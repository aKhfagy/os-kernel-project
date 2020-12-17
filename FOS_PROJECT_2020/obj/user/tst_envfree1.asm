
obj/user/tst_envfree1:     file format elf32-i386


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
  800031:	e8 55 01 00 00       	call   80018b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests environment free run tef1 5 3
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing scenario 1: without using dynamic allocation/de-allocation, shared variables and semaphores
	// Testing removing the allocated pages in mem, WS, mapped page tables, env's directory and env's page file

	int freeFrames_before = sys_calculate_free_frames() ;
  80003e:	e8 25 14 00 00       	call   801468 <sys_calculate_free_frames>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800046:	e8 a0 14 00 00       	call   8014eb <sys_pf_calculate_allocated_pages>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	ff 75 f4             	pushl  -0xc(%ebp)
  800054:	68 80 1c 80 00       	push   $0x801c80
  800059:	e8 14 05 00 00       	call   800572 <cprintf>
  80005e:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes

	int32 envIdProcessA = sys_create_env("ef_fib", (myEnv->page_WS_max_size), 50);
  800061:	a1 20 30 80 00       	mov    0x803020,%eax
  800066:	8b 40 74             	mov    0x74(%eax),%eax
  800069:	83 ec 04             	sub    $0x4,%esp
  80006c:	6a 32                	push   $0x32
  80006e:	50                   	push   %eax
  80006f:	68 b3 1c 80 00       	push   $0x801cb3
  800074:	e8 44 16 00 00       	call   8016bd <sys_create_env>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int32 envIdProcessB = sys_create_env("ef_fact", (myEnv->page_WS_max_size)-1, 50);
  80007f:	a1 20 30 80 00       	mov    0x803020,%eax
  800084:	8b 40 74             	mov    0x74(%eax),%eax
  800087:	48                   	dec    %eax
  800088:	83 ec 04             	sub    $0x4,%esp
  80008b:	6a 32                	push   $0x32
  80008d:	50                   	push   %eax
  80008e:	68 ba 1c 80 00       	push   $0x801cba
  800093:	e8 25 16 00 00       	call   8016bd <sys_create_env>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessC = sys_create_env("ef_fos_add",(myEnv->page_WS_max_size)*4, 50);
  80009e:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a3:	8b 40 74             	mov    0x74(%eax),%eax
  8000a6:	c1 e0 02             	shl    $0x2,%eax
  8000a9:	83 ec 04             	sub    $0x4,%esp
  8000ac:	6a 32                	push   $0x32
  8000ae:	50                   	push   %eax
  8000af:	68 c2 1c 80 00       	push   $0x801cc2
  8000b4:	e8 04 16 00 00       	call   8016bd <sys_create_env>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Run 3 processes
	sys_run_env(envIdProcessA);
  8000bf:	83 ec 0c             	sub    $0xc,%esp
  8000c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c5:	e8 10 16 00 00       	call   8016da <sys_run_env>
  8000ca:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d3:	e8 02 16 00 00       	call   8016da <sys_run_env>
  8000d8:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessC);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e1:	e8 f4 15 00 00       	call   8016da <sys_run_env>
  8000e6:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	68 70 17 00 00       	push   $0x1770
  8000f1:	e8 62 18 00 00       	call   801958 <env_sleep>
  8000f6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000f9:	e8 6a 13 00 00       	call   801468 <sys_calculate_free_frames>
  8000fe:	83 ec 08             	sub    $0x8,%esp
  800101:	50                   	push   %eax
  800102:	68 d0 1c 80 00       	push   $0x801cd0
  800107:	e8 66 04 00 00       	call   800572 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp

	//Kill the 3 processes
	sys_free_env(envIdProcessA);
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	ff 75 ec             	pushl  -0x14(%ebp)
  800115:	e8 dc 15 00 00       	call   8016f6 <sys_free_env>
  80011a:	83 c4 10             	add    $0x10,%esp
	sys_free_env(envIdProcessB);
  80011d:	83 ec 0c             	sub    $0xc,%esp
  800120:	ff 75 e8             	pushl  -0x18(%ebp)
  800123:	e8 ce 15 00 00       	call   8016f6 <sys_free_env>
  800128:	83 c4 10             	add    $0x10,%esp
	sys_free_env(envIdProcessC);
  80012b:	83 ec 0c             	sub    $0xc,%esp
  80012e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800131:	e8 c0 15 00 00       	call   8016f6 <sys_free_env>
  800136:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800139:	e8 2a 13 00 00       	call   801468 <sys_calculate_free_frames>
  80013e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800141:	e8 a5 13 00 00       	call   8014eb <sys_pf_calculate_allocated_pages>
  800146:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if((freeFrames_after - freeFrames_before) !=0)
  800149:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80014c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80014f:	74 14                	je     800165 <_main+0x12d>
		panic("env_free() does not work correctly... check it again.") ;
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 04 1d 80 00       	push   $0x801d04
  800159:	6a 26                	push   $0x26
  80015b:	68 3a 1d 80 00       	push   $0x801d3a
  800160:	e8 6b 01 00 00       	call   8002d0 <_panic>

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800165:	83 ec 08             	sub    $0x8,%esp
  800168:	ff 75 e0             	pushl  -0x20(%ebp)
  80016b:	68 50 1d 80 00       	push   $0x801d50
  800170:	e8 fd 03 00 00       	call   800572 <cprintf>
  800175:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 1 for envfree completed successfully.\n");
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	68 b0 1d 80 00       	push   $0x801db0
  800180:	e8 ed 03 00 00       	call   800572 <cprintf>
  800185:	83 c4 10             	add    $0x10,%esp
	return;
  800188:	90                   	nop
}
  800189:	c9                   	leave  
  80018a:	c3                   	ret    

0080018b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800191:	e8 07 12 00 00       	call   80139d <sys_getenvindex>
  800196:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800199:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80019c:	89 d0                	mov    %edx,%eax
  80019e:	c1 e0 03             	shl    $0x3,%eax
  8001a1:	01 d0                	add    %edx,%eax
  8001a3:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001aa:	01 c8                	add    %ecx,%eax
  8001ac:	01 c0                	add    %eax,%eax
  8001ae:	01 d0                	add    %edx,%eax
  8001b0:	01 c0                	add    %eax,%eax
  8001b2:	01 d0                	add    %edx,%eax
  8001b4:	89 c2                	mov    %eax,%edx
  8001b6:	c1 e2 05             	shl    $0x5,%edx
  8001b9:	29 c2                	sub    %eax,%edx
  8001bb:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001c2:	89 c2                	mov    %eax,%edx
  8001c4:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001ca:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d4:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001da:	84 c0                	test   %al,%al
  8001dc:	74 0f                	je     8001ed <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001de:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e3:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001e8:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001f1:	7e 0a                	jle    8001fd <libmain+0x72>
		binaryname = argv[0];
  8001f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f6:	8b 00                	mov    (%eax),%eax
  8001f8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	ff 75 0c             	pushl  0xc(%ebp)
  800203:	ff 75 08             	pushl  0x8(%ebp)
  800206:	e8 2d fe ff ff       	call   800038 <_main>
  80020b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80020e:	e8 25 13 00 00       	call   801538 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	68 14 1e 80 00       	push   $0x801e14
  80021b:	e8 52 03 00 00       	call   800572 <cprintf>
  800220:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800223:	a1 20 30 80 00       	mov    0x803020,%eax
  800228:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80022e:	a1 20 30 80 00       	mov    0x803020,%eax
  800233:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	52                   	push   %edx
  80023d:	50                   	push   %eax
  80023e:	68 3c 1e 80 00       	push   $0x801e3c
  800243:	e8 2a 03 00 00       	call   800572 <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80024b:	a1 20 30 80 00       	mov    0x803020,%eax
  800250:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800256:	a1 20 30 80 00       	mov    0x803020,%eax
  80025b:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800261:	83 ec 04             	sub    $0x4,%esp
  800264:	52                   	push   %edx
  800265:	50                   	push   %eax
  800266:	68 64 1e 80 00       	push   $0x801e64
  80026b:	e8 02 03 00 00       	call   800572 <cprintf>
  800270:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800273:	a1 20 30 80 00       	mov    0x803020,%eax
  800278:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80027e:	83 ec 08             	sub    $0x8,%esp
  800281:	50                   	push   %eax
  800282:	68 a5 1e 80 00       	push   $0x801ea5
  800287:	e8 e6 02 00 00       	call   800572 <cprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	68 14 1e 80 00       	push   $0x801e14
  800297:	e8 d6 02 00 00       	call   800572 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80029f:	e8 ae 12 00 00       	call   801552 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a4:	e8 19 00 00 00       	call   8002c2 <exit>
}
  8002a9:	90                   	nop
  8002aa:	c9                   	leave  
  8002ab:	c3                   	ret    

008002ac <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8002b2:	83 ec 0c             	sub    $0xc,%esp
  8002b5:	6a 00                	push   $0x0
  8002b7:	e8 ad 10 00 00       	call   801369 <sys_env_destroy>
  8002bc:	83 c4 10             	add    $0x10,%esp
}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <exit>:

void
exit(void)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002c8:	e8 02 11 00 00       	call   8013cf <sys_env_exit>
}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d6:	8d 45 10             	lea    0x10(%ebp),%eax
  8002d9:	83 c0 04             	add    $0x4,%eax
  8002dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002df:	a1 18 31 80 00       	mov    0x803118,%eax
  8002e4:	85 c0                	test   %eax,%eax
  8002e6:	74 16                	je     8002fe <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e8:	a1 18 31 80 00       	mov    0x803118,%eax
  8002ed:	83 ec 08             	sub    $0x8,%esp
  8002f0:	50                   	push   %eax
  8002f1:	68 bc 1e 80 00       	push   $0x801ebc
  8002f6:	e8 77 02 00 00       	call   800572 <cprintf>
  8002fb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002fe:	a1 00 30 80 00       	mov    0x803000,%eax
  800303:	ff 75 0c             	pushl  0xc(%ebp)
  800306:	ff 75 08             	pushl  0x8(%ebp)
  800309:	50                   	push   %eax
  80030a:	68 c1 1e 80 00       	push   $0x801ec1
  80030f:	e8 5e 02 00 00       	call   800572 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800317:	8b 45 10             	mov    0x10(%ebp),%eax
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	ff 75 f4             	pushl  -0xc(%ebp)
  800320:	50                   	push   %eax
  800321:	e8 e1 01 00 00       	call   800507 <vcprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800329:	83 ec 08             	sub    $0x8,%esp
  80032c:	6a 00                	push   $0x0
  80032e:	68 dd 1e 80 00       	push   $0x801edd
  800333:	e8 cf 01 00 00       	call   800507 <vcprintf>
  800338:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80033b:	e8 82 ff ff ff       	call   8002c2 <exit>

	// should not return here
	while (1) ;
  800340:	eb fe                	jmp    800340 <_panic+0x70>

00800342 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800348:	a1 20 30 80 00       	mov    0x803020,%eax
  80034d:	8b 50 74             	mov    0x74(%eax),%edx
  800350:	8b 45 0c             	mov    0xc(%ebp),%eax
  800353:	39 c2                	cmp    %eax,%edx
  800355:	74 14                	je     80036b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800357:	83 ec 04             	sub    $0x4,%esp
  80035a:	68 e0 1e 80 00       	push   $0x801ee0
  80035f:	6a 26                	push   $0x26
  800361:	68 2c 1f 80 00       	push   $0x801f2c
  800366:	e8 65 ff ff ff       	call   8002d0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80036b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800372:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800379:	e9 b6 00 00 00       	jmp    800434 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
  80038f:	85 c0                	test   %eax,%eax
  800391:	75 08                	jne    80039b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800393:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800396:	e9 96 00 00 00       	jmp    800431 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80039b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003a9:	eb 5d                	jmp    800408 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b0:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b9:	c1 e2 04             	shl    $0x4,%edx
  8003bc:	01 d0                	add    %edx,%eax
  8003be:	8a 40 04             	mov    0x4(%eax),%al
  8003c1:	84 c0                	test   %al,%al
  8003c3:	75 40                	jne    800405 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ca:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d3:	c1 e2 04             	shl    $0x4,%edx
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003e5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ea:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	01 c8                	add    %ecx,%eax
  8003f6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f8:	39 c2                	cmp    %eax,%edx
  8003fa:	75 09                	jne    800405 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8003fc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800403:	eb 12                	jmp    800417 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800405:	ff 45 e8             	incl   -0x18(%ebp)
  800408:	a1 20 30 80 00       	mov    0x803020,%eax
  80040d:	8b 50 74             	mov    0x74(%eax),%edx
  800410:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800413:	39 c2                	cmp    %eax,%edx
  800415:	77 94                	ja     8003ab <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800417:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80041b:	75 14                	jne    800431 <CheckWSWithoutLastIndex+0xef>
			panic(
  80041d:	83 ec 04             	sub    $0x4,%esp
  800420:	68 38 1f 80 00       	push   $0x801f38
  800425:	6a 3a                	push   $0x3a
  800427:	68 2c 1f 80 00       	push   $0x801f2c
  80042c:	e8 9f fe ff ff       	call   8002d0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800431:	ff 45 f0             	incl   -0x10(%ebp)
  800434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800437:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043a:	0f 8c 3e ff ff ff    	jl     80037e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800440:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800447:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80044e:	eb 20                	jmp    800470 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800450:	a1 20 30 80 00       	mov    0x803020,%eax
  800455:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80045b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80045e:	c1 e2 04             	shl    $0x4,%edx
  800461:	01 d0                	add    %edx,%eax
  800463:	8a 40 04             	mov    0x4(%eax),%al
  800466:	3c 01                	cmp    $0x1,%al
  800468:	75 03                	jne    80046d <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80046a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046d:	ff 45 e0             	incl   -0x20(%ebp)
  800470:	a1 20 30 80 00       	mov    0x803020,%eax
  800475:	8b 50 74             	mov    0x74(%eax),%edx
  800478:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047b:	39 c2                	cmp    %eax,%edx
  80047d:	77 d1                	ja     800450 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80047f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800482:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800485:	74 14                	je     80049b <CheckWSWithoutLastIndex+0x159>
		panic(
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	68 8c 1f 80 00       	push   $0x801f8c
  80048f:	6a 44                	push   $0x44
  800491:	68 2c 1f 80 00       	push   $0x801f2c
  800496:	e8 35 fe ff ff       	call   8002d0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80049b:	90                   	nop
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    

0080049e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004af:	89 0a                	mov    %ecx,(%edx)
  8004b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b4:	88 d1                	mov    %dl,%cl
  8004b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c0:	8b 00                	mov    (%eax),%eax
  8004c2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c7:	75 2c                	jne    8004f5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c9:	a0 24 30 80 00       	mov    0x803024,%al
  8004ce:	0f b6 c0             	movzbl %al,%eax
  8004d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d4:	8b 12                	mov    (%edx),%edx
  8004d6:	89 d1                	mov    %edx,%ecx
  8004d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004db:	83 c2 08             	add    $0x8,%edx
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	50                   	push   %eax
  8004e2:	51                   	push   %ecx
  8004e3:	52                   	push   %edx
  8004e4:	e8 3e 0e 00 00       	call   801327 <sys_cputs>
  8004e9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f8:	8b 40 04             	mov    0x4(%eax),%eax
  8004fb:	8d 50 01             	lea    0x1(%eax),%edx
  8004fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800501:	89 50 04             	mov    %edx,0x4(%eax)
}
  800504:	90                   	nop
  800505:	c9                   	leave  
  800506:	c3                   	ret    

00800507 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800507:	55                   	push   %ebp
  800508:	89 e5                	mov    %esp,%ebp
  80050a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800510:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800517:	00 00 00 
	b.cnt = 0;
  80051a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800521:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800524:	ff 75 0c             	pushl  0xc(%ebp)
  800527:	ff 75 08             	pushl  0x8(%ebp)
  80052a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800530:	50                   	push   %eax
  800531:	68 9e 04 80 00       	push   $0x80049e
  800536:	e8 11 02 00 00       	call   80074c <vprintfmt>
  80053b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80053e:	a0 24 30 80 00       	mov    0x803024,%al
  800543:	0f b6 c0             	movzbl %al,%eax
  800546:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80054c:	83 ec 04             	sub    $0x4,%esp
  80054f:	50                   	push   %eax
  800550:	52                   	push   %edx
  800551:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800557:	83 c0 08             	add    $0x8,%eax
  80055a:	50                   	push   %eax
  80055b:	e8 c7 0d 00 00       	call   801327 <sys_cputs>
  800560:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800563:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80056a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800570:	c9                   	leave  
  800571:	c3                   	ret    

00800572 <cprintf>:

int cprintf(const char *fmt, ...) {
  800572:	55                   	push   %ebp
  800573:	89 e5                	mov    %esp,%ebp
  800575:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800578:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80057f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800582:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	83 ec 08             	sub    $0x8,%esp
  80058b:	ff 75 f4             	pushl  -0xc(%ebp)
  80058e:	50                   	push   %eax
  80058f:	e8 73 ff ff ff       	call   800507 <vcprintf>
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80059a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059d:	c9                   	leave  
  80059e:	c3                   	ret    

0080059f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
  8005a2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005a5:	e8 8e 0f 00 00       	call   801538 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b9:	50                   	push   %eax
  8005ba:	e8 48 ff ff ff       	call   800507 <vcprintf>
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005c5:	e8 88 0f 00 00       	call   801552 <sys_enable_interrupt>
	return cnt;
  8005ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    

008005cf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005cf:	55                   	push   %ebp
  8005d0:	89 e5                	mov    %esp,%ebp
  8005d2:	53                   	push   %ebx
  8005d3:	83 ec 14             	sub    $0x14,%esp
  8005d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ea:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ed:	77 55                	ja     800644 <printnum+0x75>
  8005ef:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f2:	72 05                	jb     8005f9 <printnum+0x2a>
  8005f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005f7:	77 4b                	ja     800644 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005fc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005ff:	8b 45 18             	mov    0x18(%ebp),%eax
  800602:	ba 00 00 00 00       	mov    $0x0,%edx
  800607:	52                   	push   %edx
  800608:	50                   	push   %eax
  800609:	ff 75 f4             	pushl  -0xc(%ebp)
  80060c:	ff 75 f0             	pushl  -0x10(%ebp)
  80060f:	e8 f8 13 00 00       	call   801a0c <__udivdi3>
  800614:	83 c4 10             	add    $0x10,%esp
  800617:	83 ec 04             	sub    $0x4,%esp
  80061a:	ff 75 20             	pushl  0x20(%ebp)
  80061d:	53                   	push   %ebx
  80061e:	ff 75 18             	pushl  0x18(%ebp)
  800621:	52                   	push   %edx
  800622:	50                   	push   %eax
  800623:	ff 75 0c             	pushl  0xc(%ebp)
  800626:	ff 75 08             	pushl  0x8(%ebp)
  800629:	e8 a1 ff ff ff       	call   8005cf <printnum>
  80062e:	83 c4 20             	add    $0x20,%esp
  800631:	eb 1a                	jmp    80064d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	ff 75 0c             	pushl  0xc(%ebp)
  800639:	ff 75 20             	pushl  0x20(%ebp)
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	ff d0                	call   *%eax
  800641:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800644:	ff 4d 1c             	decl   0x1c(%ebp)
  800647:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80064b:	7f e6                	jg     800633 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80064d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800650:	bb 00 00 00 00       	mov    $0x0,%ebx
  800655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800658:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80065b:	53                   	push   %ebx
  80065c:	51                   	push   %ecx
  80065d:	52                   	push   %edx
  80065e:	50                   	push   %eax
  80065f:	e8 b8 14 00 00       	call   801b1c <__umoddi3>
  800664:	83 c4 10             	add    $0x10,%esp
  800667:	05 f4 21 80 00       	add    $0x8021f4,%eax
  80066c:	8a 00                	mov    (%eax),%al
  80066e:	0f be c0             	movsbl %al,%eax
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	ff 75 0c             	pushl  0xc(%ebp)
  800677:	50                   	push   %eax
  800678:	8b 45 08             	mov    0x8(%ebp),%eax
  80067b:	ff d0                	call   *%eax
  80067d:	83 c4 10             	add    $0x10,%esp
}
  800680:	90                   	nop
  800681:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800684:	c9                   	leave  
  800685:	c3                   	ret    

00800686 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800686:	55                   	push   %ebp
  800687:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800689:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80068d:	7e 1c                	jle    8006ab <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	8d 50 08             	lea    0x8(%eax),%edx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	89 10                	mov    %edx,(%eax)
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	83 e8 08             	sub    $0x8,%eax
  8006a4:	8b 50 04             	mov    0x4(%eax),%edx
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	eb 40                	jmp    8006eb <getuint+0x65>
	else if (lflag)
  8006ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006af:	74 1e                	je     8006cf <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	8d 50 04             	lea    0x4(%eax),%edx
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	89 10                	mov    %edx,(%eax)
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	83 e8 04             	sub    $0x4,%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cd:	eb 1c                	jmp    8006eb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	8d 50 04             	lea    0x4(%eax),%edx
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	89 10                	mov    %edx,(%eax)
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	83 e8 04             	sub    $0x4,%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006eb:	5d                   	pop    %ebp
  8006ec:	c3                   	ret    

008006ed <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ed:	55                   	push   %ebp
  8006ee:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f4:	7e 1c                	jle    800712 <getint+0x25>
		return va_arg(*ap, long long);
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	8d 50 08             	lea    0x8(%eax),%edx
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	89 10                	mov    %edx,(%eax)
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	83 e8 08             	sub    $0x8,%eax
  80070b:	8b 50 04             	mov    0x4(%eax),%edx
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	eb 38                	jmp    80074a <getint+0x5d>
	else if (lflag)
  800712:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800716:	74 1a                	je     800732 <getint+0x45>
		return va_arg(*ap, long);
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	8d 50 04             	lea    0x4(%eax),%edx
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	89 10                	mov    %edx,(%eax)
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	83 e8 04             	sub    $0x4,%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	99                   	cltd   
  800730:	eb 18                	jmp    80074a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	8d 50 04             	lea    0x4(%eax),%edx
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	89 10                	mov    %edx,(%eax)
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	83 e8 04             	sub    $0x4,%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	99                   	cltd   
}
  80074a:	5d                   	pop    %ebp
  80074b:	c3                   	ret    

0080074c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80074c:	55                   	push   %ebp
  80074d:	89 e5                	mov    %esp,%ebp
  80074f:	56                   	push   %esi
  800750:	53                   	push   %ebx
  800751:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800754:	eb 17                	jmp    80076d <vprintfmt+0x21>
			if (ch == '\0')
  800756:	85 db                	test   %ebx,%ebx
  800758:	0f 84 af 03 00 00    	je     800b0d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	53                   	push   %ebx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	ff d0                	call   *%eax
  80076a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076d:	8b 45 10             	mov    0x10(%ebp),%eax
  800770:	8d 50 01             	lea    0x1(%eax),%edx
  800773:	89 55 10             	mov    %edx,0x10(%ebp)
  800776:	8a 00                	mov    (%eax),%al
  800778:	0f b6 d8             	movzbl %al,%ebx
  80077b:	83 fb 25             	cmp    $0x25,%ebx
  80077e:	75 d6                	jne    800756 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800780:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800784:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80078b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800792:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800799:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a3:	8d 50 01             	lea    0x1(%eax),%edx
  8007a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a9:	8a 00                	mov    (%eax),%al
  8007ab:	0f b6 d8             	movzbl %al,%ebx
  8007ae:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007b1:	83 f8 55             	cmp    $0x55,%eax
  8007b4:	0f 87 2b 03 00 00    	ja     800ae5 <vprintfmt+0x399>
  8007ba:	8b 04 85 18 22 80 00 	mov    0x802218(,%eax,4),%eax
  8007c1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007c3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007c7:	eb d7                	jmp    8007a0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007cd:	eb d1                	jmp    8007a0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d9:	89 d0                	mov    %edx,%eax
  8007db:	c1 e0 02             	shl    $0x2,%eax
  8007de:	01 d0                	add    %edx,%eax
  8007e0:	01 c0                	add    %eax,%eax
  8007e2:	01 d8                	add    %ebx,%eax
  8007e4:	83 e8 30             	sub    $0x30,%eax
  8007e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ed:	8a 00                	mov    (%eax),%al
  8007ef:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007f2:	83 fb 2f             	cmp    $0x2f,%ebx
  8007f5:	7e 3e                	jle    800835 <vprintfmt+0xe9>
  8007f7:	83 fb 39             	cmp    $0x39,%ebx
  8007fa:	7f 39                	jg     800835 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ff:	eb d5                	jmp    8007d6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	83 c0 04             	add    $0x4,%eax
  800807:	89 45 14             	mov    %eax,0x14(%ebp)
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	83 e8 04             	sub    $0x4,%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800815:	eb 1f                	jmp    800836 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800817:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081b:	79 83                	jns    8007a0 <vprintfmt+0x54>
				width = 0;
  80081d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800824:	e9 77 ff ff ff       	jmp    8007a0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800829:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800830:	e9 6b ff ff ff       	jmp    8007a0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800835:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800836:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80083a:	0f 89 60 ff ff ff    	jns    8007a0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800840:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800843:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800846:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80084d:	e9 4e ff ff ff       	jmp    8007a0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800852:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800855:	e9 46 ff ff ff       	jmp    8007a0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 c0 04             	add    $0x4,%eax
  800860:	89 45 14             	mov    %eax,0x14(%ebp)
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	83 e8 04             	sub    $0x4,%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	83 ec 08             	sub    $0x8,%esp
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	50                   	push   %eax
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	ff d0                	call   *%eax
  800877:	83 c4 10             	add    $0x10,%esp
			break;
  80087a:	e9 89 02 00 00       	jmp    800b08 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 c0 04             	add    $0x4,%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
  800888:	8b 45 14             	mov    0x14(%ebp),%eax
  80088b:	83 e8 04             	sub    $0x4,%eax
  80088e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800890:	85 db                	test   %ebx,%ebx
  800892:	79 02                	jns    800896 <vprintfmt+0x14a>
				err = -err;
  800894:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800896:	83 fb 64             	cmp    $0x64,%ebx
  800899:	7f 0b                	jg     8008a6 <vprintfmt+0x15a>
  80089b:	8b 34 9d 60 20 80 00 	mov    0x802060(,%ebx,4),%esi
  8008a2:	85 f6                	test   %esi,%esi
  8008a4:	75 19                	jne    8008bf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008a6:	53                   	push   %ebx
  8008a7:	68 05 22 80 00       	push   $0x802205
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	ff 75 08             	pushl  0x8(%ebp)
  8008b2:	e8 5e 02 00 00       	call   800b15 <printfmt>
  8008b7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ba:	e9 49 02 00 00       	jmp    800b08 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008bf:	56                   	push   %esi
  8008c0:	68 0e 22 80 00       	push   $0x80220e
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	ff 75 08             	pushl  0x8(%ebp)
  8008cb:	e8 45 02 00 00       	call   800b15 <printfmt>
  8008d0:	83 c4 10             	add    $0x10,%esp
			break;
  8008d3:	e9 30 02 00 00       	jmp    800b08 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	83 c0 04             	add    $0x4,%eax
  8008de:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e4:	83 e8 04             	sub    $0x4,%eax
  8008e7:	8b 30                	mov    (%eax),%esi
  8008e9:	85 f6                	test   %esi,%esi
  8008eb:	75 05                	jne    8008f2 <vprintfmt+0x1a6>
				p = "(null)";
  8008ed:	be 11 22 80 00       	mov    $0x802211,%esi
			if (width > 0 && padc != '-')
  8008f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f6:	7e 6d                	jle    800965 <vprintfmt+0x219>
  8008f8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008fc:	74 67                	je     800965 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	50                   	push   %eax
  800905:	56                   	push   %esi
  800906:	e8 0c 03 00 00       	call   800c17 <strnlen>
  80090b:	83 c4 10             	add    $0x10,%esp
  80090e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800911:	eb 16                	jmp    800929 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800913:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	50                   	push   %eax
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800926:	ff 4d e4             	decl   -0x1c(%ebp)
  800929:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092d:	7f e4                	jg     800913 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092f:	eb 34                	jmp    800965 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800931:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800935:	74 1c                	je     800953 <vprintfmt+0x207>
  800937:	83 fb 1f             	cmp    $0x1f,%ebx
  80093a:	7e 05                	jle    800941 <vprintfmt+0x1f5>
  80093c:	83 fb 7e             	cmp    $0x7e,%ebx
  80093f:	7e 12                	jle    800953 <vprintfmt+0x207>
					putch('?', putdat);
  800941:	83 ec 08             	sub    $0x8,%esp
  800944:	ff 75 0c             	pushl  0xc(%ebp)
  800947:	6a 3f                	push   $0x3f
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	ff d0                	call   *%eax
  80094e:	83 c4 10             	add    $0x10,%esp
  800951:	eb 0f                	jmp    800962 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	ff 75 0c             	pushl  0xc(%ebp)
  800959:	53                   	push   %ebx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	ff d0                	call   *%eax
  80095f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800962:	ff 4d e4             	decl   -0x1c(%ebp)
  800965:	89 f0                	mov    %esi,%eax
  800967:	8d 70 01             	lea    0x1(%eax),%esi
  80096a:	8a 00                	mov    (%eax),%al
  80096c:	0f be d8             	movsbl %al,%ebx
  80096f:	85 db                	test   %ebx,%ebx
  800971:	74 24                	je     800997 <vprintfmt+0x24b>
  800973:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800977:	78 b8                	js     800931 <vprintfmt+0x1e5>
  800979:	ff 4d e0             	decl   -0x20(%ebp)
  80097c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800980:	79 af                	jns    800931 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800982:	eb 13                	jmp    800997 <vprintfmt+0x24b>
				putch(' ', putdat);
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	ff 75 0c             	pushl  0xc(%ebp)
  80098a:	6a 20                	push   $0x20
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	ff d0                	call   *%eax
  800991:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800994:	ff 4d e4             	decl   -0x1c(%ebp)
  800997:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099b:	7f e7                	jg     800984 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80099d:	e9 66 01 00 00       	jmp    800b08 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009a2:	83 ec 08             	sub    $0x8,%esp
  8009a5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ab:	50                   	push   %eax
  8009ac:	e8 3c fd ff ff       	call   8006ed <getint>
  8009b1:	83 c4 10             	add    $0x10,%esp
  8009b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c0:	85 d2                	test   %edx,%edx
  8009c2:	79 23                	jns    8009e7 <vprintfmt+0x29b>
				putch('-', putdat);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	6a 2d                	push   $0x2d
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	ff d0                	call   *%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009da:	f7 d8                	neg    %eax
  8009dc:	83 d2 00             	adc    $0x0,%edx
  8009df:	f7 da                	neg    %edx
  8009e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009e7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ee:	e9 bc 00 00 00       	jmp    800aaf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f3:	83 ec 08             	sub    $0x8,%esp
  8009f6:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f9:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fc:	50                   	push   %eax
  8009fd:	e8 84 fc ff ff       	call   800686 <getuint>
  800a02:	83 c4 10             	add    $0x10,%esp
  800a05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a08:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a0b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a12:	e9 98 00 00 00       	jmp    800aaf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	ff 75 0c             	pushl  0xc(%ebp)
  800a1d:	6a 58                	push   $0x58
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	ff d0                	call   *%eax
  800a24:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	6a 58                	push   $0x58
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	6a 58                	push   $0x58
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	ff d0                	call   *%eax
  800a44:	83 c4 10             	add    $0x10,%esp
			break;
  800a47:	e9 bc 00 00 00       	jmp    800b08 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a4c:	83 ec 08             	sub    $0x8,%esp
  800a4f:	ff 75 0c             	pushl  0xc(%ebp)
  800a52:	6a 30                	push   $0x30
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	ff d0                	call   *%eax
  800a59:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	6a 78                	push   $0x78
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	ff d0                	call   *%eax
  800a69:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	83 c0 04             	add    $0x4,%eax
  800a72:	89 45 14             	mov    %eax,0x14(%ebp)
  800a75:	8b 45 14             	mov    0x14(%ebp),%eax
  800a78:	83 e8 04             	sub    $0x4,%eax
  800a7b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a87:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a8e:	eb 1f                	jmp    800aaf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 e8             	pushl  -0x18(%ebp)
  800a96:	8d 45 14             	lea    0x14(%ebp),%eax
  800a99:	50                   	push   %eax
  800a9a:	e8 e7 fb ff ff       	call   800686 <getuint>
  800a9f:	83 c4 10             	add    $0x10,%esp
  800aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aaf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ab3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab6:	83 ec 04             	sub    $0x4,%esp
  800ab9:	52                   	push   %edx
  800aba:	ff 75 e4             	pushl  -0x1c(%ebp)
  800abd:	50                   	push   %eax
  800abe:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 08             	pushl  0x8(%ebp)
  800aca:	e8 00 fb ff ff       	call   8005cf <printnum>
  800acf:	83 c4 20             	add    $0x20,%esp
			break;
  800ad2:	eb 34                	jmp    800b08 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ad4:	83 ec 08             	sub    $0x8,%esp
  800ad7:	ff 75 0c             	pushl  0xc(%ebp)
  800ada:	53                   	push   %ebx
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			break;
  800ae3:	eb 23                	jmp    800b08 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	6a 25                	push   $0x25
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	ff d0                	call   *%eax
  800af2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af5:	ff 4d 10             	decl   0x10(%ebp)
  800af8:	eb 03                	jmp    800afd <vprintfmt+0x3b1>
  800afa:	ff 4d 10             	decl   0x10(%ebp)
  800afd:	8b 45 10             	mov    0x10(%ebp),%eax
  800b00:	48                   	dec    %eax
  800b01:	8a 00                	mov    (%eax),%al
  800b03:	3c 25                	cmp    $0x25,%al
  800b05:	75 f3                	jne    800afa <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b07:	90                   	nop
		}
	}
  800b08:	e9 47 fc ff ff       	jmp    800754 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b0d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b1b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b1e:	83 c0 04             	add    $0x4,%eax
  800b21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b24:	8b 45 10             	mov    0x10(%ebp),%eax
  800b27:	ff 75 f4             	pushl  -0xc(%ebp)
  800b2a:	50                   	push   %eax
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	ff 75 08             	pushl  0x8(%ebp)
  800b31:	e8 16 fc ff ff       	call   80074c <vprintfmt>
  800b36:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b39:	90                   	nop
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	8b 40 08             	mov    0x8(%eax),%eax
  800b45:	8d 50 01             	lea    0x1(%eax),%edx
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b51:	8b 10                	mov    (%eax),%edx
  800b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b56:	8b 40 04             	mov    0x4(%eax),%eax
  800b59:	39 c2                	cmp    %eax,%edx
  800b5b:	73 12                	jae    800b6f <sprintputch+0x33>
		*b->buf++ = ch;
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	8b 00                	mov    (%eax),%eax
  800b62:	8d 48 01             	lea    0x1(%eax),%ecx
  800b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b68:	89 0a                	mov    %ecx,(%edx)
  800b6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6d:	88 10                	mov    %dl,(%eax)
}
  800b6f:	90                   	nop
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	01 d0                	add    %edx,%eax
  800b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b97:	74 06                	je     800b9f <vsnprintf+0x2d>
  800b99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9d:	7f 07                	jg     800ba6 <vsnprintf+0x34>
		return -E_INVAL;
  800b9f:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba4:	eb 20                	jmp    800bc6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba6:	ff 75 14             	pushl  0x14(%ebp)
  800ba9:	ff 75 10             	pushl  0x10(%ebp)
  800bac:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800baf:	50                   	push   %eax
  800bb0:	68 3c 0b 80 00       	push   $0x800b3c
  800bb5:	e8 92 fb ff ff       	call   80074c <vprintfmt>
  800bba:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    

00800bc8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bce:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd1:	83 c0 04             	add    $0x4,%eax
  800bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bda:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdd:	50                   	push   %eax
  800bde:	ff 75 0c             	pushl  0xc(%ebp)
  800be1:	ff 75 08             	pushl  0x8(%ebp)
  800be4:	e8 89 ff ff ff       	call   800b72 <vsnprintf>
  800be9:	83 c4 10             	add    $0x10,%esp
  800bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf2:	c9                   	leave  
  800bf3:	c3                   	ret    

00800bf4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c01:	eb 06                	jmp    800c09 <strlen+0x15>
		n++;
  800c03:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c06:	ff 45 08             	incl   0x8(%ebp)
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8a 00                	mov    (%eax),%al
  800c0e:	84 c0                	test   %al,%al
  800c10:	75 f1                	jne    800c03 <strlen+0xf>
		n++;
	return n;
  800c12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c15:	c9                   	leave  
  800c16:	c3                   	ret    

00800c17 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c24:	eb 09                	jmp    800c2f <strnlen+0x18>
		n++;
  800c26:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c29:	ff 45 08             	incl   0x8(%ebp)
  800c2c:	ff 4d 0c             	decl   0xc(%ebp)
  800c2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c33:	74 09                	je     800c3e <strnlen+0x27>
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	84 c0                	test   %al,%al
  800c3c:	75 e8                	jne    800c26 <strnlen+0xf>
		n++;
	return n;
  800c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c4f:	90                   	nop
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	8d 50 01             	lea    0x1(%eax),%edx
  800c56:	89 55 08             	mov    %edx,0x8(%ebp)
  800c59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c62:	8a 12                	mov    (%edx),%dl
  800c64:	88 10                	mov    %dl,(%eax)
  800c66:	8a 00                	mov    (%eax),%al
  800c68:	84 c0                	test   %al,%al
  800c6a:	75 e4                	jne    800c50 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6f:	c9                   	leave  
  800c70:	c3                   	ret    

00800c71 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c84:	eb 1f                	jmp    800ca5 <strncpy+0x34>
		*dst++ = *src;
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	8d 50 01             	lea    0x1(%eax),%edx
  800c8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c92:	8a 12                	mov    (%edx),%dl
  800c94:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c99:	8a 00                	mov    (%eax),%al
  800c9b:	84 c0                	test   %al,%al
  800c9d:	74 03                	je     800ca2 <strncpy+0x31>
			src++;
  800c9f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca2:	ff 45 fc             	incl   -0x4(%ebp)
  800ca5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cab:	72 d9                	jb     800c86 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cb0:	c9                   	leave  
  800cb1:	c3                   	ret    

00800cb2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc2:	74 30                	je     800cf4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cc4:	eb 16                	jmp    800cdc <strlcpy+0x2a>
			*dst++ = *src++;
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8d 50 01             	lea    0x1(%eax),%edx
  800ccc:	89 55 08             	mov    %edx,0x8(%ebp)
  800ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd8:	8a 12                	mov    (%edx),%dl
  800cda:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cdc:	ff 4d 10             	decl   0x10(%ebp)
  800cdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce3:	74 09                	je     800cee <strlcpy+0x3c>
  800ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	75 d8                	jne    800cc6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cfa:	29 c2                	sub    %eax,%edx
  800cfc:	89 d0                	mov    %edx,%eax
}
  800cfe:	c9                   	leave  
  800cff:	c3                   	ret    

00800d00 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d03:	eb 06                	jmp    800d0b <strcmp+0xb>
		p++, q++;
  800d05:	ff 45 08             	incl   0x8(%ebp)
  800d08:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	84 c0                	test   %al,%al
  800d12:	74 0e                	je     800d22 <strcmp+0x22>
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 10                	mov    (%eax),%dl
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	8a 00                	mov    (%eax),%al
  800d1e:	38 c2                	cmp    %al,%dl
  800d20:	74 e3                	je     800d05 <strcmp+0x5>
		p++, q++;
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

00800d38 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d3b:	eb 09                	jmp    800d46 <strncmp+0xe>
		n--, p++, q++;
  800d3d:	ff 4d 10             	decl   0x10(%ebp)
  800d40:	ff 45 08             	incl   0x8(%ebp)
  800d43:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4a:	74 17                	je     800d63 <strncmp+0x2b>
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	84 c0                	test   %al,%al
  800d53:	74 0e                	je     800d63 <strncmp+0x2b>
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 10                	mov    (%eax),%dl
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	38 c2                	cmp    %al,%dl
  800d61:	74 da                	je     800d3d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d67:	75 07                	jne    800d70 <strncmp+0x38>
		return 0;
  800d69:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6e:	eb 14                	jmp    800d84 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f b6 d0             	movzbl %al,%edx
  800d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f b6 c0             	movzbl %al,%eax
  800d80:	29 c2                	sub    %eax,%edx
  800d82:	89 d0                	mov    %edx,%eax
}
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 04             	sub    $0x4,%esp
  800d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d92:	eb 12                	jmp    800da6 <strchr+0x20>
		if (*s == c)
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9c:	75 05                	jne    800da3 <strchr+0x1d>
			return (char *) s;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	eb 11                	jmp    800db4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800da3:	ff 45 08             	incl   0x8(%ebp)
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	84 c0                	test   %al,%al
  800dad:	75 e5                	jne    800d94 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db4:	c9                   	leave  
  800db5:	c3                   	ret    

00800db6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	83 ec 04             	sub    $0x4,%esp
  800dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc2:	eb 0d                	jmp    800dd1 <strfind+0x1b>
		if (*s == c)
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dcc:	74 0e                	je     800ddc <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dce:	ff 45 08             	incl   0x8(%ebp)
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	84 c0                	test   %al,%al
  800dd8:	75 ea                	jne    800dc4 <strfind+0xe>
  800dda:	eb 01                	jmp    800ddd <strfind+0x27>
		if (*s == c)
			break;
  800ddc:	90                   	nop
	return (char *) s;
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800df4:	eb 0e                	jmp    800e04 <memset+0x22>
		*p++ = c;
  800df6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df9:	8d 50 01             	lea    0x1(%eax),%edx
  800dfc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e02:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e04:	ff 4d f8             	decl   -0x8(%ebp)
  800e07:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e0b:	79 e9                	jns    800df6 <memset+0x14>
		*p++ = c;

	return v;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e24:	eb 16                	jmp    800e3c <memcpy+0x2a>
		*d++ = *s++;
  800e26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e29:	8d 50 01             	lea    0x1(%eax),%edx
  800e2c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e35:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e38:	8a 12                	mov    (%edx),%dl
  800e3a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e42:	89 55 10             	mov    %edx,0x10(%ebp)
  800e45:	85 c0                	test   %eax,%eax
  800e47:	75 dd                	jne    800e26 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    

00800e4e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e63:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e66:	73 50                	jae    800eb8 <memmove+0x6a>
  800e68:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	01 d0                	add    %edx,%eax
  800e70:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e73:	76 43                	jbe    800eb8 <memmove+0x6a>
		s += n;
  800e75:	8b 45 10             	mov    0x10(%ebp),%eax
  800e78:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e81:	eb 10                	jmp    800e93 <memmove+0x45>
			*--d = *--s;
  800e83:	ff 4d f8             	decl   -0x8(%ebp)
  800e86:	ff 4d fc             	decl   -0x4(%ebp)
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8c:	8a 10                	mov    (%eax),%dl
  800e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e91:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e93:	8b 45 10             	mov    0x10(%ebp),%eax
  800e96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e99:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	75 e3                	jne    800e83 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ea0:	eb 23                	jmp    800ec5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ea2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea5:	8d 50 01             	lea    0x1(%eax),%edx
  800ea8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eae:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb4:	8a 12                	mov    (%edx),%dl
  800eb6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebe:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	75 dd                	jne    800ea2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800edc:	eb 2a                	jmp    800f08 <memcmp+0x3e>
		if (*s1 != *s2)
  800ede:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee1:	8a 10                	mov    (%eax),%dl
  800ee3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee6:	8a 00                	mov    (%eax),%al
  800ee8:	38 c2                	cmp    %al,%dl
  800eea:	74 16                	je     800f02 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	0f b6 d0             	movzbl %al,%edx
  800ef4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	0f b6 c0             	movzbl %al,%eax
  800efc:	29 c2                	sub    %eax,%edx
  800efe:	89 d0                	mov    %edx,%eax
  800f00:	eb 18                	jmp    800f1a <memcmp+0x50>
		s1++, s2++;
  800f02:	ff 45 fc             	incl   -0x4(%ebp)
  800f05:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f08:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f11:	85 c0                	test   %eax,%eax
  800f13:	75 c9                	jne    800ede <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f1a:	c9                   	leave  
  800f1b:	c3                   	ret    

00800f1c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f22:	8b 55 08             	mov    0x8(%ebp),%edx
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f2d:	eb 15                	jmp    800f44 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	0f b6 d0             	movzbl %al,%edx
  800f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3a:	0f b6 c0             	movzbl %al,%eax
  800f3d:	39 c2                	cmp    %eax,%edx
  800f3f:	74 0d                	je     800f4e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f41:	ff 45 08             	incl   0x8(%ebp)
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f4a:	72 e3                	jb     800f2f <memfind+0x13>
  800f4c:	eb 01                	jmp    800f4f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f4e:	90                   	nop
	return (void *) s;
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f52:	c9                   	leave  
  800f53:	c3                   	ret    

00800f54 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f61:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f68:	eb 03                	jmp    800f6d <strtol+0x19>
		s++;
  800f6a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3c 20                	cmp    $0x20,%al
  800f74:	74 f4                	je     800f6a <strtol+0x16>
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	3c 09                	cmp    $0x9,%al
  800f7d:	74 eb                	je     800f6a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 00                	mov    (%eax),%al
  800f84:	3c 2b                	cmp    $0x2b,%al
  800f86:	75 05                	jne    800f8d <strtol+0x39>
		s++;
  800f88:	ff 45 08             	incl   0x8(%ebp)
  800f8b:	eb 13                	jmp    800fa0 <strtol+0x4c>
	else if (*s == '-')
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	3c 2d                	cmp    $0x2d,%al
  800f94:	75 0a                	jne    800fa0 <strtol+0x4c>
		s++, neg = 1;
  800f96:	ff 45 08             	incl   0x8(%ebp)
  800f99:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa4:	74 06                	je     800fac <strtol+0x58>
  800fa6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800faa:	75 20                	jne    800fcc <strtol+0x78>
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3c 30                	cmp    $0x30,%al
  800fb3:	75 17                	jne    800fcc <strtol+0x78>
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	40                   	inc    %eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	3c 78                	cmp    $0x78,%al
  800fbd:	75 0d                	jne    800fcc <strtol+0x78>
		s += 2, base = 16;
  800fbf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fc3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fca:	eb 28                	jmp    800ff4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fcc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd0:	75 15                	jne    800fe7 <strtol+0x93>
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 30                	cmp    $0x30,%al
  800fd9:	75 0c                	jne    800fe7 <strtol+0x93>
		s++, base = 8;
  800fdb:	ff 45 08             	incl   0x8(%ebp)
  800fde:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fe5:	eb 0d                	jmp    800ff4 <strtol+0xa0>
	else if (base == 0)
  800fe7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800feb:	75 07                	jne    800ff4 <strtol+0xa0>
		base = 10;
  800fed:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 2f                	cmp    $0x2f,%al
  800ffb:	7e 19                	jle    801016 <strtol+0xc2>
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 39                	cmp    $0x39,%al
  801004:	7f 10                	jg     801016 <strtol+0xc2>
			dig = *s - '0';
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	0f be c0             	movsbl %al,%eax
  80100e:	83 e8 30             	sub    $0x30,%eax
  801011:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801014:	eb 42                	jmp    801058 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	3c 60                	cmp    $0x60,%al
  80101d:	7e 19                	jle    801038 <strtol+0xe4>
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	3c 7a                	cmp    $0x7a,%al
  801026:	7f 10                	jg     801038 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	0f be c0             	movsbl %al,%eax
  801030:	83 e8 57             	sub    $0x57,%eax
  801033:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801036:	eb 20                	jmp    801058 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	3c 40                	cmp    $0x40,%al
  80103f:	7e 39                	jle    80107a <strtol+0x126>
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	3c 5a                	cmp    $0x5a,%al
  801048:	7f 30                	jg     80107a <strtol+0x126>
			dig = *s - 'A' + 10;
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	0f be c0             	movsbl %al,%eax
  801052:	83 e8 37             	sub    $0x37,%eax
  801055:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80105e:	7d 19                	jge    801079 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801060:	ff 45 08             	incl   0x8(%ebp)
  801063:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801066:	0f af 45 10          	imul   0x10(%ebp),%eax
  80106a:	89 c2                	mov    %eax,%edx
  80106c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106f:	01 d0                	add    %edx,%eax
  801071:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801074:	e9 7b ff ff ff       	jmp    800ff4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801079:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80107a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107e:	74 08                	je     801088 <strtol+0x134>
		*endptr = (char *) s;
  801080:	8b 45 0c             	mov    0xc(%ebp),%eax
  801083:	8b 55 08             	mov    0x8(%ebp),%edx
  801086:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801088:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80108c:	74 07                	je     801095 <strtol+0x141>
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	f7 d8                	neg    %eax
  801093:	eb 03                	jmp    801098 <strtol+0x144>
  801095:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <ltostr>:

void
ltostr(long value, char *str)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b2:	79 13                	jns    8010c7 <ltostr+0x2d>
	{
		neg = 1;
  8010b4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010be:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010c1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010c4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010cf:	99                   	cltd   
  8010d0:	f7 f9                	idiv   %ecx
  8010d2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d8:	8d 50 01             	lea    0x1(%eax),%edx
  8010db:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010de:	89 c2                	mov    %eax,%edx
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	01 d0                	add    %edx,%eax
  8010e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e8:	83 c2 30             	add    $0x30,%edx
  8010eb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010f0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f5:	f7 e9                	imul   %ecx
  8010f7:	c1 fa 02             	sar    $0x2,%edx
  8010fa:	89 c8                	mov    %ecx,%eax
  8010fc:	c1 f8 1f             	sar    $0x1f,%eax
  8010ff:	29 c2                	sub    %eax,%edx
  801101:	89 d0                	mov    %edx,%eax
  801103:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801106:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801109:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80110e:	f7 e9                	imul   %ecx
  801110:	c1 fa 02             	sar    $0x2,%edx
  801113:	89 c8                	mov    %ecx,%eax
  801115:	c1 f8 1f             	sar    $0x1f,%eax
  801118:	29 c2                	sub    %eax,%edx
  80111a:	89 d0                	mov    %edx,%eax
  80111c:	c1 e0 02             	shl    $0x2,%eax
  80111f:	01 d0                	add    %edx,%eax
  801121:	01 c0                	add    %eax,%eax
  801123:	29 c1                	sub    %eax,%ecx
  801125:	89 ca                	mov    %ecx,%edx
  801127:	85 d2                	test   %edx,%edx
  801129:	75 9c                	jne    8010c7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80112b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801132:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801135:	48                   	dec    %eax
  801136:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801139:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113d:	74 3d                	je     80117c <ltostr+0xe2>
		start = 1 ;
  80113f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801146:	eb 34                	jmp    80117c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801148:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801155:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	01 c2                	add    %eax,%edx
  80115d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	01 c8                	add    %ecx,%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801169:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	01 c2                	add    %eax,%edx
  801171:	8a 45 eb             	mov    -0x15(%ebp),%al
  801174:	88 02                	mov    %al,(%edx)
		start++ ;
  801176:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801179:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80117c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801182:	7c c4                	jl     801148 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801184:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	01 d0                	add    %edx,%eax
  80118c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80118f:	90                   	nop
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801198:	ff 75 08             	pushl  0x8(%ebp)
  80119b:	e8 54 fa ff ff       	call   800bf4 <strlen>
  8011a0:	83 c4 04             	add    $0x4,%esp
  8011a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011a6:	ff 75 0c             	pushl  0xc(%ebp)
  8011a9:	e8 46 fa ff ff       	call   800bf4 <strlen>
  8011ae:	83 c4 04             	add    $0x4,%esp
  8011b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011c2:	eb 17                	jmp    8011db <strcconcat+0x49>
		final[s] = str1[s] ;
  8011c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ca:	01 c2                	add    %eax,%edx
  8011cc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	01 c8                	add    %ecx,%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d8:	ff 45 fc             	incl   -0x4(%ebp)
  8011db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011de:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011e1:	7c e1                	jl     8011c4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011e3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011f1:	eb 1f                	jmp    801212 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f6:	8d 50 01             	lea    0x1(%eax),%edx
  8011f9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011fc:	89 c2                	mov    %eax,%edx
  8011fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801201:	01 c2                	add    %eax,%edx
  801203:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801206:	8b 45 0c             	mov    0xc(%ebp),%eax
  801209:	01 c8                	add    %ecx,%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80120f:	ff 45 f8             	incl   -0x8(%ebp)
  801212:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801215:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801218:	7c d9                	jl     8011f3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80121a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121d:	8b 45 10             	mov    0x10(%ebp),%eax
  801220:	01 d0                	add    %edx,%eax
  801222:	c6 00 00             	movb   $0x0,(%eax)
}
  801225:	90                   	nop
  801226:	c9                   	leave  
  801227:	c3                   	ret    

00801228 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80122b:	8b 45 14             	mov    0x14(%ebp),%eax
  80122e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801234:	8b 45 14             	mov    0x14(%ebp),%eax
  801237:	8b 00                	mov    (%eax),%eax
  801239:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801240:	8b 45 10             	mov    0x10(%ebp),%eax
  801243:	01 d0                	add    %edx,%eax
  801245:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124b:	eb 0c                	jmp    801259 <strsplit+0x31>
			*string++ = 0;
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8d 50 01             	lea    0x1(%eax),%edx
  801253:	89 55 08             	mov    %edx,0x8(%ebp)
  801256:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	84 c0                	test   %al,%al
  801260:	74 18                	je     80127a <strsplit+0x52>
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	0f be c0             	movsbl %al,%eax
  80126a:	50                   	push   %eax
  80126b:	ff 75 0c             	pushl  0xc(%ebp)
  80126e:	e8 13 fb ff ff       	call   800d86 <strchr>
  801273:	83 c4 08             	add    $0x8,%esp
  801276:	85 c0                	test   %eax,%eax
  801278:	75 d3                	jne    80124d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	84 c0                	test   %al,%al
  801281:	74 5a                	je     8012dd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801283:	8b 45 14             	mov    0x14(%ebp),%eax
  801286:	8b 00                	mov    (%eax),%eax
  801288:	83 f8 0f             	cmp    $0xf,%eax
  80128b:	75 07                	jne    801294 <strsplit+0x6c>
		{
			return 0;
  80128d:	b8 00 00 00 00       	mov    $0x0,%eax
  801292:	eb 66                	jmp    8012fa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801294:	8b 45 14             	mov    0x14(%ebp),%eax
  801297:	8b 00                	mov    (%eax),%eax
  801299:	8d 48 01             	lea    0x1(%eax),%ecx
  80129c:	8b 55 14             	mov    0x14(%ebp),%edx
  80129f:	89 0a                	mov    %ecx,(%edx)
  8012a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ab:	01 c2                	add    %eax,%edx
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b2:	eb 03                	jmp    8012b7 <strsplit+0x8f>
			string++;
  8012b4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	84 c0                	test   %al,%al
  8012be:	74 8b                	je     80124b <strsplit+0x23>
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	8a 00                	mov    (%eax),%al
  8012c5:	0f be c0             	movsbl %al,%eax
  8012c8:	50                   	push   %eax
  8012c9:	ff 75 0c             	pushl  0xc(%ebp)
  8012cc:	e8 b5 fa ff ff       	call   800d86 <strchr>
  8012d1:	83 c4 08             	add    $0x8,%esp
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	74 dc                	je     8012b4 <strsplit+0x8c>
			string++;
	}
  8012d8:	e9 6e ff ff ff       	jmp    80124b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012dd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012de:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e1:	8b 00                	mov    (%eax),%eax
  8012e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ed:	01 d0                	add    %edx,%eax
  8012ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012f5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012fa:	c9                   	leave  
  8012fb:	c3                   	ret    

008012fc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	57                   	push   %edi
  801300:	56                   	push   %esi
  801301:	53                   	push   %ebx
  801302:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80130e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801311:	8b 7d 18             	mov    0x18(%ebp),%edi
  801314:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801317:	cd 30                	int    $0x30
  801319:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80131c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80131f:	83 c4 10             	add    $0x10,%esp
  801322:	5b                   	pop    %ebx
  801323:	5e                   	pop    %esi
  801324:	5f                   	pop    %edi
  801325:	5d                   	pop    %ebp
  801326:	c3                   	ret    

00801327 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 04             	sub    $0x4,%esp
  80132d:	8b 45 10             	mov    0x10(%ebp),%eax
  801330:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801333:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	52                   	push   %edx
  80133f:	ff 75 0c             	pushl  0xc(%ebp)
  801342:	50                   	push   %eax
  801343:	6a 00                	push   $0x0
  801345:	e8 b2 ff ff ff       	call   8012fc <syscall>
  80134a:	83 c4 18             	add    $0x18,%esp
}
  80134d:	90                   	nop
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <sys_cgetc>:

int
sys_cgetc(void)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 01                	push   $0x1
  80135f:	e8 98 ff ff ff       	call   8012fc <syscall>
  801364:	83 c4 18             	add    $0x18,%esp
}
  801367:	c9                   	leave  
  801368:	c3                   	ret    

00801369 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	50                   	push   %eax
  801378:	6a 05                	push   $0x5
  80137a:	e8 7d ff ff ff       	call   8012fc <syscall>
  80137f:	83 c4 18             	add    $0x18,%esp
}
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 02                	push   $0x2
  801393:	e8 64 ff ff ff       	call   8012fc <syscall>
  801398:	83 c4 18             	add    $0x18,%esp
}
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 03                	push   $0x3
  8013ac:	e8 4b ff ff ff       	call   8012fc <syscall>
  8013b1:	83 c4 18             	add    $0x18,%esp
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 04                	push   $0x4
  8013c5:	e8 32 ff ff ff       	call   8012fc <syscall>
  8013ca:	83 c4 18             	add    $0x18,%esp
}
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <sys_env_exit>:


void sys_env_exit(void)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 06                	push   $0x6
  8013de:	e8 19 ff ff ff       	call   8012fc <syscall>
  8013e3:	83 c4 18             	add    $0x18,%esp
}
  8013e6:	90                   	nop
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8013ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	52                   	push   %edx
  8013f9:	50                   	push   %eax
  8013fa:	6a 07                	push   $0x7
  8013fc:	e8 fb fe ff ff       	call   8012fc <syscall>
  801401:	83 c4 18             	add    $0x18,%esp
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	56                   	push   %esi
  80140a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80140b:	8b 75 18             	mov    0x18(%ebp),%esi
  80140e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801411:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801414:	8b 55 0c             	mov    0xc(%ebp),%edx
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	56                   	push   %esi
  80141b:	53                   	push   %ebx
  80141c:	51                   	push   %ecx
  80141d:	52                   	push   %edx
  80141e:	50                   	push   %eax
  80141f:	6a 08                	push   $0x8
  801421:	e8 d6 fe ff ff       	call   8012fc <syscall>
  801426:	83 c4 18             	add    $0x18,%esp
}
  801429:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80142c:	5b                   	pop    %ebx
  80142d:	5e                   	pop    %esi
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    

00801430 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801433:	8b 55 0c             	mov    0xc(%ebp),%edx
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	52                   	push   %edx
  801440:	50                   	push   %eax
  801441:	6a 09                	push   $0x9
  801443:	e8 b4 fe ff ff       	call   8012fc <syscall>
  801448:	83 c4 18             	add    $0x18,%esp
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	ff 75 0c             	pushl  0xc(%ebp)
  801459:	ff 75 08             	pushl  0x8(%ebp)
  80145c:	6a 0a                	push   $0xa
  80145e:	e8 99 fe ff ff       	call   8012fc <syscall>
  801463:	83 c4 18             	add    $0x18,%esp
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 0b                	push   $0xb
  801477:	e8 80 fe ff ff       	call   8012fc <syscall>
  80147c:	83 c4 18             	add    $0x18,%esp
}
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 0c                	push   $0xc
  801490:	e8 67 fe ff ff       	call   8012fc <syscall>
  801495:	83 c4 18             	add    $0x18,%esp
}
  801498:	c9                   	leave  
  801499:	c3                   	ret    

0080149a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 0d                	push   $0xd
  8014a9:	e8 4e fe ff ff       	call   8012fc <syscall>
  8014ae:	83 c4 18             	add    $0x18,%esp
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	ff 75 08             	pushl  0x8(%ebp)
  8014c2:	6a 11                	push   $0x11
  8014c4:	e8 33 fe ff ff       	call   8012fc <syscall>
  8014c9:	83 c4 18             	add    $0x18,%esp
	return;
  8014cc:	90                   	nop
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	ff 75 0c             	pushl  0xc(%ebp)
  8014db:	ff 75 08             	pushl  0x8(%ebp)
  8014de:	6a 12                	push   $0x12
  8014e0:	e8 17 fe ff ff       	call   8012fc <syscall>
  8014e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8014e8:	90                   	nop
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 0e                	push   $0xe
  8014fa:	e8 fd fd ff ff       	call   8012fc <syscall>
  8014ff:	83 c4 18             	add    $0x18,%esp
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	ff 75 08             	pushl  0x8(%ebp)
  801512:	6a 0f                	push   $0xf
  801514:	e8 e3 fd ff ff       	call   8012fc <syscall>
  801519:	83 c4 18             	add    $0x18,%esp
}
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 10                	push   $0x10
  80152d:	e8 ca fd ff ff       	call   8012fc <syscall>
  801532:	83 c4 18             	add    $0x18,%esp
}
  801535:	90                   	nop
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 14                	push   $0x14
  801547:	e8 b0 fd ff ff       	call   8012fc <syscall>
  80154c:	83 c4 18             	add    $0x18,%esp
}
  80154f:	90                   	nop
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 15                	push   $0x15
  801561:	e8 96 fd ff ff       	call   8012fc <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
}
  801569:	90                   	nop
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_cputc>:


void
sys_cputc(const char c)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 04             	sub    $0x4,%esp
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801578:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	50                   	push   %eax
  801585:	6a 16                	push   $0x16
  801587:	e8 70 fd ff ff       	call   8012fc <syscall>
  80158c:	83 c4 18             	add    $0x18,%esp
}
  80158f:	90                   	nop
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 17                	push   $0x17
  8015a1:	e8 56 fd ff ff       	call   8012fc <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	90                   	nop
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	ff 75 0c             	pushl  0xc(%ebp)
  8015bb:	50                   	push   %eax
  8015bc:	6a 18                	push   $0x18
  8015be:	e8 39 fd ff ff       	call   8012fc <syscall>
  8015c3:	83 c4 18             	add    $0x18,%esp
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	52                   	push   %edx
  8015d8:	50                   	push   %eax
  8015d9:	6a 1b                	push   $0x1b
  8015db:	e8 1c fd ff ff       	call   8012fc <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	52                   	push   %edx
  8015f5:	50                   	push   %eax
  8015f6:	6a 19                	push   $0x19
  8015f8:	e8 ff fc ff ff       	call   8012fc <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	90                   	nop
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801606:	8b 55 0c             	mov    0xc(%ebp),%edx
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	52                   	push   %edx
  801613:	50                   	push   %eax
  801614:	6a 1a                	push   $0x1a
  801616:	e8 e1 fc ff ff       	call   8012fc <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
}
  80161e:	90                   	nop
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 04             	sub    $0x4,%esp
  801627:	8b 45 10             	mov    0x10(%ebp),%eax
  80162a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80162d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801630:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	6a 00                	push   $0x0
  801639:	51                   	push   %ecx
  80163a:	52                   	push   %edx
  80163b:	ff 75 0c             	pushl  0xc(%ebp)
  80163e:	50                   	push   %eax
  80163f:	6a 1c                	push   $0x1c
  801641:	e8 b6 fc ff ff       	call   8012fc <syscall>
  801646:	83 c4 18             	add    $0x18,%esp
}
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80164e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	52                   	push   %edx
  80165b:	50                   	push   %eax
  80165c:	6a 1d                	push   $0x1d
  80165e:	e8 99 fc ff ff       	call   8012fc <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80166b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80166e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	51                   	push   %ecx
  801679:	52                   	push   %edx
  80167a:	50                   	push   %eax
  80167b:	6a 1e                	push   $0x1e
  80167d:	e8 7a fc ff ff       	call   8012fc <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80168a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	52                   	push   %edx
  801697:	50                   	push   %eax
  801698:	6a 1f                	push   $0x1f
  80169a:	e8 5d fc ff ff       	call   8012fc <syscall>
  80169f:	83 c4 18             	add    $0x18,%esp
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 20                	push   $0x20
  8016b3:	e8 44 fc ff ff       	call   8012fc <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	ff 75 10             	pushl  0x10(%ebp)
  8016ca:	ff 75 0c             	pushl  0xc(%ebp)
  8016cd:	50                   	push   %eax
  8016ce:	6a 21                	push   $0x21
  8016d0:	e8 27 fc ff ff       	call   8012fc <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sys_run_env>:


void
sys_run_env(int32 envId)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	50                   	push   %eax
  8016e9:	6a 22                	push   $0x22
  8016eb:	e8 0c fc ff ff       	call   8012fc <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
}
  8016f3:	90                   	nop
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	50                   	push   %eax
  801705:	6a 23                	push   $0x23
  801707:	e8 f0 fb ff ff       	call   8012fc <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
}
  80170f:	90                   	nop
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801718:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80171b:	8d 50 04             	lea    0x4(%eax),%edx
  80171e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	52                   	push   %edx
  801728:	50                   	push   %eax
  801729:	6a 24                	push   $0x24
  80172b:	e8 cc fb ff ff       	call   8012fc <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
	return result;
  801733:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801736:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801739:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80173c:	89 01                	mov    %eax,(%ecx)
  80173e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	c9                   	leave  
  801745:	c2 04 00             	ret    $0x4

00801748 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	ff 75 10             	pushl  0x10(%ebp)
  801752:	ff 75 0c             	pushl  0xc(%ebp)
  801755:	ff 75 08             	pushl  0x8(%ebp)
  801758:	6a 13                	push   $0x13
  80175a:	e8 9d fb ff ff       	call   8012fc <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
	return ;
  801762:	90                   	nop
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <sys_rcr2>:
uint32 sys_rcr2()
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 25                	push   $0x25
  801774:	e8 83 fb ff ff       	call   8012fc <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	83 ec 04             	sub    $0x4,%esp
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80178a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	50                   	push   %eax
  801797:	6a 26                	push   $0x26
  801799:	e8 5e fb ff ff       	call   8012fc <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a1:	90                   	nop
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <rsttst>:
void rsttst()
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 28                	push   $0x28
  8017b3:	e8 44 fb ff ff       	call   8012fc <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017bb:	90                   	nop
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 04             	sub    $0x4,%esp
  8017c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017ca:	8b 55 18             	mov    0x18(%ebp),%edx
  8017cd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017d1:	52                   	push   %edx
  8017d2:	50                   	push   %eax
  8017d3:	ff 75 10             	pushl  0x10(%ebp)
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	ff 75 08             	pushl  0x8(%ebp)
  8017dc:	6a 27                	push   $0x27
  8017de:	e8 19 fb ff ff       	call   8012fc <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e6:	90                   	nop
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <chktst>:
void chktst(uint32 n)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	6a 29                	push   $0x29
  8017f9:	e8 fe fa ff ff       	call   8012fc <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
	return ;
  801801:	90                   	nop
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <inctst>:

void inctst()
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 2a                	push   $0x2a
  801813:	e8 e4 fa ff ff       	call   8012fc <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
	return ;
  80181b:	90                   	nop
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <gettst>:
uint32 gettst()
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 2b                	push   $0x2b
  80182d:	e8 ca fa ff ff       	call   8012fc <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 2c                	push   $0x2c
  801849:	e8 ae fa ff ff       	call   8012fc <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
  801851:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801854:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801858:	75 07                	jne    801861 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80185a:	b8 01 00 00 00       	mov    $0x1,%eax
  80185f:	eb 05                	jmp    801866 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801861:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 2c                	push   $0x2c
  80187a:	e8 7d fa ff ff       	call   8012fc <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
  801882:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801885:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801889:	75 07                	jne    801892 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80188b:	b8 01 00 00 00       	mov    $0x1,%eax
  801890:	eb 05                	jmp    801897 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801892:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 2c                	push   $0x2c
  8018ab:	e8 4c fa ff ff       	call   8012fc <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
  8018b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8018b6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8018ba:	75 07                	jne    8018c3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8018bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8018c1:	eb 05                	jmp    8018c8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8018c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 2c                	push   $0x2c
  8018dc:	e8 1b fa ff ff       	call   8012fc <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
  8018e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8018e7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8018eb:	75 07                	jne    8018f4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8018ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f2:	eb 05                	jmp    8018f9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8018f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	ff 75 08             	pushl  0x8(%ebp)
  801909:	6a 2d                	push   $0x2d
  80190b:	e8 ec f9 ff ff       	call   8012fc <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
	return ;
  801913:	90                   	nop
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80191a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80191d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801920:	8b 55 0c             	mov    0xc(%ebp),%edx
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	6a 00                	push   $0x0
  801928:	53                   	push   %ebx
  801929:	51                   	push   %ecx
  80192a:	52                   	push   %edx
  80192b:	50                   	push   %eax
  80192c:	6a 2e                	push   $0x2e
  80192e:	e8 c9 f9 ff ff       	call   8012fc <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
}
  801936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80193e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	52                   	push   %edx
  80194b:	50                   	push   %eax
  80194c:	6a 2f                	push   $0x2f
  80194e:	e8 a9 f9 ff ff       	call   8012fc <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80195e:	8b 55 08             	mov    0x8(%ebp),%edx
  801961:	89 d0                	mov    %edx,%eax
  801963:	c1 e0 02             	shl    $0x2,%eax
  801966:	01 d0                	add    %edx,%eax
  801968:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80196f:	01 d0                	add    %edx,%eax
  801971:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801978:	01 d0                	add    %edx,%eax
  80197a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801981:	01 d0                	add    %edx,%eax
  801983:	c1 e0 04             	shl    $0x4,%eax
  801986:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801989:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801990:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801993:	83 ec 0c             	sub    $0xc,%esp
  801996:	50                   	push   %eax
  801997:	e8 76 fd ff ff       	call   801712 <sys_get_virtual_time>
  80199c:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80199f:	eb 41                	jmp    8019e2 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8019a1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019a4:	83 ec 0c             	sub    $0xc,%esp
  8019a7:	50                   	push   %eax
  8019a8:	e8 65 fd ff ff       	call   801712 <sys_get_virtual_time>
  8019ad:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019b6:	29 c2                	sub    %eax,%edx
  8019b8:	89 d0                	mov    %edx,%eax
  8019ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c3:	89 d1                	mov    %edx,%ecx
  8019c5:	29 c1                	sub    %eax,%ecx
  8019c7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019cd:	39 c2                	cmp    %eax,%edx
  8019cf:	0f 97 c0             	seta   %al
  8019d2:	0f b6 c0             	movzbl %al,%eax
  8019d5:	29 c1                	sub    %eax,%ecx
  8019d7:	89 c8                	mov    %ecx,%eax
  8019d9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8019dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019df:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8019e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019e8:	72 b7                	jb     8019a1 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8019ea:	90                   	nop
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8019f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8019fa:	eb 03                	jmp    8019ff <busy_wait+0x12>
  8019fc:	ff 45 fc             	incl   -0x4(%ebp)
  8019ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a02:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a05:	72 f5                	jb     8019fc <busy_wait+0xf>
	return i;
  801a07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <__udivdi3>:
  801a0c:	55                   	push   %ebp
  801a0d:	57                   	push   %edi
  801a0e:	56                   	push   %esi
  801a0f:	53                   	push   %ebx
  801a10:	83 ec 1c             	sub    $0x1c,%esp
  801a13:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a17:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a23:	89 ca                	mov    %ecx,%edx
  801a25:	89 f8                	mov    %edi,%eax
  801a27:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a2b:	85 f6                	test   %esi,%esi
  801a2d:	75 2d                	jne    801a5c <__udivdi3+0x50>
  801a2f:	39 cf                	cmp    %ecx,%edi
  801a31:	77 65                	ja     801a98 <__udivdi3+0x8c>
  801a33:	89 fd                	mov    %edi,%ebp
  801a35:	85 ff                	test   %edi,%edi
  801a37:	75 0b                	jne    801a44 <__udivdi3+0x38>
  801a39:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3e:	31 d2                	xor    %edx,%edx
  801a40:	f7 f7                	div    %edi
  801a42:	89 c5                	mov    %eax,%ebp
  801a44:	31 d2                	xor    %edx,%edx
  801a46:	89 c8                	mov    %ecx,%eax
  801a48:	f7 f5                	div    %ebp
  801a4a:	89 c1                	mov    %eax,%ecx
  801a4c:	89 d8                	mov    %ebx,%eax
  801a4e:	f7 f5                	div    %ebp
  801a50:	89 cf                	mov    %ecx,%edi
  801a52:	89 fa                	mov    %edi,%edx
  801a54:	83 c4 1c             	add    $0x1c,%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5f                   	pop    %edi
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    
  801a5c:	39 ce                	cmp    %ecx,%esi
  801a5e:	77 28                	ja     801a88 <__udivdi3+0x7c>
  801a60:	0f bd fe             	bsr    %esi,%edi
  801a63:	83 f7 1f             	xor    $0x1f,%edi
  801a66:	75 40                	jne    801aa8 <__udivdi3+0x9c>
  801a68:	39 ce                	cmp    %ecx,%esi
  801a6a:	72 0a                	jb     801a76 <__udivdi3+0x6a>
  801a6c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a70:	0f 87 9e 00 00 00    	ja     801b14 <__udivdi3+0x108>
  801a76:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7b:	89 fa                	mov    %edi,%edx
  801a7d:	83 c4 1c             	add    $0x1c,%esp
  801a80:	5b                   	pop    %ebx
  801a81:	5e                   	pop    %esi
  801a82:	5f                   	pop    %edi
  801a83:	5d                   	pop    %ebp
  801a84:	c3                   	ret    
  801a85:	8d 76 00             	lea    0x0(%esi),%esi
  801a88:	31 ff                	xor    %edi,%edi
  801a8a:	31 c0                	xor    %eax,%eax
  801a8c:	89 fa                	mov    %edi,%edx
  801a8e:	83 c4 1c             	add    $0x1c,%esp
  801a91:	5b                   	pop    %ebx
  801a92:	5e                   	pop    %esi
  801a93:	5f                   	pop    %edi
  801a94:	5d                   	pop    %ebp
  801a95:	c3                   	ret    
  801a96:	66 90                	xchg   %ax,%ax
  801a98:	89 d8                	mov    %ebx,%eax
  801a9a:	f7 f7                	div    %edi
  801a9c:	31 ff                	xor    %edi,%edi
  801a9e:	89 fa                	mov    %edi,%edx
  801aa0:	83 c4 1c             	add    $0x1c,%esp
  801aa3:	5b                   	pop    %ebx
  801aa4:	5e                   	pop    %esi
  801aa5:	5f                   	pop    %edi
  801aa6:	5d                   	pop    %ebp
  801aa7:	c3                   	ret    
  801aa8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801aad:	89 eb                	mov    %ebp,%ebx
  801aaf:	29 fb                	sub    %edi,%ebx
  801ab1:	89 f9                	mov    %edi,%ecx
  801ab3:	d3 e6                	shl    %cl,%esi
  801ab5:	89 c5                	mov    %eax,%ebp
  801ab7:	88 d9                	mov    %bl,%cl
  801ab9:	d3 ed                	shr    %cl,%ebp
  801abb:	89 e9                	mov    %ebp,%ecx
  801abd:	09 f1                	or     %esi,%ecx
  801abf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ac3:	89 f9                	mov    %edi,%ecx
  801ac5:	d3 e0                	shl    %cl,%eax
  801ac7:	89 c5                	mov    %eax,%ebp
  801ac9:	89 d6                	mov    %edx,%esi
  801acb:	88 d9                	mov    %bl,%cl
  801acd:	d3 ee                	shr    %cl,%esi
  801acf:	89 f9                	mov    %edi,%ecx
  801ad1:	d3 e2                	shl    %cl,%edx
  801ad3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ad7:	88 d9                	mov    %bl,%cl
  801ad9:	d3 e8                	shr    %cl,%eax
  801adb:	09 c2                	or     %eax,%edx
  801add:	89 d0                	mov    %edx,%eax
  801adf:	89 f2                	mov    %esi,%edx
  801ae1:	f7 74 24 0c          	divl   0xc(%esp)
  801ae5:	89 d6                	mov    %edx,%esi
  801ae7:	89 c3                	mov    %eax,%ebx
  801ae9:	f7 e5                	mul    %ebp
  801aeb:	39 d6                	cmp    %edx,%esi
  801aed:	72 19                	jb     801b08 <__udivdi3+0xfc>
  801aef:	74 0b                	je     801afc <__udivdi3+0xf0>
  801af1:	89 d8                	mov    %ebx,%eax
  801af3:	31 ff                	xor    %edi,%edi
  801af5:	e9 58 ff ff ff       	jmp    801a52 <__udivdi3+0x46>
  801afa:	66 90                	xchg   %ax,%ax
  801afc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b00:	89 f9                	mov    %edi,%ecx
  801b02:	d3 e2                	shl    %cl,%edx
  801b04:	39 c2                	cmp    %eax,%edx
  801b06:	73 e9                	jae    801af1 <__udivdi3+0xe5>
  801b08:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b0b:	31 ff                	xor    %edi,%edi
  801b0d:	e9 40 ff ff ff       	jmp    801a52 <__udivdi3+0x46>
  801b12:	66 90                	xchg   %ax,%ax
  801b14:	31 c0                	xor    %eax,%eax
  801b16:	e9 37 ff ff ff       	jmp    801a52 <__udivdi3+0x46>
  801b1b:	90                   	nop

00801b1c <__umoddi3>:
  801b1c:	55                   	push   %ebp
  801b1d:	57                   	push   %edi
  801b1e:	56                   	push   %esi
  801b1f:	53                   	push   %ebx
  801b20:	83 ec 1c             	sub    $0x1c,%esp
  801b23:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b27:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b2f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b3b:	89 f3                	mov    %esi,%ebx
  801b3d:	89 fa                	mov    %edi,%edx
  801b3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b43:	89 34 24             	mov    %esi,(%esp)
  801b46:	85 c0                	test   %eax,%eax
  801b48:	75 1a                	jne    801b64 <__umoddi3+0x48>
  801b4a:	39 f7                	cmp    %esi,%edi
  801b4c:	0f 86 a2 00 00 00    	jbe    801bf4 <__umoddi3+0xd8>
  801b52:	89 c8                	mov    %ecx,%eax
  801b54:	89 f2                	mov    %esi,%edx
  801b56:	f7 f7                	div    %edi
  801b58:	89 d0                	mov    %edx,%eax
  801b5a:	31 d2                	xor    %edx,%edx
  801b5c:	83 c4 1c             	add    $0x1c,%esp
  801b5f:	5b                   	pop    %ebx
  801b60:	5e                   	pop    %esi
  801b61:	5f                   	pop    %edi
  801b62:	5d                   	pop    %ebp
  801b63:	c3                   	ret    
  801b64:	39 f0                	cmp    %esi,%eax
  801b66:	0f 87 ac 00 00 00    	ja     801c18 <__umoddi3+0xfc>
  801b6c:	0f bd e8             	bsr    %eax,%ebp
  801b6f:	83 f5 1f             	xor    $0x1f,%ebp
  801b72:	0f 84 ac 00 00 00    	je     801c24 <__umoddi3+0x108>
  801b78:	bf 20 00 00 00       	mov    $0x20,%edi
  801b7d:	29 ef                	sub    %ebp,%edi
  801b7f:	89 fe                	mov    %edi,%esi
  801b81:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b85:	89 e9                	mov    %ebp,%ecx
  801b87:	d3 e0                	shl    %cl,%eax
  801b89:	89 d7                	mov    %edx,%edi
  801b8b:	89 f1                	mov    %esi,%ecx
  801b8d:	d3 ef                	shr    %cl,%edi
  801b8f:	09 c7                	or     %eax,%edi
  801b91:	89 e9                	mov    %ebp,%ecx
  801b93:	d3 e2                	shl    %cl,%edx
  801b95:	89 14 24             	mov    %edx,(%esp)
  801b98:	89 d8                	mov    %ebx,%eax
  801b9a:	d3 e0                	shl    %cl,%eax
  801b9c:	89 c2                	mov    %eax,%edx
  801b9e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ba2:	d3 e0                	shl    %cl,%eax
  801ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bac:	89 f1                	mov    %esi,%ecx
  801bae:	d3 e8                	shr    %cl,%eax
  801bb0:	09 d0                	or     %edx,%eax
  801bb2:	d3 eb                	shr    %cl,%ebx
  801bb4:	89 da                	mov    %ebx,%edx
  801bb6:	f7 f7                	div    %edi
  801bb8:	89 d3                	mov    %edx,%ebx
  801bba:	f7 24 24             	mull   (%esp)
  801bbd:	89 c6                	mov    %eax,%esi
  801bbf:	89 d1                	mov    %edx,%ecx
  801bc1:	39 d3                	cmp    %edx,%ebx
  801bc3:	0f 82 87 00 00 00    	jb     801c50 <__umoddi3+0x134>
  801bc9:	0f 84 91 00 00 00    	je     801c60 <__umoddi3+0x144>
  801bcf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bd3:	29 f2                	sub    %esi,%edx
  801bd5:	19 cb                	sbb    %ecx,%ebx
  801bd7:	89 d8                	mov    %ebx,%eax
  801bd9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bdd:	d3 e0                	shl    %cl,%eax
  801bdf:	89 e9                	mov    %ebp,%ecx
  801be1:	d3 ea                	shr    %cl,%edx
  801be3:	09 d0                	or     %edx,%eax
  801be5:	89 e9                	mov    %ebp,%ecx
  801be7:	d3 eb                	shr    %cl,%ebx
  801be9:	89 da                	mov    %ebx,%edx
  801beb:	83 c4 1c             	add    $0x1c,%esp
  801bee:	5b                   	pop    %ebx
  801bef:	5e                   	pop    %esi
  801bf0:	5f                   	pop    %edi
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    
  801bf3:	90                   	nop
  801bf4:	89 fd                	mov    %edi,%ebp
  801bf6:	85 ff                	test   %edi,%edi
  801bf8:	75 0b                	jne    801c05 <__umoddi3+0xe9>
  801bfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801bff:	31 d2                	xor    %edx,%edx
  801c01:	f7 f7                	div    %edi
  801c03:	89 c5                	mov    %eax,%ebp
  801c05:	89 f0                	mov    %esi,%eax
  801c07:	31 d2                	xor    %edx,%edx
  801c09:	f7 f5                	div    %ebp
  801c0b:	89 c8                	mov    %ecx,%eax
  801c0d:	f7 f5                	div    %ebp
  801c0f:	89 d0                	mov    %edx,%eax
  801c11:	e9 44 ff ff ff       	jmp    801b5a <__umoddi3+0x3e>
  801c16:	66 90                	xchg   %ax,%ax
  801c18:	89 c8                	mov    %ecx,%eax
  801c1a:	89 f2                	mov    %esi,%edx
  801c1c:	83 c4 1c             	add    $0x1c,%esp
  801c1f:	5b                   	pop    %ebx
  801c20:	5e                   	pop    %esi
  801c21:	5f                   	pop    %edi
  801c22:	5d                   	pop    %ebp
  801c23:	c3                   	ret    
  801c24:	3b 04 24             	cmp    (%esp),%eax
  801c27:	72 06                	jb     801c2f <__umoddi3+0x113>
  801c29:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c2d:	77 0f                	ja     801c3e <__umoddi3+0x122>
  801c2f:	89 f2                	mov    %esi,%edx
  801c31:	29 f9                	sub    %edi,%ecx
  801c33:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c37:	89 14 24             	mov    %edx,(%esp)
  801c3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c3e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c42:	8b 14 24             	mov    (%esp),%edx
  801c45:	83 c4 1c             	add    $0x1c,%esp
  801c48:	5b                   	pop    %ebx
  801c49:	5e                   	pop    %esi
  801c4a:	5f                   	pop    %edi
  801c4b:	5d                   	pop    %ebp
  801c4c:	c3                   	ret    
  801c4d:	8d 76 00             	lea    0x0(%esi),%esi
  801c50:	2b 04 24             	sub    (%esp),%eax
  801c53:	19 fa                	sbb    %edi,%edx
  801c55:	89 d1                	mov    %edx,%ecx
  801c57:	89 c6                	mov    %eax,%esi
  801c59:	e9 71 ff ff ff       	jmp    801bcf <__umoddi3+0xb3>
  801c5e:	66 90                	xchg   %ax,%ax
  801c60:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c64:	72 ea                	jb     801c50 <__umoddi3+0x134>
  801c66:	89 d9                	mov    %ebx,%ecx
  801c68:	e9 62 ff ff ff       	jmp    801bcf <__umoddi3+0xb3>
