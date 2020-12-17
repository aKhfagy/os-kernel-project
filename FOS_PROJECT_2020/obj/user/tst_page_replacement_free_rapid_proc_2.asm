
obj/user/tst_page_replacement_free_rapid_proc_2:     file format elf32-i386


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
  800031:	e8 31 05 00 00       	call   800567 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char* ptr = (char* )0x0801000 ;
char* ptr2 = (char* )0x0804000 ;
char* ptr3 = (char*) 0xeebfe000 - (PAGE_SIZE) -1;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec bc 00 00 00    	sub    $0xbc,%esp

//	cprintf("envID = %d\n",envID);
	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800044:	a1 20 30 80 00       	mov    0x803020,%eax
  800049:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80004f:	8b 00                	mov    (%eax),%eax
  800051:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800054:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800057:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005c:	3d 00 00 20 00       	cmp    $0x200000,%eax
  800061:	74 14                	je     800077 <_main+0x3f>
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	68 a0 1f 80 00       	push   $0x801fa0
  80006b:	6a 12                	push   $0x12
  80006d:	68 e4 1f 80 00       	push   $0x801fe4
  800072:	e8 35 06 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800077:	a1 20 30 80 00       	mov    0x803020,%eax
  80007c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800082:	83 c0 10             	add    $0x10,%eax
  800085:	8b 00                	mov    (%eax),%eax
  800087:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80008a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80008d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800092:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800097:	74 14                	je     8000ad <_main+0x75>
  800099:	83 ec 04             	sub    $0x4,%esp
  80009c:	68 a0 1f 80 00       	push   $0x801fa0
  8000a1:	6a 13                	push   $0x13
  8000a3:	68 e4 1f 80 00       	push   $0x801fe4
  8000a8:	e8 ff 05 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b2:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8000b8:	83 c0 20             	add    $0x20,%eax
  8000bb:	8b 00                	mov    (%eax),%eax
  8000bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8000c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c8:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000cd:	74 14                	je     8000e3 <_main+0xab>
  8000cf:	83 ec 04             	sub    $0x4,%esp
  8000d2:	68 a0 1f 80 00       	push   $0x801fa0
  8000d7:	6a 14                	push   $0x14
  8000d9:	68 e4 1f 80 00       	push   $0x801fe4
  8000de:	e8 c9 05 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e8:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8000ee:	83 c0 30             	add    $0x30,%eax
  8000f1:	8b 00                	mov    (%eax),%eax
  8000f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000fe:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800103:	74 14                	je     800119 <_main+0xe1>
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	68 a0 1f 80 00       	push   $0x801fa0
  80010d:	6a 15                	push   $0x15
  80010f:	68 e4 1f 80 00       	push   $0x801fe4
  800114:	e8 93 05 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800119:	a1 20 30 80 00       	mov    0x803020,%eax
  80011e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800124:	83 c0 40             	add    $0x40,%eax
  800127:	8b 00                	mov    (%eax),%eax
  800129:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80012c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80012f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800134:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 a0 1f 80 00       	push   $0x801fa0
  800143:	6a 16                	push   $0x16
  800145:	68 e4 1f 80 00       	push   $0x801fe4
  80014a:	e8 5d 05 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80014f:	a1 20 30 80 00       	mov    0x803020,%eax
  800154:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80015a:	83 c0 50             	add    $0x50,%eax
  80015d:	8b 00                	mov    (%eax),%eax
  80015f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800162:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800165:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80016a:	3d 00 50 20 00       	cmp    $0x205000,%eax
  80016f:	74 14                	je     800185 <_main+0x14d>
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	68 a0 1f 80 00       	push   $0x801fa0
  800179:	6a 17                	push   $0x17
  80017b:	68 e4 1f 80 00       	push   $0x801fe4
  800180:	e8 27 05 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800185:	a1 20 30 80 00       	mov    0x803020,%eax
  80018a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800190:	83 c0 60             	add    $0x60,%eax
  800193:	8b 00                	mov    (%eax),%eax
  800195:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800198:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80019b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a0:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a5:	74 14                	je     8001bb <_main+0x183>
  8001a7:	83 ec 04             	sub    $0x4,%esp
  8001aa:	68 a0 1f 80 00       	push   $0x801fa0
  8001af:	6a 18                	push   $0x18
  8001b1:	68 e4 1f 80 00       	push   $0x801fe4
  8001b6:	e8 f1 04 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c0:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8001c6:	83 c0 70             	add    $0x70,%eax
  8001c9:	8b 00                	mov    (%eax),%eax
  8001cb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8001ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d6:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001db:	74 14                	je     8001f1 <_main+0x1b9>
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	68 a0 1f 80 00       	push   $0x801fa0
  8001e5:	6a 19                	push   $0x19
  8001e7:	68 e4 1f 80 00       	push   $0x801fe4
  8001ec:	e8 bb 04 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f6:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8001fc:	83 e8 80             	sub    $0xffffff80,%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800204:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800207:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020c:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 a0 1f 80 00       	push   $0x801fa0
  80021b:	6a 1a                	push   $0x1a
  80021d:	68 e4 1f 80 00       	push   $0x801fe4
  800222:	e8 85 04 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800232:	05 90 00 00 00       	add    $0x90,%eax
  800237:	8b 00                	mov    (%eax),%eax
  800239:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80023c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80023f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800244:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800249:	74 14                	je     80025f <_main+0x227>
  80024b:	83 ec 04             	sub    $0x4,%esp
  80024e:	68 a0 1f 80 00       	push   $0x801fa0
  800253:	6a 1b                	push   $0x1b
  800255:	68 e4 1f 80 00       	push   $0x801fe4
  80025a:	e8 4d 04 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x804000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80026a:	05 a0 00 00 00       	add    $0xa0,%eax
  80026f:	8b 00                	mov    (%eax),%eax
  800271:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800274:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800277:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027c:	3d 00 40 80 00       	cmp    $0x804000,%eax
  800281:	74 14                	je     800297 <_main+0x25f>
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	68 a0 1f 80 00       	push   $0x801fa0
  80028b:	6a 1c                	push   $0x1c
  80028d:	68 e4 1f 80 00       	push   $0x801fe4
  800292:	e8 15 04 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0x805000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800297:	a1 20 30 80 00       	mov    0x803020,%eax
  80029c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8002a2:	05 b0 00 00 00       	add    $0xb0,%eax
  8002a7:	8b 00                	mov    (%eax),%eax
  8002a9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8002ac:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8002af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002b4:	3d 00 50 80 00       	cmp    $0x805000,%eax
  8002b9:	74 14                	je     8002cf <_main+0x297>
  8002bb:	83 ec 04             	sub    $0x4,%esp
  8002be:	68 a0 1f 80 00       	push   $0x801fa0
  8002c3:	6a 1d                	push   $0x1d
  8002c5:	68 e4 1f 80 00       	push   $0x801fe4
  8002ca:	e8 dd 03 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[12].virtual_address,PAGE_SIZE) !=   0x806000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8002cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d4:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8002da:	05 c0 00 00 00       	add    $0xc0,%eax
  8002df:	8b 00                	mov    (%eax),%eax
  8002e1:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8002e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002ec:	3d 00 60 80 00       	cmp    $0x806000,%eax
  8002f1:	74 14                	je     800307 <_main+0x2cf>
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 a0 1f 80 00       	push   $0x801fa0
  8002fb:	6a 1e                	push   $0x1e
  8002fd:	68 e4 1f 80 00       	push   $0x801fe4
  800302:	e8 a5 03 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[13].virtual_address,PAGE_SIZE) !=   0x807000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800307:	a1 20 30 80 00       	mov    0x803020,%eax
  80030c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800312:	05 d0 00 00 00       	add    $0xd0,%eax
  800317:	8b 00                	mov    (%eax),%eax
  800319:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80031c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80031f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800324:	3d 00 70 80 00       	cmp    $0x807000,%eax
  800329:	74 14                	je     80033f <_main+0x307>
  80032b:	83 ec 04             	sub    $0x4,%esp
  80032e:	68 a0 1f 80 00       	push   $0x801fa0
  800333:	6a 1f                	push   $0x1f
  800335:	68 e4 1f 80 00       	push   $0x801fe4
  80033a:	e8 6d 03 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[14].virtual_address,PAGE_SIZE) !=   0x808000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80033f:	a1 20 30 80 00       	mov    0x803020,%eax
  800344:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80034a:	05 e0 00 00 00       	add    $0xe0,%eax
  80034f:	8b 00                	mov    (%eax),%eax
  800351:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800354:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800357:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80035c:	3d 00 80 80 00       	cmp    $0x808000,%eax
  800361:	74 14                	je     800377 <_main+0x33f>
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 a0 1f 80 00       	push   $0x801fa0
  80036b:	6a 20                	push   $0x20
  80036d:	68 e4 1f 80 00       	push   $0x801fe4
  800372:	e8 35 03 00 00       	call   8006ac <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[15].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800377:	a1 20 30 80 00       	mov    0x803020,%eax
  80037c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800382:	05 f0 00 00 00       	add    $0xf0,%eax
  800387:	8b 00                	mov    (%eax),%eax
  800389:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  80038c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80038f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800394:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800399:	74 14                	je     8003af <_main+0x377>
  80039b:	83 ec 04             	sub    $0x4,%esp
  80039e:	68 a0 1f 80 00       	push   $0x801fa0
  8003a3:	6a 21                	push   $0x21
  8003a5:	68 e4 1f 80 00       	push   $0x801fe4
  8003aa:	e8 fd 02 00 00       	call   8006ac <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8003af:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b4:	8b 80 18 3c 01 00    	mov    0x13c18(%eax),%eax
  8003ba:	85 c0                	test   %eax,%eax
  8003bc:	74 14                	je     8003d2 <_main+0x39a>
  8003be:	83 ec 04             	sub    $0x4,%esp
  8003c1:	68 14 20 80 00       	push   $0x802014
  8003c6:	6a 22                	push   $0x22
  8003c8:	68 e4 1f 80 00       	push   $0x801fe4
  8003cd:	e8 da 02 00 00       	call   8006ac <_panic>
	}

	// Create & run the slave environments
	int IDs[4];
	IDs[0] = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  8003d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d7:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8003dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e2:	8b 40 74             	mov    0x74(%eax),%eax
  8003e5:	83 ec 04             	sub    $0x4,%esp
  8003e8:	52                   	push   %edx
  8003e9:	50                   	push   %eax
  8003ea:	68 5a 20 80 00       	push   $0x80205a
  8003ef:	e8 a5 16 00 00       	call   801a99 <sys_create_env>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 45 80             	mov    %eax,-0x80(%ebp)
	sys_run_env(IDs[0]);
  8003fa:	8b 45 80             	mov    -0x80(%ebp),%eax
  8003fd:	83 ec 0c             	sub    $0xc,%esp
  800400:	50                   	push   %eax
  800401:	e8 b0 16 00 00       	call   801ab6 <sys_run_env>
  800406:	83 c4 10             	add    $0x10,%esp
	for(int i = 1; i < 4; ++i)
  800409:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800410:	eb 44                	jmp    800456 <_main+0x41e>
	{
		IDs[i] = sys_create_env("dummy_process", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  800412:	a1 20 30 80 00       	mov    0x803020,%eax
  800417:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80041d:	a1 20 30 80 00       	mov    0x803020,%eax
  800422:	8b 40 74             	mov    0x74(%eax),%eax
  800425:	83 ec 04             	sub    $0x4,%esp
  800428:	52                   	push   %edx
  800429:	50                   	push   %eax
  80042a:	68 69 20 80 00       	push   $0x802069
  80042f:	e8 65 16 00 00       	call   801a99 <sys_create_env>
  800434:	83 c4 10             	add    $0x10,%esp
  800437:	89 c2                	mov    %eax,%edx
  800439:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80043c:	89 54 85 80          	mov    %edx,-0x80(%ebp,%eax,4)
		sys_run_env(IDs[i]);
  800440:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800443:	8b 44 85 80          	mov    -0x80(%ebp,%eax,4),%eax
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	50                   	push   %eax
  80044b:	e8 66 16 00 00       	call   801ab6 <sys_run_env>
  800450:	83 c4 10             	add    $0x10,%esp

	// Create & run the slave environments
	int IDs[4];
	IDs[0] = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(IDs[0]);
	for(int i = 1; i < 4; ++i)
  800453:	ff 45 e4             	incl   -0x1c(%ebp)
  800456:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  80045a:	7e b6                	jle    800412 <_main+0x3da>
	{
		IDs[i] = sys_create_env("dummy_process", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
		sys_run_env(IDs[i]);
	}
	// To check that the slave environments completed successfully
	rsttst();
  80045c:	e8 1f 17 00 00       	call   801b80 <rsttst>

	uint32 freePagesBefore = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800461:	e8 de 13 00 00       	call   801844 <sys_calculate_free_frames>
  800466:	89 c3                	mov    %eax,%ebx
  800468:	e8 f0 13 00 00       	call   80185d <sys_calculate_modified_frames>
  80046d:	01 d8                	add    %ebx,%eax
  80046f:	89 45 a0             	mov    %eax,-0x60(%ebp)
	uint32 usedDiskPagesBefore = sys_pf_calculate_allocated_pages();
  800472:	e8 50 14 00 00       	call   8018c7 <sys_pf_calculate_allocated_pages>
  800477:	89 45 9c             	mov    %eax,-0x64(%ebp)
	// Check the number of pages shall be deleted with the first fault after freeing the process
	int pagesToBeDeletedCount = sys_calculate_pages_tobe_removed_ready_exit(2);
  80047a:	83 ec 0c             	sub    $0xc,%esp
  80047d:	6a 02                	push   $0x2
  80047f:	e8 5c 14 00 00       	call   8018e0 <sys_calculate_pages_tobe_removed_ready_exit>
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	89 45 98             	mov    %eax,-0x68(%ebp)

	// FAULT with TWO STACK Pages to FREE the rapid running MASTER process
	char x = *ptr3;
  80048a:	a1 08 30 80 00       	mov    0x803008,%eax
  80048f:	8a 00                	mov    (%eax),%al
  800491:	88 45 97             	mov    %al,-0x69(%ebp)

	uint32 expectedPages[16] = {0xeebfc000,0x800000,0x801000,0x802000,0x803000,0xeebfd000,0,0,0,0,0,0,0,0,0,0};
  800494:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  80049a:	bb e0 21 80 00       	mov    $0x8021e0,%ebx
  80049f:	ba 10 00 00 00       	mov    $0x10,%edx
  8004a4:	89 c7                	mov    %eax,%edi
  8004a6:	89 de                	mov    %ebx,%esi
  8004a8:	89 d1                	mov    %edx,%ecx
  8004aa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	//cprintf("Checking PAGE LRU algorithm... \n");
	{
		CheckWSWithoutLastIndex(expectedPages, 16);
  8004ac:	83 ec 08             	sub    $0x8,%esp
  8004af:	6a 10                	push   $0x10
  8004b1:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8004b7:	50                   	push   %eax
  8004b8:	e8 61 02 00 00       	call   80071e <CheckWSWithoutLastIndex>
  8004bd:	83 c4 10             	add    $0x10,%esp

		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if(myEnv->page_last_WS_index != 2) panic("wrong PAGE WS pointer location");
	}

	x = *(ptr3-PAGE_SIZE);
  8004c0:	a1 08 30 80 00       	mov    0x803008,%eax
  8004c5:	8a 80 00 f0 ff ff    	mov    -0x1000(%eax),%al
  8004cb:	88 45 97             	mov    %al,-0x69(%ebp)

	//cprintf("Checking Allocation in Mem & Page File... \n");
	//AFTER freeing MEMORY
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPagesBefore) !=  2) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  8004ce:	e8 f4 13 00 00       	call   8018c7 <sys_pf_calculate_allocated_pages>
  8004d3:	2b 45 9c             	sub    -0x64(%ebp),%eax
  8004d6:	83 f8 02             	cmp    $0x2,%eax
  8004d9:	74 14                	je     8004ef <_main+0x4b7>
  8004db:	83 ec 04             	sub    $0x4,%esp
  8004de:	68 78 20 80 00       	push   $0x802078
  8004e3:	6a 59                	push   $0x59
  8004e5:	68 e4 1f 80 00       	push   $0x801fe4
  8004ea:	e8 bd 01 00 00       	call   8006ac <_panic>
		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  8004ef:	e8 50 13 00 00       	call   801844 <sys_calculate_free_frames>
  8004f4:	89 c3                	mov    %eax,%ebx
  8004f6:	e8 62 13 00 00       	call   80185d <sys_calculate_modified_frames>
  8004fb:	01 d8                	add    %ebx,%eax
  8004fd:	89 45 90             	mov    %eax,-0x70(%ebp)
		if( (freePagesBefore + pagesToBeDeletedCount - 3) != freePagesAfter )	// 3 => 2 STACK PAGES and 1 CODE page started from the fault of the stack page ALLOCATED
  800500:	8b 55 98             	mov    -0x68(%ebp),%edx
  800503:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800506:	01 d0                	add    %edx,%eax
  800508:	83 e8 03             	sub    $0x3,%eax
  80050b:	3b 45 90             	cmp    -0x70(%ebp),%eax
  80050e:	74 20                	je     800530 <_main+0x4f8>
			panic("Extra memory are wrongly allocated ... It's REplacement: extra/less frames have been FREED for the running RAPID process %d %d", freePagesBefore + pagesToBeDeletedCount, freePagesAfter);
  800510:	8b 55 98             	mov    -0x68(%ebp),%edx
  800513:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800516:	01 d0                	add    %edx,%eax
  800518:	83 ec 0c             	sub    $0xc,%esp
  80051b:	ff 75 90             	pushl  -0x70(%ebp)
  80051e:	50                   	push   %eax
  80051f:	68 e4 20 80 00       	push   $0x8020e4
  800524:	6a 5c                	push   $0x5c
  800526:	68 e4 1f 80 00       	push   $0x801fe4
  80052b:	e8 7c 01 00 00       	call   8006ac <_panic>
	}

	//cprintf("Checking PAGE LRU algorithm... \n");
	{
		expectedPages[6] =  0xeebfb000;
  800530:	c7 85 58 ff ff ff 00 	movl   $0xeebfb000,-0xa8(%ebp)
  800537:	b0 bf ee 
		CheckWSWithoutLastIndex(expectedPages, 16);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	6a 10                	push   $0x10
  80053f:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800545:	50                   	push   %eax
  800546:	e8 d3 01 00 00       	call   80071e <CheckWSWithoutLastIndex>
  80054b:	83 c4 10             	add    $0x10,%esp

		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if(myEnv->page_last_WS_index != 3) panic("wrong PAGE WS pointer location");
	}

	cprintf("Congratulations!! test PAGE replacement [FREEING RAPID PROCESS 2] using LRU is completed successfully.\n");
  80054e:	83 ec 0c             	sub    $0xc,%esp
  800551:	68 64 21 80 00       	push   $0x802164
  800556:	e8 f3 03 00 00       	call   80094e <cprintf>
  80055b:	83 c4 10             	add    $0x10,%esp
	return;
  80055e:	90                   	nop
}
  80055f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800562:	5b                   	pop    %ebx
  800563:	5e                   	pop    %esi
  800564:	5f                   	pop    %edi
  800565:	5d                   	pop    %ebp
  800566:	c3                   	ret    

00800567 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80056d:	e8 07 12 00 00       	call   801779 <sys_getenvindex>
  800572:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800575:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800578:	89 d0                	mov    %edx,%eax
  80057a:	c1 e0 03             	shl    $0x3,%eax
  80057d:	01 d0                	add    %edx,%eax
  80057f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800586:	01 c8                	add    %ecx,%eax
  800588:	01 c0                	add    %eax,%eax
  80058a:	01 d0                	add    %edx,%eax
  80058c:	01 c0                	add    %eax,%eax
  80058e:	01 d0                	add    %edx,%eax
  800590:	89 c2                	mov    %eax,%edx
  800592:	c1 e2 05             	shl    $0x5,%edx
  800595:	29 c2                	sub    %eax,%edx
  800597:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80059e:	89 c2                	mov    %eax,%edx
  8005a0:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8005a6:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b0:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8005b6:	84 c0                	test   %al,%al
  8005b8:	74 0f                	je     8005c9 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8005ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8005bf:	05 40 3c 01 00       	add    $0x13c40,%eax
  8005c4:	a3 0c 30 80 00       	mov    %eax,0x80300c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005cd:	7e 0a                	jle    8005d9 <libmain+0x72>
		binaryname = argv[0];
  8005cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	a3 0c 30 80 00       	mov    %eax,0x80300c

	// call user main routine
	_main(argc, argv);
  8005d9:	83 ec 08             	sub    $0x8,%esp
  8005dc:	ff 75 0c             	pushl  0xc(%ebp)
  8005df:	ff 75 08             	pushl  0x8(%ebp)
  8005e2:	e8 51 fa ff ff       	call   800038 <_main>
  8005e7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005ea:	e8 25 13 00 00       	call   801914 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005ef:	83 ec 0c             	sub    $0xc,%esp
  8005f2:	68 38 22 80 00       	push   $0x802238
  8005f7:	e8 52 03 00 00       	call   80094e <cprintf>
  8005fc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800604:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80060a:	a1 20 30 80 00       	mov    0x803020,%eax
  80060f:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800615:	83 ec 04             	sub    $0x4,%esp
  800618:	52                   	push   %edx
  800619:	50                   	push   %eax
  80061a:	68 60 22 80 00       	push   $0x802260
  80061f:	e8 2a 03 00 00       	call   80094e <cprintf>
  800624:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800627:	a1 20 30 80 00       	mov    0x803020,%eax
  80062c:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800632:	a1 20 30 80 00       	mov    0x803020,%eax
  800637:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80063d:	83 ec 04             	sub    $0x4,%esp
  800640:	52                   	push   %edx
  800641:	50                   	push   %eax
  800642:	68 88 22 80 00       	push   $0x802288
  800647:	e8 02 03 00 00       	call   80094e <cprintf>
  80064c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80064f:	a1 20 30 80 00       	mov    0x803020,%eax
  800654:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	50                   	push   %eax
  80065e:	68 c9 22 80 00       	push   $0x8022c9
  800663:	e8 e6 02 00 00       	call   80094e <cprintf>
  800668:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80066b:	83 ec 0c             	sub    $0xc,%esp
  80066e:	68 38 22 80 00       	push   $0x802238
  800673:	e8 d6 02 00 00       	call   80094e <cprintf>
  800678:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80067b:	e8 ae 12 00 00       	call   80192e <sys_enable_interrupt>

	// exit gracefully
	exit();
  800680:	e8 19 00 00 00       	call   80069e <exit>
}
  800685:	90                   	nop
  800686:	c9                   	leave  
  800687:	c3                   	ret    

00800688 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800688:	55                   	push   %ebp
  800689:	89 e5                	mov    %esp,%ebp
  80068b:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	6a 00                	push   $0x0
  800693:	e8 ad 10 00 00       	call   801745 <sys_env_destroy>
  800698:	83 c4 10             	add    $0x10,%esp
}
  80069b:	90                   	nop
  80069c:	c9                   	leave  
  80069d:	c3                   	ret    

0080069e <exit>:

void
exit(void)
{
  80069e:	55                   	push   %ebp
  80069f:	89 e5                	mov    %esp,%ebp
  8006a1:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8006a4:	e8 02 11 00 00       	call   8017ab <sys_env_exit>
}
  8006a9:	90                   	nop
  8006aa:	c9                   	leave  
  8006ab:	c3                   	ret    

008006ac <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006ac:	55                   	push   %ebp
  8006ad:	89 e5                	mov    %esp,%ebp
  8006af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8006b5:	83 c0 04             	add    $0x4,%eax
  8006b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006bb:	a1 18 c1 80 00       	mov    0x80c118,%eax
  8006c0:	85 c0                	test   %eax,%eax
  8006c2:	74 16                	je     8006da <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006c4:	a1 18 c1 80 00       	mov    0x80c118,%eax
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	50                   	push   %eax
  8006cd:	68 e0 22 80 00       	push   $0x8022e0
  8006d2:	e8 77 02 00 00       	call   80094e <cprintf>
  8006d7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006da:	a1 0c 30 80 00       	mov    0x80300c,%eax
  8006df:	ff 75 0c             	pushl  0xc(%ebp)
  8006e2:	ff 75 08             	pushl  0x8(%ebp)
  8006e5:	50                   	push   %eax
  8006e6:	68 e5 22 80 00       	push   $0x8022e5
  8006eb:	e8 5e 02 00 00       	call   80094e <cprintf>
  8006f0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006fc:	50                   	push   %eax
  8006fd:	e8 e1 01 00 00       	call   8008e3 <vcprintf>
  800702:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	6a 00                	push   $0x0
  80070a:	68 01 23 80 00       	push   $0x802301
  80070f:	e8 cf 01 00 00       	call   8008e3 <vcprintf>
  800714:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800717:	e8 82 ff ff ff       	call   80069e <exit>

	// should not return here
	while (1) ;
  80071c:	eb fe                	jmp    80071c <_panic+0x70>

0080071e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800724:	a1 20 30 80 00       	mov    0x803020,%eax
  800729:	8b 50 74             	mov    0x74(%eax),%edx
  80072c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072f:	39 c2                	cmp    %eax,%edx
  800731:	74 14                	je     800747 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800733:	83 ec 04             	sub    $0x4,%esp
  800736:	68 04 23 80 00       	push   $0x802304
  80073b:	6a 26                	push   $0x26
  80073d:	68 50 23 80 00       	push   $0x802350
  800742:	e8 65 ff ff ff       	call   8006ac <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800747:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80074e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800755:	e9 b6 00 00 00       	jmp    800810 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80075a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	01 d0                	add    %edx,%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	85 c0                	test   %eax,%eax
  80076d:	75 08                	jne    800777 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80076f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800772:	e9 96 00 00 00       	jmp    80080d <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800777:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80077e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800785:	eb 5d                	jmp    8007e4 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800787:	a1 20 30 80 00       	mov    0x803020,%eax
  80078c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800792:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800795:	c1 e2 04             	shl    $0x4,%edx
  800798:	01 d0                	add    %edx,%eax
  80079a:	8a 40 04             	mov    0x4(%eax),%al
  80079d:	84 c0                	test   %al,%al
  80079f:	75 40                	jne    8007e1 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8007a6:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8007ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007af:	c1 e2 04             	shl    $0x4,%edx
  8007b2:	01 d0                	add    %edx,%eax
  8007b4:	8b 00                	mov    (%eax),%eax
  8007b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007c1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	01 c8                	add    %ecx,%eax
  8007d2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007d4:	39 c2                	cmp    %eax,%edx
  8007d6:	75 09                	jne    8007e1 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8007d8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007df:	eb 12                	jmp    8007f3 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007e1:	ff 45 e8             	incl   -0x18(%ebp)
  8007e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8007e9:	8b 50 74             	mov    0x74(%eax),%edx
  8007ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007ef:	39 c2                	cmp    %eax,%edx
  8007f1:	77 94                	ja     800787 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8007f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8007f7:	75 14                	jne    80080d <CheckWSWithoutLastIndex+0xef>
			panic(
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 5c 23 80 00       	push   $0x80235c
  800801:	6a 3a                	push   $0x3a
  800803:	68 50 23 80 00       	push   $0x802350
  800808:	e8 9f fe ff ff       	call   8006ac <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80080d:	ff 45 f0             	incl   -0x10(%ebp)
  800810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800813:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800816:	0f 8c 3e ff ff ff    	jl     80075a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80081c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800823:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80082a:	eb 20                	jmp    80084c <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80082c:	a1 20 30 80 00       	mov    0x803020,%eax
  800831:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800837:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80083a:	c1 e2 04             	shl    $0x4,%edx
  80083d:	01 d0                	add    %edx,%eax
  80083f:	8a 40 04             	mov    0x4(%eax),%al
  800842:	3c 01                	cmp    $0x1,%al
  800844:	75 03                	jne    800849 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800846:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800849:	ff 45 e0             	incl   -0x20(%ebp)
  80084c:	a1 20 30 80 00       	mov    0x803020,%eax
  800851:	8b 50 74             	mov    0x74(%eax),%edx
  800854:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800857:	39 c2                	cmp    %eax,%edx
  800859:	77 d1                	ja     80082c <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80085e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800861:	74 14                	je     800877 <CheckWSWithoutLastIndex+0x159>
		panic(
  800863:	83 ec 04             	sub    $0x4,%esp
  800866:	68 b0 23 80 00       	push   $0x8023b0
  80086b:	6a 44                	push   $0x44
  80086d:	68 50 23 80 00       	push   $0x802350
  800872:	e8 35 fe ff ff       	call   8006ac <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800877:	90                   	nop
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800880:	8b 45 0c             	mov    0xc(%ebp),%eax
  800883:	8b 00                	mov    (%eax),%eax
  800885:	8d 48 01             	lea    0x1(%eax),%ecx
  800888:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088b:	89 0a                	mov    %ecx,(%edx)
  80088d:	8b 55 08             	mov    0x8(%ebp),%edx
  800890:	88 d1                	mov    %dl,%cl
  800892:	8b 55 0c             	mov    0xc(%ebp),%edx
  800895:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008a3:	75 2c                	jne    8008d1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008a5:	a0 24 30 80 00       	mov    0x803024,%al
  8008aa:	0f b6 c0             	movzbl %al,%eax
  8008ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b0:	8b 12                	mov    (%edx),%edx
  8008b2:	89 d1                	mov    %edx,%ecx
  8008b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b7:	83 c2 08             	add    $0x8,%edx
  8008ba:	83 ec 04             	sub    $0x4,%esp
  8008bd:	50                   	push   %eax
  8008be:	51                   	push   %ecx
  8008bf:	52                   	push   %edx
  8008c0:	e8 3e 0e 00 00       	call   801703 <sys_cputs>
  8008c5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d4:	8b 40 04             	mov    0x4(%eax),%eax
  8008d7:	8d 50 01             	lea    0x1(%eax),%edx
  8008da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008e0:	90                   	nop
  8008e1:	c9                   	leave  
  8008e2:	c3                   	ret    

008008e3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8008ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008f3:	00 00 00 
	b.cnt = 0;
  8008f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008fd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	ff 75 08             	pushl  0x8(%ebp)
  800906:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80090c:	50                   	push   %eax
  80090d:	68 7a 08 80 00       	push   $0x80087a
  800912:	e8 11 02 00 00       	call   800b28 <vprintfmt>
  800917:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80091a:	a0 24 30 80 00       	mov    0x803024,%al
  80091f:	0f b6 c0             	movzbl %al,%eax
  800922:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800928:	83 ec 04             	sub    $0x4,%esp
  80092b:	50                   	push   %eax
  80092c:	52                   	push   %edx
  80092d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800933:	83 c0 08             	add    $0x8,%eax
  800936:	50                   	push   %eax
  800937:	e8 c7 0d 00 00       	call   801703 <sys_cputs>
  80093c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80093f:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800946:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80094c:	c9                   	leave  
  80094d:	c3                   	ret    

0080094e <cprintf>:

int cprintf(const char *fmt, ...) {
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800954:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80095b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80095e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	ff 75 f4             	pushl  -0xc(%ebp)
  80096a:	50                   	push   %eax
  80096b:	e8 73 ff ff ff       	call   8008e3 <vcprintf>
  800970:	83 c4 10             	add    $0x10,%esp
  800973:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800976:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800981:	e8 8e 0f 00 00       	call   801914 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800986:	8d 45 0c             	lea    0xc(%ebp),%eax
  800989:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	ff 75 f4             	pushl  -0xc(%ebp)
  800995:	50                   	push   %eax
  800996:	e8 48 ff ff ff       	call   8008e3 <vcprintf>
  80099b:	83 c4 10             	add    $0x10,%esp
  80099e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009a1:	e8 88 0f 00 00       	call   80192e <sys_enable_interrupt>
	return cnt;
  8009a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009a9:	c9                   	leave  
  8009aa:	c3                   	ret    

008009ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	53                   	push   %ebx
  8009af:	83 ec 14             	sub    $0x14,%esp
  8009b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009be:	8b 45 18             	mov    0x18(%ebp),%eax
  8009c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009c9:	77 55                	ja     800a20 <printnum+0x75>
  8009cb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009ce:	72 05                	jb     8009d5 <printnum+0x2a>
  8009d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009d3:	77 4b                	ja     800a20 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009d5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009d8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009db:	8b 45 18             	mov    0x18(%ebp),%eax
  8009de:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e3:	52                   	push   %edx
  8009e4:	50                   	push   %eax
  8009e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8009eb:	e8 44 13 00 00       	call   801d34 <__udivdi3>
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	83 ec 04             	sub    $0x4,%esp
  8009f6:	ff 75 20             	pushl  0x20(%ebp)
  8009f9:	53                   	push   %ebx
  8009fa:	ff 75 18             	pushl  0x18(%ebp)
  8009fd:	52                   	push   %edx
  8009fe:	50                   	push   %eax
  8009ff:	ff 75 0c             	pushl  0xc(%ebp)
  800a02:	ff 75 08             	pushl  0x8(%ebp)
  800a05:	e8 a1 ff ff ff       	call   8009ab <printnum>
  800a0a:	83 c4 20             	add    $0x20,%esp
  800a0d:	eb 1a                	jmp    800a29 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	ff 75 20             	pushl  0x20(%ebp)
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	ff d0                	call   *%eax
  800a1d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a20:	ff 4d 1c             	decl   0x1c(%ebp)
  800a23:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a27:	7f e6                	jg     800a0f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a29:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a2c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a37:	53                   	push   %ebx
  800a38:	51                   	push   %ecx
  800a39:	52                   	push   %edx
  800a3a:	50                   	push   %eax
  800a3b:	e8 04 14 00 00       	call   801e44 <__umoddi3>
  800a40:	83 c4 10             	add    $0x10,%esp
  800a43:	05 14 26 80 00       	add    $0x802614,%eax
  800a48:	8a 00                	mov    (%eax),%al
  800a4a:	0f be c0             	movsbl %al,%eax
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	50                   	push   %eax
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	ff d0                	call   *%eax
  800a59:	83 c4 10             	add    $0x10,%esp
}
  800a5c:	90                   	nop
  800a5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    

00800a62 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a65:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a69:	7e 1c                	jle    800a87 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	8b 00                	mov    (%eax),%eax
  800a70:	8d 50 08             	lea    0x8(%eax),%edx
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	89 10                	mov    %edx,(%eax)
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8b 00                	mov    (%eax),%eax
  800a7d:	83 e8 08             	sub    $0x8,%eax
  800a80:	8b 50 04             	mov    0x4(%eax),%edx
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	eb 40                	jmp    800ac7 <getuint+0x65>
	else if (lflag)
  800a87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8b:	74 1e                	je     800aab <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	8b 00                	mov    (%eax),%eax
  800a92:	8d 50 04             	lea    0x4(%eax),%edx
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	89 10                	mov    %edx,(%eax)
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	83 e8 04             	sub    $0x4,%eax
  800aa2:	8b 00                	mov    (%eax),%eax
  800aa4:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa9:	eb 1c                	jmp    800ac7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8b 00                	mov    (%eax),%eax
  800ab0:	8d 50 04             	lea    0x4(%eax),%edx
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	89 10                	mov    %edx,(%eax)
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	8b 00                	mov    (%eax),%eax
  800abd:	83 e8 04             	sub    $0x4,%eax
  800ac0:	8b 00                	mov    (%eax),%eax
  800ac2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    

00800ac9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800acc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ad0:	7e 1c                	jle    800aee <getint+0x25>
		return va_arg(*ap, long long);
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	8b 00                	mov    (%eax),%eax
  800ad7:	8d 50 08             	lea    0x8(%eax),%edx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	89 10                	mov    %edx,(%eax)
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	8b 00                	mov    (%eax),%eax
  800ae4:	83 e8 08             	sub    $0x8,%eax
  800ae7:	8b 50 04             	mov    0x4(%eax),%edx
  800aea:	8b 00                	mov    (%eax),%eax
  800aec:	eb 38                	jmp    800b26 <getint+0x5d>
	else if (lflag)
  800aee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af2:	74 1a                	je     800b0e <getint+0x45>
		return va_arg(*ap, long);
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	8b 00                	mov    (%eax),%eax
  800af9:	8d 50 04             	lea    0x4(%eax),%edx
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	89 10                	mov    %edx,(%eax)
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	8b 00                	mov    (%eax),%eax
  800b06:	83 e8 04             	sub    $0x4,%eax
  800b09:	8b 00                	mov    (%eax),%eax
  800b0b:	99                   	cltd   
  800b0c:	eb 18                	jmp    800b26 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	8b 00                	mov    (%eax),%eax
  800b13:	8d 50 04             	lea    0x4(%eax),%edx
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	89 10                	mov    %edx,(%eax)
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8b 00                	mov    (%eax),%eax
  800b20:	83 e8 04             	sub    $0x4,%eax
  800b23:	8b 00                	mov    (%eax),%eax
  800b25:	99                   	cltd   
}
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
  800b2d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b30:	eb 17                	jmp    800b49 <vprintfmt+0x21>
			if (ch == '\0')
  800b32:	85 db                	test   %ebx,%ebx
  800b34:	0f 84 af 03 00 00    	je     800ee9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b3a:	83 ec 08             	sub    $0x8,%esp
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	53                   	push   %ebx
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	ff d0                	call   *%eax
  800b46:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b49:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4c:	8d 50 01             	lea    0x1(%eax),%edx
  800b4f:	89 55 10             	mov    %edx,0x10(%ebp)
  800b52:	8a 00                	mov    (%eax),%al
  800b54:	0f b6 d8             	movzbl %al,%ebx
  800b57:	83 fb 25             	cmp    $0x25,%ebx
  800b5a:	75 d6                	jne    800b32 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b5c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b60:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b67:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b6e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b75:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7f:	8d 50 01             	lea    0x1(%eax),%edx
  800b82:	89 55 10             	mov    %edx,0x10(%ebp)
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	0f b6 d8             	movzbl %al,%ebx
  800b8a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b8d:	83 f8 55             	cmp    $0x55,%eax
  800b90:	0f 87 2b 03 00 00    	ja     800ec1 <vprintfmt+0x399>
  800b96:	8b 04 85 38 26 80 00 	mov    0x802638(,%eax,4),%eax
  800b9d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b9f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ba3:	eb d7                	jmp    800b7c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ba5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ba9:	eb d1                	jmp    800b7c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bb2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bb5:	89 d0                	mov    %edx,%eax
  800bb7:	c1 e0 02             	shl    $0x2,%eax
  800bba:	01 d0                	add    %edx,%eax
  800bbc:	01 c0                	add    %eax,%eax
  800bbe:	01 d8                	add    %ebx,%eax
  800bc0:	83 e8 30             	sub    $0x30,%eax
  800bc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc9:	8a 00                	mov    (%eax),%al
  800bcb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bce:	83 fb 2f             	cmp    $0x2f,%ebx
  800bd1:	7e 3e                	jle    800c11 <vprintfmt+0xe9>
  800bd3:	83 fb 39             	cmp    $0x39,%ebx
  800bd6:	7f 39                	jg     800c11 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bd8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bdb:	eb d5                	jmp    800bb2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800be0:	83 c0 04             	add    $0x4,%eax
  800be3:	89 45 14             	mov    %eax,0x14(%ebp)
  800be6:	8b 45 14             	mov    0x14(%ebp),%eax
  800be9:	83 e8 04             	sub    $0x4,%eax
  800bec:	8b 00                	mov    (%eax),%eax
  800bee:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800bf1:	eb 1f                	jmp    800c12 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800bf3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf7:	79 83                	jns    800b7c <vprintfmt+0x54>
				width = 0;
  800bf9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c00:	e9 77 ff ff ff       	jmp    800b7c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c05:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c0c:	e9 6b ff ff ff       	jmp    800b7c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c11:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c16:	0f 89 60 ff ff ff    	jns    800b7c <vprintfmt+0x54>
				width = precision, precision = -1;
  800c1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c22:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c29:	e9 4e ff ff ff       	jmp    800b7c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c2e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c31:	e9 46 ff ff ff       	jmp    800b7c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c36:	8b 45 14             	mov    0x14(%ebp),%eax
  800c39:	83 c0 04             	add    $0x4,%eax
  800c3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c42:	83 e8 04             	sub    $0x4,%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	83 ec 08             	sub    $0x8,%esp
  800c4a:	ff 75 0c             	pushl  0xc(%ebp)
  800c4d:	50                   	push   %eax
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	ff d0                	call   *%eax
  800c53:	83 c4 10             	add    $0x10,%esp
			break;
  800c56:	e9 89 02 00 00       	jmp    800ee4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5e:	83 c0 04             	add    $0x4,%eax
  800c61:	89 45 14             	mov    %eax,0x14(%ebp)
  800c64:	8b 45 14             	mov    0x14(%ebp),%eax
  800c67:	83 e8 04             	sub    $0x4,%eax
  800c6a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c6c:	85 db                	test   %ebx,%ebx
  800c6e:	79 02                	jns    800c72 <vprintfmt+0x14a>
				err = -err;
  800c70:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c72:	83 fb 64             	cmp    $0x64,%ebx
  800c75:	7f 0b                	jg     800c82 <vprintfmt+0x15a>
  800c77:	8b 34 9d 80 24 80 00 	mov    0x802480(,%ebx,4),%esi
  800c7e:	85 f6                	test   %esi,%esi
  800c80:	75 19                	jne    800c9b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c82:	53                   	push   %ebx
  800c83:	68 25 26 80 00       	push   $0x802625
  800c88:	ff 75 0c             	pushl  0xc(%ebp)
  800c8b:	ff 75 08             	pushl  0x8(%ebp)
  800c8e:	e8 5e 02 00 00       	call   800ef1 <printfmt>
  800c93:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c96:	e9 49 02 00 00       	jmp    800ee4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c9b:	56                   	push   %esi
  800c9c:	68 2e 26 80 00       	push   $0x80262e
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	ff 75 08             	pushl  0x8(%ebp)
  800ca7:	e8 45 02 00 00       	call   800ef1 <printfmt>
  800cac:	83 c4 10             	add    $0x10,%esp
			break;
  800caf:	e9 30 02 00 00       	jmp    800ee4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb7:	83 c0 04             	add    $0x4,%eax
  800cba:	89 45 14             	mov    %eax,0x14(%ebp)
  800cbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc0:	83 e8 04             	sub    $0x4,%eax
  800cc3:	8b 30                	mov    (%eax),%esi
  800cc5:	85 f6                	test   %esi,%esi
  800cc7:	75 05                	jne    800cce <vprintfmt+0x1a6>
				p = "(null)";
  800cc9:	be 31 26 80 00       	mov    $0x802631,%esi
			if (width > 0 && padc != '-')
  800cce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd2:	7e 6d                	jle    800d41 <vprintfmt+0x219>
  800cd4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cd8:	74 67                	je     800d41 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cdd:	83 ec 08             	sub    $0x8,%esp
  800ce0:	50                   	push   %eax
  800ce1:	56                   	push   %esi
  800ce2:	e8 0c 03 00 00       	call   800ff3 <strnlen>
  800ce7:	83 c4 10             	add    $0x10,%esp
  800cea:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ced:	eb 16                	jmp    800d05 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800cef:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800cf3:	83 ec 08             	sub    $0x8,%esp
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	50                   	push   %eax
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	ff d0                	call   *%eax
  800cff:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d02:	ff 4d e4             	decl   -0x1c(%ebp)
  800d05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d09:	7f e4                	jg     800cef <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d0b:	eb 34                	jmp    800d41 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d0d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d11:	74 1c                	je     800d2f <vprintfmt+0x207>
  800d13:	83 fb 1f             	cmp    $0x1f,%ebx
  800d16:	7e 05                	jle    800d1d <vprintfmt+0x1f5>
  800d18:	83 fb 7e             	cmp    $0x7e,%ebx
  800d1b:	7e 12                	jle    800d2f <vprintfmt+0x207>
					putch('?', putdat);
  800d1d:	83 ec 08             	sub    $0x8,%esp
  800d20:	ff 75 0c             	pushl  0xc(%ebp)
  800d23:	6a 3f                	push   $0x3f
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	ff d0                	call   *%eax
  800d2a:	83 c4 10             	add    $0x10,%esp
  800d2d:	eb 0f                	jmp    800d3e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d2f:	83 ec 08             	sub    $0x8,%esp
  800d32:	ff 75 0c             	pushl  0xc(%ebp)
  800d35:	53                   	push   %ebx
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	ff d0                	call   *%eax
  800d3b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800d41:	89 f0                	mov    %esi,%eax
  800d43:	8d 70 01             	lea    0x1(%eax),%esi
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	0f be d8             	movsbl %al,%ebx
  800d4b:	85 db                	test   %ebx,%ebx
  800d4d:	74 24                	je     800d73 <vprintfmt+0x24b>
  800d4f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d53:	78 b8                	js     800d0d <vprintfmt+0x1e5>
  800d55:	ff 4d e0             	decl   -0x20(%ebp)
  800d58:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d5c:	79 af                	jns    800d0d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d5e:	eb 13                	jmp    800d73 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d60:	83 ec 08             	sub    $0x8,%esp
  800d63:	ff 75 0c             	pushl  0xc(%ebp)
  800d66:	6a 20                	push   $0x20
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	ff d0                	call   *%eax
  800d6d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d70:	ff 4d e4             	decl   -0x1c(%ebp)
  800d73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d77:	7f e7                	jg     800d60 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d79:	e9 66 01 00 00       	jmp    800ee4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d7e:	83 ec 08             	sub    $0x8,%esp
  800d81:	ff 75 e8             	pushl  -0x18(%ebp)
  800d84:	8d 45 14             	lea    0x14(%ebp),%eax
  800d87:	50                   	push   %eax
  800d88:	e8 3c fd ff ff       	call   800ac9 <getint>
  800d8d:	83 c4 10             	add    $0x10,%esp
  800d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d93:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d9c:	85 d2                	test   %edx,%edx
  800d9e:	79 23                	jns    800dc3 <vprintfmt+0x29b>
				putch('-', putdat);
  800da0:	83 ec 08             	sub    $0x8,%esp
  800da3:	ff 75 0c             	pushl  0xc(%ebp)
  800da6:	6a 2d                	push   $0x2d
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	ff d0                	call   *%eax
  800dad:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db6:	f7 d8                	neg    %eax
  800db8:	83 d2 00             	adc    $0x0,%edx
  800dbb:	f7 da                	neg    %edx
  800dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800dc3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dca:	e9 bc 00 00 00       	jmp    800e8b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dcf:	83 ec 08             	sub    $0x8,%esp
  800dd2:	ff 75 e8             	pushl  -0x18(%ebp)
  800dd5:	8d 45 14             	lea    0x14(%ebp),%eax
  800dd8:	50                   	push   %eax
  800dd9:	e8 84 fc ff ff       	call   800a62 <getuint>
  800dde:	83 c4 10             	add    $0x10,%esp
  800de1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800de7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dee:	e9 98 00 00 00       	jmp    800e8b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800df3:	83 ec 08             	sub    $0x8,%esp
  800df6:	ff 75 0c             	pushl  0xc(%ebp)
  800df9:	6a 58                	push   $0x58
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	ff d0                	call   *%eax
  800e00:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e03:	83 ec 08             	sub    $0x8,%esp
  800e06:	ff 75 0c             	pushl  0xc(%ebp)
  800e09:	6a 58                	push   $0x58
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	ff d0                	call   *%eax
  800e10:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e13:	83 ec 08             	sub    $0x8,%esp
  800e16:	ff 75 0c             	pushl  0xc(%ebp)
  800e19:	6a 58                	push   $0x58
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	ff d0                	call   *%eax
  800e20:	83 c4 10             	add    $0x10,%esp
			break;
  800e23:	e9 bc 00 00 00       	jmp    800ee4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e28:	83 ec 08             	sub    $0x8,%esp
  800e2b:	ff 75 0c             	pushl  0xc(%ebp)
  800e2e:	6a 30                	push   $0x30
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	ff d0                	call   *%eax
  800e35:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	6a 78                	push   $0x78
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	ff d0                	call   *%eax
  800e45:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e48:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4b:	83 c0 04             	add    $0x4,%eax
  800e4e:	89 45 14             	mov    %eax,0x14(%ebp)
  800e51:	8b 45 14             	mov    0x14(%ebp),%eax
  800e54:	83 e8 04             	sub    $0x4,%eax
  800e57:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e63:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e6a:	eb 1f                	jmp    800e8b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e6c:	83 ec 08             	sub    $0x8,%esp
  800e6f:	ff 75 e8             	pushl  -0x18(%ebp)
  800e72:	8d 45 14             	lea    0x14(%ebp),%eax
  800e75:	50                   	push   %eax
  800e76:	e8 e7 fb ff ff       	call   800a62 <getuint>
  800e7b:	83 c4 10             	add    $0x10,%esp
  800e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e81:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e8b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e92:	83 ec 04             	sub    $0x4,%esp
  800e95:	52                   	push   %edx
  800e96:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e99:	50                   	push   %eax
  800e9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e9d:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea0:	ff 75 0c             	pushl  0xc(%ebp)
  800ea3:	ff 75 08             	pushl  0x8(%ebp)
  800ea6:	e8 00 fb ff ff       	call   8009ab <printnum>
  800eab:	83 c4 20             	add    $0x20,%esp
			break;
  800eae:	eb 34                	jmp    800ee4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800eb0:	83 ec 08             	sub    $0x8,%esp
  800eb3:	ff 75 0c             	pushl  0xc(%ebp)
  800eb6:	53                   	push   %ebx
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	ff d0                	call   *%eax
  800ebc:	83 c4 10             	add    $0x10,%esp
			break;
  800ebf:	eb 23                	jmp    800ee4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ec1:	83 ec 08             	sub    $0x8,%esp
  800ec4:	ff 75 0c             	pushl  0xc(%ebp)
  800ec7:	6a 25                	push   $0x25
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	ff d0                	call   *%eax
  800ece:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ed1:	ff 4d 10             	decl   0x10(%ebp)
  800ed4:	eb 03                	jmp    800ed9 <vprintfmt+0x3b1>
  800ed6:	ff 4d 10             	decl   0x10(%ebp)
  800ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  800edc:	48                   	dec    %eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	3c 25                	cmp    $0x25,%al
  800ee1:	75 f3                	jne    800ed6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ee3:	90                   	nop
		}
	}
  800ee4:	e9 47 fc ff ff       	jmp    800b30 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ee9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800eea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    

00800ef1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ef7:	8d 45 10             	lea    0x10(%ebp),%eax
  800efa:	83 c0 04             	add    $0x4,%eax
  800efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	ff 75 f4             	pushl  -0xc(%ebp)
  800f06:	50                   	push   %eax
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	ff 75 08             	pushl  0x8(%ebp)
  800f0d:	e8 16 fc ff ff       	call   800b28 <vprintfmt>
  800f12:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f15:	90                   	nop
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1e:	8b 40 08             	mov    0x8(%eax),%eax
  800f21:	8d 50 01             	lea    0x1(%eax),%edx
  800f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f27:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2d:	8b 10                	mov    (%eax),%edx
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	8b 40 04             	mov    0x4(%eax),%eax
  800f35:	39 c2                	cmp    %eax,%edx
  800f37:	73 12                	jae    800f4b <sprintputch+0x33>
		*b->buf++ = ch;
  800f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3c:	8b 00                	mov    (%eax),%eax
  800f3e:	8d 48 01             	lea    0x1(%eax),%ecx
  800f41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f44:	89 0a                	mov    %ecx,(%edx)
  800f46:	8b 55 08             	mov    0x8(%ebp),%edx
  800f49:	88 10                	mov    %dl,(%eax)
}
  800f4b:	90                   	nop
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    

00800f4e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	01 d0                	add    %edx,%eax
  800f65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f73:	74 06                	je     800f7b <vsnprintf+0x2d>
  800f75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f79:	7f 07                	jg     800f82 <vsnprintf+0x34>
		return -E_INVAL;
  800f7b:	b8 03 00 00 00       	mov    $0x3,%eax
  800f80:	eb 20                	jmp    800fa2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f82:	ff 75 14             	pushl  0x14(%ebp)
  800f85:	ff 75 10             	pushl  0x10(%ebp)
  800f88:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f8b:	50                   	push   %eax
  800f8c:	68 18 0f 80 00       	push   $0x800f18
  800f91:	e8 92 fb ff ff       	call   800b28 <vprintfmt>
  800f96:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f9c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800faa:	8d 45 10             	lea    0x10(%ebp),%eax
  800fad:	83 c0 04             	add    $0x4,%eax
  800fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb9:	50                   	push   %eax
  800fba:	ff 75 0c             	pushl  0xc(%ebp)
  800fbd:	ff 75 08             	pushl  0x8(%ebp)
  800fc0:	e8 89 ff ff ff       	call   800f4e <vsnprintf>
  800fc5:	83 c4 10             	add    $0x10,%esp
  800fc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fce:	c9                   	leave  
  800fcf:	c3                   	ret    

00800fd0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fdd:	eb 06                	jmp    800fe5 <strlen+0x15>
		n++;
  800fdf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe2:	ff 45 08             	incl   0x8(%ebp)
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	84 c0                	test   %al,%al
  800fec:	75 f1                	jne    800fdf <strlen+0xf>
		n++;
	return n;
  800fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ff1:	c9                   	leave  
  800ff2:	c3                   	ret    

00800ff3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ff9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801000:	eb 09                	jmp    80100b <strnlen+0x18>
		n++;
  801002:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801005:	ff 45 08             	incl   0x8(%ebp)
  801008:	ff 4d 0c             	decl   0xc(%ebp)
  80100b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80100f:	74 09                	je     80101a <strnlen+0x27>
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	84 c0                	test   %al,%al
  801018:	75 e8                	jne    801002 <strnlen+0xf>
		n++;
	return n;
  80101a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80101d:	c9                   	leave  
  80101e:	c3                   	ret    

0080101f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80102b:	90                   	nop
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8d 50 01             	lea    0x1(%eax),%edx
  801032:	89 55 08             	mov    %edx,0x8(%ebp)
  801035:	8b 55 0c             	mov    0xc(%ebp),%edx
  801038:	8d 4a 01             	lea    0x1(%edx),%ecx
  80103b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80103e:	8a 12                	mov    (%edx),%dl
  801040:	88 10                	mov    %dl,(%eax)
  801042:	8a 00                	mov    (%eax),%al
  801044:	84 c0                	test   %al,%al
  801046:	75 e4                	jne    80102c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801048:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801060:	eb 1f                	jmp    801081 <strncpy+0x34>
		*dst++ = *src;
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8d 50 01             	lea    0x1(%eax),%edx
  801068:	89 55 08             	mov    %edx,0x8(%ebp)
  80106b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106e:	8a 12                	mov    (%edx),%dl
  801070:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801072:	8b 45 0c             	mov    0xc(%ebp),%eax
  801075:	8a 00                	mov    (%eax),%al
  801077:	84 c0                	test   %al,%al
  801079:	74 03                	je     80107e <strncpy+0x31>
			src++;
  80107b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80107e:	ff 45 fc             	incl   -0x4(%ebp)
  801081:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801084:	3b 45 10             	cmp    0x10(%ebp),%eax
  801087:	72 d9                	jb     801062 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80109a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109e:	74 30                	je     8010d0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010a0:	eb 16                	jmp    8010b8 <strlcpy+0x2a>
			*dst++ = *src++;
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	8d 50 01             	lea    0x1(%eax),%edx
  8010a8:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010b4:	8a 12                	mov    (%edx),%dl
  8010b6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010b8:	ff 4d 10             	decl   0x10(%ebp)
  8010bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bf:	74 09                	je     8010ca <strlcpy+0x3c>
  8010c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	84 c0                	test   %al,%al
  8010c8:	75 d8                	jne    8010a2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d6:	29 c2                	sub    %eax,%edx
  8010d8:	89 d0                	mov    %edx,%eax
}
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    

008010dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010df:	eb 06                	jmp    8010e7 <strcmp+0xb>
		p++, q++;
  8010e1:	ff 45 08             	incl   0x8(%ebp)
  8010e4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	84 c0                	test   %al,%al
  8010ee:	74 0e                	je     8010fe <strcmp+0x22>
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8a 10                	mov    (%eax),%dl
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	38 c2                	cmp    %al,%dl
  8010fc:	74 e3                	je     8010e1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	0f b6 d0             	movzbl %al,%edx
  801106:	8b 45 0c             	mov    0xc(%ebp),%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	0f b6 c0             	movzbl %al,%eax
  80110e:	29 c2                	sub    %eax,%edx
  801110:	89 d0                	mov    %edx,%eax
}
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801117:	eb 09                	jmp    801122 <strncmp+0xe>
		n--, p++, q++;
  801119:	ff 4d 10             	decl   0x10(%ebp)
  80111c:	ff 45 08             	incl   0x8(%ebp)
  80111f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801122:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801126:	74 17                	je     80113f <strncmp+0x2b>
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	84 c0                	test   %al,%al
  80112f:	74 0e                	je     80113f <strncmp+0x2b>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 10                	mov    (%eax),%dl
  801136:	8b 45 0c             	mov    0xc(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	38 c2                	cmp    %al,%dl
  80113d:	74 da                	je     801119 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80113f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801143:	75 07                	jne    80114c <strncmp+0x38>
		return 0;
  801145:	b8 00 00 00 00       	mov    $0x0,%eax
  80114a:	eb 14                	jmp    801160 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	0f b6 d0             	movzbl %al,%edx
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	0f b6 c0             	movzbl %al,%eax
  80115c:	29 c2                	sub    %eax,%edx
  80115e:	89 d0                	mov    %edx,%eax
}
  801160:	5d                   	pop    %ebp
  801161:	c3                   	ret    

00801162 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	83 ec 04             	sub    $0x4,%esp
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80116e:	eb 12                	jmp    801182 <strchr+0x20>
		if (*s == c)
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801178:	75 05                	jne    80117f <strchr+0x1d>
			return (char *) s;
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	eb 11                	jmp    801190 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80117f:	ff 45 08             	incl   0x8(%ebp)
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	84 c0                	test   %al,%al
  801189:	75 e5                	jne    801170 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80118b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	83 ec 04             	sub    $0x4,%esp
  801198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80119e:	eb 0d                	jmp    8011ad <strfind+0x1b>
		if (*s == c)
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011a8:	74 0e                	je     8011b8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011aa:	ff 45 08             	incl   0x8(%ebp)
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	84 c0                	test   %al,%al
  8011b4:	75 ea                	jne    8011a0 <strfind+0xe>
  8011b6:	eb 01                	jmp    8011b9 <strfind+0x27>
		if (*s == c)
			break;
  8011b8:	90                   	nop
	return (char *) s;
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011bc:	c9                   	leave  
  8011bd:	c3                   	ret    

008011be <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011d0:	eb 0e                	jmp    8011e0 <memset+0x22>
		*p++ = c;
  8011d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d5:	8d 50 01             	lea    0x1(%eax),%edx
  8011d8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011de:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011e0:	ff 4d f8             	decl   -0x8(%ebp)
  8011e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8011e7:	79 e9                	jns    8011d2 <memset+0x14>
		*p++ = c;

	return v;
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801200:	eb 16                	jmp    801218 <memcpy+0x2a>
		*d++ = *s++;
  801202:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801205:	8d 50 01             	lea    0x1(%eax),%edx
  801208:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80120b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80120e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801211:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801214:	8a 12                	mov    (%edx),%dl
  801216:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801218:	8b 45 10             	mov    0x10(%ebp),%eax
  80121b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80121e:	89 55 10             	mov    %edx,0x10(%ebp)
  801221:	85 c0                	test   %eax,%eax
  801223:	75 dd                	jne    801202 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801230:	8b 45 0c             	mov    0xc(%ebp),%eax
  801233:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80123c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801242:	73 50                	jae    801294 <memmove+0x6a>
  801244:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801247:	8b 45 10             	mov    0x10(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80124f:	76 43                	jbe    801294 <memmove+0x6a>
		s += n;
  801251:	8b 45 10             	mov    0x10(%ebp),%eax
  801254:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801257:	8b 45 10             	mov    0x10(%ebp),%eax
  80125a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80125d:	eb 10                	jmp    80126f <memmove+0x45>
			*--d = *--s;
  80125f:	ff 4d f8             	decl   -0x8(%ebp)
  801262:	ff 4d fc             	decl   -0x4(%ebp)
  801265:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801268:	8a 10                	mov    (%eax),%dl
  80126a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80126f:	8b 45 10             	mov    0x10(%ebp),%eax
  801272:	8d 50 ff             	lea    -0x1(%eax),%edx
  801275:	89 55 10             	mov    %edx,0x10(%ebp)
  801278:	85 c0                	test   %eax,%eax
  80127a:	75 e3                	jne    80125f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80127c:	eb 23                	jmp    8012a1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80127e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801281:	8d 50 01             	lea    0x1(%eax),%edx
  801284:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801287:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80128d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801290:	8a 12                	mov    (%edx),%dl
  801292:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	8d 50 ff             	lea    -0x1(%eax),%edx
  80129a:	89 55 10             	mov    %edx,0x10(%ebp)
  80129d:	85 c0                	test   %eax,%eax
  80129f:	75 dd                	jne    80127e <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012b8:	eb 2a                	jmp    8012e4 <memcmp+0x3e>
		if (*s1 != *s2)
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012bd:	8a 10                	mov    (%eax),%dl
  8012bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	38 c2                	cmp    %al,%dl
  8012c6:	74 16                	je     8012de <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	0f b6 d0             	movzbl %al,%edx
  8012d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	0f b6 c0             	movzbl %al,%eax
  8012d8:	29 c2                	sub    %eax,%edx
  8012da:	89 d0                	mov    %edx,%eax
  8012dc:	eb 18                	jmp    8012f6 <memcmp+0x50>
		s1++, s2++;
  8012de:	ff 45 fc             	incl   -0x4(%ebp)
  8012e1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	75 c9                	jne    8012ba <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8012fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801301:	8b 45 10             	mov    0x10(%ebp),%eax
  801304:	01 d0                	add    %edx,%eax
  801306:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801309:	eb 15                	jmp    801320 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	0f b6 d0             	movzbl %al,%edx
  801313:	8b 45 0c             	mov    0xc(%ebp),%eax
  801316:	0f b6 c0             	movzbl %al,%eax
  801319:	39 c2                	cmp    %eax,%edx
  80131b:	74 0d                	je     80132a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80131d:	ff 45 08             	incl   0x8(%ebp)
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801326:	72 e3                	jb     80130b <memfind+0x13>
  801328:	eb 01                	jmp    80132b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80132a:	90                   	nop
	return (void *) s;
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801336:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80133d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801344:	eb 03                	jmp    801349 <strtol+0x19>
		s++;
  801346:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	3c 20                	cmp    $0x20,%al
  801350:	74 f4                	je     801346 <strtol+0x16>
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	3c 09                	cmp    $0x9,%al
  801359:	74 eb                	je     801346 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	8a 00                	mov    (%eax),%al
  801360:	3c 2b                	cmp    $0x2b,%al
  801362:	75 05                	jne    801369 <strtol+0x39>
		s++;
  801364:	ff 45 08             	incl   0x8(%ebp)
  801367:	eb 13                	jmp    80137c <strtol+0x4c>
	else if (*s == '-')
  801369:	8b 45 08             	mov    0x8(%ebp),%eax
  80136c:	8a 00                	mov    (%eax),%al
  80136e:	3c 2d                	cmp    $0x2d,%al
  801370:	75 0a                	jne    80137c <strtol+0x4c>
		s++, neg = 1;
  801372:	ff 45 08             	incl   0x8(%ebp)
  801375:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80137c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801380:	74 06                	je     801388 <strtol+0x58>
  801382:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801386:	75 20                	jne    8013a8 <strtol+0x78>
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	8a 00                	mov    (%eax),%al
  80138d:	3c 30                	cmp    $0x30,%al
  80138f:	75 17                	jne    8013a8 <strtol+0x78>
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	40                   	inc    %eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	3c 78                	cmp    $0x78,%al
  801399:	75 0d                	jne    8013a8 <strtol+0x78>
		s += 2, base = 16;
  80139b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80139f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013a6:	eb 28                	jmp    8013d0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ac:	75 15                	jne    8013c3 <strtol+0x93>
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	3c 30                	cmp    $0x30,%al
  8013b5:	75 0c                	jne    8013c3 <strtol+0x93>
		s++, base = 8;
  8013b7:	ff 45 08             	incl   0x8(%ebp)
  8013ba:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013c1:	eb 0d                	jmp    8013d0 <strtol+0xa0>
	else if (base == 0)
  8013c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c7:	75 07                	jne    8013d0 <strtol+0xa0>
		base = 10;
  8013c9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	8a 00                	mov    (%eax),%al
  8013d5:	3c 2f                	cmp    $0x2f,%al
  8013d7:	7e 19                	jle    8013f2 <strtol+0xc2>
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	3c 39                	cmp    $0x39,%al
  8013e0:	7f 10                	jg     8013f2 <strtol+0xc2>
			dig = *s - '0';
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	0f be c0             	movsbl %al,%eax
  8013ea:	83 e8 30             	sub    $0x30,%eax
  8013ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013f0:	eb 42                	jmp    801434 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	3c 60                	cmp    $0x60,%al
  8013f9:	7e 19                	jle    801414 <strtol+0xe4>
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	3c 7a                	cmp    $0x7a,%al
  801402:	7f 10                	jg     801414 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801404:	8b 45 08             	mov    0x8(%ebp),%eax
  801407:	8a 00                	mov    (%eax),%al
  801409:	0f be c0             	movsbl %al,%eax
  80140c:	83 e8 57             	sub    $0x57,%eax
  80140f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801412:	eb 20                	jmp    801434 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	3c 40                	cmp    $0x40,%al
  80141b:	7e 39                	jle    801456 <strtol+0x126>
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	3c 5a                	cmp    $0x5a,%al
  801424:	7f 30                	jg     801456 <strtol+0x126>
			dig = *s - 'A' + 10;
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	0f be c0             	movsbl %al,%eax
  80142e:	83 e8 37             	sub    $0x37,%eax
  801431:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801437:	3b 45 10             	cmp    0x10(%ebp),%eax
  80143a:	7d 19                	jge    801455 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80143c:	ff 45 08             	incl   0x8(%ebp)
  80143f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801442:	0f af 45 10          	imul   0x10(%ebp),%eax
  801446:	89 c2                	mov    %eax,%edx
  801448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144b:	01 d0                	add    %edx,%eax
  80144d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801450:	e9 7b ff ff ff       	jmp    8013d0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801455:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801456:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80145a:	74 08                	je     801464 <strtol+0x134>
		*endptr = (char *) s;
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	8b 55 08             	mov    0x8(%ebp),%edx
  801462:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801464:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801468:	74 07                	je     801471 <strtol+0x141>
  80146a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80146d:	f7 d8                	neg    %eax
  80146f:	eb 03                	jmp    801474 <strtol+0x144>
  801471:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801474:	c9                   	leave  
  801475:	c3                   	ret    

00801476 <ltostr>:

void
ltostr(long value, char *str)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80147c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801483:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80148a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80148e:	79 13                	jns    8014a3 <ltostr+0x2d>
	{
		neg = 1;
  801490:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80149d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014a0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014ab:	99                   	cltd   
  8014ac:	f7 f9                	idiv   %ecx
  8014ae:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b4:	8d 50 01             	lea    0x1(%eax),%edx
  8014b7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ba:	89 c2                	mov    %eax,%edx
  8014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bf:	01 d0                	add    %edx,%eax
  8014c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014c4:	83 c2 30             	add    $0x30,%edx
  8014c7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014cc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014d1:	f7 e9                	imul   %ecx
  8014d3:	c1 fa 02             	sar    $0x2,%edx
  8014d6:	89 c8                	mov    %ecx,%eax
  8014d8:	c1 f8 1f             	sar    $0x1f,%eax
  8014db:	29 c2                	sub    %eax,%edx
  8014dd:	89 d0                	mov    %edx,%eax
  8014df:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8014e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014ea:	f7 e9                	imul   %ecx
  8014ec:	c1 fa 02             	sar    $0x2,%edx
  8014ef:	89 c8                	mov    %ecx,%eax
  8014f1:	c1 f8 1f             	sar    $0x1f,%eax
  8014f4:	29 c2                	sub    %eax,%edx
  8014f6:	89 d0                	mov    %edx,%eax
  8014f8:	c1 e0 02             	shl    $0x2,%eax
  8014fb:	01 d0                	add    %edx,%eax
  8014fd:	01 c0                	add    %eax,%eax
  8014ff:	29 c1                	sub    %eax,%ecx
  801501:	89 ca                	mov    %ecx,%edx
  801503:	85 d2                	test   %edx,%edx
  801505:	75 9c                	jne    8014a3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801507:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80150e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801511:	48                   	dec    %eax
  801512:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801515:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801519:	74 3d                	je     801558 <ltostr+0xe2>
		start = 1 ;
  80151b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801522:	eb 34                	jmp    801558 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801524:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152a:	01 d0                	add    %edx,%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801534:	8b 45 0c             	mov    0xc(%ebp),%eax
  801537:	01 c2                	add    %eax,%edx
  801539:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80153c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153f:	01 c8                	add    %ecx,%eax
  801541:	8a 00                	mov    (%eax),%al
  801543:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801545:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154b:	01 c2                	add    %eax,%edx
  80154d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801550:	88 02                	mov    %al,(%edx)
		start++ ;
  801552:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801555:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80155e:	7c c4                	jl     801524 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801560:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801563:	8b 45 0c             	mov    0xc(%ebp),%eax
  801566:	01 d0                	add    %edx,%eax
  801568:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80156b:	90                   	nop
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801574:	ff 75 08             	pushl  0x8(%ebp)
  801577:	e8 54 fa ff ff       	call   800fd0 <strlen>
  80157c:	83 c4 04             	add    $0x4,%esp
  80157f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801582:	ff 75 0c             	pushl  0xc(%ebp)
  801585:	e8 46 fa ff ff       	call   800fd0 <strlen>
  80158a:	83 c4 04             	add    $0x4,%esp
  80158d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801590:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801597:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80159e:	eb 17                	jmp    8015b7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a6:	01 c2                	add    %eax,%edx
  8015a8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	01 c8                	add    %ecx,%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015b4:	ff 45 fc             	incl   -0x4(%ebp)
  8015b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015bd:	7c e1                	jl     8015a0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015cd:	eb 1f                	jmp    8015ee <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d2:	8d 50 01             	lea    0x1(%eax),%edx
  8015d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015d8:	89 c2                	mov    %eax,%edx
  8015da:	8b 45 10             	mov    0x10(%ebp),%eax
  8015dd:	01 c2                	add    %eax,%edx
  8015df:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e5:	01 c8                	add    %ecx,%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8015eb:	ff 45 f8             	incl   -0x8(%ebp)
  8015ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015f4:	7c d9                	jl     8015cf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8015f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fc:	01 d0                	add    %edx,%eax
  8015fe:	c6 00 00             	movb   $0x0,(%eax)
}
  801601:	90                   	nop
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801607:	8b 45 14             	mov    0x14(%ebp),%eax
  80160a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801610:	8b 45 14             	mov    0x14(%ebp),%eax
  801613:	8b 00                	mov    (%eax),%eax
  801615:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80161c:	8b 45 10             	mov    0x10(%ebp),%eax
  80161f:	01 d0                	add    %edx,%eax
  801621:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801627:	eb 0c                	jmp    801635 <strsplit+0x31>
			*string++ = 0;
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	8d 50 01             	lea    0x1(%eax),%edx
  80162f:	89 55 08             	mov    %edx,0x8(%ebp)
  801632:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	84 c0                	test   %al,%al
  80163c:	74 18                	je     801656 <strsplit+0x52>
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	0f be c0             	movsbl %al,%eax
  801646:	50                   	push   %eax
  801647:	ff 75 0c             	pushl  0xc(%ebp)
  80164a:	e8 13 fb ff ff       	call   801162 <strchr>
  80164f:	83 c4 08             	add    $0x8,%esp
  801652:	85 c0                	test   %eax,%eax
  801654:	75 d3                	jne    801629 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	8a 00                	mov    (%eax),%al
  80165b:	84 c0                	test   %al,%al
  80165d:	74 5a                	je     8016b9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80165f:	8b 45 14             	mov    0x14(%ebp),%eax
  801662:	8b 00                	mov    (%eax),%eax
  801664:	83 f8 0f             	cmp    $0xf,%eax
  801667:	75 07                	jne    801670 <strsplit+0x6c>
		{
			return 0;
  801669:	b8 00 00 00 00       	mov    $0x0,%eax
  80166e:	eb 66                	jmp    8016d6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801670:	8b 45 14             	mov    0x14(%ebp),%eax
  801673:	8b 00                	mov    (%eax),%eax
  801675:	8d 48 01             	lea    0x1(%eax),%ecx
  801678:	8b 55 14             	mov    0x14(%ebp),%edx
  80167b:	89 0a                	mov    %ecx,(%edx)
  80167d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801684:	8b 45 10             	mov    0x10(%ebp),%eax
  801687:	01 c2                	add    %eax,%edx
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80168e:	eb 03                	jmp    801693 <strsplit+0x8f>
			string++;
  801690:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	8a 00                	mov    (%eax),%al
  801698:	84 c0                	test   %al,%al
  80169a:	74 8b                	je     801627 <strsplit+0x23>
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	8a 00                	mov    (%eax),%al
  8016a1:	0f be c0             	movsbl %al,%eax
  8016a4:	50                   	push   %eax
  8016a5:	ff 75 0c             	pushl  0xc(%ebp)
  8016a8:	e8 b5 fa ff ff       	call   801162 <strchr>
  8016ad:	83 c4 08             	add    $0x8,%esp
  8016b0:	85 c0                	test   %eax,%eax
  8016b2:	74 dc                	je     801690 <strsplit+0x8c>
			string++;
	}
  8016b4:	e9 6e ff ff ff       	jmp    801627 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016b9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8016bd:	8b 00                	mov    (%eax),%eax
  8016bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c9:	01 d0                	add    %edx,%eax
  8016cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016d1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	57                   	push   %edi
  8016dc:	56                   	push   %esi
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ed:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016f0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016f3:	cd 30                	int    $0x30
  8016f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	5b                   	pop    %ebx
  8016ff:	5e                   	pop    %esi
  801700:	5f                   	pop    %edi
  801701:	5d                   	pop    %ebp
  801702:	c3                   	ret    

00801703 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 04             	sub    $0x4,%esp
  801709:	8b 45 10             	mov    0x10(%ebp),%eax
  80170c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80170f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	52                   	push   %edx
  80171b:	ff 75 0c             	pushl  0xc(%ebp)
  80171e:	50                   	push   %eax
  80171f:	6a 00                	push   $0x0
  801721:	e8 b2 ff ff ff       	call   8016d8 <syscall>
  801726:	83 c4 18             	add    $0x18,%esp
}
  801729:	90                   	nop
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_cgetc>:

int
sys_cgetc(void)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 01                	push   $0x1
  80173b:	e8 98 ff ff ff       	call   8016d8 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	50                   	push   %eax
  801754:	6a 05                	push   $0x5
  801756:	e8 7d ff ff ff       	call   8016d8 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 02                	push   $0x2
  80176f:	e8 64 ff ff ff       	call   8016d8 <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 03                	push   $0x3
  801788:	e8 4b ff ff ff       	call   8016d8 <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 04                	push   $0x4
  8017a1:	e8 32 ff ff ff       	call   8016d8 <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_env_exit>:


void sys_env_exit(void)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 06                	push   $0x6
  8017ba:	e8 19 ff ff ff       	call   8016d8 <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
}
  8017c2:	90                   	nop
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	52                   	push   %edx
  8017d5:	50                   	push   %eax
  8017d6:	6a 07                	push   $0x7
  8017d8:	e8 fb fe ff ff       	call   8016d8 <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	56                   	push   %esi
  8017e6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017e7:	8b 75 18             	mov    0x18(%ebp),%esi
  8017ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	56                   	push   %esi
  8017f7:	53                   	push   %ebx
  8017f8:	51                   	push   %ecx
  8017f9:	52                   	push   %edx
  8017fa:	50                   	push   %eax
  8017fb:	6a 08                	push   $0x8
  8017fd:	e8 d6 fe ff ff       	call   8016d8 <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
}
  801805:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801808:	5b                   	pop    %ebx
  801809:	5e                   	pop    %esi
  80180a:	5d                   	pop    %ebp
  80180b:	c3                   	ret    

0080180c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	52                   	push   %edx
  80181c:	50                   	push   %eax
  80181d:	6a 09                	push   $0x9
  80181f:	e8 b4 fe ff ff       	call   8016d8 <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	ff 75 0c             	pushl  0xc(%ebp)
  801835:	ff 75 08             	pushl  0x8(%ebp)
  801838:	6a 0a                	push   $0xa
  80183a:	e8 99 fe ff ff       	call   8016d8 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 0b                	push   $0xb
  801853:	e8 80 fe ff ff       	call   8016d8 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 0c                	push   $0xc
  80186c:	e8 67 fe ff ff       	call   8016d8 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 0d                	push   $0xd
  801885:	e8 4e fe ff ff       	call   8016d8 <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	ff 75 0c             	pushl  0xc(%ebp)
  80189b:	ff 75 08             	pushl  0x8(%ebp)
  80189e:	6a 11                	push   $0x11
  8018a0:	e8 33 fe ff ff       	call   8016d8 <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
	return;
  8018a8:	90                   	nop
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	ff 75 0c             	pushl  0xc(%ebp)
  8018b7:	ff 75 08             	pushl  0x8(%ebp)
  8018ba:	6a 12                	push   $0x12
  8018bc:	e8 17 fe ff ff       	call   8016d8 <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c4:	90                   	nop
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 0e                	push   $0xe
  8018d6:	e8 fd fd ff ff       	call   8016d8 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	ff 75 08             	pushl  0x8(%ebp)
  8018ee:	6a 0f                	push   $0xf
  8018f0:	e8 e3 fd ff ff       	call   8016d8 <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 10                	push   $0x10
  801909:	e8 ca fd ff ff       	call   8016d8 <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
}
  801911:	90                   	nop
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 14                	push   $0x14
  801923:	e8 b0 fd ff ff       	call   8016d8 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	90                   	nop
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 15                	push   $0x15
  80193d:	e8 96 fd ff ff       	call   8016d8 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	90                   	nop
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_cputc>:


void
sys_cputc(const char c)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	83 ec 04             	sub    $0x4,%esp
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801954:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	50                   	push   %eax
  801961:	6a 16                	push   $0x16
  801963:	e8 70 fd ff ff       	call   8016d8 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	90                   	nop
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 17                	push   $0x17
  80197d:	e8 56 fd ff ff       	call   8016d8 <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	90                   	nop
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	50                   	push   %eax
  801998:	6a 18                	push   $0x18
  80199a:	e8 39 fd ff ff       	call   8016d8 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	52                   	push   %edx
  8019b4:	50                   	push   %eax
  8019b5:	6a 1b                	push   $0x1b
  8019b7:	e8 1c fd ff ff       	call   8016d8 <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	52                   	push   %edx
  8019d1:	50                   	push   %eax
  8019d2:	6a 19                	push   $0x19
  8019d4:	e8 ff fc ff ff       	call   8016d8 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	90                   	nop
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	52                   	push   %edx
  8019ef:	50                   	push   %eax
  8019f0:	6a 1a                	push   $0x1a
  8019f2:	e8 e1 fc ff ff       	call   8016d8 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	90                   	nop
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	8b 45 10             	mov    0x10(%ebp),%eax
  801a06:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a09:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a0c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	6a 00                	push   $0x0
  801a15:	51                   	push   %ecx
  801a16:	52                   	push   %edx
  801a17:	ff 75 0c             	pushl  0xc(%ebp)
  801a1a:	50                   	push   %eax
  801a1b:	6a 1c                	push   $0x1c
  801a1d:	e8 b6 fc ff ff       	call   8016d8 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	52                   	push   %edx
  801a37:	50                   	push   %eax
  801a38:	6a 1d                	push   $0x1d
  801a3a:	e8 99 fc ff ff       	call   8016d8 <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a47:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	51                   	push   %ecx
  801a55:	52                   	push   %edx
  801a56:	50                   	push   %eax
  801a57:	6a 1e                	push   $0x1e
  801a59:	e8 7a fc ff ff       	call   8016d8 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	52                   	push   %edx
  801a73:	50                   	push   %eax
  801a74:	6a 1f                	push   $0x1f
  801a76:	e8 5d fc ff ff       	call   8016d8 <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 20                	push   $0x20
  801a8f:	e8 44 fc ff ff       	call   8016d8 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	ff 75 10             	pushl  0x10(%ebp)
  801aa6:	ff 75 0c             	pushl  0xc(%ebp)
  801aa9:	50                   	push   %eax
  801aaa:	6a 21                	push   $0x21
  801aac:	e8 27 fc ff ff       	call   8016d8 <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	50                   	push   %eax
  801ac5:	6a 22                	push   $0x22
  801ac7:	e8 0c fc ff ff       	call   8016d8 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	90                   	nop
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	50                   	push   %eax
  801ae1:	6a 23                	push   $0x23
  801ae3:	e8 f0 fb ff ff       	call   8016d8 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	90                   	nop
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801af4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801af7:	8d 50 04             	lea    0x4(%eax),%edx
  801afa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	52                   	push   %edx
  801b04:	50                   	push   %eax
  801b05:	6a 24                	push   $0x24
  801b07:	e8 cc fb ff ff       	call   8016d8 <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
	return result;
  801b0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b18:	89 01                	mov    %eax,(%ecx)
  801b1a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	c9                   	leave  
  801b21:	c2 04 00             	ret    $0x4

00801b24 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	ff 75 10             	pushl  0x10(%ebp)
  801b2e:	ff 75 0c             	pushl  0xc(%ebp)
  801b31:	ff 75 08             	pushl  0x8(%ebp)
  801b34:	6a 13                	push   $0x13
  801b36:	e8 9d fb ff ff       	call   8016d8 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3e:	90                   	nop
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 25                	push   $0x25
  801b50:	e8 83 fb ff ff       	call   8016d8 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 04             	sub    $0x4,%esp
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b66:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	50                   	push   %eax
  801b73:	6a 26                	push   $0x26
  801b75:	e8 5e fb ff ff       	call   8016d8 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7d:	90                   	nop
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <rsttst>:
void rsttst()
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 28                	push   $0x28
  801b8f:	e8 44 fb ff ff       	call   8016d8 <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
	return ;
  801b97:	90                   	nop
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	83 ec 04             	sub    $0x4,%esp
  801ba0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ba6:	8b 55 18             	mov    0x18(%ebp),%edx
  801ba9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bad:	52                   	push   %edx
  801bae:	50                   	push   %eax
  801baf:	ff 75 10             	pushl  0x10(%ebp)
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	6a 27                	push   $0x27
  801bba:	e8 19 fb ff ff       	call   8016d8 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc2:	90                   	nop
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <chktst>:
void chktst(uint32 n)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	ff 75 08             	pushl  0x8(%ebp)
  801bd3:	6a 29                	push   $0x29
  801bd5:	e8 fe fa ff ff       	call   8016d8 <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdd:	90                   	nop
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <inctst>:

void inctst()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 2a                	push   $0x2a
  801bef:	e8 e4 fa ff ff       	call   8016d8 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf7:	90                   	nop
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <gettst>:
uint32 gettst()
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 2b                	push   $0x2b
  801c09:	e8 ca fa ff ff       	call   8016d8 <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 2c                	push   $0x2c
  801c25:	e8 ae fa ff ff       	call   8016d8 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
  801c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c30:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c34:	75 07                	jne    801c3d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c36:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3b:	eb 05                	jmp    801c42 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 2c                	push   $0x2c
  801c56:	e8 7d fa ff ff       	call   8016d8 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
  801c5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c61:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c65:	75 07                	jne    801c6e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c67:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6c:	eb 05                	jmp    801c73 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 2c                	push   $0x2c
  801c87:	e8 4c fa ff ff       	call   8016d8 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
  801c8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c92:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c96:	75 07                	jne    801c9f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c98:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9d:	eb 05                	jmp    801ca4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 2c                	push   $0x2c
  801cb8:	e8 1b fa ff ff       	call   8016d8 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
  801cc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cc3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cc7:	75 07                	jne    801cd0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cc9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cce:	eb 05                	jmp    801cd5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	ff 75 08             	pushl  0x8(%ebp)
  801ce5:	6a 2d                	push   $0x2d
  801ce7:	e8 ec f9 ff ff       	call   8016d8 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
	return ;
  801cef:	90                   	nop
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cf6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	6a 00                	push   $0x0
  801d04:	53                   	push   %ebx
  801d05:	51                   	push   %ecx
  801d06:	52                   	push   %edx
  801d07:	50                   	push   %eax
  801d08:	6a 2e                	push   $0x2e
  801d0a:	e8 c9 f9 ff ff       	call   8016d8 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	52                   	push   %edx
  801d27:	50                   	push   %eax
  801d28:	6a 2f                	push   $0x2f
  801d2a:	e8 a9 f9 ff ff       	call   8016d8 <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <__udivdi3>:
  801d34:	55                   	push   %ebp
  801d35:	57                   	push   %edi
  801d36:	56                   	push   %esi
  801d37:	53                   	push   %ebx
  801d38:	83 ec 1c             	sub    $0x1c,%esp
  801d3b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d3f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d47:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d4b:	89 ca                	mov    %ecx,%edx
  801d4d:	89 f8                	mov    %edi,%eax
  801d4f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d53:	85 f6                	test   %esi,%esi
  801d55:	75 2d                	jne    801d84 <__udivdi3+0x50>
  801d57:	39 cf                	cmp    %ecx,%edi
  801d59:	77 65                	ja     801dc0 <__udivdi3+0x8c>
  801d5b:	89 fd                	mov    %edi,%ebp
  801d5d:	85 ff                	test   %edi,%edi
  801d5f:	75 0b                	jne    801d6c <__udivdi3+0x38>
  801d61:	b8 01 00 00 00       	mov    $0x1,%eax
  801d66:	31 d2                	xor    %edx,%edx
  801d68:	f7 f7                	div    %edi
  801d6a:	89 c5                	mov    %eax,%ebp
  801d6c:	31 d2                	xor    %edx,%edx
  801d6e:	89 c8                	mov    %ecx,%eax
  801d70:	f7 f5                	div    %ebp
  801d72:	89 c1                	mov    %eax,%ecx
  801d74:	89 d8                	mov    %ebx,%eax
  801d76:	f7 f5                	div    %ebp
  801d78:	89 cf                	mov    %ecx,%edi
  801d7a:	89 fa                	mov    %edi,%edx
  801d7c:	83 c4 1c             	add    $0x1c,%esp
  801d7f:	5b                   	pop    %ebx
  801d80:	5e                   	pop    %esi
  801d81:	5f                   	pop    %edi
  801d82:	5d                   	pop    %ebp
  801d83:	c3                   	ret    
  801d84:	39 ce                	cmp    %ecx,%esi
  801d86:	77 28                	ja     801db0 <__udivdi3+0x7c>
  801d88:	0f bd fe             	bsr    %esi,%edi
  801d8b:	83 f7 1f             	xor    $0x1f,%edi
  801d8e:	75 40                	jne    801dd0 <__udivdi3+0x9c>
  801d90:	39 ce                	cmp    %ecx,%esi
  801d92:	72 0a                	jb     801d9e <__udivdi3+0x6a>
  801d94:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d98:	0f 87 9e 00 00 00    	ja     801e3c <__udivdi3+0x108>
  801d9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801da3:	89 fa                	mov    %edi,%edx
  801da5:	83 c4 1c             	add    $0x1c,%esp
  801da8:	5b                   	pop    %ebx
  801da9:	5e                   	pop    %esi
  801daa:	5f                   	pop    %edi
  801dab:	5d                   	pop    %ebp
  801dac:	c3                   	ret    
  801dad:	8d 76 00             	lea    0x0(%esi),%esi
  801db0:	31 ff                	xor    %edi,%edi
  801db2:	31 c0                	xor    %eax,%eax
  801db4:	89 fa                	mov    %edi,%edx
  801db6:	83 c4 1c             	add    $0x1c,%esp
  801db9:	5b                   	pop    %ebx
  801dba:	5e                   	pop    %esi
  801dbb:	5f                   	pop    %edi
  801dbc:	5d                   	pop    %ebp
  801dbd:	c3                   	ret    
  801dbe:	66 90                	xchg   %ax,%ax
  801dc0:	89 d8                	mov    %ebx,%eax
  801dc2:	f7 f7                	div    %edi
  801dc4:	31 ff                	xor    %edi,%edi
  801dc6:	89 fa                	mov    %edi,%edx
  801dc8:	83 c4 1c             	add    $0x1c,%esp
  801dcb:	5b                   	pop    %ebx
  801dcc:	5e                   	pop    %esi
  801dcd:	5f                   	pop    %edi
  801dce:	5d                   	pop    %ebp
  801dcf:	c3                   	ret    
  801dd0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801dd5:	89 eb                	mov    %ebp,%ebx
  801dd7:	29 fb                	sub    %edi,%ebx
  801dd9:	89 f9                	mov    %edi,%ecx
  801ddb:	d3 e6                	shl    %cl,%esi
  801ddd:	89 c5                	mov    %eax,%ebp
  801ddf:	88 d9                	mov    %bl,%cl
  801de1:	d3 ed                	shr    %cl,%ebp
  801de3:	89 e9                	mov    %ebp,%ecx
  801de5:	09 f1                	or     %esi,%ecx
  801de7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801deb:	89 f9                	mov    %edi,%ecx
  801ded:	d3 e0                	shl    %cl,%eax
  801def:	89 c5                	mov    %eax,%ebp
  801df1:	89 d6                	mov    %edx,%esi
  801df3:	88 d9                	mov    %bl,%cl
  801df5:	d3 ee                	shr    %cl,%esi
  801df7:	89 f9                	mov    %edi,%ecx
  801df9:	d3 e2                	shl    %cl,%edx
  801dfb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dff:	88 d9                	mov    %bl,%cl
  801e01:	d3 e8                	shr    %cl,%eax
  801e03:	09 c2                	or     %eax,%edx
  801e05:	89 d0                	mov    %edx,%eax
  801e07:	89 f2                	mov    %esi,%edx
  801e09:	f7 74 24 0c          	divl   0xc(%esp)
  801e0d:	89 d6                	mov    %edx,%esi
  801e0f:	89 c3                	mov    %eax,%ebx
  801e11:	f7 e5                	mul    %ebp
  801e13:	39 d6                	cmp    %edx,%esi
  801e15:	72 19                	jb     801e30 <__udivdi3+0xfc>
  801e17:	74 0b                	je     801e24 <__udivdi3+0xf0>
  801e19:	89 d8                	mov    %ebx,%eax
  801e1b:	31 ff                	xor    %edi,%edi
  801e1d:	e9 58 ff ff ff       	jmp    801d7a <__udivdi3+0x46>
  801e22:	66 90                	xchg   %ax,%ax
  801e24:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e28:	89 f9                	mov    %edi,%ecx
  801e2a:	d3 e2                	shl    %cl,%edx
  801e2c:	39 c2                	cmp    %eax,%edx
  801e2e:	73 e9                	jae    801e19 <__udivdi3+0xe5>
  801e30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e33:	31 ff                	xor    %edi,%edi
  801e35:	e9 40 ff ff ff       	jmp    801d7a <__udivdi3+0x46>
  801e3a:	66 90                	xchg   %ax,%ax
  801e3c:	31 c0                	xor    %eax,%eax
  801e3e:	e9 37 ff ff ff       	jmp    801d7a <__udivdi3+0x46>
  801e43:	90                   	nop

00801e44 <__umoddi3>:
  801e44:	55                   	push   %ebp
  801e45:	57                   	push   %edi
  801e46:	56                   	push   %esi
  801e47:	53                   	push   %ebx
  801e48:	83 ec 1c             	sub    $0x1c,%esp
  801e4b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e57:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e63:	89 f3                	mov    %esi,%ebx
  801e65:	89 fa                	mov    %edi,%edx
  801e67:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e6b:	89 34 24             	mov    %esi,(%esp)
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	75 1a                	jne    801e8c <__umoddi3+0x48>
  801e72:	39 f7                	cmp    %esi,%edi
  801e74:	0f 86 a2 00 00 00    	jbe    801f1c <__umoddi3+0xd8>
  801e7a:	89 c8                	mov    %ecx,%eax
  801e7c:	89 f2                	mov    %esi,%edx
  801e7e:	f7 f7                	div    %edi
  801e80:	89 d0                	mov    %edx,%eax
  801e82:	31 d2                	xor    %edx,%edx
  801e84:	83 c4 1c             	add    $0x1c,%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5f                   	pop    %edi
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    
  801e8c:	39 f0                	cmp    %esi,%eax
  801e8e:	0f 87 ac 00 00 00    	ja     801f40 <__umoddi3+0xfc>
  801e94:	0f bd e8             	bsr    %eax,%ebp
  801e97:	83 f5 1f             	xor    $0x1f,%ebp
  801e9a:	0f 84 ac 00 00 00    	je     801f4c <__umoddi3+0x108>
  801ea0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ea5:	29 ef                	sub    %ebp,%edi
  801ea7:	89 fe                	mov    %edi,%esi
  801ea9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ead:	89 e9                	mov    %ebp,%ecx
  801eaf:	d3 e0                	shl    %cl,%eax
  801eb1:	89 d7                	mov    %edx,%edi
  801eb3:	89 f1                	mov    %esi,%ecx
  801eb5:	d3 ef                	shr    %cl,%edi
  801eb7:	09 c7                	or     %eax,%edi
  801eb9:	89 e9                	mov    %ebp,%ecx
  801ebb:	d3 e2                	shl    %cl,%edx
  801ebd:	89 14 24             	mov    %edx,(%esp)
  801ec0:	89 d8                	mov    %ebx,%eax
  801ec2:	d3 e0                	shl    %cl,%eax
  801ec4:	89 c2                	mov    %eax,%edx
  801ec6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801eca:	d3 e0                	shl    %cl,%eax
  801ecc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ed4:	89 f1                	mov    %esi,%ecx
  801ed6:	d3 e8                	shr    %cl,%eax
  801ed8:	09 d0                	or     %edx,%eax
  801eda:	d3 eb                	shr    %cl,%ebx
  801edc:	89 da                	mov    %ebx,%edx
  801ede:	f7 f7                	div    %edi
  801ee0:	89 d3                	mov    %edx,%ebx
  801ee2:	f7 24 24             	mull   (%esp)
  801ee5:	89 c6                	mov    %eax,%esi
  801ee7:	89 d1                	mov    %edx,%ecx
  801ee9:	39 d3                	cmp    %edx,%ebx
  801eeb:	0f 82 87 00 00 00    	jb     801f78 <__umoddi3+0x134>
  801ef1:	0f 84 91 00 00 00    	je     801f88 <__umoddi3+0x144>
  801ef7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801efb:	29 f2                	sub    %esi,%edx
  801efd:	19 cb                	sbb    %ecx,%ebx
  801eff:	89 d8                	mov    %ebx,%eax
  801f01:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f05:	d3 e0                	shl    %cl,%eax
  801f07:	89 e9                	mov    %ebp,%ecx
  801f09:	d3 ea                	shr    %cl,%edx
  801f0b:	09 d0                	or     %edx,%eax
  801f0d:	89 e9                	mov    %ebp,%ecx
  801f0f:	d3 eb                	shr    %cl,%ebx
  801f11:	89 da                	mov    %ebx,%edx
  801f13:	83 c4 1c             	add    $0x1c,%esp
  801f16:	5b                   	pop    %ebx
  801f17:	5e                   	pop    %esi
  801f18:	5f                   	pop    %edi
  801f19:	5d                   	pop    %ebp
  801f1a:	c3                   	ret    
  801f1b:	90                   	nop
  801f1c:	89 fd                	mov    %edi,%ebp
  801f1e:	85 ff                	test   %edi,%edi
  801f20:	75 0b                	jne    801f2d <__umoddi3+0xe9>
  801f22:	b8 01 00 00 00       	mov    $0x1,%eax
  801f27:	31 d2                	xor    %edx,%edx
  801f29:	f7 f7                	div    %edi
  801f2b:	89 c5                	mov    %eax,%ebp
  801f2d:	89 f0                	mov    %esi,%eax
  801f2f:	31 d2                	xor    %edx,%edx
  801f31:	f7 f5                	div    %ebp
  801f33:	89 c8                	mov    %ecx,%eax
  801f35:	f7 f5                	div    %ebp
  801f37:	89 d0                	mov    %edx,%eax
  801f39:	e9 44 ff ff ff       	jmp    801e82 <__umoddi3+0x3e>
  801f3e:	66 90                	xchg   %ax,%ax
  801f40:	89 c8                	mov    %ecx,%eax
  801f42:	89 f2                	mov    %esi,%edx
  801f44:	83 c4 1c             	add    $0x1c,%esp
  801f47:	5b                   	pop    %ebx
  801f48:	5e                   	pop    %esi
  801f49:	5f                   	pop    %edi
  801f4a:	5d                   	pop    %ebp
  801f4b:	c3                   	ret    
  801f4c:	3b 04 24             	cmp    (%esp),%eax
  801f4f:	72 06                	jb     801f57 <__umoddi3+0x113>
  801f51:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f55:	77 0f                	ja     801f66 <__umoddi3+0x122>
  801f57:	89 f2                	mov    %esi,%edx
  801f59:	29 f9                	sub    %edi,%ecx
  801f5b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f5f:	89 14 24             	mov    %edx,(%esp)
  801f62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f66:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f6a:	8b 14 24             	mov    (%esp),%edx
  801f6d:	83 c4 1c             	add    $0x1c,%esp
  801f70:	5b                   	pop    %ebx
  801f71:	5e                   	pop    %esi
  801f72:	5f                   	pop    %edi
  801f73:	5d                   	pop    %ebp
  801f74:	c3                   	ret    
  801f75:	8d 76 00             	lea    0x0(%esi),%esi
  801f78:	2b 04 24             	sub    (%esp),%eax
  801f7b:	19 fa                	sbb    %edi,%edx
  801f7d:	89 d1                	mov    %edx,%ecx
  801f7f:	89 c6                	mov    %eax,%esi
  801f81:	e9 71 ff ff ff       	jmp    801ef7 <__umoddi3+0xb3>
  801f86:	66 90                	xchg   %ax,%ax
  801f88:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f8c:	72 ea                	jb     801f78 <__umoddi3+0x134>
  801f8e:	89 d9                	mov    %ebx,%ecx
  801f90:	e9 62 ff ff ff       	jmp    801ef7 <__umoddi3+0xb3>
