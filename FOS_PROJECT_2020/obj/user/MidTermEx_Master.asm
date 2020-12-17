
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 fe 01 00 00       	call   800234 <libmain>
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
  800045:	68 20 1d 80 00       	push   $0x801d20
  80004a:	e8 a2 11 00 00       	call   8011f1 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 24 1d 80 00       	push   $0x801d24
  800066:	e8 e2 03 00 00       	call   80044d <cprintf>
  80006b:	83 c4 10             	add    $0x10,%esp
	char select = getchar() ;
  80006e:	e8 69 01 00 00       	call   8001dc <getchar>
  800073:	88 45 f3             	mov    %al,-0xd(%ebp)
	cputchar(select);
  800076:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  80007a:	83 ec 0c             	sub    $0xc,%esp
  80007d:	50                   	push   %eax
  80007e:	e8 11 01 00 00       	call   800194 <cputchar>
  800083:	83 c4 10             	add    $0x10,%esp
	cputchar('\n');
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	e8 04 01 00 00       	call   800194 <cputchar>
  800090:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 00                	push   $0x0
  800098:	6a 04                	push   $0x4
  80009a:	68 49 1d 80 00       	push   $0x801d49
  80009f:	e8 4d 11 00 00       	call   8011f1 <smalloc>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  8000aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  8000b3:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  8000b7:	74 06                	je     8000bf <_main+0x87>
  8000b9:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  8000bd:	75 09                	jne    8000c8 <_main+0x90>
		*useSem = 1 ;
  8000bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  8000c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cb:	8b 00                	mov    (%eax),%eax
  8000cd:	83 f8 01             	cmp    $0x1,%eax
  8000d0:	75 12                	jne    8000e4 <_main+0xac>
	{
		sys_createSemaphore("T", 0);
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	68 50 1d 80 00       	push   $0x801d50
  8000dc:	e8 4e 14 00 00       	call   80152f <sys_createSemaphore>
  8000e1:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	6a 01                	push   $0x1
  8000e9:	6a 04                	push   $0x4
  8000eb:	68 52 1d 80 00       	push   $0x801d52
  8000f0:	e8 fc 10 00 00       	call   8011f1 <smalloc>
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  800104:	a1 20 30 80 00       	mov    0x803020,%eax
  800109:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80010f:	a1 20 30 80 00       	mov    0x803020,%eax
  800114:	8b 40 74             	mov    0x74(%eax),%eax
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	52                   	push   %edx
  80011b:	50                   	push   %eax
  80011c:	68 60 1d 80 00       	push   $0x801d60
  800121:	e8 1a 15 00 00       	call   801640 <sys_create_env>
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
  80012c:	a1 20 30 80 00       	mov    0x803020,%eax
  800131:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800137:	a1 20 30 80 00       	mov    0x803020,%eax
  80013c:	8b 40 74             	mov    0x74(%eax),%eax
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	52                   	push   %edx
  800143:	50                   	push   %eax
  800144:	68 6a 1d 80 00       	push   $0x801d6a
  800149:	e8 f2 14 00 00       	call   801640 <sys_create_env>
  80014e:	83 c4 10             	add    $0x10,%esp
  800151:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	ff 75 e4             	pushl  -0x1c(%ebp)
  80015a:	e8 fe 14 00 00       	call   80165d <sys_run_env>
  80015f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	ff 75 e0             	pushl  -0x20(%ebp)
  800168:	e8 f0 14 00 00       	call   80165d <sys_run_env>
  80016d:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800170:	90                   	nop
  800171:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800174:	8b 00                	mov    (%eax),%eax
  800176:	83 f8 02             	cmp    $0x2,%eax
  800179:	75 f6                	jne    800171 <_main+0x139>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  80017b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80017e:	8b 00                	mov    (%eax),%eax
  800180:	83 ec 08             	sub    $0x8,%esp
  800183:	50                   	push   %eax
  800184:	68 74 1d 80 00       	push   $0x801d74
  800189:	e8 bf 02 00 00       	call   80044d <cprintf>
  80018e:	83 c4 10             	add    $0x10,%esp

	return;
  800191:	90                   	nop
}
  800192:	c9                   	leave  
  800193:	c3                   	ret    

00800194 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80019a:	8b 45 08             	mov    0x8(%ebp),%eax
  80019d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001a0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001a4:	83 ec 0c             	sub    $0xc,%esp
  8001a7:	50                   	push   %eax
  8001a8:	e8 42 13 00 00       	call   8014ef <sys_cputc>
  8001ad:	83 c4 10             	add    $0x10,%esp
}
  8001b0:	90                   	nop
  8001b1:	c9                   	leave  
  8001b2:	c3                   	ret    

008001b3 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8001b9:	e8 fd 12 00 00       	call   8014bb <sys_disable_interrupt>
	char c = ch;
  8001be:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001c4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	50                   	push   %eax
  8001cc:	e8 1e 13 00 00       	call   8014ef <sys_cputc>
  8001d1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001d4:	e8 fc 12 00 00       	call   8014d5 <sys_enable_interrupt>
}
  8001d9:	90                   	nop
  8001da:	c9                   	leave  
  8001db:	c3                   	ret    

008001dc <getchar>:

int
getchar(void)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8001e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8001e9:	eb 08                	jmp    8001f3 <getchar+0x17>
	{
		c = sys_cgetc();
  8001eb:	e8 e3 10 00 00       	call   8012d3 <sys_cgetc>
  8001f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8001f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8001f7:	74 f2                	je     8001eb <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8001f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8001fc:	c9                   	leave  
  8001fd:	c3                   	ret    

008001fe <atomic_getchar>:

int
atomic_getchar(void)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800204:	e8 b2 12 00 00       	call   8014bb <sys_disable_interrupt>
	int c=0;
  800209:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800210:	eb 08                	jmp    80021a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800212:	e8 bc 10 00 00       	call   8012d3 <sys_cgetc>
  800217:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80021a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80021e:	74 f2                	je     800212 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800220:	e8 b0 12 00 00       	call   8014d5 <sys_enable_interrupt>
	return c;
  800225:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800228:	c9                   	leave  
  800229:	c3                   	ret    

0080022a <iscons>:

int iscons(int fdnum)
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80022d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800232:	5d                   	pop    %ebp
  800233:	c3                   	ret    

00800234 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80023a:	e8 e1 10 00 00       	call   801320 <sys_getenvindex>
  80023f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800242:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800245:	89 d0                	mov    %edx,%eax
  800247:	c1 e0 03             	shl    $0x3,%eax
  80024a:	01 d0                	add    %edx,%eax
  80024c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800253:	01 c8                	add    %ecx,%eax
  800255:	01 c0                	add    %eax,%eax
  800257:	01 d0                	add    %edx,%eax
  800259:	01 c0                	add    %eax,%eax
  80025b:	01 d0                	add    %edx,%eax
  80025d:	89 c2                	mov    %eax,%edx
  80025f:	c1 e2 05             	shl    $0x5,%edx
  800262:	29 c2                	sub    %eax,%edx
  800264:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80026b:	89 c2                	mov    %eax,%edx
  80026d:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800273:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800278:	a1 20 30 80 00       	mov    0x803020,%eax
  80027d:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800283:	84 c0                	test   %al,%al
  800285:	74 0f                	je     800296 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800287:	a1 20 30 80 00       	mov    0x803020,%eax
  80028c:	05 40 3c 01 00       	add    $0x13c40,%eax
  800291:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800296:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80029a:	7e 0a                	jle    8002a6 <libmain+0x72>
		binaryname = argv[0];
  80029c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029f:	8b 00                	mov    (%eax),%eax
  8002a1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8002a6:	83 ec 08             	sub    $0x8,%esp
  8002a9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ac:	ff 75 08             	pushl  0x8(%ebp)
  8002af:	e8 84 fd ff ff       	call   800038 <_main>
  8002b4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002b7:	e8 ff 11 00 00       	call   8014bb <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 a4 1d 80 00       	push   $0x801da4
  8002c4:	e8 84 01 00 00       	call   80044d <cprintf>
  8002c9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d1:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8002d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002dc:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8002e2:	83 ec 04             	sub    $0x4,%esp
  8002e5:	52                   	push   %edx
  8002e6:	50                   	push   %eax
  8002e7:	68 cc 1d 80 00       	push   $0x801dcc
  8002ec:	e8 5c 01 00 00       	call   80044d <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8002f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f9:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8002ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800304:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80030a:	83 ec 04             	sub    $0x4,%esp
  80030d:	52                   	push   %edx
  80030e:	50                   	push   %eax
  80030f:	68 f4 1d 80 00       	push   $0x801df4
  800314:	e8 34 01 00 00       	call   80044d <cprintf>
  800319:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80031c:	a1 20 30 80 00       	mov    0x803020,%eax
  800321:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	50                   	push   %eax
  80032b:	68 35 1e 80 00       	push   $0x801e35
  800330:	e8 18 01 00 00       	call   80044d <cprintf>
  800335:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800338:	83 ec 0c             	sub    $0xc,%esp
  80033b:	68 a4 1d 80 00       	push   $0x801da4
  800340:	e8 08 01 00 00       	call   80044d <cprintf>
  800345:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800348:	e8 88 11 00 00       	call   8014d5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80034d:	e8 19 00 00 00       	call   80036b <exit>
}
  800352:	90                   	nop
  800353:	c9                   	leave  
  800354:	c3                   	ret    

00800355 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80035b:	83 ec 0c             	sub    $0xc,%esp
  80035e:	6a 00                	push   $0x0
  800360:	e8 87 0f 00 00       	call   8012ec <sys_env_destroy>
  800365:	83 c4 10             	add    $0x10,%esp
}
  800368:	90                   	nop
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <exit>:

void
exit(void)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800371:	e8 dc 0f 00 00       	call   801352 <sys_env_exit>
}
  800376:	90                   	nop
  800377:	c9                   	leave  
  800378:	c3                   	ret    

00800379 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80037f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800382:	8b 00                	mov    (%eax),%eax
  800384:	8d 48 01             	lea    0x1(%eax),%ecx
  800387:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038a:	89 0a                	mov    %ecx,(%edx)
  80038c:	8b 55 08             	mov    0x8(%ebp),%edx
  80038f:	88 d1                	mov    %dl,%cl
  800391:	8b 55 0c             	mov    0xc(%ebp),%edx
  800394:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039b:	8b 00                	mov    (%eax),%eax
  80039d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a2:	75 2c                	jne    8003d0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003a4:	a0 24 30 80 00       	mov    0x803024,%al
  8003a9:	0f b6 c0             	movzbl %al,%eax
  8003ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003af:	8b 12                	mov    (%edx),%edx
  8003b1:	89 d1                	mov    %edx,%ecx
  8003b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b6:	83 c2 08             	add    $0x8,%edx
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	50                   	push   %eax
  8003bd:	51                   	push   %ecx
  8003be:	52                   	push   %edx
  8003bf:	e8 e6 0e 00 00       	call   8012aa <sys_cputs>
  8003c4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d3:	8b 40 04             	mov    0x4(%eax),%eax
  8003d6:	8d 50 01             	lea    0x1(%eax),%edx
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003df:	90                   	nop
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003f2:	00 00 00 
	b.cnt = 0;
  8003f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003fc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003ff:	ff 75 0c             	pushl  0xc(%ebp)
  800402:	ff 75 08             	pushl  0x8(%ebp)
  800405:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80040b:	50                   	push   %eax
  80040c:	68 79 03 80 00       	push   $0x800379
  800411:	e8 11 02 00 00       	call   800627 <vprintfmt>
  800416:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800419:	a0 24 30 80 00       	mov    0x803024,%al
  80041e:	0f b6 c0             	movzbl %al,%eax
  800421:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800427:	83 ec 04             	sub    $0x4,%esp
  80042a:	50                   	push   %eax
  80042b:	52                   	push   %edx
  80042c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800432:	83 c0 08             	add    $0x8,%eax
  800435:	50                   	push   %eax
  800436:	e8 6f 0e 00 00       	call   8012aa <sys_cputs>
  80043b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80043e:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800445:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80044b:	c9                   	leave  
  80044c:	c3                   	ret    

0080044d <cprintf>:

int cprintf(const char *fmt, ...) {
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800453:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80045a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80045d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	ff 75 f4             	pushl  -0xc(%ebp)
  800469:	50                   	push   %eax
  80046a:	e8 73 ff ff ff       	call   8003e2 <vcprintf>
  80046f:	83 c4 10             	add    $0x10,%esp
  800472:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800475:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800478:	c9                   	leave  
  800479:	c3                   	ret    

0080047a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80047a:	55                   	push   %ebp
  80047b:	89 e5                	mov    %esp,%ebp
  80047d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800480:	e8 36 10 00 00       	call   8014bb <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800485:	8d 45 0c             	lea    0xc(%ebp),%eax
  800488:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	ff 75 f4             	pushl  -0xc(%ebp)
  800494:	50                   	push   %eax
  800495:	e8 48 ff ff ff       	call   8003e2 <vcprintf>
  80049a:	83 c4 10             	add    $0x10,%esp
  80049d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004a0:	e8 30 10 00 00       	call   8014d5 <sys_enable_interrupt>
	return cnt;
  8004a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	53                   	push   %ebx
  8004ae:	83 ec 14             	sub    $0x14,%esp
  8004b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004bd:	8b 45 18             	mov    0x18(%ebp),%eax
  8004c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004c8:	77 55                	ja     80051f <printnum+0x75>
  8004ca:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004cd:	72 05                	jb     8004d4 <printnum+0x2a>
  8004cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004d2:	77 4b                	ja     80051f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004d7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004da:	8b 45 18             	mov    0x18(%ebp),%eax
  8004dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e2:	52                   	push   %edx
  8004e3:	50                   	push   %eax
  8004e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8004ea:	e8 bd 15 00 00       	call   801aac <__udivdi3>
  8004ef:	83 c4 10             	add    $0x10,%esp
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	ff 75 20             	pushl  0x20(%ebp)
  8004f8:	53                   	push   %ebx
  8004f9:	ff 75 18             	pushl  0x18(%ebp)
  8004fc:	52                   	push   %edx
  8004fd:	50                   	push   %eax
  8004fe:	ff 75 0c             	pushl  0xc(%ebp)
  800501:	ff 75 08             	pushl  0x8(%ebp)
  800504:	e8 a1 ff ff ff       	call   8004aa <printnum>
  800509:	83 c4 20             	add    $0x20,%esp
  80050c:	eb 1a                	jmp    800528 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	ff 75 0c             	pushl  0xc(%ebp)
  800514:	ff 75 20             	pushl  0x20(%ebp)
  800517:	8b 45 08             	mov    0x8(%ebp),%eax
  80051a:	ff d0                	call   *%eax
  80051c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051f:	ff 4d 1c             	decl   0x1c(%ebp)
  800522:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800526:	7f e6                	jg     80050e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800528:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80052b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800533:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800536:	53                   	push   %ebx
  800537:	51                   	push   %ecx
  800538:	52                   	push   %edx
  800539:	50                   	push   %eax
  80053a:	e8 7d 16 00 00       	call   801bbc <__umoddi3>
  80053f:	83 c4 10             	add    $0x10,%esp
  800542:	05 74 20 80 00       	add    $0x802074,%eax
  800547:	8a 00                	mov    (%eax),%al
  800549:	0f be c0             	movsbl %al,%eax
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	ff 75 0c             	pushl  0xc(%ebp)
  800552:	50                   	push   %eax
  800553:	8b 45 08             	mov    0x8(%ebp),%eax
  800556:	ff d0                	call   *%eax
  800558:	83 c4 10             	add    $0x10,%esp
}
  80055b:	90                   	nop
  80055c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055f:	c9                   	leave  
  800560:	c3                   	ret    

00800561 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800561:	55                   	push   %ebp
  800562:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800564:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800568:	7e 1c                	jle    800586 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	8b 00                	mov    (%eax),%eax
  80056f:	8d 50 08             	lea    0x8(%eax),%edx
  800572:	8b 45 08             	mov    0x8(%ebp),%eax
  800575:	89 10                	mov    %edx,(%eax)
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	83 e8 08             	sub    $0x8,%eax
  80057f:	8b 50 04             	mov    0x4(%eax),%edx
  800582:	8b 00                	mov    (%eax),%eax
  800584:	eb 40                	jmp    8005c6 <getuint+0x65>
	else if (lflag)
  800586:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80058a:	74 1e                	je     8005aa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	8d 50 04             	lea    0x4(%eax),%edx
  800594:	8b 45 08             	mov    0x8(%ebp),%eax
  800597:	89 10                	mov    %edx,(%eax)
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	83 e8 04             	sub    $0x4,%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a8:	eb 1c                	jmp    8005c6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	8d 50 04             	lea    0x4(%eax),%edx
  8005b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b5:	89 10                	mov    %edx,(%eax)
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	83 e8 04             	sub    $0x4,%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005c6:	5d                   	pop    %ebp
  8005c7:	c3                   	ret    

008005c8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005c8:	55                   	push   %ebp
  8005c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005cf:	7e 1c                	jle    8005ed <getint+0x25>
		return va_arg(*ap, long long);
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	8d 50 08             	lea    0x8(%eax),%edx
  8005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dc:	89 10                	mov    %edx,(%eax)
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	83 e8 08             	sub    $0x8,%eax
  8005e6:	8b 50 04             	mov    0x4(%eax),%edx
  8005e9:	8b 00                	mov    (%eax),%eax
  8005eb:	eb 38                	jmp    800625 <getint+0x5d>
	else if (lflag)
  8005ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005f1:	74 1a                	je     80060d <getint+0x45>
		return va_arg(*ap, long);
  8005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	8d 50 04             	lea    0x4(%eax),%edx
  8005fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fe:	89 10                	mov    %edx,(%eax)
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	83 e8 04             	sub    $0x4,%eax
  800608:	8b 00                	mov    (%eax),%eax
  80060a:	99                   	cltd   
  80060b:	eb 18                	jmp    800625 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	8b 00                	mov    (%eax),%eax
  800612:	8d 50 04             	lea    0x4(%eax),%edx
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	89 10                	mov    %edx,(%eax)
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	83 e8 04             	sub    $0x4,%eax
  800622:	8b 00                	mov    (%eax),%eax
  800624:	99                   	cltd   
}
  800625:	5d                   	pop    %ebp
  800626:	c3                   	ret    

00800627 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800627:	55                   	push   %ebp
  800628:	89 e5                	mov    %esp,%ebp
  80062a:	56                   	push   %esi
  80062b:	53                   	push   %ebx
  80062c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80062f:	eb 17                	jmp    800648 <vprintfmt+0x21>
			if (ch == '\0')
  800631:	85 db                	test   %ebx,%ebx
  800633:	0f 84 af 03 00 00    	je     8009e8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	ff 75 0c             	pushl  0xc(%ebp)
  80063f:	53                   	push   %ebx
  800640:	8b 45 08             	mov    0x8(%ebp),%eax
  800643:	ff d0                	call   *%eax
  800645:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800648:	8b 45 10             	mov    0x10(%ebp),%eax
  80064b:	8d 50 01             	lea    0x1(%eax),%edx
  80064e:	89 55 10             	mov    %edx,0x10(%ebp)
  800651:	8a 00                	mov    (%eax),%al
  800653:	0f b6 d8             	movzbl %al,%ebx
  800656:	83 fb 25             	cmp    $0x25,%ebx
  800659:	75 d6                	jne    800631 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80065b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80065f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800666:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80066d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800674:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067b:	8b 45 10             	mov    0x10(%ebp),%eax
  80067e:	8d 50 01             	lea    0x1(%eax),%edx
  800681:	89 55 10             	mov    %edx,0x10(%ebp)
  800684:	8a 00                	mov    (%eax),%al
  800686:	0f b6 d8             	movzbl %al,%ebx
  800689:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80068c:	83 f8 55             	cmp    $0x55,%eax
  80068f:	0f 87 2b 03 00 00    	ja     8009c0 <vprintfmt+0x399>
  800695:	8b 04 85 98 20 80 00 	mov    0x802098(,%eax,4),%eax
  80069c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80069e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006a2:	eb d7                	jmp    80067b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006a4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006a8:	eb d1                	jmp    80067b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006b4:	89 d0                	mov    %edx,%eax
  8006b6:	c1 e0 02             	shl    $0x2,%eax
  8006b9:	01 d0                	add    %edx,%eax
  8006bb:	01 c0                	add    %eax,%eax
  8006bd:	01 d8                	add    %ebx,%eax
  8006bf:	83 e8 30             	sub    $0x30,%eax
  8006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c8:	8a 00                	mov    (%eax),%al
  8006ca:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006cd:	83 fb 2f             	cmp    $0x2f,%ebx
  8006d0:	7e 3e                	jle    800710 <vprintfmt+0xe9>
  8006d2:	83 fb 39             	cmp    $0x39,%ebx
  8006d5:	7f 39                	jg     800710 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006d7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006da:	eb d5                	jmp    8006b1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	83 c0 04             	add    $0x4,%eax
  8006e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	83 e8 04             	sub    $0x4,%eax
  8006eb:	8b 00                	mov    (%eax),%eax
  8006ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006f0:	eb 1f                	jmp    800711 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f6:	79 83                	jns    80067b <vprintfmt+0x54>
				width = 0;
  8006f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006ff:	e9 77 ff ff ff       	jmp    80067b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800704:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80070b:	e9 6b ff ff ff       	jmp    80067b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800710:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800711:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800715:	0f 89 60 ff ff ff    	jns    80067b <vprintfmt+0x54>
				width = precision, precision = -1;
  80071b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80071e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800721:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800728:	e9 4e ff ff ff       	jmp    80067b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80072d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800730:	e9 46 ff ff ff       	jmp    80067b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	83 c0 04             	add    $0x4,%eax
  80073b:	89 45 14             	mov    %eax,0x14(%ebp)
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	83 e8 04             	sub    $0x4,%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	ff 75 0c             	pushl  0xc(%ebp)
  80074c:	50                   	push   %eax
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	ff d0                	call   *%eax
  800752:	83 c4 10             	add    $0x10,%esp
			break;
  800755:	e9 89 02 00 00       	jmp    8009e3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	83 c0 04             	add    $0x4,%eax
  800760:	89 45 14             	mov    %eax,0x14(%ebp)
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	83 e8 04             	sub    $0x4,%eax
  800769:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80076b:	85 db                	test   %ebx,%ebx
  80076d:	79 02                	jns    800771 <vprintfmt+0x14a>
				err = -err;
  80076f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800771:	83 fb 64             	cmp    $0x64,%ebx
  800774:	7f 0b                	jg     800781 <vprintfmt+0x15a>
  800776:	8b 34 9d e0 1e 80 00 	mov    0x801ee0(,%ebx,4),%esi
  80077d:	85 f6                	test   %esi,%esi
  80077f:	75 19                	jne    80079a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800781:	53                   	push   %ebx
  800782:	68 85 20 80 00       	push   $0x802085
  800787:	ff 75 0c             	pushl  0xc(%ebp)
  80078a:	ff 75 08             	pushl  0x8(%ebp)
  80078d:	e8 5e 02 00 00       	call   8009f0 <printfmt>
  800792:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800795:	e9 49 02 00 00       	jmp    8009e3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80079a:	56                   	push   %esi
  80079b:	68 8e 20 80 00       	push   $0x80208e
  8007a0:	ff 75 0c             	pushl  0xc(%ebp)
  8007a3:	ff 75 08             	pushl  0x8(%ebp)
  8007a6:	e8 45 02 00 00       	call   8009f0 <printfmt>
  8007ab:	83 c4 10             	add    $0x10,%esp
			break;
  8007ae:	e9 30 02 00 00       	jmp    8009e3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	83 c0 04             	add    $0x4,%eax
  8007b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	83 e8 04             	sub    $0x4,%eax
  8007c2:	8b 30                	mov    (%eax),%esi
  8007c4:	85 f6                	test   %esi,%esi
  8007c6:	75 05                	jne    8007cd <vprintfmt+0x1a6>
				p = "(null)";
  8007c8:	be 91 20 80 00       	mov    $0x802091,%esi
			if (width > 0 && padc != '-')
  8007cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d1:	7e 6d                	jle    800840 <vprintfmt+0x219>
  8007d3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007d7:	74 67                	je     800840 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	50                   	push   %eax
  8007e0:	56                   	push   %esi
  8007e1:	e8 0c 03 00 00       	call   800af2 <strnlen>
  8007e6:	83 c4 10             	add    $0x10,%esp
  8007e9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007ec:	eb 16                	jmp    800804 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007ee:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	ff 75 0c             	pushl  0xc(%ebp)
  8007f8:	50                   	push   %eax
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	ff d0                	call   *%eax
  8007fe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800801:	ff 4d e4             	decl   -0x1c(%ebp)
  800804:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800808:	7f e4                	jg     8007ee <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80080a:	eb 34                	jmp    800840 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80080c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800810:	74 1c                	je     80082e <vprintfmt+0x207>
  800812:	83 fb 1f             	cmp    $0x1f,%ebx
  800815:	7e 05                	jle    80081c <vprintfmt+0x1f5>
  800817:	83 fb 7e             	cmp    $0x7e,%ebx
  80081a:	7e 12                	jle    80082e <vprintfmt+0x207>
					putch('?', putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	6a 3f                	push   $0x3f
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	ff d0                	call   *%eax
  800829:	83 c4 10             	add    $0x10,%esp
  80082c:	eb 0f                	jmp    80083d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	ff 75 0c             	pushl  0xc(%ebp)
  800834:	53                   	push   %ebx
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	ff d0                	call   *%eax
  80083a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80083d:	ff 4d e4             	decl   -0x1c(%ebp)
  800840:	89 f0                	mov    %esi,%eax
  800842:	8d 70 01             	lea    0x1(%eax),%esi
  800845:	8a 00                	mov    (%eax),%al
  800847:	0f be d8             	movsbl %al,%ebx
  80084a:	85 db                	test   %ebx,%ebx
  80084c:	74 24                	je     800872 <vprintfmt+0x24b>
  80084e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800852:	78 b8                	js     80080c <vprintfmt+0x1e5>
  800854:	ff 4d e0             	decl   -0x20(%ebp)
  800857:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085b:	79 af                	jns    80080c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80085d:	eb 13                	jmp    800872 <vprintfmt+0x24b>
				putch(' ', putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	6a 20                	push   $0x20
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	ff d0                	call   *%eax
  80086c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086f:	ff 4d e4             	decl   -0x1c(%ebp)
  800872:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800876:	7f e7                	jg     80085f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800878:	e9 66 01 00 00       	jmp    8009e3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	ff 75 e8             	pushl  -0x18(%ebp)
  800883:	8d 45 14             	lea    0x14(%ebp),%eax
  800886:	50                   	push   %eax
  800887:	e8 3c fd ff ff       	call   8005c8 <getint>
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800892:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089b:	85 d2                	test   %edx,%edx
  80089d:	79 23                	jns    8008c2 <vprintfmt+0x29b>
				putch('-', putdat);
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	ff 75 0c             	pushl  0xc(%ebp)
  8008a5:	6a 2d                	push   $0x2d
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	ff d0                	call   *%eax
  8008ac:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b5:	f7 d8                	neg    %eax
  8008b7:	83 d2 00             	adc    $0x0,%edx
  8008ba:	f7 da                	neg    %edx
  8008bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008c2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008c9:	e9 bc 00 00 00       	jmp    80098a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8008d4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d7:	50                   	push   %eax
  8008d8:	e8 84 fc ff ff       	call   800561 <getuint>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008e6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ed:	e9 98 00 00 00       	jmp    80098a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 0c             	pushl  0xc(%ebp)
  8008f8:	6a 58                	push   $0x58
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	ff d0                	call   *%eax
  8008ff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	6a 58                	push   $0x58
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	6a 58                	push   $0x58
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	ff d0                	call   *%eax
  80091f:	83 c4 10             	add    $0x10,%esp
			break;
  800922:	e9 bc 00 00 00       	jmp    8009e3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	6a 30                	push   $0x30
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	ff d0                	call   *%eax
  800934:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 78                	push   $0x78
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	83 c0 04             	add    $0x4,%eax
  80094d:	89 45 14             	mov    %eax,0x14(%ebp)
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	83 e8 04             	sub    $0x4,%eax
  800956:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800958:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800962:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800969:	eb 1f                	jmp    80098a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	ff 75 e8             	pushl  -0x18(%ebp)
  800971:	8d 45 14             	lea    0x14(%ebp),%eax
  800974:	50                   	push   %eax
  800975:	e8 e7 fb ff ff       	call   800561 <getuint>
  80097a:	83 c4 10             	add    $0x10,%esp
  80097d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800980:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800983:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80098a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80098e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800991:	83 ec 04             	sub    $0x4,%esp
  800994:	52                   	push   %edx
  800995:	ff 75 e4             	pushl  -0x1c(%ebp)
  800998:	50                   	push   %eax
  800999:	ff 75 f4             	pushl  -0xc(%ebp)
  80099c:	ff 75 f0             	pushl  -0x10(%ebp)
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	ff 75 08             	pushl  0x8(%ebp)
  8009a5:	e8 00 fb ff ff       	call   8004aa <printnum>
  8009aa:	83 c4 20             	add    $0x20,%esp
			break;
  8009ad:	eb 34                	jmp    8009e3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	53                   	push   %ebx
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	ff d0                	call   *%eax
  8009bb:	83 c4 10             	add    $0x10,%esp
			break;
  8009be:	eb 23                	jmp    8009e3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	ff 75 0c             	pushl  0xc(%ebp)
  8009c6:	6a 25                	push   $0x25
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	ff d0                	call   *%eax
  8009cd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009d0:	ff 4d 10             	decl   0x10(%ebp)
  8009d3:	eb 03                	jmp    8009d8 <vprintfmt+0x3b1>
  8009d5:	ff 4d 10             	decl   0x10(%ebp)
  8009d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009db:	48                   	dec    %eax
  8009dc:	8a 00                	mov    (%eax),%al
  8009de:	3c 25                	cmp    $0x25,%al
  8009e0:	75 f3                	jne    8009d5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009e2:	90                   	nop
		}
	}
  8009e3:	e9 47 fc ff ff       	jmp    80062f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009e8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009ec:	5b                   	pop    %ebx
  8009ed:	5e                   	pop    %esi
  8009ee:	5d                   	pop    %ebp
  8009ef:	c3                   	ret    

008009f0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009f6:	8d 45 10             	lea    0x10(%ebp),%eax
  8009f9:	83 c0 04             	add    $0x4,%eax
  8009fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800a02:	ff 75 f4             	pushl  -0xc(%ebp)
  800a05:	50                   	push   %eax
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	ff 75 08             	pushl  0x8(%ebp)
  800a0c:	e8 16 fc ff ff       	call   800627 <vprintfmt>
  800a11:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a14:	90                   	nop
  800a15:	c9                   	leave  
  800a16:	c3                   	ret    

00800a17 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1d:	8b 40 08             	mov    0x8(%eax),%eax
  800a20:	8d 50 01             	lea    0x1(%eax),%edx
  800a23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a26:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2c:	8b 10                	mov    (%eax),%edx
  800a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a31:	8b 40 04             	mov    0x4(%eax),%eax
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	73 12                	jae    800a4a <sprintputch+0x33>
		*b->buf++ = ch;
  800a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3b:	8b 00                	mov    (%eax),%eax
  800a3d:	8d 48 01             	lea    0x1(%eax),%ecx
  800a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a43:	89 0a                	mov    %ecx,(%edx)
  800a45:	8b 55 08             	mov    0x8(%ebp),%edx
  800a48:	88 10                	mov    %dl,(%eax)
}
  800a4a:	90                   	nop
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	01 d0                	add    %edx,%eax
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a72:	74 06                	je     800a7a <vsnprintf+0x2d>
  800a74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a78:	7f 07                	jg     800a81 <vsnprintf+0x34>
		return -E_INVAL;
  800a7a:	b8 03 00 00 00       	mov    $0x3,%eax
  800a7f:	eb 20                	jmp    800aa1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a81:	ff 75 14             	pushl  0x14(%ebp)
  800a84:	ff 75 10             	pushl  0x10(%ebp)
  800a87:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a8a:	50                   	push   %eax
  800a8b:	68 17 0a 80 00       	push   $0x800a17
  800a90:	e8 92 fb ff ff       	call   800627 <vprintfmt>
  800a95:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a9b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aa1:	c9                   	leave  
  800aa2:	c3                   	ret    

00800aa3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aa9:	8d 45 10             	lea    0x10(%ebp),%eax
  800aac:	83 c0 04             	add    $0x4,%eax
  800aaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ab2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab8:	50                   	push   %eax
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	ff 75 08             	pushl  0x8(%ebp)
  800abf:	e8 89 ff ff ff       	call   800a4d <vsnprintf>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800acd:	c9                   	leave  
  800ace:	c3                   	ret    

00800acf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ad5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800adc:	eb 06                	jmp    800ae4 <strlen+0x15>
		n++;
  800ade:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae1:	ff 45 08             	incl   0x8(%ebp)
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	8a 00                	mov    (%eax),%al
  800ae9:	84 c0                	test   %al,%al
  800aeb:	75 f1                	jne    800ade <strlen+0xf>
		n++;
	return n;
  800aed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800af0:	c9                   	leave  
  800af1:	c3                   	ret    

00800af2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800af8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aff:	eb 09                	jmp    800b0a <strnlen+0x18>
		n++;
  800b01:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b04:	ff 45 08             	incl   0x8(%ebp)
  800b07:	ff 4d 0c             	decl   0xc(%ebp)
  800b0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0e:	74 09                	je     800b19 <strnlen+0x27>
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	8a 00                	mov    (%eax),%al
  800b15:	84 c0                	test   %al,%al
  800b17:	75 e8                	jne    800b01 <strnlen+0xf>
		n++;
	return n;
  800b19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b2a:	90                   	nop
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8d 50 01             	lea    0x1(%eax),%edx
  800b31:	89 55 08             	mov    %edx,0x8(%ebp)
  800b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b37:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b3a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b3d:	8a 12                	mov    (%edx),%dl
  800b3f:	88 10                	mov    %dl,(%eax)
  800b41:	8a 00                	mov    (%eax),%al
  800b43:	84 c0                	test   %al,%al
  800b45:	75 e4                	jne    800b2b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b5f:	eb 1f                	jmp    800b80 <strncpy+0x34>
		*dst++ = *src;
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	8d 50 01             	lea    0x1(%eax),%edx
  800b67:	89 55 08             	mov    %edx,0x8(%ebp)
  800b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6d:	8a 12                	mov    (%edx),%dl
  800b6f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b74:	8a 00                	mov    (%eax),%al
  800b76:	84 c0                	test   %al,%al
  800b78:	74 03                	je     800b7d <strncpy+0x31>
			src++;
  800b7a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b7d:	ff 45 fc             	incl   -0x4(%ebp)
  800b80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b83:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b86:	72 d9                	jb     800b61 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b88:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b8b:	c9                   	leave  
  800b8c:	c3                   	ret    

00800b8d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b9d:	74 30                	je     800bcf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b9f:	eb 16                	jmp    800bb7 <strlcpy+0x2a>
			*dst++ = *src++;
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	8d 50 01             	lea    0x1(%eax),%edx
  800ba7:	89 55 08             	mov    %edx,0x8(%ebp)
  800baa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bad:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bb3:	8a 12                	mov    (%edx),%dl
  800bb5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bb7:	ff 4d 10             	decl   0x10(%ebp)
  800bba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bbe:	74 09                	je     800bc9 <strlcpy+0x3c>
  800bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc3:	8a 00                	mov    (%eax),%al
  800bc5:	84 c0                	test   %al,%al
  800bc7:	75 d8                	jne    800ba1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd5:	29 c2                	sub    %eax,%edx
  800bd7:	89 d0                	mov    %edx,%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bde:	eb 06                	jmp    800be6 <strcmp+0xb>
		p++, q++;
  800be0:	ff 45 08             	incl   0x8(%ebp)
  800be3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	8a 00                	mov    (%eax),%al
  800beb:	84 c0                	test   %al,%al
  800bed:	74 0e                	je     800bfd <strcmp+0x22>
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8a 10                	mov    (%eax),%dl
  800bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf7:	8a 00                	mov    (%eax),%al
  800bf9:	38 c2                	cmp    %al,%dl
  800bfb:	74 e3                	je     800be0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	0f b6 d0             	movzbl %al,%edx
  800c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c08:	8a 00                	mov    (%eax),%al
  800c0a:	0f b6 c0             	movzbl %al,%eax
  800c0d:	29 c2                	sub    %eax,%edx
  800c0f:	89 d0                	mov    %edx,%eax
}
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c16:	eb 09                	jmp    800c21 <strncmp+0xe>
		n--, p++, q++;
  800c18:	ff 4d 10             	decl   0x10(%ebp)
  800c1b:	ff 45 08             	incl   0x8(%ebp)
  800c1e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c25:	74 17                	je     800c3e <strncmp+0x2b>
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	84 c0                	test   %al,%al
  800c2e:	74 0e                	je     800c3e <strncmp+0x2b>
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8a 10                	mov    (%eax),%dl
  800c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	38 c2                	cmp    %al,%dl
  800c3c:	74 da                	je     800c18 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c42:	75 07                	jne    800c4b <strncmp+0x38>
		return 0;
  800c44:	b8 00 00 00 00       	mov    $0x0,%eax
  800c49:	eb 14                	jmp    800c5f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	8a 00                	mov    (%eax),%al
  800c50:	0f b6 d0             	movzbl %al,%edx
  800c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c56:	8a 00                	mov    (%eax),%al
  800c58:	0f b6 c0             	movzbl %al,%eax
  800c5b:	29 c2                	sub    %eax,%edx
  800c5d:	89 d0                	mov    %edx,%eax
}
  800c5f:	5d                   	pop    %ebp
  800c60:	c3                   	ret    

00800c61 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	83 ec 04             	sub    $0x4,%esp
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c6d:	eb 12                	jmp    800c81 <strchr+0x20>
		if (*s == c)
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	8a 00                	mov    (%eax),%al
  800c74:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c77:	75 05                	jne    800c7e <strchr+0x1d>
			return (char *) s;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	eb 11                	jmp    800c8f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c7e:	ff 45 08             	incl   0x8(%ebp)
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	8a 00                	mov    (%eax),%al
  800c86:	84 c0                	test   %al,%al
  800c88:	75 e5                	jne    800c6f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c8f:	c9                   	leave  
  800c90:	c3                   	ret    

00800c91 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 04             	sub    $0x4,%esp
  800c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c9d:	eb 0d                	jmp    800cac <strfind+0x1b>
		if (*s == c)
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ca7:	74 0e                	je     800cb7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ca9:	ff 45 08             	incl   0x8(%ebp)
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	84 c0                	test   %al,%al
  800cb3:	75 ea                	jne    800c9f <strfind+0xe>
  800cb5:	eb 01                	jmp    800cb8 <strfind+0x27>
		if (*s == c)
			break;
  800cb7:	90                   	nop
	return (char *) s;
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cbb:	c9                   	leave  
  800cbc:	c3                   	ret    

00800cbd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ccf:	eb 0e                	jmp    800cdf <memset+0x22>
		*p++ = c;
  800cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd4:	8d 50 01             	lea    0x1(%eax),%edx
  800cd7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cdf:	ff 4d f8             	decl   -0x8(%ebp)
  800ce2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ce6:	79 e9                	jns    800cd1 <memset+0x14>
		*p++ = c;

	return v;
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ceb:	c9                   	leave  
  800cec:	c3                   	ret    

00800ced <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800cff:	eb 16                	jmp    800d17 <memcpy+0x2a>
		*d++ = *s++;
  800d01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d04:	8d 50 01             	lea    0x1(%eax),%edx
  800d07:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d0d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d10:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d13:	8a 12                	mov    (%edx),%dl
  800d15:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d17:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d1d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d20:	85 c0                	test   %eax,%eax
  800d22:	75 dd                	jne    800d01 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d27:	c9                   	leave  
  800d28:	c3                   	ret    

00800d29 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d3e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d41:	73 50                	jae    800d93 <memmove+0x6a>
  800d43:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d46:	8b 45 10             	mov    0x10(%ebp),%eax
  800d49:	01 d0                	add    %edx,%eax
  800d4b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d4e:	76 43                	jbe    800d93 <memmove+0x6a>
		s += n;
  800d50:	8b 45 10             	mov    0x10(%ebp),%eax
  800d53:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d56:	8b 45 10             	mov    0x10(%ebp),%eax
  800d59:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d5c:	eb 10                	jmp    800d6e <memmove+0x45>
			*--d = *--s;
  800d5e:	ff 4d f8             	decl   -0x8(%ebp)
  800d61:	ff 4d fc             	decl   -0x4(%ebp)
  800d64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d67:	8a 10                	mov    (%eax),%dl
  800d69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d6c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d71:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d74:	89 55 10             	mov    %edx,0x10(%ebp)
  800d77:	85 c0                	test   %eax,%eax
  800d79:	75 e3                	jne    800d5e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d7b:	eb 23                	jmp    800da0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d80:	8d 50 01             	lea    0x1(%eax),%edx
  800d83:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d89:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d8c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d8f:	8a 12                	mov    (%edx),%dl
  800d91:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d93:	8b 45 10             	mov    0x10(%ebp),%eax
  800d96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d99:	89 55 10             	mov    %edx,0x10(%ebp)
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	75 dd                	jne    800d7d <memmove+0x54>
			*d++ = *s++;

	return dst;
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da3:	c9                   	leave  
  800da4:	c3                   	ret    

00800da5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800db7:	eb 2a                	jmp    800de3 <memcmp+0x3e>
		if (*s1 != *s2)
  800db9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbc:	8a 10                	mov    (%eax),%dl
  800dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	38 c2                	cmp    %al,%dl
  800dc5:	74 16                	je     800ddd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f b6 d0             	movzbl %al,%edx
  800dcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 c0             	movzbl %al,%eax
  800dd7:	29 c2                	sub    %eax,%edx
  800dd9:	89 d0                	mov    %edx,%eax
  800ddb:	eb 18                	jmp    800df5 <memcmp+0x50>
		s1++, s2++;
  800ddd:	ff 45 fc             	incl   -0x4(%ebp)
  800de0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
  800de6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800de9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dec:	85 c0                	test   %eax,%eax
  800dee:	75 c9                	jne    800db9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800df0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df5:	c9                   	leave  
  800df6:	c3                   	ret    

00800df7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	01 d0                	add    %edx,%eax
  800e05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e08:	eb 15                	jmp    800e1f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	0f b6 d0             	movzbl %al,%edx
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	0f b6 c0             	movzbl %al,%eax
  800e18:	39 c2                	cmp    %eax,%edx
  800e1a:	74 0d                	je     800e29 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e1c:	ff 45 08             	incl   0x8(%ebp)
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e25:	72 e3                	jb     800e0a <memfind+0x13>
  800e27:	eb 01                	jmp    800e2a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e29:	90                   	nop
	return (void *) s;
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e3c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e43:	eb 03                	jmp    800e48 <strtol+0x19>
		s++;
  800e45:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	3c 20                	cmp    $0x20,%al
  800e4f:	74 f4                	je     800e45 <strtol+0x16>
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8a 00                	mov    (%eax),%al
  800e56:	3c 09                	cmp    $0x9,%al
  800e58:	74 eb                	je     800e45 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	8a 00                	mov    (%eax),%al
  800e5f:	3c 2b                	cmp    $0x2b,%al
  800e61:	75 05                	jne    800e68 <strtol+0x39>
		s++;
  800e63:	ff 45 08             	incl   0x8(%ebp)
  800e66:	eb 13                	jmp    800e7b <strtol+0x4c>
	else if (*s == '-')
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	3c 2d                	cmp    $0x2d,%al
  800e6f:	75 0a                	jne    800e7b <strtol+0x4c>
		s++, neg = 1;
  800e71:	ff 45 08             	incl   0x8(%ebp)
  800e74:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7f:	74 06                	je     800e87 <strtol+0x58>
  800e81:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e85:	75 20                	jne    800ea7 <strtol+0x78>
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	3c 30                	cmp    $0x30,%al
  800e8e:	75 17                	jne    800ea7 <strtol+0x78>
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	40                   	inc    %eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	3c 78                	cmp    $0x78,%al
  800e98:	75 0d                	jne    800ea7 <strtol+0x78>
		s += 2, base = 16;
  800e9a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e9e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ea5:	eb 28                	jmp    800ecf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ea7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eab:	75 15                	jne    800ec2 <strtol+0x93>
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	3c 30                	cmp    $0x30,%al
  800eb4:	75 0c                	jne    800ec2 <strtol+0x93>
		s++, base = 8;
  800eb6:	ff 45 08             	incl   0x8(%ebp)
  800eb9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ec0:	eb 0d                	jmp    800ecf <strtol+0xa0>
	else if (base == 0)
  800ec2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec6:	75 07                	jne    800ecf <strtol+0xa0>
		base = 10;
  800ec8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	3c 2f                	cmp    $0x2f,%al
  800ed6:	7e 19                	jle    800ef1 <strtol+0xc2>
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	8a 00                	mov    (%eax),%al
  800edd:	3c 39                	cmp    $0x39,%al
  800edf:	7f 10                	jg     800ef1 <strtol+0xc2>
			dig = *s - '0';
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	0f be c0             	movsbl %al,%eax
  800ee9:	83 e8 30             	sub    $0x30,%eax
  800eec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800eef:	eb 42                	jmp    800f33 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	8a 00                	mov    (%eax),%al
  800ef6:	3c 60                	cmp    $0x60,%al
  800ef8:	7e 19                	jle    800f13 <strtol+0xe4>
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	3c 7a                	cmp    $0x7a,%al
  800f01:	7f 10                	jg     800f13 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	0f be c0             	movsbl %al,%eax
  800f0b:	83 e8 57             	sub    $0x57,%eax
  800f0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f11:	eb 20                	jmp    800f33 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3c 40                	cmp    $0x40,%al
  800f1a:	7e 39                	jle    800f55 <strtol+0x126>
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 5a                	cmp    $0x5a,%al
  800f23:	7f 30                	jg     800f55 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	0f be c0             	movsbl %al,%eax
  800f2d:	83 e8 37             	sub    $0x37,%eax
  800f30:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f36:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f39:	7d 19                	jge    800f54 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f3b:	ff 45 08             	incl   0x8(%ebp)
  800f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f41:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f45:	89 c2                	mov    %eax,%edx
  800f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f4a:	01 d0                	add    %edx,%eax
  800f4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f4f:	e9 7b ff ff ff       	jmp    800ecf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f54:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f59:	74 08                	je     800f63 <strtol+0x134>
		*endptr = (char *) s;
  800f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f61:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f63:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f67:	74 07                	je     800f70 <strtol+0x141>
  800f69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6c:	f7 d8                	neg    %eax
  800f6e:	eb 03                	jmp    800f73 <strtol+0x144>
  800f70:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f73:	c9                   	leave  
  800f74:	c3                   	ret    

00800f75 <ltostr>:

void
ltostr(long value, char *str)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f82:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f8d:	79 13                	jns    800fa2 <ltostr+0x2d>
	{
		neg = 1;
  800f8f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f9c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f9f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800faa:	99                   	cltd   
  800fab:	f7 f9                	idiv   %ecx
  800fad:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb3:	8d 50 01             	lea    0x1(%eax),%edx
  800fb6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fb9:	89 c2                	mov    %eax,%edx
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	01 d0                	add    %edx,%eax
  800fc0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fc3:	83 c2 30             	add    $0x30,%edx
  800fc6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fcb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fd0:	f7 e9                	imul   %ecx
  800fd2:	c1 fa 02             	sar    $0x2,%edx
  800fd5:	89 c8                	mov    %ecx,%eax
  800fd7:	c1 f8 1f             	sar    $0x1f,%eax
  800fda:	29 c2                	sub    %eax,%edx
  800fdc:	89 d0                	mov    %edx,%eax
  800fde:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fe1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fe9:	f7 e9                	imul   %ecx
  800feb:	c1 fa 02             	sar    $0x2,%edx
  800fee:	89 c8                	mov    %ecx,%eax
  800ff0:	c1 f8 1f             	sar    $0x1f,%eax
  800ff3:	29 c2                	sub    %eax,%edx
  800ff5:	89 d0                	mov    %edx,%eax
  800ff7:	c1 e0 02             	shl    $0x2,%eax
  800ffa:	01 d0                	add    %edx,%eax
  800ffc:	01 c0                	add    %eax,%eax
  800ffe:	29 c1                	sub    %eax,%ecx
  801000:	89 ca                	mov    %ecx,%edx
  801002:	85 d2                	test   %edx,%edx
  801004:	75 9c                	jne    800fa2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801006:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80100d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801010:	48                   	dec    %eax
  801011:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801014:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801018:	74 3d                	je     801057 <ltostr+0xe2>
		start = 1 ;
  80101a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801021:	eb 34                	jmp    801057 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801023:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	01 c2                	add    %eax,%edx
  801038:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80103b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103e:	01 c8                	add    %ecx,%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801044:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104a:	01 c2                	add    %eax,%edx
  80104c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80104f:	88 02                	mov    %al,(%edx)
		start++ ;
  801051:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801054:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80105d:	7c c4                	jl     801023 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80105f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801062:	8b 45 0c             	mov    0xc(%ebp),%eax
  801065:	01 d0                	add    %edx,%eax
  801067:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80106a:	90                   	nop
  80106b:	c9                   	leave  
  80106c:	c3                   	ret    

0080106d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801073:	ff 75 08             	pushl  0x8(%ebp)
  801076:	e8 54 fa ff ff       	call   800acf <strlen>
  80107b:	83 c4 04             	add    $0x4,%esp
  80107e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801081:	ff 75 0c             	pushl  0xc(%ebp)
  801084:	e8 46 fa ff ff       	call   800acf <strlen>
  801089:	83 c4 04             	add    $0x4,%esp
  80108c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80108f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801096:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109d:	eb 17                	jmp    8010b6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80109f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a5:	01 c2                	add    %eax,%edx
  8010a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	01 c8                	add    %ecx,%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010b3:	ff 45 fc             	incl   -0x4(%ebp)
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010bc:	7c e1                	jl     80109f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010cc:	eb 1f                	jmp    8010ed <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d1:	8d 50 01             	lea    0x1(%eax),%edx
  8010d4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010d7:	89 c2                	mov    %eax,%edx
  8010d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010dc:	01 c2                	add    %eax,%edx
  8010de:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	01 c8                	add    %ecx,%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010ea:	ff 45 f8             	incl   -0x8(%ebp)
  8010ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f3:	7c d9                	jl     8010ce <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fb:	01 d0                	add    %edx,%eax
  8010fd:	c6 00 00             	movb   $0x0,(%eax)
}
  801100:	90                   	nop
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801106:	8b 45 14             	mov    0x14(%ebp),%eax
  801109:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80110f:	8b 45 14             	mov    0x14(%ebp),%eax
  801112:	8b 00                	mov    (%eax),%eax
  801114:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80111b:	8b 45 10             	mov    0x10(%ebp),%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801126:	eb 0c                	jmp    801134 <strsplit+0x31>
			*string++ = 0;
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8d 50 01             	lea    0x1(%eax),%edx
  80112e:	89 55 08             	mov    %edx,0x8(%ebp)
  801131:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	84 c0                	test   %al,%al
  80113b:	74 18                	je     801155 <strsplit+0x52>
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	0f be c0             	movsbl %al,%eax
  801145:	50                   	push   %eax
  801146:	ff 75 0c             	pushl  0xc(%ebp)
  801149:	e8 13 fb ff ff       	call   800c61 <strchr>
  80114e:	83 c4 08             	add    $0x8,%esp
  801151:	85 c0                	test   %eax,%eax
  801153:	75 d3                	jne    801128 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	84 c0                	test   %al,%al
  80115c:	74 5a                	je     8011b8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80115e:	8b 45 14             	mov    0x14(%ebp),%eax
  801161:	8b 00                	mov    (%eax),%eax
  801163:	83 f8 0f             	cmp    $0xf,%eax
  801166:	75 07                	jne    80116f <strsplit+0x6c>
		{
			return 0;
  801168:	b8 00 00 00 00       	mov    $0x0,%eax
  80116d:	eb 66                	jmp    8011d5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80116f:	8b 45 14             	mov    0x14(%ebp),%eax
  801172:	8b 00                	mov    (%eax),%eax
  801174:	8d 48 01             	lea    0x1(%eax),%ecx
  801177:	8b 55 14             	mov    0x14(%ebp),%edx
  80117a:	89 0a                	mov    %ecx,(%edx)
  80117c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801183:	8b 45 10             	mov    0x10(%ebp),%eax
  801186:	01 c2                	add    %eax,%edx
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80118d:	eb 03                	jmp    801192 <strsplit+0x8f>
			string++;
  80118f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	84 c0                	test   %al,%al
  801199:	74 8b                	je     801126 <strsplit+0x23>
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	0f be c0             	movsbl %al,%eax
  8011a3:	50                   	push   %eax
  8011a4:	ff 75 0c             	pushl  0xc(%ebp)
  8011a7:	e8 b5 fa ff ff       	call   800c61 <strchr>
  8011ac:	83 c4 08             	add    $0x8,%esp
  8011af:	85 c0                	test   %eax,%eax
  8011b1:	74 dc                	je     80118f <strsplit+0x8c>
			string++;
	}
  8011b3:	e9 6e ff ff ff       	jmp    801126 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011b8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bc:	8b 00                	mov    (%eax),%eax
  8011be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c8:	01 d0                	add    %edx,%eax
  8011ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011d0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8011dd:	83 ec 04             	sub    $0x4,%esp
  8011e0:	68 f0 21 80 00       	push   $0x8021f0
  8011e5:	6a 19                	push   $0x19
  8011e7:	68 15 22 80 00       	push   $0x802215
  8011ec:	e8 ea 06 00 00       	call   8018db <_panic>

008011f1 <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 18             	sub    $0x18,%esp
  8011f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fa:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8011fd:	83 ec 04             	sub    $0x4,%esp
  801200:	68 24 22 80 00       	push   $0x802224
  801205:	6a 31                	push   $0x31
  801207:	68 15 22 80 00       	push   $0x802215
  80120c:	e8 ca 06 00 00       	call   8018db <_panic>

00801211 <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801217:	83 ec 04             	sub    $0x4,%esp
  80121a:	68 4c 22 80 00       	push   $0x80224c
  80121f:	6a 4a                	push   $0x4a
  801221:	68 15 22 80 00       	push   $0x802215
  801226:	e8 b0 06 00 00       	call   8018db <_panic>

0080122b <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801231:	83 ec 04             	sub    $0x4,%esp
  801234:	68 70 22 80 00       	push   $0x802270
  801239:	6a 70                	push   $0x70
  80123b:	68 15 22 80 00       	push   $0x802215
  801240:	e8 96 06 00 00       	call   8018db <_panic>

00801245 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80124b:	83 ec 04             	sub    $0x4,%esp
  80124e:	68 94 22 80 00       	push   $0x802294
  801253:	68 8b 00 00 00       	push   $0x8b
  801258:	68 15 22 80 00       	push   $0x802215
  80125d:	e8 79 06 00 00       	call   8018db <_panic>

00801262 <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801268:	83 ec 04             	sub    $0x4,%esp
  80126b:	68 b8 22 80 00       	push   $0x8022b8
  801270:	68 a8 00 00 00       	push   $0xa8
  801275:	68 15 22 80 00       	push   $0x802215
  80127a:	e8 5c 06 00 00       	call   8018db <_panic>

0080127f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	57                   	push   %edi
  801283:	56                   	push   %esi
  801284:	53                   	push   %ebx
  801285:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801291:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801294:	8b 7d 18             	mov    0x18(%ebp),%edi
  801297:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80129a:	cd 30                	int    $0x30
  80129c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80129f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012a2:	83 c4 10             	add    $0x10,%esp
  8012a5:	5b                   	pop    %ebx
  8012a6:	5e                   	pop    %esi
  8012a7:	5f                   	pop    %edi
  8012a8:	5d                   	pop    %ebp
  8012a9:	c3                   	ret    

008012aa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012b6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	52                   	push   %edx
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	50                   	push   %eax
  8012c6:	6a 00                	push   $0x0
  8012c8:	e8 b2 ff ff ff       	call   80127f <syscall>
  8012cd:	83 c4 18             	add    $0x18,%esp
}
  8012d0:	90                   	nop
  8012d1:	c9                   	leave  
  8012d2:	c3                   	ret    

008012d3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 01                	push   $0x1
  8012e2:	e8 98 ff ff ff       	call   80127f <syscall>
  8012e7:	83 c4 18             	add    $0x18,%esp
}
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    

008012ec <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	6a 00                	push   $0x0
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	50                   	push   %eax
  8012fb:	6a 05                	push   $0x5
  8012fd:	e8 7d ff ff ff       	call   80127f <syscall>
  801302:	83 c4 18             	add    $0x18,%esp
}
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	6a 02                	push   $0x2
  801316:	e8 64 ff ff ff       	call   80127f <syscall>
  80131b:	83 c4 18             	add    $0x18,%esp
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 03                	push   $0x3
  80132f:	e8 4b ff ff ff       	call   80127f <syscall>
  801334:	83 c4 18             	add    $0x18,%esp
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 04                	push   $0x4
  801348:	e8 32 ff ff ff       	call   80127f <syscall>
  80134d:	83 c4 18             	add    $0x18,%esp
}
  801350:	c9                   	leave  
  801351:	c3                   	ret    

00801352 <sys_env_exit>:


void sys_env_exit(void)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 06                	push   $0x6
  801361:	e8 19 ff ff ff       	call   80127f <syscall>
  801366:	83 c4 18             	add    $0x18,%esp
}
  801369:	90                   	nop
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80136f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	52                   	push   %edx
  80137c:	50                   	push   %eax
  80137d:	6a 07                	push   $0x7
  80137f:	e8 fb fe ff ff       	call   80127f <syscall>
  801384:	83 c4 18             	add    $0x18,%esp
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	56                   	push   %esi
  80138d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80138e:	8b 75 18             	mov    0x18(%ebp),%esi
  801391:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801394:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	56                   	push   %esi
  80139e:	53                   	push   %ebx
  80139f:	51                   	push   %ecx
  8013a0:	52                   	push   %edx
  8013a1:	50                   	push   %eax
  8013a2:	6a 08                	push   $0x8
  8013a4:	e8 d6 fe ff ff       	call   80127f <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
}
  8013ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013af:	5b                   	pop    %ebx
  8013b0:	5e                   	pop    %esi
  8013b1:	5d                   	pop    %ebp
  8013b2:	c3                   	ret    

008013b3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	52                   	push   %edx
  8013c3:	50                   	push   %eax
  8013c4:	6a 09                	push   $0x9
  8013c6:	e8 b4 fe ff ff       	call   80127f <syscall>
  8013cb:	83 c4 18             	add    $0x18,%esp
}
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	ff 75 0c             	pushl  0xc(%ebp)
  8013dc:	ff 75 08             	pushl  0x8(%ebp)
  8013df:	6a 0a                	push   $0xa
  8013e1:	e8 99 fe ff ff       	call   80127f <syscall>
  8013e6:	83 c4 18             	add    $0x18,%esp
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 0b                	push   $0xb
  8013fa:	e8 80 fe ff ff       	call   80127f <syscall>
  8013ff:	83 c4 18             	add    $0x18,%esp
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 0c                	push   $0xc
  801413:	e8 67 fe ff ff       	call   80127f <syscall>
  801418:	83 c4 18             	add    $0x18,%esp
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 0d                	push   $0xd
  80142c:	e8 4e fe ff ff       	call   80127f <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	ff 75 0c             	pushl  0xc(%ebp)
  801442:	ff 75 08             	pushl  0x8(%ebp)
  801445:	6a 11                	push   $0x11
  801447:	e8 33 fe ff ff       	call   80127f <syscall>
  80144c:	83 c4 18             	add    $0x18,%esp
	return;
  80144f:	90                   	nop
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	ff 75 0c             	pushl  0xc(%ebp)
  80145e:	ff 75 08             	pushl  0x8(%ebp)
  801461:	6a 12                	push   $0x12
  801463:	e8 17 fe ff ff       	call   80127f <syscall>
  801468:	83 c4 18             	add    $0x18,%esp
	return ;
  80146b:	90                   	nop
}
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 0e                	push   $0xe
  80147d:	e8 fd fd ff ff       	call   80127f <syscall>
  801482:	83 c4 18             	add    $0x18,%esp
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	ff 75 08             	pushl  0x8(%ebp)
  801495:	6a 0f                	push   $0xf
  801497:	e8 e3 fd ff ff       	call   80127f <syscall>
  80149c:	83 c4 18             	add    $0x18,%esp
}
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    

008014a1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 10                	push   $0x10
  8014b0:	e8 ca fd ff ff       	call   80127f <syscall>
  8014b5:	83 c4 18             	add    $0x18,%esp
}
  8014b8:	90                   	nop
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 14                	push   $0x14
  8014ca:	e8 b0 fd ff ff       	call   80127f <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 15                	push   $0x15
  8014e4:	e8 96 fd ff ff       	call   80127f <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	90                   	nop
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <sys_cputc>:


void
sys_cputc(const char c)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014fb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	50                   	push   %eax
  801508:	6a 16                	push   $0x16
  80150a:	e8 70 fd ff ff       	call   80127f <syscall>
  80150f:	83 c4 18             	add    $0x18,%esp
}
  801512:	90                   	nop
  801513:	c9                   	leave  
  801514:	c3                   	ret    

00801515 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 17                	push   $0x17
  801524:	e8 56 fd ff ff       	call   80127f <syscall>
  801529:	83 c4 18             	add    $0x18,%esp
}
  80152c:	90                   	nop
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	ff 75 0c             	pushl  0xc(%ebp)
  80153e:	50                   	push   %eax
  80153f:	6a 18                	push   $0x18
  801541:	e8 39 fd ff ff       	call   80127f <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80154e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	52                   	push   %edx
  80155b:	50                   	push   %eax
  80155c:	6a 1b                	push   $0x1b
  80155e:	e8 1c fd ff ff       	call   80127f <syscall>
  801563:	83 c4 18             	add    $0x18,%esp
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80156b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	52                   	push   %edx
  801578:	50                   	push   %eax
  801579:	6a 19                	push   $0x19
  80157b:	e8 ff fc ff ff       	call   80127f <syscall>
  801580:	83 c4 18             	add    $0x18,%esp
}
  801583:	90                   	nop
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801589:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	52                   	push   %edx
  801596:	50                   	push   %eax
  801597:	6a 1a                	push   $0x1a
  801599:	e8 e1 fc ff ff       	call   80127f <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
}
  8015a1:	90                   	nop
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    

008015a4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	83 ec 04             	sub    $0x4,%esp
  8015aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015b0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015b3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	6a 00                	push   $0x0
  8015bc:	51                   	push   %ecx
  8015bd:	52                   	push   %edx
  8015be:	ff 75 0c             	pushl  0xc(%ebp)
  8015c1:	50                   	push   %eax
  8015c2:	6a 1c                	push   $0x1c
  8015c4:	e8 b6 fc ff ff       	call   80127f <syscall>
  8015c9:	83 c4 18             	add    $0x18,%esp
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	52                   	push   %edx
  8015de:	50                   	push   %eax
  8015df:	6a 1d                	push   $0x1d
  8015e1:	e8 99 fc ff ff       	call   80127f <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	51                   	push   %ecx
  8015fc:	52                   	push   %edx
  8015fd:	50                   	push   %eax
  8015fe:	6a 1e                	push   $0x1e
  801600:	e8 7a fc ff ff       	call   80127f <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80160d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	52                   	push   %edx
  80161a:	50                   	push   %eax
  80161b:	6a 1f                	push   $0x1f
  80161d:	e8 5d fc ff ff       	call   80127f <syscall>
  801622:	83 c4 18             	add    $0x18,%esp
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 20                	push   $0x20
  801636:	e8 44 fc ff ff       	call   80127f <syscall>
  80163b:	83 c4 18             	add    $0x18,%esp
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	ff 75 10             	pushl  0x10(%ebp)
  80164d:	ff 75 0c             	pushl  0xc(%ebp)
  801650:	50                   	push   %eax
  801651:	6a 21                	push   $0x21
  801653:	e8 27 fc ff ff       	call   80127f <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <sys_run_env>:


void
sys_run_env(int32 envId)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	50                   	push   %eax
  80166c:	6a 22                	push   $0x22
  80166e:	e8 0c fc ff ff       	call   80127f <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
}
  801676:	90                   	nop
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	50                   	push   %eax
  801688:	6a 23                	push   $0x23
  80168a:	e8 f0 fb ff ff       	call   80127f <syscall>
  80168f:	83 c4 18             	add    $0x18,%esp
}
  801692:	90                   	nop
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80169b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80169e:	8d 50 04             	lea    0x4(%eax),%edx
  8016a1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	52                   	push   %edx
  8016ab:	50                   	push   %eax
  8016ac:	6a 24                	push   $0x24
  8016ae:	e8 cc fb ff ff       	call   80127f <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
	return result;
  8016b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016bf:	89 01                	mov    %eax,(%ecx)
  8016c1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	c9                   	leave  
  8016c8:	c2 04 00             	ret    $0x4

008016cb <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	ff 75 10             	pushl  0x10(%ebp)
  8016d5:	ff 75 0c             	pushl  0xc(%ebp)
  8016d8:	ff 75 08             	pushl  0x8(%ebp)
  8016db:	6a 13                	push   $0x13
  8016dd:	e8 9d fb ff ff       	call   80127f <syscall>
  8016e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e5:	90                   	nop
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 25                	push   $0x25
  8016f7:	e8 83 fb ff ff       	call   80127f <syscall>
  8016fc:	83 c4 18             	add    $0x18,%esp
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 04             	sub    $0x4,%esp
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80170d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	50                   	push   %eax
  80171a:	6a 26                	push   $0x26
  80171c:	e8 5e fb ff ff       	call   80127f <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
	return ;
  801724:	90                   	nop
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <rsttst>:
void rsttst()
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 28                	push   $0x28
  801736:	e8 44 fb ff ff       	call   80127f <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
	return ;
  80173e:	90                   	nop
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	83 ec 04             	sub    $0x4,%esp
  801747:	8b 45 14             	mov    0x14(%ebp),%eax
  80174a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80174d:	8b 55 18             	mov    0x18(%ebp),%edx
  801750:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801754:	52                   	push   %edx
  801755:	50                   	push   %eax
  801756:	ff 75 10             	pushl  0x10(%ebp)
  801759:	ff 75 0c             	pushl  0xc(%ebp)
  80175c:	ff 75 08             	pushl  0x8(%ebp)
  80175f:	6a 27                	push   $0x27
  801761:	e8 19 fb ff ff       	call   80127f <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
	return ;
  801769:	90                   	nop
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <chktst>:
void chktst(uint32 n)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	ff 75 08             	pushl  0x8(%ebp)
  80177a:	6a 29                	push   $0x29
  80177c:	e8 fe fa ff ff       	call   80127f <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
	return ;
  801784:	90                   	nop
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <inctst>:

void inctst()
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 2a                	push   $0x2a
  801796:	e8 e4 fa ff ff       	call   80127f <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
	return ;
  80179e:	90                   	nop
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <gettst>:
uint32 gettst()
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 2b                	push   $0x2b
  8017b0:	e8 ca fa ff ff       	call   80127f <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 2c                	push   $0x2c
  8017cc:	e8 ae fa ff ff       	call   80127f <syscall>
  8017d1:	83 c4 18             	add    $0x18,%esp
  8017d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017d7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017db:	75 07                	jne    8017e4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e2:	eb 05                	jmp    8017e9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 2c                	push   $0x2c
  8017fd:	e8 7d fa ff ff       	call   80127f <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
  801805:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801808:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80180c:	75 07                	jne    801815 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80180e:	b8 01 00 00 00       	mov    $0x1,%eax
  801813:	eb 05                	jmp    80181a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801815:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 2c                	push   $0x2c
  80182e:	e8 4c fa ff ff       	call   80127f <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
  801836:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801839:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80183d:	75 07                	jne    801846 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80183f:	b8 01 00 00 00       	mov    $0x1,%eax
  801844:	eb 05                	jmp    80184b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801846:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 2c                	push   $0x2c
  80185f:	e8 1b fa ff ff       	call   80127f <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
  801867:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80186a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80186e:	75 07                	jne    801877 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801870:	b8 01 00 00 00       	mov    $0x1,%eax
  801875:	eb 05                	jmp    80187c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801877:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	ff 75 08             	pushl  0x8(%ebp)
  80188c:	6a 2d                	push   $0x2d
  80188e:	e8 ec f9 ff ff       	call   80127f <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
	return ;
  801896:	90                   	nop
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80189d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	6a 00                	push   $0x0
  8018ab:	53                   	push   %ebx
  8018ac:	51                   	push   %ecx
  8018ad:	52                   	push   %edx
  8018ae:	50                   	push   %eax
  8018af:	6a 2e                	push   $0x2e
  8018b1:	e8 c9 f9 ff ff       	call   80127f <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	52                   	push   %edx
  8018ce:	50                   	push   %eax
  8018cf:	6a 2f                	push   $0x2f
  8018d1:	e8 a9 f9 ff ff       	call   80127f <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8018e1:	8d 45 10             	lea    0x10(%ebp),%eax
  8018e4:	83 c0 04             	add    $0x4,%eax
  8018e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8018ea:	a1 18 31 80 00       	mov    0x803118,%eax
  8018ef:	85 c0                	test   %eax,%eax
  8018f1:	74 16                	je     801909 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8018f3:	a1 18 31 80 00       	mov    0x803118,%eax
  8018f8:	83 ec 08             	sub    $0x8,%esp
  8018fb:	50                   	push   %eax
  8018fc:	68 e0 22 80 00       	push   $0x8022e0
  801901:	e8 47 eb ff ff       	call   80044d <cprintf>
  801906:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801909:	a1 00 30 80 00       	mov    0x803000,%eax
  80190e:	ff 75 0c             	pushl  0xc(%ebp)
  801911:	ff 75 08             	pushl  0x8(%ebp)
  801914:	50                   	push   %eax
  801915:	68 e5 22 80 00       	push   $0x8022e5
  80191a:	e8 2e eb ff ff       	call   80044d <cprintf>
  80191f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801922:	8b 45 10             	mov    0x10(%ebp),%eax
  801925:	83 ec 08             	sub    $0x8,%esp
  801928:	ff 75 f4             	pushl  -0xc(%ebp)
  80192b:	50                   	push   %eax
  80192c:	e8 b1 ea ff ff       	call   8003e2 <vcprintf>
  801931:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801934:	83 ec 08             	sub    $0x8,%esp
  801937:	6a 00                	push   $0x0
  801939:	68 01 23 80 00       	push   $0x802301
  80193e:	e8 9f ea ff ff       	call   8003e2 <vcprintf>
  801943:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801946:	e8 20 ea ff ff       	call   80036b <exit>

	// should not return here
	while (1) ;
  80194b:	eb fe                	jmp    80194b <_panic+0x70>

0080194d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801953:	a1 20 30 80 00       	mov    0x803020,%eax
  801958:	8b 50 74             	mov    0x74(%eax),%edx
  80195b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195e:	39 c2                	cmp    %eax,%edx
  801960:	74 14                	je     801976 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	68 04 23 80 00       	push   $0x802304
  80196a:	6a 26                	push   $0x26
  80196c:	68 50 23 80 00       	push   $0x802350
  801971:	e8 65 ff ff ff       	call   8018db <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801976:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80197d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801984:	e9 b6 00 00 00       	jmp    801a3f <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  801989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	01 d0                	add    %edx,%eax
  801998:	8b 00                	mov    (%eax),%eax
  80199a:	85 c0                	test   %eax,%eax
  80199c:	75 08                	jne    8019a6 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80199e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8019a1:	e9 96 00 00 00       	jmp    801a3c <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8019a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019ad:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8019b4:	eb 5d                	jmp    801a13 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8019b6:	a1 20 30 80 00       	mov    0x803020,%eax
  8019bb:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8019c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019c4:	c1 e2 04             	shl    $0x4,%edx
  8019c7:	01 d0                	add    %edx,%eax
  8019c9:	8a 40 04             	mov    0x4(%eax),%al
  8019cc:	84 c0                	test   %al,%al
  8019ce:	75 40                	jne    801a10 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8019d5:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8019db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019de:	c1 e2 04             	shl    $0x4,%edx
  8019e1:	01 d0                	add    %edx,%eax
  8019e3:	8b 00                	mov    (%eax),%eax
  8019e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019f0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8019f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	01 c8                	add    %ecx,%eax
  801a01:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a03:	39 c2                	cmp    %eax,%edx
  801a05:	75 09                	jne    801a10 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  801a07:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a0e:	eb 12                	jmp    801a22 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a10:	ff 45 e8             	incl   -0x18(%ebp)
  801a13:	a1 20 30 80 00       	mov    0x803020,%eax
  801a18:	8b 50 74             	mov    0x74(%eax),%edx
  801a1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a1e:	39 c2                	cmp    %eax,%edx
  801a20:	77 94                	ja     8019b6 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a26:	75 14                	jne    801a3c <CheckWSWithoutLastIndex+0xef>
			panic(
  801a28:	83 ec 04             	sub    $0x4,%esp
  801a2b:	68 5c 23 80 00       	push   $0x80235c
  801a30:	6a 3a                	push   $0x3a
  801a32:	68 50 23 80 00       	push   $0x802350
  801a37:	e8 9f fe ff ff       	call   8018db <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a3c:	ff 45 f0             	incl   -0x10(%ebp)
  801a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a42:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a45:	0f 8c 3e ff ff ff    	jl     801989 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a4b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a52:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a59:	eb 20                	jmp    801a7b <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a5b:	a1 20 30 80 00       	mov    0x803020,%eax
  801a60:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801a66:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a69:	c1 e2 04             	shl    $0x4,%edx
  801a6c:	01 d0                	add    %edx,%eax
  801a6e:	8a 40 04             	mov    0x4(%eax),%al
  801a71:	3c 01                	cmp    $0x1,%al
  801a73:	75 03                	jne    801a78 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  801a75:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a78:	ff 45 e0             	incl   -0x20(%ebp)
  801a7b:	a1 20 30 80 00       	mov    0x803020,%eax
  801a80:	8b 50 74             	mov    0x74(%eax),%edx
  801a83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a86:	39 c2                	cmp    %eax,%edx
  801a88:	77 d1                	ja     801a5b <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a90:	74 14                	je     801aa6 <CheckWSWithoutLastIndex+0x159>
		panic(
  801a92:	83 ec 04             	sub    $0x4,%esp
  801a95:	68 b0 23 80 00       	push   $0x8023b0
  801a9a:	6a 44                	push   $0x44
  801a9c:	68 50 23 80 00       	push   $0x802350
  801aa1:	e8 35 fe ff ff       	call   8018db <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801aa6:	90                   	nop
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    
  801aa9:	66 90                	xchg   %ax,%ax
  801aab:	90                   	nop

00801aac <__udivdi3>:
  801aac:	55                   	push   %ebp
  801aad:	57                   	push   %edi
  801aae:	56                   	push   %esi
  801aaf:	53                   	push   %ebx
  801ab0:	83 ec 1c             	sub    $0x1c,%esp
  801ab3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ab7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801abb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801abf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ac3:	89 ca                	mov    %ecx,%edx
  801ac5:	89 f8                	mov    %edi,%eax
  801ac7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801acb:	85 f6                	test   %esi,%esi
  801acd:	75 2d                	jne    801afc <__udivdi3+0x50>
  801acf:	39 cf                	cmp    %ecx,%edi
  801ad1:	77 65                	ja     801b38 <__udivdi3+0x8c>
  801ad3:	89 fd                	mov    %edi,%ebp
  801ad5:	85 ff                	test   %edi,%edi
  801ad7:	75 0b                	jne    801ae4 <__udivdi3+0x38>
  801ad9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ade:	31 d2                	xor    %edx,%edx
  801ae0:	f7 f7                	div    %edi
  801ae2:	89 c5                	mov    %eax,%ebp
  801ae4:	31 d2                	xor    %edx,%edx
  801ae6:	89 c8                	mov    %ecx,%eax
  801ae8:	f7 f5                	div    %ebp
  801aea:	89 c1                	mov    %eax,%ecx
  801aec:	89 d8                	mov    %ebx,%eax
  801aee:	f7 f5                	div    %ebp
  801af0:	89 cf                	mov    %ecx,%edi
  801af2:	89 fa                	mov    %edi,%edx
  801af4:	83 c4 1c             	add    $0x1c,%esp
  801af7:	5b                   	pop    %ebx
  801af8:	5e                   	pop    %esi
  801af9:	5f                   	pop    %edi
  801afa:	5d                   	pop    %ebp
  801afb:	c3                   	ret    
  801afc:	39 ce                	cmp    %ecx,%esi
  801afe:	77 28                	ja     801b28 <__udivdi3+0x7c>
  801b00:	0f bd fe             	bsr    %esi,%edi
  801b03:	83 f7 1f             	xor    $0x1f,%edi
  801b06:	75 40                	jne    801b48 <__udivdi3+0x9c>
  801b08:	39 ce                	cmp    %ecx,%esi
  801b0a:	72 0a                	jb     801b16 <__udivdi3+0x6a>
  801b0c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b10:	0f 87 9e 00 00 00    	ja     801bb4 <__udivdi3+0x108>
  801b16:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1b:	89 fa                	mov    %edi,%edx
  801b1d:	83 c4 1c             	add    $0x1c,%esp
  801b20:	5b                   	pop    %ebx
  801b21:	5e                   	pop    %esi
  801b22:	5f                   	pop    %edi
  801b23:	5d                   	pop    %ebp
  801b24:	c3                   	ret    
  801b25:	8d 76 00             	lea    0x0(%esi),%esi
  801b28:	31 ff                	xor    %edi,%edi
  801b2a:	31 c0                	xor    %eax,%eax
  801b2c:	89 fa                	mov    %edi,%edx
  801b2e:	83 c4 1c             	add    $0x1c,%esp
  801b31:	5b                   	pop    %ebx
  801b32:	5e                   	pop    %esi
  801b33:	5f                   	pop    %edi
  801b34:	5d                   	pop    %ebp
  801b35:	c3                   	ret    
  801b36:	66 90                	xchg   %ax,%ax
  801b38:	89 d8                	mov    %ebx,%eax
  801b3a:	f7 f7                	div    %edi
  801b3c:	31 ff                	xor    %edi,%edi
  801b3e:	89 fa                	mov    %edi,%edx
  801b40:	83 c4 1c             	add    $0x1c,%esp
  801b43:	5b                   	pop    %ebx
  801b44:	5e                   	pop    %esi
  801b45:	5f                   	pop    %edi
  801b46:	5d                   	pop    %ebp
  801b47:	c3                   	ret    
  801b48:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b4d:	89 eb                	mov    %ebp,%ebx
  801b4f:	29 fb                	sub    %edi,%ebx
  801b51:	89 f9                	mov    %edi,%ecx
  801b53:	d3 e6                	shl    %cl,%esi
  801b55:	89 c5                	mov    %eax,%ebp
  801b57:	88 d9                	mov    %bl,%cl
  801b59:	d3 ed                	shr    %cl,%ebp
  801b5b:	89 e9                	mov    %ebp,%ecx
  801b5d:	09 f1                	or     %esi,%ecx
  801b5f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b63:	89 f9                	mov    %edi,%ecx
  801b65:	d3 e0                	shl    %cl,%eax
  801b67:	89 c5                	mov    %eax,%ebp
  801b69:	89 d6                	mov    %edx,%esi
  801b6b:	88 d9                	mov    %bl,%cl
  801b6d:	d3 ee                	shr    %cl,%esi
  801b6f:	89 f9                	mov    %edi,%ecx
  801b71:	d3 e2                	shl    %cl,%edx
  801b73:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b77:	88 d9                	mov    %bl,%cl
  801b79:	d3 e8                	shr    %cl,%eax
  801b7b:	09 c2                	or     %eax,%edx
  801b7d:	89 d0                	mov    %edx,%eax
  801b7f:	89 f2                	mov    %esi,%edx
  801b81:	f7 74 24 0c          	divl   0xc(%esp)
  801b85:	89 d6                	mov    %edx,%esi
  801b87:	89 c3                	mov    %eax,%ebx
  801b89:	f7 e5                	mul    %ebp
  801b8b:	39 d6                	cmp    %edx,%esi
  801b8d:	72 19                	jb     801ba8 <__udivdi3+0xfc>
  801b8f:	74 0b                	je     801b9c <__udivdi3+0xf0>
  801b91:	89 d8                	mov    %ebx,%eax
  801b93:	31 ff                	xor    %edi,%edi
  801b95:	e9 58 ff ff ff       	jmp    801af2 <__udivdi3+0x46>
  801b9a:	66 90                	xchg   %ax,%ax
  801b9c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ba0:	89 f9                	mov    %edi,%ecx
  801ba2:	d3 e2                	shl    %cl,%edx
  801ba4:	39 c2                	cmp    %eax,%edx
  801ba6:	73 e9                	jae    801b91 <__udivdi3+0xe5>
  801ba8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bab:	31 ff                	xor    %edi,%edi
  801bad:	e9 40 ff ff ff       	jmp    801af2 <__udivdi3+0x46>
  801bb2:	66 90                	xchg   %ax,%ax
  801bb4:	31 c0                	xor    %eax,%eax
  801bb6:	e9 37 ff ff ff       	jmp    801af2 <__udivdi3+0x46>
  801bbb:	90                   	nop

00801bbc <__umoddi3>:
  801bbc:	55                   	push   %ebp
  801bbd:	57                   	push   %edi
  801bbe:	56                   	push   %esi
  801bbf:	53                   	push   %ebx
  801bc0:	83 ec 1c             	sub    $0x1c,%esp
  801bc3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bc7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bcb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bcf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bd3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bd7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bdb:	89 f3                	mov    %esi,%ebx
  801bdd:	89 fa                	mov    %edi,%edx
  801bdf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801be3:	89 34 24             	mov    %esi,(%esp)
  801be6:	85 c0                	test   %eax,%eax
  801be8:	75 1a                	jne    801c04 <__umoddi3+0x48>
  801bea:	39 f7                	cmp    %esi,%edi
  801bec:	0f 86 a2 00 00 00    	jbe    801c94 <__umoddi3+0xd8>
  801bf2:	89 c8                	mov    %ecx,%eax
  801bf4:	89 f2                	mov    %esi,%edx
  801bf6:	f7 f7                	div    %edi
  801bf8:	89 d0                	mov    %edx,%eax
  801bfa:	31 d2                	xor    %edx,%edx
  801bfc:	83 c4 1c             	add    $0x1c,%esp
  801bff:	5b                   	pop    %ebx
  801c00:	5e                   	pop    %esi
  801c01:	5f                   	pop    %edi
  801c02:	5d                   	pop    %ebp
  801c03:	c3                   	ret    
  801c04:	39 f0                	cmp    %esi,%eax
  801c06:	0f 87 ac 00 00 00    	ja     801cb8 <__umoddi3+0xfc>
  801c0c:	0f bd e8             	bsr    %eax,%ebp
  801c0f:	83 f5 1f             	xor    $0x1f,%ebp
  801c12:	0f 84 ac 00 00 00    	je     801cc4 <__umoddi3+0x108>
  801c18:	bf 20 00 00 00       	mov    $0x20,%edi
  801c1d:	29 ef                	sub    %ebp,%edi
  801c1f:	89 fe                	mov    %edi,%esi
  801c21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c25:	89 e9                	mov    %ebp,%ecx
  801c27:	d3 e0                	shl    %cl,%eax
  801c29:	89 d7                	mov    %edx,%edi
  801c2b:	89 f1                	mov    %esi,%ecx
  801c2d:	d3 ef                	shr    %cl,%edi
  801c2f:	09 c7                	or     %eax,%edi
  801c31:	89 e9                	mov    %ebp,%ecx
  801c33:	d3 e2                	shl    %cl,%edx
  801c35:	89 14 24             	mov    %edx,(%esp)
  801c38:	89 d8                	mov    %ebx,%eax
  801c3a:	d3 e0                	shl    %cl,%eax
  801c3c:	89 c2                	mov    %eax,%edx
  801c3e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c42:	d3 e0                	shl    %cl,%eax
  801c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c48:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c4c:	89 f1                	mov    %esi,%ecx
  801c4e:	d3 e8                	shr    %cl,%eax
  801c50:	09 d0                	or     %edx,%eax
  801c52:	d3 eb                	shr    %cl,%ebx
  801c54:	89 da                	mov    %ebx,%edx
  801c56:	f7 f7                	div    %edi
  801c58:	89 d3                	mov    %edx,%ebx
  801c5a:	f7 24 24             	mull   (%esp)
  801c5d:	89 c6                	mov    %eax,%esi
  801c5f:	89 d1                	mov    %edx,%ecx
  801c61:	39 d3                	cmp    %edx,%ebx
  801c63:	0f 82 87 00 00 00    	jb     801cf0 <__umoddi3+0x134>
  801c69:	0f 84 91 00 00 00    	je     801d00 <__umoddi3+0x144>
  801c6f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c73:	29 f2                	sub    %esi,%edx
  801c75:	19 cb                	sbb    %ecx,%ebx
  801c77:	89 d8                	mov    %ebx,%eax
  801c79:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c7d:	d3 e0                	shl    %cl,%eax
  801c7f:	89 e9                	mov    %ebp,%ecx
  801c81:	d3 ea                	shr    %cl,%edx
  801c83:	09 d0                	or     %edx,%eax
  801c85:	89 e9                	mov    %ebp,%ecx
  801c87:	d3 eb                	shr    %cl,%ebx
  801c89:	89 da                	mov    %ebx,%edx
  801c8b:	83 c4 1c             	add    $0x1c,%esp
  801c8e:	5b                   	pop    %ebx
  801c8f:	5e                   	pop    %esi
  801c90:	5f                   	pop    %edi
  801c91:	5d                   	pop    %ebp
  801c92:	c3                   	ret    
  801c93:	90                   	nop
  801c94:	89 fd                	mov    %edi,%ebp
  801c96:	85 ff                	test   %edi,%edi
  801c98:	75 0b                	jne    801ca5 <__umoddi3+0xe9>
  801c9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9f:	31 d2                	xor    %edx,%edx
  801ca1:	f7 f7                	div    %edi
  801ca3:	89 c5                	mov    %eax,%ebp
  801ca5:	89 f0                	mov    %esi,%eax
  801ca7:	31 d2                	xor    %edx,%edx
  801ca9:	f7 f5                	div    %ebp
  801cab:	89 c8                	mov    %ecx,%eax
  801cad:	f7 f5                	div    %ebp
  801caf:	89 d0                	mov    %edx,%eax
  801cb1:	e9 44 ff ff ff       	jmp    801bfa <__umoddi3+0x3e>
  801cb6:	66 90                	xchg   %ax,%ax
  801cb8:	89 c8                	mov    %ecx,%eax
  801cba:	89 f2                	mov    %esi,%edx
  801cbc:	83 c4 1c             	add    $0x1c,%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5f                   	pop    %edi
  801cc2:	5d                   	pop    %ebp
  801cc3:	c3                   	ret    
  801cc4:	3b 04 24             	cmp    (%esp),%eax
  801cc7:	72 06                	jb     801ccf <__umoddi3+0x113>
  801cc9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ccd:	77 0f                	ja     801cde <__umoddi3+0x122>
  801ccf:	89 f2                	mov    %esi,%edx
  801cd1:	29 f9                	sub    %edi,%ecx
  801cd3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cd7:	89 14 24             	mov    %edx,(%esp)
  801cda:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cde:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ce2:	8b 14 24             	mov    (%esp),%edx
  801ce5:	83 c4 1c             	add    $0x1c,%esp
  801ce8:	5b                   	pop    %ebx
  801ce9:	5e                   	pop    %esi
  801cea:	5f                   	pop    %edi
  801ceb:	5d                   	pop    %ebp
  801cec:	c3                   	ret    
  801ced:	8d 76 00             	lea    0x0(%esi),%esi
  801cf0:	2b 04 24             	sub    (%esp),%eax
  801cf3:	19 fa                	sbb    %edi,%edx
  801cf5:	89 d1                	mov    %edx,%ecx
  801cf7:	89 c6                	mov    %eax,%esi
  801cf9:	e9 71 ff ff ff       	jmp    801c6f <__umoddi3+0xb3>
  801cfe:	66 90                	xchg   %ax,%ax
  801d00:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d04:	72 ea                	jb     801cf0 <__umoddi3+0x134>
  801d06:	89 d9                	mov    %ebx,%ecx
  801d08:	e9 62 ff ff ff       	jmp    801c6f <__umoddi3+0xb3>
