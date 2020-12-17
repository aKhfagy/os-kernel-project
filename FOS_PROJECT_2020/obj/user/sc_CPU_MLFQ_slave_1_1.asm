
obj/user/sc_CPU_MLFQ_slave_1_1:     file format elf32-i386


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
  800031:	e8 11 01 00 00       	call   800147 <libmain>
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
			ID = sys_create_env("tmlfq_2", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  800047:	a1 20 20 80 00       	mov    0x802020,%eax
  80004c:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800052:	a1 20 20 80 00       	mov    0x802020,%eax
  800057:	8b 40 74             	mov    0x74(%eax),%eax
  80005a:	83 ec 04             	sub    $0x4,%esp
  80005d:	52                   	push   %edx
  80005e:	50                   	push   %eax
  80005f:	68 60 1a 80 00       	push   $0x801a60
  800064:	e8 42 14 00 00       	call   8014ab <sys_create_env>
  800069:	83 c4 10             	add    $0x10,%esp
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			sys_run_env(ID);
  80006f:	83 ec 0c             	sub    $0xc,%esp
  800072:	ff 75 ec             	pushl  -0x14(%ebp)
  800075:	e8 4e 14 00 00       	call   8014c8 <sys_run_env>
  80007a:	83 c4 10             	add    $0x10,%esp
#include <inc/lib.h>

void _main(void)
{
	int ID;
	for (int i = 0; i < 5; ++i) {
  80007d:	ff 45 f4             	incl   -0xc(%ebp)
  800080:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
  800084:	7e c1                	jle    800047 <_main+0xf>
			ID = sys_create_env("tmlfq_2", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
			sys_run_env(ID);
		}
	//cprintf("done\n");
	//env_sleep(5000);
	int x = busy_wait(1000000);
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 42 0f 00       	push   $0xf4240
  80008e:	e8 48 17 00 00       	call   8017db <busy_wait>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (int i = 0; i < 5; ++i) {
  800099:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000a0:	e9 82 00 00 00       	jmp    800127 <_main+0xef>
			ID = sys_create_env("tmlfq_2", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000a5:	a1 20 20 80 00       	mov    0x802020,%eax
  8000aa:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8000b0:	a1 20 20 80 00       	mov    0x802020,%eax
  8000b5:	8b 40 74             	mov    0x74(%eax),%eax
  8000b8:	83 ec 04             	sub    $0x4,%esp
  8000bb:	52                   	push   %edx
  8000bc:	50                   	push   %eax
  8000bd:	68 60 1a 80 00       	push   $0x801a60
  8000c2:	e8 e4 13 00 00       	call   8014ab <sys_create_env>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
			sys_run_env(ID);
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d3:	e8 f0 13 00 00       	call   8014c8 <sys_run_env>
  8000d8:	83 c4 10             	add    $0x10,%esp
			x = busy_wait(10000);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 10 27 00 00       	push   $0x2710
  8000e3:	e8 f3 16 00 00       	call   8017db <busy_wait>
  8000e8:	83 c4 10             	add    $0x10,%esp
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			ID = sys_create_env("tmlfq_2", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000ee:	a1 20 20 80 00       	mov    0x802020,%eax
  8000f3:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8000f9:	a1 20 20 80 00       	mov    0x802020,%eax
  8000fe:	8b 40 74             	mov    0x74(%eax),%eax
  800101:	83 ec 04             	sub    $0x4,%esp
  800104:	52                   	push   %edx
  800105:	50                   	push   %eax
  800106:	68 60 1a 80 00       	push   $0x801a60
  80010b:	e8 9b 13 00 00       	call   8014ab <sys_create_env>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 ec             	mov    %eax,-0x14(%ebp)
			sys_run_env(ID);
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	ff 75 ec             	pushl  -0x14(%ebp)
  80011c:	e8 a7 13 00 00       	call   8014c8 <sys_run_env>
  800121:	83 c4 10             	add    $0x10,%esp
		}
	//cprintf("done\n");
	//env_sleep(5000);
	int x = busy_wait(1000000);

	for (int i = 0; i < 5; ++i) {
  800124:	ff 45 f0             	incl   -0x10(%ebp)
  800127:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
  80012b:	0f 8e 74 ff ff ff    	jle    8000a5 <_main+0x6d>
			sys_run_env(ID);
			x = busy_wait(10000);
			ID = sys_create_env("tmlfq_2", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
			sys_run_env(ID);
		}
	x = busy_wait(1000000);
  800131:	83 ec 0c             	sub    $0xc,%esp
  800134:	68 40 42 0f 00       	push   $0xf4240
  800139:	e8 9d 16 00 00       	call   8017db <busy_wait>
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	89 45 e8             	mov    %eax,-0x18(%ebp)

}
  800144:	90                   	nop
  800145:	c9                   	leave  
  800146:	c3                   	ret    

00800147 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80014d:	e8 39 10 00 00       	call   80118b <sys_getenvindex>
  800152:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800155:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800158:	89 d0                	mov    %edx,%eax
  80015a:	c1 e0 03             	shl    $0x3,%eax
  80015d:	01 d0                	add    %edx,%eax
  80015f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800166:	01 c8                	add    %ecx,%eax
  800168:	01 c0                	add    %eax,%eax
  80016a:	01 d0                	add    %edx,%eax
  80016c:	01 c0                	add    %eax,%eax
  80016e:	01 d0                	add    %edx,%eax
  800170:	89 c2                	mov    %eax,%edx
  800172:	c1 e2 05             	shl    $0x5,%edx
  800175:	29 c2                	sub    %eax,%edx
  800177:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80017e:	89 c2                	mov    %eax,%edx
  800180:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800186:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80018b:	a1 20 20 80 00       	mov    0x802020,%eax
  800190:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800196:	84 c0                	test   %al,%al
  800198:	74 0f                	je     8001a9 <libmain+0x62>
		binaryname = myEnv->prog_name;
  80019a:	a1 20 20 80 00       	mov    0x802020,%eax
  80019f:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001a4:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ad:	7e 0a                	jle    8001b9 <libmain+0x72>
		binaryname = argv[0];
  8001af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b2:	8b 00                	mov    (%eax),%eax
  8001b4:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8001b9:	83 ec 08             	sub    $0x8,%esp
  8001bc:	ff 75 0c             	pushl  0xc(%ebp)
  8001bf:	ff 75 08             	pushl  0x8(%ebp)
  8001c2:	e8 71 fe ff ff       	call   800038 <_main>
  8001c7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001ca:	e8 57 11 00 00       	call   801326 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001cf:	83 ec 0c             	sub    $0xc,%esp
  8001d2:	68 80 1a 80 00       	push   $0x801a80
  8001d7:	e8 84 01 00 00       	call   800360 <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001df:	a1 20 20 80 00       	mov    0x802020,%eax
  8001e4:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8001ea:	a1 20 20 80 00       	mov    0x802020,%eax
  8001ef:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	52                   	push   %edx
  8001f9:	50                   	push   %eax
  8001fa:	68 a8 1a 80 00       	push   $0x801aa8
  8001ff:	e8 5c 01 00 00       	call   800360 <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800207:	a1 20 20 80 00       	mov    0x802020,%eax
  80020c:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800212:	a1 20 20 80 00       	mov    0x802020,%eax
  800217:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	68 d0 1a 80 00       	push   $0x801ad0
  800227:	e8 34 01 00 00       	call   800360 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80022f:	a1 20 20 80 00       	mov    0x802020,%eax
  800234:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80023a:	83 ec 08             	sub    $0x8,%esp
  80023d:	50                   	push   %eax
  80023e:	68 11 1b 80 00       	push   $0x801b11
  800243:	e8 18 01 00 00       	call   800360 <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 80 1a 80 00       	push   $0x801a80
  800253:	e8 08 01 00 00       	call   800360 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80025b:	e8 e0 10 00 00       	call   801340 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800260:	e8 19 00 00 00       	call   80027e <exit>
}
  800265:	90                   	nop
  800266:	c9                   	leave  
  800267:	c3                   	ret    

00800268 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80026e:	83 ec 0c             	sub    $0xc,%esp
  800271:	6a 00                	push   $0x0
  800273:	e8 df 0e 00 00       	call   801157 <sys_env_destroy>
  800278:	83 c4 10             	add    $0x10,%esp
}
  80027b:	90                   	nop
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <exit>:

void
exit(void)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800284:	e8 34 0f 00 00       	call   8011bd <sys_env_exit>
}
  800289:	90                   	nop
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800292:	8b 45 0c             	mov    0xc(%ebp),%eax
  800295:	8b 00                	mov    (%eax),%eax
  800297:	8d 48 01             	lea    0x1(%eax),%ecx
  80029a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029d:	89 0a                	mov    %ecx,(%edx)
  80029f:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a2:	88 d1                	mov    %dl,%cl
  8002a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b5:	75 2c                	jne    8002e3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002b7:	a0 24 20 80 00       	mov    0x802024,%al
  8002bc:	0f b6 c0             	movzbl %al,%eax
  8002bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c2:	8b 12                	mov    (%edx),%edx
  8002c4:	89 d1                	mov    %edx,%ecx
  8002c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c9:	83 c2 08             	add    $0x8,%edx
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	50                   	push   %eax
  8002d0:	51                   	push   %ecx
  8002d1:	52                   	push   %edx
  8002d2:	e8 3e 0e 00 00       	call   801115 <sys_cputs>
  8002d7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e6:	8b 40 04             	mov    0x4(%eax),%eax
  8002e9:	8d 50 01             	lea    0x1(%eax),%edx
  8002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ef:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002f2:	90                   	nop
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002fe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800305:	00 00 00 
	b.cnt = 0;
  800308:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80030f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800312:	ff 75 0c             	pushl  0xc(%ebp)
  800315:	ff 75 08             	pushl  0x8(%ebp)
  800318:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80031e:	50                   	push   %eax
  80031f:	68 8c 02 80 00       	push   $0x80028c
  800324:	e8 11 02 00 00       	call   80053a <vprintfmt>
  800329:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80032c:	a0 24 20 80 00       	mov    0x802024,%al
  800331:	0f b6 c0             	movzbl %al,%eax
  800334:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80033a:	83 ec 04             	sub    $0x4,%esp
  80033d:	50                   	push   %eax
  80033e:	52                   	push   %edx
  80033f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800345:	83 c0 08             	add    $0x8,%eax
  800348:	50                   	push   %eax
  800349:	e8 c7 0d 00 00       	call   801115 <sys_cputs>
  80034e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800351:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  800358:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80035e:	c9                   	leave  
  80035f:	c3                   	ret    

00800360 <cprintf>:

int cprintf(const char *fmt, ...) {
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800366:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  80036d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800370:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	ff 75 f4             	pushl  -0xc(%ebp)
  80037c:	50                   	push   %eax
  80037d:	e8 73 ff ff ff       	call   8002f5 <vcprintf>
  800382:	83 c4 10             	add    $0x10,%esp
  800385:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800388:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80038b:	c9                   	leave  
  80038c:	c3                   	ret    

0080038d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80038d:	55                   	push   %ebp
  80038e:	89 e5                	mov    %esp,%ebp
  800390:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800393:	e8 8e 0f 00 00       	call   801326 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800398:	8d 45 0c             	lea    0xc(%ebp),%eax
  80039b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	83 ec 08             	sub    $0x8,%esp
  8003a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a7:	50                   	push   %eax
  8003a8:	e8 48 ff ff ff       	call   8002f5 <vcprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
  8003b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003b3:	e8 88 0f 00 00       	call   801340 <sys_enable_interrupt>
	return cnt;
  8003b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003bb:	c9                   	leave  
  8003bc:	c3                   	ret    

008003bd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	53                   	push   %ebx
  8003c1:	83 ec 14             	sub    $0x14,%esp
  8003c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003db:	77 55                	ja     800432 <printnum+0x75>
  8003dd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003e0:	72 05                	jb     8003e7 <printnum+0x2a>
  8003e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003e5:	77 4b                	ja     800432 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003e7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003ea:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003ed:	8b 45 18             	mov    0x18(%ebp),%eax
  8003f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f5:	52                   	push   %edx
  8003f6:	50                   	push   %eax
  8003f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8003fd:	e8 fa 13 00 00       	call   8017fc <__udivdi3>
  800402:	83 c4 10             	add    $0x10,%esp
  800405:	83 ec 04             	sub    $0x4,%esp
  800408:	ff 75 20             	pushl  0x20(%ebp)
  80040b:	53                   	push   %ebx
  80040c:	ff 75 18             	pushl  0x18(%ebp)
  80040f:	52                   	push   %edx
  800410:	50                   	push   %eax
  800411:	ff 75 0c             	pushl  0xc(%ebp)
  800414:	ff 75 08             	pushl  0x8(%ebp)
  800417:	e8 a1 ff ff ff       	call   8003bd <printnum>
  80041c:	83 c4 20             	add    $0x20,%esp
  80041f:	eb 1a                	jmp    80043b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800421:	83 ec 08             	sub    $0x8,%esp
  800424:	ff 75 0c             	pushl  0xc(%ebp)
  800427:	ff 75 20             	pushl  0x20(%ebp)
  80042a:	8b 45 08             	mov    0x8(%ebp),%eax
  80042d:	ff d0                	call   *%eax
  80042f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800432:	ff 4d 1c             	decl   0x1c(%ebp)
  800435:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800439:	7f e6                	jg     800421 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80043b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80043e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800446:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800449:	53                   	push   %ebx
  80044a:	51                   	push   %ecx
  80044b:	52                   	push   %edx
  80044c:	50                   	push   %eax
  80044d:	e8 ba 14 00 00       	call   80190c <__umoddi3>
  800452:	83 c4 10             	add    $0x10,%esp
  800455:	05 54 1d 80 00       	add    $0x801d54,%eax
  80045a:	8a 00                	mov    (%eax),%al
  80045c:	0f be c0             	movsbl %al,%eax
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	ff 75 0c             	pushl  0xc(%ebp)
  800465:	50                   	push   %eax
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	ff d0                	call   *%eax
  80046b:	83 c4 10             	add    $0x10,%esp
}
  80046e:	90                   	nop
  80046f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800472:	c9                   	leave  
  800473:	c3                   	ret    

00800474 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800474:	55                   	push   %ebp
  800475:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800477:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80047b:	7e 1c                	jle    800499 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80047d:	8b 45 08             	mov    0x8(%ebp),%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	8d 50 08             	lea    0x8(%eax),%edx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	89 10                	mov    %edx,(%eax)
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	83 e8 08             	sub    $0x8,%eax
  800492:	8b 50 04             	mov    0x4(%eax),%edx
  800495:	8b 00                	mov    (%eax),%eax
  800497:	eb 40                	jmp    8004d9 <getuint+0x65>
	else if (lflag)
  800499:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80049d:	74 1e                	je     8004bd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	8d 50 04             	lea    0x4(%eax),%edx
  8004a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004aa:	89 10                	mov    %edx,(%eax)
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	83 e8 04             	sub    $0x4,%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004bb:	eb 1c                	jmp    8004d9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	8b 00                	mov    (%eax),%eax
  8004c2:	8d 50 04             	lea    0x4(%eax),%edx
  8004c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c8:	89 10                	mov    %edx,(%eax)
  8004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	83 e8 04             	sub    $0x4,%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004d9:	5d                   	pop    %ebp
  8004da:	c3                   	ret    

008004db <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004de:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004e2:	7e 1c                	jle    800500 <getint+0x25>
		return va_arg(*ap, long long);
  8004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e7:	8b 00                	mov    (%eax),%eax
  8004e9:	8d 50 08             	lea    0x8(%eax),%edx
  8004ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ef:	89 10                	mov    %edx,(%eax)
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	83 e8 08             	sub    $0x8,%eax
  8004f9:	8b 50 04             	mov    0x4(%eax),%edx
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	eb 38                	jmp    800538 <getint+0x5d>
	else if (lflag)
  800500:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800504:	74 1a                	je     800520 <getint+0x45>
		return va_arg(*ap, long);
  800506:	8b 45 08             	mov    0x8(%ebp),%eax
  800509:	8b 00                	mov    (%eax),%eax
  80050b:	8d 50 04             	lea    0x4(%eax),%edx
  80050e:	8b 45 08             	mov    0x8(%ebp),%eax
  800511:	89 10                	mov    %edx,(%eax)
  800513:	8b 45 08             	mov    0x8(%ebp),%eax
  800516:	8b 00                	mov    (%eax),%eax
  800518:	83 e8 04             	sub    $0x4,%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	99                   	cltd   
  80051e:	eb 18                	jmp    800538 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	8b 00                	mov    (%eax),%eax
  800525:	8d 50 04             	lea    0x4(%eax),%edx
  800528:	8b 45 08             	mov    0x8(%ebp),%eax
  80052b:	89 10                	mov    %edx,(%eax)
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	8b 00                	mov    (%eax),%eax
  800532:	83 e8 04             	sub    $0x4,%eax
  800535:	8b 00                	mov    (%eax),%eax
  800537:	99                   	cltd   
}
  800538:	5d                   	pop    %ebp
  800539:	c3                   	ret    

0080053a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80053a:	55                   	push   %ebp
  80053b:	89 e5                	mov    %esp,%ebp
  80053d:	56                   	push   %esi
  80053e:	53                   	push   %ebx
  80053f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800542:	eb 17                	jmp    80055b <vprintfmt+0x21>
			if (ch == '\0')
  800544:	85 db                	test   %ebx,%ebx
  800546:	0f 84 af 03 00 00    	je     8008fb <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	ff 75 0c             	pushl  0xc(%ebp)
  800552:	53                   	push   %ebx
  800553:	8b 45 08             	mov    0x8(%ebp),%eax
  800556:	ff d0                	call   *%eax
  800558:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055b:	8b 45 10             	mov    0x10(%ebp),%eax
  80055e:	8d 50 01             	lea    0x1(%eax),%edx
  800561:	89 55 10             	mov    %edx,0x10(%ebp)
  800564:	8a 00                	mov    (%eax),%al
  800566:	0f b6 d8             	movzbl %al,%ebx
  800569:	83 fb 25             	cmp    $0x25,%ebx
  80056c:	75 d6                	jne    800544 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80056e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800572:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800579:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800580:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800587:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80058e:	8b 45 10             	mov    0x10(%ebp),%eax
  800591:	8d 50 01             	lea    0x1(%eax),%edx
  800594:	89 55 10             	mov    %edx,0x10(%ebp)
  800597:	8a 00                	mov    (%eax),%al
  800599:	0f b6 d8             	movzbl %al,%ebx
  80059c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80059f:	83 f8 55             	cmp    $0x55,%eax
  8005a2:	0f 87 2b 03 00 00    	ja     8008d3 <vprintfmt+0x399>
  8005a8:	8b 04 85 78 1d 80 00 	mov    0x801d78(,%eax,4),%eax
  8005af:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005b1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005b5:	eb d7                	jmp    80058e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005b7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005bb:	eb d1                	jmp    80058e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c7:	89 d0                	mov    %edx,%eax
  8005c9:	c1 e0 02             	shl    $0x2,%eax
  8005cc:	01 d0                	add    %edx,%eax
  8005ce:	01 c0                	add    %eax,%eax
  8005d0:	01 d8                	add    %ebx,%eax
  8005d2:	83 e8 30             	sub    $0x30,%eax
  8005d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005db:	8a 00                	mov    (%eax),%al
  8005dd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005e0:	83 fb 2f             	cmp    $0x2f,%ebx
  8005e3:	7e 3e                	jle    800623 <vprintfmt+0xe9>
  8005e5:	83 fb 39             	cmp    $0x39,%ebx
  8005e8:	7f 39                	jg     800623 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ea:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005ed:	eb d5                	jmp    8005c4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	83 c0 04             	add    $0x4,%eax
  8005f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	83 e8 04             	sub    $0x4,%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800603:	eb 1f                	jmp    800624 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800605:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800609:	79 83                	jns    80058e <vprintfmt+0x54>
				width = 0;
  80060b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800612:	e9 77 ff ff ff       	jmp    80058e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800617:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80061e:	e9 6b ff ff ff       	jmp    80058e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800623:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800624:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800628:	0f 89 60 ff ff ff    	jns    80058e <vprintfmt+0x54>
				width = precision, precision = -1;
  80062e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800631:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800634:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80063b:	e9 4e ff ff ff       	jmp    80058e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800640:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800643:	e9 46 ff ff ff       	jmp    80058e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	83 c0 04             	add    $0x4,%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	83 e8 04             	sub    $0x4,%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	83 ec 08             	sub    $0x8,%esp
  80065c:	ff 75 0c             	pushl  0xc(%ebp)
  80065f:	50                   	push   %eax
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	ff d0                	call   *%eax
  800665:	83 c4 10             	add    $0x10,%esp
			break;
  800668:	e9 89 02 00 00       	jmp    8008f6 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	83 c0 04             	add    $0x4,%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	83 e8 04             	sub    $0x4,%eax
  80067c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80067e:	85 db                	test   %ebx,%ebx
  800680:	79 02                	jns    800684 <vprintfmt+0x14a>
				err = -err;
  800682:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800684:	83 fb 64             	cmp    $0x64,%ebx
  800687:	7f 0b                	jg     800694 <vprintfmt+0x15a>
  800689:	8b 34 9d c0 1b 80 00 	mov    0x801bc0(,%ebx,4),%esi
  800690:	85 f6                	test   %esi,%esi
  800692:	75 19                	jne    8006ad <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800694:	53                   	push   %ebx
  800695:	68 65 1d 80 00       	push   $0x801d65
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	ff 75 08             	pushl  0x8(%ebp)
  8006a0:	e8 5e 02 00 00       	call   800903 <printfmt>
  8006a5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006a8:	e9 49 02 00 00       	jmp    8008f6 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006ad:	56                   	push   %esi
  8006ae:	68 6e 1d 80 00       	push   $0x801d6e
  8006b3:	ff 75 0c             	pushl  0xc(%ebp)
  8006b6:	ff 75 08             	pushl  0x8(%ebp)
  8006b9:	e8 45 02 00 00       	call   800903 <printfmt>
  8006be:	83 c4 10             	add    $0x10,%esp
			break;
  8006c1:	e9 30 02 00 00       	jmp    8008f6 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	83 c0 04             	add    $0x4,%eax
  8006cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	83 e8 04             	sub    $0x4,%eax
  8006d5:	8b 30                	mov    (%eax),%esi
  8006d7:	85 f6                	test   %esi,%esi
  8006d9:	75 05                	jne    8006e0 <vprintfmt+0x1a6>
				p = "(null)";
  8006db:	be 71 1d 80 00       	mov    $0x801d71,%esi
			if (width > 0 && padc != '-')
  8006e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e4:	7e 6d                	jle    800753 <vprintfmt+0x219>
  8006e6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006ea:	74 67                	je     800753 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	50                   	push   %eax
  8006f3:	56                   	push   %esi
  8006f4:	e8 0c 03 00 00       	call   800a05 <strnlen>
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006ff:	eb 16                	jmp    800717 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800701:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	50                   	push   %eax
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	ff d0                	call   *%eax
  800711:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800714:	ff 4d e4             	decl   -0x1c(%ebp)
  800717:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071b:	7f e4                	jg     800701 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80071d:	eb 34                	jmp    800753 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80071f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800723:	74 1c                	je     800741 <vprintfmt+0x207>
  800725:	83 fb 1f             	cmp    $0x1f,%ebx
  800728:	7e 05                	jle    80072f <vprintfmt+0x1f5>
  80072a:	83 fb 7e             	cmp    $0x7e,%ebx
  80072d:	7e 12                	jle    800741 <vprintfmt+0x207>
					putch('?', putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	6a 3f                	push   $0x3f
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	eb 0f                	jmp    800750 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	ff 75 0c             	pushl  0xc(%ebp)
  800747:	53                   	push   %ebx
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	ff d0                	call   *%eax
  80074d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800750:	ff 4d e4             	decl   -0x1c(%ebp)
  800753:	89 f0                	mov    %esi,%eax
  800755:	8d 70 01             	lea    0x1(%eax),%esi
  800758:	8a 00                	mov    (%eax),%al
  80075a:	0f be d8             	movsbl %al,%ebx
  80075d:	85 db                	test   %ebx,%ebx
  80075f:	74 24                	je     800785 <vprintfmt+0x24b>
  800761:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800765:	78 b8                	js     80071f <vprintfmt+0x1e5>
  800767:	ff 4d e0             	decl   -0x20(%ebp)
  80076a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80076e:	79 af                	jns    80071f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800770:	eb 13                	jmp    800785 <vprintfmt+0x24b>
				putch(' ', putdat);
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	ff 75 0c             	pushl  0xc(%ebp)
  800778:	6a 20                	push   $0x20
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800782:	ff 4d e4             	decl   -0x1c(%ebp)
  800785:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800789:	7f e7                	jg     800772 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80078b:	e9 66 01 00 00       	jmp    8008f6 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	ff 75 e8             	pushl  -0x18(%ebp)
  800796:	8d 45 14             	lea    0x14(%ebp),%eax
  800799:	50                   	push   %eax
  80079a:	e8 3c fd ff ff       	call   8004db <getint>
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ae:	85 d2                	test   %edx,%edx
  8007b0:	79 23                	jns    8007d5 <vprintfmt+0x29b>
				putch('-', putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	6a 2d                	push   $0x2d
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	ff d0                	call   *%eax
  8007bf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c8:	f7 d8                	neg    %eax
  8007ca:	83 d2 00             	adc    $0x0,%edx
  8007cd:	f7 da                	neg    %edx
  8007cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007d5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007dc:	e9 bc 00 00 00       	jmp    80089d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	ff 75 e8             	pushl  -0x18(%ebp)
  8007e7:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ea:	50                   	push   %eax
  8007eb:	e8 84 fc ff ff       	call   800474 <getuint>
  8007f0:	83 c4 10             	add    $0x10,%esp
  8007f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007f9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800800:	e9 98 00 00 00       	jmp    80089d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	ff 75 0c             	pushl  0xc(%ebp)
  80080b:	6a 58                	push   $0x58
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	ff d0                	call   *%eax
  800812:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	ff 75 0c             	pushl  0xc(%ebp)
  80081b:	6a 58                	push   $0x58
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	ff d0                	call   *%eax
  800822:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	6a 58                	push   $0x58
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	ff d0                	call   *%eax
  800832:	83 c4 10             	add    $0x10,%esp
			break;
  800835:	e9 bc 00 00 00       	jmp    8008f6 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80083a:	83 ec 08             	sub    $0x8,%esp
  80083d:	ff 75 0c             	pushl  0xc(%ebp)
  800840:	6a 30                	push   $0x30
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	ff d0                	call   *%eax
  800847:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80084a:	83 ec 08             	sub    $0x8,%esp
  80084d:	ff 75 0c             	pushl  0xc(%ebp)
  800850:	6a 78                	push   $0x78
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	ff d0                	call   *%eax
  800857:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 c0 04             	add    $0x4,%eax
  800860:	89 45 14             	mov    %eax,0x14(%ebp)
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	83 e8 04             	sub    $0x4,%eax
  800869:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80086b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800875:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80087c:	eb 1f                	jmp    80089d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 e8             	pushl  -0x18(%ebp)
  800884:	8d 45 14             	lea    0x14(%ebp),%eax
  800887:	50                   	push   %eax
  800888:	e8 e7 fb ff ff       	call   800474 <getuint>
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800893:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800896:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80089d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a4:	83 ec 04             	sub    $0x4,%esp
  8008a7:	52                   	push   %edx
  8008a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8008af:	ff 75 f0             	pushl  -0x10(%ebp)
  8008b2:	ff 75 0c             	pushl  0xc(%ebp)
  8008b5:	ff 75 08             	pushl  0x8(%ebp)
  8008b8:	e8 00 fb ff ff       	call   8003bd <printnum>
  8008bd:	83 c4 20             	add    $0x20,%esp
			break;
  8008c0:	eb 34                	jmp    8008f6 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	53                   	push   %ebx
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	ff d0                	call   *%eax
  8008ce:	83 c4 10             	add    $0x10,%esp
			break;
  8008d1:	eb 23                	jmp    8008f6 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	6a 25                	push   $0x25
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	ff d0                	call   *%eax
  8008e0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008e3:	ff 4d 10             	decl   0x10(%ebp)
  8008e6:	eb 03                	jmp    8008eb <vprintfmt+0x3b1>
  8008e8:	ff 4d 10             	decl   0x10(%ebp)
  8008eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ee:	48                   	dec    %eax
  8008ef:	8a 00                	mov    (%eax),%al
  8008f1:	3c 25                	cmp    $0x25,%al
  8008f3:	75 f3                	jne    8008e8 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008f5:	90                   	nop
		}
	}
  8008f6:	e9 47 fc ff ff       	jmp    800542 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008fb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008ff:	5b                   	pop    %ebx
  800900:	5e                   	pop    %esi
  800901:	5d                   	pop    %ebp
  800902:	c3                   	ret    

00800903 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800909:	8d 45 10             	lea    0x10(%ebp),%eax
  80090c:	83 c0 04             	add    $0x4,%eax
  80090f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800912:	8b 45 10             	mov    0x10(%ebp),%eax
  800915:	ff 75 f4             	pushl  -0xc(%ebp)
  800918:	50                   	push   %eax
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	ff 75 08             	pushl  0x8(%ebp)
  80091f:	e8 16 fc ff ff       	call   80053a <vprintfmt>
  800924:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800927:	90                   	nop
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80092d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800930:	8b 40 08             	mov    0x8(%eax),%eax
  800933:	8d 50 01             	lea    0x1(%eax),%edx
  800936:	8b 45 0c             	mov    0xc(%ebp),%eax
  800939:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80093c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093f:	8b 10                	mov    (%eax),%edx
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	8b 40 04             	mov    0x4(%eax),%eax
  800947:	39 c2                	cmp    %eax,%edx
  800949:	73 12                	jae    80095d <sprintputch+0x33>
		*b->buf++ = ch;
  80094b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	8d 48 01             	lea    0x1(%eax),%ecx
  800953:	8b 55 0c             	mov    0xc(%ebp),%edx
  800956:	89 0a                	mov    %ecx,(%edx)
  800958:	8b 55 08             	mov    0x8(%ebp),%edx
  80095b:	88 10                	mov    %dl,(%eax)
}
  80095d:	90                   	nop
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    

00800960 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80096c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	01 d0                	add    %edx,%eax
  800977:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800981:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800985:	74 06                	je     80098d <vsnprintf+0x2d>
  800987:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80098b:	7f 07                	jg     800994 <vsnprintf+0x34>
		return -E_INVAL;
  80098d:	b8 03 00 00 00       	mov    $0x3,%eax
  800992:	eb 20                	jmp    8009b4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800994:	ff 75 14             	pushl  0x14(%ebp)
  800997:	ff 75 10             	pushl  0x10(%ebp)
  80099a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80099d:	50                   	push   %eax
  80099e:	68 2a 09 80 00       	push   $0x80092a
  8009a3:	e8 92 fb ff ff       	call   80053a <vprintfmt>
  8009a8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ae:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009b4:	c9                   	leave  
  8009b5:	c3                   	ret    

008009b6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009bc:	8d 45 10             	lea    0x10(%ebp),%eax
  8009bf:	83 c0 04             	add    $0x4,%eax
  8009c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8009cb:	50                   	push   %eax
  8009cc:	ff 75 0c             	pushl  0xc(%ebp)
  8009cf:	ff 75 08             	pushl  0x8(%ebp)
  8009d2:	e8 89 ff ff ff       	call   800960 <vsnprintf>
  8009d7:	83 c4 10             	add    $0x10,%esp
  8009da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009e0:	c9                   	leave  
  8009e1:	c3                   	ret    

008009e2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009ef:	eb 06                	jmp    8009f7 <strlen+0x15>
		n++;
  8009f1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f4:	ff 45 08             	incl   0x8(%ebp)
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	8a 00                	mov    (%eax),%al
  8009fc:	84 c0                	test   %al,%al
  8009fe:	75 f1                	jne    8009f1 <strlen+0xf>
		n++;
	return n;
  800a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a03:	c9                   	leave  
  800a04:	c3                   	ret    

00800a05 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a12:	eb 09                	jmp    800a1d <strnlen+0x18>
		n++;
  800a14:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a17:	ff 45 08             	incl   0x8(%ebp)
  800a1a:	ff 4d 0c             	decl   0xc(%ebp)
  800a1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a21:	74 09                	je     800a2c <strnlen+0x27>
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	8a 00                	mov    (%eax),%al
  800a28:	84 c0                	test   %al,%al
  800a2a:	75 e8                	jne    800a14 <strnlen+0xf>
		n++;
	return n;
  800a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a2f:	c9                   	leave  
  800a30:	c3                   	ret    

00800a31 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a3d:	90                   	nop
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8d 50 01             	lea    0x1(%eax),%edx
  800a44:	89 55 08             	mov    %edx,0x8(%ebp)
  800a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a4d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a50:	8a 12                	mov    (%edx),%dl
  800a52:	88 10                	mov    %dl,(%eax)
  800a54:	8a 00                	mov    (%eax),%al
  800a56:	84 c0                	test   %al,%al
  800a58:	75 e4                	jne    800a3e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a5d:	c9                   	leave  
  800a5e:	c3                   	ret    

00800a5f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a72:	eb 1f                	jmp    800a93 <strncpy+0x34>
		*dst++ = *src;
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	8d 50 01             	lea    0x1(%eax),%edx
  800a7a:	89 55 08             	mov    %edx,0x8(%ebp)
  800a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a80:	8a 12                	mov    (%edx),%dl
  800a82:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a87:	8a 00                	mov    (%eax),%al
  800a89:	84 c0                	test   %al,%al
  800a8b:	74 03                	je     800a90 <strncpy+0x31>
			src++;
  800a8d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a90:	ff 45 fc             	incl   -0x4(%ebp)
  800a93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a96:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a99:	72 d9                	jb     800a74 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a9e:	c9                   	leave  
  800a9f:	c3                   	ret    

00800aa0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800aac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab0:	74 30                	je     800ae2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ab2:	eb 16                	jmp    800aca <strlcpy+0x2a>
			*dst++ = *src++;
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	8d 50 01             	lea    0x1(%eax),%edx
  800aba:	89 55 08             	mov    %edx,0x8(%ebp)
  800abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ac3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ac6:	8a 12                	mov    (%edx),%dl
  800ac8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aca:	ff 4d 10             	decl   0x10(%ebp)
  800acd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ad1:	74 09                	je     800adc <strlcpy+0x3c>
  800ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad6:	8a 00                	mov    (%eax),%al
  800ad8:	84 c0                	test   %al,%al
  800ada:	75 d8                	jne    800ab4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ae8:	29 c2                	sub    %eax,%edx
  800aea:	89 d0                	mov    %edx,%eax
}
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800af1:	eb 06                	jmp    800af9 <strcmp+0xb>
		p++, q++;
  800af3:	ff 45 08             	incl   0x8(%ebp)
  800af6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8a 00                	mov    (%eax),%al
  800afe:	84 c0                	test   %al,%al
  800b00:	74 0e                	je     800b10 <strcmp+0x22>
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	8a 10                	mov    (%eax),%dl
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	8a 00                	mov    (%eax),%al
  800b0c:	38 c2                	cmp    %al,%dl
  800b0e:	74 e3                	je     800af3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	8a 00                	mov    (%eax),%al
  800b15:	0f b6 d0             	movzbl %al,%edx
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	8a 00                	mov    (%eax),%al
  800b1d:	0f b6 c0             	movzbl %al,%eax
  800b20:	29 c2                	sub    %eax,%edx
  800b22:	89 d0                	mov    %edx,%eax
}
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b29:	eb 09                	jmp    800b34 <strncmp+0xe>
		n--, p++, q++;
  800b2b:	ff 4d 10             	decl   0x10(%ebp)
  800b2e:	ff 45 08             	incl   0x8(%ebp)
  800b31:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b38:	74 17                	je     800b51 <strncmp+0x2b>
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	8a 00                	mov    (%eax),%al
  800b3f:	84 c0                	test   %al,%al
  800b41:	74 0e                	je     800b51 <strncmp+0x2b>
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	8a 10                	mov    (%eax),%dl
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	8a 00                	mov    (%eax),%al
  800b4d:	38 c2                	cmp    %al,%dl
  800b4f:	74 da                	je     800b2b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b55:	75 07                	jne    800b5e <strncmp+0x38>
		return 0;
  800b57:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5c:	eb 14                	jmp    800b72 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8a 00                	mov    (%eax),%al
  800b63:	0f b6 d0             	movzbl %al,%edx
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	0f b6 c0             	movzbl %al,%eax
  800b6e:	29 c2                	sub    %eax,%edx
  800b70:	89 d0                	mov    %edx,%eax
}
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 04             	sub    $0x4,%esp
  800b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b80:	eb 12                	jmp    800b94 <strchr+0x20>
		if (*s == c)
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b8a:	75 05                	jne    800b91 <strchr+0x1d>
			return (char *) s;
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	eb 11                	jmp    800ba2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b91:	ff 45 08             	incl   0x8(%ebp)
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	8a 00                	mov    (%eax),%al
  800b99:	84 c0                	test   %al,%al
  800b9b:	75 e5                	jne    800b82 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	83 ec 04             	sub    $0x4,%esp
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bb0:	eb 0d                	jmp    800bbf <strfind+0x1b>
		if (*s == c)
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	8a 00                	mov    (%eax),%al
  800bb7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bba:	74 0e                	je     800bca <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bbc:	ff 45 08             	incl   0x8(%ebp)
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	8a 00                	mov    (%eax),%al
  800bc4:	84 c0                	test   %al,%al
  800bc6:	75 ea                	jne    800bb2 <strfind+0xe>
  800bc8:	eb 01                	jmp    800bcb <strfind+0x27>
		if (*s == c)
			break;
  800bca:	90                   	nop
	return (char *) s;
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800be2:	eb 0e                	jmp    800bf2 <memset+0x22>
		*p++ = c;
  800be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be7:	8d 50 01             	lea    0x1(%eax),%edx
  800bea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bf2:	ff 4d f8             	decl   -0x8(%ebp)
  800bf5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bf9:	79 e9                	jns    800be4 <memset+0x14>
		*p++ = c;

	return v;
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bfe:	c9                   	leave  
  800bff:	c3                   	ret    

00800c00 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c12:	eb 16                	jmp    800c2a <memcpy+0x2a>
		*d++ = *s++;
  800c14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c23:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c26:	8a 12                	mov    (%edx),%dl
  800c28:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c30:	89 55 10             	mov    %edx,0x10(%ebp)
  800c33:	85 c0                	test   %eax,%eax
  800c35:	75 dd                	jne    800c14 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c3a:	c9                   	leave  
  800c3b:	c3                   	ret    

00800c3c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c51:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c54:	73 50                	jae    800ca6 <memmove+0x6a>
  800c56:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c59:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5c:	01 d0                	add    %edx,%eax
  800c5e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c61:	76 43                	jbe    800ca6 <memmove+0x6a>
		s += n;
  800c63:	8b 45 10             	mov    0x10(%ebp),%eax
  800c66:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c69:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c6f:	eb 10                	jmp    800c81 <memmove+0x45>
			*--d = *--s;
  800c71:	ff 4d f8             	decl   -0x8(%ebp)
  800c74:	ff 4d fc             	decl   -0x4(%ebp)
  800c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7a:	8a 10                	mov    (%eax),%dl
  800c7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c81:	8b 45 10             	mov    0x10(%ebp),%eax
  800c84:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c87:	89 55 10             	mov    %edx,0x10(%ebp)
  800c8a:	85 c0                	test   %eax,%eax
  800c8c:	75 e3                	jne    800c71 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c8e:	eb 23                	jmp    800cb3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c93:	8d 50 01             	lea    0x1(%eax),%edx
  800c96:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c9f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ca2:	8a 12                	mov    (%edx),%dl
  800ca4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ca6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cac:	89 55 10             	mov    %edx,0x10(%ebp)
  800caf:	85 c0                	test   %eax,%eax
  800cb1:	75 dd                	jne    800c90 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    

00800cb8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cca:	eb 2a                	jmp    800cf6 <memcmp+0x3e>
		if (*s1 != *s2)
  800ccc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccf:	8a 10                	mov    (%eax),%dl
  800cd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	38 c2                	cmp    %al,%dl
  800cd8:	74 16                	je     800cf0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	0f b6 d0             	movzbl %al,%edx
  800ce2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	0f b6 c0             	movzbl %al,%eax
  800cea:	29 c2                	sub    %eax,%edx
  800cec:	89 d0                	mov    %edx,%eax
  800cee:	eb 18                	jmp    800d08 <memcmp+0x50>
		s1++, s2++;
  800cf0:	ff 45 fc             	incl   -0x4(%ebp)
  800cf3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cfc:	89 55 10             	mov    %edx,0x10(%ebp)
  800cff:	85 c0                	test   %eax,%eax
  800d01:	75 c9                	jne    800ccc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d08:	c9                   	leave  
  800d09:	c3                   	ret    

00800d0a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d10:	8b 55 08             	mov    0x8(%ebp),%edx
  800d13:	8b 45 10             	mov    0x10(%ebp),%eax
  800d16:	01 d0                	add    %edx,%eax
  800d18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d1b:	eb 15                	jmp    800d32 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	0f b6 d0             	movzbl %al,%edx
  800d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d28:	0f b6 c0             	movzbl %al,%eax
  800d2b:	39 c2                	cmp    %eax,%edx
  800d2d:	74 0d                	je     800d3c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d2f:	ff 45 08             	incl   0x8(%ebp)
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d38:	72 e3                	jb     800d1d <memfind+0x13>
  800d3a:	eb 01                	jmp    800d3d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d3c:	90                   	nop
	return (void *) s;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d40:	c9                   	leave  
  800d41:	c3                   	ret    

00800d42 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d4f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d56:	eb 03                	jmp    800d5b <strtol+0x19>
		s++;
  800d58:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	3c 20                	cmp    $0x20,%al
  800d62:	74 f4                	je     800d58 <strtol+0x16>
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	3c 09                	cmp    $0x9,%al
  800d6b:	74 eb                	je     800d58 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	3c 2b                	cmp    $0x2b,%al
  800d74:	75 05                	jne    800d7b <strtol+0x39>
		s++;
  800d76:	ff 45 08             	incl   0x8(%ebp)
  800d79:	eb 13                	jmp    800d8e <strtol+0x4c>
	else if (*s == '-')
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8a 00                	mov    (%eax),%al
  800d80:	3c 2d                	cmp    $0x2d,%al
  800d82:	75 0a                	jne    800d8e <strtol+0x4c>
		s++, neg = 1;
  800d84:	ff 45 08             	incl   0x8(%ebp)
  800d87:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d92:	74 06                	je     800d9a <strtol+0x58>
  800d94:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d98:	75 20                	jne    800dba <strtol+0x78>
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	3c 30                	cmp    $0x30,%al
  800da1:	75 17                	jne    800dba <strtol+0x78>
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	40                   	inc    %eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	3c 78                	cmp    $0x78,%al
  800dab:	75 0d                	jne    800dba <strtol+0x78>
		s += 2, base = 16;
  800dad:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800db1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800db8:	eb 28                	jmp    800de2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbe:	75 15                	jne    800dd5 <strtol+0x93>
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	3c 30                	cmp    $0x30,%al
  800dc7:	75 0c                	jne    800dd5 <strtol+0x93>
		s++, base = 8;
  800dc9:	ff 45 08             	incl   0x8(%ebp)
  800dcc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dd3:	eb 0d                	jmp    800de2 <strtol+0xa0>
	else if (base == 0)
  800dd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd9:	75 07                	jne    800de2 <strtol+0xa0>
		base = 10;
  800ddb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	3c 2f                	cmp    $0x2f,%al
  800de9:	7e 19                	jle    800e04 <strtol+0xc2>
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	3c 39                	cmp    $0x39,%al
  800df2:	7f 10                	jg     800e04 <strtol+0xc2>
			dig = *s - '0';
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f be c0             	movsbl %al,%eax
  800dfc:	83 e8 30             	sub    $0x30,%eax
  800dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e02:	eb 42                	jmp    800e46 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	3c 60                	cmp    $0x60,%al
  800e0b:	7e 19                	jle    800e26 <strtol+0xe4>
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	3c 7a                	cmp    $0x7a,%al
  800e14:	7f 10                	jg     800e26 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8a 00                	mov    (%eax),%al
  800e1b:	0f be c0             	movsbl %al,%eax
  800e1e:	83 e8 57             	sub    $0x57,%eax
  800e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e24:	eb 20                	jmp    800e46 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8a 00                	mov    (%eax),%al
  800e2b:	3c 40                	cmp    $0x40,%al
  800e2d:	7e 39                	jle    800e68 <strtol+0x126>
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	8a 00                	mov    (%eax),%al
  800e34:	3c 5a                	cmp    $0x5a,%al
  800e36:	7f 30                	jg     800e68 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f be c0             	movsbl %al,%eax
  800e40:	83 e8 37             	sub    $0x37,%eax
  800e43:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e49:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e4c:	7d 19                	jge    800e67 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e4e:	ff 45 08             	incl   0x8(%ebp)
  800e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e54:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e58:	89 c2                	mov    %eax,%edx
  800e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e5d:	01 d0                	add    %edx,%eax
  800e5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e62:	e9 7b ff ff ff       	jmp    800de2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e67:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6c:	74 08                	je     800e76 <strtol+0x134>
		*endptr = (char *) s;
  800e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e71:	8b 55 08             	mov    0x8(%ebp),%edx
  800e74:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e76:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e7a:	74 07                	je     800e83 <strtol+0x141>
  800e7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7f:	f7 d8                	neg    %eax
  800e81:	eb 03                	jmp    800e86 <strtol+0x144>
  800e83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <ltostr>:

void
ltostr(long value, char *str)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e95:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ea0:	79 13                	jns    800eb5 <ltostr+0x2d>
	{
		neg = 1;
  800ea2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eaf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800eb2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ebd:	99                   	cltd   
  800ebe:	f7 f9                	idiv   %ecx
  800ec0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ec3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec6:	8d 50 01             	lea    0x1(%eax),%edx
  800ec9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ecc:	89 c2                	mov    %eax,%edx
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	01 d0                	add    %edx,%eax
  800ed3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ed6:	83 c2 30             	add    $0x30,%edx
  800ed9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800edb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ede:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ee3:	f7 e9                	imul   %ecx
  800ee5:	c1 fa 02             	sar    $0x2,%edx
  800ee8:	89 c8                	mov    %ecx,%eax
  800eea:	c1 f8 1f             	sar    $0x1f,%eax
  800eed:	29 c2                	sub    %eax,%edx
  800eef:	89 d0                	mov    %edx,%eax
  800ef1:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800ef4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800efc:	f7 e9                	imul   %ecx
  800efe:	c1 fa 02             	sar    $0x2,%edx
  800f01:	89 c8                	mov    %ecx,%eax
  800f03:	c1 f8 1f             	sar    $0x1f,%eax
  800f06:	29 c2                	sub    %eax,%edx
  800f08:	89 d0                	mov    %edx,%eax
  800f0a:	c1 e0 02             	shl    $0x2,%eax
  800f0d:	01 d0                	add    %edx,%eax
  800f0f:	01 c0                	add    %eax,%eax
  800f11:	29 c1                	sub    %eax,%ecx
  800f13:	89 ca                	mov    %ecx,%edx
  800f15:	85 d2                	test   %edx,%edx
  800f17:	75 9c                	jne    800eb5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f23:	48                   	dec    %eax
  800f24:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f27:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f2b:	74 3d                	je     800f6a <ltostr+0xe2>
		start = 1 ;
  800f2d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f34:	eb 34                	jmp    800f6a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3c:	01 d0                	add    %edx,%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	01 c2                	add    %eax,%edx
  800f4b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	01 c8                	add    %ecx,%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5d:	01 c2                	add    %eax,%edx
  800f5f:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f62:	88 02                	mov    %al,(%edx)
		start++ ;
  800f64:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f67:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f70:	7c c4                	jl     800f36 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f72:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	01 d0                	add    %edx,%eax
  800f7a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f7d:	90                   	nop
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f86:	ff 75 08             	pushl  0x8(%ebp)
  800f89:	e8 54 fa ff ff       	call   8009e2 <strlen>
  800f8e:	83 c4 04             	add    $0x4,%esp
  800f91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f94:	ff 75 0c             	pushl  0xc(%ebp)
  800f97:	e8 46 fa ff ff       	call   8009e2 <strlen>
  800f9c:	83 c4 04             	add    $0x4,%esp
  800f9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fa2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fa9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fb0:	eb 17                	jmp    800fc9 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb8:	01 c2                	add    %eax,%edx
  800fba:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	01 c8                	add    %ecx,%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fc6:	ff 45 fc             	incl   -0x4(%ebp)
  800fc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fcf:	7c e1                	jl     800fb2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fd1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fd8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fdf:	eb 1f                	jmp    801000 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fe1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe4:	8d 50 01             	lea    0x1(%eax),%edx
  800fe7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fea:	89 c2                	mov    %eax,%edx
  800fec:	8b 45 10             	mov    0x10(%ebp),%eax
  800fef:	01 c2                	add    %eax,%edx
  800ff1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff7:	01 c8                	add    %ecx,%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800ffd:	ff 45 f8             	incl   -0x8(%ebp)
  801000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801003:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801006:	7c d9                	jl     800fe1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801008:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100b:	8b 45 10             	mov    0x10(%ebp),%eax
  80100e:	01 d0                	add    %edx,%eax
  801010:	c6 00 00             	movb   $0x0,(%eax)
}
  801013:	90                   	nop
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801019:	8b 45 14             	mov    0x14(%ebp),%eax
  80101c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801022:	8b 45 14             	mov    0x14(%ebp),%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80102e:	8b 45 10             	mov    0x10(%ebp),%eax
  801031:	01 d0                	add    %edx,%eax
  801033:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801039:	eb 0c                	jmp    801047 <strsplit+0x31>
			*string++ = 0;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8d 50 01             	lea    0x1(%eax),%edx
  801041:	89 55 08             	mov    %edx,0x8(%ebp)
  801044:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	8a 00                	mov    (%eax),%al
  80104c:	84 c0                	test   %al,%al
  80104e:	74 18                	je     801068 <strsplit+0x52>
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	0f be c0             	movsbl %al,%eax
  801058:	50                   	push   %eax
  801059:	ff 75 0c             	pushl  0xc(%ebp)
  80105c:	e8 13 fb ff ff       	call   800b74 <strchr>
  801061:	83 c4 08             	add    $0x8,%esp
  801064:	85 c0                	test   %eax,%eax
  801066:	75 d3                	jne    80103b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	8a 00                	mov    (%eax),%al
  80106d:	84 c0                	test   %al,%al
  80106f:	74 5a                	je     8010cb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801071:	8b 45 14             	mov    0x14(%ebp),%eax
  801074:	8b 00                	mov    (%eax),%eax
  801076:	83 f8 0f             	cmp    $0xf,%eax
  801079:	75 07                	jne    801082 <strsplit+0x6c>
		{
			return 0;
  80107b:	b8 00 00 00 00       	mov    $0x0,%eax
  801080:	eb 66                	jmp    8010e8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801082:	8b 45 14             	mov    0x14(%ebp),%eax
  801085:	8b 00                	mov    (%eax),%eax
  801087:	8d 48 01             	lea    0x1(%eax),%ecx
  80108a:	8b 55 14             	mov    0x14(%ebp),%edx
  80108d:	89 0a                	mov    %ecx,(%edx)
  80108f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801096:	8b 45 10             	mov    0x10(%ebp),%eax
  801099:	01 c2                	add    %eax,%edx
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010a0:	eb 03                	jmp    8010a5 <strsplit+0x8f>
			string++;
  8010a2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8a 00                	mov    (%eax),%al
  8010aa:	84 c0                	test   %al,%al
  8010ac:	74 8b                	je     801039 <strsplit+0x23>
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	0f be c0             	movsbl %al,%eax
  8010b6:	50                   	push   %eax
  8010b7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ba:	e8 b5 fa ff ff       	call   800b74 <strchr>
  8010bf:	83 c4 08             	add    $0x8,%esp
  8010c2:	85 c0                	test   %eax,%eax
  8010c4:	74 dc                	je     8010a2 <strsplit+0x8c>
			string++;
	}
  8010c6:	e9 6e ff ff ff       	jmp    801039 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010cb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010db:	01 d0                	add    %edx,%eax
  8010dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010e8:	c9                   	leave  
  8010e9:	c3                   	ret    

008010ea <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	57                   	push   %edi
  8010ee:	56                   	push   %esi
  8010ef:	53                   	push   %ebx
  8010f0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010ff:	8b 7d 18             	mov    0x18(%ebp),%edi
  801102:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801105:	cd 30                	int    $0x30
  801107:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80110a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80110d:	83 c4 10             	add    $0x10,%esp
  801110:	5b                   	pop    %ebx
  801111:	5e                   	pop    %esi
  801112:	5f                   	pop    %edi
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 04             	sub    $0x4,%esp
  80111b:	8b 45 10             	mov    0x10(%ebp),%eax
  80111e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801121:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	6a 00                	push   $0x0
  80112a:	6a 00                	push   $0x0
  80112c:	52                   	push   %edx
  80112d:	ff 75 0c             	pushl  0xc(%ebp)
  801130:	50                   	push   %eax
  801131:	6a 00                	push   $0x0
  801133:	e8 b2 ff ff ff       	call   8010ea <syscall>
  801138:	83 c4 18             	add    $0x18,%esp
}
  80113b:	90                   	nop
  80113c:	c9                   	leave  
  80113d:	c3                   	ret    

0080113e <sys_cgetc>:

int
sys_cgetc(void)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801141:	6a 00                	push   $0x0
  801143:	6a 00                	push   $0x0
  801145:	6a 00                	push   $0x0
  801147:	6a 00                	push   $0x0
  801149:	6a 00                	push   $0x0
  80114b:	6a 01                	push   $0x1
  80114d:	e8 98 ff ff ff       	call   8010ea <syscall>
  801152:	83 c4 18             	add    $0x18,%esp
}
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	6a 00                	push   $0x0
  80115f:	6a 00                	push   $0x0
  801161:	6a 00                	push   $0x0
  801163:	6a 00                	push   $0x0
  801165:	50                   	push   %eax
  801166:	6a 05                	push   $0x5
  801168:	e8 7d ff ff ff       	call   8010ea <syscall>
  80116d:	83 c4 18             	add    $0x18,%esp
}
  801170:	c9                   	leave  
  801171:	c3                   	ret    

00801172 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801175:	6a 00                	push   $0x0
  801177:	6a 00                	push   $0x0
  801179:	6a 00                	push   $0x0
  80117b:	6a 00                	push   $0x0
  80117d:	6a 00                	push   $0x0
  80117f:	6a 02                	push   $0x2
  801181:	e8 64 ff ff ff       	call   8010ea <syscall>
  801186:	83 c4 18             	add    $0x18,%esp
}
  801189:	c9                   	leave  
  80118a:	c3                   	ret    

0080118b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80118e:	6a 00                	push   $0x0
  801190:	6a 00                	push   $0x0
  801192:	6a 00                	push   $0x0
  801194:	6a 00                	push   $0x0
  801196:	6a 00                	push   $0x0
  801198:	6a 03                	push   $0x3
  80119a:	e8 4b ff ff ff       	call   8010ea <syscall>
  80119f:	83 c4 18             	add    $0x18,%esp
}
  8011a2:	c9                   	leave  
  8011a3:	c3                   	ret    

008011a4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8011a7:	6a 00                	push   $0x0
  8011a9:	6a 00                	push   $0x0
  8011ab:	6a 00                	push   $0x0
  8011ad:	6a 00                	push   $0x0
  8011af:	6a 00                	push   $0x0
  8011b1:	6a 04                	push   $0x4
  8011b3:	e8 32 ff ff ff       	call   8010ea <syscall>
  8011b8:	83 c4 18             	add    $0x18,%esp
}
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <sys_env_exit>:


void sys_env_exit(void)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8011c0:	6a 00                	push   $0x0
  8011c2:	6a 00                	push   $0x0
  8011c4:	6a 00                	push   $0x0
  8011c6:	6a 00                	push   $0x0
  8011c8:	6a 00                	push   $0x0
  8011ca:	6a 06                	push   $0x6
  8011cc:	e8 19 ff ff ff       	call   8010ea <syscall>
  8011d1:	83 c4 18             	add    $0x18,%esp
}
  8011d4:	90                   	nop
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8011da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	6a 00                	push   $0x0
  8011e2:	6a 00                	push   $0x0
  8011e4:	6a 00                	push   $0x0
  8011e6:	52                   	push   %edx
  8011e7:	50                   	push   %eax
  8011e8:	6a 07                	push   $0x7
  8011ea:	e8 fb fe ff ff       	call   8010ea <syscall>
  8011ef:	83 c4 18             	add    $0x18,%esp
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	56                   	push   %esi
  8011f8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8011f9:	8b 75 18             	mov    0x18(%ebp),%esi
  8011fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801202:	8b 55 0c             	mov    0xc(%ebp),%edx
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	56                   	push   %esi
  801209:	53                   	push   %ebx
  80120a:	51                   	push   %ecx
  80120b:	52                   	push   %edx
  80120c:	50                   	push   %eax
  80120d:	6a 08                	push   $0x8
  80120f:	e8 d6 fe ff ff       	call   8010ea <syscall>
  801214:	83 c4 18             	add    $0x18,%esp
}
  801217:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80121a:	5b                   	pop    %ebx
  80121b:	5e                   	pop    %esi
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    

0080121e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801221:	8b 55 0c             	mov    0xc(%ebp),%edx
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	6a 00                	push   $0x0
  801229:	6a 00                	push   $0x0
  80122b:	6a 00                	push   $0x0
  80122d:	52                   	push   %edx
  80122e:	50                   	push   %eax
  80122f:	6a 09                	push   $0x9
  801231:	e8 b4 fe ff ff       	call   8010ea <syscall>
  801236:	83 c4 18             	add    $0x18,%esp
}
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80123e:	6a 00                	push   $0x0
  801240:	6a 00                	push   $0x0
  801242:	6a 00                	push   $0x0
  801244:	ff 75 0c             	pushl  0xc(%ebp)
  801247:	ff 75 08             	pushl  0x8(%ebp)
  80124a:	6a 0a                	push   $0xa
  80124c:	e8 99 fe ff ff       	call   8010ea <syscall>
  801251:	83 c4 18             	add    $0x18,%esp
}
  801254:	c9                   	leave  
  801255:	c3                   	ret    

00801256 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801259:	6a 00                	push   $0x0
  80125b:	6a 00                	push   $0x0
  80125d:	6a 00                	push   $0x0
  80125f:	6a 00                	push   $0x0
  801261:	6a 00                	push   $0x0
  801263:	6a 0b                	push   $0xb
  801265:	e8 80 fe ff ff       	call   8010ea <syscall>
  80126a:	83 c4 18             	add    $0x18,%esp
}
  80126d:	c9                   	leave  
  80126e:	c3                   	ret    

0080126f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801272:	6a 00                	push   $0x0
  801274:	6a 00                	push   $0x0
  801276:	6a 00                	push   $0x0
  801278:	6a 00                	push   $0x0
  80127a:	6a 00                	push   $0x0
  80127c:	6a 0c                	push   $0xc
  80127e:	e8 67 fe ff ff       	call   8010ea <syscall>
  801283:	83 c4 18             	add    $0x18,%esp
}
  801286:	c9                   	leave  
  801287:	c3                   	ret    

00801288 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 0d                	push   $0xd
  801297:	e8 4e fe ff ff       	call   8010ea <syscall>
  80129c:	83 c4 18             	add    $0x18,%esp
}
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    

008012a1 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	ff 75 0c             	pushl  0xc(%ebp)
  8012ad:	ff 75 08             	pushl  0x8(%ebp)
  8012b0:	6a 11                	push   $0x11
  8012b2:	e8 33 fe ff ff       	call   8010ea <syscall>
  8012b7:	83 c4 18             	add    $0x18,%esp
	return;
  8012ba:	90                   	nop
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	ff 75 0c             	pushl  0xc(%ebp)
  8012c9:	ff 75 08             	pushl  0x8(%ebp)
  8012cc:	6a 12                	push   $0x12
  8012ce:	e8 17 fe ff ff       	call   8010ea <syscall>
  8012d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8012d6:	90                   	nop
}
  8012d7:	c9                   	leave  
  8012d8:	c3                   	ret    

008012d9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 00                	push   $0x0
  8012e6:	6a 0e                	push   $0xe
  8012e8:	e8 fd fd ff ff       	call   8010ea <syscall>
  8012ed:	83 c4 18             	add    $0x18,%esp
}
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	ff 75 08             	pushl  0x8(%ebp)
  801300:	6a 0f                	push   $0xf
  801302:	e8 e3 fd ff ff       	call   8010ea <syscall>
  801307:	83 c4 18             	add    $0x18,%esp
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80130f:	6a 00                	push   $0x0
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	6a 10                	push   $0x10
  80131b:	e8 ca fd ff ff       	call   8010ea <syscall>
  801320:	83 c4 18             	add    $0x18,%esp
}
  801323:	90                   	nop
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 14                	push   $0x14
  801335:	e8 b0 fd ff ff       	call   8010ea <syscall>
  80133a:	83 c4 18             	add    $0x18,%esp
}
  80133d:	90                   	nop
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 15                	push   $0x15
  80134f:	e8 96 fd ff ff       	call   8010ea <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
}
  801357:	90                   	nop
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <sys_cputc>:


void
sys_cputc(const char c)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	83 ec 04             	sub    $0x4,%esp
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801366:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	50                   	push   %eax
  801373:	6a 16                	push   $0x16
  801375:	e8 70 fd ff ff       	call   8010ea <syscall>
  80137a:	83 c4 18             	add    $0x18,%esp
}
  80137d:	90                   	nop
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 17                	push   $0x17
  80138f:	e8 56 fd ff ff       	call   8010ea <syscall>
  801394:	83 c4 18             	add    $0x18,%esp
}
  801397:	90                   	nop
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	ff 75 0c             	pushl  0xc(%ebp)
  8013a9:	50                   	push   %eax
  8013aa:	6a 18                	push   $0x18
  8013ac:	e8 39 fd ff ff       	call   8010ea <syscall>
  8013b1:	83 c4 18             	add    $0x18,%esp
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8013b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	52                   	push   %edx
  8013c6:	50                   	push   %eax
  8013c7:	6a 1b                	push   $0x1b
  8013c9:	e8 1c fd ff ff       	call   8010ea <syscall>
  8013ce:	83 c4 18             	add    $0x18,%esp
}
  8013d1:	c9                   	leave  
  8013d2:	c3                   	ret    

008013d3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8013d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	52                   	push   %edx
  8013e3:	50                   	push   %eax
  8013e4:	6a 19                	push   $0x19
  8013e6:	e8 ff fc ff ff       	call   8010ea <syscall>
  8013eb:	83 c4 18             	add    $0x18,%esp
}
  8013ee:	90                   	nop
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8013f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	52                   	push   %edx
  801401:	50                   	push   %eax
  801402:	6a 1a                	push   $0x1a
  801404:	e8 e1 fc ff ff       	call   8010ea <syscall>
  801409:	83 c4 18             	add    $0x18,%esp
}
  80140c:	90                   	nop
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	83 ec 04             	sub    $0x4,%esp
  801415:	8b 45 10             	mov    0x10(%ebp),%eax
  801418:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80141b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80141e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	6a 00                	push   $0x0
  801427:	51                   	push   %ecx
  801428:	52                   	push   %edx
  801429:	ff 75 0c             	pushl  0xc(%ebp)
  80142c:	50                   	push   %eax
  80142d:	6a 1c                	push   $0x1c
  80142f:	e8 b6 fc ff ff       	call   8010ea <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
}
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80143c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	52                   	push   %edx
  801449:	50                   	push   %eax
  80144a:	6a 1d                	push   $0x1d
  80144c:	e8 99 fc ff ff       	call   8010ea <syscall>
  801451:	83 c4 18             	add    $0x18,%esp
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801459:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80145c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	51                   	push   %ecx
  801467:	52                   	push   %edx
  801468:	50                   	push   %eax
  801469:	6a 1e                	push   $0x1e
  80146b:	e8 7a fc ff ff       	call   8010ea <syscall>
  801470:	83 c4 18             	add    $0x18,%esp
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	52                   	push   %edx
  801485:	50                   	push   %eax
  801486:	6a 1f                	push   $0x1f
  801488:	e8 5d fc ff ff       	call   8010ea <syscall>
  80148d:	83 c4 18             	add    $0x18,%esp
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 20                	push   $0x20
  8014a1:	e8 44 fc ff ff       	call   8010ea <syscall>
  8014a6:	83 c4 18             	add    $0x18,%esp
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	ff 75 10             	pushl  0x10(%ebp)
  8014b8:	ff 75 0c             	pushl  0xc(%ebp)
  8014bb:	50                   	push   %eax
  8014bc:	6a 21                	push   $0x21
  8014be:	e8 27 fc ff ff       	call   8010ea <syscall>
  8014c3:	83 c4 18             	add    $0x18,%esp
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	50                   	push   %eax
  8014d7:	6a 22                	push   $0x22
  8014d9:	e8 0c fc ff ff       	call   8010ea <syscall>
  8014de:	83 c4 18             	add    $0x18,%esp
}
  8014e1:	90                   	nop
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    

008014e4 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	50                   	push   %eax
  8014f3:	6a 23                	push   $0x23
  8014f5:	e8 f0 fb ff ff       	call   8010ea <syscall>
  8014fa:	83 c4 18             	add    $0x18,%esp
}
  8014fd:	90                   	nop
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801506:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801509:	8d 50 04             	lea    0x4(%eax),%edx
  80150c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	52                   	push   %edx
  801516:	50                   	push   %eax
  801517:	6a 24                	push   $0x24
  801519:	e8 cc fb ff ff       	call   8010ea <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
	return result;
  801521:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801524:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801527:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80152a:	89 01                	mov    %eax,(%ecx)
  80152c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	c9                   	leave  
  801533:	c2 04 00             	ret    $0x4

00801536 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	ff 75 10             	pushl  0x10(%ebp)
  801540:	ff 75 0c             	pushl  0xc(%ebp)
  801543:	ff 75 08             	pushl  0x8(%ebp)
  801546:	6a 13                	push   $0x13
  801548:	e8 9d fb ff ff       	call   8010ea <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
	return ;
  801550:	90                   	nop
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <sys_rcr2>:
uint32 sys_rcr2()
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 25                	push   $0x25
  801562:	e8 83 fb ff ff       	call   8010ea <syscall>
  801567:	83 c4 18             	add    $0x18,%esp
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 04             	sub    $0x4,%esp
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801578:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	50                   	push   %eax
  801585:	6a 26                	push   $0x26
  801587:	e8 5e fb ff ff       	call   8010ea <syscall>
  80158c:	83 c4 18             	add    $0x18,%esp
	return ;
  80158f:	90                   	nop
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <rsttst>:
void rsttst()
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 28                	push   $0x28
  8015a1:	e8 44 fb ff ff       	call   8010ea <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a9:	90                   	nop
}
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	83 ec 04             	sub    $0x4,%esp
  8015b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015b8:	8b 55 18             	mov    0x18(%ebp),%edx
  8015bb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015bf:	52                   	push   %edx
  8015c0:	50                   	push   %eax
  8015c1:	ff 75 10             	pushl  0x10(%ebp)
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	ff 75 08             	pushl  0x8(%ebp)
  8015ca:	6a 27                	push   $0x27
  8015cc:	e8 19 fb ff ff       	call   8010ea <syscall>
  8015d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d4:	90                   	nop
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <chktst>:
void chktst(uint32 n)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	ff 75 08             	pushl  0x8(%ebp)
  8015e5:	6a 29                	push   $0x29
  8015e7:	e8 fe fa ff ff       	call   8010ea <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ef:	90                   	nop
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <inctst>:

void inctst()
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 2a                	push   $0x2a
  801601:	e8 e4 fa ff ff       	call   8010ea <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
	return ;
  801609:	90                   	nop
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <gettst>:
uint32 gettst()
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 2b                	push   $0x2b
  80161b:	e8 ca fa ff ff       	call   8010ea <syscall>
  801620:	83 c4 18             	add    $0x18,%esp
}
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 2c                	push   $0x2c
  801637:	e8 ae fa ff ff       	call   8010ea <syscall>
  80163c:	83 c4 18             	add    $0x18,%esp
  80163f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801642:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801646:	75 07                	jne    80164f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801648:	b8 01 00 00 00       	mov    $0x1,%eax
  80164d:	eb 05                	jmp    801654 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80164f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 2c                	push   $0x2c
  801668:	e8 7d fa ff ff       	call   8010ea <syscall>
  80166d:	83 c4 18             	add    $0x18,%esp
  801670:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801673:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801677:	75 07                	jne    801680 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801679:	b8 01 00 00 00       	mov    $0x1,%eax
  80167e:	eb 05                	jmp    801685 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801680:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 2c                	push   $0x2c
  801699:	e8 4c fa ff ff       	call   8010ea <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
  8016a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016a4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016a8:	75 07                	jne    8016b1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8016af:	eb 05                	jmp    8016b6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 2c                	push   $0x2c
  8016ca:	e8 1b fa ff ff       	call   8010ea <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
  8016d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8016d5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8016d9:	75 07                	jne    8016e2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8016db:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e0:	eb 05                	jmp    8016e7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	ff 75 08             	pushl  0x8(%ebp)
  8016f7:	6a 2d                	push   $0x2d
  8016f9:	e8 ec f9 ff ff       	call   8010ea <syscall>
  8016fe:	83 c4 18             	add    $0x18,%esp
	return ;
  801701:	90                   	nop
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801708:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80170b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80170e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	6a 00                	push   $0x0
  801716:	53                   	push   %ebx
  801717:	51                   	push   %ecx
  801718:	52                   	push   %edx
  801719:	50                   	push   %eax
  80171a:	6a 2e                	push   $0x2e
  80171c:	e8 c9 f9 ff ff       	call   8010ea <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
}
  801724:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80172c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	52                   	push   %edx
  801739:	50                   	push   %eax
  80173a:	6a 2f                	push   $0x2f
  80173c:	e8 a9 f9 ff ff       	call   8010ea <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80174c:	8b 55 08             	mov    0x8(%ebp),%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	c1 e0 02             	shl    $0x2,%eax
  801754:	01 d0                	add    %edx,%eax
  801756:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80175d:	01 d0                	add    %edx,%eax
  80175f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801766:	01 d0                	add    %edx,%eax
  801768:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80176f:	01 d0                	add    %edx,%eax
  801771:	c1 e0 04             	shl    $0x4,%eax
  801774:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80177e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801781:	83 ec 0c             	sub    $0xc,%esp
  801784:	50                   	push   %eax
  801785:	e8 76 fd ff ff       	call   801500 <sys_get_virtual_time>
  80178a:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80178d:	eb 41                	jmp    8017d0 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80178f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801792:	83 ec 0c             	sub    $0xc,%esp
  801795:	50                   	push   %eax
  801796:	e8 65 fd ff ff       	call   801500 <sys_get_virtual_time>
  80179b:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80179e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017a4:	29 c2                	sub    %eax,%edx
  8017a6:	89 d0                	mov    %edx,%eax
  8017a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8017ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b1:	89 d1                	mov    %edx,%ecx
  8017b3:	29 c1                	sub    %eax,%ecx
  8017b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8017b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017bb:	39 c2                	cmp    %eax,%edx
  8017bd:	0f 97 c0             	seta   %al
  8017c0:	0f b6 c0             	movzbl %al,%eax
  8017c3:	29 c1                	sub    %eax,%ecx
  8017c5:	89 c8                	mov    %ecx,%eax
  8017c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8017ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8017d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017d6:	72 b7                	jb     80178f <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8017d8:	90                   	nop
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8017e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8017e8:	eb 03                	jmp    8017ed <busy_wait+0x12>
  8017ea:	ff 45 fc             	incl   -0x4(%ebp)
  8017ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017f3:	72 f5                	jb     8017ea <busy_wait+0xf>
	return i;
  8017f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    
  8017fa:	66 90                	xchg   %ax,%ax

008017fc <__udivdi3>:
  8017fc:	55                   	push   %ebp
  8017fd:	57                   	push   %edi
  8017fe:	56                   	push   %esi
  8017ff:	53                   	push   %ebx
  801800:	83 ec 1c             	sub    $0x1c,%esp
  801803:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801807:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80180b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80180f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801813:	89 ca                	mov    %ecx,%edx
  801815:	89 f8                	mov    %edi,%eax
  801817:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80181b:	85 f6                	test   %esi,%esi
  80181d:	75 2d                	jne    80184c <__udivdi3+0x50>
  80181f:	39 cf                	cmp    %ecx,%edi
  801821:	77 65                	ja     801888 <__udivdi3+0x8c>
  801823:	89 fd                	mov    %edi,%ebp
  801825:	85 ff                	test   %edi,%edi
  801827:	75 0b                	jne    801834 <__udivdi3+0x38>
  801829:	b8 01 00 00 00       	mov    $0x1,%eax
  80182e:	31 d2                	xor    %edx,%edx
  801830:	f7 f7                	div    %edi
  801832:	89 c5                	mov    %eax,%ebp
  801834:	31 d2                	xor    %edx,%edx
  801836:	89 c8                	mov    %ecx,%eax
  801838:	f7 f5                	div    %ebp
  80183a:	89 c1                	mov    %eax,%ecx
  80183c:	89 d8                	mov    %ebx,%eax
  80183e:	f7 f5                	div    %ebp
  801840:	89 cf                	mov    %ecx,%edi
  801842:	89 fa                	mov    %edi,%edx
  801844:	83 c4 1c             	add    $0x1c,%esp
  801847:	5b                   	pop    %ebx
  801848:	5e                   	pop    %esi
  801849:	5f                   	pop    %edi
  80184a:	5d                   	pop    %ebp
  80184b:	c3                   	ret    
  80184c:	39 ce                	cmp    %ecx,%esi
  80184e:	77 28                	ja     801878 <__udivdi3+0x7c>
  801850:	0f bd fe             	bsr    %esi,%edi
  801853:	83 f7 1f             	xor    $0x1f,%edi
  801856:	75 40                	jne    801898 <__udivdi3+0x9c>
  801858:	39 ce                	cmp    %ecx,%esi
  80185a:	72 0a                	jb     801866 <__udivdi3+0x6a>
  80185c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801860:	0f 87 9e 00 00 00    	ja     801904 <__udivdi3+0x108>
  801866:	b8 01 00 00 00       	mov    $0x1,%eax
  80186b:	89 fa                	mov    %edi,%edx
  80186d:	83 c4 1c             	add    $0x1c,%esp
  801870:	5b                   	pop    %ebx
  801871:	5e                   	pop    %esi
  801872:	5f                   	pop    %edi
  801873:	5d                   	pop    %ebp
  801874:	c3                   	ret    
  801875:	8d 76 00             	lea    0x0(%esi),%esi
  801878:	31 ff                	xor    %edi,%edi
  80187a:	31 c0                	xor    %eax,%eax
  80187c:	89 fa                	mov    %edi,%edx
  80187e:	83 c4 1c             	add    $0x1c,%esp
  801881:	5b                   	pop    %ebx
  801882:	5e                   	pop    %esi
  801883:	5f                   	pop    %edi
  801884:	5d                   	pop    %ebp
  801885:	c3                   	ret    
  801886:	66 90                	xchg   %ax,%ax
  801888:	89 d8                	mov    %ebx,%eax
  80188a:	f7 f7                	div    %edi
  80188c:	31 ff                	xor    %edi,%edi
  80188e:	89 fa                	mov    %edi,%edx
  801890:	83 c4 1c             	add    $0x1c,%esp
  801893:	5b                   	pop    %ebx
  801894:	5e                   	pop    %esi
  801895:	5f                   	pop    %edi
  801896:	5d                   	pop    %ebp
  801897:	c3                   	ret    
  801898:	bd 20 00 00 00       	mov    $0x20,%ebp
  80189d:	89 eb                	mov    %ebp,%ebx
  80189f:	29 fb                	sub    %edi,%ebx
  8018a1:	89 f9                	mov    %edi,%ecx
  8018a3:	d3 e6                	shl    %cl,%esi
  8018a5:	89 c5                	mov    %eax,%ebp
  8018a7:	88 d9                	mov    %bl,%cl
  8018a9:	d3 ed                	shr    %cl,%ebp
  8018ab:	89 e9                	mov    %ebp,%ecx
  8018ad:	09 f1                	or     %esi,%ecx
  8018af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018b3:	89 f9                	mov    %edi,%ecx
  8018b5:	d3 e0                	shl    %cl,%eax
  8018b7:	89 c5                	mov    %eax,%ebp
  8018b9:	89 d6                	mov    %edx,%esi
  8018bb:	88 d9                	mov    %bl,%cl
  8018bd:	d3 ee                	shr    %cl,%esi
  8018bf:	89 f9                	mov    %edi,%ecx
  8018c1:	d3 e2                	shl    %cl,%edx
  8018c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018c7:	88 d9                	mov    %bl,%cl
  8018c9:	d3 e8                	shr    %cl,%eax
  8018cb:	09 c2                	or     %eax,%edx
  8018cd:	89 d0                	mov    %edx,%eax
  8018cf:	89 f2                	mov    %esi,%edx
  8018d1:	f7 74 24 0c          	divl   0xc(%esp)
  8018d5:	89 d6                	mov    %edx,%esi
  8018d7:	89 c3                	mov    %eax,%ebx
  8018d9:	f7 e5                	mul    %ebp
  8018db:	39 d6                	cmp    %edx,%esi
  8018dd:	72 19                	jb     8018f8 <__udivdi3+0xfc>
  8018df:	74 0b                	je     8018ec <__udivdi3+0xf0>
  8018e1:	89 d8                	mov    %ebx,%eax
  8018e3:	31 ff                	xor    %edi,%edi
  8018e5:	e9 58 ff ff ff       	jmp    801842 <__udivdi3+0x46>
  8018ea:	66 90                	xchg   %ax,%ax
  8018ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8018f0:	89 f9                	mov    %edi,%ecx
  8018f2:	d3 e2                	shl    %cl,%edx
  8018f4:	39 c2                	cmp    %eax,%edx
  8018f6:	73 e9                	jae    8018e1 <__udivdi3+0xe5>
  8018f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8018fb:	31 ff                	xor    %edi,%edi
  8018fd:	e9 40 ff ff ff       	jmp    801842 <__udivdi3+0x46>
  801902:	66 90                	xchg   %ax,%ax
  801904:	31 c0                	xor    %eax,%eax
  801906:	e9 37 ff ff ff       	jmp    801842 <__udivdi3+0x46>
  80190b:	90                   	nop

0080190c <__umoddi3>:
  80190c:	55                   	push   %ebp
  80190d:	57                   	push   %edi
  80190e:	56                   	push   %esi
  80190f:	53                   	push   %ebx
  801910:	83 ec 1c             	sub    $0x1c,%esp
  801913:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801917:	8b 74 24 34          	mov    0x34(%esp),%esi
  80191b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80191f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801923:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801927:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80192b:	89 f3                	mov    %esi,%ebx
  80192d:	89 fa                	mov    %edi,%edx
  80192f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801933:	89 34 24             	mov    %esi,(%esp)
  801936:	85 c0                	test   %eax,%eax
  801938:	75 1a                	jne    801954 <__umoddi3+0x48>
  80193a:	39 f7                	cmp    %esi,%edi
  80193c:	0f 86 a2 00 00 00    	jbe    8019e4 <__umoddi3+0xd8>
  801942:	89 c8                	mov    %ecx,%eax
  801944:	89 f2                	mov    %esi,%edx
  801946:	f7 f7                	div    %edi
  801948:	89 d0                	mov    %edx,%eax
  80194a:	31 d2                	xor    %edx,%edx
  80194c:	83 c4 1c             	add    $0x1c,%esp
  80194f:	5b                   	pop    %ebx
  801950:	5e                   	pop    %esi
  801951:	5f                   	pop    %edi
  801952:	5d                   	pop    %ebp
  801953:	c3                   	ret    
  801954:	39 f0                	cmp    %esi,%eax
  801956:	0f 87 ac 00 00 00    	ja     801a08 <__umoddi3+0xfc>
  80195c:	0f bd e8             	bsr    %eax,%ebp
  80195f:	83 f5 1f             	xor    $0x1f,%ebp
  801962:	0f 84 ac 00 00 00    	je     801a14 <__umoddi3+0x108>
  801968:	bf 20 00 00 00       	mov    $0x20,%edi
  80196d:	29 ef                	sub    %ebp,%edi
  80196f:	89 fe                	mov    %edi,%esi
  801971:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801975:	89 e9                	mov    %ebp,%ecx
  801977:	d3 e0                	shl    %cl,%eax
  801979:	89 d7                	mov    %edx,%edi
  80197b:	89 f1                	mov    %esi,%ecx
  80197d:	d3 ef                	shr    %cl,%edi
  80197f:	09 c7                	or     %eax,%edi
  801981:	89 e9                	mov    %ebp,%ecx
  801983:	d3 e2                	shl    %cl,%edx
  801985:	89 14 24             	mov    %edx,(%esp)
  801988:	89 d8                	mov    %ebx,%eax
  80198a:	d3 e0                	shl    %cl,%eax
  80198c:	89 c2                	mov    %eax,%edx
  80198e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801992:	d3 e0                	shl    %cl,%eax
  801994:	89 44 24 04          	mov    %eax,0x4(%esp)
  801998:	8b 44 24 08          	mov    0x8(%esp),%eax
  80199c:	89 f1                	mov    %esi,%ecx
  80199e:	d3 e8                	shr    %cl,%eax
  8019a0:	09 d0                	or     %edx,%eax
  8019a2:	d3 eb                	shr    %cl,%ebx
  8019a4:	89 da                	mov    %ebx,%edx
  8019a6:	f7 f7                	div    %edi
  8019a8:	89 d3                	mov    %edx,%ebx
  8019aa:	f7 24 24             	mull   (%esp)
  8019ad:	89 c6                	mov    %eax,%esi
  8019af:	89 d1                	mov    %edx,%ecx
  8019b1:	39 d3                	cmp    %edx,%ebx
  8019b3:	0f 82 87 00 00 00    	jb     801a40 <__umoddi3+0x134>
  8019b9:	0f 84 91 00 00 00    	je     801a50 <__umoddi3+0x144>
  8019bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019c3:	29 f2                	sub    %esi,%edx
  8019c5:	19 cb                	sbb    %ecx,%ebx
  8019c7:	89 d8                	mov    %ebx,%eax
  8019c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019cd:	d3 e0                	shl    %cl,%eax
  8019cf:	89 e9                	mov    %ebp,%ecx
  8019d1:	d3 ea                	shr    %cl,%edx
  8019d3:	09 d0                	or     %edx,%eax
  8019d5:	89 e9                	mov    %ebp,%ecx
  8019d7:	d3 eb                	shr    %cl,%ebx
  8019d9:	89 da                	mov    %ebx,%edx
  8019db:	83 c4 1c             	add    $0x1c,%esp
  8019de:	5b                   	pop    %ebx
  8019df:	5e                   	pop    %esi
  8019e0:	5f                   	pop    %edi
  8019e1:	5d                   	pop    %ebp
  8019e2:	c3                   	ret    
  8019e3:	90                   	nop
  8019e4:	89 fd                	mov    %edi,%ebp
  8019e6:	85 ff                	test   %edi,%edi
  8019e8:	75 0b                	jne    8019f5 <__umoddi3+0xe9>
  8019ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ef:	31 d2                	xor    %edx,%edx
  8019f1:	f7 f7                	div    %edi
  8019f3:	89 c5                	mov    %eax,%ebp
  8019f5:	89 f0                	mov    %esi,%eax
  8019f7:	31 d2                	xor    %edx,%edx
  8019f9:	f7 f5                	div    %ebp
  8019fb:	89 c8                	mov    %ecx,%eax
  8019fd:	f7 f5                	div    %ebp
  8019ff:	89 d0                	mov    %edx,%eax
  801a01:	e9 44 ff ff ff       	jmp    80194a <__umoddi3+0x3e>
  801a06:	66 90                	xchg   %ax,%ax
  801a08:	89 c8                	mov    %ecx,%eax
  801a0a:	89 f2                	mov    %esi,%edx
  801a0c:	83 c4 1c             	add    $0x1c,%esp
  801a0f:	5b                   	pop    %ebx
  801a10:	5e                   	pop    %esi
  801a11:	5f                   	pop    %edi
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    
  801a14:	3b 04 24             	cmp    (%esp),%eax
  801a17:	72 06                	jb     801a1f <__umoddi3+0x113>
  801a19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a1d:	77 0f                	ja     801a2e <__umoddi3+0x122>
  801a1f:	89 f2                	mov    %esi,%edx
  801a21:	29 f9                	sub    %edi,%ecx
  801a23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a27:	89 14 24             	mov    %edx,(%esp)
  801a2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a32:	8b 14 24             	mov    (%esp),%edx
  801a35:	83 c4 1c             	add    $0x1c,%esp
  801a38:	5b                   	pop    %ebx
  801a39:	5e                   	pop    %esi
  801a3a:	5f                   	pop    %edi
  801a3b:	5d                   	pop    %ebp
  801a3c:	c3                   	ret    
  801a3d:	8d 76 00             	lea    0x0(%esi),%esi
  801a40:	2b 04 24             	sub    (%esp),%eax
  801a43:	19 fa                	sbb    %edi,%edx
  801a45:	89 d1                	mov    %edx,%ecx
  801a47:	89 c6                	mov    %eax,%esi
  801a49:	e9 71 ff ff ff       	jmp    8019bf <__umoddi3+0xb3>
  801a4e:	66 90                	xchg   %ax,%ax
  801a50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a54:	72 ea                	jb     801a40 <__umoddi3+0x134>
  801a56:	89 d9                	mov    %ebx,%ecx
  801a58:	e9 62 ff ff ff       	jmp    8019bf <__umoddi3+0xb3>
