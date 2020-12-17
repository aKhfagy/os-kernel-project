
obj/user/tst_envfree2:     file format elf32-i386


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
  800031:	e8 2d 01 00 00       	call   800163 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests environment free run tef2 10 5
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing scenario 2: using dynamic allocation and free
	// Testing removing the allocated pages (static & dynamic) in mem, WS, mapped page tables, env's directory and env's page file

	int freeFrames_before = sys_calculate_free_frames() ;
  80003e:	e8 fd 13 00 00       	call   801440 <sys_calculate_free_frames>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800046:	e8 78 14 00 00       	call   8014c3 <sys_pf_calculate_allocated_pages>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	ff 75 f4             	pushl  -0xc(%ebp)
  800054:	68 60 1c 80 00       	push   $0x801c60
  800059:	e8 ec 04 00 00       	call   80054a <cprintf>
  80005e:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes
	int32 envIdProcessA = sys_create_env("ef_ms1", (myEnv->page_WS_max_size), 50);
  800061:	a1 20 30 80 00       	mov    0x803020,%eax
  800066:	8b 40 74             	mov    0x74(%eax),%eax
  800069:	83 ec 04             	sub    $0x4,%esp
  80006c:	6a 32                	push   $0x32
  80006e:	50                   	push   %eax
  80006f:	68 93 1c 80 00       	push   $0x801c93
  800074:	e8 1c 16 00 00       	call   801695 <sys_create_env>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int32 envIdProcessB = sys_create_env("ef_ms2", (myEnv->page_WS_max_size)-3, 50);
  80007f:	a1 20 30 80 00       	mov    0x803020,%eax
  800084:	8b 40 74             	mov    0x74(%eax),%eax
  800087:	83 e8 03             	sub    $0x3,%eax
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 32                	push   $0x32
  80008f:	50                   	push   %eax
  800090:	68 9a 1c 80 00       	push   $0x801c9a
  800095:	e8 fb 15 00 00       	call   801695 <sys_create_env>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Run 3 processes
	sys_run_env(envIdProcessA);
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	ff 75 ec             	pushl  -0x14(%ebp)
  8000a6:	e8 07 16 00 00       	call   8016b2 <sys_run_env>
  8000ab:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b4:	e8 f9 15 00 00       	call   8016b2 <sys_run_env>
  8000b9:	83 c4 10             	add    $0x10,%esp

	env_sleep(30000);
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 30 75 00 00       	push   $0x7530
  8000c4:	e8 67 18 00 00       	call   801930 <env_sleep>
  8000c9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000cc:	e8 6f 13 00 00       	call   801440 <sys_calculate_free_frames>
  8000d1:	83 ec 08             	sub    $0x8,%esp
  8000d4:	50                   	push   %eax
  8000d5:	68 a4 1c 80 00       	push   $0x801ca4
  8000da:	e8 6b 04 00 00       	call   80054a <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp

	//Kill the 3 processes
	sys_free_env(envIdProcessA);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e8:	e8 e1 15 00 00       	call   8016ce <sys_free_env>
  8000ed:	83 c4 10             	add    $0x10,%esp
	sys_free_env(envIdProcessB);
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8000f6:	e8 d3 15 00 00       	call   8016ce <sys_free_env>
  8000fb:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000fe:	e8 3d 13 00 00       	call   801440 <sys_calculate_free_frames>
  800103:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800106:	e8 b8 13 00 00       	call   8014c3 <sys_pf_calculate_allocated_pages>
  80010b:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80010e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800111:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800114:	74 27                	je     80013d <_main+0x105>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800116:	83 ec 08             	sub    $0x8,%esp
  800119:	ff 75 e4             	pushl  -0x1c(%ebp)
  80011c:	68 d8 1c 80 00       	push   $0x801cd8
  800121:	e8 24 04 00 00       	call   80054a <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800129:	83 ec 04             	sub    $0x4,%esp
  80012c:	68 28 1d 80 00       	push   $0x801d28
  800131:	6a 24                	push   $0x24
  800133:	68 5e 1d 80 00       	push   $0x801d5e
  800138:	e8 6b 01 00 00       	call   8002a8 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80013d:	83 ec 08             	sub    $0x8,%esp
  800140:	ff 75 e4             	pushl  -0x1c(%ebp)
  800143:	68 74 1d 80 00       	push   $0x801d74
  800148:	e8 fd 03 00 00       	call   80054a <cprintf>
  80014d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 2 for envfree completed successfully.\n");
  800150:	83 ec 0c             	sub    $0xc,%esp
  800153:	68 d4 1d 80 00       	push   $0x801dd4
  800158:	e8 ed 03 00 00       	call   80054a <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
	return;
  800160:	90                   	nop
}
  800161:	c9                   	leave  
  800162:	c3                   	ret    

00800163 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800169:	e8 07 12 00 00       	call   801375 <sys_getenvindex>
  80016e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800171:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800174:	89 d0                	mov    %edx,%eax
  800176:	c1 e0 03             	shl    $0x3,%eax
  800179:	01 d0                	add    %edx,%eax
  80017b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800182:	01 c8                	add    %ecx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	01 c0                	add    %eax,%eax
  80018a:	01 d0                	add    %edx,%eax
  80018c:	89 c2                	mov    %eax,%edx
  80018e:	c1 e2 05             	shl    $0x5,%edx
  800191:	29 c2                	sub    %eax,%edx
  800193:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80019a:	89 c2                	mov    %eax,%edx
  80019c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001a2:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ac:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001b2:	84 c0                	test   %al,%al
  8001b4:	74 0f                	je     8001c5 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001b6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bb:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001c0:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c9:	7e 0a                	jle    8001d5 <libmain+0x72>
		binaryname = argv[0];
  8001cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ce:	8b 00                	mov    (%eax),%eax
  8001d0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001d5:	83 ec 08             	sub    $0x8,%esp
  8001d8:	ff 75 0c             	pushl  0xc(%ebp)
  8001db:	ff 75 08             	pushl  0x8(%ebp)
  8001de:	e8 55 fe ff ff       	call   800038 <_main>
  8001e3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001e6:	e8 25 13 00 00       	call   801510 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	68 38 1e 80 00       	push   $0x801e38
  8001f3:	e8 52 03 00 00       	call   80054a <cprintf>
  8001f8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800200:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800206:	a1 20 30 80 00       	mov    0x803020,%eax
  80020b:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	52                   	push   %edx
  800215:	50                   	push   %eax
  800216:	68 60 1e 80 00       	push   $0x801e60
  80021b:	e8 2a 03 00 00       	call   80054a <cprintf>
  800220:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800223:	a1 20 30 80 00       	mov    0x803020,%eax
  800228:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80022e:	a1 20 30 80 00       	mov    0x803020,%eax
  800233:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	52                   	push   %edx
  80023d:	50                   	push   %eax
  80023e:	68 88 1e 80 00       	push   $0x801e88
  800243:	e8 02 03 00 00       	call   80054a <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024b:	a1 20 30 80 00       	mov    0x803020,%eax
  800250:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	50                   	push   %eax
  80025a:	68 c9 1e 80 00       	push   $0x801ec9
  80025f:	e8 e6 02 00 00       	call   80054a <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	68 38 1e 80 00       	push   $0x801e38
  80026f:	e8 d6 02 00 00       	call   80054a <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800277:	e8 ae 12 00 00       	call   80152a <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027c:	e8 19 00 00 00       	call   80029a <exit>
}
  800281:	90                   	nop
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 00                	push   $0x0
  80028f:	e8 ad 10 00 00       	call   801341 <sys_env_destroy>
  800294:	83 c4 10             	add    $0x10,%esp
}
  800297:	90                   	nop
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <exit>:

void
exit(void)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002a0:	e8 02 11 00 00       	call   8013a7 <sys_env_exit>
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ae:	8d 45 10             	lea    0x10(%ebp),%eax
  8002b1:	83 c0 04             	add    $0x4,%eax
  8002b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002b7:	a1 18 31 80 00       	mov    0x803118,%eax
  8002bc:	85 c0                	test   %eax,%eax
  8002be:	74 16                	je     8002d6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002c0:	a1 18 31 80 00       	mov    0x803118,%eax
  8002c5:	83 ec 08             	sub    $0x8,%esp
  8002c8:	50                   	push   %eax
  8002c9:	68 e0 1e 80 00       	push   $0x801ee0
  8002ce:	e8 77 02 00 00       	call   80054a <cprintf>
  8002d3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002d6:	a1 00 30 80 00       	mov    0x803000,%eax
  8002db:	ff 75 0c             	pushl  0xc(%ebp)
  8002de:	ff 75 08             	pushl  0x8(%ebp)
  8002e1:	50                   	push   %eax
  8002e2:	68 e5 1e 80 00       	push   $0x801ee5
  8002e7:	e8 5e 02 00 00       	call   80054a <cprintf>
  8002ec:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f2:	83 ec 08             	sub    $0x8,%esp
  8002f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f8:	50                   	push   %eax
  8002f9:	e8 e1 01 00 00       	call   8004df <vcprintf>
  8002fe:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	6a 00                	push   $0x0
  800306:	68 01 1f 80 00       	push   $0x801f01
  80030b:	e8 cf 01 00 00       	call   8004df <vcprintf>
  800310:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800313:	e8 82 ff ff ff       	call   80029a <exit>

	// should not return here
	while (1) ;
  800318:	eb fe                	jmp    800318 <_panic+0x70>

0080031a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800320:	a1 20 30 80 00       	mov    0x803020,%eax
  800325:	8b 50 74             	mov    0x74(%eax),%edx
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032b:	39 c2                	cmp    %eax,%edx
  80032d:	74 14                	je     800343 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80032f:	83 ec 04             	sub    $0x4,%esp
  800332:	68 04 1f 80 00       	push   $0x801f04
  800337:	6a 26                	push   $0x26
  800339:	68 50 1f 80 00       	push   $0x801f50
  80033e:	e8 65 ff ff ff       	call   8002a8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800343:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80034a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800351:	e9 b6 00 00 00       	jmp    80040c <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 08             	mov    0x8(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 00                	mov    (%eax),%eax
  800367:	85 c0                	test   %eax,%eax
  800369:	75 08                	jne    800373 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80036b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80036e:	e9 96 00 00 00       	jmp    800409 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800373:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80037a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800381:	eb 5d                	jmp    8003e0 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800383:	a1 20 30 80 00       	mov    0x803020,%eax
  800388:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80038e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800391:	c1 e2 04             	shl    $0x4,%edx
  800394:	01 d0                	add    %edx,%eax
  800396:	8a 40 04             	mov    0x4(%eax),%al
  800399:	84 c0                	test   %al,%al
  80039b:	75 40                	jne    8003dd <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80039d:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a2:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ab:	c1 e2 04             	shl    $0x4,%edx
  8003ae:	01 d0                	add    %edx,%eax
  8003b0:	8b 00                	mov    (%eax),%eax
  8003b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003bd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cc:	01 c8                	add    %ecx,%eax
  8003ce:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003d0:	39 c2                	cmp    %eax,%edx
  8003d2:	75 09                	jne    8003dd <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8003d4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003db:	eb 12                	jmp    8003ef <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003dd:	ff 45 e8             	incl   -0x18(%ebp)
  8003e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e5:	8b 50 74             	mov    0x74(%eax),%edx
  8003e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003eb:	39 c2                	cmp    %eax,%edx
  8003ed:	77 94                	ja     800383 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003f3:	75 14                	jne    800409 <CheckWSWithoutLastIndex+0xef>
			panic(
  8003f5:	83 ec 04             	sub    $0x4,%esp
  8003f8:	68 5c 1f 80 00       	push   $0x801f5c
  8003fd:	6a 3a                	push   $0x3a
  8003ff:	68 50 1f 80 00       	push   $0x801f50
  800404:	e8 9f fe ff ff       	call   8002a8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800409:	ff 45 f0             	incl   -0x10(%ebp)
  80040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800412:	0f 8c 3e ff ff ff    	jl     800356 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800418:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80041f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800426:	eb 20                	jmp    800448 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800428:	a1 20 30 80 00       	mov    0x803020,%eax
  80042d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800433:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800436:	c1 e2 04             	shl    $0x4,%edx
  800439:	01 d0                	add    %edx,%eax
  80043b:	8a 40 04             	mov    0x4(%eax),%al
  80043e:	3c 01                	cmp    $0x1,%al
  800440:	75 03                	jne    800445 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800442:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800445:	ff 45 e0             	incl   -0x20(%ebp)
  800448:	a1 20 30 80 00       	mov    0x803020,%eax
  80044d:	8b 50 74             	mov    0x74(%eax),%edx
  800450:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800453:	39 c2                	cmp    %eax,%edx
  800455:	77 d1                	ja     800428 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80045a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80045d:	74 14                	je     800473 <CheckWSWithoutLastIndex+0x159>
		panic(
  80045f:	83 ec 04             	sub    $0x4,%esp
  800462:	68 b0 1f 80 00       	push   $0x801fb0
  800467:	6a 44                	push   $0x44
  800469:	68 50 1f 80 00       	push   $0x801f50
  80046e:	e8 35 fe ff ff       	call   8002a8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800473:	90                   	nop
  800474:	c9                   	leave  
  800475:	c3                   	ret    

00800476 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	8d 48 01             	lea    0x1(%eax),%ecx
  800484:	8b 55 0c             	mov    0xc(%ebp),%edx
  800487:	89 0a                	mov    %ecx,(%edx)
  800489:	8b 55 08             	mov    0x8(%ebp),%edx
  80048c:	88 d1                	mov    %dl,%cl
  80048e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800491:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800495:	8b 45 0c             	mov    0xc(%ebp),%eax
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80049f:	75 2c                	jne    8004cd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004a1:	a0 24 30 80 00       	mov    0x803024,%al
  8004a6:	0f b6 c0             	movzbl %al,%eax
  8004a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ac:	8b 12                	mov    (%edx),%edx
  8004ae:	89 d1                	mov    %edx,%ecx
  8004b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b3:	83 c2 08             	add    $0x8,%edx
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	50                   	push   %eax
  8004ba:	51                   	push   %ecx
  8004bb:	52                   	push   %edx
  8004bc:	e8 3e 0e 00 00       	call   8012ff <sys_cputs>
  8004c1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d0:	8b 40 04             	mov    0x4(%eax),%eax
  8004d3:	8d 50 01             	lea    0x1(%eax),%edx
  8004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004dc:	90                   	nop
  8004dd:	c9                   	leave  
  8004de:	c3                   	ret    

008004df <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004df:	55                   	push   %ebp
  8004e0:	89 e5                	mov    %esp,%ebp
  8004e2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004e8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ef:	00 00 00 
	b.cnt = 0;
  8004f2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004f9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004fc:	ff 75 0c             	pushl  0xc(%ebp)
  8004ff:	ff 75 08             	pushl  0x8(%ebp)
  800502:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800508:	50                   	push   %eax
  800509:	68 76 04 80 00       	push   $0x800476
  80050e:	e8 11 02 00 00       	call   800724 <vprintfmt>
  800513:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800516:	a0 24 30 80 00       	mov    0x803024,%al
  80051b:	0f b6 c0             	movzbl %al,%eax
  80051e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800524:	83 ec 04             	sub    $0x4,%esp
  800527:	50                   	push   %eax
  800528:	52                   	push   %edx
  800529:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052f:	83 c0 08             	add    $0x8,%eax
  800532:	50                   	push   %eax
  800533:	e8 c7 0d 00 00       	call   8012ff <sys_cputs>
  800538:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80053b:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800542:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <cprintf>:

int cprintf(const char *fmt, ...) {
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800550:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800557:	8d 45 0c             	lea    0xc(%ebp),%eax
  80055a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	ff 75 f4             	pushl  -0xc(%ebp)
  800566:	50                   	push   %eax
  800567:	e8 73 ff ff ff       	call   8004df <vcprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
  80056f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800572:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80057d:	e8 8e 0f 00 00       	call   801510 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800582:	8d 45 0c             	lea    0xc(%ebp),%eax
  800585:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	ff 75 f4             	pushl  -0xc(%ebp)
  800591:	50                   	push   %eax
  800592:	e8 48 ff ff ff       	call   8004df <vcprintf>
  800597:	83 c4 10             	add    $0x10,%esp
  80059a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80059d:	e8 88 0f 00 00       	call   80152a <sys_enable_interrupt>
	return cnt;
  8005a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005a5:	c9                   	leave  
  8005a6:	c3                   	ret    

008005a7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a7:	55                   	push   %ebp
  8005a8:	89 e5                	mov    %esp,%ebp
  8005aa:	53                   	push   %ebx
  8005ab:	83 ec 14             	sub    $0x14,%esp
  8005ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ba:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c5:	77 55                	ja     80061c <printnum+0x75>
  8005c7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ca:	72 05                	jb     8005d1 <printnum+0x2a>
  8005cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005cf:	77 4b                	ja     80061c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005d1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005d4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005da:	ba 00 00 00 00       	mov    $0x0,%edx
  8005df:	52                   	push   %edx
  8005e0:	50                   	push   %eax
  8005e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005e7:	e8 f8 13 00 00       	call   8019e4 <__udivdi3>
  8005ec:	83 c4 10             	add    $0x10,%esp
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	ff 75 20             	pushl  0x20(%ebp)
  8005f5:	53                   	push   %ebx
  8005f6:	ff 75 18             	pushl  0x18(%ebp)
  8005f9:	52                   	push   %edx
  8005fa:	50                   	push   %eax
  8005fb:	ff 75 0c             	pushl  0xc(%ebp)
  8005fe:	ff 75 08             	pushl  0x8(%ebp)
  800601:	e8 a1 ff ff ff       	call   8005a7 <printnum>
  800606:	83 c4 20             	add    $0x20,%esp
  800609:	eb 1a                	jmp    800625 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	ff 75 0c             	pushl  0xc(%ebp)
  800611:	ff 75 20             	pushl  0x20(%ebp)
  800614:	8b 45 08             	mov    0x8(%ebp),%eax
  800617:	ff d0                	call   *%eax
  800619:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80061c:	ff 4d 1c             	decl   0x1c(%ebp)
  80061f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800623:	7f e6                	jg     80060b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800625:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800628:	bb 00 00 00 00       	mov    $0x0,%ebx
  80062d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800630:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800633:	53                   	push   %ebx
  800634:	51                   	push   %ecx
  800635:	52                   	push   %edx
  800636:	50                   	push   %eax
  800637:	e8 b8 14 00 00       	call   801af4 <__umoddi3>
  80063c:	83 c4 10             	add    $0x10,%esp
  80063f:	05 14 22 80 00       	add    $0x802214,%eax
  800644:	8a 00                	mov    (%eax),%al
  800646:	0f be c0             	movsbl %al,%eax
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	ff 75 0c             	pushl  0xc(%ebp)
  80064f:	50                   	push   %eax
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	ff d0                	call   *%eax
  800655:	83 c4 10             	add    $0x10,%esp
}
  800658:	90                   	nop
  800659:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80065c:	c9                   	leave  
  80065d:	c3                   	ret    

0080065e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80065e:	55                   	push   %ebp
  80065f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800661:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800665:	7e 1c                	jle    800683 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	8b 00                	mov    (%eax),%eax
  80066c:	8d 50 08             	lea    0x8(%eax),%edx
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	89 10                	mov    %edx,(%eax)
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	83 e8 08             	sub    $0x8,%eax
  80067c:	8b 50 04             	mov    0x4(%eax),%edx
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	eb 40                	jmp    8006c3 <getuint+0x65>
	else if (lflag)
  800683:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800687:	74 1e                	je     8006a7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800689:	8b 45 08             	mov    0x8(%ebp),%eax
  80068c:	8b 00                	mov    (%eax),%eax
  80068e:	8d 50 04             	lea    0x4(%eax),%edx
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	89 10                	mov    %edx,(%eax)
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	83 e8 04             	sub    $0x4,%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a5:	eb 1c                	jmp    8006c3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	8d 50 04             	lea    0x4(%eax),%edx
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	89 10                	mov    %edx,(%eax)
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	83 e8 04             	sub    $0x4,%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006c3:	5d                   	pop    %ebp
  8006c4:	c3                   	ret    

008006c5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006c5:	55                   	push   %ebp
  8006c6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006cc:	7e 1c                	jle    8006ea <getint+0x25>
		return va_arg(*ap, long long);
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	8d 50 08             	lea    0x8(%eax),%edx
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	89 10                	mov    %edx,(%eax)
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	83 e8 08             	sub    $0x8,%eax
  8006e3:	8b 50 04             	mov    0x4(%eax),%edx
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	eb 38                	jmp    800722 <getint+0x5d>
	else if (lflag)
  8006ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ee:	74 1a                	je     80070a <getint+0x45>
		return va_arg(*ap, long);
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	8d 50 04             	lea    0x4(%eax),%edx
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	89 10                	mov    %edx,(%eax)
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	83 e8 04             	sub    $0x4,%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	99                   	cltd   
  800708:	eb 18                	jmp    800722 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80070a:	8b 45 08             	mov    0x8(%ebp),%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	8d 50 04             	lea    0x4(%eax),%edx
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	89 10                	mov    %edx,(%eax)
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	83 e8 04             	sub    $0x4,%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	99                   	cltd   
}
  800722:	5d                   	pop    %ebp
  800723:	c3                   	ret    

00800724 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
  800727:	56                   	push   %esi
  800728:	53                   	push   %ebx
  800729:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072c:	eb 17                	jmp    800745 <vprintfmt+0x21>
			if (ch == '\0')
  80072e:	85 db                	test   %ebx,%ebx
  800730:	0f 84 af 03 00 00    	je     800ae5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	ff 75 0c             	pushl  0xc(%ebp)
  80073c:	53                   	push   %ebx
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	ff d0                	call   *%eax
  800742:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800745:	8b 45 10             	mov    0x10(%ebp),%eax
  800748:	8d 50 01             	lea    0x1(%eax),%edx
  80074b:	89 55 10             	mov    %edx,0x10(%ebp)
  80074e:	8a 00                	mov    (%eax),%al
  800750:	0f b6 d8             	movzbl %al,%ebx
  800753:	83 fb 25             	cmp    $0x25,%ebx
  800756:	75 d6                	jne    80072e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800758:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80075c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800763:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80076a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800771:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800778:	8b 45 10             	mov    0x10(%ebp),%eax
  80077b:	8d 50 01             	lea    0x1(%eax),%edx
  80077e:	89 55 10             	mov    %edx,0x10(%ebp)
  800781:	8a 00                	mov    (%eax),%al
  800783:	0f b6 d8             	movzbl %al,%ebx
  800786:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800789:	83 f8 55             	cmp    $0x55,%eax
  80078c:	0f 87 2b 03 00 00    	ja     800abd <vprintfmt+0x399>
  800792:	8b 04 85 38 22 80 00 	mov    0x802238(,%eax,4),%eax
  800799:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80079b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80079f:	eb d7                	jmp    800778 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007a1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007a5:	eb d1                	jmp    800778 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007b1:	89 d0                	mov    %edx,%eax
  8007b3:	c1 e0 02             	shl    $0x2,%eax
  8007b6:	01 d0                	add    %edx,%eax
  8007b8:	01 c0                	add    %eax,%eax
  8007ba:	01 d8                	add    %ebx,%eax
  8007bc:	83 e8 30             	sub    $0x30,%eax
  8007bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c5:	8a 00                	mov    (%eax),%al
  8007c7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ca:	83 fb 2f             	cmp    $0x2f,%ebx
  8007cd:	7e 3e                	jle    80080d <vprintfmt+0xe9>
  8007cf:	83 fb 39             	cmp    $0x39,%ebx
  8007d2:	7f 39                	jg     80080d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d7:	eb d5                	jmp    8007ae <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	83 c0 04             	add    $0x4,%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	83 e8 04             	sub    $0x4,%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007ed:	eb 1f                	jmp    80080e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f3:	79 83                	jns    800778 <vprintfmt+0x54>
				width = 0;
  8007f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007fc:	e9 77 ff ff ff       	jmp    800778 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800801:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800808:	e9 6b ff ff ff       	jmp    800778 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80080d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80080e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800812:	0f 89 60 ff ff ff    	jns    800778 <vprintfmt+0x54>
				width = precision, precision = -1;
  800818:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80081b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80081e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800825:	e9 4e ff ff ff       	jmp    800778 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80082a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80082d:	e9 46 ff ff ff       	jmp    800778 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	83 c0 04             	add    $0x4,%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	83 e8 04             	sub    $0x4,%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	50                   	push   %eax
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	ff d0                	call   *%eax
  80084f:	83 c4 10             	add    $0x10,%esp
			break;
  800852:	e9 89 02 00 00       	jmp    800ae0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	83 c0 04             	add    $0x4,%eax
  80085d:	89 45 14             	mov    %eax,0x14(%ebp)
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	83 e8 04             	sub    $0x4,%eax
  800866:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800868:	85 db                	test   %ebx,%ebx
  80086a:	79 02                	jns    80086e <vprintfmt+0x14a>
				err = -err;
  80086c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80086e:	83 fb 64             	cmp    $0x64,%ebx
  800871:	7f 0b                	jg     80087e <vprintfmt+0x15a>
  800873:	8b 34 9d 80 20 80 00 	mov    0x802080(,%ebx,4),%esi
  80087a:	85 f6                	test   %esi,%esi
  80087c:	75 19                	jne    800897 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80087e:	53                   	push   %ebx
  80087f:	68 25 22 80 00       	push   $0x802225
  800884:	ff 75 0c             	pushl  0xc(%ebp)
  800887:	ff 75 08             	pushl  0x8(%ebp)
  80088a:	e8 5e 02 00 00       	call   800aed <printfmt>
  80088f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800892:	e9 49 02 00 00       	jmp    800ae0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800897:	56                   	push   %esi
  800898:	68 2e 22 80 00       	push   $0x80222e
  80089d:	ff 75 0c             	pushl  0xc(%ebp)
  8008a0:	ff 75 08             	pushl  0x8(%ebp)
  8008a3:	e8 45 02 00 00       	call   800aed <printfmt>
  8008a8:	83 c4 10             	add    $0x10,%esp
			break;
  8008ab:	e9 30 02 00 00       	jmp    800ae0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	83 c0 04             	add    $0x4,%eax
  8008b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	83 e8 04             	sub    $0x4,%eax
  8008bf:	8b 30                	mov    (%eax),%esi
  8008c1:	85 f6                	test   %esi,%esi
  8008c3:	75 05                	jne    8008ca <vprintfmt+0x1a6>
				p = "(null)";
  8008c5:	be 31 22 80 00       	mov    $0x802231,%esi
			if (width > 0 && padc != '-')
  8008ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ce:	7e 6d                	jle    80093d <vprintfmt+0x219>
  8008d0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008d4:	74 67                	je     80093d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d9:	83 ec 08             	sub    $0x8,%esp
  8008dc:	50                   	push   %eax
  8008dd:	56                   	push   %esi
  8008de:	e8 0c 03 00 00       	call   800bef <strnlen>
  8008e3:	83 c4 10             	add    $0x10,%esp
  8008e6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008e9:	eb 16                	jmp    800901 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008eb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	50                   	push   %eax
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fe:	ff 4d e4             	decl   -0x1c(%ebp)
  800901:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800905:	7f e4                	jg     8008eb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800907:	eb 34                	jmp    80093d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800909:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80090d:	74 1c                	je     80092b <vprintfmt+0x207>
  80090f:	83 fb 1f             	cmp    $0x1f,%ebx
  800912:	7e 05                	jle    800919 <vprintfmt+0x1f5>
  800914:	83 fb 7e             	cmp    $0x7e,%ebx
  800917:	7e 12                	jle    80092b <vprintfmt+0x207>
					putch('?', putdat);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	6a 3f                	push   $0x3f
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	ff d0                	call   *%eax
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	eb 0f                	jmp    80093a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	53                   	push   %ebx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	ff d0                	call   *%eax
  800937:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093a:	ff 4d e4             	decl   -0x1c(%ebp)
  80093d:	89 f0                	mov    %esi,%eax
  80093f:	8d 70 01             	lea    0x1(%eax),%esi
  800942:	8a 00                	mov    (%eax),%al
  800944:	0f be d8             	movsbl %al,%ebx
  800947:	85 db                	test   %ebx,%ebx
  800949:	74 24                	je     80096f <vprintfmt+0x24b>
  80094b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80094f:	78 b8                	js     800909 <vprintfmt+0x1e5>
  800951:	ff 4d e0             	decl   -0x20(%ebp)
  800954:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800958:	79 af                	jns    800909 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80095a:	eb 13                	jmp    80096f <vprintfmt+0x24b>
				putch(' ', putdat);
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	ff 75 0c             	pushl  0xc(%ebp)
  800962:	6a 20                	push   $0x20
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	ff d0                	call   *%eax
  800969:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80096c:	ff 4d e4             	decl   -0x1c(%ebp)
  80096f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800973:	7f e7                	jg     80095c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800975:	e9 66 01 00 00       	jmp    800ae0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	ff 75 e8             	pushl  -0x18(%ebp)
  800980:	8d 45 14             	lea    0x14(%ebp),%eax
  800983:	50                   	push   %eax
  800984:	e8 3c fd ff ff       	call   8006c5 <getint>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800995:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800998:	85 d2                	test   %edx,%edx
  80099a:	79 23                	jns    8009bf <vprintfmt+0x29b>
				putch('-', putdat);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	6a 2d                	push   $0x2d
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	ff d0                	call   *%eax
  8009a9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b2:	f7 d8                	neg    %eax
  8009b4:	83 d2 00             	adc    $0x0,%edx
  8009b7:	f7 da                	neg    %edx
  8009b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009bf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c6:	e9 bc 00 00 00       	jmp    800a87 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d4:	50                   	push   %eax
  8009d5:	e8 84 fc ff ff       	call   80065e <getuint>
  8009da:	83 c4 10             	add    $0x10,%esp
  8009dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009e3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ea:	e9 98 00 00 00       	jmp    800a87 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 58                	push   $0x58
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 58                	push   $0x58
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 58                	push   $0x58
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			break;
  800a1f:	e9 bc 00 00 00       	jmp    800ae0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	6a 30                	push   $0x30
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	6a 78                	push   $0x78
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	ff d0                	call   *%eax
  800a41:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	83 c0 04             	add    $0x4,%eax
  800a4a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a50:	83 e8 04             	sub    $0x4,%eax
  800a53:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a5f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a66:	eb 1f                	jmp    800a87 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a6e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a71:	50                   	push   %eax
  800a72:	e8 e7 fb ff ff       	call   80065e <getuint>
  800a77:	83 c4 10             	add    $0x10,%esp
  800a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a80:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a87:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	52                   	push   %edx
  800a92:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a95:	50                   	push   %eax
  800a96:	ff 75 f4             	pushl  -0xc(%ebp)
  800a99:	ff 75 f0             	pushl  -0x10(%ebp)
  800a9c:	ff 75 0c             	pushl  0xc(%ebp)
  800a9f:	ff 75 08             	pushl  0x8(%ebp)
  800aa2:	e8 00 fb ff ff       	call   8005a7 <printnum>
  800aa7:	83 c4 20             	add    $0x20,%esp
			break;
  800aaa:	eb 34                	jmp    800ae0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	53                   	push   %ebx
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	ff d0                	call   *%eax
  800ab8:	83 c4 10             	add    $0x10,%esp
			break;
  800abb:	eb 23                	jmp    800ae0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800abd:	83 ec 08             	sub    $0x8,%esp
  800ac0:	ff 75 0c             	pushl  0xc(%ebp)
  800ac3:	6a 25                	push   $0x25
  800ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac8:	ff d0                	call   *%eax
  800aca:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800acd:	ff 4d 10             	decl   0x10(%ebp)
  800ad0:	eb 03                	jmp    800ad5 <vprintfmt+0x3b1>
  800ad2:	ff 4d 10             	decl   0x10(%ebp)
  800ad5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad8:	48                   	dec    %eax
  800ad9:	8a 00                	mov    (%eax),%al
  800adb:	3c 25                	cmp    $0x25,%al
  800add:	75 f3                	jne    800ad2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800adf:	90                   	nop
		}
	}
  800ae0:	e9 47 fc ff ff       	jmp    80072c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ae5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae9:	5b                   	pop    %ebx
  800aea:	5e                   	pop    %esi
  800aeb:	5d                   	pop    %ebp
  800aec:	c3                   	ret    

00800aed <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800af3:	8d 45 10             	lea    0x10(%ebp),%eax
  800af6:	83 c0 04             	add    $0x4,%eax
  800af9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	ff 75 f4             	pushl  -0xc(%ebp)
  800b02:	50                   	push   %eax
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	e8 16 fc ff ff       	call   800724 <vprintfmt>
  800b0e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b11:	90                   	nop
  800b12:	c9                   	leave  
  800b13:	c3                   	ret    

00800b14 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	8b 40 08             	mov    0x8(%eax),%eax
  800b1d:	8d 50 01             	lea    0x1(%eax),%edx
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b29:	8b 10                	mov    (%eax),%edx
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	8b 40 04             	mov    0x4(%eax),%eax
  800b31:	39 c2                	cmp    %eax,%edx
  800b33:	73 12                	jae    800b47 <sprintputch+0x33>
		*b->buf++ = ch;
  800b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b38:	8b 00                	mov    (%eax),%eax
  800b3a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b40:	89 0a                	mov    %ecx,(%edx)
  800b42:	8b 55 08             	mov    0x8(%ebp),%edx
  800b45:	88 10                	mov    %dl,(%eax)
}
  800b47:	90                   	nop
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	01 d0                	add    %edx,%eax
  800b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6f:	74 06                	je     800b77 <vsnprintf+0x2d>
  800b71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b75:	7f 07                	jg     800b7e <vsnprintf+0x34>
		return -E_INVAL;
  800b77:	b8 03 00 00 00       	mov    $0x3,%eax
  800b7c:	eb 20                	jmp    800b9e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b7e:	ff 75 14             	pushl  0x14(%ebp)
  800b81:	ff 75 10             	pushl  0x10(%ebp)
  800b84:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b87:	50                   	push   %eax
  800b88:	68 14 0b 80 00       	push   $0x800b14
  800b8d:	e8 92 fb ff ff       	call   800724 <vprintfmt>
  800b92:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b98:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b9e:	c9                   	leave  
  800b9f:	c3                   	ret    

00800ba0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba9:	83 c0 04             	add    $0x4,%eax
  800bac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800baf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb5:	50                   	push   %eax
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	ff 75 08             	pushl  0x8(%ebp)
  800bbc:	e8 89 ff ff ff       	call   800b4a <vsnprintf>
  800bc1:	83 c4 10             	add    $0x10,%esp
  800bc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bca:	c9                   	leave  
  800bcb:	c3                   	ret    

00800bcc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd9:	eb 06                	jmp    800be1 <strlen+0x15>
		n++;
  800bdb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bde:	ff 45 08             	incl   0x8(%ebp)
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	8a 00                	mov    (%eax),%al
  800be6:	84 c0                	test   %al,%al
  800be8:	75 f1                	jne    800bdb <strlen+0xf>
		n++;
	return n;
  800bea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bed:	c9                   	leave  
  800bee:	c3                   	ret    

00800bef <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bfc:	eb 09                	jmp    800c07 <strnlen+0x18>
		n++;
  800bfe:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c01:	ff 45 08             	incl   0x8(%ebp)
  800c04:	ff 4d 0c             	decl   0xc(%ebp)
  800c07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0b:	74 09                	je     800c16 <strnlen+0x27>
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	84 c0                	test   %al,%al
  800c14:	75 e8                	jne    800bfe <strnlen+0xf>
		n++;
	return n;
  800c16:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c27:	90                   	nop
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	8d 50 01             	lea    0x1(%eax),%edx
  800c2e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c34:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c37:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c3a:	8a 12                	mov    (%edx),%dl
  800c3c:	88 10                	mov    %dl,(%eax)
  800c3e:	8a 00                	mov    (%eax),%al
  800c40:	84 c0                	test   %al,%al
  800c42:	75 e4                	jne    800c28 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c47:	c9                   	leave  
  800c48:	c3                   	ret    

00800c49 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c5c:	eb 1f                	jmp    800c7d <strncpy+0x34>
		*dst++ = *src;
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8d 50 01             	lea    0x1(%eax),%edx
  800c64:	89 55 08             	mov    %edx,0x8(%ebp)
  800c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6a:	8a 12                	mov    (%edx),%dl
  800c6c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	8a 00                	mov    (%eax),%al
  800c73:	84 c0                	test   %al,%al
  800c75:	74 03                	je     800c7a <strncpy+0x31>
			src++;
  800c77:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c7a:	ff 45 fc             	incl   -0x4(%ebp)
  800c7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c80:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c83:	72 d9                	jb     800c5e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c85:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c88:	c9                   	leave  
  800c89:	c3                   	ret    

00800c8a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9a:	74 30                	je     800ccc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c9c:	eb 16                	jmp    800cb4 <strlcpy+0x2a>
			*dst++ = *src++;
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	8d 50 01             	lea    0x1(%eax),%edx
  800ca4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800caa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb0:	8a 12                	mov    (%edx),%dl
  800cb2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cb4:	ff 4d 10             	decl   0x10(%ebp)
  800cb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cbb:	74 09                	je     800cc6 <strlcpy+0x3c>
  800cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	84 c0                	test   %al,%al
  800cc4:	75 d8                	jne    800c9e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd2:	29 c2                	sub    %eax,%edx
  800cd4:	89 d0                	mov    %edx,%eax
}
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    

00800cd8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cdb:	eb 06                	jmp    800ce3 <strcmp+0xb>
		p++, q++;
  800cdd:	ff 45 08             	incl   0x8(%ebp)
  800ce0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	84 c0                	test   %al,%al
  800cea:	74 0e                	je     800cfa <strcmp+0x22>
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8a 10                	mov    (%eax),%dl
  800cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf4:	8a 00                	mov    (%eax),%al
  800cf6:	38 c2                	cmp    %al,%dl
  800cf8:	74 e3                	je     800cdd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	8a 00                	mov    (%eax),%al
  800cff:	0f b6 d0             	movzbl %al,%edx
  800d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	0f b6 c0             	movzbl %al,%eax
  800d0a:	29 c2                	sub    %eax,%edx
  800d0c:	89 d0                	mov    %edx,%eax
}
  800d0e:	5d                   	pop    %ebp
  800d0f:	c3                   	ret    

00800d10 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d13:	eb 09                	jmp    800d1e <strncmp+0xe>
		n--, p++, q++;
  800d15:	ff 4d 10             	decl   0x10(%ebp)
  800d18:	ff 45 08             	incl   0x8(%ebp)
  800d1b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d22:	74 17                	je     800d3b <strncmp+0x2b>
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8a 00                	mov    (%eax),%al
  800d29:	84 c0                	test   %al,%al
  800d2b:	74 0e                	je     800d3b <strncmp+0x2b>
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	8a 10                	mov    (%eax),%dl
  800d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	38 c2                	cmp    %al,%dl
  800d39:	74 da                	je     800d15 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3f:	75 07                	jne    800d48 <strncmp+0x38>
		return 0;
  800d41:	b8 00 00 00 00       	mov    $0x0,%eax
  800d46:	eb 14                	jmp    800d5c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	0f b6 d0             	movzbl %al,%edx
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	0f b6 c0             	movzbl %al,%eax
  800d58:	29 c2                	sub    %eax,%edx
  800d5a:	89 d0                	mov    %edx,%eax
}
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    

00800d5e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 04             	sub    $0x4,%esp
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d6a:	eb 12                	jmp    800d7e <strchr+0x20>
		if (*s == c)
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d74:	75 05                	jne    800d7b <strchr+0x1d>
			return (char *) s;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	eb 11                	jmp    800d8c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d7b:	ff 45 08             	incl   0x8(%ebp)
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	84 c0                	test   %al,%al
  800d85:	75 e5                	jne    800d6c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d8c:	c9                   	leave  
  800d8d:	c3                   	ret    

00800d8e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	83 ec 04             	sub    $0x4,%esp
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d9a:	eb 0d                	jmp    800da9 <strfind+0x1b>
		if (*s == c)
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	8a 00                	mov    (%eax),%al
  800da1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da4:	74 0e                	je     800db4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da6:	ff 45 08             	incl   0x8(%ebp)
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8a 00                	mov    (%eax),%al
  800dae:	84 c0                	test   %al,%al
  800db0:	75 ea                	jne    800d9c <strfind+0xe>
  800db2:	eb 01                	jmp    800db5 <strfind+0x27>
		if (*s == c)
			break;
  800db4:	90                   	nop
	return (char *) s;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db8:	c9                   	leave  
  800db9:	c3                   	ret    

00800dba <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dcc:	eb 0e                	jmp    800ddc <memset+0x22>
		*p++ = c;
  800dce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd1:	8d 50 01             	lea    0x1(%eax),%edx
  800dd4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dda:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ddc:	ff 4d f8             	decl   -0x8(%ebp)
  800ddf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800de3:	79 e9                	jns    800dce <memset+0x14>
		*p++ = c;

	return v;
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de8:	c9                   	leave  
  800de9:	c3                   	ret    

00800dea <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dfc:	eb 16                	jmp    800e14 <memcpy+0x2a>
		*d++ = *s++;
  800dfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e01:	8d 50 01             	lea    0x1(%eax),%edx
  800e04:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e0a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e10:	8a 12                	mov    (%edx),%dl
  800e12:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e14:	8b 45 10             	mov    0x10(%ebp),%eax
  800e17:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1d:	85 c0                	test   %eax,%eax
  800e1f:	75 dd                	jne    800dfe <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e24:	c9                   	leave  
  800e25:	c3                   	ret    

00800e26 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e3e:	73 50                	jae    800e90 <memmove+0x6a>
  800e40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e43:	8b 45 10             	mov    0x10(%ebp),%eax
  800e46:	01 d0                	add    %edx,%eax
  800e48:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e4b:	76 43                	jbe    800e90 <memmove+0x6a>
		s += n;
  800e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e50:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e53:	8b 45 10             	mov    0x10(%ebp),%eax
  800e56:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e59:	eb 10                	jmp    800e6b <memmove+0x45>
			*--d = *--s;
  800e5b:	ff 4d f8             	decl   -0x8(%ebp)
  800e5e:	ff 4d fc             	decl   -0x4(%ebp)
  800e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e64:	8a 10                	mov    (%eax),%dl
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e69:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e71:	89 55 10             	mov    %edx,0x10(%ebp)
  800e74:	85 c0                	test   %eax,%eax
  800e76:	75 e3                	jne    800e5b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e78:	eb 23                	jmp    800e9d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7d:	8d 50 01             	lea    0x1(%eax),%edx
  800e80:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e83:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e86:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e89:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e8c:	8a 12                	mov    (%edx),%dl
  800e8e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e90:	8b 45 10             	mov    0x10(%ebp),%eax
  800e93:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e96:	89 55 10             	mov    %edx,0x10(%ebp)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	75 dd                	jne    800e7a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    

00800ea2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eb4:	eb 2a                	jmp    800ee0 <memcmp+0x3e>
		if (*s1 != *s2)
  800eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb9:	8a 10                	mov    (%eax),%dl
  800ebb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebe:	8a 00                	mov    (%eax),%al
  800ec0:	38 c2                	cmp    %al,%dl
  800ec2:	74 16                	je     800eda <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	0f b6 d0             	movzbl %al,%edx
  800ecc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 c0             	movzbl %al,%eax
  800ed4:	29 c2                	sub    %eax,%edx
  800ed6:	89 d0                	mov    %edx,%eax
  800ed8:	eb 18                	jmp    800ef2 <memcmp+0x50>
		s1++, s2++;
  800eda:	ff 45 fc             	incl   -0x4(%ebp)
  800edd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ee0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee9:	85 c0                	test   %eax,%eax
  800eeb:	75 c9                	jne    800eb6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800efa:	8b 55 08             	mov    0x8(%ebp),%edx
  800efd:	8b 45 10             	mov    0x10(%ebp),%eax
  800f00:	01 d0                	add    %edx,%eax
  800f02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f05:	eb 15                	jmp    800f1c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	0f b6 d0             	movzbl %al,%edx
  800f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f12:	0f b6 c0             	movzbl %al,%eax
  800f15:	39 c2                	cmp    %eax,%edx
  800f17:	74 0d                	je     800f26 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f19:	ff 45 08             	incl   0x8(%ebp)
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f22:	72 e3                	jb     800f07 <memfind+0x13>
  800f24:	eb 01                	jmp    800f27 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f26:	90                   	nop
	return (void *) s;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f39:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f40:	eb 03                	jmp    800f45 <strtol+0x19>
		s++;
  800f42:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	3c 20                	cmp    $0x20,%al
  800f4c:	74 f4                	je     800f42 <strtol+0x16>
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	3c 09                	cmp    $0x9,%al
  800f55:	74 eb                	je     800f42 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	3c 2b                	cmp    $0x2b,%al
  800f5e:	75 05                	jne    800f65 <strtol+0x39>
		s++;
  800f60:	ff 45 08             	incl   0x8(%ebp)
  800f63:	eb 13                	jmp    800f78 <strtol+0x4c>
	else if (*s == '-')
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 2d                	cmp    $0x2d,%al
  800f6c:	75 0a                	jne    800f78 <strtol+0x4c>
		s++, neg = 1;
  800f6e:	ff 45 08             	incl   0x8(%ebp)
  800f71:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7c:	74 06                	je     800f84 <strtol+0x58>
  800f7e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f82:	75 20                	jne    800fa4 <strtol+0x78>
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	3c 30                	cmp    $0x30,%al
  800f8b:	75 17                	jne    800fa4 <strtol+0x78>
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	40                   	inc    %eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	3c 78                	cmp    $0x78,%al
  800f95:	75 0d                	jne    800fa4 <strtol+0x78>
		s += 2, base = 16;
  800f97:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f9b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fa2:	eb 28                	jmp    800fcc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fa4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa8:	75 15                	jne    800fbf <strtol+0x93>
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 30                	cmp    $0x30,%al
  800fb1:	75 0c                	jne    800fbf <strtol+0x93>
		s++, base = 8;
  800fb3:	ff 45 08             	incl   0x8(%ebp)
  800fb6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fbd:	eb 0d                	jmp    800fcc <strtol+0xa0>
	else if (base == 0)
  800fbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc3:	75 07                	jne    800fcc <strtol+0xa0>
		base = 10;
  800fc5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	3c 2f                	cmp    $0x2f,%al
  800fd3:	7e 19                	jle    800fee <strtol+0xc2>
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 39                	cmp    $0x39,%al
  800fdc:	7f 10                	jg     800fee <strtol+0xc2>
			dig = *s - '0';
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	0f be c0             	movsbl %al,%eax
  800fe6:	83 e8 30             	sub    $0x30,%eax
  800fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fec:	eb 42                	jmp    801030 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	3c 60                	cmp    $0x60,%al
  800ff5:	7e 19                	jle    801010 <strtol+0xe4>
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	8a 00                	mov    (%eax),%al
  800ffc:	3c 7a                	cmp    $0x7a,%al
  800ffe:	7f 10                	jg     801010 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	0f be c0             	movsbl %al,%eax
  801008:	83 e8 57             	sub    $0x57,%eax
  80100b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100e:	eb 20                	jmp    801030 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 40                	cmp    $0x40,%al
  801017:	7e 39                	jle    801052 <strtol+0x126>
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 5a                	cmp    $0x5a,%al
  801020:	7f 30                	jg     801052 <strtol+0x126>
			dig = *s - 'A' + 10;
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f be c0             	movsbl %al,%eax
  80102a:	83 e8 37             	sub    $0x37,%eax
  80102d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801033:	3b 45 10             	cmp    0x10(%ebp),%eax
  801036:	7d 19                	jge    801051 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801038:	ff 45 08             	incl   0x8(%ebp)
  80103b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801042:	89 c2                	mov    %eax,%edx
  801044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801047:	01 d0                	add    %edx,%eax
  801049:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80104c:	e9 7b ff ff ff       	jmp    800fcc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801051:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801052:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801056:	74 08                	je     801060 <strtol+0x134>
		*endptr = (char *) s;
  801058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105b:	8b 55 08             	mov    0x8(%ebp),%edx
  80105e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801060:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801064:	74 07                	je     80106d <strtol+0x141>
  801066:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801069:	f7 d8                	neg    %eax
  80106b:	eb 03                	jmp    801070 <strtol+0x144>
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <ltostr>:

void
ltostr(long value, char *str)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801078:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80107f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801086:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80108a:	79 13                	jns    80109f <ltostr+0x2d>
	{
		neg = 1;
  80108c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801099:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80109c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a7:	99                   	cltd   
  8010a8:	f7 f9                	idiv   %ecx
  8010aa:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b0:	8d 50 01             	lea    0x1(%eax),%edx
  8010b3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b6:	89 c2                	mov    %eax,%edx
  8010b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bb:	01 d0                	add    %edx,%eax
  8010bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010c0:	83 c2 30             	add    $0x30,%edx
  8010c3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010cd:	f7 e9                	imul   %ecx
  8010cf:	c1 fa 02             	sar    $0x2,%edx
  8010d2:	89 c8                	mov    %ecx,%eax
  8010d4:	c1 f8 1f             	sar    $0x1f,%eax
  8010d7:	29 c2                	sub    %eax,%edx
  8010d9:	89 d0                	mov    %edx,%eax
  8010db:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e6:	f7 e9                	imul   %ecx
  8010e8:	c1 fa 02             	sar    $0x2,%edx
  8010eb:	89 c8                	mov    %ecx,%eax
  8010ed:	c1 f8 1f             	sar    $0x1f,%eax
  8010f0:	29 c2                	sub    %eax,%edx
  8010f2:	89 d0                	mov    %edx,%eax
  8010f4:	c1 e0 02             	shl    $0x2,%eax
  8010f7:	01 d0                	add    %edx,%eax
  8010f9:	01 c0                	add    %eax,%eax
  8010fb:	29 c1                	sub    %eax,%ecx
  8010fd:	89 ca                	mov    %ecx,%edx
  8010ff:	85 d2                	test   %edx,%edx
  801101:	75 9c                	jne    80109f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801103:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80110a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110d:	48                   	dec    %eax
  80110e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801111:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801115:	74 3d                	je     801154 <ltostr+0xe2>
		start = 1 ;
  801117:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80111e:	eb 34                	jmp    801154 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801120:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801123:	8b 45 0c             	mov    0xc(%ebp),%eax
  801126:	01 d0                	add    %edx,%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80112d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	01 c2                	add    %eax,%edx
  801135:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113b:	01 c8                	add    %ecx,%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801141:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801144:	8b 45 0c             	mov    0xc(%ebp),%eax
  801147:	01 c2                	add    %eax,%edx
  801149:	8a 45 eb             	mov    -0x15(%ebp),%al
  80114c:	88 02                	mov    %al,(%edx)
		start++ ;
  80114e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801151:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801157:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80115a:	7c c4                	jl     801120 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80115c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	01 d0                	add    %edx,%eax
  801164:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801167:	90                   	nop
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801170:	ff 75 08             	pushl  0x8(%ebp)
  801173:	e8 54 fa ff ff       	call   800bcc <strlen>
  801178:	83 c4 04             	add    $0x4,%esp
  80117b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	e8 46 fa ff ff       	call   800bcc <strlen>
  801186:	83 c4 04             	add    $0x4,%esp
  801189:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80118c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801193:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80119a:	eb 17                	jmp    8011b3 <strcconcat+0x49>
		final[s] = str1[s] ;
  80119c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119f:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a2:	01 c2                	add    %eax,%edx
  8011a4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	01 c8                	add    %ecx,%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011b0:	ff 45 fc             	incl   -0x4(%ebp)
  8011b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011b9:	7c e1                	jl     80119c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011c9:	eb 1f                	jmp    8011ea <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ce:	8d 50 01             	lea    0x1(%eax),%edx
  8011d1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011d4:	89 c2                	mov    %eax,%edx
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	01 c2                	add    %eax,%edx
  8011db:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e1:	01 c8                	add    %ecx,%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011e7:	ff 45 f8             	incl   -0x8(%ebp)
  8011ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011f0:	7c d9                	jl     8011cb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f8:	01 d0                	add    %edx,%eax
  8011fa:	c6 00 00             	movb   $0x0,(%eax)
}
  8011fd:	90                   	nop
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    

00801200 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801203:	8b 45 14             	mov    0x14(%ebp),%eax
  801206:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80120c:	8b 45 14             	mov    0x14(%ebp),%eax
  80120f:	8b 00                	mov    (%eax),%eax
  801211:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801218:	8b 45 10             	mov    0x10(%ebp),%eax
  80121b:	01 d0                	add    %edx,%eax
  80121d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801223:	eb 0c                	jmp    801231 <strsplit+0x31>
			*string++ = 0;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8d 50 01             	lea    0x1(%eax),%edx
  80122b:	89 55 08             	mov    %edx,0x8(%ebp)
  80122e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	84 c0                	test   %al,%al
  801238:	74 18                	je     801252 <strsplit+0x52>
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	0f be c0             	movsbl %al,%eax
  801242:	50                   	push   %eax
  801243:	ff 75 0c             	pushl  0xc(%ebp)
  801246:	e8 13 fb ff ff       	call   800d5e <strchr>
  80124b:	83 c4 08             	add    $0x8,%esp
  80124e:	85 c0                	test   %eax,%eax
  801250:	75 d3                	jne    801225 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	84 c0                	test   %al,%al
  801259:	74 5a                	je     8012b5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80125b:	8b 45 14             	mov    0x14(%ebp),%eax
  80125e:	8b 00                	mov    (%eax),%eax
  801260:	83 f8 0f             	cmp    $0xf,%eax
  801263:	75 07                	jne    80126c <strsplit+0x6c>
		{
			return 0;
  801265:	b8 00 00 00 00       	mov    $0x0,%eax
  80126a:	eb 66                	jmp    8012d2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	8b 00                	mov    (%eax),%eax
  801271:	8d 48 01             	lea    0x1(%eax),%ecx
  801274:	8b 55 14             	mov    0x14(%ebp),%edx
  801277:	89 0a                	mov    %ecx,(%edx)
  801279:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	01 c2                	add    %eax,%edx
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80128a:	eb 03                	jmp    80128f <strsplit+0x8f>
			string++;
  80128c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	8a 00                	mov    (%eax),%al
  801294:	84 c0                	test   %al,%al
  801296:	74 8b                	je     801223 <strsplit+0x23>
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	0f be c0             	movsbl %al,%eax
  8012a0:	50                   	push   %eax
  8012a1:	ff 75 0c             	pushl  0xc(%ebp)
  8012a4:	e8 b5 fa ff ff       	call   800d5e <strchr>
  8012a9:	83 c4 08             	add    $0x8,%esp
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	74 dc                	je     80128c <strsplit+0x8c>
			string++;
	}
  8012b0:	e9 6e ff ff ff       	jmp    801223 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012b5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b9:	8b 00                	mov    (%eax),%eax
  8012bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c5:	01 d0                	add    %edx,%eax
  8012c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012cd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	57                   	push   %edi
  8012d8:	56                   	push   %esi
  8012d9:	53                   	push   %ebx
  8012da:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012ec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012ef:	cd 30                	int    $0x30
  8012f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	5b                   	pop    %ebx
  8012fb:	5e                   	pop    %esi
  8012fc:	5f                   	pop    %edi
  8012fd:	5d                   	pop    %ebp
  8012fe:	c3                   	ret    

008012ff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	8b 45 10             	mov    0x10(%ebp),%eax
  801308:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80130b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	52                   	push   %edx
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	50                   	push   %eax
  80131b:	6a 00                	push   $0x0
  80131d:	e8 b2 ff ff ff       	call   8012d4 <syscall>
  801322:	83 c4 18             	add    $0x18,%esp
}
  801325:	90                   	nop
  801326:	c9                   	leave  
  801327:	c3                   	ret    

00801328 <sys_cgetc>:

int
sys_cgetc(void)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 01                	push   $0x1
  801337:	e8 98 ff ff ff       	call   8012d4 <syscall>
  80133c:	83 c4 18             	add    $0x18,%esp
}
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	50                   	push   %eax
  801350:	6a 05                	push   $0x5
  801352:	e8 7d ff ff ff       	call   8012d4 <syscall>
  801357:	83 c4 18             	add    $0x18,%esp
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	6a 00                	push   $0x0
  801369:	6a 02                	push   $0x2
  80136b:	e8 64 ff ff ff       	call   8012d4 <syscall>
  801370:	83 c4 18             	add    $0x18,%esp
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 03                	push   $0x3
  801384:	e8 4b ff ff ff       	call   8012d4 <syscall>
  801389:	83 c4 18             	add    $0x18,%esp
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 04                	push   $0x4
  80139d:	e8 32 ff ff ff       	call   8012d4 <syscall>
  8013a2:	83 c4 18             	add    $0x18,%esp
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <sys_env_exit>:


void sys_env_exit(void)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 06                	push   $0x6
  8013b6:	e8 19 ff ff ff       	call   8012d4 <syscall>
  8013bb:	83 c4 18             	add    $0x18,%esp
}
  8013be:	90                   	nop
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8013c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	52                   	push   %edx
  8013d1:	50                   	push   %eax
  8013d2:	6a 07                	push   $0x7
  8013d4:	e8 fb fe ff ff       	call   8012d4 <syscall>
  8013d9:	83 c4 18             	add    $0x18,%esp
}
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	56                   	push   %esi
  8013e2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8013e3:	8b 75 18             	mov    0x18(%ebp),%esi
  8013e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	56                   	push   %esi
  8013f3:	53                   	push   %ebx
  8013f4:	51                   	push   %ecx
  8013f5:	52                   	push   %edx
  8013f6:	50                   	push   %eax
  8013f7:	6a 08                	push   $0x8
  8013f9:	e8 d6 fe ff ff       	call   8012d4 <syscall>
  8013fe:	83 c4 18             	add    $0x18,%esp
}
  801401:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801404:	5b                   	pop    %ebx
  801405:	5e                   	pop    %esi
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    

00801408 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80140b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	52                   	push   %edx
  801418:	50                   	push   %eax
  801419:	6a 09                	push   $0x9
  80141b:	e8 b4 fe ff ff       	call   8012d4 <syscall>
  801420:	83 c4 18             	add    $0x18,%esp
}
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	ff 75 0c             	pushl  0xc(%ebp)
  801431:	ff 75 08             	pushl  0x8(%ebp)
  801434:	6a 0a                	push   $0xa
  801436:	e8 99 fe ff ff       	call   8012d4 <syscall>
  80143b:	83 c4 18             	add    $0x18,%esp
}
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 0b                	push   $0xb
  80144f:	e8 80 fe ff ff       	call   8012d4 <syscall>
  801454:	83 c4 18             	add    $0x18,%esp
}
  801457:	c9                   	leave  
  801458:	c3                   	ret    

00801459 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 0c                	push   $0xc
  801468:	e8 67 fe ff ff       	call   8012d4 <syscall>
  80146d:	83 c4 18             	add    $0x18,%esp
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 0d                	push   $0xd
  801481:	e8 4e fe ff ff       	call   8012d4 <syscall>
  801486:	83 c4 18             	add    $0x18,%esp
}
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	ff 75 08             	pushl  0x8(%ebp)
  80149a:	6a 11                	push   $0x11
  80149c:	e8 33 fe ff ff       	call   8012d4 <syscall>
  8014a1:	83 c4 18             	add    $0x18,%esp
	return;
  8014a4:	90                   	nop
}
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    

008014a7 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	6a 12                	push   $0x12
  8014b8:	e8 17 fe ff ff       	call   8012d4 <syscall>
  8014bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8014c0:	90                   	nop
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 0e                	push   $0xe
  8014d2:	e8 fd fd ff ff       	call   8012d4 <syscall>
  8014d7:	83 c4 18             	add    $0x18,%esp
}
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	ff 75 08             	pushl  0x8(%ebp)
  8014ea:	6a 0f                	push   $0xf
  8014ec:	e8 e3 fd ff ff       	call   8012d4 <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 10                	push   $0x10
  801505:	e8 ca fd ff ff       	call   8012d4 <syscall>
  80150a:	83 c4 18             	add    $0x18,%esp
}
  80150d:	90                   	nop
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 14                	push   $0x14
  80151f:	e8 b0 fd ff ff       	call   8012d4 <syscall>
  801524:	83 c4 18             	add    $0x18,%esp
}
  801527:	90                   	nop
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 15                	push   $0x15
  801539:	e8 96 fd ff ff       	call   8012d4 <syscall>
  80153e:	83 c4 18             	add    $0x18,%esp
}
  801541:	90                   	nop
  801542:	c9                   	leave  
  801543:	c3                   	ret    

00801544 <sys_cputc>:


void
sys_cputc(const char c)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	83 ec 04             	sub    $0x4,%esp
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801550:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	50                   	push   %eax
  80155d:	6a 16                	push   $0x16
  80155f:	e8 70 fd ff ff       	call   8012d4 <syscall>
  801564:	83 c4 18             	add    $0x18,%esp
}
  801567:	90                   	nop
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 17                	push   $0x17
  801579:	e8 56 fd ff ff       	call   8012d4 <syscall>
  80157e:	83 c4 18             	add    $0x18,%esp
}
  801581:	90                   	nop
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	ff 75 0c             	pushl  0xc(%ebp)
  801593:	50                   	push   %eax
  801594:	6a 18                	push   $0x18
  801596:	e8 39 fd ff ff       	call   8012d4 <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	52                   	push   %edx
  8015b0:	50                   	push   %eax
  8015b1:	6a 1b                	push   $0x1b
  8015b3:	e8 1c fd ff ff       	call   8012d4 <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	52                   	push   %edx
  8015cd:	50                   	push   %eax
  8015ce:	6a 19                	push   $0x19
  8015d0:	e8 ff fc ff ff       	call   8012d4 <syscall>
  8015d5:	83 c4 18             	add    $0x18,%esp
}
  8015d8:	90                   	nop
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	52                   	push   %edx
  8015eb:	50                   	push   %eax
  8015ec:	6a 1a                	push   $0x1a
  8015ee:	e8 e1 fc ff ff       	call   8012d4 <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	90                   	nop
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	83 ec 04             	sub    $0x4,%esp
  8015ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801602:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801605:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801608:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	6a 00                	push   $0x0
  801611:	51                   	push   %ecx
  801612:	52                   	push   %edx
  801613:	ff 75 0c             	pushl  0xc(%ebp)
  801616:	50                   	push   %eax
  801617:	6a 1c                	push   $0x1c
  801619:	e8 b6 fc ff ff       	call   8012d4 <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801626:	8b 55 0c             	mov    0xc(%ebp),%edx
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	52                   	push   %edx
  801633:	50                   	push   %eax
  801634:	6a 1d                	push   $0x1d
  801636:	e8 99 fc ff ff       	call   8012d4 <syscall>
  80163b:	83 c4 18             	add    $0x18,%esp
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801643:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801646:	8b 55 0c             	mov    0xc(%ebp),%edx
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	51                   	push   %ecx
  801651:	52                   	push   %edx
  801652:	50                   	push   %eax
  801653:	6a 1e                	push   $0x1e
  801655:	e8 7a fc ff ff       	call   8012d4 <syscall>
  80165a:	83 c4 18             	add    $0x18,%esp
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801662:	8b 55 0c             	mov    0xc(%ebp),%edx
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	52                   	push   %edx
  80166f:	50                   	push   %eax
  801670:	6a 1f                	push   $0x1f
  801672:	e8 5d fc ff ff       	call   8012d4 <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 20                	push   $0x20
  80168b:	e8 44 fc ff ff       	call   8012d4 <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	ff 75 10             	pushl  0x10(%ebp)
  8016a2:	ff 75 0c             	pushl  0xc(%ebp)
  8016a5:	50                   	push   %eax
  8016a6:	6a 21                	push   $0x21
  8016a8:	e8 27 fc ff ff       	call   8012d4 <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	50                   	push   %eax
  8016c1:	6a 22                	push   $0x22
  8016c3:	e8 0c fc ff ff       	call   8012d4 <syscall>
  8016c8:	83 c4 18             	add    $0x18,%esp
}
  8016cb:	90                   	nop
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	50                   	push   %eax
  8016dd:	6a 23                	push   $0x23
  8016df:	e8 f0 fb ff ff       	call   8012d4 <syscall>
  8016e4:	83 c4 18             	add    $0x18,%esp
}
  8016e7:	90                   	nop
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016f3:	8d 50 04             	lea    0x4(%eax),%edx
  8016f6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	52                   	push   %edx
  801700:	50                   	push   %eax
  801701:	6a 24                	push   $0x24
  801703:	e8 cc fb ff ff       	call   8012d4 <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
	return result;
  80170b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80170e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801711:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801714:	89 01                	mov    %eax,(%ecx)
  801716:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	c9                   	leave  
  80171d:	c2 04 00             	ret    $0x4

00801720 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	ff 75 10             	pushl  0x10(%ebp)
  80172a:	ff 75 0c             	pushl  0xc(%ebp)
  80172d:	ff 75 08             	pushl  0x8(%ebp)
  801730:	6a 13                	push   $0x13
  801732:	e8 9d fb ff ff       	call   8012d4 <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
	return ;
  80173a:	90                   	nop
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <sys_rcr2>:
uint32 sys_rcr2()
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 25                	push   $0x25
  80174c:	e8 83 fb ff ff       	call   8012d4 <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 04             	sub    $0x4,%esp
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801762:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	50                   	push   %eax
  80176f:	6a 26                	push   $0x26
  801771:	e8 5e fb ff ff       	call   8012d4 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
	return ;
  801779:	90                   	nop
}
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <rsttst>:
void rsttst()
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 28                	push   $0x28
  80178b:	e8 44 fb ff ff       	call   8012d4 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
	return ;
  801793:	90                   	nop
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	8b 45 14             	mov    0x14(%ebp),%eax
  80179f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017a2:	8b 55 18             	mov    0x18(%ebp),%edx
  8017a5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017a9:	52                   	push   %edx
  8017aa:	50                   	push   %eax
  8017ab:	ff 75 10             	pushl  0x10(%ebp)
  8017ae:	ff 75 0c             	pushl  0xc(%ebp)
  8017b1:	ff 75 08             	pushl  0x8(%ebp)
  8017b4:	6a 27                	push   $0x27
  8017b6:	e8 19 fb ff ff       	call   8012d4 <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8017be:	90                   	nop
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <chktst>:
void chktst(uint32 n)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	ff 75 08             	pushl  0x8(%ebp)
  8017cf:	6a 29                	push   $0x29
  8017d1:	e8 fe fa ff ff       	call   8012d4 <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d9:	90                   	nop
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <inctst>:

void inctst()
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 2a                	push   $0x2a
  8017eb:	e8 e4 fa ff ff       	call   8012d4 <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f3:	90                   	nop
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <gettst>:
uint32 gettst()
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 2b                	push   $0x2b
  801805:	e8 ca fa ff ff       	call   8012d4 <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
}
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 2c                	push   $0x2c
  801821:	e8 ae fa ff ff       	call   8012d4 <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
  801829:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80182c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801830:	75 07                	jne    801839 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801832:	b8 01 00 00 00       	mov    $0x1,%eax
  801837:	eb 05                	jmp    80183e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801839:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 2c                	push   $0x2c
  801852:	e8 7d fa ff ff       	call   8012d4 <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
  80185a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80185d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801861:	75 07                	jne    80186a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801863:	b8 01 00 00 00       	mov    $0x1,%eax
  801868:	eb 05                	jmp    80186f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80186a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 2c                	push   $0x2c
  801883:	e8 4c fa ff ff       	call   8012d4 <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
  80188b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80188e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801892:	75 07                	jne    80189b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801894:	b8 01 00 00 00       	mov    $0x1,%eax
  801899:	eb 05                	jmp    8018a0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 2c                	push   $0x2c
  8018b4:	e8 1b fa ff ff       	call   8012d4 <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
  8018bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8018bf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8018c3:	75 07                	jne    8018cc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8018c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ca:	eb 05                	jmp    8018d1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8018cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	ff 75 08             	pushl  0x8(%ebp)
  8018e1:	6a 2d                	push   $0x2d
  8018e3:	e8 ec f9 ff ff       	call   8012d4 <syscall>
  8018e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018eb:	90                   	nop
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	6a 00                	push   $0x0
  801900:	53                   	push   %ebx
  801901:	51                   	push   %ecx
  801902:	52                   	push   %edx
  801903:	50                   	push   %eax
  801904:	6a 2e                	push   $0x2e
  801906:	e8 c9 f9 ff ff       	call   8012d4 <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801916:	8b 55 0c             	mov    0xc(%ebp),%edx
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	52                   	push   %edx
  801923:	50                   	push   %eax
  801924:	6a 2f                	push   $0x2f
  801926:	e8 a9 f9 ff ff       	call   8012d4 <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801936:	8b 55 08             	mov    0x8(%ebp),%edx
  801939:	89 d0                	mov    %edx,%eax
  80193b:	c1 e0 02             	shl    $0x2,%eax
  80193e:	01 d0                	add    %edx,%eax
  801940:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801947:	01 d0                	add    %edx,%eax
  801949:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801950:	01 d0                	add    %edx,%eax
  801952:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801959:	01 d0                	add    %edx,%eax
  80195b:	c1 e0 04             	shl    $0x4,%eax
  80195e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801961:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801968:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80196b:	83 ec 0c             	sub    $0xc,%esp
  80196e:	50                   	push   %eax
  80196f:	e8 76 fd ff ff       	call   8016ea <sys_get_virtual_time>
  801974:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801977:	eb 41                	jmp    8019ba <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801979:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80197c:	83 ec 0c             	sub    $0xc,%esp
  80197f:	50                   	push   %eax
  801980:	e8 65 fd ff ff       	call   8016ea <sys_get_virtual_time>
  801985:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801988:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80198b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80198e:	29 c2                	sub    %eax,%edx
  801990:	89 d0                	mov    %edx,%eax
  801992:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801995:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801998:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199b:	89 d1                	mov    %edx,%ecx
  80199d:	29 c1                	sub    %eax,%ecx
  80199f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a5:	39 c2                	cmp    %eax,%edx
  8019a7:	0f 97 c0             	seta   %al
  8019aa:	0f b6 c0             	movzbl %al,%eax
  8019ad:	29 c1                	sub    %eax,%ecx
  8019af:	89 c8                	mov    %ecx,%eax
  8019b1:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8019b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8019ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019c0:	72 b7                	jb     801979 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8019c2:	90                   	nop
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
  8019c8:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8019cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8019d2:	eb 03                	jmp    8019d7 <busy_wait+0x12>
  8019d4:	ff 45 fc             	incl   -0x4(%ebp)
  8019d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019dd:	72 f5                	jb     8019d4 <busy_wait+0xf>
	return i;
  8019df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <__udivdi3>:
  8019e4:	55                   	push   %ebp
  8019e5:	57                   	push   %edi
  8019e6:	56                   	push   %esi
  8019e7:	53                   	push   %ebx
  8019e8:	83 ec 1c             	sub    $0x1c,%esp
  8019eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019fb:	89 ca                	mov    %ecx,%edx
  8019fd:	89 f8                	mov    %edi,%eax
  8019ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a03:	85 f6                	test   %esi,%esi
  801a05:	75 2d                	jne    801a34 <__udivdi3+0x50>
  801a07:	39 cf                	cmp    %ecx,%edi
  801a09:	77 65                	ja     801a70 <__udivdi3+0x8c>
  801a0b:	89 fd                	mov    %edi,%ebp
  801a0d:	85 ff                	test   %edi,%edi
  801a0f:	75 0b                	jne    801a1c <__udivdi3+0x38>
  801a11:	b8 01 00 00 00       	mov    $0x1,%eax
  801a16:	31 d2                	xor    %edx,%edx
  801a18:	f7 f7                	div    %edi
  801a1a:	89 c5                	mov    %eax,%ebp
  801a1c:	31 d2                	xor    %edx,%edx
  801a1e:	89 c8                	mov    %ecx,%eax
  801a20:	f7 f5                	div    %ebp
  801a22:	89 c1                	mov    %eax,%ecx
  801a24:	89 d8                	mov    %ebx,%eax
  801a26:	f7 f5                	div    %ebp
  801a28:	89 cf                	mov    %ecx,%edi
  801a2a:	89 fa                	mov    %edi,%edx
  801a2c:	83 c4 1c             	add    $0x1c,%esp
  801a2f:	5b                   	pop    %ebx
  801a30:	5e                   	pop    %esi
  801a31:	5f                   	pop    %edi
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    
  801a34:	39 ce                	cmp    %ecx,%esi
  801a36:	77 28                	ja     801a60 <__udivdi3+0x7c>
  801a38:	0f bd fe             	bsr    %esi,%edi
  801a3b:	83 f7 1f             	xor    $0x1f,%edi
  801a3e:	75 40                	jne    801a80 <__udivdi3+0x9c>
  801a40:	39 ce                	cmp    %ecx,%esi
  801a42:	72 0a                	jb     801a4e <__udivdi3+0x6a>
  801a44:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a48:	0f 87 9e 00 00 00    	ja     801aec <__udivdi3+0x108>
  801a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a53:	89 fa                	mov    %edi,%edx
  801a55:	83 c4 1c             	add    $0x1c,%esp
  801a58:	5b                   	pop    %ebx
  801a59:	5e                   	pop    %esi
  801a5a:	5f                   	pop    %edi
  801a5b:	5d                   	pop    %ebp
  801a5c:	c3                   	ret    
  801a5d:	8d 76 00             	lea    0x0(%esi),%esi
  801a60:	31 ff                	xor    %edi,%edi
  801a62:	31 c0                	xor    %eax,%eax
  801a64:	89 fa                	mov    %edi,%edx
  801a66:	83 c4 1c             	add    $0x1c,%esp
  801a69:	5b                   	pop    %ebx
  801a6a:	5e                   	pop    %esi
  801a6b:	5f                   	pop    %edi
  801a6c:	5d                   	pop    %ebp
  801a6d:	c3                   	ret    
  801a6e:	66 90                	xchg   %ax,%ax
  801a70:	89 d8                	mov    %ebx,%eax
  801a72:	f7 f7                	div    %edi
  801a74:	31 ff                	xor    %edi,%edi
  801a76:	89 fa                	mov    %edi,%edx
  801a78:	83 c4 1c             	add    $0x1c,%esp
  801a7b:	5b                   	pop    %ebx
  801a7c:	5e                   	pop    %esi
  801a7d:	5f                   	pop    %edi
  801a7e:	5d                   	pop    %ebp
  801a7f:	c3                   	ret    
  801a80:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a85:	89 eb                	mov    %ebp,%ebx
  801a87:	29 fb                	sub    %edi,%ebx
  801a89:	89 f9                	mov    %edi,%ecx
  801a8b:	d3 e6                	shl    %cl,%esi
  801a8d:	89 c5                	mov    %eax,%ebp
  801a8f:	88 d9                	mov    %bl,%cl
  801a91:	d3 ed                	shr    %cl,%ebp
  801a93:	89 e9                	mov    %ebp,%ecx
  801a95:	09 f1                	or     %esi,%ecx
  801a97:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a9b:	89 f9                	mov    %edi,%ecx
  801a9d:	d3 e0                	shl    %cl,%eax
  801a9f:	89 c5                	mov    %eax,%ebp
  801aa1:	89 d6                	mov    %edx,%esi
  801aa3:	88 d9                	mov    %bl,%cl
  801aa5:	d3 ee                	shr    %cl,%esi
  801aa7:	89 f9                	mov    %edi,%ecx
  801aa9:	d3 e2                	shl    %cl,%edx
  801aab:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aaf:	88 d9                	mov    %bl,%cl
  801ab1:	d3 e8                	shr    %cl,%eax
  801ab3:	09 c2                	or     %eax,%edx
  801ab5:	89 d0                	mov    %edx,%eax
  801ab7:	89 f2                	mov    %esi,%edx
  801ab9:	f7 74 24 0c          	divl   0xc(%esp)
  801abd:	89 d6                	mov    %edx,%esi
  801abf:	89 c3                	mov    %eax,%ebx
  801ac1:	f7 e5                	mul    %ebp
  801ac3:	39 d6                	cmp    %edx,%esi
  801ac5:	72 19                	jb     801ae0 <__udivdi3+0xfc>
  801ac7:	74 0b                	je     801ad4 <__udivdi3+0xf0>
  801ac9:	89 d8                	mov    %ebx,%eax
  801acb:	31 ff                	xor    %edi,%edi
  801acd:	e9 58 ff ff ff       	jmp    801a2a <__udivdi3+0x46>
  801ad2:	66 90                	xchg   %ax,%ax
  801ad4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ad8:	89 f9                	mov    %edi,%ecx
  801ada:	d3 e2                	shl    %cl,%edx
  801adc:	39 c2                	cmp    %eax,%edx
  801ade:	73 e9                	jae    801ac9 <__udivdi3+0xe5>
  801ae0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ae3:	31 ff                	xor    %edi,%edi
  801ae5:	e9 40 ff ff ff       	jmp    801a2a <__udivdi3+0x46>
  801aea:	66 90                	xchg   %ax,%ax
  801aec:	31 c0                	xor    %eax,%eax
  801aee:	e9 37 ff ff ff       	jmp    801a2a <__udivdi3+0x46>
  801af3:	90                   	nop

00801af4 <__umoddi3>:
  801af4:	55                   	push   %ebp
  801af5:	57                   	push   %edi
  801af6:	56                   	push   %esi
  801af7:	53                   	push   %ebx
  801af8:	83 ec 1c             	sub    $0x1c,%esp
  801afb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801aff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b07:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b13:	89 f3                	mov    %esi,%ebx
  801b15:	89 fa                	mov    %edi,%edx
  801b17:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b1b:	89 34 24             	mov    %esi,(%esp)
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	75 1a                	jne    801b3c <__umoddi3+0x48>
  801b22:	39 f7                	cmp    %esi,%edi
  801b24:	0f 86 a2 00 00 00    	jbe    801bcc <__umoddi3+0xd8>
  801b2a:	89 c8                	mov    %ecx,%eax
  801b2c:	89 f2                	mov    %esi,%edx
  801b2e:	f7 f7                	div    %edi
  801b30:	89 d0                	mov    %edx,%eax
  801b32:	31 d2                	xor    %edx,%edx
  801b34:	83 c4 1c             	add    $0x1c,%esp
  801b37:	5b                   	pop    %ebx
  801b38:	5e                   	pop    %esi
  801b39:	5f                   	pop    %edi
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    
  801b3c:	39 f0                	cmp    %esi,%eax
  801b3e:	0f 87 ac 00 00 00    	ja     801bf0 <__umoddi3+0xfc>
  801b44:	0f bd e8             	bsr    %eax,%ebp
  801b47:	83 f5 1f             	xor    $0x1f,%ebp
  801b4a:	0f 84 ac 00 00 00    	je     801bfc <__umoddi3+0x108>
  801b50:	bf 20 00 00 00       	mov    $0x20,%edi
  801b55:	29 ef                	sub    %ebp,%edi
  801b57:	89 fe                	mov    %edi,%esi
  801b59:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b5d:	89 e9                	mov    %ebp,%ecx
  801b5f:	d3 e0                	shl    %cl,%eax
  801b61:	89 d7                	mov    %edx,%edi
  801b63:	89 f1                	mov    %esi,%ecx
  801b65:	d3 ef                	shr    %cl,%edi
  801b67:	09 c7                	or     %eax,%edi
  801b69:	89 e9                	mov    %ebp,%ecx
  801b6b:	d3 e2                	shl    %cl,%edx
  801b6d:	89 14 24             	mov    %edx,(%esp)
  801b70:	89 d8                	mov    %ebx,%eax
  801b72:	d3 e0                	shl    %cl,%eax
  801b74:	89 c2                	mov    %eax,%edx
  801b76:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b7a:	d3 e0                	shl    %cl,%eax
  801b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b80:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b84:	89 f1                	mov    %esi,%ecx
  801b86:	d3 e8                	shr    %cl,%eax
  801b88:	09 d0                	or     %edx,%eax
  801b8a:	d3 eb                	shr    %cl,%ebx
  801b8c:	89 da                	mov    %ebx,%edx
  801b8e:	f7 f7                	div    %edi
  801b90:	89 d3                	mov    %edx,%ebx
  801b92:	f7 24 24             	mull   (%esp)
  801b95:	89 c6                	mov    %eax,%esi
  801b97:	89 d1                	mov    %edx,%ecx
  801b99:	39 d3                	cmp    %edx,%ebx
  801b9b:	0f 82 87 00 00 00    	jb     801c28 <__umoddi3+0x134>
  801ba1:	0f 84 91 00 00 00    	je     801c38 <__umoddi3+0x144>
  801ba7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bab:	29 f2                	sub    %esi,%edx
  801bad:	19 cb                	sbb    %ecx,%ebx
  801baf:	89 d8                	mov    %ebx,%eax
  801bb1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bb5:	d3 e0                	shl    %cl,%eax
  801bb7:	89 e9                	mov    %ebp,%ecx
  801bb9:	d3 ea                	shr    %cl,%edx
  801bbb:	09 d0                	or     %edx,%eax
  801bbd:	89 e9                	mov    %ebp,%ecx
  801bbf:	d3 eb                	shr    %cl,%ebx
  801bc1:	89 da                	mov    %ebx,%edx
  801bc3:	83 c4 1c             	add    $0x1c,%esp
  801bc6:	5b                   	pop    %ebx
  801bc7:	5e                   	pop    %esi
  801bc8:	5f                   	pop    %edi
  801bc9:	5d                   	pop    %ebp
  801bca:	c3                   	ret    
  801bcb:	90                   	nop
  801bcc:	89 fd                	mov    %edi,%ebp
  801bce:	85 ff                	test   %edi,%edi
  801bd0:	75 0b                	jne    801bdd <__umoddi3+0xe9>
  801bd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd7:	31 d2                	xor    %edx,%edx
  801bd9:	f7 f7                	div    %edi
  801bdb:	89 c5                	mov    %eax,%ebp
  801bdd:	89 f0                	mov    %esi,%eax
  801bdf:	31 d2                	xor    %edx,%edx
  801be1:	f7 f5                	div    %ebp
  801be3:	89 c8                	mov    %ecx,%eax
  801be5:	f7 f5                	div    %ebp
  801be7:	89 d0                	mov    %edx,%eax
  801be9:	e9 44 ff ff ff       	jmp    801b32 <__umoddi3+0x3e>
  801bee:	66 90                	xchg   %ax,%ax
  801bf0:	89 c8                	mov    %ecx,%eax
  801bf2:	89 f2                	mov    %esi,%edx
  801bf4:	83 c4 1c             	add    $0x1c,%esp
  801bf7:	5b                   	pop    %ebx
  801bf8:	5e                   	pop    %esi
  801bf9:	5f                   	pop    %edi
  801bfa:	5d                   	pop    %ebp
  801bfb:	c3                   	ret    
  801bfc:	3b 04 24             	cmp    (%esp),%eax
  801bff:	72 06                	jb     801c07 <__umoddi3+0x113>
  801c01:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c05:	77 0f                	ja     801c16 <__umoddi3+0x122>
  801c07:	89 f2                	mov    %esi,%edx
  801c09:	29 f9                	sub    %edi,%ecx
  801c0b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c0f:	89 14 24             	mov    %edx,(%esp)
  801c12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c16:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c1a:	8b 14 24             	mov    (%esp),%edx
  801c1d:	83 c4 1c             	add    $0x1c,%esp
  801c20:	5b                   	pop    %ebx
  801c21:	5e                   	pop    %esi
  801c22:	5f                   	pop    %edi
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    
  801c25:	8d 76 00             	lea    0x0(%esi),%esi
  801c28:	2b 04 24             	sub    (%esp),%eax
  801c2b:	19 fa                	sbb    %edi,%edx
  801c2d:	89 d1                	mov    %edx,%ecx
  801c2f:	89 c6                	mov    %eax,%esi
  801c31:	e9 71 ff ff ff       	jmp    801ba7 <__umoddi3+0xb3>
  801c36:	66 90                	xchg   %ax,%ax
  801c38:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c3c:	72 ea                	jb     801c28 <__umoddi3+0x134>
  801c3e:	89 d9                	mov    %ebx,%ecx
  801c40:	e9 62 ff ff ff       	jmp    801ba7 <__umoddi3+0xb3>
