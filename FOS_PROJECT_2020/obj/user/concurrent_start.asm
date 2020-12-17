
obj/user/concurrent_start:     file format elf32-i386


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
  800031:	e8 b5 00 00 00       	call   8000eb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	char *str ;
	sys_createSharedObject("cnc1", 512, 1, (void*) &str);
  80003e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800041:	50                   	push   %eax
  800042:	6a 01                	push   $0x1
  800044:	68 00 02 00 00       	push   $0x200
  800049:	68 60 19 80 00       	push   $0x801960
  80004e:	e8 60 13 00 00       	call   8013b3 <sys_createSharedObject>
  800053:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore("cnc1", 1);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	6a 01                	push   $0x1
  80005b:	68 60 19 80 00       	push   $0x801960
  800060:	e8 d9 12 00 00       	call   80133e <sys_createSemaphore>
  800065:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 65 19 80 00       	push   $0x801965
  800072:	e8 c7 12 00 00       	call   80133e <sys_createSemaphore>
  800077:	83 c4 10             	add    $0x10,%esp

	uint32 id1, id2;
	id2 = sys_create_env("qs2", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  80007a:	a1 20 20 80 00       	mov    0x802020,%eax
  80007f:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800085:	a1 20 20 80 00       	mov    0x802020,%eax
  80008a:	8b 40 74             	mov    0x74(%eax),%eax
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	52                   	push   %edx
  800091:	50                   	push   %eax
  800092:	68 6d 19 80 00       	push   $0x80196d
  800097:	e8 b3 13 00 00       	call   80144f <sys_create_env>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	id1 = sys_create_env("qs1", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000a2:	a1 20 20 80 00       	mov    0x802020,%eax
  8000a7:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8000ad:	a1 20 20 80 00       	mov    0x802020,%eax
  8000b2:	8b 40 74             	mov    0x74(%eax),%eax
  8000b5:	83 ec 04             	sub    $0x4,%esp
  8000b8:	52                   	push   %edx
  8000b9:	50                   	push   %eax
  8000ba:	68 71 19 80 00       	push   $0x801971
  8000bf:	e8 8b 13 00 00       	call   80144f <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 f0             	mov    %eax,-0x10(%ebp)

	sys_run_env(id2);
  8000ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	50                   	push   %eax
  8000d1:	e8 96 13 00 00       	call   80146c <sys_run_env>
  8000d6:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id1);
  8000d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	50                   	push   %eax
  8000e0:	e8 87 13 00 00       	call   80146c <sys_run_env>
  8000e5:	83 c4 10             	add    $0x10,%esp

	return;
  8000e8:	90                   	nop
}
  8000e9:	c9                   	leave  
  8000ea:	c3                   	ret    

008000eb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000f1:	e8 39 10 00 00       	call   80112f <sys_getenvindex>
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fc:	89 d0                	mov    %edx,%eax
  8000fe:	c1 e0 03             	shl    $0x3,%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80010a:	01 c8                	add    %ecx,%eax
  80010c:	01 c0                	add    %eax,%eax
  80010e:	01 d0                	add    %edx,%eax
  800110:	01 c0                	add    %eax,%eax
  800112:	01 d0                	add    %edx,%eax
  800114:	89 c2                	mov    %eax,%edx
  800116:	c1 e2 05             	shl    $0x5,%edx
  800119:	29 c2                	sub    %eax,%edx
  80011b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800122:	89 c2                	mov    %eax,%edx
  800124:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80012a:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80012f:	a1 20 20 80 00       	mov    0x802020,%eax
  800134:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80013a:	84 c0                	test   %al,%al
  80013c:	74 0f                	je     80014d <libmain+0x62>
		binaryname = myEnv->prog_name;
  80013e:	a1 20 20 80 00       	mov    0x802020,%eax
  800143:	05 40 3c 01 00       	add    $0x13c40,%eax
  800148:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800151:	7e 0a                	jle    80015d <libmain+0x72>
		binaryname = argv[0];
  800153:	8b 45 0c             	mov    0xc(%ebp),%eax
  800156:	8b 00                	mov    (%eax),%eax
  800158:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  80015d:	83 ec 08             	sub    $0x8,%esp
  800160:	ff 75 0c             	pushl  0xc(%ebp)
  800163:	ff 75 08             	pushl  0x8(%ebp)
  800166:	e8 cd fe ff ff       	call   800038 <_main>
  80016b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80016e:	e8 57 11 00 00       	call   8012ca <sys_disable_interrupt>
	cprintf("**************************************\n");
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	68 90 19 80 00       	push   $0x801990
  80017b:	e8 84 01 00 00       	call   800304 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800183:	a1 20 20 80 00       	mov    0x802020,%eax
  800188:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80018e:	a1 20 20 80 00       	mov    0x802020,%eax
  800193:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	52                   	push   %edx
  80019d:	50                   	push   %eax
  80019e:	68 b8 19 80 00       	push   $0x8019b8
  8001a3:	e8 5c 01 00 00       	call   800304 <cprintf>
  8001a8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8001ab:	a1 20 20 80 00       	mov    0x802020,%eax
  8001b0:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8001b6:	a1 20 20 80 00       	mov    0x802020,%eax
  8001bb:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	52                   	push   %edx
  8001c5:	50                   	push   %eax
  8001c6:	68 e0 19 80 00       	push   $0x8019e0
  8001cb:	e8 34 01 00 00       	call   800304 <cprintf>
  8001d0:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001d3:	a1 20 20 80 00       	mov    0x802020,%eax
  8001d8:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8001de:	83 ec 08             	sub    $0x8,%esp
  8001e1:	50                   	push   %eax
  8001e2:	68 21 1a 80 00       	push   $0x801a21
  8001e7:	e8 18 01 00 00       	call   800304 <cprintf>
  8001ec:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	68 90 19 80 00       	push   $0x801990
  8001f7:	e8 08 01 00 00       	call   800304 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ff:	e8 e0 10 00 00       	call   8012e4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800204:	e8 19 00 00 00       	call   800222 <exit>
}
  800209:	90                   	nop
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	6a 00                	push   $0x0
  800217:	e8 df 0e 00 00       	call   8010fb <sys_env_destroy>
  80021c:	83 c4 10             	add    $0x10,%esp
}
  80021f:	90                   	nop
  800220:	c9                   	leave  
  800221:	c3                   	ret    

00800222 <exit>:

void
exit(void)
{
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800228:	e8 34 0f 00 00       	call   801161 <sys_env_exit>
}
  80022d:	90                   	nop
  80022e:	c9                   	leave  
  80022f:	c3                   	ret    

00800230 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800236:	8b 45 0c             	mov    0xc(%ebp),%eax
  800239:	8b 00                	mov    (%eax),%eax
  80023b:	8d 48 01             	lea    0x1(%eax),%ecx
  80023e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800241:	89 0a                	mov    %ecx,(%edx)
  800243:	8b 55 08             	mov    0x8(%ebp),%edx
  800246:	88 d1                	mov    %dl,%cl
  800248:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800252:	8b 00                	mov    (%eax),%eax
  800254:	3d ff 00 00 00       	cmp    $0xff,%eax
  800259:	75 2c                	jne    800287 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80025b:	a0 24 20 80 00       	mov    0x802024,%al
  800260:	0f b6 c0             	movzbl %al,%eax
  800263:	8b 55 0c             	mov    0xc(%ebp),%edx
  800266:	8b 12                	mov    (%edx),%edx
  800268:	89 d1                	mov    %edx,%ecx
  80026a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80026d:	83 c2 08             	add    $0x8,%edx
  800270:	83 ec 04             	sub    $0x4,%esp
  800273:	50                   	push   %eax
  800274:	51                   	push   %ecx
  800275:	52                   	push   %edx
  800276:	e8 3e 0e 00 00       	call   8010b9 <sys_cputs>
  80027b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80027e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800281:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028a:	8b 40 04             	mov    0x4(%eax),%eax
  80028d:	8d 50 01             	lea    0x1(%eax),%edx
  800290:	8b 45 0c             	mov    0xc(%ebp),%eax
  800293:	89 50 04             	mov    %edx,0x4(%eax)
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002a2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002a9:	00 00 00 
	b.cnt = 0;
  8002ac:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002b3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002b6:	ff 75 0c             	pushl  0xc(%ebp)
  8002b9:	ff 75 08             	pushl  0x8(%ebp)
  8002bc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c2:	50                   	push   %eax
  8002c3:	68 30 02 80 00       	push   $0x800230
  8002c8:	e8 11 02 00 00       	call   8004de <vprintfmt>
  8002cd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002d0:	a0 24 20 80 00       	mov    0x802024,%al
  8002d5:	0f b6 c0             	movzbl %al,%eax
  8002d8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002de:	83 ec 04             	sub    $0x4,%esp
  8002e1:	50                   	push   %eax
  8002e2:	52                   	push   %edx
  8002e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e9:	83 c0 08             	add    $0x8,%eax
  8002ec:	50                   	push   %eax
  8002ed:	e8 c7 0d 00 00       	call   8010b9 <sys_cputs>
  8002f2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002f5:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8002fc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800302:	c9                   	leave  
  800303:	c3                   	ret    

00800304 <cprintf>:

int cprintf(const char *fmt, ...) {
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80030a:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  800311:	8d 45 0c             	lea    0xc(%ebp),%eax
  800314:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800317:	8b 45 08             	mov    0x8(%ebp),%eax
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	ff 75 f4             	pushl  -0xc(%ebp)
  800320:	50                   	push   %eax
  800321:	e8 73 ff ff ff       	call   800299 <vcprintf>
  800326:	83 c4 10             	add    $0x10,%esp
  800329:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80032c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80032f:	c9                   	leave  
  800330:	c3                   	ret    

00800331 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800337:	e8 8e 0f 00 00       	call   8012ca <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80033c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80033f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800342:	8b 45 08             	mov    0x8(%ebp),%eax
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	ff 75 f4             	pushl  -0xc(%ebp)
  80034b:	50                   	push   %eax
  80034c:	e8 48 ff ff ff       	call   800299 <vcprintf>
  800351:	83 c4 10             	add    $0x10,%esp
  800354:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800357:	e8 88 0f 00 00       	call   8012e4 <sys_enable_interrupt>
	return cnt;
  80035c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80035f:	c9                   	leave  
  800360:	c3                   	ret    

00800361 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	53                   	push   %ebx
  800365:	83 ec 14             	sub    $0x14,%esp
  800368:	8b 45 10             	mov    0x10(%ebp),%eax
  80036b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80036e:	8b 45 14             	mov    0x14(%ebp),%eax
  800371:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800374:	8b 45 18             	mov    0x18(%ebp),%eax
  800377:	ba 00 00 00 00       	mov    $0x0,%edx
  80037c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80037f:	77 55                	ja     8003d6 <printnum+0x75>
  800381:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800384:	72 05                	jb     80038b <printnum+0x2a>
  800386:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800389:	77 4b                	ja     8003d6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80038b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80038e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800391:	8b 45 18             	mov    0x18(%ebp),%eax
  800394:	ba 00 00 00 00       	mov    $0x0,%edx
  800399:	52                   	push   %edx
  80039a:	50                   	push   %eax
  80039b:	ff 75 f4             	pushl  -0xc(%ebp)
  80039e:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a1:	e8 46 13 00 00       	call   8016ec <__udivdi3>
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	83 ec 04             	sub    $0x4,%esp
  8003ac:	ff 75 20             	pushl  0x20(%ebp)
  8003af:	53                   	push   %ebx
  8003b0:	ff 75 18             	pushl  0x18(%ebp)
  8003b3:	52                   	push   %edx
  8003b4:	50                   	push   %eax
  8003b5:	ff 75 0c             	pushl  0xc(%ebp)
  8003b8:	ff 75 08             	pushl  0x8(%ebp)
  8003bb:	e8 a1 ff ff ff       	call   800361 <printnum>
  8003c0:	83 c4 20             	add    $0x20,%esp
  8003c3:	eb 1a                	jmp    8003df <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003c5:	83 ec 08             	sub    $0x8,%esp
  8003c8:	ff 75 0c             	pushl  0xc(%ebp)
  8003cb:	ff 75 20             	pushl  0x20(%ebp)
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	ff d0                	call   *%eax
  8003d3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d6:	ff 4d 1c             	decl   0x1c(%ebp)
  8003d9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003dd:	7f e6                	jg     8003c5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003df:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ed:	53                   	push   %ebx
  8003ee:	51                   	push   %ecx
  8003ef:	52                   	push   %edx
  8003f0:	50                   	push   %eax
  8003f1:	e8 06 14 00 00       	call   8017fc <__umoddi3>
  8003f6:	83 c4 10             	add    $0x10,%esp
  8003f9:	05 54 1c 80 00       	add    $0x801c54,%eax
  8003fe:	8a 00                	mov    (%eax),%al
  800400:	0f be c0             	movsbl %al,%eax
  800403:	83 ec 08             	sub    $0x8,%esp
  800406:	ff 75 0c             	pushl  0xc(%ebp)
  800409:	50                   	push   %eax
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
  80040d:	ff d0                	call   *%eax
  80040f:	83 c4 10             	add    $0x10,%esp
}
  800412:	90                   	nop
  800413:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800416:	c9                   	leave  
  800417:	c3                   	ret    

00800418 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80041b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80041f:	7e 1c                	jle    80043d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800421:	8b 45 08             	mov    0x8(%ebp),%eax
  800424:	8b 00                	mov    (%eax),%eax
  800426:	8d 50 08             	lea    0x8(%eax),%edx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	89 10                	mov    %edx,(%eax)
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	8b 00                	mov    (%eax),%eax
  800433:	83 e8 08             	sub    $0x8,%eax
  800436:	8b 50 04             	mov    0x4(%eax),%edx
  800439:	8b 00                	mov    (%eax),%eax
  80043b:	eb 40                	jmp    80047d <getuint+0x65>
	else if (lflag)
  80043d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800441:	74 1e                	je     800461 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	8d 50 04             	lea    0x4(%eax),%edx
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	89 10                	mov    %edx,(%eax)
  800450:	8b 45 08             	mov    0x8(%ebp),%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	83 e8 04             	sub    $0x4,%eax
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	ba 00 00 00 00       	mov    $0x0,%edx
  80045f:	eb 1c                	jmp    80047d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	8d 50 04             	lea    0x4(%eax),%edx
  800469:	8b 45 08             	mov    0x8(%ebp),%eax
  80046c:	89 10                	mov    %edx,(%eax)
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	83 e8 04             	sub    $0x4,%eax
  800476:	8b 00                	mov    (%eax),%eax
  800478:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80047d:	5d                   	pop    %ebp
  80047e:	c3                   	ret    

0080047f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800482:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800486:	7e 1c                	jle    8004a4 <getint+0x25>
		return va_arg(*ap, long long);
  800488:	8b 45 08             	mov    0x8(%ebp),%eax
  80048b:	8b 00                	mov    (%eax),%eax
  80048d:	8d 50 08             	lea    0x8(%eax),%edx
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	89 10                	mov    %edx,(%eax)
  800495:	8b 45 08             	mov    0x8(%ebp),%eax
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	83 e8 08             	sub    $0x8,%eax
  80049d:	8b 50 04             	mov    0x4(%eax),%edx
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	eb 38                	jmp    8004dc <getint+0x5d>
	else if (lflag)
  8004a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004a8:	74 1a                	je     8004c4 <getint+0x45>
		return va_arg(*ap, long);
  8004aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	8d 50 04             	lea    0x4(%eax),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	89 10                	mov    %edx,(%eax)
  8004b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	83 e8 04             	sub    $0x4,%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	99                   	cltd   
  8004c2:	eb 18                	jmp    8004dc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	8d 50 04             	lea    0x4(%eax),%edx
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	89 10                	mov    %edx,(%eax)
  8004d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d4:	8b 00                	mov    (%eax),%eax
  8004d6:	83 e8 04             	sub    $0x4,%eax
  8004d9:	8b 00                	mov    (%eax),%eax
  8004db:	99                   	cltd   
}
  8004dc:	5d                   	pop    %ebp
  8004dd:	c3                   	ret    

008004de <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004de:	55                   	push   %ebp
  8004df:	89 e5                	mov    %esp,%ebp
  8004e1:	56                   	push   %esi
  8004e2:	53                   	push   %ebx
  8004e3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e6:	eb 17                	jmp    8004ff <vprintfmt+0x21>
			if (ch == '\0')
  8004e8:	85 db                	test   %ebx,%ebx
  8004ea:	0f 84 af 03 00 00    	je     80089f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004f0:	83 ec 08             	sub    $0x8,%esp
  8004f3:	ff 75 0c             	pushl  0xc(%ebp)
  8004f6:	53                   	push   %ebx
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	ff d0                	call   *%eax
  8004fc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800502:	8d 50 01             	lea    0x1(%eax),%edx
  800505:	89 55 10             	mov    %edx,0x10(%ebp)
  800508:	8a 00                	mov    (%eax),%al
  80050a:	0f b6 d8             	movzbl %al,%ebx
  80050d:	83 fb 25             	cmp    $0x25,%ebx
  800510:	75 d6                	jne    8004e8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800512:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800516:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80051d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800524:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80052b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800532:	8b 45 10             	mov    0x10(%ebp),%eax
  800535:	8d 50 01             	lea    0x1(%eax),%edx
  800538:	89 55 10             	mov    %edx,0x10(%ebp)
  80053b:	8a 00                	mov    (%eax),%al
  80053d:	0f b6 d8             	movzbl %al,%ebx
  800540:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800543:	83 f8 55             	cmp    $0x55,%eax
  800546:	0f 87 2b 03 00 00    	ja     800877 <vprintfmt+0x399>
  80054c:	8b 04 85 78 1c 80 00 	mov    0x801c78(,%eax,4),%eax
  800553:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800555:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800559:	eb d7                	jmp    800532 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80055b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80055f:	eb d1                	jmp    800532 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800561:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800568:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80056b:	89 d0                	mov    %edx,%eax
  80056d:	c1 e0 02             	shl    $0x2,%eax
  800570:	01 d0                	add    %edx,%eax
  800572:	01 c0                	add    %eax,%eax
  800574:	01 d8                	add    %ebx,%eax
  800576:	83 e8 30             	sub    $0x30,%eax
  800579:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80057c:	8b 45 10             	mov    0x10(%ebp),%eax
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800584:	83 fb 2f             	cmp    $0x2f,%ebx
  800587:	7e 3e                	jle    8005c7 <vprintfmt+0xe9>
  800589:	83 fb 39             	cmp    $0x39,%ebx
  80058c:	7f 39                	jg     8005c7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80058e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800591:	eb d5                	jmp    800568 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	83 c0 04             	add    $0x4,%eax
  800599:	89 45 14             	mov    %eax,0x14(%ebp)
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	83 e8 04             	sub    $0x4,%eax
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005a7:	eb 1f                	jmp    8005c8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ad:	79 83                	jns    800532 <vprintfmt+0x54>
				width = 0;
  8005af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005b6:	e9 77 ff ff ff       	jmp    800532 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005bb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005c2:	e9 6b ff ff ff       	jmp    800532 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005c7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005cc:	0f 89 60 ff ff ff    	jns    800532 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005d8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005df:	e9 4e ff ff ff       	jmp    800532 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005e4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005e7:	e9 46 ff ff ff       	jmp    800532 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	83 c0 04             	add    $0x4,%eax
  8005f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	83 e8 04             	sub    $0x4,%eax
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	ff 75 0c             	pushl  0xc(%ebp)
  800603:	50                   	push   %eax
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	ff d0                	call   *%eax
  800609:	83 c4 10             	add    $0x10,%esp
			break;
  80060c:	e9 89 02 00 00       	jmp    80089a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	83 c0 04             	add    $0x4,%eax
  800617:	89 45 14             	mov    %eax,0x14(%ebp)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	83 e8 04             	sub    $0x4,%eax
  800620:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800622:	85 db                	test   %ebx,%ebx
  800624:	79 02                	jns    800628 <vprintfmt+0x14a>
				err = -err;
  800626:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800628:	83 fb 64             	cmp    $0x64,%ebx
  80062b:	7f 0b                	jg     800638 <vprintfmt+0x15a>
  80062d:	8b 34 9d c0 1a 80 00 	mov    0x801ac0(,%ebx,4),%esi
  800634:	85 f6                	test   %esi,%esi
  800636:	75 19                	jne    800651 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800638:	53                   	push   %ebx
  800639:	68 65 1c 80 00       	push   $0x801c65
  80063e:	ff 75 0c             	pushl  0xc(%ebp)
  800641:	ff 75 08             	pushl  0x8(%ebp)
  800644:	e8 5e 02 00 00       	call   8008a7 <printfmt>
  800649:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80064c:	e9 49 02 00 00       	jmp    80089a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800651:	56                   	push   %esi
  800652:	68 6e 1c 80 00       	push   $0x801c6e
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	ff 75 08             	pushl  0x8(%ebp)
  80065d:	e8 45 02 00 00       	call   8008a7 <printfmt>
  800662:	83 c4 10             	add    $0x10,%esp
			break;
  800665:	e9 30 02 00 00       	jmp    80089a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	83 c0 04             	add    $0x4,%eax
  800670:	89 45 14             	mov    %eax,0x14(%ebp)
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	83 e8 04             	sub    $0x4,%eax
  800679:	8b 30                	mov    (%eax),%esi
  80067b:	85 f6                	test   %esi,%esi
  80067d:	75 05                	jne    800684 <vprintfmt+0x1a6>
				p = "(null)";
  80067f:	be 71 1c 80 00       	mov    $0x801c71,%esi
			if (width > 0 && padc != '-')
  800684:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800688:	7e 6d                	jle    8006f7 <vprintfmt+0x219>
  80068a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80068e:	74 67                	je     8006f7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	50                   	push   %eax
  800697:	56                   	push   %esi
  800698:	e8 0c 03 00 00       	call   8009a9 <strnlen>
  80069d:	83 c4 10             	add    $0x10,%esp
  8006a0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006a3:	eb 16                	jmp    8006bb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006a5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	ff 75 0c             	pushl  0xc(%ebp)
  8006af:	50                   	push   %eax
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	ff d0                	call   *%eax
  8006b5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b8:	ff 4d e4             	decl   -0x1c(%ebp)
  8006bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006bf:	7f e4                	jg     8006a5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c1:	eb 34                	jmp    8006f7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006c7:	74 1c                	je     8006e5 <vprintfmt+0x207>
  8006c9:	83 fb 1f             	cmp    $0x1f,%ebx
  8006cc:	7e 05                	jle    8006d3 <vprintfmt+0x1f5>
  8006ce:	83 fb 7e             	cmp    $0x7e,%ebx
  8006d1:	7e 12                	jle    8006e5 <vprintfmt+0x207>
					putch('?', putdat);
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	ff 75 0c             	pushl  0xc(%ebp)
  8006d9:	6a 3f                	push   $0x3f
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	ff d0                	call   *%eax
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	eb 0f                	jmp    8006f4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	ff 75 0c             	pushl  0xc(%ebp)
  8006eb:	53                   	push   %ebx
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	ff d0                	call   *%eax
  8006f1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f4:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f7:	89 f0                	mov    %esi,%eax
  8006f9:	8d 70 01             	lea    0x1(%eax),%esi
  8006fc:	8a 00                	mov    (%eax),%al
  8006fe:	0f be d8             	movsbl %al,%ebx
  800701:	85 db                	test   %ebx,%ebx
  800703:	74 24                	je     800729 <vprintfmt+0x24b>
  800705:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800709:	78 b8                	js     8006c3 <vprintfmt+0x1e5>
  80070b:	ff 4d e0             	decl   -0x20(%ebp)
  80070e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800712:	79 af                	jns    8006c3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800714:	eb 13                	jmp    800729 <vprintfmt+0x24b>
				putch(' ', putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	6a 20                	push   $0x20
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	ff d0                	call   *%eax
  800723:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800726:	ff 4d e4             	decl   -0x1c(%ebp)
  800729:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072d:	7f e7                	jg     800716 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80072f:	e9 66 01 00 00       	jmp    80089a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800734:	83 ec 08             	sub    $0x8,%esp
  800737:	ff 75 e8             	pushl  -0x18(%ebp)
  80073a:	8d 45 14             	lea    0x14(%ebp),%eax
  80073d:	50                   	push   %eax
  80073e:	e8 3c fd ff ff       	call   80047f <getint>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800749:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80074c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800752:	85 d2                	test   %edx,%edx
  800754:	79 23                	jns    800779 <vprintfmt+0x29b>
				putch('-', putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	6a 2d                	push   $0x2d
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	ff d0                	call   *%eax
  800763:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076c:	f7 d8                	neg    %eax
  80076e:	83 d2 00             	adc    $0x0,%edx
  800771:	f7 da                	neg    %edx
  800773:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800776:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800779:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800780:	e9 bc 00 00 00       	jmp    800841 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 e8             	pushl  -0x18(%ebp)
  80078b:	8d 45 14             	lea    0x14(%ebp),%eax
  80078e:	50                   	push   %eax
  80078f:	e8 84 fc ff ff       	call   800418 <getuint>
  800794:	83 c4 10             	add    $0x10,%esp
  800797:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80079d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007a4:	e9 98 00 00 00       	jmp    800841 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	ff 75 0c             	pushl  0xc(%ebp)
  8007af:	6a 58                	push   $0x58
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	ff d0                	call   *%eax
  8007b6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007b9:	83 ec 08             	sub    $0x8,%esp
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	6a 58                	push   $0x58
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	ff d0                	call   *%eax
  8007c6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 0c             	pushl  0xc(%ebp)
  8007cf:	6a 58                	push   $0x58
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	ff d0                	call   *%eax
  8007d6:	83 c4 10             	add    $0x10,%esp
			break;
  8007d9:	e9 bc 00 00 00       	jmp    80089a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	6a 30                	push   $0x30
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	ff d0                	call   *%eax
  8007eb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	6a 78                	push   $0x78
  8007f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f9:	ff d0                	call   *%eax
  8007fb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	83 c0 04             	add    $0x4,%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	83 e8 04             	sub    $0x4,%eax
  80080d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80080f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800812:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800819:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800820:	eb 1f                	jmp    800841 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 e8             	pushl  -0x18(%ebp)
  800828:	8d 45 14             	lea    0x14(%ebp),%eax
  80082b:	50                   	push   %eax
  80082c:	e8 e7 fb ff ff       	call   800418 <getuint>
  800831:	83 c4 10             	add    $0x10,%esp
  800834:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800837:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80083a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800841:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800845:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800848:	83 ec 04             	sub    $0x4,%esp
  80084b:	52                   	push   %edx
  80084c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80084f:	50                   	push   %eax
  800850:	ff 75 f4             	pushl  -0xc(%ebp)
  800853:	ff 75 f0             	pushl  -0x10(%ebp)
  800856:	ff 75 0c             	pushl  0xc(%ebp)
  800859:	ff 75 08             	pushl  0x8(%ebp)
  80085c:	e8 00 fb ff ff       	call   800361 <printnum>
  800861:	83 c4 20             	add    $0x20,%esp
			break;
  800864:	eb 34                	jmp    80089a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	53                   	push   %ebx
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	ff d0                	call   *%eax
  800872:	83 c4 10             	add    $0x10,%esp
			break;
  800875:	eb 23                	jmp    80089a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	ff 75 0c             	pushl  0xc(%ebp)
  80087d:	6a 25                	push   $0x25
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	ff d0                	call   *%eax
  800884:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800887:	ff 4d 10             	decl   0x10(%ebp)
  80088a:	eb 03                	jmp    80088f <vprintfmt+0x3b1>
  80088c:	ff 4d 10             	decl   0x10(%ebp)
  80088f:	8b 45 10             	mov    0x10(%ebp),%eax
  800892:	48                   	dec    %eax
  800893:	8a 00                	mov    (%eax),%al
  800895:	3c 25                	cmp    $0x25,%al
  800897:	75 f3                	jne    80088c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800899:	90                   	nop
		}
	}
  80089a:	e9 47 fc ff ff       	jmp    8004e6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80089f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008a3:	5b                   	pop    %ebx
  8008a4:	5e                   	pop    %esi
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8008b0:	83 c0 04             	add    $0x4,%eax
  8008b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8008bc:	50                   	push   %eax
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	ff 75 08             	pushl  0x8(%ebp)
  8008c3:	e8 16 fc ff ff       	call   8004de <vprintfmt>
  8008c8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008cb:	90                   	nop
  8008cc:	c9                   	leave  
  8008cd:	c3                   	ret    

008008ce <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d4:	8b 40 08             	mov    0x8(%eax),%eax
  8008d7:	8d 50 01             	lea    0x1(%eax),%edx
  8008da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	8b 10                	mov    (%eax),%edx
  8008e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e8:	8b 40 04             	mov    0x4(%eax),%eax
  8008eb:	39 c2                	cmp    %eax,%edx
  8008ed:	73 12                	jae    800901 <sprintputch+0x33>
		*b->buf++ = ch;
  8008ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8008f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fa:	89 0a                	mov    %ecx,(%edx)
  8008fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ff:	88 10                	mov    %dl,(%eax)
}
  800901:	90                   	nop
  800902:	5d                   	pop    %ebp
  800903:	c3                   	ret    

00800904 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800910:	8b 45 0c             	mov    0xc(%ebp),%eax
  800913:	8d 50 ff             	lea    -0x1(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	01 d0                	add    %edx,%eax
  80091b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80091e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800925:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800929:	74 06                	je     800931 <vsnprintf+0x2d>
  80092b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092f:	7f 07                	jg     800938 <vsnprintf+0x34>
		return -E_INVAL;
  800931:	b8 03 00 00 00       	mov    $0x3,%eax
  800936:	eb 20                	jmp    800958 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800938:	ff 75 14             	pushl  0x14(%ebp)
  80093b:	ff 75 10             	pushl  0x10(%ebp)
  80093e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800941:	50                   	push   %eax
  800942:	68 ce 08 80 00       	push   $0x8008ce
  800947:	e8 92 fb ff ff       	call   8004de <vprintfmt>
  80094c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80094f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800952:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800955:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800958:	c9                   	leave  
  800959:	c3                   	ret    

0080095a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800960:	8d 45 10             	lea    0x10(%ebp),%eax
  800963:	83 c0 04             	add    $0x4,%eax
  800966:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800969:	8b 45 10             	mov    0x10(%ebp),%eax
  80096c:	ff 75 f4             	pushl  -0xc(%ebp)
  80096f:	50                   	push   %eax
  800970:	ff 75 0c             	pushl  0xc(%ebp)
  800973:	ff 75 08             	pushl  0x8(%ebp)
  800976:	e8 89 ff ff ff       	call   800904 <vsnprintf>
  80097b:	83 c4 10             	add    $0x10,%esp
  80097e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800981:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800984:	c9                   	leave  
  800985:	c3                   	ret    

00800986 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80098c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800993:	eb 06                	jmp    80099b <strlen+0x15>
		n++;
  800995:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800998:	ff 45 08             	incl   0x8(%ebp)
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8a 00                	mov    (%eax),%al
  8009a0:	84 c0                	test   %al,%al
  8009a2:	75 f1                	jne    800995 <strlen+0xf>
		n++;
	return n;
  8009a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009a7:	c9                   	leave  
  8009a8:	c3                   	ret    

008009a9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009b6:	eb 09                	jmp    8009c1 <strnlen+0x18>
		n++;
  8009b8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009bb:	ff 45 08             	incl   0x8(%ebp)
  8009be:	ff 4d 0c             	decl   0xc(%ebp)
  8009c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009c5:	74 09                	je     8009d0 <strnlen+0x27>
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	8a 00                	mov    (%eax),%al
  8009cc:	84 c0                	test   %al,%al
  8009ce:	75 e8                	jne    8009b8 <strnlen+0xf>
		n++;
	return n;
  8009d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009d3:	c9                   	leave  
  8009d4:	c3                   	ret    

008009d5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009e1:	90                   	nop
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	8d 50 01             	lea    0x1(%eax),%edx
  8009e8:	89 55 08             	mov    %edx,0x8(%ebp)
  8009eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009f1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009f4:	8a 12                	mov    (%edx),%dl
  8009f6:	88 10                	mov    %dl,(%eax)
  8009f8:	8a 00                	mov    (%eax),%al
  8009fa:	84 c0                	test   %al,%al
  8009fc:	75 e4                	jne    8009e2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a16:	eb 1f                	jmp    800a37 <strncpy+0x34>
		*dst++ = *src;
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8d 50 01             	lea    0x1(%eax),%edx
  800a1e:	89 55 08             	mov    %edx,0x8(%ebp)
  800a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a24:	8a 12                	mov    (%edx),%dl
  800a26:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2b:	8a 00                	mov    (%eax),%al
  800a2d:	84 c0                	test   %al,%al
  800a2f:	74 03                	je     800a34 <strncpy+0x31>
			src++;
  800a31:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a34:	ff 45 fc             	incl   -0x4(%ebp)
  800a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a3a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a3d:	72 d9                	jb     800a18 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    

00800a44 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a54:	74 30                	je     800a86 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a56:	eb 16                	jmp    800a6e <strlcpy+0x2a>
			*dst++ = *src++;
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8d 50 01             	lea    0x1(%eax),%edx
  800a5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a64:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a67:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6a:	8a 12                	mov    (%edx),%dl
  800a6c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a6e:	ff 4d 10             	decl   0x10(%ebp)
  800a71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a75:	74 09                	je     800a80 <strlcpy+0x3c>
  800a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7a:	8a 00                	mov    (%eax),%al
  800a7c:	84 c0                	test   %al,%al
  800a7e:	75 d8                	jne    800a58 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a86:	8b 55 08             	mov    0x8(%ebp),%edx
  800a89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a8c:	29 c2                	sub    %eax,%edx
  800a8e:	89 d0                	mov    %edx,%eax
}
  800a90:	c9                   	leave  
  800a91:	c3                   	ret    

00800a92 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a95:	eb 06                	jmp    800a9d <strcmp+0xb>
		p++, q++;
  800a97:	ff 45 08             	incl   0x8(%ebp)
  800a9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	84 c0                	test   %al,%al
  800aa4:	74 0e                	je     800ab4 <strcmp+0x22>
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8a 10                	mov    (%eax),%dl
  800aab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aae:	8a 00                	mov    (%eax),%al
  800ab0:	38 c2                	cmp    %al,%dl
  800ab2:	74 e3                	je     800a97 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	8a 00                	mov    (%eax),%al
  800ab9:	0f b6 d0             	movzbl %al,%edx
  800abc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abf:	8a 00                	mov    (%eax),%al
  800ac1:	0f b6 c0             	movzbl %al,%eax
  800ac4:	29 c2                	sub    %eax,%edx
  800ac6:	89 d0                	mov    %edx,%eax
}
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800acd:	eb 09                	jmp    800ad8 <strncmp+0xe>
		n--, p++, q++;
  800acf:	ff 4d 10             	decl   0x10(%ebp)
  800ad2:	ff 45 08             	incl   0x8(%ebp)
  800ad5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ad8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800adc:	74 17                	je     800af5 <strncmp+0x2b>
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8a 00                	mov    (%eax),%al
  800ae3:	84 c0                	test   %al,%al
  800ae5:	74 0e                	je     800af5 <strncmp+0x2b>
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	8a 10                	mov    (%eax),%dl
  800aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aef:	8a 00                	mov    (%eax),%al
  800af1:	38 c2                	cmp    %al,%dl
  800af3:	74 da                	je     800acf <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800af5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800af9:	75 07                	jne    800b02 <strncmp+0x38>
		return 0;
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
  800b00:	eb 14                	jmp    800b16 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	8a 00                	mov    (%eax),%al
  800b07:	0f b6 d0             	movzbl %al,%edx
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	8a 00                	mov    (%eax),%al
  800b0f:	0f b6 c0             	movzbl %al,%eax
  800b12:	29 c2                	sub    %eax,%edx
  800b14:	89 d0                	mov    %edx,%eax
}
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	83 ec 04             	sub    $0x4,%esp
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b24:	eb 12                	jmp    800b38 <strchr+0x20>
		if (*s == c)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8a 00                	mov    (%eax),%al
  800b2b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b2e:	75 05                	jne    800b35 <strchr+0x1d>
			return (char *) s;
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	eb 11                	jmp    800b46 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b35:	ff 45 08             	incl   0x8(%ebp)
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8a 00                	mov    (%eax),%al
  800b3d:	84 c0                	test   %al,%al
  800b3f:	75 e5                	jne    800b26 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	83 ec 04             	sub    $0x4,%esp
  800b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b51:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b54:	eb 0d                	jmp    800b63 <strfind+0x1b>
		if (*s == c)
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b5e:	74 0e                	je     800b6e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b60:	ff 45 08             	incl   0x8(%ebp)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	84 c0                	test   %al,%al
  800b6a:	75 ea                	jne    800b56 <strfind+0xe>
  800b6c:	eb 01                	jmp    800b6f <strfind+0x27>
		if (*s == c)
			break;
  800b6e:	90                   	nop
	return (char *) s;
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b80:	8b 45 10             	mov    0x10(%ebp),%eax
  800b83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b86:	eb 0e                	jmp    800b96 <memset+0x22>
		*p++ = c;
  800b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b8b:	8d 50 01             	lea    0x1(%eax),%edx
  800b8e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b94:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b96:	ff 4d f8             	decl   -0x8(%ebp)
  800b99:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b9d:	79 e9                	jns    800b88 <memset+0x14>
		*p++ = c;

	return v;
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bb6:	eb 16                	jmp    800bce <memcpy+0x2a>
		*d++ = *s++;
  800bb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bbb:	8d 50 01             	lea    0x1(%eax),%edx
  800bbe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bc1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bca:	8a 12                	mov    (%edx),%dl
  800bcc:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800bce:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bd4:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd7:	85 c0                	test   %eax,%eax
  800bd9:	75 dd                	jne    800bb8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bf8:	73 50                	jae    800c4a <memmove+0x6a>
  800bfa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800c00:	01 d0                	add    %edx,%eax
  800c02:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c05:	76 43                	jbe    800c4a <memmove+0x6a>
		s += n;
  800c07:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c13:	eb 10                	jmp    800c25 <memmove+0x45>
			*--d = *--s;
  800c15:	ff 4d f8             	decl   -0x8(%ebp)
  800c18:	ff 4d fc             	decl   -0x4(%ebp)
  800c1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c1e:	8a 10                	mov    (%eax),%dl
  800c20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c23:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c25:	8b 45 10             	mov    0x10(%ebp),%eax
  800c28:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c2b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c2e:	85 c0                	test   %eax,%eax
  800c30:	75 e3                	jne    800c15 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c32:	eb 23                	jmp    800c57 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c37:	8d 50 01             	lea    0x1(%eax),%edx
  800c3a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c40:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c43:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c46:	8a 12                	mov    (%edx),%dl
  800c48:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c50:	89 55 10             	mov    %edx,0x10(%ebp)
  800c53:	85 c0                	test   %eax,%eax
  800c55:	75 dd                	jne    800c34 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c6e:	eb 2a                	jmp    800c9a <memcmp+0x3e>
		if (*s1 != *s2)
  800c70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c73:	8a 10                	mov    (%eax),%dl
  800c75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	38 c2                	cmp    %al,%dl
  800c7c:	74 16                	je     800c94 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c81:	8a 00                	mov    (%eax),%al
  800c83:	0f b6 d0             	movzbl %al,%edx
  800c86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c89:	8a 00                	mov    (%eax),%al
  800c8b:	0f b6 c0             	movzbl %al,%eax
  800c8e:	29 c2                	sub    %eax,%edx
  800c90:	89 d0                	mov    %edx,%eax
  800c92:	eb 18                	jmp    800cac <memcmp+0x50>
		s1++, s2++;
  800c94:	ff 45 fc             	incl   -0x4(%ebp)
  800c97:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	75 c9                	jne    800c70 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cac:	c9                   	leave  
  800cad:	c3                   	ret    

00800cae <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cba:	01 d0                	add    %edx,%eax
  800cbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800cbf:	eb 15                	jmp    800cd6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	0f b6 d0             	movzbl %al,%edx
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	0f b6 c0             	movzbl %al,%eax
  800ccf:	39 c2                	cmp    %eax,%edx
  800cd1:	74 0d                	je     800ce0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cd3:	ff 45 08             	incl   0x8(%ebp)
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800cdc:	72 e3                	jb     800cc1 <memfind+0x13>
  800cde:	eb 01                	jmp    800ce1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ce0:	90                   	nop
	return (void *) s;
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ce4:	c9                   	leave  
  800ce5:	c3                   	ret    

00800ce6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cf3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cfa:	eb 03                	jmp    800cff <strtol+0x19>
		s++;
  800cfc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	3c 20                	cmp    $0x20,%al
  800d06:	74 f4                	je     800cfc <strtol+0x16>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	3c 09                	cmp    $0x9,%al
  800d0f:	74 eb                	je     800cfc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	3c 2b                	cmp    $0x2b,%al
  800d18:	75 05                	jne    800d1f <strtol+0x39>
		s++;
  800d1a:	ff 45 08             	incl   0x8(%ebp)
  800d1d:	eb 13                	jmp    800d32 <strtol+0x4c>
	else if (*s == '-')
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	3c 2d                	cmp    $0x2d,%al
  800d26:	75 0a                	jne    800d32 <strtol+0x4c>
		s++, neg = 1;
  800d28:	ff 45 08             	incl   0x8(%ebp)
  800d2b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d36:	74 06                	je     800d3e <strtol+0x58>
  800d38:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d3c:	75 20                	jne    800d5e <strtol+0x78>
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	3c 30                	cmp    $0x30,%al
  800d45:	75 17                	jne    800d5e <strtol+0x78>
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	40                   	inc    %eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	3c 78                	cmp    $0x78,%al
  800d4f:	75 0d                	jne    800d5e <strtol+0x78>
		s += 2, base = 16;
  800d51:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d55:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d5c:	eb 28                	jmp    800d86 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d62:	75 15                	jne    800d79 <strtol+0x93>
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	3c 30                	cmp    $0x30,%al
  800d6b:	75 0c                	jne    800d79 <strtol+0x93>
		s++, base = 8;
  800d6d:	ff 45 08             	incl   0x8(%ebp)
  800d70:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d77:	eb 0d                	jmp    800d86 <strtol+0xa0>
	else if (base == 0)
  800d79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7d:	75 07                	jne    800d86 <strtol+0xa0>
		base = 10;
  800d7f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	3c 2f                	cmp    $0x2f,%al
  800d8d:	7e 19                	jle    800da8 <strtol+0xc2>
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	3c 39                	cmp    $0x39,%al
  800d96:	7f 10                	jg     800da8 <strtol+0xc2>
			dig = *s - '0';
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8a 00                	mov    (%eax),%al
  800d9d:	0f be c0             	movsbl %al,%eax
  800da0:	83 e8 30             	sub    $0x30,%eax
  800da3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800da6:	eb 42                	jmp    800dea <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	3c 60                	cmp    $0x60,%al
  800daf:	7e 19                	jle    800dca <strtol+0xe4>
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	3c 7a                	cmp    $0x7a,%al
  800db8:	7f 10                	jg     800dca <strtol+0xe4>
			dig = *s - 'a' + 10;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	0f be c0             	movsbl %al,%eax
  800dc2:	83 e8 57             	sub    $0x57,%eax
  800dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dc8:	eb 20                	jmp    800dea <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	3c 40                	cmp    $0x40,%al
  800dd1:	7e 39                	jle    800e0c <strtol+0x126>
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	3c 5a                	cmp    $0x5a,%al
  800dda:	7f 30                	jg     800e0c <strtol+0x126>
			dig = *s - 'A' + 10;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f be c0             	movsbl %al,%eax
  800de4:	83 e8 37             	sub    $0x37,%eax
  800de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ded:	3b 45 10             	cmp    0x10(%ebp),%eax
  800df0:	7d 19                	jge    800e0b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800df2:	ff 45 08             	incl   0x8(%ebp)
  800df5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dfc:	89 c2                	mov    %eax,%edx
  800dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e01:	01 d0                	add    %edx,%eax
  800e03:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e06:	e9 7b ff ff ff       	jmp    800d86 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e0b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e10:	74 08                	je     800e1a <strtol+0x134>
		*endptr = (char *) s;
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	8b 55 08             	mov    0x8(%ebp),%edx
  800e18:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e1e:	74 07                	je     800e27 <strtol+0x141>
  800e20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e23:	f7 d8                	neg    %eax
  800e25:	eb 03                	jmp    800e2a <strtol+0x144>
  800e27:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <ltostr>:

void
ltostr(long value, char *str)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e39:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e44:	79 13                	jns    800e59 <ltostr+0x2d>
	{
		neg = 1;
  800e46:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e50:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e53:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e56:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e61:	99                   	cltd   
  800e62:	f7 f9                	idiv   %ecx
  800e64:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6a:	8d 50 01             	lea    0x1(%eax),%edx
  800e6d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e70:	89 c2                	mov    %eax,%edx
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	01 d0                	add    %edx,%eax
  800e77:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e7a:	83 c2 30             	add    $0x30,%edx
  800e7d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e82:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e87:	f7 e9                	imul   %ecx
  800e89:	c1 fa 02             	sar    $0x2,%edx
  800e8c:	89 c8                	mov    %ecx,%eax
  800e8e:	c1 f8 1f             	sar    $0x1f,%eax
  800e91:	29 c2                	sub    %eax,%edx
  800e93:	89 d0                	mov    %edx,%eax
  800e95:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e9b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ea0:	f7 e9                	imul   %ecx
  800ea2:	c1 fa 02             	sar    $0x2,%edx
  800ea5:	89 c8                	mov    %ecx,%eax
  800ea7:	c1 f8 1f             	sar    $0x1f,%eax
  800eaa:	29 c2                	sub    %eax,%edx
  800eac:	89 d0                	mov    %edx,%eax
  800eae:	c1 e0 02             	shl    $0x2,%eax
  800eb1:	01 d0                	add    %edx,%eax
  800eb3:	01 c0                	add    %eax,%eax
  800eb5:	29 c1                	sub    %eax,%ecx
  800eb7:	89 ca                	mov    %ecx,%edx
  800eb9:	85 d2                	test   %edx,%edx
  800ebb:	75 9c                	jne    800e59 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800ebd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800ec4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec7:	48                   	dec    %eax
  800ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800ecb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ecf:	74 3d                	je     800f0e <ltostr+0xe2>
		start = 1 ;
  800ed1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800ed8:	eb 34                	jmp    800f0e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800eda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	8a 00                	mov    (%eax),%al
  800ee4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	01 c2                	add    %eax,%edx
  800eef:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	01 c8                	add    %ecx,%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800efb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f01:	01 c2                	add    %eax,%edx
  800f03:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f06:	88 02                	mov    %al,(%edx)
		start++ ;
  800f08:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f0b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f11:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f14:	7c c4                	jl     800eda <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f16:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	01 d0                	add    %edx,%eax
  800f1e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f21:	90                   	nop
  800f22:	c9                   	leave  
  800f23:	c3                   	ret    

00800f24 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f2a:	ff 75 08             	pushl  0x8(%ebp)
  800f2d:	e8 54 fa ff ff       	call   800986 <strlen>
  800f32:	83 c4 04             	add    $0x4,%esp
  800f35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f38:	ff 75 0c             	pushl  0xc(%ebp)
  800f3b:	e8 46 fa ff ff       	call   800986 <strlen>
  800f40:	83 c4 04             	add    $0x4,%esp
  800f43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f54:	eb 17                	jmp    800f6d <strcconcat+0x49>
		final[s] = str1[s] ;
  800f56:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f59:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5c:	01 c2                	add    %eax,%edx
  800f5e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	01 c8                	add    %ecx,%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f6a:	ff 45 fc             	incl   -0x4(%ebp)
  800f6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f70:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f73:	7c e1                	jl     800f56 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f75:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f7c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f83:	eb 1f                	jmp    800fa4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f88:	8d 50 01             	lea    0x1(%eax),%edx
  800f8b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f8e:	89 c2                	mov    %eax,%edx
  800f90:	8b 45 10             	mov    0x10(%ebp),%eax
  800f93:	01 c2                	add    %eax,%edx
  800f95:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9b:	01 c8                	add    %ecx,%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fa1:	ff 45 f8             	incl   -0x8(%ebp)
  800fa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800faa:	7c d9                	jl     800f85 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800fac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800faf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb2:	01 d0                	add    %edx,%eax
  800fb4:	c6 00 00             	movb   $0x0,(%eax)
}
  800fb7:	90                   	nop
  800fb8:	c9                   	leave  
  800fb9:	c3                   	ret    

00800fba <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800fbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800fc6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc9:	8b 00                	mov    (%eax),%eax
  800fcb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd5:	01 d0                	add    %edx,%eax
  800fd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fdd:	eb 0c                	jmp    800feb <strsplit+0x31>
			*string++ = 0;
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8d 50 01             	lea    0x1(%eax),%edx
  800fe5:	89 55 08             	mov    %edx,0x8(%ebp)
  800fe8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	84 c0                	test   %al,%al
  800ff2:	74 18                	je     80100c <strsplit+0x52>
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	0f be c0             	movsbl %al,%eax
  800ffc:	50                   	push   %eax
  800ffd:	ff 75 0c             	pushl  0xc(%ebp)
  801000:	e8 13 fb ff ff       	call   800b18 <strchr>
  801005:	83 c4 08             	add    $0x8,%esp
  801008:	85 c0                	test   %eax,%eax
  80100a:	75 d3                	jne    800fdf <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	84 c0                	test   %al,%al
  801013:	74 5a                	je     80106f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801015:	8b 45 14             	mov    0x14(%ebp),%eax
  801018:	8b 00                	mov    (%eax),%eax
  80101a:	83 f8 0f             	cmp    $0xf,%eax
  80101d:	75 07                	jne    801026 <strsplit+0x6c>
		{
			return 0;
  80101f:	b8 00 00 00 00       	mov    $0x0,%eax
  801024:	eb 66                	jmp    80108c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801026:	8b 45 14             	mov    0x14(%ebp),%eax
  801029:	8b 00                	mov    (%eax),%eax
  80102b:	8d 48 01             	lea    0x1(%eax),%ecx
  80102e:	8b 55 14             	mov    0x14(%ebp),%edx
  801031:	89 0a                	mov    %ecx,(%edx)
  801033:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103a:	8b 45 10             	mov    0x10(%ebp),%eax
  80103d:	01 c2                	add    %eax,%edx
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801044:	eb 03                	jmp    801049 <strsplit+0x8f>
			string++;
  801046:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	84 c0                	test   %al,%al
  801050:	74 8b                	je     800fdd <strsplit+0x23>
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	8a 00                	mov    (%eax),%al
  801057:	0f be c0             	movsbl %al,%eax
  80105a:	50                   	push   %eax
  80105b:	ff 75 0c             	pushl  0xc(%ebp)
  80105e:	e8 b5 fa ff ff       	call   800b18 <strchr>
  801063:	83 c4 08             	add    $0x8,%esp
  801066:	85 c0                	test   %eax,%eax
  801068:	74 dc                	je     801046 <strsplit+0x8c>
			string++;
	}
  80106a:	e9 6e ff ff ff       	jmp    800fdd <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80106f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801070:	8b 45 14             	mov    0x14(%ebp),%eax
  801073:	8b 00                	mov    (%eax),%eax
  801075:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80107c:	8b 45 10             	mov    0x10(%ebp),%eax
  80107f:	01 d0                	add    %edx,%eax
  801081:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801087:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	57                   	push   %edi
  801092:	56                   	push   %esi
  801093:	53                   	push   %ebx
  801094:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010a3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010a6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010a9:	cd 30                	int    $0x30
  8010ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8010ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010b1:	83 c4 10             	add    $0x10,%esp
  8010b4:	5b                   	pop    %ebx
  8010b5:	5e                   	pop    %esi
  8010b6:	5f                   	pop    %edi
  8010b7:	5d                   	pop    %ebp
  8010b8:	c3                   	ret    

008010b9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	83 ec 04             	sub    $0x4,%esp
  8010bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010c5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	6a 00                	push   $0x0
  8010ce:	6a 00                	push   $0x0
  8010d0:	52                   	push   %edx
  8010d1:	ff 75 0c             	pushl  0xc(%ebp)
  8010d4:	50                   	push   %eax
  8010d5:	6a 00                	push   $0x0
  8010d7:	e8 b2 ff ff ff       	call   80108e <syscall>
  8010dc:	83 c4 18             	add    $0x18,%esp
}
  8010df:	90                   	nop
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010e5:	6a 00                	push   $0x0
  8010e7:	6a 00                	push   $0x0
  8010e9:	6a 00                	push   $0x0
  8010eb:	6a 00                	push   $0x0
  8010ed:	6a 00                	push   $0x0
  8010ef:	6a 01                	push   $0x1
  8010f1:	e8 98 ff ff ff       	call   80108e <syscall>
  8010f6:	83 c4 18             	add    $0x18,%esp
}
  8010f9:	c9                   	leave  
  8010fa:	c3                   	ret    

008010fb <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	6a 00                	push   $0x0
  801103:	6a 00                	push   $0x0
  801105:	6a 00                	push   $0x0
  801107:	6a 00                	push   $0x0
  801109:	50                   	push   %eax
  80110a:	6a 05                	push   $0x5
  80110c:	e8 7d ff ff ff       	call   80108e <syscall>
  801111:	83 c4 18             	add    $0x18,%esp
}
  801114:	c9                   	leave  
  801115:	c3                   	ret    

00801116 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801119:	6a 00                	push   $0x0
  80111b:	6a 00                	push   $0x0
  80111d:	6a 00                	push   $0x0
  80111f:	6a 00                	push   $0x0
  801121:	6a 00                	push   $0x0
  801123:	6a 02                	push   $0x2
  801125:	e8 64 ff ff ff       	call   80108e <syscall>
  80112a:	83 c4 18             	add    $0x18,%esp
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801132:	6a 00                	push   $0x0
  801134:	6a 00                	push   $0x0
  801136:	6a 00                	push   $0x0
  801138:	6a 00                	push   $0x0
  80113a:	6a 00                	push   $0x0
  80113c:	6a 03                	push   $0x3
  80113e:	e8 4b ff ff ff       	call   80108e <syscall>
  801143:	83 c4 18             	add    $0x18,%esp
}
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80114b:	6a 00                	push   $0x0
  80114d:	6a 00                	push   $0x0
  80114f:	6a 00                	push   $0x0
  801151:	6a 00                	push   $0x0
  801153:	6a 00                	push   $0x0
  801155:	6a 04                	push   $0x4
  801157:	e8 32 ff ff ff       	call   80108e <syscall>
  80115c:	83 c4 18             	add    $0x18,%esp
}
  80115f:	c9                   	leave  
  801160:	c3                   	ret    

00801161 <sys_env_exit>:


void sys_env_exit(void)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801164:	6a 00                	push   $0x0
  801166:	6a 00                	push   $0x0
  801168:	6a 00                	push   $0x0
  80116a:	6a 00                	push   $0x0
  80116c:	6a 00                	push   $0x0
  80116e:	6a 06                	push   $0x6
  801170:	e8 19 ff ff ff       	call   80108e <syscall>
  801175:	83 c4 18             	add    $0x18,%esp
}
  801178:	90                   	nop
  801179:	c9                   	leave  
  80117a:	c3                   	ret    

0080117b <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80117e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	6a 00                	push   $0x0
  801186:	6a 00                	push   $0x0
  801188:	6a 00                	push   $0x0
  80118a:	52                   	push   %edx
  80118b:	50                   	push   %eax
  80118c:	6a 07                	push   $0x7
  80118e:	e8 fb fe ff ff       	call   80108e <syscall>
  801193:	83 c4 18             	add    $0x18,%esp
}
  801196:	c9                   	leave  
  801197:	c3                   	ret    

00801198 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	56                   	push   %esi
  80119c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80119d:	8b 75 18             	mov    0x18(%ebp),%esi
  8011a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	56                   	push   %esi
  8011ad:	53                   	push   %ebx
  8011ae:	51                   	push   %ecx
  8011af:	52                   	push   %edx
  8011b0:	50                   	push   %eax
  8011b1:	6a 08                	push   $0x8
  8011b3:	e8 d6 fe ff ff       	call   80108e <syscall>
  8011b8:	83 c4 18             	add    $0x18,%esp
}
  8011bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011be:	5b                   	pop    %ebx
  8011bf:	5e                   	pop    %esi
  8011c0:	5d                   	pop    %ebp
  8011c1:	c3                   	ret    

008011c2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8011c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	6a 00                	push   $0x0
  8011cd:	6a 00                	push   $0x0
  8011cf:	6a 00                	push   $0x0
  8011d1:	52                   	push   %edx
  8011d2:	50                   	push   %eax
  8011d3:	6a 09                	push   $0x9
  8011d5:	e8 b4 fe ff ff       	call   80108e <syscall>
  8011da:	83 c4 18             	add    $0x18,%esp
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8011e2:	6a 00                	push   $0x0
  8011e4:	6a 00                	push   $0x0
  8011e6:	6a 00                	push   $0x0
  8011e8:	ff 75 0c             	pushl  0xc(%ebp)
  8011eb:	ff 75 08             	pushl  0x8(%ebp)
  8011ee:	6a 0a                	push   $0xa
  8011f0:	e8 99 fe ff ff       	call   80108e <syscall>
  8011f5:	83 c4 18             	add    $0x18,%esp
}
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8011fd:	6a 00                	push   $0x0
  8011ff:	6a 00                	push   $0x0
  801201:	6a 00                	push   $0x0
  801203:	6a 00                	push   $0x0
  801205:	6a 00                	push   $0x0
  801207:	6a 0b                	push   $0xb
  801209:	e8 80 fe ff ff       	call   80108e <syscall>
  80120e:	83 c4 18             	add    $0x18,%esp
}
  801211:	c9                   	leave  
  801212:	c3                   	ret    

00801213 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801216:	6a 00                	push   $0x0
  801218:	6a 00                	push   $0x0
  80121a:	6a 00                	push   $0x0
  80121c:	6a 00                	push   $0x0
  80121e:	6a 00                	push   $0x0
  801220:	6a 0c                	push   $0xc
  801222:	e8 67 fe ff ff       	call   80108e <syscall>
  801227:	83 c4 18             	add    $0x18,%esp
}
  80122a:	c9                   	leave  
  80122b:	c3                   	ret    

0080122c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80122f:	6a 00                	push   $0x0
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	6a 00                	push   $0x0
  801239:	6a 0d                	push   $0xd
  80123b:	e8 4e fe ff ff       	call   80108e <syscall>
  801240:	83 c4 18             	add    $0x18,%esp
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801248:	6a 00                	push   $0x0
  80124a:	6a 00                	push   $0x0
  80124c:	6a 00                	push   $0x0
  80124e:	ff 75 0c             	pushl  0xc(%ebp)
  801251:	ff 75 08             	pushl  0x8(%ebp)
  801254:	6a 11                	push   $0x11
  801256:	e8 33 fe ff ff       	call   80108e <syscall>
  80125b:	83 c4 18             	add    $0x18,%esp
	return;
  80125e:	90                   	nop
}
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 00                	push   $0x0
  80126a:	ff 75 0c             	pushl  0xc(%ebp)
  80126d:	ff 75 08             	pushl  0x8(%ebp)
  801270:	6a 12                	push   $0x12
  801272:	e8 17 fe ff ff       	call   80108e <syscall>
  801277:	83 c4 18             	add    $0x18,%esp
	return ;
  80127a:	90                   	nop
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801280:	6a 00                	push   $0x0
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	6a 00                	push   $0x0
  80128a:	6a 0e                	push   $0xe
  80128c:	e8 fd fd ff ff       	call   80108e <syscall>
  801291:	83 c4 18             	add    $0x18,%esp
}
  801294:	c9                   	leave  
  801295:	c3                   	ret    

00801296 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801299:	6a 00                	push   $0x0
  80129b:	6a 00                	push   $0x0
  80129d:	6a 00                	push   $0x0
  80129f:	6a 00                	push   $0x0
  8012a1:	ff 75 08             	pushl  0x8(%ebp)
  8012a4:	6a 0f                	push   $0xf
  8012a6:	e8 e3 fd ff ff       	call   80108e <syscall>
  8012ab:	83 c4 18             	add    $0x18,%esp
}
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    

008012b0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	6a 10                	push   $0x10
  8012bf:	e8 ca fd ff ff       	call   80108e <syscall>
  8012c4:	83 c4 18             	add    $0x18,%esp
}
  8012c7:	90                   	nop
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8012cd:	6a 00                	push   $0x0
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 00                	push   $0x0
  8012d5:	6a 00                	push   $0x0
  8012d7:	6a 14                	push   $0x14
  8012d9:	e8 b0 fd ff ff       	call   80108e <syscall>
  8012de:	83 c4 18             	add    $0x18,%esp
}
  8012e1:	90                   	nop
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 15                	push   $0x15
  8012f3:	e8 96 fd ff ff       	call   80108e <syscall>
  8012f8:	83 c4 18             	add    $0x18,%esp
}
  8012fb:	90                   	nop
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <sys_cputc>:


void
sys_cputc(const char c)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	83 ec 04             	sub    $0x4,%esp
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80130a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	50                   	push   %eax
  801317:	6a 16                	push   $0x16
  801319:	e8 70 fd ff ff       	call   80108e <syscall>
  80131e:	83 c4 18             	add    $0x18,%esp
}
  801321:	90                   	nop
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 17                	push   $0x17
  801333:	e8 56 fd ff ff       	call   80108e <syscall>
  801338:	83 c4 18             	add    $0x18,%esp
}
  80133b:	90                   	nop
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    

0080133e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	ff 75 0c             	pushl  0xc(%ebp)
  80134d:	50                   	push   %eax
  80134e:	6a 18                	push   $0x18
  801350:	e8 39 fd ff ff       	call   80108e <syscall>
  801355:	83 c4 18             	add    $0x18,%esp
}
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80135d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	6a 00                	push   $0x0
  801369:	52                   	push   %edx
  80136a:	50                   	push   %eax
  80136b:	6a 1b                	push   $0x1b
  80136d:	e8 1c fd ff ff       	call   80108e <syscall>
  801372:	83 c4 18             	add    $0x18,%esp
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80137a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	52                   	push   %edx
  801387:	50                   	push   %eax
  801388:	6a 19                	push   $0x19
  80138a:	e8 ff fc ff ff       	call   80108e <syscall>
  80138f:	83 c4 18             	add    $0x18,%esp
}
  801392:	90                   	nop
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801398:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	52                   	push   %edx
  8013a5:	50                   	push   %eax
  8013a6:	6a 1a                	push   $0x1a
  8013a8:	e8 e1 fc ff ff       	call   80108e <syscall>
  8013ad:	83 c4 18             	add    $0x18,%esp
}
  8013b0:	90                   	nop
  8013b1:	c9                   	leave  
  8013b2:	c3                   	ret    

008013b3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	83 ec 04             	sub    $0x4,%esp
  8013b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013bf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013c2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	6a 00                	push   $0x0
  8013cb:	51                   	push   %ecx
  8013cc:	52                   	push   %edx
  8013cd:	ff 75 0c             	pushl  0xc(%ebp)
  8013d0:	50                   	push   %eax
  8013d1:	6a 1c                	push   $0x1c
  8013d3:	e8 b6 fc ff ff       	call   80108e <syscall>
  8013d8:	83 c4 18             	add    $0x18,%esp
}
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8013e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	52                   	push   %edx
  8013ed:	50                   	push   %eax
  8013ee:	6a 1d                	push   $0x1d
  8013f0:	e8 99 fc ff ff       	call   80108e <syscall>
  8013f5:	83 c4 18             	add    $0x18,%esp
}
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

008013fa <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8013fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801400:	8b 55 0c             	mov    0xc(%ebp),%edx
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	51                   	push   %ecx
  80140b:	52                   	push   %edx
  80140c:	50                   	push   %eax
  80140d:	6a 1e                	push   $0x1e
  80140f:	e8 7a fc ff ff       	call   80108e <syscall>
  801414:	83 c4 18             	add    $0x18,%esp
}
  801417:	c9                   	leave  
  801418:	c3                   	ret    

00801419 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80141c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	52                   	push   %edx
  801429:	50                   	push   %eax
  80142a:	6a 1f                	push   $0x1f
  80142c:	e8 5d fc ff ff       	call   80108e <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 20                	push   $0x20
  801445:	e8 44 fc ff ff       	call   80108e <syscall>
  80144a:	83 c4 18             	add    $0x18,%esp
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	ff 75 10             	pushl  0x10(%ebp)
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	50                   	push   %eax
  801460:	6a 21                	push   $0x21
  801462:	e8 27 fc ff ff       	call   80108e <syscall>
  801467:	83 c4 18             	add    $0x18,%esp
}
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <sys_run_env>:


void
sys_run_env(int32 envId)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	50                   	push   %eax
  80147b:	6a 22                	push   $0x22
  80147d:	e8 0c fc ff ff       	call   80108e <syscall>
  801482:	83 c4 18             	add    $0x18,%esp
}
  801485:	90                   	nop
  801486:	c9                   	leave  
  801487:	c3                   	ret    

00801488 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	50                   	push   %eax
  801497:	6a 23                	push   $0x23
  801499:	e8 f0 fb ff ff       	call   80108e <syscall>
  80149e:	83 c4 18             	add    $0x18,%esp
}
  8014a1:	90                   	nop
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8014aa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8014ad:	8d 50 04             	lea    0x4(%eax),%edx
  8014b0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	52                   	push   %edx
  8014ba:	50                   	push   %eax
  8014bb:	6a 24                	push   $0x24
  8014bd:	e8 cc fb ff ff       	call   80108e <syscall>
  8014c2:	83 c4 18             	add    $0x18,%esp
	return result;
  8014c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ce:	89 01                	mov    %eax,(%ecx)
  8014d0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	c9                   	leave  
  8014d7:	c2 04 00             	ret    $0x4

008014da <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	ff 75 10             	pushl  0x10(%ebp)
  8014e4:	ff 75 0c             	pushl  0xc(%ebp)
  8014e7:	ff 75 08             	pushl  0x8(%ebp)
  8014ea:	6a 13                	push   $0x13
  8014ec:	e8 9d fb ff ff       	call   80108e <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8014f4:	90                   	nop
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 25                	push   $0x25
  801506:	e8 83 fb ff ff       	call   80108e <syscall>
  80150b:	83 c4 18             	add    $0x18,%esp
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	83 ec 04             	sub    $0x4,%esp
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80151c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	50                   	push   %eax
  801529:	6a 26                	push   $0x26
  80152b:	e8 5e fb ff ff       	call   80108e <syscall>
  801530:	83 c4 18             	add    $0x18,%esp
	return ;
  801533:	90                   	nop
}
  801534:	c9                   	leave  
  801535:	c3                   	ret    

00801536 <rsttst>:
void rsttst()
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 28                	push   $0x28
  801545:	e8 44 fb ff ff       	call   80108e <syscall>
  80154a:	83 c4 18             	add    $0x18,%esp
	return ;
  80154d:	90                   	nop
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	83 ec 04             	sub    $0x4,%esp
  801556:	8b 45 14             	mov    0x14(%ebp),%eax
  801559:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80155c:	8b 55 18             	mov    0x18(%ebp),%edx
  80155f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801563:	52                   	push   %edx
  801564:	50                   	push   %eax
  801565:	ff 75 10             	pushl  0x10(%ebp)
  801568:	ff 75 0c             	pushl  0xc(%ebp)
  80156b:	ff 75 08             	pushl  0x8(%ebp)
  80156e:	6a 27                	push   $0x27
  801570:	e8 19 fb ff ff       	call   80108e <syscall>
  801575:	83 c4 18             	add    $0x18,%esp
	return ;
  801578:	90                   	nop
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <chktst>:
void chktst(uint32 n)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	ff 75 08             	pushl  0x8(%ebp)
  801589:	6a 29                	push   $0x29
  80158b:	e8 fe fa ff ff       	call   80108e <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
	return ;
  801593:	90                   	nop
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <inctst>:

void inctst()
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 2a                	push   $0x2a
  8015a5:	e8 e4 fa ff ff       	call   80108e <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ad:	90                   	nop
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <gettst>:
uint32 gettst()
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 2b                	push   $0x2b
  8015bf:	e8 ca fa ff ff       	call   80108e <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 2c                	push   $0x2c
  8015db:	e8 ae fa ff ff       	call   80108e <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
  8015e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8015e6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8015ea:	75 07                	jne    8015f3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8015ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8015f1:	eb 05                	jmp    8015f8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 2c                	push   $0x2c
  80160c:	e8 7d fa ff ff       	call   80108e <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
  801614:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801617:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80161b:	75 07                	jne    801624 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80161d:	b8 01 00 00 00       	mov    $0x1,%eax
  801622:	eb 05                	jmp    801629 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801624:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 2c                	push   $0x2c
  80163d:	e8 4c fa ff ff       	call   80108e <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
  801645:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801648:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80164c:	75 07                	jne    801655 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80164e:	b8 01 00 00 00       	mov    $0x1,%eax
  801653:	eb 05                	jmp    80165a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801655:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 2c                	push   $0x2c
  80166e:	e8 1b fa ff ff       	call   80108e <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
  801676:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801679:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80167d:	75 07                	jne    801686 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80167f:	b8 01 00 00 00       	mov    $0x1,%eax
  801684:	eb 05                	jmp    80168b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801686:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	ff 75 08             	pushl  0x8(%ebp)
  80169b:	6a 2d                	push   $0x2d
  80169d:	e8 ec f9 ff ff       	call   80108e <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a5:	90                   	nop
}
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8016ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	6a 00                	push   $0x0
  8016ba:	53                   	push   %ebx
  8016bb:	51                   	push   %ecx
  8016bc:	52                   	push   %edx
  8016bd:	50                   	push   %eax
  8016be:	6a 2e                	push   $0x2e
  8016c0:	e8 c9 f9 ff ff       	call   80108e <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
}
  8016c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	52                   	push   %edx
  8016dd:	50                   	push   %eax
  8016de:	6a 2f                	push   $0x2f
  8016e0:	e8 a9 f9 ff ff       	call   80108e <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    
  8016ea:	66 90                	xchg   %ax,%ax

008016ec <__udivdi3>:
  8016ec:	55                   	push   %ebp
  8016ed:	57                   	push   %edi
  8016ee:	56                   	push   %esi
  8016ef:	53                   	push   %ebx
  8016f0:	83 ec 1c             	sub    $0x1c,%esp
  8016f3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8016f7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8016fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8016ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801703:	89 ca                	mov    %ecx,%edx
  801705:	89 f8                	mov    %edi,%eax
  801707:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80170b:	85 f6                	test   %esi,%esi
  80170d:	75 2d                	jne    80173c <__udivdi3+0x50>
  80170f:	39 cf                	cmp    %ecx,%edi
  801711:	77 65                	ja     801778 <__udivdi3+0x8c>
  801713:	89 fd                	mov    %edi,%ebp
  801715:	85 ff                	test   %edi,%edi
  801717:	75 0b                	jne    801724 <__udivdi3+0x38>
  801719:	b8 01 00 00 00       	mov    $0x1,%eax
  80171e:	31 d2                	xor    %edx,%edx
  801720:	f7 f7                	div    %edi
  801722:	89 c5                	mov    %eax,%ebp
  801724:	31 d2                	xor    %edx,%edx
  801726:	89 c8                	mov    %ecx,%eax
  801728:	f7 f5                	div    %ebp
  80172a:	89 c1                	mov    %eax,%ecx
  80172c:	89 d8                	mov    %ebx,%eax
  80172e:	f7 f5                	div    %ebp
  801730:	89 cf                	mov    %ecx,%edi
  801732:	89 fa                	mov    %edi,%edx
  801734:	83 c4 1c             	add    $0x1c,%esp
  801737:	5b                   	pop    %ebx
  801738:	5e                   	pop    %esi
  801739:	5f                   	pop    %edi
  80173a:	5d                   	pop    %ebp
  80173b:	c3                   	ret    
  80173c:	39 ce                	cmp    %ecx,%esi
  80173e:	77 28                	ja     801768 <__udivdi3+0x7c>
  801740:	0f bd fe             	bsr    %esi,%edi
  801743:	83 f7 1f             	xor    $0x1f,%edi
  801746:	75 40                	jne    801788 <__udivdi3+0x9c>
  801748:	39 ce                	cmp    %ecx,%esi
  80174a:	72 0a                	jb     801756 <__udivdi3+0x6a>
  80174c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801750:	0f 87 9e 00 00 00    	ja     8017f4 <__udivdi3+0x108>
  801756:	b8 01 00 00 00       	mov    $0x1,%eax
  80175b:	89 fa                	mov    %edi,%edx
  80175d:	83 c4 1c             	add    $0x1c,%esp
  801760:	5b                   	pop    %ebx
  801761:	5e                   	pop    %esi
  801762:	5f                   	pop    %edi
  801763:	5d                   	pop    %ebp
  801764:	c3                   	ret    
  801765:	8d 76 00             	lea    0x0(%esi),%esi
  801768:	31 ff                	xor    %edi,%edi
  80176a:	31 c0                	xor    %eax,%eax
  80176c:	89 fa                	mov    %edi,%edx
  80176e:	83 c4 1c             	add    $0x1c,%esp
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5f                   	pop    %edi
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    
  801776:	66 90                	xchg   %ax,%ax
  801778:	89 d8                	mov    %ebx,%eax
  80177a:	f7 f7                	div    %edi
  80177c:	31 ff                	xor    %edi,%edi
  80177e:	89 fa                	mov    %edi,%edx
  801780:	83 c4 1c             	add    $0x1c,%esp
  801783:	5b                   	pop    %ebx
  801784:	5e                   	pop    %esi
  801785:	5f                   	pop    %edi
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    
  801788:	bd 20 00 00 00       	mov    $0x20,%ebp
  80178d:	89 eb                	mov    %ebp,%ebx
  80178f:	29 fb                	sub    %edi,%ebx
  801791:	89 f9                	mov    %edi,%ecx
  801793:	d3 e6                	shl    %cl,%esi
  801795:	89 c5                	mov    %eax,%ebp
  801797:	88 d9                	mov    %bl,%cl
  801799:	d3 ed                	shr    %cl,%ebp
  80179b:	89 e9                	mov    %ebp,%ecx
  80179d:	09 f1                	or     %esi,%ecx
  80179f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8017a3:	89 f9                	mov    %edi,%ecx
  8017a5:	d3 e0                	shl    %cl,%eax
  8017a7:	89 c5                	mov    %eax,%ebp
  8017a9:	89 d6                	mov    %edx,%esi
  8017ab:	88 d9                	mov    %bl,%cl
  8017ad:	d3 ee                	shr    %cl,%esi
  8017af:	89 f9                	mov    %edi,%ecx
  8017b1:	d3 e2                	shl    %cl,%edx
  8017b3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017b7:	88 d9                	mov    %bl,%cl
  8017b9:	d3 e8                	shr    %cl,%eax
  8017bb:	09 c2                	or     %eax,%edx
  8017bd:	89 d0                	mov    %edx,%eax
  8017bf:	89 f2                	mov    %esi,%edx
  8017c1:	f7 74 24 0c          	divl   0xc(%esp)
  8017c5:	89 d6                	mov    %edx,%esi
  8017c7:	89 c3                	mov    %eax,%ebx
  8017c9:	f7 e5                	mul    %ebp
  8017cb:	39 d6                	cmp    %edx,%esi
  8017cd:	72 19                	jb     8017e8 <__udivdi3+0xfc>
  8017cf:	74 0b                	je     8017dc <__udivdi3+0xf0>
  8017d1:	89 d8                	mov    %ebx,%eax
  8017d3:	31 ff                	xor    %edi,%edi
  8017d5:	e9 58 ff ff ff       	jmp    801732 <__udivdi3+0x46>
  8017da:	66 90                	xchg   %ax,%ax
  8017dc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8017e0:	89 f9                	mov    %edi,%ecx
  8017e2:	d3 e2                	shl    %cl,%edx
  8017e4:	39 c2                	cmp    %eax,%edx
  8017e6:	73 e9                	jae    8017d1 <__udivdi3+0xe5>
  8017e8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8017eb:	31 ff                	xor    %edi,%edi
  8017ed:	e9 40 ff ff ff       	jmp    801732 <__udivdi3+0x46>
  8017f2:	66 90                	xchg   %ax,%ax
  8017f4:	31 c0                	xor    %eax,%eax
  8017f6:	e9 37 ff ff ff       	jmp    801732 <__udivdi3+0x46>
  8017fb:	90                   	nop

008017fc <__umoddi3>:
  8017fc:	55                   	push   %ebp
  8017fd:	57                   	push   %edi
  8017fe:	56                   	push   %esi
  8017ff:	53                   	push   %ebx
  801800:	83 ec 1c             	sub    $0x1c,%esp
  801803:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801807:	8b 74 24 34          	mov    0x34(%esp),%esi
  80180b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80180f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801813:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801817:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80181b:	89 f3                	mov    %esi,%ebx
  80181d:	89 fa                	mov    %edi,%edx
  80181f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801823:	89 34 24             	mov    %esi,(%esp)
  801826:	85 c0                	test   %eax,%eax
  801828:	75 1a                	jne    801844 <__umoddi3+0x48>
  80182a:	39 f7                	cmp    %esi,%edi
  80182c:	0f 86 a2 00 00 00    	jbe    8018d4 <__umoddi3+0xd8>
  801832:	89 c8                	mov    %ecx,%eax
  801834:	89 f2                	mov    %esi,%edx
  801836:	f7 f7                	div    %edi
  801838:	89 d0                	mov    %edx,%eax
  80183a:	31 d2                	xor    %edx,%edx
  80183c:	83 c4 1c             	add    $0x1c,%esp
  80183f:	5b                   	pop    %ebx
  801840:	5e                   	pop    %esi
  801841:	5f                   	pop    %edi
  801842:	5d                   	pop    %ebp
  801843:	c3                   	ret    
  801844:	39 f0                	cmp    %esi,%eax
  801846:	0f 87 ac 00 00 00    	ja     8018f8 <__umoddi3+0xfc>
  80184c:	0f bd e8             	bsr    %eax,%ebp
  80184f:	83 f5 1f             	xor    $0x1f,%ebp
  801852:	0f 84 ac 00 00 00    	je     801904 <__umoddi3+0x108>
  801858:	bf 20 00 00 00       	mov    $0x20,%edi
  80185d:	29 ef                	sub    %ebp,%edi
  80185f:	89 fe                	mov    %edi,%esi
  801861:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801865:	89 e9                	mov    %ebp,%ecx
  801867:	d3 e0                	shl    %cl,%eax
  801869:	89 d7                	mov    %edx,%edi
  80186b:	89 f1                	mov    %esi,%ecx
  80186d:	d3 ef                	shr    %cl,%edi
  80186f:	09 c7                	or     %eax,%edi
  801871:	89 e9                	mov    %ebp,%ecx
  801873:	d3 e2                	shl    %cl,%edx
  801875:	89 14 24             	mov    %edx,(%esp)
  801878:	89 d8                	mov    %ebx,%eax
  80187a:	d3 e0                	shl    %cl,%eax
  80187c:	89 c2                	mov    %eax,%edx
  80187e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801882:	d3 e0                	shl    %cl,%eax
  801884:	89 44 24 04          	mov    %eax,0x4(%esp)
  801888:	8b 44 24 08          	mov    0x8(%esp),%eax
  80188c:	89 f1                	mov    %esi,%ecx
  80188e:	d3 e8                	shr    %cl,%eax
  801890:	09 d0                	or     %edx,%eax
  801892:	d3 eb                	shr    %cl,%ebx
  801894:	89 da                	mov    %ebx,%edx
  801896:	f7 f7                	div    %edi
  801898:	89 d3                	mov    %edx,%ebx
  80189a:	f7 24 24             	mull   (%esp)
  80189d:	89 c6                	mov    %eax,%esi
  80189f:	89 d1                	mov    %edx,%ecx
  8018a1:	39 d3                	cmp    %edx,%ebx
  8018a3:	0f 82 87 00 00 00    	jb     801930 <__umoddi3+0x134>
  8018a9:	0f 84 91 00 00 00    	je     801940 <__umoddi3+0x144>
  8018af:	8b 54 24 04          	mov    0x4(%esp),%edx
  8018b3:	29 f2                	sub    %esi,%edx
  8018b5:	19 cb                	sbb    %ecx,%ebx
  8018b7:	89 d8                	mov    %ebx,%eax
  8018b9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8018bd:	d3 e0                	shl    %cl,%eax
  8018bf:	89 e9                	mov    %ebp,%ecx
  8018c1:	d3 ea                	shr    %cl,%edx
  8018c3:	09 d0                	or     %edx,%eax
  8018c5:	89 e9                	mov    %ebp,%ecx
  8018c7:	d3 eb                	shr    %cl,%ebx
  8018c9:	89 da                	mov    %ebx,%edx
  8018cb:	83 c4 1c             	add    $0x1c,%esp
  8018ce:	5b                   	pop    %ebx
  8018cf:	5e                   	pop    %esi
  8018d0:	5f                   	pop    %edi
  8018d1:	5d                   	pop    %ebp
  8018d2:	c3                   	ret    
  8018d3:	90                   	nop
  8018d4:	89 fd                	mov    %edi,%ebp
  8018d6:	85 ff                	test   %edi,%edi
  8018d8:	75 0b                	jne    8018e5 <__umoddi3+0xe9>
  8018da:	b8 01 00 00 00       	mov    $0x1,%eax
  8018df:	31 d2                	xor    %edx,%edx
  8018e1:	f7 f7                	div    %edi
  8018e3:	89 c5                	mov    %eax,%ebp
  8018e5:	89 f0                	mov    %esi,%eax
  8018e7:	31 d2                	xor    %edx,%edx
  8018e9:	f7 f5                	div    %ebp
  8018eb:	89 c8                	mov    %ecx,%eax
  8018ed:	f7 f5                	div    %ebp
  8018ef:	89 d0                	mov    %edx,%eax
  8018f1:	e9 44 ff ff ff       	jmp    80183a <__umoddi3+0x3e>
  8018f6:	66 90                	xchg   %ax,%ax
  8018f8:	89 c8                	mov    %ecx,%eax
  8018fa:	89 f2                	mov    %esi,%edx
  8018fc:	83 c4 1c             	add    $0x1c,%esp
  8018ff:	5b                   	pop    %ebx
  801900:	5e                   	pop    %esi
  801901:	5f                   	pop    %edi
  801902:	5d                   	pop    %ebp
  801903:	c3                   	ret    
  801904:	3b 04 24             	cmp    (%esp),%eax
  801907:	72 06                	jb     80190f <__umoddi3+0x113>
  801909:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80190d:	77 0f                	ja     80191e <__umoddi3+0x122>
  80190f:	89 f2                	mov    %esi,%edx
  801911:	29 f9                	sub    %edi,%ecx
  801913:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801917:	89 14 24             	mov    %edx,(%esp)
  80191a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80191e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801922:	8b 14 24             	mov    (%esp),%edx
  801925:	83 c4 1c             	add    $0x1c,%esp
  801928:	5b                   	pop    %ebx
  801929:	5e                   	pop    %esi
  80192a:	5f                   	pop    %edi
  80192b:	5d                   	pop    %ebp
  80192c:	c3                   	ret    
  80192d:	8d 76 00             	lea    0x0(%esi),%esi
  801930:	2b 04 24             	sub    (%esp),%eax
  801933:	19 fa                	sbb    %edi,%edx
  801935:	89 d1                	mov    %edx,%ecx
  801937:	89 c6                	mov    %eax,%esi
  801939:	e9 71 ff ff ff       	jmp    8018af <__umoddi3+0xb3>
  80193e:	66 90                	xchg   %ax,%ax
  801940:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801944:	72 ea                	jb     801930 <__umoddi3+0x134>
  801946:	89 d9                	mov    %ebx,%ecx
  801948:	e9 62 ff ff ff       	jmp    8018af <__umoddi3+0xb3>
