
obj/user/tst_buffer_2:     file format elf32-i386


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
  800031:	e8 15 09 00 00       	call   80094b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/*SHOULD be on User DATA not on the STACK*/
char arr[PAGE_SIZE*1024*14 + PAGE_SIZE];
//=========================================

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 6c             	sub    $0x6c,%esp



	/*[1] CHECK INITIAL WORKING SET*/
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800041:	a1 20 30 80 00       	mov    0x803020,%eax
  800046:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80004c:	8b 00                	mov    (%eax),%eax
  80004e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800051:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800054:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800059:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005e:	74 14                	je     800074 <_main+0x3c>
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 40 24 80 00       	push   $0x802440
  800068:	6a 17                	push   $0x17
  80006a:	68 88 24 80 00       	push   $0x802488
  80006f:	e8 1c 0a 00 00       	call   800a90 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800074:	a1 20 30 80 00       	mov    0x803020,%eax
  800079:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80007f:	83 c0 10             	add    $0x10,%eax
  800082:	8b 00                	mov    (%eax),%eax
  800084:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800087:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80008a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008f:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800094:	74 14                	je     8000aa <_main+0x72>
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	68 40 24 80 00       	push   $0x802440
  80009e:	6a 18                	push   $0x18
  8000a0:	68 88 24 80 00       	push   $0x802488
  8000a5:	e8 e6 09 00 00       	call   800a90 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8000aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8000af:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8000b5:	83 c0 20             	add    $0x20,%eax
  8000b8:	8b 00                	mov    (%eax),%eax
  8000ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c5:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 40 24 80 00       	push   $0x802440
  8000d4:	6a 19                	push   $0x19
  8000d6:	68 88 24 80 00       	push   $0x802488
  8000db:	e8 b0 09 00 00       	call   800a90 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8000e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e5:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8000eb:	83 c0 30             	add    $0x30,%eax
  8000ee:	8b 00                	mov    (%eax),%eax
  8000f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8000f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000fb:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800100:	74 14                	je     800116 <_main+0xde>
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	68 40 24 80 00       	push   $0x802440
  80010a:	6a 1a                	push   $0x1a
  80010c:	68 88 24 80 00       	push   $0x802488
  800111:	e8 7a 09 00 00       	call   800a90 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800116:	a1 20 30 80 00       	mov    0x803020,%eax
  80011b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800121:	83 c0 40             	add    $0x40,%eax
  800124:	8b 00                	mov    (%eax),%eax
  800126:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800129:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80012c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800131:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 40 24 80 00       	push   $0x802440
  800140:	6a 1b                	push   $0x1b
  800142:	68 88 24 80 00       	push   $0x802488
  800147:	e8 44 09 00 00       	call   800a90 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80014c:	a1 20 30 80 00       	mov    0x803020,%eax
  800151:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800157:	83 c0 50             	add    $0x50,%eax
  80015a:	8b 00                	mov    (%eax),%eax
  80015c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80015f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800162:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800167:	3d 00 50 20 00       	cmp    $0x205000,%eax
  80016c:	74 14                	je     800182 <_main+0x14a>
  80016e:	83 ec 04             	sub    $0x4,%esp
  800171:	68 40 24 80 00       	push   $0x802440
  800176:	6a 1c                	push   $0x1c
  800178:	68 88 24 80 00       	push   $0x802488
  80017d:	e8 0e 09 00 00       	call   800a90 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800182:	a1 20 30 80 00       	mov    0x803020,%eax
  800187:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80018d:	83 c0 60             	add    $0x60,%eax
  800190:	8b 00                	mov    (%eax),%eax
  800192:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800195:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800198:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019d:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a2:	74 14                	je     8001b8 <_main+0x180>
  8001a4:	83 ec 04             	sub    $0x4,%esp
  8001a7:	68 40 24 80 00       	push   $0x802440
  8001ac:	6a 1d                	push   $0x1d
  8001ae:	68 88 24 80 00       	push   $0x802488
  8001b3:	e8 d8 08 00 00       	call   800a90 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bd:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8001c3:	83 c0 70             	add    $0x70,%eax
  8001c6:	8b 00                	mov    (%eax),%eax
  8001c8:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8001cb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d3:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001d8:	74 14                	je     8001ee <_main+0x1b6>
  8001da:	83 ec 04             	sub    $0x4,%esp
  8001dd:	68 40 24 80 00       	push   $0x802440
  8001e2:	6a 1e                	push   $0x1e
  8001e4:	68 88 24 80 00       	push   $0x802488
  8001e9:	e8 a2 08 00 00       	call   800a90 <_panic>
		//if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f3:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8001f9:	83 e8 80             	sub    $0xffffff80,%eax
  8001fc:	8b 00                	mov    (%eax),%eax
  8001fe:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800201:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800204:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800209:	3d 00 20 80 00       	cmp    $0x802000,%eax
  80020e:	74 14                	je     800224 <_main+0x1ec>
  800210:	83 ec 04             	sub    $0x4,%esp
  800213:	68 40 24 80 00       	push   $0x802440
  800218:	6a 20                	push   $0x20
  80021a:	68 88 24 80 00       	push   $0x802488
  80021f:	e8 6c 08 00 00       	call   800a90 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800224:	a1 20 30 80 00       	mov    0x803020,%eax
  800229:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80022f:	05 90 00 00 00       	add    $0x90,%eax
  800234:	8b 00                	mov    (%eax),%eax
  800236:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800239:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800241:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800246:	74 14                	je     80025c <_main+0x224>
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	68 40 24 80 00       	push   $0x802440
  800250:	6a 21                	push   $0x21
  800252:	68 88 24 80 00       	push   $0x802488
  800257:	e8 34 08 00 00       	call   800a90 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80025c:	a1 20 30 80 00       	mov    0x803020,%eax
  800261:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800267:	05 a0 00 00 00       	add    $0xa0,%eax
  80026c:	8b 00                	mov    (%eax),%eax
  80026e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800271:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800274:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800279:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80027e:	74 14                	je     800294 <_main+0x25c>
  800280:	83 ec 04             	sub    $0x4,%esp
  800283:	68 40 24 80 00       	push   $0x802440
  800288:	6a 22                	push   $0x22
  80028a:	68 88 24 80 00       	push   $0x802488
  80028f:	e8 fc 07 00 00       	call   800a90 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review sizes of the two WS's..!!");
  800294:	a1 20 30 80 00       	mov    0x803020,%eax
  800299:	8b 80 18 3c 01 00    	mov    0x13c18(%eax),%eax
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	74 14                	je     8002b7 <_main+0x27f>
  8002a3:	83 ec 04             	sub    $0x4,%esp
  8002a6:	68 9c 24 80 00       	push   $0x80249c
  8002ab:	6a 23                	push   $0x23
  8002ad:	68 88 24 80 00       	push   $0x802488
  8002b2:	e8 d9 07 00 00       	call   800a90 <_panic>

	/*[2] RUN THE SLAVE PROGRAM*/

	//****************************************************************************************************************
	//IMP: program name is placed statically on the stack to avoid PAGE FAULT on it during the sys call inside the Kernel
	char slaveProgName[10] = "tpb2slave";
  8002b7:	8d 45 92             	lea    -0x6e(%ebp),%eax
  8002ba:	bb 23 28 80 00       	mov    $0x802823,%ebx
  8002bf:	ba 0a 00 00 00       	mov    $0xa,%edx
  8002c4:	89 c7                	mov    %eax,%edi
  8002c6:	89 de                	mov    %ebx,%esi
  8002c8:	89 d1                	mov    %edx,%ecx
  8002ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	//****************************************************************************************************************

	int32 envIdSlave = sys_create_env(slaveProgName, (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d1:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8002d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002dc:	8b 40 74             	mov    0x74(%eax),%eax
  8002df:	83 ec 04             	sub    $0x4,%esp
  8002e2:	52                   	push   %edx
  8002e3:	50                   	push   %eax
  8002e4:	8d 45 92             	lea    -0x6e(%ebp),%eax
  8002e7:	50                   	push   %eax
  8002e8:	e8 90 1b 00 00       	call   801e7d <sys_create_env>
  8002ed:	83 c4 10             	add    $0x10,%esp
  8002f0:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int initModBufCnt = sys_calculate_modified_frames();
  8002f3:	e8 49 19 00 00       	call   801c41 <sys_calculate_modified_frames>
  8002f8:	89 45 ac             	mov    %eax,-0x54(%ebp)
	sys_run_env(envIdSlave);
  8002fb:	83 ec 0c             	sub    $0xc,%esp
  8002fe:	ff 75 b0             	pushl  -0x50(%ebp)
  800301:	e8 94 1b 00 00       	call   801e9a <sys_run_env>
  800306:	83 c4 10             	add    $0x10,%esp

	/*[3] BUSY-WAIT FOR A WHILE TILL FINISHING IT*/
	env_sleep(5000);
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	68 88 13 00 00       	push   $0x1388
  800311:	e8 02 1e 00 00       	call   802118 <env_sleep>
  800316:	83 c4 10             	add    $0x10,%esp


	//NOW: modified list contains 7 pages from the slave program
	if (sys_calculate_modified_frames() - initModBufCnt  != 7)  panic("Error in BUFFERING/RESTORING of modified frames of the slave ... WRONG number of buffered pages in MODIFIED frame list");
  800319:	e8 23 19 00 00       	call   801c41 <sys_calculate_modified_frames>
  80031e:	89 c2                	mov    %eax,%edx
  800320:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800323:	29 c2                	sub    %eax,%edx
  800325:	89 d0                	mov    %edx,%eax
  800327:	83 f8 07             	cmp    $0x7,%eax
  80032a:	74 14                	je     800340 <_main+0x308>
  80032c:	83 ec 04             	sub    $0x4,%esp
  80032f:	68 ec 24 80 00       	push   $0x8024ec
  800334:	6a 36                	push   $0x36
  800336:	68 88 24 80 00       	push   $0x802488
  80033b:	e8 50 07 00 00       	call   800a90 <_panic>


	/*START OF TST_BUFFER_2*/
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800340:	e8 66 19 00 00       	call   801cab <sys_pf_calculate_allocated_pages>
  800345:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int freePages = sys_calculate_free_frames();
  800348:	e8 db 18 00 00       	call   801c28 <sys_calculate_free_frames>
  80034d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  800350:	e8 ec 18 00 00       	call   801c41 <sys_calculate_modified_frames>
  800355:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int initFreeBufCnt = sys_calculate_notmod_frames();
  800358:	e8 fd 18 00 00       	call   801c5a <sys_calculate_notmod_frames>
  80035d:	89 45 a0             	mov    %eax,-0x60(%ebp)
	int dummy = 0;
  800360:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
	//Fault #1
	int i=0;
  800367:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for(;i<1;i++)
  80036e:	eb 0e                	jmp    80037e <_main+0x346>
	{
		arr[i] = -1;
  800370:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800373:	05 40 30 80 00       	add    $0x803040,%eax
  800378:	c6 00 ff             	movb   $0xff,(%eax)
	initModBufCnt = sys_calculate_modified_frames();
	int initFreeBufCnt = sys_calculate_notmod_frames();
	int dummy = 0;
	//Fault #1
	int i=0;
	for(;i<1;i++)
  80037b:	ff 45 e4             	incl   -0x1c(%ebp)
  80037e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800382:	7e ec                	jle    800370 <_main+0x338>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800384:	e8 d1 18 00 00       	call   801c5a <sys_calculate_notmod_frames>
  800389:	89 c2                	mov    %eax,%edx
  80038b:	a1 20 30 80 00       	mov    0x803020,%eax
  800390:	8b 40 4c             	mov    0x4c(%eax),%eax
  800393:	01 d0                	add    %edx,%eax
  800395:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #2
	i=PAGE_SIZE*1024;
  800398:	c7 45 e4 00 00 40 00 	movl   $0x400000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024+1;i++)
  80039f:	eb 0e                	jmp    8003af <_main+0x377>
	{
		arr[i] = -1;
  8003a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003a4:	05 40 30 80 00       	add    $0x803040,%eax
  8003a9:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #2
	i=PAGE_SIZE*1024;
	for(;i<PAGE_SIZE*1024+1;i++)
  8003ac:	ff 45 e4             	incl   -0x1c(%ebp)
  8003af:	81 7d e4 00 00 40 00 	cmpl   $0x400000,-0x1c(%ebp)
  8003b6:	7e e9                	jle    8003a1 <_main+0x369>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8003b8:	e8 9d 18 00 00       	call   801c5a <sys_calculate_notmod_frames>
  8003bd:	89 c2                	mov    %eax,%edx
  8003bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c4:	8b 40 4c             	mov    0x4c(%eax),%eax
  8003c7:	01 d0                	add    %edx,%eax
  8003c9:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #3
	i=PAGE_SIZE*1024*2;
  8003cc:	c7 45 e4 00 00 80 00 	movl   $0x800000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*2+1;i++)
  8003d3:	eb 0e                	jmp    8003e3 <_main+0x3ab>
	{
		arr[i] = -1;
  8003d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d8:	05 40 30 80 00       	add    $0x803040,%eax
  8003dd:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #3
	i=PAGE_SIZE*1024*2;
	for(;i<PAGE_SIZE*1024*2+1;i++)
  8003e0:	ff 45 e4             	incl   -0x1c(%ebp)
  8003e3:	81 7d e4 00 00 80 00 	cmpl   $0x800000,-0x1c(%ebp)
  8003ea:	7e e9                	jle    8003d5 <_main+0x39d>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8003ec:	e8 69 18 00 00       	call   801c5a <sys_calculate_notmod_frames>
  8003f1:	89 c2                	mov    %eax,%edx
  8003f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8003fb:	01 d0                	add    %edx,%eax
  8003fd:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #4
	i=PAGE_SIZE*1024*3;
  800400:	c7 45 e4 00 00 c0 00 	movl   $0xc00000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*3+1;i++)
  800407:	eb 0e                	jmp    800417 <_main+0x3df>
	{
		arr[i] = -1;
  800409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040c:	05 40 30 80 00       	add    $0x803040,%eax
  800411:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #4
	i=PAGE_SIZE*1024*3;
	for(;i<PAGE_SIZE*1024*3+1;i++)
  800414:	ff 45 e4             	incl   -0x1c(%ebp)
  800417:	81 7d e4 00 00 c0 00 	cmpl   $0xc00000,-0x1c(%ebp)
  80041e:	7e e9                	jle    800409 <_main+0x3d1>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800420:	e8 35 18 00 00       	call   801c5a <sys_calculate_notmod_frames>
  800425:	89 c2                	mov    %eax,%edx
  800427:	a1 20 30 80 00       	mov    0x803020,%eax
  80042c:	8b 40 4c             	mov    0x4c(%eax),%eax
  80042f:	01 d0                	add    %edx,%eax
  800431:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #5
	i=PAGE_SIZE*1024*4;
  800434:	c7 45 e4 00 00 00 01 	movl   $0x1000000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*4+1;i++)
  80043b:	eb 0e                	jmp    80044b <_main+0x413>
	{
		arr[i] = -1;
  80043d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800440:	05 40 30 80 00       	add    $0x803040,%eax
  800445:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #5
	i=PAGE_SIZE*1024*4;
	for(;i<PAGE_SIZE*1024*4+1;i++)
  800448:	ff 45 e4             	incl   -0x1c(%ebp)
  80044b:	81 7d e4 00 00 00 01 	cmpl   $0x1000000,-0x1c(%ebp)
  800452:	7e e9                	jle    80043d <_main+0x405>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800454:	e8 01 18 00 00       	call   801c5a <sys_calculate_notmod_frames>
  800459:	89 c2                	mov    %eax,%edx
  80045b:	a1 20 30 80 00       	mov    0x803020,%eax
  800460:	8b 40 4c             	mov    0x4c(%eax),%eax
  800463:	01 d0                	add    %edx,%eax
  800465:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #6
	i=PAGE_SIZE*1024*5;
  800468:	c7 45 e4 00 00 40 01 	movl   $0x1400000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*5+1;i++)
  80046f:	eb 0e                	jmp    80047f <_main+0x447>
	{
		arr[i] = -1;
  800471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800474:	05 40 30 80 00       	add    $0x803040,%eax
  800479:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #6
	i=PAGE_SIZE*1024*5;
	for(;i<PAGE_SIZE*1024*5+1;i++)
  80047c:	ff 45 e4             	incl   -0x1c(%ebp)
  80047f:	81 7d e4 00 00 40 01 	cmpl   $0x1400000,-0x1c(%ebp)
  800486:	7e e9                	jle    800471 <_main+0x439>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800488:	e8 cd 17 00 00       	call   801c5a <sys_calculate_notmod_frames>
  80048d:	89 c2                	mov    %eax,%edx
  80048f:	a1 20 30 80 00       	mov    0x803020,%eax
  800494:	8b 40 4c             	mov    0x4c(%eax),%eax
  800497:	01 d0                	add    %edx,%eax
  800499:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #7
	i=PAGE_SIZE*1024*6;
  80049c:	c7 45 e4 00 00 80 01 	movl   $0x1800000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*6+1;i++)
  8004a3:	eb 0e                	jmp    8004b3 <_main+0x47b>
	{
		arr[i] = -1;
  8004a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a8:	05 40 30 80 00       	add    $0x803040,%eax
  8004ad:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #7
	i=PAGE_SIZE*1024*6;
	for(;i<PAGE_SIZE*1024*6+1;i++)
  8004b0:	ff 45 e4             	incl   -0x1c(%ebp)
  8004b3:	81 7d e4 00 00 80 01 	cmpl   $0x1800000,-0x1c(%ebp)
  8004ba:	7e e9                	jle    8004a5 <_main+0x46d>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8004bc:	e8 99 17 00 00       	call   801c5a <sys_calculate_notmod_frames>
  8004c1:	89 c2                	mov    %eax,%edx
  8004c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8004cb:	01 d0                	add    %edx,%eax
  8004cd:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #8
	i=PAGE_SIZE*1024*7;
  8004d0:	c7 45 e4 00 00 c0 01 	movl   $0x1c00000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*7+1;i++)
  8004d7:	eb 0e                	jmp    8004e7 <_main+0x4af>
	{
		arr[i] = -1;
  8004d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004dc:	05 40 30 80 00       	add    $0x803040,%eax
  8004e1:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #8
	i=PAGE_SIZE*1024*7;
	for(;i<PAGE_SIZE*1024*7+1;i++)
  8004e4:	ff 45 e4             	incl   -0x1c(%ebp)
  8004e7:	81 7d e4 00 00 c0 01 	cmpl   $0x1c00000,-0x1c(%ebp)
  8004ee:	7e e9                	jle    8004d9 <_main+0x4a1>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8004f0:	e8 65 17 00 00       	call   801c5a <sys_calculate_notmod_frames>
  8004f5:	89 c2                	mov    %eax,%edx
  8004f7:	a1 20 30 80 00       	mov    0x803020,%eax
  8004fc:	8b 40 4c             	mov    0x4c(%eax),%eax
  8004ff:	01 d0                	add    %edx,%eax
  800501:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//TILL NOW: 8 pages were brought into MEM and be modified (7 unmodified should be buffered)
	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 7)
  800504:	e8 51 17 00 00       	call   801c5a <sys_calculate_notmod_frames>
  800509:	89 c2                	mov    %eax,%edx
  80050b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80050e:	29 c2                	sub    %eax,%edx
  800510:	89 d0                	mov    %edx,%eax
  800512:	83 f8 07             	cmp    $0x7,%eax
  800515:	74 31                	je     800548 <_main+0x510>
	{
		sys_env_destroy(envIdSlave);
  800517:	83 ec 0c             	sub    $0xc,%esp
  80051a:	ff 75 b0             	pushl  -0x50(%ebp)
  80051d:	e8 07 16 00 00       	call   801b29 <sys_env_destroy>
  800522:	83 c4 10             	add    $0x10,%esp
		panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list %d",sys_calculate_notmod_frames()  - initFreeBufCnt);
  800525:	e8 30 17 00 00       	call   801c5a <sys_calculate_notmod_frames>
  80052a:	89 c2                	mov    %eax,%edx
  80052c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80052f:	29 c2                	sub    %eax,%edx
  800531:	89 d0                	mov    %edx,%eax
  800533:	50                   	push   %eax
  800534:	68 64 25 80 00       	push   $0x802564
  800539:	68 83 00 00 00       	push   $0x83
  80053e:	68 88 24 80 00       	push   $0x802488
  800543:	e8 48 05 00 00       	call   800a90 <_panic>
	}
	if (sys_calculate_modified_frames() - initModBufCnt  != 0)
  800548:	e8 f4 16 00 00       	call   801c41 <sys_calculate_modified_frames>
  80054d:	89 c2                	mov    %eax,%edx
  80054f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800552:	39 c2                	cmp    %eax,%edx
  800554:	74 25                	je     80057b <_main+0x543>
	{
		sys_env_destroy(envIdSlave);
  800556:	83 ec 0c             	sub    $0xc,%esp
  800559:	ff 75 b0             	pushl  -0x50(%ebp)
  80055c:	e8 c8 15 00 00       	call   801b29 <sys_env_destroy>
  800561:	83 c4 10             	add    $0x10,%esp
		panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800564:	83 ec 04             	sub    $0x4,%esp
  800567:	68 c8 25 80 00       	push   $0x8025c8
  80056c:	68 88 00 00 00       	push   $0x88
  800571:	68 88 24 80 00       	push   $0x802488
  800576:	e8 15 05 00 00       	call   800a90 <_panic>
	}

	initFreeBufCnt = sys_calculate_notmod_frames();
  80057b:	e8 da 16 00 00       	call   801c5a <sys_calculate_notmod_frames>
  800580:	89 45 a0             	mov    %eax,-0x60(%ebp)

	//The following 7 faults should victimize the 7 previously modified pages
	//(i.e. the modified list should be freed after 3 faults... then, two modified frames will be added to it again)
	//Fault #7
	i=PAGE_SIZE*1024*8;
  800583:	c7 45 e4 00 00 00 02 	movl   $0x2000000,-0x1c(%ebp)
	int s = 0;
  80058a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for(;i<PAGE_SIZE*1024*8+1;i++)
  800591:	eb 13                	jmp    8005a6 <_main+0x56e>
	{
		s += arr[i] ;
  800593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800596:	05 40 30 80 00       	add    $0x803040,%eax
  80059b:	8a 00                	mov    (%eax),%al
  80059d:	0f be c0             	movsbl %al,%eax
  8005a0:	01 45 e0             	add    %eax,-0x20(%ebp)
	//The following 7 faults should victimize the 7 previously modified pages
	//(i.e. the modified list should be freed after 3 faults... then, two modified frames will be added to it again)
	//Fault #7
	i=PAGE_SIZE*1024*8;
	int s = 0;
	for(;i<PAGE_SIZE*1024*8+1;i++)
  8005a3:	ff 45 e4             	incl   -0x1c(%ebp)
  8005a6:	81 7d e4 00 00 00 02 	cmpl   $0x2000000,-0x1c(%ebp)
  8005ad:	7e e4                	jle    800593 <_main+0x55b>
	{
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8005af:	e8 a6 16 00 00       	call   801c5a <sys_calculate_notmod_frames>
  8005b4:	89 c2                	mov    %eax,%edx
  8005b6:	a1 20 30 80 00       	mov    0x803020,%eax
  8005bb:	8b 40 4c             	mov    0x4c(%eax),%eax
  8005be:	01 d0                	add    %edx,%eax
  8005c0:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #8
	i=PAGE_SIZE*1024*9;
  8005c3:	c7 45 e4 00 00 40 02 	movl   $0x2400000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*9+1;i++)
  8005ca:	eb 13                	jmp    8005df <_main+0x5a7>
	{
		s += arr[i] ;
  8005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005cf:	05 40 30 80 00       	add    $0x803040,%eax
  8005d4:	8a 00                	mov    (%eax),%al
  8005d6:	0f be c0             	movsbl %al,%eax
  8005d9:	01 45 e0             	add    %eax,-0x20(%ebp)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #8
	i=PAGE_SIZE*1024*9;
	for(;i<PAGE_SIZE*1024*9+1;i++)
  8005dc:	ff 45 e4             	incl   -0x1c(%ebp)
  8005df:	81 7d e4 00 00 40 02 	cmpl   $0x2400000,-0x1c(%ebp)
  8005e6:	7e e4                	jle    8005cc <_main+0x594>
	{
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8005e8:	e8 6d 16 00 00       	call   801c5a <sys_calculate_notmod_frames>
  8005ed:	89 c2                	mov    %eax,%edx
  8005ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f4:	8b 40 4c             	mov    0x4c(%eax),%eax
  8005f7:	01 d0                	add    %edx,%eax
  8005f9:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #9
	i=PAGE_SIZE*1024*10;
  8005fc:	c7 45 e4 00 00 80 02 	movl   $0x2800000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*10+1;i++)
  800603:	eb 13                	jmp    800618 <_main+0x5e0>
	{
		s += arr[i] ;
  800605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800608:	05 40 30 80 00       	add    $0x803040,%eax
  80060d:	8a 00                	mov    (%eax),%al
  80060f:	0f be c0             	movsbl %al,%eax
  800612:	01 45 e0             	add    %eax,-0x20(%ebp)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #9
	i=PAGE_SIZE*1024*10;
	for(;i<PAGE_SIZE*1024*10+1;i++)
  800615:	ff 45 e4             	incl   -0x1c(%ebp)
  800618:	81 7d e4 00 00 80 02 	cmpl   $0x2800000,-0x1c(%ebp)
  80061f:	7e e4                	jle    800605 <_main+0x5cd>
	{
		s += arr[i] ;
	}

	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800621:	e8 34 16 00 00       	call   801c5a <sys_calculate_notmod_frames>
  800626:	89 c2                	mov    %eax,%edx
  800628:	a1 20 30 80 00       	mov    0x803020,%eax
  80062d:	8b 40 4c             	mov    0x4c(%eax),%eax
  800630:	01 d0                	add    %edx,%eax
  800632:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//HERE: modified list should be freed
	if (sys_calculate_modified_frames() != 0)
  800635:	e8 07 16 00 00       	call   801c41 <sys_calculate_modified_frames>
  80063a:	85 c0                	test   %eax,%eax
  80063c:	74 25                	je     800663 <_main+0x62b>
	{
		sys_env_destroy(envIdSlave);
  80063e:	83 ec 0c             	sub    $0xc,%esp
  800641:	ff 75 b0             	pushl  -0x50(%ebp)
  800644:	e8 e0 14 00 00       	call   801b29 <sys_env_destroy>
  800649:	83 c4 10             	add    $0x10,%esp
		panic("Modified frames not removed from list (or not updated) correctly when the modified list reaches MAX");
  80064c:	83 ec 04             	sub    $0x4,%esp
  80064f:	68 34 26 80 00       	push   $0x802634
  800654:	68 ad 00 00 00       	push   $0xad
  800659:	68 88 24 80 00       	push   $0x802488
  80065e:	e8 2d 04 00 00       	call   800a90 <_panic>
	}
	if ((sys_calculate_notmod_frames() - initFreeBufCnt) != 10)
  800663:	e8 f2 15 00 00       	call   801c5a <sys_calculate_notmod_frames>
  800668:	89 c2                	mov    %eax,%edx
  80066a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80066d:	29 c2                	sub    %eax,%edx
  80066f:	89 d0                	mov    %edx,%eax
  800671:	83 f8 0a             	cmp    $0xa,%eax
  800674:	74 25                	je     80069b <_main+0x663>
	{
		sys_env_destroy(envIdSlave);
  800676:	83 ec 0c             	sub    $0xc,%esp
  800679:	ff 75 b0             	pushl  -0x50(%ebp)
  80067c:	e8 a8 14 00 00       	call   801b29 <sys_env_destroy>
  800681:	83 c4 10             	add    $0x10,%esp
		panic("Modified frames not added to free frame list as BUFFERED when the modified list reaches MAX");
  800684:	83 ec 04             	sub    $0x4,%esp
  800687:	68 98 26 80 00       	push   $0x802698
  80068c:	68 b2 00 00 00       	push   $0xb2
  800691:	68 88 24 80 00       	push   $0x802488
  800696:	e8 f5 03 00 00       	call   800a90 <_panic>
	}

	//Three additional fault (i.e. three modified page will be added to modified list)
	//Fault #10
	i = PAGE_SIZE * 1024 * 11;
  80069b:	c7 45 e4 00 00 c0 02 	movl   $0x2c00000,-0x1c(%ebp)
	for (; i < PAGE_SIZE * 1024*11 + 1; i++) {
  8006a2:	eb 13                	jmp    8006b7 <_main+0x67f>
		s += arr[i] ;
  8006a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a7:	05 40 30 80 00       	add    $0x803040,%eax
  8006ac:	8a 00                	mov    (%eax),%al
  8006ae:	0f be c0             	movsbl %al,%eax
  8006b1:	01 45 e0             	add    %eax,-0x20(%ebp)
	}

	//Three additional fault (i.e. three modified page will be added to modified list)
	//Fault #10
	i = PAGE_SIZE * 1024 * 11;
	for (; i < PAGE_SIZE * 1024*11 + 1; i++) {
  8006b4:	ff 45 e4             	incl   -0x1c(%ebp)
  8006b7:	81 7d e4 00 00 c0 02 	cmpl   $0x2c00000,-0x1c(%ebp)
  8006be:	7e e4                	jle    8006a4 <_main+0x66c>
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8006c0:	e8 95 15 00 00       	call   801c5a <sys_calculate_notmod_frames>
  8006c5:	89 c2                	mov    %eax,%edx
  8006c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8006cc:	8b 40 4c             	mov    0x4c(%eax),%eax
  8006cf:	01 d0                	add    %edx,%eax
  8006d1:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #11
	i = PAGE_SIZE * 1024 * 12;
  8006d4:	c7 45 e4 00 00 00 03 	movl   $0x3000000,-0x1c(%ebp)
	for (; i < PAGE_SIZE * 1024*12 + 1; i++) {
  8006db:	eb 13                	jmp    8006f0 <_main+0x6b8>
		s += arr[i] ;
  8006dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006e0:	05 40 30 80 00       	add    $0x803040,%eax
  8006e5:	8a 00                	mov    (%eax),%al
  8006e7:	0f be c0             	movsbl %al,%eax
  8006ea:	01 45 e0             	add    %eax,-0x20(%ebp)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #11
	i = PAGE_SIZE * 1024 * 12;
	for (; i < PAGE_SIZE * 1024*12 + 1; i++) {
  8006ed:	ff 45 e4             	incl   -0x1c(%ebp)
  8006f0:	81 7d e4 00 00 00 03 	cmpl   $0x3000000,-0x1c(%ebp)
  8006f7:	7e e4                	jle    8006dd <_main+0x6a5>
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8006f9:	e8 5c 15 00 00       	call   801c5a <sys_calculate_notmod_frames>
  8006fe:	89 c2                	mov    %eax,%edx
  800700:	a1 20 30 80 00       	mov    0x803020,%eax
  800705:	8b 40 4c             	mov    0x4c(%eax),%eax
  800708:	01 d0                	add    %edx,%eax
  80070a:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #12
	i = PAGE_SIZE * 1024 * 13;
  80070d:	c7 45 e4 00 00 40 03 	movl   $0x3400000,-0x1c(%ebp)
	for (; i < PAGE_SIZE * 1024*13 + 1; i++) {
  800714:	eb 13                	jmp    800729 <_main+0x6f1>
		s += arr[i] ;
  800716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800719:	05 40 30 80 00       	add    $0x803040,%eax
  80071e:	8a 00                	mov    (%eax),%al
  800720:	0f be c0             	movsbl %al,%eax
  800723:	01 45 e0             	add    %eax,-0x20(%ebp)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #12
	i = PAGE_SIZE * 1024 * 13;
	for (; i < PAGE_SIZE * 1024*13 + 1; i++) {
  800726:	ff 45 e4             	incl   -0x1c(%ebp)
  800729:	81 7d e4 00 00 40 03 	cmpl   $0x3400000,-0x1c(%ebp)
  800730:	7e e4                	jle    800716 <_main+0x6de>
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800732:	e8 23 15 00 00       	call   801c5a <sys_calculate_notmod_frames>
  800737:	89 c2                	mov    %eax,%edx
  800739:	a1 20 30 80 00       	mov    0x803020,%eax
  80073e:	8b 40 4c             	mov    0x4c(%eax),%eax
  800741:	01 d0                	add    %edx,%eax
  800743:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//cprintf("testing...\n");
	{
		if (sys_calculate_modified_frames() != 3)
  800746:	e8 f6 14 00 00       	call   801c41 <sys_calculate_modified_frames>
  80074b:	83 f8 03             	cmp    $0x3,%eax
  80074e:	74 25                	je     800775 <_main+0x73d>
		{
			sys_env_destroy(envIdSlave);
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	ff 75 b0             	pushl  -0x50(%ebp)
  800756:	e8 ce 13 00 00       	call   801b29 <sys_env_destroy>
  80075b:	83 c4 10             	add    $0x10,%esp
			panic("Modified frames not removed from list (or not updated) correctly when the modified list reaches MAX");
  80075e:	83 ec 04             	sub    $0x4,%esp
  800761:	68 34 26 80 00       	push   $0x802634
  800766:	68 d0 00 00 00       	push   $0xd0
  80076b:	68 88 24 80 00       	push   $0x802488
  800770:	e8 1b 03 00 00       	call   800a90 <_panic>
		}

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  800775:	e8 31 15 00 00       	call   801cab <sys_pf_calculate_allocated_pages>
  80077a:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  80077d:	74 25                	je     8007a4 <_main+0x76c>
		{
			sys_env_destroy(envIdSlave);
  80077f:	83 ec 0c             	sub    $0xc,%esp
  800782:	ff 75 b0             	pushl  -0x50(%ebp)
  800785:	e8 9f 13 00 00       	call   801b29 <sys_env_destroy>
  80078a:	83 c4 10             	add    $0x10,%esp
			panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  80078d:	83 ec 04             	sub    $0x4,%esp
  800790:	68 f4 26 80 00       	push   $0x8026f4
  800795:	68 d6 00 00 00       	push   $0xd6
  80079a:	68 88 24 80 00       	push   $0x802488
  80079f:	e8 ec 02 00 00       	call   800a90 <_panic>
		}

		if( arr[0] != -1) 						{sys_env_destroy(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  8007a4:	a0 40 30 80 00       	mov    0x803040,%al
  8007a9:	3c ff                	cmp    $0xff,%al
  8007ab:	74 25                	je     8007d2 <_main+0x79a>
  8007ad:	83 ec 0c             	sub    $0xc,%esp
  8007b0:	ff 75 b0             	pushl  -0x50(%ebp)
  8007b3:	e8 71 13 00 00       	call   801b29 <sys_env_destroy>
  8007b8:	83 c4 10             	add    $0x10,%esp
  8007bb:	83 ec 04             	sub    $0x4,%esp
  8007be:	68 60 27 80 00       	push   $0x802760
  8007c3:	68 d9 00 00 00       	push   $0xd9
  8007c8:	68 88 24 80 00       	push   $0x802488
  8007cd:	e8 be 02 00 00       	call   800a90 <_panic>
		if( arr[PAGE_SIZE * 1024 * 1] != -1) 	{sys_env_destroy(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  8007d2:	a0 40 30 c0 00       	mov    0xc03040,%al
  8007d7:	3c ff                	cmp    $0xff,%al
  8007d9:	74 25                	je     800800 <_main+0x7c8>
  8007db:	83 ec 0c             	sub    $0xc,%esp
  8007de:	ff 75 b0             	pushl  -0x50(%ebp)
  8007e1:	e8 43 13 00 00       	call   801b29 <sys_env_destroy>
  8007e6:	83 c4 10             	add    $0x10,%esp
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	68 60 27 80 00       	push   $0x802760
  8007f1:	68 da 00 00 00       	push   $0xda
  8007f6:	68 88 24 80 00       	push   $0x802488
  8007fb:	e8 90 02 00 00       	call   800a90 <_panic>
		if( arr[PAGE_SIZE * 1024 * 2] != -1) 	{sys_env_destroy(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  800800:	a0 40 30 00 01       	mov    0x1003040,%al
  800805:	3c ff                	cmp    $0xff,%al
  800807:	74 25                	je     80082e <_main+0x7f6>
  800809:	83 ec 0c             	sub    $0xc,%esp
  80080c:	ff 75 b0             	pushl  -0x50(%ebp)
  80080f:	e8 15 13 00 00       	call   801b29 <sys_env_destroy>
  800814:	83 c4 10             	add    $0x10,%esp
  800817:	83 ec 04             	sub    $0x4,%esp
  80081a:	68 60 27 80 00       	push   $0x802760
  80081f:	68 db 00 00 00       	push   $0xdb
  800824:	68 88 24 80 00       	push   $0x802488
  800829:	e8 62 02 00 00       	call   800a90 <_panic>
		if( arr[PAGE_SIZE * 1024 * 3] != -1) 	{sys_env_destroy(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  80082e:	a0 40 30 40 01       	mov    0x1403040,%al
  800833:	3c ff                	cmp    $0xff,%al
  800835:	74 25                	je     80085c <_main+0x824>
  800837:	83 ec 0c             	sub    $0xc,%esp
  80083a:	ff 75 b0             	pushl  -0x50(%ebp)
  80083d:	e8 e7 12 00 00       	call   801b29 <sys_env_destroy>
  800842:	83 c4 10             	add    $0x10,%esp
  800845:	83 ec 04             	sub    $0x4,%esp
  800848:	68 60 27 80 00       	push   $0x802760
  80084d:	68 dc 00 00 00       	push   $0xdc
  800852:	68 88 24 80 00       	push   $0x802488
  800857:	e8 34 02 00 00       	call   800a90 <_panic>
		if( arr[PAGE_SIZE * 1024 * 4] != -1) 	{sys_env_destroy(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  80085c:	a0 40 30 80 01       	mov    0x1803040,%al
  800861:	3c ff                	cmp    $0xff,%al
  800863:	74 25                	je     80088a <_main+0x852>
  800865:	83 ec 0c             	sub    $0xc,%esp
  800868:	ff 75 b0             	pushl  -0x50(%ebp)
  80086b:	e8 b9 12 00 00       	call   801b29 <sys_env_destroy>
  800870:	83 c4 10             	add    $0x10,%esp
  800873:	83 ec 04             	sub    $0x4,%esp
  800876:	68 60 27 80 00       	push   $0x802760
  80087b:	68 dd 00 00 00       	push   $0xdd
  800880:	68 88 24 80 00       	push   $0x802488
  800885:	e8 06 02 00 00       	call   800a90 <_panic>
		if( arr[PAGE_SIZE * 1024 * 5] != -1) 	{sys_env_destroy(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  80088a:	a0 40 30 c0 01       	mov    0x1c03040,%al
  80088f:	3c ff                	cmp    $0xff,%al
  800891:	74 25                	je     8008b8 <_main+0x880>
  800893:	83 ec 0c             	sub    $0xc,%esp
  800896:	ff 75 b0             	pushl  -0x50(%ebp)
  800899:	e8 8b 12 00 00       	call   801b29 <sys_env_destroy>
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	83 ec 04             	sub    $0x4,%esp
  8008a4:	68 60 27 80 00       	push   $0x802760
  8008a9:	68 de 00 00 00       	push   $0xde
  8008ae:	68 88 24 80 00       	push   $0x802488
  8008b3:	e8 d8 01 00 00       	call   800a90 <_panic>
		if( arr[PAGE_SIZE * 1024 * 6] != -1) 	{sys_env_destroy(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  8008b8:	a0 40 30 00 02       	mov    0x2003040,%al
  8008bd:	3c ff                	cmp    $0xff,%al
  8008bf:	74 25                	je     8008e6 <_main+0x8ae>
  8008c1:	83 ec 0c             	sub    $0xc,%esp
  8008c4:	ff 75 b0             	pushl  -0x50(%ebp)
  8008c7:	e8 5d 12 00 00       	call   801b29 <sys_env_destroy>
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 60 27 80 00       	push   $0x802760
  8008d7:	68 df 00 00 00       	push   $0xdf
  8008dc:	68 88 24 80 00       	push   $0x802488
  8008e1:	e8 aa 01 00 00       	call   800a90 <_panic>
		if( arr[PAGE_SIZE * 1024 * 7] != -1) 	{sys_env_destroy(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  8008e6:	a0 40 30 40 02       	mov    0x2403040,%al
  8008eb:	3c ff                	cmp    $0xff,%al
  8008ed:	74 25                	je     800914 <_main+0x8dc>
  8008ef:	83 ec 0c             	sub    $0xc,%esp
  8008f2:	ff 75 b0             	pushl  -0x50(%ebp)
  8008f5:	e8 2f 12 00 00       	call   801b29 <sys_env_destroy>
  8008fa:	83 c4 10             	add    $0x10,%esp
  8008fd:	83 ec 04             	sub    $0x4,%esp
  800900:	68 60 27 80 00       	push   $0x802760
  800905:	68 e0 00 00 00       	push   $0xe0
  80090a:	68 88 24 80 00       	push   $0x802488
  80090f:	e8 7c 01 00 00       	call   800a90 <_panic>

		if (sys_calculate_modified_frames() != 0) {sys_env_destroy(envIdSlave);panic("Modified frames not removed from list (or isModified/modified bit is not updated) correctly when the modified list reaches MAX");}
  800914:	e8 28 13 00 00       	call   801c41 <sys_calculate_modified_frames>
  800919:	85 c0                	test   %eax,%eax
  80091b:	74 25                	je     800942 <_main+0x90a>
  80091d:	83 ec 0c             	sub    $0xc,%esp
  800920:	ff 75 b0             	pushl  -0x50(%ebp)
  800923:	e8 01 12 00 00       	call   801b29 <sys_env_destroy>
  800928:	83 c4 10             	add    $0x10,%esp
  80092b:	83 ec 04             	sub    $0x4,%esp
  80092e:	68 a4 27 80 00       	push   $0x8027a4
  800933:	68 e2 00 00 00       	push   $0xe2
  800938:	68 88 24 80 00       	push   $0x802488
  80093d:	e8 4e 01 00 00       	call   800a90 <_panic>
	}

	return;
  800942:	90                   	nop
}
  800943:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800946:	5b                   	pop    %ebx
  800947:	5e                   	pop    %esi
  800948:	5f                   	pop    %edi
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800951:	e8 07 12 00 00       	call   801b5d <sys_getenvindex>
  800956:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800959:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095c:	89 d0                	mov    %edx,%eax
  80095e:	c1 e0 03             	shl    $0x3,%eax
  800961:	01 d0                	add    %edx,%eax
  800963:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80096a:	01 c8                	add    %ecx,%eax
  80096c:	01 c0                	add    %eax,%eax
  80096e:	01 d0                	add    %edx,%eax
  800970:	01 c0                	add    %eax,%eax
  800972:	01 d0                	add    %edx,%eax
  800974:	89 c2                	mov    %eax,%edx
  800976:	c1 e2 05             	shl    $0x5,%edx
  800979:	29 c2                	sub    %eax,%edx
  80097b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800982:	89 c2                	mov    %eax,%edx
  800984:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80098a:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80098f:	a1 20 30 80 00       	mov    0x803020,%eax
  800994:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80099a:	84 c0                	test   %al,%al
  80099c:	74 0f                	je     8009ad <libmain+0x62>
		binaryname = myEnv->prog_name;
  80099e:	a1 20 30 80 00       	mov    0x803020,%eax
  8009a3:	05 40 3c 01 00       	add    $0x13c40,%eax
  8009a8:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009b1:	7e 0a                	jle    8009bd <libmain+0x72>
		binaryname = argv[0];
  8009b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b6:	8b 00                	mov    (%eax),%eax
  8009b8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8009bd:	83 ec 08             	sub    $0x8,%esp
  8009c0:	ff 75 0c             	pushl  0xc(%ebp)
  8009c3:	ff 75 08             	pushl  0x8(%ebp)
  8009c6:	e8 6d f6 ff ff       	call   800038 <_main>
  8009cb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8009ce:	e8 25 13 00 00       	call   801cf8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009d3:	83 ec 0c             	sub    $0xc,%esp
  8009d6:	68 48 28 80 00       	push   $0x802848
  8009db:	e8 52 03 00 00       	call   800d32 <cprintf>
  8009e0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8009e8:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8009ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8009f3:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8009f9:	83 ec 04             	sub    $0x4,%esp
  8009fc:	52                   	push   %edx
  8009fd:	50                   	push   %eax
  8009fe:	68 70 28 80 00       	push   $0x802870
  800a03:	e8 2a 03 00 00       	call   800d32 <cprintf>
  800a08:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800a0b:	a1 20 30 80 00       	mov    0x803020,%eax
  800a10:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800a16:	a1 20 30 80 00       	mov    0x803020,%eax
  800a1b:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800a21:	83 ec 04             	sub    $0x4,%esp
  800a24:	52                   	push   %edx
  800a25:	50                   	push   %eax
  800a26:	68 98 28 80 00       	push   $0x802898
  800a2b:	e8 02 03 00 00       	call   800d32 <cprintf>
  800a30:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a33:	a1 20 30 80 00       	mov    0x803020,%eax
  800a38:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800a3e:	83 ec 08             	sub    $0x8,%esp
  800a41:	50                   	push   %eax
  800a42:	68 d9 28 80 00       	push   $0x8028d9
  800a47:	e8 e6 02 00 00       	call   800d32 <cprintf>
  800a4c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a4f:	83 ec 0c             	sub    $0xc,%esp
  800a52:	68 48 28 80 00       	push   $0x802848
  800a57:	e8 d6 02 00 00       	call   800d32 <cprintf>
  800a5c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a5f:	e8 ae 12 00 00       	call   801d12 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a64:	e8 19 00 00 00       	call   800a82 <exit>
}
  800a69:	90                   	nop
  800a6a:	c9                   	leave  
  800a6b:	c3                   	ret    

00800a6c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800a72:	83 ec 0c             	sub    $0xc,%esp
  800a75:	6a 00                	push   $0x0
  800a77:	e8 ad 10 00 00       	call   801b29 <sys_env_destroy>
  800a7c:	83 c4 10             	add    $0x10,%esp
}
  800a7f:	90                   	nop
  800a80:	c9                   	leave  
  800a81:	c3                   	ret    

00800a82 <exit>:

void
exit(void)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800a88:	e8 02 11 00 00       	call   801b8f <sys_env_exit>
}
  800a8d:	90                   	nop
  800a8e:	c9                   	leave  
  800a8f:	c3                   	ret    

00800a90 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a96:	8d 45 10             	lea    0x10(%ebp),%eax
  800a99:	83 c0 04             	add    $0x4,%eax
  800a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a9f:	a1 18 41 00 04       	mov    0x4004118,%eax
  800aa4:	85 c0                	test   %eax,%eax
  800aa6:	74 16                	je     800abe <_panic+0x2e>
		cprintf("%s: ", argv0);
  800aa8:	a1 18 41 00 04       	mov    0x4004118,%eax
  800aad:	83 ec 08             	sub    $0x8,%esp
  800ab0:	50                   	push   %eax
  800ab1:	68 f0 28 80 00       	push   $0x8028f0
  800ab6:	e8 77 02 00 00       	call   800d32 <cprintf>
  800abb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800abe:	a1 00 30 80 00       	mov    0x803000,%eax
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	ff 75 08             	pushl  0x8(%ebp)
  800ac9:	50                   	push   %eax
  800aca:	68 f5 28 80 00       	push   $0x8028f5
  800acf:	e8 5e 02 00 00       	call   800d32 <cprintf>
  800ad4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae0:	50                   	push   %eax
  800ae1:	e8 e1 01 00 00       	call   800cc7 <vcprintf>
  800ae6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	6a 00                	push   $0x0
  800aee:	68 11 29 80 00       	push   $0x802911
  800af3:	e8 cf 01 00 00       	call   800cc7 <vcprintf>
  800af8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800afb:	e8 82 ff ff ff       	call   800a82 <exit>

	// should not return here
	while (1) ;
  800b00:	eb fe                	jmp    800b00 <_panic+0x70>

00800b02 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b08:	a1 20 30 80 00       	mov    0x803020,%eax
  800b0d:	8b 50 74             	mov    0x74(%eax),%edx
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	39 c2                	cmp    %eax,%edx
  800b15:	74 14                	je     800b2b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b17:	83 ec 04             	sub    $0x4,%esp
  800b1a:	68 14 29 80 00       	push   $0x802914
  800b1f:	6a 26                	push   $0x26
  800b21:	68 60 29 80 00       	push   $0x802960
  800b26:	e8 65 ff ff ff       	call   800a90 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b32:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b39:	e9 b6 00 00 00       	jmp    800bf4 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	01 d0                	add    %edx,%eax
  800b4d:	8b 00                	mov    (%eax),%eax
  800b4f:	85 c0                	test   %eax,%eax
  800b51:	75 08                	jne    800b5b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800b53:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b56:	e9 96 00 00 00       	jmp    800bf1 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800b5b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b62:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b69:	eb 5d                	jmp    800bc8 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b6b:	a1 20 30 80 00       	mov    0x803020,%eax
  800b70:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b76:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b79:	c1 e2 04             	shl    $0x4,%edx
  800b7c:	01 d0                	add    %edx,%eax
  800b7e:	8a 40 04             	mov    0x4(%eax),%al
  800b81:	84 c0                	test   %al,%al
  800b83:	75 40                	jne    800bc5 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b85:	a1 20 30 80 00       	mov    0x803020,%eax
  800b8a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b93:	c1 e2 04             	shl    $0x4,%edx
  800b96:	01 d0                	add    %edx,%eax
  800b98:	8b 00                	mov    (%eax),%eax
  800b9a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ba0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800baa:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	01 c8                	add    %ecx,%eax
  800bb6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bb8:	39 c2                	cmp    %eax,%edx
  800bba:	75 09                	jne    800bc5 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800bbc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800bc3:	eb 12                	jmp    800bd7 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bc5:	ff 45 e8             	incl   -0x18(%ebp)
  800bc8:	a1 20 30 80 00       	mov    0x803020,%eax
  800bcd:	8b 50 74             	mov    0x74(%eax),%edx
  800bd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800bd3:	39 c2                	cmp    %eax,%edx
  800bd5:	77 94                	ja     800b6b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800bd7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800bdb:	75 14                	jne    800bf1 <CheckWSWithoutLastIndex+0xef>
			panic(
  800bdd:	83 ec 04             	sub    $0x4,%esp
  800be0:	68 6c 29 80 00       	push   $0x80296c
  800be5:	6a 3a                	push   $0x3a
  800be7:	68 60 29 80 00       	push   $0x802960
  800bec:	e8 9f fe ff ff       	call   800a90 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800bf1:	ff 45 f0             	incl   -0x10(%ebp)
  800bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800bfa:	0f 8c 3e ff ff ff    	jl     800b3e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c07:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c0e:	eb 20                	jmp    800c30 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c10:	a1 20 30 80 00       	mov    0x803020,%eax
  800c15:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800c1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c1e:	c1 e2 04             	shl    $0x4,%edx
  800c21:	01 d0                	add    %edx,%eax
  800c23:	8a 40 04             	mov    0x4(%eax),%al
  800c26:	3c 01                	cmp    $0x1,%al
  800c28:	75 03                	jne    800c2d <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800c2a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c2d:	ff 45 e0             	incl   -0x20(%ebp)
  800c30:	a1 20 30 80 00       	mov    0x803020,%eax
  800c35:	8b 50 74             	mov    0x74(%eax),%edx
  800c38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c3b:	39 c2                	cmp    %eax,%edx
  800c3d:	77 d1                	ja     800c10 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c42:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c45:	74 14                	je     800c5b <CheckWSWithoutLastIndex+0x159>
		panic(
  800c47:	83 ec 04             	sub    $0x4,%esp
  800c4a:	68 c0 29 80 00       	push   $0x8029c0
  800c4f:	6a 44                	push   $0x44
  800c51:	68 60 29 80 00       	push   $0x802960
  800c56:	e8 35 fe ff ff       	call   800a90 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c5b:	90                   	nop
  800c5c:	c9                   	leave  
  800c5d:	c3                   	ret    

00800c5e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c67:	8b 00                	mov    (%eax),%eax
  800c69:	8d 48 01             	lea    0x1(%eax),%ecx
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	89 0a                	mov    %ecx,(%edx)
  800c71:	8b 55 08             	mov    0x8(%ebp),%edx
  800c74:	88 d1                	mov    %dl,%cl
  800c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c79:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	8b 00                	mov    (%eax),%eax
  800c82:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c87:	75 2c                	jne    800cb5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c89:	a0 24 30 80 00       	mov    0x803024,%al
  800c8e:	0f b6 c0             	movzbl %al,%eax
  800c91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c94:	8b 12                	mov    (%edx),%edx
  800c96:	89 d1                	mov    %edx,%ecx
  800c98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9b:	83 c2 08             	add    $0x8,%edx
  800c9e:	83 ec 04             	sub    $0x4,%esp
  800ca1:	50                   	push   %eax
  800ca2:	51                   	push   %ecx
  800ca3:	52                   	push   %edx
  800ca4:	e8 3e 0e 00 00       	call   801ae7 <sys_cputs>
  800ca9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb8:	8b 40 04             	mov    0x4(%eax),%eax
  800cbb:	8d 50 01             	lea    0x1(%eax),%edx
  800cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc1:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cc4:	90                   	nop
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800cd0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800cd7:	00 00 00 
	b.cnt = 0;
  800cda:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ce1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ce4:	ff 75 0c             	pushl  0xc(%ebp)
  800ce7:	ff 75 08             	pushl  0x8(%ebp)
  800cea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cf0:	50                   	push   %eax
  800cf1:	68 5e 0c 80 00       	push   $0x800c5e
  800cf6:	e8 11 02 00 00       	call   800f0c <vprintfmt>
  800cfb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800cfe:	a0 24 30 80 00       	mov    0x803024,%al
  800d03:	0f b6 c0             	movzbl %al,%eax
  800d06:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d0c:	83 ec 04             	sub    $0x4,%esp
  800d0f:	50                   	push   %eax
  800d10:	52                   	push   %edx
  800d11:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d17:	83 c0 08             	add    $0x8,%eax
  800d1a:	50                   	push   %eax
  800d1b:	e8 c7 0d 00 00       	call   801ae7 <sys_cputs>
  800d20:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d23:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800d2a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <cprintf>:

int cprintf(const char *fmt, ...) {
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d38:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800d3f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4e:	50                   	push   %eax
  800d4f:	e8 73 ff ff ff       	call   800cc7 <vcprintf>
  800d54:	83 c4 10             	add    $0x10,%esp
  800d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d5d:	c9                   	leave  
  800d5e:	c3                   	ret    

00800d5f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d65:	e8 8e 0f 00 00       	call   801cf8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d6a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	83 ec 08             	sub    $0x8,%esp
  800d76:	ff 75 f4             	pushl  -0xc(%ebp)
  800d79:	50                   	push   %eax
  800d7a:	e8 48 ff ff ff       	call   800cc7 <vcprintf>
  800d7f:	83 c4 10             	add    $0x10,%esp
  800d82:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800d85:	e8 88 0f 00 00       	call   801d12 <sys_enable_interrupt>
	return cnt;
  800d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d8d:	c9                   	leave  
  800d8e:	c3                   	ret    

00800d8f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	53                   	push   %ebx
  800d93:	83 ec 14             	sub    $0x14,%esp
  800d96:	8b 45 10             	mov    0x10(%ebp),%eax
  800d99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800da2:	8b 45 18             	mov    0x18(%ebp),%eax
  800da5:	ba 00 00 00 00       	mov    $0x0,%edx
  800daa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800dad:	77 55                	ja     800e04 <printnum+0x75>
  800daf:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800db2:	72 05                	jb     800db9 <printnum+0x2a>
  800db4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800db7:	77 4b                	ja     800e04 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800db9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800dbc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800dbf:	8b 45 18             	mov    0x18(%ebp),%eax
  800dc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc7:	52                   	push   %edx
  800dc8:	50                   	push   %eax
  800dc9:	ff 75 f4             	pushl  -0xc(%ebp)
  800dcc:	ff 75 f0             	pushl  -0x10(%ebp)
  800dcf:	e8 f8 13 00 00       	call   8021cc <__udivdi3>
  800dd4:	83 c4 10             	add    $0x10,%esp
  800dd7:	83 ec 04             	sub    $0x4,%esp
  800dda:	ff 75 20             	pushl  0x20(%ebp)
  800ddd:	53                   	push   %ebx
  800dde:	ff 75 18             	pushl  0x18(%ebp)
  800de1:	52                   	push   %edx
  800de2:	50                   	push   %eax
  800de3:	ff 75 0c             	pushl  0xc(%ebp)
  800de6:	ff 75 08             	pushl  0x8(%ebp)
  800de9:	e8 a1 ff ff ff       	call   800d8f <printnum>
  800dee:	83 c4 20             	add    $0x20,%esp
  800df1:	eb 1a                	jmp    800e0d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800df3:	83 ec 08             	sub    $0x8,%esp
  800df6:	ff 75 0c             	pushl  0xc(%ebp)
  800df9:	ff 75 20             	pushl  0x20(%ebp)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	ff d0                	call   *%eax
  800e01:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e04:	ff 4d 1c             	decl   0x1c(%ebp)
  800e07:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e0b:	7f e6                	jg     800df3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e0d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e10:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1b:	53                   	push   %ebx
  800e1c:	51                   	push   %ecx
  800e1d:	52                   	push   %edx
  800e1e:	50                   	push   %eax
  800e1f:	e8 b8 14 00 00       	call   8022dc <__umoddi3>
  800e24:	83 c4 10             	add    $0x10,%esp
  800e27:	05 34 2c 80 00       	add    $0x802c34,%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	0f be c0             	movsbl %al,%eax
  800e31:	83 ec 08             	sub    $0x8,%esp
  800e34:	ff 75 0c             	pushl  0xc(%ebp)
  800e37:	50                   	push   %eax
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	ff d0                	call   *%eax
  800e3d:	83 c4 10             	add    $0x10,%esp
}
  800e40:	90                   	nop
  800e41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e49:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e4d:	7e 1c                	jle    800e6b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8b 00                	mov    (%eax),%eax
  800e54:	8d 50 08             	lea    0x8(%eax),%edx
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	89 10                	mov    %edx,(%eax)
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	8b 00                	mov    (%eax),%eax
  800e61:	83 e8 08             	sub    $0x8,%eax
  800e64:	8b 50 04             	mov    0x4(%eax),%edx
  800e67:	8b 00                	mov    (%eax),%eax
  800e69:	eb 40                	jmp    800eab <getuint+0x65>
	else if (lflag)
  800e6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6f:	74 1e                	je     800e8f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8b 00                	mov    (%eax),%eax
  800e76:	8d 50 04             	lea    0x4(%eax),%edx
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	89 10                	mov    %edx,(%eax)
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8b 00                	mov    (%eax),%eax
  800e83:	83 e8 04             	sub    $0x4,%eax
  800e86:	8b 00                	mov    (%eax),%eax
  800e88:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8d:	eb 1c                	jmp    800eab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8b 00                	mov    (%eax),%eax
  800e94:	8d 50 04             	lea    0x4(%eax),%edx
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	89 10                	mov    %edx,(%eax)
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8b 00                	mov    (%eax),%eax
  800ea1:	83 e8 04             	sub    $0x4,%eax
  800ea4:	8b 00                	mov    (%eax),%eax
  800ea6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800eab:	5d                   	pop    %ebp
  800eac:	c3                   	ret    

00800ead <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800eb0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800eb4:	7e 1c                	jle    800ed2 <getint+0x25>
		return va_arg(*ap, long long);
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8b 00                	mov    (%eax),%eax
  800ebb:	8d 50 08             	lea    0x8(%eax),%edx
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	89 10                	mov    %edx,(%eax)
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8b 00                	mov    (%eax),%eax
  800ec8:	83 e8 08             	sub    $0x8,%eax
  800ecb:	8b 50 04             	mov    0x4(%eax),%edx
  800ece:	8b 00                	mov    (%eax),%eax
  800ed0:	eb 38                	jmp    800f0a <getint+0x5d>
	else if (lflag)
  800ed2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ed6:	74 1a                	je     800ef2 <getint+0x45>
		return va_arg(*ap, long);
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	8b 00                	mov    (%eax),%eax
  800edd:	8d 50 04             	lea    0x4(%eax),%edx
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	89 10                	mov    %edx,(%eax)
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8b 00                	mov    (%eax),%eax
  800eea:	83 e8 04             	sub    $0x4,%eax
  800eed:	8b 00                	mov    (%eax),%eax
  800eef:	99                   	cltd   
  800ef0:	eb 18                	jmp    800f0a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8b 00                	mov    (%eax),%eax
  800ef7:	8d 50 04             	lea    0x4(%eax),%edx
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	89 10                	mov    %edx,(%eax)
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8b 00                	mov    (%eax),%eax
  800f04:	83 e8 04             	sub    $0x4,%eax
  800f07:	8b 00                	mov    (%eax),%eax
  800f09:	99                   	cltd   
}
  800f0a:	5d                   	pop    %ebp
  800f0b:	c3                   	ret    

00800f0c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	56                   	push   %esi
  800f10:	53                   	push   %ebx
  800f11:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f14:	eb 17                	jmp    800f2d <vprintfmt+0x21>
			if (ch == '\0')
  800f16:	85 db                	test   %ebx,%ebx
  800f18:	0f 84 af 03 00 00    	je     8012cd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	ff 75 0c             	pushl  0xc(%ebp)
  800f24:	53                   	push   %ebx
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	ff d0                	call   *%eax
  800f2a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f30:	8d 50 01             	lea    0x1(%eax),%edx
  800f33:	89 55 10             	mov    %edx,0x10(%ebp)
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	0f b6 d8             	movzbl %al,%ebx
  800f3b:	83 fb 25             	cmp    $0x25,%ebx
  800f3e:	75 d6                	jne    800f16 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f40:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f44:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f4b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f52:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f59:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f60:	8b 45 10             	mov    0x10(%ebp),%eax
  800f63:	8d 50 01             	lea    0x1(%eax),%edx
  800f66:	89 55 10             	mov    %edx,0x10(%ebp)
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	0f b6 d8             	movzbl %al,%ebx
  800f6e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f71:	83 f8 55             	cmp    $0x55,%eax
  800f74:	0f 87 2b 03 00 00    	ja     8012a5 <vprintfmt+0x399>
  800f7a:	8b 04 85 58 2c 80 00 	mov    0x802c58(,%eax,4),%eax
  800f81:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f83:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f87:	eb d7                	jmp    800f60 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f89:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f8d:	eb d1                	jmp    800f60 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f8f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f96:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f99:	89 d0                	mov    %edx,%eax
  800f9b:	c1 e0 02             	shl    $0x2,%eax
  800f9e:	01 d0                	add    %edx,%eax
  800fa0:	01 c0                	add    %eax,%eax
  800fa2:	01 d8                	add    %ebx,%eax
  800fa4:	83 e8 30             	sub    $0x30,%eax
  800fa7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800faa:	8b 45 10             	mov    0x10(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fb2:	83 fb 2f             	cmp    $0x2f,%ebx
  800fb5:	7e 3e                	jle    800ff5 <vprintfmt+0xe9>
  800fb7:	83 fb 39             	cmp    $0x39,%ebx
  800fba:	7f 39                	jg     800ff5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fbc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800fbf:	eb d5                	jmp    800f96 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800fc1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc4:	83 c0 04             	add    $0x4,%eax
  800fc7:	89 45 14             	mov    %eax,0x14(%ebp)
  800fca:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcd:	83 e8 04             	sub    $0x4,%eax
  800fd0:	8b 00                	mov    (%eax),%eax
  800fd2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800fd5:	eb 1f                	jmp    800ff6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800fd7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fdb:	79 83                	jns    800f60 <vprintfmt+0x54>
				width = 0;
  800fdd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800fe4:	e9 77 ff ff ff       	jmp    800f60 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800fe9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ff0:	e9 6b ff ff ff       	jmp    800f60 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ff5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ff6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ffa:	0f 89 60 ff ff ff    	jns    800f60 <vprintfmt+0x54>
				width = precision, precision = -1;
  801000:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801003:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801006:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80100d:	e9 4e ff ff ff       	jmp    800f60 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801012:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801015:	e9 46 ff ff ff       	jmp    800f60 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80101a:	8b 45 14             	mov    0x14(%ebp),%eax
  80101d:	83 c0 04             	add    $0x4,%eax
  801020:	89 45 14             	mov    %eax,0x14(%ebp)
  801023:	8b 45 14             	mov    0x14(%ebp),%eax
  801026:	83 e8 04             	sub    $0x4,%eax
  801029:	8b 00                	mov    (%eax),%eax
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	50                   	push   %eax
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	ff d0                	call   *%eax
  801037:	83 c4 10             	add    $0x10,%esp
			break;
  80103a:	e9 89 02 00 00       	jmp    8012c8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80103f:	8b 45 14             	mov    0x14(%ebp),%eax
  801042:	83 c0 04             	add    $0x4,%eax
  801045:	89 45 14             	mov    %eax,0x14(%ebp)
  801048:	8b 45 14             	mov    0x14(%ebp),%eax
  80104b:	83 e8 04             	sub    $0x4,%eax
  80104e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801050:	85 db                	test   %ebx,%ebx
  801052:	79 02                	jns    801056 <vprintfmt+0x14a>
				err = -err;
  801054:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801056:	83 fb 64             	cmp    $0x64,%ebx
  801059:	7f 0b                	jg     801066 <vprintfmt+0x15a>
  80105b:	8b 34 9d a0 2a 80 00 	mov    0x802aa0(,%ebx,4),%esi
  801062:	85 f6                	test   %esi,%esi
  801064:	75 19                	jne    80107f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801066:	53                   	push   %ebx
  801067:	68 45 2c 80 00       	push   $0x802c45
  80106c:	ff 75 0c             	pushl  0xc(%ebp)
  80106f:	ff 75 08             	pushl  0x8(%ebp)
  801072:	e8 5e 02 00 00       	call   8012d5 <printfmt>
  801077:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80107a:	e9 49 02 00 00       	jmp    8012c8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80107f:	56                   	push   %esi
  801080:	68 4e 2c 80 00       	push   $0x802c4e
  801085:	ff 75 0c             	pushl  0xc(%ebp)
  801088:	ff 75 08             	pushl  0x8(%ebp)
  80108b:	e8 45 02 00 00       	call   8012d5 <printfmt>
  801090:	83 c4 10             	add    $0x10,%esp
			break;
  801093:	e9 30 02 00 00       	jmp    8012c8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801098:	8b 45 14             	mov    0x14(%ebp),%eax
  80109b:	83 c0 04             	add    $0x4,%eax
  80109e:	89 45 14             	mov    %eax,0x14(%ebp)
  8010a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a4:	83 e8 04             	sub    $0x4,%eax
  8010a7:	8b 30                	mov    (%eax),%esi
  8010a9:	85 f6                	test   %esi,%esi
  8010ab:	75 05                	jne    8010b2 <vprintfmt+0x1a6>
				p = "(null)";
  8010ad:	be 51 2c 80 00       	mov    $0x802c51,%esi
			if (width > 0 && padc != '-')
  8010b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010b6:	7e 6d                	jle    801125 <vprintfmt+0x219>
  8010b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8010bc:	74 67                	je     801125 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8010be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010c1:	83 ec 08             	sub    $0x8,%esp
  8010c4:	50                   	push   %eax
  8010c5:	56                   	push   %esi
  8010c6:	e8 0c 03 00 00       	call   8013d7 <strnlen>
  8010cb:	83 c4 10             	add    $0x10,%esp
  8010ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8010d1:	eb 16                	jmp    8010e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8010d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8010d7:	83 ec 08             	sub    $0x8,%esp
  8010da:	ff 75 0c             	pushl  0xc(%ebp)
  8010dd:	50                   	push   %eax
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	ff d0                	call   *%eax
  8010e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8010e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8010e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ed:	7f e4                	jg     8010d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010ef:	eb 34                	jmp    801125 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8010f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010f5:	74 1c                	je     801113 <vprintfmt+0x207>
  8010f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8010fa:	7e 05                	jle    801101 <vprintfmt+0x1f5>
  8010fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8010ff:	7e 12                	jle    801113 <vprintfmt+0x207>
					putch('?', putdat);
  801101:	83 ec 08             	sub    $0x8,%esp
  801104:	ff 75 0c             	pushl  0xc(%ebp)
  801107:	6a 3f                	push   $0x3f
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	ff d0                	call   *%eax
  80110e:	83 c4 10             	add    $0x10,%esp
  801111:	eb 0f                	jmp    801122 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801113:	83 ec 08             	sub    $0x8,%esp
  801116:	ff 75 0c             	pushl  0xc(%ebp)
  801119:	53                   	push   %ebx
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	ff d0                	call   *%eax
  80111f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801122:	ff 4d e4             	decl   -0x1c(%ebp)
  801125:	89 f0                	mov    %esi,%eax
  801127:	8d 70 01             	lea    0x1(%eax),%esi
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	0f be d8             	movsbl %al,%ebx
  80112f:	85 db                	test   %ebx,%ebx
  801131:	74 24                	je     801157 <vprintfmt+0x24b>
  801133:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801137:	78 b8                	js     8010f1 <vprintfmt+0x1e5>
  801139:	ff 4d e0             	decl   -0x20(%ebp)
  80113c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801140:	79 af                	jns    8010f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801142:	eb 13                	jmp    801157 <vprintfmt+0x24b>
				putch(' ', putdat);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	ff 75 0c             	pushl  0xc(%ebp)
  80114a:	6a 20                	push   $0x20
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	ff d0                	call   *%eax
  801151:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801154:	ff 4d e4             	decl   -0x1c(%ebp)
  801157:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80115b:	7f e7                	jg     801144 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80115d:	e9 66 01 00 00       	jmp    8012c8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801162:	83 ec 08             	sub    $0x8,%esp
  801165:	ff 75 e8             	pushl  -0x18(%ebp)
  801168:	8d 45 14             	lea    0x14(%ebp),%eax
  80116b:	50                   	push   %eax
  80116c:	e8 3c fd ff ff       	call   800ead <getint>
  801171:	83 c4 10             	add    $0x10,%esp
  801174:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801177:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80117a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80117d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801180:	85 d2                	test   %edx,%edx
  801182:	79 23                	jns    8011a7 <vprintfmt+0x29b>
				putch('-', putdat);
  801184:	83 ec 08             	sub    $0x8,%esp
  801187:	ff 75 0c             	pushl  0xc(%ebp)
  80118a:	6a 2d                	push   $0x2d
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	ff d0                	call   *%eax
  801191:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801197:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80119a:	f7 d8                	neg    %eax
  80119c:	83 d2 00             	adc    $0x0,%edx
  80119f:	f7 da                	neg    %edx
  8011a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8011a7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011ae:	e9 bc 00 00 00       	jmp    80126f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8011b3:	83 ec 08             	sub    $0x8,%esp
  8011b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8011b9:	8d 45 14             	lea    0x14(%ebp),%eax
  8011bc:	50                   	push   %eax
  8011bd:	e8 84 fc ff ff       	call   800e46 <getuint>
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8011cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011d2:	e9 98 00 00 00       	jmp    80126f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8011d7:	83 ec 08             	sub    $0x8,%esp
  8011da:	ff 75 0c             	pushl  0xc(%ebp)
  8011dd:	6a 58                	push   $0x58
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	ff d0                	call   *%eax
  8011e4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011e7:	83 ec 08             	sub    $0x8,%esp
  8011ea:	ff 75 0c             	pushl  0xc(%ebp)
  8011ed:	6a 58                	push   $0x58
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	ff d0                	call   *%eax
  8011f4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011f7:	83 ec 08             	sub    $0x8,%esp
  8011fa:	ff 75 0c             	pushl  0xc(%ebp)
  8011fd:	6a 58                	push   $0x58
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	ff d0                	call   *%eax
  801204:	83 c4 10             	add    $0x10,%esp
			break;
  801207:	e9 bc 00 00 00       	jmp    8012c8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80120c:	83 ec 08             	sub    $0x8,%esp
  80120f:	ff 75 0c             	pushl  0xc(%ebp)
  801212:	6a 30                	push   $0x30
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	ff d0                	call   *%eax
  801219:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80121c:	83 ec 08             	sub    $0x8,%esp
  80121f:	ff 75 0c             	pushl  0xc(%ebp)
  801222:	6a 78                	push   $0x78
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	ff d0                	call   *%eax
  801229:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	83 c0 04             	add    $0x4,%eax
  801232:	89 45 14             	mov    %eax,0x14(%ebp)
  801235:	8b 45 14             	mov    0x14(%ebp),%eax
  801238:	83 e8 04             	sub    $0x4,%eax
  80123b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80123d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801240:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801247:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80124e:	eb 1f                	jmp    80126f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801250:	83 ec 08             	sub    $0x8,%esp
  801253:	ff 75 e8             	pushl  -0x18(%ebp)
  801256:	8d 45 14             	lea    0x14(%ebp),%eax
  801259:	50                   	push   %eax
  80125a:	e8 e7 fb ff ff       	call   800e46 <getuint>
  80125f:	83 c4 10             	add    $0x10,%esp
  801262:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801265:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801268:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80126f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801273:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801276:	83 ec 04             	sub    $0x4,%esp
  801279:	52                   	push   %edx
  80127a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80127d:	50                   	push   %eax
  80127e:	ff 75 f4             	pushl  -0xc(%ebp)
  801281:	ff 75 f0             	pushl  -0x10(%ebp)
  801284:	ff 75 0c             	pushl  0xc(%ebp)
  801287:	ff 75 08             	pushl  0x8(%ebp)
  80128a:	e8 00 fb ff ff       	call   800d8f <printnum>
  80128f:	83 c4 20             	add    $0x20,%esp
			break;
  801292:	eb 34                	jmp    8012c8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801294:	83 ec 08             	sub    $0x8,%esp
  801297:	ff 75 0c             	pushl  0xc(%ebp)
  80129a:	53                   	push   %ebx
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	ff d0                	call   *%eax
  8012a0:	83 c4 10             	add    $0x10,%esp
			break;
  8012a3:	eb 23                	jmp    8012c8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012a5:	83 ec 08             	sub    $0x8,%esp
  8012a8:	ff 75 0c             	pushl  0xc(%ebp)
  8012ab:	6a 25                	push   $0x25
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	ff d0                	call   *%eax
  8012b2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012b5:	ff 4d 10             	decl   0x10(%ebp)
  8012b8:	eb 03                	jmp    8012bd <vprintfmt+0x3b1>
  8012ba:	ff 4d 10             	decl   0x10(%ebp)
  8012bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c0:	48                   	dec    %eax
  8012c1:	8a 00                	mov    (%eax),%al
  8012c3:	3c 25                	cmp    $0x25,%al
  8012c5:	75 f3                	jne    8012ba <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8012c7:	90                   	nop
		}
	}
  8012c8:	e9 47 fc ff ff       	jmp    800f14 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8012cd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8012ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012d1:	5b                   	pop    %ebx
  8012d2:	5e                   	pop    %esi
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    

008012d5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8012db:	8d 45 10             	lea    0x10(%ebp),%eax
  8012de:	83 c0 04             	add    $0x4,%eax
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8012e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ea:	50                   	push   %eax
  8012eb:	ff 75 0c             	pushl  0xc(%ebp)
  8012ee:	ff 75 08             	pushl  0x8(%ebp)
  8012f1:	e8 16 fc ff ff       	call   800f0c <vprintfmt>
  8012f6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012f9:	90                   	nop
  8012fa:	c9                   	leave  
  8012fb:	c3                   	ret    

008012fc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801302:	8b 40 08             	mov    0x8(%eax),%eax
  801305:	8d 50 01             	lea    0x1(%eax),%edx
  801308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80130e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801311:	8b 10                	mov    (%eax),%edx
  801313:	8b 45 0c             	mov    0xc(%ebp),%eax
  801316:	8b 40 04             	mov    0x4(%eax),%eax
  801319:	39 c2                	cmp    %eax,%edx
  80131b:	73 12                	jae    80132f <sprintputch+0x33>
		*b->buf++ = ch;
  80131d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801320:	8b 00                	mov    (%eax),%eax
  801322:	8d 48 01             	lea    0x1(%eax),%ecx
  801325:	8b 55 0c             	mov    0xc(%ebp),%edx
  801328:	89 0a                	mov    %ecx,(%edx)
  80132a:	8b 55 08             	mov    0x8(%ebp),%edx
  80132d:	88 10                	mov    %dl,(%eax)
}
  80132f:	90                   	nop
  801330:	5d                   	pop    %ebp
  801331:	c3                   	ret    

00801332 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80133e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801341:	8d 50 ff             	lea    -0x1(%eax),%edx
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	01 d0                	add    %edx,%eax
  801349:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80134c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801353:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801357:	74 06                	je     80135f <vsnprintf+0x2d>
  801359:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80135d:	7f 07                	jg     801366 <vsnprintf+0x34>
		return -E_INVAL;
  80135f:	b8 03 00 00 00       	mov    $0x3,%eax
  801364:	eb 20                	jmp    801386 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801366:	ff 75 14             	pushl  0x14(%ebp)
  801369:	ff 75 10             	pushl  0x10(%ebp)
  80136c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80136f:	50                   	push   %eax
  801370:	68 fc 12 80 00       	push   $0x8012fc
  801375:	e8 92 fb ff ff       	call   800f0c <vprintfmt>
  80137a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80137d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801380:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801383:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80138e:	8d 45 10             	lea    0x10(%ebp),%eax
  801391:	83 c0 04             	add    $0x4,%eax
  801394:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801397:	8b 45 10             	mov    0x10(%ebp),%eax
  80139a:	ff 75 f4             	pushl  -0xc(%ebp)
  80139d:	50                   	push   %eax
  80139e:	ff 75 0c             	pushl  0xc(%ebp)
  8013a1:	ff 75 08             	pushl  0x8(%ebp)
  8013a4:	e8 89 ff ff ff       	call   801332 <vsnprintf>
  8013a9:	83 c4 10             	add    $0x10,%esp
  8013ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8013af:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013c1:	eb 06                	jmp    8013c9 <strlen+0x15>
		n++;
  8013c3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013c6:	ff 45 08             	incl   0x8(%ebp)
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	84 c0                	test   %al,%al
  8013d0:	75 f1                	jne    8013c3 <strlen+0xf>
		n++;
	return n;
  8013d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e4:	eb 09                	jmp    8013ef <strnlen+0x18>
		n++;
  8013e6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013e9:	ff 45 08             	incl   0x8(%ebp)
  8013ec:	ff 4d 0c             	decl   0xc(%ebp)
  8013ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013f3:	74 09                	je     8013fe <strnlen+0x27>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	84 c0                	test   %al,%al
  8013fc:	75 e8                	jne    8013e6 <strnlen+0xf>
		n++;
	return n;
  8013fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80140f:	90                   	nop
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	8d 50 01             	lea    0x1(%eax),%edx
  801416:	89 55 08             	mov    %edx,0x8(%ebp)
  801419:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80141f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801422:	8a 12                	mov    (%edx),%dl
  801424:	88 10                	mov    %dl,(%eax)
  801426:	8a 00                	mov    (%eax),%al
  801428:	84 c0                	test   %al,%al
  80142a:	75 e4                	jne    801410 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80142c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80143d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801444:	eb 1f                	jmp    801465 <strncpy+0x34>
		*dst++ = *src;
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	8d 50 01             	lea    0x1(%eax),%edx
  80144c:	89 55 08             	mov    %edx,0x8(%ebp)
  80144f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801452:	8a 12                	mov    (%edx),%dl
  801454:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801456:	8b 45 0c             	mov    0xc(%ebp),%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	84 c0                	test   %al,%al
  80145d:	74 03                	je     801462 <strncpy+0x31>
			src++;
  80145f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801462:	ff 45 fc             	incl   -0x4(%ebp)
  801465:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801468:	3b 45 10             	cmp    0x10(%ebp),%eax
  80146b:	72 d9                	jb     801446 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80146d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80147e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801482:	74 30                	je     8014b4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801484:	eb 16                	jmp    80149c <strlcpy+0x2a>
			*dst++ = *src++;
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	8d 50 01             	lea    0x1(%eax),%edx
  80148c:	89 55 08             	mov    %edx,0x8(%ebp)
  80148f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801492:	8d 4a 01             	lea    0x1(%edx),%ecx
  801495:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801498:	8a 12                	mov    (%edx),%dl
  80149a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80149c:	ff 4d 10             	decl   0x10(%ebp)
  80149f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a3:	74 09                	je     8014ae <strlcpy+0x3c>
  8014a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a8:	8a 00                	mov    (%eax),%al
  8014aa:	84 c0                	test   %al,%al
  8014ac:	75 d8                	jne    801486 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ba:	29 c2                	sub    %eax,%edx
  8014bc:	89 d0                	mov    %edx,%eax
}
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014c3:	eb 06                	jmp    8014cb <strcmp+0xb>
		p++, q++;
  8014c5:	ff 45 08             	incl   0x8(%ebp)
  8014c8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	8a 00                	mov    (%eax),%al
  8014d0:	84 c0                	test   %al,%al
  8014d2:	74 0e                	je     8014e2 <strcmp+0x22>
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	8a 10                	mov    (%eax),%dl
  8014d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	38 c2                	cmp    %al,%dl
  8014e0:	74 e3                	je     8014c5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	8a 00                	mov    (%eax),%al
  8014e7:	0f b6 d0             	movzbl %al,%edx
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	0f b6 c0             	movzbl %al,%eax
  8014f2:	29 c2                	sub    %eax,%edx
  8014f4:	89 d0                	mov    %edx,%eax
}
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    

008014f8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014fb:	eb 09                	jmp    801506 <strncmp+0xe>
		n--, p++, q++;
  8014fd:	ff 4d 10             	decl   0x10(%ebp)
  801500:	ff 45 08             	incl   0x8(%ebp)
  801503:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801506:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150a:	74 17                	je     801523 <strncmp+0x2b>
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	8a 00                	mov    (%eax),%al
  801511:	84 c0                	test   %al,%al
  801513:	74 0e                	je     801523 <strncmp+0x2b>
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8a 10                	mov    (%eax),%dl
  80151a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	38 c2                	cmp    %al,%dl
  801521:	74 da                	je     8014fd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801523:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801527:	75 07                	jne    801530 <strncmp+0x38>
		return 0;
  801529:	b8 00 00 00 00       	mov    $0x0,%eax
  80152e:	eb 14                	jmp    801544 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	8a 00                	mov    (%eax),%al
  801535:	0f b6 d0             	movzbl %al,%edx
  801538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	0f b6 c0             	movzbl %al,%eax
  801540:	29 c2                	sub    %eax,%edx
  801542:	89 d0                	mov    %edx,%eax
}
  801544:	5d                   	pop    %ebp
  801545:	c3                   	ret    

00801546 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801552:	eb 12                	jmp    801566 <strchr+0x20>
		if (*s == c)
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80155c:	75 05                	jne    801563 <strchr+0x1d>
			return (char *) s;
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	eb 11                	jmp    801574 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801563:	ff 45 08             	incl   0x8(%ebp)
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8a 00                	mov    (%eax),%al
  80156b:	84 c0                	test   %al,%al
  80156d:	75 e5                	jne    801554 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80156f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	83 ec 04             	sub    $0x4,%esp
  80157c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801582:	eb 0d                	jmp    801591 <strfind+0x1b>
		if (*s == c)
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	8a 00                	mov    (%eax),%al
  801589:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80158c:	74 0e                	je     80159c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80158e:	ff 45 08             	incl   0x8(%ebp)
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	8a 00                	mov    (%eax),%al
  801596:	84 c0                	test   %al,%al
  801598:	75 ea                	jne    801584 <strfind+0xe>
  80159a:	eb 01                	jmp    80159d <strfind+0x27>
		if (*s == c)
			break;
  80159c:	90                   	nop
	return (char *) s;
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015b4:	eb 0e                	jmp    8015c4 <memset+0x22>
		*p++ = c;
  8015b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b9:	8d 50 01             	lea    0x1(%eax),%edx
  8015bc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015c4:	ff 4d f8             	decl   -0x8(%ebp)
  8015c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015cb:	79 e9                	jns    8015b6 <memset+0x14>
		*p++ = c;

	return v;
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8015e4:	eb 16                	jmp    8015fc <memcpy+0x2a>
		*d++ = *s++;
  8015e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e9:	8d 50 01             	lea    0x1(%eax),%edx
  8015ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015f5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015f8:	8a 12                	mov    (%edx),%dl
  8015fa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801602:	89 55 10             	mov    %edx,0x10(%ebp)
  801605:	85 c0                	test   %eax,%eax
  801607:	75 dd                	jne    8015e6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801614:	8b 45 0c             	mov    0xc(%ebp),%eax
  801617:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801620:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801623:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801626:	73 50                	jae    801678 <memmove+0x6a>
  801628:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162b:	8b 45 10             	mov    0x10(%ebp),%eax
  80162e:	01 d0                	add    %edx,%eax
  801630:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801633:	76 43                	jbe    801678 <memmove+0x6a>
		s += n;
  801635:	8b 45 10             	mov    0x10(%ebp),%eax
  801638:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80163b:	8b 45 10             	mov    0x10(%ebp),%eax
  80163e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801641:	eb 10                	jmp    801653 <memmove+0x45>
			*--d = *--s;
  801643:	ff 4d f8             	decl   -0x8(%ebp)
  801646:	ff 4d fc             	decl   -0x4(%ebp)
  801649:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164c:	8a 10                	mov    (%eax),%dl
  80164e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801651:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801653:	8b 45 10             	mov    0x10(%ebp),%eax
  801656:	8d 50 ff             	lea    -0x1(%eax),%edx
  801659:	89 55 10             	mov    %edx,0x10(%ebp)
  80165c:	85 c0                	test   %eax,%eax
  80165e:	75 e3                	jne    801643 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801660:	eb 23                	jmp    801685 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801662:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801665:	8d 50 01             	lea    0x1(%eax),%edx
  801668:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80166b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80166e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801671:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801674:	8a 12                	mov    (%edx),%dl
  801676:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801678:	8b 45 10             	mov    0x10(%ebp),%eax
  80167b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80167e:	89 55 10             	mov    %edx,0x10(%ebp)
  801681:	85 c0                	test   %eax,%eax
  801683:	75 dd                	jne    801662 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801696:	8b 45 0c             	mov    0xc(%ebp),%eax
  801699:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80169c:	eb 2a                	jmp    8016c8 <memcmp+0x3e>
		if (*s1 != *s2)
  80169e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a1:	8a 10                	mov    (%eax),%dl
  8016a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a6:	8a 00                	mov    (%eax),%al
  8016a8:	38 c2                	cmp    %al,%dl
  8016aa:	74 16                	je     8016c2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016af:	8a 00                	mov    (%eax),%al
  8016b1:	0f b6 d0             	movzbl %al,%edx
  8016b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b7:	8a 00                	mov    (%eax),%al
  8016b9:	0f b6 c0             	movzbl %al,%eax
  8016bc:	29 c2                	sub    %eax,%edx
  8016be:	89 d0                	mov    %edx,%eax
  8016c0:	eb 18                	jmp    8016da <memcmp+0x50>
		s1++, s2++;
  8016c2:	ff 45 fc             	incl   -0x4(%ebp)
  8016c5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8016d1:	85 c0                	test   %eax,%eax
  8016d3:	75 c9                	jne    80169e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e8:	01 d0                	add    %edx,%eax
  8016ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016ed:	eb 15                	jmp    801704 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	0f b6 d0             	movzbl %al,%edx
  8016f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fa:	0f b6 c0             	movzbl %al,%eax
  8016fd:	39 c2                	cmp    %eax,%edx
  8016ff:	74 0d                	je     80170e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801701:	ff 45 08             	incl   0x8(%ebp)
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80170a:	72 e3                	jb     8016ef <memfind+0x13>
  80170c:	eb 01                	jmp    80170f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80170e:	90                   	nop
	return (void *) s;
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80171a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801721:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801728:	eb 03                	jmp    80172d <strtol+0x19>
		s++;
  80172a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	8a 00                	mov    (%eax),%al
  801732:	3c 20                	cmp    $0x20,%al
  801734:	74 f4                	je     80172a <strtol+0x16>
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8a 00                	mov    (%eax),%al
  80173b:	3c 09                	cmp    $0x9,%al
  80173d:	74 eb                	je     80172a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8a 00                	mov    (%eax),%al
  801744:	3c 2b                	cmp    $0x2b,%al
  801746:	75 05                	jne    80174d <strtol+0x39>
		s++;
  801748:	ff 45 08             	incl   0x8(%ebp)
  80174b:	eb 13                	jmp    801760 <strtol+0x4c>
	else if (*s == '-')
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	8a 00                	mov    (%eax),%al
  801752:	3c 2d                	cmp    $0x2d,%al
  801754:	75 0a                	jne    801760 <strtol+0x4c>
		s++, neg = 1;
  801756:	ff 45 08             	incl   0x8(%ebp)
  801759:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801760:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801764:	74 06                	je     80176c <strtol+0x58>
  801766:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80176a:	75 20                	jne    80178c <strtol+0x78>
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	8a 00                	mov    (%eax),%al
  801771:	3c 30                	cmp    $0x30,%al
  801773:	75 17                	jne    80178c <strtol+0x78>
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	40                   	inc    %eax
  801779:	8a 00                	mov    (%eax),%al
  80177b:	3c 78                	cmp    $0x78,%al
  80177d:	75 0d                	jne    80178c <strtol+0x78>
		s += 2, base = 16;
  80177f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801783:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80178a:	eb 28                	jmp    8017b4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80178c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801790:	75 15                	jne    8017a7 <strtol+0x93>
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8a 00                	mov    (%eax),%al
  801797:	3c 30                	cmp    $0x30,%al
  801799:	75 0c                	jne    8017a7 <strtol+0x93>
		s++, base = 8;
  80179b:	ff 45 08             	incl   0x8(%ebp)
  80179e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017a5:	eb 0d                	jmp    8017b4 <strtol+0xa0>
	else if (base == 0)
  8017a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ab:	75 07                	jne    8017b4 <strtol+0xa0>
		base = 10;
  8017ad:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	8a 00                	mov    (%eax),%al
  8017b9:	3c 2f                	cmp    $0x2f,%al
  8017bb:	7e 19                	jle    8017d6 <strtol+0xc2>
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	8a 00                	mov    (%eax),%al
  8017c2:	3c 39                	cmp    $0x39,%al
  8017c4:	7f 10                	jg     8017d6 <strtol+0xc2>
			dig = *s - '0';
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	8a 00                	mov    (%eax),%al
  8017cb:	0f be c0             	movsbl %al,%eax
  8017ce:	83 e8 30             	sub    $0x30,%eax
  8017d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017d4:	eb 42                	jmp    801818 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	3c 60                	cmp    $0x60,%al
  8017dd:	7e 19                	jle    8017f8 <strtol+0xe4>
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8a 00                	mov    (%eax),%al
  8017e4:	3c 7a                	cmp    $0x7a,%al
  8017e6:	7f 10                	jg     8017f8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	8a 00                	mov    (%eax),%al
  8017ed:	0f be c0             	movsbl %al,%eax
  8017f0:	83 e8 57             	sub    $0x57,%eax
  8017f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f6:	eb 20                	jmp    801818 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	8a 00                	mov    (%eax),%al
  8017fd:	3c 40                	cmp    $0x40,%al
  8017ff:	7e 39                	jle    80183a <strtol+0x126>
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	8a 00                	mov    (%eax),%al
  801806:	3c 5a                	cmp    $0x5a,%al
  801808:	7f 30                	jg     80183a <strtol+0x126>
			dig = *s - 'A' + 10;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	8a 00                	mov    (%eax),%al
  80180f:	0f be c0             	movsbl %al,%eax
  801812:	83 e8 37             	sub    $0x37,%eax
  801815:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80181e:	7d 19                	jge    801839 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801820:	ff 45 08             	incl   0x8(%ebp)
  801823:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801826:	0f af 45 10          	imul   0x10(%ebp),%eax
  80182a:	89 c2                	mov    %eax,%edx
  80182c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182f:	01 d0                	add    %edx,%eax
  801831:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801834:	e9 7b ff ff ff       	jmp    8017b4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801839:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80183a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80183e:	74 08                	je     801848 <strtol+0x134>
		*endptr = (char *) s;
  801840:	8b 45 0c             	mov    0xc(%ebp),%eax
  801843:	8b 55 08             	mov    0x8(%ebp),%edx
  801846:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801848:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80184c:	74 07                	je     801855 <strtol+0x141>
  80184e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801851:	f7 d8                	neg    %eax
  801853:	eb 03                	jmp    801858 <strtol+0x144>
  801855:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <ltostr>:

void
ltostr(long value, char *str)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801860:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801867:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80186e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801872:	79 13                	jns    801887 <ltostr+0x2d>
	{
		neg = 1;
  801874:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80187b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801881:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801884:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80188f:	99                   	cltd   
  801890:	f7 f9                	idiv   %ecx
  801892:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801895:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801898:	8d 50 01             	lea    0x1(%eax),%edx
  80189b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80189e:	89 c2                	mov    %eax,%edx
  8018a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a3:	01 d0                	add    %edx,%eax
  8018a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018a8:	83 c2 30             	add    $0x30,%edx
  8018ab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018b5:	f7 e9                	imul   %ecx
  8018b7:	c1 fa 02             	sar    $0x2,%edx
  8018ba:	89 c8                	mov    %ecx,%eax
  8018bc:	c1 f8 1f             	sar    $0x1f,%eax
  8018bf:	29 c2                	sub    %eax,%edx
  8018c1:	89 d0                	mov    %edx,%eax
  8018c3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018ce:	f7 e9                	imul   %ecx
  8018d0:	c1 fa 02             	sar    $0x2,%edx
  8018d3:	89 c8                	mov    %ecx,%eax
  8018d5:	c1 f8 1f             	sar    $0x1f,%eax
  8018d8:	29 c2                	sub    %eax,%edx
  8018da:	89 d0                	mov    %edx,%eax
  8018dc:	c1 e0 02             	shl    $0x2,%eax
  8018df:	01 d0                	add    %edx,%eax
  8018e1:	01 c0                	add    %eax,%eax
  8018e3:	29 c1                	sub    %eax,%ecx
  8018e5:	89 ca                	mov    %ecx,%edx
  8018e7:	85 d2                	test   %edx,%edx
  8018e9:	75 9c                	jne    801887 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f5:	48                   	dec    %eax
  8018f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018fd:	74 3d                	je     80193c <ltostr+0xe2>
		start = 1 ;
  8018ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801906:	eb 34                	jmp    80193c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801908:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80190b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190e:	01 d0                	add    %edx,%eax
  801910:	8a 00                	mov    (%eax),%al
  801912:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801915:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191b:	01 c2                	add    %eax,%edx
  80191d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801920:	8b 45 0c             	mov    0xc(%ebp),%eax
  801923:	01 c8                	add    %ecx,%eax
  801925:	8a 00                	mov    (%eax),%al
  801927:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801929:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80192c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192f:	01 c2                	add    %eax,%edx
  801931:	8a 45 eb             	mov    -0x15(%ebp),%al
  801934:	88 02                	mov    %al,(%edx)
		start++ ;
  801936:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801939:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80193c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801942:	7c c4                	jl     801908 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801944:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194a:	01 d0                	add    %edx,%eax
  80194c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80194f:	90                   	nop
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801958:	ff 75 08             	pushl  0x8(%ebp)
  80195b:	e8 54 fa ff ff       	call   8013b4 <strlen>
  801960:	83 c4 04             	add    $0x4,%esp
  801963:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	e8 46 fa ff ff       	call   8013b4 <strlen>
  80196e:	83 c4 04             	add    $0x4,%esp
  801971:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801974:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80197b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801982:	eb 17                	jmp    80199b <strcconcat+0x49>
		final[s] = str1[s] ;
  801984:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801987:	8b 45 10             	mov    0x10(%ebp),%eax
  80198a:	01 c2                	add    %eax,%edx
  80198c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	01 c8                	add    %ecx,%eax
  801994:	8a 00                	mov    (%eax),%al
  801996:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801998:	ff 45 fc             	incl   -0x4(%ebp)
  80199b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80199e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019a1:	7c e1                	jl     801984 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019b1:	eb 1f                	jmp    8019d2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019b6:	8d 50 01             	lea    0x1(%eax),%edx
  8019b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019bc:	89 c2                	mov    %eax,%edx
  8019be:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c1:	01 c2                	add    %eax,%edx
  8019c3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c9:	01 c8                	add    %ecx,%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019cf:	ff 45 f8             	incl   -0x8(%ebp)
  8019d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019d8:	7c d9                	jl     8019b3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e0:	01 d0                	add    %edx,%eax
  8019e2:	c6 00 00             	movb   $0x0,(%eax)
}
  8019e5:	90                   	nop
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f7:	8b 00                	mov    (%eax),%eax
  8019f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a00:	8b 45 10             	mov    0x10(%ebp),%eax
  801a03:	01 d0                	add    %edx,%eax
  801a05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a0b:	eb 0c                	jmp    801a19 <strsplit+0x31>
			*string++ = 0;
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	8d 50 01             	lea    0x1(%eax),%edx
  801a13:	89 55 08             	mov    %edx,0x8(%ebp)
  801a16:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	8a 00                	mov    (%eax),%al
  801a1e:	84 c0                	test   %al,%al
  801a20:	74 18                	je     801a3a <strsplit+0x52>
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	8a 00                	mov    (%eax),%al
  801a27:	0f be c0             	movsbl %al,%eax
  801a2a:	50                   	push   %eax
  801a2b:	ff 75 0c             	pushl  0xc(%ebp)
  801a2e:	e8 13 fb ff ff       	call   801546 <strchr>
  801a33:	83 c4 08             	add    $0x8,%esp
  801a36:	85 c0                	test   %eax,%eax
  801a38:	75 d3                	jne    801a0d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8a 00                	mov    (%eax),%al
  801a3f:	84 c0                	test   %al,%al
  801a41:	74 5a                	je     801a9d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a43:	8b 45 14             	mov    0x14(%ebp),%eax
  801a46:	8b 00                	mov    (%eax),%eax
  801a48:	83 f8 0f             	cmp    $0xf,%eax
  801a4b:	75 07                	jne    801a54 <strsplit+0x6c>
		{
			return 0;
  801a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a52:	eb 66                	jmp    801aba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a54:	8b 45 14             	mov    0x14(%ebp),%eax
  801a57:	8b 00                	mov    (%eax),%eax
  801a59:	8d 48 01             	lea    0x1(%eax),%ecx
  801a5c:	8b 55 14             	mov    0x14(%ebp),%edx
  801a5f:	89 0a                	mov    %ecx,(%edx)
  801a61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a68:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6b:	01 c2                	add    %eax,%edx
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a72:	eb 03                	jmp    801a77 <strsplit+0x8f>
			string++;
  801a74:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	8a 00                	mov    (%eax),%al
  801a7c:	84 c0                	test   %al,%al
  801a7e:	74 8b                	je     801a0b <strsplit+0x23>
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	8a 00                	mov    (%eax),%al
  801a85:	0f be c0             	movsbl %al,%eax
  801a88:	50                   	push   %eax
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	e8 b5 fa ff ff       	call   801546 <strchr>
  801a91:	83 c4 08             	add    $0x8,%esp
  801a94:	85 c0                	test   %eax,%eax
  801a96:	74 dc                	je     801a74 <strsplit+0x8c>
			string++;
	}
  801a98:	e9 6e ff ff ff       	jmp    801a0b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a9d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa1:	8b 00                	mov    (%eax),%eax
  801aa3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aaa:	8b 45 10             	mov    0x10(%ebp),%eax
  801aad:	01 d0                	add    %edx,%eax
  801aaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ab5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	57                   	push   %edi
  801ac0:	56                   	push   %esi
  801ac1:	53                   	push   %ebx
  801ac2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ace:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ad4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ad7:	cd 30                	int    $0x30
  801ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801adf:	83 c4 10             	add    $0x10,%esp
  801ae2:	5b                   	pop    %ebx
  801ae3:	5e                   	pop    %esi
  801ae4:	5f                   	pop    %edi
  801ae5:	5d                   	pop    %ebp
  801ae6:	c3                   	ret    

00801ae7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	83 ec 04             	sub    $0x4,%esp
  801aed:	8b 45 10             	mov    0x10(%ebp),%eax
  801af0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801af3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	52                   	push   %edx
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	50                   	push   %eax
  801b03:	6a 00                	push   $0x0
  801b05:	e8 b2 ff ff ff       	call   801abc <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	90                   	nop
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 01                	push   $0x1
  801b1f:	e8 98 ff ff ff       	call   801abc <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	50                   	push   %eax
  801b38:	6a 05                	push   $0x5
  801b3a:	e8 7d ff ff ff       	call   801abc <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 02                	push   $0x2
  801b53:	e8 64 ff ff ff       	call   801abc <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 03                	push   $0x3
  801b6c:	e8 4b ff ff ff       	call   801abc <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 04                	push   $0x4
  801b85:	e8 32 ff ff ff       	call   801abc <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_env_exit>:


void sys_env_exit(void)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 06                	push   $0x6
  801b9e:	e8 19 ff ff ff       	call   801abc <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	90                   	nop
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801bac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	52                   	push   %edx
  801bb9:	50                   	push   %eax
  801bba:	6a 07                	push   $0x7
  801bbc:	e8 fb fe ff ff       	call   801abc <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	56                   	push   %esi
  801bca:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bcb:	8b 75 18             	mov    0x18(%ebp),%esi
  801bce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bd1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	56                   	push   %esi
  801bdb:	53                   	push   %ebx
  801bdc:	51                   	push   %ecx
  801bdd:	52                   	push   %edx
  801bde:	50                   	push   %eax
  801bdf:	6a 08                	push   $0x8
  801be1:	e8 d6 fe ff ff       	call   801abc <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bec:	5b                   	pop    %ebx
  801bed:	5e                   	pop    %esi
  801bee:	5d                   	pop    %ebp
  801bef:	c3                   	ret    

00801bf0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	52                   	push   %edx
  801c00:	50                   	push   %eax
  801c01:	6a 09                	push   $0x9
  801c03:	e8 b4 fe ff ff       	call   801abc <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	ff 75 0c             	pushl  0xc(%ebp)
  801c19:	ff 75 08             	pushl  0x8(%ebp)
  801c1c:	6a 0a                	push   $0xa
  801c1e:	e8 99 fe ff ff       	call   801abc <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 0b                	push   $0xb
  801c37:	e8 80 fe ff ff       	call   801abc <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 0c                	push   $0xc
  801c50:	e8 67 fe ff ff       	call   801abc <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 0d                	push   $0xd
  801c69:	e8 4e fe ff ff       	call   801abc <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	ff 75 0c             	pushl  0xc(%ebp)
  801c7f:	ff 75 08             	pushl  0x8(%ebp)
  801c82:	6a 11                	push   $0x11
  801c84:	e8 33 fe ff ff       	call   801abc <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
	return;
  801c8c:	90                   	nop
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	ff 75 08             	pushl  0x8(%ebp)
  801c9e:	6a 12                	push   $0x12
  801ca0:	e8 17 fe ff ff       	call   801abc <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca8:	90                   	nop
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 0e                	push   $0xe
  801cba:	e8 fd fd ff ff       	call   801abc <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	ff 75 08             	pushl  0x8(%ebp)
  801cd2:	6a 0f                	push   $0xf
  801cd4:	e8 e3 fd ff ff       	call   801abc <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 10                	push   $0x10
  801ced:	e8 ca fd ff ff       	call   801abc <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	90                   	nop
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 14                	push   $0x14
  801d07:	e8 b0 fd ff ff       	call   801abc <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	90                   	nop
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 15                	push   $0x15
  801d21:	e8 96 fd ff ff       	call   801abc <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
}
  801d29:	90                   	nop
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <sys_cputc>:


void
sys_cputc(const char c)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	83 ec 04             	sub    $0x4,%esp
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
  801d35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d38:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	50                   	push   %eax
  801d45:	6a 16                	push   $0x16
  801d47:	e8 70 fd ff ff       	call   801abc <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
}
  801d4f:	90                   	nop
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 17                	push   $0x17
  801d61:	e8 56 fd ff ff       	call   801abc <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	90                   	nop
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	ff 75 0c             	pushl  0xc(%ebp)
  801d7b:	50                   	push   %eax
  801d7c:	6a 18                	push   $0x18
  801d7e:	e8 39 fd ff ff       	call   801abc <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	52                   	push   %edx
  801d98:	50                   	push   %eax
  801d99:	6a 1b                	push   $0x1b
  801d9b:	e8 1c fd ff ff       	call   801abc <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801da8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	52                   	push   %edx
  801db5:	50                   	push   %eax
  801db6:	6a 19                	push   $0x19
  801db8:	e8 ff fc ff ff       	call   801abc <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	90                   	nop
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	52                   	push   %edx
  801dd3:	50                   	push   %eax
  801dd4:	6a 1a                	push   $0x1a
  801dd6:	e8 e1 fc ff ff       	call   801abc <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
}
  801dde:	90                   	nop
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 04             	sub    $0x4,%esp
  801de7:	8b 45 10             	mov    0x10(%ebp),%eax
  801dea:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ded:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801df0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	6a 00                	push   $0x0
  801df9:	51                   	push   %ecx
  801dfa:	52                   	push   %edx
  801dfb:	ff 75 0c             	pushl  0xc(%ebp)
  801dfe:	50                   	push   %eax
  801dff:	6a 1c                	push   $0x1c
  801e01:	e8 b6 fc ff ff       	call   801abc <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	52                   	push   %edx
  801e1b:	50                   	push   %eax
  801e1c:	6a 1d                	push   $0x1d
  801e1e:	e8 99 fc ff ff       	call   801abc <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	51                   	push   %ecx
  801e39:	52                   	push   %edx
  801e3a:	50                   	push   %eax
  801e3b:	6a 1e                	push   $0x1e
  801e3d:	e8 7a fc ff ff       	call   801abc <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	52                   	push   %edx
  801e57:	50                   	push   %eax
  801e58:	6a 1f                	push   $0x1f
  801e5a:	e8 5d fc ff ff       	call   801abc <syscall>
  801e5f:	83 c4 18             	add    $0x18,%esp
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 20                	push   $0x20
  801e73:	e8 44 fc ff ff       	call   801abc <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	ff 75 10             	pushl  0x10(%ebp)
  801e8a:	ff 75 0c             	pushl  0xc(%ebp)
  801e8d:	50                   	push   %eax
  801e8e:	6a 21                	push   $0x21
  801e90:	e8 27 fc ff ff       	call   801abc <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	50                   	push   %eax
  801ea9:	6a 22                	push   $0x22
  801eab:	e8 0c fc ff ff       	call   801abc <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
}
  801eb3:	90                   	nop
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	50                   	push   %eax
  801ec5:	6a 23                	push   $0x23
  801ec7:	e8 f0 fb ff ff       	call   801abc <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
}
  801ecf:	90                   	nop
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ed8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801edb:	8d 50 04             	lea    0x4(%eax),%edx
  801ede:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	52                   	push   %edx
  801ee8:	50                   	push   %eax
  801ee9:	6a 24                	push   $0x24
  801eeb:	e8 cc fb ff ff       	call   801abc <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
	return result;
  801ef3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ef9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801efc:	89 01                	mov    %eax,(%ecx)
  801efe:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	c9                   	leave  
  801f05:	c2 04 00             	ret    $0x4

00801f08 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	ff 75 10             	pushl  0x10(%ebp)
  801f12:	ff 75 0c             	pushl  0xc(%ebp)
  801f15:	ff 75 08             	pushl  0x8(%ebp)
  801f18:	6a 13                	push   $0x13
  801f1a:	e8 9d fb ff ff       	call   801abc <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f22:	90                   	nop
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 25                	push   $0x25
  801f34:	e8 83 fb ff ff       	call   801abc <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 04             	sub    $0x4,%esp
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f4a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	50                   	push   %eax
  801f57:	6a 26                	push   $0x26
  801f59:	e8 5e fb ff ff       	call   801abc <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f61:	90                   	nop
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <rsttst>:
void rsttst()
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 28                	push   $0x28
  801f73:	e8 44 fb ff ff       	call   801abc <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7b:	90                   	nop
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	83 ec 04             	sub    $0x4,%esp
  801f84:	8b 45 14             	mov    0x14(%ebp),%eax
  801f87:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f8a:	8b 55 18             	mov    0x18(%ebp),%edx
  801f8d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f91:	52                   	push   %edx
  801f92:	50                   	push   %eax
  801f93:	ff 75 10             	pushl  0x10(%ebp)
  801f96:	ff 75 0c             	pushl  0xc(%ebp)
  801f99:	ff 75 08             	pushl  0x8(%ebp)
  801f9c:	6a 27                	push   $0x27
  801f9e:	e8 19 fb ff ff       	call   801abc <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa6:	90                   	nop
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <chktst>:
void chktst(uint32 n)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	ff 75 08             	pushl  0x8(%ebp)
  801fb7:	6a 29                	push   $0x29
  801fb9:	e8 fe fa ff ff       	call   801abc <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc1:	90                   	nop
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <inctst>:

void inctst()
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 2a                	push   $0x2a
  801fd3:	e8 e4 fa ff ff       	call   801abc <syscall>
  801fd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801fdb:	90                   	nop
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <gettst>:
uint32 gettst()
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 2b                	push   $0x2b
  801fed:	e8 ca fa ff ff       	call   801abc <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 2c                	push   $0x2c
  802009:	e8 ae fa ff ff       	call   801abc <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
  802011:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802014:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802018:	75 07                	jne    802021 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80201a:	b8 01 00 00 00       	mov    $0x1,%eax
  80201f:	eb 05                	jmp    802026 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802021:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 2c                	push   $0x2c
  80203a:	e8 7d fa ff ff       	call   801abc <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
  802042:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802045:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802049:	75 07                	jne    802052 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80204b:	b8 01 00 00 00       	mov    $0x1,%eax
  802050:	eb 05                	jmp    802057 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 2c                	push   $0x2c
  80206b:	e8 4c fa ff ff       	call   801abc <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
  802073:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802076:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80207a:	75 07                	jne    802083 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80207c:	b8 01 00 00 00       	mov    $0x1,%eax
  802081:	eb 05                	jmp    802088 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802083:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 2c                	push   $0x2c
  80209c:	e8 1b fa ff ff       	call   801abc <syscall>
  8020a1:	83 c4 18             	add    $0x18,%esp
  8020a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020a7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020ab:	75 07                	jne    8020b4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b2:	eb 05                	jmp    8020b9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	ff 75 08             	pushl  0x8(%ebp)
  8020c9:	6a 2d                	push   $0x2d
  8020cb:	e8 ec f9 ff ff       	call   801abc <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d3:	90                   	nop
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	6a 00                	push   $0x0
  8020e8:	53                   	push   %ebx
  8020e9:	51                   	push   %ecx
  8020ea:	52                   	push   %edx
  8020eb:	50                   	push   %eax
  8020ec:	6a 2e                	push   $0x2e
  8020ee:	e8 c9 f9 ff ff       	call   801abc <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
}
  8020f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	52                   	push   %edx
  80210b:	50                   	push   %eax
  80210c:	6a 2f                	push   $0x2f
  80210e:	e8 a9 f9 ff ff       	call   801abc <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80211e:	8b 55 08             	mov    0x8(%ebp),%edx
  802121:	89 d0                	mov    %edx,%eax
  802123:	c1 e0 02             	shl    $0x2,%eax
  802126:	01 d0                	add    %edx,%eax
  802128:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80212f:	01 d0                	add    %edx,%eax
  802131:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802138:	01 d0                	add    %edx,%eax
  80213a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802141:	01 d0                	add    %edx,%eax
  802143:	c1 e0 04             	shl    $0x4,%eax
  802146:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802149:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802150:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802153:	83 ec 0c             	sub    $0xc,%esp
  802156:	50                   	push   %eax
  802157:	e8 76 fd ff ff       	call   801ed2 <sys_get_virtual_time>
  80215c:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80215f:	eb 41                	jmp    8021a2 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802161:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802164:	83 ec 0c             	sub    $0xc,%esp
  802167:	50                   	push   %eax
  802168:	e8 65 fd ff ff       	call   801ed2 <sys_get_virtual_time>
  80216d:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802170:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802173:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802176:	29 c2                	sub    %eax,%edx
  802178:	89 d0                	mov    %edx,%eax
  80217a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80217d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802180:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802183:	89 d1                	mov    %edx,%ecx
  802185:	29 c1                	sub    %eax,%ecx
  802187:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80218a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80218d:	39 c2                	cmp    %eax,%edx
  80218f:	0f 97 c0             	seta   %al
  802192:	0f b6 c0             	movzbl %al,%eax
  802195:	29 c1                	sub    %eax,%ecx
  802197:	89 c8                	mov    %ecx,%eax
  802199:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80219c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80219f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8021a8:	72 b7                	jb     802161 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8021aa:	90                   	nop
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8021b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8021ba:	eb 03                	jmp    8021bf <busy_wait+0x12>
  8021bc:	ff 45 fc             	incl   -0x4(%ebp)
  8021bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021c5:	72 f5                	jb     8021bc <busy_wait+0xf>
	return i;
  8021c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021ca:	c9                   	leave  
  8021cb:	c3                   	ret    

008021cc <__udivdi3>:
  8021cc:	55                   	push   %ebp
  8021cd:	57                   	push   %edi
  8021ce:	56                   	push   %esi
  8021cf:	53                   	push   %ebx
  8021d0:	83 ec 1c             	sub    $0x1c,%esp
  8021d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8021d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021e3:	89 ca                	mov    %ecx,%edx
  8021e5:	89 f8                	mov    %edi,%eax
  8021e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8021eb:	85 f6                	test   %esi,%esi
  8021ed:	75 2d                	jne    80221c <__udivdi3+0x50>
  8021ef:	39 cf                	cmp    %ecx,%edi
  8021f1:	77 65                	ja     802258 <__udivdi3+0x8c>
  8021f3:	89 fd                	mov    %edi,%ebp
  8021f5:	85 ff                	test   %edi,%edi
  8021f7:	75 0b                	jne    802204 <__udivdi3+0x38>
  8021f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fe:	31 d2                	xor    %edx,%edx
  802200:	f7 f7                	div    %edi
  802202:	89 c5                	mov    %eax,%ebp
  802204:	31 d2                	xor    %edx,%edx
  802206:	89 c8                	mov    %ecx,%eax
  802208:	f7 f5                	div    %ebp
  80220a:	89 c1                	mov    %eax,%ecx
  80220c:	89 d8                	mov    %ebx,%eax
  80220e:	f7 f5                	div    %ebp
  802210:	89 cf                	mov    %ecx,%edi
  802212:	89 fa                	mov    %edi,%edx
  802214:	83 c4 1c             	add    $0x1c,%esp
  802217:	5b                   	pop    %ebx
  802218:	5e                   	pop    %esi
  802219:	5f                   	pop    %edi
  80221a:	5d                   	pop    %ebp
  80221b:	c3                   	ret    
  80221c:	39 ce                	cmp    %ecx,%esi
  80221e:	77 28                	ja     802248 <__udivdi3+0x7c>
  802220:	0f bd fe             	bsr    %esi,%edi
  802223:	83 f7 1f             	xor    $0x1f,%edi
  802226:	75 40                	jne    802268 <__udivdi3+0x9c>
  802228:	39 ce                	cmp    %ecx,%esi
  80222a:	72 0a                	jb     802236 <__udivdi3+0x6a>
  80222c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802230:	0f 87 9e 00 00 00    	ja     8022d4 <__udivdi3+0x108>
  802236:	b8 01 00 00 00       	mov    $0x1,%eax
  80223b:	89 fa                	mov    %edi,%edx
  80223d:	83 c4 1c             	add    $0x1c,%esp
  802240:	5b                   	pop    %ebx
  802241:	5e                   	pop    %esi
  802242:	5f                   	pop    %edi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    
  802245:	8d 76 00             	lea    0x0(%esi),%esi
  802248:	31 ff                	xor    %edi,%edi
  80224a:	31 c0                	xor    %eax,%eax
  80224c:	89 fa                	mov    %edi,%edx
  80224e:	83 c4 1c             	add    $0x1c,%esp
  802251:	5b                   	pop    %ebx
  802252:	5e                   	pop    %esi
  802253:	5f                   	pop    %edi
  802254:	5d                   	pop    %ebp
  802255:	c3                   	ret    
  802256:	66 90                	xchg   %ax,%ax
  802258:	89 d8                	mov    %ebx,%eax
  80225a:	f7 f7                	div    %edi
  80225c:	31 ff                	xor    %edi,%edi
  80225e:	89 fa                	mov    %edi,%edx
  802260:	83 c4 1c             	add    $0x1c,%esp
  802263:	5b                   	pop    %ebx
  802264:	5e                   	pop    %esi
  802265:	5f                   	pop    %edi
  802266:	5d                   	pop    %ebp
  802267:	c3                   	ret    
  802268:	bd 20 00 00 00       	mov    $0x20,%ebp
  80226d:	89 eb                	mov    %ebp,%ebx
  80226f:	29 fb                	sub    %edi,%ebx
  802271:	89 f9                	mov    %edi,%ecx
  802273:	d3 e6                	shl    %cl,%esi
  802275:	89 c5                	mov    %eax,%ebp
  802277:	88 d9                	mov    %bl,%cl
  802279:	d3 ed                	shr    %cl,%ebp
  80227b:	89 e9                	mov    %ebp,%ecx
  80227d:	09 f1                	or     %esi,%ecx
  80227f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802283:	89 f9                	mov    %edi,%ecx
  802285:	d3 e0                	shl    %cl,%eax
  802287:	89 c5                	mov    %eax,%ebp
  802289:	89 d6                	mov    %edx,%esi
  80228b:	88 d9                	mov    %bl,%cl
  80228d:	d3 ee                	shr    %cl,%esi
  80228f:	89 f9                	mov    %edi,%ecx
  802291:	d3 e2                	shl    %cl,%edx
  802293:	8b 44 24 08          	mov    0x8(%esp),%eax
  802297:	88 d9                	mov    %bl,%cl
  802299:	d3 e8                	shr    %cl,%eax
  80229b:	09 c2                	or     %eax,%edx
  80229d:	89 d0                	mov    %edx,%eax
  80229f:	89 f2                	mov    %esi,%edx
  8022a1:	f7 74 24 0c          	divl   0xc(%esp)
  8022a5:	89 d6                	mov    %edx,%esi
  8022a7:	89 c3                	mov    %eax,%ebx
  8022a9:	f7 e5                	mul    %ebp
  8022ab:	39 d6                	cmp    %edx,%esi
  8022ad:	72 19                	jb     8022c8 <__udivdi3+0xfc>
  8022af:	74 0b                	je     8022bc <__udivdi3+0xf0>
  8022b1:	89 d8                	mov    %ebx,%eax
  8022b3:	31 ff                	xor    %edi,%edi
  8022b5:	e9 58 ff ff ff       	jmp    802212 <__udivdi3+0x46>
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022c0:	89 f9                	mov    %edi,%ecx
  8022c2:	d3 e2                	shl    %cl,%edx
  8022c4:	39 c2                	cmp    %eax,%edx
  8022c6:	73 e9                	jae    8022b1 <__udivdi3+0xe5>
  8022c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022cb:	31 ff                	xor    %edi,%edi
  8022cd:	e9 40 ff ff ff       	jmp    802212 <__udivdi3+0x46>
  8022d2:	66 90                	xchg   %ax,%ax
  8022d4:	31 c0                	xor    %eax,%eax
  8022d6:	e9 37 ff ff ff       	jmp    802212 <__udivdi3+0x46>
  8022db:	90                   	nop

008022dc <__umoddi3>:
  8022dc:	55                   	push   %ebp
  8022dd:	57                   	push   %edi
  8022de:	56                   	push   %esi
  8022df:	53                   	push   %ebx
  8022e0:	83 ec 1c             	sub    $0x1c,%esp
  8022e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8022e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022fb:	89 f3                	mov    %esi,%ebx
  8022fd:	89 fa                	mov    %edi,%edx
  8022ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802303:	89 34 24             	mov    %esi,(%esp)
  802306:	85 c0                	test   %eax,%eax
  802308:	75 1a                	jne    802324 <__umoddi3+0x48>
  80230a:	39 f7                	cmp    %esi,%edi
  80230c:	0f 86 a2 00 00 00    	jbe    8023b4 <__umoddi3+0xd8>
  802312:	89 c8                	mov    %ecx,%eax
  802314:	89 f2                	mov    %esi,%edx
  802316:	f7 f7                	div    %edi
  802318:	89 d0                	mov    %edx,%eax
  80231a:	31 d2                	xor    %edx,%edx
  80231c:	83 c4 1c             	add    $0x1c,%esp
  80231f:	5b                   	pop    %ebx
  802320:	5e                   	pop    %esi
  802321:	5f                   	pop    %edi
  802322:	5d                   	pop    %ebp
  802323:	c3                   	ret    
  802324:	39 f0                	cmp    %esi,%eax
  802326:	0f 87 ac 00 00 00    	ja     8023d8 <__umoddi3+0xfc>
  80232c:	0f bd e8             	bsr    %eax,%ebp
  80232f:	83 f5 1f             	xor    $0x1f,%ebp
  802332:	0f 84 ac 00 00 00    	je     8023e4 <__umoddi3+0x108>
  802338:	bf 20 00 00 00       	mov    $0x20,%edi
  80233d:	29 ef                	sub    %ebp,%edi
  80233f:	89 fe                	mov    %edi,%esi
  802341:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802345:	89 e9                	mov    %ebp,%ecx
  802347:	d3 e0                	shl    %cl,%eax
  802349:	89 d7                	mov    %edx,%edi
  80234b:	89 f1                	mov    %esi,%ecx
  80234d:	d3 ef                	shr    %cl,%edi
  80234f:	09 c7                	or     %eax,%edi
  802351:	89 e9                	mov    %ebp,%ecx
  802353:	d3 e2                	shl    %cl,%edx
  802355:	89 14 24             	mov    %edx,(%esp)
  802358:	89 d8                	mov    %ebx,%eax
  80235a:	d3 e0                	shl    %cl,%eax
  80235c:	89 c2                	mov    %eax,%edx
  80235e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802362:	d3 e0                	shl    %cl,%eax
  802364:	89 44 24 04          	mov    %eax,0x4(%esp)
  802368:	8b 44 24 08          	mov    0x8(%esp),%eax
  80236c:	89 f1                	mov    %esi,%ecx
  80236e:	d3 e8                	shr    %cl,%eax
  802370:	09 d0                	or     %edx,%eax
  802372:	d3 eb                	shr    %cl,%ebx
  802374:	89 da                	mov    %ebx,%edx
  802376:	f7 f7                	div    %edi
  802378:	89 d3                	mov    %edx,%ebx
  80237a:	f7 24 24             	mull   (%esp)
  80237d:	89 c6                	mov    %eax,%esi
  80237f:	89 d1                	mov    %edx,%ecx
  802381:	39 d3                	cmp    %edx,%ebx
  802383:	0f 82 87 00 00 00    	jb     802410 <__umoddi3+0x134>
  802389:	0f 84 91 00 00 00    	je     802420 <__umoddi3+0x144>
  80238f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802393:	29 f2                	sub    %esi,%edx
  802395:	19 cb                	sbb    %ecx,%ebx
  802397:	89 d8                	mov    %ebx,%eax
  802399:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80239d:	d3 e0                	shl    %cl,%eax
  80239f:	89 e9                	mov    %ebp,%ecx
  8023a1:	d3 ea                	shr    %cl,%edx
  8023a3:	09 d0                	or     %edx,%eax
  8023a5:	89 e9                	mov    %ebp,%ecx
  8023a7:	d3 eb                	shr    %cl,%ebx
  8023a9:	89 da                	mov    %ebx,%edx
  8023ab:	83 c4 1c             	add    $0x1c,%esp
  8023ae:	5b                   	pop    %ebx
  8023af:	5e                   	pop    %esi
  8023b0:	5f                   	pop    %edi
  8023b1:	5d                   	pop    %ebp
  8023b2:	c3                   	ret    
  8023b3:	90                   	nop
  8023b4:	89 fd                	mov    %edi,%ebp
  8023b6:	85 ff                	test   %edi,%edi
  8023b8:	75 0b                	jne    8023c5 <__umoddi3+0xe9>
  8023ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bf:	31 d2                	xor    %edx,%edx
  8023c1:	f7 f7                	div    %edi
  8023c3:	89 c5                	mov    %eax,%ebp
  8023c5:	89 f0                	mov    %esi,%eax
  8023c7:	31 d2                	xor    %edx,%edx
  8023c9:	f7 f5                	div    %ebp
  8023cb:	89 c8                	mov    %ecx,%eax
  8023cd:	f7 f5                	div    %ebp
  8023cf:	89 d0                	mov    %edx,%eax
  8023d1:	e9 44 ff ff ff       	jmp    80231a <__umoddi3+0x3e>
  8023d6:	66 90                	xchg   %ax,%ax
  8023d8:	89 c8                	mov    %ecx,%eax
  8023da:	89 f2                	mov    %esi,%edx
  8023dc:	83 c4 1c             	add    $0x1c,%esp
  8023df:	5b                   	pop    %ebx
  8023e0:	5e                   	pop    %esi
  8023e1:	5f                   	pop    %edi
  8023e2:	5d                   	pop    %ebp
  8023e3:	c3                   	ret    
  8023e4:	3b 04 24             	cmp    (%esp),%eax
  8023e7:	72 06                	jb     8023ef <__umoddi3+0x113>
  8023e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8023ed:	77 0f                	ja     8023fe <__umoddi3+0x122>
  8023ef:	89 f2                	mov    %esi,%edx
  8023f1:	29 f9                	sub    %edi,%ecx
  8023f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8023f7:	89 14 24             	mov    %edx,(%esp)
  8023fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  802402:	8b 14 24             	mov    (%esp),%edx
  802405:	83 c4 1c             	add    $0x1c,%esp
  802408:	5b                   	pop    %ebx
  802409:	5e                   	pop    %esi
  80240a:	5f                   	pop    %edi
  80240b:	5d                   	pop    %ebp
  80240c:	c3                   	ret    
  80240d:	8d 76 00             	lea    0x0(%esi),%esi
  802410:	2b 04 24             	sub    (%esp),%eax
  802413:	19 fa                	sbb    %edi,%edx
  802415:	89 d1                	mov    %edx,%ecx
  802417:	89 c6                	mov    %eax,%esi
  802419:	e9 71 ff ff ff       	jmp    80238f <__umoddi3+0xb3>
  80241e:	66 90                	xchg   %ax,%ax
  802420:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802424:	72 ea                	jb     802410 <__umoddi3+0x134>
  802426:	89 d9                	mov    %ebx,%ecx
  802428:	e9 62 ff ff ff       	jmp    80238f <__umoddi3+0xb3>
