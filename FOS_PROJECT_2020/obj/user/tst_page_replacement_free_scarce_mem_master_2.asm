
obj/user/tst_page_replacement_free_scarce_mem_master_2:     file format elf32-i386


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
  800031:	e8 5a 01 00 00       	call   800190 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 74 20 00 00    	sub    $0x2074,%esp
	int IDs[20];

	// Create & run the slave environments
	IDs[0] = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  800042:	a1 20 30 80 00       	mov    0x803020,%eax
  800047:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80004d:	a1 20 30 80 00       	mov    0x803020,%eax
  800052:	8b 40 74             	mov    0x74(%eax),%eax
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	52                   	push   %edx
  800059:	50                   	push   %eax
  80005a:	68 80 1c 80 00       	push   $0x801c80
  80005f:	e8 5e 16 00 00       	call   8016c2 <sys_create_env>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 94             	mov    %eax,-0x6c(%ebp)
	sys_run_env(IDs[0]);
  80006a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80006d:	83 ec 0c             	sub    $0xc,%esp
  800070:	50                   	push   %eax
  800071:	e8 69 16 00 00       	call   8016df <sys_run_env>
  800076:	83 c4 10             	add    $0x10,%esp
	for(int i = 1; i < 10; ++i)
  800079:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  800080:	eb 44                	jmp    8000c6 <_main+0x8e>
	{
		IDs[i] = sys_create_env("dummy_process", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
  800082:	a1 20 30 80 00       	mov    0x803020,%eax
  800087:	8b 90 84 3c 01 00    	mov    0x13c84(%eax),%edx
  80008d:	a1 20 30 80 00       	mov    0x803020,%eax
  800092:	8b 40 74             	mov    0x74(%eax),%eax
  800095:	83 ec 04             	sub    $0x4,%esp
  800098:	52                   	push   %edx
  800099:	50                   	push   %eax
  80009a:	68 8f 1c 80 00       	push   $0x801c8f
  80009f:	e8 1e 16 00 00       	call   8016c2 <sys_create_env>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 c2                	mov    %eax,%edx
  8000a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ac:	89 54 85 94          	mov    %edx,-0x6c(%ebp,%eax,4)
		sys_run_env(IDs[i]);
  8000b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b3:	8b 44 85 94          	mov    -0x6c(%ebp,%eax,4),%eax
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	50                   	push   %eax
  8000bb:	e8 1f 16 00 00       	call   8016df <sys_run_env>
  8000c0:	83 c4 10             	add    $0x10,%esp
	int IDs[20];

	// Create & run the slave environments
	IDs[0] = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(IDs[0]);
	for(int i = 1; i < 10; ++i)
  8000c3:	ff 45 f4             	incl   -0xc(%ebp)
  8000c6:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  8000ca:	7e b6                	jle    800082 <_main+0x4a>
		IDs[i] = sys_create_env("dummy_process", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
		sys_run_env(IDs[i]);
	}

	// To check that the slave environments completed successfully
	rsttst();
  8000cc:	e8 d8 16 00 00       	call   8017a9 <rsttst>

	env_sleep(3000);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	68 b8 0b 00 00       	push   $0xbb8
  8000d9:	e8 7f 18 00 00       	call   80195d <env_sleep>
  8000de:	83 c4 10             	add    $0x10,%esp
	sys_scarce_memory();
  8000e1:	e8 3d 14 00 00       	call   801523 <sys_scarce_memory>
	uint32 freePagesBefore = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  8000e6:	e8 82 13 00 00       	call   80146d <sys_calculate_free_frames>
  8000eb:	89 c3                	mov    %eax,%ebx
  8000ed:	e8 94 13 00 00       	call   801486 <sys_calculate_modified_frames>
  8000f2:	01 d8                	add    %ebx,%eax
  8000f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 usedDiskPagesBefore = sys_pf_calculate_allocated_pages();
  8000f7:	e8 f4 13 00 00       	call   8014f0 <sys_pf_calculate_allocated_pages>
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	// Check the number of pages shall be deleted with the first fault after scarce the memory
	int pagesToBeDeletedCount = sys_calculate_pages_tobe_removed_ready_exit(1);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	6a 01                	push   $0x1
  800104:	e8 00 14 00 00       	call   801509 <sys_calculate_pages_tobe_removed_ready_exit>
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	char arr[PAGE_SIZE*2];
	// Access the created array in STACK to FAULT and Free SCARCE MEM
	arr[1*PAGE_SIZE] = -1;
  80010f:	c6 85 94 ef ff ff ff 	movb   $0xff,-0x106c(%ebp)

	//cprintf("Checking Allocation in Mem & Page File... \n");
	//AFTER freeing MEMORY
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPagesBefore) !=  1) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800116:	e8 d5 13 00 00       	call   8014f0 <sys_pf_calculate_allocated_pages>
  80011b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80011e:	83 f8 01             	cmp    $0x1,%eax
  800121:	74 14                	je     800137 <_main+0xff>
  800123:	83 ec 04             	sub    $0x4,%esp
  800126:	68 a0 1c 80 00       	push   $0x801ca0
  80012b:	6a 22                	push   $0x22
  80012d:	68 0c 1d 80 00       	push   $0x801d0c
  800132:	e8 9e 01 00 00       	call   8002d5 <_panic>
		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800137:	e8 31 13 00 00       	call   80146d <sys_calculate_free_frames>
  80013c:	89 c3                	mov    %eax,%ebx
  80013e:	e8 43 13 00 00       	call   801486 <sys_calculate_modified_frames>
  800143:	01 d8                	add    %ebx,%eax
  800145:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if( (freePagesBefore + pagesToBeDeletedCount - 1) != freePagesAfter )
  800148:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80014b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	48                   	dec    %eax
  800151:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800154:	74 14                	je     80016a <_main+0x132>
			panic("Extra memory are wrongly allocated ... It's REplacement: extra/less frames have been FREED after the memory being scarce");
  800156:	83 ec 04             	sub    $0x4,%esp
  800159:	68 44 1d 80 00       	push   $0x801d44
  80015e:	6a 25                	push   $0x25
  800160:	68 0c 1d 80 00       	push   $0x801d0c
  800165:	e8 6b 01 00 00       	call   8002d5 <_panic>
	}

	env_sleep(80000);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	68 80 38 01 00       	push   $0x13880
  800172:	e8 e6 17 00 00       	call   80195d <env_sleep>
  800177:	83 c4 10             	add    $0x10,%esp
	// To ensure that the slave environments completed successfully
	cprintf("Congratulations!! test PAGE replacement [FREEING SCARCE MEMORY 2] is completed successfully.\n");
  80017a:	83 ec 0c             	sub    $0xc,%esp
  80017d:	68 c0 1d 80 00       	push   $0x801dc0
  800182:	e8 f0 03 00 00       	call   800577 <cprintf>
  800187:	83 c4 10             	add    $0x10,%esp
}
  80018a:	90                   	nop
  80018b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    

00800190 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800196:	e8 07 12 00 00       	call   8013a2 <sys_getenvindex>
  80019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80019e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a1:	89 d0                	mov    %edx,%eax
  8001a3:	c1 e0 03             	shl    $0x3,%eax
  8001a6:	01 d0                	add    %edx,%eax
  8001a8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001af:	01 c8                	add    %ecx,%eax
  8001b1:	01 c0                	add    %eax,%eax
  8001b3:	01 d0                	add    %edx,%eax
  8001b5:	01 c0                	add    %eax,%eax
  8001b7:	01 d0                	add    %edx,%eax
  8001b9:	89 c2                	mov    %eax,%edx
  8001bb:	c1 e2 05             	shl    $0x5,%edx
  8001be:	29 c2                	sub    %eax,%edx
  8001c0:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001c7:	89 c2                	mov    %eax,%edx
  8001c9:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001cf:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d9:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001df:	84 c0                	test   %al,%al
  8001e1:	74 0f                	je     8001f2 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e8:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001ed:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001f6:	7e 0a                	jle    800202 <libmain+0x72>
		binaryname = argv[0];
  8001f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001fb:	8b 00                	mov    (%eax),%eax
  8001fd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	ff 75 0c             	pushl  0xc(%ebp)
  800208:	ff 75 08             	pushl  0x8(%ebp)
  80020b:	e8 28 fe ff ff       	call   800038 <_main>
  800210:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800213:	e8 25 13 00 00       	call   80153d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	68 38 1e 80 00       	push   $0x801e38
  800220:	e8 52 03 00 00       	call   800577 <cprintf>
  800225:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800228:	a1 20 30 80 00       	mov    0x803020,%eax
  80022d:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800233:	a1 20 30 80 00       	mov    0x803020,%eax
  800238:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80023e:	83 ec 04             	sub    $0x4,%esp
  800241:	52                   	push   %edx
  800242:	50                   	push   %eax
  800243:	68 60 1e 80 00       	push   $0x801e60
  800248:	e8 2a 03 00 00       	call   800577 <cprintf>
  80024d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800250:	a1 20 30 80 00       	mov    0x803020,%eax
  800255:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80025b:	a1 20 30 80 00       	mov    0x803020,%eax
  800260:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800266:	83 ec 04             	sub    $0x4,%esp
  800269:	52                   	push   %edx
  80026a:	50                   	push   %eax
  80026b:	68 88 1e 80 00       	push   $0x801e88
  800270:	e8 02 03 00 00       	call   800577 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800278:	a1 20 30 80 00       	mov    0x803020,%eax
  80027d:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800283:	83 ec 08             	sub    $0x8,%esp
  800286:	50                   	push   %eax
  800287:	68 c9 1e 80 00       	push   $0x801ec9
  80028c:	e8 e6 02 00 00       	call   800577 <cprintf>
  800291:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	68 38 1e 80 00       	push   $0x801e38
  80029c:	e8 d6 02 00 00       	call   800577 <cprintf>
  8002a1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002a4:	e8 ae 12 00 00       	call   801557 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a9:	e8 19 00 00 00       	call   8002c7 <exit>
}
  8002ae:	90                   	nop
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8002b7:	83 ec 0c             	sub    $0xc,%esp
  8002ba:	6a 00                	push   $0x0
  8002bc:	e8 ad 10 00 00       	call   80136e <sys_env_destroy>
  8002c1:	83 c4 10             	add    $0x10,%esp
}
  8002c4:	90                   	nop
  8002c5:	c9                   	leave  
  8002c6:	c3                   	ret    

008002c7 <exit>:

void
exit(void)
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002cd:	e8 02 11 00 00       	call   8013d4 <sys_env_exit>
}
  8002d2:	90                   	nop
  8002d3:	c9                   	leave  
  8002d4:	c3                   	ret    

008002d5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002db:	8d 45 10             	lea    0x10(%ebp),%eax
  8002de:	83 c0 04             	add    $0x4,%eax
  8002e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002e4:	a1 18 31 80 00       	mov    0x803118,%eax
  8002e9:	85 c0                	test   %eax,%eax
  8002eb:	74 16                	je     800303 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002ed:	a1 18 31 80 00       	mov    0x803118,%eax
  8002f2:	83 ec 08             	sub    $0x8,%esp
  8002f5:	50                   	push   %eax
  8002f6:	68 e0 1e 80 00       	push   $0x801ee0
  8002fb:	e8 77 02 00 00       	call   800577 <cprintf>
  800300:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800303:	a1 00 30 80 00       	mov    0x803000,%eax
  800308:	ff 75 0c             	pushl  0xc(%ebp)
  80030b:	ff 75 08             	pushl  0x8(%ebp)
  80030e:	50                   	push   %eax
  80030f:	68 e5 1e 80 00       	push   $0x801ee5
  800314:	e8 5e 02 00 00       	call   800577 <cprintf>
  800319:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80031c:	8b 45 10             	mov    0x10(%ebp),%eax
  80031f:	83 ec 08             	sub    $0x8,%esp
  800322:	ff 75 f4             	pushl  -0xc(%ebp)
  800325:	50                   	push   %eax
  800326:	e8 e1 01 00 00       	call   80050c <vcprintf>
  80032b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	6a 00                	push   $0x0
  800333:	68 01 1f 80 00       	push   $0x801f01
  800338:	e8 cf 01 00 00       	call   80050c <vcprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800340:	e8 82 ff ff ff       	call   8002c7 <exit>

	// should not return here
	while (1) ;
  800345:	eb fe                	jmp    800345 <_panic+0x70>

00800347 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80034d:	a1 20 30 80 00       	mov    0x803020,%eax
  800352:	8b 50 74             	mov    0x74(%eax),%edx
  800355:	8b 45 0c             	mov    0xc(%ebp),%eax
  800358:	39 c2                	cmp    %eax,%edx
  80035a:	74 14                	je     800370 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80035c:	83 ec 04             	sub    $0x4,%esp
  80035f:	68 04 1f 80 00       	push   $0x801f04
  800364:	6a 26                	push   $0x26
  800366:	68 50 1f 80 00       	push   $0x801f50
  80036b:	e8 65 ff ff ff       	call   8002d5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800370:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800377:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80037e:	e9 b6 00 00 00       	jmp    800439 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800386:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038d:	8b 45 08             	mov    0x8(%ebp),%eax
  800390:	01 d0                	add    %edx,%eax
  800392:	8b 00                	mov    (%eax),%eax
  800394:	85 c0                	test   %eax,%eax
  800396:	75 08                	jne    8003a0 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800398:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80039b:	e9 96 00 00 00       	jmp    800436 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8003a0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ae:	eb 5d                	jmp    80040d <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b5:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003be:	c1 e2 04             	shl    $0x4,%edx
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	8a 40 04             	mov    0x4(%eax),%al
  8003c6:	84 c0                	test   %al,%al
  8003c8:	75 40                	jne    80040a <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cf:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d8:	c1 e2 04             	shl    $0x4,%edx
  8003db:	01 d0                	add    %edx,%eax
  8003dd:	8b 00                	mov    (%eax),%eax
  8003df:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ea:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	01 c8                	add    %ecx,%eax
  8003fb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003fd:	39 c2                	cmp    %eax,%edx
  8003ff:	75 09                	jne    80040a <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800401:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800408:	eb 12                	jmp    80041c <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040a:	ff 45 e8             	incl   -0x18(%ebp)
  80040d:	a1 20 30 80 00       	mov    0x803020,%eax
  800412:	8b 50 74             	mov    0x74(%eax),%edx
  800415:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800418:	39 c2                	cmp    %eax,%edx
  80041a:	77 94                	ja     8003b0 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80041c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800420:	75 14                	jne    800436 <CheckWSWithoutLastIndex+0xef>
			panic(
  800422:	83 ec 04             	sub    $0x4,%esp
  800425:	68 5c 1f 80 00       	push   $0x801f5c
  80042a:	6a 3a                	push   $0x3a
  80042c:	68 50 1f 80 00       	push   $0x801f50
  800431:	e8 9f fe ff ff       	call   8002d5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800436:	ff 45 f0             	incl   -0x10(%ebp)
  800439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043f:	0f 8c 3e ff ff ff    	jl     800383 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800445:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80044c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800453:	eb 20                	jmp    800475 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800455:	a1 20 30 80 00       	mov    0x803020,%eax
  80045a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800460:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800463:	c1 e2 04             	shl    $0x4,%edx
  800466:	01 d0                	add    %edx,%eax
  800468:	8a 40 04             	mov    0x4(%eax),%al
  80046b:	3c 01                	cmp    $0x1,%al
  80046d:	75 03                	jne    800472 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80046f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800472:	ff 45 e0             	incl   -0x20(%ebp)
  800475:	a1 20 30 80 00       	mov    0x803020,%eax
  80047a:	8b 50 74             	mov    0x74(%eax),%edx
  80047d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800480:	39 c2                	cmp    %eax,%edx
  800482:	77 d1                	ja     800455 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800487:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80048a:	74 14                	je     8004a0 <CheckWSWithoutLastIndex+0x159>
		panic(
  80048c:	83 ec 04             	sub    $0x4,%esp
  80048f:	68 b0 1f 80 00       	push   $0x801fb0
  800494:	6a 44                	push   $0x44
  800496:	68 50 1f 80 00       	push   $0x801f50
  80049b:	e8 35 fe ff ff       	call   8002d5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004a0:	90                   	nop
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

008004a3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ac:	8b 00                	mov    (%eax),%eax
  8004ae:	8d 48 01             	lea    0x1(%eax),%ecx
  8004b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b4:	89 0a                	mov    %ecx,(%edx)
  8004b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b9:	88 d1                	mov    %dl,%cl
  8004bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004be:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004cc:	75 2c                	jne    8004fa <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004ce:	a0 24 30 80 00       	mov    0x803024,%al
  8004d3:	0f b6 c0             	movzbl %al,%eax
  8004d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d9:	8b 12                	mov    (%edx),%edx
  8004db:	89 d1                	mov    %edx,%ecx
  8004dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e0:	83 c2 08             	add    $0x8,%edx
  8004e3:	83 ec 04             	sub    $0x4,%esp
  8004e6:	50                   	push   %eax
  8004e7:	51                   	push   %ecx
  8004e8:	52                   	push   %edx
  8004e9:	e8 3e 0e 00 00       	call   80132c <sys_cputs>
  8004ee:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	8b 40 04             	mov    0x4(%eax),%eax
  800500:	8d 50 01             	lea    0x1(%eax),%edx
  800503:	8b 45 0c             	mov    0xc(%ebp),%eax
  800506:	89 50 04             	mov    %edx,0x4(%eax)
}
  800509:	90                   	nop
  80050a:	c9                   	leave  
  80050b:	c3                   	ret    

0080050c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800515:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80051c:	00 00 00 
	b.cnt = 0;
  80051f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800526:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800529:	ff 75 0c             	pushl  0xc(%ebp)
  80052c:	ff 75 08             	pushl  0x8(%ebp)
  80052f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800535:	50                   	push   %eax
  800536:	68 a3 04 80 00       	push   $0x8004a3
  80053b:	e8 11 02 00 00       	call   800751 <vprintfmt>
  800540:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800543:	a0 24 30 80 00       	mov    0x803024,%al
  800548:	0f b6 c0             	movzbl %al,%eax
  80054b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800551:	83 ec 04             	sub    $0x4,%esp
  800554:	50                   	push   %eax
  800555:	52                   	push   %edx
  800556:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055c:	83 c0 08             	add    $0x8,%eax
  80055f:	50                   	push   %eax
  800560:	e8 c7 0d 00 00       	call   80132c <sys_cputs>
  800565:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800568:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80056f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <cprintf>:

int cprintf(const char *fmt, ...) {
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80057d:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800584:	8d 45 0c             	lea    0xc(%ebp),%eax
  800587:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	ff 75 f4             	pushl  -0xc(%ebp)
  800593:	50                   	push   %eax
  800594:	e8 73 ff ff ff       	call   80050c <vcprintf>
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80059f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005aa:	e8 8e 0f 00 00       	call   80153d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005af:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8005be:	50                   	push   %eax
  8005bf:	e8 48 ff ff ff       	call   80050c <vcprintf>
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005ca:	e8 88 0f 00 00       	call   801557 <sys_enable_interrupt>
	return cnt;
  8005cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	53                   	push   %ebx
  8005d8:	83 ec 14             	sub    $0x14,%esp
  8005db:	8b 45 10             	mov    0x10(%ebp),%eax
  8005de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ef:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f2:	77 55                	ja     800649 <printnum+0x75>
  8005f4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f7:	72 05                	jb     8005fe <printnum+0x2a>
  8005f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005fc:	77 4b                	ja     800649 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005fe:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800601:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800604:	8b 45 18             	mov    0x18(%ebp),%eax
  800607:	ba 00 00 00 00       	mov    $0x0,%edx
  80060c:	52                   	push   %edx
  80060d:	50                   	push   %eax
  80060e:	ff 75 f4             	pushl  -0xc(%ebp)
  800611:	ff 75 f0             	pushl  -0x10(%ebp)
  800614:	e8 fb 13 00 00       	call   801a14 <__udivdi3>
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	83 ec 04             	sub    $0x4,%esp
  80061f:	ff 75 20             	pushl  0x20(%ebp)
  800622:	53                   	push   %ebx
  800623:	ff 75 18             	pushl  0x18(%ebp)
  800626:	52                   	push   %edx
  800627:	50                   	push   %eax
  800628:	ff 75 0c             	pushl  0xc(%ebp)
  80062b:	ff 75 08             	pushl  0x8(%ebp)
  80062e:	e8 a1 ff ff ff       	call   8005d4 <printnum>
  800633:	83 c4 20             	add    $0x20,%esp
  800636:	eb 1a                	jmp    800652 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 0c             	pushl  0xc(%ebp)
  80063e:	ff 75 20             	pushl  0x20(%ebp)
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	ff d0                	call   *%eax
  800646:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800649:	ff 4d 1c             	decl   0x1c(%ebp)
  80064c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800650:	7f e6                	jg     800638 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800652:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800655:	bb 00 00 00 00       	mov    $0x0,%ebx
  80065a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80065d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800660:	53                   	push   %ebx
  800661:	51                   	push   %ecx
  800662:	52                   	push   %edx
  800663:	50                   	push   %eax
  800664:	e8 bb 14 00 00       	call   801b24 <__umoddi3>
  800669:	83 c4 10             	add    $0x10,%esp
  80066c:	05 14 22 80 00       	add    $0x802214,%eax
  800671:	8a 00                	mov    (%eax),%al
  800673:	0f be c0             	movsbl %al,%eax
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	ff 75 0c             	pushl  0xc(%ebp)
  80067c:	50                   	push   %eax
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	ff d0                	call   *%eax
  800682:	83 c4 10             	add    $0x10,%esp
}
  800685:	90                   	nop
  800686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800689:	c9                   	leave  
  80068a:	c3                   	ret    

0080068b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80068e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800692:	7e 1c                	jle    8006b0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	8d 50 08             	lea    0x8(%eax),%edx
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	89 10                	mov    %edx,(%eax)
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	83 e8 08             	sub    $0x8,%eax
  8006a9:	8b 50 04             	mov    0x4(%eax),%edx
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	eb 40                	jmp    8006f0 <getuint+0x65>
	else if (lflag)
  8006b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b4:	74 1e                	je     8006d4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	8d 50 04             	lea    0x4(%eax),%edx
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	89 10                	mov    %edx,(%eax)
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	83 e8 04             	sub    $0x4,%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d2:	eb 1c                	jmp    8006f0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	8d 50 04             	lea    0x4(%eax),%edx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	89 10                	mov    %edx,(%eax)
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	83 e8 04             	sub    $0x4,%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006f0:	5d                   	pop    %ebp
  8006f1:	c3                   	ret    

008006f2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006f2:	55                   	push   %ebp
  8006f3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f9:	7e 1c                	jle    800717 <getint+0x25>
		return va_arg(*ap, long long);
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	8d 50 08             	lea    0x8(%eax),%edx
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	89 10                	mov    %edx,(%eax)
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	83 e8 08             	sub    $0x8,%eax
  800710:	8b 50 04             	mov    0x4(%eax),%edx
  800713:	8b 00                	mov    (%eax),%eax
  800715:	eb 38                	jmp    80074f <getint+0x5d>
	else if (lflag)
  800717:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80071b:	74 1a                	je     800737 <getint+0x45>
		return va_arg(*ap, long);
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	8d 50 04             	lea    0x4(%eax),%edx
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	89 10                	mov    %edx,(%eax)
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	83 e8 04             	sub    $0x4,%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	99                   	cltd   
  800735:	eb 18                	jmp    80074f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	8d 50 04             	lea    0x4(%eax),%edx
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	89 10                	mov    %edx,(%eax)
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	83 e8 04             	sub    $0x4,%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	99                   	cltd   
}
  80074f:	5d                   	pop    %ebp
  800750:	c3                   	ret    

00800751 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	56                   	push   %esi
  800755:	53                   	push   %ebx
  800756:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800759:	eb 17                	jmp    800772 <vprintfmt+0x21>
			if (ch == '\0')
  80075b:	85 db                	test   %ebx,%ebx
  80075d:	0f 84 af 03 00 00    	je     800b12 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	53                   	push   %ebx
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	ff d0                	call   *%eax
  80076f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800772:	8b 45 10             	mov    0x10(%ebp),%eax
  800775:	8d 50 01             	lea    0x1(%eax),%edx
  800778:	89 55 10             	mov    %edx,0x10(%ebp)
  80077b:	8a 00                	mov    (%eax),%al
  80077d:	0f b6 d8             	movzbl %al,%ebx
  800780:	83 fb 25             	cmp    $0x25,%ebx
  800783:	75 d6                	jne    80075b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800785:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800789:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800790:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800797:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80079e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a8:	8d 50 01             	lea    0x1(%eax),%edx
  8007ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ae:	8a 00                	mov    (%eax),%al
  8007b0:	0f b6 d8             	movzbl %al,%ebx
  8007b3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007b6:	83 f8 55             	cmp    $0x55,%eax
  8007b9:	0f 87 2b 03 00 00    	ja     800aea <vprintfmt+0x399>
  8007bf:	8b 04 85 38 22 80 00 	mov    0x802238(,%eax,4),%eax
  8007c6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007c8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007cc:	eb d7                	jmp    8007a5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007ce:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007d2:	eb d1                	jmp    8007a5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007de:	89 d0                	mov    %edx,%eax
  8007e0:	c1 e0 02             	shl    $0x2,%eax
  8007e3:	01 d0                	add    %edx,%eax
  8007e5:	01 c0                	add    %eax,%eax
  8007e7:	01 d8                	add    %ebx,%eax
  8007e9:	83 e8 30             	sub    $0x30,%eax
  8007ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f2:	8a 00                	mov    (%eax),%al
  8007f4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007f7:	83 fb 2f             	cmp    $0x2f,%ebx
  8007fa:	7e 3e                	jle    80083a <vprintfmt+0xe9>
  8007fc:	83 fb 39             	cmp    $0x39,%ebx
  8007ff:	7f 39                	jg     80083a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800801:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800804:	eb d5                	jmp    8007db <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	83 c0 04             	add    $0x4,%eax
  80080c:	89 45 14             	mov    %eax,0x14(%ebp)
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	83 e8 04             	sub    $0x4,%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80081a:	eb 1f                	jmp    80083b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80081c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800820:	79 83                	jns    8007a5 <vprintfmt+0x54>
				width = 0;
  800822:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800829:	e9 77 ff ff ff       	jmp    8007a5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80082e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800835:	e9 6b ff ff ff       	jmp    8007a5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80083a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80083b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80083f:	0f 89 60 ff ff ff    	jns    8007a5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800845:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800848:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80084b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800852:	e9 4e ff ff ff       	jmp    8007a5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800857:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80085a:	e9 46 ff ff ff       	jmp    8007a5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	83 c0 04             	add    $0x4,%eax
  800865:	89 45 14             	mov    %eax,0x14(%ebp)
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	83 e8 04             	sub    $0x4,%eax
  80086e:	8b 00                	mov    (%eax),%eax
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	50                   	push   %eax
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	ff d0                	call   *%eax
  80087c:	83 c4 10             	add    $0x10,%esp
			break;
  80087f:	e9 89 02 00 00       	jmp    800b0d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	83 c0 04             	add    $0x4,%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	83 e8 04             	sub    $0x4,%eax
  800893:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800895:	85 db                	test   %ebx,%ebx
  800897:	79 02                	jns    80089b <vprintfmt+0x14a>
				err = -err;
  800899:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80089b:	83 fb 64             	cmp    $0x64,%ebx
  80089e:	7f 0b                	jg     8008ab <vprintfmt+0x15a>
  8008a0:	8b 34 9d 80 20 80 00 	mov    0x802080(,%ebx,4),%esi
  8008a7:	85 f6                	test   %esi,%esi
  8008a9:	75 19                	jne    8008c4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008ab:	53                   	push   %ebx
  8008ac:	68 25 22 80 00       	push   $0x802225
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	ff 75 08             	pushl  0x8(%ebp)
  8008b7:	e8 5e 02 00 00       	call   800b1a <printfmt>
  8008bc:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008bf:	e9 49 02 00 00       	jmp    800b0d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008c4:	56                   	push   %esi
  8008c5:	68 2e 22 80 00       	push   $0x80222e
  8008ca:	ff 75 0c             	pushl  0xc(%ebp)
  8008cd:	ff 75 08             	pushl  0x8(%ebp)
  8008d0:	e8 45 02 00 00       	call   800b1a <printfmt>
  8008d5:	83 c4 10             	add    $0x10,%esp
			break;
  8008d8:	e9 30 02 00 00       	jmp    800b0d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e0:	83 c0 04             	add    $0x4,%eax
  8008e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e9:	83 e8 04             	sub    $0x4,%eax
  8008ec:	8b 30                	mov    (%eax),%esi
  8008ee:	85 f6                	test   %esi,%esi
  8008f0:	75 05                	jne    8008f7 <vprintfmt+0x1a6>
				p = "(null)";
  8008f2:	be 31 22 80 00       	mov    $0x802231,%esi
			if (width > 0 && padc != '-')
  8008f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fb:	7e 6d                	jle    80096a <vprintfmt+0x219>
  8008fd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800901:	74 67                	je     80096a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800903:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	50                   	push   %eax
  80090a:	56                   	push   %esi
  80090b:	e8 0c 03 00 00       	call   800c1c <strnlen>
  800910:	83 c4 10             	add    $0x10,%esp
  800913:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800916:	eb 16                	jmp    80092e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800918:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80091c:	83 ec 08             	sub    $0x8,%esp
  80091f:	ff 75 0c             	pushl  0xc(%ebp)
  800922:	50                   	push   %eax
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	ff d0                	call   *%eax
  800928:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80092b:	ff 4d e4             	decl   -0x1c(%ebp)
  80092e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800932:	7f e4                	jg     800918 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800934:	eb 34                	jmp    80096a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800936:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80093a:	74 1c                	je     800958 <vprintfmt+0x207>
  80093c:	83 fb 1f             	cmp    $0x1f,%ebx
  80093f:	7e 05                	jle    800946 <vprintfmt+0x1f5>
  800941:	83 fb 7e             	cmp    $0x7e,%ebx
  800944:	7e 12                	jle    800958 <vprintfmt+0x207>
					putch('?', putdat);
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	ff 75 0c             	pushl  0xc(%ebp)
  80094c:	6a 3f                	push   $0x3f
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
  800956:	eb 0f                	jmp    800967 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	ff 75 0c             	pushl  0xc(%ebp)
  80095e:	53                   	push   %ebx
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	ff d0                	call   *%eax
  800964:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800967:	ff 4d e4             	decl   -0x1c(%ebp)
  80096a:	89 f0                	mov    %esi,%eax
  80096c:	8d 70 01             	lea    0x1(%eax),%esi
  80096f:	8a 00                	mov    (%eax),%al
  800971:	0f be d8             	movsbl %al,%ebx
  800974:	85 db                	test   %ebx,%ebx
  800976:	74 24                	je     80099c <vprintfmt+0x24b>
  800978:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097c:	78 b8                	js     800936 <vprintfmt+0x1e5>
  80097e:	ff 4d e0             	decl   -0x20(%ebp)
  800981:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800985:	79 af                	jns    800936 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800987:	eb 13                	jmp    80099c <vprintfmt+0x24b>
				putch(' ', putdat);
  800989:	83 ec 08             	sub    $0x8,%esp
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	6a 20                	push   $0x20
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	ff d0                	call   *%eax
  800996:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800999:	ff 4d e4             	decl   -0x1c(%ebp)
  80099c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a0:	7f e7                	jg     800989 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009a2:	e9 66 01 00 00       	jmp    800b0d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ad:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b0:	50                   	push   %eax
  8009b1:	e8 3c fd ff ff       	call   8006f2 <getint>
  8009b6:	83 c4 10             	add    $0x10,%esp
  8009b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c5:	85 d2                	test   %edx,%edx
  8009c7:	79 23                	jns    8009ec <vprintfmt+0x29b>
				putch('-', putdat);
  8009c9:	83 ec 08             	sub    $0x8,%esp
  8009cc:	ff 75 0c             	pushl  0xc(%ebp)
  8009cf:	6a 2d                	push   $0x2d
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009df:	f7 d8                	neg    %eax
  8009e1:	83 d2 00             	adc    $0x0,%edx
  8009e4:	f7 da                	neg    %edx
  8009e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009f3:	e9 bc 00 00 00       	jmp    800ab4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 e8             	pushl  -0x18(%ebp)
  8009fe:	8d 45 14             	lea    0x14(%ebp),%eax
  800a01:	50                   	push   %eax
  800a02:	e8 84 fc ff ff       	call   80068b <getuint>
  800a07:	83 c4 10             	add    $0x10,%esp
  800a0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a10:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a17:	e9 98 00 00 00       	jmp    800ab4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a1c:	83 ec 08             	sub    $0x8,%esp
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	6a 58                	push   $0x58
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	ff d0                	call   *%eax
  800a29:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	ff 75 0c             	pushl  0xc(%ebp)
  800a32:	6a 58                	push   $0x58
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	ff d0                	call   *%eax
  800a39:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a3c:	83 ec 08             	sub    $0x8,%esp
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	6a 58                	push   $0x58
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	ff d0                	call   *%eax
  800a49:	83 c4 10             	add    $0x10,%esp
			break;
  800a4c:	e9 bc 00 00 00       	jmp    800b0d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 0c             	pushl  0xc(%ebp)
  800a57:	6a 30                	push   $0x30
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	ff d0                	call   *%eax
  800a5e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	ff 75 0c             	pushl  0xc(%ebp)
  800a67:	6a 78                	push   $0x78
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	ff d0                	call   *%eax
  800a6e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 c0 04             	add    $0x4,%eax
  800a77:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	83 e8 04             	sub    $0x4,%eax
  800a80:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a8c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a93:	eb 1f                	jmp    800ab4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 e8             	pushl  -0x18(%ebp)
  800a9b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a9e:	50                   	push   %eax
  800a9f:	e8 e7 fb ff ff       	call   80068b <getuint>
  800aa4:	83 c4 10             	add    $0x10,%esp
  800aa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aaa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aad:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ab4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800abb:	83 ec 04             	sub    $0x4,%esp
  800abe:	52                   	push   %edx
  800abf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ac2:	50                   	push   %eax
  800ac3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac6:	ff 75 f0             	pushl  -0x10(%ebp)
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	ff 75 08             	pushl  0x8(%ebp)
  800acf:	e8 00 fb ff ff       	call   8005d4 <printnum>
  800ad4:	83 c4 20             	add    $0x20,%esp
			break;
  800ad7:	eb 34                	jmp    800b0d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	53                   	push   %ebx
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	ff d0                	call   *%eax
  800ae5:	83 c4 10             	add    $0x10,%esp
			break;
  800ae8:	eb 23                	jmp    800b0d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	ff 75 0c             	pushl  0xc(%ebp)
  800af0:	6a 25                	push   $0x25
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	ff d0                	call   *%eax
  800af7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800afa:	ff 4d 10             	decl   0x10(%ebp)
  800afd:	eb 03                	jmp    800b02 <vprintfmt+0x3b1>
  800aff:	ff 4d 10             	decl   0x10(%ebp)
  800b02:	8b 45 10             	mov    0x10(%ebp),%eax
  800b05:	48                   	dec    %eax
  800b06:	8a 00                	mov    (%eax),%al
  800b08:	3c 25                	cmp    $0x25,%al
  800b0a:	75 f3                	jne    800aff <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b0c:	90                   	nop
		}
	}
  800b0d:	e9 47 fc ff ff       	jmp    800759 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b12:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b16:	5b                   	pop    %ebx
  800b17:	5e                   	pop    %esi
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    

00800b1a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b20:	8d 45 10             	lea    0x10(%ebp),%eax
  800b23:	83 c0 04             	add    $0x4,%eax
  800b26:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b29:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b2f:	50                   	push   %eax
  800b30:	ff 75 0c             	pushl  0xc(%ebp)
  800b33:	ff 75 08             	pushl  0x8(%ebp)
  800b36:	e8 16 fc ff ff       	call   800751 <vprintfmt>
  800b3b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b3e:	90                   	nop
  800b3f:	c9                   	leave  
  800b40:	c3                   	ret    

00800b41 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b47:	8b 40 08             	mov    0x8(%eax),%eax
  800b4a:	8d 50 01             	lea    0x1(%eax),%edx
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b56:	8b 10                	mov    (%eax),%edx
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	8b 40 04             	mov    0x4(%eax),%eax
  800b5e:	39 c2                	cmp    %eax,%edx
  800b60:	73 12                	jae    800b74 <sprintputch+0x33>
		*b->buf++ = ch;
  800b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	8d 48 01             	lea    0x1(%eax),%ecx
  800b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6d:	89 0a                	mov    %ecx,(%edx)
  800b6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b72:	88 10                	mov    %dl,(%eax)
}
  800b74:	90                   	nop
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b86:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	01 d0                	add    %edx,%eax
  800b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b9c:	74 06                	je     800ba4 <vsnprintf+0x2d>
  800b9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba2:	7f 07                	jg     800bab <vsnprintf+0x34>
		return -E_INVAL;
  800ba4:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba9:	eb 20                	jmp    800bcb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bab:	ff 75 14             	pushl  0x14(%ebp)
  800bae:	ff 75 10             	pushl  0x10(%ebp)
  800bb1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb4:	50                   	push   %eax
  800bb5:	68 41 0b 80 00       	push   $0x800b41
  800bba:	e8 92 fb ff ff       	call   800751 <vprintfmt>
  800bbf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bcb:	c9                   	leave  
  800bcc:	c3                   	ret    

00800bcd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd3:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd6:	83 c0 04             	add    $0x4,%eax
  800bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdf:	ff 75 f4             	pushl  -0xc(%ebp)
  800be2:	50                   	push   %eax
  800be3:	ff 75 0c             	pushl  0xc(%ebp)
  800be6:	ff 75 08             	pushl  0x8(%ebp)
  800be9:	e8 89 ff ff ff       	call   800b77 <vsnprintf>
  800bee:	83 c4 10             	add    $0x10,%esp
  800bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf7:	c9                   	leave  
  800bf8:	c3                   	ret    

00800bf9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c06:	eb 06                	jmp    800c0e <strlen+0x15>
		n++;
  800c08:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0b:	ff 45 08             	incl   0x8(%ebp)
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	84 c0                	test   %al,%al
  800c15:	75 f1                	jne    800c08 <strlen+0xf>
		n++;
	return n;
  800c17:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c29:	eb 09                	jmp    800c34 <strnlen+0x18>
		n++;
  800c2b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2e:	ff 45 08             	incl   0x8(%ebp)
  800c31:	ff 4d 0c             	decl   0xc(%ebp)
  800c34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c38:	74 09                	je     800c43 <strnlen+0x27>
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8a 00                	mov    (%eax),%al
  800c3f:	84 c0                	test   %al,%al
  800c41:	75 e8                	jne    800c2b <strnlen+0xf>
		n++;
	return n;
  800c43:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c46:	c9                   	leave  
  800c47:	c3                   	ret    

00800c48 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c54:	90                   	nop
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8d 50 01             	lea    0x1(%eax),%edx
  800c5b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c61:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c64:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c67:	8a 12                	mov    (%edx),%dl
  800c69:	88 10                	mov    %dl,(%eax)
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	84 c0                	test   %al,%al
  800c6f:	75 e4                	jne    800c55 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c89:	eb 1f                	jmp    800caa <strncpy+0x34>
		*dst++ = *src;
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8d 50 01             	lea    0x1(%eax),%edx
  800c91:	89 55 08             	mov    %edx,0x8(%ebp)
  800c94:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c97:	8a 12                	mov    (%edx),%dl
  800c99:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8a 00                	mov    (%eax),%al
  800ca0:	84 c0                	test   %al,%al
  800ca2:	74 03                	je     800ca7 <strncpy+0x31>
			src++;
  800ca4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca7:	ff 45 fc             	incl   -0x4(%ebp)
  800caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cad:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cb0:	72 d9                	jb     800c8b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cb5:	c9                   	leave  
  800cb6:	c3                   	ret    

00800cb7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc7:	74 30                	je     800cf9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cc9:	eb 16                	jmp    800ce1 <strlcpy+0x2a>
			*dst++ = *src++;
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	8d 50 01             	lea    0x1(%eax),%edx
  800cd1:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cda:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cdd:	8a 12                	mov    (%edx),%dl
  800cdf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ce1:	ff 4d 10             	decl   0x10(%ebp)
  800ce4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce8:	74 09                	je     800cf3 <strlcpy+0x3c>
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	84 c0                	test   %al,%al
  800cf1:	75 d8                	jne    800ccb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cff:	29 c2                	sub    %eax,%edx
  800d01:	89 d0                	mov    %edx,%eax
}
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d08:	eb 06                	jmp    800d10 <strcmp+0xb>
		p++, q++;
  800d0a:	ff 45 08             	incl   0x8(%ebp)
  800d0d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	74 0e                	je     800d27 <strcmp+0x22>
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 10                	mov    (%eax),%dl
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	38 c2                	cmp    %al,%dl
  800d25:	74 e3                	je     800d0a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 00                	mov    (%eax),%al
  800d2c:	0f b6 d0             	movzbl %al,%edx
  800d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	0f b6 c0             	movzbl %al,%eax
  800d37:	29 c2                	sub    %eax,%edx
  800d39:	89 d0                	mov    %edx,%eax
}
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d40:	eb 09                	jmp    800d4b <strncmp+0xe>
		n--, p++, q++;
  800d42:	ff 4d 10             	decl   0x10(%ebp)
  800d45:	ff 45 08             	incl   0x8(%ebp)
  800d48:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4f:	74 17                	je     800d68 <strncmp+0x2b>
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	84 c0                	test   %al,%al
  800d58:	74 0e                	je     800d68 <strncmp+0x2b>
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8a 10                	mov    (%eax),%dl
  800d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	38 c2                	cmp    %al,%dl
  800d66:	74 da                	je     800d42 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6c:	75 07                	jne    800d75 <strncmp+0x38>
		return 0;
  800d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d73:	eb 14                	jmp    800d89 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	0f b6 d0             	movzbl %al,%edx
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	0f b6 c0             	movzbl %al,%eax
  800d85:	29 c2                	sub    %eax,%edx
  800d87:	89 d0                	mov    %edx,%eax
}
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    

00800d8b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	83 ec 04             	sub    $0x4,%esp
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d97:	eb 12                	jmp    800dab <strchr+0x20>
		if (*s == c)
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da1:	75 05                	jne    800da8 <strchr+0x1d>
			return (char *) s;
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	eb 11                	jmp    800db9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	84 c0                	test   %al,%al
  800db2:	75 e5                	jne    800d99 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800db4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db9:	c9                   	leave  
  800dba:	c3                   	ret    

00800dbb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	83 ec 04             	sub    $0x4,%esp
  800dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc7:	eb 0d                	jmp    800dd6 <strfind+0x1b>
		if (*s == c)
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd1:	74 0e                	je     800de1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dd3:	ff 45 08             	incl   0x8(%ebp)
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	84 c0                	test   %al,%al
  800ddd:	75 ea                	jne    800dc9 <strfind+0xe>
  800ddf:	eb 01                	jmp    800de2 <strfind+0x27>
		if (*s == c)
			break;
  800de1:	90                   	nop
	return (char *) s;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de5:	c9                   	leave  
  800de6:	c3                   	ret    

00800de7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800df3:	8b 45 10             	mov    0x10(%ebp),%eax
  800df6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800df9:	eb 0e                	jmp    800e09 <memset+0x22>
		*p++ = c;
  800dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfe:	8d 50 01             	lea    0x1(%eax),%edx
  800e01:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e07:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e09:	ff 4d f8             	decl   -0x8(%ebp)
  800e0c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e10:	79 e9                	jns    800dfb <memset+0x14>
		*p++ = c;

	return v;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e29:	eb 16                	jmp    800e41 <memcpy+0x2a>
		*d++ = *s++;
  800e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2e:	8d 50 01             	lea    0x1(%eax),%edx
  800e31:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e34:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e37:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e3d:	8a 12                	mov    (%edx),%dl
  800e3f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e41:	8b 45 10             	mov    0x10(%ebp),%eax
  800e44:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e47:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4a:	85 c0                	test   %eax,%eax
  800e4c:	75 dd                	jne    800e2b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e51:	c9                   	leave  
  800e52:	c3                   	ret    

00800e53 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e6b:	73 50                	jae    800ebd <memmove+0x6a>
  800e6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e70:	8b 45 10             	mov    0x10(%ebp),%eax
  800e73:	01 d0                	add    %edx,%eax
  800e75:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e78:	76 43                	jbe    800ebd <memmove+0x6a>
		s += n;
  800e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e80:	8b 45 10             	mov    0x10(%ebp),%eax
  800e83:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e86:	eb 10                	jmp    800e98 <memmove+0x45>
			*--d = *--s;
  800e88:	ff 4d f8             	decl   -0x8(%ebp)
  800e8b:	ff 4d fc             	decl   -0x4(%ebp)
  800e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e91:	8a 10                	mov    (%eax),%dl
  800e93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e96:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e98:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e9e:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea1:	85 c0                	test   %eax,%eax
  800ea3:	75 e3                	jne    800e88 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ea5:	eb 23                	jmp    800eca <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8d 50 01             	lea    0x1(%eax),%edx
  800ead:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eb3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb9:	8a 12                	mov    (%edx),%dl
  800ebb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec6:	85 c0                	test   %eax,%eax
  800ec8:	75 dd                	jne    800ea7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ede:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ee1:	eb 2a                	jmp    800f0d <memcmp+0x3e>
		if (*s1 != *s2)
  800ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee6:	8a 10                	mov    (%eax),%dl
  800ee8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	38 c2                	cmp    %al,%dl
  800eef:	74 16                	je     800f07 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 00                	mov    (%eax),%al
  800ef6:	0f b6 d0             	movzbl %al,%edx
  800ef9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	0f b6 c0             	movzbl %al,%eax
  800f01:	29 c2                	sub    %eax,%edx
  800f03:	89 d0                	mov    %edx,%eax
  800f05:	eb 18                	jmp    800f1f <memcmp+0x50>
		s1++, s2++;
  800f07:	ff 45 fc             	incl   -0x4(%ebp)
  800f0a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f10:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f13:	89 55 10             	mov    %edx,0x10(%ebp)
  800f16:	85 c0                	test   %eax,%eax
  800f18:	75 c9                	jne    800ee3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f27:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2d:	01 d0                	add    %edx,%eax
  800f2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f32:	eb 15                	jmp    800f49 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	0f b6 d0             	movzbl %al,%edx
  800f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3f:	0f b6 c0             	movzbl %al,%eax
  800f42:	39 c2                	cmp    %eax,%edx
  800f44:	74 0d                	je     800f53 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f46:	ff 45 08             	incl   0x8(%ebp)
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f4f:	72 e3                	jb     800f34 <memfind+0x13>
  800f51:	eb 01                	jmp    800f54 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f53:	90                   	nop
	return (void *) s;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f57:	c9                   	leave  
  800f58:	c3                   	ret    

00800f59 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f5f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f66:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6d:	eb 03                	jmp    800f72 <strtol+0x19>
		s++;
  800f6f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	3c 20                	cmp    $0x20,%al
  800f79:	74 f4                	je     800f6f <strtol+0x16>
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	3c 09                	cmp    $0x9,%al
  800f82:	74 eb                	je     800f6f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	3c 2b                	cmp    $0x2b,%al
  800f8b:	75 05                	jne    800f92 <strtol+0x39>
		s++;
  800f8d:	ff 45 08             	incl   0x8(%ebp)
  800f90:	eb 13                	jmp    800fa5 <strtol+0x4c>
	else if (*s == '-')
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	3c 2d                	cmp    $0x2d,%al
  800f99:	75 0a                	jne    800fa5 <strtol+0x4c>
		s++, neg = 1;
  800f9b:	ff 45 08             	incl   0x8(%ebp)
  800f9e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fa5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa9:	74 06                	je     800fb1 <strtol+0x58>
  800fab:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800faf:	75 20                	jne    800fd1 <strtol+0x78>
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	3c 30                	cmp    $0x30,%al
  800fb8:	75 17                	jne    800fd1 <strtol+0x78>
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	40                   	inc    %eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	3c 78                	cmp    $0x78,%al
  800fc2:	75 0d                	jne    800fd1 <strtol+0x78>
		s += 2, base = 16;
  800fc4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fc8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fcf:	eb 28                	jmp    800ff9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd5:	75 15                	jne    800fec <strtol+0x93>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 30                	cmp    $0x30,%al
  800fde:	75 0c                	jne    800fec <strtol+0x93>
		s++, base = 8;
  800fe0:	ff 45 08             	incl   0x8(%ebp)
  800fe3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fea:	eb 0d                	jmp    800ff9 <strtol+0xa0>
	else if (base == 0)
  800fec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff0:	75 07                	jne    800ff9 <strtol+0xa0>
		base = 10;
  800ff2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 2f                	cmp    $0x2f,%al
  801000:	7e 19                	jle    80101b <strtol+0xc2>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 39                	cmp    $0x39,%al
  801009:	7f 10                	jg     80101b <strtol+0xc2>
			dig = *s - '0';
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	0f be c0             	movsbl %al,%eax
  801013:	83 e8 30             	sub    $0x30,%eax
  801016:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801019:	eb 42                	jmp    80105d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	3c 60                	cmp    $0x60,%al
  801022:	7e 19                	jle    80103d <strtol+0xe4>
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	3c 7a                	cmp    $0x7a,%al
  80102b:	7f 10                	jg     80103d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	0f be c0             	movsbl %al,%eax
  801035:	83 e8 57             	sub    $0x57,%eax
  801038:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103b:	eb 20                	jmp    80105d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	3c 40                	cmp    $0x40,%al
  801044:	7e 39                	jle    80107f <strtol+0x126>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	3c 5a                	cmp    $0x5a,%al
  80104d:	7f 30                	jg     80107f <strtol+0x126>
			dig = *s - 'A' + 10;
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	8a 00                	mov    (%eax),%al
  801054:	0f be c0             	movsbl %al,%eax
  801057:	83 e8 37             	sub    $0x37,%eax
  80105a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80105d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801060:	3b 45 10             	cmp    0x10(%ebp),%eax
  801063:	7d 19                	jge    80107e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801065:	ff 45 08             	incl   0x8(%ebp)
  801068:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80106f:	89 c2                	mov    %eax,%edx
  801071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801074:	01 d0                	add    %edx,%eax
  801076:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801079:	e9 7b ff ff ff       	jmp    800ff9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80107e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80107f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801083:	74 08                	je     80108d <strtol+0x134>
		*endptr = (char *) s;
  801085:	8b 45 0c             	mov    0xc(%ebp),%eax
  801088:	8b 55 08             	mov    0x8(%ebp),%edx
  80108b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80108d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801091:	74 07                	je     80109a <strtol+0x141>
  801093:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801096:	f7 d8                	neg    %eax
  801098:	eb 03                	jmp    80109d <strtol+0x144>
  80109a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80109d:	c9                   	leave  
  80109e:	c3                   	ret    

0080109f <ltostr>:

void
ltostr(long value, char *str)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b7:	79 13                	jns    8010cc <ltostr+0x2d>
	{
		neg = 1;
  8010b9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010c6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010c9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010d4:	99                   	cltd   
  8010d5:	f7 f9                	idiv   %ecx
  8010d7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dd:	8d 50 01             	lea    0x1(%eax),%edx
  8010e0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010e3:	89 c2                	mov    %eax,%edx
  8010e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e8:	01 d0                	add    %edx,%eax
  8010ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ed:	83 c2 30             	add    $0x30,%edx
  8010f0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010f5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010fa:	f7 e9                	imul   %ecx
  8010fc:	c1 fa 02             	sar    $0x2,%edx
  8010ff:	89 c8                	mov    %ecx,%eax
  801101:	c1 f8 1f             	sar    $0x1f,%eax
  801104:	29 c2                	sub    %eax,%edx
  801106:	89 d0                	mov    %edx,%eax
  801108:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80110b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80110e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801113:	f7 e9                	imul   %ecx
  801115:	c1 fa 02             	sar    $0x2,%edx
  801118:	89 c8                	mov    %ecx,%eax
  80111a:	c1 f8 1f             	sar    $0x1f,%eax
  80111d:	29 c2                	sub    %eax,%edx
  80111f:	89 d0                	mov    %edx,%eax
  801121:	c1 e0 02             	shl    $0x2,%eax
  801124:	01 d0                	add    %edx,%eax
  801126:	01 c0                	add    %eax,%eax
  801128:	29 c1                	sub    %eax,%ecx
  80112a:	89 ca                	mov    %ecx,%edx
  80112c:	85 d2                	test   %edx,%edx
  80112e:	75 9c                	jne    8010cc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801130:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801137:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113a:	48                   	dec    %eax
  80113b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80113e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801142:	74 3d                	je     801181 <ltostr+0xe2>
		start = 1 ;
  801144:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80114b:	eb 34                	jmp    801181 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80114d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	01 d0                	add    %edx,%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80115a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	01 c2                	add    %eax,%edx
  801162:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801165:	8b 45 0c             	mov    0xc(%ebp),%eax
  801168:	01 c8                	add    %ecx,%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80116e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801171:	8b 45 0c             	mov    0xc(%ebp),%eax
  801174:	01 c2                	add    %eax,%edx
  801176:	8a 45 eb             	mov    -0x15(%ebp),%al
  801179:	88 02                	mov    %al,(%edx)
		start++ ;
  80117b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80117e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801184:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801187:	7c c4                	jl     80114d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801189:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	01 d0                	add    %edx,%eax
  801191:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801194:	90                   	nop
  801195:	c9                   	leave  
  801196:	c3                   	ret    

00801197 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80119d:	ff 75 08             	pushl  0x8(%ebp)
  8011a0:	e8 54 fa ff ff       	call   800bf9 <strlen>
  8011a5:	83 c4 04             	add    $0x4,%esp
  8011a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011ab:	ff 75 0c             	pushl  0xc(%ebp)
  8011ae:	e8 46 fa ff ff       	call   800bf9 <strlen>
  8011b3:	83 c4 04             	add    $0x4,%esp
  8011b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011c7:	eb 17                	jmp    8011e0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cf:	01 c2                	add    %eax,%edx
  8011d1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	01 c8                	add    %ecx,%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011dd:	ff 45 fc             	incl   -0x4(%ebp)
  8011e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011e6:	7c e1                	jl     8011c9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011f6:	eb 1f                	jmp    801217 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011fb:	8d 50 01             	lea    0x1(%eax),%edx
  8011fe:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801201:	89 c2                	mov    %eax,%edx
  801203:	8b 45 10             	mov    0x10(%ebp),%eax
  801206:	01 c2                	add    %eax,%edx
  801208:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80120b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120e:	01 c8                	add    %ecx,%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801214:	ff 45 f8             	incl   -0x8(%ebp)
  801217:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80121d:	7c d9                	jl     8011f8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80121f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801222:	8b 45 10             	mov    0x10(%ebp),%eax
  801225:	01 d0                	add    %edx,%eax
  801227:	c6 00 00             	movb   $0x0,(%eax)
}
  80122a:	90                   	nop
  80122b:	c9                   	leave  
  80122c:	c3                   	ret    

0080122d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801230:	8b 45 14             	mov    0x14(%ebp),%eax
  801233:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801239:	8b 45 14             	mov    0x14(%ebp),%eax
  80123c:	8b 00                	mov    (%eax),%eax
  80123e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801245:	8b 45 10             	mov    0x10(%ebp),%eax
  801248:	01 d0                	add    %edx,%eax
  80124a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801250:	eb 0c                	jmp    80125e <strsplit+0x31>
			*string++ = 0;
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	8d 50 01             	lea    0x1(%eax),%edx
  801258:	89 55 08             	mov    %edx,0x8(%ebp)
  80125b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	84 c0                	test   %al,%al
  801265:	74 18                	je     80127f <strsplit+0x52>
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	0f be c0             	movsbl %al,%eax
  80126f:	50                   	push   %eax
  801270:	ff 75 0c             	pushl  0xc(%ebp)
  801273:	e8 13 fb ff ff       	call   800d8b <strchr>
  801278:	83 c4 08             	add    $0x8,%esp
  80127b:	85 c0                	test   %eax,%eax
  80127d:	75 d3                	jne    801252 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	84 c0                	test   %al,%al
  801286:	74 5a                	je     8012e2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801288:	8b 45 14             	mov    0x14(%ebp),%eax
  80128b:	8b 00                	mov    (%eax),%eax
  80128d:	83 f8 0f             	cmp    $0xf,%eax
  801290:	75 07                	jne    801299 <strsplit+0x6c>
		{
			return 0;
  801292:	b8 00 00 00 00       	mov    $0x0,%eax
  801297:	eb 66                	jmp    8012ff <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801299:	8b 45 14             	mov    0x14(%ebp),%eax
  80129c:	8b 00                	mov    (%eax),%eax
  80129e:	8d 48 01             	lea    0x1(%eax),%ecx
  8012a1:	8b 55 14             	mov    0x14(%ebp),%edx
  8012a4:	89 0a                	mov    %ecx,(%edx)
  8012a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	01 c2                	add    %eax,%edx
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b7:	eb 03                	jmp    8012bc <strsplit+0x8f>
			string++;
  8012b9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	8a 00                	mov    (%eax),%al
  8012c1:	84 c0                	test   %al,%al
  8012c3:	74 8b                	je     801250 <strsplit+0x23>
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	8a 00                	mov    (%eax),%al
  8012ca:	0f be c0             	movsbl %al,%eax
  8012cd:	50                   	push   %eax
  8012ce:	ff 75 0c             	pushl  0xc(%ebp)
  8012d1:	e8 b5 fa ff ff       	call   800d8b <strchr>
  8012d6:	83 c4 08             	add    $0x8,%esp
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	74 dc                	je     8012b9 <strsplit+0x8c>
			string++;
	}
  8012dd:	e9 6e ff ff ff       	jmp    801250 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012e2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e6:	8b 00                	mov    (%eax),%eax
  8012e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f2:	01 d0                	add    %edx,%eax
  8012f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012fa:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	57                   	push   %edi
  801305:	56                   	push   %esi
  801306:	53                   	push   %ebx
  801307:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801310:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801313:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801316:	8b 7d 18             	mov    0x18(%ebp),%edi
  801319:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80131c:	cd 30                	int    $0x30
  80131e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801321:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801324:	83 c4 10             	add    $0x10,%esp
  801327:	5b                   	pop    %ebx
  801328:	5e                   	pop    %esi
  801329:	5f                   	pop    %edi
  80132a:	5d                   	pop    %ebp
  80132b:	c3                   	ret    

0080132c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 04             	sub    $0x4,%esp
  801332:	8b 45 10             	mov    0x10(%ebp),%eax
  801335:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801338:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	52                   	push   %edx
  801344:	ff 75 0c             	pushl  0xc(%ebp)
  801347:	50                   	push   %eax
  801348:	6a 00                	push   $0x0
  80134a:	e8 b2 ff ff ff       	call   801301 <syscall>
  80134f:	83 c4 18             	add    $0x18,%esp
}
  801352:	90                   	nop
  801353:	c9                   	leave  
  801354:	c3                   	ret    

00801355 <sys_cgetc>:

int
sys_cgetc(void)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 01                	push   $0x1
  801364:	e8 98 ff ff ff       	call   801301 <syscall>
  801369:	83 c4 18             	add    $0x18,%esp
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	50                   	push   %eax
  80137d:	6a 05                	push   $0x5
  80137f:	e8 7d ff ff ff       	call   801301 <syscall>
  801384:	83 c4 18             	add    $0x18,%esp
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 02                	push   $0x2
  801398:	e8 64 ff ff ff       	call   801301 <syscall>
  80139d:	83 c4 18             	add    $0x18,%esp
}
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 03                	push   $0x3
  8013b1:	e8 4b ff ff ff       	call   801301 <syscall>
  8013b6:	83 c4 18             	add    $0x18,%esp
}
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 04                	push   $0x4
  8013ca:	e8 32 ff ff ff       	call   801301 <syscall>
  8013cf:	83 c4 18             	add    $0x18,%esp
}
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    

008013d4 <sys_env_exit>:


void sys_env_exit(void)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 06                	push   $0x6
  8013e3:	e8 19 ff ff ff       	call   801301 <syscall>
  8013e8:	83 c4 18             	add    $0x18,%esp
}
  8013eb:	90                   	nop
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8013f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	52                   	push   %edx
  8013fe:	50                   	push   %eax
  8013ff:	6a 07                	push   $0x7
  801401:	e8 fb fe ff ff       	call   801301 <syscall>
  801406:	83 c4 18             	add    $0x18,%esp
}
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	56                   	push   %esi
  80140f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801410:	8b 75 18             	mov    0x18(%ebp),%esi
  801413:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801416:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801419:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	56                   	push   %esi
  801420:	53                   	push   %ebx
  801421:	51                   	push   %ecx
  801422:	52                   	push   %edx
  801423:	50                   	push   %eax
  801424:	6a 08                	push   $0x8
  801426:	e8 d6 fe ff ff       	call   801301 <syscall>
  80142b:	83 c4 18             	add    $0x18,%esp
}
  80142e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801431:	5b                   	pop    %ebx
  801432:	5e                   	pop    %esi
  801433:	5d                   	pop    %ebp
  801434:	c3                   	ret    

00801435 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	52                   	push   %edx
  801445:	50                   	push   %eax
  801446:	6a 09                	push   $0x9
  801448:	e8 b4 fe ff ff       	call   801301 <syscall>
  80144d:	83 c4 18             	add    $0x18,%esp
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	ff 75 0c             	pushl  0xc(%ebp)
  80145e:	ff 75 08             	pushl  0x8(%ebp)
  801461:	6a 0a                	push   $0xa
  801463:	e8 99 fe ff ff       	call   801301 <syscall>
  801468:	83 c4 18             	add    $0x18,%esp
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 0b                	push   $0xb
  80147c:	e8 80 fe ff ff       	call   801301 <syscall>
  801481:	83 c4 18             	add    $0x18,%esp
}
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 0c                	push   $0xc
  801495:	e8 67 fe ff ff       	call   801301 <syscall>
  80149a:	83 c4 18             	add    $0x18,%esp
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 0d                	push   $0xd
  8014ae:	e8 4e fe ff ff       	call   801301 <syscall>
  8014b3:	83 c4 18             	add    $0x18,%esp
}
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	ff 75 0c             	pushl  0xc(%ebp)
  8014c4:	ff 75 08             	pushl  0x8(%ebp)
  8014c7:	6a 11                	push   $0x11
  8014c9:	e8 33 fe ff ff       	call   801301 <syscall>
  8014ce:	83 c4 18             	add    $0x18,%esp
	return;
  8014d1:	90                   	nop
}
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    

008014d4 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	ff 75 0c             	pushl  0xc(%ebp)
  8014e0:	ff 75 08             	pushl  0x8(%ebp)
  8014e3:	6a 12                	push   $0x12
  8014e5:	e8 17 fe ff ff       	call   801301 <syscall>
  8014ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8014ed:	90                   	nop
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 0e                	push   $0xe
  8014ff:	e8 fd fd ff ff       	call   801301 <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	ff 75 08             	pushl  0x8(%ebp)
  801517:	6a 0f                	push   $0xf
  801519:	e8 e3 fd ff ff       	call   801301 <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 10                	push   $0x10
  801532:	e8 ca fd ff ff       	call   801301 <syscall>
  801537:	83 c4 18             	add    $0x18,%esp
}
  80153a:	90                   	nop
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 14                	push   $0x14
  80154c:	e8 b0 fd ff ff       	call   801301 <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
}
  801554:	90                   	nop
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 15                	push   $0x15
  801566:	e8 96 fd ff ff       	call   801301 <syscall>
  80156b:	83 c4 18             	add    $0x18,%esp
}
  80156e:	90                   	nop
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_cputc>:


void
sys_cputc(const char c)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	83 ec 04             	sub    $0x4,%esp
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80157d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	50                   	push   %eax
  80158a:	6a 16                	push   $0x16
  80158c:	e8 70 fd ff ff       	call   801301 <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	90                   	nop
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 17                	push   $0x17
  8015a6:	e8 56 fd ff ff       	call   801301 <syscall>
  8015ab:	83 c4 18             	add    $0x18,%esp
}
  8015ae:	90                   	nop
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	ff 75 0c             	pushl  0xc(%ebp)
  8015c0:	50                   	push   %eax
  8015c1:	6a 18                	push   $0x18
  8015c3:	e8 39 fd ff ff       	call   801301 <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	52                   	push   %edx
  8015dd:	50                   	push   %eax
  8015de:	6a 1b                	push   $0x1b
  8015e0:	e8 1c fd ff ff       	call   801301 <syscall>
  8015e5:	83 c4 18             	add    $0x18,%esp
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	52                   	push   %edx
  8015fa:	50                   	push   %eax
  8015fb:	6a 19                	push   $0x19
  8015fd:	e8 ff fc ff ff       	call   801301 <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
}
  801605:	90                   	nop
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80160b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	52                   	push   %edx
  801618:	50                   	push   %eax
  801619:	6a 1a                	push   $0x1a
  80161b:	e8 e1 fc ff ff       	call   801301 <syscall>
  801620:	83 c4 18             	add    $0x18,%esp
}
  801623:	90                   	nop
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	8b 45 10             	mov    0x10(%ebp),%eax
  80162f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801632:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801635:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	6a 00                	push   $0x0
  80163e:	51                   	push   %ecx
  80163f:	52                   	push   %edx
  801640:	ff 75 0c             	pushl  0xc(%ebp)
  801643:	50                   	push   %eax
  801644:	6a 1c                	push   $0x1c
  801646:	e8 b6 fc ff ff       	call   801301 <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801653:	8b 55 0c             	mov    0xc(%ebp),%edx
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	52                   	push   %edx
  801660:	50                   	push   %eax
  801661:	6a 1d                	push   $0x1d
  801663:	e8 99 fc ff ff       	call   801301 <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801670:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801673:	8b 55 0c             	mov    0xc(%ebp),%edx
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	51                   	push   %ecx
  80167e:	52                   	push   %edx
  80167f:	50                   	push   %eax
  801680:	6a 1e                	push   $0x1e
  801682:	e8 7a fc ff ff       	call   801301 <syscall>
  801687:	83 c4 18             	add    $0x18,%esp
}
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80168f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	52                   	push   %edx
  80169c:	50                   	push   %eax
  80169d:	6a 1f                	push   $0x1f
  80169f:	e8 5d fc ff ff       	call   801301 <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
}
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 20                	push   $0x20
  8016b8:	e8 44 fc ff ff       	call   801301 <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	ff 75 10             	pushl  0x10(%ebp)
  8016cf:	ff 75 0c             	pushl  0xc(%ebp)
  8016d2:	50                   	push   %eax
  8016d3:	6a 21                	push   $0x21
  8016d5:	e8 27 fc ff ff       	call   801301 <syscall>
  8016da:	83 c4 18             	add    $0x18,%esp
}
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <sys_run_env>:


void
sys_run_env(int32 envId)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	50                   	push   %eax
  8016ee:	6a 22                	push   $0x22
  8016f0:	e8 0c fc ff ff       	call   801301 <syscall>
  8016f5:	83 c4 18             	add    $0x18,%esp
}
  8016f8:	90                   	nop
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	50                   	push   %eax
  80170a:	6a 23                	push   $0x23
  80170c:	e8 f0 fb ff ff       	call   801301 <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
}
  801714:	90                   	nop
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80171d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801720:	8d 50 04             	lea    0x4(%eax),%edx
  801723:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	52                   	push   %edx
  80172d:	50                   	push   %eax
  80172e:	6a 24                	push   $0x24
  801730:	e8 cc fb ff ff       	call   801301 <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
	return result;
  801738:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801741:	89 01                	mov    %eax,(%ecx)
  801743:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	c9                   	leave  
  80174a:	c2 04 00             	ret    $0x4

0080174d <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	ff 75 10             	pushl  0x10(%ebp)
  801757:	ff 75 0c             	pushl  0xc(%ebp)
  80175a:	ff 75 08             	pushl  0x8(%ebp)
  80175d:	6a 13                	push   $0x13
  80175f:	e8 9d fb ff ff       	call   801301 <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
	return ;
  801767:	90                   	nop
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_rcr2>:
uint32 sys_rcr2()
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 25                	push   $0x25
  801779:	e8 83 fb ff ff       	call   801301 <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 04             	sub    $0x4,%esp
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80178f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	50                   	push   %eax
  80179c:	6a 26                	push   $0x26
  80179e:	e8 5e fb ff ff       	call   801301 <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a6:	90                   	nop
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <rsttst>:
void rsttst()
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 28                	push   $0x28
  8017b8:	e8 44 fb ff ff       	call   801301 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c0:	90                   	nop
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 04             	sub    $0x4,%esp
  8017c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017cf:	8b 55 18             	mov    0x18(%ebp),%edx
  8017d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017d6:	52                   	push   %edx
  8017d7:	50                   	push   %eax
  8017d8:	ff 75 10             	pushl  0x10(%ebp)
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	ff 75 08             	pushl  0x8(%ebp)
  8017e1:	6a 27                	push   $0x27
  8017e3:	e8 19 fb ff ff       	call   801301 <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017eb:	90                   	nop
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <chktst>:
void chktst(uint32 n)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	ff 75 08             	pushl  0x8(%ebp)
  8017fc:	6a 29                	push   $0x29
  8017fe:	e8 fe fa ff ff       	call   801301 <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
	return ;
  801806:	90                   	nop
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <inctst>:

void inctst()
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 2a                	push   $0x2a
  801818:	e8 e4 fa ff ff       	call   801301 <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
	return ;
  801820:	90                   	nop
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <gettst>:
uint32 gettst()
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 2b                	push   $0x2b
  801832:	e8 ca fa ff ff       	call   801301 <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 2c                	push   $0x2c
  80184e:	e8 ae fa ff ff       	call   801301 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
  801856:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801859:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80185d:	75 07                	jne    801866 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80185f:	b8 01 00 00 00       	mov    $0x1,%eax
  801864:	eb 05                	jmp    80186b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801866:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 2c                	push   $0x2c
  80187f:	e8 7d fa ff ff       	call   801301 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
  801887:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80188a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80188e:	75 07                	jne    801897 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801890:	b8 01 00 00 00       	mov    $0x1,%eax
  801895:	eb 05                	jmp    80189c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801897:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 2c                	push   $0x2c
  8018b0:	e8 4c fa ff ff       	call   801301 <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
  8018b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8018bb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8018bf:	75 07                	jne    8018c8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8018c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8018c6:	eb 05                	jmp    8018cd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8018c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 2c                	push   $0x2c
  8018e1:	e8 1b fa ff ff       	call   801301 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
  8018e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8018ec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8018f0:	75 07                	jne    8018f9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8018f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f7:	eb 05                	jmp    8018fe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8018f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	ff 75 08             	pushl  0x8(%ebp)
  80190e:	6a 2d                	push   $0x2d
  801910:	e8 ec f9 ff ff       	call   801301 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
	return ;
  801918:	90                   	nop
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80191f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801922:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801925:	8b 55 0c             	mov    0xc(%ebp),%edx
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	6a 00                	push   $0x0
  80192d:	53                   	push   %ebx
  80192e:	51                   	push   %ecx
  80192f:	52                   	push   %edx
  801930:	50                   	push   %eax
  801931:	6a 2e                	push   $0x2e
  801933:	e8 c9 f9 ff ff       	call   801301 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801943:	8b 55 0c             	mov    0xc(%ebp),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 2f                	push   $0x2f
  801953:	e8 a9 f9 ff ff       	call   801301 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801963:	8b 55 08             	mov    0x8(%ebp),%edx
  801966:	89 d0                	mov    %edx,%eax
  801968:	c1 e0 02             	shl    $0x2,%eax
  80196b:	01 d0                	add    %edx,%eax
  80196d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801974:	01 d0                	add    %edx,%eax
  801976:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80197d:	01 d0                	add    %edx,%eax
  80197f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801986:	01 d0                	add    %edx,%eax
  801988:	c1 e0 04             	shl    $0x4,%eax
  80198b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80198e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801995:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801998:	83 ec 0c             	sub    $0xc,%esp
  80199b:	50                   	push   %eax
  80199c:	e8 76 fd ff ff       	call   801717 <sys_get_virtual_time>
  8019a1:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8019a4:	eb 41                	jmp    8019e7 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8019a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019a9:	83 ec 0c             	sub    $0xc,%esp
  8019ac:	50                   	push   %eax
  8019ad:	e8 65 fd ff ff       	call   801717 <sys_get_virtual_time>
  8019b2:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019bb:	29 c2                	sub    %eax,%edx
  8019bd:	89 d0                	mov    %edx,%eax
  8019bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c8:	89 d1                	mov    %edx,%ecx
  8019ca:	29 c1                	sub    %eax,%ecx
  8019cc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d2:	39 c2                	cmp    %eax,%edx
  8019d4:	0f 97 c0             	seta   %al
  8019d7:	0f b6 c0             	movzbl %al,%eax
  8019da:	29 c1                	sub    %eax,%ecx
  8019dc:	89 c8                	mov    %ecx,%eax
  8019de:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8019e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8019e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019ed:	72 b7                	jb     8019a6 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8019ef:	90                   	nop
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8019f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8019ff:	eb 03                	jmp    801a04 <busy_wait+0x12>
  801a01:	ff 45 fc             	incl   -0x4(%ebp)
  801a04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a07:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a0a:	72 f5                	jb     801a01 <busy_wait+0xf>
	return i;
  801a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    
  801a11:	66 90                	xchg   %ax,%ax
  801a13:	90                   	nop

00801a14 <__udivdi3>:
  801a14:	55                   	push   %ebp
  801a15:	57                   	push   %edi
  801a16:	56                   	push   %esi
  801a17:	53                   	push   %ebx
  801a18:	83 ec 1c             	sub    $0x1c,%esp
  801a1b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a1f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a27:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a2b:	89 ca                	mov    %ecx,%edx
  801a2d:	89 f8                	mov    %edi,%eax
  801a2f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a33:	85 f6                	test   %esi,%esi
  801a35:	75 2d                	jne    801a64 <__udivdi3+0x50>
  801a37:	39 cf                	cmp    %ecx,%edi
  801a39:	77 65                	ja     801aa0 <__udivdi3+0x8c>
  801a3b:	89 fd                	mov    %edi,%ebp
  801a3d:	85 ff                	test   %edi,%edi
  801a3f:	75 0b                	jne    801a4c <__udivdi3+0x38>
  801a41:	b8 01 00 00 00       	mov    $0x1,%eax
  801a46:	31 d2                	xor    %edx,%edx
  801a48:	f7 f7                	div    %edi
  801a4a:	89 c5                	mov    %eax,%ebp
  801a4c:	31 d2                	xor    %edx,%edx
  801a4e:	89 c8                	mov    %ecx,%eax
  801a50:	f7 f5                	div    %ebp
  801a52:	89 c1                	mov    %eax,%ecx
  801a54:	89 d8                	mov    %ebx,%eax
  801a56:	f7 f5                	div    %ebp
  801a58:	89 cf                	mov    %ecx,%edi
  801a5a:	89 fa                	mov    %edi,%edx
  801a5c:	83 c4 1c             	add    $0x1c,%esp
  801a5f:	5b                   	pop    %ebx
  801a60:	5e                   	pop    %esi
  801a61:	5f                   	pop    %edi
  801a62:	5d                   	pop    %ebp
  801a63:	c3                   	ret    
  801a64:	39 ce                	cmp    %ecx,%esi
  801a66:	77 28                	ja     801a90 <__udivdi3+0x7c>
  801a68:	0f bd fe             	bsr    %esi,%edi
  801a6b:	83 f7 1f             	xor    $0x1f,%edi
  801a6e:	75 40                	jne    801ab0 <__udivdi3+0x9c>
  801a70:	39 ce                	cmp    %ecx,%esi
  801a72:	72 0a                	jb     801a7e <__udivdi3+0x6a>
  801a74:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a78:	0f 87 9e 00 00 00    	ja     801b1c <__udivdi3+0x108>
  801a7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a83:	89 fa                	mov    %edi,%edx
  801a85:	83 c4 1c             	add    $0x1c,%esp
  801a88:	5b                   	pop    %ebx
  801a89:	5e                   	pop    %esi
  801a8a:	5f                   	pop    %edi
  801a8b:	5d                   	pop    %ebp
  801a8c:	c3                   	ret    
  801a8d:	8d 76 00             	lea    0x0(%esi),%esi
  801a90:	31 ff                	xor    %edi,%edi
  801a92:	31 c0                	xor    %eax,%eax
  801a94:	89 fa                	mov    %edi,%edx
  801a96:	83 c4 1c             	add    $0x1c,%esp
  801a99:	5b                   	pop    %ebx
  801a9a:	5e                   	pop    %esi
  801a9b:	5f                   	pop    %edi
  801a9c:	5d                   	pop    %ebp
  801a9d:	c3                   	ret    
  801a9e:	66 90                	xchg   %ax,%ax
  801aa0:	89 d8                	mov    %ebx,%eax
  801aa2:	f7 f7                	div    %edi
  801aa4:	31 ff                	xor    %edi,%edi
  801aa6:	89 fa                	mov    %edi,%edx
  801aa8:	83 c4 1c             	add    $0x1c,%esp
  801aab:	5b                   	pop    %ebx
  801aac:	5e                   	pop    %esi
  801aad:	5f                   	pop    %edi
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    
  801ab0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ab5:	89 eb                	mov    %ebp,%ebx
  801ab7:	29 fb                	sub    %edi,%ebx
  801ab9:	89 f9                	mov    %edi,%ecx
  801abb:	d3 e6                	shl    %cl,%esi
  801abd:	89 c5                	mov    %eax,%ebp
  801abf:	88 d9                	mov    %bl,%cl
  801ac1:	d3 ed                	shr    %cl,%ebp
  801ac3:	89 e9                	mov    %ebp,%ecx
  801ac5:	09 f1                	or     %esi,%ecx
  801ac7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801acb:	89 f9                	mov    %edi,%ecx
  801acd:	d3 e0                	shl    %cl,%eax
  801acf:	89 c5                	mov    %eax,%ebp
  801ad1:	89 d6                	mov    %edx,%esi
  801ad3:	88 d9                	mov    %bl,%cl
  801ad5:	d3 ee                	shr    %cl,%esi
  801ad7:	89 f9                	mov    %edi,%ecx
  801ad9:	d3 e2                	shl    %cl,%edx
  801adb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801adf:	88 d9                	mov    %bl,%cl
  801ae1:	d3 e8                	shr    %cl,%eax
  801ae3:	09 c2                	or     %eax,%edx
  801ae5:	89 d0                	mov    %edx,%eax
  801ae7:	89 f2                	mov    %esi,%edx
  801ae9:	f7 74 24 0c          	divl   0xc(%esp)
  801aed:	89 d6                	mov    %edx,%esi
  801aef:	89 c3                	mov    %eax,%ebx
  801af1:	f7 e5                	mul    %ebp
  801af3:	39 d6                	cmp    %edx,%esi
  801af5:	72 19                	jb     801b10 <__udivdi3+0xfc>
  801af7:	74 0b                	je     801b04 <__udivdi3+0xf0>
  801af9:	89 d8                	mov    %ebx,%eax
  801afb:	31 ff                	xor    %edi,%edi
  801afd:	e9 58 ff ff ff       	jmp    801a5a <__udivdi3+0x46>
  801b02:	66 90                	xchg   %ax,%ax
  801b04:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b08:	89 f9                	mov    %edi,%ecx
  801b0a:	d3 e2                	shl    %cl,%edx
  801b0c:	39 c2                	cmp    %eax,%edx
  801b0e:	73 e9                	jae    801af9 <__udivdi3+0xe5>
  801b10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b13:	31 ff                	xor    %edi,%edi
  801b15:	e9 40 ff ff ff       	jmp    801a5a <__udivdi3+0x46>
  801b1a:	66 90                	xchg   %ax,%ax
  801b1c:	31 c0                	xor    %eax,%eax
  801b1e:	e9 37 ff ff ff       	jmp    801a5a <__udivdi3+0x46>
  801b23:	90                   	nop

00801b24 <__umoddi3>:
  801b24:	55                   	push   %ebp
  801b25:	57                   	push   %edi
  801b26:	56                   	push   %esi
  801b27:	53                   	push   %ebx
  801b28:	83 ec 1c             	sub    $0x1c,%esp
  801b2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b37:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b43:	89 f3                	mov    %esi,%ebx
  801b45:	89 fa                	mov    %edi,%edx
  801b47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b4b:	89 34 24             	mov    %esi,(%esp)
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	75 1a                	jne    801b6c <__umoddi3+0x48>
  801b52:	39 f7                	cmp    %esi,%edi
  801b54:	0f 86 a2 00 00 00    	jbe    801bfc <__umoddi3+0xd8>
  801b5a:	89 c8                	mov    %ecx,%eax
  801b5c:	89 f2                	mov    %esi,%edx
  801b5e:	f7 f7                	div    %edi
  801b60:	89 d0                	mov    %edx,%eax
  801b62:	31 d2                	xor    %edx,%edx
  801b64:	83 c4 1c             	add    $0x1c,%esp
  801b67:	5b                   	pop    %ebx
  801b68:	5e                   	pop    %esi
  801b69:	5f                   	pop    %edi
  801b6a:	5d                   	pop    %ebp
  801b6b:	c3                   	ret    
  801b6c:	39 f0                	cmp    %esi,%eax
  801b6e:	0f 87 ac 00 00 00    	ja     801c20 <__umoddi3+0xfc>
  801b74:	0f bd e8             	bsr    %eax,%ebp
  801b77:	83 f5 1f             	xor    $0x1f,%ebp
  801b7a:	0f 84 ac 00 00 00    	je     801c2c <__umoddi3+0x108>
  801b80:	bf 20 00 00 00       	mov    $0x20,%edi
  801b85:	29 ef                	sub    %ebp,%edi
  801b87:	89 fe                	mov    %edi,%esi
  801b89:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b8d:	89 e9                	mov    %ebp,%ecx
  801b8f:	d3 e0                	shl    %cl,%eax
  801b91:	89 d7                	mov    %edx,%edi
  801b93:	89 f1                	mov    %esi,%ecx
  801b95:	d3 ef                	shr    %cl,%edi
  801b97:	09 c7                	or     %eax,%edi
  801b99:	89 e9                	mov    %ebp,%ecx
  801b9b:	d3 e2                	shl    %cl,%edx
  801b9d:	89 14 24             	mov    %edx,(%esp)
  801ba0:	89 d8                	mov    %ebx,%eax
  801ba2:	d3 e0                	shl    %cl,%eax
  801ba4:	89 c2                	mov    %eax,%edx
  801ba6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801baa:	d3 e0                	shl    %cl,%eax
  801bac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bb4:	89 f1                	mov    %esi,%ecx
  801bb6:	d3 e8                	shr    %cl,%eax
  801bb8:	09 d0                	or     %edx,%eax
  801bba:	d3 eb                	shr    %cl,%ebx
  801bbc:	89 da                	mov    %ebx,%edx
  801bbe:	f7 f7                	div    %edi
  801bc0:	89 d3                	mov    %edx,%ebx
  801bc2:	f7 24 24             	mull   (%esp)
  801bc5:	89 c6                	mov    %eax,%esi
  801bc7:	89 d1                	mov    %edx,%ecx
  801bc9:	39 d3                	cmp    %edx,%ebx
  801bcb:	0f 82 87 00 00 00    	jb     801c58 <__umoddi3+0x134>
  801bd1:	0f 84 91 00 00 00    	je     801c68 <__umoddi3+0x144>
  801bd7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bdb:	29 f2                	sub    %esi,%edx
  801bdd:	19 cb                	sbb    %ecx,%ebx
  801bdf:	89 d8                	mov    %ebx,%eax
  801be1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801be5:	d3 e0                	shl    %cl,%eax
  801be7:	89 e9                	mov    %ebp,%ecx
  801be9:	d3 ea                	shr    %cl,%edx
  801beb:	09 d0                	or     %edx,%eax
  801bed:	89 e9                	mov    %ebp,%ecx
  801bef:	d3 eb                	shr    %cl,%ebx
  801bf1:	89 da                	mov    %ebx,%edx
  801bf3:	83 c4 1c             	add    $0x1c,%esp
  801bf6:	5b                   	pop    %ebx
  801bf7:	5e                   	pop    %esi
  801bf8:	5f                   	pop    %edi
  801bf9:	5d                   	pop    %ebp
  801bfa:	c3                   	ret    
  801bfb:	90                   	nop
  801bfc:	89 fd                	mov    %edi,%ebp
  801bfe:	85 ff                	test   %edi,%edi
  801c00:	75 0b                	jne    801c0d <__umoddi3+0xe9>
  801c02:	b8 01 00 00 00       	mov    $0x1,%eax
  801c07:	31 d2                	xor    %edx,%edx
  801c09:	f7 f7                	div    %edi
  801c0b:	89 c5                	mov    %eax,%ebp
  801c0d:	89 f0                	mov    %esi,%eax
  801c0f:	31 d2                	xor    %edx,%edx
  801c11:	f7 f5                	div    %ebp
  801c13:	89 c8                	mov    %ecx,%eax
  801c15:	f7 f5                	div    %ebp
  801c17:	89 d0                	mov    %edx,%eax
  801c19:	e9 44 ff ff ff       	jmp    801b62 <__umoddi3+0x3e>
  801c1e:	66 90                	xchg   %ax,%ax
  801c20:	89 c8                	mov    %ecx,%eax
  801c22:	89 f2                	mov    %esi,%edx
  801c24:	83 c4 1c             	add    $0x1c,%esp
  801c27:	5b                   	pop    %ebx
  801c28:	5e                   	pop    %esi
  801c29:	5f                   	pop    %edi
  801c2a:	5d                   	pop    %ebp
  801c2b:	c3                   	ret    
  801c2c:	3b 04 24             	cmp    (%esp),%eax
  801c2f:	72 06                	jb     801c37 <__umoddi3+0x113>
  801c31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c35:	77 0f                	ja     801c46 <__umoddi3+0x122>
  801c37:	89 f2                	mov    %esi,%edx
  801c39:	29 f9                	sub    %edi,%ecx
  801c3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c3f:	89 14 24             	mov    %edx,(%esp)
  801c42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c46:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c4a:	8b 14 24             	mov    (%esp),%edx
  801c4d:	83 c4 1c             	add    $0x1c,%esp
  801c50:	5b                   	pop    %ebx
  801c51:	5e                   	pop    %esi
  801c52:	5f                   	pop    %edi
  801c53:	5d                   	pop    %ebp
  801c54:	c3                   	ret    
  801c55:	8d 76 00             	lea    0x0(%esi),%esi
  801c58:	2b 04 24             	sub    (%esp),%eax
  801c5b:	19 fa                	sbb    %edi,%edx
  801c5d:	89 d1                	mov    %edx,%ecx
  801c5f:	89 c6                	mov    %eax,%esi
  801c61:	e9 71 ff ff ff       	jmp    801bd7 <__umoddi3+0xb3>
  801c66:	66 90                	xchg   %ax,%ax
  801c68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c6c:	72 ea                	jb     801c58 <__umoddi3+0x134>
  801c6e:	89 d9                	mov    %ebx,%ecx
  801c70:	e9 62 ff ff ff       	jmp    801bd7 <__umoddi3+0xb3>
