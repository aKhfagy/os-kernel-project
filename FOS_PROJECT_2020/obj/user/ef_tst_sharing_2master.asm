
obj/user/ef_tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 22 03 00 00       	call   800358 <libmain>
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
  800087:	68 00 1f 80 00       	push   $0x801f00
  80008c:	6a 13                	push   $0x13
  80008e:	68 1c 1f 80 00       	push   $0x801f1c
  800093:	e8 05 04 00 00       	call   80049d <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  800098:	e8 40 16 00 00       	call   8016dd <sys_calculate_free_frames>
  80009d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	6a 00                	push   $0x0
  8000a5:	6a 04                	push   $0x4
  8000a7:	68 3a 1f 80 00       	push   $0x801f3a
  8000ac:	e8 32 14 00 00       	call   8014e3 <smalloc>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000b7:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000be:	74 14                	je     8000d4 <_main+0x9c>
  8000c0:	83 ec 04             	sub    $0x4,%esp
  8000c3:	68 3c 1f 80 00       	push   $0x801f3c
  8000c8:	6a 1a                	push   $0x1a
  8000ca:	68 1c 1f 80 00       	push   $0x801f1c
  8000cf:	e8 c9 03 00 00       	call   80049d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000d4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d7:	e8 01 16 00 00       	call   8016dd <sys_calculate_free_frames>
  8000dc:	29 c3                	sub    %eax,%ebx
  8000de:	89 d8                	mov    %ebx,%eax
  8000e0:	83 f8 04             	cmp    $0x4,%eax
  8000e3:	74 28                	je     80010d <_main+0xd5>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 f0 15 00 00       	call   8016dd <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	e8 e9 15 00 00       	call   8016dd <sys_calculate_free_frames>
  8000f4:	83 ec 08             	sub    $0x8,%esp
  8000f7:	53                   	push   %ebx
  8000f8:	50                   	push   %eax
  8000f9:	ff 75 ec             	pushl  -0x14(%ebp)
  8000fc:	68 a0 1f 80 00       	push   $0x801fa0
  800101:	6a 1b                	push   $0x1b
  800103:	68 1c 1f 80 00       	push   $0x801f1c
  800108:	e8 90 03 00 00       	call   80049d <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80010d:	e8 cb 15 00 00       	call   8016dd <sys_calculate_free_frames>
  800112:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800115:	83 ec 04             	sub    $0x4,%esp
  800118:	6a 00                	push   $0x0
  80011a:	6a 04                	push   $0x4
  80011c:	68 31 20 80 00       	push   $0x802031
  800121:	e8 bd 13 00 00       	call   8014e3 <smalloc>
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012c:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800133:	74 14                	je     800149 <_main+0x111>
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 3c 1f 80 00       	push   $0x801f3c
  80013d:	6a 20                	push   $0x20
  80013f:	68 1c 1f 80 00       	push   $0x801f1c
  800144:	e8 54 03 00 00       	call   80049d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  800149:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80014c:	e8 8c 15 00 00       	call   8016dd <sys_calculate_free_frames>
  800151:	29 c3                	sub    %eax,%ebx
  800153:	89 d8                	mov    %ebx,%eax
  800155:	83 f8 03             	cmp    $0x3,%eax
  800158:	74 28                	je     800182 <_main+0x14a>
  80015a:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80015d:	e8 7b 15 00 00       	call   8016dd <sys_calculate_free_frames>
  800162:	29 c3                	sub    %eax,%ebx
  800164:	e8 74 15 00 00       	call   8016dd <sys_calculate_free_frames>
  800169:	83 ec 08             	sub    $0x8,%esp
  80016c:	53                   	push   %ebx
  80016d:	50                   	push   %eax
  80016e:	ff 75 ec             	pushl  -0x14(%ebp)
  800171:	68 a0 1f 80 00       	push   $0x801fa0
  800176:	6a 21                	push   $0x21
  800178:	68 1c 1f 80 00       	push   $0x801f1c
  80017d:	e8 1b 03 00 00       	call   80049d <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800182:	e8 56 15 00 00       	call   8016dd <sys_calculate_free_frames>
  800187:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  80018a:	83 ec 04             	sub    $0x4,%esp
  80018d:	6a 01                	push   $0x1
  80018f:	6a 04                	push   $0x4
  800191:	68 33 20 80 00       	push   $0x802033
  800196:	e8 48 13 00 00       	call   8014e3 <smalloc>
  80019b:	83 c4 10             	add    $0x10,%esp
  80019e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001a1:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  8001a8:	74 14                	je     8001be <_main+0x186>
  8001aa:	83 ec 04             	sub    $0x4,%esp
  8001ad:	68 3c 1f 80 00       	push   $0x801f3c
  8001b2:	6a 26                	push   $0x26
  8001b4:	68 1c 1f 80 00       	push   $0x801f1c
  8001b9:	e8 df 02 00 00       	call   80049d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001be:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001c1:	e8 17 15 00 00       	call   8016dd <sys_calculate_free_frames>
  8001c6:	29 c3                	sub    %eax,%ebx
  8001c8:	89 d8                	mov    %ebx,%eax
  8001ca:	83 f8 03             	cmp    $0x3,%eax
  8001cd:	74 14                	je     8001e3 <_main+0x1ab>
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	68 38 20 80 00       	push   $0x802038
  8001d7:	6a 27                	push   $0x27
  8001d9:	68 1c 1f 80 00       	push   $0x801f1c
  8001de:	e8 ba 02 00 00       	call   80049d <_panic>

	*x = 10 ;
  8001e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001e6:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ef:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size), 50);
  8001f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fa:	8b 40 74             	mov    0x74(%eax),%eax
  8001fd:	83 ec 04             	sub    $0x4,%esp
  800200:	6a 32                	push   $0x32
  800202:	50                   	push   %eax
  800203:	68 c0 20 80 00       	push   $0x8020c0
  800208:	e8 25 17 00 00       	call   801932 <sys_create_env>
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size), 50);
  800213:	a1 20 30 80 00       	mov    0x803020,%eax
  800218:	8b 40 74             	mov    0x74(%eax),%eax
  80021b:	83 ec 04             	sub    $0x4,%esp
  80021e:	6a 32                	push   $0x32
  800220:	50                   	push   %eax
  800221:	68 c0 20 80 00       	push   $0x8020c0
  800226:	e8 07 17 00 00       	call   801932 <sys_create_env>
  80022b:	83 c4 10             	add    $0x10,%esp
  80022e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size), 50);
  800231:	a1 20 30 80 00       	mov    0x803020,%eax
  800236:	8b 40 74             	mov    0x74(%eax),%eax
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	6a 32                	push   $0x32
  80023e:	50                   	push   %eax
  80023f:	68 c0 20 80 00       	push   $0x8020c0
  800244:	e8 e9 16 00 00       	call   801932 <sys_create_env>
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  80024f:	e8 c5 17 00 00       	call   801a19 <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  800254:	83 ec 04             	sub    $0x4,%esp
  800257:	6a 01                	push   $0x1
  800259:	6a 04                	push   $0x4
  80025b:	68 ce 20 80 00       	push   $0x8020ce
  800260:	e8 7e 12 00 00       	call   8014e3 <smalloc>
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	ff 75 dc             	pushl  -0x24(%ebp)
  800271:	e8 d9 16 00 00       	call   80194f <sys_run_env>
  800276:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800279:	83 ec 0c             	sub    $0xc,%esp
  80027c:	ff 75 d8             	pushl  -0x28(%ebp)
  80027f:	e8 cb 16 00 00       	call   80194f <sys_run_env>
  800284:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80028d:	e8 bd 16 00 00       	call   80194f <sys_run_env>
  800292:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 98 3a 00 00       	push   $0x3a98
  80029d:	e8 2b 19 00 00       	call   801bcd <env_sleep>
  8002a2:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002a5:	e8 e9 17 00 00       	call   801a93 <gettst>
  8002aa:	83 f8 03             	cmp    $0x3,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 de 20 80 00       	push   $0x8020de
  8002b7:	6a 3d                	push   $0x3d
  8002b9:	68 1c 1f 80 00       	push   $0x801f1c
  8002be:	e8 da 01 00 00       	call   80049d <_panic>


	if (*z != 30)
  8002c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c6:	8b 00                	mov    (%eax),%eax
  8002c8:	83 f8 1e             	cmp    $0x1e,%eax
  8002cb:	74 14                	je     8002e1 <_main+0x2a9>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 ec 20 80 00       	push   $0x8020ec
  8002d5:	6a 41                	push   $0x41
  8002d7:	68 1c 1f 80 00       	push   $0x801f1c
  8002dc:	e8 bc 01 00 00       	call   80049d <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002e1:	83 ec 0c             	sub    $0xc,%esp
  8002e4:	68 3c 21 80 00       	push   $0x80213c
  8002e9:	e8 51 04 00 00       	call   80073f <cprintf>
  8002ee:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  8002f1:	e8 35 13 00 00       	call   80162b <sys_getparentenvid>
  8002f6:	85 c0                	test   %eax,%eax
  8002f8:	7e 58                	jle    800352 <_main+0x31a>
		sys_free_env(id1);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	ff 75 dc             	pushl  -0x24(%ebp)
  800300:	e8 66 16 00 00       	call   80196b <sys_free_env>
  800305:	83 c4 10             	add    $0x10,%esp
		sys_free_env(id2);
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	ff 75 d8             	pushl  -0x28(%ebp)
  80030e:	e8 58 16 00 00       	call   80196b <sys_free_env>
  800313:	83 c4 10             	add    $0x10,%esp
		sys_free_env(id3);
  800316:	83 ec 0c             	sub    $0xc,%esp
  800319:	ff 75 d4             	pushl  -0x2c(%ebp)
  80031c:	e8 4a 16 00 00       	call   80196b <sys_free_env>
  800321:	83 c4 10             	add    $0x10,%esp
		int *finishedCount = NULL;
  800324:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  80032b:	e8 fb 12 00 00       	call   80162b <sys_getparentenvid>
  800330:	83 ec 08             	sub    $0x8,%esp
  800333:	68 96 21 80 00       	push   $0x802196
  800338:	50                   	push   %eax
  800339:	e8 c5 11 00 00       	call   801503 <sget>
  80033e:	83 c4 10             	add    $0x10,%esp
  800341:	89 45 cc             	mov    %eax,-0x34(%ebp)
		(*finishedCount)++ ;
  800344:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800347:	8b 00                	mov    (%eax),%eax
  800349:	8d 50 01             	lea    0x1(%eax),%edx
  80034c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80034f:	89 10                	mov    %edx,(%eax)
	}
	return;
  800351:	90                   	nop
  800352:	90                   	nop
}
  800353:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800356:	c9                   	leave  
  800357:	c3                   	ret    

00800358 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800358:	55                   	push   %ebp
  800359:	89 e5                	mov    %esp,%ebp
  80035b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80035e:	e8 af 12 00 00       	call   801612 <sys_getenvindex>
  800363:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800366:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800369:	89 d0                	mov    %edx,%eax
  80036b:	c1 e0 03             	shl    $0x3,%eax
  80036e:	01 d0                	add    %edx,%eax
  800370:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800377:	01 c8                	add    %ecx,%eax
  800379:	01 c0                	add    %eax,%eax
  80037b:	01 d0                	add    %edx,%eax
  80037d:	01 c0                	add    %eax,%eax
  80037f:	01 d0                	add    %edx,%eax
  800381:	89 c2                	mov    %eax,%edx
  800383:	c1 e2 05             	shl    $0x5,%edx
  800386:	29 c2                	sub    %eax,%edx
  800388:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80038f:	89 c2                	mov    %eax,%edx
  800391:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800397:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80039c:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a1:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8003a7:	84 c0                	test   %al,%al
  8003a9:	74 0f                	je     8003ba <libmain+0x62>
		binaryname = myEnv->prog_name;
  8003ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b0:	05 40 3c 01 00       	add    $0x13c40,%eax
  8003b5:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003be:	7e 0a                	jle    8003ca <libmain+0x72>
		binaryname = argv[0];
  8003c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c3:	8b 00                	mov    (%eax),%eax
  8003c5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8003ca:	83 ec 08             	sub    $0x8,%esp
  8003cd:	ff 75 0c             	pushl  0xc(%ebp)
  8003d0:	ff 75 08             	pushl  0x8(%ebp)
  8003d3:	e8 60 fc ff ff       	call   800038 <_main>
  8003d8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003db:	e8 cd 13 00 00       	call   8017ad <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003e0:	83 ec 0c             	sub    $0xc,%esp
  8003e3:	68 bc 21 80 00       	push   $0x8021bc
  8003e8:	e8 52 03 00 00       	call   80073f <cprintf>
  8003ed:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f5:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8003fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800400:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800406:	83 ec 04             	sub    $0x4,%esp
  800409:	52                   	push   %edx
  80040a:	50                   	push   %eax
  80040b:	68 e4 21 80 00       	push   $0x8021e4
  800410:	e8 2a 03 00 00       	call   80073f <cprintf>
  800415:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800418:	a1 20 30 80 00       	mov    0x803020,%eax
  80041d:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800423:	a1 20 30 80 00       	mov    0x803020,%eax
  800428:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	52                   	push   %edx
  800432:	50                   	push   %eax
  800433:	68 0c 22 80 00       	push   $0x80220c
  800438:	e8 02 03 00 00       	call   80073f <cprintf>
  80043d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800440:	a1 20 30 80 00       	mov    0x803020,%eax
  800445:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	50                   	push   %eax
  80044f:	68 4d 22 80 00       	push   $0x80224d
  800454:	e8 e6 02 00 00       	call   80073f <cprintf>
  800459:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80045c:	83 ec 0c             	sub    $0xc,%esp
  80045f:	68 bc 21 80 00       	push   $0x8021bc
  800464:	e8 d6 02 00 00       	call   80073f <cprintf>
  800469:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80046c:	e8 56 13 00 00       	call   8017c7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800471:	e8 19 00 00 00       	call   80048f <exit>
}
  800476:	90                   	nop
  800477:	c9                   	leave  
  800478:	c3                   	ret    

00800479 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	6a 00                	push   $0x0
  800484:	e8 55 11 00 00       	call   8015de <sys_env_destroy>
  800489:	83 c4 10             	add    $0x10,%esp
}
  80048c:	90                   	nop
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <exit>:

void
exit(void)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800495:	e8 aa 11 00 00       	call   801644 <sys_env_exit>
}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8004a6:	83 c0 04             	add    $0x4,%eax
  8004a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004ac:	a1 18 31 80 00       	mov    0x803118,%eax
  8004b1:	85 c0                	test   %eax,%eax
  8004b3:	74 16                	je     8004cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004b5:	a1 18 31 80 00       	mov    0x803118,%eax
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	50                   	push   %eax
  8004be:	68 64 22 80 00       	push   $0x802264
  8004c3:	e8 77 02 00 00       	call   80073f <cprintf>
  8004c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004cb:	a1 00 30 80 00       	mov    0x803000,%eax
  8004d0:	ff 75 0c             	pushl  0xc(%ebp)
  8004d3:	ff 75 08             	pushl  0x8(%ebp)
  8004d6:	50                   	push   %eax
  8004d7:	68 69 22 80 00       	push   $0x802269
  8004dc:	e8 5e 02 00 00       	call   80073f <cprintf>
  8004e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e7:	83 ec 08             	sub    $0x8,%esp
  8004ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ed:	50                   	push   %eax
  8004ee:	e8 e1 01 00 00       	call   8006d4 <vcprintf>
  8004f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	6a 00                	push   $0x0
  8004fb:	68 85 22 80 00       	push   $0x802285
  800500:	e8 cf 01 00 00       	call   8006d4 <vcprintf>
  800505:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800508:	e8 82 ff ff ff       	call   80048f <exit>

	// should not return here
	while (1) ;
  80050d:	eb fe                	jmp    80050d <_panic+0x70>

0080050f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800515:	a1 20 30 80 00       	mov    0x803020,%eax
  80051a:	8b 50 74             	mov    0x74(%eax),%edx
  80051d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800520:	39 c2                	cmp    %eax,%edx
  800522:	74 14                	je     800538 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800524:	83 ec 04             	sub    $0x4,%esp
  800527:	68 88 22 80 00       	push   $0x802288
  80052c:	6a 26                	push   $0x26
  80052e:	68 d4 22 80 00       	push   $0x8022d4
  800533:	e8 65 ff ff ff       	call   80049d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800538:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80053f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800546:	e9 b6 00 00 00       	jmp    800601 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800555:	8b 45 08             	mov    0x8(%ebp),%eax
  800558:	01 d0                	add    %edx,%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	85 c0                	test   %eax,%eax
  80055e:	75 08                	jne    800568 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800560:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800563:	e9 96 00 00 00       	jmp    8005fe <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800568:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800576:	eb 5d                	jmp    8005d5 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800578:	a1 20 30 80 00       	mov    0x803020,%eax
  80057d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800583:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800586:	c1 e2 04             	shl    $0x4,%edx
  800589:	01 d0                	add    %edx,%eax
  80058b:	8a 40 04             	mov    0x4(%eax),%al
  80058e:	84 c0                	test   %al,%al
  800590:	75 40                	jne    8005d2 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800592:	a1 20 30 80 00       	mov    0x803020,%eax
  800597:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80059d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a0:	c1 e2 04             	shl    $0x4,%edx
  8005a3:	01 d0                	add    %edx,%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005be:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c1:	01 c8                	add    %ecx,%eax
  8005c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005c5:	39 c2                	cmp    %eax,%edx
  8005c7:	75 09                	jne    8005d2 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8005c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005d0:	eb 12                	jmp    8005e4 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d2:	ff 45 e8             	incl   -0x18(%ebp)
  8005d5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005da:	8b 50 74             	mov    0x74(%eax),%edx
  8005dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e0:	39 c2                	cmp    %eax,%edx
  8005e2:	77 94                	ja     800578 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005e8:	75 14                	jne    8005fe <CheckWSWithoutLastIndex+0xef>
			panic(
  8005ea:	83 ec 04             	sub    $0x4,%esp
  8005ed:	68 e0 22 80 00       	push   $0x8022e0
  8005f2:	6a 3a                	push   $0x3a
  8005f4:	68 d4 22 80 00       	push   $0x8022d4
  8005f9:	e8 9f fe ff ff       	call   80049d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005fe:	ff 45 f0             	incl   -0x10(%ebp)
  800601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800604:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800607:	0f 8c 3e ff ff ff    	jl     80054b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80060d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800614:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80061b:	eb 20                	jmp    80063d <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80061d:	a1 20 30 80 00       	mov    0x803020,%eax
  800622:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800628:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062b:	c1 e2 04             	shl    $0x4,%edx
  80062e:	01 d0                	add    %edx,%eax
  800630:	8a 40 04             	mov    0x4(%eax),%al
  800633:	3c 01                	cmp    $0x1,%al
  800635:	75 03                	jne    80063a <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800637:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063a:	ff 45 e0             	incl   -0x20(%ebp)
  80063d:	a1 20 30 80 00       	mov    0x803020,%eax
  800642:	8b 50 74             	mov    0x74(%eax),%edx
  800645:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800648:	39 c2                	cmp    %eax,%edx
  80064a:	77 d1                	ja     80061d <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80064c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800652:	74 14                	je     800668 <CheckWSWithoutLastIndex+0x159>
		panic(
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	68 34 23 80 00       	push   $0x802334
  80065c:	6a 44                	push   $0x44
  80065e:	68 d4 22 80 00       	push   $0x8022d4
  800663:	e8 35 fe ff ff       	call   80049d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800668:	90                   	nop
  800669:	c9                   	leave  
  80066a:	c3                   	ret    

0080066b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80066b:	55                   	push   %ebp
  80066c:	89 e5                	mov    %esp,%ebp
  80066e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800671:	8b 45 0c             	mov    0xc(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	8d 48 01             	lea    0x1(%eax),%ecx
  800679:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067c:	89 0a                	mov    %ecx,(%edx)
  80067e:	8b 55 08             	mov    0x8(%ebp),%edx
  800681:	88 d1                	mov    %dl,%cl
  800683:	8b 55 0c             	mov    0xc(%ebp),%edx
  800686:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80068a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800694:	75 2c                	jne    8006c2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800696:	a0 24 30 80 00       	mov    0x803024,%al
  80069b:	0f b6 c0             	movzbl %al,%eax
  80069e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a1:	8b 12                	mov    (%edx),%edx
  8006a3:	89 d1                	mov    %edx,%ecx
  8006a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a8:	83 c2 08             	add    $0x8,%edx
  8006ab:	83 ec 04             	sub    $0x4,%esp
  8006ae:	50                   	push   %eax
  8006af:	51                   	push   %ecx
  8006b0:	52                   	push   %edx
  8006b1:	e8 e6 0e 00 00       	call   80159c <sys_cputs>
  8006b6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c5:	8b 40 04             	mov    0x4(%eax),%eax
  8006c8:	8d 50 01             	lea    0x1(%eax),%edx
  8006cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ce:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006d1:	90                   	nop
  8006d2:	c9                   	leave  
  8006d3:	c3                   	ret    

008006d4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d4:	55                   	push   %ebp
  8006d5:	89 e5                	mov    %esp,%ebp
  8006d7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e4:	00 00 00 
	b.cnt = 0;
  8006e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ee:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006f1:	ff 75 0c             	pushl  0xc(%ebp)
  8006f4:	ff 75 08             	pushl  0x8(%ebp)
  8006f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006fd:	50                   	push   %eax
  8006fe:	68 6b 06 80 00       	push   $0x80066b
  800703:	e8 11 02 00 00       	call   800919 <vprintfmt>
  800708:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80070b:	a0 24 30 80 00       	mov    0x803024,%al
  800710:	0f b6 c0             	movzbl %al,%eax
  800713:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800719:	83 ec 04             	sub    $0x4,%esp
  80071c:	50                   	push   %eax
  80071d:	52                   	push   %edx
  80071e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800724:	83 c0 08             	add    $0x8,%eax
  800727:	50                   	push   %eax
  800728:	e8 6f 0e 00 00       	call   80159c <sys_cputs>
  80072d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800730:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800737:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80073d:	c9                   	leave  
  80073e:	c3                   	ret    

0080073f <cprintf>:

int cprintf(const char *fmt, ...) {
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
  800742:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800745:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80074c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 f4             	pushl  -0xc(%ebp)
  80075b:	50                   	push   %eax
  80075c:	e8 73 ff ff ff       	call   8006d4 <vcprintf>
  800761:	83 c4 10             	add    $0x10,%esp
  800764:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800767:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80076a:	c9                   	leave  
  80076b:	c3                   	ret    

0080076c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800772:	e8 36 10 00 00       	call   8017ad <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800777:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	ff 75 f4             	pushl  -0xc(%ebp)
  800786:	50                   	push   %eax
  800787:	e8 48 ff ff ff       	call   8006d4 <vcprintf>
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800792:	e8 30 10 00 00       	call   8017c7 <sys_enable_interrupt>
	return cnt;
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079a:	c9                   	leave  
  80079b:	c3                   	ret    

0080079c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	53                   	push   %ebx
  8007a0:	83 ec 14             	sub    $0x14,%esp
  8007a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007af:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ba:	77 55                	ja     800811 <printnum+0x75>
  8007bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007bf:	72 05                	jb     8007c6 <printnum+0x2a>
  8007c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007c4:	77 4b                	ja     800811 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007c6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007cc:	8b 45 18             	mov    0x18(%ebp),%eax
  8007cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d4:	52                   	push   %edx
  8007d5:	50                   	push   %eax
  8007d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8007dc:	e8 a3 14 00 00       	call   801c84 <__udivdi3>
  8007e1:	83 c4 10             	add    $0x10,%esp
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	ff 75 20             	pushl  0x20(%ebp)
  8007ea:	53                   	push   %ebx
  8007eb:	ff 75 18             	pushl  0x18(%ebp)
  8007ee:	52                   	push   %edx
  8007ef:	50                   	push   %eax
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	ff 75 08             	pushl  0x8(%ebp)
  8007f6:	e8 a1 ff ff ff       	call   80079c <printnum>
  8007fb:	83 c4 20             	add    $0x20,%esp
  8007fe:	eb 1a                	jmp    80081a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	ff 75 20             	pushl  0x20(%ebp)
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	ff d0                	call   *%eax
  80080e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800811:	ff 4d 1c             	decl   0x1c(%ebp)
  800814:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800818:	7f e6                	jg     800800 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80081a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80081d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800825:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800828:	53                   	push   %ebx
  800829:	51                   	push   %ecx
  80082a:	52                   	push   %edx
  80082b:	50                   	push   %eax
  80082c:	e8 63 15 00 00       	call   801d94 <__umoddi3>
  800831:	83 c4 10             	add    $0x10,%esp
  800834:	05 94 25 80 00       	add    $0x802594,%eax
  800839:	8a 00                	mov    (%eax),%al
  80083b:	0f be c0             	movsbl %al,%eax
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	50                   	push   %eax
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	ff d0                	call   *%eax
  80084a:	83 c4 10             	add    $0x10,%esp
}
  80084d:	90                   	nop
  80084e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800851:	c9                   	leave  
  800852:	c3                   	ret    

00800853 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800856:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80085a:	7e 1c                	jle    800878 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	8d 50 08             	lea    0x8(%eax),%edx
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	89 10                	mov    %edx,(%eax)
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	83 e8 08             	sub    $0x8,%eax
  800871:	8b 50 04             	mov    0x4(%eax),%edx
  800874:	8b 00                	mov    (%eax),%eax
  800876:	eb 40                	jmp    8008b8 <getuint+0x65>
	else if (lflag)
  800878:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087c:	74 1e                	je     80089c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	8d 50 04             	lea    0x4(%eax),%edx
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	89 10                	mov    %edx,(%eax)
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	8b 00                	mov    (%eax),%eax
  800890:	83 e8 04             	sub    $0x4,%eax
  800893:	8b 00                	mov    (%eax),%eax
  800895:	ba 00 00 00 00       	mov    $0x0,%edx
  80089a:	eb 1c                	jmp    8008b8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	8d 50 04             	lea    0x4(%eax),%edx
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	89 10                	mov    %edx,(%eax)
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	83 e8 04             	sub    $0x4,%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b8:	5d                   	pop    %ebp
  8008b9:	c3                   	ret    

008008ba <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c1:	7e 1c                	jle    8008df <getint+0x25>
		return va_arg(*ap, long long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 08             	lea    0x8(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 08             	sub    $0x8,%eax
  8008d8:	8b 50 04             	mov    0x4(%eax),%edx
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	eb 38                	jmp    800917 <getint+0x5d>
	else if (lflag)
  8008df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e3:	74 1a                	je     8008ff <getint+0x45>
		return va_arg(*ap, long);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	99                   	cltd   
  8008fd:	eb 18                	jmp    800917 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	8d 50 04             	lea    0x4(%eax),%edx
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	89 10                	mov    %edx,(%eax)
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	83 e8 04             	sub    $0x4,%eax
  800914:	8b 00                	mov    (%eax),%eax
  800916:	99                   	cltd   
}
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	56                   	push   %esi
  80091d:	53                   	push   %ebx
  80091e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800921:	eb 17                	jmp    80093a <vprintfmt+0x21>
			if (ch == '\0')
  800923:	85 db                	test   %ebx,%ebx
  800925:	0f 84 af 03 00 00    	je     800cda <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	53                   	push   %ebx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	ff d0                	call   *%eax
  800937:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093a:	8b 45 10             	mov    0x10(%ebp),%eax
  80093d:	8d 50 01             	lea    0x1(%eax),%edx
  800940:	89 55 10             	mov    %edx,0x10(%ebp)
  800943:	8a 00                	mov    (%eax),%al
  800945:	0f b6 d8             	movzbl %al,%ebx
  800948:	83 fb 25             	cmp    $0x25,%ebx
  80094b:	75 d6                	jne    800923 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800951:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800958:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80095f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800966:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096d:	8b 45 10             	mov    0x10(%ebp),%eax
  800970:	8d 50 01             	lea    0x1(%eax),%edx
  800973:	89 55 10             	mov    %edx,0x10(%ebp)
  800976:	8a 00                	mov    (%eax),%al
  800978:	0f b6 d8             	movzbl %al,%ebx
  80097b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80097e:	83 f8 55             	cmp    $0x55,%eax
  800981:	0f 87 2b 03 00 00    	ja     800cb2 <vprintfmt+0x399>
  800987:	8b 04 85 b8 25 80 00 	mov    0x8025b8(,%eax,4),%eax
  80098e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800990:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800994:	eb d7                	jmp    80096d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800996:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80099a:	eb d1                	jmp    80096d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	c1 e0 02             	shl    $0x2,%eax
  8009ab:	01 d0                	add    %edx,%eax
  8009ad:	01 c0                	add    %eax,%eax
  8009af:	01 d8                	add    %ebx,%eax
  8009b1:	83 e8 30             	sub    $0x30,%eax
  8009b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ba:	8a 00                	mov    (%eax),%al
  8009bc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009bf:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c2:	7e 3e                	jle    800a02 <vprintfmt+0xe9>
  8009c4:	83 fb 39             	cmp    $0x39,%ebx
  8009c7:	7f 39                	jg     800a02 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009cc:	eb d5                	jmp    8009a3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d1:	83 c0 04             	add    $0x4,%eax
  8009d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009da:	83 e8 04             	sub    $0x4,%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e2:	eb 1f                	jmp    800a03 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e8:	79 83                	jns    80096d <vprintfmt+0x54>
				width = 0;
  8009ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009f1:	e9 77 ff ff ff       	jmp    80096d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009f6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009fd:	e9 6b ff ff ff       	jmp    80096d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a02:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a07:	0f 89 60 ff ff ff    	jns    80096d <vprintfmt+0x54>
				width = precision, precision = -1;
  800a0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a13:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a1a:	e9 4e ff ff ff       	jmp    80096d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a22:	e9 46 ff ff ff       	jmp    80096d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a27:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2a:	83 c0 04             	add    $0x4,%eax
  800a2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	83 e8 04             	sub    $0x4,%eax
  800a36:	8b 00                	mov    (%eax),%eax
  800a38:	83 ec 08             	sub    $0x8,%esp
  800a3b:	ff 75 0c             	pushl  0xc(%ebp)
  800a3e:	50                   	push   %eax
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	ff d0                	call   *%eax
  800a44:	83 c4 10             	add    $0x10,%esp
			break;
  800a47:	e9 89 02 00 00       	jmp    800cd5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	83 c0 04             	add    $0x4,%eax
  800a52:	89 45 14             	mov    %eax,0x14(%ebp)
  800a55:	8b 45 14             	mov    0x14(%ebp),%eax
  800a58:	83 e8 04             	sub    $0x4,%eax
  800a5b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a5d:	85 db                	test   %ebx,%ebx
  800a5f:	79 02                	jns    800a63 <vprintfmt+0x14a>
				err = -err;
  800a61:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a63:	83 fb 64             	cmp    $0x64,%ebx
  800a66:	7f 0b                	jg     800a73 <vprintfmt+0x15a>
  800a68:	8b 34 9d 00 24 80 00 	mov    0x802400(,%ebx,4),%esi
  800a6f:	85 f6                	test   %esi,%esi
  800a71:	75 19                	jne    800a8c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a73:	53                   	push   %ebx
  800a74:	68 a5 25 80 00       	push   $0x8025a5
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	ff 75 08             	pushl  0x8(%ebp)
  800a7f:	e8 5e 02 00 00       	call   800ce2 <printfmt>
  800a84:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a87:	e9 49 02 00 00       	jmp    800cd5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8c:	56                   	push   %esi
  800a8d:	68 ae 25 80 00       	push   $0x8025ae
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	ff 75 08             	pushl  0x8(%ebp)
  800a98:	e8 45 02 00 00       	call   800ce2 <printfmt>
  800a9d:	83 c4 10             	add    $0x10,%esp
			break;
  800aa0:	e9 30 02 00 00       	jmp    800cd5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa8:	83 c0 04             	add    $0x4,%eax
  800aab:	89 45 14             	mov    %eax,0x14(%ebp)
  800aae:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab1:	83 e8 04             	sub    $0x4,%eax
  800ab4:	8b 30                	mov    (%eax),%esi
  800ab6:	85 f6                	test   %esi,%esi
  800ab8:	75 05                	jne    800abf <vprintfmt+0x1a6>
				p = "(null)";
  800aba:	be b1 25 80 00       	mov    $0x8025b1,%esi
			if (width > 0 && padc != '-')
  800abf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac3:	7e 6d                	jle    800b32 <vprintfmt+0x219>
  800ac5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac9:	74 67                	je     800b32 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800acb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	50                   	push   %eax
  800ad2:	56                   	push   %esi
  800ad3:	e8 0c 03 00 00       	call   800de4 <strnlen>
  800ad8:	83 c4 10             	add    $0x10,%esp
  800adb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ade:	eb 16                	jmp    800af6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ae0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	50                   	push   %eax
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af3:	ff 4d e4             	decl   -0x1c(%ebp)
  800af6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800afa:	7f e4                	jg     800ae0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afc:	eb 34                	jmp    800b32 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800afe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b02:	74 1c                	je     800b20 <vprintfmt+0x207>
  800b04:	83 fb 1f             	cmp    $0x1f,%ebx
  800b07:	7e 05                	jle    800b0e <vprintfmt+0x1f5>
  800b09:	83 fb 7e             	cmp    $0x7e,%ebx
  800b0c:	7e 12                	jle    800b20 <vprintfmt+0x207>
					putch('?', putdat);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	ff 75 0c             	pushl  0xc(%ebp)
  800b14:	6a 3f                	push   $0x3f
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	ff d0                	call   *%eax
  800b1b:	83 c4 10             	add    $0x10,%esp
  800b1e:	eb 0f                	jmp    800b2f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b20:	83 ec 08             	sub    $0x8,%esp
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	53                   	push   %ebx
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	ff d0                	call   *%eax
  800b2c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b32:	89 f0                	mov    %esi,%eax
  800b34:	8d 70 01             	lea    0x1(%eax),%esi
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	0f be d8             	movsbl %al,%ebx
  800b3c:	85 db                	test   %ebx,%ebx
  800b3e:	74 24                	je     800b64 <vprintfmt+0x24b>
  800b40:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b44:	78 b8                	js     800afe <vprintfmt+0x1e5>
  800b46:	ff 4d e0             	decl   -0x20(%ebp)
  800b49:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4d:	79 af                	jns    800afe <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4f:	eb 13                	jmp    800b64 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b51:	83 ec 08             	sub    $0x8,%esp
  800b54:	ff 75 0c             	pushl  0xc(%ebp)
  800b57:	6a 20                	push   $0x20
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	ff d0                	call   *%eax
  800b5e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b61:	ff 4d e4             	decl   -0x1c(%ebp)
  800b64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b68:	7f e7                	jg     800b51 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b6a:	e9 66 01 00 00       	jmp    800cd5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 e8             	pushl  -0x18(%ebp)
  800b75:	8d 45 14             	lea    0x14(%ebp),%eax
  800b78:	50                   	push   %eax
  800b79:	e8 3c fd ff ff       	call   8008ba <getint>
  800b7e:	83 c4 10             	add    $0x10,%esp
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8d:	85 d2                	test   %edx,%edx
  800b8f:	79 23                	jns    800bb4 <vprintfmt+0x29b>
				putch('-', putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	6a 2d                	push   $0x2d
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba7:	f7 d8                	neg    %eax
  800ba9:	83 d2 00             	adc    $0x0,%edx
  800bac:	f7 da                	neg    %edx
  800bae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bb4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bbb:	e9 bc 00 00 00       	jmp    800c7c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bc0:	83 ec 08             	sub    $0x8,%esp
  800bc3:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc6:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc9:	50                   	push   %eax
  800bca:	e8 84 fc ff ff       	call   800853 <getuint>
  800bcf:	83 c4 10             	add    $0x10,%esp
  800bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bdf:	e9 98 00 00 00       	jmp    800c7c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be4:	83 ec 08             	sub    $0x8,%esp
  800be7:	ff 75 0c             	pushl  0xc(%ebp)
  800bea:	6a 58                	push   $0x58
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	ff d0                	call   *%eax
  800bf1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf4:	83 ec 08             	sub    $0x8,%esp
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	6a 58                	push   $0x58
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	ff d0                	call   *%eax
  800c01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c04:	83 ec 08             	sub    $0x8,%esp
  800c07:	ff 75 0c             	pushl  0xc(%ebp)
  800c0a:	6a 58                	push   $0x58
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	ff d0                	call   *%eax
  800c11:	83 c4 10             	add    $0x10,%esp
			break;
  800c14:	e9 bc 00 00 00       	jmp    800cd5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c19:	83 ec 08             	sub    $0x8,%esp
  800c1c:	ff 75 0c             	pushl  0xc(%ebp)
  800c1f:	6a 30                	push   $0x30
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	ff d0                	call   *%eax
  800c26:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c29:	83 ec 08             	sub    $0x8,%esp
  800c2c:	ff 75 0c             	pushl  0xc(%ebp)
  800c2f:	6a 78                	push   $0x78
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	ff d0                	call   *%eax
  800c36:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c39:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3c:	83 c0 04             	add    $0x4,%eax
  800c3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c42:	8b 45 14             	mov    0x14(%ebp),%eax
  800c45:	83 e8 04             	sub    $0x4,%eax
  800c48:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c5b:	eb 1f                	jmp    800c7c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5d:	83 ec 08             	sub    $0x8,%esp
  800c60:	ff 75 e8             	pushl  -0x18(%ebp)
  800c63:	8d 45 14             	lea    0x14(%ebp),%eax
  800c66:	50                   	push   %eax
  800c67:	e8 e7 fb ff ff       	call   800853 <getuint>
  800c6c:	83 c4 10             	add    $0x10,%esp
  800c6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c72:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c75:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c7c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c83:	83 ec 04             	sub    $0x4,%esp
  800c86:	52                   	push   %edx
  800c87:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c8a:	50                   	push   %eax
  800c8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8e:	ff 75 f0             	pushl  -0x10(%ebp)
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	ff 75 08             	pushl  0x8(%ebp)
  800c97:	e8 00 fb ff ff       	call   80079c <printnum>
  800c9c:	83 c4 20             	add    $0x20,%esp
			break;
  800c9f:	eb 34                	jmp    800cd5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ca1:	83 ec 08             	sub    $0x8,%esp
  800ca4:	ff 75 0c             	pushl  0xc(%ebp)
  800ca7:	53                   	push   %ebx
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	ff d0                	call   *%eax
  800cad:	83 c4 10             	add    $0x10,%esp
			break;
  800cb0:	eb 23                	jmp    800cd5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cb2:	83 ec 08             	sub    $0x8,%esp
  800cb5:	ff 75 0c             	pushl  0xc(%ebp)
  800cb8:	6a 25                	push   $0x25
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	ff d0                	call   *%eax
  800cbf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc2:	ff 4d 10             	decl   0x10(%ebp)
  800cc5:	eb 03                	jmp    800cca <vprintfmt+0x3b1>
  800cc7:	ff 4d 10             	decl   0x10(%ebp)
  800cca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccd:	48                   	dec    %eax
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	3c 25                	cmp    $0x25,%al
  800cd2:	75 f3                	jne    800cc7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cd4:	90                   	nop
		}
	}
  800cd5:	e9 47 fc ff ff       	jmp    800921 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cda:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cdb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    

00800ce2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ce8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ceb:	83 c0 04             	add    $0x4,%eax
  800cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf7:	50                   	push   %eax
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	ff 75 08             	pushl  0x8(%ebp)
  800cfe:	e8 16 fc ff ff       	call   800919 <vprintfmt>
  800d03:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d06:	90                   	nop
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0f:	8b 40 08             	mov    0x8(%eax),%eax
  800d12:	8d 50 01             	lea    0x1(%eax),%edx
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	8b 10                	mov    (%eax),%edx
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	8b 40 04             	mov    0x4(%eax),%eax
  800d26:	39 c2                	cmp    %eax,%edx
  800d28:	73 12                	jae    800d3c <sprintputch+0x33>
		*b->buf++ = ch;
  800d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2d:	8b 00                	mov    (%eax),%eax
  800d2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d35:	89 0a                	mov    %ecx,(%edx)
  800d37:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3a:	88 10                	mov    %dl,(%eax)
}
  800d3c:	90                   	nop
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	01 d0                	add    %edx,%eax
  800d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d64:	74 06                	je     800d6c <vsnprintf+0x2d>
  800d66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6a:	7f 07                	jg     800d73 <vsnprintf+0x34>
		return -E_INVAL;
  800d6c:	b8 03 00 00 00       	mov    $0x3,%eax
  800d71:	eb 20                	jmp    800d93 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d73:	ff 75 14             	pushl  0x14(%ebp)
  800d76:	ff 75 10             	pushl  0x10(%ebp)
  800d79:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d7c:	50                   	push   %eax
  800d7d:	68 09 0d 80 00       	push   $0x800d09
  800d82:	e8 92 fb ff ff       	call   800919 <vprintfmt>
  800d87:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d8d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d9b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d9e:	83 c0 04             	add    $0x4,%eax
  800da1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800da4:	8b 45 10             	mov    0x10(%ebp),%eax
  800da7:	ff 75 f4             	pushl  -0xc(%ebp)
  800daa:	50                   	push   %eax
  800dab:	ff 75 0c             	pushl  0xc(%ebp)
  800dae:	ff 75 08             	pushl  0x8(%ebp)
  800db1:	e8 89 ff ff ff       	call   800d3f <vsnprintf>
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dbf:	c9                   	leave  
  800dc0:	c3                   	ret    

00800dc1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dce:	eb 06                	jmp    800dd6 <strlen+0x15>
		n++;
  800dd0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd3:	ff 45 08             	incl   0x8(%ebp)
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	84 c0                	test   %al,%al
  800ddd:	75 f1                	jne    800dd0 <strlen+0xf>
		n++;
	return n;
  800ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800df1:	eb 09                	jmp    800dfc <strnlen+0x18>
		n++;
  800df3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df6:	ff 45 08             	incl   0x8(%ebp)
  800df9:	ff 4d 0c             	decl   0xc(%ebp)
  800dfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e00:	74 09                	je     800e0b <strnlen+0x27>
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	84 c0                	test   %al,%al
  800e09:	75 e8                	jne    800df3 <strnlen+0xf>
		n++;
	return n;
  800e0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e0e:	c9                   	leave  
  800e0f:	c3                   	ret    

00800e10 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e1c:	90                   	nop
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8d 50 01             	lea    0x1(%eax),%edx
  800e23:	89 55 08             	mov    %edx,0x8(%ebp)
  800e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2f:	8a 12                	mov    (%edx),%dl
  800e31:	88 10                	mov    %dl,(%eax)
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	84 c0                	test   %al,%al
  800e37:	75 e4                	jne    800e1d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e39:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e51:	eb 1f                	jmp    800e72 <strncpy+0x34>
		*dst++ = *src;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8d 50 01             	lea    0x1(%eax),%edx
  800e59:	89 55 08             	mov    %edx,0x8(%ebp)
  800e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5f:	8a 12                	mov    (%edx),%dl
  800e61:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	84 c0                	test   %al,%al
  800e6a:	74 03                	je     800e6f <strncpy+0x31>
			src++;
  800e6c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e6f:	ff 45 fc             	incl   -0x4(%ebp)
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e75:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e78:	72 d9                	jb     800e53 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e7d:	c9                   	leave  
  800e7e:	c3                   	ret    

00800e7f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8f:	74 30                	je     800ec1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e91:	eb 16                	jmp    800ea9 <strlcpy+0x2a>
			*dst++ = *src++;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8d 50 01             	lea    0x1(%eax),%edx
  800e99:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea5:	8a 12                	mov    (%edx),%dl
  800ea7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ea9:	ff 4d 10             	decl   0x10(%ebp)
  800eac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb0:	74 09                	je     800ebb <strlcpy+0x3c>
  800eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	84 c0                	test   %al,%al
  800eb9:	75 d8                	jne    800e93 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec7:	29 c2                	sub    %eax,%edx
  800ec9:	89 d0                	mov    %edx,%eax
}
  800ecb:	c9                   	leave  
  800ecc:	c3                   	ret    

00800ecd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ed0:	eb 06                	jmp    800ed8 <strcmp+0xb>
		p++, q++;
  800ed2:	ff 45 08             	incl   0x8(%ebp)
  800ed5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	8a 00                	mov    (%eax),%al
  800edd:	84 c0                	test   %al,%al
  800edf:	74 0e                	je     800eef <strcmp+0x22>
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8a 10                	mov    (%eax),%dl
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	38 c2                	cmp    %al,%dl
  800eed:	74 e3                	je     800ed2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	0f b6 d0             	movzbl %al,%edx
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	0f b6 c0             	movzbl %al,%eax
  800eff:	29 c2                	sub    %eax,%edx
  800f01:	89 d0                	mov    %edx,%eax
}
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    

00800f05 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f08:	eb 09                	jmp    800f13 <strncmp+0xe>
		n--, p++, q++;
  800f0a:	ff 4d 10             	decl   0x10(%ebp)
  800f0d:	ff 45 08             	incl   0x8(%ebp)
  800f10:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 17                	je     800f30 <strncmp+0x2b>
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	74 0e                	je     800f30 <strncmp+0x2b>
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	8a 10                	mov    (%eax),%dl
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	38 c2                	cmp    %al,%dl
  800f2e:	74 da                	je     800f0a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f34:	75 07                	jne    800f3d <strncmp+0x38>
		return 0;
  800f36:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3b:	eb 14                	jmp    800f51 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8a 00                	mov    (%eax),%al
  800f42:	0f b6 d0             	movzbl %al,%edx
  800f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	0f b6 c0             	movzbl %al,%eax
  800f4d:	29 c2                	sub    %eax,%edx
  800f4f:	89 d0                	mov    %edx,%eax
}
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 04             	sub    $0x4,%esp
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f5f:	eb 12                	jmp    800f73 <strchr+0x20>
		if (*s == c)
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f69:	75 05                	jne    800f70 <strchr+0x1d>
			return (char *) s;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	eb 11                	jmp    800f81 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f70:	ff 45 08             	incl   0x8(%ebp)
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	84 c0                	test   %al,%al
  800f7a:	75 e5                	jne    800f61 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f81:	c9                   	leave  
  800f82:	c3                   	ret    

00800f83 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8f:	eb 0d                	jmp    800f9e <strfind+0x1b>
		if (*s == c)
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f99:	74 0e                	je     800fa9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f9b:	ff 45 08             	incl   0x8(%ebp)
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	84 c0                	test   %al,%al
  800fa5:	75 ea                	jne    800f91 <strfind+0xe>
  800fa7:	eb 01                	jmp    800faa <strfind+0x27>
		if (*s == c)
			break;
  800fa9:	90                   	nop
	return (char *) s;
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fad:	c9                   	leave  
  800fae:	c3                   	ret    

00800faf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fc1:	eb 0e                	jmp    800fd1 <memset+0x22>
		*p++ = c;
  800fc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc6:	8d 50 01             	lea    0x1(%eax),%edx
  800fc9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcf:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fd1:	ff 4d f8             	decl   -0x8(%ebp)
  800fd4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fd8:	79 e9                	jns    800fc3 <memset+0x14>
		*p++ = c;

	return v;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ff1:	eb 16                	jmp    801009 <memcpy+0x2a>
		*d++ = *s++;
  800ff3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff6:	8d 50 01             	lea    0x1(%eax),%edx
  800ff9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ffc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fff:	8d 4a 01             	lea    0x1(%edx),%ecx
  801002:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801005:	8a 12                	mov    (%edx),%dl
  801007:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801009:	8b 45 10             	mov    0x10(%ebp),%eax
  80100c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100f:	89 55 10             	mov    %edx,0x10(%ebp)
  801012:	85 c0                	test   %eax,%eax
  801014:	75 dd                	jne    800ff3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801019:	c9                   	leave  
  80101a:	c3                   	ret    

0080101b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80102d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801030:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801033:	73 50                	jae    801085 <memmove+0x6a>
  801035:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801038:	8b 45 10             	mov    0x10(%ebp),%eax
  80103b:	01 d0                	add    %edx,%eax
  80103d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801040:	76 43                	jbe    801085 <memmove+0x6a>
		s += n;
  801042:	8b 45 10             	mov    0x10(%ebp),%eax
  801045:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801048:	8b 45 10             	mov    0x10(%ebp),%eax
  80104b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80104e:	eb 10                	jmp    801060 <memmove+0x45>
			*--d = *--s;
  801050:	ff 4d f8             	decl   -0x8(%ebp)
  801053:	ff 4d fc             	decl   -0x4(%ebp)
  801056:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801059:	8a 10                	mov    (%eax),%dl
  80105b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801060:	8b 45 10             	mov    0x10(%ebp),%eax
  801063:	8d 50 ff             	lea    -0x1(%eax),%edx
  801066:	89 55 10             	mov    %edx,0x10(%ebp)
  801069:	85 c0                	test   %eax,%eax
  80106b:	75 e3                	jne    801050 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80106d:	eb 23                	jmp    801092 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80106f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801072:	8d 50 01             	lea    0x1(%eax),%edx
  801075:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801078:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80107b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80107e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801081:	8a 12                	mov    (%edx),%dl
  801083:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801085:	8b 45 10             	mov    0x10(%ebp),%eax
  801088:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108b:	89 55 10             	mov    %edx,0x10(%ebp)
  80108e:	85 c0                	test   %eax,%eax
  801090:	75 dd                	jne    80106f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010a9:	eb 2a                	jmp    8010d5 <memcmp+0x3e>
		if (*s1 != *s2)
  8010ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ae:	8a 10                	mov    (%eax),%dl
  8010b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b3:	8a 00                	mov    (%eax),%al
  8010b5:	38 c2                	cmp    %al,%dl
  8010b7:	74 16                	je     8010cf <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	0f b6 d0             	movzbl %al,%edx
  8010c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	0f b6 c0             	movzbl %al,%eax
  8010c9:	29 c2                	sub    %eax,%edx
  8010cb:	89 d0                	mov    %edx,%eax
  8010cd:	eb 18                	jmp    8010e7 <memcmp+0x50>
		s1++, s2++;
  8010cf:	ff 45 fc             	incl   -0x4(%ebp)
  8010d2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010db:	89 55 10             	mov    %edx,0x10(%ebp)
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	75 c9                	jne    8010ab <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e7:	c9                   	leave  
  8010e8:	c3                   	ret    

008010e9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f5:	01 d0                	add    %edx,%eax
  8010f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010fa:	eb 15                	jmp    801111 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	8a 00                	mov    (%eax),%al
  801101:	0f b6 d0             	movzbl %al,%edx
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	0f b6 c0             	movzbl %al,%eax
  80110a:	39 c2                	cmp    %eax,%edx
  80110c:	74 0d                	je     80111b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80110e:	ff 45 08             	incl   0x8(%ebp)
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801117:	72 e3                	jb     8010fc <memfind+0x13>
  801119:	eb 01                	jmp    80111c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80111b:	90                   	nop
	return (void *) s;
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111f:	c9                   	leave  
  801120:	c3                   	ret    

00801121 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801127:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80112e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801135:	eb 03                	jmp    80113a <strtol+0x19>
		s++;
  801137:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	3c 20                	cmp    $0x20,%al
  801141:	74 f4                	je     801137 <strtol+0x16>
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	3c 09                	cmp    $0x9,%al
  80114a:	74 eb                	je     801137 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 2b                	cmp    $0x2b,%al
  801153:	75 05                	jne    80115a <strtol+0x39>
		s++;
  801155:	ff 45 08             	incl   0x8(%ebp)
  801158:	eb 13                	jmp    80116d <strtol+0x4c>
	else if (*s == '-')
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	3c 2d                	cmp    $0x2d,%al
  801161:	75 0a                	jne    80116d <strtol+0x4c>
		s++, neg = 1;
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80116d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801171:	74 06                	je     801179 <strtol+0x58>
  801173:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801177:	75 20                	jne    801199 <strtol+0x78>
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	3c 30                	cmp    $0x30,%al
  801180:	75 17                	jne    801199 <strtol+0x78>
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	40                   	inc    %eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	3c 78                	cmp    $0x78,%al
  80118a:	75 0d                	jne    801199 <strtol+0x78>
		s += 2, base = 16;
  80118c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801190:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801197:	eb 28                	jmp    8011c1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801199:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119d:	75 15                	jne    8011b4 <strtol+0x93>
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	3c 30                	cmp    $0x30,%al
  8011a6:	75 0c                	jne    8011b4 <strtol+0x93>
		s++, base = 8;
  8011a8:	ff 45 08             	incl   0x8(%ebp)
  8011ab:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011b2:	eb 0d                	jmp    8011c1 <strtol+0xa0>
	else if (base == 0)
  8011b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b8:	75 07                	jne    8011c1 <strtol+0xa0>
		base = 10;
  8011ba:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 2f                	cmp    $0x2f,%al
  8011c8:	7e 19                	jle    8011e3 <strtol+0xc2>
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	3c 39                	cmp    $0x39,%al
  8011d1:	7f 10                	jg     8011e3 <strtol+0xc2>
			dig = *s - '0';
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	8a 00                	mov    (%eax),%al
  8011d8:	0f be c0             	movsbl %al,%eax
  8011db:	83 e8 30             	sub    $0x30,%eax
  8011de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011e1:	eb 42                	jmp    801225 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	3c 60                	cmp    $0x60,%al
  8011ea:	7e 19                	jle    801205 <strtol+0xe4>
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	8a 00                	mov    (%eax),%al
  8011f1:	3c 7a                	cmp    $0x7a,%al
  8011f3:	7f 10                	jg     801205 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	0f be c0             	movsbl %al,%eax
  8011fd:	83 e8 57             	sub    $0x57,%eax
  801200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801203:	eb 20                	jmp    801225 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	3c 40                	cmp    $0x40,%al
  80120c:	7e 39                	jle    801247 <strtol+0x126>
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	3c 5a                	cmp    $0x5a,%al
  801215:	7f 30                	jg     801247 <strtol+0x126>
			dig = *s - 'A' + 10;
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	0f be c0             	movsbl %al,%eax
  80121f:	83 e8 37             	sub    $0x37,%eax
  801222:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801228:	3b 45 10             	cmp    0x10(%ebp),%eax
  80122b:	7d 19                	jge    801246 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80122d:	ff 45 08             	incl   0x8(%ebp)
  801230:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801233:	0f af 45 10          	imul   0x10(%ebp),%eax
  801237:	89 c2                	mov    %eax,%edx
  801239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123c:	01 d0                	add    %edx,%eax
  80123e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801241:	e9 7b ff ff ff       	jmp    8011c1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801246:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801247:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80124b:	74 08                	je     801255 <strtol+0x134>
		*endptr = (char *) s;
  80124d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801250:	8b 55 08             	mov    0x8(%ebp),%edx
  801253:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801255:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801259:	74 07                	je     801262 <strtol+0x141>
  80125b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125e:	f7 d8                	neg    %eax
  801260:	eb 03                	jmp    801265 <strtol+0x144>
  801262:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801265:	c9                   	leave  
  801266:	c3                   	ret    

00801267 <ltostr>:

void
ltostr(long value, char *str)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80126d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801274:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80127b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127f:	79 13                	jns    801294 <ltostr+0x2d>
	{
		neg = 1;
  801281:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80128e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801291:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80129c:	99                   	cltd   
  80129d:	f7 f9                	idiv   %ecx
  80129f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a5:	8d 50 01             	lea    0x1(%eax),%edx
  8012a8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ab:	89 c2                	mov    %eax,%edx
  8012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b0:	01 d0                	add    %edx,%eax
  8012b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012b5:	83 c2 30             	add    $0x30,%edx
  8012b8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012bd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012c2:	f7 e9                	imul   %ecx
  8012c4:	c1 fa 02             	sar    $0x2,%edx
  8012c7:	89 c8                	mov    %ecx,%eax
  8012c9:	c1 f8 1f             	sar    $0x1f,%eax
  8012cc:	29 c2                	sub    %eax,%edx
  8012ce:	89 d0                	mov    %edx,%eax
  8012d0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012db:	f7 e9                	imul   %ecx
  8012dd:	c1 fa 02             	sar    $0x2,%edx
  8012e0:	89 c8                	mov    %ecx,%eax
  8012e2:	c1 f8 1f             	sar    $0x1f,%eax
  8012e5:	29 c2                	sub    %eax,%edx
  8012e7:	89 d0                	mov    %edx,%eax
  8012e9:	c1 e0 02             	shl    $0x2,%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	01 c0                	add    %eax,%eax
  8012f0:	29 c1                	sub    %eax,%ecx
  8012f2:	89 ca                	mov    %ecx,%edx
  8012f4:	85 d2                	test   %edx,%edx
  8012f6:	75 9c                	jne    801294 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801302:	48                   	dec    %eax
  801303:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801306:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80130a:	74 3d                	je     801349 <ltostr+0xe2>
		start = 1 ;
  80130c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801313:	eb 34                	jmp    801349 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801315:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801318:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131b:	01 d0                	add    %edx,%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801322:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801325:	8b 45 0c             	mov    0xc(%ebp),%eax
  801328:	01 c2                	add    %eax,%edx
  80132a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80132d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801330:	01 c8                	add    %ecx,%eax
  801332:	8a 00                	mov    (%eax),%al
  801334:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801336:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133c:	01 c2                	add    %eax,%edx
  80133e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801341:	88 02                	mov    %al,(%edx)
		start++ ;
  801343:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801346:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134f:	7c c4                	jl     801315 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801351:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	01 d0                	add    %edx,%eax
  801359:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80135c:	90                   	nop
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801365:	ff 75 08             	pushl  0x8(%ebp)
  801368:	e8 54 fa ff ff       	call   800dc1 <strlen>
  80136d:	83 c4 04             	add    $0x4,%esp
  801370:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801373:	ff 75 0c             	pushl  0xc(%ebp)
  801376:	e8 46 fa ff ff       	call   800dc1 <strlen>
  80137b:	83 c4 04             	add    $0x4,%esp
  80137e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801381:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138f:	eb 17                	jmp    8013a8 <strcconcat+0x49>
		final[s] = str1[s] ;
  801391:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801394:	8b 45 10             	mov    0x10(%ebp),%eax
  801397:	01 c2                	add    %eax,%edx
  801399:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	01 c8                	add    %ecx,%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013a5:	ff 45 fc             	incl   -0x4(%ebp)
  8013a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ae:	7c e1                	jl     801391 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013be:	eb 1f                	jmp    8013df <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c3:	8d 50 01             	lea    0x1(%eax),%edx
  8013c6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013c9:	89 c2                	mov    %eax,%edx
  8013cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ce:	01 c2                	add    %eax,%edx
  8013d0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d6:	01 c8                	add    %ecx,%eax
  8013d8:	8a 00                	mov    (%eax),%al
  8013da:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013dc:	ff 45 f8             	incl   -0x8(%ebp)
  8013df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e5:	7c d9                	jl     8013c0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ed:	01 d0                	add    %edx,%eax
  8013ef:	c6 00 00             	movb   $0x0,(%eax)
}
  8013f2:	90                   	nop
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801401:	8b 45 14             	mov    0x14(%ebp),%eax
  801404:	8b 00                	mov    (%eax),%eax
  801406:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140d:	8b 45 10             	mov    0x10(%ebp),%eax
  801410:	01 d0                	add    %edx,%eax
  801412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801418:	eb 0c                	jmp    801426 <strsplit+0x31>
			*string++ = 0;
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8d 50 01             	lea    0x1(%eax),%edx
  801420:	89 55 08             	mov    %edx,0x8(%ebp)
  801423:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	84 c0                	test   %al,%al
  80142d:	74 18                	je     801447 <strsplit+0x52>
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	0f be c0             	movsbl %al,%eax
  801437:	50                   	push   %eax
  801438:	ff 75 0c             	pushl  0xc(%ebp)
  80143b:	e8 13 fb ff ff       	call   800f53 <strchr>
  801440:	83 c4 08             	add    $0x8,%esp
  801443:	85 c0                	test   %eax,%eax
  801445:	75 d3                	jne    80141a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	84 c0                	test   %al,%al
  80144e:	74 5a                	je     8014aa <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801450:	8b 45 14             	mov    0x14(%ebp),%eax
  801453:	8b 00                	mov    (%eax),%eax
  801455:	83 f8 0f             	cmp    $0xf,%eax
  801458:	75 07                	jne    801461 <strsplit+0x6c>
		{
			return 0;
  80145a:	b8 00 00 00 00       	mov    $0x0,%eax
  80145f:	eb 66                	jmp    8014c7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801461:	8b 45 14             	mov    0x14(%ebp),%eax
  801464:	8b 00                	mov    (%eax),%eax
  801466:	8d 48 01             	lea    0x1(%eax),%ecx
  801469:	8b 55 14             	mov    0x14(%ebp),%edx
  80146c:	89 0a                	mov    %ecx,(%edx)
  80146e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801475:	8b 45 10             	mov    0x10(%ebp),%eax
  801478:	01 c2                	add    %eax,%edx
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80147f:	eb 03                	jmp    801484 <strsplit+0x8f>
			string++;
  801481:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	84 c0                	test   %al,%al
  80148b:	74 8b                	je     801418 <strsplit+0x23>
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	0f be c0             	movsbl %al,%eax
  801495:	50                   	push   %eax
  801496:	ff 75 0c             	pushl  0xc(%ebp)
  801499:	e8 b5 fa ff ff       	call   800f53 <strchr>
  80149e:	83 c4 08             	add    $0x8,%esp
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	74 dc                	je     801481 <strsplit+0x8c>
			string++;
	}
  8014a5:	e9 6e ff ff ff       	jmp    801418 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014aa:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ae:	8b 00                	mov    (%eax),%eax
  8014b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ba:	01 d0                	add    %edx,%eax
  8014bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014c2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8014cf:	83 ec 04             	sub    $0x4,%esp
  8014d2:	68 10 27 80 00       	push   $0x802710
  8014d7:	6a 19                	push   $0x19
  8014d9:	68 35 27 80 00       	push   $0x802735
  8014de:	e8 ba ef ff ff       	call   80049d <_panic>

008014e3 <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	83 ec 18             	sub    $0x18,%esp
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	68 44 27 80 00       	push   $0x802744
  8014f7:	6a 31                	push   $0x31
  8014f9:	68 35 27 80 00       	push   $0x802735
  8014fe:	e8 9a ef ff ff       	call   80049d <_panic>

00801503 <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801509:	83 ec 04             	sub    $0x4,%esp
  80150c:	68 6c 27 80 00       	push   $0x80276c
  801511:	6a 4a                	push   $0x4a
  801513:	68 35 27 80 00       	push   $0x802735
  801518:	e8 80 ef ff ff       	call   80049d <_panic>

0080151d <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801523:	83 ec 04             	sub    $0x4,%esp
  801526:	68 90 27 80 00       	push   $0x802790
  80152b:	6a 70                	push   $0x70
  80152d:	68 35 27 80 00       	push   $0x802735
  801532:	e8 66 ef ff ff       	call   80049d <_panic>

00801537 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80153d:	83 ec 04             	sub    $0x4,%esp
  801540:	68 b4 27 80 00       	push   $0x8027b4
  801545:	68 8b 00 00 00       	push   $0x8b
  80154a:	68 35 27 80 00       	push   $0x802735
  80154f:	e8 49 ef ff ff       	call   80049d <_panic>

00801554 <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80155a:	83 ec 04             	sub    $0x4,%esp
  80155d:	68 d8 27 80 00       	push   $0x8027d8
  801562:	68 a8 00 00 00       	push   $0xa8
  801567:	68 35 27 80 00       	push   $0x802735
  80156c:	e8 2c ef ff ff       	call   80049d <_panic>

00801571 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	57                   	push   %edi
  801575:	56                   	push   %esi
  801576:	53                   	push   %ebx
  801577:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801580:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801583:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801586:	8b 7d 18             	mov    0x18(%ebp),%edi
  801589:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80158c:	cd 30                	int    $0x30
  80158e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801591:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801594:	83 c4 10             	add    $0x10,%esp
  801597:	5b                   	pop    %ebx
  801598:	5e                   	pop    %esi
  801599:	5f                   	pop    %edi
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    

0080159c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 04             	sub    $0x4,%esp
  8015a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015a8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	52                   	push   %edx
  8015b4:	ff 75 0c             	pushl  0xc(%ebp)
  8015b7:	50                   	push   %eax
  8015b8:	6a 00                	push   $0x0
  8015ba:	e8 b2 ff ff ff       	call   801571 <syscall>
  8015bf:	83 c4 18             	add    $0x18,%esp
}
  8015c2:	90                   	nop
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 01                	push   $0x1
  8015d4:	e8 98 ff ff ff       	call   801571 <syscall>
  8015d9:	83 c4 18             	add    $0x18,%esp
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	50                   	push   %eax
  8015ed:	6a 05                	push   $0x5
  8015ef:	e8 7d ff ff ff       	call   801571 <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 02                	push   $0x2
  801608:	e8 64 ff ff ff       	call   801571 <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 03                	push   $0x3
  801621:	e8 4b ff ff ff       	call   801571 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 04                	push   $0x4
  80163a:	e8 32 ff ff ff       	call   801571 <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_env_exit>:


void sys_env_exit(void)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 06                	push   $0x6
  801653:	e8 19 ff ff ff       	call   801571 <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
}
  80165b:	90                   	nop
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801661:	8b 55 0c             	mov    0xc(%ebp),%edx
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	52                   	push   %edx
  80166e:	50                   	push   %eax
  80166f:	6a 07                	push   $0x7
  801671:	e8 fb fe ff ff       	call   801571 <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	56                   	push   %esi
  80167f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801680:	8b 75 18             	mov    0x18(%ebp),%esi
  801683:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801686:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801689:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	56                   	push   %esi
  801690:	53                   	push   %ebx
  801691:	51                   	push   %ecx
  801692:	52                   	push   %edx
  801693:	50                   	push   %eax
  801694:	6a 08                	push   $0x8
  801696:	e8 d6 fe ff ff       	call   801571 <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a1:	5b                   	pop    %ebx
  8016a2:	5e                   	pop    %esi
  8016a3:	5d                   	pop    %ebp
  8016a4:	c3                   	ret    

008016a5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	52                   	push   %edx
  8016b5:	50                   	push   %eax
  8016b6:	6a 09                	push   $0x9
  8016b8:	e8 b4 fe ff ff       	call   801571 <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	ff 75 08             	pushl  0x8(%ebp)
  8016d1:	6a 0a                	push   $0xa
  8016d3:	e8 99 fe ff ff       	call   801571 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 0b                	push   $0xb
  8016ec:	e8 80 fe ff ff       	call   801571 <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 0c                	push   $0xc
  801705:	e8 67 fe ff ff       	call   801571 <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 0d                	push   $0xd
  80171e:	e8 4e fe ff ff       	call   801571 <syscall>
  801723:	83 c4 18             	add    $0x18,%esp
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	ff 75 0c             	pushl  0xc(%ebp)
  801734:	ff 75 08             	pushl  0x8(%ebp)
  801737:	6a 11                	push   $0x11
  801739:	e8 33 fe ff ff       	call   801571 <syscall>
  80173e:	83 c4 18             	add    $0x18,%esp
	return;
  801741:	90                   	nop
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	ff 75 08             	pushl  0x8(%ebp)
  801753:	6a 12                	push   $0x12
  801755:	e8 17 fe ff ff       	call   801571 <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
	return ;
  80175d:	90                   	nop
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 0e                	push   $0xe
  80176f:	e8 fd fd ff ff       	call   801571 <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	ff 75 08             	pushl  0x8(%ebp)
  801787:	6a 0f                	push   $0xf
  801789:	e8 e3 fd ff ff       	call   801571 <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 10                	push   $0x10
  8017a2:	e8 ca fd ff ff       	call   801571 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
}
  8017aa:	90                   	nop
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 14                	push   $0x14
  8017bc:	e8 b0 fd ff ff       	call   801571 <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
}
  8017c4:	90                   	nop
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 15                	push   $0x15
  8017d6:	e8 96 fd ff ff       	call   801571 <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	90                   	nop
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017ed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	50                   	push   %eax
  8017fa:	6a 16                	push   $0x16
  8017fc:	e8 70 fd ff ff       	call   801571 <syscall>
  801801:	83 c4 18             	add    $0x18,%esp
}
  801804:	90                   	nop
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 17                	push   $0x17
  801816:	e8 56 fd ff ff       	call   801571 <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
}
  80181e:	90                   	nop
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	ff 75 0c             	pushl  0xc(%ebp)
  801830:	50                   	push   %eax
  801831:	6a 18                	push   $0x18
  801833:	e8 39 fd ff ff       	call   801571 <syscall>
  801838:	83 c4 18             	add    $0x18,%esp
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801840:	8b 55 0c             	mov    0xc(%ebp),%edx
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	52                   	push   %edx
  80184d:	50                   	push   %eax
  80184e:	6a 1b                	push   $0x1b
  801850:	e8 1c fd ff ff       	call   801571 <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	52                   	push   %edx
  80186a:	50                   	push   %eax
  80186b:	6a 19                	push   $0x19
  80186d:	e8 ff fc ff ff       	call   801571 <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	90                   	nop
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80187b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187e:	8b 45 08             	mov    0x8(%ebp),%eax
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	52                   	push   %edx
  801888:	50                   	push   %eax
  801889:	6a 1a                	push   $0x1a
  80188b:	e8 e1 fc ff ff       	call   801571 <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 04             	sub    $0x4,%esp
  80189c:	8b 45 10             	mov    0x10(%ebp),%eax
  80189f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018a2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018a5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	51                   	push   %ecx
  8018af:	52                   	push   %edx
  8018b0:	ff 75 0c             	pushl  0xc(%ebp)
  8018b3:	50                   	push   %eax
  8018b4:	6a 1c                	push   $0x1c
  8018b6:	e8 b6 fc ff ff       	call   801571 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	52                   	push   %edx
  8018d0:	50                   	push   %eax
  8018d1:	6a 1d                	push   $0x1d
  8018d3:	e8 99 fc ff ff       	call   801571 <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	51                   	push   %ecx
  8018ee:	52                   	push   %edx
  8018ef:	50                   	push   %eax
  8018f0:	6a 1e                	push   $0x1e
  8018f2:	e8 7a fc ff ff       	call   801571 <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	52                   	push   %edx
  80190c:	50                   	push   %eax
  80190d:	6a 1f                	push   $0x1f
  80190f:	e8 5d fc ff ff       	call   801571 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 20                	push   $0x20
  801928:	e8 44 fc ff ff       	call   801571 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	ff 75 10             	pushl  0x10(%ebp)
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	50                   	push   %eax
  801943:	6a 21                	push   $0x21
  801945:	e8 27 fc ff ff       	call   801571 <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_run_env>:


void
sys_run_env(int32 envId)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	50                   	push   %eax
  80195e:	6a 22                	push   $0x22
  801960:	e8 0c fc ff ff       	call   801571 <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	90                   	nop
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_free_env>:

void
sys_free_env(int32 envId)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	50                   	push   %eax
  80197a:	6a 23                	push   $0x23
  80197c:	e8 f0 fb ff ff       	call   801571 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	90                   	nop
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80198d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801990:	8d 50 04             	lea    0x4(%eax),%edx
  801993:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	52                   	push   %edx
  80199d:	50                   	push   %eax
  80199e:	6a 24                	push   $0x24
  8019a0:	e8 cc fb ff ff       	call   801571 <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
	return result;
  8019a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b1:	89 01                	mov    %eax,(%ecx)
  8019b3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	c9                   	leave  
  8019ba:	c2 04 00             	ret    $0x4

008019bd <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	ff 75 10             	pushl  0x10(%ebp)
  8019c7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ca:	ff 75 08             	pushl  0x8(%ebp)
  8019cd:	6a 13                	push   $0x13
  8019cf:	e8 9d fb ff ff       	call   801571 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d7:	90                   	nop
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_rcr2>:
uint32 sys_rcr2()
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 25                	push   $0x25
  8019e9:	e8 83 fb ff ff       	call   801571 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019ff:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	50                   	push   %eax
  801a0c:	6a 26                	push   $0x26
  801a0e:	e8 5e fb ff ff       	call   801571 <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
	return ;
  801a16:	90                   	nop
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <rsttst>:
void rsttst()
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 28                	push   $0x28
  801a28:	e8 44 fb ff ff       	call   801571 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a30:	90                   	nop
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	83 ec 04             	sub    $0x4,%esp
  801a39:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a3f:	8b 55 18             	mov    0x18(%ebp),%edx
  801a42:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a46:	52                   	push   %edx
  801a47:	50                   	push   %eax
  801a48:	ff 75 10             	pushl  0x10(%ebp)
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	ff 75 08             	pushl  0x8(%ebp)
  801a51:	6a 27                	push   $0x27
  801a53:	e8 19 fb ff ff       	call   801571 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5b:	90                   	nop
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <chktst>:
void chktst(uint32 n)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	ff 75 08             	pushl  0x8(%ebp)
  801a6c:	6a 29                	push   $0x29
  801a6e:	e8 fe fa ff ff       	call   801571 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
	return ;
  801a76:	90                   	nop
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <inctst>:

void inctst()
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 2a                	push   $0x2a
  801a88:	e8 e4 fa ff ff       	call   801571 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a90:	90                   	nop
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <gettst>:
uint32 gettst()
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 2b                	push   $0x2b
  801aa2:	e8 ca fa ff ff       	call   801571 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 2c                	push   $0x2c
  801abe:	e8 ae fa ff ff       	call   801571 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
  801ac6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ac9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801acd:	75 07                	jne    801ad6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801acf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad4:	eb 05                	jmp    801adb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ad6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 2c                	push   $0x2c
  801aef:	e8 7d fa ff ff       	call   801571 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
  801af7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801afa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801afe:	75 07                	jne    801b07 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b00:	b8 01 00 00 00       	mov    $0x1,%eax
  801b05:	eb 05                	jmp    801b0c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 2c                	push   $0x2c
  801b20:	e8 4c fa ff ff       	call   801571 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
  801b28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b2b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b2f:	75 07                	jne    801b38 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b31:	b8 01 00 00 00       	mov    $0x1,%eax
  801b36:	eb 05                	jmp    801b3d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 2c                	push   $0x2c
  801b51:	e8 1b fa ff ff       	call   801571 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
  801b59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b5c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b60:	75 07                	jne    801b69 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b62:	b8 01 00 00 00       	mov    $0x1,%eax
  801b67:	eb 05                	jmp    801b6e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	ff 75 08             	pushl  0x8(%ebp)
  801b7e:	6a 2d                	push   $0x2d
  801b80:	e8 ec f9 ff ff       	call   801571 <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
	return ;
  801b88:	90                   	nop
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b8f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	53                   	push   %ebx
  801b9e:	51                   	push   %ecx
  801b9f:	52                   	push   %edx
  801ba0:	50                   	push   %eax
  801ba1:	6a 2e                	push   $0x2e
  801ba3:	e8 c9 f9 ff ff       	call   801571 <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	52                   	push   %edx
  801bc0:	50                   	push   %eax
  801bc1:	6a 2f                	push   $0x2f
  801bc3:	e8 a9 f9 ff ff       	call   801571 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801bd3:	8b 55 08             	mov    0x8(%ebp),%edx
  801bd6:	89 d0                	mov    %edx,%eax
  801bd8:	c1 e0 02             	shl    $0x2,%eax
  801bdb:	01 d0                	add    %edx,%eax
  801bdd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801be4:	01 d0                	add    %edx,%eax
  801be6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bed:	01 d0                	add    %edx,%eax
  801bef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bf6:	01 d0                	add    %edx,%eax
  801bf8:	c1 e0 04             	shl    $0x4,%eax
  801bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801bfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801c05:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801c08:	83 ec 0c             	sub    $0xc,%esp
  801c0b:	50                   	push   %eax
  801c0c:	e8 76 fd ff ff       	call   801987 <sys_get_virtual_time>
  801c11:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801c14:	eb 41                	jmp    801c57 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801c16:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801c19:	83 ec 0c             	sub    $0xc,%esp
  801c1c:	50                   	push   %eax
  801c1d:	e8 65 fd ff ff       	call   801987 <sys_get_virtual_time>
  801c22:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801c25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c2b:	29 c2                	sub    %eax,%edx
  801c2d:	89 d0                	mov    %edx,%eax
  801c2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801c32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c38:	89 d1                	mov    %edx,%ecx
  801c3a:	29 c1                	sub    %eax,%ecx
  801c3c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c42:	39 c2                	cmp    %eax,%edx
  801c44:	0f 97 c0             	seta   %al
  801c47:	0f b6 c0             	movzbl %al,%eax
  801c4a:	29 c1                	sub    %eax,%ecx
  801c4c:	89 c8                	mov    %ecx,%eax
  801c4e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801c51:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c5d:	72 b7                	jb     801c16 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801c5f:	90                   	nop
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801c68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801c6f:	eb 03                	jmp    801c74 <busy_wait+0x12>
  801c71:	ff 45 fc             	incl   -0x4(%ebp)
  801c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c77:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c7a:	72 f5                	jb     801c71 <busy_wait+0xf>
	return i;
  801c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    
  801c81:	66 90                	xchg   %ax,%ax
  801c83:	90                   	nop

00801c84 <__udivdi3>:
  801c84:	55                   	push   %ebp
  801c85:	57                   	push   %edi
  801c86:	56                   	push   %esi
  801c87:	53                   	push   %ebx
  801c88:	83 ec 1c             	sub    $0x1c,%esp
  801c8b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c8f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c97:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c9b:	89 ca                	mov    %ecx,%edx
  801c9d:	89 f8                	mov    %edi,%eax
  801c9f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ca3:	85 f6                	test   %esi,%esi
  801ca5:	75 2d                	jne    801cd4 <__udivdi3+0x50>
  801ca7:	39 cf                	cmp    %ecx,%edi
  801ca9:	77 65                	ja     801d10 <__udivdi3+0x8c>
  801cab:	89 fd                	mov    %edi,%ebp
  801cad:	85 ff                	test   %edi,%edi
  801caf:	75 0b                	jne    801cbc <__udivdi3+0x38>
  801cb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb6:	31 d2                	xor    %edx,%edx
  801cb8:	f7 f7                	div    %edi
  801cba:	89 c5                	mov    %eax,%ebp
  801cbc:	31 d2                	xor    %edx,%edx
  801cbe:	89 c8                	mov    %ecx,%eax
  801cc0:	f7 f5                	div    %ebp
  801cc2:	89 c1                	mov    %eax,%ecx
  801cc4:	89 d8                	mov    %ebx,%eax
  801cc6:	f7 f5                	div    %ebp
  801cc8:	89 cf                	mov    %ecx,%edi
  801cca:	89 fa                	mov    %edi,%edx
  801ccc:	83 c4 1c             	add    $0x1c,%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5f                   	pop    %edi
  801cd2:	5d                   	pop    %ebp
  801cd3:	c3                   	ret    
  801cd4:	39 ce                	cmp    %ecx,%esi
  801cd6:	77 28                	ja     801d00 <__udivdi3+0x7c>
  801cd8:	0f bd fe             	bsr    %esi,%edi
  801cdb:	83 f7 1f             	xor    $0x1f,%edi
  801cde:	75 40                	jne    801d20 <__udivdi3+0x9c>
  801ce0:	39 ce                	cmp    %ecx,%esi
  801ce2:	72 0a                	jb     801cee <__udivdi3+0x6a>
  801ce4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ce8:	0f 87 9e 00 00 00    	ja     801d8c <__udivdi3+0x108>
  801cee:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf3:	89 fa                	mov    %edi,%edx
  801cf5:	83 c4 1c             	add    $0x1c,%esp
  801cf8:	5b                   	pop    %ebx
  801cf9:	5e                   	pop    %esi
  801cfa:	5f                   	pop    %edi
  801cfb:	5d                   	pop    %ebp
  801cfc:	c3                   	ret    
  801cfd:	8d 76 00             	lea    0x0(%esi),%esi
  801d00:	31 ff                	xor    %edi,%edi
  801d02:	31 c0                	xor    %eax,%eax
  801d04:	89 fa                	mov    %edi,%edx
  801d06:	83 c4 1c             	add    $0x1c,%esp
  801d09:	5b                   	pop    %ebx
  801d0a:	5e                   	pop    %esi
  801d0b:	5f                   	pop    %edi
  801d0c:	5d                   	pop    %ebp
  801d0d:	c3                   	ret    
  801d0e:	66 90                	xchg   %ax,%ax
  801d10:	89 d8                	mov    %ebx,%eax
  801d12:	f7 f7                	div    %edi
  801d14:	31 ff                	xor    %edi,%edi
  801d16:	89 fa                	mov    %edi,%edx
  801d18:	83 c4 1c             	add    $0x1c,%esp
  801d1b:	5b                   	pop    %ebx
  801d1c:	5e                   	pop    %esi
  801d1d:	5f                   	pop    %edi
  801d1e:	5d                   	pop    %ebp
  801d1f:	c3                   	ret    
  801d20:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d25:	89 eb                	mov    %ebp,%ebx
  801d27:	29 fb                	sub    %edi,%ebx
  801d29:	89 f9                	mov    %edi,%ecx
  801d2b:	d3 e6                	shl    %cl,%esi
  801d2d:	89 c5                	mov    %eax,%ebp
  801d2f:	88 d9                	mov    %bl,%cl
  801d31:	d3 ed                	shr    %cl,%ebp
  801d33:	89 e9                	mov    %ebp,%ecx
  801d35:	09 f1                	or     %esi,%ecx
  801d37:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d3b:	89 f9                	mov    %edi,%ecx
  801d3d:	d3 e0                	shl    %cl,%eax
  801d3f:	89 c5                	mov    %eax,%ebp
  801d41:	89 d6                	mov    %edx,%esi
  801d43:	88 d9                	mov    %bl,%cl
  801d45:	d3 ee                	shr    %cl,%esi
  801d47:	89 f9                	mov    %edi,%ecx
  801d49:	d3 e2                	shl    %cl,%edx
  801d4b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d4f:	88 d9                	mov    %bl,%cl
  801d51:	d3 e8                	shr    %cl,%eax
  801d53:	09 c2                	or     %eax,%edx
  801d55:	89 d0                	mov    %edx,%eax
  801d57:	89 f2                	mov    %esi,%edx
  801d59:	f7 74 24 0c          	divl   0xc(%esp)
  801d5d:	89 d6                	mov    %edx,%esi
  801d5f:	89 c3                	mov    %eax,%ebx
  801d61:	f7 e5                	mul    %ebp
  801d63:	39 d6                	cmp    %edx,%esi
  801d65:	72 19                	jb     801d80 <__udivdi3+0xfc>
  801d67:	74 0b                	je     801d74 <__udivdi3+0xf0>
  801d69:	89 d8                	mov    %ebx,%eax
  801d6b:	31 ff                	xor    %edi,%edi
  801d6d:	e9 58 ff ff ff       	jmp    801cca <__udivdi3+0x46>
  801d72:	66 90                	xchg   %ax,%ax
  801d74:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d78:	89 f9                	mov    %edi,%ecx
  801d7a:	d3 e2                	shl    %cl,%edx
  801d7c:	39 c2                	cmp    %eax,%edx
  801d7e:	73 e9                	jae    801d69 <__udivdi3+0xe5>
  801d80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d83:	31 ff                	xor    %edi,%edi
  801d85:	e9 40 ff ff ff       	jmp    801cca <__udivdi3+0x46>
  801d8a:	66 90                	xchg   %ax,%ax
  801d8c:	31 c0                	xor    %eax,%eax
  801d8e:	e9 37 ff ff ff       	jmp    801cca <__udivdi3+0x46>
  801d93:	90                   	nop

00801d94 <__umoddi3>:
  801d94:	55                   	push   %ebp
  801d95:	57                   	push   %edi
  801d96:	56                   	push   %esi
  801d97:	53                   	push   %ebx
  801d98:	83 ec 1c             	sub    $0x1c,%esp
  801d9b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801da3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801da7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801daf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801db3:	89 f3                	mov    %esi,%ebx
  801db5:	89 fa                	mov    %edi,%edx
  801db7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dbb:	89 34 24             	mov    %esi,(%esp)
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	75 1a                	jne    801ddc <__umoddi3+0x48>
  801dc2:	39 f7                	cmp    %esi,%edi
  801dc4:	0f 86 a2 00 00 00    	jbe    801e6c <__umoddi3+0xd8>
  801dca:	89 c8                	mov    %ecx,%eax
  801dcc:	89 f2                	mov    %esi,%edx
  801dce:	f7 f7                	div    %edi
  801dd0:	89 d0                	mov    %edx,%eax
  801dd2:	31 d2                	xor    %edx,%edx
  801dd4:	83 c4 1c             	add    $0x1c,%esp
  801dd7:	5b                   	pop    %ebx
  801dd8:	5e                   	pop    %esi
  801dd9:	5f                   	pop    %edi
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    
  801ddc:	39 f0                	cmp    %esi,%eax
  801dde:	0f 87 ac 00 00 00    	ja     801e90 <__umoddi3+0xfc>
  801de4:	0f bd e8             	bsr    %eax,%ebp
  801de7:	83 f5 1f             	xor    $0x1f,%ebp
  801dea:	0f 84 ac 00 00 00    	je     801e9c <__umoddi3+0x108>
  801df0:	bf 20 00 00 00       	mov    $0x20,%edi
  801df5:	29 ef                	sub    %ebp,%edi
  801df7:	89 fe                	mov    %edi,%esi
  801df9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dfd:	89 e9                	mov    %ebp,%ecx
  801dff:	d3 e0                	shl    %cl,%eax
  801e01:	89 d7                	mov    %edx,%edi
  801e03:	89 f1                	mov    %esi,%ecx
  801e05:	d3 ef                	shr    %cl,%edi
  801e07:	09 c7                	or     %eax,%edi
  801e09:	89 e9                	mov    %ebp,%ecx
  801e0b:	d3 e2                	shl    %cl,%edx
  801e0d:	89 14 24             	mov    %edx,(%esp)
  801e10:	89 d8                	mov    %ebx,%eax
  801e12:	d3 e0                	shl    %cl,%eax
  801e14:	89 c2                	mov    %eax,%edx
  801e16:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e1a:	d3 e0                	shl    %cl,%eax
  801e1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e20:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e24:	89 f1                	mov    %esi,%ecx
  801e26:	d3 e8                	shr    %cl,%eax
  801e28:	09 d0                	or     %edx,%eax
  801e2a:	d3 eb                	shr    %cl,%ebx
  801e2c:	89 da                	mov    %ebx,%edx
  801e2e:	f7 f7                	div    %edi
  801e30:	89 d3                	mov    %edx,%ebx
  801e32:	f7 24 24             	mull   (%esp)
  801e35:	89 c6                	mov    %eax,%esi
  801e37:	89 d1                	mov    %edx,%ecx
  801e39:	39 d3                	cmp    %edx,%ebx
  801e3b:	0f 82 87 00 00 00    	jb     801ec8 <__umoddi3+0x134>
  801e41:	0f 84 91 00 00 00    	je     801ed8 <__umoddi3+0x144>
  801e47:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e4b:	29 f2                	sub    %esi,%edx
  801e4d:	19 cb                	sbb    %ecx,%ebx
  801e4f:	89 d8                	mov    %ebx,%eax
  801e51:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e55:	d3 e0                	shl    %cl,%eax
  801e57:	89 e9                	mov    %ebp,%ecx
  801e59:	d3 ea                	shr    %cl,%edx
  801e5b:	09 d0                	or     %edx,%eax
  801e5d:	89 e9                	mov    %ebp,%ecx
  801e5f:	d3 eb                	shr    %cl,%ebx
  801e61:	89 da                	mov    %ebx,%edx
  801e63:	83 c4 1c             	add    $0x1c,%esp
  801e66:	5b                   	pop    %ebx
  801e67:	5e                   	pop    %esi
  801e68:	5f                   	pop    %edi
  801e69:	5d                   	pop    %ebp
  801e6a:	c3                   	ret    
  801e6b:	90                   	nop
  801e6c:	89 fd                	mov    %edi,%ebp
  801e6e:	85 ff                	test   %edi,%edi
  801e70:	75 0b                	jne    801e7d <__umoddi3+0xe9>
  801e72:	b8 01 00 00 00       	mov    $0x1,%eax
  801e77:	31 d2                	xor    %edx,%edx
  801e79:	f7 f7                	div    %edi
  801e7b:	89 c5                	mov    %eax,%ebp
  801e7d:	89 f0                	mov    %esi,%eax
  801e7f:	31 d2                	xor    %edx,%edx
  801e81:	f7 f5                	div    %ebp
  801e83:	89 c8                	mov    %ecx,%eax
  801e85:	f7 f5                	div    %ebp
  801e87:	89 d0                	mov    %edx,%eax
  801e89:	e9 44 ff ff ff       	jmp    801dd2 <__umoddi3+0x3e>
  801e8e:	66 90                	xchg   %ax,%ax
  801e90:	89 c8                	mov    %ecx,%eax
  801e92:	89 f2                	mov    %esi,%edx
  801e94:	83 c4 1c             	add    $0x1c,%esp
  801e97:	5b                   	pop    %ebx
  801e98:	5e                   	pop    %esi
  801e99:	5f                   	pop    %edi
  801e9a:	5d                   	pop    %ebp
  801e9b:	c3                   	ret    
  801e9c:	3b 04 24             	cmp    (%esp),%eax
  801e9f:	72 06                	jb     801ea7 <__umoddi3+0x113>
  801ea1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ea5:	77 0f                	ja     801eb6 <__umoddi3+0x122>
  801ea7:	89 f2                	mov    %esi,%edx
  801ea9:	29 f9                	sub    %edi,%ecx
  801eab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801eaf:	89 14 24             	mov    %edx,(%esp)
  801eb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801eb6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801eba:	8b 14 24             	mov    (%esp),%edx
  801ebd:	83 c4 1c             	add    $0x1c,%esp
  801ec0:	5b                   	pop    %ebx
  801ec1:	5e                   	pop    %esi
  801ec2:	5f                   	pop    %edi
  801ec3:	5d                   	pop    %ebp
  801ec4:	c3                   	ret    
  801ec5:	8d 76 00             	lea    0x0(%esi),%esi
  801ec8:	2b 04 24             	sub    (%esp),%eax
  801ecb:	19 fa                	sbb    %edi,%edx
  801ecd:	89 d1                	mov    %edx,%ecx
  801ecf:	89 c6                	mov    %eax,%esi
  801ed1:	e9 71 ff ff ff       	jmp    801e47 <__umoddi3+0xb3>
  801ed6:	66 90                	xchg   %ax,%ax
  801ed8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801edc:	72 ea                	jb     801ec8 <__umoddi3+0x134>
  801ede:	89 d9                	mov    %ebx,%ecx
  801ee0:	e9 62 ff ff ff       	jmp    801e47 <__umoddi3+0xb3>
