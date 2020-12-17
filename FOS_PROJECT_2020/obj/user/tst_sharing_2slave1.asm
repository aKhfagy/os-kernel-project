
obj/user/tst_sharing_2slave1:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 18 02 00 00       	call   80024e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 23                	jmp    80006f <_main+0x37>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
  800051:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	c1 e2 04             	shl    $0x4,%edx
  80005d:	01 d0                	add    %edx,%eax
  80005f:	8a 40 04             	mov    0x4(%eax),%al
  800062:	84 c0                	test   %al,%al
  800064:	74 06                	je     80006c <_main+0x34>
			{
				fullWS = 0;
  800066:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006a:	eb 12                	jmp    80007e <_main+0x46>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006c:	ff 45 f0             	incl   -0x10(%ebp)
  80006f:	a1 20 30 80 00       	mov    0x803020,%eax
  800074:	8b 50 74             	mov    0x74(%eax),%edx
  800077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	77 ce                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007e:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800082:	74 14                	je     800098 <_main+0x60>
  800084:	83 ec 04             	sub    $0x4,%esp
  800087:	68 40 1d 80 00       	push   $0x801d40
  80008c:	6a 13                	push   $0x13
  80008e:	68 5c 1d 80 00       	push   $0x801d5c
  800093:	e8 fb 02 00 00       	call   800393 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  800098:	e8 84 14 00 00       	call   801521 <sys_getparentenvid>
  80009d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a0:	e8 fe 15 00 00       	call   8016a3 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000a5:	e8 29 15 00 00       	call   8015d3 <sys_calculate_free_frames>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	68 77 1d 80 00       	push   $0x801d77
  8000b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b8:	e8 3c 13 00 00       	call   8013f9 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c3:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 7c 1d 80 00       	push   $0x801d7c
  8000d4:	6a 1c                	push   $0x1c
  8000d6:	68 5c 1d 80 00       	push   $0x801d5c
  8000db:	e8 b3 02 00 00       	call   800393 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e3:	e8 eb 14 00 00       	call   8015d3 <sys_calculate_free_frames>
  8000e8:	29 c3                	sub    %eax,%ebx
  8000ea:	89 d8                	mov    %ebx,%eax
  8000ec:	83 f8 01             	cmp    $0x1,%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 dc 1d 80 00       	push   $0x801ddc
  8000f9:	6a 1d                	push   $0x1d
  8000fb:	68 5c 1d 80 00       	push   $0x801d5c
  800100:	e8 8e 02 00 00       	call   800393 <_panic>
	sys_enable_interrupt();
  800105:	e8 b3 15 00 00       	call   8016bd <sys_enable_interrupt>

	sys_disable_interrupt();
  80010a:	e8 94 15 00 00       	call   8016a3 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80010f:	e8 bf 14 00 00       	call   8015d3 <sys_calculate_free_frames>
  800114:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	68 6d 1e 80 00       	push   $0x801e6d
  80011f:	ff 75 ec             	pushl  -0x14(%ebp)
  800122:	e8 d2 12 00 00       	call   8013f9 <sget>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012d:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800134:	74 14                	je     80014a <_main+0x112>
  800136:	83 ec 04             	sub    $0x4,%esp
  800139:	68 7c 1d 80 00       	push   $0x801d7c
  80013e:	6a 23                	push   $0x23
  800140:	68 5c 1d 80 00       	push   $0x801d5c
  800145:	e8 49 02 00 00       	call   800393 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80014a:	e8 84 14 00 00       	call   8015d3 <sys_calculate_free_frames>
  80014f:	89 c2                	mov    %eax,%edx
  800151:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800154:	39 c2                	cmp    %eax,%edx
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 dc 1d 80 00       	push   $0x801ddc
  800160:	6a 24                	push   $0x24
  800162:	68 5c 1d 80 00       	push   $0x801d5c
  800167:	e8 27 02 00 00       	call   800393 <_panic>
	sys_enable_interrupt();
  80016c:	e8 4c 15 00 00       	call   8016bd <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800171:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800174:	8b 00                	mov    (%eax),%eax
  800176:	83 f8 14             	cmp    $0x14,%eax
  800179:	74 14                	je     80018f <_main+0x157>
  80017b:	83 ec 04             	sub    $0x4,%esp
  80017e:	68 70 1e 80 00       	push   $0x801e70
  800183:	6a 27                	push   $0x27
  800185:	68 5c 1d 80 00       	push   $0x801d5c
  80018a:	e8 04 02 00 00       	call   800393 <_panic>

	sys_disable_interrupt();
  80018f:	e8 0f 15 00 00       	call   8016a3 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800194:	e8 3a 14 00 00       	call   8015d3 <sys_calculate_free_frames>
  800199:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80019c:	83 ec 08             	sub    $0x8,%esp
  80019f:	68 a7 1e 80 00       	push   $0x801ea7
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	e8 4d 12 00 00       	call   8013f9 <sget>
  8001ac:	83 c4 10             	add    $0x10,%esp
  8001af:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b2:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001b9:	74 14                	je     8001cf <_main+0x197>
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	68 7c 1d 80 00       	push   $0x801d7c
  8001c3:	6a 2c                	push   $0x2c
  8001c5:	68 5c 1d 80 00       	push   $0x801d5c
  8001ca:	e8 c4 01 00 00       	call   800393 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001cf:	e8 ff 13 00 00       	call   8015d3 <sys_calculate_free_frames>
  8001d4:	89 c2                	mov    %eax,%edx
  8001d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001d9:	39 c2                	cmp    %eax,%edx
  8001db:	74 14                	je     8001f1 <_main+0x1b9>
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	68 dc 1d 80 00       	push   $0x801ddc
  8001e5:	6a 2d                	push   $0x2d
  8001e7:	68 5c 1d 80 00       	push   $0x801d5c
  8001ec:	e8 a2 01 00 00       	call   800393 <_panic>
	sys_enable_interrupt();
  8001f1:	e8 c7 14 00 00       	call   8016bd <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f9:	8b 00                	mov    (%eax),%eax
  8001fb:	83 f8 0a             	cmp    $0xa,%eax
  8001fe:	74 14                	je     800214 <_main+0x1dc>
  800200:	83 ec 04             	sub    $0x4,%esp
  800203:	68 70 1e 80 00       	push   $0x801e70
  800208:	6a 30                	push   $0x30
  80020a:	68 5c 1d 80 00       	push   $0x801d5c
  80020f:	e8 7f 01 00 00       	call   800393 <_panic>

	*z = *x + *y ;
  800214:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800217:	8b 10                	mov    (%eax),%edx
  800219:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80021c:	8b 00                	mov    (%eax),%eax
  80021e:	01 c2                	add    %eax,%edx
  800220:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800223:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800225:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800228:	8b 00                	mov    (%eax),%eax
  80022a:	83 f8 1e             	cmp    $0x1e,%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 70 1e 80 00       	push   $0x801e70
  800237:	6a 33                	push   $0x33
  800239:	68 5c 1d 80 00       	push   $0x801d5c
  80023e:	e8 50 01 00 00       	call   800393 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800243:	e8 27 17 00 00       	call   80196f <inctst>

	return;
  800248:	90                   	nop
}
  800249:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80024c:	c9                   	leave  
  80024d:	c3                   	ret    

0080024e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800254:	e8 af 12 00 00       	call   801508 <sys_getenvindex>
  800259:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80025c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80025f:	89 d0                	mov    %edx,%eax
  800261:	c1 e0 03             	shl    $0x3,%eax
  800264:	01 d0                	add    %edx,%eax
  800266:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80026d:	01 c8                	add    %ecx,%eax
  80026f:	01 c0                	add    %eax,%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	01 c0                	add    %eax,%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	89 c2                	mov    %eax,%edx
  800279:	c1 e2 05             	shl    $0x5,%edx
  80027c:	29 c2                	sub    %eax,%edx
  80027e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800285:	89 c2                	mov    %eax,%edx
  800287:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80028d:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800292:	a1 20 30 80 00       	mov    0x803020,%eax
  800297:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80029d:	84 c0                	test   %al,%al
  80029f:	74 0f                	je     8002b0 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8002a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a6:	05 40 3c 01 00       	add    $0x13c40,%eax
  8002ab:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002b4:	7e 0a                	jle    8002c0 <libmain+0x72>
		binaryname = argv[0];
  8002b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b9:	8b 00                	mov    (%eax),%eax
  8002bb:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8002c0:	83 ec 08             	sub    $0x8,%esp
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	e8 6a fd ff ff       	call   800038 <_main>
  8002ce:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002d1:	e8 cd 13 00 00       	call   8016a3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	68 c4 1e 80 00       	push   $0x801ec4
  8002de:	e8 52 03 00 00       	call   800635 <cprintf>
  8002e3:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002eb:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8002f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f6:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8002fc:	83 ec 04             	sub    $0x4,%esp
  8002ff:	52                   	push   %edx
  800300:	50                   	push   %eax
  800301:	68 ec 1e 80 00       	push   $0x801eec
  800306:	e8 2a 03 00 00       	call   800635 <cprintf>
  80030b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80030e:	a1 20 30 80 00       	mov    0x803020,%eax
  800313:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800319:	a1 20 30 80 00       	mov    0x803020,%eax
  80031e:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800324:	83 ec 04             	sub    $0x4,%esp
  800327:	52                   	push   %edx
  800328:	50                   	push   %eax
  800329:	68 14 1f 80 00       	push   $0x801f14
  80032e:	e8 02 03 00 00       	call   800635 <cprintf>
  800333:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800336:	a1 20 30 80 00       	mov    0x803020,%eax
  80033b:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	50                   	push   %eax
  800345:	68 55 1f 80 00       	push   $0x801f55
  80034a:	e8 e6 02 00 00       	call   800635 <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	68 c4 1e 80 00       	push   $0x801ec4
  80035a:	e8 d6 02 00 00       	call   800635 <cprintf>
  80035f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800362:	e8 56 13 00 00       	call   8016bd <sys_enable_interrupt>

	// exit gracefully
	exit();
  800367:	e8 19 00 00 00       	call   800385 <exit>
}
  80036c:	90                   	nop
  80036d:	c9                   	leave  
  80036e:	c3                   	ret    

0080036f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
  800372:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800375:	83 ec 0c             	sub    $0xc,%esp
  800378:	6a 00                	push   $0x0
  80037a:	e8 55 11 00 00       	call   8014d4 <sys_env_destroy>
  80037f:	83 c4 10             	add    $0x10,%esp
}
  800382:	90                   	nop
  800383:	c9                   	leave  
  800384:	c3                   	ret    

00800385 <exit>:

void
exit(void)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80038b:	e8 aa 11 00 00       	call   80153a <sys_env_exit>
}
  800390:	90                   	nop
  800391:	c9                   	leave  
  800392:	c3                   	ret    

00800393 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800399:	8d 45 10             	lea    0x10(%ebp),%eax
  80039c:	83 c0 04             	add    $0x4,%eax
  80039f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003a2:	a1 18 31 80 00       	mov    0x803118,%eax
  8003a7:	85 c0                	test   %eax,%eax
  8003a9:	74 16                	je     8003c1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003ab:	a1 18 31 80 00       	mov    0x803118,%eax
  8003b0:	83 ec 08             	sub    $0x8,%esp
  8003b3:	50                   	push   %eax
  8003b4:	68 6c 1f 80 00       	push   $0x801f6c
  8003b9:	e8 77 02 00 00       	call   800635 <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003c1:	a1 00 30 80 00       	mov    0x803000,%eax
  8003c6:	ff 75 0c             	pushl  0xc(%ebp)
  8003c9:	ff 75 08             	pushl  0x8(%ebp)
  8003cc:	50                   	push   %eax
  8003cd:	68 71 1f 80 00       	push   $0x801f71
  8003d2:	e8 5e 02 00 00       	call   800635 <cprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003da:	8b 45 10             	mov    0x10(%ebp),%eax
  8003dd:	83 ec 08             	sub    $0x8,%esp
  8003e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e3:	50                   	push   %eax
  8003e4:	e8 e1 01 00 00       	call   8005ca <vcprintf>
  8003e9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003ec:	83 ec 08             	sub    $0x8,%esp
  8003ef:	6a 00                	push   $0x0
  8003f1:	68 8d 1f 80 00       	push   $0x801f8d
  8003f6:	e8 cf 01 00 00       	call   8005ca <vcprintf>
  8003fb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003fe:	e8 82 ff ff ff       	call   800385 <exit>

	// should not return here
	while (1) ;
  800403:	eb fe                	jmp    800403 <_panic+0x70>

00800405 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
  800408:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80040b:	a1 20 30 80 00       	mov    0x803020,%eax
  800410:	8b 50 74             	mov    0x74(%eax),%edx
  800413:	8b 45 0c             	mov    0xc(%ebp),%eax
  800416:	39 c2                	cmp    %eax,%edx
  800418:	74 14                	je     80042e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80041a:	83 ec 04             	sub    $0x4,%esp
  80041d:	68 90 1f 80 00       	push   $0x801f90
  800422:	6a 26                	push   $0x26
  800424:	68 dc 1f 80 00       	push   $0x801fdc
  800429:	e8 65 ff ff ff       	call   800393 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800435:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80043c:	e9 b6 00 00 00       	jmp    8004f7 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800444:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	01 d0                	add    %edx,%eax
  800450:	8b 00                	mov    (%eax),%eax
  800452:	85 c0                	test   %eax,%eax
  800454:	75 08                	jne    80045e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800456:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800459:	e9 96 00 00 00       	jmp    8004f4 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80045e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800465:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80046c:	eb 5d                	jmp    8004cb <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046e:	a1 20 30 80 00       	mov    0x803020,%eax
  800473:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800479:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80047c:	c1 e2 04             	shl    $0x4,%edx
  80047f:	01 d0                	add    %edx,%eax
  800481:	8a 40 04             	mov    0x4(%eax),%al
  800484:	84 c0                	test   %al,%al
  800486:	75 40                	jne    8004c8 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800488:	a1 20 30 80 00       	mov    0x803020,%eax
  80048d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800493:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800496:	c1 e2 04             	shl    $0x4,%edx
  800499:	01 d0                	add    %edx,%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004a8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	01 c8                	add    %ecx,%eax
  8004b9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004bb:	39 c2                	cmp    %eax,%edx
  8004bd:	75 09                	jne    8004c8 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8004bf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004c6:	eb 12                	jmp    8004da <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c8:	ff 45 e8             	incl   -0x18(%ebp)
  8004cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d0:	8b 50 74             	mov    0x74(%eax),%edx
  8004d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004d6:	39 c2                	cmp    %eax,%edx
  8004d8:	77 94                	ja     80046e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004de:	75 14                	jne    8004f4 <CheckWSWithoutLastIndex+0xef>
			panic(
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	68 e8 1f 80 00       	push   $0x801fe8
  8004e8:	6a 3a                	push   $0x3a
  8004ea:	68 dc 1f 80 00       	push   $0x801fdc
  8004ef:	e8 9f fe ff ff       	call   800393 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004f4:	ff 45 f0             	incl   -0x10(%ebp)
  8004f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004fd:	0f 8c 3e ff ff ff    	jl     800441 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800503:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80050a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800511:	eb 20                	jmp    800533 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800513:	a1 20 30 80 00       	mov    0x803020,%eax
  800518:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80051e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800521:	c1 e2 04             	shl    $0x4,%edx
  800524:	01 d0                	add    %edx,%eax
  800526:	8a 40 04             	mov    0x4(%eax),%al
  800529:	3c 01                	cmp    $0x1,%al
  80052b:	75 03                	jne    800530 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80052d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800530:	ff 45 e0             	incl   -0x20(%ebp)
  800533:	a1 20 30 80 00       	mov    0x803020,%eax
  800538:	8b 50 74             	mov    0x74(%eax),%edx
  80053b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	77 d1                	ja     800513 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800545:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800548:	74 14                	je     80055e <CheckWSWithoutLastIndex+0x159>
		panic(
  80054a:	83 ec 04             	sub    $0x4,%esp
  80054d:	68 3c 20 80 00       	push   $0x80203c
  800552:	6a 44                	push   $0x44
  800554:	68 dc 1f 80 00       	push   $0x801fdc
  800559:	e8 35 fe ff ff       	call   800393 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80055e:	90                   	nop
  80055f:	c9                   	leave  
  800560:	c3                   	ret    

00800561 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800561:	55                   	push   %ebp
  800562:	89 e5                	mov    %esp,%ebp
  800564:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	8d 48 01             	lea    0x1(%eax),%ecx
  80056f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800572:	89 0a                	mov    %ecx,(%edx)
  800574:	8b 55 08             	mov    0x8(%ebp),%edx
  800577:	88 d1                	mov    %dl,%cl
  800579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80057c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800580:	8b 45 0c             	mov    0xc(%ebp),%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	3d ff 00 00 00       	cmp    $0xff,%eax
  80058a:	75 2c                	jne    8005b8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80058c:	a0 24 30 80 00       	mov    0x803024,%al
  800591:	0f b6 c0             	movzbl %al,%eax
  800594:	8b 55 0c             	mov    0xc(%ebp),%edx
  800597:	8b 12                	mov    (%edx),%edx
  800599:	89 d1                	mov    %edx,%ecx
  80059b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059e:	83 c2 08             	add    $0x8,%edx
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	50                   	push   %eax
  8005a5:	51                   	push   %ecx
  8005a6:	52                   	push   %edx
  8005a7:	e8 e6 0e 00 00       	call   801492 <sys_cputs>
  8005ac:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bb:	8b 40 04             	mov    0x4(%eax),%eax
  8005be:	8d 50 01             	lea    0x1(%eax),%edx
  8005c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005c7:	90                   	nop
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

008005ca <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005da:	00 00 00 
	b.cnt = 0;
  8005dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005e4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 08             	pushl  0x8(%ebp)
  8005ed:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005f3:	50                   	push   %eax
  8005f4:	68 61 05 80 00       	push   $0x800561
  8005f9:	e8 11 02 00 00       	call   80080f <vprintfmt>
  8005fe:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800601:	a0 24 30 80 00       	mov    0x803024,%al
  800606:	0f b6 c0             	movzbl %al,%eax
  800609:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	50                   	push   %eax
  800613:	52                   	push   %edx
  800614:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80061a:	83 c0 08             	add    $0x8,%eax
  80061d:	50                   	push   %eax
  80061e:	e8 6f 0e 00 00       	call   801492 <sys_cputs>
  800623:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800626:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80062d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800633:	c9                   	leave  
  800634:	c3                   	ret    

00800635 <cprintf>:

int cprintf(const char *fmt, ...) {
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
  800638:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80063b:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800642:	8d 45 0c             	lea    0xc(%ebp),%eax
  800645:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	ff 75 f4             	pushl  -0xc(%ebp)
  800651:	50                   	push   %eax
  800652:	e8 73 ff ff ff       	call   8005ca <vcprintf>
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80065d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800660:	c9                   	leave  
  800661:	c3                   	ret    

00800662 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800662:	55                   	push   %ebp
  800663:	89 e5                	mov    %esp,%ebp
  800665:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800668:	e8 36 10 00 00       	call   8016a3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80066d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800670:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800673:	8b 45 08             	mov    0x8(%ebp),%eax
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	ff 75 f4             	pushl  -0xc(%ebp)
  80067c:	50                   	push   %eax
  80067d:	e8 48 ff ff ff       	call   8005ca <vcprintf>
  800682:	83 c4 10             	add    $0x10,%esp
  800685:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800688:	e8 30 10 00 00       	call   8016bd <sys_enable_interrupt>
	return cnt;
  80068d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800690:	c9                   	leave  
  800691:	c3                   	ret    

00800692 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800692:	55                   	push   %ebp
  800693:	89 e5                	mov    %esp,%ebp
  800695:	53                   	push   %ebx
  800696:	83 ec 14             	sub    $0x14,%esp
  800699:	8b 45 10             	mov    0x10(%ebp),%eax
  80069c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ad:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b0:	77 55                	ja     800707 <printnum+0x75>
  8006b2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b5:	72 05                	jb     8006bc <printnum+0x2a>
  8006b7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006ba:	77 4b                	ja     800707 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006bc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006bf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006c2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ca:	52                   	push   %edx
  8006cb:	50                   	push   %eax
  8006cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8006d2:	e8 ed 13 00 00       	call   801ac4 <__udivdi3>
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	ff 75 20             	pushl  0x20(%ebp)
  8006e0:	53                   	push   %ebx
  8006e1:	ff 75 18             	pushl  0x18(%ebp)
  8006e4:	52                   	push   %edx
  8006e5:	50                   	push   %eax
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	e8 a1 ff ff ff       	call   800692 <printnum>
  8006f1:	83 c4 20             	add    $0x20,%esp
  8006f4:	eb 1a                	jmp    800710 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	ff 75 20             	pushl  0x20(%ebp)
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	ff d0                	call   *%eax
  800704:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800707:	ff 4d 1c             	decl   0x1c(%ebp)
  80070a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80070e:	7f e6                	jg     8006f6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800710:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800713:	bb 00 00 00 00       	mov    $0x0,%ebx
  800718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071e:	53                   	push   %ebx
  80071f:	51                   	push   %ecx
  800720:	52                   	push   %edx
  800721:	50                   	push   %eax
  800722:	e8 ad 14 00 00       	call   801bd4 <__umoddi3>
  800727:	83 c4 10             	add    $0x10,%esp
  80072a:	05 b4 22 80 00       	add    $0x8022b4,%eax
  80072f:	8a 00                	mov    (%eax),%al
  800731:	0f be c0             	movsbl %al,%eax
  800734:	83 ec 08             	sub    $0x8,%esp
  800737:	ff 75 0c             	pushl  0xc(%ebp)
  80073a:	50                   	push   %eax
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	ff d0                	call   *%eax
  800740:	83 c4 10             	add    $0x10,%esp
}
  800743:	90                   	nop
  800744:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800747:	c9                   	leave  
  800748:	c3                   	ret    

00800749 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800749:	55                   	push   %ebp
  80074a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80074c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800750:	7e 1c                	jle    80076e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	8d 50 08             	lea    0x8(%eax),%edx
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	89 10                	mov    %edx,(%eax)
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	83 e8 08             	sub    $0x8,%eax
  800767:	8b 50 04             	mov    0x4(%eax),%edx
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	eb 40                	jmp    8007ae <getuint+0x65>
	else if (lflag)
  80076e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800772:	74 1e                	je     800792 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	8d 50 04             	lea    0x4(%eax),%edx
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	89 10                	mov    %edx,(%eax)
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	83 e8 04             	sub    $0x4,%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	ba 00 00 00 00       	mov    $0x0,%edx
  800790:	eb 1c                	jmp    8007ae <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800792:	8b 45 08             	mov    0x8(%ebp),%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	8d 50 04             	lea    0x4(%eax),%edx
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	89 10                	mov    %edx,(%eax)
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	83 e8 04             	sub    $0x4,%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ae:	5d                   	pop    %ebp
  8007af:	c3                   	ret    

008007b0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b7:	7e 1c                	jle    8007d5 <getint+0x25>
		return va_arg(*ap, long long);
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	8d 50 08             	lea    0x8(%eax),%edx
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	89 10                	mov    %edx,(%eax)
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	83 e8 08             	sub    $0x8,%eax
  8007ce:	8b 50 04             	mov    0x4(%eax),%edx
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	eb 38                	jmp    80080d <getint+0x5d>
	else if (lflag)
  8007d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d9:	74 1a                	je     8007f5 <getint+0x45>
		return va_arg(*ap, long);
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	8d 50 04             	lea    0x4(%eax),%edx
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	89 10                	mov    %edx,(%eax)
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	83 e8 04             	sub    $0x4,%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	99                   	cltd   
  8007f3:	eb 18                	jmp    80080d <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	8b 00                	mov    (%eax),%eax
  8007fa:	8d 50 04             	lea    0x4(%eax),%edx
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	89 10                	mov    %edx,(%eax)
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	8b 00                	mov    (%eax),%eax
  800807:	83 e8 04             	sub    $0x4,%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	99                   	cltd   
}
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	56                   	push   %esi
  800813:	53                   	push   %ebx
  800814:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800817:	eb 17                	jmp    800830 <vprintfmt+0x21>
			if (ch == '\0')
  800819:	85 db                	test   %ebx,%ebx
  80081b:	0f 84 af 03 00 00    	je     800bd0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	53                   	push   %ebx
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800830:	8b 45 10             	mov    0x10(%ebp),%eax
  800833:	8d 50 01             	lea    0x1(%eax),%edx
  800836:	89 55 10             	mov    %edx,0x10(%ebp)
  800839:	8a 00                	mov    (%eax),%al
  80083b:	0f b6 d8             	movzbl %al,%ebx
  80083e:	83 fb 25             	cmp    $0x25,%ebx
  800841:	75 d6                	jne    800819 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800843:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800847:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80084e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800855:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80085c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800863:	8b 45 10             	mov    0x10(%ebp),%eax
  800866:	8d 50 01             	lea    0x1(%eax),%edx
  800869:	89 55 10             	mov    %edx,0x10(%ebp)
  80086c:	8a 00                	mov    (%eax),%al
  80086e:	0f b6 d8             	movzbl %al,%ebx
  800871:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800874:	83 f8 55             	cmp    $0x55,%eax
  800877:	0f 87 2b 03 00 00    	ja     800ba8 <vprintfmt+0x399>
  80087d:	8b 04 85 d8 22 80 00 	mov    0x8022d8(,%eax,4),%eax
  800884:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800886:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80088a:	eb d7                	jmp    800863 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80088c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800890:	eb d1                	jmp    800863 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800892:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800899:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80089c:	89 d0                	mov    %edx,%eax
  80089e:	c1 e0 02             	shl    $0x2,%eax
  8008a1:	01 d0                	add    %edx,%eax
  8008a3:	01 c0                	add    %eax,%eax
  8008a5:	01 d8                	add    %ebx,%eax
  8008a7:	83 e8 30             	sub    $0x30,%eax
  8008aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b0:	8a 00                	mov    (%eax),%al
  8008b2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008b5:	83 fb 2f             	cmp    $0x2f,%ebx
  8008b8:	7e 3e                	jle    8008f8 <vprintfmt+0xe9>
  8008ba:	83 fb 39             	cmp    $0x39,%ebx
  8008bd:	7f 39                	jg     8008f8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008bf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008c2:	eb d5                	jmp    800899 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	83 c0 04             	add    $0x4,%eax
  8008ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	83 e8 04             	sub    $0x4,%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008d8:	eb 1f                	jmp    8008f9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008de:	79 83                	jns    800863 <vprintfmt+0x54>
				width = 0;
  8008e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008e7:	e9 77 ff ff ff       	jmp    800863 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008ec:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008f3:	e9 6b ff ff ff       	jmp    800863 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008f8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fd:	0f 89 60 ff ff ff    	jns    800863 <vprintfmt+0x54>
				width = precision, precision = -1;
  800903:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800906:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800909:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800910:	e9 4e ff ff ff       	jmp    800863 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800915:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800918:	e9 46 ff ff ff       	jmp    800863 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	83 c0 04             	add    $0x4,%eax
  800923:	89 45 14             	mov    %eax,0x14(%ebp)
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	83 e8 04             	sub    $0x4,%eax
  80092c:	8b 00                	mov    (%eax),%eax
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	ff 75 0c             	pushl  0xc(%ebp)
  800934:	50                   	push   %eax
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	ff d0                	call   *%eax
  80093a:	83 c4 10             	add    $0x10,%esp
			break;
  80093d:	e9 89 02 00 00       	jmp    800bcb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	83 c0 04             	add    $0x4,%eax
  800948:	89 45 14             	mov    %eax,0x14(%ebp)
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	83 e8 04             	sub    $0x4,%eax
  800951:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800953:	85 db                	test   %ebx,%ebx
  800955:	79 02                	jns    800959 <vprintfmt+0x14a>
				err = -err;
  800957:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800959:	83 fb 64             	cmp    $0x64,%ebx
  80095c:	7f 0b                	jg     800969 <vprintfmt+0x15a>
  80095e:	8b 34 9d 20 21 80 00 	mov    0x802120(,%ebx,4),%esi
  800965:	85 f6                	test   %esi,%esi
  800967:	75 19                	jne    800982 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800969:	53                   	push   %ebx
  80096a:	68 c5 22 80 00       	push   $0x8022c5
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	ff 75 08             	pushl  0x8(%ebp)
  800975:	e8 5e 02 00 00       	call   800bd8 <printfmt>
  80097a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80097d:	e9 49 02 00 00       	jmp    800bcb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800982:	56                   	push   %esi
  800983:	68 ce 22 80 00       	push   $0x8022ce
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	ff 75 08             	pushl  0x8(%ebp)
  80098e:	e8 45 02 00 00       	call   800bd8 <printfmt>
  800993:	83 c4 10             	add    $0x10,%esp
			break;
  800996:	e9 30 02 00 00       	jmp    800bcb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80099b:	8b 45 14             	mov    0x14(%ebp),%eax
  80099e:	83 c0 04             	add    $0x4,%eax
  8009a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	83 e8 04             	sub    $0x4,%eax
  8009aa:	8b 30                	mov    (%eax),%esi
  8009ac:	85 f6                	test   %esi,%esi
  8009ae:	75 05                	jne    8009b5 <vprintfmt+0x1a6>
				p = "(null)";
  8009b0:	be d1 22 80 00       	mov    $0x8022d1,%esi
			if (width > 0 && padc != '-')
  8009b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b9:	7e 6d                	jle    800a28 <vprintfmt+0x219>
  8009bb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009bf:	74 67                	je     800a28 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	50                   	push   %eax
  8009c8:	56                   	push   %esi
  8009c9:	e8 0c 03 00 00       	call   800cda <strnlen>
  8009ce:	83 c4 10             	add    $0x10,%esp
  8009d1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009d4:	eb 16                	jmp    8009ec <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009d6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	50                   	push   %eax
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	ff d0                	call   *%eax
  8009e6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f0:	7f e4                	jg     8009d6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f2:	eb 34                	jmp    800a28 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009f8:	74 1c                	je     800a16 <vprintfmt+0x207>
  8009fa:	83 fb 1f             	cmp    $0x1f,%ebx
  8009fd:	7e 05                	jle    800a04 <vprintfmt+0x1f5>
  8009ff:	83 fb 7e             	cmp    $0x7e,%ebx
  800a02:	7e 12                	jle    800a16 <vprintfmt+0x207>
					putch('?', putdat);
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	6a 3f                	push   $0x3f
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	ff d0                	call   *%eax
  800a11:	83 c4 10             	add    $0x10,%esp
  800a14:	eb 0f                	jmp    800a25 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	53                   	push   %ebx
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	ff d0                	call   *%eax
  800a22:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a25:	ff 4d e4             	decl   -0x1c(%ebp)
  800a28:	89 f0                	mov    %esi,%eax
  800a2a:	8d 70 01             	lea    0x1(%eax),%esi
  800a2d:	8a 00                	mov    (%eax),%al
  800a2f:	0f be d8             	movsbl %al,%ebx
  800a32:	85 db                	test   %ebx,%ebx
  800a34:	74 24                	je     800a5a <vprintfmt+0x24b>
  800a36:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a3a:	78 b8                	js     8009f4 <vprintfmt+0x1e5>
  800a3c:	ff 4d e0             	decl   -0x20(%ebp)
  800a3f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a43:	79 af                	jns    8009f4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a45:	eb 13                	jmp    800a5a <vprintfmt+0x24b>
				putch(' ', putdat);
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	6a 20                	push   $0x20
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	ff d0                	call   *%eax
  800a54:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a57:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5e:	7f e7                	jg     800a47 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a60:	e9 66 01 00 00       	jmp    800bcb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 e8             	pushl  -0x18(%ebp)
  800a6b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6e:	50                   	push   %eax
  800a6f:	e8 3c fd ff ff       	call   8007b0 <getint>
  800a74:	83 c4 10             	add    $0x10,%esp
  800a77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a83:	85 d2                	test   %edx,%edx
  800a85:	79 23                	jns    800aaa <vprintfmt+0x29b>
				putch('-', putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	6a 2d                	push   $0x2d
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9d:	f7 d8                	neg    %eax
  800a9f:	83 d2 00             	adc    $0x0,%edx
  800aa2:	f7 da                	neg    %edx
  800aa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aaa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ab1:	e9 bc 00 00 00       	jmp    800b72 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ab6:	83 ec 08             	sub    $0x8,%esp
  800ab9:	ff 75 e8             	pushl  -0x18(%ebp)
  800abc:	8d 45 14             	lea    0x14(%ebp),%eax
  800abf:	50                   	push   %eax
  800ac0:	e8 84 fc ff ff       	call   800749 <getuint>
  800ac5:	83 c4 10             	add    $0x10,%esp
  800ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800acb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ace:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad5:	e9 98 00 00 00       	jmp    800b72 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	6a 58                	push   $0x58
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
  800ae7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	ff 75 0c             	pushl  0xc(%ebp)
  800af0:	6a 58                	push   $0x58
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	ff d0                	call   *%eax
  800af7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	6a 58                	push   $0x58
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
			break;
  800b0a:	e9 bc 00 00 00       	jmp    800bcb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b0f:	83 ec 08             	sub    $0x8,%esp
  800b12:	ff 75 0c             	pushl  0xc(%ebp)
  800b15:	6a 30                	push   $0x30
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	ff d0                	call   *%eax
  800b1c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	6a 78                	push   $0x78
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	ff d0                	call   *%eax
  800b2c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b32:	83 c0 04             	add    $0x4,%eax
  800b35:	89 45 14             	mov    %eax,0x14(%ebp)
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	83 e8 04             	sub    $0x4,%eax
  800b3e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b4a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b51:	eb 1f                	jmp    800b72 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 e8             	pushl  -0x18(%ebp)
  800b59:	8d 45 14             	lea    0x14(%ebp),%eax
  800b5c:	50                   	push   %eax
  800b5d:	e8 e7 fb ff ff       	call   800749 <getuint>
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b6b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b72:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b79:	83 ec 04             	sub    $0x4,%esp
  800b7c:	52                   	push   %edx
  800b7d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b80:	50                   	push   %eax
  800b81:	ff 75 f4             	pushl  -0xc(%ebp)
  800b84:	ff 75 f0             	pushl  -0x10(%ebp)
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	ff 75 08             	pushl  0x8(%ebp)
  800b8d:	e8 00 fb ff ff       	call   800692 <printnum>
  800b92:	83 c4 20             	add    $0x20,%esp
			break;
  800b95:	eb 34                	jmp    800bcb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b97:	83 ec 08             	sub    $0x8,%esp
  800b9a:	ff 75 0c             	pushl  0xc(%ebp)
  800b9d:	53                   	push   %ebx
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	ff d0                	call   *%eax
  800ba3:	83 c4 10             	add    $0x10,%esp
			break;
  800ba6:	eb 23                	jmp    800bcb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba8:	83 ec 08             	sub    $0x8,%esp
  800bab:	ff 75 0c             	pushl  0xc(%ebp)
  800bae:	6a 25                	push   $0x25
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	ff d0                	call   *%eax
  800bb5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb8:	ff 4d 10             	decl   0x10(%ebp)
  800bbb:	eb 03                	jmp    800bc0 <vprintfmt+0x3b1>
  800bbd:	ff 4d 10             	decl   0x10(%ebp)
  800bc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc3:	48                   	dec    %eax
  800bc4:	8a 00                	mov    (%eax),%al
  800bc6:	3c 25                	cmp    $0x25,%al
  800bc8:	75 f3                	jne    800bbd <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bca:	90                   	nop
		}
	}
  800bcb:	e9 47 fc ff ff       	jmp    800817 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bd0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bd1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bde:	8d 45 10             	lea    0x10(%ebp),%eax
  800be1:	83 c0 04             	add    $0x4,%eax
  800be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	ff 75 f4             	pushl  -0xc(%ebp)
  800bed:	50                   	push   %eax
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	ff 75 08             	pushl  0x8(%ebp)
  800bf4:	e8 16 fc ff ff       	call   80080f <vprintfmt>
  800bf9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bfc:	90                   	nop
  800bfd:	c9                   	leave  
  800bfe:	c3                   	ret    

00800bff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c05:	8b 40 08             	mov    0x8(%eax),%eax
  800c08:	8d 50 01             	lea    0x1(%eax),%edx
  800c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	8b 10                	mov    (%eax),%edx
  800c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c19:	8b 40 04             	mov    0x4(%eax),%eax
  800c1c:	39 c2                	cmp    %eax,%edx
  800c1e:	73 12                	jae    800c32 <sprintputch+0x33>
		*b->buf++ = ch;
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 00                	mov    (%eax),%eax
  800c25:	8d 48 01             	lea    0x1(%eax),%ecx
  800c28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2b:	89 0a                	mov    %ecx,(%edx)
  800c2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c30:	88 10                	mov    %dl,(%eax)
}
  800c32:	90                   	nop
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c44:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	01 d0                	add    %edx,%eax
  800c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c5a:	74 06                	je     800c62 <vsnprintf+0x2d>
  800c5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c60:	7f 07                	jg     800c69 <vsnprintf+0x34>
		return -E_INVAL;
  800c62:	b8 03 00 00 00       	mov    $0x3,%eax
  800c67:	eb 20                	jmp    800c89 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c69:	ff 75 14             	pushl  0x14(%ebp)
  800c6c:	ff 75 10             	pushl  0x10(%ebp)
  800c6f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c72:	50                   	push   %eax
  800c73:	68 ff 0b 80 00       	push   $0x800bff
  800c78:	e8 92 fb ff ff       	call   80080f <vprintfmt>
  800c7d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c83:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c89:	c9                   	leave  
  800c8a:	c3                   	ret    

00800c8b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c91:	8d 45 10             	lea    0x10(%ebp),%eax
  800c94:	83 c0 04             	add    $0x4,%eax
  800c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca0:	50                   	push   %eax
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	ff 75 08             	pushl  0x8(%ebp)
  800ca7:	e8 89 ff ff ff       	call   800c35 <vsnprintf>
  800cac:	83 c4 10             	add    $0x10,%esp
  800caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb5:	c9                   	leave  
  800cb6:	c3                   	ret    

00800cb7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc4:	eb 06                	jmp    800ccc <strlen+0x15>
		n++;
  800cc6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc9:	ff 45 08             	incl   0x8(%ebp)
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	84 c0                	test   %al,%al
  800cd3:	75 f1                	jne    800cc6 <strlen+0xf>
		n++;
	return n;
  800cd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd8:	c9                   	leave  
  800cd9:	c3                   	ret    

00800cda <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce7:	eb 09                	jmp    800cf2 <strnlen+0x18>
		n++;
  800ce9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cec:	ff 45 08             	incl   0x8(%ebp)
  800cef:	ff 4d 0c             	decl   0xc(%ebp)
  800cf2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf6:	74 09                	je     800d01 <strnlen+0x27>
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	84 c0                	test   %al,%al
  800cff:	75 e8                	jne    800ce9 <strnlen+0xf>
		n++;
	return n;
  800d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d12:	90                   	nop
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8d 50 01             	lea    0x1(%eax),%edx
  800d19:	89 55 08             	mov    %edx,0x8(%ebp)
  800d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d22:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d25:	8a 12                	mov    (%edx),%dl
  800d27:	88 10                	mov    %dl,(%eax)
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	84 c0                	test   %al,%al
  800d2d:	75 e4                	jne    800d13 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d32:	c9                   	leave  
  800d33:	c3                   	ret    

00800d34 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d47:	eb 1f                	jmp    800d68 <strncpy+0x34>
		*dst++ = *src;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8d 50 01             	lea    0x1(%eax),%edx
  800d4f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d55:	8a 12                	mov    (%edx),%dl
  800d57:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	84 c0                	test   %al,%al
  800d60:	74 03                	je     800d65 <strncpy+0x31>
			src++;
  800d62:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d65:	ff 45 fc             	incl   -0x4(%ebp)
  800d68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d6e:	72 d9                	jb     800d49 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d70:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d73:	c9                   	leave  
  800d74:	c3                   	ret    

00800d75 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d85:	74 30                	je     800db7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d87:	eb 16                	jmp    800d9f <strlcpy+0x2a>
			*dst++ = *src++;
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8d 50 01             	lea    0x1(%eax),%edx
  800d8f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d95:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d98:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d9b:	8a 12                	mov    (%edx),%dl
  800d9d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d9f:	ff 4d 10             	decl   0x10(%ebp)
  800da2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da6:	74 09                	je     800db1 <strlcpy+0x3c>
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	84 c0                	test   %al,%al
  800daf:	75 d8                	jne    800d89 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800db7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbd:	29 c2                	sub    %eax,%edx
  800dbf:	89 d0                	mov    %edx,%eax
}
  800dc1:	c9                   	leave  
  800dc2:	c3                   	ret    

00800dc3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dc6:	eb 06                	jmp    800dce <strcmp+0xb>
		p++, q++;
  800dc8:	ff 45 08             	incl   0x8(%ebp)
  800dcb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	84 c0                	test   %al,%al
  800dd5:	74 0e                	je     800de5 <strcmp+0x22>
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 10                	mov    (%eax),%dl
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	38 c2                	cmp    %al,%dl
  800de3:	74 e3                	je     800dc8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f b6 d0             	movzbl %al,%edx
  800ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	0f b6 c0             	movzbl %al,%eax
  800df5:	29 c2                	sub    %eax,%edx
  800df7:	89 d0                	mov    %edx,%eax
}
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dfe:	eb 09                	jmp    800e09 <strncmp+0xe>
		n--, p++, q++;
  800e00:	ff 4d 10             	decl   0x10(%ebp)
  800e03:	ff 45 08             	incl   0x8(%ebp)
  800e06:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0d:	74 17                	je     800e26 <strncmp+0x2b>
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	84 c0                	test   %al,%al
  800e16:	74 0e                	je     800e26 <strncmp+0x2b>
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8a 10                	mov    (%eax),%dl
  800e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	38 c2                	cmp    %al,%dl
  800e24:	74 da                	je     800e00 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2a:	75 07                	jne    800e33 <strncmp+0x38>
		return 0;
  800e2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e31:	eb 14                	jmp    800e47 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	0f b6 d0             	movzbl %al,%edx
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	0f b6 c0             	movzbl %al,%eax
  800e43:	29 c2                	sub    %eax,%edx
  800e45:	89 d0                	mov    %edx,%eax
}
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 04             	sub    $0x4,%esp
  800e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e52:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e55:	eb 12                	jmp    800e69 <strchr+0x20>
		if (*s == c)
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e5f:	75 05                	jne    800e66 <strchr+0x1d>
			return (char *) s;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	eb 11                	jmp    800e77 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e66:	ff 45 08             	incl   0x8(%ebp)
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 e5                	jne    800e57 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 04             	sub    $0x4,%esp
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e85:	eb 0d                	jmp    800e94 <strfind+0x1b>
		if (*s == c)
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e8f:	74 0e                	je     800e9f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e91:	ff 45 08             	incl   0x8(%ebp)
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	84 c0                	test   %al,%al
  800e9b:	75 ea                	jne    800e87 <strfind+0xe>
  800e9d:	eb 01                	jmp    800ea0 <strfind+0x27>
		if (*s == c)
			break;
  800e9f:	90                   	nop
	return (char *) s;
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800eb7:	eb 0e                	jmp    800ec7 <memset+0x22>
		*p++ = c;
  800eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebc:	8d 50 01             	lea    0x1(%eax),%edx
  800ebf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ec7:	ff 4d f8             	decl   -0x8(%ebp)
  800eca:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ece:	79 e9                	jns    800eb9 <memset+0x14>
		*p++ = c;

	return v;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed3:	c9                   	leave  
  800ed4:	c3                   	ret    

00800ed5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ede:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ee7:	eb 16                	jmp    800eff <memcpy+0x2a>
		*d++ = *s++;
  800ee9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eec:	8d 50 01             	lea    0x1(%eax),%edx
  800eef:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ef2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ef5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800efb:	8a 12                	mov    (%edx),%dl
  800efd:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f05:	89 55 10             	mov    %edx,0x10(%ebp)
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	75 dd                	jne    800ee9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0f:	c9                   	leave  
  800f10:	c3                   	ret    

00800f11 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f26:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f29:	73 50                	jae    800f7b <memmove+0x6a>
  800f2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f31:	01 d0                	add    %edx,%eax
  800f33:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f36:	76 43                	jbe    800f7b <memmove+0x6a>
		s += n;
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f41:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f44:	eb 10                	jmp    800f56 <memmove+0x45>
			*--d = *--s;
  800f46:	ff 4d f8             	decl   -0x8(%ebp)
  800f49:	ff 4d fc             	decl   -0x4(%ebp)
  800f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4f:	8a 10                	mov    (%eax),%dl
  800f51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f54:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f56:	8b 45 10             	mov    0x10(%ebp),%eax
  800f59:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f5c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5f:	85 c0                	test   %eax,%eax
  800f61:	75 e3                	jne    800f46 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f63:	eb 23                	jmp    800f88 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f68:	8d 50 01             	lea    0x1(%eax),%edx
  800f6b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f71:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f74:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f77:	8a 12                	mov    (%edx),%dl
  800f79:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f81:	89 55 10             	mov    %edx,0x10(%ebp)
  800f84:	85 c0                	test   %eax,%eax
  800f86:	75 dd                	jne    800f65 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8b:	c9                   	leave  
  800f8c:	c3                   	ret    

00800f8d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f9f:	eb 2a                	jmp    800fcb <memcmp+0x3e>
		if (*s1 != *s2)
  800fa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa4:	8a 10                	mov    (%eax),%dl
  800fa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	38 c2                	cmp    %al,%dl
  800fad:	74 16                	je     800fc5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800faf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	0f b6 d0             	movzbl %al,%edx
  800fb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	0f b6 c0             	movzbl %al,%eax
  800fbf:	29 c2                	sub    %eax,%edx
  800fc1:	89 d0                	mov    %edx,%eax
  800fc3:	eb 18                	jmp    800fdd <memcmp+0x50>
		s1++, s2++;
  800fc5:	ff 45 fc             	incl   -0x4(%ebp)
  800fc8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fce:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd1:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	75 c9                	jne    800fa1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  800feb:	01 d0                	add    %edx,%eax
  800fed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ff0:	eb 15                	jmp    801007 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	0f b6 d0             	movzbl %al,%edx
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	0f b6 c0             	movzbl %al,%eax
  801000:	39 c2                	cmp    %eax,%edx
  801002:	74 0d                	je     801011 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801004:	ff 45 08             	incl   0x8(%ebp)
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80100d:	72 e3                	jb     800ff2 <memfind+0x13>
  80100f:	eb 01                	jmp    801012 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801011:	90                   	nop
	return (void *) s;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80101d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801024:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80102b:	eb 03                	jmp    801030 <strtol+0x19>
		s++;
  80102d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 20                	cmp    $0x20,%al
  801037:	74 f4                	je     80102d <strtol+0x16>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 09                	cmp    $0x9,%al
  801040:	74 eb                	je     80102d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	3c 2b                	cmp    $0x2b,%al
  801049:	75 05                	jne    801050 <strtol+0x39>
		s++;
  80104b:	ff 45 08             	incl   0x8(%ebp)
  80104e:	eb 13                	jmp    801063 <strtol+0x4c>
	else if (*s == '-')
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	3c 2d                	cmp    $0x2d,%al
  801057:	75 0a                	jne    801063 <strtol+0x4c>
		s++, neg = 1;
  801059:	ff 45 08             	incl   0x8(%ebp)
  80105c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801063:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801067:	74 06                	je     80106f <strtol+0x58>
  801069:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80106d:	75 20                	jne    80108f <strtol+0x78>
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	8a 00                	mov    (%eax),%al
  801074:	3c 30                	cmp    $0x30,%al
  801076:	75 17                	jne    80108f <strtol+0x78>
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	40                   	inc    %eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	3c 78                	cmp    $0x78,%al
  801080:	75 0d                	jne    80108f <strtol+0x78>
		s += 2, base = 16;
  801082:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801086:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80108d:	eb 28                	jmp    8010b7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80108f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801093:	75 15                	jne    8010aa <strtol+0x93>
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	3c 30                	cmp    $0x30,%al
  80109c:	75 0c                	jne    8010aa <strtol+0x93>
		s++, base = 8;
  80109e:	ff 45 08             	incl   0x8(%ebp)
  8010a1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010a8:	eb 0d                	jmp    8010b7 <strtol+0xa0>
	else if (base == 0)
  8010aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ae:	75 07                	jne    8010b7 <strtol+0xa0>
		base = 10;
  8010b0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	3c 2f                	cmp    $0x2f,%al
  8010be:	7e 19                	jle    8010d9 <strtol+0xc2>
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	3c 39                	cmp    $0x39,%al
  8010c7:	7f 10                	jg     8010d9 <strtol+0xc2>
			dig = *s - '0';
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	0f be c0             	movsbl %al,%eax
  8010d1:	83 e8 30             	sub    $0x30,%eax
  8010d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010d7:	eb 42                	jmp    80111b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	3c 60                	cmp    $0x60,%al
  8010e0:	7e 19                	jle    8010fb <strtol+0xe4>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 7a                	cmp    $0x7a,%al
  8010e9:	7f 10                	jg     8010fb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	0f be c0             	movsbl %al,%eax
  8010f3:	83 e8 57             	sub    $0x57,%eax
  8010f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f9:	eb 20                	jmp    80111b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	3c 40                	cmp    $0x40,%al
  801102:	7e 39                	jle    80113d <strtol+0x126>
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 5a                	cmp    $0x5a,%al
  80110b:	7f 30                	jg     80113d <strtol+0x126>
			dig = *s - 'A' + 10;
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	0f be c0             	movsbl %al,%eax
  801115:	83 e8 37             	sub    $0x37,%eax
  801118:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80111b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801121:	7d 19                	jge    80113c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801123:	ff 45 08             	incl   0x8(%ebp)
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	0f af 45 10          	imul   0x10(%ebp),%eax
  80112d:	89 c2                	mov    %eax,%edx
  80112f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801137:	e9 7b ff ff ff       	jmp    8010b7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80113c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80113d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801141:	74 08                	je     80114b <strtol+0x134>
		*endptr = (char *) s;
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	8b 55 08             	mov    0x8(%ebp),%edx
  801149:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80114b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114f:	74 07                	je     801158 <strtol+0x141>
  801151:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801154:	f7 d8                	neg    %eax
  801156:	eb 03                	jmp    80115b <strtol+0x144>
  801158:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80115b:	c9                   	leave  
  80115c:	c3                   	ret    

0080115d <ltostr>:

void
ltostr(long value, char *str)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801163:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80116a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801171:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801175:	79 13                	jns    80118a <ltostr+0x2d>
	{
		neg = 1;
  801177:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80117e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801181:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801184:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801187:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801192:	99                   	cltd   
  801193:	f7 f9                	idiv   %ecx
  801195:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801198:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119b:	8d 50 01             	lea    0x1(%eax),%edx
  80119e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011a1:	89 c2                	mov    %eax,%edx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 d0                	add    %edx,%eax
  8011a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ab:	83 c2 30             	add    $0x30,%edx
  8011ae:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011b8:	f7 e9                	imul   %ecx
  8011ba:	c1 fa 02             	sar    $0x2,%edx
  8011bd:	89 c8                	mov    %ecx,%eax
  8011bf:	c1 f8 1f             	sar    $0x1f,%eax
  8011c2:	29 c2                	sub    %eax,%edx
  8011c4:	89 d0                	mov    %edx,%eax
  8011c6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011cc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011d1:	f7 e9                	imul   %ecx
  8011d3:	c1 fa 02             	sar    $0x2,%edx
  8011d6:	89 c8                	mov    %ecx,%eax
  8011d8:	c1 f8 1f             	sar    $0x1f,%eax
  8011db:	29 c2                	sub    %eax,%edx
  8011dd:	89 d0                	mov    %edx,%eax
  8011df:	c1 e0 02             	shl    $0x2,%eax
  8011e2:	01 d0                	add    %edx,%eax
  8011e4:	01 c0                	add    %eax,%eax
  8011e6:	29 c1                	sub    %eax,%ecx
  8011e8:	89 ca                	mov    %ecx,%edx
  8011ea:	85 d2                	test   %edx,%edx
  8011ec:	75 9c                	jne    80118a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f8:	48                   	dec    %eax
  8011f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801200:	74 3d                	je     80123f <ltostr+0xe2>
		start = 1 ;
  801202:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801209:	eb 34                	jmp    80123f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80120b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	01 d0                	add    %edx,%eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121e:	01 c2                	add    %eax,%edx
  801220:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	01 c8                	add    %ecx,%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80122c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80122f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801232:	01 c2                	add    %eax,%edx
  801234:	8a 45 eb             	mov    -0x15(%ebp),%al
  801237:	88 02                	mov    %al,(%edx)
		start++ ;
  801239:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80123c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80123f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801242:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801245:	7c c4                	jl     80120b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801247:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80124a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124d:	01 d0                	add    %edx,%eax
  80124f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801252:	90                   	nop
  801253:	c9                   	leave  
  801254:	c3                   	ret    

00801255 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80125b:	ff 75 08             	pushl  0x8(%ebp)
  80125e:	e8 54 fa ff ff       	call   800cb7 <strlen>
  801263:	83 c4 04             	add    $0x4,%esp
  801266:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801269:	ff 75 0c             	pushl  0xc(%ebp)
  80126c:	e8 46 fa ff ff       	call   800cb7 <strlen>
  801271:	83 c4 04             	add    $0x4,%esp
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801277:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80127e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801285:	eb 17                	jmp    80129e <strcconcat+0x49>
		final[s] = str1[s] ;
  801287:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128a:	8b 45 10             	mov    0x10(%ebp),%eax
  80128d:	01 c2                	add    %eax,%edx
  80128f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	01 c8                	add    %ecx,%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80129b:	ff 45 fc             	incl   -0x4(%ebp)
  80129e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012a4:	7c e1                	jl     801287 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012b4:	eb 1f                	jmp    8012d5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b9:	8d 50 01             	lea    0x1(%eax),%edx
  8012bc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c4:	01 c2                	add    %eax,%edx
  8012c6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 c8                	add    %ecx,%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012d2:	ff 45 f8             	incl   -0x8(%ebp)
  8012d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012db:	7c d9                	jl     8012b6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e3:	01 d0                	add    %edx,%eax
  8012e5:	c6 00 00             	movb   $0x0,(%eax)
}
  8012e8:	90                   	nop
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fa:	8b 00                	mov    (%eax),%eax
  8012fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	01 d0                	add    %edx,%eax
  801308:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80130e:	eb 0c                	jmp    80131c <strsplit+0x31>
			*string++ = 0;
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	8d 50 01             	lea    0x1(%eax),%edx
  801316:	89 55 08             	mov    %edx,0x8(%ebp)
  801319:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	84 c0                	test   %al,%al
  801323:	74 18                	je     80133d <strsplit+0x52>
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	0f be c0             	movsbl %al,%eax
  80132d:	50                   	push   %eax
  80132e:	ff 75 0c             	pushl  0xc(%ebp)
  801331:	e8 13 fb ff ff       	call   800e49 <strchr>
  801336:	83 c4 08             	add    $0x8,%esp
  801339:	85 c0                	test   %eax,%eax
  80133b:	75 d3                	jne    801310 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	84 c0                	test   %al,%al
  801344:	74 5a                	je     8013a0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801346:	8b 45 14             	mov    0x14(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	83 f8 0f             	cmp    $0xf,%eax
  80134e:	75 07                	jne    801357 <strsplit+0x6c>
		{
			return 0;
  801350:	b8 00 00 00 00       	mov    $0x0,%eax
  801355:	eb 66                	jmp    8013bd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801357:	8b 45 14             	mov    0x14(%ebp),%eax
  80135a:	8b 00                	mov    (%eax),%eax
  80135c:	8d 48 01             	lea    0x1(%eax),%ecx
  80135f:	8b 55 14             	mov    0x14(%ebp),%edx
  801362:	89 0a                	mov    %ecx,(%edx)
  801364:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136b:	8b 45 10             	mov    0x10(%ebp),%eax
  80136e:	01 c2                	add    %eax,%edx
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801375:	eb 03                	jmp    80137a <strsplit+0x8f>
			string++;
  801377:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	84 c0                	test   %al,%al
  801381:	74 8b                	je     80130e <strsplit+0x23>
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8a 00                	mov    (%eax),%al
  801388:	0f be c0             	movsbl %al,%eax
  80138b:	50                   	push   %eax
  80138c:	ff 75 0c             	pushl  0xc(%ebp)
  80138f:	e8 b5 fa ff ff       	call   800e49 <strchr>
  801394:	83 c4 08             	add    $0x8,%esp
  801397:	85 c0                	test   %eax,%eax
  801399:	74 dc                	je     801377 <strsplit+0x8c>
			string++;
	}
  80139b:	e9 6e ff ff ff       	jmp    80130e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013a0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a4:	8b 00                	mov    (%eax),%eax
  8013a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b0:	01 d0                	add    %edx,%eax
  8013b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013b8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8013c5:	83 ec 04             	sub    $0x4,%esp
  8013c8:	68 30 24 80 00       	push   $0x802430
  8013cd:	6a 19                	push   $0x19
  8013cf:	68 55 24 80 00       	push   $0x802455
  8013d4:	e8 ba ef ff ff       	call   800393 <_panic>

008013d9 <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 18             	sub    $0x18,%esp
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8013e5:	83 ec 04             	sub    $0x4,%esp
  8013e8:	68 64 24 80 00       	push   $0x802464
  8013ed:	6a 31                	push   $0x31
  8013ef:	68 55 24 80 00       	push   $0x802455
  8013f4:	e8 9a ef ff ff       	call   800393 <_panic>

008013f9 <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8013ff:	83 ec 04             	sub    $0x4,%esp
  801402:	68 8c 24 80 00       	push   $0x80248c
  801407:	6a 4a                	push   $0x4a
  801409:	68 55 24 80 00       	push   $0x802455
  80140e:	e8 80 ef ff ff       	call   800393 <_panic>

00801413 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801419:	83 ec 04             	sub    $0x4,%esp
  80141c:	68 b0 24 80 00       	push   $0x8024b0
  801421:	6a 70                	push   $0x70
  801423:	68 55 24 80 00       	push   $0x802455
  801428:	e8 66 ef ff ff       	call   800393 <_panic>

0080142d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801433:	83 ec 04             	sub    $0x4,%esp
  801436:	68 d4 24 80 00       	push   $0x8024d4
  80143b:	68 8b 00 00 00       	push   $0x8b
  801440:	68 55 24 80 00       	push   $0x802455
  801445:	e8 49 ef ff ff       	call   800393 <_panic>

0080144a <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801450:	83 ec 04             	sub    $0x4,%esp
  801453:	68 f8 24 80 00       	push   $0x8024f8
  801458:	68 a8 00 00 00       	push   $0xa8
  80145d:	68 55 24 80 00       	push   $0x802455
  801462:	e8 2c ef ff ff       	call   800393 <_panic>

00801467 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	57                   	push   %edi
  80146b:	56                   	push   %esi
  80146c:	53                   	push   %ebx
  80146d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	8b 55 0c             	mov    0xc(%ebp),%edx
  801476:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801479:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80147c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80147f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801482:	cd 30                	int    $0x30
  801484:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801487:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	5b                   	pop    %ebx
  80148e:	5e                   	pop    %esi
  80148f:	5f                   	pop    %edi
  801490:	5d                   	pop    %ebp
  801491:	c3                   	ret    

00801492 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 04             	sub    $0x4,%esp
  801498:	8b 45 10             	mov    0x10(%ebp),%eax
  80149b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80149e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	52                   	push   %edx
  8014aa:	ff 75 0c             	pushl  0xc(%ebp)
  8014ad:	50                   	push   %eax
  8014ae:	6a 00                	push   $0x0
  8014b0:	e8 b2 ff ff ff       	call   801467 <syscall>
  8014b5:	83 c4 18             	add    $0x18,%esp
}
  8014b8:	90                   	nop
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <sys_cgetc>:

int
sys_cgetc(void)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 01                	push   $0x1
  8014ca:	e8 98 ff ff ff       	call   801467 <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
}
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    

008014d4 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	50                   	push   %eax
  8014e3:	6a 05                	push   $0x5
  8014e5:	e8 7d ff ff ff       	call   801467 <syscall>
  8014ea:	83 c4 18             	add    $0x18,%esp
}
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 02                	push   $0x2
  8014fe:	e8 64 ff ff ff       	call   801467 <syscall>
  801503:	83 c4 18             	add    $0x18,%esp
}
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 03                	push   $0x3
  801517:	e8 4b ff ff ff       	call   801467 <syscall>
  80151c:	83 c4 18             	add    $0x18,%esp
}
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 04                	push   $0x4
  801530:	e8 32 ff ff ff       	call   801467 <syscall>
  801535:	83 c4 18             	add    $0x18,%esp
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <sys_env_exit>:


void sys_env_exit(void)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 06                	push   $0x6
  801549:	e8 19 ff ff ff       	call   801467 <syscall>
  80154e:	83 c4 18             	add    $0x18,%esp
}
  801551:	90                   	nop
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801557:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	52                   	push   %edx
  801564:	50                   	push   %eax
  801565:	6a 07                	push   $0x7
  801567:	e8 fb fe ff ff       	call   801467 <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	56                   	push   %esi
  801575:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801576:	8b 75 18             	mov    0x18(%ebp),%esi
  801579:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80157c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80157f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	56                   	push   %esi
  801586:	53                   	push   %ebx
  801587:	51                   	push   %ecx
  801588:	52                   	push   %edx
  801589:	50                   	push   %eax
  80158a:	6a 08                	push   $0x8
  80158c:	e8 d6 fe ff ff       	call   801467 <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801597:	5b                   	pop    %ebx
  801598:	5e                   	pop    %esi
  801599:	5d                   	pop    %ebp
  80159a:	c3                   	ret    

0080159b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80159e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	52                   	push   %edx
  8015ab:	50                   	push   %eax
  8015ac:	6a 09                	push   $0x9
  8015ae:	e8 b4 fe ff ff       	call   801467 <syscall>
  8015b3:	83 c4 18             	add    $0x18,%esp
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	ff 75 0c             	pushl  0xc(%ebp)
  8015c4:	ff 75 08             	pushl  0x8(%ebp)
  8015c7:	6a 0a                	push   $0xa
  8015c9:	e8 99 fe ff ff       	call   801467 <syscall>
  8015ce:	83 c4 18             	add    $0x18,%esp
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 0b                	push   $0xb
  8015e2:	e8 80 fe ff ff       	call   801467 <syscall>
  8015e7:	83 c4 18             	add    $0x18,%esp
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 0c                	push   $0xc
  8015fb:	e8 67 fe ff ff       	call   801467 <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 0d                	push   $0xd
  801614:	e8 4e fe ff ff       	call   801467 <syscall>
  801619:	83 c4 18             	add    $0x18,%esp
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	ff 75 0c             	pushl  0xc(%ebp)
  80162a:	ff 75 08             	pushl  0x8(%ebp)
  80162d:	6a 11                	push   $0x11
  80162f:	e8 33 fe ff ff       	call   801467 <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
	return;
  801637:	90                   	nop
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	ff 75 0c             	pushl  0xc(%ebp)
  801646:	ff 75 08             	pushl  0x8(%ebp)
  801649:	6a 12                	push   $0x12
  80164b:	e8 17 fe ff ff       	call   801467 <syscall>
  801650:	83 c4 18             	add    $0x18,%esp
	return ;
  801653:	90                   	nop
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 0e                	push   $0xe
  801665:	e8 fd fd ff ff       	call   801467 <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	ff 75 08             	pushl  0x8(%ebp)
  80167d:	6a 0f                	push   $0xf
  80167f:	e8 e3 fd ff ff       	call   801467 <syscall>
  801684:	83 c4 18             	add    $0x18,%esp
}
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 10                	push   $0x10
  801698:	e8 ca fd ff ff       	call   801467 <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	90                   	nop
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 14                	push   $0x14
  8016b2:	e8 b0 fd ff ff       	call   801467 <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
}
  8016ba:	90                   	nop
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 15                	push   $0x15
  8016cc:	e8 96 fd ff ff       	call   801467 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
}
  8016d4:	90                   	nop
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 04             	sub    $0x4,%esp
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016e3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	50                   	push   %eax
  8016f0:	6a 16                	push   $0x16
  8016f2:	e8 70 fd ff ff       	call   801467 <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	90                   	nop
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 17                	push   $0x17
  80170c:	e8 56 fd ff ff       	call   801467 <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
}
  801714:	90                   	nop
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	ff 75 0c             	pushl  0xc(%ebp)
  801726:	50                   	push   %eax
  801727:	6a 18                	push   $0x18
  801729:	e8 39 fd ff ff       	call   801467 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801736:	8b 55 0c             	mov    0xc(%ebp),%edx
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	52                   	push   %edx
  801743:	50                   	push   %eax
  801744:	6a 1b                	push   $0x1b
  801746:	e8 1c fd ff ff       	call   801467 <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801753:	8b 55 0c             	mov    0xc(%ebp),%edx
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	52                   	push   %edx
  801760:	50                   	push   %eax
  801761:	6a 19                	push   $0x19
  801763:	e8 ff fc ff ff       	call   801467 <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
}
  80176b:	90                   	nop
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801771:	8b 55 0c             	mov    0xc(%ebp),%edx
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	52                   	push   %edx
  80177e:	50                   	push   %eax
  80177f:	6a 1a                	push   $0x1a
  801781:	e8 e1 fc ff ff       	call   801467 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	90                   	nop
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 04             	sub    $0x4,%esp
  801792:	8b 45 10             	mov    0x10(%ebp),%eax
  801795:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801798:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80179b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	6a 00                	push   $0x0
  8017a4:	51                   	push   %ecx
  8017a5:	52                   	push   %edx
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	50                   	push   %eax
  8017aa:	6a 1c                	push   $0x1c
  8017ac:	e8 b6 fc ff ff       	call   801467 <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	52                   	push   %edx
  8017c6:	50                   	push   %eax
  8017c7:	6a 1d                	push   $0x1d
  8017c9:	e8 99 fc ff ff       	call   801467 <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	51                   	push   %ecx
  8017e4:	52                   	push   %edx
  8017e5:	50                   	push   %eax
  8017e6:	6a 1e                	push   $0x1e
  8017e8:	e8 7a fc ff ff       	call   801467 <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	52                   	push   %edx
  801802:	50                   	push   %eax
  801803:	6a 1f                	push   $0x1f
  801805:	e8 5d fc ff ff       	call   801467 <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
}
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 20                	push   $0x20
  80181e:	e8 44 fc ff ff       	call   801467 <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	ff 75 10             	pushl  0x10(%ebp)
  801835:	ff 75 0c             	pushl  0xc(%ebp)
  801838:	50                   	push   %eax
  801839:	6a 21                	push   $0x21
  80183b:	e8 27 fc ff ff       	call   801467 <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	50                   	push   %eax
  801854:	6a 22                	push   $0x22
  801856:	e8 0c fc ff ff       	call   801467 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	90                   	nop
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	50                   	push   %eax
  801870:	6a 23                	push   $0x23
  801872:	e8 f0 fb ff ff       	call   801467 <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	90                   	nop
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801883:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801886:	8d 50 04             	lea    0x4(%eax),%edx
  801889:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	52                   	push   %edx
  801893:	50                   	push   %eax
  801894:	6a 24                	push   $0x24
  801896:	e8 cc fb ff ff       	call   801467 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
	return result;
  80189e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a7:	89 01                	mov    %eax,(%ecx)
  8018a9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	c9                   	leave  
  8018b0:	c2 04 00             	ret    $0x4

008018b3 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	ff 75 10             	pushl  0x10(%ebp)
  8018bd:	ff 75 0c             	pushl  0xc(%ebp)
  8018c0:	ff 75 08             	pushl  0x8(%ebp)
  8018c3:	6a 13                	push   $0x13
  8018c5:	e8 9d fb ff ff       	call   801467 <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8018cd:	90                   	nop
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 25                	push   $0x25
  8018df:	e8 83 fb ff ff       	call   801467 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018f5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	50                   	push   %eax
  801902:	6a 26                	push   $0x26
  801904:	e8 5e fb ff ff       	call   801467 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
	return ;
  80190c:	90                   	nop
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <rsttst>:
void rsttst()
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 28                	push   $0x28
  80191e:	e8 44 fb ff ff       	call   801467 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
	return ;
  801926:	90                   	nop
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	83 ec 04             	sub    $0x4,%esp
  80192f:	8b 45 14             	mov    0x14(%ebp),%eax
  801932:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801935:	8b 55 18             	mov    0x18(%ebp),%edx
  801938:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80193c:	52                   	push   %edx
  80193d:	50                   	push   %eax
  80193e:	ff 75 10             	pushl  0x10(%ebp)
  801941:	ff 75 0c             	pushl  0xc(%ebp)
  801944:	ff 75 08             	pushl  0x8(%ebp)
  801947:	6a 27                	push   $0x27
  801949:	e8 19 fb ff ff       	call   801467 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
	return ;
  801951:	90                   	nop
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <chktst>:
void chktst(uint32 n)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	ff 75 08             	pushl  0x8(%ebp)
  801962:	6a 29                	push   $0x29
  801964:	e8 fe fa ff ff       	call   801467 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
	return ;
  80196c:	90                   	nop
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <inctst>:

void inctst()
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 2a                	push   $0x2a
  80197e:	e8 e4 fa ff ff       	call   801467 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
	return ;
  801986:	90                   	nop
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <gettst>:
uint32 gettst()
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 2b                	push   $0x2b
  801998:	e8 ca fa ff ff       	call   801467 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 2c                	push   $0x2c
  8019b4:	e8 ae fa ff ff       	call   801467 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
  8019bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019bf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019c3:	75 07                	jne    8019cc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ca:	eb 05                	jmp    8019d1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 2c                	push   $0x2c
  8019e5:	e8 7d fa ff ff       	call   801467 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
  8019ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019f0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019f4:	75 07                	jne    8019fd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fb:	eb 05                	jmp    801a02 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 2c                	push   $0x2c
  801a16:	e8 4c fa ff ff       	call   801467 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
  801a1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a21:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a25:	75 07                	jne    801a2e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a27:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2c:	eb 05                	jmp    801a33 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 2c                	push   $0x2c
  801a47:	e8 1b fa ff ff       	call   801467 <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
  801a4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a52:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a56:	75 07                	jne    801a5f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a58:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5d:	eb 05                	jmp    801a64 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	ff 75 08             	pushl  0x8(%ebp)
  801a74:	6a 2d                	push   $0x2d
  801a76:	e8 ec f9 ff ff       	call   801467 <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7e:	90                   	nop
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a85:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a88:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	6a 00                	push   $0x0
  801a93:	53                   	push   %ebx
  801a94:	51                   	push   %ecx
  801a95:	52                   	push   %edx
  801a96:	50                   	push   %eax
  801a97:	6a 2e                	push   $0x2e
  801a99:	e8 c9 f9 ff ff       	call   801467 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	52                   	push   %edx
  801ab6:	50                   	push   %eax
  801ab7:	6a 2f                	push   $0x2f
  801ab9:	e8 a9 f9 ff ff       	call   801467 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    
  801ac3:	90                   	nop

00801ac4 <__udivdi3>:
  801ac4:	55                   	push   %ebp
  801ac5:	57                   	push   %edi
  801ac6:	56                   	push   %esi
  801ac7:	53                   	push   %ebx
  801ac8:	83 ec 1c             	sub    $0x1c,%esp
  801acb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801acf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ad3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ad7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801adb:	89 ca                	mov    %ecx,%edx
  801add:	89 f8                	mov    %edi,%eax
  801adf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ae3:	85 f6                	test   %esi,%esi
  801ae5:	75 2d                	jne    801b14 <__udivdi3+0x50>
  801ae7:	39 cf                	cmp    %ecx,%edi
  801ae9:	77 65                	ja     801b50 <__udivdi3+0x8c>
  801aeb:	89 fd                	mov    %edi,%ebp
  801aed:	85 ff                	test   %edi,%edi
  801aef:	75 0b                	jne    801afc <__udivdi3+0x38>
  801af1:	b8 01 00 00 00       	mov    $0x1,%eax
  801af6:	31 d2                	xor    %edx,%edx
  801af8:	f7 f7                	div    %edi
  801afa:	89 c5                	mov    %eax,%ebp
  801afc:	31 d2                	xor    %edx,%edx
  801afe:	89 c8                	mov    %ecx,%eax
  801b00:	f7 f5                	div    %ebp
  801b02:	89 c1                	mov    %eax,%ecx
  801b04:	89 d8                	mov    %ebx,%eax
  801b06:	f7 f5                	div    %ebp
  801b08:	89 cf                	mov    %ecx,%edi
  801b0a:	89 fa                	mov    %edi,%edx
  801b0c:	83 c4 1c             	add    $0x1c,%esp
  801b0f:	5b                   	pop    %ebx
  801b10:	5e                   	pop    %esi
  801b11:	5f                   	pop    %edi
  801b12:	5d                   	pop    %ebp
  801b13:	c3                   	ret    
  801b14:	39 ce                	cmp    %ecx,%esi
  801b16:	77 28                	ja     801b40 <__udivdi3+0x7c>
  801b18:	0f bd fe             	bsr    %esi,%edi
  801b1b:	83 f7 1f             	xor    $0x1f,%edi
  801b1e:	75 40                	jne    801b60 <__udivdi3+0x9c>
  801b20:	39 ce                	cmp    %ecx,%esi
  801b22:	72 0a                	jb     801b2e <__udivdi3+0x6a>
  801b24:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b28:	0f 87 9e 00 00 00    	ja     801bcc <__udivdi3+0x108>
  801b2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b33:	89 fa                	mov    %edi,%edx
  801b35:	83 c4 1c             	add    $0x1c,%esp
  801b38:	5b                   	pop    %ebx
  801b39:	5e                   	pop    %esi
  801b3a:	5f                   	pop    %edi
  801b3b:	5d                   	pop    %ebp
  801b3c:	c3                   	ret    
  801b3d:	8d 76 00             	lea    0x0(%esi),%esi
  801b40:	31 ff                	xor    %edi,%edi
  801b42:	31 c0                	xor    %eax,%eax
  801b44:	89 fa                	mov    %edi,%edx
  801b46:	83 c4 1c             	add    $0x1c,%esp
  801b49:	5b                   	pop    %ebx
  801b4a:	5e                   	pop    %esi
  801b4b:	5f                   	pop    %edi
  801b4c:	5d                   	pop    %ebp
  801b4d:	c3                   	ret    
  801b4e:	66 90                	xchg   %ax,%ax
  801b50:	89 d8                	mov    %ebx,%eax
  801b52:	f7 f7                	div    %edi
  801b54:	31 ff                	xor    %edi,%edi
  801b56:	89 fa                	mov    %edi,%edx
  801b58:	83 c4 1c             	add    $0x1c,%esp
  801b5b:	5b                   	pop    %ebx
  801b5c:	5e                   	pop    %esi
  801b5d:	5f                   	pop    %edi
  801b5e:	5d                   	pop    %ebp
  801b5f:	c3                   	ret    
  801b60:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b65:	89 eb                	mov    %ebp,%ebx
  801b67:	29 fb                	sub    %edi,%ebx
  801b69:	89 f9                	mov    %edi,%ecx
  801b6b:	d3 e6                	shl    %cl,%esi
  801b6d:	89 c5                	mov    %eax,%ebp
  801b6f:	88 d9                	mov    %bl,%cl
  801b71:	d3 ed                	shr    %cl,%ebp
  801b73:	89 e9                	mov    %ebp,%ecx
  801b75:	09 f1                	or     %esi,%ecx
  801b77:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b7b:	89 f9                	mov    %edi,%ecx
  801b7d:	d3 e0                	shl    %cl,%eax
  801b7f:	89 c5                	mov    %eax,%ebp
  801b81:	89 d6                	mov    %edx,%esi
  801b83:	88 d9                	mov    %bl,%cl
  801b85:	d3 ee                	shr    %cl,%esi
  801b87:	89 f9                	mov    %edi,%ecx
  801b89:	d3 e2                	shl    %cl,%edx
  801b8b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b8f:	88 d9                	mov    %bl,%cl
  801b91:	d3 e8                	shr    %cl,%eax
  801b93:	09 c2                	or     %eax,%edx
  801b95:	89 d0                	mov    %edx,%eax
  801b97:	89 f2                	mov    %esi,%edx
  801b99:	f7 74 24 0c          	divl   0xc(%esp)
  801b9d:	89 d6                	mov    %edx,%esi
  801b9f:	89 c3                	mov    %eax,%ebx
  801ba1:	f7 e5                	mul    %ebp
  801ba3:	39 d6                	cmp    %edx,%esi
  801ba5:	72 19                	jb     801bc0 <__udivdi3+0xfc>
  801ba7:	74 0b                	je     801bb4 <__udivdi3+0xf0>
  801ba9:	89 d8                	mov    %ebx,%eax
  801bab:	31 ff                	xor    %edi,%edi
  801bad:	e9 58 ff ff ff       	jmp    801b0a <__udivdi3+0x46>
  801bb2:	66 90                	xchg   %ax,%ax
  801bb4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bb8:	89 f9                	mov    %edi,%ecx
  801bba:	d3 e2                	shl    %cl,%edx
  801bbc:	39 c2                	cmp    %eax,%edx
  801bbe:	73 e9                	jae    801ba9 <__udivdi3+0xe5>
  801bc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bc3:	31 ff                	xor    %edi,%edi
  801bc5:	e9 40 ff ff ff       	jmp    801b0a <__udivdi3+0x46>
  801bca:	66 90                	xchg   %ax,%ax
  801bcc:	31 c0                	xor    %eax,%eax
  801bce:	e9 37 ff ff ff       	jmp    801b0a <__udivdi3+0x46>
  801bd3:	90                   	nop

00801bd4 <__umoddi3>:
  801bd4:	55                   	push   %ebp
  801bd5:	57                   	push   %edi
  801bd6:	56                   	push   %esi
  801bd7:	53                   	push   %ebx
  801bd8:	83 ec 1c             	sub    $0x1c,%esp
  801bdb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bdf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801be3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801be7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801beb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bf3:	89 f3                	mov    %esi,%ebx
  801bf5:	89 fa                	mov    %edi,%edx
  801bf7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bfb:	89 34 24             	mov    %esi,(%esp)
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	75 1a                	jne    801c1c <__umoddi3+0x48>
  801c02:	39 f7                	cmp    %esi,%edi
  801c04:	0f 86 a2 00 00 00    	jbe    801cac <__umoddi3+0xd8>
  801c0a:	89 c8                	mov    %ecx,%eax
  801c0c:	89 f2                	mov    %esi,%edx
  801c0e:	f7 f7                	div    %edi
  801c10:	89 d0                	mov    %edx,%eax
  801c12:	31 d2                	xor    %edx,%edx
  801c14:	83 c4 1c             	add    $0x1c,%esp
  801c17:	5b                   	pop    %ebx
  801c18:	5e                   	pop    %esi
  801c19:	5f                   	pop    %edi
  801c1a:	5d                   	pop    %ebp
  801c1b:	c3                   	ret    
  801c1c:	39 f0                	cmp    %esi,%eax
  801c1e:	0f 87 ac 00 00 00    	ja     801cd0 <__umoddi3+0xfc>
  801c24:	0f bd e8             	bsr    %eax,%ebp
  801c27:	83 f5 1f             	xor    $0x1f,%ebp
  801c2a:	0f 84 ac 00 00 00    	je     801cdc <__umoddi3+0x108>
  801c30:	bf 20 00 00 00       	mov    $0x20,%edi
  801c35:	29 ef                	sub    %ebp,%edi
  801c37:	89 fe                	mov    %edi,%esi
  801c39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c3d:	89 e9                	mov    %ebp,%ecx
  801c3f:	d3 e0                	shl    %cl,%eax
  801c41:	89 d7                	mov    %edx,%edi
  801c43:	89 f1                	mov    %esi,%ecx
  801c45:	d3 ef                	shr    %cl,%edi
  801c47:	09 c7                	or     %eax,%edi
  801c49:	89 e9                	mov    %ebp,%ecx
  801c4b:	d3 e2                	shl    %cl,%edx
  801c4d:	89 14 24             	mov    %edx,(%esp)
  801c50:	89 d8                	mov    %ebx,%eax
  801c52:	d3 e0                	shl    %cl,%eax
  801c54:	89 c2                	mov    %eax,%edx
  801c56:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c5a:	d3 e0                	shl    %cl,%eax
  801c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c60:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c64:	89 f1                	mov    %esi,%ecx
  801c66:	d3 e8                	shr    %cl,%eax
  801c68:	09 d0                	or     %edx,%eax
  801c6a:	d3 eb                	shr    %cl,%ebx
  801c6c:	89 da                	mov    %ebx,%edx
  801c6e:	f7 f7                	div    %edi
  801c70:	89 d3                	mov    %edx,%ebx
  801c72:	f7 24 24             	mull   (%esp)
  801c75:	89 c6                	mov    %eax,%esi
  801c77:	89 d1                	mov    %edx,%ecx
  801c79:	39 d3                	cmp    %edx,%ebx
  801c7b:	0f 82 87 00 00 00    	jb     801d08 <__umoddi3+0x134>
  801c81:	0f 84 91 00 00 00    	je     801d18 <__umoddi3+0x144>
  801c87:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c8b:	29 f2                	sub    %esi,%edx
  801c8d:	19 cb                	sbb    %ecx,%ebx
  801c8f:	89 d8                	mov    %ebx,%eax
  801c91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c95:	d3 e0                	shl    %cl,%eax
  801c97:	89 e9                	mov    %ebp,%ecx
  801c99:	d3 ea                	shr    %cl,%edx
  801c9b:	09 d0                	or     %edx,%eax
  801c9d:	89 e9                	mov    %ebp,%ecx
  801c9f:	d3 eb                	shr    %cl,%ebx
  801ca1:	89 da                	mov    %ebx,%edx
  801ca3:	83 c4 1c             	add    $0x1c,%esp
  801ca6:	5b                   	pop    %ebx
  801ca7:	5e                   	pop    %esi
  801ca8:	5f                   	pop    %edi
  801ca9:	5d                   	pop    %ebp
  801caa:	c3                   	ret    
  801cab:	90                   	nop
  801cac:	89 fd                	mov    %edi,%ebp
  801cae:	85 ff                	test   %edi,%edi
  801cb0:	75 0b                	jne    801cbd <__umoddi3+0xe9>
  801cb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb7:	31 d2                	xor    %edx,%edx
  801cb9:	f7 f7                	div    %edi
  801cbb:	89 c5                	mov    %eax,%ebp
  801cbd:	89 f0                	mov    %esi,%eax
  801cbf:	31 d2                	xor    %edx,%edx
  801cc1:	f7 f5                	div    %ebp
  801cc3:	89 c8                	mov    %ecx,%eax
  801cc5:	f7 f5                	div    %ebp
  801cc7:	89 d0                	mov    %edx,%eax
  801cc9:	e9 44 ff ff ff       	jmp    801c12 <__umoddi3+0x3e>
  801cce:	66 90                	xchg   %ax,%ax
  801cd0:	89 c8                	mov    %ecx,%eax
  801cd2:	89 f2                	mov    %esi,%edx
  801cd4:	83 c4 1c             	add    $0x1c,%esp
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5f                   	pop    %edi
  801cda:	5d                   	pop    %ebp
  801cdb:	c3                   	ret    
  801cdc:	3b 04 24             	cmp    (%esp),%eax
  801cdf:	72 06                	jb     801ce7 <__umoddi3+0x113>
  801ce1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ce5:	77 0f                	ja     801cf6 <__umoddi3+0x122>
  801ce7:	89 f2                	mov    %esi,%edx
  801ce9:	29 f9                	sub    %edi,%ecx
  801ceb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cef:	89 14 24             	mov    %edx,(%esp)
  801cf2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cf6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cfa:	8b 14 24             	mov    (%esp),%edx
  801cfd:	83 c4 1c             	add    $0x1c,%esp
  801d00:	5b                   	pop    %ebx
  801d01:	5e                   	pop    %esi
  801d02:	5f                   	pop    %edi
  801d03:	5d                   	pop    %ebp
  801d04:	c3                   	ret    
  801d05:	8d 76 00             	lea    0x0(%esi),%esi
  801d08:	2b 04 24             	sub    (%esp),%eax
  801d0b:	19 fa                	sbb    %edi,%edx
  801d0d:	89 d1                	mov    %edx,%ecx
  801d0f:	89 c6                	mov    %eax,%esi
  801d11:	e9 71 ff ff ff       	jmp    801c87 <__umoddi3+0xb3>
  801d16:	66 90                	xchg   %ax,%ax
  801d18:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d1c:	72 ea                	jb     801d08 <__umoddi3+0x134>
  801d1e:	89 d9                	mov    %ebx,%ecx
  801d20:	e9 62 ff ff ff       	jmp    801c87 <__umoddi3+0xb3>
