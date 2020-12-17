
obj/user/tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 38 01 00 00       	call   80016e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 23                	jmp    80006e <_main+0x36>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 30 80 00       	mov    0x803020,%eax
  800050:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	c1 e2 04             	shl    $0x4,%edx
  80005c:	01 d0                	add    %edx,%eax
  80005e:	8a 40 04             	mov    0x4(%eax),%al
  800061:	84 c0                	test   %al,%al
  800063:	74 06                	je     80006b <_main+0x33>
			{
				fullWS = 0;
  800065:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800069:	eb 12                	jmp    80007d <_main+0x45>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006b:	ff 45 f0             	incl   -0x10(%ebp)
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 50 74             	mov    0x74(%eax),%edx
  800076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800079:	39 c2                	cmp    %eax,%edx
  80007b:	77 ce                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007d:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800081:	74 14                	je     800097 <_main+0x5f>
  800083:	83 ec 04             	sub    $0x4,%esp
  800086:	68 00 1d 80 00       	push   $0x801d00
  80008b:	6a 12                	push   $0x12
  80008d:	68 1c 1d 80 00       	push   $0x801d1c
  800092:	e8 1c 02 00 00       	call   8002b3 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  800097:	e8 a5 13 00 00       	call   801441 <sys_getparentenvid>
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	68 39 1d 80 00       	push   $0x801d39
  8000a4:	50                   	push   %eax
  8000a5:	e8 6f 12 00 00       	call   801319 <sget>
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 3c 1d 80 00       	push   $0x801d3c
  8000b8:	e8 98 04 00 00       	call   800555 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	68 64 1d 80 00       	push   $0x801d64
  8000c8:	e8 88 04 00 00       	call   800555 <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	68 28 23 00 00       	push   $0x2328
  8000d8:	e8 06 19 00 00       	call   8019e3 <env_sleep>
  8000dd:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 0e 14 00 00       	call   8014f3 <sys_calculate_free_frames>
  8000e5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ee:	e8 5a 12 00 00       	call   80134d <sfree>
  8000f3:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 84 1d 80 00       	push   $0x801d84
  8000fe:	e8 52 04 00 00       	call   800555 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800106:	e8 e8 13 00 00       	call   8014f3 <sys_calculate_free_frames>
  80010b:	89 c2                	mov    %eax,%edx
  80010d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800110:	29 c2                	sub    %eax,%edx
  800112:	89 d0                	mov    %edx,%eax
  800114:	83 f8 04             	cmp    $0x4,%eax
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 9c 1d 80 00       	push   $0x801d9c
  800121:	6a 20                	push   $0x20
  800123:	68 1c 1d 80 00       	push   $0x801d1c
  800128:	e8 86 01 00 00       	call   8002b3 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  80012d:	e8 77 17 00 00       	call   8018a9 <gettst>
  800132:	83 f8 02             	cmp    $0x2,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 3c 1e 80 00       	push   $0x801e3c
  80013f:	6a 23                	push   $0x23
  800141:	68 1c 1d 80 00       	push   $0x801d1c
  800146:	e8 68 01 00 00       	call   8002b3 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	68 48 1e 80 00       	push   $0x801e48
  800153:	e8 fd 03 00 00       	call   800555 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	68 6c 1e 80 00       	push   $0x801e6c
  800163:	e8 ed 03 00 00       	call   800555 <cprintf>
  800168:	83 c4 10             	add    $0x10,%esp

	return;
  80016b:	90                   	nop
}
  80016c:	c9                   	leave  
  80016d:	c3                   	ret    

0080016e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016e:	55                   	push   %ebp
  80016f:	89 e5                	mov    %esp,%ebp
  800171:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800174:	e8 af 12 00 00       	call   801428 <sys_getenvindex>
  800179:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80017c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017f:	89 d0                	mov    %edx,%eax
  800181:	c1 e0 03             	shl    $0x3,%eax
  800184:	01 d0                	add    %edx,%eax
  800186:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80018d:	01 c8                	add    %ecx,%eax
  80018f:	01 c0                	add    %eax,%eax
  800191:	01 d0                	add    %edx,%eax
  800193:	01 c0                	add    %eax,%eax
  800195:	01 d0                	add    %edx,%eax
  800197:	89 c2                	mov    %eax,%edx
  800199:	c1 e2 05             	shl    $0x5,%edx
  80019c:	29 c2                	sub    %eax,%edx
  80019e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001a5:	89 c2                	mov    %eax,%edx
  8001a7:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001ad:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b7:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001bd:	84 c0                	test   %al,%al
  8001bf:	74 0f                	je     8001d0 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c6:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001cb:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d4:	7e 0a                	jle    8001e0 <libmain+0x72>
		binaryname = argv[0];
  8001d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d9:	8b 00                	mov    (%eax),%eax
  8001db:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001e0:	83 ec 08             	sub    $0x8,%esp
  8001e3:	ff 75 0c             	pushl  0xc(%ebp)
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	e8 4a fe ff ff       	call   800038 <_main>
  8001ee:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001f1:	e8 cd 13 00 00       	call   8015c3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	68 d0 1e 80 00       	push   $0x801ed0
  8001fe:	e8 52 03 00 00       	call   800555 <cprintf>
  800203:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800206:	a1 20 30 80 00       	mov    0x803020,%eax
  80020b:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800211:	a1 20 30 80 00       	mov    0x803020,%eax
  800216:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	52                   	push   %edx
  800220:	50                   	push   %eax
  800221:	68 f8 1e 80 00       	push   $0x801ef8
  800226:	e8 2a 03 00 00       	call   800555 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80022e:	a1 20 30 80 00       	mov    0x803020,%eax
  800233:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800239:	a1 20 30 80 00       	mov    0x803020,%eax
  80023e:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800244:	83 ec 04             	sub    $0x4,%esp
  800247:	52                   	push   %edx
  800248:	50                   	push   %eax
  800249:	68 20 1f 80 00       	push   $0x801f20
  80024e:	e8 02 03 00 00       	call   800555 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800256:	a1 20 30 80 00       	mov    0x803020,%eax
  80025b:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800261:	83 ec 08             	sub    $0x8,%esp
  800264:	50                   	push   %eax
  800265:	68 61 1f 80 00       	push   $0x801f61
  80026a:	e8 e6 02 00 00       	call   800555 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 d0 1e 80 00       	push   $0x801ed0
  80027a:	e8 d6 02 00 00       	call   800555 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800282:	e8 56 13 00 00       	call   8015dd <sys_enable_interrupt>

	// exit gracefully
	exit();
  800287:	e8 19 00 00 00       	call   8002a5 <exit>
}
  80028c:	90                   	nop
  80028d:	c9                   	leave  
  80028e:	c3                   	ret    

0080028f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	6a 00                	push   $0x0
  80029a:	e8 55 11 00 00       	call   8013f4 <sys_env_destroy>
  80029f:	83 c4 10             	add    $0x10,%esp
}
  8002a2:	90                   	nop
  8002a3:	c9                   	leave  
  8002a4:	c3                   	ret    

008002a5 <exit>:

void
exit(void)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002ab:	e8 aa 11 00 00       	call   80145a <sys_env_exit>
}
  8002b0:	90                   	nop
  8002b1:	c9                   	leave  
  8002b2:	c3                   	ret    

008002b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8002bc:	83 c0 04             	add    $0x4,%eax
  8002bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002c2:	a1 18 31 80 00       	mov    0x803118,%eax
  8002c7:	85 c0                	test   %eax,%eax
  8002c9:	74 16                	je     8002e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002cb:	a1 18 31 80 00       	mov    0x803118,%eax
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	50                   	push   %eax
  8002d4:	68 78 1f 80 00       	push   $0x801f78
  8002d9:	e8 77 02 00 00       	call   800555 <cprintf>
  8002de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e1:	a1 00 30 80 00       	mov    0x803000,%eax
  8002e6:	ff 75 0c             	pushl  0xc(%ebp)
  8002e9:	ff 75 08             	pushl  0x8(%ebp)
  8002ec:	50                   	push   %eax
  8002ed:	68 7d 1f 80 00       	push   $0x801f7d
  8002f2:	e8 5e 02 00 00       	call   800555 <cprintf>
  8002f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fd:	83 ec 08             	sub    $0x8,%esp
  800300:	ff 75 f4             	pushl  -0xc(%ebp)
  800303:	50                   	push   %eax
  800304:	e8 e1 01 00 00       	call   8004ea <vcprintf>
  800309:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	6a 00                	push   $0x0
  800311:	68 99 1f 80 00       	push   $0x801f99
  800316:	e8 cf 01 00 00       	call   8004ea <vcprintf>
  80031b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80031e:	e8 82 ff ff ff       	call   8002a5 <exit>

	// should not return here
	while (1) ;
  800323:	eb fe                	jmp    800323 <_panic+0x70>

00800325 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80032b:	a1 20 30 80 00       	mov    0x803020,%eax
  800330:	8b 50 74             	mov    0x74(%eax),%edx
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	39 c2                	cmp    %eax,%edx
  800338:	74 14                	je     80034e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80033a:	83 ec 04             	sub    $0x4,%esp
  80033d:	68 9c 1f 80 00       	push   $0x801f9c
  800342:	6a 26                	push   $0x26
  800344:	68 e8 1f 80 00       	push   $0x801fe8
  800349:	e8 65 ff ff ff       	call   8002b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80034e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800355:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80035c:	e9 b6 00 00 00       	jmp    800417 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800364:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	01 d0                	add    %edx,%eax
  800370:	8b 00                	mov    (%eax),%eax
  800372:	85 c0                	test   %eax,%eax
  800374:	75 08                	jne    80037e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800376:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800379:	e9 96 00 00 00       	jmp    800414 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80037e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800385:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80038c:	eb 5d                	jmp    8003eb <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80038e:	a1 20 30 80 00       	mov    0x803020,%eax
  800393:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800399:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80039c:	c1 e2 04             	shl    $0x4,%edx
  80039f:	01 d0                	add    %edx,%eax
  8003a1:	8a 40 04             	mov    0x4(%eax),%al
  8003a4:	84 c0                	test   %al,%al
  8003a6:	75 40                	jne    8003e8 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ad:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b6:	c1 e2 04             	shl    $0x4,%edx
  8003b9:	01 d0                	add    %edx,%eax
  8003bb:	8b 00                	mov    (%eax),%eax
  8003bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	01 c8                	add    %ecx,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003db:	39 c2                	cmp    %eax,%edx
  8003dd:	75 09                	jne    8003e8 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8003df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003e6:	eb 12                	jmp    8003fa <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e8:	ff 45 e8             	incl   -0x18(%ebp)
  8003eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f0:	8b 50 74             	mov    0x74(%eax),%edx
  8003f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f6:	39 c2                	cmp    %eax,%edx
  8003f8:	77 94                	ja     80038e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003fe:	75 14                	jne    800414 <CheckWSWithoutLastIndex+0xef>
			panic(
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	68 f4 1f 80 00       	push   $0x801ff4
  800408:	6a 3a                	push   $0x3a
  80040a:	68 e8 1f 80 00       	push   $0x801fe8
  80040f:	e8 9f fe ff ff       	call   8002b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800414:	ff 45 f0             	incl   -0x10(%ebp)
  800417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041d:	0f 8c 3e ff ff ff    	jl     800361 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800423:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800431:	eb 20                	jmp    800453 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800433:	a1 20 30 80 00       	mov    0x803020,%eax
  800438:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80043e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800441:	c1 e2 04             	shl    $0x4,%edx
  800444:	01 d0                	add    %edx,%eax
  800446:	8a 40 04             	mov    0x4(%eax),%al
  800449:	3c 01                	cmp    $0x1,%al
  80044b:	75 03                	jne    800450 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80044d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800450:	ff 45 e0             	incl   -0x20(%ebp)
  800453:	a1 20 30 80 00       	mov    0x803020,%eax
  800458:	8b 50 74             	mov    0x74(%eax),%edx
  80045b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80045e:	39 c2                	cmp    %eax,%edx
  800460:	77 d1                	ja     800433 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800465:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800468:	74 14                	je     80047e <CheckWSWithoutLastIndex+0x159>
		panic(
  80046a:	83 ec 04             	sub    $0x4,%esp
  80046d:	68 48 20 80 00       	push   $0x802048
  800472:	6a 44                	push   $0x44
  800474:	68 e8 1f 80 00       	push   $0x801fe8
  800479:	e8 35 fe ff ff       	call   8002b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80047e:	90                   	nop
  80047f:	c9                   	leave  
  800480:	c3                   	ret    

00800481 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	8d 48 01             	lea    0x1(%eax),%ecx
  80048f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800492:	89 0a                	mov    %ecx,(%edx)
  800494:	8b 55 08             	mov    0x8(%ebp),%edx
  800497:	88 d1                	mov    %dl,%cl
  800499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004aa:	75 2c                	jne    8004d8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004ac:	a0 24 30 80 00       	mov    0x803024,%al
  8004b1:	0f b6 c0             	movzbl %al,%eax
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 12                	mov    (%edx),%edx
  8004b9:	89 d1                	mov    %edx,%ecx
  8004bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004be:	83 c2 08             	add    $0x8,%edx
  8004c1:	83 ec 04             	sub    $0x4,%esp
  8004c4:	50                   	push   %eax
  8004c5:	51                   	push   %ecx
  8004c6:	52                   	push   %edx
  8004c7:	e8 e6 0e 00 00       	call   8013b2 <sys_cputs>
  8004cc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004db:	8b 40 04             	mov    0x4(%eax),%eax
  8004de:	8d 50 01             	lea    0x1(%eax),%edx
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004e7:	90                   	nop
  8004e8:	c9                   	leave  
  8004e9:	c3                   	ret    

008004ea <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004fa:	00 00 00 
	b.cnt = 0;
  8004fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800504:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800507:	ff 75 0c             	pushl  0xc(%ebp)
  80050a:	ff 75 08             	pushl  0x8(%ebp)
  80050d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800513:	50                   	push   %eax
  800514:	68 81 04 80 00       	push   $0x800481
  800519:	e8 11 02 00 00       	call   80072f <vprintfmt>
  80051e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800521:	a0 24 30 80 00       	mov    0x803024,%al
  800526:	0f b6 c0             	movzbl %al,%eax
  800529:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80052f:	83 ec 04             	sub    $0x4,%esp
  800532:	50                   	push   %eax
  800533:	52                   	push   %edx
  800534:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80053a:	83 c0 08             	add    $0x8,%eax
  80053d:	50                   	push   %eax
  80053e:	e8 6f 0e 00 00       	call   8013b2 <sys_cputs>
  800543:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800546:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80054d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800553:	c9                   	leave  
  800554:	c3                   	ret    

00800555 <cprintf>:

int cprintf(const char *fmt, ...) {
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80055b:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800562:	8d 45 0c             	lea    0xc(%ebp),%eax
  800565:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	ff 75 f4             	pushl  -0xc(%ebp)
  800571:	50                   	push   %eax
  800572:	e8 73 ff ff ff       	call   8004ea <vcprintf>
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800588:	e8 36 10 00 00       	call   8015c3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80058d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800590:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	ff 75 f4             	pushl  -0xc(%ebp)
  80059c:	50                   	push   %eax
  80059d:	e8 48 ff ff ff       	call   8004ea <vcprintf>
  8005a2:	83 c4 10             	add    $0x10,%esp
  8005a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005a8:	e8 30 10 00 00       	call   8015dd <sys_enable_interrupt>
	return cnt;
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	53                   	push   %ebx
  8005b6:	83 ec 14             	sub    $0x14,%esp
  8005b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005d0:	77 55                	ja     800627 <printnum+0x75>
  8005d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005d5:	72 05                	jb     8005dc <printnum+0x2a>
  8005d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005da:	77 4b                	ja     800627 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005dc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005df:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005e2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ea:	52                   	push   %edx
  8005eb:	50                   	push   %eax
  8005ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8005f2:	e8 a1 14 00 00       	call   801a98 <__udivdi3>
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	83 ec 04             	sub    $0x4,%esp
  8005fd:	ff 75 20             	pushl  0x20(%ebp)
  800600:	53                   	push   %ebx
  800601:	ff 75 18             	pushl  0x18(%ebp)
  800604:	52                   	push   %edx
  800605:	50                   	push   %eax
  800606:	ff 75 0c             	pushl  0xc(%ebp)
  800609:	ff 75 08             	pushl  0x8(%ebp)
  80060c:	e8 a1 ff ff ff       	call   8005b2 <printnum>
  800611:	83 c4 20             	add    $0x20,%esp
  800614:	eb 1a                	jmp    800630 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	ff 75 0c             	pushl  0xc(%ebp)
  80061c:	ff 75 20             	pushl  0x20(%ebp)
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	ff d0                	call   *%eax
  800624:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800627:	ff 4d 1c             	decl   0x1c(%ebp)
  80062a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80062e:	7f e6                	jg     800616 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800630:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800633:	bb 00 00 00 00       	mov    $0x0,%ebx
  800638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80063b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80063e:	53                   	push   %ebx
  80063f:	51                   	push   %ecx
  800640:	52                   	push   %edx
  800641:	50                   	push   %eax
  800642:	e8 61 15 00 00       	call   801ba8 <__umoddi3>
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	05 b4 22 80 00       	add    $0x8022b4,%eax
  80064f:	8a 00                	mov    (%eax),%al
  800651:	0f be c0             	movsbl %al,%eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	50                   	push   %eax
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	ff d0                	call   *%eax
  800660:	83 c4 10             	add    $0x10,%esp
}
  800663:	90                   	nop
  800664:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80066c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800670:	7e 1c                	jle    80068e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 50 08             	lea    0x8(%eax),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 10                	mov    %edx,(%eax)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	83 e8 08             	sub    $0x8,%eax
  800687:	8b 50 04             	mov    0x4(%eax),%edx
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	eb 40                	jmp    8006ce <getuint+0x65>
	else if (lflag)
  80068e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800692:	74 1e                	je     8006b2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	8d 50 04             	lea    0x4(%eax),%edx
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	89 10                	mov    %edx,(%eax)
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	83 e8 04             	sub    $0x4,%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b0:	eb 1c                	jmp    8006ce <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	89 10                	mov    %edx,(%eax)
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	8b 00                	mov    (%eax),%eax
  8006c4:	83 e8 04             	sub    $0x4,%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ce:	5d                   	pop    %ebp
  8006cf:	c3                   	ret    

008006d0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006d0:	55                   	push   %ebp
  8006d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006d7:	7e 1c                	jle    8006f5 <getint+0x25>
		return va_arg(*ap, long long);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 08             	lea    0x8(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 08             	sub    $0x8,%eax
  8006ee:	8b 50 04             	mov    0x4(%eax),%edx
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	eb 38                	jmp    80072d <getint+0x5d>
	else if (lflag)
  8006f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006f9:	74 1a                	je     800715 <getint+0x45>
		return va_arg(*ap, long);
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	8d 50 04             	lea    0x4(%eax),%edx
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	89 10                	mov    %edx,(%eax)
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	83 e8 04             	sub    $0x4,%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	99                   	cltd   
  800713:	eb 18                	jmp    80072d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	8d 50 04             	lea    0x4(%eax),%edx
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	89 10                	mov    %edx,(%eax)
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	83 e8 04             	sub    $0x4,%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	99                   	cltd   
}
  80072d:	5d                   	pop    %ebp
  80072e:	c3                   	ret    

0080072f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	56                   	push   %esi
  800733:	53                   	push   %ebx
  800734:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800737:	eb 17                	jmp    800750 <vprintfmt+0x21>
			if (ch == '\0')
  800739:	85 db                	test   %ebx,%ebx
  80073b:	0f 84 af 03 00 00    	je     800af0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	ff 75 0c             	pushl  0xc(%ebp)
  800747:	53                   	push   %ebx
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	ff d0                	call   *%eax
  80074d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800750:	8b 45 10             	mov    0x10(%ebp),%eax
  800753:	8d 50 01             	lea    0x1(%eax),%edx
  800756:	89 55 10             	mov    %edx,0x10(%ebp)
  800759:	8a 00                	mov    (%eax),%al
  80075b:	0f b6 d8             	movzbl %al,%ebx
  80075e:	83 fb 25             	cmp    $0x25,%ebx
  800761:	75 d6                	jne    800739 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800763:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800767:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80076e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800775:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80077c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800783:	8b 45 10             	mov    0x10(%ebp),%eax
  800786:	8d 50 01             	lea    0x1(%eax),%edx
  800789:	89 55 10             	mov    %edx,0x10(%ebp)
  80078c:	8a 00                	mov    (%eax),%al
  80078e:	0f b6 d8             	movzbl %al,%ebx
  800791:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800794:	83 f8 55             	cmp    $0x55,%eax
  800797:	0f 87 2b 03 00 00    	ja     800ac8 <vprintfmt+0x399>
  80079d:	8b 04 85 d8 22 80 00 	mov    0x8022d8(,%eax,4),%eax
  8007a4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007a6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007aa:	eb d7                	jmp    800783 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007ac:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007b0:	eb d1                	jmp    800783 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	c1 e0 02             	shl    $0x2,%eax
  8007c1:	01 d0                	add    %edx,%eax
  8007c3:	01 c0                	add    %eax,%eax
  8007c5:	01 d8                	add    %ebx,%eax
  8007c7:	83 e8 30             	sub    $0x30,%eax
  8007ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d0:	8a 00                	mov    (%eax),%al
  8007d2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007d5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007d8:	7e 3e                	jle    800818 <vprintfmt+0xe9>
  8007da:	83 fb 39             	cmp    $0x39,%ebx
  8007dd:	7f 39                	jg     800818 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007df:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007e2:	eb d5                	jmp    8007b9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	83 c0 04             	add    $0x4,%eax
  8007ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	83 e8 04             	sub    $0x4,%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007f8:	eb 1f                	jmp    800819 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fe:	79 83                	jns    800783 <vprintfmt+0x54>
				width = 0;
  800800:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800807:	e9 77 ff ff ff       	jmp    800783 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80080c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800813:	e9 6b ff ff ff       	jmp    800783 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800818:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800819:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081d:	0f 89 60 ff ff ff    	jns    800783 <vprintfmt+0x54>
				width = precision, precision = -1;
  800823:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800826:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800829:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800830:	e9 4e ff ff ff       	jmp    800783 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800835:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800838:	e9 46 ff ff ff       	jmp    800783 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	83 c0 04             	add    $0x4,%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	83 e8 04             	sub    $0x4,%eax
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	ff 75 0c             	pushl  0xc(%ebp)
  800854:	50                   	push   %eax
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	ff d0                	call   *%eax
  80085a:	83 c4 10             	add    $0x10,%esp
			break;
  80085d:	e9 89 02 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 c0 04             	add    $0x4,%eax
  800868:	89 45 14             	mov    %eax,0x14(%ebp)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	83 e8 04             	sub    $0x4,%eax
  800871:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800873:	85 db                	test   %ebx,%ebx
  800875:	79 02                	jns    800879 <vprintfmt+0x14a>
				err = -err;
  800877:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800879:	83 fb 64             	cmp    $0x64,%ebx
  80087c:	7f 0b                	jg     800889 <vprintfmt+0x15a>
  80087e:	8b 34 9d 20 21 80 00 	mov    0x802120(,%ebx,4),%esi
  800885:	85 f6                	test   %esi,%esi
  800887:	75 19                	jne    8008a2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800889:	53                   	push   %ebx
  80088a:	68 c5 22 80 00       	push   $0x8022c5
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	ff 75 08             	pushl  0x8(%ebp)
  800895:	e8 5e 02 00 00       	call   800af8 <printfmt>
  80089a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80089d:	e9 49 02 00 00       	jmp    800aeb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008a2:	56                   	push   %esi
  8008a3:	68 ce 22 80 00       	push   $0x8022ce
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	ff 75 08             	pushl  0x8(%ebp)
  8008ae:	e8 45 02 00 00       	call   800af8 <printfmt>
  8008b3:	83 c4 10             	add    $0x10,%esp
			break;
  8008b6:	e9 30 02 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	83 c0 04             	add    $0x4,%eax
  8008c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	83 e8 04             	sub    $0x4,%eax
  8008ca:	8b 30                	mov    (%eax),%esi
  8008cc:	85 f6                	test   %esi,%esi
  8008ce:	75 05                	jne    8008d5 <vprintfmt+0x1a6>
				p = "(null)";
  8008d0:	be d1 22 80 00       	mov    $0x8022d1,%esi
			if (width > 0 && padc != '-')
  8008d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d9:	7e 6d                	jle    800948 <vprintfmt+0x219>
  8008db:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008df:	74 67                	je     800948 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	50                   	push   %eax
  8008e8:	56                   	push   %esi
  8008e9:	e8 0c 03 00 00       	call   800bfa <strnlen>
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008f4:	eb 16                	jmp    80090c <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008f6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	50                   	push   %eax
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	ff d0                	call   *%eax
  800906:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800909:	ff 4d e4             	decl   -0x1c(%ebp)
  80090c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800910:	7f e4                	jg     8008f6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800912:	eb 34                	jmp    800948 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800914:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800918:	74 1c                	je     800936 <vprintfmt+0x207>
  80091a:	83 fb 1f             	cmp    $0x1f,%ebx
  80091d:	7e 05                	jle    800924 <vprintfmt+0x1f5>
  80091f:	83 fb 7e             	cmp    $0x7e,%ebx
  800922:	7e 12                	jle    800936 <vprintfmt+0x207>
					putch('?', putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	6a 3f                	push   $0x3f
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
  800934:	eb 0f                	jmp    800945 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	53                   	push   %ebx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800945:	ff 4d e4             	decl   -0x1c(%ebp)
  800948:	89 f0                	mov    %esi,%eax
  80094a:	8d 70 01             	lea    0x1(%eax),%esi
  80094d:	8a 00                	mov    (%eax),%al
  80094f:	0f be d8             	movsbl %al,%ebx
  800952:	85 db                	test   %ebx,%ebx
  800954:	74 24                	je     80097a <vprintfmt+0x24b>
  800956:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80095a:	78 b8                	js     800914 <vprintfmt+0x1e5>
  80095c:	ff 4d e0             	decl   -0x20(%ebp)
  80095f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800963:	79 af                	jns    800914 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800965:	eb 13                	jmp    80097a <vprintfmt+0x24b>
				putch(' ', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	6a 20                	push   $0x20
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
  800974:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800977:	ff 4d e4             	decl   -0x1c(%ebp)
  80097a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097e:	7f e7                	jg     800967 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800980:	e9 66 01 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 e8             	pushl  -0x18(%ebp)
  80098b:	8d 45 14             	lea    0x14(%ebp),%eax
  80098e:	50                   	push   %eax
  80098f:	e8 3c fd ff ff       	call   8006d0 <getint>
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80099d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a3:	85 d2                	test   %edx,%edx
  8009a5:	79 23                	jns    8009ca <vprintfmt+0x29b>
				putch('-', putdat);
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	6a 2d                	push   $0x2d
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	ff d0                	call   *%eax
  8009b4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009bd:	f7 d8                	neg    %eax
  8009bf:	83 d2 00             	adc    $0x0,%edx
  8009c2:	f7 da                	neg    %edx
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d1:	e9 bc 00 00 00       	jmp    800a92 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8009df:	50                   	push   %eax
  8009e0:	e8 84 fc ff ff       	call   800669 <getuint>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009f5:	e9 98 00 00 00       	jmp    800a92 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	6a 58                	push   $0x58
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	ff d0                	call   *%eax
  800a07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 0c             	pushl  0xc(%ebp)
  800a10:	6a 58                	push   $0x58
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	ff d0                	call   *%eax
  800a17:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1a:	83 ec 08             	sub    $0x8,%esp
  800a1d:	ff 75 0c             	pushl  0xc(%ebp)
  800a20:	6a 58                	push   $0x58
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	ff d0                	call   *%eax
  800a27:	83 c4 10             	add    $0x10,%esp
			break;
  800a2a:	e9 bc 00 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 30                	push   $0x30
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	ff 75 0c             	pushl  0xc(%ebp)
  800a45:	6a 78                	push   $0x78
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	ff d0                	call   *%eax
  800a4c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a52:	83 c0 04             	add    $0x4,%eax
  800a55:	89 45 14             	mov    %eax,0x14(%ebp)
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	83 e8 04             	sub    $0x4,%eax
  800a5e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a71:	eb 1f                	jmp    800a92 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 e8             	pushl  -0x18(%ebp)
  800a79:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7c:	50                   	push   %eax
  800a7d:	e8 e7 fb ff ff       	call   800669 <getuint>
  800a82:	83 c4 10             	add    $0x10,%esp
  800a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a8b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a92:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a99:	83 ec 04             	sub    $0x4,%esp
  800a9c:	52                   	push   %edx
  800a9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aa0:	50                   	push   %eax
  800aa1:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa4:	ff 75 f0             	pushl  -0x10(%ebp)
  800aa7:	ff 75 0c             	pushl  0xc(%ebp)
  800aaa:	ff 75 08             	pushl  0x8(%ebp)
  800aad:	e8 00 fb ff ff       	call   8005b2 <printnum>
  800ab2:	83 c4 20             	add    $0x20,%esp
			break;
  800ab5:	eb 34                	jmp    800aeb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	53                   	push   %ebx
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	ff d0                	call   *%eax
  800ac3:	83 c4 10             	add    $0x10,%esp
			break;
  800ac6:	eb 23                	jmp    800aeb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	6a 25                	push   $0x25
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	ff d0                	call   *%eax
  800ad5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad8:	ff 4d 10             	decl   0x10(%ebp)
  800adb:	eb 03                	jmp    800ae0 <vprintfmt+0x3b1>
  800add:	ff 4d 10             	decl   0x10(%ebp)
  800ae0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae3:	48                   	dec    %eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	3c 25                	cmp    $0x25,%al
  800ae8:	75 f3                	jne    800add <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aea:	90                   	nop
		}
	}
  800aeb:	e9 47 fc ff ff       	jmp    800737 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800af0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800af1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800af4:	5b                   	pop    %ebx
  800af5:	5e                   	pop    %esi
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    

00800af8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800afe:	8d 45 10             	lea    0x10(%ebp),%eax
  800b01:	83 c0 04             	add    $0x4,%eax
  800b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b07:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0d:	50                   	push   %eax
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	ff 75 08             	pushl  0x8(%ebp)
  800b14:	e8 16 fc ff ff       	call   80072f <vprintfmt>
  800b19:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b1c:	90                   	nop
  800b1d:	c9                   	leave  
  800b1e:	c3                   	ret    

00800b1f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8b 40 08             	mov    0x8(%eax),%eax
  800b28:	8d 50 01             	lea    0x1(%eax),%edx
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8b 10                	mov    (%eax),%edx
  800b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b39:	8b 40 04             	mov    0x4(%eax),%eax
  800b3c:	39 c2                	cmp    %eax,%edx
  800b3e:	73 12                	jae    800b52 <sprintputch+0x33>
		*b->buf++ = ch;
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	8b 00                	mov    (%eax),%eax
  800b45:	8d 48 01             	lea    0x1(%eax),%ecx
  800b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4b:	89 0a                	mov    %ecx,(%edx)
  800b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b50:	88 10                	mov    %dl,(%eax)
}
  800b52:	90                   	nop
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	01 d0                	add    %edx,%eax
  800b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b7a:	74 06                	je     800b82 <vsnprintf+0x2d>
  800b7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b80:	7f 07                	jg     800b89 <vsnprintf+0x34>
		return -E_INVAL;
  800b82:	b8 03 00 00 00       	mov    $0x3,%eax
  800b87:	eb 20                	jmp    800ba9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b89:	ff 75 14             	pushl  0x14(%ebp)
  800b8c:	ff 75 10             	pushl  0x10(%ebp)
  800b8f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b92:	50                   	push   %eax
  800b93:	68 1f 0b 80 00       	push   $0x800b1f
  800b98:	e8 92 fb ff ff       	call   80072f <vprintfmt>
  800b9d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ba3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bb1:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb4:	83 c0 04             	add    $0x4,%eax
  800bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bba:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc0:	50                   	push   %eax
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	ff 75 08             	pushl  0x8(%ebp)
  800bc7:	e8 89 ff ff ff       	call   800b55 <vsnprintf>
  800bcc:	83 c4 10             	add    $0x10,%esp
  800bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be4:	eb 06                	jmp    800bec <strlen+0x15>
		n++;
  800be6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800be9:	ff 45 08             	incl   0x8(%ebp)
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8a 00                	mov    (%eax),%al
  800bf1:	84 c0                	test   %al,%al
  800bf3:	75 f1                	jne    800be6 <strlen+0xf>
		n++;
	return n;
  800bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf8:	c9                   	leave  
  800bf9:	c3                   	ret    

00800bfa <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c07:	eb 09                	jmp    800c12 <strnlen+0x18>
		n++;
  800c09:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c0c:	ff 45 08             	incl   0x8(%ebp)
  800c0f:	ff 4d 0c             	decl   0xc(%ebp)
  800c12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c16:	74 09                	je     800c21 <strnlen+0x27>
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	84 c0                	test   %al,%al
  800c1f:	75 e8                	jne    800c09 <strnlen+0xf>
		n++;
	return n;
  800c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c32:	90                   	nop
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8d 50 01             	lea    0x1(%eax),%edx
  800c39:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c42:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c45:	8a 12                	mov    (%edx),%dl
  800c47:	88 10                	mov    %dl,(%eax)
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	84 c0                	test   %al,%al
  800c4d:	75 e4                	jne    800c33 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c67:	eb 1f                	jmp    800c88 <strncpy+0x34>
		*dst++ = *src;
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8d 50 01             	lea    0x1(%eax),%edx
  800c6f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	84 c0                	test   %al,%al
  800c80:	74 03                	je     800c85 <strncpy+0x31>
			src++;
  800c82:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c85:	ff 45 fc             	incl   -0x4(%ebp)
  800c88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c8e:	72 d9                	jb     800c69 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c90:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ca1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca5:	74 30                	je     800cd7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ca7:	eb 16                	jmp    800cbf <strlcpy+0x2a>
			*dst++ = *src++;
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8d 50 01             	lea    0x1(%eax),%edx
  800caf:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cbb:	8a 12                	mov    (%edx),%dl
  800cbd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cbf:	ff 4d 10             	decl   0x10(%ebp)
  800cc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc6:	74 09                	je     800cd1 <strlcpy+0x3c>
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	84 c0                	test   %al,%al
  800ccf:	75 d8                	jne    800ca9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cdd:	29 c2                	sub    %eax,%edx
  800cdf:	89 d0                	mov    %edx,%eax
}
  800ce1:	c9                   	leave  
  800ce2:	c3                   	ret    

00800ce3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ce6:	eb 06                	jmp    800cee <strcmp+0xb>
		p++, q++;
  800ce8:	ff 45 08             	incl   0x8(%ebp)
  800ceb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	84 c0                	test   %al,%al
  800cf5:	74 0e                	je     800d05 <strcmp+0x22>
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8a 10                	mov    (%eax),%dl
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	38 c2                	cmp    %al,%dl
  800d03:	74 e3                	je     800ce8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	0f b6 d0             	movzbl %al,%edx
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	0f b6 c0             	movzbl %al,%eax
  800d15:	29 c2                	sub    %eax,%edx
  800d17:	89 d0                	mov    %edx,%eax
}
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d1e:	eb 09                	jmp    800d29 <strncmp+0xe>
		n--, p++, q++;
  800d20:	ff 4d 10             	decl   0x10(%ebp)
  800d23:	ff 45 08             	incl   0x8(%ebp)
  800d26:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2d:	74 17                	je     800d46 <strncmp+0x2b>
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	84 c0                	test   %al,%al
  800d36:	74 0e                	je     800d46 <strncmp+0x2b>
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 10                	mov    (%eax),%dl
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	38 c2                	cmp    %al,%dl
  800d44:	74 da                	je     800d20 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4a:	75 07                	jne    800d53 <strncmp+0x38>
		return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d51:	eb 14                	jmp    800d67 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	0f b6 d0             	movzbl %al,%edx
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	0f b6 c0             	movzbl %al,%eax
  800d63:	29 c2                	sub    %eax,%edx
  800d65:	89 d0                	mov    %edx,%eax
}
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d75:	eb 12                	jmp    800d89 <strchr+0x20>
		if (*s == c)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7f:	75 05                	jne    800d86 <strchr+0x1d>
			return (char *) s;
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	eb 11                	jmp    800d97 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d86:	ff 45 08             	incl   0x8(%ebp)
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	75 e5                	jne    800d77 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d97:	c9                   	leave  
  800d98:	c3                   	ret    

00800d99 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 04             	sub    $0x4,%esp
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da5:	eb 0d                	jmp    800db4 <strfind+0x1b>
		if (*s == c)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800daf:	74 0e                	je     800dbf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	75 ea                	jne    800da7 <strfind+0xe>
  800dbd:	eb 01                	jmp    800dc0 <strfind+0x27>
		if (*s == c)
			break;
  800dbf:	90                   	nop
	return (char *) s;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dd7:	eb 0e                	jmp    800de7 <memset+0x22>
		*p++ = c;
  800dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800de7:	ff 4d f8             	decl   -0x8(%ebp)
  800dea:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dee:	79 e9                	jns    800dd9 <memset+0x14>
		*p++ = c;

	return v;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e07:	eb 16                	jmp    800e1f <memcpy+0x2a>
		*d++ = *s++;
  800e09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0c:	8d 50 01             	lea    0x1(%eax),%edx
  800e0f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e18:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e1b:	8a 12                	mov    (%edx),%dl
  800e1d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e25:	89 55 10             	mov    %edx,0x10(%ebp)
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	75 dd                	jne    800e09 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    

00800e31 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e49:	73 50                	jae    800e9b <memmove+0x6a>
  800e4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e51:	01 d0                	add    %edx,%eax
  800e53:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e56:	76 43                	jbe    800e9b <memmove+0x6a>
		s += n;
  800e58:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e61:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e64:	eb 10                	jmp    800e76 <memmove+0x45>
			*--d = *--s;
  800e66:	ff 4d f8             	decl   -0x8(%ebp)
  800e69:	ff 4d fc             	decl   -0x4(%ebp)
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6f:	8a 10                	mov    (%eax),%dl
  800e71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e74:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e76:	8b 45 10             	mov    0x10(%ebp),%eax
  800e79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	75 e3                	jne    800e66 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e83:	eb 23                	jmp    800ea8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e88:	8d 50 01             	lea    0x1(%eax),%edx
  800e8b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e91:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e94:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e97:	8a 12                	mov    (%edx),%dl
  800e99:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	75 dd                	jne    800e85 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ebf:	eb 2a                	jmp    800eeb <memcmp+0x3e>
		if (*s1 != *s2)
  800ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec4:	8a 10                	mov    (%eax),%dl
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	38 c2                	cmp    %al,%dl
  800ecd:	74 16                	je     800ee5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	0f b6 d0             	movzbl %al,%edx
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	0f b6 c0             	movzbl %al,%eax
  800edf:	29 c2                	sub    %eax,%edx
  800ee1:	89 d0                	mov    %edx,%eax
  800ee3:	eb 18                	jmp    800efd <memcmp+0x50>
		s1++, s2++;
  800ee5:	ff 45 fc             	incl   -0x4(%ebp)
  800ee8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800eee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	75 c9                	jne    800ec1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ef8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efd:	c9                   	leave  
  800efe:	c3                   	ret    

00800eff <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f05:	8b 55 08             	mov    0x8(%ebp),%edx
  800f08:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0b:	01 d0                	add    %edx,%eax
  800f0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f10:	eb 15                	jmp    800f27 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	0f b6 d0             	movzbl %al,%edx
  800f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1d:	0f b6 c0             	movzbl %al,%eax
  800f20:	39 c2                	cmp    %eax,%edx
  800f22:	74 0d                	je     800f31 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f24:	ff 45 08             	incl   0x8(%ebp)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f2d:	72 e3                	jb     800f12 <memfind+0x13>
  800f2f:	eb 01                	jmp    800f32 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f31:	90                   	nop
	return (void *) s;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f44:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f4b:	eb 03                	jmp    800f50 <strtol+0x19>
		s++;
  800f4d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 20                	cmp    $0x20,%al
  800f57:	74 f4                	je     800f4d <strtol+0x16>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 09                	cmp    $0x9,%al
  800f60:	74 eb                	je     800f4d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	3c 2b                	cmp    $0x2b,%al
  800f69:	75 05                	jne    800f70 <strtol+0x39>
		s++;
  800f6b:	ff 45 08             	incl   0x8(%ebp)
  800f6e:	eb 13                	jmp    800f83 <strtol+0x4c>
	else if (*s == '-')
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 2d                	cmp    $0x2d,%al
  800f77:	75 0a                	jne    800f83 <strtol+0x4c>
		s++, neg = 1;
  800f79:	ff 45 08             	incl   0x8(%ebp)
  800f7c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f87:	74 06                	je     800f8f <strtol+0x58>
  800f89:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f8d:	75 20                	jne    800faf <strtol+0x78>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 30                	cmp    $0x30,%al
  800f96:	75 17                	jne    800faf <strtol+0x78>
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	40                   	inc    %eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 78                	cmp    $0x78,%al
  800fa0:	75 0d                	jne    800faf <strtol+0x78>
		s += 2, base = 16;
  800fa2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fa6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fad:	eb 28                	jmp    800fd7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800faf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb3:	75 15                	jne    800fca <strtol+0x93>
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 30                	cmp    $0x30,%al
  800fbc:	75 0c                	jne    800fca <strtol+0x93>
		s++, base = 8;
  800fbe:	ff 45 08             	incl   0x8(%ebp)
  800fc1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fc8:	eb 0d                	jmp    800fd7 <strtol+0xa0>
	else if (base == 0)
  800fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fce:	75 07                	jne    800fd7 <strtol+0xa0>
		base = 10;
  800fd0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 2f                	cmp    $0x2f,%al
  800fde:	7e 19                	jle    800ff9 <strtol+0xc2>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 39                	cmp    $0x39,%al
  800fe7:	7f 10                	jg     800ff9 <strtol+0xc2>
			dig = *s - '0';
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f be c0             	movsbl %al,%eax
  800ff1:	83 e8 30             	sub    $0x30,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff7:	eb 42                	jmp    80103b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 60                	cmp    $0x60,%al
  801000:	7e 19                	jle    80101b <strtol+0xe4>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 7a                	cmp    $0x7a,%al
  801009:	7f 10                	jg     80101b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	0f be c0             	movsbl %al,%eax
  801013:	83 e8 57             	sub    $0x57,%eax
  801016:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801019:	eb 20                	jmp    80103b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	3c 40                	cmp    $0x40,%al
  801022:	7e 39                	jle    80105d <strtol+0x126>
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	3c 5a                	cmp    $0x5a,%al
  80102b:	7f 30                	jg     80105d <strtol+0x126>
			dig = *s - 'A' + 10;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	0f be c0             	movsbl %al,%eax
  801035:	83 e8 37             	sub    $0x37,%eax
  801038:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80103b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801041:	7d 19                	jge    80105c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801049:	0f af 45 10          	imul   0x10(%ebp),%eax
  80104d:	89 c2                	mov    %eax,%edx
  80104f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801052:	01 d0                	add    %edx,%eax
  801054:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801057:	e9 7b ff ff ff       	jmp    800fd7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80105c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80105d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801061:	74 08                	je     80106b <strtol+0x134>
		*endptr = (char *) s;
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80106b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80106f:	74 07                	je     801078 <strtol+0x141>
  801071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801074:	f7 d8                	neg    %eax
  801076:	eb 03                	jmp    80107b <strtol+0x144>
  801078:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    

0080107d <ltostr>:

void
ltostr(long value, char *str)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801083:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80108a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801095:	79 13                	jns    8010aa <ltostr+0x2d>
	{
		neg = 1;
  801097:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80109e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010a4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010a7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010b2:	99                   	cltd   
  8010b3:	f7 f9                	idiv   %ecx
  8010b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bb:	8d 50 01             	lea    0x1(%eax),%edx
  8010be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c6:	01 d0                	add    %edx,%eax
  8010c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010cb:	83 c2 30             	add    $0x30,%edx
  8010ce:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d8:	f7 e9                	imul   %ecx
  8010da:	c1 fa 02             	sar    $0x2,%edx
  8010dd:	89 c8                	mov    %ecx,%eax
  8010df:	c1 f8 1f             	sar    $0x1f,%eax
  8010e2:	29 c2                	sub    %eax,%edx
  8010e4:	89 d0                	mov    %edx,%eax
  8010e6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ec:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f1:	f7 e9                	imul   %ecx
  8010f3:	c1 fa 02             	sar    $0x2,%edx
  8010f6:	89 c8                	mov    %ecx,%eax
  8010f8:	c1 f8 1f             	sar    $0x1f,%eax
  8010fb:	29 c2                	sub    %eax,%edx
  8010fd:	89 d0                	mov    %edx,%eax
  8010ff:	c1 e0 02             	shl    $0x2,%eax
  801102:	01 d0                	add    %edx,%eax
  801104:	01 c0                	add    %eax,%eax
  801106:	29 c1                	sub    %eax,%ecx
  801108:	89 ca                	mov    %ecx,%edx
  80110a:	85 d2                	test   %edx,%edx
  80110c:	75 9c                	jne    8010aa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80110e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801115:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801118:	48                   	dec    %eax
  801119:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80111c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801120:	74 3d                	je     80115f <ltostr+0xe2>
		start = 1 ;
  801122:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801129:	eb 34                	jmp    80115f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80112b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801131:	01 d0                	add    %edx,%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	01 c2                	add    %eax,%edx
  801140:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 c8                	add    %ecx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80114c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	01 c2                	add    %eax,%edx
  801154:	8a 45 eb             	mov    -0x15(%ebp),%al
  801157:	88 02                	mov    %al,(%edx)
		start++ ;
  801159:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80115c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80115f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801162:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801165:	7c c4                	jl     80112b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801167:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80116a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116d:	01 d0                	add    %edx,%eax
  80116f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801172:	90                   	nop
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80117b:	ff 75 08             	pushl  0x8(%ebp)
  80117e:	e8 54 fa ff ff       	call   800bd7 <strlen>
  801183:	83 c4 04             	add    $0x4,%esp
  801186:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801189:	ff 75 0c             	pushl  0xc(%ebp)
  80118c:	e8 46 fa ff ff       	call   800bd7 <strlen>
  801191:	83 c4 04             	add    $0x4,%esp
  801194:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801197:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80119e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011a5:	eb 17                	jmp    8011be <strcconcat+0x49>
		final[s] = str1[s] ;
  8011a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ad:	01 c2                	add    %eax,%edx
  8011af:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	01 c8                	add    %ecx,%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011bb:	ff 45 fc             	incl   -0x4(%ebp)
  8011be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011c4:	7c e1                	jl     8011a7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011d4:	eb 1f                	jmp    8011f5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d9:	8d 50 01             	lea    0x1(%eax),%edx
  8011dc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011df:	89 c2                	mov    %eax,%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 c2                	add    %eax,%edx
  8011e6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ec:	01 c8                	add    %ecx,%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011f2:	ff 45 f8             	incl   -0x8(%ebp)
  8011f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011fb:	7c d9                	jl     8011d6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801200:	8b 45 10             	mov    0x10(%ebp),%eax
  801203:	01 d0                	add    %edx,%eax
  801205:	c6 00 00             	movb   $0x0,(%eax)
}
  801208:	90                   	nop
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80120e:	8b 45 14             	mov    0x14(%ebp),%eax
  801211:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801217:	8b 45 14             	mov    0x14(%ebp),%eax
  80121a:	8b 00                	mov    (%eax),%eax
  80121c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801223:	8b 45 10             	mov    0x10(%ebp),%eax
  801226:	01 d0                	add    %edx,%eax
  801228:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80122e:	eb 0c                	jmp    80123c <strsplit+0x31>
			*string++ = 0;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8d 50 01             	lea    0x1(%eax),%edx
  801236:	89 55 08             	mov    %edx,0x8(%ebp)
  801239:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	84 c0                	test   %al,%al
  801243:	74 18                	je     80125d <strsplit+0x52>
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	0f be c0             	movsbl %al,%eax
  80124d:	50                   	push   %eax
  80124e:	ff 75 0c             	pushl  0xc(%ebp)
  801251:	e8 13 fb ff ff       	call   800d69 <strchr>
  801256:	83 c4 08             	add    $0x8,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	75 d3                	jne    801230 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	84 c0                	test   %al,%al
  801264:	74 5a                	je     8012c0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801266:	8b 45 14             	mov    0x14(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	83 f8 0f             	cmp    $0xf,%eax
  80126e:	75 07                	jne    801277 <strsplit+0x6c>
		{
			return 0;
  801270:	b8 00 00 00 00       	mov    $0x0,%eax
  801275:	eb 66                	jmp    8012dd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	8d 48 01             	lea    0x1(%eax),%ecx
  80127f:	8b 55 14             	mov    0x14(%ebp),%edx
  801282:	89 0a                	mov    %ecx,(%edx)
  801284:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80128b:	8b 45 10             	mov    0x10(%ebp),%eax
  80128e:	01 c2                	add    %eax,%edx
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801295:	eb 03                	jmp    80129a <strsplit+0x8f>
			string++;
  801297:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	8a 00                	mov    (%eax),%al
  80129f:	84 c0                	test   %al,%al
  8012a1:	74 8b                	je     80122e <strsplit+0x23>
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	0f be c0             	movsbl %al,%eax
  8012ab:	50                   	push   %eax
  8012ac:	ff 75 0c             	pushl  0xc(%ebp)
  8012af:	e8 b5 fa ff ff       	call   800d69 <strchr>
  8012b4:	83 c4 08             	add    $0x8,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	74 dc                	je     801297 <strsplit+0x8c>
			string++;
	}
  8012bb:	e9 6e ff ff ff       	jmp    80122e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012c0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c4:	8b 00                	mov    (%eax),%eax
  8012c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012d8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8012e5:	83 ec 04             	sub    $0x4,%esp
  8012e8:	68 30 24 80 00       	push   $0x802430
  8012ed:	6a 19                	push   $0x19
  8012ef:	68 55 24 80 00       	push   $0x802455
  8012f4:	e8 ba ef ff ff       	call   8002b3 <_panic>

008012f9 <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	83 ec 18             	sub    $0x18,%esp
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801305:	83 ec 04             	sub    $0x4,%esp
  801308:	68 64 24 80 00       	push   $0x802464
  80130d:	6a 31                	push   $0x31
  80130f:	68 55 24 80 00       	push   $0x802455
  801314:	e8 9a ef ff ff       	call   8002b3 <_panic>

00801319 <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80131f:	83 ec 04             	sub    $0x4,%esp
  801322:	68 8c 24 80 00       	push   $0x80248c
  801327:	6a 4a                	push   $0x4a
  801329:	68 55 24 80 00       	push   $0x802455
  80132e:	e8 80 ef ff ff       	call   8002b3 <_panic>

00801333 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801339:	83 ec 04             	sub    $0x4,%esp
  80133c:	68 b0 24 80 00       	push   $0x8024b0
  801341:	6a 70                	push   $0x70
  801343:	68 55 24 80 00       	push   $0x802455
  801348:	e8 66 ef ff ff       	call   8002b3 <_panic>

0080134d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801353:	83 ec 04             	sub    $0x4,%esp
  801356:	68 d4 24 80 00       	push   $0x8024d4
  80135b:	68 8b 00 00 00       	push   $0x8b
  801360:	68 55 24 80 00       	push   $0x802455
  801365:	e8 49 ef ff ff       	call   8002b3 <_panic>

0080136a <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801370:	83 ec 04             	sub    $0x4,%esp
  801373:	68 f8 24 80 00       	push   $0x8024f8
  801378:	68 a8 00 00 00       	push   $0xa8
  80137d:	68 55 24 80 00       	push   $0x802455
  801382:	e8 2c ef ff ff       	call   8002b3 <_panic>

00801387 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	57                   	push   %edi
  80138b:	56                   	push   %esi
  80138c:	53                   	push   %ebx
  80138d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8b 55 0c             	mov    0xc(%ebp),%edx
  801396:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801399:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80139c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80139f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013a2:	cd 30                	int    $0x30
  8013a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8013a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013aa:	83 c4 10             	add    $0x10,%esp
  8013ad:	5b                   	pop    %ebx
  8013ae:	5e                   	pop    %esi
  8013af:	5f                   	pop    %edi
  8013b0:	5d                   	pop    %ebp
  8013b1:	c3                   	ret    

008013b2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
  8013b5:	83 ec 04             	sub    $0x4,%esp
  8013b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8013be:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	52                   	push   %edx
  8013ca:	ff 75 0c             	pushl  0xc(%ebp)
  8013cd:	50                   	push   %eax
  8013ce:	6a 00                	push   $0x0
  8013d0:	e8 b2 ff ff ff       	call   801387 <syscall>
  8013d5:	83 c4 18             	add    $0x18,%esp
}
  8013d8:	90                   	nop
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <sys_cgetc>:

int
sys_cgetc(void)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 01                	push   $0x1
  8013ea:	e8 98 ff ff ff       	call   801387 <syscall>
  8013ef:	83 c4 18             	add    $0x18,%esp
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	50                   	push   %eax
  801403:	6a 05                	push   $0x5
  801405:	e8 7d ff ff ff       	call   801387 <syscall>
  80140a:	83 c4 18             	add    $0x18,%esp
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 02                	push   $0x2
  80141e:	e8 64 ff ff ff       	call   801387 <syscall>
  801423:	83 c4 18             	add    $0x18,%esp
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 03                	push   $0x3
  801437:	e8 4b ff ff ff       	call   801387 <syscall>
  80143c:	83 c4 18             	add    $0x18,%esp
}
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 04                	push   $0x4
  801450:	e8 32 ff ff ff       	call   801387 <syscall>
  801455:	83 c4 18             	add    $0x18,%esp
}
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <sys_env_exit>:


void sys_env_exit(void)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 06                	push   $0x6
  801469:	e8 19 ff ff ff       	call   801387 <syscall>
  80146e:	83 c4 18             	add    $0x18,%esp
}
  801471:	90                   	nop
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801477:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	52                   	push   %edx
  801484:	50                   	push   %eax
  801485:	6a 07                	push   $0x7
  801487:	e8 fb fe ff ff       	call   801387 <syscall>
  80148c:	83 c4 18             	add    $0x18,%esp
}
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	56                   	push   %esi
  801495:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801496:	8b 75 18             	mov    0x18(%ebp),%esi
  801499:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80149c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80149f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	56                   	push   %esi
  8014a6:	53                   	push   %ebx
  8014a7:	51                   	push   %ecx
  8014a8:	52                   	push   %edx
  8014a9:	50                   	push   %eax
  8014aa:	6a 08                	push   $0x8
  8014ac:	e8 d6 fe ff ff       	call   801387 <syscall>
  8014b1:	83 c4 18             	add    $0x18,%esp
}
  8014b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014b7:	5b                   	pop    %ebx
  8014b8:	5e                   	pop    %esi
  8014b9:	5d                   	pop    %ebp
  8014ba:	c3                   	ret    

008014bb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	52                   	push   %edx
  8014cb:	50                   	push   %eax
  8014cc:	6a 09                	push   $0x9
  8014ce:	e8 b4 fe ff ff       	call   801387 <syscall>
  8014d3:	83 c4 18             	add    $0x18,%esp
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	ff 75 08             	pushl  0x8(%ebp)
  8014e7:	6a 0a                	push   $0xa
  8014e9:	e8 99 fe ff ff       	call   801387 <syscall>
  8014ee:	83 c4 18             	add    $0x18,%esp
}
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 0b                	push   $0xb
  801502:	e8 80 fe ff ff       	call   801387 <syscall>
  801507:	83 c4 18             	add    $0x18,%esp
}
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 0c                	push   $0xc
  80151b:	e8 67 fe ff ff       	call   801387 <syscall>
  801520:	83 c4 18             	add    $0x18,%esp
}
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 0d                	push   $0xd
  801534:	e8 4e fe ff ff       	call   801387 <syscall>
  801539:	83 c4 18             	add    $0x18,%esp
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	ff 75 0c             	pushl  0xc(%ebp)
  80154a:	ff 75 08             	pushl  0x8(%ebp)
  80154d:	6a 11                	push   $0x11
  80154f:	e8 33 fe ff ff       	call   801387 <syscall>
  801554:	83 c4 18             	add    $0x18,%esp
	return;
  801557:	90                   	nop
}
  801558:	c9                   	leave  
  801559:	c3                   	ret    

0080155a <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	ff 75 0c             	pushl  0xc(%ebp)
  801566:	ff 75 08             	pushl  0x8(%ebp)
  801569:	6a 12                	push   $0x12
  80156b:	e8 17 fe ff ff       	call   801387 <syscall>
  801570:	83 c4 18             	add    $0x18,%esp
	return ;
  801573:	90                   	nop
}
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 0e                	push   $0xe
  801585:	e8 fd fd ff ff       	call   801387 <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	ff 75 08             	pushl  0x8(%ebp)
  80159d:	6a 0f                	push   $0xf
  80159f:	e8 e3 fd ff ff       	call   801387 <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 10                	push   $0x10
  8015b8:	e8 ca fd ff ff       	call   801387 <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
}
  8015c0:	90                   	nop
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 14                	push   $0x14
  8015d2:	e8 b0 fd ff ff       	call   801387 <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	90                   	nop
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 15                	push   $0x15
  8015ec:	e8 96 fd ff ff       	call   801387 <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
}
  8015f4:	90                   	nop
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 04             	sub    $0x4,%esp
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801603:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	50                   	push   %eax
  801610:	6a 16                	push   $0x16
  801612:	e8 70 fd ff ff       	call   801387 <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
}
  80161a:	90                   	nop
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 17                	push   $0x17
  80162c:	e8 56 fd ff ff       	call   801387 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
}
  801634:	90                   	nop
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	ff 75 0c             	pushl  0xc(%ebp)
  801646:	50                   	push   %eax
  801647:	6a 18                	push   $0x18
  801649:	e8 39 fd ff ff       	call   801387 <syscall>
  80164e:	83 c4 18             	add    $0x18,%esp
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801656:	8b 55 0c             	mov    0xc(%ebp),%edx
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	52                   	push   %edx
  801663:	50                   	push   %eax
  801664:	6a 1b                	push   $0x1b
  801666:	e8 1c fd ff ff       	call   801387 <syscall>
  80166b:	83 c4 18             	add    $0x18,%esp
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801673:	8b 55 0c             	mov    0xc(%ebp),%edx
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	52                   	push   %edx
  801680:	50                   	push   %eax
  801681:	6a 19                	push   $0x19
  801683:	e8 ff fc ff ff       	call   801387 <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
}
  80168b:	90                   	nop
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801691:	8b 55 0c             	mov    0xc(%ebp),%edx
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	52                   	push   %edx
  80169e:	50                   	push   %eax
  80169f:	6a 1a                	push   $0x1a
  8016a1:	e8 e1 fc ff ff       	call   801387 <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	90                   	nop
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 04             	sub    $0x4,%esp
  8016b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016b8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016bb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	6a 00                	push   $0x0
  8016c4:	51                   	push   %ecx
  8016c5:	52                   	push   %edx
  8016c6:	ff 75 0c             	pushl  0xc(%ebp)
  8016c9:	50                   	push   %eax
  8016ca:	6a 1c                	push   $0x1c
  8016cc:	e8 b6 fc ff ff       	call   801387 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	52                   	push   %edx
  8016e6:	50                   	push   %eax
  8016e7:	6a 1d                	push   $0x1d
  8016e9:	e8 99 fc ff ff       	call   801387 <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	51                   	push   %ecx
  801704:	52                   	push   %edx
  801705:	50                   	push   %eax
  801706:	6a 1e                	push   $0x1e
  801708:	e8 7a fc ff ff       	call   801387 <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801715:	8b 55 0c             	mov    0xc(%ebp),%edx
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	52                   	push   %edx
  801722:	50                   	push   %eax
  801723:	6a 1f                	push   $0x1f
  801725:	e8 5d fc ff ff       	call   801387 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 20                	push   $0x20
  80173e:	e8 44 fc ff ff       	call   801387 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	ff 75 10             	pushl  0x10(%ebp)
  801755:	ff 75 0c             	pushl  0xc(%ebp)
  801758:	50                   	push   %eax
  801759:	6a 21                	push   $0x21
  80175b:	e8 27 fc ff ff       	call   801387 <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	50                   	push   %eax
  801774:	6a 22                	push   $0x22
  801776:	e8 0c fc ff ff       	call   801387 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	90                   	nop
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	50                   	push   %eax
  801790:	6a 23                	push   $0x23
  801792:	e8 f0 fb ff ff       	call   801387 <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	90                   	nop
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017a3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017a6:	8d 50 04             	lea    0x4(%eax),%edx
  8017a9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	52                   	push   %edx
  8017b3:	50                   	push   %eax
  8017b4:	6a 24                	push   $0x24
  8017b6:	e8 cc fb ff ff       	call   801387 <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
	return result;
  8017be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c7:	89 01                	mov    %eax,(%ecx)
  8017c9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	c9                   	leave  
  8017d0:	c2 04 00             	ret    $0x4

008017d3 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	ff 75 10             	pushl  0x10(%ebp)
  8017dd:	ff 75 0c             	pushl  0xc(%ebp)
  8017e0:	ff 75 08             	pushl  0x8(%ebp)
  8017e3:	6a 13                	push   $0x13
  8017e5:	e8 9d fb ff ff       	call   801387 <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ed:	90                   	nop
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 25                	push   $0x25
  8017ff:	e8 83 fb ff ff       	call   801387 <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801815:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	50                   	push   %eax
  801822:	6a 26                	push   $0x26
  801824:	e8 5e fb ff ff       	call   801387 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
	return ;
  80182c:	90                   	nop
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <rsttst>:
void rsttst()
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 28                	push   $0x28
  80183e:	e8 44 fb ff ff       	call   801387 <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
	return ;
  801846:	90                   	nop
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 04             	sub    $0x4,%esp
  80184f:	8b 45 14             	mov    0x14(%ebp),%eax
  801852:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801855:	8b 55 18             	mov    0x18(%ebp),%edx
  801858:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80185c:	52                   	push   %edx
  80185d:	50                   	push   %eax
  80185e:	ff 75 10             	pushl  0x10(%ebp)
  801861:	ff 75 0c             	pushl  0xc(%ebp)
  801864:	ff 75 08             	pushl  0x8(%ebp)
  801867:	6a 27                	push   $0x27
  801869:	e8 19 fb ff ff       	call   801387 <syscall>
  80186e:	83 c4 18             	add    $0x18,%esp
	return ;
  801871:	90                   	nop
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <chktst>:
void chktst(uint32 n)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	ff 75 08             	pushl  0x8(%ebp)
  801882:	6a 29                	push   $0x29
  801884:	e8 fe fa ff ff       	call   801387 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
	return ;
  80188c:	90                   	nop
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <inctst>:

void inctst()
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 2a                	push   $0x2a
  80189e:	e8 e4 fa ff ff       	call   801387 <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a6:	90                   	nop
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <gettst>:
uint32 gettst()
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 2b                	push   $0x2b
  8018b8:	e8 ca fa ff ff       	call   801387 <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 2c                	push   $0x2c
  8018d4:	e8 ae fa ff ff       	call   801387 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
  8018dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018df:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018e3:	75 07                	jne    8018ec <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ea:	eb 05                	jmp    8018f1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 2c                	push   $0x2c
  801905:	e8 7d fa ff ff       	call   801387 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
  80190d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801910:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801914:	75 07                	jne    80191d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801916:	b8 01 00 00 00       	mov    $0x1,%eax
  80191b:	eb 05                	jmp    801922 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80191d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 2c                	push   $0x2c
  801936:	e8 4c fa ff ff       	call   801387 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
  80193e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801941:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801945:	75 07                	jne    80194e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801947:	b8 01 00 00 00       	mov    $0x1,%eax
  80194c:	eb 05                	jmp    801953 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80194e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 2c                	push   $0x2c
  801967:	e8 1b fa ff ff       	call   801387 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
  80196f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801972:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801976:	75 07                	jne    80197f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801978:	b8 01 00 00 00       	mov    $0x1,%eax
  80197d:	eb 05                	jmp    801984 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80197f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	ff 75 08             	pushl  0x8(%ebp)
  801994:	6a 2d                	push   $0x2d
  801996:	e8 ec f9 ff ff       	call   801387 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
	return ;
  80199e:	90                   	nop
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019a5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	53                   	push   %ebx
  8019b4:	51                   	push   %ecx
  8019b5:	52                   	push   %edx
  8019b6:	50                   	push   %eax
  8019b7:	6a 2e                	push   $0x2e
  8019b9:	e8 c9 f9 ff ff       	call   801387 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8019c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	52                   	push   %edx
  8019d6:	50                   	push   %eax
  8019d7:	6a 2f                	push   $0x2f
  8019d9:	e8 a9 f9 ff ff       	call   801387 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8019e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ec:	89 d0                	mov    %edx,%eax
  8019ee:	c1 e0 02             	shl    $0x2,%eax
  8019f1:	01 d0                	add    %edx,%eax
  8019f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019fa:	01 d0                	add    %edx,%eax
  8019fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a03:	01 d0                	add    %edx,%eax
  801a05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a0c:	01 d0                	add    %edx,%eax
  801a0e:	c1 e0 04             	shl    $0x4,%eax
  801a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801a14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801a1b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	50                   	push   %eax
  801a22:	e8 76 fd ff ff       	call   80179d <sys_get_virtual_time>
  801a27:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801a2a:	eb 41                	jmp    801a6d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801a2c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a2f:	83 ec 0c             	sub    $0xc,%esp
  801a32:	50                   	push   %eax
  801a33:	e8 65 fd ff ff       	call   80179d <sys_get_virtual_time>
  801a38:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801a3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a41:	29 c2                	sub    %eax,%edx
  801a43:	89 d0                	mov    %edx,%eax
  801a45:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801a48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a4e:	89 d1                	mov    %edx,%ecx
  801a50:	29 c1                	sub    %eax,%ecx
  801a52:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a58:	39 c2                	cmp    %eax,%edx
  801a5a:	0f 97 c0             	seta   %al
  801a5d:	0f b6 c0             	movzbl %al,%eax
  801a60:	29 c1                	sub    %eax,%ecx
  801a62:	89 c8                	mov    %ecx,%eax
  801a64:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a67:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a70:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a73:	72 b7                	jb     801a2c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a75:	90                   	nop
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a85:	eb 03                	jmp    801a8a <busy_wait+0x12>
  801a87:	ff 45 fc             	incl   -0x4(%ebp)
  801a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a8d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a90:	72 f5                	jb     801a87 <busy_wait+0xf>
	return i;
  801a92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    
  801a97:	90                   	nop

00801a98 <__udivdi3>:
  801a98:	55                   	push   %ebp
  801a99:	57                   	push   %edi
  801a9a:	56                   	push   %esi
  801a9b:	53                   	push   %ebx
  801a9c:	83 ec 1c             	sub    $0x1c,%esp
  801a9f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801aa3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801aa7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aaf:	89 ca                	mov    %ecx,%edx
  801ab1:	89 f8                	mov    %edi,%eax
  801ab3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ab7:	85 f6                	test   %esi,%esi
  801ab9:	75 2d                	jne    801ae8 <__udivdi3+0x50>
  801abb:	39 cf                	cmp    %ecx,%edi
  801abd:	77 65                	ja     801b24 <__udivdi3+0x8c>
  801abf:	89 fd                	mov    %edi,%ebp
  801ac1:	85 ff                	test   %edi,%edi
  801ac3:	75 0b                	jne    801ad0 <__udivdi3+0x38>
  801ac5:	b8 01 00 00 00       	mov    $0x1,%eax
  801aca:	31 d2                	xor    %edx,%edx
  801acc:	f7 f7                	div    %edi
  801ace:	89 c5                	mov    %eax,%ebp
  801ad0:	31 d2                	xor    %edx,%edx
  801ad2:	89 c8                	mov    %ecx,%eax
  801ad4:	f7 f5                	div    %ebp
  801ad6:	89 c1                	mov    %eax,%ecx
  801ad8:	89 d8                	mov    %ebx,%eax
  801ada:	f7 f5                	div    %ebp
  801adc:	89 cf                	mov    %ecx,%edi
  801ade:	89 fa                	mov    %edi,%edx
  801ae0:	83 c4 1c             	add    $0x1c,%esp
  801ae3:	5b                   	pop    %ebx
  801ae4:	5e                   	pop    %esi
  801ae5:	5f                   	pop    %edi
  801ae6:	5d                   	pop    %ebp
  801ae7:	c3                   	ret    
  801ae8:	39 ce                	cmp    %ecx,%esi
  801aea:	77 28                	ja     801b14 <__udivdi3+0x7c>
  801aec:	0f bd fe             	bsr    %esi,%edi
  801aef:	83 f7 1f             	xor    $0x1f,%edi
  801af2:	75 40                	jne    801b34 <__udivdi3+0x9c>
  801af4:	39 ce                	cmp    %ecx,%esi
  801af6:	72 0a                	jb     801b02 <__udivdi3+0x6a>
  801af8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801afc:	0f 87 9e 00 00 00    	ja     801ba0 <__udivdi3+0x108>
  801b02:	b8 01 00 00 00       	mov    $0x1,%eax
  801b07:	89 fa                	mov    %edi,%edx
  801b09:	83 c4 1c             	add    $0x1c,%esp
  801b0c:	5b                   	pop    %ebx
  801b0d:	5e                   	pop    %esi
  801b0e:	5f                   	pop    %edi
  801b0f:	5d                   	pop    %ebp
  801b10:	c3                   	ret    
  801b11:	8d 76 00             	lea    0x0(%esi),%esi
  801b14:	31 ff                	xor    %edi,%edi
  801b16:	31 c0                	xor    %eax,%eax
  801b18:	89 fa                	mov    %edi,%edx
  801b1a:	83 c4 1c             	add    $0x1c,%esp
  801b1d:	5b                   	pop    %ebx
  801b1e:	5e                   	pop    %esi
  801b1f:	5f                   	pop    %edi
  801b20:	5d                   	pop    %ebp
  801b21:	c3                   	ret    
  801b22:	66 90                	xchg   %ax,%ax
  801b24:	89 d8                	mov    %ebx,%eax
  801b26:	f7 f7                	div    %edi
  801b28:	31 ff                	xor    %edi,%edi
  801b2a:	89 fa                	mov    %edi,%edx
  801b2c:	83 c4 1c             	add    $0x1c,%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5e                   	pop    %esi
  801b31:	5f                   	pop    %edi
  801b32:	5d                   	pop    %ebp
  801b33:	c3                   	ret    
  801b34:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b39:	89 eb                	mov    %ebp,%ebx
  801b3b:	29 fb                	sub    %edi,%ebx
  801b3d:	89 f9                	mov    %edi,%ecx
  801b3f:	d3 e6                	shl    %cl,%esi
  801b41:	89 c5                	mov    %eax,%ebp
  801b43:	88 d9                	mov    %bl,%cl
  801b45:	d3 ed                	shr    %cl,%ebp
  801b47:	89 e9                	mov    %ebp,%ecx
  801b49:	09 f1                	or     %esi,%ecx
  801b4b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b4f:	89 f9                	mov    %edi,%ecx
  801b51:	d3 e0                	shl    %cl,%eax
  801b53:	89 c5                	mov    %eax,%ebp
  801b55:	89 d6                	mov    %edx,%esi
  801b57:	88 d9                	mov    %bl,%cl
  801b59:	d3 ee                	shr    %cl,%esi
  801b5b:	89 f9                	mov    %edi,%ecx
  801b5d:	d3 e2                	shl    %cl,%edx
  801b5f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b63:	88 d9                	mov    %bl,%cl
  801b65:	d3 e8                	shr    %cl,%eax
  801b67:	09 c2                	or     %eax,%edx
  801b69:	89 d0                	mov    %edx,%eax
  801b6b:	89 f2                	mov    %esi,%edx
  801b6d:	f7 74 24 0c          	divl   0xc(%esp)
  801b71:	89 d6                	mov    %edx,%esi
  801b73:	89 c3                	mov    %eax,%ebx
  801b75:	f7 e5                	mul    %ebp
  801b77:	39 d6                	cmp    %edx,%esi
  801b79:	72 19                	jb     801b94 <__udivdi3+0xfc>
  801b7b:	74 0b                	je     801b88 <__udivdi3+0xf0>
  801b7d:	89 d8                	mov    %ebx,%eax
  801b7f:	31 ff                	xor    %edi,%edi
  801b81:	e9 58 ff ff ff       	jmp    801ade <__udivdi3+0x46>
  801b86:	66 90                	xchg   %ax,%ax
  801b88:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b8c:	89 f9                	mov    %edi,%ecx
  801b8e:	d3 e2                	shl    %cl,%edx
  801b90:	39 c2                	cmp    %eax,%edx
  801b92:	73 e9                	jae    801b7d <__udivdi3+0xe5>
  801b94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b97:	31 ff                	xor    %edi,%edi
  801b99:	e9 40 ff ff ff       	jmp    801ade <__udivdi3+0x46>
  801b9e:	66 90                	xchg   %ax,%ax
  801ba0:	31 c0                	xor    %eax,%eax
  801ba2:	e9 37 ff ff ff       	jmp    801ade <__udivdi3+0x46>
  801ba7:	90                   	nop

00801ba8 <__umoddi3>:
  801ba8:	55                   	push   %ebp
  801ba9:	57                   	push   %edi
  801baa:	56                   	push   %esi
  801bab:	53                   	push   %ebx
  801bac:	83 ec 1c             	sub    $0x1c,%esp
  801baf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bb3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bc7:	89 f3                	mov    %esi,%ebx
  801bc9:	89 fa                	mov    %edi,%edx
  801bcb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bcf:	89 34 24             	mov    %esi,(%esp)
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	75 1a                	jne    801bf0 <__umoddi3+0x48>
  801bd6:	39 f7                	cmp    %esi,%edi
  801bd8:	0f 86 a2 00 00 00    	jbe    801c80 <__umoddi3+0xd8>
  801bde:	89 c8                	mov    %ecx,%eax
  801be0:	89 f2                	mov    %esi,%edx
  801be2:	f7 f7                	div    %edi
  801be4:	89 d0                	mov    %edx,%eax
  801be6:	31 d2                	xor    %edx,%edx
  801be8:	83 c4 1c             	add    $0x1c,%esp
  801beb:	5b                   	pop    %ebx
  801bec:	5e                   	pop    %esi
  801bed:	5f                   	pop    %edi
  801bee:	5d                   	pop    %ebp
  801bef:	c3                   	ret    
  801bf0:	39 f0                	cmp    %esi,%eax
  801bf2:	0f 87 ac 00 00 00    	ja     801ca4 <__umoddi3+0xfc>
  801bf8:	0f bd e8             	bsr    %eax,%ebp
  801bfb:	83 f5 1f             	xor    $0x1f,%ebp
  801bfe:	0f 84 ac 00 00 00    	je     801cb0 <__umoddi3+0x108>
  801c04:	bf 20 00 00 00       	mov    $0x20,%edi
  801c09:	29 ef                	sub    %ebp,%edi
  801c0b:	89 fe                	mov    %edi,%esi
  801c0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c11:	89 e9                	mov    %ebp,%ecx
  801c13:	d3 e0                	shl    %cl,%eax
  801c15:	89 d7                	mov    %edx,%edi
  801c17:	89 f1                	mov    %esi,%ecx
  801c19:	d3 ef                	shr    %cl,%edi
  801c1b:	09 c7                	or     %eax,%edi
  801c1d:	89 e9                	mov    %ebp,%ecx
  801c1f:	d3 e2                	shl    %cl,%edx
  801c21:	89 14 24             	mov    %edx,(%esp)
  801c24:	89 d8                	mov    %ebx,%eax
  801c26:	d3 e0                	shl    %cl,%eax
  801c28:	89 c2                	mov    %eax,%edx
  801c2a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c2e:	d3 e0                	shl    %cl,%eax
  801c30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c34:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c38:	89 f1                	mov    %esi,%ecx
  801c3a:	d3 e8                	shr    %cl,%eax
  801c3c:	09 d0                	or     %edx,%eax
  801c3e:	d3 eb                	shr    %cl,%ebx
  801c40:	89 da                	mov    %ebx,%edx
  801c42:	f7 f7                	div    %edi
  801c44:	89 d3                	mov    %edx,%ebx
  801c46:	f7 24 24             	mull   (%esp)
  801c49:	89 c6                	mov    %eax,%esi
  801c4b:	89 d1                	mov    %edx,%ecx
  801c4d:	39 d3                	cmp    %edx,%ebx
  801c4f:	0f 82 87 00 00 00    	jb     801cdc <__umoddi3+0x134>
  801c55:	0f 84 91 00 00 00    	je     801cec <__umoddi3+0x144>
  801c5b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c5f:	29 f2                	sub    %esi,%edx
  801c61:	19 cb                	sbb    %ecx,%ebx
  801c63:	89 d8                	mov    %ebx,%eax
  801c65:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c69:	d3 e0                	shl    %cl,%eax
  801c6b:	89 e9                	mov    %ebp,%ecx
  801c6d:	d3 ea                	shr    %cl,%edx
  801c6f:	09 d0                	or     %edx,%eax
  801c71:	89 e9                	mov    %ebp,%ecx
  801c73:	d3 eb                	shr    %cl,%ebx
  801c75:	89 da                	mov    %ebx,%edx
  801c77:	83 c4 1c             	add    $0x1c,%esp
  801c7a:	5b                   	pop    %ebx
  801c7b:	5e                   	pop    %esi
  801c7c:	5f                   	pop    %edi
  801c7d:	5d                   	pop    %ebp
  801c7e:	c3                   	ret    
  801c7f:	90                   	nop
  801c80:	89 fd                	mov    %edi,%ebp
  801c82:	85 ff                	test   %edi,%edi
  801c84:	75 0b                	jne    801c91 <__umoddi3+0xe9>
  801c86:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8b:	31 d2                	xor    %edx,%edx
  801c8d:	f7 f7                	div    %edi
  801c8f:	89 c5                	mov    %eax,%ebp
  801c91:	89 f0                	mov    %esi,%eax
  801c93:	31 d2                	xor    %edx,%edx
  801c95:	f7 f5                	div    %ebp
  801c97:	89 c8                	mov    %ecx,%eax
  801c99:	f7 f5                	div    %ebp
  801c9b:	89 d0                	mov    %edx,%eax
  801c9d:	e9 44 ff ff ff       	jmp    801be6 <__umoddi3+0x3e>
  801ca2:	66 90                	xchg   %ax,%ax
  801ca4:	89 c8                	mov    %ecx,%eax
  801ca6:	89 f2                	mov    %esi,%edx
  801ca8:	83 c4 1c             	add    $0x1c,%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5e                   	pop    %esi
  801cad:	5f                   	pop    %edi
  801cae:	5d                   	pop    %ebp
  801caf:	c3                   	ret    
  801cb0:	3b 04 24             	cmp    (%esp),%eax
  801cb3:	72 06                	jb     801cbb <__umoddi3+0x113>
  801cb5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cb9:	77 0f                	ja     801cca <__umoddi3+0x122>
  801cbb:	89 f2                	mov    %esi,%edx
  801cbd:	29 f9                	sub    %edi,%ecx
  801cbf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cc3:	89 14 24             	mov    %edx,(%esp)
  801cc6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cca:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cce:	8b 14 24             	mov    (%esp),%edx
  801cd1:	83 c4 1c             	add    $0x1c,%esp
  801cd4:	5b                   	pop    %ebx
  801cd5:	5e                   	pop    %esi
  801cd6:	5f                   	pop    %edi
  801cd7:	5d                   	pop    %ebp
  801cd8:	c3                   	ret    
  801cd9:	8d 76 00             	lea    0x0(%esi),%esi
  801cdc:	2b 04 24             	sub    (%esp),%eax
  801cdf:	19 fa                	sbb    %edi,%edx
  801ce1:	89 d1                	mov    %edx,%ecx
  801ce3:	89 c6                	mov    %eax,%esi
  801ce5:	e9 71 ff ff ff       	jmp    801c5b <__umoddi3+0xb3>
  801cea:	66 90                	xchg   %ax,%ax
  801cec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cf0:	72 ea                	jb     801cdc <__umoddi3+0x134>
  801cf2:	89 d9                	mov    %ebx,%ecx
  801cf4:	e9 62 ff ff ff       	jmp    801c5b <__umoddi3+0xb3>
