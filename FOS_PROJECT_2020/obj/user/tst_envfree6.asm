
obj/user/tst_envfree6:     file format elf32-i386


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
  800031:	e8 4a 01 00 00       	call   800180 <libmain>
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
	// Testing scenario 6: Semaphores & shared variables
	// Testing removing the shared variables and semaphores
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 20 1d 80 00       	push   $0x801d20
  80004a:	e8 bc 12 00 00       	call   80130b <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 a2 14 00 00       	call   801505 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 1d 15 00 00       	call   801588 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 1d 80 00       	push   $0x801d30
  800079:	e8 e9 04 00 00       	call   800567 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000,50);
  800081:	83 ec 04             	sub    $0x4,%esp
  800084:	6a 32                	push   $0x32
  800086:	68 d0 07 00 00       	push   $0x7d0
  80008b:	68 63 1d 80 00       	push   $0x801d63
  800090:	e8 c5 16 00 00       	call   80175a <sys_create_env>
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", 20, 50);
  80009b:	83 ec 04             	sub    $0x4,%esp
  80009e:	6a 32                	push   $0x32
  8000a0:	6a 14                	push   $0x14
  8000a2:	68 6c 1d 80 00       	push   $0x801d6c
  8000a7:	e8 ae 16 00 00       	call   80175a <sys_create_env>
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b8:	e8 ba 16 00 00       	call   801777 <sys_run_env>
  8000bd:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	68 10 27 00 00       	push   $0x2710
  8000c8:	e8 28 19 00 00       	call   8019f5 <env_sleep>
  8000cd:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d6:	e8 9c 16 00 00       	call   801777 <sys_run_env>
  8000db:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000de:	90                   	nop
  8000df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e2:	8b 00                	mov    (%eax),%eax
  8000e4:	83 f8 02             	cmp    $0x2,%eax
  8000e7:	75 f6                	jne    8000df <_main+0xa7>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000e9:	e8 17 14 00 00       	call   801505 <sys_calculate_free_frames>
  8000ee:	83 ec 08             	sub    $0x8,%esp
  8000f1:	50                   	push   %eax
  8000f2:	68 78 1d 80 00       	push   $0x801d78
  8000f7:	e8 6b 04 00 00       	call   800567 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp

	sys_free_env(envIdProcessA);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	ff 75 e8             	pushl  -0x18(%ebp)
  800105:	e8 89 16 00 00       	call   801793 <sys_free_env>
  80010a:	83 c4 10             	add    $0x10,%esp
	sys_free_env(envIdProcessB);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	ff 75 e4             	pushl  -0x1c(%ebp)
  800113:	e8 7b 16 00 00       	call   801793 <sys_free_env>
  800118:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011b:	e8 e5 13 00 00       	call   801505 <sys_calculate_free_frames>
  800120:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800123:	e8 60 14 00 00       	call   801588 <sys_pf_calculate_allocated_pages>
  800128:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800131:	74 27                	je     80015a <_main+0x122>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800133:	83 ec 08             	sub    $0x8,%esp
  800136:	ff 75 e0             	pushl  -0x20(%ebp)
  800139:	68 ac 1d 80 00       	push   $0x801dac
  80013e:	e8 24 04 00 00       	call   800567 <cprintf>
  800143:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	68 fc 1d 80 00       	push   $0x801dfc
  80014e:	6a 23                	push   $0x23
  800150:	68 32 1e 80 00       	push   $0x801e32
  800155:	e8 6b 01 00 00       	call   8002c5 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015a:	83 ec 08             	sub    $0x8,%esp
  80015d:	ff 75 e0             	pushl  -0x20(%ebp)
  800160:	68 48 1e 80 00       	push   $0x801e48
  800165:	e8 fd 03 00 00       	call   800567 <cprintf>
  80016a:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	68 a8 1e 80 00       	push   $0x801ea8
  800175:	e8 ed 03 00 00       	call   800567 <cprintf>
  80017a:	83 c4 10             	add    $0x10,%esp
	return;
  80017d:	90                   	nop
}
  80017e:	c9                   	leave  
  80017f:	c3                   	ret    

00800180 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800186:	e8 af 12 00 00       	call   80143a <sys_getenvindex>
  80018b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80018e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800191:	89 d0                	mov    %edx,%eax
  800193:	c1 e0 03             	shl    $0x3,%eax
  800196:	01 d0                	add    %edx,%eax
  800198:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80019f:	01 c8                	add    %ecx,%eax
  8001a1:	01 c0                	add    %eax,%eax
  8001a3:	01 d0                	add    %edx,%eax
  8001a5:	01 c0                	add    %eax,%eax
  8001a7:	01 d0                	add    %edx,%eax
  8001a9:	89 c2                	mov    %eax,%edx
  8001ab:	c1 e2 05             	shl    $0x5,%edx
  8001ae:	29 c2                	sub    %eax,%edx
  8001b0:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001b7:	89 c2                	mov    %eax,%edx
  8001b9:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001bf:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c9:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001cf:	84 c0                	test   %al,%al
  8001d1:	74 0f                	je     8001e2 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d8:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001dd:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e6:	7e 0a                	jle    8001f2 <libmain+0x72>
		binaryname = argv[0];
  8001e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001eb:	8b 00                	mov    (%eax),%eax
  8001ed:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 38 fe ff ff       	call   800038 <_main>
  800200:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800203:	e8 cd 13 00 00       	call   8015d5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	68 0c 1f 80 00       	push   $0x801f0c
  800210:	e8 52 03 00 00       	call   800567 <cprintf>
  800215:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800218:	a1 20 30 80 00       	mov    0x803020,%eax
  80021d:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800223:	a1 20 30 80 00       	mov    0x803020,%eax
  800228:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	52                   	push   %edx
  800232:	50                   	push   %eax
  800233:	68 34 1f 80 00       	push   $0x801f34
  800238:	e8 2a 03 00 00       	call   800567 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800240:	a1 20 30 80 00       	mov    0x803020,%eax
  800245:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80024b:	a1 20 30 80 00       	mov    0x803020,%eax
  800250:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	52                   	push   %edx
  80025a:	50                   	push   %eax
  80025b:	68 5c 1f 80 00       	push   $0x801f5c
  800260:	e8 02 03 00 00       	call   800567 <cprintf>
  800265:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800268:	a1 20 30 80 00       	mov    0x803020,%eax
  80026d:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800273:	83 ec 08             	sub    $0x8,%esp
  800276:	50                   	push   %eax
  800277:	68 9d 1f 80 00       	push   $0x801f9d
  80027c:	e8 e6 02 00 00       	call   800567 <cprintf>
  800281:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800284:	83 ec 0c             	sub    $0xc,%esp
  800287:	68 0c 1f 80 00       	push   $0x801f0c
  80028c:	e8 d6 02 00 00       	call   800567 <cprintf>
  800291:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800294:	e8 56 13 00 00       	call   8015ef <sys_enable_interrupt>

	// exit gracefully
	exit();
  800299:	e8 19 00 00 00       	call   8002b7 <exit>
}
  80029e:	90                   	nop
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	6a 00                	push   $0x0
  8002ac:	e8 55 11 00 00       	call   801406 <sys_env_destroy>
  8002b1:	83 c4 10             	add    $0x10,%esp
}
  8002b4:	90                   	nop
  8002b5:	c9                   	leave  
  8002b6:	c3                   	ret    

008002b7 <exit>:

void
exit(void)
{
  8002b7:	55                   	push   %ebp
  8002b8:	89 e5                	mov    %esp,%ebp
  8002ba:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002bd:	e8 aa 11 00 00       	call   80146c <sys_env_exit>
}
  8002c2:	90                   	nop
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002cb:	8d 45 10             	lea    0x10(%ebp),%eax
  8002ce:	83 c0 04             	add    $0x4,%eax
  8002d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002d4:	a1 18 31 80 00       	mov    0x803118,%eax
  8002d9:	85 c0                	test   %eax,%eax
  8002db:	74 16                	je     8002f3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002dd:	a1 18 31 80 00       	mov    0x803118,%eax
  8002e2:	83 ec 08             	sub    $0x8,%esp
  8002e5:	50                   	push   %eax
  8002e6:	68 b4 1f 80 00       	push   $0x801fb4
  8002eb:	e8 77 02 00 00       	call   800567 <cprintf>
  8002f0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002f3:	a1 00 30 80 00       	mov    0x803000,%eax
  8002f8:	ff 75 0c             	pushl  0xc(%ebp)
  8002fb:	ff 75 08             	pushl  0x8(%ebp)
  8002fe:	50                   	push   %eax
  8002ff:	68 b9 1f 80 00       	push   $0x801fb9
  800304:	e8 5e 02 00 00       	call   800567 <cprintf>
  800309:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80030c:	8b 45 10             	mov    0x10(%ebp),%eax
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	ff 75 f4             	pushl  -0xc(%ebp)
  800315:	50                   	push   %eax
  800316:	e8 e1 01 00 00       	call   8004fc <vcprintf>
  80031b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80031e:	83 ec 08             	sub    $0x8,%esp
  800321:	6a 00                	push   $0x0
  800323:	68 d5 1f 80 00       	push   $0x801fd5
  800328:	e8 cf 01 00 00       	call   8004fc <vcprintf>
  80032d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800330:	e8 82 ff ff ff       	call   8002b7 <exit>

	// should not return here
	while (1) ;
  800335:	eb fe                	jmp    800335 <_panic+0x70>

00800337 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80033d:	a1 20 30 80 00       	mov    0x803020,%eax
  800342:	8b 50 74             	mov    0x74(%eax),%edx
  800345:	8b 45 0c             	mov    0xc(%ebp),%eax
  800348:	39 c2                	cmp    %eax,%edx
  80034a:	74 14                	je     800360 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80034c:	83 ec 04             	sub    $0x4,%esp
  80034f:	68 d8 1f 80 00       	push   $0x801fd8
  800354:	6a 26                	push   $0x26
  800356:	68 24 20 80 00       	push   $0x802024
  80035b:	e8 65 ff ff ff       	call   8002c5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800360:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800367:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036e:	e9 b6 00 00 00       	jmp    800429 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800376:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80037d:	8b 45 08             	mov    0x8(%ebp),%eax
  800380:	01 d0                	add    %edx,%eax
  800382:	8b 00                	mov    (%eax),%eax
  800384:	85 c0                	test   %eax,%eax
  800386:	75 08                	jne    800390 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800388:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80038b:	e9 96 00 00 00       	jmp    800426 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800390:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800397:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80039e:	eb 5d                	jmp    8003fd <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a5:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ae:	c1 e2 04             	shl    $0x4,%edx
  8003b1:	01 d0                	add    %edx,%eax
  8003b3:	8a 40 04             	mov    0x4(%eax),%al
  8003b6:	84 c0                	test   %al,%al
  8003b8:	75 40                	jne    8003fa <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8003bf:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003c8:	c1 e2 04             	shl    $0x4,%edx
  8003cb:	01 d0                	add    %edx,%eax
  8003cd:	8b 00                	mov    (%eax),%eax
  8003cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003da:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003df:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e9:	01 c8                	add    %ecx,%eax
  8003eb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ed:	39 c2                	cmp    %eax,%edx
  8003ef:	75 09                	jne    8003fa <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8003f1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003f8:	eb 12                	jmp    80040c <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fa:	ff 45 e8             	incl   -0x18(%ebp)
  8003fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800402:	8b 50 74             	mov    0x74(%eax),%edx
  800405:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800408:	39 c2                	cmp    %eax,%edx
  80040a:	77 94                	ja     8003a0 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80040c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800410:	75 14                	jne    800426 <CheckWSWithoutLastIndex+0xef>
			panic(
  800412:	83 ec 04             	sub    $0x4,%esp
  800415:	68 30 20 80 00       	push   $0x802030
  80041a:	6a 3a                	push   $0x3a
  80041c:	68 24 20 80 00       	push   $0x802024
  800421:	e8 9f fe ff ff       	call   8002c5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800426:	ff 45 f0             	incl   -0x10(%ebp)
  800429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042f:	0f 8c 3e ff ff ff    	jl     800373 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800435:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800443:	eb 20                	jmp    800465 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800445:	a1 20 30 80 00       	mov    0x803020,%eax
  80044a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800450:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800453:	c1 e2 04             	shl    $0x4,%edx
  800456:	01 d0                	add    %edx,%eax
  800458:	8a 40 04             	mov    0x4(%eax),%al
  80045b:	3c 01                	cmp    $0x1,%al
  80045d:	75 03                	jne    800462 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80045f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800462:	ff 45 e0             	incl   -0x20(%ebp)
  800465:	a1 20 30 80 00       	mov    0x803020,%eax
  80046a:	8b 50 74             	mov    0x74(%eax),%edx
  80046d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800470:	39 c2                	cmp    %eax,%edx
  800472:	77 d1                	ja     800445 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800477:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047a:	74 14                	je     800490 <CheckWSWithoutLastIndex+0x159>
		panic(
  80047c:	83 ec 04             	sub    $0x4,%esp
  80047f:	68 84 20 80 00       	push   $0x802084
  800484:	6a 44                	push   $0x44
  800486:	68 24 20 80 00       	push   $0x802024
  80048b:	e8 35 fe ff ff       	call   8002c5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800490:	90                   	nop
  800491:	c9                   	leave  
  800492:	c3                   	ret    

00800493 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800493:	55                   	push   %ebp
  800494:	89 e5                	mov    %esp,%ebp
  800496:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a4:	89 0a                	mov    %ecx,(%edx)
  8004a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a9:	88 d1                	mov    %dl,%cl
  8004ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ae:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bc:	75 2c                	jne    8004ea <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004be:	a0 24 30 80 00       	mov    0x803024,%al
  8004c3:	0f b6 c0             	movzbl %al,%eax
  8004c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c9:	8b 12                	mov    (%edx),%edx
  8004cb:	89 d1                	mov    %edx,%ecx
  8004cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d0:	83 c2 08             	add    $0x8,%edx
  8004d3:	83 ec 04             	sub    $0x4,%esp
  8004d6:	50                   	push   %eax
  8004d7:	51                   	push   %ecx
  8004d8:	52                   	push   %edx
  8004d9:	e8 e6 0e 00 00       	call   8013c4 <sys_cputs>
  8004de:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ed:	8b 40 04             	mov    0x4(%eax),%eax
  8004f0:	8d 50 01             	lea    0x1(%eax),%edx
  8004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004f9:	90                   	nop
  8004fa:	c9                   	leave  
  8004fb:	c3                   	ret    

008004fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004fc:	55                   	push   %ebp
  8004fd:	89 e5                	mov    %esp,%ebp
  8004ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800505:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050c:	00 00 00 
	b.cnt = 0;
  80050f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800516:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800519:	ff 75 0c             	pushl  0xc(%ebp)
  80051c:	ff 75 08             	pushl  0x8(%ebp)
  80051f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800525:	50                   	push   %eax
  800526:	68 93 04 80 00       	push   $0x800493
  80052b:	e8 11 02 00 00       	call   800741 <vprintfmt>
  800530:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800533:	a0 24 30 80 00       	mov    0x803024,%al
  800538:	0f b6 c0             	movzbl %al,%eax
  80053b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800541:	83 ec 04             	sub    $0x4,%esp
  800544:	50                   	push   %eax
  800545:	52                   	push   %edx
  800546:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054c:	83 c0 08             	add    $0x8,%eax
  80054f:	50                   	push   %eax
  800550:	e8 6f 0e 00 00       	call   8013c4 <sys_cputs>
  800555:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800558:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80055f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800565:	c9                   	leave  
  800566:	c3                   	ret    

00800567 <cprintf>:

int cprintf(const char *fmt, ...) {
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056d:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800574:	8d 45 0c             	lea    0xc(%ebp),%eax
  800577:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80057a:	8b 45 08             	mov    0x8(%ebp),%eax
  80057d:	83 ec 08             	sub    $0x8,%esp
  800580:	ff 75 f4             	pushl  -0xc(%ebp)
  800583:	50                   	push   %eax
  800584:	e8 73 ff ff ff       	call   8004fc <vcprintf>
  800589:	83 c4 10             	add    $0x10,%esp
  80058c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80058f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800592:	c9                   	leave  
  800593:	c3                   	ret    

00800594 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80059a:	e8 36 10 00 00       	call   8015d5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80059f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ae:	50                   	push   %eax
  8005af:	e8 48 ff ff ff       	call   8004fc <vcprintf>
  8005b4:	83 c4 10             	add    $0x10,%esp
  8005b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005ba:	e8 30 10 00 00       	call   8015ef <sys_enable_interrupt>
	return cnt;
  8005bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c2:	c9                   	leave  
  8005c3:	c3                   	ret    

008005c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	53                   	push   %ebx
  8005c8:	83 ec 14             	sub    $0x14,%esp
  8005cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005da:	ba 00 00 00 00       	mov    $0x0,%edx
  8005df:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e2:	77 55                	ja     800639 <printnum+0x75>
  8005e4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e7:	72 05                	jb     8005ee <printnum+0x2a>
  8005e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ec:	77 4b                	ja     800639 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ee:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fc:	52                   	push   %edx
  8005fd:	50                   	push   %eax
  8005fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800601:	ff 75 f0             	pushl  -0x10(%ebp)
  800604:	e8 a3 14 00 00       	call   801aac <__udivdi3>
  800609:	83 c4 10             	add    $0x10,%esp
  80060c:	83 ec 04             	sub    $0x4,%esp
  80060f:	ff 75 20             	pushl  0x20(%ebp)
  800612:	53                   	push   %ebx
  800613:	ff 75 18             	pushl  0x18(%ebp)
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	ff 75 0c             	pushl  0xc(%ebp)
  80061b:	ff 75 08             	pushl  0x8(%ebp)
  80061e:	e8 a1 ff ff ff       	call   8005c4 <printnum>
  800623:	83 c4 20             	add    $0x20,%esp
  800626:	eb 1a                	jmp    800642 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	ff 75 0c             	pushl  0xc(%ebp)
  80062e:	ff 75 20             	pushl  0x20(%ebp)
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	ff d0                	call   *%eax
  800636:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800639:	ff 4d 1c             	decl   0x1c(%ebp)
  80063c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800640:	7f e6                	jg     800628 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800642:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800645:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800650:	53                   	push   %ebx
  800651:	51                   	push   %ecx
  800652:	52                   	push   %edx
  800653:	50                   	push   %eax
  800654:	e8 63 15 00 00       	call   801bbc <__umoddi3>
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	05 f4 22 80 00       	add    $0x8022f4,%eax
  800661:	8a 00                	mov    (%eax),%al
  800663:	0f be c0             	movsbl %al,%eax
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	ff 75 0c             	pushl  0xc(%ebp)
  80066c:	50                   	push   %eax
  80066d:	8b 45 08             	mov    0x8(%ebp),%eax
  800670:	ff d0                	call   *%eax
  800672:	83 c4 10             	add    $0x10,%esp
}
  800675:	90                   	nop
  800676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800679:	c9                   	leave  
  80067a:	c3                   	ret    

0080067b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067b:	55                   	push   %ebp
  80067c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800682:	7e 1c                	jle    8006a0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	8d 50 08             	lea    0x8(%eax),%edx
  80068c:	8b 45 08             	mov    0x8(%ebp),%eax
  80068f:	89 10                	mov    %edx,(%eax)
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	8b 00                	mov    (%eax),%eax
  800696:	83 e8 08             	sub    $0x8,%eax
  800699:	8b 50 04             	mov    0x4(%eax),%edx
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	eb 40                	jmp    8006e0 <getuint+0x65>
	else if (lflag)
  8006a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a4:	74 1e                	je     8006c4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	8d 50 04             	lea    0x4(%eax),%edx
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	89 10                	mov    %edx,(%eax)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	83 e8 04             	sub    $0x4,%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c2:	eb 1c                	jmp    8006e0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	8d 50 04             	lea    0x4(%eax),%edx
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	89 10                	mov    %edx,(%eax)
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	83 e8 04             	sub    $0x4,%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e0:	5d                   	pop    %ebp
  8006e1:	c3                   	ret    

008006e2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e2:	55                   	push   %ebp
  8006e3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e9:	7e 1c                	jle    800707 <getint+0x25>
		return va_arg(*ap, long long);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 08             	lea    0x8(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 08             	sub    $0x8,%eax
  800700:	8b 50 04             	mov    0x4(%eax),%edx
  800703:	8b 00                	mov    (%eax),%eax
  800705:	eb 38                	jmp    80073f <getint+0x5d>
	else if (lflag)
  800707:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070b:	74 1a                	je     800727 <getint+0x45>
		return va_arg(*ap, long);
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	8d 50 04             	lea    0x4(%eax),%edx
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	89 10                	mov    %edx,(%eax)
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	83 e8 04             	sub    $0x4,%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	99                   	cltd   
  800725:	eb 18                	jmp    80073f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	8d 50 04             	lea    0x4(%eax),%edx
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	89 10                	mov    %edx,(%eax)
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	8b 00                	mov    (%eax),%eax
  800739:	83 e8 04             	sub    $0x4,%eax
  80073c:	8b 00                	mov    (%eax),%eax
  80073e:	99                   	cltd   
}
  80073f:	5d                   	pop    %ebp
  800740:	c3                   	ret    

00800741 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	56                   	push   %esi
  800745:	53                   	push   %ebx
  800746:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800749:	eb 17                	jmp    800762 <vprintfmt+0x21>
			if (ch == '\0')
  80074b:	85 db                	test   %ebx,%ebx
  80074d:	0f 84 af 03 00 00    	je     800b02 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	53                   	push   %ebx
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	ff d0                	call   *%eax
  80075f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800762:	8b 45 10             	mov    0x10(%ebp),%eax
  800765:	8d 50 01             	lea    0x1(%eax),%edx
  800768:	89 55 10             	mov    %edx,0x10(%ebp)
  80076b:	8a 00                	mov    (%eax),%al
  80076d:	0f b6 d8             	movzbl %al,%ebx
  800770:	83 fb 25             	cmp    $0x25,%ebx
  800773:	75 d6                	jne    80074b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800775:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800779:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800780:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800787:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80078e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800795:	8b 45 10             	mov    0x10(%ebp),%eax
  800798:	8d 50 01             	lea    0x1(%eax),%edx
  80079b:	89 55 10             	mov    %edx,0x10(%ebp)
  80079e:	8a 00                	mov    (%eax),%al
  8007a0:	0f b6 d8             	movzbl %al,%ebx
  8007a3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a6:	83 f8 55             	cmp    $0x55,%eax
  8007a9:	0f 87 2b 03 00 00    	ja     800ada <vprintfmt+0x399>
  8007af:	8b 04 85 18 23 80 00 	mov    0x802318(,%eax,4),%eax
  8007b6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bc:	eb d7                	jmp    800795 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007be:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c2:	eb d1                	jmp    800795 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ce:	89 d0                	mov    %edx,%eax
  8007d0:	c1 e0 02             	shl    $0x2,%eax
  8007d3:	01 d0                	add    %edx,%eax
  8007d5:	01 c0                	add    %eax,%eax
  8007d7:	01 d8                	add    %ebx,%eax
  8007d9:	83 e8 30             	sub    $0x30,%eax
  8007dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007df:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e2:	8a 00                	mov    (%eax),%al
  8007e4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e7:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ea:	7e 3e                	jle    80082a <vprintfmt+0xe9>
  8007ec:	83 fb 39             	cmp    $0x39,%ebx
  8007ef:	7f 39                	jg     80082a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f4:	eb d5                	jmp    8007cb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	83 c0 04             	add    $0x4,%eax
  8007fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	83 e8 04             	sub    $0x4,%eax
  800805:	8b 00                	mov    (%eax),%eax
  800807:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080a:	eb 1f                	jmp    80082b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800810:	79 83                	jns    800795 <vprintfmt+0x54>
				width = 0;
  800812:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800819:	e9 77 ff ff ff       	jmp    800795 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80081e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800825:	e9 6b ff ff ff       	jmp    800795 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082f:	0f 89 60 ff ff ff    	jns    800795 <vprintfmt+0x54>
				width = precision, precision = -1;
  800835:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800838:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800842:	e9 4e ff ff ff       	jmp    800795 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800847:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084a:	e9 46 ff ff ff       	jmp    800795 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	83 c0 04             	add    $0x4,%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	83 e8 04             	sub    $0x4,%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	83 ec 08             	sub    $0x8,%esp
  800863:	ff 75 0c             	pushl  0xc(%ebp)
  800866:	50                   	push   %eax
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	ff d0                	call   *%eax
  80086c:	83 c4 10             	add    $0x10,%esp
			break;
  80086f:	e9 89 02 00 00       	jmp    800afd <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	83 c0 04             	add    $0x4,%eax
  80087a:	89 45 14             	mov    %eax,0x14(%ebp)
  80087d:	8b 45 14             	mov    0x14(%ebp),%eax
  800880:	83 e8 04             	sub    $0x4,%eax
  800883:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800885:	85 db                	test   %ebx,%ebx
  800887:	79 02                	jns    80088b <vprintfmt+0x14a>
				err = -err;
  800889:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088b:	83 fb 64             	cmp    $0x64,%ebx
  80088e:	7f 0b                	jg     80089b <vprintfmt+0x15a>
  800890:	8b 34 9d 60 21 80 00 	mov    0x802160(,%ebx,4),%esi
  800897:	85 f6                	test   %esi,%esi
  800899:	75 19                	jne    8008b4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089b:	53                   	push   %ebx
  80089c:	68 05 23 80 00       	push   $0x802305
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	ff 75 08             	pushl  0x8(%ebp)
  8008a7:	e8 5e 02 00 00       	call   800b0a <printfmt>
  8008ac:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008af:	e9 49 02 00 00       	jmp    800afd <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b4:	56                   	push   %esi
  8008b5:	68 0e 23 80 00       	push   $0x80230e
  8008ba:	ff 75 0c             	pushl  0xc(%ebp)
  8008bd:	ff 75 08             	pushl  0x8(%ebp)
  8008c0:	e8 45 02 00 00       	call   800b0a <printfmt>
  8008c5:	83 c4 10             	add    $0x10,%esp
			break;
  8008c8:	e9 30 02 00 00       	jmp    800afd <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	83 c0 04             	add    $0x4,%eax
  8008d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	83 e8 04             	sub    $0x4,%eax
  8008dc:	8b 30                	mov    (%eax),%esi
  8008de:	85 f6                	test   %esi,%esi
  8008e0:	75 05                	jne    8008e7 <vprintfmt+0x1a6>
				p = "(null)";
  8008e2:	be 11 23 80 00       	mov    $0x802311,%esi
			if (width > 0 && padc != '-')
  8008e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008eb:	7e 6d                	jle    80095a <vprintfmt+0x219>
  8008ed:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f1:	74 67                	je     80095a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	50                   	push   %eax
  8008fa:	56                   	push   %esi
  8008fb:	e8 0c 03 00 00       	call   800c0c <strnlen>
  800900:	83 c4 10             	add    $0x10,%esp
  800903:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800906:	eb 16                	jmp    80091e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800908:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	50                   	push   %eax
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	ff d0                	call   *%eax
  800918:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091b:	ff 4d e4             	decl   -0x1c(%ebp)
  80091e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800922:	7f e4                	jg     800908 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800924:	eb 34                	jmp    80095a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800926:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092a:	74 1c                	je     800948 <vprintfmt+0x207>
  80092c:	83 fb 1f             	cmp    $0x1f,%ebx
  80092f:	7e 05                	jle    800936 <vprintfmt+0x1f5>
  800931:	83 fb 7e             	cmp    $0x7e,%ebx
  800934:	7e 12                	jle    800948 <vprintfmt+0x207>
					putch('?', putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	6a 3f                	push   $0x3f
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	ff d0                	call   *%eax
  800943:	83 c4 10             	add    $0x10,%esp
  800946:	eb 0f                	jmp    800957 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	53                   	push   %ebx
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	ff d0                	call   *%eax
  800954:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800957:	ff 4d e4             	decl   -0x1c(%ebp)
  80095a:	89 f0                	mov    %esi,%eax
  80095c:	8d 70 01             	lea    0x1(%eax),%esi
  80095f:	8a 00                	mov    (%eax),%al
  800961:	0f be d8             	movsbl %al,%ebx
  800964:	85 db                	test   %ebx,%ebx
  800966:	74 24                	je     80098c <vprintfmt+0x24b>
  800968:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096c:	78 b8                	js     800926 <vprintfmt+0x1e5>
  80096e:	ff 4d e0             	decl   -0x20(%ebp)
  800971:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800975:	79 af                	jns    800926 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800977:	eb 13                	jmp    80098c <vprintfmt+0x24b>
				putch(' ', putdat);
  800979:	83 ec 08             	sub    $0x8,%esp
  80097c:	ff 75 0c             	pushl  0xc(%ebp)
  80097f:	6a 20                	push   $0x20
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	ff d0                	call   *%eax
  800986:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800989:	ff 4d e4             	decl   -0x1c(%ebp)
  80098c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800990:	7f e7                	jg     800979 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800992:	e9 66 01 00 00       	jmp    800afd <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 e8             	pushl  -0x18(%ebp)
  80099d:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a0:	50                   	push   %eax
  8009a1:	e8 3c fd ff ff       	call   8006e2 <getint>
  8009a6:	83 c4 10             	add    $0x10,%esp
  8009a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b5:	85 d2                	test   %edx,%edx
  8009b7:	79 23                	jns    8009dc <vprintfmt+0x29b>
				putch('-', putdat);
  8009b9:	83 ec 08             	sub    $0x8,%esp
  8009bc:	ff 75 0c             	pushl  0xc(%ebp)
  8009bf:	6a 2d                	push   $0x2d
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	ff d0                	call   *%eax
  8009c6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009cf:	f7 d8                	neg    %eax
  8009d1:	83 d2 00             	adc    $0x0,%edx
  8009d4:	f7 da                	neg    %edx
  8009d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009dc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e3:	e9 bc 00 00 00       	jmp    800aa4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ee:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f1:	50                   	push   %eax
  8009f2:	e8 84 fc ff ff       	call   80067b <getuint>
  8009f7:	83 c4 10             	add    $0x10,%esp
  8009fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a00:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a07:	e9 98 00 00 00       	jmp    800aa4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0c:	83 ec 08             	sub    $0x8,%esp
  800a0f:	ff 75 0c             	pushl  0xc(%ebp)
  800a12:	6a 58                	push   $0x58
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	ff d0                	call   *%eax
  800a19:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1c:	83 ec 08             	sub    $0x8,%esp
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	6a 58                	push   $0x58
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	ff d0                	call   *%eax
  800a29:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	ff 75 0c             	pushl  0xc(%ebp)
  800a32:	6a 58                	push   $0x58
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	ff d0                	call   *%eax
  800a39:	83 c4 10             	add    $0x10,%esp
			break;
  800a3c:	e9 bc 00 00 00       	jmp    800afd <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	ff 75 0c             	pushl  0xc(%ebp)
  800a47:	6a 30                	push   $0x30
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	ff d0                	call   *%eax
  800a4e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 0c             	pushl  0xc(%ebp)
  800a57:	6a 78                	push   $0x78
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	ff d0                	call   *%eax
  800a5e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a61:	8b 45 14             	mov    0x14(%ebp),%eax
  800a64:	83 c0 04             	add    $0x4,%eax
  800a67:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6d:	83 e8 04             	sub    $0x4,%eax
  800a70:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a83:	eb 1f                	jmp    800aa4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a85:	83 ec 08             	sub    $0x8,%esp
  800a88:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8e:	50                   	push   %eax
  800a8f:	e8 e7 fb ff ff       	call   80067b <getuint>
  800a94:	83 c4 10             	add    $0x10,%esp
  800a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aab:	83 ec 04             	sub    $0x4,%esp
  800aae:	52                   	push   %edx
  800aaf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab2:	50                   	push   %eax
  800ab3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab6:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	ff 75 08             	pushl  0x8(%ebp)
  800abf:	e8 00 fb ff ff       	call   8005c4 <printnum>
  800ac4:	83 c4 20             	add    $0x20,%esp
			break;
  800ac7:	eb 34                	jmp    800afd <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac9:	83 ec 08             	sub    $0x8,%esp
  800acc:	ff 75 0c             	pushl  0xc(%ebp)
  800acf:	53                   	push   %ebx
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	ff d0                	call   *%eax
  800ad5:	83 c4 10             	add    $0x10,%esp
			break;
  800ad8:	eb 23                	jmp    800afd <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	6a 25                	push   $0x25
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
  800ae7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aea:	ff 4d 10             	decl   0x10(%ebp)
  800aed:	eb 03                	jmp    800af2 <vprintfmt+0x3b1>
  800aef:	ff 4d 10             	decl   0x10(%ebp)
  800af2:	8b 45 10             	mov    0x10(%ebp),%eax
  800af5:	48                   	dec    %eax
  800af6:	8a 00                	mov    (%eax),%al
  800af8:	3c 25                	cmp    $0x25,%al
  800afa:	75 f3                	jne    800aef <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800afc:	90                   	nop
		}
	}
  800afd:	e9 47 fc ff ff       	jmp    800749 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b02:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b06:	5b                   	pop    %ebx
  800b07:	5e                   	pop    %esi
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b10:	8d 45 10             	lea    0x10(%ebp),%eax
  800b13:	83 c0 04             	add    $0x4,%eax
  800b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b19:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1f:	50                   	push   %eax
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	ff 75 08             	pushl  0x8(%ebp)
  800b26:	e8 16 fc ff ff       	call   800741 <vprintfmt>
  800b2b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b2e:	90                   	nop
  800b2f:	c9                   	leave  
  800b30:	c3                   	ret    

00800b31 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	8b 40 08             	mov    0x8(%eax),%eax
  800b3a:	8d 50 01             	lea    0x1(%eax),%edx
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8b 10                	mov    (%eax),%edx
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	8b 40 04             	mov    0x4(%eax),%eax
  800b4e:	39 c2                	cmp    %eax,%edx
  800b50:	73 12                	jae    800b64 <sprintputch+0x33>
		*b->buf++ = ch;
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 00                	mov    (%eax),%eax
  800b57:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5d:	89 0a                	mov    %ecx,(%edx)
  800b5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b62:	88 10                	mov    %dl,(%eax)
}
  800b64:	90                   	nop
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	01 d0                	add    %edx,%eax
  800b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8c:	74 06                	je     800b94 <vsnprintf+0x2d>
  800b8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b92:	7f 07                	jg     800b9b <vsnprintf+0x34>
		return -E_INVAL;
  800b94:	b8 03 00 00 00       	mov    $0x3,%eax
  800b99:	eb 20                	jmp    800bbb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9b:	ff 75 14             	pushl  0x14(%ebp)
  800b9e:	ff 75 10             	pushl  0x10(%ebp)
  800ba1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba4:	50                   	push   %eax
  800ba5:	68 31 0b 80 00       	push   $0x800b31
  800baa:	e8 92 fb ff ff       	call   800741 <vprintfmt>
  800baf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc3:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc6:	83 c0 04             	add    $0x4,%eax
  800bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	50                   	push   %eax
  800bd3:	ff 75 0c             	pushl  0xc(%ebp)
  800bd6:	ff 75 08             	pushl  0x8(%ebp)
  800bd9:	e8 89 ff ff ff       	call   800b67 <vsnprintf>
  800bde:	83 c4 10             	add    $0x10,%esp
  800be1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf6:	eb 06                	jmp    800bfe <strlen+0x15>
		n++;
  800bf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfb:	ff 45 08             	incl   0x8(%ebp)
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8a 00                	mov    (%eax),%al
  800c03:	84 c0                	test   %al,%al
  800c05:	75 f1                	jne    800bf8 <strlen+0xf>
		n++;
	return n;
  800c07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c19:	eb 09                	jmp    800c24 <strnlen+0x18>
		n++;
  800c1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1e:	ff 45 08             	incl   0x8(%ebp)
  800c21:	ff 4d 0c             	decl   0xc(%ebp)
  800c24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c28:	74 09                	je     800c33 <strnlen+0x27>
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	8a 00                	mov    (%eax),%al
  800c2f:	84 c0                	test   %al,%al
  800c31:	75 e8                	jne    800c1b <strnlen+0xf>
		n++;
	return n;
  800c33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c36:	c9                   	leave  
  800c37:	c3                   	ret    

00800c38 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c44:	90                   	nop
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8d 50 01             	lea    0x1(%eax),%edx
  800c4b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c51:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c54:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c57:	8a 12                	mov    (%edx),%dl
  800c59:	88 10                	mov    %dl,(%eax)
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	84 c0                	test   %al,%al
  800c5f:	75 e4                	jne    800c45 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c64:	c9                   	leave  
  800c65:	c3                   	ret    

00800c66 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c79:	eb 1f                	jmp    800c9a <strncpy+0x34>
		*dst++ = *src;
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8d 50 01             	lea    0x1(%eax),%edx
  800c81:	89 55 08             	mov    %edx,0x8(%ebp)
  800c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c87:	8a 12                	mov    (%edx),%dl
  800c89:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8e:	8a 00                	mov    (%eax),%al
  800c90:	84 c0                	test   %al,%al
  800c92:	74 03                	je     800c97 <strncpy+0x31>
			src++;
  800c94:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c97:	ff 45 fc             	incl   -0x4(%ebp)
  800c9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca0:	72 d9                	jb     800c7b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb7:	74 30                	je     800ce9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cb9:	eb 16                	jmp    800cd1 <strlcpy+0x2a>
			*dst++ = *src++;
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8d 50 01             	lea    0x1(%eax),%edx
  800cc1:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccd:	8a 12                	mov    (%edx),%dl
  800ccf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd1:	ff 4d 10             	decl   0x10(%ebp)
  800cd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd8:	74 09                	je     800ce3 <strlcpy+0x3c>
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 d8                	jne    800cbb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cef:	29 c2                	sub    %eax,%edx
  800cf1:	89 d0                	mov    %edx,%eax
}
  800cf3:	c9                   	leave  
  800cf4:	c3                   	ret    

00800cf5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cf8:	eb 06                	jmp    800d00 <strcmp+0xb>
		p++, q++;
  800cfa:	ff 45 08             	incl   0x8(%ebp)
  800cfd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	84 c0                	test   %al,%al
  800d07:	74 0e                	je     800d17 <strcmp+0x22>
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8a 10                	mov    (%eax),%dl
  800d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	38 c2                	cmp    %al,%dl
  800d15:	74 e3                	je     800cfa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	0f b6 d0             	movzbl %al,%edx
  800d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	0f b6 c0             	movzbl %al,%eax
  800d27:	29 c2                	sub    %eax,%edx
  800d29:	89 d0                	mov    %edx,%eax
}
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d30:	eb 09                	jmp    800d3b <strncmp+0xe>
		n--, p++, q++;
  800d32:	ff 4d 10             	decl   0x10(%ebp)
  800d35:	ff 45 08             	incl   0x8(%ebp)
  800d38:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3f:	74 17                	je     800d58 <strncmp+0x2b>
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	84 c0                	test   %al,%al
  800d48:	74 0e                	je     800d58 <strncmp+0x2b>
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8a 10                	mov    (%eax),%dl
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	38 c2                	cmp    %al,%dl
  800d56:	74 da                	je     800d32 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5c:	75 07                	jne    800d65 <strncmp+0x38>
		return 0;
  800d5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d63:	eb 14                	jmp    800d79 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	0f b6 d0             	movzbl %al,%edx
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	0f b6 c0             	movzbl %al,%eax
  800d75:	29 c2                	sub    %eax,%edx
  800d77:	89 d0                	mov    %edx,%eax
}
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	83 ec 04             	sub    $0x4,%esp
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d87:	eb 12                	jmp    800d9b <strchr+0x20>
		if (*s == c)
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d91:	75 05                	jne    800d98 <strchr+0x1d>
			return (char *) s;
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	eb 11                	jmp    800da9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d98:	ff 45 08             	incl   0x8(%ebp)
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	84 c0                	test   %al,%al
  800da2:	75 e5                	jne    800d89 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da9:	c9                   	leave  
  800daa:	c3                   	ret    

00800dab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db7:	eb 0d                	jmp    800dc6 <strfind+0x1b>
		if (*s == c)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc1:	74 0e                	je     800dd1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc3:	ff 45 08             	incl   0x8(%ebp)
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	84 c0                	test   %al,%al
  800dcd:	75 ea                	jne    800db9 <strfind+0xe>
  800dcf:	eb 01                	jmp    800dd2 <strfind+0x27>
		if (*s == c)
			break;
  800dd1:	90                   	nop
	return (char *) s;
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd5:	c9                   	leave  
  800dd6:	c3                   	ret    

00800dd7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
  800de6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800de9:	eb 0e                	jmp    800df9 <memset+0x22>
		*p++ = c;
  800deb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dee:	8d 50 01             	lea    0x1(%eax),%edx
  800df1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800df9:	ff 4d f8             	decl   -0x8(%ebp)
  800dfc:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e00:	79 e9                	jns    800deb <memset+0x14>
		*p++ = c;

	return v;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e05:	c9                   	leave  
  800e06:	c3                   	ret    

00800e07 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e19:	eb 16                	jmp    800e31 <memcpy+0x2a>
		*d++ = *s++;
  800e1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1e:	8d 50 01             	lea    0x1(%eax),%edx
  800e21:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e24:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e2d:	8a 12                	mov    (%edx),%dl
  800e2f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e31:	8b 45 10             	mov    0x10(%ebp),%eax
  800e34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e37:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	75 dd                	jne    800e1b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e41:	c9                   	leave  
  800e42:	c3                   	ret    

00800e43 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e58:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5b:	73 50                	jae    800ead <memmove+0x6a>
  800e5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e60:	8b 45 10             	mov    0x10(%ebp),%eax
  800e63:	01 d0                	add    %edx,%eax
  800e65:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e68:	76 43                	jbe    800ead <memmove+0x6a>
		s += n;
  800e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e70:	8b 45 10             	mov    0x10(%ebp),%eax
  800e73:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e76:	eb 10                	jmp    800e88 <memmove+0x45>
			*--d = *--s;
  800e78:	ff 4d f8             	decl   -0x8(%ebp)
  800e7b:	ff 4d fc             	decl   -0x4(%ebp)
  800e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e81:	8a 10                	mov    (%eax),%dl
  800e83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e86:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e88:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e91:	85 c0                	test   %eax,%eax
  800e93:	75 e3                	jne    800e78 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e95:	eb 23                	jmp    800eba <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9a:	8d 50 01             	lea    0x1(%eax),%edx
  800e9d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea9:	8a 12                	mov    (%edx),%dl
  800eab:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ead:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb3:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb6:	85 c0                	test   %eax,%eax
  800eb8:	75 dd                	jne    800e97 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebd:	c9                   	leave  
  800ebe:	c3                   	ret    

00800ebf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed1:	eb 2a                	jmp    800efd <memcmp+0x3e>
		if (*s1 != *s2)
  800ed3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed6:	8a 10                	mov    (%eax),%dl
  800ed8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800edb:	8a 00                	mov    (%eax),%al
  800edd:	38 c2                	cmp    %al,%dl
  800edf:	74 16                	je     800ef7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	0f b6 d0             	movzbl %al,%edx
  800ee9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	0f b6 c0             	movzbl %al,%eax
  800ef1:	29 c2                	sub    %eax,%edx
  800ef3:	89 d0                	mov    %edx,%eax
  800ef5:	eb 18                	jmp    800f0f <memcmp+0x50>
		s1++, s2++;
  800ef7:	ff 45 fc             	incl   -0x4(%ebp)
  800efa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800efd:	8b 45 10             	mov    0x10(%ebp),%eax
  800f00:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f03:	89 55 10             	mov    %edx,0x10(%ebp)
  800f06:	85 c0                	test   %eax,%eax
  800f08:	75 c9                	jne    800ed3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0f:	c9                   	leave  
  800f10:	c3                   	ret    

00800f11 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f17:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1d:	01 d0                	add    %edx,%eax
  800f1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f22:	eb 15                	jmp    800f39 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	0f b6 d0             	movzbl %al,%edx
  800f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2f:	0f b6 c0             	movzbl %al,%eax
  800f32:	39 c2                	cmp    %eax,%edx
  800f34:	74 0d                	je     800f43 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f36:	ff 45 08             	incl   0x8(%ebp)
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f3f:	72 e3                	jb     800f24 <memfind+0x13>
  800f41:	eb 01                	jmp    800f44 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f43:	90                   	nop
	return (void *) s;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f47:	c9                   	leave  
  800f48:	c3                   	ret    

00800f49 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f56:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5d:	eb 03                	jmp    800f62 <strtol+0x19>
		s++;
  800f5f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	3c 20                	cmp    $0x20,%al
  800f69:	74 f4                	je     800f5f <strtol+0x16>
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	3c 09                	cmp    $0x9,%al
  800f72:	74 eb                	je     800f5f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	3c 2b                	cmp    $0x2b,%al
  800f7b:	75 05                	jne    800f82 <strtol+0x39>
		s++;
  800f7d:	ff 45 08             	incl   0x8(%ebp)
  800f80:	eb 13                	jmp    800f95 <strtol+0x4c>
	else if (*s == '-')
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	3c 2d                	cmp    $0x2d,%al
  800f89:	75 0a                	jne    800f95 <strtol+0x4c>
		s++, neg = 1;
  800f8b:	ff 45 08             	incl   0x8(%ebp)
  800f8e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f99:	74 06                	je     800fa1 <strtol+0x58>
  800f9b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f9f:	75 20                	jne    800fc1 <strtol+0x78>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 30                	cmp    $0x30,%al
  800fa8:	75 17                	jne    800fc1 <strtol+0x78>
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	40                   	inc    %eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	3c 78                	cmp    $0x78,%al
  800fb2:	75 0d                	jne    800fc1 <strtol+0x78>
		s += 2, base = 16;
  800fb4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fb8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fbf:	eb 28                	jmp    800fe9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc5:	75 15                	jne    800fdc <strtol+0x93>
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	3c 30                	cmp    $0x30,%al
  800fce:	75 0c                	jne    800fdc <strtol+0x93>
		s++, base = 8;
  800fd0:	ff 45 08             	incl   0x8(%ebp)
  800fd3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fda:	eb 0d                	jmp    800fe9 <strtol+0xa0>
	else if (base == 0)
  800fdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe0:	75 07                	jne    800fe9 <strtol+0xa0>
		base = 10;
  800fe2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	3c 2f                	cmp    $0x2f,%al
  800ff0:	7e 19                	jle    80100b <strtol+0xc2>
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	3c 39                	cmp    $0x39,%al
  800ff9:	7f 10                	jg     80100b <strtol+0xc2>
			dig = *s - '0';
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	0f be c0             	movsbl %al,%eax
  801003:	83 e8 30             	sub    $0x30,%eax
  801006:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801009:	eb 42                	jmp    80104d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	3c 60                	cmp    $0x60,%al
  801012:	7e 19                	jle    80102d <strtol+0xe4>
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3c 7a                	cmp    $0x7a,%al
  80101b:	7f 10                	jg     80102d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	0f be c0             	movsbl %al,%eax
  801025:	83 e8 57             	sub    $0x57,%eax
  801028:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102b:	eb 20                	jmp    80104d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 40                	cmp    $0x40,%al
  801034:	7e 39                	jle    80106f <strtol+0x126>
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 5a                	cmp    $0x5a,%al
  80103d:	7f 30                	jg     80106f <strtol+0x126>
			dig = *s - 'A' + 10;
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	0f be c0             	movsbl %al,%eax
  801047:	83 e8 37             	sub    $0x37,%eax
  80104a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80104d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801050:	3b 45 10             	cmp    0x10(%ebp),%eax
  801053:	7d 19                	jge    80106e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801055:	ff 45 08             	incl   0x8(%ebp)
  801058:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80105f:	89 c2                	mov    %eax,%edx
  801061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801064:	01 d0                	add    %edx,%eax
  801066:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801069:	e9 7b ff ff ff       	jmp    800fe9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80106e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80106f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801073:	74 08                	je     80107d <strtol+0x134>
		*endptr = (char *) s;
  801075:	8b 45 0c             	mov    0xc(%ebp),%eax
  801078:	8b 55 08             	mov    0x8(%ebp),%edx
  80107b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80107d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801081:	74 07                	je     80108a <strtol+0x141>
  801083:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801086:	f7 d8                	neg    %eax
  801088:	eb 03                	jmp    80108d <strtol+0x144>
  80108a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <ltostr>:

void
ltostr(long value, char *str)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a7:	79 13                	jns    8010bc <ltostr+0x2d>
	{
		neg = 1;
  8010a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010b9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c4:	99                   	cltd   
  8010c5:	f7 f9                	idiv   %ecx
  8010c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cd:	8d 50 01             	lea    0x1(%eax),%edx
  8010d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d3:	89 c2                	mov    %eax,%edx
  8010d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d8:	01 d0                	add    %edx,%eax
  8010da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010dd:	83 c2 30             	add    $0x30,%edx
  8010e0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ea:	f7 e9                	imul   %ecx
  8010ec:	c1 fa 02             	sar    $0x2,%edx
  8010ef:	89 c8                	mov    %ecx,%eax
  8010f1:	c1 f8 1f             	sar    $0x1f,%eax
  8010f4:	29 c2                	sub    %eax,%edx
  8010f6:	89 d0                	mov    %edx,%eax
  8010f8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010fe:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801103:	f7 e9                	imul   %ecx
  801105:	c1 fa 02             	sar    $0x2,%edx
  801108:	89 c8                	mov    %ecx,%eax
  80110a:	c1 f8 1f             	sar    $0x1f,%eax
  80110d:	29 c2                	sub    %eax,%edx
  80110f:	89 d0                	mov    %edx,%eax
  801111:	c1 e0 02             	shl    $0x2,%eax
  801114:	01 d0                	add    %edx,%eax
  801116:	01 c0                	add    %eax,%eax
  801118:	29 c1                	sub    %eax,%ecx
  80111a:	89 ca                	mov    %ecx,%edx
  80111c:	85 d2                	test   %edx,%edx
  80111e:	75 9c                	jne    8010bc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801120:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801127:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112a:	48                   	dec    %eax
  80112b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80112e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801132:	74 3d                	je     801171 <ltostr+0xe2>
		start = 1 ;
  801134:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113b:	eb 34                	jmp    801171 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80113d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	01 d0                	add    %edx,%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80114a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	01 c2                	add    %eax,%edx
  801152:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801155:	8b 45 0c             	mov    0xc(%ebp),%eax
  801158:	01 c8                	add    %ecx,%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80115e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801161:	8b 45 0c             	mov    0xc(%ebp),%eax
  801164:	01 c2                	add    %eax,%edx
  801166:	8a 45 eb             	mov    -0x15(%ebp),%al
  801169:	88 02                	mov    %al,(%edx)
		start++ ;
  80116b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80116e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801174:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801177:	7c c4                	jl     80113d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801179:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	01 d0                	add    %edx,%eax
  801181:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801184:	90                   	nop
  801185:	c9                   	leave  
  801186:	c3                   	ret    

00801187 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80118d:	ff 75 08             	pushl  0x8(%ebp)
  801190:	e8 54 fa ff ff       	call   800be9 <strlen>
  801195:	83 c4 04             	add    $0x4,%esp
  801198:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119b:	ff 75 0c             	pushl  0xc(%ebp)
  80119e:	e8 46 fa ff ff       	call   800be9 <strlen>
  8011a3:	83 c4 04             	add    $0x4,%esp
  8011a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b7:	eb 17                	jmp    8011d0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bf:	01 c2                	add    %eax,%edx
  8011c1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	01 c8                	add    %ecx,%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011cd:	ff 45 fc             	incl   -0x4(%ebp)
  8011d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d6:	7c e1                	jl     8011b9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e6:	eb 1f                	jmp    801207 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011eb:	8d 50 01             	lea    0x1(%eax),%edx
  8011ee:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f1:	89 c2                	mov    %eax,%edx
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	01 c2                	add    %eax,%edx
  8011f8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	01 c8                	add    %ecx,%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801204:	ff 45 f8             	incl   -0x8(%ebp)
  801207:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120d:	7c d9                	jl     8011e8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80120f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	01 d0                	add    %edx,%eax
  801217:	c6 00 00             	movb   $0x0,(%eax)
}
  80121a:	90                   	nop
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801220:	8b 45 14             	mov    0x14(%ebp),%eax
  801223:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801229:	8b 45 14             	mov    0x14(%ebp),%eax
  80122c:	8b 00                	mov    (%eax),%eax
  80122e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801235:	8b 45 10             	mov    0x10(%ebp),%eax
  801238:	01 d0                	add    %edx,%eax
  80123a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801240:	eb 0c                	jmp    80124e <strsplit+0x31>
			*string++ = 0;
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	8d 50 01             	lea    0x1(%eax),%edx
  801248:	89 55 08             	mov    %edx,0x8(%ebp)
  80124b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	84 c0                	test   %al,%al
  801255:	74 18                	je     80126f <strsplit+0x52>
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	0f be c0             	movsbl %al,%eax
  80125f:	50                   	push   %eax
  801260:	ff 75 0c             	pushl  0xc(%ebp)
  801263:	e8 13 fb ff ff       	call   800d7b <strchr>
  801268:	83 c4 08             	add    $0x8,%esp
  80126b:	85 c0                	test   %eax,%eax
  80126d:	75 d3                	jne    801242 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	84 c0                	test   %al,%al
  801276:	74 5a                	je     8012d2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801278:	8b 45 14             	mov    0x14(%ebp),%eax
  80127b:	8b 00                	mov    (%eax),%eax
  80127d:	83 f8 0f             	cmp    $0xf,%eax
  801280:	75 07                	jne    801289 <strsplit+0x6c>
		{
			return 0;
  801282:	b8 00 00 00 00       	mov    $0x0,%eax
  801287:	eb 66                	jmp    8012ef <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801289:	8b 45 14             	mov    0x14(%ebp),%eax
  80128c:	8b 00                	mov    (%eax),%eax
  80128e:	8d 48 01             	lea    0x1(%eax),%ecx
  801291:	8b 55 14             	mov    0x14(%ebp),%edx
  801294:	89 0a                	mov    %ecx,(%edx)
  801296:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129d:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a0:	01 c2                	add    %eax,%edx
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012a7:	eb 03                	jmp    8012ac <strsplit+0x8f>
			string++;
  8012a9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	84 c0                	test   %al,%al
  8012b3:	74 8b                	je     801240 <strsplit+0x23>
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	0f be c0             	movsbl %al,%eax
  8012bd:	50                   	push   %eax
  8012be:	ff 75 0c             	pushl  0xc(%ebp)
  8012c1:	e8 b5 fa ff ff       	call   800d7b <strchr>
  8012c6:	83 c4 08             	add    $0x8,%esp
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	74 dc                	je     8012a9 <strsplit+0x8c>
			string++;
	}
  8012cd:	e9 6e ff ff ff       	jmp    801240 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d6:	8b 00                	mov    (%eax),%eax
  8012d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012df:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e2:	01 d0                	add    %edx,%eax
  8012e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ea:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8012f7:	83 ec 04             	sub    $0x4,%esp
  8012fa:	68 70 24 80 00       	push   $0x802470
  8012ff:	6a 19                	push   $0x19
  801301:	68 95 24 80 00       	push   $0x802495
  801306:	e8 ba ef ff ff       	call   8002c5 <_panic>

0080130b <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 18             	sub    $0x18,%esp
  801311:	8b 45 10             	mov    0x10(%ebp),%eax
  801314:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801317:	83 ec 04             	sub    $0x4,%esp
  80131a:	68 a4 24 80 00       	push   $0x8024a4
  80131f:	6a 31                	push   $0x31
  801321:	68 95 24 80 00       	push   $0x802495
  801326:	e8 9a ef ff ff       	call   8002c5 <_panic>

0080132b <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801331:	83 ec 04             	sub    $0x4,%esp
  801334:	68 cc 24 80 00       	push   $0x8024cc
  801339:	6a 4a                	push   $0x4a
  80133b:	68 95 24 80 00       	push   $0x802495
  801340:	e8 80 ef ff ff       	call   8002c5 <_panic>

00801345 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80134b:	83 ec 04             	sub    $0x4,%esp
  80134e:	68 f0 24 80 00       	push   $0x8024f0
  801353:	6a 70                	push   $0x70
  801355:	68 95 24 80 00       	push   $0x802495
  80135a:	e8 66 ef ff ff       	call   8002c5 <_panic>

0080135f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801365:	83 ec 04             	sub    $0x4,%esp
  801368:	68 14 25 80 00       	push   $0x802514
  80136d:	68 8b 00 00 00       	push   $0x8b
  801372:	68 95 24 80 00       	push   $0x802495
  801377:	e8 49 ef ff ff       	call   8002c5 <_panic>

0080137c <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801382:	83 ec 04             	sub    $0x4,%esp
  801385:	68 38 25 80 00       	push   $0x802538
  80138a:	68 a8 00 00 00       	push   $0xa8
  80138f:	68 95 24 80 00       	push   $0x802495
  801394:	e8 2c ef ff ff       	call   8002c5 <_panic>

00801399 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	57                   	push   %edi
  80139d:	56                   	push   %esi
  80139e:	53                   	push   %ebx
  80139f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013ae:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013b1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013b4:	cd 30                	int    $0x30
  8013b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8013b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013bc:	83 c4 10             	add    $0x10,%esp
  8013bf:	5b                   	pop    %ebx
  8013c0:	5e                   	pop    %esi
  8013c1:	5f                   	pop    %edi
  8013c2:	5d                   	pop    %ebp
  8013c3:	c3                   	ret    

008013c4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	83 ec 04             	sub    $0x4,%esp
  8013ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8013d0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	52                   	push   %edx
  8013dc:	ff 75 0c             	pushl  0xc(%ebp)
  8013df:	50                   	push   %eax
  8013e0:	6a 00                	push   $0x0
  8013e2:	e8 b2 ff ff ff       	call   801399 <syscall>
  8013e7:	83 c4 18             	add    $0x18,%esp
}
  8013ea:	90                   	nop
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <sys_cgetc>:

int
sys_cgetc(void)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 01                	push   $0x1
  8013fc:	e8 98 ff ff ff       	call   801399 <syscall>
  801401:	83 c4 18             	add    $0x18,%esp
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	50                   	push   %eax
  801415:	6a 05                	push   $0x5
  801417:	e8 7d ff ff ff       	call   801399 <syscall>
  80141c:	83 c4 18             	add    $0x18,%esp
}
  80141f:	c9                   	leave  
  801420:	c3                   	ret    

00801421 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 02                	push   $0x2
  801430:	e8 64 ff ff ff       	call   801399 <syscall>
  801435:	83 c4 18             	add    $0x18,%esp
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 03                	push   $0x3
  801449:	e8 4b ff ff ff       	call   801399 <syscall>
  80144e:	83 c4 18             	add    $0x18,%esp
}
  801451:	c9                   	leave  
  801452:	c3                   	ret    

00801453 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 04                	push   $0x4
  801462:	e8 32 ff ff ff       	call   801399 <syscall>
  801467:	83 c4 18             	add    $0x18,%esp
}
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <sys_env_exit>:


void sys_env_exit(void)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 06                	push   $0x6
  80147b:	e8 19 ff ff ff       	call   801399 <syscall>
  801480:	83 c4 18             	add    $0x18,%esp
}
  801483:	90                   	nop
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801489:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	52                   	push   %edx
  801496:	50                   	push   %eax
  801497:	6a 07                	push   $0x7
  801499:	e8 fb fe ff ff       	call   801399 <syscall>
  80149e:	83 c4 18             	add    $0x18,%esp
}
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	56                   	push   %esi
  8014a7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014a8:	8b 75 18             	mov    0x18(%ebp),%esi
  8014ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	56                   	push   %esi
  8014b8:	53                   	push   %ebx
  8014b9:	51                   	push   %ecx
  8014ba:	52                   	push   %edx
  8014bb:	50                   	push   %eax
  8014bc:	6a 08                	push   $0x8
  8014be:	e8 d6 fe ff ff       	call   801399 <syscall>
  8014c3:	83 c4 18             	add    $0x18,%esp
}
  8014c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014c9:	5b                   	pop    %ebx
  8014ca:	5e                   	pop    %esi
  8014cb:	5d                   	pop    %ebp
  8014cc:	c3                   	ret    

008014cd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	52                   	push   %edx
  8014dd:	50                   	push   %eax
  8014de:	6a 09                	push   $0x9
  8014e0:	e8 b4 fe ff ff       	call   801399 <syscall>
  8014e5:	83 c4 18             	add    $0x18,%esp
}
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	ff 75 0c             	pushl  0xc(%ebp)
  8014f6:	ff 75 08             	pushl  0x8(%ebp)
  8014f9:	6a 0a                	push   $0xa
  8014fb:	e8 99 fe ff ff       	call   801399 <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 0b                	push   $0xb
  801514:	e8 80 fe ff ff       	call   801399 <syscall>
  801519:	83 c4 18             	add    $0x18,%esp
}
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 0c                	push   $0xc
  80152d:	e8 67 fe ff ff       	call   801399 <syscall>
  801532:	83 c4 18             	add    $0x18,%esp
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 0d                	push   $0xd
  801546:	e8 4e fe ff ff       	call   801399 <syscall>
  80154b:	83 c4 18             	add    $0x18,%esp
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	ff 75 0c             	pushl  0xc(%ebp)
  80155c:	ff 75 08             	pushl  0x8(%ebp)
  80155f:	6a 11                	push   $0x11
  801561:	e8 33 fe ff ff       	call   801399 <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
	return;
  801569:	90                   	nop
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	ff 75 0c             	pushl  0xc(%ebp)
  801578:	ff 75 08             	pushl  0x8(%ebp)
  80157b:	6a 12                	push   $0x12
  80157d:	e8 17 fe ff ff       	call   801399 <syscall>
  801582:	83 c4 18             	add    $0x18,%esp
	return ;
  801585:	90                   	nop
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 0e                	push   $0xe
  801597:	e8 fd fd ff ff       	call   801399 <syscall>
  80159c:	83 c4 18             	add    $0x18,%esp
}
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	ff 75 08             	pushl  0x8(%ebp)
  8015af:	6a 0f                	push   $0xf
  8015b1:	e8 e3 fd ff ff       	call   801399 <syscall>
  8015b6:	83 c4 18             	add    $0x18,%esp
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 10                	push   $0x10
  8015ca:	e8 ca fd ff ff       	call   801399 <syscall>
  8015cf:	83 c4 18             	add    $0x18,%esp
}
  8015d2:	90                   	nop
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 14                	push   $0x14
  8015e4:	e8 b0 fd ff ff       	call   801399 <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
}
  8015ec:	90                   	nop
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 15                	push   $0x15
  8015fe:	e8 96 fd ff ff       	call   801399 <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
}
  801606:	90                   	nop
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sys_cputc>:


void
sys_cputc(const char c)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801615:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	50                   	push   %eax
  801622:	6a 16                	push   $0x16
  801624:	e8 70 fd ff ff       	call   801399 <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
}
  80162c:	90                   	nop
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 17                	push   $0x17
  80163e:	e8 56 fd ff ff       	call   801399 <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
}
  801646:	90                   	nop
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	ff 75 0c             	pushl  0xc(%ebp)
  801658:	50                   	push   %eax
  801659:	6a 18                	push   $0x18
  80165b:	e8 39 fd ff ff       	call   801399 <syscall>
  801660:	83 c4 18             	add    $0x18,%esp
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	52                   	push   %edx
  801675:	50                   	push   %eax
  801676:	6a 1b                	push   $0x1b
  801678:	e8 1c fd ff ff       	call   801399 <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801685:	8b 55 0c             	mov    0xc(%ebp),%edx
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	52                   	push   %edx
  801692:	50                   	push   %eax
  801693:	6a 19                	push   $0x19
  801695:	e8 ff fc ff ff       	call   801399 <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	90                   	nop
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	52                   	push   %edx
  8016b0:	50                   	push   %eax
  8016b1:	6a 1a                	push   $0x1a
  8016b3:	e8 e1 fc ff ff       	call   801399 <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	90                   	nop
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 04             	sub    $0x4,%esp
  8016c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016ca:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016cd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	6a 00                	push   $0x0
  8016d6:	51                   	push   %ecx
  8016d7:	52                   	push   %edx
  8016d8:	ff 75 0c             	pushl  0xc(%ebp)
  8016db:	50                   	push   %eax
  8016dc:	6a 1c                	push   $0x1c
  8016de:	e8 b6 fc ff ff       	call   801399 <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	52                   	push   %edx
  8016f8:	50                   	push   %eax
  8016f9:	6a 1d                	push   $0x1d
  8016fb:	e8 99 fc ff ff       	call   801399 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801708:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80170b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	51                   	push   %ecx
  801716:	52                   	push   %edx
  801717:	50                   	push   %eax
  801718:	6a 1e                	push   $0x1e
  80171a:	e8 7a fc ff ff       	call   801399 <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	52                   	push   %edx
  801734:	50                   	push   %eax
  801735:	6a 1f                	push   $0x1f
  801737:	e8 5d fc ff ff       	call   801399 <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 20                	push   $0x20
  801750:	e8 44 fc ff ff       	call   801399 <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	ff 75 10             	pushl  0x10(%ebp)
  801767:	ff 75 0c             	pushl  0xc(%ebp)
  80176a:	50                   	push   %eax
  80176b:	6a 21                	push   $0x21
  80176d:	e8 27 fc ff ff       	call   801399 <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	50                   	push   %eax
  801786:	6a 22                	push   $0x22
  801788:	e8 0c fc ff ff       	call   801399 <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	90                   	nop
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	50                   	push   %eax
  8017a2:	6a 23                	push   $0x23
  8017a4:	e8 f0 fb ff ff       	call   801399 <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
}
  8017ac:	90                   	nop
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017b5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017b8:	8d 50 04             	lea    0x4(%eax),%edx
  8017bb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	52                   	push   %edx
  8017c5:	50                   	push   %eax
  8017c6:	6a 24                	push   $0x24
  8017c8:	e8 cc fb ff ff       	call   801399 <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
	return result;
  8017d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017d9:	89 01                	mov    %eax,(%ecx)
  8017db:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	c9                   	leave  
  8017e2:	c2 04 00             	ret    $0x4

008017e5 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	ff 75 10             	pushl  0x10(%ebp)
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	ff 75 08             	pushl  0x8(%ebp)
  8017f5:	6a 13                	push   $0x13
  8017f7:	e8 9d fb ff ff       	call   801399 <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ff:	90                   	nop
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_rcr2>:
uint32 sys_rcr2()
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 25                	push   $0x25
  801811:	e8 83 fb ff ff       	call   801399 <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801827:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	50                   	push   %eax
  801834:	6a 26                	push   $0x26
  801836:	e8 5e fb ff ff       	call   801399 <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
	return ;
  80183e:	90                   	nop
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <rsttst>:
void rsttst()
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 28                	push   $0x28
  801850:	e8 44 fb ff ff       	call   801399 <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
	return ;
  801858:	90                   	nop
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 04             	sub    $0x4,%esp
  801861:	8b 45 14             	mov    0x14(%ebp),%eax
  801864:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801867:	8b 55 18             	mov    0x18(%ebp),%edx
  80186a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80186e:	52                   	push   %edx
  80186f:	50                   	push   %eax
  801870:	ff 75 10             	pushl  0x10(%ebp)
  801873:	ff 75 0c             	pushl  0xc(%ebp)
  801876:	ff 75 08             	pushl  0x8(%ebp)
  801879:	6a 27                	push   $0x27
  80187b:	e8 19 fb ff ff       	call   801399 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
	return ;
  801883:	90                   	nop
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <chktst>:
void chktst(uint32 n)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	ff 75 08             	pushl  0x8(%ebp)
  801894:	6a 29                	push   $0x29
  801896:	e8 fe fa ff ff       	call   801399 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
	return ;
  80189e:	90                   	nop
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <inctst>:

void inctst()
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 2a                	push   $0x2a
  8018b0:	e8 e4 fa ff ff       	call   801399 <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b8:	90                   	nop
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <gettst>:
uint32 gettst()
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 2b                	push   $0x2b
  8018ca:	e8 ca fa ff ff       	call   801399 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 2c                	push   $0x2c
  8018e6:	e8 ae fa ff ff       	call   801399 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
  8018ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018f1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018f5:	75 07                	jne    8018fe <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8018fc:	eb 05                	jmp    801903 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 2c                	push   $0x2c
  801917:	e8 7d fa ff ff       	call   801399 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
  80191f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801922:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801926:	75 07                	jne    80192f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801928:	b8 01 00 00 00       	mov    $0x1,%eax
  80192d:	eb 05                	jmp    801934 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80192f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 2c                	push   $0x2c
  801948:	e8 4c fa ff ff       	call   801399 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
  801950:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801953:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801957:	75 07                	jne    801960 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801959:	b8 01 00 00 00       	mov    $0x1,%eax
  80195e:	eb 05                	jmp    801965 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801960:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 2c                	push   $0x2c
  801979:	e8 1b fa ff ff       	call   801399 <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
  801981:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801984:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801988:	75 07                	jne    801991 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80198a:	b8 01 00 00 00       	mov    $0x1,%eax
  80198f:	eb 05                	jmp    801996 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801991:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	ff 75 08             	pushl  0x8(%ebp)
  8019a6:	6a 2d                	push   $0x2d
  8019a8:	e8 ec f9 ff ff       	call   801399 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b0:	90                   	nop
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	6a 00                	push   $0x0
  8019c5:	53                   	push   %ebx
  8019c6:	51                   	push   %ecx
  8019c7:	52                   	push   %edx
  8019c8:	50                   	push   %eax
  8019c9:	6a 2e                	push   $0x2e
  8019cb:	e8 c9 f9 ff ff       	call   801399 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8019db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	52                   	push   %edx
  8019e8:	50                   	push   %eax
  8019e9:	6a 2f                	push   $0x2f
  8019eb:	e8 a9 f9 ff ff       	call   801399 <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8019fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8019fe:	89 d0                	mov    %edx,%eax
  801a00:	c1 e0 02             	shl    $0x2,%eax
  801a03:	01 d0                	add    %edx,%eax
  801a05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a0c:	01 d0                	add    %edx,%eax
  801a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a15:	01 d0                	add    %edx,%eax
  801a17:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a1e:	01 d0                	add    %edx,%eax
  801a20:	c1 e0 04             	shl    $0x4,%eax
  801a23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801a26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801a2d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801a30:	83 ec 0c             	sub    $0xc,%esp
  801a33:	50                   	push   %eax
  801a34:	e8 76 fd ff ff       	call   8017af <sys_get_virtual_time>
  801a39:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801a3c:	eb 41                	jmp    801a7f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801a3e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a41:	83 ec 0c             	sub    $0xc,%esp
  801a44:	50                   	push   %eax
  801a45:	e8 65 fd ff ff       	call   8017af <sys_get_virtual_time>
  801a4a:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801a4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a53:	29 c2                	sub    %eax,%edx
  801a55:	89 d0                	mov    %edx,%eax
  801a57:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801a5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a60:	89 d1                	mov    %edx,%ecx
  801a62:	29 c1                	sub    %eax,%ecx
  801a64:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a6a:	39 c2                	cmp    %eax,%edx
  801a6c:	0f 97 c0             	seta   %al
  801a6f:	0f b6 c0             	movzbl %al,%eax
  801a72:	29 c1                	sub    %eax,%ecx
  801a74:	89 c8                	mov    %ecx,%eax
  801a76:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a82:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a85:	72 b7                	jb     801a3e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a87:	90                   	nop
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a97:	eb 03                	jmp    801a9c <busy_wait+0x12>
  801a99:	ff 45 fc             	incl   -0x4(%ebp)
  801a9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a9f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801aa2:	72 f5                	jb     801a99 <busy_wait+0xf>
	return i;
  801aa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    
  801aa9:	66 90                	xchg   %ax,%ax
  801aab:	90                   	nop

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
