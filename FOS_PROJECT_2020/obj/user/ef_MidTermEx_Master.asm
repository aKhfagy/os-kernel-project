
obj/user/ef_MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 7e 01 00 00       	call   8001b4 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 60 1d 80 00       	push   $0x801d60
  80004a:	e8 22 11 00 00       	call   801171 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	//cprintf("Do you want to use semaphore (y/n)? ") ;
	//char select = getchar() ;
	char select = 'y';
  80005e:	c6 45 f3 79          	movb   $0x79,-0xd(%ebp)
	//cputchar(select);
	//cputchar('\n');

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	6a 00                	push   $0x0
  800067:	6a 04                	push   $0x4
  800069:	68 62 1d 80 00       	push   $0x801d62
  80006e:	e8 fe 10 00 00       	call   801171 <smalloc>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  800079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80007c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  800082:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  800086:	74 06                	je     80008e <_main+0x56>
  800088:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  80008c:	75 09                	jne    800097 <_main+0x5f>
		*useSem = 1 ;
  80008e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800091:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  800097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009a:	8b 00                	mov    (%eax),%eax
  80009c:	83 f8 01             	cmp    $0x1,%eax
  80009f:	75 12                	jne    8000b3 <_main+0x7b>
	{
		sys_createSemaphore("T", 0);
  8000a1:	83 ec 08             	sub    $0x8,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	68 69 1d 80 00       	push   $0x801d69
  8000ab:	e8 ff 13 00 00       	call   8014af <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 6b 1d 80 00       	push   $0x801d6b
  8000bf:	e8 ad 10 00 00       	call   801171 <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size), 50);
  8000d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d8:	8b 40 74             	mov    0x74(%eax),%eax
  8000db:	83 ec 04             	sub    $0x4,%esp
  8000de:	6a 32                	push   $0x32
  8000e0:	50                   	push   %eax
  8000e1:	68 79 1d 80 00       	push   $0x801d79
  8000e6:	e8 d5 14 00 00       	call   8015c0 <sys_create_env>
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), 50);
  8000f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f6:	8b 40 74             	mov    0x74(%eax),%eax
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	6a 32                	push   $0x32
  8000fe:	50                   	push   %eax
  8000ff:	68 83 1d 80 00       	push   $0x801d83
  800104:	e8 b7 14 00 00       	call   8015c0 <sys_create_env>
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	ff 75 e4             	pushl  -0x1c(%ebp)
  800115:	e8 c3 14 00 00       	call   8015dd <sys_run_env>
  80011a:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  80011d:	83 ec 0c             	sub    $0xc,%esp
  800120:	68 10 27 00 00       	push   $0x2710
  800125:	e8 31 17 00 00       	call   80185b <env_sleep>
  80012a:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	ff 75 e0             	pushl  -0x20(%ebp)
  800133:	e8 a5 14 00 00       	call   8015dd <sys_run_env>
  800138:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  80013b:	90                   	nop
  80013c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013f:	8b 00                	mov    (%eax),%eax
  800141:	83 f8 02             	cmp    $0x2,%eax
  800144:	75 f6                	jne    80013c <_main+0x104>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  800146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800149:	8b 00                	mov    (%eax),%eax
  80014b:	83 ec 08             	sub    $0x8,%esp
  80014e:	50                   	push   %eax
  80014f:	68 8d 1d 80 00       	push   $0x801d8d
  800154:	e8 74 02 00 00       	call   8003cd <cprintf>
  800159:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80015c:	e8 58 11 00 00       	call   8012b9 <sys_getparentenvid>
  800161:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  800164:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800168:	7e 47                	jle    8001b1 <_main+0x179>
	{
		//Get the check-finishing counter
		int *AllFinish = NULL;
  80016a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		AllFinish = sget(parentenvID, "finishedCount") ;
  800171:	83 ec 08             	sub    $0x8,%esp
  800174:	68 6b 1d 80 00       	push   $0x801d6b
  800179:	ff 75 dc             	pushl  -0x24(%ebp)
  80017c:	e8 10 10 00 00       	call   801191 <sget>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_free_env(envIdProcessA);
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80018d:	e8 67 14 00 00       	call   8015f9 <sys_free_env>
  800192:	83 c4 10             	add    $0x10,%esp
		sys_free_env(envIdProcessB);
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	ff 75 e0             	pushl  -0x20(%ebp)
  80019b:	e8 59 14 00 00       	call   8015f9 <sys_free_env>
  8001a0:	83 c4 10             	add    $0x10,%esp
		(*AllFinish)++ ;
  8001a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a6:	8b 00                	mov    (%eax),%eax
  8001a8:	8d 50 01             	lea    0x1(%eax),%edx
  8001ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001ae:	89 10                	mov    %edx,(%eax)
	}

	return;
  8001b0:	90                   	nop
  8001b1:	90                   	nop
}
  8001b2:	c9                   	leave  
  8001b3:	c3                   	ret    

008001b4 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ba:	e8 e1 10 00 00       	call   8012a0 <sys_getenvindex>
  8001bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001c5:	89 d0                	mov    %edx,%eax
  8001c7:	c1 e0 03             	shl    $0x3,%eax
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001d3:	01 c8                	add    %ecx,%eax
  8001d5:	01 c0                	add    %eax,%eax
  8001d7:	01 d0                	add    %edx,%eax
  8001d9:	01 c0                	add    %eax,%eax
  8001db:	01 d0                	add    %edx,%eax
  8001dd:	89 c2                	mov    %eax,%edx
  8001df:	c1 e2 05             	shl    $0x5,%edx
  8001e2:	29 c2                	sub    %eax,%edx
  8001e4:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001eb:	89 c2                	mov    %eax,%edx
  8001ed:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001f3:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fd:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800203:	84 c0                	test   %al,%al
  800205:	74 0f                	je     800216 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800207:	a1 20 30 80 00       	mov    0x803020,%eax
  80020c:	05 40 3c 01 00       	add    $0x13c40,%eax
  800211:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800216:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80021a:	7e 0a                	jle    800226 <libmain+0x72>
		binaryname = argv[0];
  80021c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021f:	8b 00                	mov    (%eax),%eax
  800221:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800226:	83 ec 08             	sub    $0x8,%esp
  800229:	ff 75 0c             	pushl  0xc(%ebp)
  80022c:	ff 75 08             	pushl  0x8(%ebp)
  80022f:	e8 04 fe ff ff       	call   800038 <_main>
  800234:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800237:	e8 ff 11 00 00       	call   80143b <sys_disable_interrupt>
	cprintf("**************************************\n");
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	68 bc 1d 80 00       	push   $0x801dbc
  800244:	e8 84 01 00 00       	call   8003cd <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80024c:	a1 20 30 80 00       	mov    0x803020,%eax
  800251:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800257:	a1 20 30 80 00       	mov    0x803020,%eax
  80025c:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	52                   	push   %edx
  800266:	50                   	push   %eax
  800267:	68 e4 1d 80 00       	push   $0x801de4
  80026c:	e8 5c 01 00 00       	call   8003cd <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800274:	a1 20 30 80 00       	mov    0x803020,%eax
  800279:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80027f:	a1 20 30 80 00       	mov    0x803020,%eax
  800284:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80028a:	83 ec 04             	sub    $0x4,%esp
  80028d:	52                   	push   %edx
  80028e:	50                   	push   %eax
  80028f:	68 0c 1e 80 00       	push   $0x801e0c
  800294:	e8 34 01 00 00       	call   8003cd <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80029c:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a1:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8002a7:	83 ec 08             	sub    $0x8,%esp
  8002aa:	50                   	push   %eax
  8002ab:	68 4d 1e 80 00       	push   $0x801e4d
  8002b0:	e8 18 01 00 00       	call   8003cd <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 bc 1d 80 00       	push   $0x801dbc
  8002c0:	e8 08 01 00 00       	call   8003cd <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002c8:	e8 88 11 00 00       	call   801455 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002cd:	e8 19 00 00 00       	call   8002eb <exit>
}
  8002d2:	90                   	nop
  8002d3:	c9                   	leave  
  8002d4:	c3                   	ret    

008002d5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8002db:	83 ec 0c             	sub    $0xc,%esp
  8002de:	6a 00                	push   $0x0
  8002e0:	e8 87 0f 00 00       	call   80126c <sys_env_destroy>
  8002e5:	83 c4 10             	add    $0x10,%esp
}
  8002e8:	90                   	nop
  8002e9:	c9                   	leave  
  8002ea:	c3                   	ret    

008002eb <exit>:

void
exit(void)
{
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002f1:	e8 dc 0f 00 00       	call   8012d2 <sys_env_exit>
}
  8002f6:	90                   	nop
  8002f7:	c9                   	leave  
  8002f8:	c3                   	ret    

008002f9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	8b 00                	mov    (%eax),%eax
  800304:	8d 48 01             	lea    0x1(%eax),%ecx
  800307:	8b 55 0c             	mov    0xc(%ebp),%edx
  80030a:	89 0a                	mov    %ecx,(%edx)
  80030c:	8b 55 08             	mov    0x8(%ebp),%edx
  80030f:	88 d1                	mov    %dl,%cl
  800311:	8b 55 0c             	mov    0xc(%ebp),%edx
  800314:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800318:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031b:	8b 00                	mov    (%eax),%eax
  80031d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800322:	75 2c                	jne    800350 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800324:	a0 24 30 80 00       	mov    0x803024,%al
  800329:	0f b6 c0             	movzbl %al,%eax
  80032c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80032f:	8b 12                	mov    (%edx),%edx
  800331:	89 d1                	mov    %edx,%ecx
  800333:	8b 55 0c             	mov    0xc(%ebp),%edx
  800336:	83 c2 08             	add    $0x8,%edx
  800339:	83 ec 04             	sub    $0x4,%esp
  80033c:	50                   	push   %eax
  80033d:	51                   	push   %ecx
  80033e:	52                   	push   %edx
  80033f:	e8 e6 0e 00 00       	call   80122a <sys_cputs>
  800344:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800350:	8b 45 0c             	mov    0xc(%ebp),%eax
  800353:	8b 40 04             	mov    0x4(%eax),%eax
  800356:	8d 50 01             	lea    0x1(%eax),%edx
  800359:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80035f:	90                   	nop
  800360:	c9                   	leave  
  800361:	c3                   	ret    

00800362 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80036b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800372:	00 00 00 
	b.cnt = 0;
  800375:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80037c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80037f:	ff 75 0c             	pushl  0xc(%ebp)
  800382:	ff 75 08             	pushl  0x8(%ebp)
  800385:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80038b:	50                   	push   %eax
  80038c:	68 f9 02 80 00       	push   $0x8002f9
  800391:	e8 11 02 00 00       	call   8005a7 <vprintfmt>
  800396:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800399:	a0 24 30 80 00       	mov    0x803024,%al
  80039e:	0f b6 c0             	movzbl %al,%eax
  8003a1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	50                   	push   %eax
  8003ab:	52                   	push   %edx
  8003ac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003b2:	83 c0 08             	add    $0x8,%eax
  8003b5:	50                   	push   %eax
  8003b6:	e8 6f 0e 00 00       	call   80122a <sys_cputs>
  8003bb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003be:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8003c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003cb:	c9                   	leave  
  8003cc:	c3                   	ret    

008003cd <cprintf>:

int cprintf(const char *fmt, ...) {
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003d3:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8003da:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e3:	83 ec 08             	sub    $0x8,%esp
  8003e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e9:	50                   	push   %eax
  8003ea:	e8 73 ff ff ff       	call   800362 <vcprintf>
  8003ef:	83 c4 10             	add    $0x10,%esp
  8003f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003f8:	c9                   	leave  
  8003f9:	c3                   	ret    

008003fa <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800400:	e8 36 10 00 00       	call   80143b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800405:	8d 45 0c             	lea    0xc(%ebp),%eax
  800408:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	83 ec 08             	sub    $0x8,%esp
  800411:	ff 75 f4             	pushl  -0xc(%ebp)
  800414:	50                   	push   %eax
  800415:	e8 48 ff ff ff       	call   800362 <vcprintf>
  80041a:	83 c4 10             	add    $0x10,%esp
  80041d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800420:	e8 30 10 00 00       	call   801455 <sys_enable_interrupt>
	return cnt;
  800425:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	53                   	push   %ebx
  80042e:	83 ec 14             	sub    $0x14,%esp
  800431:	8b 45 10             	mov    0x10(%ebp),%eax
  800434:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800437:	8b 45 14             	mov    0x14(%ebp),%eax
  80043a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80043d:	8b 45 18             	mov    0x18(%ebp),%eax
  800440:	ba 00 00 00 00       	mov    $0x0,%edx
  800445:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800448:	77 55                	ja     80049f <printnum+0x75>
  80044a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80044d:	72 05                	jb     800454 <printnum+0x2a>
  80044f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800452:	77 4b                	ja     80049f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800454:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800457:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80045a:	8b 45 18             	mov    0x18(%ebp),%eax
  80045d:	ba 00 00 00 00       	mov    $0x0,%edx
  800462:	52                   	push   %edx
  800463:	50                   	push   %eax
  800464:	ff 75 f4             	pushl  -0xc(%ebp)
  800467:	ff 75 f0             	pushl  -0x10(%ebp)
  80046a:	e8 71 16 00 00       	call   801ae0 <__udivdi3>
  80046f:	83 c4 10             	add    $0x10,%esp
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	ff 75 20             	pushl  0x20(%ebp)
  800478:	53                   	push   %ebx
  800479:	ff 75 18             	pushl  0x18(%ebp)
  80047c:	52                   	push   %edx
  80047d:	50                   	push   %eax
  80047e:	ff 75 0c             	pushl  0xc(%ebp)
  800481:	ff 75 08             	pushl  0x8(%ebp)
  800484:	e8 a1 ff ff ff       	call   80042a <printnum>
  800489:	83 c4 20             	add    $0x20,%esp
  80048c:	eb 1a                	jmp    8004a8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	ff 75 0c             	pushl  0xc(%ebp)
  800494:	ff 75 20             	pushl  0x20(%ebp)
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	ff d0                	call   *%eax
  80049c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80049f:	ff 4d 1c             	decl   0x1c(%ebp)
  8004a2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004a6:	7f e6                	jg     80048e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004a8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004b6:	53                   	push   %ebx
  8004b7:	51                   	push   %ecx
  8004b8:	52                   	push   %edx
  8004b9:	50                   	push   %eax
  8004ba:	e8 31 17 00 00       	call   801bf0 <__umoddi3>
  8004bf:	83 c4 10             	add    $0x10,%esp
  8004c2:	05 94 20 80 00       	add    $0x802094,%eax
  8004c7:	8a 00                	mov    (%eax),%al
  8004c9:	0f be c0             	movsbl %al,%eax
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	ff 75 0c             	pushl  0xc(%ebp)
  8004d2:	50                   	push   %eax
  8004d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d6:	ff d0                	call   *%eax
  8004d8:	83 c4 10             	add    $0x10,%esp
}
  8004db:	90                   	nop
  8004dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004df:	c9                   	leave  
  8004e0:	c3                   	ret    

008004e1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004e8:	7e 1c                	jle    800506 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	8d 50 08             	lea    0x8(%eax),%edx
  8004f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f5:	89 10                	mov    %edx,(%eax)
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	83 e8 08             	sub    $0x8,%eax
  8004ff:	8b 50 04             	mov    0x4(%eax),%edx
  800502:	8b 00                	mov    (%eax),%eax
  800504:	eb 40                	jmp    800546 <getuint+0x65>
	else if (lflag)
  800506:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80050a:	74 1e                	je     80052a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	8d 50 04             	lea    0x4(%eax),%edx
  800514:	8b 45 08             	mov    0x8(%ebp),%eax
  800517:	89 10                	mov    %edx,(%eax)
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	83 e8 04             	sub    $0x4,%eax
  800521:	8b 00                	mov    (%eax),%eax
  800523:	ba 00 00 00 00       	mov    $0x0,%edx
  800528:	eb 1c                	jmp    800546 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	8d 50 04             	lea    0x4(%eax),%edx
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	89 10                	mov    %edx,(%eax)
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	83 e8 04             	sub    $0x4,%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800546:	5d                   	pop    %ebp
  800547:	c3                   	ret    

00800548 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80054b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80054f:	7e 1c                	jle    80056d <getint+0x25>
		return va_arg(*ap, long long);
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	8d 50 08             	lea    0x8(%eax),%edx
  800559:	8b 45 08             	mov    0x8(%ebp),%eax
  80055c:	89 10                	mov    %edx,(%eax)
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	83 e8 08             	sub    $0x8,%eax
  800566:	8b 50 04             	mov    0x4(%eax),%edx
  800569:	8b 00                	mov    (%eax),%eax
  80056b:	eb 38                	jmp    8005a5 <getint+0x5d>
	else if (lflag)
  80056d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800571:	74 1a                	je     80058d <getint+0x45>
		return va_arg(*ap, long);
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	8b 00                	mov    (%eax),%eax
  800578:	8d 50 04             	lea    0x4(%eax),%edx
  80057b:	8b 45 08             	mov    0x8(%ebp),%eax
  80057e:	89 10                	mov    %edx,(%eax)
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	83 e8 04             	sub    $0x4,%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	99                   	cltd   
  80058b:	eb 18                	jmp    8005a5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80058d:	8b 45 08             	mov    0x8(%ebp),%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	8d 50 04             	lea    0x4(%eax),%edx
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	89 10                	mov    %edx,(%eax)
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	83 e8 04             	sub    $0x4,%eax
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	99                   	cltd   
}
  8005a5:	5d                   	pop    %ebp
  8005a6:	c3                   	ret    

008005a7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005a7:	55                   	push   %ebp
  8005a8:	89 e5                	mov    %esp,%ebp
  8005aa:	56                   	push   %esi
  8005ab:	53                   	push   %ebx
  8005ac:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005af:	eb 17                	jmp    8005c8 <vprintfmt+0x21>
			if (ch == '\0')
  8005b1:	85 db                	test   %ebx,%ebx
  8005b3:	0f 84 af 03 00 00    	je     800968 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	ff 75 0c             	pushl  0xc(%ebp)
  8005bf:	53                   	push   %ebx
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	ff d0                	call   *%eax
  8005c5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cb:	8d 50 01             	lea    0x1(%eax),%edx
  8005ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8005d1:	8a 00                	mov    (%eax),%al
  8005d3:	0f b6 d8             	movzbl %al,%ebx
  8005d6:	83 fb 25             	cmp    $0x25,%ebx
  8005d9:	75 d6                	jne    8005b1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005db:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005df:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005ed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005f4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8005fe:	8d 50 01             	lea    0x1(%eax),%edx
  800601:	89 55 10             	mov    %edx,0x10(%ebp)
  800604:	8a 00                	mov    (%eax),%al
  800606:	0f b6 d8             	movzbl %al,%ebx
  800609:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80060c:	83 f8 55             	cmp    $0x55,%eax
  80060f:	0f 87 2b 03 00 00    	ja     800940 <vprintfmt+0x399>
  800615:	8b 04 85 b8 20 80 00 	mov    0x8020b8(,%eax,4),%eax
  80061c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80061e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800622:	eb d7                	jmp    8005fb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800624:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800628:	eb d1                	jmp    8005fb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80062a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800631:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800634:	89 d0                	mov    %edx,%eax
  800636:	c1 e0 02             	shl    $0x2,%eax
  800639:	01 d0                	add    %edx,%eax
  80063b:	01 c0                	add    %eax,%eax
  80063d:	01 d8                	add    %ebx,%eax
  80063f:	83 e8 30             	sub    $0x30,%eax
  800642:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800645:	8b 45 10             	mov    0x10(%ebp),%eax
  800648:	8a 00                	mov    (%eax),%al
  80064a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80064d:	83 fb 2f             	cmp    $0x2f,%ebx
  800650:	7e 3e                	jle    800690 <vprintfmt+0xe9>
  800652:	83 fb 39             	cmp    $0x39,%ebx
  800655:	7f 39                	jg     800690 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800657:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80065a:	eb d5                	jmp    800631 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	83 c0 04             	add    $0x4,%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	83 e8 04             	sub    $0x4,%eax
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800670:	eb 1f                	jmp    800691 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800672:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800676:	79 83                	jns    8005fb <vprintfmt+0x54>
				width = 0;
  800678:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80067f:	e9 77 ff ff ff       	jmp    8005fb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800684:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80068b:	e9 6b ff ff ff       	jmp    8005fb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800690:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800691:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800695:	0f 89 60 ff ff ff    	jns    8005fb <vprintfmt+0x54>
				width = precision, precision = -1;
  80069b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006a8:	e9 4e ff ff ff       	jmp    8005fb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006ad:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006b0:	e9 46 ff ff ff       	jmp    8005fb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	83 c0 04             	add    $0x4,%eax
  8006bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	83 e8 04             	sub    $0x4,%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 0c             	pushl  0xc(%ebp)
  8006cc:	50                   	push   %eax
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	ff d0                	call   *%eax
  8006d2:	83 c4 10             	add    $0x10,%esp
			break;
  8006d5:	e9 89 02 00 00       	jmp    800963 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	83 c0 04             	add    $0x4,%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	83 e8 04             	sub    $0x4,%eax
  8006e9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006eb:	85 db                	test   %ebx,%ebx
  8006ed:	79 02                	jns    8006f1 <vprintfmt+0x14a>
				err = -err;
  8006ef:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006f1:	83 fb 64             	cmp    $0x64,%ebx
  8006f4:	7f 0b                	jg     800701 <vprintfmt+0x15a>
  8006f6:	8b 34 9d 00 1f 80 00 	mov    0x801f00(,%ebx,4),%esi
  8006fd:	85 f6                	test   %esi,%esi
  8006ff:	75 19                	jne    80071a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800701:	53                   	push   %ebx
  800702:	68 a5 20 80 00       	push   $0x8020a5
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	ff 75 08             	pushl  0x8(%ebp)
  80070d:	e8 5e 02 00 00       	call   800970 <printfmt>
  800712:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800715:	e9 49 02 00 00       	jmp    800963 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80071a:	56                   	push   %esi
  80071b:	68 ae 20 80 00       	push   $0x8020ae
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	ff 75 08             	pushl  0x8(%ebp)
  800726:	e8 45 02 00 00       	call   800970 <printfmt>
  80072b:	83 c4 10             	add    $0x10,%esp
			break;
  80072e:	e9 30 02 00 00       	jmp    800963 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	83 c0 04             	add    $0x4,%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	83 e8 04             	sub    $0x4,%eax
  800742:	8b 30                	mov    (%eax),%esi
  800744:	85 f6                	test   %esi,%esi
  800746:	75 05                	jne    80074d <vprintfmt+0x1a6>
				p = "(null)";
  800748:	be b1 20 80 00       	mov    $0x8020b1,%esi
			if (width > 0 && padc != '-')
  80074d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800751:	7e 6d                	jle    8007c0 <vprintfmt+0x219>
  800753:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800757:	74 67                	je     8007c0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800759:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	50                   	push   %eax
  800760:	56                   	push   %esi
  800761:	e8 0c 03 00 00       	call   800a72 <strnlen>
  800766:	83 c4 10             	add    $0x10,%esp
  800769:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80076c:	eb 16                	jmp    800784 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80076e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	ff 75 0c             	pushl  0xc(%ebp)
  800778:	50                   	push   %eax
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	ff d0                	call   *%eax
  80077e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800781:	ff 4d e4             	decl   -0x1c(%ebp)
  800784:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800788:	7f e4                	jg     80076e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80078a:	eb 34                	jmp    8007c0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80078c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800790:	74 1c                	je     8007ae <vprintfmt+0x207>
  800792:	83 fb 1f             	cmp    $0x1f,%ebx
  800795:	7e 05                	jle    80079c <vprintfmt+0x1f5>
  800797:	83 fb 7e             	cmp    $0x7e,%ebx
  80079a:	7e 12                	jle    8007ae <vprintfmt+0x207>
					putch('?', putdat);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	6a 3f                	push   $0x3f
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	ff d0                	call   *%eax
  8007a9:	83 c4 10             	add    $0x10,%esp
  8007ac:	eb 0f                	jmp    8007bd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	ff 75 0c             	pushl  0xc(%ebp)
  8007b4:	53                   	push   %ebx
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	ff d0                	call   *%eax
  8007ba:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007bd:	ff 4d e4             	decl   -0x1c(%ebp)
  8007c0:	89 f0                	mov    %esi,%eax
  8007c2:	8d 70 01             	lea    0x1(%eax),%esi
  8007c5:	8a 00                	mov    (%eax),%al
  8007c7:	0f be d8             	movsbl %al,%ebx
  8007ca:	85 db                	test   %ebx,%ebx
  8007cc:	74 24                	je     8007f2 <vprintfmt+0x24b>
  8007ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007d2:	78 b8                	js     80078c <vprintfmt+0x1e5>
  8007d4:	ff 4d e0             	decl   -0x20(%ebp)
  8007d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007db:	79 af                	jns    80078c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007dd:	eb 13                	jmp    8007f2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	ff 75 0c             	pushl  0xc(%ebp)
  8007e5:	6a 20                	push   $0x20
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	ff d0                	call   *%eax
  8007ec:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8007f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f6:	7f e7                	jg     8007df <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007f8:	e9 66 01 00 00       	jmp    800963 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 e8             	pushl  -0x18(%ebp)
  800803:	8d 45 14             	lea    0x14(%ebp),%eax
  800806:	50                   	push   %eax
  800807:	e8 3c fd ff ff       	call   800548 <getint>
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800812:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800818:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80081b:	85 d2                	test   %edx,%edx
  80081d:	79 23                	jns    800842 <vprintfmt+0x29b>
				putch('-', putdat);
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	ff 75 0c             	pushl  0xc(%ebp)
  800825:	6a 2d                	push   $0x2d
  800827:	8b 45 08             	mov    0x8(%ebp),%eax
  80082a:	ff d0                	call   *%eax
  80082c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80082f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800832:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800835:	f7 d8                	neg    %eax
  800837:	83 d2 00             	adc    $0x0,%edx
  80083a:	f7 da                	neg    %edx
  80083c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80083f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800842:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800849:	e9 bc 00 00 00       	jmp    80090a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	ff 75 e8             	pushl  -0x18(%ebp)
  800854:	8d 45 14             	lea    0x14(%ebp),%eax
  800857:	50                   	push   %eax
  800858:	e8 84 fc ff ff       	call   8004e1 <getuint>
  80085d:	83 c4 10             	add    $0x10,%esp
  800860:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800863:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800866:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80086d:	e9 98 00 00 00       	jmp    80090a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	ff 75 0c             	pushl  0xc(%ebp)
  800878:	6a 58                	push   $0x58
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	ff d0                	call   *%eax
  80087f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	ff 75 0c             	pushl  0xc(%ebp)
  800888:	6a 58                	push   $0x58
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	ff d0                	call   *%eax
  80088f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	ff 75 0c             	pushl  0xc(%ebp)
  800898:	6a 58                	push   $0x58
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	ff d0                	call   *%eax
  80089f:	83 c4 10             	add    $0x10,%esp
			break;
  8008a2:	e9 bc 00 00 00       	jmp    800963 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	ff 75 0c             	pushl  0xc(%ebp)
  8008ad:	6a 30                	push   $0x30
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	ff d0                	call   *%eax
  8008b4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008b7:	83 ec 08             	sub    $0x8,%esp
  8008ba:	ff 75 0c             	pushl  0xc(%ebp)
  8008bd:	6a 78                	push   $0x78
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	ff d0                	call   *%eax
  8008c4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	83 c0 04             	add    $0x4,%eax
  8008cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 e8 04             	sub    $0x4,%eax
  8008d6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008e2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008e9:	eb 1f                	jmp    80090a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8008f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f4:	50                   	push   %eax
  8008f5:	e8 e7 fb ff ff       	call   8004e1 <getuint>
  8008fa:	83 c4 10             	add    $0x10,%esp
  8008fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800900:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800903:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80090a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80090e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800911:	83 ec 04             	sub    $0x4,%esp
  800914:	52                   	push   %edx
  800915:	ff 75 e4             	pushl  -0x1c(%ebp)
  800918:	50                   	push   %eax
  800919:	ff 75 f4             	pushl  -0xc(%ebp)
  80091c:	ff 75 f0             	pushl  -0x10(%ebp)
  80091f:	ff 75 0c             	pushl  0xc(%ebp)
  800922:	ff 75 08             	pushl  0x8(%ebp)
  800925:	e8 00 fb ff ff       	call   80042a <printnum>
  80092a:	83 c4 20             	add    $0x20,%esp
			break;
  80092d:	eb 34                	jmp    800963 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80092f:	83 ec 08             	sub    $0x8,%esp
  800932:	ff 75 0c             	pushl  0xc(%ebp)
  800935:	53                   	push   %ebx
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	ff d0                	call   *%eax
  80093b:	83 c4 10             	add    $0x10,%esp
			break;
  80093e:	eb 23                	jmp    800963 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	6a 25                	push   $0x25
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	ff d0                	call   *%eax
  80094d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800950:	ff 4d 10             	decl   0x10(%ebp)
  800953:	eb 03                	jmp    800958 <vprintfmt+0x3b1>
  800955:	ff 4d 10             	decl   0x10(%ebp)
  800958:	8b 45 10             	mov    0x10(%ebp),%eax
  80095b:	48                   	dec    %eax
  80095c:	8a 00                	mov    (%eax),%al
  80095e:	3c 25                	cmp    $0x25,%al
  800960:	75 f3                	jne    800955 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800962:	90                   	nop
		}
	}
  800963:	e9 47 fc ff ff       	jmp    8005af <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800968:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800969:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80096c:	5b                   	pop    %ebx
  80096d:	5e                   	pop    %esi
  80096e:	5d                   	pop    %ebp
  80096f:	c3                   	ret    

00800970 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800976:	8d 45 10             	lea    0x10(%ebp),%eax
  800979:	83 c0 04             	add    $0x4,%eax
  80097c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80097f:	8b 45 10             	mov    0x10(%ebp),%eax
  800982:	ff 75 f4             	pushl  -0xc(%ebp)
  800985:	50                   	push   %eax
  800986:	ff 75 0c             	pushl  0xc(%ebp)
  800989:	ff 75 08             	pushl  0x8(%ebp)
  80098c:	e8 16 fc ff ff       	call   8005a7 <vprintfmt>
  800991:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800994:	90                   	nop
  800995:	c9                   	leave  
  800996:	c3                   	ret    

00800997 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80099a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099d:	8b 40 08             	mov    0x8(%eax),%eax
  8009a0:	8d 50 01             	lea    0x1(%eax),%edx
  8009a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ac:	8b 10                	mov    (%eax),%edx
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	8b 40 04             	mov    0x4(%eax),%eax
  8009b4:	39 c2                	cmp    %eax,%edx
  8009b6:	73 12                	jae    8009ca <sprintputch+0x33>
		*b->buf++ = ch;
  8009b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	8d 48 01             	lea    0x1(%eax),%ecx
  8009c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c3:	89 0a                	mov    %ecx,(%edx)
  8009c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c8:	88 10                	mov    %dl,(%eax)
}
  8009ca:	90                   	nop
  8009cb:	5d                   	pop    %ebp
  8009cc:	c3                   	ret    

008009cd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	01 d0                	add    %edx,%eax
  8009e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009f2:	74 06                	je     8009fa <vsnprintf+0x2d>
  8009f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009f8:	7f 07                	jg     800a01 <vsnprintf+0x34>
		return -E_INVAL;
  8009fa:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ff:	eb 20                	jmp    800a21 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a01:	ff 75 14             	pushl  0x14(%ebp)
  800a04:	ff 75 10             	pushl  0x10(%ebp)
  800a07:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a0a:	50                   	push   %eax
  800a0b:	68 97 09 80 00       	push   $0x800997
  800a10:	e8 92 fb ff ff       	call   8005a7 <vprintfmt>
  800a15:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a1b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a21:	c9                   	leave  
  800a22:	c3                   	ret    

00800a23 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a29:	8d 45 10             	lea    0x10(%ebp),%eax
  800a2c:	83 c0 04             	add    $0x4,%eax
  800a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a32:	8b 45 10             	mov    0x10(%ebp),%eax
  800a35:	ff 75 f4             	pushl  -0xc(%ebp)
  800a38:	50                   	push   %eax
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	ff 75 08             	pushl  0x8(%ebp)
  800a3f:	e8 89 ff ff ff       	call   8009cd <vsnprintf>
  800a44:	83 c4 10             	add    $0x10,%esp
  800a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a5c:	eb 06                	jmp    800a64 <strlen+0x15>
		n++;
  800a5e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a61:	ff 45 08             	incl   0x8(%ebp)
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	8a 00                	mov    (%eax),%al
  800a69:	84 c0                	test   %al,%al
  800a6b:	75 f1                	jne    800a5e <strlen+0xf>
		n++;
	return n;
  800a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a7f:	eb 09                	jmp    800a8a <strnlen+0x18>
		n++;
  800a81:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a84:	ff 45 08             	incl   0x8(%ebp)
  800a87:	ff 4d 0c             	decl   0xc(%ebp)
  800a8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8e:	74 09                	je     800a99 <strnlen+0x27>
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8a 00                	mov    (%eax),%al
  800a95:	84 c0                	test   %al,%al
  800a97:	75 e8                	jne    800a81 <strnlen+0xf>
		n++;
	return n;
  800a99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a9c:	c9                   	leave  
  800a9d:	c3                   	ret    

00800a9e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a9e:	55                   	push   %ebp
  800a9f:	89 e5                	mov    %esp,%ebp
  800aa1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800aaa:	90                   	nop
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8d 50 01             	lea    0x1(%eax),%edx
  800ab1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ab4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800abd:	8a 12                	mov    (%edx),%dl
  800abf:	88 10                	mov    %dl,(%eax)
  800ac1:	8a 00                	mov    (%eax),%al
  800ac3:	84 c0                	test   %al,%al
  800ac5:	75 e4                	jne    800aab <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ac7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aca:	c9                   	leave  
  800acb:	c3                   	ret    

00800acc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ad8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800adf:	eb 1f                	jmp    800b00 <strncpy+0x34>
		*dst++ = *src;
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8d 50 01             	lea    0x1(%eax),%edx
  800ae7:	89 55 08             	mov    %edx,0x8(%ebp)
  800aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aed:	8a 12                	mov    (%edx),%dl
  800aef:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af4:	8a 00                	mov    (%eax),%al
  800af6:	84 c0                	test   %al,%al
  800af8:	74 03                	je     800afd <strncpy+0x31>
			src++;
  800afa:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800afd:	ff 45 fc             	incl   -0x4(%ebp)
  800b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b03:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b06:	72 d9                	jb     800ae1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b08:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b0b:	c9                   	leave  
  800b0c:	c3                   	ret    

00800b0d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b1d:	74 30                	je     800b4f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b1f:	eb 16                	jmp    800b37 <strlcpy+0x2a>
			*dst++ = *src++;
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	8d 50 01             	lea    0x1(%eax),%edx
  800b27:	89 55 08             	mov    %edx,0x8(%ebp)
  800b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b30:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b33:	8a 12                	mov    (%edx),%dl
  800b35:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b37:	ff 4d 10             	decl   0x10(%ebp)
  800b3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3e:	74 09                	je     800b49 <strlcpy+0x3c>
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	8a 00                	mov    (%eax),%al
  800b45:	84 c0                	test   %al,%al
  800b47:	75 d8                	jne    800b21 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b55:	29 c2                	sub    %eax,%edx
  800b57:	89 d0                	mov    %edx,%eax
}
  800b59:	c9                   	leave  
  800b5a:	c3                   	ret    

00800b5b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b5e:	eb 06                	jmp    800b66 <strcmp+0xb>
		p++, q++;
  800b60:	ff 45 08             	incl   0x8(%ebp)
  800b63:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	84 c0                	test   %al,%al
  800b6d:	74 0e                	je     800b7d <strcmp+0x22>
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8a 10                	mov    (%eax),%dl
  800b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b77:	8a 00                	mov    (%eax),%al
  800b79:	38 c2                	cmp    %al,%dl
  800b7b:	74 e3                	je     800b60 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	8a 00                	mov    (%eax),%al
  800b82:	0f b6 d0             	movzbl %al,%edx
  800b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b88:	8a 00                	mov    (%eax),%al
  800b8a:	0f b6 c0             	movzbl %al,%eax
  800b8d:	29 c2                	sub    %eax,%edx
  800b8f:	89 d0                	mov    %edx,%eax
}
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b96:	eb 09                	jmp    800ba1 <strncmp+0xe>
		n--, p++, q++;
  800b98:	ff 4d 10             	decl   0x10(%ebp)
  800b9b:	ff 45 08             	incl   0x8(%ebp)
  800b9e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ba1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba5:	74 17                	je     800bbe <strncmp+0x2b>
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	74 0e                	je     800bbe <strncmp+0x2b>
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8a 10                	mov    (%eax),%dl
  800bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb8:	8a 00                	mov    (%eax),%al
  800bba:	38 c2                	cmp    %al,%dl
  800bbc:	74 da                	je     800b98 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800bbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc2:	75 07                	jne    800bcb <strncmp+0x38>
		return 0;
  800bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc9:	eb 14                	jmp    800bdf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	8a 00                	mov    (%eax),%al
  800bd0:	0f b6 d0             	movzbl %al,%edx
  800bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	0f b6 c0             	movzbl %al,%eax
  800bdb:	29 c2                	sub    %eax,%edx
  800bdd:	89 d0                	mov    %edx,%eax
}
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	83 ec 04             	sub    $0x4,%esp
  800be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bed:	eb 12                	jmp    800c01 <strchr+0x20>
		if (*s == c)
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8a 00                	mov    (%eax),%al
  800bf4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bf7:	75 05                	jne    800bfe <strchr+0x1d>
			return (char *) s;
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	eb 11                	jmp    800c0f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bfe:	ff 45 08             	incl   0x8(%ebp)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	84 c0                	test   %al,%al
  800c08:	75 e5                	jne    800bef <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c0f:	c9                   	leave  
  800c10:	c3                   	ret    

00800c11 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 04             	sub    $0x4,%esp
  800c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c1d:	eb 0d                	jmp    800c2c <strfind+0x1b>
		if (*s == c)
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8a 00                	mov    (%eax),%al
  800c24:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c27:	74 0e                	je     800c37 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c29:	ff 45 08             	incl   0x8(%ebp)
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	8a 00                	mov    (%eax),%al
  800c31:	84 c0                	test   %al,%al
  800c33:	75 ea                	jne    800c1f <strfind+0xe>
  800c35:	eb 01                	jmp    800c38 <strfind+0x27>
		if (*s == c)
			break;
  800c37:	90                   	nop
	return (char *) s;
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c3b:	c9                   	leave  
  800c3c:	c3                   	ret    

00800c3d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c49:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c4f:	eb 0e                	jmp    800c5f <memset+0x22>
		*p++ = c;
  800c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c54:	8d 50 01             	lea    0x1(%eax),%edx
  800c57:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c5f:	ff 4d f8             	decl   -0x8(%ebp)
  800c62:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c66:	79 e9                	jns    800c51 <memset+0x14>
		*p++ = c;

	return v;
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c7f:	eb 16                	jmp    800c97 <memcpy+0x2a>
		*d++ = *s++;
  800c81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c84:	8d 50 01             	lea    0x1(%eax),%edx
  800c87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c93:	8a 12                	mov    (%edx),%dl
  800c95:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c97:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca0:	85 c0                	test   %eax,%eax
  800ca2:	75 dd                	jne    800c81 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ca7:	c9                   	leave  
  800ca8:	c3                   	ret    

00800ca9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cc1:	73 50                	jae    800d13 <memmove+0x6a>
  800cc3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc9:	01 d0                	add    %edx,%eax
  800ccb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cce:	76 43                	jbe    800d13 <memmove+0x6a>
		s += n;
  800cd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cdc:	eb 10                	jmp    800cee <memmove+0x45>
			*--d = *--s;
  800cde:	ff 4d f8             	decl   -0x8(%ebp)
  800ce1:	ff 4d fc             	decl   -0x4(%ebp)
  800ce4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce7:	8a 10                	mov    (%eax),%dl
  800ce9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cec:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800cee:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cf4:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	75 e3                	jne    800cde <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cfb:	eb 23                	jmp    800d20 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d00:	8d 50 01             	lea    0x1(%eax),%edx
  800d03:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d0f:	8a 12                	mov    (%edx),%dl
  800d11:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d13:	8b 45 10             	mov    0x10(%ebp),%eax
  800d16:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d19:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1c:	85 c0                	test   %eax,%eax
  800d1e:	75 dd                	jne    800cfd <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d37:	eb 2a                	jmp    800d63 <memcmp+0x3e>
		if (*s1 != *s2)
  800d39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d3c:	8a 10                	mov    (%eax),%dl
  800d3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	38 c2                	cmp    %al,%dl
  800d45:	74 16                	je     800d5d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	0f b6 d0             	movzbl %al,%edx
  800d4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	0f b6 c0             	movzbl %al,%eax
  800d57:	29 c2                	sub    %eax,%edx
  800d59:	89 d0                	mov    %edx,%eax
  800d5b:	eb 18                	jmp    800d75 <memcmp+0x50>
		s1++, s2++;
  800d5d:	ff 45 fc             	incl   -0x4(%ebp)
  800d60:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d63:	8b 45 10             	mov    0x10(%ebp),%eax
  800d66:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d69:	89 55 10             	mov    %edx,0x10(%ebp)
  800d6c:	85 c0                	test   %eax,%eax
  800d6e:	75 c9                	jne    800d39 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d80:	8b 45 10             	mov    0x10(%ebp),%eax
  800d83:	01 d0                	add    %edx,%eax
  800d85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d88:	eb 15                	jmp    800d9f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f b6 d0             	movzbl %al,%edx
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	0f b6 c0             	movzbl %al,%eax
  800d98:	39 c2                	cmp    %eax,%edx
  800d9a:	74 0d                	je     800da9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d9c:	ff 45 08             	incl   0x8(%ebp)
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800da5:	72 e3                	jb     800d8a <memfind+0x13>
  800da7:	eb 01                	jmp    800daa <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800da9:	90                   	nop
	return (void *) s;
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800db5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800dbc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dc3:	eb 03                	jmp    800dc8 <strtol+0x19>
		s++;
  800dc5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	3c 20                	cmp    $0x20,%al
  800dcf:	74 f4                	je     800dc5 <strtol+0x16>
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	3c 09                	cmp    $0x9,%al
  800dd8:	74 eb                	je     800dc5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	3c 2b                	cmp    $0x2b,%al
  800de1:	75 05                	jne    800de8 <strtol+0x39>
		s++;
  800de3:	ff 45 08             	incl   0x8(%ebp)
  800de6:	eb 13                	jmp    800dfb <strtol+0x4c>
	else if (*s == '-')
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	3c 2d                	cmp    $0x2d,%al
  800def:	75 0a                	jne    800dfb <strtol+0x4c>
		s++, neg = 1;
  800df1:	ff 45 08             	incl   0x8(%ebp)
  800df4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dff:	74 06                	je     800e07 <strtol+0x58>
  800e01:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e05:	75 20                	jne    800e27 <strtol+0x78>
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	3c 30                	cmp    $0x30,%al
  800e0e:	75 17                	jne    800e27 <strtol+0x78>
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	40                   	inc    %eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	3c 78                	cmp    $0x78,%al
  800e18:	75 0d                	jne    800e27 <strtol+0x78>
		s += 2, base = 16;
  800e1a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e1e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e25:	eb 28                	jmp    800e4f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2b:	75 15                	jne    800e42 <strtol+0x93>
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	3c 30                	cmp    $0x30,%al
  800e34:	75 0c                	jne    800e42 <strtol+0x93>
		s++, base = 8;
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e40:	eb 0d                	jmp    800e4f <strtol+0xa0>
	else if (base == 0)
  800e42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e46:	75 07                	jne    800e4f <strtol+0xa0>
		base = 10;
  800e48:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	3c 2f                	cmp    $0x2f,%al
  800e56:	7e 19                	jle    800e71 <strtol+0xc2>
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	3c 39                	cmp    $0x39,%al
  800e5f:	7f 10                	jg     800e71 <strtol+0xc2>
			dig = *s - '0';
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	0f be c0             	movsbl %al,%eax
  800e69:	83 e8 30             	sub    $0x30,%eax
  800e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e6f:	eb 42                	jmp    800eb3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	3c 60                	cmp    $0x60,%al
  800e78:	7e 19                	jle    800e93 <strtol+0xe4>
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	3c 7a                	cmp    $0x7a,%al
  800e81:	7f 10                	jg     800e93 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8a 00                	mov    (%eax),%al
  800e88:	0f be c0             	movsbl %al,%eax
  800e8b:	83 e8 57             	sub    $0x57,%eax
  800e8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e91:	eb 20                	jmp    800eb3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	3c 40                	cmp    $0x40,%al
  800e9a:	7e 39                	jle    800ed5 <strtol+0x126>
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	3c 5a                	cmp    $0x5a,%al
  800ea3:	7f 30                	jg     800ed5 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	0f be c0             	movsbl %al,%eax
  800ead:	83 e8 37             	sub    $0x37,%eax
  800eb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eb6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800eb9:	7d 19                	jge    800ed4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ebb:	ff 45 08             	incl   0x8(%ebp)
  800ebe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ec5:	89 c2                	mov    %eax,%edx
  800ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eca:	01 d0                	add    %edx,%eax
  800ecc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ecf:	e9 7b ff ff ff       	jmp    800e4f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ed4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ed5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ed9:	74 08                	je     800ee3 <strtol+0x134>
		*endptr = (char *) s;
  800edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ede:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ee3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ee7:	74 07                	je     800ef0 <strtol+0x141>
  800ee9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eec:	f7 d8                	neg    %eax
  800eee:	eb 03                	jmp    800ef3 <strtol+0x144>
  800ef0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <ltostr>:

void
ltostr(long value, char *str)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800efb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f02:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f0d:	79 13                	jns    800f22 <ltostr+0x2d>
	{
		neg = 1;
  800f0f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f1c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f1f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f2a:	99                   	cltd   
  800f2b:	f7 f9                	idiv   %ecx
  800f2d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f33:	8d 50 01             	lea    0x1(%eax),%edx
  800f36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f39:	89 c2                	mov    %eax,%edx
  800f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3e:	01 d0                	add    %edx,%eax
  800f40:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f43:	83 c2 30             	add    $0x30,%edx
  800f46:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f4b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f50:	f7 e9                	imul   %ecx
  800f52:	c1 fa 02             	sar    $0x2,%edx
  800f55:	89 c8                	mov    %ecx,%eax
  800f57:	c1 f8 1f             	sar    $0x1f,%eax
  800f5a:	29 c2                	sub    %eax,%edx
  800f5c:	89 d0                	mov    %edx,%eax
  800f5e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f64:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f69:	f7 e9                	imul   %ecx
  800f6b:	c1 fa 02             	sar    $0x2,%edx
  800f6e:	89 c8                	mov    %ecx,%eax
  800f70:	c1 f8 1f             	sar    $0x1f,%eax
  800f73:	29 c2                	sub    %eax,%edx
  800f75:	89 d0                	mov    %edx,%eax
  800f77:	c1 e0 02             	shl    $0x2,%eax
  800f7a:	01 d0                	add    %edx,%eax
  800f7c:	01 c0                	add    %eax,%eax
  800f7e:	29 c1                	sub    %eax,%ecx
  800f80:	89 ca                	mov    %ecx,%edx
  800f82:	85 d2                	test   %edx,%edx
  800f84:	75 9c                	jne    800f22 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f90:	48                   	dec    %eax
  800f91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f94:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f98:	74 3d                	je     800fd7 <ltostr+0xe2>
		start = 1 ;
  800f9a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fa1:	eb 34                	jmp    800fd7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800fa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa9:	01 d0                	add    %edx,%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	01 c2                	add    %eax,%edx
  800fb8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	01 c8                	add    %ecx,%eax
  800fc0:	8a 00                	mov    (%eax),%al
  800fc2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fca:	01 c2                	add    %eax,%edx
  800fcc:	8a 45 eb             	mov    -0x15(%ebp),%al
  800fcf:	88 02                	mov    %al,(%edx)
		start++ ;
  800fd1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800fd4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fda:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fdd:	7c c4                	jl     800fa3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800fdf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe5:	01 d0                	add    %edx,%eax
  800fe7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800fea:	90                   	nop
  800feb:	c9                   	leave  
  800fec:	c3                   	ret    

00800fed <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ff3:	ff 75 08             	pushl  0x8(%ebp)
  800ff6:	e8 54 fa ff ff       	call   800a4f <strlen>
  800ffb:	83 c4 04             	add    $0x4,%esp
  800ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	e8 46 fa ff ff       	call   800a4f <strlen>
  801009:	83 c4 04             	add    $0x4,%esp
  80100c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80100f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801016:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80101d:	eb 17                	jmp    801036 <strcconcat+0x49>
		final[s] = str1[s] ;
  80101f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	01 c2                	add    %eax,%edx
  801027:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	01 c8                	add    %ecx,%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801033:	ff 45 fc             	incl   -0x4(%ebp)
  801036:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801039:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80103c:	7c e1                	jl     80101f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80103e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801045:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80104c:	eb 1f                	jmp    80106d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80104e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801051:	8d 50 01             	lea    0x1(%eax),%edx
  801054:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801057:	89 c2                	mov    %eax,%edx
  801059:	8b 45 10             	mov    0x10(%ebp),%eax
  80105c:	01 c2                	add    %eax,%edx
  80105e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801061:	8b 45 0c             	mov    0xc(%ebp),%eax
  801064:	01 c8                	add    %ecx,%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80106a:	ff 45 f8             	incl   -0x8(%ebp)
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801070:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801073:	7c d9                	jl     80104e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801075:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	01 d0                	add    %edx,%eax
  80107d:	c6 00 00             	movb   $0x0,(%eax)
}
  801080:	90                   	nop
  801081:	c9                   	leave  
  801082:	c3                   	ret    

00801083 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801086:	8b 45 14             	mov    0x14(%ebp),%eax
  801089:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80108f:	8b 45 14             	mov    0x14(%ebp),%eax
  801092:	8b 00                	mov    (%eax),%eax
  801094:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80109b:	8b 45 10             	mov    0x10(%ebp),%eax
  80109e:	01 d0                	add    %edx,%eax
  8010a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010a6:	eb 0c                	jmp    8010b4 <strsplit+0x31>
			*string++ = 0;
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	8d 50 01             	lea    0x1(%eax),%edx
  8010ae:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	84 c0                	test   %al,%al
  8010bb:	74 18                	je     8010d5 <strsplit+0x52>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	0f be c0             	movsbl %al,%eax
  8010c5:	50                   	push   %eax
  8010c6:	ff 75 0c             	pushl  0xc(%ebp)
  8010c9:	e8 13 fb ff ff       	call   800be1 <strchr>
  8010ce:	83 c4 08             	add    $0x8,%esp
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	75 d3                	jne    8010a8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	84 c0                	test   %al,%al
  8010dc:	74 5a                	je     801138 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010de:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e1:	8b 00                	mov    (%eax),%eax
  8010e3:	83 f8 0f             	cmp    $0xf,%eax
  8010e6:	75 07                	jne    8010ef <strsplit+0x6c>
		{
			return 0;
  8010e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ed:	eb 66                	jmp    801155 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f2:	8b 00                	mov    (%eax),%eax
  8010f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8010f7:	8b 55 14             	mov    0x14(%ebp),%edx
  8010fa:	89 0a                	mov    %ecx,(%edx)
  8010fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801103:	8b 45 10             	mov    0x10(%ebp),%eax
  801106:	01 c2                	add    %eax,%edx
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80110d:	eb 03                	jmp    801112 <strsplit+0x8f>
			string++;
  80110f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	84 c0                	test   %al,%al
  801119:	74 8b                	je     8010a6 <strsplit+0x23>
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	0f be c0             	movsbl %al,%eax
  801123:	50                   	push   %eax
  801124:	ff 75 0c             	pushl  0xc(%ebp)
  801127:	e8 b5 fa ff ff       	call   800be1 <strchr>
  80112c:	83 c4 08             	add    $0x8,%esp
  80112f:	85 c0                	test   %eax,%eax
  801131:	74 dc                	je     80110f <strsplit+0x8c>
			string++;
	}
  801133:	e9 6e ff ff ff       	jmp    8010a6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801138:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801139:	8b 45 14             	mov    0x14(%ebp),%eax
  80113c:	8b 00                	mov    (%eax),%eax
  80113e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801145:	8b 45 10             	mov    0x10(%ebp),%eax
  801148:	01 d0                	add    %edx,%eax
  80114a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801150:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80115d:	83 ec 04             	sub    $0x4,%esp
  801160:	68 10 22 80 00       	push   $0x802210
  801165:	6a 19                	push   $0x19
  801167:	68 35 22 80 00       	push   $0x802235
  80116c:	e8 9e 07 00 00       	call   80190f <_panic>

00801171 <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	83 ec 18             	sub    $0x18,%esp
  801177:	8b 45 10             	mov    0x10(%ebp),%eax
  80117a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80117d:	83 ec 04             	sub    $0x4,%esp
  801180:	68 44 22 80 00       	push   $0x802244
  801185:	6a 31                	push   $0x31
  801187:	68 35 22 80 00       	push   $0x802235
  80118c:	e8 7e 07 00 00       	call   80190f <_panic>

00801191 <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801197:	83 ec 04             	sub    $0x4,%esp
  80119a:	68 6c 22 80 00       	push   $0x80226c
  80119f:	6a 4a                	push   $0x4a
  8011a1:	68 35 22 80 00       	push   $0x802235
  8011a6:	e8 64 07 00 00       	call   80190f <_panic>

008011ab <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8011b1:	83 ec 04             	sub    $0x4,%esp
  8011b4:	68 90 22 80 00       	push   $0x802290
  8011b9:	6a 70                	push   $0x70
  8011bb:	68 35 22 80 00       	push   $0x802235
  8011c0:	e8 4a 07 00 00       	call   80190f <_panic>

008011c5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8011cb:	83 ec 04             	sub    $0x4,%esp
  8011ce:	68 b4 22 80 00       	push   $0x8022b4
  8011d3:	68 8b 00 00 00       	push   $0x8b
  8011d8:	68 35 22 80 00       	push   $0x802235
  8011dd:	e8 2d 07 00 00       	call   80190f <_panic>

008011e2 <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8011e8:	83 ec 04             	sub    $0x4,%esp
  8011eb:	68 d8 22 80 00       	push   $0x8022d8
  8011f0:	68 a8 00 00 00       	push   $0xa8
  8011f5:	68 35 22 80 00       	push   $0x802235
  8011fa:	e8 10 07 00 00       	call   80190f <_panic>

008011ff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	57                   	push   %edi
  801203:	56                   	push   %esi
  801204:	53                   	push   %ebx
  801205:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801211:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801214:	8b 7d 18             	mov    0x18(%ebp),%edi
  801217:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80121a:	cd 30                	int    $0x30
  80121c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80121f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801222:	83 c4 10             	add    $0x10,%esp
  801225:	5b                   	pop    %ebx
  801226:	5e                   	pop    %esi
  801227:	5f                   	pop    %edi
  801228:	5d                   	pop    %ebp
  801229:	c3                   	ret    

0080122a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	83 ec 04             	sub    $0x4,%esp
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801236:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	6a 00                	push   $0x0
  80123f:	6a 00                	push   $0x0
  801241:	52                   	push   %edx
  801242:	ff 75 0c             	pushl  0xc(%ebp)
  801245:	50                   	push   %eax
  801246:	6a 00                	push   $0x0
  801248:	e8 b2 ff ff ff       	call   8011ff <syscall>
  80124d:	83 c4 18             	add    $0x18,%esp
}
  801250:	90                   	nop
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <sys_cgetc>:

int
sys_cgetc(void)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	6a 00                	push   $0x0
  80125c:	6a 00                	push   $0x0
  80125e:	6a 00                	push   $0x0
  801260:	6a 01                	push   $0x1
  801262:	e8 98 ff ff ff       	call   8011ff <syscall>
  801267:	83 c4 18             	add    $0x18,%esp
}
  80126a:	c9                   	leave  
  80126b:	c3                   	ret    

0080126c <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	6a 00                	push   $0x0
  801274:	6a 00                	push   $0x0
  801276:	6a 00                	push   $0x0
  801278:	6a 00                	push   $0x0
  80127a:	50                   	push   %eax
  80127b:	6a 05                	push   $0x5
  80127d:	e8 7d ff ff ff       	call   8011ff <syscall>
  801282:	83 c4 18             	add    $0x18,%esp
}
  801285:	c9                   	leave  
  801286:	c3                   	ret    

00801287 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80128a:	6a 00                	push   $0x0
  80128c:	6a 00                	push   $0x0
  80128e:	6a 00                	push   $0x0
  801290:	6a 00                	push   $0x0
  801292:	6a 00                	push   $0x0
  801294:	6a 02                	push   $0x2
  801296:	e8 64 ff ff ff       	call   8011ff <syscall>
  80129b:	83 c4 18             	add    $0x18,%esp
}
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    

008012a0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8012a3:	6a 00                	push   $0x0
  8012a5:	6a 00                	push   $0x0
  8012a7:	6a 00                	push   $0x0
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 03                	push   $0x3
  8012af:	e8 4b ff ff ff       	call   8011ff <syscall>
  8012b4:	83 c4 18             	add    $0x18,%esp
}
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8012bc:	6a 00                	push   $0x0
  8012be:	6a 00                	push   $0x0
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 04                	push   $0x4
  8012c8:	e8 32 ff ff ff       	call   8011ff <syscall>
  8012cd:	83 c4 18             	add    $0x18,%esp
}
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    

008012d2 <sys_env_exit>:


void sys_env_exit(void)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8012d5:	6a 00                	push   $0x0
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 00                	push   $0x0
  8012dd:	6a 00                	push   $0x0
  8012df:	6a 06                	push   $0x6
  8012e1:	e8 19 ff ff ff       	call   8011ff <syscall>
  8012e6:	83 c4 18             	add    $0x18,%esp
}
  8012e9:	90                   	nop
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    

008012ec <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	52                   	push   %edx
  8012fc:	50                   	push   %eax
  8012fd:	6a 07                	push   $0x7
  8012ff:	e8 fb fe ff ff       	call   8011ff <syscall>
  801304:	83 c4 18             	add    $0x18,%esp
}
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	56                   	push   %esi
  80130d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80130e:	8b 75 18             	mov    0x18(%ebp),%esi
  801311:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801314:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	56                   	push   %esi
  80131e:	53                   	push   %ebx
  80131f:	51                   	push   %ecx
  801320:	52                   	push   %edx
  801321:	50                   	push   %eax
  801322:	6a 08                	push   $0x8
  801324:	e8 d6 fe ff ff       	call   8011ff <syscall>
  801329:	83 c4 18             	add    $0x18,%esp
}
  80132c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80132f:	5b                   	pop    %ebx
  801330:	5e                   	pop    %esi
  801331:	5d                   	pop    %ebp
  801332:	c3                   	ret    

00801333 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801336:	8b 55 0c             	mov    0xc(%ebp),%edx
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	52                   	push   %edx
  801343:	50                   	push   %eax
  801344:	6a 09                	push   $0x9
  801346:	e8 b4 fe ff ff       	call   8011ff <syscall>
  80134b:	83 c4 18             	add    $0x18,%esp
}
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	ff 75 0c             	pushl  0xc(%ebp)
  80135c:	ff 75 08             	pushl  0x8(%ebp)
  80135f:	6a 0a                	push   $0xa
  801361:	e8 99 fe ff ff       	call   8011ff <syscall>
  801366:	83 c4 18             	add    $0x18,%esp
}
  801369:	c9                   	leave  
  80136a:	c3                   	ret    

0080136b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 0b                	push   $0xb
  80137a:	e8 80 fe ff ff       	call   8011ff <syscall>
  80137f:	83 c4 18             	add    $0x18,%esp
}
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 0c                	push   $0xc
  801393:	e8 67 fe ff ff       	call   8011ff <syscall>
  801398:	83 c4 18             	add    $0x18,%esp
}
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 0d                	push   $0xd
  8013ac:	e8 4e fe ff ff       	call   8011ff <syscall>
  8013b1:	83 c4 18             	add    $0x18,%esp
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	ff 75 0c             	pushl  0xc(%ebp)
  8013c2:	ff 75 08             	pushl  0x8(%ebp)
  8013c5:	6a 11                	push   $0x11
  8013c7:	e8 33 fe ff ff       	call   8011ff <syscall>
  8013cc:	83 c4 18             	add    $0x18,%esp
	return;
  8013cf:	90                   	nop
}
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	ff 75 0c             	pushl  0xc(%ebp)
  8013de:	ff 75 08             	pushl  0x8(%ebp)
  8013e1:	6a 12                	push   $0x12
  8013e3:	e8 17 fe ff ff       	call   8011ff <syscall>
  8013e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8013eb:	90                   	nop
}
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 0e                	push   $0xe
  8013fd:	e8 fd fd ff ff       	call   8011ff <syscall>
  801402:	83 c4 18             	add    $0x18,%esp
}
  801405:	c9                   	leave  
  801406:	c3                   	ret    

00801407 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	ff 75 08             	pushl  0x8(%ebp)
  801415:	6a 0f                	push   $0xf
  801417:	e8 e3 fd ff ff       	call   8011ff <syscall>
  80141c:	83 c4 18             	add    $0x18,%esp
}
  80141f:	c9                   	leave  
  801420:	c3                   	ret    

00801421 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 10                	push   $0x10
  801430:	e8 ca fd ff ff       	call   8011ff <syscall>
  801435:	83 c4 18             	add    $0x18,%esp
}
  801438:	90                   	nop
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 14                	push   $0x14
  80144a:	e8 b0 fd ff ff       	call   8011ff <syscall>
  80144f:	83 c4 18             	add    $0x18,%esp
}
  801452:	90                   	nop
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 15                	push   $0x15
  801464:	e8 96 fd ff ff       	call   8011ff <syscall>
  801469:	83 c4 18             	add    $0x18,%esp
}
  80146c:	90                   	nop
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <sys_cputc>:


void
sys_cputc(const char c)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	83 ec 04             	sub    $0x4,%esp
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80147b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	50                   	push   %eax
  801488:	6a 16                	push   $0x16
  80148a:	e8 70 fd ff ff       	call   8011ff <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
}
  801492:	90                   	nop
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 17                	push   $0x17
  8014a4:	e8 56 fd ff ff       	call   8011ff <syscall>
  8014a9:	83 c4 18             	add    $0x18,%esp
}
  8014ac:	90                   	nop
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	ff 75 0c             	pushl  0xc(%ebp)
  8014be:	50                   	push   %eax
  8014bf:	6a 18                	push   $0x18
  8014c1:	e8 39 fd ff ff       	call   8011ff <syscall>
  8014c6:	83 c4 18             	add    $0x18,%esp
}
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	52                   	push   %edx
  8014db:	50                   	push   %eax
  8014dc:	6a 1b                	push   $0x1b
  8014de:	e8 1c fd ff ff       	call   8011ff <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	52                   	push   %edx
  8014f8:	50                   	push   %eax
  8014f9:	6a 19                	push   $0x19
  8014fb:	e8 ff fc ff ff       	call   8011ff <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
}
  801503:	90                   	nop
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801509:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	52                   	push   %edx
  801516:	50                   	push   %eax
  801517:	6a 1a                	push   $0x1a
  801519:	e8 e1 fc ff ff       	call   8011ff <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
}
  801521:	90                   	nop
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 04             	sub    $0x4,%esp
  80152a:	8b 45 10             	mov    0x10(%ebp),%eax
  80152d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801530:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801533:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	6a 00                	push   $0x0
  80153c:	51                   	push   %ecx
  80153d:	52                   	push   %edx
  80153e:	ff 75 0c             	pushl  0xc(%ebp)
  801541:	50                   	push   %eax
  801542:	6a 1c                	push   $0x1c
  801544:	e8 b6 fc ff ff       	call   8011ff <syscall>
  801549:	83 c4 18             	add    $0x18,%esp
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	52                   	push   %edx
  80155e:	50                   	push   %eax
  80155f:	6a 1d                	push   $0x1d
  801561:	e8 99 fc ff ff       	call   8011ff <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80156e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801571:	8b 55 0c             	mov    0xc(%ebp),%edx
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	51                   	push   %ecx
  80157c:	52                   	push   %edx
  80157d:	50                   	push   %eax
  80157e:	6a 1e                	push   $0x1e
  801580:	e8 7a fc ff ff       	call   8011ff <syscall>
  801585:	83 c4 18             	add    $0x18,%esp
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80158d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	52                   	push   %edx
  80159a:	50                   	push   %eax
  80159b:	6a 1f                	push   $0x1f
  80159d:	e8 5d fc ff ff       	call   8011ff <syscall>
  8015a2:	83 c4 18             	add    $0x18,%esp
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 20                	push   $0x20
  8015b6:	e8 44 fc ff ff       	call   8011ff <syscall>
  8015bb:	83 c4 18             	add    $0x18,%esp
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	ff 75 10             	pushl  0x10(%ebp)
  8015cd:	ff 75 0c             	pushl  0xc(%ebp)
  8015d0:	50                   	push   %eax
  8015d1:	6a 21                	push   $0x21
  8015d3:	e8 27 fc ff ff       	call   8011ff <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_run_env>:


void
sys_run_env(int32 envId)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	50                   	push   %eax
  8015ec:	6a 22                	push   $0x22
  8015ee:	e8 0c fc ff ff       	call   8011ff <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	90                   	nop
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	50                   	push   %eax
  801608:	6a 23                	push   $0x23
  80160a:	e8 f0 fb ff ff       	call   8011ff <syscall>
  80160f:	83 c4 18             	add    $0x18,%esp
}
  801612:	90                   	nop
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80161b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80161e:	8d 50 04             	lea    0x4(%eax),%edx
  801621:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	52                   	push   %edx
  80162b:	50                   	push   %eax
  80162c:	6a 24                	push   $0x24
  80162e:	e8 cc fb ff ff       	call   8011ff <syscall>
  801633:	83 c4 18             	add    $0x18,%esp
	return result;
  801636:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801639:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163f:	89 01                	mov    %eax,(%ecx)
  801641:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	c9                   	leave  
  801648:	c2 04 00             	ret    $0x4

0080164b <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	ff 75 10             	pushl  0x10(%ebp)
  801655:	ff 75 0c             	pushl  0xc(%ebp)
  801658:	ff 75 08             	pushl  0x8(%ebp)
  80165b:	6a 13                	push   $0x13
  80165d:	e8 9d fb ff ff       	call   8011ff <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
	return ;
  801665:	90                   	nop
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <sys_rcr2>:
uint32 sys_rcr2()
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 25                	push   $0x25
  801677:	e8 83 fb ff ff       	call   8011ff <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 04             	sub    $0x4,%esp
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80168d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	50                   	push   %eax
  80169a:	6a 26                	push   $0x26
  80169c:	e8 5e fb ff ff       	call   8011ff <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a4:	90                   	nop
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <rsttst>:
void rsttst()
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 28                	push   $0x28
  8016b6:	e8 44 fb ff ff       	call   8011ff <syscall>
  8016bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8016be:	90                   	nop
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016cd:	8b 55 18             	mov    0x18(%ebp),%edx
  8016d0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016d4:	52                   	push   %edx
  8016d5:	50                   	push   %eax
  8016d6:	ff 75 10             	pushl  0x10(%ebp)
  8016d9:	ff 75 0c             	pushl  0xc(%ebp)
  8016dc:	ff 75 08             	pushl  0x8(%ebp)
  8016df:	6a 27                	push   $0x27
  8016e1:	e8 19 fb ff ff       	call   8011ff <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e9:	90                   	nop
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <chktst>:
void chktst(uint32 n)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	ff 75 08             	pushl  0x8(%ebp)
  8016fa:	6a 29                	push   $0x29
  8016fc:	e8 fe fa ff ff       	call   8011ff <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
	return ;
  801704:	90                   	nop
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <inctst>:

void inctst()
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 2a                	push   $0x2a
  801716:	e8 e4 fa ff ff       	call   8011ff <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
	return ;
  80171e:	90                   	nop
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <gettst>:
uint32 gettst()
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 2b                	push   $0x2b
  801730:	e8 ca fa ff ff       	call   8011ff <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 2c                	push   $0x2c
  80174c:	e8 ae fa ff ff       	call   8011ff <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
  801754:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801757:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80175b:	75 07                	jne    801764 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80175d:	b8 01 00 00 00       	mov    $0x1,%eax
  801762:	eb 05                	jmp    801769 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801764:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 2c                	push   $0x2c
  80177d:	e8 7d fa ff ff       	call   8011ff <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
  801785:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801788:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80178c:	75 07                	jne    801795 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80178e:	b8 01 00 00 00       	mov    $0x1,%eax
  801793:	eb 05                	jmp    80179a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 2c                	push   $0x2c
  8017ae:	e8 4c fa ff ff       	call   8011ff <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
  8017b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017b9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017bd:	75 07                	jne    8017c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c4:	eb 05                	jmp    8017cb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 2c                	push   $0x2c
  8017df:	e8 1b fa ff ff       	call   8011ff <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
  8017e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017ea:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017ee:	75 07                	jne    8017f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f5:	eb 05                	jmp    8017fc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	ff 75 08             	pushl  0x8(%ebp)
  80180c:	6a 2d                	push   $0x2d
  80180e:	e8 ec f9 ff ff       	call   8011ff <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
	return ;
  801816:	90                   	nop
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80181d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801820:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801823:	8b 55 0c             	mov    0xc(%ebp),%edx
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	6a 00                	push   $0x0
  80182b:	53                   	push   %ebx
  80182c:	51                   	push   %ecx
  80182d:	52                   	push   %edx
  80182e:	50                   	push   %eax
  80182f:	6a 2e                	push   $0x2e
  801831:	e8 c9 f9 ff ff       	call   8011ff <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801841:	8b 55 0c             	mov    0xc(%ebp),%edx
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	52                   	push   %edx
  80184e:	50                   	push   %eax
  80184f:	6a 2f                	push   $0x2f
  801851:	e8 a9 f9 ff ff       	call   8011ff <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801861:	8b 55 08             	mov    0x8(%ebp),%edx
  801864:	89 d0                	mov    %edx,%eax
  801866:	c1 e0 02             	shl    $0x2,%eax
  801869:	01 d0                	add    %edx,%eax
  80186b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801872:	01 d0                	add    %edx,%eax
  801874:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80187b:	01 d0                	add    %edx,%eax
  80187d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801884:	01 d0                	add    %edx,%eax
  801886:	c1 e0 04             	shl    $0x4,%eax
  801889:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80188c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801893:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801896:	83 ec 0c             	sub    $0xc,%esp
  801899:	50                   	push   %eax
  80189a:	e8 76 fd ff ff       	call   801615 <sys_get_virtual_time>
  80189f:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8018a2:	eb 41                	jmp    8018e5 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8018a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018a7:	83 ec 0c             	sub    $0xc,%esp
  8018aa:	50                   	push   %eax
  8018ab:	e8 65 fd ff ff       	call   801615 <sys_get_virtual_time>
  8018b0:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8018b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b9:	29 c2                	sub    %eax,%edx
  8018bb:	89 d0                	mov    %edx,%eax
  8018bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8018c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c6:	89 d1                	mov    %edx,%ecx
  8018c8:	29 c1                	sub    %eax,%ecx
  8018ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d0:	39 c2                	cmp    %eax,%edx
  8018d2:	0f 97 c0             	seta   %al
  8018d5:	0f b6 c0             	movzbl %al,%eax
  8018d8:	29 c1                	sub    %eax,%ecx
  8018da:	89 c8                	mov    %ecx,%eax
  8018dc:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8018df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018eb:	72 b7                	jb     8018a4 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8018ed:	90                   	nop
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8018f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8018fd:	eb 03                	jmp    801902 <busy_wait+0x12>
  8018ff:	ff 45 fc             	incl   -0x4(%ebp)
  801902:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801905:	3b 45 08             	cmp    0x8(%ebp),%eax
  801908:	72 f5                	jb     8018ff <busy_wait+0xf>
	return i;
  80190a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801915:	8d 45 10             	lea    0x10(%ebp),%eax
  801918:	83 c0 04             	add    $0x4,%eax
  80191b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80191e:	a1 18 31 80 00       	mov    0x803118,%eax
  801923:	85 c0                	test   %eax,%eax
  801925:	74 16                	je     80193d <_panic+0x2e>
		cprintf("%s: ", argv0);
  801927:	a1 18 31 80 00       	mov    0x803118,%eax
  80192c:	83 ec 08             	sub    $0x8,%esp
  80192f:	50                   	push   %eax
  801930:	68 00 23 80 00       	push   $0x802300
  801935:	e8 93 ea ff ff       	call   8003cd <cprintf>
  80193a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80193d:	a1 00 30 80 00       	mov    0x803000,%eax
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	ff 75 08             	pushl  0x8(%ebp)
  801948:	50                   	push   %eax
  801949:	68 05 23 80 00       	push   $0x802305
  80194e:	e8 7a ea ff ff       	call   8003cd <cprintf>
  801953:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801956:	8b 45 10             	mov    0x10(%ebp),%eax
  801959:	83 ec 08             	sub    $0x8,%esp
  80195c:	ff 75 f4             	pushl  -0xc(%ebp)
  80195f:	50                   	push   %eax
  801960:	e8 fd e9 ff ff       	call   800362 <vcprintf>
  801965:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801968:	83 ec 08             	sub    $0x8,%esp
  80196b:	6a 00                	push   $0x0
  80196d:	68 21 23 80 00       	push   $0x802321
  801972:	e8 eb e9 ff ff       	call   800362 <vcprintf>
  801977:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80197a:	e8 6c e9 ff ff       	call   8002eb <exit>

	// should not return here
	while (1) ;
  80197f:	eb fe                	jmp    80197f <_panic+0x70>

00801981 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801987:	a1 20 30 80 00       	mov    0x803020,%eax
  80198c:	8b 50 74             	mov    0x74(%eax),%edx
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	39 c2                	cmp    %eax,%edx
  801994:	74 14                	je     8019aa <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801996:	83 ec 04             	sub    $0x4,%esp
  801999:	68 24 23 80 00       	push   $0x802324
  80199e:	6a 26                	push   $0x26
  8019a0:	68 70 23 80 00       	push   $0x802370
  8019a5:	e8 65 ff ff ff       	call   80190f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019b8:	e9 b6 00 00 00       	jmp    801a73 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8019bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	01 d0                	add    %edx,%eax
  8019cc:	8b 00                	mov    (%eax),%eax
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	75 08                	jne    8019da <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8019d2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8019d5:	e9 96 00 00 00       	jmp    801a70 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8019da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019e1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8019e8:	eb 5d                	jmp    801a47 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8019ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8019ef:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8019f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019f8:	c1 e2 04             	shl    $0x4,%edx
  8019fb:	01 d0                	add    %edx,%eax
  8019fd:	8a 40 04             	mov    0x4(%eax),%al
  801a00:	84 c0                	test   %al,%al
  801a02:	75 40                	jne    801a44 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a04:	a1 20 30 80 00       	mov    0x803020,%eax
  801a09:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801a0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a12:	c1 e2 04             	shl    $0x4,%edx
  801a15:	01 d0                	add    %edx,%eax
  801a17:	8b 00                	mov    (%eax),%eax
  801a19:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a24:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a29:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	01 c8                	add    %ecx,%eax
  801a35:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a37:	39 c2                	cmp    %eax,%edx
  801a39:	75 09                	jne    801a44 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  801a3b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a42:	eb 12                	jmp    801a56 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a44:	ff 45 e8             	incl   -0x18(%ebp)
  801a47:	a1 20 30 80 00       	mov    0x803020,%eax
  801a4c:	8b 50 74             	mov    0x74(%eax),%edx
  801a4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a52:	39 c2                	cmp    %eax,%edx
  801a54:	77 94                	ja     8019ea <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a56:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a5a:	75 14                	jne    801a70 <CheckWSWithoutLastIndex+0xef>
			panic(
  801a5c:	83 ec 04             	sub    $0x4,%esp
  801a5f:	68 7c 23 80 00       	push   $0x80237c
  801a64:	6a 3a                	push   $0x3a
  801a66:	68 70 23 80 00       	push   $0x802370
  801a6b:	e8 9f fe ff ff       	call   80190f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a70:	ff 45 f0             	incl   -0x10(%ebp)
  801a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a76:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a79:	0f 8c 3e ff ff ff    	jl     8019bd <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a7f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a86:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a8d:	eb 20                	jmp    801aaf <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a8f:	a1 20 30 80 00       	mov    0x803020,%eax
  801a94:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801a9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a9d:	c1 e2 04             	shl    $0x4,%edx
  801aa0:	01 d0                	add    %edx,%eax
  801aa2:	8a 40 04             	mov    0x4(%eax),%al
  801aa5:	3c 01                	cmp    $0x1,%al
  801aa7:	75 03                	jne    801aac <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  801aa9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aac:	ff 45 e0             	incl   -0x20(%ebp)
  801aaf:	a1 20 30 80 00       	mov    0x803020,%eax
  801ab4:	8b 50 74             	mov    0x74(%eax),%edx
  801ab7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aba:	39 c2                	cmp    %eax,%edx
  801abc:	77 d1                	ja     801a8f <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ac4:	74 14                	je     801ada <CheckWSWithoutLastIndex+0x159>
		panic(
  801ac6:	83 ec 04             	sub    $0x4,%esp
  801ac9:	68 d0 23 80 00       	push   $0x8023d0
  801ace:	6a 44                	push   $0x44
  801ad0:	68 70 23 80 00       	push   $0x802370
  801ad5:	e8 35 fe ff ff       	call   80190f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801ada:	90                   	nop
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    
  801add:	66 90                	xchg   %ax,%ax
  801adf:	90                   	nop

00801ae0 <__udivdi3>:
  801ae0:	55                   	push   %ebp
  801ae1:	57                   	push   %edi
  801ae2:	56                   	push   %esi
  801ae3:	53                   	push   %ebx
  801ae4:	83 ec 1c             	sub    $0x1c,%esp
  801ae7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801aeb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801aef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801af3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801af7:	89 ca                	mov    %ecx,%edx
  801af9:	89 f8                	mov    %edi,%eax
  801afb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801aff:	85 f6                	test   %esi,%esi
  801b01:	75 2d                	jne    801b30 <__udivdi3+0x50>
  801b03:	39 cf                	cmp    %ecx,%edi
  801b05:	77 65                	ja     801b6c <__udivdi3+0x8c>
  801b07:	89 fd                	mov    %edi,%ebp
  801b09:	85 ff                	test   %edi,%edi
  801b0b:	75 0b                	jne    801b18 <__udivdi3+0x38>
  801b0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b12:	31 d2                	xor    %edx,%edx
  801b14:	f7 f7                	div    %edi
  801b16:	89 c5                	mov    %eax,%ebp
  801b18:	31 d2                	xor    %edx,%edx
  801b1a:	89 c8                	mov    %ecx,%eax
  801b1c:	f7 f5                	div    %ebp
  801b1e:	89 c1                	mov    %eax,%ecx
  801b20:	89 d8                	mov    %ebx,%eax
  801b22:	f7 f5                	div    %ebp
  801b24:	89 cf                	mov    %ecx,%edi
  801b26:	89 fa                	mov    %edi,%edx
  801b28:	83 c4 1c             	add    $0x1c,%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5f                   	pop    %edi
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    
  801b30:	39 ce                	cmp    %ecx,%esi
  801b32:	77 28                	ja     801b5c <__udivdi3+0x7c>
  801b34:	0f bd fe             	bsr    %esi,%edi
  801b37:	83 f7 1f             	xor    $0x1f,%edi
  801b3a:	75 40                	jne    801b7c <__udivdi3+0x9c>
  801b3c:	39 ce                	cmp    %ecx,%esi
  801b3e:	72 0a                	jb     801b4a <__udivdi3+0x6a>
  801b40:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b44:	0f 87 9e 00 00 00    	ja     801be8 <__udivdi3+0x108>
  801b4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b4f:	89 fa                	mov    %edi,%edx
  801b51:	83 c4 1c             	add    $0x1c,%esp
  801b54:	5b                   	pop    %ebx
  801b55:	5e                   	pop    %esi
  801b56:	5f                   	pop    %edi
  801b57:	5d                   	pop    %ebp
  801b58:	c3                   	ret    
  801b59:	8d 76 00             	lea    0x0(%esi),%esi
  801b5c:	31 ff                	xor    %edi,%edi
  801b5e:	31 c0                	xor    %eax,%eax
  801b60:	89 fa                	mov    %edi,%edx
  801b62:	83 c4 1c             	add    $0x1c,%esp
  801b65:	5b                   	pop    %ebx
  801b66:	5e                   	pop    %esi
  801b67:	5f                   	pop    %edi
  801b68:	5d                   	pop    %ebp
  801b69:	c3                   	ret    
  801b6a:	66 90                	xchg   %ax,%ax
  801b6c:	89 d8                	mov    %ebx,%eax
  801b6e:	f7 f7                	div    %edi
  801b70:	31 ff                	xor    %edi,%edi
  801b72:	89 fa                	mov    %edi,%edx
  801b74:	83 c4 1c             	add    $0x1c,%esp
  801b77:	5b                   	pop    %ebx
  801b78:	5e                   	pop    %esi
  801b79:	5f                   	pop    %edi
  801b7a:	5d                   	pop    %ebp
  801b7b:	c3                   	ret    
  801b7c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b81:	89 eb                	mov    %ebp,%ebx
  801b83:	29 fb                	sub    %edi,%ebx
  801b85:	89 f9                	mov    %edi,%ecx
  801b87:	d3 e6                	shl    %cl,%esi
  801b89:	89 c5                	mov    %eax,%ebp
  801b8b:	88 d9                	mov    %bl,%cl
  801b8d:	d3 ed                	shr    %cl,%ebp
  801b8f:	89 e9                	mov    %ebp,%ecx
  801b91:	09 f1                	or     %esi,%ecx
  801b93:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b97:	89 f9                	mov    %edi,%ecx
  801b99:	d3 e0                	shl    %cl,%eax
  801b9b:	89 c5                	mov    %eax,%ebp
  801b9d:	89 d6                	mov    %edx,%esi
  801b9f:	88 d9                	mov    %bl,%cl
  801ba1:	d3 ee                	shr    %cl,%esi
  801ba3:	89 f9                	mov    %edi,%ecx
  801ba5:	d3 e2                	shl    %cl,%edx
  801ba7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bab:	88 d9                	mov    %bl,%cl
  801bad:	d3 e8                	shr    %cl,%eax
  801baf:	09 c2                	or     %eax,%edx
  801bb1:	89 d0                	mov    %edx,%eax
  801bb3:	89 f2                	mov    %esi,%edx
  801bb5:	f7 74 24 0c          	divl   0xc(%esp)
  801bb9:	89 d6                	mov    %edx,%esi
  801bbb:	89 c3                	mov    %eax,%ebx
  801bbd:	f7 e5                	mul    %ebp
  801bbf:	39 d6                	cmp    %edx,%esi
  801bc1:	72 19                	jb     801bdc <__udivdi3+0xfc>
  801bc3:	74 0b                	je     801bd0 <__udivdi3+0xf0>
  801bc5:	89 d8                	mov    %ebx,%eax
  801bc7:	31 ff                	xor    %edi,%edi
  801bc9:	e9 58 ff ff ff       	jmp    801b26 <__udivdi3+0x46>
  801bce:	66 90                	xchg   %ax,%ax
  801bd0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bd4:	89 f9                	mov    %edi,%ecx
  801bd6:	d3 e2                	shl    %cl,%edx
  801bd8:	39 c2                	cmp    %eax,%edx
  801bda:	73 e9                	jae    801bc5 <__udivdi3+0xe5>
  801bdc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bdf:	31 ff                	xor    %edi,%edi
  801be1:	e9 40 ff ff ff       	jmp    801b26 <__udivdi3+0x46>
  801be6:	66 90                	xchg   %ax,%ax
  801be8:	31 c0                	xor    %eax,%eax
  801bea:	e9 37 ff ff ff       	jmp    801b26 <__udivdi3+0x46>
  801bef:	90                   	nop

00801bf0 <__umoddi3>:
  801bf0:	55                   	push   %ebp
  801bf1:	57                   	push   %edi
  801bf2:	56                   	push   %esi
  801bf3:	53                   	push   %ebx
  801bf4:	83 ec 1c             	sub    $0x1c,%esp
  801bf7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bfb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c03:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c0f:	89 f3                	mov    %esi,%ebx
  801c11:	89 fa                	mov    %edi,%edx
  801c13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c17:	89 34 24             	mov    %esi,(%esp)
  801c1a:	85 c0                	test   %eax,%eax
  801c1c:	75 1a                	jne    801c38 <__umoddi3+0x48>
  801c1e:	39 f7                	cmp    %esi,%edi
  801c20:	0f 86 a2 00 00 00    	jbe    801cc8 <__umoddi3+0xd8>
  801c26:	89 c8                	mov    %ecx,%eax
  801c28:	89 f2                	mov    %esi,%edx
  801c2a:	f7 f7                	div    %edi
  801c2c:	89 d0                	mov    %edx,%eax
  801c2e:	31 d2                	xor    %edx,%edx
  801c30:	83 c4 1c             	add    $0x1c,%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5e                   	pop    %esi
  801c35:	5f                   	pop    %edi
  801c36:	5d                   	pop    %ebp
  801c37:	c3                   	ret    
  801c38:	39 f0                	cmp    %esi,%eax
  801c3a:	0f 87 ac 00 00 00    	ja     801cec <__umoddi3+0xfc>
  801c40:	0f bd e8             	bsr    %eax,%ebp
  801c43:	83 f5 1f             	xor    $0x1f,%ebp
  801c46:	0f 84 ac 00 00 00    	je     801cf8 <__umoddi3+0x108>
  801c4c:	bf 20 00 00 00       	mov    $0x20,%edi
  801c51:	29 ef                	sub    %ebp,%edi
  801c53:	89 fe                	mov    %edi,%esi
  801c55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c59:	89 e9                	mov    %ebp,%ecx
  801c5b:	d3 e0                	shl    %cl,%eax
  801c5d:	89 d7                	mov    %edx,%edi
  801c5f:	89 f1                	mov    %esi,%ecx
  801c61:	d3 ef                	shr    %cl,%edi
  801c63:	09 c7                	or     %eax,%edi
  801c65:	89 e9                	mov    %ebp,%ecx
  801c67:	d3 e2                	shl    %cl,%edx
  801c69:	89 14 24             	mov    %edx,(%esp)
  801c6c:	89 d8                	mov    %ebx,%eax
  801c6e:	d3 e0                	shl    %cl,%eax
  801c70:	89 c2                	mov    %eax,%edx
  801c72:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c76:	d3 e0                	shl    %cl,%eax
  801c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c80:	89 f1                	mov    %esi,%ecx
  801c82:	d3 e8                	shr    %cl,%eax
  801c84:	09 d0                	or     %edx,%eax
  801c86:	d3 eb                	shr    %cl,%ebx
  801c88:	89 da                	mov    %ebx,%edx
  801c8a:	f7 f7                	div    %edi
  801c8c:	89 d3                	mov    %edx,%ebx
  801c8e:	f7 24 24             	mull   (%esp)
  801c91:	89 c6                	mov    %eax,%esi
  801c93:	89 d1                	mov    %edx,%ecx
  801c95:	39 d3                	cmp    %edx,%ebx
  801c97:	0f 82 87 00 00 00    	jb     801d24 <__umoddi3+0x134>
  801c9d:	0f 84 91 00 00 00    	je     801d34 <__umoddi3+0x144>
  801ca3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ca7:	29 f2                	sub    %esi,%edx
  801ca9:	19 cb                	sbb    %ecx,%ebx
  801cab:	89 d8                	mov    %ebx,%eax
  801cad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cb1:	d3 e0                	shl    %cl,%eax
  801cb3:	89 e9                	mov    %ebp,%ecx
  801cb5:	d3 ea                	shr    %cl,%edx
  801cb7:	09 d0                	or     %edx,%eax
  801cb9:	89 e9                	mov    %ebp,%ecx
  801cbb:	d3 eb                	shr    %cl,%ebx
  801cbd:	89 da                	mov    %ebx,%edx
  801cbf:	83 c4 1c             	add    $0x1c,%esp
  801cc2:	5b                   	pop    %ebx
  801cc3:	5e                   	pop    %esi
  801cc4:	5f                   	pop    %edi
  801cc5:	5d                   	pop    %ebp
  801cc6:	c3                   	ret    
  801cc7:	90                   	nop
  801cc8:	89 fd                	mov    %edi,%ebp
  801cca:	85 ff                	test   %edi,%edi
  801ccc:	75 0b                	jne    801cd9 <__umoddi3+0xe9>
  801cce:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd3:	31 d2                	xor    %edx,%edx
  801cd5:	f7 f7                	div    %edi
  801cd7:	89 c5                	mov    %eax,%ebp
  801cd9:	89 f0                	mov    %esi,%eax
  801cdb:	31 d2                	xor    %edx,%edx
  801cdd:	f7 f5                	div    %ebp
  801cdf:	89 c8                	mov    %ecx,%eax
  801ce1:	f7 f5                	div    %ebp
  801ce3:	89 d0                	mov    %edx,%eax
  801ce5:	e9 44 ff ff ff       	jmp    801c2e <__umoddi3+0x3e>
  801cea:	66 90                	xchg   %ax,%ax
  801cec:	89 c8                	mov    %ecx,%eax
  801cee:	89 f2                	mov    %esi,%edx
  801cf0:	83 c4 1c             	add    $0x1c,%esp
  801cf3:	5b                   	pop    %ebx
  801cf4:	5e                   	pop    %esi
  801cf5:	5f                   	pop    %edi
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    
  801cf8:	3b 04 24             	cmp    (%esp),%eax
  801cfb:	72 06                	jb     801d03 <__umoddi3+0x113>
  801cfd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d01:	77 0f                	ja     801d12 <__umoddi3+0x122>
  801d03:	89 f2                	mov    %esi,%edx
  801d05:	29 f9                	sub    %edi,%ecx
  801d07:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d0b:	89 14 24             	mov    %edx,(%esp)
  801d0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d12:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d16:	8b 14 24             	mov    (%esp),%edx
  801d19:	83 c4 1c             	add    $0x1c,%esp
  801d1c:	5b                   	pop    %ebx
  801d1d:	5e                   	pop    %esi
  801d1e:	5f                   	pop    %edi
  801d1f:	5d                   	pop    %ebp
  801d20:	c3                   	ret    
  801d21:	8d 76 00             	lea    0x0(%esi),%esi
  801d24:	2b 04 24             	sub    (%esp),%eax
  801d27:	19 fa                	sbb    %edi,%edx
  801d29:	89 d1                	mov    %edx,%ecx
  801d2b:	89 c6                	mov    %eax,%esi
  801d2d:	e9 71 ff ff ff       	jmp    801ca3 <__umoddi3+0xb3>
  801d32:	66 90                	xchg   %ax,%ax
  801d34:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d38:	72 ea                	jb     801d24 <__umoddi3+0x134>
  801d3a:	89 d9                	mov    %ebx,%ecx
  801d3c:	e9 62 ff ff ff       	jmp    801ca3 <__umoddi3+0xb3>
