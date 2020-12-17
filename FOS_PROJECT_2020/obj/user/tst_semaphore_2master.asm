
obj/user/tst_semaphore_2master:     file format elf32-i386


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
  800031:	e8 69 01 00 00       	call   80019f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: take user input, create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	int envID = sys_getenvid();
  800041:	e8 8a 13 00 00       	call   8013d0 <sys_getenvid>
  800046:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char line[256] ;
	readline("Enter total number of customers: ", line) ;
  800049:	83 ec 08             	sub    $0x8,%esp
  80004c:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	68 c0 1c 80 00       	push   $0x801cc0
  800058:	e8 dd 09 00 00       	call   800a3a <readline>
  80005d:	83 c4 10             	add    $0x10,%esp
	int totalNumOfCusts = strtol(line, NULL, 10);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	6a 0a                	push   $0xa
  800065:	6a 00                	push   $0x0
  800067:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  80006d:	50                   	push   %eax
  80006e:	e8 2d 0f 00 00       	call   800fa0 <strtol>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	readline("Enter shop capacity: ", line) ;
  800079:	83 ec 08             	sub    $0x8,%esp
  80007c:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  800082:	50                   	push   %eax
  800083:	68 e2 1c 80 00       	push   $0x801ce2
  800088:	e8 ad 09 00 00       	call   800a3a <readline>
  80008d:	83 c4 10             	add    $0x10,%esp
	int shopCapacity = strtol(line, NULL, 10);
  800090:	83 ec 04             	sub    $0x4,%esp
  800093:	6a 0a                	push   $0xa
  800095:	6a 00                	push   $0x0
  800097:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  80009d:	50                   	push   %eax
  80009e:	e8 fd 0e 00 00       	call   800fa0 <strtol>
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_createSemaphore("shopCapacity", shopCapacity);
  8000a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	50                   	push   %eax
  8000b0:	68 f8 1c 80 00       	push   $0x801cf8
  8000b5:	e8 3e 15 00 00       	call   8015f8 <sys_createSemaphore>
  8000ba:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore("depend", 0);
  8000bd:	83 ec 08             	sub    $0x8,%esp
  8000c0:	6a 00                	push   $0x0
  8000c2:	68 05 1d 80 00       	push   $0x801d05
  8000c7:	e8 2c 15 00 00       	call   8015f8 <sys_createSemaphore>
  8000cc:	83 c4 10             	add    $0x10,%esp

	int i = 0 ;
  8000cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int id ;
	for (; i<totalNumOfCusts; i++)
  8000d6:	eb 39                	jmp    800111 <_main+0xd9>
	{
		id = sys_create_env("sem2Slave", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000dd:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8000e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e8:	8b 40 74             	mov    0x74(%eax),%eax
  8000eb:	83 ec 04             	sub    $0x4,%esp
  8000ee:	52                   	push   %edx
  8000ef:	50                   	push   %eax
  8000f0:	68 0c 1d 80 00       	push   $0x801d0c
  8000f5:	e8 0f 16 00 00       	call   801709 <sys_create_env>
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		sys_run_env(id) ;
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e4             	pushl  -0x1c(%ebp)
  800106:	e8 1b 16 00 00       	call   801726 <sys_run_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore("shopCapacity", shopCapacity);
	sys_createSemaphore("depend", 0);

	int i = 0 ;
	int id ;
	for (; i<totalNumOfCusts; i++)
  80010e:	ff 45 f4             	incl   -0xc(%ebp)
  800111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800114:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800117:	7c bf                	jl     8000d8 <_main+0xa0>
	{
		id = sys_create_env("sem2Slave", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
		sys_run_env(id) ;
	}

	for (i = 0 ; i<totalNumOfCusts; i++)
  800119:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800120:	eb 16                	jmp    800138 <_main+0x100>
	{
		sys_waitSemaphore(envID, "depend") ;
  800122:	83 ec 08             	sub    $0x8,%esp
  800125:	68 05 1d 80 00       	push   $0x801d05
  80012a:	ff 75 f0             	pushl  -0x10(%ebp)
  80012d:	e8 ff 14 00 00       	call   801631 <sys_waitSemaphore>
  800132:	83 c4 10             	add    $0x10,%esp
	{
		id = sys_create_env("sem2Slave", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
		sys_run_env(id) ;
	}

	for (i = 0 ; i<totalNumOfCusts; i++)
  800135:	ff 45 f4             	incl   -0xc(%ebp)
  800138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80013b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80013e:	7c e2                	jl     800122 <_main+0xea>
	{
		sys_waitSemaphore(envID, "depend") ;
	}
	int sem1val = sys_getSemaphoreValue(envID, "shopCapacity");
  800140:	83 ec 08             	sub    $0x8,%esp
  800143:	68 f8 1c 80 00       	push   $0x801cf8
  800148:	ff 75 f0             	pushl  -0x10(%ebp)
  80014b:	e8 c4 14 00 00       	call   801614 <sys_getSemaphoreValue>
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend");
  800156:	83 ec 08             	sub    $0x8,%esp
  800159:	68 05 1d 80 00       	push   $0x801d05
  80015e:	ff 75 f0             	pushl  -0x10(%ebp)
  800161:	e8 ae 14 00 00       	call   801614 <sys_getSemaphoreValue>
  800166:	83 c4 10             	add    $0x10,%esp
  800169:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (sem2val == 0 && sem1val == shopCapacity)
  80016c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800170:	75 1a                	jne    80018c <_main+0x154>
  800172:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800175:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800178:	75 12                	jne    80018c <_main+0x154>
		cprintf("Congratulations!! Test of Semaphores [2] completed successfully!!\n\n\n");
  80017a:	83 ec 0c             	sub    $0xc,%esp
  80017d:	68 18 1d 80 00       	push   $0x801d18
  800182:	e8 31 02 00 00       	call   8003b8 <cprintf>
  800187:	83 c4 10             	add    $0x10,%esp
  80018a:	eb 10                	jmp    80019c <_main+0x164>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	68 60 1d 80 00       	push   $0x801d60
  800194:	e8 1f 02 00 00       	call   8003b8 <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp

	return;
  80019c:	90                   	nop
}
  80019d:	c9                   	leave  
  80019e:	c3                   	ret    

0080019f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001a5:	e8 3f 12 00 00       	call   8013e9 <sys_getenvindex>
  8001aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001b0:	89 d0                	mov    %edx,%eax
  8001b2:	c1 e0 03             	shl    $0x3,%eax
  8001b5:	01 d0                	add    %edx,%eax
  8001b7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001be:	01 c8                	add    %ecx,%eax
  8001c0:	01 c0                	add    %eax,%eax
  8001c2:	01 d0                	add    %edx,%eax
  8001c4:	01 c0                	add    %eax,%eax
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	89 c2                	mov    %eax,%edx
  8001ca:	c1 e2 05             	shl    $0x5,%edx
  8001cd:	29 c2                	sub    %eax,%edx
  8001cf:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001d6:	89 c2                	mov    %eax,%edx
  8001d8:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001de:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e8:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001ee:	84 c0                	test   %al,%al
  8001f0:	74 0f                	je     800201 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f7:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001fc:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800201:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800205:	7e 0a                	jle    800211 <libmain+0x72>
		binaryname = argv[0];
  800207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800211:	83 ec 08             	sub    $0x8,%esp
  800214:	ff 75 0c             	pushl  0xc(%ebp)
  800217:	ff 75 08             	pushl  0x8(%ebp)
  80021a:	e8 19 fe ff ff       	call   800038 <_main>
  80021f:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800222:	e8 5d 13 00 00       	call   801584 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 c4 1d 80 00       	push   $0x801dc4
  80022f:	e8 84 01 00 00       	call   8003b8 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800237:	a1 20 30 80 00       	mov    0x803020,%eax
  80023c:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800242:	a1 20 30 80 00       	mov    0x803020,%eax
  800247:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80024d:	83 ec 04             	sub    $0x4,%esp
  800250:	52                   	push   %edx
  800251:	50                   	push   %eax
  800252:	68 ec 1d 80 00       	push   $0x801dec
  800257:	e8 5c 01 00 00       	call   8003b8 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80026a:	a1 20 30 80 00       	mov    0x803020,%eax
  80026f:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	52                   	push   %edx
  800279:	50                   	push   %eax
  80027a:	68 14 1e 80 00       	push   $0x801e14
  80027f:	e8 34 01 00 00       	call   8003b8 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800287:	a1 20 30 80 00       	mov    0x803020,%eax
  80028c:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	50                   	push   %eax
  800296:	68 55 1e 80 00       	push   $0x801e55
  80029b:	e8 18 01 00 00       	call   8003b8 <cprintf>
  8002a0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a3:	83 ec 0c             	sub    $0xc,%esp
  8002a6:	68 c4 1d 80 00       	push   $0x801dc4
  8002ab:	e8 08 01 00 00       	call   8003b8 <cprintf>
  8002b0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b3:	e8 e6 12 00 00       	call   80159e <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002b8:	e8 19 00 00 00       	call   8002d6 <exit>
}
  8002bd:	90                   	nop
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8002c6:	83 ec 0c             	sub    $0xc,%esp
  8002c9:	6a 00                	push   $0x0
  8002cb:	e8 e5 10 00 00       	call   8013b5 <sys_env_destroy>
  8002d0:	83 c4 10             	add    $0x10,%esp
}
  8002d3:	90                   	nop
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <exit>:

void
exit(void)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002dc:	e8 3a 11 00 00       	call   80141b <sys_env_exit>
}
  8002e1:	90                   	nop
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	8d 48 01             	lea    0x1(%eax),%ecx
  8002f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f5:	89 0a                	mov    %ecx,(%edx)
  8002f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fa:	88 d1                	mov    %dl,%cl
  8002fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ff:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800303:	8b 45 0c             	mov    0xc(%ebp),%eax
  800306:	8b 00                	mov    (%eax),%eax
  800308:	3d ff 00 00 00       	cmp    $0xff,%eax
  80030d:	75 2c                	jne    80033b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80030f:	a0 24 30 80 00       	mov    0x803024,%al
  800314:	0f b6 c0             	movzbl %al,%eax
  800317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80031a:	8b 12                	mov    (%edx),%edx
  80031c:	89 d1                	mov    %edx,%ecx
  80031e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800321:	83 c2 08             	add    $0x8,%edx
  800324:	83 ec 04             	sub    $0x4,%esp
  800327:	50                   	push   %eax
  800328:	51                   	push   %ecx
  800329:	52                   	push   %edx
  80032a:	e8 44 10 00 00       	call   801373 <sys_cputs>
  80032f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800332:	8b 45 0c             	mov    0xc(%ebp),%eax
  800335:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80033b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033e:	8b 40 04             	mov    0x4(%eax),%eax
  800341:	8d 50 01             	lea    0x1(%eax),%edx
  800344:	8b 45 0c             	mov    0xc(%ebp),%eax
  800347:	89 50 04             	mov    %edx,0x4(%eax)
}
  80034a:	90                   	nop
  80034b:	c9                   	leave  
  80034c:	c3                   	ret    

0080034d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800356:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80035d:	00 00 00 
	b.cnt = 0;
  800360:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800367:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80036a:	ff 75 0c             	pushl  0xc(%ebp)
  80036d:	ff 75 08             	pushl  0x8(%ebp)
  800370:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800376:	50                   	push   %eax
  800377:	68 e4 02 80 00       	push   $0x8002e4
  80037c:	e8 11 02 00 00       	call   800592 <vprintfmt>
  800381:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800384:	a0 24 30 80 00       	mov    0x803024,%al
  800389:	0f b6 c0             	movzbl %al,%eax
  80038c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800392:	83 ec 04             	sub    $0x4,%esp
  800395:	50                   	push   %eax
  800396:	52                   	push   %edx
  800397:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80039d:	83 c0 08             	add    $0x8,%eax
  8003a0:	50                   	push   %eax
  8003a1:	e8 cd 0f 00 00       	call   801373 <sys_cputs>
  8003a6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003a9:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8003b0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003b6:	c9                   	leave  
  8003b7:	c3                   	ret    

008003b8 <cprintf>:

int cprintf(const char *fmt, ...) {
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003be:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8003c5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d4:	50                   	push   %eax
  8003d5:	e8 73 ff ff ff       	call   80034d <vcprintf>
  8003da:	83 c4 10             	add    $0x10,%esp
  8003dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003e3:	c9                   	leave  
  8003e4:	c3                   	ret    

008003e5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003eb:	e8 94 11 00 00       	call   801584 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003f0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	83 ec 08             	sub    $0x8,%esp
  8003fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ff:	50                   	push   %eax
  800400:	e8 48 ff ff ff       	call   80034d <vcprintf>
  800405:	83 c4 10             	add    $0x10,%esp
  800408:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80040b:	e8 8e 11 00 00       	call   80159e <sys_enable_interrupt>
	return cnt;
  800410:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800413:	c9                   	leave  
  800414:	c3                   	ret    

00800415 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800415:	55                   	push   %ebp
  800416:	89 e5                	mov    %esp,%ebp
  800418:	53                   	push   %ebx
  800419:	83 ec 14             	sub    $0x14,%esp
  80041c:	8b 45 10             	mov    0x10(%ebp),%eax
  80041f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800422:	8b 45 14             	mov    0x14(%ebp),%eax
  800425:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800428:	8b 45 18             	mov    0x18(%ebp),%eax
  80042b:	ba 00 00 00 00       	mov    $0x0,%edx
  800430:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800433:	77 55                	ja     80048a <printnum+0x75>
  800435:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800438:	72 05                	jb     80043f <printnum+0x2a>
  80043a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80043d:	77 4b                	ja     80048a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80043f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800442:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800445:	8b 45 18             	mov    0x18(%ebp),%eax
  800448:	ba 00 00 00 00       	mov    $0x0,%edx
  80044d:	52                   	push   %edx
  80044e:	50                   	push   %eax
  80044f:	ff 75 f4             	pushl  -0xc(%ebp)
  800452:	ff 75 f0             	pushl  -0x10(%ebp)
  800455:	e8 ea 15 00 00       	call   801a44 <__udivdi3>
  80045a:	83 c4 10             	add    $0x10,%esp
  80045d:	83 ec 04             	sub    $0x4,%esp
  800460:	ff 75 20             	pushl  0x20(%ebp)
  800463:	53                   	push   %ebx
  800464:	ff 75 18             	pushl  0x18(%ebp)
  800467:	52                   	push   %edx
  800468:	50                   	push   %eax
  800469:	ff 75 0c             	pushl  0xc(%ebp)
  80046c:	ff 75 08             	pushl  0x8(%ebp)
  80046f:	e8 a1 ff ff ff       	call   800415 <printnum>
  800474:	83 c4 20             	add    $0x20,%esp
  800477:	eb 1a                	jmp    800493 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800479:	83 ec 08             	sub    $0x8,%esp
  80047c:	ff 75 0c             	pushl  0xc(%ebp)
  80047f:	ff 75 20             	pushl  0x20(%ebp)
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	ff d0                	call   *%eax
  800487:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80048a:	ff 4d 1c             	decl   0x1c(%ebp)
  80048d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800491:	7f e6                	jg     800479 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800493:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800496:	bb 00 00 00 00       	mov    $0x0,%ebx
  80049b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80049e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004a1:	53                   	push   %ebx
  8004a2:	51                   	push   %ecx
  8004a3:	52                   	push   %edx
  8004a4:	50                   	push   %eax
  8004a5:	e8 aa 16 00 00       	call   801b54 <__umoddi3>
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	05 94 20 80 00       	add    $0x802094,%eax
  8004b2:	8a 00                	mov    (%eax),%al
  8004b4:	0f be c0             	movsbl %al,%eax
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	ff 75 0c             	pushl  0xc(%ebp)
  8004bd:	50                   	push   %eax
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	ff d0                	call   *%eax
  8004c3:	83 c4 10             	add    $0x10,%esp
}
  8004c6:	90                   	nop
  8004c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004ca:	c9                   	leave  
  8004cb:	c3                   	ret    

008004cc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004d3:	7e 1c                	jle    8004f1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	8d 50 08             	lea    0x8(%eax),%edx
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	89 10                	mov    %edx,(%eax)
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	83 e8 08             	sub    $0x8,%eax
  8004ea:	8b 50 04             	mov    0x4(%eax),%edx
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	eb 40                	jmp    800531 <getuint+0x65>
	else if (lflag)
  8004f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f5:	74 1e                	je     800515 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 50 04             	lea    0x4(%eax),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	89 10                	mov    %edx,(%eax)
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	83 e8 04             	sub    $0x4,%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	ba 00 00 00 00       	mov    $0x0,%edx
  800513:	eb 1c                	jmp    800531 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	8d 50 04             	lea    0x4(%eax),%edx
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	89 10                	mov    %edx,(%eax)
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	83 e8 04             	sub    $0x4,%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800531:	5d                   	pop    %ebp
  800532:	c3                   	ret    

00800533 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800536:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80053a:	7e 1c                	jle    800558 <getint+0x25>
		return va_arg(*ap, long long);
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	8d 50 08             	lea    0x8(%eax),%edx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	89 10                	mov    %edx,(%eax)
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	83 e8 08             	sub    $0x8,%eax
  800551:	8b 50 04             	mov    0x4(%eax),%edx
  800554:	8b 00                	mov    (%eax),%eax
  800556:	eb 38                	jmp    800590 <getint+0x5d>
	else if (lflag)
  800558:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80055c:	74 1a                	je     800578 <getint+0x45>
		return va_arg(*ap, long);
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	8d 50 04             	lea    0x4(%eax),%edx
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	89 10                	mov    %edx,(%eax)
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	83 e8 04             	sub    $0x4,%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	99                   	cltd   
  800576:	eb 18                	jmp    800590 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	8b 00                	mov    (%eax),%eax
  80057d:	8d 50 04             	lea    0x4(%eax),%edx
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	89 10                	mov    %edx,(%eax)
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	83 e8 04             	sub    $0x4,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	99                   	cltd   
}
  800590:	5d                   	pop    %ebp
  800591:	c3                   	ret    

00800592 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	56                   	push   %esi
  800596:	53                   	push   %ebx
  800597:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80059a:	eb 17                	jmp    8005b3 <vprintfmt+0x21>
			if (ch == '\0')
  80059c:	85 db                	test   %ebx,%ebx
  80059e:	0f 84 af 03 00 00    	je     800953 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8005a4:	83 ec 08             	sub    $0x8,%esp
  8005a7:	ff 75 0c             	pushl  0xc(%ebp)
  8005aa:	53                   	push   %ebx
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	ff d0                	call   *%eax
  8005b0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b6:	8d 50 01             	lea    0x1(%eax),%edx
  8005b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8005bc:	8a 00                	mov    (%eax),%al
  8005be:	0f b6 d8             	movzbl %al,%ebx
  8005c1:	83 fb 25             	cmp    $0x25,%ebx
  8005c4:	75 d6                	jne    80059c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005c6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005ca:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005d1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005df:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e9:	8d 50 01             	lea    0x1(%eax),%edx
  8005ec:	89 55 10             	mov    %edx,0x10(%ebp)
  8005ef:	8a 00                	mov    (%eax),%al
  8005f1:	0f b6 d8             	movzbl %al,%ebx
  8005f4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005f7:	83 f8 55             	cmp    $0x55,%eax
  8005fa:	0f 87 2b 03 00 00    	ja     80092b <vprintfmt+0x399>
  800600:	8b 04 85 b8 20 80 00 	mov    0x8020b8(,%eax,4),%eax
  800607:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800609:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80060d:	eb d7                	jmp    8005e6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80060f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800613:	eb d1                	jmp    8005e6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800615:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80061c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80061f:	89 d0                	mov    %edx,%eax
  800621:	c1 e0 02             	shl    $0x2,%eax
  800624:	01 d0                	add    %edx,%eax
  800626:	01 c0                	add    %eax,%eax
  800628:	01 d8                	add    %ebx,%eax
  80062a:	83 e8 30             	sub    $0x30,%eax
  80062d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800630:	8b 45 10             	mov    0x10(%ebp),%eax
  800633:	8a 00                	mov    (%eax),%al
  800635:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800638:	83 fb 2f             	cmp    $0x2f,%ebx
  80063b:	7e 3e                	jle    80067b <vprintfmt+0xe9>
  80063d:	83 fb 39             	cmp    $0x39,%ebx
  800640:	7f 39                	jg     80067b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800642:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800645:	eb d5                	jmp    80061c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	83 c0 04             	add    $0x4,%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	83 e8 04             	sub    $0x4,%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80065b:	eb 1f                	jmp    80067c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80065d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800661:	79 83                	jns    8005e6 <vprintfmt+0x54>
				width = 0;
  800663:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80066a:	e9 77 ff ff ff       	jmp    8005e6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80066f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800676:	e9 6b ff ff ff       	jmp    8005e6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80067b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80067c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800680:	0f 89 60 ff ff ff    	jns    8005e6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800686:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800689:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80068c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800693:	e9 4e ff ff ff       	jmp    8005e6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800698:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80069b:	e9 46 ff ff ff       	jmp    8005e6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	83 c0 04             	add    $0x4,%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	83 e8 04             	sub    $0x4,%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	ff 75 0c             	pushl  0xc(%ebp)
  8006b7:	50                   	push   %eax
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	ff d0                	call   *%eax
  8006bd:	83 c4 10             	add    $0x10,%esp
			break;
  8006c0:	e9 89 02 00 00       	jmp    80094e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	83 c0 04             	add    $0x4,%eax
  8006cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	83 e8 04             	sub    $0x4,%eax
  8006d4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006d6:	85 db                	test   %ebx,%ebx
  8006d8:	79 02                	jns    8006dc <vprintfmt+0x14a>
				err = -err;
  8006da:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006dc:	83 fb 64             	cmp    $0x64,%ebx
  8006df:	7f 0b                	jg     8006ec <vprintfmt+0x15a>
  8006e1:	8b 34 9d 00 1f 80 00 	mov    0x801f00(,%ebx,4),%esi
  8006e8:	85 f6                	test   %esi,%esi
  8006ea:	75 19                	jne    800705 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006ec:	53                   	push   %ebx
  8006ed:	68 a5 20 80 00       	push   $0x8020a5
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	ff 75 08             	pushl  0x8(%ebp)
  8006f8:	e8 5e 02 00 00       	call   80095b <printfmt>
  8006fd:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800700:	e9 49 02 00 00       	jmp    80094e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800705:	56                   	push   %esi
  800706:	68 ae 20 80 00       	push   $0x8020ae
  80070b:	ff 75 0c             	pushl  0xc(%ebp)
  80070e:	ff 75 08             	pushl  0x8(%ebp)
  800711:	e8 45 02 00 00       	call   80095b <printfmt>
  800716:	83 c4 10             	add    $0x10,%esp
			break;
  800719:	e9 30 02 00 00       	jmp    80094e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	83 c0 04             	add    $0x4,%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	83 e8 04             	sub    $0x4,%eax
  80072d:	8b 30                	mov    (%eax),%esi
  80072f:	85 f6                	test   %esi,%esi
  800731:	75 05                	jne    800738 <vprintfmt+0x1a6>
				p = "(null)";
  800733:	be b1 20 80 00       	mov    $0x8020b1,%esi
			if (width > 0 && padc != '-')
  800738:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073c:	7e 6d                	jle    8007ab <vprintfmt+0x219>
  80073e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800742:	74 67                	je     8007ab <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800744:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	50                   	push   %eax
  80074b:	56                   	push   %esi
  80074c:	e8 12 05 00 00       	call   800c63 <strnlen>
  800751:	83 c4 10             	add    $0x10,%esp
  800754:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800757:	eb 16                	jmp    80076f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800759:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	50                   	push   %eax
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80076c:	ff 4d e4             	decl   -0x1c(%ebp)
  80076f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800773:	7f e4                	jg     800759 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800775:	eb 34                	jmp    8007ab <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800777:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80077b:	74 1c                	je     800799 <vprintfmt+0x207>
  80077d:	83 fb 1f             	cmp    $0x1f,%ebx
  800780:	7e 05                	jle    800787 <vprintfmt+0x1f5>
  800782:	83 fb 7e             	cmp    $0x7e,%ebx
  800785:	7e 12                	jle    800799 <vprintfmt+0x207>
					putch('?', putdat);
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 0c             	pushl  0xc(%ebp)
  80078d:	6a 3f                	push   $0x3f
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	ff d0                	call   *%eax
  800794:	83 c4 10             	add    $0x10,%esp
  800797:	eb 0f                	jmp    8007a8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800799:	83 ec 08             	sub    $0x8,%esp
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	53                   	push   %ebx
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	ff d0                	call   *%eax
  8007a5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007a8:	ff 4d e4             	decl   -0x1c(%ebp)
  8007ab:	89 f0                	mov    %esi,%eax
  8007ad:	8d 70 01             	lea    0x1(%eax),%esi
  8007b0:	8a 00                	mov    (%eax),%al
  8007b2:	0f be d8             	movsbl %al,%ebx
  8007b5:	85 db                	test   %ebx,%ebx
  8007b7:	74 24                	je     8007dd <vprintfmt+0x24b>
  8007b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007bd:	78 b8                	js     800777 <vprintfmt+0x1e5>
  8007bf:	ff 4d e0             	decl   -0x20(%ebp)
  8007c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007c6:	79 af                	jns    800777 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007c8:	eb 13                	jmp    8007dd <vprintfmt+0x24b>
				putch(' ', putdat);
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	ff 75 0c             	pushl  0xc(%ebp)
  8007d0:	6a 20                	push   $0x20
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	ff d0                	call   *%eax
  8007d7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007da:	ff 4d e4             	decl   -0x1c(%ebp)
  8007dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e1:	7f e7                	jg     8007ca <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007e3:	e9 66 01 00 00       	jmp    80094e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ee:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f1:	50                   	push   %eax
  8007f2:	e8 3c fd ff ff       	call   800533 <getint>
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800803:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800806:	85 d2                	test   %edx,%edx
  800808:	79 23                	jns    80082d <vprintfmt+0x29b>
				putch('-', putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	6a 2d                	push   $0x2d
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	ff d0                	call   *%eax
  800817:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80081a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80081d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800820:	f7 d8                	neg    %eax
  800822:	83 d2 00             	adc    $0x0,%edx
  800825:	f7 da                	neg    %edx
  800827:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80082d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800834:	e9 bc 00 00 00       	jmp    8008f5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	ff 75 e8             	pushl  -0x18(%ebp)
  80083f:	8d 45 14             	lea    0x14(%ebp),%eax
  800842:	50                   	push   %eax
  800843:	e8 84 fc ff ff       	call   8004cc <getuint>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80084e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800851:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800858:	e9 98 00 00 00       	jmp    8008f5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	6a 58                	push   $0x58
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	ff d0                	call   *%eax
  80086a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	6a 58                	push   $0x58
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	ff 75 0c             	pushl  0xc(%ebp)
  800883:	6a 58                	push   $0x58
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			break;
  80088d:	e9 bc 00 00 00       	jmp    80094e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	ff 75 0c             	pushl  0xc(%ebp)
  800898:	6a 30                	push   $0x30
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	ff d0                	call   *%eax
  80089f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008a2:	83 ec 08             	sub    $0x8,%esp
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	6a 78                	push   $0x78
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	ff d0                	call   *%eax
  8008af:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	83 c0 04             	add    $0x4,%eax
  8008b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	83 e8 04             	sub    $0x4,%eax
  8008c1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008cd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008d4:	eb 1f                	jmp    8008f5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8008dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8008df:	50                   	push   %eax
  8008e0:	e8 e7 fb ff ff       	call   8004cc <getuint>
  8008e5:	83 c4 10             	add    $0x10,%esp
  8008e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008ee:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008f5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008fc:	83 ec 04             	sub    $0x4,%esp
  8008ff:	52                   	push   %edx
  800900:	ff 75 e4             	pushl  -0x1c(%ebp)
  800903:	50                   	push   %eax
  800904:	ff 75 f4             	pushl  -0xc(%ebp)
  800907:	ff 75 f0             	pushl  -0x10(%ebp)
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	e8 00 fb ff ff       	call   800415 <printnum>
  800915:	83 c4 20             	add    $0x20,%esp
			break;
  800918:	eb 34                	jmp    80094e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80091a:	83 ec 08             	sub    $0x8,%esp
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	53                   	push   %ebx
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	ff d0                	call   *%eax
  800926:	83 c4 10             	add    $0x10,%esp
			break;
  800929:	eb 23                	jmp    80094e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	6a 25                	push   $0x25
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	ff d0                	call   *%eax
  800938:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80093b:	ff 4d 10             	decl   0x10(%ebp)
  80093e:	eb 03                	jmp    800943 <vprintfmt+0x3b1>
  800940:	ff 4d 10             	decl   0x10(%ebp)
  800943:	8b 45 10             	mov    0x10(%ebp),%eax
  800946:	48                   	dec    %eax
  800947:	8a 00                	mov    (%eax),%al
  800949:	3c 25                	cmp    $0x25,%al
  80094b:	75 f3                	jne    800940 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80094d:	90                   	nop
		}
	}
  80094e:	e9 47 fc ff ff       	jmp    80059a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800953:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800954:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800957:	5b                   	pop    %ebx
  800958:	5e                   	pop    %esi
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800961:	8d 45 10             	lea    0x10(%ebp),%eax
  800964:	83 c0 04             	add    $0x4,%eax
  800967:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80096a:	8b 45 10             	mov    0x10(%ebp),%eax
  80096d:	ff 75 f4             	pushl  -0xc(%ebp)
  800970:	50                   	push   %eax
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	ff 75 08             	pushl  0x8(%ebp)
  800977:	e8 16 fc ff ff       	call   800592 <vprintfmt>
  80097c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80097f:	90                   	nop
  800980:	c9                   	leave  
  800981:	c3                   	ret    

00800982 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800985:	8b 45 0c             	mov    0xc(%ebp),%eax
  800988:	8b 40 08             	mov    0x8(%eax),%eax
  80098b:	8d 50 01             	lea    0x1(%eax),%edx
  80098e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800991:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800994:	8b 45 0c             	mov    0xc(%ebp),%eax
  800997:	8b 10                	mov    (%eax),%edx
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	8b 40 04             	mov    0x4(%eax),%eax
  80099f:	39 c2                	cmp    %eax,%edx
  8009a1:	73 12                	jae    8009b5 <sprintputch+0x33>
		*b->buf++ = ch;
  8009a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a6:	8b 00                	mov    (%eax),%eax
  8009a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	89 0a                	mov    %ecx,(%edx)
  8009b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b3:	88 10                	mov    %dl,(%eax)
}
  8009b5:	90                   	nop
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    

008009b8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	01 d0                	add    %edx,%eax
  8009cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009dd:	74 06                	je     8009e5 <vsnprintf+0x2d>
  8009df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009e3:	7f 07                	jg     8009ec <vsnprintf+0x34>
		return -E_INVAL;
  8009e5:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ea:	eb 20                	jmp    800a0c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ec:	ff 75 14             	pushl  0x14(%ebp)
  8009ef:	ff 75 10             	pushl  0x10(%ebp)
  8009f2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009f5:	50                   	push   %eax
  8009f6:	68 82 09 80 00       	push   $0x800982
  8009fb:	e8 92 fb ff ff       	call   800592 <vprintfmt>
  800a00:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a06:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a0c:	c9                   	leave  
  800a0d:	c3                   	ret    

00800a0e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a14:	8d 45 10             	lea    0x10(%ebp),%eax
  800a17:	83 c0 04             	add    $0x4,%eax
  800a1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a20:	ff 75 f4             	pushl  -0xc(%ebp)
  800a23:	50                   	push   %eax
  800a24:	ff 75 0c             	pushl  0xc(%ebp)
  800a27:	ff 75 08             	pushl  0x8(%ebp)
  800a2a:	e8 89 ff ff ff       	call   8009b8 <vsnprintf>
  800a2f:	83 c4 10             	add    $0x10,%esp
  800a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800a40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a44:	74 13                	je     800a59 <readline+0x1f>
		cprintf("%s", prompt);
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	ff 75 08             	pushl  0x8(%ebp)
  800a4c:	68 10 22 80 00       	push   $0x802210
  800a51:	e8 62 f9 ff ff       	call   8003b8 <cprintf>
  800a56:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a60:	83 ec 0c             	sub    $0xc,%esp
  800a63:	6a 00                	push   $0x0
  800a65:	e8 d0 0f 00 00       	call   801a3a <iscons>
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a70:	e8 77 0f 00 00       	call   8019ec <getchar>
  800a75:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a78:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a7c:	79 22                	jns    800aa0 <readline+0x66>
			if (c != -E_EOF)
  800a7e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800a82:	0f 84 ad 00 00 00    	je     800b35 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 ec             	pushl  -0x14(%ebp)
  800a8e:	68 13 22 80 00       	push   $0x802213
  800a93:	e8 20 f9 ff ff       	call   8003b8 <cprintf>
  800a98:	83 c4 10             	add    $0x10,%esp
			return;
  800a9b:	e9 95 00 00 00       	jmp    800b35 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800aa0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800aa4:	7e 34                	jle    800ada <readline+0xa0>
  800aa6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800aad:	7f 2b                	jg     800ada <readline+0xa0>
			if (echoing)
  800aaf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ab3:	74 0e                	je     800ac3 <readline+0x89>
				cputchar(c);
  800ab5:	83 ec 0c             	sub    $0xc,%esp
  800ab8:	ff 75 ec             	pushl  -0x14(%ebp)
  800abb:	e8 e4 0e 00 00       	call   8019a4 <cputchar>
  800ac0:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac6:	8d 50 01             	lea    0x1(%eax),%edx
  800ac9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800acc:	89 c2                	mov    %eax,%edx
  800ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad1:	01 d0                	add    %edx,%eax
  800ad3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ad6:	88 10                	mov    %dl,(%eax)
  800ad8:	eb 56                	jmp    800b30 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ada:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ade:	75 1f                	jne    800aff <readline+0xc5>
  800ae0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ae4:	7e 19                	jle    800aff <readline+0xc5>
			if (echoing)
  800ae6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800aea:	74 0e                	je     800afa <readline+0xc0>
				cputchar(c);
  800aec:	83 ec 0c             	sub    $0xc,%esp
  800aef:	ff 75 ec             	pushl  -0x14(%ebp)
  800af2:	e8 ad 0e 00 00       	call   8019a4 <cputchar>
  800af7:	83 c4 10             	add    $0x10,%esp

			i--;
  800afa:	ff 4d f4             	decl   -0xc(%ebp)
  800afd:	eb 31                	jmp    800b30 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800aff:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b03:	74 0a                	je     800b0f <readline+0xd5>
  800b05:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b09:	0f 85 61 ff ff ff    	jne    800a70 <readline+0x36>
			if (echoing)
  800b0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b13:	74 0e                	je     800b23 <readline+0xe9>
				cputchar(c);
  800b15:	83 ec 0c             	sub    $0xc,%esp
  800b18:	ff 75 ec             	pushl  -0x14(%ebp)
  800b1b:	e8 84 0e 00 00       	call   8019a4 <cputchar>
  800b20:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b29:	01 d0                	add    %edx,%eax
  800b2b:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800b2e:	eb 06                	jmp    800b36 <readline+0xfc>
		}
	}
  800b30:	e9 3b ff ff ff       	jmp    800a70 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800b35:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800b36:	c9                   	leave  
  800b37:	c3                   	ret    

00800b38 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b3e:	e8 41 0a 00 00       	call   801584 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800b43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b47:	74 13                	je     800b5c <atomic_readline+0x24>
		cprintf("%s", prompt);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 08             	pushl  0x8(%ebp)
  800b4f:	68 10 22 80 00       	push   $0x802210
  800b54:	e8 5f f8 ff ff       	call   8003b8 <cprintf>
  800b59:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800b5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800b63:	83 ec 0c             	sub    $0xc,%esp
  800b66:	6a 00                	push   $0x0
  800b68:	e8 cd 0e 00 00       	call   801a3a <iscons>
  800b6d:	83 c4 10             	add    $0x10,%esp
  800b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800b73:	e8 74 0e 00 00       	call   8019ec <getchar>
  800b78:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800b7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b7f:	79 23                	jns    800ba4 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800b81:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b85:	74 13                	je     800b9a <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 ec             	pushl  -0x14(%ebp)
  800b8d:	68 13 22 80 00       	push   $0x802213
  800b92:	e8 21 f8 ff ff       	call   8003b8 <cprintf>
  800b97:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800b9a:	e8 ff 09 00 00       	call   80159e <sys_enable_interrupt>
			return;
  800b9f:	e9 9a 00 00 00       	jmp    800c3e <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ba4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ba8:	7e 34                	jle    800bde <atomic_readline+0xa6>
  800baa:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800bb1:	7f 2b                	jg     800bde <atomic_readline+0xa6>
			if (echoing)
  800bb3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bb7:	74 0e                	je     800bc7 <atomic_readline+0x8f>
				cputchar(c);
  800bb9:	83 ec 0c             	sub    $0xc,%esp
  800bbc:	ff 75 ec             	pushl  -0x14(%ebp)
  800bbf:	e8 e0 0d 00 00       	call   8019a4 <cputchar>
  800bc4:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bca:	8d 50 01             	lea    0x1(%eax),%edx
  800bcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bd0:	89 c2                	mov    %eax,%edx
  800bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd5:	01 d0                	add    %edx,%eax
  800bd7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bda:	88 10                	mov    %dl,(%eax)
  800bdc:	eb 5b                	jmp    800c39 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800bde:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800be2:	75 1f                	jne    800c03 <atomic_readline+0xcb>
  800be4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800be8:	7e 19                	jle    800c03 <atomic_readline+0xcb>
			if (echoing)
  800bea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bee:	74 0e                	je     800bfe <atomic_readline+0xc6>
				cputchar(c);
  800bf0:	83 ec 0c             	sub    $0xc,%esp
  800bf3:	ff 75 ec             	pushl  -0x14(%ebp)
  800bf6:	e8 a9 0d 00 00       	call   8019a4 <cputchar>
  800bfb:	83 c4 10             	add    $0x10,%esp
			i--;
  800bfe:	ff 4d f4             	decl   -0xc(%ebp)
  800c01:	eb 36                	jmp    800c39 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800c03:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800c07:	74 0a                	je     800c13 <atomic_readline+0xdb>
  800c09:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800c0d:	0f 85 60 ff ff ff    	jne    800b73 <atomic_readline+0x3b>
			if (echoing)
  800c13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c17:	74 0e                	je     800c27 <atomic_readline+0xef>
				cputchar(c);
  800c19:	83 ec 0c             	sub    $0xc,%esp
  800c1c:	ff 75 ec             	pushl  -0x14(%ebp)
  800c1f:	e8 80 0d 00 00       	call   8019a4 <cputchar>
  800c24:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800c27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	01 d0                	add    %edx,%eax
  800c2f:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800c32:	e8 67 09 00 00       	call   80159e <sys_enable_interrupt>
			return;
  800c37:	eb 05                	jmp    800c3e <atomic_readline+0x106>
		}
	}
  800c39:	e9 35 ff ff ff       	jmp    800b73 <atomic_readline+0x3b>
}
  800c3e:	c9                   	leave  
  800c3f:	c3                   	ret    

00800c40 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4d:	eb 06                	jmp    800c55 <strlen+0x15>
		n++;
  800c4f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c52:	ff 45 08             	incl   0x8(%ebp)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8a 00                	mov    (%eax),%al
  800c5a:	84 c0                	test   %al,%al
  800c5c:	75 f1                	jne    800c4f <strlen+0xf>
		n++;
	return n;
  800c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c70:	eb 09                	jmp    800c7b <strnlen+0x18>
		n++;
  800c72:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c75:	ff 45 08             	incl   0x8(%ebp)
  800c78:	ff 4d 0c             	decl   0xc(%ebp)
  800c7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7f:	74 09                	je     800c8a <strnlen+0x27>
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	8a 00                	mov    (%eax),%al
  800c86:	84 c0                	test   %al,%al
  800c88:	75 e8                	jne    800c72 <strnlen+0xf>
		n++;
	return n;
  800c8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c9b:	90                   	nop
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8d 50 01             	lea    0x1(%eax),%edx
  800ca2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cae:	8a 12                	mov    (%edx),%dl
  800cb0:	88 10                	mov    %dl,(%eax)
  800cb2:	8a 00                	mov    (%eax),%al
  800cb4:	84 c0                	test   %al,%al
  800cb6:	75 e4                	jne    800c9c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cbb:	c9                   	leave  
  800cbc:	c3                   	ret    

00800cbd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd0:	eb 1f                	jmp    800cf1 <strncpy+0x34>
		*dst++ = *src;
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8d 50 01             	lea    0x1(%eax),%edx
  800cd8:	89 55 08             	mov    %edx,0x8(%ebp)
  800cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cde:	8a 12                	mov    (%edx),%dl
  800ce0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	84 c0                	test   %al,%al
  800ce9:	74 03                	je     800cee <strncpy+0x31>
			src++;
  800ceb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cee:	ff 45 fc             	incl   -0x4(%ebp)
  800cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cf7:	72 d9                	jb     800cd2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cf9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 30                	je     800d40 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d10:	eb 16                	jmp    800d28 <strlcpy+0x2a>
			*dst++ = *src++;
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8d 50 01             	lea    0x1(%eax),%edx
  800d18:	89 55 08             	mov    %edx,0x8(%ebp)
  800d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d21:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d24:	8a 12                	mov    (%edx),%dl
  800d26:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d28:	ff 4d 10             	decl   0x10(%ebp)
  800d2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2f:	74 09                	je     800d3a <strlcpy+0x3c>
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	84 c0                	test   %al,%al
  800d38:	75 d8                	jne    800d12 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d40:	8b 55 08             	mov    0x8(%ebp),%edx
  800d43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d46:	29 c2                	sub    %eax,%edx
  800d48:	89 d0                	mov    %edx,%eax
}
  800d4a:	c9                   	leave  
  800d4b:	c3                   	ret    

00800d4c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d4f:	eb 06                	jmp    800d57 <strcmp+0xb>
		p++, q++;
  800d51:	ff 45 08             	incl   0x8(%ebp)
  800d54:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	84 c0                	test   %al,%al
  800d5e:	74 0e                	je     800d6e <strcmp+0x22>
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8a 10                	mov    (%eax),%dl
  800d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	38 c2                	cmp    %al,%dl
  800d6c:	74 e3                	je     800d51 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	0f b6 d0             	movzbl %al,%edx
  800d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	0f b6 c0             	movzbl %al,%eax
  800d7e:	29 c2                	sub    %eax,%edx
  800d80:	89 d0                	mov    %edx,%eax
}
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d87:	eb 09                	jmp    800d92 <strncmp+0xe>
		n--, p++, q++;
  800d89:	ff 4d 10             	decl   0x10(%ebp)
  800d8c:	ff 45 08             	incl   0x8(%ebp)
  800d8f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d96:	74 17                	je     800daf <strncmp+0x2b>
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8a 00                	mov    (%eax),%al
  800d9d:	84 c0                	test   %al,%al
  800d9f:	74 0e                	je     800daf <strncmp+0x2b>
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	8a 10                	mov    (%eax),%dl
  800da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	38 c2                	cmp    %al,%dl
  800dad:	74 da                	je     800d89 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800daf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db3:	75 07                	jne    800dbc <strncmp+0x38>
		return 0;
  800db5:	b8 00 00 00 00       	mov    $0x0,%eax
  800dba:	eb 14                	jmp    800dd0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	0f b6 d0             	movzbl %al,%edx
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	0f b6 c0             	movzbl %al,%eax
  800dcc:	29 c2                	sub    %eax,%edx
  800dce:	89 d0                	mov    %edx,%eax
}
  800dd0:	5d                   	pop    %ebp
  800dd1:	c3                   	ret    

00800dd2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	83 ec 04             	sub    $0x4,%esp
  800dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dde:	eb 12                	jmp    800df2 <strchr+0x20>
		if (*s == c)
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800de8:	75 05                	jne    800def <strchr+0x1d>
			return (char *) s;
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	eb 11                	jmp    800e00 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800def:	ff 45 08             	incl   0x8(%ebp)
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	84 c0                	test   %al,%al
  800df9:	75 e5                	jne    800de0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e00:	c9                   	leave  
  800e01:	c3                   	ret    

00800e02 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	83 ec 04             	sub    $0x4,%esp
  800e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e0e:	eb 0d                	jmp    800e1d <strfind+0x1b>
		if (*s == c)
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e18:	74 0e                	je     800e28 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	84 c0                	test   %al,%al
  800e24:	75 ea                	jne    800e10 <strfind+0xe>
  800e26:	eb 01                	jmp    800e29 <strfind+0x27>
		if (*s == c)
			break;
  800e28:	90                   	nop
	return (char *) s;
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2c:	c9                   	leave  
  800e2d:	c3                   	ret    

00800e2e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e40:	eb 0e                	jmp    800e50 <memset+0x22>
		*p++ = c;
  800e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e45:	8d 50 01             	lea    0x1(%eax),%edx
  800e48:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e50:	ff 4d f8             	decl   -0x8(%ebp)
  800e53:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e57:	79 e9                	jns    800e42 <memset+0x14>
		*p++ = c;

	return v;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e70:	eb 16                	jmp    800e88 <memcpy+0x2a>
		*d++ = *s++;
  800e72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e75:	8d 50 01             	lea    0x1(%eax),%edx
  800e78:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e81:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e84:	8a 12                	mov    (%edx),%dl
  800e86:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e88:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e91:	85 c0                	test   %eax,%eax
  800e93:	75 dd                	jne    800e72 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e98:	c9                   	leave  
  800e99:	c3                   	ret    

00800e9a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800eac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eaf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eb2:	73 50                	jae    800f04 <memmove+0x6a>
  800eb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	01 d0                	add    %edx,%eax
  800ebc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ebf:	76 43                	jbe    800f04 <memmove+0x6a>
		s += n;
  800ec1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eca:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ecd:	eb 10                	jmp    800edf <memmove+0x45>
			*--d = *--s;
  800ecf:	ff 4d f8             	decl   -0x8(%ebp)
  800ed2:	ff 4d fc             	decl   -0x4(%ebp)
  800ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed8:	8a 10                	mov    (%eax),%dl
  800eda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800edd:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800edf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee5:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	75 e3                	jne    800ecf <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eec:	eb 23                	jmp    800f11 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef1:	8d 50 01             	lea    0x1(%eax),%edx
  800ef4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ef7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800efa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800efd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f00:	8a 12                	mov    (%edx),%dl
  800f02:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f04:	8b 45 10             	mov    0x10(%ebp),%eax
  800f07:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f0d:	85 c0                	test   %eax,%eax
  800f0f:	75 dd                	jne    800eee <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f14:	c9                   	leave  
  800f15:	c3                   	ret    

00800f16 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f25:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f28:	eb 2a                	jmp    800f54 <memcmp+0x3e>
		if (*s1 != *s2)
  800f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2d:	8a 10                	mov    (%eax),%dl
  800f2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	38 c2                	cmp    %al,%dl
  800f36:	74 16                	je     800f4e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	0f b6 d0             	movzbl %al,%edx
  800f40:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	0f b6 c0             	movzbl %al,%eax
  800f48:	29 c2                	sub    %eax,%edx
  800f4a:	89 d0                	mov    %edx,%eax
  800f4c:	eb 18                	jmp    800f66 <memcmp+0x50>
		s1++, s2++;
  800f4e:	ff 45 fc             	incl   -0x4(%ebp)
  800f51:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f54:	8b 45 10             	mov    0x10(%ebp),%eax
  800f57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	75 c9                	jne    800f2a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	8b 45 10             	mov    0x10(%ebp),%eax
  800f74:	01 d0                	add    %edx,%eax
  800f76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f79:	eb 15                	jmp    800f90 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	0f b6 d0             	movzbl %al,%edx
  800f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f86:	0f b6 c0             	movzbl %al,%eax
  800f89:	39 c2                	cmp    %eax,%edx
  800f8b:	74 0d                	je     800f9a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f8d:	ff 45 08             	incl   0x8(%ebp)
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f96:	72 e3                	jb     800f7b <memfind+0x13>
  800f98:	eb 01                	jmp    800f9b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f9a:	90                   	nop
	return (void *) s;
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9e:	c9                   	leave  
  800f9f:	c3                   	ret    

00800fa0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fa6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fb4:	eb 03                	jmp    800fb9 <strtol+0x19>
		s++;
  800fb6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	3c 20                	cmp    $0x20,%al
  800fc0:	74 f4                	je     800fb6 <strtol+0x16>
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	3c 09                	cmp    $0x9,%al
  800fc9:	74 eb                	je     800fb6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	3c 2b                	cmp    $0x2b,%al
  800fd2:	75 05                	jne    800fd9 <strtol+0x39>
		s++;
  800fd4:	ff 45 08             	incl   0x8(%ebp)
  800fd7:	eb 13                	jmp    800fec <strtol+0x4c>
	else if (*s == '-')
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	3c 2d                	cmp    $0x2d,%al
  800fe0:	75 0a                	jne    800fec <strtol+0x4c>
		s++, neg = 1;
  800fe2:	ff 45 08             	incl   0x8(%ebp)
  800fe5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff0:	74 06                	je     800ff8 <strtol+0x58>
  800ff2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ff6:	75 20                	jne    801018 <strtol+0x78>
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3c 30                	cmp    $0x30,%al
  800fff:	75 17                	jne    801018 <strtol+0x78>
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	40                   	inc    %eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 78                	cmp    $0x78,%al
  801009:	75 0d                	jne    801018 <strtol+0x78>
		s += 2, base = 16;
  80100b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80100f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801016:	eb 28                	jmp    801040 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801018:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101c:	75 15                	jne    801033 <strtol+0x93>
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 30                	cmp    $0x30,%al
  801025:	75 0c                	jne    801033 <strtol+0x93>
		s++, base = 8;
  801027:	ff 45 08             	incl   0x8(%ebp)
  80102a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801031:	eb 0d                	jmp    801040 <strtol+0xa0>
	else if (base == 0)
  801033:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801037:	75 07                	jne    801040 <strtol+0xa0>
		base = 10;
  801039:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	3c 2f                	cmp    $0x2f,%al
  801047:	7e 19                	jle    801062 <strtol+0xc2>
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	3c 39                	cmp    $0x39,%al
  801050:	7f 10                	jg     801062 <strtol+0xc2>
			dig = *s - '0';
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	8a 00                	mov    (%eax),%al
  801057:	0f be c0             	movsbl %al,%eax
  80105a:	83 e8 30             	sub    $0x30,%eax
  80105d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801060:	eb 42                	jmp    8010a4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	3c 60                	cmp    $0x60,%al
  801069:	7e 19                	jle    801084 <strtol+0xe4>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 7a                	cmp    $0x7a,%al
  801072:	7f 10                	jg     801084 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	0f be c0             	movsbl %al,%eax
  80107c:	83 e8 57             	sub    $0x57,%eax
  80107f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801082:	eb 20                	jmp    8010a4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	3c 40                	cmp    $0x40,%al
  80108b:	7e 39                	jle    8010c6 <strtol+0x126>
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	3c 5a                	cmp    $0x5a,%al
  801094:	7f 30                	jg     8010c6 <strtol+0x126>
			dig = *s - 'A' + 10;
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	0f be c0             	movsbl %al,%eax
  80109e:	83 e8 37             	sub    $0x37,%eax
  8010a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010aa:	7d 19                	jge    8010c5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010ac:	ff 45 08             	incl   0x8(%ebp)
  8010af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010b6:	89 c2                	mov    %eax,%edx
  8010b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010bb:	01 d0                	add    %edx,%eax
  8010bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010c0:	e9 7b ff ff ff       	jmp    801040 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010c5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ca:	74 08                	je     8010d4 <strtol+0x134>
		*endptr = (char *) s;
  8010cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010d8:	74 07                	je     8010e1 <strtol+0x141>
  8010da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dd:	f7 d8                	neg    %eax
  8010df:	eb 03                	jmp    8010e4 <strtol+0x144>
  8010e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    

008010e6 <ltostr>:

void
ltostr(long value, char *str)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010fe:	79 13                	jns    801113 <ltostr+0x2d>
	{
		neg = 1;
  801100:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80110d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801110:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80111b:	99                   	cltd   
  80111c:	f7 f9                	idiv   %ecx
  80111e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801121:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80112a:	89 c2                	mov    %eax,%edx
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801134:	83 c2 30             	add    $0x30,%edx
  801137:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801139:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80113c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801141:	f7 e9                	imul   %ecx
  801143:	c1 fa 02             	sar    $0x2,%edx
  801146:	89 c8                	mov    %ecx,%eax
  801148:	c1 f8 1f             	sar    $0x1f,%eax
  80114b:	29 c2                	sub    %eax,%edx
  80114d:	89 d0                	mov    %edx,%eax
  80114f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801152:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801155:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80115a:	f7 e9                	imul   %ecx
  80115c:	c1 fa 02             	sar    $0x2,%edx
  80115f:	89 c8                	mov    %ecx,%eax
  801161:	c1 f8 1f             	sar    $0x1f,%eax
  801164:	29 c2                	sub    %eax,%edx
  801166:	89 d0                	mov    %edx,%eax
  801168:	c1 e0 02             	shl    $0x2,%eax
  80116b:	01 d0                	add    %edx,%eax
  80116d:	01 c0                	add    %eax,%eax
  80116f:	29 c1                	sub    %eax,%ecx
  801171:	89 ca                	mov    %ecx,%edx
  801173:	85 d2                	test   %edx,%edx
  801175:	75 9c                	jne    801113 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801177:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80117e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801181:	48                   	dec    %eax
  801182:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801185:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801189:	74 3d                	je     8011c8 <ltostr+0xe2>
		start = 1 ;
  80118b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801192:	eb 34                	jmp    8011c8 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801194:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 d0                	add    %edx,%eax
  80119c:	8a 00                	mov    (%eax),%al
  80119e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	01 c2                	add    %eax,%edx
  8011a9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011af:	01 c8                	add    %ecx,%eax
  8011b1:	8a 00                	mov    (%eax),%al
  8011b3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bb:	01 c2                	add    %eax,%edx
  8011bd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011c0:	88 02                	mov    %al,(%edx)
		start++ ;
  8011c2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011c5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ce:	7c c4                	jl     801194 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d6:	01 d0                	add    %edx,%eax
  8011d8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011db:	90                   	nop
  8011dc:	c9                   	leave  
  8011dd:	c3                   	ret    

008011de <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011e4:	ff 75 08             	pushl  0x8(%ebp)
  8011e7:	e8 54 fa ff ff       	call   800c40 <strlen>
  8011ec:	83 c4 04             	add    $0x4,%esp
  8011ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011f2:	ff 75 0c             	pushl  0xc(%ebp)
  8011f5:	e8 46 fa ff ff       	call   800c40 <strlen>
  8011fa:	83 c4 04             	add    $0x4,%esp
  8011fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801200:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801207:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80120e:	eb 17                	jmp    801227 <strcconcat+0x49>
		final[s] = str1[s] ;
  801210:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801213:	8b 45 10             	mov    0x10(%ebp),%eax
  801216:	01 c2                	add    %eax,%edx
  801218:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	01 c8                	add    %ecx,%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801224:	ff 45 fc             	incl   -0x4(%ebp)
  801227:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80122d:	7c e1                	jl     801210 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80122f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801236:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80123d:	eb 1f                	jmp    80125e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80123f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801242:	8d 50 01             	lea    0x1(%eax),%edx
  801245:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801248:	89 c2                	mov    %eax,%edx
  80124a:	8b 45 10             	mov    0x10(%ebp),%eax
  80124d:	01 c2                	add    %eax,%edx
  80124f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801252:	8b 45 0c             	mov    0xc(%ebp),%eax
  801255:	01 c8                	add    %ecx,%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80125b:	ff 45 f8             	incl   -0x8(%ebp)
  80125e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801261:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801264:	7c d9                	jl     80123f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801266:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801269:	8b 45 10             	mov    0x10(%ebp),%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	c6 00 00             	movb   $0x0,(%eax)
}
  801271:	90                   	nop
  801272:	c9                   	leave  
  801273:	c3                   	ret    

00801274 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801280:	8b 45 14             	mov    0x14(%ebp),%eax
  801283:	8b 00                	mov    (%eax),%eax
  801285:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	01 d0                	add    %edx,%eax
  801291:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801297:	eb 0c                	jmp    8012a5 <strsplit+0x31>
			*string++ = 0;
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8d 50 01             	lea    0x1(%eax),%edx
  80129f:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	84 c0                	test   %al,%al
  8012ac:	74 18                	je     8012c6 <strsplit+0x52>
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	0f be c0             	movsbl %al,%eax
  8012b6:	50                   	push   %eax
  8012b7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ba:	e8 13 fb ff ff       	call   800dd2 <strchr>
  8012bf:	83 c4 08             	add    $0x8,%esp
  8012c2:	85 c0                	test   %eax,%eax
  8012c4:	75 d3                	jne    801299 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	84 c0                	test   %al,%al
  8012cd:	74 5a                	je     801329 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d2:	8b 00                	mov    (%eax),%eax
  8012d4:	83 f8 0f             	cmp    $0xf,%eax
  8012d7:	75 07                	jne    8012e0 <strsplit+0x6c>
		{
			return 0;
  8012d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012de:	eb 66                	jmp    801346 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	8d 48 01             	lea    0x1(%eax),%ecx
  8012e8:	8b 55 14             	mov    0x14(%ebp),%edx
  8012eb:	89 0a                	mov    %ecx,(%edx)
  8012ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f7:	01 c2                	add    %eax,%edx
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012fe:	eb 03                	jmp    801303 <strsplit+0x8f>
			string++;
  801300:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	8a 00                	mov    (%eax),%al
  801308:	84 c0                	test   %al,%al
  80130a:	74 8b                	je     801297 <strsplit+0x23>
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	8a 00                	mov    (%eax),%al
  801311:	0f be c0             	movsbl %al,%eax
  801314:	50                   	push   %eax
  801315:	ff 75 0c             	pushl  0xc(%ebp)
  801318:	e8 b5 fa ff ff       	call   800dd2 <strchr>
  80131d:	83 c4 08             	add    $0x8,%esp
  801320:	85 c0                	test   %eax,%eax
  801322:	74 dc                	je     801300 <strsplit+0x8c>
			string++;
	}
  801324:	e9 6e ff ff ff       	jmp    801297 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801329:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80132a:	8b 45 14             	mov    0x14(%ebp),%eax
  80132d:	8b 00                	mov    (%eax),%eax
  80132f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801336:	8b 45 10             	mov    0x10(%ebp),%eax
  801339:	01 d0                	add    %edx,%eax
  80133b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801341:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	57                   	push   %edi
  80134c:	56                   	push   %esi
  80134d:	53                   	push   %ebx
  80134e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	8b 55 0c             	mov    0xc(%ebp),%edx
  801357:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80135a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80135d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801360:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801363:	cd 30                	int    $0x30
  801365:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801368:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80136b:	83 c4 10             	add    $0x10,%esp
  80136e:	5b                   	pop    %ebx
  80136f:	5e                   	pop    %esi
  801370:	5f                   	pop    %edi
  801371:	5d                   	pop    %ebp
  801372:	c3                   	ret    

00801373 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 04             	sub    $0x4,%esp
  801379:	8b 45 10             	mov    0x10(%ebp),%eax
  80137c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80137f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	52                   	push   %edx
  80138b:	ff 75 0c             	pushl  0xc(%ebp)
  80138e:	50                   	push   %eax
  80138f:	6a 00                	push   $0x0
  801391:	e8 b2 ff ff ff       	call   801348 <syscall>
  801396:	83 c4 18             	add    $0x18,%esp
}
  801399:	90                   	nop
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <sys_cgetc>:

int
sys_cgetc(void)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 01                	push   $0x1
  8013ab:	e8 98 ff ff ff       	call   801348 <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	50                   	push   %eax
  8013c4:	6a 05                	push   $0x5
  8013c6:	e8 7d ff ff ff       	call   801348 <syscall>
  8013cb:	83 c4 18             	add    $0x18,%esp
}
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 02                	push   $0x2
  8013df:	e8 64 ff ff ff       	call   801348 <syscall>
  8013e4:	83 c4 18             	add    $0x18,%esp
}
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 03                	push   $0x3
  8013f8:	e8 4b ff ff ff       	call   801348 <syscall>
  8013fd:	83 c4 18             	add    $0x18,%esp
}
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 04                	push   $0x4
  801411:	e8 32 ff ff ff       	call   801348 <syscall>
  801416:	83 c4 18             	add    $0x18,%esp
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <sys_env_exit>:


void sys_env_exit(void)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 06                	push   $0x6
  80142a:	e8 19 ff ff ff       	call   801348 <syscall>
  80142f:	83 c4 18             	add    $0x18,%esp
}
  801432:	90                   	nop
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	52                   	push   %edx
  801445:	50                   	push   %eax
  801446:	6a 07                	push   $0x7
  801448:	e8 fb fe ff ff       	call   801348 <syscall>
  80144d:	83 c4 18             	add    $0x18,%esp
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	56                   	push   %esi
  801456:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801457:	8b 75 18             	mov    0x18(%ebp),%esi
  80145a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80145d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801460:	8b 55 0c             	mov    0xc(%ebp),%edx
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	56                   	push   %esi
  801467:	53                   	push   %ebx
  801468:	51                   	push   %ecx
  801469:	52                   	push   %edx
  80146a:	50                   	push   %eax
  80146b:	6a 08                	push   $0x8
  80146d:	e8 d6 fe ff ff       	call   801348 <syscall>
  801472:	83 c4 18             	add    $0x18,%esp
}
  801475:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801478:	5b                   	pop    %ebx
  801479:	5e                   	pop    %esi
  80147a:	5d                   	pop    %ebp
  80147b:	c3                   	ret    

0080147c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80147f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	52                   	push   %edx
  80148c:	50                   	push   %eax
  80148d:	6a 09                	push   $0x9
  80148f:	e8 b4 fe ff ff       	call   801348 <syscall>
  801494:	83 c4 18             	add    $0x18,%esp
}
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	ff 75 0c             	pushl  0xc(%ebp)
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	6a 0a                	push   $0xa
  8014aa:	e8 99 fe ff ff       	call   801348 <syscall>
  8014af:	83 c4 18             	add    $0x18,%esp
}
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 0b                	push   $0xb
  8014c3:	e8 80 fe ff ff       	call   801348 <syscall>
  8014c8:	83 c4 18             	add    $0x18,%esp
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 0c                	push   $0xc
  8014dc:	e8 67 fe ff ff       	call   801348 <syscall>
  8014e1:	83 c4 18             	add    $0x18,%esp
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 0d                	push   $0xd
  8014f5:	e8 4e fe ff ff       	call   801348 <syscall>
  8014fa:	83 c4 18             	add    $0x18,%esp
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	ff 75 0c             	pushl  0xc(%ebp)
  80150b:	ff 75 08             	pushl  0x8(%ebp)
  80150e:	6a 11                	push   $0x11
  801510:	e8 33 fe ff ff       	call   801348 <syscall>
  801515:	83 c4 18             	add    $0x18,%esp
	return;
  801518:	90                   	nop
}
  801519:	c9                   	leave  
  80151a:	c3                   	ret    

0080151b <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	ff 75 0c             	pushl  0xc(%ebp)
  801527:	ff 75 08             	pushl  0x8(%ebp)
  80152a:	6a 12                	push   $0x12
  80152c:	e8 17 fe ff ff       	call   801348 <syscall>
  801531:	83 c4 18             	add    $0x18,%esp
	return ;
  801534:	90                   	nop
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 0e                	push   $0xe
  801546:	e8 fd fd ff ff       	call   801348 <syscall>
  80154b:	83 c4 18             	add    $0x18,%esp
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	ff 75 08             	pushl  0x8(%ebp)
  80155e:	6a 0f                	push   $0xf
  801560:	e8 e3 fd ff ff       	call   801348 <syscall>
  801565:	83 c4 18             	add    $0x18,%esp
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 10                	push   $0x10
  801579:	e8 ca fd ff ff       	call   801348 <syscall>
  80157e:	83 c4 18             	add    $0x18,%esp
}
  801581:	90                   	nop
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 14                	push   $0x14
  801593:	e8 b0 fd ff ff       	call   801348 <syscall>
  801598:	83 c4 18             	add    $0x18,%esp
}
  80159b:	90                   	nop
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 15                	push   $0x15
  8015ad:	e8 96 fd ff ff       	call   801348 <syscall>
  8015b2:	83 c4 18             	add    $0x18,%esp
}
  8015b5:	90                   	nop
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <sys_cputc>:


void
sys_cputc(const char c)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 04             	sub    $0x4,%esp
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015c4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	50                   	push   %eax
  8015d1:	6a 16                	push   $0x16
  8015d3:	e8 70 fd ff ff       	call   801348 <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
}
  8015db:	90                   	nop
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 17                	push   $0x17
  8015ed:	e8 56 fd ff ff       	call   801348 <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
}
  8015f5:	90                   	nop
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	ff 75 0c             	pushl  0xc(%ebp)
  801607:	50                   	push   %eax
  801608:	6a 18                	push   $0x18
  80160a:	e8 39 fd ff ff       	call   801348 <syscall>
  80160f:	83 c4 18             	add    $0x18,%esp
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	52                   	push   %edx
  801624:	50                   	push   %eax
  801625:	6a 1b                	push   $0x1b
  801627:	e8 1c fd ff ff       	call   801348 <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801634:	8b 55 0c             	mov    0xc(%ebp),%edx
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	52                   	push   %edx
  801641:	50                   	push   %eax
  801642:	6a 19                	push   $0x19
  801644:	e8 ff fc ff ff       	call   801348 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
}
  80164c:	90                   	nop
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801652:	8b 55 0c             	mov    0xc(%ebp),%edx
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	52                   	push   %edx
  80165f:	50                   	push   %eax
  801660:	6a 1a                	push   $0x1a
  801662:	e8 e1 fc ff ff       	call   801348 <syscall>
  801667:	83 c4 18             	add    $0x18,%esp
}
  80166a:	90                   	nop
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 04             	sub    $0x4,%esp
  801673:	8b 45 10             	mov    0x10(%ebp),%eax
  801676:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801679:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80167c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	6a 00                	push   $0x0
  801685:	51                   	push   %ecx
  801686:	52                   	push   %edx
  801687:	ff 75 0c             	pushl  0xc(%ebp)
  80168a:	50                   	push   %eax
  80168b:	6a 1c                	push   $0x1c
  80168d:	e8 b6 fc ff ff       	call   801348 <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80169a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	52                   	push   %edx
  8016a7:	50                   	push   %eax
  8016a8:	6a 1d                	push   $0x1d
  8016aa:	e8 99 fc ff ff       	call   801348 <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
}
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	51                   	push   %ecx
  8016c5:	52                   	push   %edx
  8016c6:	50                   	push   %eax
  8016c7:	6a 1e                	push   $0x1e
  8016c9:	e8 7a fc ff ff       	call   801348 <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	52                   	push   %edx
  8016e3:	50                   	push   %eax
  8016e4:	6a 1f                	push   $0x1f
  8016e6:	e8 5d fc ff ff       	call   801348 <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 20                	push   $0x20
  8016ff:	e8 44 fc ff ff       	call   801348 <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	ff 75 10             	pushl  0x10(%ebp)
  801716:	ff 75 0c             	pushl  0xc(%ebp)
  801719:	50                   	push   %eax
  80171a:	6a 21                	push   $0x21
  80171c:	e8 27 fc ff ff       	call   801348 <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	50                   	push   %eax
  801735:	6a 22                	push   $0x22
  801737:	e8 0c fc ff ff       	call   801348 <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
}
  80173f:	90                   	nop
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	50                   	push   %eax
  801751:	6a 23                	push   $0x23
  801753:	e8 f0 fb ff ff       	call   801348 <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
}
  80175b:	90                   	nop
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801764:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801767:	8d 50 04             	lea    0x4(%eax),%edx
  80176a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	52                   	push   %edx
  801774:	50                   	push   %eax
  801775:	6a 24                	push   $0x24
  801777:	e8 cc fb ff ff       	call   801348 <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
	return result;
  80177f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801782:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801785:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801788:	89 01                	mov    %eax,(%ecx)
  80178a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	c9                   	leave  
  801791:	c2 04 00             	ret    $0x4

00801794 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	ff 75 10             	pushl  0x10(%ebp)
  80179e:	ff 75 0c             	pushl  0xc(%ebp)
  8017a1:	ff 75 08             	pushl  0x8(%ebp)
  8017a4:	6a 13                	push   $0x13
  8017a6:	e8 9d fb ff ff       	call   801348 <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ae:	90                   	nop
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 25                	push   $0x25
  8017c0:	e8 83 fb ff ff       	call   801348 <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 04             	sub    $0x4,%esp
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017d6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	50                   	push   %eax
  8017e3:	6a 26                	push   $0x26
  8017e5:	e8 5e fb ff ff       	call   801348 <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ed:	90                   	nop
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <rsttst>:
void rsttst()
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 28                	push   $0x28
  8017ff:	e8 44 fb ff ff       	call   801348 <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
	return ;
  801807:	90                   	nop
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	8b 45 14             	mov    0x14(%ebp),%eax
  801813:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801816:	8b 55 18             	mov    0x18(%ebp),%edx
  801819:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80181d:	52                   	push   %edx
  80181e:	50                   	push   %eax
  80181f:	ff 75 10             	pushl  0x10(%ebp)
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	ff 75 08             	pushl  0x8(%ebp)
  801828:	6a 27                	push   $0x27
  80182a:	e8 19 fb ff ff       	call   801348 <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
	return ;
  801832:	90                   	nop
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <chktst>:
void chktst(uint32 n)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	ff 75 08             	pushl  0x8(%ebp)
  801843:	6a 29                	push   $0x29
  801845:	e8 fe fa ff ff       	call   801348 <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
	return ;
  80184d:	90                   	nop
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <inctst>:

void inctst()
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 2a                	push   $0x2a
  80185f:	e8 e4 fa ff ff       	call   801348 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
	return ;
  801867:	90                   	nop
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <gettst>:
uint32 gettst()
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 2b                	push   $0x2b
  801879:	e8 ca fa ff ff       	call   801348 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 2c                	push   $0x2c
  801895:	e8 ae fa ff ff       	call   801348 <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
  80189d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018a0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018a4:	75 07                	jne    8018ad <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ab:	eb 05                	jmp    8018b2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 2c                	push   $0x2c
  8018c6:	e8 7d fa ff ff       	call   801348 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
  8018ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8018d1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8018d5:	75 07                	jne    8018de <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8018d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8018dc:	eb 05                	jmp    8018e3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8018de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 2c                	push   $0x2c
  8018f7:	e8 4c fa ff ff       	call   801348 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
  8018ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801902:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801906:	75 07                	jne    80190f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801908:	b8 01 00 00 00       	mov    $0x1,%eax
  80190d:	eb 05                	jmp    801914 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80190f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 2c                	push   $0x2c
  801928:	e8 1b fa ff ff       	call   801348 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
  801930:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801933:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801937:	75 07                	jne    801940 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801939:	b8 01 00 00 00       	mov    $0x1,%eax
  80193e:	eb 05                	jmp    801945 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801940:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	ff 75 08             	pushl  0x8(%ebp)
  801955:	6a 2d                	push   $0x2d
  801957:	e8 ec f9 ff ff       	call   801348 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
	return ;
  80195f:	90                   	nop
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801966:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801969:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	6a 00                	push   $0x0
  801974:	53                   	push   %ebx
  801975:	51                   	push   %ecx
  801976:	52                   	push   %edx
  801977:	50                   	push   %eax
  801978:	6a 2e                	push   $0x2e
  80197a:	e8 c9 f9 ff ff       	call   801348 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80198a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	52                   	push   %edx
  801997:	50                   	push   %eax
  801998:	6a 2f                	push   $0x2f
  80199a:	e8 a9 f9 ff ff       	call   801348 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019b0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019b4:	83 ec 0c             	sub    $0xc,%esp
  8019b7:	50                   	push   %eax
  8019b8:	e8 fb fb ff ff       	call   8015b8 <sys_cputc>
  8019bd:	83 c4 10             	add    $0x10,%esp
}
  8019c0:	90                   	nop
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8019c9:	e8 b6 fb ff ff       	call   801584 <sys_disable_interrupt>
	char c = ch;
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019d4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019d8:	83 ec 0c             	sub    $0xc,%esp
  8019db:	50                   	push   %eax
  8019dc:	e8 d7 fb ff ff       	call   8015b8 <sys_cputc>
  8019e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8019e4:	e8 b5 fb ff ff       	call   80159e <sys_enable_interrupt>
}
  8019e9:	90                   	nop
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <getchar>:

int
getchar(void)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8019f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8019f9:	eb 08                	jmp    801a03 <getchar+0x17>
	{
		c = sys_cgetc();
  8019fb:	e8 9c f9 ff ff       	call   80139c <sys_cgetc>
  801a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  801a03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a07:	74 f2                	je     8019fb <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  801a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <atomic_getchar>:

int
atomic_getchar(void)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801a14:	e8 6b fb ff ff       	call   801584 <sys_disable_interrupt>
	int c=0;
  801a19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801a20:	eb 08                	jmp    801a2a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801a22:	e8 75 f9 ff ff       	call   80139c <sys_cgetc>
  801a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801a2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a2e:	74 f2                	je     801a22 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801a30:	e8 69 fb ff ff       	call   80159e <sys_enable_interrupt>
	return c;
  801a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <iscons>:

int iscons(int fdnum)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a3d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a42:	5d                   	pop    %ebp
  801a43:	c3                   	ret    

00801a44 <__udivdi3>:
  801a44:	55                   	push   %ebp
  801a45:	57                   	push   %edi
  801a46:	56                   	push   %esi
  801a47:	53                   	push   %ebx
  801a48:	83 ec 1c             	sub    $0x1c,%esp
  801a4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a5b:	89 ca                	mov    %ecx,%edx
  801a5d:	89 f8                	mov    %edi,%eax
  801a5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a63:	85 f6                	test   %esi,%esi
  801a65:	75 2d                	jne    801a94 <__udivdi3+0x50>
  801a67:	39 cf                	cmp    %ecx,%edi
  801a69:	77 65                	ja     801ad0 <__udivdi3+0x8c>
  801a6b:	89 fd                	mov    %edi,%ebp
  801a6d:	85 ff                	test   %edi,%edi
  801a6f:	75 0b                	jne    801a7c <__udivdi3+0x38>
  801a71:	b8 01 00 00 00       	mov    $0x1,%eax
  801a76:	31 d2                	xor    %edx,%edx
  801a78:	f7 f7                	div    %edi
  801a7a:	89 c5                	mov    %eax,%ebp
  801a7c:	31 d2                	xor    %edx,%edx
  801a7e:	89 c8                	mov    %ecx,%eax
  801a80:	f7 f5                	div    %ebp
  801a82:	89 c1                	mov    %eax,%ecx
  801a84:	89 d8                	mov    %ebx,%eax
  801a86:	f7 f5                	div    %ebp
  801a88:	89 cf                	mov    %ecx,%edi
  801a8a:	89 fa                	mov    %edi,%edx
  801a8c:	83 c4 1c             	add    $0x1c,%esp
  801a8f:	5b                   	pop    %ebx
  801a90:	5e                   	pop    %esi
  801a91:	5f                   	pop    %edi
  801a92:	5d                   	pop    %ebp
  801a93:	c3                   	ret    
  801a94:	39 ce                	cmp    %ecx,%esi
  801a96:	77 28                	ja     801ac0 <__udivdi3+0x7c>
  801a98:	0f bd fe             	bsr    %esi,%edi
  801a9b:	83 f7 1f             	xor    $0x1f,%edi
  801a9e:	75 40                	jne    801ae0 <__udivdi3+0x9c>
  801aa0:	39 ce                	cmp    %ecx,%esi
  801aa2:	72 0a                	jb     801aae <__udivdi3+0x6a>
  801aa4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801aa8:	0f 87 9e 00 00 00    	ja     801b4c <__udivdi3+0x108>
  801aae:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab3:	89 fa                	mov    %edi,%edx
  801ab5:	83 c4 1c             	add    $0x1c,%esp
  801ab8:	5b                   	pop    %ebx
  801ab9:	5e                   	pop    %esi
  801aba:	5f                   	pop    %edi
  801abb:	5d                   	pop    %ebp
  801abc:	c3                   	ret    
  801abd:	8d 76 00             	lea    0x0(%esi),%esi
  801ac0:	31 ff                	xor    %edi,%edi
  801ac2:	31 c0                	xor    %eax,%eax
  801ac4:	89 fa                	mov    %edi,%edx
  801ac6:	83 c4 1c             	add    $0x1c,%esp
  801ac9:	5b                   	pop    %ebx
  801aca:	5e                   	pop    %esi
  801acb:	5f                   	pop    %edi
  801acc:	5d                   	pop    %ebp
  801acd:	c3                   	ret    
  801ace:	66 90                	xchg   %ax,%ax
  801ad0:	89 d8                	mov    %ebx,%eax
  801ad2:	f7 f7                	div    %edi
  801ad4:	31 ff                	xor    %edi,%edi
  801ad6:	89 fa                	mov    %edi,%edx
  801ad8:	83 c4 1c             	add    $0x1c,%esp
  801adb:	5b                   	pop    %ebx
  801adc:	5e                   	pop    %esi
  801add:	5f                   	pop    %edi
  801ade:	5d                   	pop    %ebp
  801adf:	c3                   	ret    
  801ae0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ae5:	89 eb                	mov    %ebp,%ebx
  801ae7:	29 fb                	sub    %edi,%ebx
  801ae9:	89 f9                	mov    %edi,%ecx
  801aeb:	d3 e6                	shl    %cl,%esi
  801aed:	89 c5                	mov    %eax,%ebp
  801aef:	88 d9                	mov    %bl,%cl
  801af1:	d3 ed                	shr    %cl,%ebp
  801af3:	89 e9                	mov    %ebp,%ecx
  801af5:	09 f1                	or     %esi,%ecx
  801af7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801afb:	89 f9                	mov    %edi,%ecx
  801afd:	d3 e0                	shl    %cl,%eax
  801aff:	89 c5                	mov    %eax,%ebp
  801b01:	89 d6                	mov    %edx,%esi
  801b03:	88 d9                	mov    %bl,%cl
  801b05:	d3 ee                	shr    %cl,%esi
  801b07:	89 f9                	mov    %edi,%ecx
  801b09:	d3 e2                	shl    %cl,%edx
  801b0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0f:	88 d9                	mov    %bl,%cl
  801b11:	d3 e8                	shr    %cl,%eax
  801b13:	09 c2                	or     %eax,%edx
  801b15:	89 d0                	mov    %edx,%eax
  801b17:	89 f2                	mov    %esi,%edx
  801b19:	f7 74 24 0c          	divl   0xc(%esp)
  801b1d:	89 d6                	mov    %edx,%esi
  801b1f:	89 c3                	mov    %eax,%ebx
  801b21:	f7 e5                	mul    %ebp
  801b23:	39 d6                	cmp    %edx,%esi
  801b25:	72 19                	jb     801b40 <__udivdi3+0xfc>
  801b27:	74 0b                	je     801b34 <__udivdi3+0xf0>
  801b29:	89 d8                	mov    %ebx,%eax
  801b2b:	31 ff                	xor    %edi,%edi
  801b2d:	e9 58 ff ff ff       	jmp    801a8a <__udivdi3+0x46>
  801b32:	66 90                	xchg   %ax,%ax
  801b34:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b38:	89 f9                	mov    %edi,%ecx
  801b3a:	d3 e2                	shl    %cl,%edx
  801b3c:	39 c2                	cmp    %eax,%edx
  801b3e:	73 e9                	jae    801b29 <__udivdi3+0xe5>
  801b40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b43:	31 ff                	xor    %edi,%edi
  801b45:	e9 40 ff ff ff       	jmp    801a8a <__udivdi3+0x46>
  801b4a:	66 90                	xchg   %ax,%ax
  801b4c:	31 c0                	xor    %eax,%eax
  801b4e:	e9 37 ff ff ff       	jmp    801a8a <__udivdi3+0x46>
  801b53:	90                   	nop

00801b54 <__umoddi3>:
  801b54:	55                   	push   %ebp
  801b55:	57                   	push   %edi
  801b56:	56                   	push   %esi
  801b57:	53                   	push   %ebx
  801b58:	83 ec 1c             	sub    $0x1c,%esp
  801b5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b73:	89 f3                	mov    %esi,%ebx
  801b75:	89 fa                	mov    %edi,%edx
  801b77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b7b:	89 34 24             	mov    %esi,(%esp)
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	75 1a                	jne    801b9c <__umoddi3+0x48>
  801b82:	39 f7                	cmp    %esi,%edi
  801b84:	0f 86 a2 00 00 00    	jbe    801c2c <__umoddi3+0xd8>
  801b8a:	89 c8                	mov    %ecx,%eax
  801b8c:	89 f2                	mov    %esi,%edx
  801b8e:	f7 f7                	div    %edi
  801b90:	89 d0                	mov    %edx,%eax
  801b92:	31 d2                	xor    %edx,%edx
  801b94:	83 c4 1c             	add    $0x1c,%esp
  801b97:	5b                   	pop    %ebx
  801b98:	5e                   	pop    %esi
  801b99:	5f                   	pop    %edi
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    
  801b9c:	39 f0                	cmp    %esi,%eax
  801b9e:	0f 87 ac 00 00 00    	ja     801c50 <__umoddi3+0xfc>
  801ba4:	0f bd e8             	bsr    %eax,%ebp
  801ba7:	83 f5 1f             	xor    $0x1f,%ebp
  801baa:	0f 84 ac 00 00 00    	je     801c5c <__umoddi3+0x108>
  801bb0:	bf 20 00 00 00       	mov    $0x20,%edi
  801bb5:	29 ef                	sub    %ebp,%edi
  801bb7:	89 fe                	mov    %edi,%esi
  801bb9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bbd:	89 e9                	mov    %ebp,%ecx
  801bbf:	d3 e0                	shl    %cl,%eax
  801bc1:	89 d7                	mov    %edx,%edi
  801bc3:	89 f1                	mov    %esi,%ecx
  801bc5:	d3 ef                	shr    %cl,%edi
  801bc7:	09 c7                	or     %eax,%edi
  801bc9:	89 e9                	mov    %ebp,%ecx
  801bcb:	d3 e2                	shl    %cl,%edx
  801bcd:	89 14 24             	mov    %edx,(%esp)
  801bd0:	89 d8                	mov    %ebx,%eax
  801bd2:	d3 e0                	shl    %cl,%eax
  801bd4:	89 c2                	mov    %eax,%edx
  801bd6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bda:	d3 e0                	shl    %cl,%eax
  801bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801be4:	89 f1                	mov    %esi,%ecx
  801be6:	d3 e8                	shr    %cl,%eax
  801be8:	09 d0                	or     %edx,%eax
  801bea:	d3 eb                	shr    %cl,%ebx
  801bec:	89 da                	mov    %ebx,%edx
  801bee:	f7 f7                	div    %edi
  801bf0:	89 d3                	mov    %edx,%ebx
  801bf2:	f7 24 24             	mull   (%esp)
  801bf5:	89 c6                	mov    %eax,%esi
  801bf7:	89 d1                	mov    %edx,%ecx
  801bf9:	39 d3                	cmp    %edx,%ebx
  801bfb:	0f 82 87 00 00 00    	jb     801c88 <__umoddi3+0x134>
  801c01:	0f 84 91 00 00 00    	je     801c98 <__umoddi3+0x144>
  801c07:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c0b:	29 f2                	sub    %esi,%edx
  801c0d:	19 cb                	sbb    %ecx,%ebx
  801c0f:	89 d8                	mov    %ebx,%eax
  801c11:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c15:	d3 e0                	shl    %cl,%eax
  801c17:	89 e9                	mov    %ebp,%ecx
  801c19:	d3 ea                	shr    %cl,%edx
  801c1b:	09 d0                	or     %edx,%eax
  801c1d:	89 e9                	mov    %ebp,%ecx
  801c1f:	d3 eb                	shr    %cl,%ebx
  801c21:	89 da                	mov    %ebx,%edx
  801c23:	83 c4 1c             	add    $0x1c,%esp
  801c26:	5b                   	pop    %ebx
  801c27:	5e                   	pop    %esi
  801c28:	5f                   	pop    %edi
  801c29:	5d                   	pop    %ebp
  801c2a:	c3                   	ret    
  801c2b:	90                   	nop
  801c2c:	89 fd                	mov    %edi,%ebp
  801c2e:	85 ff                	test   %edi,%edi
  801c30:	75 0b                	jne    801c3d <__umoddi3+0xe9>
  801c32:	b8 01 00 00 00       	mov    $0x1,%eax
  801c37:	31 d2                	xor    %edx,%edx
  801c39:	f7 f7                	div    %edi
  801c3b:	89 c5                	mov    %eax,%ebp
  801c3d:	89 f0                	mov    %esi,%eax
  801c3f:	31 d2                	xor    %edx,%edx
  801c41:	f7 f5                	div    %ebp
  801c43:	89 c8                	mov    %ecx,%eax
  801c45:	f7 f5                	div    %ebp
  801c47:	89 d0                	mov    %edx,%eax
  801c49:	e9 44 ff ff ff       	jmp    801b92 <__umoddi3+0x3e>
  801c4e:	66 90                	xchg   %ax,%ax
  801c50:	89 c8                	mov    %ecx,%eax
  801c52:	89 f2                	mov    %esi,%edx
  801c54:	83 c4 1c             	add    $0x1c,%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5e                   	pop    %esi
  801c59:	5f                   	pop    %edi
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    
  801c5c:	3b 04 24             	cmp    (%esp),%eax
  801c5f:	72 06                	jb     801c67 <__umoddi3+0x113>
  801c61:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c65:	77 0f                	ja     801c76 <__umoddi3+0x122>
  801c67:	89 f2                	mov    %esi,%edx
  801c69:	29 f9                	sub    %edi,%ecx
  801c6b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c6f:	89 14 24             	mov    %edx,(%esp)
  801c72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c76:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c7a:	8b 14 24             	mov    (%esp),%edx
  801c7d:	83 c4 1c             	add    $0x1c,%esp
  801c80:	5b                   	pop    %ebx
  801c81:	5e                   	pop    %esi
  801c82:	5f                   	pop    %edi
  801c83:	5d                   	pop    %ebp
  801c84:	c3                   	ret    
  801c85:	8d 76 00             	lea    0x0(%esi),%esi
  801c88:	2b 04 24             	sub    (%esp),%eax
  801c8b:	19 fa                	sbb    %edi,%edx
  801c8d:	89 d1                	mov    %edx,%ecx
  801c8f:	89 c6                	mov    %eax,%esi
  801c91:	e9 71 ff ff ff       	jmp    801c07 <__umoddi3+0xb3>
  801c96:	66 90                	xchg   %ax,%ax
  801c98:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c9c:	72 ea                	jb     801c88 <__umoddi3+0x134>
  801c9e:	89 d9                	mov    %ebx,%ecx
  801ca0:	e9 62 ff ff ff       	jmp    801c07 <__umoddi3+0xb3>
