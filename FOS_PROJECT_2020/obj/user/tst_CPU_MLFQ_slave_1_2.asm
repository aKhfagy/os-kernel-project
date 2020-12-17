
obj/user/tst_CPU_MLFQ_slave_1_2:     file format elf32-i386


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
  800031:	e8 73 00 00 00       	call   8000a9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	// Create & run the slave environments
	int ID;
	for(int i = 0; i < 3; ++i)
  80003e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800045:	eb 39                	jmp    800080 <_main+0x48>
	{
		ID = sys_create_env("dummy_process", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
  800047:	a1 20 20 80 00       	mov    0x802020,%eax
  80004c:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800052:	a1 20 20 80 00       	mov    0x802020,%eax
  800057:	8b 40 74             	mov    0x74(%eax),%eax
  80005a:	83 ec 04             	sub    $0x4,%esp
  80005d:	52                   	push   %edx
  80005e:	50                   	push   %eax
  80005f:	68 c0 19 80 00       	push   $0x8019c0
  800064:	e8 a4 13 00 00       	call   80140d <sys_create_env>
  800069:	83 c4 10             	add    $0x10,%esp
  80006c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_run_env(ID);
  80006f:	83 ec 0c             	sub    $0xc,%esp
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 b0 13 00 00       	call   80142a <sys_run_env>
  80007a:	83 c4 10             	add    $0x10,%esp

void _main(void)
{
	// Create & run the slave environments
	int ID;
	for(int i = 0; i < 3; ++i)
  80007d:	ff 45 f4             	incl   -0xc(%ebp)
  800080:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
  800084:	7e c1                	jle    800047 <_main+0xf>
	{
		ID = sys_create_env("dummy_process", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
		sys_run_env(ID);
	}

	env_sleep(100000);
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 86 01 00       	push   $0x186a0
  80008e:	e8 15 16 00 00       	call   8016a8 <env_sleep>
  800093:	83 c4 10             	add    $0x10,%esp
	// To ensure that the slave environments completed successfully
	cprintf("Congratulations!! test CPU SCHEDULING using MLFQ is completed successfully.\n");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 d0 19 80 00       	push   $0x8019d0
  80009e:	e8 1f 02 00 00       	call   8002c2 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp

	return;
  8000a6:	90                   	nop
}
  8000a7:	c9                   	leave  
  8000a8:	c3                   	ret    

008000a9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000af:	e8 39 10 00 00       	call   8010ed <sys_getenvindex>
  8000b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000ba:	89 d0                	mov    %edx,%eax
  8000bc:	c1 e0 03             	shl    $0x3,%eax
  8000bf:	01 d0                	add    %edx,%eax
  8000c1:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000c8:	01 c8                	add    %ecx,%eax
  8000ca:	01 c0                	add    %eax,%eax
  8000cc:	01 d0                	add    %edx,%eax
  8000ce:	01 c0                	add    %eax,%eax
  8000d0:	01 d0                	add    %edx,%eax
  8000d2:	89 c2                	mov    %eax,%edx
  8000d4:	c1 e2 05             	shl    $0x5,%edx
  8000d7:	29 c2                	sub    %eax,%edx
  8000d9:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8000e0:	89 c2                	mov    %eax,%edx
  8000e2:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000e8:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000ed:	a1 20 20 80 00       	mov    0x802020,%eax
  8000f2:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8000f8:	84 c0                	test   %al,%al
  8000fa:	74 0f                	je     80010b <libmain+0x62>
		binaryname = myEnv->prog_name;
  8000fc:	a1 20 20 80 00       	mov    0x802020,%eax
  800101:	05 40 3c 01 00       	add    $0x13c40,%eax
  800106:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80010f:	7e 0a                	jle    80011b <libmain+0x72>
		binaryname = argv[0];
  800111:	8b 45 0c             	mov    0xc(%ebp),%eax
  800114:	8b 00                	mov    (%eax),%eax
  800116:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	ff 75 0c             	pushl  0xc(%ebp)
  800121:	ff 75 08             	pushl  0x8(%ebp)
  800124:	e8 0f ff ff ff       	call   800038 <_main>
  800129:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80012c:	e8 57 11 00 00       	call   801288 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800131:	83 ec 0c             	sub    $0xc,%esp
  800134:	68 38 1a 80 00       	push   $0x801a38
  800139:	e8 84 01 00 00       	call   8002c2 <cprintf>
  80013e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800141:	a1 20 20 80 00       	mov    0x802020,%eax
  800146:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80014c:	a1 20 20 80 00       	mov    0x802020,%eax
  800151:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	52                   	push   %edx
  80015b:	50                   	push   %eax
  80015c:	68 60 1a 80 00       	push   $0x801a60
  800161:	e8 5c 01 00 00       	call   8002c2 <cprintf>
  800166:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800169:	a1 20 20 80 00       	mov    0x802020,%eax
  80016e:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800174:	a1 20 20 80 00       	mov    0x802020,%eax
  800179:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80017f:	83 ec 04             	sub    $0x4,%esp
  800182:	52                   	push   %edx
  800183:	50                   	push   %eax
  800184:	68 88 1a 80 00       	push   $0x801a88
  800189:	e8 34 01 00 00       	call   8002c2 <cprintf>
  80018e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800191:	a1 20 20 80 00       	mov    0x802020,%eax
  800196:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80019c:	83 ec 08             	sub    $0x8,%esp
  80019f:	50                   	push   %eax
  8001a0:	68 c9 1a 80 00       	push   $0x801ac9
  8001a5:	e8 18 01 00 00       	call   8002c2 <cprintf>
  8001aa:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 38 1a 80 00       	push   $0x801a38
  8001b5:	e8 08 01 00 00       	call   8002c2 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001bd:	e8 e0 10 00 00       	call   8012a2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001c2:	e8 19 00 00 00       	call   8001e0 <exit>
}
  8001c7:	90                   	nop
  8001c8:	c9                   	leave  
  8001c9:	c3                   	ret    

008001ca <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	6a 00                	push   $0x0
  8001d5:	e8 df 0e 00 00       	call   8010b9 <sys_env_destroy>
  8001da:	83 c4 10             	add    $0x10,%esp
}
  8001dd:	90                   	nop
  8001de:	c9                   	leave  
  8001df:	c3                   	ret    

008001e0 <exit>:

void
exit(void)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8001e6:	e8 34 0f 00 00       	call   80111f <sys_env_exit>
}
  8001eb:	90                   	nop
  8001ec:	c9                   	leave  
  8001ed:	c3                   	ret    

008001ee <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f7:	8b 00                	mov    (%eax),%eax
  8001f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8001fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ff:	89 0a                	mov    %ecx,(%edx)
  800201:	8b 55 08             	mov    0x8(%ebp),%edx
  800204:	88 d1                	mov    %dl,%cl
  800206:	8b 55 0c             	mov    0xc(%ebp),%edx
  800209:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80020d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800210:	8b 00                	mov    (%eax),%eax
  800212:	3d ff 00 00 00       	cmp    $0xff,%eax
  800217:	75 2c                	jne    800245 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800219:	a0 24 20 80 00       	mov    0x802024,%al
  80021e:	0f b6 c0             	movzbl %al,%eax
  800221:	8b 55 0c             	mov    0xc(%ebp),%edx
  800224:	8b 12                	mov    (%edx),%edx
  800226:	89 d1                	mov    %edx,%ecx
  800228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022b:	83 c2 08             	add    $0x8,%edx
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	50                   	push   %eax
  800232:	51                   	push   %ecx
  800233:	52                   	push   %edx
  800234:	e8 3e 0e 00 00       	call   801077 <sys_cputs>
  800239:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80023c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800245:	8b 45 0c             	mov    0xc(%ebp),%eax
  800248:	8b 40 04             	mov    0x4(%eax),%eax
  80024b:	8d 50 01             	lea    0x1(%eax),%edx
  80024e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800251:	89 50 04             	mov    %edx,0x4(%eax)
}
  800254:	90                   	nop
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800260:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800267:	00 00 00 
	b.cnt = 0;
  80026a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800271:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800274:	ff 75 0c             	pushl  0xc(%ebp)
  800277:	ff 75 08             	pushl  0x8(%ebp)
  80027a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800280:	50                   	push   %eax
  800281:	68 ee 01 80 00       	push   $0x8001ee
  800286:	e8 11 02 00 00       	call   80049c <vprintfmt>
  80028b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80028e:	a0 24 20 80 00       	mov    0x802024,%al
  800293:	0f b6 c0             	movzbl %al,%eax
  800296:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80029c:	83 ec 04             	sub    $0x4,%esp
  80029f:	50                   	push   %eax
  8002a0:	52                   	push   %edx
  8002a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a7:	83 c0 08             	add    $0x8,%eax
  8002aa:	50                   	push   %eax
  8002ab:	e8 c7 0d 00 00       	call   801077 <sys_cputs>
  8002b0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002b3:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8002ba:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002c8:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8002cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d8:	83 ec 08             	sub    $0x8,%esp
  8002db:	ff 75 f4             	pushl  -0xc(%ebp)
  8002de:	50                   	push   %eax
  8002df:	e8 73 ff ff ff       	call   800257 <vcprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
  8002e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002f5:	e8 8e 0f 00 00       	call   801288 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002fa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800300:	8b 45 08             	mov    0x8(%ebp),%eax
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	ff 75 f4             	pushl  -0xc(%ebp)
  800309:	50                   	push   %eax
  80030a:	e8 48 ff ff ff       	call   800257 <vcprintf>
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800315:	e8 88 0f 00 00       	call   8012a2 <sys_enable_interrupt>
	return cnt;
  80031a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	53                   	push   %ebx
  800323:	83 ec 14             	sub    $0x14,%esp
  800326:	8b 45 10             	mov    0x10(%ebp),%eax
  800329:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80032c:	8b 45 14             	mov    0x14(%ebp),%eax
  80032f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800332:	8b 45 18             	mov    0x18(%ebp),%eax
  800335:	ba 00 00 00 00       	mov    $0x0,%edx
  80033a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80033d:	77 55                	ja     800394 <printnum+0x75>
  80033f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800342:	72 05                	jb     800349 <printnum+0x2a>
  800344:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800347:	77 4b                	ja     800394 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800349:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80034c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80034f:	8b 45 18             	mov    0x18(%ebp),%eax
  800352:	ba 00 00 00 00       	mov    $0x0,%edx
  800357:	52                   	push   %edx
  800358:	50                   	push   %eax
  800359:	ff 75 f4             	pushl  -0xc(%ebp)
  80035c:	ff 75 f0             	pushl  -0x10(%ebp)
  80035f:	e8 f8 13 00 00       	call   80175c <__udivdi3>
  800364:	83 c4 10             	add    $0x10,%esp
  800367:	83 ec 04             	sub    $0x4,%esp
  80036a:	ff 75 20             	pushl  0x20(%ebp)
  80036d:	53                   	push   %ebx
  80036e:	ff 75 18             	pushl  0x18(%ebp)
  800371:	52                   	push   %edx
  800372:	50                   	push   %eax
  800373:	ff 75 0c             	pushl  0xc(%ebp)
  800376:	ff 75 08             	pushl  0x8(%ebp)
  800379:	e8 a1 ff ff ff       	call   80031f <printnum>
  80037e:	83 c4 20             	add    $0x20,%esp
  800381:	eb 1a                	jmp    80039d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800383:	83 ec 08             	sub    $0x8,%esp
  800386:	ff 75 0c             	pushl  0xc(%ebp)
  800389:	ff 75 20             	pushl  0x20(%ebp)
  80038c:	8b 45 08             	mov    0x8(%ebp),%eax
  80038f:	ff d0                	call   *%eax
  800391:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800394:	ff 4d 1c             	decl   0x1c(%ebp)
  800397:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80039b:	7f e6                	jg     800383 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ab:	53                   	push   %ebx
  8003ac:	51                   	push   %ecx
  8003ad:	52                   	push   %edx
  8003ae:	50                   	push   %eax
  8003af:	e8 b8 14 00 00       	call   80186c <__umoddi3>
  8003b4:	83 c4 10             	add    $0x10,%esp
  8003b7:	05 f4 1c 80 00       	add    $0x801cf4,%eax
  8003bc:	8a 00                	mov    (%eax),%al
  8003be:	0f be c0             	movsbl %al,%eax
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	ff 75 0c             	pushl  0xc(%ebp)
  8003c7:	50                   	push   %eax
  8003c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cb:	ff d0                	call   *%eax
  8003cd:	83 c4 10             	add    $0x10,%esp
}
  8003d0:	90                   	nop
  8003d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003d4:	c9                   	leave  
  8003d5:	c3                   	ret    

008003d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003dd:	7e 1c                	jle    8003fb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	8d 50 08             	lea    0x8(%eax),%edx
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ea:	89 10                	mov    %edx,(%eax)
  8003ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ef:	8b 00                	mov    (%eax),%eax
  8003f1:	83 e8 08             	sub    $0x8,%eax
  8003f4:	8b 50 04             	mov    0x4(%eax),%edx
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	eb 40                	jmp    80043b <getuint+0x65>
	else if (lflag)
  8003fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003ff:	74 1e                	je     80041f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	8d 50 04             	lea    0x4(%eax),%edx
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
  80040c:	89 10                	mov    %edx,(%eax)
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	83 e8 04             	sub    $0x4,%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	ba 00 00 00 00       	mov    $0x0,%edx
  80041d:	eb 1c                	jmp    80043b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
  800422:	8b 00                	mov    (%eax),%eax
  800424:	8d 50 04             	lea    0x4(%eax),%edx
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	89 10                	mov    %edx,(%eax)
  80042c:	8b 45 08             	mov    0x8(%ebp),%eax
  80042f:	8b 00                	mov    (%eax),%eax
  800431:	83 e8 04             	sub    $0x4,%eax
  800434:	8b 00                	mov    (%eax),%eax
  800436:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80043b:	5d                   	pop    %ebp
  80043c:	c3                   	ret    

0080043d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800440:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800444:	7e 1c                	jle    800462 <getint+0x25>
		return va_arg(*ap, long long);
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	8d 50 08             	lea    0x8(%eax),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	89 10                	mov    %edx,(%eax)
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	83 e8 08             	sub    $0x8,%eax
  80045b:	8b 50 04             	mov    0x4(%eax),%edx
  80045e:	8b 00                	mov    (%eax),%eax
  800460:	eb 38                	jmp    80049a <getint+0x5d>
	else if (lflag)
  800462:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800466:	74 1a                	je     800482 <getint+0x45>
		return va_arg(*ap, long);
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	8d 50 04             	lea    0x4(%eax),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	89 10                	mov    %edx,(%eax)
  800475:	8b 45 08             	mov    0x8(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	83 e8 04             	sub    $0x4,%eax
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	99                   	cltd   
  800480:	eb 18                	jmp    80049a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	8b 00                	mov    (%eax),%eax
  800487:	8d 50 04             	lea    0x4(%eax),%edx
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	89 10                	mov    %edx,(%eax)
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	83 e8 04             	sub    $0x4,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	99                   	cltd   
}
  80049a:	5d                   	pop    %ebp
  80049b:	c3                   	ret    

0080049c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80049c:	55                   	push   %ebp
  80049d:	89 e5                	mov    %esp,%ebp
  80049f:	56                   	push   %esi
  8004a0:	53                   	push   %ebx
  8004a1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a4:	eb 17                	jmp    8004bd <vprintfmt+0x21>
			if (ch == '\0')
  8004a6:	85 db                	test   %ebx,%ebx
  8004a8:	0f 84 af 03 00 00    	je     80085d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	ff 75 0c             	pushl  0xc(%ebp)
  8004b4:	53                   	push   %ebx
  8004b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b8:	ff d0                	call   *%eax
  8004ba:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c0:	8d 50 01             	lea    0x1(%eax),%edx
  8004c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8004c6:	8a 00                	mov    (%eax),%al
  8004c8:	0f b6 d8             	movzbl %al,%ebx
  8004cb:	83 fb 25             	cmp    $0x25,%ebx
  8004ce:	75 d6                	jne    8004a6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004d0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004d4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004e9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f3:	8d 50 01             	lea    0x1(%eax),%edx
  8004f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f9:	8a 00                	mov    (%eax),%al
  8004fb:	0f b6 d8             	movzbl %al,%ebx
  8004fe:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800501:	83 f8 55             	cmp    $0x55,%eax
  800504:	0f 87 2b 03 00 00    	ja     800835 <vprintfmt+0x399>
  80050a:	8b 04 85 18 1d 80 00 	mov    0x801d18(,%eax,4),%eax
  800511:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800513:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800517:	eb d7                	jmp    8004f0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800519:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80051d:	eb d1                	jmp    8004f0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80051f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800526:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800529:	89 d0                	mov    %edx,%eax
  80052b:	c1 e0 02             	shl    $0x2,%eax
  80052e:	01 d0                	add    %edx,%eax
  800530:	01 c0                	add    %eax,%eax
  800532:	01 d8                	add    %ebx,%eax
  800534:	83 e8 30             	sub    $0x30,%eax
  800537:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80053a:	8b 45 10             	mov    0x10(%ebp),%eax
  80053d:	8a 00                	mov    (%eax),%al
  80053f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800542:	83 fb 2f             	cmp    $0x2f,%ebx
  800545:	7e 3e                	jle    800585 <vprintfmt+0xe9>
  800547:	83 fb 39             	cmp    $0x39,%ebx
  80054a:	7f 39                	jg     800585 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80054c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80054f:	eb d5                	jmp    800526 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	83 c0 04             	add    $0x4,%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	83 e8 04             	sub    $0x4,%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800565:	eb 1f                	jmp    800586 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800567:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80056b:	79 83                	jns    8004f0 <vprintfmt+0x54>
				width = 0;
  80056d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800574:	e9 77 ff ff ff       	jmp    8004f0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800579:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800580:	e9 6b ff ff ff       	jmp    8004f0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800585:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800586:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80058a:	0f 89 60 ff ff ff    	jns    8004f0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800590:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800593:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800596:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80059d:	e9 4e ff ff ff       	jmp    8004f0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005a2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005a5:	e9 46 ff ff ff       	jmp    8004f0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	83 c0 04             	add    $0x4,%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	83 e8 04             	sub    $0x4,%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	ff 75 0c             	pushl  0xc(%ebp)
  8005c1:	50                   	push   %eax
  8005c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c5:	ff d0                	call   *%eax
  8005c7:	83 c4 10             	add    $0x10,%esp
			break;
  8005ca:	e9 89 02 00 00       	jmp    800858 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	83 c0 04             	add    $0x4,%eax
  8005d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	83 e8 04             	sub    $0x4,%eax
  8005de:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005e0:	85 db                	test   %ebx,%ebx
  8005e2:	79 02                	jns    8005e6 <vprintfmt+0x14a>
				err = -err;
  8005e4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005e6:	83 fb 64             	cmp    $0x64,%ebx
  8005e9:	7f 0b                	jg     8005f6 <vprintfmt+0x15a>
  8005eb:	8b 34 9d 60 1b 80 00 	mov    0x801b60(,%ebx,4),%esi
  8005f2:	85 f6                	test   %esi,%esi
  8005f4:	75 19                	jne    80060f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005f6:	53                   	push   %ebx
  8005f7:	68 05 1d 80 00       	push   $0x801d05
  8005fc:	ff 75 0c             	pushl  0xc(%ebp)
  8005ff:	ff 75 08             	pushl  0x8(%ebp)
  800602:	e8 5e 02 00 00       	call   800865 <printfmt>
  800607:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80060a:	e9 49 02 00 00       	jmp    800858 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80060f:	56                   	push   %esi
  800610:	68 0e 1d 80 00       	push   $0x801d0e
  800615:	ff 75 0c             	pushl  0xc(%ebp)
  800618:	ff 75 08             	pushl  0x8(%ebp)
  80061b:	e8 45 02 00 00       	call   800865 <printfmt>
  800620:	83 c4 10             	add    $0x10,%esp
			break;
  800623:	e9 30 02 00 00       	jmp    800858 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	83 c0 04             	add    $0x4,%eax
  80062e:	89 45 14             	mov    %eax,0x14(%ebp)
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	83 e8 04             	sub    $0x4,%eax
  800637:	8b 30                	mov    (%eax),%esi
  800639:	85 f6                	test   %esi,%esi
  80063b:	75 05                	jne    800642 <vprintfmt+0x1a6>
				p = "(null)";
  80063d:	be 11 1d 80 00       	mov    $0x801d11,%esi
			if (width > 0 && padc != '-')
  800642:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800646:	7e 6d                	jle    8006b5 <vprintfmt+0x219>
  800648:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80064c:	74 67                	je     8006b5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80064e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	50                   	push   %eax
  800655:	56                   	push   %esi
  800656:	e8 0c 03 00 00       	call   800967 <strnlen>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800661:	eb 16                	jmp    800679 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800663:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 0c             	pushl  0xc(%ebp)
  80066d:	50                   	push   %eax
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	ff d0                	call   *%eax
  800673:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800676:	ff 4d e4             	decl   -0x1c(%ebp)
  800679:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067d:	7f e4                	jg     800663 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80067f:	eb 34                	jmp    8006b5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800681:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800685:	74 1c                	je     8006a3 <vprintfmt+0x207>
  800687:	83 fb 1f             	cmp    $0x1f,%ebx
  80068a:	7e 05                	jle    800691 <vprintfmt+0x1f5>
  80068c:	83 fb 7e             	cmp    $0x7e,%ebx
  80068f:	7e 12                	jle    8006a3 <vprintfmt+0x207>
					putch('?', putdat);
  800691:	83 ec 08             	sub    $0x8,%esp
  800694:	ff 75 0c             	pushl  0xc(%ebp)
  800697:	6a 3f                	push   $0x3f
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	ff d0                	call   *%eax
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	eb 0f                	jmp    8006b2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	ff 75 0c             	pushl  0xc(%ebp)
  8006a9:	53                   	push   %ebx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	ff d0                	call   *%eax
  8006af:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006b5:	89 f0                	mov    %esi,%eax
  8006b7:	8d 70 01             	lea    0x1(%eax),%esi
  8006ba:	8a 00                	mov    (%eax),%al
  8006bc:	0f be d8             	movsbl %al,%ebx
  8006bf:	85 db                	test   %ebx,%ebx
  8006c1:	74 24                	je     8006e7 <vprintfmt+0x24b>
  8006c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c7:	78 b8                	js     800681 <vprintfmt+0x1e5>
  8006c9:	ff 4d e0             	decl   -0x20(%ebp)
  8006cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006d0:	79 af                	jns    800681 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d2:	eb 13                	jmp    8006e7 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	ff 75 0c             	pushl  0xc(%ebp)
  8006da:	6a 20                	push   $0x20
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	ff d0                	call   *%eax
  8006e1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e4:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006eb:	7f e7                	jg     8006d4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006ed:	e9 66 01 00 00       	jmp    800858 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8006f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8006fb:	50                   	push   %eax
  8006fc:	e8 3c fd ff ff       	call   80043d <getint>
  800701:	83 c4 10             	add    $0x10,%esp
  800704:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800707:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80070a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80070d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800710:	85 d2                	test   %edx,%edx
  800712:	79 23                	jns    800737 <vprintfmt+0x29b>
				putch('-', putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	ff 75 0c             	pushl  0xc(%ebp)
  80071a:	6a 2d                	push   $0x2d
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	ff d0                	call   *%eax
  800721:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800727:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072a:	f7 d8                	neg    %eax
  80072c:	83 d2 00             	adc    $0x0,%edx
  80072f:	f7 da                	neg    %edx
  800731:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800734:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800737:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80073e:	e9 bc 00 00 00       	jmp    8007ff <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 e8             	pushl  -0x18(%ebp)
  800749:	8d 45 14             	lea    0x14(%ebp),%eax
  80074c:	50                   	push   %eax
  80074d:	e8 84 fc ff ff       	call   8003d6 <getuint>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800758:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80075b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800762:	e9 98 00 00 00       	jmp    8007ff <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 0c             	pushl  0xc(%ebp)
  80076d:	6a 58                	push   $0x58
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	ff d0                	call   *%eax
  800774:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	ff 75 0c             	pushl  0xc(%ebp)
  80077d:	6a 58                	push   $0x58
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	ff d0                	call   *%eax
  800784:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 0c             	pushl  0xc(%ebp)
  80078d:	6a 58                	push   $0x58
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	ff d0                	call   *%eax
  800794:	83 c4 10             	add    $0x10,%esp
			break;
  800797:	e9 bc 00 00 00       	jmp    800858 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	6a 30                	push   $0x30
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	ff d0                	call   *%eax
  8007a9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	ff 75 0c             	pushl  0xc(%ebp)
  8007b2:	6a 78                	push   $0x78
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	ff d0                	call   *%eax
  8007b9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	83 c0 04             	add    $0x4,%eax
  8007c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	83 e8 04             	sub    $0x4,%eax
  8007cb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007d7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007de:	eb 1f                	jmp    8007ff <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8007e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e9:	50                   	push   %eax
  8007ea:	e8 e7 fb ff ff       	call   8003d6 <getuint>
  8007ef:	83 c4 10             	add    $0x10,%esp
  8007f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007f8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007ff:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800803:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	52                   	push   %edx
  80080a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80080d:	50                   	push   %eax
  80080e:	ff 75 f4             	pushl  -0xc(%ebp)
  800811:	ff 75 f0             	pushl  -0x10(%ebp)
  800814:	ff 75 0c             	pushl  0xc(%ebp)
  800817:	ff 75 08             	pushl  0x8(%ebp)
  80081a:	e8 00 fb ff ff       	call   80031f <printnum>
  80081f:	83 c4 20             	add    $0x20,%esp
			break;
  800822:	eb 34                	jmp    800858 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	53                   	push   %ebx
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	ff d0                	call   *%eax
  800830:	83 c4 10             	add    $0x10,%esp
			break;
  800833:	eb 23                	jmp    800858 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	6a 25                	push   $0x25
  80083d:	8b 45 08             	mov    0x8(%ebp),%eax
  800840:	ff d0                	call   *%eax
  800842:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800845:	ff 4d 10             	decl   0x10(%ebp)
  800848:	eb 03                	jmp    80084d <vprintfmt+0x3b1>
  80084a:	ff 4d 10             	decl   0x10(%ebp)
  80084d:	8b 45 10             	mov    0x10(%ebp),%eax
  800850:	48                   	dec    %eax
  800851:	8a 00                	mov    (%eax),%al
  800853:	3c 25                	cmp    $0x25,%al
  800855:	75 f3                	jne    80084a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800857:	90                   	nop
		}
	}
  800858:	e9 47 fc ff ff       	jmp    8004a4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80085d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80085e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800861:	5b                   	pop    %ebx
  800862:	5e                   	pop    %esi
  800863:	5d                   	pop    %ebp
  800864:	c3                   	ret    

00800865 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800865:	55                   	push   %ebp
  800866:	89 e5                	mov    %esp,%ebp
  800868:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80086b:	8d 45 10             	lea    0x10(%ebp),%eax
  80086e:	83 c0 04             	add    $0x4,%eax
  800871:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800874:	8b 45 10             	mov    0x10(%ebp),%eax
  800877:	ff 75 f4             	pushl  -0xc(%ebp)
  80087a:	50                   	push   %eax
  80087b:	ff 75 0c             	pushl  0xc(%ebp)
  80087e:	ff 75 08             	pushl  0x8(%ebp)
  800881:	e8 16 fc ff ff       	call   80049c <vprintfmt>
  800886:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800889:	90                   	nop
  80088a:	c9                   	leave  
  80088b:	c3                   	ret    

0080088c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80088f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800892:	8b 40 08             	mov    0x8(%eax),%eax
  800895:	8d 50 01             	lea    0x1(%eax),%edx
  800898:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80089e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a1:	8b 10                	mov    (%eax),%edx
  8008a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a6:	8b 40 04             	mov    0x4(%eax),%eax
  8008a9:	39 c2                	cmp    %eax,%edx
  8008ab:	73 12                	jae    8008bf <sprintputch+0x33>
		*b->buf++ = ch;
  8008ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8008b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b8:	89 0a                	mov    %ecx,(%edx)
  8008ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8008bd:	88 10                	mov    %dl,(%eax)
}
  8008bf:	90                   	nop
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    

008008c2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	01 d0                	add    %edx,%eax
  8008d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008e7:	74 06                	je     8008ef <vsnprintf+0x2d>
  8008e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ed:	7f 07                	jg     8008f6 <vsnprintf+0x34>
		return -E_INVAL;
  8008ef:	b8 03 00 00 00       	mov    $0x3,%eax
  8008f4:	eb 20                	jmp    800916 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008f6:	ff 75 14             	pushl  0x14(%ebp)
  8008f9:	ff 75 10             	pushl  0x10(%ebp)
  8008fc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ff:	50                   	push   %eax
  800900:	68 8c 08 80 00       	push   $0x80088c
  800905:	e8 92 fb ff ff       	call   80049c <vprintfmt>
  80090a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80090d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800910:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800913:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80091e:	8d 45 10             	lea    0x10(%ebp),%eax
  800921:	83 c0 04             	add    $0x4,%eax
  800924:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800927:	8b 45 10             	mov    0x10(%ebp),%eax
  80092a:	ff 75 f4             	pushl  -0xc(%ebp)
  80092d:	50                   	push   %eax
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	ff 75 08             	pushl  0x8(%ebp)
  800934:	e8 89 ff ff ff       	call   8008c2 <vsnprintf>
  800939:	83 c4 10             	add    $0x10,%esp
  80093c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80093f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800942:	c9                   	leave  
  800943:	c3                   	ret    

00800944 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80094a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800951:	eb 06                	jmp    800959 <strlen+0x15>
		n++;
  800953:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800956:	ff 45 08             	incl   0x8(%ebp)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8a 00                	mov    (%eax),%al
  80095e:	84 c0                	test   %al,%al
  800960:	75 f1                	jne    800953 <strlen+0xf>
		n++;
	return n;
  800962:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80096d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800974:	eb 09                	jmp    80097f <strnlen+0x18>
		n++;
  800976:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800979:	ff 45 08             	incl   0x8(%ebp)
  80097c:	ff 4d 0c             	decl   0xc(%ebp)
  80097f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800983:	74 09                	je     80098e <strnlen+0x27>
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	8a 00                	mov    (%eax),%al
  80098a:	84 c0                	test   %al,%al
  80098c:	75 e8                	jne    800976 <strnlen+0xf>
		n++;
	return n;
  80098e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800991:	c9                   	leave  
  800992:	c3                   	ret    

00800993 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80099f:	90                   	nop
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8d 50 01             	lea    0x1(%eax),%edx
  8009a6:	89 55 08             	mov    %edx,0x8(%ebp)
  8009a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009af:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009b2:	8a 12                	mov    (%edx),%dl
  8009b4:	88 10                	mov    %dl,(%eax)
  8009b6:	8a 00                	mov    (%eax),%al
  8009b8:	84 c0                	test   %al,%al
  8009ba:	75 e4                	jne    8009a0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009bf:	c9                   	leave  
  8009c0:	c3                   	ret    

008009c1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d4:	eb 1f                	jmp    8009f5 <strncpy+0x34>
		*dst++ = *src;
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8d 50 01             	lea    0x1(%eax),%edx
  8009dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8009df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e2:	8a 12                	mov    (%edx),%dl
  8009e4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e9:	8a 00                	mov    (%eax),%al
  8009eb:	84 c0                	test   %al,%al
  8009ed:	74 03                	je     8009f2 <strncpy+0x31>
			src++;
  8009ef:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f2:	ff 45 fc             	incl   -0x4(%ebp)
  8009f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009f8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009fb:	72 d9                	jb     8009d6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a00:	c9                   	leave  
  800a01:	c3                   	ret    

00800a02 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a12:	74 30                	je     800a44 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a14:	eb 16                	jmp    800a2c <strlcpy+0x2a>
			*dst++ = *src++;
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8d 50 01             	lea    0x1(%eax),%edx
  800a1c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a22:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a25:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a28:	8a 12                	mov    (%edx),%dl
  800a2a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a2c:	ff 4d 10             	decl   0x10(%ebp)
  800a2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a33:	74 09                	je     800a3e <strlcpy+0x3c>
  800a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a38:	8a 00                	mov    (%eax),%al
  800a3a:	84 c0                	test   %al,%al
  800a3c:	75 d8                	jne    800a16 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a44:	8b 55 08             	mov    0x8(%ebp),%edx
  800a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a4a:	29 c2                	sub    %eax,%edx
  800a4c:	89 d0                	mov    %edx,%eax
}
  800a4e:	c9                   	leave  
  800a4f:	c3                   	ret    

00800a50 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a53:	eb 06                	jmp    800a5b <strcmp+0xb>
		p++, q++;
  800a55:	ff 45 08             	incl   0x8(%ebp)
  800a58:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	8a 00                	mov    (%eax),%al
  800a60:	84 c0                	test   %al,%al
  800a62:	74 0e                	je     800a72 <strcmp+0x22>
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	8a 10                	mov    (%eax),%dl
  800a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6c:	8a 00                	mov    (%eax),%al
  800a6e:	38 c2                	cmp    %al,%dl
  800a70:	74 e3                	je     800a55 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	8a 00                	mov    (%eax),%al
  800a77:	0f b6 d0             	movzbl %al,%edx
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	8a 00                	mov    (%eax),%al
  800a7f:	0f b6 c0             	movzbl %al,%eax
  800a82:	29 c2                	sub    %eax,%edx
  800a84:	89 d0                	mov    %edx,%eax
}
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a8b:	eb 09                	jmp    800a96 <strncmp+0xe>
		n--, p++, q++;
  800a8d:	ff 4d 10             	decl   0x10(%ebp)
  800a90:	ff 45 08             	incl   0x8(%ebp)
  800a93:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a9a:	74 17                	je     800ab3 <strncmp+0x2b>
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8a 00                	mov    (%eax),%al
  800aa1:	84 c0                	test   %al,%al
  800aa3:	74 0e                	je     800ab3 <strncmp+0x2b>
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8a 10                	mov    (%eax),%dl
  800aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aad:	8a 00                	mov    (%eax),%al
  800aaf:	38 c2                	cmp    %al,%dl
  800ab1:	74 da                	je     800a8d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ab3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab7:	75 07                	jne    800ac0 <strncmp+0x38>
		return 0;
  800ab9:	b8 00 00 00 00       	mov    $0x0,%eax
  800abe:	eb 14                	jmp    800ad4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8a 00                	mov    (%eax),%al
  800ac5:	0f b6 d0             	movzbl %al,%edx
  800ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acb:	8a 00                	mov    (%eax),%al
  800acd:	0f b6 c0             	movzbl %al,%eax
  800ad0:	29 c2                	sub    %eax,%edx
  800ad2:	89 d0                	mov    %edx,%eax
}
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ae2:	eb 12                	jmp    800af6 <strchr+0x20>
		if (*s == c)
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	8a 00                	mov    (%eax),%al
  800ae9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800aec:	75 05                	jne    800af3 <strchr+0x1d>
			return (char *) s;
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	eb 11                	jmp    800b04 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800af3:	ff 45 08             	incl   0x8(%ebp)
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8a 00                	mov    (%eax),%al
  800afb:	84 c0                	test   %al,%al
  800afd:	75 e5                	jne    800ae4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800aff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b04:	c9                   	leave  
  800b05:	c3                   	ret    

00800b06 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 04             	sub    $0x4,%esp
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b12:	eb 0d                	jmp    800b21 <strfind+0x1b>
		if (*s == c)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b1c:	74 0e                	je     800b2c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b1e:	ff 45 08             	incl   0x8(%ebp)
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	8a 00                	mov    (%eax),%al
  800b26:	84 c0                	test   %al,%al
  800b28:	75 ea                	jne    800b14 <strfind+0xe>
  800b2a:	eb 01                	jmp    800b2d <strfind+0x27>
		if (*s == c)
			break;
  800b2c:	90                   	nop
	return (char *) s;
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b30:	c9                   	leave  
  800b31:	c3                   	ret    

00800b32 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b41:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b44:	eb 0e                	jmp    800b54 <memset+0x22>
		*p++ = c;
  800b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b49:	8d 50 01             	lea    0x1(%eax),%edx
  800b4c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b52:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b54:	ff 4d f8             	decl   -0x8(%ebp)
  800b57:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b5b:	79 e9                	jns    800b46 <memset+0x14>
		*p++ = c;

	return v;
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b60:	c9                   	leave  
  800b61:	c3                   	ret    

00800b62 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b74:	eb 16                	jmp    800b8c <memcpy+0x2a>
		*d++ = *s++;
  800b76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b79:	8d 50 01             	lea    0x1(%eax),%edx
  800b7c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b7f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b85:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b88:	8a 12                	mov    (%edx),%dl
  800b8a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b92:	89 55 10             	mov    %edx,0x10(%ebp)
  800b95:	85 c0                	test   %eax,%eax
  800b97:	75 dd                	jne    800b76 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b9c:	c9                   	leave  
  800b9d:	c3                   	ret    

00800b9e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bb6:	73 50                	jae    800c08 <memmove+0x6a>
  800bb8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbe:	01 d0                	add    %edx,%eax
  800bc0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bc3:	76 43                	jbe    800c08 <memmove+0x6a>
		s += n;
  800bc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bce:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bd1:	eb 10                	jmp    800be3 <memmove+0x45>
			*--d = *--s;
  800bd3:	ff 4d f8             	decl   -0x8(%ebp)
  800bd6:	ff 4d fc             	decl   -0x4(%ebp)
  800bd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bdc:	8a 10                	mov    (%eax),%dl
  800bde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800be3:	8b 45 10             	mov    0x10(%ebp),%eax
  800be6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bec:	85 c0                	test   %eax,%eax
  800bee:	75 e3                	jne    800bd3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf0:	eb 23                	jmp    800c15 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bf2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf5:	8d 50 01             	lea    0x1(%eax),%edx
  800bf8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bfb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bfe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c01:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c04:	8a 12                	mov    (%edx),%dl
  800c06:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	85 c0                	test   %eax,%eax
  800c13:	75 dd                	jne    800bf2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    

00800c1a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c2c:	eb 2a                	jmp    800c58 <memcmp+0x3e>
		if (*s1 != *s2)
  800c2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c31:	8a 10                	mov    (%eax),%dl
  800c33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	38 c2                	cmp    %al,%dl
  800c3a:	74 16                	je     800c52 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	0f b6 d0             	movzbl %al,%edx
  800c44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c47:	8a 00                	mov    (%eax),%al
  800c49:	0f b6 c0             	movzbl %al,%eax
  800c4c:	29 c2                	sub    %eax,%edx
  800c4e:	89 d0                	mov    %edx,%eax
  800c50:	eb 18                	jmp    800c6a <memcmp+0x50>
		s1++, s2++;
  800c52:	ff 45 fc             	incl   -0x4(%ebp)
  800c55:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c58:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c5e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c61:	85 c0                	test   %eax,%eax
  800c63:	75 c9                	jne    800c2e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c72:	8b 55 08             	mov    0x8(%ebp),%edx
  800c75:	8b 45 10             	mov    0x10(%ebp),%eax
  800c78:	01 d0                	add    %edx,%eax
  800c7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c7d:	eb 15                	jmp    800c94 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8a 00                	mov    (%eax),%al
  800c84:	0f b6 d0             	movzbl %al,%edx
  800c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8a:	0f b6 c0             	movzbl %al,%eax
  800c8d:	39 c2                	cmp    %eax,%edx
  800c8f:	74 0d                	je     800c9e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c91:	ff 45 08             	incl   0x8(%ebp)
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c9a:	72 e3                	jb     800c7f <memfind+0x13>
  800c9c:	eb 01                	jmp    800c9f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c9e:	90                   	nop
	return (void *) s;
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cb1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb8:	eb 03                	jmp    800cbd <strtol+0x19>
		s++;
  800cba:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	3c 20                	cmp    $0x20,%al
  800cc4:	74 f4                	je     800cba <strtol+0x16>
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8a 00                	mov    (%eax),%al
  800ccb:	3c 09                	cmp    $0x9,%al
  800ccd:	74 eb                	je     800cba <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	3c 2b                	cmp    $0x2b,%al
  800cd6:	75 05                	jne    800cdd <strtol+0x39>
		s++;
  800cd8:	ff 45 08             	incl   0x8(%ebp)
  800cdb:	eb 13                	jmp    800cf0 <strtol+0x4c>
	else if (*s == '-')
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	3c 2d                	cmp    $0x2d,%al
  800ce4:	75 0a                	jne    800cf0 <strtol+0x4c>
		s++, neg = 1;
  800ce6:	ff 45 08             	incl   0x8(%ebp)
  800ce9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf4:	74 06                	je     800cfc <strtol+0x58>
  800cf6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cfa:	75 20                	jne    800d1c <strtol+0x78>
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	3c 30                	cmp    $0x30,%al
  800d03:	75 17                	jne    800d1c <strtol+0x78>
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	40                   	inc    %eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	3c 78                	cmp    $0x78,%al
  800d0d:	75 0d                	jne    800d1c <strtol+0x78>
		s += 2, base = 16;
  800d0f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d13:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d1a:	eb 28                	jmp    800d44 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d20:	75 15                	jne    800d37 <strtol+0x93>
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	3c 30                	cmp    $0x30,%al
  800d29:	75 0c                	jne    800d37 <strtol+0x93>
		s++, base = 8;
  800d2b:	ff 45 08             	incl   0x8(%ebp)
  800d2e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d35:	eb 0d                	jmp    800d44 <strtol+0xa0>
	else if (base == 0)
  800d37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3b:	75 07                	jne    800d44 <strtol+0xa0>
		base = 10;
  800d3d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	3c 2f                	cmp    $0x2f,%al
  800d4b:	7e 19                	jle    800d66 <strtol+0xc2>
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	3c 39                	cmp    $0x39,%al
  800d54:	7f 10                	jg     800d66 <strtol+0xc2>
			dig = *s - '0';
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	0f be c0             	movsbl %al,%eax
  800d5e:	83 e8 30             	sub    $0x30,%eax
  800d61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d64:	eb 42                	jmp    800da8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	3c 60                	cmp    $0x60,%al
  800d6d:	7e 19                	jle    800d88 <strtol+0xe4>
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	3c 7a                	cmp    $0x7a,%al
  800d76:	7f 10                	jg     800d88 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f be c0             	movsbl %al,%eax
  800d80:	83 e8 57             	sub    $0x57,%eax
  800d83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d86:	eb 20                	jmp    800da8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 40                	cmp    $0x40,%al
  800d8f:	7e 39                	jle    800dca <strtol+0x126>
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	3c 5a                	cmp    $0x5a,%al
  800d98:	7f 30                	jg     800dca <strtol+0x126>
			dig = *s - 'A' + 10;
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	0f be c0             	movsbl %al,%eax
  800da2:	83 e8 37             	sub    $0x37,%eax
  800da5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dab:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dae:	7d 19                	jge    800dc9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800db0:	ff 45 08             	incl   0x8(%ebp)
  800db3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dba:	89 c2                	mov    %eax,%edx
  800dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dbf:	01 d0                	add    %edx,%eax
  800dc1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dc4:	e9 7b ff ff ff       	jmp    800d44 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dc9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dce:	74 08                	je     800dd8 <strtol+0x134>
		*endptr = (char *) s;
  800dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ddc:	74 07                	je     800de5 <strtol+0x141>
  800dde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de1:	f7 d8                	neg    %eax
  800de3:	eb 03                	jmp    800de8 <strtol+0x144>
  800de5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de8:	c9                   	leave  
  800de9:	c3                   	ret    

00800dea <ltostr>:

void
ltostr(long value, char *str)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800df0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800df7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e02:	79 13                	jns    800e17 <ltostr+0x2d>
	{
		neg = 1;
  800e04:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e11:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e14:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e1f:	99                   	cltd   
  800e20:	f7 f9                	idiv   %ecx
  800e22:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e28:	8d 50 01             	lea    0x1(%eax),%edx
  800e2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2e:	89 c2                	mov    %eax,%edx
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	01 d0                	add    %edx,%eax
  800e35:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e38:	83 c2 30             	add    $0x30,%edx
  800e3b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e40:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e45:	f7 e9                	imul   %ecx
  800e47:	c1 fa 02             	sar    $0x2,%edx
  800e4a:	89 c8                	mov    %ecx,%eax
  800e4c:	c1 f8 1f             	sar    $0x1f,%eax
  800e4f:	29 c2                	sub    %eax,%edx
  800e51:	89 d0                	mov    %edx,%eax
  800e53:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e59:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e5e:	f7 e9                	imul   %ecx
  800e60:	c1 fa 02             	sar    $0x2,%edx
  800e63:	89 c8                	mov    %ecx,%eax
  800e65:	c1 f8 1f             	sar    $0x1f,%eax
  800e68:	29 c2                	sub    %eax,%edx
  800e6a:	89 d0                	mov    %edx,%eax
  800e6c:	c1 e0 02             	shl    $0x2,%eax
  800e6f:	01 d0                	add    %edx,%eax
  800e71:	01 c0                	add    %eax,%eax
  800e73:	29 c1                	sub    %eax,%ecx
  800e75:	89 ca                	mov    %ecx,%edx
  800e77:	85 d2                	test   %edx,%edx
  800e79:	75 9c                	jne    800e17 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	48                   	dec    %eax
  800e86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e89:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e8d:	74 3d                	je     800ecc <ltostr+0xe2>
		start = 1 ;
  800e8f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e96:	eb 34                	jmp    800ecc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	01 d0                	add    %edx,%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	01 c2                	add    %eax,%edx
  800ead:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	01 c8                	add    %ecx,%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800eb9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	01 c2                	add    %eax,%edx
  800ec1:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ec4:	88 02                	mov    %al,(%edx)
		start++ ;
  800ec6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ec9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ecf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ed2:	7c c4                	jl     800e98 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ed4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eda:	01 d0                	add    %edx,%eax
  800edc:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800edf:	90                   	nop
  800ee0:	c9                   	leave  
  800ee1:	c3                   	ret    

00800ee2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ee8:	ff 75 08             	pushl  0x8(%ebp)
  800eeb:	e8 54 fa ff ff       	call   800944 <strlen>
  800ef0:	83 c4 04             	add    $0x4,%esp
  800ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ef6:	ff 75 0c             	pushl  0xc(%ebp)
  800ef9:	e8 46 fa ff ff       	call   800944 <strlen>
  800efe:	83 c4 04             	add    $0x4,%esp
  800f01:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f12:	eb 17                	jmp    800f2b <strcconcat+0x49>
		final[s] = str1[s] ;
  800f14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	01 c2                	add    %eax,%edx
  800f1c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	01 c8                	add    %ecx,%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f28:	ff 45 fc             	incl   -0x4(%ebp)
  800f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f31:	7c e1                	jl     800f14 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f3a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f41:	eb 1f                	jmp    800f62 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f46:	8d 50 01             	lea    0x1(%eax),%edx
  800f49:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f4c:	89 c2                	mov    %eax,%edx
  800f4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f51:	01 c2                	add    %eax,%edx
  800f53:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	01 c8                	add    %ecx,%eax
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f5f:	ff 45 f8             	incl   -0x8(%ebp)
  800f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f65:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f68:	7c d9                	jl     800f43 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f6a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f70:	01 d0                	add    %edx,%eax
  800f72:	c6 00 00             	movb   $0x0,(%eax)
}
  800f75:	90                   	nop
  800f76:	c9                   	leave  
  800f77:	c3                   	ret    

00800f78 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f84:	8b 45 14             	mov    0x14(%ebp),%eax
  800f87:	8b 00                	mov    (%eax),%eax
  800f89:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f90:	8b 45 10             	mov    0x10(%ebp),%eax
  800f93:	01 d0                	add    %edx,%eax
  800f95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f9b:	eb 0c                	jmp    800fa9 <strsplit+0x31>
			*string++ = 0;
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8d 50 01             	lea    0x1(%eax),%edx
  800fa3:	89 55 08             	mov    %edx,0x8(%ebp)
  800fa6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	84 c0                	test   %al,%al
  800fb0:	74 18                	je     800fca <strsplit+0x52>
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	0f be c0             	movsbl %al,%eax
  800fba:	50                   	push   %eax
  800fbb:	ff 75 0c             	pushl  0xc(%ebp)
  800fbe:	e8 13 fb ff ff       	call   800ad6 <strchr>
  800fc3:	83 c4 08             	add    $0x8,%esp
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	75 d3                	jne    800f9d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	84 c0                	test   %al,%al
  800fd1:	74 5a                	je     80102d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd6:	8b 00                	mov    (%eax),%eax
  800fd8:	83 f8 0f             	cmp    $0xf,%eax
  800fdb:	75 07                	jne    800fe4 <strsplit+0x6c>
		{
			return 0;
  800fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe2:	eb 66                	jmp    80104a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fe4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe7:	8b 00                	mov    (%eax),%eax
  800fe9:	8d 48 01             	lea    0x1(%eax),%ecx
  800fec:	8b 55 14             	mov    0x14(%ebp),%edx
  800fef:	89 0a                	mov    %ecx,(%edx)
  800ff1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ff8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffb:	01 c2                	add    %eax,%edx
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801002:	eb 03                	jmp    801007 <strsplit+0x8f>
			string++;
  801004:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	84 c0                	test   %al,%al
  80100e:	74 8b                	je     800f9b <strsplit+0x23>
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	0f be c0             	movsbl %al,%eax
  801018:	50                   	push   %eax
  801019:	ff 75 0c             	pushl  0xc(%ebp)
  80101c:	e8 b5 fa ff ff       	call   800ad6 <strchr>
  801021:	83 c4 08             	add    $0x8,%esp
  801024:	85 c0                	test   %eax,%eax
  801026:	74 dc                	je     801004 <strsplit+0x8c>
			string++;
	}
  801028:	e9 6e ff ff ff       	jmp    800f9b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80102d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80102e:	8b 45 14             	mov    0x14(%ebp),%eax
  801031:	8b 00                	mov    (%eax),%eax
  801033:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103a:	8b 45 10             	mov    0x10(%ebp),%eax
  80103d:	01 d0                	add    %edx,%eax
  80103f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801045:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80104a:	c9                   	leave  
  80104b:	c3                   	ret    

0080104c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	57                   	push   %edi
  801050:	56                   	push   %esi
  801051:	53                   	push   %ebx
  801052:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80105e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801061:	8b 7d 18             	mov    0x18(%ebp),%edi
  801064:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801067:	cd 30                	int    $0x30
  801069:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80106c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80106f:	83 c4 10             	add    $0x10,%esp
  801072:	5b                   	pop    %ebx
  801073:	5e                   	pop    %esi
  801074:	5f                   	pop    %edi
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 04             	sub    $0x4,%esp
  80107d:	8b 45 10             	mov    0x10(%ebp),%eax
  801080:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801083:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	6a 00                	push   $0x0
  80108c:	6a 00                	push   $0x0
  80108e:	52                   	push   %edx
  80108f:	ff 75 0c             	pushl  0xc(%ebp)
  801092:	50                   	push   %eax
  801093:	6a 00                	push   $0x0
  801095:	e8 b2 ff ff ff       	call   80104c <syscall>
  80109a:	83 c4 18             	add    $0x18,%esp
}
  80109d:	90                   	nop
  80109e:	c9                   	leave  
  80109f:	c3                   	ret    

008010a0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010a3:	6a 00                	push   $0x0
  8010a5:	6a 00                	push   $0x0
  8010a7:	6a 00                	push   $0x0
  8010a9:	6a 00                	push   $0x0
  8010ab:	6a 00                	push   $0x0
  8010ad:	6a 01                	push   $0x1
  8010af:	e8 98 ff ff ff       	call   80104c <syscall>
  8010b4:	83 c4 18             	add    $0x18,%esp
}
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    

008010b9 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	6a 00                	push   $0x0
  8010c1:	6a 00                	push   $0x0
  8010c3:	6a 00                	push   $0x0
  8010c5:	6a 00                	push   $0x0
  8010c7:	50                   	push   %eax
  8010c8:	6a 05                	push   $0x5
  8010ca:	e8 7d ff ff ff       	call   80104c <syscall>
  8010cf:	83 c4 18             	add    $0x18,%esp
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8010d7:	6a 00                	push   $0x0
  8010d9:	6a 00                	push   $0x0
  8010db:	6a 00                	push   $0x0
  8010dd:	6a 00                	push   $0x0
  8010df:	6a 00                	push   $0x0
  8010e1:	6a 02                	push   $0x2
  8010e3:	e8 64 ff ff ff       	call   80104c <syscall>
  8010e8:	83 c4 18             	add    $0x18,%esp
}
  8010eb:	c9                   	leave  
  8010ec:	c3                   	ret    

008010ed <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8010f0:	6a 00                	push   $0x0
  8010f2:	6a 00                	push   $0x0
  8010f4:	6a 00                	push   $0x0
  8010f6:	6a 00                	push   $0x0
  8010f8:	6a 00                	push   $0x0
  8010fa:	6a 03                	push   $0x3
  8010fc:	e8 4b ff ff ff       	call   80104c <syscall>
  801101:	83 c4 18             	add    $0x18,%esp
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801109:	6a 00                	push   $0x0
  80110b:	6a 00                	push   $0x0
  80110d:	6a 00                	push   $0x0
  80110f:	6a 00                	push   $0x0
  801111:	6a 00                	push   $0x0
  801113:	6a 04                	push   $0x4
  801115:	e8 32 ff ff ff       	call   80104c <syscall>
  80111a:	83 c4 18             	add    $0x18,%esp
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <sys_env_exit>:


void sys_env_exit(void)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	6a 00                	push   $0x0
  801128:	6a 00                	push   $0x0
  80112a:	6a 00                	push   $0x0
  80112c:	6a 06                	push   $0x6
  80112e:	e8 19 ff ff ff       	call   80104c <syscall>
  801133:	83 c4 18             	add    $0x18,%esp
}
  801136:	90                   	nop
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80113c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	6a 00                	push   $0x0
  801144:	6a 00                	push   $0x0
  801146:	6a 00                	push   $0x0
  801148:	52                   	push   %edx
  801149:	50                   	push   %eax
  80114a:	6a 07                	push   $0x7
  80114c:	e8 fb fe ff ff       	call   80104c <syscall>
  801151:	83 c4 18             	add    $0x18,%esp
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	56                   	push   %esi
  80115a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80115b:	8b 75 18             	mov    0x18(%ebp),%esi
  80115e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801161:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801164:	8b 55 0c             	mov    0xc(%ebp),%edx
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	56                   	push   %esi
  80116b:	53                   	push   %ebx
  80116c:	51                   	push   %ecx
  80116d:	52                   	push   %edx
  80116e:	50                   	push   %eax
  80116f:	6a 08                	push   $0x8
  801171:	e8 d6 fe ff ff       	call   80104c <syscall>
  801176:	83 c4 18             	add    $0x18,%esp
}
  801179:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80117c:	5b                   	pop    %ebx
  80117d:	5e                   	pop    %esi
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    

00801180 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801183:	8b 55 0c             	mov    0xc(%ebp),%edx
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	6a 00                	push   $0x0
  80118b:	6a 00                	push   $0x0
  80118d:	6a 00                	push   $0x0
  80118f:	52                   	push   %edx
  801190:	50                   	push   %eax
  801191:	6a 09                	push   $0x9
  801193:	e8 b4 fe ff ff       	call   80104c <syscall>
  801198:	83 c4 18             	add    $0x18,%esp
}
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    

0080119d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8011a0:	6a 00                	push   $0x0
  8011a2:	6a 00                	push   $0x0
  8011a4:	6a 00                	push   $0x0
  8011a6:	ff 75 0c             	pushl  0xc(%ebp)
  8011a9:	ff 75 08             	pushl  0x8(%ebp)
  8011ac:	6a 0a                	push   $0xa
  8011ae:	e8 99 fe ff ff       	call   80104c <syscall>
  8011b3:	83 c4 18             	add    $0x18,%esp
}
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    

008011b8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8011bb:	6a 00                	push   $0x0
  8011bd:	6a 00                	push   $0x0
  8011bf:	6a 00                	push   $0x0
  8011c1:	6a 00                	push   $0x0
  8011c3:	6a 00                	push   $0x0
  8011c5:	6a 0b                	push   $0xb
  8011c7:	e8 80 fe ff ff       	call   80104c <syscall>
  8011cc:	83 c4 18             	add    $0x18,%esp
}
  8011cf:	c9                   	leave  
  8011d0:	c3                   	ret    

008011d1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011d4:	6a 00                	push   $0x0
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 00                	push   $0x0
  8011da:	6a 00                	push   $0x0
  8011dc:	6a 00                	push   $0x0
  8011de:	6a 0c                	push   $0xc
  8011e0:	e8 67 fe ff ff       	call   80104c <syscall>
  8011e5:	83 c4 18             	add    $0x18,%esp
}
  8011e8:	c9                   	leave  
  8011e9:	c3                   	ret    

008011ea <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011ed:	6a 00                	push   $0x0
  8011ef:	6a 00                	push   $0x0
  8011f1:	6a 00                	push   $0x0
  8011f3:	6a 00                	push   $0x0
  8011f5:	6a 00                	push   $0x0
  8011f7:	6a 0d                	push   $0xd
  8011f9:	e8 4e fe ff ff       	call   80104c <syscall>
  8011fe:	83 c4 18             	add    $0x18,%esp
}
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801206:	6a 00                	push   $0x0
  801208:	6a 00                	push   $0x0
  80120a:	6a 00                	push   $0x0
  80120c:	ff 75 0c             	pushl  0xc(%ebp)
  80120f:	ff 75 08             	pushl  0x8(%ebp)
  801212:	6a 11                	push   $0x11
  801214:	e8 33 fe ff ff       	call   80104c <syscall>
  801219:	83 c4 18             	add    $0x18,%esp
	return;
  80121c:	90                   	nop
}
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    

0080121f <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801222:	6a 00                	push   $0x0
  801224:	6a 00                	push   $0x0
  801226:	6a 00                	push   $0x0
  801228:	ff 75 0c             	pushl  0xc(%ebp)
  80122b:	ff 75 08             	pushl  0x8(%ebp)
  80122e:	6a 12                	push   $0x12
  801230:	e8 17 fe ff ff       	call   80104c <syscall>
  801235:	83 c4 18             	add    $0x18,%esp
	return ;
  801238:	90                   	nop
}
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80123e:	6a 00                	push   $0x0
  801240:	6a 00                	push   $0x0
  801242:	6a 00                	push   $0x0
  801244:	6a 00                	push   $0x0
  801246:	6a 00                	push   $0x0
  801248:	6a 0e                	push   $0xe
  80124a:	e8 fd fd ff ff       	call   80104c <syscall>
  80124f:	83 c4 18             	add    $0x18,%esp
}
  801252:	c9                   	leave  
  801253:	c3                   	ret    

00801254 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801257:	6a 00                	push   $0x0
  801259:	6a 00                	push   $0x0
  80125b:	6a 00                	push   $0x0
  80125d:	6a 00                	push   $0x0
  80125f:	ff 75 08             	pushl  0x8(%ebp)
  801262:	6a 0f                	push   $0xf
  801264:	e8 e3 fd ff ff       	call   80104c <syscall>
  801269:	83 c4 18             	add    $0x18,%esp
}
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801271:	6a 00                	push   $0x0
  801273:	6a 00                	push   $0x0
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	6a 10                	push   $0x10
  80127d:	e8 ca fd ff ff       	call   80104c <syscall>
  801282:	83 c4 18             	add    $0x18,%esp
}
  801285:	90                   	nop
  801286:	c9                   	leave  
  801287:	c3                   	ret    

00801288 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 14                	push   $0x14
  801297:	e8 b0 fd ff ff       	call   80104c <syscall>
  80129c:	83 c4 18             	add    $0x18,%esp
}
  80129f:	90                   	nop
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    

008012a2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8012a5:	6a 00                	push   $0x0
  8012a7:	6a 00                	push   $0x0
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 15                	push   $0x15
  8012b1:	e8 96 fd ff ff       	call   80104c <syscall>
  8012b6:	83 c4 18             	add    $0x18,%esp
}
  8012b9:	90                   	nop
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <sys_cputc>:


void
sys_cputc(const char c)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 04             	sub    $0x4,%esp
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8012c8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8012cc:	6a 00                	push   $0x0
  8012ce:	6a 00                	push   $0x0
  8012d0:	6a 00                	push   $0x0
  8012d2:	6a 00                	push   $0x0
  8012d4:	50                   	push   %eax
  8012d5:	6a 16                	push   $0x16
  8012d7:	e8 70 fd ff ff       	call   80104c <syscall>
  8012dc:	83 c4 18             	add    $0x18,%esp
}
  8012df:	90                   	nop
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    

008012e2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 17                	push   $0x17
  8012f1:	e8 56 fd ff ff       	call   80104c <syscall>
  8012f6:	83 c4 18             	add    $0x18,%esp
}
  8012f9:	90                   	nop
  8012fa:	c9                   	leave  
  8012fb:	c3                   	ret    

008012fc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	6a 00                	push   $0x0
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	ff 75 0c             	pushl  0xc(%ebp)
  80130b:	50                   	push   %eax
  80130c:	6a 18                	push   $0x18
  80130e:	e8 39 fd ff ff       	call   80104c <syscall>
  801313:	83 c4 18             	add    $0x18,%esp
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80131b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	52                   	push   %edx
  801328:	50                   	push   %eax
  801329:	6a 1b                	push   $0x1b
  80132b:	e8 1c fd ff ff       	call   80104c <syscall>
  801330:	83 c4 18             	add    $0x18,%esp
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801338:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	52                   	push   %edx
  801345:	50                   	push   %eax
  801346:	6a 19                	push   $0x19
  801348:	e8 ff fc ff ff       	call   80104c <syscall>
  80134d:	83 c4 18             	add    $0x18,%esp
}
  801350:	90                   	nop
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801356:	8b 55 0c             	mov    0xc(%ebp),%edx
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	52                   	push   %edx
  801363:	50                   	push   %eax
  801364:	6a 1a                	push   $0x1a
  801366:	e8 e1 fc ff ff       	call   80104c <syscall>
  80136b:	83 c4 18             	add    $0x18,%esp
}
  80136e:	90                   	nop
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	83 ec 04             	sub    $0x4,%esp
  801377:	8b 45 10             	mov    0x10(%ebp),%eax
  80137a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80137d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801380:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	6a 00                	push   $0x0
  801389:	51                   	push   %ecx
  80138a:	52                   	push   %edx
  80138b:	ff 75 0c             	pushl  0xc(%ebp)
  80138e:	50                   	push   %eax
  80138f:	6a 1c                	push   $0x1c
  801391:	e8 b6 fc ff ff       	call   80104c <syscall>
  801396:	83 c4 18             	add    $0x18,%esp
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80139e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	52                   	push   %edx
  8013ab:	50                   	push   %eax
  8013ac:	6a 1d                	push   $0x1d
  8013ae:	e8 99 fc ff ff       	call   80104c <syscall>
  8013b3:	83 c4 18             	add    $0x18,%esp
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8013bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	51                   	push   %ecx
  8013c9:	52                   	push   %edx
  8013ca:	50                   	push   %eax
  8013cb:	6a 1e                	push   $0x1e
  8013cd:	e8 7a fc ff ff       	call   80104c <syscall>
  8013d2:	83 c4 18             	add    $0x18,%esp
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8013da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	52                   	push   %edx
  8013e7:	50                   	push   %eax
  8013e8:	6a 1f                	push   $0x1f
  8013ea:	e8 5d fc ff ff       	call   80104c <syscall>
  8013ef:	83 c4 18             	add    $0x18,%esp
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 20                	push   $0x20
  801403:	e8 44 fc ff ff       	call   80104c <syscall>
  801408:	83 c4 18             	add    $0x18,%esp
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	ff 75 10             	pushl  0x10(%ebp)
  80141a:	ff 75 0c             	pushl  0xc(%ebp)
  80141d:	50                   	push   %eax
  80141e:	6a 21                	push   $0x21
  801420:	e8 27 fc ff ff       	call   80104c <syscall>
  801425:	83 c4 18             	add    $0x18,%esp
}
  801428:	c9                   	leave  
  801429:	c3                   	ret    

0080142a <sys_run_env>:


void
sys_run_env(int32 envId)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	50                   	push   %eax
  801439:	6a 22                	push   $0x22
  80143b:	e8 0c fc ff ff       	call   80104c <syscall>
  801440:	83 c4 18             	add    $0x18,%esp
}
  801443:	90                   	nop
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	50                   	push   %eax
  801455:	6a 23                	push   $0x23
  801457:	e8 f0 fb ff ff       	call   80104c <syscall>
  80145c:	83 c4 18             	add    $0x18,%esp
}
  80145f:	90                   	nop
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801468:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80146b:	8d 50 04             	lea    0x4(%eax),%edx
  80146e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	52                   	push   %edx
  801478:	50                   	push   %eax
  801479:	6a 24                	push   $0x24
  80147b:	e8 cc fb ff ff       	call   80104c <syscall>
  801480:	83 c4 18             	add    $0x18,%esp
	return result;
  801483:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801486:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801489:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148c:	89 01                	mov    %eax,(%ecx)
  80148e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	c9                   	leave  
  801495:	c2 04 00             	ret    $0x4

00801498 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	ff 75 10             	pushl  0x10(%ebp)
  8014a2:	ff 75 0c             	pushl  0xc(%ebp)
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	6a 13                	push   $0x13
  8014aa:	e8 9d fb ff ff       	call   80104c <syscall>
  8014af:	83 c4 18             	add    $0x18,%esp
	return ;
  8014b2:	90                   	nop
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 25                	push   $0x25
  8014c4:	e8 83 fb ff ff       	call   80104c <syscall>
  8014c9:	83 c4 18             	add    $0x18,%esp
}
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    

008014ce <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014da:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	50                   	push   %eax
  8014e7:	6a 26                	push   $0x26
  8014e9:	e8 5e fb ff ff       	call   80104c <syscall>
  8014ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8014f1:	90                   	nop
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <rsttst>:
void rsttst()
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 28                	push   $0x28
  801503:	e8 44 fb ff ff       	call   80104c <syscall>
  801508:	83 c4 18             	add    $0x18,%esp
	return ;
  80150b:	90                   	nop
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	8b 45 14             	mov    0x14(%ebp),%eax
  801517:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80151a:	8b 55 18             	mov    0x18(%ebp),%edx
  80151d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801521:	52                   	push   %edx
  801522:	50                   	push   %eax
  801523:	ff 75 10             	pushl  0x10(%ebp)
  801526:	ff 75 0c             	pushl  0xc(%ebp)
  801529:	ff 75 08             	pushl  0x8(%ebp)
  80152c:	6a 27                	push   $0x27
  80152e:	e8 19 fb ff ff       	call   80104c <syscall>
  801533:	83 c4 18             	add    $0x18,%esp
	return ;
  801536:	90                   	nop
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <chktst>:
void chktst(uint32 n)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	ff 75 08             	pushl  0x8(%ebp)
  801547:	6a 29                	push   $0x29
  801549:	e8 fe fa ff ff       	call   80104c <syscall>
  80154e:	83 c4 18             	add    $0x18,%esp
	return ;
  801551:	90                   	nop
}
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <inctst>:

void inctst()
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 2a                	push   $0x2a
  801563:	e8 e4 fa ff ff       	call   80104c <syscall>
  801568:	83 c4 18             	add    $0x18,%esp
	return ;
  80156b:	90                   	nop
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <gettst>:
uint32 gettst()
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 2b                	push   $0x2b
  80157d:	e8 ca fa ff ff       	call   80104c <syscall>
  801582:	83 c4 18             	add    $0x18,%esp
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 2c                	push   $0x2c
  801599:	e8 ae fa ff ff       	call   80104c <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
  8015a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8015a4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8015a8:	75 07                	jne    8015b1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8015aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8015af:	eb 05                	jmp    8015b6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 2c                	push   $0x2c
  8015ca:	e8 7d fa ff ff       	call   80104c <syscall>
  8015cf:	83 c4 18             	add    $0x18,%esp
  8015d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015d5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015d9:	75 07                	jne    8015e2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015db:	b8 01 00 00 00       	mov    $0x1,%eax
  8015e0:	eb 05                	jmp    8015e7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 2c                	push   $0x2c
  8015fb:	e8 4c fa ff ff       	call   80104c <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
  801603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801606:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80160a:	75 07                	jne    801613 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80160c:	b8 01 00 00 00       	mov    $0x1,%eax
  801611:	eb 05                	jmp    801618 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801613:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 2c                	push   $0x2c
  80162c:	e8 1b fa ff ff       	call   80104c <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
  801634:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801637:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80163b:	75 07                	jne    801644 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80163d:	b8 01 00 00 00       	mov    $0x1,%eax
  801642:	eb 05                	jmp    801649 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801644:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	ff 75 08             	pushl  0x8(%ebp)
  801659:	6a 2d                	push   $0x2d
  80165b:	e8 ec f9 ff ff       	call   80104c <syscall>
  801660:	83 c4 18             	add    $0x18,%esp
	return ;
  801663:	90                   	nop
}
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80166a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80166d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801670:	8b 55 0c             	mov    0xc(%ebp),%edx
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	6a 00                	push   $0x0
  801678:	53                   	push   %ebx
  801679:	51                   	push   %ecx
  80167a:	52                   	push   %edx
  80167b:	50                   	push   %eax
  80167c:	6a 2e                	push   $0x2e
  80167e:	e8 c9 f9 ff ff       	call   80104c <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
}
  801686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80168e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	52                   	push   %edx
  80169b:	50                   	push   %eax
  80169c:	6a 2f                	push   $0x2f
  80169e:	e8 a9 f9 ff ff       	call   80104c <syscall>
  8016a3:	83 c4 18             	add    $0x18,%esp
}
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8016ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b1:	89 d0                	mov    %edx,%eax
  8016b3:	c1 e0 02             	shl    $0x2,%eax
  8016b6:	01 d0                	add    %edx,%eax
  8016b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016bf:	01 d0                	add    %edx,%eax
  8016c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016c8:	01 d0                	add    %edx,%eax
  8016ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016d1:	01 d0                	add    %edx,%eax
  8016d3:	c1 e0 04             	shl    $0x4,%eax
  8016d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8016d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8016e0:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8016e3:	83 ec 0c             	sub    $0xc,%esp
  8016e6:	50                   	push   %eax
  8016e7:	e8 76 fd ff ff       	call   801462 <sys_get_virtual_time>
  8016ec:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8016ef:	eb 41                	jmp    801732 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8016f1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016f4:	83 ec 0c             	sub    $0xc,%esp
  8016f7:	50                   	push   %eax
  8016f8:	e8 65 fd ff ff       	call   801462 <sys_get_virtual_time>
  8016fd:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801700:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801703:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801706:	29 c2                	sub    %eax,%edx
  801708:	89 d0                	mov    %edx,%eax
  80170a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80170d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801710:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801713:	89 d1                	mov    %edx,%ecx
  801715:	29 c1                	sub    %eax,%ecx
  801717:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80171a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80171d:	39 c2                	cmp    %eax,%edx
  80171f:	0f 97 c0             	seta   %al
  801722:	0f b6 c0             	movzbl %al,%eax
  801725:	29 c1                	sub    %eax,%ecx
  801727:	89 c8                	mov    %ecx,%eax
  801729:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80172c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80172f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801735:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801738:	72 b7                	jb     8016f1 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80173a:	90                   	nop
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801743:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80174a:	eb 03                	jmp    80174f <busy_wait+0x12>
  80174c:	ff 45 fc             	incl   -0x4(%ebp)
  80174f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801752:	3b 45 08             	cmp    0x8(%ebp),%eax
  801755:	72 f5                	jb     80174c <busy_wait+0xf>
	return i;
  801757:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <__udivdi3>:
  80175c:	55                   	push   %ebp
  80175d:	57                   	push   %edi
  80175e:	56                   	push   %esi
  80175f:	53                   	push   %ebx
  801760:	83 ec 1c             	sub    $0x1c,%esp
  801763:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801767:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80176b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80176f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801773:	89 ca                	mov    %ecx,%edx
  801775:	89 f8                	mov    %edi,%eax
  801777:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80177b:	85 f6                	test   %esi,%esi
  80177d:	75 2d                	jne    8017ac <__udivdi3+0x50>
  80177f:	39 cf                	cmp    %ecx,%edi
  801781:	77 65                	ja     8017e8 <__udivdi3+0x8c>
  801783:	89 fd                	mov    %edi,%ebp
  801785:	85 ff                	test   %edi,%edi
  801787:	75 0b                	jne    801794 <__udivdi3+0x38>
  801789:	b8 01 00 00 00       	mov    $0x1,%eax
  80178e:	31 d2                	xor    %edx,%edx
  801790:	f7 f7                	div    %edi
  801792:	89 c5                	mov    %eax,%ebp
  801794:	31 d2                	xor    %edx,%edx
  801796:	89 c8                	mov    %ecx,%eax
  801798:	f7 f5                	div    %ebp
  80179a:	89 c1                	mov    %eax,%ecx
  80179c:	89 d8                	mov    %ebx,%eax
  80179e:	f7 f5                	div    %ebp
  8017a0:	89 cf                	mov    %ecx,%edi
  8017a2:	89 fa                	mov    %edi,%edx
  8017a4:	83 c4 1c             	add    $0x1c,%esp
  8017a7:	5b                   	pop    %ebx
  8017a8:	5e                   	pop    %esi
  8017a9:	5f                   	pop    %edi
  8017aa:	5d                   	pop    %ebp
  8017ab:	c3                   	ret    
  8017ac:	39 ce                	cmp    %ecx,%esi
  8017ae:	77 28                	ja     8017d8 <__udivdi3+0x7c>
  8017b0:	0f bd fe             	bsr    %esi,%edi
  8017b3:	83 f7 1f             	xor    $0x1f,%edi
  8017b6:	75 40                	jne    8017f8 <__udivdi3+0x9c>
  8017b8:	39 ce                	cmp    %ecx,%esi
  8017ba:	72 0a                	jb     8017c6 <__udivdi3+0x6a>
  8017bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8017c0:	0f 87 9e 00 00 00    	ja     801864 <__udivdi3+0x108>
  8017c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8017cb:	89 fa                	mov    %edi,%edx
  8017cd:	83 c4 1c             	add    $0x1c,%esp
  8017d0:	5b                   	pop    %ebx
  8017d1:	5e                   	pop    %esi
  8017d2:	5f                   	pop    %edi
  8017d3:	5d                   	pop    %ebp
  8017d4:	c3                   	ret    
  8017d5:	8d 76 00             	lea    0x0(%esi),%esi
  8017d8:	31 ff                	xor    %edi,%edi
  8017da:	31 c0                	xor    %eax,%eax
  8017dc:	89 fa                	mov    %edi,%edx
  8017de:	83 c4 1c             	add    $0x1c,%esp
  8017e1:	5b                   	pop    %ebx
  8017e2:	5e                   	pop    %esi
  8017e3:	5f                   	pop    %edi
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    
  8017e6:	66 90                	xchg   %ax,%ax
  8017e8:	89 d8                	mov    %ebx,%eax
  8017ea:	f7 f7                	div    %edi
  8017ec:	31 ff                	xor    %edi,%edi
  8017ee:	89 fa                	mov    %edi,%edx
  8017f0:	83 c4 1c             	add    $0x1c,%esp
  8017f3:	5b                   	pop    %ebx
  8017f4:	5e                   	pop    %esi
  8017f5:	5f                   	pop    %edi
  8017f6:	5d                   	pop    %ebp
  8017f7:	c3                   	ret    
  8017f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8017fd:	89 eb                	mov    %ebp,%ebx
  8017ff:	29 fb                	sub    %edi,%ebx
  801801:	89 f9                	mov    %edi,%ecx
  801803:	d3 e6                	shl    %cl,%esi
  801805:	89 c5                	mov    %eax,%ebp
  801807:	88 d9                	mov    %bl,%cl
  801809:	d3 ed                	shr    %cl,%ebp
  80180b:	89 e9                	mov    %ebp,%ecx
  80180d:	09 f1                	or     %esi,%ecx
  80180f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801813:	89 f9                	mov    %edi,%ecx
  801815:	d3 e0                	shl    %cl,%eax
  801817:	89 c5                	mov    %eax,%ebp
  801819:	89 d6                	mov    %edx,%esi
  80181b:	88 d9                	mov    %bl,%cl
  80181d:	d3 ee                	shr    %cl,%esi
  80181f:	89 f9                	mov    %edi,%ecx
  801821:	d3 e2                	shl    %cl,%edx
  801823:	8b 44 24 08          	mov    0x8(%esp),%eax
  801827:	88 d9                	mov    %bl,%cl
  801829:	d3 e8                	shr    %cl,%eax
  80182b:	09 c2                	or     %eax,%edx
  80182d:	89 d0                	mov    %edx,%eax
  80182f:	89 f2                	mov    %esi,%edx
  801831:	f7 74 24 0c          	divl   0xc(%esp)
  801835:	89 d6                	mov    %edx,%esi
  801837:	89 c3                	mov    %eax,%ebx
  801839:	f7 e5                	mul    %ebp
  80183b:	39 d6                	cmp    %edx,%esi
  80183d:	72 19                	jb     801858 <__udivdi3+0xfc>
  80183f:	74 0b                	je     80184c <__udivdi3+0xf0>
  801841:	89 d8                	mov    %ebx,%eax
  801843:	31 ff                	xor    %edi,%edi
  801845:	e9 58 ff ff ff       	jmp    8017a2 <__udivdi3+0x46>
  80184a:	66 90                	xchg   %ax,%ax
  80184c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801850:	89 f9                	mov    %edi,%ecx
  801852:	d3 e2                	shl    %cl,%edx
  801854:	39 c2                	cmp    %eax,%edx
  801856:	73 e9                	jae    801841 <__udivdi3+0xe5>
  801858:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80185b:	31 ff                	xor    %edi,%edi
  80185d:	e9 40 ff ff ff       	jmp    8017a2 <__udivdi3+0x46>
  801862:	66 90                	xchg   %ax,%ax
  801864:	31 c0                	xor    %eax,%eax
  801866:	e9 37 ff ff ff       	jmp    8017a2 <__udivdi3+0x46>
  80186b:	90                   	nop

0080186c <__umoddi3>:
  80186c:	55                   	push   %ebp
  80186d:	57                   	push   %edi
  80186e:	56                   	push   %esi
  80186f:	53                   	push   %ebx
  801870:	83 ec 1c             	sub    $0x1c,%esp
  801873:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801877:	8b 74 24 34          	mov    0x34(%esp),%esi
  80187b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80187f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801883:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801887:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80188b:	89 f3                	mov    %esi,%ebx
  80188d:	89 fa                	mov    %edi,%edx
  80188f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801893:	89 34 24             	mov    %esi,(%esp)
  801896:	85 c0                	test   %eax,%eax
  801898:	75 1a                	jne    8018b4 <__umoddi3+0x48>
  80189a:	39 f7                	cmp    %esi,%edi
  80189c:	0f 86 a2 00 00 00    	jbe    801944 <__umoddi3+0xd8>
  8018a2:	89 c8                	mov    %ecx,%eax
  8018a4:	89 f2                	mov    %esi,%edx
  8018a6:	f7 f7                	div    %edi
  8018a8:	89 d0                	mov    %edx,%eax
  8018aa:	31 d2                	xor    %edx,%edx
  8018ac:	83 c4 1c             	add    $0x1c,%esp
  8018af:	5b                   	pop    %ebx
  8018b0:	5e                   	pop    %esi
  8018b1:	5f                   	pop    %edi
  8018b2:	5d                   	pop    %ebp
  8018b3:	c3                   	ret    
  8018b4:	39 f0                	cmp    %esi,%eax
  8018b6:	0f 87 ac 00 00 00    	ja     801968 <__umoddi3+0xfc>
  8018bc:	0f bd e8             	bsr    %eax,%ebp
  8018bf:	83 f5 1f             	xor    $0x1f,%ebp
  8018c2:	0f 84 ac 00 00 00    	je     801974 <__umoddi3+0x108>
  8018c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8018cd:	29 ef                	sub    %ebp,%edi
  8018cf:	89 fe                	mov    %edi,%esi
  8018d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018d5:	89 e9                	mov    %ebp,%ecx
  8018d7:	d3 e0                	shl    %cl,%eax
  8018d9:	89 d7                	mov    %edx,%edi
  8018db:	89 f1                	mov    %esi,%ecx
  8018dd:	d3 ef                	shr    %cl,%edi
  8018df:	09 c7                	or     %eax,%edi
  8018e1:	89 e9                	mov    %ebp,%ecx
  8018e3:	d3 e2                	shl    %cl,%edx
  8018e5:	89 14 24             	mov    %edx,(%esp)
  8018e8:	89 d8                	mov    %ebx,%eax
  8018ea:	d3 e0                	shl    %cl,%eax
  8018ec:	89 c2                	mov    %eax,%edx
  8018ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018f2:	d3 e0                	shl    %cl,%eax
  8018f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018fc:	89 f1                	mov    %esi,%ecx
  8018fe:	d3 e8                	shr    %cl,%eax
  801900:	09 d0                	or     %edx,%eax
  801902:	d3 eb                	shr    %cl,%ebx
  801904:	89 da                	mov    %ebx,%edx
  801906:	f7 f7                	div    %edi
  801908:	89 d3                	mov    %edx,%ebx
  80190a:	f7 24 24             	mull   (%esp)
  80190d:	89 c6                	mov    %eax,%esi
  80190f:	89 d1                	mov    %edx,%ecx
  801911:	39 d3                	cmp    %edx,%ebx
  801913:	0f 82 87 00 00 00    	jb     8019a0 <__umoddi3+0x134>
  801919:	0f 84 91 00 00 00    	je     8019b0 <__umoddi3+0x144>
  80191f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801923:	29 f2                	sub    %esi,%edx
  801925:	19 cb                	sbb    %ecx,%ebx
  801927:	89 d8                	mov    %ebx,%eax
  801929:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80192d:	d3 e0                	shl    %cl,%eax
  80192f:	89 e9                	mov    %ebp,%ecx
  801931:	d3 ea                	shr    %cl,%edx
  801933:	09 d0                	or     %edx,%eax
  801935:	89 e9                	mov    %ebp,%ecx
  801937:	d3 eb                	shr    %cl,%ebx
  801939:	89 da                	mov    %ebx,%edx
  80193b:	83 c4 1c             	add    $0x1c,%esp
  80193e:	5b                   	pop    %ebx
  80193f:	5e                   	pop    %esi
  801940:	5f                   	pop    %edi
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    
  801943:	90                   	nop
  801944:	89 fd                	mov    %edi,%ebp
  801946:	85 ff                	test   %edi,%edi
  801948:	75 0b                	jne    801955 <__umoddi3+0xe9>
  80194a:	b8 01 00 00 00       	mov    $0x1,%eax
  80194f:	31 d2                	xor    %edx,%edx
  801951:	f7 f7                	div    %edi
  801953:	89 c5                	mov    %eax,%ebp
  801955:	89 f0                	mov    %esi,%eax
  801957:	31 d2                	xor    %edx,%edx
  801959:	f7 f5                	div    %ebp
  80195b:	89 c8                	mov    %ecx,%eax
  80195d:	f7 f5                	div    %ebp
  80195f:	89 d0                	mov    %edx,%eax
  801961:	e9 44 ff ff ff       	jmp    8018aa <__umoddi3+0x3e>
  801966:	66 90                	xchg   %ax,%ax
  801968:	89 c8                	mov    %ecx,%eax
  80196a:	89 f2                	mov    %esi,%edx
  80196c:	83 c4 1c             	add    $0x1c,%esp
  80196f:	5b                   	pop    %ebx
  801970:	5e                   	pop    %esi
  801971:	5f                   	pop    %edi
  801972:	5d                   	pop    %ebp
  801973:	c3                   	ret    
  801974:	3b 04 24             	cmp    (%esp),%eax
  801977:	72 06                	jb     80197f <__umoddi3+0x113>
  801979:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80197d:	77 0f                	ja     80198e <__umoddi3+0x122>
  80197f:	89 f2                	mov    %esi,%edx
  801981:	29 f9                	sub    %edi,%ecx
  801983:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801987:	89 14 24             	mov    %edx,(%esp)
  80198a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80198e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801992:	8b 14 24             	mov    (%esp),%edx
  801995:	83 c4 1c             	add    $0x1c,%esp
  801998:	5b                   	pop    %ebx
  801999:	5e                   	pop    %esi
  80199a:	5f                   	pop    %edi
  80199b:	5d                   	pop    %ebp
  80199c:	c3                   	ret    
  80199d:	8d 76 00             	lea    0x0(%esi),%esi
  8019a0:	2b 04 24             	sub    (%esp),%eax
  8019a3:	19 fa                	sbb    %edi,%edx
  8019a5:	89 d1                	mov    %edx,%ecx
  8019a7:	89 c6                	mov    %eax,%esi
  8019a9:	e9 71 ff ff ff       	jmp    80191f <__umoddi3+0xb3>
  8019ae:	66 90                	xchg   %ax,%ax
  8019b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8019b4:	72 ea                	jb     8019a0 <__umoddi3+0x134>
  8019b6:	89 d9                	mov    %ebx,%ecx
  8019b8:	e9 62 ff ff ff       	jmp    80191f <__umoddi3+0xb3>
