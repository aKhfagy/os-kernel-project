
obj/user/tst_CPU_MLFQ_slave_1_1:     file format elf32-i386


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
  800031:	e8 a6 00 00 00       	call   8000dc <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int ID;
	for (int i = 0; i < 3; ++i) {
  80003e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800045:	eb 39                	jmp    800080 <_main+0x48>
		ID = sys_create_env("dummy_process", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
  800047:	a1 20 20 80 00       	mov    0x802020,%eax
  80004c:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800052:	a1 20 20 80 00       	mov    0x802020,%eax
  800057:	8b 40 74             	mov    0x74(%eax),%eax
  80005a:	83 ec 04             	sub    $0x4,%esp
  80005d:	52                   	push   %edx
  80005e:	50                   	push   %eax
  80005f:	68 00 1a 80 00       	push   $0x801a00
  800064:	e8 d7 13 00 00       	call   801440 <sys_create_env>
  800069:	83 c4 10             	add    $0x10,%esp
  80006c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_run_env(ID);
  80006f:	83 ec 0c             	sub    $0xc,%esp
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 e3 13 00 00       	call   80145d <sys_run_env>
  80007a:	83 c4 10             	add    $0x10,%esp
#include <inc/lib.h>

void _main(void)
{
	int ID;
	for (int i = 0; i < 3; ++i) {
  80007d:	ff 45 f4             	incl   -0xc(%ebp)
  800080:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
  800084:	7e c1                	jle    800047 <_main+0xf>
		ID = sys_create_env("dummy_process", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
		sys_run_env(ID);
	}
	env_sleep(50);
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	6a 32                	push   $0x32
  80008b:	e8 4b 16 00 00       	call   8016db <env_sleep>
  800090:	83 c4 10             	add    $0x10,%esp

	ID = sys_create_env("cpuMLFQ1Slave_2", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  800093:	a1 20 20 80 00       	mov    0x802020,%eax
  800098:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80009e:	a1 20 20 80 00       	mov    0x802020,%eax
  8000a3:	8b 40 74             	mov    0x74(%eax),%eax
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	52                   	push   %edx
  8000aa:	50                   	push   %eax
  8000ab:	68 0e 1a 80 00       	push   $0x801a0e
  8000b0:	e8 8b 13 00 00       	call   801440 <sys_create_env>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID);
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	ff 75 f0             	pushl  -0x10(%ebp)
  8000c1:	e8 97 13 00 00       	call   80145d <sys_run_env>
  8000c6:	83 c4 10             	add    $0x10,%esp

	env_sleep(5000);
  8000c9:	83 ec 0c             	sub    $0xc,%esp
  8000cc:	68 88 13 00 00       	push   $0x1388
  8000d1:	e8 05 16 00 00       	call   8016db <env_sleep>
  8000d6:	83 c4 10             	add    $0x10,%esp

	return;
  8000d9:	90                   	nop
}
  8000da:	c9                   	leave  
  8000db:	c3                   	ret    

008000dc <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e2:	e8 39 10 00 00       	call   801120 <sys_getenvindex>
  8000e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000ed:	89 d0                	mov    %edx,%eax
  8000ef:	c1 e0 03             	shl    $0x3,%eax
  8000f2:	01 d0                	add    %edx,%eax
  8000f4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000fb:	01 c8                	add    %ecx,%eax
  8000fd:	01 c0                	add    %eax,%eax
  8000ff:	01 d0                	add    %edx,%eax
  800101:	01 c0                	add    %eax,%eax
  800103:	01 d0                	add    %edx,%eax
  800105:	89 c2                	mov    %eax,%edx
  800107:	c1 e2 05             	shl    $0x5,%edx
  80010a:	29 c2                	sub    %eax,%edx
  80010c:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800113:	89 c2                	mov    %eax,%edx
  800115:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80011b:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800120:	a1 20 20 80 00       	mov    0x802020,%eax
  800125:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80012b:	84 c0                	test   %al,%al
  80012d:	74 0f                	je     80013e <libmain+0x62>
		binaryname = myEnv->prog_name;
  80012f:	a1 20 20 80 00       	mov    0x802020,%eax
  800134:	05 40 3c 01 00       	add    $0x13c40,%eax
  800139:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800142:	7e 0a                	jle    80014e <libmain+0x72>
		binaryname = argv[0];
  800144:	8b 45 0c             	mov    0xc(%ebp),%eax
  800147:	8b 00                	mov    (%eax),%eax
  800149:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  80014e:	83 ec 08             	sub    $0x8,%esp
  800151:	ff 75 0c             	pushl  0xc(%ebp)
  800154:	ff 75 08             	pushl  0x8(%ebp)
  800157:	e8 dc fe ff ff       	call   800038 <_main>
  80015c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80015f:	e8 57 11 00 00       	call   8012bb <sys_disable_interrupt>
	cprintf("**************************************\n");
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	68 38 1a 80 00       	push   $0x801a38
  80016c:	e8 84 01 00 00       	call   8002f5 <cprintf>
  800171:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800174:	a1 20 20 80 00       	mov    0x802020,%eax
  800179:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80017f:	a1 20 20 80 00       	mov    0x802020,%eax
  800184:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80018a:	83 ec 04             	sub    $0x4,%esp
  80018d:	52                   	push   %edx
  80018e:	50                   	push   %eax
  80018f:	68 60 1a 80 00       	push   $0x801a60
  800194:	e8 5c 01 00 00       	call   8002f5 <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80019c:	a1 20 20 80 00       	mov    0x802020,%eax
  8001a1:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8001a7:	a1 20 20 80 00       	mov    0x802020,%eax
  8001ac:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8001b2:	83 ec 04             	sub    $0x4,%esp
  8001b5:	52                   	push   %edx
  8001b6:	50                   	push   %eax
  8001b7:	68 88 1a 80 00       	push   $0x801a88
  8001bc:	e8 34 01 00 00       	call   8002f5 <cprintf>
  8001c1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001c4:	a1 20 20 80 00       	mov    0x802020,%eax
  8001c9:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8001cf:	83 ec 08             	sub    $0x8,%esp
  8001d2:	50                   	push   %eax
  8001d3:	68 c9 1a 80 00       	push   $0x801ac9
  8001d8:	e8 18 01 00 00       	call   8002f5 <cprintf>
  8001dd:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001e0:	83 ec 0c             	sub    $0xc,%esp
  8001e3:	68 38 1a 80 00       	push   $0x801a38
  8001e8:	e8 08 01 00 00       	call   8002f5 <cprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001f0:	e8 e0 10 00 00       	call   8012d5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001f5:	e8 19 00 00 00       	call   800213 <exit>
}
  8001fa:	90                   	nop
  8001fb:	c9                   	leave  
  8001fc:	c3                   	ret    

008001fd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001fd:	55                   	push   %ebp
  8001fe:	89 e5                	mov    %esp,%ebp
  800200:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	6a 00                	push   $0x0
  800208:	e8 df 0e 00 00       	call   8010ec <sys_env_destroy>
  80020d:	83 c4 10             	add    $0x10,%esp
}
  800210:	90                   	nop
  800211:	c9                   	leave  
  800212:	c3                   	ret    

00800213 <exit>:

void
exit(void)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800219:	e8 34 0f 00 00       	call   801152 <sys_env_exit>
}
  80021e:	90                   	nop
  80021f:	c9                   	leave  
  800220:	c3                   	ret    

00800221 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022a:	8b 00                	mov    (%eax),%eax
  80022c:	8d 48 01             	lea    0x1(%eax),%ecx
  80022f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800232:	89 0a                	mov    %ecx,(%edx)
  800234:	8b 55 08             	mov    0x8(%ebp),%edx
  800237:	88 d1                	mov    %dl,%cl
  800239:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800240:	8b 45 0c             	mov    0xc(%ebp),%eax
  800243:	8b 00                	mov    (%eax),%eax
  800245:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024a:	75 2c                	jne    800278 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80024c:	a0 24 20 80 00       	mov    0x802024,%al
  800251:	0f b6 c0             	movzbl %al,%eax
  800254:	8b 55 0c             	mov    0xc(%ebp),%edx
  800257:	8b 12                	mov    (%edx),%edx
  800259:	89 d1                	mov    %edx,%ecx
  80025b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025e:	83 c2 08             	add    $0x8,%edx
  800261:	83 ec 04             	sub    $0x4,%esp
  800264:	50                   	push   %eax
  800265:	51                   	push   %ecx
  800266:	52                   	push   %edx
  800267:	e8 3e 0e 00 00       	call   8010aa <sys_cputs>
  80026c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80026f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800272:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027b:	8b 40 04             	mov    0x4(%eax),%eax
  80027e:	8d 50 01             	lea    0x1(%eax),%edx
  800281:	8b 45 0c             	mov    0xc(%ebp),%eax
  800284:	89 50 04             	mov    %edx,0x4(%eax)
}
  800287:	90                   	nop
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800293:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80029a:	00 00 00 
	b.cnt = 0;
  80029d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002a7:	ff 75 0c             	pushl  0xc(%ebp)
  8002aa:	ff 75 08             	pushl  0x8(%ebp)
  8002ad:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b3:	50                   	push   %eax
  8002b4:	68 21 02 80 00       	push   $0x800221
  8002b9:	e8 11 02 00 00       	call   8004cf <vprintfmt>
  8002be:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002c1:	a0 24 20 80 00       	mov    0x802024,%al
  8002c6:	0f b6 c0             	movzbl %al,%eax
  8002c9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	50                   	push   %eax
  8002d3:	52                   	push   %edx
  8002d4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002da:	83 c0 08             	add    $0x8,%eax
  8002dd:	50                   	push   %eax
  8002de:	e8 c7 0d 00 00       	call   8010aa <sys_cputs>
  8002e3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002e6:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8002ed:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002fb:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  800302:	8d 45 0c             	lea    0xc(%ebp),%eax
  800305:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	83 ec 08             	sub    $0x8,%esp
  80030e:	ff 75 f4             	pushl  -0xc(%ebp)
  800311:	50                   	push   %eax
  800312:	e8 73 ff ff ff       	call   80028a <vcprintf>
  800317:	83 c4 10             	add    $0x10,%esp
  80031a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80031d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800320:	c9                   	leave  
  800321:	c3                   	ret    

00800322 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800328:	e8 8e 0f 00 00       	call   8012bb <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80032d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800330:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800333:	8b 45 08             	mov    0x8(%ebp),%eax
  800336:	83 ec 08             	sub    $0x8,%esp
  800339:	ff 75 f4             	pushl  -0xc(%ebp)
  80033c:	50                   	push   %eax
  80033d:	e8 48 ff ff ff       	call   80028a <vcprintf>
  800342:	83 c4 10             	add    $0x10,%esp
  800345:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800348:	e8 88 0f 00 00       	call   8012d5 <sys_enable_interrupt>
	return cnt;
  80034d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800350:	c9                   	leave  
  800351:	c3                   	ret    

00800352 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800352:	55                   	push   %ebp
  800353:	89 e5                	mov    %esp,%ebp
  800355:	53                   	push   %ebx
  800356:	83 ec 14             	sub    $0x14,%esp
  800359:	8b 45 10             	mov    0x10(%ebp),%eax
  80035c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80035f:	8b 45 14             	mov    0x14(%ebp),%eax
  800362:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800365:	8b 45 18             	mov    0x18(%ebp),%eax
  800368:	ba 00 00 00 00       	mov    $0x0,%edx
  80036d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800370:	77 55                	ja     8003c7 <printnum+0x75>
  800372:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800375:	72 05                	jb     80037c <printnum+0x2a>
  800377:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80037a:	77 4b                	ja     8003c7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80037c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80037f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800382:	8b 45 18             	mov    0x18(%ebp),%eax
  800385:	ba 00 00 00 00       	mov    $0x0,%edx
  80038a:	52                   	push   %edx
  80038b:	50                   	push   %eax
  80038c:	ff 75 f4             	pushl  -0xc(%ebp)
  80038f:	ff 75 f0             	pushl  -0x10(%ebp)
  800392:	e8 f9 13 00 00       	call   801790 <__udivdi3>
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	83 ec 04             	sub    $0x4,%esp
  80039d:	ff 75 20             	pushl  0x20(%ebp)
  8003a0:	53                   	push   %ebx
  8003a1:	ff 75 18             	pushl  0x18(%ebp)
  8003a4:	52                   	push   %edx
  8003a5:	50                   	push   %eax
  8003a6:	ff 75 0c             	pushl  0xc(%ebp)
  8003a9:	ff 75 08             	pushl  0x8(%ebp)
  8003ac:	e8 a1 ff ff ff       	call   800352 <printnum>
  8003b1:	83 c4 20             	add    $0x20,%esp
  8003b4:	eb 1a                	jmp    8003d0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	ff 75 0c             	pushl  0xc(%ebp)
  8003bc:	ff 75 20             	pushl  0x20(%ebp)
  8003bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c2:	ff d0                	call   *%eax
  8003c4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c7:	ff 4d 1c             	decl   0x1c(%ebp)
  8003ca:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003ce:	7f e6                	jg     8003b6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003de:	53                   	push   %ebx
  8003df:	51                   	push   %ecx
  8003e0:	52                   	push   %edx
  8003e1:	50                   	push   %eax
  8003e2:	e8 b9 14 00 00       	call   8018a0 <__umoddi3>
  8003e7:	83 c4 10             	add    $0x10,%esp
  8003ea:	05 f4 1c 80 00       	add    $0x801cf4,%eax
  8003ef:	8a 00                	mov    (%eax),%al
  8003f1:	0f be c0             	movsbl %al,%eax
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	ff 75 0c             	pushl  0xc(%ebp)
  8003fa:	50                   	push   %eax
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	ff d0                	call   *%eax
  800400:	83 c4 10             	add    $0x10,%esp
}
  800403:	90                   	nop
  800404:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80040c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800410:	7e 1c                	jle    80042e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	8b 00                	mov    (%eax),%eax
  800417:	8d 50 08             	lea    0x8(%eax),%edx
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	89 10                	mov    %edx,(%eax)
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
  800422:	8b 00                	mov    (%eax),%eax
  800424:	83 e8 08             	sub    $0x8,%eax
  800427:	8b 50 04             	mov    0x4(%eax),%edx
  80042a:	8b 00                	mov    (%eax),%eax
  80042c:	eb 40                	jmp    80046e <getuint+0x65>
	else if (lflag)
  80042e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800432:	74 1e                	je     800452 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800434:	8b 45 08             	mov    0x8(%ebp),%eax
  800437:	8b 00                	mov    (%eax),%eax
  800439:	8d 50 04             	lea    0x4(%eax),%edx
  80043c:	8b 45 08             	mov    0x8(%ebp),%eax
  80043f:	89 10                	mov    %edx,(%eax)
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	83 e8 04             	sub    $0x4,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	ba 00 00 00 00       	mov    $0x0,%edx
  800450:	eb 1c                	jmp    80046e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800452:	8b 45 08             	mov    0x8(%ebp),%eax
  800455:	8b 00                	mov    (%eax),%eax
  800457:	8d 50 04             	lea    0x4(%eax),%edx
  80045a:	8b 45 08             	mov    0x8(%ebp),%eax
  80045d:	89 10                	mov    %edx,(%eax)
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 e8 04             	sub    $0x4,%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80046e:	5d                   	pop    %ebp
  80046f:	c3                   	ret    

00800470 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800473:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800477:	7e 1c                	jle    800495 <getint+0x25>
		return va_arg(*ap, long long);
  800479:	8b 45 08             	mov    0x8(%ebp),%eax
  80047c:	8b 00                	mov    (%eax),%eax
  80047e:	8d 50 08             	lea    0x8(%eax),%edx
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	89 10                	mov    %edx,(%eax)
  800486:	8b 45 08             	mov    0x8(%ebp),%eax
  800489:	8b 00                	mov    (%eax),%eax
  80048b:	83 e8 08             	sub    $0x8,%eax
  80048e:	8b 50 04             	mov    0x4(%eax),%edx
  800491:	8b 00                	mov    (%eax),%eax
  800493:	eb 38                	jmp    8004cd <getint+0x5d>
	else if (lflag)
  800495:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800499:	74 1a                	je     8004b5 <getint+0x45>
		return va_arg(*ap, long);
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	8d 50 04             	lea    0x4(%eax),%edx
  8004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a6:	89 10                	mov    %edx,(%eax)
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	83 e8 04             	sub    $0x4,%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	99                   	cltd   
  8004b3:	eb 18                	jmp    8004cd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	8d 50 04             	lea    0x4(%eax),%edx
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	89 10                	mov    %edx,(%eax)
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	83 e8 04             	sub    $0x4,%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	99                   	cltd   
}
  8004cd:	5d                   	pop    %ebp
  8004ce:	c3                   	ret    

008004cf <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
  8004d2:	56                   	push   %esi
  8004d3:	53                   	push   %ebx
  8004d4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d7:	eb 17                	jmp    8004f0 <vprintfmt+0x21>
			if (ch == '\0')
  8004d9:	85 db                	test   %ebx,%ebx
  8004db:	0f 84 af 03 00 00    	je     800890 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004e1:	83 ec 08             	sub    $0x8,%esp
  8004e4:	ff 75 0c             	pushl  0xc(%ebp)
  8004e7:	53                   	push   %ebx
  8004e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004eb:	ff d0                	call   *%eax
  8004ed:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f3:	8d 50 01             	lea    0x1(%eax),%edx
  8004f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f9:	8a 00                	mov    (%eax),%al
  8004fb:	0f b6 d8             	movzbl %al,%ebx
  8004fe:	83 fb 25             	cmp    $0x25,%ebx
  800501:	75 d6                	jne    8004d9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800503:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800507:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80050e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800515:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80051c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800523:	8b 45 10             	mov    0x10(%ebp),%eax
  800526:	8d 50 01             	lea    0x1(%eax),%edx
  800529:	89 55 10             	mov    %edx,0x10(%ebp)
  80052c:	8a 00                	mov    (%eax),%al
  80052e:	0f b6 d8             	movzbl %al,%ebx
  800531:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800534:	83 f8 55             	cmp    $0x55,%eax
  800537:	0f 87 2b 03 00 00    	ja     800868 <vprintfmt+0x399>
  80053d:	8b 04 85 18 1d 80 00 	mov    0x801d18(,%eax,4),%eax
  800544:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800546:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80054a:	eb d7                	jmp    800523 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80054c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800550:	eb d1                	jmp    800523 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800552:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800559:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80055c:	89 d0                	mov    %edx,%eax
  80055e:	c1 e0 02             	shl    $0x2,%eax
  800561:	01 d0                	add    %edx,%eax
  800563:	01 c0                	add    %eax,%eax
  800565:	01 d8                	add    %ebx,%eax
  800567:	83 e8 30             	sub    $0x30,%eax
  80056a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80056d:	8b 45 10             	mov    0x10(%ebp),%eax
  800570:	8a 00                	mov    (%eax),%al
  800572:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800575:	83 fb 2f             	cmp    $0x2f,%ebx
  800578:	7e 3e                	jle    8005b8 <vprintfmt+0xe9>
  80057a:	83 fb 39             	cmp    $0x39,%ebx
  80057d:	7f 39                	jg     8005b8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80057f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800582:	eb d5                	jmp    800559 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	83 c0 04             	add    $0x4,%eax
  80058a:	89 45 14             	mov    %eax,0x14(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	83 e8 04             	sub    $0x4,%eax
  800593:	8b 00                	mov    (%eax),%eax
  800595:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800598:	eb 1f                	jmp    8005b9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80059a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80059e:	79 83                	jns    800523 <vprintfmt+0x54>
				width = 0;
  8005a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005a7:	e9 77 ff ff ff       	jmp    800523 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005ac:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005b3:	e9 6b ff ff ff       	jmp    800523 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005b8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005bd:	0f 89 60 ff ff ff    	jns    800523 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005d0:	e9 4e ff ff ff       	jmp    800523 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005d5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005d8:	e9 46 ff ff ff       	jmp    800523 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	83 c0 04             	add    $0x4,%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	83 e8 04             	sub    $0x4,%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	ff 75 0c             	pushl  0xc(%ebp)
  8005f4:	50                   	push   %eax
  8005f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f8:	ff d0                	call   *%eax
  8005fa:	83 c4 10             	add    $0x10,%esp
			break;
  8005fd:	e9 89 02 00 00       	jmp    80088b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	83 c0 04             	add    $0x4,%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	83 e8 04             	sub    $0x4,%eax
  800611:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800613:	85 db                	test   %ebx,%ebx
  800615:	79 02                	jns    800619 <vprintfmt+0x14a>
				err = -err;
  800617:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800619:	83 fb 64             	cmp    $0x64,%ebx
  80061c:	7f 0b                	jg     800629 <vprintfmt+0x15a>
  80061e:	8b 34 9d 60 1b 80 00 	mov    0x801b60(,%ebx,4),%esi
  800625:	85 f6                	test   %esi,%esi
  800627:	75 19                	jne    800642 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800629:	53                   	push   %ebx
  80062a:	68 05 1d 80 00       	push   $0x801d05
  80062f:	ff 75 0c             	pushl  0xc(%ebp)
  800632:	ff 75 08             	pushl  0x8(%ebp)
  800635:	e8 5e 02 00 00       	call   800898 <printfmt>
  80063a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80063d:	e9 49 02 00 00       	jmp    80088b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800642:	56                   	push   %esi
  800643:	68 0e 1d 80 00       	push   $0x801d0e
  800648:	ff 75 0c             	pushl  0xc(%ebp)
  80064b:	ff 75 08             	pushl  0x8(%ebp)
  80064e:	e8 45 02 00 00       	call   800898 <printfmt>
  800653:	83 c4 10             	add    $0x10,%esp
			break;
  800656:	e9 30 02 00 00       	jmp    80088b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	83 c0 04             	add    $0x4,%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	83 e8 04             	sub    $0x4,%eax
  80066a:	8b 30                	mov    (%eax),%esi
  80066c:	85 f6                	test   %esi,%esi
  80066e:	75 05                	jne    800675 <vprintfmt+0x1a6>
				p = "(null)";
  800670:	be 11 1d 80 00       	mov    $0x801d11,%esi
			if (width > 0 && padc != '-')
  800675:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800679:	7e 6d                	jle    8006e8 <vprintfmt+0x219>
  80067b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80067f:	74 67                	je     8006e8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800681:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	50                   	push   %eax
  800688:	56                   	push   %esi
  800689:	e8 0c 03 00 00       	call   80099a <strnlen>
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800694:	eb 16                	jmp    8006ac <vprintfmt+0x1dd>
					putch(padc, putdat);
  800696:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	ff 75 0c             	pushl  0xc(%ebp)
  8006a0:	50                   	push   %eax
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	ff d0                	call   *%eax
  8006a6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a9:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b0:	7f e4                	jg     800696 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b2:	eb 34                	jmp    8006e8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006b8:	74 1c                	je     8006d6 <vprintfmt+0x207>
  8006ba:	83 fb 1f             	cmp    $0x1f,%ebx
  8006bd:	7e 05                	jle    8006c4 <vprintfmt+0x1f5>
  8006bf:	83 fb 7e             	cmp    $0x7e,%ebx
  8006c2:	7e 12                	jle    8006d6 <vprintfmt+0x207>
					putch('?', putdat);
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ca:	6a 3f                	push   $0x3f
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	ff d0                	call   *%eax
  8006d1:	83 c4 10             	add    $0x10,%esp
  8006d4:	eb 0f                	jmp    8006e5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006d6:	83 ec 08             	sub    $0x8,%esp
  8006d9:	ff 75 0c             	pushl  0xc(%ebp)
  8006dc:	53                   	push   %ebx
  8006dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e0:	ff d0                	call   *%eax
  8006e2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e5:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e8:	89 f0                	mov    %esi,%eax
  8006ea:	8d 70 01             	lea    0x1(%eax),%esi
  8006ed:	8a 00                	mov    (%eax),%al
  8006ef:	0f be d8             	movsbl %al,%ebx
  8006f2:	85 db                	test   %ebx,%ebx
  8006f4:	74 24                	je     80071a <vprintfmt+0x24b>
  8006f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006fa:	78 b8                	js     8006b4 <vprintfmt+0x1e5>
  8006fc:	ff 4d e0             	decl   -0x20(%ebp)
  8006ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800703:	79 af                	jns    8006b4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800705:	eb 13                	jmp    80071a <vprintfmt+0x24b>
				putch(' ', putdat);
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	ff 75 0c             	pushl  0xc(%ebp)
  80070d:	6a 20                	push   $0x20
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	ff d0                	call   *%eax
  800714:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800717:	ff 4d e4             	decl   -0x1c(%ebp)
  80071a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071e:	7f e7                	jg     800707 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800720:	e9 66 01 00 00       	jmp    80088b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	ff 75 e8             	pushl  -0x18(%ebp)
  80072b:	8d 45 14             	lea    0x14(%ebp),%eax
  80072e:	50                   	push   %eax
  80072f:	e8 3c fd ff ff       	call   800470 <getint>
  800734:	83 c4 10             	add    $0x10,%esp
  800737:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80073a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80073d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800740:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800743:	85 d2                	test   %edx,%edx
  800745:	79 23                	jns    80076a <vprintfmt+0x29b>
				putch('-', putdat);
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	ff 75 0c             	pushl  0xc(%ebp)
  80074d:	6a 2d                	push   $0x2d
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	ff d0                	call   *%eax
  800754:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80075d:	f7 d8                	neg    %eax
  80075f:	83 d2 00             	adc    $0x0,%edx
  800762:	f7 da                	neg    %edx
  800764:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800767:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80076a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800771:	e9 bc 00 00 00       	jmp    800832 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	ff 75 e8             	pushl  -0x18(%ebp)
  80077c:	8d 45 14             	lea    0x14(%ebp),%eax
  80077f:	50                   	push   %eax
  800780:	e8 84 fc ff ff       	call   800409 <getuint>
  800785:	83 c4 10             	add    $0x10,%esp
  800788:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80078e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800795:	e9 98 00 00 00       	jmp    800832 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	6a 58                	push   $0x58
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	ff d0                	call   *%eax
  8007a7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	6a 58                	push   $0x58
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	ff d0                	call   *%eax
  8007b7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	ff 75 0c             	pushl  0xc(%ebp)
  8007c0:	6a 58                	push   $0x58
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	ff d0                	call   *%eax
  8007c7:	83 c4 10             	add    $0x10,%esp
			break;
  8007ca:	e9 bc 00 00 00       	jmp    80088b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	ff 75 0c             	pushl  0xc(%ebp)
  8007d5:	6a 30                	push   $0x30
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	ff d0                	call   *%eax
  8007dc:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	ff 75 0c             	pushl  0xc(%ebp)
  8007e5:	6a 78                	push   $0x78
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	ff d0                	call   *%eax
  8007ec:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	83 c0 04             	add    $0x4,%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	83 e8 04             	sub    $0x4,%eax
  8007fe:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800800:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800803:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80080a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800811:	eb 1f                	jmp    800832 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	ff 75 e8             	pushl  -0x18(%ebp)
  800819:	8d 45 14             	lea    0x14(%ebp),%eax
  80081c:	50                   	push   %eax
  80081d:	e8 e7 fb ff ff       	call   800409 <getuint>
  800822:	83 c4 10             	add    $0x10,%esp
  800825:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800828:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80082b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800832:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800836:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800839:	83 ec 04             	sub    $0x4,%esp
  80083c:	52                   	push   %edx
  80083d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800840:	50                   	push   %eax
  800841:	ff 75 f4             	pushl  -0xc(%ebp)
  800844:	ff 75 f0             	pushl  -0x10(%ebp)
  800847:	ff 75 0c             	pushl  0xc(%ebp)
  80084a:	ff 75 08             	pushl  0x8(%ebp)
  80084d:	e8 00 fb ff ff       	call   800352 <printnum>
  800852:	83 c4 20             	add    $0x20,%esp
			break;
  800855:	eb 34                	jmp    80088b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	ff 75 0c             	pushl  0xc(%ebp)
  80085d:	53                   	push   %ebx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
  800863:	83 c4 10             	add    $0x10,%esp
			break;
  800866:	eb 23                	jmp    80088b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	ff 75 0c             	pushl  0xc(%ebp)
  80086e:	6a 25                	push   $0x25
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800878:	ff 4d 10             	decl   0x10(%ebp)
  80087b:	eb 03                	jmp    800880 <vprintfmt+0x3b1>
  80087d:	ff 4d 10             	decl   0x10(%ebp)
  800880:	8b 45 10             	mov    0x10(%ebp),%eax
  800883:	48                   	dec    %eax
  800884:	8a 00                	mov    (%eax),%al
  800886:	3c 25                	cmp    $0x25,%al
  800888:	75 f3                	jne    80087d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80088a:	90                   	nop
		}
	}
  80088b:	e9 47 fc ff ff       	jmp    8004d7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800890:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800891:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800894:	5b                   	pop    %ebx
  800895:	5e                   	pop    %esi
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80089e:	8d 45 10             	lea    0x10(%ebp),%eax
  8008a1:	83 c0 04             	add    $0x4,%eax
  8008a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ad:	50                   	push   %eax
  8008ae:	ff 75 0c             	pushl  0xc(%ebp)
  8008b1:	ff 75 08             	pushl  0x8(%ebp)
  8008b4:	e8 16 fc ff ff       	call   8004cf <vprintfmt>
  8008b9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008bc:	90                   	nop
  8008bd:	c9                   	leave  
  8008be:	c3                   	ret    

008008bf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c5:	8b 40 08             	mov    0x8(%eax),%eax
  8008c8:	8d 50 01             	lea    0x1(%eax),%edx
  8008cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ce:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d4:	8b 10                	mov    (%eax),%edx
  8008d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d9:	8b 40 04             	mov    0x4(%eax),%eax
  8008dc:	39 c2                	cmp    %eax,%edx
  8008de:	73 12                	jae    8008f2 <sprintputch+0x33>
		*b->buf++ = ch;
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  8008e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008eb:	89 0a                	mov    %ecx,(%edx)
  8008ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f0:	88 10                	mov    %dl,(%eax)
}
  8008f2:	90                   	nop
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800901:	8b 45 0c             	mov    0xc(%ebp),%eax
  800904:	8d 50 ff             	lea    -0x1(%eax),%edx
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	01 d0                	add    %edx,%eax
  80090c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80090f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800916:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80091a:	74 06                	je     800922 <vsnprintf+0x2d>
  80091c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800920:	7f 07                	jg     800929 <vsnprintf+0x34>
		return -E_INVAL;
  800922:	b8 03 00 00 00       	mov    $0x3,%eax
  800927:	eb 20                	jmp    800949 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800929:	ff 75 14             	pushl  0x14(%ebp)
  80092c:	ff 75 10             	pushl  0x10(%ebp)
  80092f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800932:	50                   	push   %eax
  800933:	68 bf 08 80 00       	push   $0x8008bf
  800938:	e8 92 fb ff ff       	call   8004cf <vprintfmt>
  80093d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800940:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800943:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800946:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800949:	c9                   	leave  
  80094a:	c3                   	ret    

0080094b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800951:	8d 45 10             	lea    0x10(%ebp),%eax
  800954:	83 c0 04             	add    $0x4,%eax
  800957:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80095a:	8b 45 10             	mov    0x10(%ebp),%eax
  80095d:	ff 75 f4             	pushl  -0xc(%ebp)
  800960:	50                   	push   %eax
  800961:	ff 75 0c             	pushl  0xc(%ebp)
  800964:	ff 75 08             	pushl  0x8(%ebp)
  800967:	e8 89 ff ff ff       	call   8008f5 <vsnprintf>
  80096c:	83 c4 10             	add    $0x10,%esp
  80096f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800972:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80097d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800984:	eb 06                	jmp    80098c <strlen+0x15>
		n++;
  800986:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800989:	ff 45 08             	incl   0x8(%ebp)
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	8a 00                	mov    (%eax),%al
  800991:	84 c0                	test   %al,%al
  800993:	75 f1                	jne    800986 <strlen+0xf>
		n++;
	return n;
  800995:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009a7:	eb 09                	jmp    8009b2 <strnlen+0x18>
		n++;
  8009a9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ac:	ff 45 08             	incl   0x8(%ebp)
  8009af:	ff 4d 0c             	decl   0xc(%ebp)
  8009b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009b6:	74 09                	je     8009c1 <strnlen+0x27>
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	8a 00                	mov    (%eax),%al
  8009bd:	84 c0                	test   %al,%al
  8009bf:	75 e8                	jne    8009a9 <strnlen+0xf>
		n++;
	return n;
  8009c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009c4:	c9                   	leave  
  8009c5:	c3                   	ret    

008009c6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009d2:	90                   	nop
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8d 50 01             	lea    0x1(%eax),%edx
  8009d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8009dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009df:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009e2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009e5:	8a 12                	mov    (%edx),%dl
  8009e7:	88 10                	mov    %dl,(%eax)
  8009e9:	8a 00                	mov    (%eax),%al
  8009eb:	84 c0                	test   %al,%al
  8009ed:	75 e4                	jne    8009d3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009f2:	c9                   	leave  
  8009f3:	c3                   	ret    

008009f4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a07:	eb 1f                	jmp    800a28 <strncpy+0x34>
		*dst++ = *src;
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8d 50 01             	lea    0x1(%eax),%edx
  800a0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a15:	8a 12                	mov    (%edx),%dl
  800a17:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1c:	8a 00                	mov    (%eax),%al
  800a1e:	84 c0                	test   %al,%al
  800a20:	74 03                	je     800a25 <strncpy+0x31>
			src++;
  800a22:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a25:	ff 45 fc             	incl   -0x4(%ebp)
  800a28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a2b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a2e:	72 d9                	jb     800a09 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a30:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a45:	74 30                	je     800a77 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a47:	eb 16                	jmp    800a5f <strlcpy+0x2a>
			*dst++ = *src++;
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	8d 50 01             	lea    0x1(%eax),%edx
  800a4f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a55:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a58:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a5b:	8a 12                	mov    (%edx),%dl
  800a5d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a5f:	ff 4d 10             	decl   0x10(%ebp)
  800a62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a66:	74 09                	je     800a71 <strlcpy+0x3c>
  800a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6b:	8a 00                	mov    (%eax),%al
  800a6d:	84 c0                	test   %al,%al
  800a6f:	75 d8                	jne    800a49 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a77:	8b 55 08             	mov    0x8(%ebp),%edx
  800a7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a7d:	29 c2                	sub    %eax,%edx
  800a7f:	89 d0                	mov    %edx,%eax
}
  800a81:	c9                   	leave  
  800a82:	c3                   	ret    

00800a83 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a86:	eb 06                	jmp    800a8e <strcmp+0xb>
		p++, q++;
  800a88:	ff 45 08             	incl   0x8(%ebp)
  800a8b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	8a 00                	mov    (%eax),%al
  800a93:	84 c0                	test   %al,%al
  800a95:	74 0e                	je     800aa5 <strcmp+0x22>
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	8a 10                	mov    (%eax),%dl
  800a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9f:	8a 00                	mov    (%eax),%al
  800aa1:	38 c2                	cmp    %al,%dl
  800aa3:	74 e3                	je     800a88 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8a 00                	mov    (%eax),%al
  800aaa:	0f b6 d0             	movzbl %al,%edx
  800aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab0:	8a 00                	mov    (%eax),%al
  800ab2:	0f b6 c0             	movzbl %al,%eax
  800ab5:	29 c2                	sub    %eax,%edx
  800ab7:	89 d0                	mov    %edx,%eax
}
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800abe:	eb 09                	jmp    800ac9 <strncmp+0xe>
		n--, p++, q++;
  800ac0:	ff 4d 10             	decl   0x10(%ebp)
  800ac3:	ff 45 08             	incl   0x8(%ebp)
  800ac6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ac9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acd:	74 17                	je     800ae6 <strncmp+0x2b>
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8a 00                	mov    (%eax),%al
  800ad4:	84 c0                	test   %al,%al
  800ad6:	74 0e                	je     800ae6 <strncmp+0x2b>
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	8a 10                	mov    (%eax),%dl
  800add:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae0:	8a 00                	mov    (%eax),%al
  800ae2:	38 c2                	cmp    %al,%dl
  800ae4:	74 da                	je     800ac0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ae6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aea:	75 07                	jne    800af3 <strncmp+0x38>
		return 0;
  800aec:	b8 00 00 00 00       	mov    $0x0,%eax
  800af1:	eb 14                	jmp    800b07 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	8a 00                	mov    (%eax),%al
  800af8:	0f b6 d0             	movzbl %al,%edx
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	8a 00                	mov    (%eax),%al
  800b00:	0f b6 c0             	movzbl %al,%eax
  800b03:	29 c2                	sub    %eax,%edx
  800b05:	89 d0                	mov    %edx,%eax
}
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 04             	sub    $0x4,%esp
  800b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b12:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b15:	eb 12                	jmp    800b29 <strchr+0x20>
		if (*s == c)
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	8a 00                	mov    (%eax),%al
  800b1c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b1f:	75 05                	jne    800b26 <strchr+0x1d>
			return (char *) s;
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	eb 11                	jmp    800b37 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b26:	ff 45 08             	incl   0x8(%ebp)
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8a 00                	mov    (%eax),%al
  800b2e:	84 c0                	test   %al,%al
  800b30:	75 e5                	jne    800b17 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b37:	c9                   	leave  
  800b38:	c3                   	ret    

00800b39 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	83 ec 04             	sub    $0x4,%esp
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b45:	eb 0d                	jmp    800b54 <strfind+0x1b>
		if (*s == c)
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	8a 00                	mov    (%eax),%al
  800b4c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b4f:	74 0e                	je     800b5f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b51:	ff 45 08             	incl   0x8(%ebp)
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	8a 00                	mov    (%eax),%al
  800b59:	84 c0                	test   %al,%al
  800b5b:	75 ea                	jne    800b47 <strfind+0xe>
  800b5d:	eb 01                	jmp    800b60 <strfind+0x27>
		if (*s == c)
			break;
  800b5f:	90                   	nop
	return (char *) s;
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b71:	8b 45 10             	mov    0x10(%ebp),%eax
  800b74:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b77:	eb 0e                	jmp    800b87 <memset+0x22>
		*p++ = c;
  800b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b7c:	8d 50 01             	lea    0x1(%eax),%edx
  800b7f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b85:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b87:	ff 4d f8             	decl   -0x8(%ebp)
  800b8a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b8e:	79 e9                	jns    800b79 <memset+0x14>
		*p++ = c;

	return v;
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b93:	c9                   	leave  
  800b94:	c3                   	ret    

00800b95 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ba7:	eb 16                	jmp    800bbf <memcpy+0x2a>
		*d++ = *s++;
  800ba9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bac:	8d 50 01             	lea    0x1(%eax),%edx
  800baf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bbb:	8a 12                	mov    (%edx),%dl
  800bbd:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800bbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc5:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc8:	85 c0                	test   %eax,%eax
  800bca:	75 dd                	jne    800ba9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800be9:	73 50                	jae    800c3b <memmove+0x6a>
  800beb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bee:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf1:	01 d0                	add    %edx,%eax
  800bf3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bf6:	76 43                	jbe    800c3b <memmove+0x6a>
		s += n;
  800bf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800c01:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c04:	eb 10                	jmp    800c16 <memmove+0x45>
			*--d = *--s;
  800c06:	ff 4d f8             	decl   -0x8(%ebp)
  800c09:	ff 4d fc             	decl   -0x4(%ebp)
  800c0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c0f:	8a 10                	mov    (%eax),%dl
  800c11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c14:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c16:	8b 45 10             	mov    0x10(%ebp),%eax
  800c19:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	75 e3                	jne    800c06 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c23:	eb 23                	jmp    800c48 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c28:	8d 50 01             	lea    0x1(%eax),%edx
  800c2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c37:	8a 12                	mov    (%edx),%dl
  800c39:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c41:	89 55 10             	mov    %edx,0x10(%ebp)
  800c44:	85 c0                	test   %eax,%eax
  800c46:	75 dd                	jne    800c25 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c5f:	eb 2a                	jmp    800c8b <memcmp+0x3e>
		if (*s1 != *s2)
  800c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c64:	8a 10                	mov    (%eax),%dl
  800c66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c69:	8a 00                	mov    (%eax),%al
  800c6b:	38 c2                	cmp    %al,%dl
  800c6d:	74 16                	je     800c85 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c72:	8a 00                	mov    (%eax),%al
  800c74:	0f b6 d0             	movzbl %al,%edx
  800c77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7a:	8a 00                	mov    (%eax),%al
  800c7c:	0f b6 c0             	movzbl %al,%eax
  800c7f:	29 c2                	sub    %eax,%edx
  800c81:	89 d0                	mov    %edx,%eax
  800c83:	eb 18                	jmp    800c9d <memcmp+0x50>
		s1++, s2++;
  800c85:	ff 45 fc             	incl   -0x4(%ebp)
  800c88:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c91:	89 55 10             	mov    %edx,0x10(%ebp)
  800c94:	85 c0                	test   %eax,%eax
  800c96:	75 c9                	jne    800c61 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cab:	01 d0                	add    %edx,%eax
  800cad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800cb0:	eb 15                	jmp    800cc7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	0f b6 d0             	movzbl %al,%edx
  800cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbd:	0f b6 c0             	movzbl %al,%eax
  800cc0:	39 c2                	cmp    %eax,%edx
  800cc2:	74 0d                	je     800cd1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cc4:	ff 45 08             	incl   0x8(%ebp)
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ccd:	72 e3                	jb     800cb2 <memfind+0x13>
  800ccf:	eb 01                	jmp    800cd2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800cd1:	90                   	nop
	return (void *) s;
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd5:	c9                   	leave  
  800cd6:	c3                   	ret    

00800cd7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ce4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ceb:	eb 03                	jmp    800cf0 <strtol+0x19>
		s++;
  800ced:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8a 00                	mov    (%eax),%al
  800cf5:	3c 20                	cmp    $0x20,%al
  800cf7:	74 f4                	je     800ced <strtol+0x16>
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	3c 09                	cmp    $0x9,%al
  800d00:	74 eb                	je     800ced <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	3c 2b                	cmp    $0x2b,%al
  800d09:	75 05                	jne    800d10 <strtol+0x39>
		s++;
  800d0b:	ff 45 08             	incl   0x8(%ebp)
  800d0e:	eb 13                	jmp    800d23 <strtol+0x4c>
	else if (*s == '-')
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	3c 2d                	cmp    $0x2d,%al
  800d17:	75 0a                	jne    800d23 <strtol+0x4c>
		s++, neg = 1;
  800d19:	ff 45 08             	incl   0x8(%ebp)
  800d1c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d27:	74 06                	je     800d2f <strtol+0x58>
  800d29:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d2d:	75 20                	jne    800d4f <strtol+0x78>
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	3c 30                	cmp    $0x30,%al
  800d36:	75 17                	jne    800d4f <strtol+0x78>
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	40                   	inc    %eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	3c 78                	cmp    $0x78,%al
  800d40:	75 0d                	jne    800d4f <strtol+0x78>
		s += 2, base = 16;
  800d42:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d46:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d4d:	eb 28                	jmp    800d77 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d53:	75 15                	jne    800d6a <strtol+0x93>
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3c 30                	cmp    $0x30,%al
  800d5c:	75 0c                	jne    800d6a <strtol+0x93>
		s++, base = 8;
  800d5e:	ff 45 08             	incl   0x8(%ebp)
  800d61:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d68:	eb 0d                	jmp    800d77 <strtol+0xa0>
	else if (base == 0)
  800d6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6e:	75 07                	jne    800d77 <strtol+0xa0>
		base = 10;
  800d70:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3c 2f                	cmp    $0x2f,%al
  800d7e:	7e 19                	jle    800d99 <strtol+0xc2>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3c 39                	cmp    $0x39,%al
  800d87:	7f 10                	jg     800d99 <strtol+0xc2>
			dig = *s - '0';
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	0f be c0             	movsbl %al,%eax
  800d91:	83 e8 30             	sub    $0x30,%eax
  800d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d97:	eb 42                	jmp    800ddb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	3c 60                	cmp    $0x60,%al
  800da0:	7e 19                	jle    800dbb <strtol+0xe4>
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8a 00                	mov    (%eax),%al
  800da7:	3c 7a                	cmp    $0x7a,%al
  800da9:	7f 10                	jg     800dbb <strtol+0xe4>
			dig = *s - 'a' + 10;
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	0f be c0             	movsbl %al,%eax
  800db3:	83 e8 57             	sub    $0x57,%eax
  800db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800db9:	eb 20                	jmp    800ddb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	3c 40                	cmp    $0x40,%al
  800dc2:	7e 39                	jle    800dfd <strtol+0x126>
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	3c 5a                	cmp    $0x5a,%al
  800dcb:	7f 30                	jg     800dfd <strtol+0x126>
			dig = *s - 'A' + 10;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	0f be c0             	movsbl %al,%eax
  800dd5:	83 e8 37             	sub    $0x37,%eax
  800dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dde:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de1:	7d 19                	jge    800dfc <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800de3:	ff 45 08             	incl   0x8(%ebp)
  800de6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ded:	89 c2                	mov    %eax,%edx
  800def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800df2:	01 d0                	add    %edx,%eax
  800df4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800df7:	e9 7b ff ff ff       	jmp    800d77 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dfc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dfd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e01:	74 08                	je     800e0b <strtol+0x134>
		*endptr = (char *) s;
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	8b 55 08             	mov    0x8(%ebp),%edx
  800e09:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e0f:	74 07                	je     800e18 <strtol+0x141>
  800e11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e14:	f7 d8                	neg    %eax
  800e16:	eb 03                	jmp    800e1b <strtol+0x144>
  800e18:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e1b:	c9                   	leave  
  800e1c:	c3                   	ret    

00800e1d <ltostr>:

void
ltostr(long value, char *str)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
  800e20:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e2a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e35:	79 13                	jns    800e4a <ltostr+0x2d>
	{
		neg = 1;
  800e37:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e41:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e44:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e47:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e52:	99                   	cltd   
  800e53:	f7 f9                	idiv   %ecx
  800e55:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e58:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5b:	8d 50 01             	lea    0x1(%eax),%edx
  800e5e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e61:	89 c2                	mov    %eax,%edx
  800e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e66:	01 d0                	add    %edx,%eax
  800e68:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e6b:	83 c2 30             	add    $0x30,%edx
  800e6e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e73:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e78:	f7 e9                	imul   %ecx
  800e7a:	c1 fa 02             	sar    $0x2,%edx
  800e7d:	89 c8                	mov    %ecx,%eax
  800e7f:	c1 f8 1f             	sar    $0x1f,%eax
  800e82:	29 c2                	sub    %eax,%edx
  800e84:	89 d0                	mov    %edx,%eax
  800e86:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e8c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e91:	f7 e9                	imul   %ecx
  800e93:	c1 fa 02             	sar    $0x2,%edx
  800e96:	89 c8                	mov    %ecx,%eax
  800e98:	c1 f8 1f             	sar    $0x1f,%eax
  800e9b:	29 c2                	sub    %eax,%edx
  800e9d:	89 d0                	mov    %edx,%eax
  800e9f:	c1 e0 02             	shl    $0x2,%eax
  800ea2:	01 d0                	add    %edx,%eax
  800ea4:	01 c0                	add    %eax,%eax
  800ea6:	29 c1                	sub    %eax,%ecx
  800ea8:	89 ca                	mov    %ecx,%edx
  800eaa:	85 d2                	test   %edx,%edx
  800eac:	75 9c                	jne    800e4a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800eae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	48                   	dec    %eax
  800eb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800ebc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ec0:	74 3d                	je     800eff <ltostr+0xe2>
		start = 1 ;
  800ec2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800ec9:	eb 34                	jmp    800eff <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800ecb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	01 d0                	add    %edx,%eax
  800ed3:	8a 00                	mov    (%eax),%al
  800ed5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800ed8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ede:	01 c2                	add    %eax,%edx
  800ee0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee6:	01 c8                	add    %ecx,%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800eec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef2:	01 c2                	add    %eax,%edx
  800ef4:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ef7:	88 02                	mov    %al,(%edx)
		start++ ;
  800ef9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800efc:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f02:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f05:	7c c4                	jl     800ecb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f07:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0d:	01 d0                	add    %edx,%eax
  800f0f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f12:	90                   	nop
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f1b:	ff 75 08             	pushl  0x8(%ebp)
  800f1e:	e8 54 fa ff ff       	call   800977 <strlen>
  800f23:	83 c4 04             	add    $0x4,%esp
  800f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f29:	ff 75 0c             	pushl  0xc(%ebp)
  800f2c:	e8 46 fa ff ff       	call   800977 <strlen>
  800f31:	83 c4 04             	add    $0x4,%esp
  800f34:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f45:	eb 17                	jmp    800f5e <strcconcat+0x49>
		final[s] = str1[s] ;
  800f47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4d:	01 c2                	add    %eax,%edx
  800f4f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	01 c8                	add    %ecx,%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f5b:	ff 45 fc             	incl   -0x4(%ebp)
  800f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f61:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f64:	7c e1                	jl     800f47 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f66:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f6d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f74:	eb 1f                	jmp    800f95 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f79:	8d 50 01             	lea    0x1(%eax),%edx
  800f7c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f7f:	89 c2                	mov    %eax,%edx
  800f81:	8b 45 10             	mov    0x10(%ebp),%eax
  800f84:	01 c2                	add    %eax,%edx
  800f86:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	01 c8                	add    %ecx,%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f92:	ff 45 f8             	incl   -0x8(%ebp)
  800f95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f98:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f9b:	7c d9                	jl     800f76 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa3:	01 d0                	add    %edx,%eax
  800fa5:	c6 00 00             	movb   $0x0,(%eax)
}
  800fa8:	90                   	nop
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800fae:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800fb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fba:	8b 00                	mov    (%eax),%eax
  800fbc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc6:	01 d0                	add    %edx,%eax
  800fc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fce:	eb 0c                	jmp    800fdc <strsplit+0x31>
			*string++ = 0;
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8d 50 01             	lea    0x1(%eax),%edx
  800fd6:	89 55 08             	mov    %edx,0x8(%ebp)
  800fd9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	84 c0                	test   %al,%al
  800fe3:	74 18                	je     800ffd <strsplit+0x52>
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	0f be c0             	movsbl %al,%eax
  800fed:	50                   	push   %eax
  800fee:	ff 75 0c             	pushl  0xc(%ebp)
  800ff1:	e8 13 fb ff ff       	call   800b09 <strchr>
  800ff6:	83 c4 08             	add    $0x8,%esp
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	75 d3                	jne    800fd0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	84 c0                	test   %al,%al
  801004:	74 5a                	je     801060 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801006:	8b 45 14             	mov    0x14(%ebp),%eax
  801009:	8b 00                	mov    (%eax),%eax
  80100b:	83 f8 0f             	cmp    $0xf,%eax
  80100e:	75 07                	jne    801017 <strsplit+0x6c>
		{
			return 0;
  801010:	b8 00 00 00 00       	mov    $0x0,%eax
  801015:	eb 66                	jmp    80107d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801017:	8b 45 14             	mov    0x14(%ebp),%eax
  80101a:	8b 00                	mov    (%eax),%eax
  80101c:	8d 48 01             	lea    0x1(%eax),%ecx
  80101f:	8b 55 14             	mov    0x14(%ebp),%edx
  801022:	89 0a                	mov    %ecx,(%edx)
  801024:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80102b:	8b 45 10             	mov    0x10(%ebp),%eax
  80102e:	01 c2                	add    %eax,%edx
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801035:	eb 03                	jmp    80103a <strsplit+0x8f>
			string++;
  801037:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	84 c0                	test   %al,%al
  801041:	74 8b                	je     800fce <strsplit+0x23>
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	0f be c0             	movsbl %al,%eax
  80104b:	50                   	push   %eax
  80104c:	ff 75 0c             	pushl  0xc(%ebp)
  80104f:	e8 b5 fa ff ff       	call   800b09 <strchr>
  801054:	83 c4 08             	add    $0x8,%esp
  801057:	85 c0                	test   %eax,%eax
  801059:	74 dc                	je     801037 <strsplit+0x8c>
			string++;
	}
  80105b:	e9 6e ff ff ff       	jmp    800fce <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801060:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801061:	8b 45 14             	mov    0x14(%ebp),%eax
  801064:	8b 00                	mov    (%eax),%eax
  801066:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80106d:	8b 45 10             	mov    0x10(%ebp),%eax
  801070:	01 d0                	add    %edx,%eax
  801072:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801078:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80107d:	c9                   	leave  
  80107e:	c3                   	ret    

0080107f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	57                   	push   %edi
  801083:	56                   	push   %esi
  801084:	53                   	push   %ebx
  801085:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801091:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801094:	8b 7d 18             	mov    0x18(%ebp),%edi
  801097:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80109a:	cd 30                	int    $0x30
  80109c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80109f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010a2:	83 c4 10             	add    $0x10,%esp
  8010a5:	5b                   	pop    %ebx
  8010a6:	5e                   	pop    %esi
  8010a7:	5f                   	pop    %edi
  8010a8:	5d                   	pop    %ebp
  8010a9:	c3                   	ret    

008010aa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 04             	sub    $0x4,%esp
  8010b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010b6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	6a 00                	push   $0x0
  8010bf:	6a 00                	push   $0x0
  8010c1:	52                   	push   %edx
  8010c2:	ff 75 0c             	pushl  0xc(%ebp)
  8010c5:	50                   	push   %eax
  8010c6:	6a 00                	push   $0x0
  8010c8:	e8 b2 ff ff ff       	call   80107f <syscall>
  8010cd:	83 c4 18             	add    $0x18,%esp
}
  8010d0:	90                   	nop
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010d6:	6a 00                	push   $0x0
  8010d8:	6a 00                	push   $0x0
  8010da:	6a 00                	push   $0x0
  8010dc:	6a 00                	push   $0x0
  8010de:	6a 00                	push   $0x0
  8010e0:	6a 01                	push   $0x1
  8010e2:	e8 98 ff ff ff       	call   80107f <syscall>
  8010e7:	83 c4 18             	add    $0x18,%esp
}
  8010ea:	c9                   	leave  
  8010eb:	c3                   	ret    

008010ec <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	6a 00                	push   $0x0
  8010f4:	6a 00                	push   $0x0
  8010f6:	6a 00                	push   $0x0
  8010f8:	6a 00                	push   $0x0
  8010fa:	50                   	push   %eax
  8010fb:	6a 05                	push   $0x5
  8010fd:	e8 7d ff ff ff       	call   80107f <syscall>
  801102:	83 c4 18             	add    $0x18,%esp
}
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80110a:	6a 00                	push   $0x0
  80110c:	6a 00                	push   $0x0
  80110e:	6a 00                	push   $0x0
  801110:	6a 00                	push   $0x0
  801112:	6a 00                	push   $0x0
  801114:	6a 02                	push   $0x2
  801116:	e8 64 ff ff ff       	call   80107f <syscall>
  80111b:	83 c4 18             	add    $0x18,%esp
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801123:	6a 00                	push   $0x0
  801125:	6a 00                	push   $0x0
  801127:	6a 00                	push   $0x0
  801129:	6a 00                	push   $0x0
  80112b:	6a 00                	push   $0x0
  80112d:	6a 03                	push   $0x3
  80112f:	e8 4b ff ff ff       	call   80107f <syscall>
  801134:	83 c4 18             	add    $0x18,%esp
}
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80113c:	6a 00                	push   $0x0
  80113e:	6a 00                	push   $0x0
  801140:	6a 00                	push   $0x0
  801142:	6a 00                	push   $0x0
  801144:	6a 00                	push   $0x0
  801146:	6a 04                	push   $0x4
  801148:	e8 32 ff ff ff       	call   80107f <syscall>
  80114d:	83 c4 18             	add    $0x18,%esp
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <sys_env_exit>:


void sys_env_exit(void)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801155:	6a 00                	push   $0x0
  801157:	6a 00                	push   $0x0
  801159:	6a 00                	push   $0x0
  80115b:	6a 00                	push   $0x0
  80115d:	6a 00                	push   $0x0
  80115f:	6a 06                	push   $0x6
  801161:	e8 19 ff ff ff       	call   80107f <syscall>
  801166:	83 c4 18             	add    $0x18,%esp
}
  801169:	90                   	nop
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80116f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	6a 00                	push   $0x0
  801177:	6a 00                	push   $0x0
  801179:	6a 00                	push   $0x0
  80117b:	52                   	push   %edx
  80117c:	50                   	push   %eax
  80117d:	6a 07                	push   $0x7
  80117f:	e8 fb fe ff ff       	call   80107f <syscall>
  801184:	83 c4 18             	add    $0x18,%esp
}
  801187:	c9                   	leave  
  801188:	c3                   	ret    

00801189 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	56                   	push   %esi
  80118d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80118e:	8b 75 18             	mov    0x18(%ebp),%esi
  801191:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801194:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801197:	8b 55 0c             	mov    0xc(%ebp),%edx
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	56                   	push   %esi
  80119e:	53                   	push   %ebx
  80119f:	51                   	push   %ecx
  8011a0:	52                   	push   %edx
  8011a1:	50                   	push   %eax
  8011a2:	6a 08                	push   $0x8
  8011a4:	e8 d6 fe ff ff       	call   80107f <syscall>
  8011a9:	83 c4 18             	add    $0x18,%esp
}
  8011ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011af:	5b                   	pop    %ebx
  8011b0:	5e                   	pop    %esi
  8011b1:	5d                   	pop    %ebp
  8011b2:	c3                   	ret    

008011b3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8011b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 00                	push   $0x0
  8011c0:	6a 00                	push   $0x0
  8011c2:	52                   	push   %edx
  8011c3:	50                   	push   %eax
  8011c4:	6a 09                	push   $0x9
  8011c6:	e8 b4 fe ff ff       	call   80107f <syscall>
  8011cb:	83 c4 18             	add    $0x18,%esp
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8011d3:	6a 00                	push   $0x0
  8011d5:	6a 00                	push   $0x0
  8011d7:	6a 00                	push   $0x0
  8011d9:	ff 75 0c             	pushl  0xc(%ebp)
  8011dc:	ff 75 08             	pushl  0x8(%ebp)
  8011df:	6a 0a                	push   $0xa
  8011e1:	e8 99 fe ff ff       	call   80107f <syscall>
  8011e6:	83 c4 18             	add    $0x18,%esp
}
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    

008011eb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8011ee:	6a 00                	push   $0x0
  8011f0:	6a 00                	push   $0x0
  8011f2:	6a 00                	push   $0x0
  8011f4:	6a 00                	push   $0x0
  8011f6:	6a 00                	push   $0x0
  8011f8:	6a 0b                	push   $0xb
  8011fa:	e8 80 fe ff ff       	call   80107f <syscall>
  8011ff:	83 c4 18             	add    $0x18,%esp
}
  801202:	c9                   	leave  
  801203:	c3                   	ret    

00801204 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801207:	6a 00                	push   $0x0
  801209:	6a 00                	push   $0x0
  80120b:	6a 00                	push   $0x0
  80120d:	6a 00                	push   $0x0
  80120f:	6a 00                	push   $0x0
  801211:	6a 0c                	push   $0xc
  801213:	e8 67 fe ff ff       	call   80107f <syscall>
  801218:	83 c4 18             	add    $0x18,%esp
}
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801220:	6a 00                	push   $0x0
  801222:	6a 00                	push   $0x0
  801224:	6a 00                	push   $0x0
  801226:	6a 00                	push   $0x0
  801228:	6a 00                	push   $0x0
  80122a:	6a 0d                	push   $0xd
  80122c:	e8 4e fe ff ff       	call   80107f <syscall>
  801231:	83 c4 18             	add    $0x18,%esp
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	ff 75 0c             	pushl  0xc(%ebp)
  801242:	ff 75 08             	pushl  0x8(%ebp)
  801245:	6a 11                	push   $0x11
  801247:	e8 33 fe ff ff       	call   80107f <syscall>
  80124c:	83 c4 18             	add    $0x18,%esp
	return;
  80124f:	90                   	nop
}
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801255:	6a 00                	push   $0x0
  801257:	6a 00                	push   $0x0
  801259:	6a 00                	push   $0x0
  80125b:	ff 75 0c             	pushl  0xc(%ebp)
  80125e:	ff 75 08             	pushl  0x8(%ebp)
  801261:	6a 12                	push   $0x12
  801263:	e8 17 fe ff ff       	call   80107f <syscall>
  801268:	83 c4 18             	add    $0x18,%esp
	return ;
  80126b:	90                   	nop
}
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801271:	6a 00                	push   $0x0
  801273:	6a 00                	push   $0x0
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	6a 0e                	push   $0xe
  80127d:	e8 fd fd ff ff       	call   80107f <syscall>
  801282:	83 c4 18             	add    $0x18,%esp
}
  801285:	c9                   	leave  
  801286:	c3                   	ret    

00801287 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80128a:	6a 00                	push   $0x0
  80128c:	6a 00                	push   $0x0
  80128e:	6a 00                	push   $0x0
  801290:	6a 00                	push   $0x0
  801292:	ff 75 08             	pushl  0x8(%ebp)
  801295:	6a 0f                	push   $0xf
  801297:	e8 e3 fd ff ff       	call   80107f <syscall>
  80129c:	83 c4 18             	add    $0x18,%esp
}
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    

008012a1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 10                	push   $0x10
  8012b0:	e8 ca fd ff ff       	call   80107f <syscall>
  8012b5:	83 c4 18             	add    $0x18,%esp
}
  8012b8:	90                   	nop
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8012be:	6a 00                	push   $0x0
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 14                	push   $0x14
  8012ca:	e8 b0 fd ff ff       	call   80107f <syscall>
  8012cf:	83 c4 18             	add    $0x18,%esp
}
  8012d2:	90                   	nop
  8012d3:	c9                   	leave  
  8012d4:	c3                   	ret    

008012d5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 15                	push   $0x15
  8012e4:	e8 96 fd ff ff       	call   80107f <syscall>
  8012e9:	83 c4 18             	add    $0x18,%esp
}
  8012ec:	90                   	nop
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <sys_cputc>:


void
sys_cputc(const char c)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 04             	sub    $0x4,%esp
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8012fb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8012ff:	6a 00                	push   $0x0
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	50                   	push   %eax
  801308:	6a 16                	push   $0x16
  80130a:	e8 70 fd ff ff       	call   80107f <syscall>
  80130f:	83 c4 18             	add    $0x18,%esp
}
  801312:	90                   	nop
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	6a 17                	push   $0x17
  801324:	e8 56 fd ff ff       	call   80107f <syscall>
  801329:	83 c4 18             	add    $0x18,%esp
}
  80132c:	90                   	nop
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	ff 75 0c             	pushl  0xc(%ebp)
  80133e:	50                   	push   %eax
  80133f:	6a 18                	push   $0x18
  801341:	e8 39 fd ff ff       	call   80107f <syscall>
  801346:	83 c4 18             	add    $0x18,%esp
}
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80134e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	52                   	push   %edx
  80135b:	50                   	push   %eax
  80135c:	6a 1b                	push   $0x1b
  80135e:	e8 1c fd ff ff       	call   80107f <syscall>
  801363:	83 c4 18             	add    $0x18,%esp
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80136b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	52                   	push   %edx
  801378:	50                   	push   %eax
  801379:	6a 19                	push   $0x19
  80137b:	e8 ff fc ff ff       	call   80107f <syscall>
  801380:	83 c4 18             	add    $0x18,%esp
}
  801383:	90                   	nop
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	52                   	push   %edx
  801396:	50                   	push   %eax
  801397:	6a 1a                	push   $0x1a
  801399:	e8 e1 fc ff ff       	call   80107f <syscall>
  80139e:	83 c4 18             	add    $0x18,%esp
}
  8013a1:	90                   	nop
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    

008013a4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	83 ec 04             	sub    $0x4,%esp
  8013aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013b0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013b3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	6a 00                	push   $0x0
  8013bc:	51                   	push   %ecx
  8013bd:	52                   	push   %edx
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	50                   	push   %eax
  8013c2:	6a 1c                	push   $0x1c
  8013c4:	e8 b6 fc ff ff       	call   80107f <syscall>
  8013c9:	83 c4 18             	add    $0x18,%esp
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8013d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	52                   	push   %edx
  8013de:	50                   	push   %eax
  8013df:	6a 1d                	push   $0x1d
  8013e1:	e8 99 fc ff ff       	call   80107f <syscall>
  8013e6:	83 c4 18             	add    $0x18,%esp
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8013ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	51                   	push   %ecx
  8013fc:	52                   	push   %edx
  8013fd:	50                   	push   %eax
  8013fe:	6a 1e                	push   $0x1e
  801400:	e8 7a fc ff ff       	call   80107f <syscall>
  801405:	83 c4 18             	add    $0x18,%esp
}
  801408:	c9                   	leave  
  801409:	c3                   	ret    

0080140a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80140d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	52                   	push   %edx
  80141a:	50                   	push   %eax
  80141b:	6a 1f                	push   $0x1f
  80141d:	e8 5d fc ff ff       	call   80107f <syscall>
  801422:	83 c4 18             	add    $0x18,%esp
}
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 20                	push   $0x20
  801436:	e8 44 fc ff ff       	call   80107f <syscall>
  80143b:	83 c4 18             	add    $0x18,%esp
}
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	ff 75 10             	pushl  0x10(%ebp)
  80144d:	ff 75 0c             	pushl  0xc(%ebp)
  801450:	50                   	push   %eax
  801451:	6a 21                	push   $0x21
  801453:	e8 27 fc ff ff       	call   80107f <syscall>
  801458:	83 c4 18             	add    $0x18,%esp
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <sys_run_env>:


void
sys_run_env(int32 envId)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	50                   	push   %eax
  80146c:	6a 22                	push   $0x22
  80146e:	e8 0c fc ff ff       	call   80107f <syscall>
  801473:	83 c4 18             	add    $0x18,%esp
}
  801476:	90                   	nop
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	50                   	push   %eax
  801488:	6a 23                	push   $0x23
  80148a:	e8 f0 fb ff ff       	call   80107f <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
}
  801492:	90                   	nop
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80149b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80149e:	8d 50 04             	lea    0x4(%eax),%edx
  8014a1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	52                   	push   %edx
  8014ab:	50                   	push   %eax
  8014ac:	6a 24                	push   $0x24
  8014ae:	e8 cc fb ff ff       	call   80107f <syscall>
  8014b3:	83 c4 18             	add    $0x18,%esp
	return result;
  8014b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014bf:	89 01                	mov    %eax,(%ecx)
  8014c1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	c9                   	leave  
  8014c8:	c2 04 00             	ret    $0x4

008014cb <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	ff 75 10             	pushl  0x10(%ebp)
  8014d5:	ff 75 0c             	pushl  0xc(%ebp)
  8014d8:	ff 75 08             	pushl  0x8(%ebp)
  8014db:	6a 13                	push   $0x13
  8014dd:	e8 9d fb ff ff       	call   80107f <syscall>
  8014e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8014e5:	90                   	nop
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 25                	push   $0x25
  8014f7:	e8 83 fb ff ff       	call   80107f <syscall>
  8014fc:	83 c4 18             	add    $0x18,%esp
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80150d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	50                   	push   %eax
  80151a:	6a 26                	push   $0x26
  80151c:	e8 5e fb ff ff       	call   80107f <syscall>
  801521:	83 c4 18             	add    $0x18,%esp
	return ;
  801524:	90                   	nop
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <rsttst>:
void rsttst()
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 28                	push   $0x28
  801536:	e8 44 fb ff ff       	call   80107f <syscall>
  80153b:	83 c4 18             	add    $0x18,%esp
	return ;
  80153e:	90                   	nop
}
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 04             	sub    $0x4,%esp
  801547:	8b 45 14             	mov    0x14(%ebp),%eax
  80154a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80154d:	8b 55 18             	mov    0x18(%ebp),%edx
  801550:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801554:	52                   	push   %edx
  801555:	50                   	push   %eax
  801556:	ff 75 10             	pushl  0x10(%ebp)
  801559:	ff 75 0c             	pushl  0xc(%ebp)
  80155c:	ff 75 08             	pushl  0x8(%ebp)
  80155f:	6a 27                	push   $0x27
  801561:	e8 19 fb ff ff       	call   80107f <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
	return ;
  801569:	90                   	nop
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <chktst>:
void chktst(uint32 n)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	ff 75 08             	pushl  0x8(%ebp)
  80157a:	6a 29                	push   $0x29
  80157c:	e8 fe fa ff ff       	call   80107f <syscall>
  801581:	83 c4 18             	add    $0x18,%esp
	return ;
  801584:	90                   	nop
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <inctst>:

void inctst()
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 2a                	push   $0x2a
  801596:	e8 e4 fa ff ff       	call   80107f <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
	return ;
  80159e:	90                   	nop
}
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <gettst>:
uint32 gettst()
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 2b                	push   $0x2b
  8015b0:	e8 ca fa ff ff       	call   80107f <syscall>
  8015b5:	83 c4 18             	add    $0x18,%esp
}
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 2c                	push   $0x2c
  8015cc:	e8 ae fa ff ff       	call   80107f <syscall>
  8015d1:	83 c4 18             	add    $0x18,%esp
  8015d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8015d7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8015db:	75 07                	jne    8015e4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8015dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8015e2:	eb 05                	jmp    8015e9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 2c                	push   $0x2c
  8015fd:	e8 7d fa ff ff       	call   80107f <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
  801605:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801608:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80160c:	75 07                	jne    801615 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80160e:	b8 01 00 00 00       	mov    $0x1,%eax
  801613:	eb 05                	jmp    80161a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801615:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 2c                	push   $0x2c
  80162e:	e8 4c fa ff ff       	call   80107f <syscall>
  801633:	83 c4 18             	add    $0x18,%esp
  801636:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801639:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80163d:	75 07                	jne    801646 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80163f:	b8 01 00 00 00       	mov    $0x1,%eax
  801644:	eb 05                	jmp    80164b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801646:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 2c                	push   $0x2c
  80165f:	e8 1b fa ff ff       	call   80107f <syscall>
  801664:	83 c4 18             	add    $0x18,%esp
  801667:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80166a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80166e:	75 07                	jne    801677 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801670:	b8 01 00 00 00       	mov    $0x1,%eax
  801675:	eb 05                	jmp    80167c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801677:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	ff 75 08             	pushl  0x8(%ebp)
  80168c:	6a 2d                	push   $0x2d
  80168e:	e8 ec f9 ff ff       	call   80107f <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
	return ;
  801696:	90                   	nop
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80169d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	6a 00                	push   $0x0
  8016ab:	53                   	push   %ebx
  8016ac:	51                   	push   %ecx
  8016ad:	52                   	push   %edx
  8016ae:	50                   	push   %eax
  8016af:	6a 2e                	push   $0x2e
  8016b1:	e8 c9 f9 ff ff       	call   80107f <syscall>
  8016b6:	83 c4 18             	add    $0x18,%esp
}
  8016b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	52                   	push   %edx
  8016ce:	50                   	push   %eax
  8016cf:	6a 2f                	push   $0x2f
  8016d1:	e8 a9 f9 ff ff       	call   80107f <syscall>
  8016d6:	83 c4 18             	add    $0x18,%esp
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8016e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e4:	89 d0                	mov    %edx,%eax
  8016e6:	c1 e0 02             	shl    $0x2,%eax
  8016e9:	01 d0                	add    %edx,%eax
  8016eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016f2:	01 d0                	add    %edx,%eax
  8016f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016fb:	01 d0                	add    %edx,%eax
  8016fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801704:	01 d0                	add    %edx,%eax
  801706:	c1 e0 04             	shl    $0x4,%eax
  801709:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80170c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801713:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801716:	83 ec 0c             	sub    $0xc,%esp
  801719:	50                   	push   %eax
  80171a:	e8 76 fd ff ff       	call   801495 <sys_get_virtual_time>
  80171f:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801722:	eb 41                	jmp    801765 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801724:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801727:	83 ec 0c             	sub    $0xc,%esp
  80172a:	50                   	push   %eax
  80172b:	e8 65 fd ff ff       	call   801495 <sys_get_virtual_time>
  801730:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801733:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801736:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801739:	29 c2                	sub    %eax,%edx
  80173b:	89 d0                	mov    %edx,%eax
  80173d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801740:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801746:	89 d1                	mov    %edx,%ecx
  801748:	29 c1                	sub    %eax,%ecx
  80174a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80174d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801750:	39 c2                	cmp    %eax,%edx
  801752:	0f 97 c0             	seta   %al
  801755:	0f b6 c0             	movzbl %al,%eax
  801758:	29 c1                	sub    %eax,%ecx
  80175a:	89 c8                	mov    %ecx,%eax
  80175c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80175f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801762:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801768:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80176b:	72 b7                	jb     801724 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80176d:	90                   	nop
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801776:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80177d:	eb 03                	jmp    801782 <busy_wait+0x12>
  80177f:	ff 45 fc             	incl   -0x4(%ebp)
  801782:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801785:	3b 45 08             	cmp    0x8(%ebp),%eax
  801788:	72 f5                	jb     80177f <busy_wait+0xf>
	return i;
  80178a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    
  80178f:	90                   	nop

00801790 <__udivdi3>:
  801790:	55                   	push   %ebp
  801791:	57                   	push   %edi
  801792:	56                   	push   %esi
  801793:	53                   	push   %ebx
  801794:	83 ec 1c             	sub    $0x1c,%esp
  801797:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80179b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80179f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8017a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017a7:	89 ca                	mov    %ecx,%edx
  8017a9:	89 f8                	mov    %edi,%eax
  8017ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8017af:	85 f6                	test   %esi,%esi
  8017b1:	75 2d                	jne    8017e0 <__udivdi3+0x50>
  8017b3:	39 cf                	cmp    %ecx,%edi
  8017b5:	77 65                	ja     80181c <__udivdi3+0x8c>
  8017b7:	89 fd                	mov    %edi,%ebp
  8017b9:	85 ff                	test   %edi,%edi
  8017bb:	75 0b                	jne    8017c8 <__udivdi3+0x38>
  8017bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c2:	31 d2                	xor    %edx,%edx
  8017c4:	f7 f7                	div    %edi
  8017c6:	89 c5                	mov    %eax,%ebp
  8017c8:	31 d2                	xor    %edx,%edx
  8017ca:	89 c8                	mov    %ecx,%eax
  8017cc:	f7 f5                	div    %ebp
  8017ce:	89 c1                	mov    %eax,%ecx
  8017d0:	89 d8                	mov    %ebx,%eax
  8017d2:	f7 f5                	div    %ebp
  8017d4:	89 cf                	mov    %ecx,%edi
  8017d6:	89 fa                	mov    %edi,%edx
  8017d8:	83 c4 1c             	add    $0x1c,%esp
  8017db:	5b                   	pop    %ebx
  8017dc:	5e                   	pop    %esi
  8017dd:	5f                   	pop    %edi
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    
  8017e0:	39 ce                	cmp    %ecx,%esi
  8017e2:	77 28                	ja     80180c <__udivdi3+0x7c>
  8017e4:	0f bd fe             	bsr    %esi,%edi
  8017e7:	83 f7 1f             	xor    $0x1f,%edi
  8017ea:	75 40                	jne    80182c <__udivdi3+0x9c>
  8017ec:	39 ce                	cmp    %ecx,%esi
  8017ee:	72 0a                	jb     8017fa <__udivdi3+0x6a>
  8017f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8017f4:	0f 87 9e 00 00 00    	ja     801898 <__udivdi3+0x108>
  8017fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ff:	89 fa                	mov    %edi,%edx
  801801:	83 c4 1c             	add    $0x1c,%esp
  801804:	5b                   	pop    %ebx
  801805:	5e                   	pop    %esi
  801806:	5f                   	pop    %edi
  801807:	5d                   	pop    %ebp
  801808:	c3                   	ret    
  801809:	8d 76 00             	lea    0x0(%esi),%esi
  80180c:	31 ff                	xor    %edi,%edi
  80180e:	31 c0                	xor    %eax,%eax
  801810:	89 fa                	mov    %edi,%edx
  801812:	83 c4 1c             	add    $0x1c,%esp
  801815:	5b                   	pop    %ebx
  801816:	5e                   	pop    %esi
  801817:	5f                   	pop    %edi
  801818:	5d                   	pop    %ebp
  801819:	c3                   	ret    
  80181a:	66 90                	xchg   %ax,%ax
  80181c:	89 d8                	mov    %ebx,%eax
  80181e:	f7 f7                	div    %edi
  801820:	31 ff                	xor    %edi,%edi
  801822:	89 fa                	mov    %edi,%edx
  801824:	83 c4 1c             	add    $0x1c,%esp
  801827:	5b                   	pop    %ebx
  801828:	5e                   	pop    %esi
  801829:	5f                   	pop    %edi
  80182a:	5d                   	pop    %ebp
  80182b:	c3                   	ret    
  80182c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801831:	89 eb                	mov    %ebp,%ebx
  801833:	29 fb                	sub    %edi,%ebx
  801835:	89 f9                	mov    %edi,%ecx
  801837:	d3 e6                	shl    %cl,%esi
  801839:	89 c5                	mov    %eax,%ebp
  80183b:	88 d9                	mov    %bl,%cl
  80183d:	d3 ed                	shr    %cl,%ebp
  80183f:	89 e9                	mov    %ebp,%ecx
  801841:	09 f1                	or     %esi,%ecx
  801843:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801847:	89 f9                	mov    %edi,%ecx
  801849:	d3 e0                	shl    %cl,%eax
  80184b:	89 c5                	mov    %eax,%ebp
  80184d:	89 d6                	mov    %edx,%esi
  80184f:	88 d9                	mov    %bl,%cl
  801851:	d3 ee                	shr    %cl,%esi
  801853:	89 f9                	mov    %edi,%ecx
  801855:	d3 e2                	shl    %cl,%edx
  801857:	8b 44 24 08          	mov    0x8(%esp),%eax
  80185b:	88 d9                	mov    %bl,%cl
  80185d:	d3 e8                	shr    %cl,%eax
  80185f:	09 c2                	or     %eax,%edx
  801861:	89 d0                	mov    %edx,%eax
  801863:	89 f2                	mov    %esi,%edx
  801865:	f7 74 24 0c          	divl   0xc(%esp)
  801869:	89 d6                	mov    %edx,%esi
  80186b:	89 c3                	mov    %eax,%ebx
  80186d:	f7 e5                	mul    %ebp
  80186f:	39 d6                	cmp    %edx,%esi
  801871:	72 19                	jb     80188c <__udivdi3+0xfc>
  801873:	74 0b                	je     801880 <__udivdi3+0xf0>
  801875:	89 d8                	mov    %ebx,%eax
  801877:	31 ff                	xor    %edi,%edi
  801879:	e9 58 ff ff ff       	jmp    8017d6 <__udivdi3+0x46>
  80187e:	66 90                	xchg   %ax,%ax
  801880:	8b 54 24 08          	mov    0x8(%esp),%edx
  801884:	89 f9                	mov    %edi,%ecx
  801886:	d3 e2                	shl    %cl,%edx
  801888:	39 c2                	cmp    %eax,%edx
  80188a:	73 e9                	jae    801875 <__udivdi3+0xe5>
  80188c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80188f:	31 ff                	xor    %edi,%edi
  801891:	e9 40 ff ff ff       	jmp    8017d6 <__udivdi3+0x46>
  801896:	66 90                	xchg   %ax,%ax
  801898:	31 c0                	xor    %eax,%eax
  80189a:	e9 37 ff ff ff       	jmp    8017d6 <__udivdi3+0x46>
  80189f:	90                   	nop

008018a0 <__umoddi3>:
  8018a0:	55                   	push   %ebp
  8018a1:	57                   	push   %edi
  8018a2:	56                   	push   %esi
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 1c             	sub    $0x1c,%esp
  8018a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8018ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8018af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8018b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018bf:	89 f3                	mov    %esi,%ebx
  8018c1:	89 fa                	mov    %edi,%edx
  8018c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018c7:	89 34 24             	mov    %esi,(%esp)
  8018ca:	85 c0                	test   %eax,%eax
  8018cc:	75 1a                	jne    8018e8 <__umoddi3+0x48>
  8018ce:	39 f7                	cmp    %esi,%edi
  8018d0:	0f 86 a2 00 00 00    	jbe    801978 <__umoddi3+0xd8>
  8018d6:	89 c8                	mov    %ecx,%eax
  8018d8:	89 f2                	mov    %esi,%edx
  8018da:	f7 f7                	div    %edi
  8018dc:	89 d0                	mov    %edx,%eax
  8018de:	31 d2                	xor    %edx,%edx
  8018e0:	83 c4 1c             	add    $0x1c,%esp
  8018e3:	5b                   	pop    %ebx
  8018e4:	5e                   	pop    %esi
  8018e5:	5f                   	pop    %edi
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    
  8018e8:	39 f0                	cmp    %esi,%eax
  8018ea:	0f 87 ac 00 00 00    	ja     80199c <__umoddi3+0xfc>
  8018f0:	0f bd e8             	bsr    %eax,%ebp
  8018f3:	83 f5 1f             	xor    $0x1f,%ebp
  8018f6:	0f 84 ac 00 00 00    	je     8019a8 <__umoddi3+0x108>
  8018fc:	bf 20 00 00 00       	mov    $0x20,%edi
  801901:	29 ef                	sub    %ebp,%edi
  801903:	89 fe                	mov    %edi,%esi
  801905:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801909:	89 e9                	mov    %ebp,%ecx
  80190b:	d3 e0                	shl    %cl,%eax
  80190d:	89 d7                	mov    %edx,%edi
  80190f:	89 f1                	mov    %esi,%ecx
  801911:	d3 ef                	shr    %cl,%edi
  801913:	09 c7                	or     %eax,%edi
  801915:	89 e9                	mov    %ebp,%ecx
  801917:	d3 e2                	shl    %cl,%edx
  801919:	89 14 24             	mov    %edx,(%esp)
  80191c:	89 d8                	mov    %ebx,%eax
  80191e:	d3 e0                	shl    %cl,%eax
  801920:	89 c2                	mov    %eax,%edx
  801922:	8b 44 24 08          	mov    0x8(%esp),%eax
  801926:	d3 e0                	shl    %cl,%eax
  801928:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801930:	89 f1                	mov    %esi,%ecx
  801932:	d3 e8                	shr    %cl,%eax
  801934:	09 d0                	or     %edx,%eax
  801936:	d3 eb                	shr    %cl,%ebx
  801938:	89 da                	mov    %ebx,%edx
  80193a:	f7 f7                	div    %edi
  80193c:	89 d3                	mov    %edx,%ebx
  80193e:	f7 24 24             	mull   (%esp)
  801941:	89 c6                	mov    %eax,%esi
  801943:	89 d1                	mov    %edx,%ecx
  801945:	39 d3                	cmp    %edx,%ebx
  801947:	0f 82 87 00 00 00    	jb     8019d4 <__umoddi3+0x134>
  80194d:	0f 84 91 00 00 00    	je     8019e4 <__umoddi3+0x144>
  801953:	8b 54 24 04          	mov    0x4(%esp),%edx
  801957:	29 f2                	sub    %esi,%edx
  801959:	19 cb                	sbb    %ecx,%ebx
  80195b:	89 d8                	mov    %ebx,%eax
  80195d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801961:	d3 e0                	shl    %cl,%eax
  801963:	89 e9                	mov    %ebp,%ecx
  801965:	d3 ea                	shr    %cl,%edx
  801967:	09 d0                	or     %edx,%eax
  801969:	89 e9                	mov    %ebp,%ecx
  80196b:	d3 eb                	shr    %cl,%ebx
  80196d:	89 da                	mov    %ebx,%edx
  80196f:	83 c4 1c             	add    $0x1c,%esp
  801972:	5b                   	pop    %ebx
  801973:	5e                   	pop    %esi
  801974:	5f                   	pop    %edi
  801975:	5d                   	pop    %ebp
  801976:	c3                   	ret    
  801977:	90                   	nop
  801978:	89 fd                	mov    %edi,%ebp
  80197a:	85 ff                	test   %edi,%edi
  80197c:	75 0b                	jne    801989 <__umoddi3+0xe9>
  80197e:	b8 01 00 00 00       	mov    $0x1,%eax
  801983:	31 d2                	xor    %edx,%edx
  801985:	f7 f7                	div    %edi
  801987:	89 c5                	mov    %eax,%ebp
  801989:	89 f0                	mov    %esi,%eax
  80198b:	31 d2                	xor    %edx,%edx
  80198d:	f7 f5                	div    %ebp
  80198f:	89 c8                	mov    %ecx,%eax
  801991:	f7 f5                	div    %ebp
  801993:	89 d0                	mov    %edx,%eax
  801995:	e9 44 ff ff ff       	jmp    8018de <__umoddi3+0x3e>
  80199a:	66 90                	xchg   %ax,%ax
  80199c:	89 c8                	mov    %ecx,%eax
  80199e:	89 f2                	mov    %esi,%edx
  8019a0:	83 c4 1c             	add    $0x1c,%esp
  8019a3:	5b                   	pop    %ebx
  8019a4:	5e                   	pop    %esi
  8019a5:	5f                   	pop    %edi
  8019a6:	5d                   	pop    %ebp
  8019a7:	c3                   	ret    
  8019a8:	3b 04 24             	cmp    (%esp),%eax
  8019ab:	72 06                	jb     8019b3 <__umoddi3+0x113>
  8019ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8019b1:	77 0f                	ja     8019c2 <__umoddi3+0x122>
  8019b3:	89 f2                	mov    %esi,%edx
  8019b5:	29 f9                	sub    %edi,%ecx
  8019b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8019bb:	89 14 24             	mov    %edx,(%esp)
  8019be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8019c6:	8b 14 24             	mov    (%esp),%edx
  8019c9:	83 c4 1c             	add    $0x1c,%esp
  8019cc:	5b                   	pop    %ebx
  8019cd:	5e                   	pop    %esi
  8019ce:	5f                   	pop    %edi
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    
  8019d1:	8d 76 00             	lea    0x0(%esi),%esi
  8019d4:	2b 04 24             	sub    (%esp),%eax
  8019d7:	19 fa                	sbb    %edi,%edx
  8019d9:	89 d1                	mov    %edx,%ecx
  8019db:	89 c6                	mov    %eax,%esi
  8019dd:	e9 71 ff ff ff       	jmp    801953 <__umoddi3+0xb3>
  8019e2:	66 90                	xchg   %ax,%ax
  8019e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8019e8:	72 ea                	jb     8019d4 <__umoddi3+0x134>
  8019ea:	89 d9                	mov    %ebx,%ecx
  8019ec:	e9 62 ff ff ff       	jmp    801953 <__umoddi3+0xb3>
