
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 f6 02 00 00       	call   80032c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 23                	jmp    80006f <_main+0x37>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
  800051:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	c1 e2 04             	shl    $0x4,%edx
  80005d:	01 d0                	add    %edx,%eax
  80005f:	8a 40 04             	mov    0x4(%eax),%al
  800062:	84 c0                	test   %al,%al
  800064:	74 06                	je     80006c <_main+0x34>
			{
				fullWS = 0;
  800066:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006a:	eb 12                	jmp    80007e <_main+0x46>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006c:	ff 45 f0             	incl   -0x10(%ebp)
  80006f:	a1 20 30 80 00       	mov    0x803020,%eax
  800074:	8b 50 74             	mov    0x74(%eax),%edx
  800077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	77 ce                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007e:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800082:	74 14                	je     800098 <_main+0x60>
  800084:	83 ec 04             	sub    $0x4,%esp
  800087:	68 c0 1e 80 00       	push   $0x801ec0
  80008c:	6a 13                	push   $0x13
  80008e:	68 dc 1e 80 00       	push   $0x801edc
  800093:	e8 d9 03 00 00       	call   800471 <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  800098:	e8 14 16 00 00       	call   8016b1 <sys_calculate_free_frames>
  80009d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	6a 00                	push   $0x0
  8000a5:	6a 04                	push   $0x4
  8000a7:	68 f7 1e 80 00       	push   $0x801ef7
  8000ac:	e8 06 14 00 00       	call   8014b7 <smalloc>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000b7:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000be:	74 14                	je     8000d4 <_main+0x9c>
  8000c0:	83 ec 04             	sub    $0x4,%esp
  8000c3:	68 fc 1e 80 00       	push   $0x801efc
  8000c8:	6a 1a                	push   $0x1a
  8000ca:	68 dc 1e 80 00       	push   $0x801edc
  8000cf:	e8 9d 03 00 00       	call   800471 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000d4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d7:	e8 d5 15 00 00       	call   8016b1 <sys_calculate_free_frames>
  8000dc:	29 c3                	sub    %eax,%ebx
  8000de:	89 d8                	mov    %ebx,%eax
  8000e0:	83 f8 04             	cmp    $0x4,%eax
  8000e3:	74 14                	je     8000f9 <_main+0xc1>
  8000e5:	83 ec 04             	sub    $0x4,%esp
  8000e8:	68 60 1f 80 00       	push   $0x801f60
  8000ed:	6a 1b                	push   $0x1b
  8000ef:	68 dc 1e 80 00       	push   $0x801edc
  8000f4:	e8 78 03 00 00       	call   800471 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  8000f9:	e8 b3 15 00 00       	call   8016b1 <sys_calculate_free_frames>
  8000fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800101:	83 ec 04             	sub    $0x4,%esp
  800104:	6a 00                	push   $0x0
  800106:	6a 04                	push   $0x4
  800108:	68 e8 1f 80 00       	push   $0x801fe8
  80010d:	e8 a5 13 00 00       	call   8014b7 <smalloc>
  800112:	83 c4 10             	add    $0x10,%esp
  800115:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800118:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  80011f:	74 14                	je     800135 <_main+0xfd>
  800121:	83 ec 04             	sub    $0x4,%esp
  800124:	68 fc 1e 80 00       	push   $0x801efc
  800129:	6a 20                	push   $0x20
  80012b:	68 dc 1e 80 00       	push   $0x801edc
  800130:	e8 3c 03 00 00       	call   800471 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800135:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800138:	e8 74 15 00 00       	call   8016b1 <sys_calculate_free_frames>
  80013d:	29 c3                	sub    %eax,%ebx
  80013f:	89 d8                	mov    %ebx,%eax
  800141:	83 f8 03             	cmp    $0x3,%eax
  800144:	74 14                	je     80015a <_main+0x122>
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	68 60 1f 80 00       	push   $0x801f60
  80014e:	6a 21                	push   $0x21
  800150:	68 dc 1e 80 00       	push   $0x801edc
  800155:	e8 17 03 00 00       	call   800471 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  80015a:	e8 52 15 00 00       	call   8016b1 <sys_calculate_free_frames>
  80015f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	6a 01                	push   $0x1
  800167:	6a 04                	push   $0x4
  800169:	68 ea 1f 80 00       	push   $0x801fea
  80016e:	e8 44 13 00 00       	call   8014b7 <smalloc>
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800179:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800180:	74 14                	je     800196 <_main+0x15e>
  800182:	83 ec 04             	sub    $0x4,%esp
  800185:	68 fc 1e 80 00       	push   $0x801efc
  80018a:	6a 26                	push   $0x26
  80018c:	68 dc 1e 80 00       	push   $0x801edc
  800191:	e8 db 02 00 00       	call   800471 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800196:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800199:	e8 13 15 00 00       	call   8016b1 <sys_calculate_free_frames>
  80019e:	29 c3                	sub    %eax,%ebx
  8001a0:	89 d8                	mov    %ebx,%eax
  8001a2:	83 f8 03             	cmp    $0x3,%eax
  8001a5:	74 14                	je     8001bb <_main+0x183>
  8001a7:	83 ec 04             	sub    $0x4,%esp
  8001aa:	68 60 1f 80 00       	push   $0x801f60
  8001af:	6a 27                	push   $0x27
  8001b1:	68 dc 1e 80 00       	push   $0x801edc
  8001b6:	e8 b6 02 00 00       	call   800471 <_panic>

	*x = 10 ;
  8001bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001be:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c7:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d2:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8001d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001dd:	8b 40 74             	mov    0x74(%eax),%eax
  8001e0:	83 ec 04             	sub    $0x4,%esp
  8001e3:	52                   	push   %edx
  8001e4:	50                   	push   %eax
  8001e5:	68 ec 1f 80 00       	push   $0x801fec
  8001ea:	e8 17 17 00 00       	call   801906 <sys_create_env>
  8001ef:	83 c4 10             	add    $0x10,%esp
  8001f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fa:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800200:	a1 20 30 80 00       	mov    0x803020,%eax
  800205:	8b 40 74             	mov    0x74(%eax),%eax
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 ec 1f 80 00       	push   $0x801fec
  800212:	e8 ef 16 00 00       	call   801906 <sys_create_env>
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  80021d:	a1 20 30 80 00       	mov    0x803020,%eax
  800222:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800228:	a1 20 30 80 00       	mov    0x803020,%eax
  80022d:	8b 40 74             	mov    0x74(%eax),%eax
  800230:	83 ec 04             	sub    $0x4,%esp
  800233:	52                   	push   %edx
  800234:	50                   	push   %eax
  800235:	68 ec 1f 80 00       	push   $0x801fec
  80023a:	e8 c7 16 00 00       	call   801906 <sys_create_env>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800245:	e8 a3 17 00 00       	call   8019ed <rsttst>

	sys_run_env(id1);
  80024a:	83 ec 0c             	sub    $0xc,%esp
  80024d:	ff 75 dc             	pushl  -0x24(%ebp)
  800250:	e8 ce 16 00 00       	call   801923 <sys_run_env>
  800255:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	ff 75 d8             	pushl  -0x28(%ebp)
  80025e:	e8 c0 16 00 00       	call   801923 <sys_run_env>
  800263:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	ff 75 d4             	pushl  -0x2c(%ebp)
  80026c:	e8 b2 16 00 00       	call   801923 <sys_run_env>
  800271:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	68 e0 2e 00 00       	push   $0x2ee0
  80027c:	e8 20 19 00 00       	call   801ba1 <env_sleep>
  800281:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  800284:	e8 de 17 00 00       	call   801a67 <gettst>
  800289:	83 f8 03             	cmp    $0x3,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 f7 1f 80 00       	push   $0x801ff7
  800296:	6a 3b                	push   $0x3b
  800298:	68 dc 1e 80 00       	push   $0x801edc
  80029d:	e8 cf 01 00 00       	call   800471 <_panic>


	if (*z != 30)
  8002a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a5:	8b 00                	mov    (%eax),%eax
  8002a7:	83 f8 1e             	cmp    $0x1e,%eax
  8002aa:	74 14                	je     8002c0 <_main+0x288>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 04 20 80 00       	push   $0x802004
  8002b4:	6a 3f                	push   $0x3f
  8002b6:	68 dc 1e 80 00       	push   $0x801edc
  8002bb:	e8 b1 01 00 00       	call   800471 <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	68 50 20 80 00       	push   $0x802050
  8002c8:	e8 46 04 00 00       	call   800713 <cprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 ac 20 80 00       	push   $0x8020ac
  8002d8:	e8 36 04 00 00       	call   800713 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e5:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8002eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f0:	8b 40 74             	mov    0x74(%eax),%eax
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	52                   	push   %edx
  8002f7:	50                   	push   %eax
  8002f8:	68 07 21 80 00       	push   $0x802107
  8002fd:	e8 04 16 00 00       	call   801906 <sys_create_env>
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 b8 0b 00 00       	push   $0xbb8
  800310:	e8 8c 18 00 00       	call   801ba1 <env_sleep>
  800315:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	ff 75 dc             	pushl  -0x24(%ebp)
  80031e:	e8 00 16 00 00       	call   801923 <sys_run_env>
  800323:	83 c4 10             	add    $0x10,%esp

	return;
  800326:	90                   	nop
}
  800327:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80032a:	c9                   	leave  
  80032b:	c3                   	ret    

0080032c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800332:	e8 af 12 00 00       	call   8015e6 <sys_getenvindex>
  800337:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80033a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80033d:	89 d0                	mov    %edx,%eax
  80033f:	c1 e0 03             	shl    $0x3,%eax
  800342:	01 d0                	add    %edx,%eax
  800344:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80034b:	01 c8                	add    %ecx,%eax
  80034d:	01 c0                	add    %eax,%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	01 c0                	add    %eax,%eax
  800353:	01 d0                	add    %edx,%eax
  800355:	89 c2                	mov    %eax,%edx
  800357:	c1 e2 05             	shl    $0x5,%edx
  80035a:	29 c2                	sub    %eax,%edx
  80035c:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800363:	89 c2                	mov    %eax,%edx
  800365:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80036b:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800370:	a1 20 30 80 00       	mov    0x803020,%eax
  800375:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80037b:	84 c0                	test   %al,%al
  80037d:	74 0f                	je     80038e <libmain+0x62>
		binaryname = myEnv->prog_name;
  80037f:	a1 20 30 80 00       	mov    0x803020,%eax
  800384:	05 40 3c 01 00       	add    $0x13c40,%eax
  800389:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80038e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800392:	7e 0a                	jle    80039e <libmain+0x72>
		binaryname = argv[0];
  800394:	8b 45 0c             	mov    0xc(%ebp),%eax
  800397:	8b 00                	mov    (%eax),%eax
  800399:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	ff 75 0c             	pushl  0xc(%ebp)
  8003a4:	ff 75 08             	pushl  0x8(%ebp)
  8003a7:	e8 8c fc ff ff       	call   800038 <_main>
  8003ac:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003af:	e8 cd 13 00 00       	call   801781 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 2c 21 80 00       	push   $0x80212c
  8003bc:	e8 52 03 00 00       	call   800713 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c9:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8003cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d4:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	52                   	push   %edx
  8003de:	50                   	push   %eax
  8003df:	68 54 21 80 00       	push   $0x802154
  8003e4:	e8 2a 03 00 00       	call   800713 <cprintf>
  8003e9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8003ec:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f1:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8003f7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fc:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800402:	83 ec 04             	sub    $0x4,%esp
  800405:	52                   	push   %edx
  800406:	50                   	push   %eax
  800407:	68 7c 21 80 00       	push   $0x80217c
  80040c:	e8 02 03 00 00       	call   800713 <cprintf>
  800411:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800414:	a1 20 30 80 00       	mov    0x803020,%eax
  800419:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	50                   	push   %eax
  800423:	68 bd 21 80 00       	push   $0x8021bd
  800428:	e8 e6 02 00 00       	call   800713 <cprintf>
  80042d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800430:	83 ec 0c             	sub    $0xc,%esp
  800433:	68 2c 21 80 00       	push   $0x80212c
  800438:	e8 d6 02 00 00       	call   800713 <cprintf>
  80043d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800440:	e8 56 13 00 00       	call   80179b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800445:	e8 19 00 00 00       	call   800463 <exit>
}
  80044a:	90                   	nop
  80044b:	c9                   	leave  
  80044c:	c3                   	ret    

0080044d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	6a 00                	push   $0x0
  800458:	e8 55 11 00 00       	call   8015b2 <sys_env_destroy>
  80045d:	83 c4 10             	add    $0x10,%esp
}
  800460:	90                   	nop
  800461:	c9                   	leave  
  800462:	c3                   	ret    

00800463 <exit>:

void
exit(void)
{
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800469:	e8 aa 11 00 00       	call   801618 <sys_env_exit>
}
  80046e:	90                   	nop
  80046f:	c9                   	leave  
  800470:	c3                   	ret    

00800471 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800477:	8d 45 10             	lea    0x10(%ebp),%eax
  80047a:	83 c0 04             	add    $0x4,%eax
  80047d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800480:	a1 18 31 80 00       	mov    0x803118,%eax
  800485:	85 c0                	test   %eax,%eax
  800487:	74 16                	je     80049f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800489:	a1 18 31 80 00       	mov    0x803118,%eax
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	50                   	push   %eax
  800492:	68 d4 21 80 00       	push   $0x8021d4
  800497:	e8 77 02 00 00       	call   800713 <cprintf>
  80049c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80049f:	a1 00 30 80 00       	mov    0x803000,%eax
  8004a4:	ff 75 0c             	pushl  0xc(%ebp)
  8004a7:	ff 75 08             	pushl  0x8(%ebp)
  8004aa:	50                   	push   %eax
  8004ab:	68 d9 21 80 00       	push   $0x8021d9
  8004b0:	e8 5e 02 00 00       	call   800713 <cprintf>
  8004b5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bb:	83 ec 08             	sub    $0x8,%esp
  8004be:	ff 75 f4             	pushl  -0xc(%ebp)
  8004c1:	50                   	push   %eax
  8004c2:	e8 e1 01 00 00       	call   8006a8 <vcprintf>
  8004c7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004ca:	83 ec 08             	sub    $0x8,%esp
  8004cd:	6a 00                	push   $0x0
  8004cf:	68 f5 21 80 00       	push   $0x8021f5
  8004d4:	e8 cf 01 00 00       	call   8006a8 <vcprintf>
  8004d9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004dc:	e8 82 ff ff ff       	call   800463 <exit>

	// should not return here
	while (1) ;
  8004e1:	eb fe                	jmp    8004e1 <_panic+0x70>

008004e3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ee:	8b 50 74             	mov    0x74(%eax),%edx
  8004f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f4:	39 c2                	cmp    %eax,%edx
  8004f6:	74 14                	je     80050c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	68 f8 21 80 00       	push   $0x8021f8
  800500:	6a 26                	push   $0x26
  800502:	68 44 22 80 00       	push   $0x802244
  800507:	e8 65 ff ff ff       	call   800471 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80050c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051a:	e9 b6 00 00 00       	jmp    8005d5 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80051f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800522:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	01 d0                	add    %edx,%eax
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	85 c0                	test   %eax,%eax
  800532:	75 08                	jne    80053c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800534:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800537:	e9 96 00 00 00       	jmp    8005d2 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80053c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800543:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80054a:	eb 5d                	jmp    8005a9 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80054c:	a1 20 30 80 00       	mov    0x803020,%eax
  800551:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800557:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80055a:	c1 e2 04             	shl    $0x4,%edx
  80055d:	01 d0                	add    %edx,%eax
  80055f:	8a 40 04             	mov    0x4(%eax),%al
  800562:	84 c0                	test   %al,%al
  800564:	75 40                	jne    8005a6 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800566:	a1 20 30 80 00       	mov    0x803020,%eax
  80056b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800571:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800574:	c1 e2 04             	shl    $0x4,%edx
  800577:	01 d0                	add    %edx,%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80057e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800581:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800586:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80058b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800592:	8b 45 08             	mov    0x8(%ebp),%eax
  800595:	01 c8                	add    %ecx,%eax
  800597:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800599:	39 c2                	cmp    %eax,%edx
  80059b:	75 09                	jne    8005a6 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  80059d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005a4:	eb 12                	jmp    8005b8 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a6:	ff 45 e8             	incl   -0x18(%ebp)
  8005a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ae:	8b 50 74             	mov    0x74(%eax),%edx
  8005b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b4:	39 c2                	cmp    %eax,%edx
  8005b6:	77 94                	ja     80054c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005bc:	75 14                	jne    8005d2 <CheckWSWithoutLastIndex+0xef>
			panic(
  8005be:	83 ec 04             	sub    $0x4,%esp
  8005c1:	68 50 22 80 00       	push   $0x802250
  8005c6:	6a 3a                	push   $0x3a
  8005c8:	68 44 22 80 00       	push   $0x802244
  8005cd:	e8 9f fe ff ff       	call   800471 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005d2:	ff 45 f0             	incl   -0x10(%ebp)
  8005d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005db:	0f 8c 3e ff ff ff    	jl     80051f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005ef:	eb 20                	jmp    800611 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f6:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8005fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ff:	c1 e2 04             	shl    $0x4,%edx
  800602:	01 d0                	add    %edx,%eax
  800604:	8a 40 04             	mov    0x4(%eax),%al
  800607:	3c 01                	cmp    $0x1,%al
  800609:	75 03                	jne    80060e <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80060b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80060e:	ff 45 e0             	incl   -0x20(%ebp)
  800611:	a1 20 30 80 00       	mov    0x803020,%eax
  800616:	8b 50 74             	mov    0x74(%eax),%edx
  800619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	77 d1                	ja     8005f1 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800623:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800626:	74 14                	je     80063c <CheckWSWithoutLastIndex+0x159>
		panic(
  800628:	83 ec 04             	sub    $0x4,%esp
  80062b:	68 a4 22 80 00       	push   $0x8022a4
  800630:	6a 44                	push   $0x44
  800632:	68 44 22 80 00       	push   $0x802244
  800637:	e8 35 fe ff ff       	call   800471 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80063c:	90                   	nop
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
  800642:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800645:	8b 45 0c             	mov    0xc(%ebp),%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	8d 48 01             	lea    0x1(%eax),%ecx
  80064d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800650:	89 0a                	mov    %ecx,(%edx)
  800652:	8b 55 08             	mov    0x8(%ebp),%edx
  800655:	88 d1                	mov    %dl,%cl
  800657:	8b 55 0c             	mov    0xc(%ebp),%edx
  80065a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80065e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	3d ff 00 00 00       	cmp    $0xff,%eax
  800668:	75 2c                	jne    800696 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80066a:	a0 24 30 80 00       	mov    0x803024,%al
  80066f:	0f b6 c0             	movzbl %al,%eax
  800672:	8b 55 0c             	mov    0xc(%ebp),%edx
  800675:	8b 12                	mov    (%edx),%edx
  800677:	89 d1                	mov    %edx,%ecx
  800679:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067c:	83 c2 08             	add    $0x8,%edx
  80067f:	83 ec 04             	sub    $0x4,%esp
  800682:	50                   	push   %eax
  800683:	51                   	push   %ecx
  800684:	52                   	push   %edx
  800685:	e8 e6 0e 00 00       	call   801570 <sys_cputs>
  80068a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80068d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800696:	8b 45 0c             	mov    0xc(%ebp),%eax
  800699:	8b 40 04             	mov    0x4(%eax),%eax
  80069c:	8d 50 01             	lea    0x1(%eax),%edx
  80069f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006a5:	90                   	nop
  8006a6:	c9                   	leave  
  8006a7:	c3                   	ret    

008006a8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
  8006ab:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006b1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006b8:	00 00 00 
	b.cnt = 0;
  8006bb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006c2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006c5:	ff 75 0c             	pushl  0xc(%ebp)
  8006c8:	ff 75 08             	pushl  0x8(%ebp)
  8006cb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006d1:	50                   	push   %eax
  8006d2:	68 3f 06 80 00       	push   $0x80063f
  8006d7:	e8 11 02 00 00       	call   8008ed <vprintfmt>
  8006dc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8006df:	a0 24 30 80 00       	mov    0x803024,%al
  8006e4:	0f b6 c0             	movzbl %al,%eax
  8006e7:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006ed:	83 ec 04             	sub    $0x4,%esp
  8006f0:	50                   	push   %eax
  8006f1:	52                   	push   %edx
  8006f2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f8:	83 c0 08             	add    $0x8,%eax
  8006fb:	50                   	push   %eax
  8006fc:	e8 6f 0e 00 00       	call   801570 <sys_cputs>
  800701:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800704:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80070b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800711:	c9                   	leave  
  800712:	c3                   	ret    

00800713 <cprintf>:

int cprintf(const char *fmt, ...) {
  800713:	55                   	push   %ebp
  800714:	89 e5                	mov    %esp,%ebp
  800716:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800719:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800720:	8d 45 0c             	lea    0xc(%ebp),%eax
  800723:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 f4             	pushl  -0xc(%ebp)
  80072f:	50                   	push   %eax
  800730:	e8 73 ff ff ff       	call   8006a8 <vcprintf>
  800735:	83 c4 10             	add    $0x10,%esp
  800738:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80073b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80073e:	c9                   	leave  
  80073f:	c3                   	ret    

00800740 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800746:	e8 36 10 00 00       	call   801781 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80074b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	ff 75 f4             	pushl  -0xc(%ebp)
  80075a:	50                   	push   %eax
  80075b:	e8 48 ff ff ff       	call   8006a8 <vcprintf>
  800760:	83 c4 10             	add    $0x10,%esp
  800763:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800766:	e8 30 10 00 00       	call   80179b <sys_enable_interrupt>
	return cnt;
  80076b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80076e:	c9                   	leave  
  80076f:	c3                   	ret    

00800770 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800770:	55                   	push   %ebp
  800771:	89 e5                	mov    %esp,%ebp
  800773:	53                   	push   %ebx
  800774:	83 ec 14             	sub    $0x14,%esp
  800777:	8b 45 10             	mov    0x10(%ebp),%eax
  80077a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800783:	8b 45 18             	mov    0x18(%ebp),%eax
  800786:	ba 00 00 00 00       	mov    $0x0,%edx
  80078b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80078e:	77 55                	ja     8007e5 <printnum+0x75>
  800790:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800793:	72 05                	jb     80079a <printnum+0x2a>
  800795:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800798:	77 4b                	ja     8007e5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80079a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80079d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007a0:	8b 45 18             	mov    0x18(%ebp),%eax
  8007a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a8:	52                   	push   %edx
  8007a9:	50                   	push   %eax
  8007aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8007b0:	e8 a3 14 00 00       	call   801c58 <__udivdi3>
  8007b5:	83 c4 10             	add    $0x10,%esp
  8007b8:	83 ec 04             	sub    $0x4,%esp
  8007bb:	ff 75 20             	pushl  0x20(%ebp)
  8007be:	53                   	push   %ebx
  8007bf:	ff 75 18             	pushl  0x18(%ebp)
  8007c2:	52                   	push   %edx
  8007c3:	50                   	push   %eax
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 a1 ff ff ff       	call   800770 <printnum>
  8007cf:	83 c4 20             	add    $0x20,%esp
  8007d2:	eb 1a                	jmp    8007ee <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	ff 75 0c             	pushl  0xc(%ebp)
  8007da:	ff 75 20             	pushl  0x20(%ebp)
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	ff d0                	call   *%eax
  8007e2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007e5:	ff 4d 1c             	decl   0x1c(%ebp)
  8007e8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007ec:	7f e6                	jg     8007d4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007ee:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007fc:	53                   	push   %ebx
  8007fd:	51                   	push   %ecx
  8007fe:	52                   	push   %edx
  8007ff:	50                   	push   %eax
  800800:	e8 63 15 00 00       	call   801d68 <__umoddi3>
  800805:	83 c4 10             	add    $0x10,%esp
  800808:	05 14 25 80 00       	add    $0x802514,%eax
  80080d:	8a 00                	mov    (%eax),%al
  80080f:	0f be c0             	movsbl %al,%eax
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	50                   	push   %eax
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	ff d0                	call   *%eax
  80081e:	83 c4 10             	add    $0x10,%esp
}
  800821:	90                   	nop
  800822:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800825:	c9                   	leave  
  800826:	c3                   	ret    

00800827 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80082a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80082e:	7e 1c                	jle    80084c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	8b 00                	mov    (%eax),%eax
  800835:	8d 50 08             	lea    0x8(%eax),%edx
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	89 10                	mov    %edx,(%eax)
  80083d:	8b 45 08             	mov    0x8(%ebp),%eax
  800840:	8b 00                	mov    (%eax),%eax
  800842:	83 e8 08             	sub    $0x8,%eax
  800845:	8b 50 04             	mov    0x4(%eax),%edx
  800848:	8b 00                	mov    (%eax),%eax
  80084a:	eb 40                	jmp    80088c <getuint+0x65>
	else if (lflag)
  80084c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800850:	74 1e                	je     800870 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	8b 00                	mov    (%eax),%eax
  800857:	8d 50 04             	lea    0x4(%eax),%edx
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	89 10                	mov    %edx,(%eax)
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	8b 00                	mov    (%eax),%eax
  800864:	83 e8 04             	sub    $0x4,%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	ba 00 00 00 00       	mov    $0x0,%edx
  80086e:	eb 1c                	jmp    80088c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	8d 50 04             	lea    0x4(%eax),%edx
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	89 10                	mov    %edx,(%eax)
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800891:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800895:	7e 1c                	jle    8008b3 <getint+0x25>
		return va_arg(*ap, long long);
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	8d 50 08             	lea    0x8(%eax),%edx
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	89 10                	mov    %edx,(%eax)
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	83 e8 08             	sub    $0x8,%eax
  8008ac:	8b 50 04             	mov    0x4(%eax),%edx
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	eb 38                	jmp    8008eb <getint+0x5d>
	else if (lflag)
  8008b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b7:	74 1a                	je     8008d3 <getint+0x45>
		return va_arg(*ap, long);
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	8d 50 04             	lea    0x4(%eax),%edx
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	89 10                	mov    %edx,(%eax)
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	83 e8 04             	sub    $0x4,%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	99                   	cltd   
  8008d1:	eb 18                	jmp    8008eb <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	8b 00                	mov    (%eax),%eax
  8008d8:	8d 50 04             	lea    0x4(%eax),%edx
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	89 10                	mov    %edx,(%eax)
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	83 e8 04             	sub    $0x4,%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	99                   	cltd   
}
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    

008008ed <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	56                   	push   %esi
  8008f1:	53                   	push   %ebx
  8008f2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f5:	eb 17                	jmp    80090e <vprintfmt+0x21>
			if (ch == '\0')
  8008f7:	85 db                	test   %ebx,%ebx
  8008f9:	0f 84 af 03 00 00    	je     800cae <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	53                   	push   %ebx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	ff d0                	call   *%eax
  80090b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80090e:	8b 45 10             	mov    0x10(%ebp),%eax
  800911:	8d 50 01             	lea    0x1(%eax),%edx
  800914:	89 55 10             	mov    %edx,0x10(%ebp)
  800917:	8a 00                	mov    (%eax),%al
  800919:	0f b6 d8             	movzbl %al,%ebx
  80091c:	83 fb 25             	cmp    $0x25,%ebx
  80091f:	75 d6                	jne    8008f7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800921:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800925:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80092c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800933:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80093a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800941:	8b 45 10             	mov    0x10(%ebp),%eax
  800944:	8d 50 01             	lea    0x1(%eax),%edx
  800947:	89 55 10             	mov    %edx,0x10(%ebp)
  80094a:	8a 00                	mov    (%eax),%al
  80094c:	0f b6 d8             	movzbl %al,%ebx
  80094f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800952:	83 f8 55             	cmp    $0x55,%eax
  800955:	0f 87 2b 03 00 00    	ja     800c86 <vprintfmt+0x399>
  80095b:	8b 04 85 38 25 80 00 	mov    0x802538(,%eax,4),%eax
  800962:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800964:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800968:	eb d7                	jmp    800941 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80096a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80096e:	eb d1                	jmp    800941 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800970:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800977:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80097a:	89 d0                	mov    %edx,%eax
  80097c:	c1 e0 02             	shl    $0x2,%eax
  80097f:	01 d0                	add    %edx,%eax
  800981:	01 c0                	add    %eax,%eax
  800983:	01 d8                	add    %ebx,%eax
  800985:	83 e8 30             	sub    $0x30,%eax
  800988:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80098b:	8b 45 10             	mov    0x10(%ebp),%eax
  80098e:	8a 00                	mov    (%eax),%al
  800990:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800993:	83 fb 2f             	cmp    $0x2f,%ebx
  800996:	7e 3e                	jle    8009d6 <vprintfmt+0xe9>
  800998:	83 fb 39             	cmp    $0x39,%ebx
  80099b:	7f 39                	jg     8009d6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009a0:	eb d5                	jmp    800977 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a5:	83 c0 04             	add    $0x4,%eax
  8009a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ae:	83 e8 04             	sub    $0x4,%eax
  8009b1:	8b 00                	mov    (%eax),%eax
  8009b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009b6:	eb 1f                	jmp    8009d7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009bc:	79 83                	jns    800941 <vprintfmt+0x54>
				width = 0;
  8009be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009c5:	e9 77 ff ff ff       	jmp    800941 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009ca:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009d1:	e9 6b ff ff ff       	jmp    800941 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009d6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009db:	0f 89 60 ff ff ff    	jns    800941 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009e7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009ee:	e9 4e ff ff ff       	jmp    800941 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009f3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009f6:	e9 46 ff ff ff       	jmp    800941 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fe:	83 c0 04             	add    $0x4,%eax
  800a01:	89 45 14             	mov    %eax,0x14(%ebp)
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	83 e8 04             	sub    $0x4,%eax
  800a0a:	8b 00                	mov    (%eax),%eax
  800a0c:	83 ec 08             	sub    $0x8,%esp
  800a0f:	ff 75 0c             	pushl  0xc(%ebp)
  800a12:	50                   	push   %eax
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
			break;
  800a1b:	e9 89 02 00 00       	jmp    800ca9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a20:	8b 45 14             	mov    0x14(%ebp),%eax
  800a23:	83 c0 04             	add    $0x4,%eax
  800a26:	89 45 14             	mov    %eax,0x14(%ebp)
  800a29:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2c:	83 e8 04             	sub    $0x4,%eax
  800a2f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a31:	85 db                	test   %ebx,%ebx
  800a33:	79 02                	jns    800a37 <vprintfmt+0x14a>
				err = -err;
  800a35:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a37:	83 fb 64             	cmp    $0x64,%ebx
  800a3a:	7f 0b                	jg     800a47 <vprintfmt+0x15a>
  800a3c:	8b 34 9d 80 23 80 00 	mov    0x802380(,%ebx,4),%esi
  800a43:	85 f6                	test   %esi,%esi
  800a45:	75 19                	jne    800a60 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a47:	53                   	push   %ebx
  800a48:	68 25 25 80 00       	push   $0x802525
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	ff 75 08             	pushl  0x8(%ebp)
  800a53:	e8 5e 02 00 00       	call   800cb6 <printfmt>
  800a58:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a5b:	e9 49 02 00 00       	jmp    800ca9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a60:	56                   	push   %esi
  800a61:	68 2e 25 80 00       	push   $0x80252e
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	ff 75 08             	pushl  0x8(%ebp)
  800a6c:	e8 45 02 00 00       	call   800cb6 <printfmt>
  800a71:	83 c4 10             	add    $0x10,%esp
			break;
  800a74:	e9 30 02 00 00       	jmp    800ca9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a79:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7c:	83 c0 04             	add    $0x4,%eax
  800a7f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	83 e8 04             	sub    $0x4,%eax
  800a88:	8b 30                	mov    (%eax),%esi
  800a8a:	85 f6                	test   %esi,%esi
  800a8c:	75 05                	jne    800a93 <vprintfmt+0x1a6>
				p = "(null)";
  800a8e:	be 31 25 80 00       	mov    $0x802531,%esi
			if (width > 0 && padc != '-')
  800a93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a97:	7e 6d                	jle    800b06 <vprintfmt+0x219>
  800a99:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a9d:	74 67                	je     800b06 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aa2:	83 ec 08             	sub    $0x8,%esp
  800aa5:	50                   	push   %eax
  800aa6:	56                   	push   %esi
  800aa7:	e8 0c 03 00 00       	call   800db8 <strnlen>
  800aac:	83 c4 10             	add    $0x10,%esp
  800aaf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ab2:	eb 16                	jmp    800aca <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ab4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ab8:	83 ec 08             	sub    $0x8,%esp
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	50                   	push   %eax
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac7:	ff 4d e4             	decl   -0x1c(%ebp)
  800aca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ace:	7f e4                	jg     800ab4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad0:	eb 34                	jmp    800b06 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ad2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ad6:	74 1c                	je     800af4 <vprintfmt+0x207>
  800ad8:	83 fb 1f             	cmp    $0x1f,%ebx
  800adb:	7e 05                	jle    800ae2 <vprintfmt+0x1f5>
  800add:	83 fb 7e             	cmp    $0x7e,%ebx
  800ae0:	7e 12                	jle    800af4 <vprintfmt+0x207>
					putch('?', putdat);
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	6a 3f                	push   $0x3f
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	ff d0                	call   *%eax
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	eb 0f                	jmp    800b03 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800af4:	83 ec 08             	sub    $0x8,%esp
  800af7:	ff 75 0c             	pushl  0xc(%ebp)
  800afa:	53                   	push   %ebx
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	ff d0                	call   *%eax
  800b00:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b03:	ff 4d e4             	decl   -0x1c(%ebp)
  800b06:	89 f0                	mov    %esi,%eax
  800b08:	8d 70 01             	lea    0x1(%eax),%esi
  800b0b:	8a 00                	mov    (%eax),%al
  800b0d:	0f be d8             	movsbl %al,%ebx
  800b10:	85 db                	test   %ebx,%ebx
  800b12:	74 24                	je     800b38 <vprintfmt+0x24b>
  800b14:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b18:	78 b8                	js     800ad2 <vprintfmt+0x1e5>
  800b1a:	ff 4d e0             	decl   -0x20(%ebp)
  800b1d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b21:	79 af                	jns    800ad2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b23:	eb 13                	jmp    800b38 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 0c             	pushl  0xc(%ebp)
  800b2b:	6a 20                	push   $0x20
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	ff d0                	call   *%eax
  800b32:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b35:	ff 4d e4             	decl   -0x1c(%ebp)
  800b38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3c:	7f e7                	jg     800b25 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b3e:	e9 66 01 00 00       	jmp    800ca9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b43:	83 ec 08             	sub    $0x8,%esp
  800b46:	ff 75 e8             	pushl  -0x18(%ebp)
  800b49:	8d 45 14             	lea    0x14(%ebp),%eax
  800b4c:	50                   	push   %eax
  800b4d:	e8 3c fd ff ff       	call   80088e <getint>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b61:	85 d2                	test   %edx,%edx
  800b63:	79 23                	jns    800b88 <vprintfmt+0x29b>
				putch('-', putdat);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	6a 2d                	push   $0x2d
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	ff d0                	call   *%eax
  800b72:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b7b:	f7 d8                	neg    %eax
  800b7d:	83 d2 00             	adc    $0x0,%edx
  800b80:	f7 da                	neg    %edx
  800b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b85:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b88:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b8f:	e9 bc 00 00 00       	jmp    800c50 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	ff 75 e8             	pushl  -0x18(%ebp)
  800b9a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b9d:	50                   	push   %eax
  800b9e:	e8 84 fc ff ff       	call   800827 <getuint>
  800ba3:	83 c4 10             	add    $0x10,%esp
  800ba6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bac:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb3:	e9 98 00 00 00       	jmp    800c50 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	6a 58                	push   $0x58
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bc8:	83 ec 08             	sub    $0x8,%esp
  800bcb:	ff 75 0c             	pushl  0xc(%ebp)
  800bce:	6a 58                	push   $0x58
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	ff d0                	call   *%eax
  800bd5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bd8:	83 ec 08             	sub    $0x8,%esp
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	6a 58                	push   $0x58
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	ff d0                	call   *%eax
  800be5:	83 c4 10             	add    $0x10,%esp
			break;
  800be8:	e9 bc 00 00 00       	jmp    800ca9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 0c             	pushl  0xc(%ebp)
  800bf3:	6a 30                	push   $0x30
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	ff d0                	call   *%eax
  800bfa:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bfd:	83 ec 08             	sub    $0x8,%esp
  800c00:	ff 75 0c             	pushl  0xc(%ebp)
  800c03:	6a 78                	push   $0x78
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	ff d0                	call   *%eax
  800c0a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c10:	83 c0 04             	add    $0x4,%eax
  800c13:	89 45 14             	mov    %eax,0x14(%ebp)
  800c16:	8b 45 14             	mov    0x14(%ebp),%eax
  800c19:	83 e8 04             	sub    $0x4,%eax
  800c1c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c28:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c2f:	eb 1f                	jmp    800c50 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 e8             	pushl  -0x18(%ebp)
  800c37:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3a:	50                   	push   %eax
  800c3b:	e8 e7 fb ff ff       	call   800827 <getuint>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c49:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c50:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c57:	83 ec 04             	sub    $0x4,%esp
  800c5a:	52                   	push   %edx
  800c5b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c5e:	50                   	push   %eax
  800c5f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c62:	ff 75 f0             	pushl  -0x10(%ebp)
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	ff 75 08             	pushl  0x8(%ebp)
  800c6b:	e8 00 fb ff ff       	call   800770 <printnum>
  800c70:	83 c4 20             	add    $0x20,%esp
			break;
  800c73:	eb 34                	jmp    800ca9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	53                   	push   %ebx
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			break;
  800c84:	eb 23                	jmp    800ca9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c86:	83 ec 08             	sub    $0x8,%esp
  800c89:	ff 75 0c             	pushl  0xc(%ebp)
  800c8c:	6a 25                	push   $0x25
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	ff d0                	call   *%eax
  800c93:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c96:	ff 4d 10             	decl   0x10(%ebp)
  800c99:	eb 03                	jmp    800c9e <vprintfmt+0x3b1>
  800c9b:	ff 4d 10             	decl   0x10(%ebp)
  800c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca1:	48                   	dec    %eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	3c 25                	cmp    $0x25,%al
  800ca6:	75 f3                	jne    800c9b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ca8:	90                   	nop
		}
	}
  800ca9:	e9 47 fc ff ff       	jmp    8008f5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cae:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800caf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cb2:	5b                   	pop    %ebx
  800cb3:	5e                   	pop    %esi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    

00800cb6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cbc:	8d 45 10             	lea    0x10(%ebp),%eax
  800cbf:	83 c0 04             	add    $0x4,%eax
  800cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc8:	ff 75 f4             	pushl  -0xc(%ebp)
  800ccb:	50                   	push   %eax
  800ccc:	ff 75 0c             	pushl  0xc(%ebp)
  800ccf:	ff 75 08             	pushl  0x8(%ebp)
  800cd2:	e8 16 fc ff ff       	call   8008ed <vprintfmt>
  800cd7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cda:	90                   	nop
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce3:	8b 40 08             	mov    0x8(%eax),%eax
  800ce6:	8d 50 01             	lea    0x1(%eax),%edx
  800ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cec:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf2:	8b 10                	mov    (%eax),%edx
  800cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf7:	8b 40 04             	mov    0x4(%eax),%eax
  800cfa:	39 c2                	cmp    %eax,%edx
  800cfc:	73 12                	jae    800d10 <sprintputch+0x33>
		*b->buf++ = ch;
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8b 00                	mov    (%eax),%eax
  800d03:	8d 48 01             	lea    0x1(%eax),%ecx
  800d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d09:	89 0a                	mov    %ecx,(%edx)
  800d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0e:	88 10                	mov    %dl,(%eax)
}
  800d10:	90                   	nop
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    

00800d13 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d22:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	01 d0                	add    %edx,%eax
  800d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d38:	74 06                	je     800d40 <vsnprintf+0x2d>
  800d3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d3e:	7f 07                	jg     800d47 <vsnprintf+0x34>
		return -E_INVAL;
  800d40:	b8 03 00 00 00       	mov    $0x3,%eax
  800d45:	eb 20                	jmp    800d67 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d47:	ff 75 14             	pushl  0x14(%ebp)
  800d4a:	ff 75 10             	pushl  0x10(%ebp)
  800d4d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d50:	50                   	push   %eax
  800d51:	68 dd 0c 80 00       	push   $0x800cdd
  800d56:	e8 92 fb ff ff       	call   8008ed <vprintfmt>
  800d5b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d61:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d6f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d72:	83 c0 04             	add    $0x4,%eax
  800d75:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d78:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d7e:	50                   	push   %eax
  800d7f:	ff 75 0c             	pushl  0xc(%ebp)
  800d82:	ff 75 08             	pushl  0x8(%ebp)
  800d85:	e8 89 ff ff ff       	call   800d13 <vsnprintf>
  800d8a:	83 c4 10             	add    $0x10,%esp
  800d8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800da2:	eb 06                	jmp    800daa <strlen+0x15>
		n++;
  800da4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800da7:	ff 45 08             	incl   0x8(%ebp)
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	8a 00                	mov    (%eax),%al
  800daf:	84 c0                	test   %al,%al
  800db1:	75 f1                	jne    800da4 <strlen+0xf>
		n++;
	return n;
  800db3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800db6:	c9                   	leave  
  800db7:	c3                   	ret    

00800db8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc5:	eb 09                	jmp    800dd0 <strnlen+0x18>
		n++;
  800dc7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dca:	ff 45 08             	incl   0x8(%ebp)
  800dcd:	ff 4d 0c             	decl   0xc(%ebp)
  800dd0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd4:	74 09                	je     800ddf <strnlen+0x27>
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	84 c0                	test   %al,%al
  800ddd:	75 e8                	jne    800dc7 <strnlen+0xf>
		n++;
	return n;
  800ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800df0:	90                   	nop
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8d 50 01             	lea    0x1(%eax),%edx
  800df7:	89 55 08             	mov    %edx,0x8(%ebp)
  800dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e00:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e03:	8a 12                	mov    (%edx),%dl
  800e05:	88 10                	mov    %dl,(%eax)
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	84 c0                	test   %al,%al
  800e0b:	75 e4                	jne    800df1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e25:	eb 1f                	jmp    800e46 <strncpy+0x34>
		*dst++ = *src;
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8d 50 01             	lea    0x1(%eax),%edx
  800e2d:	89 55 08             	mov    %edx,0x8(%ebp)
  800e30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e33:	8a 12                	mov    (%edx),%dl
  800e35:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	84 c0                	test   %al,%al
  800e3e:	74 03                	je     800e43 <strncpy+0x31>
			src++;
  800e40:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e43:	ff 45 fc             	incl   -0x4(%ebp)
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e49:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e4c:	72 d9                	jb     800e27 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e51:	c9                   	leave  
  800e52:	c3                   	ret    

00800e53 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e63:	74 30                	je     800e95 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e65:	eb 16                	jmp    800e7d <strlcpy+0x2a>
			*dst++ = *src++;
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8d 50 01             	lea    0x1(%eax),%edx
  800e6d:	89 55 08             	mov    %edx,0x8(%ebp)
  800e70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e73:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e76:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e79:	8a 12                	mov    (%edx),%dl
  800e7b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e7d:	ff 4d 10             	decl   0x10(%ebp)
  800e80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e84:	74 09                	je     800e8f <strlcpy+0x3c>
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	8a 00                	mov    (%eax),%al
  800e8b:	84 c0                	test   %al,%al
  800e8d:	75 d8                	jne    800e67 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e95:	8b 55 08             	mov    0x8(%ebp),%edx
  800e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9b:	29 c2                	sub    %eax,%edx
  800e9d:	89 d0                	mov    %edx,%eax
}
  800e9f:	c9                   	leave  
  800ea0:	c3                   	ret    

00800ea1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ea4:	eb 06                	jmp    800eac <strcmp+0xb>
		p++, q++;
  800ea6:	ff 45 08             	incl   0x8(%ebp)
  800ea9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	8a 00                	mov    (%eax),%al
  800eb1:	84 c0                	test   %al,%al
  800eb3:	74 0e                	je     800ec3 <strcmp+0x22>
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8a 10                	mov    (%eax),%dl
  800eba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	38 c2                	cmp    %al,%dl
  800ec1:	74 e3                	je     800ea6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	0f b6 d0             	movzbl %al,%edx
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	0f b6 c0             	movzbl %al,%eax
  800ed3:	29 c2                	sub    %eax,%edx
  800ed5:	89 d0                	mov    %edx,%eax
}
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    

00800ed9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800edc:	eb 09                	jmp    800ee7 <strncmp+0xe>
		n--, p++, q++;
  800ede:	ff 4d 10             	decl   0x10(%ebp)
  800ee1:	ff 45 08             	incl   0x8(%ebp)
  800ee4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ee7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eeb:	74 17                	je     800f04 <strncmp+0x2b>
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	84 c0                	test   %al,%al
  800ef4:	74 0e                	je     800f04 <strncmp+0x2b>
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8a 10                	mov    (%eax),%dl
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	38 c2                	cmp    %al,%dl
  800f02:	74 da                	je     800ede <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f08:	75 07                	jne    800f11 <strncmp+0x38>
		return 0;
  800f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f0f:	eb 14                	jmp    800f25 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	0f b6 d0             	movzbl %al,%edx
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	0f b6 c0             	movzbl %al,%eax
  800f21:	29 c2                	sub    %eax,%edx
  800f23:	89 d0                	mov    %edx,%eax
}
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    

00800f27 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	83 ec 04             	sub    $0x4,%esp
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f33:	eb 12                	jmp    800f47 <strchr+0x20>
		if (*s == c)
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f3d:	75 05                	jne    800f44 <strchr+0x1d>
			return (char *) s;
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	eb 11                	jmp    800f55 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f44:	ff 45 08             	incl   0x8(%ebp)
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	84 c0                	test   %al,%al
  800f4e:	75 e5                	jne    800f35 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f55:	c9                   	leave  
  800f56:	c3                   	ret    

00800f57 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	83 ec 04             	sub    $0x4,%esp
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f63:	eb 0d                	jmp    800f72 <strfind+0x1b>
		if (*s == c)
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f6d:	74 0e                	je     800f7d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f6f:	ff 45 08             	incl   0x8(%ebp)
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	84 c0                	test   %al,%al
  800f79:	75 ea                	jne    800f65 <strfind+0xe>
  800f7b:	eb 01                	jmp    800f7e <strfind+0x27>
		if (*s == c)
			break;
  800f7d:	90                   	nop
	return (char *) s;
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f81:	c9                   	leave  
  800f82:	c3                   	ret    

00800f83 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f95:	eb 0e                	jmp    800fa5 <memset+0x22>
		*p++ = c;
  800f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9a:	8d 50 01             	lea    0x1(%eax),%edx
  800f9d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fa5:	ff 4d f8             	decl   -0x8(%ebp)
  800fa8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fac:	79 e9                	jns    800f97 <memset+0x14>
		*p++ = c;

	return v;
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fc5:	eb 16                	jmp    800fdd <memcpy+0x2a>
		*d++ = *s++;
  800fc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fca:	8d 50 01             	lea    0x1(%eax),%edx
  800fcd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fd6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fd9:	8a 12                	mov    (%edx),%dl
  800fdb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe3:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	75 dd                	jne    800fc7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fed:	c9                   	leave  
  800fee:	c3                   	ret    

00800fef <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801001:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801004:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801007:	73 50                	jae    801059 <memmove+0x6a>
  801009:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100c:	8b 45 10             	mov    0x10(%ebp),%eax
  80100f:	01 d0                	add    %edx,%eax
  801011:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801014:	76 43                	jbe    801059 <memmove+0x6a>
		s += n;
  801016:	8b 45 10             	mov    0x10(%ebp),%eax
  801019:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80101c:	8b 45 10             	mov    0x10(%ebp),%eax
  80101f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801022:	eb 10                	jmp    801034 <memmove+0x45>
			*--d = *--s;
  801024:	ff 4d f8             	decl   -0x8(%ebp)
  801027:	ff 4d fc             	decl   -0x4(%ebp)
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8a 10                	mov    (%eax),%dl
  80102f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801032:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801034:	8b 45 10             	mov    0x10(%ebp),%eax
  801037:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103a:	89 55 10             	mov    %edx,0x10(%ebp)
  80103d:	85 c0                	test   %eax,%eax
  80103f:	75 e3                	jne    801024 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801041:	eb 23                	jmp    801066 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801043:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801046:	8d 50 01             	lea    0x1(%eax),%edx
  801049:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80104c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801052:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801055:	8a 12                	mov    (%edx),%dl
  801057:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801059:	8b 45 10             	mov    0x10(%ebp),%eax
  80105c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105f:	89 55 10             	mov    %edx,0x10(%ebp)
  801062:	85 c0                	test   %eax,%eax
  801064:	75 dd                	jne    801043 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80107d:	eb 2a                	jmp    8010a9 <memcmp+0x3e>
		if (*s1 != *s2)
  80107f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801082:	8a 10                	mov    (%eax),%dl
  801084:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	38 c2                	cmp    %al,%dl
  80108b:	74 16                	je     8010a3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80108d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	0f b6 d0             	movzbl %al,%edx
  801095:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	0f b6 c0             	movzbl %al,%eax
  80109d:	29 c2                	sub    %eax,%edx
  80109f:	89 d0                	mov    %edx,%eax
  8010a1:	eb 18                	jmp    8010bb <memcmp+0x50>
		s1++, s2++;
  8010a3:	ff 45 fc             	incl   -0x4(%ebp)
  8010a6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010af:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b2:	85 c0                	test   %eax,%eax
  8010b4:	75 c9                	jne    80107f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010bb:	c9                   	leave  
  8010bc:	c3                   	ret    

008010bd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010bd:	55                   	push   %ebp
  8010be:	89 e5                	mov    %esp,%ebp
  8010c0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c9:	01 d0                	add    %edx,%eax
  8010cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010ce:	eb 15                	jmp    8010e5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	0f b6 d0             	movzbl %al,%edx
  8010d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010db:	0f b6 c0             	movzbl %al,%eax
  8010de:	39 c2                	cmp    %eax,%edx
  8010e0:	74 0d                	je     8010ef <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010e2:	ff 45 08             	incl   0x8(%ebp)
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010eb:	72 e3                	jb     8010d0 <memfind+0x13>
  8010ed:	eb 01                	jmp    8010f0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010ef:	90                   	nop
	return (void *) s;
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801102:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801109:	eb 03                	jmp    80110e <strtol+0x19>
		s++;
  80110b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 20                	cmp    $0x20,%al
  801115:	74 f4                	je     80110b <strtol+0x16>
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 09                	cmp    $0x9,%al
  80111e:	74 eb                	je     80110b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 2b                	cmp    $0x2b,%al
  801127:	75 05                	jne    80112e <strtol+0x39>
		s++;
  801129:	ff 45 08             	incl   0x8(%ebp)
  80112c:	eb 13                	jmp    801141 <strtol+0x4c>
	else if (*s == '-')
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	3c 2d                	cmp    $0x2d,%al
  801135:	75 0a                	jne    801141 <strtol+0x4c>
		s++, neg = 1;
  801137:	ff 45 08             	incl   0x8(%ebp)
  80113a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801141:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801145:	74 06                	je     80114d <strtol+0x58>
  801147:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80114b:	75 20                	jne    80116d <strtol+0x78>
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	3c 30                	cmp    $0x30,%al
  801154:	75 17                	jne    80116d <strtol+0x78>
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	40                   	inc    %eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	3c 78                	cmp    $0x78,%al
  80115e:	75 0d                	jne    80116d <strtol+0x78>
		s += 2, base = 16;
  801160:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801164:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80116b:	eb 28                	jmp    801195 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80116d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801171:	75 15                	jne    801188 <strtol+0x93>
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 30                	cmp    $0x30,%al
  80117a:	75 0c                	jne    801188 <strtol+0x93>
		s++, base = 8;
  80117c:	ff 45 08             	incl   0x8(%ebp)
  80117f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801186:	eb 0d                	jmp    801195 <strtol+0xa0>
	else if (base == 0)
  801188:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118c:	75 07                	jne    801195 <strtol+0xa0>
		base = 10;
  80118e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 2f                	cmp    $0x2f,%al
  80119c:	7e 19                	jle    8011b7 <strtol+0xc2>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	3c 39                	cmp    $0x39,%al
  8011a5:	7f 10                	jg     8011b7 <strtol+0xc2>
			dig = *s - '0';
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	8a 00                	mov    (%eax),%al
  8011ac:	0f be c0             	movsbl %al,%eax
  8011af:	83 e8 30             	sub    $0x30,%eax
  8011b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011b5:	eb 42                	jmp    8011f9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3c 60                	cmp    $0x60,%al
  8011be:	7e 19                	jle    8011d9 <strtol+0xe4>
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	3c 7a                	cmp    $0x7a,%al
  8011c7:	7f 10                	jg     8011d9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	0f be c0             	movsbl %al,%eax
  8011d1:	83 e8 57             	sub    $0x57,%eax
  8011d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011d7:	eb 20                	jmp    8011f9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	3c 40                	cmp    $0x40,%al
  8011e0:	7e 39                	jle    80121b <strtol+0x126>
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	3c 5a                	cmp    $0x5a,%al
  8011e9:	7f 30                	jg     80121b <strtol+0x126>
			dig = *s - 'A' + 10;
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	0f be c0             	movsbl %al,%eax
  8011f3:	83 e8 37             	sub    $0x37,%eax
  8011f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011fc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011ff:	7d 19                	jge    80121a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801201:	ff 45 08             	incl   0x8(%ebp)
  801204:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801207:	0f af 45 10          	imul   0x10(%ebp),%eax
  80120b:	89 c2                	mov    %eax,%edx
  80120d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801210:	01 d0                	add    %edx,%eax
  801212:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801215:	e9 7b ff ff ff       	jmp    801195 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80121a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80121b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80121f:	74 08                	je     801229 <strtol+0x134>
		*endptr = (char *) s;
  801221:	8b 45 0c             	mov    0xc(%ebp),%eax
  801224:	8b 55 08             	mov    0x8(%ebp),%edx
  801227:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801229:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80122d:	74 07                	je     801236 <strtol+0x141>
  80122f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801232:	f7 d8                	neg    %eax
  801234:	eb 03                	jmp    801239 <strtol+0x144>
  801236:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <ltostr>:

void
ltostr(long value, char *str)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801241:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801248:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80124f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801253:	79 13                	jns    801268 <ltostr+0x2d>
	{
		neg = 1;
  801255:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801262:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801265:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801270:	99                   	cltd   
  801271:	f7 f9                	idiv   %ecx
  801273:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801276:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801279:	8d 50 01             	lea    0x1(%eax),%edx
  80127c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80127f:	89 c2                	mov    %eax,%edx
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801289:	83 c2 30             	add    $0x30,%edx
  80128c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80128e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801291:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801296:	f7 e9                	imul   %ecx
  801298:	c1 fa 02             	sar    $0x2,%edx
  80129b:	89 c8                	mov    %ecx,%eax
  80129d:	c1 f8 1f             	sar    $0x1f,%eax
  8012a0:	29 c2                	sub    %eax,%edx
  8012a2:	89 d0                	mov    %edx,%eax
  8012a4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012aa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012af:	f7 e9                	imul   %ecx
  8012b1:	c1 fa 02             	sar    $0x2,%edx
  8012b4:	89 c8                	mov    %ecx,%eax
  8012b6:	c1 f8 1f             	sar    $0x1f,%eax
  8012b9:	29 c2                	sub    %eax,%edx
  8012bb:	89 d0                	mov    %edx,%eax
  8012bd:	c1 e0 02             	shl    $0x2,%eax
  8012c0:	01 d0                	add    %edx,%eax
  8012c2:	01 c0                	add    %eax,%eax
  8012c4:	29 c1                	sub    %eax,%ecx
  8012c6:	89 ca                	mov    %ecx,%edx
  8012c8:	85 d2                	test   %edx,%edx
  8012ca:	75 9c                	jne    801268 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d6:	48                   	dec    %eax
  8012d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012da:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012de:	74 3d                	je     80131d <ltostr+0xe2>
		start = 1 ;
  8012e0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012e7:	eb 34                	jmp    80131d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8012e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ef:	01 d0                	add    %edx,%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	01 c2                	add    %eax,%edx
  8012fe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801301:	8b 45 0c             	mov    0xc(%ebp),%eax
  801304:	01 c8                	add    %ecx,%eax
  801306:	8a 00                	mov    (%eax),%al
  801308:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80130a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80130d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801310:	01 c2                	add    %eax,%edx
  801312:	8a 45 eb             	mov    -0x15(%ebp),%al
  801315:	88 02                	mov    %al,(%edx)
		start++ ;
  801317:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80131a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80131d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801320:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801323:	7c c4                	jl     8012e9 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801325:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132b:	01 d0                	add    %edx,%eax
  80132d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801330:	90                   	nop
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801339:	ff 75 08             	pushl  0x8(%ebp)
  80133c:	e8 54 fa ff ff       	call   800d95 <strlen>
  801341:	83 c4 04             	add    $0x4,%esp
  801344:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801347:	ff 75 0c             	pushl  0xc(%ebp)
  80134a:	e8 46 fa ff ff       	call   800d95 <strlen>
  80134f:	83 c4 04             	add    $0x4,%esp
  801352:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801355:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80135c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801363:	eb 17                	jmp    80137c <strcconcat+0x49>
		final[s] = str1[s] ;
  801365:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	01 c2                	add    %eax,%edx
  80136d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	01 c8                	add    %ecx,%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801379:	ff 45 fc             	incl   -0x4(%ebp)
  80137c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801382:	7c e1                	jl     801365 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801384:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80138b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801392:	eb 1f                	jmp    8013b3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801397:	8d 50 01             	lea    0x1(%eax),%edx
  80139a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80139d:	89 c2                	mov    %eax,%edx
  80139f:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a2:	01 c2                	add    %eax,%edx
  8013a4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013aa:	01 c8                	add    %ecx,%eax
  8013ac:	8a 00                	mov    (%eax),%al
  8013ae:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013b0:	ff 45 f8             	incl   -0x8(%ebp)
  8013b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b9:	7c d9                	jl     801394 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013be:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c1:	01 d0                	add    %edx,%eax
  8013c3:	c6 00 00             	movb   $0x0,(%eax)
}
  8013c6:	90                   	nop
  8013c7:	c9                   	leave  
  8013c8:	c3                   	ret    

008013c9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d8:	8b 00                	mov    (%eax),%eax
  8013da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e4:	01 d0                	add    %edx,%eax
  8013e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013ec:	eb 0c                	jmp    8013fa <strsplit+0x31>
			*string++ = 0;
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8d 50 01             	lea    0x1(%eax),%edx
  8013f4:	89 55 08             	mov    %edx,0x8(%ebp)
  8013f7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	84 c0                	test   %al,%al
  801401:	74 18                	je     80141b <strsplit+0x52>
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	0f be c0             	movsbl %al,%eax
  80140b:	50                   	push   %eax
  80140c:	ff 75 0c             	pushl  0xc(%ebp)
  80140f:	e8 13 fb ff ff       	call   800f27 <strchr>
  801414:	83 c4 08             	add    $0x8,%esp
  801417:	85 c0                	test   %eax,%eax
  801419:	75 d3                	jne    8013ee <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	8a 00                	mov    (%eax),%al
  801420:	84 c0                	test   %al,%al
  801422:	74 5a                	je     80147e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801424:	8b 45 14             	mov    0x14(%ebp),%eax
  801427:	8b 00                	mov    (%eax),%eax
  801429:	83 f8 0f             	cmp    $0xf,%eax
  80142c:	75 07                	jne    801435 <strsplit+0x6c>
		{
			return 0;
  80142e:	b8 00 00 00 00       	mov    $0x0,%eax
  801433:	eb 66                	jmp    80149b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801435:	8b 45 14             	mov    0x14(%ebp),%eax
  801438:	8b 00                	mov    (%eax),%eax
  80143a:	8d 48 01             	lea    0x1(%eax),%ecx
  80143d:	8b 55 14             	mov    0x14(%ebp),%edx
  801440:	89 0a                	mov    %ecx,(%edx)
  801442:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801449:	8b 45 10             	mov    0x10(%ebp),%eax
  80144c:	01 c2                	add    %eax,%edx
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801453:	eb 03                	jmp    801458 <strsplit+0x8f>
			string++;
  801455:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	8a 00                	mov    (%eax),%al
  80145d:	84 c0                	test   %al,%al
  80145f:	74 8b                	je     8013ec <strsplit+0x23>
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	8a 00                	mov    (%eax),%al
  801466:	0f be c0             	movsbl %al,%eax
  801469:	50                   	push   %eax
  80146a:	ff 75 0c             	pushl  0xc(%ebp)
  80146d:	e8 b5 fa ff ff       	call   800f27 <strchr>
  801472:	83 c4 08             	add    $0x8,%esp
  801475:	85 c0                	test   %eax,%eax
  801477:	74 dc                	je     801455 <strsplit+0x8c>
			string++;
	}
  801479:	e9 6e ff ff ff       	jmp    8013ec <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80147e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80147f:	8b 45 14             	mov    0x14(%ebp),%eax
  801482:	8b 00                	mov    (%eax),%eax
  801484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80148b:	8b 45 10             	mov    0x10(%ebp),%eax
  80148e:	01 d0                	add    %edx,%eax
  801490:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801496:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	68 90 26 80 00       	push   $0x802690
  8014ab:	6a 19                	push   $0x19
  8014ad:	68 b5 26 80 00       	push   $0x8026b5
  8014b2:	e8 ba ef ff ff       	call   800471 <_panic>

008014b7 <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	83 ec 18             	sub    $0x18,%esp
  8014bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c0:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8014c3:	83 ec 04             	sub    $0x4,%esp
  8014c6:	68 c4 26 80 00       	push   $0x8026c4
  8014cb:	6a 31                	push   $0x31
  8014cd:	68 b5 26 80 00       	push   $0x8026b5
  8014d2:	e8 9a ef ff ff       	call   800471 <_panic>

008014d7 <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014dd:	83 ec 04             	sub    $0x4,%esp
  8014e0:	68 ec 26 80 00       	push   $0x8026ec
  8014e5:	6a 4a                	push   $0x4a
  8014e7:	68 b5 26 80 00       	push   $0x8026b5
  8014ec:	e8 80 ef ff ff       	call   800471 <_panic>

008014f1 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8014f7:	83 ec 04             	sub    $0x4,%esp
  8014fa:	68 10 27 80 00       	push   $0x802710
  8014ff:	6a 70                	push   $0x70
  801501:	68 b5 26 80 00       	push   $0x8026b5
  801506:	e8 66 ef ff ff       	call   800471 <_panic>

0080150b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
  80150e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	68 34 27 80 00       	push   $0x802734
  801519:	68 8b 00 00 00       	push   $0x8b
  80151e:	68 b5 26 80 00       	push   $0x8026b5
  801523:	e8 49 ef ff ff       	call   800471 <_panic>

00801528 <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80152e:	83 ec 04             	sub    $0x4,%esp
  801531:	68 58 27 80 00       	push   $0x802758
  801536:	68 a8 00 00 00       	push   $0xa8
  80153b:	68 b5 26 80 00       	push   $0x8026b5
  801540:	e8 2c ef ff ff       	call   800471 <_panic>

00801545 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	57                   	push   %edi
  801549:	56                   	push   %esi
  80154a:	53                   	push   %ebx
  80154b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801557:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80155a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80155d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801560:	cd 30                	int    $0x30
  801562:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801565:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	5b                   	pop    %ebx
  80156c:	5e                   	pop    %esi
  80156d:	5f                   	pop    %edi
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    

00801570 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80157c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	52                   	push   %edx
  801588:	ff 75 0c             	pushl  0xc(%ebp)
  80158b:	50                   	push   %eax
  80158c:	6a 00                	push   $0x0
  80158e:	e8 b2 ff ff ff       	call   801545 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
}
  801596:	90                   	nop
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <sys_cgetc>:

int
sys_cgetc(void)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 01                	push   $0x1
  8015a8:	e8 98 ff ff ff       	call   801545 <syscall>
  8015ad:	83 c4 18             	add    $0x18,%esp
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	50                   	push   %eax
  8015c1:	6a 05                	push   $0x5
  8015c3:	e8 7d ff ff ff       	call   801545 <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 02                	push   $0x2
  8015dc:	e8 64 ff ff ff       	call   801545 <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 03                	push   $0x3
  8015f5:	e8 4b ff ff ff       	call   801545 <syscall>
  8015fa:	83 c4 18             	add    $0x18,%esp
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 04                	push   $0x4
  80160e:	e8 32 ff ff ff       	call   801545 <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
}
  801616:	c9                   	leave  
  801617:	c3                   	ret    

00801618 <sys_env_exit>:


void sys_env_exit(void)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 06                	push   $0x6
  801627:	e8 19 ff ff ff       	call   801545 <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	90                   	nop
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801635:	8b 55 0c             	mov    0xc(%ebp),%edx
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	52                   	push   %edx
  801642:	50                   	push   %eax
  801643:	6a 07                	push   $0x7
  801645:	e8 fb fe ff ff       	call   801545 <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	56                   	push   %esi
  801653:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801654:	8b 75 18             	mov    0x18(%ebp),%esi
  801657:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80165a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80165d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	56                   	push   %esi
  801664:	53                   	push   %ebx
  801665:	51                   	push   %ecx
  801666:	52                   	push   %edx
  801667:	50                   	push   %eax
  801668:	6a 08                	push   $0x8
  80166a:	e8 d6 fe ff ff       	call   801545 <syscall>
  80166f:	83 c4 18             	add    $0x18,%esp
}
  801672:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801675:	5b                   	pop    %ebx
  801676:	5e                   	pop    %esi
  801677:	5d                   	pop    %ebp
  801678:	c3                   	ret    

00801679 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80167c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	52                   	push   %edx
  801689:	50                   	push   %eax
  80168a:	6a 09                	push   $0x9
  80168c:	e8 b4 fe ff ff       	call   801545 <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	ff 75 0c             	pushl  0xc(%ebp)
  8016a2:	ff 75 08             	pushl  0x8(%ebp)
  8016a5:	6a 0a                	push   $0xa
  8016a7:	e8 99 fe ff ff       	call   801545 <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 0b                	push   $0xb
  8016c0:	e8 80 fe ff ff       	call   801545 <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 0c                	push   $0xc
  8016d9:	e8 67 fe ff ff       	call   801545 <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 0d                	push   $0xd
  8016f2:	e8 4e fe ff ff       	call   801545 <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	ff 75 0c             	pushl  0xc(%ebp)
  801708:	ff 75 08             	pushl  0x8(%ebp)
  80170b:	6a 11                	push   $0x11
  80170d:	e8 33 fe ff ff       	call   801545 <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
	return;
  801715:	90                   	nop
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	ff 75 0c             	pushl  0xc(%ebp)
  801724:	ff 75 08             	pushl  0x8(%ebp)
  801727:	6a 12                	push   $0x12
  801729:	e8 17 fe ff ff       	call   801545 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
	return ;
  801731:	90                   	nop
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 0e                	push   $0xe
  801743:	e8 fd fd ff ff       	call   801545 <syscall>
  801748:	83 c4 18             	add    $0x18,%esp
}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	ff 75 08             	pushl  0x8(%ebp)
  80175b:	6a 0f                	push   $0xf
  80175d:	e8 e3 fd ff ff       	call   801545 <syscall>
  801762:	83 c4 18             	add    $0x18,%esp
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 10                	push   $0x10
  801776:	e8 ca fd ff ff       	call   801545 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	90                   	nop
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 14                	push   $0x14
  801790:	e8 b0 fd ff ff       	call   801545 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	90                   	nop
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 15                	push   $0x15
  8017aa:	e8 96 fd ff ff       	call   801545 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	90                   	nop
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	50                   	push   %eax
  8017ce:	6a 16                	push   $0x16
  8017d0:	e8 70 fd ff ff       	call   801545 <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
}
  8017d8:	90                   	nop
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 17                	push   $0x17
  8017ea:	e8 56 fd ff ff       	call   801545 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	90                   	nop
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	ff 75 0c             	pushl  0xc(%ebp)
  801804:	50                   	push   %eax
  801805:	6a 18                	push   $0x18
  801807:	e8 39 fd ff ff       	call   801545 <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801814:	8b 55 0c             	mov    0xc(%ebp),%edx
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	52                   	push   %edx
  801821:	50                   	push   %eax
  801822:	6a 1b                	push   $0x1b
  801824:	e8 1c fd ff ff       	call   801545 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801831:	8b 55 0c             	mov    0xc(%ebp),%edx
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	52                   	push   %edx
  80183e:	50                   	push   %eax
  80183f:	6a 19                	push   $0x19
  801841:	e8 ff fc ff ff       	call   801545 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
}
  801849:	90                   	nop
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80184f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	52                   	push   %edx
  80185c:	50                   	push   %eax
  80185d:	6a 1a                	push   $0x1a
  80185f:	e8 e1 fc ff ff       	call   801545 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	90                   	nop
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	8b 45 10             	mov    0x10(%ebp),%eax
  801873:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801876:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801879:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	6a 00                	push   $0x0
  801882:	51                   	push   %ecx
  801883:	52                   	push   %edx
  801884:	ff 75 0c             	pushl  0xc(%ebp)
  801887:	50                   	push   %eax
  801888:	6a 1c                	push   $0x1c
  80188a:	e8 b6 fc ff ff       	call   801545 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801897:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	52                   	push   %edx
  8018a4:	50                   	push   %eax
  8018a5:	6a 1d                	push   $0x1d
  8018a7:	e8 99 fc ff ff       	call   801545 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	51                   	push   %ecx
  8018c2:	52                   	push   %edx
  8018c3:	50                   	push   %eax
  8018c4:	6a 1e                	push   $0x1e
  8018c6:	e8 7a fc ff ff       	call   801545 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	52                   	push   %edx
  8018e0:	50                   	push   %eax
  8018e1:	6a 1f                	push   $0x1f
  8018e3:	e8 5d fc ff ff       	call   801545 <syscall>
  8018e8:	83 c4 18             	add    $0x18,%esp
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 20                	push   $0x20
  8018fc:	e8 44 fc ff ff       	call   801545 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	ff 75 10             	pushl  0x10(%ebp)
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	50                   	push   %eax
  801917:	6a 21                	push   $0x21
  801919:	e8 27 fc ff ff       	call   801545 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	50                   	push   %eax
  801932:	6a 22                	push   $0x22
  801934:	e8 0c fc ff ff       	call   801545 <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	90                   	nop
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	50                   	push   %eax
  80194e:	6a 23                	push   $0x23
  801950:	e8 f0 fb ff ff       	call   801545 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	90                   	nop
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801961:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801964:	8d 50 04             	lea    0x4(%eax),%edx
  801967:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	52                   	push   %edx
  801971:	50                   	push   %eax
  801972:	6a 24                	push   $0x24
  801974:	e8 cc fb ff ff       	call   801545 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
	return result;
  80197c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80197f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801982:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801985:	89 01                	mov    %eax,(%ecx)
  801987:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	c9                   	leave  
  80198e:	c2 04 00             	ret    $0x4

00801991 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	ff 75 10             	pushl  0x10(%ebp)
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	ff 75 08             	pushl  0x8(%ebp)
  8019a1:	6a 13                	push   $0x13
  8019a3:	e8 9d fb ff ff       	call   801545 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ab:	90                   	nop
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_rcr2>:
uint32 sys_rcr2()
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 25                	push   $0x25
  8019bd:	e8 83 fb ff ff       	call   801545 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 04             	sub    $0x4,%esp
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019d3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	50                   	push   %eax
  8019e0:	6a 26                	push   $0x26
  8019e2:	e8 5e fb ff ff       	call   801545 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ea:	90                   	nop
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <rsttst>:
void rsttst()
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 28                	push   $0x28
  8019fc:	e8 44 fb ff ff       	call   801545 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
	return ;
  801a04:	90                   	nop
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 04             	sub    $0x4,%esp
  801a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a10:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a13:	8b 55 18             	mov    0x18(%ebp),%edx
  801a16:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a1a:	52                   	push   %edx
  801a1b:	50                   	push   %eax
  801a1c:	ff 75 10             	pushl  0x10(%ebp)
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	ff 75 08             	pushl  0x8(%ebp)
  801a25:	6a 27                	push   $0x27
  801a27:	e8 19 fb ff ff       	call   801545 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2f:	90                   	nop
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <chktst>:
void chktst(uint32 n)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	ff 75 08             	pushl  0x8(%ebp)
  801a40:	6a 29                	push   $0x29
  801a42:	e8 fe fa ff ff       	call   801545 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4a:	90                   	nop
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <inctst>:

void inctst()
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 2a                	push   $0x2a
  801a5c:	e8 e4 fa ff ff       	call   801545 <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
	return ;
  801a64:	90                   	nop
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <gettst>:
uint32 gettst()
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 2b                	push   $0x2b
  801a76:	e8 ca fa ff ff       	call   801545 <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 2c                	push   $0x2c
  801a92:	e8 ae fa ff ff       	call   801545 <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
  801a9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a9d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801aa1:	75 07                	jne    801aaa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801aa3:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa8:	eb 05                	jmp    801aaf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801aaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 2c                	push   $0x2c
  801ac3:	e8 7d fa ff ff       	call   801545 <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
  801acb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ace:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ad2:	75 07                	jne    801adb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ad4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad9:	eb 05                	jmp    801ae0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801adb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 2c                	push   $0x2c
  801af4:	e8 4c fa ff ff       	call   801545 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
  801afc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801aff:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b03:	75 07                	jne    801b0c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b05:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0a:	eb 05                	jmp    801b11 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 2c                	push   $0x2c
  801b25:	e8 1b fa ff ff       	call   801545 <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
  801b2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b30:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b34:	75 07                	jne    801b3d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b36:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3b:	eb 05                	jmp    801b42 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	ff 75 08             	pushl  0x8(%ebp)
  801b52:	6a 2d                	push   $0x2d
  801b54:	e8 ec f9 ff ff       	call   801545 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5c:	90                   	nop
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b63:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b66:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	53                   	push   %ebx
  801b72:	51                   	push   %ecx
  801b73:	52                   	push   %edx
  801b74:	50                   	push   %eax
  801b75:	6a 2e                	push   $0x2e
  801b77:	e8 c9 f9 ff ff       	call   801545 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	52                   	push   %edx
  801b94:	50                   	push   %eax
  801b95:	6a 2f                	push   $0x2f
  801b97:	e8 a9 f9 ff ff       	call   801545 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  801baa:	89 d0                	mov    %edx,%eax
  801bac:	c1 e0 02             	shl    $0x2,%eax
  801baf:	01 d0                	add    %edx,%eax
  801bb1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bb8:	01 d0                	add    %edx,%eax
  801bba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bc1:	01 d0                	add    %edx,%eax
  801bc3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bca:	01 d0                	add    %edx,%eax
  801bcc:	c1 e0 04             	shl    $0x4,%eax
  801bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801bd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801bd9:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801bdc:	83 ec 0c             	sub    $0xc,%esp
  801bdf:	50                   	push   %eax
  801be0:	e8 76 fd ff ff       	call   80195b <sys_get_virtual_time>
  801be5:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801be8:	eb 41                	jmp    801c2b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801bea:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801bed:	83 ec 0c             	sub    $0xc,%esp
  801bf0:	50                   	push   %eax
  801bf1:	e8 65 fd ff ff       	call   80195b <sys_get_virtual_time>
  801bf6:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801bf9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bff:	29 c2                	sub    %eax,%edx
  801c01:	89 d0                	mov    %edx,%eax
  801c03:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801c06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c0c:	89 d1                	mov    %edx,%ecx
  801c0e:	29 c1                	sub    %eax,%ecx
  801c10:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c16:	39 c2                	cmp    %eax,%edx
  801c18:	0f 97 c0             	seta   %al
  801c1b:	0f b6 c0             	movzbl %al,%eax
  801c1e:	29 c1                	sub    %eax,%ecx
  801c20:	89 c8                	mov    %ecx,%eax
  801c22:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801c25:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c31:	72 b7                	jb     801bea <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801c33:	90                   	nop
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801c3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801c43:	eb 03                	jmp    801c48 <busy_wait+0x12>
  801c45:	ff 45 fc             	incl   -0x4(%ebp)
  801c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c4e:	72 f5                	jb     801c45 <busy_wait+0xf>
	return i;
  801c50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    
  801c55:	66 90                	xchg   %ax,%ax
  801c57:	90                   	nop

00801c58 <__udivdi3>:
  801c58:	55                   	push   %ebp
  801c59:	57                   	push   %edi
  801c5a:	56                   	push   %esi
  801c5b:	53                   	push   %ebx
  801c5c:	83 ec 1c             	sub    $0x1c,%esp
  801c5f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c63:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c6f:	89 ca                	mov    %ecx,%edx
  801c71:	89 f8                	mov    %edi,%eax
  801c73:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c77:	85 f6                	test   %esi,%esi
  801c79:	75 2d                	jne    801ca8 <__udivdi3+0x50>
  801c7b:	39 cf                	cmp    %ecx,%edi
  801c7d:	77 65                	ja     801ce4 <__udivdi3+0x8c>
  801c7f:	89 fd                	mov    %edi,%ebp
  801c81:	85 ff                	test   %edi,%edi
  801c83:	75 0b                	jne    801c90 <__udivdi3+0x38>
  801c85:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8a:	31 d2                	xor    %edx,%edx
  801c8c:	f7 f7                	div    %edi
  801c8e:	89 c5                	mov    %eax,%ebp
  801c90:	31 d2                	xor    %edx,%edx
  801c92:	89 c8                	mov    %ecx,%eax
  801c94:	f7 f5                	div    %ebp
  801c96:	89 c1                	mov    %eax,%ecx
  801c98:	89 d8                	mov    %ebx,%eax
  801c9a:	f7 f5                	div    %ebp
  801c9c:	89 cf                	mov    %ecx,%edi
  801c9e:	89 fa                	mov    %edi,%edx
  801ca0:	83 c4 1c             	add    $0x1c,%esp
  801ca3:	5b                   	pop    %ebx
  801ca4:	5e                   	pop    %esi
  801ca5:	5f                   	pop    %edi
  801ca6:	5d                   	pop    %ebp
  801ca7:	c3                   	ret    
  801ca8:	39 ce                	cmp    %ecx,%esi
  801caa:	77 28                	ja     801cd4 <__udivdi3+0x7c>
  801cac:	0f bd fe             	bsr    %esi,%edi
  801caf:	83 f7 1f             	xor    $0x1f,%edi
  801cb2:	75 40                	jne    801cf4 <__udivdi3+0x9c>
  801cb4:	39 ce                	cmp    %ecx,%esi
  801cb6:	72 0a                	jb     801cc2 <__udivdi3+0x6a>
  801cb8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cbc:	0f 87 9e 00 00 00    	ja     801d60 <__udivdi3+0x108>
  801cc2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc7:	89 fa                	mov    %edi,%edx
  801cc9:	83 c4 1c             	add    $0x1c,%esp
  801ccc:	5b                   	pop    %ebx
  801ccd:	5e                   	pop    %esi
  801cce:	5f                   	pop    %edi
  801ccf:	5d                   	pop    %ebp
  801cd0:	c3                   	ret    
  801cd1:	8d 76 00             	lea    0x0(%esi),%esi
  801cd4:	31 ff                	xor    %edi,%edi
  801cd6:	31 c0                	xor    %eax,%eax
  801cd8:	89 fa                	mov    %edi,%edx
  801cda:	83 c4 1c             	add    $0x1c,%esp
  801cdd:	5b                   	pop    %ebx
  801cde:	5e                   	pop    %esi
  801cdf:	5f                   	pop    %edi
  801ce0:	5d                   	pop    %ebp
  801ce1:	c3                   	ret    
  801ce2:	66 90                	xchg   %ax,%ax
  801ce4:	89 d8                	mov    %ebx,%eax
  801ce6:	f7 f7                	div    %edi
  801ce8:	31 ff                	xor    %edi,%edi
  801cea:	89 fa                	mov    %edi,%edx
  801cec:	83 c4 1c             	add    $0x1c,%esp
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5f                   	pop    %edi
  801cf2:	5d                   	pop    %ebp
  801cf3:	c3                   	ret    
  801cf4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cf9:	89 eb                	mov    %ebp,%ebx
  801cfb:	29 fb                	sub    %edi,%ebx
  801cfd:	89 f9                	mov    %edi,%ecx
  801cff:	d3 e6                	shl    %cl,%esi
  801d01:	89 c5                	mov    %eax,%ebp
  801d03:	88 d9                	mov    %bl,%cl
  801d05:	d3 ed                	shr    %cl,%ebp
  801d07:	89 e9                	mov    %ebp,%ecx
  801d09:	09 f1                	or     %esi,%ecx
  801d0b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d0f:	89 f9                	mov    %edi,%ecx
  801d11:	d3 e0                	shl    %cl,%eax
  801d13:	89 c5                	mov    %eax,%ebp
  801d15:	89 d6                	mov    %edx,%esi
  801d17:	88 d9                	mov    %bl,%cl
  801d19:	d3 ee                	shr    %cl,%esi
  801d1b:	89 f9                	mov    %edi,%ecx
  801d1d:	d3 e2                	shl    %cl,%edx
  801d1f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d23:	88 d9                	mov    %bl,%cl
  801d25:	d3 e8                	shr    %cl,%eax
  801d27:	09 c2                	or     %eax,%edx
  801d29:	89 d0                	mov    %edx,%eax
  801d2b:	89 f2                	mov    %esi,%edx
  801d2d:	f7 74 24 0c          	divl   0xc(%esp)
  801d31:	89 d6                	mov    %edx,%esi
  801d33:	89 c3                	mov    %eax,%ebx
  801d35:	f7 e5                	mul    %ebp
  801d37:	39 d6                	cmp    %edx,%esi
  801d39:	72 19                	jb     801d54 <__udivdi3+0xfc>
  801d3b:	74 0b                	je     801d48 <__udivdi3+0xf0>
  801d3d:	89 d8                	mov    %ebx,%eax
  801d3f:	31 ff                	xor    %edi,%edi
  801d41:	e9 58 ff ff ff       	jmp    801c9e <__udivdi3+0x46>
  801d46:	66 90                	xchg   %ax,%ax
  801d48:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d4c:	89 f9                	mov    %edi,%ecx
  801d4e:	d3 e2                	shl    %cl,%edx
  801d50:	39 c2                	cmp    %eax,%edx
  801d52:	73 e9                	jae    801d3d <__udivdi3+0xe5>
  801d54:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d57:	31 ff                	xor    %edi,%edi
  801d59:	e9 40 ff ff ff       	jmp    801c9e <__udivdi3+0x46>
  801d5e:	66 90                	xchg   %ax,%ax
  801d60:	31 c0                	xor    %eax,%eax
  801d62:	e9 37 ff ff ff       	jmp    801c9e <__udivdi3+0x46>
  801d67:	90                   	nop

00801d68 <__umoddi3>:
  801d68:	55                   	push   %ebp
  801d69:	57                   	push   %edi
  801d6a:	56                   	push   %esi
  801d6b:	53                   	push   %ebx
  801d6c:	83 ec 1c             	sub    $0x1c,%esp
  801d6f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d73:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d87:	89 f3                	mov    %esi,%ebx
  801d89:	89 fa                	mov    %edi,%edx
  801d8b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d8f:	89 34 24             	mov    %esi,(%esp)
  801d92:	85 c0                	test   %eax,%eax
  801d94:	75 1a                	jne    801db0 <__umoddi3+0x48>
  801d96:	39 f7                	cmp    %esi,%edi
  801d98:	0f 86 a2 00 00 00    	jbe    801e40 <__umoddi3+0xd8>
  801d9e:	89 c8                	mov    %ecx,%eax
  801da0:	89 f2                	mov    %esi,%edx
  801da2:	f7 f7                	div    %edi
  801da4:	89 d0                	mov    %edx,%eax
  801da6:	31 d2                	xor    %edx,%edx
  801da8:	83 c4 1c             	add    $0x1c,%esp
  801dab:	5b                   	pop    %ebx
  801dac:	5e                   	pop    %esi
  801dad:	5f                   	pop    %edi
  801dae:	5d                   	pop    %ebp
  801daf:	c3                   	ret    
  801db0:	39 f0                	cmp    %esi,%eax
  801db2:	0f 87 ac 00 00 00    	ja     801e64 <__umoddi3+0xfc>
  801db8:	0f bd e8             	bsr    %eax,%ebp
  801dbb:	83 f5 1f             	xor    $0x1f,%ebp
  801dbe:	0f 84 ac 00 00 00    	je     801e70 <__umoddi3+0x108>
  801dc4:	bf 20 00 00 00       	mov    $0x20,%edi
  801dc9:	29 ef                	sub    %ebp,%edi
  801dcb:	89 fe                	mov    %edi,%esi
  801dcd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dd1:	89 e9                	mov    %ebp,%ecx
  801dd3:	d3 e0                	shl    %cl,%eax
  801dd5:	89 d7                	mov    %edx,%edi
  801dd7:	89 f1                	mov    %esi,%ecx
  801dd9:	d3 ef                	shr    %cl,%edi
  801ddb:	09 c7                	or     %eax,%edi
  801ddd:	89 e9                	mov    %ebp,%ecx
  801ddf:	d3 e2                	shl    %cl,%edx
  801de1:	89 14 24             	mov    %edx,(%esp)
  801de4:	89 d8                	mov    %ebx,%eax
  801de6:	d3 e0                	shl    %cl,%eax
  801de8:	89 c2                	mov    %eax,%edx
  801dea:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dee:	d3 e0                	shl    %cl,%eax
  801df0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801df8:	89 f1                	mov    %esi,%ecx
  801dfa:	d3 e8                	shr    %cl,%eax
  801dfc:	09 d0                	or     %edx,%eax
  801dfe:	d3 eb                	shr    %cl,%ebx
  801e00:	89 da                	mov    %ebx,%edx
  801e02:	f7 f7                	div    %edi
  801e04:	89 d3                	mov    %edx,%ebx
  801e06:	f7 24 24             	mull   (%esp)
  801e09:	89 c6                	mov    %eax,%esi
  801e0b:	89 d1                	mov    %edx,%ecx
  801e0d:	39 d3                	cmp    %edx,%ebx
  801e0f:	0f 82 87 00 00 00    	jb     801e9c <__umoddi3+0x134>
  801e15:	0f 84 91 00 00 00    	je     801eac <__umoddi3+0x144>
  801e1b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e1f:	29 f2                	sub    %esi,%edx
  801e21:	19 cb                	sbb    %ecx,%ebx
  801e23:	89 d8                	mov    %ebx,%eax
  801e25:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e29:	d3 e0                	shl    %cl,%eax
  801e2b:	89 e9                	mov    %ebp,%ecx
  801e2d:	d3 ea                	shr    %cl,%edx
  801e2f:	09 d0                	or     %edx,%eax
  801e31:	89 e9                	mov    %ebp,%ecx
  801e33:	d3 eb                	shr    %cl,%ebx
  801e35:	89 da                	mov    %ebx,%edx
  801e37:	83 c4 1c             	add    $0x1c,%esp
  801e3a:	5b                   	pop    %ebx
  801e3b:	5e                   	pop    %esi
  801e3c:	5f                   	pop    %edi
  801e3d:	5d                   	pop    %ebp
  801e3e:	c3                   	ret    
  801e3f:	90                   	nop
  801e40:	89 fd                	mov    %edi,%ebp
  801e42:	85 ff                	test   %edi,%edi
  801e44:	75 0b                	jne    801e51 <__umoddi3+0xe9>
  801e46:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4b:	31 d2                	xor    %edx,%edx
  801e4d:	f7 f7                	div    %edi
  801e4f:	89 c5                	mov    %eax,%ebp
  801e51:	89 f0                	mov    %esi,%eax
  801e53:	31 d2                	xor    %edx,%edx
  801e55:	f7 f5                	div    %ebp
  801e57:	89 c8                	mov    %ecx,%eax
  801e59:	f7 f5                	div    %ebp
  801e5b:	89 d0                	mov    %edx,%eax
  801e5d:	e9 44 ff ff ff       	jmp    801da6 <__umoddi3+0x3e>
  801e62:	66 90                	xchg   %ax,%ax
  801e64:	89 c8                	mov    %ecx,%eax
  801e66:	89 f2                	mov    %esi,%edx
  801e68:	83 c4 1c             	add    $0x1c,%esp
  801e6b:	5b                   	pop    %ebx
  801e6c:	5e                   	pop    %esi
  801e6d:	5f                   	pop    %edi
  801e6e:	5d                   	pop    %ebp
  801e6f:	c3                   	ret    
  801e70:	3b 04 24             	cmp    (%esp),%eax
  801e73:	72 06                	jb     801e7b <__umoddi3+0x113>
  801e75:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e79:	77 0f                	ja     801e8a <__umoddi3+0x122>
  801e7b:	89 f2                	mov    %esi,%edx
  801e7d:	29 f9                	sub    %edi,%ecx
  801e7f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e83:	89 14 24             	mov    %edx,(%esp)
  801e86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e8a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e8e:	8b 14 24             	mov    (%esp),%edx
  801e91:	83 c4 1c             	add    $0x1c,%esp
  801e94:	5b                   	pop    %ebx
  801e95:	5e                   	pop    %esi
  801e96:	5f                   	pop    %edi
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    
  801e99:	8d 76 00             	lea    0x0(%esi),%esi
  801e9c:	2b 04 24             	sub    (%esp),%eax
  801e9f:	19 fa                	sbb    %edi,%edx
  801ea1:	89 d1                	mov    %edx,%ecx
  801ea3:	89 c6                	mov    %eax,%esi
  801ea5:	e9 71 ff ff ff       	jmp    801e1b <__umoddi3+0xb3>
  801eaa:	66 90                	xchg   %ax,%ax
  801eac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801eb0:	72 ea                	jb     801e9c <__umoddi3+0x134>
  801eb2:	89 d9                	mov    %ebx,%ecx
  801eb4:	e9 62 ff ff ff       	jmp    801e1b <__umoddi3+0xb3>
