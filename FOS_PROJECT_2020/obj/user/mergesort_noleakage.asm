
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 8f 07 00 00       	call   8007c5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_disable_interrupt();
  800041:	e8 da 1d 00 00       	call   801e20 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 24 80 00       	push   $0x8024c0
  80004e:	e8 59 0b 00 00       	call   800bac <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 24 80 00       	push   $0x8024c2
  80005e:	e8 49 0b 00 00       	call   800bac <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 d8 24 80 00       	push   $0x8024d8
  80006e:	e8 39 0b 00 00       	call   800bac <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 24 80 00       	push   $0x8024c2
  80007e:	e8 29 0b 00 00       	call   800bac <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 24 80 00       	push   $0x8024c0
  80008e:	e8 19 0b 00 00       	call   800bac <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 f0 24 80 00       	push   $0x8024f0
  8000a5:	e8 84 11 00 00       	call   80122e <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 d4 16 00 00       	call   801794 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 67 1a 00 00       	call   801b3c <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 10 25 80 00       	push   $0x802510
  8000e3:	e8 c4 0a 00 00       	call   800bac <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 32 25 80 00       	push   $0x802532
  8000f3:	e8 b4 0a 00 00       	call   800bac <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 40 25 80 00       	push   $0x802540
  800103:	e8 a4 0a 00 00       	call   800bac <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 4f 25 80 00       	push   $0x80254f
  800113:	e8 94 0a 00 00       	call   800bac <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 5f 25 80 00       	push   $0x80255f
  800123:	e8 84 0a 00 00       	call   800bac <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 3d 06 00 00       	call   80076d <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 e5 05 00 00       	call   800725 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 d8 05 00 00       	call   800725 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 d3 1c 00 00       	call   801e3a <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 f4 01 00 00       	call   80037c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 12 02 00 00       	call   8003ad <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 34 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 21 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 e0 02 00 00       	call   8004b4 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 44 1c 00 00       	call   801e20 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 68 25 80 00       	push   $0x802568
  8001e4:	e8 c3 09 00 00       	call   800bac <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 49 1c 00 00       	call   801e3a <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 d3 00 00 00       	call   8002d2 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 9c 25 80 00       	push   $0x80259c
  800213:	6a 4a                	push   $0x4a
  800215:	68 be 25 80 00       	push   $0x8025be
  80021a:	e8 eb 06 00 00       	call   80090a <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 fc 1b 00 00       	call   801e20 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 dc 25 80 00       	push   $0x8025dc
  80022c:	e8 7b 09 00 00       	call   800bac <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 10 26 80 00       	push   $0x802610
  80023c:	e8 6b 09 00 00       	call   800bac <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 44 26 80 00       	push   $0x802644
  80024c:	e8 5b 09 00 00       	call   800bac <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 e1 1b 00 00       	call   801e3a <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 2c 19 00 00       	call   801b90 <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 b4 1b 00 00       	call   801e20 <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 76 26 80 00       	push   $0x802676
  80027a:	e8 2d 09 00 00       	call   800bac <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800282:	e8 e6 04 00 00       	call   80076d <getchar>
  800287:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80028a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	e8 8e 04 00 00       	call   800725 <cputchar>
  800297:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	6a 0a                	push   $0xa
  80029f:	e8 81 04 00 00       	call   800725 <cputchar>
  8002a4:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	6a 0a                	push   $0xa
  8002ac:	e8 74 04 00 00       	call   800725 <cputchar>
  8002b1:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b8:	74 06                	je     8002c0 <_main+0x288>
  8002ba:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002be:	75 b2                	jne    800272 <_main+0x23a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002c0:	e8 75 1b 00 00       	call   801e3a <sys_enable_interrupt>

	} while (Chose == 'y');
  8002c5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c9:	0f 84 72 fd ff ff    	je     800041 <_main+0x9>

}
  8002cf:	90                   	nop
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002e6:	eb 33                	jmp    80031b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8b 10                	mov    (%eax),%edx
  8002f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002fc:	40                   	inc    %eax
  8002fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	01 c8                	add    %ecx,%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	39 c2                	cmp    %eax,%edx
  80030d:	7e 09                	jle    800318 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80030f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800316:	eb 0c                	jmp    800324 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800318:	ff 45 f8             	incl   -0x8(%ebp)
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	48                   	dec    %eax
  80031f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800322:	7f c4                	jg     8002e8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800324:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	01 d0                	add    %edx,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	01 c2                	add    %eax,%edx
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	01 c8                	add    %ecx,%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800365:	8b 45 10             	mov    0x10(%ebp),%eax
  800368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	01 c2                	add    %eax,%edx
  800374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800377:	89 02                	mov    %eax,(%edx)
}
  800379:	90                   	nop
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800389:	eb 17                	jmp    8003a2 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80038b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 c2                	add    %eax,%edx
  80039a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80039f:	ff 45 fc             	incl   -0x4(%ebp)
  8003a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003a8:	7c e1                	jl     80038b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003aa:	90                   	nop
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ba:	eb 1b                	jmp    8003d7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	01 c2                	add    %eax,%edx
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ce:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003d1:	48                   	dec    %eax
  8003d2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003d4:	ff 45 fc             	incl   -0x4(%ebp)
  8003d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003dd:	7c dd                	jl     8003bc <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003df:	90                   	nop
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003f0:	f7 e9                	imul   %ecx
  8003f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	29 c8                	sub    %ecx,%eax
  8003f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800403:	eb 1e                	jmp    800423 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	99                   	cltd   
  800419:	f7 7d f8             	idivl  -0x8(%ebp)
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 fc             	incl   -0x4(%ebp)
  800423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	7c da                	jl     800405 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80042b:	90                   	nop
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800434:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800442:	eb 42                	jmp    800486 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800447:	99                   	cltd   
  800448:	f7 7d f0             	idivl  -0x10(%ebp)
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	85 c0                	test   %eax,%eax
  80044f:	75 10                	jne    800461 <PrintElements+0x33>
			cprintf("\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 c0 24 80 00       	push   $0x8024c0
  800459:	e8 4e 07 00 00       	call   800bac <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800464:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 d0                	add    %edx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	50                   	push   %eax
  800476:	68 94 26 80 00       	push   $0x802694
  80047b:	e8 2c 07 00 00       	call   800bac <cprintf>
  800480:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800483:	ff 45 f4             	incl   -0xc(%ebp)
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	48                   	dec    %eax
  80048a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80048d:	7f b5                	jg     800444 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	01 d0                	add    %edx,%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 99 26 80 00       	push   $0x802699
  8004a9:	e8 fe 06 00 00       	call   800bac <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp

}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c0:	7d 54                	jge    800516 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	89 c2                	mov    %eax,%edx
  8004cc:	c1 ea 1f             	shr    $0x1f,%edx
  8004cf:	01 d0                	add    %edx,%eax
  8004d1:	d1 f8                	sar    %eax
  8004d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dc:	ff 75 0c             	pushl  0xc(%ebp)
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	e8 cd ff ff ff       	call   8004b4 <MSort>
  8004e7:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ed:	40                   	inc    %eax
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	ff 75 10             	pushl  0x10(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	ff 75 08             	pushl  0x8(%ebp)
  8004f8:	e8 b7 ff ff ff       	call   8004b4 <MSort>
  8004fd:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800500:	ff 75 10             	pushl  0x10(%ebp)
  800503:	ff 75 f4             	pushl  -0xc(%ebp)
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	e8 08 00 00 00       	call   800519 <Merge>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	eb 01                	jmp    800517 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800516:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80051f:	8b 45 10             	mov    0x10(%ebp),%eax
  800522:	2b 45 0c             	sub    0xc(%ebp),%eax
  800525:	40                   	inc    %eax
  800526:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	2b 45 10             	sub    0x10(%ebp),%eax
  80052f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800532:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	c1 e0 02             	shl    $0x2,%eax
  800546:	83 ec 0c             	sub    $0xc,%esp
  800549:	50                   	push   %eax
  80054a:	e8 ed 15 00 00       	call   801b3c <malloc>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  800555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800558:	c1 e0 02             	shl    $0x2,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 d8 15 00 00       	call   801b3c <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800571:	eb 2f                	jmp    8005a2 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800576:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800580:	01 c2                	add    %eax,%edx
  800582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80058f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80059f:	ff 45 ec             	incl   -0x14(%ebp)
  8005a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005a8:	7c c9                	jl     800573 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b1:	eb 2a                	jmp    8005dd <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c0:	01 c2                	add    %eax,%edx
  8005c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	01 c8                	add    %ecx,%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e3:	7c ce                	jl     8005b3 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005eb:	e9 0a 01 00 00       	jmp    8006fa <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005f6:	0f 8d 95 00 00 00    	jge    800691 <Merge+0x178>
  8005fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800602:	0f 8d 89 00 00 00    	jge    800691 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800612:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800615:	01 d0                	add    %edx,%eax
  800617:	8b 10                	mov    (%eax),%edx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800626:	01 c8                	add    %ecx,%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	7d 33                	jge    800661 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80062e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800631:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800636:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800646:	8d 50 01             	lea    0x1(%eax),%edx
  800649:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80064c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800653:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800656:	01 d0                	add    %edx,%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80065c:	e9 96 00 00 00       	jmp    8006f7 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800664:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800669:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800679:	8d 50 01             	lea    0x1(%eax),%edx
  80067c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80067f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80068f:	eb 66                	jmp    8006f7 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800694:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800697:	7d 30                	jge    8006c9 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b1:	8d 50 01             	lea    0x1(%eax),%edx
  8006b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c1:	01 d0                	add    %edx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 01                	mov    %eax,(%ecx)
  8006c7:	eb 2e                	jmp    8006f7 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006cc:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8d 50 01             	lea    0x1(%eax),%edx
  8006e4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f1:	01 d0                	add    %edx,%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006f7:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800700:	0f 8e ea fe ff ff    	jle    8005f0 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d8             	pushl  -0x28(%ebp)
  80070c:	e8 7f 14 00 00       	call   801b90 <free>
  800711:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071a:	e8 71 14 00 00       	call   801b90 <free>
  80071f:	83 c4 10             	add    $0x10,%esp

}
  800722:	90                   	nop
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800731:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	50                   	push   %eax
  800739:	e8 16 17 00 00       	call   801e54 <sys_cputc>
  80073e:	83 c4 10             	add    $0x10,%esp
}
  800741:	90                   	nop
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80074a:	e8 d1 16 00 00       	call   801e20 <sys_disable_interrupt>
	char c = ch;
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800755:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	50                   	push   %eax
  80075d:	e8 f2 16 00 00       	call   801e54 <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 d0 16 00 00       	call   801e3a <sys_enable_interrupt>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <getchar>:

int
getchar(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80077a:	eb 08                	jmp    800784 <getchar+0x17>
	{
		c = sys_cgetc();
  80077c:	e8 b7 14 00 00       	call   801c38 <sys_cgetc>
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800788:	74 f2                	je     80077c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <atomic_getchar>:

int
atomic_getchar(void)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800795:	e8 86 16 00 00       	call   801e20 <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 90 14 00 00       	call   801c38 <sys_cgetc>
  8007a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007af:	74 f2                	je     8007a3 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007b1:	e8 84 16 00 00       	call   801e3a <sys_enable_interrupt>
	return c;
  8007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <iscons>:

int iscons(int fdnum)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007cb:	e8 b5 14 00 00       	call   801c85 <sys_getenvindex>
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d6:	89 d0                	mov    %edx,%eax
  8007d8:	c1 e0 03             	shl    $0x3,%eax
  8007db:	01 d0                	add    %edx,%eax
  8007dd:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8007e4:	01 c8                	add    %ecx,%eax
  8007e6:	01 c0                	add    %eax,%eax
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	01 c0                	add    %eax,%eax
  8007ec:	01 d0                	add    %edx,%eax
  8007ee:	89 c2                	mov    %eax,%edx
  8007f0:	c1 e2 05             	shl    $0x5,%edx
  8007f3:	29 c2                	sub    %eax,%edx
  8007f5:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8007fc:	89 c2                	mov    %eax,%edx
  8007fe:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800804:	a3 24 30 80 00       	mov    %eax,0x803024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800809:	a1 24 30 80 00       	mov    0x803024,%eax
  80080e:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800814:	84 c0                	test   %al,%al
  800816:	74 0f                	je     800827 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800818:	a1 24 30 80 00       	mov    0x803024,%eax
  80081d:	05 40 3c 01 00       	add    $0x13c40,%eax
  800822:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800827:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80082b:	7e 0a                	jle    800837 <libmain+0x72>
		binaryname = argv[0];
  80082d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	ff 75 08             	pushl  0x8(%ebp)
  800840:	e8 f3 f7 ff ff       	call   800038 <_main>
  800845:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800848:	e8 d3 15 00 00       	call   801e20 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80084d:	83 ec 0c             	sub    $0xc,%esp
  800850:	68 b8 26 80 00       	push   $0x8026b8
  800855:	e8 52 03 00 00       	call   800bac <cprintf>
  80085a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80085d:	a1 24 30 80 00       	mov    0x803024,%eax
  800862:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800868:	a1 24 30 80 00       	mov    0x803024,%eax
  80086d:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800873:	83 ec 04             	sub    $0x4,%esp
  800876:	52                   	push   %edx
  800877:	50                   	push   %eax
  800878:	68 e0 26 80 00       	push   $0x8026e0
  80087d:	e8 2a 03 00 00       	call   800bac <cprintf>
  800882:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800885:	a1 24 30 80 00       	mov    0x803024,%eax
  80088a:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800890:	a1 24 30 80 00       	mov    0x803024,%eax
  800895:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80089b:	83 ec 04             	sub    $0x4,%esp
  80089e:	52                   	push   %edx
  80089f:	50                   	push   %eax
  8008a0:	68 08 27 80 00       	push   $0x802708
  8008a5:	e8 02 03 00 00       	call   800bac <cprintf>
  8008aa:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008ad:	a1 24 30 80 00       	mov    0x803024,%eax
  8008b2:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	50                   	push   %eax
  8008bc:	68 49 27 80 00       	push   $0x802749
  8008c1:	e8 e6 02 00 00       	call   800bac <cprintf>
  8008c6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008c9:	83 ec 0c             	sub    $0xc,%esp
  8008cc:	68 b8 26 80 00       	push   $0x8026b8
  8008d1:	e8 d6 02 00 00       	call   800bac <cprintf>
  8008d6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008d9:	e8 5c 15 00 00       	call   801e3a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008de:	e8 19 00 00 00       	call   8008fc <exit>
}
  8008e3:	90                   	nop
  8008e4:	c9                   	leave  
  8008e5:	c3                   	ret    

008008e6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8008ec:	83 ec 0c             	sub    $0xc,%esp
  8008ef:	6a 00                	push   $0x0
  8008f1:	e8 5b 13 00 00       	call   801c51 <sys_env_destroy>
  8008f6:	83 c4 10             	add    $0x10,%esp
}
  8008f9:	90                   	nop
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <exit>:

void
exit(void)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800902:	e8 b0 13 00 00       	call   801cb7 <sys_env_exit>
}
  800907:	90                   	nop
  800908:	c9                   	leave  
  800909:	c3                   	ret    

0080090a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800910:	8d 45 10             	lea    0x10(%ebp),%eax
  800913:	83 c0 04             	add    $0x4,%eax
  800916:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800919:	a1 18 31 80 00       	mov    0x803118,%eax
  80091e:	85 c0                	test   %eax,%eax
  800920:	74 16                	je     800938 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800922:	a1 18 31 80 00       	mov    0x803118,%eax
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	50                   	push   %eax
  80092b:	68 60 27 80 00       	push   $0x802760
  800930:	e8 77 02 00 00       	call   800bac <cprintf>
  800935:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800938:	a1 00 30 80 00       	mov    0x803000,%eax
  80093d:	ff 75 0c             	pushl  0xc(%ebp)
  800940:	ff 75 08             	pushl  0x8(%ebp)
  800943:	50                   	push   %eax
  800944:	68 65 27 80 00       	push   $0x802765
  800949:	e8 5e 02 00 00       	call   800bac <cprintf>
  80094e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800951:	8b 45 10             	mov    0x10(%ebp),%eax
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	ff 75 f4             	pushl  -0xc(%ebp)
  80095a:	50                   	push   %eax
  80095b:	e8 e1 01 00 00       	call   800b41 <vcprintf>
  800960:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	6a 00                	push   $0x0
  800968:	68 81 27 80 00       	push   $0x802781
  80096d:	e8 cf 01 00 00       	call   800b41 <vcprintf>
  800972:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800975:	e8 82 ff ff ff       	call   8008fc <exit>

	// should not return here
	while (1) ;
  80097a:	eb fe                	jmp    80097a <_panic+0x70>

0080097c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800982:	a1 24 30 80 00       	mov    0x803024,%eax
  800987:	8b 50 74             	mov    0x74(%eax),%edx
  80098a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098d:	39 c2                	cmp    %eax,%edx
  80098f:	74 14                	je     8009a5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800991:	83 ec 04             	sub    $0x4,%esp
  800994:	68 84 27 80 00       	push   $0x802784
  800999:	6a 26                	push   $0x26
  80099b:	68 d0 27 80 00       	push   $0x8027d0
  8009a0:	e8 65 ff ff ff       	call   80090a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b3:	e9 b6 00 00 00       	jmp    800a6e <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8009b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	01 d0                	add    %edx,%eax
  8009c7:	8b 00                	mov    (%eax),%eax
  8009c9:	85 c0                	test   %eax,%eax
  8009cb:	75 08                	jne    8009d5 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009cd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009d0:	e9 96 00 00 00       	jmp    800a6b <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8009d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009e3:	eb 5d                	jmp    800a42 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009e5:	a1 24 30 80 00       	mov    0x803024,%eax
  8009ea:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8009f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f3:	c1 e2 04             	shl    $0x4,%edx
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	8a 40 04             	mov    0x4(%eax),%al
  8009fb:	84 c0                	test   %al,%al
  8009fd:	75 40                	jne    800a3f <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ff:	a1 24 30 80 00       	mov    0x803024,%eax
  800a04:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800a0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a0d:	c1 e2 04             	shl    $0x4,%edx
  800a10:	01 d0                	add    %edx,%eax
  800a12:	8b 00                	mov    (%eax),%eax
  800a14:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a1a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a1f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a24:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	01 c8                	add    %ecx,%eax
  800a30:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a32:	39 c2                	cmp    %eax,%edx
  800a34:	75 09                	jne    800a3f <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800a36:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a3d:	eb 12                	jmp    800a51 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a3f:	ff 45 e8             	incl   -0x18(%ebp)
  800a42:	a1 24 30 80 00       	mov    0x803024,%eax
  800a47:	8b 50 74             	mov    0x74(%eax),%edx
  800a4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a4d:	39 c2                	cmp    %eax,%edx
  800a4f:	77 94                	ja     8009e5 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a51:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a55:	75 14                	jne    800a6b <CheckWSWithoutLastIndex+0xef>
			panic(
  800a57:	83 ec 04             	sub    $0x4,%esp
  800a5a:	68 dc 27 80 00       	push   $0x8027dc
  800a5f:	6a 3a                	push   $0x3a
  800a61:	68 d0 27 80 00       	push   $0x8027d0
  800a66:	e8 9f fe ff ff       	call   80090a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a6b:	ff 45 f0             	incl   -0x10(%ebp)
  800a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a71:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a74:	0f 8c 3e ff ff ff    	jl     8009b8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a7a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a81:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a88:	eb 20                	jmp    800aaa <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a8a:	a1 24 30 80 00       	mov    0x803024,%eax
  800a8f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800a95:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a98:	c1 e2 04             	shl    $0x4,%edx
  800a9b:	01 d0                	add    %edx,%eax
  800a9d:	8a 40 04             	mov    0x4(%eax),%al
  800aa0:	3c 01                	cmp    $0x1,%al
  800aa2:	75 03                	jne    800aa7 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800aa4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa7:	ff 45 e0             	incl   -0x20(%ebp)
  800aaa:	a1 24 30 80 00       	mov    0x803024,%eax
  800aaf:	8b 50 74             	mov    0x74(%eax),%edx
  800ab2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab5:	39 c2                	cmp    %eax,%edx
  800ab7:	77 d1                	ja     800a8a <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800abc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800abf:	74 14                	je     800ad5 <CheckWSWithoutLastIndex+0x159>
		panic(
  800ac1:	83 ec 04             	sub    $0x4,%esp
  800ac4:	68 30 28 80 00       	push   $0x802830
  800ac9:	6a 44                	push   $0x44
  800acb:	68 d0 27 80 00       	push   $0x8027d0
  800ad0:	e8 35 fe ff ff       	call   80090a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ad5:	90                   	nop
  800ad6:	c9                   	leave  
  800ad7:	c3                   	ret    

00800ad8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae1:	8b 00                	mov    (%eax),%eax
  800ae3:	8d 48 01             	lea    0x1(%eax),%ecx
  800ae6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae9:	89 0a                	mov    %ecx,(%edx)
  800aeb:	8b 55 08             	mov    0x8(%ebp),%edx
  800aee:	88 d1                	mov    %dl,%cl
  800af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afa:	8b 00                	mov    (%eax),%eax
  800afc:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b01:	75 2c                	jne    800b2f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b03:	a0 28 30 80 00       	mov    0x803028,%al
  800b08:	0f b6 c0             	movzbl %al,%eax
  800b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0e:	8b 12                	mov    (%edx),%edx
  800b10:	89 d1                	mov    %edx,%ecx
  800b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b15:	83 c2 08             	add    $0x8,%edx
  800b18:	83 ec 04             	sub    $0x4,%esp
  800b1b:	50                   	push   %eax
  800b1c:	51                   	push   %ecx
  800b1d:	52                   	push   %edx
  800b1e:	e8 ec 10 00 00       	call   801c0f <sys_cputs>
  800b23:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	8b 40 04             	mov    0x4(%eax),%eax
  800b35:	8d 50 01             	lea    0x1(%eax),%edx
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b3e:	90                   	nop
  800b3f:	c9                   	leave  
  800b40:	c3                   	ret    

00800b41 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b4a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b51:	00 00 00 
	b.cnt = 0;
  800b54:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b5b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	ff 75 08             	pushl  0x8(%ebp)
  800b64:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b6a:	50                   	push   %eax
  800b6b:	68 d8 0a 80 00       	push   $0x800ad8
  800b70:	e8 11 02 00 00       	call   800d86 <vprintfmt>
  800b75:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b78:	a0 28 30 80 00       	mov    0x803028,%al
  800b7d:	0f b6 c0             	movzbl %al,%eax
  800b80:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b86:	83 ec 04             	sub    $0x4,%esp
  800b89:	50                   	push   %eax
  800b8a:	52                   	push   %edx
  800b8b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b91:	83 c0 08             	add    $0x8,%eax
  800b94:	50                   	push   %eax
  800b95:	e8 75 10 00 00       	call   801c0f <sys_cputs>
  800b9a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b9d:	c6 05 28 30 80 00 00 	movb   $0x0,0x803028
	return b.cnt;
  800ba4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800baa:	c9                   	leave  
  800bab:	c3                   	ret    

00800bac <cprintf>:

int cprintf(const char *fmt, ...) {
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bb2:	c6 05 28 30 80 00 01 	movb   $0x1,0x803028
	va_start(ap, fmt);
  800bb9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	83 ec 08             	sub    $0x8,%esp
  800bc5:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc8:	50                   	push   %eax
  800bc9:	e8 73 ff ff ff       	call   800b41 <vcprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
  800bd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd7:	c9                   	leave  
  800bd8:	c3                   	ret    

00800bd9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bdf:	e8 3c 12 00 00       	call   801e20 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800be4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf3:	50                   	push   %eax
  800bf4:	e8 48 ff ff ff       	call   800b41 <vcprintf>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bff:	e8 36 12 00 00       	call   801e3a <sys_enable_interrupt>
	return cnt;
  800c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c07:	c9                   	leave  
  800c08:	c3                   	ret    

00800c09 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	53                   	push   %ebx
  800c0d:	83 ec 14             	sub    $0x14,%esp
  800c10:	8b 45 10             	mov    0x10(%ebp),%eax
  800c13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c16:	8b 45 14             	mov    0x14(%ebp),%eax
  800c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c1c:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c24:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c27:	77 55                	ja     800c7e <printnum+0x75>
  800c29:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c2c:	72 05                	jb     800c33 <printnum+0x2a>
  800c2e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c31:	77 4b                	ja     800c7e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c33:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c36:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c39:	8b 45 18             	mov    0x18(%ebp),%eax
  800c3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c41:	52                   	push   %edx
  800c42:	50                   	push   %eax
  800c43:	ff 75 f4             	pushl  -0xc(%ebp)
  800c46:	ff 75 f0             	pushl  -0x10(%ebp)
  800c49:	e8 f2 15 00 00       	call   802240 <__udivdi3>
  800c4e:	83 c4 10             	add    $0x10,%esp
  800c51:	83 ec 04             	sub    $0x4,%esp
  800c54:	ff 75 20             	pushl  0x20(%ebp)
  800c57:	53                   	push   %ebx
  800c58:	ff 75 18             	pushl  0x18(%ebp)
  800c5b:	52                   	push   %edx
  800c5c:	50                   	push   %eax
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	ff 75 08             	pushl  0x8(%ebp)
  800c63:	e8 a1 ff ff ff       	call   800c09 <printnum>
  800c68:	83 c4 20             	add    $0x20,%esp
  800c6b:	eb 1a                	jmp    800c87 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c6d:	83 ec 08             	sub    $0x8,%esp
  800c70:	ff 75 0c             	pushl  0xc(%ebp)
  800c73:	ff 75 20             	pushl  0x20(%ebp)
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	ff d0                	call   *%eax
  800c7b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c7e:	ff 4d 1c             	decl   0x1c(%ebp)
  800c81:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c85:	7f e6                	jg     800c6d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c87:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c95:	53                   	push   %ebx
  800c96:	51                   	push   %ecx
  800c97:	52                   	push   %edx
  800c98:	50                   	push   %eax
  800c99:	e8 b2 16 00 00       	call   802350 <__umoddi3>
  800c9e:	83 c4 10             	add    $0x10,%esp
  800ca1:	05 94 2a 80 00       	add    $0x802a94,%eax
  800ca6:	8a 00                	mov    (%eax),%al
  800ca8:	0f be c0             	movsbl %al,%eax
  800cab:	83 ec 08             	sub    $0x8,%esp
  800cae:	ff 75 0c             	pushl  0xc(%ebp)
  800cb1:	50                   	push   %eax
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	ff d0                	call   *%eax
  800cb7:	83 c4 10             	add    $0x10,%esp
}
  800cba:	90                   	nop
  800cbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cbe:	c9                   	leave  
  800cbf:	c3                   	ret    

00800cc0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cc3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cc7:	7e 1c                	jle    800ce5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8b 00                	mov    (%eax),%eax
  800cce:	8d 50 08             	lea    0x8(%eax),%edx
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	89 10                	mov    %edx,(%eax)
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8b 00                	mov    (%eax),%eax
  800cdb:	83 e8 08             	sub    $0x8,%eax
  800cde:	8b 50 04             	mov    0x4(%eax),%edx
  800ce1:	8b 00                	mov    (%eax),%eax
  800ce3:	eb 40                	jmp    800d25 <getuint+0x65>
	else if (lflag)
  800ce5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce9:	74 1e                	je     800d09 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8b 00                	mov    (%eax),%eax
  800cf0:	8d 50 04             	lea    0x4(%eax),%edx
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	89 10                	mov    %edx,(%eax)
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8b 00                	mov    (%eax),%eax
  800cfd:	83 e8 04             	sub    $0x4,%eax
  800d00:	8b 00                	mov    (%eax),%eax
  800d02:	ba 00 00 00 00       	mov    $0x0,%edx
  800d07:	eb 1c                	jmp    800d25 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8b 00                	mov    (%eax),%eax
  800d0e:	8d 50 04             	lea    0x4(%eax),%edx
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	89 10                	mov    %edx,(%eax)
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8b 00                	mov    (%eax),%eax
  800d1b:	83 e8 04             	sub    $0x4,%eax
  800d1e:	8b 00                	mov    (%eax),%eax
  800d20:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    

00800d27 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d2a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d2e:	7e 1c                	jle    800d4c <getint+0x25>
		return va_arg(*ap, long long);
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8b 00                	mov    (%eax),%eax
  800d35:	8d 50 08             	lea    0x8(%eax),%edx
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	89 10                	mov    %edx,(%eax)
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8b 00                	mov    (%eax),%eax
  800d42:	83 e8 08             	sub    $0x8,%eax
  800d45:	8b 50 04             	mov    0x4(%eax),%edx
  800d48:	8b 00                	mov    (%eax),%eax
  800d4a:	eb 38                	jmp    800d84 <getint+0x5d>
	else if (lflag)
  800d4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d50:	74 1a                	je     800d6c <getint+0x45>
		return va_arg(*ap, long);
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8b 00                	mov    (%eax),%eax
  800d57:	8d 50 04             	lea    0x4(%eax),%edx
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	89 10                	mov    %edx,(%eax)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8b 00                	mov    (%eax),%eax
  800d64:	83 e8 04             	sub    $0x4,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	99                   	cltd   
  800d6a:	eb 18                	jmp    800d84 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8b 00                	mov    (%eax),%eax
  800d71:	8d 50 04             	lea    0x4(%eax),%edx
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	89 10                	mov    %edx,(%eax)
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	83 e8 04             	sub    $0x4,%eax
  800d81:	8b 00                	mov    (%eax),%eax
  800d83:	99                   	cltd   
}
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d8e:	eb 17                	jmp    800da7 <vprintfmt+0x21>
			if (ch == '\0')
  800d90:	85 db                	test   %ebx,%ebx
  800d92:	0f 84 af 03 00 00    	je     801147 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d98:	83 ec 08             	sub    $0x8,%esp
  800d9b:	ff 75 0c             	pushl  0xc(%ebp)
  800d9e:	53                   	push   %ebx
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	ff d0                	call   *%eax
  800da4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da7:	8b 45 10             	mov    0x10(%ebp),%eax
  800daa:	8d 50 01             	lea    0x1(%eax),%edx
  800dad:	89 55 10             	mov    %edx,0x10(%ebp)
  800db0:	8a 00                	mov    (%eax),%al
  800db2:	0f b6 d8             	movzbl %al,%ebx
  800db5:	83 fb 25             	cmp    $0x25,%ebx
  800db8:	75 d6                	jne    800d90 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dba:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dbe:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dc5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dcc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800dd3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dda:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddd:	8d 50 01             	lea    0x1(%eax),%edx
  800de0:	89 55 10             	mov    %edx,0x10(%ebp)
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 d8             	movzbl %al,%ebx
  800de8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800deb:	83 f8 55             	cmp    $0x55,%eax
  800dee:	0f 87 2b 03 00 00    	ja     80111f <vprintfmt+0x399>
  800df4:	8b 04 85 b8 2a 80 00 	mov    0x802ab8(,%eax,4),%eax
  800dfb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800dfd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e01:	eb d7                	jmp    800dda <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e03:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e07:	eb d1                	jmp    800dda <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e09:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e10:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e13:	89 d0                	mov    %edx,%eax
  800e15:	c1 e0 02             	shl    $0x2,%eax
  800e18:	01 d0                	add    %edx,%eax
  800e1a:	01 c0                	add    %eax,%eax
  800e1c:	01 d8                	add    %ebx,%eax
  800e1e:	83 e8 30             	sub    $0x30,%eax
  800e21:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e24:	8b 45 10             	mov    0x10(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e2c:	83 fb 2f             	cmp    $0x2f,%ebx
  800e2f:	7e 3e                	jle    800e6f <vprintfmt+0xe9>
  800e31:	83 fb 39             	cmp    $0x39,%ebx
  800e34:	7f 39                	jg     800e6f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e36:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e39:	eb d5                	jmp    800e10 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3e:	83 c0 04             	add    $0x4,%eax
  800e41:	89 45 14             	mov    %eax,0x14(%ebp)
  800e44:	8b 45 14             	mov    0x14(%ebp),%eax
  800e47:	83 e8 04             	sub    $0x4,%eax
  800e4a:	8b 00                	mov    (%eax),%eax
  800e4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e4f:	eb 1f                	jmp    800e70 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e55:	79 83                	jns    800dda <vprintfmt+0x54>
				width = 0;
  800e57:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e5e:	e9 77 ff ff ff       	jmp    800dda <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e63:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e6a:	e9 6b ff ff ff       	jmp    800dda <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e6f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e74:	0f 89 60 ff ff ff    	jns    800dda <vprintfmt+0x54>
				width = precision, precision = -1;
  800e7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e80:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e87:	e9 4e ff ff ff       	jmp    800dda <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e8c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e8f:	e9 46 ff ff ff       	jmp    800dda <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e94:	8b 45 14             	mov    0x14(%ebp),%eax
  800e97:	83 c0 04             	add    $0x4,%eax
  800e9a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea0:	83 e8 04             	sub    $0x4,%eax
  800ea3:	8b 00                	mov    (%eax),%eax
  800ea5:	83 ec 08             	sub    $0x8,%esp
  800ea8:	ff 75 0c             	pushl  0xc(%ebp)
  800eab:	50                   	push   %eax
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	ff d0                	call   *%eax
  800eb1:	83 c4 10             	add    $0x10,%esp
			break;
  800eb4:	e9 89 02 00 00       	jmp    801142 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800eb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebc:	83 c0 04             	add    $0x4,%eax
  800ebf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec5:	83 e8 04             	sub    $0x4,%eax
  800ec8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800eca:	85 db                	test   %ebx,%ebx
  800ecc:	79 02                	jns    800ed0 <vprintfmt+0x14a>
				err = -err;
  800ece:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ed0:	83 fb 64             	cmp    $0x64,%ebx
  800ed3:	7f 0b                	jg     800ee0 <vprintfmt+0x15a>
  800ed5:	8b 34 9d 00 29 80 00 	mov    0x802900(,%ebx,4),%esi
  800edc:	85 f6                	test   %esi,%esi
  800ede:	75 19                	jne    800ef9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ee0:	53                   	push   %ebx
  800ee1:	68 a5 2a 80 00       	push   $0x802aa5
  800ee6:	ff 75 0c             	pushl  0xc(%ebp)
  800ee9:	ff 75 08             	pushl  0x8(%ebp)
  800eec:	e8 5e 02 00 00       	call   80114f <printfmt>
  800ef1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ef4:	e9 49 02 00 00       	jmp    801142 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ef9:	56                   	push   %esi
  800efa:	68 ae 2a 80 00       	push   $0x802aae
  800eff:	ff 75 0c             	pushl  0xc(%ebp)
  800f02:	ff 75 08             	pushl  0x8(%ebp)
  800f05:	e8 45 02 00 00       	call   80114f <printfmt>
  800f0a:	83 c4 10             	add    $0x10,%esp
			break;
  800f0d:	e9 30 02 00 00       	jmp    801142 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f12:	8b 45 14             	mov    0x14(%ebp),%eax
  800f15:	83 c0 04             	add    $0x4,%eax
  800f18:	89 45 14             	mov    %eax,0x14(%ebp)
  800f1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1e:	83 e8 04             	sub    $0x4,%eax
  800f21:	8b 30                	mov    (%eax),%esi
  800f23:	85 f6                	test   %esi,%esi
  800f25:	75 05                	jne    800f2c <vprintfmt+0x1a6>
				p = "(null)";
  800f27:	be b1 2a 80 00       	mov    $0x802ab1,%esi
			if (width > 0 && padc != '-')
  800f2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f30:	7e 6d                	jle    800f9f <vprintfmt+0x219>
  800f32:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f36:	74 67                	je     800f9f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f3b:	83 ec 08             	sub    $0x8,%esp
  800f3e:	50                   	push   %eax
  800f3f:	56                   	push   %esi
  800f40:	e8 12 05 00 00       	call   801457 <strnlen>
  800f45:	83 c4 10             	add    $0x10,%esp
  800f48:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f4b:	eb 16                	jmp    800f63 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f4d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f51:	83 ec 08             	sub    $0x8,%esp
  800f54:	ff 75 0c             	pushl  0xc(%ebp)
  800f57:	50                   	push   %eax
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	ff d0                	call   *%eax
  800f5d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f60:	ff 4d e4             	decl   -0x1c(%ebp)
  800f63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f67:	7f e4                	jg     800f4d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f69:	eb 34                	jmp    800f9f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f6b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f6f:	74 1c                	je     800f8d <vprintfmt+0x207>
  800f71:	83 fb 1f             	cmp    $0x1f,%ebx
  800f74:	7e 05                	jle    800f7b <vprintfmt+0x1f5>
  800f76:	83 fb 7e             	cmp    $0x7e,%ebx
  800f79:	7e 12                	jle    800f8d <vprintfmt+0x207>
					putch('?', putdat);
  800f7b:	83 ec 08             	sub    $0x8,%esp
  800f7e:	ff 75 0c             	pushl  0xc(%ebp)
  800f81:	6a 3f                	push   $0x3f
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	ff d0                	call   *%eax
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	eb 0f                	jmp    800f9c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f8d:	83 ec 08             	sub    $0x8,%esp
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	53                   	push   %ebx
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	ff d0                	call   *%eax
  800f99:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f9c:	ff 4d e4             	decl   -0x1c(%ebp)
  800f9f:	89 f0                	mov    %esi,%eax
  800fa1:	8d 70 01             	lea    0x1(%eax),%esi
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	0f be d8             	movsbl %al,%ebx
  800fa9:	85 db                	test   %ebx,%ebx
  800fab:	74 24                	je     800fd1 <vprintfmt+0x24b>
  800fad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fb1:	78 b8                	js     800f6b <vprintfmt+0x1e5>
  800fb3:	ff 4d e0             	decl   -0x20(%ebp)
  800fb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fba:	79 af                	jns    800f6b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fbc:	eb 13                	jmp    800fd1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800fbe:	83 ec 08             	sub    $0x8,%esp
  800fc1:	ff 75 0c             	pushl  0xc(%ebp)
  800fc4:	6a 20                	push   $0x20
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	ff d0                	call   *%eax
  800fcb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fce:	ff 4d e4             	decl   -0x1c(%ebp)
  800fd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd5:	7f e7                	jg     800fbe <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fd7:	e9 66 01 00 00       	jmp    801142 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fdc:	83 ec 08             	sub    $0x8,%esp
  800fdf:	ff 75 e8             	pushl  -0x18(%ebp)
  800fe2:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe5:	50                   	push   %eax
  800fe6:	e8 3c fd ff ff       	call   800d27 <getint>
  800feb:	83 c4 10             	add    $0x10,%esp
  800fee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ffa:	85 d2                	test   %edx,%edx
  800ffc:	79 23                	jns    801021 <vprintfmt+0x29b>
				putch('-', putdat);
  800ffe:	83 ec 08             	sub    $0x8,%esp
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	6a 2d                	push   $0x2d
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	ff d0                	call   *%eax
  80100b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80100e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801011:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801014:	f7 d8                	neg    %eax
  801016:	83 d2 00             	adc    $0x0,%edx
  801019:	f7 da                	neg    %edx
  80101b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80101e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801021:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801028:	e9 bc 00 00 00       	jmp    8010e9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80102d:	83 ec 08             	sub    $0x8,%esp
  801030:	ff 75 e8             	pushl  -0x18(%ebp)
  801033:	8d 45 14             	lea    0x14(%ebp),%eax
  801036:	50                   	push   %eax
  801037:	e8 84 fc ff ff       	call   800cc0 <getuint>
  80103c:	83 c4 10             	add    $0x10,%esp
  80103f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801042:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801045:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80104c:	e9 98 00 00 00       	jmp    8010e9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801051:	83 ec 08             	sub    $0x8,%esp
  801054:	ff 75 0c             	pushl  0xc(%ebp)
  801057:	6a 58                	push   $0x58
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	ff d0                	call   *%eax
  80105e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801061:	83 ec 08             	sub    $0x8,%esp
  801064:	ff 75 0c             	pushl  0xc(%ebp)
  801067:	6a 58                	push   $0x58
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	ff d0                	call   *%eax
  80106e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801071:	83 ec 08             	sub    $0x8,%esp
  801074:	ff 75 0c             	pushl  0xc(%ebp)
  801077:	6a 58                	push   $0x58
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	ff d0                	call   *%eax
  80107e:	83 c4 10             	add    $0x10,%esp
			break;
  801081:	e9 bc 00 00 00       	jmp    801142 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801086:	83 ec 08             	sub    $0x8,%esp
  801089:	ff 75 0c             	pushl  0xc(%ebp)
  80108c:	6a 30                	push   $0x30
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	ff d0                	call   *%eax
  801093:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801096:	83 ec 08             	sub    $0x8,%esp
  801099:	ff 75 0c             	pushl  0xc(%ebp)
  80109c:	6a 78                	push   $0x78
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	ff d0                	call   *%eax
  8010a3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a9:	83 c0 04             	add    $0x4,%eax
  8010ac:	89 45 14             	mov    %eax,0x14(%ebp)
  8010af:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b2:	83 e8 04             	sub    $0x4,%eax
  8010b5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010c1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010c8:	eb 1f                	jmp    8010e9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010ca:	83 ec 08             	sub    $0x8,%esp
  8010cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8010d0:	8d 45 14             	lea    0x14(%ebp),%eax
  8010d3:	50                   	push   %eax
  8010d4:	e8 e7 fb ff ff       	call   800cc0 <getuint>
  8010d9:	83 c4 10             	add    $0x10,%esp
  8010dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010df:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010e2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010e9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	52                   	push   %edx
  8010f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f7:	50                   	push   %eax
  8010f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	ff 75 08             	pushl  0x8(%ebp)
  801104:	e8 00 fb ff ff       	call   800c09 <printnum>
  801109:	83 c4 20             	add    $0x20,%esp
			break;
  80110c:	eb 34                	jmp    801142 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	53                   	push   %ebx
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	ff d0                	call   *%eax
  80111a:	83 c4 10             	add    $0x10,%esp
			break;
  80111d:	eb 23                	jmp    801142 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80111f:	83 ec 08             	sub    $0x8,%esp
  801122:	ff 75 0c             	pushl  0xc(%ebp)
  801125:	6a 25                	push   $0x25
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	ff d0                	call   *%eax
  80112c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80112f:	ff 4d 10             	decl   0x10(%ebp)
  801132:	eb 03                	jmp    801137 <vprintfmt+0x3b1>
  801134:	ff 4d 10             	decl   0x10(%ebp)
  801137:	8b 45 10             	mov    0x10(%ebp),%eax
  80113a:	48                   	dec    %eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	3c 25                	cmp    $0x25,%al
  80113f:	75 f3                	jne    801134 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801141:	90                   	nop
		}
	}
  801142:	e9 47 fc ff ff       	jmp    800d8e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801147:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801148:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80114b:	5b                   	pop    %ebx
  80114c:	5e                   	pop    %esi
  80114d:	5d                   	pop    %ebp
  80114e:	c3                   	ret    

0080114f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801155:	8d 45 10             	lea    0x10(%ebp),%eax
  801158:	83 c0 04             	add    $0x4,%eax
  80115b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80115e:	8b 45 10             	mov    0x10(%ebp),%eax
  801161:	ff 75 f4             	pushl  -0xc(%ebp)
  801164:	50                   	push   %eax
  801165:	ff 75 0c             	pushl  0xc(%ebp)
  801168:	ff 75 08             	pushl  0x8(%ebp)
  80116b:	e8 16 fc ff ff       	call   800d86 <vprintfmt>
  801170:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801173:	90                   	nop
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	8b 40 08             	mov    0x8(%eax),%eax
  80117f:	8d 50 01             	lea    0x1(%eax),%edx
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	8b 10                	mov    (%eax),%edx
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	8b 40 04             	mov    0x4(%eax),%eax
  801193:	39 c2                	cmp    %eax,%edx
  801195:	73 12                	jae    8011a9 <sprintputch+0x33>
		*b->buf++ = ch;
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	8b 00                	mov    (%eax),%eax
  80119c:	8d 48 01             	lea    0x1(%eax),%ecx
  80119f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a2:	89 0a                	mov    %ecx,(%edx)
  8011a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a7:	88 10                	mov    %dl,(%eax)
}
  8011a9:	90                   	nop
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    

008011ac <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	01 d0                	add    %edx,%eax
  8011c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d1:	74 06                	je     8011d9 <vsnprintf+0x2d>
  8011d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d7:	7f 07                	jg     8011e0 <vsnprintf+0x34>
		return -E_INVAL;
  8011d9:	b8 03 00 00 00       	mov    $0x3,%eax
  8011de:	eb 20                	jmp    801200 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011e0:	ff 75 14             	pushl  0x14(%ebp)
  8011e3:	ff 75 10             	pushl  0x10(%ebp)
  8011e6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011e9:	50                   	push   %eax
  8011ea:	68 76 11 80 00       	push   $0x801176
  8011ef:	e8 92 fb ff ff       	call   800d86 <vprintfmt>
  8011f4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011fa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801200:	c9                   	leave  
  801201:	c3                   	ret    

00801202 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801208:	8d 45 10             	lea    0x10(%ebp),%eax
  80120b:	83 c0 04             	add    $0x4,%eax
  80120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	ff 75 f4             	pushl  -0xc(%ebp)
  801217:	50                   	push   %eax
  801218:	ff 75 0c             	pushl  0xc(%ebp)
  80121b:	ff 75 08             	pushl  0x8(%ebp)
  80121e:	e8 89 ff ff ff       	call   8011ac <vsnprintf>
  801223:	83 c4 10             	add    $0x10,%esp
  801226:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801229:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80122c:	c9                   	leave  
  80122d:	c3                   	ret    

0080122e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801234:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801238:	74 13                	je     80124d <readline+0x1f>
		cprintf("%s", prompt);
  80123a:	83 ec 08             	sub    $0x8,%esp
  80123d:	ff 75 08             	pushl  0x8(%ebp)
  801240:	68 10 2c 80 00       	push   $0x802c10
  801245:	e8 62 f9 ff ff       	call   800bac <cprintf>
  80124a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80124d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801254:	83 ec 0c             	sub    $0xc,%esp
  801257:	6a 00                	push   $0x0
  801259:	e8 5d f5 ff ff       	call   8007bb <iscons>
  80125e:	83 c4 10             	add    $0x10,%esp
  801261:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801264:	e8 04 f5 ff ff       	call   80076d <getchar>
  801269:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80126c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801270:	79 22                	jns    801294 <readline+0x66>
			if (c != -E_EOF)
  801272:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801276:	0f 84 ad 00 00 00    	je     801329 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80127c:	83 ec 08             	sub    $0x8,%esp
  80127f:	ff 75 ec             	pushl  -0x14(%ebp)
  801282:	68 13 2c 80 00       	push   $0x802c13
  801287:	e8 20 f9 ff ff       	call   800bac <cprintf>
  80128c:	83 c4 10             	add    $0x10,%esp
			return;
  80128f:	e9 95 00 00 00       	jmp    801329 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801294:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801298:	7e 34                	jle    8012ce <readline+0xa0>
  80129a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012a1:	7f 2b                	jg     8012ce <readline+0xa0>
			if (echoing)
  8012a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a7:	74 0e                	je     8012b7 <readline+0x89>
				cputchar(c);
  8012a9:	83 ec 0c             	sub    $0xc,%esp
  8012ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8012af:	e8 71 f4 ff ff       	call   800725 <cputchar>
  8012b4:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8012b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ba:	8d 50 01             	lea    0x1(%eax),%edx
  8012bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012c0:	89 c2                	mov    %eax,%edx
  8012c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c5:	01 d0                	add    %edx,%eax
  8012c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012ca:	88 10                	mov    %dl,(%eax)
  8012cc:	eb 56                	jmp    801324 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012ce:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012d2:	75 1f                	jne    8012f3 <readline+0xc5>
  8012d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012d8:	7e 19                	jle    8012f3 <readline+0xc5>
			if (echoing)
  8012da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012de:	74 0e                	je     8012ee <readline+0xc0>
				cputchar(c);
  8012e0:	83 ec 0c             	sub    $0xc,%esp
  8012e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8012e6:	e8 3a f4 ff ff       	call   800725 <cputchar>
  8012eb:	83 c4 10             	add    $0x10,%esp

			i--;
  8012ee:	ff 4d f4             	decl   -0xc(%ebp)
  8012f1:	eb 31                	jmp    801324 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012f3:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012f7:	74 0a                	je     801303 <readline+0xd5>
  8012f9:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012fd:	0f 85 61 ff ff ff    	jne    801264 <readline+0x36>
			if (echoing)
  801303:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801307:	74 0e                	je     801317 <readline+0xe9>
				cputchar(c);
  801309:	83 ec 0c             	sub    $0xc,%esp
  80130c:	ff 75 ec             	pushl  -0x14(%ebp)
  80130f:	e8 11 f4 ff ff       	call   800725 <cputchar>
  801314:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801317:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	01 d0                	add    %edx,%eax
  80131f:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801322:	eb 06                	jmp    80132a <readline+0xfc>
		}
	}
  801324:	e9 3b ff ff ff       	jmp    801264 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801329:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801332:	e8 e9 0a 00 00       	call   801e20 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801337:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133b:	74 13                	je     801350 <atomic_readline+0x24>
		cprintf("%s", prompt);
  80133d:	83 ec 08             	sub    $0x8,%esp
  801340:	ff 75 08             	pushl  0x8(%ebp)
  801343:	68 10 2c 80 00       	push   $0x802c10
  801348:	e8 5f f8 ff ff       	call   800bac <cprintf>
  80134d:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801350:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801357:	83 ec 0c             	sub    $0xc,%esp
  80135a:	6a 00                	push   $0x0
  80135c:	e8 5a f4 ff ff       	call   8007bb <iscons>
  801361:	83 c4 10             	add    $0x10,%esp
  801364:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801367:	e8 01 f4 ff ff       	call   80076d <getchar>
  80136c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80136f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801373:	79 23                	jns    801398 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801375:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801379:	74 13                	je     80138e <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80137b:	83 ec 08             	sub    $0x8,%esp
  80137e:	ff 75 ec             	pushl  -0x14(%ebp)
  801381:	68 13 2c 80 00       	push   $0x802c13
  801386:	e8 21 f8 ff ff       	call   800bac <cprintf>
  80138b:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80138e:	e8 a7 0a 00 00       	call   801e3a <sys_enable_interrupt>
			return;
  801393:	e9 9a 00 00 00       	jmp    801432 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801398:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80139c:	7e 34                	jle    8013d2 <atomic_readline+0xa6>
  80139e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013a5:	7f 2b                	jg     8013d2 <atomic_readline+0xa6>
			if (echoing)
  8013a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ab:	74 0e                	je     8013bb <atomic_readline+0x8f>
				cputchar(c);
  8013ad:	83 ec 0c             	sub    $0xc,%esp
  8013b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b3:	e8 6d f3 ff ff       	call   800725 <cputchar>
  8013b8:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013be:	8d 50 01             	lea    0x1(%eax),%edx
  8013c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013c4:	89 c2                	mov    %eax,%edx
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	01 d0                	add    %edx,%eax
  8013cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ce:	88 10                	mov    %dl,(%eax)
  8013d0:	eb 5b                	jmp    80142d <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013d2:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013d6:	75 1f                	jne    8013f7 <atomic_readline+0xcb>
  8013d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013dc:	7e 19                	jle    8013f7 <atomic_readline+0xcb>
			if (echoing)
  8013de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013e2:	74 0e                	je     8013f2 <atomic_readline+0xc6>
				cputchar(c);
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8013ea:	e8 36 f3 ff ff       	call   800725 <cputchar>
  8013ef:	83 c4 10             	add    $0x10,%esp
			i--;
  8013f2:	ff 4d f4             	decl   -0xc(%ebp)
  8013f5:	eb 36                	jmp    80142d <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8013f7:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013fb:	74 0a                	je     801407 <atomic_readline+0xdb>
  8013fd:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801401:	0f 85 60 ff ff ff    	jne    801367 <atomic_readline+0x3b>
			if (echoing)
  801407:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80140b:	74 0e                	je     80141b <atomic_readline+0xef>
				cputchar(c);
  80140d:	83 ec 0c             	sub    $0xc,%esp
  801410:	ff 75 ec             	pushl  -0x14(%ebp)
  801413:	e8 0d f3 ff ff       	call   800725 <cputchar>
  801418:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  80141b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	01 d0                	add    %edx,%eax
  801423:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801426:	e8 0f 0a 00 00       	call   801e3a <sys_enable_interrupt>
			return;
  80142b:	eb 05                	jmp    801432 <atomic_readline+0x106>
		}
	}
  80142d:	e9 35 ff ff ff       	jmp    801367 <atomic_readline+0x3b>
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80143a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801441:	eb 06                	jmp    801449 <strlen+0x15>
		n++;
  801443:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801446:	ff 45 08             	incl   0x8(%ebp)
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	84 c0                	test   %al,%al
  801450:	75 f1                	jne    801443 <strlen+0xf>
		n++;
	return n;
  801452:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80145d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801464:	eb 09                	jmp    80146f <strnlen+0x18>
		n++;
  801466:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801469:	ff 45 08             	incl   0x8(%ebp)
  80146c:	ff 4d 0c             	decl   0xc(%ebp)
  80146f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801473:	74 09                	je     80147e <strnlen+0x27>
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	84 c0                	test   %al,%al
  80147c:	75 e8                	jne    801466 <strnlen+0xf>
		n++;
	return n;
  80147e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80148f:	90                   	nop
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	8d 50 01             	lea    0x1(%eax),%edx
  801496:	89 55 08             	mov    %edx,0x8(%ebp)
  801499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80149f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014a2:	8a 12                	mov    (%edx),%dl
  8014a4:	88 10                	mov    %dl,(%eax)
  8014a6:	8a 00                	mov    (%eax),%al
  8014a8:	84 c0                	test   %al,%al
  8014aa:	75 e4                	jne    801490 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c4:	eb 1f                	jmp    8014e5 <strncpy+0x34>
		*dst++ = *src;
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	8d 50 01             	lea    0x1(%eax),%edx
  8014cc:	89 55 08             	mov    %edx,0x8(%ebp)
  8014cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d2:	8a 12                	mov    (%edx),%dl
  8014d4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	84 c0                	test   %al,%al
  8014dd:	74 03                	je     8014e2 <strncpy+0x31>
			src++;
  8014df:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014e2:	ff 45 fc             	incl   -0x4(%ebp)
  8014e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014eb:	72 d9                	jb     8014c6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    

008014f2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801502:	74 30                	je     801534 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801504:	eb 16                	jmp    80151c <strlcpy+0x2a>
			*dst++ = *src++;
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8d 50 01             	lea    0x1(%eax),%edx
  80150c:	89 55 08             	mov    %edx,0x8(%ebp)
  80150f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801512:	8d 4a 01             	lea    0x1(%edx),%ecx
  801515:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801518:	8a 12                	mov    (%edx),%dl
  80151a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80151c:	ff 4d 10             	decl   0x10(%ebp)
  80151f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801523:	74 09                	je     80152e <strlcpy+0x3c>
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	8a 00                	mov    (%eax),%al
  80152a:	84 c0                	test   %al,%al
  80152c:	75 d8                	jne    801506 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801534:	8b 55 08             	mov    0x8(%ebp),%edx
  801537:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153a:	29 c2                	sub    %eax,%edx
  80153c:	89 d0                	mov    %edx,%eax
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801543:	eb 06                	jmp    80154b <strcmp+0xb>
		p++, q++;
  801545:	ff 45 08             	incl   0x8(%ebp)
  801548:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	8a 00                	mov    (%eax),%al
  801550:	84 c0                	test   %al,%al
  801552:	74 0e                	je     801562 <strcmp+0x22>
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 10                	mov    (%eax),%dl
  801559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	38 c2                	cmp    %al,%dl
  801560:	74 e3                	je     801545 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	0f b6 d0             	movzbl %al,%edx
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	8a 00                	mov    (%eax),%al
  80156f:	0f b6 c0             	movzbl %al,%eax
  801572:	29 c2                	sub    %eax,%edx
  801574:	89 d0                	mov    %edx,%eax
}
  801576:	5d                   	pop    %ebp
  801577:	c3                   	ret    

00801578 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80157b:	eb 09                	jmp    801586 <strncmp+0xe>
		n--, p++, q++;
  80157d:	ff 4d 10             	decl   0x10(%ebp)
  801580:	ff 45 08             	incl   0x8(%ebp)
  801583:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801586:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80158a:	74 17                	je     8015a3 <strncmp+0x2b>
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	84 c0                	test   %al,%al
  801593:	74 0e                	je     8015a3 <strncmp+0x2b>
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8a 10                	mov    (%eax),%dl
  80159a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159d:	8a 00                	mov    (%eax),%al
  80159f:	38 c2                	cmp    %al,%dl
  8015a1:	74 da                	je     80157d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015a7:	75 07                	jne    8015b0 <strncmp+0x38>
		return 0;
  8015a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ae:	eb 14                	jmp    8015c4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8a 00                	mov    (%eax),%al
  8015b5:	0f b6 d0             	movzbl %al,%edx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	8a 00                	mov    (%eax),%al
  8015bd:	0f b6 c0             	movzbl %al,%eax
  8015c0:	29 c2                	sub    %eax,%edx
  8015c2:	89 d0                	mov    %edx,%eax
}
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	83 ec 04             	sub    $0x4,%esp
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015d2:	eb 12                	jmp    8015e6 <strchr+0x20>
		if (*s == c)
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	8a 00                	mov    (%eax),%al
  8015d9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015dc:	75 05                	jne    8015e3 <strchr+0x1d>
			return (char *) s;
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	eb 11                	jmp    8015f4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015e3:	ff 45 08             	incl   0x8(%ebp)
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	8a 00                	mov    (%eax),%al
  8015eb:	84 c0                	test   %al,%al
  8015ed:	75 e5                	jne    8015d4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 04             	sub    $0x4,%esp
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801602:	eb 0d                	jmp    801611 <strfind+0x1b>
		if (*s == c)
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80160c:	74 0e                	je     80161c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80160e:	ff 45 08             	incl   0x8(%ebp)
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	8a 00                	mov    (%eax),%al
  801616:	84 c0                	test   %al,%al
  801618:	75 ea                	jne    801604 <strfind+0xe>
  80161a:	eb 01                	jmp    80161d <strfind+0x27>
		if (*s == c)
			break;
  80161c:	90                   	nop
	return (char *) s;
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80162e:	8b 45 10             	mov    0x10(%ebp),%eax
  801631:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801634:	eb 0e                	jmp    801644 <memset+0x22>
		*p++ = c;
  801636:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801639:	8d 50 01             	lea    0x1(%eax),%edx
  80163c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801644:	ff 4d f8             	decl   -0x8(%ebp)
  801647:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80164b:	79 e9                	jns    801636 <memset+0x14>
		*p++ = c;

	return v;
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801658:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801664:	eb 16                	jmp    80167c <memcpy+0x2a>
		*d++ = *s++;
  801666:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801669:	8d 50 01             	lea    0x1(%eax),%edx
  80166c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80166f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801672:	8d 4a 01             	lea    0x1(%edx),%ecx
  801675:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801678:	8a 12                	mov    (%edx),%dl
  80167a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80167c:	8b 45 10             	mov    0x10(%ebp),%eax
  80167f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801682:	89 55 10             	mov    %edx,0x10(%ebp)
  801685:	85 c0                	test   %eax,%eax
  801687:	75 dd                	jne    801666 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801694:	8b 45 0c             	mov    0xc(%ebp),%eax
  801697:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016a6:	73 50                	jae    8016f8 <memmove+0x6a>
  8016a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ae:	01 d0                	add    %edx,%eax
  8016b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016b3:	76 43                	jbe    8016f8 <memmove+0x6a>
		s += n;
  8016b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016be:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016c1:	eb 10                	jmp    8016d3 <memmove+0x45>
			*--d = *--s;
  8016c3:	ff 4d f8             	decl   -0x8(%ebp)
  8016c6:	ff 4d fc             	decl   -0x4(%ebp)
  8016c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016cc:	8a 10                	mov    (%eax),%dl
  8016ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	75 e3                	jne    8016c3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016e0:	eb 23                	jmp    801705 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e5:	8d 50 01             	lea    0x1(%eax),%edx
  8016e8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016f1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016f4:	8a 12                	mov    (%edx),%dl
  8016f6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016fe:	89 55 10             	mov    %edx,0x10(%ebp)
  801701:	85 c0                	test   %eax,%eax
  801703:	75 dd                	jne    8016e2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801716:	8b 45 0c             	mov    0xc(%ebp),%eax
  801719:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80171c:	eb 2a                	jmp    801748 <memcmp+0x3e>
		if (*s1 != *s2)
  80171e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801721:	8a 10                	mov    (%eax),%dl
  801723:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	38 c2                	cmp    %al,%dl
  80172a:	74 16                	je     801742 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80172c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	0f b6 d0             	movzbl %al,%edx
  801734:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801737:	8a 00                	mov    (%eax),%al
  801739:	0f b6 c0             	movzbl %al,%eax
  80173c:	29 c2                	sub    %eax,%edx
  80173e:	89 d0                	mov    %edx,%eax
  801740:	eb 18                	jmp    80175a <memcmp+0x50>
		s1++, s2++;
  801742:	ff 45 fc             	incl   -0x4(%ebp)
  801745:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801748:	8b 45 10             	mov    0x10(%ebp),%eax
  80174b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80174e:	89 55 10             	mov    %edx,0x10(%ebp)
  801751:	85 c0                	test   %eax,%eax
  801753:	75 c9                	jne    80171e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801762:	8b 55 08             	mov    0x8(%ebp),%edx
  801765:	8b 45 10             	mov    0x10(%ebp),%eax
  801768:	01 d0                	add    %edx,%eax
  80176a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80176d:	eb 15                	jmp    801784 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	0f b6 d0             	movzbl %al,%edx
  801777:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177a:	0f b6 c0             	movzbl %al,%eax
  80177d:	39 c2                	cmp    %eax,%edx
  80177f:	74 0d                	je     80178e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801781:	ff 45 08             	incl   0x8(%ebp)
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80178a:	72 e3                	jb     80176f <memfind+0x13>
  80178c:	eb 01                	jmp    80178f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80178e:	90                   	nop
	return (void *) s;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80179a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017a8:	eb 03                	jmp    8017ad <strtol+0x19>
		s++;
  8017aa:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 20                	cmp    $0x20,%al
  8017b4:	74 f4                	je     8017aa <strtol+0x16>
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	3c 09                	cmp    $0x9,%al
  8017bd:	74 eb                	je     8017aa <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	3c 2b                	cmp    $0x2b,%al
  8017c6:	75 05                	jne    8017cd <strtol+0x39>
		s++;
  8017c8:	ff 45 08             	incl   0x8(%ebp)
  8017cb:	eb 13                	jmp    8017e0 <strtol+0x4c>
	else if (*s == '-')
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	3c 2d                	cmp    $0x2d,%al
  8017d4:	75 0a                	jne    8017e0 <strtol+0x4c>
		s++, neg = 1;
  8017d6:	ff 45 08             	incl   0x8(%ebp)
  8017d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e4:	74 06                	je     8017ec <strtol+0x58>
  8017e6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017ea:	75 20                	jne    80180c <strtol+0x78>
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	8a 00                	mov    (%eax),%al
  8017f1:	3c 30                	cmp    $0x30,%al
  8017f3:	75 17                	jne    80180c <strtol+0x78>
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	40                   	inc    %eax
  8017f9:	8a 00                	mov    (%eax),%al
  8017fb:	3c 78                	cmp    $0x78,%al
  8017fd:	75 0d                	jne    80180c <strtol+0x78>
		s += 2, base = 16;
  8017ff:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801803:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80180a:	eb 28                	jmp    801834 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80180c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801810:	75 15                	jne    801827 <strtol+0x93>
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	8a 00                	mov    (%eax),%al
  801817:	3c 30                	cmp    $0x30,%al
  801819:	75 0c                	jne    801827 <strtol+0x93>
		s++, base = 8;
  80181b:	ff 45 08             	incl   0x8(%ebp)
  80181e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801825:	eb 0d                	jmp    801834 <strtol+0xa0>
	else if (base == 0)
  801827:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80182b:	75 07                	jne    801834 <strtol+0xa0>
		base = 10;
  80182d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	8a 00                	mov    (%eax),%al
  801839:	3c 2f                	cmp    $0x2f,%al
  80183b:	7e 19                	jle    801856 <strtol+0xc2>
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	3c 39                	cmp    $0x39,%al
  801844:	7f 10                	jg     801856 <strtol+0xc2>
			dig = *s - '0';
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	0f be c0             	movsbl %al,%eax
  80184e:	83 e8 30             	sub    $0x30,%eax
  801851:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801854:	eb 42                	jmp    801898 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	3c 60                	cmp    $0x60,%al
  80185d:	7e 19                	jle    801878 <strtol+0xe4>
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	3c 7a                	cmp    $0x7a,%al
  801866:	7f 10                	jg     801878 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	0f be c0             	movsbl %al,%eax
  801870:	83 e8 57             	sub    $0x57,%eax
  801873:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801876:	eb 20                	jmp    801898 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	8a 00                	mov    (%eax),%al
  80187d:	3c 40                	cmp    $0x40,%al
  80187f:	7e 39                	jle    8018ba <strtol+0x126>
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	3c 5a                	cmp    $0x5a,%al
  801888:	7f 30                	jg     8018ba <strtol+0x126>
			dig = *s - 'A' + 10;
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 00                	mov    (%eax),%al
  80188f:	0f be c0             	movsbl %al,%eax
  801892:	83 e8 37             	sub    $0x37,%eax
  801895:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80189e:	7d 19                	jge    8018b9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018a0:	ff 45 08             	incl   0x8(%ebp)
  8018a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018aa:	89 c2                	mov    %eax,%edx
  8018ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018af:	01 d0                	add    %edx,%eax
  8018b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018b4:	e9 7b ff ff ff       	jmp    801834 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018b9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018be:	74 08                	je     8018c8 <strtol+0x134>
		*endptr = (char *) s;
  8018c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018cc:	74 07                	je     8018d5 <strtol+0x141>
  8018ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d1:	f7 d8                	neg    %eax
  8018d3:	eb 03                	jmp    8018d8 <strtol+0x144>
  8018d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <ltostr>:

void
ltostr(long value, char *str)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018f2:	79 13                	jns    801907 <ltostr+0x2d>
	{
		neg = 1;
  8018f4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fe:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801901:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801904:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80190f:	99                   	cltd   
  801910:	f7 f9                	idiv   %ecx
  801912:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801915:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801918:	8d 50 01             	lea    0x1(%eax),%edx
  80191b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80191e:	89 c2                	mov    %eax,%edx
  801920:	8b 45 0c             	mov    0xc(%ebp),%eax
  801923:	01 d0                	add    %edx,%eax
  801925:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801928:	83 c2 30             	add    $0x30,%edx
  80192b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80192d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801930:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801935:	f7 e9                	imul   %ecx
  801937:	c1 fa 02             	sar    $0x2,%edx
  80193a:	89 c8                	mov    %ecx,%eax
  80193c:	c1 f8 1f             	sar    $0x1f,%eax
  80193f:	29 c2                	sub    %eax,%edx
  801941:	89 d0                	mov    %edx,%eax
  801943:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801946:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801949:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80194e:	f7 e9                	imul   %ecx
  801950:	c1 fa 02             	sar    $0x2,%edx
  801953:	89 c8                	mov    %ecx,%eax
  801955:	c1 f8 1f             	sar    $0x1f,%eax
  801958:	29 c2                	sub    %eax,%edx
  80195a:	89 d0                	mov    %edx,%eax
  80195c:	c1 e0 02             	shl    $0x2,%eax
  80195f:	01 d0                	add    %edx,%eax
  801961:	01 c0                	add    %eax,%eax
  801963:	29 c1                	sub    %eax,%ecx
  801965:	89 ca                	mov    %ecx,%edx
  801967:	85 d2                	test   %edx,%edx
  801969:	75 9c                	jne    801907 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80196b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801972:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801975:	48                   	dec    %eax
  801976:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801979:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80197d:	74 3d                	je     8019bc <ltostr+0xe2>
		start = 1 ;
  80197f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801986:	eb 34                	jmp    8019bc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801988:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80198b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198e:	01 d0                	add    %edx,%eax
  801990:	8a 00                	mov    (%eax),%al
  801992:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801995:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801998:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199b:	01 c2                	add    %eax,%edx
  80199d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a3:	01 c8                	add    %ecx,%eax
  8019a5:	8a 00                	mov    (%eax),%al
  8019a7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019af:	01 c2                	add    %eax,%edx
  8019b1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019b4:	88 02                	mov    %al,(%edx)
		start++ ;
  8019b6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019b9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019c2:	7c c4                	jl     801988 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019c4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ca:	01 d0                	add    %edx,%eax
  8019cc:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019d8:	ff 75 08             	pushl  0x8(%ebp)
  8019db:	e8 54 fa ff ff       	call   801434 <strlen>
  8019e0:	83 c4 04             	add    $0x4,%esp
  8019e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019e6:	ff 75 0c             	pushl  0xc(%ebp)
  8019e9:	e8 46 fa ff ff       	call   801434 <strlen>
  8019ee:	83 c4 04             	add    $0x4,%esp
  8019f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a02:	eb 17                	jmp    801a1b <strcconcat+0x49>
		final[s] = str1[s] ;
  801a04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a07:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0a:	01 c2                	add    %eax,%edx
  801a0c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	01 c8                	add    %ecx,%eax
  801a14:	8a 00                	mov    (%eax),%al
  801a16:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a18:	ff 45 fc             	incl   -0x4(%ebp)
  801a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a1e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a21:	7c e1                	jl     801a04 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a23:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a2a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a31:	eb 1f                	jmp    801a52 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a36:	8d 50 01             	lea    0x1(%eax),%edx
  801a39:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a3c:	89 c2                	mov    %eax,%edx
  801a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a41:	01 c2                	add    %eax,%edx
  801a43:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a49:	01 c8                	add    %ecx,%eax
  801a4b:	8a 00                	mov    (%eax),%al
  801a4d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a4f:	ff 45 f8             	incl   -0x8(%ebp)
  801a52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a55:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a58:	7c d9                	jl     801a33 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a60:	01 d0                	add    %edx,%eax
  801a62:	c6 00 00             	movb   $0x0,(%eax)
}
  801a65:	90                   	nop
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a74:	8b 45 14             	mov    0x14(%ebp),%eax
  801a77:	8b 00                	mov    (%eax),%eax
  801a79:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a80:	8b 45 10             	mov    0x10(%ebp),%eax
  801a83:	01 d0                	add    %edx,%eax
  801a85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a8b:	eb 0c                	jmp    801a99 <strsplit+0x31>
			*string++ = 0;
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	8d 50 01             	lea    0x1(%eax),%edx
  801a93:	89 55 08             	mov    %edx,0x8(%ebp)
  801a96:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8a 00                	mov    (%eax),%al
  801a9e:	84 c0                	test   %al,%al
  801aa0:	74 18                	je     801aba <strsplit+0x52>
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	0f be c0             	movsbl %al,%eax
  801aaa:	50                   	push   %eax
  801aab:	ff 75 0c             	pushl  0xc(%ebp)
  801aae:	e8 13 fb ff ff       	call   8015c6 <strchr>
  801ab3:	83 c4 08             	add    $0x8,%esp
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	75 d3                	jne    801a8d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	8a 00                	mov    (%eax),%al
  801abf:	84 c0                	test   %al,%al
  801ac1:	74 5a                	je     801b1d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac6:	8b 00                	mov    (%eax),%eax
  801ac8:	83 f8 0f             	cmp    $0xf,%eax
  801acb:	75 07                	jne    801ad4 <strsplit+0x6c>
		{
			return 0;
  801acd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad2:	eb 66                	jmp    801b3a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad7:	8b 00                	mov    (%eax),%eax
  801ad9:	8d 48 01             	lea    0x1(%eax),%ecx
  801adc:	8b 55 14             	mov    0x14(%ebp),%edx
  801adf:	89 0a                	mov    %ecx,(%edx)
  801ae1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  801aeb:	01 c2                	add    %eax,%edx
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801af2:	eb 03                	jmp    801af7 <strsplit+0x8f>
			string++;
  801af4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	8a 00                	mov    (%eax),%al
  801afc:	84 c0                	test   %al,%al
  801afe:	74 8b                	je     801a8b <strsplit+0x23>
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	8a 00                	mov    (%eax),%al
  801b05:	0f be c0             	movsbl %al,%eax
  801b08:	50                   	push   %eax
  801b09:	ff 75 0c             	pushl  0xc(%ebp)
  801b0c:	e8 b5 fa ff ff       	call   8015c6 <strchr>
  801b11:	83 c4 08             	add    $0x8,%esp
  801b14:	85 c0                	test   %eax,%eax
  801b16:	74 dc                	je     801af4 <strsplit+0x8c>
			string++;
	}
  801b18:	e9 6e ff ff ff       	jmp    801a8b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b1d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b21:	8b 00                	mov    (%eax),%eax
  801b23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2d:	01 d0                	add    %edx,%eax
  801b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b35:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801b42:	83 ec 04             	sub    $0x4,%esp
  801b45:	68 24 2c 80 00       	push   $0x802c24
  801b4a:	6a 19                	push   $0x19
  801b4c:	68 49 2c 80 00       	push   $0x802c49
  801b51:	e8 b4 ed ff ff       	call   80090a <_panic>

00801b56 <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	83 ec 18             	sub    $0x18,%esp
  801b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801b62:	83 ec 04             	sub    $0x4,%esp
  801b65:	68 58 2c 80 00       	push   $0x802c58
  801b6a:	6a 31                	push   $0x31
  801b6c:	68 49 2c 80 00       	push   $0x802c49
  801b71:	e8 94 ed ff ff       	call   80090a <_panic>

00801b76 <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801b7c:	83 ec 04             	sub    $0x4,%esp
  801b7f:	68 80 2c 80 00       	push   $0x802c80
  801b84:	6a 4a                	push   $0x4a
  801b86:	68 49 2c 80 00       	push   $0x802c49
  801b8b:	e8 7a ed ff ff       	call   80090a <_panic>

00801b90 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801b96:	83 ec 04             	sub    $0x4,%esp
  801b99:	68 a4 2c 80 00       	push   $0x802ca4
  801b9e:	6a 70                	push   $0x70
  801ba0:	68 49 2c 80 00       	push   $0x802c49
  801ba5:	e8 60 ed ff ff       	call   80090a <_panic>

00801baa <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bb0:	83 ec 04             	sub    $0x4,%esp
  801bb3:	68 c8 2c 80 00       	push   $0x802cc8
  801bb8:	68 8b 00 00 00       	push   $0x8b
  801bbd:	68 49 2c 80 00       	push   $0x802c49
  801bc2:	e8 43 ed ff ff       	call   80090a <_panic>

00801bc7 <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bcd:	83 ec 04             	sub    $0x4,%esp
  801bd0:	68 ec 2c 80 00       	push   $0x802cec
  801bd5:	68 a8 00 00 00       	push   $0xa8
  801bda:	68 49 2c 80 00       	push   $0x802c49
  801bdf:	e8 26 ed ff ff       	call   80090a <_panic>

00801be4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	57                   	push   %edi
  801be8:	56                   	push   %esi
  801be9:	53                   	push   %ebx
  801bea:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bf9:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bfc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bff:	cd 30                	int    $0x30
  801c01:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c07:	83 c4 10             	add    $0x10,%esp
  801c0a:	5b                   	pop    %ebx
  801c0b:	5e                   	pop    %esi
  801c0c:	5f                   	pop    %edi
  801c0d:	5d                   	pop    %ebp
  801c0e:	c3                   	ret    

00801c0f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	83 ec 04             	sub    $0x4,%esp
  801c15:	8b 45 10             	mov    0x10(%ebp),%eax
  801c18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c1b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	52                   	push   %edx
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	50                   	push   %eax
  801c2b:	6a 00                	push   $0x0
  801c2d:	e8 b2 ff ff ff       	call   801be4 <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
}
  801c35:	90                   	nop
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 01                	push   $0x1
  801c47:	e8 98 ff ff ff       	call   801be4 <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	50                   	push   %eax
  801c60:	6a 05                	push   $0x5
  801c62:	e8 7d ff ff ff       	call   801be4 <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 02                	push   $0x2
  801c7b:	e8 64 ff ff ff       	call   801be4 <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 03                	push   $0x3
  801c94:	e8 4b ff ff ff       	call   801be4 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 04                	push   $0x4
  801cad:	e8 32 ff ff ff       	call   801be4 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_env_exit>:


void sys_env_exit(void)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 06                	push   $0x6
  801cc6:	e8 19 ff ff ff       	call   801be4 <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
}
  801cce:	90                   	nop
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	52                   	push   %edx
  801ce1:	50                   	push   %eax
  801ce2:	6a 07                	push   $0x7
  801ce4:	e8 fb fe ff ff       	call   801be4 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	56                   	push   %esi
  801cf2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cf3:	8b 75 18             	mov    0x18(%ebp),%esi
  801cf6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	56                   	push   %esi
  801d03:	53                   	push   %ebx
  801d04:	51                   	push   %ecx
  801d05:	52                   	push   %edx
  801d06:	50                   	push   %eax
  801d07:	6a 08                	push   $0x8
  801d09:	e8 d6 fe ff ff       	call   801be4 <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
}
  801d11:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d14:	5b                   	pop    %ebx
  801d15:	5e                   	pop    %esi
  801d16:	5d                   	pop    %ebp
  801d17:	c3                   	ret    

00801d18 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	52                   	push   %edx
  801d28:	50                   	push   %eax
  801d29:	6a 09                	push   $0x9
  801d2b:	e8 b4 fe ff ff       	call   801be4 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	ff 75 0c             	pushl  0xc(%ebp)
  801d41:	ff 75 08             	pushl  0x8(%ebp)
  801d44:	6a 0a                	push   $0xa
  801d46:	e8 99 fe ff ff       	call   801be4 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 0b                	push   $0xb
  801d5f:	e8 80 fe ff ff       	call   801be4 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 0c                	push   $0xc
  801d78:	e8 67 fe ff ff       	call   801be4 <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 0d                	push   $0xd
  801d91:	e8 4e fe ff ff       	call   801be4 <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	ff 75 0c             	pushl  0xc(%ebp)
  801da7:	ff 75 08             	pushl  0x8(%ebp)
  801daa:	6a 11                	push   $0x11
  801dac:	e8 33 fe ff ff       	call   801be4 <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
	return;
  801db4:	90                   	nop
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	ff 75 0c             	pushl  0xc(%ebp)
  801dc3:	ff 75 08             	pushl  0x8(%ebp)
  801dc6:	6a 12                	push   $0x12
  801dc8:	e8 17 fe ff ff       	call   801be4 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd0:	90                   	nop
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 0e                	push   $0xe
  801de2:	e8 fd fd ff ff       	call   801be4 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	ff 75 08             	pushl  0x8(%ebp)
  801dfa:	6a 0f                	push   $0xf
  801dfc:	e8 e3 fd ff ff       	call   801be4 <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 10                	push   $0x10
  801e15:	e8 ca fd ff ff       	call   801be4 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
}
  801e1d:	90                   	nop
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 14                	push   $0x14
  801e2f:	e8 b0 fd ff ff       	call   801be4 <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	90                   	nop
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 15                	push   $0x15
  801e49:	e8 96 fd ff ff       	call   801be4 <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
}
  801e51:	90                   	nop
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 04             	sub    $0x4,%esp
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e60:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	50                   	push   %eax
  801e6d:	6a 16                	push   $0x16
  801e6f:	e8 70 fd ff ff       	call   801be4 <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
}
  801e77:	90                   	nop
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 17                	push   $0x17
  801e89:	e8 56 fd ff ff       	call   801be4 <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	90                   	nop
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	ff 75 0c             	pushl  0xc(%ebp)
  801ea3:	50                   	push   %eax
  801ea4:	6a 18                	push   $0x18
  801ea6:	e8 39 fd ff ff       	call   801be4 <syscall>
  801eab:	83 c4 18             	add    $0x18,%esp
}
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	52                   	push   %edx
  801ec0:	50                   	push   %eax
  801ec1:	6a 1b                	push   $0x1b
  801ec3:	e8 1c fd ff ff       	call   801be4 <syscall>
  801ec8:	83 c4 18             	add    $0x18,%esp
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	52                   	push   %edx
  801edd:	50                   	push   %eax
  801ede:	6a 19                	push   $0x19
  801ee0:	e8 ff fc ff ff       	call   801be4 <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
}
  801ee8:	90                   	nop
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	52                   	push   %edx
  801efb:	50                   	push   %eax
  801efc:	6a 1a                	push   $0x1a
  801efe:	e8 e1 fc ff ff       	call   801be4 <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
}
  801f06:	90                   	nop
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	83 ec 04             	sub    $0x4,%esp
  801f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f12:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f15:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f18:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	6a 00                	push   $0x0
  801f21:	51                   	push   %ecx
  801f22:	52                   	push   %edx
  801f23:	ff 75 0c             	pushl  0xc(%ebp)
  801f26:	50                   	push   %eax
  801f27:	6a 1c                	push   $0x1c
  801f29:	e8 b6 fc ff ff       	call   801be4 <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	52                   	push   %edx
  801f43:	50                   	push   %eax
  801f44:	6a 1d                	push   $0x1d
  801f46:	e8 99 fc ff ff       	call   801be4 <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
}
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f53:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	51                   	push   %ecx
  801f61:	52                   	push   %edx
  801f62:	50                   	push   %eax
  801f63:	6a 1e                	push   $0x1e
  801f65:	e8 7a fc ff ff       	call   801be4 <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	52                   	push   %edx
  801f7f:	50                   	push   %eax
  801f80:	6a 1f                	push   $0x1f
  801f82:	e8 5d fc ff ff       	call   801be4 <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 20                	push   $0x20
  801f9b:	e8 44 fc ff ff       	call   801be4 <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	ff 75 10             	pushl  0x10(%ebp)
  801fb2:	ff 75 0c             	pushl  0xc(%ebp)
  801fb5:	50                   	push   %eax
  801fb6:	6a 21                	push   $0x21
  801fb8:	e8 27 fc ff ff       	call   801be4 <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
}
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	50                   	push   %eax
  801fd1:	6a 22                	push   $0x22
  801fd3:	e8 0c fc ff ff       	call   801be4 <syscall>
  801fd8:	83 c4 18             	add    $0x18,%esp
}
  801fdb:	90                   	nop
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	50                   	push   %eax
  801fed:	6a 23                	push   $0x23
  801fef:	e8 f0 fb ff ff       	call   801be4 <syscall>
  801ff4:	83 c4 18             	add    $0x18,%esp
}
  801ff7:	90                   	nop
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    

00801ffa <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802000:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802003:	8d 50 04             	lea    0x4(%eax),%edx
  802006:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	52                   	push   %edx
  802010:	50                   	push   %eax
  802011:	6a 24                	push   $0x24
  802013:	e8 cc fb ff ff       	call   801be4 <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
	return result;
  80201b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80201e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802021:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802024:	89 01                	mov    %eax,(%ecx)
  802026:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	c9                   	leave  
  80202d:	c2 04 00             	ret    $0x4

00802030 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	ff 75 10             	pushl  0x10(%ebp)
  80203a:	ff 75 0c             	pushl  0xc(%ebp)
  80203d:	ff 75 08             	pushl  0x8(%ebp)
  802040:	6a 13                	push   $0x13
  802042:	e8 9d fb ff ff       	call   801be4 <syscall>
  802047:	83 c4 18             	add    $0x18,%esp
	return ;
  80204a:	90                   	nop
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sys_rcr2>:
uint32 sys_rcr2()
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 25                	push   $0x25
  80205c:	e8 83 fb ff ff       	call   801be4 <syscall>
  802061:	83 c4 18             	add    $0x18,%esp
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 04             	sub    $0x4,%esp
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802072:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	50                   	push   %eax
  80207f:	6a 26                	push   $0x26
  802081:	e8 5e fb ff ff       	call   801be4 <syscall>
  802086:	83 c4 18             	add    $0x18,%esp
	return ;
  802089:	90                   	nop
}
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <rsttst>:
void rsttst()
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 28                	push   $0x28
  80209b:	e8 44 fb ff ff       	call   801be4 <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a3:	90                   	nop
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 04             	sub    $0x4,%esp
  8020ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8020af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020b2:	8b 55 18             	mov    0x18(%ebp),%edx
  8020b5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020b9:	52                   	push   %edx
  8020ba:	50                   	push   %eax
  8020bb:	ff 75 10             	pushl  0x10(%ebp)
  8020be:	ff 75 0c             	pushl  0xc(%ebp)
  8020c1:	ff 75 08             	pushl  0x8(%ebp)
  8020c4:	6a 27                	push   $0x27
  8020c6:	e8 19 fb ff ff       	call   801be4 <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ce:	90                   	nop
}
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <chktst>:
void chktst(uint32 n)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	ff 75 08             	pushl  0x8(%ebp)
  8020df:	6a 29                	push   $0x29
  8020e1:	e8 fe fa ff ff       	call   801be4 <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e9:	90                   	nop
}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <inctst>:

void inctst()
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 2a                	push   $0x2a
  8020fb:	e8 e4 fa ff ff       	call   801be4 <syscall>
  802100:	83 c4 18             	add    $0x18,%esp
	return ;
  802103:	90                   	nop
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <gettst>:
uint32 gettst()
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 2b                	push   $0x2b
  802115:	e8 ca fa ff ff       	call   801be4 <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 2c                	push   $0x2c
  802131:	e8 ae fa ff ff       	call   801be4 <syscall>
  802136:	83 c4 18             	add    $0x18,%esp
  802139:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80213c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802140:	75 07                	jne    802149 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802142:	b8 01 00 00 00       	mov    $0x1,%eax
  802147:	eb 05                	jmp    80214e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802149:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 2c                	push   $0x2c
  802162:	e8 7d fa ff ff       	call   801be4 <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
  80216a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80216d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802171:	75 07                	jne    80217a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802173:	b8 01 00 00 00       	mov    $0x1,%eax
  802178:	eb 05                	jmp    80217f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80217a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 2c                	push   $0x2c
  802193:	e8 4c fa ff ff       	call   801be4 <syscall>
  802198:	83 c4 18             	add    $0x18,%esp
  80219b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80219e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021a2:	75 07                	jne    8021ab <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a9:	eb 05                	jmp    8021b0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 2c                	push   $0x2c
  8021c4:	e8 1b fa ff ff       	call   801be4 <syscall>
  8021c9:	83 c4 18             	add    $0x18,%esp
  8021cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021cf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021d3:	75 07                	jne    8021dc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8021da:	eb 05                	jmp    8021e1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	ff 75 08             	pushl  0x8(%ebp)
  8021f1:	6a 2d                	push   $0x2d
  8021f3:	e8 ec f9 ff ff       	call   801be4 <syscall>
  8021f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8021fb:	90                   	nop
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802202:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802205:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802208:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	6a 00                	push   $0x0
  802210:	53                   	push   %ebx
  802211:	51                   	push   %ecx
  802212:	52                   	push   %edx
  802213:	50                   	push   %eax
  802214:	6a 2e                	push   $0x2e
  802216:	e8 c9 f9 ff ff       	call   801be4 <syscall>
  80221b:	83 c4 18             	add    $0x18,%esp
}
  80221e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802226:	8b 55 0c             	mov    0xc(%ebp),%edx
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	52                   	push   %edx
  802233:	50                   	push   %eax
  802234:	6a 2f                	push   $0x2f
  802236:	e8 a9 f9 ff ff       	call   801be4 <syscall>
  80223b:	83 c4 18             	add    $0x18,%esp
}
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <__udivdi3>:
  802240:	55                   	push   %ebp
  802241:	57                   	push   %edi
  802242:	56                   	push   %esi
  802243:	53                   	push   %ebx
  802244:	83 ec 1c             	sub    $0x1c,%esp
  802247:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80224b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80224f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802253:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802257:	89 ca                	mov    %ecx,%edx
  802259:	89 f8                	mov    %edi,%eax
  80225b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80225f:	85 f6                	test   %esi,%esi
  802261:	75 2d                	jne    802290 <__udivdi3+0x50>
  802263:	39 cf                	cmp    %ecx,%edi
  802265:	77 65                	ja     8022cc <__udivdi3+0x8c>
  802267:	89 fd                	mov    %edi,%ebp
  802269:	85 ff                	test   %edi,%edi
  80226b:	75 0b                	jne    802278 <__udivdi3+0x38>
  80226d:	b8 01 00 00 00       	mov    $0x1,%eax
  802272:	31 d2                	xor    %edx,%edx
  802274:	f7 f7                	div    %edi
  802276:	89 c5                	mov    %eax,%ebp
  802278:	31 d2                	xor    %edx,%edx
  80227a:	89 c8                	mov    %ecx,%eax
  80227c:	f7 f5                	div    %ebp
  80227e:	89 c1                	mov    %eax,%ecx
  802280:	89 d8                	mov    %ebx,%eax
  802282:	f7 f5                	div    %ebp
  802284:	89 cf                	mov    %ecx,%edi
  802286:	89 fa                	mov    %edi,%edx
  802288:	83 c4 1c             	add    $0x1c,%esp
  80228b:	5b                   	pop    %ebx
  80228c:	5e                   	pop    %esi
  80228d:	5f                   	pop    %edi
  80228e:	5d                   	pop    %ebp
  80228f:	c3                   	ret    
  802290:	39 ce                	cmp    %ecx,%esi
  802292:	77 28                	ja     8022bc <__udivdi3+0x7c>
  802294:	0f bd fe             	bsr    %esi,%edi
  802297:	83 f7 1f             	xor    $0x1f,%edi
  80229a:	75 40                	jne    8022dc <__udivdi3+0x9c>
  80229c:	39 ce                	cmp    %ecx,%esi
  80229e:	72 0a                	jb     8022aa <__udivdi3+0x6a>
  8022a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8022a4:	0f 87 9e 00 00 00    	ja     802348 <__udivdi3+0x108>
  8022aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8022af:	89 fa                	mov    %edi,%edx
  8022b1:	83 c4 1c             	add    $0x1c,%esp
  8022b4:	5b                   	pop    %ebx
  8022b5:	5e                   	pop    %esi
  8022b6:	5f                   	pop    %edi
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    
  8022b9:	8d 76 00             	lea    0x0(%esi),%esi
  8022bc:	31 ff                	xor    %edi,%edi
  8022be:	31 c0                	xor    %eax,%eax
  8022c0:	89 fa                	mov    %edi,%edx
  8022c2:	83 c4 1c             	add    $0x1c,%esp
  8022c5:	5b                   	pop    %ebx
  8022c6:	5e                   	pop    %esi
  8022c7:	5f                   	pop    %edi
  8022c8:	5d                   	pop    %ebp
  8022c9:	c3                   	ret    
  8022ca:	66 90                	xchg   %ax,%ax
  8022cc:	89 d8                	mov    %ebx,%eax
  8022ce:	f7 f7                	div    %edi
  8022d0:	31 ff                	xor    %edi,%edi
  8022d2:	89 fa                	mov    %edi,%edx
  8022d4:	83 c4 1c             	add    $0x1c,%esp
  8022d7:	5b                   	pop    %ebx
  8022d8:	5e                   	pop    %esi
  8022d9:	5f                   	pop    %edi
  8022da:	5d                   	pop    %ebp
  8022db:	c3                   	ret    
  8022dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8022e1:	89 eb                	mov    %ebp,%ebx
  8022e3:	29 fb                	sub    %edi,%ebx
  8022e5:	89 f9                	mov    %edi,%ecx
  8022e7:	d3 e6                	shl    %cl,%esi
  8022e9:	89 c5                	mov    %eax,%ebp
  8022eb:	88 d9                	mov    %bl,%cl
  8022ed:	d3 ed                	shr    %cl,%ebp
  8022ef:	89 e9                	mov    %ebp,%ecx
  8022f1:	09 f1                	or     %esi,%ecx
  8022f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8022f7:	89 f9                	mov    %edi,%ecx
  8022f9:	d3 e0                	shl    %cl,%eax
  8022fb:	89 c5                	mov    %eax,%ebp
  8022fd:	89 d6                	mov    %edx,%esi
  8022ff:	88 d9                	mov    %bl,%cl
  802301:	d3 ee                	shr    %cl,%esi
  802303:	89 f9                	mov    %edi,%ecx
  802305:	d3 e2                	shl    %cl,%edx
  802307:	8b 44 24 08          	mov    0x8(%esp),%eax
  80230b:	88 d9                	mov    %bl,%cl
  80230d:	d3 e8                	shr    %cl,%eax
  80230f:	09 c2                	or     %eax,%edx
  802311:	89 d0                	mov    %edx,%eax
  802313:	89 f2                	mov    %esi,%edx
  802315:	f7 74 24 0c          	divl   0xc(%esp)
  802319:	89 d6                	mov    %edx,%esi
  80231b:	89 c3                	mov    %eax,%ebx
  80231d:	f7 e5                	mul    %ebp
  80231f:	39 d6                	cmp    %edx,%esi
  802321:	72 19                	jb     80233c <__udivdi3+0xfc>
  802323:	74 0b                	je     802330 <__udivdi3+0xf0>
  802325:	89 d8                	mov    %ebx,%eax
  802327:	31 ff                	xor    %edi,%edi
  802329:	e9 58 ff ff ff       	jmp    802286 <__udivdi3+0x46>
  80232e:	66 90                	xchg   %ax,%ax
  802330:	8b 54 24 08          	mov    0x8(%esp),%edx
  802334:	89 f9                	mov    %edi,%ecx
  802336:	d3 e2                	shl    %cl,%edx
  802338:	39 c2                	cmp    %eax,%edx
  80233a:	73 e9                	jae    802325 <__udivdi3+0xe5>
  80233c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80233f:	31 ff                	xor    %edi,%edi
  802341:	e9 40 ff ff ff       	jmp    802286 <__udivdi3+0x46>
  802346:	66 90                	xchg   %ax,%ax
  802348:	31 c0                	xor    %eax,%eax
  80234a:	e9 37 ff ff ff       	jmp    802286 <__udivdi3+0x46>
  80234f:	90                   	nop

00802350 <__umoddi3>:
  802350:	55                   	push   %ebp
  802351:	57                   	push   %edi
  802352:	56                   	push   %esi
  802353:	53                   	push   %ebx
  802354:	83 ec 1c             	sub    $0x1c,%esp
  802357:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80235b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80235f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802363:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802367:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80236b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80236f:	89 f3                	mov    %esi,%ebx
  802371:	89 fa                	mov    %edi,%edx
  802373:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802377:	89 34 24             	mov    %esi,(%esp)
  80237a:	85 c0                	test   %eax,%eax
  80237c:	75 1a                	jne    802398 <__umoddi3+0x48>
  80237e:	39 f7                	cmp    %esi,%edi
  802380:	0f 86 a2 00 00 00    	jbe    802428 <__umoddi3+0xd8>
  802386:	89 c8                	mov    %ecx,%eax
  802388:	89 f2                	mov    %esi,%edx
  80238a:	f7 f7                	div    %edi
  80238c:	89 d0                	mov    %edx,%eax
  80238e:	31 d2                	xor    %edx,%edx
  802390:	83 c4 1c             	add    $0x1c,%esp
  802393:	5b                   	pop    %ebx
  802394:	5e                   	pop    %esi
  802395:	5f                   	pop    %edi
  802396:	5d                   	pop    %ebp
  802397:	c3                   	ret    
  802398:	39 f0                	cmp    %esi,%eax
  80239a:	0f 87 ac 00 00 00    	ja     80244c <__umoddi3+0xfc>
  8023a0:	0f bd e8             	bsr    %eax,%ebp
  8023a3:	83 f5 1f             	xor    $0x1f,%ebp
  8023a6:	0f 84 ac 00 00 00    	je     802458 <__umoddi3+0x108>
  8023ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8023b1:	29 ef                	sub    %ebp,%edi
  8023b3:	89 fe                	mov    %edi,%esi
  8023b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023b9:	89 e9                	mov    %ebp,%ecx
  8023bb:	d3 e0                	shl    %cl,%eax
  8023bd:	89 d7                	mov    %edx,%edi
  8023bf:	89 f1                	mov    %esi,%ecx
  8023c1:	d3 ef                	shr    %cl,%edi
  8023c3:	09 c7                	or     %eax,%edi
  8023c5:	89 e9                	mov    %ebp,%ecx
  8023c7:	d3 e2                	shl    %cl,%edx
  8023c9:	89 14 24             	mov    %edx,(%esp)
  8023cc:	89 d8                	mov    %ebx,%eax
  8023ce:	d3 e0                	shl    %cl,%eax
  8023d0:	89 c2                	mov    %eax,%edx
  8023d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023d6:	d3 e0                	shl    %cl,%eax
  8023d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023e0:	89 f1                	mov    %esi,%ecx
  8023e2:	d3 e8                	shr    %cl,%eax
  8023e4:	09 d0                	or     %edx,%eax
  8023e6:	d3 eb                	shr    %cl,%ebx
  8023e8:	89 da                	mov    %ebx,%edx
  8023ea:	f7 f7                	div    %edi
  8023ec:	89 d3                	mov    %edx,%ebx
  8023ee:	f7 24 24             	mull   (%esp)
  8023f1:	89 c6                	mov    %eax,%esi
  8023f3:	89 d1                	mov    %edx,%ecx
  8023f5:	39 d3                	cmp    %edx,%ebx
  8023f7:	0f 82 87 00 00 00    	jb     802484 <__umoddi3+0x134>
  8023fd:	0f 84 91 00 00 00    	je     802494 <__umoddi3+0x144>
  802403:	8b 54 24 04          	mov    0x4(%esp),%edx
  802407:	29 f2                	sub    %esi,%edx
  802409:	19 cb                	sbb    %ecx,%ebx
  80240b:	89 d8                	mov    %ebx,%eax
  80240d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802411:	d3 e0                	shl    %cl,%eax
  802413:	89 e9                	mov    %ebp,%ecx
  802415:	d3 ea                	shr    %cl,%edx
  802417:	09 d0                	or     %edx,%eax
  802419:	89 e9                	mov    %ebp,%ecx
  80241b:	d3 eb                	shr    %cl,%ebx
  80241d:	89 da                	mov    %ebx,%edx
  80241f:	83 c4 1c             	add    $0x1c,%esp
  802422:	5b                   	pop    %ebx
  802423:	5e                   	pop    %esi
  802424:	5f                   	pop    %edi
  802425:	5d                   	pop    %ebp
  802426:	c3                   	ret    
  802427:	90                   	nop
  802428:	89 fd                	mov    %edi,%ebp
  80242a:	85 ff                	test   %edi,%edi
  80242c:	75 0b                	jne    802439 <__umoddi3+0xe9>
  80242e:	b8 01 00 00 00       	mov    $0x1,%eax
  802433:	31 d2                	xor    %edx,%edx
  802435:	f7 f7                	div    %edi
  802437:	89 c5                	mov    %eax,%ebp
  802439:	89 f0                	mov    %esi,%eax
  80243b:	31 d2                	xor    %edx,%edx
  80243d:	f7 f5                	div    %ebp
  80243f:	89 c8                	mov    %ecx,%eax
  802441:	f7 f5                	div    %ebp
  802443:	89 d0                	mov    %edx,%eax
  802445:	e9 44 ff ff ff       	jmp    80238e <__umoddi3+0x3e>
  80244a:	66 90                	xchg   %ax,%ax
  80244c:	89 c8                	mov    %ecx,%eax
  80244e:	89 f2                	mov    %esi,%edx
  802450:	83 c4 1c             	add    $0x1c,%esp
  802453:	5b                   	pop    %ebx
  802454:	5e                   	pop    %esi
  802455:	5f                   	pop    %edi
  802456:	5d                   	pop    %ebp
  802457:	c3                   	ret    
  802458:	3b 04 24             	cmp    (%esp),%eax
  80245b:	72 06                	jb     802463 <__umoddi3+0x113>
  80245d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802461:	77 0f                	ja     802472 <__umoddi3+0x122>
  802463:	89 f2                	mov    %esi,%edx
  802465:	29 f9                	sub    %edi,%ecx
  802467:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80246b:	89 14 24             	mov    %edx,(%esp)
  80246e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802472:	8b 44 24 04          	mov    0x4(%esp),%eax
  802476:	8b 14 24             	mov    (%esp),%edx
  802479:	83 c4 1c             	add    $0x1c,%esp
  80247c:	5b                   	pop    %ebx
  80247d:	5e                   	pop    %esi
  80247e:	5f                   	pop    %edi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    
  802481:	8d 76 00             	lea    0x0(%esi),%esi
  802484:	2b 04 24             	sub    (%esp),%eax
  802487:	19 fa                	sbb    %edi,%edx
  802489:	89 d1                	mov    %edx,%ecx
  80248b:	89 c6                	mov    %eax,%esi
  80248d:	e9 71 ff ff ff       	jmp    802403 <__umoddi3+0xb3>
  802492:	66 90                	xchg   %ax,%ax
  802494:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802498:	72 ea                	jb     802484 <__umoddi3+0x134>
  80249a:	89 d9                	mov    %ebx,%ecx
  80249c:	e9 62 ff ff ff       	jmp    802403 <__umoddi3+0xb3>