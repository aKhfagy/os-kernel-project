
obj/user/tst_CPU_MLFQ_master_1:     file format elf32-i386


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
  800031:	e8 2a 01 00 00       	call   800160 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	// For EXIT
	int ID = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
  80003e:	a1 20 20 80 00       	mov    0x802020,%eax
  800043:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800049:	a1 20 20 80 00       	mov    0x802020,%eax
  80004e:	8b 40 74             	mov    0x74(%eax),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	52                   	push   %edx
  800055:	50                   	push   %eax
  800056:	68 80 1a 80 00       	push   $0x801a80
  80005b:	e8 64 14 00 00       	call   8014c4 <sys_create_env>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID);
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	ff 75 f0             	pushl  -0x10(%ebp)
  80006c:	e8 70 14 00 00       	call   8014e1 <sys_run_env>
  800071:	83 c4 10             	add    $0x10,%esp
	ID = sys_create_env("fos_add", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
  800074:	a1 20 20 80 00       	mov    0x802020,%eax
  800079:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80007f:	a1 20 20 80 00       	mov    0x802020,%eax
  800084:	8b 40 74             	mov    0x74(%eax),%eax
  800087:	83 ec 04             	sub    $0x4,%esp
  80008a:	52                   	push   %edx
  80008b:	50                   	push   %eax
  80008c:	68 8f 1a 80 00       	push   $0x801a8f
  800091:	e8 2e 14 00 00       	call   8014c4 <sys_create_env>
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID);
  80009c:	83 ec 0c             	sub    $0xc,%esp
  80009f:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a2:	e8 3a 14 00 00       	call   8014e1 <sys_run_env>
  8000a7:	83 c4 10             	add    $0x10,%esp
	//============

	for (int i = 0; i < 3; ++i) {
  8000aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000b1:	eb 39                	jmp    8000ec <_main+0xb4>
			ID = sys_create_env("dummy_process", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000b3:	a1 20 20 80 00       	mov    0x802020,%eax
  8000b8:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8000be:	a1 20 20 80 00       	mov    0x802020,%eax
  8000c3:	8b 40 74             	mov    0x74(%eax),%eax
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	52                   	push   %edx
  8000ca:	50                   	push   %eax
  8000cb:	68 97 1a 80 00       	push   $0x801a97
  8000d0:	e8 ef 13 00 00       	call   8014c4 <sys_create_env>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			sys_run_env(ID);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e1:	e8 fb 13 00 00       	call   8014e1 <sys_run_env>
  8000e6:	83 c4 10             	add    $0x10,%esp
	sys_run_env(ID);
	ID = sys_create_env("fos_add", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(ID);
	//============

	for (int i = 0; i < 3; ++i) {
  8000e9:	ff 45 f4             	incl   -0xc(%ebp)
  8000ec:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
  8000f0:	7e c1                	jle    8000b3 <_main+0x7b>
			ID = sys_create_env("dummy_process", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
			sys_run_env(ID);
		}
	env_sleep(10000);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	68 10 27 00 00       	push   $0x2710
  8000fa:	e8 60 16 00 00       	call   80175f <env_sleep>
  8000ff:	83 c4 10             	add    $0x10,%esp

	ID = sys_create_env("cpuMLFQ1Slave_1", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
  800102:	a1 20 20 80 00       	mov    0x802020,%eax
  800107:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80010d:	a1 20 20 80 00       	mov    0x802020,%eax
  800112:	8b 40 74             	mov    0x74(%eax),%eax
  800115:	83 ec 04             	sub    $0x4,%esp
  800118:	52                   	push   %edx
  800119:	50                   	push   %eax
  80011a:	68 a5 1a 80 00       	push   $0x801aa5
  80011f:	e8 a0 13 00 00       	call   8014c4 <sys_create_env>
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID);
  80012a:	83 ec 0c             	sub    $0xc,%esp
  80012d:	ff 75 f0             	pushl  -0x10(%ebp)
  800130:	e8 ac 13 00 00       	call   8014e1 <sys_run_env>
  800135:	83 c4 10             	add    $0x10,%esp

	// To wait till other queues filled with other processes
	env_sleep(10000);
  800138:	83 ec 0c             	sub    $0xc,%esp
  80013b:	68 10 27 00 00       	push   $0x2710
  800140:	e8 1a 16 00 00       	call   80175f <env_sleep>
  800145:	83 c4 10             	add    $0x10,%esp


	// To check that the slave environments completed successfully
	rsttst();
  800148:	e8 5e 14 00 00       	call   8015ab <rsttst>

	env_sleep(200);
  80014d:	83 ec 0c             	sub    $0xc,%esp
  800150:	68 c8 00 00 00       	push   $0xc8
  800155:	e8 05 16 00 00       	call   80175f <env_sleep>
  80015a:	83 c4 10             	add    $0x10,%esp
}
  80015d:	90                   	nop
  80015e:	c9                   	leave  
  80015f:	c3                   	ret    

00800160 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800166:	e8 39 10 00 00       	call   8011a4 <sys_getenvindex>
  80016b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80016e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800171:	89 d0                	mov    %edx,%eax
  800173:	c1 e0 03             	shl    $0x3,%eax
  800176:	01 d0                	add    %edx,%eax
  800178:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80017f:	01 c8                	add    %ecx,%eax
  800181:	01 c0                	add    %eax,%eax
  800183:	01 d0                	add    %edx,%eax
  800185:	01 c0                	add    %eax,%eax
  800187:	01 d0                	add    %edx,%eax
  800189:	89 c2                	mov    %eax,%edx
  80018b:	c1 e2 05             	shl    $0x5,%edx
  80018e:	29 c2                	sub    %eax,%edx
  800190:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800197:	89 c2                	mov    %eax,%edx
  800199:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80019f:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001a4:	a1 20 20 80 00       	mov    0x802020,%eax
  8001a9:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001af:	84 c0                	test   %al,%al
  8001b1:	74 0f                	je     8001c2 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001b3:	a1 20 20 80 00       	mov    0x802020,%eax
  8001b8:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001bd:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c6:	7e 0a                	jle    8001d2 <libmain+0x72>
		binaryname = argv[0];
  8001c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001cb:	8b 00                	mov    (%eax),%eax
  8001cd:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	ff 75 0c             	pushl  0xc(%ebp)
  8001d8:	ff 75 08             	pushl  0x8(%ebp)
  8001db:	e8 58 fe ff ff       	call   800038 <_main>
  8001e0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001e3:	e8 57 11 00 00       	call   80133f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e8:	83 ec 0c             	sub    $0xc,%esp
  8001eb:	68 d0 1a 80 00       	push   $0x801ad0
  8001f0:	e8 84 01 00 00       	call   800379 <cprintf>
  8001f5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f8:	a1 20 20 80 00       	mov    0x802020,%eax
  8001fd:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800203:	a1 20 20 80 00       	mov    0x802020,%eax
  800208:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80020e:	83 ec 04             	sub    $0x4,%esp
  800211:	52                   	push   %edx
  800212:	50                   	push   %eax
  800213:	68 f8 1a 80 00       	push   $0x801af8
  800218:	e8 5c 01 00 00       	call   800379 <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800220:	a1 20 20 80 00       	mov    0x802020,%eax
  800225:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80022b:	a1 20 20 80 00       	mov    0x802020,%eax
  800230:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	52                   	push   %edx
  80023a:	50                   	push   %eax
  80023b:	68 20 1b 80 00       	push   $0x801b20
  800240:	e8 34 01 00 00       	call   800379 <cprintf>
  800245:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800248:	a1 20 20 80 00       	mov    0x802020,%eax
  80024d:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	50                   	push   %eax
  800257:	68 61 1b 80 00       	push   $0x801b61
  80025c:	e8 18 01 00 00       	call   800379 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 d0 1a 80 00       	push   $0x801ad0
  80026c:	e8 08 01 00 00       	call   800379 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800274:	e8 e0 10 00 00       	call   801359 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800279:	e8 19 00 00 00       	call   800297 <exit>
}
  80027e:	90                   	nop
  80027f:	c9                   	leave  
  800280:	c3                   	ret    

00800281 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	6a 00                	push   $0x0
  80028c:	e8 df 0e 00 00       	call   801170 <sys_env_destroy>
  800291:	83 c4 10             	add    $0x10,%esp
}
  800294:	90                   	nop
  800295:	c9                   	leave  
  800296:	c3                   	ret    

00800297 <exit>:

void
exit(void)
{
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80029d:	e8 34 0f 00 00       	call   8011d6 <sys_env_exit>
}
  8002a2:	90                   	nop
  8002a3:	c9                   	leave  
  8002a4:	c3                   	ret    

008002a5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b6:	89 0a                	mov    %ecx,(%edx)
  8002b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bb:	88 d1                	mov    %dl,%cl
  8002bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c7:	8b 00                	mov    (%eax),%eax
  8002c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ce:	75 2c                	jne    8002fc <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d0:	a0 24 20 80 00       	mov    0x802024,%al
  8002d5:	0f b6 c0             	movzbl %al,%eax
  8002d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002db:	8b 12                	mov    (%edx),%edx
  8002dd:	89 d1                	mov    %edx,%ecx
  8002df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e2:	83 c2 08             	add    $0x8,%edx
  8002e5:	83 ec 04             	sub    $0x4,%esp
  8002e8:	50                   	push   %eax
  8002e9:	51                   	push   %ecx
  8002ea:	52                   	push   %edx
  8002eb:	e8 3e 0e 00 00       	call   80112e <sys_cputs>
  8002f0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ff:	8b 40 04             	mov    0x4(%eax),%eax
  800302:	8d 50 01             	lea    0x1(%eax),%edx
  800305:	8b 45 0c             	mov    0xc(%ebp),%eax
  800308:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030b:	90                   	nop
  80030c:	c9                   	leave  
  80030d:	c3                   	ret    

0080030e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800317:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80031e:	00 00 00 
	b.cnt = 0;
  800321:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800328:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032b:	ff 75 0c             	pushl  0xc(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800337:	50                   	push   %eax
  800338:	68 a5 02 80 00       	push   $0x8002a5
  80033d:	e8 11 02 00 00       	call   800553 <vprintfmt>
  800342:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800345:	a0 24 20 80 00       	mov    0x802024,%al
  80034a:	0f b6 c0             	movzbl %al,%eax
  80034d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800353:	83 ec 04             	sub    $0x4,%esp
  800356:	50                   	push   %eax
  800357:	52                   	push   %edx
  800358:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80035e:	83 c0 08             	add    $0x8,%eax
  800361:	50                   	push   %eax
  800362:	e8 c7 0d 00 00       	call   80112e <sys_cputs>
  800367:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036a:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  800371:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800377:	c9                   	leave  
  800378:	c3                   	ret    

00800379 <cprintf>:

int cprintf(const char *fmt, ...) {
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80037f:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  800386:	8d 45 0c             	lea    0xc(%ebp),%eax
  800389:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038c:	8b 45 08             	mov    0x8(%ebp),%eax
  80038f:	83 ec 08             	sub    $0x8,%esp
  800392:	ff 75 f4             	pushl  -0xc(%ebp)
  800395:	50                   	push   %eax
  800396:	e8 73 ff ff ff       	call   80030e <vcprintf>
  80039b:	83 c4 10             	add    $0x10,%esp
  80039e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a4:	c9                   	leave  
  8003a5:	c3                   	ret    

008003a6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
  8003a9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003ac:	e8 8e 0f 00 00       	call   80133f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ba:	83 ec 08             	sub    $0x8,%esp
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	50                   	push   %eax
  8003c1:	e8 48 ff ff ff       	call   80030e <vcprintf>
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003cc:	e8 88 0f 00 00       	call   801359 <sys_enable_interrupt>
	return cnt;
  8003d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d4:	c9                   	leave  
  8003d5:	c3                   	ret    

008003d6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	53                   	push   %ebx
  8003da:	83 ec 14             	sub    $0x14,%esp
  8003dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003e9:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f4:	77 55                	ja     80044b <printnum+0x75>
  8003f6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f9:	72 05                	jb     800400 <printnum+0x2a>
  8003fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003fe:	77 4b                	ja     80044b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800400:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800403:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800406:	8b 45 18             	mov    0x18(%ebp),%eax
  800409:	ba 00 00 00 00       	mov    $0x0,%edx
  80040e:	52                   	push   %edx
  80040f:	50                   	push   %eax
  800410:	ff 75 f4             	pushl  -0xc(%ebp)
  800413:	ff 75 f0             	pushl  -0x10(%ebp)
  800416:	e8 f9 13 00 00       	call   801814 <__udivdi3>
  80041b:	83 c4 10             	add    $0x10,%esp
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	ff 75 20             	pushl  0x20(%ebp)
  800424:	53                   	push   %ebx
  800425:	ff 75 18             	pushl  0x18(%ebp)
  800428:	52                   	push   %edx
  800429:	50                   	push   %eax
  80042a:	ff 75 0c             	pushl  0xc(%ebp)
  80042d:	ff 75 08             	pushl  0x8(%ebp)
  800430:	e8 a1 ff ff ff       	call   8003d6 <printnum>
  800435:	83 c4 20             	add    $0x20,%esp
  800438:	eb 1a                	jmp    800454 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	ff 75 0c             	pushl  0xc(%ebp)
  800440:	ff 75 20             	pushl  0x20(%ebp)
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	ff d0                	call   *%eax
  800448:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044b:	ff 4d 1c             	decl   0x1c(%ebp)
  80044e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800452:	7f e6                	jg     80043a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800454:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800457:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800462:	53                   	push   %ebx
  800463:	51                   	push   %ecx
  800464:	52                   	push   %edx
  800465:	50                   	push   %eax
  800466:	e8 b9 14 00 00       	call   801924 <__umoddi3>
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	05 94 1d 80 00       	add    $0x801d94,%eax
  800473:	8a 00                	mov    (%eax),%al
  800475:	0f be c0             	movsbl %al,%eax
  800478:	83 ec 08             	sub    $0x8,%esp
  80047b:	ff 75 0c             	pushl  0xc(%ebp)
  80047e:	50                   	push   %eax
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	ff d0                	call   *%eax
  800484:	83 c4 10             	add    $0x10,%esp
}
  800487:	90                   	nop
  800488:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048b:	c9                   	leave  
  80048c:	c3                   	ret    

0080048d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048d:	55                   	push   %ebp
  80048e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800490:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800494:	7e 1c                	jle    8004b2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	8b 00                	mov    (%eax),%eax
  80049b:	8d 50 08             	lea    0x8(%eax),%edx
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	89 10                	mov    %edx,(%eax)
  8004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	83 e8 08             	sub    $0x8,%eax
  8004ab:	8b 50 04             	mov    0x4(%eax),%edx
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	eb 40                	jmp    8004f2 <getuint+0x65>
	else if (lflag)
  8004b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b6:	74 1e                	je     8004d6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	8d 50 04             	lea    0x4(%eax),%edx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	89 10                	mov    %edx,(%eax)
  8004c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c8:	8b 00                	mov    (%eax),%eax
  8004ca:	83 e8 04             	sub    $0x4,%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d4:	eb 1c                	jmp    8004f2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	8b 00                	mov    (%eax),%eax
  8004db:	8d 50 04             	lea    0x4(%eax),%edx
  8004de:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e1:	89 10                	mov    %edx,(%eax)
  8004e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e6:	8b 00                	mov    (%eax),%eax
  8004e8:	83 e8 04             	sub    $0x4,%eax
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f2:	5d                   	pop    %ebp
  8004f3:	c3                   	ret    

008004f4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f4:	55                   	push   %ebp
  8004f5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004f7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fb:	7e 1c                	jle    800519 <getint+0x25>
		return va_arg(*ap, long long);
  8004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800500:	8b 00                	mov    (%eax),%eax
  800502:	8d 50 08             	lea    0x8(%eax),%edx
  800505:	8b 45 08             	mov    0x8(%ebp),%eax
  800508:	89 10                	mov    %edx,(%eax)
  80050a:	8b 45 08             	mov    0x8(%ebp),%eax
  80050d:	8b 00                	mov    (%eax),%eax
  80050f:	83 e8 08             	sub    $0x8,%eax
  800512:	8b 50 04             	mov    0x4(%eax),%edx
  800515:	8b 00                	mov    (%eax),%eax
  800517:	eb 38                	jmp    800551 <getint+0x5d>
	else if (lflag)
  800519:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80051d:	74 1a                	je     800539 <getint+0x45>
		return va_arg(*ap, long);
  80051f:	8b 45 08             	mov    0x8(%ebp),%eax
  800522:	8b 00                	mov    (%eax),%eax
  800524:	8d 50 04             	lea    0x4(%eax),%edx
  800527:	8b 45 08             	mov    0x8(%ebp),%eax
  80052a:	89 10                	mov    %edx,(%eax)
  80052c:	8b 45 08             	mov    0x8(%ebp),%eax
  80052f:	8b 00                	mov    (%eax),%eax
  800531:	83 e8 04             	sub    $0x4,%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	99                   	cltd   
  800537:	eb 18                	jmp    800551 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800539:	8b 45 08             	mov    0x8(%ebp),%eax
  80053c:	8b 00                	mov    (%eax),%eax
  80053e:	8d 50 04             	lea    0x4(%eax),%edx
  800541:	8b 45 08             	mov    0x8(%ebp),%eax
  800544:	89 10                	mov    %edx,(%eax)
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  800549:	8b 00                	mov    (%eax),%eax
  80054b:	83 e8 04             	sub    $0x4,%eax
  80054e:	8b 00                	mov    (%eax),%eax
  800550:	99                   	cltd   
}
  800551:	5d                   	pop    %ebp
  800552:	c3                   	ret    

00800553 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800553:	55                   	push   %ebp
  800554:	89 e5                	mov    %esp,%ebp
  800556:	56                   	push   %esi
  800557:	53                   	push   %ebx
  800558:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055b:	eb 17                	jmp    800574 <vprintfmt+0x21>
			if (ch == '\0')
  80055d:	85 db                	test   %ebx,%ebx
  80055f:	0f 84 af 03 00 00    	je     800914 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800565:	83 ec 08             	sub    $0x8,%esp
  800568:	ff 75 0c             	pushl  0xc(%ebp)
  80056b:	53                   	push   %ebx
  80056c:	8b 45 08             	mov    0x8(%ebp),%eax
  80056f:	ff d0                	call   *%eax
  800571:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800574:	8b 45 10             	mov    0x10(%ebp),%eax
  800577:	8d 50 01             	lea    0x1(%eax),%edx
  80057a:	89 55 10             	mov    %edx,0x10(%ebp)
  80057d:	8a 00                	mov    (%eax),%al
  80057f:	0f b6 d8             	movzbl %al,%ebx
  800582:	83 fb 25             	cmp    $0x25,%ebx
  800585:	75 d6                	jne    80055d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800587:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800592:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800599:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005aa:	8d 50 01             	lea    0x1(%eax),%edx
  8005ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b0:	8a 00                	mov    (%eax),%al
  8005b2:	0f b6 d8             	movzbl %al,%ebx
  8005b5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005b8:	83 f8 55             	cmp    $0x55,%eax
  8005bb:	0f 87 2b 03 00 00    	ja     8008ec <vprintfmt+0x399>
  8005c1:	8b 04 85 b8 1d 80 00 	mov    0x801db8(,%eax,4),%eax
  8005c8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005ca:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005ce:	eb d7                	jmp    8005a7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d4:	eb d1                	jmp    8005a7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e0:	89 d0                	mov    %edx,%eax
  8005e2:	c1 e0 02             	shl    $0x2,%eax
  8005e5:	01 d0                	add    %edx,%eax
  8005e7:	01 c0                	add    %eax,%eax
  8005e9:	01 d8                	add    %ebx,%eax
  8005eb:	83 e8 30             	sub    $0x30,%eax
  8005ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f4:	8a 00                	mov    (%eax),%al
  8005f6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005f9:	83 fb 2f             	cmp    $0x2f,%ebx
  8005fc:	7e 3e                	jle    80063c <vprintfmt+0xe9>
  8005fe:	83 fb 39             	cmp    $0x39,%ebx
  800601:	7f 39                	jg     80063c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800603:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800606:	eb d5                	jmp    8005dd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	83 c0 04             	add    $0x4,%eax
  80060e:	89 45 14             	mov    %eax,0x14(%ebp)
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	83 e8 04             	sub    $0x4,%eax
  800617:	8b 00                	mov    (%eax),%eax
  800619:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061c:	eb 1f                	jmp    80063d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80061e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800622:	79 83                	jns    8005a7 <vprintfmt+0x54>
				width = 0;
  800624:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062b:	e9 77 ff ff ff       	jmp    8005a7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800630:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800637:	e9 6b ff ff ff       	jmp    8005a7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80063d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800641:	0f 89 60 ff ff ff    	jns    8005a7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800647:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800654:	e9 4e ff ff ff       	jmp    8005a7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800659:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065c:	e9 46 ff ff ff       	jmp    8005a7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	83 c0 04             	add    $0x4,%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	83 e8 04             	sub    $0x4,%eax
  800670:	8b 00                	mov    (%eax),%eax
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	ff 75 0c             	pushl  0xc(%ebp)
  800678:	50                   	push   %eax
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	ff d0                	call   *%eax
  80067e:	83 c4 10             	add    $0x10,%esp
			break;
  800681:	e9 89 02 00 00       	jmp    80090f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	83 c0 04             	add    $0x4,%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	83 e8 04             	sub    $0x4,%eax
  800695:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800697:	85 db                	test   %ebx,%ebx
  800699:	79 02                	jns    80069d <vprintfmt+0x14a>
				err = -err;
  80069b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80069d:	83 fb 64             	cmp    $0x64,%ebx
  8006a0:	7f 0b                	jg     8006ad <vprintfmt+0x15a>
  8006a2:	8b 34 9d 00 1c 80 00 	mov    0x801c00(,%ebx,4),%esi
  8006a9:	85 f6                	test   %esi,%esi
  8006ab:	75 19                	jne    8006c6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006ad:	53                   	push   %ebx
  8006ae:	68 a5 1d 80 00       	push   $0x801da5
  8006b3:	ff 75 0c             	pushl  0xc(%ebp)
  8006b6:	ff 75 08             	pushl  0x8(%ebp)
  8006b9:	e8 5e 02 00 00       	call   80091c <printfmt>
  8006be:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c1:	e9 49 02 00 00       	jmp    80090f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c6:	56                   	push   %esi
  8006c7:	68 ae 1d 80 00       	push   $0x801dae
  8006cc:	ff 75 0c             	pushl  0xc(%ebp)
  8006cf:	ff 75 08             	pushl  0x8(%ebp)
  8006d2:	e8 45 02 00 00       	call   80091c <printfmt>
  8006d7:	83 c4 10             	add    $0x10,%esp
			break;
  8006da:	e9 30 02 00 00       	jmp    80090f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	83 c0 04             	add    $0x4,%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	83 e8 04             	sub    $0x4,%eax
  8006ee:	8b 30                	mov    (%eax),%esi
  8006f0:	85 f6                	test   %esi,%esi
  8006f2:	75 05                	jne    8006f9 <vprintfmt+0x1a6>
				p = "(null)";
  8006f4:	be b1 1d 80 00       	mov    $0x801db1,%esi
			if (width > 0 && padc != '-')
  8006f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006fd:	7e 6d                	jle    80076c <vprintfmt+0x219>
  8006ff:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800703:	74 67                	je     80076c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800705:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800708:	83 ec 08             	sub    $0x8,%esp
  80070b:	50                   	push   %eax
  80070c:	56                   	push   %esi
  80070d:	e8 0c 03 00 00       	call   800a1e <strnlen>
  800712:	83 c4 10             	add    $0x10,%esp
  800715:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800718:	eb 16                	jmp    800730 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	50                   	push   %eax
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	ff d0                	call   *%eax
  80072a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80072d:	ff 4d e4             	decl   -0x1c(%ebp)
  800730:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800734:	7f e4                	jg     80071a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800736:	eb 34                	jmp    80076c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800738:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073c:	74 1c                	je     80075a <vprintfmt+0x207>
  80073e:	83 fb 1f             	cmp    $0x1f,%ebx
  800741:	7e 05                	jle    800748 <vprintfmt+0x1f5>
  800743:	83 fb 7e             	cmp    $0x7e,%ebx
  800746:	7e 12                	jle    80075a <vprintfmt+0x207>
					putch('?', putdat);
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	ff 75 0c             	pushl  0xc(%ebp)
  80074e:	6a 3f                	push   $0x3f
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	ff d0                	call   *%eax
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	eb 0f                	jmp    800769 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	53                   	push   %ebx
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	ff d0                	call   *%eax
  800766:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800769:	ff 4d e4             	decl   -0x1c(%ebp)
  80076c:	89 f0                	mov    %esi,%eax
  80076e:	8d 70 01             	lea    0x1(%eax),%esi
  800771:	8a 00                	mov    (%eax),%al
  800773:	0f be d8             	movsbl %al,%ebx
  800776:	85 db                	test   %ebx,%ebx
  800778:	74 24                	je     80079e <vprintfmt+0x24b>
  80077a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80077e:	78 b8                	js     800738 <vprintfmt+0x1e5>
  800780:	ff 4d e0             	decl   -0x20(%ebp)
  800783:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800787:	79 af                	jns    800738 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800789:	eb 13                	jmp    80079e <vprintfmt+0x24b>
				putch(' ', putdat);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	ff 75 0c             	pushl  0xc(%ebp)
  800791:	6a 20                	push   $0x20
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	ff d0                	call   *%eax
  800798:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079b:	ff 4d e4             	decl   -0x1c(%ebp)
  80079e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a2:	7f e7                	jg     80078b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a4:	e9 66 01 00 00       	jmp    80090f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8007af:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b2:	50                   	push   %eax
  8007b3:	e8 3c fd ff ff       	call   8004f4 <getint>
  8007b8:	83 c4 10             	add    $0x10,%esp
  8007bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c7:	85 d2                	test   %edx,%edx
  8007c9:	79 23                	jns    8007ee <vprintfmt+0x29b>
				putch('-', putdat);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	6a 2d                	push   $0x2d
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	ff d0                	call   *%eax
  8007d8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e1:	f7 d8                	neg    %eax
  8007e3:	83 d2 00             	adc    $0x0,%edx
  8007e6:	f7 da                	neg    %edx
  8007e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007ee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f5:	e9 bc 00 00 00       	jmp    8008b6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	ff 75 e8             	pushl  -0x18(%ebp)
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
  800803:	50                   	push   %eax
  800804:	e8 84 fc ff ff       	call   80048d <getuint>
  800809:	83 c4 10             	add    $0x10,%esp
  80080c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800812:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800819:	e9 98 00 00 00       	jmp    8008b6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	6a 58                	push   $0x58
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	ff d0                	call   *%eax
  80082b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	ff 75 0c             	pushl  0xc(%ebp)
  800834:	6a 58                	push   $0x58
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	6a 58                	push   $0x58
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	ff d0                	call   *%eax
  80084b:	83 c4 10             	add    $0x10,%esp
			break;
  80084e:	e9 bc 00 00 00       	jmp    80090f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	ff 75 0c             	pushl  0xc(%ebp)
  800859:	6a 30                	push   $0x30
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	ff d0                	call   *%eax
  800860:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	6a 78                	push   $0x78
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	ff d0                	call   *%eax
  800870:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 c0 04             	add    $0x4,%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	83 e8 04             	sub    $0x4,%eax
  800882:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800884:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800887:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80088e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800895:	eb 1f                	jmp    8008b6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	ff 75 e8             	pushl  -0x18(%ebp)
  80089d:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a0:	50                   	push   %eax
  8008a1:	e8 e7 fb ff ff       	call   80048d <getuint>
  8008a6:	83 c4 10             	add    $0x10,%esp
  8008a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008af:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bd:	83 ec 04             	sub    $0x4,%esp
  8008c0:	52                   	push   %edx
  8008c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c4:	50                   	push   %eax
  8008c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	ff 75 08             	pushl  0x8(%ebp)
  8008d1:	e8 00 fb ff ff       	call   8003d6 <printnum>
  8008d6:	83 c4 20             	add    $0x20,%esp
			break;
  8008d9:	eb 34                	jmp    80090f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	53                   	push   %ebx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	ff d0                	call   *%eax
  8008e7:	83 c4 10             	add    $0x10,%esp
			break;
  8008ea:	eb 23                	jmp    80090f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	ff 75 0c             	pushl  0xc(%ebp)
  8008f2:	6a 25                	push   $0x25
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	ff d0                	call   *%eax
  8008f9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008fc:	ff 4d 10             	decl   0x10(%ebp)
  8008ff:	eb 03                	jmp    800904 <vprintfmt+0x3b1>
  800901:	ff 4d 10             	decl   0x10(%ebp)
  800904:	8b 45 10             	mov    0x10(%ebp),%eax
  800907:	48                   	dec    %eax
  800908:	8a 00                	mov    (%eax),%al
  80090a:	3c 25                	cmp    $0x25,%al
  80090c:	75 f3                	jne    800901 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80090e:	90                   	nop
		}
	}
  80090f:	e9 47 fc ff ff       	jmp    80055b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800914:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800915:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800918:	5b                   	pop    %ebx
  800919:	5e                   	pop    %esi
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    

0080091c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800922:	8d 45 10             	lea    0x10(%ebp),%eax
  800925:	83 c0 04             	add    $0x4,%eax
  800928:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092b:	8b 45 10             	mov    0x10(%ebp),%eax
  80092e:	ff 75 f4             	pushl  -0xc(%ebp)
  800931:	50                   	push   %eax
  800932:	ff 75 0c             	pushl  0xc(%ebp)
  800935:	ff 75 08             	pushl  0x8(%ebp)
  800938:	e8 16 fc ff ff       	call   800553 <vprintfmt>
  80093d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800940:	90                   	nop
  800941:	c9                   	leave  
  800942:	c3                   	ret    

00800943 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800946:	8b 45 0c             	mov    0xc(%ebp),%eax
  800949:	8b 40 08             	mov    0x8(%eax),%eax
  80094c:	8d 50 01             	lea    0x1(%eax),%edx
  80094f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800952:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	8b 10                	mov    (%eax),%edx
  80095a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095d:	8b 40 04             	mov    0x4(%eax),%eax
  800960:	39 c2                	cmp    %eax,%edx
  800962:	73 12                	jae    800976 <sprintputch+0x33>
		*b->buf++ = ch;
  800964:	8b 45 0c             	mov    0xc(%ebp),%eax
  800967:	8b 00                	mov    (%eax),%eax
  800969:	8d 48 01             	lea    0x1(%eax),%ecx
  80096c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096f:	89 0a                	mov    %ecx,(%edx)
  800971:	8b 55 08             	mov    0x8(%ebp),%edx
  800974:	88 10                	mov    %dl,(%eax)
}
  800976:	90                   	nop
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800985:	8b 45 0c             	mov    0xc(%ebp),%eax
  800988:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	01 d0                	add    %edx,%eax
  800990:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800993:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80099e:	74 06                	je     8009a6 <vsnprintf+0x2d>
  8009a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a4:	7f 07                	jg     8009ad <vsnprintf+0x34>
		return -E_INVAL;
  8009a6:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ab:	eb 20                	jmp    8009cd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ad:	ff 75 14             	pushl  0x14(%ebp)
  8009b0:	ff 75 10             	pushl  0x10(%ebp)
  8009b3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b6:	50                   	push   %eax
  8009b7:	68 43 09 80 00       	push   $0x800943
  8009bc:	e8 92 fb ff ff       	call   800553 <vprintfmt>
  8009c1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009cd:	c9                   	leave  
  8009ce:	c3                   	ret    

008009cf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8009d8:	83 c0 04             	add    $0x4,%eax
  8009db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009de:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e4:	50                   	push   %eax
  8009e5:	ff 75 0c             	pushl  0xc(%ebp)
  8009e8:	ff 75 08             	pushl  0x8(%ebp)
  8009eb:	e8 89 ff ff ff       	call   800979 <vsnprintf>
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009f9:	c9                   	leave  
  8009fa:	c3                   	ret    

008009fb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a08:	eb 06                	jmp    800a10 <strlen+0x15>
		n++;
  800a0a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0d:	ff 45 08             	incl   0x8(%ebp)
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	8a 00                	mov    (%eax),%al
  800a15:	84 c0                	test   %al,%al
  800a17:	75 f1                	jne    800a0a <strlen+0xf>
		n++;
	return n;
  800a19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1c:	c9                   	leave  
  800a1d:	c3                   	ret    

00800a1e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2b:	eb 09                	jmp    800a36 <strnlen+0x18>
		n++;
  800a2d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a30:	ff 45 08             	incl   0x8(%ebp)
  800a33:	ff 4d 0c             	decl   0xc(%ebp)
  800a36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3a:	74 09                	je     800a45 <strnlen+0x27>
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8a 00                	mov    (%eax),%al
  800a41:	84 c0                	test   %al,%al
  800a43:	75 e8                	jne    800a2d <strnlen+0xf>
		n++;
	return n;
  800a45:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a48:	c9                   	leave  
  800a49:	c3                   	ret    

00800a4a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a56:	90                   	nop
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	8d 50 01             	lea    0x1(%eax),%edx
  800a5d:	89 55 08             	mov    %edx,0x8(%ebp)
  800a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a63:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a66:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a69:	8a 12                	mov    (%edx),%dl
  800a6b:	88 10                	mov    %dl,(%eax)
  800a6d:	8a 00                	mov    (%eax),%al
  800a6f:	84 c0                	test   %al,%al
  800a71:	75 e4                	jne    800a57 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a76:	c9                   	leave  
  800a77:	c3                   	ret    

00800a78 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8b:	eb 1f                	jmp    800aac <strncpy+0x34>
		*dst++ = *src;
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	8d 50 01             	lea    0x1(%eax),%edx
  800a93:	89 55 08             	mov    %edx,0x8(%ebp)
  800a96:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a99:	8a 12                	mov    (%edx),%dl
  800a9b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	84 c0                	test   %al,%al
  800aa4:	74 03                	je     800aa9 <strncpy+0x31>
			src++;
  800aa6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aa9:	ff 45 fc             	incl   -0x4(%ebp)
  800aac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aaf:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab2:	72 d9                	jb     800a8d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ab7:	c9                   	leave  
  800ab8:	c3                   	ret    

00800ab9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac9:	74 30                	je     800afb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800acb:	eb 16                	jmp    800ae3 <strlcpy+0x2a>
			*dst++ = *src++;
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	8d 50 01             	lea    0x1(%eax),%edx
  800ad3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800adc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800adf:	8a 12                	mov    (%edx),%dl
  800ae1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae3:	ff 4d 10             	decl   0x10(%ebp)
  800ae6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aea:	74 09                	je     800af5 <strlcpy+0x3c>
  800aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aef:	8a 00                	mov    (%eax),%al
  800af1:	84 c0                	test   %al,%al
  800af3:	75 d8                	jne    800acd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afb:	8b 55 08             	mov    0x8(%ebp),%edx
  800afe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b01:	29 c2                	sub    %eax,%edx
  800b03:	89 d0                	mov    %edx,%eax
}
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0a:	eb 06                	jmp    800b12 <strcmp+0xb>
		p++, q++;
  800b0c:	ff 45 08             	incl   0x8(%ebp)
  800b0f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	8a 00                	mov    (%eax),%al
  800b17:	84 c0                	test   %al,%al
  800b19:	74 0e                	je     800b29 <strcmp+0x22>
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8a 10                	mov    (%eax),%dl
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	8a 00                	mov    (%eax),%al
  800b25:	38 c2                	cmp    %al,%dl
  800b27:	74 e3                	je     800b0c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8a 00                	mov    (%eax),%al
  800b2e:	0f b6 d0             	movzbl %al,%edx
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8a 00                	mov    (%eax),%al
  800b36:	0f b6 c0             	movzbl %al,%eax
  800b39:	29 c2                	sub    %eax,%edx
  800b3b:	89 d0                	mov    %edx,%eax
}
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b42:	eb 09                	jmp    800b4d <strncmp+0xe>
		n--, p++, q++;
  800b44:	ff 4d 10             	decl   0x10(%ebp)
  800b47:	ff 45 08             	incl   0x8(%ebp)
  800b4a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b51:	74 17                	je     800b6a <strncmp+0x2b>
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8a 00                	mov    (%eax),%al
  800b58:	84 c0                	test   %al,%al
  800b5a:	74 0e                	je     800b6a <strncmp+0x2b>
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	8a 10                	mov    (%eax),%dl
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8a 00                	mov    (%eax),%al
  800b66:	38 c2                	cmp    %al,%dl
  800b68:	74 da                	je     800b44 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b6e:	75 07                	jne    800b77 <strncmp+0x38>
		return 0;
  800b70:	b8 00 00 00 00       	mov    $0x0,%eax
  800b75:	eb 14                	jmp    800b8b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8a 00                	mov    (%eax),%al
  800b7c:	0f b6 d0             	movzbl %al,%edx
  800b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	0f b6 c0             	movzbl %al,%eax
  800b87:	29 c2                	sub    %eax,%edx
  800b89:	89 d0                	mov    %edx,%eax
}
  800b8b:	5d                   	pop    %ebp
  800b8c:	c3                   	ret    

00800b8d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	83 ec 04             	sub    $0x4,%esp
  800b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b96:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b99:	eb 12                	jmp    800bad <strchr+0x20>
		if (*s == c)
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba3:	75 05                	jne    800baa <strchr+0x1d>
			return (char *) s;
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	eb 11                	jmp    800bbb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800baa:	ff 45 08             	incl   0x8(%ebp)
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8a 00                	mov    (%eax),%al
  800bb2:	84 c0                	test   %al,%al
  800bb4:	75 e5                	jne    800b9b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	83 ec 04             	sub    $0x4,%esp
  800bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bc9:	eb 0d                	jmp    800bd8 <strfind+0x1b>
		if (*s == c)
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	8a 00                	mov    (%eax),%al
  800bd0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd3:	74 0e                	je     800be3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd5:	ff 45 08             	incl   0x8(%ebp)
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	8a 00                	mov    (%eax),%al
  800bdd:	84 c0                	test   %al,%al
  800bdf:	75 ea                	jne    800bcb <strfind+0xe>
  800be1:	eb 01                	jmp    800be4 <strfind+0x27>
		if (*s == c)
			break;
  800be3:	90                   	nop
	return (char *) s;
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfb:	eb 0e                	jmp    800c0b <memset+0x22>
		*p++ = c;
  800bfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c00:	8d 50 01             	lea    0x1(%eax),%edx
  800c03:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c09:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0b:	ff 4d f8             	decl   -0x8(%ebp)
  800c0e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c12:	79 e9                	jns    800bfd <memset+0x14>
		*p++ = c;

	return v;
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c17:	c9                   	leave  
  800c18:	c3                   	ret    

00800c19 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2b:	eb 16                	jmp    800c43 <memcpy+0x2a>
		*d++ = *s++;
  800c2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c30:	8d 50 01             	lea    0x1(%eax),%edx
  800c33:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c39:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c3f:	8a 12                	mov    (%edx),%dl
  800c41:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c43:	8b 45 10             	mov    0x10(%ebp),%eax
  800c46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c49:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4c:	85 c0                	test   %eax,%eax
  800c4e:	75 dd                	jne    800c2d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c53:	c9                   	leave  
  800c54:	c3                   	ret    

00800c55 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c6d:	73 50                	jae    800cbf <memmove+0x6a>
  800c6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c72:	8b 45 10             	mov    0x10(%ebp),%eax
  800c75:	01 d0                	add    %edx,%eax
  800c77:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7a:	76 43                	jbe    800cbf <memmove+0x6a>
		s += n;
  800c7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c82:	8b 45 10             	mov    0x10(%ebp),%eax
  800c85:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c88:	eb 10                	jmp    800c9a <memmove+0x45>
			*--d = *--s;
  800c8a:	ff 4d f8             	decl   -0x8(%ebp)
  800c8d:	ff 4d fc             	decl   -0x4(%ebp)
  800c90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c93:	8a 10                	mov    (%eax),%dl
  800c95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c98:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	75 e3                	jne    800c8a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca7:	eb 23                	jmp    800ccc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ca9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cac:	8d 50 01             	lea    0x1(%eax),%edx
  800caf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbb:	8a 12                	mov    (%edx),%dl
  800cbd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc5:	89 55 10             	mov    %edx,0x10(%ebp)
  800cc8:	85 c0                	test   %eax,%eax
  800cca:	75 dd                	jne    800ca9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ccf:	c9                   	leave  
  800cd0:	c3                   	ret    

00800cd1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce3:	eb 2a                	jmp    800d0f <memcmp+0x3e>
		if (*s1 != *s2)
  800ce5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce8:	8a 10                	mov    (%eax),%dl
  800cea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	38 c2                	cmp    %al,%dl
  800cf1:	74 16                	je     800d09 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	0f b6 d0             	movzbl %al,%edx
  800cfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	0f b6 c0             	movzbl %al,%eax
  800d03:	29 c2                	sub    %eax,%edx
  800d05:	89 d0                	mov    %edx,%eax
  800d07:	eb 18                	jmp    800d21 <memcmp+0x50>
		s1++, s2++;
  800d09:	ff 45 fc             	incl   -0x4(%ebp)
  800d0c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d15:	89 55 10             	mov    %edx,0x10(%ebp)
  800d18:	85 c0                	test   %eax,%eax
  800d1a:	75 c9                	jne    800ce5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d21:	c9                   	leave  
  800d22:	c3                   	ret    

00800d23 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d29:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2f:	01 d0                	add    %edx,%eax
  800d31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d34:	eb 15                	jmp    800d4b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	0f b6 d0             	movzbl %al,%edx
  800d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d41:	0f b6 c0             	movzbl %al,%eax
  800d44:	39 c2                	cmp    %eax,%edx
  800d46:	74 0d                	je     800d55 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d48:	ff 45 08             	incl   0x8(%ebp)
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d51:	72 e3                	jb     800d36 <memfind+0x13>
  800d53:	eb 01                	jmp    800d56 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d55:	90                   	nop
	return (void *) s;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d59:	c9                   	leave  
  800d5a:	c3                   	ret    

00800d5b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d68:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d6f:	eb 03                	jmp    800d74 <strtol+0x19>
		s++;
  800d71:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	3c 20                	cmp    $0x20,%al
  800d7b:	74 f4                	je     800d71 <strtol+0x16>
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	3c 09                	cmp    $0x9,%al
  800d84:	74 eb                	je     800d71 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	3c 2b                	cmp    $0x2b,%al
  800d8d:	75 05                	jne    800d94 <strtol+0x39>
		s++;
  800d8f:	ff 45 08             	incl   0x8(%ebp)
  800d92:	eb 13                	jmp    800da7 <strtol+0x4c>
	else if (*s == '-')
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	3c 2d                	cmp    $0x2d,%al
  800d9b:	75 0a                	jne    800da7 <strtol+0x4c>
		s++, neg = 1;
  800d9d:	ff 45 08             	incl   0x8(%ebp)
  800da0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800da7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dab:	74 06                	je     800db3 <strtol+0x58>
  800dad:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db1:	75 20                	jne    800dd3 <strtol+0x78>
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8a 00                	mov    (%eax),%al
  800db8:	3c 30                	cmp    $0x30,%al
  800dba:	75 17                	jne    800dd3 <strtol+0x78>
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	40                   	inc    %eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	3c 78                	cmp    $0x78,%al
  800dc4:	75 0d                	jne    800dd3 <strtol+0x78>
		s += 2, base = 16;
  800dc6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dca:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd1:	eb 28                	jmp    800dfb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd7:	75 15                	jne    800dee <strtol+0x93>
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	3c 30                	cmp    $0x30,%al
  800de0:	75 0c                	jne    800dee <strtol+0x93>
		s++, base = 8;
  800de2:	ff 45 08             	incl   0x8(%ebp)
  800de5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dec:	eb 0d                	jmp    800dfb <strtol+0xa0>
	else if (base == 0)
  800dee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df2:	75 07                	jne    800dfb <strtol+0xa0>
		base = 10;
  800df4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	3c 2f                	cmp    $0x2f,%al
  800e02:	7e 19                	jle    800e1d <strtol+0xc2>
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	3c 39                	cmp    $0x39,%al
  800e0b:	7f 10                	jg     800e1d <strtol+0xc2>
			dig = *s - '0';
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	0f be c0             	movsbl %al,%eax
  800e15:	83 e8 30             	sub    $0x30,%eax
  800e18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1b:	eb 42                	jmp    800e5f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	3c 60                	cmp    $0x60,%al
  800e24:	7e 19                	jle    800e3f <strtol+0xe4>
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8a 00                	mov    (%eax),%al
  800e2b:	3c 7a                	cmp    $0x7a,%al
  800e2d:	7f 10                	jg     800e3f <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	8a 00                	mov    (%eax),%al
  800e34:	0f be c0             	movsbl %al,%eax
  800e37:	83 e8 57             	sub    $0x57,%eax
  800e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e3d:	eb 20                	jmp    800e5f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	3c 40                	cmp    $0x40,%al
  800e46:	7e 39                	jle    800e81 <strtol+0x126>
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	3c 5a                	cmp    $0x5a,%al
  800e4f:	7f 30                	jg     800e81 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8a 00                	mov    (%eax),%al
  800e56:	0f be c0             	movsbl %al,%eax
  800e59:	83 e8 37             	sub    $0x37,%eax
  800e5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e62:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e65:	7d 19                	jge    800e80 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e67:	ff 45 08             	incl   0x8(%ebp)
  800e6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e71:	89 c2                	mov    %eax,%edx
  800e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e76:	01 d0                	add    %edx,%eax
  800e78:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7b:	e9 7b ff ff ff       	jmp    800dfb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e80:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e85:	74 08                	je     800e8f <strtol+0x134>
		*endptr = (char *) s;
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e93:	74 07                	je     800e9c <strtol+0x141>
  800e95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e98:	f7 d8                	neg    %eax
  800e9a:	eb 03                	jmp    800e9f <strtol+0x144>
  800e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e9f:	c9                   	leave  
  800ea0:	c3                   	ret    

00800ea1 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ea7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800eb9:	79 13                	jns    800ece <ltostr+0x2d>
	{
		neg = 1;
  800ebb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ec8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ecb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed6:	99                   	cltd   
  800ed7:	f7 f9                	idiv   %ecx
  800ed9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800edc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800edf:	8d 50 01             	lea    0x1(%eax),%edx
  800ee2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee5:	89 c2                	mov    %eax,%edx
  800ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eea:	01 d0                	add    %edx,%eax
  800eec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800eef:	83 c2 30             	add    $0x30,%edx
  800ef2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800efc:	f7 e9                	imul   %ecx
  800efe:	c1 fa 02             	sar    $0x2,%edx
  800f01:	89 c8                	mov    %ecx,%eax
  800f03:	c1 f8 1f             	sar    $0x1f,%eax
  800f06:	29 c2                	sub    %eax,%edx
  800f08:	89 d0                	mov    %edx,%eax
  800f0a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f10:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f15:	f7 e9                	imul   %ecx
  800f17:	c1 fa 02             	sar    $0x2,%edx
  800f1a:	89 c8                	mov    %ecx,%eax
  800f1c:	c1 f8 1f             	sar    $0x1f,%eax
  800f1f:	29 c2                	sub    %eax,%edx
  800f21:	89 d0                	mov    %edx,%eax
  800f23:	c1 e0 02             	shl    $0x2,%eax
  800f26:	01 d0                	add    %edx,%eax
  800f28:	01 c0                	add    %eax,%eax
  800f2a:	29 c1                	sub    %eax,%ecx
  800f2c:	89 ca                	mov    %ecx,%edx
  800f2e:	85 d2                	test   %edx,%edx
  800f30:	75 9c                	jne    800ece <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3c:	48                   	dec    %eax
  800f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f40:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f44:	74 3d                	je     800f83 <ltostr+0xe2>
		start = 1 ;
  800f46:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f4d:	eb 34                	jmp    800f83 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	01 d0                	add    %edx,%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	01 c2                	add    %eax,%edx
  800f64:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6a:	01 c8                	add    %ecx,%eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	01 c2                	add    %eax,%edx
  800f78:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7b:	88 02                	mov    %al,(%edx)
		start++ ;
  800f7d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f80:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f86:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f89:	7c c4                	jl     800f4f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	01 d0                	add    %edx,%eax
  800f93:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f96:	90                   	nop
  800f97:	c9                   	leave  
  800f98:	c3                   	ret    

00800f99 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f9f:	ff 75 08             	pushl  0x8(%ebp)
  800fa2:	e8 54 fa ff ff       	call   8009fb <strlen>
  800fa7:	83 c4 04             	add    $0x4,%esp
  800faa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fad:	ff 75 0c             	pushl  0xc(%ebp)
  800fb0:	e8 46 fa ff ff       	call   8009fb <strlen>
  800fb5:	83 c4 04             	add    $0x4,%esp
  800fb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fc9:	eb 17                	jmp    800fe2 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fcb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fce:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd1:	01 c2                	add    %eax,%edx
  800fd3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	01 c8                	add    %ecx,%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fdf:	ff 45 fc             	incl   -0x4(%ebp)
  800fe2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fe8:	7c e1                	jl     800fcb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ff8:	eb 1f                	jmp    801019 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffd:	8d 50 01             	lea    0x1(%eax),%edx
  801000:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801003:	89 c2                	mov    %eax,%edx
  801005:	8b 45 10             	mov    0x10(%ebp),%eax
  801008:	01 c2                	add    %eax,%edx
  80100a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80100d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801010:	01 c8                	add    %ecx,%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801016:	ff 45 f8             	incl   -0x8(%ebp)
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80101f:	7c d9                	jl     800ffa <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801021:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801024:	8b 45 10             	mov    0x10(%ebp),%eax
  801027:	01 d0                	add    %edx,%eax
  801029:	c6 00 00             	movb   $0x0,(%eax)
}
  80102c:	90                   	nop
  80102d:	c9                   	leave  
  80102e:	c3                   	ret    

0080102f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801032:	8b 45 14             	mov    0x14(%ebp),%eax
  801035:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103b:	8b 45 14             	mov    0x14(%ebp),%eax
  80103e:	8b 00                	mov    (%eax),%eax
  801040:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801047:	8b 45 10             	mov    0x10(%ebp),%eax
  80104a:	01 d0                	add    %edx,%eax
  80104c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801052:	eb 0c                	jmp    801060 <strsplit+0x31>
			*string++ = 0;
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8d 50 01             	lea    0x1(%eax),%edx
  80105a:	89 55 08             	mov    %edx,0x8(%ebp)
  80105d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	8a 00                	mov    (%eax),%al
  801065:	84 c0                	test   %al,%al
  801067:	74 18                	je     801081 <strsplit+0x52>
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	0f be c0             	movsbl %al,%eax
  801071:	50                   	push   %eax
  801072:	ff 75 0c             	pushl  0xc(%ebp)
  801075:	e8 13 fb ff ff       	call   800b8d <strchr>
  80107a:	83 c4 08             	add    $0x8,%esp
  80107d:	85 c0                	test   %eax,%eax
  80107f:	75 d3                	jne    801054 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	8a 00                	mov    (%eax),%al
  801086:	84 c0                	test   %al,%al
  801088:	74 5a                	je     8010e4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108a:	8b 45 14             	mov    0x14(%ebp),%eax
  80108d:	8b 00                	mov    (%eax),%eax
  80108f:	83 f8 0f             	cmp    $0xf,%eax
  801092:	75 07                	jne    80109b <strsplit+0x6c>
		{
			return 0;
  801094:	b8 00 00 00 00       	mov    $0x0,%eax
  801099:	eb 66                	jmp    801101 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109b:	8b 45 14             	mov    0x14(%ebp),%eax
  80109e:	8b 00                	mov    (%eax),%eax
  8010a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a3:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a6:	89 0a                	mov    %ecx,(%edx)
  8010a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 c2                	add    %eax,%edx
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010b9:	eb 03                	jmp    8010be <strsplit+0x8f>
			string++;
  8010bb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	84 c0                	test   %al,%al
  8010c5:	74 8b                	je     801052 <strsplit+0x23>
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	0f be c0             	movsbl %al,%eax
  8010cf:	50                   	push   %eax
  8010d0:	ff 75 0c             	pushl  0xc(%ebp)
  8010d3:	e8 b5 fa ff ff       	call   800b8d <strchr>
  8010d8:	83 c4 08             	add    $0x8,%esp
  8010db:	85 c0                	test   %eax,%eax
  8010dd:	74 dc                	je     8010bb <strsplit+0x8c>
			string++;
	}
  8010df:	e9 6e ff ff ff       	jmp    801052 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e8:	8b 00                	mov    (%eax),%eax
  8010ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	01 d0                	add    %edx,%eax
  8010f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010fc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	57                   	push   %edi
  801107:	56                   	push   %esi
  801108:	53                   	push   %ebx
  801109:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801112:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801115:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801118:	8b 7d 18             	mov    0x18(%ebp),%edi
  80111b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80111e:	cd 30                	int    $0x30
  801120:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801123:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801126:	83 c4 10             	add    $0x10,%esp
  801129:	5b                   	pop    %ebx
  80112a:	5e                   	pop    %esi
  80112b:	5f                   	pop    %edi
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    

0080112e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	83 ec 04             	sub    $0x4,%esp
  801134:	8b 45 10             	mov    0x10(%ebp),%eax
  801137:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80113a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	6a 00                	push   $0x0
  801143:	6a 00                	push   $0x0
  801145:	52                   	push   %edx
  801146:	ff 75 0c             	pushl  0xc(%ebp)
  801149:	50                   	push   %eax
  80114a:	6a 00                	push   $0x0
  80114c:	e8 b2 ff ff ff       	call   801103 <syscall>
  801151:	83 c4 18             	add    $0x18,%esp
}
  801154:	90                   	nop
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <sys_cgetc>:

int
sys_cgetc(void)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80115a:	6a 00                	push   $0x0
  80115c:	6a 00                	push   $0x0
  80115e:	6a 00                	push   $0x0
  801160:	6a 00                	push   $0x0
  801162:	6a 00                	push   $0x0
  801164:	6a 01                	push   $0x1
  801166:	e8 98 ff ff ff       	call   801103 <syscall>
  80116b:	83 c4 18             	add    $0x18,%esp
}
  80116e:	c9                   	leave  
  80116f:	c3                   	ret    

00801170 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	6a 00                	push   $0x0
  801178:	6a 00                	push   $0x0
  80117a:	6a 00                	push   $0x0
  80117c:	6a 00                	push   $0x0
  80117e:	50                   	push   %eax
  80117f:	6a 05                	push   $0x5
  801181:	e8 7d ff ff ff       	call   801103 <syscall>
  801186:	83 c4 18             	add    $0x18,%esp
}
  801189:	c9                   	leave  
  80118a:	c3                   	ret    

0080118b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80118e:	6a 00                	push   $0x0
  801190:	6a 00                	push   $0x0
  801192:	6a 00                	push   $0x0
  801194:	6a 00                	push   $0x0
  801196:	6a 00                	push   $0x0
  801198:	6a 02                	push   $0x2
  80119a:	e8 64 ff ff ff       	call   801103 <syscall>
  80119f:	83 c4 18             	add    $0x18,%esp
}
  8011a2:	c9                   	leave  
  8011a3:	c3                   	ret    

008011a4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8011a7:	6a 00                	push   $0x0
  8011a9:	6a 00                	push   $0x0
  8011ab:	6a 00                	push   $0x0
  8011ad:	6a 00                	push   $0x0
  8011af:	6a 00                	push   $0x0
  8011b1:	6a 03                	push   $0x3
  8011b3:	e8 4b ff ff ff       	call   801103 <syscall>
  8011b8:	83 c4 18             	add    $0x18,%esp
}
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8011c0:	6a 00                	push   $0x0
  8011c2:	6a 00                	push   $0x0
  8011c4:	6a 00                	push   $0x0
  8011c6:	6a 00                	push   $0x0
  8011c8:	6a 00                	push   $0x0
  8011ca:	6a 04                	push   $0x4
  8011cc:	e8 32 ff ff ff       	call   801103 <syscall>
  8011d1:	83 c4 18             	add    $0x18,%esp
}
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <sys_env_exit>:


void sys_env_exit(void)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8011d9:	6a 00                	push   $0x0
  8011db:	6a 00                	push   $0x0
  8011dd:	6a 00                	push   $0x0
  8011df:	6a 00                	push   $0x0
  8011e1:	6a 00                	push   $0x0
  8011e3:	6a 06                	push   $0x6
  8011e5:	e8 19 ff ff ff       	call   801103 <syscall>
  8011ea:	83 c4 18             	add    $0x18,%esp
}
  8011ed:	90                   	nop
  8011ee:	c9                   	leave  
  8011ef:	c3                   	ret    

008011f0 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8011f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 00                	push   $0x0
  8011ff:	52                   	push   %edx
  801200:	50                   	push   %eax
  801201:	6a 07                	push   $0x7
  801203:	e8 fb fe ff ff       	call   801103 <syscall>
  801208:	83 c4 18             	add    $0x18,%esp
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	56                   	push   %esi
  801211:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801212:	8b 75 18             	mov    0x18(%ebp),%esi
  801215:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801218:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80121b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	56                   	push   %esi
  801222:	53                   	push   %ebx
  801223:	51                   	push   %ecx
  801224:	52                   	push   %edx
  801225:	50                   	push   %eax
  801226:	6a 08                	push   $0x8
  801228:	e8 d6 fe ff ff       	call   801103 <syscall>
  80122d:	83 c4 18             	add    $0x18,%esp
}
  801230:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801233:	5b                   	pop    %ebx
  801234:	5e                   	pop    %esi
  801235:	5d                   	pop    %ebp
  801236:	c3                   	ret    

00801237 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80123a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	6a 00                	push   $0x0
  801242:	6a 00                	push   $0x0
  801244:	6a 00                	push   $0x0
  801246:	52                   	push   %edx
  801247:	50                   	push   %eax
  801248:	6a 09                	push   $0x9
  80124a:	e8 b4 fe ff ff       	call   801103 <syscall>
  80124f:	83 c4 18             	add    $0x18,%esp
}
  801252:	c9                   	leave  
  801253:	c3                   	ret    

00801254 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801257:	6a 00                	push   $0x0
  801259:	6a 00                	push   $0x0
  80125b:	6a 00                	push   $0x0
  80125d:	ff 75 0c             	pushl  0xc(%ebp)
  801260:	ff 75 08             	pushl  0x8(%ebp)
  801263:	6a 0a                	push   $0xa
  801265:	e8 99 fe ff ff       	call   801103 <syscall>
  80126a:	83 c4 18             	add    $0x18,%esp
}
  80126d:	c9                   	leave  
  80126e:	c3                   	ret    

0080126f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801272:	6a 00                	push   $0x0
  801274:	6a 00                	push   $0x0
  801276:	6a 00                	push   $0x0
  801278:	6a 00                	push   $0x0
  80127a:	6a 00                	push   $0x0
  80127c:	6a 0b                	push   $0xb
  80127e:	e8 80 fe ff ff       	call   801103 <syscall>
  801283:	83 c4 18             	add    $0x18,%esp
}
  801286:	c9                   	leave  
  801287:	c3                   	ret    

00801288 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 0c                	push   $0xc
  801297:	e8 67 fe ff ff       	call   801103 <syscall>
  80129c:	83 c4 18             	add    $0x18,%esp
}
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    

008012a1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 0d                	push   $0xd
  8012b0:	e8 4e fe ff ff       	call   801103 <syscall>
  8012b5:	83 c4 18             	add    $0x18,%esp
}
  8012b8:	c9                   	leave  
  8012b9:	c3                   	ret    

008012ba <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	ff 75 0c             	pushl  0xc(%ebp)
  8012c6:	ff 75 08             	pushl  0x8(%ebp)
  8012c9:	6a 11                	push   $0x11
  8012cb:	e8 33 fe ff ff       	call   801103 <syscall>
  8012d0:	83 c4 18             	add    $0x18,%esp
	return;
  8012d3:	90                   	nop
}
  8012d4:	c9                   	leave  
  8012d5:	c3                   	ret    

008012d6 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 00                	push   $0x0
  8012dd:	6a 00                	push   $0x0
  8012df:	ff 75 0c             	pushl  0xc(%ebp)
  8012e2:	ff 75 08             	pushl  0x8(%ebp)
  8012e5:	6a 12                	push   $0x12
  8012e7:	e8 17 fe ff ff       	call   801103 <syscall>
  8012ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8012ef:	90                   	nop
}
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 0e                	push   $0xe
  801301:	e8 fd fd ff ff       	call   801103 <syscall>
  801306:	83 c4 18             	add    $0x18,%esp
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	ff 75 08             	pushl  0x8(%ebp)
  801319:	6a 0f                	push   $0xf
  80131b:	e8 e3 fd ff ff       	call   801103 <syscall>
  801320:	83 c4 18             	add    $0x18,%esp
}
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 10                	push   $0x10
  801334:	e8 ca fd ff ff       	call   801103 <syscall>
  801339:	83 c4 18             	add    $0x18,%esp
}
  80133c:	90                   	nop
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 14                	push   $0x14
  80134e:	e8 b0 fd ff ff       	call   801103 <syscall>
  801353:	83 c4 18             	add    $0x18,%esp
}
  801356:	90                   	nop
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 15                	push   $0x15
  801368:	e8 96 fd ff ff       	call   801103 <syscall>
  80136d:	83 c4 18             	add    $0x18,%esp
}
  801370:	90                   	nop
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <sys_cputc>:


void
sys_cputc(const char c)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 04             	sub    $0x4,%esp
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80137f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	50                   	push   %eax
  80138c:	6a 16                	push   $0x16
  80138e:	e8 70 fd ff ff       	call   801103 <syscall>
  801393:	83 c4 18             	add    $0x18,%esp
}
  801396:	90                   	nop
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 17                	push   $0x17
  8013a8:	e8 56 fd ff ff       	call   801103 <syscall>
  8013ad:	83 c4 18             	add    $0x18,%esp
}
  8013b0:	90                   	nop
  8013b1:	c9                   	leave  
  8013b2:	c3                   	ret    

008013b3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	ff 75 0c             	pushl  0xc(%ebp)
  8013c2:	50                   	push   %eax
  8013c3:	6a 18                	push   $0x18
  8013c5:	e8 39 fd ff ff       	call   801103 <syscall>
  8013ca:	83 c4 18             	add    $0x18,%esp
}
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8013d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	52                   	push   %edx
  8013df:	50                   	push   %eax
  8013e0:	6a 1b                	push   $0x1b
  8013e2:	e8 1c fd ff ff       	call   801103 <syscall>
  8013e7:	83 c4 18             	add    $0x18,%esp
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8013ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	52                   	push   %edx
  8013fc:	50                   	push   %eax
  8013fd:	6a 19                	push   $0x19
  8013ff:	e8 ff fc ff ff       	call   801103 <syscall>
  801404:	83 c4 18             	add    $0x18,%esp
}
  801407:	90                   	nop
  801408:	c9                   	leave  
  801409:	c3                   	ret    

0080140a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80140d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	52                   	push   %edx
  80141a:	50                   	push   %eax
  80141b:	6a 1a                	push   $0x1a
  80141d:	e8 e1 fc ff ff       	call   801103 <syscall>
  801422:	83 c4 18             	add    $0x18,%esp
}
  801425:	90                   	nop
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 04             	sub    $0x4,%esp
  80142e:	8b 45 10             	mov    0x10(%ebp),%eax
  801431:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801434:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801437:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	6a 00                	push   $0x0
  801440:	51                   	push   %ecx
  801441:	52                   	push   %edx
  801442:	ff 75 0c             	pushl  0xc(%ebp)
  801445:	50                   	push   %eax
  801446:	6a 1c                	push   $0x1c
  801448:	e8 b6 fc ff ff       	call   801103 <syscall>
  80144d:	83 c4 18             	add    $0x18,%esp
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801455:	8b 55 0c             	mov    0xc(%ebp),%edx
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	52                   	push   %edx
  801462:	50                   	push   %eax
  801463:	6a 1d                	push   $0x1d
  801465:	e8 99 fc ff ff       	call   801103 <syscall>
  80146a:	83 c4 18             	add    $0x18,%esp
}
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801472:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801475:	8b 55 0c             	mov    0xc(%ebp),%edx
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	51                   	push   %ecx
  801480:	52                   	push   %edx
  801481:	50                   	push   %eax
  801482:	6a 1e                	push   $0x1e
  801484:	e8 7a fc ff ff       	call   801103 <syscall>
  801489:	83 c4 18             	add    $0x18,%esp
}
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801491:	8b 55 0c             	mov    0xc(%ebp),%edx
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	52                   	push   %edx
  80149e:	50                   	push   %eax
  80149f:	6a 1f                	push   $0x1f
  8014a1:	e8 5d fc ff ff       	call   801103 <syscall>
  8014a6:	83 c4 18             	add    $0x18,%esp
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 20                	push   $0x20
  8014ba:	e8 44 fc ff ff       	call   801103 <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	ff 75 10             	pushl  0x10(%ebp)
  8014d1:	ff 75 0c             	pushl  0xc(%ebp)
  8014d4:	50                   	push   %eax
  8014d5:	6a 21                	push   $0x21
  8014d7:	e8 27 fc ff ff       	call   801103 <syscall>
  8014dc:	83 c4 18             	add    $0x18,%esp
}
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	50                   	push   %eax
  8014f0:	6a 22                	push   $0x22
  8014f2:	e8 0c fc ff ff       	call   801103 <syscall>
  8014f7:	83 c4 18             	add    $0x18,%esp
}
  8014fa:	90                   	nop
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    

008014fd <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	50                   	push   %eax
  80150c:	6a 23                	push   $0x23
  80150e:	e8 f0 fb ff ff       	call   801103 <syscall>
  801513:	83 c4 18             	add    $0x18,%esp
}
  801516:	90                   	nop
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80151f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801522:	8d 50 04             	lea    0x4(%eax),%edx
  801525:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	52                   	push   %edx
  80152f:	50                   	push   %eax
  801530:	6a 24                	push   $0x24
  801532:	e8 cc fb ff ff       	call   801103 <syscall>
  801537:	83 c4 18             	add    $0x18,%esp
	return result;
  80153a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80153d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801540:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801543:	89 01                	mov    %eax,(%ecx)
  801545:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	c9                   	leave  
  80154c:	c2 04 00             	ret    $0x4

0080154f <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	ff 75 10             	pushl  0x10(%ebp)
  801559:	ff 75 0c             	pushl  0xc(%ebp)
  80155c:	ff 75 08             	pushl  0x8(%ebp)
  80155f:	6a 13                	push   $0x13
  801561:	e8 9d fb ff ff       	call   801103 <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
	return ;
  801569:	90                   	nop
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_rcr2>:
uint32 sys_rcr2()
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 25                	push   $0x25
  80157b:	e8 83 fb ff ff       	call   801103 <syscall>
  801580:	83 c4 18             	add    $0x18,%esp
}
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 04             	sub    $0x4,%esp
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801591:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	50                   	push   %eax
  80159e:	6a 26                	push   $0x26
  8015a0:	e8 5e fb ff ff       	call   801103 <syscall>
  8015a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a8:	90                   	nop
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <rsttst>:
void rsttst()
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 28                	push   $0x28
  8015ba:	e8 44 fb ff ff       	call   801103 <syscall>
  8015bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c2:	90                   	nop
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 04             	sub    $0x4,%esp
  8015cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015d1:	8b 55 18             	mov    0x18(%ebp),%edx
  8015d4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015d8:	52                   	push   %edx
  8015d9:	50                   	push   %eax
  8015da:	ff 75 10             	pushl  0x10(%ebp)
  8015dd:	ff 75 0c             	pushl  0xc(%ebp)
  8015e0:	ff 75 08             	pushl  0x8(%ebp)
  8015e3:	6a 27                	push   $0x27
  8015e5:	e8 19 fb ff ff       	call   801103 <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ed:	90                   	nop
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <chktst>:
void chktst(uint32 n)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	ff 75 08             	pushl  0x8(%ebp)
  8015fe:	6a 29                	push   $0x29
  801600:	e8 fe fa ff ff       	call   801103 <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
	return ;
  801608:	90                   	nop
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <inctst>:

void inctst()
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 2a                	push   $0x2a
  80161a:	e8 e4 fa ff ff       	call   801103 <syscall>
  80161f:	83 c4 18             	add    $0x18,%esp
	return ;
  801622:	90                   	nop
}
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <gettst>:
uint32 gettst()
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 2b                	push   $0x2b
  801634:	e8 ca fa ff ff       	call   801103 <syscall>
  801639:	83 c4 18             	add    $0x18,%esp
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 2c                	push   $0x2c
  801650:	e8 ae fa ff ff       	call   801103 <syscall>
  801655:	83 c4 18             	add    $0x18,%esp
  801658:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80165b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80165f:	75 07                	jne    801668 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801661:	b8 01 00 00 00       	mov    $0x1,%eax
  801666:	eb 05                	jmp    80166d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801668:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 2c                	push   $0x2c
  801681:	e8 7d fa ff ff       	call   801103 <syscall>
  801686:	83 c4 18             	add    $0x18,%esp
  801689:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80168c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801690:	75 07                	jne    801699 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801692:	b8 01 00 00 00       	mov    $0x1,%eax
  801697:	eb 05                	jmp    80169e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 2c                	push   $0x2c
  8016b2:	e8 4c fa ff ff       	call   801103 <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
  8016ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016bd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016c1:	75 07                	jne    8016ca <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8016c8:	eb 05                	jmp    8016cf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 2c                	push   $0x2c
  8016e3:	e8 1b fa ff ff       	call   801103 <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
  8016eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8016ee:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8016f2:	75 07                	jne    8016fb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8016f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8016f9:	eb 05                	jmp    801700 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8016fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	ff 75 08             	pushl  0x8(%ebp)
  801710:	6a 2d                	push   $0x2d
  801712:	e8 ec f9 ff ff       	call   801103 <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
	return ;
  80171a:	90                   	nop
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801721:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801724:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	6a 00                	push   $0x0
  80172f:	53                   	push   %ebx
  801730:	51                   	push   %ecx
  801731:	52                   	push   %edx
  801732:	50                   	push   %eax
  801733:	6a 2e                	push   $0x2e
  801735:	e8 c9 f9 ff ff       	call   801103 <syscall>
  80173a:	83 c4 18             	add    $0x18,%esp
}
  80173d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801745:	8b 55 0c             	mov    0xc(%ebp),%edx
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	52                   	push   %edx
  801752:	50                   	push   %eax
  801753:	6a 2f                	push   $0x2f
  801755:	e8 a9 f9 ff ff       	call   801103 <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801765:	8b 55 08             	mov    0x8(%ebp),%edx
  801768:	89 d0                	mov    %edx,%eax
  80176a:	c1 e0 02             	shl    $0x2,%eax
  80176d:	01 d0                	add    %edx,%eax
  80176f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801776:	01 d0                	add    %edx,%eax
  801778:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80177f:	01 d0                	add    %edx,%eax
  801781:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801788:	01 d0                	add    %edx,%eax
  80178a:	c1 e0 04             	shl    $0x4,%eax
  80178d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801790:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801797:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80179a:	83 ec 0c             	sub    $0xc,%esp
  80179d:	50                   	push   %eax
  80179e:	e8 76 fd ff ff       	call   801519 <sys_get_virtual_time>
  8017a3:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8017a6:	eb 41                	jmp    8017e9 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8017a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017ab:	83 ec 0c             	sub    $0xc,%esp
  8017ae:	50                   	push   %eax
  8017af:	e8 65 fd ff ff       	call   801519 <sys_get_virtual_time>
  8017b4:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8017b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017bd:	29 c2                	sub    %eax,%edx
  8017bf:	89 d0                	mov    %edx,%eax
  8017c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8017c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ca:	89 d1                	mov    %edx,%ecx
  8017cc:	29 c1                	sub    %eax,%ecx
  8017ce:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8017d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017d4:	39 c2                	cmp    %eax,%edx
  8017d6:	0f 97 c0             	seta   %al
  8017d9:	0f b6 c0             	movzbl %al,%eax
  8017dc:	29 c1                	sub    %eax,%ecx
  8017de:	89 c8                	mov    %ecx,%eax
  8017e0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8017e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8017e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017ef:	72 b7                	jb     8017a8 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8017f1:	90                   	nop
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8017fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801801:	eb 03                	jmp    801806 <busy_wait+0x12>
  801803:	ff 45 fc             	incl   -0x4(%ebp)
  801806:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801809:	3b 45 08             	cmp    0x8(%ebp),%eax
  80180c:	72 f5                	jb     801803 <busy_wait+0xf>
	return i;
  80180e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    
  801813:	90                   	nop

00801814 <__udivdi3>:
  801814:	55                   	push   %ebp
  801815:	57                   	push   %edi
  801816:	56                   	push   %esi
  801817:	53                   	push   %ebx
  801818:	83 ec 1c             	sub    $0x1c,%esp
  80181b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80181f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801823:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801827:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80182b:	89 ca                	mov    %ecx,%edx
  80182d:	89 f8                	mov    %edi,%eax
  80182f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801833:	85 f6                	test   %esi,%esi
  801835:	75 2d                	jne    801864 <__udivdi3+0x50>
  801837:	39 cf                	cmp    %ecx,%edi
  801839:	77 65                	ja     8018a0 <__udivdi3+0x8c>
  80183b:	89 fd                	mov    %edi,%ebp
  80183d:	85 ff                	test   %edi,%edi
  80183f:	75 0b                	jne    80184c <__udivdi3+0x38>
  801841:	b8 01 00 00 00       	mov    $0x1,%eax
  801846:	31 d2                	xor    %edx,%edx
  801848:	f7 f7                	div    %edi
  80184a:	89 c5                	mov    %eax,%ebp
  80184c:	31 d2                	xor    %edx,%edx
  80184e:	89 c8                	mov    %ecx,%eax
  801850:	f7 f5                	div    %ebp
  801852:	89 c1                	mov    %eax,%ecx
  801854:	89 d8                	mov    %ebx,%eax
  801856:	f7 f5                	div    %ebp
  801858:	89 cf                	mov    %ecx,%edi
  80185a:	89 fa                	mov    %edi,%edx
  80185c:	83 c4 1c             	add    $0x1c,%esp
  80185f:	5b                   	pop    %ebx
  801860:	5e                   	pop    %esi
  801861:	5f                   	pop    %edi
  801862:	5d                   	pop    %ebp
  801863:	c3                   	ret    
  801864:	39 ce                	cmp    %ecx,%esi
  801866:	77 28                	ja     801890 <__udivdi3+0x7c>
  801868:	0f bd fe             	bsr    %esi,%edi
  80186b:	83 f7 1f             	xor    $0x1f,%edi
  80186e:	75 40                	jne    8018b0 <__udivdi3+0x9c>
  801870:	39 ce                	cmp    %ecx,%esi
  801872:	72 0a                	jb     80187e <__udivdi3+0x6a>
  801874:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801878:	0f 87 9e 00 00 00    	ja     80191c <__udivdi3+0x108>
  80187e:	b8 01 00 00 00       	mov    $0x1,%eax
  801883:	89 fa                	mov    %edi,%edx
  801885:	83 c4 1c             	add    $0x1c,%esp
  801888:	5b                   	pop    %ebx
  801889:	5e                   	pop    %esi
  80188a:	5f                   	pop    %edi
  80188b:	5d                   	pop    %ebp
  80188c:	c3                   	ret    
  80188d:	8d 76 00             	lea    0x0(%esi),%esi
  801890:	31 ff                	xor    %edi,%edi
  801892:	31 c0                	xor    %eax,%eax
  801894:	89 fa                	mov    %edi,%edx
  801896:	83 c4 1c             	add    $0x1c,%esp
  801899:	5b                   	pop    %ebx
  80189a:	5e                   	pop    %esi
  80189b:	5f                   	pop    %edi
  80189c:	5d                   	pop    %ebp
  80189d:	c3                   	ret    
  80189e:	66 90                	xchg   %ax,%ax
  8018a0:	89 d8                	mov    %ebx,%eax
  8018a2:	f7 f7                	div    %edi
  8018a4:	31 ff                	xor    %edi,%edi
  8018a6:	89 fa                	mov    %edi,%edx
  8018a8:	83 c4 1c             	add    $0x1c,%esp
  8018ab:	5b                   	pop    %ebx
  8018ac:	5e                   	pop    %esi
  8018ad:	5f                   	pop    %edi
  8018ae:	5d                   	pop    %ebp
  8018af:	c3                   	ret    
  8018b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018b5:	89 eb                	mov    %ebp,%ebx
  8018b7:	29 fb                	sub    %edi,%ebx
  8018b9:	89 f9                	mov    %edi,%ecx
  8018bb:	d3 e6                	shl    %cl,%esi
  8018bd:	89 c5                	mov    %eax,%ebp
  8018bf:	88 d9                	mov    %bl,%cl
  8018c1:	d3 ed                	shr    %cl,%ebp
  8018c3:	89 e9                	mov    %ebp,%ecx
  8018c5:	09 f1                	or     %esi,%ecx
  8018c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018cb:	89 f9                	mov    %edi,%ecx
  8018cd:	d3 e0                	shl    %cl,%eax
  8018cf:	89 c5                	mov    %eax,%ebp
  8018d1:	89 d6                	mov    %edx,%esi
  8018d3:	88 d9                	mov    %bl,%cl
  8018d5:	d3 ee                	shr    %cl,%esi
  8018d7:	89 f9                	mov    %edi,%ecx
  8018d9:	d3 e2                	shl    %cl,%edx
  8018db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018df:	88 d9                	mov    %bl,%cl
  8018e1:	d3 e8                	shr    %cl,%eax
  8018e3:	09 c2                	or     %eax,%edx
  8018e5:	89 d0                	mov    %edx,%eax
  8018e7:	89 f2                	mov    %esi,%edx
  8018e9:	f7 74 24 0c          	divl   0xc(%esp)
  8018ed:	89 d6                	mov    %edx,%esi
  8018ef:	89 c3                	mov    %eax,%ebx
  8018f1:	f7 e5                	mul    %ebp
  8018f3:	39 d6                	cmp    %edx,%esi
  8018f5:	72 19                	jb     801910 <__udivdi3+0xfc>
  8018f7:	74 0b                	je     801904 <__udivdi3+0xf0>
  8018f9:	89 d8                	mov    %ebx,%eax
  8018fb:	31 ff                	xor    %edi,%edi
  8018fd:	e9 58 ff ff ff       	jmp    80185a <__udivdi3+0x46>
  801902:	66 90                	xchg   %ax,%ax
  801904:	8b 54 24 08          	mov    0x8(%esp),%edx
  801908:	89 f9                	mov    %edi,%ecx
  80190a:	d3 e2                	shl    %cl,%edx
  80190c:	39 c2                	cmp    %eax,%edx
  80190e:	73 e9                	jae    8018f9 <__udivdi3+0xe5>
  801910:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801913:	31 ff                	xor    %edi,%edi
  801915:	e9 40 ff ff ff       	jmp    80185a <__udivdi3+0x46>
  80191a:	66 90                	xchg   %ax,%ax
  80191c:	31 c0                	xor    %eax,%eax
  80191e:	e9 37 ff ff ff       	jmp    80185a <__udivdi3+0x46>
  801923:	90                   	nop

00801924 <__umoddi3>:
  801924:	55                   	push   %ebp
  801925:	57                   	push   %edi
  801926:	56                   	push   %esi
  801927:	53                   	push   %ebx
  801928:	83 ec 1c             	sub    $0x1c,%esp
  80192b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80192f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801933:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801937:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80193b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80193f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801943:	89 f3                	mov    %esi,%ebx
  801945:	89 fa                	mov    %edi,%edx
  801947:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80194b:	89 34 24             	mov    %esi,(%esp)
  80194e:	85 c0                	test   %eax,%eax
  801950:	75 1a                	jne    80196c <__umoddi3+0x48>
  801952:	39 f7                	cmp    %esi,%edi
  801954:	0f 86 a2 00 00 00    	jbe    8019fc <__umoddi3+0xd8>
  80195a:	89 c8                	mov    %ecx,%eax
  80195c:	89 f2                	mov    %esi,%edx
  80195e:	f7 f7                	div    %edi
  801960:	89 d0                	mov    %edx,%eax
  801962:	31 d2                	xor    %edx,%edx
  801964:	83 c4 1c             	add    $0x1c,%esp
  801967:	5b                   	pop    %ebx
  801968:	5e                   	pop    %esi
  801969:	5f                   	pop    %edi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    
  80196c:	39 f0                	cmp    %esi,%eax
  80196e:	0f 87 ac 00 00 00    	ja     801a20 <__umoddi3+0xfc>
  801974:	0f bd e8             	bsr    %eax,%ebp
  801977:	83 f5 1f             	xor    $0x1f,%ebp
  80197a:	0f 84 ac 00 00 00    	je     801a2c <__umoddi3+0x108>
  801980:	bf 20 00 00 00       	mov    $0x20,%edi
  801985:	29 ef                	sub    %ebp,%edi
  801987:	89 fe                	mov    %edi,%esi
  801989:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80198d:	89 e9                	mov    %ebp,%ecx
  80198f:	d3 e0                	shl    %cl,%eax
  801991:	89 d7                	mov    %edx,%edi
  801993:	89 f1                	mov    %esi,%ecx
  801995:	d3 ef                	shr    %cl,%edi
  801997:	09 c7                	or     %eax,%edi
  801999:	89 e9                	mov    %ebp,%ecx
  80199b:	d3 e2                	shl    %cl,%edx
  80199d:	89 14 24             	mov    %edx,(%esp)
  8019a0:	89 d8                	mov    %ebx,%eax
  8019a2:	d3 e0                	shl    %cl,%eax
  8019a4:	89 c2                	mov    %eax,%edx
  8019a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019aa:	d3 e0                	shl    %cl,%eax
  8019ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019b4:	89 f1                	mov    %esi,%ecx
  8019b6:	d3 e8                	shr    %cl,%eax
  8019b8:	09 d0                	or     %edx,%eax
  8019ba:	d3 eb                	shr    %cl,%ebx
  8019bc:	89 da                	mov    %ebx,%edx
  8019be:	f7 f7                	div    %edi
  8019c0:	89 d3                	mov    %edx,%ebx
  8019c2:	f7 24 24             	mull   (%esp)
  8019c5:	89 c6                	mov    %eax,%esi
  8019c7:	89 d1                	mov    %edx,%ecx
  8019c9:	39 d3                	cmp    %edx,%ebx
  8019cb:	0f 82 87 00 00 00    	jb     801a58 <__umoddi3+0x134>
  8019d1:	0f 84 91 00 00 00    	je     801a68 <__umoddi3+0x144>
  8019d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019db:	29 f2                	sub    %esi,%edx
  8019dd:	19 cb                	sbb    %ecx,%ebx
  8019df:	89 d8                	mov    %ebx,%eax
  8019e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019e5:	d3 e0                	shl    %cl,%eax
  8019e7:	89 e9                	mov    %ebp,%ecx
  8019e9:	d3 ea                	shr    %cl,%edx
  8019eb:	09 d0                	or     %edx,%eax
  8019ed:	89 e9                	mov    %ebp,%ecx
  8019ef:	d3 eb                	shr    %cl,%ebx
  8019f1:	89 da                	mov    %ebx,%edx
  8019f3:	83 c4 1c             	add    $0x1c,%esp
  8019f6:	5b                   	pop    %ebx
  8019f7:	5e                   	pop    %esi
  8019f8:	5f                   	pop    %edi
  8019f9:	5d                   	pop    %ebp
  8019fa:	c3                   	ret    
  8019fb:	90                   	nop
  8019fc:	89 fd                	mov    %edi,%ebp
  8019fe:	85 ff                	test   %edi,%edi
  801a00:	75 0b                	jne    801a0d <__umoddi3+0xe9>
  801a02:	b8 01 00 00 00       	mov    $0x1,%eax
  801a07:	31 d2                	xor    %edx,%edx
  801a09:	f7 f7                	div    %edi
  801a0b:	89 c5                	mov    %eax,%ebp
  801a0d:	89 f0                	mov    %esi,%eax
  801a0f:	31 d2                	xor    %edx,%edx
  801a11:	f7 f5                	div    %ebp
  801a13:	89 c8                	mov    %ecx,%eax
  801a15:	f7 f5                	div    %ebp
  801a17:	89 d0                	mov    %edx,%eax
  801a19:	e9 44 ff ff ff       	jmp    801962 <__umoddi3+0x3e>
  801a1e:	66 90                	xchg   %ax,%ax
  801a20:	89 c8                	mov    %ecx,%eax
  801a22:	89 f2                	mov    %esi,%edx
  801a24:	83 c4 1c             	add    $0x1c,%esp
  801a27:	5b                   	pop    %ebx
  801a28:	5e                   	pop    %esi
  801a29:	5f                   	pop    %edi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    
  801a2c:	3b 04 24             	cmp    (%esp),%eax
  801a2f:	72 06                	jb     801a37 <__umoddi3+0x113>
  801a31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a35:	77 0f                	ja     801a46 <__umoddi3+0x122>
  801a37:	89 f2                	mov    %esi,%edx
  801a39:	29 f9                	sub    %edi,%ecx
  801a3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a3f:	89 14 24             	mov    %edx,(%esp)
  801a42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a46:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a4a:	8b 14 24             	mov    (%esp),%edx
  801a4d:	83 c4 1c             	add    $0x1c,%esp
  801a50:	5b                   	pop    %ebx
  801a51:	5e                   	pop    %esi
  801a52:	5f                   	pop    %edi
  801a53:	5d                   	pop    %ebp
  801a54:	c3                   	ret    
  801a55:	8d 76 00             	lea    0x0(%esi),%esi
  801a58:	2b 04 24             	sub    (%esp),%eax
  801a5b:	19 fa                	sbb    %edi,%edx
  801a5d:	89 d1                	mov    %edx,%ecx
  801a5f:	89 c6                	mov    %eax,%esi
  801a61:	e9 71 ff ff ff       	jmp    8019d7 <__umoddi3+0xb3>
  801a66:	66 90                	xchg   %ax,%ax
  801a68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a6c:	72 ea                	jb     801a58 <__umoddi3+0x134>
  801a6e:	89 d9                	mov    %ebx,%ecx
  801a70:	e9 62 ff ff ff       	jmp    8019d7 <__umoddi3+0xb3>
