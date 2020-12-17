
obj/user/tst_placement:     file format elf32-i386


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
  800031:	e8 78 05 00 00       	call   8005ae <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 00 00 01    	sub    $0x100009c,%esp

	char arr[PAGE_SIZE*1024*4];

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800044:	a1 20 30 80 00       	mov    0x803020,%eax
  800049:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80004f:	8b 00                	mov    (%eax),%eax
  800051:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800054:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800057:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005c:	3d 00 00 20 00       	cmp    $0x200000,%eax
  800061:	74 14                	je     800077 <_main+0x3f>
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	68 e0 1f 80 00       	push   $0x801fe0
  80006b:	6a 10                	push   $0x10
  80006d:	68 21 20 80 00       	push   $0x802021
  800072:	e8 7c 06 00 00       	call   8006f3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800077:	a1 20 30 80 00       	mov    0x803020,%eax
  80007c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800082:	83 c0 10             	add    $0x10,%eax
  800085:	8b 00                	mov    (%eax),%eax
  800087:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80008a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80008d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800092:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800097:	74 14                	je     8000ad <_main+0x75>
  800099:	83 ec 04             	sub    $0x4,%esp
  80009c:	68 e0 1f 80 00       	push   $0x801fe0
  8000a1:	6a 11                	push   $0x11
  8000a3:	68 21 20 80 00       	push   $0x802021
  8000a8:	e8 46 06 00 00       	call   8006f3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b2:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8000b8:	83 c0 20             	add    $0x20,%eax
  8000bb:	8b 00                	mov    (%eax),%eax
  8000bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c8:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000cd:	74 14                	je     8000e3 <_main+0xab>
  8000cf:	83 ec 04             	sub    $0x4,%esp
  8000d2:	68 e0 1f 80 00       	push   $0x801fe0
  8000d7:	6a 12                	push   $0x12
  8000d9:	68 21 20 80 00       	push   $0x802021
  8000de:	e8 10 06 00 00       	call   8006f3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e8:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8000ee:	83 c0 30             	add    $0x30,%eax
  8000f1:	8b 00                	mov    (%eax),%eax
  8000f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8000f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000fe:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800103:	74 14                	je     800119 <_main+0xe1>
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	68 e0 1f 80 00       	push   $0x801fe0
  80010d:	6a 13                	push   $0x13
  80010f:	68 21 20 80 00       	push   $0x802021
  800114:	e8 da 05 00 00       	call   8006f3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800119:	a1 20 30 80 00       	mov    0x803020,%eax
  80011e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800124:	83 c0 40             	add    $0x40,%eax
  800127:	8b 00                	mov    (%eax),%eax
  800129:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80012c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80012f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800134:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 e0 1f 80 00       	push   $0x801fe0
  800143:	6a 14                	push   $0x14
  800145:	68 21 20 80 00       	push   $0x802021
  80014a:	e8 a4 05 00 00       	call   8006f3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80014f:	a1 20 30 80 00       	mov    0x803020,%eax
  800154:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80015a:	83 c0 50             	add    $0x50,%eax
  80015d:	8b 00                	mov    (%eax),%eax
  80015f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800162:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800165:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80016a:	3d 00 50 20 00       	cmp    $0x205000,%eax
  80016f:	74 14                	je     800185 <_main+0x14d>
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	68 e0 1f 80 00       	push   $0x801fe0
  800179:	6a 15                	push   $0x15
  80017b:	68 21 20 80 00       	push   $0x802021
  800180:	e8 6e 05 00 00       	call   8006f3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x206000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800185:	a1 20 30 80 00       	mov    0x803020,%eax
  80018a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800190:	83 c0 60             	add    $0x60,%eax
  800193:	8b 00                	mov    (%eax),%eax
  800195:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800198:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80019b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a0:	3d 00 60 20 00       	cmp    $0x206000,%eax
  8001a5:	74 14                	je     8001bb <_main+0x183>
  8001a7:	83 ec 04             	sub    $0x4,%esp
  8001aa:	68 e0 1f 80 00       	push   $0x801fe0
  8001af:	6a 16                	push   $0x16
  8001b1:	68 21 20 80 00       	push   $0x802021
  8001b6:	e8 38 05 00 00       	call   8006f3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c0:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8001c6:	83 c0 70             	add    $0x70,%eax
  8001c9:	8b 00                	mov    (%eax),%eax
  8001cb:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8001ce:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d6:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001db:	74 14                	je     8001f1 <_main+0x1b9>
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	68 e0 1f 80 00       	push   $0x801fe0
  8001e5:	6a 17                	push   $0x17
  8001e7:	68 21 20 80 00       	push   $0x802021
  8001ec:	e8 02 05 00 00       	call   8006f3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f6:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8001fc:	83 e8 80             	sub    $0xffffff80,%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800204:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800207:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020c:	3d 00 10 80 00       	cmp    $0x801000,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 e0 1f 80 00       	push   $0x801fe0
  80021b:	6a 18                	push   $0x18
  80021d:	68 21 20 80 00       	push   $0x802021
  800222:	e8 cc 04 00 00       	call   8006f3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800232:	05 90 00 00 00       	add    $0x90,%eax
  800237:	8b 00                	mov    (%eax),%eax
  800239:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80023c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800244:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800249:	74 14                	je     80025f <_main+0x227>
  80024b:	83 ec 04             	sub    $0x4,%esp
  80024e:	68 e0 1f 80 00       	push   $0x801fe0
  800253:	6a 19                	push   $0x19
  800255:	68 21 20 80 00       	push   $0x802021
  80025a:	e8 94 04 00 00       	call   8006f3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80026a:	05 a0 00 00 00       	add    $0xa0,%eax
  80026f:	8b 00                	mov    (%eax),%eax
  800271:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800274:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800277:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027c:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800281:	74 14                	je     800297 <_main+0x25f>
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	68 e0 1f 80 00       	push   $0x801fe0
  80028b:	6a 1a                	push   $0x1a
  80028d:	68 21 20 80 00       	push   $0x802021
  800292:	e8 5c 04 00 00       	call   8006f3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800297:	a1 20 30 80 00       	mov    0x803020,%eax
  80029c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8002a2:	05 b0 00 00 00       	add    $0xb0,%eax
  8002a7:	8b 00                	mov    (%eax),%eax
  8002a9:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8002ac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002b4:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  8002b9:	74 14                	je     8002cf <_main+0x297>
  8002bb:	83 ec 04             	sub    $0x4,%esp
  8002be:	68 e0 1f 80 00       	push   $0x801fe0
  8002c3:	6a 1b                	push   $0x1b
  8002c5:	68 21 20 80 00       	push   $0x802021
  8002ca:	e8 24 04 00 00       	call   8006f3 <_panic>

		for (int k = 12; k < 20; k++)
  8002cf:	c7 45 e4 0c 00 00 00 	movl   $0xc,-0x1c(%ebp)
  8002d6:	eb 31                	jmp    800309 <_main+0x2d1>
			if( myEnv->__uptr_pws[k].empty !=  1)
  8002d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002dd:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8002e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e6:	c1 e2 04             	shl    $0x4,%edx
  8002e9:	01 d0                	add    %edx,%eax
  8002eb:	8a 40 04             	mov    0x4(%eax),%al
  8002ee:	3c 01                	cmp    $0x1,%al
  8002f0:	74 14                	je     800306 <_main+0x2ce>
				panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8002f2:	83 ec 04             	sub    $0x4,%esp
  8002f5:	68 e0 1f 80 00       	push   $0x801fe0
  8002fa:	6a 1f                	push   $0x1f
  8002fc:	68 21 20 80 00       	push   $0x802021
  800301:	e8 ed 03 00 00       	call   8006f3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");

		for (int k = 12; k < 20; k++)
  800306:	ff 45 e4             	incl   -0x1c(%ebp)
  800309:	83 7d e4 13          	cmpl   $0x13,-0x1c(%ebp)
  80030d:	7e c9                	jle    8002d8 <_main+0x2a0>
		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if( myEnv->page_last_WS_index !=  12)  											panic("INITIAL PAGE last index checking failed! Review size of the WS..!!");
		/*====================================*/
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80030f:	e8 fa 15 00 00       	call   80190e <sys_pf_calculate_allocated_pages>
  800314:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int freePages = sys_calculate_free_frames();
  800317:	e8 6f 15 00 00       	call   80188b <sys_calculate_free_frames>
  80031c:	89 45 a8             	mov    %eax,-0x58(%ebp)

	int i=0;
  80031f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for(;i<=PAGE_SIZE;i++)
  800326:	eb 11                	jmp    800339 <_main+0x301>
	{
		arr[i] = -1;
  800328:	8d 95 a8 ff ff fe    	lea    -0x1000058(%ebp),%edx
  80032e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800331:	01 d0                	add    %edx,%eax
  800333:	c6 00 ff             	movb   $0xff,(%eax)

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();

	int i=0;
	for(;i<=PAGE_SIZE;i++)
  800336:	ff 45 e0             	incl   -0x20(%ebp)
  800339:	81 7d e0 00 10 00 00 	cmpl   $0x1000,-0x20(%ebp)
  800340:	7e e6                	jle    800328 <_main+0x2f0>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  800342:	c7 45 e0 00 00 40 00 	movl   $0x400000,-0x20(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800349:	eb 11                	jmp    80035c <_main+0x324>
	{
		arr[i] = -1;
  80034b:	8d 95 a8 ff ff fe    	lea    -0x1000058(%ebp),%edx
  800351:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800354:	01 d0                	add    %edx,%eax
  800356:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800359:	ff 45 e0             	incl   -0x20(%ebp)
  80035c:	81 7d e0 00 10 40 00 	cmpl   $0x401000,-0x20(%ebp)
  800363:	7e e6                	jle    80034b <_main+0x313>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  800365:	c7 45 e0 00 00 80 00 	movl   $0x800000,-0x20(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  80036c:	eb 11                	jmp    80037f <_main+0x347>
	{
		arr[i] = -1;
  80036e:	8d 95 a8 ff ff fe    	lea    -0x1000058(%ebp),%edx
  800374:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800377:	01 d0                	add    %edx,%eax
  800379:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  80037c:	ff 45 e0             	incl   -0x20(%ebp)
  80037f:	81 7d e0 00 10 80 00 	cmpl   $0x801000,-0x20(%ebp)
  800386:	7e e6                	jle    80036e <_main+0x336>
		arr[i] = -1;
	}



	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	68 38 20 80 00       	push   $0x802038
  800390:	e8 00 06 00 00       	call   800995 <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  panic("PLACEMENT of stack page failed");
  800398:	8a 85 a8 ff ff fe    	mov    -0x1000058(%ebp),%al
  80039e:	3c ff                	cmp    $0xff,%al
  8003a0:	74 14                	je     8003b6 <_main+0x37e>
  8003a2:	83 ec 04             	sub    $0x4,%esp
  8003a5:	68 68 20 80 00       	push   $0x802068
  8003aa:	6a 3f                	push   $0x3f
  8003ac:	68 21 20 80 00       	push   $0x802021
  8003b1:	e8 3d 03 00 00       	call   8006f3 <_panic>
		if( arr[PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  8003b6:	8a 85 a8 0f 00 ff    	mov    -0xfff058(%ebp),%al
  8003bc:	3c ff                	cmp    $0xff,%al
  8003be:	74 14                	je     8003d4 <_main+0x39c>
  8003c0:	83 ec 04             	sub    $0x4,%esp
  8003c3:	68 68 20 80 00       	push   $0x802068
  8003c8:	6a 40                	push   $0x40
  8003ca:	68 21 20 80 00       	push   $0x802021
  8003cf:	e8 1f 03 00 00       	call   8006f3 <_panic>

		if( arr[PAGE_SIZE*1024] !=  -1)  panic("PLACEMENT of stack page failed");
  8003d4:	8a 85 a8 ff 3f ff    	mov    -0xc00058(%ebp),%al
  8003da:	3c ff                	cmp    $0xff,%al
  8003dc:	74 14                	je     8003f2 <_main+0x3ba>
  8003de:	83 ec 04             	sub    $0x4,%esp
  8003e1:	68 68 20 80 00       	push   $0x802068
  8003e6:	6a 42                	push   $0x42
  8003e8:	68 21 20 80 00       	push   $0x802021
  8003ed:	e8 01 03 00 00       	call   8006f3 <_panic>
		if( arr[PAGE_SIZE*1025] !=  -1)  panic("PLACEMENT of stack page failed");
  8003f2:	8a 85 a8 0f 40 ff    	mov    -0xbff058(%ebp),%al
  8003f8:	3c ff                	cmp    $0xff,%al
  8003fa:	74 14                	je     800410 <_main+0x3d8>
  8003fc:	83 ec 04             	sub    $0x4,%esp
  8003ff:	68 68 20 80 00       	push   $0x802068
  800404:	6a 43                	push   $0x43
  800406:	68 21 20 80 00       	push   $0x802021
  80040b:	e8 e3 02 00 00       	call   8006f3 <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  -1)  panic("PLACEMENT of stack page failed");
  800410:	8a 85 a8 ff 7f ff    	mov    -0x800058(%ebp),%al
  800416:	3c ff                	cmp    $0xff,%al
  800418:	74 14                	je     80042e <_main+0x3f6>
  80041a:	83 ec 04             	sub    $0x4,%esp
  80041d:	68 68 20 80 00       	push   $0x802068
  800422:	6a 45                	push   $0x45
  800424:	68 21 20 80 00       	push   $0x802021
  800429:	e8 c5 02 00 00       	call   8006f3 <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  80042e:	8a 85 a8 0f 80 ff    	mov    -0x7ff058(%ebp),%al
  800434:	3c ff                	cmp    $0xff,%al
  800436:	74 14                	je     80044c <_main+0x414>
  800438:	83 ec 04             	sub    $0x4,%esp
  80043b:	68 68 20 80 00       	push   $0x802068
  800440:	6a 46                	push   $0x46
  800442:	68 21 20 80 00       	push   $0x802021
  800447:	e8 a7 02 00 00       	call   8006f3 <_panic>


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5) panic("new stack pages are not written to Page File");
  80044c:	e8 bd 14 00 00       	call   80190e <sys_pf_calculate_allocated_pages>
  800451:	2b 45 ac             	sub    -0x54(%ebp),%eax
  800454:	83 f8 05             	cmp    $0x5,%eax
  800457:	74 14                	je     80046d <_main+0x435>
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	68 88 20 80 00       	push   $0x802088
  800461:	6a 49                	push   $0x49
  800463:	68 21 20 80 00       	push   $0x802021
  800468:	e8 86 02 00 00       	call   8006f3 <_panic>

		if( (freePages - sys_calculate_free_frames() ) != 9 ) panic("allocated memory size incorrect");
  80046d:	8b 5d a8             	mov    -0x58(%ebp),%ebx
  800470:	e8 16 14 00 00       	call   80188b <sys_calculate_free_frames>
  800475:	29 c3                	sub    %eax,%ebx
  800477:	89 d8                	mov    %ebx,%eax
  800479:	83 f8 09             	cmp    $0x9,%eax
  80047c:	74 14                	je     800492 <_main+0x45a>
  80047e:	83 ec 04             	sub    $0x4,%esp
  800481:	68 b8 20 80 00       	push   $0x8020b8
  800486:	6a 4b                	push   $0x4b
  800488:	68 21 20 80 00       	push   $0x802021
  80048d:	e8 61 02 00 00       	call   8006f3 <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  800492:	83 ec 0c             	sub    $0xc,%esp
  800495:	68 d8 20 80 00       	push   $0x8020d8
  80049a:	e8 f6 04 00 00       	call   800995 <cprintf>
  80049f:	83 c4 10             	add    $0x10,%esp


	uint32 expectedPages[20] = {0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x800000,0x801000,0x802000,0x803000,0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000, 0, 0};
  8004a2:	8d 85 58 ff ff fe    	lea    -0x10000a8(%ebp),%eax
  8004a8:	bb 00 22 80 00       	mov    $0x802200,%ebx
  8004ad:	ba 14 00 00 00       	mov    $0x14,%edx
  8004b2:	89 c7                	mov    %eax,%edi
  8004b4:	89 de                	mov    %ebx,%esi
  8004b6:	89 d1                	mov    %edx,%ecx
  8004b8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	cprintf("STEP B: checking WS entries ...\n");
  8004ba:	83 ec 0c             	sub    $0xc,%esp
  8004bd:	68 0c 21 80 00       	push   $0x80210c
  8004c2:	e8 ce 04 00 00       	call   800995 <cprintf>
  8004c7:	83 c4 10             	add    $0x10,%esp
	{
		CheckWSWithoutLastIndex(expectedPages, 20);
  8004ca:	83 ec 08             	sub    $0x8,%esp
  8004cd:	6a 14                	push   $0x14
  8004cf:	8d 85 58 ff ff fe    	lea    -0x10000a8(%ebp),%eax
  8004d5:	50                   	push   %eax
  8004d6:	e8 8a 02 00 00       	call   800765 <CheckWSWithoutLastIndex>
  8004db:	83 c4 10             	add    $0x10,%esp
	//		if( ROUNDDOWN(myEnv->__uptr_pws[14].virtual_address,PAGE_SIZE) !=  0xedffd000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	//		if( ROUNDDOWN(myEnv->__uptr_pws[15].virtual_address,PAGE_SIZE) !=  0xedffe000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	//		if( ROUNDDOWN(myEnv->__uptr_pws[16].virtual_address,PAGE_SIZE) !=  0xee3fd000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	//		if( ROUNDDOWN(myEnv->__uptr_pws[17].virtual_address,PAGE_SIZE) !=  0xee3fe000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
}
cprintf("STEP B passed: WS entries test are correct\n\n\n");
  8004de:	83 ec 0c             	sub    $0xc,%esp
  8004e1:	68 30 21 80 00       	push   $0x802130
  8004e6:	e8 aa 04 00 00       	call   800995 <cprintf>
  8004eb:	83 c4 10             	add    $0x10,%esp

cprintf("STEP C: checking working sets WHEN BECOMES FULL...\n");
  8004ee:	83 ec 0c             	sub    $0xc,%esp
  8004f1:	68 60 21 80 00       	push   $0x802160
  8004f6:	e8 9a 04 00 00       	call   800995 <cprintf>
  8004fb:	83 c4 10             	add    $0x10,%esp
{
	/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
	//if(myEnv->page_last_WS_index != 18) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

	i=PAGE_SIZE*1024*3;
  8004fe:	c7 45 e0 00 00 c0 00 	movl   $0xc00000,-0x20(%ebp)
	for(;i<=(PAGE_SIZE*1024*3+PAGE_SIZE);i++)
  800505:	eb 11                	jmp    800518 <_main+0x4e0>
	{
		arr[i] = -1;
  800507:	8d 95 a8 ff ff fe    	lea    -0x1000058(%ebp),%edx
  80050d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800510:	01 d0                	add    %edx,%eax
  800512:	c6 00 ff             	movb   $0xff,(%eax)
{
	/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
	//if(myEnv->page_last_WS_index != 18) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

	i=PAGE_SIZE*1024*3;
	for(;i<=(PAGE_SIZE*1024*3+PAGE_SIZE);i++)
  800515:	ff 45 e0             	incl   -0x20(%ebp)
  800518:	81 7d e0 00 10 c0 00 	cmpl   $0xc01000,-0x20(%ebp)
  80051f:	7e e6                	jle    800507 <_main+0x4cf>
	{
		arr[i] = -1;
	}

	if( arr[PAGE_SIZE*1024*3] !=  -1)  panic("PLACEMENT of stack page failed");
  800521:	8a 85 a8 ff bf ff    	mov    -0x400058(%ebp),%al
  800527:	3c ff                	cmp    $0xff,%al
  800529:	74 14                	je     80053f <_main+0x507>
  80052b:	83 ec 04             	sub    $0x4,%esp
  80052e:	68 68 20 80 00       	push   $0x802068
  800533:	6a 74                	push   $0x74
  800535:	68 21 20 80 00       	push   $0x802021
  80053a:	e8 b4 01 00 00       	call   8006f3 <_panic>
	if( arr[PAGE_SIZE*1024*3 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  80053f:	8a 85 a8 0f c0 ff    	mov    -0x3ff058(%ebp),%al
  800545:	3c ff                	cmp    $0xff,%al
  800547:	74 14                	je     80055d <_main+0x525>
  800549:	83 ec 04             	sub    $0x4,%esp
  80054c:	68 68 20 80 00       	push   $0x802068
  800551:	6a 75                	push   $0x75
  800553:	68 21 20 80 00       	push   $0x802021
  800558:	e8 96 01 00 00       	call   8006f3 <_panic>

	expectedPages[18] = 0xee7fd000;
  80055d:	c7 85 a0 ff ff fe 00 	movl   $0xee7fd000,-0x1000060(%ebp)
  800564:	d0 7f ee 
	expectedPages[19] = 0xee7fe000;
  800567:	c7 85 a4 ff ff fe 00 	movl   $0xee7fe000,-0x100005c(%ebp)
  80056e:	e0 7f ee 

	CheckWSWithoutLastIndex(expectedPages, 20);
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	6a 14                	push   $0x14
  800576:	8d 85 58 ff ff fe    	lea    -0x10000a8(%ebp),%eax
  80057c:	50                   	push   %eax
  80057d:	e8 e3 01 00 00       	call   800765 <CheckWSWithoutLastIndex>
  800582:	83 c4 10             	add    $0x10,%esp

	/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
	//if(myEnv->page_last_WS_index != 0) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

}
cprintf("STEP C passed: WS is FULL now\n\n\n");
  800585:	83 ec 0c             	sub    $0xc,%esp
  800588:	68 94 21 80 00       	push   $0x802194
  80058d:	e8 03 04 00 00       	call   800995 <cprintf>
  800592:	83 c4 10             	add    $0x10,%esp

cprintf("Congratulations!! Test of PAGE PLACEMENT completed successfully!!\n\n\n");
  800595:	83 ec 0c             	sub    $0xc,%esp
  800598:	68 b8 21 80 00       	push   $0x8021b8
  80059d:	e8 f3 03 00 00       	call   800995 <cprintf>
  8005a2:	83 c4 10             	add    $0x10,%esp
return;
  8005a5:	90                   	nop
}
  8005a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005a9:	5b                   	pop    %ebx
  8005aa:	5e                   	pop    %esi
  8005ab:	5f                   	pop    %edi
  8005ac:	5d                   	pop    %ebp
  8005ad:	c3                   	ret    

008005ae <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005ae:	55                   	push   %ebp
  8005af:	89 e5                	mov    %esp,%ebp
  8005b1:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005b4:	e8 07 12 00 00       	call   8017c0 <sys_getenvindex>
  8005b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005bf:	89 d0                	mov    %edx,%eax
  8005c1:	c1 e0 03             	shl    $0x3,%eax
  8005c4:	01 d0                	add    %edx,%eax
  8005c6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8005cd:	01 c8                	add    %ecx,%eax
  8005cf:	01 c0                	add    %eax,%eax
  8005d1:	01 d0                	add    %edx,%eax
  8005d3:	01 c0                	add    %eax,%eax
  8005d5:	01 d0                	add    %edx,%eax
  8005d7:	89 c2                	mov    %eax,%edx
  8005d9:	c1 e2 05             	shl    $0x5,%edx
  8005dc:	29 c2                	sub    %eax,%edx
  8005de:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8005e5:	89 c2                	mov    %eax,%edx
  8005e7:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8005ed:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f7:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8005fd:	84 c0                	test   %al,%al
  8005ff:	74 0f                	je     800610 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800601:	a1 20 30 80 00       	mov    0x803020,%eax
  800606:	05 40 3c 01 00       	add    $0x13c40,%eax
  80060b:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800610:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800614:	7e 0a                	jle    800620 <libmain+0x72>
		binaryname = argv[0];
  800616:	8b 45 0c             	mov    0xc(%ebp),%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	ff 75 0c             	pushl  0xc(%ebp)
  800626:	ff 75 08             	pushl  0x8(%ebp)
  800629:	e8 0a fa ff ff       	call   800038 <_main>
  80062e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800631:	e8 25 13 00 00       	call   80195b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800636:	83 ec 0c             	sub    $0xc,%esp
  800639:	68 68 22 80 00       	push   $0x802268
  80063e:	e8 52 03 00 00       	call   800995 <cprintf>
  800643:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800646:	a1 20 30 80 00       	mov    0x803020,%eax
  80064b:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800651:	a1 20 30 80 00       	mov    0x803020,%eax
  800656:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80065c:	83 ec 04             	sub    $0x4,%esp
  80065f:	52                   	push   %edx
  800660:	50                   	push   %eax
  800661:	68 90 22 80 00       	push   $0x802290
  800666:	e8 2a 03 00 00       	call   800995 <cprintf>
  80066b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80066e:	a1 20 30 80 00       	mov    0x803020,%eax
  800673:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800679:	a1 20 30 80 00       	mov    0x803020,%eax
  80067e:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800684:	83 ec 04             	sub    $0x4,%esp
  800687:	52                   	push   %edx
  800688:	50                   	push   %eax
  800689:	68 b8 22 80 00       	push   $0x8022b8
  80068e:	e8 02 03 00 00       	call   800995 <cprintf>
  800693:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800696:	a1 20 30 80 00       	mov    0x803020,%eax
  80069b:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8006a1:	83 ec 08             	sub    $0x8,%esp
  8006a4:	50                   	push   %eax
  8006a5:	68 f9 22 80 00       	push   $0x8022f9
  8006aa:	e8 e6 02 00 00       	call   800995 <cprintf>
  8006af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006b2:	83 ec 0c             	sub    $0xc,%esp
  8006b5:	68 68 22 80 00       	push   $0x802268
  8006ba:	e8 d6 02 00 00       	call   800995 <cprintf>
  8006bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006c2:	e8 ae 12 00 00       	call   801975 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006c7:	e8 19 00 00 00       	call   8006e5 <exit>
}
  8006cc:	90                   	nop
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	6a 00                	push   $0x0
  8006da:	e8 ad 10 00 00       	call   80178c <sys_env_destroy>
  8006df:	83 c4 10             	add    $0x10,%esp
}
  8006e2:	90                   	nop
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

008006e5 <exit>:

void
exit(void)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8006eb:	e8 02 11 00 00       	call   8017f2 <sys_env_exit>
}
  8006f0:	90                   	nop
  8006f1:	c9                   	leave  
  8006f2:	c3                   	ret    

008006f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006f3:	55                   	push   %ebp
  8006f4:	89 e5                	mov    %esp,%ebp
  8006f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8006fc:	83 c0 04             	add    $0x4,%eax
  8006ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800702:	a1 18 31 80 00       	mov    0x803118,%eax
  800707:	85 c0                	test   %eax,%eax
  800709:	74 16                	je     800721 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80070b:	a1 18 31 80 00       	mov    0x803118,%eax
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	50                   	push   %eax
  800714:	68 10 23 80 00       	push   $0x802310
  800719:	e8 77 02 00 00       	call   800995 <cprintf>
  80071e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800721:	a1 00 30 80 00       	mov    0x803000,%eax
  800726:	ff 75 0c             	pushl  0xc(%ebp)
  800729:	ff 75 08             	pushl  0x8(%ebp)
  80072c:	50                   	push   %eax
  80072d:	68 15 23 80 00       	push   $0x802315
  800732:	e8 5e 02 00 00       	call   800995 <cprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80073a:	8b 45 10             	mov    0x10(%ebp),%eax
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 f4             	pushl  -0xc(%ebp)
  800743:	50                   	push   %eax
  800744:	e8 e1 01 00 00       	call   80092a <vcprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	6a 00                	push   $0x0
  800751:	68 31 23 80 00       	push   $0x802331
  800756:	e8 cf 01 00 00       	call   80092a <vcprintf>
  80075b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80075e:	e8 82 ff ff ff       	call   8006e5 <exit>

	// should not return here
	while (1) ;
  800763:	eb fe                	jmp    800763 <_panic+0x70>

00800765 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80076b:	a1 20 30 80 00       	mov    0x803020,%eax
  800770:	8b 50 74             	mov    0x74(%eax),%edx
  800773:	8b 45 0c             	mov    0xc(%ebp),%eax
  800776:	39 c2                	cmp    %eax,%edx
  800778:	74 14                	je     80078e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80077a:	83 ec 04             	sub    $0x4,%esp
  80077d:	68 34 23 80 00       	push   $0x802334
  800782:	6a 26                	push   $0x26
  800784:	68 80 23 80 00       	push   $0x802380
  800789:	e8 65 ff ff ff       	call   8006f3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80078e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800795:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80079c:	e9 b6 00 00 00       	jmp    800857 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8007a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	01 d0                	add    %edx,%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	85 c0                	test   %eax,%eax
  8007b4:	75 08                	jne    8007be <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007b6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007b9:	e9 96 00 00 00       	jmp    800854 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8007be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007cc:	eb 5d                	jmp    80082b <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8007d3:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8007d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007dc:	c1 e2 04             	shl    $0x4,%edx
  8007df:	01 d0                	add    %edx,%eax
  8007e1:	8a 40 04             	mov    0x4(%eax),%al
  8007e4:	84 c0                	test   %al,%al
  8007e6:	75 40                	jne    800828 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8007ed:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8007f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007f6:	c1 e2 04             	shl    $0x4,%edx
  8007f9:	01 d0                	add    %edx,%eax
  8007fb:	8b 00                	mov    (%eax),%eax
  8007fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800800:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800803:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800808:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80080a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	01 c8                	add    %ecx,%eax
  800819:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80081b:	39 c2                	cmp    %eax,%edx
  80081d:	75 09                	jne    800828 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  80081f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800826:	eb 12                	jmp    80083a <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800828:	ff 45 e8             	incl   -0x18(%ebp)
  80082b:	a1 20 30 80 00       	mov    0x803020,%eax
  800830:	8b 50 74             	mov    0x74(%eax),%edx
  800833:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800836:	39 c2                	cmp    %eax,%edx
  800838:	77 94                	ja     8007ce <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80083a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80083e:	75 14                	jne    800854 <CheckWSWithoutLastIndex+0xef>
			panic(
  800840:	83 ec 04             	sub    $0x4,%esp
  800843:	68 8c 23 80 00       	push   $0x80238c
  800848:	6a 3a                	push   $0x3a
  80084a:	68 80 23 80 00       	push   $0x802380
  80084f:	e8 9f fe ff ff       	call   8006f3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800854:	ff 45 f0             	incl   -0x10(%ebp)
  800857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80085d:	0f 8c 3e ff ff ff    	jl     8007a1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800863:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80086a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800871:	eb 20                	jmp    800893 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800873:	a1 20 30 80 00       	mov    0x803020,%eax
  800878:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80087e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800881:	c1 e2 04             	shl    $0x4,%edx
  800884:	01 d0                	add    %edx,%eax
  800886:	8a 40 04             	mov    0x4(%eax),%al
  800889:	3c 01                	cmp    $0x1,%al
  80088b:	75 03                	jne    800890 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80088d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800890:	ff 45 e0             	incl   -0x20(%ebp)
  800893:	a1 20 30 80 00       	mov    0x803020,%eax
  800898:	8b 50 74             	mov    0x74(%eax),%edx
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	39 c2                	cmp    %eax,%edx
  8008a0:	77 d1                	ja     800873 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008a8:	74 14                	je     8008be <CheckWSWithoutLastIndex+0x159>
		panic(
  8008aa:	83 ec 04             	sub    $0x4,%esp
  8008ad:	68 e0 23 80 00       	push   $0x8023e0
  8008b2:	6a 44                	push   $0x44
  8008b4:	68 80 23 80 00       	push   $0x802380
  8008b9:	e8 35 fe ff ff       	call   8006f3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008be:	90                   	nop
  8008bf:	c9                   	leave  
  8008c0:	c3                   	ret    

008008c1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8008cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d2:	89 0a                	mov    %ecx,(%edx)
  8008d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d7:	88 d1                	mov    %dl,%cl
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008ea:	75 2c                	jne    800918 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008ec:	a0 24 30 80 00       	mov    0x803024,%al
  8008f1:	0f b6 c0             	movzbl %al,%eax
  8008f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f7:	8b 12                	mov    (%edx),%edx
  8008f9:	89 d1                	mov    %edx,%ecx
  8008fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fe:	83 c2 08             	add    $0x8,%edx
  800901:	83 ec 04             	sub    $0x4,%esp
  800904:	50                   	push   %eax
  800905:	51                   	push   %ecx
  800906:	52                   	push   %edx
  800907:	e8 3e 0e 00 00       	call   80174a <sys_cputs>
  80090c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091b:	8b 40 04             	mov    0x4(%eax),%eax
  80091e:	8d 50 01             	lea    0x1(%eax),%edx
  800921:	8b 45 0c             	mov    0xc(%ebp),%eax
  800924:	89 50 04             	mov    %edx,0x4(%eax)
}
  800927:	90                   	nop
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800933:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80093a:	00 00 00 
	b.cnt = 0;
  80093d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800944:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	ff 75 08             	pushl  0x8(%ebp)
  80094d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800953:	50                   	push   %eax
  800954:	68 c1 08 80 00       	push   $0x8008c1
  800959:	e8 11 02 00 00       	call   800b6f <vprintfmt>
  80095e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800961:	a0 24 30 80 00       	mov    0x803024,%al
  800966:	0f b6 c0             	movzbl %al,%eax
  800969:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	50                   	push   %eax
  800973:	52                   	push   %edx
  800974:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80097a:	83 c0 08             	add    $0x8,%eax
  80097d:	50                   	push   %eax
  80097e:	e8 c7 0d 00 00       	call   80174a <sys_cputs>
  800983:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800986:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80098d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <cprintf>:

int cprintf(const char *fmt, ...) {
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80099b:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b1:	50                   	push   %eax
  8009b2:	e8 73 ff ff ff       	call   80092a <vcprintf>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c0:	c9                   	leave  
  8009c1:	c3                   	ret    

008009c2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009c8:	e8 8e 0f 00 00       	call   80195b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009cd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009dc:	50                   	push   %eax
  8009dd:	e8 48 ff ff ff       	call   80092a <vcprintf>
  8009e2:	83 c4 10             	add    $0x10,%esp
  8009e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009e8:	e8 88 0f 00 00       	call   801975 <sys_enable_interrupt>
	return cnt;
  8009ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	53                   	push   %ebx
  8009f6:	83 ec 14             	sub    $0x14,%esp
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a05:	8b 45 18             	mov    0x18(%ebp),%eax
  800a08:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a10:	77 55                	ja     800a67 <printnum+0x75>
  800a12:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a15:	72 05                	jb     800a1c <printnum+0x2a>
  800a17:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a1a:	77 4b                	ja     800a67 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a1c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a1f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a22:	8b 45 18             	mov    0x18(%ebp),%eax
  800a25:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2a:	52                   	push   %edx
  800a2b:	50                   	push   %eax
  800a2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2f:	ff 75 f0             	pushl  -0x10(%ebp)
  800a32:	e8 45 13 00 00       	call   801d7c <__udivdi3>
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	83 ec 04             	sub    $0x4,%esp
  800a3d:	ff 75 20             	pushl  0x20(%ebp)
  800a40:	53                   	push   %ebx
  800a41:	ff 75 18             	pushl  0x18(%ebp)
  800a44:	52                   	push   %edx
  800a45:	50                   	push   %eax
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	ff 75 08             	pushl  0x8(%ebp)
  800a4c:	e8 a1 ff ff ff       	call   8009f2 <printnum>
  800a51:	83 c4 20             	add    $0x20,%esp
  800a54:	eb 1a                	jmp    800a70 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	ff 75 20             	pushl  0x20(%ebp)
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a67:	ff 4d 1c             	decl   0x1c(%ebp)
  800a6a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a6e:	7f e6                	jg     800a56 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a70:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7e:	53                   	push   %ebx
  800a7f:	51                   	push   %ecx
  800a80:	52                   	push   %edx
  800a81:	50                   	push   %eax
  800a82:	e8 05 14 00 00       	call   801e8c <__umoddi3>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	05 54 26 80 00       	add    $0x802654,%eax
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	0f be c0             	movsbl %al,%eax
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
}
  800aa3:	90                   	nop
  800aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    

00800aa9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ab0:	7e 1c                	jle    800ace <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 00                	mov    (%eax),%eax
  800ab7:	8d 50 08             	lea    0x8(%eax),%edx
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	89 10                	mov    %edx,(%eax)
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	83 e8 08             	sub    $0x8,%eax
  800ac7:	8b 50 04             	mov    0x4(%eax),%edx
  800aca:	8b 00                	mov    (%eax),%eax
  800acc:	eb 40                	jmp    800b0e <getuint+0x65>
	else if (lflag)
  800ace:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad2:	74 1e                	je     800af2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	8d 50 04             	lea    0x4(%eax),%edx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	89 10                	mov    %edx,(%eax)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	83 e8 04             	sub    $0x4,%eax
  800ae9:	8b 00                	mov    (%eax),%eax
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	eb 1c                	jmp    800b0e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 50 04             	lea    0x4(%eax),%edx
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	89 10                	mov    %edx,(%eax)
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 00                	mov    (%eax),%eax
  800b04:	83 e8 04             	sub    $0x4,%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b13:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b17:	7e 1c                	jle    800b35 <getint+0x25>
		return va_arg(*ap, long long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 08             	lea    0x8(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 08             	sub    $0x8,%eax
  800b2e:	8b 50 04             	mov    0x4(%eax),%edx
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	eb 38                	jmp    800b6d <getint+0x5d>
	else if (lflag)
  800b35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b39:	74 1a                	je     800b55 <getint+0x45>
		return va_arg(*ap, long);
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	8d 50 04             	lea    0x4(%eax),%edx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	89 10                	mov    %edx,(%eax)
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 00                	mov    (%eax),%eax
  800b4d:	83 e8 04             	sub    $0x4,%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	99                   	cltd   
  800b53:	eb 18                	jmp    800b6d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 50 04             	lea    0x4(%eax),%edx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 10                	mov    %edx,(%eax)
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	83 e8 04             	sub    $0x4,%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	99                   	cltd   
}
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b77:	eb 17                	jmp    800b90 <vprintfmt+0x21>
			if (ch == '\0')
  800b79:	85 db                	test   %ebx,%ebx
  800b7b:	0f 84 af 03 00 00    	je     800f30 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	53                   	push   %ebx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	8d 50 01             	lea    0x1(%eax),%edx
  800b96:	89 55 10             	mov    %edx,0x10(%ebp)
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	0f b6 d8             	movzbl %al,%ebx
  800b9e:	83 fb 25             	cmp    $0x25,%ebx
  800ba1:	75 d6                	jne    800b79 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ba3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ba7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bb5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bbc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc6:	8d 50 01             	lea    0x1(%eax),%edx
  800bc9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	0f b6 d8             	movzbl %al,%ebx
  800bd1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bd4:	83 f8 55             	cmp    $0x55,%eax
  800bd7:	0f 87 2b 03 00 00    	ja     800f08 <vprintfmt+0x399>
  800bdd:	8b 04 85 78 26 80 00 	mov    0x802678(,%eax,4),%eax
  800be4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800be6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bea:	eb d7                	jmp    800bc3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bec:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bf0:	eb d1                	jmp    800bc3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bf9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bfc:	89 d0                	mov    %edx,%eax
  800bfe:	c1 e0 02             	shl    $0x2,%eax
  800c01:	01 d0                	add    %edx,%eax
  800c03:	01 c0                	add    %eax,%eax
  800c05:	01 d8                	add    %ebx,%eax
  800c07:	83 e8 30             	sub    $0x30,%eax
  800c0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c15:	83 fb 2f             	cmp    $0x2f,%ebx
  800c18:	7e 3e                	jle    800c58 <vprintfmt+0xe9>
  800c1a:	83 fb 39             	cmp    $0x39,%ebx
  800c1d:	7f 39                	jg     800c58 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c1f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c22:	eb d5                	jmp    800bf9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c24:	8b 45 14             	mov    0x14(%ebp),%eax
  800c27:	83 c0 04             	add    $0x4,%eax
  800c2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 e8 04             	sub    $0x4,%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c38:	eb 1f                	jmp    800c59 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c3e:	79 83                	jns    800bc3 <vprintfmt+0x54>
				width = 0;
  800c40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c47:	e9 77 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c4c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c53:	e9 6b ff ff ff       	jmp    800bc3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c58:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5d:	0f 89 60 ff ff ff    	jns    800bc3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c69:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c70:	e9 4e ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c75:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c78:	e9 46 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 c0 04             	add    $0x4,%eax
  800c83:	89 45 14             	mov    %eax,0x14(%ebp)
  800c86:	8b 45 14             	mov    0x14(%ebp),%eax
  800c89:	83 e8 04             	sub    $0x4,%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	ff d0                	call   *%eax
  800c9a:	83 c4 10             	add    $0x10,%esp
			break;
  800c9d:	e9 89 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ca2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca5:	83 c0 04             	add    $0x4,%eax
  800ca8:	89 45 14             	mov    %eax,0x14(%ebp)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 e8 04             	sub    $0x4,%eax
  800cb1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cb3:	85 db                	test   %ebx,%ebx
  800cb5:	79 02                	jns    800cb9 <vprintfmt+0x14a>
				err = -err;
  800cb7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cb9:	83 fb 64             	cmp    $0x64,%ebx
  800cbc:	7f 0b                	jg     800cc9 <vprintfmt+0x15a>
  800cbe:	8b 34 9d c0 24 80 00 	mov    0x8024c0(,%ebx,4),%esi
  800cc5:	85 f6                	test   %esi,%esi
  800cc7:	75 19                	jne    800ce2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cc9:	53                   	push   %ebx
  800cca:	68 65 26 80 00       	push   $0x802665
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	ff 75 08             	pushl  0x8(%ebp)
  800cd5:	e8 5e 02 00 00       	call   800f38 <printfmt>
  800cda:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cdd:	e9 49 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ce2:	56                   	push   %esi
  800ce3:	68 6e 26 80 00       	push   $0x80266e
  800ce8:	ff 75 0c             	pushl  0xc(%ebp)
  800ceb:	ff 75 08             	pushl  0x8(%ebp)
  800cee:	e8 45 02 00 00       	call   800f38 <printfmt>
  800cf3:	83 c4 10             	add    $0x10,%esp
			break;
  800cf6:	e9 30 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfe:	83 c0 04             	add    $0x4,%eax
  800d01:	89 45 14             	mov    %eax,0x14(%ebp)
  800d04:	8b 45 14             	mov    0x14(%ebp),%eax
  800d07:	83 e8 04             	sub    $0x4,%eax
  800d0a:	8b 30                	mov    (%eax),%esi
  800d0c:	85 f6                	test   %esi,%esi
  800d0e:	75 05                	jne    800d15 <vprintfmt+0x1a6>
				p = "(null)";
  800d10:	be 71 26 80 00       	mov    $0x802671,%esi
			if (width > 0 && padc != '-')
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	7e 6d                	jle    800d88 <vprintfmt+0x219>
  800d1b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d1f:	74 67                	je     800d88 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d24:	83 ec 08             	sub    $0x8,%esp
  800d27:	50                   	push   %eax
  800d28:	56                   	push   %esi
  800d29:	e8 0c 03 00 00       	call   80103a <strnlen>
  800d2e:	83 c4 10             	add    $0x10,%esp
  800d31:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d34:	eb 16                	jmp    800d4c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d36:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d3a:	83 ec 08             	sub    $0x8,%esp
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	50                   	push   %eax
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	ff d0                	call   *%eax
  800d46:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d49:	ff 4d e4             	decl   -0x1c(%ebp)
  800d4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d50:	7f e4                	jg     800d36 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d52:	eb 34                	jmp    800d88 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d54:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d58:	74 1c                	je     800d76 <vprintfmt+0x207>
  800d5a:	83 fb 1f             	cmp    $0x1f,%ebx
  800d5d:	7e 05                	jle    800d64 <vprintfmt+0x1f5>
  800d5f:	83 fb 7e             	cmp    $0x7e,%ebx
  800d62:	7e 12                	jle    800d76 <vprintfmt+0x207>
					putch('?', putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	6a 3f                	push   $0x3f
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	ff d0                	call   *%eax
  800d71:	83 c4 10             	add    $0x10,%esp
  800d74:	eb 0f                	jmp    800d85 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d76:	83 ec 08             	sub    $0x8,%esp
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	53                   	push   %ebx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	ff d0                	call   *%eax
  800d82:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d85:	ff 4d e4             	decl   -0x1c(%ebp)
  800d88:	89 f0                	mov    %esi,%eax
  800d8a:	8d 70 01             	lea    0x1(%eax),%esi
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f be d8             	movsbl %al,%ebx
  800d92:	85 db                	test   %ebx,%ebx
  800d94:	74 24                	je     800dba <vprintfmt+0x24b>
  800d96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d9a:	78 b8                	js     800d54 <vprintfmt+0x1e5>
  800d9c:	ff 4d e0             	decl   -0x20(%ebp)
  800d9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800da3:	79 af                	jns    800d54 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	eb 13                	jmp    800dba <vprintfmt+0x24b>
				putch(' ', putdat);
  800da7:	83 ec 08             	sub    $0x8,%esp
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	6a 20                	push   $0x20
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	ff d0                	call   *%eax
  800db4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db7:	ff 4d e4             	decl   -0x1c(%ebp)
  800dba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbe:	7f e7                	jg     800da7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dc0:	e9 66 01 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 e8             	pushl  -0x18(%ebp)
  800dcb:	8d 45 14             	lea    0x14(%ebp),%eax
  800dce:	50                   	push   %eax
  800dcf:	e8 3c fd ff ff       	call   800b10 <getint>
  800dd4:	83 c4 10             	add    $0x10,%esp
  800dd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dda:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de3:	85 d2                	test   %edx,%edx
  800de5:	79 23                	jns    800e0a <vprintfmt+0x29b>
				putch('-', putdat);
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	ff 75 0c             	pushl  0xc(%ebp)
  800ded:	6a 2d                	push   $0x2d
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	ff d0                	call   *%eax
  800df4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfd:	f7 d8                	neg    %eax
  800dff:	83 d2 00             	adc    $0x0,%edx
  800e02:	f7 da                	neg    %edx
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e11:	e9 bc 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 e8             	pushl  -0x18(%ebp)
  800e1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e1f:	50                   	push   %eax
  800e20:	e8 84 fc ff ff       	call   800aa9 <getuint>
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e35:	e9 98 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	ff 75 0c             	pushl  0xc(%ebp)
  800e40:	6a 58                	push   $0x58
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	ff d0                	call   *%eax
  800e47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	6a 58                	push   $0x58
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	ff d0                	call   *%eax
  800e57:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e5a:	83 ec 08             	sub    $0x8,%esp
  800e5d:	ff 75 0c             	pushl  0xc(%ebp)
  800e60:	6a 58                	push   $0x58
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	ff d0                	call   *%eax
  800e67:	83 c4 10             	add    $0x10,%esp
			break;
  800e6a:	e9 bc 00 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e6f:	83 ec 08             	sub    $0x8,%esp
  800e72:	ff 75 0c             	pushl  0xc(%ebp)
  800e75:	6a 30                	push   $0x30
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	ff d0                	call   *%eax
  800e7c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 78                	push   $0x78
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eaa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eb1:	eb 1f                	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	ff 75 e8             	pushl  -0x18(%ebp)
  800eb9:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebc:	50                   	push   %eax
  800ebd:	e8 e7 fb ff ff       	call   800aa9 <getuint>
  800ec2:	83 c4 10             	add    $0x10,%esp
  800ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ecb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ed2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ed9:	83 ec 04             	sub    $0x4,%esp
  800edc:	52                   	push   %edx
  800edd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ee0:	50                   	push   %eax
  800ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ee7:	ff 75 0c             	pushl  0xc(%ebp)
  800eea:	ff 75 08             	pushl  0x8(%ebp)
  800eed:	e8 00 fb ff ff       	call   8009f2 <printnum>
  800ef2:	83 c4 20             	add    $0x20,%esp
			break;
  800ef5:	eb 34                	jmp    800f2b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	53                   	push   %ebx
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			break;
  800f06:	eb 23                	jmp    800f2b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	6a 25                	push   $0x25
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	ff d0                	call   *%eax
  800f15:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	eb 03                	jmp    800f20 <vprintfmt+0x3b1>
  800f1d:	ff 4d 10             	decl   0x10(%ebp)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	48                   	dec    %eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 25                	cmp    $0x25,%al
  800f28:	75 f3                	jne    800f1d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f2a:	90                   	nop
		}
	}
  800f2b:	e9 47 fc ff ff       	jmp    800b77 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f30:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f3e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4d:	50                   	push   %eax
  800f4e:	ff 75 0c             	pushl  0xc(%ebp)
  800f51:	ff 75 08             	pushl  0x8(%ebp)
  800f54:	e8 16 fc ff ff       	call   800b6f <vprintfmt>
  800f59:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f5c:	90                   	nop
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	8b 40 08             	mov    0x8(%eax),%eax
  800f68:	8d 50 01             	lea    0x1(%eax),%edx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8b 10                	mov    (%eax),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	8b 40 04             	mov    0x4(%eax),%eax
  800f7c:	39 c2                	cmp    %eax,%edx
  800f7e:	73 12                	jae    800f92 <sprintputch+0x33>
		*b->buf++ = ch;
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	8b 00                	mov    (%eax),%eax
  800f85:	8d 48 01             	lea    0x1(%eax),%ecx
  800f88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8b:	89 0a                	mov    %ecx,(%edx)
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	88 10                	mov    %dl,(%eax)
}
  800f92:	90                   	nop
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	01 d0                	add    %edx,%eax
  800fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800faf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fba:	74 06                	je     800fc2 <vsnprintf+0x2d>
  800fbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc0:	7f 07                	jg     800fc9 <vsnprintf+0x34>
		return -E_INVAL;
  800fc2:	b8 03 00 00 00       	mov    $0x3,%eax
  800fc7:	eb 20                	jmp    800fe9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fc9:	ff 75 14             	pushl  0x14(%ebp)
  800fcc:	ff 75 10             	pushl  0x10(%ebp)
  800fcf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fd2:	50                   	push   %eax
  800fd3:	68 5f 0f 80 00       	push   $0x800f5f
  800fd8:	e8 92 fb ff ff       	call   800b6f <vprintfmt>
  800fdd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ff1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff4:	83 c0 04             	add    $0x4,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	ff 75 f4             	pushl  -0xc(%ebp)
  801000:	50                   	push   %eax
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	ff 75 08             	pushl  0x8(%ebp)
  801007:	e8 89 ff ff ff       	call   800f95 <vsnprintf>
  80100c:	83 c4 10             	add    $0x10,%esp
  80100f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801012:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80101d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801024:	eb 06                	jmp    80102c <strlen+0x15>
		n++;
  801026:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801029:	ff 45 08             	incl   0x8(%ebp)
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	84 c0                	test   %al,%al
  801033:	75 f1                	jne    801026 <strlen+0xf>
		n++;
	return n;
  801035:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801047:	eb 09                	jmp    801052 <strnlen+0x18>
		n++;
  801049:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104c:	ff 45 08             	incl   0x8(%ebp)
  80104f:	ff 4d 0c             	decl   0xc(%ebp)
  801052:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801056:	74 09                	je     801061 <strnlen+0x27>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e8                	jne    801049 <strnlen+0xf>
		n++;
	return n;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801072:	90                   	nop
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8d 50 01             	lea    0x1(%eax),%edx
  801079:	89 55 08             	mov    %edx,0x8(%ebp)
  80107c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801082:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801085:	8a 12                	mov    (%edx),%dl
  801087:	88 10                	mov    %dl,(%eax)
  801089:	8a 00                	mov    (%eax),%al
  80108b:	84 c0                	test   %al,%al
  80108d:	75 e4                	jne    801073 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a7:	eb 1f                	jmp    8010c8 <strncpy+0x34>
		*dst++ = *src;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8d 50 01             	lea    0x1(%eax),%edx
  8010af:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b5:	8a 12                	mov    (%edx),%dl
  8010b7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	84 c0                	test   %al,%al
  8010c0:	74 03                	je     8010c5 <strncpy+0x31>
			src++;
  8010c2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010c5:	ff 45 fc             	incl   -0x4(%ebp)
  8010c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ce:	72 d9                	jb     8010a9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e5:	74 30                	je     801117 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010e7:	eb 16                	jmp    8010ff <strlcpy+0x2a>
			*dst++ = *src++;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8d 50 01             	lea    0x1(%eax),%edx
  8010ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fb:	8a 12                	mov    (%edx),%dl
  8010fd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ff:	ff 4d 10             	decl   0x10(%ebp)
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	74 09                	je     801111 <strlcpy+0x3c>
  801108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	84 c0                	test   %al,%al
  80110f:	75 d8                	jne    8010e9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801117:	8b 55 08             	mov    0x8(%ebp),%edx
  80111a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111d:	29 c2                	sub    %eax,%edx
  80111f:	89 d0                	mov    %edx,%eax
}
  801121:	c9                   	leave  
  801122:	c3                   	ret    

00801123 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801126:	eb 06                	jmp    80112e <strcmp+0xb>
		p++, q++;
  801128:	ff 45 08             	incl   0x8(%ebp)
  80112b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	84 c0                	test   %al,%al
  801135:	74 0e                	je     801145 <strcmp+0x22>
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 10                	mov    (%eax),%dl
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	38 c2                	cmp    %al,%dl
  801143:	74 e3                	je     801128 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f b6 d0             	movzbl %al,%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	29 c2                	sub    %eax,%edx
  801157:	89 d0                	mov    %edx,%eax
}
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80115e:	eb 09                	jmp    801169 <strncmp+0xe>
		n--, p++, q++;
  801160:	ff 4d 10             	decl   0x10(%ebp)
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801169:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116d:	74 17                	je     801186 <strncmp+0x2b>
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	84 c0                	test   %al,%al
  801176:	74 0e                	je     801186 <strncmp+0x2b>
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 10                	mov    (%eax),%dl
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	38 c2                	cmp    %al,%dl
  801184:	74 da                	je     801160 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801186:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118a:	75 07                	jne    801193 <strncmp+0x38>
		return 0;
  80118c:	b8 00 00 00 00       	mov    $0x0,%eax
  801191:	eb 14                	jmp    8011a7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	0f b6 d0             	movzbl %al,%edx
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	0f b6 c0             	movzbl %al,%eax
  8011a3:	29 c2                	sub    %eax,%edx
  8011a5:	89 d0                	mov    %edx,%eax
}
  8011a7:	5d                   	pop    %ebp
  8011a8:	c3                   	ret    

008011a9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 04             	sub    $0x4,%esp
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b5:	eb 12                	jmp    8011c9 <strchr+0x20>
		if (*s == c)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011bf:	75 05                	jne    8011c6 <strchr+0x1d>
			return (char *) s;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	eb 11                	jmp    8011d7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011c6:	ff 45 08             	incl   0x8(%ebp)
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	84 c0                	test   %al,%al
  8011d0:	75 e5                	jne    8011b7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e5:	eb 0d                	jmp    8011f4 <strfind+0x1b>
		if (*s == c)
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ef:	74 0e                	je     8011ff <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011f1:	ff 45 08             	incl   0x8(%ebp)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	84 c0                	test   %al,%al
  8011fb:	75 ea                	jne    8011e7 <strfind+0xe>
  8011fd:	eb 01                	jmp    801200 <strfind+0x27>
		if (*s == c)
			break;
  8011ff:	90                   	nop
	return (char *) s;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801217:	eb 0e                	jmp    801227 <memset+0x22>
		*p++ = c;
  801219:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121c:	8d 50 01             	lea    0x1(%eax),%edx
  80121f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801222:	8b 55 0c             	mov    0xc(%ebp),%edx
  801225:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801227:	ff 4d f8             	decl   -0x8(%ebp)
  80122a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80122e:	79 e9                	jns    801219 <memset+0x14>
		*p++ = c;

	return v;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801247:	eb 16                	jmp    80125f <memcpy+0x2a>
		*d++ = *s++;
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	8d 50 01             	lea    0x1(%eax),%edx
  80124f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801252:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801255:	8d 4a 01             	lea    0x1(%edx),%ecx
  801258:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80125b:	8a 12                	mov    (%edx),%dl
  80125d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	8d 50 ff             	lea    -0x1(%eax),%edx
  801265:	89 55 10             	mov    %edx,0x10(%ebp)
  801268:	85 c0                	test   %eax,%eax
  80126a:	75 dd                	jne    801249 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801283:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801286:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801289:	73 50                	jae    8012db <memmove+0x6a>
  80128b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128e:	8b 45 10             	mov    0x10(%ebp),%eax
  801291:	01 d0                	add    %edx,%eax
  801293:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801296:	76 43                	jbe    8012db <memmove+0x6a>
		s += n;
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80129e:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012a4:	eb 10                	jmp    8012b6 <memmove+0x45>
			*--d = *--s;
  8012a6:	ff 4d f8             	decl   -0x8(%ebp)
  8012a9:	ff 4d fc             	decl   -0x4(%ebp)
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012af:	8a 10                	mov    (%eax),%dl
  8012b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	75 e3                	jne    8012a6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012c3:	eb 23                	jmp    8012e8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d7:	8a 12                	mov    (%edx),%dl
  8012d9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	75 dd                	jne    8012c5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ff:	eb 2a                	jmp    80132b <memcmp+0x3e>
		if (*s1 != *s2)
  801301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801304:	8a 10                	mov    (%eax),%dl
  801306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	38 c2                	cmp    %al,%dl
  80130d:	74 16                	je     801325 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	0f b6 d0             	movzbl %al,%edx
  801317:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f b6 c0             	movzbl %al,%eax
  80131f:	29 c2                	sub    %eax,%edx
  801321:	89 d0                	mov    %edx,%eax
  801323:	eb 18                	jmp    80133d <memcmp+0x50>
		s1++, s2++;
  801325:	ff 45 fc             	incl   -0x4(%ebp)
  801328:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80132b:	8b 45 10             	mov    0x10(%ebp),%eax
  80132e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801331:	89 55 10             	mov    %edx,0x10(%ebp)
  801334:	85 c0                	test   %eax,%eax
  801336:	75 c9                	jne    801301 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801345:	8b 55 08             	mov    0x8(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801350:	eb 15                	jmp    801367 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	0f b6 d0             	movzbl %al,%edx
  80135a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135d:	0f b6 c0             	movzbl %al,%eax
  801360:	39 c2                	cmp    %eax,%edx
  801362:	74 0d                	je     801371 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801364:	ff 45 08             	incl   0x8(%ebp)
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80136d:	72 e3                	jb     801352 <memfind+0x13>
  80136f:	eb 01                	jmp    801372 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801371:	90                   	nop
	return (void *) s;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80137d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801384:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138b:	eb 03                	jmp    801390 <strtol+0x19>
		s++;
  80138d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 20                	cmp    $0x20,%al
  801397:	74 f4                	je     80138d <strtol+0x16>
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	3c 09                	cmp    $0x9,%al
  8013a0:	74 eb                	je     80138d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	3c 2b                	cmp    $0x2b,%al
  8013a9:	75 05                	jne    8013b0 <strtol+0x39>
		s++;
  8013ab:	ff 45 08             	incl   0x8(%ebp)
  8013ae:	eb 13                	jmp    8013c3 <strtol+0x4c>
	else if (*s == '-')
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	3c 2d                	cmp    $0x2d,%al
  8013b7:	75 0a                	jne    8013c3 <strtol+0x4c>
		s++, neg = 1;
  8013b9:	ff 45 08             	incl   0x8(%ebp)
  8013bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c7:	74 06                	je     8013cf <strtol+0x58>
  8013c9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013cd:	75 20                	jne    8013ef <strtol+0x78>
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	3c 30                	cmp    $0x30,%al
  8013d6:	75 17                	jne    8013ef <strtol+0x78>
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	40                   	inc    %eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	3c 78                	cmp    $0x78,%al
  8013e0:	75 0d                	jne    8013ef <strtol+0x78>
		s += 2, base = 16;
  8013e2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013ed:	eb 28                	jmp    801417 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f3:	75 15                	jne    80140a <strtol+0x93>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	3c 30                	cmp    $0x30,%al
  8013fc:	75 0c                	jne    80140a <strtol+0x93>
		s++, base = 8;
  8013fe:	ff 45 08             	incl   0x8(%ebp)
  801401:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801408:	eb 0d                	jmp    801417 <strtol+0xa0>
	else if (base == 0)
  80140a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140e:	75 07                	jne    801417 <strtol+0xa0>
		base = 10;
  801410:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	3c 2f                	cmp    $0x2f,%al
  80141e:	7e 19                	jle    801439 <strtol+0xc2>
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	3c 39                	cmp    $0x39,%al
  801427:	7f 10                	jg     801439 <strtol+0xc2>
			dig = *s - '0';
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	0f be c0             	movsbl %al,%eax
  801431:	83 e8 30             	sub    $0x30,%eax
  801434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801437:	eb 42                	jmp    80147b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	3c 60                	cmp    $0x60,%al
  801440:	7e 19                	jle    80145b <strtol+0xe4>
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	3c 7a                	cmp    $0x7a,%al
  801449:	7f 10                	jg     80145b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	83 e8 57             	sub    $0x57,%eax
  801456:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801459:	eb 20                	jmp    80147b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	3c 40                	cmp    $0x40,%al
  801462:	7e 39                	jle    80149d <strtol+0x126>
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	3c 5a                	cmp    $0x5a,%al
  80146b:	7f 30                	jg     80149d <strtol+0x126>
			dig = *s - 'A' + 10;
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	0f be c0             	movsbl %al,%eax
  801475:	83 e8 37             	sub    $0x37,%eax
  801478:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801481:	7d 19                	jge    80149c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801483:	ff 45 08             	incl   0x8(%ebp)
  801486:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801489:	0f af 45 10          	imul   0x10(%ebp),%eax
  80148d:	89 c2                	mov    %eax,%edx
  80148f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801492:	01 d0                	add    %edx,%eax
  801494:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801497:	e9 7b ff ff ff       	jmp    801417 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80149c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80149d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a1:	74 08                	je     8014ab <strtol+0x134>
		*endptr = (char *) s;
  8014a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014af:	74 07                	je     8014b8 <strtol+0x141>
  8014b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b4:	f7 d8                	neg    %eax
  8014b6:	eb 03                	jmp    8014bb <strtol+0x144>
  8014b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <ltostr>:

void
ltostr(long value, char *str)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d5:	79 13                	jns    8014ea <ltostr+0x2d>
	{
		neg = 1;
  8014d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014e4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014e7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014f2:	99                   	cltd   
  8014f3:	f7 f9                	idiv   %ecx
  8014f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fb:	8d 50 01             	lea    0x1(%eax),%edx
  8014fe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801501:	89 c2                	mov    %eax,%edx
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	01 d0                	add    %edx,%eax
  801508:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80150b:	83 c2 30             	add    $0x30,%edx
  80150e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801510:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801513:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801518:	f7 e9                	imul   %ecx
  80151a:	c1 fa 02             	sar    $0x2,%edx
  80151d:	89 c8                	mov    %ecx,%eax
  80151f:	c1 f8 1f             	sar    $0x1f,%eax
  801522:	29 c2                	sub    %eax,%edx
  801524:	89 d0                	mov    %edx,%eax
  801526:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801529:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801531:	f7 e9                	imul   %ecx
  801533:	c1 fa 02             	sar    $0x2,%edx
  801536:	89 c8                	mov    %ecx,%eax
  801538:	c1 f8 1f             	sar    $0x1f,%eax
  80153b:	29 c2                	sub    %eax,%edx
  80153d:	89 d0                	mov    %edx,%eax
  80153f:	c1 e0 02             	shl    $0x2,%eax
  801542:	01 d0                	add    %edx,%eax
  801544:	01 c0                	add    %eax,%eax
  801546:	29 c1                	sub    %eax,%ecx
  801548:	89 ca                	mov    %ecx,%edx
  80154a:	85 d2                	test   %edx,%edx
  80154c:	75 9c                	jne    8014ea <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80154e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801555:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801558:	48                   	dec    %eax
  801559:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80155c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801560:	74 3d                	je     80159f <ltostr+0xe2>
		start = 1 ;
  801562:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801569:	eb 34                	jmp    80159f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80156b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801571:	01 d0                	add    %edx,%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 c2                	add    %eax,%edx
  801580:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	01 c8                	add    %ecx,%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80158c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	01 c2                	add    %eax,%edx
  801594:	8a 45 eb             	mov    -0x15(%ebp),%al
  801597:	88 02                	mov    %al,(%edx)
		start++ ;
  801599:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80159c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015a5:	7c c4                	jl     80156b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ad:	01 d0                	add    %edx,%eax
  8015af:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015b2:	90                   	nop
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 54 fa ff ff       	call   801017 <strlen>
  8015c3:	83 c4 04             	add    $0x4,%esp
  8015c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	e8 46 fa ff ff       	call   801017 <strlen>
  8015d1:	83 c4 04             	add    $0x4,%esp
  8015d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e5:	eb 17                	jmp    8015fe <strcconcat+0x49>
		final[s] = str1[s] ;
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ed:	01 c2                	add    %eax,%edx
  8015ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	01 c8                	add    %ecx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015fb:	ff 45 fc             	incl   -0x4(%ebp)
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801601:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801604:	7c e1                	jl     8015e7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801606:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80160d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801614:	eb 1f                	jmp    801635 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801616:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801619:	8d 50 01             	lea    0x1(%eax),%edx
  80161c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161f:	89 c2                	mov    %eax,%edx
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	01 c2                	add    %eax,%edx
  801626:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162c:	01 c8                	add    %ecx,%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801632:	ff 45 f8             	incl   -0x8(%ebp)
  801635:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801638:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80163b:	7c d9                	jl     801616 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80163d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	01 d0                	add    %edx,%eax
  801645:	c6 00 00             	movb   $0x0,(%eax)
}
  801648:	90                   	nop
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80164e:	8b 45 14             	mov    0x14(%ebp),%eax
  801651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801657:	8b 45 14             	mov    0x14(%ebp),%eax
  80165a:	8b 00                	mov    (%eax),%eax
  80165c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801663:	8b 45 10             	mov    0x10(%ebp),%eax
  801666:	01 d0                	add    %edx,%eax
  801668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166e:	eb 0c                	jmp    80167c <strsplit+0x31>
			*string++ = 0;
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	8d 50 01             	lea    0x1(%eax),%edx
  801676:	89 55 08             	mov    %edx,0x8(%ebp)
  801679:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	84 c0                	test   %al,%al
  801683:	74 18                	je     80169d <strsplit+0x52>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	0f be c0             	movsbl %al,%eax
  80168d:	50                   	push   %eax
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	e8 13 fb ff ff       	call   8011a9 <strchr>
  801696:	83 c4 08             	add    $0x8,%esp
  801699:	85 c0                	test   %eax,%eax
  80169b:	75 d3                	jne    801670 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8a 00                	mov    (%eax),%al
  8016a2:	84 c0                	test   %al,%al
  8016a4:	74 5a                	je     801700 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a9:	8b 00                	mov    (%eax),%eax
  8016ab:	83 f8 0f             	cmp    $0xf,%eax
  8016ae:	75 07                	jne    8016b7 <strsplit+0x6c>
		{
			return 0;
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	eb 66                	jmp    80171d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ba:	8b 00                	mov    (%eax),%eax
  8016bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8016bf:	8b 55 14             	mov    0x14(%ebp),%edx
  8016c2:	89 0a                	mov    %ecx,(%edx)
  8016c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ce:	01 c2                	add    %eax,%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016d5:	eb 03                	jmp    8016da <strsplit+0x8f>
			string++;
  8016d7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 8b                	je     80166e <strsplit+0x23>
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f be c0             	movsbl %al,%eax
  8016eb:	50                   	push   %eax
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	e8 b5 fa ff ff       	call   8011a9 <strchr>
  8016f4:	83 c4 08             	add    $0x8,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	74 dc                	je     8016d7 <strsplit+0x8c>
			string++;
	}
  8016fb:	e9 6e ff ff ff       	jmp    80166e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801700:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801701:	8b 45 14             	mov    0x14(%ebp),%eax
  801704:	8b 00                	mov    (%eax),%eax
  801706:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80170d:	8b 45 10             	mov    0x10(%ebp),%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801718:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	57                   	push   %edi
  801723:	56                   	push   %esi
  801724:	53                   	push   %ebx
  801725:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801731:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801734:	8b 7d 18             	mov    0x18(%ebp),%edi
  801737:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80173a:	cd 30                	int    $0x30
  80173c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80173f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801742:	83 c4 10             	add    $0x10,%esp
  801745:	5b                   	pop    %ebx
  801746:	5e                   	pop    %esi
  801747:	5f                   	pop    %edi
  801748:	5d                   	pop    %ebp
  801749:	c3                   	ret    

0080174a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 04             	sub    $0x4,%esp
  801750:	8b 45 10             	mov    0x10(%ebp),%eax
  801753:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801756:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	52                   	push   %edx
  801762:	ff 75 0c             	pushl  0xc(%ebp)
  801765:	50                   	push   %eax
  801766:	6a 00                	push   $0x0
  801768:	e8 b2 ff ff ff       	call   80171f <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
}
  801770:	90                   	nop
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_cgetc>:

int
sys_cgetc(void)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 01                	push   $0x1
  801782:	e8 98 ff ff ff       	call   80171f <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	50                   	push   %eax
  80179b:	6a 05                	push   $0x5
  80179d:	e8 7d ff ff ff       	call   80171f <syscall>
  8017a2:	83 c4 18             	add    $0x18,%esp
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 02                	push   $0x2
  8017b6:	e8 64 ff ff ff       	call   80171f <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 03                	push   $0x3
  8017cf:	e8 4b ff ff ff       	call   80171f <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 04                	push   $0x4
  8017e8:	e8 32 ff ff ff       	call   80171f <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <sys_env_exit>:


void sys_env_exit(void)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 06                	push   $0x6
  801801:	e8 19 ff ff ff       	call   80171f <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
}
  801809:	90                   	nop
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	52                   	push   %edx
  80181c:	50                   	push   %eax
  80181d:	6a 07                	push   $0x7
  80181f:	e8 fb fe ff ff       	call   80171f <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	56                   	push   %esi
  80182d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80182e:	8b 75 18             	mov    0x18(%ebp),%esi
  801831:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801834:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801837:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	56                   	push   %esi
  80183e:	53                   	push   %ebx
  80183f:	51                   	push   %ecx
  801840:	52                   	push   %edx
  801841:	50                   	push   %eax
  801842:	6a 08                	push   $0x8
  801844:	e8 d6 fe ff ff       	call   80171f <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80184f:	5b                   	pop    %ebx
  801850:	5e                   	pop    %esi
  801851:	5d                   	pop    %ebp
  801852:	c3                   	ret    

00801853 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801856:	8b 55 0c             	mov    0xc(%ebp),%edx
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	52                   	push   %edx
  801863:	50                   	push   %eax
  801864:	6a 09                	push   $0x9
  801866:	e8 b4 fe ff ff       	call   80171f <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	ff 75 0c             	pushl  0xc(%ebp)
  80187c:	ff 75 08             	pushl  0x8(%ebp)
  80187f:	6a 0a                	push   $0xa
  801881:	e8 99 fe ff ff       	call   80171f <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 0b                	push   $0xb
  80189a:	e8 80 fe ff ff       	call   80171f <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 0c                	push   $0xc
  8018b3:	e8 67 fe ff ff       	call   80171f <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 0d                	push   $0xd
  8018cc:	e8 4e fe ff ff       	call   80171f <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	ff 75 0c             	pushl  0xc(%ebp)
  8018e2:	ff 75 08             	pushl  0x8(%ebp)
  8018e5:	6a 11                	push   $0x11
  8018e7:	e8 33 fe ff ff       	call   80171f <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
	return;
  8018ef:	90                   	nop
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	ff 75 08             	pushl  0x8(%ebp)
  801901:	6a 12                	push   $0x12
  801903:	e8 17 fe ff ff       	call   80171f <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
	return ;
  80190b:	90                   	nop
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 0e                	push   $0xe
  80191d:	e8 fd fd ff ff       	call   80171f <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	ff 75 08             	pushl  0x8(%ebp)
  801935:	6a 0f                	push   $0xf
  801937:	e8 e3 fd ff ff       	call   80171f <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 10                	push   $0x10
  801950:	e8 ca fd ff ff       	call   80171f <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	90                   	nop
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 14                	push   $0x14
  80196a:	e8 b0 fd ff ff       	call   80171f <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	90                   	nop
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 15                	push   $0x15
  801984:	e8 96 fd ff ff       	call   80171f <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
}
  80198c:	90                   	nop
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_cputc>:


void
sys_cputc(const char c)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	83 ec 04             	sub    $0x4,%esp
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80199b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	50                   	push   %eax
  8019a8:	6a 16                	push   $0x16
  8019aa:	e8 70 fd ff ff       	call   80171f <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	90                   	nop
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 17                	push   $0x17
  8019c4:	e8 56 fd ff ff       	call   80171f <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	90                   	nop
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	50                   	push   %eax
  8019df:	6a 18                	push   $0x18
  8019e1:	e8 39 fd ff ff       	call   80171f <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	52                   	push   %edx
  8019fb:	50                   	push   %eax
  8019fc:	6a 1b                	push   $0x1b
  8019fe:	e8 1c fd ff ff       	call   80171f <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	52                   	push   %edx
  801a18:	50                   	push   %eax
  801a19:	6a 19                	push   $0x19
  801a1b:	e8 ff fc ff ff       	call   80171f <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	90                   	nop
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	52                   	push   %edx
  801a36:	50                   	push   %eax
  801a37:	6a 1a                	push   $0x1a
  801a39:	e8 e1 fc ff ff       	call   80171f <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	90                   	nop
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 04             	sub    $0x4,%esp
  801a4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a50:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a53:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	6a 00                	push   $0x0
  801a5c:	51                   	push   %ecx
  801a5d:	52                   	push   %edx
  801a5e:	ff 75 0c             	pushl  0xc(%ebp)
  801a61:	50                   	push   %eax
  801a62:	6a 1c                	push   $0x1c
  801a64:	e8 b6 fc ff ff       	call   80171f <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	52                   	push   %edx
  801a7e:	50                   	push   %eax
  801a7f:	6a 1d                	push   $0x1d
  801a81:	e8 99 fc ff ff       	call   80171f <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	51                   	push   %ecx
  801a9c:	52                   	push   %edx
  801a9d:	50                   	push   %eax
  801a9e:	6a 1e                	push   $0x1e
  801aa0:	e8 7a fc ff ff       	call   80171f <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	52                   	push   %edx
  801aba:	50                   	push   %eax
  801abb:	6a 1f                	push   $0x1f
  801abd:	e8 5d fc ff ff       	call   80171f <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 20                	push   $0x20
  801ad6:	e8 44 fc ff ff       	call   80171f <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	ff 75 10             	pushl  0x10(%ebp)
  801aed:	ff 75 0c             	pushl  0xc(%ebp)
  801af0:	50                   	push   %eax
  801af1:	6a 21                	push   $0x21
  801af3:	e8 27 fc ff ff       	call   80171f <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	50                   	push   %eax
  801b0c:	6a 22                	push   $0x22
  801b0e:	e8 0c fc ff ff       	call   80171f <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	90                   	nop
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	50                   	push   %eax
  801b28:	6a 23                	push   $0x23
  801b2a:	e8 f0 fb ff ff       	call   80171f <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	90                   	nop
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b3b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b3e:	8d 50 04             	lea    0x4(%eax),%edx
  801b41:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	52                   	push   %edx
  801b4b:	50                   	push   %eax
  801b4c:	6a 24                	push   $0x24
  801b4e:	e8 cc fb ff ff       	call   80171f <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
	return result;
  801b56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b5f:	89 01                	mov    %eax,(%ecx)
  801b61:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	c9                   	leave  
  801b68:	c2 04 00             	ret    $0x4

00801b6b <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	ff 75 10             	pushl  0x10(%ebp)
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	6a 13                	push   $0x13
  801b7d:	e8 9d fb ff ff       	call   80171f <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	return ;
  801b85:	90                   	nop
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 25                	push   $0x25
  801b97:	e8 83 fb ff ff       	call   80171f <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 04             	sub    $0x4,%esp
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bad:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	50                   	push   %eax
  801bba:	6a 26                	push   $0x26
  801bbc:	e8 5e fb ff ff       	call   80171f <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc4:	90                   	nop
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <rsttst>:
void rsttst()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 28                	push   $0x28
  801bd6:	e8 44 fb ff ff       	call   80171f <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bde:	90                   	nop
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 04             	sub    $0x4,%esp
  801be7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bed:	8b 55 18             	mov    0x18(%ebp),%edx
  801bf0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bf4:	52                   	push   %edx
  801bf5:	50                   	push   %eax
  801bf6:	ff 75 10             	pushl  0x10(%ebp)
  801bf9:	ff 75 0c             	pushl  0xc(%ebp)
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	6a 27                	push   $0x27
  801c01:	e8 19 fb ff ff       	call   80171f <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
	return ;
  801c09:	90                   	nop
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <chktst>:
void chktst(uint32 n)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	ff 75 08             	pushl  0x8(%ebp)
  801c1a:	6a 29                	push   $0x29
  801c1c:	e8 fe fa ff ff       	call   80171f <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
	return ;
  801c24:	90                   	nop
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <inctst>:

void inctst()
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 2a                	push   $0x2a
  801c36:	e8 e4 fa ff ff       	call   80171f <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3e:	90                   	nop
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <gettst>:
uint32 gettst()
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 2b                	push   $0x2b
  801c50:	e8 ca fa ff ff       	call   80171f <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 2c                	push   $0x2c
  801c6c:	e8 ae fa ff ff       	call   80171f <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
  801c74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c77:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c7b:	75 07                	jne    801c84 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c82:	eb 05                	jmp    801c89 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 2c                	push   $0x2c
  801c9d:	e8 7d fa ff ff       	call   80171f <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
  801ca5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ca8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cac:	75 07                	jne    801cb5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cae:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb3:	eb 05                	jmp    801cba <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 2c                	push   $0x2c
  801cce:	e8 4c fa ff ff       	call   80171f <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
  801cd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cd9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cdd:	75 07                	jne    801ce6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cdf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce4:	eb 05                	jmp    801ceb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ce6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 2c                	push   $0x2c
  801cff:	e8 1b fa ff ff       	call   80171f <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
  801d07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d0a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d0e:	75 07                	jne    801d17 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d10:	b8 01 00 00 00       	mov    $0x1,%eax
  801d15:	eb 05                	jmp    801d1c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	ff 75 08             	pushl  0x8(%ebp)
  801d2c:	6a 2d                	push   $0x2d
  801d2e:	e8 ec f9 ff ff       	call   80171f <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
	return ;
  801d36:	90                   	nop
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d3d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	6a 00                	push   $0x0
  801d4b:	53                   	push   %ebx
  801d4c:	51                   	push   %ecx
  801d4d:	52                   	push   %edx
  801d4e:	50                   	push   %eax
  801d4f:	6a 2e                	push   $0x2e
  801d51:	e8 c9 f9 ff ff       	call   80171f <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	52                   	push   %edx
  801d6e:	50                   	push   %eax
  801d6f:	6a 2f                	push   $0x2f
  801d71:	e8 a9 f9 ff ff       	call   80171f <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    
  801d7b:	90                   	nop

00801d7c <__udivdi3>:
  801d7c:	55                   	push   %ebp
  801d7d:	57                   	push   %edi
  801d7e:	56                   	push   %esi
  801d7f:	53                   	push   %ebx
  801d80:	83 ec 1c             	sub    $0x1c,%esp
  801d83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d93:	89 ca                	mov    %ecx,%edx
  801d95:	89 f8                	mov    %edi,%eax
  801d97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d9b:	85 f6                	test   %esi,%esi
  801d9d:	75 2d                	jne    801dcc <__udivdi3+0x50>
  801d9f:	39 cf                	cmp    %ecx,%edi
  801da1:	77 65                	ja     801e08 <__udivdi3+0x8c>
  801da3:	89 fd                	mov    %edi,%ebp
  801da5:	85 ff                	test   %edi,%edi
  801da7:	75 0b                	jne    801db4 <__udivdi3+0x38>
  801da9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dae:	31 d2                	xor    %edx,%edx
  801db0:	f7 f7                	div    %edi
  801db2:	89 c5                	mov    %eax,%ebp
  801db4:	31 d2                	xor    %edx,%edx
  801db6:	89 c8                	mov    %ecx,%eax
  801db8:	f7 f5                	div    %ebp
  801dba:	89 c1                	mov    %eax,%ecx
  801dbc:	89 d8                	mov    %ebx,%eax
  801dbe:	f7 f5                	div    %ebp
  801dc0:	89 cf                	mov    %ecx,%edi
  801dc2:	89 fa                	mov    %edi,%edx
  801dc4:	83 c4 1c             	add    $0x1c,%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5f                   	pop    %edi
  801dca:	5d                   	pop    %ebp
  801dcb:	c3                   	ret    
  801dcc:	39 ce                	cmp    %ecx,%esi
  801dce:	77 28                	ja     801df8 <__udivdi3+0x7c>
  801dd0:	0f bd fe             	bsr    %esi,%edi
  801dd3:	83 f7 1f             	xor    $0x1f,%edi
  801dd6:	75 40                	jne    801e18 <__udivdi3+0x9c>
  801dd8:	39 ce                	cmp    %ecx,%esi
  801dda:	72 0a                	jb     801de6 <__udivdi3+0x6a>
  801ddc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801de0:	0f 87 9e 00 00 00    	ja     801e84 <__udivdi3+0x108>
  801de6:	b8 01 00 00 00       	mov    $0x1,%eax
  801deb:	89 fa                	mov    %edi,%edx
  801ded:	83 c4 1c             	add    $0x1c,%esp
  801df0:	5b                   	pop    %ebx
  801df1:	5e                   	pop    %esi
  801df2:	5f                   	pop    %edi
  801df3:	5d                   	pop    %ebp
  801df4:	c3                   	ret    
  801df5:	8d 76 00             	lea    0x0(%esi),%esi
  801df8:	31 ff                	xor    %edi,%edi
  801dfa:	31 c0                	xor    %eax,%eax
  801dfc:	89 fa                	mov    %edi,%edx
  801dfe:	83 c4 1c             	add    $0x1c,%esp
  801e01:	5b                   	pop    %ebx
  801e02:	5e                   	pop    %esi
  801e03:	5f                   	pop    %edi
  801e04:	5d                   	pop    %ebp
  801e05:	c3                   	ret    
  801e06:	66 90                	xchg   %ax,%ax
  801e08:	89 d8                	mov    %ebx,%eax
  801e0a:	f7 f7                	div    %edi
  801e0c:	31 ff                	xor    %edi,%edi
  801e0e:	89 fa                	mov    %edi,%edx
  801e10:	83 c4 1c             	add    $0x1c,%esp
  801e13:	5b                   	pop    %ebx
  801e14:	5e                   	pop    %esi
  801e15:	5f                   	pop    %edi
  801e16:	5d                   	pop    %ebp
  801e17:	c3                   	ret    
  801e18:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e1d:	89 eb                	mov    %ebp,%ebx
  801e1f:	29 fb                	sub    %edi,%ebx
  801e21:	89 f9                	mov    %edi,%ecx
  801e23:	d3 e6                	shl    %cl,%esi
  801e25:	89 c5                	mov    %eax,%ebp
  801e27:	88 d9                	mov    %bl,%cl
  801e29:	d3 ed                	shr    %cl,%ebp
  801e2b:	89 e9                	mov    %ebp,%ecx
  801e2d:	09 f1                	or     %esi,%ecx
  801e2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e33:	89 f9                	mov    %edi,%ecx
  801e35:	d3 e0                	shl    %cl,%eax
  801e37:	89 c5                	mov    %eax,%ebp
  801e39:	89 d6                	mov    %edx,%esi
  801e3b:	88 d9                	mov    %bl,%cl
  801e3d:	d3 ee                	shr    %cl,%esi
  801e3f:	89 f9                	mov    %edi,%ecx
  801e41:	d3 e2                	shl    %cl,%edx
  801e43:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e47:	88 d9                	mov    %bl,%cl
  801e49:	d3 e8                	shr    %cl,%eax
  801e4b:	09 c2                	or     %eax,%edx
  801e4d:	89 d0                	mov    %edx,%eax
  801e4f:	89 f2                	mov    %esi,%edx
  801e51:	f7 74 24 0c          	divl   0xc(%esp)
  801e55:	89 d6                	mov    %edx,%esi
  801e57:	89 c3                	mov    %eax,%ebx
  801e59:	f7 e5                	mul    %ebp
  801e5b:	39 d6                	cmp    %edx,%esi
  801e5d:	72 19                	jb     801e78 <__udivdi3+0xfc>
  801e5f:	74 0b                	je     801e6c <__udivdi3+0xf0>
  801e61:	89 d8                	mov    %ebx,%eax
  801e63:	31 ff                	xor    %edi,%edi
  801e65:	e9 58 ff ff ff       	jmp    801dc2 <__udivdi3+0x46>
  801e6a:	66 90                	xchg   %ax,%ax
  801e6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e70:	89 f9                	mov    %edi,%ecx
  801e72:	d3 e2                	shl    %cl,%edx
  801e74:	39 c2                	cmp    %eax,%edx
  801e76:	73 e9                	jae    801e61 <__udivdi3+0xe5>
  801e78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e7b:	31 ff                	xor    %edi,%edi
  801e7d:	e9 40 ff ff ff       	jmp    801dc2 <__udivdi3+0x46>
  801e82:	66 90                	xchg   %ax,%ax
  801e84:	31 c0                	xor    %eax,%eax
  801e86:	e9 37 ff ff ff       	jmp    801dc2 <__udivdi3+0x46>
  801e8b:	90                   	nop

00801e8c <__umoddi3>:
  801e8c:	55                   	push   %ebp
  801e8d:	57                   	push   %edi
  801e8e:	56                   	push   %esi
  801e8f:	53                   	push   %ebx
  801e90:	83 ec 1c             	sub    $0x1c,%esp
  801e93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e97:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ea3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ea7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801eab:	89 f3                	mov    %esi,%ebx
  801ead:	89 fa                	mov    %edi,%edx
  801eaf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801eb3:	89 34 24             	mov    %esi,(%esp)
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	75 1a                	jne    801ed4 <__umoddi3+0x48>
  801eba:	39 f7                	cmp    %esi,%edi
  801ebc:	0f 86 a2 00 00 00    	jbe    801f64 <__umoddi3+0xd8>
  801ec2:	89 c8                	mov    %ecx,%eax
  801ec4:	89 f2                	mov    %esi,%edx
  801ec6:	f7 f7                	div    %edi
  801ec8:	89 d0                	mov    %edx,%eax
  801eca:	31 d2                	xor    %edx,%edx
  801ecc:	83 c4 1c             	add    $0x1c,%esp
  801ecf:	5b                   	pop    %ebx
  801ed0:	5e                   	pop    %esi
  801ed1:	5f                   	pop    %edi
  801ed2:	5d                   	pop    %ebp
  801ed3:	c3                   	ret    
  801ed4:	39 f0                	cmp    %esi,%eax
  801ed6:	0f 87 ac 00 00 00    	ja     801f88 <__umoddi3+0xfc>
  801edc:	0f bd e8             	bsr    %eax,%ebp
  801edf:	83 f5 1f             	xor    $0x1f,%ebp
  801ee2:	0f 84 ac 00 00 00    	je     801f94 <__umoddi3+0x108>
  801ee8:	bf 20 00 00 00       	mov    $0x20,%edi
  801eed:	29 ef                	sub    %ebp,%edi
  801eef:	89 fe                	mov    %edi,%esi
  801ef1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ef5:	89 e9                	mov    %ebp,%ecx
  801ef7:	d3 e0                	shl    %cl,%eax
  801ef9:	89 d7                	mov    %edx,%edi
  801efb:	89 f1                	mov    %esi,%ecx
  801efd:	d3 ef                	shr    %cl,%edi
  801eff:	09 c7                	or     %eax,%edi
  801f01:	89 e9                	mov    %ebp,%ecx
  801f03:	d3 e2                	shl    %cl,%edx
  801f05:	89 14 24             	mov    %edx,(%esp)
  801f08:	89 d8                	mov    %ebx,%eax
  801f0a:	d3 e0                	shl    %cl,%eax
  801f0c:	89 c2                	mov    %eax,%edx
  801f0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f12:	d3 e0                	shl    %cl,%eax
  801f14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f18:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f1c:	89 f1                	mov    %esi,%ecx
  801f1e:	d3 e8                	shr    %cl,%eax
  801f20:	09 d0                	or     %edx,%eax
  801f22:	d3 eb                	shr    %cl,%ebx
  801f24:	89 da                	mov    %ebx,%edx
  801f26:	f7 f7                	div    %edi
  801f28:	89 d3                	mov    %edx,%ebx
  801f2a:	f7 24 24             	mull   (%esp)
  801f2d:	89 c6                	mov    %eax,%esi
  801f2f:	89 d1                	mov    %edx,%ecx
  801f31:	39 d3                	cmp    %edx,%ebx
  801f33:	0f 82 87 00 00 00    	jb     801fc0 <__umoddi3+0x134>
  801f39:	0f 84 91 00 00 00    	je     801fd0 <__umoddi3+0x144>
  801f3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f43:	29 f2                	sub    %esi,%edx
  801f45:	19 cb                	sbb    %ecx,%ebx
  801f47:	89 d8                	mov    %ebx,%eax
  801f49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f4d:	d3 e0                	shl    %cl,%eax
  801f4f:	89 e9                	mov    %ebp,%ecx
  801f51:	d3 ea                	shr    %cl,%edx
  801f53:	09 d0                	or     %edx,%eax
  801f55:	89 e9                	mov    %ebp,%ecx
  801f57:	d3 eb                	shr    %cl,%ebx
  801f59:	89 da                	mov    %ebx,%edx
  801f5b:	83 c4 1c             	add    $0x1c,%esp
  801f5e:	5b                   	pop    %ebx
  801f5f:	5e                   	pop    %esi
  801f60:	5f                   	pop    %edi
  801f61:	5d                   	pop    %ebp
  801f62:	c3                   	ret    
  801f63:	90                   	nop
  801f64:	89 fd                	mov    %edi,%ebp
  801f66:	85 ff                	test   %edi,%edi
  801f68:	75 0b                	jne    801f75 <__umoddi3+0xe9>
  801f6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6f:	31 d2                	xor    %edx,%edx
  801f71:	f7 f7                	div    %edi
  801f73:	89 c5                	mov    %eax,%ebp
  801f75:	89 f0                	mov    %esi,%eax
  801f77:	31 d2                	xor    %edx,%edx
  801f79:	f7 f5                	div    %ebp
  801f7b:	89 c8                	mov    %ecx,%eax
  801f7d:	f7 f5                	div    %ebp
  801f7f:	89 d0                	mov    %edx,%eax
  801f81:	e9 44 ff ff ff       	jmp    801eca <__umoddi3+0x3e>
  801f86:	66 90                	xchg   %ax,%ax
  801f88:	89 c8                	mov    %ecx,%eax
  801f8a:	89 f2                	mov    %esi,%edx
  801f8c:	83 c4 1c             	add    $0x1c,%esp
  801f8f:	5b                   	pop    %ebx
  801f90:	5e                   	pop    %esi
  801f91:	5f                   	pop    %edi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    
  801f94:	3b 04 24             	cmp    (%esp),%eax
  801f97:	72 06                	jb     801f9f <__umoddi3+0x113>
  801f99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f9d:	77 0f                	ja     801fae <__umoddi3+0x122>
  801f9f:	89 f2                	mov    %esi,%edx
  801fa1:	29 f9                	sub    %edi,%ecx
  801fa3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801fa7:	89 14 24             	mov    %edx,(%esp)
  801faa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fae:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fb2:	8b 14 24             	mov    (%esp),%edx
  801fb5:	83 c4 1c             	add    $0x1c,%esp
  801fb8:	5b                   	pop    %ebx
  801fb9:	5e                   	pop    %esi
  801fba:	5f                   	pop    %edi
  801fbb:	5d                   	pop    %ebp
  801fbc:	c3                   	ret    
  801fbd:	8d 76 00             	lea    0x0(%esi),%esi
  801fc0:	2b 04 24             	sub    (%esp),%eax
  801fc3:	19 fa                	sbb    %edi,%edx
  801fc5:	89 d1                	mov    %edx,%ecx
  801fc7:	89 c6                	mov    %eax,%esi
  801fc9:	e9 71 ff ff ff       	jmp    801f3f <__umoddi3+0xb3>
  801fce:	66 90                	xchg   %ax,%ax
  801fd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801fd4:	72 ea                	jb     801fc0 <__umoddi3+0x134>
  801fd6:	89 d9                	mov    %ebx,%ecx
  801fd8:	e9 62 ff ff ff       	jmp    801f3f <__umoddi3+0xb3>
