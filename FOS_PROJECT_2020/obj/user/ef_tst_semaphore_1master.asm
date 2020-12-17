
obj/user/ef_tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 b1 01 00 00       	call   8001e7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int envID = sys_getenvid();
  80003e:	e8 77 12 00 00       	call   8012ba <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 c0 1c 80 00       	push   $0x801cc0
  800050:	e8 8d 14 00 00       	call   8014e2 <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 c4 1c 80 00       	push   $0x801cc4
  800062:	e8 7b 14 00 00       	call   8014e2 <sys_createSemaphore>
  800067:	83 c4 10             	add    $0x10,%esp

	int id1, id2, id3;
	id1 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size), 50);
  80006a:	a1 20 30 80 00       	mov    0x803020,%eax
  80006f:	8b 40 74             	mov    0x74(%eax),%eax
  800072:	83 ec 04             	sub    $0x4,%esp
  800075:	6a 32                	push   $0x32
  800077:	50                   	push   %eax
  800078:	68 cc 1c 80 00       	push   $0x801ccc
  80007d:	e8 71 15 00 00       	call   8015f3 <sys_create_env>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size), 50);
  800088:	a1 20 30 80 00       	mov    0x803020,%eax
  80008d:	8b 40 74             	mov    0x74(%eax),%eax
  800090:	83 ec 04             	sub    $0x4,%esp
  800093:	6a 32                	push   $0x32
  800095:	50                   	push   %eax
  800096:	68 cc 1c 80 00       	push   $0x801ccc
  80009b:	e8 53 15 00 00       	call   8015f3 <sys_create_env>
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size), 50);
  8000a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ab:	8b 40 74             	mov    0x74(%eax),%eax
  8000ae:	83 ec 04             	sub    $0x4,%esp
  8000b1:	6a 32                	push   $0x32
  8000b3:	50                   	push   %eax
  8000b4:	68 cc 1c 80 00       	push   $0x801ccc
  8000b9:	e8 35 15 00 00       	call   8015f3 <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(id1);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ca:	e8 41 15 00 00       	call   801610 <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d8:	e8 33 15 00 00       	call   801610 <sys_run_env>
  8000dd:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8000e6:	e8 25 15 00 00       	call   801610 <sys_run_env>
  8000eb:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  8000ee:	83 ec 08             	sub    $0x8,%esp
  8000f1:	68 c4 1c 80 00       	push   $0x801cc4
  8000f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000f9:	e8 1d 14 00 00       	call   80151b <sys_waitSemaphore>
  8000fe:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800101:	83 ec 08             	sub    $0x8,%esp
  800104:	68 c4 1c 80 00       	push   $0x801cc4
  800109:	ff 75 f4             	pushl  -0xc(%ebp)
  80010c:	e8 0a 14 00 00       	call   80151b <sys_waitSemaphore>
  800111:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	68 c4 1c 80 00       	push   $0x801cc4
  80011c:	ff 75 f4             	pushl  -0xc(%ebp)
  80011f:	e8 f7 13 00 00       	call   80151b <sys_waitSemaphore>
  800124:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  800127:	83 ec 08             	sub    $0x8,%esp
  80012a:	68 c0 1c 80 00       	push   $0x801cc0
  80012f:	ff 75 f4             	pushl  -0xc(%ebp)
  800132:	e8 c7 13 00 00       	call   8014fe <sys_getSemaphoreValue>
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  80013d:	83 ec 08             	sub    $0x8,%esp
  800140:	68 c4 1c 80 00       	push   $0x801cc4
  800145:	ff 75 f4             	pushl  -0xc(%ebp)
  800148:	e8 b1 13 00 00       	call   8014fe <sys_getSemaphoreValue>
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  800153:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800157:	75 18                	jne    800171 <_main+0x139>
  800159:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  80015d:	75 12                	jne    800171 <_main+0x139>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  80015f:	83 ec 0c             	sub    $0xc,%esp
  800162:	68 dc 1c 80 00       	push   $0x801cdc
  800167:	e8 94 02 00 00       	call   800400 <cprintf>
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	eb 10                	jmp    800181 <_main+0x149>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  800171:	83 ec 0c             	sub    $0xc,%esp
  800174:	68 24 1d 80 00       	push   $0x801d24
  800179:	e8 82 02 00 00       	call   800400 <cprintf>
  80017e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800181:	e8 66 11 00 00       	call   8012ec <sys_getparentenvid>
  800186:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  800189:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80018d:	7e 55                	jle    8001e4 <_main+0x1ac>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  80018f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	68 6f 1d 80 00       	push   $0x801d6f
  80019e:	ff 75 dc             	pushl  -0x24(%ebp)
  8001a1:	e8 1e 10 00 00       	call   8011c4 <sget>
  8001a6:	83 c4 10             	add    $0x10,%esp
  8001a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_free_env(id1);
  8001ac:	83 ec 0c             	sub    $0xc,%esp
  8001af:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b2:	e8 75 14 00 00       	call   80162c <sys_free_env>
  8001b7:	83 c4 10             	add    $0x10,%esp
		sys_free_env(id2);
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c0:	e8 67 14 00 00       	call   80162c <sys_free_env>
  8001c5:	83 c4 10             	add    $0x10,%esp
		sys_free_env(id3);
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ce:	e8 59 14 00 00       	call   80162c <sys_free_env>
  8001d3:	83 c4 10             	add    $0x10,%esp
		(*finishedCount)++ ;
  8001d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001d9:	8b 00                	mov    (%eax),%eax
  8001db:	8d 50 01             	lea    0x1(%eax),%edx
  8001de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001e1:	89 10                	mov    %edx,(%eax)
	}

	return;
  8001e3:	90                   	nop
  8001e4:	90                   	nop
}
  8001e5:	c9                   	leave  
  8001e6:	c3                   	ret    

008001e7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001e7:	55                   	push   %ebp
  8001e8:	89 e5                	mov    %esp,%ebp
  8001ea:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ed:	e8 e1 10 00 00       	call   8012d3 <sys_getenvindex>
  8001f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001f8:	89 d0                	mov    %edx,%eax
  8001fa:	c1 e0 03             	shl    $0x3,%eax
  8001fd:	01 d0                	add    %edx,%eax
  8001ff:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800206:	01 c8                	add    %ecx,%eax
  800208:	01 c0                	add    %eax,%eax
  80020a:	01 d0                	add    %edx,%eax
  80020c:	01 c0                	add    %eax,%eax
  80020e:	01 d0                	add    %edx,%eax
  800210:	89 c2                	mov    %eax,%edx
  800212:	c1 e2 05             	shl    $0x5,%edx
  800215:	29 c2                	sub    %eax,%edx
  800217:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80021e:	89 c2                	mov    %eax,%edx
  800220:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800226:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80022b:	a1 20 30 80 00       	mov    0x803020,%eax
  800230:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800236:	84 c0                	test   %al,%al
  800238:	74 0f                	je     800249 <libmain+0x62>
		binaryname = myEnv->prog_name;
  80023a:	a1 20 30 80 00       	mov    0x803020,%eax
  80023f:	05 40 3c 01 00       	add    $0x13c40,%eax
  800244:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80024d:	7e 0a                	jle    800259 <libmain+0x72>
		binaryname = argv[0];
  80024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800252:	8b 00                	mov    (%eax),%eax
  800254:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	ff 75 0c             	pushl  0xc(%ebp)
  80025f:	ff 75 08             	pushl  0x8(%ebp)
  800262:	e8 d1 fd ff ff       	call   800038 <_main>
  800267:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80026a:	e8 ff 11 00 00       	call   80146e <sys_disable_interrupt>
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 98 1d 80 00       	push   $0x801d98
  800277:	e8 84 01 00 00       	call   800400 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80027f:	a1 20 30 80 00       	mov    0x803020,%eax
  800284:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80028a:	a1 20 30 80 00       	mov    0x803020,%eax
  80028f:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	52                   	push   %edx
  800299:	50                   	push   %eax
  80029a:	68 c0 1d 80 00       	push   $0x801dc0
  80029f:	e8 5c 01 00 00       	call   800400 <cprintf>
  8002a4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8002a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ac:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8002b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b7:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8002bd:	83 ec 04             	sub    $0x4,%esp
  8002c0:	52                   	push   %edx
  8002c1:	50                   	push   %eax
  8002c2:	68 e8 1d 80 00       	push   $0x801de8
  8002c7:	e8 34 01 00 00       	call   800400 <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d4:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	50                   	push   %eax
  8002de:	68 29 1e 80 00       	push   $0x801e29
  8002e3:	e8 18 01 00 00       	call   800400 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002eb:	83 ec 0c             	sub    $0xc,%esp
  8002ee:	68 98 1d 80 00       	push   $0x801d98
  8002f3:	e8 08 01 00 00       	call   800400 <cprintf>
  8002f8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002fb:	e8 88 11 00 00       	call   801488 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800300:	e8 19 00 00 00       	call   80031e <exit>
}
  800305:	90                   	nop
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	6a 00                	push   $0x0
  800313:	e8 87 0f 00 00       	call   80129f <sys_env_destroy>
  800318:	83 c4 10             	add    $0x10,%esp
}
  80031b:	90                   	nop
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <exit>:

void
exit(void)
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800324:	e8 dc 0f 00 00       	call   801305 <sys_env_exit>
}
  800329:	90                   	nop
  80032a:	c9                   	leave  
  80032b:	c3                   	ret    

0080032c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800332:	8b 45 0c             	mov    0xc(%ebp),%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	8d 48 01             	lea    0x1(%eax),%ecx
  80033a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80033d:	89 0a                	mov    %ecx,(%edx)
  80033f:	8b 55 08             	mov    0x8(%ebp),%edx
  800342:	88 d1                	mov    %dl,%cl
  800344:	8b 55 0c             	mov    0xc(%ebp),%edx
  800347:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80034b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034e:	8b 00                	mov    (%eax),%eax
  800350:	3d ff 00 00 00       	cmp    $0xff,%eax
  800355:	75 2c                	jne    800383 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800357:	a0 24 30 80 00       	mov    0x803024,%al
  80035c:	0f b6 c0             	movzbl %al,%eax
  80035f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800362:	8b 12                	mov    (%edx),%edx
  800364:	89 d1                	mov    %edx,%ecx
  800366:	8b 55 0c             	mov    0xc(%ebp),%edx
  800369:	83 c2 08             	add    $0x8,%edx
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	50                   	push   %eax
  800370:	51                   	push   %ecx
  800371:	52                   	push   %edx
  800372:	e8 e6 0e 00 00       	call   80125d <sys_cputs>
  800377:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80037a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800383:	8b 45 0c             	mov    0xc(%ebp),%eax
  800386:	8b 40 04             	mov    0x4(%eax),%eax
  800389:	8d 50 01             	lea    0x1(%eax),%edx
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800392:	90                   	nop
  800393:	c9                   	leave  
  800394:	c3                   	ret    

00800395 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80039e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003a5:	00 00 00 
	b.cnt = 0;
  8003a8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003af:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003b2:	ff 75 0c             	pushl  0xc(%ebp)
  8003b5:	ff 75 08             	pushl  0x8(%ebp)
  8003b8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003be:	50                   	push   %eax
  8003bf:	68 2c 03 80 00       	push   $0x80032c
  8003c4:	e8 11 02 00 00       	call   8005da <vprintfmt>
  8003c9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8003cc:	a0 24 30 80 00       	mov    0x803024,%al
  8003d1:	0f b6 c0             	movzbl %al,%eax
  8003d4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	50                   	push   %eax
  8003de:	52                   	push   %edx
  8003df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e5:	83 c0 08             	add    $0x8,%eax
  8003e8:	50                   	push   %eax
  8003e9:	e8 6f 0e 00 00       	call   80125d <sys_cputs>
  8003ee:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003f1:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8003f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003fe:	c9                   	leave  
  8003ff:	c3                   	ret    

00800400 <cprintf>:

int cprintf(const char *fmt, ...) {
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800406:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80040d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800410:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	ff 75 f4             	pushl  -0xc(%ebp)
  80041c:	50                   	push   %eax
  80041d:	e8 73 ff ff ff       	call   800395 <vcprintf>
  800422:	83 c4 10             	add    $0x10,%esp
  800425:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800428:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80042b:	c9                   	leave  
  80042c:	c3                   	ret    

0080042d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
  800430:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800433:	e8 36 10 00 00       	call   80146e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800438:	8d 45 0c             	lea    0xc(%ebp),%eax
  80043b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80043e:	8b 45 08             	mov    0x8(%ebp),%eax
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	ff 75 f4             	pushl  -0xc(%ebp)
  800447:	50                   	push   %eax
  800448:	e8 48 ff ff ff       	call   800395 <vcprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
  800450:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800453:	e8 30 10 00 00       	call   801488 <sys_enable_interrupt>
	return cnt;
  800458:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80045b:	c9                   	leave  
  80045c:	c3                   	ret    

0080045d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80045d:	55                   	push   %ebp
  80045e:	89 e5                	mov    %esp,%ebp
  800460:	53                   	push   %ebx
  800461:	83 ec 14             	sub    $0x14,%esp
  800464:	8b 45 10             	mov    0x10(%ebp),%eax
  800467:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80046a:	8b 45 14             	mov    0x14(%ebp),%eax
  80046d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800470:	8b 45 18             	mov    0x18(%ebp),%eax
  800473:	ba 00 00 00 00       	mov    $0x0,%edx
  800478:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80047b:	77 55                	ja     8004d2 <printnum+0x75>
  80047d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800480:	72 05                	jb     800487 <printnum+0x2a>
  800482:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800485:	77 4b                	ja     8004d2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800487:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80048a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80048d:	8b 45 18             	mov    0x18(%ebp),%eax
  800490:	ba 00 00 00 00       	mov    $0x0,%edx
  800495:	52                   	push   %edx
  800496:	50                   	push   %eax
  800497:	ff 75 f4             	pushl  -0xc(%ebp)
  80049a:	ff 75 f0             	pushl  -0x10(%ebp)
  80049d:	e8 ba 15 00 00       	call   801a5c <__udivdi3>
  8004a2:	83 c4 10             	add    $0x10,%esp
  8004a5:	83 ec 04             	sub    $0x4,%esp
  8004a8:	ff 75 20             	pushl  0x20(%ebp)
  8004ab:	53                   	push   %ebx
  8004ac:	ff 75 18             	pushl  0x18(%ebp)
  8004af:	52                   	push   %edx
  8004b0:	50                   	push   %eax
  8004b1:	ff 75 0c             	pushl  0xc(%ebp)
  8004b4:	ff 75 08             	pushl  0x8(%ebp)
  8004b7:	e8 a1 ff ff ff       	call   80045d <printnum>
  8004bc:	83 c4 20             	add    $0x20,%esp
  8004bf:	eb 1a                	jmp    8004db <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	ff 75 0c             	pushl  0xc(%ebp)
  8004c7:	ff 75 20             	pushl  0x20(%ebp)
  8004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cd:	ff d0                	call   *%eax
  8004cf:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004d2:	ff 4d 1c             	decl   0x1c(%ebp)
  8004d5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004d9:	7f e6                	jg     8004c1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004db:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004e9:	53                   	push   %ebx
  8004ea:	51                   	push   %ecx
  8004eb:	52                   	push   %edx
  8004ec:	50                   	push   %eax
  8004ed:	e8 7a 16 00 00       	call   801b6c <__umoddi3>
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	05 54 20 80 00       	add    $0x802054,%eax
  8004fa:	8a 00                	mov    (%eax),%al
  8004fc:	0f be c0             	movsbl %al,%eax
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	ff 75 0c             	pushl  0xc(%ebp)
  800505:	50                   	push   %eax
  800506:	8b 45 08             	mov    0x8(%ebp),%eax
  800509:	ff d0                	call   *%eax
  80050b:	83 c4 10             	add    $0x10,%esp
}
  80050e:	90                   	nop
  80050f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800512:	c9                   	leave  
  800513:	c3                   	ret    

00800514 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800514:	55                   	push   %ebp
  800515:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800517:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80051b:	7e 1c                	jle    800539 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	8b 00                	mov    (%eax),%eax
  800522:	8d 50 08             	lea    0x8(%eax),%edx
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	89 10                	mov    %edx,(%eax)
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	83 e8 08             	sub    $0x8,%eax
  800532:	8b 50 04             	mov    0x4(%eax),%edx
  800535:	8b 00                	mov    (%eax),%eax
  800537:	eb 40                	jmp    800579 <getuint+0x65>
	else if (lflag)
  800539:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80053d:	74 1e                	je     80055d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80053f:	8b 45 08             	mov    0x8(%ebp),%eax
  800542:	8b 00                	mov    (%eax),%eax
  800544:	8d 50 04             	lea    0x4(%eax),%edx
  800547:	8b 45 08             	mov    0x8(%ebp),%eax
  80054a:	89 10                	mov    %edx,(%eax)
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	83 e8 04             	sub    $0x4,%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	ba 00 00 00 00       	mov    $0x0,%edx
  80055b:	eb 1c                	jmp    800579 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	8d 50 04             	lea    0x4(%eax),%edx
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	89 10                	mov    %edx,(%eax)
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	8b 00                	mov    (%eax),%eax
  80056f:	83 e8 04             	sub    $0x4,%eax
  800572:	8b 00                	mov    (%eax),%eax
  800574:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800579:	5d                   	pop    %ebp
  80057a:	c3                   	ret    

0080057b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80057b:	55                   	push   %ebp
  80057c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80057e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800582:	7e 1c                	jle    8005a0 <getint+0x25>
		return va_arg(*ap, long long);
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	8d 50 08             	lea    0x8(%eax),%edx
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	89 10                	mov    %edx,(%eax)
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	8b 00                	mov    (%eax),%eax
  800596:	83 e8 08             	sub    $0x8,%eax
  800599:	8b 50 04             	mov    0x4(%eax),%edx
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	eb 38                	jmp    8005d8 <getint+0x5d>
	else if (lflag)
  8005a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005a4:	74 1a                	je     8005c0 <getint+0x45>
		return va_arg(*ap, long);
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	8d 50 04             	lea    0x4(%eax),%edx
  8005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b1:	89 10                	mov    %edx,(%eax)
  8005b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b6:	8b 00                	mov    (%eax),%eax
  8005b8:	83 e8 04             	sub    $0x4,%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	99                   	cltd   
  8005be:	eb 18                	jmp    8005d8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	8d 50 04             	lea    0x4(%eax),%edx
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	89 10                	mov    %edx,(%eax)
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	83 e8 04             	sub    $0x4,%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	99                   	cltd   
}
  8005d8:	5d                   	pop    %ebp
  8005d9:	c3                   	ret    

008005da <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	56                   	push   %esi
  8005de:	53                   	push   %ebx
  8005df:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005e2:	eb 17                	jmp    8005fb <vprintfmt+0x21>
			if (ch == '\0')
  8005e4:	85 db                	test   %ebx,%ebx
  8005e6:	0f 84 af 03 00 00    	je     80099b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	53                   	push   %ebx
  8005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f6:	ff d0                	call   *%eax
  8005f8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8005fe:	8d 50 01             	lea    0x1(%eax),%edx
  800601:	89 55 10             	mov    %edx,0x10(%ebp)
  800604:	8a 00                	mov    (%eax),%al
  800606:	0f b6 d8             	movzbl %al,%ebx
  800609:	83 fb 25             	cmp    $0x25,%ebx
  80060c:	75 d6                	jne    8005e4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80060e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800612:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800619:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800620:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800627:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80062e:	8b 45 10             	mov    0x10(%ebp),%eax
  800631:	8d 50 01             	lea    0x1(%eax),%edx
  800634:	89 55 10             	mov    %edx,0x10(%ebp)
  800637:	8a 00                	mov    (%eax),%al
  800639:	0f b6 d8             	movzbl %al,%ebx
  80063c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80063f:	83 f8 55             	cmp    $0x55,%eax
  800642:	0f 87 2b 03 00 00    	ja     800973 <vprintfmt+0x399>
  800648:	8b 04 85 78 20 80 00 	mov    0x802078(,%eax,4),%eax
  80064f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800651:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800655:	eb d7                	jmp    80062e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800657:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80065b:	eb d1                	jmp    80062e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80065d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800664:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800667:	89 d0                	mov    %edx,%eax
  800669:	c1 e0 02             	shl    $0x2,%eax
  80066c:	01 d0                	add    %edx,%eax
  80066e:	01 c0                	add    %eax,%eax
  800670:	01 d8                	add    %ebx,%eax
  800672:	83 e8 30             	sub    $0x30,%eax
  800675:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800678:	8b 45 10             	mov    0x10(%ebp),%eax
  80067b:	8a 00                	mov    (%eax),%al
  80067d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800680:	83 fb 2f             	cmp    $0x2f,%ebx
  800683:	7e 3e                	jle    8006c3 <vprintfmt+0xe9>
  800685:	83 fb 39             	cmp    $0x39,%ebx
  800688:	7f 39                	jg     8006c3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80068a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80068d:	eb d5                	jmp    800664 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	83 c0 04             	add    $0x4,%eax
  800695:	89 45 14             	mov    %eax,0x14(%ebp)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	83 e8 04             	sub    $0x4,%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006a3:	eb 1f                	jmp    8006c4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a9:	79 83                	jns    80062e <vprintfmt+0x54>
				width = 0;
  8006ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006b2:	e9 77 ff ff ff       	jmp    80062e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006b7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006be:	e9 6b ff ff ff       	jmp    80062e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006c3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c8:	0f 89 60 ff ff ff    	jns    80062e <vprintfmt+0x54>
				width = precision, precision = -1;
  8006ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006db:	e9 4e ff ff ff       	jmp    80062e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006e0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006e3:	e9 46 ff ff ff       	jmp    80062e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	83 c0 04             	add    $0x4,%eax
  8006ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	83 e8 04             	sub    $0x4,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	ff 75 0c             	pushl  0xc(%ebp)
  8006ff:	50                   	push   %eax
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	ff d0                	call   *%eax
  800705:	83 c4 10             	add    $0x10,%esp
			break;
  800708:	e9 89 02 00 00       	jmp    800996 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	83 c0 04             	add    $0x4,%eax
  800713:	89 45 14             	mov    %eax,0x14(%ebp)
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	83 e8 04             	sub    $0x4,%eax
  80071c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80071e:	85 db                	test   %ebx,%ebx
  800720:	79 02                	jns    800724 <vprintfmt+0x14a>
				err = -err;
  800722:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800724:	83 fb 64             	cmp    $0x64,%ebx
  800727:	7f 0b                	jg     800734 <vprintfmt+0x15a>
  800729:	8b 34 9d c0 1e 80 00 	mov    0x801ec0(,%ebx,4),%esi
  800730:	85 f6                	test   %esi,%esi
  800732:	75 19                	jne    80074d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800734:	53                   	push   %ebx
  800735:	68 65 20 80 00       	push   $0x802065
  80073a:	ff 75 0c             	pushl  0xc(%ebp)
  80073d:	ff 75 08             	pushl  0x8(%ebp)
  800740:	e8 5e 02 00 00       	call   8009a3 <printfmt>
  800745:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800748:	e9 49 02 00 00       	jmp    800996 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80074d:	56                   	push   %esi
  80074e:	68 6e 20 80 00       	push   $0x80206e
  800753:	ff 75 0c             	pushl  0xc(%ebp)
  800756:	ff 75 08             	pushl  0x8(%ebp)
  800759:	e8 45 02 00 00       	call   8009a3 <printfmt>
  80075e:	83 c4 10             	add    $0x10,%esp
			break;
  800761:	e9 30 02 00 00       	jmp    800996 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	83 c0 04             	add    $0x4,%eax
  80076c:	89 45 14             	mov    %eax,0x14(%ebp)
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	83 e8 04             	sub    $0x4,%eax
  800775:	8b 30                	mov    (%eax),%esi
  800777:	85 f6                	test   %esi,%esi
  800779:	75 05                	jne    800780 <vprintfmt+0x1a6>
				p = "(null)";
  80077b:	be 71 20 80 00       	mov    $0x802071,%esi
			if (width > 0 && padc != '-')
  800780:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800784:	7e 6d                	jle    8007f3 <vprintfmt+0x219>
  800786:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80078a:	74 67                	je     8007f3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80078c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	50                   	push   %eax
  800793:	56                   	push   %esi
  800794:	e8 0c 03 00 00       	call   800aa5 <strnlen>
  800799:	83 c4 10             	add    $0x10,%esp
  80079c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80079f:	eb 16                	jmp    8007b7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007a1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007a5:	83 ec 08             	sub    $0x8,%esp
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	50                   	push   %eax
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	ff d0                	call   *%eax
  8007b1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b4:	ff 4d e4             	decl   -0x1c(%ebp)
  8007b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007bb:	7f e4                	jg     8007a1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007bd:	eb 34                	jmp    8007f3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007c3:	74 1c                	je     8007e1 <vprintfmt+0x207>
  8007c5:	83 fb 1f             	cmp    $0x1f,%ebx
  8007c8:	7e 05                	jle    8007cf <vprintfmt+0x1f5>
  8007ca:	83 fb 7e             	cmp    $0x7e,%ebx
  8007cd:	7e 12                	jle    8007e1 <vprintfmt+0x207>
					putch('?', putdat);
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	ff 75 0c             	pushl  0xc(%ebp)
  8007d5:	6a 3f                	push   $0x3f
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	ff d0                	call   *%eax
  8007dc:	83 c4 10             	add    $0x10,%esp
  8007df:	eb 0f                	jmp    8007f0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	ff 75 0c             	pushl  0xc(%ebp)
  8007e7:	53                   	push   %ebx
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	ff d0                	call   *%eax
  8007ed:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007f0:	ff 4d e4             	decl   -0x1c(%ebp)
  8007f3:	89 f0                	mov    %esi,%eax
  8007f5:	8d 70 01             	lea    0x1(%eax),%esi
  8007f8:	8a 00                	mov    (%eax),%al
  8007fa:	0f be d8             	movsbl %al,%ebx
  8007fd:	85 db                	test   %ebx,%ebx
  8007ff:	74 24                	je     800825 <vprintfmt+0x24b>
  800801:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800805:	78 b8                	js     8007bf <vprintfmt+0x1e5>
  800807:	ff 4d e0             	decl   -0x20(%ebp)
  80080a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80080e:	79 af                	jns    8007bf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800810:	eb 13                	jmp    800825 <vprintfmt+0x24b>
				putch(' ', putdat);
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	6a 20                	push   $0x20
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	ff d0                	call   *%eax
  80081f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800822:	ff 4d e4             	decl   -0x1c(%ebp)
  800825:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800829:	7f e7                	jg     800812 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80082b:	e9 66 01 00 00       	jmp    800996 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 e8             	pushl  -0x18(%ebp)
  800836:	8d 45 14             	lea    0x14(%ebp),%eax
  800839:	50                   	push   %eax
  80083a:	e8 3c fd ff ff       	call   80057b <getint>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800845:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80084e:	85 d2                	test   %edx,%edx
  800850:	79 23                	jns    800875 <vprintfmt+0x29b>
				putch('-', putdat);
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	ff 75 0c             	pushl  0xc(%ebp)
  800858:	6a 2d                	push   $0x2d
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	ff d0                	call   *%eax
  80085f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800865:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800868:	f7 d8                	neg    %eax
  80086a:	83 d2 00             	adc    $0x0,%edx
  80086d:	f7 da                	neg    %edx
  80086f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800872:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800875:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80087c:	e9 bc 00 00 00       	jmp    80093d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800881:	83 ec 08             	sub    $0x8,%esp
  800884:	ff 75 e8             	pushl  -0x18(%ebp)
  800887:	8d 45 14             	lea    0x14(%ebp),%eax
  80088a:	50                   	push   %eax
  80088b:	e8 84 fc ff ff       	call   800514 <getuint>
  800890:	83 c4 10             	add    $0x10,%esp
  800893:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800896:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800899:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008a0:	e9 98 00 00 00       	jmp    80093d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	6a 58                	push   $0x58
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	ff d0                	call   *%eax
  8008b2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	ff 75 0c             	pushl  0xc(%ebp)
  8008bb:	6a 58                	push   $0x58
  8008bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c0:	ff d0                	call   *%eax
  8008c2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	6a 58                	push   $0x58
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	ff d0                	call   *%eax
  8008d2:	83 c4 10             	add    $0x10,%esp
			break;
  8008d5:	e9 bc 00 00 00       	jmp    800996 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8008da:	83 ec 08             	sub    $0x8,%esp
  8008dd:	ff 75 0c             	pushl  0xc(%ebp)
  8008e0:	6a 30                	push   $0x30
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	ff d0                	call   *%eax
  8008e7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	ff 75 0c             	pushl  0xc(%ebp)
  8008f0:	6a 78                	push   $0x78
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	ff d0                	call   *%eax
  8008f7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fd:	83 c0 04             	add    $0x4,%eax
  800900:	89 45 14             	mov    %eax,0x14(%ebp)
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 e8 04             	sub    $0x4,%eax
  800909:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80090b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80090e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800915:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80091c:	eb 1f                	jmp    80093d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	ff 75 e8             	pushl  -0x18(%ebp)
  800924:	8d 45 14             	lea    0x14(%ebp),%eax
  800927:	50                   	push   %eax
  800928:	e8 e7 fb ff ff       	call   800514 <getuint>
  80092d:	83 c4 10             	add    $0x10,%esp
  800930:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800933:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800936:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80093d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800944:	83 ec 04             	sub    $0x4,%esp
  800947:	52                   	push   %edx
  800948:	ff 75 e4             	pushl  -0x1c(%ebp)
  80094b:	50                   	push   %eax
  80094c:	ff 75 f4             	pushl  -0xc(%ebp)
  80094f:	ff 75 f0             	pushl  -0x10(%ebp)
  800952:	ff 75 0c             	pushl  0xc(%ebp)
  800955:	ff 75 08             	pushl  0x8(%ebp)
  800958:	e8 00 fb ff ff       	call   80045d <printnum>
  80095d:	83 c4 20             	add    $0x20,%esp
			break;
  800960:	eb 34                	jmp    800996 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	ff 75 0c             	pushl  0xc(%ebp)
  800968:	53                   	push   %ebx
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
			break;
  800971:	eb 23                	jmp    800996 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	ff 75 0c             	pushl  0xc(%ebp)
  800979:	6a 25                	push   $0x25
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	ff d0                	call   *%eax
  800980:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800983:	ff 4d 10             	decl   0x10(%ebp)
  800986:	eb 03                	jmp    80098b <vprintfmt+0x3b1>
  800988:	ff 4d 10             	decl   0x10(%ebp)
  80098b:	8b 45 10             	mov    0x10(%ebp),%eax
  80098e:	48                   	dec    %eax
  80098f:	8a 00                	mov    (%eax),%al
  800991:	3c 25                	cmp    $0x25,%al
  800993:	75 f3                	jne    800988 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800995:	90                   	nop
		}
	}
  800996:	e9 47 fc ff ff       	jmp    8005e2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80099b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80099c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80099f:	5b                   	pop    %ebx
  8009a0:	5e                   	pop    %esi
  8009a1:	5d                   	pop    %ebp
  8009a2:	c3                   	ret    

008009a3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009a9:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ac:	83 c0 04             	add    $0x4,%eax
  8009af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b8:	50                   	push   %eax
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	ff 75 08             	pushl  0x8(%ebp)
  8009bf:	e8 16 fc ff ff       	call   8005da <vprintfmt>
  8009c4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009c7:	90                   	nop
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d0:	8b 40 08             	mov    0x8(%eax),%eax
  8009d3:	8d 50 01             	lea    0x1(%eax),%edx
  8009d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009df:	8b 10                	mov    (%eax),%edx
  8009e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e4:	8b 40 04             	mov    0x4(%eax),%eax
  8009e7:	39 c2                	cmp    %eax,%edx
  8009e9:	73 12                	jae    8009fd <sprintputch+0x33>
		*b->buf++ = ch;
  8009eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ee:	8b 00                	mov    (%eax),%eax
  8009f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8009f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f6:	89 0a                	mov    %ecx,(%edx)
  8009f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8009fb:	88 10                	mov    %dl,(%eax)
}
  8009fd:	90                   	nop
  8009fe:	5d                   	pop    %ebp
  8009ff:	c3                   	ret    

00800a00 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	01 d0                	add    %edx,%eax
  800a17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a25:	74 06                	je     800a2d <vsnprintf+0x2d>
  800a27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a2b:	7f 07                	jg     800a34 <vsnprintf+0x34>
		return -E_INVAL;
  800a2d:	b8 03 00 00 00       	mov    $0x3,%eax
  800a32:	eb 20                	jmp    800a54 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a34:	ff 75 14             	pushl  0x14(%ebp)
  800a37:	ff 75 10             	pushl  0x10(%ebp)
  800a3a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a3d:	50                   	push   %eax
  800a3e:	68 ca 09 80 00       	push   $0x8009ca
  800a43:	e8 92 fb ff ff       	call   8005da <vprintfmt>
  800a48:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a4e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a54:	c9                   	leave  
  800a55:	c3                   	ret    

00800a56 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a5c:	8d 45 10             	lea    0x10(%ebp),%eax
  800a5f:	83 c0 04             	add    $0x4,%eax
  800a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a65:	8b 45 10             	mov    0x10(%ebp),%eax
  800a68:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6b:	50                   	push   %eax
  800a6c:	ff 75 0c             	pushl  0xc(%ebp)
  800a6f:	ff 75 08             	pushl  0x8(%ebp)
  800a72:	e8 89 ff ff ff       	call   800a00 <vsnprintf>
  800a77:	83 c4 10             	add    $0x10,%esp
  800a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a80:	c9                   	leave  
  800a81:	c3                   	ret    

00800a82 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8f:	eb 06                	jmp    800a97 <strlen+0x15>
		n++;
  800a91:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a94:	ff 45 08             	incl   0x8(%ebp)
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	8a 00                	mov    (%eax),%al
  800a9c:	84 c0                	test   %al,%al
  800a9e:	75 f1                	jne    800a91 <strlen+0xf>
		n++;
	return n;
  800aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aa3:	c9                   	leave  
  800aa4:	c3                   	ret    

00800aa5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ab2:	eb 09                	jmp    800abd <strnlen+0x18>
		n++;
  800ab4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ab7:	ff 45 08             	incl   0x8(%ebp)
  800aba:	ff 4d 0c             	decl   0xc(%ebp)
  800abd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac1:	74 09                	je     800acc <strnlen+0x27>
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	8a 00                	mov    (%eax),%al
  800ac8:	84 c0                	test   %al,%al
  800aca:	75 e8                	jne    800ab4 <strnlen+0xf>
		n++;
	return n;
  800acc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800acf:	c9                   	leave  
  800ad0:	c3                   	ret    

00800ad1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800add:	90                   	nop
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8d 50 01             	lea    0x1(%eax),%edx
  800ae4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800af0:	8a 12                	mov    (%edx),%dl
  800af2:	88 10                	mov    %dl,(%eax)
  800af4:	8a 00                	mov    (%eax),%al
  800af6:	84 c0                	test   %al,%al
  800af8:	75 e4                	jne    800ade <strcpy+0xd>
		/* do nothing */;
	return ret;
  800afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b12:	eb 1f                	jmp    800b33 <strncpy+0x34>
		*dst++ = *src;
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8d 50 01             	lea    0x1(%eax),%edx
  800b1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b20:	8a 12                	mov    (%edx),%dl
  800b22:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b27:	8a 00                	mov    (%eax),%al
  800b29:	84 c0                	test   %al,%al
  800b2b:	74 03                	je     800b30 <strncpy+0x31>
			src++;
  800b2d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b30:	ff 45 fc             	incl   -0x4(%ebp)
  800b33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b36:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b39:	72 d9                	jb     800b14 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b3e:	c9                   	leave  
  800b3f:	c3                   	ret    

00800b40 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b50:	74 30                	je     800b82 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b52:	eb 16                	jmp    800b6a <strlcpy+0x2a>
			*dst++ = *src++;
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	8d 50 01             	lea    0x1(%eax),%edx
  800b5a:	89 55 08             	mov    %edx,0x8(%ebp)
  800b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b60:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b63:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b66:	8a 12                	mov    (%edx),%dl
  800b68:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b6a:	ff 4d 10             	decl   0x10(%ebp)
  800b6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b71:	74 09                	je     800b7c <strlcpy+0x3c>
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	8a 00                	mov    (%eax),%al
  800b78:	84 c0                	test   %al,%al
  800b7a:	75 d8                	jne    800b54 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b82:	8b 55 08             	mov    0x8(%ebp),%edx
  800b85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b88:	29 c2                	sub    %eax,%edx
  800b8a:	89 d0                	mov    %edx,%eax
}
  800b8c:	c9                   	leave  
  800b8d:	c3                   	ret    

00800b8e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b91:	eb 06                	jmp    800b99 <strcmp+0xb>
		p++, q++;
  800b93:	ff 45 08             	incl   0x8(%ebp)
  800b96:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8a 00                	mov    (%eax),%al
  800b9e:	84 c0                	test   %al,%al
  800ba0:	74 0e                	je     800bb0 <strcmp+0x22>
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8a 10                	mov    (%eax),%dl
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	38 c2                	cmp    %al,%dl
  800bae:	74 e3                	je     800b93 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8a 00                	mov    (%eax),%al
  800bb5:	0f b6 d0             	movzbl %al,%edx
  800bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	0f b6 c0             	movzbl %al,%eax
  800bc0:	29 c2                	sub    %eax,%edx
  800bc2:	89 d0                	mov    %edx,%eax
}
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800bc9:	eb 09                	jmp    800bd4 <strncmp+0xe>
		n--, p++, q++;
  800bcb:	ff 4d 10             	decl   0x10(%ebp)
  800bce:	ff 45 08             	incl   0x8(%ebp)
  800bd1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800bd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bd8:	74 17                	je     800bf1 <strncmp+0x2b>
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	84 c0                	test   %al,%al
  800be1:	74 0e                	je     800bf1 <strncmp+0x2b>
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8a 10                	mov    (%eax),%dl
  800be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	38 c2                	cmp    %al,%dl
  800bef:	74 da                	je     800bcb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800bf1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf5:	75 07                	jne    800bfe <strncmp+0x38>
		return 0;
  800bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfc:	eb 14                	jmp    800c12 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8a 00                	mov    (%eax),%al
  800c03:	0f b6 d0             	movzbl %al,%edx
  800c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	0f b6 c0             	movzbl %al,%eax
  800c0e:	29 c2                	sub    %eax,%edx
  800c10:	89 d0                	mov    %edx,%eax
}
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	83 ec 04             	sub    $0x4,%esp
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c20:	eb 12                	jmp    800c34 <strchr+0x20>
		if (*s == c)
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8a 00                	mov    (%eax),%al
  800c27:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c2a:	75 05                	jne    800c31 <strchr+0x1d>
			return (char *) s;
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	eb 11                	jmp    800c42 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c31:	ff 45 08             	incl   0x8(%ebp)
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 e5                	jne    800c22 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 04             	sub    $0x4,%esp
  800c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c50:	eb 0d                	jmp    800c5f <strfind+0x1b>
		if (*s == c)
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c5a:	74 0e                	je     800c6a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c5c:	ff 45 08             	incl   0x8(%ebp)
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8a 00                	mov    (%eax),%al
  800c64:	84 c0                	test   %al,%al
  800c66:	75 ea                	jne    800c52 <strfind+0xe>
  800c68:	eb 01                	jmp    800c6b <strfind+0x27>
		if (*s == c)
			break;
  800c6a:	90                   	nop
	return (char *) s;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c82:	eb 0e                	jmp    800c92 <memset+0x22>
		*p++ = c;
  800c84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c87:	8d 50 01             	lea    0x1(%eax),%edx
  800c8a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c90:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c92:	ff 4d f8             	decl   -0x8(%ebp)
  800c95:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c99:	79 e9                	jns    800c84 <memset+0x14>
		*p++ = c;

	return v;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800cb2:	eb 16                	jmp    800cca <memcpy+0x2a>
		*d++ = *s++;
  800cb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cb7:	8d 50 01             	lea    0x1(%eax),%edx
  800cba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cbd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cc6:	8a 12                	mov    (%edx),%dl
  800cc8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800cca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	75 dd                	jne    800cb4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cf4:	73 50                	jae    800d46 <memmove+0x6a>
  800cf6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cf9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfc:	01 d0                	add    %edx,%eax
  800cfe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d01:	76 43                	jbe    800d46 <memmove+0x6a>
		s += n;
  800d03:	8b 45 10             	mov    0x10(%ebp),%eax
  800d06:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d09:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d0f:	eb 10                	jmp    800d21 <memmove+0x45>
			*--d = *--s;
  800d11:	ff 4d f8             	decl   -0x8(%ebp)
  800d14:	ff 4d fc             	decl   -0x4(%ebp)
  800d17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1a:	8a 10                	mov    (%eax),%dl
  800d1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d21:	8b 45 10             	mov    0x10(%ebp),%eax
  800d24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d27:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2a:	85 c0                	test   %eax,%eax
  800d2c:	75 e3                	jne    800d11 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d2e:	eb 23                	jmp    800d53 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d33:	8d 50 01             	lea    0x1(%eax),%edx
  800d36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d42:	8a 12                	mov    (%edx),%dl
  800d44:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d46:	8b 45 10             	mov    0x10(%ebp),%eax
  800d49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	75 dd                	jne    800d30 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d56:	c9                   	leave  
  800d57:	c3                   	ret    

00800d58 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d6a:	eb 2a                	jmp    800d96 <memcmp+0x3e>
		if (*s1 != *s2)
  800d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6f:	8a 10                	mov    (%eax),%dl
  800d71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d74:	8a 00                	mov    (%eax),%al
  800d76:	38 c2                	cmp    %al,%dl
  800d78:	74 16                	je     800d90 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7d:	8a 00                	mov    (%eax),%al
  800d7f:	0f b6 d0             	movzbl %al,%edx
  800d82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	0f b6 c0             	movzbl %al,%eax
  800d8a:	29 c2                	sub    %eax,%edx
  800d8c:	89 d0                	mov    %edx,%eax
  800d8e:	eb 18                	jmp    800da8 <memcmp+0x50>
		s1++, s2++;
  800d90:	ff 45 fc             	incl   -0x4(%ebp)
  800d93:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d96:	8b 45 10             	mov    0x10(%ebp),%eax
  800d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	75 c9                	jne    800d6c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	8b 45 10             	mov    0x10(%ebp),%eax
  800db6:	01 d0                	add    %edx,%eax
  800db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800dbb:	eb 15                	jmp    800dd2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	0f b6 d0             	movzbl %al,%edx
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	0f b6 c0             	movzbl %al,%eax
  800dcb:	39 c2                	cmp    %eax,%edx
  800dcd:	74 0d                	je     800ddc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dcf:	ff 45 08             	incl   0x8(%ebp)
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dd8:	72 e3                	jb     800dbd <memfind+0x13>
  800dda:	eb 01                	jmp    800ddd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ddc:	90                   	nop
	return (void *) s;
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800def:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800df6:	eb 03                	jmp    800dfb <strtol+0x19>
		s++;
  800df8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	3c 20                	cmp    $0x20,%al
  800e02:	74 f4                	je     800df8 <strtol+0x16>
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	3c 09                	cmp    $0x9,%al
  800e0b:	74 eb                	je     800df8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	3c 2b                	cmp    $0x2b,%al
  800e14:	75 05                	jne    800e1b <strtol+0x39>
		s++;
  800e16:	ff 45 08             	incl   0x8(%ebp)
  800e19:	eb 13                	jmp    800e2e <strtol+0x4c>
	else if (*s == '-')
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	3c 2d                	cmp    $0x2d,%al
  800e22:	75 0a                	jne    800e2e <strtol+0x4c>
		s++, neg = 1;
  800e24:	ff 45 08             	incl   0x8(%ebp)
  800e27:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e32:	74 06                	je     800e3a <strtol+0x58>
  800e34:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e38:	75 20                	jne    800e5a <strtol+0x78>
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	3c 30                	cmp    $0x30,%al
  800e41:	75 17                	jne    800e5a <strtol+0x78>
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	40                   	inc    %eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	3c 78                	cmp    $0x78,%al
  800e4b:	75 0d                	jne    800e5a <strtol+0x78>
		s += 2, base = 16;
  800e4d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e51:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e58:	eb 28                	jmp    800e82 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5e:	75 15                	jne    800e75 <strtol+0x93>
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	3c 30                	cmp    $0x30,%al
  800e67:	75 0c                	jne    800e75 <strtol+0x93>
		s++, base = 8;
  800e69:	ff 45 08             	incl   0x8(%ebp)
  800e6c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e73:	eb 0d                	jmp    800e82 <strtol+0xa0>
	else if (base == 0)
  800e75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e79:	75 07                	jne    800e82 <strtol+0xa0>
		base = 10;
  800e7b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	3c 2f                	cmp    $0x2f,%al
  800e89:	7e 19                	jle    800ea4 <strtol+0xc2>
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	3c 39                	cmp    $0x39,%al
  800e92:	7f 10                	jg     800ea4 <strtol+0xc2>
			dig = *s - '0';
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	0f be c0             	movsbl %al,%eax
  800e9c:	83 e8 30             	sub    $0x30,%eax
  800e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ea2:	eb 42                	jmp    800ee6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	3c 60                	cmp    $0x60,%al
  800eab:	7e 19                	jle    800ec6 <strtol+0xe4>
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	3c 7a                	cmp    $0x7a,%al
  800eb4:	7f 10                	jg     800ec6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f be c0             	movsbl %al,%eax
  800ebe:	83 e8 57             	sub    $0x57,%eax
  800ec1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ec4:	eb 20                	jmp    800ee6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	3c 40                	cmp    $0x40,%al
  800ecd:	7e 39                	jle    800f08 <strtol+0x126>
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	3c 5a                	cmp    $0x5a,%al
  800ed6:	7f 30                	jg     800f08 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	8a 00                	mov    (%eax),%al
  800edd:	0f be c0             	movsbl %al,%eax
  800ee0:	83 e8 37             	sub    $0x37,%eax
  800ee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800eec:	7d 19                	jge    800f07 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800eee:	ff 45 08             	incl   0x8(%ebp)
  800ef1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ef8:	89 c2                	mov    %eax,%edx
  800efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800efd:	01 d0                	add    %edx,%eax
  800eff:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f02:	e9 7b ff ff ff       	jmp    800e82 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f07:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0c:	74 08                	je     800f16 <strtol+0x134>
		*endptr = (char *) s;
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f16:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f1a:	74 07                	je     800f23 <strtol+0x141>
  800f1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1f:	f7 d8                	neg    %eax
  800f21:	eb 03                	jmp    800f26 <strtol+0x144>
  800f23:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f26:	c9                   	leave  
  800f27:	c3                   	ret    

00800f28 <ltostr>:

void
ltostr(long value, char *str)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f35:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f40:	79 13                	jns    800f55 <ltostr+0x2d>
	{
		neg = 1;
  800f42:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f4f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f52:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f5d:	99                   	cltd   
  800f5e:	f7 f9                	idiv   %ecx
  800f60:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f66:	8d 50 01             	lea    0x1(%eax),%edx
  800f69:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6c:	89 c2                	mov    %eax,%edx
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	01 d0                	add    %edx,%eax
  800f73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f76:	83 c2 30             	add    $0x30,%edx
  800f79:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f7e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f83:	f7 e9                	imul   %ecx
  800f85:	c1 fa 02             	sar    $0x2,%edx
  800f88:	89 c8                	mov    %ecx,%eax
  800f8a:	c1 f8 1f             	sar    $0x1f,%eax
  800f8d:	29 c2                	sub    %eax,%edx
  800f8f:	89 d0                	mov    %edx,%eax
  800f91:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f97:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f9c:	f7 e9                	imul   %ecx
  800f9e:	c1 fa 02             	sar    $0x2,%edx
  800fa1:	89 c8                	mov    %ecx,%eax
  800fa3:	c1 f8 1f             	sar    $0x1f,%eax
  800fa6:	29 c2                	sub    %eax,%edx
  800fa8:	89 d0                	mov    %edx,%eax
  800faa:	c1 e0 02             	shl    $0x2,%eax
  800fad:	01 d0                	add    %edx,%eax
  800faf:	01 c0                	add    %eax,%eax
  800fb1:	29 c1                	sub    %eax,%ecx
  800fb3:	89 ca                	mov    %ecx,%edx
  800fb5:	85 d2                	test   %edx,%edx
  800fb7:	75 9c                	jne    800f55 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800fb9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800fc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc3:	48                   	dec    %eax
  800fc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800fc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fcb:	74 3d                	je     80100a <ltostr+0xe2>
		start = 1 ;
  800fcd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fd4:	eb 34                	jmp    80100a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	01 d0                	add    %edx,%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fe3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	01 c2                	add    %eax,%edx
  800feb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	01 c8                	add    %ecx,%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ff7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	01 c2                	add    %eax,%edx
  800fff:	8a 45 eb             	mov    -0x15(%ebp),%al
  801002:	88 02                	mov    %al,(%edx)
		start++ ;
  801004:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801007:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80100a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801010:	7c c4                	jl     800fd6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801012:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	01 d0                	add    %edx,%eax
  80101a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80101d:	90                   	nop
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801026:	ff 75 08             	pushl  0x8(%ebp)
  801029:	e8 54 fa ff ff       	call   800a82 <strlen>
  80102e:	83 c4 04             	add    $0x4,%esp
  801031:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801034:	ff 75 0c             	pushl  0xc(%ebp)
  801037:	e8 46 fa ff ff       	call   800a82 <strlen>
  80103c:	83 c4 04             	add    $0x4,%esp
  80103f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801042:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801049:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801050:	eb 17                	jmp    801069 <strcconcat+0x49>
		final[s] = str1[s] ;
  801052:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801055:	8b 45 10             	mov    0x10(%ebp),%eax
  801058:	01 c2                	add    %eax,%edx
  80105a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	01 c8                	add    %ecx,%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801066:	ff 45 fc             	incl   -0x4(%ebp)
  801069:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80106f:	7c e1                	jl     801052 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801071:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801078:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80107f:	eb 1f                	jmp    8010a0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801081:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801084:	8d 50 01             	lea    0x1(%eax),%edx
  801087:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80108a:	89 c2                	mov    %eax,%edx
  80108c:	8b 45 10             	mov    0x10(%ebp),%eax
  80108f:	01 c2                	add    %eax,%edx
  801091:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801094:	8b 45 0c             	mov    0xc(%ebp),%eax
  801097:	01 c8                	add    %ecx,%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80109d:	ff 45 f8             	incl   -0x8(%ebp)
  8010a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010a6:	7c d9                	jl     801081 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	01 d0                	add    %edx,%eax
  8010b0:	c6 00 00             	movb   $0x0,(%eax)
}
  8010b3:	90                   	nop
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c5:	8b 00                	mov    (%eax),%eax
  8010c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d1:	01 d0                	add    %edx,%eax
  8010d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010d9:	eb 0c                	jmp    8010e7 <strsplit+0x31>
			*string++ = 0;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	8d 50 01             	lea    0x1(%eax),%edx
  8010e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	84 c0                	test   %al,%al
  8010ee:	74 18                	je     801108 <strsplit+0x52>
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	0f be c0             	movsbl %al,%eax
  8010f8:	50                   	push   %eax
  8010f9:	ff 75 0c             	pushl  0xc(%ebp)
  8010fc:	e8 13 fb ff ff       	call   800c14 <strchr>
  801101:	83 c4 08             	add    $0x8,%esp
  801104:	85 c0                	test   %eax,%eax
  801106:	75 d3                	jne    8010db <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	84 c0                	test   %al,%al
  80110f:	74 5a                	je     80116b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801111:	8b 45 14             	mov    0x14(%ebp),%eax
  801114:	8b 00                	mov    (%eax),%eax
  801116:	83 f8 0f             	cmp    $0xf,%eax
  801119:	75 07                	jne    801122 <strsplit+0x6c>
		{
			return 0;
  80111b:	b8 00 00 00 00       	mov    $0x0,%eax
  801120:	eb 66                	jmp    801188 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801122:	8b 45 14             	mov    0x14(%ebp),%eax
  801125:	8b 00                	mov    (%eax),%eax
  801127:	8d 48 01             	lea    0x1(%eax),%ecx
  80112a:	8b 55 14             	mov    0x14(%ebp),%edx
  80112d:	89 0a                	mov    %ecx,(%edx)
  80112f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	01 c2                	add    %eax,%edx
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801140:	eb 03                	jmp    801145 <strsplit+0x8f>
			string++;
  801142:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	84 c0                	test   %al,%al
  80114c:	74 8b                	je     8010d9 <strsplit+0x23>
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	0f be c0             	movsbl %al,%eax
  801156:	50                   	push   %eax
  801157:	ff 75 0c             	pushl  0xc(%ebp)
  80115a:	e8 b5 fa ff ff       	call   800c14 <strchr>
  80115f:	83 c4 08             	add    $0x8,%esp
  801162:	85 c0                	test   %eax,%eax
  801164:	74 dc                	je     801142 <strsplit+0x8c>
			string++;
	}
  801166:	e9 6e ff ff ff       	jmp    8010d9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80116b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80116c:	8b 45 14             	mov    0x14(%ebp),%eax
  80116f:	8b 00                	mov    (%eax),%eax
  801171:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801178:	8b 45 10             	mov    0x10(%ebp),%eax
  80117b:	01 d0                	add    %edx,%eax
  80117d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801183:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801190:	83 ec 04             	sub    $0x4,%esp
  801193:	68 d0 21 80 00       	push   $0x8021d0
  801198:	6a 19                	push   $0x19
  80119a:	68 f5 21 80 00       	push   $0x8021f5
  80119f:	e8 ea 06 00 00       	call   80188e <_panic>

008011a4 <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	83 ec 18             	sub    $0x18,%esp
  8011aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ad:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8011b0:	83 ec 04             	sub    $0x4,%esp
  8011b3:	68 04 22 80 00       	push   $0x802204
  8011b8:	6a 31                	push   $0x31
  8011ba:	68 f5 21 80 00       	push   $0x8021f5
  8011bf:	e8 ca 06 00 00       	call   80188e <_panic>

008011c4 <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8011ca:	83 ec 04             	sub    $0x4,%esp
  8011cd:	68 2c 22 80 00       	push   $0x80222c
  8011d2:	6a 4a                	push   $0x4a
  8011d4:	68 f5 21 80 00       	push   $0x8021f5
  8011d9:	e8 b0 06 00 00       	call   80188e <_panic>

008011de <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8011e4:	83 ec 04             	sub    $0x4,%esp
  8011e7:	68 50 22 80 00       	push   $0x802250
  8011ec:	6a 70                	push   $0x70
  8011ee:	68 f5 21 80 00       	push   $0x8021f5
  8011f3:	e8 96 06 00 00       	call   80188e <_panic>

008011f8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8011fe:	83 ec 04             	sub    $0x4,%esp
  801201:	68 74 22 80 00       	push   $0x802274
  801206:	68 8b 00 00 00       	push   $0x8b
  80120b:	68 f5 21 80 00       	push   $0x8021f5
  801210:	e8 79 06 00 00       	call   80188e <_panic>

00801215 <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	68 98 22 80 00       	push   $0x802298
  801223:	68 a8 00 00 00       	push   $0xa8
  801228:	68 f5 21 80 00       	push   $0x8021f5
  80122d:	e8 5c 06 00 00       	call   80188e <_panic>

00801232 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
  801235:	57                   	push   %edi
  801236:	56                   	push   %esi
  801237:	53                   	push   %ebx
  801238:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801241:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801244:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801247:	8b 7d 18             	mov    0x18(%ebp),%edi
  80124a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80124d:	cd 30                	int    $0x30
  80124f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801252:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801255:	83 c4 10             	add    $0x10,%esp
  801258:	5b                   	pop    %ebx
  801259:	5e                   	pop    %esi
  80125a:	5f                   	pop    %edi
  80125b:	5d                   	pop    %ebp
  80125c:	c3                   	ret    

0080125d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 04             	sub    $0x4,%esp
  801263:	8b 45 10             	mov    0x10(%ebp),%eax
  801266:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801269:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	6a 00                	push   $0x0
  801272:	6a 00                	push   $0x0
  801274:	52                   	push   %edx
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	50                   	push   %eax
  801279:	6a 00                	push   $0x0
  80127b:	e8 b2 ff ff ff       	call   801232 <syscall>
  801280:	83 c4 18             	add    $0x18,%esp
}
  801283:	90                   	nop
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <sys_cgetc>:

int
sys_cgetc(void)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 01                	push   $0x1
  801295:	e8 98 ff ff ff       	call   801232 <syscall>
  80129a:	83 c4 18             	add    $0x18,%esp
}
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	6a 00                	push   $0x0
  8012a7:	6a 00                	push   $0x0
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	50                   	push   %eax
  8012ae:	6a 05                	push   $0x5
  8012b0:	e8 7d ff ff ff       	call   801232 <syscall>
  8012b5:	83 c4 18             	add    $0x18,%esp
}
  8012b8:	c9                   	leave  
  8012b9:	c3                   	ret    

008012ba <sys_getenvid>:

int32 sys_getenvid(void)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	6a 02                	push   $0x2
  8012c9:	e8 64 ff ff ff       	call   801232 <syscall>
  8012ce:	83 c4 18             	add    $0x18,%esp
}
  8012d1:	c9                   	leave  
  8012d2:	c3                   	ret    

008012d3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 03                	push   $0x3
  8012e2:	e8 4b ff ff ff       	call   801232 <syscall>
  8012e7:	83 c4 18             	add    $0x18,%esp
}
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    

008012ec <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 00                	push   $0x0
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 04                	push   $0x4
  8012fb:	e8 32 ff ff ff       	call   801232 <syscall>
  801300:	83 c4 18             	add    $0x18,%esp
}
  801303:	c9                   	leave  
  801304:	c3                   	ret    

00801305 <sys_env_exit>:


void sys_env_exit(void)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801308:	6a 00                	push   $0x0
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	6a 06                	push   $0x6
  801314:	e8 19 ff ff ff       	call   801232 <syscall>
  801319:	83 c4 18             	add    $0x18,%esp
}
  80131c:	90                   	nop
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801322:	8b 55 0c             	mov    0xc(%ebp),%edx
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	52                   	push   %edx
  80132f:	50                   	push   %eax
  801330:	6a 07                	push   $0x7
  801332:	e8 fb fe ff ff       	call   801232 <syscall>
  801337:	83 c4 18             	add    $0x18,%esp
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	56                   	push   %esi
  801340:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801341:	8b 75 18             	mov    0x18(%ebp),%esi
  801344:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801347:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80134a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134d:	8b 45 08             	mov    0x8(%ebp),%eax
  801350:	56                   	push   %esi
  801351:	53                   	push   %ebx
  801352:	51                   	push   %ecx
  801353:	52                   	push   %edx
  801354:	50                   	push   %eax
  801355:	6a 08                	push   $0x8
  801357:	e8 d6 fe ff ff       	call   801232 <syscall>
  80135c:	83 c4 18             	add    $0x18,%esp
}
  80135f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801362:	5b                   	pop    %ebx
  801363:	5e                   	pop    %esi
  801364:	5d                   	pop    %ebp
  801365:	c3                   	ret    

00801366 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	52                   	push   %edx
  801376:	50                   	push   %eax
  801377:	6a 09                	push   $0x9
  801379:	e8 b4 fe ff ff       	call   801232 <syscall>
  80137e:	83 c4 18             	add    $0x18,%esp
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	ff 75 0c             	pushl  0xc(%ebp)
  80138f:	ff 75 08             	pushl  0x8(%ebp)
  801392:	6a 0a                	push   $0xa
  801394:	e8 99 fe ff ff       	call   801232 <syscall>
  801399:	83 c4 18             	add    $0x18,%esp
}
  80139c:	c9                   	leave  
  80139d:	c3                   	ret    

0080139e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 0b                	push   $0xb
  8013ad:	e8 80 fe ff ff       	call   801232 <syscall>
  8013b2:	83 c4 18             	add    $0x18,%esp
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 0c                	push   $0xc
  8013c6:	e8 67 fe ff ff       	call   801232 <syscall>
  8013cb:	83 c4 18             	add    $0x18,%esp
}
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 0d                	push   $0xd
  8013df:	e8 4e fe ff ff       	call   801232 <syscall>
  8013e4:	83 c4 18             	add    $0x18,%esp
}
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	ff 75 0c             	pushl  0xc(%ebp)
  8013f5:	ff 75 08             	pushl  0x8(%ebp)
  8013f8:	6a 11                	push   $0x11
  8013fa:	e8 33 fe ff ff       	call   801232 <syscall>
  8013ff:	83 c4 18             	add    $0x18,%esp
	return;
  801402:	90                   	nop
}
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	ff 75 0c             	pushl  0xc(%ebp)
  801411:	ff 75 08             	pushl  0x8(%ebp)
  801414:	6a 12                	push   $0x12
  801416:	e8 17 fe ff ff       	call   801232 <syscall>
  80141b:	83 c4 18             	add    $0x18,%esp
	return ;
  80141e:	90                   	nop
}
  80141f:	c9                   	leave  
  801420:	c3                   	ret    

00801421 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 0e                	push   $0xe
  801430:	e8 fd fd ff ff       	call   801232 <syscall>
  801435:	83 c4 18             	add    $0x18,%esp
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	ff 75 08             	pushl  0x8(%ebp)
  801448:	6a 0f                	push   $0xf
  80144a:	e8 e3 fd ff ff       	call   801232 <syscall>
  80144f:	83 c4 18             	add    $0x18,%esp
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 10                	push   $0x10
  801463:	e8 ca fd ff ff       	call   801232 <syscall>
  801468:	83 c4 18             	add    $0x18,%esp
}
  80146b:	90                   	nop
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 14                	push   $0x14
  80147d:	e8 b0 fd ff ff       	call   801232 <syscall>
  801482:	83 c4 18             	add    $0x18,%esp
}
  801485:	90                   	nop
  801486:	c9                   	leave  
  801487:	c3                   	ret    

00801488 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	6a 15                	push   $0x15
  801497:	e8 96 fd ff ff       	call   801232 <syscall>
  80149c:	83 c4 18             	add    $0x18,%esp
}
  80149f:	90                   	nop
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <sys_cputc>:


void
sys_cputc(const char c)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	83 ec 04             	sub    $0x4,%esp
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014ae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	50                   	push   %eax
  8014bb:	6a 16                	push   $0x16
  8014bd:	e8 70 fd ff ff       	call   801232 <syscall>
  8014c2:	83 c4 18             	add    $0x18,%esp
}
  8014c5:	90                   	nop
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 17                	push   $0x17
  8014d7:	e8 56 fd ff ff       	call   801232 <syscall>
  8014dc:	83 c4 18             	add    $0x18,%esp
}
  8014df:	90                   	nop
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    

008014e2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	ff 75 0c             	pushl  0xc(%ebp)
  8014f1:	50                   	push   %eax
  8014f2:	6a 18                	push   $0x18
  8014f4:	e8 39 fd ff ff       	call   801232 <syscall>
  8014f9:	83 c4 18             	add    $0x18,%esp
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801501:	8b 55 0c             	mov    0xc(%ebp),%edx
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	52                   	push   %edx
  80150e:	50                   	push   %eax
  80150f:	6a 1b                	push   $0x1b
  801511:	e8 1c fd ff ff       	call   801232 <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
}
  801519:	c9                   	leave  
  80151a:	c3                   	ret    

0080151b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80151e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	52                   	push   %edx
  80152b:	50                   	push   %eax
  80152c:	6a 19                	push   $0x19
  80152e:	e8 ff fc ff ff       	call   801232 <syscall>
  801533:	83 c4 18             	add    $0x18,%esp
}
  801536:	90                   	nop
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80153c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	52                   	push   %edx
  801549:	50                   	push   %eax
  80154a:	6a 1a                	push   $0x1a
  80154c:	e8 e1 fc ff ff       	call   801232 <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
}
  801554:	90                   	nop
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	83 ec 04             	sub    $0x4,%esp
  80155d:	8b 45 10             	mov    0x10(%ebp),%eax
  801560:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801563:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801566:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	6a 00                	push   $0x0
  80156f:	51                   	push   %ecx
  801570:	52                   	push   %edx
  801571:	ff 75 0c             	pushl  0xc(%ebp)
  801574:	50                   	push   %eax
  801575:	6a 1c                	push   $0x1c
  801577:	e8 b6 fc ff ff       	call   801232 <syscall>
  80157c:	83 c4 18             	add    $0x18,%esp
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801584:	8b 55 0c             	mov    0xc(%ebp),%edx
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	52                   	push   %edx
  801591:	50                   	push   %eax
  801592:	6a 1d                	push   $0x1d
  801594:	e8 99 fc ff ff       	call   801232 <syscall>
  801599:	83 c4 18             	add    $0x18,%esp
}
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	51                   	push   %ecx
  8015af:	52                   	push   %edx
  8015b0:	50                   	push   %eax
  8015b1:	6a 1e                	push   $0x1e
  8015b3:	e8 7a fc ff ff       	call   801232 <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	52                   	push   %edx
  8015cd:	50                   	push   %eax
  8015ce:	6a 1f                	push   $0x1f
  8015d0:	e8 5d fc ff ff       	call   801232 <syscall>
  8015d5:	83 c4 18             	add    $0x18,%esp
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 20                	push   $0x20
  8015e9:	e8 44 fc ff ff       	call   801232 <syscall>
  8015ee:	83 c4 18             	add    $0x18,%esp
}
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

008015f3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	ff 75 10             	pushl  0x10(%ebp)
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	50                   	push   %eax
  801604:	6a 21                	push   $0x21
  801606:	e8 27 fc ff ff       	call   801232 <syscall>
  80160b:	83 c4 18             	add    $0x18,%esp
}
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	50                   	push   %eax
  80161f:	6a 22                	push   $0x22
  801621:	e8 0c fc ff ff       	call   801232 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	90                   	nop
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	50                   	push   %eax
  80163b:	6a 23                	push   $0x23
  80163d:	e8 f0 fb ff ff       	call   801232 <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
}
  801645:	90                   	nop
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80164e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801651:	8d 50 04             	lea    0x4(%eax),%edx
  801654:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	52                   	push   %edx
  80165e:	50                   	push   %eax
  80165f:	6a 24                	push   $0x24
  801661:	e8 cc fb ff ff       	call   801232 <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
	return result;
  801669:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80166c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80166f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801672:	89 01                	mov    %eax,(%ecx)
  801674:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	c9                   	leave  
  80167b:	c2 04 00             	ret    $0x4

0080167e <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	ff 75 10             	pushl  0x10(%ebp)
  801688:	ff 75 0c             	pushl  0xc(%ebp)
  80168b:	ff 75 08             	pushl  0x8(%ebp)
  80168e:	6a 13                	push   $0x13
  801690:	e8 9d fb ff ff       	call   801232 <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
	return ;
  801698:	90                   	nop
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <sys_rcr2>:
uint32 sys_rcr2()
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 25                	push   $0x25
  8016aa:	e8 83 fb ff ff       	call   801232 <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
}
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016c0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	50                   	push   %eax
  8016cd:	6a 26                	push   $0x26
  8016cf:	e8 5e fb ff ff       	call   801232 <syscall>
  8016d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d7:	90                   	nop
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <rsttst>:
void rsttst()
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 28                	push   $0x28
  8016e9:	e8 44 fb ff ff       	call   801232 <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f1:	90                   	nop
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 04             	sub    $0x4,%esp
  8016fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801700:	8b 55 18             	mov    0x18(%ebp),%edx
  801703:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801707:	52                   	push   %edx
  801708:	50                   	push   %eax
  801709:	ff 75 10             	pushl  0x10(%ebp)
  80170c:	ff 75 0c             	pushl  0xc(%ebp)
  80170f:	ff 75 08             	pushl  0x8(%ebp)
  801712:	6a 27                	push   $0x27
  801714:	e8 19 fb ff ff       	call   801232 <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
	return ;
  80171c:	90                   	nop
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <chktst>:
void chktst(uint32 n)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	ff 75 08             	pushl  0x8(%ebp)
  80172d:	6a 29                	push   $0x29
  80172f:	e8 fe fa ff ff       	call   801232 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
	return ;
  801737:	90                   	nop
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <inctst>:

void inctst()
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 2a                	push   $0x2a
  801749:	e8 e4 fa ff ff       	call   801232 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
	return ;
  801751:	90                   	nop
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <gettst>:
uint32 gettst()
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 2b                	push   $0x2b
  801763:	e8 ca fa ff ff       	call   801232 <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 2c                	push   $0x2c
  80177f:	e8 ae fa ff ff       	call   801232 <syscall>
  801784:	83 c4 18             	add    $0x18,%esp
  801787:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80178a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80178e:	75 07                	jne    801797 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801790:	b8 01 00 00 00       	mov    $0x1,%eax
  801795:	eb 05                	jmp    80179c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801797:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 2c                	push   $0x2c
  8017b0:	e8 7d fa ff ff       	call   801232 <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
  8017b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8017bb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017bf:	75 07                	jne    8017c8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c6:	eb 05                	jmp    8017cd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 2c                	push   $0x2c
  8017e1:	e8 4c fa ff ff       	call   801232 <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
  8017e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017ec:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017f0:	75 07                	jne    8017f9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f7:	eb 05                	jmp    8017fe <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 2c                	push   $0x2c
  801812:	e8 1b fa ff ff       	call   801232 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
  80181a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80181d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801821:	75 07                	jne    80182a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801823:	b8 01 00 00 00       	mov    $0x1,%eax
  801828:	eb 05                	jmp    80182f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80182a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	ff 75 08             	pushl  0x8(%ebp)
  80183f:	6a 2d                	push   $0x2d
  801841:	e8 ec f9 ff ff       	call   801232 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
	return ;
  801849:	90                   	nop
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801850:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801853:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801856:	8b 55 0c             	mov    0xc(%ebp),%edx
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	6a 00                	push   $0x0
  80185e:	53                   	push   %ebx
  80185f:	51                   	push   %ecx
  801860:	52                   	push   %edx
  801861:	50                   	push   %eax
  801862:	6a 2e                	push   $0x2e
  801864:	e8 c9 f9 ff ff       	call   801232 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801874:	8b 55 0c             	mov    0xc(%ebp),%edx
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	52                   	push   %edx
  801881:	50                   	push   %eax
  801882:	6a 2f                	push   $0x2f
  801884:	e8 a9 f9 ff ff       	call   801232 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801894:	8d 45 10             	lea    0x10(%ebp),%eax
  801897:	83 c0 04             	add    $0x4,%eax
  80189a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80189d:	a1 18 31 80 00       	mov    0x803118,%eax
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	74 16                	je     8018bc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8018a6:	a1 18 31 80 00       	mov    0x803118,%eax
  8018ab:	83 ec 08             	sub    $0x8,%esp
  8018ae:	50                   	push   %eax
  8018af:	68 c0 22 80 00       	push   $0x8022c0
  8018b4:	e8 47 eb ff ff       	call   800400 <cprintf>
  8018b9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8018bc:	a1 00 30 80 00       	mov    0x803000,%eax
  8018c1:	ff 75 0c             	pushl  0xc(%ebp)
  8018c4:	ff 75 08             	pushl  0x8(%ebp)
  8018c7:	50                   	push   %eax
  8018c8:	68 c5 22 80 00       	push   $0x8022c5
  8018cd:	e8 2e eb ff ff       	call   800400 <cprintf>
  8018d2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8018d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d8:	83 ec 08             	sub    $0x8,%esp
  8018db:	ff 75 f4             	pushl  -0xc(%ebp)
  8018de:	50                   	push   %eax
  8018df:	e8 b1 ea ff ff       	call   800395 <vcprintf>
  8018e4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8018e7:	83 ec 08             	sub    $0x8,%esp
  8018ea:	6a 00                	push   $0x0
  8018ec:	68 e1 22 80 00       	push   $0x8022e1
  8018f1:	e8 9f ea ff ff       	call   800395 <vcprintf>
  8018f6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8018f9:	e8 20 ea ff ff       	call   80031e <exit>

	// should not return here
	while (1) ;
  8018fe:	eb fe                	jmp    8018fe <_panic+0x70>

00801900 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801906:	a1 20 30 80 00       	mov    0x803020,%eax
  80190b:	8b 50 74             	mov    0x74(%eax),%edx
  80190e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801911:	39 c2                	cmp    %eax,%edx
  801913:	74 14                	je     801929 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801915:	83 ec 04             	sub    $0x4,%esp
  801918:	68 e4 22 80 00       	push   $0x8022e4
  80191d:	6a 26                	push   $0x26
  80191f:	68 30 23 80 00       	push   $0x802330
  801924:	e8 65 ff ff ff       	call   80188e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801929:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801930:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801937:	e9 b6 00 00 00       	jmp    8019f2 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80193c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	01 d0                	add    %edx,%eax
  80194b:	8b 00                	mov    (%eax),%eax
  80194d:	85 c0                	test   %eax,%eax
  80194f:	75 08                	jne    801959 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801951:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801954:	e9 96 00 00 00       	jmp    8019ef <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  801959:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801960:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801967:	eb 5d                	jmp    8019c6 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801969:	a1 20 30 80 00       	mov    0x803020,%eax
  80196e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801974:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801977:	c1 e2 04             	shl    $0x4,%edx
  80197a:	01 d0                	add    %edx,%eax
  80197c:	8a 40 04             	mov    0x4(%eax),%al
  80197f:	84 c0                	test   %al,%al
  801981:	75 40                	jne    8019c3 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801983:	a1 20 30 80 00       	mov    0x803020,%eax
  801988:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80198e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801991:	c1 e2 04             	shl    $0x4,%edx
  801994:	01 d0                	add    %edx,%eax
  801996:	8b 00                	mov    (%eax),%eax
  801998:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80199b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80199e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019a3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8019a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	01 c8                	add    %ecx,%eax
  8019b4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019b6:	39 c2                	cmp    %eax,%edx
  8019b8:	75 09                	jne    8019c3 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8019ba:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8019c1:	eb 12                	jmp    8019d5 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019c3:	ff 45 e8             	incl   -0x18(%ebp)
  8019c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8019cb:	8b 50 74             	mov    0x74(%eax),%edx
  8019ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019d1:	39 c2                	cmp    %eax,%edx
  8019d3:	77 94                	ja     801969 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8019d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019d9:	75 14                	jne    8019ef <CheckWSWithoutLastIndex+0xef>
			panic(
  8019db:	83 ec 04             	sub    $0x4,%esp
  8019de:	68 3c 23 80 00       	push   $0x80233c
  8019e3:	6a 3a                	push   $0x3a
  8019e5:	68 30 23 80 00       	push   $0x802330
  8019ea:	e8 9f fe ff ff       	call   80188e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8019ef:	ff 45 f0             	incl   -0x10(%ebp)
  8019f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8019f8:	0f 8c 3e ff ff ff    	jl     80193c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8019fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a05:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a0c:	eb 20                	jmp    801a2e <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a0e:	a1 20 30 80 00       	mov    0x803020,%eax
  801a13:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801a19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a1c:	c1 e2 04             	shl    $0x4,%edx
  801a1f:	01 d0                	add    %edx,%eax
  801a21:	8a 40 04             	mov    0x4(%eax),%al
  801a24:	3c 01                	cmp    $0x1,%al
  801a26:	75 03                	jne    801a2b <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  801a28:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a2b:	ff 45 e0             	incl   -0x20(%ebp)
  801a2e:	a1 20 30 80 00       	mov    0x803020,%eax
  801a33:	8b 50 74             	mov    0x74(%eax),%edx
  801a36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a39:	39 c2                	cmp    %eax,%edx
  801a3b:	77 d1                	ja     801a0e <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a40:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a43:	74 14                	je     801a59 <CheckWSWithoutLastIndex+0x159>
		panic(
  801a45:	83 ec 04             	sub    $0x4,%esp
  801a48:	68 90 23 80 00       	push   $0x802390
  801a4d:	6a 44                	push   $0x44
  801a4f:	68 30 23 80 00       	push   $0x802330
  801a54:	e8 35 fe ff ff       	call   80188e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a59:	90                   	nop
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <__udivdi3>:
  801a5c:	55                   	push   %ebp
  801a5d:	57                   	push   %edi
  801a5e:	56                   	push   %esi
  801a5f:	53                   	push   %ebx
  801a60:	83 ec 1c             	sub    $0x1c,%esp
  801a63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a73:	89 ca                	mov    %ecx,%edx
  801a75:	89 f8                	mov    %edi,%eax
  801a77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a7b:	85 f6                	test   %esi,%esi
  801a7d:	75 2d                	jne    801aac <__udivdi3+0x50>
  801a7f:	39 cf                	cmp    %ecx,%edi
  801a81:	77 65                	ja     801ae8 <__udivdi3+0x8c>
  801a83:	89 fd                	mov    %edi,%ebp
  801a85:	85 ff                	test   %edi,%edi
  801a87:	75 0b                	jne    801a94 <__udivdi3+0x38>
  801a89:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8e:	31 d2                	xor    %edx,%edx
  801a90:	f7 f7                	div    %edi
  801a92:	89 c5                	mov    %eax,%ebp
  801a94:	31 d2                	xor    %edx,%edx
  801a96:	89 c8                	mov    %ecx,%eax
  801a98:	f7 f5                	div    %ebp
  801a9a:	89 c1                	mov    %eax,%ecx
  801a9c:	89 d8                	mov    %ebx,%eax
  801a9e:	f7 f5                	div    %ebp
  801aa0:	89 cf                	mov    %ecx,%edi
  801aa2:	89 fa                	mov    %edi,%edx
  801aa4:	83 c4 1c             	add    $0x1c,%esp
  801aa7:	5b                   	pop    %ebx
  801aa8:	5e                   	pop    %esi
  801aa9:	5f                   	pop    %edi
  801aaa:	5d                   	pop    %ebp
  801aab:	c3                   	ret    
  801aac:	39 ce                	cmp    %ecx,%esi
  801aae:	77 28                	ja     801ad8 <__udivdi3+0x7c>
  801ab0:	0f bd fe             	bsr    %esi,%edi
  801ab3:	83 f7 1f             	xor    $0x1f,%edi
  801ab6:	75 40                	jne    801af8 <__udivdi3+0x9c>
  801ab8:	39 ce                	cmp    %ecx,%esi
  801aba:	72 0a                	jb     801ac6 <__udivdi3+0x6a>
  801abc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ac0:	0f 87 9e 00 00 00    	ja     801b64 <__udivdi3+0x108>
  801ac6:	b8 01 00 00 00       	mov    $0x1,%eax
  801acb:	89 fa                	mov    %edi,%edx
  801acd:	83 c4 1c             	add    $0x1c,%esp
  801ad0:	5b                   	pop    %ebx
  801ad1:	5e                   	pop    %esi
  801ad2:	5f                   	pop    %edi
  801ad3:	5d                   	pop    %ebp
  801ad4:	c3                   	ret    
  801ad5:	8d 76 00             	lea    0x0(%esi),%esi
  801ad8:	31 ff                	xor    %edi,%edi
  801ada:	31 c0                	xor    %eax,%eax
  801adc:	89 fa                	mov    %edi,%edx
  801ade:	83 c4 1c             	add    $0x1c,%esp
  801ae1:	5b                   	pop    %ebx
  801ae2:	5e                   	pop    %esi
  801ae3:	5f                   	pop    %edi
  801ae4:	5d                   	pop    %ebp
  801ae5:	c3                   	ret    
  801ae6:	66 90                	xchg   %ax,%ax
  801ae8:	89 d8                	mov    %ebx,%eax
  801aea:	f7 f7                	div    %edi
  801aec:	31 ff                	xor    %edi,%edi
  801aee:	89 fa                	mov    %edi,%edx
  801af0:	83 c4 1c             	add    $0x1c,%esp
  801af3:	5b                   	pop    %ebx
  801af4:	5e                   	pop    %esi
  801af5:	5f                   	pop    %edi
  801af6:	5d                   	pop    %ebp
  801af7:	c3                   	ret    
  801af8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801afd:	89 eb                	mov    %ebp,%ebx
  801aff:	29 fb                	sub    %edi,%ebx
  801b01:	89 f9                	mov    %edi,%ecx
  801b03:	d3 e6                	shl    %cl,%esi
  801b05:	89 c5                	mov    %eax,%ebp
  801b07:	88 d9                	mov    %bl,%cl
  801b09:	d3 ed                	shr    %cl,%ebp
  801b0b:	89 e9                	mov    %ebp,%ecx
  801b0d:	09 f1                	or     %esi,%ecx
  801b0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b13:	89 f9                	mov    %edi,%ecx
  801b15:	d3 e0                	shl    %cl,%eax
  801b17:	89 c5                	mov    %eax,%ebp
  801b19:	89 d6                	mov    %edx,%esi
  801b1b:	88 d9                	mov    %bl,%cl
  801b1d:	d3 ee                	shr    %cl,%esi
  801b1f:	89 f9                	mov    %edi,%ecx
  801b21:	d3 e2                	shl    %cl,%edx
  801b23:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b27:	88 d9                	mov    %bl,%cl
  801b29:	d3 e8                	shr    %cl,%eax
  801b2b:	09 c2                	or     %eax,%edx
  801b2d:	89 d0                	mov    %edx,%eax
  801b2f:	89 f2                	mov    %esi,%edx
  801b31:	f7 74 24 0c          	divl   0xc(%esp)
  801b35:	89 d6                	mov    %edx,%esi
  801b37:	89 c3                	mov    %eax,%ebx
  801b39:	f7 e5                	mul    %ebp
  801b3b:	39 d6                	cmp    %edx,%esi
  801b3d:	72 19                	jb     801b58 <__udivdi3+0xfc>
  801b3f:	74 0b                	je     801b4c <__udivdi3+0xf0>
  801b41:	89 d8                	mov    %ebx,%eax
  801b43:	31 ff                	xor    %edi,%edi
  801b45:	e9 58 ff ff ff       	jmp    801aa2 <__udivdi3+0x46>
  801b4a:	66 90                	xchg   %ax,%ax
  801b4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b50:	89 f9                	mov    %edi,%ecx
  801b52:	d3 e2                	shl    %cl,%edx
  801b54:	39 c2                	cmp    %eax,%edx
  801b56:	73 e9                	jae    801b41 <__udivdi3+0xe5>
  801b58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b5b:	31 ff                	xor    %edi,%edi
  801b5d:	e9 40 ff ff ff       	jmp    801aa2 <__udivdi3+0x46>
  801b62:	66 90                	xchg   %ax,%ax
  801b64:	31 c0                	xor    %eax,%eax
  801b66:	e9 37 ff ff ff       	jmp    801aa2 <__udivdi3+0x46>
  801b6b:	90                   	nop

00801b6c <__umoddi3>:
  801b6c:	55                   	push   %ebp
  801b6d:	57                   	push   %edi
  801b6e:	56                   	push   %esi
  801b6f:	53                   	push   %ebx
  801b70:	83 ec 1c             	sub    $0x1c,%esp
  801b73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b77:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b8b:	89 f3                	mov    %esi,%ebx
  801b8d:	89 fa                	mov    %edi,%edx
  801b8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b93:	89 34 24             	mov    %esi,(%esp)
  801b96:	85 c0                	test   %eax,%eax
  801b98:	75 1a                	jne    801bb4 <__umoddi3+0x48>
  801b9a:	39 f7                	cmp    %esi,%edi
  801b9c:	0f 86 a2 00 00 00    	jbe    801c44 <__umoddi3+0xd8>
  801ba2:	89 c8                	mov    %ecx,%eax
  801ba4:	89 f2                	mov    %esi,%edx
  801ba6:	f7 f7                	div    %edi
  801ba8:	89 d0                	mov    %edx,%eax
  801baa:	31 d2                	xor    %edx,%edx
  801bac:	83 c4 1c             	add    $0x1c,%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	5f                   	pop    %edi
  801bb2:	5d                   	pop    %ebp
  801bb3:	c3                   	ret    
  801bb4:	39 f0                	cmp    %esi,%eax
  801bb6:	0f 87 ac 00 00 00    	ja     801c68 <__umoddi3+0xfc>
  801bbc:	0f bd e8             	bsr    %eax,%ebp
  801bbf:	83 f5 1f             	xor    $0x1f,%ebp
  801bc2:	0f 84 ac 00 00 00    	je     801c74 <__umoddi3+0x108>
  801bc8:	bf 20 00 00 00       	mov    $0x20,%edi
  801bcd:	29 ef                	sub    %ebp,%edi
  801bcf:	89 fe                	mov    %edi,%esi
  801bd1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bd5:	89 e9                	mov    %ebp,%ecx
  801bd7:	d3 e0                	shl    %cl,%eax
  801bd9:	89 d7                	mov    %edx,%edi
  801bdb:	89 f1                	mov    %esi,%ecx
  801bdd:	d3 ef                	shr    %cl,%edi
  801bdf:	09 c7                	or     %eax,%edi
  801be1:	89 e9                	mov    %ebp,%ecx
  801be3:	d3 e2                	shl    %cl,%edx
  801be5:	89 14 24             	mov    %edx,(%esp)
  801be8:	89 d8                	mov    %ebx,%eax
  801bea:	d3 e0                	shl    %cl,%eax
  801bec:	89 c2                	mov    %eax,%edx
  801bee:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bf2:	d3 e0                	shl    %cl,%eax
  801bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bfc:	89 f1                	mov    %esi,%ecx
  801bfe:	d3 e8                	shr    %cl,%eax
  801c00:	09 d0                	or     %edx,%eax
  801c02:	d3 eb                	shr    %cl,%ebx
  801c04:	89 da                	mov    %ebx,%edx
  801c06:	f7 f7                	div    %edi
  801c08:	89 d3                	mov    %edx,%ebx
  801c0a:	f7 24 24             	mull   (%esp)
  801c0d:	89 c6                	mov    %eax,%esi
  801c0f:	89 d1                	mov    %edx,%ecx
  801c11:	39 d3                	cmp    %edx,%ebx
  801c13:	0f 82 87 00 00 00    	jb     801ca0 <__umoddi3+0x134>
  801c19:	0f 84 91 00 00 00    	je     801cb0 <__umoddi3+0x144>
  801c1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c23:	29 f2                	sub    %esi,%edx
  801c25:	19 cb                	sbb    %ecx,%ebx
  801c27:	89 d8                	mov    %ebx,%eax
  801c29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c2d:	d3 e0                	shl    %cl,%eax
  801c2f:	89 e9                	mov    %ebp,%ecx
  801c31:	d3 ea                	shr    %cl,%edx
  801c33:	09 d0                	or     %edx,%eax
  801c35:	89 e9                	mov    %ebp,%ecx
  801c37:	d3 eb                	shr    %cl,%ebx
  801c39:	89 da                	mov    %ebx,%edx
  801c3b:	83 c4 1c             	add    $0x1c,%esp
  801c3e:	5b                   	pop    %ebx
  801c3f:	5e                   	pop    %esi
  801c40:	5f                   	pop    %edi
  801c41:	5d                   	pop    %ebp
  801c42:	c3                   	ret    
  801c43:	90                   	nop
  801c44:	89 fd                	mov    %edi,%ebp
  801c46:	85 ff                	test   %edi,%edi
  801c48:	75 0b                	jne    801c55 <__umoddi3+0xe9>
  801c4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4f:	31 d2                	xor    %edx,%edx
  801c51:	f7 f7                	div    %edi
  801c53:	89 c5                	mov    %eax,%ebp
  801c55:	89 f0                	mov    %esi,%eax
  801c57:	31 d2                	xor    %edx,%edx
  801c59:	f7 f5                	div    %ebp
  801c5b:	89 c8                	mov    %ecx,%eax
  801c5d:	f7 f5                	div    %ebp
  801c5f:	89 d0                	mov    %edx,%eax
  801c61:	e9 44 ff ff ff       	jmp    801baa <__umoddi3+0x3e>
  801c66:	66 90                	xchg   %ax,%ax
  801c68:	89 c8                	mov    %ecx,%eax
  801c6a:	89 f2                	mov    %esi,%edx
  801c6c:	83 c4 1c             	add    $0x1c,%esp
  801c6f:	5b                   	pop    %ebx
  801c70:	5e                   	pop    %esi
  801c71:	5f                   	pop    %edi
  801c72:	5d                   	pop    %ebp
  801c73:	c3                   	ret    
  801c74:	3b 04 24             	cmp    (%esp),%eax
  801c77:	72 06                	jb     801c7f <__umoddi3+0x113>
  801c79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c7d:	77 0f                	ja     801c8e <__umoddi3+0x122>
  801c7f:	89 f2                	mov    %esi,%edx
  801c81:	29 f9                	sub    %edi,%ecx
  801c83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c87:	89 14 24             	mov    %edx,(%esp)
  801c8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c92:	8b 14 24             	mov    (%esp),%edx
  801c95:	83 c4 1c             	add    $0x1c,%esp
  801c98:	5b                   	pop    %ebx
  801c99:	5e                   	pop    %esi
  801c9a:	5f                   	pop    %edi
  801c9b:	5d                   	pop    %ebp
  801c9c:	c3                   	ret    
  801c9d:	8d 76 00             	lea    0x0(%esi),%esi
  801ca0:	2b 04 24             	sub    (%esp),%eax
  801ca3:	19 fa                	sbb    %edi,%edx
  801ca5:	89 d1                	mov    %edx,%ecx
  801ca7:	89 c6                	mov    %eax,%esi
  801ca9:	e9 71 ff ff ff       	jmp    801c1f <__umoddi3+0xb3>
  801cae:	66 90                	xchg   %ax,%ax
  801cb0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cb4:	72 ea                	jb     801ca0 <__umoddi3+0x134>
  801cb6:	89 d9                	mov    %ebx,%ecx
  801cb8:	e9 62 ff ff ff       	jmp    801c1f <__umoddi3+0xb3>
