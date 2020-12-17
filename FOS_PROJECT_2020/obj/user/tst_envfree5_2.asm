
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 4d 01 00 00       	call   800183 <libmain>
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
	// Testing removing the shared variables
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 20 1d 80 00       	push   $0x801d20
  80004a:	e8 bf 12 00 00       	call   80130e <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 a5 14 00 00       	call   801508 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 20 15 00 00       	call   80158b <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 1d 80 00       	push   $0x801d30
  800079:	e8 ec 04 00 00       	call   80056a <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000, 50);
  800081:	83 ec 04             	sub    $0x4,%esp
  800084:	6a 32                	push   $0x32
  800086:	68 d0 07 00 00       	push   $0x7d0
  80008b:	68 63 1d 80 00       	push   $0x801d63
  800090:	e8 c8 16 00 00       	call   80175d <sys_create_env>
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000, 50);
  80009b:	83 ec 04             	sub    $0x4,%esp
  80009e:	6a 32                	push   $0x32
  8000a0:	68 d0 07 00 00       	push   $0x7d0
  8000a5:	68 6c 1d 80 00       	push   $0x801d6c
  8000aa:	e8 ae 16 00 00       	call   80175d <sys_create_env>
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b5:	83 ec 0c             	sub    $0xc,%esp
  8000b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8000bb:	e8 ba 16 00 00       	call   80177a <sys_run_env>
  8000c0:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 98 3a 00 00       	push   $0x3a98
  8000cb:	e8 28 19 00 00       	call   8019f8 <env_sleep>
  8000d0:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d9:	e8 9c 16 00 00       	call   80177a <sys_run_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000e1:	90                   	nop
  8000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e5:	8b 00                	mov    (%eax),%eax
  8000e7:	83 f8 02             	cmp    $0x2,%eax
  8000ea:	75 f6                	jne    8000e2 <_main+0xaa>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ec:	e8 17 14 00 00       	call   801508 <sys_calculate_free_frames>
  8000f1:	83 ec 08             	sub    $0x8,%esp
  8000f4:	50                   	push   %eax
  8000f5:	68 78 1d 80 00       	push   $0x801d78
  8000fa:	e8 6b 04 00 00       	call   80056a <cprintf>
  8000ff:	83 c4 10             	add    $0x10,%esp

	sys_free_env(envIdProcessA);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	ff 75 e8             	pushl  -0x18(%ebp)
  800108:	e8 89 16 00 00       	call   801796 <sys_free_env>
  80010d:	83 c4 10             	add    $0x10,%esp
	sys_free_env(envIdProcessB);
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	ff 75 e4             	pushl  -0x1c(%ebp)
  800116:	e8 7b 16 00 00       	call   801796 <sys_free_env>
  80011b:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011e:	e8 e5 13 00 00       	call   801508 <sys_calculate_free_frames>
  800123:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800126:	e8 60 14 00 00       	call   80158b <sys_pf_calculate_allocated_pages>
  80012b:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800131:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800134:	74 27                	je     80015d <_main+0x125>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	ff 75 e0             	pushl  -0x20(%ebp)
  80013c:	68 ac 1d 80 00       	push   $0x801dac
  800141:	e8 24 04 00 00       	call   80056a <cprintf>
  800146:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 fc 1d 80 00       	push   $0x801dfc
  800151:	6a 23                	push   $0x23
  800153:	68 32 1e 80 00       	push   $0x801e32
  800158:	e8 6b 01 00 00       	call   8002c8 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015d:	83 ec 08             	sub    $0x8,%esp
  800160:	ff 75 e0             	pushl  -0x20(%ebp)
  800163:	68 48 1e 80 00       	push   $0x801e48
  800168:	e8 fd 03 00 00       	call   80056a <cprintf>
  80016d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	68 a8 1e 80 00       	push   $0x801ea8
  800178:	e8 ed 03 00 00       	call   80056a <cprintf>
  80017d:	83 c4 10             	add    $0x10,%esp
	return;
  800180:	90                   	nop
}
  800181:	c9                   	leave  
  800182:	c3                   	ret    

00800183 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800183:	55                   	push   %ebp
  800184:	89 e5                	mov    %esp,%ebp
  800186:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800189:	e8 af 12 00 00       	call   80143d <sys_getenvindex>
  80018e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800191:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800194:	89 d0                	mov    %edx,%eax
  800196:	c1 e0 03             	shl    $0x3,%eax
  800199:	01 d0                	add    %edx,%eax
  80019b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001a2:	01 c8                	add    %ecx,%eax
  8001a4:	01 c0                	add    %eax,%eax
  8001a6:	01 d0                	add    %edx,%eax
  8001a8:	01 c0                	add    %eax,%eax
  8001aa:	01 d0                	add    %edx,%eax
  8001ac:	89 c2                	mov    %eax,%edx
  8001ae:	c1 e2 05             	shl    $0x5,%edx
  8001b1:	29 c2                	sub    %eax,%edx
  8001b3:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001ba:	89 c2                	mov    %eax,%edx
  8001bc:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001c2:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001cc:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001d2:	84 c0                	test   %al,%al
  8001d4:	74 0f                	je     8001e5 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001db:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001e0:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e9:	7e 0a                	jle    8001f5 <libmain+0x72>
		binaryname = argv[0];
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	ff 75 0c             	pushl  0xc(%ebp)
  8001fb:	ff 75 08             	pushl  0x8(%ebp)
  8001fe:	e8 35 fe ff ff       	call   800038 <_main>
  800203:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800206:	e8 cd 13 00 00       	call   8015d8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 0c 1f 80 00       	push   $0x801f0c
  800213:	e8 52 03 00 00       	call   80056a <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80021b:	a1 20 30 80 00       	mov    0x803020,%eax
  800220:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800226:	a1 20 30 80 00       	mov    0x803020,%eax
  80022b:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800231:	83 ec 04             	sub    $0x4,%esp
  800234:	52                   	push   %edx
  800235:	50                   	push   %eax
  800236:	68 34 1f 80 00       	push   $0x801f34
  80023b:	e8 2a 03 00 00       	call   80056a <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800243:	a1 20 30 80 00       	mov    0x803020,%eax
  800248:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80024e:	a1 20 30 80 00       	mov    0x803020,%eax
  800253:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800259:	83 ec 04             	sub    $0x4,%esp
  80025c:	52                   	push   %edx
  80025d:	50                   	push   %eax
  80025e:	68 5c 1f 80 00       	push   $0x801f5c
  800263:	e8 02 03 00 00       	call   80056a <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80026b:	a1 20 30 80 00       	mov    0x803020,%eax
  800270:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800276:	83 ec 08             	sub    $0x8,%esp
  800279:	50                   	push   %eax
  80027a:	68 9d 1f 80 00       	push   $0x801f9d
  80027f:	e8 e6 02 00 00       	call   80056a <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	68 0c 1f 80 00       	push   $0x801f0c
  80028f:	e8 d6 02 00 00       	call   80056a <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800297:	e8 56 13 00 00       	call   8015f2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80029c:	e8 19 00 00 00       	call   8002ba <exit>
}
  8002a1:	90                   	nop
  8002a2:	c9                   	leave  
  8002a3:	c3                   	ret    

008002a4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8002aa:	83 ec 0c             	sub    $0xc,%esp
  8002ad:	6a 00                	push   $0x0
  8002af:	e8 55 11 00 00       	call   801409 <sys_env_destroy>
  8002b4:	83 c4 10             	add    $0x10,%esp
}
  8002b7:	90                   	nop
  8002b8:	c9                   	leave  
  8002b9:	c3                   	ret    

008002ba <exit>:

void
exit(void)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002c0:	e8 aa 11 00 00       	call   80146f <sys_env_exit>
}
  8002c5:	90                   	nop
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ce:	8d 45 10             	lea    0x10(%ebp),%eax
  8002d1:	83 c0 04             	add    $0x4,%eax
  8002d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002d7:	a1 18 31 80 00       	mov    0x803118,%eax
  8002dc:	85 c0                	test   %eax,%eax
  8002de:	74 16                	je     8002f6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e0:	a1 18 31 80 00       	mov    0x803118,%eax
  8002e5:	83 ec 08             	sub    $0x8,%esp
  8002e8:	50                   	push   %eax
  8002e9:	68 b4 1f 80 00       	push   $0x801fb4
  8002ee:	e8 77 02 00 00       	call   80056a <cprintf>
  8002f3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002f6:	a1 00 30 80 00       	mov    0x803000,%eax
  8002fb:	ff 75 0c             	pushl  0xc(%ebp)
  8002fe:	ff 75 08             	pushl  0x8(%ebp)
  800301:	50                   	push   %eax
  800302:	68 b9 1f 80 00       	push   $0x801fb9
  800307:	e8 5e 02 00 00       	call   80056a <cprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	ff 75 f4             	pushl  -0xc(%ebp)
  800318:	50                   	push   %eax
  800319:	e8 e1 01 00 00       	call   8004ff <vcprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800321:	83 ec 08             	sub    $0x8,%esp
  800324:	6a 00                	push   $0x0
  800326:	68 d5 1f 80 00       	push   $0x801fd5
  80032b:	e8 cf 01 00 00       	call   8004ff <vcprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800333:	e8 82 ff ff ff       	call   8002ba <exit>

	// should not return here
	while (1) ;
  800338:	eb fe                	jmp    800338 <_panic+0x70>

0080033a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80033a:	55                   	push   %ebp
  80033b:	89 e5                	mov    %esp,%ebp
  80033d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800340:	a1 20 30 80 00       	mov    0x803020,%eax
  800345:	8b 50 74             	mov    0x74(%eax),%edx
  800348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034b:	39 c2                	cmp    %eax,%edx
  80034d:	74 14                	je     800363 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80034f:	83 ec 04             	sub    $0x4,%esp
  800352:	68 d8 1f 80 00       	push   $0x801fd8
  800357:	6a 26                	push   $0x26
  800359:	68 24 20 80 00       	push   $0x802024
  80035e:	e8 65 ff ff ff       	call   8002c8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800363:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80036a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800371:	e9 b6 00 00 00       	jmp    80042c <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800379:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800380:	8b 45 08             	mov    0x8(%ebp),%eax
  800383:	01 d0                	add    %edx,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	85 c0                	test   %eax,%eax
  800389:	75 08                	jne    800393 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80038b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80038e:	e9 96 00 00 00       	jmp    800429 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800393:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003a1:	eb 5d                	jmp    800400 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a8:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b1:	c1 e2 04             	shl    $0x4,%edx
  8003b4:	01 d0                	add    %edx,%eax
  8003b6:	8a 40 04             	mov    0x4(%eax),%al
  8003b9:	84 c0                	test   %al,%al
  8003bb:	75 40                	jne    8003fd <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c2:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003cb:	c1 e2 04             	shl    $0x4,%edx
  8003ce:	01 d0                	add    %edx,%eax
  8003d0:	8b 00                	mov    (%eax),%eax
  8003d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003dd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ec:	01 c8                	add    %ecx,%eax
  8003ee:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f0:	39 c2                	cmp    %eax,%edx
  8003f2:	75 09                	jne    8003fd <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8003f4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003fb:	eb 12                	jmp    80040f <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fd:	ff 45 e8             	incl   -0x18(%ebp)
  800400:	a1 20 30 80 00       	mov    0x803020,%eax
  800405:	8b 50 74             	mov    0x74(%eax),%edx
  800408:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80040b:	39 c2                	cmp    %eax,%edx
  80040d:	77 94                	ja     8003a3 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80040f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800413:	75 14                	jne    800429 <CheckWSWithoutLastIndex+0xef>
			panic(
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	68 30 20 80 00       	push   $0x802030
  80041d:	6a 3a                	push   $0x3a
  80041f:	68 24 20 80 00       	push   $0x802024
  800424:	e8 9f fe ff ff       	call   8002c8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800429:	ff 45 f0             	incl   -0x10(%ebp)
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800432:	0f 8c 3e ff ff ff    	jl     800376 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800438:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800446:	eb 20                	jmp    800468 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800448:	a1 20 30 80 00       	mov    0x803020,%eax
  80044d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800453:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800456:	c1 e2 04             	shl    $0x4,%edx
  800459:	01 d0                	add    %edx,%eax
  80045b:	8a 40 04             	mov    0x4(%eax),%al
  80045e:	3c 01                	cmp    $0x1,%al
  800460:	75 03                	jne    800465 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800462:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800465:	ff 45 e0             	incl   -0x20(%ebp)
  800468:	a1 20 30 80 00       	mov    0x803020,%eax
  80046d:	8b 50 74             	mov    0x74(%eax),%edx
  800470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800473:	39 c2                	cmp    %eax,%edx
  800475:	77 d1                	ja     800448 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047d:	74 14                	je     800493 <CheckWSWithoutLastIndex+0x159>
		panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 84 20 80 00       	push   $0x802084
  800487:	6a 44                	push   $0x44
  800489:	68 24 20 80 00       	push   $0x802024
  80048e:	e8 35 fe ff ff       	call   8002c8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800493:	90                   	nop
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	89 0a                	mov    %ecx,(%edx)
  8004a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ac:	88 d1                	mov    %dl,%cl
  8004ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bf:	75 2c                	jne    8004ed <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c1:	a0 24 30 80 00       	mov    0x803024,%al
  8004c6:	0f b6 c0             	movzbl %al,%eax
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	8b 12                	mov    (%edx),%edx
  8004ce:	89 d1                	mov    %edx,%ecx
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	83 c2 08             	add    $0x8,%edx
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	50                   	push   %eax
  8004da:	51                   	push   %ecx
  8004db:	52                   	push   %edx
  8004dc:	e8 e6 0e 00 00       	call   8013c7 <sys_cputs>
  8004e1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	8b 40 04             	mov    0x4(%eax),%eax
  8004f3:	8d 50 01             	lea    0x1(%eax),%edx
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fc:	90                   	nop
  8004fd:	c9                   	leave  
  8004fe:	c3                   	ret    

008004ff <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800508:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050f:	00 00 00 
	b.cnt = 0;
  800512:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800519:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051c:	ff 75 0c             	pushl  0xc(%ebp)
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800528:	50                   	push   %eax
  800529:	68 96 04 80 00       	push   $0x800496
  80052e:	e8 11 02 00 00       	call   800744 <vprintfmt>
  800533:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800536:	a0 24 30 80 00       	mov    0x803024,%al
  80053b:	0f b6 c0             	movzbl %al,%eax
  80053e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800544:	83 ec 04             	sub    $0x4,%esp
  800547:	50                   	push   %eax
  800548:	52                   	push   %edx
  800549:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054f:	83 c0 08             	add    $0x8,%eax
  800552:	50                   	push   %eax
  800553:	e8 6f 0e 00 00       	call   8013c7 <sys_cputs>
  800558:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80055b:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800562:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800568:	c9                   	leave  
  800569:	c3                   	ret    

0080056a <cprintf>:

int cprintf(const char *fmt, ...) {
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800570:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800577:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	ff 75 f4             	pushl  -0xc(%ebp)
  800586:	50                   	push   %eax
  800587:	e8 73 ff ff ff       	call   8004ff <vcprintf>
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800592:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80059d:	e8 36 10 00 00       	call   8015d8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b1:	50                   	push   %eax
  8005b2:	e8 48 ff ff ff       	call   8004ff <vcprintf>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005bd:	e8 30 10 00 00       	call   8015f2 <sys_enable_interrupt>
	return cnt;
  8005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 14             	sub    $0x14,%esp
  8005ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005da:	8b 45 18             	mov    0x18(%ebp),%eax
  8005dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e5:	77 55                	ja     80063c <printnum+0x75>
  8005e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ea:	72 05                	jb     8005f1 <printnum+0x2a>
  8005ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ef:	77 4b                	ja     80063c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ff:	52                   	push   %edx
  800600:	50                   	push   %eax
  800601:	ff 75 f4             	pushl  -0xc(%ebp)
  800604:	ff 75 f0             	pushl  -0x10(%ebp)
  800607:	e8 a0 14 00 00       	call   801aac <__udivdi3>
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	ff 75 20             	pushl  0x20(%ebp)
  800615:	53                   	push   %ebx
  800616:	ff 75 18             	pushl  0x18(%ebp)
  800619:	52                   	push   %edx
  80061a:	50                   	push   %eax
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	ff 75 08             	pushl  0x8(%ebp)
  800621:	e8 a1 ff ff ff       	call   8005c7 <printnum>
  800626:	83 c4 20             	add    $0x20,%esp
  800629:	eb 1a                	jmp    800645 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	ff 75 20             	pushl  0x20(%ebp)
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	ff d0                	call   *%eax
  800639:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063c:	ff 4d 1c             	decl   0x1c(%ebp)
  80063f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800643:	7f e6                	jg     80062b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800645:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800648:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800653:	53                   	push   %ebx
  800654:	51                   	push   %ecx
  800655:	52                   	push   %edx
  800656:	50                   	push   %eax
  800657:	e8 60 15 00 00       	call   801bbc <__umoddi3>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	05 f4 22 80 00       	add    $0x8022f4,%eax
  800664:	8a 00                	mov    (%eax),%al
  800666:	0f be c0             	movsbl %al,%eax
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	50                   	push   %eax
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
}
  800678:	90                   	nop
  800679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800681:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800685:	7e 1c                	jle    8006a3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8d 50 08             	lea    0x8(%eax),%edx
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	89 10                	mov    %edx,(%eax)
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	83 e8 08             	sub    $0x8,%eax
  80069c:	8b 50 04             	mov    0x4(%eax),%edx
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	eb 40                	jmp    8006e3 <getuint+0x65>
	else if (lflag)
  8006a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a7:	74 1e                	je     8006c7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 04             	lea    0x4(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 04             	sub    $0x4,%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c5:	eb 1c                	jmp    8006e3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	8d 50 04             	lea    0x4(%eax),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	89 10                	mov    %edx,(%eax)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	83 e8 04             	sub    $0x4,%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e3:	5d                   	pop    %ebp
  8006e4:	c3                   	ret    

008006e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ec:	7e 1c                	jle    80070a <getint+0x25>
		return va_arg(*ap, long long);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	8d 50 08             	lea    0x8(%eax),%edx
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	89 10                	mov    %edx,(%eax)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	83 e8 08             	sub    $0x8,%eax
  800703:	8b 50 04             	mov    0x4(%eax),%edx
  800706:	8b 00                	mov    (%eax),%eax
  800708:	eb 38                	jmp    800742 <getint+0x5d>
	else if (lflag)
  80070a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070e:	74 1a                	je     80072a <getint+0x45>
		return va_arg(*ap, long);
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	8d 50 04             	lea    0x4(%eax),%edx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	89 10                	mov    %edx,(%eax)
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	83 e8 04             	sub    $0x4,%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	99                   	cltd   
  800728:	eb 18                	jmp    800742 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 50 04             	lea    0x4(%eax),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	89 10                	mov    %edx,(%eax)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	83 e8 04             	sub    $0x4,%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	99                   	cltd   
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	56                   	push   %esi
  800748:	53                   	push   %ebx
  800749:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074c:	eb 17                	jmp    800765 <vprintfmt+0x21>
			if (ch == '\0')
  80074e:	85 db                	test   %ebx,%ebx
  800750:	0f 84 af 03 00 00    	je     800b05 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	53                   	push   %ebx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	ff d0                	call   *%eax
  800762:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	8d 50 01             	lea    0x1(%eax),%edx
  80076b:	89 55 10             	mov    %edx,0x10(%ebp)
  80076e:	8a 00                	mov    (%eax),%al
  800770:	0f b6 d8             	movzbl %al,%ebx
  800773:	83 fb 25             	cmp    $0x25,%ebx
  800776:	75 d6                	jne    80074e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800778:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800783:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80078a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800791:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a9:	83 f8 55             	cmp    $0x55,%eax
  8007ac:	0f 87 2b 03 00 00    	ja     800add <vprintfmt+0x399>
  8007b2:	8b 04 85 18 23 80 00 	mov    0x802318(,%eax,4),%eax
  8007b9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007bb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bf:	eb d7                	jmp    800798 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c5:	eb d1                	jmp    800798 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d1:	89 d0                	mov    %edx,%eax
  8007d3:	c1 e0 02             	shl    $0x2,%eax
  8007d6:	01 d0                	add    %edx,%eax
  8007d8:	01 c0                	add    %eax,%eax
  8007da:	01 d8                	add    %ebx,%eax
  8007dc:	83 e8 30             	sub    $0x30,%eax
  8007df:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8a 00                	mov    (%eax),%al
  8007e7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ea:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ed:	7e 3e                	jle    80082d <vprintfmt+0xe9>
  8007ef:	83 fb 39             	cmp    $0x39,%ebx
  8007f2:	7f 39                	jg     80082d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f7:	eb d5                	jmp    8007ce <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 c0 04             	add    $0x4,%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080d:	eb 1f                	jmp    80082e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800813:	79 83                	jns    800798 <vprintfmt+0x54>
				width = 0;
  800815:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081c:	e9 77 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800821:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800828:	e9 6b ff ff ff       	jmp    800798 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800832:	0f 89 60 ff ff ff    	jns    800798 <vprintfmt+0x54>
				width = precision, precision = -1;
  800838:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800845:	e9 4e ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084d:	e9 46 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	83 c0 04             	add    $0x4,%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	50                   	push   %eax
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	ff d0                	call   *%eax
  80086f:	83 c4 10             	add    $0x10,%esp
			break;
  800872:	e9 89 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	83 c0 04             	add    $0x4,%eax
  80087d:	89 45 14             	mov    %eax,0x14(%ebp)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	83 e8 04             	sub    $0x4,%eax
  800886:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800888:	85 db                	test   %ebx,%ebx
  80088a:	79 02                	jns    80088e <vprintfmt+0x14a>
				err = -err;
  80088c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088e:	83 fb 64             	cmp    $0x64,%ebx
  800891:	7f 0b                	jg     80089e <vprintfmt+0x15a>
  800893:	8b 34 9d 60 21 80 00 	mov    0x802160(,%ebx,4),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 19                	jne    8008b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089e:	53                   	push   %ebx
  80089f:	68 05 23 80 00       	push   $0x802305
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	ff 75 08             	pushl  0x8(%ebp)
  8008aa:	e8 5e 02 00 00       	call   800b0d <printfmt>
  8008af:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b2:	e9 49 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b7:	56                   	push   %esi
  8008b8:	68 0e 23 80 00       	push   $0x80230e
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	ff 75 08             	pushl  0x8(%ebp)
  8008c3:	e8 45 02 00 00       	call   800b0d <printfmt>
  8008c8:	83 c4 10             	add    $0x10,%esp
			break;
  8008cb:	e9 30 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 e8 04             	sub    $0x4,%eax
  8008df:	8b 30                	mov    (%eax),%esi
  8008e1:	85 f6                	test   %esi,%esi
  8008e3:	75 05                	jne    8008ea <vprintfmt+0x1a6>
				p = "(null)";
  8008e5:	be 11 23 80 00       	mov    $0x802311,%esi
			if (width > 0 && padc != '-')
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7e 6d                	jle    80095d <vprintfmt+0x219>
  8008f0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f4:	74 67                	je     80095d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	50                   	push   %eax
  8008fd:	56                   	push   %esi
  8008fe:	e8 0c 03 00 00       	call   800c0f <strnlen>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800909:	eb 16                	jmp    800921 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80090b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091e:	ff 4d e4             	decl   -0x1c(%ebp)
  800921:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800925:	7f e4                	jg     80090b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800927:	eb 34                	jmp    80095d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800929:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092d:	74 1c                	je     80094b <vprintfmt+0x207>
  80092f:	83 fb 1f             	cmp    $0x1f,%ebx
  800932:	7e 05                	jle    800939 <vprintfmt+0x1f5>
  800934:	83 fb 7e             	cmp    $0x7e,%ebx
  800937:	7e 12                	jle    80094b <vprintfmt+0x207>
					putch('?', putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	6a 3f                	push   $0x3f
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
  800946:	83 c4 10             	add    $0x10,%esp
  800949:	eb 0f                	jmp    80095a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	53                   	push   %ebx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	ff 4d e4             	decl   -0x1c(%ebp)
  80095d:	89 f0                	mov    %esi,%eax
  80095f:	8d 70 01             	lea    0x1(%eax),%esi
  800962:	8a 00                	mov    (%eax),%al
  800964:	0f be d8             	movsbl %al,%ebx
  800967:	85 db                	test   %ebx,%ebx
  800969:	74 24                	je     80098f <vprintfmt+0x24b>
  80096b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096f:	78 b8                	js     800929 <vprintfmt+0x1e5>
  800971:	ff 4d e0             	decl   -0x20(%ebp)
  800974:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800978:	79 af                	jns    800929 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097a:	eb 13                	jmp    80098f <vprintfmt+0x24b>
				putch(' ', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	6a 20                	push   $0x20
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	ff d0                	call   *%eax
  800989:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098c:	ff 4d e4             	decl   -0x1c(%ebp)
  80098f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800993:	7f e7                	jg     80097c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800995:	e9 66 01 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a3:	50                   	push   %eax
  8009a4:	e8 3c fd ff ff       	call   8006e5 <getint>
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b8:	85 d2                	test   %edx,%edx
  8009ba:	79 23                	jns    8009df <vprintfmt+0x29b>
				putch('-', putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	6a 2d                	push   $0x2d
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	ff d0                	call   *%eax
  8009c9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d2:	f7 d8                	neg    %eax
  8009d4:	83 d2 00             	adc    $0x0,%edx
  8009d7:	f7 da                	neg    %edx
  8009d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e6:	e9 bc 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f4:	50                   	push   %eax
  8009f5:	e8 84 fc ff ff       	call   80067e <getuint>
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a03:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a0a:	e9 98 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 58                	push   $0x58
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	6a 58                	push   $0x58
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 58                	push   $0x58
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			break;
  800a3f:	e9 bc 00 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 30                	push   $0x30
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	6a 78                	push   $0x78
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	83 c0 04             	add    $0x4,%eax
  800a6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a70:	83 e8 04             	sub    $0x4,%eax
  800a73:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a86:	eb 1f                	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a91:	50                   	push   %eax
  800a92:	e8 e7 fb ff ff       	call   80067e <getuint>
  800a97:	83 c4 10             	add    $0x10,%esp
  800a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	52                   	push   %edx
  800ab2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab9:	ff 75 f0             	pushl  -0x10(%ebp)
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	ff 75 08             	pushl  0x8(%ebp)
  800ac2:	e8 00 fb ff ff       	call   8005c7 <printnum>
  800ac7:	83 c4 20             	add    $0x20,%esp
			break;
  800aca:	eb 34                	jmp    800b00 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	53                   	push   %ebx
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	ff d0                	call   *%eax
  800ad8:	83 c4 10             	add    $0x10,%esp
			break;
  800adb:	eb 23                	jmp    800b00 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	6a 25                	push   $0x25
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	ff d0                	call   *%eax
  800aea:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aed:	ff 4d 10             	decl   0x10(%ebp)
  800af0:	eb 03                	jmp    800af5 <vprintfmt+0x3b1>
  800af2:	ff 4d 10             	decl   0x10(%ebp)
  800af5:	8b 45 10             	mov    0x10(%ebp),%eax
  800af8:	48                   	dec    %eax
  800af9:	8a 00                	mov    (%eax),%al
  800afb:	3c 25                	cmp    $0x25,%al
  800afd:	75 f3                	jne    800af2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aff:	90                   	nop
		}
	}
  800b00:	e9 47 fc ff ff       	jmp    80074c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b05:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b09:	5b                   	pop    %ebx
  800b0a:	5e                   	pop    %esi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b13:	8d 45 10             	lea    0x10(%ebp),%eax
  800b16:	83 c0 04             	add    $0x4,%eax
  800b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b22:	50                   	push   %eax
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	ff 75 08             	pushl  0x8(%ebp)
  800b29:	e8 16 fc ff ff       	call   800744 <vprintfmt>
  800b2e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b31:	90                   	nop
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8b 40 08             	mov    0x8(%eax),%eax
  800b3d:	8d 50 01             	lea    0x1(%eax),%edx
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	8b 10                	mov    (%eax),%edx
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8b 40 04             	mov    0x4(%eax),%eax
  800b51:	39 c2                	cmp    %eax,%edx
  800b53:	73 12                	jae    800b67 <sprintputch+0x33>
		*b->buf++ = ch;
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b60:	89 0a                	mov    %ecx,(%edx)
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	88 10                	mov    %dl,(%eax)
}
  800b67:	90                   	nop
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	01 d0                	add    %edx,%eax
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8f:	74 06                	je     800b97 <vsnprintf+0x2d>
  800b91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b95:	7f 07                	jg     800b9e <vsnprintf+0x34>
		return -E_INVAL;
  800b97:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9c:	eb 20                	jmp    800bbe <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9e:	ff 75 14             	pushl  0x14(%ebp)
  800ba1:	ff 75 10             	pushl  0x10(%ebp)
  800ba4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba7:	50                   	push   %eax
  800ba8:	68 34 0b 80 00       	push   $0x800b34
  800bad:	e8 92 fb ff ff       	call   800744 <vprintfmt>
  800bb2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc9:	83 c0 04             	add    $0x4,%eax
  800bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	ff 75 08             	pushl  0x8(%ebp)
  800bdc:	e8 89 ff ff ff       	call   800b6a <vsnprintf>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf9:	eb 06                	jmp    800c01 <strlen+0x15>
		n++;
  800bfb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfe:	ff 45 08             	incl   0x8(%ebp)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	84 c0                	test   %al,%al
  800c08:	75 f1                	jne    800bfb <strlen+0xf>
		n++;
	return n;
  800c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1c:	eb 09                	jmp    800c27 <strnlen+0x18>
		n++;
  800c1e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c21:	ff 45 08             	incl   0x8(%ebp)
  800c24:	ff 4d 0c             	decl   0xc(%ebp)
  800c27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2b:	74 09                	je     800c36 <strnlen+0x27>
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	84 c0                	test   %al,%al
  800c34:	75 e8                	jne    800c1e <strnlen+0xf>
		n++;
	return n;
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    

00800c3b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c47:	90                   	nop
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8d 50 01             	lea    0x1(%eax),%edx
  800c4e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c54:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c57:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c5a:	8a 12                	mov    (%edx),%dl
  800c5c:	88 10                	mov    %dl,(%eax)
  800c5e:	8a 00                	mov    (%eax),%al
  800c60:	84 c0                	test   %al,%al
  800c62:	75 e4                	jne    800c48 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7c:	eb 1f                	jmp    800c9d <strncpy+0x34>
		*dst++ = *src;
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8d 50 01             	lea    0x1(%eax),%edx
  800c84:	89 55 08             	mov    %edx,0x8(%ebp)
  800c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	74 03                	je     800c9a <strncpy+0x31>
			src++;
  800c97:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c9a:	ff 45 fc             	incl   -0x4(%ebp)
  800c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca3:	72 d9                	jb     800c7e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cba:	74 30                	je     800cec <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cbc:	eb 16                	jmp    800cd4 <strlcpy+0x2a>
			*dst++ = *src++;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8d 50 01             	lea    0x1(%eax),%edx
  800cc4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd0:	8a 12                	mov    (%edx),%dl
  800cd2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd4:	ff 4d 10             	decl   0x10(%ebp)
  800cd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdb:	74 09                	je     800ce6 <strlcpy+0x3c>
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	75 d8                	jne    800cbe <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf2:	29 c2                	sub    %eax,%edx
  800cf4:	89 d0                	mov    %edx,%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cfb:	eb 06                	jmp    800d03 <strcmp+0xb>
		p++, q++;
  800cfd:	ff 45 08             	incl   0x8(%ebp)
  800d00:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	84 c0                	test   %al,%al
  800d0a:	74 0e                	je     800d1a <strcmp+0x22>
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 10                	mov    (%eax),%dl
  800d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	38 c2                	cmp    %al,%dl
  800d18:	74 e3                	je     800cfd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	0f b6 d0             	movzbl %al,%edx
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	0f b6 c0             	movzbl %al,%eax
  800d2a:	29 c2                	sub    %eax,%edx
  800d2c:	89 d0                	mov    %edx,%eax
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d33:	eb 09                	jmp    800d3e <strncmp+0xe>
		n--, p++, q++;
  800d35:	ff 4d 10             	decl   0x10(%ebp)
  800d38:	ff 45 08             	incl   0x8(%ebp)
  800d3b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d42:	74 17                	je     800d5b <strncmp+0x2b>
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	84 c0                	test   %al,%al
  800d4b:	74 0e                	je     800d5b <strncmp+0x2b>
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 10                	mov    (%eax),%dl
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	38 c2                	cmp    %al,%dl
  800d59:	74 da                	je     800d35 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5f:	75 07                	jne    800d68 <strncmp+0x38>
		return 0;
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
  800d66:	eb 14                	jmp    800d7c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	0f b6 d0             	movzbl %al,%edx
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f b6 c0             	movzbl %al,%eax
  800d78:	29 c2                	sub    %eax,%edx
  800d7a:	89 d0                	mov    %edx,%eax
}
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 04             	sub    $0x4,%esp
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8a:	eb 12                	jmp    800d9e <strchr+0x20>
		if (*s == c)
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d94:	75 05                	jne    800d9b <strchr+0x1d>
			return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	eb 11                	jmp    800dac <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	84 c0                	test   %al,%al
  800da5:	75 e5                	jne    800d8c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 04             	sub    $0x4,%esp
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dba:	eb 0d                	jmp    800dc9 <strfind+0x1b>
		if (*s == c)
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc4:	74 0e                	je     800dd4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc6:	ff 45 08             	incl   0x8(%ebp)
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	84 c0                	test   %al,%al
  800dd0:	75 ea                	jne    800dbc <strfind+0xe>
  800dd2:	eb 01                	jmp    800dd5 <strfind+0x27>
		if (*s == c)
			break;
  800dd4:	90                   	nop
	return (char *) s;
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd8:	c9                   	leave  
  800dd9:	c3                   	ret    

00800dda <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de6:	8b 45 10             	mov    0x10(%ebp),%eax
  800de9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dec:	eb 0e                	jmp    800dfc <memset+0x22>
		*p++ = c;
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfa:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dfc:	ff 4d f8             	decl   -0x8(%ebp)
  800dff:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e03:	79 e9                	jns    800dee <memset+0x14>
		*p++ = c;

	return v;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e1c:	eb 16                	jmp    800e34 <memcpy+0x2a>
		*d++ = *s++;
  800e1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e21:	8d 50 01             	lea    0x1(%eax),%edx
  800e24:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e27:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e30:	8a 12                	mov    (%edx),%dl
  800e32:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	75 dd                	jne    800e1e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5e:	73 50                	jae    800eb0 <memmove+0x6a>
  800e60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	01 d0                	add    %edx,%eax
  800e68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e6b:	76 43                	jbe    800eb0 <memmove+0x6a>
		s += n;
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e73:	8b 45 10             	mov    0x10(%ebp),%eax
  800e76:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e79:	eb 10                	jmp    800e8b <memmove+0x45>
			*--d = *--s;
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	ff 4d fc             	decl   -0x4(%ebp)
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e84:	8a 10                	mov    (%eax),%dl
  800e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e89:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e91:	89 55 10             	mov    %edx,0x10(%ebp)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	75 e3                	jne    800e7b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e98:	eb 23                	jmp    800ebd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eac:	8a 12                	mov    (%edx),%dl
  800eae:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	75 dd                	jne    800e9a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed4:	eb 2a                	jmp    800f00 <memcmp+0x3e>
		if (*s1 != *s2)
  800ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed9:	8a 10                	mov    (%eax),%dl
  800edb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	38 c2                	cmp    %al,%dl
  800ee2:	74 16                	je     800efa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	0f b6 d0             	movzbl %al,%edx
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	0f b6 c0             	movzbl %al,%eax
  800ef4:	29 c2                	sub    %eax,%edx
  800ef6:	89 d0                	mov    %edx,%eax
  800ef8:	eb 18                	jmp    800f12 <memcmp+0x50>
		s1++, s2++;
  800efa:	ff 45 fc             	incl   -0x4(%ebp)
  800efd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f06:	89 55 10             	mov    %edx,0x10(%ebp)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	75 c9                	jne    800ed6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f20:	01 d0                	add    %edx,%eax
  800f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f25:	eb 15                	jmp    800f3c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 d0             	movzbl %al,%edx
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	0f b6 c0             	movzbl %al,%eax
  800f35:	39 c2                	cmp    %eax,%edx
  800f37:	74 0d                	je     800f46 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f42:	72 e3                	jb     800f27 <memfind+0x13>
  800f44:	eb 01                	jmp    800f47 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f46:	90                   	nop
	return (void *) s;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4a:	c9                   	leave  
  800f4b:	c3                   	ret    

00800f4c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f59:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f60:	eb 03                	jmp    800f65 <strtol+0x19>
		s++;
  800f62:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 20                	cmp    $0x20,%al
  800f6c:	74 f4                	je     800f62 <strtol+0x16>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 09                	cmp    $0x9,%al
  800f75:	74 eb                	je     800f62 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 2b                	cmp    $0x2b,%al
  800f7e:	75 05                	jne    800f85 <strtol+0x39>
		s++;
  800f80:	ff 45 08             	incl   0x8(%ebp)
  800f83:	eb 13                	jmp    800f98 <strtol+0x4c>
	else if (*s == '-')
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 2d                	cmp    $0x2d,%al
  800f8c:	75 0a                	jne    800f98 <strtol+0x4c>
		s++, neg = 1;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	74 06                	je     800fa4 <strtol+0x58>
  800f9e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa2:	75 20                	jne    800fc4 <strtol+0x78>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 17                	jne    800fc4 <strtol+0x78>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	40                   	inc    %eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	3c 78                	cmp    $0x78,%al
  800fb5:	75 0d                	jne    800fc4 <strtol+0x78>
		s += 2, base = 16;
  800fb7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fbb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc2:	eb 28                	jmp    800fec <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc8:	75 15                	jne    800fdf <strtol+0x93>
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	3c 30                	cmp    $0x30,%al
  800fd1:	75 0c                	jne    800fdf <strtol+0x93>
		s++, base = 8;
  800fd3:	ff 45 08             	incl   0x8(%ebp)
  800fd6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fdd:	eb 0d                	jmp    800fec <strtol+0xa0>
	else if (base == 0)
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 07                	jne    800fec <strtol+0xa0>
		base = 10;
  800fe5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 2f                	cmp    $0x2f,%al
  800ff3:	7e 19                	jle    80100e <strtol+0xc2>
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 39                	cmp    $0x39,%al
  800ffc:	7f 10                	jg     80100e <strtol+0xc2>
			dig = *s - '0';
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	0f be c0             	movsbl %al,%eax
  801006:	83 e8 30             	sub    $0x30,%eax
  801009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100c:	eb 42                	jmp    801050 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	3c 60                	cmp    $0x60,%al
  801015:	7e 19                	jle    801030 <strtol+0xe4>
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	3c 7a                	cmp    $0x7a,%al
  80101e:	7f 10                	jg     801030 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	0f be c0             	movsbl %al,%eax
  801028:	83 e8 57             	sub    $0x57,%eax
  80102b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102e:	eb 20                	jmp    801050 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 40                	cmp    $0x40,%al
  801037:	7e 39                	jle    801072 <strtol+0x126>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 5a                	cmp    $0x5a,%al
  801040:	7f 30                	jg     801072 <strtol+0x126>
			dig = *s - 'A' + 10;
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	0f be c0             	movsbl %al,%eax
  80104a:	83 e8 37             	sub    $0x37,%eax
  80104d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801053:	3b 45 10             	cmp    0x10(%ebp),%eax
  801056:	7d 19                	jge    801071 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801058:	ff 45 08             	incl   0x8(%ebp)
  80105b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801062:	89 c2                	mov    %eax,%edx
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	01 d0                	add    %edx,%eax
  801069:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80106c:	e9 7b ff ff ff       	jmp    800fec <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801071:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801072:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801076:	74 08                	je     801080 <strtol+0x134>
		*endptr = (char *) s;
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801080:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801084:	74 07                	je     80108d <strtol+0x141>
  801086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801089:	f7 d8                	neg    %eax
  80108b:	eb 03                	jmp    801090 <strtol+0x144>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <ltostr>:

void
ltostr(long value, char *str)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010aa:	79 13                	jns    8010bf <ltostr+0x2d>
	{
		neg = 1;
  8010ac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010bc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c7:	99                   	cltd   
  8010c8:	f7 f9                	idiv   %ecx
  8010ca:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d0:	8d 50 01             	lea    0x1(%eax),%edx
  8010d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d6:	89 c2                	mov    %eax,%edx
  8010d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010db:	01 d0                	add    %edx,%eax
  8010dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e0:	83 c2 30             	add    $0x30,%edx
  8010e3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ed:	f7 e9                	imul   %ecx
  8010ef:	c1 fa 02             	sar    $0x2,%edx
  8010f2:	89 c8                	mov    %ecx,%eax
  8010f4:	c1 f8 1f             	sar    $0x1f,%eax
  8010f7:	29 c2                	sub    %eax,%edx
  8010f9:	89 d0                	mov    %edx,%eax
  8010fb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801101:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801106:	f7 e9                	imul   %ecx
  801108:	c1 fa 02             	sar    $0x2,%edx
  80110b:	89 c8                	mov    %ecx,%eax
  80110d:	c1 f8 1f             	sar    $0x1f,%eax
  801110:	29 c2                	sub    %eax,%edx
  801112:	89 d0                	mov    %edx,%eax
  801114:	c1 e0 02             	shl    $0x2,%eax
  801117:	01 d0                	add    %edx,%eax
  801119:	01 c0                	add    %eax,%eax
  80111b:	29 c1                	sub    %eax,%ecx
  80111d:	89 ca                	mov    %ecx,%edx
  80111f:	85 d2                	test   %edx,%edx
  801121:	75 9c                	jne    8010bf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80112a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112d:	48                   	dec    %eax
  80112e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801131:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801135:	74 3d                	je     801174 <ltostr+0xe2>
		start = 1 ;
  801137:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113e:	eb 34                	jmp    801174 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 d0                	add    %edx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80114d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	01 c2                	add    %eax,%edx
  801155:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	01 c8                	add    %ecx,%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801161:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8a 45 eb             	mov    -0x15(%ebp),%al
  80116c:	88 02                	mov    %al,(%edx)
		start++ ;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801171:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801177:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80117a:	7c c4                	jl     801140 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80117c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 d0                	add    %edx,%eax
  801184:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801190:	ff 75 08             	pushl  0x8(%ebp)
  801193:	e8 54 fa ff ff       	call   800bec <strlen>
  801198:	83 c4 04             	add    $0x4,%esp
  80119b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119e:	ff 75 0c             	pushl  0xc(%ebp)
  8011a1:	e8 46 fa ff ff       	call   800bec <strlen>
  8011a6:	83 c4 04             	add    $0x4,%esp
  8011a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ba:	eb 17                	jmp    8011d3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d0:	ff 45 fc             	incl   -0x4(%ebp)
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d9:	7c e1                	jl     8011bc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e9:	eb 1f                	jmp    80120a <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	89 c2                	mov    %eax,%edx
  8011f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f9:	01 c2                	add    %eax,%edx
  8011fb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 c8                	add    %ecx,%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801207:	ff 45 f8             	incl   -0x8(%ebp)
  80120a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801210:	7c d9                	jl     8011eb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801212:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801215:	8b 45 10             	mov    0x10(%ebp),%eax
  801218:	01 d0                	add    %edx,%eax
  80121a:	c6 00 00             	movb   $0x0,(%eax)
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	8b 00                	mov    (%eax),%eax
  801231:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	01 d0                	add    %edx,%eax
  80123d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801243:	eb 0c                	jmp    801251 <strsplit+0x31>
			*string++ = 0;
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8d 50 01             	lea    0x1(%eax),%edx
  80124b:	89 55 08             	mov    %edx,0x8(%ebp)
  80124e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	84 c0                	test   %al,%al
  801258:	74 18                	je     801272 <strsplit+0x52>
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	0f be c0             	movsbl %al,%eax
  801262:	50                   	push   %eax
  801263:	ff 75 0c             	pushl  0xc(%ebp)
  801266:	e8 13 fb ff ff       	call   800d7e <strchr>
  80126b:	83 c4 08             	add    $0x8,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	75 d3                	jne    801245 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	84 c0                	test   %al,%al
  801279:	74 5a                	je     8012d5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	83 f8 0f             	cmp    $0xf,%eax
  801283:	75 07                	jne    80128c <strsplit+0x6c>
		{
			return 0;
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
  80128a:	eb 66                	jmp    8012f2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80128c:	8b 45 14             	mov    0x14(%ebp),%eax
  80128f:	8b 00                	mov    (%eax),%eax
  801291:	8d 48 01             	lea    0x1(%eax),%ecx
  801294:	8b 55 14             	mov    0x14(%ebp),%edx
  801297:	89 0a                	mov    %ecx,(%edx)
  801299:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a3:	01 c2                	add    %eax,%edx
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012aa:	eb 03                	jmp    8012af <strsplit+0x8f>
			string++;
  8012ac:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	84 c0                	test   %al,%al
  8012b6:	74 8b                	je     801243 <strsplit+0x23>
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	0f be c0             	movsbl %al,%eax
  8012c0:	50                   	push   %eax
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	e8 b5 fa ff ff       	call   800d7e <strchr>
  8012c9:	83 c4 08             	add    $0x8,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	74 dc                	je     8012ac <strsplit+0x8c>
			string++;
	}
  8012d0:	e9 6e ff ff ff       	jmp    801243 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d9:	8b 00                	mov    (%eax),%eax
  8012db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	01 d0                	add    %edx,%eax
  8012e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ed:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8012fa:	83 ec 04             	sub    $0x4,%esp
  8012fd:	68 70 24 80 00       	push   $0x802470
  801302:	6a 19                	push   $0x19
  801304:	68 95 24 80 00       	push   $0x802495
  801309:	e8 ba ef ff ff       	call   8002c8 <_panic>

0080130e <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	83 ec 18             	sub    $0x18,%esp
  801314:	8b 45 10             	mov    0x10(%ebp),%eax
  801317:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80131a:	83 ec 04             	sub    $0x4,%esp
  80131d:	68 a4 24 80 00       	push   $0x8024a4
  801322:	6a 31                	push   $0x31
  801324:	68 95 24 80 00       	push   $0x802495
  801329:	e8 9a ef ff ff       	call   8002c8 <_panic>

0080132e <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801334:	83 ec 04             	sub    $0x4,%esp
  801337:	68 cc 24 80 00       	push   $0x8024cc
  80133c:	6a 4a                	push   $0x4a
  80133e:	68 95 24 80 00       	push   $0x802495
  801343:	e8 80 ef ff ff       	call   8002c8 <_panic>

00801348 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80134e:	83 ec 04             	sub    $0x4,%esp
  801351:	68 f0 24 80 00       	push   $0x8024f0
  801356:	6a 70                	push   $0x70
  801358:	68 95 24 80 00       	push   $0x802495
  80135d:	e8 66 ef ff ff       	call   8002c8 <_panic>

00801362 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801368:	83 ec 04             	sub    $0x4,%esp
  80136b:	68 14 25 80 00       	push   $0x802514
  801370:	68 8b 00 00 00       	push   $0x8b
  801375:	68 95 24 80 00       	push   $0x802495
  80137a:	e8 49 ef ff ff       	call   8002c8 <_panic>

0080137f <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801385:	83 ec 04             	sub    $0x4,%esp
  801388:	68 38 25 80 00       	push   $0x802538
  80138d:	68 a8 00 00 00       	push   $0xa8
  801392:	68 95 24 80 00       	push   $0x802495
  801397:	e8 2c ef ff ff       	call   8002c8 <_panic>

0080139c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	57                   	push   %edi
  8013a0:	56                   	push   %esi
  8013a1:	53                   	push   %ebx
  8013a2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013b1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013b4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013b7:	cd 30                	int    $0x30
  8013b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8013bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013bf:	83 c4 10             	add    $0x10,%esp
  8013c2:	5b                   	pop    %ebx
  8013c3:	5e                   	pop    %esi
  8013c4:	5f                   	pop    %edi
  8013c5:	5d                   	pop    %ebp
  8013c6:	c3                   	ret    

008013c7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	83 ec 04             	sub    $0x4,%esp
  8013cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8013d3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	52                   	push   %edx
  8013df:	ff 75 0c             	pushl  0xc(%ebp)
  8013e2:	50                   	push   %eax
  8013e3:	6a 00                	push   $0x0
  8013e5:	e8 b2 ff ff ff       	call   80139c <syscall>
  8013ea:	83 c4 18             	add    $0x18,%esp
}
  8013ed:	90                   	nop
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 01                	push   $0x1
  8013ff:	e8 98 ff ff ff       	call   80139c <syscall>
  801404:	83 c4 18             	add    $0x18,%esp
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	50                   	push   %eax
  801418:	6a 05                	push   $0x5
  80141a:	e8 7d ff ff ff       	call   80139c <syscall>
  80141f:	83 c4 18             	add    $0x18,%esp
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 02                	push   $0x2
  801433:	e8 64 ff ff ff       	call   80139c <syscall>
  801438:	83 c4 18             	add    $0x18,%esp
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 03                	push   $0x3
  80144c:	e8 4b ff ff ff       	call   80139c <syscall>
  801451:	83 c4 18             	add    $0x18,%esp
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 04                	push   $0x4
  801465:	e8 32 ff ff ff       	call   80139c <syscall>
  80146a:	83 c4 18             	add    $0x18,%esp
}
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <sys_env_exit>:


void sys_env_exit(void)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	6a 06                	push   $0x6
  80147e:	e8 19 ff ff ff       	call   80139c <syscall>
  801483:	83 c4 18             	add    $0x18,%esp
}
  801486:	90                   	nop
  801487:	c9                   	leave  
  801488:	c3                   	ret    

00801489 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80148c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	52                   	push   %edx
  801499:	50                   	push   %eax
  80149a:	6a 07                	push   $0x7
  80149c:	e8 fb fe ff ff       	call   80139c <syscall>
  8014a1:	83 c4 18             	add    $0x18,%esp
}
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    

008014a6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
  8014a9:	56                   	push   %esi
  8014aa:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014ab:	8b 75 18             	mov    0x18(%ebp),%esi
  8014ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	56                   	push   %esi
  8014bb:	53                   	push   %ebx
  8014bc:	51                   	push   %ecx
  8014bd:	52                   	push   %edx
  8014be:	50                   	push   %eax
  8014bf:	6a 08                	push   $0x8
  8014c1:	e8 d6 fe ff ff       	call   80139c <syscall>
  8014c6:	83 c4 18             	add    $0x18,%esp
}
  8014c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014cc:	5b                   	pop    %ebx
  8014cd:	5e                   	pop    %esi
  8014ce:	5d                   	pop    %ebp
  8014cf:	c3                   	ret    

008014d0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	52                   	push   %edx
  8014e0:	50                   	push   %eax
  8014e1:	6a 09                	push   $0x9
  8014e3:	e8 b4 fe ff ff       	call   80139c <syscall>
  8014e8:	83 c4 18             	add    $0x18,%esp
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	ff 75 0c             	pushl  0xc(%ebp)
  8014f9:	ff 75 08             	pushl  0x8(%ebp)
  8014fc:	6a 0a                	push   $0xa
  8014fe:	e8 99 fe ff ff       	call   80139c <syscall>
  801503:	83 c4 18             	add    $0x18,%esp
}
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 0b                	push   $0xb
  801517:	e8 80 fe ff ff       	call   80139c <syscall>
  80151c:	83 c4 18             	add    $0x18,%esp
}
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 0c                	push   $0xc
  801530:	e8 67 fe ff ff       	call   80139c <syscall>
  801535:	83 c4 18             	add    $0x18,%esp
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 0d                	push   $0xd
  801549:	e8 4e fe ff ff       	call   80139c <syscall>
  80154e:	83 c4 18             	add    $0x18,%esp
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	ff 75 0c             	pushl  0xc(%ebp)
  80155f:	ff 75 08             	pushl  0x8(%ebp)
  801562:	6a 11                	push   $0x11
  801564:	e8 33 fe ff ff       	call   80139c <syscall>
  801569:	83 c4 18             	add    $0x18,%esp
	return;
  80156c:	90                   	nop
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	ff 75 0c             	pushl  0xc(%ebp)
  80157b:	ff 75 08             	pushl  0x8(%ebp)
  80157e:	6a 12                	push   $0x12
  801580:	e8 17 fe ff ff       	call   80139c <syscall>
  801585:	83 c4 18             	add    $0x18,%esp
	return ;
  801588:	90                   	nop
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 0e                	push   $0xe
  80159a:	e8 fd fd ff ff       	call   80139c <syscall>
  80159f:	83 c4 18             	add    $0x18,%esp
}
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    

008015a4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	ff 75 08             	pushl  0x8(%ebp)
  8015b2:	6a 0f                	push   $0xf
  8015b4:	e8 e3 fd ff ff       	call   80139c <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 10                	push   $0x10
  8015cd:	e8 ca fd ff ff       	call   80139c <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	90                   	nop
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 14                	push   $0x14
  8015e7:	e8 b0 fd ff ff       	call   80139c <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
}
  8015ef:	90                   	nop
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 15                	push   $0x15
  801601:	e8 96 fd ff ff       	call   80139c <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	90                   	nop
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <sys_cputc>:


void
sys_cputc(const char c)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801618:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	50                   	push   %eax
  801625:	6a 16                	push   $0x16
  801627:	e8 70 fd ff ff       	call   80139c <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	90                   	nop
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 17                	push   $0x17
  801641:	e8 56 fd ff ff       	call   80139c <syscall>
  801646:	83 c4 18             	add    $0x18,%esp
}
  801649:	90                   	nop
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	ff 75 0c             	pushl  0xc(%ebp)
  80165b:	50                   	push   %eax
  80165c:	6a 18                	push   $0x18
  80165e:	e8 39 fd ff ff       	call   80139c <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80166b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	52                   	push   %edx
  801678:	50                   	push   %eax
  801679:	6a 1b                	push   $0x1b
  80167b:	e8 1c fd ff ff       	call   80139c <syscall>
  801680:	83 c4 18             	add    $0x18,%esp
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	52                   	push   %edx
  801695:	50                   	push   %eax
  801696:	6a 19                	push   $0x19
  801698:	e8 ff fc ff ff       	call   80139c <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	90                   	nop
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	52                   	push   %edx
  8016b3:	50                   	push   %eax
  8016b4:	6a 1a                	push   $0x1a
  8016b6:	e8 e1 fc ff ff       	call   80139c <syscall>
  8016bb:	83 c4 18             	add    $0x18,%esp
}
  8016be:	90                   	nop
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016cd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016d0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	6a 00                	push   $0x0
  8016d9:	51                   	push   %ecx
  8016da:	52                   	push   %edx
  8016db:	ff 75 0c             	pushl  0xc(%ebp)
  8016de:	50                   	push   %eax
  8016df:	6a 1c                	push   $0x1c
  8016e1:	e8 b6 fc ff ff       	call   80139c <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	52                   	push   %edx
  8016fb:	50                   	push   %eax
  8016fc:	6a 1d                	push   $0x1d
  8016fe:	e8 99 fc ff ff       	call   80139c <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80170b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80170e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	51                   	push   %ecx
  801719:	52                   	push   %edx
  80171a:	50                   	push   %eax
  80171b:	6a 1e                	push   $0x1e
  80171d:	e8 7a fc ff ff       	call   80139c <syscall>
  801722:	83 c4 18             	add    $0x18,%esp
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80172a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	52                   	push   %edx
  801737:	50                   	push   %eax
  801738:	6a 1f                	push   $0x1f
  80173a:	e8 5d fc ff ff       	call   80139c <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 20                	push   $0x20
  801753:	e8 44 fc ff ff       	call   80139c <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	ff 75 10             	pushl  0x10(%ebp)
  80176a:	ff 75 0c             	pushl  0xc(%ebp)
  80176d:	50                   	push   %eax
  80176e:	6a 21                	push   $0x21
  801770:	e8 27 fc ff ff       	call   80139c <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_run_env>:


void
sys_run_env(int32 envId)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	50                   	push   %eax
  801789:	6a 22                	push   $0x22
  80178b:	e8 0c fc ff ff       	call   80139c <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	90                   	nop
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	50                   	push   %eax
  8017a5:	6a 23                	push   $0x23
  8017a7:	e8 f0 fb ff ff       	call   80139c <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
}
  8017af:	90                   	nop
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017b8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017bb:	8d 50 04             	lea    0x4(%eax),%edx
  8017be:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	52                   	push   %edx
  8017c8:	50                   	push   %eax
  8017c9:	6a 24                	push   $0x24
  8017cb:	e8 cc fb ff ff       	call   80139c <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
	return result;
  8017d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017dc:	89 01                	mov    %eax,(%ecx)
  8017de:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	c9                   	leave  
  8017e5:	c2 04 00             	ret    $0x4

008017e8 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	ff 75 10             	pushl  0x10(%ebp)
  8017f2:	ff 75 0c             	pushl  0xc(%ebp)
  8017f5:	ff 75 08             	pushl  0x8(%ebp)
  8017f8:	6a 13                	push   $0x13
  8017fa:	e8 9d fb ff ff       	call   80139c <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801802:	90                   	nop
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_rcr2>:
uint32 sys_rcr2()
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 25                	push   $0x25
  801814:	e8 83 fb ff ff       	call   80139c <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 04             	sub    $0x4,%esp
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80182a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	50                   	push   %eax
  801837:	6a 26                	push   $0x26
  801839:	e8 5e fb ff ff       	call   80139c <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
	return ;
  801841:	90                   	nop
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <rsttst>:
void rsttst()
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 28                	push   $0x28
  801853:	e8 44 fb ff ff       	call   80139c <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
	return ;
  80185b:	90                   	nop
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 04             	sub    $0x4,%esp
  801864:	8b 45 14             	mov    0x14(%ebp),%eax
  801867:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80186a:	8b 55 18             	mov    0x18(%ebp),%edx
  80186d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801871:	52                   	push   %edx
  801872:	50                   	push   %eax
  801873:	ff 75 10             	pushl  0x10(%ebp)
  801876:	ff 75 0c             	pushl  0xc(%ebp)
  801879:	ff 75 08             	pushl  0x8(%ebp)
  80187c:	6a 27                	push   $0x27
  80187e:	e8 19 fb ff ff       	call   80139c <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
	return ;
  801886:	90                   	nop
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <chktst>:
void chktst(uint32 n)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	ff 75 08             	pushl  0x8(%ebp)
  801897:	6a 29                	push   $0x29
  801899:	e8 fe fa ff ff       	call   80139c <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a1:	90                   	nop
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <inctst>:

void inctst()
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 2a                	push   $0x2a
  8018b3:	e8 e4 fa ff ff       	call   80139c <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018bb:	90                   	nop
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <gettst>:
uint32 gettst()
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 2b                	push   $0x2b
  8018cd:	e8 ca fa ff ff       	call   80139c <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 2c                	push   $0x2c
  8018e9:	e8 ae fa ff ff       	call   80139c <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
  8018f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018f4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018f8:	75 07                	jne    801901 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ff:	eb 05                	jmp    801906 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801901:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 2c                	push   $0x2c
  80191a:	e8 7d fa ff ff       	call   80139c <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
  801922:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801925:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801929:	75 07                	jne    801932 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80192b:	b8 01 00 00 00       	mov    $0x1,%eax
  801930:	eb 05                	jmp    801937 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801932:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 2c                	push   $0x2c
  80194b:	e8 4c fa ff ff       	call   80139c <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
  801953:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801956:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80195a:	75 07                	jne    801963 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80195c:	b8 01 00 00 00       	mov    $0x1,%eax
  801961:	eb 05                	jmp    801968 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801963:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 2c                	push   $0x2c
  80197c:	e8 1b fa ff ff       	call   80139c <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
  801984:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801987:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80198b:	75 07                	jne    801994 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80198d:	b8 01 00 00 00       	mov    $0x1,%eax
  801992:	eb 05                	jmp    801999 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801994:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	ff 75 08             	pushl  0x8(%ebp)
  8019a9:	6a 2d                	push   $0x2d
  8019ab:	e8 ec f9 ff ff       	call   80139c <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b3:	90                   	nop
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	6a 00                	push   $0x0
  8019c8:	53                   	push   %ebx
  8019c9:	51                   	push   %ecx
  8019ca:	52                   	push   %edx
  8019cb:	50                   	push   %eax
  8019cc:	6a 2e                	push   $0x2e
  8019ce:	e8 c9 f9 ff ff       	call   80139c <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8019de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	52                   	push   %edx
  8019eb:	50                   	push   %eax
  8019ec:	6a 2f                	push   $0x2f
  8019ee:	e8 a9 f9 ff ff       	call   80139c <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8019fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801a01:	89 d0                	mov    %edx,%eax
  801a03:	c1 e0 02             	shl    $0x2,%eax
  801a06:	01 d0                	add    %edx,%eax
  801a08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a0f:	01 d0                	add    %edx,%eax
  801a11:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a18:	01 d0                	add    %edx,%eax
  801a1a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a21:	01 d0                	add    %edx,%eax
  801a23:	c1 e0 04             	shl    $0x4,%eax
  801a26:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801a29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801a30:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801a33:	83 ec 0c             	sub    $0xc,%esp
  801a36:	50                   	push   %eax
  801a37:	e8 76 fd ff ff       	call   8017b2 <sys_get_virtual_time>
  801a3c:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801a3f:	eb 41                	jmp    801a82 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801a41:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a44:	83 ec 0c             	sub    $0xc,%esp
  801a47:	50                   	push   %eax
  801a48:	e8 65 fd ff ff       	call   8017b2 <sys_get_virtual_time>
  801a4d:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801a50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a56:	29 c2                	sub    %eax,%edx
  801a58:	89 d0                	mov    %edx,%eax
  801a5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801a5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a63:	89 d1                	mov    %edx,%ecx
  801a65:	29 c1                	sub    %eax,%ecx
  801a67:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a6d:	39 c2                	cmp    %eax,%edx
  801a6f:	0f 97 c0             	seta   %al
  801a72:	0f b6 c0             	movzbl %al,%eax
  801a75:	29 c1                	sub    %eax,%ecx
  801a77:	89 c8                	mov    %ecx,%eax
  801a79:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a7c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a85:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a88:	72 b7                	jb     801a41 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a8a:	90                   	nop
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a9a:	eb 03                	jmp    801a9f <busy_wait+0x12>
  801a9c:	ff 45 fc             	incl   -0x4(%ebp)
  801a9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa2:	3b 45 08             	cmp    0x8(%ebp),%eax
  801aa5:	72 f5                	jb     801a9c <busy_wait+0xf>
	return i;
  801aa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <__udivdi3>:
  801aac:	55                   	push   %ebp
  801aad:	57                   	push   %edi
  801aae:	56                   	push   %esi
  801aaf:	53                   	push   %ebx
  801ab0:	83 ec 1c             	sub    $0x1c,%esp
  801ab3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ab7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801abb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801abf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ac3:	89 ca                	mov    %ecx,%edx
  801ac5:	89 f8                	mov    %edi,%eax
  801ac7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801acb:	85 f6                	test   %esi,%esi
  801acd:	75 2d                	jne    801afc <__udivdi3+0x50>
  801acf:	39 cf                	cmp    %ecx,%edi
  801ad1:	77 65                	ja     801b38 <__udivdi3+0x8c>
  801ad3:	89 fd                	mov    %edi,%ebp
  801ad5:	85 ff                	test   %edi,%edi
  801ad7:	75 0b                	jne    801ae4 <__udivdi3+0x38>
  801ad9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ade:	31 d2                	xor    %edx,%edx
  801ae0:	f7 f7                	div    %edi
  801ae2:	89 c5                	mov    %eax,%ebp
  801ae4:	31 d2                	xor    %edx,%edx
  801ae6:	89 c8                	mov    %ecx,%eax
  801ae8:	f7 f5                	div    %ebp
  801aea:	89 c1                	mov    %eax,%ecx
  801aec:	89 d8                	mov    %ebx,%eax
  801aee:	f7 f5                	div    %ebp
  801af0:	89 cf                	mov    %ecx,%edi
  801af2:	89 fa                	mov    %edi,%edx
  801af4:	83 c4 1c             	add    $0x1c,%esp
  801af7:	5b                   	pop    %ebx
  801af8:	5e                   	pop    %esi
  801af9:	5f                   	pop    %edi
  801afa:	5d                   	pop    %ebp
  801afb:	c3                   	ret    
  801afc:	39 ce                	cmp    %ecx,%esi
  801afe:	77 28                	ja     801b28 <__udivdi3+0x7c>
  801b00:	0f bd fe             	bsr    %esi,%edi
  801b03:	83 f7 1f             	xor    $0x1f,%edi
  801b06:	75 40                	jne    801b48 <__udivdi3+0x9c>
  801b08:	39 ce                	cmp    %ecx,%esi
  801b0a:	72 0a                	jb     801b16 <__udivdi3+0x6a>
  801b0c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b10:	0f 87 9e 00 00 00    	ja     801bb4 <__udivdi3+0x108>
  801b16:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1b:	89 fa                	mov    %edi,%edx
  801b1d:	83 c4 1c             	add    $0x1c,%esp
  801b20:	5b                   	pop    %ebx
  801b21:	5e                   	pop    %esi
  801b22:	5f                   	pop    %edi
  801b23:	5d                   	pop    %ebp
  801b24:	c3                   	ret    
  801b25:	8d 76 00             	lea    0x0(%esi),%esi
  801b28:	31 ff                	xor    %edi,%edi
  801b2a:	31 c0                	xor    %eax,%eax
  801b2c:	89 fa                	mov    %edi,%edx
  801b2e:	83 c4 1c             	add    $0x1c,%esp
  801b31:	5b                   	pop    %ebx
  801b32:	5e                   	pop    %esi
  801b33:	5f                   	pop    %edi
  801b34:	5d                   	pop    %ebp
  801b35:	c3                   	ret    
  801b36:	66 90                	xchg   %ax,%ax
  801b38:	89 d8                	mov    %ebx,%eax
  801b3a:	f7 f7                	div    %edi
  801b3c:	31 ff                	xor    %edi,%edi
  801b3e:	89 fa                	mov    %edi,%edx
  801b40:	83 c4 1c             	add    $0x1c,%esp
  801b43:	5b                   	pop    %ebx
  801b44:	5e                   	pop    %esi
  801b45:	5f                   	pop    %edi
  801b46:	5d                   	pop    %ebp
  801b47:	c3                   	ret    
  801b48:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b4d:	89 eb                	mov    %ebp,%ebx
  801b4f:	29 fb                	sub    %edi,%ebx
  801b51:	89 f9                	mov    %edi,%ecx
  801b53:	d3 e6                	shl    %cl,%esi
  801b55:	89 c5                	mov    %eax,%ebp
  801b57:	88 d9                	mov    %bl,%cl
  801b59:	d3 ed                	shr    %cl,%ebp
  801b5b:	89 e9                	mov    %ebp,%ecx
  801b5d:	09 f1                	or     %esi,%ecx
  801b5f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b63:	89 f9                	mov    %edi,%ecx
  801b65:	d3 e0                	shl    %cl,%eax
  801b67:	89 c5                	mov    %eax,%ebp
  801b69:	89 d6                	mov    %edx,%esi
  801b6b:	88 d9                	mov    %bl,%cl
  801b6d:	d3 ee                	shr    %cl,%esi
  801b6f:	89 f9                	mov    %edi,%ecx
  801b71:	d3 e2                	shl    %cl,%edx
  801b73:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b77:	88 d9                	mov    %bl,%cl
  801b79:	d3 e8                	shr    %cl,%eax
  801b7b:	09 c2                	or     %eax,%edx
  801b7d:	89 d0                	mov    %edx,%eax
  801b7f:	89 f2                	mov    %esi,%edx
  801b81:	f7 74 24 0c          	divl   0xc(%esp)
  801b85:	89 d6                	mov    %edx,%esi
  801b87:	89 c3                	mov    %eax,%ebx
  801b89:	f7 e5                	mul    %ebp
  801b8b:	39 d6                	cmp    %edx,%esi
  801b8d:	72 19                	jb     801ba8 <__udivdi3+0xfc>
  801b8f:	74 0b                	je     801b9c <__udivdi3+0xf0>
  801b91:	89 d8                	mov    %ebx,%eax
  801b93:	31 ff                	xor    %edi,%edi
  801b95:	e9 58 ff ff ff       	jmp    801af2 <__udivdi3+0x46>
  801b9a:	66 90                	xchg   %ax,%ax
  801b9c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ba0:	89 f9                	mov    %edi,%ecx
  801ba2:	d3 e2                	shl    %cl,%edx
  801ba4:	39 c2                	cmp    %eax,%edx
  801ba6:	73 e9                	jae    801b91 <__udivdi3+0xe5>
  801ba8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bab:	31 ff                	xor    %edi,%edi
  801bad:	e9 40 ff ff ff       	jmp    801af2 <__udivdi3+0x46>
  801bb2:	66 90                	xchg   %ax,%ax
  801bb4:	31 c0                	xor    %eax,%eax
  801bb6:	e9 37 ff ff ff       	jmp    801af2 <__udivdi3+0x46>
  801bbb:	90                   	nop

00801bbc <__umoddi3>:
  801bbc:	55                   	push   %ebp
  801bbd:	57                   	push   %edi
  801bbe:	56                   	push   %esi
  801bbf:	53                   	push   %ebx
  801bc0:	83 ec 1c             	sub    $0x1c,%esp
  801bc3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bc7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bcb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bcf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bd3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bd7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bdb:	89 f3                	mov    %esi,%ebx
  801bdd:	89 fa                	mov    %edi,%edx
  801bdf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801be3:	89 34 24             	mov    %esi,(%esp)
  801be6:	85 c0                	test   %eax,%eax
  801be8:	75 1a                	jne    801c04 <__umoddi3+0x48>
  801bea:	39 f7                	cmp    %esi,%edi
  801bec:	0f 86 a2 00 00 00    	jbe    801c94 <__umoddi3+0xd8>
  801bf2:	89 c8                	mov    %ecx,%eax
  801bf4:	89 f2                	mov    %esi,%edx
  801bf6:	f7 f7                	div    %edi
  801bf8:	89 d0                	mov    %edx,%eax
  801bfa:	31 d2                	xor    %edx,%edx
  801bfc:	83 c4 1c             	add    $0x1c,%esp
  801bff:	5b                   	pop    %ebx
  801c00:	5e                   	pop    %esi
  801c01:	5f                   	pop    %edi
  801c02:	5d                   	pop    %ebp
  801c03:	c3                   	ret    
  801c04:	39 f0                	cmp    %esi,%eax
  801c06:	0f 87 ac 00 00 00    	ja     801cb8 <__umoddi3+0xfc>
  801c0c:	0f bd e8             	bsr    %eax,%ebp
  801c0f:	83 f5 1f             	xor    $0x1f,%ebp
  801c12:	0f 84 ac 00 00 00    	je     801cc4 <__umoddi3+0x108>
  801c18:	bf 20 00 00 00       	mov    $0x20,%edi
  801c1d:	29 ef                	sub    %ebp,%edi
  801c1f:	89 fe                	mov    %edi,%esi
  801c21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c25:	89 e9                	mov    %ebp,%ecx
  801c27:	d3 e0                	shl    %cl,%eax
  801c29:	89 d7                	mov    %edx,%edi
  801c2b:	89 f1                	mov    %esi,%ecx
  801c2d:	d3 ef                	shr    %cl,%edi
  801c2f:	09 c7                	or     %eax,%edi
  801c31:	89 e9                	mov    %ebp,%ecx
  801c33:	d3 e2                	shl    %cl,%edx
  801c35:	89 14 24             	mov    %edx,(%esp)
  801c38:	89 d8                	mov    %ebx,%eax
  801c3a:	d3 e0                	shl    %cl,%eax
  801c3c:	89 c2                	mov    %eax,%edx
  801c3e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c42:	d3 e0                	shl    %cl,%eax
  801c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c48:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c4c:	89 f1                	mov    %esi,%ecx
  801c4e:	d3 e8                	shr    %cl,%eax
  801c50:	09 d0                	or     %edx,%eax
  801c52:	d3 eb                	shr    %cl,%ebx
  801c54:	89 da                	mov    %ebx,%edx
  801c56:	f7 f7                	div    %edi
  801c58:	89 d3                	mov    %edx,%ebx
  801c5a:	f7 24 24             	mull   (%esp)
  801c5d:	89 c6                	mov    %eax,%esi
  801c5f:	89 d1                	mov    %edx,%ecx
  801c61:	39 d3                	cmp    %edx,%ebx
  801c63:	0f 82 87 00 00 00    	jb     801cf0 <__umoddi3+0x134>
  801c69:	0f 84 91 00 00 00    	je     801d00 <__umoddi3+0x144>
  801c6f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c73:	29 f2                	sub    %esi,%edx
  801c75:	19 cb                	sbb    %ecx,%ebx
  801c77:	89 d8                	mov    %ebx,%eax
  801c79:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c7d:	d3 e0                	shl    %cl,%eax
  801c7f:	89 e9                	mov    %ebp,%ecx
  801c81:	d3 ea                	shr    %cl,%edx
  801c83:	09 d0                	or     %edx,%eax
  801c85:	89 e9                	mov    %ebp,%ecx
  801c87:	d3 eb                	shr    %cl,%ebx
  801c89:	89 da                	mov    %ebx,%edx
  801c8b:	83 c4 1c             	add    $0x1c,%esp
  801c8e:	5b                   	pop    %ebx
  801c8f:	5e                   	pop    %esi
  801c90:	5f                   	pop    %edi
  801c91:	5d                   	pop    %ebp
  801c92:	c3                   	ret    
  801c93:	90                   	nop
  801c94:	89 fd                	mov    %edi,%ebp
  801c96:	85 ff                	test   %edi,%edi
  801c98:	75 0b                	jne    801ca5 <__umoddi3+0xe9>
  801c9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9f:	31 d2                	xor    %edx,%edx
  801ca1:	f7 f7                	div    %edi
  801ca3:	89 c5                	mov    %eax,%ebp
  801ca5:	89 f0                	mov    %esi,%eax
  801ca7:	31 d2                	xor    %edx,%edx
  801ca9:	f7 f5                	div    %ebp
  801cab:	89 c8                	mov    %ecx,%eax
  801cad:	f7 f5                	div    %ebp
  801caf:	89 d0                	mov    %edx,%eax
  801cb1:	e9 44 ff ff ff       	jmp    801bfa <__umoddi3+0x3e>
  801cb6:	66 90                	xchg   %ax,%ax
  801cb8:	89 c8                	mov    %ecx,%eax
  801cba:	89 f2                	mov    %esi,%edx
  801cbc:	83 c4 1c             	add    $0x1c,%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5f                   	pop    %edi
  801cc2:	5d                   	pop    %ebp
  801cc3:	c3                   	ret    
  801cc4:	3b 04 24             	cmp    (%esp),%eax
  801cc7:	72 06                	jb     801ccf <__umoddi3+0x113>
  801cc9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ccd:	77 0f                	ja     801cde <__umoddi3+0x122>
  801ccf:	89 f2                	mov    %esi,%edx
  801cd1:	29 f9                	sub    %edi,%ecx
  801cd3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cd7:	89 14 24             	mov    %edx,(%esp)
  801cda:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cde:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ce2:	8b 14 24             	mov    (%esp),%edx
  801ce5:	83 c4 1c             	add    $0x1c,%esp
  801ce8:	5b                   	pop    %ebx
  801ce9:	5e                   	pop    %esi
  801cea:	5f                   	pop    %edi
  801ceb:	5d                   	pop    %ebp
  801cec:	c3                   	ret    
  801ced:	8d 76 00             	lea    0x0(%esi),%esi
  801cf0:	2b 04 24             	sub    (%esp),%eax
  801cf3:	19 fa                	sbb    %edi,%edx
  801cf5:	89 d1                	mov    %edx,%ecx
  801cf7:	89 c6                	mov    %eax,%esi
  801cf9:	e9 71 ff ff ff       	jmp    801c6f <__umoddi3+0xb3>
  801cfe:	66 90                	xchg   %ax,%ax
  801d00:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d04:	72 ea                	jb     801cf0 <__umoddi3+0x134>
  801d06:	89 d9                	mov    %ebx,%ecx
  801d08:	e9 62 ff ff ff       	jmp    801c6f <__umoddi3+0xb3>
