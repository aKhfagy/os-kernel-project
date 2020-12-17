
obj/user/tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 85 03 00 00       	call   8003bb <libmain>
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
  800087:	68 60 1f 80 00       	push   $0x801f60
  80008c:	6a 12                	push   $0x12
  80008e:	68 7c 1f 80 00       	push   $0x801f7c
  800093:	e8 68 04 00 00       	call   800500 <_panic>
	}

	cprintf("************************************************\n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 98 1f 80 00       	push   $0x801f98
  8000a0:	e8 fd 06 00 00       	call   8007a2 <cprintf>
  8000a5:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	68 cc 1f 80 00       	push   $0x801fcc
  8000b0:	e8 ed 06 00 00       	call   8007a2 <cprintf>
  8000b5:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	68 28 20 80 00       	push   $0x802028
  8000c0:	e8 dd 06 00 00       	call   8007a2 <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000c8:	e8 8f 15 00 00       	call   80165c <sys_getenvid>
  8000cd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	68 5c 20 80 00       	push   $0x80205c
  8000d8:	e8 c5 06 00 00       	call   8007a2 <cprintf>
  8000dd:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int32 envIdSlave1 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e5:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  8000eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f0:	8b 40 74             	mov    0x74(%eax),%eax
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	52                   	push   %edx
  8000f7:	50                   	push   %eax
  8000f8:	68 9d 20 80 00       	push   $0x80209d
  8000fd:	e8 93 18 00 00       	call   801995 <sys_create_env>
  800102:	83 c4 10             	add    $0x10,%esp
  800105:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int32 envIdSlave2 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  800108:	a1 20 30 80 00       	mov    0x803020,%eax
  80010d:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8b 40 74             	mov    0x74(%eax),%eax
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	52                   	push   %edx
  80011f:	50                   	push   %eax
  800120:	68 9d 20 80 00       	push   $0x80209d
  800125:	e8 6b 18 00 00       	call   801995 <sys_create_env>
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800130:	e8 0b 16 00 00       	call   801740 <sys_calculate_free_frames>
  800135:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	6a 01                	push   $0x1
  80013d:	68 00 10 00 00       	push   $0x1000
  800142:	68 a8 20 80 00       	push   $0x8020a8
  800147:	e8 fa 13 00 00       	call   801546 <smalloc>
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  800152:	83 ec 0c             	sub    $0xc,%esp
  800155:	68 ac 20 80 00       	push   $0x8020ac
  80015a:	e8 43 06 00 00       	call   8007a2 <cprintf>
  80015f:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800162:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 cc 20 80 00       	push   $0x8020cc
  800173:	6a 24                	push   $0x24
  800175:	68 7c 1f 80 00       	push   $0x801f7c
  80017a:	e8 81 03 00 00       	call   800500 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80017f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800182:	e8 b9 15 00 00       	call   801740 <sys_calculate_free_frames>
  800187:	29 c3                	sub    %eax,%ebx
  800189:	89 d8                	mov    %ebx,%eax
  80018b:	83 f8 04             	cmp    $0x4,%eax
  80018e:	74 14                	je     8001a4 <_main+0x16c>
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	68 38 21 80 00       	push   $0x802138
  800198:	6a 25                	push   $0x25
  80019a:	68 7c 1f 80 00       	push   $0x801f7c
  80019f:	e8 5c 03 00 00       	call   800500 <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001a4:	e8 d3 18 00 00       	call   801a7c <rsttst>

		sys_run_env(envIdSlave1);
  8001a9:	83 ec 0c             	sub    $0xc,%esp
  8001ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8001af:	e8 fe 17 00 00       	call   8019b2 <sys_run_env>
  8001b4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001bd:	e8 f0 17 00 00       	call   8019b2 <sys_run_env>
  8001c2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 b6 21 80 00       	push   $0x8021b6
  8001cd:	e8 d0 05 00 00       	call   8007a2 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 b8 0b 00 00       	push   $0xbb8
  8001dd:	e8 4e 1a 00 00       	call   801c30 <env_sleep>
  8001e2:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001e5:	e8 0c 19 00 00       	call   801af6 <gettst>
  8001ea:	83 f8 02             	cmp    $0x2,%eax
  8001ed:	74 14                	je     800203 <_main+0x1cb>
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	68 cd 21 80 00       	push   $0x8021cd
  8001f7:	6a 31                	push   $0x31
  8001f9:	68 7c 1f 80 00       	push   $0x801f7c
  8001fe:	e8 fd 02 00 00       	call   800500 <_panic>

		sfree(x);
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	ff 75 dc             	pushl  -0x24(%ebp)
  800209:	e8 8c 13 00 00       	call   80159a <sfree>
  80020e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	68 dc 21 80 00       	push   $0x8021dc
  800219:	e8 84 05 00 00       	call   8007a2 <cprintf>
  80021e:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800221:	e8 1a 15 00 00       	call   801740 <sys_calculate_free_frames>
  800226:	89 c2                	mov    %eax,%edx
  800228:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022b:	29 c2                	sub    %eax,%edx
  80022d:	89 d0                	mov    %edx,%eax
  80022f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  800232:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800236:	74 14                	je     80024c <_main+0x214>
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 fc 21 80 00       	push   $0x8021fc
  800240:	6a 36                	push   $0x36
  800242:	68 7c 1f 80 00       	push   $0x801f7c
  800247:	e8 b4 02 00 00       	call   800500 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	68 2c 22 80 00       	push   $0x80222c
  800254:	e8 49 05 00 00       	call   8007a2 <cprintf>
  800259:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	68 50 22 80 00       	push   $0x802250
  800264:	e8 39 05 00 00       	call   8007a2 <cprintf>
  800269:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int32 envIdSlaveB1 = sys_create_env("tshr5slaveB1", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  80026c:	a1 20 30 80 00       	mov    0x803020,%eax
  800271:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  800277:	a1 20 30 80 00       	mov    0x803020,%eax
  80027c:	8b 40 74             	mov    0x74(%eax),%eax
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	52                   	push   %edx
  800283:	50                   	push   %eax
  800284:	68 80 22 80 00       	push   $0x802280
  800289:	e8 07 17 00 00       	call   801995 <sys_create_env>
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int32 envIdSlaveB2 = sys_create_env("tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  800294:	a1 20 30 80 00       	mov    0x803020,%eax
  800299:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80029f:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a4:	8b 40 74             	mov    0x74(%eax),%eax
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	52                   	push   %edx
  8002ab:	50                   	push   %eax
  8002ac:	68 8d 22 80 00       	push   $0x80228d
  8002b1:	e8 df 16 00 00       	call   801995 <sys_create_env>
  8002b6:	83 c4 10             	add    $0x10,%esp
  8002b9:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002bc:	83 ec 04             	sub    $0x4,%esp
  8002bf:	6a 01                	push   $0x1
  8002c1:	68 00 10 00 00       	push   $0x1000
  8002c6:	68 9a 22 80 00       	push   $0x80229a
  8002cb:	e8 76 12 00 00       	call   801546 <smalloc>
  8002d0:	83 c4 10             	add    $0x10,%esp
  8002d3:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	68 9c 22 80 00       	push   $0x80229c
  8002de:	e8 bf 04 00 00       	call   8007a2 <cprintf>
  8002e3:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	6a 01                	push   $0x1
  8002eb:	68 00 10 00 00       	push   $0x1000
  8002f0:	68 a8 20 80 00       	push   $0x8020a8
  8002f5:	e8 4c 12 00 00       	call   801546 <smalloc>
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	68 ac 20 80 00       	push   $0x8020ac
  800308:	e8 95 04 00 00       	call   8007a2 <cprintf>
  80030d:	83 c4 10             	add    $0x10,%esp

		rsttst();
  800310:	e8 67 17 00 00       	call   801a7c <rsttst>

		sys_run_env(envIdSlaveB1);
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	ff 75 d4             	pushl  -0x2c(%ebp)
  80031b:	e8 92 16 00 00       	call   8019b2 <sys_run_env>
  800320:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	ff 75 d0             	pushl  -0x30(%ebp)
  800329:	e8 84 16 00 00       	call   8019b2 <sys_run_env>
  80032e:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  800331:	83 ec 0c             	sub    $0xc,%esp
  800334:	68 a0 0f 00 00       	push   $0xfa0
  800339:	e8 f2 18 00 00       	call   801c30 <env_sleep>
  80033e:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  800341:	e8 fa 13 00 00       	call   801740 <sys_calculate_free_frames>
  800346:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800349:	83 ec 0c             	sub    $0xc,%esp
  80034c:	ff 75 cc             	pushl  -0x34(%ebp)
  80034f:	e8 46 12 00 00       	call   80159a <sfree>
  800354:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	68 bc 22 80 00       	push   $0x8022bc
  80035f:	e8 3e 04 00 00       	call   8007a2 <cprintf>
  800364:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800367:	83 ec 0c             	sub    $0xc,%esp
  80036a:	ff 75 c8             	pushl  -0x38(%ebp)
  80036d:	e8 28 12 00 00       	call   80159a <sfree>
  800372:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  800375:	83 ec 0c             	sub    $0xc,%esp
  800378:	68 d2 22 80 00       	push   $0x8022d2
  80037d:	e8 20 04 00 00       	call   8007a2 <cprintf>
  800382:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  800385:	e8 b6 13 00 00       	call   801740 <sys_calculate_free_frames>
  80038a:	89 c2                	mov    %eax,%edx
  80038c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80038f:	29 c2                	sub    %eax,%edx
  800391:	89 d0                	mov    %edx,%eax
  800393:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  800396:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  80039a:	74 14                	je     8003b0 <_main+0x378>
  80039c:	83 ec 04             	sub    $0x4,%esp
  80039f:	68 e8 22 80 00       	push   $0x8022e8
  8003a4:	6a 57                	push   $0x57
  8003a6:	68 7c 1f 80 00       	push   $0x801f7c
  8003ab:	e8 50 01 00 00       	call   800500 <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003b0:	e8 27 17 00 00       	call   801adc <inctst>


	}


	return;
  8003b5:	90                   	nop
}
  8003b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b9:	c9                   	leave  
  8003ba:	c3                   	ret    

008003bb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
  8003be:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003c1:	e8 af 12 00 00       	call   801675 <sys_getenvindex>
  8003c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003cc:	89 d0                	mov    %edx,%eax
  8003ce:	c1 e0 03             	shl    $0x3,%eax
  8003d1:	01 d0                	add    %edx,%eax
  8003d3:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003da:	01 c8                	add    %ecx,%eax
  8003dc:	01 c0                	add    %eax,%eax
  8003de:	01 d0                	add    %edx,%eax
  8003e0:	01 c0                	add    %eax,%eax
  8003e2:	01 d0                	add    %edx,%eax
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	c1 e2 05             	shl    $0x5,%edx
  8003e9:	29 c2                	sub    %eax,%edx
  8003eb:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8003fa:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800404:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80040a:	84 c0                	test   %al,%al
  80040c:	74 0f                	je     80041d <libmain+0x62>
		binaryname = myEnv->prog_name;
  80040e:	a1 20 30 80 00       	mov    0x803020,%eax
  800413:	05 40 3c 01 00       	add    $0x13c40,%eax
  800418:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80041d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800421:	7e 0a                	jle    80042d <libmain+0x72>
		binaryname = argv[0];
  800423:	8b 45 0c             	mov    0xc(%ebp),%eax
  800426:	8b 00                	mov    (%eax),%eax
  800428:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80042d:	83 ec 08             	sub    $0x8,%esp
  800430:	ff 75 0c             	pushl  0xc(%ebp)
  800433:	ff 75 08             	pushl  0x8(%ebp)
  800436:	e8 fd fb ff ff       	call   800038 <_main>
  80043b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80043e:	e8 cd 13 00 00       	call   801810 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 a8 23 80 00       	push   $0x8023a8
  80044b:	e8 52 03 00 00       	call   8007a2 <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800453:	a1 20 30 80 00       	mov    0x803020,%eax
  800458:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80045e:	a1 20 30 80 00       	mov    0x803020,%eax
  800463:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800469:	83 ec 04             	sub    $0x4,%esp
  80046c:	52                   	push   %edx
  80046d:	50                   	push   %eax
  80046e:	68 d0 23 80 00       	push   $0x8023d0
  800473:	e8 2a 03 00 00       	call   8007a2 <cprintf>
  800478:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80047b:	a1 20 30 80 00       	mov    0x803020,%eax
  800480:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800486:	a1 20 30 80 00       	mov    0x803020,%eax
  80048b:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800491:	83 ec 04             	sub    $0x4,%esp
  800494:	52                   	push   %edx
  800495:	50                   	push   %eax
  800496:	68 f8 23 80 00       	push   $0x8023f8
  80049b:	e8 02 03 00 00       	call   8007a2 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a8:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	50                   	push   %eax
  8004b2:	68 39 24 80 00       	push   $0x802439
  8004b7:	e8 e6 02 00 00       	call   8007a2 <cprintf>
  8004bc:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004bf:	83 ec 0c             	sub    $0xc,%esp
  8004c2:	68 a8 23 80 00       	push   $0x8023a8
  8004c7:	e8 d6 02 00 00       	call   8007a2 <cprintf>
  8004cc:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004cf:	e8 56 13 00 00       	call   80182a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004d4:	e8 19 00 00 00       	call   8004f2 <exit>
}
  8004d9:	90                   	nop
  8004da:	c9                   	leave  
  8004db:	c3                   	ret    

008004dc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004dc:	55                   	push   %ebp
  8004dd:	89 e5                	mov    %esp,%ebp
  8004df:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8004e2:	83 ec 0c             	sub    $0xc,%esp
  8004e5:	6a 00                	push   $0x0
  8004e7:	e8 55 11 00 00       	call   801641 <sys_env_destroy>
  8004ec:	83 c4 10             	add    $0x10,%esp
}
  8004ef:	90                   	nop
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <exit>:

void
exit(void)
{
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8004f8:	e8 aa 11 00 00       	call   8016a7 <sys_env_exit>
}
  8004fd:	90                   	nop
  8004fe:	c9                   	leave  
  8004ff:	c3                   	ret    

00800500 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800506:	8d 45 10             	lea    0x10(%ebp),%eax
  800509:	83 c0 04             	add    $0x4,%eax
  80050c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80050f:	a1 18 31 80 00       	mov    0x803118,%eax
  800514:	85 c0                	test   %eax,%eax
  800516:	74 16                	je     80052e <_panic+0x2e>
		cprintf("%s: ", argv0);
  800518:	a1 18 31 80 00       	mov    0x803118,%eax
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	50                   	push   %eax
  800521:	68 50 24 80 00       	push   $0x802450
  800526:	e8 77 02 00 00       	call   8007a2 <cprintf>
  80052b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80052e:	a1 00 30 80 00       	mov    0x803000,%eax
  800533:	ff 75 0c             	pushl  0xc(%ebp)
  800536:	ff 75 08             	pushl  0x8(%ebp)
  800539:	50                   	push   %eax
  80053a:	68 55 24 80 00       	push   $0x802455
  80053f:	e8 5e 02 00 00       	call   8007a2 <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800547:	8b 45 10             	mov    0x10(%ebp),%eax
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 f4             	pushl  -0xc(%ebp)
  800550:	50                   	push   %eax
  800551:	e8 e1 01 00 00       	call   800737 <vcprintf>
  800556:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	6a 00                	push   $0x0
  80055e:	68 71 24 80 00       	push   $0x802471
  800563:	e8 cf 01 00 00       	call   800737 <vcprintf>
  800568:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80056b:	e8 82 ff ff ff       	call   8004f2 <exit>

	// should not return here
	while (1) ;
  800570:	eb fe                	jmp    800570 <_panic+0x70>

00800572 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800572:	55                   	push   %ebp
  800573:	89 e5                	mov    %esp,%ebp
  800575:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800578:	a1 20 30 80 00       	mov    0x803020,%eax
  80057d:	8b 50 74             	mov    0x74(%eax),%edx
  800580:	8b 45 0c             	mov    0xc(%ebp),%eax
  800583:	39 c2                	cmp    %eax,%edx
  800585:	74 14                	je     80059b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800587:	83 ec 04             	sub    $0x4,%esp
  80058a:	68 74 24 80 00       	push   $0x802474
  80058f:	6a 26                	push   $0x26
  800591:	68 c0 24 80 00       	push   $0x8024c0
  800596:	e8 65 ff ff ff       	call   800500 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80059b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005a9:	e9 b6 00 00 00       	jmp    800664 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8005ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	85 c0                	test   %eax,%eax
  8005c1:	75 08                	jne    8005cb <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005c3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005c6:	e9 96 00 00 00       	jmp    800661 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8005cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005d9:	eb 5d                	jmp    800638 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005db:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e0:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8005e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005e9:	c1 e2 04             	shl    $0x4,%edx
  8005ec:	01 d0                	add    %edx,%eax
  8005ee:	8a 40 04             	mov    0x4(%eax),%al
  8005f1:	84 c0                	test   %al,%al
  8005f3:	75 40                	jne    800635 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fa:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800600:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800603:	c1 e2 04             	shl    $0x4,%edx
  800606:	01 d0                	add    %edx,%eax
  800608:	8b 00                	mov    (%eax),%eax
  80060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80060d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800610:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800615:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	01 c8                	add    %ecx,%eax
  800626:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	75 09                	jne    800635 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  80062c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800633:	eb 12                	jmp    800647 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800635:	ff 45 e8             	incl   -0x18(%ebp)
  800638:	a1 20 30 80 00       	mov    0x803020,%eax
  80063d:	8b 50 74             	mov    0x74(%eax),%edx
  800640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800643:	39 c2                	cmp    %eax,%edx
  800645:	77 94                	ja     8005db <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800647:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80064b:	75 14                	jne    800661 <CheckWSWithoutLastIndex+0xef>
			panic(
  80064d:	83 ec 04             	sub    $0x4,%esp
  800650:	68 cc 24 80 00       	push   $0x8024cc
  800655:	6a 3a                	push   $0x3a
  800657:	68 c0 24 80 00       	push   $0x8024c0
  80065c:	e8 9f fe ff ff       	call   800500 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800661:	ff 45 f0             	incl   -0x10(%ebp)
  800664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800667:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80066a:	0f 8c 3e ff ff ff    	jl     8005ae <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800670:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800677:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80067e:	eb 20                	jmp    8006a0 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800680:	a1 20 30 80 00       	mov    0x803020,%eax
  800685:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80068b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068e:	c1 e2 04             	shl    $0x4,%edx
  800691:	01 d0                	add    %edx,%eax
  800693:	8a 40 04             	mov    0x4(%eax),%al
  800696:	3c 01                	cmp    $0x1,%al
  800698:	75 03                	jne    80069d <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80069a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80069d:	ff 45 e0             	incl   -0x20(%ebp)
  8006a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a5:	8b 50 74             	mov    0x74(%eax),%edx
  8006a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ab:	39 c2                	cmp    %eax,%edx
  8006ad:	77 d1                	ja     800680 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006b5:	74 14                	je     8006cb <CheckWSWithoutLastIndex+0x159>
		panic(
  8006b7:	83 ec 04             	sub    $0x4,%esp
  8006ba:	68 20 25 80 00       	push   $0x802520
  8006bf:	6a 44                	push   $0x44
  8006c1:	68 c0 24 80 00       	push   $0x8024c0
  8006c6:	e8 35 fe ff ff       	call   800500 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006cb:	90                   	nop
  8006cc:	c9                   	leave  
  8006cd:	c3                   	ret    

008006ce <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006ce:	55                   	push   %ebp
  8006cf:	89 e5                	mov    %esp,%ebp
  8006d1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	8d 48 01             	lea    0x1(%eax),%ecx
  8006dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006df:	89 0a                	mov    %ecx,(%edx)
  8006e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8006e4:	88 d1                	mov    %dl,%cl
  8006e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006f7:	75 2c                	jne    800725 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006f9:	a0 24 30 80 00       	mov    0x803024,%al
  8006fe:	0f b6 c0             	movzbl %al,%eax
  800701:	8b 55 0c             	mov    0xc(%ebp),%edx
  800704:	8b 12                	mov    (%edx),%edx
  800706:	89 d1                	mov    %edx,%ecx
  800708:	8b 55 0c             	mov    0xc(%ebp),%edx
  80070b:	83 c2 08             	add    $0x8,%edx
  80070e:	83 ec 04             	sub    $0x4,%esp
  800711:	50                   	push   %eax
  800712:	51                   	push   %ecx
  800713:	52                   	push   %edx
  800714:	e8 e6 0e 00 00       	call   8015ff <sys_cputs>
  800719:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80071c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800725:	8b 45 0c             	mov    0xc(%ebp),%eax
  800728:	8b 40 04             	mov    0x4(%eax),%eax
  80072b:	8d 50 01             	lea    0x1(%eax),%edx
  80072e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800731:	89 50 04             	mov    %edx,0x4(%eax)
}
  800734:	90                   	nop
  800735:	c9                   	leave  
  800736:	c3                   	ret    

00800737 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800737:	55                   	push   %ebp
  800738:	89 e5                	mov    %esp,%ebp
  80073a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800740:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800747:	00 00 00 
	b.cnt = 0;
  80074a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800751:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800754:	ff 75 0c             	pushl  0xc(%ebp)
  800757:	ff 75 08             	pushl  0x8(%ebp)
  80075a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800760:	50                   	push   %eax
  800761:	68 ce 06 80 00       	push   $0x8006ce
  800766:	e8 11 02 00 00       	call   80097c <vprintfmt>
  80076b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80076e:	a0 24 30 80 00       	mov    0x803024,%al
  800773:	0f b6 c0             	movzbl %al,%eax
  800776:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80077c:	83 ec 04             	sub    $0x4,%esp
  80077f:	50                   	push   %eax
  800780:	52                   	push   %edx
  800781:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800787:	83 c0 08             	add    $0x8,%eax
  80078a:	50                   	push   %eax
  80078b:	e8 6f 0e 00 00       	call   8015ff <sys_cputs>
  800790:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800793:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80079a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007a0:	c9                   	leave  
  8007a1:	c3                   	ret    

008007a2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007a8:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007af:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8007be:	50                   	push   %eax
  8007bf:	e8 73 ff ff ff       	call   800737 <vcprintf>
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007cd:	c9                   	leave  
  8007ce:	c3                   	ret    

008007cf <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007d5:	e8 36 10 00 00       	call   801810 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007da:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e9:	50                   	push   %eax
  8007ea:	e8 48 ff ff ff       	call   800737 <vcprintf>
  8007ef:	83 c4 10             	add    $0x10,%esp
  8007f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007f5:	e8 30 10 00 00       	call   80182a <sys_enable_interrupt>
	return cnt;
  8007fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007fd:	c9                   	leave  
  8007fe:	c3                   	ret    

008007ff <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	53                   	push   %ebx
  800803:	83 ec 14             	sub    $0x14,%esp
  800806:	8b 45 10             	mov    0x10(%ebp),%eax
  800809:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800812:	8b 45 18             	mov    0x18(%ebp),%eax
  800815:	ba 00 00 00 00       	mov    $0x0,%edx
  80081a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80081d:	77 55                	ja     800874 <printnum+0x75>
  80081f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800822:	72 05                	jb     800829 <printnum+0x2a>
  800824:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800827:	77 4b                	ja     800874 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800829:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80082c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80082f:	8b 45 18             	mov    0x18(%ebp),%eax
  800832:	ba 00 00 00 00       	mov    $0x0,%edx
  800837:	52                   	push   %edx
  800838:	50                   	push   %eax
  800839:	ff 75 f4             	pushl  -0xc(%ebp)
  80083c:	ff 75 f0             	pushl  -0x10(%ebp)
  80083f:	e8 a0 14 00 00       	call   801ce4 <__udivdi3>
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	83 ec 04             	sub    $0x4,%esp
  80084a:	ff 75 20             	pushl  0x20(%ebp)
  80084d:	53                   	push   %ebx
  80084e:	ff 75 18             	pushl  0x18(%ebp)
  800851:	52                   	push   %edx
  800852:	50                   	push   %eax
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	ff 75 08             	pushl  0x8(%ebp)
  800859:	e8 a1 ff ff ff       	call   8007ff <printnum>
  80085e:	83 c4 20             	add    $0x20,%esp
  800861:	eb 1a                	jmp    80087d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	ff 75 20             	pushl  0x20(%ebp)
  80086c:	8b 45 08             	mov    0x8(%ebp),%eax
  80086f:	ff d0                	call   *%eax
  800871:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800874:	ff 4d 1c             	decl   0x1c(%ebp)
  800877:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087b:	7f e6                	jg     800863 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80087d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800880:	bb 00 00 00 00       	mov    $0x0,%ebx
  800885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800888:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088b:	53                   	push   %ebx
  80088c:	51                   	push   %ecx
  80088d:	52                   	push   %edx
  80088e:	50                   	push   %eax
  80088f:	e8 60 15 00 00       	call   801df4 <__umoddi3>
  800894:	83 c4 10             	add    $0x10,%esp
  800897:	05 94 27 80 00       	add    $0x802794,%eax
  80089c:	8a 00                	mov    (%eax),%al
  80089e:	0f be c0             	movsbl %al,%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	50                   	push   %eax
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	ff d0                	call   *%eax
  8008ad:	83 c4 10             	add    $0x10,%esp
}
  8008b0:	90                   	nop
  8008b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b4:	c9                   	leave  
  8008b5:	c3                   	ret    

008008b6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008bd:	7e 1c                	jle    8008db <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	8b 00                	mov    (%eax),%eax
  8008c4:	8d 50 08             	lea    0x8(%eax),%edx
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	89 10                	mov    %edx,(%eax)
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	83 e8 08             	sub    $0x8,%eax
  8008d4:	8b 50 04             	mov    0x4(%eax),%edx
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	eb 40                	jmp    80091b <getuint+0x65>
	else if (lflag)
  8008db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008df:	74 1e                	je     8008ff <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	8d 50 04             	lea    0x4(%eax),%edx
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	89 10                	mov    %edx,(%eax)
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	83 e8 04             	sub    $0x4,%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fd:	eb 1c                	jmp    80091b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	8d 50 04             	lea    0x4(%eax),%edx
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	89 10                	mov    %edx,(%eax)
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	83 e8 04             	sub    $0x4,%eax
  800914:	8b 00                	mov    (%eax),%eax
  800916:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    

0080091d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800920:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800924:	7e 1c                	jle    800942 <getint+0x25>
		return va_arg(*ap, long long);
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	8d 50 08             	lea    0x8(%eax),%edx
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	89 10                	mov    %edx,(%eax)
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	83 e8 08             	sub    $0x8,%eax
  80093b:	8b 50 04             	mov    0x4(%eax),%edx
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	eb 38                	jmp    80097a <getint+0x5d>
	else if (lflag)
  800942:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800946:	74 1a                	je     800962 <getint+0x45>
		return va_arg(*ap, long);
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	8d 50 04             	lea    0x4(%eax),%edx
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	89 10                	mov    %edx,(%eax)
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	83 e8 04             	sub    $0x4,%eax
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	99                   	cltd   
  800960:	eb 18                	jmp    80097a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	8b 00                	mov    (%eax),%eax
  800967:	8d 50 04             	lea    0x4(%eax),%edx
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	89 10                	mov    %edx,(%eax)
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	8b 00                	mov    (%eax),%eax
  800974:	83 e8 04             	sub    $0x4,%eax
  800977:	8b 00                	mov    (%eax),%eax
  800979:	99                   	cltd   
}
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	56                   	push   %esi
  800980:	53                   	push   %ebx
  800981:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800984:	eb 17                	jmp    80099d <vprintfmt+0x21>
			if (ch == '\0')
  800986:	85 db                	test   %ebx,%ebx
  800988:	0f 84 af 03 00 00    	je     800d3d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	53                   	push   %ebx
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	ff d0                	call   *%eax
  80099a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099d:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a0:	8d 50 01             	lea    0x1(%eax),%edx
  8009a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a6:	8a 00                	mov    (%eax),%al
  8009a8:	0f b6 d8             	movzbl %al,%ebx
  8009ab:	83 fb 25             	cmp    $0x25,%ebx
  8009ae:	75 d6                	jne    800986 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009bb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009c9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d3:	8d 50 01             	lea    0x1(%eax),%edx
  8009d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d9:	8a 00                	mov    (%eax),%al
  8009db:	0f b6 d8             	movzbl %al,%ebx
  8009de:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e1:	83 f8 55             	cmp    $0x55,%eax
  8009e4:	0f 87 2b 03 00 00    	ja     800d15 <vprintfmt+0x399>
  8009ea:	8b 04 85 b8 27 80 00 	mov    0x8027b8(,%eax,4),%eax
  8009f1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009f7:	eb d7                	jmp    8009d0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009fd:	eb d1                	jmp    8009d0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a09:	89 d0                	mov    %edx,%eax
  800a0b:	c1 e0 02             	shl    $0x2,%eax
  800a0e:	01 d0                	add    %edx,%eax
  800a10:	01 c0                	add    %eax,%eax
  800a12:	01 d8                	add    %ebx,%eax
  800a14:	83 e8 30             	sub    $0x30,%eax
  800a17:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1d:	8a 00                	mov    (%eax),%al
  800a1f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a22:	83 fb 2f             	cmp    $0x2f,%ebx
  800a25:	7e 3e                	jle    800a65 <vprintfmt+0xe9>
  800a27:	83 fb 39             	cmp    $0x39,%ebx
  800a2a:	7f 39                	jg     800a65 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a2c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a2f:	eb d5                	jmp    800a06 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a31:	8b 45 14             	mov    0x14(%ebp),%eax
  800a34:	83 c0 04             	add    $0x4,%eax
  800a37:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3d:	83 e8 04             	sub    $0x4,%eax
  800a40:	8b 00                	mov    (%eax),%eax
  800a42:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a45:	eb 1f                	jmp    800a66 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4b:	79 83                	jns    8009d0 <vprintfmt+0x54>
				width = 0;
  800a4d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a54:	e9 77 ff ff ff       	jmp    8009d0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a59:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a60:	e9 6b ff ff ff       	jmp    8009d0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a65:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6a:	0f 89 60 ff ff ff    	jns    8009d0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a76:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a7d:	e9 4e ff ff ff       	jmp    8009d0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a82:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a85:	e9 46 ff ff ff       	jmp    8009d0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8d:	83 c0 04             	add    $0x4,%eax
  800a90:	89 45 14             	mov    %eax,0x14(%ebp)
  800a93:	8b 45 14             	mov    0x14(%ebp),%eax
  800a96:	83 e8 04             	sub    $0x4,%eax
  800a99:	8b 00                	mov    (%eax),%eax
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	50                   	push   %eax
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	ff d0                	call   *%eax
  800aa7:	83 c4 10             	add    $0x10,%esp
			break;
  800aaa:	e9 89 02 00 00       	jmp    800d38 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	83 c0 04             	add    $0x4,%eax
  800ab5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab8:	8b 45 14             	mov    0x14(%ebp),%eax
  800abb:	83 e8 04             	sub    $0x4,%eax
  800abe:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac0:	85 db                	test   %ebx,%ebx
  800ac2:	79 02                	jns    800ac6 <vprintfmt+0x14a>
				err = -err;
  800ac4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ac6:	83 fb 64             	cmp    $0x64,%ebx
  800ac9:	7f 0b                	jg     800ad6 <vprintfmt+0x15a>
  800acb:	8b 34 9d 00 26 80 00 	mov    0x802600(,%ebx,4),%esi
  800ad2:	85 f6                	test   %esi,%esi
  800ad4:	75 19                	jne    800aef <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ad6:	53                   	push   %ebx
  800ad7:	68 a5 27 80 00       	push   $0x8027a5
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	ff 75 08             	pushl  0x8(%ebp)
  800ae2:	e8 5e 02 00 00       	call   800d45 <printfmt>
  800ae7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aea:	e9 49 02 00 00       	jmp    800d38 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aef:	56                   	push   %esi
  800af0:	68 ae 27 80 00       	push   $0x8027ae
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	ff 75 08             	pushl  0x8(%ebp)
  800afb:	e8 45 02 00 00       	call   800d45 <printfmt>
  800b00:	83 c4 10             	add    $0x10,%esp
			break;
  800b03:	e9 30 02 00 00       	jmp    800d38 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b08:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0b:	83 c0 04             	add    $0x4,%eax
  800b0e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b11:	8b 45 14             	mov    0x14(%ebp),%eax
  800b14:	83 e8 04             	sub    $0x4,%eax
  800b17:	8b 30                	mov    (%eax),%esi
  800b19:	85 f6                	test   %esi,%esi
  800b1b:	75 05                	jne    800b22 <vprintfmt+0x1a6>
				p = "(null)";
  800b1d:	be b1 27 80 00       	mov    $0x8027b1,%esi
			if (width > 0 && padc != '-')
  800b22:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b26:	7e 6d                	jle    800b95 <vprintfmt+0x219>
  800b28:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b2c:	74 67                	je     800b95 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	50                   	push   %eax
  800b35:	56                   	push   %esi
  800b36:	e8 0c 03 00 00       	call   800e47 <strnlen>
  800b3b:	83 c4 10             	add    $0x10,%esp
  800b3e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b41:	eb 16                	jmp    800b59 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b43:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b47:	83 ec 08             	sub    $0x8,%esp
  800b4a:	ff 75 0c             	pushl  0xc(%ebp)
  800b4d:	50                   	push   %eax
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	ff d0                	call   *%eax
  800b53:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b56:	ff 4d e4             	decl   -0x1c(%ebp)
  800b59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b5d:	7f e4                	jg     800b43 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5f:	eb 34                	jmp    800b95 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b61:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b65:	74 1c                	je     800b83 <vprintfmt+0x207>
  800b67:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6a:	7e 05                	jle    800b71 <vprintfmt+0x1f5>
  800b6c:	83 fb 7e             	cmp    $0x7e,%ebx
  800b6f:	7e 12                	jle    800b83 <vprintfmt+0x207>
					putch('?', putdat);
  800b71:	83 ec 08             	sub    $0x8,%esp
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	6a 3f                	push   $0x3f
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	ff d0                	call   *%eax
  800b7e:	83 c4 10             	add    $0x10,%esp
  800b81:	eb 0f                	jmp    800b92 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b83:	83 ec 08             	sub    $0x8,%esp
  800b86:	ff 75 0c             	pushl  0xc(%ebp)
  800b89:	53                   	push   %ebx
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	ff d0                	call   *%eax
  800b8f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b92:	ff 4d e4             	decl   -0x1c(%ebp)
  800b95:	89 f0                	mov    %esi,%eax
  800b97:	8d 70 01             	lea    0x1(%eax),%esi
  800b9a:	8a 00                	mov    (%eax),%al
  800b9c:	0f be d8             	movsbl %al,%ebx
  800b9f:	85 db                	test   %ebx,%ebx
  800ba1:	74 24                	je     800bc7 <vprintfmt+0x24b>
  800ba3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba7:	78 b8                	js     800b61 <vprintfmt+0x1e5>
  800ba9:	ff 4d e0             	decl   -0x20(%ebp)
  800bac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb0:	79 af                	jns    800b61 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb2:	eb 13                	jmp    800bc7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb4:	83 ec 08             	sub    $0x8,%esp
  800bb7:	ff 75 0c             	pushl  0xc(%ebp)
  800bba:	6a 20                	push   $0x20
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	ff d0                	call   *%eax
  800bc1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc4:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcb:	7f e7                	jg     800bb4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bcd:	e9 66 01 00 00       	jmp    800d38 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd2:	83 ec 08             	sub    $0x8,%esp
  800bd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdb:	50                   	push   %eax
  800bdc:	e8 3c fd ff ff       	call   80091d <getint>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf0:	85 d2                	test   %edx,%edx
  800bf2:	79 23                	jns    800c17 <vprintfmt+0x29b>
				putch('-', putdat);
  800bf4:	83 ec 08             	sub    $0x8,%esp
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	6a 2d                	push   $0x2d
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	ff d0                	call   *%eax
  800c01:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0a:	f7 d8                	neg    %eax
  800c0c:	83 d2 00             	adc    $0x0,%edx
  800c0f:	f7 da                	neg    %edx
  800c11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c14:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c17:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c1e:	e9 bc 00 00 00       	jmp    800cdf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c23:	83 ec 08             	sub    $0x8,%esp
  800c26:	ff 75 e8             	pushl  -0x18(%ebp)
  800c29:	8d 45 14             	lea    0x14(%ebp),%eax
  800c2c:	50                   	push   %eax
  800c2d:	e8 84 fc ff ff       	call   8008b6 <getuint>
  800c32:	83 c4 10             	add    $0x10,%esp
  800c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c38:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c42:	e9 98 00 00 00       	jmp    800cdf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c47:	83 ec 08             	sub    $0x8,%esp
  800c4a:	ff 75 0c             	pushl  0xc(%ebp)
  800c4d:	6a 58                	push   $0x58
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	ff d0                	call   *%eax
  800c54:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c57:	83 ec 08             	sub    $0x8,%esp
  800c5a:	ff 75 0c             	pushl  0xc(%ebp)
  800c5d:	6a 58                	push   $0x58
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	ff d0                	call   *%eax
  800c64:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c67:	83 ec 08             	sub    $0x8,%esp
  800c6a:	ff 75 0c             	pushl  0xc(%ebp)
  800c6d:	6a 58                	push   $0x58
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	ff d0                	call   *%eax
  800c74:	83 c4 10             	add    $0x10,%esp
			break;
  800c77:	e9 bc 00 00 00       	jmp    800d38 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c7c:	83 ec 08             	sub    $0x8,%esp
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	6a 30                	push   $0x30
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	ff d0                	call   *%eax
  800c89:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	6a 78                	push   $0x78
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	ff d0                	call   *%eax
  800c99:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9f:	83 c0 04             	add    $0x4,%eax
  800ca2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca8:	83 e8 04             	sub    $0x4,%eax
  800cab:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cb7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cbe:	eb 1f                	jmp    800cdf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc0:	83 ec 08             	sub    $0x8,%esp
  800cc3:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc6:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc9:	50                   	push   %eax
  800cca:	e8 e7 fb ff ff       	call   8008b6 <getuint>
  800ccf:	83 c4 10             	add    $0x10,%esp
  800cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cd8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cdf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce6:	83 ec 04             	sub    $0x4,%esp
  800ce9:	52                   	push   %edx
  800cea:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ced:	50                   	push   %eax
  800cee:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf1:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf4:	ff 75 0c             	pushl  0xc(%ebp)
  800cf7:	ff 75 08             	pushl  0x8(%ebp)
  800cfa:	e8 00 fb ff ff       	call   8007ff <printnum>
  800cff:	83 c4 20             	add    $0x20,%esp
			break;
  800d02:	eb 34                	jmp    800d38 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d04:	83 ec 08             	sub    $0x8,%esp
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	53                   	push   %ebx
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	ff d0                	call   *%eax
  800d10:	83 c4 10             	add    $0x10,%esp
			break;
  800d13:	eb 23                	jmp    800d38 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d15:	83 ec 08             	sub    $0x8,%esp
  800d18:	ff 75 0c             	pushl  0xc(%ebp)
  800d1b:	6a 25                	push   $0x25
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	ff d0                	call   *%eax
  800d22:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d25:	ff 4d 10             	decl   0x10(%ebp)
  800d28:	eb 03                	jmp    800d2d <vprintfmt+0x3b1>
  800d2a:	ff 4d 10             	decl   0x10(%ebp)
  800d2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d30:	48                   	dec    %eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	3c 25                	cmp    $0x25,%al
  800d35:	75 f3                	jne    800d2a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d37:	90                   	nop
		}
	}
  800d38:	e9 47 fc ff ff       	jmp    800984 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d3d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    

00800d45 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d4b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d4e:	83 c0 04             	add    $0x4,%eax
  800d51:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d54:	8b 45 10             	mov    0x10(%ebp),%eax
  800d57:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5a:	50                   	push   %eax
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	e8 16 fc ff ff       	call   80097c <vprintfmt>
  800d66:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d69:	90                   	nop
  800d6a:	c9                   	leave  
  800d6b:	c3                   	ret    

00800d6c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	8b 40 08             	mov    0x8(%eax),%eax
  800d75:	8d 50 01             	lea    0x1(%eax),%edx
  800d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d81:	8b 10                	mov    (%eax),%edx
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	8b 40 04             	mov    0x4(%eax),%eax
  800d89:	39 c2                	cmp    %eax,%edx
  800d8b:	73 12                	jae    800d9f <sprintputch+0x33>
		*b->buf++ = ch;
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	8b 00                	mov    (%eax),%eax
  800d92:	8d 48 01             	lea    0x1(%eax),%ecx
  800d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d98:	89 0a                	mov    %ecx,(%edx)
  800d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9d:	88 10                	mov    %dl,(%eax)
}
  800d9f:	90                   	nop
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	01 d0                	add    %edx,%eax
  800db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dc7:	74 06                	je     800dcf <vsnprintf+0x2d>
  800dc9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dcd:	7f 07                	jg     800dd6 <vsnprintf+0x34>
		return -E_INVAL;
  800dcf:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd4:	eb 20                	jmp    800df6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dd6:	ff 75 14             	pushl  0x14(%ebp)
  800dd9:	ff 75 10             	pushl  0x10(%ebp)
  800ddc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ddf:	50                   	push   %eax
  800de0:	68 6c 0d 80 00       	push   $0x800d6c
  800de5:	e8 92 fb ff ff       	call   80097c <vprintfmt>
  800dea:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800df6:	c9                   	leave  
  800df7:	c3                   	ret    

00800df8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dfe:	8d 45 10             	lea    0x10(%ebp),%eax
  800e01:	83 c0 04             	add    $0x4,%eax
  800e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e07:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e0d:	50                   	push   %eax
  800e0e:	ff 75 0c             	pushl  0xc(%ebp)
  800e11:	ff 75 08             	pushl  0x8(%ebp)
  800e14:	e8 89 ff ff ff       	call   800da2 <vsnprintf>
  800e19:	83 c4 10             	add    $0x10,%esp
  800e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e31:	eb 06                	jmp    800e39 <strlen+0x15>
		n++;
  800e33:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	75 f1                	jne    800e33 <strlen+0xf>
		n++;
	return n;
  800e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e45:	c9                   	leave  
  800e46:	c3                   	ret    

00800e47 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e54:	eb 09                	jmp    800e5f <strnlen+0x18>
		n++;
  800e56:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e59:	ff 45 08             	incl   0x8(%ebp)
  800e5c:	ff 4d 0c             	decl   0xc(%ebp)
  800e5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e63:	74 09                	je     800e6e <strnlen+0x27>
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	84 c0                	test   %al,%al
  800e6c:	75 e8                	jne    800e56 <strnlen+0xf>
		n++;
	return n;
  800e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e71:	c9                   	leave  
  800e72:	c3                   	ret    

00800e73 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e7f:	90                   	nop
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	8d 50 01             	lea    0x1(%eax),%edx
  800e86:	89 55 08             	mov    %edx,0x8(%ebp)
  800e89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e92:	8a 12                	mov    (%edx),%dl
  800e94:	88 10                	mov    %dl,(%eax)
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	84 c0                	test   %al,%al
  800e9a:	75 e4                	jne    800e80 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e9f:	c9                   	leave  
  800ea0:	c3                   	ret    

00800ea1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ead:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb4:	eb 1f                	jmp    800ed5 <strncpy+0x34>
		*dst++ = *src;
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8d 50 01             	lea    0x1(%eax),%edx
  800ebc:	89 55 08             	mov    %edx,0x8(%ebp)
  800ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec2:	8a 12                	mov    (%edx),%dl
  800ec4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	84 c0                	test   %al,%al
  800ecd:	74 03                	je     800ed2 <strncpy+0x31>
			src++;
  800ecf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed2:	ff 45 fc             	incl   -0x4(%ebp)
  800ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800edb:	72 d9                	jb     800eb6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800edd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee0:	c9                   	leave  
  800ee1:	c3                   	ret    

00800ee2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800eee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef2:	74 30                	je     800f24 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef4:	eb 16                	jmp    800f0c <strlcpy+0x2a>
			*dst++ = *src++;
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8d 50 01             	lea    0x1(%eax),%edx
  800efc:	89 55 08             	mov    %edx,0x8(%ebp)
  800eff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f02:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f05:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f08:	8a 12                	mov    (%edx),%dl
  800f0a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f0c:	ff 4d 10             	decl   0x10(%ebp)
  800f0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f13:	74 09                	je     800f1e <strlcpy+0x3c>
  800f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f18:	8a 00                	mov    (%eax),%al
  800f1a:	84 c0                	test   %al,%al
  800f1c:	75 d8                	jne    800ef6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f24:	8b 55 08             	mov    0x8(%ebp),%edx
  800f27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2a:	29 c2                	sub    %eax,%edx
  800f2c:	89 d0                	mov    %edx,%eax
}
  800f2e:	c9                   	leave  
  800f2f:	c3                   	ret    

00800f30 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f33:	eb 06                	jmp    800f3b <strcmp+0xb>
		p++, q++;
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	84 c0                	test   %al,%al
  800f42:	74 0e                	je     800f52 <strcmp+0x22>
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 10                	mov    (%eax),%dl
  800f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	38 c2                	cmp    %al,%dl
  800f50:	74 e3                	je     800f35 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	0f b6 d0             	movzbl %al,%edx
  800f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	0f b6 c0             	movzbl %al,%eax
  800f62:	29 c2                	sub    %eax,%edx
  800f64:	89 d0                	mov    %edx,%eax
}
  800f66:	5d                   	pop    %ebp
  800f67:	c3                   	ret    

00800f68 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f6b:	eb 09                	jmp    800f76 <strncmp+0xe>
		n--, p++, q++;
  800f6d:	ff 4d 10             	decl   0x10(%ebp)
  800f70:	ff 45 08             	incl   0x8(%ebp)
  800f73:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7a:	74 17                	je     800f93 <strncmp+0x2b>
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	84 c0                	test   %al,%al
  800f83:	74 0e                	je     800f93 <strncmp+0x2b>
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 10                	mov    (%eax),%dl
  800f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8d:	8a 00                	mov    (%eax),%al
  800f8f:	38 c2                	cmp    %al,%dl
  800f91:	74 da                	je     800f6d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f97:	75 07                	jne    800fa0 <strncmp+0x38>
		return 0;
  800f99:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9e:	eb 14                	jmp    800fb4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	0f b6 d0             	movzbl %al,%edx
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	0f b6 c0             	movzbl %al,%eax
  800fb0:	29 c2                	sub    %eax,%edx
  800fb2:	89 d0                	mov    %edx,%eax
}
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	83 ec 04             	sub    $0x4,%esp
  800fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc2:	eb 12                	jmp    800fd6 <strchr+0x20>
		if (*s == c)
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fcc:	75 05                	jne    800fd3 <strchr+0x1d>
			return (char *) s;
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	eb 11                	jmp    800fe4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd3:	ff 45 08             	incl   0x8(%ebp)
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	84 c0                	test   %al,%al
  800fdd:	75 e5                	jne    800fc4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe4:	c9                   	leave  
  800fe5:	c3                   	ret    

00800fe6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	83 ec 04             	sub    $0x4,%esp
  800fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff2:	eb 0d                	jmp    801001 <strfind+0x1b>
		if (*s == c)
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ffc:	74 0e                	je     80100c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ffe:	ff 45 08             	incl   0x8(%ebp)
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	84 c0                	test   %al,%al
  801008:	75 ea                	jne    800ff4 <strfind+0xe>
  80100a:	eb 01                	jmp    80100d <strfind+0x27>
		if (*s == c)
			break;
  80100c:	90                   	nop
	return (char *) s;
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801010:	c9                   	leave  
  801011:	c3                   	ret    

00801012 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80101e:	8b 45 10             	mov    0x10(%ebp),%eax
  801021:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801024:	eb 0e                	jmp    801034 <memset+0x22>
		*p++ = c;
  801026:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801029:	8d 50 01             	lea    0x1(%eax),%edx
  80102c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80102f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801032:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801034:	ff 4d f8             	decl   -0x8(%ebp)
  801037:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80103b:	79 e9                	jns    801026 <memset+0x14>
		*p++ = c;

	return v;
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801054:	eb 16                	jmp    80106c <memcpy+0x2a>
		*d++ = *s++;
  801056:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801059:	8d 50 01             	lea    0x1(%eax),%edx
  80105c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80105f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801062:	8d 4a 01             	lea    0x1(%edx),%ecx
  801065:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801068:	8a 12                	mov    (%edx),%dl
  80106a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80106c:	8b 45 10             	mov    0x10(%ebp),%eax
  80106f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801072:	89 55 10             	mov    %edx,0x10(%ebp)
  801075:	85 c0                	test   %eax,%eax
  801077:	75 dd                	jne    801056 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80107c:	c9                   	leave  
  80107d:	c3                   	ret    

0080107e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801090:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801093:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801096:	73 50                	jae    8010e8 <memmove+0x6a>
  801098:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109b:	8b 45 10             	mov    0x10(%ebp),%eax
  80109e:	01 d0                	add    %edx,%eax
  8010a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010a3:	76 43                	jbe    8010e8 <memmove+0x6a>
		s += n;
  8010a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b1:	eb 10                	jmp    8010c3 <memmove+0x45>
			*--d = *--s;
  8010b3:	ff 4d f8             	decl   -0x8(%ebp)
  8010b6:	ff 4d fc             	decl   -0x4(%ebp)
  8010b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bc:	8a 10                	mov    (%eax),%dl
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	75 e3                	jne    8010b3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010d0:	eb 23                	jmp    8010f5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d5:	8d 50 01             	lea    0x1(%eax),%edx
  8010d8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010de:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010e4:	8a 12                	mov    (%edx),%dl
  8010e6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	75 dd                	jne    8010d2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f8:	c9                   	leave  
  8010f9:	c3                   	ret    

008010fa <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801106:	8b 45 0c             	mov    0xc(%ebp),%eax
  801109:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80110c:	eb 2a                	jmp    801138 <memcmp+0x3e>
		if (*s1 != *s2)
  80110e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801111:	8a 10                	mov    (%eax),%dl
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	38 c2                	cmp    %al,%dl
  80111a:	74 16                	je     801132 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80111c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	0f b6 d0             	movzbl %al,%edx
  801124:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801127:	8a 00                	mov    (%eax),%al
  801129:	0f b6 c0             	movzbl %al,%eax
  80112c:	29 c2                	sub    %eax,%edx
  80112e:	89 d0                	mov    %edx,%eax
  801130:	eb 18                	jmp    80114a <memcmp+0x50>
		s1++, s2++;
  801132:	ff 45 fc             	incl   -0x4(%ebp)
  801135:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801138:	8b 45 10             	mov    0x10(%ebp),%eax
  80113b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80113e:	89 55 10             	mov    %edx,0x10(%ebp)
  801141:	85 c0                	test   %eax,%eax
  801143:	75 c9                	jne    80110e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801145:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114a:	c9                   	leave  
  80114b:	c3                   	ret    

0080114c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801152:	8b 55 08             	mov    0x8(%ebp),%edx
  801155:	8b 45 10             	mov    0x10(%ebp),%eax
  801158:	01 d0                	add    %edx,%eax
  80115a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80115d:	eb 15                	jmp    801174 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f b6 d0             	movzbl %al,%edx
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	0f b6 c0             	movzbl %al,%eax
  80116d:	39 c2                	cmp    %eax,%edx
  80116f:	74 0d                	je     80117e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80117a:	72 e3                	jb     80115f <memfind+0x13>
  80117c:	eb 01                	jmp    80117f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80117e:	90                   	nop
	return (void *) s;
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801182:	c9                   	leave  
  801183:	c3                   	ret    

00801184 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80118a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801191:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801198:	eb 03                	jmp    80119d <strtol+0x19>
		s++;
  80119a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	3c 20                	cmp    $0x20,%al
  8011a4:	74 f4                	je     80119a <strtol+0x16>
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	3c 09                	cmp    $0x9,%al
  8011ad:	74 eb                	je     80119a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 00                	mov    (%eax),%al
  8011b4:	3c 2b                	cmp    $0x2b,%al
  8011b6:	75 05                	jne    8011bd <strtol+0x39>
		s++;
  8011b8:	ff 45 08             	incl   0x8(%ebp)
  8011bb:	eb 13                	jmp    8011d0 <strtol+0x4c>
	else if (*s == '-')
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	3c 2d                	cmp    $0x2d,%al
  8011c4:	75 0a                	jne    8011d0 <strtol+0x4c>
		s++, neg = 1;
  8011c6:	ff 45 08             	incl   0x8(%ebp)
  8011c9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d4:	74 06                	je     8011dc <strtol+0x58>
  8011d6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011da:	75 20                	jne    8011fc <strtol+0x78>
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	8a 00                	mov    (%eax),%al
  8011e1:	3c 30                	cmp    $0x30,%al
  8011e3:	75 17                	jne    8011fc <strtol+0x78>
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	40                   	inc    %eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 78                	cmp    $0x78,%al
  8011ed:	75 0d                	jne    8011fc <strtol+0x78>
		s += 2, base = 16;
  8011ef:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011f3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011fa:	eb 28                	jmp    801224 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801200:	75 15                	jne    801217 <strtol+0x93>
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	3c 30                	cmp    $0x30,%al
  801209:	75 0c                	jne    801217 <strtol+0x93>
		s++, base = 8;
  80120b:	ff 45 08             	incl   0x8(%ebp)
  80120e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801215:	eb 0d                	jmp    801224 <strtol+0xa0>
	else if (base == 0)
  801217:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121b:	75 07                	jne    801224 <strtol+0xa0>
		base = 10;
  80121d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	3c 2f                	cmp    $0x2f,%al
  80122b:	7e 19                	jle    801246 <strtol+0xc2>
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	3c 39                	cmp    $0x39,%al
  801234:	7f 10                	jg     801246 <strtol+0xc2>
			dig = *s - '0';
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	8a 00                	mov    (%eax),%al
  80123b:	0f be c0             	movsbl %al,%eax
  80123e:	83 e8 30             	sub    $0x30,%eax
  801241:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801244:	eb 42                	jmp    801288 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	8a 00                	mov    (%eax),%al
  80124b:	3c 60                	cmp    $0x60,%al
  80124d:	7e 19                	jle    801268 <strtol+0xe4>
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	3c 7a                	cmp    $0x7a,%al
  801256:	7f 10                	jg     801268 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	0f be c0             	movsbl %al,%eax
  801260:	83 e8 57             	sub    $0x57,%eax
  801263:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801266:	eb 20                	jmp    801288 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	8a 00                	mov    (%eax),%al
  80126d:	3c 40                	cmp    $0x40,%al
  80126f:	7e 39                	jle    8012aa <strtol+0x126>
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3c 5a                	cmp    $0x5a,%al
  801278:	7f 30                	jg     8012aa <strtol+0x126>
			dig = *s - 'A' + 10;
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	0f be c0             	movsbl %al,%eax
  801282:	83 e8 37             	sub    $0x37,%eax
  801285:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80128e:	7d 19                	jge    8012a9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801290:	ff 45 08             	incl   0x8(%ebp)
  801293:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801296:	0f af 45 10          	imul   0x10(%ebp),%eax
  80129a:	89 c2                	mov    %eax,%edx
  80129c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129f:	01 d0                	add    %edx,%eax
  8012a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012a4:	e9 7b ff ff ff       	jmp    801224 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012a9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012ae:	74 08                	je     8012b8 <strtol+0x134>
		*endptr = (char *) s;
  8012b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012bc:	74 07                	je     8012c5 <strtol+0x141>
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	f7 d8                	neg    %eax
  8012c3:	eb 03                	jmp    8012c8 <strtol+0x144>
  8012c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <ltostr>:

void
ltostr(long value, char *str)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e2:	79 13                	jns    8012f7 <ltostr+0x2d>
	{
		neg = 1;
  8012e4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ee:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012f1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012f4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012ff:	99                   	cltd   
  801300:	f7 f9                	idiv   %ecx
  801302:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801305:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801308:	8d 50 01             	lea    0x1(%eax),%edx
  80130b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130e:	89 c2                	mov    %eax,%edx
  801310:	8b 45 0c             	mov    0xc(%ebp),%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801318:	83 c2 30             	add    $0x30,%edx
  80131b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80131d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801320:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801325:	f7 e9                	imul   %ecx
  801327:	c1 fa 02             	sar    $0x2,%edx
  80132a:	89 c8                	mov    %ecx,%eax
  80132c:	c1 f8 1f             	sar    $0x1f,%eax
  80132f:	29 c2                	sub    %eax,%edx
  801331:	89 d0                	mov    %edx,%eax
  801333:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801336:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801339:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80133e:	f7 e9                	imul   %ecx
  801340:	c1 fa 02             	sar    $0x2,%edx
  801343:	89 c8                	mov    %ecx,%eax
  801345:	c1 f8 1f             	sar    $0x1f,%eax
  801348:	29 c2                	sub    %eax,%edx
  80134a:	89 d0                	mov    %edx,%eax
  80134c:	c1 e0 02             	shl    $0x2,%eax
  80134f:	01 d0                	add    %edx,%eax
  801351:	01 c0                	add    %eax,%eax
  801353:	29 c1                	sub    %eax,%ecx
  801355:	89 ca                	mov    %ecx,%edx
  801357:	85 d2                	test   %edx,%edx
  801359:	75 9c                	jne    8012f7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80135b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801362:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801365:	48                   	dec    %eax
  801366:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801369:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80136d:	74 3d                	je     8013ac <ltostr+0xe2>
		start = 1 ;
  80136f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801376:	eb 34                	jmp    8013ac <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137e:	01 d0                	add    %edx,%eax
  801380:	8a 00                	mov    (%eax),%al
  801382:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801385:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801388:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138b:	01 c2                	add    %eax,%edx
  80138d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801390:	8b 45 0c             	mov    0xc(%ebp),%eax
  801393:	01 c8                	add    %ecx,%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801399:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80139c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139f:	01 c2                	add    %eax,%edx
  8013a1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013a4:	88 02                	mov    %al,(%edx)
		start++ ;
  8013a6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013a9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013af:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b2:	7c c4                	jl     801378 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013b4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ba:	01 d0                	add    %edx,%eax
  8013bc:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013bf:	90                   	nop
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013c8:	ff 75 08             	pushl  0x8(%ebp)
  8013cb:	e8 54 fa ff ff       	call   800e24 <strlen>
  8013d0:	83 c4 04             	add    $0x4,%esp
  8013d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013d6:	ff 75 0c             	pushl  0xc(%ebp)
  8013d9:	e8 46 fa ff ff       	call   800e24 <strlen>
  8013de:	83 c4 04             	add    $0x4,%esp
  8013e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f2:	eb 17                	jmp    80140b <strcconcat+0x49>
		final[s] = str1[s] ;
  8013f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fa:	01 c2                	add    %eax,%edx
  8013fc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	01 c8                	add    %ecx,%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801408:	ff 45 fc             	incl   -0x4(%ebp)
  80140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801411:	7c e1                	jl     8013f4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801413:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80141a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801421:	eb 1f                	jmp    801442 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801426:	8d 50 01             	lea    0x1(%eax),%edx
  801429:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80142c:	89 c2                	mov    %eax,%edx
  80142e:	8b 45 10             	mov    0x10(%ebp),%eax
  801431:	01 c2                	add    %eax,%edx
  801433:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801436:	8b 45 0c             	mov    0xc(%ebp),%eax
  801439:	01 c8                	add    %ecx,%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80143f:	ff 45 f8             	incl   -0x8(%ebp)
  801442:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801445:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801448:	7c d9                	jl     801423 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80144a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144d:	8b 45 10             	mov    0x10(%ebp),%eax
  801450:	01 d0                	add    %edx,%eax
  801452:	c6 00 00             	movb   $0x0,(%eax)
}
  801455:	90                   	nop
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80145b:	8b 45 14             	mov    0x14(%ebp),%eax
  80145e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801464:	8b 45 14             	mov    0x14(%ebp),%eax
  801467:	8b 00                	mov    (%eax),%eax
  801469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80147b:	eb 0c                	jmp    801489 <strsplit+0x31>
			*string++ = 0;
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8d 50 01             	lea    0x1(%eax),%edx
  801483:	89 55 08             	mov    %edx,0x8(%ebp)
  801486:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	84 c0                	test   %al,%al
  801490:	74 18                	je     8014aa <strsplit+0x52>
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	0f be c0             	movsbl %al,%eax
  80149a:	50                   	push   %eax
  80149b:	ff 75 0c             	pushl  0xc(%ebp)
  80149e:	e8 13 fb ff ff       	call   800fb6 <strchr>
  8014a3:	83 c4 08             	add    $0x8,%esp
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	75 d3                	jne    80147d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	84 c0                	test   %al,%al
  8014b1:	74 5a                	je     80150d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b6:	8b 00                	mov    (%eax),%eax
  8014b8:	83 f8 0f             	cmp    $0xf,%eax
  8014bb:	75 07                	jne    8014c4 <strsplit+0x6c>
		{
			return 0;
  8014bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c2:	eb 66                	jmp    80152a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c7:	8b 00                	mov    (%eax),%eax
  8014c9:	8d 48 01             	lea    0x1(%eax),%ecx
  8014cc:	8b 55 14             	mov    0x14(%ebp),%edx
  8014cf:	89 0a                	mov    %ecx,(%edx)
  8014d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014db:	01 c2                	add    %eax,%edx
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e2:	eb 03                	jmp    8014e7 <strsplit+0x8f>
			string++;
  8014e4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	84 c0                	test   %al,%al
  8014ee:	74 8b                	je     80147b <strsplit+0x23>
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	0f be c0             	movsbl %al,%eax
  8014f8:	50                   	push   %eax
  8014f9:	ff 75 0c             	pushl  0xc(%ebp)
  8014fc:	e8 b5 fa ff ff       	call   800fb6 <strchr>
  801501:	83 c4 08             	add    $0x8,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	74 dc                	je     8014e4 <strsplit+0x8c>
			string++;
	}
  801508:	e9 6e ff ff ff       	jmp    80147b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80150d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80150e:	8b 45 14             	mov    0x14(%ebp),%eax
  801511:	8b 00                	mov    (%eax),%eax
  801513:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151a:	8b 45 10             	mov    0x10(%ebp),%eax
  80151d:	01 d0                	add    %edx,%eax
  80151f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801525:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801532:	83 ec 04             	sub    $0x4,%esp
  801535:	68 10 29 80 00       	push   $0x802910
  80153a:	6a 19                	push   $0x19
  80153c:	68 35 29 80 00       	push   $0x802935
  801541:	e8 ba ef ff ff       	call   800500 <_panic>

00801546 <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	83 ec 18             	sub    $0x18,%esp
  80154c:	8b 45 10             	mov    0x10(%ebp),%eax
  80154f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801552:	83 ec 04             	sub    $0x4,%esp
  801555:	68 44 29 80 00       	push   $0x802944
  80155a:	6a 31                	push   $0x31
  80155c:	68 35 29 80 00       	push   $0x802935
  801561:	e8 9a ef ff ff       	call   800500 <_panic>

00801566 <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	68 6c 29 80 00       	push   $0x80296c
  801574:	6a 4a                	push   $0x4a
  801576:	68 35 29 80 00       	push   $0x802935
  80157b:	e8 80 ef ff ff       	call   800500 <_panic>

00801580 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	68 90 29 80 00       	push   $0x802990
  80158e:	6a 70                	push   $0x70
  801590:	68 35 29 80 00       	push   $0x802935
  801595:	e8 66 ef ff ff       	call   800500 <_panic>

0080159a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015a0:	83 ec 04             	sub    $0x4,%esp
  8015a3:	68 b4 29 80 00       	push   $0x8029b4
  8015a8:	68 8b 00 00 00       	push   $0x8b
  8015ad:	68 35 29 80 00       	push   $0x802935
  8015b2:	e8 49 ef ff ff       	call   800500 <_panic>

008015b7 <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015bd:	83 ec 04             	sub    $0x4,%esp
  8015c0:	68 d8 29 80 00       	push   $0x8029d8
  8015c5:	68 a8 00 00 00       	push   $0xa8
  8015ca:	68 35 29 80 00       	push   $0x802935
  8015cf:	e8 2c ef ff ff       	call   800500 <_panic>

008015d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	57                   	push   %edi
  8015d8:	56                   	push   %esi
  8015d9:	53                   	push   %ebx
  8015da:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015e9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015ec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015ef:	cd 30                	int    $0x30
  8015f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015f7:	83 c4 10             	add    $0x10,%esp
  8015fa:	5b                   	pop    %ebx
  8015fb:	5e                   	pop    %esi
  8015fc:	5f                   	pop    %edi
  8015fd:	5d                   	pop    %ebp
  8015fe:	c3                   	ret    

008015ff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	8b 45 10             	mov    0x10(%ebp),%eax
  801608:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80160b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	52                   	push   %edx
  801617:	ff 75 0c             	pushl  0xc(%ebp)
  80161a:	50                   	push   %eax
  80161b:	6a 00                	push   $0x0
  80161d:	e8 b2 ff ff ff       	call   8015d4 <syscall>
  801622:	83 c4 18             	add    $0x18,%esp
}
  801625:	90                   	nop
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <sys_cgetc>:

int
sys_cgetc(void)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 01                	push   $0x1
  801637:	e8 98 ff ff ff       	call   8015d4 <syscall>
  80163c:	83 c4 18             	add    $0x18,%esp
}
  80163f:	c9                   	leave  
  801640:	c3                   	ret    

00801641 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	50                   	push   %eax
  801650:	6a 05                	push   $0x5
  801652:	e8 7d ff ff ff       	call   8015d4 <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
}
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 02                	push   $0x2
  80166b:	e8 64 ff ff ff       	call   8015d4 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 03                	push   $0x3
  801684:	e8 4b ff ff ff       	call   8015d4 <syscall>
  801689:	83 c4 18             	add    $0x18,%esp
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 04                	push   $0x4
  80169d:	e8 32 ff ff ff       	call   8015d4 <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <sys_env_exit>:


void sys_env_exit(void)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 06                	push   $0x6
  8016b6:	e8 19 ff ff ff       	call   8015d4 <syscall>
  8016bb:	83 c4 18             	add    $0x18,%esp
}
  8016be:	90                   	nop
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	52                   	push   %edx
  8016d1:	50                   	push   %eax
  8016d2:	6a 07                	push   $0x7
  8016d4:	e8 fb fe ff ff       	call   8015d4 <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	56                   	push   %esi
  8016e2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016e3:	8b 75 18             	mov    0x18(%ebp),%esi
  8016e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	56                   	push   %esi
  8016f3:	53                   	push   %ebx
  8016f4:	51                   	push   %ecx
  8016f5:	52                   	push   %edx
  8016f6:	50                   	push   %eax
  8016f7:	6a 08                	push   $0x8
  8016f9:	e8 d6 fe ff ff       	call   8015d4 <syscall>
  8016fe:	83 c4 18             	add    $0x18,%esp
}
  801701:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801704:	5b                   	pop    %ebx
  801705:	5e                   	pop    %esi
  801706:	5d                   	pop    %ebp
  801707:	c3                   	ret    

00801708 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80170b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	52                   	push   %edx
  801718:	50                   	push   %eax
  801719:	6a 09                	push   $0x9
  80171b:	e8 b4 fe ff ff       	call   8015d4 <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	ff 75 0c             	pushl  0xc(%ebp)
  801731:	ff 75 08             	pushl  0x8(%ebp)
  801734:	6a 0a                	push   $0xa
  801736:	e8 99 fe ff ff       	call   8015d4 <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 0b                	push   $0xb
  80174f:	e8 80 fe ff ff       	call   8015d4 <syscall>
  801754:	83 c4 18             	add    $0x18,%esp
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 0c                	push   $0xc
  801768:	e8 67 fe ff ff       	call   8015d4 <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 0d                	push   $0xd
  801781:	e8 4e fe ff ff       	call   8015d4 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	ff 75 0c             	pushl  0xc(%ebp)
  801797:	ff 75 08             	pushl  0x8(%ebp)
  80179a:	6a 11                	push   $0x11
  80179c:	e8 33 fe ff ff       	call   8015d4 <syscall>
  8017a1:	83 c4 18             	add    $0x18,%esp
	return;
  8017a4:	90                   	nop
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	ff 75 0c             	pushl  0xc(%ebp)
  8017b3:	ff 75 08             	pushl  0x8(%ebp)
  8017b6:	6a 12                	push   $0x12
  8017b8:	e8 17 fe ff ff       	call   8015d4 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c0:	90                   	nop
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 0e                	push   $0xe
  8017d2:	e8 fd fd ff ff       	call   8015d4 <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	ff 75 08             	pushl  0x8(%ebp)
  8017ea:	6a 0f                	push   $0xf
  8017ec:	e8 e3 fd ff ff       	call   8015d4 <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 10                	push   $0x10
  801805:	e8 ca fd ff ff       	call   8015d4 <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
}
  80180d:	90                   	nop
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 14                	push   $0x14
  80181f:	e8 b0 fd ff ff       	call   8015d4 <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
}
  801827:	90                   	nop
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 15                	push   $0x15
  801839:	e8 96 fd ff ff       	call   8015d4 <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	90                   	nop
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_cputc>:


void
sys_cputc(const char c)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801850:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	50                   	push   %eax
  80185d:	6a 16                	push   $0x16
  80185f:	e8 70 fd ff ff       	call   8015d4 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	90                   	nop
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 17                	push   $0x17
  801879:	e8 56 fd ff ff       	call   8015d4 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	90                   	nop
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	ff 75 0c             	pushl  0xc(%ebp)
  801893:	50                   	push   %eax
  801894:	6a 18                	push   $0x18
  801896:	e8 39 fd ff ff       	call   8015d4 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	52                   	push   %edx
  8018b0:	50                   	push   %eax
  8018b1:	6a 1b                	push   $0x1b
  8018b3:	e8 1c fd ff ff       	call   8015d4 <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	52                   	push   %edx
  8018cd:	50                   	push   %eax
  8018ce:	6a 19                	push   $0x19
  8018d0:	e8 ff fc ff ff       	call   8015d4 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	90                   	nop
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	52                   	push   %edx
  8018eb:	50                   	push   %eax
  8018ec:	6a 1a                	push   $0x1a
  8018ee:	e8 e1 fc ff ff       	call   8015d4 <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
}
  8018f6:	90                   	nop
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 04             	sub    $0x4,%esp
  8018ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801902:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801905:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801908:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	6a 00                	push   $0x0
  801911:	51                   	push   %ecx
  801912:	52                   	push   %edx
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	50                   	push   %eax
  801917:	6a 1c                	push   $0x1c
  801919:	e8 b6 fc ff ff       	call   8015d4 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801926:	8b 55 0c             	mov    0xc(%ebp),%edx
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	52                   	push   %edx
  801933:	50                   	push   %eax
  801934:	6a 1d                	push   $0x1d
  801936:	e8 99 fc ff ff       	call   8015d4 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801943:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801946:	8b 55 0c             	mov    0xc(%ebp),%edx
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	51                   	push   %ecx
  801951:	52                   	push   %edx
  801952:	50                   	push   %eax
  801953:	6a 1e                	push   $0x1e
  801955:	e8 7a fc ff ff       	call   8015d4 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801962:	8b 55 0c             	mov    0xc(%ebp),%edx
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	52                   	push   %edx
  80196f:	50                   	push   %eax
  801970:	6a 1f                	push   $0x1f
  801972:	e8 5d fc ff ff       	call   8015d4 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 20                	push   $0x20
  80198b:	e8 44 fc ff ff       	call   8015d4 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	ff 75 10             	pushl  0x10(%ebp)
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	50                   	push   %eax
  8019a6:	6a 21                	push   $0x21
  8019a8:	e8 27 fc ff ff       	call   8015d4 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_run_env>:


void
sys_run_env(int32 envId)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	50                   	push   %eax
  8019c1:	6a 22                	push   $0x22
  8019c3:	e8 0c fc ff ff       	call   8015d4 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	90                   	nop
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	50                   	push   %eax
  8019dd:	6a 23                	push   $0x23
  8019df:	e8 f0 fb ff ff       	call   8015d4 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	90                   	nop
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019f3:	8d 50 04             	lea    0x4(%eax),%edx
  8019f6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	52                   	push   %edx
  801a00:	50                   	push   %eax
  801a01:	6a 24                	push   $0x24
  801a03:	e8 cc fb ff ff       	call   8015d4 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
	return result;
  801a0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a14:	89 01                	mov    %eax,(%ecx)
  801a16:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	c9                   	leave  
  801a1d:	c2 04 00             	ret    $0x4

00801a20 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	ff 75 10             	pushl  0x10(%ebp)
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	ff 75 08             	pushl  0x8(%ebp)
  801a30:	6a 13                	push   $0x13
  801a32:	e8 9d fb ff ff       	call   8015d4 <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3a:	90                   	nop
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_rcr2>:
uint32 sys_rcr2()
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 25                	push   $0x25
  801a4c:	e8 83 fb ff ff       	call   8015d4 <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 04             	sub    $0x4,%esp
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a62:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	50                   	push   %eax
  801a6f:	6a 26                	push   $0x26
  801a71:	e8 5e fb ff ff       	call   8015d4 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
	return ;
  801a79:	90                   	nop
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <rsttst>:
void rsttst()
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 28                	push   $0x28
  801a8b:	e8 44 fb ff ff       	call   8015d4 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
	return ;
  801a93:	90                   	nop
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 04             	sub    $0x4,%esp
  801a9c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801aa2:	8b 55 18             	mov    0x18(%ebp),%edx
  801aa5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aa9:	52                   	push   %edx
  801aaa:	50                   	push   %eax
  801aab:	ff 75 10             	pushl  0x10(%ebp)
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	6a 27                	push   $0x27
  801ab6:	e8 19 fb ff ff       	call   8015d4 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
	return ;
  801abe:	90                   	nop
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <chktst>:
void chktst(uint32 n)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	ff 75 08             	pushl  0x8(%ebp)
  801acf:	6a 29                	push   $0x29
  801ad1:	e8 fe fa ff ff       	call   8015d4 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad9:	90                   	nop
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <inctst>:

void inctst()
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 2a                	push   $0x2a
  801aeb:	e8 e4 fa ff ff       	call   8015d4 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
	return ;
  801af3:	90                   	nop
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <gettst>:
uint32 gettst()
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 2b                	push   $0x2b
  801b05:	e8 ca fa ff ff       	call   8015d4 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 2c                	push   $0x2c
  801b21:	e8 ae fa ff ff       	call   8015d4 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
  801b29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b2c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b30:	75 07                	jne    801b39 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b32:	b8 01 00 00 00       	mov    $0x1,%eax
  801b37:	eb 05                	jmp    801b3e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 2c                	push   $0x2c
  801b52:	e8 7d fa ff ff       	call   8015d4 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
  801b5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b5d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b61:	75 07                	jne    801b6a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b63:	b8 01 00 00 00       	mov    $0x1,%eax
  801b68:	eb 05                	jmp    801b6f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 2c                	push   $0x2c
  801b83:	e8 4c fa ff ff       	call   8015d4 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
  801b8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b8e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b92:	75 07                	jne    801b9b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b94:	b8 01 00 00 00       	mov    $0x1,%eax
  801b99:	eb 05                	jmp    801ba0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 2c                	push   $0x2c
  801bb4:	e8 1b fa ff ff       	call   8015d4 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
  801bbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bbf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bc3:	75 07                	jne    801bcc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bc5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bca:	eb 05                	jmp    801bd1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	ff 75 08             	pushl  0x8(%ebp)
  801be1:	6a 2d                	push   $0x2d
  801be3:	e8 ec f9 ff ff       	call   8015d4 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
	return ;
  801beb:	90                   	nop
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801bf2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bf5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	6a 00                	push   $0x0
  801c00:	53                   	push   %ebx
  801c01:	51                   	push   %ecx
  801c02:	52                   	push   %edx
  801c03:	50                   	push   %eax
  801c04:	6a 2e                	push   $0x2e
  801c06:	e8 c9 f9 ff ff       	call   8015d4 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	52                   	push   %edx
  801c23:	50                   	push   %eax
  801c24:	6a 2f                	push   $0x2f
  801c26:	e8 a9 f9 ff ff       	call   8015d4 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801c36:	8b 55 08             	mov    0x8(%ebp),%edx
  801c39:	89 d0                	mov    %edx,%eax
  801c3b:	c1 e0 02             	shl    $0x2,%eax
  801c3e:	01 d0                	add    %edx,%eax
  801c40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c47:	01 d0                	add    %edx,%eax
  801c49:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c50:	01 d0                	add    %edx,%eax
  801c52:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c59:	01 d0                	add    %edx,%eax
  801c5b:	c1 e0 04             	shl    $0x4,%eax
  801c5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801c61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801c68:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801c6b:	83 ec 0c             	sub    $0xc,%esp
  801c6e:	50                   	push   %eax
  801c6f:	e8 76 fd ff ff       	call   8019ea <sys_get_virtual_time>
  801c74:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801c77:	eb 41                	jmp    801cba <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801c79:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801c7c:	83 ec 0c             	sub    $0xc,%esp
  801c7f:	50                   	push   %eax
  801c80:	e8 65 fd ff ff       	call   8019ea <sys_get_virtual_time>
  801c85:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801c88:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c8e:	29 c2                	sub    %eax,%edx
  801c90:	89 d0                	mov    %edx,%eax
  801c92:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801c95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c9b:	89 d1                	mov    %edx,%ecx
  801c9d:	29 c1                	sub    %eax,%ecx
  801c9f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ca2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca5:	39 c2                	cmp    %eax,%edx
  801ca7:	0f 97 c0             	seta   %al
  801caa:	0f b6 c0             	movzbl %al,%eax
  801cad:	29 c1                	sub    %eax,%ecx
  801caf:	89 c8                	mov    %ecx,%eax
  801cb1:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801cb4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801cc0:	72 b7                	jb     801c79 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801cc2:	90                   	nop
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801ccb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801cd2:	eb 03                	jmp    801cd7 <busy_wait+0x12>
  801cd4:	ff 45 fc             	incl   -0x4(%ebp)
  801cd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cda:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cdd:	72 f5                	jb     801cd4 <busy_wait+0xf>
	return i;
  801cdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <__udivdi3>:
  801ce4:	55                   	push   %ebp
  801ce5:	57                   	push   %edi
  801ce6:	56                   	push   %esi
  801ce7:	53                   	push   %ebx
  801ce8:	83 ec 1c             	sub    $0x1c,%esp
  801ceb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801cef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cf3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cf7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cfb:	89 ca                	mov    %ecx,%edx
  801cfd:	89 f8                	mov    %edi,%eax
  801cff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d03:	85 f6                	test   %esi,%esi
  801d05:	75 2d                	jne    801d34 <__udivdi3+0x50>
  801d07:	39 cf                	cmp    %ecx,%edi
  801d09:	77 65                	ja     801d70 <__udivdi3+0x8c>
  801d0b:	89 fd                	mov    %edi,%ebp
  801d0d:	85 ff                	test   %edi,%edi
  801d0f:	75 0b                	jne    801d1c <__udivdi3+0x38>
  801d11:	b8 01 00 00 00       	mov    $0x1,%eax
  801d16:	31 d2                	xor    %edx,%edx
  801d18:	f7 f7                	div    %edi
  801d1a:	89 c5                	mov    %eax,%ebp
  801d1c:	31 d2                	xor    %edx,%edx
  801d1e:	89 c8                	mov    %ecx,%eax
  801d20:	f7 f5                	div    %ebp
  801d22:	89 c1                	mov    %eax,%ecx
  801d24:	89 d8                	mov    %ebx,%eax
  801d26:	f7 f5                	div    %ebp
  801d28:	89 cf                	mov    %ecx,%edi
  801d2a:	89 fa                	mov    %edi,%edx
  801d2c:	83 c4 1c             	add    $0x1c,%esp
  801d2f:	5b                   	pop    %ebx
  801d30:	5e                   	pop    %esi
  801d31:	5f                   	pop    %edi
  801d32:	5d                   	pop    %ebp
  801d33:	c3                   	ret    
  801d34:	39 ce                	cmp    %ecx,%esi
  801d36:	77 28                	ja     801d60 <__udivdi3+0x7c>
  801d38:	0f bd fe             	bsr    %esi,%edi
  801d3b:	83 f7 1f             	xor    $0x1f,%edi
  801d3e:	75 40                	jne    801d80 <__udivdi3+0x9c>
  801d40:	39 ce                	cmp    %ecx,%esi
  801d42:	72 0a                	jb     801d4e <__udivdi3+0x6a>
  801d44:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d48:	0f 87 9e 00 00 00    	ja     801dec <__udivdi3+0x108>
  801d4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d53:	89 fa                	mov    %edi,%edx
  801d55:	83 c4 1c             	add    $0x1c,%esp
  801d58:	5b                   	pop    %ebx
  801d59:	5e                   	pop    %esi
  801d5a:	5f                   	pop    %edi
  801d5b:	5d                   	pop    %ebp
  801d5c:	c3                   	ret    
  801d5d:	8d 76 00             	lea    0x0(%esi),%esi
  801d60:	31 ff                	xor    %edi,%edi
  801d62:	31 c0                	xor    %eax,%eax
  801d64:	89 fa                	mov    %edi,%edx
  801d66:	83 c4 1c             	add    $0x1c,%esp
  801d69:	5b                   	pop    %ebx
  801d6a:	5e                   	pop    %esi
  801d6b:	5f                   	pop    %edi
  801d6c:	5d                   	pop    %ebp
  801d6d:	c3                   	ret    
  801d6e:	66 90                	xchg   %ax,%ax
  801d70:	89 d8                	mov    %ebx,%eax
  801d72:	f7 f7                	div    %edi
  801d74:	31 ff                	xor    %edi,%edi
  801d76:	89 fa                	mov    %edi,%edx
  801d78:	83 c4 1c             	add    $0x1c,%esp
  801d7b:	5b                   	pop    %ebx
  801d7c:	5e                   	pop    %esi
  801d7d:	5f                   	pop    %edi
  801d7e:	5d                   	pop    %ebp
  801d7f:	c3                   	ret    
  801d80:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d85:	89 eb                	mov    %ebp,%ebx
  801d87:	29 fb                	sub    %edi,%ebx
  801d89:	89 f9                	mov    %edi,%ecx
  801d8b:	d3 e6                	shl    %cl,%esi
  801d8d:	89 c5                	mov    %eax,%ebp
  801d8f:	88 d9                	mov    %bl,%cl
  801d91:	d3 ed                	shr    %cl,%ebp
  801d93:	89 e9                	mov    %ebp,%ecx
  801d95:	09 f1                	or     %esi,%ecx
  801d97:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d9b:	89 f9                	mov    %edi,%ecx
  801d9d:	d3 e0                	shl    %cl,%eax
  801d9f:	89 c5                	mov    %eax,%ebp
  801da1:	89 d6                	mov    %edx,%esi
  801da3:	88 d9                	mov    %bl,%cl
  801da5:	d3 ee                	shr    %cl,%esi
  801da7:	89 f9                	mov    %edi,%ecx
  801da9:	d3 e2                	shl    %cl,%edx
  801dab:	8b 44 24 08          	mov    0x8(%esp),%eax
  801daf:	88 d9                	mov    %bl,%cl
  801db1:	d3 e8                	shr    %cl,%eax
  801db3:	09 c2                	or     %eax,%edx
  801db5:	89 d0                	mov    %edx,%eax
  801db7:	89 f2                	mov    %esi,%edx
  801db9:	f7 74 24 0c          	divl   0xc(%esp)
  801dbd:	89 d6                	mov    %edx,%esi
  801dbf:	89 c3                	mov    %eax,%ebx
  801dc1:	f7 e5                	mul    %ebp
  801dc3:	39 d6                	cmp    %edx,%esi
  801dc5:	72 19                	jb     801de0 <__udivdi3+0xfc>
  801dc7:	74 0b                	je     801dd4 <__udivdi3+0xf0>
  801dc9:	89 d8                	mov    %ebx,%eax
  801dcb:	31 ff                	xor    %edi,%edi
  801dcd:	e9 58 ff ff ff       	jmp    801d2a <__udivdi3+0x46>
  801dd2:	66 90                	xchg   %ax,%ax
  801dd4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801dd8:	89 f9                	mov    %edi,%ecx
  801dda:	d3 e2                	shl    %cl,%edx
  801ddc:	39 c2                	cmp    %eax,%edx
  801dde:	73 e9                	jae    801dc9 <__udivdi3+0xe5>
  801de0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801de3:	31 ff                	xor    %edi,%edi
  801de5:	e9 40 ff ff ff       	jmp    801d2a <__udivdi3+0x46>
  801dea:	66 90                	xchg   %ax,%ax
  801dec:	31 c0                	xor    %eax,%eax
  801dee:	e9 37 ff ff ff       	jmp    801d2a <__udivdi3+0x46>
  801df3:	90                   	nop

00801df4 <__umoddi3>:
  801df4:	55                   	push   %ebp
  801df5:	57                   	push   %edi
  801df6:	56                   	push   %esi
  801df7:	53                   	push   %ebx
  801df8:	83 ec 1c             	sub    $0x1c,%esp
  801dfb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801dff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e07:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e13:	89 f3                	mov    %esi,%ebx
  801e15:	89 fa                	mov    %edi,%edx
  801e17:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e1b:	89 34 24             	mov    %esi,(%esp)
  801e1e:	85 c0                	test   %eax,%eax
  801e20:	75 1a                	jne    801e3c <__umoddi3+0x48>
  801e22:	39 f7                	cmp    %esi,%edi
  801e24:	0f 86 a2 00 00 00    	jbe    801ecc <__umoddi3+0xd8>
  801e2a:	89 c8                	mov    %ecx,%eax
  801e2c:	89 f2                	mov    %esi,%edx
  801e2e:	f7 f7                	div    %edi
  801e30:	89 d0                	mov    %edx,%eax
  801e32:	31 d2                	xor    %edx,%edx
  801e34:	83 c4 1c             	add    $0x1c,%esp
  801e37:	5b                   	pop    %ebx
  801e38:	5e                   	pop    %esi
  801e39:	5f                   	pop    %edi
  801e3a:	5d                   	pop    %ebp
  801e3b:	c3                   	ret    
  801e3c:	39 f0                	cmp    %esi,%eax
  801e3e:	0f 87 ac 00 00 00    	ja     801ef0 <__umoddi3+0xfc>
  801e44:	0f bd e8             	bsr    %eax,%ebp
  801e47:	83 f5 1f             	xor    $0x1f,%ebp
  801e4a:	0f 84 ac 00 00 00    	je     801efc <__umoddi3+0x108>
  801e50:	bf 20 00 00 00       	mov    $0x20,%edi
  801e55:	29 ef                	sub    %ebp,%edi
  801e57:	89 fe                	mov    %edi,%esi
  801e59:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e5d:	89 e9                	mov    %ebp,%ecx
  801e5f:	d3 e0                	shl    %cl,%eax
  801e61:	89 d7                	mov    %edx,%edi
  801e63:	89 f1                	mov    %esi,%ecx
  801e65:	d3 ef                	shr    %cl,%edi
  801e67:	09 c7                	or     %eax,%edi
  801e69:	89 e9                	mov    %ebp,%ecx
  801e6b:	d3 e2                	shl    %cl,%edx
  801e6d:	89 14 24             	mov    %edx,(%esp)
  801e70:	89 d8                	mov    %ebx,%eax
  801e72:	d3 e0                	shl    %cl,%eax
  801e74:	89 c2                	mov    %eax,%edx
  801e76:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e7a:	d3 e0                	shl    %cl,%eax
  801e7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e80:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e84:	89 f1                	mov    %esi,%ecx
  801e86:	d3 e8                	shr    %cl,%eax
  801e88:	09 d0                	or     %edx,%eax
  801e8a:	d3 eb                	shr    %cl,%ebx
  801e8c:	89 da                	mov    %ebx,%edx
  801e8e:	f7 f7                	div    %edi
  801e90:	89 d3                	mov    %edx,%ebx
  801e92:	f7 24 24             	mull   (%esp)
  801e95:	89 c6                	mov    %eax,%esi
  801e97:	89 d1                	mov    %edx,%ecx
  801e99:	39 d3                	cmp    %edx,%ebx
  801e9b:	0f 82 87 00 00 00    	jb     801f28 <__umoddi3+0x134>
  801ea1:	0f 84 91 00 00 00    	je     801f38 <__umoddi3+0x144>
  801ea7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801eab:	29 f2                	sub    %esi,%edx
  801ead:	19 cb                	sbb    %ecx,%ebx
  801eaf:	89 d8                	mov    %ebx,%eax
  801eb1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801eb5:	d3 e0                	shl    %cl,%eax
  801eb7:	89 e9                	mov    %ebp,%ecx
  801eb9:	d3 ea                	shr    %cl,%edx
  801ebb:	09 d0                	or     %edx,%eax
  801ebd:	89 e9                	mov    %ebp,%ecx
  801ebf:	d3 eb                	shr    %cl,%ebx
  801ec1:	89 da                	mov    %ebx,%edx
  801ec3:	83 c4 1c             	add    $0x1c,%esp
  801ec6:	5b                   	pop    %ebx
  801ec7:	5e                   	pop    %esi
  801ec8:	5f                   	pop    %edi
  801ec9:	5d                   	pop    %ebp
  801eca:	c3                   	ret    
  801ecb:	90                   	nop
  801ecc:	89 fd                	mov    %edi,%ebp
  801ece:	85 ff                	test   %edi,%edi
  801ed0:	75 0b                	jne    801edd <__umoddi3+0xe9>
  801ed2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed7:	31 d2                	xor    %edx,%edx
  801ed9:	f7 f7                	div    %edi
  801edb:	89 c5                	mov    %eax,%ebp
  801edd:	89 f0                	mov    %esi,%eax
  801edf:	31 d2                	xor    %edx,%edx
  801ee1:	f7 f5                	div    %ebp
  801ee3:	89 c8                	mov    %ecx,%eax
  801ee5:	f7 f5                	div    %ebp
  801ee7:	89 d0                	mov    %edx,%eax
  801ee9:	e9 44 ff ff ff       	jmp    801e32 <__umoddi3+0x3e>
  801eee:	66 90                	xchg   %ax,%ax
  801ef0:	89 c8                	mov    %ecx,%eax
  801ef2:	89 f2                	mov    %esi,%edx
  801ef4:	83 c4 1c             	add    $0x1c,%esp
  801ef7:	5b                   	pop    %ebx
  801ef8:	5e                   	pop    %esi
  801ef9:	5f                   	pop    %edi
  801efa:	5d                   	pop    %ebp
  801efb:	c3                   	ret    
  801efc:	3b 04 24             	cmp    (%esp),%eax
  801eff:	72 06                	jb     801f07 <__umoddi3+0x113>
  801f01:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f05:	77 0f                	ja     801f16 <__umoddi3+0x122>
  801f07:	89 f2                	mov    %esi,%edx
  801f09:	29 f9                	sub    %edi,%ecx
  801f0b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f0f:	89 14 24             	mov    %edx,(%esp)
  801f12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f16:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f1a:	8b 14 24             	mov    (%esp),%edx
  801f1d:	83 c4 1c             	add    $0x1c,%esp
  801f20:	5b                   	pop    %ebx
  801f21:	5e                   	pop    %esi
  801f22:	5f                   	pop    %edi
  801f23:	5d                   	pop    %ebp
  801f24:	c3                   	ret    
  801f25:	8d 76 00             	lea    0x0(%esi),%esi
  801f28:	2b 04 24             	sub    (%esp),%eax
  801f2b:	19 fa                	sbb    %edi,%edx
  801f2d:	89 d1                	mov    %edx,%ecx
  801f2f:	89 c6                	mov    %eax,%esi
  801f31:	e9 71 ff ff ff       	jmp    801ea7 <__umoddi3+0xb3>
  801f36:	66 90                	xchg   %ax,%ax
  801f38:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f3c:	72 ea                	jb     801f28 <__umoddi3+0x134>
  801f3e:	89 d9                	mov    %ebx,%ecx
  801f40:	e9 62 ff ff ff       	jmp    801ea7 <__umoddi3+0xb3>
