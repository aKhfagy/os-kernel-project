
obj/user/tst_page_replacement_free_scarce_mem_slave_3_2:     file format elf32-i386


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
  800031:	e8 03 01 00 00       	call   800139 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 20 00 00    	sub    $0x2024,%esp
	// Create & run the slave environments
	int ID;
	for(int i = 0; i < 3; ++i)
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800049:	eb 39                	jmp    800084 <_main+0x4c>
	{
		ID = sys_create_env("dummy_process", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  80004b:	a1 20 30 80 00       	mov    0x803020,%eax
  800050:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800056:	a1 20 30 80 00       	mov    0x803020,%eax
  80005b:	8b 40 74             	mov    0x74(%eax),%eax
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	52                   	push   %edx
  800062:	50                   	push   %eax
  800063:	68 20 1c 80 00       	push   $0x801c20
  800068:	e8 fe 15 00 00       	call   80166b <sys_create_env>
  80006d:	83 c4 10             	add    $0x10,%esp
  800070:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_run_env(ID);
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	ff 75 f0             	pushl  -0x10(%ebp)
  800079:	e8 0a 16 00 00       	call   801688 <sys_run_env>
  80007e:	83 c4 10             	add    $0x10,%esp

void _main(void)
{
	// Create & run the slave environments
	int ID;
	for(int i = 0; i < 3; ++i)
  800081:	ff 45 f4             	incl   -0xc(%ebp)
  800084:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
  800088:	7e c1                	jle    80004b <_main+0x13>
	{
		ID = sys_create_env("dummy_process", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
		sys_run_env(ID);
	}

	sys_scarce_memory();
  80008a:	e8 3d 14 00 00       	call   8014cc <sys_scarce_memory>

	uint32 freePagesBefore = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  80008f:	e8 82 13 00 00       	call   801416 <sys_calculate_free_frames>
  800094:	89 c3                	mov    %eax,%ebx
  800096:	e8 94 13 00 00       	call   80142f <sys_calculate_modified_frames>
  80009b:	01 d8                	add    %ebx,%eax
  80009d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 usedDiskPagesBefore = sys_pf_calculate_allocated_pages();
  8000a0:	e8 f4 13 00 00       	call   801499 <sys_pf_calculate_allocated_pages>
  8000a5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	// Check the number of pages shall be deleted with the first fault after scarce the memory
	int pagesToBeDeletedCount = sys_calculate_pages_tobe_removed_ready_exit(1);
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	6a 01                	push   $0x1
  8000ad:	e8 00 14 00 00       	call   8014b2 <sys_calculate_pages_tobe_removed_ready_exit>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char arr[PAGE_SIZE*2];
	// Access the created array in STACK to FAULT and Free SCARCE MEM
	arr[1*PAGE_SIZE] = -1;
  8000b8:	c6 85 e0 ef ff ff ff 	movb   $0xff,-0x1020(%ebp)

	//cprintf("Checking Allocation in Mem & Page File... \n");
	//AFTER freeing MEMORY
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPagesBefore) !=  1) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  8000bf:	e8 d5 13 00 00       	call   801499 <sys_pf_calculate_allocated_pages>
  8000c4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000c7:	83 f8 01             	cmp    $0x1,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 30 1c 80 00       	push   $0x801c30
  8000d4:	6a 1c                	push   $0x1c
  8000d6:	68 9c 1c 80 00       	push   $0x801c9c
  8000db:	e8 9e 01 00 00       	call   80027e <_panic>
		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  8000e0:	e8 31 13 00 00       	call   801416 <sys_calculate_free_frames>
  8000e5:	89 c3                	mov    %eax,%ebx
  8000e7:	e8 43 13 00 00       	call   80142f <sys_calculate_modified_frames>
  8000ec:	01 d8                	add    %ebx,%eax
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if( (freePagesBefore + pagesToBeDeletedCount - 1) != freePagesAfter )
  8000f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f7:	01 d0                	add    %edx,%eax
  8000f9:	48                   	dec    %eax
  8000fa:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000fd:	74 14                	je     800113 <_main+0xdb>
			panic("Extra memory are wrongly allocated ... It's REplacement: extra/less frames have been FREED after the memory being scarce");
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	68 d4 1c 80 00       	push   $0x801cd4
  800107:	6a 1f                	push   $0x1f
  800109:	68 9c 1c 80 00       	push   $0x801c9c
  80010e:	e8 6b 01 00 00       	call   80027e <_panic>
	}

	env_sleep(100000);
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 a0 86 01 00       	push   $0x186a0
  80011b:	e8 e6 17 00 00       	call   801906 <env_sleep>
  800120:	83 c4 10             	add    $0x10,%esp
	// To ensure that the slave environments completed successfully
	cprintf("Congratulations!! test PAGE replacement [FREEING SCARCE MEMORY 3] is completed successfully.\n");
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 50 1d 80 00       	push   $0x801d50
  80012b:	e8 f0 03 00 00       	call   800520 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	return;
  800133:	90                   	nop
}
  800134:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800137:	c9                   	leave  
  800138:	c3                   	ret    

00800139 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013f:	e8 07 12 00 00       	call   80134b <sys_getenvindex>
  800144:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80014a:	89 d0                	mov    %edx,%eax
  80014c:	c1 e0 03             	shl    $0x3,%eax
  80014f:	01 d0                	add    %edx,%eax
  800151:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800158:	01 c8                	add    %ecx,%eax
  80015a:	01 c0                	add    %eax,%eax
  80015c:	01 d0                	add    %edx,%eax
  80015e:	01 c0                	add    %eax,%eax
  800160:	01 d0                	add    %edx,%eax
  800162:	89 c2                	mov    %eax,%edx
  800164:	c1 e2 05             	shl    $0x5,%edx
  800167:	29 c2                	sub    %eax,%edx
  800169:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800170:	89 c2                	mov    %eax,%edx
  800172:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800178:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80017d:	a1 20 30 80 00       	mov    0x803020,%eax
  800182:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800188:	84 c0                	test   %al,%al
  80018a:	74 0f                	je     80019b <libmain+0x62>
		binaryname = myEnv->prog_name;
  80018c:	a1 20 30 80 00       	mov    0x803020,%eax
  800191:	05 40 3c 01 00       	add    $0x13c40,%eax
  800196:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019f:	7e 0a                	jle    8001ab <libmain+0x72>
		binaryname = argv[0];
  8001a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a4:	8b 00                	mov    (%eax),%eax
  8001a6:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001ab:	83 ec 08             	sub    $0x8,%esp
  8001ae:	ff 75 0c             	pushl  0xc(%ebp)
  8001b1:	ff 75 08             	pushl  0x8(%ebp)
  8001b4:	e8 7f fe ff ff       	call   800038 <_main>
  8001b9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001bc:	e8 25 13 00 00       	call   8014e6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001c1:	83 ec 0c             	sub    $0xc,%esp
  8001c4:	68 c8 1d 80 00       	push   $0x801dc8
  8001c9:	e8 52 03 00 00       	call   800520 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d6:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8001dc:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e1:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	52                   	push   %edx
  8001eb:	50                   	push   %eax
  8001ec:	68 f0 1d 80 00       	push   $0x801df0
  8001f1:	e8 2a 03 00 00       	call   800520 <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8001f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fe:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800204:	a1 20 30 80 00       	mov    0x803020,%eax
  800209:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	52                   	push   %edx
  800213:	50                   	push   %eax
  800214:	68 18 1e 80 00       	push   $0x801e18
  800219:	e8 02 03 00 00       	call   800520 <cprintf>
  80021e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800221:	a1 20 30 80 00       	mov    0x803020,%eax
  800226:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80022c:	83 ec 08             	sub    $0x8,%esp
  80022f:	50                   	push   %eax
  800230:	68 59 1e 80 00       	push   $0x801e59
  800235:	e8 e6 02 00 00       	call   800520 <cprintf>
  80023a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	68 c8 1d 80 00       	push   $0x801dc8
  800245:	e8 d6 02 00 00       	call   800520 <cprintf>
  80024a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024d:	e8 ae 12 00 00       	call   801500 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800252:	e8 19 00 00 00       	call   800270 <exit>
}
  800257:	90                   	nop
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	6a 00                	push   $0x0
  800265:	e8 ad 10 00 00       	call   801317 <sys_env_destroy>
  80026a:	83 c4 10             	add    $0x10,%esp
}
  80026d:	90                   	nop
  80026e:	c9                   	leave  
  80026f:	c3                   	ret    

00800270 <exit>:

void
exit(void)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800276:	e8 02 11 00 00       	call   80137d <sys_env_exit>
}
  80027b:	90                   	nop
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800284:	8d 45 10             	lea    0x10(%ebp),%eax
  800287:	83 c0 04             	add    $0x4,%eax
  80028a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80028d:	a1 18 31 80 00       	mov    0x803118,%eax
  800292:	85 c0                	test   %eax,%eax
  800294:	74 16                	je     8002ac <_panic+0x2e>
		cprintf("%s: ", argv0);
  800296:	a1 18 31 80 00       	mov    0x803118,%eax
  80029b:	83 ec 08             	sub    $0x8,%esp
  80029e:	50                   	push   %eax
  80029f:	68 70 1e 80 00       	push   $0x801e70
  8002a4:	e8 77 02 00 00       	call   800520 <cprintf>
  8002a9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ac:	a1 00 30 80 00       	mov    0x803000,%eax
  8002b1:	ff 75 0c             	pushl  0xc(%ebp)
  8002b4:	ff 75 08             	pushl  0x8(%ebp)
  8002b7:	50                   	push   %eax
  8002b8:	68 75 1e 80 00       	push   $0x801e75
  8002bd:	e8 5e 02 00 00       	call   800520 <cprintf>
  8002c2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c8:	83 ec 08             	sub    $0x8,%esp
  8002cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ce:	50                   	push   %eax
  8002cf:	e8 e1 01 00 00       	call   8004b5 <vcprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d7:	83 ec 08             	sub    $0x8,%esp
  8002da:	6a 00                	push   $0x0
  8002dc:	68 91 1e 80 00       	push   $0x801e91
  8002e1:	e8 cf 01 00 00       	call   8004b5 <vcprintf>
  8002e6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e9:	e8 82 ff ff ff       	call   800270 <exit>

	// should not return here
	while (1) ;
  8002ee:	eb fe                	jmp    8002ee <_panic+0x70>

008002f0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002fb:	8b 50 74             	mov    0x74(%eax),%edx
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	39 c2                	cmp    %eax,%edx
  800303:	74 14                	je     800319 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	68 94 1e 80 00       	push   $0x801e94
  80030d:	6a 26                	push   $0x26
  80030f:	68 e0 1e 80 00       	push   $0x801ee0
  800314:	e8 65 ff ff ff       	call   80027e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800319:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800320:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800327:	e9 b6 00 00 00       	jmp    8003e2 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80032c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800336:	8b 45 08             	mov    0x8(%ebp),%eax
  800339:	01 d0                	add    %edx,%eax
  80033b:	8b 00                	mov    (%eax),%eax
  80033d:	85 c0                	test   %eax,%eax
  80033f:	75 08                	jne    800349 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800341:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800344:	e9 96 00 00 00       	jmp    8003df <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800349:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800350:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800357:	eb 5d                	jmp    8003b6 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800359:	a1 20 30 80 00       	mov    0x803020,%eax
  80035e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800364:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800367:	c1 e2 04             	shl    $0x4,%edx
  80036a:	01 d0                	add    %edx,%eax
  80036c:	8a 40 04             	mov    0x4(%eax),%al
  80036f:	84 c0                	test   %al,%al
  800371:	75 40                	jne    8003b3 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800373:	a1 20 30 80 00       	mov    0x803020,%eax
  800378:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80037e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800381:	c1 e2 04             	shl    $0x4,%edx
  800384:	01 d0                	add    %edx,%eax
  800386:	8b 00                	mov    (%eax),%eax
  800388:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80038b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800393:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800398:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	01 c8                	add    %ecx,%eax
  8003a4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a6:	39 c2                	cmp    %eax,%edx
  8003a8:	75 09                	jne    8003b3 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8003aa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b1:	eb 12                	jmp    8003c5 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b3:	ff 45 e8             	incl   -0x18(%ebp)
  8003b6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003bb:	8b 50 74             	mov    0x74(%eax),%edx
  8003be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c1:	39 c2                	cmp    %eax,%edx
  8003c3:	77 94                	ja     800359 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003c9:	75 14                	jne    8003df <CheckWSWithoutLastIndex+0xef>
			panic(
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	68 ec 1e 80 00       	push   $0x801eec
  8003d3:	6a 3a                	push   $0x3a
  8003d5:	68 e0 1e 80 00       	push   $0x801ee0
  8003da:	e8 9f fe ff ff       	call   80027e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003df:	ff 45 f0             	incl   -0x10(%ebp)
  8003e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e8:	0f 8c 3e ff ff ff    	jl     80032c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003fc:	eb 20                	jmp    80041e <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800403:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800409:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80040c:	c1 e2 04             	shl    $0x4,%edx
  80040f:	01 d0                	add    %edx,%eax
  800411:	8a 40 04             	mov    0x4(%eax),%al
  800414:	3c 01                	cmp    $0x1,%al
  800416:	75 03                	jne    80041b <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800418:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80041b:	ff 45 e0             	incl   -0x20(%ebp)
  80041e:	a1 20 30 80 00       	mov    0x803020,%eax
  800423:	8b 50 74             	mov    0x74(%eax),%edx
  800426:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800429:	39 c2                	cmp    %eax,%edx
  80042b:	77 d1                	ja     8003fe <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80042d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800430:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800433:	74 14                	je     800449 <CheckWSWithoutLastIndex+0x159>
		panic(
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	68 40 1f 80 00       	push   $0x801f40
  80043d:	6a 44                	push   $0x44
  80043f:	68 e0 1e 80 00       	push   $0x801ee0
  800444:	e8 35 fe ff ff       	call   80027e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800449:	90                   	nop
  80044a:	c9                   	leave  
  80044b:	c3                   	ret    

0080044c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80044c:	55                   	push   %ebp
  80044d:	89 e5                	mov    %esp,%ebp
  80044f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800452:	8b 45 0c             	mov    0xc(%ebp),%eax
  800455:	8b 00                	mov    (%eax),%eax
  800457:	8d 48 01             	lea    0x1(%eax),%ecx
  80045a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045d:	89 0a                	mov    %ecx,(%edx)
  80045f:	8b 55 08             	mov    0x8(%ebp),%edx
  800462:	88 d1                	mov    %dl,%cl
  800464:	8b 55 0c             	mov    0xc(%ebp),%edx
  800467:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80046b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046e:	8b 00                	mov    (%eax),%eax
  800470:	3d ff 00 00 00       	cmp    $0xff,%eax
  800475:	75 2c                	jne    8004a3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800477:	a0 24 30 80 00       	mov    0x803024,%al
  80047c:	0f b6 c0             	movzbl %al,%eax
  80047f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800482:	8b 12                	mov    (%edx),%edx
  800484:	89 d1                	mov    %edx,%ecx
  800486:	8b 55 0c             	mov    0xc(%ebp),%edx
  800489:	83 c2 08             	add    $0x8,%edx
  80048c:	83 ec 04             	sub    $0x4,%esp
  80048f:	50                   	push   %eax
  800490:	51                   	push   %ecx
  800491:	52                   	push   %edx
  800492:	e8 3e 0e 00 00       	call   8012d5 <sys_cputs>
  800497:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a6:	8b 40 04             	mov    0x4(%eax),%eax
  8004a9:	8d 50 01             	lea    0x1(%eax),%edx
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b2:	90                   	nop
  8004b3:	c9                   	leave  
  8004b4:	c3                   	ret    

008004b5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
  8004b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c5:	00 00 00 
	b.cnt = 0;
  8004c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004cf:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004de:	50                   	push   %eax
  8004df:	68 4c 04 80 00       	push   $0x80044c
  8004e4:	e8 11 02 00 00       	call   8006fa <vprintfmt>
  8004e9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004ec:	a0 24 30 80 00       	mov    0x803024,%al
  8004f1:	0f b6 c0             	movzbl %al,%eax
  8004f4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004fa:	83 ec 04             	sub    $0x4,%esp
  8004fd:	50                   	push   %eax
  8004fe:	52                   	push   %edx
  8004ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800505:	83 c0 08             	add    $0x8,%eax
  800508:	50                   	push   %eax
  800509:	e8 c7 0d 00 00       	call   8012d5 <sys_cputs>
  80050e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800511:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800518:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80051e:	c9                   	leave  
  80051f:	c3                   	ret    

00800520 <cprintf>:

int cprintf(const char *fmt, ...) {
  800520:	55                   	push   %ebp
  800521:	89 e5                	mov    %esp,%ebp
  800523:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800526:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80052d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800530:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800533:	8b 45 08             	mov    0x8(%ebp),%eax
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	ff 75 f4             	pushl  -0xc(%ebp)
  80053c:	50                   	push   %eax
  80053d:	e8 73 ff ff ff       	call   8004b5 <vcprintf>
  800542:	83 c4 10             	add    $0x10,%esp
  800545:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800548:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054b:	c9                   	leave  
  80054c:	c3                   	ret    

0080054d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80054d:	55                   	push   %ebp
  80054e:	89 e5                	mov    %esp,%ebp
  800550:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800553:	e8 8e 0f 00 00       	call   8014e6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800558:	8d 45 0c             	lea    0xc(%ebp),%eax
  80055b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	ff 75 f4             	pushl  -0xc(%ebp)
  800567:	50                   	push   %eax
  800568:	e8 48 ff ff ff       	call   8004b5 <vcprintf>
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800573:	e8 88 0f 00 00       	call   801500 <sys_enable_interrupt>
	return cnt;
  800578:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80057b:	c9                   	leave  
  80057c:	c3                   	ret    

0080057d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80057d:	55                   	push   %ebp
  80057e:	89 e5                	mov    %esp,%ebp
  800580:	53                   	push   %ebx
  800581:	83 ec 14             	sub    $0x14,%esp
  800584:	8b 45 10             	mov    0x10(%ebp),%eax
  800587:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800590:	8b 45 18             	mov    0x18(%ebp),%eax
  800593:	ba 00 00 00 00       	mov    $0x0,%edx
  800598:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059b:	77 55                	ja     8005f2 <printnum+0x75>
  80059d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a0:	72 05                	jb     8005a7 <printnum+0x2a>
  8005a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005a5:	77 4b                	ja     8005f2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005a7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005aa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005ad:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	52                   	push   %edx
  8005b6:	50                   	push   %eax
  8005b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8005bd:	e8 fa 13 00 00       	call   8019bc <__udivdi3>
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	ff 75 20             	pushl  0x20(%ebp)
  8005cb:	53                   	push   %ebx
  8005cc:	ff 75 18             	pushl  0x18(%ebp)
  8005cf:	52                   	push   %edx
  8005d0:	50                   	push   %eax
  8005d1:	ff 75 0c             	pushl  0xc(%ebp)
  8005d4:	ff 75 08             	pushl  0x8(%ebp)
  8005d7:	e8 a1 ff ff ff       	call   80057d <printnum>
  8005dc:	83 c4 20             	add    $0x20,%esp
  8005df:	eb 1a                	jmp    8005fb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e1:	83 ec 08             	sub    $0x8,%esp
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 20             	pushl  0x20(%ebp)
  8005ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ed:	ff d0                	call   *%eax
  8005ef:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f2:	ff 4d 1c             	decl   0x1c(%ebp)
  8005f5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005f9:	7f e6                	jg     8005e1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005fb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800606:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800609:	53                   	push   %ebx
  80060a:	51                   	push   %ecx
  80060b:	52                   	push   %edx
  80060c:	50                   	push   %eax
  80060d:	e8 ba 14 00 00       	call   801acc <__umoddi3>
  800612:	83 c4 10             	add    $0x10,%esp
  800615:	05 b4 21 80 00       	add    $0x8021b4,%eax
  80061a:	8a 00                	mov    (%eax),%al
  80061c:	0f be c0             	movsbl %al,%eax
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	50                   	push   %eax
  800626:	8b 45 08             	mov    0x8(%ebp),%eax
  800629:	ff d0                	call   *%eax
  80062b:	83 c4 10             	add    $0x10,%esp
}
  80062e:	90                   	nop
  80062f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800632:	c9                   	leave  
  800633:	c3                   	ret    

00800634 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800637:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80063b:	7e 1c                	jle    800659 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	8d 50 08             	lea    0x8(%eax),%edx
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	89 10                	mov    %edx,(%eax)
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	83 e8 08             	sub    $0x8,%eax
  800652:	8b 50 04             	mov    0x4(%eax),%edx
  800655:	8b 00                	mov    (%eax),%eax
  800657:	eb 40                	jmp    800699 <getuint+0x65>
	else if (lflag)
  800659:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80065d:	74 1e                	je     80067d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	8b 00                	mov    (%eax),%eax
  800664:	8d 50 04             	lea    0x4(%eax),%edx
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	89 10                	mov    %edx,(%eax)
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	83 e8 04             	sub    $0x4,%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	ba 00 00 00 00       	mov    $0x0,%edx
  80067b:	eb 1c                	jmp    800699 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	8d 50 04             	lea    0x4(%eax),%edx
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	89 10                	mov    %edx,(%eax)
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	83 e8 04             	sub    $0x4,%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800699:	5d                   	pop    %ebp
  80069a:	c3                   	ret    

0080069b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80069b:	55                   	push   %ebp
  80069c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80069e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a2:	7e 1c                	jle    8006c0 <getint+0x25>
		return va_arg(*ap, long long);
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	8d 50 08             	lea    0x8(%eax),%edx
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	89 10                	mov    %edx,(%eax)
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	83 e8 08             	sub    $0x8,%eax
  8006b9:	8b 50 04             	mov    0x4(%eax),%edx
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	eb 38                	jmp    8006f8 <getint+0x5d>
	else if (lflag)
  8006c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c4:	74 1a                	je     8006e0 <getint+0x45>
		return va_arg(*ap, long);
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	8d 50 04             	lea    0x4(%eax),%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	89 10                	mov    %edx,(%eax)
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	83 e8 04             	sub    $0x4,%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	99                   	cltd   
  8006de:	eb 18                	jmp    8006f8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	8d 50 04             	lea    0x4(%eax),%edx
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	89 10                	mov    %edx,(%eax)
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	83 e8 04             	sub    $0x4,%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	99                   	cltd   
}
  8006f8:	5d                   	pop    %ebp
  8006f9:	c3                   	ret    

008006fa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	56                   	push   %esi
  8006fe:	53                   	push   %ebx
  8006ff:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800702:	eb 17                	jmp    80071b <vprintfmt+0x21>
			if (ch == '\0')
  800704:	85 db                	test   %ebx,%ebx
  800706:	0f 84 af 03 00 00    	je     800abb <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	ff 75 0c             	pushl  0xc(%ebp)
  800712:	53                   	push   %ebx
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	ff d0                	call   *%eax
  800718:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071b:	8b 45 10             	mov    0x10(%ebp),%eax
  80071e:	8d 50 01             	lea    0x1(%eax),%edx
  800721:	89 55 10             	mov    %edx,0x10(%ebp)
  800724:	8a 00                	mov    (%eax),%al
  800726:	0f b6 d8             	movzbl %al,%ebx
  800729:	83 fb 25             	cmp    $0x25,%ebx
  80072c:	75 d6                	jne    800704 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80072e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800732:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800739:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800740:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800747:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80074e:	8b 45 10             	mov    0x10(%ebp),%eax
  800751:	8d 50 01             	lea    0x1(%eax),%edx
  800754:	89 55 10             	mov    %edx,0x10(%ebp)
  800757:	8a 00                	mov    (%eax),%al
  800759:	0f b6 d8             	movzbl %al,%ebx
  80075c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80075f:	83 f8 55             	cmp    $0x55,%eax
  800762:	0f 87 2b 03 00 00    	ja     800a93 <vprintfmt+0x399>
  800768:	8b 04 85 d8 21 80 00 	mov    0x8021d8(,%eax,4),%eax
  80076f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800771:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800775:	eb d7                	jmp    80074e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800777:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80077b:	eb d1                	jmp    80074e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80077d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800784:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800787:	89 d0                	mov    %edx,%eax
  800789:	c1 e0 02             	shl    $0x2,%eax
  80078c:	01 d0                	add    %edx,%eax
  80078e:	01 c0                	add    %eax,%eax
  800790:	01 d8                	add    %ebx,%eax
  800792:	83 e8 30             	sub    $0x30,%eax
  800795:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8a 00                	mov    (%eax),%al
  80079d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a0:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a3:	7e 3e                	jle    8007e3 <vprintfmt+0xe9>
  8007a5:	83 fb 39             	cmp    $0x39,%ebx
  8007a8:	7f 39                	jg     8007e3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007aa:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ad:	eb d5                	jmp    800784 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	83 c0 04             	add    $0x4,%eax
  8007b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	83 e8 04             	sub    $0x4,%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c3:	eb 1f                	jmp    8007e4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c9:	79 83                	jns    80074e <vprintfmt+0x54>
				width = 0;
  8007cb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d2:	e9 77 ff ff ff       	jmp    80074e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007d7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007de:	e9 6b ff ff ff       	jmp    80074e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e8:	0f 89 60 ff ff ff    	jns    80074e <vprintfmt+0x54>
				width = precision, precision = -1;
  8007ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007fb:	e9 4e ff ff ff       	jmp    80074e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800800:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800803:	e9 46 ff ff ff       	jmp    80074e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	83 c0 04             	add    $0x4,%eax
  80080e:	89 45 14             	mov    %eax,0x14(%ebp)
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	83 e8 04             	sub    $0x4,%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	ff 75 0c             	pushl  0xc(%ebp)
  80081f:	50                   	push   %eax
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	ff d0                	call   *%eax
  800825:	83 c4 10             	add    $0x10,%esp
			break;
  800828:	e9 89 02 00 00       	jmp    800ab6 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	83 c0 04             	add    $0x4,%eax
  800833:	89 45 14             	mov    %eax,0x14(%ebp)
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	83 e8 04             	sub    $0x4,%eax
  80083c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80083e:	85 db                	test   %ebx,%ebx
  800840:	79 02                	jns    800844 <vprintfmt+0x14a>
				err = -err;
  800842:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800844:	83 fb 64             	cmp    $0x64,%ebx
  800847:	7f 0b                	jg     800854 <vprintfmt+0x15a>
  800849:	8b 34 9d 20 20 80 00 	mov    0x802020(,%ebx,4),%esi
  800850:	85 f6                	test   %esi,%esi
  800852:	75 19                	jne    80086d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800854:	53                   	push   %ebx
  800855:	68 c5 21 80 00       	push   $0x8021c5
  80085a:	ff 75 0c             	pushl  0xc(%ebp)
  80085d:	ff 75 08             	pushl  0x8(%ebp)
  800860:	e8 5e 02 00 00       	call   800ac3 <printfmt>
  800865:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800868:	e9 49 02 00 00       	jmp    800ab6 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80086d:	56                   	push   %esi
  80086e:	68 ce 21 80 00       	push   $0x8021ce
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	ff 75 08             	pushl  0x8(%ebp)
  800879:	e8 45 02 00 00       	call   800ac3 <printfmt>
  80087e:	83 c4 10             	add    $0x10,%esp
			break;
  800881:	e9 30 02 00 00       	jmp    800ab6 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800886:	8b 45 14             	mov    0x14(%ebp),%eax
  800889:	83 c0 04             	add    $0x4,%eax
  80088c:	89 45 14             	mov    %eax,0x14(%ebp)
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	83 e8 04             	sub    $0x4,%eax
  800895:	8b 30                	mov    (%eax),%esi
  800897:	85 f6                	test   %esi,%esi
  800899:	75 05                	jne    8008a0 <vprintfmt+0x1a6>
				p = "(null)";
  80089b:	be d1 21 80 00       	mov    $0x8021d1,%esi
			if (width > 0 && padc != '-')
  8008a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a4:	7e 6d                	jle    800913 <vprintfmt+0x219>
  8008a6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008aa:	74 67                	je     800913 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	56                   	push   %esi
  8008b4:	e8 0c 03 00 00       	call   800bc5 <strnlen>
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008bf:	eb 16                	jmp    8008d7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	50                   	push   %eax
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	ff d0                	call   *%eax
  8008d1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d4:	ff 4d e4             	decl   -0x1c(%ebp)
  8008d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008db:	7f e4                	jg     8008c1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008dd:	eb 34                	jmp    800913 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008df:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e3:	74 1c                	je     800901 <vprintfmt+0x207>
  8008e5:	83 fb 1f             	cmp    $0x1f,%ebx
  8008e8:	7e 05                	jle    8008ef <vprintfmt+0x1f5>
  8008ea:	83 fb 7e             	cmp    $0x7e,%ebx
  8008ed:	7e 12                	jle    800901 <vprintfmt+0x207>
					putch('?', putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	6a 3f                	push   $0x3f
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	eb 0f                	jmp    800910 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	53                   	push   %ebx
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	ff d0                	call   *%eax
  80090d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800910:	ff 4d e4             	decl   -0x1c(%ebp)
  800913:	89 f0                	mov    %esi,%eax
  800915:	8d 70 01             	lea    0x1(%eax),%esi
  800918:	8a 00                	mov    (%eax),%al
  80091a:	0f be d8             	movsbl %al,%ebx
  80091d:	85 db                	test   %ebx,%ebx
  80091f:	74 24                	je     800945 <vprintfmt+0x24b>
  800921:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800925:	78 b8                	js     8008df <vprintfmt+0x1e5>
  800927:	ff 4d e0             	decl   -0x20(%ebp)
  80092a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092e:	79 af                	jns    8008df <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800930:	eb 13                	jmp    800945 <vprintfmt+0x24b>
				putch(' ', putdat);
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	6a 20                	push   $0x20
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	ff d0                	call   *%eax
  80093f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800942:	ff 4d e4             	decl   -0x1c(%ebp)
  800945:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800949:	7f e7                	jg     800932 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80094b:	e9 66 01 00 00       	jmp    800ab6 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	ff 75 e8             	pushl  -0x18(%ebp)
  800956:	8d 45 14             	lea    0x14(%ebp),%eax
  800959:	50                   	push   %eax
  80095a:	e8 3c fd ff ff       	call   80069b <getint>
  80095f:	83 c4 10             	add    $0x10,%esp
  800962:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800965:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80096b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80096e:	85 d2                	test   %edx,%edx
  800970:	79 23                	jns    800995 <vprintfmt+0x29b>
				putch('-', putdat);
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	6a 2d                	push   $0x2d
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	ff d0                	call   *%eax
  80097f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800985:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800988:	f7 d8                	neg    %eax
  80098a:	83 d2 00             	adc    $0x0,%edx
  80098d:	f7 da                	neg    %edx
  80098f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800992:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800995:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80099c:	e9 bc 00 00 00       	jmp    800a5d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a7:	8d 45 14             	lea    0x14(%ebp),%eax
  8009aa:	50                   	push   %eax
  8009ab:	e8 84 fc ff ff       	call   800634 <getuint>
  8009b0:	83 c4 10             	add    $0x10,%esp
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c0:	e9 98 00 00 00       	jmp    800a5d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	6a 58                	push   $0x58
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	ff d0                	call   *%eax
  8009d2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	6a 58                	push   $0x58
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	ff d0                	call   *%eax
  8009e2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e5:	83 ec 08             	sub    $0x8,%esp
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	6a 58                	push   $0x58
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	ff d0                	call   *%eax
  8009f2:	83 c4 10             	add    $0x10,%esp
			break;
  8009f5:	e9 bc 00 00 00       	jmp    800ab6 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	6a 30                	push   $0x30
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	ff d0                	call   *%eax
  800a07:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 0c             	pushl  0xc(%ebp)
  800a10:	6a 78                	push   $0x78
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	ff d0                	call   *%eax
  800a17:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1d:	83 c0 04             	add    $0x4,%eax
  800a20:	89 45 14             	mov    %eax,0x14(%ebp)
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	83 e8 04             	sub    $0x4,%eax
  800a29:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a35:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a3c:	eb 1f                	jmp    800a5d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a3e:	83 ec 08             	sub    $0x8,%esp
  800a41:	ff 75 e8             	pushl  -0x18(%ebp)
  800a44:	8d 45 14             	lea    0x14(%ebp),%eax
  800a47:	50                   	push   %eax
  800a48:	e8 e7 fb ff ff       	call   800634 <getuint>
  800a4d:	83 c4 10             	add    $0x10,%esp
  800a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a53:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a56:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a5d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a64:	83 ec 04             	sub    $0x4,%esp
  800a67:	52                   	push   %edx
  800a68:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a6b:	50                   	push   %eax
  800a6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6f:	ff 75 f0             	pushl  -0x10(%ebp)
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	ff 75 08             	pushl  0x8(%ebp)
  800a78:	e8 00 fb ff ff       	call   80057d <printnum>
  800a7d:	83 c4 20             	add    $0x20,%esp
			break;
  800a80:	eb 34                	jmp    800ab6 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	53                   	push   %ebx
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	ff d0                	call   *%eax
  800a8e:	83 c4 10             	add    $0x10,%esp
			break;
  800a91:	eb 23                	jmp    800ab6 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	6a 25                	push   $0x25
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa3:	ff 4d 10             	decl   0x10(%ebp)
  800aa6:	eb 03                	jmp    800aab <vprintfmt+0x3b1>
  800aa8:	ff 4d 10             	decl   0x10(%ebp)
  800aab:	8b 45 10             	mov    0x10(%ebp),%eax
  800aae:	48                   	dec    %eax
  800aaf:	8a 00                	mov    (%eax),%al
  800ab1:	3c 25                	cmp    $0x25,%al
  800ab3:	75 f3                	jne    800aa8 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ab5:	90                   	nop
		}
	}
  800ab6:	e9 47 fc ff ff       	jmp    800702 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800abb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800abc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800abf:	5b                   	pop    %ebx
  800ac0:	5e                   	pop    %esi
  800ac1:	5d                   	pop    %ebp
  800ac2:	c3                   	ret    

00800ac3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ac9:	8d 45 10             	lea    0x10(%ebp),%eax
  800acc:	83 c0 04             	add    $0x4,%eax
  800acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad8:	50                   	push   %eax
  800ad9:	ff 75 0c             	pushl  0xc(%ebp)
  800adc:	ff 75 08             	pushl  0x8(%ebp)
  800adf:	e8 16 fc ff ff       	call   8006fa <vprintfmt>
  800ae4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ae7:	90                   	nop
  800ae8:	c9                   	leave  
  800ae9:	c3                   	ret    

00800aea <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af0:	8b 40 08             	mov    0x8(%eax),%eax
  800af3:	8d 50 01             	lea    0x1(%eax),%edx
  800af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aff:	8b 10                	mov    (%eax),%edx
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	8b 40 04             	mov    0x4(%eax),%eax
  800b07:	39 c2                	cmp    %eax,%edx
  800b09:	73 12                	jae    800b1d <sprintputch+0x33>
		*b->buf++ = ch;
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	8b 00                	mov    (%eax),%eax
  800b10:	8d 48 01             	lea    0x1(%eax),%ecx
  800b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b16:	89 0a                	mov    %ecx,(%edx)
  800b18:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1b:	88 10                	mov    %dl,(%eax)
}
  800b1d:	90                   	nop
  800b1e:	5d                   	pop    %ebp
  800b1f:	c3                   	ret    

00800b20 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	01 d0                	add    %edx,%eax
  800b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b45:	74 06                	je     800b4d <vsnprintf+0x2d>
  800b47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4b:	7f 07                	jg     800b54 <vsnprintf+0x34>
		return -E_INVAL;
  800b4d:	b8 03 00 00 00       	mov    $0x3,%eax
  800b52:	eb 20                	jmp    800b74 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b54:	ff 75 14             	pushl  0x14(%ebp)
  800b57:	ff 75 10             	pushl  0x10(%ebp)
  800b5a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b5d:	50                   	push   %eax
  800b5e:	68 ea 0a 80 00       	push   $0x800aea
  800b63:	e8 92 fb ff ff       	call   8006fa <vprintfmt>
  800b68:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b6e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b74:	c9                   	leave  
  800b75:	c3                   	ret    

00800b76 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b7c:	8d 45 10             	lea    0x10(%ebp),%eax
  800b7f:	83 c0 04             	add    $0x4,%eax
  800b82:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b85:	8b 45 10             	mov    0x10(%ebp),%eax
  800b88:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8b:	50                   	push   %eax
  800b8c:	ff 75 0c             	pushl  0xc(%ebp)
  800b8f:	ff 75 08             	pushl  0x8(%ebp)
  800b92:	e8 89 ff ff ff       	call   800b20 <vsnprintf>
  800b97:	83 c4 10             	add    $0x10,%esp
  800b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba0:	c9                   	leave  
  800ba1:	c3                   	ret    

00800ba2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800baf:	eb 06                	jmp    800bb7 <strlen+0x15>
		n++;
  800bb1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb4:	ff 45 08             	incl   0x8(%ebp)
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	84 c0                	test   %al,%al
  800bbe:	75 f1                	jne    800bb1 <strlen+0xf>
		n++;
	return n;
  800bc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc3:	c9                   	leave  
  800bc4:	c3                   	ret    

00800bc5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bcb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd2:	eb 09                	jmp    800bdd <strnlen+0x18>
		n++;
  800bd4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd7:	ff 45 08             	incl   0x8(%ebp)
  800bda:	ff 4d 0c             	decl   0xc(%ebp)
  800bdd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be1:	74 09                	je     800bec <strnlen+0x27>
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8a 00                	mov    (%eax),%al
  800be8:	84 c0                	test   %al,%al
  800bea:	75 e8                	jne    800bd4 <strnlen+0xf>
		n++;
	return n;
  800bec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bfd:	90                   	nop
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8d 50 01             	lea    0x1(%eax),%edx
  800c04:	89 55 08             	mov    %edx,0x8(%ebp)
  800c07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c10:	8a 12                	mov    (%edx),%dl
  800c12:	88 10                	mov    %dl,(%eax)
  800c14:	8a 00                	mov    (%eax),%al
  800c16:	84 c0                	test   %al,%al
  800c18:	75 e4                	jne    800bfe <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c32:	eb 1f                	jmp    800c53 <strncpy+0x34>
		*dst++ = *src;
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8d 50 01             	lea    0x1(%eax),%edx
  800c3a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c40:	8a 12                	mov    (%edx),%dl
  800c42:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c47:	8a 00                	mov    (%eax),%al
  800c49:	84 c0                	test   %al,%al
  800c4b:	74 03                	je     800c50 <strncpy+0x31>
			src++;
  800c4d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c50:	ff 45 fc             	incl   -0x4(%ebp)
  800c53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c56:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c59:	72 d9                	jb     800c34 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c70:	74 30                	je     800ca2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c72:	eb 16                	jmp    800c8a <strlcpy+0x2a>
			*dst++ = *src++;
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	8d 50 01             	lea    0x1(%eax),%edx
  800c7a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c83:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c86:	8a 12                	mov    (%edx),%dl
  800c88:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c8a:	ff 4d 10             	decl   0x10(%ebp)
  800c8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c91:	74 09                	je     800c9c <strlcpy+0x3c>
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8a 00                	mov    (%eax),%al
  800c98:	84 c0                	test   %al,%al
  800c9a:	75 d8                	jne    800c74 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca8:	29 c2                	sub    %eax,%edx
  800caa:	89 d0                	mov    %edx,%eax
}
  800cac:	c9                   	leave  
  800cad:	c3                   	ret    

00800cae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb1:	eb 06                	jmp    800cb9 <strcmp+0xb>
		p++, q++;
  800cb3:	ff 45 08             	incl   0x8(%ebp)
  800cb6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	74 0e                	je     800cd0 <strcmp+0x22>
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	8a 10                	mov    (%eax),%dl
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	38 c2                	cmp    %al,%dl
  800cce:	74 e3                	je     800cb3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	0f b6 d0             	movzbl %al,%edx
  800cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	0f b6 c0             	movzbl %al,%eax
  800ce0:	29 c2                	sub    %eax,%edx
  800ce2:	89 d0                	mov    %edx,%eax
}
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    

00800ce6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ce9:	eb 09                	jmp    800cf4 <strncmp+0xe>
		n--, p++, q++;
  800ceb:	ff 4d 10             	decl   0x10(%ebp)
  800cee:	ff 45 08             	incl   0x8(%ebp)
  800cf1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf8:	74 17                	je     800d11 <strncmp+0x2b>
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	8a 00                	mov    (%eax),%al
  800cff:	84 c0                	test   %al,%al
  800d01:	74 0e                	je     800d11 <strncmp+0x2b>
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 10                	mov    (%eax),%dl
  800d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	38 c2                	cmp    %al,%dl
  800d0f:	74 da                	je     800ceb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d15:	75 07                	jne    800d1e <strncmp+0x38>
		return 0;
  800d17:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1c:	eb 14                	jmp    800d32 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	0f b6 d0             	movzbl %al,%edx
  800d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	0f b6 c0             	movzbl %al,%eax
  800d2e:	29 c2                	sub    %eax,%edx
  800d30:	89 d0                	mov    %edx,%eax
}
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	83 ec 04             	sub    $0x4,%esp
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d40:	eb 12                	jmp    800d54 <strchr+0x20>
		if (*s == c)
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4a:	75 05                	jne    800d51 <strchr+0x1d>
			return (char *) s;
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	eb 11                	jmp    800d62 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d51:	ff 45 08             	incl   0x8(%ebp)
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	84 c0                	test   %al,%al
  800d5b:	75 e5                	jne    800d42 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d62:	c9                   	leave  
  800d63:	c3                   	ret    

00800d64 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	83 ec 04             	sub    $0x4,%esp
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d70:	eb 0d                	jmp    800d7f <strfind+0x1b>
		if (*s == c)
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7a:	74 0e                	je     800d8a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d7c:	ff 45 08             	incl   0x8(%ebp)
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	84 c0                	test   %al,%al
  800d86:	75 ea                	jne    800d72 <strfind+0xe>
  800d88:	eb 01                	jmp    800d8b <strfind+0x27>
		if (*s == c)
			break;
  800d8a:	90                   	nop
	return (char *) s;
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d8e:	c9                   	leave  
  800d8f:	c3                   	ret    

00800d90 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da2:	eb 0e                	jmp    800db2 <memset+0x22>
		*p++ = c;
  800da4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da7:	8d 50 01             	lea    0x1(%eax),%edx
  800daa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db2:	ff 4d f8             	decl   -0x8(%ebp)
  800db5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800db9:	79 e9                	jns    800da4 <memset+0x14>
		*p++ = c;

	return v;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd2:	eb 16                	jmp    800dea <memcpy+0x2a>
		*d++ = *s++;
  800dd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd7:	8d 50 01             	lea    0x1(%eax),%edx
  800dda:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ddd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800de6:	8a 12                	mov    (%edx),%dl
  800de8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dea:	8b 45 10             	mov    0x10(%ebp),%eax
  800ded:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df0:	89 55 10             	mov    %edx,0x10(%ebp)
  800df3:	85 c0                	test   %eax,%eax
  800df5:	75 dd                	jne    800dd4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e11:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e14:	73 50                	jae    800e66 <memmove+0x6a>
  800e16:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	01 d0                	add    %edx,%eax
  800e1e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e21:	76 43                	jbe    800e66 <memmove+0x6a>
		s += n;
  800e23:	8b 45 10             	mov    0x10(%ebp),%eax
  800e26:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e29:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e2f:	eb 10                	jmp    800e41 <memmove+0x45>
			*--d = *--s;
  800e31:	ff 4d f8             	decl   -0x8(%ebp)
  800e34:	ff 4d fc             	decl   -0x4(%ebp)
  800e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3a:	8a 10                	mov    (%eax),%dl
  800e3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e41:	8b 45 10             	mov    0x10(%ebp),%eax
  800e44:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e47:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4a:	85 c0                	test   %eax,%eax
  800e4c:	75 e3                	jne    800e31 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e4e:	eb 23                	jmp    800e73 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e53:	8d 50 01             	lea    0x1(%eax),%edx
  800e56:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e62:	8a 12                	mov    (%edx),%dl
  800e64:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e66:	8b 45 10             	mov    0x10(%ebp),%eax
  800e69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	75 dd                	jne    800e50 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    

00800e78 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8a:	eb 2a                	jmp    800eb6 <memcmp+0x3e>
		if (*s1 != *s2)
  800e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8f:	8a 10                	mov    (%eax),%dl
  800e91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	38 c2                	cmp    %al,%dl
  800e98:	74 16                	je     800eb0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	0f b6 d0             	movzbl %al,%edx
  800ea2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	0f b6 c0             	movzbl %al,%eax
  800eaa:	29 c2                	sub    %eax,%edx
  800eac:	89 d0                	mov    %edx,%eax
  800eae:	eb 18                	jmp    800ec8 <memcmp+0x50>
		s1++, s2++;
  800eb0:	ff 45 fc             	incl   -0x4(%ebp)
  800eb3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebc:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	75 c9                	jne    800e8c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	01 d0                	add    %edx,%eax
  800ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800edb:	eb 15                	jmp    800ef2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	0f b6 d0             	movzbl %al,%edx
  800ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee8:	0f b6 c0             	movzbl %al,%eax
  800eeb:	39 c2                	cmp    %eax,%edx
  800eed:	74 0d                	je     800efc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eef:	ff 45 08             	incl   0x8(%ebp)
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ef8:	72 e3                	jb     800edd <memfind+0x13>
  800efa:	eb 01                	jmp    800efd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800efc:	90                   	nop
	return (void *) s;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f00:	c9                   	leave  
  800f01:	c3                   	ret    

00800f02 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f0f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f16:	eb 03                	jmp    800f1b <strtol+0x19>
		s++;
  800f18:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3c 20                	cmp    $0x20,%al
  800f22:	74 f4                	je     800f18 <strtol+0x16>
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	3c 09                	cmp    $0x9,%al
  800f2b:	74 eb                	je     800f18 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	3c 2b                	cmp    $0x2b,%al
  800f34:	75 05                	jne    800f3b <strtol+0x39>
		s++;
  800f36:	ff 45 08             	incl   0x8(%ebp)
  800f39:	eb 13                	jmp    800f4e <strtol+0x4c>
	else if (*s == '-')
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	3c 2d                	cmp    $0x2d,%al
  800f42:	75 0a                	jne    800f4e <strtol+0x4c>
		s++, neg = 1;
  800f44:	ff 45 08             	incl   0x8(%ebp)
  800f47:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f52:	74 06                	je     800f5a <strtol+0x58>
  800f54:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f58:	75 20                	jne    800f7a <strtol+0x78>
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	3c 30                	cmp    $0x30,%al
  800f61:	75 17                	jne    800f7a <strtol+0x78>
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	40                   	inc    %eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	3c 78                	cmp    $0x78,%al
  800f6b:	75 0d                	jne    800f7a <strtol+0x78>
		s += 2, base = 16;
  800f6d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f71:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f78:	eb 28                	jmp    800fa2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	75 15                	jne    800f95 <strtol+0x93>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 30                	cmp    $0x30,%al
  800f87:	75 0c                	jne    800f95 <strtol+0x93>
		s++, base = 8;
  800f89:	ff 45 08             	incl   0x8(%ebp)
  800f8c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f93:	eb 0d                	jmp    800fa2 <strtol+0xa0>
	else if (base == 0)
  800f95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f99:	75 07                	jne    800fa2 <strtol+0xa0>
		base = 10;
  800f9b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	3c 2f                	cmp    $0x2f,%al
  800fa9:	7e 19                	jle    800fc4 <strtol+0xc2>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	3c 39                	cmp    $0x39,%al
  800fb2:	7f 10                	jg     800fc4 <strtol+0xc2>
			dig = *s - '0';
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f be c0             	movsbl %al,%eax
  800fbc:	83 e8 30             	sub    $0x30,%eax
  800fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc2:	eb 42                	jmp    801006 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3c 60                	cmp    $0x60,%al
  800fcb:	7e 19                	jle    800fe6 <strtol+0xe4>
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3c 7a                	cmp    $0x7a,%al
  800fd4:	7f 10                	jg     800fe6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	0f be c0             	movsbl %al,%eax
  800fde:	83 e8 57             	sub    $0x57,%eax
  800fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe4:	eb 20                	jmp    801006 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	3c 40                	cmp    $0x40,%al
  800fed:	7e 39                	jle    801028 <strtol+0x126>
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	3c 5a                	cmp    $0x5a,%al
  800ff6:	7f 30                	jg     801028 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	0f be c0             	movsbl %al,%eax
  801000:	83 e8 37             	sub    $0x37,%eax
  801003:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801009:	3b 45 10             	cmp    0x10(%ebp),%eax
  80100c:	7d 19                	jge    801027 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80100e:	ff 45 08             	incl   0x8(%ebp)
  801011:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801014:	0f af 45 10          	imul   0x10(%ebp),%eax
  801018:	89 c2                	mov    %eax,%edx
  80101a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101d:	01 d0                	add    %edx,%eax
  80101f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801022:	e9 7b ff ff ff       	jmp    800fa2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801027:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801028:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102c:	74 08                	je     801036 <strtol+0x134>
		*endptr = (char *) s;
  80102e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801031:	8b 55 08             	mov    0x8(%ebp),%edx
  801034:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801036:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103a:	74 07                	je     801043 <strtol+0x141>
  80103c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103f:	f7 d8                	neg    %eax
  801041:	eb 03                	jmp    801046 <strtol+0x144>
  801043:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801046:	c9                   	leave  
  801047:	c3                   	ret    

00801048 <ltostr>:

void
ltostr(long value, char *str)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80104e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801055:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80105c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801060:	79 13                	jns    801075 <ltostr+0x2d>
	{
		neg = 1;
  801062:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80106f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801072:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80107d:	99                   	cltd   
  80107e:	f7 f9                	idiv   %ecx
  801080:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801083:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801086:	8d 50 01             	lea    0x1(%eax),%edx
  801089:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108c:	89 c2                	mov    %eax,%edx
  80108e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801091:	01 d0                	add    %edx,%eax
  801093:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801096:	83 c2 30             	add    $0x30,%edx
  801099:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80109b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a3:	f7 e9                	imul   %ecx
  8010a5:	c1 fa 02             	sar    $0x2,%edx
  8010a8:	89 c8                	mov    %ecx,%eax
  8010aa:	c1 f8 1f             	sar    $0x1f,%eax
  8010ad:	29 c2                	sub    %eax,%edx
  8010af:	89 d0                	mov    %edx,%eax
  8010b1:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010bc:	f7 e9                	imul   %ecx
  8010be:	c1 fa 02             	sar    $0x2,%edx
  8010c1:	89 c8                	mov    %ecx,%eax
  8010c3:	c1 f8 1f             	sar    $0x1f,%eax
  8010c6:	29 c2                	sub    %eax,%edx
  8010c8:	89 d0                	mov    %edx,%eax
  8010ca:	c1 e0 02             	shl    $0x2,%eax
  8010cd:	01 d0                	add    %edx,%eax
  8010cf:	01 c0                	add    %eax,%eax
  8010d1:	29 c1                	sub    %eax,%ecx
  8010d3:	89 ca                	mov    %ecx,%edx
  8010d5:	85 d2                	test   %edx,%edx
  8010d7:	75 9c                	jne    801075 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e3:	48                   	dec    %eax
  8010e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010eb:	74 3d                	je     80112a <ltostr+0xe2>
		start = 1 ;
  8010ed:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f4:	eb 34                	jmp    80112a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fc:	01 d0                	add    %edx,%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801103:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801106:	8b 45 0c             	mov    0xc(%ebp),%eax
  801109:	01 c2                	add    %eax,%edx
  80110b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80110e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801111:	01 c8                	add    %ecx,%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801117:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	01 c2                	add    %eax,%edx
  80111f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801122:	88 02                	mov    %al,(%edx)
		start++ ;
  801124:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801127:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801130:	7c c4                	jl     8010f6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801132:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801135:	8b 45 0c             	mov    0xc(%ebp),%eax
  801138:	01 d0                	add    %edx,%eax
  80113a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80113d:	90                   	nop
  80113e:	c9                   	leave  
  80113f:	c3                   	ret    

00801140 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801146:	ff 75 08             	pushl  0x8(%ebp)
  801149:	e8 54 fa ff ff       	call   800ba2 <strlen>
  80114e:	83 c4 04             	add    $0x4,%esp
  801151:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801154:	ff 75 0c             	pushl  0xc(%ebp)
  801157:	e8 46 fa ff ff       	call   800ba2 <strlen>
  80115c:	83 c4 04             	add    $0x4,%esp
  80115f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801162:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801169:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801170:	eb 17                	jmp    801189 <strcconcat+0x49>
		final[s] = str1[s] ;
  801172:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801175:	8b 45 10             	mov    0x10(%ebp),%eax
  801178:	01 c2                	add    %eax,%edx
  80117a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	01 c8                	add    %ecx,%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801186:	ff 45 fc             	incl   -0x4(%ebp)
  801189:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80118f:	7c e1                	jl     801172 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801191:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801198:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80119f:	eb 1f                	jmp    8011c0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a4:	8d 50 01             	lea    0x1(%eax),%edx
  8011a7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011aa:	89 c2                	mov    %eax,%edx
  8011ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8011af:	01 c2                	add    %eax,%edx
  8011b1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	01 c8                	add    %ecx,%eax
  8011b9:	8a 00                	mov    (%eax),%al
  8011bb:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011bd:	ff 45 f8             	incl   -0x8(%ebp)
  8011c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c6:	7c d9                	jl     8011a1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ce:	01 d0                	add    %edx,%eax
  8011d0:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d3:	90                   	nop
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e5:	8b 00                	mov    (%eax),%eax
  8011e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f9:	eb 0c                	jmp    801207 <strsplit+0x31>
			*string++ = 0;
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8d 50 01             	lea    0x1(%eax),%edx
  801201:	89 55 08             	mov    %edx,0x8(%ebp)
  801204:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	84 c0                	test   %al,%al
  80120e:	74 18                	je     801228 <strsplit+0x52>
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	0f be c0             	movsbl %al,%eax
  801218:	50                   	push   %eax
  801219:	ff 75 0c             	pushl  0xc(%ebp)
  80121c:	e8 13 fb ff ff       	call   800d34 <strchr>
  801221:	83 c4 08             	add    $0x8,%esp
  801224:	85 c0                	test   %eax,%eax
  801226:	75 d3                	jne    8011fb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	84 c0                	test   %al,%al
  80122f:	74 5a                	je     80128b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801231:	8b 45 14             	mov    0x14(%ebp),%eax
  801234:	8b 00                	mov    (%eax),%eax
  801236:	83 f8 0f             	cmp    $0xf,%eax
  801239:	75 07                	jne    801242 <strsplit+0x6c>
		{
			return 0;
  80123b:	b8 00 00 00 00       	mov    $0x0,%eax
  801240:	eb 66                	jmp    8012a8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801242:	8b 45 14             	mov    0x14(%ebp),%eax
  801245:	8b 00                	mov    (%eax),%eax
  801247:	8d 48 01             	lea    0x1(%eax),%ecx
  80124a:	8b 55 14             	mov    0x14(%ebp),%edx
  80124d:	89 0a                	mov    %ecx,(%edx)
  80124f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801256:	8b 45 10             	mov    0x10(%ebp),%eax
  801259:	01 c2                	add    %eax,%edx
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801260:	eb 03                	jmp    801265 <strsplit+0x8f>
			string++;
  801262:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	8a 00                	mov    (%eax),%al
  80126a:	84 c0                	test   %al,%al
  80126c:	74 8b                	je     8011f9 <strsplit+0x23>
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	0f be c0             	movsbl %al,%eax
  801276:	50                   	push   %eax
  801277:	ff 75 0c             	pushl  0xc(%ebp)
  80127a:	e8 b5 fa ff ff       	call   800d34 <strchr>
  80127f:	83 c4 08             	add    $0x8,%esp
  801282:	85 c0                	test   %eax,%eax
  801284:	74 dc                	je     801262 <strsplit+0x8c>
			string++;
	}
  801286:	e9 6e ff ff ff       	jmp    8011f9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80128b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80128c:	8b 45 14             	mov    0x14(%ebp),%eax
  80128f:	8b 00                	mov    (%eax),%eax
  801291:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	01 d0                	add    %edx,%eax
  80129d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	57                   	push   %edi
  8012ae:	56                   	push   %esi
  8012af:	53                   	push   %ebx
  8012b0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012bf:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012c2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012c5:	cd 30                	int    $0x30
  8012c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	5b                   	pop    %ebx
  8012d1:	5e                   	pop    %esi
  8012d2:	5f                   	pop    %edi
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    

008012d5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	83 ec 04             	sub    $0x4,%esp
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	52                   	push   %edx
  8012ed:	ff 75 0c             	pushl  0xc(%ebp)
  8012f0:	50                   	push   %eax
  8012f1:	6a 00                	push   $0x0
  8012f3:	e8 b2 ff ff ff       	call   8012aa <syscall>
  8012f8:	83 c4 18             	add    $0x18,%esp
}
  8012fb:	90                   	nop
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <sys_cgetc>:

int
sys_cgetc(void)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	6a 01                	push   $0x1
  80130d:	e8 98 ff ff ff       	call   8012aa <syscall>
  801312:	83 c4 18             	add    $0x18,%esp
}
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	50                   	push   %eax
  801326:	6a 05                	push   $0x5
  801328:	e8 7d ff ff ff       	call   8012aa <syscall>
  80132d:	83 c4 18             	add    $0x18,%esp
}
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 02                	push   $0x2
  801341:	e8 64 ff ff ff       	call   8012aa <syscall>
  801346:	83 c4 18             	add    $0x18,%esp
}
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 03                	push   $0x3
  80135a:	e8 4b ff ff ff       	call   8012aa <syscall>
  80135f:	83 c4 18             	add    $0x18,%esp
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 04                	push   $0x4
  801373:	e8 32 ff ff ff       	call   8012aa <syscall>
  801378:	83 c4 18             	add    $0x18,%esp
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <sys_env_exit>:


void sys_env_exit(void)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 06                	push   $0x6
  80138c:	e8 19 ff ff ff       	call   8012aa <syscall>
  801391:	83 c4 18             	add    $0x18,%esp
}
  801394:	90                   	nop
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80139a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	52                   	push   %edx
  8013a7:	50                   	push   %eax
  8013a8:	6a 07                	push   $0x7
  8013aa:	e8 fb fe ff ff       	call   8012aa <syscall>
  8013af:	83 c4 18             	add    $0x18,%esp
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	56                   	push   %esi
  8013b8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8013b9:	8b 75 18             	mov    0x18(%ebp),%esi
  8013bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	56                   	push   %esi
  8013c9:	53                   	push   %ebx
  8013ca:	51                   	push   %ecx
  8013cb:	52                   	push   %edx
  8013cc:	50                   	push   %eax
  8013cd:	6a 08                	push   $0x8
  8013cf:	e8 d6 fe ff ff       	call   8012aa <syscall>
  8013d4:	83 c4 18             	add    $0x18,%esp
}
  8013d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013da:	5b                   	pop    %ebx
  8013db:	5e                   	pop    %esi
  8013dc:	5d                   	pop    %ebp
  8013dd:	c3                   	ret    

008013de <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	52                   	push   %edx
  8013ee:	50                   	push   %eax
  8013ef:	6a 09                	push   $0x9
  8013f1:	e8 b4 fe ff ff       	call   8012aa <syscall>
  8013f6:	83 c4 18             	add    $0x18,%esp
}
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	ff 75 0c             	pushl  0xc(%ebp)
  801407:	ff 75 08             	pushl  0x8(%ebp)
  80140a:	6a 0a                	push   $0xa
  80140c:	e8 99 fe ff ff       	call   8012aa <syscall>
  801411:	83 c4 18             	add    $0x18,%esp
}
  801414:	c9                   	leave  
  801415:	c3                   	ret    

00801416 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 0b                	push   $0xb
  801425:	e8 80 fe ff ff       	call   8012aa <syscall>
  80142a:	83 c4 18             	add    $0x18,%esp
}
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    

0080142f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 0c                	push   $0xc
  80143e:	e8 67 fe ff ff       	call   8012aa <syscall>
  801443:	83 c4 18             	add    $0x18,%esp
}
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	6a 0d                	push   $0xd
  801457:	e8 4e fe ff ff       	call   8012aa <syscall>
  80145c:	83 c4 18             	add    $0x18,%esp
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	ff 75 0c             	pushl  0xc(%ebp)
  80146d:	ff 75 08             	pushl  0x8(%ebp)
  801470:	6a 11                	push   $0x11
  801472:	e8 33 fe ff ff       	call   8012aa <syscall>
  801477:	83 c4 18             	add    $0x18,%esp
	return;
  80147a:	90                   	nop
}
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	ff 75 0c             	pushl  0xc(%ebp)
  801489:	ff 75 08             	pushl  0x8(%ebp)
  80148c:	6a 12                	push   $0x12
  80148e:	e8 17 fe ff ff       	call   8012aa <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
	return ;
  801496:	90                   	nop
}
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 0e                	push   $0xe
  8014a8:	e8 fd fd ff ff       	call   8012aa <syscall>
  8014ad:	83 c4 18             	add    $0x18,%esp
}
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	ff 75 08             	pushl  0x8(%ebp)
  8014c0:	6a 0f                	push   $0xf
  8014c2:	e8 e3 fd ff ff       	call   8012aa <syscall>
  8014c7:	83 c4 18             	add    $0x18,%esp
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 10                	push   $0x10
  8014db:	e8 ca fd ff ff       	call   8012aa <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
}
  8014e3:	90                   	nop
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 14                	push   $0x14
  8014f5:	e8 b0 fd ff ff       	call   8012aa <syscall>
  8014fa:	83 c4 18             	add    $0x18,%esp
}
  8014fd:	90                   	nop
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 15                	push   $0x15
  80150f:	e8 96 fd ff ff       	call   8012aa <syscall>
  801514:	83 c4 18             	add    $0x18,%esp
}
  801517:	90                   	nop
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <sys_cputc>:


void
sys_cputc(const char c)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	83 ec 04             	sub    $0x4,%esp
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801526:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	50                   	push   %eax
  801533:	6a 16                	push   $0x16
  801535:	e8 70 fd ff ff       	call   8012aa <syscall>
  80153a:	83 c4 18             	add    $0x18,%esp
}
  80153d:	90                   	nop
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 17                	push   $0x17
  80154f:	e8 56 fd ff ff       	call   8012aa <syscall>
  801554:	83 c4 18             	add    $0x18,%esp
}
  801557:	90                   	nop
  801558:	c9                   	leave  
  801559:	c3                   	ret    

0080155a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	ff 75 0c             	pushl  0xc(%ebp)
  801569:	50                   	push   %eax
  80156a:	6a 18                	push   $0x18
  80156c:	e8 39 fd ff ff       	call   8012aa <syscall>
  801571:	83 c4 18             	add    $0x18,%esp
}
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	52                   	push   %edx
  801586:	50                   	push   %eax
  801587:	6a 1b                	push   $0x1b
  801589:	e8 1c fd ff ff       	call   8012aa <syscall>
  80158e:	83 c4 18             	add    $0x18,%esp
}
  801591:	c9                   	leave  
  801592:	c3                   	ret    

00801593 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801596:	8b 55 0c             	mov    0xc(%ebp),%edx
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	52                   	push   %edx
  8015a3:	50                   	push   %eax
  8015a4:	6a 19                	push   $0x19
  8015a6:	e8 ff fc ff ff       	call   8012aa <syscall>
  8015ab:	83 c4 18             	add    $0x18,%esp
}
  8015ae:	90                   	nop
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	52                   	push   %edx
  8015c1:	50                   	push   %eax
  8015c2:	6a 1a                	push   $0x1a
  8015c4:	e8 e1 fc ff ff       	call   8012aa <syscall>
  8015c9:	83 c4 18             	add    $0x18,%esp
}
  8015cc:	90                   	nop
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015db:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	6a 00                	push   $0x0
  8015e7:	51                   	push   %ecx
  8015e8:	52                   	push   %edx
  8015e9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ec:	50                   	push   %eax
  8015ed:	6a 1c                	push   $0x1c
  8015ef:	e8 b6 fc ff ff       	call   8012aa <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	52                   	push   %edx
  801609:	50                   	push   %eax
  80160a:	6a 1d                	push   $0x1d
  80160c:	e8 99 fc ff ff       	call   8012aa <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801619:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80161c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	51                   	push   %ecx
  801627:	52                   	push   %edx
  801628:	50                   	push   %eax
  801629:	6a 1e                	push   $0x1e
  80162b:	e8 7a fc ff ff       	call   8012aa <syscall>
  801630:	83 c4 18             	add    $0x18,%esp
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801638:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	52                   	push   %edx
  801645:	50                   	push   %eax
  801646:	6a 1f                	push   $0x1f
  801648:	e8 5d fc ff ff       	call   8012aa <syscall>
  80164d:	83 c4 18             	add    $0x18,%esp
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 20                	push   $0x20
  801661:	e8 44 fc ff ff       	call   8012aa <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	ff 75 10             	pushl  0x10(%ebp)
  801678:	ff 75 0c             	pushl  0xc(%ebp)
  80167b:	50                   	push   %eax
  80167c:	6a 21                	push   $0x21
  80167e:	e8 27 fc ff ff       	call   8012aa <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
}
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	50                   	push   %eax
  801697:	6a 22                	push   $0x22
  801699:	e8 0c fc ff ff       	call   8012aa <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
}
  8016a1:	90                   	nop
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	50                   	push   %eax
  8016b3:	6a 23                	push   $0x23
  8016b5:	e8 f0 fb ff ff       	call   8012aa <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
}
  8016bd:	90                   	nop
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016c6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016c9:	8d 50 04             	lea    0x4(%eax),%edx
  8016cc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	52                   	push   %edx
  8016d6:	50                   	push   %eax
  8016d7:	6a 24                	push   $0x24
  8016d9:	e8 cc fb ff ff       	call   8012aa <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
	return result;
  8016e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ea:	89 01                	mov    %eax,(%ecx)
  8016ec:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	c9                   	leave  
  8016f3:	c2 04 00             	ret    $0x4

008016f6 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	ff 75 10             	pushl  0x10(%ebp)
  801700:	ff 75 0c             	pushl  0xc(%ebp)
  801703:	ff 75 08             	pushl  0x8(%ebp)
  801706:	6a 13                	push   $0x13
  801708:	e8 9d fb ff ff       	call   8012aa <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
	return ;
  801710:	90                   	nop
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sys_rcr2>:
uint32 sys_rcr2()
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 25                	push   $0x25
  801722:	e8 83 fb ff ff       	call   8012aa <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	83 ec 04             	sub    $0x4,%esp
  801732:	8b 45 08             	mov    0x8(%ebp),%eax
  801735:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801738:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	50                   	push   %eax
  801745:	6a 26                	push   $0x26
  801747:	e8 5e fb ff ff       	call   8012aa <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
	return ;
  80174f:	90                   	nop
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <rsttst>:
void rsttst()
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 28                	push   $0x28
  801761:	e8 44 fb ff ff       	call   8012aa <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
	return ;
  801769:	90                   	nop
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 04             	sub    $0x4,%esp
  801772:	8b 45 14             	mov    0x14(%ebp),%eax
  801775:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801778:	8b 55 18             	mov    0x18(%ebp),%edx
  80177b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80177f:	52                   	push   %edx
  801780:	50                   	push   %eax
  801781:	ff 75 10             	pushl  0x10(%ebp)
  801784:	ff 75 0c             	pushl  0xc(%ebp)
  801787:	ff 75 08             	pushl  0x8(%ebp)
  80178a:	6a 27                	push   $0x27
  80178c:	e8 19 fb ff ff       	call   8012aa <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
	return ;
  801794:	90                   	nop
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <chktst>:
void chktst(uint32 n)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	ff 75 08             	pushl  0x8(%ebp)
  8017a5:	6a 29                	push   $0x29
  8017a7:	e8 fe fa ff ff       	call   8012aa <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8017af:	90                   	nop
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <inctst>:

void inctst()
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 2a                	push   $0x2a
  8017c1:	e8 e4 fa ff ff       	call   8012aa <syscall>
  8017c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c9:	90                   	nop
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <gettst>:
uint32 gettst()
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 2b                	push   $0x2b
  8017db:	e8 ca fa ff ff       	call   8012aa <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 2c                	push   $0x2c
  8017f7:	e8 ae fa ff ff       	call   8012aa <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
  8017ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801802:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801806:	75 07                	jne    80180f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801808:	b8 01 00 00 00       	mov    $0x1,%eax
  80180d:	eb 05                	jmp    801814 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80180f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 2c                	push   $0x2c
  801828:	e8 7d fa ff ff       	call   8012aa <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
  801830:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801833:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801837:	75 07                	jne    801840 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801839:	b8 01 00 00 00       	mov    $0x1,%eax
  80183e:	eb 05                	jmp    801845 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801840:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 2c                	push   $0x2c
  801859:	e8 4c fa ff ff       	call   8012aa <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
  801861:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801864:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801868:	75 07                	jne    801871 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80186a:	b8 01 00 00 00       	mov    $0x1,%eax
  80186f:	eb 05                	jmp    801876 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801871:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 2c                	push   $0x2c
  80188a:	e8 1b fa ff ff       	call   8012aa <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
  801892:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801895:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801899:	75 07                	jne    8018a2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80189b:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a0:	eb 05                	jmp    8018a7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8018a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	ff 75 08             	pushl  0x8(%ebp)
  8018b7:	6a 2d                	push   $0x2d
  8018b9:	e8 ec f9 ff ff       	call   8012aa <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c1:	90                   	nop
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	6a 00                	push   $0x0
  8018d6:	53                   	push   %ebx
  8018d7:	51                   	push   %ecx
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	6a 2e                	push   $0x2e
  8018dc:	e8 c9 f9 ff ff       	call   8012aa <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	52                   	push   %edx
  8018f9:	50                   	push   %eax
  8018fa:	6a 2f                	push   $0x2f
  8018fc:	e8 a9 f9 ff ff       	call   8012aa <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80190c:	8b 55 08             	mov    0x8(%ebp),%edx
  80190f:	89 d0                	mov    %edx,%eax
  801911:	c1 e0 02             	shl    $0x2,%eax
  801914:	01 d0                	add    %edx,%eax
  801916:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80191d:	01 d0                	add    %edx,%eax
  80191f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801926:	01 d0                	add    %edx,%eax
  801928:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80192f:	01 d0                	add    %edx,%eax
  801931:	c1 e0 04             	shl    $0x4,%eax
  801934:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801937:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80193e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801941:	83 ec 0c             	sub    $0xc,%esp
  801944:	50                   	push   %eax
  801945:	e8 76 fd ff ff       	call   8016c0 <sys_get_virtual_time>
  80194a:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80194d:	eb 41                	jmp    801990 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80194f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801952:	83 ec 0c             	sub    $0xc,%esp
  801955:	50                   	push   %eax
  801956:	e8 65 fd ff ff       	call   8016c0 <sys_get_virtual_time>
  80195b:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80195e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801961:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801964:	29 c2                	sub    %eax,%edx
  801966:	89 d0                	mov    %edx,%eax
  801968:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80196b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80196e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801971:	89 d1                	mov    %edx,%ecx
  801973:	29 c1                	sub    %eax,%ecx
  801975:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801978:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80197b:	39 c2                	cmp    %eax,%edx
  80197d:	0f 97 c0             	seta   %al
  801980:	0f b6 c0             	movzbl %al,%eax
  801983:	29 c1                	sub    %eax,%ecx
  801985:	89 c8                	mov    %ecx,%eax
  801987:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80198a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80198d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801993:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801996:	72 b7                	jb     80194f <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8019a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8019a8:	eb 03                	jmp    8019ad <busy_wait+0x12>
  8019aa:	ff 45 fc             	incl   -0x4(%ebp)
  8019ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019b3:	72 f5                	jb     8019aa <busy_wait+0xf>
	return i;
  8019b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    
  8019ba:	66 90                	xchg   %ax,%ax

008019bc <__udivdi3>:
  8019bc:	55                   	push   %ebp
  8019bd:	57                   	push   %edi
  8019be:	56                   	push   %esi
  8019bf:	53                   	push   %ebx
  8019c0:	83 ec 1c             	sub    $0x1c,%esp
  8019c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019d3:	89 ca                	mov    %ecx,%edx
  8019d5:	89 f8                	mov    %edi,%eax
  8019d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019db:	85 f6                	test   %esi,%esi
  8019dd:	75 2d                	jne    801a0c <__udivdi3+0x50>
  8019df:	39 cf                	cmp    %ecx,%edi
  8019e1:	77 65                	ja     801a48 <__udivdi3+0x8c>
  8019e3:	89 fd                	mov    %edi,%ebp
  8019e5:	85 ff                	test   %edi,%edi
  8019e7:	75 0b                	jne    8019f4 <__udivdi3+0x38>
  8019e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ee:	31 d2                	xor    %edx,%edx
  8019f0:	f7 f7                	div    %edi
  8019f2:	89 c5                	mov    %eax,%ebp
  8019f4:	31 d2                	xor    %edx,%edx
  8019f6:	89 c8                	mov    %ecx,%eax
  8019f8:	f7 f5                	div    %ebp
  8019fa:	89 c1                	mov    %eax,%ecx
  8019fc:	89 d8                	mov    %ebx,%eax
  8019fe:	f7 f5                	div    %ebp
  801a00:	89 cf                	mov    %ecx,%edi
  801a02:	89 fa                	mov    %edi,%edx
  801a04:	83 c4 1c             	add    $0x1c,%esp
  801a07:	5b                   	pop    %ebx
  801a08:	5e                   	pop    %esi
  801a09:	5f                   	pop    %edi
  801a0a:	5d                   	pop    %ebp
  801a0b:	c3                   	ret    
  801a0c:	39 ce                	cmp    %ecx,%esi
  801a0e:	77 28                	ja     801a38 <__udivdi3+0x7c>
  801a10:	0f bd fe             	bsr    %esi,%edi
  801a13:	83 f7 1f             	xor    $0x1f,%edi
  801a16:	75 40                	jne    801a58 <__udivdi3+0x9c>
  801a18:	39 ce                	cmp    %ecx,%esi
  801a1a:	72 0a                	jb     801a26 <__udivdi3+0x6a>
  801a1c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a20:	0f 87 9e 00 00 00    	ja     801ac4 <__udivdi3+0x108>
  801a26:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2b:	89 fa                	mov    %edi,%edx
  801a2d:	83 c4 1c             	add    $0x1c,%esp
  801a30:	5b                   	pop    %ebx
  801a31:	5e                   	pop    %esi
  801a32:	5f                   	pop    %edi
  801a33:	5d                   	pop    %ebp
  801a34:	c3                   	ret    
  801a35:	8d 76 00             	lea    0x0(%esi),%esi
  801a38:	31 ff                	xor    %edi,%edi
  801a3a:	31 c0                	xor    %eax,%eax
  801a3c:	89 fa                	mov    %edi,%edx
  801a3e:	83 c4 1c             	add    $0x1c,%esp
  801a41:	5b                   	pop    %ebx
  801a42:	5e                   	pop    %esi
  801a43:	5f                   	pop    %edi
  801a44:	5d                   	pop    %ebp
  801a45:	c3                   	ret    
  801a46:	66 90                	xchg   %ax,%ax
  801a48:	89 d8                	mov    %ebx,%eax
  801a4a:	f7 f7                	div    %edi
  801a4c:	31 ff                	xor    %edi,%edi
  801a4e:	89 fa                	mov    %edi,%edx
  801a50:	83 c4 1c             	add    $0x1c,%esp
  801a53:	5b                   	pop    %ebx
  801a54:	5e                   	pop    %esi
  801a55:	5f                   	pop    %edi
  801a56:	5d                   	pop    %ebp
  801a57:	c3                   	ret    
  801a58:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a5d:	89 eb                	mov    %ebp,%ebx
  801a5f:	29 fb                	sub    %edi,%ebx
  801a61:	89 f9                	mov    %edi,%ecx
  801a63:	d3 e6                	shl    %cl,%esi
  801a65:	89 c5                	mov    %eax,%ebp
  801a67:	88 d9                	mov    %bl,%cl
  801a69:	d3 ed                	shr    %cl,%ebp
  801a6b:	89 e9                	mov    %ebp,%ecx
  801a6d:	09 f1                	or     %esi,%ecx
  801a6f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a73:	89 f9                	mov    %edi,%ecx
  801a75:	d3 e0                	shl    %cl,%eax
  801a77:	89 c5                	mov    %eax,%ebp
  801a79:	89 d6                	mov    %edx,%esi
  801a7b:	88 d9                	mov    %bl,%cl
  801a7d:	d3 ee                	shr    %cl,%esi
  801a7f:	89 f9                	mov    %edi,%ecx
  801a81:	d3 e2                	shl    %cl,%edx
  801a83:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a87:	88 d9                	mov    %bl,%cl
  801a89:	d3 e8                	shr    %cl,%eax
  801a8b:	09 c2                	or     %eax,%edx
  801a8d:	89 d0                	mov    %edx,%eax
  801a8f:	89 f2                	mov    %esi,%edx
  801a91:	f7 74 24 0c          	divl   0xc(%esp)
  801a95:	89 d6                	mov    %edx,%esi
  801a97:	89 c3                	mov    %eax,%ebx
  801a99:	f7 e5                	mul    %ebp
  801a9b:	39 d6                	cmp    %edx,%esi
  801a9d:	72 19                	jb     801ab8 <__udivdi3+0xfc>
  801a9f:	74 0b                	je     801aac <__udivdi3+0xf0>
  801aa1:	89 d8                	mov    %ebx,%eax
  801aa3:	31 ff                	xor    %edi,%edi
  801aa5:	e9 58 ff ff ff       	jmp    801a02 <__udivdi3+0x46>
  801aaa:	66 90                	xchg   %ax,%ax
  801aac:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ab0:	89 f9                	mov    %edi,%ecx
  801ab2:	d3 e2                	shl    %cl,%edx
  801ab4:	39 c2                	cmp    %eax,%edx
  801ab6:	73 e9                	jae    801aa1 <__udivdi3+0xe5>
  801ab8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801abb:	31 ff                	xor    %edi,%edi
  801abd:	e9 40 ff ff ff       	jmp    801a02 <__udivdi3+0x46>
  801ac2:	66 90                	xchg   %ax,%ax
  801ac4:	31 c0                	xor    %eax,%eax
  801ac6:	e9 37 ff ff ff       	jmp    801a02 <__udivdi3+0x46>
  801acb:	90                   	nop

00801acc <__umoddi3>:
  801acc:	55                   	push   %ebp
  801acd:	57                   	push   %edi
  801ace:	56                   	push   %esi
  801acf:	53                   	push   %ebx
  801ad0:	83 ec 1c             	sub    $0x1c,%esp
  801ad3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ad7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801adb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801adf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ae3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ae7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aeb:	89 f3                	mov    %esi,%ebx
  801aed:	89 fa                	mov    %edi,%edx
  801aef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801af3:	89 34 24             	mov    %esi,(%esp)
  801af6:	85 c0                	test   %eax,%eax
  801af8:	75 1a                	jne    801b14 <__umoddi3+0x48>
  801afa:	39 f7                	cmp    %esi,%edi
  801afc:	0f 86 a2 00 00 00    	jbe    801ba4 <__umoddi3+0xd8>
  801b02:	89 c8                	mov    %ecx,%eax
  801b04:	89 f2                	mov    %esi,%edx
  801b06:	f7 f7                	div    %edi
  801b08:	89 d0                	mov    %edx,%eax
  801b0a:	31 d2                	xor    %edx,%edx
  801b0c:	83 c4 1c             	add    $0x1c,%esp
  801b0f:	5b                   	pop    %ebx
  801b10:	5e                   	pop    %esi
  801b11:	5f                   	pop    %edi
  801b12:	5d                   	pop    %ebp
  801b13:	c3                   	ret    
  801b14:	39 f0                	cmp    %esi,%eax
  801b16:	0f 87 ac 00 00 00    	ja     801bc8 <__umoddi3+0xfc>
  801b1c:	0f bd e8             	bsr    %eax,%ebp
  801b1f:	83 f5 1f             	xor    $0x1f,%ebp
  801b22:	0f 84 ac 00 00 00    	je     801bd4 <__umoddi3+0x108>
  801b28:	bf 20 00 00 00       	mov    $0x20,%edi
  801b2d:	29 ef                	sub    %ebp,%edi
  801b2f:	89 fe                	mov    %edi,%esi
  801b31:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b35:	89 e9                	mov    %ebp,%ecx
  801b37:	d3 e0                	shl    %cl,%eax
  801b39:	89 d7                	mov    %edx,%edi
  801b3b:	89 f1                	mov    %esi,%ecx
  801b3d:	d3 ef                	shr    %cl,%edi
  801b3f:	09 c7                	or     %eax,%edi
  801b41:	89 e9                	mov    %ebp,%ecx
  801b43:	d3 e2                	shl    %cl,%edx
  801b45:	89 14 24             	mov    %edx,(%esp)
  801b48:	89 d8                	mov    %ebx,%eax
  801b4a:	d3 e0                	shl    %cl,%eax
  801b4c:	89 c2                	mov    %eax,%edx
  801b4e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b52:	d3 e0                	shl    %cl,%eax
  801b54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b58:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b5c:	89 f1                	mov    %esi,%ecx
  801b5e:	d3 e8                	shr    %cl,%eax
  801b60:	09 d0                	or     %edx,%eax
  801b62:	d3 eb                	shr    %cl,%ebx
  801b64:	89 da                	mov    %ebx,%edx
  801b66:	f7 f7                	div    %edi
  801b68:	89 d3                	mov    %edx,%ebx
  801b6a:	f7 24 24             	mull   (%esp)
  801b6d:	89 c6                	mov    %eax,%esi
  801b6f:	89 d1                	mov    %edx,%ecx
  801b71:	39 d3                	cmp    %edx,%ebx
  801b73:	0f 82 87 00 00 00    	jb     801c00 <__umoddi3+0x134>
  801b79:	0f 84 91 00 00 00    	je     801c10 <__umoddi3+0x144>
  801b7f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b83:	29 f2                	sub    %esi,%edx
  801b85:	19 cb                	sbb    %ecx,%ebx
  801b87:	89 d8                	mov    %ebx,%eax
  801b89:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b8d:	d3 e0                	shl    %cl,%eax
  801b8f:	89 e9                	mov    %ebp,%ecx
  801b91:	d3 ea                	shr    %cl,%edx
  801b93:	09 d0                	or     %edx,%eax
  801b95:	89 e9                	mov    %ebp,%ecx
  801b97:	d3 eb                	shr    %cl,%ebx
  801b99:	89 da                	mov    %ebx,%edx
  801b9b:	83 c4 1c             	add    $0x1c,%esp
  801b9e:	5b                   	pop    %ebx
  801b9f:	5e                   	pop    %esi
  801ba0:	5f                   	pop    %edi
  801ba1:	5d                   	pop    %ebp
  801ba2:	c3                   	ret    
  801ba3:	90                   	nop
  801ba4:	89 fd                	mov    %edi,%ebp
  801ba6:	85 ff                	test   %edi,%edi
  801ba8:	75 0b                	jne    801bb5 <__umoddi3+0xe9>
  801baa:	b8 01 00 00 00       	mov    $0x1,%eax
  801baf:	31 d2                	xor    %edx,%edx
  801bb1:	f7 f7                	div    %edi
  801bb3:	89 c5                	mov    %eax,%ebp
  801bb5:	89 f0                	mov    %esi,%eax
  801bb7:	31 d2                	xor    %edx,%edx
  801bb9:	f7 f5                	div    %ebp
  801bbb:	89 c8                	mov    %ecx,%eax
  801bbd:	f7 f5                	div    %ebp
  801bbf:	89 d0                	mov    %edx,%eax
  801bc1:	e9 44 ff ff ff       	jmp    801b0a <__umoddi3+0x3e>
  801bc6:	66 90                	xchg   %ax,%ax
  801bc8:	89 c8                	mov    %ecx,%eax
  801bca:	89 f2                	mov    %esi,%edx
  801bcc:	83 c4 1c             	add    $0x1c,%esp
  801bcf:	5b                   	pop    %ebx
  801bd0:	5e                   	pop    %esi
  801bd1:	5f                   	pop    %edi
  801bd2:	5d                   	pop    %ebp
  801bd3:	c3                   	ret    
  801bd4:	3b 04 24             	cmp    (%esp),%eax
  801bd7:	72 06                	jb     801bdf <__umoddi3+0x113>
  801bd9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bdd:	77 0f                	ja     801bee <__umoddi3+0x122>
  801bdf:	89 f2                	mov    %esi,%edx
  801be1:	29 f9                	sub    %edi,%ecx
  801be3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801be7:	89 14 24             	mov    %edx,(%esp)
  801bea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bee:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bf2:	8b 14 24             	mov    (%esp),%edx
  801bf5:	83 c4 1c             	add    $0x1c,%esp
  801bf8:	5b                   	pop    %ebx
  801bf9:	5e                   	pop    %esi
  801bfa:	5f                   	pop    %edi
  801bfb:	5d                   	pop    %ebp
  801bfc:	c3                   	ret    
  801bfd:	8d 76 00             	lea    0x0(%esi),%esi
  801c00:	2b 04 24             	sub    (%esp),%eax
  801c03:	19 fa                	sbb    %edi,%edx
  801c05:	89 d1                	mov    %edx,%ecx
  801c07:	89 c6                	mov    %eax,%esi
  801c09:	e9 71 ff ff ff       	jmp    801b7f <__umoddi3+0xb3>
  801c0e:	66 90                	xchg   %ax,%ax
  801c10:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c14:	72 ea                	jb     801c00 <__umoddi3+0x134>
  801c16:	89 d9                	mov    %ebx,%ecx
  801c18:	e9 62 ff ff ff       	jmp    801b7f <__umoddi3+0xb3>
