
obj/user/tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 ff 00 00 00       	call   800135 <libmain>
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
  800086:	68 e0 1c 80 00       	push   $0x801ce0
  80008b:	6a 12                	push   $0x12
  80008d:	68 fc 1c 80 00       	push   $0x801cfc
  800092:	e8 e3 01 00 00       	call   80027a <_panic>
	}
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  800097:	e8 6c 13 00 00       	call   801408 <sys_getparentenvid>
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	68 19 1d 80 00       	push   $0x801d19
  8000a4:	50                   	push   %eax
  8000a5:	e8 36 12 00 00       	call   8012e0 <sget>
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 1c 1d 80 00       	push   $0x801d1c
  8000b8:	e8 5f 04 00 00       	call   80051c <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B1 please be patient ...\n");
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	68 44 1d 80 00       	push   $0x801d44
  8000c8:	e8 4f 04 00 00       	call   80051c <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	68 70 17 00 00       	push   $0x1770
  8000d8:	e8 cd 18 00 00       	call   8019aa <env_sleep>
  8000dd:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 d5 13 00 00       	call   8014ba <sys_calculate_free_frames>
  8000e5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ee:	e8 21 12 00 00       	call   801314 <sfree>
  8000f3:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 64 1d 80 00       	push   $0x801d64
  8000fe:	e8 19 04 00 00       	call   80051c <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800106:	e8 af 13 00 00       	call   8014ba <sys_calculate_free_frames>
  80010b:	89 c2                	mov    %eax,%edx
  80010d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800110:	29 c2                	sub    %eax,%edx
  800112:	89 d0                	mov    %edx,%eax
  800114:	83 f8 04             	cmp    $0x4,%eax
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 7c 1d 80 00       	push   $0x801d7c
  800121:	6a 20                	push   $0x20
  800123:	68 fc 1c 80 00       	push   $0x801cfc
  800128:	e8 4d 01 00 00       	call   80027a <_panic>

	//To indicate that it's completed successfully
	inctst();
  80012d:	e8 24 17 00 00       	call   801856 <inctst>
	return;
  800132:	90                   	nop
}
  800133:	c9                   	leave  
  800134:	c3                   	ret    

00800135 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013b:	e8 af 12 00 00       	call   8013ef <sys_getenvindex>
  800140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800143:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800146:	89 d0                	mov    %edx,%eax
  800148:	c1 e0 03             	shl    $0x3,%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800154:	01 c8                	add    %ecx,%eax
  800156:	01 c0                	add    %eax,%eax
  800158:	01 d0                	add    %edx,%eax
  80015a:	01 c0                	add    %eax,%eax
  80015c:	01 d0                	add    %edx,%eax
  80015e:	89 c2                	mov    %eax,%edx
  800160:	c1 e2 05             	shl    $0x5,%edx
  800163:	29 c2                	sub    %eax,%edx
  800165:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800174:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800179:	a1 20 30 80 00       	mov    0x803020,%eax
  80017e:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800184:	84 c0                	test   %al,%al
  800186:	74 0f                	je     800197 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800188:	a1 20 30 80 00       	mov    0x803020,%eax
  80018d:	05 40 3c 01 00       	add    $0x13c40,%eax
  800192:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800197:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019b:	7e 0a                	jle    8001a7 <libmain+0x72>
		binaryname = argv[0];
  80019d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a0:	8b 00                	mov    (%eax),%eax
  8001a2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	ff 75 0c             	pushl  0xc(%ebp)
  8001ad:	ff 75 08             	pushl  0x8(%ebp)
  8001b0:	e8 83 fe ff ff       	call   800038 <_main>
  8001b5:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b8:	e8 cd 13 00 00       	call   80158a <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 3c 1e 80 00       	push   $0x801e3c
  8001c5:	e8 52 03 00 00       	call   80051c <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d2:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8001d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001dd:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	52                   	push   %edx
  8001e7:	50                   	push   %eax
  8001e8:	68 64 1e 80 00       	push   $0x801e64
  8001ed:	e8 2a 03 00 00       	call   80051c <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8001f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fa:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800200:	a1 20 30 80 00       	mov    0x803020,%eax
  800205:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	52                   	push   %edx
  80020f:	50                   	push   %eax
  800210:	68 8c 1e 80 00       	push   $0x801e8c
  800215:	e8 02 03 00 00       	call   80051c <cprintf>
  80021a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021d:	a1 20 30 80 00       	mov    0x803020,%eax
  800222:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	50                   	push   %eax
  80022c:	68 cd 1e 80 00       	push   $0x801ecd
  800231:	e8 e6 02 00 00       	call   80051c <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800239:	83 ec 0c             	sub    $0xc,%esp
  80023c:	68 3c 1e 80 00       	push   $0x801e3c
  800241:	e8 d6 02 00 00       	call   80051c <cprintf>
  800246:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800249:	e8 56 13 00 00       	call   8015a4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80024e:	e8 19 00 00 00       	call   80026c <exit>
}
  800253:	90                   	nop
  800254:	c9                   	leave  
  800255:	c3                   	ret    

00800256 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800256:	55                   	push   %ebp
  800257:	89 e5                	mov    %esp,%ebp
  800259:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	6a 00                	push   $0x0
  800261:	e8 55 11 00 00       	call   8013bb <sys_env_destroy>
  800266:	83 c4 10             	add    $0x10,%esp
}
  800269:	90                   	nop
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <exit>:

void
exit(void)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800272:	e8 aa 11 00 00       	call   801421 <sys_env_exit>
}
  800277:	90                   	nop
  800278:	c9                   	leave  
  800279:	c3                   	ret    

0080027a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800280:	8d 45 10             	lea    0x10(%ebp),%eax
  800283:	83 c0 04             	add    $0x4,%eax
  800286:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800289:	a1 18 31 80 00       	mov    0x803118,%eax
  80028e:	85 c0                	test   %eax,%eax
  800290:	74 16                	je     8002a8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800292:	a1 18 31 80 00       	mov    0x803118,%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 e4 1e 80 00       	push   $0x801ee4
  8002a0:	e8 77 02 00 00       	call   80051c <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a8:	a1 00 30 80 00       	mov    0x803000,%eax
  8002ad:	ff 75 0c             	pushl  0xc(%ebp)
  8002b0:	ff 75 08             	pushl  0x8(%ebp)
  8002b3:	50                   	push   %eax
  8002b4:	68 e9 1e 80 00       	push   $0x801ee9
  8002b9:	e8 5e 02 00 00       	call   80051c <cprintf>
  8002be:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ca:	50                   	push   %eax
  8002cb:	e8 e1 01 00 00       	call   8004b1 <vcprintf>
  8002d0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d3:	83 ec 08             	sub    $0x8,%esp
  8002d6:	6a 00                	push   $0x0
  8002d8:	68 05 1f 80 00       	push   $0x801f05
  8002dd:	e8 cf 01 00 00       	call   8004b1 <vcprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e5:	e8 82 ff ff ff       	call   80026c <exit>

	// should not return here
	while (1) ;
  8002ea:	eb fe                	jmp    8002ea <_panic+0x70>

008002ec <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f7:	8b 50 74             	mov    0x74(%eax),%edx
  8002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	74 14                	je     800315 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800301:	83 ec 04             	sub    $0x4,%esp
  800304:	68 08 1f 80 00       	push   $0x801f08
  800309:	6a 26                	push   $0x26
  80030b:	68 54 1f 80 00       	push   $0x801f54
  800310:	e8 65 ff ff ff       	call   80027a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800315:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80031c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800323:	e9 b6 00 00 00       	jmp    8003de <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800332:	8b 45 08             	mov    0x8(%ebp),%eax
  800335:	01 d0                	add    %edx,%eax
  800337:	8b 00                	mov    (%eax),%eax
  800339:	85 c0                	test   %eax,%eax
  80033b:	75 08                	jne    800345 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80033d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800340:	e9 96 00 00 00       	jmp    8003db <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800345:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80034c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800353:	eb 5d                	jmp    8003b2 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800355:	a1 20 30 80 00       	mov    0x803020,%eax
  80035a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800360:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800363:	c1 e2 04             	shl    $0x4,%edx
  800366:	01 d0                	add    %edx,%eax
  800368:	8a 40 04             	mov    0x4(%eax),%al
  80036b:	84 c0                	test   %al,%al
  80036d:	75 40                	jne    8003af <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80036f:	a1 20 30 80 00       	mov    0x803020,%eax
  800374:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80037a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037d:	c1 e2 04             	shl    $0x4,%edx
  800380:	01 d0                	add    %edx,%eax
  800382:	8b 00                	mov    (%eax),%eax
  800384:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800387:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80038f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800394:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	01 c8                	add    %ecx,%eax
  8003a0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a2:	39 c2                	cmp    %eax,%edx
  8003a4:	75 09                	jne    8003af <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8003a6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003ad:	eb 12                	jmp    8003c1 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003af:	ff 45 e8             	incl   -0x18(%ebp)
  8003b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b7:	8b 50 74             	mov    0x74(%eax),%edx
  8003ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003bd:	39 c2                	cmp    %eax,%edx
  8003bf:	77 94                	ja     800355 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003c5:	75 14                	jne    8003db <CheckWSWithoutLastIndex+0xef>
			panic(
  8003c7:	83 ec 04             	sub    $0x4,%esp
  8003ca:	68 60 1f 80 00       	push   $0x801f60
  8003cf:	6a 3a                	push   $0x3a
  8003d1:	68 54 1f 80 00       	push   $0x801f54
  8003d6:	e8 9f fe ff ff       	call   80027a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003db:	ff 45 f0             	incl   -0x10(%ebp)
  8003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e4:	0f 8c 3e ff ff ff    	jl     800328 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003f8:	eb 20                	jmp    80041a <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ff:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800405:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800408:	c1 e2 04             	shl    $0x4,%edx
  80040b:	01 d0                	add    %edx,%eax
  80040d:	8a 40 04             	mov    0x4(%eax),%al
  800410:	3c 01                	cmp    $0x1,%al
  800412:	75 03                	jne    800417 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800414:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800417:	ff 45 e0             	incl   -0x20(%ebp)
  80041a:	a1 20 30 80 00       	mov    0x803020,%eax
  80041f:	8b 50 74             	mov    0x74(%eax),%edx
  800422:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800425:	39 c2                	cmp    %eax,%edx
  800427:	77 d1                	ja     8003fa <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80042c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80042f:	74 14                	je     800445 <CheckWSWithoutLastIndex+0x159>
		panic(
  800431:	83 ec 04             	sub    $0x4,%esp
  800434:	68 b4 1f 80 00       	push   $0x801fb4
  800439:	6a 44                	push   $0x44
  80043b:	68 54 1f 80 00       	push   $0x801f54
  800440:	e8 35 fe ff ff       	call   80027a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800445:	90                   	nop
  800446:	c9                   	leave  
  800447:	c3                   	ret    

00800448 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80044e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	8d 48 01             	lea    0x1(%eax),%ecx
  800456:	8b 55 0c             	mov    0xc(%ebp),%edx
  800459:	89 0a                	mov    %ecx,(%edx)
  80045b:	8b 55 08             	mov    0x8(%ebp),%edx
  80045e:	88 d1                	mov    %dl,%cl
  800460:	8b 55 0c             	mov    0xc(%ebp),%edx
  800463:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800471:	75 2c                	jne    80049f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800473:	a0 24 30 80 00       	mov    0x803024,%al
  800478:	0f b6 c0             	movzbl %al,%eax
  80047b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047e:	8b 12                	mov    (%edx),%edx
  800480:	89 d1                	mov    %edx,%ecx
  800482:	8b 55 0c             	mov    0xc(%ebp),%edx
  800485:	83 c2 08             	add    $0x8,%edx
  800488:	83 ec 04             	sub    $0x4,%esp
  80048b:	50                   	push   %eax
  80048c:	51                   	push   %ecx
  80048d:	52                   	push   %edx
  80048e:	e8 e6 0e 00 00       	call   801379 <sys_cputs>
  800493:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800496:	8b 45 0c             	mov    0xc(%ebp),%eax
  800499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	8b 40 04             	mov    0x4(%eax),%eax
  8004a5:	8d 50 01             	lea    0x1(%eax),%edx
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004ae:	90                   	nop
  8004af:	c9                   	leave  
  8004b0:	c3                   	ret    

008004b1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004ba:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c1:	00 00 00 
	b.cnt = 0;
  8004c4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004cb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004da:	50                   	push   %eax
  8004db:	68 48 04 80 00       	push   $0x800448
  8004e0:	e8 11 02 00 00       	call   8006f6 <vprintfmt>
  8004e5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004e8:	a0 24 30 80 00       	mov    0x803024,%al
  8004ed:	0f b6 c0             	movzbl %al,%eax
  8004f0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004f6:	83 ec 04             	sub    $0x4,%esp
  8004f9:	50                   	push   %eax
  8004fa:	52                   	push   %edx
  8004fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800501:	83 c0 08             	add    $0x8,%eax
  800504:	50                   	push   %eax
  800505:	e8 6f 0e 00 00       	call   801379 <sys_cputs>
  80050a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80050d:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800514:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80051a:	c9                   	leave  
  80051b:	c3                   	ret    

0080051c <cprintf>:

int cprintf(const char *fmt, ...) {
  80051c:	55                   	push   %ebp
  80051d:	89 e5                	mov    %esp,%ebp
  80051f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800522:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800529:	8d 45 0c             	lea    0xc(%ebp),%eax
  80052c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	ff 75 f4             	pushl  -0xc(%ebp)
  800538:	50                   	push   %eax
  800539:	e8 73 ff ff ff       	call   8004b1 <vcprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800544:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800547:	c9                   	leave  
  800548:	c3                   	ret    

00800549 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800549:	55                   	push   %ebp
  80054a:	89 e5                	mov    %esp,%ebp
  80054c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80054f:	e8 36 10 00 00       	call   80158a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800554:	8d 45 0c             	lea    0xc(%ebp),%eax
  800557:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80055a:	8b 45 08             	mov    0x8(%ebp),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	ff 75 f4             	pushl  -0xc(%ebp)
  800563:	50                   	push   %eax
  800564:	e8 48 ff ff ff       	call   8004b1 <vcprintf>
  800569:	83 c4 10             	add    $0x10,%esp
  80056c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80056f:	e8 30 10 00 00       	call   8015a4 <sys_enable_interrupt>
	return cnt;
  800574:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800577:	c9                   	leave  
  800578:	c3                   	ret    

00800579 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800579:	55                   	push   %ebp
  80057a:	89 e5                	mov    %esp,%ebp
  80057c:	53                   	push   %ebx
  80057d:	83 ec 14             	sub    $0x14,%esp
  800580:	8b 45 10             	mov    0x10(%ebp),%eax
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80058c:	8b 45 18             	mov    0x18(%ebp),%eax
  80058f:	ba 00 00 00 00       	mov    $0x0,%edx
  800594:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800597:	77 55                	ja     8005ee <printnum+0x75>
  800599:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059c:	72 05                	jb     8005a3 <printnum+0x2a>
  80059e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005a1:	77 4b                	ja     8005ee <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005a3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005a6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005a9:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b1:	52                   	push   %edx
  8005b2:	50                   	push   %eax
  8005b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8005b9:	e8 a2 14 00 00       	call   801a60 <__udivdi3>
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	83 ec 04             	sub    $0x4,%esp
  8005c4:	ff 75 20             	pushl  0x20(%ebp)
  8005c7:	53                   	push   %ebx
  8005c8:	ff 75 18             	pushl  0x18(%ebp)
  8005cb:	52                   	push   %edx
  8005cc:	50                   	push   %eax
  8005cd:	ff 75 0c             	pushl  0xc(%ebp)
  8005d0:	ff 75 08             	pushl  0x8(%ebp)
  8005d3:	e8 a1 ff ff ff       	call   800579 <printnum>
  8005d8:	83 c4 20             	add    $0x20,%esp
  8005db:	eb 1a                	jmp    8005f7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	ff 75 0c             	pushl  0xc(%ebp)
  8005e3:	ff 75 20             	pushl  0x20(%ebp)
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	ff d0                	call   *%eax
  8005eb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ee:	ff 4d 1c             	decl   0x1c(%ebp)
  8005f1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005f5:	7f e6                	jg     8005dd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005f7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800602:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800605:	53                   	push   %ebx
  800606:	51                   	push   %ecx
  800607:	52                   	push   %edx
  800608:	50                   	push   %eax
  800609:	e8 62 15 00 00       	call   801b70 <__umoddi3>
  80060e:	83 c4 10             	add    $0x10,%esp
  800611:	05 14 22 80 00       	add    $0x802214,%eax
  800616:	8a 00                	mov    (%eax),%al
  800618:	0f be c0             	movsbl %al,%eax
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	ff 75 0c             	pushl  0xc(%ebp)
  800621:	50                   	push   %eax
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	ff d0                	call   *%eax
  800627:	83 c4 10             	add    $0x10,%esp
}
  80062a:	90                   	nop
  80062b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80062e:	c9                   	leave  
  80062f:	c3                   	ret    

00800630 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800630:	55                   	push   %ebp
  800631:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800633:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800637:	7e 1c                	jle    800655 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	8d 50 08             	lea    0x8(%eax),%edx
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	89 10                	mov    %edx,(%eax)
  800646:	8b 45 08             	mov    0x8(%ebp),%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	83 e8 08             	sub    $0x8,%eax
  80064e:	8b 50 04             	mov    0x4(%eax),%edx
  800651:	8b 00                	mov    (%eax),%eax
  800653:	eb 40                	jmp    800695 <getuint+0x65>
	else if (lflag)
  800655:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800659:	74 1e                	je     800679 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	8d 50 04             	lea    0x4(%eax),%edx
  800663:	8b 45 08             	mov    0x8(%ebp),%eax
  800666:	89 10                	mov    %edx,(%eax)
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	83 e8 04             	sub    $0x4,%eax
  800670:	8b 00                	mov    (%eax),%eax
  800672:	ba 00 00 00 00       	mov    $0x0,%edx
  800677:	eb 1c                	jmp    800695 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	8d 50 04             	lea    0x4(%eax),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	89 10                	mov    %edx,(%eax)
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	83 e8 04             	sub    $0x4,%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800695:	5d                   	pop    %ebp
  800696:	c3                   	ret    

00800697 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800697:	55                   	push   %ebp
  800698:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80069a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80069e:	7e 1c                	jle    8006bc <getint+0x25>
		return va_arg(*ap, long long);
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	8d 50 08             	lea    0x8(%eax),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	89 10                	mov    %edx,(%eax)
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	83 e8 08             	sub    $0x8,%eax
  8006b5:	8b 50 04             	mov    0x4(%eax),%edx
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	eb 38                	jmp    8006f4 <getint+0x5d>
	else if (lflag)
  8006bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c0:	74 1a                	je     8006dc <getint+0x45>
		return va_arg(*ap, long);
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	89 10                	mov    %edx,(%eax)
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	83 e8 04             	sub    $0x4,%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	99                   	cltd   
  8006da:	eb 18                	jmp    8006f4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	99                   	cltd   
}
  8006f4:	5d                   	pop    %ebp
  8006f5:	c3                   	ret    

008006f6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	56                   	push   %esi
  8006fa:	53                   	push   %ebx
  8006fb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006fe:	eb 17                	jmp    800717 <vprintfmt+0x21>
			if (ch == '\0')
  800700:	85 db                	test   %ebx,%ebx
  800702:	0f 84 af 03 00 00    	je     800ab7 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800708:	83 ec 08             	sub    $0x8,%esp
  80070b:	ff 75 0c             	pushl  0xc(%ebp)
  80070e:	53                   	push   %ebx
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	ff d0                	call   *%eax
  800714:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800717:	8b 45 10             	mov    0x10(%ebp),%eax
  80071a:	8d 50 01             	lea    0x1(%eax),%edx
  80071d:	89 55 10             	mov    %edx,0x10(%ebp)
  800720:	8a 00                	mov    (%eax),%al
  800722:	0f b6 d8             	movzbl %al,%ebx
  800725:	83 fb 25             	cmp    $0x25,%ebx
  800728:	75 d6                	jne    800700 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80072a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80072e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800735:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80073c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800743:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80074a:	8b 45 10             	mov    0x10(%ebp),%eax
  80074d:	8d 50 01             	lea    0x1(%eax),%edx
  800750:	89 55 10             	mov    %edx,0x10(%ebp)
  800753:	8a 00                	mov    (%eax),%al
  800755:	0f b6 d8             	movzbl %al,%ebx
  800758:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80075b:	83 f8 55             	cmp    $0x55,%eax
  80075e:	0f 87 2b 03 00 00    	ja     800a8f <vprintfmt+0x399>
  800764:	8b 04 85 38 22 80 00 	mov    0x802238(,%eax,4),%eax
  80076b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80076d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800771:	eb d7                	jmp    80074a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800773:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800777:	eb d1                	jmp    80074a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800779:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800780:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800783:	89 d0                	mov    %edx,%eax
  800785:	c1 e0 02             	shl    $0x2,%eax
  800788:	01 d0                	add    %edx,%eax
  80078a:	01 c0                	add    %eax,%eax
  80078c:	01 d8                	add    %ebx,%eax
  80078e:	83 e8 30             	sub    $0x30,%eax
  800791:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800794:	8b 45 10             	mov    0x10(%ebp),%eax
  800797:	8a 00                	mov    (%eax),%al
  800799:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80079c:	83 fb 2f             	cmp    $0x2f,%ebx
  80079f:	7e 3e                	jle    8007df <vprintfmt+0xe9>
  8007a1:	83 fb 39             	cmp    $0x39,%ebx
  8007a4:	7f 39                	jg     8007df <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007a9:	eb d5                	jmp    800780 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	83 c0 04             	add    $0x4,%eax
  8007b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	83 e8 04             	sub    $0x4,%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007bf:	eb 1f                	jmp    8007e0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c5:	79 83                	jns    80074a <vprintfmt+0x54>
				width = 0;
  8007c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007ce:	e9 77 ff ff ff       	jmp    80074a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007da:	e9 6b ff ff ff       	jmp    80074a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007df:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e4:	0f 89 60 ff ff ff    	jns    80074a <vprintfmt+0x54>
				width = precision, precision = -1;
  8007ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007f7:	e9 4e ff ff ff       	jmp    80074a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007fc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007ff:	e9 46 ff ff ff       	jmp    80074a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	83 c0 04             	add    $0x4,%eax
  80080a:	89 45 14             	mov    %eax,0x14(%ebp)
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	83 e8 04             	sub    $0x4,%eax
  800813:	8b 00                	mov    (%eax),%eax
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	ff 75 0c             	pushl  0xc(%ebp)
  80081b:	50                   	push   %eax
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	ff d0                	call   *%eax
  800821:	83 c4 10             	add    $0x10,%esp
			break;
  800824:	e9 89 02 00 00       	jmp    800ab2 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	83 c0 04             	add    $0x4,%eax
  80082f:	89 45 14             	mov    %eax,0x14(%ebp)
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	83 e8 04             	sub    $0x4,%eax
  800838:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80083a:	85 db                	test   %ebx,%ebx
  80083c:	79 02                	jns    800840 <vprintfmt+0x14a>
				err = -err;
  80083e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800840:	83 fb 64             	cmp    $0x64,%ebx
  800843:	7f 0b                	jg     800850 <vprintfmt+0x15a>
  800845:	8b 34 9d 80 20 80 00 	mov    0x802080(,%ebx,4),%esi
  80084c:	85 f6                	test   %esi,%esi
  80084e:	75 19                	jne    800869 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800850:	53                   	push   %ebx
  800851:	68 25 22 80 00       	push   $0x802225
  800856:	ff 75 0c             	pushl  0xc(%ebp)
  800859:	ff 75 08             	pushl  0x8(%ebp)
  80085c:	e8 5e 02 00 00       	call   800abf <printfmt>
  800861:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800864:	e9 49 02 00 00       	jmp    800ab2 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800869:	56                   	push   %esi
  80086a:	68 2e 22 80 00       	push   $0x80222e
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	ff 75 08             	pushl  0x8(%ebp)
  800875:	e8 45 02 00 00       	call   800abf <printfmt>
  80087a:	83 c4 10             	add    $0x10,%esp
			break;
  80087d:	e9 30 02 00 00       	jmp    800ab2 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800882:	8b 45 14             	mov    0x14(%ebp),%eax
  800885:	83 c0 04             	add    $0x4,%eax
  800888:	89 45 14             	mov    %eax,0x14(%ebp)
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 30                	mov    (%eax),%esi
  800893:	85 f6                	test   %esi,%esi
  800895:	75 05                	jne    80089c <vprintfmt+0x1a6>
				p = "(null)";
  800897:	be 31 22 80 00       	mov    $0x802231,%esi
			if (width > 0 && padc != '-')
  80089c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a0:	7e 6d                	jle    80090f <vprintfmt+0x219>
  8008a2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008a6:	74 67                	je     80090f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ab:	83 ec 08             	sub    $0x8,%esp
  8008ae:	50                   	push   %eax
  8008af:	56                   	push   %esi
  8008b0:	e8 0c 03 00 00       	call   800bc1 <strnlen>
  8008b5:	83 c4 10             	add    $0x10,%esp
  8008b8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008bb:	eb 16                	jmp    8008d3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008bd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	50                   	push   %eax
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d0:	ff 4d e4             	decl   -0x1c(%ebp)
  8008d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d7:	7f e4                	jg     8008bd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008d9:	eb 34                	jmp    80090f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008df:	74 1c                	je     8008fd <vprintfmt+0x207>
  8008e1:	83 fb 1f             	cmp    $0x1f,%ebx
  8008e4:	7e 05                	jle    8008eb <vprintfmt+0x1f5>
  8008e6:	83 fb 7e             	cmp    $0x7e,%ebx
  8008e9:	7e 12                	jle    8008fd <vprintfmt+0x207>
					putch('?', putdat);
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	ff 75 0c             	pushl  0xc(%ebp)
  8008f1:	6a 3f                	push   $0x3f
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	ff d0                	call   *%eax
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	eb 0f                	jmp    80090c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	53                   	push   %ebx
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	ff d0                	call   *%eax
  800909:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80090c:	ff 4d e4             	decl   -0x1c(%ebp)
  80090f:	89 f0                	mov    %esi,%eax
  800911:	8d 70 01             	lea    0x1(%eax),%esi
  800914:	8a 00                	mov    (%eax),%al
  800916:	0f be d8             	movsbl %al,%ebx
  800919:	85 db                	test   %ebx,%ebx
  80091b:	74 24                	je     800941 <vprintfmt+0x24b>
  80091d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800921:	78 b8                	js     8008db <vprintfmt+0x1e5>
  800923:	ff 4d e0             	decl   -0x20(%ebp)
  800926:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092a:	79 af                	jns    8008db <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80092c:	eb 13                	jmp    800941 <vprintfmt+0x24b>
				putch(' ', putdat);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	ff 75 0c             	pushl  0xc(%ebp)
  800934:	6a 20                	push   $0x20
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	ff d0                	call   *%eax
  80093b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093e:	ff 4d e4             	decl   -0x1c(%ebp)
  800941:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800945:	7f e7                	jg     80092e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800947:	e9 66 01 00 00       	jmp    800ab2 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	ff 75 e8             	pushl  -0x18(%ebp)
  800952:	8d 45 14             	lea    0x14(%ebp),%eax
  800955:	50                   	push   %eax
  800956:	e8 3c fd ff ff       	call   800697 <getint>
  80095b:	83 c4 10             	add    $0x10,%esp
  80095e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800961:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80096a:	85 d2                	test   %edx,%edx
  80096c:	79 23                	jns    800991 <vprintfmt+0x29b>
				putch('-', putdat);
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	6a 2d                	push   $0x2d
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	ff d0                	call   *%eax
  80097b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80097e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800984:	f7 d8                	neg    %eax
  800986:	83 d2 00             	adc    $0x0,%edx
  800989:	f7 da                	neg    %edx
  80098b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800991:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800998:	e9 bc 00 00 00       	jmp    800a59 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80099d:	83 ec 08             	sub    $0x8,%esp
  8009a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a6:	50                   	push   %eax
  8009a7:	e8 84 fc ff ff       	call   800630 <getuint>
  8009ac:	83 c4 10             	add    $0x10,%esp
  8009af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009b5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009bc:	e9 98 00 00 00       	jmp    800a59 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	ff 75 0c             	pushl  0xc(%ebp)
  8009c7:	6a 58                	push   $0x58
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	ff d0                	call   *%eax
  8009ce:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d1:	83 ec 08             	sub    $0x8,%esp
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	6a 58                	push   $0x58
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	ff d0                	call   *%eax
  8009de:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e1:	83 ec 08             	sub    $0x8,%esp
  8009e4:	ff 75 0c             	pushl  0xc(%ebp)
  8009e7:	6a 58                	push   $0x58
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	ff d0                	call   *%eax
  8009ee:	83 c4 10             	add    $0x10,%esp
			break;
  8009f1:	e9 bc 00 00 00       	jmp    800ab2 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	6a 30                	push   $0x30
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	ff d0                	call   *%eax
  800a03:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	6a 78                	push   $0x78
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	ff d0                	call   *%eax
  800a13:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a16:	8b 45 14             	mov    0x14(%ebp),%eax
  800a19:	83 c0 04             	add    $0x4,%eax
  800a1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 e8 04             	sub    $0x4,%eax
  800a25:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a31:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a38:	eb 1f                	jmp    800a59 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a40:	8d 45 14             	lea    0x14(%ebp),%eax
  800a43:	50                   	push   %eax
  800a44:	e8 e7 fb ff ff       	call   800630 <getuint>
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a59:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a60:	83 ec 04             	sub    $0x4,%esp
  800a63:	52                   	push   %edx
  800a64:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a67:	50                   	push   %eax
  800a68:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6b:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6e:	ff 75 0c             	pushl  0xc(%ebp)
  800a71:	ff 75 08             	pushl  0x8(%ebp)
  800a74:	e8 00 fb ff ff       	call   800579 <printnum>
  800a79:	83 c4 20             	add    $0x20,%esp
			break;
  800a7c:	eb 34                	jmp    800ab2 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	53                   	push   %ebx
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	ff d0                	call   *%eax
  800a8a:	83 c4 10             	add    $0x10,%esp
			break;
  800a8d:	eb 23                	jmp    800ab2 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	6a 25                	push   $0x25
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	ff d0                	call   *%eax
  800a9c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a9f:	ff 4d 10             	decl   0x10(%ebp)
  800aa2:	eb 03                	jmp    800aa7 <vprintfmt+0x3b1>
  800aa4:	ff 4d 10             	decl   0x10(%ebp)
  800aa7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aaa:	48                   	dec    %eax
  800aab:	8a 00                	mov    (%eax),%al
  800aad:	3c 25                	cmp    $0x25,%al
  800aaf:	75 f3                	jne    800aa4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ab1:	90                   	nop
		}
	}
  800ab2:	e9 47 fc ff ff       	jmp    8006fe <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ab7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ab8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800abb:	5b                   	pop    %ebx
  800abc:	5e                   	pop    %esi
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    

00800abf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ac5:	8d 45 10             	lea    0x10(%ebp),%eax
  800ac8:	83 c0 04             	add    $0x4,%eax
  800acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ace:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad4:	50                   	push   %eax
  800ad5:	ff 75 0c             	pushl  0xc(%ebp)
  800ad8:	ff 75 08             	pushl  0x8(%ebp)
  800adb:	e8 16 fc ff ff       	call   8006f6 <vprintfmt>
  800ae0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ae3:	90                   	nop
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aec:	8b 40 08             	mov    0x8(%eax),%eax
  800aef:	8d 50 01             	lea    0x1(%eax),%edx
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	8b 10                	mov    (%eax),%edx
  800afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b00:	8b 40 04             	mov    0x4(%eax),%eax
  800b03:	39 c2                	cmp    %eax,%edx
  800b05:	73 12                	jae    800b19 <sprintputch+0x33>
		*b->buf++ = ch;
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	8b 00                	mov    (%eax),%eax
  800b0c:	8d 48 01             	lea    0x1(%eax),%ecx
  800b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b12:	89 0a                	mov    %ecx,(%edx)
  800b14:	8b 55 08             	mov    0x8(%ebp),%edx
  800b17:	88 10                	mov    %dl,(%eax)
}
  800b19:	90                   	nop
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	01 d0                	add    %edx,%eax
  800b33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b41:	74 06                	je     800b49 <vsnprintf+0x2d>
  800b43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b47:	7f 07                	jg     800b50 <vsnprintf+0x34>
		return -E_INVAL;
  800b49:	b8 03 00 00 00       	mov    $0x3,%eax
  800b4e:	eb 20                	jmp    800b70 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b50:	ff 75 14             	pushl  0x14(%ebp)
  800b53:	ff 75 10             	pushl  0x10(%ebp)
  800b56:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b59:	50                   	push   %eax
  800b5a:	68 e6 0a 80 00       	push   $0x800ae6
  800b5f:	e8 92 fb ff ff       	call   8006f6 <vprintfmt>
  800b64:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b6a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b70:	c9                   	leave  
  800b71:	c3                   	ret    

00800b72 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b78:	8d 45 10             	lea    0x10(%ebp),%eax
  800b7b:	83 c0 04             	add    $0x4,%eax
  800b7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b81:	8b 45 10             	mov    0x10(%ebp),%eax
  800b84:	ff 75 f4             	pushl  -0xc(%ebp)
  800b87:	50                   	push   %eax
  800b88:	ff 75 0c             	pushl  0xc(%ebp)
  800b8b:	ff 75 08             	pushl  0x8(%ebp)
  800b8e:	e8 89 ff ff ff       	call   800b1c <vsnprintf>
  800b93:	83 c4 10             	add    $0x10,%esp
  800b96:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b9c:	c9                   	leave  
  800b9d:	c3                   	ret    

00800b9e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bab:	eb 06                	jmp    800bb3 <strlen+0x15>
		n++;
  800bad:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb0:	ff 45 08             	incl   0x8(%ebp)
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8a 00                	mov    (%eax),%al
  800bb8:	84 c0                	test   %al,%al
  800bba:	75 f1                	jne    800bad <strlen+0xf>
		n++;
	return n;
  800bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bbf:	c9                   	leave  
  800bc0:	c3                   	ret    

00800bc1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bce:	eb 09                	jmp    800bd9 <strnlen+0x18>
		n++;
  800bd0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd3:	ff 45 08             	incl   0x8(%ebp)
  800bd6:	ff 4d 0c             	decl   0xc(%ebp)
  800bd9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bdd:	74 09                	je     800be8 <strnlen+0x27>
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	8a 00                	mov    (%eax),%al
  800be4:	84 c0                	test   %al,%al
  800be6:	75 e8                	jne    800bd0 <strnlen+0xf>
		n++;
	return n;
  800be8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bf9:	90                   	nop
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	8d 50 01             	lea    0x1(%eax),%edx
  800c00:	89 55 08             	mov    %edx,0x8(%ebp)
  800c03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c0c:	8a 12                	mov    (%edx),%dl
  800c0e:	88 10                	mov    %dl,(%eax)
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	84 c0                	test   %al,%al
  800c14:	75 e4                	jne    800bfa <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c16:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2e:	eb 1f                	jmp    800c4f <strncpy+0x34>
		*dst++ = *src;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8d 50 01             	lea    0x1(%eax),%edx
  800c36:	89 55 08             	mov    %edx,0x8(%ebp)
  800c39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3c:	8a 12                	mov    (%edx),%dl
  800c3e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c43:	8a 00                	mov    (%eax),%al
  800c45:	84 c0                	test   %al,%al
  800c47:	74 03                	je     800c4c <strncpy+0x31>
			src++;
  800c49:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c4c:	ff 45 fc             	incl   -0x4(%ebp)
  800c4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c52:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c55:	72 d9                	jb     800c30 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c57:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c6c:	74 30                	je     800c9e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c6e:	eb 16                	jmp    800c86 <strlcpy+0x2a>
			*dst++ = *src++;
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	8d 50 01             	lea    0x1(%eax),%edx
  800c76:	89 55 08             	mov    %edx,0x8(%ebp)
  800c79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c7f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c82:	8a 12                	mov    (%edx),%dl
  800c84:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c86:	ff 4d 10             	decl   0x10(%ebp)
  800c89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8d:	74 09                	je     800c98 <strlcpy+0x3c>
  800c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c92:	8a 00                	mov    (%eax),%al
  800c94:	84 c0                	test   %al,%al
  800c96:	75 d8                	jne    800c70 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca4:	29 c2                	sub    %eax,%edx
  800ca6:	89 d0                	mov    %edx,%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cad:	eb 06                	jmp    800cb5 <strcmp+0xb>
		p++, q++;
  800caf:	ff 45 08             	incl   0x8(%ebp)
  800cb2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	84 c0                	test   %al,%al
  800cbc:	74 0e                	je     800ccc <strcmp+0x22>
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8a 10                	mov    (%eax),%dl
  800cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	38 c2                	cmp    %al,%dl
  800cca:	74 e3                	je     800caf <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	0f b6 d0             	movzbl %al,%edx
  800cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	0f b6 c0             	movzbl %al,%eax
  800cdc:	29 c2                	sub    %eax,%edx
  800cde:	89 d0                	mov    %edx,%eax
}
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    

00800ce2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ce5:	eb 09                	jmp    800cf0 <strncmp+0xe>
		n--, p++, q++;
  800ce7:	ff 4d 10             	decl   0x10(%ebp)
  800cea:	ff 45 08             	incl   0x8(%ebp)
  800ced:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf4:	74 17                	je     800d0d <strncmp+0x2b>
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	84 c0                	test   %al,%al
  800cfd:	74 0e                	je     800d0d <strncmp+0x2b>
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 10                	mov    (%eax),%dl
  800d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d07:	8a 00                	mov    (%eax),%al
  800d09:	38 c2                	cmp    %al,%dl
  800d0b:	74 da                	je     800ce7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d11:	75 07                	jne    800d1a <strncmp+0x38>
		return 0;
  800d13:	b8 00 00 00 00       	mov    $0x0,%eax
  800d18:	eb 14                	jmp    800d2e <strncmp+0x4c>
	else
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

00800d30 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 04             	sub    $0x4,%esp
  800d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d39:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d3c:	eb 12                	jmp    800d50 <strchr+0x20>
		if (*s == c)
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d46:	75 05                	jne    800d4d <strchr+0x1d>
			return (char *) s;
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	eb 11                	jmp    800d5e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d4d:	ff 45 08             	incl   0x8(%ebp)
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	84 c0                	test   %al,%al
  800d57:	75 e5                	jne    800d3e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d5e:	c9                   	leave  
  800d5f:	c3                   	ret    

00800d60 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	83 ec 04             	sub    $0x4,%esp
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d6c:	eb 0d                	jmp    800d7b <strfind+0x1b>
		if (*s == c)
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d76:	74 0e                	je     800d86 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d78:	ff 45 08             	incl   0x8(%ebp)
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8a 00                	mov    (%eax),%al
  800d80:	84 c0                	test   %al,%al
  800d82:	75 ea                	jne    800d6e <strfind+0xe>
  800d84:	eb 01                	jmp    800d87 <strfind+0x27>
		if (*s == c)
			break;
  800d86:	90                   	nop
	return (char *) s;
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d8a:	c9                   	leave  
  800d8b:	c3                   	ret    

00800d8c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d98:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d9e:	eb 0e                	jmp    800dae <memset+0x22>
		*p++ = c;
  800da0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da3:	8d 50 01             	lea    0x1(%eax),%edx
  800da6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800da9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dac:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dae:	ff 4d f8             	decl   -0x8(%ebp)
  800db1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800db5:	79 e9                	jns    800da0 <memset+0x14>
		*p++ = c;

	return v;
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dba:	c9                   	leave  
  800dbb:	c3                   	ret    

00800dbc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dce:	eb 16                	jmp    800de6 <memcpy+0x2a>
		*d++ = *s++;
  800dd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd3:	8d 50 01             	lea    0x1(%eax),%edx
  800dd6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dd9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ddc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ddf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800de2:	8a 12                	mov    (%edx),%dl
  800de4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800de6:	8b 45 10             	mov    0x10(%ebp),%eax
  800de9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dec:	89 55 10             	mov    %edx,0x10(%ebp)
  800def:	85 c0                	test   %eax,%eax
  800df1:	75 dd                	jne    800dd0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df6:	c9                   	leave  
  800df7:	c3                   	ret    

00800df8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e10:	73 50                	jae    800e62 <memmove+0x6a>
  800e12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	01 d0                	add    %edx,%eax
  800e1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1d:	76 43                	jbe    800e62 <memmove+0x6a>
		s += n;
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e25:	8b 45 10             	mov    0x10(%ebp),%eax
  800e28:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e2b:	eb 10                	jmp    800e3d <memmove+0x45>
			*--d = *--s;
  800e2d:	ff 4d f8             	decl   -0x8(%ebp)
  800e30:	ff 4d fc             	decl   -0x4(%ebp)
  800e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e36:	8a 10                	mov    (%eax),%dl
  800e38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e43:	89 55 10             	mov    %edx,0x10(%ebp)
  800e46:	85 c0                	test   %eax,%eax
  800e48:	75 e3                	jne    800e2d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e4a:	eb 23                	jmp    800e6f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4f:	8d 50 01             	lea    0x1(%eax),%edx
  800e52:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e58:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e5e:	8a 12                	mov    (%edx),%dl
  800e60:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e62:	8b 45 10             	mov    0x10(%ebp),%eax
  800e65:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e68:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	75 dd                	jne    800e4c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e72:	c9                   	leave  
  800e73:	c3                   	ret    

00800e74 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e86:	eb 2a                	jmp    800eb2 <memcmp+0x3e>
		if (*s1 != *s2)
  800e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8b:	8a 10                	mov    (%eax),%dl
  800e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e90:	8a 00                	mov    (%eax),%al
  800e92:	38 c2                	cmp    %al,%dl
  800e94:	74 16                	je     800eac <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	0f b6 d0             	movzbl %al,%edx
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	0f b6 c0             	movzbl %al,%eax
  800ea6:	29 c2                	sub    %eax,%edx
  800ea8:	89 d0                	mov    %edx,%eax
  800eaa:	eb 18                	jmp    800ec4 <memcmp+0x50>
		s1++, s2++;
  800eac:	ff 45 fc             	incl   -0x4(%ebp)
  800eaf:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebb:	85 c0                	test   %eax,%eax
  800ebd:	75 c9                	jne    800e88 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    

00800ec6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed2:	01 d0                	add    %edx,%eax
  800ed4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ed7:	eb 15                	jmp    800eee <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	0f b6 d0             	movzbl %al,%edx
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	0f b6 c0             	movzbl %al,%eax
  800ee7:	39 c2                	cmp    %eax,%edx
  800ee9:	74 0d                	je     800ef8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eeb:	ff 45 08             	incl   0x8(%ebp)
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ef4:	72 e3                	jb     800ed9 <memfind+0x13>
  800ef6:	eb 01                	jmp    800ef9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ef8:	90                   	nop
	return (void *) s;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f12:	eb 03                	jmp    800f17 <strtol+0x19>
		s++;
  800f14:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	3c 20                	cmp    $0x20,%al
  800f1e:	74 f4                	je     800f14 <strtol+0x16>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 09                	cmp    $0x9,%al
  800f27:	74 eb                	je     800f14 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 2b                	cmp    $0x2b,%al
  800f30:	75 05                	jne    800f37 <strtol+0x39>
		s++;
  800f32:	ff 45 08             	incl   0x8(%ebp)
  800f35:	eb 13                	jmp    800f4a <strtol+0x4c>
	else if (*s == '-')
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	3c 2d                	cmp    $0x2d,%al
  800f3e:	75 0a                	jne    800f4a <strtol+0x4c>
		s++, neg = 1;
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4e:	74 06                	je     800f56 <strtol+0x58>
  800f50:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f54:	75 20                	jne    800f76 <strtol+0x78>
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	3c 30                	cmp    $0x30,%al
  800f5d:	75 17                	jne    800f76 <strtol+0x78>
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	40                   	inc    %eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	3c 78                	cmp    $0x78,%al
  800f67:	75 0d                	jne    800f76 <strtol+0x78>
		s += 2, base = 16;
  800f69:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f6d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f74:	eb 28                	jmp    800f9e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7a:	75 15                	jne    800f91 <strtol+0x93>
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	3c 30                	cmp    $0x30,%al
  800f83:	75 0c                	jne    800f91 <strtol+0x93>
		s++, base = 8;
  800f85:	ff 45 08             	incl   0x8(%ebp)
  800f88:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f8f:	eb 0d                	jmp    800f9e <strtol+0xa0>
	else if (base == 0)
  800f91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f95:	75 07                	jne    800f9e <strtol+0xa0>
		base = 10;
  800f97:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	3c 2f                	cmp    $0x2f,%al
  800fa5:	7e 19                	jle    800fc0 <strtol+0xc2>
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	3c 39                	cmp    $0x39,%al
  800fae:	7f 10                	jg     800fc0 <strtol+0xc2>
			dig = *s - '0';
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	0f be c0             	movsbl %al,%eax
  800fb8:	83 e8 30             	sub    $0x30,%eax
  800fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fbe:	eb 42                	jmp    801002 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 60                	cmp    $0x60,%al
  800fc7:	7e 19                	jle    800fe2 <strtol+0xe4>
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 7a                	cmp    $0x7a,%al
  800fd0:	7f 10                	jg     800fe2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	0f be c0             	movsbl %al,%eax
  800fda:	83 e8 57             	sub    $0x57,%eax
  800fdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe0:	eb 20                	jmp    801002 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	3c 40                	cmp    $0x40,%al
  800fe9:	7e 39                	jle    801024 <strtol+0x126>
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	3c 5a                	cmp    $0x5a,%al
  800ff2:	7f 30                	jg     801024 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	0f be c0             	movsbl %al,%eax
  800ffc:	83 e8 37             	sub    $0x37,%eax
  800fff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801005:	3b 45 10             	cmp    0x10(%ebp),%eax
  801008:	7d 19                	jge    801023 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80100a:	ff 45 08             	incl   0x8(%ebp)
  80100d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801010:	0f af 45 10          	imul   0x10(%ebp),%eax
  801014:	89 c2                	mov    %eax,%edx
  801016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801019:	01 d0                	add    %edx,%eax
  80101b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80101e:	e9 7b ff ff ff       	jmp    800f9e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801023:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801024:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801028:	74 08                	je     801032 <strtol+0x134>
		*endptr = (char *) s;
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	8b 55 08             	mov    0x8(%ebp),%edx
  801030:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801032:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801036:	74 07                	je     80103f <strtol+0x141>
  801038:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103b:	f7 d8                	neg    %eax
  80103d:	eb 03                	jmp    801042 <strtol+0x144>
  80103f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <ltostr>:

void
ltostr(long value, char *str)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80104a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801051:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801058:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80105c:	79 13                	jns    801071 <ltostr+0x2d>
	{
		neg = 1;
  80105e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801065:	8b 45 0c             	mov    0xc(%ebp),%eax
  801068:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80106b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80106e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801079:	99                   	cltd   
  80107a:	f7 f9                	idiv   %ecx
  80107c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80107f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801082:	8d 50 01             	lea    0x1(%eax),%edx
  801085:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801088:	89 c2                	mov    %eax,%edx
  80108a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108d:	01 d0                	add    %edx,%eax
  80108f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801092:	83 c2 30             	add    $0x30,%edx
  801095:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801097:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80109f:	f7 e9                	imul   %ecx
  8010a1:	c1 fa 02             	sar    $0x2,%edx
  8010a4:	89 c8                	mov    %ecx,%eax
  8010a6:	c1 f8 1f             	sar    $0x1f,%eax
  8010a9:	29 c2                	sub    %eax,%edx
  8010ab:	89 d0                	mov    %edx,%eax
  8010ad:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b8:	f7 e9                	imul   %ecx
  8010ba:	c1 fa 02             	sar    $0x2,%edx
  8010bd:	89 c8                	mov    %ecx,%eax
  8010bf:	c1 f8 1f             	sar    $0x1f,%eax
  8010c2:	29 c2                	sub    %eax,%edx
  8010c4:	89 d0                	mov    %edx,%eax
  8010c6:	c1 e0 02             	shl    $0x2,%eax
  8010c9:	01 d0                	add    %edx,%eax
  8010cb:	01 c0                	add    %eax,%eax
  8010cd:	29 c1                	sub    %eax,%ecx
  8010cf:	89 ca                	mov    %ecx,%edx
  8010d1:	85 d2                	test   %edx,%edx
  8010d3:	75 9c                	jne    801071 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010df:	48                   	dec    %eax
  8010e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e7:	74 3d                	je     801126 <ltostr+0xe2>
		start = 1 ;
  8010e9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f0:	eb 34                	jmp    801126 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	01 d0                	add    %edx,%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	01 c2                	add    %eax,%edx
  801107:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	01 c8                	add    %ecx,%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801113:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801116:	8b 45 0c             	mov    0xc(%ebp),%eax
  801119:	01 c2                	add    %eax,%edx
  80111b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80111e:	88 02                	mov    %al,(%edx)
		start++ ;
  801120:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801123:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801129:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112c:	7c c4                	jl     8010f2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80112e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	01 d0                	add    %edx,%eax
  801136:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801139:	90                   	nop
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    

0080113c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801142:	ff 75 08             	pushl  0x8(%ebp)
  801145:	e8 54 fa ff ff       	call   800b9e <strlen>
  80114a:	83 c4 04             	add    $0x4,%esp
  80114d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801150:	ff 75 0c             	pushl  0xc(%ebp)
  801153:	e8 46 fa ff ff       	call   800b9e <strlen>
  801158:	83 c4 04             	add    $0x4,%esp
  80115b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80115e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801165:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80116c:	eb 17                	jmp    801185 <strcconcat+0x49>
		final[s] = str1[s] ;
  80116e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801171:	8b 45 10             	mov    0x10(%ebp),%eax
  801174:	01 c2                	add    %eax,%edx
  801176:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	01 c8                	add    %ecx,%eax
  80117e:	8a 00                	mov    (%eax),%al
  801180:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801182:	ff 45 fc             	incl   -0x4(%ebp)
  801185:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801188:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80118b:	7c e1                	jl     80116e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80118d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801194:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80119b:	eb 1f                	jmp    8011bc <strcconcat+0x80>
		final[s++] = str2[i] ;
  80119d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a0:	8d 50 01             	lea    0x1(%eax),%edx
  8011a3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011a6:	89 c2                	mov    %eax,%edx
  8011a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ab:	01 c2                	add    %eax,%edx
  8011ad:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b3:	01 c8                	add    %ecx,%eax
  8011b5:	8a 00                	mov    (%eax),%al
  8011b7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011b9:	ff 45 f8             	incl   -0x8(%ebp)
  8011bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c2:	7c d9                	jl     80119d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	c6 00 00             	movb   $0x0,(%eax)
}
  8011cf:	90                   	nop
  8011d0:	c9                   	leave  
  8011d1:	c3                   	ret    

008011d2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	8b 00                	mov    (%eax),%eax
  8011e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ed:	01 d0                	add    %edx,%eax
  8011ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f5:	eb 0c                	jmp    801203 <strsplit+0x31>
			*string++ = 0;
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8d 50 01             	lea    0x1(%eax),%edx
  8011fd:	89 55 08             	mov    %edx,0x8(%ebp)
  801200:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	84 c0                	test   %al,%al
  80120a:	74 18                	je     801224 <strsplit+0x52>
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	0f be c0             	movsbl %al,%eax
  801214:	50                   	push   %eax
  801215:	ff 75 0c             	pushl  0xc(%ebp)
  801218:	e8 13 fb ff ff       	call   800d30 <strchr>
  80121d:	83 c4 08             	add    $0x8,%esp
  801220:	85 c0                	test   %eax,%eax
  801222:	75 d3                	jne    8011f7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	84 c0                	test   %al,%al
  80122b:	74 5a                	je     801287 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80122d:	8b 45 14             	mov    0x14(%ebp),%eax
  801230:	8b 00                	mov    (%eax),%eax
  801232:	83 f8 0f             	cmp    $0xf,%eax
  801235:	75 07                	jne    80123e <strsplit+0x6c>
		{
			return 0;
  801237:	b8 00 00 00 00       	mov    $0x0,%eax
  80123c:	eb 66                	jmp    8012a4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80123e:	8b 45 14             	mov    0x14(%ebp),%eax
  801241:	8b 00                	mov    (%eax),%eax
  801243:	8d 48 01             	lea    0x1(%eax),%ecx
  801246:	8b 55 14             	mov    0x14(%ebp),%edx
  801249:	89 0a                	mov    %ecx,(%edx)
  80124b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801252:	8b 45 10             	mov    0x10(%ebp),%eax
  801255:	01 c2                	add    %eax,%edx
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80125c:	eb 03                	jmp    801261 <strsplit+0x8f>
			string++;
  80125e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	84 c0                	test   %al,%al
  801268:	74 8b                	je     8011f5 <strsplit+0x23>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	0f be c0             	movsbl %al,%eax
  801272:	50                   	push   %eax
  801273:	ff 75 0c             	pushl  0xc(%ebp)
  801276:	e8 b5 fa ff ff       	call   800d30 <strchr>
  80127b:	83 c4 08             	add    $0x8,%esp
  80127e:	85 c0                	test   %eax,%eax
  801280:	74 dc                	je     80125e <strsplit+0x8c>
			string++;
	}
  801282:	e9 6e ff ff ff       	jmp    8011f5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801287:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801288:	8b 45 14             	mov    0x14(%ebp),%eax
  80128b:	8b 00                	mov    (%eax),%eax
  80128d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80129f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 90 23 80 00       	push   $0x802390
  8012b4:	6a 19                	push   $0x19
  8012b6:	68 b5 23 80 00       	push   $0x8023b5
  8012bb:	e8 ba ef ff ff       	call   80027a <_panic>

008012c0 <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 18             	sub    $0x18,%esp
  8012c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c9:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8012cc:	83 ec 04             	sub    $0x4,%esp
  8012cf:	68 c4 23 80 00       	push   $0x8023c4
  8012d4:	6a 31                	push   $0x31
  8012d6:	68 b5 23 80 00       	push   $0x8023b5
  8012db:	e8 9a ef ff ff       	call   80027a <_panic>

008012e0 <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8012e6:	83 ec 04             	sub    $0x4,%esp
  8012e9:	68 ec 23 80 00       	push   $0x8023ec
  8012ee:	6a 4a                	push   $0x4a
  8012f0:	68 b5 23 80 00       	push   $0x8023b5
  8012f5:	e8 80 ef ff ff       	call   80027a <_panic>

008012fa <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801300:	83 ec 04             	sub    $0x4,%esp
  801303:	68 10 24 80 00       	push   $0x802410
  801308:	6a 70                	push   $0x70
  80130a:	68 b5 23 80 00       	push   $0x8023b5
  80130f:	e8 66 ef ff ff       	call   80027a <_panic>

00801314 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
  801317:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80131a:	83 ec 04             	sub    $0x4,%esp
  80131d:	68 34 24 80 00       	push   $0x802434
  801322:	68 8b 00 00 00       	push   $0x8b
  801327:	68 b5 23 80 00       	push   $0x8023b5
  80132c:	e8 49 ef ff ff       	call   80027a <_panic>

00801331 <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801337:	83 ec 04             	sub    $0x4,%esp
  80133a:	68 58 24 80 00       	push   $0x802458
  80133f:	68 a8 00 00 00       	push   $0xa8
  801344:	68 b5 23 80 00       	push   $0x8023b5
  801349:	e8 2c ef ff ff       	call   80027a <_panic>

0080134e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	57                   	push   %edi
  801352:	56                   	push   %esi
  801353:	53                   	push   %ebx
  801354:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801360:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801363:	8b 7d 18             	mov    0x18(%ebp),%edi
  801366:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801369:	cd 30                	int    $0x30
  80136b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80136e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	5b                   	pop    %ebx
  801375:	5e                   	pop    %esi
  801376:	5f                   	pop    %edi
  801377:	5d                   	pop    %ebp
  801378:	c3                   	ret    

00801379 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	83 ec 04             	sub    $0x4,%esp
  80137f:	8b 45 10             	mov    0x10(%ebp),%eax
  801382:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801385:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	52                   	push   %edx
  801391:	ff 75 0c             	pushl  0xc(%ebp)
  801394:	50                   	push   %eax
  801395:	6a 00                	push   $0x0
  801397:	e8 b2 ff ff ff       	call   80134e <syscall>
  80139c:	83 c4 18             	add    $0x18,%esp
}
  80139f:	90                   	nop
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 01                	push   $0x1
  8013b1:	e8 98 ff ff ff       	call   80134e <syscall>
  8013b6:	83 c4 18             	add    $0x18,%esp
}
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	50                   	push   %eax
  8013ca:	6a 05                	push   $0x5
  8013cc:	e8 7d ff ff ff       	call   80134e <syscall>
  8013d1:	83 c4 18             	add    $0x18,%esp
}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 02                	push   $0x2
  8013e5:	e8 64 ff ff ff       	call   80134e <syscall>
  8013ea:	83 c4 18             	add    $0x18,%esp
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 03                	push   $0x3
  8013fe:	e8 4b ff ff ff       	call   80134e <syscall>
  801403:	83 c4 18             	add    $0x18,%esp
}
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 04                	push   $0x4
  801417:	e8 32 ff ff ff       	call   80134e <syscall>
  80141c:	83 c4 18             	add    $0x18,%esp
}
  80141f:	c9                   	leave  
  801420:	c3                   	ret    

00801421 <sys_env_exit>:


void sys_env_exit(void)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 06                	push   $0x6
  801430:	e8 19 ff ff ff       	call   80134e <syscall>
  801435:	83 c4 18             	add    $0x18,%esp
}
  801438:	90                   	nop
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80143e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	52                   	push   %edx
  80144b:	50                   	push   %eax
  80144c:	6a 07                	push   $0x7
  80144e:	e8 fb fe ff ff       	call   80134e <syscall>
  801453:	83 c4 18             	add    $0x18,%esp
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	56                   	push   %esi
  80145c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80145d:	8b 75 18             	mov    0x18(%ebp),%esi
  801460:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801463:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801466:	8b 55 0c             	mov    0xc(%ebp),%edx
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	56                   	push   %esi
  80146d:	53                   	push   %ebx
  80146e:	51                   	push   %ecx
  80146f:	52                   	push   %edx
  801470:	50                   	push   %eax
  801471:	6a 08                	push   $0x8
  801473:	e8 d6 fe ff ff       	call   80134e <syscall>
  801478:	83 c4 18             	add    $0x18,%esp
}
  80147b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80147e:	5b                   	pop    %ebx
  80147f:	5e                   	pop    %esi
  801480:	5d                   	pop    %ebp
  801481:	c3                   	ret    

00801482 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801485:	8b 55 0c             	mov    0xc(%ebp),%edx
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	52                   	push   %edx
  801492:	50                   	push   %eax
  801493:	6a 09                	push   $0x9
  801495:	e8 b4 fe ff ff       	call   80134e <syscall>
  80149a:	83 c4 18             	add    $0x18,%esp
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	ff 75 0c             	pushl  0xc(%ebp)
  8014ab:	ff 75 08             	pushl  0x8(%ebp)
  8014ae:	6a 0a                	push   $0xa
  8014b0:	e8 99 fe ff ff       	call   80134e <syscall>
  8014b5:	83 c4 18             	add    $0x18,%esp
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 0b                	push   $0xb
  8014c9:	e8 80 fe ff ff       	call   80134e <syscall>
  8014ce:	83 c4 18             	add    $0x18,%esp
}
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 0c                	push   $0xc
  8014e2:	e8 67 fe ff ff       	call   80134e <syscall>
  8014e7:	83 c4 18             	add    $0x18,%esp
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 0d                	push   $0xd
  8014fb:	e8 4e fe ff ff       	call   80134e <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	ff 75 0c             	pushl  0xc(%ebp)
  801511:	ff 75 08             	pushl  0x8(%ebp)
  801514:	6a 11                	push   $0x11
  801516:	e8 33 fe ff ff       	call   80134e <syscall>
  80151b:	83 c4 18             	add    $0x18,%esp
	return;
  80151e:	90                   	nop
}
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	ff 75 0c             	pushl  0xc(%ebp)
  80152d:	ff 75 08             	pushl  0x8(%ebp)
  801530:	6a 12                	push   $0x12
  801532:	e8 17 fe ff ff       	call   80134e <syscall>
  801537:	83 c4 18             	add    $0x18,%esp
	return ;
  80153a:	90                   	nop
}
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 0e                	push   $0xe
  80154c:	e8 fd fd ff ff       	call   80134e <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	ff 75 08             	pushl  0x8(%ebp)
  801564:	6a 0f                	push   $0xf
  801566:	e8 e3 fd ff ff       	call   80134e <syscall>
  80156b:	83 c4 18             	add    $0x18,%esp
}
  80156e:	c9                   	leave  
  80156f:	c3                   	ret    

00801570 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 10                	push   $0x10
  80157f:	e8 ca fd ff ff       	call   80134e <syscall>
  801584:	83 c4 18             	add    $0x18,%esp
}
  801587:	90                   	nop
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 14                	push   $0x14
  801599:	e8 b0 fd ff ff       	call   80134e <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
}
  8015a1:	90                   	nop
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    

008015a4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 15                	push   $0x15
  8015b3:	e8 96 fd ff ff       	call   80134e <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
}
  8015bb:	90                   	nop
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_cputc>:


void
sys_cputc(const char c)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015ca:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	50                   	push   %eax
  8015d7:	6a 16                	push   $0x16
  8015d9:	e8 70 fd ff ff       	call   80134e <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
}
  8015e1:	90                   	nop
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 17                	push   $0x17
  8015f3:	e8 56 fd ff ff       	call   80134e <syscall>
  8015f8:	83 c4 18             	add    $0x18,%esp
}
  8015fb:	90                   	nop
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	ff 75 0c             	pushl  0xc(%ebp)
  80160d:	50                   	push   %eax
  80160e:	6a 18                	push   $0x18
  801610:	e8 39 fd ff ff       	call   80134e <syscall>
  801615:	83 c4 18             	add    $0x18,%esp
}
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80161d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	52                   	push   %edx
  80162a:	50                   	push   %eax
  80162b:	6a 1b                	push   $0x1b
  80162d:	e8 1c fd ff ff       	call   80134e <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80163a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	52                   	push   %edx
  801647:	50                   	push   %eax
  801648:	6a 19                	push   $0x19
  80164a:	e8 ff fc ff ff       	call   80134e <syscall>
  80164f:	83 c4 18             	add    $0x18,%esp
}
  801652:	90                   	nop
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	52                   	push   %edx
  801665:	50                   	push   %eax
  801666:	6a 1a                	push   $0x1a
  801668:	e8 e1 fc ff ff       	call   80134e <syscall>
  80166d:	83 c4 18             	add    $0x18,%esp
}
  801670:	90                   	nop
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	83 ec 04             	sub    $0x4,%esp
  801679:	8b 45 10             	mov    0x10(%ebp),%eax
  80167c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80167f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801682:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	6a 00                	push   $0x0
  80168b:	51                   	push   %ecx
  80168c:	52                   	push   %edx
  80168d:	ff 75 0c             	pushl  0xc(%ebp)
  801690:	50                   	push   %eax
  801691:	6a 1c                	push   $0x1c
  801693:	e8 b6 fc ff ff       	call   80134e <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	52                   	push   %edx
  8016ad:	50                   	push   %eax
  8016ae:	6a 1d                	push   $0x1d
  8016b0:	e8 99 fc ff ff       	call   80134e <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	51                   	push   %ecx
  8016cb:	52                   	push   %edx
  8016cc:	50                   	push   %eax
  8016cd:	6a 1e                	push   $0x1e
  8016cf:	e8 7a fc ff ff       	call   80134e <syscall>
  8016d4:	83 c4 18             	add    $0x18,%esp
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	52                   	push   %edx
  8016e9:	50                   	push   %eax
  8016ea:	6a 1f                	push   $0x1f
  8016ec:	e8 5d fc ff ff       	call   80134e <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 20                	push   $0x20
  801705:	e8 44 fc ff ff       	call   80134e <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	ff 75 10             	pushl  0x10(%ebp)
  80171c:	ff 75 0c             	pushl  0xc(%ebp)
  80171f:	50                   	push   %eax
  801720:	6a 21                	push   $0x21
  801722:	e8 27 fc ff ff       	call   80134e <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_run_env>:


void
sys_run_env(int32 envId)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	50                   	push   %eax
  80173b:	6a 22                	push   $0x22
  80173d:	e8 0c fc ff ff       	call   80134e <syscall>
  801742:	83 c4 18             	add    $0x18,%esp
}
  801745:	90                   	nop
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	50                   	push   %eax
  801757:	6a 23                	push   $0x23
  801759:	e8 f0 fb ff ff       	call   80134e <syscall>
  80175e:	83 c4 18             	add    $0x18,%esp
}
  801761:	90                   	nop
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80176a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80176d:	8d 50 04             	lea    0x4(%eax),%edx
  801770:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	52                   	push   %edx
  80177a:	50                   	push   %eax
  80177b:	6a 24                	push   $0x24
  80177d:	e8 cc fb ff ff       	call   80134e <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
	return result;
  801785:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801788:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80178b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80178e:	89 01                	mov    %eax,(%ecx)
  801790:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	c9                   	leave  
  801797:	c2 04 00             	ret    $0x4

0080179a <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	ff 75 10             	pushl  0x10(%ebp)
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	ff 75 08             	pushl  0x8(%ebp)
  8017aa:	6a 13                	push   $0x13
  8017ac:	e8 9d fb ff ff       	call   80134e <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b4:	90                   	nop
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 25                	push   $0x25
  8017c6:	e8 83 fb ff ff       	call   80134e <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	83 ec 04             	sub    $0x4,%esp
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017dc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	50                   	push   %eax
  8017e9:	6a 26                	push   $0x26
  8017eb:	e8 5e fb ff ff       	call   80134e <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f3:	90                   	nop
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <rsttst>:
void rsttst()
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 28                	push   $0x28
  801805:	e8 44 fb ff ff       	call   80134e <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
	return ;
  80180d:	90                   	nop
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 04             	sub    $0x4,%esp
  801816:	8b 45 14             	mov    0x14(%ebp),%eax
  801819:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80181c:	8b 55 18             	mov    0x18(%ebp),%edx
  80181f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801823:	52                   	push   %edx
  801824:	50                   	push   %eax
  801825:	ff 75 10             	pushl  0x10(%ebp)
  801828:	ff 75 0c             	pushl  0xc(%ebp)
  80182b:	ff 75 08             	pushl  0x8(%ebp)
  80182e:	6a 27                	push   $0x27
  801830:	e8 19 fb ff ff       	call   80134e <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
	return ;
  801838:	90                   	nop
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <chktst>:
void chktst(uint32 n)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	ff 75 08             	pushl  0x8(%ebp)
  801849:	6a 29                	push   $0x29
  80184b:	e8 fe fa ff ff       	call   80134e <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
	return ;
  801853:	90                   	nop
}
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <inctst>:

void inctst()
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 2a                	push   $0x2a
  801865:	e8 e4 fa ff ff       	call   80134e <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
	return ;
  80186d:	90                   	nop
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <gettst>:
uint32 gettst()
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 2b                	push   $0x2b
  80187f:	e8 ca fa ff ff       	call   80134e <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 2c                	push   $0x2c
  80189b:	e8 ae fa ff ff       	call   80134e <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
  8018a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018a6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018aa:	75 07                	jne    8018b3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8018b1:	eb 05                	jmp    8018b8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 2c                	push   $0x2c
  8018cc:	e8 7d fa ff ff       	call   80134e <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
  8018d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8018d7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8018db:	75 07                	jne    8018e4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8018dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8018e2:	eb 05                	jmp    8018e9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 2c                	push   $0x2c
  8018fd:	e8 4c fa ff ff       	call   80134e <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
  801905:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801908:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80190c:	75 07                	jne    801915 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80190e:	b8 01 00 00 00       	mov    $0x1,%eax
  801913:	eb 05                	jmp    80191a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801915:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 2c                	push   $0x2c
  80192e:	e8 1b fa ff ff       	call   80134e <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
  801936:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801939:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80193d:	75 07                	jne    801946 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80193f:	b8 01 00 00 00       	mov    $0x1,%eax
  801944:	eb 05                	jmp    80194b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801946:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	ff 75 08             	pushl  0x8(%ebp)
  80195b:	6a 2d                	push   $0x2d
  80195d:	e8 ec f9 ff ff       	call   80134e <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
	return ;
  801965:	90                   	nop
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
  80196b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80196c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80196f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801972:	8b 55 0c             	mov    0xc(%ebp),%edx
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	6a 00                	push   $0x0
  80197a:	53                   	push   %ebx
  80197b:	51                   	push   %ecx
  80197c:	52                   	push   %edx
  80197d:	50                   	push   %eax
  80197e:	6a 2e                	push   $0x2e
  801980:	e8 c9 f9 ff ff       	call   80134e <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
}
  801988:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801990:	8b 55 0c             	mov    0xc(%ebp),%edx
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	52                   	push   %edx
  80199d:	50                   	push   %eax
  80199e:	6a 2f                	push   $0x2f
  8019a0:	e8 a9 f9 ff ff       	call   80134e <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8019b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8019b3:	89 d0                	mov    %edx,%eax
  8019b5:	c1 e0 02             	shl    $0x2,%eax
  8019b8:	01 d0                	add    %edx,%eax
  8019ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c1:	01 d0                	add    %edx,%eax
  8019c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ca:	01 d0                	add    %edx,%eax
  8019cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019d3:	01 d0                	add    %edx,%eax
  8019d5:	c1 e0 04             	shl    $0x4,%eax
  8019d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8019db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8019e2:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8019e5:	83 ec 0c             	sub    $0xc,%esp
  8019e8:	50                   	push   %eax
  8019e9:	e8 76 fd ff ff       	call   801764 <sys_get_virtual_time>
  8019ee:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8019f1:	eb 41                	jmp    801a34 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8019f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019f6:	83 ec 0c             	sub    $0xc,%esp
  8019f9:	50                   	push   %eax
  8019fa:	e8 65 fd ff ff       	call   801764 <sys_get_virtual_time>
  8019ff:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801a02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a08:	29 c2                	sub    %eax,%edx
  801a0a:	89 d0                	mov    %edx,%eax
  801a0c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801a0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a15:	89 d1                	mov    %edx,%ecx
  801a17:	29 c1                	sub    %eax,%ecx
  801a19:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a1f:	39 c2                	cmp    %eax,%edx
  801a21:	0f 97 c0             	seta   %al
  801a24:	0f b6 c0             	movzbl %al,%eax
  801a27:	29 c1                	sub    %eax,%ecx
  801a29:	89 c8                	mov    %ecx,%eax
  801a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a37:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a3a:	72 b7                	jb     8019f3 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a3c:	90                   	nop
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a4c:	eb 03                	jmp    801a51 <busy_wait+0x12>
  801a4e:	ff 45 fc             	incl   -0x4(%ebp)
  801a51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a54:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a57:	72 f5                	jb     801a4e <busy_wait+0xf>
	return i;
  801a59:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    
  801a5e:	66 90                	xchg   %ax,%ax

00801a60 <__udivdi3>:
  801a60:	55                   	push   %ebp
  801a61:	57                   	push   %edi
  801a62:	56                   	push   %esi
  801a63:	53                   	push   %ebx
  801a64:	83 ec 1c             	sub    $0x1c,%esp
  801a67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a77:	89 ca                	mov    %ecx,%edx
  801a79:	89 f8                	mov    %edi,%eax
  801a7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a7f:	85 f6                	test   %esi,%esi
  801a81:	75 2d                	jne    801ab0 <__udivdi3+0x50>
  801a83:	39 cf                	cmp    %ecx,%edi
  801a85:	77 65                	ja     801aec <__udivdi3+0x8c>
  801a87:	89 fd                	mov    %edi,%ebp
  801a89:	85 ff                	test   %edi,%edi
  801a8b:	75 0b                	jne    801a98 <__udivdi3+0x38>
  801a8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a92:	31 d2                	xor    %edx,%edx
  801a94:	f7 f7                	div    %edi
  801a96:	89 c5                	mov    %eax,%ebp
  801a98:	31 d2                	xor    %edx,%edx
  801a9a:	89 c8                	mov    %ecx,%eax
  801a9c:	f7 f5                	div    %ebp
  801a9e:	89 c1                	mov    %eax,%ecx
  801aa0:	89 d8                	mov    %ebx,%eax
  801aa2:	f7 f5                	div    %ebp
  801aa4:	89 cf                	mov    %ecx,%edi
  801aa6:	89 fa                	mov    %edi,%edx
  801aa8:	83 c4 1c             	add    $0x1c,%esp
  801aab:	5b                   	pop    %ebx
  801aac:	5e                   	pop    %esi
  801aad:	5f                   	pop    %edi
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    
  801ab0:	39 ce                	cmp    %ecx,%esi
  801ab2:	77 28                	ja     801adc <__udivdi3+0x7c>
  801ab4:	0f bd fe             	bsr    %esi,%edi
  801ab7:	83 f7 1f             	xor    $0x1f,%edi
  801aba:	75 40                	jne    801afc <__udivdi3+0x9c>
  801abc:	39 ce                	cmp    %ecx,%esi
  801abe:	72 0a                	jb     801aca <__udivdi3+0x6a>
  801ac0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ac4:	0f 87 9e 00 00 00    	ja     801b68 <__udivdi3+0x108>
  801aca:	b8 01 00 00 00       	mov    $0x1,%eax
  801acf:	89 fa                	mov    %edi,%edx
  801ad1:	83 c4 1c             	add    $0x1c,%esp
  801ad4:	5b                   	pop    %ebx
  801ad5:	5e                   	pop    %esi
  801ad6:	5f                   	pop    %edi
  801ad7:	5d                   	pop    %ebp
  801ad8:	c3                   	ret    
  801ad9:	8d 76 00             	lea    0x0(%esi),%esi
  801adc:	31 ff                	xor    %edi,%edi
  801ade:	31 c0                	xor    %eax,%eax
  801ae0:	89 fa                	mov    %edi,%edx
  801ae2:	83 c4 1c             	add    $0x1c,%esp
  801ae5:	5b                   	pop    %ebx
  801ae6:	5e                   	pop    %esi
  801ae7:	5f                   	pop    %edi
  801ae8:	5d                   	pop    %ebp
  801ae9:	c3                   	ret    
  801aea:	66 90                	xchg   %ax,%ax
  801aec:	89 d8                	mov    %ebx,%eax
  801aee:	f7 f7                	div    %edi
  801af0:	31 ff                	xor    %edi,%edi
  801af2:	89 fa                	mov    %edi,%edx
  801af4:	83 c4 1c             	add    $0x1c,%esp
  801af7:	5b                   	pop    %ebx
  801af8:	5e                   	pop    %esi
  801af9:	5f                   	pop    %edi
  801afa:	5d                   	pop    %ebp
  801afb:	c3                   	ret    
  801afc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b01:	89 eb                	mov    %ebp,%ebx
  801b03:	29 fb                	sub    %edi,%ebx
  801b05:	89 f9                	mov    %edi,%ecx
  801b07:	d3 e6                	shl    %cl,%esi
  801b09:	89 c5                	mov    %eax,%ebp
  801b0b:	88 d9                	mov    %bl,%cl
  801b0d:	d3 ed                	shr    %cl,%ebp
  801b0f:	89 e9                	mov    %ebp,%ecx
  801b11:	09 f1                	or     %esi,%ecx
  801b13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b17:	89 f9                	mov    %edi,%ecx
  801b19:	d3 e0                	shl    %cl,%eax
  801b1b:	89 c5                	mov    %eax,%ebp
  801b1d:	89 d6                	mov    %edx,%esi
  801b1f:	88 d9                	mov    %bl,%cl
  801b21:	d3 ee                	shr    %cl,%esi
  801b23:	89 f9                	mov    %edi,%ecx
  801b25:	d3 e2                	shl    %cl,%edx
  801b27:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b2b:	88 d9                	mov    %bl,%cl
  801b2d:	d3 e8                	shr    %cl,%eax
  801b2f:	09 c2                	or     %eax,%edx
  801b31:	89 d0                	mov    %edx,%eax
  801b33:	89 f2                	mov    %esi,%edx
  801b35:	f7 74 24 0c          	divl   0xc(%esp)
  801b39:	89 d6                	mov    %edx,%esi
  801b3b:	89 c3                	mov    %eax,%ebx
  801b3d:	f7 e5                	mul    %ebp
  801b3f:	39 d6                	cmp    %edx,%esi
  801b41:	72 19                	jb     801b5c <__udivdi3+0xfc>
  801b43:	74 0b                	je     801b50 <__udivdi3+0xf0>
  801b45:	89 d8                	mov    %ebx,%eax
  801b47:	31 ff                	xor    %edi,%edi
  801b49:	e9 58 ff ff ff       	jmp    801aa6 <__udivdi3+0x46>
  801b4e:	66 90                	xchg   %ax,%ax
  801b50:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b54:	89 f9                	mov    %edi,%ecx
  801b56:	d3 e2                	shl    %cl,%edx
  801b58:	39 c2                	cmp    %eax,%edx
  801b5a:	73 e9                	jae    801b45 <__udivdi3+0xe5>
  801b5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b5f:	31 ff                	xor    %edi,%edi
  801b61:	e9 40 ff ff ff       	jmp    801aa6 <__udivdi3+0x46>
  801b66:	66 90                	xchg   %ax,%ax
  801b68:	31 c0                	xor    %eax,%eax
  801b6a:	e9 37 ff ff ff       	jmp    801aa6 <__udivdi3+0x46>
  801b6f:	90                   	nop

00801b70 <__umoddi3>:
  801b70:	55                   	push   %ebp
  801b71:	57                   	push   %edi
  801b72:	56                   	push   %esi
  801b73:	53                   	push   %ebx
  801b74:	83 ec 1c             	sub    $0x1c,%esp
  801b77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b8f:	89 f3                	mov    %esi,%ebx
  801b91:	89 fa                	mov    %edi,%edx
  801b93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b97:	89 34 24             	mov    %esi,(%esp)
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	75 1a                	jne    801bb8 <__umoddi3+0x48>
  801b9e:	39 f7                	cmp    %esi,%edi
  801ba0:	0f 86 a2 00 00 00    	jbe    801c48 <__umoddi3+0xd8>
  801ba6:	89 c8                	mov    %ecx,%eax
  801ba8:	89 f2                	mov    %esi,%edx
  801baa:	f7 f7                	div    %edi
  801bac:	89 d0                	mov    %edx,%eax
  801bae:	31 d2                	xor    %edx,%edx
  801bb0:	83 c4 1c             	add    $0x1c,%esp
  801bb3:	5b                   	pop    %ebx
  801bb4:	5e                   	pop    %esi
  801bb5:	5f                   	pop    %edi
  801bb6:	5d                   	pop    %ebp
  801bb7:	c3                   	ret    
  801bb8:	39 f0                	cmp    %esi,%eax
  801bba:	0f 87 ac 00 00 00    	ja     801c6c <__umoddi3+0xfc>
  801bc0:	0f bd e8             	bsr    %eax,%ebp
  801bc3:	83 f5 1f             	xor    $0x1f,%ebp
  801bc6:	0f 84 ac 00 00 00    	je     801c78 <__umoddi3+0x108>
  801bcc:	bf 20 00 00 00       	mov    $0x20,%edi
  801bd1:	29 ef                	sub    %ebp,%edi
  801bd3:	89 fe                	mov    %edi,%esi
  801bd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bd9:	89 e9                	mov    %ebp,%ecx
  801bdb:	d3 e0                	shl    %cl,%eax
  801bdd:	89 d7                	mov    %edx,%edi
  801bdf:	89 f1                	mov    %esi,%ecx
  801be1:	d3 ef                	shr    %cl,%edi
  801be3:	09 c7                	or     %eax,%edi
  801be5:	89 e9                	mov    %ebp,%ecx
  801be7:	d3 e2                	shl    %cl,%edx
  801be9:	89 14 24             	mov    %edx,(%esp)
  801bec:	89 d8                	mov    %ebx,%eax
  801bee:	d3 e0                	shl    %cl,%eax
  801bf0:	89 c2                	mov    %eax,%edx
  801bf2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bf6:	d3 e0                	shl    %cl,%eax
  801bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c00:	89 f1                	mov    %esi,%ecx
  801c02:	d3 e8                	shr    %cl,%eax
  801c04:	09 d0                	or     %edx,%eax
  801c06:	d3 eb                	shr    %cl,%ebx
  801c08:	89 da                	mov    %ebx,%edx
  801c0a:	f7 f7                	div    %edi
  801c0c:	89 d3                	mov    %edx,%ebx
  801c0e:	f7 24 24             	mull   (%esp)
  801c11:	89 c6                	mov    %eax,%esi
  801c13:	89 d1                	mov    %edx,%ecx
  801c15:	39 d3                	cmp    %edx,%ebx
  801c17:	0f 82 87 00 00 00    	jb     801ca4 <__umoddi3+0x134>
  801c1d:	0f 84 91 00 00 00    	je     801cb4 <__umoddi3+0x144>
  801c23:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c27:	29 f2                	sub    %esi,%edx
  801c29:	19 cb                	sbb    %ecx,%ebx
  801c2b:	89 d8                	mov    %ebx,%eax
  801c2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c31:	d3 e0                	shl    %cl,%eax
  801c33:	89 e9                	mov    %ebp,%ecx
  801c35:	d3 ea                	shr    %cl,%edx
  801c37:	09 d0                	or     %edx,%eax
  801c39:	89 e9                	mov    %ebp,%ecx
  801c3b:	d3 eb                	shr    %cl,%ebx
  801c3d:	89 da                	mov    %ebx,%edx
  801c3f:	83 c4 1c             	add    $0x1c,%esp
  801c42:	5b                   	pop    %ebx
  801c43:	5e                   	pop    %esi
  801c44:	5f                   	pop    %edi
  801c45:	5d                   	pop    %ebp
  801c46:	c3                   	ret    
  801c47:	90                   	nop
  801c48:	89 fd                	mov    %edi,%ebp
  801c4a:	85 ff                	test   %edi,%edi
  801c4c:	75 0b                	jne    801c59 <__umoddi3+0xe9>
  801c4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c53:	31 d2                	xor    %edx,%edx
  801c55:	f7 f7                	div    %edi
  801c57:	89 c5                	mov    %eax,%ebp
  801c59:	89 f0                	mov    %esi,%eax
  801c5b:	31 d2                	xor    %edx,%edx
  801c5d:	f7 f5                	div    %ebp
  801c5f:	89 c8                	mov    %ecx,%eax
  801c61:	f7 f5                	div    %ebp
  801c63:	89 d0                	mov    %edx,%eax
  801c65:	e9 44 ff ff ff       	jmp    801bae <__umoddi3+0x3e>
  801c6a:	66 90                	xchg   %ax,%ax
  801c6c:	89 c8                	mov    %ecx,%eax
  801c6e:	89 f2                	mov    %esi,%edx
  801c70:	83 c4 1c             	add    $0x1c,%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5e                   	pop    %esi
  801c75:	5f                   	pop    %edi
  801c76:	5d                   	pop    %ebp
  801c77:	c3                   	ret    
  801c78:	3b 04 24             	cmp    (%esp),%eax
  801c7b:	72 06                	jb     801c83 <__umoddi3+0x113>
  801c7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c81:	77 0f                	ja     801c92 <__umoddi3+0x122>
  801c83:	89 f2                	mov    %esi,%edx
  801c85:	29 f9                	sub    %edi,%ecx
  801c87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c8b:	89 14 24             	mov    %edx,(%esp)
  801c8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c92:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c96:	8b 14 24             	mov    (%esp),%edx
  801c99:	83 c4 1c             	add    $0x1c,%esp
  801c9c:	5b                   	pop    %ebx
  801c9d:	5e                   	pop    %esi
  801c9e:	5f                   	pop    %edi
  801c9f:	5d                   	pop    %ebp
  801ca0:	c3                   	ret    
  801ca1:	8d 76 00             	lea    0x0(%esi),%esi
  801ca4:	2b 04 24             	sub    (%esp),%eax
  801ca7:	19 fa                	sbb    %edi,%edx
  801ca9:	89 d1                	mov    %edx,%ecx
  801cab:	89 c6                	mov    %eax,%esi
  801cad:	e9 71 ff ff ff       	jmp    801c23 <__umoddi3+0xb3>
  801cb2:	66 90                	xchg   %ax,%ax
  801cb4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cb8:	72 ea                	jb     801ca4 <__umoddi3+0x134>
  801cba:	89 d9                	mov    %ebx,%ecx
  801cbc:	e9 62 ff ff ff       	jmp    801c23 <__umoddi3+0xb3>
