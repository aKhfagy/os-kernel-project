
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 07 01 00 00       	call   80013d <libmain>
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
	// Testing scenario 5_1: Kill ONE program has shared variables and it free it
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 20 1c 80 00       	push   $0x801c20
  80004a:	e8 79 12 00 00       	call   8012c8 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 5f 14 00 00       	call   8014c2 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 da 14 00 00       	call   801545 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 1c 80 00       	push   $0x801c30
  800079:	e8 a6 04 00 00       	call   800524 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000, 50);
  800081:	83 ec 04             	sub    $0x4,%esp
  800084:	6a 32                	push   $0x32
  800086:	68 d0 07 00 00       	push   $0x7d0
  80008b:	68 63 1c 80 00       	push   $0x801c63
  800090:	e8 82 16 00 00       	call   801717 <sys_create_env>
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	ff 75 e8             	pushl  -0x18(%ebp)
  8000a1:	e8 8e 16 00 00       	call   801734 <sys_run_env>
  8000a6:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000a9:	90                   	nop
  8000aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ad:	8b 00                	mov    (%eax),%eax
  8000af:	83 f8 01             	cmp    $0x1,%eax
  8000b2:	75 f6                	jne    8000aa <_main+0x72>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000b4:	e8 09 14 00 00       	call   8014c2 <sys_calculate_free_frames>
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	50                   	push   %eax
  8000bd:	68 6c 1c 80 00       	push   $0x801c6c
  8000c2:	e8 5d 04 00 00       	call   800524 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp

	sys_free_env(envIdProcessA);
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d0:	e8 7b 16 00 00       	call   801750 <sys_free_env>
  8000d5:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000d8:	e8 e5 13 00 00       	call   8014c2 <sys_calculate_free_frames>
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e0:	e8 60 14 00 00       	call   801545 <sys_pf_calculate_allocated_pages>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000ee:	74 27                	je     800117 <_main+0xdf>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n", freeFrames_after);
  8000f0:	83 ec 08             	sub    $0x8,%esp
  8000f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f6:	68 a0 1c 80 00       	push   $0x801ca0
  8000fb:	e8 24 04 00 00       	call   800524 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		panic("env_free() does not work correctly... check it again.");
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 f0 1c 80 00       	push   $0x801cf0
  80010b:	6a 1e                	push   $0x1e
  80010d:	68 26 1d 80 00       	push   $0x801d26
  800112:	e8 6b 01 00 00       	call   800282 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80011d:	68 3c 1d 80 00       	push   $0x801d3c
  800122:	e8 fd 03 00 00       	call   800524 <cprintf>
  800127:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  80012a:	83 ec 0c             	sub    $0xc,%esp
  80012d:	68 9c 1d 80 00       	push   $0x801d9c
  800132:	e8 ed 03 00 00       	call   800524 <cprintf>
  800137:	83 c4 10             	add    $0x10,%esp
	return;
  80013a:	90                   	nop
}
  80013b:	c9                   	leave  
  80013c:	c3                   	ret    

0080013d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80013d:	55                   	push   %ebp
  80013e:	89 e5                	mov    %esp,%ebp
  800140:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800143:	e8 af 12 00 00       	call   8013f7 <sys_getenvindex>
  800148:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80014b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80014e:	89 d0                	mov    %edx,%eax
  800150:	c1 e0 03             	shl    $0x3,%eax
  800153:	01 d0                	add    %edx,%eax
  800155:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80015c:	01 c8                	add    %ecx,%eax
  80015e:	01 c0                	add    %eax,%eax
  800160:	01 d0                	add    %edx,%eax
  800162:	01 c0                	add    %eax,%eax
  800164:	01 d0                	add    %edx,%eax
  800166:	89 c2                	mov    %eax,%edx
  800168:	c1 e2 05             	shl    $0x5,%edx
  80016b:	29 c2                	sub    %eax,%edx
  80016d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800174:	89 c2                	mov    %eax,%edx
  800176:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80017c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800181:	a1 20 30 80 00       	mov    0x803020,%eax
  800186:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80018c:	84 c0                	test   %al,%al
  80018e:	74 0f                	je     80019f <libmain+0x62>
		binaryname = myEnv->prog_name;
  800190:	a1 20 30 80 00       	mov    0x803020,%eax
  800195:	05 40 3c 01 00       	add    $0x13c40,%eax
  80019a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a3:	7e 0a                	jle    8001af <libmain+0x72>
		binaryname = argv[0];
  8001a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	ff 75 0c             	pushl  0xc(%ebp)
  8001b5:	ff 75 08             	pushl  0x8(%ebp)
  8001b8:	e8 7b fe ff ff       	call   800038 <_main>
  8001bd:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001c0:	e8 cd 13 00 00       	call   801592 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 00 1e 80 00       	push   $0x801e00
  8001cd:	e8 52 03 00 00       	call   800524 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001da:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8001e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e5:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	52                   	push   %edx
  8001ef:	50                   	push   %eax
  8001f0:	68 28 1e 80 00       	push   $0x801e28
  8001f5:	e8 2a 03 00 00       	call   800524 <cprintf>
  8001fa:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8001fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800202:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800208:	a1 20 30 80 00       	mov    0x803020,%eax
  80020d:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	52                   	push   %edx
  800217:	50                   	push   %eax
  800218:	68 50 1e 80 00       	push   $0x801e50
  80021d:	e8 02 03 00 00       	call   800524 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 30 80 00       	mov    0x803020,%eax
  80022a:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 91 1e 80 00       	push   $0x801e91
  800239:	e8 e6 02 00 00       	call   800524 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 00 1e 80 00       	push   $0x801e00
  800249:	e8 d6 02 00 00       	call   800524 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800251:	e8 56 13 00 00       	call   8015ac <sys_enable_interrupt>

	// exit gracefully
	exit();
  800256:	e8 19 00 00 00       	call   800274 <exit>
}
  80025b:	90                   	nop
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	6a 00                	push   $0x0
  800269:	e8 55 11 00 00       	call   8013c3 <sys_env_destroy>
  80026e:	83 c4 10             	add    $0x10,%esp
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <exit>:

void
exit(void)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80027a:	e8 aa 11 00 00       	call   801429 <sys_env_exit>
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800288:	8d 45 10             	lea    0x10(%ebp),%eax
  80028b:	83 c0 04             	add    $0x4,%eax
  80028e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800291:	a1 18 31 80 00       	mov    0x803118,%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	74 16                	je     8002b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029a:	a1 18 31 80 00       	mov    0x803118,%eax
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	50                   	push   %eax
  8002a3:	68 a8 1e 80 00       	push   $0x801ea8
  8002a8:	e8 77 02 00 00       	call   800524 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 30 80 00       	mov    0x803000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 ad 1e 80 00       	push   $0x801ead
  8002c1:	e8 5e 02 00 00       	call   800524 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d2:	50                   	push   %eax
  8002d3:	e8 e1 01 00 00       	call   8004b9 <vcprintf>
  8002d8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	6a 00                	push   $0x0
  8002e0:	68 c9 1e 80 00       	push   $0x801ec9
  8002e5:	e8 cf 01 00 00       	call   8004b9 <vcprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ed:	e8 82 ff ff ff       	call   800274 <exit>

	// should not return here
	while (1) ;
  8002f2:	eb fe                	jmp    8002f2 <_panic+0x70>

008002f4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ff:	8b 50 74             	mov    0x74(%eax),%edx
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
  800305:	39 c2                	cmp    %eax,%edx
  800307:	74 14                	je     80031d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 cc 1e 80 00       	push   $0x801ecc
  800311:	6a 26                	push   $0x26
  800313:	68 18 1f 80 00       	push   $0x801f18
  800318:	e8 65 ff ff ff       	call   800282 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800324:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80032b:	e9 b6 00 00 00       	jmp    8003e6 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800333:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	01 d0                	add    %edx,%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	85 c0                	test   %eax,%eax
  800343:	75 08                	jne    80034d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800345:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800348:	e9 96 00 00 00       	jmp    8003e3 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80034d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800354:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80035b:	eb 5d                	jmp    8003ba <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035d:	a1 20 30 80 00       	mov    0x803020,%eax
  800362:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800368:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80036b:	c1 e2 04             	shl    $0x4,%edx
  80036e:	01 d0                	add    %edx,%eax
  800370:	8a 40 04             	mov    0x4(%eax),%al
  800373:	84 c0                	test   %al,%al
  800375:	75 40                	jne    8003b7 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800377:	a1 20 30 80 00       	mov    0x803020,%eax
  80037c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800382:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800385:	c1 e2 04             	shl    $0x4,%edx
  800388:	01 d0                	add    %edx,%eax
  80038a:	8b 00                	mov    (%eax),%eax
  80038c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80038f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800392:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800397:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a6:	01 c8                	add    %ecx,%eax
  8003a8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003aa:	39 c2                	cmp    %eax,%edx
  8003ac:	75 09                	jne    8003b7 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8003ae:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b5:	eb 12                	jmp    8003c9 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b7:	ff 45 e8             	incl   -0x18(%ebp)
  8003ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8003bf:	8b 50 74             	mov    0x74(%eax),%edx
  8003c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c5:	39 c2                	cmp    %eax,%edx
  8003c7:	77 94                	ja     80035d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003cd:	75 14                	jne    8003e3 <CheckWSWithoutLastIndex+0xef>
			panic(
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 24 1f 80 00       	push   $0x801f24
  8003d7:	6a 3a                	push   $0x3a
  8003d9:	68 18 1f 80 00       	push   $0x801f18
  8003de:	e8 9f fe ff ff       	call   800282 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e3:	ff 45 f0             	incl   -0x10(%ebp)
  8003e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003ec:	0f 8c 3e ff ff ff    	jl     800330 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003f2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800400:	eb 20                	jmp    800422 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800402:	a1 20 30 80 00       	mov    0x803020,%eax
  800407:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80040d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800410:	c1 e2 04             	shl    $0x4,%edx
  800413:	01 d0                	add    %edx,%eax
  800415:	8a 40 04             	mov    0x4(%eax),%al
  800418:	3c 01                	cmp    $0x1,%al
  80041a:	75 03                	jne    80041f <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80041c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80041f:	ff 45 e0             	incl   -0x20(%ebp)
  800422:	a1 20 30 80 00       	mov    0x803020,%eax
  800427:	8b 50 74             	mov    0x74(%eax),%edx
  80042a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042d:	39 c2                	cmp    %eax,%edx
  80042f:	77 d1                	ja     800402 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800434:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800437:	74 14                	je     80044d <CheckWSWithoutLastIndex+0x159>
		panic(
  800439:	83 ec 04             	sub    $0x4,%esp
  80043c:	68 78 1f 80 00       	push   $0x801f78
  800441:	6a 44                	push   $0x44
  800443:	68 18 1f 80 00       	push   $0x801f18
  800448:	e8 35 fe ff ff       	call   800282 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80044d:	90                   	nop
  80044e:	c9                   	leave  
  80044f:	c3                   	ret    

00800450 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800456:	8b 45 0c             	mov    0xc(%ebp),%eax
  800459:	8b 00                	mov    (%eax),%eax
  80045b:	8d 48 01             	lea    0x1(%eax),%ecx
  80045e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800461:	89 0a                	mov    %ecx,(%edx)
  800463:	8b 55 08             	mov    0x8(%ebp),%edx
  800466:	88 d1                	mov    %dl,%cl
  800468:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80046f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800472:	8b 00                	mov    (%eax),%eax
  800474:	3d ff 00 00 00       	cmp    $0xff,%eax
  800479:	75 2c                	jne    8004a7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80047b:	a0 24 30 80 00       	mov    0x803024,%al
  800480:	0f b6 c0             	movzbl %al,%eax
  800483:	8b 55 0c             	mov    0xc(%ebp),%edx
  800486:	8b 12                	mov    (%edx),%edx
  800488:	89 d1                	mov    %edx,%ecx
  80048a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048d:	83 c2 08             	add    $0x8,%edx
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	50                   	push   %eax
  800494:	51                   	push   %ecx
  800495:	52                   	push   %edx
  800496:	e8 e6 0e 00 00       	call   801381 <sys_cputs>
  80049b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004aa:	8b 40 04             	mov    0x4(%eax),%eax
  8004ad:	8d 50 01             	lea    0x1(%eax),%edx
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b6:	90                   	nop
  8004b7:	c9                   	leave  
  8004b8:	c3                   	ret    

008004b9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b9:	55                   	push   %ebp
  8004ba:	89 e5                	mov    %esp,%ebp
  8004bc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c9:	00 00 00 
	b.cnt = 0;
  8004cc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e2:	50                   	push   %eax
  8004e3:	68 50 04 80 00       	push   $0x800450
  8004e8:	e8 11 02 00 00       	call   8006fe <vprintfmt>
  8004ed:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f0:	a0 24 30 80 00       	mov    0x803024,%al
  8004f5:	0f b6 c0             	movzbl %al,%eax
  8004f8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	50                   	push   %eax
  800502:	52                   	push   %edx
  800503:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800509:	83 c0 08             	add    $0x8,%eax
  80050c:	50                   	push   %eax
  80050d:	e8 6f 0e 00 00       	call   801381 <sys_cputs>
  800512:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800515:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80051c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800522:	c9                   	leave  
  800523:	c3                   	ret    

00800524 <cprintf>:

int cprintf(const char *fmt, ...) {
  800524:	55                   	push   %ebp
  800525:	89 e5                	mov    %esp,%ebp
  800527:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80052a:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800531:	8d 45 0c             	lea    0xc(%ebp),%eax
  800534:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	ff 75 f4             	pushl  -0xc(%ebp)
  800540:	50                   	push   %eax
  800541:	e8 73 ff ff ff       	call   8004b9 <vcprintf>
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054f:	c9                   	leave  
  800550:	c3                   	ret    

00800551 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800551:	55                   	push   %ebp
  800552:	89 e5                	mov    %esp,%ebp
  800554:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800557:	e8 36 10 00 00       	call   801592 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80055c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80055f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800562:	8b 45 08             	mov    0x8(%ebp),%eax
  800565:	83 ec 08             	sub    $0x8,%esp
  800568:	ff 75 f4             	pushl  -0xc(%ebp)
  80056b:	50                   	push   %eax
  80056c:	e8 48 ff ff ff       	call   8004b9 <vcprintf>
  800571:	83 c4 10             	add    $0x10,%esp
  800574:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800577:	e8 30 10 00 00       	call   8015ac <sys_enable_interrupt>
	return cnt;
  80057c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80057f:	c9                   	leave  
  800580:	c3                   	ret    

00800581 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800581:	55                   	push   %ebp
  800582:	89 e5                	mov    %esp,%ebp
  800584:	53                   	push   %ebx
  800585:	83 ec 14             	sub    $0x14,%esp
  800588:	8b 45 10             	mov    0x10(%ebp),%eax
  80058b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800594:	8b 45 18             	mov    0x18(%ebp),%eax
  800597:	ba 00 00 00 00       	mov    $0x0,%edx
  80059c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059f:	77 55                	ja     8005f6 <printnum+0x75>
  8005a1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a4:	72 05                	jb     8005ab <printnum+0x2a>
  8005a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005a9:	77 4b                	ja     8005f6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ab:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ae:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b9:	52                   	push   %edx
  8005ba:	50                   	push   %eax
  8005bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8005be:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c1:	e8 ee 13 00 00       	call   8019b4 <__udivdi3>
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	ff 75 20             	pushl  0x20(%ebp)
  8005cf:	53                   	push   %ebx
  8005d0:	ff 75 18             	pushl  0x18(%ebp)
  8005d3:	52                   	push   %edx
  8005d4:	50                   	push   %eax
  8005d5:	ff 75 0c             	pushl  0xc(%ebp)
  8005d8:	ff 75 08             	pushl  0x8(%ebp)
  8005db:	e8 a1 ff ff ff       	call   800581 <printnum>
  8005e0:	83 c4 20             	add    $0x20,%esp
  8005e3:	eb 1a                	jmp    8005ff <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e5:	83 ec 08             	sub    $0x8,%esp
  8005e8:	ff 75 0c             	pushl  0xc(%ebp)
  8005eb:	ff 75 20             	pushl  0x20(%ebp)
  8005ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f1:	ff d0                	call   *%eax
  8005f3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f6:	ff 4d 1c             	decl   0x1c(%ebp)
  8005f9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005fd:	7f e6                	jg     8005e5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ff:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800602:	bb 00 00 00 00       	mov    $0x0,%ebx
  800607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060d:	53                   	push   %ebx
  80060e:	51                   	push   %ecx
  80060f:	52                   	push   %edx
  800610:	50                   	push   %eax
  800611:	e8 ae 14 00 00       	call   801ac4 <__umoddi3>
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	05 f4 21 80 00       	add    $0x8021f4,%eax
  80061e:	8a 00                	mov    (%eax),%al
  800620:	0f be c0             	movsbl %al,%eax
  800623:	83 ec 08             	sub    $0x8,%esp
  800626:	ff 75 0c             	pushl  0xc(%ebp)
  800629:	50                   	push   %eax
  80062a:	8b 45 08             	mov    0x8(%ebp),%eax
  80062d:	ff d0                	call   *%eax
  80062f:	83 c4 10             	add    $0x10,%esp
}
  800632:	90                   	nop
  800633:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800636:	c9                   	leave  
  800637:	c3                   	ret    

00800638 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800638:	55                   	push   %ebp
  800639:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80063b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80063f:	7e 1c                	jle    80065d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	8b 00                	mov    (%eax),%eax
  800646:	8d 50 08             	lea    0x8(%eax),%edx
  800649:	8b 45 08             	mov    0x8(%ebp),%eax
  80064c:	89 10                	mov    %edx,(%eax)
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	83 e8 08             	sub    $0x8,%eax
  800656:	8b 50 04             	mov    0x4(%eax),%edx
  800659:	8b 00                	mov    (%eax),%eax
  80065b:	eb 40                	jmp    80069d <getuint+0x65>
	else if (lflag)
  80065d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800661:	74 1e                	je     800681 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800663:	8b 45 08             	mov    0x8(%ebp),%eax
  800666:	8b 00                	mov    (%eax),%eax
  800668:	8d 50 04             	lea    0x4(%eax),%edx
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	89 10                	mov    %edx,(%eax)
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	83 e8 04             	sub    $0x4,%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	ba 00 00 00 00       	mov    $0x0,%edx
  80067f:	eb 1c                	jmp    80069d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	8b 00                	mov    (%eax),%eax
  800686:	8d 50 04             	lea    0x4(%eax),%edx
  800689:	8b 45 08             	mov    0x8(%ebp),%eax
  80068c:	89 10                	mov    %edx,(%eax)
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	83 e8 04             	sub    $0x4,%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069d:	5d                   	pop    %ebp
  80069e:	c3                   	ret    

0080069f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80069f:	55                   	push   %ebp
  8006a0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a6:	7e 1c                	jle    8006c4 <getint+0x25>
		return va_arg(*ap, long long);
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	8d 50 08             	lea    0x8(%eax),%edx
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	89 10                	mov    %edx,(%eax)
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	83 e8 08             	sub    $0x8,%eax
  8006bd:	8b 50 04             	mov    0x4(%eax),%edx
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	eb 38                	jmp    8006fc <getint+0x5d>
	else if (lflag)
  8006c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c8:	74 1a                	je     8006e4 <getint+0x45>
		return va_arg(*ap, long);
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	8d 50 04             	lea    0x4(%eax),%edx
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	89 10                	mov    %edx,(%eax)
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	83 e8 04             	sub    $0x4,%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	99                   	cltd   
  8006e2:	eb 18                	jmp    8006fc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	8d 50 04             	lea    0x4(%eax),%edx
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	89 10                	mov    %edx,(%eax)
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	83 e8 04             	sub    $0x4,%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	99                   	cltd   
}
  8006fc:	5d                   	pop    %ebp
  8006fd:	c3                   	ret    

008006fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	56                   	push   %esi
  800702:	53                   	push   %ebx
  800703:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800706:	eb 17                	jmp    80071f <vprintfmt+0x21>
			if (ch == '\0')
  800708:	85 db                	test   %ebx,%ebx
  80070a:	0f 84 af 03 00 00    	je     800abf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	ff 75 0c             	pushl  0xc(%ebp)
  800716:	53                   	push   %ebx
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	ff d0                	call   *%eax
  80071c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071f:	8b 45 10             	mov    0x10(%ebp),%eax
  800722:	8d 50 01             	lea    0x1(%eax),%edx
  800725:	89 55 10             	mov    %edx,0x10(%ebp)
  800728:	8a 00                	mov    (%eax),%al
  80072a:	0f b6 d8             	movzbl %al,%ebx
  80072d:	83 fb 25             	cmp    $0x25,%ebx
  800730:	75 d6                	jne    800708 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800732:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800736:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80073d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800744:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80074b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800752:	8b 45 10             	mov    0x10(%ebp),%eax
  800755:	8d 50 01             	lea    0x1(%eax),%edx
  800758:	89 55 10             	mov    %edx,0x10(%ebp)
  80075b:	8a 00                	mov    (%eax),%al
  80075d:	0f b6 d8             	movzbl %al,%ebx
  800760:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800763:	83 f8 55             	cmp    $0x55,%eax
  800766:	0f 87 2b 03 00 00    	ja     800a97 <vprintfmt+0x399>
  80076c:	8b 04 85 18 22 80 00 	mov    0x802218(,%eax,4),%eax
  800773:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800775:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800779:	eb d7                	jmp    800752 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80077f:	eb d1                	jmp    800752 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800781:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800788:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80078b:	89 d0                	mov    %edx,%eax
  80078d:	c1 e0 02             	shl    $0x2,%eax
  800790:	01 d0                	add    %edx,%eax
  800792:	01 c0                	add    %eax,%eax
  800794:	01 d8                	add    %ebx,%eax
  800796:	83 e8 30             	sub    $0x30,%eax
  800799:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80079c:	8b 45 10             	mov    0x10(%ebp),%eax
  80079f:	8a 00                	mov    (%eax),%al
  8007a1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a4:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a7:	7e 3e                	jle    8007e7 <vprintfmt+0xe9>
  8007a9:	83 fb 39             	cmp    $0x39,%ebx
  8007ac:	7f 39                	jg     8007e7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ae:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b1:	eb d5                	jmp    800788 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	83 c0 04             	add    $0x4,%eax
  8007b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	83 e8 04             	sub    $0x4,%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c7:	eb 1f                	jmp    8007e8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007cd:	79 83                	jns    800752 <vprintfmt+0x54>
				width = 0;
  8007cf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d6:	e9 77 ff ff ff       	jmp    800752 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007db:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e2:	e9 6b ff ff ff       	jmp    800752 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ec:	0f 89 60 ff ff ff    	jns    800752 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007ff:	e9 4e ff ff ff       	jmp    800752 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800804:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800807:	e9 46 ff ff ff       	jmp    800752 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	83 c0 04             	add    $0x4,%eax
  800812:	89 45 14             	mov    %eax,0x14(%ebp)
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	83 e8 04             	sub    $0x4,%eax
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	50                   	push   %eax
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	ff d0                	call   *%eax
  800829:	83 c4 10             	add    $0x10,%esp
			break;
  80082c:	e9 89 02 00 00       	jmp    800aba <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	83 c0 04             	add    $0x4,%eax
  800837:	89 45 14             	mov    %eax,0x14(%ebp)
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	83 e8 04             	sub    $0x4,%eax
  800840:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800842:	85 db                	test   %ebx,%ebx
  800844:	79 02                	jns    800848 <vprintfmt+0x14a>
				err = -err;
  800846:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800848:	83 fb 64             	cmp    $0x64,%ebx
  80084b:	7f 0b                	jg     800858 <vprintfmt+0x15a>
  80084d:	8b 34 9d 60 20 80 00 	mov    0x802060(,%ebx,4),%esi
  800854:	85 f6                	test   %esi,%esi
  800856:	75 19                	jne    800871 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800858:	53                   	push   %ebx
  800859:	68 05 22 80 00       	push   $0x802205
  80085e:	ff 75 0c             	pushl  0xc(%ebp)
  800861:	ff 75 08             	pushl  0x8(%ebp)
  800864:	e8 5e 02 00 00       	call   800ac7 <printfmt>
  800869:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086c:	e9 49 02 00 00       	jmp    800aba <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800871:	56                   	push   %esi
  800872:	68 0e 22 80 00       	push   $0x80220e
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	ff 75 08             	pushl  0x8(%ebp)
  80087d:	e8 45 02 00 00       	call   800ac7 <printfmt>
  800882:	83 c4 10             	add    $0x10,%esp
			break;
  800885:	e9 30 02 00 00       	jmp    800aba <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	83 c0 04             	add    $0x4,%eax
  800890:	89 45 14             	mov    %eax,0x14(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	83 e8 04             	sub    $0x4,%eax
  800899:	8b 30                	mov    (%eax),%esi
  80089b:	85 f6                	test   %esi,%esi
  80089d:	75 05                	jne    8008a4 <vprintfmt+0x1a6>
				p = "(null)";
  80089f:	be 11 22 80 00       	mov    $0x802211,%esi
			if (width > 0 && padc != '-')
  8008a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a8:	7e 6d                	jle    800917 <vprintfmt+0x219>
  8008aa:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ae:	74 67                	je     800917 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	50                   	push   %eax
  8008b7:	56                   	push   %esi
  8008b8:	e8 0c 03 00 00       	call   800bc9 <strnlen>
  8008bd:	83 c4 10             	add    $0x10,%esp
  8008c0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c3:	eb 16                	jmp    8008db <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	ff 75 0c             	pushl  0xc(%ebp)
  8008cf:	50                   	push   %eax
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	ff d0                	call   *%eax
  8008d5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008df:	7f e4                	jg     8008c5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e1:	eb 34                	jmp    800917 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e7:	74 1c                	je     800905 <vprintfmt+0x207>
  8008e9:	83 fb 1f             	cmp    $0x1f,%ebx
  8008ec:	7e 05                	jle    8008f3 <vprintfmt+0x1f5>
  8008ee:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f1:	7e 12                	jle    800905 <vprintfmt+0x207>
					putch('?', putdat);
  8008f3:	83 ec 08             	sub    $0x8,%esp
  8008f6:	ff 75 0c             	pushl  0xc(%ebp)
  8008f9:	6a 3f                	push   $0x3f
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	ff d0                	call   *%eax
  800900:	83 c4 10             	add    $0x10,%esp
  800903:	eb 0f                	jmp    800914 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800905:	83 ec 08             	sub    $0x8,%esp
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	53                   	push   %ebx
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	ff d0                	call   *%eax
  800911:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800914:	ff 4d e4             	decl   -0x1c(%ebp)
  800917:	89 f0                	mov    %esi,%eax
  800919:	8d 70 01             	lea    0x1(%eax),%esi
  80091c:	8a 00                	mov    (%eax),%al
  80091e:	0f be d8             	movsbl %al,%ebx
  800921:	85 db                	test   %ebx,%ebx
  800923:	74 24                	je     800949 <vprintfmt+0x24b>
  800925:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800929:	78 b8                	js     8008e3 <vprintfmt+0x1e5>
  80092b:	ff 4d e0             	decl   -0x20(%ebp)
  80092e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800932:	79 af                	jns    8008e3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800934:	eb 13                	jmp    800949 <vprintfmt+0x24b>
				putch(' ', putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	6a 20                	push   $0x20
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	ff d0                	call   *%eax
  800943:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800946:	ff 4d e4             	decl   -0x1c(%ebp)
  800949:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094d:	7f e7                	jg     800936 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80094f:	e9 66 01 00 00       	jmp    800aba <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	ff 75 e8             	pushl  -0x18(%ebp)
  80095a:	8d 45 14             	lea    0x14(%ebp),%eax
  80095d:	50                   	push   %eax
  80095e:	e8 3c fd ff ff       	call   80069f <getint>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800969:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80096c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80096f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800972:	85 d2                	test   %edx,%edx
  800974:	79 23                	jns    800999 <vprintfmt+0x29b>
				putch('-', putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	6a 2d                	push   $0x2d
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	ff d0                	call   *%eax
  800983:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800989:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098c:	f7 d8                	neg    %eax
  80098e:	83 d2 00             	adc    $0x0,%edx
  800991:	f7 da                	neg    %edx
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800999:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a0:	e9 bc 00 00 00       	jmp    800a61 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a5:	83 ec 08             	sub    $0x8,%esp
  8009a8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ab:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ae:	50                   	push   %eax
  8009af:	e8 84 fc ff ff       	call   800638 <getuint>
  8009b4:	83 c4 10             	add    $0x10,%esp
  8009b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c4:	e9 98 00 00 00       	jmp    800a61 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009c9:	83 ec 08             	sub    $0x8,%esp
  8009cc:	ff 75 0c             	pushl  0xc(%ebp)
  8009cf:	6a 58                	push   $0x58
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	6a 58                	push   $0x58
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	ff d0                	call   *%eax
  8009e6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 58                	push   $0x58
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			break;
  8009f9:	e9 bc 00 00 00       	jmp    800aba <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	6a 30                	push   $0x30
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	ff d0                	call   *%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	6a 78                	push   $0x78
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	ff d0                	call   *%eax
  800a1b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a21:	83 c0 04             	add    $0x4,%eax
  800a24:	89 45 14             	mov    %eax,0x14(%ebp)
  800a27:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2a:	83 e8 04             	sub    $0x4,%eax
  800a2d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a39:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a40:	eb 1f                	jmp    800a61 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 e8             	pushl  -0x18(%ebp)
  800a48:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4b:	50                   	push   %eax
  800a4c:	e8 e7 fb ff ff       	call   800638 <getuint>
  800a51:	83 c4 10             	add    $0x10,%esp
  800a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a57:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a61:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a68:	83 ec 04             	sub    $0x4,%esp
  800a6b:	52                   	push   %edx
  800a6c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a6f:	50                   	push   %eax
  800a70:	ff 75 f4             	pushl  -0xc(%ebp)
  800a73:	ff 75 f0             	pushl  -0x10(%ebp)
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	ff 75 08             	pushl  0x8(%ebp)
  800a7c:	e8 00 fb ff ff       	call   800581 <printnum>
  800a81:	83 c4 20             	add    $0x20,%esp
			break;
  800a84:	eb 34                	jmp    800aba <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	53                   	push   %ebx
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	ff d0                	call   *%eax
  800a92:	83 c4 10             	add    $0x10,%esp
			break;
  800a95:	eb 23                	jmp    800aba <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	ff 75 0c             	pushl  0xc(%ebp)
  800a9d:	6a 25                	push   $0x25
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa7:	ff 4d 10             	decl   0x10(%ebp)
  800aaa:	eb 03                	jmp    800aaf <vprintfmt+0x3b1>
  800aac:	ff 4d 10             	decl   0x10(%ebp)
  800aaf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab2:	48                   	dec    %eax
  800ab3:	8a 00                	mov    (%eax),%al
  800ab5:	3c 25                	cmp    $0x25,%al
  800ab7:	75 f3                	jne    800aac <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ab9:	90                   	nop
		}
	}
  800aba:	e9 47 fc ff ff       	jmp    800706 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800abf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac3:	5b                   	pop    %ebx
  800ac4:	5e                   	pop    %esi
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800acd:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad0:	83 c0 04             	add    $0x4,%eax
  800ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad9:	ff 75 f4             	pushl  -0xc(%ebp)
  800adc:	50                   	push   %eax
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	ff 75 08             	pushl  0x8(%ebp)
  800ae3:	e8 16 fc ff ff       	call   8006fe <vprintfmt>
  800ae8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800aeb:	90                   	nop
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af4:	8b 40 08             	mov    0x8(%eax),%eax
  800af7:	8d 50 01             	lea    0x1(%eax),%edx
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 10                	mov    (%eax),%edx
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	8b 40 04             	mov    0x4(%eax),%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	73 12                	jae    800b21 <sprintputch+0x33>
		*b->buf++ = ch;
  800b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b12:	8b 00                	mov    (%eax),%eax
  800b14:	8d 48 01             	lea    0x1(%eax),%ecx
  800b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1a:	89 0a                	mov    %ecx,(%edx)
  800b1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1f:	88 10                	mov    %dl,(%eax)
}
  800b21:	90                   	nop
  800b22:	5d                   	pop    %ebp
  800b23:	c3                   	ret    

00800b24 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	01 d0                	add    %edx,%eax
  800b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b49:	74 06                	je     800b51 <vsnprintf+0x2d>
  800b4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4f:	7f 07                	jg     800b58 <vsnprintf+0x34>
		return -E_INVAL;
  800b51:	b8 03 00 00 00       	mov    $0x3,%eax
  800b56:	eb 20                	jmp    800b78 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b58:	ff 75 14             	pushl  0x14(%ebp)
  800b5b:	ff 75 10             	pushl  0x10(%ebp)
  800b5e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b61:	50                   	push   %eax
  800b62:	68 ee 0a 80 00       	push   $0x800aee
  800b67:	e8 92 fb ff ff       	call   8006fe <vprintfmt>
  800b6c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b72:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b78:	c9                   	leave  
  800b79:	c3                   	ret    

00800b7a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b80:	8d 45 10             	lea    0x10(%ebp),%eax
  800b83:	83 c0 04             	add    $0x4,%eax
  800b86:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b89:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8f:	50                   	push   %eax
  800b90:	ff 75 0c             	pushl  0xc(%ebp)
  800b93:	ff 75 08             	pushl  0x8(%ebp)
  800b96:	e8 89 ff ff ff       	call   800b24 <vsnprintf>
  800b9b:	83 c4 10             	add    $0x10,%esp
  800b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba4:	c9                   	leave  
  800ba5:	c3                   	ret    

00800ba6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb3:	eb 06                	jmp    800bbb <strlen+0x15>
		n++;
  800bb5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb8:	ff 45 08             	incl   0x8(%ebp)
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	8a 00                	mov    (%eax),%al
  800bc0:	84 c0                	test   %al,%al
  800bc2:	75 f1                	jne    800bb5 <strlen+0xf>
		n++;
	return n;
  800bc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc7:	c9                   	leave  
  800bc8:	c3                   	ret    

00800bc9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd6:	eb 09                	jmp    800be1 <strnlen+0x18>
		n++;
  800bd8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bdb:	ff 45 08             	incl   0x8(%ebp)
  800bde:	ff 4d 0c             	decl   0xc(%ebp)
  800be1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be5:	74 09                	je     800bf0 <strnlen+0x27>
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8a 00                	mov    (%eax),%al
  800bec:	84 c0                	test   %al,%al
  800bee:	75 e8                	jne    800bd8 <strnlen+0xf>
		n++;
	return n;
  800bf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf3:	c9                   	leave  
  800bf4:	c3                   	ret    

00800bf5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c01:	90                   	nop
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8d 50 01             	lea    0x1(%eax),%edx
  800c08:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c11:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c14:	8a 12                	mov    (%edx),%dl
  800c16:	88 10                	mov    %dl,(%eax)
  800c18:	8a 00                	mov    (%eax),%al
  800c1a:	84 c0                	test   %al,%al
  800c1c:	75 e4                	jne    800c02 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c21:	c9                   	leave  
  800c22:	c3                   	ret    

00800c23 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c36:	eb 1f                	jmp    800c57 <strncpy+0x34>
		*dst++ = *src;
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	8d 50 01             	lea    0x1(%eax),%edx
  800c3e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c44:	8a 12                	mov    (%edx),%dl
  800c46:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	84 c0                	test   %al,%al
  800c4f:	74 03                	je     800c54 <strncpy+0x31>
			src++;
  800c51:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c54:	ff 45 fc             	incl   -0x4(%ebp)
  800c57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c5d:	72 d9                	jb     800c38 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c62:	c9                   	leave  
  800c63:	c3                   	ret    

00800c64 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c74:	74 30                	je     800ca6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c76:	eb 16                	jmp    800c8e <strlcpy+0x2a>
			*dst++ = *src++;
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c84:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c87:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c8e:	ff 4d 10             	decl   0x10(%ebp)
  800c91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c95:	74 09                	je     800ca0 <strlcpy+0x3c>
  800c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9a:	8a 00                	mov    (%eax),%al
  800c9c:	84 c0                	test   %al,%al
  800c9e:	75 d8                	jne    800c78 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cac:	29 c2                	sub    %eax,%edx
  800cae:	89 d0                	mov    %edx,%eax
}
  800cb0:	c9                   	leave  
  800cb1:	c3                   	ret    

00800cb2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb5:	eb 06                	jmp    800cbd <strcmp+0xb>
		p++, q++;
  800cb7:	ff 45 08             	incl   0x8(%ebp)
  800cba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	84 c0                	test   %al,%al
  800cc4:	74 0e                	je     800cd4 <strcmp+0x22>
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8a 10                	mov    (%eax),%dl
  800ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	38 c2                	cmp    %al,%dl
  800cd2:	74 e3                	je     800cb7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	0f b6 d0             	movzbl %al,%edx
  800cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	0f b6 c0             	movzbl %al,%eax
  800ce4:	29 c2                	sub    %eax,%edx
  800ce6:	89 d0                	mov    %edx,%eax
}
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ced:	eb 09                	jmp    800cf8 <strncmp+0xe>
		n--, p++, q++;
  800cef:	ff 4d 10             	decl   0x10(%ebp)
  800cf2:	ff 45 08             	incl   0x8(%ebp)
  800cf5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfc:	74 17                	je     800d15 <strncmp+0x2b>
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	84 c0                	test   %al,%al
  800d05:	74 0e                	je     800d15 <strncmp+0x2b>
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8a 10                	mov    (%eax),%dl
  800d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	38 c2                	cmp    %al,%dl
  800d13:	74 da                	je     800cef <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d19:	75 07                	jne    800d22 <strncmp+0x38>
		return 0;
  800d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d20:	eb 14                	jmp    800d36 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	0f b6 d0             	movzbl %al,%edx
  800d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	0f b6 c0             	movzbl %al,%eax
  800d32:	29 c2                	sub    %eax,%edx
  800d34:	89 d0                	mov    %edx,%eax
}
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    

00800d38 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	83 ec 04             	sub    $0x4,%esp
  800d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d41:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d44:	eb 12                	jmp    800d58 <strchr+0x20>
		if (*s == c)
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4e:	75 05                	jne    800d55 <strchr+0x1d>
			return (char *) s;
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	eb 11                	jmp    800d66 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d55:	ff 45 08             	incl   0x8(%ebp)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	84 c0                	test   %al,%al
  800d5f:	75 e5                	jne    800d46 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	83 ec 04             	sub    $0x4,%esp
  800d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d71:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d74:	eb 0d                	jmp    800d83 <strfind+0x1b>
		if (*s == c)
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7e:	74 0e                	je     800d8e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d80:	ff 45 08             	incl   0x8(%ebp)
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	84 c0                	test   %al,%al
  800d8a:	75 ea                	jne    800d76 <strfind+0xe>
  800d8c:	eb 01                	jmp    800d8f <strfind+0x27>
		if (*s == c)
			break;
  800d8e:	90                   	nop
	return (char *) s;
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d92:	c9                   	leave  
  800d93:	c3                   	ret    

00800d94 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da0:	8b 45 10             	mov    0x10(%ebp),%eax
  800da3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da6:	eb 0e                	jmp    800db6 <memset+0x22>
		*p++ = c;
  800da8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dab:	8d 50 01             	lea    0x1(%eax),%edx
  800dae:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db6:	ff 4d f8             	decl   -0x8(%ebp)
  800db9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dbd:	79 e9                	jns    800da8 <memset+0x14>
		*p++ = c;

	return v;
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc2:	c9                   	leave  
  800dc3:	c3                   	ret    

00800dc4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd6:	eb 16                	jmp    800dee <memcpy+0x2a>
		*d++ = *s++;
  800dd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddb:	8d 50 01             	lea    0x1(%eax),%edx
  800dde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dea:	8a 12                	mov    (%edx),%dl
  800dec:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df4:	89 55 10             	mov    %edx,0x10(%ebp)
  800df7:	85 c0                	test   %eax,%eax
  800df9:	75 dd                	jne    800dd8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e15:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e18:	73 50                	jae    800e6a <memmove+0x6a>
  800e1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e20:	01 d0                	add    %edx,%eax
  800e22:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e25:	76 43                	jbe    800e6a <memmove+0x6a>
		s += n;
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e33:	eb 10                	jmp    800e45 <memmove+0x45>
			*--d = *--s;
  800e35:	ff 4d f8             	decl   -0x8(%ebp)
  800e38:	ff 4d fc             	decl   -0x4(%ebp)
  800e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3e:	8a 10                	mov    (%eax),%dl
  800e40:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e43:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	75 e3                	jne    800e35 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e52:	eb 23                	jmp    800e77 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e57:	8d 50 01             	lea    0x1(%eax),%edx
  800e5a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e60:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e63:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e66:	8a 12                	mov    (%edx),%dl
  800e68:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e70:	89 55 10             	mov    %edx,0x10(%ebp)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	75 dd                	jne    800e54 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7a:	c9                   	leave  
  800e7b:	c3                   	ret    

00800e7c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8e:	eb 2a                	jmp    800eba <memcmp+0x3e>
		if (*s1 != *s2)
  800e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e93:	8a 10                	mov    (%eax),%dl
  800e95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	38 c2                	cmp    %al,%dl
  800e9c:	74 16                	je     800eb4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	0f b6 d0             	movzbl %al,%edx
  800ea6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	0f b6 c0             	movzbl %al,%eax
  800eae:	29 c2                	sub    %eax,%edx
  800eb0:	89 d0                	mov    %edx,%eax
  800eb2:	eb 18                	jmp    800ecc <memcmp+0x50>
		s1++, s2++;
  800eb4:	ff 45 fc             	incl   -0x4(%ebp)
  800eb7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eba:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec3:	85 c0                	test   %eax,%eax
  800ec5:	75 c9                	jne    800e90 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecc:	c9                   	leave  
  800ecd:	c3                   	ret    

00800ece <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eda:	01 d0                	add    %edx,%eax
  800edc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800edf:	eb 15                	jmp    800ef6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	0f b6 d0             	movzbl %al,%edx
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	0f b6 c0             	movzbl %al,%eax
  800eef:	39 c2                	cmp    %eax,%edx
  800ef1:	74 0d                	je     800f00 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef3:	ff 45 08             	incl   0x8(%ebp)
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800efc:	72 e3                	jb     800ee1 <memfind+0x13>
  800efe:	eb 01                	jmp    800f01 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f00:	90                   	nop
	return (void *) s;
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f04:	c9                   	leave  
  800f05:	c3                   	ret    

00800f06 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f13:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1a:	eb 03                	jmp    800f1f <strtol+0x19>
		s++;
  800f1c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	3c 20                	cmp    $0x20,%al
  800f26:	74 f4                	je     800f1c <strtol+0x16>
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	3c 09                	cmp    $0x9,%al
  800f2f:	74 eb                	je     800f1c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 2b                	cmp    $0x2b,%al
  800f38:	75 05                	jne    800f3f <strtol+0x39>
		s++;
  800f3a:	ff 45 08             	incl   0x8(%ebp)
  800f3d:	eb 13                	jmp    800f52 <strtol+0x4c>
	else if (*s == '-')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 2d                	cmp    $0x2d,%al
  800f46:	75 0a                	jne    800f52 <strtol+0x4c>
		s++, neg = 1;
  800f48:	ff 45 08             	incl   0x8(%ebp)
  800f4b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f56:	74 06                	je     800f5e <strtol+0x58>
  800f58:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f5c:	75 20                	jne    800f7e <strtol+0x78>
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 30                	cmp    $0x30,%al
  800f65:	75 17                	jne    800f7e <strtol+0x78>
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	40                   	inc    %eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	3c 78                	cmp    $0x78,%al
  800f6f:	75 0d                	jne    800f7e <strtol+0x78>
		s += 2, base = 16;
  800f71:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f75:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f7c:	eb 28                	jmp    800fa6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f82:	75 15                	jne    800f99 <strtol+0x93>
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	3c 30                	cmp    $0x30,%al
  800f8b:	75 0c                	jne    800f99 <strtol+0x93>
		s++, base = 8;
  800f8d:	ff 45 08             	incl   0x8(%ebp)
  800f90:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f97:	eb 0d                	jmp    800fa6 <strtol+0xa0>
	else if (base == 0)
  800f99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9d:	75 07                	jne    800fa6 <strtol+0xa0>
		base = 10;
  800f9f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	3c 2f                	cmp    $0x2f,%al
  800fad:	7e 19                	jle    800fc8 <strtol+0xc2>
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	3c 39                	cmp    $0x39,%al
  800fb6:	7f 10                	jg     800fc8 <strtol+0xc2>
			dig = *s - '0';
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	0f be c0             	movsbl %al,%eax
  800fc0:	83 e8 30             	sub    $0x30,%eax
  800fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc6:	eb 42                	jmp    80100a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3c 60                	cmp    $0x60,%al
  800fcf:	7e 19                	jle    800fea <strtol+0xe4>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 7a                	cmp    $0x7a,%al
  800fd8:	7f 10                	jg     800fea <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	0f be c0             	movsbl %al,%eax
  800fe2:	83 e8 57             	sub    $0x57,%eax
  800fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe8:	eb 20                	jmp    80100a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	3c 40                	cmp    $0x40,%al
  800ff1:	7e 39                	jle    80102c <strtol+0x126>
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	3c 5a                	cmp    $0x5a,%al
  800ffa:	7f 30                	jg     80102c <strtol+0x126>
			dig = *s - 'A' + 10;
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	0f be c0             	movsbl %al,%eax
  801004:	83 e8 37             	sub    $0x37,%eax
  801007:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80100a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801010:	7d 19                	jge    80102b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801012:	ff 45 08             	incl   0x8(%ebp)
  801015:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801018:	0f af 45 10          	imul   0x10(%ebp),%eax
  80101c:	89 c2                	mov    %eax,%edx
  80101e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801021:	01 d0                	add    %edx,%eax
  801023:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801026:	e9 7b ff ff ff       	jmp    800fa6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80102b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80102c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801030:	74 08                	je     80103a <strtol+0x134>
		*endptr = (char *) s;
  801032:	8b 45 0c             	mov    0xc(%ebp),%eax
  801035:	8b 55 08             	mov    0x8(%ebp),%edx
  801038:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80103a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103e:	74 07                	je     801047 <strtol+0x141>
  801040:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801043:	f7 d8                	neg    %eax
  801045:	eb 03                	jmp    80104a <strtol+0x144>
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80104a:	c9                   	leave  
  80104b:	c3                   	ret    

0080104c <ltostr>:

void
ltostr(long value, char *str)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801052:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801059:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801060:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801064:	79 13                	jns    801079 <ltostr+0x2d>
	{
		neg = 1;
  801066:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801073:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801076:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801081:	99                   	cltd   
  801082:	f7 f9                	idiv   %ecx
  801084:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801087:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108a:	8d 50 01             	lea    0x1(%eax),%edx
  80108d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801090:	89 c2                	mov    %eax,%edx
  801092:	8b 45 0c             	mov    0xc(%ebp),%eax
  801095:	01 d0                	add    %edx,%eax
  801097:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80109a:	83 c2 30             	add    $0x30,%edx
  80109d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80109f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a7:	f7 e9                	imul   %ecx
  8010a9:	c1 fa 02             	sar    $0x2,%edx
  8010ac:	89 c8                	mov    %ecx,%eax
  8010ae:	c1 f8 1f             	sar    $0x1f,%eax
  8010b1:	29 c2                	sub    %eax,%edx
  8010b3:	89 d0                	mov    %edx,%eax
  8010b5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c0:	f7 e9                	imul   %ecx
  8010c2:	c1 fa 02             	sar    $0x2,%edx
  8010c5:	89 c8                	mov    %ecx,%eax
  8010c7:	c1 f8 1f             	sar    $0x1f,%eax
  8010ca:	29 c2                	sub    %eax,%edx
  8010cc:	89 d0                	mov    %edx,%eax
  8010ce:	c1 e0 02             	shl    $0x2,%eax
  8010d1:	01 d0                	add    %edx,%eax
  8010d3:	01 c0                	add    %eax,%eax
  8010d5:	29 c1                	sub    %eax,%ecx
  8010d7:	89 ca                	mov    %ecx,%edx
  8010d9:	85 d2                	test   %edx,%edx
  8010db:	75 9c                	jne    801079 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e7:	48                   	dec    %eax
  8010e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010ef:	74 3d                	je     80112e <ltostr+0xe2>
		start = 1 ;
  8010f1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f8:	eb 34                	jmp    80112e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	01 d0                	add    %edx,%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801107:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	01 c2                	add    %eax,%edx
  80110f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	01 c8                	add    %ecx,%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80111b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	01 c2                	add    %eax,%edx
  801123:	8a 45 eb             	mov    -0x15(%ebp),%al
  801126:	88 02                	mov    %al,(%edx)
		start++ ;
  801128:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80112b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801131:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801134:	7c c4                	jl     8010fa <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801136:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113c:	01 d0                	add    %edx,%eax
  80113e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801141:	90                   	nop
  801142:	c9                   	leave  
  801143:	c3                   	ret    

00801144 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80114a:	ff 75 08             	pushl  0x8(%ebp)
  80114d:	e8 54 fa ff ff       	call   800ba6 <strlen>
  801152:	83 c4 04             	add    $0x4,%esp
  801155:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801158:	ff 75 0c             	pushl  0xc(%ebp)
  80115b:	e8 46 fa ff ff       	call   800ba6 <strlen>
  801160:	83 c4 04             	add    $0x4,%esp
  801163:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801166:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801174:	eb 17                	jmp    80118d <strcconcat+0x49>
		final[s] = str1[s] ;
  801176:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801179:	8b 45 10             	mov    0x10(%ebp),%eax
  80117c:	01 c2                	add    %eax,%edx
  80117e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	01 c8                	add    %ecx,%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80118a:	ff 45 fc             	incl   -0x4(%ebp)
  80118d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801190:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801193:	7c e1                	jl     801176 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801195:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80119c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a3:	eb 1f                	jmp    8011c4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a8:	8d 50 01             	lea    0x1(%eax),%edx
  8011ab:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ae:	89 c2                	mov    %eax,%edx
  8011b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b3:	01 c2                	add    %eax,%edx
  8011b5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bb:	01 c8                	add    %ecx,%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c1:	ff 45 f8             	incl   -0x8(%ebp)
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ca:	7c d9                	jl     8011a5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d2:	01 d0                	add    %edx,%eax
  8011d4:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d7:	90                   	nop
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e9:	8b 00                	mov    (%eax),%eax
  8011eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 d0                	add    %edx,%eax
  8011f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fd:	eb 0c                	jmp    80120b <strsplit+0x31>
			*string++ = 0;
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8d 50 01             	lea    0x1(%eax),%edx
  801205:	89 55 08             	mov    %edx,0x8(%ebp)
  801208:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	84 c0                	test   %al,%al
  801212:	74 18                	je     80122c <strsplit+0x52>
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	8a 00                	mov    (%eax),%al
  801219:	0f be c0             	movsbl %al,%eax
  80121c:	50                   	push   %eax
  80121d:	ff 75 0c             	pushl  0xc(%ebp)
  801220:	e8 13 fb ff ff       	call   800d38 <strchr>
  801225:	83 c4 08             	add    $0x8,%esp
  801228:	85 c0                	test   %eax,%eax
  80122a:	75 d3                	jne    8011ff <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	84 c0                	test   %al,%al
  801233:	74 5a                	je     80128f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801235:	8b 45 14             	mov    0x14(%ebp),%eax
  801238:	8b 00                	mov    (%eax),%eax
  80123a:	83 f8 0f             	cmp    $0xf,%eax
  80123d:	75 07                	jne    801246 <strsplit+0x6c>
		{
			return 0;
  80123f:	b8 00 00 00 00       	mov    $0x0,%eax
  801244:	eb 66                	jmp    8012ac <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801246:	8b 45 14             	mov    0x14(%ebp),%eax
  801249:	8b 00                	mov    (%eax),%eax
  80124b:	8d 48 01             	lea    0x1(%eax),%ecx
  80124e:	8b 55 14             	mov    0x14(%ebp),%edx
  801251:	89 0a                	mov    %ecx,(%edx)
  801253:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125a:	8b 45 10             	mov    0x10(%ebp),%eax
  80125d:	01 c2                	add    %eax,%edx
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801264:	eb 03                	jmp    801269 <strsplit+0x8f>
			string++;
  801266:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	84 c0                	test   %al,%al
  801270:	74 8b                	je     8011fd <strsplit+0x23>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	0f be c0             	movsbl %al,%eax
  80127a:	50                   	push   %eax
  80127b:	ff 75 0c             	pushl  0xc(%ebp)
  80127e:	e8 b5 fa ff ff       	call   800d38 <strchr>
  801283:	83 c4 08             	add    $0x8,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	74 dc                	je     801266 <strsplit+0x8c>
			string++;
	}
  80128a:	e9 6e ff ff ff       	jmp    8011fd <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80128f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801290:	8b 45 14             	mov    0x14(%ebp),%eax
  801293:	8b 00                	mov    (%eax),%eax
  801295:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	01 d0                	add    %edx,%eax
  8012a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8012b4:	83 ec 04             	sub    $0x4,%esp
  8012b7:	68 70 23 80 00       	push   $0x802370
  8012bc:	6a 19                	push   $0x19
  8012be:	68 95 23 80 00       	push   $0x802395
  8012c3:	e8 ba ef ff ff       	call   800282 <_panic>

008012c8 <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	83 ec 18             	sub    $0x18,%esp
  8012ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d1:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8012d4:	83 ec 04             	sub    $0x4,%esp
  8012d7:	68 a4 23 80 00       	push   $0x8023a4
  8012dc:	6a 31                	push   $0x31
  8012de:	68 95 23 80 00       	push   $0x802395
  8012e3:	e8 9a ef ff ff       	call   800282 <_panic>

008012e8 <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 cc 23 80 00       	push   $0x8023cc
  8012f6:	6a 4a                	push   $0x4a
  8012f8:	68 95 23 80 00       	push   $0x802395
  8012fd:	e8 80 ef ff ff       	call   800282 <_panic>

00801302 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801308:	83 ec 04             	sub    $0x4,%esp
  80130b:	68 f0 23 80 00       	push   $0x8023f0
  801310:	6a 70                	push   $0x70
  801312:	68 95 23 80 00       	push   $0x802395
  801317:	e8 66 ef ff ff       	call   800282 <_panic>

0080131c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801322:	83 ec 04             	sub    $0x4,%esp
  801325:	68 14 24 80 00       	push   $0x802414
  80132a:	68 8b 00 00 00       	push   $0x8b
  80132f:	68 95 23 80 00       	push   $0x802395
  801334:	e8 49 ef ff ff       	call   800282 <_panic>

00801339 <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80133f:	83 ec 04             	sub    $0x4,%esp
  801342:	68 38 24 80 00       	push   $0x802438
  801347:	68 a8 00 00 00       	push   $0xa8
  80134c:	68 95 23 80 00       	push   $0x802395
  801351:	e8 2c ef ff ff       	call   800282 <_panic>

00801356 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	57                   	push   %edi
  80135a:	56                   	push   %esi
  80135b:	53                   	push   %ebx
  80135c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8b 55 0c             	mov    0xc(%ebp),%edx
  801365:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801368:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80136b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80136e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801371:	cd 30                	int    $0x30
  801373:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801376:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801379:	83 c4 10             	add    $0x10,%esp
  80137c:	5b                   	pop    %ebx
  80137d:	5e                   	pop    %esi
  80137e:	5f                   	pop    %edi
  80137f:	5d                   	pop    %ebp
  801380:	c3                   	ret    

00801381 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	83 ec 04             	sub    $0x4,%esp
  801387:	8b 45 10             	mov    0x10(%ebp),%eax
  80138a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80138d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	52                   	push   %edx
  801399:	ff 75 0c             	pushl  0xc(%ebp)
  80139c:	50                   	push   %eax
  80139d:	6a 00                	push   $0x0
  80139f:	e8 b2 ff ff ff       	call   801356 <syscall>
  8013a4:	83 c4 18             	add    $0x18,%esp
}
  8013a7:	90                   	nop
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <sys_cgetc>:

int
sys_cgetc(void)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 01                	push   $0x1
  8013b9:	e8 98 ff ff ff       	call   801356 <syscall>
  8013be:	83 c4 18             	add    $0x18,%esp
}
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	50                   	push   %eax
  8013d2:	6a 05                	push   $0x5
  8013d4:	e8 7d ff ff ff       	call   801356 <syscall>
  8013d9:	83 c4 18             	add    $0x18,%esp
}
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 02                	push   $0x2
  8013ed:	e8 64 ff ff ff       	call   801356 <syscall>
  8013f2:	83 c4 18             	add    $0x18,%esp
}
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 03                	push   $0x3
  801406:	e8 4b ff ff ff       	call   801356 <syscall>
  80140b:	83 c4 18             	add    $0x18,%esp
}
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 04                	push   $0x4
  80141f:	e8 32 ff ff ff       	call   801356 <syscall>
  801424:	83 c4 18             	add    $0x18,%esp
}
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <sys_env_exit>:


void sys_env_exit(void)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 06                	push   $0x6
  801438:	e8 19 ff ff ff       	call   801356 <syscall>
  80143d:	83 c4 18             	add    $0x18,%esp
}
  801440:	90                   	nop
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801446:	8b 55 0c             	mov    0xc(%ebp),%edx
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	52                   	push   %edx
  801453:	50                   	push   %eax
  801454:	6a 07                	push   $0x7
  801456:	e8 fb fe ff ff       	call   801356 <syscall>
  80145b:	83 c4 18             	add    $0x18,%esp
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	56                   	push   %esi
  801464:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801465:	8b 75 18             	mov    0x18(%ebp),%esi
  801468:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80146b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80146e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	56                   	push   %esi
  801475:	53                   	push   %ebx
  801476:	51                   	push   %ecx
  801477:	52                   	push   %edx
  801478:	50                   	push   %eax
  801479:	6a 08                	push   $0x8
  80147b:	e8 d6 fe ff ff       	call   801356 <syscall>
  801480:	83 c4 18             	add    $0x18,%esp
}
  801483:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801486:	5b                   	pop    %ebx
  801487:	5e                   	pop    %esi
  801488:	5d                   	pop    %ebp
  801489:	c3                   	ret    

0080148a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80148d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	52                   	push   %edx
  80149a:	50                   	push   %eax
  80149b:	6a 09                	push   $0x9
  80149d:	e8 b4 fe ff ff       	call   801356 <syscall>
  8014a2:	83 c4 18             	add    $0x18,%esp
}
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    

008014a7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	6a 0a                	push   $0xa
  8014b8:	e8 99 fe ff ff       	call   801356 <syscall>
  8014bd:	83 c4 18             	add    $0x18,%esp
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 0b                	push   $0xb
  8014d1:	e8 80 fe ff ff       	call   801356 <syscall>
  8014d6:	83 c4 18             	add    $0x18,%esp
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 0c                	push   $0xc
  8014ea:	e8 67 fe ff ff       	call   801356 <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 0d                	push   $0xd
  801503:	e8 4e fe ff ff       	call   801356 <syscall>
  801508:	83 c4 18             	add    $0x18,%esp
}
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	ff 75 0c             	pushl  0xc(%ebp)
  801519:	ff 75 08             	pushl  0x8(%ebp)
  80151c:	6a 11                	push   $0x11
  80151e:	e8 33 fe ff ff       	call   801356 <syscall>
  801523:	83 c4 18             	add    $0x18,%esp
	return;
  801526:	90                   	nop
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	ff 75 0c             	pushl  0xc(%ebp)
  801535:	ff 75 08             	pushl  0x8(%ebp)
  801538:	6a 12                	push   $0x12
  80153a:	e8 17 fe ff ff       	call   801356 <syscall>
  80153f:	83 c4 18             	add    $0x18,%esp
	return ;
  801542:	90                   	nop
}
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 0e                	push   $0xe
  801554:	e8 fd fd ff ff       	call   801356 <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	ff 75 08             	pushl  0x8(%ebp)
  80156c:	6a 0f                	push   $0xf
  80156e:	e8 e3 fd ff ff       	call   801356 <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 10                	push   $0x10
  801587:	e8 ca fd ff ff       	call   801356 <syscall>
  80158c:	83 c4 18             	add    $0x18,%esp
}
  80158f:	90                   	nop
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 14                	push   $0x14
  8015a1:	e8 b0 fd ff ff       	call   801356 <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	90                   	nop
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 15                	push   $0x15
  8015bb:	e8 96 fd ff ff       	call   801356 <syscall>
  8015c0:	83 c4 18             	add    $0x18,%esp
}
  8015c3:	90                   	nop
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	83 ec 04             	sub    $0x4,%esp
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	50                   	push   %eax
  8015df:	6a 16                	push   $0x16
  8015e1:	e8 70 fd ff ff       	call   801356 <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
}
  8015e9:	90                   	nop
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 17                	push   $0x17
  8015fb:	e8 56 fd ff ff       	call   801356 <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
}
  801603:	90                   	nop
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	ff 75 0c             	pushl  0xc(%ebp)
  801615:	50                   	push   %eax
  801616:	6a 18                	push   $0x18
  801618:	e8 39 fd ff ff       	call   801356 <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801625:	8b 55 0c             	mov    0xc(%ebp),%edx
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	52                   	push   %edx
  801632:	50                   	push   %eax
  801633:	6a 1b                	push   $0x1b
  801635:	e8 1c fd ff ff       	call   801356 <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801642:	8b 55 0c             	mov    0xc(%ebp),%edx
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	52                   	push   %edx
  80164f:	50                   	push   %eax
  801650:	6a 19                	push   $0x19
  801652:	e8 ff fc ff ff       	call   801356 <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
}
  80165a:	90                   	nop
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801660:	8b 55 0c             	mov    0xc(%ebp),%edx
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	52                   	push   %edx
  80166d:	50                   	push   %eax
  80166e:	6a 1a                	push   $0x1a
  801670:	e8 e1 fc ff ff       	call   801356 <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
}
  801678:	90                   	nop
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 04             	sub    $0x4,%esp
  801681:	8b 45 10             	mov    0x10(%ebp),%eax
  801684:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801687:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80168a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	6a 00                	push   $0x0
  801693:	51                   	push   %ecx
  801694:	52                   	push   %edx
  801695:	ff 75 0c             	pushl  0xc(%ebp)
  801698:	50                   	push   %eax
  801699:	6a 1c                	push   $0x1c
  80169b:	e8 b6 fc ff ff       	call   801356 <syscall>
  8016a0:	83 c4 18             	add    $0x18,%esp
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	52                   	push   %edx
  8016b5:	50                   	push   %eax
  8016b6:	6a 1d                	push   $0x1d
  8016b8:	e8 99 fc ff ff       	call   801356 <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	51                   	push   %ecx
  8016d3:	52                   	push   %edx
  8016d4:	50                   	push   %eax
  8016d5:	6a 1e                	push   $0x1e
  8016d7:	e8 7a fc ff ff       	call   801356 <syscall>
  8016dc:	83 c4 18             	add    $0x18,%esp
}
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	52                   	push   %edx
  8016f1:	50                   	push   %eax
  8016f2:	6a 1f                	push   $0x1f
  8016f4:	e8 5d fc ff ff       	call   801356 <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 20                	push   $0x20
  80170d:	e8 44 fc ff ff       	call   801356 <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	ff 75 10             	pushl  0x10(%ebp)
  801724:	ff 75 0c             	pushl  0xc(%ebp)
  801727:	50                   	push   %eax
  801728:	6a 21                	push   $0x21
  80172a:	e8 27 fc ff ff       	call   801356 <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	50                   	push   %eax
  801743:	6a 22                	push   $0x22
  801745:	e8 0c fc ff ff       	call   801356 <syscall>
  80174a:	83 c4 18             	add    $0x18,%esp
}
  80174d:	90                   	nop
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	50                   	push   %eax
  80175f:	6a 23                	push   $0x23
  801761:	e8 f0 fb ff ff       	call   801356 <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	90                   	nop
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801772:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801775:	8d 50 04             	lea    0x4(%eax),%edx
  801778:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	52                   	push   %edx
  801782:	50                   	push   %eax
  801783:	6a 24                	push   $0x24
  801785:	e8 cc fb ff ff       	call   801356 <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
	return result;
  80178d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801790:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801793:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801796:	89 01                	mov    %eax,(%ecx)
  801798:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	c9                   	leave  
  80179f:	c2 04 00             	ret    $0x4

008017a2 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	ff 75 10             	pushl  0x10(%ebp)
  8017ac:	ff 75 0c             	pushl  0xc(%ebp)
  8017af:	ff 75 08             	pushl  0x8(%ebp)
  8017b2:	6a 13                	push   $0x13
  8017b4:	e8 9d fb ff ff       	call   801356 <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017bc:	90                   	nop
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <sys_rcr2>:
uint32 sys_rcr2()
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 25                	push   $0x25
  8017ce:	e8 83 fb ff ff       	call   801356 <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	83 ec 04             	sub    $0x4,%esp
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017e4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	50                   	push   %eax
  8017f1:	6a 26                	push   $0x26
  8017f3:	e8 5e fb ff ff       	call   801356 <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017fb:	90                   	nop
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <rsttst>:
void rsttst()
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 28                	push   $0x28
  80180d:	e8 44 fb ff ff       	call   801356 <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
	return ;
  801815:	90                   	nop
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 04             	sub    $0x4,%esp
  80181e:	8b 45 14             	mov    0x14(%ebp),%eax
  801821:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801824:	8b 55 18             	mov    0x18(%ebp),%edx
  801827:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80182b:	52                   	push   %edx
  80182c:	50                   	push   %eax
  80182d:	ff 75 10             	pushl  0x10(%ebp)
  801830:	ff 75 0c             	pushl  0xc(%ebp)
  801833:	ff 75 08             	pushl  0x8(%ebp)
  801836:	6a 27                	push   $0x27
  801838:	e8 19 fb ff ff       	call   801356 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
	return ;
  801840:	90                   	nop
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <chktst>:
void chktst(uint32 n)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	ff 75 08             	pushl  0x8(%ebp)
  801851:	6a 29                	push   $0x29
  801853:	e8 fe fa ff ff       	call   801356 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
	return ;
  80185b:	90                   	nop
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <inctst>:

void inctst()
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 2a                	push   $0x2a
  80186d:	e8 e4 fa ff ff       	call   801356 <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
	return ;
  801875:	90                   	nop
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <gettst>:
uint32 gettst()
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 2b                	push   $0x2b
  801887:	e8 ca fa ff ff       	call   801356 <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 2c                	push   $0x2c
  8018a3:	e8 ae fa ff ff       	call   801356 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
  8018ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018ae:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018b2:	75 07                	jne    8018bb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8018b9:	eb 05                	jmp    8018c0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
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
  8018d4:	e8 7d fa ff ff       	call   801356 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
  8018dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8018df:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8018e3:	75 07                	jne    8018ec <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8018e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ea:	eb 05                	jmp    8018f1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8018ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  801905:	e8 4c fa ff ff       	call   801356 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
  80190d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801910:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801914:	75 07                	jne    80191d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801916:	b8 01 00 00 00       	mov    $0x1,%eax
  80191b:	eb 05                	jmp    801922 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80191d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801936:	e8 1b fa ff ff       	call   801356 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
  80193e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801941:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801945:	75 07                	jne    80194e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801947:	b8 01 00 00 00       	mov    $0x1,%eax
  80194c:	eb 05                	jmp    801953 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80194e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	ff 75 08             	pushl  0x8(%ebp)
  801963:	6a 2d                	push   $0x2d
  801965:	e8 ec f9 ff ff       	call   801356 <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
	return ;
  80196d:	90                   	nop
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801974:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801977:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	53                   	push   %ebx
  801983:	51                   	push   %ecx
  801984:	52                   	push   %edx
  801985:	50                   	push   %eax
  801986:	6a 2e                	push   $0x2e
  801988:	e8 c9 f9 ff ff       	call   801356 <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801998:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	52                   	push   %edx
  8019a5:	50                   	push   %eax
  8019a6:	6a 2f                	push   $0x2f
  8019a8:	e8 a9 f9 ff ff       	call   801356 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    
  8019b2:	66 90                	xchg   %ax,%ax

008019b4 <__udivdi3>:
  8019b4:	55                   	push   %ebp
  8019b5:	57                   	push   %edi
  8019b6:	56                   	push   %esi
  8019b7:	53                   	push   %ebx
  8019b8:	83 ec 1c             	sub    $0x1c,%esp
  8019bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019cb:	89 ca                	mov    %ecx,%edx
  8019cd:	89 f8                	mov    %edi,%eax
  8019cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019d3:	85 f6                	test   %esi,%esi
  8019d5:	75 2d                	jne    801a04 <__udivdi3+0x50>
  8019d7:	39 cf                	cmp    %ecx,%edi
  8019d9:	77 65                	ja     801a40 <__udivdi3+0x8c>
  8019db:	89 fd                	mov    %edi,%ebp
  8019dd:	85 ff                	test   %edi,%edi
  8019df:	75 0b                	jne    8019ec <__udivdi3+0x38>
  8019e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e6:	31 d2                	xor    %edx,%edx
  8019e8:	f7 f7                	div    %edi
  8019ea:	89 c5                	mov    %eax,%ebp
  8019ec:	31 d2                	xor    %edx,%edx
  8019ee:	89 c8                	mov    %ecx,%eax
  8019f0:	f7 f5                	div    %ebp
  8019f2:	89 c1                	mov    %eax,%ecx
  8019f4:	89 d8                	mov    %ebx,%eax
  8019f6:	f7 f5                	div    %ebp
  8019f8:	89 cf                	mov    %ecx,%edi
  8019fa:	89 fa                	mov    %edi,%edx
  8019fc:	83 c4 1c             	add    $0x1c,%esp
  8019ff:	5b                   	pop    %ebx
  801a00:	5e                   	pop    %esi
  801a01:	5f                   	pop    %edi
  801a02:	5d                   	pop    %ebp
  801a03:	c3                   	ret    
  801a04:	39 ce                	cmp    %ecx,%esi
  801a06:	77 28                	ja     801a30 <__udivdi3+0x7c>
  801a08:	0f bd fe             	bsr    %esi,%edi
  801a0b:	83 f7 1f             	xor    $0x1f,%edi
  801a0e:	75 40                	jne    801a50 <__udivdi3+0x9c>
  801a10:	39 ce                	cmp    %ecx,%esi
  801a12:	72 0a                	jb     801a1e <__udivdi3+0x6a>
  801a14:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a18:	0f 87 9e 00 00 00    	ja     801abc <__udivdi3+0x108>
  801a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a23:	89 fa                	mov    %edi,%edx
  801a25:	83 c4 1c             	add    $0x1c,%esp
  801a28:	5b                   	pop    %ebx
  801a29:	5e                   	pop    %esi
  801a2a:	5f                   	pop    %edi
  801a2b:	5d                   	pop    %ebp
  801a2c:	c3                   	ret    
  801a2d:	8d 76 00             	lea    0x0(%esi),%esi
  801a30:	31 ff                	xor    %edi,%edi
  801a32:	31 c0                	xor    %eax,%eax
  801a34:	89 fa                	mov    %edi,%edx
  801a36:	83 c4 1c             	add    $0x1c,%esp
  801a39:	5b                   	pop    %ebx
  801a3a:	5e                   	pop    %esi
  801a3b:	5f                   	pop    %edi
  801a3c:	5d                   	pop    %ebp
  801a3d:	c3                   	ret    
  801a3e:	66 90                	xchg   %ax,%ax
  801a40:	89 d8                	mov    %ebx,%eax
  801a42:	f7 f7                	div    %edi
  801a44:	31 ff                	xor    %edi,%edi
  801a46:	89 fa                	mov    %edi,%edx
  801a48:	83 c4 1c             	add    $0x1c,%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5f                   	pop    %edi
  801a4e:	5d                   	pop    %ebp
  801a4f:	c3                   	ret    
  801a50:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a55:	89 eb                	mov    %ebp,%ebx
  801a57:	29 fb                	sub    %edi,%ebx
  801a59:	89 f9                	mov    %edi,%ecx
  801a5b:	d3 e6                	shl    %cl,%esi
  801a5d:	89 c5                	mov    %eax,%ebp
  801a5f:	88 d9                	mov    %bl,%cl
  801a61:	d3 ed                	shr    %cl,%ebp
  801a63:	89 e9                	mov    %ebp,%ecx
  801a65:	09 f1                	or     %esi,%ecx
  801a67:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a6b:	89 f9                	mov    %edi,%ecx
  801a6d:	d3 e0                	shl    %cl,%eax
  801a6f:	89 c5                	mov    %eax,%ebp
  801a71:	89 d6                	mov    %edx,%esi
  801a73:	88 d9                	mov    %bl,%cl
  801a75:	d3 ee                	shr    %cl,%esi
  801a77:	89 f9                	mov    %edi,%ecx
  801a79:	d3 e2                	shl    %cl,%edx
  801a7b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a7f:	88 d9                	mov    %bl,%cl
  801a81:	d3 e8                	shr    %cl,%eax
  801a83:	09 c2                	or     %eax,%edx
  801a85:	89 d0                	mov    %edx,%eax
  801a87:	89 f2                	mov    %esi,%edx
  801a89:	f7 74 24 0c          	divl   0xc(%esp)
  801a8d:	89 d6                	mov    %edx,%esi
  801a8f:	89 c3                	mov    %eax,%ebx
  801a91:	f7 e5                	mul    %ebp
  801a93:	39 d6                	cmp    %edx,%esi
  801a95:	72 19                	jb     801ab0 <__udivdi3+0xfc>
  801a97:	74 0b                	je     801aa4 <__udivdi3+0xf0>
  801a99:	89 d8                	mov    %ebx,%eax
  801a9b:	31 ff                	xor    %edi,%edi
  801a9d:	e9 58 ff ff ff       	jmp    8019fa <__udivdi3+0x46>
  801aa2:	66 90                	xchg   %ax,%ax
  801aa4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801aa8:	89 f9                	mov    %edi,%ecx
  801aaa:	d3 e2                	shl    %cl,%edx
  801aac:	39 c2                	cmp    %eax,%edx
  801aae:	73 e9                	jae    801a99 <__udivdi3+0xe5>
  801ab0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ab3:	31 ff                	xor    %edi,%edi
  801ab5:	e9 40 ff ff ff       	jmp    8019fa <__udivdi3+0x46>
  801aba:	66 90                	xchg   %ax,%ax
  801abc:	31 c0                	xor    %eax,%eax
  801abe:	e9 37 ff ff ff       	jmp    8019fa <__udivdi3+0x46>
  801ac3:	90                   	nop

00801ac4 <__umoddi3>:
  801ac4:	55                   	push   %ebp
  801ac5:	57                   	push   %edi
  801ac6:	56                   	push   %esi
  801ac7:	53                   	push   %ebx
  801ac8:	83 ec 1c             	sub    $0x1c,%esp
  801acb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801acf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ad3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ad7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801adb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801adf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ae3:	89 f3                	mov    %esi,%ebx
  801ae5:	89 fa                	mov    %edi,%edx
  801ae7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aeb:	89 34 24             	mov    %esi,(%esp)
  801aee:	85 c0                	test   %eax,%eax
  801af0:	75 1a                	jne    801b0c <__umoddi3+0x48>
  801af2:	39 f7                	cmp    %esi,%edi
  801af4:	0f 86 a2 00 00 00    	jbe    801b9c <__umoddi3+0xd8>
  801afa:	89 c8                	mov    %ecx,%eax
  801afc:	89 f2                	mov    %esi,%edx
  801afe:	f7 f7                	div    %edi
  801b00:	89 d0                	mov    %edx,%eax
  801b02:	31 d2                	xor    %edx,%edx
  801b04:	83 c4 1c             	add    $0x1c,%esp
  801b07:	5b                   	pop    %ebx
  801b08:	5e                   	pop    %esi
  801b09:	5f                   	pop    %edi
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    
  801b0c:	39 f0                	cmp    %esi,%eax
  801b0e:	0f 87 ac 00 00 00    	ja     801bc0 <__umoddi3+0xfc>
  801b14:	0f bd e8             	bsr    %eax,%ebp
  801b17:	83 f5 1f             	xor    $0x1f,%ebp
  801b1a:	0f 84 ac 00 00 00    	je     801bcc <__umoddi3+0x108>
  801b20:	bf 20 00 00 00       	mov    $0x20,%edi
  801b25:	29 ef                	sub    %ebp,%edi
  801b27:	89 fe                	mov    %edi,%esi
  801b29:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b2d:	89 e9                	mov    %ebp,%ecx
  801b2f:	d3 e0                	shl    %cl,%eax
  801b31:	89 d7                	mov    %edx,%edi
  801b33:	89 f1                	mov    %esi,%ecx
  801b35:	d3 ef                	shr    %cl,%edi
  801b37:	09 c7                	or     %eax,%edi
  801b39:	89 e9                	mov    %ebp,%ecx
  801b3b:	d3 e2                	shl    %cl,%edx
  801b3d:	89 14 24             	mov    %edx,(%esp)
  801b40:	89 d8                	mov    %ebx,%eax
  801b42:	d3 e0                	shl    %cl,%eax
  801b44:	89 c2                	mov    %eax,%edx
  801b46:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b4a:	d3 e0                	shl    %cl,%eax
  801b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b50:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b54:	89 f1                	mov    %esi,%ecx
  801b56:	d3 e8                	shr    %cl,%eax
  801b58:	09 d0                	or     %edx,%eax
  801b5a:	d3 eb                	shr    %cl,%ebx
  801b5c:	89 da                	mov    %ebx,%edx
  801b5e:	f7 f7                	div    %edi
  801b60:	89 d3                	mov    %edx,%ebx
  801b62:	f7 24 24             	mull   (%esp)
  801b65:	89 c6                	mov    %eax,%esi
  801b67:	89 d1                	mov    %edx,%ecx
  801b69:	39 d3                	cmp    %edx,%ebx
  801b6b:	0f 82 87 00 00 00    	jb     801bf8 <__umoddi3+0x134>
  801b71:	0f 84 91 00 00 00    	je     801c08 <__umoddi3+0x144>
  801b77:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b7b:	29 f2                	sub    %esi,%edx
  801b7d:	19 cb                	sbb    %ecx,%ebx
  801b7f:	89 d8                	mov    %ebx,%eax
  801b81:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b85:	d3 e0                	shl    %cl,%eax
  801b87:	89 e9                	mov    %ebp,%ecx
  801b89:	d3 ea                	shr    %cl,%edx
  801b8b:	09 d0                	or     %edx,%eax
  801b8d:	89 e9                	mov    %ebp,%ecx
  801b8f:	d3 eb                	shr    %cl,%ebx
  801b91:	89 da                	mov    %ebx,%edx
  801b93:	83 c4 1c             	add    $0x1c,%esp
  801b96:	5b                   	pop    %ebx
  801b97:	5e                   	pop    %esi
  801b98:	5f                   	pop    %edi
  801b99:	5d                   	pop    %ebp
  801b9a:	c3                   	ret    
  801b9b:	90                   	nop
  801b9c:	89 fd                	mov    %edi,%ebp
  801b9e:	85 ff                	test   %edi,%edi
  801ba0:	75 0b                	jne    801bad <__umoddi3+0xe9>
  801ba2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba7:	31 d2                	xor    %edx,%edx
  801ba9:	f7 f7                	div    %edi
  801bab:	89 c5                	mov    %eax,%ebp
  801bad:	89 f0                	mov    %esi,%eax
  801baf:	31 d2                	xor    %edx,%edx
  801bb1:	f7 f5                	div    %ebp
  801bb3:	89 c8                	mov    %ecx,%eax
  801bb5:	f7 f5                	div    %ebp
  801bb7:	89 d0                	mov    %edx,%eax
  801bb9:	e9 44 ff ff ff       	jmp    801b02 <__umoddi3+0x3e>
  801bbe:	66 90                	xchg   %ax,%ax
  801bc0:	89 c8                	mov    %ecx,%eax
  801bc2:	89 f2                	mov    %esi,%edx
  801bc4:	83 c4 1c             	add    $0x1c,%esp
  801bc7:	5b                   	pop    %ebx
  801bc8:	5e                   	pop    %esi
  801bc9:	5f                   	pop    %edi
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    
  801bcc:	3b 04 24             	cmp    (%esp),%eax
  801bcf:	72 06                	jb     801bd7 <__umoddi3+0x113>
  801bd1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bd5:	77 0f                	ja     801be6 <__umoddi3+0x122>
  801bd7:	89 f2                	mov    %esi,%edx
  801bd9:	29 f9                	sub    %edi,%ecx
  801bdb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bdf:	89 14 24             	mov    %edx,(%esp)
  801be2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801be6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bea:	8b 14 24             	mov    (%esp),%edx
  801bed:	83 c4 1c             	add    $0x1c,%esp
  801bf0:	5b                   	pop    %ebx
  801bf1:	5e                   	pop    %esi
  801bf2:	5f                   	pop    %edi
  801bf3:	5d                   	pop    %ebp
  801bf4:	c3                   	ret    
  801bf5:	8d 76 00             	lea    0x0(%esi),%esi
  801bf8:	2b 04 24             	sub    (%esp),%eax
  801bfb:	19 fa                	sbb    %edi,%edx
  801bfd:	89 d1                	mov    %edx,%ecx
  801bff:	89 c6                	mov    %eax,%esi
  801c01:	e9 71 ff ff ff       	jmp    801b77 <__umoddi3+0xb3>
  801c06:	66 90                	xchg   %ax,%ax
  801c08:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c0c:	72 ea                	jb     801bf8 <__umoddi3+0x134>
  801c0e:	89 d9                	mov    %ebx,%ecx
  801c10:	e9 62 ff ff ff       	jmp    801b77 <__umoddi3+0xb3>
