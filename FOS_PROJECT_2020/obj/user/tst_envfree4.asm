
obj/user/tst_envfree4:     file format elf32-i386


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
  800031:	e8 04 01 00 00       	call   80013a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing scenario 4: Freeing the allocated semaphores
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 20 1c 80 00       	push   $0x801c20
  80004a:	e8 76 12 00 00       	call   8012c5 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 5c 14 00 00       	call   8014bf <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 d7 14 00 00       	call   801542 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 1c 80 00       	push   $0x801c30
  800079:	e8 a3 04 00 00       	call   800521 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tsem1", 100, 50);
  800081:	83 ec 04             	sub    $0x4,%esp
  800084:	6a 32                	push   $0x32
  800086:	6a 64                	push   $0x64
  800088:	68 63 1c 80 00       	push   $0x801c63
  80008d:	e8 82 16 00 00       	call   801714 <sys_create_env>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	ff 75 e8             	pushl  -0x18(%ebp)
  80009e:	e8 8e 16 00 00       	call   801731 <sys_run_env>
  8000a3:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000a6:	90                   	nop
  8000a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000aa:	8b 00                	mov    (%eax),%eax
  8000ac:	83 f8 01             	cmp    $0x1,%eax
  8000af:	75 f6                	jne    8000a7 <_main+0x6f>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000b1:	e8 09 14 00 00       	call   8014bf <sys_calculate_free_frames>
  8000b6:	83 ec 08             	sub    $0x8,%esp
  8000b9:	50                   	push   %eax
  8000ba:	68 6c 1c 80 00       	push   $0x801c6c
  8000bf:	e8 5d 04 00 00       	call   800521 <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp

	sys_free_env(envIdProcessA);
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8000cd:	e8 7b 16 00 00       	call   80174d <sys_free_env>
  8000d2:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000d5:	e8 e5 13 00 00       	call   8014bf <sys_calculate_free_frames>
  8000da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000dd:	e8 60 14 00 00       	call   801542 <sys_pf_calculate_allocated_pages>
  8000e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000eb:	74 27                	je     800114 <_main+0xdc>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f3:	68 a0 1c 80 00       	push   $0x801ca0
  8000f8:	e8 24 04 00 00       	call   800521 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	68 f0 1c 80 00       	push   $0x801cf0
  800108:	6a 1f                	push   $0x1f
  80010a:	68 26 1d 80 00       	push   $0x801d26
  80010f:	e8 6b 01 00 00       	call   80027f <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	ff 75 e4             	pushl  -0x1c(%ebp)
  80011a:	68 3c 1d 80 00       	push   $0x801d3c
  80011f:	e8 fd 03 00 00       	call   800521 <cprintf>
  800124:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 4 for envfree completed successfully.\n");
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	68 9c 1d 80 00       	push   $0x801d9c
  80012f:	e8 ed 03 00 00       	call   800521 <cprintf>
  800134:	83 c4 10             	add    $0x10,%esp
	return;
  800137:	90                   	nop
}
  800138:	c9                   	leave  
  800139:	c3                   	ret    

0080013a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80013a:	55                   	push   %ebp
  80013b:	89 e5                	mov    %esp,%ebp
  80013d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800140:	e8 af 12 00 00       	call   8013f4 <sys_getenvindex>
  800145:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800148:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80014b:	89 d0                	mov    %edx,%eax
  80014d:	c1 e0 03             	shl    $0x3,%eax
  800150:	01 d0                	add    %edx,%eax
  800152:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800159:	01 c8                	add    %ecx,%eax
  80015b:	01 c0                	add    %eax,%eax
  80015d:	01 d0                	add    %edx,%eax
  80015f:	01 c0                	add    %eax,%eax
  800161:	01 d0                	add    %edx,%eax
  800163:	89 c2                	mov    %eax,%edx
  800165:	c1 e2 05             	shl    $0x5,%edx
  800168:	29 c2                	sub    %eax,%edx
  80016a:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800171:	89 c2                	mov    %eax,%edx
  800173:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800179:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80017e:	a1 20 30 80 00       	mov    0x803020,%eax
  800183:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800189:	84 c0                	test   %al,%al
  80018b:	74 0f                	je     80019c <libmain+0x62>
		binaryname = myEnv->prog_name;
  80018d:	a1 20 30 80 00       	mov    0x803020,%eax
  800192:	05 40 3c 01 00       	add    $0x13c40,%eax
  800197:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a0:	7e 0a                	jle    8001ac <libmain+0x72>
		binaryname = argv[0];
  8001a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a5:	8b 00                	mov    (%eax),%eax
  8001a7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001ac:	83 ec 08             	sub    $0x8,%esp
  8001af:	ff 75 0c             	pushl  0xc(%ebp)
  8001b2:	ff 75 08             	pushl  0x8(%ebp)
  8001b5:	e8 7e fe ff ff       	call   800038 <_main>
  8001ba:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001bd:	e8 cd 13 00 00       	call   80158f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	68 00 1e 80 00       	push   $0x801e00
  8001ca:	e8 52 03 00 00       	call   800521 <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d7:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8001dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e2:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8001e8:	83 ec 04             	sub    $0x4,%esp
  8001eb:	52                   	push   %edx
  8001ec:	50                   	push   %eax
  8001ed:	68 28 1e 80 00       	push   $0x801e28
  8001f2:	e8 2a 03 00 00       	call   800521 <cprintf>
  8001f7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8001fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ff:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800205:	a1 20 30 80 00       	mov    0x803020,%eax
  80020a:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800210:	83 ec 04             	sub    $0x4,%esp
  800213:	52                   	push   %edx
  800214:	50                   	push   %eax
  800215:	68 50 1e 80 00       	push   $0x801e50
  80021a:	e8 02 03 00 00       	call   800521 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800222:	a1 20 30 80 00       	mov    0x803020,%eax
  800227:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	50                   	push   %eax
  800231:	68 91 1e 80 00       	push   $0x801e91
  800236:	e8 e6 02 00 00       	call   800521 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	68 00 1e 80 00       	push   $0x801e00
  800246:	e8 d6 02 00 00       	call   800521 <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024e:	e8 56 13 00 00       	call   8015a9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800253:	e8 19 00 00 00       	call   800271 <exit>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	6a 00                	push   $0x0
  800266:	e8 55 11 00 00       	call   8013c0 <sys_env_destroy>
  80026b:	83 c4 10             	add    $0x10,%esp
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <exit>:

void
exit(void)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800277:	e8 aa 11 00 00       	call   801426 <sys_env_exit>
}
  80027c:	90                   	nop
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800285:	8d 45 10             	lea    0x10(%ebp),%eax
  800288:	83 c0 04             	add    $0x4,%eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80028e:	a1 18 31 80 00       	mov    0x803118,%eax
  800293:	85 c0                	test   %eax,%eax
  800295:	74 16                	je     8002ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  800297:	a1 18 31 80 00       	mov    0x803118,%eax
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	50                   	push   %eax
  8002a0:	68 a8 1e 80 00       	push   $0x801ea8
  8002a5:	e8 77 02 00 00       	call   800521 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ad:	a1 00 30 80 00       	mov    0x803000,%eax
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	50                   	push   %eax
  8002b9:	68 ad 1e 80 00       	push   $0x801ead
  8002be:	e8 5e 02 00 00       	call   800521 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cf:	50                   	push   %eax
  8002d0:	e8 e1 01 00 00       	call   8004b6 <vcprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d8:	83 ec 08             	sub    $0x8,%esp
  8002db:	6a 00                	push   $0x0
  8002dd:	68 c9 1e 80 00       	push   $0x801ec9
  8002e2:	e8 cf 01 00 00       	call   8004b6 <vcprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ea:	e8 82 ff ff ff       	call   800271 <exit>

	// should not return here
	while (1) ;
  8002ef:	eb fe                	jmp    8002ef <_panic+0x70>

008002f1 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002fc:	8b 50 74             	mov    0x74(%eax),%edx
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	74 14                	je     80031a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	68 cc 1e 80 00       	push   $0x801ecc
  80030e:	6a 26                	push   $0x26
  800310:	68 18 1f 80 00       	push   $0x801f18
  800315:	e8 65 ff ff ff       	call   80027f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	e9 b6 00 00 00       	jmp    8003e3 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800330:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	01 d0                	add    %edx,%eax
  80033c:	8b 00                	mov    (%eax),%eax
  80033e:	85 c0                	test   %eax,%eax
  800340:	75 08                	jne    80034a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800342:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800345:	e9 96 00 00 00       	jmp    8003e0 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80034a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800351:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800358:	eb 5d                	jmp    8003b7 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035a:	a1 20 30 80 00       	mov    0x803020,%eax
  80035f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800365:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800368:	c1 e2 04             	shl    $0x4,%edx
  80036b:	01 d0                	add    %edx,%eax
  80036d:	8a 40 04             	mov    0x4(%eax),%al
  800370:	84 c0                	test   %al,%al
  800372:	75 40                	jne    8003b4 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800374:	a1 20 30 80 00       	mov    0x803020,%eax
  800379:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80037f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800382:	c1 e2 04             	shl    $0x4,%edx
  800385:	01 d0                	add    %edx,%eax
  800387:	8b 00                	mov    (%eax),%eax
  800389:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80038c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800394:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800399:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a3:	01 c8                	add    %ecx,%eax
  8003a5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a7:	39 c2                	cmp    %eax,%edx
  8003a9:	75 09                	jne    8003b4 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8003ab:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b2:	eb 12                	jmp    8003c6 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b4:	ff 45 e8             	incl   -0x18(%ebp)
  8003b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003bc:	8b 50 74             	mov    0x74(%eax),%edx
  8003bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c2:	39 c2                	cmp    %eax,%edx
  8003c4:	77 94                	ja     80035a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ca:	75 14                	jne    8003e0 <CheckWSWithoutLastIndex+0xef>
			panic(
  8003cc:	83 ec 04             	sub    $0x4,%esp
  8003cf:	68 24 1f 80 00       	push   $0x801f24
  8003d4:	6a 3a                	push   $0x3a
  8003d6:	68 18 1f 80 00       	push   $0x801f18
  8003db:	e8 9f fe ff ff       	call   80027f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e0:	ff 45 f0             	incl   -0x10(%ebp)
  8003e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e9:	0f 8c 3e ff ff ff    	jl     80032d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003fd:	eb 20                	jmp    80041f <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800404:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80040a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80040d:	c1 e2 04             	shl    $0x4,%edx
  800410:	01 d0                	add    %edx,%eax
  800412:	8a 40 04             	mov    0x4(%eax),%al
  800415:	3c 01                	cmp    $0x1,%al
  800417:	75 03                	jne    80041c <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800419:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80041c:	ff 45 e0             	incl   -0x20(%ebp)
  80041f:	a1 20 30 80 00       	mov    0x803020,%eax
  800424:	8b 50 74             	mov    0x74(%eax),%edx
  800427:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042a:	39 c2                	cmp    %eax,%edx
  80042c:	77 d1                	ja     8003ff <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80042e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800431:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800434:	74 14                	je     80044a <CheckWSWithoutLastIndex+0x159>
		panic(
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	68 78 1f 80 00       	push   $0x801f78
  80043e:	6a 44                	push   $0x44
  800440:	68 18 1f 80 00       	push   $0x801f18
  800445:	e8 35 fe ff ff       	call   80027f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80044a:	90                   	nop
  80044b:	c9                   	leave  
  80044c:	c3                   	ret    

0080044d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800453:	8b 45 0c             	mov    0xc(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	8d 48 01             	lea    0x1(%eax),%ecx
  80045b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045e:	89 0a                	mov    %ecx,(%edx)
  800460:	8b 55 08             	mov    0x8(%ebp),%edx
  800463:	88 d1                	mov    %dl,%cl
  800465:	8b 55 0c             	mov    0xc(%ebp),%edx
  800468:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80046c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046f:	8b 00                	mov    (%eax),%eax
  800471:	3d ff 00 00 00       	cmp    $0xff,%eax
  800476:	75 2c                	jne    8004a4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800478:	a0 24 30 80 00       	mov    0x803024,%al
  80047d:	0f b6 c0             	movzbl %al,%eax
  800480:	8b 55 0c             	mov    0xc(%ebp),%edx
  800483:	8b 12                	mov    (%edx),%edx
  800485:	89 d1                	mov    %edx,%ecx
  800487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048a:	83 c2 08             	add    $0x8,%edx
  80048d:	83 ec 04             	sub    $0x4,%esp
  800490:	50                   	push   %eax
  800491:	51                   	push   %ecx
  800492:	52                   	push   %edx
  800493:	e8 e6 0e 00 00       	call   80137e <sys_cputs>
  800498:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a7:	8b 40 04             	mov    0x4(%eax),%eax
  8004aa:	8d 50 01             	lea    0x1(%eax),%edx
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b3:	90                   	nop
  8004b4:	c9                   	leave  
  8004b5:	c3                   	ret    

008004b6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b6:	55                   	push   %ebp
  8004b7:	89 e5                	mov    %esp,%ebp
  8004b9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c6:	00 00 00 
	b.cnt = 0;
  8004c9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d3:	ff 75 0c             	pushl  0xc(%ebp)
  8004d6:	ff 75 08             	pushl  0x8(%ebp)
  8004d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004df:	50                   	push   %eax
  8004e0:	68 4d 04 80 00       	push   $0x80044d
  8004e5:	e8 11 02 00 00       	call   8006fb <vprintfmt>
  8004ea:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004ed:	a0 24 30 80 00       	mov    0x803024,%al
  8004f2:	0f b6 c0             	movzbl %al,%eax
  8004f5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004fb:	83 ec 04             	sub    $0x4,%esp
  8004fe:	50                   	push   %eax
  8004ff:	52                   	push   %edx
  800500:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800506:	83 c0 08             	add    $0x8,%eax
  800509:	50                   	push   %eax
  80050a:	e8 6f 0e 00 00       	call   80137e <sys_cputs>
  80050f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800512:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800519:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80051f:	c9                   	leave  
  800520:	c3                   	ret    

00800521 <cprintf>:

int cprintf(const char *fmt, ...) {
  800521:	55                   	push   %ebp
  800522:	89 e5                	mov    %esp,%ebp
  800524:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800527:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80052e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800531:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800534:	8b 45 08             	mov    0x8(%ebp),%eax
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	ff 75 f4             	pushl  -0xc(%ebp)
  80053d:	50                   	push   %eax
  80053e:	e8 73 ff ff ff       	call   8004b6 <vcprintf>
  800543:	83 c4 10             	add    $0x10,%esp
  800546:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800549:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054c:	c9                   	leave  
  80054d:	c3                   	ret    

0080054e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800554:	e8 36 10 00 00       	call   80158f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800559:	8d 45 0c             	lea    0xc(%ebp),%eax
  80055c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	ff 75 f4             	pushl  -0xc(%ebp)
  800568:	50                   	push   %eax
  800569:	e8 48 ff ff ff       	call   8004b6 <vcprintf>
  80056e:	83 c4 10             	add    $0x10,%esp
  800571:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800574:	e8 30 10 00 00       	call   8015a9 <sys_enable_interrupt>
	return cnt;
  800579:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	53                   	push   %ebx
  800582:	83 ec 14             	sub    $0x14,%esp
  800585:	8b 45 10             	mov    0x10(%ebp),%eax
  800588:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058b:	8b 45 14             	mov    0x14(%ebp),%eax
  80058e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800591:	8b 45 18             	mov    0x18(%ebp),%eax
  800594:	ba 00 00 00 00       	mov    $0x0,%edx
  800599:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059c:	77 55                	ja     8005f3 <printnum+0x75>
  80059e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a1:	72 05                	jb     8005a8 <printnum+0x2a>
  8005a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005a6:	77 4b                	ja     8005f3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005a8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ab:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005ae:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b6:	52                   	push   %edx
  8005b7:	50                   	push   %eax
  8005b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8005be:	e8 ed 13 00 00       	call   8019b0 <__udivdi3>
  8005c3:	83 c4 10             	add    $0x10,%esp
  8005c6:	83 ec 04             	sub    $0x4,%esp
  8005c9:	ff 75 20             	pushl  0x20(%ebp)
  8005cc:	53                   	push   %ebx
  8005cd:	ff 75 18             	pushl  0x18(%ebp)
  8005d0:	52                   	push   %edx
  8005d1:	50                   	push   %eax
  8005d2:	ff 75 0c             	pushl  0xc(%ebp)
  8005d5:	ff 75 08             	pushl  0x8(%ebp)
  8005d8:	e8 a1 ff ff ff       	call   80057e <printnum>
  8005dd:	83 c4 20             	add    $0x20,%esp
  8005e0:	eb 1a                	jmp    8005fc <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	ff 75 0c             	pushl  0xc(%ebp)
  8005e8:	ff 75 20             	pushl  0x20(%ebp)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	ff d0                	call   *%eax
  8005f0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f3:	ff 4d 1c             	decl   0x1c(%ebp)
  8005f6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005fa:	7f e6                	jg     8005e2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005fc:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800607:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060a:	53                   	push   %ebx
  80060b:	51                   	push   %ecx
  80060c:	52                   	push   %edx
  80060d:	50                   	push   %eax
  80060e:	e8 ad 14 00 00       	call   801ac0 <__umoddi3>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	05 f4 21 80 00       	add    $0x8021f4,%eax
  80061b:	8a 00                	mov    (%eax),%al
  80061d:	0f be c0             	movsbl %al,%eax
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	ff 75 0c             	pushl  0xc(%ebp)
  800626:	50                   	push   %eax
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	ff d0                	call   *%eax
  80062c:	83 c4 10             	add    $0x10,%esp
}
  80062f:	90                   	nop
  800630:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800633:	c9                   	leave  
  800634:	c3                   	ret    

00800635 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800638:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80063c:	7e 1c                	jle    80065a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	8b 00                	mov    (%eax),%eax
  800643:	8d 50 08             	lea    0x8(%eax),%edx
  800646:	8b 45 08             	mov    0x8(%ebp),%eax
  800649:	89 10                	mov    %edx,(%eax)
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	83 e8 08             	sub    $0x8,%eax
  800653:	8b 50 04             	mov    0x4(%eax),%edx
  800656:	8b 00                	mov    (%eax),%eax
  800658:	eb 40                	jmp    80069a <getuint+0x65>
	else if (lflag)
  80065a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80065e:	74 1e                	je     80067e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	8d 50 04             	lea    0x4(%eax),%edx
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	89 10                	mov    %edx,(%eax)
  80066d:	8b 45 08             	mov    0x8(%ebp),%eax
  800670:	8b 00                	mov    (%eax),%eax
  800672:	83 e8 04             	sub    $0x4,%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
  80067c:	eb 1c                	jmp    80069a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	8d 50 04             	lea    0x4(%eax),%edx
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	89 10                	mov    %edx,(%eax)
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	83 e8 04             	sub    $0x4,%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069a:	5d                   	pop    %ebp
  80069b:	c3                   	ret    

0080069c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80069c:	55                   	push   %ebp
  80069d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80069f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a3:	7e 1c                	jle    8006c1 <getint+0x25>
		return va_arg(*ap, long long);
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	8d 50 08             	lea    0x8(%eax),%edx
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	89 10                	mov    %edx,(%eax)
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	83 e8 08             	sub    $0x8,%eax
  8006ba:	8b 50 04             	mov    0x4(%eax),%edx
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	eb 38                	jmp    8006f9 <getint+0x5d>
	else if (lflag)
  8006c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c5:	74 1a                	je     8006e1 <getint+0x45>
		return va_arg(*ap, long);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	8d 50 04             	lea    0x4(%eax),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	89 10                	mov    %edx,(%eax)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	83 e8 04             	sub    $0x4,%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	99                   	cltd   
  8006df:	eb 18                	jmp    8006f9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	8d 50 04             	lea    0x4(%eax),%edx
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	89 10                	mov    %edx,(%eax)
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	83 e8 04             	sub    $0x4,%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	99                   	cltd   
}
  8006f9:	5d                   	pop    %ebp
  8006fa:	c3                   	ret    

008006fb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	56                   	push   %esi
  8006ff:	53                   	push   %ebx
  800700:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800703:	eb 17                	jmp    80071c <vprintfmt+0x21>
			if (ch == '\0')
  800705:	85 db                	test   %ebx,%ebx
  800707:	0f 84 af 03 00 00    	je     800abc <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80070d:	83 ec 08             	sub    $0x8,%esp
  800710:	ff 75 0c             	pushl  0xc(%ebp)
  800713:	53                   	push   %ebx
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	ff d0                	call   *%eax
  800719:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071c:	8b 45 10             	mov    0x10(%ebp),%eax
  80071f:	8d 50 01             	lea    0x1(%eax),%edx
  800722:	89 55 10             	mov    %edx,0x10(%ebp)
  800725:	8a 00                	mov    (%eax),%al
  800727:	0f b6 d8             	movzbl %al,%ebx
  80072a:	83 fb 25             	cmp    $0x25,%ebx
  80072d:	75 d6                	jne    800705 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80072f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800733:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80073a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800741:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800748:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80074f:	8b 45 10             	mov    0x10(%ebp),%eax
  800752:	8d 50 01             	lea    0x1(%eax),%edx
  800755:	89 55 10             	mov    %edx,0x10(%ebp)
  800758:	8a 00                	mov    (%eax),%al
  80075a:	0f b6 d8             	movzbl %al,%ebx
  80075d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800760:	83 f8 55             	cmp    $0x55,%eax
  800763:	0f 87 2b 03 00 00    	ja     800a94 <vprintfmt+0x399>
  800769:	8b 04 85 18 22 80 00 	mov    0x802218(,%eax,4),%eax
  800770:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800772:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800776:	eb d7                	jmp    80074f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800778:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80077c:	eb d1                	jmp    80074f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80077e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800785:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800788:	89 d0                	mov    %edx,%eax
  80078a:	c1 e0 02             	shl    $0x2,%eax
  80078d:	01 d0                	add    %edx,%eax
  80078f:	01 c0                	add    %eax,%eax
  800791:	01 d8                	add    %ebx,%eax
  800793:	83 e8 30             	sub    $0x30,%eax
  800796:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800799:	8b 45 10             	mov    0x10(%ebp),%eax
  80079c:	8a 00                	mov    (%eax),%al
  80079e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a1:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a4:	7e 3e                	jle    8007e4 <vprintfmt+0xe9>
  8007a6:	83 fb 39             	cmp    $0x39,%ebx
  8007a9:	7f 39                	jg     8007e4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ab:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ae:	eb d5                	jmp    800785 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	83 c0 04             	add    $0x4,%eax
  8007b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	83 e8 04             	sub    $0x4,%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c4:	eb 1f                	jmp    8007e5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ca:	79 83                	jns    80074f <vprintfmt+0x54>
				width = 0;
  8007cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d3:	e9 77 ff ff ff       	jmp    80074f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007d8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007df:	e9 6b ff ff ff       	jmp    80074f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e9:	0f 89 60 ff ff ff    	jns    80074f <vprintfmt+0x54>
				width = precision, precision = -1;
  8007ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007fc:	e9 4e ff ff ff       	jmp    80074f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800801:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800804:	e9 46 ff ff ff       	jmp    80074f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	83 c0 04             	add    $0x4,%eax
  80080f:	89 45 14             	mov    %eax,0x14(%ebp)
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	83 e8 04             	sub    $0x4,%eax
  800818:	8b 00                	mov    (%eax),%eax
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	ff 75 0c             	pushl  0xc(%ebp)
  800820:	50                   	push   %eax
  800821:	8b 45 08             	mov    0x8(%ebp),%eax
  800824:	ff d0                	call   *%eax
  800826:	83 c4 10             	add    $0x10,%esp
			break;
  800829:	e9 89 02 00 00       	jmp    800ab7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80082e:	8b 45 14             	mov    0x14(%ebp),%eax
  800831:	83 c0 04             	add    $0x4,%eax
  800834:	89 45 14             	mov    %eax,0x14(%ebp)
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	83 e8 04             	sub    $0x4,%eax
  80083d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80083f:	85 db                	test   %ebx,%ebx
  800841:	79 02                	jns    800845 <vprintfmt+0x14a>
				err = -err;
  800843:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800845:	83 fb 64             	cmp    $0x64,%ebx
  800848:	7f 0b                	jg     800855 <vprintfmt+0x15a>
  80084a:	8b 34 9d 60 20 80 00 	mov    0x802060(,%ebx,4),%esi
  800851:	85 f6                	test   %esi,%esi
  800853:	75 19                	jne    80086e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800855:	53                   	push   %ebx
  800856:	68 05 22 80 00       	push   $0x802205
  80085b:	ff 75 0c             	pushl  0xc(%ebp)
  80085e:	ff 75 08             	pushl  0x8(%ebp)
  800861:	e8 5e 02 00 00       	call   800ac4 <printfmt>
  800866:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800869:	e9 49 02 00 00       	jmp    800ab7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80086e:	56                   	push   %esi
  80086f:	68 0e 22 80 00       	push   $0x80220e
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	ff 75 08             	pushl  0x8(%ebp)
  80087a:	e8 45 02 00 00       	call   800ac4 <printfmt>
  80087f:	83 c4 10             	add    $0x10,%esp
			break;
  800882:	e9 30 02 00 00       	jmp    800ab7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	83 c0 04             	add    $0x4,%eax
  80088d:	89 45 14             	mov    %eax,0x14(%ebp)
  800890:	8b 45 14             	mov    0x14(%ebp),%eax
  800893:	83 e8 04             	sub    $0x4,%eax
  800896:	8b 30                	mov    (%eax),%esi
  800898:	85 f6                	test   %esi,%esi
  80089a:	75 05                	jne    8008a1 <vprintfmt+0x1a6>
				p = "(null)";
  80089c:	be 11 22 80 00       	mov    $0x802211,%esi
			if (width > 0 && padc != '-')
  8008a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a5:	7e 6d                	jle    800914 <vprintfmt+0x219>
  8008a7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ab:	74 67                	je     800914 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b0:	83 ec 08             	sub    $0x8,%esp
  8008b3:	50                   	push   %eax
  8008b4:	56                   	push   %esi
  8008b5:	e8 0c 03 00 00       	call   800bc6 <strnlen>
  8008ba:	83 c4 10             	add    $0x10,%esp
  8008bd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c0:	eb 16                	jmp    8008d8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	50                   	push   %eax
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	ff d0                	call   *%eax
  8008d2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d5:	ff 4d e4             	decl   -0x1c(%ebp)
  8008d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008dc:	7f e4                	jg     8008c2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008de:	eb 34                	jmp    800914 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e4:	74 1c                	je     800902 <vprintfmt+0x207>
  8008e6:	83 fb 1f             	cmp    $0x1f,%ebx
  8008e9:	7e 05                	jle    8008f0 <vprintfmt+0x1f5>
  8008eb:	83 fb 7e             	cmp    $0x7e,%ebx
  8008ee:	7e 12                	jle    800902 <vprintfmt+0x207>
					putch('?', putdat);
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	6a 3f                	push   $0x3f
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	ff d0                	call   *%eax
  8008fd:	83 c4 10             	add    $0x10,%esp
  800900:	eb 0f                	jmp    800911 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	53                   	push   %ebx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	ff d0                	call   *%eax
  80090e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800911:	ff 4d e4             	decl   -0x1c(%ebp)
  800914:	89 f0                	mov    %esi,%eax
  800916:	8d 70 01             	lea    0x1(%eax),%esi
  800919:	8a 00                	mov    (%eax),%al
  80091b:	0f be d8             	movsbl %al,%ebx
  80091e:	85 db                	test   %ebx,%ebx
  800920:	74 24                	je     800946 <vprintfmt+0x24b>
  800922:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800926:	78 b8                	js     8008e0 <vprintfmt+0x1e5>
  800928:	ff 4d e0             	decl   -0x20(%ebp)
  80092b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092f:	79 af                	jns    8008e0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800931:	eb 13                	jmp    800946 <vprintfmt+0x24b>
				putch(' ', putdat);
  800933:	83 ec 08             	sub    $0x8,%esp
  800936:	ff 75 0c             	pushl  0xc(%ebp)
  800939:	6a 20                	push   $0x20
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	ff d0                	call   *%eax
  800940:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800943:	ff 4d e4             	decl   -0x1c(%ebp)
  800946:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094a:	7f e7                	jg     800933 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80094c:	e9 66 01 00 00       	jmp    800ab7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 e8             	pushl  -0x18(%ebp)
  800957:	8d 45 14             	lea    0x14(%ebp),%eax
  80095a:	50                   	push   %eax
  80095b:	e8 3c fd ff ff       	call   80069c <getint>
  800960:	83 c4 10             	add    $0x10,%esp
  800963:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800966:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800969:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80096c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80096f:	85 d2                	test   %edx,%edx
  800971:	79 23                	jns    800996 <vprintfmt+0x29b>
				putch('-', putdat);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	ff 75 0c             	pushl  0xc(%ebp)
  800979:	6a 2d                	push   $0x2d
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	ff d0                	call   *%eax
  800980:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800986:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800989:	f7 d8                	neg    %eax
  80098b:	83 d2 00             	adc    $0x0,%edx
  80098e:	f7 da                	neg    %edx
  800990:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800993:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800996:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80099d:	e9 bc 00 00 00       	jmp    800a5e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a2:	83 ec 08             	sub    $0x8,%esp
  8009a5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ab:	50                   	push   %eax
  8009ac:	e8 84 fc ff ff       	call   800635 <getuint>
  8009b1:	83 c4 10             	add    $0x10,%esp
  8009b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c1:	e9 98 00 00 00       	jmp    800a5e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009c6:	83 ec 08             	sub    $0x8,%esp
  8009c9:	ff 75 0c             	pushl  0xc(%ebp)
  8009cc:	6a 58                	push   $0x58
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	ff d0                	call   *%eax
  8009d3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	6a 58                	push   $0x58
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ec:	6a 58                	push   $0x58
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	ff d0                	call   *%eax
  8009f3:	83 c4 10             	add    $0x10,%esp
			break;
  8009f6:	e9 bc 00 00 00       	jmp    800ab7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 30                	push   $0x30
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	6a 78                	push   $0x78
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1e:	83 c0 04             	add    $0x4,%eax
  800a21:	89 45 14             	mov    %eax,0x14(%ebp)
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	83 e8 04             	sub    $0x4,%eax
  800a2a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a36:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a3d:	eb 1f                	jmp    800a5e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	ff 75 e8             	pushl  -0x18(%ebp)
  800a45:	8d 45 14             	lea    0x14(%ebp),%eax
  800a48:	50                   	push   %eax
  800a49:	e8 e7 fb ff ff       	call   800635 <getuint>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a54:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a57:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a5e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a65:	83 ec 04             	sub    $0x4,%esp
  800a68:	52                   	push   %edx
  800a69:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a6c:	50                   	push   %eax
  800a6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a70:	ff 75 f0             	pushl  -0x10(%ebp)
  800a73:	ff 75 0c             	pushl  0xc(%ebp)
  800a76:	ff 75 08             	pushl  0x8(%ebp)
  800a79:	e8 00 fb ff ff       	call   80057e <printnum>
  800a7e:	83 c4 20             	add    $0x20,%esp
			break;
  800a81:	eb 34                	jmp    800ab7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	53                   	push   %ebx
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			break;
  800a92:	eb 23                	jmp    800ab7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	6a 25                	push   $0x25
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa4:	ff 4d 10             	decl   0x10(%ebp)
  800aa7:	eb 03                	jmp    800aac <vprintfmt+0x3b1>
  800aa9:	ff 4d 10             	decl   0x10(%ebp)
  800aac:	8b 45 10             	mov    0x10(%ebp),%eax
  800aaf:	48                   	dec    %eax
  800ab0:	8a 00                	mov    (%eax),%al
  800ab2:	3c 25                	cmp    $0x25,%al
  800ab4:	75 f3                	jne    800aa9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ab6:	90                   	nop
		}
	}
  800ab7:	e9 47 fc ff ff       	jmp    800703 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800abc:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800abd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac0:	5b                   	pop    %ebx
  800ac1:	5e                   	pop    %esi
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aca:	8d 45 10             	lea    0x10(%ebp),%eax
  800acd:	83 c0 04             	add    $0x4,%eax
  800ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad9:	50                   	push   %eax
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	ff 75 08             	pushl  0x8(%ebp)
  800ae0:	e8 16 fc ff ff       	call   8006fb <vprintfmt>
  800ae5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ae8:	90                   	nop
  800ae9:	c9                   	leave  
  800aea:	c3                   	ret    

00800aeb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	8b 40 08             	mov    0x8(%eax),%eax
  800af4:	8d 50 01             	lea    0x1(%eax),%edx
  800af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afa:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b00:	8b 10                	mov    (%eax),%edx
  800b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b05:	8b 40 04             	mov    0x4(%eax),%eax
  800b08:	39 c2                	cmp    %eax,%edx
  800b0a:	73 12                	jae    800b1e <sprintputch+0x33>
		*b->buf++ = ch;
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	8d 48 01             	lea    0x1(%eax),%ecx
  800b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b17:	89 0a                	mov    %ecx,(%edx)
  800b19:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1c:	88 10                	mov    %dl,(%eax)
}
  800b1e:	90                   	nop
  800b1f:	5d                   	pop    %ebp
  800b20:	c3                   	ret    

00800b21 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b30:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	01 d0                	add    %edx,%eax
  800b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b46:	74 06                	je     800b4e <vsnprintf+0x2d>
  800b48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4c:	7f 07                	jg     800b55 <vsnprintf+0x34>
		return -E_INVAL;
  800b4e:	b8 03 00 00 00       	mov    $0x3,%eax
  800b53:	eb 20                	jmp    800b75 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b55:	ff 75 14             	pushl  0x14(%ebp)
  800b58:	ff 75 10             	pushl  0x10(%ebp)
  800b5b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b5e:	50                   	push   %eax
  800b5f:	68 eb 0a 80 00       	push   $0x800aeb
  800b64:	e8 92 fb ff ff       	call   8006fb <vprintfmt>
  800b69:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b6f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b75:	c9                   	leave  
  800b76:	c3                   	ret    

00800b77 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b7d:	8d 45 10             	lea    0x10(%ebp),%eax
  800b80:	83 c0 04             	add    $0x4,%eax
  800b83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b86:	8b 45 10             	mov    0x10(%ebp),%eax
  800b89:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8c:	50                   	push   %eax
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	ff 75 08             	pushl  0x8(%ebp)
  800b93:	e8 89 ff ff ff       	call   800b21 <vsnprintf>
  800b98:	83 c4 10             	add    $0x10,%esp
  800b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba1:	c9                   	leave  
  800ba2:	c3                   	ret    

00800ba3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb0:	eb 06                	jmp    800bb8 <strlen+0x15>
		n++;
  800bb2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb5:	ff 45 08             	incl   0x8(%ebp)
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	84 c0                	test   %al,%al
  800bbf:	75 f1                	jne    800bb2 <strlen+0xf>
		n++;
	return n;
  800bc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd3:	eb 09                	jmp    800bde <strnlen+0x18>
		n++;
  800bd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	ff 4d 0c             	decl   0xc(%ebp)
  800bde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be2:	74 09                	je     800bed <strnlen+0x27>
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8a 00                	mov    (%eax),%al
  800be9:	84 c0                	test   %al,%al
  800beb:	75 e8                	jne    800bd5 <strnlen+0xf>
		n++;
	return n;
  800bed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf0:	c9                   	leave  
  800bf1:	c3                   	ret    

00800bf2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bfe:	90                   	nop
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	8d 50 01             	lea    0x1(%eax),%edx
  800c05:	89 55 08             	mov    %edx,0x8(%ebp)
  800c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c11:	8a 12                	mov    (%edx),%dl
  800c13:	88 10                	mov    %dl,(%eax)
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	84 c0                	test   %al,%al
  800c19:	75 e4                	jne    800bff <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c33:	eb 1f                	jmp    800c54 <strncpy+0x34>
		*dst++ = *src;
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	8d 50 01             	lea    0x1(%eax),%edx
  800c3b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c41:	8a 12                	mov    (%edx),%dl
  800c43:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	84 c0                	test   %al,%al
  800c4c:	74 03                	je     800c51 <strncpy+0x31>
			src++;
  800c4e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c51:	ff 45 fc             	incl   -0x4(%ebp)
  800c54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c57:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c5a:	72 d9                	jb     800c35 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c5f:	c9                   	leave  
  800c60:	c3                   	ret    

00800c61 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c71:	74 30                	je     800ca3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c73:	eb 16                	jmp    800c8b <strlcpy+0x2a>
			*dst++ = *src++;
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8d 50 01             	lea    0x1(%eax),%edx
  800c7b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c81:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c84:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c87:	8a 12                	mov    (%edx),%dl
  800c89:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c8b:	ff 4d 10             	decl   0x10(%ebp)
  800c8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c92:	74 09                	je     800c9d <strlcpy+0x3c>
  800c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c97:	8a 00                	mov    (%eax),%al
  800c99:	84 c0                	test   %al,%al
  800c9b:	75 d8                	jne    800c75 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca9:	29 c2                	sub    %eax,%edx
  800cab:	89 d0                	mov    %edx,%eax
}
  800cad:	c9                   	leave  
  800cae:	c3                   	ret    

00800caf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb2:	eb 06                	jmp    800cba <strcmp+0xb>
		p++, q++;
  800cb4:	ff 45 08             	incl   0x8(%ebp)
  800cb7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	84 c0                	test   %al,%al
  800cc1:	74 0e                	je     800cd1 <strcmp+0x22>
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8a 10                	mov    (%eax),%dl
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	38 c2                	cmp    %al,%dl
  800ccf:	74 e3                	je     800cb4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	0f b6 d0             	movzbl %al,%edx
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	0f b6 c0             	movzbl %al,%eax
  800ce1:	29 c2                	sub    %eax,%edx
  800ce3:	89 d0                	mov    %edx,%eax
}
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cea:	eb 09                	jmp    800cf5 <strncmp+0xe>
		n--, p++, q++;
  800cec:	ff 4d 10             	decl   0x10(%ebp)
  800cef:	ff 45 08             	incl   0x8(%ebp)
  800cf2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf9:	74 17                	je     800d12 <strncmp+0x2b>
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	84 c0                	test   %al,%al
  800d02:	74 0e                	je     800d12 <strncmp+0x2b>
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8a 10                	mov    (%eax),%dl
  800d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	38 c2                	cmp    %al,%dl
  800d10:	74 da                	je     800cec <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d16:	75 07                	jne    800d1f <strncmp+0x38>
		return 0;
  800d18:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1d:	eb 14                	jmp    800d33 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	0f b6 d0             	movzbl %al,%edx
  800d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2a:	8a 00                	mov    (%eax),%al
  800d2c:	0f b6 c0             	movzbl %al,%eax
  800d2f:	29 c2                	sub    %eax,%edx
  800d31:	89 d0                	mov    %edx,%eax
}
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	83 ec 04             	sub    $0x4,%esp
  800d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d41:	eb 12                	jmp    800d55 <strchr+0x20>
		if (*s == c)
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4b:	75 05                	jne    800d52 <strchr+0x1d>
			return (char *) s;
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	eb 11                	jmp    800d63 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d52:	ff 45 08             	incl   0x8(%ebp)
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	84 c0                	test   %al,%al
  800d5c:	75 e5                	jne    800d43 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d63:	c9                   	leave  
  800d64:	c3                   	ret    

00800d65 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 04             	sub    $0x4,%esp
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d71:	eb 0d                	jmp    800d80 <strfind+0x1b>
		if (*s == c)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7b:	74 0e                	je     800d8b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d7d:	ff 45 08             	incl   0x8(%ebp)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	84 c0                	test   %al,%al
  800d87:	75 ea                	jne    800d73 <strfind+0xe>
  800d89:	eb 01                	jmp    800d8c <strfind+0x27>
		if (*s == c)
			break;
  800d8b:	90                   	nop
	return (char *) s;
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800da0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da3:	eb 0e                	jmp    800db3 <memset+0x22>
		*p++ = c;
  800da5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da8:	8d 50 01             	lea    0x1(%eax),%edx
  800dab:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db3:	ff 4d f8             	decl   -0x8(%ebp)
  800db6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dba:	79 e9                	jns    800da5 <memset+0x14>
		*p++ = c;

	return v;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dbf:	c9                   	leave  
  800dc0:	c3                   	ret    

00800dc1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd3:	eb 16                	jmp    800deb <memcpy+0x2a>
		*d++ = *s++;
  800dd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd8:	8d 50 01             	lea    0x1(%eax),%edx
  800ddb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dde:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800de7:	8a 12                	mov    (%edx),%dl
  800de9:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800deb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df1:	89 55 10             	mov    %edx,0x10(%ebp)
  800df4:	85 c0                	test   %eax,%eax
  800df6:	75 dd                	jne    800dd5 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfb:	c9                   	leave  
  800dfc:	c3                   	ret    

00800dfd <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e12:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e15:	73 50                	jae    800e67 <memmove+0x6a>
  800e17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1d:	01 d0                	add    %edx,%eax
  800e1f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e22:	76 43                	jbe    800e67 <memmove+0x6a>
		s += n;
  800e24:	8b 45 10             	mov    0x10(%ebp),%eax
  800e27:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e30:	eb 10                	jmp    800e42 <memmove+0x45>
			*--d = *--s;
  800e32:	ff 4d f8             	decl   -0x8(%ebp)
  800e35:	ff 4d fc             	decl   -0x4(%ebp)
  800e38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3b:	8a 10                	mov    (%eax),%dl
  800e3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e40:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e42:	8b 45 10             	mov    0x10(%ebp),%eax
  800e45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e48:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4b:	85 c0                	test   %eax,%eax
  800e4d:	75 e3                	jne    800e32 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e4f:	eb 23                	jmp    800e74 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e60:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e63:	8a 12                	mov    (%edx),%dl
  800e65:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e67:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	75 dd                	jne    800e51 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e88:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8b:	eb 2a                	jmp    800eb7 <memcmp+0x3e>
		if (*s1 != *s2)
  800e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e90:	8a 10                	mov    (%eax),%dl
  800e92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	38 c2                	cmp    %al,%dl
  800e99:	74 16                	je     800eb1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9e:	8a 00                	mov    (%eax),%al
  800ea0:	0f b6 d0             	movzbl %al,%edx
  800ea3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	0f b6 c0             	movzbl %al,%eax
  800eab:	29 c2                	sub    %eax,%edx
  800ead:	89 d0                	mov    %edx,%eax
  800eaf:	eb 18                	jmp    800ec9 <memcmp+0x50>
		s1++, s2++;
  800eb1:	ff 45 fc             	incl   -0x4(%ebp)
  800eb4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	75 c9                	jne    800e8d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed7:	01 d0                	add    %edx,%eax
  800ed9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800edc:	eb 15                	jmp    800ef3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	0f b6 d0             	movzbl %al,%edx
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	0f b6 c0             	movzbl %al,%eax
  800eec:	39 c2                	cmp    %eax,%edx
  800eee:	74 0d                	je     800efd <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef0:	ff 45 08             	incl   0x8(%ebp)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ef9:	72 e3                	jb     800ede <memfind+0x13>
  800efb:	eb 01                	jmp    800efe <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800efd:	90                   	nop
	return (void *) s;
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f01:	c9                   	leave  
  800f02:	c3                   	ret    

00800f03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f10:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f17:	eb 03                	jmp    800f1c <strtol+0x19>
		s++;
  800f19:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 20                	cmp    $0x20,%al
  800f23:	74 f4                	je     800f19 <strtol+0x16>
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	3c 09                	cmp    $0x9,%al
  800f2c:	74 eb                	je     800f19 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 2b                	cmp    $0x2b,%al
  800f35:	75 05                	jne    800f3c <strtol+0x39>
		s++;
  800f37:	ff 45 08             	incl   0x8(%ebp)
  800f3a:	eb 13                	jmp    800f4f <strtol+0x4c>
	else if (*s == '-')
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	3c 2d                	cmp    $0x2d,%al
  800f43:	75 0a                	jne    800f4f <strtol+0x4c>
		s++, neg = 1;
  800f45:	ff 45 08             	incl   0x8(%ebp)
  800f48:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f53:	74 06                	je     800f5b <strtol+0x58>
  800f55:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f59:	75 20                	jne    800f7b <strtol+0x78>
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	3c 30                	cmp    $0x30,%al
  800f62:	75 17                	jne    800f7b <strtol+0x78>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	40                   	inc    %eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 78                	cmp    $0x78,%al
  800f6c:	75 0d                	jne    800f7b <strtol+0x78>
		s += 2, base = 16;
  800f6e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f72:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f79:	eb 28                	jmp    800fa3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	75 15                	jne    800f96 <strtol+0x93>
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	3c 30                	cmp    $0x30,%al
  800f88:	75 0c                	jne    800f96 <strtol+0x93>
		s++, base = 8;
  800f8a:	ff 45 08             	incl   0x8(%ebp)
  800f8d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f94:	eb 0d                	jmp    800fa3 <strtol+0xa0>
	else if (base == 0)
  800f96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9a:	75 07                	jne    800fa3 <strtol+0xa0>
		base = 10;
  800f9c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	3c 2f                	cmp    $0x2f,%al
  800faa:	7e 19                	jle    800fc5 <strtol+0xc2>
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3c 39                	cmp    $0x39,%al
  800fb3:	7f 10                	jg     800fc5 <strtol+0xc2>
			dig = *s - '0';
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	0f be c0             	movsbl %al,%eax
  800fbd:	83 e8 30             	sub    $0x30,%eax
  800fc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc3:	eb 42                	jmp    801007 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	3c 60                	cmp    $0x60,%al
  800fcc:	7e 19                	jle    800fe7 <strtol+0xe4>
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	3c 7a                	cmp    $0x7a,%al
  800fd5:	7f 10                	jg     800fe7 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	0f be c0             	movsbl %al,%eax
  800fdf:	83 e8 57             	sub    $0x57,%eax
  800fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe5:	eb 20                	jmp    801007 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3c 40                	cmp    $0x40,%al
  800fee:	7e 39                	jle    801029 <strtol+0x126>
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	3c 5a                	cmp    $0x5a,%al
  800ff7:	7f 30                	jg     801029 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	0f be c0             	movsbl %al,%eax
  801001:	83 e8 37             	sub    $0x37,%eax
  801004:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80100d:	7d 19                	jge    801028 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80100f:	ff 45 08             	incl   0x8(%ebp)
  801012:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801015:	0f af 45 10          	imul   0x10(%ebp),%eax
  801019:	89 c2                	mov    %eax,%edx
  80101b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101e:	01 d0                	add    %edx,%eax
  801020:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801023:	e9 7b ff ff ff       	jmp    800fa3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801028:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801029:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102d:	74 08                	je     801037 <strtol+0x134>
		*endptr = (char *) s;
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	8b 55 08             	mov    0x8(%ebp),%edx
  801035:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801037:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103b:	74 07                	je     801044 <strtol+0x141>
  80103d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801040:	f7 d8                	neg    %eax
  801042:	eb 03                	jmp    801047 <strtol+0x144>
  801044:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801047:	c9                   	leave  
  801048:	c3                   	ret    

00801049 <ltostr>:

void
ltostr(long value, char *str)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80104f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801056:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80105d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801061:	79 13                	jns    801076 <ltostr+0x2d>
	{
		neg = 1;
  801063:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80106a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801070:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801073:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80107e:	99                   	cltd   
  80107f:	f7 f9                	idiv   %ecx
  801081:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801084:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801087:	8d 50 01             	lea    0x1(%eax),%edx
  80108a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108d:	89 c2                	mov    %eax,%edx
  80108f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801092:	01 d0                	add    %edx,%eax
  801094:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801097:	83 c2 30             	add    $0x30,%edx
  80109a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80109c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a4:	f7 e9                	imul   %ecx
  8010a6:	c1 fa 02             	sar    $0x2,%edx
  8010a9:	89 c8                	mov    %ecx,%eax
  8010ab:	c1 f8 1f             	sar    $0x1f,%eax
  8010ae:	29 c2                	sub    %eax,%edx
  8010b0:	89 d0                	mov    %edx,%eax
  8010b2:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010bd:	f7 e9                	imul   %ecx
  8010bf:	c1 fa 02             	sar    $0x2,%edx
  8010c2:	89 c8                	mov    %ecx,%eax
  8010c4:	c1 f8 1f             	sar    $0x1f,%eax
  8010c7:	29 c2                	sub    %eax,%edx
  8010c9:	89 d0                	mov    %edx,%eax
  8010cb:	c1 e0 02             	shl    $0x2,%eax
  8010ce:	01 d0                	add    %edx,%eax
  8010d0:	01 c0                	add    %eax,%eax
  8010d2:	29 c1                	sub    %eax,%ecx
  8010d4:	89 ca                	mov    %ecx,%edx
  8010d6:	85 d2                	test   %edx,%edx
  8010d8:	75 9c                	jne    801076 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e4:	48                   	dec    %eax
  8010e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010ec:	74 3d                	je     80112b <ltostr+0xe2>
		start = 1 ;
  8010ee:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f5:	eb 34                	jmp    80112b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	01 d0                	add    %edx,%eax
  8010ff:	8a 00                	mov    (%eax),%al
  801101:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801104:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110a:	01 c2                	add    %eax,%edx
  80110c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	01 c8                	add    %ecx,%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801118:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111e:	01 c2                	add    %eax,%edx
  801120:	8a 45 eb             	mov    -0x15(%ebp),%al
  801123:	88 02                	mov    %al,(%edx)
		start++ ;
  801125:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801128:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801131:	7c c4                	jl     8010f7 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801133:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801136:	8b 45 0c             	mov    0xc(%ebp),%eax
  801139:	01 d0                	add    %edx,%eax
  80113b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80113e:	90                   	nop
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801147:	ff 75 08             	pushl  0x8(%ebp)
  80114a:	e8 54 fa ff ff       	call   800ba3 <strlen>
  80114f:	83 c4 04             	add    $0x4,%esp
  801152:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801155:	ff 75 0c             	pushl  0xc(%ebp)
  801158:	e8 46 fa ff ff       	call   800ba3 <strlen>
  80115d:	83 c4 04             	add    $0x4,%esp
  801160:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801163:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80116a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801171:	eb 17                	jmp    80118a <strcconcat+0x49>
		final[s] = str1[s] ;
  801173:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801176:	8b 45 10             	mov    0x10(%ebp),%eax
  801179:	01 c2                	add    %eax,%edx
  80117b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	01 c8                	add    %ecx,%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801187:	ff 45 fc             	incl   -0x4(%ebp)
  80118a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801190:	7c e1                	jl     801173 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801192:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801199:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a0:	eb 1f                	jmp    8011c1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a5:	8d 50 01             	lea    0x1(%eax),%edx
  8011a8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ab:	89 c2                	mov    %eax,%edx
  8011ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b0:	01 c2                	add    %eax,%edx
  8011b2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b8:	01 c8                	add    %ecx,%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011be:	ff 45 f8             	incl   -0x8(%ebp)
  8011c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c7:	7c d9                	jl     8011a2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d4:	90                   	nop
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011da:	8b 45 14             	mov    0x14(%ebp),%eax
  8011dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e6:	8b 00                	mov    (%eax),%eax
  8011e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fa:	eb 0c                	jmp    801208 <strsplit+0x31>
			*string++ = 0;
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	8d 50 01             	lea    0x1(%eax),%edx
  801202:	89 55 08             	mov    %edx,0x8(%ebp)
  801205:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	84 c0                	test   %al,%al
  80120f:	74 18                	je     801229 <strsplit+0x52>
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f be c0             	movsbl %al,%eax
  801219:	50                   	push   %eax
  80121a:	ff 75 0c             	pushl  0xc(%ebp)
  80121d:	e8 13 fb ff ff       	call   800d35 <strchr>
  801222:	83 c4 08             	add    $0x8,%esp
  801225:	85 c0                	test   %eax,%eax
  801227:	75 d3                	jne    8011fc <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	84 c0                	test   %al,%al
  801230:	74 5a                	je     80128c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801232:	8b 45 14             	mov    0x14(%ebp),%eax
  801235:	8b 00                	mov    (%eax),%eax
  801237:	83 f8 0f             	cmp    $0xf,%eax
  80123a:	75 07                	jne    801243 <strsplit+0x6c>
		{
			return 0;
  80123c:	b8 00 00 00 00       	mov    $0x0,%eax
  801241:	eb 66                	jmp    8012a9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801243:	8b 45 14             	mov    0x14(%ebp),%eax
  801246:	8b 00                	mov    (%eax),%eax
  801248:	8d 48 01             	lea    0x1(%eax),%ecx
  80124b:	8b 55 14             	mov    0x14(%ebp),%edx
  80124e:	89 0a                	mov    %ecx,(%edx)
  801250:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801257:	8b 45 10             	mov    0x10(%ebp),%eax
  80125a:	01 c2                	add    %eax,%edx
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801261:	eb 03                	jmp    801266 <strsplit+0x8f>
			string++;
  801263:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	8a 00                	mov    (%eax),%al
  80126b:	84 c0                	test   %al,%al
  80126d:	74 8b                	je     8011fa <strsplit+0x23>
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	0f be c0             	movsbl %al,%eax
  801277:	50                   	push   %eax
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	e8 b5 fa ff ff       	call   800d35 <strchr>
  801280:	83 c4 08             	add    $0x8,%esp
  801283:	85 c0                	test   %eax,%eax
  801285:	74 dc                	je     801263 <strsplit+0x8c>
			string++;
	}
  801287:	e9 6e ff ff ff       	jmp    8011fa <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80128c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80128d:	8b 45 14             	mov    0x14(%ebp),%eax
  801290:	8b 00                	mov    (%eax),%eax
  801292:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	01 d0                	add    %edx,%eax
  80129e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012a9:	c9                   	leave  
  8012aa:	c3                   	ret    

008012ab <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
  8012ae:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8012b1:	83 ec 04             	sub    $0x4,%esp
  8012b4:	68 70 23 80 00       	push   $0x802370
  8012b9:	6a 19                	push   $0x19
  8012bb:	68 95 23 80 00       	push   $0x802395
  8012c0:	e8 ba ef ff ff       	call   80027f <_panic>

008012c5 <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	83 ec 18             	sub    $0x18,%esp
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8012d1:	83 ec 04             	sub    $0x4,%esp
  8012d4:	68 a4 23 80 00       	push   $0x8023a4
  8012d9:	6a 31                	push   $0x31
  8012db:	68 95 23 80 00       	push   $0x802395
  8012e0:	e8 9a ef ff ff       	call   80027f <_panic>

008012e5 <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8012eb:	83 ec 04             	sub    $0x4,%esp
  8012ee:	68 cc 23 80 00       	push   $0x8023cc
  8012f3:	6a 4a                	push   $0x4a
  8012f5:	68 95 23 80 00       	push   $0x802395
  8012fa:	e8 80 ef ff ff       	call   80027f <_panic>

008012ff <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801305:	83 ec 04             	sub    $0x4,%esp
  801308:	68 f0 23 80 00       	push   $0x8023f0
  80130d:	6a 70                	push   $0x70
  80130f:	68 95 23 80 00       	push   $0x802395
  801314:	e8 66 ef ff ff       	call   80027f <_panic>

00801319 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80131f:	83 ec 04             	sub    $0x4,%esp
  801322:	68 14 24 80 00       	push   $0x802414
  801327:	68 8b 00 00 00       	push   $0x8b
  80132c:	68 95 23 80 00       	push   $0x802395
  801331:	e8 49 ef ff ff       	call   80027f <_panic>

00801336 <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
  801339:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80133c:	83 ec 04             	sub    $0x4,%esp
  80133f:	68 38 24 80 00       	push   $0x802438
  801344:	68 a8 00 00 00       	push   $0xa8
  801349:	68 95 23 80 00       	push   $0x802395
  80134e:	e8 2c ef ff ff       	call   80027f <_panic>

00801353 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	57                   	push   %edi
  801357:	56                   	push   %esi
  801358:	53                   	push   %ebx
  801359:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801362:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801365:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801368:	8b 7d 18             	mov    0x18(%ebp),%edi
  80136b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80136e:	cd 30                	int    $0x30
  801370:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801373:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801376:	83 c4 10             	add    $0x10,%esp
  801379:	5b                   	pop    %ebx
  80137a:	5e                   	pop    %esi
  80137b:	5f                   	pop    %edi
  80137c:	5d                   	pop    %ebp
  80137d:	c3                   	ret    

0080137e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	83 ec 04             	sub    $0x4,%esp
  801384:	8b 45 10             	mov    0x10(%ebp),%eax
  801387:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80138a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	52                   	push   %edx
  801396:	ff 75 0c             	pushl  0xc(%ebp)
  801399:	50                   	push   %eax
  80139a:	6a 00                	push   $0x0
  80139c:	e8 b2 ff ff ff       	call   801353 <syscall>
  8013a1:	83 c4 18             	add    $0x18,%esp
}
  8013a4:	90                   	nop
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 01                	push   $0x1
  8013b6:	e8 98 ff ff ff       	call   801353 <syscall>
  8013bb:	83 c4 18             	add    $0x18,%esp
}
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    

008013c0 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	50                   	push   %eax
  8013cf:	6a 05                	push   $0x5
  8013d1:	e8 7d ff ff ff       	call   801353 <syscall>
  8013d6:	83 c4 18             	add    $0x18,%esp
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 02                	push   $0x2
  8013ea:	e8 64 ff ff ff       	call   801353 <syscall>
  8013ef:	83 c4 18             	add    $0x18,%esp
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 03                	push   $0x3
  801403:	e8 4b ff ff ff       	call   801353 <syscall>
  801408:	83 c4 18             	add    $0x18,%esp
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 04                	push   $0x4
  80141c:	e8 32 ff ff ff       	call   801353 <syscall>
  801421:	83 c4 18             	add    $0x18,%esp
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <sys_env_exit>:


void sys_env_exit(void)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 06                	push   $0x6
  801435:	e8 19 ff ff ff       	call   801353 <syscall>
  80143a:	83 c4 18             	add    $0x18,%esp
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801443:	8b 55 0c             	mov    0xc(%ebp),%edx
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	52                   	push   %edx
  801450:	50                   	push   %eax
  801451:	6a 07                	push   $0x7
  801453:	e8 fb fe ff ff       	call   801353 <syscall>
  801458:	83 c4 18             	add    $0x18,%esp
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	56                   	push   %esi
  801461:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801462:	8b 75 18             	mov    0x18(%ebp),%esi
  801465:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801468:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80146b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	56                   	push   %esi
  801472:	53                   	push   %ebx
  801473:	51                   	push   %ecx
  801474:	52                   	push   %edx
  801475:	50                   	push   %eax
  801476:	6a 08                	push   $0x8
  801478:	e8 d6 fe ff ff       	call   801353 <syscall>
  80147d:	83 c4 18             	add    $0x18,%esp
}
  801480:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801483:	5b                   	pop    %ebx
  801484:	5e                   	pop    %esi
  801485:	5d                   	pop    %ebp
  801486:	c3                   	ret    

00801487 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80148a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	52                   	push   %edx
  801497:	50                   	push   %eax
  801498:	6a 09                	push   $0x9
  80149a:	e8 b4 fe ff ff       	call   801353 <syscall>
  80149f:	83 c4 18             	add    $0x18,%esp
}
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	ff 75 0c             	pushl  0xc(%ebp)
  8014b0:	ff 75 08             	pushl  0x8(%ebp)
  8014b3:	6a 0a                	push   $0xa
  8014b5:	e8 99 fe ff ff       	call   801353 <syscall>
  8014ba:	83 c4 18             	add    $0x18,%esp
}
  8014bd:	c9                   	leave  
  8014be:	c3                   	ret    

008014bf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 0b                	push   $0xb
  8014ce:	e8 80 fe ff ff       	call   801353 <syscall>
  8014d3:	83 c4 18             	add    $0x18,%esp
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 0c                	push   $0xc
  8014e7:	e8 67 fe ff ff       	call   801353 <syscall>
  8014ec:	83 c4 18             	add    $0x18,%esp
}
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 0d                	push   $0xd
  801500:	e8 4e fe ff ff       	call   801353 <syscall>
  801505:	83 c4 18             	add    $0x18,%esp
}
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	ff 75 0c             	pushl  0xc(%ebp)
  801516:	ff 75 08             	pushl  0x8(%ebp)
  801519:	6a 11                	push   $0x11
  80151b:	e8 33 fe ff ff       	call   801353 <syscall>
  801520:	83 c4 18             	add    $0x18,%esp
	return;
  801523:	90                   	nop
}
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	ff 75 0c             	pushl  0xc(%ebp)
  801532:	ff 75 08             	pushl  0x8(%ebp)
  801535:	6a 12                	push   $0x12
  801537:	e8 17 fe ff ff       	call   801353 <syscall>
  80153c:	83 c4 18             	add    $0x18,%esp
	return ;
  80153f:	90                   	nop
}
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 0e                	push   $0xe
  801551:	e8 fd fd ff ff       	call   801353 <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	ff 75 08             	pushl  0x8(%ebp)
  801569:	6a 0f                	push   $0xf
  80156b:	e8 e3 fd ff ff       	call   801353 <syscall>
  801570:	83 c4 18             	add    $0x18,%esp
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 10                	push   $0x10
  801584:	e8 ca fd ff ff       	call   801353 <syscall>
  801589:	83 c4 18             	add    $0x18,%esp
}
  80158c:	90                   	nop
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 14                	push   $0x14
  80159e:	e8 b0 fd ff ff       	call   801353 <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
}
  8015a6:	90                   	nop
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 15                	push   $0x15
  8015b8:	e8 96 fd ff ff       	call   801353 <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
}
  8015c0:	90                   	nop
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_cputc>:


void
sys_cputc(const char c)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	83 ec 04             	sub    $0x4,%esp
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015cf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	50                   	push   %eax
  8015dc:	6a 16                	push   $0x16
  8015de:	e8 70 fd ff ff       	call   801353 <syscall>
  8015e3:	83 c4 18             	add    $0x18,%esp
}
  8015e6:	90                   	nop
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 17                	push   $0x17
  8015f8:	e8 56 fd ff ff       	call   801353 <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	90                   	nop
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	50                   	push   %eax
  801613:	6a 18                	push   $0x18
  801615:	e8 39 fd ff ff       	call   801353 <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801622:	8b 55 0c             	mov    0xc(%ebp),%edx
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	52                   	push   %edx
  80162f:	50                   	push   %eax
  801630:	6a 1b                	push   $0x1b
  801632:	e8 1c fd ff ff       	call   801353 <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	52                   	push   %edx
  80164c:	50                   	push   %eax
  80164d:	6a 19                	push   $0x19
  80164f:	e8 ff fc ff ff       	call   801353 <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	90                   	nop
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80165d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	52                   	push   %edx
  80166a:	50                   	push   %eax
  80166b:	6a 1a                	push   $0x1a
  80166d:	e8 e1 fc ff ff       	call   801353 <syscall>
  801672:	83 c4 18             	add    $0x18,%esp
}
  801675:	90                   	nop
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	83 ec 04             	sub    $0x4,%esp
  80167e:	8b 45 10             	mov    0x10(%ebp),%eax
  801681:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801684:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801687:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	6a 00                	push   $0x0
  801690:	51                   	push   %ecx
  801691:	52                   	push   %edx
  801692:	ff 75 0c             	pushl  0xc(%ebp)
  801695:	50                   	push   %eax
  801696:	6a 1c                	push   $0x1c
  801698:	e8 b6 fc ff ff       	call   801353 <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	52                   	push   %edx
  8016b2:	50                   	push   %eax
  8016b3:	6a 1d                	push   $0x1d
  8016b5:	e8 99 fc ff ff       	call   801353 <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	51                   	push   %ecx
  8016d0:	52                   	push   %edx
  8016d1:	50                   	push   %eax
  8016d2:	6a 1e                	push   $0x1e
  8016d4:	e8 7a fc ff ff       	call   801353 <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	52                   	push   %edx
  8016ee:	50                   	push   %eax
  8016ef:	6a 1f                	push   $0x1f
  8016f1:	e8 5d fc ff ff       	call   801353 <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 20                	push   $0x20
  80170a:	e8 44 fc ff ff       	call   801353 <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	ff 75 10             	pushl  0x10(%ebp)
  801721:	ff 75 0c             	pushl  0xc(%ebp)
  801724:	50                   	push   %eax
  801725:	6a 21                	push   $0x21
  801727:	e8 27 fc ff ff       	call   801353 <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	50                   	push   %eax
  801740:	6a 22                	push   $0x22
  801742:	e8 0c fc ff ff       	call   801353 <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
}
  80174a:	90                   	nop
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	50                   	push   %eax
  80175c:	6a 23                	push   $0x23
  80175e:	e8 f0 fb ff ff       	call   801353 <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
}
  801766:	90                   	nop
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80176f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801772:	8d 50 04             	lea    0x4(%eax),%edx
  801775:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	52                   	push   %edx
  80177f:	50                   	push   %eax
  801780:	6a 24                	push   $0x24
  801782:	e8 cc fb ff ff       	call   801353 <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
	return result;
  80178a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80178d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801790:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801793:	89 01                	mov    %eax,(%ecx)
  801795:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
  80179b:	c9                   	leave  
  80179c:	c2 04 00             	ret    $0x4

0080179f <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	ff 75 10             	pushl  0x10(%ebp)
  8017a9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ac:	ff 75 08             	pushl  0x8(%ebp)
  8017af:	6a 13                	push   $0x13
  8017b1:	e8 9d fb ff ff       	call   801353 <syscall>
  8017b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b9:	90                   	nop
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_rcr2>:
uint32 sys_rcr2()
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 25                	push   $0x25
  8017cb:	e8 83 fb ff ff       	call   801353 <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	83 ec 04             	sub    $0x4,%esp
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017e1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	50                   	push   %eax
  8017ee:	6a 26                	push   $0x26
  8017f0:	e8 5e fb ff ff       	call   801353 <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f8:	90                   	nop
}
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <rsttst>:
void rsttst()
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 28                	push   $0x28
  80180a:	e8 44 fb ff ff       	call   801353 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
	return ;
  801812:	90                   	nop
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 04             	sub    $0x4,%esp
  80181b:	8b 45 14             	mov    0x14(%ebp),%eax
  80181e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801821:	8b 55 18             	mov    0x18(%ebp),%edx
  801824:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801828:	52                   	push   %edx
  801829:	50                   	push   %eax
  80182a:	ff 75 10             	pushl  0x10(%ebp)
  80182d:	ff 75 0c             	pushl  0xc(%ebp)
  801830:	ff 75 08             	pushl  0x8(%ebp)
  801833:	6a 27                	push   $0x27
  801835:	e8 19 fb ff ff       	call   801353 <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
	return ;
  80183d:	90                   	nop
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <chktst>:
void chktst(uint32 n)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	ff 75 08             	pushl  0x8(%ebp)
  80184e:	6a 29                	push   $0x29
  801850:	e8 fe fa ff ff       	call   801353 <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
	return ;
  801858:	90                   	nop
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <inctst>:

void inctst()
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 2a                	push   $0x2a
  80186a:	e8 e4 fa ff ff       	call   801353 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
	return ;
  801872:	90                   	nop
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <gettst>:
uint32 gettst()
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 2b                	push   $0x2b
  801884:	e8 ca fa ff ff       	call   801353 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 2c                	push   $0x2c
  8018a0:	e8 ae fa ff ff       	call   801353 <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
  8018a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018ab:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018af:	75 07                	jne    8018b8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8018b6:	eb 05                	jmp    8018bd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 2c                	push   $0x2c
  8018d1:	e8 7d fa ff ff       	call   801353 <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
  8018d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8018dc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8018e0:	75 07                	jne    8018e9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8018e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018e7:	eb 05                	jmp    8018ee <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8018e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 2c                	push   $0x2c
  801902:	e8 4c fa ff ff       	call   801353 <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
  80190a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80190d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801911:	75 07                	jne    80191a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801913:	b8 01 00 00 00       	mov    $0x1,%eax
  801918:	eb 05                	jmp    80191f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80191a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 2c                	push   $0x2c
  801933:	e8 1b fa ff ff       	call   801353 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
  80193b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80193e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801942:	75 07                	jne    80194b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801944:	b8 01 00 00 00       	mov    $0x1,%eax
  801949:	eb 05                	jmp    801950 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80194b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	ff 75 08             	pushl  0x8(%ebp)
  801960:	6a 2d                	push   $0x2d
  801962:	e8 ec f9 ff ff       	call   801353 <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
	return ;
  80196a:	90                   	nop
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801971:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801974:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801977:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	6a 00                	push   $0x0
  80197f:	53                   	push   %ebx
  801980:	51                   	push   %ecx
  801981:	52                   	push   %edx
  801982:	50                   	push   %eax
  801983:	6a 2e                	push   $0x2e
  801985:	e8 c9 f9 ff ff       	call   801353 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801995:	8b 55 0c             	mov    0xc(%ebp),%edx
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	52                   	push   %edx
  8019a2:	50                   	push   %eax
  8019a3:	6a 2f                	push   $0x2f
  8019a5:	e8 a9 f9 ff ff       	call   801353 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    
  8019af:	90                   	nop

008019b0 <__udivdi3>:
  8019b0:	55                   	push   %ebp
  8019b1:	57                   	push   %edi
  8019b2:	56                   	push   %esi
  8019b3:	53                   	push   %ebx
  8019b4:	83 ec 1c             	sub    $0x1c,%esp
  8019b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019c7:	89 ca                	mov    %ecx,%edx
  8019c9:	89 f8                	mov    %edi,%eax
  8019cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019cf:	85 f6                	test   %esi,%esi
  8019d1:	75 2d                	jne    801a00 <__udivdi3+0x50>
  8019d3:	39 cf                	cmp    %ecx,%edi
  8019d5:	77 65                	ja     801a3c <__udivdi3+0x8c>
  8019d7:	89 fd                	mov    %edi,%ebp
  8019d9:	85 ff                	test   %edi,%edi
  8019db:	75 0b                	jne    8019e8 <__udivdi3+0x38>
  8019dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e2:	31 d2                	xor    %edx,%edx
  8019e4:	f7 f7                	div    %edi
  8019e6:	89 c5                	mov    %eax,%ebp
  8019e8:	31 d2                	xor    %edx,%edx
  8019ea:	89 c8                	mov    %ecx,%eax
  8019ec:	f7 f5                	div    %ebp
  8019ee:	89 c1                	mov    %eax,%ecx
  8019f0:	89 d8                	mov    %ebx,%eax
  8019f2:	f7 f5                	div    %ebp
  8019f4:	89 cf                	mov    %ecx,%edi
  8019f6:	89 fa                	mov    %edi,%edx
  8019f8:	83 c4 1c             	add    $0x1c,%esp
  8019fb:	5b                   	pop    %ebx
  8019fc:	5e                   	pop    %esi
  8019fd:	5f                   	pop    %edi
  8019fe:	5d                   	pop    %ebp
  8019ff:	c3                   	ret    
  801a00:	39 ce                	cmp    %ecx,%esi
  801a02:	77 28                	ja     801a2c <__udivdi3+0x7c>
  801a04:	0f bd fe             	bsr    %esi,%edi
  801a07:	83 f7 1f             	xor    $0x1f,%edi
  801a0a:	75 40                	jne    801a4c <__udivdi3+0x9c>
  801a0c:	39 ce                	cmp    %ecx,%esi
  801a0e:	72 0a                	jb     801a1a <__udivdi3+0x6a>
  801a10:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a14:	0f 87 9e 00 00 00    	ja     801ab8 <__udivdi3+0x108>
  801a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1f:	89 fa                	mov    %edi,%edx
  801a21:	83 c4 1c             	add    $0x1c,%esp
  801a24:	5b                   	pop    %ebx
  801a25:	5e                   	pop    %esi
  801a26:	5f                   	pop    %edi
  801a27:	5d                   	pop    %ebp
  801a28:	c3                   	ret    
  801a29:	8d 76 00             	lea    0x0(%esi),%esi
  801a2c:	31 ff                	xor    %edi,%edi
  801a2e:	31 c0                	xor    %eax,%eax
  801a30:	89 fa                	mov    %edi,%edx
  801a32:	83 c4 1c             	add    $0x1c,%esp
  801a35:	5b                   	pop    %ebx
  801a36:	5e                   	pop    %esi
  801a37:	5f                   	pop    %edi
  801a38:	5d                   	pop    %ebp
  801a39:	c3                   	ret    
  801a3a:	66 90                	xchg   %ax,%ax
  801a3c:	89 d8                	mov    %ebx,%eax
  801a3e:	f7 f7                	div    %edi
  801a40:	31 ff                	xor    %edi,%edi
  801a42:	89 fa                	mov    %edi,%edx
  801a44:	83 c4 1c             	add    $0x1c,%esp
  801a47:	5b                   	pop    %ebx
  801a48:	5e                   	pop    %esi
  801a49:	5f                   	pop    %edi
  801a4a:	5d                   	pop    %ebp
  801a4b:	c3                   	ret    
  801a4c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a51:	89 eb                	mov    %ebp,%ebx
  801a53:	29 fb                	sub    %edi,%ebx
  801a55:	89 f9                	mov    %edi,%ecx
  801a57:	d3 e6                	shl    %cl,%esi
  801a59:	89 c5                	mov    %eax,%ebp
  801a5b:	88 d9                	mov    %bl,%cl
  801a5d:	d3 ed                	shr    %cl,%ebp
  801a5f:	89 e9                	mov    %ebp,%ecx
  801a61:	09 f1                	or     %esi,%ecx
  801a63:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a67:	89 f9                	mov    %edi,%ecx
  801a69:	d3 e0                	shl    %cl,%eax
  801a6b:	89 c5                	mov    %eax,%ebp
  801a6d:	89 d6                	mov    %edx,%esi
  801a6f:	88 d9                	mov    %bl,%cl
  801a71:	d3 ee                	shr    %cl,%esi
  801a73:	89 f9                	mov    %edi,%ecx
  801a75:	d3 e2                	shl    %cl,%edx
  801a77:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a7b:	88 d9                	mov    %bl,%cl
  801a7d:	d3 e8                	shr    %cl,%eax
  801a7f:	09 c2                	or     %eax,%edx
  801a81:	89 d0                	mov    %edx,%eax
  801a83:	89 f2                	mov    %esi,%edx
  801a85:	f7 74 24 0c          	divl   0xc(%esp)
  801a89:	89 d6                	mov    %edx,%esi
  801a8b:	89 c3                	mov    %eax,%ebx
  801a8d:	f7 e5                	mul    %ebp
  801a8f:	39 d6                	cmp    %edx,%esi
  801a91:	72 19                	jb     801aac <__udivdi3+0xfc>
  801a93:	74 0b                	je     801aa0 <__udivdi3+0xf0>
  801a95:	89 d8                	mov    %ebx,%eax
  801a97:	31 ff                	xor    %edi,%edi
  801a99:	e9 58 ff ff ff       	jmp    8019f6 <__udivdi3+0x46>
  801a9e:	66 90                	xchg   %ax,%ax
  801aa0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801aa4:	89 f9                	mov    %edi,%ecx
  801aa6:	d3 e2                	shl    %cl,%edx
  801aa8:	39 c2                	cmp    %eax,%edx
  801aaa:	73 e9                	jae    801a95 <__udivdi3+0xe5>
  801aac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801aaf:	31 ff                	xor    %edi,%edi
  801ab1:	e9 40 ff ff ff       	jmp    8019f6 <__udivdi3+0x46>
  801ab6:	66 90                	xchg   %ax,%ax
  801ab8:	31 c0                	xor    %eax,%eax
  801aba:	e9 37 ff ff ff       	jmp    8019f6 <__udivdi3+0x46>
  801abf:	90                   	nop

00801ac0 <__umoddi3>:
  801ac0:	55                   	push   %ebp
  801ac1:	57                   	push   %edi
  801ac2:	56                   	push   %esi
  801ac3:	53                   	push   %ebx
  801ac4:	83 ec 1c             	sub    $0x1c,%esp
  801ac7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801acb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801acf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ad3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ad7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801adb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801adf:	89 f3                	mov    %esi,%ebx
  801ae1:	89 fa                	mov    %edi,%edx
  801ae3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ae7:	89 34 24             	mov    %esi,(%esp)
  801aea:	85 c0                	test   %eax,%eax
  801aec:	75 1a                	jne    801b08 <__umoddi3+0x48>
  801aee:	39 f7                	cmp    %esi,%edi
  801af0:	0f 86 a2 00 00 00    	jbe    801b98 <__umoddi3+0xd8>
  801af6:	89 c8                	mov    %ecx,%eax
  801af8:	89 f2                	mov    %esi,%edx
  801afa:	f7 f7                	div    %edi
  801afc:	89 d0                	mov    %edx,%eax
  801afe:	31 d2                	xor    %edx,%edx
  801b00:	83 c4 1c             	add    $0x1c,%esp
  801b03:	5b                   	pop    %ebx
  801b04:	5e                   	pop    %esi
  801b05:	5f                   	pop    %edi
  801b06:	5d                   	pop    %ebp
  801b07:	c3                   	ret    
  801b08:	39 f0                	cmp    %esi,%eax
  801b0a:	0f 87 ac 00 00 00    	ja     801bbc <__umoddi3+0xfc>
  801b10:	0f bd e8             	bsr    %eax,%ebp
  801b13:	83 f5 1f             	xor    $0x1f,%ebp
  801b16:	0f 84 ac 00 00 00    	je     801bc8 <__umoddi3+0x108>
  801b1c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b21:	29 ef                	sub    %ebp,%edi
  801b23:	89 fe                	mov    %edi,%esi
  801b25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b29:	89 e9                	mov    %ebp,%ecx
  801b2b:	d3 e0                	shl    %cl,%eax
  801b2d:	89 d7                	mov    %edx,%edi
  801b2f:	89 f1                	mov    %esi,%ecx
  801b31:	d3 ef                	shr    %cl,%edi
  801b33:	09 c7                	or     %eax,%edi
  801b35:	89 e9                	mov    %ebp,%ecx
  801b37:	d3 e2                	shl    %cl,%edx
  801b39:	89 14 24             	mov    %edx,(%esp)
  801b3c:	89 d8                	mov    %ebx,%eax
  801b3e:	d3 e0                	shl    %cl,%eax
  801b40:	89 c2                	mov    %eax,%edx
  801b42:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b46:	d3 e0                	shl    %cl,%eax
  801b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b50:	89 f1                	mov    %esi,%ecx
  801b52:	d3 e8                	shr    %cl,%eax
  801b54:	09 d0                	or     %edx,%eax
  801b56:	d3 eb                	shr    %cl,%ebx
  801b58:	89 da                	mov    %ebx,%edx
  801b5a:	f7 f7                	div    %edi
  801b5c:	89 d3                	mov    %edx,%ebx
  801b5e:	f7 24 24             	mull   (%esp)
  801b61:	89 c6                	mov    %eax,%esi
  801b63:	89 d1                	mov    %edx,%ecx
  801b65:	39 d3                	cmp    %edx,%ebx
  801b67:	0f 82 87 00 00 00    	jb     801bf4 <__umoddi3+0x134>
  801b6d:	0f 84 91 00 00 00    	je     801c04 <__umoddi3+0x144>
  801b73:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b77:	29 f2                	sub    %esi,%edx
  801b79:	19 cb                	sbb    %ecx,%ebx
  801b7b:	89 d8                	mov    %ebx,%eax
  801b7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b81:	d3 e0                	shl    %cl,%eax
  801b83:	89 e9                	mov    %ebp,%ecx
  801b85:	d3 ea                	shr    %cl,%edx
  801b87:	09 d0                	or     %edx,%eax
  801b89:	89 e9                	mov    %ebp,%ecx
  801b8b:	d3 eb                	shr    %cl,%ebx
  801b8d:	89 da                	mov    %ebx,%edx
  801b8f:	83 c4 1c             	add    $0x1c,%esp
  801b92:	5b                   	pop    %ebx
  801b93:	5e                   	pop    %esi
  801b94:	5f                   	pop    %edi
  801b95:	5d                   	pop    %ebp
  801b96:	c3                   	ret    
  801b97:	90                   	nop
  801b98:	89 fd                	mov    %edi,%ebp
  801b9a:	85 ff                	test   %edi,%edi
  801b9c:	75 0b                	jne    801ba9 <__umoddi3+0xe9>
  801b9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba3:	31 d2                	xor    %edx,%edx
  801ba5:	f7 f7                	div    %edi
  801ba7:	89 c5                	mov    %eax,%ebp
  801ba9:	89 f0                	mov    %esi,%eax
  801bab:	31 d2                	xor    %edx,%edx
  801bad:	f7 f5                	div    %ebp
  801baf:	89 c8                	mov    %ecx,%eax
  801bb1:	f7 f5                	div    %ebp
  801bb3:	89 d0                	mov    %edx,%eax
  801bb5:	e9 44 ff ff ff       	jmp    801afe <__umoddi3+0x3e>
  801bba:	66 90                	xchg   %ax,%ax
  801bbc:	89 c8                	mov    %ecx,%eax
  801bbe:	89 f2                	mov    %esi,%edx
  801bc0:	83 c4 1c             	add    $0x1c,%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5e                   	pop    %esi
  801bc5:	5f                   	pop    %edi
  801bc6:	5d                   	pop    %ebp
  801bc7:	c3                   	ret    
  801bc8:	3b 04 24             	cmp    (%esp),%eax
  801bcb:	72 06                	jb     801bd3 <__umoddi3+0x113>
  801bcd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bd1:	77 0f                	ja     801be2 <__umoddi3+0x122>
  801bd3:	89 f2                	mov    %esi,%edx
  801bd5:	29 f9                	sub    %edi,%ecx
  801bd7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bdb:	89 14 24             	mov    %edx,(%esp)
  801bde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801be2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801be6:	8b 14 24             	mov    (%esp),%edx
  801be9:	83 c4 1c             	add    $0x1c,%esp
  801bec:	5b                   	pop    %ebx
  801bed:	5e                   	pop    %esi
  801bee:	5f                   	pop    %edi
  801bef:	5d                   	pop    %ebp
  801bf0:	c3                   	ret    
  801bf1:	8d 76 00             	lea    0x0(%esi),%esi
  801bf4:	2b 04 24             	sub    (%esp),%eax
  801bf7:	19 fa                	sbb    %edi,%edx
  801bf9:	89 d1                	mov    %edx,%ecx
  801bfb:	89 c6                	mov    %eax,%esi
  801bfd:	e9 71 ff ff ff       	jmp    801b73 <__umoddi3+0xb3>
  801c02:	66 90                	xchg   %ax,%ax
  801c04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c08:	72 ea                	jb     801bf4 <__umoddi3+0x134>
  801c0a:	89 d9                	mov    %ebx,%ecx
  801c0c:	e9 62 ff ff ff       	jmp    801b73 <__umoddi3+0xb3>
