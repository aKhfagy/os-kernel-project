
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 0b 04 00 00       	call   800441 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
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
  800087:	68 e0 1f 80 00       	push   $0x801fe0
  80008c:	6a 12                	push   $0x12
  80008e:	68 fc 1f 80 00       	push   $0x801ffc
  800093:	e8 ee 04 00 00       	call   800586 <_panic>
	}

	cprintf("************************************************\n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 1c 20 80 00       	push   $0x80201c
  8000a0:	e8 83 07 00 00       	call   800828 <cprintf>
  8000a5:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	68 50 20 80 00       	push   $0x802050
  8000b0:	e8 73 07 00 00       	call   800828 <cprintf>
  8000b5:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	68 ac 20 80 00       	push   $0x8020ac
  8000c0:	e8 63 07 00 00       	call   800828 <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000c8:	e8 15 16 00 00       	call   8016e2 <sys_getenvid>
  8000cd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	68 e0 20 80 00       	push   $0x8020e0
  8000d8:	e8 4b 07 00 00       	call   800828 <cprintf>
  8000dd:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size), 50);
  8000e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e5:	8b 40 74             	mov    0x74(%eax),%eax
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	6a 32                	push   $0x32
  8000ed:	50                   	push   %eax
  8000ee:	68 21 21 80 00       	push   $0x802121
  8000f3:	e8 23 19 00 00       	call   801a1b <sys_create_env>
  8000f8:	83 c4 10             	add    $0x10,%esp
  8000fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size), 50);
  8000fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800103:	8b 40 74             	mov    0x74(%eax),%eax
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	6a 32                	push   $0x32
  80010b:	50                   	push   %eax
  80010c:	68 21 21 80 00       	push   $0x802121
  800111:	e8 05 19 00 00       	call   801a1b <sys_create_env>
  800116:	83 c4 10             	add    $0x10,%esp
  800119:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  80011c:	e8 a5 16 00 00       	call   8017c6 <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	6a 01                	push   $0x1
  800129:	68 00 10 00 00       	push   $0x1000
  80012e:	68 2f 21 80 00       	push   $0x80212f
  800133:	e8 94 14 00 00       	call   8015cc <smalloc>
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	68 34 21 80 00       	push   $0x802134
  800146:	e8 dd 06 00 00       	call   800828 <cprintf>
  80014b:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80014e:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800155:	74 14                	je     80016b <_main+0x133>
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	68 54 21 80 00       	push   $0x802154
  80015f:	6a 26                	push   $0x26
  800161:	68 fc 1f 80 00       	push   $0x801ffc
  800166:	e8 1b 04 00 00       	call   800586 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80016b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80016e:	e8 53 16 00 00       	call   8017c6 <sys_calculate_free_frames>
  800173:	29 c3                	sub    %eax,%ebx
  800175:	89 d8                	mov    %ebx,%eax
  800177:	83 f8 04             	cmp    $0x4,%eax
  80017a:	74 14                	je     800190 <_main+0x158>
  80017c:	83 ec 04             	sub    $0x4,%esp
  80017f:	68 c0 21 80 00       	push   $0x8021c0
  800184:	6a 27                	push   $0x27
  800186:	68 fc 1f 80 00       	push   $0x801ffc
  80018b:	e8 f6 03 00 00       	call   800586 <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  800190:	e8 6d 19 00 00       	call   801b02 <rsttst>

		sys_run_env(envIdSlave1);
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	ff 75 e8             	pushl  -0x18(%ebp)
  80019b:	e8 98 18 00 00       	call   801a38 <sys_run_env>
  8001a0:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001a9:	e8 8a 18 00 00       	call   801a38 <sys_run_env>
  8001ae:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 3e 22 80 00       	push   $0x80223e
  8001b9:	e8 6a 06 00 00       	call   800828 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001c1:	83 ec 0c             	sub    $0xc,%esp
  8001c4:	68 b8 0b 00 00       	push   $0xbb8
  8001c9:	e8 e8 1a 00 00       	call   801cb6 <env_sleep>
  8001ce:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001d1:	e8 a6 19 00 00       	call   801b7c <gettst>
  8001d6:	83 f8 02             	cmp    $0x2,%eax
  8001d9:	74 14                	je     8001ef <_main+0x1b7>
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	68 55 22 80 00       	push   $0x802255
  8001e3:	6a 33                	push   $0x33
  8001e5:	68 fc 1f 80 00       	push   $0x801ffc
  8001ea:	e8 97 03 00 00       	call   800586 <_panic>

		sfree(x);
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f5:	e8 26 14 00 00       	call   801620 <sfree>
  8001fa:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	68 64 22 80 00       	push   $0x802264
  800205:	e8 1e 06 00 00       	call   800828 <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  80020d:	e8 b4 15 00 00       	call   8017c6 <sys_calculate_free_frames>
  800212:	89 c2                	mov    %eax,%edx
  800214:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800217:	29 c2                	sub    %eax,%edx
  800219:	89 d0                	mov    %edx,%eax
  80021b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80021e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800222:	74 14                	je     800238 <_main+0x200>
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	68 84 22 80 00       	push   $0x802284
  80022c:	6a 38                	push   $0x38
  80022e:	68 fc 1f 80 00       	push   $0x801ffc
  800233:	e8 4e 03 00 00       	call   800586 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	68 b4 22 80 00       	push   $0x8022b4
  800240:	e8 e3 05 00 00       	call   800828 <cprintf>
  800245:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	68 d8 22 80 00       	push   $0x8022d8
  800250:	e8 d3 05 00 00       	call   800828 <cprintf>
  800255:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size), 50);
  800258:	a1 20 30 80 00       	mov    0x803020,%eax
  80025d:	8b 40 74             	mov    0x74(%eax),%eax
  800260:	83 ec 04             	sub    $0x4,%esp
  800263:	6a 32                	push   $0x32
  800265:	50                   	push   %eax
  800266:	68 08 23 80 00       	push   $0x802308
  80026b:	e8 ab 17 00 00       	call   801a1b <sys_create_env>
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size),50);
  800276:	a1 20 30 80 00       	mov    0x803020,%eax
  80027b:	8b 40 74             	mov    0x74(%eax),%eax
  80027e:	83 ec 04             	sub    $0x4,%esp
  800281:	6a 32                	push   $0x32
  800283:	50                   	push   %eax
  800284:	68 18 23 80 00       	push   $0x802318
  800289:	e8 8d 17 00 00       	call   801a1b <sys_create_env>
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	6a 01                	push   $0x1
  800299:	68 00 10 00 00       	push   $0x1000
  80029e:	68 28 23 80 00       	push   $0x802328
  8002a3:	e8 24 13 00 00       	call   8015cc <smalloc>
  8002a8:	83 c4 10             	add    $0x10,%esp
  8002ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	68 2c 23 80 00       	push   $0x80232c
  8002b6:	e8 6d 05 00 00       	call   800828 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002be:	83 ec 04             	sub    $0x4,%esp
  8002c1:	6a 01                	push   $0x1
  8002c3:	68 00 10 00 00       	push   $0x1000
  8002c8:	68 2f 21 80 00       	push   $0x80212f
  8002cd:	e8 fa 12 00 00       	call   8015cc <smalloc>
  8002d2:	83 c4 10             	add    $0x10,%esp
  8002d5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	68 34 21 80 00       	push   $0x802134
  8002e0:	e8 43 05 00 00       	call   800828 <cprintf>
  8002e5:	83 c4 10             	add    $0x10,%esp

		rsttst();
  8002e8:	e8 15 18 00 00       	call   801b02 <rsttst>

		sys_run_env(envIdSlaveB1);
  8002ed:	83 ec 0c             	sub    $0xc,%esp
  8002f0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f3:	e8 40 17 00 00       	call   801a38 <sys_run_env>
  8002f8:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  8002fb:	83 ec 0c             	sub    $0xc,%esp
  8002fe:	ff 75 d0             	pushl  -0x30(%ebp)
  800301:	e8 32 17 00 00       	call   801a38 <sys_run_env>
  800306:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	68 a0 0f 00 00       	push   $0xfa0
  800311:	e8 a0 19 00 00       	call   801cb6 <env_sleep>
  800316:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  800319:	e8 a8 14 00 00       	call   8017c6 <sys_calculate_free_frames>
  80031e:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 cc             	pushl  -0x34(%ebp)
  800327:	e8 f4 12 00 00       	call   801620 <sfree>
  80032c:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	68 4c 23 80 00       	push   $0x80234c
  800337:	e8 ec 04 00 00       	call   800828 <cprintf>
  80033c:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 c8             	pushl  -0x38(%ebp)
  800345:	e8 d6 12 00 00       	call   801620 <sfree>
  80034a:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	68 62 23 80 00       	push   $0x802362
  800355:	e8 ce 04 00 00       	call   800828 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  80035d:	e8 64 14 00 00       	call   8017c6 <sys_calculate_free_frames>
  800362:	89 c2                	mov    %eax,%edx
  800364:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800367:	29 c2                	sub    %eax,%edx
  800369:	89 d0                	mov    %edx,%eax
  80036b:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  80036e:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  800372:	74 14                	je     800388 <_main+0x350>
  800374:	83 ec 04             	sub    $0x4,%esp
  800377:	68 78 23 80 00       	push   $0x802378
  80037c:	6a 59                	push   $0x59
  80037e:	68 fc 1f 80 00       	push   $0x801ffc
  800383:	e8 fe 01 00 00       	call   800586 <_panic>

		//To indicate that it's completed successfully
		inctst();
  800388:	e8 d5 17 00 00       	call   801b62 <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	6a 01                	push   $0x1
  800392:	6a 04                	push   $0x4
  800394:	68 1d 24 80 00       	push   $0x80241d
  800399:	e8 2e 12 00 00       	call   8015cc <smalloc>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003a4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003ad:	e8 62 13 00 00       	call   801714 <sys_getparentenvid>
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	0f 8e 81 00 00 00    	jle    80043b <_main+0x403>
			while(*finish_children != 1);
  8003ba:	90                   	nop
  8003bb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003be:	8b 00                	mov    (%eax),%eax
  8003c0:	83 f8 01             	cmp    $0x1,%eax
  8003c3:	75 f6                	jne    8003bb <_main+0x383>
			cprintf("done\n");
  8003c5:	83 ec 0c             	sub    $0xc,%esp
  8003c8:	68 2d 24 80 00       	push   $0x80242d
  8003cd:	e8 56 04 00 00       	call   800828 <cprintf>
  8003d2:	83 c4 10             	add    $0x10,%esp
			sys_free_env(envIdSlave1);
  8003d5:	83 ec 0c             	sub    $0xc,%esp
  8003d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8003db:	e8 74 16 00 00       	call   801a54 <sys_free_env>
  8003e0:	83 c4 10             	add    $0x10,%esp
			sys_free_env(envIdSlave2);
  8003e3:	83 ec 0c             	sub    $0xc,%esp
  8003e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e9:	e8 66 16 00 00       	call   801a54 <sys_free_env>
  8003ee:	83 c4 10             	add    $0x10,%esp
			sys_free_env(envIdSlaveB1);
  8003f1:	83 ec 0c             	sub    $0xc,%esp
  8003f4:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003f7:	e8 58 16 00 00       	call   801a54 <sys_free_env>
  8003fc:	83 c4 10             	add    $0x10,%esp
			sys_free_env(envIdSlaveB2);
  8003ff:	83 ec 0c             	sub    $0xc,%esp
  800402:	ff 75 d0             	pushl  -0x30(%ebp)
  800405:	e8 4a 16 00 00       	call   801a54 <sys_free_env>
  80040a:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  80040d:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800414:	e8 fb 12 00 00       	call   801714 <sys_getparentenvid>
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	68 33 24 80 00       	push   $0x802433
  800421:	50                   	push   %eax
  800422:	e8 c5 11 00 00       	call   8015ec <sget>
  800427:	83 c4 10             	add    $0x10,%esp
  80042a:	89 45 b8             	mov    %eax,-0x48(%ebp)
			(*finishedCount)++ ;
  80042d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800430:	8b 00                	mov    (%eax),%eax
  800432:	8d 50 01             	lea    0x1(%eax),%edx
  800435:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800438:	89 10                	mov    %edx,(%eax)
		}
	}


	return;
  80043a:	90                   	nop
  80043b:	90                   	nop
}
  80043c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80043f:	c9                   	leave  
  800440:	c3                   	ret    

00800441 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800441:	55                   	push   %ebp
  800442:	89 e5                	mov    %esp,%ebp
  800444:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800447:	e8 af 12 00 00       	call   8016fb <sys_getenvindex>
  80044c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80044f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800452:	89 d0                	mov    %edx,%eax
  800454:	c1 e0 03             	shl    $0x3,%eax
  800457:	01 d0                	add    %edx,%eax
  800459:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800460:	01 c8                	add    %ecx,%eax
  800462:	01 c0                	add    %eax,%eax
  800464:	01 d0                	add    %edx,%eax
  800466:	01 c0                	add    %eax,%eax
  800468:	01 d0                	add    %edx,%eax
  80046a:	89 c2                	mov    %eax,%edx
  80046c:	c1 e2 05             	shl    $0x5,%edx
  80046f:	29 c2                	sub    %eax,%edx
  800471:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800478:	89 c2                	mov    %eax,%edx
  80047a:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800480:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800485:	a1 20 30 80 00       	mov    0x803020,%eax
  80048a:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800490:	84 c0                	test   %al,%al
  800492:	74 0f                	je     8004a3 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800494:	a1 20 30 80 00       	mov    0x803020,%eax
  800499:	05 40 3c 01 00       	add    $0x13c40,%eax
  80049e:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004a7:	7e 0a                	jle    8004b3 <libmain+0x72>
		binaryname = argv[0];
  8004a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ac:	8b 00                	mov    (%eax),%eax
  8004ae:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8004b3:	83 ec 08             	sub    $0x8,%esp
  8004b6:	ff 75 0c             	pushl  0xc(%ebp)
  8004b9:	ff 75 08             	pushl  0x8(%ebp)
  8004bc:	e8 77 fb ff ff       	call   800038 <_main>
  8004c1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004c4:	e8 cd 13 00 00       	call   801896 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004c9:	83 ec 0c             	sub    $0xc,%esp
  8004cc:	68 5c 24 80 00       	push   $0x80245c
  8004d1:	e8 52 03 00 00       	call   800828 <cprintf>
  8004d6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8004de:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8004e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e9:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8004ef:	83 ec 04             	sub    $0x4,%esp
  8004f2:	52                   	push   %edx
  8004f3:	50                   	push   %eax
  8004f4:	68 84 24 80 00       	push   $0x802484
  8004f9:	e8 2a 03 00 00       	call   800828 <cprintf>
  8004fe:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800501:	a1 20 30 80 00       	mov    0x803020,%eax
  800506:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80050c:	a1 20 30 80 00       	mov    0x803020,%eax
  800511:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800517:	83 ec 04             	sub    $0x4,%esp
  80051a:	52                   	push   %edx
  80051b:	50                   	push   %eax
  80051c:	68 ac 24 80 00       	push   $0x8024ac
  800521:	e8 02 03 00 00       	call   800828 <cprintf>
  800526:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800529:	a1 20 30 80 00       	mov    0x803020,%eax
  80052e:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	50                   	push   %eax
  800538:	68 ed 24 80 00       	push   $0x8024ed
  80053d:	e8 e6 02 00 00       	call   800828 <cprintf>
  800542:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800545:	83 ec 0c             	sub    $0xc,%esp
  800548:	68 5c 24 80 00       	push   $0x80245c
  80054d:	e8 d6 02 00 00       	call   800828 <cprintf>
  800552:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800555:	e8 56 13 00 00       	call   8018b0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80055a:	e8 19 00 00 00       	call   800578 <exit>
}
  80055f:	90                   	nop
  800560:	c9                   	leave  
  800561:	c3                   	ret    

00800562 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800562:	55                   	push   %ebp
  800563:	89 e5                	mov    %esp,%ebp
  800565:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800568:	83 ec 0c             	sub    $0xc,%esp
  80056b:	6a 00                	push   $0x0
  80056d:	e8 55 11 00 00       	call   8016c7 <sys_env_destroy>
  800572:	83 c4 10             	add    $0x10,%esp
}
  800575:	90                   	nop
  800576:	c9                   	leave  
  800577:	c3                   	ret    

00800578 <exit>:

void
exit(void)
{
  800578:	55                   	push   %ebp
  800579:	89 e5                	mov    %esp,%ebp
  80057b:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80057e:	e8 aa 11 00 00       	call   80172d <sys_env_exit>
}
  800583:	90                   	nop
  800584:	c9                   	leave  
  800585:	c3                   	ret    

00800586 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800586:	55                   	push   %ebp
  800587:	89 e5                	mov    %esp,%ebp
  800589:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80058c:	8d 45 10             	lea    0x10(%ebp),%eax
  80058f:	83 c0 04             	add    $0x4,%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800595:	a1 18 31 80 00       	mov    0x803118,%eax
  80059a:	85 c0                	test   %eax,%eax
  80059c:	74 16                	je     8005b4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80059e:	a1 18 31 80 00       	mov    0x803118,%eax
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	50                   	push   %eax
  8005a7:	68 04 25 80 00       	push   $0x802504
  8005ac:	e8 77 02 00 00       	call   800828 <cprintf>
  8005b1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005b4:	a1 00 30 80 00       	mov    0x803000,%eax
  8005b9:	ff 75 0c             	pushl  0xc(%ebp)
  8005bc:	ff 75 08             	pushl  0x8(%ebp)
  8005bf:	50                   	push   %eax
  8005c0:	68 09 25 80 00       	push   $0x802509
  8005c5:	e8 5e 02 00 00       	call   800828 <cprintf>
  8005ca:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d6:	50                   	push   %eax
  8005d7:	e8 e1 01 00 00       	call   8007bd <vcprintf>
  8005dc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	6a 00                	push   $0x0
  8005e4:	68 25 25 80 00       	push   $0x802525
  8005e9:	e8 cf 01 00 00       	call   8007bd <vcprintf>
  8005ee:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005f1:	e8 82 ff ff ff       	call   800578 <exit>

	// should not return here
	while (1) ;
  8005f6:	eb fe                	jmp    8005f6 <_panic+0x70>

008005f8 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005f8:	55                   	push   %ebp
  8005f9:	89 e5                	mov    %esp,%ebp
  8005fb:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800603:	8b 50 74             	mov    0x74(%eax),%edx
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	39 c2                	cmp    %eax,%edx
  80060b:	74 14                	je     800621 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80060d:	83 ec 04             	sub    $0x4,%esp
  800610:	68 28 25 80 00       	push   $0x802528
  800615:	6a 26                	push   $0x26
  800617:	68 74 25 80 00       	push   $0x802574
  80061c:	e8 65 ff ff ff       	call   800586 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800621:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800628:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80062f:	e9 b6 00 00 00       	jmp    8006ea <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800637:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	01 d0                	add    %edx,%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	85 c0                	test   %eax,%eax
  800647:	75 08                	jne    800651 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800649:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80064c:	e9 96 00 00 00       	jmp    8006e7 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800651:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800658:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80065f:	eb 5d                	jmp    8006be <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800661:	a1 20 30 80 00       	mov    0x803020,%eax
  800666:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80066c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80066f:	c1 e2 04             	shl    $0x4,%edx
  800672:	01 d0                	add    %edx,%eax
  800674:	8a 40 04             	mov    0x4(%eax),%al
  800677:	84 c0                	test   %al,%al
  800679:	75 40                	jne    8006bb <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80067b:	a1 20 30 80 00       	mov    0x803020,%eax
  800680:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800686:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800689:	c1 e2 04             	shl    $0x4,%edx
  80068c:	01 d0                	add    %edx,%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800693:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800696:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80069b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80069d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	01 c8                	add    %ecx,%eax
  8006ac:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006ae:	39 c2                	cmp    %eax,%edx
  8006b0:	75 09                	jne    8006bb <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8006b2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006b9:	eb 12                	jmp    8006cd <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006bb:	ff 45 e8             	incl   -0x18(%ebp)
  8006be:	a1 20 30 80 00       	mov    0x803020,%eax
  8006c3:	8b 50 74             	mov    0x74(%eax),%edx
  8006c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006c9:	39 c2                	cmp    %eax,%edx
  8006cb:	77 94                	ja     800661 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006d1:	75 14                	jne    8006e7 <CheckWSWithoutLastIndex+0xef>
			panic(
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	68 80 25 80 00       	push   $0x802580
  8006db:	6a 3a                	push   $0x3a
  8006dd:	68 74 25 80 00       	push   $0x802574
  8006e2:	e8 9f fe ff ff       	call   800586 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006e7:	ff 45 f0             	incl   -0x10(%ebp)
  8006ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ed:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006f0:	0f 8c 3e ff ff ff    	jl     800634 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800704:	eb 20                	jmp    800726 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800706:	a1 20 30 80 00       	mov    0x803020,%eax
  80070b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800711:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800714:	c1 e2 04             	shl    $0x4,%edx
  800717:	01 d0                	add    %edx,%eax
  800719:	8a 40 04             	mov    0x4(%eax),%al
  80071c:	3c 01                	cmp    $0x1,%al
  80071e:	75 03                	jne    800723 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800720:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800723:	ff 45 e0             	incl   -0x20(%ebp)
  800726:	a1 20 30 80 00       	mov    0x803020,%eax
  80072b:	8b 50 74             	mov    0x74(%eax),%edx
  80072e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800731:	39 c2                	cmp    %eax,%edx
  800733:	77 d1                	ja     800706 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800738:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80073b:	74 14                	je     800751 <CheckWSWithoutLastIndex+0x159>
		panic(
  80073d:	83 ec 04             	sub    $0x4,%esp
  800740:	68 d4 25 80 00       	push   $0x8025d4
  800745:	6a 44                	push   $0x44
  800747:	68 74 25 80 00       	push   $0x802574
  80074c:	e8 35 fe ff ff       	call   800586 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800751:	90                   	nop
  800752:	c9                   	leave  
  800753:	c3                   	ret    

00800754 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
  800757:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	8d 48 01             	lea    0x1(%eax),%ecx
  800762:	8b 55 0c             	mov    0xc(%ebp),%edx
  800765:	89 0a                	mov    %ecx,(%edx)
  800767:	8b 55 08             	mov    0x8(%ebp),%edx
  80076a:	88 d1                	mov    %dl,%cl
  80076c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80076f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800773:	8b 45 0c             	mov    0xc(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	3d ff 00 00 00       	cmp    $0xff,%eax
  80077d:	75 2c                	jne    8007ab <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80077f:	a0 24 30 80 00       	mov    0x803024,%al
  800784:	0f b6 c0             	movzbl %al,%eax
  800787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80078a:	8b 12                	mov    (%edx),%edx
  80078c:	89 d1                	mov    %edx,%ecx
  80078e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800791:	83 c2 08             	add    $0x8,%edx
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	50                   	push   %eax
  800798:	51                   	push   %ecx
  800799:	52                   	push   %edx
  80079a:	e8 e6 0e 00 00       	call   801685 <sys_cputs>
  80079f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ae:	8b 40 04             	mov    0x4(%eax),%eax
  8007b1:	8d 50 01             	lea    0x1(%eax),%edx
  8007b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007ba:	90                   	nop
  8007bb:	c9                   	leave  
  8007bc:	c3                   	ret    

008007bd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007c6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007cd:	00 00 00 
	b.cnt = 0;
  8007d0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007d7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007da:	ff 75 0c             	pushl  0xc(%ebp)
  8007dd:	ff 75 08             	pushl  0x8(%ebp)
  8007e0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e6:	50                   	push   %eax
  8007e7:	68 54 07 80 00       	push   $0x800754
  8007ec:	e8 11 02 00 00       	call   800a02 <vprintfmt>
  8007f1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007f4:	a0 24 30 80 00       	mov    0x803024,%al
  8007f9:	0f b6 c0             	movzbl %al,%eax
  8007fc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800802:	83 ec 04             	sub    $0x4,%esp
  800805:	50                   	push   %eax
  800806:	52                   	push   %edx
  800807:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80080d:	83 c0 08             	add    $0x8,%eax
  800810:	50                   	push   %eax
  800811:	e8 6f 0e 00 00       	call   801685 <sys_cputs>
  800816:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800819:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800820:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800826:	c9                   	leave  
  800827:	c3                   	ret    

00800828 <cprintf>:

int cprintf(const char *fmt, ...) {
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80082e:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800835:	8d 45 0c             	lea    0xc(%ebp),%eax
  800838:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	ff 75 f4             	pushl  -0xc(%ebp)
  800844:	50                   	push   %eax
  800845:	e8 73 ff ff ff       	call   8007bd <vcprintf>
  80084a:	83 c4 10             	add    $0x10,%esp
  80084d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800850:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800853:	c9                   	leave  
  800854:	c3                   	ret    

00800855 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80085b:	e8 36 10 00 00       	call   801896 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800860:	8d 45 0c             	lea    0xc(%ebp),%eax
  800863:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	ff 75 f4             	pushl  -0xc(%ebp)
  80086f:	50                   	push   %eax
  800870:	e8 48 ff ff ff       	call   8007bd <vcprintf>
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80087b:	e8 30 10 00 00       	call   8018b0 <sys_enable_interrupt>
	return cnt;
  800880:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800883:	c9                   	leave  
  800884:	c3                   	ret    

00800885 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	53                   	push   %ebx
  800889:	83 ec 14             	sub    $0x14,%esp
  80088c:	8b 45 10             	mov    0x10(%ebp),%eax
  80088f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800898:	8b 45 18             	mov    0x18(%ebp),%eax
  80089b:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008a3:	77 55                	ja     8008fa <printnum+0x75>
  8008a5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008a8:	72 05                	jb     8008af <printnum+0x2a>
  8008aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008ad:	77 4b                	ja     8008fa <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008af:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008b2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8008b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bd:	52                   	push   %edx
  8008be:	50                   	push   %eax
  8008bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8008c5:	e8 a2 14 00 00       	call   801d6c <__udivdi3>
  8008ca:	83 c4 10             	add    $0x10,%esp
  8008cd:	83 ec 04             	sub    $0x4,%esp
  8008d0:	ff 75 20             	pushl  0x20(%ebp)
  8008d3:	53                   	push   %ebx
  8008d4:	ff 75 18             	pushl  0x18(%ebp)
  8008d7:	52                   	push   %edx
  8008d8:	50                   	push   %eax
  8008d9:	ff 75 0c             	pushl  0xc(%ebp)
  8008dc:	ff 75 08             	pushl  0x8(%ebp)
  8008df:	e8 a1 ff ff ff       	call   800885 <printnum>
  8008e4:	83 c4 20             	add    $0x20,%esp
  8008e7:	eb 1a                	jmp    800903 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	ff 75 20             	pushl  0x20(%ebp)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	ff d0                	call   *%eax
  8008f7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008fa:	ff 4d 1c             	decl   0x1c(%ebp)
  8008fd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800901:	7f e6                	jg     8008e9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800903:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800906:	bb 00 00 00 00       	mov    $0x0,%ebx
  80090b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800911:	53                   	push   %ebx
  800912:	51                   	push   %ecx
  800913:	52                   	push   %edx
  800914:	50                   	push   %eax
  800915:	e8 62 15 00 00       	call   801e7c <__umoddi3>
  80091a:	83 c4 10             	add    $0x10,%esp
  80091d:	05 34 28 80 00       	add    $0x802834,%eax
  800922:	8a 00                	mov    (%eax),%al
  800924:	0f be c0             	movsbl %al,%eax
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	50                   	push   %eax
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
}
  800936:	90                   	nop
  800937:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80093a:	c9                   	leave  
  80093b:	c3                   	ret    

0080093c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80093f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800943:	7e 1c                	jle    800961 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	8d 50 08             	lea    0x8(%eax),%edx
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	89 10                	mov    %edx,(%eax)
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	83 e8 08             	sub    $0x8,%eax
  80095a:	8b 50 04             	mov    0x4(%eax),%edx
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	eb 40                	jmp    8009a1 <getuint+0x65>
	else if (lflag)
  800961:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800965:	74 1e                	je     800985 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	8d 50 04             	lea    0x4(%eax),%edx
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	89 10                	mov    %edx,(%eax)
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 00                	mov    (%eax),%eax
  800979:	83 e8 04             	sub    $0x4,%eax
  80097c:	8b 00                	mov    (%eax),%eax
  80097e:	ba 00 00 00 00       	mov    $0x0,%edx
  800983:	eb 1c                	jmp    8009a1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	8b 00                	mov    (%eax),%eax
  80098a:	8d 50 04             	lea    0x4(%eax),%edx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	89 10                	mov    %edx,(%eax)
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	8b 00                	mov    (%eax),%eax
  800997:	83 e8 04             	sub    $0x4,%eax
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009a1:	5d                   	pop    %ebp
  8009a2:	c3                   	ret    

008009a3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009a6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009aa:	7e 1c                	jle    8009c8 <getint+0x25>
		return va_arg(*ap, long long);
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	8d 50 08             	lea    0x8(%eax),%edx
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	89 10                	mov    %edx,(%eax)
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	83 e8 08             	sub    $0x8,%eax
  8009c1:	8b 50 04             	mov    0x4(%eax),%edx
  8009c4:	8b 00                	mov    (%eax),%eax
  8009c6:	eb 38                	jmp    800a00 <getint+0x5d>
	else if (lflag)
  8009c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009cc:	74 1a                	je     8009e8 <getint+0x45>
		return va_arg(*ap, long);
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	8b 00                	mov    (%eax),%eax
  8009d3:	8d 50 04             	lea    0x4(%eax),%edx
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	89 10                	mov    %edx,(%eax)
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8b 00                	mov    (%eax),%eax
  8009e0:	83 e8 04             	sub    $0x4,%eax
  8009e3:	8b 00                	mov    (%eax),%eax
  8009e5:	99                   	cltd   
  8009e6:	eb 18                	jmp    800a00 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	8d 50 04             	lea    0x4(%eax),%edx
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	89 10                	mov    %edx,(%eax)
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	8b 00                	mov    (%eax),%eax
  8009fa:	83 e8 04             	sub    $0x4,%eax
  8009fd:	8b 00                	mov    (%eax),%eax
  8009ff:	99                   	cltd   
}
  800a00:	5d                   	pop    %ebp
  800a01:	c3                   	ret    

00800a02 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	56                   	push   %esi
  800a06:	53                   	push   %ebx
  800a07:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a0a:	eb 17                	jmp    800a23 <vprintfmt+0x21>
			if (ch == '\0')
  800a0c:	85 db                	test   %ebx,%ebx
  800a0e:	0f 84 af 03 00 00    	je     800dc3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a14:	83 ec 08             	sub    $0x8,%esp
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	53                   	push   %ebx
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a23:	8b 45 10             	mov    0x10(%ebp),%eax
  800a26:	8d 50 01             	lea    0x1(%eax),%edx
  800a29:	89 55 10             	mov    %edx,0x10(%ebp)
  800a2c:	8a 00                	mov    (%eax),%al
  800a2e:	0f b6 d8             	movzbl %al,%ebx
  800a31:	83 fb 25             	cmp    $0x25,%ebx
  800a34:	75 d6                	jne    800a0c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a36:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a3a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a41:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a48:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a4f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a56:	8b 45 10             	mov    0x10(%ebp),%eax
  800a59:	8d 50 01             	lea    0x1(%eax),%edx
  800a5c:	89 55 10             	mov    %edx,0x10(%ebp)
  800a5f:	8a 00                	mov    (%eax),%al
  800a61:	0f b6 d8             	movzbl %al,%ebx
  800a64:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a67:	83 f8 55             	cmp    $0x55,%eax
  800a6a:	0f 87 2b 03 00 00    	ja     800d9b <vprintfmt+0x399>
  800a70:	8b 04 85 58 28 80 00 	mov    0x802858(,%eax,4),%eax
  800a77:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a79:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a7d:	eb d7                	jmp    800a56 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a7f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a83:	eb d1                	jmp    800a56 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a85:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a8f:	89 d0                	mov    %edx,%eax
  800a91:	c1 e0 02             	shl    $0x2,%eax
  800a94:	01 d0                	add    %edx,%eax
  800a96:	01 c0                	add    %eax,%eax
  800a98:	01 d8                	add    %ebx,%eax
  800a9a:	83 e8 30             	sub    $0x30,%eax
  800a9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800aa0:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa3:	8a 00                	mov    (%eax),%al
  800aa5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aa8:	83 fb 2f             	cmp    $0x2f,%ebx
  800aab:	7e 3e                	jle    800aeb <vprintfmt+0xe9>
  800aad:	83 fb 39             	cmp    $0x39,%ebx
  800ab0:	7f 39                	jg     800aeb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ab2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ab5:	eb d5                	jmp    800a8c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aba:	83 c0 04             	add    $0x4,%eax
  800abd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	83 e8 04             	sub    $0x4,%eax
  800ac6:	8b 00                	mov    (%eax),%eax
  800ac8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800acb:	eb 1f                	jmp    800aec <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	79 83                	jns    800a56 <vprintfmt+0x54>
				width = 0;
  800ad3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ada:	e9 77 ff ff ff       	jmp    800a56 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800adf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ae6:	e9 6b ff ff ff       	jmp    800a56 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800aeb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800aec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af0:	0f 89 60 ff ff ff    	jns    800a56 <vprintfmt+0x54>
				width = precision, precision = -1;
  800af6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800af9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800afc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b03:	e9 4e ff ff ff       	jmp    800a56 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b08:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b0b:	e9 46 ff ff ff       	jmp    800a56 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b10:	8b 45 14             	mov    0x14(%ebp),%eax
  800b13:	83 c0 04             	add    $0x4,%eax
  800b16:	89 45 14             	mov    %eax,0x14(%ebp)
  800b19:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1c:	83 e8 04             	sub    $0x4,%eax
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	83 ec 08             	sub    $0x8,%esp
  800b24:	ff 75 0c             	pushl  0xc(%ebp)
  800b27:	50                   	push   %eax
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	ff d0                	call   *%eax
  800b2d:	83 c4 10             	add    $0x10,%esp
			break;
  800b30:	e9 89 02 00 00       	jmp    800dbe <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b35:	8b 45 14             	mov    0x14(%ebp),%eax
  800b38:	83 c0 04             	add    $0x4,%eax
  800b3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	83 e8 04             	sub    $0x4,%eax
  800b44:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b46:	85 db                	test   %ebx,%ebx
  800b48:	79 02                	jns    800b4c <vprintfmt+0x14a>
				err = -err;
  800b4a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b4c:	83 fb 64             	cmp    $0x64,%ebx
  800b4f:	7f 0b                	jg     800b5c <vprintfmt+0x15a>
  800b51:	8b 34 9d a0 26 80 00 	mov    0x8026a0(,%ebx,4),%esi
  800b58:	85 f6                	test   %esi,%esi
  800b5a:	75 19                	jne    800b75 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b5c:	53                   	push   %ebx
  800b5d:	68 45 28 80 00       	push   $0x802845
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	ff 75 08             	pushl  0x8(%ebp)
  800b68:	e8 5e 02 00 00       	call   800dcb <printfmt>
  800b6d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b70:	e9 49 02 00 00       	jmp    800dbe <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b75:	56                   	push   %esi
  800b76:	68 4e 28 80 00       	push   $0x80284e
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	ff 75 08             	pushl  0x8(%ebp)
  800b81:	e8 45 02 00 00       	call   800dcb <printfmt>
  800b86:	83 c4 10             	add    $0x10,%esp
			break;
  800b89:	e9 30 02 00 00       	jmp    800dbe <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b91:	83 c0 04             	add    $0x4,%eax
  800b94:	89 45 14             	mov    %eax,0x14(%ebp)
  800b97:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9a:	83 e8 04             	sub    $0x4,%eax
  800b9d:	8b 30                	mov    (%eax),%esi
  800b9f:	85 f6                	test   %esi,%esi
  800ba1:	75 05                	jne    800ba8 <vprintfmt+0x1a6>
				p = "(null)";
  800ba3:	be 51 28 80 00       	mov    $0x802851,%esi
			if (width > 0 && padc != '-')
  800ba8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bac:	7e 6d                	jle    800c1b <vprintfmt+0x219>
  800bae:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bb2:	74 67                	je     800c1b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	50                   	push   %eax
  800bbb:	56                   	push   %esi
  800bbc:	e8 0c 03 00 00       	call   800ecd <strnlen>
  800bc1:	83 c4 10             	add    $0x10,%esp
  800bc4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bc7:	eb 16                	jmp    800bdf <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bc9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	50                   	push   %eax
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	ff d0                	call   *%eax
  800bd9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bdc:	ff 4d e4             	decl   -0x1c(%ebp)
  800bdf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be3:	7f e4                	jg     800bc9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be5:	eb 34                	jmp    800c1b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800be7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800beb:	74 1c                	je     800c09 <vprintfmt+0x207>
  800bed:	83 fb 1f             	cmp    $0x1f,%ebx
  800bf0:	7e 05                	jle    800bf7 <vprintfmt+0x1f5>
  800bf2:	83 fb 7e             	cmp    $0x7e,%ebx
  800bf5:	7e 12                	jle    800c09 <vprintfmt+0x207>
					putch('?', putdat);
  800bf7:	83 ec 08             	sub    $0x8,%esp
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	6a 3f                	push   $0x3f
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	ff d0                	call   *%eax
  800c04:	83 c4 10             	add    $0x10,%esp
  800c07:	eb 0f                	jmp    800c18 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c09:	83 ec 08             	sub    $0x8,%esp
  800c0c:	ff 75 0c             	pushl  0xc(%ebp)
  800c0f:	53                   	push   %ebx
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	ff d0                	call   *%eax
  800c15:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c18:	ff 4d e4             	decl   -0x1c(%ebp)
  800c1b:	89 f0                	mov    %esi,%eax
  800c1d:	8d 70 01             	lea    0x1(%eax),%esi
  800c20:	8a 00                	mov    (%eax),%al
  800c22:	0f be d8             	movsbl %al,%ebx
  800c25:	85 db                	test   %ebx,%ebx
  800c27:	74 24                	je     800c4d <vprintfmt+0x24b>
  800c29:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c2d:	78 b8                	js     800be7 <vprintfmt+0x1e5>
  800c2f:	ff 4d e0             	decl   -0x20(%ebp)
  800c32:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c36:	79 af                	jns    800be7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c38:	eb 13                	jmp    800c4d <vprintfmt+0x24b>
				putch(' ', putdat);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	6a 20                	push   $0x20
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c4a:	ff 4d e4             	decl   -0x1c(%ebp)
  800c4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c51:	7f e7                	jg     800c3a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c53:	e9 66 01 00 00       	jmp    800dbe <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	ff 75 e8             	pushl  -0x18(%ebp)
  800c5e:	8d 45 14             	lea    0x14(%ebp),%eax
  800c61:	50                   	push   %eax
  800c62:	e8 3c fd ff ff       	call   8009a3 <getint>
  800c67:	83 c4 10             	add    $0x10,%esp
  800c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c76:	85 d2                	test   %edx,%edx
  800c78:	79 23                	jns    800c9d <vprintfmt+0x29b>
				putch('-', putdat);
  800c7a:	83 ec 08             	sub    $0x8,%esp
  800c7d:	ff 75 0c             	pushl  0xc(%ebp)
  800c80:	6a 2d                	push   $0x2d
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	ff d0                	call   *%eax
  800c87:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c90:	f7 d8                	neg    %eax
  800c92:	83 d2 00             	adc    $0x0,%edx
  800c95:	f7 da                	neg    %edx
  800c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c9d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ca4:	e9 bc 00 00 00       	jmp    800d65 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ca9:	83 ec 08             	sub    $0x8,%esp
  800cac:	ff 75 e8             	pushl  -0x18(%ebp)
  800caf:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb2:	50                   	push   %eax
  800cb3:	e8 84 fc ff ff       	call   80093c <getuint>
  800cb8:	83 c4 10             	add    $0x10,%esp
  800cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cc1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cc8:	e9 98 00 00 00       	jmp    800d65 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ccd:	83 ec 08             	sub    $0x8,%esp
  800cd0:	ff 75 0c             	pushl  0xc(%ebp)
  800cd3:	6a 58                	push   $0x58
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	ff d0                	call   *%eax
  800cda:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cdd:	83 ec 08             	sub    $0x8,%esp
  800ce0:	ff 75 0c             	pushl  0xc(%ebp)
  800ce3:	6a 58                	push   $0x58
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	ff d0                	call   *%eax
  800cea:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ced:	83 ec 08             	sub    $0x8,%esp
  800cf0:	ff 75 0c             	pushl  0xc(%ebp)
  800cf3:	6a 58                	push   $0x58
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	ff d0                	call   *%eax
  800cfa:	83 c4 10             	add    $0x10,%esp
			break;
  800cfd:	e9 bc 00 00 00       	jmp    800dbe <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d02:	83 ec 08             	sub    $0x8,%esp
  800d05:	ff 75 0c             	pushl  0xc(%ebp)
  800d08:	6a 30                	push   $0x30
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	ff d0                	call   *%eax
  800d0f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	6a 78                	push   $0x78
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	ff d0                	call   *%eax
  800d1f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d22:	8b 45 14             	mov    0x14(%ebp),%eax
  800d25:	83 c0 04             	add    $0x4,%eax
  800d28:	89 45 14             	mov    %eax,0x14(%ebp)
  800d2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2e:	83 e8 04             	sub    $0x4,%eax
  800d31:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d3d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d44:	eb 1f                	jmp    800d65 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	ff 75 e8             	pushl  -0x18(%ebp)
  800d4c:	8d 45 14             	lea    0x14(%ebp),%eax
  800d4f:	50                   	push   %eax
  800d50:	e8 e7 fb ff ff       	call   80093c <getuint>
  800d55:	83 c4 10             	add    $0x10,%esp
  800d58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d5e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d65:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	52                   	push   %edx
  800d70:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d73:	50                   	push   %eax
  800d74:	ff 75 f4             	pushl  -0xc(%ebp)
  800d77:	ff 75 f0             	pushl  -0x10(%ebp)
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	ff 75 08             	pushl  0x8(%ebp)
  800d80:	e8 00 fb ff ff       	call   800885 <printnum>
  800d85:	83 c4 20             	add    $0x20,%esp
			break;
  800d88:	eb 34                	jmp    800dbe <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d8a:	83 ec 08             	sub    $0x8,%esp
  800d8d:	ff 75 0c             	pushl  0xc(%ebp)
  800d90:	53                   	push   %ebx
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	ff d0                	call   *%eax
  800d96:	83 c4 10             	add    $0x10,%esp
			break;
  800d99:	eb 23                	jmp    800dbe <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d9b:	83 ec 08             	sub    $0x8,%esp
  800d9e:	ff 75 0c             	pushl  0xc(%ebp)
  800da1:	6a 25                	push   $0x25
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	ff d0                	call   *%eax
  800da8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dab:	ff 4d 10             	decl   0x10(%ebp)
  800dae:	eb 03                	jmp    800db3 <vprintfmt+0x3b1>
  800db0:	ff 4d 10             	decl   0x10(%ebp)
  800db3:	8b 45 10             	mov    0x10(%ebp),%eax
  800db6:	48                   	dec    %eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	3c 25                	cmp    $0x25,%al
  800dbb:	75 f3                	jne    800db0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800dbd:	90                   	nop
		}
	}
  800dbe:	e9 47 fc ff ff       	jmp    800a0a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dc3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    

00800dcb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dd1:	8d 45 10             	lea    0x10(%ebp),%eax
  800dd4:	83 c0 04             	add    $0x4,%eax
  800dd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dda:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddd:	ff 75 f4             	pushl  -0xc(%ebp)
  800de0:	50                   	push   %eax
  800de1:	ff 75 0c             	pushl  0xc(%ebp)
  800de4:	ff 75 08             	pushl  0x8(%ebp)
  800de7:	e8 16 fc ff ff       	call   800a02 <vprintfmt>
  800dec:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800def:	90                   	nop
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df8:	8b 40 08             	mov    0x8(%eax),%eax
  800dfb:	8d 50 01             	lea    0x1(%eax),%edx
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e07:	8b 10                	mov    (%eax),%edx
  800e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0c:	8b 40 04             	mov    0x4(%eax),%eax
  800e0f:	39 c2                	cmp    %eax,%edx
  800e11:	73 12                	jae    800e25 <sprintputch+0x33>
		*b->buf++ = ch;
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	8b 00                	mov    (%eax),%eax
  800e18:	8d 48 01             	lea    0x1(%eax),%ecx
  800e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1e:	89 0a                	mov    %ecx,(%edx)
  800e20:	8b 55 08             	mov    0x8(%ebp),%edx
  800e23:	88 10                	mov    %dl,(%eax)
}
  800e25:	90                   	nop
  800e26:	5d                   	pop    %ebp
  800e27:	c3                   	ret    

00800e28 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	01 d0                	add    %edx,%eax
  800e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e4d:	74 06                	je     800e55 <vsnprintf+0x2d>
  800e4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e53:	7f 07                	jg     800e5c <vsnprintf+0x34>
		return -E_INVAL;
  800e55:	b8 03 00 00 00       	mov    $0x3,%eax
  800e5a:	eb 20                	jmp    800e7c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e5c:	ff 75 14             	pushl  0x14(%ebp)
  800e5f:	ff 75 10             	pushl  0x10(%ebp)
  800e62:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e65:	50                   	push   %eax
  800e66:	68 f2 0d 80 00       	push   $0x800df2
  800e6b:	e8 92 fb ff ff       	call   800a02 <vprintfmt>
  800e70:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e76:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e7c:	c9                   	leave  
  800e7d:	c3                   	ret    

00800e7e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e84:	8d 45 10             	lea    0x10(%ebp),%eax
  800e87:	83 c0 04             	add    $0x4,%eax
  800e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e90:	ff 75 f4             	pushl  -0xc(%ebp)
  800e93:	50                   	push   %eax
  800e94:	ff 75 0c             	pushl  0xc(%ebp)
  800e97:	ff 75 08             	pushl  0x8(%ebp)
  800e9a:	e8 89 ff ff ff       	call   800e28 <vsnprintf>
  800e9f:	83 c4 10             	add    $0x10,%esp
  800ea2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800eb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb7:	eb 06                	jmp    800ebf <strlen+0x15>
		n++;
  800eb9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ebc:	ff 45 08             	incl   0x8(%ebp)
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	84 c0                	test   %al,%al
  800ec6:	75 f1                	jne    800eb9 <strlen+0xf>
		n++;
	return n;
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ecb:	c9                   	leave  
  800ecc:	c3                   	ret    

00800ecd <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ed3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eda:	eb 09                	jmp    800ee5 <strnlen+0x18>
		n++;
  800edc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800edf:	ff 45 08             	incl   0x8(%ebp)
  800ee2:	ff 4d 0c             	decl   0xc(%ebp)
  800ee5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ee9:	74 09                	je     800ef4 <strnlen+0x27>
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	84 c0                	test   %al,%al
  800ef2:	75 e8                	jne    800edc <strnlen+0xf>
		n++;
	return n;
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ef7:	c9                   	leave  
  800ef8:	c3                   	ret    

00800ef9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f05:	90                   	nop
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	8d 50 01             	lea    0x1(%eax),%edx
  800f0c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f12:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f15:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f18:	8a 12                	mov    (%edx),%dl
  800f1a:	88 10                	mov    %dl,(%eax)
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	75 e4                	jne    800f06 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f25:	c9                   	leave  
  800f26:	c3                   	ret    

00800f27 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f3a:	eb 1f                	jmp    800f5b <strncpy+0x34>
		*dst++ = *src;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8d 50 01             	lea    0x1(%eax),%edx
  800f42:	89 55 08             	mov    %edx,0x8(%ebp)
  800f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f48:	8a 12                	mov    (%edx),%dl
  800f4a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	84 c0                	test   %al,%al
  800f53:	74 03                	je     800f58 <strncpy+0x31>
			src++;
  800f55:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f58:	ff 45 fc             	incl   -0x4(%ebp)
  800f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f61:	72 d9                	jb     800f3c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f63:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f78:	74 30                	je     800faa <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f7a:	eb 16                	jmp    800f92 <strlcpy+0x2a>
			*dst++ = *src++;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8d 50 01             	lea    0x1(%eax),%edx
  800f82:	89 55 08             	mov    %edx,0x8(%ebp)
  800f85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f88:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f8b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f8e:	8a 12                	mov    (%edx),%dl
  800f90:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f92:	ff 4d 10             	decl   0x10(%ebp)
  800f95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f99:	74 09                	je     800fa4 <strlcpy+0x3c>
  800f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	84 c0                	test   %al,%al
  800fa2:	75 d8                	jne    800f7c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800faa:	8b 55 08             	mov    0x8(%ebp),%edx
  800fad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb0:	29 c2                	sub    %eax,%edx
  800fb2:	89 d0                	mov    %edx,%eax
}
  800fb4:	c9                   	leave  
  800fb5:	c3                   	ret    

00800fb6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fb9:	eb 06                	jmp    800fc1 <strcmp+0xb>
		p++, q++;
  800fbb:	ff 45 08             	incl   0x8(%ebp)
  800fbe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	84 c0                	test   %al,%al
  800fc8:	74 0e                	je     800fd8 <strcmp+0x22>
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 10                	mov    (%eax),%dl
  800fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	38 c2                	cmp    %al,%dl
  800fd6:	74 e3                	je     800fbb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f b6 d0             	movzbl %al,%edx
  800fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	0f b6 c0             	movzbl %al,%eax
  800fe8:	29 c2                	sub    %eax,%edx
  800fea:	89 d0                	mov    %edx,%eax
}
  800fec:	5d                   	pop    %ebp
  800fed:	c3                   	ret    

00800fee <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ff1:	eb 09                	jmp    800ffc <strncmp+0xe>
		n--, p++, q++;
  800ff3:	ff 4d 10             	decl   0x10(%ebp)
  800ff6:	ff 45 08             	incl   0x8(%ebp)
  800ff9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ffc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801000:	74 17                	je     801019 <strncmp+0x2b>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	84 c0                	test   %al,%al
  801009:	74 0e                	je     801019 <strncmp+0x2b>
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 10                	mov    (%eax),%dl
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	38 c2                	cmp    %al,%dl
  801017:	74 da                	je     800ff3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801019:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101d:	75 07                	jne    801026 <strncmp+0x38>
		return 0;
  80101f:	b8 00 00 00 00       	mov    $0x0,%eax
  801024:	eb 14                	jmp    80103a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	0f b6 d0             	movzbl %al,%edx
  80102e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	0f b6 c0             	movzbl %al,%eax
  801036:	29 c2                	sub    %eax,%edx
  801038:	89 d0                	mov    %edx,%eax
}
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    

0080103c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 04             	sub    $0x4,%esp
  801042:	8b 45 0c             	mov    0xc(%ebp),%eax
  801045:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801048:	eb 12                	jmp    80105c <strchr+0x20>
		if (*s == c)
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801052:	75 05                	jne    801059 <strchr+0x1d>
			return (char *) s;
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	eb 11                	jmp    80106a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801059:	ff 45 08             	incl   0x8(%ebp)
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	84 c0                	test   %al,%al
  801063:	75 e5                	jne    80104a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 04             	sub    $0x4,%esp
  801072:	8b 45 0c             	mov    0xc(%ebp),%eax
  801075:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801078:	eb 0d                	jmp    801087 <strfind+0x1b>
		if (*s == c)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801082:	74 0e                	je     801092 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801084:	ff 45 08             	incl   0x8(%ebp)
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	84 c0                	test   %al,%al
  80108e:	75 ea                	jne    80107a <strfind+0xe>
  801090:	eb 01                	jmp    801093 <strfind+0x27>
		if (*s == c)
			break;
  801092:	90                   	nop
	return (char *) s;
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801096:	c9                   	leave  
  801097:	c3                   	ret    

00801098 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010aa:	eb 0e                	jmp    8010ba <memset+0x22>
		*p++ = c;
  8010ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010af:	8d 50 01             	lea    0x1(%eax),%edx
  8010b2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010ba:	ff 4d f8             	decl   -0x8(%ebp)
  8010bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010c1:	79 e9                	jns    8010ac <memset+0x14>
		*p++ = c;

	return v;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c6:	c9                   	leave  
  8010c7:	c3                   	ret    

008010c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010da:	eb 16                	jmp    8010f2 <memcpy+0x2a>
		*d++ = *s++;
  8010dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010df:	8d 50 01             	lea    0x1(%eax),%edx
  8010e2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010eb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010ee:	8a 12                	mov    (%edx),%dl
  8010f0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f8:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	75 dd                	jne    8010dc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801116:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801119:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80111c:	73 50                	jae    80116e <memmove+0x6a>
  80111e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801121:	8b 45 10             	mov    0x10(%ebp),%eax
  801124:	01 d0                	add    %edx,%eax
  801126:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801129:	76 43                	jbe    80116e <memmove+0x6a>
		s += n;
  80112b:	8b 45 10             	mov    0x10(%ebp),%eax
  80112e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801131:	8b 45 10             	mov    0x10(%ebp),%eax
  801134:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801137:	eb 10                	jmp    801149 <memmove+0x45>
			*--d = *--s;
  801139:	ff 4d f8             	decl   -0x8(%ebp)
  80113c:	ff 4d fc             	decl   -0x4(%ebp)
  80113f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801142:	8a 10                	mov    (%eax),%dl
  801144:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801147:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801149:	8b 45 10             	mov    0x10(%ebp),%eax
  80114c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114f:	89 55 10             	mov    %edx,0x10(%ebp)
  801152:	85 c0                	test   %eax,%eax
  801154:	75 e3                	jne    801139 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801156:	eb 23                	jmp    80117b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801158:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115b:	8d 50 01             	lea    0x1(%eax),%edx
  80115e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801161:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801164:	8d 4a 01             	lea    0x1(%edx),%ecx
  801167:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80116a:	8a 12                	mov    (%edx),%dl
  80116c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80116e:	8b 45 10             	mov    0x10(%ebp),%eax
  801171:	8d 50 ff             	lea    -0x1(%eax),%edx
  801174:	89 55 10             	mov    %edx,0x10(%ebp)
  801177:	85 c0                	test   %eax,%eax
  801179:	75 dd                	jne    801158 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80117e:	c9                   	leave  
  80117f:	c3                   	ret    

00801180 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801192:	eb 2a                	jmp    8011be <memcmp+0x3e>
		if (*s1 != *s2)
  801194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801197:	8a 10                	mov    (%eax),%dl
  801199:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119c:	8a 00                	mov    (%eax),%al
  80119e:	38 c2                	cmp    %al,%dl
  8011a0:	74 16                	je     8011b8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	0f b6 d0             	movzbl %al,%edx
  8011aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	0f b6 c0             	movzbl %al,%eax
  8011b2:	29 c2                	sub    %eax,%edx
  8011b4:	89 d0                	mov    %edx,%eax
  8011b6:	eb 18                	jmp    8011d0 <memcmp+0x50>
		s1++, s2++;
  8011b8:	ff 45 fc             	incl   -0x4(%ebp)
  8011bb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011be:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c4:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	75 c9                	jne    801194 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d0:	c9                   	leave  
  8011d1:	c3                   	ret    

008011d2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011db:	8b 45 10             	mov    0x10(%ebp),%eax
  8011de:	01 d0                	add    %edx,%eax
  8011e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011e3:	eb 15                	jmp    8011fa <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	0f b6 d0             	movzbl %al,%edx
  8011ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f0:	0f b6 c0             	movzbl %al,%eax
  8011f3:	39 c2                	cmp    %eax,%edx
  8011f5:	74 0d                	je     801204 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011f7:	ff 45 08             	incl   0x8(%ebp)
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801200:	72 e3                	jb     8011e5 <memfind+0x13>
  801202:	eb 01                	jmp    801205 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801204:	90                   	nop
	return (void *) s;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801208:	c9                   	leave  
  801209:	c3                   	ret    

0080120a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801210:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801217:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80121e:	eb 03                	jmp    801223 <strtol+0x19>
		s++;
  801220:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	3c 20                	cmp    $0x20,%al
  80122a:	74 f4                	je     801220 <strtol+0x16>
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	3c 09                	cmp    $0x9,%al
  801233:	74 eb                	je     801220 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	3c 2b                	cmp    $0x2b,%al
  80123c:	75 05                	jne    801243 <strtol+0x39>
		s++;
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	eb 13                	jmp    801256 <strtol+0x4c>
	else if (*s == '-')
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	3c 2d                	cmp    $0x2d,%al
  80124a:	75 0a                	jne    801256 <strtol+0x4c>
		s++, neg = 1;
  80124c:	ff 45 08             	incl   0x8(%ebp)
  80124f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801256:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125a:	74 06                	je     801262 <strtol+0x58>
  80125c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801260:	75 20                	jne    801282 <strtol+0x78>
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	3c 30                	cmp    $0x30,%al
  801269:	75 17                	jne    801282 <strtol+0x78>
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	40                   	inc    %eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 78                	cmp    $0x78,%al
  801273:	75 0d                	jne    801282 <strtol+0x78>
		s += 2, base = 16;
  801275:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801279:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801280:	eb 28                	jmp    8012aa <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801282:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801286:	75 15                	jne    80129d <strtol+0x93>
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	3c 30                	cmp    $0x30,%al
  80128f:	75 0c                	jne    80129d <strtol+0x93>
		s++, base = 8;
  801291:	ff 45 08             	incl   0x8(%ebp)
  801294:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80129b:	eb 0d                	jmp    8012aa <strtol+0xa0>
	else if (base == 0)
  80129d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a1:	75 07                	jne    8012aa <strtol+0xa0>
		base = 10;
  8012a3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	3c 2f                	cmp    $0x2f,%al
  8012b1:	7e 19                	jle    8012cc <strtol+0xc2>
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	8a 00                	mov    (%eax),%al
  8012b8:	3c 39                	cmp    $0x39,%al
  8012ba:	7f 10                	jg     8012cc <strtol+0xc2>
			dig = *s - '0';
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	8a 00                	mov    (%eax),%al
  8012c1:	0f be c0             	movsbl %al,%eax
  8012c4:	83 e8 30             	sub    $0x30,%eax
  8012c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ca:	eb 42                	jmp    80130e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	8a 00                	mov    (%eax),%al
  8012d1:	3c 60                	cmp    $0x60,%al
  8012d3:	7e 19                	jle    8012ee <strtol+0xe4>
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	8a 00                	mov    (%eax),%al
  8012da:	3c 7a                	cmp    $0x7a,%al
  8012dc:	7f 10                	jg     8012ee <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	0f be c0             	movsbl %al,%eax
  8012e6:	83 e8 57             	sub    $0x57,%eax
  8012e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ec:	eb 20                	jmp    80130e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	3c 40                	cmp    $0x40,%al
  8012f5:	7e 39                	jle    801330 <strtol+0x126>
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	3c 5a                	cmp    $0x5a,%al
  8012fe:	7f 30                	jg     801330 <strtol+0x126>
			dig = *s - 'A' + 10;
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	0f be c0             	movsbl %al,%eax
  801308:	83 e8 37             	sub    $0x37,%eax
  80130b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80130e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801311:	3b 45 10             	cmp    0x10(%ebp),%eax
  801314:	7d 19                	jge    80132f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801316:	ff 45 08             	incl   0x8(%ebp)
  801319:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801320:	89 c2                	mov    %eax,%edx
  801322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801325:	01 d0                	add    %edx,%eax
  801327:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80132a:	e9 7b ff ff ff       	jmp    8012aa <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80132f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801330:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801334:	74 08                	je     80133e <strtol+0x134>
		*endptr = (char *) s;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	8b 55 08             	mov    0x8(%ebp),%edx
  80133c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80133e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801342:	74 07                	je     80134b <strtol+0x141>
  801344:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801347:	f7 d8                	neg    %eax
  801349:	eb 03                	jmp    80134e <strtol+0x144>
  80134b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <ltostr>:

void
ltostr(long value, char *str)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801356:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80135d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801364:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801368:	79 13                	jns    80137d <ltostr+0x2d>
	{
		neg = 1;
  80136a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801377:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80137a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801385:	99                   	cltd   
  801386:	f7 f9                	idiv   %ecx
  801388:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80138b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138e:	8d 50 01             	lea    0x1(%eax),%edx
  801391:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801394:	89 c2                	mov    %eax,%edx
  801396:	8b 45 0c             	mov    0xc(%ebp),%eax
  801399:	01 d0                	add    %edx,%eax
  80139b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80139e:	83 c2 30             	add    $0x30,%edx
  8013a1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013ab:	f7 e9                	imul   %ecx
  8013ad:	c1 fa 02             	sar    $0x2,%edx
  8013b0:	89 c8                	mov    %ecx,%eax
  8013b2:	c1 f8 1f             	sar    $0x1f,%eax
  8013b5:	29 c2                	sub    %eax,%edx
  8013b7:	89 d0                	mov    %edx,%eax
  8013b9:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8013bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013bf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013c4:	f7 e9                	imul   %ecx
  8013c6:	c1 fa 02             	sar    $0x2,%edx
  8013c9:	89 c8                	mov    %ecx,%eax
  8013cb:	c1 f8 1f             	sar    $0x1f,%eax
  8013ce:	29 c2                	sub    %eax,%edx
  8013d0:	89 d0                	mov    %edx,%eax
  8013d2:	c1 e0 02             	shl    $0x2,%eax
  8013d5:	01 d0                	add    %edx,%eax
  8013d7:	01 c0                	add    %eax,%eax
  8013d9:	29 c1                	sub    %eax,%ecx
  8013db:	89 ca                	mov    %ecx,%edx
  8013dd:	85 d2                	test   %edx,%edx
  8013df:	75 9c                	jne    80137d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013eb:	48                   	dec    %eax
  8013ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013f3:	74 3d                	je     801432 <ltostr+0xe2>
		start = 1 ;
  8013f5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013fc:	eb 34                	jmp    801432 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801401:	8b 45 0c             	mov    0xc(%ebp),%eax
  801404:	01 d0                	add    %edx,%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80140b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801411:	01 c2                	add    %eax,%edx
  801413:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801416:	8b 45 0c             	mov    0xc(%ebp),%eax
  801419:	01 c8                	add    %ecx,%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80141f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	01 c2                	add    %eax,%edx
  801427:	8a 45 eb             	mov    -0x15(%ebp),%al
  80142a:	88 02                	mov    %al,(%edx)
		start++ ;
  80142c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80142f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801435:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801438:	7c c4                	jl     8013fe <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80143a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80143d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801440:	01 d0                	add    %edx,%eax
  801442:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801445:	90                   	nop
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80144e:	ff 75 08             	pushl  0x8(%ebp)
  801451:	e8 54 fa ff ff       	call   800eaa <strlen>
  801456:	83 c4 04             	add    $0x4,%esp
  801459:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	e8 46 fa ff ff       	call   800eaa <strlen>
  801464:	83 c4 04             	add    $0x4,%esp
  801467:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80146a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801471:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801478:	eb 17                	jmp    801491 <strcconcat+0x49>
		final[s] = str1[s] ;
  80147a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147d:	8b 45 10             	mov    0x10(%ebp),%eax
  801480:	01 c2                	add    %eax,%edx
  801482:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	01 c8                	add    %ecx,%eax
  80148a:	8a 00                	mov    (%eax),%al
  80148c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80148e:	ff 45 fc             	incl   -0x4(%ebp)
  801491:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801494:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801497:	7c e1                	jl     80147a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801499:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014a0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014a7:	eb 1f                	jmp    8014c8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ac:	8d 50 01             	lea    0x1(%eax),%edx
  8014af:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014b2:	89 c2                	mov    %eax,%edx
  8014b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b7:	01 c2                	add    %eax,%edx
  8014b9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bf:	01 c8                	add    %ecx,%eax
  8014c1:	8a 00                	mov    (%eax),%al
  8014c3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014c5:	ff 45 f8             	incl   -0x8(%ebp)
  8014c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014ce:	7c d9                	jl     8014a9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	01 d0                	add    %edx,%eax
  8014d8:	c6 00 00             	movb   $0x0,(%eax)
}
  8014db:	90                   	nop
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ed:	8b 00                	mov    (%eax),%eax
  8014ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f9:	01 d0                	add    %edx,%eax
  8014fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801501:	eb 0c                	jmp    80150f <strsplit+0x31>
			*string++ = 0;
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	8d 50 01             	lea    0x1(%eax),%edx
  801509:	89 55 08             	mov    %edx,0x8(%ebp)
  80150c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	84 c0                	test   %al,%al
  801516:	74 18                	je     801530 <strsplit+0x52>
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	8a 00                	mov    (%eax),%al
  80151d:	0f be c0             	movsbl %al,%eax
  801520:	50                   	push   %eax
  801521:	ff 75 0c             	pushl  0xc(%ebp)
  801524:	e8 13 fb ff ff       	call   80103c <strchr>
  801529:	83 c4 08             	add    $0x8,%esp
  80152c:	85 c0                	test   %eax,%eax
  80152e:	75 d3                	jne    801503 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	8a 00                	mov    (%eax),%al
  801535:	84 c0                	test   %al,%al
  801537:	74 5a                	je     801593 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801539:	8b 45 14             	mov    0x14(%ebp),%eax
  80153c:	8b 00                	mov    (%eax),%eax
  80153e:	83 f8 0f             	cmp    $0xf,%eax
  801541:	75 07                	jne    80154a <strsplit+0x6c>
		{
			return 0;
  801543:	b8 00 00 00 00       	mov    $0x0,%eax
  801548:	eb 66                	jmp    8015b0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80154a:	8b 45 14             	mov    0x14(%ebp),%eax
  80154d:	8b 00                	mov    (%eax),%eax
  80154f:	8d 48 01             	lea    0x1(%eax),%ecx
  801552:	8b 55 14             	mov    0x14(%ebp),%edx
  801555:	89 0a                	mov    %ecx,(%edx)
  801557:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80155e:	8b 45 10             	mov    0x10(%ebp),%eax
  801561:	01 c2                	add    %eax,%edx
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801568:	eb 03                	jmp    80156d <strsplit+0x8f>
			string++;
  80156a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	8a 00                	mov    (%eax),%al
  801572:	84 c0                	test   %al,%al
  801574:	74 8b                	je     801501 <strsplit+0x23>
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
  801579:	8a 00                	mov    (%eax),%al
  80157b:	0f be c0             	movsbl %al,%eax
  80157e:	50                   	push   %eax
  80157f:	ff 75 0c             	pushl  0xc(%ebp)
  801582:	e8 b5 fa ff ff       	call   80103c <strchr>
  801587:	83 c4 08             	add    $0x8,%esp
  80158a:	85 c0                	test   %eax,%eax
  80158c:	74 dc                	je     80156a <strsplit+0x8c>
			string++;
	}
  80158e:	e9 6e ff ff ff       	jmp    801501 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801593:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801594:	8b 45 14             	mov    0x14(%ebp),%eax
  801597:	8b 00                	mov    (%eax),%eax
  801599:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a3:	01 d0                	add    %edx,%eax
  8015a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015ab:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	68 b0 29 80 00       	push   $0x8029b0
  8015c0:	6a 19                	push   $0x19
  8015c2:	68 d5 29 80 00       	push   $0x8029d5
  8015c7:	e8 ba ef ff ff       	call   800586 <_panic>

008015cc <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	83 ec 18             	sub    $0x18,%esp
  8015d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d5:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	68 e4 29 80 00       	push   $0x8029e4
  8015e0:	6a 31                	push   $0x31
  8015e2:	68 d5 29 80 00       	push   $0x8029d5
  8015e7:	e8 9a ef ff ff       	call   800586 <_panic>

008015ec <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 0c 2a 80 00       	push   $0x802a0c
  8015fa:	6a 4a                	push   $0x4a
  8015fc:	68 d5 29 80 00       	push   $0x8029d5
  801601:	e8 80 ef ff ff       	call   800586 <_panic>

00801606 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	68 30 2a 80 00       	push   $0x802a30
  801614:	6a 70                	push   $0x70
  801616:	68 d5 29 80 00       	push   $0x8029d5
  80161b:	e8 66 ef ff ff       	call   800586 <_panic>

00801620 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801626:	83 ec 04             	sub    $0x4,%esp
  801629:	68 54 2a 80 00       	push   $0x802a54
  80162e:	68 8b 00 00 00       	push   $0x8b
  801633:	68 d5 29 80 00       	push   $0x8029d5
  801638:	e8 49 ef ff ff       	call   800586 <_panic>

0080163d <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801643:	83 ec 04             	sub    $0x4,%esp
  801646:	68 78 2a 80 00       	push   $0x802a78
  80164b:	68 a8 00 00 00       	push   $0xa8
  801650:	68 d5 29 80 00       	push   $0x8029d5
  801655:	e8 2c ef ff ff       	call   800586 <_panic>

0080165a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	57                   	push   %edi
  80165e:	56                   	push   %esi
  80165f:	53                   	push   %ebx
  801660:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	8b 55 0c             	mov    0xc(%ebp),%edx
  801669:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80166c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80166f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801672:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801675:	cd 30                	int    $0x30
  801677:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80167a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	5b                   	pop    %ebx
  801681:	5e                   	pop    %esi
  801682:	5f                   	pop    %edi
  801683:	5d                   	pop    %ebp
  801684:	c3                   	ret    

00801685 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	8b 45 10             	mov    0x10(%ebp),%eax
  80168e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801691:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	52                   	push   %edx
  80169d:	ff 75 0c             	pushl  0xc(%ebp)
  8016a0:	50                   	push   %eax
  8016a1:	6a 00                	push   $0x0
  8016a3:	e8 b2 ff ff ff       	call   80165a <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
}
  8016ab:	90                   	nop
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 01                	push   $0x1
  8016bd:	e8 98 ff ff ff       	call   80165a <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	50                   	push   %eax
  8016d6:	6a 05                	push   $0x5
  8016d8:	e8 7d ff ff ff       	call   80165a <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 02                	push   $0x2
  8016f1:	e8 64 ff ff ff       	call   80165a <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 03                	push   $0x3
  80170a:	e8 4b ff ff ff       	call   80165a <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 04                	push   $0x4
  801723:	e8 32 ff ff ff       	call   80165a <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_env_exit>:


void sys_env_exit(void)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 06                	push   $0x6
  80173c:	e8 19 ff ff ff       	call   80165a <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	90                   	nop
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80174a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	52                   	push   %edx
  801757:	50                   	push   %eax
  801758:	6a 07                	push   $0x7
  80175a:	e8 fb fe ff ff       	call   80165a <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	56                   	push   %esi
  801768:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801769:	8b 75 18             	mov    0x18(%ebp),%esi
  80176c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80176f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801772:	8b 55 0c             	mov    0xc(%ebp),%edx
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	56                   	push   %esi
  801779:	53                   	push   %ebx
  80177a:	51                   	push   %ecx
  80177b:	52                   	push   %edx
  80177c:	50                   	push   %eax
  80177d:	6a 08                	push   $0x8
  80177f:	e8 d6 fe ff ff       	call   80165a <syscall>
  801784:	83 c4 18             	add    $0x18,%esp
}
  801787:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178a:	5b                   	pop    %ebx
  80178b:	5e                   	pop    %esi
  80178c:	5d                   	pop    %ebp
  80178d:	c3                   	ret    

0080178e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801791:	8b 55 0c             	mov    0xc(%ebp),%edx
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	52                   	push   %edx
  80179e:	50                   	push   %eax
  80179f:	6a 09                	push   $0x9
  8017a1:	e8 b4 fe ff ff       	call   80165a <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	ff 75 0c             	pushl  0xc(%ebp)
  8017b7:	ff 75 08             	pushl  0x8(%ebp)
  8017ba:	6a 0a                	push   $0xa
  8017bc:	e8 99 fe ff ff       	call   80165a <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
}
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 0b                	push   $0xb
  8017d5:	e8 80 fe ff ff       	call   80165a <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 0c                	push   $0xc
  8017ee:	e8 67 fe ff ff       	call   80165a <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 0d                	push   $0xd
  801807:	e8 4e fe ff ff       	call   80165a <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	ff 75 0c             	pushl  0xc(%ebp)
  80181d:	ff 75 08             	pushl  0x8(%ebp)
  801820:	6a 11                	push   $0x11
  801822:	e8 33 fe ff ff       	call   80165a <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
	return;
  80182a:	90                   	nop
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	ff 75 0c             	pushl  0xc(%ebp)
  801839:	ff 75 08             	pushl  0x8(%ebp)
  80183c:	6a 12                	push   $0x12
  80183e:	e8 17 fe ff ff       	call   80165a <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
	return ;
  801846:	90                   	nop
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 0e                	push   $0xe
  801858:	e8 fd fd ff ff       	call   80165a <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	ff 75 08             	pushl  0x8(%ebp)
  801870:	6a 0f                	push   $0xf
  801872:	e8 e3 fd ff ff       	call   80165a <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 10                	push   $0x10
  80188b:	e8 ca fd ff ff       	call   80165a <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 14                	push   $0x14
  8018a5:	e8 b0 fd ff ff       	call   80165a <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	90                   	nop
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 15                	push   $0x15
  8018bf:	e8 96 fd ff ff       	call   80165a <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	90                   	nop
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_cputc>:


void
sys_cputc(const char c)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	83 ec 04             	sub    $0x4,%esp
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018d6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	50                   	push   %eax
  8018e3:	6a 16                	push   $0x16
  8018e5:	e8 70 fd ff ff       	call   80165a <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
}
  8018ed:	90                   	nop
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 17                	push   $0x17
  8018ff:	e8 56 fd ff ff       	call   80165a <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	90                   	nop
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	ff 75 0c             	pushl  0xc(%ebp)
  801919:	50                   	push   %eax
  80191a:	6a 18                	push   $0x18
  80191c:	e8 39 fd ff ff       	call   80165a <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801929:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	52                   	push   %edx
  801936:	50                   	push   %eax
  801937:	6a 1b                	push   $0x1b
  801939:	e8 1c fd ff ff       	call   80165a <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801946:	8b 55 0c             	mov    0xc(%ebp),%edx
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	52                   	push   %edx
  801953:	50                   	push   %eax
  801954:	6a 19                	push   $0x19
  801956:	e8 ff fc ff ff       	call   80165a <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	90                   	nop
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801964:	8b 55 0c             	mov    0xc(%ebp),%edx
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	52                   	push   %edx
  801971:	50                   	push   %eax
  801972:	6a 1a                	push   $0x1a
  801974:	e8 e1 fc ff ff       	call   80165a <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	90                   	nop
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	8b 45 10             	mov    0x10(%ebp),%eax
  801988:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80198b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80198e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	51                   	push   %ecx
  801998:	52                   	push   %edx
  801999:	ff 75 0c             	pushl  0xc(%ebp)
  80199c:	50                   	push   %eax
  80199d:	6a 1c                	push   $0x1c
  80199f:	e8 b6 fc ff ff       	call   80165a <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	52                   	push   %edx
  8019b9:	50                   	push   %eax
  8019ba:	6a 1d                	push   $0x1d
  8019bc:	e8 99 fc ff ff       	call   80165a <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	51                   	push   %ecx
  8019d7:	52                   	push   %edx
  8019d8:	50                   	push   %eax
  8019d9:	6a 1e                	push   $0x1e
  8019db:	e8 7a fc ff ff       	call   80165a <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	52                   	push   %edx
  8019f5:	50                   	push   %eax
  8019f6:	6a 1f                	push   $0x1f
  8019f8:	e8 5d fc ff ff       	call   80165a <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 20                	push   $0x20
  801a11:	e8 44 fc ff ff       	call   80165a <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	ff 75 10             	pushl  0x10(%ebp)
  801a28:	ff 75 0c             	pushl  0xc(%ebp)
  801a2b:	50                   	push   %eax
  801a2c:	6a 21                	push   $0x21
  801a2e:	e8 27 fc ff ff       	call   80165a <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	50                   	push   %eax
  801a47:	6a 22                	push   $0x22
  801a49:	e8 0c fc ff ff       	call   80165a <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	90                   	nop
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	50                   	push   %eax
  801a63:	6a 23                	push   $0x23
  801a65:	e8 f0 fb ff ff       	call   80165a <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	90                   	nop
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a76:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a79:	8d 50 04             	lea    0x4(%eax),%edx
  801a7c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	52                   	push   %edx
  801a86:	50                   	push   %eax
  801a87:	6a 24                	push   $0x24
  801a89:	e8 cc fb ff ff       	call   80165a <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
	return result;
  801a91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a9a:	89 01                	mov    %eax,(%ecx)
  801a9c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	c9                   	leave  
  801aa3:	c2 04 00             	ret    $0x4

00801aa6 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	ff 75 10             	pushl  0x10(%ebp)
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	ff 75 08             	pushl  0x8(%ebp)
  801ab6:	6a 13                	push   $0x13
  801ab8:	e8 9d fb ff ff       	call   80165a <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac0:	90                   	nop
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 25                	push   $0x25
  801ad2:	e8 83 fb ff ff       	call   80165a <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ae8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	50                   	push   %eax
  801af5:	6a 26                	push   $0x26
  801af7:	e8 5e fb ff ff       	call   80165a <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
	return ;
  801aff:	90                   	nop
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <rsttst>:
void rsttst()
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 28                	push   $0x28
  801b11:	e8 44 fb ff ff       	call   80165a <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
	return ;
  801b19:	90                   	nop
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	8b 45 14             	mov    0x14(%ebp),%eax
  801b25:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b28:	8b 55 18             	mov    0x18(%ebp),%edx
  801b2b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b2f:	52                   	push   %edx
  801b30:	50                   	push   %eax
  801b31:	ff 75 10             	pushl  0x10(%ebp)
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	ff 75 08             	pushl  0x8(%ebp)
  801b3a:	6a 27                	push   $0x27
  801b3c:	e8 19 fb ff ff       	call   80165a <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
	return ;
  801b44:	90                   	nop
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <chktst>:
void chktst(uint32 n)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	ff 75 08             	pushl  0x8(%ebp)
  801b55:	6a 29                	push   $0x29
  801b57:	e8 fe fa ff ff       	call   80165a <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5f:	90                   	nop
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <inctst>:

void inctst()
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 2a                	push   $0x2a
  801b71:	e8 e4 fa ff ff       	call   80165a <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
	return ;
  801b79:	90                   	nop
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <gettst>:
uint32 gettst()
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 2b                	push   $0x2b
  801b8b:	e8 ca fa ff ff       	call   80165a <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 2c                	push   $0x2c
  801ba7:	e8 ae fa ff ff       	call   80165a <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
  801baf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bb2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bb6:	75 07                	jne    801bbf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bb8:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbd:	eb 05                	jmp    801bc4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 2c                	push   $0x2c
  801bd8:	e8 7d fa ff ff       	call   80165a <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
  801be0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801be3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801be7:	75 07                	jne    801bf0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801be9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bee:	eb 05                	jmp    801bf5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 2c                	push   $0x2c
  801c09:	e8 4c fa ff ff       	call   80165a <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
  801c11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c14:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c18:	75 07                	jne    801c21 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1f:	eb 05                	jmp    801c26 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 2c                	push   $0x2c
  801c3a:	e8 1b fa ff ff       	call   80165a <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
  801c42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c45:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c49:	75 07                	jne    801c52 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c4b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c50:	eb 05                	jmp    801c57 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	ff 75 08             	pushl  0x8(%ebp)
  801c67:	6a 2d                	push   $0x2d
  801c69:	e8 ec f9 ff ff       	call   80165a <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c71:	90                   	nop
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c78:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	6a 00                	push   $0x0
  801c86:	53                   	push   %ebx
  801c87:	51                   	push   %ecx
  801c88:	52                   	push   %edx
  801c89:	50                   	push   %eax
  801c8a:	6a 2e                	push   $0x2e
  801c8c:	e8 c9 f9 ff ff       	call   80165a <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
}
  801c94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	52                   	push   %edx
  801ca9:	50                   	push   %eax
  801caa:	6a 2f                	push   $0x2f
  801cac:	e8 a9 f9 ff ff       	call   80165a <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801cbc:	8b 55 08             	mov    0x8(%ebp),%edx
  801cbf:	89 d0                	mov    %edx,%eax
  801cc1:	c1 e0 02             	shl    $0x2,%eax
  801cc4:	01 d0                	add    %edx,%eax
  801cc6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ccd:	01 d0                	add    %edx,%eax
  801ccf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cd6:	01 d0                	add    %edx,%eax
  801cd8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cdf:	01 d0                	add    %edx,%eax
  801ce1:	c1 e0 04             	shl    $0x4,%eax
  801ce4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801ce7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801cee:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801cf1:	83 ec 0c             	sub    $0xc,%esp
  801cf4:	50                   	push   %eax
  801cf5:	e8 76 fd ff ff       	call   801a70 <sys_get_virtual_time>
  801cfa:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801cfd:	eb 41                	jmp    801d40 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801cff:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801d02:	83 ec 0c             	sub    $0xc,%esp
  801d05:	50                   	push   %eax
  801d06:	e8 65 fd ff ff       	call   801a70 <sys_get_virtual_time>
  801d0b:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801d0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d14:	29 c2                	sub    %eax,%edx
  801d16:	89 d0                	mov    %edx,%eax
  801d18:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801d1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d21:	89 d1                	mov    %edx,%ecx
  801d23:	29 c1                	sub    %eax,%ecx
  801d25:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d2b:	39 c2                	cmp    %eax,%edx
  801d2d:	0f 97 c0             	seta   %al
  801d30:	0f b6 c0             	movzbl %al,%eax
  801d33:	29 c1                	sub    %eax,%ecx
  801d35:	89 c8                	mov    %ecx,%eax
  801d37:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801d3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d43:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d46:	72 b7                	jb     801cff <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801d48:	90                   	nop
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801d51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801d58:	eb 03                	jmp    801d5d <busy_wait+0x12>
  801d5a:	ff 45 fc             	incl   -0x4(%ebp)
  801d5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d60:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d63:	72 f5                	jb     801d5a <busy_wait+0xf>
	return i;
  801d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    
  801d6a:	66 90                	xchg   %ax,%ax

00801d6c <__udivdi3>:
  801d6c:	55                   	push   %ebp
  801d6d:	57                   	push   %edi
  801d6e:	56                   	push   %esi
  801d6f:	53                   	push   %ebx
  801d70:	83 ec 1c             	sub    $0x1c,%esp
  801d73:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d77:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d7f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d83:	89 ca                	mov    %ecx,%edx
  801d85:	89 f8                	mov    %edi,%eax
  801d87:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d8b:	85 f6                	test   %esi,%esi
  801d8d:	75 2d                	jne    801dbc <__udivdi3+0x50>
  801d8f:	39 cf                	cmp    %ecx,%edi
  801d91:	77 65                	ja     801df8 <__udivdi3+0x8c>
  801d93:	89 fd                	mov    %edi,%ebp
  801d95:	85 ff                	test   %edi,%edi
  801d97:	75 0b                	jne    801da4 <__udivdi3+0x38>
  801d99:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9e:	31 d2                	xor    %edx,%edx
  801da0:	f7 f7                	div    %edi
  801da2:	89 c5                	mov    %eax,%ebp
  801da4:	31 d2                	xor    %edx,%edx
  801da6:	89 c8                	mov    %ecx,%eax
  801da8:	f7 f5                	div    %ebp
  801daa:	89 c1                	mov    %eax,%ecx
  801dac:	89 d8                	mov    %ebx,%eax
  801dae:	f7 f5                	div    %ebp
  801db0:	89 cf                	mov    %ecx,%edi
  801db2:	89 fa                	mov    %edi,%edx
  801db4:	83 c4 1c             	add    $0x1c,%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5f                   	pop    %edi
  801dba:	5d                   	pop    %ebp
  801dbb:	c3                   	ret    
  801dbc:	39 ce                	cmp    %ecx,%esi
  801dbe:	77 28                	ja     801de8 <__udivdi3+0x7c>
  801dc0:	0f bd fe             	bsr    %esi,%edi
  801dc3:	83 f7 1f             	xor    $0x1f,%edi
  801dc6:	75 40                	jne    801e08 <__udivdi3+0x9c>
  801dc8:	39 ce                	cmp    %ecx,%esi
  801dca:	72 0a                	jb     801dd6 <__udivdi3+0x6a>
  801dcc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801dd0:	0f 87 9e 00 00 00    	ja     801e74 <__udivdi3+0x108>
  801dd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddb:	89 fa                	mov    %edi,%edx
  801ddd:	83 c4 1c             	add    $0x1c,%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5e                   	pop    %esi
  801de2:	5f                   	pop    %edi
  801de3:	5d                   	pop    %ebp
  801de4:	c3                   	ret    
  801de5:	8d 76 00             	lea    0x0(%esi),%esi
  801de8:	31 ff                	xor    %edi,%edi
  801dea:	31 c0                	xor    %eax,%eax
  801dec:	89 fa                	mov    %edi,%edx
  801dee:	83 c4 1c             	add    $0x1c,%esp
  801df1:	5b                   	pop    %ebx
  801df2:	5e                   	pop    %esi
  801df3:	5f                   	pop    %edi
  801df4:	5d                   	pop    %ebp
  801df5:	c3                   	ret    
  801df6:	66 90                	xchg   %ax,%ax
  801df8:	89 d8                	mov    %ebx,%eax
  801dfa:	f7 f7                	div    %edi
  801dfc:	31 ff                	xor    %edi,%edi
  801dfe:	89 fa                	mov    %edi,%edx
  801e00:	83 c4 1c             	add    $0x1c,%esp
  801e03:	5b                   	pop    %ebx
  801e04:	5e                   	pop    %esi
  801e05:	5f                   	pop    %edi
  801e06:	5d                   	pop    %ebp
  801e07:	c3                   	ret    
  801e08:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e0d:	89 eb                	mov    %ebp,%ebx
  801e0f:	29 fb                	sub    %edi,%ebx
  801e11:	89 f9                	mov    %edi,%ecx
  801e13:	d3 e6                	shl    %cl,%esi
  801e15:	89 c5                	mov    %eax,%ebp
  801e17:	88 d9                	mov    %bl,%cl
  801e19:	d3 ed                	shr    %cl,%ebp
  801e1b:	89 e9                	mov    %ebp,%ecx
  801e1d:	09 f1                	or     %esi,%ecx
  801e1f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e23:	89 f9                	mov    %edi,%ecx
  801e25:	d3 e0                	shl    %cl,%eax
  801e27:	89 c5                	mov    %eax,%ebp
  801e29:	89 d6                	mov    %edx,%esi
  801e2b:	88 d9                	mov    %bl,%cl
  801e2d:	d3 ee                	shr    %cl,%esi
  801e2f:	89 f9                	mov    %edi,%ecx
  801e31:	d3 e2                	shl    %cl,%edx
  801e33:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e37:	88 d9                	mov    %bl,%cl
  801e39:	d3 e8                	shr    %cl,%eax
  801e3b:	09 c2                	or     %eax,%edx
  801e3d:	89 d0                	mov    %edx,%eax
  801e3f:	89 f2                	mov    %esi,%edx
  801e41:	f7 74 24 0c          	divl   0xc(%esp)
  801e45:	89 d6                	mov    %edx,%esi
  801e47:	89 c3                	mov    %eax,%ebx
  801e49:	f7 e5                	mul    %ebp
  801e4b:	39 d6                	cmp    %edx,%esi
  801e4d:	72 19                	jb     801e68 <__udivdi3+0xfc>
  801e4f:	74 0b                	je     801e5c <__udivdi3+0xf0>
  801e51:	89 d8                	mov    %ebx,%eax
  801e53:	31 ff                	xor    %edi,%edi
  801e55:	e9 58 ff ff ff       	jmp    801db2 <__udivdi3+0x46>
  801e5a:	66 90                	xchg   %ax,%ax
  801e5c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e60:	89 f9                	mov    %edi,%ecx
  801e62:	d3 e2                	shl    %cl,%edx
  801e64:	39 c2                	cmp    %eax,%edx
  801e66:	73 e9                	jae    801e51 <__udivdi3+0xe5>
  801e68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e6b:	31 ff                	xor    %edi,%edi
  801e6d:	e9 40 ff ff ff       	jmp    801db2 <__udivdi3+0x46>
  801e72:	66 90                	xchg   %ax,%ax
  801e74:	31 c0                	xor    %eax,%eax
  801e76:	e9 37 ff ff ff       	jmp    801db2 <__udivdi3+0x46>
  801e7b:	90                   	nop

00801e7c <__umoddi3>:
  801e7c:	55                   	push   %ebp
  801e7d:	57                   	push   %edi
  801e7e:	56                   	push   %esi
  801e7f:	53                   	push   %ebx
  801e80:	83 ec 1c             	sub    $0x1c,%esp
  801e83:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e87:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e8f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e9b:	89 f3                	mov    %esi,%ebx
  801e9d:	89 fa                	mov    %edi,%edx
  801e9f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ea3:	89 34 24             	mov    %esi,(%esp)
  801ea6:	85 c0                	test   %eax,%eax
  801ea8:	75 1a                	jne    801ec4 <__umoddi3+0x48>
  801eaa:	39 f7                	cmp    %esi,%edi
  801eac:	0f 86 a2 00 00 00    	jbe    801f54 <__umoddi3+0xd8>
  801eb2:	89 c8                	mov    %ecx,%eax
  801eb4:	89 f2                	mov    %esi,%edx
  801eb6:	f7 f7                	div    %edi
  801eb8:	89 d0                	mov    %edx,%eax
  801eba:	31 d2                	xor    %edx,%edx
  801ebc:	83 c4 1c             	add    $0x1c,%esp
  801ebf:	5b                   	pop    %ebx
  801ec0:	5e                   	pop    %esi
  801ec1:	5f                   	pop    %edi
  801ec2:	5d                   	pop    %ebp
  801ec3:	c3                   	ret    
  801ec4:	39 f0                	cmp    %esi,%eax
  801ec6:	0f 87 ac 00 00 00    	ja     801f78 <__umoddi3+0xfc>
  801ecc:	0f bd e8             	bsr    %eax,%ebp
  801ecf:	83 f5 1f             	xor    $0x1f,%ebp
  801ed2:	0f 84 ac 00 00 00    	je     801f84 <__umoddi3+0x108>
  801ed8:	bf 20 00 00 00       	mov    $0x20,%edi
  801edd:	29 ef                	sub    %ebp,%edi
  801edf:	89 fe                	mov    %edi,%esi
  801ee1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ee5:	89 e9                	mov    %ebp,%ecx
  801ee7:	d3 e0                	shl    %cl,%eax
  801ee9:	89 d7                	mov    %edx,%edi
  801eeb:	89 f1                	mov    %esi,%ecx
  801eed:	d3 ef                	shr    %cl,%edi
  801eef:	09 c7                	or     %eax,%edi
  801ef1:	89 e9                	mov    %ebp,%ecx
  801ef3:	d3 e2                	shl    %cl,%edx
  801ef5:	89 14 24             	mov    %edx,(%esp)
  801ef8:	89 d8                	mov    %ebx,%eax
  801efa:	d3 e0                	shl    %cl,%eax
  801efc:	89 c2                	mov    %eax,%edx
  801efe:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f02:	d3 e0                	shl    %cl,%eax
  801f04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f08:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f0c:	89 f1                	mov    %esi,%ecx
  801f0e:	d3 e8                	shr    %cl,%eax
  801f10:	09 d0                	or     %edx,%eax
  801f12:	d3 eb                	shr    %cl,%ebx
  801f14:	89 da                	mov    %ebx,%edx
  801f16:	f7 f7                	div    %edi
  801f18:	89 d3                	mov    %edx,%ebx
  801f1a:	f7 24 24             	mull   (%esp)
  801f1d:	89 c6                	mov    %eax,%esi
  801f1f:	89 d1                	mov    %edx,%ecx
  801f21:	39 d3                	cmp    %edx,%ebx
  801f23:	0f 82 87 00 00 00    	jb     801fb0 <__umoddi3+0x134>
  801f29:	0f 84 91 00 00 00    	je     801fc0 <__umoddi3+0x144>
  801f2f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f33:	29 f2                	sub    %esi,%edx
  801f35:	19 cb                	sbb    %ecx,%ebx
  801f37:	89 d8                	mov    %ebx,%eax
  801f39:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f3d:	d3 e0                	shl    %cl,%eax
  801f3f:	89 e9                	mov    %ebp,%ecx
  801f41:	d3 ea                	shr    %cl,%edx
  801f43:	09 d0                	or     %edx,%eax
  801f45:	89 e9                	mov    %ebp,%ecx
  801f47:	d3 eb                	shr    %cl,%ebx
  801f49:	89 da                	mov    %ebx,%edx
  801f4b:	83 c4 1c             	add    $0x1c,%esp
  801f4e:	5b                   	pop    %ebx
  801f4f:	5e                   	pop    %esi
  801f50:	5f                   	pop    %edi
  801f51:	5d                   	pop    %ebp
  801f52:	c3                   	ret    
  801f53:	90                   	nop
  801f54:	89 fd                	mov    %edi,%ebp
  801f56:	85 ff                	test   %edi,%edi
  801f58:	75 0b                	jne    801f65 <__umoddi3+0xe9>
  801f5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5f:	31 d2                	xor    %edx,%edx
  801f61:	f7 f7                	div    %edi
  801f63:	89 c5                	mov    %eax,%ebp
  801f65:	89 f0                	mov    %esi,%eax
  801f67:	31 d2                	xor    %edx,%edx
  801f69:	f7 f5                	div    %ebp
  801f6b:	89 c8                	mov    %ecx,%eax
  801f6d:	f7 f5                	div    %ebp
  801f6f:	89 d0                	mov    %edx,%eax
  801f71:	e9 44 ff ff ff       	jmp    801eba <__umoddi3+0x3e>
  801f76:	66 90                	xchg   %ax,%ax
  801f78:	89 c8                	mov    %ecx,%eax
  801f7a:	89 f2                	mov    %esi,%edx
  801f7c:	83 c4 1c             	add    $0x1c,%esp
  801f7f:	5b                   	pop    %ebx
  801f80:	5e                   	pop    %esi
  801f81:	5f                   	pop    %edi
  801f82:	5d                   	pop    %ebp
  801f83:	c3                   	ret    
  801f84:	3b 04 24             	cmp    (%esp),%eax
  801f87:	72 06                	jb     801f8f <__umoddi3+0x113>
  801f89:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f8d:	77 0f                	ja     801f9e <__umoddi3+0x122>
  801f8f:	89 f2                	mov    %esi,%edx
  801f91:	29 f9                	sub    %edi,%ecx
  801f93:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f97:	89 14 24             	mov    %edx,(%esp)
  801f9a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f9e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fa2:	8b 14 24             	mov    (%esp),%edx
  801fa5:	83 c4 1c             	add    $0x1c,%esp
  801fa8:	5b                   	pop    %ebx
  801fa9:	5e                   	pop    %esi
  801faa:	5f                   	pop    %edi
  801fab:	5d                   	pop    %ebp
  801fac:	c3                   	ret    
  801fad:	8d 76 00             	lea    0x0(%esi),%esi
  801fb0:	2b 04 24             	sub    (%esp),%eax
  801fb3:	19 fa                	sbb    %edi,%edx
  801fb5:	89 d1                	mov    %edx,%ecx
  801fb7:	89 c6                	mov    %eax,%esi
  801fb9:	e9 71 ff ff ff       	jmp    801f2f <__umoddi3+0xb3>
  801fbe:	66 90                	xchg   %ax,%ax
  801fc0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801fc4:	72 ea                	jb     801fb0 <__umoddi3+0x134>
  801fc6:	89 d9                	mov    %ebx,%ecx
  801fc8:	e9 62 ff ff ff       	jmp    801f2f <__umoddi3+0xb3>
