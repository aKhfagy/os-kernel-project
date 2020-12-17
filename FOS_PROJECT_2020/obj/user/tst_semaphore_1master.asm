
obj/user/tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 6c 01 00 00       	call   8001a2 <libmain>
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
  80003e:	e8 8a 11 00 00       	call   8011cd <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 20 1a 80 00       	push   $0x801a20
  800050:	e8 a0 13 00 00       	call   8013f5 <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 24 1a 80 00       	push   $0x801a24
  800062:	e8 8e 13 00 00       	call   8013f5 <sys_createSemaphore>
  800067:	83 c4 10             	add    $0x10,%esp

	int id1, id2, id3;
	id1 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  80006a:	a1 20 20 80 00       	mov    0x802020,%eax
  80006f:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800075:	a1 20 20 80 00       	mov    0x802020,%eax
  80007a:	8b 40 74             	mov    0x74(%eax),%eax
  80007d:	83 ec 04             	sub    $0x4,%esp
  800080:	52                   	push   %edx
  800081:	50                   	push   %eax
  800082:	68 2c 1a 80 00       	push   $0x801a2c
  800087:	e8 7a 14 00 00       	call   801506 <sys_create_env>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
  800092:	a1 20 20 80 00       	mov    0x802020,%eax
  800097:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80009d:	a1 20 20 80 00       	mov    0x802020,%eax
  8000a2:	8b 40 74             	mov    0x74(%eax),%eax
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	52                   	push   %edx
  8000a9:	50                   	push   %eax
  8000aa:	68 2c 1a 80 00       	push   $0x801a2c
  8000af:	e8 52 14 00 00       	call   801506 <sys_create_env>
  8000b4:	83 c4 10             	add    $0x10,%esp
  8000b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000ba:	a1 20 20 80 00       	mov    0x802020,%eax
  8000bf:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8000c5:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ca:	8b 40 74             	mov    0x74(%eax),%eax
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	52                   	push   %edx
  8000d1:	50                   	push   %eax
  8000d2:	68 2c 1a 80 00       	push   $0x801a2c
  8000d7:	e8 2a 14 00 00       	call   801506 <sys_create_env>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(id1);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e8:	e8 36 14 00 00       	call   801523 <sys_run_env>
  8000ed:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f6:	e8 28 14 00 00       	call   801523 <sys_run_env>
  8000fb:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 e8             	pushl  -0x18(%ebp)
  800104:	e8 1a 14 00 00       	call   801523 <sys_run_env>
  800109:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	68 24 1a 80 00       	push   $0x801a24
  800114:	ff 75 f4             	pushl  -0xc(%ebp)
  800117:	e8 12 13 00 00       	call   80142e <sys_waitSemaphore>
  80011c:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  80011f:	83 ec 08             	sub    $0x8,%esp
  800122:	68 24 1a 80 00       	push   $0x801a24
  800127:	ff 75 f4             	pushl  -0xc(%ebp)
  80012a:	e8 ff 12 00 00       	call   80142e <sys_waitSemaphore>
  80012f:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800132:	83 ec 08             	sub    $0x8,%esp
  800135:	68 24 1a 80 00       	push   $0x801a24
  80013a:	ff 75 f4             	pushl  -0xc(%ebp)
  80013d:	e8 ec 12 00 00       	call   80142e <sys_waitSemaphore>
  800142:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	68 20 1a 80 00       	push   $0x801a20
  80014d:	ff 75 f4             	pushl  -0xc(%ebp)
  800150:	e8 bc 12 00 00       	call   801411 <sys_getSemaphoreValue>
  800155:	83 c4 10             	add    $0x10,%esp
  800158:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 24 1a 80 00       	push   $0x801a24
  800163:	ff 75 f4             	pushl  -0xc(%ebp)
  800166:	e8 a6 12 00 00       	call   801411 <sys_getSemaphoreValue>
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  800171:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800175:	75 18                	jne    80018f <_main+0x157>
  800177:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  80017b:	75 12                	jne    80018f <_main+0x157>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	68 38 1a 80 00       	push   $0x801a38
  800185:	e8 31 02 00 00       	call   8003bb <cprintf>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	eb 10                	jmp    80019f <_main+0x167>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 80 1a 80 00       	push   $0x801a80
  800197:	e8 1f 02 00 00       	call   8003bb <cprintf>
  80019c:	83 c4 10             	add    $0x10,%esp

	return;
  80019f:	90                   	nop
}
  8001a0:	c9                   	leave  
  8001a1:	c3                   	ret    

008001a2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001a2:	55                   	push   %ebp
  8001a3:	89 e5                	mov    %esp,%ebp
  8001a5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001a8:	e8 39 10 00 00       	call   8011e6 <sys_getenvindex>
  8001ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001b3:	89 d0                	mov    %edx,%eax
  8001b5:	c1 e0 03             	shl    $0x3,%eax
  8001b8:	01 d0                	add    %edx,%eax
  8001ba:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001c1:	01 c8                	add    %ecx,%eax
  8001c3:	01 c0                	add    %eax,%eax
  8001c5:	01 d0                	add    %edx,%eax
  8001c7:	01 c0                	add    %eax,%eax
  8001c9:	01 d0                	add    %edx,%eax
  8001cb:	89 c2                	mov    %eax,%edx
  8001cd:	c1 e2 05             	shl    $0x5,%edx
  8001d0:	29 c2                	sub    %eax,%edx
  8001d2:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001d9:	89 c2                	mov    %eax,%edx
  8001db:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001e1:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001e6:	a1 20 20 80 00       	mov    0x802020,%eax
  8001eb:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001f1:	84 c0                	test   %al,%al
  8001f3:	74 0f                	je     800204 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001f5:	a1 20 20 80 00       	mov    0x802020,%eax
  8001fa:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001ff:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800204:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800208:	7e 0a                	jle    800214 <libmain+0x72>
		binaryname = argv[0];
  80020a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020d:	8b 00                	mov    (%eax),%eax
  80020f:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	ff 75 0c             	pushl  0xc(%ebp)
  80021a:	ff 75 08             	pushl  0x8(%ebp)
  80021d:	e8 16 fe ff ff       	call   800038 <_main>
  800222:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800225:	e8 57 11 00 00       	call   801381 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 e4 1a 80 00       	push   $0x801ae4
  800232:	e8 84 01 00 00       	call   8003bb <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80023a:	a1 20 20 80 00       	mov    0x802020,%eax
  80023f:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800245:	a1 20 20 80 00       	mov    0x802020,%eax
  80024a:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800250:	83 ec 04             	sub    $0x4,%esp
  800253:	52                   	push   %edx
  800254:	50                   	push   %eax
  800255:	68 0c 1b 80 00       	push   $0x801b0c
  80025a:	e8 5c 01 00 00       	call   8003bb <cprintf>
  80025f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800262:	a1 20 20 80 00       	mov    0x802020,%eax
  800267:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80026d:	a1 20 20 80 00       	mov    0x802020,%eax
  800272:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	52                   	push   %edx
  80027c:	50                   	push   %eax
  80027d:	68 34 1b 80 00       	push   $0x801b34
  800282:	e8 34 01 00 00       	call   8003bb <cprintf>
  800287:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028a:	a1 20 20 80 00       	mov    0x802020,%eax
  80028f:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800295:	83 ec 08             	sub    $0x8,%esp
  800298:	50                   	push   %eax
  800299:	68 75 1b 80 00       	push   $0x801b75
  80029e:	e8 18 01 00 00       	call   8003bb <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a6:	83 ec 0c             	sub    $0xc,%esp
  8002a9:	68 e4 1a 80 00       	push   $0x801ae4
  8002ae:	e8 08 01 00 00       	call   8003bb <cprintf>
  8002b3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b6:	e8 e0 10 00 00       	call   80139b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002bb:	e8 19 00 00 00       	call   8002d9 <exit>
}
  8002c0:	90                   	nop
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8002c9:	83 ec 0c             	sub    $0xc,%esp
  8002cc:	6a 00                	push   $0x0
  8002ce:	e8 df 0e 00 00       	call   8011b2 <sys_env_destroy>
  8002d3:	83 c4 10             	add    $0x10,%esp
}
  8002d6:	90                   	nop
  8002d7:	c9                   	leave  
  8002d8:	c3                   	ret    

008002d9 <exit>:

void
exit(void)
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002df:	e8 34 0f 00 00       	call   801218 <sys_env_exit>
}
  8002e4:	90                   	nop
  8002e5:	c9                   	leave  
  8002e6:	c3                   	ret    

008002e7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f0:	8b 00                	mov    (%eax),%eax
  8002f2:	8d 48 01             	lea    0x1(%eax),%ecx
  8002f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f8:	89 0a                	mov    %ecx,(%edx)
  8002fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fd:	88 d1                	mov    %dl,%cl
  8002ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800302:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800306:	8b 45 0c             	mov    0xc(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800310:	75 2c                	jne    80033e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800312:	a0 24 20 80 00       	mov    0x802024,%al
  800317:	0f b6 c0             	movzbl %al,%eax
  80031a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80031d:	8b 12                	mov    (%edx),%edx
  80031f:	89 d1                	mov    %edx,%ecx
  800321:	8b 55 0c             	mov    0xc(%ebp),%edx
  800324:	83 c2 08             	add    $0x8,%edx
  800327:	83 ec 04             	sub    $0x4,%esp
  80032a:	50                   	push   %eax
  80032b:	51                   	push   %ecx
  80032c:	52                   	push   %edx
  80032d:	e8 3e 0e 00 00       	call   801170 <sys_cputs>
  800332:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80033e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800341:	8b 40 04             	mov    0x4(%eax),%eax
  800344:	8d 50 01             	lea    0x1(%eax),%edx
  800347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80034d:	90                   	nop
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800359:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800360:	00 00 00 
	b.cnt = 0;
  800363:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80036a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80036d:	ff 75 0c             	pushl  0xc(%ebp)
  800370:	ff 75 08             	pushl  0x8(%ebp)
  800373:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800379:	50                   	push   %eax
  80037a:	68 e7 02 80 00       	push   $0x8002e7
  80037f:	e8 11 02 00 00       	call   800595 <vprintfmt>
  800384:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800387:	a0 24 20 80 00       	mov    0x802024,%al
  80038c:	0f b6 c0             	movzbl %al,%eax
  80038f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800395:	83 ec 04             	sub    $0x4,%esp
  800398:	50                   	push   %eax
  800399:	52                   	push   %edx
  80039a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003a0:	83 c0 08             	add    $0x8,%eax
  8003a3:	50                   	push   %eax
  8003a4:	e8 c7 0d 00 00       	call   801170 <sys_cputs>
  8003a9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003ac:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8003b3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003b9:	c9                   	leave  
  8003ba:	c3                   	ret    

008003bb <cprintf>:

int cprintf(const char *fmt, ...) {
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
  8003be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003c1:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8003c8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	83 ec 08             	sub    $0x8,%esp
  8003d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d7:	50                   	push   %eax
  8003d8:	e8 73 ff ff ff       	call   800350 <vcprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
  8003e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003e6:	c9                   	leave  
  8003e7:	c3                   	ret    

008003e8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
  8003eb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003ee:	e8 8e 0f 00 00       	call   801381 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003f3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800402:	50                   	push   %eax
  800403:	e8 48 ff ff ff       	call   800350 <vcprintf>
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80040e:	e8 88 0f 00 00       	call   80139b <sys_enable_interrupt>
	return cnt;
  800413:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800416:	c9                   	leave  
  800417:	c3                   	ret    

00800418 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
  80041b:	53                   	push   %ebx
  80041c:	83 ec 14             	sub    $0x14,%esp
  80041f:	8b 45 10             	mov    0x10(%ebp),%eax
  800422:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800425:	8b 45 14             	mov    0x14(%ebp),%eax
  800428:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80042b:	8b 45 18             	mov    0x18(%ebp),%eax
  80042e:	ba 00 00 00 00       	mov    $0x0,%edx
  800433:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800436:	77 55                	ja     80048d <printnum+0x75>
  800438:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80043b:	72 05                	jb     800442 <printnum+0x2a>
  80043d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800440:	77 4b                	ja     80048d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800442:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800445:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800448:	8b 45 18             	mov    0x18(%ebp),%eax
  80044b:	ba 00 00 00 00       	mov    $0x0,%edx
  800450:	52                   	push   %edx
  800451:	50                   	push   %eax
  800452:	ff 75 f4             	pushl  -0xc(%ebp)
  800455:	ff 75 f0             	pushl  -0x10(%ebp)
  800458:	e8 47 13 00 00       	call   8017a4 <__udivdi3>
  80045d:	83 c4 10             	add    $0x10,%esp
  800460:	83 ec 04             	sub    $0x4,%esp
  800463:	ff 75 20             	pushl  0x20(%ebp)
  800466:	53                   	push   %ebx
  800467:	ff 75 18             	pushl  0x18(%ebp)
  80046a:	52                   	push   %edx
  80046b:	50                   	push   %eax
  80046c:	ff 75 0c             	pushl  0xc(%ebp)
  80046f:	ff 75 08             	pushl  0x8(%ebp)
  800472:	e8 a1 ff ff ff       	call   800418 <printnum>
  800477:	83 c4 20             	add    $0x20,%esp
  80047a:	eb 1a                	jmp    800496 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	ff 75 0c             	pushl  0xc(%ebp)
  800482:	ff 75 20             	pushl  0x20(%ebp)
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	ff d0                	call   *%eax
  80048a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80048d:	ff 4d 1c             	decl   0x1c(%ebp)
  800490:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800494:	7f e6                	jg     80047c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800496:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800499:	bb 00 00 00 00       	mov    $0x0,%ebx
  80049e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004a4:	53                   	push   %ebx
  8004a5:	51                   	push   %ecx
  8004a6:	52                   	push   %edx
  8004a7:	50                   	push   %eax
  8004a8:	e8 07 14 00 00       	call   8018b4 <__umoddi3>
  8004ad:	83 c4 10             	add    $0x10,%esp
  8004b0:	05 b4 1d 80 00       	add    $0x801db4,%eax
  8004b5:	8a 00                	mov    (%eax),%al
  8004b7:	0f be c0             	movsbl %al,%eax
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	ff 75 0c             	pushl  0xc(%ebp)
  8004c0:	50                   	push   %eax
  8004c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c4:	ff d0                	call   *%eax
  8004c6:	83 c4 10             	add    $0x10,%esp
}
  8004c9:	90                   	nop
  8004ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004cd:	c9                   	leave  
  8004ce:	c3                   	ret    

008004cf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004d6:	7e 1c                	jle    8004f4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 50 08             	lea    0x8(%eax),%edx
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	89 10                	mov    %edx,(%eax)
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	83 e8 08             	sub    $0x8,%eax
  8004ed:	8b 50 04             	mov    0x4(%eax),%edx
  8004f0:	8b 00                	mov    (%eax),%eax
  8004f2:	eb 40                	jmp    800534 <getuint+0x65>
	else if (lflag)
  8004f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f8:	74 1e                	je     800518 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fd:	8b 00                	mov    (%eax),%eax
  8004ff:	8d 50 04             	lea    0x4(%eax),%edx
  800502:	8b 45 08             	mov    0x8(%ebp),%eax
  800505:	89 10                	mov    %edx,(%eax)
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	8b 00                	mov    (%eax),%eax
  80050c:	83 e8 04             	sub    $0x4,%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	ba 00 00 00 00       	mov    $0x0,%edx
  800516:	eb 1c                	jmp    800534 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800518:	8b 45 08             	mov    0x8(%ebp),%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	8d 50 04             	lea    0x4(%eax),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	89 10                	mov    %edx,(%eax)
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	83 e8 04             	sub    $0x4,%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800534:	5d                   	pop    %ebp
  800535:	c3                   	ret    

00800536 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800539:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80053d:	7e 1c                	jle    80055b <getint+0x25>
		return va_arg(*ap, long long);
  80053f:	8b 45 08             	mov    0x8(%ebp),%eax
  800542:	8b 00                	mov    (%eax),%eax
  800544:	8d 50 08             	lea    0x8(%eax),%edx
  800547:	8b 45 08             	mov    0x8(%ebp),%eax
  80054a:	89 10                	mov    %edx,(%eax)
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	83 e8 08             	sub    $0x8,%eax
  800554:	8b 50 04             	mov    0x4(%eax),%edx
  800557:	8b 00                	mov    (%eax),%eax
  800559:	eb 38                	jmp    800593 <getint+0x5d>
	else if (lflag)
  80055b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80055f:	74 1a                	je     80057b <getint+0x45>
		return va_arg(*ap, long);
  800561:	8b 45 08             	mov    0x8(%ebp),%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	8d 50 04             	lea    0x4(%eax),%edx
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	89 10                	mov    %edx,(%eax)
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	83 e8 04             	sub    $0x4,%eax
  800576:	8b 00                	mov    (%eax),%eax
  800578:	99                   	cltd   
  800579:	eb 18                	jmp    800593 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80057b:	8b 45 08             	mov    0x8(%ebp),%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	8d 50 04             	lea    0x4(%eax),%edx
  800583:	8b 45 08             	mov    0x8(%ebp),%eax
  800586:	89 10                	mov    %edx,(%eax)
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	8b 00                	mov    (%eax),%eax
  80058d:	83 e8 04             	sub    $0x4,%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	99                   	cltd   
}
  800593:	5d                   	pop    %ebp
  800594:	c3                   	ret    

00800595 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800595:	55                   	push   %ebp
  800596:	89 e5                	mov    %esp,%ebp
  800598:	56                   	push   %esi
  800599:	53                   	push   %ebx
  80059a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80059d:	eb 17                	jmp    8005b6 <vprintfmt+0x21>
			if (ch == '\0')
  80059f:	85 db                	test   %ebx,%ebx
  8005a1:	0f 84 af 03 00 00    	je     800956 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	ff 75 0c             	pushl  0xc(%ebp)
  8005ad:	53                   	push   %ebx
  8005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b1:	ff d0                	call   *%eax
  8005b3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b9:	8d 50 01             	lea    0x1(%eax),%edx
  8005bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8005bf:	8a 00                	mov    (%eax),%al
  8005c1:	0f b6 d8             	movzbl %al,%ebx
  8005c4:	83 fb 25             	cmp    $0x25,%ebx
  8005c7:	75 d6                	jne    80059f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005c9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005cd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005e2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ec:	8d 50 01             	lea    0x1(%eax),%edx
  8005ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8005f2:	8a 00                	mov    (%eax),%al
  8005f4:	0f b6 d8             	movzbl %al,%ebx
  8005f7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005fa:	83 f8 55             	cmp    $0x55,%eax
  8005fd:	0f 87 2b 03 00 00    	ja     80092e <vprintfmt+0x399>
  800603:	8b 04 85 d8 1d 80 00 	mov    0x801dd8(,%eax,4),%eax
  80060a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80060c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800610:	eb d7                	jmp    8005e9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800612:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800616:	eb d1                	jmp    8005e9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800618:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80061f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800622:	89 d0                	mov    %edx,%eax
  800624:	c1 e0 02             	shl    $0x2,%eax
  800627:	01 d0                	add    %edx,%eax
  800629:	01 c0                	add    %eax,%eax
  80062b:	01 d8                	add    %ebx,%eax
  80062d:	83 e8 30             	sub    $0x30,%eax
  800630:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800633:	8b 45 10             	mov    0x10(%ebp),%eax
  800636:	8a 00                	mov    (%eax),%al
  800638:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80063b:	83 fb 2f             	cmp    $0x2f,%ebx
  80063e:	7e 3e                	jle    80067e <vprintfmt+0xe9>
  800640:	83 fb 39             	cmp    $0x39,%ebx
  800643:	7f 39                	jg     80067e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800645:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800648:	eb d5                	jmp    80061f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	83 c0 04             	add    $0x4,%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	83 e8 04             	sub    $0x4,%eax
  800659:	8b 00                	mov    (%eax),%eax
  80065b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80065e:	eb 1f                	jmp    80067f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800660:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800664:	79 83                	jns    8005e9 <vprintfmt+0x54>
				width = 0;
  800666:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80066d:	e9 77 ff ff ff       	jmp    8005e9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800672:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800679:	e9 6b ff ff ff       	jmp    8005e9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80067e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80067f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800683:	0f 89 60 ff ff ff    	jns    8005e9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800689:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80068f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800696:	e9 4e ff ff ff       	jmp    8005e9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80069b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80069e:	e9 46 ff ff ff       	jmp    8005e9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	83 c0 04             	add    $0x4,%eax
  8006a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	83 e8 04             	sub    $0x4,%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ba:	50                   	push   %eax
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	ff d0                	call   *%eax
  8006c0:	83 c4 10             	add    $0x10,%esp
			break;
  8006c3:	e9 89 02 00 00       	jmp    800951 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	83 c0 04             	add    $0x4,%eax
  8006ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	83 e8 04             	sub    $0x4,%eax
  8006d7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006d9:	85 db                	test   %ebx,%ebx
  8006db:	79 02                	jns    8006df <vprintfmt+0x14a>
				err = -err;
  8006dd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006df:	83 fb 64             	cmp    $0x64,%ebx
  8006e2:	7f 0b                	jg     8006ef <vprintfmt+0x15a>
  8006e4:	8b 34 9d 20 1c 80 00 	mov    0x801c20(,%ebx,4),%esi
  8006eb:	85 f6                	test   %esi,%esi
  8006ed:	75 19                	jne    800708 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006ef:	53                   	push   %ebx
  8006f0:	68 c5 1d 80 00       	push   $0x801dc5
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	ff 75 08             	pushl  0x8(%ebp)
  8006fb:	e8 5e 02 00 00       	call   80095e <printfmt>
  800700:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800703:	e9 49 02 00 00       	jmp    800951 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800708:	56                   	push   %esi
  800709:	68 ce 1d 80 00       	push   $0x801dce
  80070e:	ff 75 0c             	pushl  0xc(%ebp)
  800711:	ff 75 08             	pushl  0x8(%ebp)
  800714:	e8 45 02 00 00       	call   80095e <printfmt>
  800719:	83 c4 10             	add    $0x10,%esp
			break;
  80071c:	e9 30 02 00 00       	jmp    800951 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	83 c0 04             	add    $0x4,%eax
  800727:	89 45 14             	mov    %eax,0x14(%ebp)
  80072a:	8b 45 14             	mov    0x14(%ebp),%eax
  80072d:	83 e8 04             	sub    $0x4,%eax
  800730:	8b 30                	mov    (%eax),%esi
  800732:	85 f6                	test   %esi,%esi
  800734:	75 05                	jne    80073b <vprintfmt+0x1a6>
				p = "(null)";
  800736:	be d1 1d 80 00       	mov    $0x801dd1,%esi
			if (width > 0 && padc != '-')
  80073b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073f:	7e 6d                	jle    8007ae <vprintfmt+0x219>
  800741:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800745:	74 67                	je     8007ae <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800747:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	50                   	push   %eax
  80074e:	56                   	push   %esi
  80074f:	e8 0c 03 00 00       	call   800a60 <strnlen>
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80075a:	eb 16                	jmp    800772 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80075c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	ff 75 0c             	pushl  0xc(%ebp)
  800766:	50                   	push   %eax
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	ff d0                	call   *%eax
  80076c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80076f:	ff 4d e4             	decl   -0x1c(%ebp)
  800772:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800776:	7f e4                	jg     80075c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800778:	eb 34                	jmp    8007ae <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80077a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80077e:	74 1c                	je     80079c <vprintfmt+0x207>
  800780:	83 fb 1f             	cmp    $0x1f,%ebx
  800783:	7e 05                	jle    80078a <vprintfmt+0x1f5>
  800785:	83 fb 7e             	cmp    $0x7e,%ebx
  800788:	7e 12                	jle    80079c <vprintfmt+0x207>
					putch('?', putdat);
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	ff 75 0c             	pushl  0xc(%ebp)
  800790:	6a 3f                	push   $0x3f
  800792:	8b 45 08             	mov    0x8(%ebp),%eax
  800795:	ff d0                	call   *%eax
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	eb 0f                	jmp    8007ab <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	53                   	push   %ebx
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	ff d0                	call   *%eax
  8007a8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ab:	ff 4d e4             	decl   -0x1c(%ebp)
  8007ae:	89 f0                	mov    %esi,%eax
  8007b0:	8d 70 01             	lea    0x1(%eax),%esi
  8007b3:	8a 00                	mov    (%eax),%al
  8007b5:	0f be d8             	movsbl %al,%ebx
  8007b8:	85 db                	test   %ebx,%ebx
  8007ba:	74 24                	je     8007e0 <vprintfmt+0x24b>
  8007bc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007c0:	78 b8                	js     80077a <vprintfmt+0x1e5>
  8007c2:	ff 4d e0             	decl   -0x20(%ebp)
  8007c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007c9:	79 af                	jns    80077a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007cb:	eb 13                	jmp    8007e0 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	6a 20                	push   $0x20
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	ff d0                	call   *%eax
  8007da:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007dd:	ff 4d e4             	decl   -0x1c(%ebp)
  8007e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e4:	7f e7                	jg     8007cd <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007e6:	e9 66 01 00 00       	jmp    800951 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8007f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f4:	50                   	push   %eax
  8007f5:	e8 3c fd ff ff       	call   800536 <getint>
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800800:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800806:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800809:	85 d2                	test   %edx,%edx
  80080b:	79 23                	jns    800830 <vprintfmt+0x29b>
				putch('-', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	6a 2d                	push   $0x2d
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80081d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800820:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800823:	f7 d8                	neg    %eax
  800825:	83 d2 00             	adc    $0x0,%edx
  800828:	f7 da                	neg    %edx
  80082a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800830:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800837:	e9 bc 00 00 00       	jmp    8008f8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 e8             	pushl  -0x18(%ebp)
  800842:	8d 45 14             	lea    0x14(%ebp),%eax
  800845:	50                   	push   %eax
  800846:	e8 84 fc ff ff       	call   8004cf <getuint>
  80084b:	83 c4 10             	add    $0x10,%esp
  80084e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800851:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800854:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80085b:	e9 98 00 00 00       	jmp    8008f8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800860:	83 ec 08             	sub    $0x8,%esp
  800863:	ff 75 0c             	pushl  0xc(%ebp)
  800866:	6a 58                	push   $0x58
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	ff d0                	call   *%eax
  80086d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	6a 58                	push   $0x58
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	ff d0                	call   *%eax
  80087d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800880:	83 ec 08             	sub    $0x8,%esp
  800883:	ff 75 0c             	pushl  0xc(%ebp)
  800886:	6a 58                	push   $0x58
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	ff d0                	call   *%eax
  80088d:	83 c4 10             	add    $0x10,%esp
			break;
  800890:	e9 bc 00 00 00       	jmp    800951 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	ff 75 0c             	pushl  0xc(%ebp)
  80089b:	6a 30                	push   $0x30
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	ff d0                	call   *%eax
  8008a2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	6a 78                	push   $0x78
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	ff d0                	call   *%eax
  8008b2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	83 c0 04             	add    $0x4,%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008be:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c1:	83 e8 04             	sub    $0x4,%eax
  8008c4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008d0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008d7:	eb 1f                	jmp    8008f8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008d9:	83 ec 08             	sub    $0x8,%esp
  8008dc:	ff 75 e8             	pushl  -0x18(%ebp)
  8008df:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e2:	50                   	push   %eax
  8008e3:	e8 e7 fb ff ff       	call   8004cf <getuint>
  8008e8:	83 c4 10             	add    $0x10,%esp
  8008eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008f1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008f8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ff:	83 ec 04             	sub    $0x4,%esp
  800902:	52                   	push   %edx
  800903:	ff 75 e4             	pushl  -0x1c(%ebp)
  800906:	50                   	push   %eax
  800907:	ff 75 f4             	pushl  -0xc(%ebp)
  80090a:	ff 75 f0             	pushl  -0x10(%ebp)
  80090d:	ff 75 0c             	pushl  0xc(%ebp)
  800910:	ff 75 08             	pushl  0x8(%ebp)
  800913:	e8 00 fb ff ff       	call   800418 <printnum>
  800918:	83 c4 20             	add    $0x20,%esp
			break;
  80091b:	eb 34                	jmp    800951 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80091d:	83 ec 08             	sub    $0x8,%esp
  800920:	ff 75 0c             	pushl  0xc(%ebp)
  800923:	53                   	push   %ebx
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	ff d0                	call   *%eax
  800929:	83 c4 10             	add    $0x10,%esp
			break;
  80092c:	eb 23                	jmp    800951 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	ff 75 0c             	pushl  0xc(%ebp)
  800934:	6a 25                	push   $0x25
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	ff d0                	call   *%eax
  80093b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80093e:	ff 4d 10             	decl   0x10(%ebp)
  800941:	eb 03                	jmp    800946 <vprintfmt+0x3b1>
  800943:	ff 4d 10             	decl   0x10(%ebp)
  800946:	8b 45 10             	mov    0x10(%ebp),%eax
  800949:	48                   	dec    %eax
  80094a:	8a 00                	mov    (%eax),%al
  80094c:	3c 25                	cmp    $0x25,%al
  80094e:	75 f3                	jne    800943 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800950:	90                   	nop
		}
	}
  800951:	e9 47 fc ff ff       	jmp    80059d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800956:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800957:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80095a:	5b                   	pop    %ebx
  80095b:	5e                   	pop    %esi
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    

0080095e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800964:	8d 45 10             	lea    0x10(%ebp),%eax
  800967:	83 c0 04             	add    $0x4,%eax
  80096a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80096d:	8b 45 10             	mov    0x10(%ebp),%eax
  800970:	ff 75 f4             	pushl  -0xc(%ebp)
  800973:	50                   	push   %eax
  800974:	ff 75 0c             	pushl  0xc(%ebp)
  800977:	ff 75 08             	pushl  0x8(%ebp)
  80097a:	e8 16 fc ff ff       	call   800595 <vprintfmt>
  80097f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800982:	90                   	nop
  800983:	c9                   	leave  
  800984:	c3                   	ret    

00800985 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098b:	8b 40 08             	mov    0x8(%eax),%eax
  80098e:	8d 50 01             	lea    0x1(%eax),%edx
  800991:	8b 45 0c             	mov    0xc(%ebp),%eax
  800994:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800997:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099a:	8b 10                	mov    (%eax),%edx
  80099c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099f:	8b 40 04             	mov    0x4(%eax),%eax
  8009a2:	39 c2                	cmp    %eax,%edx
  8009a4:	73 12                	jae    8009b8 <sprintputch+0x33>
		*b->buf++ = ch;
  8009a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a9:	8b 00                	mov    (%eax),%eax
  8009ab:	8d 48 01             	lea    0x1(%eax),%ecx
  8009ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b1:	89 0a                	mov    %ecx,(%edx)
  8009b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b6:	88 10                	mov    %dl,(%eax)
}
  8009b8:	90                   	nop
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	01 d0                	add    %edx,%eax
  8009d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009e0:	74 06                	je     8009e8 <vsnprintf+0x2d>
  8009e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009e6:	7f 07                	jg     8009ef <vsnprintf+0x34>
		return -E_INVAL;
  8009e8:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ed:	eb 20                	jmp    800a0f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ef:	ff 75 14             	pushl  0x14(%ebp)
  8009f2:	ff 75 10             	pushl  0x10(%ebp)
  8009f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009f8:	50                   	push   %eax
  8009f9:	68 85 09 80 00       	push   $0x800985
  8009fe:	e8 92 fb ff ff       	call   800595 <vprintfmt>
  800a03:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a09:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a0f:	c9                   	leave  
  800a10:	c3                   	ret    

00800a11 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a17:	8d 45 10             	lea    0x10(%ebp),%eax
  800a1a:	83 c0 04             	add    $0x4,%eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a20:	8b 45 10             	mov    0x10(%ebp),%eax
  800a23:	ff 75 f4             	pushl  -0xc(%ebp)
  800a26:	50                   	push   %eax
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	ff 75 08             	pushl  0x8(%ebp)
  800a2d:	e8 89 ff ff ff       	call   8009bb <vsnprintf>
  800a32:	83 c4 10             	add    $0x10,%esp
  800a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a3b:	c9                   	leave  
  800a3c:	c3                   	ret    

00800a3d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a4a:	eb 06                	jmp    800a52 <strlen+0x15>
		n++;
  800a4c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a4f:	ff 45 08             	incl   0x8(%ebp)
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8a 00                	mov    (%eax),%al
  800a57:	84 c0                	test   %al,%al
  800a59:	75 f1                	jne    800a4c <strlen+0xf>
		n++;
	return n;
  800a5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a5e:	c9                   	leave  
  800a5f:	c3                   	ret    

00800a60 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a6d:	eb 09                	jmp    800a78 <strnlen+0x18>
		n++;
  800a6f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a72:	ff 45 08             	incl   0x8(%ebp)
  800a75:	ff 4d 0c             	decl   0xc(%ebp)
  800a78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a7c:	74 09                	je     800a87 <strnlen+0x27>
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	8a 00                	mov    (%eax),%al
  800a83:	84 c0                	test   %al,%al
  800a85:	75 e8                	jne    800a6f <strnlen+0xf>
		n++;
	return n;
  800a87:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a8a:	c9                   	leave  
  800a8b:	c3                   	ret    

00800a8c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a98:	90                   	nop
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8d 50 01             	lea    0x1(%eax),%edx
  800a9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aa8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aab:	8a 12                	mov    (%edx),%dl
  800aad:	88 10                	mov    %dl,(%eax)
  800aaf:	8a 00                	mov    (%eax),%al
  800ab1:	84 c0                	test   %al,%al
  800ab3:	75 e4                	jne    800a99 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ab8:	c9                   	leave  
  800ab9:	c3                   	ret    

00800aba <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ac6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800acd:	eb 1f                	jmp    800aee <strncpy+0x34>
		*dst++ = *src;
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8d 50 01             	lea    0x1(%eax),%edx
  800ad5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adb:	8a 12                	mov    (%edx),%dl
  800add:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae2:	8a 00                	mov    (%eax),%al
  800ae4:	84 c0                	test   %al,%al
  800ae6:	74 03                	je     800aeb <strncpy+0x31>
			src++;
  800ae8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aeb:	ff 45 fc             	incl   -0x4(%ebp)
  800aee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800af1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800af4:	72 d9                	jb     800acf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800af6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800af9:	c9                   	leave  
  800afa:	c3                   	ret    

00800afb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b0b:	74 30                	je     800b3d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b0d:	eb 16                	jmp    800b25 <strlcpy+0x2a>
			*dst++ = *src++;
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	8d 50 01             	lea    0x1(%eax),%edx
  800b15:	89 55 08             	mov    %edx,0x8(%ebp)
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b1e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b21:	8a 12                	mov    (%edx),%dl
  800b23:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b25:	ff 4d 10             	decl   0x10(%ebp)
  800b28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b2c:	74 09                	je     800b37 <strlcpy+0x3c>
  800b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b31:	8a 00                	mov    (%eax),%al
  800b33:	84 c0                	test   %al,%al
  800b35:	75 d8                	jne    800b0f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b43:	29 c2                	sub    %eax,%edx
  800b45:	89 d0                	mov    %edx,%eax
}
  800b47:	c9                   	leave  
  800b48:	c3                   	ret    

00800b49 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b4c:	eb 06                	jmp    800b54 <strcmp+0xb>
		p++, q++;
  800b4e:	ff 45 08             	incl   0x8(%ebp)
  800b51:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	8a 00                	mov    (%eax),%al
  800b59:	84 c0                	test   %al,%al
  800b5b:	74 0e                	je     800b6b <strcmp+0x22>
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	8a 10                	mov    (%eax),%dl
  800b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b65:	8a 00                	mov    (%eax),%al
  800b67:	38 c2                	cmp    %al,%dl
  800b69:	74 e3                	je     800b4e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8a 00                	mov    (%eax),%al
  800b70:	0f b6 d0             	movzbl %al,%edx
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	8a 00                	mov    (%eax),%al
  800b78:	0f b6 c0             	movzbl %al,%eax
  800b7b:	29 c2                	sub    %eax,%edx
  800b7d:	89 d0                	mov    %edx,%eax
}
  800b7f:	5d                   	pop    %ebp
  800b80:	c3                   	ret    

00800b81 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b84:	eb 09                	jmp    800b8f <strncmp+0xe>
		n--, p++, q++;
  800b86:	ff 4d 10             	decl   0x10(%ebp)
  800b89:	ff 45 08             	incl   0x8(%ebp)
  800b8c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b93:	74 17                	je     800bac <strncmp+0x2b>
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	8a 00                	mov    (%eax),%al
  800b9a:	84 c0                	test   %al,%al
  800b9c:	74 0e                	je     800bac <strncmp+0x2b>
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8a 10                	mov    (%eax),%dl
  800ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba6:	8a 00                	mov    (%eax),%al
  800ba8:	38 c2                	cmp    %al,%dl
  800baa:	74 da                	je     800b86 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800bac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bb0:	75 07                	jne    800bb9 <strncmp+0x38>
		return 0;
  800bb2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb7:	eb 14                	jmp    800bcd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8a 00                	mov    (%eax),%al
  800bbe:	0f b6 d0             	movzbl %al,%edx
  800bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc4:	8a 00                	mov    (%eax),%al
  800bc6:	0f b6 c0             	movzbl %al,%eax
  800bc9:	29 c2                	sub    %eax,%edx
  800bcb:	89 d0                	mov    %edx,%eax
}
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    

00800bcf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	83 ec 04             	sub    $0x4,%esp
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bdb:	eb 12                	jmp    800bef <strchr+0x20>
		if (*s == c)
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800be5:	75 05                	jne    800bec <strchr+0x1d>
			return (char *) s;
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	eb 11                	jmp    800bfd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bec:	ff 45 08             	incl   0x8(%ebp)
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8a 00                	mov    (%eax),%al
  800bf4:	84 c0                	test   %al,%al
  800bf6:	75 e5                	jne    800bdd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bfd:	c9                   	leave  
  800bfe:	c3                   	ret    

00800bff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	83 ec 04             	sub    $0x4,%esp
  800c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c08:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c0b:	eb 0d                	jmp    800c1a <strfind+0x1b>
		if (*s == c)
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c15:	74 0e                	je     800c25 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c17:	ff 45 08             	incl   0x8(%ebp)
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	8a 00                	mov    (%eax),%al
  800c1f:	84 c0                	test   %al,%al
  800c21:	75 ea                	jne    800c0d <strfind+0xe>
  800c23:	eb 01                	jmp    800c26 <strfind+0x27>
		if (*s == c)
			break;
  800c25:	90                   	nop
	return (char *) s;
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c29:	c9                   	leave  
  800c2a:	c3                   	ret    

00800c2b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c37:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c3d:	eb 0e                	jmp    800c4d <memset+0x22>
		*p++ = c;
  800c3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c42:	8d 50 01             	lea    0x1(%eax),%edx
  800c45:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c4d:	ff 4d f8             	decl   -0x8(%ebp)
  800c50:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c54:	79 e9                	jns    800c3f <memset+0x14>
		*p++ = c;

	return v;
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c59:	c9                   	leave  
  800c5a:	c3                   	ret    

00800c5b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c6d:	eb 16                	jmp    800c85 <memcpy+0x2a>
		*d++ = *s++;
  800c6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c72:	8d 50 01             	lea    0x1(%eax),%edx
  800c75:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c7b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c7e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c81:	8a 12                	mov    (%edx),%dl
  800c83:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c8b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c8e:	85 c0                	test   %eax,%eax
  800c90:	75 dd                	jne    800c6f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ca9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800caf:	73 50                	jae    800d01 <memmove+0x6a>
  800cb1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb7:	01 d0                	add    %edx,%eax
  800cb9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cbc:	76 43                	jbe    800d01 <memmove+0x6a>
		s += n;
  800cbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cca:	eb 10                	jmp    800cdc <memmove+0x45>
			*--d = *--s;
  800ccc:	ff 4d f8             	decl   -0x8(%ebp)
  800ccf:	ff 4d fc             	decl   -0x4(%ebp)
  800cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd5:	8a 10                	mov    (%eax),%dl
  800cd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cda:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800cdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	75 e3                	jne    800ccc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ce9:	eb 23                	jmp    800d0e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ceb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cee:	8d 50 01             	lea    0x1(%eax),%edx
  800cf1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cf4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cf7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cfa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cfd:	8a 12                	mov    (%edx),%dl
  800cff:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d01:	8b 45 10             	mov    0x10(%ebp),%eax
  800d04:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d07:	89 55 10             	mov    %edx,0x10(%ebp)
  800d0a:	85 c0                	test   %eax,%eax
  800d0c:	75 dd                	jne    800ceb <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d11:	c9                   	leave  
  800d12:	c3                   	ret    

00800d13 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d22:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d25:	eb 2a                	jmp    800d51 <memcmp+0x3e>
		if (*s1 != *s2)
  800d27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 16                	je     800d4b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	0f b6 d0             	movzbl %al,%edx
  800d3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	0f b6 c0             	movzbl %al,%eax
  800d45:	29 c2                	sub    %eax,%edx
  800d47:	89 d0                	mov    %edx,%eax
  800d49:	eb 18                	jmp    800d63 <memcmp+0x50>
		s1++, s2++;
  800d4b:	ff 45 fc             	incl   -0x4(%ebp)
  800d4e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d51:	8b 45 10             	mov    0x10(%ebp),%eax
  800d54:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d57:	89 55 10             	mov    %edx,0x10(%ebp)
  800d5a:	85 c0                	test   %eax,%eax
  800d5c:	75 c9                	jne    800d27 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d63:	c9                   	leave  
  800d64:	c3                   	ret    

00800d65 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d71:	01 d0                	add    %edx,%eax
  800d73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d76:	eb 15                	jmp    800d8d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f b6 d0             	movzbl %al,%edx
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	0f b6 c0             	movzbl %al,%eax
  800d86:	39 c2                	cmp    %eax,%edx
  800d88:	74 0d                	je     800d97 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d8a:	ff 45 08             	incl   0x8(%ebp)
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d93:	72 e3                	jb     800d78 <memfind+0x13>
  800d95:	eb 01                	jmp    800d98 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d97:	90                   	nop
	return (void *) s;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d9b:	c9                   	leave  
  800d9c:	c3                   	ret    

00800d9d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800da3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800daa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800db1:	eb 03                	jmp    800db6 <strtol+0x19>
		s++;
  800db3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	3c 20                	cmp    $0x20,%al
  800dbd:	74 f4                	je     800db3 <strtol+0x16>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3c 09                	cmp    $0x9,%al
  800dc6:	74 eb                	je     800db3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	3c 2b                	cmp    $0x2b,%al
  800dcf:	75 05                	jne    800dd6 <strtol+0x39>
		s++;
  800dd1:	ff 45 08             	incl   0x8(%ebp)
  800dd4:	eb 13                	jmp    800de9 <strtol+0x4c>
	else if (*s == '-')
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	3c 2d                	cmp    $0x2d,%al
  800ddd:	75 0a                	jne    800de9 <strtol+0x4c>
		s++, neg = 1;
  800ddf:	ff 45 08             	incl   0x8(%ebp)
  800de2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800de9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ded:	74 06                	je     800df5 <strtol+0x58>
  800def:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800df3:	75 20                	jne    800e15 <strtol+0x78>
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	3c 30                	cmp    $0x30,%al
  800dfc:	75 17                	jne    800e15 <strtol+0x78>
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	40                   	inc    %eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	3c 78                	cmp    $0x78,%al
  800e06:	75 0d                	jne    800e15 <strtol+0x78>
		s += 2, base = 16;
  800e08:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e0c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e13:	eb 28                	jmp    800e3d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e19:	75 15                	jne    800e30 <strtol+0x93>
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	3c 30                	cmp    $0x30,%al
  800e22:	75 0c                	jne    800e30 <strtol+0x93>
		s++, base = 8;
  800e24:	ff 45 08             	incl   0x8(%ebp)
  800e27:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e2e:	eb 0d                	jmp    800e3d <strtol+0xa0>
	else if (base == 0)
  800e30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e34:	75 07                	jne    800e3d <strtol+0xa0>
		base = 10;
  800e36:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	3c 2f                	cmp    $0x2f,%al
  800e44:	7e 19                	jle    800e5f <strtol+0xc2>
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	3c 39                	cmp    $0x39,%al
  800e4d:	7f 10                	jg     800e5f <strtol+0xc2>
			dig = *s - '0';
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	0f be c0             	movsbl %al,%eax
  800e57:	83 e8 30             	sub    $0x30,%eax
  800e5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e5d:	eb 42                	jmp    800ea1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	3c 60                	cmp    $0x60,%al
  800e66:	7e 19                	jle    800e81 <strtol+0xe4>
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	3c 7a                	cmp    $0x7a,%al
  800e6f:	7f 10                	jg     800e81 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	0f be c0             	movsbl %al,%eax
  800e79:	83 e8 57             	sub    $0x57,%eax
  800e7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e7f:	eb 20                	jmp    800ea1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	3c 40                	cmp    $0x40,%al
  800e88:	7e 39                	jle    800ec3 <strtol+0x126>
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	3c 5a                	cmp    $0x5a,%al
  800e91:	7f 30                	jg     800ec3 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	0f be c0             	movsbl %al,%eax
  800e9b:	83 e8 37             	sub    $0x37,%eax
  800e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ea4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ea7:	7d 19                	jge    800ec2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ea9:	ff 45 08             	incl   0x8(%ebp)
  800eac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaf:	0f af 45 10          	imul   0x10(%ebp),%eax
  800eb3:	89 c2                	mov    %eax,%edx
  800eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eb8:	01 d0                	add    %edx,%eax
  800eba:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ebd:	e9 7b ff ff ff       	jmp    800e3d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ec2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ec3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec7:	74 08                	je     800ed1 <strtol+0x134>
		*endptr = (char *) s;
  800ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ed1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ed5:	74 07                	je     800ede <strtol+0x141>
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	f7 d8                	neg    %eax
  800edc:	eb 03                	jmp    800ee1 <strtol+0x144>
  800ede:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee1:	c9                   	leave  
  800ee2:	c3                   	ret    

00800ee3 <ltostr>:

void
ltostr(long value, char *str)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ee9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800ef0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ef7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800efb:	79 13                	jns    800f10 <ltostr+0x2d>
	{
		neg = 1;
  800efd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f0a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f0d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f18:	99                   	cltd   
  800f19:	f7 f9                	idiv   %ecx
  800f1b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f21:	8d 50 01             	lea    0x1(%eax),%edx
  800f24:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f27:	89 c2                	mov    %eax,%edx
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	01 d0                	add    %edx,%eax
  800f2e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f31:	83 c2 30             	add    $0x30,%edx
  800f34:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f39:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f3e:	f7 e9                	imul   %ecx
  800f40:	c1 fa 02             	sar    $0x2,%edx
  800f43:	89 c8                	mov    %ecx,%eax
  800f45:	c1 f8 1f             	sar    $0x1f,%eax
  800f48:	29 c2                	sub    %eax,%edx
  800f4a:	89 d0                	mov    %edx,%eax
  800f4c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f52:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f57:	f7 e9                	imul   %ecx
  800f59:	c1 fa 02             	sar    $0x2,%edx
  800f5c:	89 c8                	mov    %ecx,%eax
  800f5e:	c1 f8 1f             	sar    $0x1f,%eax
  800f61:	29 c2                	sub    %eax,%edx
  800f63:	89 d0                	mov    %edx,%eax
  800f65:	c1 e0 02             	shl    $0x2,%eax
  800f68:	01 d0                	add    %edx,%eax
  800f6a:	01 c0                	add    %eax,%eax
  800f6c:	29 c1                	sub    %eax,%ecx
  800f6e:	89 ca                	mov    %ecx,%edx
  800f70:	85 d2                	test   %edx,%edx
  800f72:	75 9c                	jne    800f10 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7e:	48                   	dec    %eax
  800f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f82:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f86:	74 3d                	je     800fc5 <ltostr+0xe2>
		start = 1 ;
  800f88:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f8f:	eb 34                	jmp    800fc5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f97:	01 d0                	add    %edx,%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	01 c2                	add    %eax,%edx
  800fa6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fac:	01 c8                	add    %ecx,%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	01 c2                	add    %eax,%edx
  800fba:	8a 45 eb             	mov    -0x15(%ebp),%al
  800fbd:	88 02                	mov    %al,(%edx)
		start++ ;
  800fbf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800fc2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fc8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fcb:	7c c4                	jl     800f91 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800fcd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd3:	01 d0                	add    %edx,%eax
  800fd5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800fd8:	90                   	nop
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    

00800fdb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fe1:	ff 75 08             	pushl  0x8(%ebp)
  800fe4:	e8 54 fa ff ff       	call   800a3d <strlen>
  800fe9:	83 c4 04             	add    $0x4,%esp
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fef:	ff 75 0c             	pushl  0xc(%ebp)
  800ff2:	e8 46 fa ff ff       	call   800a3d <strlen>
  800ff7:	83 c4 04             	add    $0x4,%esp
  800ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ffd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801004:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80100b:	eb 17                	jmp    801024 <strcconcat+0x49>
		final[s] = str1[s] ;
  80100d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801010:	8b 45 10             	mov    0x10(%ebp),%eax
  801013:	01 c2                	add    %eax,%edx
  801015:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	01 c8                	add    %ecx,%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801021:	ff 45 fc             	incl   -0x4(%ebp)
  801024:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801027:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80102a:	7c e1                	jl     80100d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80102c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801033:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80103a:	eb 1f                	jmp    80105b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80103c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103f:	8d 50 01             	lea    0x1(%eax),%edx
  801042:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801045:	89 c2                	mov    %eax,%edx
  801047:	8b 45 10             	mov    0x10(%ebp),%eax
  80104a:	01 c2                	add    %eax,%edx
  80104c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80104f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801052:	01 c8                	add    %ecx,%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801058:	ff 45 f8             	incl   -0x8(%ebp)
  80105b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801061:	7c d9                	jl     80103c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801063:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801066:	8b 45 10             	mov    0x10(%ebp),%eax
  801069:	01 d0                	add    %edx,%eax
  80106b:	c6 00 00             	movb   $0x0,(%eax)
}
  80106e:	90                   	nop
  80106f:	c9                   	leave  
  801070:	c3                   	ret    

00801071 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801074:	8b 45 14             	mov    0x14(%ebp),%eax
  801077:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80107d:	8b 45 14             	mov    0x14(%ebp),%eax
  801080:	8b 00                	mov    (%eax),%eax
  801082:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801089:	8b 45 10             	mov    0x10(%ebp),%eax
  80108c:	01 d0                	add    %edx,%eax
  80108e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801094:	eb 0c                	jmp    8010a2 <strsplit+0x31>
			*string++ = 0;
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8d 50 01             	lea    0x1(%eax),%edx
  80109c:	89 55 08             	mov    %edx,0x8(%ebp)
  80109f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	8a 00                	mov    (%eax),%al
  8010a7:	84 c0                	test   %al,%al
  8010a9:	74 18                	je     8010c3 <strsplit+0x52>
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	0f be c0             	movsbl %al,%eax
  8010b3:	50                   	push   %eax
  8010b4:	ff 75 0c             	pushl  0xc(%ebp)
  8010b7:	e8 13 fb ff ff       	call   800bcf <strchr>
  8010bc:	83 c4 08             	add    $0x8,%esp
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	75 d3                	jne    801096 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	84 c0                	test   %al,%al
  8010ca:	74 5a                	je     801126 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	83 f8 0f             	cmp    $0xf,%eax
  8010d4:	75 07                	jne    8010dd <strsplit+0x6c>
		{
			return 0;
  8010d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010db:	eb 66                	jmp    801143 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e0:	8b 00                	mov    (%eax),%eax
  8010e2:	8d 48 01             	lea    0x1(%eax),%ecx
  8010e5:	8b 55 14             	mov    0x14(%ebp),%edx
  8010e8:	89 0a                	mov    %ecx,(%edx)
  8010ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	01 c2                	add    %eax,%edx
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010fb:	eb 03                	jmp    801100 <strsplit+0x8f>
			string++;
  8010fd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	84 c0                	test   %al,%al
  801107:	74 8b                	je     801094 <strsplit+0x23>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	8a 00                	mov    (%eax),%al
  80110e:	0f be c0             	movsbl %al,%eax
  801111:	50                   	push   %eax
  801112:	ff 75 0c             	pushl  0xc(%ebp)
  801115:	e8 b5 fa ff ff       	call   800bcf <strchr>
  80111a:	83 c4 08             	add    $0x8,%esp
  80111d:	85 c0                	test   %eax,%eax
  80111f:	74 dc                	je     8010fd <strsplit+0x8c>
			string++;
	}
  801121:	e9 6e ff ff ff       	jmp    801094 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801126:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801127:	8b 45 14             	mov    0x14(%ebp),%eax
  80112a:	8b 00                	mov    (%eax),%eax
  80112c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801133:	8b 45 10             	mov    0x10(%ebp),%eax
  801136:	01 d0                	add    %edx,%eax
  801138:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80113e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	57                   	push   %edi
  801149:	56                   	push   %esi
  80114a:	53                   	push   %ebx
  80114b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8b 55 0c             	mov    0xc(%ebp),%edx
  801154:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801157:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80115a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80115d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801160:	cd 30                	int    $0x30
  801162:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801165:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801168:	83 c4 10             	add    $0x10,%esp
  80116b:	5b                   	pop    %ebx
  80116c:	5e                   	pop    %esi
  80116d:	5f                   	pop    %edi
  80116e:	5d                   	pop    %ebp
  80116f:	c3                   	ret    

00801170 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	83 ec 04             	sub    $0x4,%esp
  801176:	8b 45 10             	mov    0x10(%ebp),%eax
  801179:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80117c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	6a 00                	push   $0x0
  801185:	6a 00                	push   $0x0
  801187:	52                   	push   %edx
  801188:	ff 75 0c             	pushl  0xc(%ebp)
  80118b:	50                   	push   %eax
  80118c:	6a 00                	push   $0x0
  80118e:	e8 b2 ff ff ff       	call   801145 <syscall>
  801193:	83 c4 18             	add    $0x18,%esp
}
  801196:	90                   	nop
  801197:	c9                   	leave  
  801198:	c3                   	ret    

00801199 <sys_cgetc>:

int
sys_cgetc(void)
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80119c:	6a 00                	push   $0x0
  80119e:	6a 00                	push   $0x0
  8011a0:	6a 00                	push   $0x0
  8011a2:	6a 00                	push   $0x0
  8011a4:	6a 00                	push   $0x0
  8011a6:	6a 01                	push   $0x1
  8011a8:	e8 98 ff ff ff       	call   801145 <syscall>
  8011ad:	83 c4 18             	add    $0x18,%esp
}
  8011b0:	c9                   	leave  
  8011b1:	c3                   	ret    

008011b2 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	6a 00                	push   $0x0
  8011ba:	6a 00                	push   $0x0
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 00                	push   $0x0
  8011c0:	50                   	push   %eax
  8011c1:	6a 05                	push   $0x5
  8011c3:	e8 7d ff ff ff       	call   801145 <syscall>
  8011c8:	83 c4 18             	add    $0x18,%esp
}
  8011cb:	c9                   	leave  
  8011cc:	c3                   	ret    

008011cd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8011d0:	6a 00                	push   $0x0
  8011d2:	6a 00                	push   $0x0
  8011d4:	6a 00                	push   $0x0
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 00                	push   $0x0
  8011da:	6a 02                	push   $0x2
  8011dc:	e8 64 ff ff ff       	call   801145 <syscall>
  8011e1:	83 c4 18             	add    $0x18,%esp
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    

008011e6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8011e9:	6a 00                	push   $0x0
  8011eb:	6a 00                	push   $0x0
  8011ed:	6a 00                	push   $0x0
  8011ef:	6a 00                	push   $0x0
  8011f1:	6a 00                	push   $0x0
  8011f3:	6a 03                	push   $0x3
  8011f5:	e8 4b ff ff ff       	call   801145 <syscall>
  8011fa:	83 c4 18             	add    $0x18,%esp
}
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801202:	6a 00                	push   $0x0
  801204:	6a 00                	push   $0x0
  801206:	6a 00                	push   $0x0
  801208:	6a 00                	push   $0x0
  80120a:	6a 00                	push   $0x0
  80120c:	6a 04                	push   $0x4
  80120e:	e8 32 ff ff ff       	call   801145 <syscall>
  801213:	83 c4 18             	add    $0x18,%esp
}
  801216:	c9                   	leave  
  801217:	c3                   	ret    

00801218 <sys_env_exit>:


void sys_env_exit(void)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80121b:	6a 00                	push   $0x0
  80121d:	6a 00                	push   $0x0
  80121f:	6a 00                	push   $0x0
  801221:	6a 00                	push   $0x0
  801223:	6a 00                	push   $0x0
  801225:	6a 06                	push   $0x6
  801227:	e8 19 ff ff ff       	call   801145 <syscall>
  80122c:	83 c4 18             	add    $0x18,%esp
}
  80122f:	90                   	nop
  801230:	c9                   	leave  
  801231:	c3                   	ret    

00801232 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801235:	8b 55 0c             	mov    0xc(%ebp),%edx
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	6a 00                	push   $0x0
  801241:	52                   	push   %edx
  801242:	50                   	push   %eax
  801243:	6a 07                	push   $0x7
  801245:	e8 fb fe ff ff       	call   801145 <syscall>
  80124a:	83 c4 18             	add    $0x18,%esp
}
  80124d:	c9                   	leave  
  80124e:	c3                   	ret    

0080124f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
  801252:	56                   	push   %esi
  801253:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801254:	8b 75 18             	mov    0x18(%ebp),%esi
  801257:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80125a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80125d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	56                   	push   %esi
  801264:	53                   	push   %ebx
  801265:	51                   	push   %ecx
  801266:	52                   	push   %edx
  801267:	50                   	push   %eax
  801268:	6a 08                	push   $0x8
  80126a:	e8 d6 fe ff ff       	call   801145 <syscall>
  80126f:	83 c4 18             	add    $0x18,%esp
}
  801272:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801275:	5b                   	pop    %ebx
  801276:	5e                   	pop    %esi
  801277:	5d                   	pop    %ebp
  801278:	c3                   	ret    

00801279 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80127c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	52                   	push   %edx
  801289:	50                   	push   %eax
  80128a:	6a 09                	push   $0x9
  80128c:	e8 b4 fe ff ff       	call   801145 <syscall>
  801291:	83 c4 18             	add    $0x18,%esp
}
  801294:	c9                   	leave  
  801295:	c3                   	ret    

00801296 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801299:	6a 00                	push   $0x0
  80129b:	6a 00                	push   $0x0
  80129d:	6a 00                	push   $0x0
  80129f:	ff 75 0c             	pushl  0xc(%ebp)
  8012a2:	ff 75 08             	pushl  0x8(%ebp)
  8012a5:	6a 0a                	push   $0xa
  8012a7:	e8 99 fe ff ff       	call   801145 <syscall>
  8012ac:	83 c4 18             	add    $0x18,%esp
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8012b4:	6a 00                	push   $0x0
  8012b6:	6a 00                	push   $0x0
  8012b8:	6a 00                	push   $0x0
  8012ba:	6a 00                	push   $0x0
  8012bc:	6a 00                	push   $0x0
  8012be:	6a 0b                	push   $0xb
  8012c0:	e8 80 fe ff ff       	call   801145 <syscall>
  8012c5:	83 c4 18             	add    $0x18,%esp
}
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8012cd:	6a 00                	push   $0x0
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 00                	push   $0x0
  8012d5:	6a 00                	push   $0x0
  8012d7:	6a 0c                	push   $0xc
  8012d9:	e8 67 fe ff ff       	call   801145 <syscall>
  8012de:	83 c4 18             	add    $0x18,%esp
}
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    

008012e3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8012e6:	6a 00                	push   $0x0
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 0d                	push   $0xd
  8012f2:	e8 4e fe ff ff       	call   801145 <syscall>
  8012f7:	83 c4 18             	add    $0x18,%esp
}
  8012fa:	c9                   	leave  
  8012fb:	c3                   	ret    

008012fc <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8012ff:	6a 00                	push   $0x0
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	ff 75 0c             	pushl  0xc(%ebp)
  801308:	ff 75 08             	pushl  0x8(%ebp)
  80130b:	6a 11                	push   $0x11
  80130d:	e8 33 fe ff ff       	call   801145 <syscall>
  801312:	83 c4 18             	add    $0x18,%esp
	return;
  801315:	90                   	nop
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80131b:	6a 00                	push   $0x0
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	ff 75 0c             	pushl  0xc(%ebp)
  801324:	ff 75 08             	pushl  0x8(%ebp)
  801327:	6a 12                	push   $0x12
  801329:	e8 17 fe ff ff       	call   801145 <syscall>
  80132e:	83 c4 18             	add    $0x18,%esp
	return ;
  801331:	90                   	nop
}
  801332:	c9                   	leave  
  801333:	c3                   	ret    

00801334 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 0e                	push   $0xe
  801343:	e8 fd fd ff ff       	call   801145 <syscall>
  801348:	83 c4 18             	add    $0x18,%esp
}
  80134b:	c9                   	leave  
  80134c:	c3                   	ret    

0080134d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	ff 75 08             	pushl  0x8(%ebp)
  80135b:	6a 0f                	push   $0xf
  80135d:	e8 e3 fd ff ff       	call   801145 <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 10                	push   $0x10
  801376:	e8 ca fd ff ff       	call   801145 <syscall>
  80137b:	83 c4 18             	add    $0x18,%esp
}
  80137e:	90                   	nop
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 14                	push   $0x14
  801390:	e8 b0 fd ff ff       	call   801145 <syscall>
  801395:	83 c4 18             	add    $0x18,%esp
}
  801398:	90                   	nop
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 15                	push   $0x15
  8013aa:	e8 96 fd ff ff       	call   801145 <syscall>
  8013af:	83 c4 18             	add    $0x18,%esp
}
  8013b2:	90                   	nop
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	83 ec 04             	sub    $0x4,%esp
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	50                   	push   %eax
  8013ce:	6a 16                	push   $0x16
  8013d0:	e8 70 fd ff ff       	call   801145 <syscall>
  8013d5:	83 c4 18             	add    $0x18,%esp
}
  8013d8:	90                   	nop
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 17                	push   $0x17
  8013ea:	e8 56 fd ff ff       	call   801145 <syscall>
  8013ef:	83 c4 18             	add    $0x18,%esp
}
  8013f2:	90                   	nop
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	ff 75 0c             	pushl  0xc(%ebp)
  801404:	50                   	push   %eax
  801405:	6a 18                	push   $0x18
  801407:	e8 39 fd ff ff       	call   801145 <syscall>
  80140c:	83 c4 18             	add    $0x18,%esp
}
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801414:	8b 55 0c             	mov    0xc(%ebp),%edx
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	52                   	push   %edx
  801421:	50                   	push   %eax
  801422:	6a 1b                	push   $0x1b
  801424:	e8 1c fd ff ff       	call   801145 <syscall>
  801429:	83 c4 18             	add    $0x18,%esp
}
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801431:	8b 55 0c             	mov    0xc(%ebp),%edx
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	52                   	push   %edx
  80143e:	50                   	push   %eax
  80143f:	6a 19                	push   $0x19
  801441:	e8 ff fc ff ff       	call   801145 <syscall>
  801446:	83 c4 18             	add    $0x18,%esp
}
  801449:	90                   	nop
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80144f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	52                   	push   %edx
  80145c:	50                   	push   %eax
  80145d:	6a 1a                	push   $0x1a
  80145f:	e8 e1 fc ff ff       	call   801145 <syscall>
  801464:	83 c4 18             	add    $0x18,%esp
}
  801467:	90                   	nop
  801468:	c9                   	leave  
  801469:	c3                   	ret    

0080146a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	83 ec 04             	sub    $0x4,%esp
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801476:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801479:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	6a 00                	push   $0x0
  801482:	51                   	push   %ecx
  801483:	52                   	push   %edx
  801484:	ff 75 0c             	pushl  0xc(%ebp)
  801487:	50                   	push   %eax
  801488:	6a 1c                	push   $0x1c
  80148a:	e8 b6 fc ff ff       	call   801145 <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
}
  801492:	c9                   	leave  
  801493:	c3                   	ret    

00801494 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801497:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	52                   	push   %edx
  8014a4:	50                   	push   %eax
  8014a5:	6a 1d                	push   $0x1d
  8014a7:	e8 99 fc ff ff       	call   801145 <syscall>
  8014ac:	83 c4 18             	add    $0x18,%esp
}
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	51                   	push   %ecx
  8014c2:	52                   	push   %edx
  8014c3:	50                   	push   %eax
  8014c4:	6a 1e                	push   $0x1e
  8014c6:	e8 7a fc ff ff       	call   801145 <syscall>
  8014cb:	83 c4 18             	add    $0x18,%esp
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	52                   	push   %edx
  8014e0:	50                   	push   %eax
  8014e1:	6a 1f                	push   $0x1f
  8014e3:	e8 5d fc ff ff       	call   801145 <syscall>
  8014e8:	83 c4 18             	add    $0x18,%esp
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 20                	push   $0x20
  8014fc:	e8 44 fc ff ff       	call   801145 <syscall>
  801501:	83 c4 18             	add    $0x18,%esp
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801509:	8b 45 08             	mov    0x8(%ebp),%eax
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	ff 75 10             	pushl  0x10(%ebp)
  801513:	ff 75 0c             	pushl  0xc(%ebp)
  801516:	50                   	push   %eax
  801517:	6a 21                	push   $0x21
  801519:	e8 27 fc ff ff       	call   801145 <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	50                   	push   %eax
  801532:	6a 22                	push   $0x22
  801534:	e8 0c fc ff ff       	call   801145 <syscall>
  801539:	83 c4 18             	add    $0x18,%esp
}
  80153c:	90                   	nop
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	50                   	push   %eax
  80154e:	6a 23                	push   $0x23
  801550:	e8 f0 fb ff ff       	call   801145 <syscall>
  801555:	83 c4 18             	add    $0x18,%esp
}
  801558:	90                   	nop
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801561:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801564:	8d 50 04             	lea    0x4(%eax),%edx
  801567:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	52                   	push   %edx
  801571:	50                   	push   %eax
  801572:	6a 24                	push   $0x24
  801574:	e8 cc fb ff ff       	call   801145 <syscall>
  801579:	83 c4 18             	add    $0x18,%esp
	return result;
  80157c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80157f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801582:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801585:	89 01                	mov    %eax,(%ecx)
  801587:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	c9                   	leave  
  80158e:	c2 04 00             	ret    $0x4

00801591 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	ff 75 10             	pushl  0x10(%ebp)
  80159b:	ff 75 0c             	pushl  0xc(%ebp)
  80159e:	ff 75 08             	pushl  0x8(%ebp)
  8015a1:	6a 13                	push   $0x13
  8015a3:	e8 9d fb ff ff       	call   801145 <syscall>
  8015a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ab:	90                   	nop
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <sys_rcr2>:
uint32 sys_rcr2()
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 25                	push   $0x25
  8015bd:	e8 83 fb ff ff       	call   801145 <syscall>
  8015c2:	83 c4 18             	add    $0x18,%esp
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 04             	sub    $0x4,%esp
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015d3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	50                   	push   %eax
  8015e0:	6a 26                	push   $0x26
  8015e2:	e8 5e fb ff ff       	call   801145 <syscall>
  8015e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ea:	90                   	nop
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <rsttst>:
void rsttst()
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 28                	push   $0x28
  8015fc:	e8 44 fb ff ff       	call   801145 <syscall>
  801601:	83 c4 18             	add    $0x18,%esp
	return ;
  801604:	90                   	nop
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 04             	sub    $0x4,%esp
  80160d:	8b 45 14             	mov    0x14(%ebp),%eax
  801610:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801613:	8b 55 18             	mov    0x18(%ebp),%edx
  801616:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80161a:	52                   	push   %edx
  80161b:	50                   	push   %eax
  80161c:	ff 75 10             	pushl  0x10(%ebp)
  80161f:	ff 75 0c             	pushl  0xc(%ebp)
  801622:	ff 75 08             	pushl  0x8(%ebp)
  801625:	6a 27                	push   $0x27
  801627:	e8 19 fb ff ff       	call   801145 <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
	return ;
  80162f:	90                   	nop
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <chktst>:
void chktst(uint32 n)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	ff 75 08             	pushl  0x8(%ebp)
  801640:	6a 29                	push   $0x29
  801642:	e8 fe fa ff ff       	call   801145 <syscall>
  801647:	83 c4 18             	add    $0x18,%esp
	return ;
  80164a:	90                   	nop
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <inctst>:

void inctst()
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 2a                	push   $0x2a
  80165c:	e8 e4 fa ff ff       	call   801145 <syscall>
  801661:	83 c4 18             	add    $0x18,%esp
	return ;
  801664:	90                   	nop
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <gettst>:
uint32 gettst()
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 2b                	push   $0x2b
  801676:	e8 ca fa ff ff       	call   801145 <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
}
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 2c                	push   $0x2c
  801692:	e8 ae fa ff ff       	call   801145 <syscall>
  801697:	83 c4 18             	add    $0x18,%esp
  80169a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80169d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8016a1:	75 07                	jne    8016aa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8016a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a8:	eb 05                	jmp    8016af <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 2c                	push   $0x2c
  8016c3:	e8 7d fa ff ff       	call   801145 <syscall>
  8016c8:	83 c4 18             	add    $0x18,%esp
  8016cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016ce:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016d2:	75 07                	jne    8016db <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8016d9:	eb 05                	jmp    8016e0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 2c                	push   $0x2c
  8016f4:	e8 4c fa ff ff       	call   801145 <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
  8016fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016ff:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801703:	75 07                	jne    80170c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801705:	b8 01 00 00 00       	mov    $0x1,%eax
  80170a:	eb 05                	jmp    801711 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 2c                	push   $0x2c
  801725:	e8 1b fa ff ff       	call   801145 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
  80172d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801730:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801734:	75 07                	jne    80173d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801736:	b8 01 00 00 00       	mov    $0x1,%eax
  80173b:	eb 05                	jmp    801742 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80173d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	ff 75 08             	pushl  0x8(%ebp)
  801752:	6a 2d                	push   $0x2d
  801754:	e8 ec f9 ff ff       	call   801145 <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
	return ;
  80175c:	90                   	nop
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801763:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801766:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	6a 00                	push   $0x0
  801771:	53                   	push   %ebx
  801772:	51                   	push   %ecx
  801773:	52                   	push   %edx
  801774:	50                   	push   %eax
  801775:	6a 2e                	push   $0x2e
  801777:	e8 c9 f9 ff ff       	call   801145 <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
}
  80177f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	52                   	push   %edx
  801794:	50                   	push   %eax
  801795:	6a 2f                	push   $0x2f
  801797:	e8 a9 f9 ff ff       	call   801145 <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    
  8017a1:	66 90                	xchg   %ax,%ax
  8017a3:	90                   	nop

008017a4 <__udivdi3>:
  8017a4:	55                   	push   %ebp
  8017a5:	57                   	push   %edi
  8017a6:	56                   	push   %esi
  8017a7:	53                   	push   %ebx
  8017a8:	83 ec 1c             	sub    $0x1c,%esp
  8017ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8017af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8017b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8017b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017bb:	89 ca                	mov    %ecx,%edx
  8017bd:	89 f8                	mov    %edi,%eax
  8017bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8017c3:	85 f6                	test   %esi,%esi
  8017c5:	75 2d                	jne    8017f4 <__udivdi3+0x50>
  8017c7:	39 cf                	cmp    %ecx,%edi
  8017c9:	77 65                	ja     801830 <__udivdi3+0x8c>
  8017cb:	89 fd                	mov    %edi,%ebp
  8017cd:	85 ff                	test   %edi,%edi
  8017cf:	75 0b                	jne    8017dc <__udivdi3+0x38>
  8017d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d6:	31 d2                	xor    %edx,%edx
  8017d8:	f7 f7                	div    %edi
  8017da:	89 c5                	mov    %eax,%ebp
  8017dc:	31 d2                	xor    %edx,%edx
  8017de:	89 c8                	mov    %ecx,%eax
  8017e0:	f7 f5                	div    %ebp
  8017e2:	89 c1                	mov    %eax,%ecx
  8017e4:	89 d8                	mov    %ebx,%eax
  8017e6:	f7 f5                	div    %ebp
  8017e8:	89 cf                	mov    %ecx,%edi
  8017ea:	89 fa                	mov    %edi,%edx
  8017ec:	83 c4 1c             	add    $0x1c,%esp
  8017ef:	5b                   	pop    %ebx
  8017f0:	5e                   	pop    %esi
  8017f1:	5f                   	pop    %edi
  8017f2:	5d                   	pop    %ebp
  8017f3:	c3                   	ret    
  8017f4:	39 ce                	cmp    %ecx,%esi
  8017f6:	77 28                	ja     801820 <__udivdi3+0x7c>
  8017f8:	0f bd fe             	bsr    %esi,%edi
  8017fb:	83 f7 1f             	xor    $0x1f,%edi
  8017fe:	75 40                	jne    801840 <__udivdi3+0x9c>
  801800:	39 ce                	cmp    %ecx,%esi
  801802:	72 0a                	jb     80180e <__udivdi3+0x6a>
  801804:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801808:	0f 87 9e 00 00 00    	ja     8018ac <__udivdi3+0x108>
  80180e:	b8 01 00 00 00       	mov    $0x1,%eax
  801813:	89 fa                	mov    %edi,%edx
  801815:	83 c4 1c             	add    $0x1c,%esp
  801818:	5b                   	pop    %ebx
  801819:	5e                   	pop    %esi
  80181a:	5f                   	pop    %edi
  80181b:	5d                   	pop    %ebp
  80181c:	c3                   	ret    
  80181d:	8d 76 00             	lea    0x0(%esi),%esi
  801820:	31 ff                	xor    %edi,%edi
  801822:	31 c0                	xor    %eax,%eax
  801824:	89 fa                	mov    %edi,%edx
  801826:	83 c4 1c             	add    $0x1c,%esp
  801829:	5b                   	pop    %ebx
  80182a:	5e                   	pop    %esi
  80182b:	5f                   	pop    %edi
  80182c:	5d                   	pop    %ebp
  80182d:	c3                   	ret    
  80182e:	66 90                	xchg   %ax,%ax
  801830:	89 d8                	mov    %ebx,%eax
  801832:	f7 f7                	div    %edi
  801834:	31 ff                	xor    %edi,%edi
  801836:	89 fa                	mov    %edi,%edx
  801838:	83 c4 1c             	add    $0x1c,%esp
  80183b:	5b                   	pop    %ebx
  80183c:	5e                   	pop    %esi
  80183d:	5f                   	pop    %edi
  80183e:	5d                   	pop    %ebp
  80183f:	c3                   	ret    
  801840:	bd 20 00 00 00       	mov    $0x20,%ebp
  801845:	89 eb                	mov    %ebp,%ebx
  801847:	29 fb                	sub    %edi,%ebx
  801849:	89 f9                	mov    %edi,%ecx
  80184b:	d3 e6                	shl    %cl,%esi
  80184d:	89 c5                	mov    %eax,%ebp
  80184f:	88 d9                	mov    %bl,%cl
  801851:	d3 ed                	shr    %cl,%ebp
  801853:	89 e9                	mov    %ebp,%ecx
  801855:	09 f1                	or     %esi,%ecx
  801857:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80185b:	89 f9                	mov    %edi,%ecx
  80185d:	d3 e0                	shl    %cl,%eax
  80185f:	89 c5                	mov    %eax,%ebp
  801861:	89 d6                	mov    %edx,%esi
  801863:	88 d9                	mov    %bl,%cl
  801865:	d3 ee                	shr    %cl,%esi
  801867:	89 f9                	mov    %edi,%ecx
  801869:	d3 e2                	shl    %cl,%edx
  80186b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80186f:	88 d9                	mov    %bl,%cl
  801871:	d3 e8                	shr    %cl,%eax
  801873:	09 c2                	or     %eax,%edx
  801875:	89 d0                	mov    %edx,%eax
  801877:	89 f2                	mov    %esi,%edx
  801879:	f7 74 24 0c          	divl   0xc(%esp)
  80187d:	89 d6                	mov    %edx,%esi
  80187f:	89 c3                	mov    %eax,%ebx
  801881:	f7 e5                	mul    %ebp
  801883:	39 d6                	cmp    %edx,%esi
  801885:	72 19                	jb     8018a0 <__udivdi3+0xfc>
  801887:	74 0b                	je     801894 <__udivdi3+0xf0>
  801889:	89 d8                	mov    %ebx,%eax
  80188b:	31 ff                	xor    %edi,%edi
  80188d:	e9 58 ff ff ff       	jmp    8017ea <__udivdi3+0x46>
  801892:	66 90                	xchg   %ax,%ax
  801894:	8b 54 24 08          	mov    0x8(%esp),%edx
  801898:	89 f9                	mov    %edi,%ecx
  80189a:	d3 e2                	shl    %cl,%edx
  80189c:	39 c2                	cmp    %eax,%edx
  80189e:	73 e9                	jae    801889 <__udivdi3+0xe5>
  8018a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8018a3:	31 ff                	xor    %edi,%edi
  8018a5:	e9 40 ff ff ff       	jmp    8017ea <__udivdi3+0x46>
  8018aa:	66 90                	xchg   %ax,%ax
  8018ac:	31 c0                	xor    %eax,%eax
  8018ae:	e9 37 ff ff ff       	jmp    8017ea <__udivdi3+0x46>
  8018b3:	90                   	nop

008018b4 <__umoddi3>:
  8018b4:	55                   	push   %ebp
  8018b5:	57                   	push   %edi
  8018b6:	56                   	push   %esi
  8018b7:	53                   	push   %ebx
  8018b8:	83 ec 1c             	sub    $0x1c,%esp
  8018bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8018bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8018c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8018cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018d3:	89 f3                	mov    %esi,%ebx
  8018d5:	89 fa                	mov    %edi,%edx
  8018d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018db:	89 34 24             	mov    %esi,(%esp)
  8018de:	85 c0                	test   %eax,%eax
  8018e0:	75 1a                	jne    8018fc <__umoddi3+0x48>
  8018e2:	39 f7                	cmp    %esi,%edi
  8018e4:	0f 86 a2 00 00 00    	jbe    80198c <__umoddi3+0xd8>
  8018ea:	89 c8                	mov    %ecx,%eax
  8018ec:	89 f2                	mov    %esi,%edx
  8018ee:	f7 f7                	div    %edi
  8018f0:	89 d0                	mov    %edx,%eax
  8018f2:	31 d2                	xor    %edx,%edx
  8018f4:	83 c4 1c             	add    $0x1c,%esp
  8018f7:	5b                   	pop    %ebx
  8018f8:	5e                   	pop    %esi
  8018f9:	5f                   	pop    %edi
  8018fa:	5d                   	pop    %ebp
  8018fb:	c3                   	ret    
  8018fc:	39 f0                	cmp    %esi,%eax
  8018fe:	0f 87 ac 00 00 00    	ja     8019b0 <__umoddi3+0xfc>
  801904:	0f bd e8             	bsr    %eax,%ebp
  801907:	83 f5 1f             	xor    $0x1f,%ebp
  80190a:	0f 84 ac 00 00 00    	je     8019bc <__umoddi3+0x108>
  801910:	bf 20 00 00 00       	mov    $0x20,%edi
  801915:	29 ef                	sub    %ebp,%edi
  801917:	89 fe                	mov    %edi,%esi
  801919:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80191d:	89 e9                	mov    %ebp,%ecx
  80191f:	d3 e0                	shl    %cl,%eax
  801921:	89 d7                	mov    %edx,%edi
  801923:	89 f1                	mov    %esi,%ecx
  801925:	d3 ef                	shr    %cl,%edi
  801927:	09 c7                	or     %eax,%edi
  801929:	89 e9                	mov    %ebp,%ecx
  80192b:	d3 e2                	shl    %cl,%edx
  80192d:	89 14 24             	mov    %edx,(%esp)
  801930:	89 d8                	mov    %ebx,%eax
  801932:	d3 e0                	shl    %cl,%eax
  801934:	89 c2                	mov    %eax,%edx
  801936:	8b 44 24 08          	mov    0x8(%esp),%eax
  80193a:	d3 e0                	shl    %cl,%eax
  80193c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801940:	8b 44 24 08          	mov    0x8(%esp),%eax
  801944:	89 f1                	mov    %esi,%ecx
  801946:	d3 e8                	shr    %cl,%eax
  801948:	09 d0                	or     %edx,%eax
  80194a:	d3 eb                	shr    %cl,%ebx
  80194c:	89 da                	mov    %ebx,%edx
  80194e:	f7 f7                	div    %edi
  801950:	89 d3                	mov    %edx,%ebx
  801952:	f7 24 24             	mull   (%esp)
  801955:	89 c6                	mov    %eax,%esi
  801957:	89 d1                	mov    %edx,%ecx
  801959:	39 d3                	cmp    %edx,%ebx
  80195b:	0f 82 87 00 00 00    	jb     8019e8 <__umoddi3+0x134>
  801961:	0f 84 91 00 00 00    	je     8019f8 <__umoddi3+0x144>
  801967:	8b 54 24 04          	mov    0x4(%esp),%edx
  80196b:	29 f2                	sub    %esi,%edx
  80196d:	19 cb                	sbb    %ecx,%ebx
  80196f:	89 d8                	mov    %ebx,%eax
  801971:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801975:	d3 e0                	shl    %cl,%eax
  801977:	89 e9                	mov    %ebp,%ecx
  801979:	d3 ea                	shr    %cl,%edx
  80197b:	09 d0                	or     %edx,%eax
  80197d:	89 e9                	mov    %ebp,%ecx
  80197f:	d3 eb                	shr    %cl,%ebx
  801981:	89 da                	mov    %ebx,%edx
  801983:	83 c4 1c             	add    $0x1c,%esp
  801986:	5b                   	pop    %ebx
  801987:	5e                   	pop    %esi
  801988:	5f                   	pop    %edi
  801989:	5d                   	pop    %ebp
  80198a:	c3                   	ret    
  80198b:	90                   	nop
  80198c:	89 fd                	mov    %edi,%ebp
  80198e:	85 ff                	test   %edi,%edi
  801990:	75 0b                	jne    80199d <__umoddi3+0xe9>
  801992:	b8 01 00 00 00       	mov    $0x1,%eax
  801997:	31 d2                	xor    %edx,%edx
  801999:	f7 f7                	div    %edi
  80199b:	89 c5                	mov    %eax,%ebp
  80199d:	89 f0                	mov    %esi,%eax
  80199f:	31 d2                	xor    %edx,%edx
  8019a1:	f7 f5                	div    %ebp
  8019a3:	89 c8                	mov    %ecx,%eax
  8019a5:	f7 f5                	div    %ebp
  8019a7:	89 d0                	mov    %edx,%eax
  8019a9:	e9 44 ff ff ff       	jmp    8018f2 <__umoddi3+0x3e>
  8019ae:	66 90                	xchg   %ax,%ax
  8019b0:	89 c8                	mov    %ecx,%eax
  8019b2:	89 f2                	mov    %esi,%edx
  8019b4:	83 c4 1c             	add    $0x1c,%esp
  8019b7:	5b                   	pop    %ebx
  8019b8:	5e                   	pop    %esi
  8019b9:	5f                   	pop    %edi
  8019ba:	5d                   	pop    %ebp
  8019bb:	c3                   	ret    
  8019bc:	3b 04 24             	cmp    (%esp),%eax
  8019bf:	72 06                	jb     8019c7 <__umoddi3+0x113>
  8019c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8019c5:	77 0f                	ja     8019d6 <__umoddi3+0x122>
  8019c7:	89 f2                	mov    %esi,%edx
  8019c9:	29 f9                	sub    %edi,%ecx
  8019cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8019cf:	89 14 24             	mov    %edx,(%esp)
  8019d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8019da:	8b 14 24             	mov    (%esp),%edx
  8019dd:	83 c4 1c             	add    $0x1c,%esp
  8019e0:	5b                   	pop    %ebx
  8019e1:	5e                   	pop    %esi
  8019e2:	5f                   	pop    %edi
  8019e3:	5d                   	pop    %ebp
  8019e4:	c3                   	ret    
  8019e5:	8d 76 00             	lea    0x0(%esi),%esi
  8019e8:	2b 04 24             	sub    (%esp),%eax
  8019eb:	19 fa                	sbb    %edi,%edx
  8019ed:	89 d1                	mov    %edx,%ecx
  8019ef:	89 c6                	mov    %eax,%esi
  8019f1:	e9 71 ff ff ff       	jmp    801967 <__umoddi3+0xb3>
  8019f6:	66 90                	xchg   %ax,%ax
  8019f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8019fc:	72 ea                	jb     8019e8 <__umoddi3+0x134>
  8019fe:	89 d9                	mov    %ebx,%ecx
  801a00:	e9 62 ff ff ff       	jmp    801967 <__umoddi3+0xb3>
