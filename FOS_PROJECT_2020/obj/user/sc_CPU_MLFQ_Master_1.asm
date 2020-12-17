
obj/user/sc_CPU_MLFQ_Master_1:     file format elf32-i386


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
  800031:	e8 66 00 00 00       	call   80009c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int ID;
	for (int i = 0; i < 5; ++i) {
  80003e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800045:	eb 39                	jmp    800080 <_main+0x48>
			ID = sys_create_env("tmlfq_1", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
  800047:	a1 20 20 80 00       	mov    0x802020,%eax
  80004c:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800052:	a1 20 20 80 00       	mov    0x802020,%eax
  800057:	8b 40 74             	mov    0x74(%eax),%eax
  80005a:	83 ec 04             	sub    $0x4,%esp
  80005d:	52                   	push   %edx
  80005e:	50                   	push   %eax
  80005f:	68 c0 19 80 00       	push   $0x8019c0
  800064:	e8 97 13 00 00       	call   801400 <sys_create_env>
  800069:	83 c4 10             	add    $0x10,%esp
  80006c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_run_env(ID);
  80006f:	83 ec 0c             	sub    $0xc,%esp
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 a3 13 00 00       	call   80141d <sys_run_env>
  80007a:	83 c4 10             	add    $0x10,%esp
#include <inc/lib.h>

void _main(void)
{
	int ID;
	for (int i = 0; i < 5; ++i) {
  80007d:	ff 45 f4             	incl   -0xc(%ebp)
  800080:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
  800084:	7e c1                	jle    800047 <_main+0xf>
			ID = sys_create_env("tmlfq_1", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
			sys_run_env(ID);
		}

		//env_sleep(80000);
		int x = busy_wait(50000000);
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 f0 fa 02       	push   $0x2faf080
  80008e:	e8 9d 16 00 00       	call   801730 <busy_wait>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	89 45 ec             	mov    %eax,-0x14(%ebp)

}
  800099:	90                   	nop
  80009a:	c9                   	leave  
  80009b:	c3                   	ret    

0080009c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80009c:	55                   	push   %ebp
  80009d:	89 e5                	mov    %esp,%ebp
  80009f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000a2:	e8 39 10 00 00       	call   8010e0 <sys_getenvindex>
  8000a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000ad:	89 d0                	mov    %edx,%eax
  8000af:	c1 e0 03             	shl    $0x3,%eax
  8000b2:	01 d0                	add    %edx,%eax
  8000b4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000bb:	01 c8                	add    %ecx,%eax
  8000bd:	01 c0                	add    %eax,%eax
  8000bf:	01 d0                	add    %edx,%eax
  8000c1:	01 c0                	add    %eax,%eax
  8000c3:	01 d0                	add    %edx,%eax
  8000c5:	89 c2                	mov    %eax,%edx
  8000c7:	c1 e2 05             	shl    $0x5,%edx
  8000ca:	29 c2                	sub    %eax,%edx
  8000cc:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8000d3:	89 c2                	mov    %eax,%edx
  8000d5:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000db:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000e0:	a1 20 20 80 00       	mov    0x802020,%eax
  8000e5:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8000eb:	84 c0                	test   %al,%al
  8000ed:	74 0f                	je     8000fe <libmain+0x62>
		binaryname = myEnv->prog_name;
  8000ef:	a1 20 20 80 00       	mov    0x802020,%eax
  8000f4:	05 40 3c 01 00       	add    $0x13c40,%eax
  8000f9:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800102:	7e 0a                	jle    80010e <libmain+0x72>
		binaryname = argv[0];
  800104:	8b 45 0c             	mov    0xc(%ebp),%eax
  800107:	8b 00                	mov    (%eax),%eax
  800109:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  80010e:	83 ec 08             	sub    $0x8,%esp
  800111:	ff 75 0c             	pushl  0xc(%ebp)
  800114:	ff 75 08             	pushl  0x8(%ebp)
  800117:	e8 1c ff ff ff       	call   800038 <_main>
  80011c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80011f:	e8 57 11 00 00       	call   80127b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 e0 19 80 00       	push   $0x8019e0
  80012c:	e8 84 01 00 00       	call   8002b5 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800134:	a1 20 20 80 00       	mov    0x802020,%eax
  800139:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80013f:	a1 20 20 80 00       	mov    0x802020,%eax
  800144:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80014a:	83 ec 04             	sub    $0x4,%esp
  80014d:	52                   	push   %edx
  80014e:	50                   	push   %eax
  80014f:	68 08 1a 80 00       	push   $0x801a08
  800154:	e8 5c 01 00 00       	call   8002b5 <cprintf>
  800159:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80015c:	a1 20 20 80 00       	mov    0x802020,%eax
  800161:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800167:	a1 20 20 80 00       	mov    0x802020,%eax
  80016c:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800172:	83 ec 04             	sub    $0x4,%esp
  800175:	52                   	push   %edx
  800176:	50                   	push   %eax
  800177:	68 30 1a 80 00       	push   $0x801a30
  80017c:	e8 34 01 00 00       	call   8002b5 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800184:	a1 20 20 80 00       	mov    0x802020,%eax
  800189:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80018f:	83 ec 08             	sub    $0x8,%esp
  800192:	50                   	push   %eax
  800193:	68 71 1a 80 00       	push   $0x801a71
  800198:	e8 18 01 00 00       	call   8002b5 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	68 e0 19 80 00       	push   $0x8019e0
  8001a8:	e8 08 01 00 00       	call   8002b5 <cprintf>
  8001ad:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001b0:	e8 e0 10 00 00       	call   801295 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001b5:	e8 19 00 00 00       	call   8001d3 <exit>
}
  8001ba:	90                   	nop
  8001bb:	c9                   	leave  
  8001bc:	c3                   	ret    

008001bd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8001c3:	83 ec 0c             	sub    $0xc,%esp
  8001c6:	6a 00                	push   $0x0
  8001c8:	e8 df 0e 00 00       	call   8010ac <sys_env_destroy>
  8001cd:	83 c4 10             	add    $0x10,%esp
}
  8001d0:	90                   	nop
  8001d1:	c9                   	leave  
  8001d2:	c3                   	ret    

008001d3 <exit>:

void
exit(void)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8001d9:	e8 34 0f 00 00       	call   801112 <sys_env_exit>
}
  8001de:	90                   	nop
  8001df:	c9                   	leave  
  8001e0:	c3                   	ret    

008001e1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001e1:	55                   	push   %ebp
  8001e2:	89 e5                	mov    %esp,%ebp
  8001e4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ea:	8b 00                	mov    (%eax),%eax
  8001ec:	8d 48 01             	lea    0x1(%eax),%ecx
  8001ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f2:	89 0a                	mov    %ecx,(%edx)
  8001f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f7:	88 d1                	mov    %dl,%cl
  8001f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001fc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800200:	8b 45 0c             	mov    0xc(%ebp),%eax
  800203:	8b 00                	mov    (%eax),%eax
  800205:	3d ff 00 00 00       	cmp    $0xff,%eax
  80020a:	75 2c                	jne    800238 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80020c:	a0 24 20 80 00       	mov    0x802024,%al
  800211:	0f b6 c0             	movzbl %al,%eax
  800214:	8b 55 0c             	mov    0xc(%ebp),%edx
  800217:	8b 12                	mov    (%edx),%edx
  800219:	89 d1                	mov    %edx,%ecx
  80021b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021e:	83 c2 08             	add    $0x8,%edx
  800221:	83 ec 04             	sub    $0x4,%esp
  800224:	50                   	push   %eax
  800225:	51                   	push   %ecx
  800226:	52                   	push   %edx
  800227:	e8 3e 0e 00 00       	call   80106a <sys_cputs>
  80022c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80022f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800232:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023b:	8b 40 04             	mov    0x4(%eax),%eax
  80023e:	8d 50 01             	lea    0x1(%eax),%edx
  800241:	8b 45 0c             	mov    0xc(%ebp),%eax
  800244:	89 50 04             	mov    %edx,0x4(%eax)
}
  800247:	90                   	nop
  800248:	c9                   	leave  
  800249:	c3                   	ret    

0080024a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800253:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80025a:	00 00 00 
	b.cnt = 0;
  80025d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800264:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800267:	ff 75 0c             	pushl  0xc(%ebp)
  80026a:	ff 75 08             	pushl  0x8(%ebp)
  80026d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800273:	50                   	push   %eax
  800274:	68 e1 01 80 00       	push   $0x8001e1
  800279:	e8 11 02 00 00       	call   80048f <vprintfmt>
  80027e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800281:	a0 24 20 80 00       	mov    0x802024,%al
  800286:	0f b6 c0             	movzbl %al,%eax
  800289:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80028f:	83 ec 04             	sub    $0x4,%esp
  800292:	50                   	push   %eax
  800293:	52                   	push   %edx
  800294:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80029a:	83 c0 08             	add    $0x8,%eax
  80029d:	50                   	push   %eax
  80029e:	e8 c7 0d 00 00       	call   80106a <sys_cputs>
  8002a3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002a6:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8002ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    

008002b5 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002bb:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8002c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cb:	83 ec 08             	sub    $0x8,%esp
  8002ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d1:	50                   	push   %eax
  8002d2:	e8 73 ff ff ff       	call   80024a <vcprintf>
  8002d7:	83 c4 10             	add    $0x10,%esp
  8002da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002e0:	c9                   	leave  
  8002e1:	c3                   	ret    

008002e2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002e2:	55                   	push   %ebp
  8002e3:	89 e5                	mov    %esp,%ebp
  8002e5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002e8:	e8 8e 0f 00 00       	call   80127b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ed:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f6:	83 ec 08             	sub    $0x8,%esp
  8002f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8002fc:	50                   	push   %eax
  8002fd:	e8 48 ff ff ff       	call   80024a <vcprintf>
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800308:	e8 88 0f 00 00       	call   801295 <sys_enable_interrupt>
	return cnt;
  80030d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800310:	c9                   	leave  
  800311:	c3                   	ret    

00800312 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	53                   	push   %ebx
  800316:	83 ec 14             	sub    $0x14,%esp
  800319:	8b 45 10             	mov    0x10(%ebp),%eax
  80031c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80031f:	8b 45 14             	mov    0x14(%ebp),%eax
  800322:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800325:	8b 45 18             	mov    0x18(%ebp),%eax
  800328:	ba 00 00 00 00       	mov    $0x0,%edx
  80032d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800330:	77 55                	ja     800387 <printnum+0x75>
  800332:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800335:	72 05                	jb     80033c <printnum+0x2a>
  800337:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80033a:	77 4b                	ja     800387 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80033c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80033f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800342:	8b 45 18             	mov    0x18(%ebp),%eax
  800345:	ba 00 00 00 00       	mov    $0x0,%edx
  80034a:	52                   	push   %edx
  80034b:	50                   	push   %eax
  80034c:	ff 75 f4             	pushl  -0xc(%ebp)
  80034f:	ff 75 f0             	pushl  -0x10(%ebp)
  800352:	e8 f9 13 00 00       	call   801750 <__udivdi3>
  800357:	83 c4 10             	add    $0x10,%esp
  80035a:	83 ec 04             	sub    $0x4,%esp
  80035d:	ff 75 20             	pushl  0x20(%ebp)
  800360:	53                   	push   %ebx
  800361:	ff 75 18             	pushl  0x18(%ebp)
  800364:	52                   	push   %edx
  800365:	50                   	push   %eax
  800366:	ff 75 0c             	pushl  0xc(%ebp)
  800369:	ff 75 08             	pushl  0x8(%ebp)
  80036c:	e8 a1 ff ff ff       	call   800312 <printnum>
  800371:	83 c4 20             	add    $0x20,%esp
  800374:	eb 1a                	jmp    800390 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	ff 75 0c             	pushl  0xc(%ebp)
  80037c:	ff 75 20             	pushl  0x20(%ebp)
  80037f:	8b 45 08             	mov    0x8(%ebp),%eax
  800382:	ff d0                	call   *%eax
  800384:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800387:	ff 4d 1c             	decl   0x1c(%ebp)
  80038a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80038e:	7f e6                	jg     800376 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800390:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800393:	bb 00 00 00 00       	mov    $0x0,%ebx
  800398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80039e:	53                   	push   %ebx
  80039f:	51                   	push   %ecx
  8003a0:	52                   	push   %edx
  8003a1:	50                   	push   %eax
  8003a2:	e8 b9 14 00 00       	call   801860 <__umoddi3>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	05 b4 1c 80 00       	add    $0x801cb4,%eax
  8003af:	8a 00                	mov    (%eax),%al
  8003b1:	0f be c0             	movsbl %al,%eax
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	ff 75 0c             	pushl  0xc(%ebp)
  8003ba:	50                   	push   %eax
  8003bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003be:	ff d0                	call   *%eax
  8003c0:	83 c4 10             	add    $0x10,%esp
}
  8003c3:	90                   	nop
  8003c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003c7:	c9                   	leave  
  8003c8:	c3                   	ret    

008003c9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003c9:	55                   	push   %ebp
  8003ca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003cc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003d0:	7e 1c                	jle    8003ee <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d5:	8b 00                	mov    (%eax),%eax
  8003d7:	8d 50 08             	lea    0x8(%eax),%edx
  8003da:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dd:	89 10                	mov    %edx,(%eax)
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	83 e8 08             	sub    $0x8,%eax
  8003e7:	8b 50 04             	mov    0x4(%eax),%edx
  8003ea:	8b 00                	mov    (%eax),%eax
  8003ec:	eb 40                	jmp    80042e <getuint+0x65>
	else if (lflag)
  8003ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003f2:	74 1e                	je     800412 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	8d 50 04             	lea    0x4(%eax),%edx
  8003fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ff:	89 10                	mov    %edx,(%eax)
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	83 e8 04             	sub    $0x4,%eax
  800409:	8b 00                	mov    (%eax),%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	eb 1c                	jmp    80042e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	8b 00                	mov    (%eax),%eax
  800417:	8d 50 04             	lea    0x4(%eax),%edx
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	89 10                	mov    %edx,(%eax)
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
  800422:	8b 00                	mov    (%eax),%eax
  800424:	83 e8 04             	sub    $0x4,%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80042e:	5d                   	pop    %ebp
  80042f:	c3                   	ret    

00800430 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800433:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800437:	7e 1c                	jle    800455 <getint+0x25>
		return va_arg(*ap, long long);
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	8d 50 08             	lea    0x8(%eax),%edx
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	89 10                	mov    %edx,(%eax)
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	83 e8 08             	sub    $0x8,%eax
  80044e:	8b 50 04             	mov    0x4(%eax),%edx
  800451:	8b 00                	mov    (%eax),%eax
  800453:	eb 38                	jmp    80048d <getint+0x5d>
	else if (lflag)
  800455:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800459:	74 1a                	je     800475 <getint+0x45>
		return va_arg(*ap, long);
  80045b:	8b 45 08             	mov    0x8(%ebp),%eax
  80045e:	8b 00                	mov    (%eax),%eax
  800460:	8d 50 04             	lea    0x4(%eax),%edx
  800463:	8b 45 08             	mov    0x8(%ebp),%eax
  800466:	89 10                	mov    %edx,(%eax)
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	83 e8 04             	sub    $0x4,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	99                   	cltd   
  800473:	eb 18                	jmp    80048d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800475:	8b 45 08             	mov    0x8(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	8d 50 04             	lea    0x4(%eax),%edx
  80047d:	8b 45 08             	mov    0x8(%ebp),%eax
  800480:	89 10                	mov    %edx,(%eax)
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	8b 00                	mov    (%eax),%eax
  800487:	83 e8 04             	sub    $0x4,%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	99                   	cltd   
}
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    

0080048f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	56                   	push   %esi
  800493:	53                   	push   %ebx
  800494:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800497:	eb 17                	jmp    8004b0 <vprintfmt+0x21>
			if (ch == '\0')
  800499:	85 db                	test   %ebx,%ebx
  80049b:	0f 84 af 03 00 00    	je     800850 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	ff 75 0c             	pushl  0xc(%ebp)
  8004a7:	53                   	push   %ebx
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	ff d0                	call   *%eax
  8004ad:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b3:	8d 50 01             	lea    0x1(%eax),%edx
  8004b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8004b9:	8a 00                	mov    (%eax),%al
  8004bb:	0f b6 d8             	movzbl %al,%ebx
  8004be:	83 fb 25             	cmp    $0x25,%ebx
  8004c1:	75 d6                	jne    800499 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004c3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004c7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004ce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004d5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004dc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e6:	8d 50 01             	lea    0x1(%eax),%edx
  8004e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8004ec:	8a 00                	mov    (%eax),%al
  8004ee:	0f b6 d8             	movzbl %al,%ebx
  8004f1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004f4:	83 f8 55             	cmp    $0x55,%eax
  8004f7:	0f 87 2b 03 00 00    	ja     800828 <vprintfmt+0x399>
  8004fd:	8b 04 85 d8 1c 80 00 	mov    0x801cd8(,%eax,4),%eax
  800504:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800506:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80050a:	eb d7                	jmp    8004e3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80050c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800510:	eb d1                	jmp    8004e3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800512:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800519:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80051c:	89 d0                	mov    %edx,%eax
  80051e:	c1 e0 02             	shl    $0x2,%eax
  800521:	01 d0                	add    %edx,%eax
  800523:	01 c0                	add    %eax,%eax
  800525:	01 d8                	add    %ebx,%eax
  800527:	83 e8 30             	sub    $0x30,%eax
  80052a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80052d:	8b 45 10             	mov    0x10(%ebp),%eax
  800530:	8a 00                	mov    (%eax),%al
  800532:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800535:	83 fb 2f             	cmp    $0x2f,%ebx
  800538:	7e 3e                	jle    800578 <vprintfmt+0xe9>
  80053a:	83 fb 39             	cmp    $0x39,%ebx
  80053d:	7f 39                	jg     800578 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80053f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800542:	eb d5                	jmp    800519 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	83 c0 04             	add    $0x4,%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
  80054d:	8b 45 14             	mov    0x14(%ebp),%eax
  800550:	83 e8 04             	sub    $0x4,%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800558:	eb 1f                	jmp    800579 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80055a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80055e:	79 83                	jns    8004e3 <vprintfmt+0x54>
				width = 0;
  800560:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800567:	e9 77 ff ff ff       	jmp    8004e3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80056c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800573:	e9 6b ff ff ff       	jmp    8004e3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800578:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800579:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80057d:	0f 89 60 ff ff ff    	jns    8004e3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800583:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800586:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800589:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800590:	e9 4e ff ff ff       	jmp    8004e3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800595:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800598:	e9 46 ff ff ff       	jmp    8004e3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	83 c0 04             	add    $0x4,%eax
  8005a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	83 e8 04             	sub    $0x4,%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	ff 75 0c             	pushl  0xc(%ebp)
  8005b4:	50                   	push   %eax
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	ff d0                	call   *%eax
  8005ba:	83 c4 10             	add    $0x10,%esp
			break;
  8005bd:	e9 89 02 00 00       	jmp    80084b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	83 c0 04             	add    $0x4,%eax
  8005c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	83 e8 04             	sub    $0x4,%eax
  8005d1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005d3:	85 db                	test   %ebx,%ebx
  8005d5:	79 02                	jns    8005d9 <vprintfmt+0x14a>
				err = -err;
  8005d7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005d9:	83 fb 64             	cmp    $0x64,%ebx
  8005dc:	7f 0b                	jg     8005e9 <vprintfmt+0x15a>
  8005de:	8b 34 9d 20 1b 80 00 	mov    0x801b20(,%ebx,4),%esi
  8005e5:	85 f6                	test   %esi,%esi
  8005e7:	75 19                	jne    800602 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005e9:	53                   	push   %ebx
  8005ea:	68 c5 1c 80 00       	push   $0x801cc5
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	ff 75 08             	pushl  0x8(%ebp)
  8005f5:	e8 5e 02 00 00       	call   800858 <printfmt>
  8005fa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005fd:	e9 49 02 00 00       	jmp    80084b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800602:	56                   	push   %esi
  800603:	68 ce 1c 80 00       	push   $0x801cce
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 08             	pushl  0x8(%ebp)
  80060e:	e8 45 02 00 00       	call   800858 <printfmt>
  800613:	83 c4 10             	add    $0x10,%esp
			break;
  800616:	e9 30 02 00 00       	jmp    80084b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	83 c0 04             	add    $0x4,%eax
  800621:	89 45 14             	mov    %eax,0x14(%ebp)
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	83 e8 04             	sub    $0x4,%eax
  80062a:	8b 30                	mov    (%eax),%esi
  80062c:	85 f6                	test   %esi,%esi
  80062e:	75 05                	jne    800635 <vprintfmt+0x1a6>
				p = "(null)";
  800630:	be d1 1c 80 00       	mov    $0x801cd1,%esi
			if (width > 0 && padc != '-')
  800635:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800639:	7e 6d                	jle    8006a8 <vprintfmt+0x219>
  80063b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80063f:	74 67                	je     8006a8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800641:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	50                   	push   %eax
  800648:	56                   	push   %esi
  800649:	e8 0c 03 00 00       	call   80095a <strnlen>
  80064e:	83 c4 10             	add    $0x10,%esp
  800651:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800654:	eb 16                	jmp    80066c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800656:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 0c             	pushl  0xc(%ebp)
  800660:	50                   	push   %eax
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	ff d0                	call   *%eax
  800666:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800669:	ff 4d e4             	decl   -0x1c(%ebp)
  80066c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800670:	7f e4                	jg     800656 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800672:	eb 34                	jmp    8006a8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800674:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800678:	74 1c                	je     800696 <vprintfmt+0x207>
  80067a:	83 fb 1f             	cmp    $0x1f,%ebx
  80067d:	7e 05                	jle    800684 <vprintfmt+0x1f5>
  80067f:	83 fb 7e             	cmp    $0x7e,%ebx
  800682:	7e 12                	jle    800696 <vprintfmt+0x207>
					putch('?', putdat);
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	6a 3f                	push   $0x3f
  80068c:	8b 45 08             	mov    0x8(%ebp),%eax
  80068f:	ff d0                	call   *%eax
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	eb 0f                	jmp    8006a5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	ff 75 0c             	pushl  0xc(%ebp)
  80069c:	53                   	push   %ebx
  80069d:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a0:	ff d0                	call   *%eax
  8006a2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a5:	ff 4d e4             	decl   -0x1c(%ebp)
  8006a8:	89 f0                	mov    %esi,%eax
  8006aa:	8d 70 01             	lea    0x1(%eax),%esi
  8006ad:	8a 00                	mov    (%eax),%al
  8006af:	0f be d8             	movsbl %al,%ebx
  8006b2:	85 db                	test   %ebx,%ebx
  8006b4:	74 24                	je     8006da <vprintfmt+0x24b>
  8006b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ba:	78 b8                	js     800674 <vprintfmt+0x1e5>
  8006bc:	ff 4d e0             	decl   -0x20(%ebp)
  8006bf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c3:	79 af                	jns    800674 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006c5:	eb 13                	jmp    8006da <vprintfmt+0x24b>
				putch(' ', putdat);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	6a 20                	push   $0x20
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	ff d0                	call   *%eax
  8006d4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d7:	ff 4d e4             	decl   -0x1c(%ebp)
  8006da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006de:	7f e7                	jg     8006c7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006e0:	e9 66 01 00 00       	jmp    80084b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8006eb:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ee:	50                   	push   %eax
  8006ef:	e8 3c fd ff ff       	call   800430 <getint>
  8006f4:	83 c4 10             	add    $0x10,%esp
  8006f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800700:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800703:	85 d2                	test   %edx,%edx
  800705:	79 23                	jns    80072a <vprintfmt+0x29b>
				putch('-', putdat);
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	ff 75 0c             	pushl  0xc(%ebp)
  80070d:	6a 2d                	push   $0x2d
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	ff d0                	call   *%eax
  800714:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071d:	f7 d8                	neg    %eax
  80071f:	83 d2 00             	adc    $0x0,%edx
  800722:	f7 da                	neg    %edx
  800724:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800727:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80072a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800731:	e9 bc 00 00 00       	jmp    8007f2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	ff 75 e8             	pushl  -0x18(%ebp)
  80073c:	8d 45 14             	lea    0x14(%ebp),%eax
  80073f:	50                   	push   %eax
  800740:	e8 84 fc ff ff       	call   8003c9 <getuint>
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80074b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80074e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800755:	e9 98 00 00 00       	jmp    8007f2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	6a 58                	push   $0x58
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	ff d0                	call   *%eax
  800767:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	6a 58                	push   $0x58
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	ff d0                	call   *%eax
  800777:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	ff 75 0c             	pushl  0xc(%ebp)
  800780:	6a 58                	push   $0x58
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	ff d0                	call   *%eax
  800787:	83 c4 10             	add    $0x10,%esp
			break;
  80078a:	e9 bc 00 00 00       	jmp    80084b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	ff 75 0c             	pushl  0xc(%ebp)
  800795:	6a 30                	push   $0x30
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	ff d0                	call   *%eax
  80079c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	ff 75 0c             	pushl  0xc(%ebp)
  8007a5:	6a 78                	push   $0x78
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	ff d0                	call   *%eax
  8007ac:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	83 c0 04             	add    $0x4,%eax
  8007b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	83 e8 04             	sub    $0x4,%eax
  8007be:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007ca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007d1:	eb 1f                	jmp    8007f2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8007dc:	50                   	push   %eax
  8007dd:	e8 e7 fb ff ff       	call   8003c9 <getuint>
  8007e2:	83 c4 10             	add    $0x10,%esp
  8007e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007eb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007f2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	52                   	push   %edx
  8007fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800800:	50                   	push   %eax
  800801:	ff 75 f4             	pushl  -0xc(%ebp)
  800804:	ff 75 f0             	pushl  -0x10(%ebp)
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	ff 75 08             	pushl  0x8(%ebp)
  80080d:	e8 00 fb ff ff       	call   800312 <printnum>
  800812:	83 c4 20             	add    $0x20,%esp
			break;
  800815:	eb 34                	jmp    80084b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	53                   	push   %ebx
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	ff d0                	call   *%eax
  800823:	83 c4 10             	add    $0x10,%esp
			break;
  800826:	eb 23                	jmp    80084b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	6a 25                	push   $0x25
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	ff d0                	call   *%eax
  800835:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800838:	ff 4d 10             	decl   0x10(%ebp)
  80083b:	eb 03                	jmp    800840 <vprintfmt+0x3b1>
  80083d:	ff 4d 10             	decl   0x10(%ebp)
  800840:	8b 45 10             	mov    0x10(%ebp),%eax
  800843:	48                   	dec    %eax
  800844:	8a 00                	mov    (%eax),%al
  800846:	3c 25                	cmp    $0x25,%al
  800848:	75 f3                	jne    80083d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80084a:	90                   	nop
		}
	}
  80084b:	e9 47 fc ff ff       	jmp    800497 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800850:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800851:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800854:	5b                   	pop    %ebx
  800855:	5e                   	pop    %esi
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80085e:	8d 45 10             	lea    0x10(%ebp),%eax
  800861:	83 c0 04             	add    $0x4,%eax
  800864:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800867:	8b 45 10             	mov    0x10(%ebp),%eax
  80086a:	ff 75 f4             	pushl  -0xc(%ebp)
  80086d:	50                   	push   %eax
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	ff 75 08             	pushl  0x8(%ebp)
  800874:	e8 16 fc ff ff       	call   80048f <vprintfmt>
  800879:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80087c:	90                   	nop
  80087d:	c9                   	leave  
  80087e:	c3                   	ret    

0080087f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800882:	8b 45 0c             	mov    0xc(%ebp),%eax
  800885:	8b 40 08             	mov    0x8(%eax),%eax
  800888:	8d 50 01             	lea    0x1(%eax),%edx
  80088b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800891:	8b 45 0c             	mov    0xc(%ebp),%eax
  800894:	8b 10                	mov    (%eax),%edx
  800896:	8b 45 0c             	mov    0xc(%ebp),%eax
  800899:	8b 40 04             	mov    0x4(%eax),%eax
  80089c:	39 c2                	cmp    %eax,%edx
  80089e:	73 12                	jae    8008b2 <sprintputch+0x33>
		*b->buf++ = ch;
  8008a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a3:	8b 00                	mov    (%eax),%eax
  8008a5:	8d 48 01             	lea    0x1(%eax),%ecx
  8008a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ab:	89 0a                	mov    %ecx,(%edx)
  8008ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8008b0:	88 10                	mov    %dl,(%eax)
}
  8008b2:	90                   	nop
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	01 d0                	add    %edx,%eax
  8008cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008da:	74 06                	je     8008e2 <vsnprintf+0x2d>
  8008dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e0:	7f 07                	jg     8008e9 <vsnprintf+0x34>
		return -E_INVAL;
  8008e2:	b8 03 00 00 00       	mov    $0x3,%eax
  8008e7:	eb 20                	jmp    800909 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e9:	ff 75 14             	pushl  0x14(%ebp)
  8008ec:	ff 75 10             	pushl  0x10(%ebp)
  8008ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008f2:	50                   	push   %eax
  8008f3:	68 7f 08 80 00       	push   $0x80087f
  8008f8:	e8 92 fb ff ff       	call   80048f <vprintfmt>
  8008fd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800900:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800903:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800906:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800909:	c9                   	leave  
  80090a:	c3                   	ret    

0080090b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800911:	8d 45 10             	lea    0x10(%ebp),%eax
  800914:	83 c0 04             	add    $0x4,%eax
  800917:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80091a:	8b 45 10             	mov    0x10(%ebp),%eax
  80091d:	ff 75 f4             	pushl  -0xc(%ebp)
  800920:	50                   	push   %eax
  800921:	ff 75 0c             	pushl  0xc(%ebp)
  800924:	ff 75 08             	pushl  0x8(%ebp)
  800927:	e8 89 ff ff ff       	call   8008b5 <vsnprintf>
  80092c:	83 c4 10             	add    $0x10,%esp
  80092f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800932:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800935:	c9                   	leave  
  800936:	c3                   	ret    

00800937 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80093d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800944:	eb 06                	jmp    80094c <strlen+0x15>
		n++;
  800946:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800949:	ff 45 08             	incl   0x8(%ebp)
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8a 00                	mov    (%eax),%al
  800951:	84 c0                	test   %al,%al
  800953:	75 f1                	jne    800946 <strlen+0xf>
		n++;
	return n;
  800955:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800958:	c9                   	leave  
  800959:	c3                   	ret    

0080095a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800960:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800967:	eb 09                	jmp    800972 <strnlen+0x18>
		n++;
  800969:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80096c:	ff 45 08             	incl   0x8(%ebp)
  80096f:	ff 4d 0c             	decl   0xc(%ebp)
  800972:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800976:	74 09                	je     800981 <strnlen+0x27>
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	8a 00                	mov    (%eax),%al
  80097d:	84 c0                	test   %al,%al
  80097f:	75 e8                	jne    800969 <strnlen+0xf>
		n++;
	return n;
  800981:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800984:	c9                   	leave  
  800985:	c3                   	ret    

00800986 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800992:	90                   	nop
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8d 50 01             	lea    0x1(%eax),%edx
  800999:	89 55 08             	mov    %edx,0x8(%ebp)
  80099c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009a2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009a5:	8a 12                	mov    (%edx),%dl
  8009a7:	88 10                	mov    %dl,(%eax)
  8009a9:	8a 00                	mov    (%eax),%al
  8009ab:	84 c0                	test   %al,%al
  8009ad:	75 e4                	jne    800993 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009b2:	c9                   	leave  
  8009b3:	c3                   	ret    

008009b4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009c7:	eb 1f                	jmp    8009e8 <strncpy+0x34>
		*dst++ = *src;
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8d 50 01             	lea    0x1(%eax),%edx
  8009cf:	89 55 08             	mov    %edx,0x8(%ebp)
  8009d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d5:	8a 12                	mov    (%edx),%dl
  8009d7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009dc:	8a 00                	mov    (%eax),%al
  8009de:	84 c0                	test   %al,%al
  8009e0:	74 03                	je     8009e5 <strncpy+0x31>
			src++;
  8009e2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e5:	ff 45 fc             	incl   -0x4(%ebp)
  8009e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009eb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009ee:	72 d9                	jb     8009c9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009f3:	c9                   	leave  
  8009f4:	c3                   	ret    

008009f5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a05:	74 30                	je     800a37 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a07:	eb 16                	jmp    800a1f <strlcpy+0x2a>
			*dst++ = *src++;
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8d 50 01             	lea    0x1(%eax),%edx
  800a0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a18:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a1b:	8a 12                	mov    (%edx),%dl
  800a1d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a1f:	ff 4d 10             	decl   0x10(%ebp)
  800a22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a26:	74 09                	je     800a31 <strlcpy+0x3c>
  800a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2b:	8a 00                	mov    (%eax),%al
  800a2d:	84 c0                	test   %al,%al
  800a2f:	75 d8                	jne    800a09 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a37:	8b 55 08             	mov    0x8(%ebp),%edx
  800a3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a3d:	29 c2                	sub    %eax,%edx
  800a3f:	89 d0                	mov    %edx,%eax
}
  800a41:	c9                   	leave  
  800a42:	c3                   	ret    

00800a43 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a46:	eb 06                	jmp    800a4e <strcmp+0xb>
		p++, q++;
  800a48:	ff 45 08             	incl   0x8(%ebp)
  800a4b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	8a 00                	mov    (%eax),%al
  800a53:	84 c0                	test   %al,%al
  800a55:	74 0e                	je     800a65 <strcmp+0x22>
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	8a 10                	mov    (%eax),%dl
  800a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5f:	8a 00                	mov    (%eax),%al
  800a61:	38 c2                	cmp    %al,%dl
  800a63:	74 e3                	je     800a48 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	8a 00                	mov    (%eax),%al
  800a6a:	0f b6 d0             	movzbl %al,%edx
  800a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a70:	8a 00                	mov    (%eax),%al
  800a72:	0f b6 c0             	movzbl %al,%eax
  800a75:	29 c2                	sub    %eax,%edx
  800a77:	89 d0                	mov    %edx,%eax
}
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a7e:	eb 09                	jmp    800a89 <strncmp+0xe>
		n--, p++, q++;
  800a80:	ff 4d 10             	decl   0x10(%ebp)
  800a83:	ff 45 08             	incl   0x8(%ebp)
  800a86:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a8d:	74 17                	je     800aa6 <strncmp+0x2b>
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8a 00                	mov    (%eax),%al
  800a94:	84 c0                	test   %al,%al
  800a96:	74 0e                	je     800aa6 <strncmp+0x2b>
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	8a 10                	mov    (%eax),%dl
  800a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	38 c2                	cmp    %al,%dl
  800aa4:	74 da                	je     800a80 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800aa6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aaa:	75 07                	jne    800ab3 <strncmp+0x38>
		return 0;
  800aac:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab1:	eb 14                	jmp    800ac7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8a 00                	mov    (%eax),%al
  800ab8:	0f b6 d0             	movzbl %al,%edx
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	8a 00                	mov    (%eax),%al
  800ac0:	0f b6 c0             	movzbl %al,%eax
  800ac3:	29 c2                	sub    %eax,%edx
  800ac5:	89 d0                	mov    %edx,%eax
}
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    

00800ac9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	83 ec 04             	sub    $0x4,%esp
  800acf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ad5:	eb 12                	jmp    800ae9 <strchr+0x20>
		if (*s == c)
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	8a 00                	mov    (%eax),%al
  800adc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800adf:	75 05                	jne    800ae6 <strchr+0x1d>
			return (char *) s;
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	eb 11                	jmp    800af7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ae6:	ff 45 08             	incl   0x8(%ebp)
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8a 00                	mov    (%eax),%al
  800aee:	84 c0                	test   %al,%al
  800af0:	75 e5                	jne    800ad7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800af2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af7:	c9                   	leave  
  800af8:	c3                   	ret    

00800af9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	83 ec 04             	sub    $0x4,%esp
  800aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b02:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b05:	eb 0d                	jmp    800b14 <strfind+0x1b>
		if (*s == c)
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8a 00                	mov    (%eax),%al
  800b0c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b0f:	74 0e                	je     800b1f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b11:	ff 45 08             	incl   0x8(%ebp)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	75 ea                	jne    800b07 <strfind+0xe>
  800b1d:	eb 01                	jmp    800b20 <strfind+0x27>
		if (*s == c)
			break;
  800b1f:	90                   	nop
	return (char *) s;
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b23:	c9                   	leave  
  800b24:	c3                   	ret    

00800b25 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b31:	8b 45 10             	mov    0x10(%ebp),%eax
  800b34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b37:	eb 0e                	jmp    800b47 <memset+0x22>
		*p++ = c;
  800b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b3c:	8d 50 01             	lea    0x1(%eax),%edx
  800b3f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b45:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b47:	ff 4d f8             	decl   -0x8(%ebp)
  800b4a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b4e:	79 e9                	jns    800b39 <memset+0x14>
		*p++ = c;

	return v;
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b67:	eb 16                	jmp    800b7f <memcpy+0x2a>
		*d++ = *s++;
  800b69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b6c:	8d 50 01             	lea    0x1(%eax),%edx
  800b6f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b72:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b75:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b78:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b7b:	8a 12                	mov    (%edx),%dl
  800b7d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b85:	89 55 10             	mov    %edx,0x10(%ebp)
  800b88:	85 c0                	test   %eax,%eax
  800b8a:	75 dd                	jne    800b69 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ba3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ba9:	73 50                	jae    800bfb <memmove+0x6a>
  800bab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bae:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb1:	01 d0                	add    %edx,%eax
  800bb3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bb6:	76 43                	jbe    800bfb <memmove+0x6a>
		s += n;
  800bb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bc4:	eb 10                	jmp    800bd6 <memmove+0x45>
			*--d = *--s;
  800bc6:	ff 4d f8             	decl   -0x8(%ebp)
  800bc9:	ff 4d fc             	decl   -0x4(%ebp)
  800bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bcf:	8a 10                	mov    (%eax),%dl
  800bd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bd4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bdc:	89 55 10             	mov    %edx,0x10(%ebp)
  800bdf:	85 c0                	test   %eax,%eax
  800be1:	75 e3                	jne    800bc6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be3:	eb 23                	jmp    800c08 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800be5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be8:	8d 50 01             	lea    0x1(%eax),%edx
  800beb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bf1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bf7:	8a 12                	mov    (%edx),%dl
  800bf9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c01:	89 55 10             	mov    %edx,0x10(%ebp)
  800c04:	85 c0                	test   %eax,%eax
  800c06:	75 dd                	jne    800be5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c1f:	eb 2a                	jmp    800c4b <memcmp+0x3e>
		if (*s1 != *s2)
  800c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c24:	8a 10                	mov    (%eax),%dl
  800c26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c29:	8a 00                	mov    (%eax),%al
  800c2b:	38 c2                	cmp    %al,%dl
  800c2d:	74 16                	je     800c45 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c32:	8a 00                	mov    (%eax),%al
  800c34:	0f b6 d0             	movzbl %al,%edx
  800c37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c3a:	8a 00                	mov    (%eax),%al
  800c3c:	0f b6 c0             	movzbl %al,%eax
  800c3f:	29 c2                	sub    %eax,%edx
  800c41:	89 d0                	mov    %edx,%eax
  800c43:	eb 18                	jmp    800c5d <memcmp+0x50>
		s1++, s2++;
  800c45:	ff 45 fc             	incl   -0x4(%ebp)
  800c48:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c51:	89 55 10             	mov    %edx,0x10(%ebp)
  800c54:	85 c0                	test   %eax,%eax
  800c56:	75 c9                	jne    800c21 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c5d:	c9                   	leave  
  800c5e:	c3                   	ret    

00800c5f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c65:	8b 55 08             	mov    0x8(%ebp),%edx
  800c68:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6b:	01 d0                	add    %edx,%eax
  800c6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c70:	eb 15                	jmp    800c87 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8a 00                	mov    (%eax),%al
  800c77:	0f b6 d0             	movzbl %al,%edx
  800c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7d:	0f b6 c0             	movzbl %al,%eax
  800c80:	39 c2                	cmp    %eax,%edx
  800c82:	74 0d                	je     800c91 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c84:	ff 45 08             	incl   0x8(%ebp)
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c8d:	72 e3                	jb     800c72 <memfind+0x13>
  800c8f:	eb 01                	jmp    800c92 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c91:	90                   	nop
	return (void *) s;
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ca4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cab:	eb 03                	jmp    800cb0 <strtol+0x19>
		s++;
  800cad:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8a 00                	mov    (%eax),%al
  800cb5:	3c 20                	cmp    $0x20,%al
  800cb7:	74 f4                	je     800cad <strtol+0x16>
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	3c 09                	cmp    $0x9,%al
  800cc0:	74 eb                	je     800cad <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	3c 2b                	cmp    $0x2b,%al
  800cc9:	75 05                	jne    800cd0 <strtol+0x39>
		s++;
  800ccb:	ff 45 08             	incl   0x8(%ebp)
  800cce:	eb 13                	jmp    800ce3 <strtol+0x4c>
	else if (*s == '-')
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	3c 2d                	cmp    $0x2d,%al
  800cd7:	75 0a                	jne    800ce3 <strtol+0x4c>
		s++, neg = 1;
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce7:	74 06                	je     800cef <strtol+0x58>
  800ce9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ced:	75 20                	jne    800d0f <strtol+0x78>
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	3c 30                	cmp    $0x30,%al
  800cf6:	75 17                	jne    800d0f <strtol+0x78>
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	40                   	inc    %eax
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	3c 78                	cmp    $0x78,%al
  800d00:	75 0d                	jne    800d0f <strtol+0x78>
		s += 2, base = 16;
  800d02:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d06:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d0d:	eb 28                	jmp    800d37 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d13:	75 15                	jne    800d2a <strtol+0x93>
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	3c 30                	cmp    $0x30,%al
  800d1c:	75 0c                	jne    800d2a <strtol+0x93>
		s++, base = 8;
  800d1e:	ff 45 08             	incl   0x8(%ebp)
  800d21:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d28:	eb 0d                	jmp    800d37 <strtol+0xa0>
	else if (base == 0)
  800d2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2e:	75 07                	jne    800d37 <strtol+0xa0>
		base = 10;
  800d30:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	8a 00                	mov    (%eax),%al
  800d3c:	3c 2f                	cmp    $0x2f,%al
  800d3e:	7e 19                	jle    800d59 <strtol+0xc2>
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	3c 39                	cmp    $0x39,%al
  800d47:	7f 10                	jg     800d59 <strtol+0xc2>
			dig = *s - '0';
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	0f be c0             	movsbl %al,%eax
  800d51:	83 e8 30             	sub    $0x30,%eax
  800d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d57:	eb 42                	jmp    800d9b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	3c 60                	cmp    $0x60,%al
  800d60:	7e 19                	jle    800d7b <strtol+0xe4>
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	3c 7a                	cmp    $0x7a,%al
  800d69:	7f 10                	jg     800d7b <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	0f be c0             	movsbl %al,%eax
  800d73:	83 e8 57             	sub    $0x57,%eax
  800d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d79:	eb 20                	jmp    800d9b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8a 00                	mov    (%eax),%al
  800d80:	3c 40                	cmp    $0x40,%al
  800d82:	7e 39                	jle    800dbd <strtol+0x126>
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	3c 5a                	cmp    $0x5a,%al
  800d8b:	7f 30                	jg     800dbd <strtol+0x126>
			dig = *s - 'A' + 10;
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8a 00                	mov    (%eax),%al
  800d92:	0f be c0             	movsbl %al,%eax
  800d95:	83 e8 37             	sub    $0x37,%eax
  800d98:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d9e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800da1:	7d 19                	jge    800dbc <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800da3:	ff 45 08             	incl   0x8(%ebp)
  800da6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dad:	89 c2                	mov    %eax,%edx
  800daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db2:	01 d0                	add    %edx,%eax
  800db4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800db7:	e9 7b ff ff ff       	jmp    800d37 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dbc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dbd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc1:	74 08                	je     800dcb <strtol+0x134>
		*endptr = (char *) s;
  800dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dcb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dcf:	74 07                	je     800dd8 <strtol+0x141>
  800dd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd4:	f7 d8                	neg    %eax
  800dd6:	eb 03                	jmp    800ddb <strtol+0x144>
  800dd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <ltostr>:

void
ltostr(long value, char *str)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800de3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800df1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df5:	79 13                	jns    800e0a <ltostr+0x2d>
	{
		neg = 1;
  800df7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e04:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e07:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e12:	99                   	cltd   
  800e13:	f7 f9                	idiv   %ecx
  800e15:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1b:	8d 50 01             	lea    0x1(%eax),%edx
  800e1e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e21:	89 c2                	mov    %eax,%edx
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	01 d0                	add    %edx,%eax
  800e28:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e2b:	83 c2 30             	add    $0x30,%edx
  800e2e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e33:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e38:	f7 e9                	imul   %ecx
  800e3a:	c1 fa 02             	sar    $0x2,%edx
  800e3d:	89 c8                	mov    %ecx,%eax
  800e3f:	c1 f8 1f             	sar    $0x1f,%eax
  800e42:	29 c2                	sub    %eax,%edx
  800e44:	89 d0                	mov    %edx,%eax
  800e46:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e4c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e51:	f7 e9                	imul   %ecx
  800e53:	c1 fa 02             	sar    $0x2,%edx
  800e56:	89 c8                	mov    %ecx,%eax
  800e58:	c1 f8 1f             	sar    $0x1f,%eax
  800e5b:	29 c2                	sub    %eax,%edx
  800e5d:	89 d0                	mov    %edx,%eax
  800e5f:	c1 e0 02             	shl    $0x2,%eax
  800e62:	01 d0                	add    %edx,%eax
  800e64:	01 c0                	add    %eax,%eax
  800e66:	29 c1                	sub    %eax,%ecx
  800e68:	89 ca                	mov    %ecx,%edx
  800e6a:	85 d2                	test   %edx,%edx
  800e6c:	75 9c                	jne    800e0a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e78:	48                   	dec    %eax
  800e79:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e80:	74 3d                	je     800ebf <ltostr+0xe2>
		start = 1 ;
  800e82:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e89:	eb 34                	jmp    800ebf <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	01 d0                	add    %edx,%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	01 c2                	add    %eax,%edx
  800ea0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea6:	01 c8                	add    %ecx,%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800eac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	01 c2                	add    %eax,%edx
  800eb4:	8a 45 eb             	mov    -0x15(%ebp),%al
  800eb7:	88 02                	mov    %al,(%edx)
		start++ ;
  800eb9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ebc:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ec5:	7c c4                	jl     800e8b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ec7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	01 d0                	add    %edx,%eax
  800ecf:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ed2:	90                   	nop
  800ed3:	c9                   	leave  
  800ed4:	c3                   	ret    

00800ed5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800edb:	ff 75 08             	pushl  0x8(%ebp)
  800ede:	e8 54 fa ff ff       	call   800937 <strlen>
  800ee3:	83 c4 04             	add    $0x4,%esp
  800ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ee9:	ff 75 0c             	pushl  0xc(%ebp)
  800eec:	e8 46 fa ff ff       	call   800937 <strlen>
  800ef1:	83 c4 04             	add    $0x4,%esp
  800ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ef7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800efe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f05:	eb 17                	jmp    800f1e <strcconcat+0x49>
		final[s] = str1[s] ;
  800f07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0d:	01 c2                	add    %eax,%edx
  800f0f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	01 c8                	add    %ecx,%eax
  800f17:	8a 00                	mov    (%eax),%al
  800f19:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f1b:	ff 45 fc             	incl   -0x4(%ebp)
  800f1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f21:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f24:	7c e1                	jl     800f07 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f26:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f34:	eb 1f                	jmp    800f55 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f39:	8d 50 01             	lea    0x1(%eax),%edx
  800f3c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	01 c2                	add    %eax,%edx
  800f46:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4c:	01 c8                	add    %ecx,%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f52:	ff 45 f8             	incl   -0x8(%ebp)
  800f55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f58:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f5b:	7c d9                	jl     800f36 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f60:	8b 45 10             	mov    0x10(%ebp),%eax
  800f63:	01 d0                	add    %edx,%eax
  800f65:	c6 00 00             	movb   $0x0,(%eax)
}
  800f68:	90                   	nop
  800f69:	c9                   	leave  
  800f6a:	c3                   	ret    

00800f6b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f77:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7a:	8b 00                	mov    (%eax),%eax
  800f7c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f83:	8b 45 10             	mov    0x10(%ebp),%eax
  800f86:	01 d0                	add    %edx,%eax
  800f88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f8e:	eb 0c                	jmp    800f9c <strsplit+0x31>
			*string++ = 0;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	8d 50 01             	lea    0x1(%eax),%edx
  800f96:	89 55 08             	mov    %edx,0x8(%ebp)
  800f99:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	84 c0                	test   %al,%al
  800fa3:	74 18                	je     800fbd <strsplit+0x52>
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	0f be c0             	movsbl %al,%eax
  800fad:	50                   	push   %eax
  800fae:	ff 75 0c             	pushl  0xc(%ebp)
  800fb1:	e8 13 fb ff ff       	call   800ac9 <strchr>
  800fb6:	83 c4 08             	add    $0x8,%esp
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	75 d3                	jne    800f90 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	8a 00                	mov    (%eax),%al
  800fc2:	84 c0                	test   %al,%al
  800fc4:	74 5a                	je     801020 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fc6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc9:	8b 00                	mov    (%eax),%eax
  800fcb:	83 f8 0f             	cmp    $0xf,%eax
  800fce:	75 07                	jne    800fd7 <strsplit+0x6c>
		{
			return 0;
  800fd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd5:	eb 66                	jmp    80103d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fda:	8b 00                	mov    (%eax),%eax
  800fdc:	8d 48 01             	lea    0x1(%eax),%ecx
  800fdf:	8b 55 14             	mov    0x14(%ebp),%edx
  800fe2:	89 0a                	mov    %ecx,(%edx)
  800fe4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800feb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fee:	01 c2                	add    %eax,%edx
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ff5:	eb 03                	jmp    800ffa <strsplit+0x8f>
			string++;
  800ff7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	84 c0                	test   %al,%al
  801001:	74 8b                	je     800f8e <strsplit+0x23>
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	0f be c0             	movsbl %al,%eax
  80100b:	50                   	push   %eax
  80100c:	ff 75 0c             	pushl  0xc(%ebp)
  80100f:	e8 b5 fa ff ff       	call   800ac9 <strchr>
  801014:	83 c4 08             	add    $0x8,%esp
  801017:	85 c0                	test   %eax,%eax
  801019:	74 dc                	je     800ff7 <strsplit+0x8c>
			string++;
	}
  80101b:	e9 6e ff ff ff       	jmp    800f8e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801020:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801021:	8b 45 14             	mov    0x14(%ebp),%eax
  801024:	8b 00                	mov    (%eax),%eax
  801026:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80102d:	8b 45 10             	mov    0x10(%ebp),%eax
  801030:	01 d0                	add    %edx,%eax
  801032:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801038:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80103d:	c9                   	leave  
  80103e:	c3                   	ret    

0080103f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
  801042:	57                   	push   %edi
  801043:	56                   	push   %esi
  801044:	53                   	push   %ebx
  801045:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801051:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801054:	8b 7d 18             	mov    0x18(%ebp),%edi
  801057:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80105a:	cd 30                	int    $0x30
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80105f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801062:	83 c4 10             	add    $0x10,%esp
  801065:	5b                   	pop    %ebx
  801066:	5e                   	pop    %esi
  801067:	5f                   	pop    %edi
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    

0080106a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	83 ec 04             	sub    $0x4,%esp
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801076:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	6a 00                	push   $0x0
  80107f:	6a 00                	push   $0x0
  801081:	52                   	push   %edx
  801082:	ff 75 0c             	pushl  0xc(%ebp)
  801085:	50                   	push   %eax
  801086:	6a 00                	push   $0x0
  801088:	e8 b2 ff ff ff       	call   80103f <syscall>
  80108d:	83 c4 18             	add    $0x18,%esp
}
  801090:	90                   	nop
  801091:	c9                   	leave  
  801092:	c3                   	ret    

00801093 <sys_cgetc>:

int
sys_cgetc(void)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801096:	6a 00                	push   $0x0
  801098:	6a 00                	push   $0x0
  80109a:	6a 00                	push   $0x0
  80109c:	6a 00                	push   $0x0
  80109e:	6a 00                	push   $0x0
  8010a0:	6a 01                	push   $0x1
  8010a2:	e8 98 ff ff ff       	call   80103f <syscall>
  8010a7:	83 c4 18             	add    $0x18,%esp
}
  8010aa:	c9                   	leave  
  8010ab:	c3                   	ret    

008010ac <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	6a 00                	push   $0x0
  8010b4:	6a 00                	push   $0x0
  8010b6:	6a 00                	push   $0x0
  8010b8:	6a 00                	push   $0x0
  8010ba:	50                   	push   %eax
  8010bb:	6a 05                	push   $0x5
  8010bd:	e8 7d ff ff ff       	call   80103f <syscall>
  8010c2:	83 c4 18             	add    $0x18,%esp
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8010ca:	6a 00                	push   $0x0
  8010cc:	6a 00                	push   $0x0
  8010ce:	6a 00                	push   $0x0
  8010d0:	6a 00                	push   $0x0
  8010d2:	6a 00                	push   $0x0
  8010d4:	6a 02                	push   $0x2
  8010d6:	e8 64 ff ff ff       	call   80103f <syscall>
  8010db:	83 c4 18             	add    $0x18,%esp
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8010e3:	6a 00                	push   $0x0
  8010e5:	6a 00                	push   $0x0
  8010e7:	6a 00                	push   $0x0
  8010e9:	6a 00                	push   $0x0
  8010eb:	6a 00                	push   $0x0
  8010ed:	6a 03                	push   $0x3
  8010ef:	e8 4b ff ff ff       	call   80103f <syscall>
  8010f4:	83 c4 18             	add    $0x18,%esp
}
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8010fc:	6a 00                	push   $0x0
  8010fe:	6a 00                	push   $0x0
  801100:	6a 00                	push   $0x0
  801102:	6a 00                	push   $0x0
  801104:	6a 00                	push   $0x0
  801106:	6a 04                	push   $0x4
  801108:	e8 32 ff ff ff       	call   80103f <syscall>
  80110d:	83 c4 18             	add    $0x18,%esp
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <sys_env_exit>:


void sys_env_exit(void)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801115:	6a 00                	push   $0x0
  801117:	6a 00                	push   $0x0
  801119:	6a 00                	push   $0x0
  80111b:	6a 00                	push   $0x0
  80111d:	6a 00                	push   $0x0
  80111f:	6a 06                	push   $0x6
  801121:	e8 19 ff ff ff       	call   80103f <syscall>
  801126:	83 c4 18             	add    $0x18,%esp
}
  801129:	90                   	nop
  80112a:	c9                   	leave  
  80112b:	c3                   	ret    

0080112c <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80112f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	6a 00                	push   $0x0
  801137:	6a 00                	push   $0x0
  801139:	6a 00                	push   $0x0
  80113b:	52                   	push   %edx
  80113c:	50                   	push   %eax
  80113d:	6a 07                	push   $0x7
  80113f:	e8 fb fe ff ff       	call   80103f <syscall>
  801144:	83 c4 18             	add    $0x18,%esp
}
  801147:	c9                   	leave  
  801148:	c3                   	ret    

00801149 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	56                   	push   %esi
  80114d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80114e:	8b 75 18             	mov    0x18(%ebp),%esi
  801151:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801154:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	56                   	push   %esi
  80115e:	53                   	push   %ebx
  80115f:	51                   	push   %ecx
  801160:	52                   	push   %edx
  801161:	50                   	push   %eax
  801162:	6a 08                	push   $0x8
  801164:	e8 d6 fe ff ff       	call   80103f <syscall>
  801169:	83 c4 18             	add    $0x18,%esp
}
  80116c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116f:	5b                   	pop    %ebx
  801170:	5e                   	pop    %esi
  801171:	5d                   	pop    %ebp
  801172:	c3                   	ret    

00801173 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801176:	8b 55 0c             	mov    0xc(%ebp),%edx
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	6a 00                	push   $0x0
  80117e:	6a 00                	push   $0x0
  801180:	6a 00                	push   $0x0
  801182:	52                   	push   %edx
  801183:	50                   	push   %eax
  801184:	6a 09                	push   $0x9
  801186:	e8 b4 fe ff ff       	call   80103f <syscall>
  80118b:	83 c4 18             	add    $0x18,%esp
}
  80118e:	c9                   	leave  
  80118f:	c3                   	ret    

00801190 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801193:	6a 00                	push   $0x0
  801195:	6a 00                	push   $0x0
  801197:	6a 00                	push   $0x0
  801199:	ff 75 0c             	pushl  0xc(%ebp)
  80119c:	ff 75 08             	pushl  0x8(%ebp)
  80119f:	6a 0a                	push   $0xa
  8011a1:	e8 99 fe ff ff       	call   80103f <syscall>
  8011a6:	83 c4 18             	add    $0x18,%esp
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8011ae:	6a 00                	push   $0x0
  8011b0:	6a 00                	push   $0x0
  8011b2:	6a 00                	push   $0x0
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 00                	push   $0x0
  8011b8:	6a 0b                	push   $0xb
  8011ba:	e8 80 fe ff ff       	call   80103f <syscall>
  8011bf:	83 c4 18             	add    $0x18,%esp
}
  8011c2:	c9                   	leave  
  8011c3:	c3                   	ret    

008011c4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011c7:	6a 00                	push   $0x0
  8011c9:	6a 00                	push   $0x0
  8011cb:	6a 00                	push   $0x0
  8011cd:	6a 00                	push   $0x0
  8011cf:	6a 00                	push   $0x0
  8011d1:	6a 0c                	push   $0xc
  8011d3:	e8 67 fe ff ff       	call   80103f <syscall>
  8011d8:	83 c4 18             	add    $0x18,%esp
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011e0:	6a 00                	push   $0x0
  8011e2:	6a 00                	push   $0x0
  8011e4:	6a 00                	push   $0x0
  8011e6:	6a 00                	push   $0x0
  8011e8:	6a 00                	push   $0x0
  8011ea:	6a 0d                	push   $0xd
  8011ec:	e8 4e fe ff ff       	call   80103f <syscall>
  8011f1:	83 c4 18             	add    $0x18,%esp
}
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 00                	push   $0x0
  8011ff:	ff 75 0c             	pushl  0xc(%ebp)
  801202:	ff 75 08             	pushl  0x8(%ebp)
  801205:	6a 11                	push   $0x11
  801207:	e8 33 fe ff ff       	call   80103f <syscall>
  80120c:	83 c4 18             	add    $0x18,%esp
	return;
  80120f:	90                   	nop
}
  801210:	c9                   	leave  
  801211:	c3                   	ret    

00801212 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801215:	6a 00                	push   $0x0
  801217:	6a 00                	push   $0x0
  801219:	6a 00                	push   $0x0
  80121b:	ff 75 0c             	pushl  0xc(%ebp)
  80121e:	ff 75 08             	pushl  0x8(%ebp)
  801221:	6a 12                	push   $0x12
  801223:	e8 17 fe ff ff       	call   80103f <syscall>
  801228:	83 c4 18             	add    $0x18,%esp
	return ;
  80122b:	90                   	nop
}
  80122c:	c9                   	leave  
  80122d:	c3                   	ret    

0080122e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 0e                	push   $0xe
  80123d:	e8 fd fd ff ff       	call   80103f <syscall>
  801242:	83 c4 18             	add    $0x18,%esp
}
  801245:	c9                   	leave  
  801246:	c3                   	ret    

00801247 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80124a:	6a 00                	push   $0x0
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	ff 75 08             	pushl  0x8(%ebp)
  801255:	6a 0f                	push   $0xf
  801257:	e8 e3 fd ff ff       	call   80103f <syscall>
  80125c:	83 c4 18             	add    $0x18,%esp
}
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 00                	push   $0x0
  80126a:	6a 00                	push   $0x0
  80126c:	6a 00                	push   $0x0
  80126e:	6a 10                	push   $0x10
  801270:	e8 ca fd ff ff       	call   80103f <syscall>
  801275:	83 c4 18             	add    $0x18,%esp
}
  801278:	90                   	nop
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	6a 14                	push   $0x14
  80128a:	e8 b0 fd ff ff       	call   80103f <syscall>
  80128f:	83 c4 18             	add    $0x18,%esp
}
  801292:	90                   	nop
  801293:	c9                   	leave  
  801294:	c3                   	ret    

00801295 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801298:	6a 00                	push   $0x0
  80129a:	6a 00                	push   $0x0
  80129c:	6a 00                	push   $0x0
  80129e:	6a 00                	push   $0x0
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 15                	push   $0x15
  8012a4:	e8 96 fd ff ff       	call   80103f <syscall>
  8012a9:	83 c4 18             	add    $0x18,%esp
}
  8012ac:	90                   	nop
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <sys_cputc>:


void
sys_cputc(const char c)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 04             	sub    $0x4,%esp
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8012bb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	50                   	push   %eax
  8012c8:	6a 16                	push   $0x16
  8012ca:	e8 70 fd ff ff       	call   80103f <syscall>
  8012cf:	83 c4 18             	add    $0x18,%esp
}
  8012d2:	90                   	nop
  8012d3:	c9                   	leave  
  8012d4:	c3                   	ret    

008012d5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 17                	push   $0x17
  8012e4:	e8 56 fd ff ff       	call   80103f <syscall>
  8012e9:	83 c4 18             	add    $0x18,%esp
}
  8012ec:	90                   	nop
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	ff 75 0c             	pushl  0xc(%ebp)
  8012fe:	50                   	push   %eax
  8012ff:	6a 18                	push   $0x18
  801301:	e8 39 fd ff ff       	call   80103f <syscall>
  801306:	83 c4 18             	add    $0x18,%esp
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80130e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	52                   	push   %edx
  80131b:	50                   	push   %eax
  80131c:	6a 1b                	push   $0x1b
  80131e:	e8 1c fd ff ff       	call   80103f <syscall>
  801323:	83 c4 18             	add    $0x18,%esp
}
  801326:	c9                   	leave  
  801327:	c3                   	ret    

00801328 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80132b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	52                   	push   %edx
  801338:	50                   	push   %eax
  801339:	6a 19                	push   $0x19
  80133b:	e8 ff fc ff ff       	call   80103f <syscall>
  801340:	83 c4 18             	add    $0x18,%esp
}
  801343:	90                   	nop
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801349:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	52                   	push   %edx
  801356:	50                   	push   %eax
  801357:	6a 1a                	push   $0x1a
  801359:	e8 e1 fc ff ff       	call   80103f <syscall>
  80135e:	83 c4 18             	add    $0x18,%esp
}
  801361:	90                   	nop
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	8b 45 10             	mov    0x10(%ebp),%eax
  80136d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801370:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801373:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	6a 00                	push   $0x0
  80137c:	51                   	push   %ecx
  80137d:	52                   	push   %edx
  80137e:	ff 75 0c             	pushl  0xc(%ebp)
  801381:	50                   	push   %eax
  801382:	6a 1c                	push   $0x1c
  801384:	e8 b6 fc ff ff       	call   80103f <syscall>
  801389:	83 c4 18             	add    $0x18,%esp
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801391:	8b 55 0c             	mov    0xc(%ebp),%edx
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	52                   	push   %edx
  80139e:	50                   	push   %eax
  80139f:	6a 1d                	push   $0x1d
  8013a1:	e8 99 fc ff ff       	call   80103f <syscall>
  8013a6:	83 c4 18             	add    $0x18,%esp
}
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    

008013ab <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8013ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	51                   	push   %ecx
  8013bc:	52                   	push   %edx
  8013bd:	50                   	push   %eax
  8013be:	6a 1e                	push   $0x1e
  8013c0:	e8 7a fc ff ff       	call   80103f <syscall>
  8013c5:	83 c4 18             	add    $0x18,%esp
}
  8013c8:	c9                   	leave  
  8013c9:	c3                   	ret    

008013ca <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8013cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	52                   	push   %edx
  8013da:	50                   	push   %eax
  8013db:	6a 1f                	push   $0x1f
  8013dd:	e8 5d fc ff ff       	call   80103f <syscall>
  8013e2:	83 c4 18             	add    $0x18,%esp
}
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    

008013e7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 20                	push   $0x20
  8013f6:	e8 44 fc ff ff       	call   80103f <syscall>
  8013fb:	83 c4 18             	add    $0x18,%esp
}
  8013fe:	c9                   	leave  
  8013ff:	c3                   	ret    

00801400 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	ff 75 10             	pushl  0x10(%ebp)
  80140d:	ff 75 0c             	pushl  0xc(%ebp)
  801410:	50                   	push   %eax
  801411:	6a 21                	push   $0x21
  801413:	e8 27 fc ff ff       	call   80103f <syscall>
  801418:	83 c4 18             	add    $0x18,%esp
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <sys_run_env>:


void
sys_run_env(int32 envId)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	50                   	push   %eax
  80142c:	6a 22                	push   $0x22
  80142e:	e8 0c fc ff ff       	call   80103f <syscall>
  801433:	83 c4 18             	add    $0x18,%esp
}
  801436:	90                   	nop
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	50                   	push   %eax
  801448:	6a 23                	push   $0x23
  80144a:	e8 f0 fb ff ff       	call   80103f <syscall>
  80144f:	83 c4 18             	add    $0x18,%esp
}
  801452:	90                   	nop
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80145b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80145e:	8d 50 04             	lea    0x4(%eax),%edx
  801461:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	52                   	push   %edx
  80146b:	50                   	push   %eax
  80146c:	6a 24                	push   $0x24
  80146e:	e8 cc fb ff ff       	call   80103f <syscall>
  801473:	83 c4 18             	add    $0x18,%esp
	return result;
  801476:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801479:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147f:	89 01                	mov    %eax,(%ecx)
  801481:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	c9                   	leave  
  801488:	c2 04 00             	ret    $0x4

0080148b <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	ff 75 10             	pushl  0x10(%ebp)
  801495:	ff 75 0c             	pushl  0xc(%ebp)
  801498:	ff 75 08             	pushl  0x8(%ebp)
  80149b:	6a 13                	push   $0x13
  80149d:	e8 9d fb ff ff       	call   80103f <syscall>
  8014a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8014a5:	90                   	nop
}
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 25                	push   $0x25
  8014b7:	e8 83 fb ff ff       	call   80103f <syscall>
  8014bc:	83 c4 18             	add    $0x18,%esp
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	83 ec 04             	sub    $0x4,%esp
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014cd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	50                   	push   %eax
  8014da:	6a 26                	push   $0x26
  8014dc:	e8 5e fb ff ff       	call   80103f <syscall>
  8014e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8014e4:	90                   	nop
}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <rsttst>:
void rsttst()
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 28                	push   $0x28
  8014f6:	e8 44 fb ff ff       	call   80103f <syscall>
  8014fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8014fe:	90                   	nop
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	8b 45 14             	mov    0x14(%ebp),%eax
  80150a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80150d:	8b 55 18             	mov    0x18(%ebp),%edx
  801510:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801514:	52                   	push   %edx
  801515:	50                   	push   %eax
  801516:	ff 75 10             	pushl  0x10(%ebp)
  801519:	ff 75 0c             	pushl  0xc(%ebp)
  80151c:	ff 75 08             	pushl  0x8(%ebp)
  80151f:	6a 27                	push   $0x27
  801521:	e8 19 fb ff ff       	call   80103f <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
	return ;
  801529:	90                   	nop
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <chktst>:
void chktst(uint32 n)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	ff 75 08             	pushl  0x8(%ebp)
  80153a:	6a 29                	push   $0x29
  80153c:	e8 fe fa ff ff       	call   80103f <syscall>
  801541:	83 c4 18             	add    $0x18,%esp
	return ;
  801544:	90                   	nop
}
  801545:	c9                   	leave  
  801546:	c3                   	ret    

00801547 <inctst>:

void inctst()
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 2a                	push   $0x2a
  801556:	e8 e4 fa ff ff       	call   80103f <syscall>
  80155b:	83 c4 18             	add    $0x18,%esp
	return ;
  80155e:	90                   	nop
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <gettst>:
uint32 gettst()
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 2b                	push   $0x2b
  801570:	e8 ca fa ff ff       	call   80103f <syscall>
  801575:	83 c4 18             	add    $0x18,%esp
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 2c                	push   $0x2c
  80158c:	e8 ae fa ff ff       	call   80103f <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
  801594:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801597:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80159b:	75 07                	jne    8015a4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80159d:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a2:	eb 05                	jmp    8015a9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 2c                	push   $0x2c
  8015bd:	e8 7d fa ff ff       	call   80103f <syscall>
  8015c2:	83 c4 18             	add    $0x18,%esp
  8015c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015c8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015cc:	75 07                	jne    8015d5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d3:	eb 05                	jmp    8015da <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 2c                	push   $0x2c
  8015ee:	e8 4c fa ff ff       	call   80103f <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
  8015f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015f9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015fd:	75 07                	jne    801606 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015ff:	b8 01 00 00 00       	mov    $0x1,%eax
  801604:	eb 05                	jmp    80160b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801606:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 2c                	push   $0x2c
  80161f:	e8 1b fa ff ff       	call   80103f <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
  801627:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80162a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80162e:	75 07                	jne    801637 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801630:	b8 01 00 00 00       	mov    $0x1,%eax
  801635:	eb 05                	jmp    80163c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801637:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	ff 75 08             	pushl  0x8(%ebp)
  80164c:	6a 2d                	push   $0x2d
  80164e:	e8 ec f9 ff ff       	call   80103f <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
	return ;
  801656:	90                   	nop
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80165d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801660:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801663:	8b 55 0c             	mov    0xc(%ebp),%edx
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	6a 00                	push   $0x0
  80166b:	53                   	push   %ebx
  80166c:	51                   	push   %ecx
  80166d:	52                   	push   %edx
  80166e:	50                   	push   %eax
  80166f:	6a 2e                	push   $0x2e
  801671:	e8 c9 f9 ff ff       	call   80103f <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
}
  801679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801681:	8b 55 0c             	mov    0xc(%ebp),%edx
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	52                   	push   %edx
  80168e:	50                   	push   %eax
  80168f:	6a 2f                	push   $0x2f
  801691:	e8 a9 f9 ff ff       	call   80103f <syscall>
  801696:	83 c4 18             	add    $0x18,%esp
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8016a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a4:	89 d0                	mov    %edx,%eax
  8016a6:	c1 e0 02             	shl    $0x2,%eax
  8016a9:	01 d0                	add    %edx,%eax
  8016ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b2:	01 d0                	add    %edx,%eax
  8016b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016bb:	01 d0                	add    %edx,%eax
  8016bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016c4:	01 d0                	add    %edx,%eax
  8016c6:	c1 e0 04             	shl    $0x4,%eax
  8016c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8016cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8016d3:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8016d6:	83 ec 0c             	sub    $0xc,%esp
  8016d9:	50                   	push   %eax
  8016da:	e8 76 fd ff ff       	call   801455 <sys_get_virtual_time>
  8016df:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8016e2:	eb 41                	jmp    801725 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8016e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016e7:	83 ec 0c             	sub    $0xc,%esp
  8016ea:	50                   	push   %eax
  8016eb:	e8 65 fd ff ff       	call   801455 <sys_get_virtual_time>
  8016f0:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8016f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016f9:	29 c2                	sub    %eax,%edx
  8016fb:	89 d0                	mov    %edx,%eax
  8016fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801700:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801703:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801706:	89 d1                	mov    %edx,%ecx
  801708:	29 c1                	sub    %eax,%ecx
  80170a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80170d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801710:	39 c2                	cmp    %eax,%edx
  801712:	0f 97 c0             	seta   %al
  801715:	0f b6 c0             	movzbl %al,%eax
  801718:	29 c1                	sub    %eax,%ecx
  80171a:	89 c8                	mov    %ecx,%eax
  80171c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80171f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801722:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801728:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80172b:	72 b7                	jb     8016e4 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80172d:	90                   	nop
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801736:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80173d:	eb 03                	jmp    801742 <busy_wait+0x12>
  80173f:	ff 45 fc             	incl   -0x4(%ebp)
  801742:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801745:	3b 45 08             	cmp    0x8(%ebp),%eax
  801748:	72 f5                	jb     80173f <busy_wait+0xf>
	return i;
  80174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    
  80174f:	90                   	nop

00801750 <__udivdi3>:
  801750:	55                   	push   %ebp
  801751:	57                   	push   %edi
  801752:	56                   	push   %esi
  801753:	53                   	push   %ebx
  801754:	83 ec 1c             	sub    $0x1c,%esp
  801757:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80175b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80175f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801763:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801767:	89 ca                	mov    %ecx,%edx
  801769:	89 f8                	mov    %edi,%eax
  80176b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80176f:	85 f6                	test   %esi,%esi
  801771:	75 2d                	jne    8017a0 <__udivdi3+0x50>
  801773:	39 cf                	cmp    %ecx,%edi
  801775:	77 65                	ja     8017dc <__udivdi3+0x8c>
  801777:	89 fd                	mov    %edi,%ebp
  801779:	85 ff                	test   %edi,%edi
  80177b:	75 0b                	jne    801788 <__udivdi3+0x38>
  80177d:	b8 01 00 00 00       	mov    $0x1,%eax
  801782:	31 d2                	xor    %edx,%edx
  801784:	f7 f7                	div    %edi
  801786:	89 c5                	mov    %eax,%ebp
  801788:	31 d2                	xor    %edx,%edx
  80178a:	89 c8                	mov    %ecx,%eax
  80178c:	f7 f5                	div    %ebp
  80178e:	89 c1                	mov    %eax,%ecx
  801790:	89 d8                	mov    %ebx,%eax
  801792:	f7 f5                	div    %ebp
  801794:	89 cf                	mov    %ecx,%edi
  801796:	89 fa                	mov    %edi,%edx
  801798:	83 c4 1c             	add    $0x1c,%esp
  80179b:	5b                   	pop    %ebx
  80179c:	5e                   	pop    %esi
  80179d:	5f                   	pop    %edi
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    
  8017a0:	39 ce                	cmp    %ecx,%esi
  8017a2:	77 28                	ja     8017cc <__udivdi3+0x7c>
  8017a4:	0f bd fe             	bsr    %esi,%edi
  8017a7:	83 f7 1f             	xor    $0x1f,%edi
  8017aa:	75 40                	jne    8017ec <__udivdi3+0x9c>
  8017ac:	39 ce                	cmp    %ecx,%esi
  8017ae:	72 0a                	jb     8017ba <__udivdi3+0x6a>
  8017b0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8017b4:	0f 87 9e 00 00 00    	ja     801858 <__udivdi3+0x108>
  8017ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8017bf:	89 fa                	mov    %edi,%edx
  8017c1:	83 c4 1c             	add    $0x1c,%esp
  8017c4:	5b                   	pop    %ebx
  8017c5:	5e                   	pop    %esi
  8017c6:	5f                   	pop    %edi
  8017c7:	5d                   	pop    %ebp
  8017c8:	c3                   	ret    
  8017c9:	8d 76 00             	lea    0x0(%esi),%esi
  8017cc:	31 ff                	xor    %edi,%edi
  8017ce:	31 c0                	xor    %eax,%eax
  8017d0:	89 fa                	mov    %edi,%edx
  8017d2:	83 c4 1c             	add    $0x1c,%esp
  8017d5:	5b                   	pop    %ebx
  8017d6:	5e                   	pop    %esi
  8017d7:	5f                   	pop    %edi
  8017d8:	5d                   	pop    %ebp
  8017d9:	c3                   	ret    
  8017da:	66 90                	xchg   %ax,%ax
  8017dc:	89 d8                	mov    %ebx,%eax
  8017de:	f7 f7                	div    %edi
  8017e0:	31 ff                	xor    %edi,%edi
  8017e2:	89 fa                	mov    %edi,%edx
  8017e4:	83 c4 1c             	add    $0x1c,%esp
  8017e7:	5b                   	pop    %ebx
  8017e8:	5e                   	pop    %esi
  8017e9:	5f                   	pop    %edi
  8017ea:	5d                   	pop    %ebp
  8017eb:	c3                   	ret    
  8017ec:	bd 20 00 00 00       	mov    $0x20,%ebp
  8017f1:	89 eb                	mov    %ebp,%ebx
  8017f3:	29 fb                	sub    %edi,%ebx
  8017f5:	89 f9                	mov    %edi,%ecx
  8017f7:	d3 e6                	shl    %cl,%esi
  8017f9:	89 c5                	mov    %eax,%ebp
  8017fb:	88 d9                	mov    %bl,%cl
  8017fd:	d3 ed                	shr    %cl,%ebp
  8017ff:	89 e9                	mov    %ebp,%ecx
  801801:	09 f1                	or     %esi,%ecx
  801803:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801807:	89 f9                	mov    %edi,%ecx
  801809:	d3 e0                	shl    %cl,%eax
  80180b:	89 c5                	mov    %eax,%ebp
  80180d:	89 d6                	mov    %edx,%esi
  80180f:	88 d9                	mov    %bl,%cl
  801811:	d3 ee                	shr    %cl,%esi
  801813:	89 f9                	mov    %edi,%ecx
  801815:	d3 e2                	shl    %cl,%edx
  801817:	8b 44 24 08          	mov    0x8(%esp),%eax
  80181b:	88 d9                	mov    %bl,%cl
  80181d:	d3 e8                	shr    %cl,%eax
  80181f:	09 c2                	or     %eax,%edx
  801821:	89 d0                	mov    %edx,%eax
  801823:	89 f2                	mov    %esi,%edx
  801825:	f7 74 24 0c          	divl   0xc(%esp)
  801829:	89 d6                	mov    %edx,%esi
  80182b:	89 c3                	mov    %eax,%ebx
  80182d:	f7 e5                	mul    %ebp
  80182f:	39 d6                	cmp    %edx,%esi
  801831:	72 19                	jb     80184c <__udivdi3+0xfc>
  801833:	74 0b                	je     801840 <__udivdi3+0xf0>
  801835:	89 d8                	mov    %ebx,%eax
  801837:	31 ff                	xor    %edi,%edi
  801839:	e9 58 ff ff ff       	jmp    801796 <__udivdi3+0x46>
  80183e:	66 90                	xchg   %ax,%ax
  801840:	8b 54 24 08          	mov    0x8(%esp),%edx
  801844:	89 f9                	mov    %edi,%ecx
  801846:	d3 e2                	shl    %cl,%edx
  801848:	39 c2                	cmp    %eax,%edx
  80184a:	73 e9                	jae    801835 <__udivdi3+0xe5>
  80184c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80184f:	31 ff                	xor    %edi,%edi
  801851:	e9 40 ff ff ff       	jmp    801796 <__udivdi3+0x46>
  801856:	66 90                	xchg   %ax,%ax
  801858:	31 c0                	xor    %eax,%eax
  80185a:	e9 37 ff ff ff       	jmp    801796 <__udivdi3+0x46>
  80185f:	90                   	nop

00801860 <__umoddi3>:
  801860:	55                   	push   %ebp
  801861:	57                   	push   %edi
  801862:	56                   	push   %esi
  801863:	53                   	push   %ebx
  801864:	83 ec 1c             	sub    $0x1c,%esp
  801867:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80186b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80186f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801873:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801877:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80187b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80187f:	89 f3                	mov    %esi,%ebx
  801881:	89 fa                	mov    %edi,%edx
  801883:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801887:	89 34 24             	mov    %esi,(%esp)
  80188a:	85 c0                	test   %eax,%eax
  80188c:	75 1a                	jne    8018a8 <__umoddi3+0x48>
  80188e:	39 f7                	cmp    %esi,%edi
  801890:	0f 86 a2 00 00 00    	jbe    801938 <__umoddi3+0xd8>
  801896:	89 c8                	mov    %ecx,%eax
  801898:	89 f2                	mov    %esi,%edx
  80189a:	f7 f7                	div    %edi
  80189c:	89 d0                	mov    %edx,%eax
  80189e:	31 d2                	xor    %edx,%edx
  8018a0:	83 c4 1c             	add    $0x1c,%esp
  8018a3:	5b                   	pop    %ebx
  8018a4:	5e                   	pop    %esi
  8018a5:	5f                   	pop    %edi
  8018a6:	5d                   	pop    %ebp
  8018a7:	c3                   	ret    
  8018a8:	39 f0                	cmp    %esi,%eax
  8018aa:	0f 87 ac 00 00 00    	ja     80195c <__umoddi3+0xfc>
  8018b0:	0f bd e8             	bsr    %eax,%ebp
  8018b3:	83 f5 1f             	xor    $0x1f,%ebp
  8018b6:	0f 84 ac 00 00 00    	je     801968 <__umoddi3+0x108>
  8018bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8018c1:	29 ef                	sub    %ebp,%edi
  8018c3:	89 fe                	mov    %edi,%esi
  8018c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018c9:	89 e9                	mov    %ebp,%ecx
  8018cb:	d3 e0                	shl    %cl,%eax
  8018cd:	89 d7                	mov    %edx,%edi
  8018cf:	89 f1                	mov    %esi,%ecx
  8018d1:	d3 ef                	shr    %cl,%edi
  8018d3:	09 c7                	or     %eax,%edi
  8018d5:	89 e9                	mov    %ebp,%ecx
  8018d7:	d3 e2                	shl    %cl,%edx
  8018d9:	89 14 24             	mov    %edx,(%esp)
  8018dc:	89 d8                	mov    %ebx,%eax
  8018de:	d3 e0                	shl    %cl,%eax
  8018e0:	89 c2                	mov    %eax,%edx
  8018e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018e6:	d3 e0                	shl    %cl,%eax
  8018e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018f0:	89 f1                	mov    %esi,%ecx
  8018f2:	d3 e8                	shr    %cl,%eax
  8018f4:	09 d0                	or     %edx,%eax
  8018f6:	d3 eb                	shr    %cl,%ebx
  8018f8:	89 da                	mov    %ebx,%edx
  8018fa:	f7 f7                	div    %edi
  8018fc:	89 d3                	mov    %edx,%ebx
  8018fe:	f7 24 24             	mull   (%esp)
  801901:	89 c6                	mov    %eax,%esi
  801903:	89 d1                	mov    %edx,%ecx
  801905:	39 d3                	cmp    %edx,%ebx
  801907:	0f 82 87 00 00 00    	jb     801994 <__umoddi3+0x134>
  80190d:	0f 84 91 00 00 00    	je     8019a4 <__umoddi3+0x144>
  801913:	8b 54 24 04          	mov    0x4(%esp),%edx
  801917:	29 f2                	sub    %esi,%edx
  801919:	19 cb                	sbb    %ecx,%ebx
  80191b:	89 d8                	mov    %ebx,%eax
  80191d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801921:	d3 e0                	shl    %cl,%eax
  801923:	89 e9                	mov    %ebp,%ecx
  801925:	d3 ea                	shr    %cl,%edx
  801927:	09 d0                	or     %edx,%eax
  801929:	89 e9                	mov    %ebp,%ecx
  80192b:	d3 eb                	shr    %cl,%ebx
  80192d:	89 da                	mov    %ebx,%edx
  80192f:	83 c4 1c             	add    $0x1c,%esp
  801932:	5b                   	pop    %ebx
  801933:	5e                   	pop    %esi
  801934:	5f                   	pop    %edi
  801935:	5d                   	pop    %ebp
  801936:	c3                   	ret    
  801937:	90                   	nop
  801938:	89 fd                	mov    %edi,%ebp
  80193a:	85 ff                	test   %edi,%edi
  80193c:	75 0b                	jne    801949 <__umoddi3+0xe9>
  80193e:	b8 01 00 00 00       	mov    $0x1,%eax
  801943:	31 d2                	xor    %edx,%edx
  801945:	f7 f7                	div    %edi
  801947:	89 c5                	mov    %eax,%ebp
  801949:	89 f0                	mov    %esi,%eax
  80194b:	31 d2                	xor    %edx,%edx
  80194d:	f7 f5                	div    %ebp
  80194f:	89 c8                	mov    %ecx,%eax
  801951:	f7 f5                	div    %ebp
  801953:	89 d0                	mov    %edx,%eax
  801955:	e9 44 ff ff ff       	jmp    80189e <__umoddi3+0x3e>
  80195a:	66 90                	xchg   %ax,%ax
  80195c:	89 c8                	mov    %ecx,%eax
  80195e:	89 f2                	mov    %esi,%edx
  801960:	83 c4 1c             	add    $0x1c,%esp
  801963:	5b                   	pop    %ebx
  801964:	5e                   	pop    %esi
  801965:	5f                   	pop    %edi
  801966:	5d                   	pop    %ebp
  801967:	c3                   	ret    
  801968:	3b 04 24             	cmp    (%esp),%eax
  80196b:	72 06                	jb     801973 <__umoddi3+0x113>
  80196d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801971:	77 0f                	ja     801982 <__umoddi3+0x122>
  801973:	89 f2                	mov    %esi,%edx
  801975:	29 f9                	sub    %edi,%ecx
  801977:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80197b:	89 14 24             	mov    %edx,(%esp)
  80197e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801982:	8b 44 24 04          	mov    0x4(%esp),%eax
  801986:	8b 14 24             	mov    (%esp),%edx
  801989:	83 c4 1c             	add    $0x1c,%esp
  80198c:	5b                   	pop    %ebx
  80198d:	5e                   	pop    %esi
  80198e:	5f                   	pop    %edi
  80198f:	5d                   	pop    %ebp
  801990:	c3                   	ret    
  801991:	8d 76 00             	lea    0x0(%esi),%esi
  801994:	2b 04 24             	sub    (%esp),%eax
  801997:	19 fa                	sbb    %edi,%edx
  801999:	89 d1                	mov    %edx,%ecx
  80199b:	89 c6                	mov    %eax,%esi
  80199d:	e9 71 ff ff ff       	jmp    801913 <__umoddi3+0xb3>
  8019a2:	66 90                	xchg   %ax,%ax
  8019a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8019a8:	72 ea                	jb     801994 <__umoddi3+0x134>
  8019aa:	89 d9                	mov    %ebx,%ecx
  8019ac:	e9 62 ff ff ff       	jmp    801913 <__umoddi3+0xb3>
