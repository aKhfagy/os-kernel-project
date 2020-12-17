
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 e4 06 00 00       	call   80071a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 88 00 00 00    	sub    $0x88,%esp
	/*[1] CREATE SHARED ARRAY*/
	int ret;
	char Chose;
	char Line[30];
	//2012: lock the interrupt
	sys_disable_interrupt();
  800041:	e8 2f 1d 00 00       	call   801d75 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 24 80 00       	push   $0x802400
  80004e:	e8 ae 0a 00 00       	call   800b01 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 24 80 00       	push   $0x802402
  80005e:	e8 9e 0a 00 00       	call   800b01 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 20 24 80 00       	push   $0x802420
  80006e:	e8 8e 0a 00 00       	call   800b01 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 24 80 00       	push   $0x802402
  80007e:	e8 7e 0a 00 00       	call   800b01 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 24 80 00       	push   $0x802400
  80008e:	e8 6e 0a 00 00       	call   800b01 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 40 24 80 00       	push   $0x802440
  8000a2:	e8 dc 10 00 00       	call   801183 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 5f 24 80 00       	push   $0x80245f
  8000b6:	e8 f0 19 00 00       	call   801aab <smalloc>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 0a                	push   $0xa
  8000c6:	6a 00                	push   $0x0
  8000c8:	8d 45 82             	lea    -0x7e(%ebp),%eax
  8000cb:	50                   	push   %eax
  8000cc:	e8 18 16 00 00       	call   8016e9 <strtol>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	89 c2                	mov    %eax,%edx
  8000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d9:	89 10                	mov    %edx,(%eax)
		int NumOfElements = *arrSize;
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8b 00                	mov    (%eax),%eax
  8000e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  8000e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e6:	c1 e0 02             	shl    $0x2,%eax
  8000e9:	83 ec 04             	sub    $0x4,%esp
  8000ec:	6a 00                	push   $0x0
  8000ee:	50                   	push   %eax
  8000ef:	68 67 24 80 00       	push   $0x802467
  8000f4:	e8 b2 19 00 00       	call   801aab <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 6c 24 80 00       	push   $0x80246c
  800107:	e8 f5 09 00 00       	call   800b01 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 8e 24 80 00       	push   $0x80248e
  800117:	e8 e5 09 00 00       	call   800b01 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 9c 24 80 00       	push   $0x80249c
  800127:	e8 d5 09 00 00       	call   800b01 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 ab 24 80 00       	push   $0x8024ab
  800137:	e8 c5 09 00 00       	call   800b01 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 bb 24 80 00       	push   $0x8024bb
  800147:	e8 b5 09 00 00       	call   800b01 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80014f:	e8 6e 05 00 00       	call   8006c2 <getchar>
  800154:	88 45 eb             	mov    %al,-0x15(%ebp)
			cputchar(Chose);
  800157:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	50                   	push   %eax
  80015f:	e8 16 05 00 00       	call   80067a <cputchar>
  800164:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	6a 0a                	push   $0xa
  80016c:	e8 09 05 00 00       	call   80067a <cputchar>
  800171:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800174:	80 7d eb 61          	cmpb   $0x61,-0x15(%ebp)
  800178:	74 0c                	je     800186 <_main+0x14e>
  80017a:	80 7d eb 62          	cmpb   $0x62,-0x15(%ebp)
  80017e:	74 06                	je     800186 <_main+0x14e>
  800180:	80 7d eb 63          	cmpb   $0x63,-0x15(%ebp)
  800184:	75 b9                	jne    80013f <_main+0x107>

	//2012: unlock the interrupt
	sys_enable_interrupt();
  800186:	e8 04 1c 00 00       	call   801d8f <sys_enable_interrupt>

	int  i ;
	switch (Chose)
  80018b:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80018f:	83 f8 62             	cmp    $0x62,%eax
  800192:	74 1d                	je     8001b1 <_main+0x179>
  800194:	83 f8 63             	cmp    $0x63,%eax
  800197:	74 2b                	je     8001c4 <_main+0x18c>
  800199:	83 f8 61             	cmp    $0x61,%eax
  80019c:	75 39                	jne    8001d7 <_main+0x19f>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	e8 54 03 00 00       	call   800500 <InitializeAscending>
  8001ac:	83 c4 10             	add    $0x10,%esp
		break ;
  8001af:	eb 37                	jmp    8001e8 <_main+0x1b0>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 72 03 00 00       	call   800531 <InitializeDescending>
  8001bf:	83 c4 10             	add    $0x10,%esp
		break ;
  8001c2:	eb 24                	jmp    8001e8 <_main+0x1b0>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 94 03 00 00       	call   800566 <InitializeSemiRandom>
  8001d2:	83 c4 10             	add    $0x10,%esp
		break ;
  8001d5:	eb 11                	jmp    8001e8 <_main+0x1b0>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	ff 75 f0             	pushl  -0x10(%ebp)
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	e8 81 03 00 00       	call   800566 <InitializeSemiRandom>
  8001e5:	83 c4 10             	add    $0x10,%esp
	}

	//Create the check-finishing counter
	int numOfSlaveProgs = 3 ;
  8001e8:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	6a 04                	push   $0x4
  8001f6:	68 c4 24 80 00       	push   $0x8024c4
  8001fb:	e8 ab 18 00 00       	call   801aab <smalloc>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  800206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[2] RUN THE SLAVES PROGRAMS*/
	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  80020f:	a1 20 30 80 00       	mov    0x803020,%eax
  800214:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80021a:	a1 20 30 80 00       	mov    0x803020,%eax
  80021f:	8b 40 74             	mov    0x74(%eax),%eax
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	52                   	push   %edx
  800226:	50                   	push   %eax
  800227:	68 d2 24 80 00       	push   $0x8024d2
  80022c:	e8 c9 1c 00 00       	call   801efa <sys_create_env>
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  800237:	a1 20 30 80 00       	mov    0x803020,%eax
  80023c:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800242:	a1 20 30 80 00       	mov    0x803020,%eax
  800247:	8b 40 74             	mov    0x74(%eax),%eax
  80024a:	83 ec 04             	sub    $0x4,%esp
  80024d:	52                   	push   %edx
  80024e:	50                   	push   %eax
  80024f:	68 db 24 80 00       	push   $0x8024db
  800254:	e8 a1 1c 00 00       	call   801efa <sys_create_env>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size),(myEnv->percentage_of_WS_pages_to_be_removed));
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80026a:	a1 20 30 80 00       	mov    0x803020,%eax
  80026f:	8b 40 74             	mov    0x74(%eax),%eax
  800272:	83 ec 04             	sub    $0x4,%esp
  800275:	52                   	push   %edx
  800276:	50                   	push   %eax
  800277:	68 e4 24 80 00       	push   $0x8024e4
  80027c:	e8 79 1c 00 00       	call   801efa <sys_create_env>
  800281:	83 c4 10             	add    $0x10,%esp
  800284:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	sys_run_env(envIdQuickSort);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	ff 75 dc             	pushl  -0x24(%ebp)
  80028d:	e8 85 1c 00 00       	call   801f17 <sys_run_env>
  800292:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	ff 75 d8             	pushl  -0x28(%ebp)
  80029b:	e8 77 1c 00 00       	call   801f17 <sys_run_env>
  8002a0:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002a3:	83 ec 0c             	sub    $0xc,%esp
  8002a6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a9:	e8 69 1c 00 00       	call   801f17 <sys_run_env>
  8002ae:	83 c4 10             	add    $0x10,%esp

	/*[3] BUSY-WAIT TILL FINISHING THEM*/
	while (*numOfFinished != numOfSlaveProgs) ;
  8002b1:	90                   	nop
  8002b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8002ba:	75 f6                	jne    8002b2 <_main+0x27a>

	/*[4] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  8002bc:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int *mergesortedArr = NULL;
  8002c3:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	int *mean = NULL;
  8002ca:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	int *var = NULL;
  8002d1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	int *min = NULL;
  8002d8:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
	int *max = NULL;
  8002df:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int *med = NULL;
  8002e6:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  8002ed:	83 ec 08             	sub    $0x8,%esp
  8002f0:	68 f0 24 80 00       	push   $0x8024f0
  8002f5:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f8:	e8 ce 17 00 00       	call   801acb <sget>
  8002fd:	83 c4 10             	add    $0x10,%esp
  800300:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	68 ff 24 80 00       	push   $0x8024ff
  80030b:	ff 75 d8             	pushl  -0x28(%ebp)
  80030e:	e8 b8 17 00 00       	call   801acb <sget>
  800313:	83 c4 10             	add    $0x10,%esp
  800316:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800319:	83 ec 08             	sub    $0x8,%esp
  80031c:	68 0e 25 80 00       	push   $0x80250e
  800321:	ff 75 d4             	pushl  -0x2c(%ebp)
  800324:	e8 a2 17 00 00       	call   801acb <sget>
  800329:	83 c4 10             	add    $0x10,%esp
  80032c:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	68 13 25 80 00       	push   $0x802513
  800337:	ff 75 d4             	pushl  -0x2c(%ebp)
  80033a:	e8 8c 17 00 00       	call   801acb <sget>
  80033f:	83 c4 10             	add    $0x10,%esp
  800342:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	68 17 25 80 00       	push   $0x802517
  80034d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800350:	e8 76 17 00 00       	call   801acb <sget>
  800355:	83 c4 10             	add    $0x10,%esp
  800358:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  80035b:	83 ec 08             	sub    $0x8,%esp
  80035e:	68 1b 25 80 00       	push   $0x80251b
  800363:	ff 75 d4             	pushl  -0x2c(%ebp)
  800366:	e8 60 17 00 00       	call   801acb <sget>
  80036b:	83 c4 10             	add    $0x10,%esp
  80036e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  800371:	83 ec 08             	sub    $0x8,%esp
  800374:	68 1f 25 80 00       	push   $0x80251f
  800379:	ff 75 d4             	pushl  -0x2c(%ebp)
  80037c:	e8 4a 17 00 00       	call   801acb <sget>
  800381:	83 c4 10             	add    $0x10,%esp
  800384:	89 45 b8             	mov    %eax,-0x48(%ebp)

	/*[5] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  800387:	83 ec 08             	sub    $0x8,%esp
  80038a:	ff 75 f0             	pushl  -0x10(%ebp)
  80038d:	ff 75 d0             	pushl  -0x30(%ebp)
  800390:	e8 14 01 00 00       	call   8004a9 <CheckSorted>
  800395:	83 c4 10             	add    $0x10,%esp
  800398:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  80039b:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80039f:	75 14                	jne    8003b5 <_main+0x37d>
  8003a1:	83 ec 04             	sub    $0x4,%esp
  8003a4:	68 24 25 80 00       	push   $0x802524
  8003a9:	6a 62                	push   $0x62
  8003ab:	68 4c 25 80 00       	push   $0x80254c
  8003b0:	e8 aa 04 00 00       	call   80085f <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8003b5:	83 ec 08             	sub    $0x8,%esp
  8003b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8003bb:	ff 75 cc             	pushl  -0x34(%ebp)
  8003be:	e8 e6 00 00 00       	call   8004a9 <CheckSorted>
  8003c3:	83 c4 10             	add    $0x10,%esp
  8003c6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  8003c9:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8003cd:	75 14                	jne    8003e3 <_main+0x3ab>
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 6c 25 80 00       	push   $0x80256c
  8003d7:	6a 64                	push   $0x64
  8003d9:	68 4c 25 80 00       	push   $0x80254c
  8003de:	e8 7c 04 00 00       	call   80085f <_panic>
	int correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  8003e3:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  8003e9:	50                   	push   %eax
  8003ea:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003f0:	50                   	push   %eax
  8003f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8003f7:	e8 b6 01 00 00       	call   8005b2 <ArrayStats>
  8003fc:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  8003ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800402:	8b 00                	mov    (%eax),%eax
  800404:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int last = NumOfElements-1;
  800407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040a:	48                   	dec    %eax
  80040b:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int middle = (NumOfElements-1)/2;
  80040e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800411:	48                   	dec    %eax
  800412:	89 c2                	mov    %eax,%edx
  800414:	c1 ea 1f             	shr    $0x1f,%edx
  800417:	01 d0                	add    %edx,%eax
  800419:	d1 f8                	sar    %eax
  80041b:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int correctMax = quicksortedArr[last];
  80041e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800421:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800428:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int correctMed = quicksortedArr[middle];
  800432:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//cprintf("Array is correctly sorted\n");
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);

	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  800446:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800449:	8b 10                	mov    (%eax),%edx
  80044b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800451:	39 c2                	cmp    %eax,%edx
  800453:	75 2d                	jne    800482 <_main+0x44a>
  800455:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800458:	8b 10                	mov    (%eax),%edx
  80045a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800460:	39 c2                	cmp    %eax,%edx
  800462:	75 1e                	jne    800482 <_main+0x44a>
  800464:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  80046c:	75 14                	jne    800482 <_main+0x44a>
  80046e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  800476:	75 0a                	jne    800482 <_main+0x44a>
  800478:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80047b:	8b 00                	mov    (%eax),%eax
  80047d:	3b 45 a0             	cmp    -0x60(%ebp),%eax
  800480:	74 14                	je     800496 <_main+0x45e>
		panic("The array STATS are NOT calculated correctly") ;
  800482:	83 ec 04             	sub    $0x4,%esp
  800485:	68 94 25 80 00       	push   $0x802594
  80048a:	6a 71                	push   $0x71
  80048c:	68 4c 25 80 00       	push   $0x80254c
  800491:	e8 c9 03 00 00       	call   80085f <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	68 c4 25 80 00       	push   $0x8025c4
  80049e:	e8 5e 06 00 00       	call   800b01 <cprintf>
  8004a3:	83 c4 10             	add    $0x10,%esp

	return;
  8004a6:	90                   	nop
}
  8004a7:	c9                   	leave  
  8004a8:	c3                   	ret    

008004a9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8004a9:	55                   	push   %ebp
  8004aa:	89 e5                	mov    %esp,%ebp
  8004ac:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8004af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8004b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8004bd:	eb 33                	jmp    8004f2 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8004bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8004c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	01 d0                	add    %edx,%eax
  8004ce:	8b 10                	mov    (%eax),%edx
  8004d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8004d3:	40                   	inc    %eax
  8004d4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	01 c8                	add    %ecx,%eax
  8004e0:	8b 00                	mov    (%eax),%eax
  8004e2:	39 c2                	cmp    %eax,%edx
  8004e4:	7e 09                	jle    8004ef <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8004e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8004ed:	eb 0c                	jmp    8004fb <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8004ef:	ff 45 f8             	incl   -0x8(%ebp)
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f5:	48                   	dec    %eax
  8004f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8004f9:	7f c4                	jg     8004bf <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8004fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8004fe:	c9                   	leave  
  8004ff:	c3                   	ret    

00800500 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800506:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80050d:	eb 17                	jmp    800526 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80050f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800512:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	01 c2                	add    %eax,%edx
  80051e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800521:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800523:	ff 45 fc             	incl   -0x4(%ebp)
  800526:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800529:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80052c:	7c e1                	jl     80050f <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80052e:	90                   	nop
  80052f:	c9                   	leave  
  800530:	c3                   	ret    

00800531 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800537:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80053e:	eb 1b                	jmp    80055b <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800543:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054a:	8b 45 08             	mov    0x8(%ebp),%eax
  80054d:	01 c2                	add    %eax,%edx
  80054f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800552:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800555:	48                   	dec    %eax
  800556:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800558:	ff 45 fc             	incl   -0x4(%ebp)
  80055b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80055e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800561:	7c dd                	jl     800540 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800563:	90                   	nop
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80056c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80056f:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800574:	f7 e9                	imul   %ecx
  800576:	c1 f9 1f             	sar    $0x1f,%ecx
  800579:	89 d0                	mov    %edx,%eax
  80057b:	29 c8                	sub    %ecx,%eax
  80057d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800580:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800587:	eb 1e                	jmp    8005a7 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800589:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80058c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800599:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80059c:	99                   	cltd   
  80059d:	f7 7d f8             	idivl  -0x8(%ebp)
  8005a0:	89 d0                	mov    %edx,%eax
  8005a2:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8005a4:	ff 45 fc             	incl   -0x4(%ebp)
  8005a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005ad:	7c da                	jl     800589 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  8005af:	90                   	nop
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	53                   	push   %ebx
  8005b6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	*mean =0 ;
  8005b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  8005c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005c9:	eb 20                	jmp    8005eb <ArrayStats+0x39>
	{
		*mean += Elements[i];
  8005cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ce:	8b 10                	mov    (%eax),%edx
  8005d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005d3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	01 c8                	add    %ecx,%eax
  8005df:	8b 00                	mov    (%eax),%eax
  8005e1:	01 c2                	add    %eax,%edx
  8005e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e6:	89 10                	mov    %edx,(%eax)

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8005e8:	ff 45 f8             	incl   -0x8(%ebp)
  8005eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f1:	7c d8                	jl     8005cb <ArrayStats+0x19>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  8005f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	99                   	cltd   
  8005f9:	f7 7d 0c             	idivl  0xc(%ebp)
  8005fc:	89 c2                	mov    %eax,%edx
  8005fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800601:	89 10                	mov    %edx,(%eax)
	*var = 0;
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80060c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800613:	eb 46                	jmp    80065b <ArrayStats+0xa9>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8b 10                	mov    (%eax),%edx
  80061a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80061d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800624:	8b 45 08             	mov    0x8(%ebp),%eax
  800627:	01 c8                	add    %ecx,%eax
  800629:	8b 08                	mov    (%eax),%ecx
  80062b:	8b 45 10             	mov    0x10(%ebp),%eax
  80062e:	8b 00                	mov    (%eax),%eax
  800630:	89 cb                	mov    %ecx,%ebx
  800632:	29 c3                	sub    %eax,%ebx
  800634:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800637:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	01 c8                	add    %ecx,%eax
  800643:	8b 08                	mov    (%eax),%ecx
  800645:	8b 45 10             	mov    0x10(%ebp),%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	29 c1                	sub    %eax,%ecx
  80064c:	89 c8                	mov    %ecx,%eax
  80064e:	0f af c3             	imul   %ebx,%eax
  800651:	01 c2                	add    %eax,%edx
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	89 10                	mov    %edx,(%eax)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  800658:	ff 45 f8             	incl   -0x8(%ebp)
  80065b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80065e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800661:	7c b2                	jl     800615 <ArrayStats+0x63>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
	}
	*var /= NumOfElements;
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8b 00                	mov    (%eax),%eax
  800668:	99                   	cltd   
  800669:	f7 7d 0c             	idivl  0xc(%ebp)
  80066c:	89 c2                	mov    %eax,%edx
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	89 10                	mov    %edx,(%eax)
}
  800673:	90                   	nop
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	5b                   	pop    %ebx
  800678:	5d                   	pop    %ebp
  800679:	c3                   	ret    

0080067a <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
  80067d:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800680:	8b 45 08             	mov    0x8(%ebp),%eax
  800683:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800686:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80068a:	83 ec 0c             	sub    $0xc,%esp
  80068d:	50                   	push   %eax
  80068e:	e8 16 17 00 00       	call   801da9 <sys_cputc>
  800693:	83 c4 10             	add    $0x10,%esp
}
  800696:	90                   	nop
  800697:	c9                   	leave  
  800698:	c3                   	ret    

00800699 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800699:	55                   	push   %ebp
  80069a:	89 e5                	mov    %esp,%ebp
  80069c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80069f:	e8 d1 16 00 00       	call   801d75 <sys_disable_interrupt>
	char c = ch;
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006aa:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	50                   	push   %eax
  8006b2:	e8 f2 16 00 00       	call   801da9 <sys_cputc>
  8006b7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ba:	e8 d0 16 00 00       	call   801d8f <sys_enable_interrupt>
}
  8006bf:	90                   	nop
  8006c0:	c9                   	leave  
  8006c1:	c3                   	ret    

008006c2 <getchar>:

int
getchar(void)
{
  8006c2:	55                   	push   %ebp
  8006c3:	89 e5                	mov    %esp,%ebp
  8006c5:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8006c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8006cf:	eb 08                	jmp    8006d9 <getchar+0x17>
	{
		c = sys_cgetc();
  8006d1:	e8 b7 14 00 00       	call   801b8d <sys_cgetc>
  8006d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8006d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8006dd:	74 f2                	je     8006d1 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8006df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8006e2:	c9                   	leave  
  8006e3:	c3                   	ret    

008006e4 <atomic_getchar>:

int
atomic_getchar(void)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
  8006e7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006ea:	e8 86 16 00 00       	call   801d75 <sys_disable_interrupt>
	int c=0;
  8006ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8006f6:	eb 08                	jmp    800700 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8006f8:	e8 90 14 00 00       	call   801b8d <sys_cgetc>
  8006fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800700:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800704:	74 f2                	je     8006f8 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800706:	e8 84 16 00 00       	call   801d8f <sys_enable_interrupt>
	return c;
  80070b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <iscons>:

int iscons(int fdnum)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800713:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800718:	5d                   	pop    %ebp
  800719:	c3                   	ret    

0080071a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800720:	e8 b5 14 00 00       	call   801bda <sys_getenvindex>
  800725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800728:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072b:	89 d0                	mov    %edx,%eax
  80072d:	c1 e0 03             	shl    $0x3,%eax
  800730:	01 d0                	add    %edx,%eax
  800732:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800739:	01 c8                	add    %ecx,%eax
  80073b:	01 c0                	add    %eax,%eax
  80073d:	01 d0                	add    %edx,%eax
  80073f:	01 c0                	add    %eax,%eax
  800741:	01 d0                	add    %edx,%eax
  800743:	89 c2                	mov    %eax,%edx
  800745:	c1 e2 05             	shl    $0x5,%edx
  800748:	29 c2                	sub    %eax,%edx
  80074a:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800751:	89 c2                	mov    %eax,%edx
  800753:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800759:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80075e:	a1 20 30 80 00       	mov    0x803020,%eax
  800763:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800769:	84 c0                	test   %al,%al
  80076b:	74 0f                	je     80077c <libmain+0x62>
		binaryname = myEnv->prog_name;
  80076d:	a1 20 30 80 00       	mov    0x803020,%eax
  800772:	05 40 3c 01 00       	add    $0x13c40,%eax
  800777:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80077c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800780:	7e 0a                	jle    80078c <libmain+0x72>
		binaryname = argv[0];
  800782:	8b 45 0c             	mov    0xc(%ebp),%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80078c:	83 ec 08             	sub    $0x8,%esp
  80078f:	ff 75 0c             	pushl  0xc(%ebp)
  800792:	ff 75 08             	pushl  0x8(%ebp)
  800795:	e8 9e f8 ff ff       	call   800038 <_main>
  80079a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80079d:	e8 d3 15 00 00       	call   801d75 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007a2:	83 ec 0c             	sub    $0xc,%esp
  8007a5:	68 40 26 80 00       	push   $0x802640
  8007aa:	e8 52 03 00 00       	call   800b01 <cprintf>
  8007af:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8007b7:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8007bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8007c2:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8007c8:	83 ec 04             	sub    $0x4,%esp
  8007cb:	52                   	push   %edx
  8007cc:	50                   	push   %eax
  8007cd:	68 68 26 80 00       	push   $0x802668
  8007d2:	e8 2a 03 00 00       	call   800b01 <cprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8007da:	a1 20 30 80 00       	mov    0x803020,%eax
  8007df:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8007e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8007ea:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8007f0:	83 ec 04             	sub    $0x4,%esp
  8007f3:	52                   	push   %edx
  8007f4:	50                   	push   %eax
  8007f5:	68 90 26 80 00       	push   $0x802690
  8007fa:	e8 02 03 00 00       	call   800b01 <cprintf>
  8007ff:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800802:	a1 20 30 80 00       	mov    0x803020,%eax
  800807:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	50                   	push   %eax
  800811:	68 d1 26 80 00       	push   $0x8026d1
  800816:	e8 e6 02 00 00       	call   800b01 <cprintf>
  80081b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80081e:	83 ec 0c             	sub    $0xc,%esp
  800821:	68 40 26 80 00       	push   $0x802640
  800826:	e8 d6 02 00 00       	call   800b01 <cprintf>
  80082b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80082e:	e8 5c 15 00 00       	call   801d8f <sys_enable_interrupt>

	// exit gracefully
	exit();
  800833:	e8 19 00 00 00       	call   800851 <exit>
}
  800838:	90                   	nop
  800839:	c9                   	leave  
  80083a:	c3                   	ret    

0080083b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800841:	83 ec 0c             	sub    $0xc,%esp
  800844:	6a 00                	push   $0x0
  800846:	e8 5b 13 00 00       	call   801ba6 <sys_env_destroy>
  80084b:	83 c4 10             	add    $0x10,%esp
}
  80084e:	90                   	nop
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <exit>:

void
exit(void)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800857:	e8 b0 13 00 00       	call   801c0c <sys_env_exit>
}
  80085c:	90                   	nop
  80085d:	c9                   	leave  
  80085e:	c3                   	ret    

0080085f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800865:	8d 45 10             	lea    0x10(%ebp),%eax
  800868:	83 c0 04             	add    $0x4,%eax
  80086b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80086e:	a1 18 31 80 00       	mov    0x803118,%eax
  800873:	85 c0                	test   %eax,%eax
  800875:	74 16                	je     80088d <_panic+0x2e>
		cprintf("%s: ", argv0);
  800877:	a1 18 31 80 00       	mov    0x803118,%eax
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	50                   	push   %eax
  800880:	68 e8 26 80 00       	push   $0x8026e8
  800885:	e8 77 02 00 00       	call   800b01 <cprintf>
  80088a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80088d:	a1 00 30 80 00       	mov    0x803000,%eax
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	ff 75 08             	pushl  0x8(%ebp)
  800898:	50                   	push   %eax
  800899:	68 ed 26 80 00       	push   $0x8026ed
  80089e:	e8 5e 02 00 00       	call   800b01 <cprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8008af:	50                   	push   %eax
  8008b0:	e8 e1 01 00 00       	call   800a96 <vcprintf>
  8008b5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	6a 00                	push   $0x0
  8008bd:	68 09 27 80 00       	push   $0x802709
  8008c2:	e8 cf 01 00 00       	call   800a96 <vcprintf>
  8008c7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008ca:	e8 82 ff ff ff       	call   800851 <exit>

	// should not return here
	while (1) ;
  8008cf:	eb fe                	jmp    8008cf <_panic+0x70>

008008d1 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8008dc:	8b 50 74             	mov    0x74(%eax),%edx
  8008df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e2:	39 c2                	cmp    %eax,%edx
  8008e4:	74 14                	je     8008fa <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008e6:	83 ec 04             	sub    $0x4,%esp
  8008e9:	68 0c 27 80 00       	push   $0x80270c
  8008ee:	6a 26                	push   $0x26
  8008f0:	68 58 27 80 00       	push   $0x802758
  8008f5:	e8 65 ff ff ff       	call   80085f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800901:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800908:	e9 b6 00 00 00       	jmp    8009c3 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80090d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800910:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	01 d0                	add    %edx,%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	85 c0                	test   %eax,%eax
  800920:	75 08                	jne    80092a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800922:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800925:	e9 96 00 00 00       	jmp    8009c0 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80092a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800931:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800938:	eb 5d                	jmp    800997 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80093a:	a1 20 30 80 00       	mov    0x803020,%eax
  80093f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800945:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800948:	c1 e2 04             	shl    $0x4,%edx
  80094b:	01 d0                	add    %edx,%eax
  80094d:	8a 40 04             	mov    0x4(%eax),%al
  800950:	84 c0                	test   %al,%al
  800952:	75 40                	jne    800994 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800954:	a1 20 30 80 00       	mov    0x803020,%eax
  800959:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80095f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800962:	c1 e2 04             	shl    $0x4,%edx
  800965:	01 d0                	add    %edx,%eax
  800967:	8b 00                	mov    (%eax),%eax
  800969:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80096c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80096f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800974:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800976:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800979:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	01 c8                	add    %ecx,%eax
  800985:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800987:	39 c2                	cmp    %eax,%edx
  800989:	75 09                	jne    800994 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  80098b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800992:	eb 12                	jmp    8009a6 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800994:	ff 45 e8             	incl   -0x18(%ebp)
  800997:	a1 20 30 80 00       	mov    0x803020,%eax
  80099c:	8b 50 74             	mov    0x74(%eax),%edx
  80099f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009a2:	39 c2                	cmp    %eax,%edx
  8009a4:	77 94                	ja     80093a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009aa:	75 14                	jne    8009c0 <CheckWSWithoutLastIndex+0xef>
			panic(
  8009ac:	83 ec 04             	sub    $0x4,%esp
  8009af:	68 64 27 80 00       	push   $0x802764
  8009b4:	6a 3a                	push   $0x3a
  8009b6:	68 58 27 80 00       	push   $0x802758
  8009bb:	e8 9f fe ff ff       	call   80085f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009c0:	ff 45 f0             	incl   -0x10(%ebp)
  8009c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009c9:	0f 8c 3e ff ff ff    	jl     80090d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009cf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009dd:	eb 20                	jmp    8009ff <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009df:	a1 20 30 80 00       	mov    0x803020,%eax
  8009e4:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8009ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009ed:	c1 e2 04             	shl    $0x4,%edx
  8009f0:	01 d0                	add    %edx,%eax
  8009f2:	8a 40 04             	mov    0x4(%eax),%al
  8009f5:	3c 01                	cmp    $0x1,%al
  8009f7:	75 03                	jne    8009fc <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8009f9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009fc:	ff 45 e0             	incl   -0x20(%ebp)
  8009ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800a04:	8b 50 74             	mov    0x74(%eax),%edx
  800a07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0a:	39 c2                	cmp    %eax,%edx
  800a0c:	77 d1                	ja     8009df <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a11:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a14:	74 14                	je     800a2a <CheckWSWithoutLastIndex+0x159>
		panic(
  800a16:	83 ec 04             	sub    $0x4,%esp
  800a19:	68 b8 27 80 00       	push   $0x8027b8
  800a1e:	6a 44                	push   $0x44
  800a20:	68 58 27 80 00       	push   $0x802758
  800a25:	e8 35 fe ff ff       	call   80085f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a2a:	90                   	nop
  800a2b:	c9                   	leave  
  800a2c:	c3                   	ret    

00800a2d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a36:	8b 00                	mov    (%eax),%eax
  800a38:	8d 48 01             	lea    0x1(%eax),%ecx
  800a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3e:	89 0a                	mov    %ecx,(%edx)
  800a40:	8b 55 08             	mov    0x8(%ebp),%edx
  800a43:	88 d1                	mov    %dl,%cl
  800a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a48:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4f:	8b 00                	mov    (%eax),%eax
  800a51:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a56:	75 2c                	jne    800a84 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a58:	a0 24 30 80 00       	mov    0x803024,%al
  800a5d:	0f b6 c0             	movzbl %al,%eax
  800a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a63:	8b 12                	mov    (%edx),%edx
  800a65:	89 d1                	mov    %edx,%ecx
  800a67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6a:	83 c2 08             	add    $0x8,%edx
  800a6d:	83 ec 04             	sub    $0x4,%esp
  800a70:	50                   	push   %eax
  800a71:	51                   	push   %ecx
  800a72:	52                   	push   %edx
  800a73:	e8 ec 10 00 00       	call   801b64 <sys_cputs>
  800a78:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a87:	8b 40 04             	mov    0x4(%eax),%eax
  800a8a:	8d 50 01             	lea    0x1(%eax),%edx
  800a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a90:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a93:	90                   	nop
  800a94:	c9                   	leave  
  800a95:	c3                   	ret    

00800a96 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a9f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800aa6:	00 00 00 
	b.cnt = 0;
  800aa9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ab0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	ff 75 08             	pushl  0x8(%ebp)
  800ab9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800abf:	50                   	push   %eax
  800ac0:	68 2d 0a 80 00       	push   $0x800a2d
  800ac5:	e8 11 02 00 00       	call   800cdb <vprintfmt>
  800aca:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800acd:	a0 24 30 80 00       	mov    0x803024,%al
  800ad2:	0f b6 c0             	movzbl %al,%eax
  800ad5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800adb:	83 ec 04             	sub    $0x4,%esp
  800ade:	50                   	push   %eax
  800adf:	52                   	push   %edx
  800ae0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ae6:	83 c0 08             	add    $0x8,%eax
  800ae9:	50                   	push   %eax
  800aea:	e8 75 10 00 00       	call   801b64 <sys_cputs>
  800aef:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800af2:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800af9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800aff:	c9                   	leave  
  800b00:	c3                   	ret    

00800b01 <cprintf>:

int cprintf(const char *fmt, ...) {
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b07:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800b0e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1d:	50                   	push   %eax
  800b1e:	e8 73 ff ff ff       	call   800a96 <vcprintf>
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b2c:	c9                   	leave  
  800b2d:	c3                   	ret    

00800b2e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b34:	e8 3c 12 00 00       	call   801d75 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b39:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	83 ec 08             	sub    $0x8,%esp
  800b45:	ff 75 f4             	pushl  -0xc(%ebp)
  800b48:	50                   	push   %eax
  800b49:	e8 48 ff ff ff       	call   800a96 <vcprintf>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800b54:	e8 36 12 00 00       	call   801d8f <sys_enable_interrupt>
	return cnt;
  800b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b5c:	c9                   	leave  
  800b5d:	c3                   	ret    

00800b5e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b5e:	55                   	push   %ebp
  800b5f:	89 e5                	mov    %esp,%ebp
  800b61:	53                   	push   %ebx
  800b62:	83 ec 14             	sub    $0x14,%esp
  800b65:	8b 45 10             	mov    0x10(%ebp),%eax
  800b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b71:	8b 45 18             	mov    0x18(%ebp),%eax
  800b74:	ba 00 00 00 00       	mov    $0x0,%edx
  800b79:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b7c:	77 55                	ja     800bd3 <printnum+0x75>
  800b7e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b81:	72 05                	jb     800b88 <printnum+0x2a>
  800b83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b86:	77 4b                	ja     800bd3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b88:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b8b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b8e:	8b 45 18             	mov    0x18(%ebp),%eax
  800b91:	ba 00 00 00 00       	mov    $0x0,%edx
  800b96:	52                   	push   %edx
  800b97:	50                   	push   %eax
  800b98:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9b:	ff 75 f0             	pushl  -0x10(%ebp)
  800b9e:	e8 f5 15 00 00       	call   802198 <__udivdi3>
  800ba3:	83 c4 10             	add    $0x10,%esp
  800ba6:	83 ec 04             	sub    $0x4,%esp
  800ba9:	ff 75 20             	pushl  0x20(%ebp)
  800bac:	53                   	push   %ebx
  800bad:	ff 75 18             	pushl  0x18(%ebp)
  800bb0:	52                   	push   %edx
  800bb1:	50                   	push   %eax
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	ff 75 08             	pushl  0x8(%ebp)
  800bb8:	e8 a1 ff ff ff       	call   800b5e <printnum>
  800bbd:	83 c4 20             	add    $0x20,%esp
  800bc0:	eb 1a                	jmp    800bdc <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bc2:	83 ec 08             	sub    $0x8,%esp
  800bc5:	ff 75 0c             	pushl  0xc(%ebp)
  800bc8:	ff 75 20             	pushl  0x20(%ebp)
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	ff d0                	call   *%eax
  800bd0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bd3:	ff 4d 1c             	decl   0x1c(%ebp)
  800bd6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bda:	7f e6                	jg     800bc2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bdc:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bdf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bea:	53                   	push   %ebx
  800beb:	51                   	push   %ecx
  800bec:	52                   	push   %edx
  800bed:	50                   	push   %eax
  800bee:	e8 b5 16 00 00       	call   8022a8 <__umoddi3>
  800bf3:	83 c4 10             	add    $0x10,%esp
  800bf6:	05 34 2a 80 00       	add    $0x802a34,%eax
  800bfb:	8a 00                	mov    (%eax),%al
  800bfd:	0f be c0             	movsbl %al,%eax
  800c00:	83 ec 08             	sub    $0x8,%esp
  800c03:	ff 75 0c             	pushl  0xc(%ebp)
  800c06:	50                   	push   %eax
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	ff d0                	call   *%eax
  800c0c:	83 c4 10             	add    $0x10,%esp
}
  800c0f:	90                   	nop
  800c10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c13:	c9                   	leave  
  800c14:	c3                   	ret    

00800c15 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c18:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c1c:	7e 1c                	jle    800c3a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	8d 50 08             	lea    0x8(%eax),%edx
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	89 10                	mov    %edx,(%eax)
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	8b 00                	mov    (%eax),%eax
  800c30:	83 e8 08             	sub    $0x8,%eax
  800c33:	8b 50 04             	mov    0x4(%eax),%edx
  800c36:	8b 00                	mov    (%eax),%eax
  800c38:	eb 40                	jmp    800c7a <getuint+0x65>
	else if (lflag)
  800c3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3e:	74 1e                	je     800c5e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	8b 00                	mov    (%eax),%eax
  800c45:	8d 50 04             	lea    0x4(%eax),%edx
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 10                	mov    %edx,(%eax)
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	8b 00                	mov    (%eax),%eax
  800c52:	83 e8 04             	sub    $0x4,%eax
  800c55:	8b 00                	mov    (%eax),%eax
  800c57:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5c:	eb 1c                	jmp    800c7a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8b 00                	mov    (%eax),%eax
  800c63:	8d 50 04             	lea    0x4(%eax),%edx
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	89 10                	mov    %edx,(%eax)
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8b 00                	mov    (%eax),%eax
  800c70:	83 e8 04             	sub    $0x4,%eax
  800c73:	8b 00                	mov    (%eax),%eax
  800c75:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c7a:	5d                   	pop    %ebp
  800c7b:	c3                   	ret    

00800c7c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c7f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c83:	7e 1c                	jle    800ca1 <getint+0x25>
		return va_arg(*ap, long long);
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8b 00                	mov    (%eax),%eax
  800c8a:	8d 50 08             	lea    0x8(%eax),%edx
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	89 10                	mov    %edx,(%eax)
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	8b 00                	mov    (%eax),%eax
  800c97:	83 e8 08             	sub    $0x8,%eax
  800c9a:	8b 50 04             	mov    0x4(%eax),%edx
  800c9d:	8b 00                	mov    (%eax),%eax
  800c9f:	eb 38                	jmp    800cd9 <getint+0x5d>
	else if (lflag)
  800ca1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca5:	74 1a                	je     800cc1 <getint+0x45>
		return va_arg(*ap, long);
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8b 00                	mov    (%eax),%eax
  800cac:	8d 50 04             	lea    0x4(%eax),%edx
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	89 10                	mov    %edx,(%eax)
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	8b 00                	mov    (%eax),%eax
  800cb9:	83 e8 04             	sub    $0x4,%eax
  800cbc:	8b 00                	mov    (%eax),%eax
  800cbe:	99                   	cltd   
  800cbf:	eb 18                	jmp    800cd9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	8b 00                	mov    (%eax),%eax
  800cc6:	8d 50 04             	lea    0x4(%eax),%edx
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	89 10                	mov    %edx,(%eax)
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8b 00                	mov    (%eax),%eax
  800cd3:	83 e8 04             	sub    $0x4,%eax
  800cd6:	8b 00                	mov    (%eax),%eax
  800cd8:	99                   	cltd   
}
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	56                   	push   %esi
  800cdf:	53                   	push   %ebx
  800ce0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ce3:	eb 17                	jmp    800cfc <vprintfmt+0x21>
			if (ch == '\0')
  800ce5:	85 db                	test   %ebx,%ebx
  800ce7:	0f 84 af 03 00 00    	je     80109c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ced:	83 ec 08             	sub    $0x8,%esp
  800cf0:	ff 75 0c             	pushl  0xc(%ebp)
  800cf3:	53                   	push   %ebx
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	ff d0                	call   *%eax
  800cf9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cff:	8d 50 01             	lea    0x1(%eax),%edx
  800d02:	89 55 10             	mov    %edx,0x10(%ebp)
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	0f b6 d8             	movzbl %al,%ebx
  800d0a:	83 fb 25             	cmp    $0x25,%ebx
  800d0d:	75 d6                	jne    800ce5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d0f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d13:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d1a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d21:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d28:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	8d 50 01             	lea    0x1(%eax),%edx
  800d35:	89 55 10             	mov    %edx,0x10(%ebp)
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	0f b6 d8             	movzbl %al,%ebx
  800d3d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d40:	83 f8 55             	cmp    $0x55,%eax
  800d43:	0f 87 2b 03 00 00    	ja     801074 <vprintfmt+0x399>
  800d49:	8b 04 85 58 2a 80 00 	mov    0x802a58(,%eax,4),%eax
  800d50:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d52:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d56:	eb d7                	jmp    800d2f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d58:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d5c:	eb d1                	jmp    800d2f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d65:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d68:	89 d0                	mov    %edx,%eax
  800d6a:	c1 e0 02             	shl    $0x2,%eax
  800d6d:	01 d0                	add    %edx,%eax
  800d6f:	01 c0                	add    %eax,%eax
  800d71:	01 d8                	add    %ebx,%eax
  800d73:	83 e8 30             	sub    $0x30,%eax
  800d76:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d79:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d81:	83 fb 2f             	cmp    $0x2f,%ebx
  800d84:	7e 3e                	jle    800dc4 <vprintfmt+0xe9>
  800d86:	83 fb 39             	cmp    $0x39,%ebx
  800d89:	7f 39                	jg     800dc4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d8b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d8e:	eb d5                	jmp    800d65 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d90:	8b 45 14             	mov    0x14(%ebp),%eax
  800d93:	83 c0 04             	add    $0x4,%eax
  800d96:	89 45 14             	mov    %eax,0x14(%ebp)
  800d99:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9c:	83 e8 04             	sub    $0x4,%eax
  800d9f:	8b 00                	mov    (%eax),%eax
  800da1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800da4:	eb 1f                	jmp    800dc5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800da6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800daa:	79 83                	jns    800d2f <vprintfmt+0x54>
				width = 0;
  800dac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800db3:	e9 77 ff ff ff       	jmp    800d2f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800db8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800dbf:	e9 6b ff ff ff       	jmp    800d2f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800dc4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800dc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc9:	0f 89 60 ff ff ff    	jns    800d2f <vprintfmt+0x54>
				width = precision, precision = -1;
  800dcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dd5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ddc:	e9 4e ff ff ff       	jmp    800d2f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800de1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800de4:	e9 46 ff ff ff       	jmp    800d2f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800de9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dec:	83 c0 04             	add    $0x4,%eax
  800def:	89 45 14             	mov    %eax,0x14(%ebp)
  800df2:	8b 45 14             	mov    0x14(%ebp),%eax
  800df5:	83 e8 04             	sub    $0x4,%eax
  800df8:	8b 00                	mov    (%eax),%eax
  800dfa:	83 ec 08             	sub    $0x8,%esp
  800dfd:	ff 75 0c             	pushl  0xc(%ebp)
  800e00:	50                   	push   %eax
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	ff d0                	call   *%eax
  800e06:	83 c4 10             	add    $0x10,%esp
			break;
  800e09:	e9 89 02 00 00       	jmp    801097 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e11:	83 c0 04             	add    $0x4,%eax
  800e14:	89 45 14             	mov    %eax,0x14(%ebp)
  800e17:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1a:	83 e8 04             	sub    $0x4,%eax
  800e1d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e1f:	85 db                	test   %ebx,%ebx
  800e21:	79 02                	jns    800e25 <vprintfmt+0x14a>
				err = -err;
  800e23:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e25:	83 fb 64             	cmp    $0x64,%ebx
  800e28:	7f 0b                	jg     800e35 <vprintfmt+0x15a>
  800e2a:	8b 34 9d a0 28 80 00 	mov    0x8028a0(,%ebx,4),%esi
  800e31:	85 f6                	test   %esi,%esi
  800e33:	75 19                	jne    800e4e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e35:	53                   	push   %ebx
  800e36:	68 45 2a 80 00       	push   $0x802a45
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	ff 75 08             	pushl  0x8(%ebp)
  800e41:	e8 5e 02 00 00       	call   8010a4 <printfmt>
  800e46:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e49:	e9 49 02 00 00       	jmp    801097 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e4e:	56                   	push   %esi
  800e4f:	68 4e 2a 80 00       	push   $0x802a4e
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	ff 75 08             	pushl  0x8(%ebp)
  800e5a:	e8 45 02 00 00       	call   8010a4 <printfmt>
  800e5f:	83 c4 10             	add    $0x10,%esp
			break;
  800e62:	e9 30 02 00 00       	jmp    801097 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	83 c0 04             	add    $0x4,%eax
  800e6d:	89 45 14             	mov    %eax,0x14(%ebp)
  800e70:	8b 45 14             	mov    0x14(%ebp),%eax
  800e73:	83 e8 04             	sub    $0x4,%eax
  800e76:	8b 30                	mov    (%eax),%esi
  800e78:	85 f6                	test   %esi,%esi
  800e7a:	75 05                	jne    800e81 <vprintfmt+0x1a6>
				p = "(null)";
  800e7c:	be 51 2a 80 00       	mov    $0x802a51,%esi
			if (width > 0 && padc != '-')
  800e81:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e85:	7e 6d                	jle    800ef4 <vprintfmt+0x219>
  800e87:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e8b:	74 67                	je     800ef4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e90:	83 ec 08             	sub    $0x8,%esp
  800e93:	50                   	push   %eax
  800e94:	56                   	push   %esi
  800e95:	e8 12 05 00 00       	call   8013ac <strnlen>
  800e9a:	83 c4 10             	add    $0x10,%esp
  800e9d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ea0:	eb 16                	jmp    800eb8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ea2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ea6:	83 ec 08             	sub    $0x8,%esp
  800ea9:	ff 75 0c             	pushl  0xc(%ebp)
  800eac:	50                   	push   %eax
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	ff d0                	call   *%eax
  800eb2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eb5:	ff 4d e4             	decl   -0x1c(%ebp)
  800eb8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ebc:	7f e4                	jg     800ea2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ebe:	eb 34                	jmp    800ef4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ec0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ec4:	74 1c                	je     800ee2 <vprintfmt+0x207>
  800ec6:	83 fb 1f             	cmp    $0x1f,%ebx
  800ec9:	7e 05                	jle    800ed0 <vprintfmt+0x1f5>
  800ecb:	83 fb 7e             	cmp    $0x7e,%ebx
  800ece:	7e 12                	jle    800ee2 <vprintfmt+0x207>
					putch('?', putdat);
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	ff 75 0c             	pushl  0xc(%ebp)
  800ed6:	6a 3f                	push   $0x3f
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	ff d0                	call   *%eax
  800edd:	83 c4 10             	add    $0x10,%esp
  800ee0:	eb 0f                	jmp    800ef1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ee2:	83 ec 08             	sub    $0x8,%esp
  800ee5:	ff 75 0c             	pushl  0xc(%ebp)
  800ee8:	53                   	push   %ebx
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	ff d0                	call   *%eax
  800eee:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ef1:	ff 4d e4             	decl   -0x1c(%ebp)
  800ef4:	89 f0                	mov    %esi,%eax
  800ef6:	8d 70 01             	lea    0x1(%eax),%esi
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	0f be d8             	movsbl %al,%ebx
  800efe:	85 db                	test   %ebx,%ebx
  800f00:	74 24                	je     800f26 <vprintfmt+0x24b>
  800f02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f06:	78 b8                	js     800ec0 <vprintfmt+0x1e5>
  800f08:	ff 4d e0             	decl   -0x20(%ebp)
  800f0b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f0f:	79 af                	jns    800ec0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f11:	eb 13                	jmp    800f26 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f13:	83 ec 08             	sub    $0x8,%esp
  800f16:	ff 75 0c             	pushl  0xc(%ebp)
  800f19:	6a 20                	push   $0x20
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	ff d0                	call   *%eax
  800f20:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f23:	ff 4d e4             	decl   -0x1c(%ebp)
  800f26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f2a:	7f e7                	jg     800f13 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f2c:	e9 66 01 00 00       	jmp    801097 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f31:	83 ec 08             	sub    $0x8,%esp
  800f34:	ff 75 e8             	pushl  -0x18(%ebp)
  800f37:	8d 45 14             	lea    0x14(%ebp),%eax
  800f3a:	50                   	push   %eax
  800f3b:	e8 3c fd ff ff       	call   800c7c <getint>
  800f40:	83 c4 10             	add    $0x10,%esp
  800f43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f4f:	85 d2                	test   %edx,%edx
  800f51:	79 23                	jns    800f76 <vprintfmt+0x29b>
				putch('-', putdat);
  800f53:	83 ec 08             	sub    $0x8,%esp
  800f56:	ff 75 0c             	pushl  0xc(%ebp)
  800f59:	6a 2d                	push   $0x2d
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	ff d0                	call   *%eax
  800f60:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f69:	f7 d8                	neg    %eax
  800f6b:	83 d2 00             	adc    $0x0,%edx
  800f6e:	f7 da                	neg    %edx
  800f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f73:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f76:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f7d:	e9 bc 00 00 00       	jmp    80103e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f82:	83 ec 08             	sub    $0x8,%esp
  800f85:	ff 75 e8             	pushl  -0x18(%ebp)
  800f88:	8d 45 14             	lea    0x14(%ebp),%eax
  800f8b:	50                   	push   %eax
  800f8c:	e8 84 fc ff ff       	call   800c15 <getuint>
  800f91:	83 c4 10             	add    $0x10,%esp
  800f94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f97:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f9a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fa1:	e9 98 00 00 00       	jmp    80103e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fa6:	83 ec 08             	sub    $0x8,%esp
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	6a 58                	push   $0x58
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	ff d0                	call   *%eax
  800fb3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fb6:	83 ec 08             	sub    $0x8,%esp
  800fb9:	ff 75 0c             	pushl  0xc(%ebp)
  800fbc:	6a 58                	push   $0x58
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	ff d0                	call   *%eax
  800fc3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fc6:	83 ec 08             	sub    $0x8,%esp
  800fc9:	ff 75 0c             	pushl  0xc(%ebp)
  800fcc:	6a 58                	push   $0x58
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	ff d0                	call   *%eax
  800fd3:	83 c4 10             	add    $0x10,%esp
			break;
  800fd6:	e9 bc 00 00 00       	jmp    801097 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800fdb:	83 ec 08             	sub    $0x8,%esp
  800fde:	ff 75 0c             	pushl  0xc(%ebp)
  800fe1:	6a 30                	push   $0x30
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	ff d0                	call   *%eax
  800fe8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800feb:	83 ec 08             	sub    $0x8,%esp
  800fee:	ff 75 0c             	pushl  0xc(%ebp)
  800ff1:	6a 78                	push   $0x78
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	ff d0                	call   *%eax
  800ff8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ffb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffe:	83 c0 04             	add    $0x4,%eax
  801001:	89 45 14             	mov    %eax,0x14(%ebp)
  801004:	8b 45 14             	mov    0x14(%ebp),%eax
  801007:	83 e8 04             	sub    $0x4,%eax
  80100a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80100c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80100f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801016:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80101d:	eb 1f                	jmp    80103e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80101f:	83 ec 08             	sub    $0x8,%esp
  801022:	ff 75 e8             	pushl  -0x18(%ebp)
  801025:	8d 45 14             	lea    0x14(%ebp),%eax
  801028:	50                   	push   %eax
  801029:	e8 e7 fb ff ff       	call   800c15 <getuint>
  80102e:	83 c4 10             	add    $0x10,%esp
  801031:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801034:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801037:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80103e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801042:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801045:	83 ec 04             	sub    $0x4,%esp
  801048:	52                   	push   %edx
  801049:	ff 75 e4             	pushl  -0x1c(%ebp)
  80104c:	50                   	push   %eax
  80104d:	ff 75 f4             	pushl  -0xc(%ebp)
  801050:	ff 75 f0             	pushl  -0x10(%ebp)
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	ff 75 08             	pushl  0x8(%ebp)
  801059:	e8 00 fb ff ff       	call   800b5e <printnum>
  80105e:	83 c4 20             	add    $0x20,%esp
			break;
  801061:	eb 34                	jmp    801097 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801063:	83 ec 08             	sub    $0x8,%esp
  801066:	ff 75 0c             	pushl  0xc(%ebp)
  801069:	53                   	push   %ebx
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	ff d0                	call   *%eax
  80106f:	83 c4 10             	add    $0x10,%esp
			break;
  801072:	eb 23                	jmp    801097 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801074:	83 ec 08             	sub    $0x8,%esp
  801077:	ff 75 0c             	pushl  0xc(%ebp)
  80107a:	6a 25                	push   $0x25
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	ff d0                	call   *%eax
  801081:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801084:	ff 4d 10             	decl   0x10(%ebp)
  801087:	eb 03                	jmp    80108c <vprintfmt+0x3b1>
  801089:	ff 4d 10             	decl   0x10(%ebp)
  80108c:	8b 45 10             	mov    0x10(%ebp),%eax
  80108f:	48                   	dec    %eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	3c 25                	cmp    $0x25,%al
  801094:	75 f3                	jne    801089 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801096:	90                   	nop
		}
	}
  801097:	e9 47 fc ff ff       	jmp    800ce3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80109c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80109d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5d                   	pop    %ebp
  8010a3:	c3                   	ret    

008010a4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010aa:	8d 45 10             	lea    0x10(%ebp),%eax
  8010ad:	83 c0 04             	add    $0x4,%eax
  8010b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b9:	50                   	push   %eax
  8010ba:	ff 75 0c             	pushl  0xc(%ebp)
  8010bd:	ff 75 08             	pushl  0x8(%ebp)
  8010c0:	e8 16 fc ff ff       	call   800cdb <vprintfmt>
  8010c5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010c8:	90                   	nop
  8010c9:	c9                   	leave  
  8010ca:	c3                   	ret    

008010cb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	8b 40 08             	mov    0x8(%eax),%eax
  8010d4:	8d 50 01             	lea    0x1(%eax),%edx
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	8b 10                	mov    (%eax),%edx
  8010e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e5:	8b 40 04             	mov    0x4(%eax),%eax
  8010e8:	39 c2                	cmp    %eax,%edx
  8010ea:	73 12                	jae    8010fe <sprintputch+0x33>
		*b->buf++ = ch;
  8010ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ef:	8b 00                	mov    (%eax),%eax
  8010f1:	8d 48 01             	lea    0x1(%eax),%ecx
  8010f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f7:	89 0a                	mov    %ecx,(%edx)
  8010f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fc:	88 10                	mov    %dl,(%eax)
}
  8010fe:	90                   	nop
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    

00801101 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80110d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801110:	8d 50 ff             	lea    -0x1(%eax),%edx
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	01 d0                	add    %edx,%eax
  801118:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80111b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801122:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801126:	74 06                	je     80112e <vsnprintf+0x2d>
  801128:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112c:	7f 07                	jg     801135 <vsnprintf+0x34>
		return -E_INVAL;
  80112e:	b8 03 00 00 00       	mov    $0x3,%eax
  801133:	eb 20                	jmp    801155 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801135:	ff 75 14             	pushl  0x14(%ebp)
  801138:	ff 75 10             	pushl  0x10(%ebp)
  80113b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80113e:	50                   	push   %eax
  80113f:	68 cb 10 80 00       	push   $0x8010cb
  801144:	e8 92 fb ff ff       	call   800cdb <vprintfmt>
  801149:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80114c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80114f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801152:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80115d:	8d 45 10             	lea    0x10(%ebp),%eax
  801160:	83 c0 04             	add    $0x4,%eax
  801163:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	ff 75 f4             	pushl  -0xc(%ebp)
  80116c:	50                   	push   %eax
  80116d:	ff 75 0c             	pushl  0xc(%ebp)
  801170:	ff 75 08             	pushl  0x8(%ebp)
  801173:	e8 89 ff ff ff       	call   801101 <vsnprintf>
  801178:	83 c4 10             	add    $0x10,%esp
  80117b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80117e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801181:	c9                   	leave  
  801182:	c3                   	ret    

00801183 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801189:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80118d:	74 13                	je     8011a2 <readline+0x1f>
		cprintf("%s", prompt);
  80118f:	83 ec 08             	sub    $0x8,%esp
  801192:	ff 75 08             	pushl  0x8(%ebp)
  801195:	68 b0 2b 80 00       	push   $0x802bb0
  80119a:	e8 62 f9 ff ff       	call   800b01 <cprintf>
  80119f:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011a9:	83 ec 0c             	sub    $0xc,%esp
  8011ac:	6a 00                	push   $0x0
  8011ae:	e8 5d f5 ff ff       	call   800710 <iscons>
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011b9:	e8 04 f5 ff ff       	call   8006c2 <getchar>
  8011be:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011c5:	79 22                	jns    8011e9 <readline+0x66>
			if (c != -E_EOF)
  8011c7:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011cb:	0f 84 ad 00 00 00    	je     80127e <readline+0xfb>
				cprintf("read error: %e\n", c);
  8011d1:	83 ec 08             	sub    $0x8,%esp
  8011d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8011d7:	68 b3 2b 80 00       	push   $0x802bb3
  8011dc:	e8 20 f9 ff ff       	call   800b01 <cprintf>
  8011e1:	83 c4 10             	add    $0x10,%esp
			return;
  8011e4:	e9 95 00 00 00       	jmp    80127e <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011e9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011ed:	7e 34                	jle    801223 <readline+0xa0>
  8011ef:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011f6:	7f 2b                	jg     801223 <readline+0xa0>
			if (echoing)
  8011f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011fc:	74 0e                	je     80120c <readline+0x89>
				cputchar(c);
  8011fe:	83 ec 0c             	sub    $0xc,%esp
  801201:	ff 75 ec             	pushl  -0x14(%ebp)
  801204:	e8 71 f4 ff ff       	call   80067a <cputchar>
  801209:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80120c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80120f:	8d 50 01             	lea    0x1(%eax),%edx
  801212:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801215:	89 c2                	mov    %eax,%edx
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	01 d0                	add    %edx,%eax
  80121c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121f:	88 10                	mov    %dl,(%eax)
  801221:	eb 56                	jmp    801279 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801223:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801227:	75 1f                	jne    801248 <readline+0xc5>
  801229:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80122d:	7e 19                	jle    801248 <readline+0xc5>
			if (echoing)
  80122f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801233:	74 0e                	je     801243 <readline+0xc0>
				cputchar(c);
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	ff 75 ec             	pushl  -0x14(%ebp)
  80123b:	e8 3a f4 ff ff       	call   80067a <cputchar>
  801240:	83 c4 10             	add    $0x10,%esp

			i--;
  801243:	ff 4d f4             	decl   -0xc(%ebp)
  801246:	eb 31                	jmp    801279 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801248:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80124c:	74 0a                	je     801258 <readline+0xd5>
  80124e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801252:	0f 85 61 ff ff ff    	jne    8011b9 <readline+0x36>
			if (echoing)
  801258:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80125c:	74 0e                	je     80126c <readline+0xe9>
				cputchar(c);
  80125e:	83 ec 0c             	sub    $0xc,%esp
  801261:	ff 75 ec             	pushl  -0x14(%ebp)
  801264:	e8 11 f4 ff ff       	call   80067a <cputchar>
  801269:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80126c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	01 d0                	add    %edx,%eax
  801274:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801277:	eb 06                	jmp    80127f <readline+0xfc>
		}
	}
  801279:	e9 3b ff ff ff       	jmp    8011b9 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  80127e:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  80127f:	c9                   	leave  
  801280:	c3                   	ret    

00801281 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801287:	e8 e9 0a 00 00       	call   801d75 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  80128c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801290:	74 13                	je     8012a5 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801292:	83 ec 08             	sub    $0x8,%esp
  801295:	ff 75 08             	pushl  0x8(%ebp)
  801298:	68 b0 2b 80 00       	push   $0x802bb0
  80129d:	e8 5f f8 ff ff       	call   800b01 <cprintf>
  8012a2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012ac:	83 ec 0c             	sub    $0xc,%esp
  8012af:	6a 00                	push   $0x0
  8012b1:	e8 5a f4 ff ff       	call   800710 <iscons>
  8012b6:	83 c4 10             	add    $0x10,%esp
  8012b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012bc:	e8 01 f4 ff ff       	call   8006c2 <getchar>
  8012c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8012c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012c8:	79 23                	jns    8012ed <atomic_readline+0x6c>
			if (c != -E_EOF)
  8012ca:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012ce:	74 13                	je     8012e3 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8012d0:	83 ec 08             	sub    $0x8,%esp
  8012d3:	ff 75 ec             	pushl  -0x14(%ebp)
  8012d6:	68 b3 2b 80 00       	push   $0x802bb3
  8012db:	e8 21 f8 ff ff       	call   800b01 <cprintf>
  8012e0:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8012e3:	e8 a7 0a 00 00       	call   801d8f <sys_enable_interrupt>
			return;
  8012e8:	e9 9a 00 00 00       	jmp    801387 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8012ed:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012f1:	7e 34                	jle    801327 <atomic_readline+0xa6>
  8012f3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012fa:	7f 2b                	jg     801327 <atomic_readline+0xa6>
			if (echoing)
  8012fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801300:	74 0e                	je     801310 <atomic_readline+0x8f>
				cputchar(c);
  801302:	83 ec 0c             	sub    $0xc,%esp
  801305:	ff 75 ec             	pushl  -0x14(%ebp)
  801308:	e8 6d f3 ff ff       	call   80067a <cputchar>
  80130d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801313:	8d 50 01             	lea    0x1(%eax),%edx
  801316:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801319:	89 c2                	mov    %eax,%edx
  80131b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131e:	01 d0                	add    %edx,%eax
  801320:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801323:	88 10                	mov    %dl,(%eax)
  801325:	eb 5b                	jmp    801382 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801327:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80132b:	75 1f                	jne    80134c <atomic_readline+0xcb>
  80132d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801331:	7e 19                	jle    80134c <atomic_readline+0xcb>
			if (echoing)
  801333:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801337:	74 0e                	je     801347 <atomic_readline+0xc6>
				cputchar(c);
  801339:	83 ec 0c             	sub    $0xc,%esp
  80133c:	ff 75 ec             	pushl  -0x14(%ebp)
  80133f:	e8 36 f3 ff ff       	call   80067a <cputchar>
  801344:	83 c4 10             	add    $0x10,%esp
			i--;
  801347:	ff 4d f4             	decl   -0xc(%ebp)
  80134a:	eb 36                	jmp    801382 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80134c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801350:	74 0a                	je     80135c <atomic_readline+0xdb>
  801352:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801356:	0f 85 60 ff ff ff    	jne    8012bc <atomic_readline+0x3b>
			if (echoing)
  80135c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801360:	74 0e                	je     801370 <atomic_readline+0xef>
				cputchar(c);
  801362:	83 ec 0c             	sub    $0xc,%esp
  801365:	ff 75 ec             	pushl  -0x14(%ebp)
  801368:	e8 0d f3 ff ff       	call   80067a <cputchar>
  80136d:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801370:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801373:	8b 45 0c             	mov    0xc(%ebp),%eax
  801376:	01 d0                	add    %edx,%eax
  801378:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  80137b:	e8 0f 0a 00 00       	call   801d8f <sys_enable_interrupt>
			return;
  801380:	eb 05                	jmp    801387 <atomic_readline+0x106>
		}
	}
  801382:	e9 35 ff ff ff       	jmp    8012bc <atomic_readline+0x3b>
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80138f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801396:	eb 06                	jmp    80139e <strlen+0x15>
		n++;
  801398:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80139b:	ff 45 08             	incl   0x8(%ebp)
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	84 c0                	test   %al,%al
  8013a5:	75 f1                	jne    801398 <strlen+0xf>
		n++;
	return n;
  8013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013b9:	eb 09                	jmp    8013c4 <strnlen+0x18>
		n++;
  8013bb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013be:	ff 45 08             	incl   0x8(%ebp)
  8013c1:	ff 4d 0c             	decl   0xc(%ebp)
  8013c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013c8:	74 09                	je     8013d3 <strnlen+0x27>
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	84 c0                	test   %al,%al
  8013d1:	75 e8                	jne    8013bb <strnlen+0xf>
		n++;
	return n;
  8013d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    

008013d8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013e4:	90                   	nop
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8d 50 01             	lea    0x1(%eax),%edx
  8013eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013f4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013f7:	8a 12                	mov    (%edx),%dl
  8013f9:	88 10                	mov    %dl,(%eax)
  8013fb:	8a 00                	mov    (%eax),%al
  8013fd:	84 c0                	test   %al,%al
  8013ff:	75 e4                	jne    8013e5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801401:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801412:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801419:	eb 1f                	jmp    80143a <strncpy+0x34>
		*dst++ = *src;
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	8d 50 01             	lea    0x1(%eax),%edx
  801421:	89 55 08             	mov    %edx,0x8(%ebp)
  801424:	8b 55 0c             	mov    0xc(%ebp),%edx
  801427:	8a 12                	mov    (%edx),%dl
  801429:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80142b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142e:	8a 00                	mov    (%eax),%al
  801430:	84 c0                	test   %al,%al
  801432:	74 03                	je     801437 <strncpy+0x31>
			src++;
  801434:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801437:	ff 45 fc             	incl   -0x4(%ebp)
  80143a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80143d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801440:	72 d9                	jb     80141b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801442:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801453:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801457:	74 30                	je     801489 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801459:	eb 16                	jmp    801471 <strlcpy+0x2a>
			*dst++ = *src++;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8d 50 01             	lea    0x1(%eax),%edx
  801461:	89 55 08             	mov    %edx,0x8(%ebp)
  801464:	8b 55 0c             	mov    0xc(%ebp),%edx
  801467:	8d 4a 01             	lea    0x1(%edx),%ecx
  80146a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80146d:	8a 12                	mov    (%edx),%dl
  80146f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801471:	ff 4d 10             	decl   0x10(%ebp)
  801474:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801478:	74 09                	je     801483 <strlcpy+0x3c>
  80147a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	84 c0                	test   %al,%al
  801481:	75 d8                	jne    80145b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801489:	8b 55 08             	mov    0x8(%ebp),%edx
  80148c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148f:	29 c2                	sub    %eax,%edx
  801491:	89 d0                	mov    %edx,%eax
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801498:	eb 06                	jmp    8014a0 <strcmp+0xb>
		p++, q++;
  80149a:	ff 45 08             	incl   0x8(%ebp)
  80149d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	84 c0                	test   %al,%al
  8014a7:	74 0e                	je     8014b7 <strcmp+0x22>
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8a 10                	mov    (%eax),%dl
  8014ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	38 c2                	cmp    %al,%dl
  8014b5:	74 e3                	je     80149a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	8a 00                	mov    (%eax),%al
  8014bc:	0f b6 d0             	movzbl %al,%edx
  8014bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c2:	8a 00                	mov    (%eax),%al
  8014c4:	0f b6 c0             	movzbl %al,%eax
  8014c7:	29 c2                	sub    %eax,%edx
  8014c9:	89 d0                	mov    %edx,%eax
}
  8014cb:	5d                   	pop    %ebp
  8014cc:	c3                   	ret    

008014cd <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014d0:	eb 09                	jmp    8014db <strncmp+0xe>
		n--, p++, q++;
  8014d2:	ff 4d 10             	decl   0x10(%ebp)
  8014d5:	ff 45 08             	incl   0x8(%ebp)
  8014d8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014df:	74 17                	je     8014f8 <strncmp+0x2b>
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	84 c0                	test   %al,%al
  8014e8:	74 0e                	je     8014f8 <strncmp+0x2b>
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	8a 10                	mov    (%eax),%dl
  8014ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f2:	8a 00                	mov    (%eax),%al
  8014f4:	38 c2                	cmp    %al,%dl
  8014f6:	74 da                	je     8014d2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014fc:	75 07                	jne    801505 <strncmp+0x38>
		return 0;
  8014fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801503:	eb 14                	jmp    801519 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8a 00                	mov    (%eax),%al
  80150a:	0f b6 d0             	movzbl %al,%edx
  80150d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801510:	8a 00                	mov    (%eax),%al
  801512:	0f b6 c0             	movzbl %al,%eax
  801515:	29 c2                	sub    %eax,%edx
  801517:	89 d0                	mov    %edx,%eax
}
  801519:	5d                   	pop    %ebp
  80151a:	c3                   	ret    

0080151b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
  80151e:	83 ec 04             	sub    $0x4,%esp
  801521:	8b 45 0c             	mov    0xc(%ebp),%eax
  801524:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801527:	eb 12                	jmp    80153b <strchr+0x20>
		if (*s == c)
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801531:	75 05                	jne    801538 <strchr+0x1d>
			return (char *) s;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	eb 11                	jmp    801549 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801538:	ff 45 08             	incl   0x8(%ebp)
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8a 00                	mov    (%eax),%al
  801540:	84 c0                	test   %al,%al
  801542:	75 e5                	jne    801529 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801544:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 04             	sub    $0x4,%esp
  801551:	8b 45 0c             	mov    0xc(%ebp),%eax
  801554:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801557:	eb 0d                	jmp    801566 <strfind+0x1b>
		if (*s == c)
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801561:	74 0e                	je     801571 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801563:	ff 45 08             	incl   0x8(%ebp)
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8a 00                	mov    (%eax),%al
  80156b:	84 c0                	test   %al,%al
  80156d:	75 ea                	jne    801559 <strfind+0xe>
  80156f:	eb 01                	jmp    801572 <strfind+0x27>
		if (*s == c)
			break;
  801571:	90                   	nop
	return (char *) s;
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801583:	8b 45 10             	mov    0x10(%ebp),%eax
  801586:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801589:	eb 0e                	jmp    801599 <memset+0x22>
		*p++ = c;
  80158b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80158e:	8d 50 01             	lea    0x1(%eax),%edx
  801591:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801594:	8b 55 0c             	mov    0xc(%ebp),%edx
  801597:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801599:	ff 4d f8             	decl   -0x8(%ebp)
  80159c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015a0:	79 e9                	jns    80158b <memset+0x14>
		*p++ = c;

	return v;
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8015b9:	eb 16                	jmp    8015d1 <memcpy+0x2a>
		*d++ = *s++;
  8015bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015be:	8d 50 01             	lea    0x1(%eax),%edx
  8015c1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015ca:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015cd:	8a 12                	mov    (%edx),%dl
  8015cf:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	75 dd                	jne    8015bb <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015fb:	73 50                	jae    80164d <memmove+0x6a>
  8015fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801600:	8b 45 10             	mov    0x10(%ebp),%eax
  801603:	01 d0                	add    %edx,%eax
  801605:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801608:	76 43                	jbe    80164d <memmove+0x6a>
		s += n;
  80160a:	8b 45 10             	mov    0x10(%ebp),%eax
  80160d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801610:	8b 45 10             	mov    0x10(%ebp),%eax
  801613:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801616:	eb 10                	jmp    801628 <memmove+0x45>
			*--d = *--s;
  801618:	ff 4d f8             	decl   -0x8(%ebp)
  80161b:	ff 4d fc             	decl   -0x4(%ebp)
  80161e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801621:	8a 10                	mov    (%eax),%dl
  801623:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801626:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801628:	8b 45 10             	mov    0x10(%ebp),%eax
  80162b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80162e:	89 55 10             	mov    %edx,0x10(%ebp)
  801631:	85 c0                	test   %eax,%eax
  801633:	75 e3                	jne    801618 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801635:	eb 23                	jmp    80165a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801637:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163a:	8d 50 01             	lea    0x1(%eax),%edx
  80163d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801640:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801643:	8d 4a 01             	lea    0x1(%edx),%ecx
  801646:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801649:	8a 12                	mov    (%edx),%dl
  80164b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80164d:	8b 45 10             	mov    0x10(%ebp),%eax
  801650:	8d 50 ff             	lea    -0x1(%eax),%edx
  801653:	89 55 10             	mov    %edx,0x10(%ebp)
  801656:	85 c0                	test   %eax,%eax
  801658:	75 dd                	jne    801637 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801671:	eb 2a                	jmp    80169d <memcmp+0x3e>
		if (*s1 != *s2)
  801673:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801676:	8a 10                	mov    (%eax),%dl
  801678:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80167b:	8a 00                	mov    (%eax),%al
  80167d:	38 c2                	cmp    %al,%dl
  80167f:	74 16                	je     801697 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801681:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801684:	8a 00                	mov    (%eax),%al
  801686:	0f b6 d0             	movzbl %al,%edx
  801689:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168c:	8a 00                	mov    (%eax),%al
  80168e:	0f b6 c0             	movzbl %al,%eax
  801691:	29 c2                	sub    %eax,%edx
  801693:	89 d0                	mov    %edx,%eax
  801695:	eb 18                	jmp    8016af <memcmp+0x50>
		s1++, s2++;
  801697:	ff 45 fc             	incl   -0x4(%ebp)
  80169a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	75 c9                	jne    801673 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bd:	01 d0                	add    %edx,%eax
  8016bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016c2:	eb 15                	jmp    8016d9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	8a 00                	mov    (%eax),%al
  8016c9:	0f b6 d0             	movzbl %al,%edx
  8016cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cf:	0f b6 c0             	movzbl %al,%eax
  8016d2:	39 c2                	cmp    %eax,%edx
  8016d4:	74 0d                	je     8016e3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016d6:	ff 45 08             	incl   0x8(%ebp)
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016df:	72 e3                	jb     8016c4 <memfind+0x13>
  8016e1:	eb 01                	jmp    8016e4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016e3:	90                   	nop
	return (void *) s;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016fd:	eb 03                	jmp    801702 <strtol+0x19>
		s++;
  8016ff:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	3c 20                	cmp    $0x20,%al
  801709:	74 f4                	je     8016ff <strtol+0x16>
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	3c 09                	cmp    $0x9,%al
  801712:	74 eb                	je     8016ff <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	8a 00                	mov    (%eax),%al
  801719:	3c 2b                	cmp    $0x2b,%al
  80171b:	75 05                	jne    801722 <strtol+0x39>
		s++;
  80171d:	ff 45 08             	incl   0x8(%ebp)
  801720:	eb 13                	jmp    801735 <strtol+0x4c>
	else if (*s == '-')
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	8a 00                	mov    (%eax),%al
  801727:	3c 2d                	cmp    $0x2d,%al
  801729:	75 0a                	jne    801735 <strtol+0x4c>
		s++, neg = 1;
  80172b:	ff 45 08             	incl   0x8(%ebp)
  80172e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801735:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801739:	74 06                	je     801741 <strtol+0x58>
  80173b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80173f:	75 20                	jne    801761 <strtol+0x78>
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	3c 30                	cmp    $0x30,%al
  801748:	75 17                	jne    801761 <strtol+0x78>
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	40                   	inc    %eax
  80174e:	8a 00                	mov    (%eax),%al
  801750:	3c 78                	cmp    $0x78,%al
  801752:	75 0d                	jne    801761 <strtol+0x78>
		s += 2, base = 16;
  801754:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801758:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80175f:	eb 28                	jmp    801789 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801761:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801765:	75 15                	jne    80177c <strtol+0x93>
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	8a 00                	mov    (%eax),%al
  80176c:	3c 30                	cmp    $0x30,%al
  80176e:	75 0c                	jne    80177c <strtol+0x93>
		s++, base = 8;
  801770:	ff 45 08             	incl   0x8(%ebp)
  801773:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80177a:	eb 0d                	jmp    801789 <strtol+0xa0>
	else if (base == 0)
  80177c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801780:	75 07                	jne    801789 <strtol+0xa0>
		base = 10;
  801782:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	8a 00                	mov    (%eax),%al
  80178e:	3c 2f                	cmp    $0x2f,%al
  801790:	7e 19                	jle    8017ab <strtol+0xc2>
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8a 00                	mov    (%eax),%al
  801797:	3c 39                	cmp    $0x39,%al
  801799:	7f 10                	jg     8017ab <strtol+0xc2>
			dig = *s - '0';
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	0f be c0             	movsbl %al,%eax
  8017a3:	83 e8 30             	sub    $0x30,%eax
  8017a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017a9:	eb 42                	jmp    8017ed <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	8a 00                	mov    (%eax),%al
  8017b0:	3c 60                	cmp    $0x60,%al
  8017b2:	7e 19                	jle    8017cd <strtol+0xe4>
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	8a 00                	mov    (%eax),%al
  8017b9:	3c 7a                	cmp    $0x7a,%al
  8017bb:	7f 10                	jg     8017cd <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	8a 00                	mov    (%eax),%al
  8017c2:	0f be c0             	movsbl %al,%eax
  8017c5:	83 e8 57             	sub    $0x57,%eax
  8017c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017cb:	eb 20                	jmp    8017ed <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	3c 40                	cmp    $0x40,%al
  8017d4:	7e 39                	jle    80180f <strtol+0x126>
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	3c 5a                	cmp    $0x5a,%al
  8017dd:	7f 30                	jg     80180f <strtol+0x126>
			dig = *s - 'A' + 10;
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8a 00                	mov    (%eax),%al
  8017e4:	0f be c0             	movsbl %al,%eax
  8017e7:	83 e8 37             	sub    $0x37,%eax
  8017ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017f3:	7d 19                	jge    80180e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017f5:	ff 45 08             	incl   0x8(%ebp)
  8017f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fb:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017ff:	89 c2                	mov    %eax,%edx
  801801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801804:	01 d0                	add    %edx,%eax
  801806:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801809:	e9 7b ff ff ff       	jmp    801789 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80180e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80180f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801813:	74 08                	je     80181d <strtol+0x134>
		*endptr = (char *) s;
  801815:	8b 45 0c             	mov    0xc(%ebp),%eax
  801818:	8b 55 08             	mov    0x8(%ebp),%edx
  80181b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80181d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801821:	74 07                	je     80182a <strtol+0x141>
  801823:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801826:	f7 d8                	neg    %eax
  801828:	eb 03                	jmp    80182d <strtol+0x144>
  80182a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <ltostr>:

void
ltostr(long value, char *str)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801835:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80183c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801843:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801847:	79 13                	jns    80185c <ltostr+0x2d>
	{
		neg = 1;
  801849:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801850:	8b 45 0c             	mov    0xc(%ebp),%eax
  801853:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801856:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801859:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801864:	99                   	cltd   
  801865:	f7 f9                	idiv   %ecx
  801867:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80186a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186d:	8d 50 01             	lea    0x1(%eax),%edx
  801870:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801873:	89 c2                	mov    %eax,%edx
  801875:	8b 45 0c             	mov    0xc(%ebp),%eax
  801878:	01 d0                	add    %edx,%eax
  80187a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80187d:	83 c2 30             	add    $0x30,%edx
  801880:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801882:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801885:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80188a:	f7 e9                	imul   %ecx
  80188c:	c1 fa 02             	sar    $0x2,%edx
  80188f:	89 c8                	mov    %ecx,%eax
  801891:	c1 f8 1f             	sar    $0x1f,%eax
  801894:	29 c2                	sub    %eax,%edx
  801896:	89 d0                	mov    %edx,%eax
  801898:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80189b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80189e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018a3:	f7 e9                	imul   %ecx
  8018a5:	c1 fa 02             	sar    $0x2,%edx
  8018a8:	89 c8                	mov    %ecx,%eax
  8018aa:	c1 f8 1f             	sar    $0x1f,%eax
  8018ad:	29 c2                	sub    %eax,%edx
  8018af:	89 d0                	mov    %edx,%eax
  8018b1:	c1 e0 02             	shl    $0x2,%eax
  8018b4:	01 d0                	add    %edx,%eax
  8018b6:	01 c0                	add    %eax,%eax
  8018b8:	29 c1                	sub    %eax,%ecx
  8018ba:	89 ca                	mov    %ecx,%edx
  8018bc:	85 d2                	test   %edx,%edx
  8018be:	75 9c                	jne    80185c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ca:	48                   	dec    %eax
  8018cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018d2:	74 3d                	je     801911 <ltostr+0xe2>
		start = 1 ;
  8018d4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018db:	eb 34                	jmp    801911 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8018dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e3:	01 d0                	add    %edx,%eax
  8018e5:	8a 00                	mov    (%eax),%al
  8018e7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f0:	01 c2                	add    %eax,%edx
  8018f2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f8:	01 c8                	add    %ecx,%eax
  8018fa:	8a 00                	mov    (%eax),%al
  8018fc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801901:	8b 45 0c             	mov    0xc(%ebp),%eax
  801904:	01 c2                	add    %eax,%edx
  801906:	8a 45 eb             	mov    -0x15(%ebp),%al
  801909:	88 02                	mov    %al,(%edx)
		start++ ;
  80190b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80190e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801914:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801917:	7c c4                	jl     8018dd <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801919:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80191c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191f:	01 d0                	add    %edx,%eax
  801921:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801924:	90                   	nop
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80192d:	ff 75 08             	pushl  0x8(%ebp)
  801930:	e8 54 fa ff ff       	call   801389 <strlen>
  801935:	83 c4 04             	add    $0x4,%esp
  801938:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	e8 46 fa ff ff       	call   801389 <strlen>
  801943:	83 c4 04             	add    $0x4,%esp
  801946:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801949:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801950:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801957:	eb 17                	jmp    801970 <strcconcat+0x49>
		final[s] = str1[s] ;
  801959:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80195c:	8b 45 10             	mov    0x10(%ebp),%eax
  80195f:	01 c2                	add    %eax,%edx
  801961:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	01 c8                	add    %ecx,%eax
  801969:	8a 00                	mov    (%eax),%al
  80196b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80196d:	ff 45 fc             	incl   -0x4(%ebp)
  801970:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801973:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801976:	7c e1                	jl     801959 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801978:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80197f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801986:	eb 1f                	jmp    8019a7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801988:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80198b:	8d 50 01             	lea    0x1(%eax),%edx
  80198e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801991:	89 c2                	mov    %eax,%edx
  801993:	8b 45 10             	mov    0x10(%ebp),%eax
  801996:	01 c2                	add    %eax,%edx
  801998:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80199b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199e:	01 c8                	add    %ecx,%eax
  8019a0:	8a 00                	mov    (%eax),%al
  8019a2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019a4:	ff 45 f8             	incl   -0x8(%ebp)
  8019a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019ad:	7c d9                	jl     801988 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b5:	01 d0                	add    %edx,%eax
  8019b7:	c6 00 00             	movb   $0x0,(%eax)
}
  8019ba:	90                   	nop
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019cc:	8b 00                	mov    (%eax),%eax
  8019ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d8:	01 d0                	add    %edx,%eax
  8019da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019e0:	eb 0c                	jmp    8019ee <strsplit+0x31>
			*string++ = 0;
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	8d 50 01             	lea    0x1(%eax),%edx
  8019e8:	89 55 08             	mov    %edx,0x8(%ebp)
  8019eb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	8a 00                	mov    (%eax),%al
  8019f3:	84 c0                	test   %al,%al
  8019f5:	74 18                	je     801a0f <strsplit+0x52>
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8a 00                	mov    (%eax),%al
  8019fc:	0f be c0             	movsbl %al,%eax
  8019ff:	50                   	push   %eax
  801a00:	ff 75 0c             	pushl  0xc(%ebp)
  801a03:	e8 13 fb ff ff       	call   80151b <strchr>
  801a08:	83 c4 08             	add    $0x8,%esp
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	75 d3                	jne    8019e2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	8a 00                	mov    (%eax),%al
  801a14:	84 c0                	test   %al,%al
  801a16:	74 5a                	je     801a72 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a18:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1b:	8b 00                	mov    (%eax),%eax
  801a1d:	83 f8 0f             	cmp    $0xf,%eax
  801a20:	75 07                	jne    801a29 <strsplit+0x6c>
		{
			return 0;
  801a22:	b8 00 00 00 00       	mov    $0x0,%eax
  801a27:	eb 66                	jmp    801a8f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a29:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2c:	8b 00                	mov    (%eax),%eax
  801a2e:	8d 48 01             	lea    0x1(%eax),%ecx
  801a31:	8b 55 14             	mov    0x14(%ebp),%edx
  801a34:	89 0a                	mov    %ecx,(%edx)
  801a36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a40:	01 c2                	add    %eax,%edx
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a47:	eb 03                	jmp    801a4c <strsplit+0x8f>
			string++;
  801a49:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	8a 00                	mov    (%eax),%al
  801a51:	84 c0                	test   %al,%al
  801a53:	74 8b                	je     8019e0 <strsplit+0x23>
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	8a 00                	mov    (%eax),%al
  801a5a:	0f be c0             	movsbl %al,%eax
  801a5d:	50                   	push   %eax
  801a5e:	ff 75 0c             	pushl  0xc(%ebp)
  801a61:	e8 b5 fa ff ff       	call   80151b <strchr>
  801a66:	83 c4 08             	add    $0x8,%esp
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	74 dc                	je     801a49 <strsplit+0x8c>
			string++;
	}
  801a6d:	e9 6e ff ff ff       	jmp    8019e0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a72:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a73:	8b 45 14             	mov    0x14(%ebp),%eax
  801a76:	8b 00                	mov    (%eax),%eax
  801a78:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a82:	01 d0                	add    %edx,%eax
  801a84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a8a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801a97:	83 ec 04             	sub    $0x4,%esp
  801a9a:	68 c4 2b 80 00       	push   $0x802bc4
  801a9f:	6a 19                	push   $0x19
  801aa1:	68 e9 2b 80 00       	push   $0x802be9
  801aa6:	e8 b4 ed ff ff       	call   80085f <_panic>

00801aab <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
  801aae:	83 ec 18             	sub    $0x18,%esp
  801ab1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab4:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801ab7:	83 ec 04             	sub    $0x4,%esp
  801aba:	68 f8 2b 80 00       	push   $0x802bf8
  801abf:	6a 31                	push   $0x31
  801ac1:	68 e9 2b 80 00       	push   $0x802be9
  801ac6:	e8 94 ed ff ff       	call   80085f <_panic>

00801acb <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801ad1:	83 ec 04             	sub    $0x4,%esp
  801ad4:	68 20 2c 80 00       	push   $0x802c20
  801ad9:	6a 4a                	push   $0x4a
  801adb:	68 e9 2b 80 00       	push   $0x802be9
  801ae0:	e8 7a ed ff ff       	call   80085f <_panic>

00801ae5 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801aeb:	83 ec 04             	sub    $0x4,%esp
  801aee:	68 44 2c 80 00       	push   $0x802c44
  801af3:	6a 70                	push   $0x70
  801af5:	68 e9 2b 80 00       	push   $0x802be9
  801afa:	e8 60 ed ff ff       	call   80085f <_panic>

00801aff <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b05:	83 ec 04             	sub    $0x4,%esp
  801b08:	68 68 2c 80 00       	push   $0x802c68
  801b0d:	68 8b 00 00 00       	push   $0x8b
  801b12:	68 e9 2b 80 00       	push   $0x802be9
  801b17:	e8 43 ed ff ff       	call   80085f <_panic>

00801b1c <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b22:	83 ec 04             	sub    $0x4,%esp
  801b25:	68 8c 2c 80 00       	push   $0x802c8c
  801b2a:	68 a8 00 00 00       	push   $0xa8
  801b2f:	68 e9 2b 80 00       	push   $0x802be9
  801b34:	e8 26 ed ff ff       	call   80085f <_panic>

00801b39 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	57                   	push   %edi
  801b3d:	56                   	push   %esi
  801b3e:	53                   	push   %ebx
  801b3f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b4e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b51:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b54:	cd 30                	int    $0x30
  801b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	5b                   	pop    %ebx
  801b60:	5e                   	pop    %esi
  801b61:	5f                   	pop    %edi
  801b62:	5d                   	pop    %ebp
  801b63:	c3                   	ret    

00801b64 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 04             	sub    $0x4,%esp
  801b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b70:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	52                   	push   %edx
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	50                   	push   %eax
  801b80:	6a 00                	push   $0x0
  801b82:	e8 b2 ff ff ff       	call   801b39 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	90                   	nop
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_cgetc>:

int
sys_cgetc(void)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 01                	push   $0x1
  801b9c:	e8 98 ff ff ff       	call   801b39 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	50                   	push   %eax
  801bb5:	6a 05                	push   $0x5
  801bb7:	e8 7d ff ff ff       	call   801b39 <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 02                	push   $0x2
  801bd0:	e8 64 ff ff ff       	call   801b39 <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 03                	push   $0x3
  801be9:	e8 4b ff ff ff       	call   801b39 <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 04                	push   $0x4
  801c02:	e8 32 ff ff ff       	call   801b39 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_env_exit>:


void sys_env_exit(void)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 06                	push   $0x6
  801c1b:	e8 19 ff ff ff       	call   801b39 <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	90                   	nop
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	52                   	push   %edx
  801c36:	50                   	push   %eax
  801c37:	6a 07                	push   $0x7
  801c39:	e8 fb fe ff ff       	call   801b39 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	56                   	push   %esi
  801c47:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c48:	8b 75 18             	mov    0x18(%ebp),%esi
  801c4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	56                   	push   %esi
  801c58:	53                   	push   %ebx
  801c59:	51                   	push   %ecx
  801c5a:	52                   	push   %edx
  801c5b:	50                   	push   %eax
  801c5c:	6a 08                	push   $0x8
  801c5e:	e8 d6 fe ff ff       	call   801b39 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c69:	5b                   	pop    %ebx
  801c6a:	5e                   	pop    %esi
  801c6b:	5d                   	pop    %ebp
  801c6c:	c3                   	ret    

00801c6d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	52                   	push   %edx
  801c7d:	50                   	push   %eax
  801c7e:	6a 09                	push   $0x9
  801c80:	e8 b4 fe ff ff       	call   801b39 <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	ff 75 0c             	pushl  0xc(%ebp)
  801c96:	ff 75 08             	pushl  0x8(%ebp)
  801c99:	6a 0a                	push   $0xa
  801c9b:	e8 99 fe ff ff       	call   801b39 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 0b                	push   $0xb
  801cb4:	e8 80 fe ff ff       	call   801b39 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 0c                	push   $0xc
  801ccd:	e8 67 fe ff ff       	call   801b39 <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 0d                	push   $0xd
  801ce6:	e8 4e fe ff ff       	call   801b39 <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	ff 75 0c             	pushl  0xc(%ebp)
  801cfc:	ff 75 08             	pushl  0x8(%ebp)
  801cff:	6a 11                	push   $0x11
  801d01:	e8 33 fe ff ff       	call   801b39 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
	return;
  801d09:	90                   	nop
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	ff 75 0c             	pushl  0xc(%ebp)
  801d18:	ff 75 08             	pushl  0x8(%ebp)
  801d1b:	6a 12                	push   $0x12
  801d1d:	e8 17 fe ff ff       	call   801b39 <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
	return ;
  801d25:	90                   	nop
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 0e                	push   $0xe
  801d37:	e8 fd fd ff ff       	call   801b39 <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	ff 75 08             	pushl  0x8(%ebp)
  801d4f:	6a 0f                	push   $0xf
  801d51:	e8 e3 fd ff ff       	call   801b39 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 10                	push   $0x10
  801d6a:	e8 ca fd ff ff       	call   801b39 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	90                   	nop
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 14                	push   $0x14
  801d84:	e8 b0 fd ff ff       	call   801b39 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
}
  801d8c:	90                   	nop
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 15                	push   $0x15
  801d9e:	e8 96 fd ff ff       	call   801b39 <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
}
  801da6:	90                   	nop
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_cputc>:


void
sys_cputc(const char c)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	83 ec 04             	sub    $0x4,%esp
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801db5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	50                   	push   %eax
  801dc2:	6a 16                	push   $0x16
  801dc4:	e8 70 fd ff ff       	call   801b39 <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
}
  801dcc:	90                   	nop
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 17                	push   $0x17
  801dde:	e8 56 fd ff ff       	call   801b39 <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	90                   	nop
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	ff 75 0c             	pushl  0xc(%ebp)
  801df8:	50                   	push   %eax
  801df9:	6a 18                	push   $0x18
  801dfb:	e8 39 fd ff ff       	call   801b39 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	52                   	push   %edx
  801e15:	50                   	push   %eax
  801e16:	6a 1b                	push   $0x1b
  801e18:	e8 1c fd ff ff       	call   801b39 <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	52                   	push   %edx
  801e32:	50                   	push   %eax
  801e33:	6a 19                	push   $0x19
  801e35:	e8 ff fc ff ff       	call   801b39 <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
}
  801e3d:	90                   	nop
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	52                   	push   %edx
  801e50:	50                   	push   %eax
  801e51:	6a 1a                	push   $0x1a
  801e53:	e8 e1 fc ff ff       	call   801b39 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	90                   	nop
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 04             	sub    $0x4,%esp
  801e64:	8b 45 10             	mov    0x10(%ebp),%eax
  801e67:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e6a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e6d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	6a 00                	push   $0x0
  801e76:	51                   	push   %ecx
  801e77:	52                   	push   %edx
  801e78:	ff 75 0c             	pushl  0xc(%ebp)
  801e7b:	50                   	push   %eax
  801e7c:	6a 1c                	push   $0x1c
  801e7e:	e8 b6 fc ff ff       	call   801b39 <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	52                   	push   %edx
  801e98:	50                   	push   %eax
  801e99:	6a 1d                	push   $0x1d
  801e9b:	e8 99 fc ff ff       	call   801b39 <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ea8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	51                   	push   %ecx
  801eb6:	52                   	push   %edx
  801eb7:	50                   	push   %eax
  801eb8:	6a 1e                	push   $0x1e
  801eba:	e8 7a fc ff ff       	call   801b39 <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
}
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ec7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	52                   	push   %edx
  801ed4:	50                   	push   %eax
  801ed5:	6a 1f                	push   $0x1f
  801ed7:	e8 5d fc ff ff       	call   801b39 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 20                	push   $0x20
  801ef0:	e8 44 fc ff ff       	call   801b39 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801efd:	8b 45 08             	mov    0x8(%ebp),%eax
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	ff 75 10             	pushl  0x10(%ebp)
  801f07:	ff 75 0c             	pushl  0xc(%ebp)
  801f0a:	50                   	push   %eax
  801f0b:	6a 21                	push   $0x21
  801f0d:	e8 27 fc ff ff       	call   801b39 <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	50                   	push   %eax
  801f26:	6a 22                	push   $0x22
  801f28:	e8 0c fc ff ff       	call   801b39 <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	90                   	nop
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	50                   	push   %eax
  801f42:	6a 23                	push   $0x23
  801f44:	e8 f0 fb ff ff       	call   801b39 <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
}
  801f4c:	90                   	nop
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f55:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f58:	8d 50 04             	lea    0x4(%eax),%edx
  801f5b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	52                   	push   %edx
  801f65:	50                   	push   %eax
  801f66:	6a 24                	push   $0x24
  801f68:	e8 cc fb ff ff       	call   801b39 <syscall>
  801f6d:	83 c4 18             	add    $0x18,%esp
	return result;
  801f70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f76:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f79:	89 01                	mov    %eax,(%ecx)
  801f7b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	c9                   	leave  
  801f82:	c2 04 00             	ret    $0x4

00801f85 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	ff 75 10             	pushl  0x10(%ebp)
  801f8f:	ff 75 0c             	pushl  0xc(%ebp)
  801f92:	ff 75 08             	pushl  0x8(%ebp)
  801f95:	6a 13                	push   $0x13
  801f97:	e8 9d fb ff ff       	call   801b39 <syscall>
  801f9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9f:	90                   	nop
}
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 25                	push   $0x25
  801fb1:	e8 83 fb ff ff       	call   801b39 <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fc7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	50                   	push   %eax
  801fd4:	6a 26                	push   $0x26
  801fd6:	e8 5e fb ff ff       	call   801b39 <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801fde:	90                   	nop
}
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <rsttst>:
void rsttst()
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 28                	push   $0x28
  801ff0:	e8 44 fb ff ff       	call   801b39 <syscall>
  801ff5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff8:	90                   	nop
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	83 ec 04             	sub    $0x4,%esp
  802001:	8b 45 14             	mov    0x14(%ebp),%eax
  802004:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802007:	8b 55 18             	mov    0x18(%ebp),%edx
  80200a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80200e:	52                   	push   %edx
  80200f:	50                   	push   %eax
  802010:	ff 75 10             	pushl  0x10(%ebp)
  802013:	ff 75 0c             	pushl  0xc(%ebp)
  802016:	ff 75 08             	pushl  0x8(%ebp)
  802019:	6a 27                	push   $0x27
  80201b:	e8 19 fb ff ff       	call   801b39 <syscall>
  802020:	83 c4 18             	add    $0x18,%esp
	return ;
  802023:	90                   	nop
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <chktst>:
void chktst(uint32 n)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	ff 75 08             	pushl  0x8(%ebp)
  802034:	6a 29                	push   $0x29
  802036:	e8 fe fa ff ff       	call   801b39 <syscall>
  80203b:	83 c4 18             	add    $0x18,%esp
	return ;
  80203e:	90                   	nop
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <inctst>:

void inctst()
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 2a                	push   $0x2a
  802050:	e8 e4 fa ff ff       	call   801b39 <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
	return ;
  802058:	90                   	nop
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <gettst>:
uint32 gettst()
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 2b                	push   $0x2b
  80206a:	e8 ca fa ff ff       	call   801b39 <syscall>
  80206f:	83 c4 18             	add    $0x18,%esp
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 2c                	push   $0x2c
  802086:	e8 ae fa ff ff       	call   801b39 <syscall>
  80208b:	83 c4 18             	add    $0x18,%esp
  80208e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802091:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802095:	75 07                	jne    80209e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802097:	b8 01 00 00 00       	mov    $0x1,%eax
  80209c:	eb 05                	jmp    8020a3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80209e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 2c                	push   $0x2c
  8020b7:	e8 7d fa ff ff       	call   801b39 <syscall>
  8020bc:	83 c4 18             	add    $0x18,%esp
  8020bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020c2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020c6:	75 07                	jne    8020cf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8020cd:	eb 05                	jmp    8020d4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 2c                	push   $0x2c
  8020e8:	e8 4c fa ff ff       	call   801b39 <syscall>
  8020ed:	83 c4 18             	add    $0x18,%esp
  8020f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020f3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020f7:	75 07                	jne    802100 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020fe:	eb 05                	jmp    802105 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802100:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 2c                	push   $0x2c
  802119:	e8 1b fa ff ff       	call   801b39 <syscall>
  80211e:	83 c4 18             	add    $0x18,%esp
  802121:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802124:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802128:	75 07                	jne    802131 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80212a:	b8 01 00 00 00       	mov    $0x1,%eax
  80212f:	eb 05                	jmp    802136 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802131:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	ff 75 08             	pushl  0x8(%ebp)
  802146:	6a 2d                	push   $0x2d
  802148:	e8 ec f9 ff ff       	call   801b39 <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
	return ;
  802150:	90                   	nop
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802157:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80215a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80215d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	6a 00                	push   $0x0
  802165:	53                   	push   %ebx
  802166:	51                   	push   %ecx
  802167:	52                   	push   %edx
  802168:	50                   	push   %eax
  802169:	6a 2e                	push   $0x2e
  80216b:	e8 c9 f9 ff ff       	call   801b39 <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
}
  802173:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80217b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	52                   	push   %edx
  802188:	50                   	push   %eax
  802189:	6a 2f                	push   $0x2f
  80218b:	e8 a9 f9 ff ff       	call   801b39 <syscall>
  802190:	83 c4 18             	add    $0x18,%esp
}
  802193:	c9                   	leave  
  802194:	c3                   	ret    
  802195:	66 90                	xchg   %ax,%ax
  802197:	90                   	nop

00802198 <__udivdi3>:
  802198:	55                   	push   %ebp
  802199:	57                   	push   %edi
  80219a:	56                   	push   %esi
  80219b:	53                   	push   %ebx
  80219c:	83 ec 1c             	sub    $0x1c,%esp
  80219f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8021a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021af:	89 ca                	mov    %ecx,%edx
  8021b1:	89 f8                	mov    %edi,%eax
  8021b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8021b7:	85 f6                	test   %esi,%esi
  8021b9:	75 2d                	jne    8021e8 <__udivdi3+0x50>
  8021bb:	39 cf                	cmp    %ecx,%edi
  8021bd:	77 65                	ja     802224 <__udivdi3+0x8c>
  8021bf:	89 fd                	mov    %edi,%ebp
  8021c1:	85 ff                	test   %edi,%edi
  8021c3:	75 0b                	jne    8021d0 <__udivdi3+0x38>
  8021c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ca:	31 d2                	xor    %edx,%edx
  8021cc:	f7 f7                	div    %edi
  8021ce:	89 c5                	mov    %eax,%ebp
  8021d0:	31 d2                	xor    %edx,%edx
  8021d2:	89 c8                	mov    %ecx,%eax
  8021d4:	f7 f5                	div    %ebp
  8021d6:	89 c1                	mov    %eax,%ecx
  8021d8:	89 d8                	mov    %ebx,%eax
  8021da:	f7 f5                	div    %ebp
  8021dc:	89 cf                	mov    %ecx,%edi
  8021de:	89 fa                	mov    %edi,%edx
  8021e0:	83 c4 1c             	add    $0x1c,%esp
  8021e3:	5b                   	pop    %ebx
  8021e4:	5e                   	pop    %esi
  8021e5:	5f                   	pop    %edi
  8021e6:	5d                   	pop    %ebp
  8021e7:	c3                   	ret    
  8021e8:	39 ce                	cmp    %ecx,%esi
  8021ea:	77 28                	ja     802214 <__udivdi3+0x7c>
  8021ec:	0f bd fe             	bsr    %esi,%edi
  8021ef:	83 f7 1f             	xor    $0x1f,%edi
  8021f2:	75 40                	jne    802234 <__udivdi3+0x9c>
  8021f4:	39 ce                	cmp    %ecx,%esi
  8021f6:	72 0a                	jb     802202 <__udivdi3+0x6a>
  8021f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8021fc:	0f 87 9e 00 00 00    	ja     8022a0 <__udivdi3+0x108>
  802202:	b8 01 00 00 00       	mov    $0x1,%eax
  802207:	89 fa                	mov    %edi,%edx
  802209:	83 c4 1c             	add    $0x1c,%esp
  80220c:	5b                   	pop    %ebx
  80220d:	5e                   	pop    %esi
  80220e:	5f                   	pop    %edi
  80220f:	5d                   	pop    %ebp
  802210:	c3                   	ret    
  802211:	8d 76 00             	lea    0x0(%esi),%esi
  802214:	31 ff                	xor    %edi,%edi
  802216:	31 c0                	xor    %eax,%eax
  802218:	89 fa                	mov    %edi,%edx
  80221a:	83 c4 1c             	add    $0x1c,%esp
  80221d:	5b                   	pop    %ebx
  80221e:	5e                   	pop    %esi
  80221f:	5f                   	pop    %edi
  802220:	5d                   	pop    %ebp
  802221:	c3                   	ret    
  802222:	66 90                	xchg   %ax,%ax
  802224:	89 d8                	mov    %ebx,%eax
  802226:	f7 f7                	div    %edi
  802228:	31 ff                	xor    %edi,%edi
  80222a:	89 fa                	mov    %edi,%edx
  80222c:	83 c4 1c             	add    $0x1c,%esp
  80222f:	5b                   	pop    %ebx
  802230:	5e                   	pop    %esi
  802231:	5f                   	pop    %edi
  802232:	5d                   	pop    %ebp
  802233:	c3                   	ret    
  802234:	bd 20 00 00 00       	mov    $0x20,%ebp
  802239:	89 eb                	mov    %ebp,%ebx
  80223b:	29 fb                	sub    %edi,%ebx
  80223d:	89 f9                	mov    %edi,%ecx
  80223f:	d3 e6                	shl    %cl,%esi
  802241:	89 c5                	mov    %eax,%ebp
  802243:	88 d9                	mov    %bl,%cl
  802245:	d3 ed                	shr    %cl,%ebp
  802247:	89 e9                	mov    %ebp,%ecx
  802249:	09 f1                	or     %esi,%ecx
  80224b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80224f:	89 f9                	mov    %edi,%ecx
  802251:	d3 e0                	shl    %cl,%eax
  802253:	89 c5                	mov    %eax,%ebp
  802255:	89 d6                	mov    %edx,%esi
  802257:	88 d9                	mov    %bl,%cl
  802259:	d3 ee                	shr    %cl,%esi
  80225b:	89 f9                	mov    %edi,%ecx
  80225d:	d3 e2                	shl    %cl,%edx
  80225f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802263:	88 d9                	mov    %bl,%cl
  802265:	d3 e8                	shr    %cl,%eax
  802267:	09 c2                	or     %eax,%edx
  802269:	89 d0                	mov    %edx,%eax
  80226b:	89 f2                	mov    %esi,%edx
  80226d:	f7 74 24 0c          	divl   0xc(%esp)
  802271:	89 d6                	mov    %edx,%esi
  802273:	89 c3                	mov    %eax,%ebx
  802275:	f7 e5                	mul    %ebp
  802277:	39 d6                	cmp    %edx,%esi
  802279:	72 19                	jb     802294 <__udivdi3+0xfc>
  80227b:	74 0b                	je     802288 <__udivdi3+0xf0>
  80227d:	89 d8                	mov    %ebx,%eax
  80227f:	31 ff                	xor    %edi,%edi
  802281:	e9 58 ff ff ff       	jmp    8021de <__udivdi3+0x46>
  802286:	66 90                	xchg   %ax,%ax
  802288:	8b 54 24 08          	mov    0x8(%esp),%edx
  80228c:	89 f9                	mov    %edi,%ecx
  80228e:	d3 e2                	shl    %cl,%edx
  802290:	39 c2                	cmp    %eax,%edx
  802292:	73 e9                	jae    80227d <__udivdi3+0xe5>
  802294:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802297:	31 ff                	xor    %edi,%edi
  802299:	e9 40 ff ff ff       	jmp    8021de <__udivdi3+0x46>
  80229e:	66 90                	xchg   %ax,%ax
  8022a0:	31 c0                	xor    %eax,%eax
  8022a2:	e9 37 ff ff ff       	jmp    8021de <__udivdi3+0x46>
  8022a7:	90                   	nop

008022a8 <__umoddi3>:
  8022a8:	55                   	push   %ebp
  8022a9:	57                   	push   %edi
  8022aa:	56                   	push   %esi
  8022ab:	53                   	push   %ebx
  8022ac:	83 ec 1c             	sub    $0x1c,%esp
  8022af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8022b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022c7:	89 f3                	mov    %esi,%ebx
  8022c9:	89 fa                	mov    %edi,%edx
  8022cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022cf:	89 34 24             	mov    %esi,(%esp)
  8022d2:	85 c0                	test   %eax,%eax
  8022d4:	75 1a                	jne    8022f0 <__umoddi3+0x48>
  8022d6:	39 f7                	cmp    %esi,%edi
  8022d8:	0f 86 a2 00 00 00    	jbe    802380 <__umoddi3+0xd8>
  8022de:	89 c8                	mov    %ecx,%eax
  8022e0:	89 f2                	mov    %esi,%edx
  8022e2:	f7 f7                	div    %edi
  8022e4:	89 d0                	mov    %edx,%eax
  8022e6:	31 d2                	xor    %edx,%edx
  8022e8:	83 c4 1c             	add    $0x1c,%esp
  8022eb:	5b                   	pop    %ebx
  8022ec:	5e                   	pop    %esi
  8022ed:	5f                   	pop    %edi
  8022ee:	5d                   	pop    %ebp
  8022ef:	c3                   	ret    
  8022f0:	39 f0                	cmp    %esi,%eax
  8022f2:	0f 87 ac 00 00 00    	ja     8023a4 <__umoddi3+0xfc>
  8022f8:	0f bd e8             	bsr    %eax,%ebp
  8022fb:	83 f5 1f             	xor    $0x1f,%ebp
  8022fe:	0f 84 ac 00 00 00    	je     8023b0 <__umoddi3+0x108>
  802304:	bf 20 00 00 00       	mov    $0x20,%edi
  802309:	29 ef                	sub    %ebp,%edi
  80230b:	89 fe                	mov    %edi,%esi
  80230d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802311:	89 e9                	mov    %ebp,%ecx
  802313:	d3 e0                	shl    %cl,%eax
  802315:	89 d7                	mov    %edx,%edi
  802317:	89 f1                	mov    %esi,%ecx
  802319:	d3 ef                	shr    %cl,%edi
  80231b:	09 c7                	or     %eax,%edi
  80231d:	89 e9                	mov    %ebp,%ecx
  80231f:	d3 e2                	shl    %cl,%edx
  802321:	89 14 24             	mov    %edx,(%esp)
  802324:	89 d8                	mov    %ebx,%eax
  802326:	d3 e0                	shl    %cl,%eax
  802328:	89 c2                	mov    %eax,%edx
  80232a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80232e:	d3 e0                	shl    %cl,%eax
  802330:	89 44 24 04          	mov    %eax,0x4(%esp)
  802334:	8b 44 24 08          	mov    0x8(%esp),%eax
  802338:	89 f1                	mov    %esi,%ecx
  80233a:	d3 e8                	shr    %cl,%eax
  80233c:	09 d0                	or     %edx,%eax
  80233e:	d3 eb                	shr    %cl,%ebx
  802340:	89 da                	mov    %ebx,%edx
  802342:	f7 f7                	div    %edi
  802344:	89 d3                	mov    %edx,%ebx
  802346:	f7 24 24             	mull   (%esp)
  802349:	89 c6                	mov    %eax,%esi
  80234b:	89 d1                	mov    %edx,%ecx
  80234d:	39 d3                	cmp    %edx,%ebx
  80234f:	0f 82 87 00 00 00    	jb     8023dc <__umoddi3+0x134>
  802355:	0f 84 91 00 00 00    	je     8023ec <__umoddi3+0x144>
  80235b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80235f:	29 f2                	sub    %esi,%edx
  802361:	19 cb                	sbb    %ecx,%ebx
  802363:	89 d8                	mov    %ebx,%eax
  802365:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802369:	d3 e0                	shl    %cl,%eax
  80236b:	89 e9                	mov    %ebp,%ecx
  80236d:	d3 ea                	shr    %cl,%edx
  80236f:	09 d0                	or     %edx,%eax
  802371:	89 e9                	mov    %ebp,%ecx
  802373:	d3 eb                	shr    %cl,%ebx
  802375:	89 da                	mov    %ebx,%edx
  802377:	83 c4 1c             	add    $0x1c,%esp
  80237a:	5b                   	pop    %ebx
  80237b:	5e                   	pop    %esi
  80237c:	5f                   	pop    %edi
  80237d:	5d                   	pop    %ebp
  80237e:	c3                   	ret    
  80237f:	90                   	nop
  802380:	89 fd                	mov    %edi,%ebp
  802382:	85 ff                	test   %edi,%edi
  802384:	75 0b                	jne    802391 <__umoddi3+0xe9>
  802386:	b8 01 00 00 00       	mov    $0x1,%eax
  80238b:	31 d2                	xor    %edx,%edx
  80238d:	f7 f7                	div    %edi
  80238f:	89 c5                	mov    %eax,%ebp
  802391:	89 f0                	mov    %esi,%eax
  802393:	31 d2                	xor    %edx,%edx
  802395:	f7 f5                	div    %ebp
  802397:	89 c8                	mov    %ecx,%eax
  802399:	f7 f5                	div    %ebp
  80239b:	89 d0                	mov    %edx,%eax
  80239d:	e9 44 ff ff ff       	jmp    8022e6 <__umoddi3+0x3e>
  8023a2:	66 90                	xchg   %ax,%ax
  8023a4:	89 c8                	mov    %ecx,%eax
  8023a6:	89 f2                	mov    %esi,%edx
  8023a8:	83 c4 1c             	add    $0x1c,%esp
  8023ab:	5b                   	pop    %ebx
  8023ac:	5e                   	pop    %esi
  8023ad:	5f                   	pop    %edi
  8023ae:	5d                   	pop    %ebp
  8023af:	c3                   	ret    
  8023b0:	3b 04 24             	cmp    (%esp),%eax
  8023b3:	72 06                	jb     8023bb <__umoddi3+0x113>
  8023b5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8023b9:	77 0f                	ja     8023ca <__umoddi3+0x122>
  8023bb:	89 f2                	mov    %esi,%edx
  8023bd:	29 f9                	sub    %edi,%ecx
  8023bf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8023c3:	89 14 24             	mov    %edx,(%esp)
  8023c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023ce:	8b 14 24             	mov    (%esp),%edx
  8023d1:	83 c4 1c             	add    $0x1c,%esp
  8023d4:	5b                   	pop    %ebx
  8023d5:	5e                   	pop    %esi
  8023d6:	5f                   	pop    %edi
  8023d7:	5d                   	pop    %ebp
  8023d8:	c3                   	ret    
  8023d9:	8d 76 00             	lea    0x0(%esi),%esi
  8023dc:	2b 04 24             	sub    (%esp),%eax
  8023df:	19 fa                	sbb    %edi,%edx
  8023e1:	89 d1                	mov    %edx,%ecx
  8023e3:	89 c6                	mov    %eax,%esi
  8023e5:	e9 71 ff ff ff       	jmp    80235b <__umoddi3+0xb3>
  8023ea:	66 90                	xchg   %ax,%ax
  8023ec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8023f0:	72 ea                	jb     8023dc <__umoddi3+0x134>
  8023f2:	89 d9                	mov    %ebx,%ecx
  8023f4:	e9 62 ff ff ff       	jmp    80235b <__umoddi3+0xb3>
