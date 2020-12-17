
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 6d 03 00 00       	call   8003a3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 23                	jmp    800072 <_main+0x3a>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 30 80 00       	mov    0x803020,%eax
  800054:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	c1 e2 04             	shl    $0x4,%edx
  800060:	01 d0                	add    %edx,%eax
  800062:	8a 40 04             	mov    0x4(%eax),%al
  800065:	84 c0                	test   %al,%al
  800067:	74 06                	je     80006f <_main+0x37>
			{
				fullWS = 0;
  800069:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006d:	eb 12                	jmp    800081 <_main+0x49>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006f:	ff 45 f0             	incl   -0x10(%ebp)
  800072:	a1 20 30 80 00       	mov    0x803020,%eax
  800077:	8b 50 74             	mov    0x74(%eax),%edx
  80007a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007d:	39 c2                	cmp    %eax,%edx
  80007f:	77 ce                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800081:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800085:	74 14                	je     80009b <_main+0x63>
  800087:	83 ec 04             	sub    $0x4,%esp
  80008a:	68 80 1e 80 00       	push   $0x801e80
  80008f:	6a 1a                	push   $0x1a
  800091:	68 9c 1e 80 00       	push   $0x801e9c
  800096:	e8 4d 04 00 00       	call   8004e8 <_panic>
	}


	int Mega = 1024*1024;
  80009b:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000a2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	char minByte = 1<<7;
  8000a9:	c6 45 e7 80          	movb   $0x80,-0x19(%ebp)
	char maxByte = 0x7F;
  8000ad:	c6 45 e6 7f          	movb   $0x7f,-0x1a(%ebp)
	short minShort = 1<<15 ;
  8000b1:	66 c7 45 e4 00 80    	movw   $0x8000,-0x1c(%ebp)
	short maxShort = 0x7FFF;
  8000b7:	66 c7 45 e2 ff 7f    	movw   $0x7fff,-0x1e(%ebp)
	int minInt = 1<<31 ;
  8000bd:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000c4:	c7 45 d8 ff ff ff 7f 	movl   $0x7fffffff,-0x28(%ebp)

	void* ptr_allocations[20] = {0};
  8000cb:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  8000d1:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	89 d7                	mov    %edx,%edi
  8000dd:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	01 c0                	add    %eax,%eax
  8000e4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000e7:	83 ec 0c             	sub    $0xc,%esp
  8000ea:	50                   	push   %eax
  8000eb:	e8 24 14 00 00       	call   801514 <malloc>
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  8000f9:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8000ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800102:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800105:	01 c0                	add    %eax,%eax
  800107:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010a:	48                   	dec    %eax
  80010b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = minByte ;
  80010e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800111:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800114:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800116:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800119:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80011c:	01 c2                	add    %eax,%edx
  80011e:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800121:	88 02                	mov    %al,(%edx)

		ptr_allocations[1] = malloc(2*Mega-kilo);
  800123:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800126:	01 c0                	add    %eax,%eax
  800128:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80012b:	83 ec 0c             	sub    $0xc,%esp
  80012e:	50                   	push   %eax
  80012f:	e8 e0 13 00 00       	call   801514 <malloc>
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  80013d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800143:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800146:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800149:	01 c0                	add    %eax,%eax
  80014b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80014e:	d1 e8                	shr    %eax
  800150:	48                   	dec    %eax
  800151:	89 45 c8             	mov    %eax,-0x38(%ebp)
		shortArr[0] = minShort;
  800154:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800157:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80015a:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  80015d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800160:	01 c0                	add    %eax,%eax
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800167:	01 c2                	add    %eax,%edx
  800169:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  80016d:	66 89 02             	mov    %ax,(%edx)

		ptr_allocations[2] = malloc(3*kilo);
  800170:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800173:	89 c2                	mov    %eax,%edx
  800175:	01 d2                	add    %edx,%edx
  800177:	01 d0                	add    %edx,%eax
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	50                   	push   %eax
  80017d:	e8 92 13 00 00       	call   801514 <malloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  80018b:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800191:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800194:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800197:	01 c0                	add    %eax,%eax
  800199:	c1 e8 02             	shr    $0x2,%eax
  80019c:	48                   	dec    %eax
  80019d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr[0] = minInt;
  8001a0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001a6:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8001a8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001b5:	01 c2                	add    %eax,%edx
  8001b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001ba:	89 02                	mov    %eax,(%edx)

		ptr_allocations[3] = malloc(7*kilo);
  8001bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001bf:	89 d0                	mov    %edx,%eax
  8001c1:	01 c0                	add    %eax,%eax
  8001c3:	01 d0                	add    %edx,%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	01 d0                	add    %edx,%eax
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	50                   	push   %eax
  8001cd:	e8 42 13 00 00       	call   801514 <malloc>
  8001d2:	83 c4 10             	add    $0x10,%esp
  8001d5:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8001db:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8001e1:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8001e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001e7:	89 d0                	mov    %edx,%eax
  8001e9:	01 c0                	add    %eax,%eax
  8001eb:	01 d0                	add    %edx,%eax
  8001ed:	01 c0                	add    %eax,%eax
  8001ef:	01 d0                	add    %edx,%eax
  8001f1:	c1 e8 03             	shr    $0x3,%eax
  8001f4:	48                   	dec    %eax
  8001f5:	89 45 b8             	mov    %eax,-0x48(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8001f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001fb:	8a 55 e7             	mov    -0x19(%ebp),%dl
  8001fe:	88 10                	mov    %dl,(%eax)
  800200:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800206:	66 89 42 02          	mov    %ax,0x2(%edx)
  80020a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800210:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800213:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800216:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80021d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800220:	01 c2                	add    %eax,%edx
  800222:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800225:	88 02                	mov    %al,(%edx)
  800227:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80022a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800231:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800234:	01 c2                	add    %eax,%edx
  800236:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  80023a:	66 89 42 02          	mov    %ax,0x2(%edx)
  80023e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800241:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800248:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80024b:	01 c2                	add    %eax,%edx
  80024d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800250:	89 42 04             	mov    %eax,0x4(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800253:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800256:	8a 00                	mov    (%eax),%al
  800258:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80025b:	75 0f                	jne    80026c <_main+0x234>
  80025d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800260:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800263:	01 d0                	add    %edx,%eax
  800265:	8a 00                	mov    (%eax),%al
  800267:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80026a:	74 14                	je     800280 <_main+0x248>
  80026c:	83 ec 04             	sub    $0x4,%esp
  80026f:	68 b0 1e 80 00       	push   $0x801eb0
  800274:	6a 42                	push   $0x42
  800276:	68 9c 1e 80 00       	push   $0x801e9c
  80027b:	e8 68 02 00 00       	call   8004e8 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800280:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800283:	66 8b 00             	mov    (%eax),%ax
  800286:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80028a:	75 15                	jne    8002a1 <_main+0x269>
  80028c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80028f:	01 c0                	add    %eax,%eax
  800291:	89 c2                	mov    %eax,%edx
  800293:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800296:	01 d0                	add    %edx,%eax
  800298:	66 8b 00             	mov    (%eax),%ax
  80029b:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  80029f:	74 14                	je     8002b5 <_main+0x27d>
  8002a1:	83 ec 04             	sub    $0x4,%esp
  8002a4:	68 b0 1e 80 00       	push   $0x801eb0
  8002a9:	6a 43                	push   $0x43
  8002ab:	68 9c 1e 80 00       	push   $0x801e9c
  8002b0:	e8 33 02 00 00       	call   8004e8 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8002b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002b8:	8b 00                	mov    (%eax),%eax
  8002ba:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002bd:	75 16                	jne    8002d5 <_main+0x29d>
  8002bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002cc:	01 d0                	add    %edx,%eax
  8002ce:	8b 00                	mov    (%eax),%eax
  8002d0:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002d3:	74 14                	je     8002e9 <_main+0x2b1>
  8002d5:	83 ec 04             	sub    $0x4,%esp
  8002d8:	68 b0 1e 80 00       	push   $0x801eb0
  8002dd:	6a 44                	push   $0x44
  8002df:	68 9c 1e 80 00       	push   $0x801e9c
  8002e4:	e8 ff 01 00 00       	call   8004e8 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002e9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002ec:	8a 00                	mov    (%eax),%al
  8002ee:	3a 45 e7             	cmp    -0x19(%ebp),%al
  8002f1:	75 16                	jne    800309 <_main+0x2d1>
  8002f3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002f6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800300:	01 d0                	add    %edx,%eax
  800302:	8a 00                	mov    (%eax),%al
  800304:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  800307:	74 14                	je     80031d <_main+0x2e5>
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 b0 1e 80 00       	push   $0x801eb0
  800311:	6a 46                	push   $0x46
  800313:	68 9c 1e 80 00       	push   $0x801e9c
  800318:	e8 cb 01 00 00       	call   8004e8 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  80031d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800320:	66 8b 40 02          	mov    0x2(%eax),%ax
  800324:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  800328:	75 19                	jne    800343 <_main+0x30b>
  80032a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80032d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800334:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800337:	01 d0                	add    %edx,%eax
  800339:	66 8b 40 02          	mov    0x2(%eax),%ax
  80033d:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  800341:	74 14                	je     800357 <_main+0x31f>
  800343:	83 ec 04             	sub    $0x4,%esp
  800346:	68 b0 1e 80 00       	push   $0x801eb0
  80034b:	6a 47                	push   $0x47
  80034d:	68 9c 1e 80 00       	push   $0x801e9c
  800352:	e8 91 01 00 00       	call   8004e8 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800357:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80035a:	8b 40 04             	mov    0x4(%eax),%eax
  80035d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800360:	75 17                	jne    800379 <_main+0x341>
  800362:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800365:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80036c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80036f:	01 d0                	add    %edx,%eax
  800371:	8b 40 04             	mov    0x4(%eax),%eax
  800374:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800377:	74 14                	je     80038d <_main+0x355>
  800379:	83 ec 04             	sub    $0x4,%esp
  80037c:	68 b0 1e 80 00       	push   $0x801eb0
  800381:	6a 48                	push   $0x48
  800383:	68 9c 1e 80 00       	push   $0x801e9c
  800388:	e8 5b 01 00 00       	call   8004e8 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  80038d:	83 ec 0c             	sub    $0xc,%esp
  800390:	68 e8 1e 80 00       	push   $0x801ee8
  800395:	e8 f0 03 00 00       	call   80078a <cprintf>
  80039a:	83 c4 10             	add    $0x10,%esp

	return;
  80039d:	90                   	nop
}
  80039e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003a9:	e8 af 12 00 00       	call   80165d <sys_getenvindex>
  8003ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003b4:	89 d0                	mov    %edx,%eax
  8003b6:	c1 e0 03             	shl    $0x3,%eax
  8003b9:	01 d0                	add    %edx,%eax
  8003bb:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003c2:	01 c8                	add    %ecx,%eax
  8003c4:	01 c0                	add    %eax,%eax
  8003c6:	01 d0                	add    %edx,%eax
  8003c8:	01 c0                	add    %eax,%eax
  8003ca:	01 d0                	add    %edx,%eax
  8003cc:	89 c2                	mov    %eax,%edx
  8003ce:	c1 e2 05             	shl    $0x5,%edx
  8003d1:	29 c2                	sub    %eax,%edx
  8003d3:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8003da:	89 c2                	mov    %eax,%edx
  8003dc:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8003e2:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ec:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8003f2:	84 c0                	test   %al,%al
  8003f4:	74 0f                	je     800405 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8003f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fb:	05 40 3c 01 00       	add    $0x13c40,%eax
  800400:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800405:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800409:	7e 0a                	jle    800415 <libmain+0x72>
		binaryname = argv[0];
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800415:	83 ec 08             	sub    $0x8,%esp
  800418:	ff 75 0c             	pushl  0xc(%ebp)
  80041b:	ff 75 08             	pushl  0x8(%ebp)
  80041e:	e8 15 fc ff ff       	call   800038 <_main>
  800423:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800426:	e8 cd 13 00 00       	call   8017f8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	68 3c 1f 80 00       	push   $0x801f3c
  800433:	e8 52 03 00 00       	call   80078a <cprintf>
  800438:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80043b:	a1 20 30 80 00       	mov    0x803020,%eax
  800440:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800446:	a1 20 30 80 00       	mov    0x803020,%eax
  80044b:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800451:	83 ec 04             	sub    $0x4,%esp
  800454:	52                   	push   %edx
  800455:	50                   	push   %eax
  800456:	68 64 1f 80 00       	push   $0x801f64
  80045b:	e8 2a 03 00 00       	call   80078a <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800463:	a1 20 30 80 00       	mov    0x803020,%eax
  800468:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80046e:	a1 20 30 80 00       	mov    0x803020,%eax
  800473:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800479:	83 ec 04             	sub    $0x4,%esp
  80047c:	52                   	push   %edx
  80047d:	50                   	push   %eax
  80047e:	68 8c 1f 80 00       	push   $0x801f8c
  800483:	e8 02 03 00 00       	call   80078a <cprintf>
  800488:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80048b:	a1 20 30 80 00       	mov    0x803020,%eax
  800490:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	50                   	push   %eax
  80049a:	68 cd 1f 80 00       	push   $0x801fcd
  80049f:	e8 e6 02 00 00       	call   80078a <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004a7:	83 ec 0c             	sub    $0xc,%esp
  8004aa:	68 3c 1f 80 00       	push   $0x801f3c
  8004af:	e8 d6 02 00 00       	call   80078a <cprintf>
  8004b4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004b7:	e8 56 13 00 00       	call   801812 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004bc:	e8 19 00 00 00       	call   8004da <exit>
}
  8004c1:	90                   	nop
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8004ca:	83 ec 0c             	sub    $0xc,%esp
  8004cd:	6a 00                	push   $0x0
  8004cf:	e8 55 11 00 00       	call   801629 <sys_env_destroy>
  8004d4:	83 c4 10             	add    $0x10,%esp
}
  8004d7:	90                   	nop
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <exit>:

void
exit(void)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8004e0:	e8 aa 11 00 00       	call   80168f <sys_env_exit>
}
  8004e5:	90                   	nop
  8004e6:	c9                   	leave  
  8004e7:	c3                   	ret    

008004e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
  8004eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ee:	8d 45 10             	lea    0x10(%ebp),%eax
  8004f1:	83 c0 04             	add    $0x4,%eax
  8004f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004f7:	a1 18 31 80 00       	mov    0x803118,%eax
  8004fc:	85 c0                	test   %eax,%eax
  8004fe:	74 16                	je     800516 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800500:	a1 18 31 80 00       	mov    0x803118,%eax
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	50                   	push   %eax
  800509:	68 e4 1f 80 00       	push   $0x801fe4
  80050e:	e8 77 02 00 00       	call   80078a <cprintf>
  800513:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800516:	a1 00 30 80 00       	mov    0x803000,%eax
  80051b:	ff 75 0c             	pushl  0xc(%ebp)
  80051e:	ff 75 08             	pushl  0x8(%ebp)
  800521:	50                   	push   %eax
  800522:	68 e9 1f 80 00       	push   $0x801fe9
  800527:	e8 5e 02 00 00       	call   80078a <cprintf>
  80052c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80052f:	8b 45 10             	mov    0x10(%ebp),%eax
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	ff 75 f4             	pushl  -0xc(%ebp)
  800538:	50                   	push   %eax
  800539:	e8 e1 01 00 00       	call   80071f <vcprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	6a 00                	push   $0x0
  800546:	68 05 20 80 00       	push   $0x802005
  80054b:	e8 cf 01 00 00       	call   80071f <vcprintf>
  800550:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800553:	e8 82 ff ff ff       	call   8004da <exit>

	// should not return here
	while (1) ;
  800558:	eb fe                	jmp    800558 <_panic+0x70>

0080055a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80055a:	55                   	push   %ebp
  80055b:	89 e5                	mov    %esp,%ebp
  80055d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800560:	a1 20 30 80 00       	mov    0x803020,%eax
  800565:	8b 50 74             	mov    0x74(%eax),%edx
  800568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056b:	39 c2                	cmp    %eax,%edx
  80056d:	74 14                	je     800583 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80056f:	83 ec 04             	sub    $0x4,%esp
  800572:	68 08 20 80 00       	push   $0x802008
  800577:	6a 26                	push   $0x26
  800579:	68 54 20 80 00       	push   $0x802054
  80057e:	e8 65 ff ff ff       	call   8004e8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800583:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80058a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800591:	e9 b6 00 00 00       	jmp    80064c <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800599:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a3:	01 d0                	add    %edx,%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	85 c0                	test   %eax,%eax
  8005a9:	75 08                	jne    8005b3 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005ab:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005ae:	e9 96 00 00 00       	jmp    800649 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8005b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005c1:	eb 5d                	jmp    800620 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c8:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8005ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005d1:	c1 e2 04             	shl    $0x4,%edx
  8005d4:	01 d0                	add    %edx,%eax
  8005d6:	8a 40 04             	mov    0x4(%eax),%al
  8005d9:	84 c0                	test   %al,%al
  8005db:	75 40                	jne    80061d <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e2:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8005e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005eb:	c1 e2 04             	shl    $0x4,%edx
  8005ee:	01 d0                	add    %edx,%eax
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005fd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800602:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	01 c8                	add    %ecx,%eax
  80060e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800610:	39 c2                	cmp    %eax,%edx
  800612:	75 09                	jne    80061d <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800614:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80061b:	eb 12                	jmp    80062f <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061d:	ff 45 e8             	incl   -0x18(%ebp)
  800620:	a1 20 30 80 00       	mov    0x803020,%eax
  800625:	8b 50 74             	mov    0x74(%eax),%edx
  800628:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80062b:	39 c2                	cmp    %eax,%edx
  80062d:	77 94                	ja     8005c3 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80062f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800633:	75 14                	jne    800649 <CheckWSWithoutLastIndex+0xef>
			panic(
  800635:	83 ec 04             	sub    $0x4,%esp
  800638:	68 60 20 80 00       	push   $0x802060
  80063d:	6a 3a                	push   $0x3a
  80063f:	68 54 20 80 00       	push   $0x802054
  800644:	e8 9f fe ff ff       	call   8004e8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800649:	ff 45 f0             	incl   -0x10(%ebp)
  80064c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800652:	0f 8c 3e ff ff ff    	jl     800596 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800658:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80065f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800666:	eb 20                	jmp    800688 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800668:	a1 20 30 80 00       	mov    0x803020,%eax
  80066d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800673:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800676:	c1 e2 04             	shl    $0x4,%edx
  800679:	01 d0                	add    %edx,%eax
  80067b:	8a 40 04             	mov    0x4(%eax),%al
  80067e:	3c 01                	cmp    $0x1,%al
  800680:	75 03                	jne    800685 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800682:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800685:	ff 45 e0             	incl   -0x20(%ebp)
  800688:	a1 20 30 80 00       	mov    0x803020,%eax
  80068d:	8b 50 74             	mov    0x74(%eax),%edx
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	39 c2                	cmp    %eax,%edx
  800695:	77 d1                	ja     800668 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80069a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80069d:	74 14                	je     8006b3 <CheckWSWithoutLastIndex+0x159>
		panic(
  80069f:	83 ec 04             	sub    $0x4,%esp
  8006a2:	68 b4 20 80 00       	push   $0x8020b4
  8006a7:	6a 44                	push   $0x44
  8006a9:	68 54 20 80 00       	push   $0x802054
  8006ae:	e8 35 fe ff ff       	call   8004e8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006b3:	90                   	nop
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8006c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c7:	89 0a                	mov    %ecx,(%edx)
  8006c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006cc:	88 d1                	mov    %dl,%cl
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006df:	75 2c                	jne    80070d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006e1:	a0 24 30 80 00       	mov    0x803024,%al
  8006e6:	0f b6 c0             	movzbl %al,%eax
  8006e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ec:	8b 12                	mov    (%edx),%edx
  8006ee:	89 d1                	mov    %edx,%ecx
  8006f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f3:	83 c2 08             	add    $0x8,%edx
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	50                   	push   %eax
  8006fa:	51                   	push   %ecx
  8006fb:	52                   	push   %edx
  8006fc:	e8 e6 0e 00 00       	call   8015e7 <sys_cputs>
  800701:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800704:	8b 45 0c             	mov    0xc(%ebp),%eax
  800707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80070d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800710:	8b 40 04             	mov    0x4(%eax),%eax
  800713:	8d 50 01             	lea    0x1(%eax),%edx
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
  800719:	89 50 04             	mov    %edx,0x4(%eax)
}
  80071c:	90                   	nop
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800728:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80072f:	00 00 00 
	b.cnt = 0;
  800732:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800739:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	ff 75 08             	pushl  0x8(%ebp)
  800742:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800748:	50                   	push   %eax
  800749:	68 b6 06 80 00       	push   $0x8006b6
  80074e:	e8 11 02 00 00       	call   800964 <vprintfmt>
  800753:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800756:	a0 24 30 80 00       	mov    0x803024,%al
  80075b:	0f b6 c0             	movzbl %al,%eax
  80075e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	50                   	push   %eax
  800768:	52                   	push   %edx
  800769:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076f:	83 c0 08             	add    $0x8,%eax
  800772:	50                   	push   %eax
  800773:	e8 6f 0e 00 00       	call   8015e7 <sys_cputs>
  800778:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80077b:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800782:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <cprintf>:

int cprintf(const char *fmt, ...) {
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800790:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800797:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	e8 73 ff ff ff       	call   80071f <vcprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    

008007b7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007bd:	e8 36 10 00 00       	call   8017f8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d1:	50                   	push   %eax
  8007d2:	e8 48 ff ff ff       	call   80071f <vcprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007dd:	e8 30 10 00 00       	call   801812 <sys_enable_interrupt>
	return cnt;
  8007e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	53                   	push   %ebx
  8007eb:	83 ec 14             	sub    $0x14,%esp
  8007ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8007fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800802:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800805:	77 55                	ja     80085c <printnum+0x75>
  800807:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080a:	72 05                	jb     800811 <printnum+0x2a>
  80080c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80080f:	77 4b                	ja     80085c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800811:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800814:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800817:	8b 45 18             	mov    0x18(%ebp),%eax
  80081a:	ba 00 00 00 00       	mov    $0x0,%edx
  80081f:	52                   	push   %edx
  800820:	50                   	push   %eax
  800821:	ff 75 f4             	pushl  -0xc(%ebp)
  800824:	ff 75 f0             	pushl  -0x10(%ebp)
  800827:	e8 ec 13 00 00       	call   801c18 <__udivdi3>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	ff 75 20             	pushl  0x20(%ebp)
  800835:	53                   	push   %ebx
  800836:	ff 75 18             	pushl  0x18(%ebp)
  800839:	52                   	push   %edx
  80083a:	50                   	push   %eax
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	ff 75 08             	pushl  0x8(%ebp)
  800841:	e8 a1 ff ff ff       	call   8007e7 <printnum>
  800846:	83 c4 20             	add    $0x20,%esp
  800849:	eb 1a                	jmp    800865 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 20             	pushl  0x20(%ebp)
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085c:	ff 4d 1c             	decl   0x1c(%ebp)
  80085f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800863:	7f e6                	jg     80084b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800865:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800868:	bb 00 00 00 00       	mov    $0x0,%ebx
  80086d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800870:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800873:	53                   	push   %ebx
  800874:	51                   	push   %ecx
  800875:	52                   	push   %edx
  800876:	50                   	push   %eax
  800877:	e8 ac 14 00 00       	call   801d28 <__umoddi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	05 14 23 80 00       	add    $0x802314,%eax
  800884:	8a 00                	mov    (%eax),%al
  800886:	0f be c0             	movsbl %al,%eax
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	50                   	push   %eax
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	ff d0                	call   *%eax
  800895:	83 c4 10             	add    $0x10,%esp
}
  800898:	90                   	nop
  800899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a5:	7e 1c                	jle    8008c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	8d 50 08             	lea    0x8(%eax),%edx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	89 10                	mov    %edx,(%eax)
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	83 e8 08             	sub    $0x8,%eax
  8008bc:	8b 50 04             	mov    0x4(%eax),%edx
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	eb 40                	jmp    800903 <getuint+0x65>
	else if (lflag)
  8008c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c7:	74 1e                	je     8008e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	8d 50 04             	lea    0x4(%eax),%edx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	89 10                	mov    %edx,(%eax)
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e5:	eb 1c                	jmp    800903 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	8d 50 04             	lea    0x4(%eax),%edx
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	89 10                	mov    %edx,(%eax)
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	83 e8 04             	sub    $0x4,%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800908:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090c:	7e 1c                	jle    80092a <getint+0x25>
		return va_arg(*ap, long long);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	8d 50 08             	lea    0x8(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	89 10                	mov    %edx,(%eax)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	83 e8 08             	sub    $0x8,%eax
  800923:	8b 50 04             	mov    0x4(%eax),%edx
  800926:	8b 00                	mov    (%eax),%eax
  800928:	eb 38                	jmp    800962 <getint+0x5d>
	else if (lflag)
  80092a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092e:	74 1a                	je     80094a <getint+0x45>
		return va_arg(*ap, long);
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	8d 50 04             	lea    0x4(%eax),%edx
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	89 10                	mov    %edx,(%eax)
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	83 e8 04             	sub    $0x4,%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	99                   	cltd   
  800948:	eb 18                	jmp    800962 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	8d 50 04             	lea    0x4(%eax),%edx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	89 10                	mov    %edx,(%eax)
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	83 e8 04             	sub    $0x4,%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	99                   	cltd   
}
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	56                   	push   %esi
  800968:	53                   	push   %ebx
  800969:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096c:	eb 17                	jmp    800985 <vprintfmt+0x21>
			if (ch == '\0')
  80096e:	85 db                	test   %ebx,%ebx
  800970:	0f 84 af 03 00 00    	je     800d25 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	53                   	push   %ebx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800985:	8b 45 10             	mov    0x10(%ebp),%eax
  800988:	8d 50 01             	lea    0x1(%eax),%edx
  80098b:	89 55 10             	mov    %edx,0x10(%ebp)
  80098e:	8a 00                	mov    (%eax),%al
  800990:	0f b6 d8             	movzbl %al,%ebx
  800993:	83 fb 25             	cmp    $0x25,%ebx
  800996:	75 d6                	jne    80096e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800998:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bb:	8d 50 01             	lea    0x1(%eax),%edx
  8009be:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f b6 d8             	movzbl %al,%ebx
  8009c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c9:	83 f8 55             	cmp    $0x55,%eax
  8009cc:	0f 87 2b 03 00 00    	ja     800cfd <vprintfmt+0x399>
  8009d2:	8b 04 85 38 23 80 00 	mov    0x802338(,%eax,4),%eax
  8009d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009df:	eb d7                	jmp    8009b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e5:	eb d1                	jmp    8009b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f1:	89 d0                	mov    %edx,%eax
  8009f3:	c1 e0 02             	shl    $0x2,%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	01 d8                	add    %ebx,%eax
  8009fc:	83 e8 30             	sub    $0x30,%eax
  8009ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
  800a05:	8a 00                	mov    (%eax),%al
  800a07:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a0a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0d:	7e 3e                	jle    800a4d <vprintfmt+0xe9>
  800a0f:	83 fb 39             	cmp    $0x39,%ebx
  800a12:	7f 39                	jg     800a4d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a14:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a17:	eb d5                	jmp    8009ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	83 c0 04             	add    $0x4,%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 e8 04             	sub    $0x4,%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a2d:	eb 1f                	jmp    800a4e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a33:	79 83                	jns    8009b8 <vprintfmt+0x54>
				width = 0;
  800a35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3c:	e9 77 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a41:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a48:	e9 6b ff ff ff       	jmp    8009b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a52:	0f 89 60 ff ff ff    	jns    8009b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a65:	e9 4e ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a6a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a6d:	e9 46 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	83 c0 04             	add    $0x4,%eax
  800a78:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	83 e8 04             	sub    $0x4,%eax
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	50                   	push   %eax
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			break;
  800a92:	e9 89 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa8:	85 db                	test   %ebx,%ebx
  800aaa:	79 02                	jns    800aae <vprintfmt+0x14a>
				err = -err;
  800aac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aae:	83 fb 64             	cmp    $0x64,%ebx
  800ab1:	7f 0b                	jg     800abe <vprintfmt+0x15a>
  800ab3:	8b 34 9d 80 21 80 00 	mov    0x802180(,%ebx,4),%esi
  800aba:	85 f6                	test   %esi,%esi
  800abc:	75 19                	jne    800ad7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abe:	53                   	push   %ebx
  800abf:	68 25 23 80 00       	push   $0x802325
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 08             	pushl  0x8(%ebp)
  800aca:	e8 5e 02 00 00       	call   800d2d <printfmt>
  800acf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad2:	e9 49 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad7:	56                   	push   %esi
  800ad8:	68 2e 23 80 00       	push   $0x80232e
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	ff 75 08             	pushl  0x8(%ebp)
  800ae3:	e8 45 02 00 00       	call   800d2d <printfmt>
  800ae8:	83 c4 10             	add    $0x10,%esp
			break;
  800aeb:	e9 30 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	83 c0 04             	add    $0x4,%eax
  800af6:	89 45 14             	mov    %eax,0x14(%ebp)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	83 e8 04             	sub    $0x4,%eax
  800aff:	8b 30                	mov    (%eax),%esi
  800b01:	85 f6                	test   %esi,%esi
  800b03:	75 05                	jne    800b0a <vprintfmt+0x1a6>
				p = "(null)";
  800b05:	be 31 23 80 00       	mov    $0x802331,%esi
			if (width > 0 && padc != '-')
  800b0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0e:	7e 6d                	jle    800b7d <vprintfmt+0x219>
  800b10:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b14:	74 67                	je     800b7d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	50                   	push   %eax
  800b1d:	56                   	push   %esi
  800b1e:	e8 0c 03 00 00       	call   800e2f <strnlen>
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b29:	eb 16                	jmp    800b41 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b2b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	50                   	push   %eax
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	7f e4                	jg     800b2b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b47:	eb 34                	jmp    800b7d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b49:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b4d:	74 1c                	je     800b6b <vprintfmt+0x207>
  800b4f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b52:	7e 05                	jle    800b59 <vprintfmt+0x1f5>
  800b54:	83 fb 7e             	cmp    $0x7e,%ebx
  800b57:	7e 12                	jle    800b6b <vprintfmt+0x207>
					putch('?', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 3f                	push   $0x3f
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
  800b69:	eb 0f                	jmp    800b7a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	53                   	push   %ebx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	ff d0                	call   *%eax
  800b77:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	8d 70 01             	lea    0x1(%eax),%esi
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	0f be d8             	movsbl %al,%ebx
  800b87:	85 db                	test   %ebx,%ebx
  800b89:	74 24                	je     800baf <vprintfmt+0x24b>
  800b8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8f:	78 b8                	js     800b49 <vprintfmt+0x1e5>
  800b91:	ff 4d e0             	decl   -0x20(%ebp)
  800b94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b98:	79 af                	jns    800b49 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9a:	eb 13                	jmp    800baf <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	6a 20                	push   $0x20
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bac:	ff 4d e4             	decl   -0x1c(%ebp)
  800baf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb3:	7f e7                	jg     800b9c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb5:	e9 66 01 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bba:	83 ec 08             	sub    $0x8,%esp
  800bbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc3:	50                   	push   %eax
  800bc4:	e8 3c fd ff ff       	call   800905 <getint>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd8:	85 d2                	test   %edx,%edx
  800bda:	79 23                	jns    800bff <vprintfmt+0x29b>
				putch('-', putdat);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	6a 2d                	push   $0x2d
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	ff d0                	call   *%eax
  800be9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf2:	f7 d8                	neg    %eax
  800bf4:	83 d2 00             	adc    $0x0,%edx
  800bf7:	f7 da                	neg    %edx
  800bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c06:	e9 bc 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c11:	8d 45 14             	lea    0x14(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	e8 84 fc ff ff       	call   80089e <getuint>
  800c1a:	83 c4 10             	add    $0x10,%esp
  800c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c20:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c23:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2a:	e9 98 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	6a 58                	push   $0x58
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	ff d0                	call   *%eax
  800c3c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 58                	push   $0x58
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 58                	push   $0x58
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			break;
  800c5f:	e9 bc 00 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	6a 30                	push   $0x30
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 78                	push   $0x78
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	83 c0 04             	add    $0x4,%eax
  800c8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c90:	83 e8 04             	sub    $0x4,%eax
  800c93:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca6:	eb 1f                	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 e8             	pushl  -0x18(%ebp)
  800cae:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb1:	50                   	push   %eax
  800cb2:	e8 e7 fb ff ff       	call   80089e <getuint>
  800cb7:	83 c4 10             	add    $0x10,%esp
  800cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cce:	83 ec 04             	sub    $0x4,%esp
  800cd1:	52                   	push   %edx
  800cd2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd5:	50                   	push   %eax
  800cd6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd9:	ff 75 f0             	pushl  -0x10(%ebp)
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	ff 75 08             	pushl  0x8(%ebp)
  800ce2:	e8 00 fb ff ff       	call   8007e7 <printnum>
  800ce7:	83 c4 20             	add    $0x20,%esp
			break;
  800cea:	eb 34                	jmp    800d20 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cec:	83 ec 08             	sub    $0x8,%esp
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	53                   	push   %ebx
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	ff d0                	call   *%eax
  800cf8:	83 c4 10             	add    $0x10,%esp
			break;
  800cfb:	eb 23                	jmp    800d20 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 0c             	pushl  0xc(%ebp)
  800d03:	6a 25                	push   $0x25
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	ff d0                	call   *%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0d:	ff 4d 10             	decl   0x10(%ebp)
  800d10:	eb 03                	jmp    800d15 <vprintfmt+0x3b1>
  800d12:	ff 4d 10             	decl   0x10(%ebp)
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	48                   	dec    %eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 25                	cmp    $0x25,%al
  800d1d:	75 f3                	jne    800d12 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d1f:	90                   	nop
		}
	}
  800d20:	e9 47 fc ff ff       	jmp    80096c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d25:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d33:	8d 45 10             	lea    0x10(%ebp),%eax
  800d36:	83 c0 04             	add    $0x4,%eax
  800d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d42:	50                   	push   %eax
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	ff 75 08             	pushl  0x8(%ebp)
  800d49:	e8 16 fc ff ff       	call   800964 <vprintfmt>
  800d4e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d51:	90                   	nop
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8b 40 08             	mov    0x8(%eax),%eax
  800d5d:	8d 50 01             	lea    0x1(%eax),%edx
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	8b 10                	mov    (%eax),%edx
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	8b 40 04             	mov    0x4(%eax),%eax
  800d71:	39 c2                	cmp    %eax,%edx
  800d73:	73 12                	jae    800d87 <sprintputch+0x33>
		*b->buf++ = ch;
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 48 01             	lea    0x1(%eax),%ecx
  800d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d80:	89 0a                	mov    %ecx,(%edx)
  800d82:	8b 55 08             	mov    0x8(%ebp),%edx
  800d85:	88 10                	mov    %dl,(%eax)
}
  800d87:	90                   	nop
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	01 d0                	add    %edx,%eax
  800da1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800daf:	74 06                	je     800db7 <vsnprintf+0x2d>
  800db1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db5:	7f 07                	jg     800dbe <vsnprintf+0x34>
		return -E_INVAL;
  800db7:	b8 03 00 00 00       	mov    $0x3,%eax
  800dbc:	eb 20                	jmp    800dde <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dbe:	ff 75 14             	pushl  0x14(%ebp)
  800dc1:	ff 75 10             	pushl  0x10(%ebp)
  800dc4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc7:	50                   	push   %eax
  800dc8:	68 54 0d 80 00       	push   $0x800d54
  800dcd:	e8 92 fb ff ff       	call   800964 <vprintfmt>
  800dd2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de6:	8d 45 10             	lea    0x10(%ebp),%eax
  800de9:	83 c0 04             	add    $0x4,%eax
  800dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	ff 75 f4             	pushl  -0xc(%ebp)
  800df5:	50                   	push   %eax
  800df6:	ff 75 0c             	pushl  0xc(%ebp)
  800df9:	ff 75 08             	pushl  0x8(%ebp)
  800dfc:	e8 89 ff ff ff       	call   800d8a <vsnprintf>
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e19:	eb 06                	jmp    800e21 <strlen+0x15>
		n++;
  800e1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1e:	ff 45 08             	incl   0x8(%ebp)
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	84 c0                	test   %al,%al
  800e28:	75 f1                	jne    800e1b <strlen+0xf>
		n++;
	return n;
  800e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3c:	eb 09                	jmp    800e47 <strnlen+0x18>
		n++;
  800e3e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e41:	ff 45 08             	incl   0x8(%ebp)
  800e44:	ff 4d 0c             	decl   0xc(%ebp)
  800e47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4b:	74 09                	je     800e56 <strnlen+0x27>
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	84 c0                	test   %al,%al
  800e54:	75 e8                	jne    800e3e <strnlen+0xf>
		n++;
	return n;
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e67:	90                   	nop
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8d 50 01             	lea    0x1(%eax),%edx
  800e6e:	89 55 08             	mov    %edx,0x8(%ebp)
  800e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e74:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e77:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e7a:	8a 12                	mov    (%edx),%dl
  800e7c:	88 10                	mov    %dl,(%eax)
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	84 c0                	test   %al,%al
  800e82:	75 e4                	jne    800e68 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9c:	eb 1f                	jmp    800ebd <strncpy+0x34>
		*dst++ = *src;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8d 50 01             	lea    0x1(%eax),%edx
  800ea4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaa:	8a 12                	mov    (%edx),%dl
  800eac:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	84 c0                	test   %al,%al
  800eb5:	74 03                	je     800eba <strncpy+0x31>
			src++;
  800eb7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eba:	ff 45 fc             	incl   -0x4(%ebp)
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec3:	72 d9                	jb     800e9e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eda:	74 30                	je     800f0c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800edc:	eb 16                	jmp    800ef4 <strlcpy+0x2a>
			*dst++ = *src++;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef0:	8a 12                	mov    (%edx),%dl
  800ef2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef4:	ff 4d 10             	decl   0x10(%ebp)
  800ef7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efb:	74 09                	je     800f06 <strlcpy+0x3c>
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	84 c0                	test   %al,%al
  800f04:	75 d8                	jne    800ede <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f12:	29 c2                	sub    %eax,%edx
  800f14:	89 d0                	mov    %edx,%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f1b:	eb 06                	jmp    800f23 <strcmp+0xb>
		p++, q++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
  800f20:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	84 c0                	test   %al,%al
  800f2a:	74 0e                	je     800f3a <strcmp+0x22>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 10                	mov    (%eax),%dl
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	38 c2                	cmp    %al,%dl
  800f38:	74 e3                	je     800f1d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	0f b6 d0             	movzbl %al,%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 c0             	movzbl %al,%eax
  800f4a:	29 c2                	sub    %eax,%edx
  800f4c:	89 d0                	mov    %edx,%eax
}
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f53:	eb 09                	jmp    800f5e <strncmp+0xe>
		n--, p++, q++;
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	ff 45 08             	incl   0x8(%ebp)
  800f5b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f62:	74 17                	je     800f7b <strncmp+0x2b>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	84 c0                	test   %al,%al
  800f6b:	74 0e                	je     800f7b <strncmp+0x2b>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 10                	mov    (%eax),%dl
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	38 c2                	cmp    %al,%dl
  800f79:	74 da                	je     800f55 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	75 07                	jne    800f88 <strncmp+0x38>
		return 0;
  800f81:	b8 00 00 00 00       	mov    $0x0,%eax
  800f86:	eb 14                	jmp    800f9c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	0f b6 d0             	movzbl %al,%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	0f b6 c0             	movzbl %al,%eax
  800f98:	29 c2                	sub    %eax,%edx
  800f9a:	89 d0                	mov    %edx,%eax
}
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800faa:	eb 12                	jmp    800fbe <strchr+0x20>
		if (*s == c)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb4:	75 05                	jne    800fbb <strchr+0x1d>
			return (char *) s;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	eb 11                	jmp    800fcc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fbb:	ff 45 08             	incl   0x8(%ebp)
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	84 c0                	test   %al,%al
  800fc5:	75 e5                	jne    800fac <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 04             	sub    $0x4,%esp
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fda:	eb 0d                	jmp    800fe9 <strfind+0x1b>
		if (*s == c)
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe4:	74 0e                	je     800ff4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe6:	ff 45 08             	incl   0x8(%ebp)
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 ea                	jne    800fdc <strfind+0xe>
  800ff2:	eb 01                	jmp    800ff5 <strfind+0x27>
		if (*s == c)
			break;
  800ff4:	90                   	nop
	return (char *) s;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff8:	c9                   	leave  
  800ff9:	c3                   	ret    

00800ffa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80100c:	eb 0e                	jmp    80101c <memset+0x22>
		*p++ = c;
  80100e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801011:	8d 50 01             	lea    0x1(%eax),%edx
  801014:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80101c:	ff 4d f8             	decl   -0x8(%ebp)
  80101f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801023:	79 e9                	jns    80100e <memset+0x14>
		*p++ = c;

	return v;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80103c:	eb 16                	jmp    801054 <memcpy+0x2a>
		*d++ = *s++;
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	8d 50 01             	lea    0x1(%eax),%edx
  801044:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801047:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80104d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801050:	8a 12                	mov    (%edx),%dl
  801052:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105a:	89 55 10             	mov    %edx,0x10(%ebp)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	75 dd                	jne    80103e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107e:	73 50                	jae    8010d0 <memmove+0x6a>
  801080:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	01 d0                	add    %edx,%eax
  801088:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80108b:	76 43                	jbe    8010d0 <memmove+0x6a>
		s += n;
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801099:	eb 10                	jmp    8010ab <memmove+0x45>
			*--d = *--s;
  80109b:	ff 4d f8             	decl   -0x8(%ebp)
  80109e:	ff 4d fc             	decl   -0x4(%ebp)
  8010a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a4:	8a 10                	mov    (%eax),%dl
  8010a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	75 e3                	jne    80109b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b8:	eb 23                	jmp    8010dd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010cc:	8a 12                	mov    (%edx),%dl
  8010ce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	75 dd                	jne    8010ba <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010f4:	eb 2a                	jmp    801120 <memcmp+0x3e>
		if (*s1 != *s2)
  8010f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f9:	8a 10                	mov    (%eax),%dl
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	38 c2                	cmp    %al,%dl
  801102:	74 16                	je     80111a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	0f b6 d0             	movzbl %al,%edx
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	0f b6 c0             	movzbl %al,%eax
  801114:	29 c2                	sub    %eax,%edx
  801116:	89 d0                	mov    %edx,%eax
  801118:	eb 18                	jmp    801132 <memcmp+0x50>
		s1++, s2++;
  80111a:	ff 45 fc             	incl   -0x4(%ebp)
  80111d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	8d 50 ff             	lea    -0x1(%eax),%edx
  801126:	89 55 10             	mov    %edx,0x10(%ebp)
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 c9                	jne    8010f6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80112d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	01 d0                	add    %edx,%eax
  801142:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801145:	eb 15                	jmp    80115c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f b6 d0             	movzbl %al,%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	39 c2                	cmp    %eax,%edx
  801157:	74 0d                	je     801166 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801159:	ff 45 08             	incl   0x8(%ebp)
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801162:	72 e3                	jb     801147 <memfind+0x13>
  801164:	eb 01                	jmp    801167 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801166:	90                   	nop
	return (void *) s;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801180:	eb 03                	jmp    801185 <strtol+0x19>
		s++;
  801182:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	3c 20                	cmp    $0x20,%al
  80118c:	74 f4                	je     801182 <strtol+0x16>
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 09                	cmp    $0x9,%al
  801195:	74 eb                	je     801182 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 2b                	cmp    $0x2b,%al
  80119e:	75 05                	jne    8011a5 <strtol+0x39>
		s++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	eb 13                	jmp    8011b8 <strtol+0x4c>
	else if (*s == '-')
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3c 2d                	cmp    $0x2d,%al
  8011ac:	75 0a                	jne    8011b8 <strtol+0x4c>
		s++, neg = 1;
  8011ae:	ff 45 08             	incl   0x8(%ebp)
  8011b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bc:	74 06                	je     8011c4 <strtol+0x58>
  8011be:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011c2:	75 20                	jne    8011e4 <strtol+0x78>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	3c 30                	cmp    $0x30,%al
  8011cb:	75 17                	jne    8011e4 <strtol+0x78>
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	40                   	inc    %eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	3c 78                	cmp    $0x78,%al
  8011d5:	75 0d                	jne    8011e4 <strtol+0x78>
		s += 2, base = 16;
  8011d7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011db:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011e2:	eb 28                	jmp    80120c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 15                	jne    8011ff <strtol+0x93>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 30                	cmp    $0x30,%al
  8011f1:	75 0c                	jne    8011ff <strtol+0x93>
		s++, base = 8;
  8011f3:	ff 45 08             	incl   0x8(%ebp)
  8011f6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011fd:	eb 0d                	jmp    80120c <strtol+0xa0>
	else if (base == 0)
  8011ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801203:	75 07                	jne    80120c <strtol+0xa0>
		base = 10;
  801205:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 2f                	cmp    $0x2f,%al
  801213:	7e 19                	jle    80122e <strtol+0xc2>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	3c 39                	cmp    $0x39,%al
  80121c:	7f 10                	jg     80122e <strtol+0xc2>
			dig = *s - '0';
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f be c0             	movsbl %al,%eax
  801226:	83 e8 30             	sub    $0x30,%eax
  801229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80122c:	eb 42                	jmp    801270 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 60                	cmp    $0x60,%al
  801235:	7e 19                	jle    801250 <strtol+0xe4>
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	3c 7a                	cmp    $0x7a,%al
  80123e:	7f 10                	jg     801250 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f be c0             	movsbl %al,%eax
  801248:	83 e8 57             	sub    $0x57,%eax
  80124b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80124e:	eb 20                	jmp    801270 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 40                	cmp    $0x40,%al
  801257:	7e 39                	jle    801292 <strtol+0x126>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 5a                	cmp    $0x5a,%al
  801260:	7f 30                	jg     801292 <strtol+0x126>
			dig = *s - 'A' + 10;
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	0f be c0             	movsbl %al,%eax
  80126a:	83 e8 37             	sub    $0x37,%eax
  80126d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801273:	3b 45 10             	cmp    0x10(%ebp),%eax
  801276:	7d 19                	jge    801291 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801278:	ff 45 08             	incl   0x8(%ebp)
  80127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801282:	89 c2                	mov    %eax,%edx
  801284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80128c:	e9 7b ff ff ff       	jmp    80120c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801291:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801292:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801296:	74 08                	je     8012a0 <strtol+0x134>
		*endptr = (char *) s;
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	8b 55 08             	mov    0x8(%ebp),%edx
  80129e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a4:	74 07                	je     8012ad <strtol+0x141>
  8012a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a9:	f7 d8                	neg    %eax
  8012ab:	eb 03                	jmp    8012b0 <strtol+0x144>
  8012ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <ltostr>:

void
ltostr(long value, char *str)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ca:	79 13                	jns    8012df <ltostr+0x2d>
	{
		neg = 1;
  8012cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012d9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012dc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012e7:	99                   	cltd   
  8012e8:	f7 f9                	idiv   %ecx
  8012ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f0:	8d 50 01             	lea    0x1(%eax),%edx
  8012f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801300:	83 c2 30             	add    $0x30,%edx
  801303:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801305:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801308:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130d:	f7 e9                	imul   %ecx
  80130f:	c1 fa 02             	sar    $0x2,%edx
  801312:	89 c8                	mov    %ecx,%eax
  801314:	c1 f8 1f             	sar    $0x1f,%eax
  801317:	29 c2                	sub    %eax,%edx
  801319:	89 d0                	mov    %edx,%eax
  80131b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80131e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801321:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801326:	f7 e9                	imul   %ecx
  801328:	c1 fa 02             	sar    $0x2,%edx
  80132b:	89 c8                	mov    %ecx,%eax
  80132d:	c1 f8 1f             	sar    $0x1f,%eax
  801330:	29 c2                	sub    %eax,%edx
  801332:	89 d0                	mov    %edx,%eax
  801334:	c1 e0 02             	shl    $0x2,%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	01 c0                	add    %eax,%eax
  80133b:	29 c1                	sub    %eax,%ecx
  80133d:	89 ca                	mov    %ecx,%edx
  80133f:	85 d2                	test   %edx,%edx
  801341:	75 9c                	jne    8012df <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801343:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80134a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134d:	48                   	dec    %eax
  80134e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801351:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801355:	74 3d                	je     801394 <ltostr+0xe2>
		start = 1 ;
  801357:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80135e:	eb 34                	jmp    801394 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80136d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 c2                	add    %eax,%edx
  801375:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	01 c8                	add    %ecx,%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801381:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 c2                	add    %eax,%edx
  801389:	8a 45 eb             	mov    -0x15(%ebp),%al
  80138c:	88 02                	mov    %al,(%edx)
		start++ ;
  80138e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801391:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801397:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80139a:	7c c4                	jl     801360 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80139c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	01 d0                	add    %edx,%eax
  8013a4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013a7:	90                   	nop
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013b0:	ff 75 08             	pushl  0x8(%ebp)
  8013b3:	e8 54 fa ff ff       	call   800e0c <strlen>
  8013b8:	83 c4 04             	add    $0x4,%esp
  8013bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	e8 46 fa ff ff       	call   800e0c <strlen>
  8013c6:	83 c4 04             	add    $0x4,%esp
  8013c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013da:	eb 17                	jmp    8013f3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 c2                	add    %eax,%edx
  8013e4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	01 c8                	add    %ecx,%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013f0:	ff 45 fc             	incl   -0x4(%ebp)
  8013f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013f9:	7c e1                	jl     8013dc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801402:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801409:	eb 1f                	jmp    80142a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140e:	8d 50 01             	lea    0x1(%eax),%edx
  801411:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801414:	89 c2                	mov    %eax,%edx
  801416:	8b 45 10             	mov    0x10(%ebp),%eax
  801419:	01 c2                	add    %eax,%edx
  80141b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	01 c8                	add    %ecx,%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801427:	ff 45 f8             	incl   -0x8(%ebp)
  80142a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801430:	7c d9                	jl     80140b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	c6 00 00             	movb   $0x0,(%eax)
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801443:	8b 45 14             	mov    0x14(%ebp),%eax
  801446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80144c:	8b 45 14             	mov    0x14(%ebp),%eax
  80144f:	8b 00                	mov    (%eax),%eax
  801451:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801463:	eb 0c                	jmp    801471 <strsplit+0x31>
			*string++ = 0;
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 08             	mov    %edx,0x8(%ebp)
  80146e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8a 00                	mov    (%eax),%al
  801476:	84 c0                	test   %al,%al
  801478:	74 18                	je     801492 <strsplit+0x52>
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	0f be c0             	movsbl %al,%eax
  801482:	50                   	push   %eax
  801483:	ff 75 0c             	pushl  0xc(%ebp)
  801486:	e8 13 fb ff ff       	call   800f9e <strchr>
  80148b:	83 c4 08             	add    $0x8,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	75 d3                	jne    801465 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 5a                	je     8014f5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80149b:	8b 45 14             	mov    0x14(%ebp),%eax
  80149e:	8b 00                	mov    (%eax),%eax
  8014a0:	83 f8 0f             	cmp    $0xf,%eax
  8014a3:	75 07                	jne    8014ac <strsplit+0x6c>
		{
			return 0;
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	eb 66                	jmp    801512 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b4:	8b 55 14             	mov    0x14(%ebp),%edx
  8014b7:	89 0a                	mov    %ecx,(%edx)
  8014b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c3:	01 c2                	add    %eax,%edx
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ca:	eb 03                	jmp    8014cf <strsplit+0x8f>
			string++;
  8014cc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8a 00                	mov    (%eax),%al
  8014d4:	84 c0                	test   %al,%al
  8014d6:	74 8b                	je     801463 <strsplit+0x23>
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	0f be c0             	movsbl %al,%eax
  8014e0:	50                   	push   %eax
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	e8 b5 fa ff ff       	call   800f9e <strchr>
  8014e9:	83 c4 08             	add    $0x8,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	74 dc                	je     8014cc <strsplit+0x8c>
			string++;
	}
  8014f0:	e9 6e ff ff ff       	jmp    801463 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014f5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80150d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80151a:	83 ec 04             	sub    $0x4,%esp
  80151d:	68 90 24 80 00       	push   $0x802490
  801522:	6a 19                	push   $0x19
  801524:	68 b5 24 80 00       	push   $0x8024b5
  801529:	e8 ba ef ff ff       	call   8004e8 <_panic>

0080152e <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 18             	sub    $0x18,%esp
  801534:	8b 45 10             	mov    0x10(%ebp),%eax
  801537:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80153a:	83 ec 04             	sub    $0x4,%esp
  80153d:	68 c4 24 80 00       	push   $0x8024c4
  801542:	6a 31                	push   $0x31
  801544:	68 b5 24 80 00       	push   $0x8024b5
  801549:	e8 9a ef ff ff       	call   8004e8 <_panic>

0080154e <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801554:	83 ec 04             	sub    $0x4,%esp
  801557:	68 ec 24 80 00       	push   $0x8024ec
  80155c:	6a 4a                	push   $0x4a
  80155e:	68 b5 24 80 00       	push   $0x8024b5
  801563:	e8 80 ef ff ff       	call   8004e8 <_panic>

00801568 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	68 10 25 80 00       	push   $0x802510
  801576:	6a 70                	push   $0x70
  801578:	68 b5 24 80 00       	push   $0x8024b5
  80157d:	e8 66 ef ff ff       	call   8004e8 <_panic>

00801582 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801588:	83 ec 04             	sub    $0x4,%esp
  80158b:	68 34 25 80 00       	push   $0x802534
  801590:	68 8b 00 00 00       	push   $0x8b
  801595:	68 b5 24 80 00       	push   $0x8024b5
  80159a:	e8 49 ef ff ff       	call   8004e8 <_panic>

0080159f <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015a5:	83 ec 04             	sub    $0x4,%esp
  8015a8:	68 58 25 80 00       	push   $0x802558
  8015ad:	68 a8 00 00 00       	push   $0xa8
  8015b2:	68 b5 24 80 00       	push   $0x8024b5
  8015b7:	e8 2c ef ff ff       	call   8004e8 <_panic>

008015bc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	57                   	push   %edi
  8015c0:	56                   	push   %esi
  8015c1:	53                   	push   %ebx
  8015c2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015d1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015d4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015d7:	cd 30                	int    $0x30
  8015d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	5b                   	pop    %ebx
  8015e3:	5e                   	pop    %esi
  8015e4:	5f                   	pop    %edi
  8015e5:	5d                   	pop    %ebp
  8015e6:	c3                   	ret    

008015e7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	83 ec 04             	sub    $0x4,%esp
  8015ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015f3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	52                   	push   %edx
  8015ff:	ff 75 0c             	pushl  0xc(%ebp)
  801602:	50                   	push   %eax
  801603:	6a 00                	push   $0x0
  801605:	e8 b2 ff ff ff       	call   8015bc <syscall>
  80160a:	83 c4 18             	add    $0x18,%esp
}
  80160d:	90                   	nop
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <sys_cgetc>:

int
sys_cgetc(void)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 01                	push   $0x1
  80161f:	e8 98 ff ff ff       	call   8015bc <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	50                   	push   %eax
  801638:	6a 05                	push   $0x5
  80163a:	e8 7d ff ff ff       	call   8015bc <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 02                	push   $0x2
  801653:	e8 64 ff ff ff       	call   8015bc <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 03                	push   $0x3
  80166c:	e8 4b ff ff ff       	call   8015bc <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 04                	push   $0x4
  801685:	e8 32 ff ff ff       	call   8015bc <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
}
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <sys_env_exit>:


void sys_env_exit(void)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 06                	push   $0x6
  80169e:	e8 19 ff ff ff       	call   8015bc <syscall>
  8016a3:	83 c4 18             	add    $0x18,%esp
}
  8016a6:	90                   	nop
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	52                   	push   %edx
  8016b9:	50                   	push   %eax
  8016ba:	6a 07                	push   $0x7
  8016bc:	e8 fb fe ff ff       	call   8015bc <syscall>
  8016c1:	83 c4 18             	add    $0x18,%esp
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	56                   	push   %esi
  8016ca:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016cb:	8b 75 18             	mov    0x18(%ebp),%esi
  8016ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	56                   	push   %esi
  8016db:	53                   	push   %ebx
  8016dc:	51                   	push   %ecx
  8016dd:	52                   	push   %edx
  8016de:	50                   	push   %eax
  8016df:	6a 08                	push   $0x8
  8016e1:	e8 d6 fe ff ff       	call   8015bc <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
}
  8016e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ec:	5b                   	pop    %ebx
  8016ed:	5e                   	pop    %esi
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    

008016f0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	52                   	push   %edx
  801700:	50                   	push   %eax
  801701:	6a 09                	push   $0x9
  801703:	e8 b4 fe ff ff       	call   8015bc <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	ff 75 0c             	pushl  0xc(%ebp)
  801719:	ff 75 08             	pushl  0x8(%ebp)
  80171c:	6a 0a                	push   $0xa
  80171e:	e8 99 fe ff ff       	call   8015bc <syscall>
  801723:	83 c4 18             	add    $0x18,%esp
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 0b                	push   $0xb
  801737:	e8 80 fe ff ff       	call   8015bc <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 0c                	push   $0xc
  801750:	e8 67 fe ff ff       	call   8015bc <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 0d                	push   $0xd
  801769:	e8 4e fe ff ff       	call   8015bc <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	ff 75 0c             	pushl  0xc(%ebp)
  80177f:	ff 75 08             	pushl  0x8(%ebp)
  801782:	6a 11                	push   $0x11
  801784:	e8 33 fe ff ff       	call   8015bc <syscall>
  801789:	83 c4 18             	add    $0x18,%esp
	return;
  80178c:	90                   	nop
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	ff 75 0c             	pushl  0xc(%ebp)
  80179b:	ff 75 08             	pushl  0x8(%ebp)
  80179e:	6a 12                	push   $0x12
  8017a0:	e8 17 fe ff ff       	call   8015bc <syscall>
  8017a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a8:	90                   	nop
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 0e                	push   $0xe
  8017ba:	e8 fd fd ff ff       	call   8015bc <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	ff 75 08             	pushl  0x8(%ebp)
  8017d2:	6a 0f                	push   $0xf
  8017d4:	e8 e3 fd ff ff       	call   8015bc <syscall>
  8017d9:	83 c4 18             	add    $0x18,%esp
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 10                	push   $0x10
  8017ed:	e8 ca fd ff ff       	call   8015bc <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
}
  8017f5:	90                   	nop
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 14                	push   $0x14
  801807:	e8 b0 fd ff ff       	call   8015bc <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
}
  80180f:	90                   	nop
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 15                	push   $0x15
  801821:	e8 96 fd ff ff       	call   8015bc <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	90                   	nop
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <sys_cputc>:


void
sys_cputc(const char c)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	83 ec 04             	sub    $0x4,%esp
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801838:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	50                   	push   %eax
  801845:	6a 16                	push   $0x16
  801847:	e8 70 fd ff ff       	call   8015bc <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
}
  80184f:	90                   	nop
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 17                	push   $0x17
  801861:	e8 56 fd ff ff       	call   8015bc <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	90                   	nop
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	ff 75 0c             	pushl  0xc(%ebp)
  80187b:	50                   	push   %eax
  80187c:	6a 18                	push   $0x18
  80187e:	e8 39 fd ff ff       	call   8015bc <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80188b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	52                   	push   %edx
  801898:	50                   	push   %eax
  801899:	6a 1b                	push   $0x1b
  80189b:	e8 1c fd ff ff       	call   8015bc <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	52                   	push   %edx
  8018b5:	50                   	push   %eax
  8018b6:	6a 19                	push   $0x19
  8018b8:	e8 ff fc ff ff       	call   8015bc <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
}
  8018c0:	90                   	nop
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	52                   	push   %edx
  8018d3:	50                   	push   %eax
  8018d4:	6a 1a                	push   $0x1a
  8018d6:	e8 e1 fc ff ff       	call   8015bc <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	90                   	nop
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	83 ec 04             	sub    $0x4,%esp
  8018e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018ed:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018f0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	6a 00                	push   $0x0
  8018f9:	51                   	push   %ecx
  8018fa:	52                   	push   %edx
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	50                   	push   %eax
  8018ff:	6a 1c                	push   $0x1c
  801901:	e8 b6 fc ff ff       	call   8015bc <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80190e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	52                   	push   %edx
  80191b:	50                   	push   %eax
  80191c:	6a 1d                	push   $0x1d
  80191e:	e8 99 fc ff ff       	call   8015bc <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80192b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	51                   	push   %ecx
  801939:	52                   	push   %edx
  80193a:	50                   	push   %eax
  80193b:	6a 1e                	push   $0x1e
  80193d:	e8 7a fc ff ff       	call   8015bc <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80194a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	52                   	push   %edx
  801957:	50                   	push   %eax
  801958:	6a 1f                	push   $0x1f
  80195a:	e8 5d fc ff ff       	call   8015bc <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 20                	push   $0x20
  801973:	e8 44 fc ff ff       	call   8015bc <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	ff 75 10             	pushl  0x10(%ebp)
  80198a:	ff 75 0c             	pushl  0xc(%ebp)
  80198d:	50                   	push   %eax
  80198e:	6a 21                	push   $0x21
  801990:	e8 27 fc ff ff       	call   8015bc <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_run_env>:


void
sys_run_env(int32 envId)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	50                   	push   %eax
  8019a9:	6a 22                	push   $0x22
  8019ab:	e8 0c fc ff ff       	call   8015bc <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	90                   	nop
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	50                   	push   %eax
  8019c5:	6a 23                	push   $0x23
  8019c7:	e8 f0 fb ff ff       	call   8015bc <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019d8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019db:	8d 50 04             	lea    0x4(%eax),%edx
  8019de:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	52                   	push   %edx
  8019e8:	50                   	push   %eax
  8019e9:	6a 24                	push   $0x24
  8019eb:	e8 cc fb ff ff       	call   8015bc <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
	return result;
  8019f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019fc:	89 01                	mov    %eax,(%ecx)
  8019fe:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	c9                   	leave  
  801a05:	c2 04 00             	ret    $0x4

00801a08 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	ff 75 10             	pushl  0x10(%ebp)
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	ff 75 08             	pushl  0x8(%ebp)
  801a18:	6a 13                	push   $0x13
  801a1a:	e8 9d fb ff ff       	call   8015bc <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a22:	90                   	nop
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 25                	push   $0x25
  801a34:	e8 83 fb ff ff       	call   8015bc <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	83 ec 04             	sub    $0x4,%esp
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a4a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	50                   	push   %eax
  801a57:	6a 26                	push   $0x26
  801a59:	e8 5e fb ff ff       	call   8015bc <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a61:	90                   	nop
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <rsttst>:
void rsttst()
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 28                	push   $0x28
  801a73:	e8 44 fb ff ff       	call   8015bc <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7b:	90                   	nop
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	83 ec 04             	sub    $0x4,%esp
  801a84:	8b 45 14             	mov    0x14(%ebp),%eax
  801a87:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a8a:	8b 55 18             	mov    0x18(%ebp),%edx
  801a8d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a91:	52                   	push   %edx
  801a92:	50                   	push   %eax
  801a93:	ff 75 10             	pushl  0x10(%ebp)
  801a96:	ff 75 0c             	pushl  0xc(%ebp)
  801a99:	ff 75 08             	pushl  0x8(%ebp)
  801a9c:	6a 27                	push   $0x27
  801a9e:	e8 19 fb ff ff       	call   8015bc <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa6:	90                   	nop
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <chktst>:
void chktst(uint32 n)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	ff 75 08             	pushl  0x8(%ebp)
  801ab7:	6a 29                	push   $0x29
  801ab9:	e8 fe fa ff ff       	call   8015bc <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac1:	90                   	nop
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <inctst>:

void inctst()
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 2a                	push   $0x2a
  801ad3:	e8 e4 fa ff ff       	call   8015bc <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
	return ;
  801adb:	90                   	nop
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <gettst>:
uint32 gettst()
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 2b                	push   $0x2b
  801aed:	e8 ca fa ff ff       	call   8015bc <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 2c                	push   $0x2c
  801b09:	e8 ae fa ff ff       	call   8015bc <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
  801b11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b14:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b18:	75 07                	jne    801b21 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1f:	eb 05                	jmp    801b26 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 2c                	push   $0x2c
  801b3a:	e8 7d fa ff ff       	call   8015bc <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
  801b42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b45:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b49:	75 07                	jne    801b52 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b4b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b50:	eb 05                	jmp    801b57 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 2c                	push   $0x2c
  801b6b:	e8 4c fa ff ff       	call   8015bc <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
  801b73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b76:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b7a:	75 07                	jne    801b83 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b7c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b81:	eb 05                	jmp    801b88 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 2c                	push   $0x2c
  801b9c:	e8 1b fa ff ff       	call   8015bc <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
  801ba4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ba7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bab:	75 07                	jne    801bb4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bad:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb2:	eb 05                	jmp    801bb9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	ff 75 08             	pushl  0x8(%ebp)
  801bc9:	6a 2d                	push   $0x2d
  801bcb:	e8 ec f9 ff ff       	call   8015bc <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd3:	90                   	nop
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801bda:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bdd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	6a 00                	push   $0x0
  801be8:	53                   	push   %ebx
  801be9:	51                   	push   %ecx
  801bea:	52                   	push   %edx
  801beb:	50                   	push   %eax
  801bec:	6a 2e                	push   $0x2e
  801bee:	e8 c9 f9 ff ff       	call   8015bc <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	52                   	push   %edx
  801c0b:	50                   	push   %eax
  801c0c:	6a 2f                	push   $0x2f
  801c0e:	e8 a9 f9 ff ff       	call   8015bc <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <__udivdi3>:
  801c18:	55                   	push   %ebp
  801c19:	57                   	push   %edi
  801c1a:	56                   	push   %esi
  801c1b:	53                   	push   %ebx
  801c1c:	83 ec 1c             	sub    $0x1c,%esp
  801c1f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c23:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c2b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c2f:	89 ca                	mov    %ecx,%edx
  801c31:	89 f8                	mov    %edi,%eax
  801c33:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c37:	85 f6                	test   %esi,%esi
  801c39:	75 2d                	jne    801c68 <__udivdi3+0x50>
  801c3b:	39 cf                	cmp    %ecx,%edi
  801c3d:	77 65                	ja     801ca4 <__udivdi3+0x8c>
  801c3f:	89 fd                	mov    %edi,%ebp
  801c41:	85 ff                	test   %edi,%edi
  801c43:	75 0b                	jne    801c50 <__udivdi3+0x38>
  801c45:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4a:	31 d2                	xor    %edx,%edx
  801c4c:	f7 f7                	div    %edi
  801c4e:	89 c5                	mov    %eax,%ebp
  801c50:	31 d2                	xor    %edx,%edx
  801c52:	89 c8                	mov    %ecx,%eax
  801c54:	f7 f5                	div    %ebp
  801c56:	89 c1                	mov    %eax,%ecx
  801c58:	89 d8                	mov    %ebx,%eax
  801c5a:	f7 f5                	div    %ebp
  801c5c:	89 cf                	mov    %ecx,%edi
  801c5e:	89 fa                	mov    %edi,%edx
  801c60:	83 c4 1c             	add    $0x1c,%esp
  801c63:	5b                   	pop    %ebx
  801c64:	5e                   	pop    %esi
  801c65:	5f                   	pop    %edi
  801c66:	5d                   	pop    %ebp
  801c67:	c3                   	ret    
  801c68:	39 ce                	cmp    %ecx,%esi
  801c6a:	77 28                	ja     801c94 <__udivdi3+0x7c>
  801c6c:	0f bd fe             	bsr    %esi,%edi
  801c6f:	83 f7 1f             	xor    $0x1f,%edi
  801c72:	75 40                	jne    801cb4 <__udivdi3+0x9c>
  801c74:	39 ce                	cmp    %ecx,%esi
  801c76:	72 0a                	jb     801c82 <__udivdi3+0x6a>
  801c78:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c7c:	0f 87 9e 00 00 00    	ja     801d20 <__udivdi3+0x108>
  801c82:	b8 01 00 00 00       	mov    $0x1,%eax
  801c87:	89 fa                	mov    %edi,%edx
  801c89:	83 c4 1c             	add    $0x1c,%esp
  801c8c:	5b                   	pop    %ebx
  801c8d:	5e                   	pop    %esi
  801c8e:	5f                   	pop    %edi
  801c8f:	5d                   	pop    %ebp
  801c90:	c3                   	ret    
  801c91:	8d 76 00             	lea    0x0(%esi),%esi
  801c94:	31 ff                	xor    %edi,%edi
  801c96:	31 c0                	xor    %eax,%eax
  801c98:	89 fa                	mov    %edi,%edx
  801c9a:	83 c4 1c             	add    $0x1c,%esp
  801c9d:	5b                   	pop    %ebx
  801c9e:	5e                   	pop    %esi
  801c9f:	5f                   	pop    %edi
  801ca0:	5d                   	pop    %ebp
  801ca1:	c3                   	ret    
  801ca2:	66 90                	xchg   %ax,%ax
  801ca4:	89 d8                	mov    %ebx,%eax
  801ca6:	f7 f7                	div    %edi
  801ca8:	31 ff                	xor    %edi,%edi
  801caa:	89 fa                	mov    %edi,%edx
  801cac:	83 c4 1c             	add    $0x1c,%esp
  801caf:	5b                   	pop    %ebx
  801cb0:	5e                   	pop    %esi
  801cb1:	5f                   	pop    %edi
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    
  801cb4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cb9:	89 eb                	mov    %ebp,%ebx
  801cbb:	29 fb                	sub    %edi,%ebx
  801cbd:	89 f9                	mov    %edi,%ecx
  801cbf:	d3 e6                	shl    %cl,%esi
  801cc1:	89 c5                	mov    %eax,%ebp
  801cc3:	88 d9                	mov    %bl,%cl
  801cc5:	d3 ed                	shr    %cl,%ebp
  801cc7:	89 e9                	mov    %ebp,%ecx
  801cc9:	09 f1                	or     %esi,%ecx
  801ccb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ccf:	89 f9                	mov    %edi,%ecx
  801cd1:	d3 e0                	shl    %cl,%eax
  801cd3:	89 c5                	mov    %eax,%ebp
  801cd5:	89 d6                	mov    %edx,%esi
  801cd7:	88 d9                	mov    %bl,%cl
  801cd9:	d3 ee                	shr    %cl,%esi
  801cdb:	89 f9                	mov    %edi,%ecx
  801cdd:	d3 e2                	shl    %cl,%edx
  801cdf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ce3:	88 d9                	mov    %bl,%cl
  801ce5:	d3 e8                	shr    %cl,%eax
  801ce7:	09 c2                	or     %eax,%edx
  801ce9:	89 d0                	mov    %edx,%eax
  801ceb:	89 f2                	mov    %esi,%edx
  801ced:	f7 74 24 0c          	divl   0xc(%esp)
  801cf1:	89 d6                	mov    %edx,%esi
  801cf3:	89 c3                	mov    %eax,%ebx
  801cf5:	f7 e5                	mul    %ebp
  801cf7:	39 d6                	cmp    %edx,%esi
  801cf9:	72 19                	jb     801d14 <__udivdi3+0xfc>
  801cfb:	74 0b                	je     801d08 <__udivdi3+0xf0>
  801cfd:	89 d8                	mov    %ebx,%eax
  801cff:	31 ff                	xor    %edi,%edi
  801d01:	e9 58 ff ff ff       	jmp    801c5e <__udivdi3+0x46>
  801d06:	66 90                	xchg   %ax,%ax
  801d08:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d0c:	89 f9                	mov    %edi,%ecx
  801d0e:	d3 e2                	shl    %cl,%edx
  801d10:	39 c2                	cmp    %eax,%edx
  801d12:	73 e9                	jae    801cfd <__udivdi3+0xe5>
  801d14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d17:	31 ff                	xor    %edi,%edi
  801d19:	e9 40 ff ff ff       	jmp    801c5e <__udivdi3+0x46>
  801d1e:	66 90                	xchg   %ax,%ax
  801d20:	31 c0                	xor    %eax,%eax
  801d22:	e9 37 ff ff ff       	jmp    801c5e <__udivdi3+0x46>
  801d27:	90                   	nop

00801d28 <__umoddi3>:
  801d28:	55                   	push   %ebp
  801d29:	57                   	push   %edi
  801d2a:	56                   	push   %esi
  801d2b:	53                   	push   %ebx
  801d2c:	83 ec 1c             	sub    $0x1c,%esp
  801d2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d33:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d47:	89 f3                	mov    %esi,%ebx
  801d49:	89 fa                	mov    %edi,%edx
  801d4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d4f:	89 34 24             	mov    %esi,(%esp)
  801d52:	85 c0                	test   %eax,%eax
  801d54:	75 1a                	jne    801d70 <__umoddi3+0x48>
  801d56:	39 f7                	cmp    %esi,%edi
  801d58:	0f 86 a2 00 00 00    	jbe    801e00 <__umoddi3+0xd8>
  801d5e:	89 c8                	mov    %ecx,%eax
  801d60:	89 f2                	mov    %esi,%edx
  801d62:	f7 f7                	div    %edi
  801d64:	89 d0                	mov    %edx,%eax
  801d66:	31 d2                	xor    %edx,%edx
  801d68:	83 c4 1c             	add    $0x1c,%esp
  801d6b:	5b                   	pop    %ebx
  801d6c:	5e                   	pop    %esi
  801d6d:	5f                   	pop    %edi
  801d6e:	5d                   	pop    %ebp
  801d6f:	c3                   	ret    
  801d70:	39 f0                	cmp    %esi,%eax
  801d72:	0f 87 ac 00 00 00    	ja     801e24 <__umoddi3+0xfc>
  801d78:	0f bd e8             	bsr    %eax,%ebp
  801d7b:	83 f5 1f             	xor    $0x1f,%ebp
  801d7e:	0f 84 ac 00 00 00    	je     801e30 <__umoddi3+0x108>
  801d84:	bf 20 00 00 00       	mov    $0x20,%edi
  801d89:	29 ef                	sub    %ebp,%edi
  801d8b:	89 fe                	mov    %edi,%esi
  801d8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d91:	89 e9                	mov    %ebp,%ecx
  801d93:	d3 e0                	shl    %cl,%eax
  801d95:	89 d7                	mov    %edx,%edi
  801d97:	89 f1                	mov    %esi,%ecx
  801d99:	d3 ef                	shr    %cl,%edi
  801d9b:	09 c7                	or     %eax,%edi
  801d9d:	89 e9                	mov    %ebp,%ecx
  801d9f:	d3 e2                	shl    %cl,%edx
  801da1:	89 14 24             	mov    %edx,(%esp)
  801da4:	89 d8                	mov    %ebx,%eax
  801da6:	d3 e0                	shl    %cl,%eax
  801da8:	89 c2                	mov    %eax,%edx
  801daa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dae:	d3 e0                	shl    %cl,%eax
  801db0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801db8:	89 f1                	mov    %esi,%ecx
  801dba:	d3 e8                	shr    %cl,%eax
  801dbc:	09 d0                	or     %edx,%eax
  801dbe:	d3 eb                	shr    %cl,%ebx
  801dc0:	89 da                	mov    %ebx,%edx
  801dc2:	f7 f7                	div    %edi
  801dc4:	89 d3                	mov    %edx,%ebx
  801dc6:	f7 24 24             	mull   (%esp)
  801dc9:	89 c6                	mov    %eax,%esi
  801dcb:	89 d1                	mov    %edx,%ecx
  801dcd:	39 d3                	cmp    %edx,%ebx
  801dcf:	0f 82 87 00 00 00    	jb     801e5c <__umoddi3+0x134>
  801dd5:	0f 84 91 00 00 00    	je     801e6c <__umoddi3+0x144>
  801ddb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ddf:	29 f2                	sub    %esi,%edx
  801de1:	19 cb                	sbb    %ecx,%ebx
  801de3:	89 d8                	mov    %ebx,%eax
  801de5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801de9:	d3 e0                	shl    %cl,%eax
  801deb:	89 e9                	mov    %ebp,%ecx
  801ded:	d3 ea                	shr    %cl,%edx
  801def:	09 d0                	or     %edx,%eax
  801df1:	89 e9                	mov    %ebp,%ecx
  801df3:	d3 eb                	shr    %cl,%ebx
  801df5:	89 da                	mov    %ebx,%edx
  801df7:	83 c4 1c             	add    $0x1c,%esp
  801dfa:	5b                   	pop    %ebx
  801dfb:	5e                   	pop    %esi
  801dfc:	5f                   	pop    %edi
  801dfd:	5d                   	pop    %ebp
  801dfe:	c3                   	ret    
  801dff:	90                   	nop
  801e00:	89 fd                	mov    %edi,%ebp
  801e02:	85 ff                	test   %edi,%edi
  801e04:	75 0b                	jne    801e11 <__umoddi3+0xe9>
  801e06:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0b:	31 d2                	xor    %edx,%edx
  801e0d:	f7 f7                	div    %edi
  801e0f:	89 c5                	mov    %eax,%ebp
  801e11:	89 f0                	mov    %esi,%eax
  801e13:	31 d2                	xor    %edx,%edx
  801e15:	f7 f5                	div    %ebp
  801e17:	89 c8                	mov    %ecx,%eax
  801e19:	f7 f5                	div    %ebp
  801e1b:	89 d0                	mov    %edx,%eax
  801e1d:	e9 44 ff ff ff       	jmp    801d66 <__umoddi3+0x3e>
  801e22:	66 90                	xchg   %ax,%ax
  801e24:	89 c8                	mov    %ecx,%eax
  801e26:	89 f2                	mov    %esi,%edx
  801e28:	83 c4 1c             	add    $0x1c,%esp
  801e2b:	5b                   	pop    %ebx
  801e2c:	5e                   	pop    %esi
  801e2d:	5f                   	pop    %edi
  801e2e:	5d                   	pop    %ebp
  801e2f:	c3                   	ret    
  801e30:	3b 04 24             	cmp    (%esp),%eax
  801e33:	72 06                	jb     801e3b <__umoddi3+0x113>
  801e35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e39:	77 0f                	ja     801e4a <__umoddi3+0x122>
  801e3b:	89 f2                	mov    %esi,%edx
  801e3d:	29 f9                	sub    %edi,%ecx
  801e3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e43:	89 14 24             	mov    %edx,(%esp)
  801e46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e4e:	8b 14 24             	mov    (%esp),%edx
  801e51:	83 c4 1c             	add    $0x1c,%esp
  801e54:	5b                   	pop    %ebx
  801e55:	5e                   	pop    %esi
  801e56:	5f                   	pop    %edi
  801e57:	5d                   	pop    %ebp
  801e58:	c3                   	ret    
  801e59:	8d 76 00             	lea    0x0(%esi),%esi
  801e5c:	2b 04 24             	sub    (%esp),%eax
  801e5f:	19 fa                	sbb    %edi,%edx
  801e61:	89 d1                	mov    %edx,%ecx
  801e63:	89 c6                	mov    %eax,%esi
  801e65:	e9 71 ff ff ff       	jmp    801ddb <__umoddi3+0xb3>
  801e6a:	66 90                	xchg   %ax,%ax
  801e6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e70:	72 ea                	jb     801e5c <__umoddi3+0x134>
  801e72:	89 d9                	mov    %ebx,%ecx
  801e74:	e9 62 ff ff ff       	jmp    801ddb <__umoddi3+0xb3>
