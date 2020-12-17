
obj/user/tst_sharing_4:     file format elf32-i386


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
  800031:	e8 1e 05 00 00       	call   800554 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
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
  800087:	68 40 20 80 00       	push   $0x802040
  80008c:	6a 12                	push   $0x12
  80008e:	68 5c 20 80 00       	push   $0x80205c
  800093:	e8 01 06 00 00       	call   800699 <_panic>
	}

	cprintf("************************************************\n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 74 20 80 00       	push   $0x802074
  8000a0:	e8 96 08 00 00       	call   80093b <cprintf>
  8000a5:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	68 a8 20 80 00       	push   $0x8020a8
  8000b0:	e8 86 08 00 00       	call   80093b <cprintf>
  8000b5:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	68 04 21 80 00       	push   $0x802104
  8000c0:	e8 76 08 00 00       	call   80093b <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000c8:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000cf:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000d6:	e8 1a 17 00 00       	call   8017f5 <sys_getenvid>
  8000db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	68 38 21 80 00       	push   $0x802138
  8000e6:	e8 50 08 00 00       	call   80093b <cprintf>
  8000eb:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000ee:	e8 e6 17 00 00       	call   8018d9 <sys_calculate_free_frames>
  8000f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	6a 01                	push   $0x1
  8000fb:	68 00 10 00 00       	push   $0x1000
  800100:	68 67 21 80 00       	push   $0x802167
  800105:	e8 d5 15 00 00       	call   8016df <smalloc>
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800110:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 6c 21 80 00       	push   $0x80216c
  800121:	6a 21                	push   $0x21
  800123:	68 5c 20 80 00       	push   $0x80205c
  800128:	e8 6c 05 00 00       	call   800699 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80012d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800130:	e8 a4 17 00 00       	call   8018d9 <sys_calculate_free_frames>
  800135:	29 c3                	sub    %eax,%ebx
  800137:	89 d8                	mov    %ebx,%eax
  800139:	83 f8 04             	cmp    $0x4,%eax
  80013c:	74 14                	je     800152 <_main+0x11a>
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	68 d8 21 80 00       	push   $0x8021d8
  800146:	6a 22                	push   $0x22
  800148:	68 5c 20 80 00       	push   $0x80205c
  80014d:	e8 47 05 00 00       	call   800699 <_panic>

		sfree(x);
  800152:	83 ec 0c             	sub    $0xc,%esp
  800155:	ff 75 dc             	pushl  -0x24(%ebp)
  800158:	e8 d6 15 00 00       	call   801733 <sfree>
  80015d:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800160:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800163:	e8 71 17 00 00       	call   8018d9 <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	89 d8                	mov    %ebx,%eax
  80016c:	83 f8 02             	cmp    $0x2,%eax
  80016f:	75 14                	jne    800185 <_main+0x14d>
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	68 58 22 80 00       	push   $0x802258
  800179:	6a 25                	push   $0x25
  80017b:	68 5c 20 80 00       	push   $0x80205c
  800180:	e8 14 05 00 00       	call   800699 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800185:	e8 4f 17 00 00       	call   8018d9 <sys_calculate_free_frames>
  80018a:	89 c2                	mov    %eax,%edx
  80018c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80018f:	39 c2                	cmp    %eax,%edx
  800191:	74 14                	je     8001a7 <_main+0x16f>
  800193:	83 ec 04             	sub    $0x4,%esp
  800196:	68 b0 22 80 00       	push   $0x8022b0
  80019b:	6a 26                	push   $0x26
  80019d:	68 5c 20 80 00       	push   $0x80205c
  8001a2:	e8 f2 04 00 00       	call   800699 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	68 e0 22 80 00       	push   $0x8022e0
  8001af:	e8 87 07 00 00       	call   80093b <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	68 04 23 80 00       	push   $0x802304
  8001bf:	e8 77 07 00 00       	call   80093b <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001c7:	e8 0d 17 00 00       	call   8018d9 <sys_calculate_free_frames>
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	6a 01                	push   $0x1
  8001d4:	68 00 10 00 00       	push   $0x1000
  8001d9:	68 34 23 80 00       	push   $0x802334
  8001de:	e8 fc 14 00 00       	call   8016df <smalloc>
  8001e3:	83 c4 10             	add    $0x10,%esp
  8001e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001e9:	83 ec 04             	sub    $0x4,%esp
  8001ec:	6a 01                	push   $0x1
  8001ee:	68 00 10 00 00       	push   $0x1000
  8001f3:	68 67 21 80 00       	push   $0x802167
  8001f8:	e8 e2 14 00 00       	call   8016df <smalloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800203:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 58 22 80 00       	push   $0x802258
  800211:	6a 32                	push   $0x32
  800213:	68 5c 20 80 00       	push   $0x80205c
  800218:	e8 7c 04 00 00       	call   800699 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  80021d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800220:	e8 b4 16 00 00       	call   8018d9 <sys_calculate_free_frames>
  800225:	29 c3                	sub    %eax,%ebx
  800227:	89 d8                	mov    %ebx,%eax
  800229:	83 f8 07             	cmp    $0x7,%eax
  80022c:	74 14                	je     800242 <_main+0x20a>
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	68 38 23 80 00       	push   $0x802338
  800236:	6a 34                	push   $0x34
  800238:	68 5c 20 80 00       	push   $0x80205c
  80023d:	e8 57 04 00 00       	call   800699 <_panic>

		sfree(z);
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	ff 75 d4             	pushl  -0x2c(%ebp)
  800248:	e8 e6 14 00 00       	call   801733 <sfree>
  80024d:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800250:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800253:	e8 81 16 00 00       	call   8018d9 <sys_calculate_free_frames>
  800258:	29 c3                	sub    %eax,%ebx
  80025a:	89 d8                	mov    %ebx,%eax
  80025c:	83 f8 04             	cmp    $0x4,%eax
  80025f:	74 14                	je     800275 <_main+0x23d>
  800261:	83 ec 04             	sub    $0x4,%esp
  800264:	68 8d 23 80 00       	push   $0x80238d
  800269:	6a 37                	push   $0x37
  80026b:	68 5c 20 80 00       	push   $0x80205c
  800270:	e8 24 04 00 00       	call   800699 <_panic>

		sfree(x);
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	ff 75 d0             	pushl  -0x30(%ebp)
  80027b:	e8 b3 14 00 00       	call   801733 <sfree>
  800280:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800283:	e8 51 16 00 00       	call   8018d9 <sys_calculate_free_frames>
  800288:	89 c2                	mov    %eax,%edx
  80028a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80028d:	39 c2                	cmp    %eax,%edx
  80028f:	74 14                	je     8002a5 <_main+0x26d>
  800291:	83 ec 04             	sub    $0x4,%esp
  800294:	68 8d 23 80 00       	push   $0x80238d
  800299:	6a 3a                	push   $0x3a
  80029b:	68 5c 20 80 00       	push   $0x80205c
  8002a0:	e8 f4 03 00 00       	call   800699 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	68 ac 23 80 00       	push   $0x8023ac
  8002ad:	e8 89 06 00 00       	call   80093b <cprintf>
  8002b2:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	68 d0 23 80 00       	push   $0x8023d0
  8002bd:	e8 79 06 00 00       	call   80093b <cprintf>
  8002c2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 0f 16 00 00       	call   8018d9 <sys_calculate_free_frames>
  8002ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	6a 01                	push   $0x1
  8002d2:	68 01 30 00 00       	push   $0x3001
  8002d7:	68 00 24 80 00       	push   $0x802400
  8002dc:	e8 fe 13 00 00       	call   8016df <smalloc>
  8002e1:	83 c4 10             	add    $0x10,%esp
  8002e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002e7:	83 ec 04             	sub    $0x4,%esp
  8002ea:	6a 01                	push   $0x1
  8002ec:	68 00 10 00 00       	push   $0x1000
  8002f1:	68 02 24 80 00       	push   $0x802402
  8002f6:	e8 e4 13 00 00       	call   8016df <smalloc>
  8002fb:	83 c4 10             	add    $0x10,%esp
  8002fe:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800301:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800304:	e8 d0 15 00 00       	call   8018d9 <sys_calculate_free_frames>
  800309:	29 c3                	sub    %eax,%ebx
  80030b:	89 d8                	mov    %ebx,%eax
  80030d:	83 f8 0a             	cmp    $0xa,%eax
  800310:	74 14                	je     800326 <_main+0x2ee>
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	68 d8 21 80 00       	push   $0x8021d8
  80031a:	6a 46                	push   $0x46
  80031c:	68 5c 20 80 00       	push   $0x80205c
  800321:	e8 73 03 00 00       	call   800699 <_panic>

		sfree(w);
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	ff 75 c8             	pushl  -0x38(%ebp)
  80032c:	e8 02 14 00 00       	call   801733 <sfree>
  800331:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800334:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800337:	e8 9d 15 00 00       	call   8018d9 <sys_calculate_free_frames>
  80033c:	29 c3                	sub    %eax,%ebx
  80033e:	89 d8                	mov    %ebx,%eax
  800340:	83 f8 04             	cmp    $0x4,%eax
  800343:	74 14                	je     800359 <_main+0x321>
  800345:	83 ec 04             	sub    $0x4,%esp
  800348:	68 8d 23 80 00       	push   $0x80238d
  80034d:	6a 49                	push   $0x49
  80034f:	68 5c 20 80 00       	push   $0x80205c
  800354:	e8 40 03 00 00       	call   800699 <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	6a 01                	push   $0x1
  80035e:	68 ff 1f 00 00       	push   $0x1fff
  800363:	68 04 24 80 00       	push   $0x802404
  800368:	e8 72 13 00 00       	call   8016df <smalloc>
  80036d:	83 c4 10             	add    $0x10,%esp
  800370:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800373:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800376:	e8 5e 15 00 00       	call   8018d9 <sys_calculate_free_frames>
  80037b:	29 c3                	sub    %eax,%ebx
  80037d:	89 d8                	mov    %ebx,%eax
  80037f:	83 f8 08             	cmp    $0x8,%eax
  800382:	74 14                	je     800398 <_main+0x360>
  800384:	83 ec 04             	sub    $0x4,%esp
  800387:	68 d8 21 80 00       	push   $0x8021d8
  80038c:	6a 4e                	push   $0x4e
  80038e:	68 5c 20 80 00       	push   $0x80205c
  800393:	e8 01 03 00 00       	call   800699 <_panic>

		sfree(o);
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	ff 75 c0             	pushl  -0x40(%ebp)
  80039e:	e8 90 13 00 00       	call   801733 <sfree>
  8003a3:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003a6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003a9:	e8 2b 15 00 00       	call   8018d9 <sys_calculate_free_frames>
  8003ae:	29 c3                	sub    %eax,%ebx
  8003b0:	89 d8                	mov    %ebx,%eax
  8003b2:	83 f8 04             	cmp    $0x4,%eax
  8003b5:	74 14                	je     8003cb <_main+0x393>
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	68 8d 23 80 00       	push   $0x80238d
  8003bf:	6a 51                	push   $0x51
  8003c1:	68 5c 20 80 00       	push   $0x80205c
  8003c6:	e8 ce 02 00 00       	call   800699 <_panic>

		sfree(u);
  8003cb:	83 ec 0c             	sub    $0xc,%esp
  8003ce:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d1:	e8 5d 13 00 00       	call   801733 <sfree>
  8003d6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003d9:	e8 fb 14 00 00       	call   8018d9 <sys_calculate_free_frames>
  8003de:	89 c2                	mov    %eax,%edx
  8003e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e3:	39 c2                	cmp    %eax,%edx
  8003e5:	74 14                	je     8003fb <_main+0x3c3>
  8003e7:	83 ec 04             	sub    $0x4,%esp
  8003ea:	68 8d 23 80 00       	push   $0x80238d
  8003ef:	6a 54                	push   $0x54
  8003f1:	68 5c 20 80 00       	push   $0x80205c
  8003f6:	e8 9e 02 00 00       	call   800699 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  8003fb:	e8 d9 14 00 00       	call   8018d9 <sys_calculate_free_frames>
  800400:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800403:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800406:	89 c2                	mov    %eax,%edx
  800408:	01 d2                	add    %edx,%edx
  80040a:	01 d0                	add    %edx,%eax
  80040c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	6a 01                	push   $0x1
  800414:	50                   	push   %eax
  800415:	68 00 24 80 00       	push   $0x802400
  80041a:	e8 c0 12 00 00       	call   8016df <smalloc>
  80041f:	83 c4 10             	add    $0x10,%esp
  800422:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  800425:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800428:	89 d0                	mov    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	01 c0                	add    %eax,%eax
  800430:	01 d0                	add    %edx,%eax
  800432:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	6a 01                	push   $0x1
  80043a:	50                   	push   %eax
  80043b:	68 02 24 80 00       	push   $0x802402
  800440:	e8 9a 12 00 00       	call   8016df <smalloc>
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  80044b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80044e:	01 c0                	add    %eax,%eax
  800450:	89 c2                	mov    %eax,%edx
  800452:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800455:	01 d0                	add    %edx,%eax
  800457:	83 ec 04             	sub    $0x4,%esp
  80045a:	6a 01                	push   $0x1
  80045c:	50                   	push   %eax
  80045d:	68 04 24 80 00       	push   $0x802404
  800462:	e8 78 12 00 00       	call   8016df <smalloc>
  800467:	83 c4 10             	add    $0x10,%esp
  80046a:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80046d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800470:	e8 64 14 00 00       	call   8018d9 <sys_calculate_free_frames>
  800475:	29 c3                	sub    %eax,%ebx
  800477:	89 d8                	mov    %ebx,%eax
  800479:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 d8 21 80 00       	push   $0x8021d8
  800488:	6a 5d                	push   $0x5d
  80048a:	68 5c 20 80 00       	push   $0x80205c
  80048f:	e8 05 02 00 00       	call   800699 <_panic>

		sfree(o);
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	ff 75 c0             	pushl  -0x40(%ebp)
  80049a:	e8 94 12 00 00       	call   801733 <sfree>
  80049f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a2:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004a5:	e8 2f 14 00 00       	call   8018d9 <sys_calculate_free_frames>
  8004aa:	29 c3                	sub    %eax,%ebx
  8004ac:	89 d8                	mov    %ebx,%eax
  8004ae:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b3:	74 14                	je     8004c9 <_main+0x491>
  8004b5:	83 ec 04             	sub    $0x4,%esp
  8004b8:	68 8d 23 80 00       	push   $0x80238d
  8004bd:	6a 60                	push   $0x60
  8004bf:	68 5c 20 80 00       	push   $0x80205c
  8004c4:	e8 d0 01 00 00       	call   800699 <_panic>

		sfree(w);
  8004c9:	83 ec 0c             	sub    $0xc,%esp
  8004cc:	ff 75 c8             	pushl  -0x38(%ebp)
  8004cf:	e8 5f 12 00 00       	call   801733 <sfree>
  8004d4:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004d7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004da:	e8 fa 13 00 00       	call   8018d9 <sys_calculate_free_frames>
  8004df:	29 c3                	sub    %eax,%ebx
  8004e1:	89 d8                	mov    %ebx,%eax
  8004e3:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004e8:	74 14                	je     8004fe <_main+0x4c6>
  8004ea:	83 ec 04             	sub    $0x4,%esp
  8004ed:	68 8d 23 80 00       	push   $0x80238d
  8004f2:	6a 63                	push   $0x63
  8004f4:	68 5c 20 80 00       	push   $0x80205c
  8004f9:	e8 9b 01 00 00       	call   800699 <_panic>

		sfree(u);
  8004fe:	83 ec 0c             	sub    $0xc,%esp
  800501:	ff 75 c4             	pushl  -0x3c(%ebp)
  800504:	e8 2a 12 00 00       	call   801733 <sfree>
  800509:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80050c:	e8 c8 13 00 00       	call   8018d9 <sys_calculate_free_frames>
  800511:	89 c2                	mov    %eax,%edx
  800513:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800516:	39 c2                	cmp    %eax,%edx
  800518:	74 14                	je     80052e <_main+0x4f6>
  80051a:	83 ec 04             	sub    $0x4,%esp
  80051d:	68 8d 23 80 00       	push   $0x80238d
  800522:	6a 66                	push   $0x66
  800524:	68 5c 20 80 00       	push   $0x80205c
  800529:	e8 6b 01 00 00       	call   800699 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  80052e:	83 ec 0c             	sub    $0xc,%esp
  800531:	68 08 24 80 00       	push   $0x802408
  800536:	e8 00 04 00 00       	call   80093b <cprintf>
  80053b:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  80053e:	83 ec 0c             	sub    $0xc,%esp
  800541:	68 2c 24 80 00       	push   $0x80242c
  800546:	e8 f0 03 00 00       	call   80093b <cprintf>
  80054b:	83 c4 10             	add    $0x10,%esp

	return;
  80054e:	90                   	nop
}
  80054f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800552:	c9                   	leave  
  800553:	c3                   	ret    

00800554 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800554:	55                   	push   %ebp
  800555:	89 e5                	mov    %esp,%ebp
  800557:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80055a:	e8 af 12 00 00       	call   80180e <sys_getenvindex>
  80055f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800562:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800565:	89 d0                	mov    %edx,%eax
  800567:	c1 e0 03             	shl    $0x3,%eax
  80056a:	01 d0                	add    %edx,%eax
  80056c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800573:	01 c8                	add    %ecx,%eax
  800575:	01 c0                	add    %eax,%eax
  800577:	01 d0                	add    %edx,%eax
  800579:	01 c0                	add    %eax,%eax
  80057b:	01 d0                	add    %edx,%eax
  80057d:	89 c2                	mov    %eax,%edx
  80057f:	c1 e2 05             	shl    $0x5,%edx
  800582:	29 c2                	sub    %eax,%edx
  800584:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80058b:	89 c2                	mov    %eax,%edx
  80058d:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800593:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800598:	a1 20 30 80 00       	mov    0x803020,%eax
  80059d:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8005a3:	84 c0                	test   %al,%al
  8005a5:	74 0f                	je     8005b6 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8005a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ac:	05 40 3c 01 00       	add    $0x13c40,%eax
  8005b1:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005ba:	7e 0a                	jle    8005c6 <libmain+0x72>
		binaryname = argv[0];
  8005bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	ff 75 0c             	pushl  0xc(%ebp)
  8005cc:	ff 75 08             	pushl  0x8(%ebp)
  8005cf:	e8 64 fa ff ff       	call   800038 <_main>
  8005d4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005d7:	e8 cd 13 00 00       	call   8019a9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005dc:	83 ec 0c             	sub    $0xc,%esp
  8005df:	68 90 24 80 00       	push   $0x802490
  8005e4:	e8 52 03 00 00       	call   80093b <cprintf>
  8005e9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005ec:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f1:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8005f7:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fc:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800602:	83 ec 04             	sub    $0x4,%esp
  800605:	52                   	push   %edx
  800606:	50                   	push   %eax
  800607:	68 b8 24 80 00       	push   $0x8024b8
  80060c:	e8 2a 03 00 00       	call   80093b <cprintf>
  800611:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800614:	a1 20 30 80 00       	mov    0x803020,%eax
  800619:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80061f:	a1 20 30 80 00       	mov    0x803020,%eax
  800624:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80062a:	83 ec 04             	sub    $0x4,%esp
  80062d:	52                   	push   %edx
  80062e:	50                   	push   %eax
  80062f:	68 e0 24 80 00       	push   $0x8024e0
  800634:	e8 02 03 00 00       	call   80093b <cprintf>
  800639:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80063c:	a1 20 30 80 00       	mov    0x803020,%eax
  800641:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800647:	83 ec 08             	sub    $0x8,%esp
  80064a:	50                   	push   %eax
  80064b:	68 21 25 80 00       	push   $0x802521
  800650:	e8 e6 02 00 00       	call   80093b <cprintf>
  800655:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 90 24 80 00       	push   $0x802490
  800660:	e8 d6 02 00 00       	call   80093b <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800668:	e8 56 13 00 00       	call   8019c3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80066d:	e8 19 00 00 00       	call   80068b <exit>
}
  800672:	90                   	nop
  800673:	c9                   	leave  
  800674:	c3                   	ret    

00800675 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800675:	55                   	push   %ebp
  800676:	89 e5                	mov    %esp,%ebp
  800678:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	6a 00                	push   $0x0
  800680:	e8 55 11 00 00       	call   8017da <sys_env_destroy>
  800685:	83 c4 10             	add    $0x10,%esp
}
  800688:	90                   	nop
  800689:	c9                   	leave  
  80068a:	c3                   	ret    

0080068b <exit>:

void
exit(void)
{
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
  80068e:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800691:	e8 aa 11 00 00       	call   801840 <sys_env_exit>
}
  800696:	90                   	nop
  800697:	c9                   	leave  
  800698:	c3                   	ret    

00800699 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800699:	55                   	push   %ebp
  80069a:	89 e5                	mov    %esp,%ebp
  80069c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80069f:	8d 45 10             	lea    0x10(%ebp),%eax
  8006a2:	83 c0 04             	add    $0x4,%eax
  8006a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006a8:	a1 18 31 80 00       	mov    0x803118,%eax
  8006ad:	85 c0                	test   %eax,%eax
  8006af:	74 16                	je     8006c7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006b1:	a1 18 31 80 00       	mov    0x803118,%eax
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	50                   	push   %eax
  8006ba:	68 38 25 80 00       	push   $0x802538
  8006bf:	e8 77 02 00 00       	call   80093b <cprintf>
  8006c4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006c7:	a1 00 30 80 00       	mov    0x803000,%eax
  8006cc:	ff 75 0c             	pushl  0xc(%ebp)
  8006cf:	ff 75 08             	pushl  0x8(%ebp)
  8006d2:	50                   	push   %eax
  8006d3:	68 3d 25 80 00       	push   $0x80253d
  8006d8:	e8 5e 02 00 00       	call   80093b <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e9:	50                   	push   %eax
  8006ea:	e8 e1 01 00 00       	call   8008d0 <vcprintf>
  8006ef:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	6a 00                	push   $0x0
  8006f7:	68 59 25 80 00       	push   $0x802559
  8006fc:	e8 cf 01 00 00       	call   8008d0 <vcprintf>
  800701:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800704:	e8 82 ff ff ff       	call   80068b <exit>

	// should not return here
	while (1) ;
  800709:	eb fe                	jmp    800709 <_panic+0x70>

0080070b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80070b:	55                   	push   %ebp
  80070c:	89 e5                	mov    %esp,%ebp
  80070e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800711:	a1 20 30 80 00       	mov    0x803020,%eax
  800716:	8b 50 74             	mov    0x74(%eax),%edx
  800719:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071c:	39 c2                	cmp    %eax,%edx
  80071e:	74 14                	je     800734 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800720:	83 ec 04             	sub    $0x4,%esp
  800723:	68 5c 25 80 00       	push   $0x80255c
  800728:	6a 26                	push   $0x26
  80072a:	68 a8 25 80 00       	push   $0x8025a8
  80072f:	e8 65 ff ff ff       	call   800699 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800734:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80073b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800742:	e9 b6 00 00 00       	jmp    8007fd <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	01 d0                	add    %edx,%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	85 c0                	test   %eax,%eax
  80075a:	75 08                	jne    800764 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80075c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80075f:	e9 96 00 00 00       	jmp    8007fa <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800764:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80076b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800772:	eb 5d                	jmp    8007d1 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800774:	a1 20 30 80 00       	mov    0x803020,%eax
  800779:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80077f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800782:	c1 e2 04             	shl    $0x4,%edx
  800785:	01 d0                	add    %edx,%eax
  800787:	8a 40 04             	mov    0x4(%eax),%al
  80078a:	84 c0                	test   %al,%al
  80078c:	75 40                	jne    8007ce <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80078e:	a1 20 30 80 00       	mov    0x803020,%eax
  800793:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800799:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80079c:	c1 e2 04             	shl    $0x4,%edx
  80079f:	01 d0                	add    %edx,%eax
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007ae:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	01 c8                	add    %ecx,%eax
  8007bf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007c1:	39 c2                	cmp    %eax,%edx
  8007c3:	75 09                	jne    8007ce <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8007c5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007cc:	eb 12                	jmp    8007e0 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007ce:	ff 45 e8             	incl   -0x18(%ebp)
  8007d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8007d6:	8b 50 74             	mov    0x74(%eax),%edx
  8007d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007dc:	39 c2                	cmp    %eax,%edx
  8007de:	77 94                	ja     800774 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8007e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8007e4:	75 14                	jne    8007fa <CheckWSWithoutLastIndex+0xef>
			panic(
  8007e6:	83 ec 04             	sub    $0x4,%esp
  8007e9:	68 b4 25 80 00       	push   $0x8025b4
  8007ee:	6a 3a                	push   $0x3a
  8007f0:	68 a8 25 80 00       	push   $0x8025a8
  8007f5:	e8 9f fe ff ff       	call   800699 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8007fa:	ff 45 f0             	incl   -0x10(%ebp)
  8007fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800800:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800803:	0f 8c 3e ff ff ff    	jl     800747 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800809:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800810:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800817:	eb 20                	jmp    800839 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800819:	a1 20 30 80 00       	mov    0x803020,%eax
  80081e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800824:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800827:	c1 e2 04             	shl    $0x4,%edx
  80082a:	01 d0                	add    %edx,%eax
  80082c:	8a 40 04             	mov    0x4(%eax),%al
  80082f:	3c 01                	cmp    $0x1,%al
  800831:	75 03                	jne    800836 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800833:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800836:	ff 45 e0             	incl   -0x20(%ebp)
  800839:	a1 20 30 80 00       	mov    0x803020,%eax
  80083e:	8b 50 74             	mov    0x74(%eax),%edx
  800841:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800844:	39 c2                	cmp    %eax,%edx
  800846:	77 d1                	ja     800819 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80084e:	74 14                	je     800864 <CheckWSWithoutLastIndex+0x159>
		panic(
  800850:	83 ec 04             	sub    $0x4,%esp
  800853:	68 08 26 80 00       	push   $0x802608
  800858:	6a 44                	push   $0x44
  80085a:	68 a8 25 80 00       	push   $0x8025a8
  80085f:	e8 35 fe ff ff       	call   800699 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800864:	90                   	nop
  800865:	c9                   	leave  
  800866:	c3                   	ret    

00800867 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80086d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	8d 48 01             	lea    0x1(%eax),%ecx
  800875:	8b 55 0c             	mov    0xc(%ebp),%edx
  800878:	89 0a                	mov    %ecx,(%edx)
  80087a:	8b 55 08             	mov    0x8(%ebp),%edx
  80087d:	88 d1                	mov    %dl,%cl
  80087f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800882:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800886:	8b 45 0c             	mov    0xc(%ebp),%eax
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800890:	75 2c                	jne    8008be <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800892:	a0 24 30 80 00       	mov    0x803024,%al
  800897:	0f b6 c0             	movzbl %al,%eax
  80089a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089d:	8b 12                	mov    (%edx),%edx
  80089f:	89 d1                	mov    %edx,%ecx
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a4:	83 c2 08             	add    $0x8,%edx
  8008a7:	83 ec 04             	sub    $0x4,%esp
  8008aa:	50                   	push   %eax
  8008ab:	51                   	push   %ecx
  8008ac:	52                   	push   %edx
  8008ad:	e8 e6 0e 00 00       	call   801798 <sys_cputs>
  8008b2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c1:	8b 40 04             	mov    0x4(%eax),%eax
  8008c4:	8d 50 01             	lea    0x1(%eax),%edx
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ca:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008cd:	90                   	nop
  8008ce:	c9                   	leave  
  8008cf:	c3                   	ret    

008008d0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8008d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008e0:	00 00 00 
	b.cnt = 0;
  8008e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008ea:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8008ed:	ff 75 0c             	pushl  0xc(%ebp)
  8008f0:	ff 75 08             	pushl  0x8(%ebp)
  8008f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008f9:	50                   	push   %eax
  8008fa:	68 67 08 80 00       	push   $0x800867
  8008ff:	e8 11 02 00 00       	call   800b15 <vprintfmt>
  800904:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800907:	a0 24 30 80 00       	mov    0x803024,%al
  80090c:	0f b6 c0             	movzbl %al,%eax
  80090f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	50                   	push   %eax
  800919:	52                   	push   %edx
  80091a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800920:	83 c0 08             	add    $0x8,%eax
  800923:	50                   	push   %eax
  800924:	e8 6f 0e 00 00       	call   801798 <sys_cputs>
  800929:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80092c:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800933:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800939:	c9                   	leave  
  80093a:	c3                   	ret    

0080093b <cprintf>:

int cprintf(const char *fmt, ...) {
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800941:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800948:	8d 45 0c             	lea    0xc(%ebp),%eax
  80094b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 f4             	pushl  -0xc(%ebp)
  800957:	50                   	push   %eax
  800958:	e8 73 ff ff ff       	call   8008d0 <vcprintf>
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800963:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80096e:	e8 36 10 00 00       	call   8019a9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800973:	8d 45 0c             	lea    0xc(%ebp),%eax
  800976:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 f4             	pushl  -0xc(%ebp)
  800982:	50                   	push   %eax
  800983:	e8 48 ff ff ff       	call   8008d0 <vcprintf>
  800988:	83 c4 10             	add    $0x10,%esp
  80098b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80098e:	e8 30 10 00 00       	call   8019c3 <sys_enable_interrupt>
	return cnt;
  800993:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800996:	c9                   	leave  
  800997:	c3                   	ret    

00800998 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800998:	55                   	push   %ebp
  800999:	89 e5                	mov    %esp,%ebp
  80099b:	53                   	push   %ebx
  80099c:	83 ec 14             	sub    $0x14,%esp
  80099f:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009ab:	8b 45 18             	mov    0x18(%ebp),%eax
  8009ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009b6:	77 55                	ja     800a0d <printnum+0x75>
  8009b8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009bb:	72 05                	jb     8009c2 <printnum+0x2a>
  8009bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009c0:	77 4b                	ja     800a0d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009c2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009c5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009c8:	8b 45 18             	mov    0x18(%ebp),%eax
  8009cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d0:	52                   	push   %edx
  8009d1:	50                   	push   %eax
  8009d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8009d8:	e8 ef 13 00 00       	call   801dcc <__udivdi3>
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	83 ec 04             	sub    $0x4,%esp
  8009e3:	ff 75 20             	pushl  0x20(%ebp)
  8009e6:	53                   	push   %ebx
  8009e7:	ff 75 18             	pushl  0x18(%ebp)
  8009ea:	52                   	push   %edx
  8009eb:	50                   	push   %eax
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	ff 75 08             	pushl  0x8(%ebp)
  8009f2:	e8 a1 ff ff ff       	call   800998 <printnum>
  8009f7:	83 c4 20             	add    $0x20,%esp
  8009fa:	eb 1a                	jmp    800a16 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8009fc:	83 ec 08             	sub    $0x8,%esp
  8009ff:	ff 75 0c             	pushl  0xc(%ebp)
  800a02:	ff 75 20             	pushl  0x20(%ebp)
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	ff d0                	call   *%eax
  800a0a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a0d:	ff 4d 1c             	decl   0x1c(%ebp)
  800a10:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a14:	7f e6                	jg     8009fc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a16:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a19:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a24:	53                   	push   %ebx
  800a25:	51                   	push   %ecx
  800a26:	52                   	push   %edx
  800a27:	50                   	push   %eax
  800a28:	e8 af 14 00 00       	call   801edc <__umoddi3>
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	05 74 28 80 00       	add    $0x802874,%eax
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	0f be c0             	movsbl %al,%eax
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	50                   	push   %eax
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	ff d0                	call   *%eax
  800a46:	83 c4 10             	add    $0x10,%esp
}
  800a49:	90                   	nop
  800a4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a52:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a56:	7e 1c                	jle    800a74 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8b 00                	mov    (%eax),%eax
  800a5d:	8d 50 08             	lea    0x8(%eax),%edx
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	89 10                	mov    %edx,(%eax)
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	8b 00                	mov    (%eax),%eax
  800a6a:	83 e8 08             	sub    $0x8,%eax
  800a6d:	8b 50 04             	mov    0x4(%eax),%edx
  800a70:	8b 00                	mov    (%eax),%eax
  800a72:	eb 40                	jmp    800ab4 <getuint+0x65>
	else if (lflag)
  800a74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a78:	74 1e                	je     800a98 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	8b 00                	mov    (%eax),%eax
  800a7f:	8d 50 04             	lea    0x4(%eax),%edx
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	89 10                	mov    %edx,(%eax)
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8b 00                	mov    (%eax),%eax
  800a8c:	83 e8 04             	sub    $0x4,%eax
  800a8f:	8b 00                	mov    (%eax),%eax
  800a91:	ba 00 00 00 00       	mov    $0x0,%edx
  800a96:	eb 1c                	jmp    800ab4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	8b 00                	mov    (%eax),%eax
  800a9d:	8d 50 04             	lea    0x4(%eax),%edx
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	89 10                	mov    %edx,(%eax)
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8b 00                	mov    (%eax),%eax
  800aaa:	83 e8 04             	sub    $0x4,%eax
  800aad:	8b 00                	mov    (%eax),%eax
  800aaf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ab4:	5d                   	pop    %ebp
  800ab5:	c3                   	ret    

00800ab6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ab9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800abd:	7e 1c                	jle    800adb <getint+0x25>
		return va_arg(*ap, long long);
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	8d 50 08             	lea    0x8(%eax),%edx
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	89 10                	mov    %edx,(%eax)
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	8b 00                	mov    (%eax),%eax
  800ad1:	83 e8 08             	sub    $0x8,%eax
  800ad4:	8b 50 04             	mov    0x4(%eax),%edx
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	eb 38                	jmp    800b13 <getint+0x5d>
	else if (lflag)
  800adb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800adf:	74 1a                	je     800afb <getint+0x45>
		return va_arg(*ap, long);
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	8d 50 04             	lea    0x4(%eax),%edx
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	89 10                	mov    %edx,(%eax)
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8b 00                	mov    (%eax),%eax
  800af3:	83 e8 04             	sub    $0x4,%eax
  800af6:	8b 00                	mov    (%eax),%eax
  800af8:	99                   	cltd   
  800af9:	eb 18                	jmp    800b13 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	8b 00                	mov    (%eax),%eax
  800b00:	8d 50 04             	lea    0x4(%eax),%edx
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	89 10                	mov    %edx,(%eax)
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	8b 00                	mov    (%eax),%eax
  800b0d:	83 e8 04             	sub    $0x4,%eax
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	99                   	cltd   
}
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	56                   	push   %esi
  800b19:	53                   	push   %ebx
  800b1a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b1d:	eb 17                	jmp    800b36 <vprintfmt+0x21>
			if (ch == '\0')
  800b1f:	85 db                	test   %ebx,%ebx
  800b21:	0f 84 af 03 00 00    	je     800ed6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	53                   	push   %ebx
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	ff d0                	call   *%eax
  800b33:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b36:	8b 45 10             	mov    0x10(%ebp),%eax
  800b39:	8d 50 01             	lea    0x1(%eax),%edx
  800b3c:	89 55 10             	mov    %edx,0x10(%ebp)
  800b3f:	8a 00                	mov    (%eax),%al
  800b41:	0f b6 d8             	movzbl %al,%ebx
  800b44:	83 fb 25             	cmp    $0x25,%ebx
  800b47:	75 d6                	jne    800b1f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b49:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b4d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b54:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b5b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b62:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b69:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6c:	8d 50 01             	lea    0x1(%eax),%edx
  800b6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800b72:	8a 00                	mov    (%eax),%al
  800b74:	0f b6 d8             	movzbl %al,%ebx
  800b77:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b7a:	83 f8 55             	cmp    $0x55,%eax
  800b7d:	0f 87 2b 03 00 00    	ja     800eae <vprintfmt+0x399>
  800b83:	8b 04 85 98 28 80 00 	mov    0x802898(,%eax,4),%eax
  800b8a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b8c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b90:	eb d7                	jmp    800b69 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b92:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b96:	eb d1                	jmp    800b69 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b98:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ba2:	89 d0                	mov    %edx,%eax
  800ba4:	c1 e0 02             	shl    $0x2,%eax
  800ba7:	01 d0                	add    %edx,%eax
  800ba9:	01 c0                	add    %eax,%eax
  800bab:	01 d8                	add    %ebx,%eax
  800bad:	83 e8 30             	sub    $0x30,%eax
  800bb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb6:	8a 00                	mov    (%eax),%al
  800bb8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bbb:	83 fb 2f             	cmp    $0x2f,%ebx
  800bbe:	7e 3e                	jle    800bfe <vprintfmt+0xe9>
  800bc0:	83 fb 39             	cmp    $0x39,%ebx
  800bc3:	7f 39                	jg     800bfe <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bc8:	eb d5                	jmp    800b9f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bca:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcd:	83 c0 04             	add    $0x4,%eax
  800bd0:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd6:	83 e8 04             	sub    $0x4,%eax
  800bd9:	8b 00                	mov    (%eax),%eax
  800bdb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800bde:	eb 1f                	jmp    800bff <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800be0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be4:	79 83                	jns    800b69 <vprintfmt+0x54>
				width = 0;
  800be6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800bed:	e9 77 ff ff ff       	jmp    800b69 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800bf2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800bf9:	e9 6b ff ff ff       	jmp    800b69 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800bfe:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800bff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c03:	0f 89 60 ff ff ff    	jns    800b69 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c0f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c16:	e9 4e ff ff ff       	jmp    800b69 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c1b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c1e:	e9 46 ff ff ff       	jmp    800b69 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c23:	8b 45 14             	mov    0x14(%ebp),%eax
  800c26:	83 c0 04             	add    $0x4,%eax
  800c29:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2f:	83 e8 04             	sub    $0x4,%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	83 ec 08             	sub    $0x8,%esp
  800c37:	ff 75 0c             	pushl  0xc(%ebp)
  800c3a:	50                   	push   %eax
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	ff d0                	call   *%eax
  800c40:	83 c4 10             	add    $0x10,%esp
			break;
  800c43:	e9 89 02 00 00       	jmp    800ed1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c48:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4b:	83 c0 04             	add    $0x4,%eax
  800c4e:	89 45 14             	mov    %eax,0x14(%ebp)
  800c51:	8b 45 14             	mov    0x14(%ebp),%eax
  800c54:	83 e8 04             	sub    $0x4,%eax
  800c57:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c59:	85 db                	test   %ebx,%ebx
  800c5b:	79 02                	jns    800c5f <vprintfmt+0x14a>
				err = -err;
  800c5d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c5f:	83 fb 64             	cmp    $0x64,%ebx
  800c62:	7f 0b                	jg     800c6f <vprintfmt+0x15a>
  800c64:	8b 34 9d e0 26 80 00 	mov    0x8026e0(,%ebx,4),%esi
  800c6b:	85 f6                	test   %esi,%esi
  800c6d:	75 19                	jne    800c88 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c6f:	53                   	push   %ebx
  800c70:	68 85 28 80 00       	push   $0x802885
  800c75:	ff 75 0c             	pushl  0xc(%ebp)
  800c78:	ff 75 08             	pushl  0x8(%ebp)
  800c7b:	e8 5e 02 00 00       	call   800ede <printfmt>
  800c80:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c83:	e9 49 02 00 00       	jmp    800ed1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c88:	56                   	push   %esi
  800c89:	68 8e 28 80 00       	push   $0x80288e
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	ff 75 08             	pushl  0x8(%ebp)
  800c94:	e8 45 02 00 00       	call   800ede <printfmt>
  800c99:	83 c4 10             	add    $0x10,%esp
			break;
  800c9c:	e9 30 02 00 00       	jmp    800ed1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ca1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca4:	83 c0 04             	add    $0x4,%eax
  800ca7:	89 45 14             	mov    %eax,0x14(%ebp)
  800caa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cad:	83 e8 04             	sub    $0x4,%eax
  800cb0:	8b 30                	mov    (%eax),%esi
  800cb2:	85 f6                	test   %esi,%esi
  800cb4:	75 05                	jne    800cbb <vprintfmt+0x1a6>
				p = "(null)";
  800cb6:	be 91 28 80 00       	mov    $0x802891,%esi
			if (width > 0 && padc != '-')
  800cbb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cbf:	7e 6d                	jle    800d2e <vprintfmt+0x219>
  800cc1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cc5:	74 67                	je     800d2e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cca:	83 ec 08             	sub    $0x8,%esp
  800ccd:	50                   	push   %eax
  800cce:	56                   	push   %esi
  800ccf:	e8 0c 03 00 00       	call   800fe0 <strnlen>
  800cd4:	83 c4 10             	add    $0x10,%esp
  800cd7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800cda:	eb 16                	jmp    800cf2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800cdc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	ff 75 0c             	pushl  0xc(%ebp)
  800ce6:	50                   	push   %eax
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	ff d0                	call   *%eax
  800cec:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cef:	ff 4d e4             	decl   -0x1c(%ebp)
  800cf2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf6:	7f e4                	jg     800cdc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf8:	eb 34                	jmp    800d2e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800cfa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800cfe:	74 1c                	je     800d1c <vprintfmt+0x207>
  800d00:	83 fb 1f             	cmp    $0x1f,%ebx
  800d03:	7e 05                	jle    800d0a <vprintfmt+0x1f5>
  800d05:	83 fb 7e             	cmp    $0x7e,%ebx
  800d08:	7e 12                	jle    800d1c <vprintfmt+0x207>
					putch('?', putdat);
  800d0a:	83 ec 08             	sub    $0x8,%esp
  800d0d:	ff 75 0c             	pushl  0xc(%ebp)
  800d10:	6a 3f                	push   $0x3f
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	ff d0                	call   *%eax
  800d17:	83 c4 10             	add    $0x10,%esp
  800d1a:	eb 0f                	jmp    800d2b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 0c             	pushl  0xc(%ebp)
  800d22:	53                   	push   %ebx
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	ff d0                	call   *%eax
  800d28:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d2b:	ff 4d e4             	decl   -0x1c(%ebp)
  800d2e:	89 f0                	mov    %esi,%eax
  800d30:	8d 70 01             	lea    0x1(%eax),%esi
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	0f be d8             	movsbl %al,%ebx
  800d38:	85 db                	test   %ebx,%ebx
  800d3a:	74 24                	je     800d60 <vprintfmt+0x24b>
  800d3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d40:	78 b8                	js     800cfa <vprintfmt+0x1e5>
  800d42:	ff 4d e0             	decl   -0x20(%ebp)
  800d45:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d49:	79 af                	jns    800cfa <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d4b:	eb 13                	jmp    800d60 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d4d:	83 ec 08             	sub    $0x8,%esp
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	6a 20                	push   $0x20
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	ff d0                	call   *%eax
  800d5a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d5d:	ff 4d e4             	decl   -0x1c(%ebp)
  800d60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d64:	7f e7                	jg     800d4d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d66:	e9 66 01 00 00       	jmp    800ed1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d6b:	83 ec 08             	sub    $0x8,%esp
  800d6e:	ff 75 e8             	pushl  -0x18(%ebp)
  800d71:	8d 45 14             	lea    0x14(%ebp),%eax
  800d74:	50                   	push   %eax
  800d75:	e8 3c fd ff ff       	call   800ab6 <getint>
  800d7a:	83 c4 10             	add    $0x10,%esp
  800d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d80:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d89:	85 d2                	test   %edx,%edx
  800d8b:	79 23                	jns    800db0 <vprintfmt+0x29b>
				putch('-', putdat);
  800d8d:	83 ec 08             	sub    $0x8,%esp
  800d90:	ff 75 0c             	pushl  0xc(%ebp)
  800d93:	6a 2d                	push   $0x2d
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	ff d0                	call   *%eax
  800d9a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800da3:	f7 d8                	neg    %eax
  800da5:	83 d2 00             	adc    $0x0,%edx
  800da8:	f7 da                	neg    %edx
  800daa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800db0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800db7:	e9 bc 00 00 00       	jmp    800e78 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dbc:	83 ec 08             	sub    $0x8,%esp
  800dbf:	ff 75 e8             	pushl  -0x18(%ebp)
  800dc2:	8d 45 14             	lea    0x14(%ebp),%eax
  800dc5:	50                   	push   %eax
  800dc6:	e8 84 fc ff ff       	call   800a4f <getuint>
  800dcb:	83 c4 10             	add    $0x10,%esp
  800dce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800dd4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ddb:	e9 98 00 00 00       	jmp    800e78 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800de0:	83 ec 08             	sub    $0x8,%esp
  800de3:	ff 75 0c             	pushl  0xc(%ebp)
  800de6:	6a 58                	push   $0x58
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	ff d0                	call   *%eax
  800ded:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800df0:	83 ec 08             	sub    $0x8,%esp
  800df3:	ff 75 0c             	pushl  0xc(%ebp)
  800df6:	6a 58                	push   $0x58
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	ff d0                	call   *%eax
  800dfd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e00:	83 ec 08             	sub    $0x8,%esp
  800e03:	ff 75 0c             	pushl  0xc(%ebp)
  800e06:	6a 58                	push   $0x58
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	ff d0                	call   *%eax
  800e0d:	83 c4 10             	add    $0x10,%esp
			break;
  800e10:	e9 bc 00 00 00       	jmp    800ed1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	6a 30                	push   $0x30
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	ff d0                	call   *%eax
  800e22:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e25:	83 ec 08             	sub    $0x8,%esp
  800e28:	ff 75 0c             	pushl  0xc(%ebp)
  800e2b:	6a 78                	push   $0x78
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	ff d0                	call   *%eax
  800e32:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e35:	8b 45 14             	mov    0x14(%ebp),%eax
  800e38:	83 c0 04             	add    $0x4,%eax
  800e3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e41:	83 e8 04             	sub    $0x4,%eax
  800e44:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e50:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e57:	eb 1f                	jmp    800e78 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e59:	83 ec 08             	sub    $0x8,%esp
  800e5c:	ff 75 e8             	pushl  -0x18(%ebp)
  800e5f:	8d 45 14             	lea    0x14(%ebp),%eax
  800e62:	50                   	push   %eax
  800e63:	e8 e7 fb ff ff       	call   800a4f <getuint>
  800e68:	83 c4 10             	add    $0x10,%esp
  800e6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e6e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e71:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e78:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e7f:	83 ec 04             	sub    $0x4,%esp
  800e82:	52                   	push   %edx
  800e83:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e86:	50                   	push   %eax
  800e87:	ff 75 f4             	pushl  -0xc(%ebp)
  800e8a:	ff 75 f0             	pushl  -0x10(%ebp)
  800e8d:	ff 75 0c             	pushl  0xc(%ebp)
  800e90:	ff 75 08             	pushl  0x8(%ebp)
  800e93:	e8 00 fb ff ff       	call   800998 <printnum>
  800e98:	83 c4 20             	add    $0x20,%esp
			break;
  800e9b:	eb 34                	jmp    800ed1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e9d:	83 ec 08             	sub    $0x8,%esp
  800ea0:	ff 75 0c             	pushl  0xc(%ebp)
  800ea3:	53                   	push   %ebx
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	ff d0                	call   *%eax
  800ea9:	83 c4 10             	add    $0x10,%esp
			break;
  800eac:	eb 23                	jmp    800ed1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eae:	83 ec 08             	sub    $0x8,%esp
  800eb1:	ff 75 0c             	pushl  0xc(%ebp)
  800eb4:	6a 25                	push   $0x25
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	ff d0                	call   *%eax
  800ebb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ebe:	ff 4d 10             	decl   0x10(%ebp)
  800ec1:	eb 03                	jmp    800ec6 <vprintfmt+0x3b1>
  800ec3:	ff 4d 10             	decl   0x10(%ebp)
  800ec6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec9:	48                   	dec    %eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	3c 25                	cmp    $0x25,%al
  800ece:	75 f3                	jne    800ec3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ed0:	90                   	nop
		}
	}
  800ed1:	e9 47 fc ff ff       	jmp    800b1d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ed6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ed7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eda:	5b                   	pop    %ebx
  800edb:	5e                   	pop    %esi
  800edc:	5d                   	pop    %ebp
  800edd:	c3                   	ret    

00800ede <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
  800ee1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ee4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ee7:	83 c0 04             	add    $0x4,%eax
  800eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800eed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef3:	50                   	push   %eax
  800ef4:	ff 75 0c             	pushl  0xc(%ebp)
  800ef7:	ff 75 08             	pushl  0x8(%ebp)
  800efa:	e8 16 fc ff ff       	call   800b15 <vprintfmt>
  800eff:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f02:	90                   	nop
  800f03:	c9                   	leave  
  800f04:	c3                   	ret    

00800f05 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	8b 40 08             	mov    0x8(%eax),%eax
  800f0e:	8d 50 01             	lea    0x1(%eax),%edx
  800f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f14:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1a:	8b 10                	mov    (%eax),%edx
  800f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1f:	8b 40 04             	mov    0x4(%eax),%eax
  800f22:	39 c2                	cmp    %eax,%edx
  800f24:	73 12                	jae    800f38 <sprintputch+0x33>
		*b->buf++ = ch;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	8b 00                	mov    (%eax),%eax
  800f2b:	8d 48 01             	lea    0x1(%eax),%ecx
  800f2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f31:	89 0a                	mov    %ecx,(%edx)
  800f33:	8b 55 08             	mov    0x8(%ebp),%edx
  800f36:	88 10                	mov    %dl,(%eax)
}
  800f38:	90                   	nop
  800f39:	5d                   	pop    %ebp
  800f3a:	c3                   	ret    

00800f3b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	01 d0                	add    %edx,%eax
  800f52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f60:	74 06                	je     800f68 <vsnprintf+0x2d>
  800f62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f66:	7f 07                	jg     800f6f <vsnprintf+0x34>
		return -E_INVAL;
  800f68:	b8 03 00 00 00       	mov    $0x3,%eax
  800f6d:	eb 20                	jmp    800f8f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f6f:	ff 75 14             	pushl  0x14(%ebp)
  800f72:	ff 75 10             	pushl  0x10(%ebp)
  800f75:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f78:	50                   	push   %eax
  800f79:	68 05 0f 80 00       	push   $0x800f05
  800f7e:	e8 92 fb ff ff       	call   800b15 <vprintfmt>
  800f83:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f89:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f97:	8d 45 10             	lea    0x10(%ebp),%eax
  800f9a:	83 c0 04             	add    $0x4,%eax
  800f9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fa0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa3:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa6:	50                   	push   %eax
  800fa7:	ff 75 0c             	pushl  0xc(%ebp)
  800faa:	ff 75 08             	pushl  0x8(%ebp)
  800fad:	e8 89 ff ff ff       	call   800f3b <vsnprintf>
  800fb2:	83 c4 10             	add    $0x10,%esp
  800fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fc3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fca:	eb 06                	jmp    800fd2 <strlen+0x15>
		n++;
  800fcc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fcf:	ff 45 08             	incl   0x8(%ebp)
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	84 c0                	test   %al,%al
  800fd9:	75 f1                	jne    800fcc <strlen+0xf>
		n++;
	return n;
  800fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fde:	c9                   	leave  
  800fdf:	c3                   	ret    

00800fe0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fe6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fed:	eb 09                	jmp    800ff8 <strnlen+0x18>
		n++;
  800fef:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ff2:	ff 45 08             	incl   0x8(%ebp)
  800ff5:	ff 4d 0c             	decl   0xc(%ebp)
  800ff8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ffc:	74 09                	je     801007 <strnlen+0x27>
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	84 c0                	test   %al,%al
  801005:	75 e8                	jne    800fef <strnlen+0xf>
		n++;
	return n;
  801007:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801018:	90                   	nop
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8d 50 01             	lea    0x1(%eax),%edx
  80101f:	89 55 08             	mov    %edx,0x8(%ebp)
  801022:	8b 55 0c             	mov    0xc(%ebp),%edx
  801025:	8d 4a 01             	lea    0x1(%edx),%ecx
  801028:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80102b:	8a 12                	mov    (%edx),%dl
  80102d:	88 10                	mov    %dl,(%eax)
  80102f:	8a 00                	mov    (%eax),%al
  801031:	84 c0                	test   %al,%al
  801033:	75 e4                	jne    801019 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801035:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801046:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80104d:	eb 1f                	jmp    80106e <strncpy+0x34>
		*dst++ = *src;
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	8d 50 01             	lea    0x1(%eax),%edx
  801055:	89 55 08             	mov    %edx,0x8(%ebp)
  801058:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105b:	8a 12                	mov    (%edx),%dl
  80105d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	84 c0                	test   %al,%al
  801066:	74 03                	je     80106b <strncpy+0x31>
			src++;
  801068:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80106b:	ff 45 fc             	incl   -0x4(%ebp)
  80106e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801071:	3b 45 10             	cmp    0x10(%ebp),%eax
  801074:	72 d9                	jb     80104f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801076:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801079:	c9                   	leave  
  80107a:	c3                   	ret    

0080107b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801087:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80108b:	74 30                	je     8010bd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80108d:	eb 16                	jmp    8010a5 <strlcpy+0x2a>
			*dst++ = *src++;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8d 50 01             	lea    0x1(%eax),%edx
  801095:	89 55 08             	mov    %edx,0x8(%ebp)
  801098:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80109e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010a1:	8a 12                	mov    (%edx),%dl
  8010a3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010a5:	ff 4d 10             	decl   0x10(%ebp)
  8010a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ac:	74 09                	je     8010b7 <strlcpy+0x3c>
  8010ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	84 c0                	test   %al,%al
  8010b5:	75 d8                	jne    80108f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c3:	29 c2                	sub    %eax,%edx
  8010c5:	89 d0                	mov    %edx,%eax
}
  8010c7:	c9                   	leave  
  8010c8:	c3                   	ret    

008010c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010cc:	eb 06                	jmp    8010d4 <strcmp+0xb>
		p++, q++;
  8010ce:	ff 45 08             	incl   0x8(%ebp)
  8010d1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	84 c0                	test   %al,%al
  8010db:	74 0e                	je     8010eb <strcmp+0x22>
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e0:	8a 10                	mov    (%eax),%dl
  8010e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	38 c2                	cmp    %al,%dl
  8010e9:	74 e3                	je     8010ce <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	0f b6 d0             	movzbl %al,%edx
  8010f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f6:	8a 00                	mov    (%eax),%al
  8010f8:	0f b6 c0             	movzbl %al,%eax
  8010fb:	29 c2                	sub    %eax,%edx
  8010fd:	89 d0                	mov    %edx,%eax
}
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    

00801101 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801104:	eb 09                	jmp    80110f <strncmp+0xe>
		n--, p++, q++;
  801106:	ff 4d 10             	decl   0x10(%ebp)
  801109:	ff 45 08             	incl   0x8(%ebp)
  80110c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80110f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801113:	74 17                	je     80112c <strncmp+0x2b>
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	84 c0                	test   %al,%al
  80111c:	74 0e                	je     80112c <strncmp+0x2b>
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8a 10                	mov    (%eax),%dl
  801123:	8b 45 0c             	mov    0xc(%ebp),%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	38 c2                	cmp    %al,%dl
  80112a:	74 da                	je     801106 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80112c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801130:	75 07                	jne    801139 <strncmp+0x38>
		return 0;
  801132:	b8 00 00 00 00       	mov    $0x0,%eax
  801137:	eb 14                	jmp    80114d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	0f b6 d0             	movzbl %al,%edx
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	0f b6 c0             	movzbl %al,%eax
  801149:	29 c2                	sub    %eax,%edx
  80114b:	89 d0                	mov    %edx,%eax
}
  80114d:	5d                   	pop    %ebp
  80114e:	c3                   	ret    

0080114f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	83 ec 04             	sub    $0x4,%esp
  801155:	8b 45 0c             	mov    0xc(%ebp),%eax
  801158:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80115b:	eb 12                	jmp    80116f <strchr+0x20>
		if (*s == c)
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801165:	75 05                	jne    80116c <strchr+0x1d>
			return (char *) s;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	eb 11                	jmp    80117d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80116c:	ff 45 08             	incl   0x8(%ebp)
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	84 c0                	test   %al,%al
  801176:	75 e5                	jne    80115d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801178:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 04             	sub    $0x4,%esp
  801185:	8b 45 0c             	mov    0xc(%ebp),%eax
  801188:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80118b:	eb 0d                	jmp    80119a <strfind+0x1b>
		if (*s == c)
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801195:	74 0e                	je     8011a5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801197:	ff 45 08             	incl   0x8(%ebp)
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	84 c0                	test   %al,%al
  8011a1:	75 ea                	jne    80118d <strfind+0xe>
  8011a3:	eb 01                	jmp    8011a6 <strfind+0x27>
		if (*s == c)
			break;
  8011a5:	90                   	nop
	return (char *) s;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011bd:	eb 0e                	jmp    8011cd <memset+0x22>
		*p++ = c;
  8011bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c2:	8d 50 01             	lea    0x1(%eax),%edx
  8011c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011cb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011cd:	ff 4d f8             	decl   -0x8(%ebp)
  8011d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8011d4:	79 e9                	jns    8011bf <memset+0x14>
		*p++ = c;

	return v;
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8011e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8011ed:	eb 16                	jmp    801205 <memcpy+0x2a>
		*d++ = *s++;
  8011ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f2:	8d 50 01             	lea    0x1(%eax),%edx
  8011f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011fe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801201:	8a 12                	mov    (%edx),%dl
  801203:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801205:	8b 45 10             	mov    0x10(%ebp),%eax
  801208:	8d 50 ff             	lea    -0x1(%eax),%edx
  80120b:	89 55 10             	mov    %edx,0x10(%ebp)
  80120e:	85 c0                	test   %eax,%eax
  801210:	75 dd                	jne    8011ef <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801215:	c9                   	leave  
  801216:	c3                   	ret    

00801217 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801229:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80122f:	73 50                	jae    801281 <memmove+0x6a>
  801231:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801234:	8b 45 10             	mov    0x10(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80123c:	76 43                	jbe    801281 <memmove+0x6a>
		s += n;
  80123e:	8b 45 10             	mov    0x10(%ebp),%eax
  801241:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801244:	8b 45 10             	mov    0x10(%ebp),%eax
  801247:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80124a:	eb 10                	jmp    80125c <memmove+0x45>
			*--d = *--s;
  80124c:	ff 4d f8             	decl   -0x8(%ebp)
  80124f:	ff 4d fc             	decl   -0x4(%ebp)
  801252:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801255:	8a 10                	mov    (%eax),%dl
  801257:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80125c:	8b 45 10             	mov    0x10(%ebp),%eax
  80125f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801262:	89 55 10             	mov    %edx,0x10(%ebp)
  801265:	85 c0                	test   %eax,%eax
  801267:	75 e3                	jne    80124c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801269:	eb 23                	jmp    80128e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80126b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126e:	8d 50 01             	lea    0x1(%eax),%edx
  801271:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801274:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801277:	8d 4a 01             	lea    0x1(%edx),%ecx
  80127a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80127d:	8a 12                	mov    (%edx),%dl
  80127f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801281:	8b 45 10             	mov    0x10(%ebp),%eax
  801284:	8d 50 ff             	lea    -0x1(%eax),%edx
  801287:	89 55 10             	mov    %edx,0x10(%ebp)
  80128a:	85 c0                	test   %eax,%eax
  80128c:	75 dd                	jne    80126b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    

00801293 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012a5:	eb 2a                	jmp    8012d1 <memcmp+0x3e>
		if (*s1 != *s2)
  8012a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012aa:	8a 10                	mov    (%eax),%dl
  8012ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	38 c2                	cmp    %al,%dl
  8012b3:	74 16                	je     8012cb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	0f b6 d0             	movzbl %al,%edx
  8012bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	0f b6 c0             	movzbl %al,%eax
  8012c5:	29 c2                	sub    %eax,%edx
  8012c7:	89 d0                	mov    %edx,%eax
  8012c9:	eb 18                	jmp    8012e3 <memcmp+0x50>
		s1++, s2++;
  8012cb:	ff 45 fc             	incl   -0x4(%ebp)
  8012ce:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	75 c9                	jne    8012a7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    

008012e5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8012eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f1:	01 d0                	add    %edx,%eax
  8012f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8012f6:	eb 15                	jmp    80130d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	0f b6 d0             	movzbl %al,%edx
  801300:	8b 45 0c             	mov    0xc(%ebp),%eax
  801303:	0f b6 c0             	movzbl %al,%eax
  801306:	39 c2                	cmp    %eax,%edx
  801308:	74 0d                	je     801317 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80130a:	ff 45 08             	incl   0x8(%ebp)
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801313:	72 e3                	jb     8012f8 <memfind+0x13>
  801315:	eb 01                	jmp    801318 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801317:	90                   	nop
	return (void *) s;
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801323:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80132a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801331:	eb 03                	jmp    801336 <strtol+0x19>
		s++;
  801333:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	3c 20                	cmp    $0x20,%al
  80133d:	74 f4                	je     801333 <strtol+0x16>
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8a 00                	mov    (%eax),%al
  801344:	3c 09                	cmp    $0x9,%al
  801346:	74 eb                	je     801333 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	3c 2b                	cmp    $0x2b,%al
  80134f:	75 05                	jne    801356 <strtol+0x39>
		s++;
  801351:	ff 45 08             	incl   0x8(%ebp)
  801354:	eb 13                	jmp    801369 <strtol+0x4c>
	else if (*s == '-')
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	8a 00                	mov    (%eax),%al
  80135b:	3c 2d                	cmp    $0x2d,%al
  80135d:	75 0a                	jne    801369 <strtol+0x4c>
		s++, neg = 1;
  80135f:	ff 45 08             	incl   0x8(%ebp)
  801362:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801369:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80136d:	74 06                	je     801375 <strtol+0x58>
  80136f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801373:	75 20                	jne    801395 <strtol+0x78>
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	8a 00                	mov    (%eax),%al
  80137a:	3c 30                	cmp    $0x30,%al
  80137c:	75 17                	jne    801395 <strtol+0x78>
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	40                   	inc    %eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	3c 78                	cmp    $0x78,%al
  801386:	75 0d                	jne    801395 <strtol+0x78>
		s += 2, base = 16;
  801388:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80138c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801393:	eb 28                	jmp    8013bd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801395:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801399:	75 15                	jne    8013b0 <strtol+0x93>
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	8a 00                	mov    (%eax),%al
  8013a0:	3c 30                	cmp    $0x30,%al
  8013a2:	75 0c                	jne    8013b0 <strtol+0x93>
		s++, base = 8;
  8013a4:	ff 45 08             	incl   0x8(%ebp)
  8013a7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013ae:	eb 0d                	jmp    8013bd <strtol+0xa0>
	else if (base == 0)
  8013b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b4:	75 07                	jne    8013bd <strtol+0xa0>
		base = 10;
  8013b6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	3c 2f                	cmp    $0x2f,%al
  8013c4:	7e 19                	jle    8013df <strtol+0xc2>
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	3c 39                	cmp    $0x39,%al
  8013cd:	7f 10                	jg     8013df <strtol+0xc2>
			dig = *s - '0';
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	0f be c0             	movsbl %al,%eax
  8013d7:	83 e8 30             	sub    $0x30,%eax
  8013da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013dd:	eb 42                	jmp    801421 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	3c 60                	cmp    $0x60,%al
  8013e6:	7e 19                	jle    801401 <strtol+0xe4>
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	8a 00                	mov    (%eax),%al
  8013ed:	3c 7a                	cmp    $0x7a,%al
  8013ef:	7f 10                	jg     801401 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	0f be c0             	movsbl %al,%eax
  8013f9:	83 e8 57             	sub    $0x57,%eax
  8013fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013ff:	eb 20                	jmp    801421 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	3c 40                	cmp    $0x40,%al
  801408:	7e 39                	jle    801443 <strtol+0x126>
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	3c 5a                	cmp    $0x5a,%al
  801411:	7f 30                	jg     801443 <strtol+0x126>
			dig = *s - 'A' + 10;
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	0f be c0             	movsbl %al,%eax
  80141b:	83 e8 37             	sub    $0x37,%eax
  80141e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801424:	3b 45 10             	cmp    0x10(%ebp),%eax
  801427:	7d 19                	jge    801442 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801429:	ff 45 08             	incl   0x8(%ebp)
  80142c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801433:	89 c2                	mov    %eax,%edx
  801435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80143d:	e9 7b ff ff ff       	jmp    8013bd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801442:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801443:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801447:	74 08                	je     801451 <strtol+0x134>
		*endptr = (char *) s;
  801449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144c:	8b 55 08             	mov    0x8(%ebp),%edx
  80144f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801451:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801455:	74 07                	je     80145e <strtol+0x141>
  801457:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145a:	f7 d8                	neg    %eax
  80145c:	eb 03                	jmp    801461 <strtol+0x144>
  80145e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <ltostr>:

void
ltostr(long value, char *str)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801469:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801470:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801477:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80147b:	79 13                	jns    801490 <ltostr+0x2d>
	{
		neg = 1;
  80147d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801484:	8b 45 0c             	mov    0xc(%ebp),%eax
  801487:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80148a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80148d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801498:	99                   	cltd   
  801499:	f7 f9                	idiv   %ecx
  80149b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80149e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a1:	8d 50 01             	lea    0x1(%eax),%edx
  8014a4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014a7:	89 c2                	mov    %eax,%edx
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	01 d0                	add    %edx,%eax
  8014ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014b1:	83 c2 30             	add    $0x30,%edx
  8014b4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014b9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014be:	f7 e9                	imul   %ecx
  8014c0:	c1 fa 02             	sar    $0x2,%edx
  8014c3:	89 c8                	mov    %ecx,%eax
  8014c5:	c1 f8 1f             	sar    $0x1f,%eax
  8014c8:	29 c2                	sub    %eax,%edx
  8014ca:	89 d0                	mov    %edx,%eax
  8014cc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8014cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014d2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014d7:	f7 e9                	imul   %ecx
  8014d9:	c1 fa 02             	sar    $0x2,%edx
  8014dc:	89 c8                	mov    %ecx,%eax
  8014de:	c1 f8 1f             	sar    $0x1f,%eax
  8014e1:	29 c2                	sub    %eax,%edx
  8014e3:	89 d0                	mov    %edx,%eax
  8014e5:	c1 e0 02             	shl    $0x2,%eax
  8014e8:	01 d0                	add    %edx,%eax
  8014ea:	01 c0                	add    %eax,%eax
  8014ec:	29 c1                	sub    %eax,%ecx
  8014ee:	89 ca                	mov    %ecx,%edx
  8014f0:	85 d2                	test   %edx,%edx
  8014f2:	75 9c                	jne    801490 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8014f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8014fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fe:	48                   	dec    %eax
  8014ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801502:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801506:	74 3d                	je     801545 <ltostr+0xe2>
		start = 1 ;
  801508:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80150f:	eb 34                	jmp    801545 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801511:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801514:	8b 45 0c             	mov    0xc(%ebp),%eax
  801517:	01 d0                	add    %edx,%eax
  801519:	8a 00                	mov    (%eax),%al
  80151b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80151e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801521:	8b 45 0c             	mov    0xc(%ebp),%eax
  801524:	01 c2                	add    %eax,%edx
  801526:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152c:	01 c8                	add    %ecx,%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801532:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801535:	8b 45 0c             	mov    0xc(%ebp),%eax
  801538:	01 c2                	add    %eax,%edx
  80153a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80153d:	88 02                	mov    %al,(%edx)
		start++ ;
  80153f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801542:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801548:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80154b:	7c c4                	jl     801511 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80154d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801550:	8b 45 0c             	mov    0xc(%ebp),%eax
  801553:	01 d0                	add    %edx,%eax
  801555:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801558:	90                   	nop
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801561:	ff 75 08             	pushl  0x8(%ebp)
  801564:	e8 54 fa ff ff       	call   800fbd <strlen>
  801569:	83 c4 04             	add    $0x4,%esp
  80156c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	e8 46 fa ff ff       	call   800fbd <strlen>
  801577:	83 c4 04             	add    $0x4,%esp
  80157a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80157d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801584:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80158b:	eb 17                	jmp    8015a4 <strcconcat+0x49>
		final[s] = str1[s] ;
  80158d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801590:	8b 45 10             	mov    0x10(%ebp),%eax
  801593:	01 c2                	add    %eax,%edx
  801595:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	01 c8                	add    %ecx,%eax
  80159d:	8a 00                	mov    (%eax),%al
  80159f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015a1:	ff 45 fc             	incl   -0x4(%ebp)
  8015a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015aa:	7c e1                	jl     80158d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015b3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015ba:	eb 1f                	jmp    8015db <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015bf:	8d 50 01             	lea    0x1(%eax),%edx
  8015c2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015c5:	89 c2                	mov    %eax,%edx
  8015c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ca:	01 c2                	add    %eax,%edx
  8015cc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d2:	01 c8                	add    %ecx,%eax
  8015d4:	8a 00                	mov    (%eax),%al
  8015d6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8015d8:	ff 45 f8             	incl   -0x8(%ebp)
  8015db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e1:	7c d9                	jl     8015bc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8015e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e9:	01 d0                	add    %edx,%eax
  8015eb:	c6 00 00             	movb   $0x0,(%eax)
}
  8015ee:	90                   	nop
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8015f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8015fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801600:	8b 00                	mov    (%eax),%eax
  801602:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801609:	8b 45 10             	mov    0x10(%ebp),%eax
  80160c:	01 d0                	add    %edx,%eax
  80160e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801614:	eb 0c                	jmp    801622 <strsplit+0x31>
			*string++ = 0;
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	8d 50 01             	lea    0x1(%eax),%edx
  80161c:	89 55 08             	mov    %edx,0x8(%ebp)
  80161f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	8a 00                	mov    (%eax),%al
  801627:	84 c0                	test   %al,%al
  801629:	74 18                	je     801643 <strsplit+0x52>
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	0f be c0             	movsbl %al,%eax
  801633:	50                   	push   %eax
  801634:	ff 75 0c             	pushl  0xc(%ebp)
  801637:	e8 13 fb ff ff       	call   80114f <strchr>
  80163c:	83 c4 08             	add    $0x8,%esp
  80163f:	85 c0                	test   %eax,%eax
  801641:	75 d3                	jne    801616 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	8a 00                	mov    (%eax),%al
  801648:	84 c0                	test   %al,%al
  80164a:	74 5a                	je     8016a6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80164c:	8b 45 14             	mov    0x14(%ebp),%eax
  80164f:	8b 00                	mov    (%eax),%eax
  801651:	83 f8 0f             	cmp    $0xf,%eax
  801654:	75 07                	jne    80165d <strsplit+0x6c>
		{
			return 0;
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
  80165b:	eb 66                	jmp    8016c3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80165d:	8b 45 14             	mov    0x14(%ebp),%eax
  801660:	8b 00                	mov    (%eax),%eax
  801662:	8d 48 01             	lea    0x1(%eax),%ecx
  801665:	8b 55 14             	mov    0x14(%ebp),%edx
  801668:	89 0a                	mov    %ecx,(%edx)
  80166a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801671:	8b 45 10             	mov    0x10(%ebp),%eax
  801674:	01 c2                	add    %eax,%edx
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80167b:	eb 03                	jmp    801680 <strsplit+0x8f>
			string++;
  80167d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	8a 00                	mov    (%eax),%al
  801685:	84 c0                	test   %al,%al
  801687:	74 8b                	je     801614 <strsplit+0x23>
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	8a 00                	mov    (%eax),%al
  80168e:	0f be c0             	movsbl %al,%eax
  801691:	50                   	push   %eax
  801692:	ff 75 0c             	pushl  0xc(%ebp)
  801695:	e8 b5 fa ff ff       	call   80114f <strchr>
  80169a:	83 c4 08             	add    $0x8,%esp
  80169d:	85 c0                	test   %eax,%eax
  80169f:	74 dc                	je     80167d <strsplit+0x8c>
			string++;
	}
  8016a1:	e9 6e ff ff ff       	jmp    801614 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016a6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016aa:	8b 00                	mov    (%eax),%eax
  8016ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b6:	01 d0                	add    %edx,%eax
  8016b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <malloc>:
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

void* malloc(uint32 size)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020  - User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8016cb:	83 ec 04             	sub    $0x4,%esp
  8016ce:	68 f0 29 80 00       	push   $0x8029f0
  8016d3:	6a 19                	push   $0x19
  8016d5:	68 15 2a 80 00       	push   $0x802a15
  8016da:	e8 ba ef ff ff       	call   800699 <_panic>

008016df <smalloc>:
	//change this "return" according to your answer
	return 0;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	83 ec 18             	sub    $0x18,%esp
  8016e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e8:	88 45 f4             	mov    %al,-0xc(%ebp)
	//TODO: [PROJECT 2020  - Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	68 24 2a 80 00       	push   $0x802a24
  8016f3:	6a 31                	push   $0x31
  8016f5:	68 15 2a 80 00       	push   $0x802a15
  8016fa:	e8 9a ef ff ff       	call   800699 <_panic>

008016ff <sget>:
	//change this "return" according to your answer
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 -  Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	68 4c 2a 80 00       	push   $0x802a4c
  80170d:	6a 4a                	push   $0x4a
  80170f:	68 15 2a 80 00       	push   $0x802a15
  801714:	e8 80 ef ff ff       	call   800699 <_panic>

00801719 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80171f:	83 ec 04             	sub    $0x4,%esp
  801722:	68 70 2a 80 00       	push   $0x802a70
  801727:	6a 70                	push   $0x70
  801729:	68 15 2a 80 00       	push   $0x802a15
  80172e:	e8 66 ef ff ff       	call   800699 <_panic>

00801733 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801739:	83 ec 04             	sub    $0x4,%esp
  80173c:	68 94 2a 80 00       	push   $0x802a94
  801741:	68 8b 00 00 00       	push   $0x8b
  801746:	68 15 2a 80 00       	push   $0x802a15
  80174b:	e8 49 ef ff ff       	call   800699 <_panic>

00801750 <realloc>:
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	68 b8 2a 80 00       	push   $0x802ab8
  80175e:	68 a8 00 00 00       	push   $0xa8
  801763:	68 15 2a 80 00       	push   $0x802a15
  801768:	e8 2c ef ff ff       	call   800699 <_panic>

0080176d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	57                   	push   %edi
  801771:	56                   	push   %esi
  801772:	53                   	push   %ebx
  801773:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801782:	8b 7d 18             	mov    0x18(%ebp),%edi
  801785:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801788:	cd 30                	int    $0x30
  80178a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80178d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	5b                   	pop    %ebx
  801794:	5e                   	pop    %esi
  801795:	5f                   	pop    %edi
  801796:	5d                   	pop    %ebp
  801797:	c3                   	ret    

00801798 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 04             	sub    $0x4,%esp
  80179e:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017a4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	52                   	push   %edx
  8017b0:	ff 75 0c             	pushl  0xc(%ebp)
  8017b3:	50                   	push   %eax
  8017b4:	6a 00                	push   $0x0
  8017b6:	e8 b2 ff ff ff       	call   80176d <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
}
  8017be:	90                   	nop
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 01                	push   $0x1
  8017d0:	e8 98 ff ff ff       	call   80176d <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
}
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	50                   	push   %eax
  8017e9:	6a 05                	push   $0x5
  8017eb:	e8 7d ff ff ff       	call   80176d <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 02                	push   $0x2
  801804:	e8 64 ff ff ff       	call   80176d <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 03                	push   $0x3
  80181d:	e8 4b ff ff ff       	call   80176d <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 04                	push   $0x4
  801836:	e8 32 ff ff ff       	call   80176d <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_env_exit>:


void sys_env_exit(void)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 06                	push   $0x6
  80184f:	e8 19 ff ff ff       	call   80176d <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	90                   	nop
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	52                   	push   %edx
  80186a:	50                   	push   %eax
  80186b:	6a 07                	push   $0x7
  80186d:	e8 fb fe ff ff       	call   80176d <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	56                   	push   %esi
  80187b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80187c:	8b 75 18             	mov    0x18(%ebp),%esi
  80187f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801882:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801885:	8b 55 0c             	mov    0xc(%ebp),%edx
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	56                   	push   %esi
  80188c:	53                   	push   %ebx
  80188d:	51                   	push   %ecx
  80188e:	52                   	push   %edx
  80188f:	50                   	push   %eax
  801890:	6a 08                	push   $0x8
  801892:	e8 d6 fe ff ff       	call   80176d <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
}
  80189a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189d:	5b                   	pop    %ebx
  80189e:	5e                   	pop    %esi
  80189f:	5d                   	pop    %ebp
  8018a0:	c3                   	ret    

008018a1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	52                   	push   %edx
  8018b1:	50                   	push   %eax
  8018b2:	6a 09                	push   $0x9
  8018b4:	e8 b4 fe ff ff       	call   80176d <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ca:	ff 75 08             	pushl  0x8(%ebp)
  8018cd:	6a 0a                	push   $0xa
  8018cf:	e8 99 fe ff ff       	call   80176d <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 0b                	push   $0xb
  8018e8:	e8 80 fe ff ff       	call   80176d <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 0c                	push   $0xc
  801901:	e8 67 fe ff ff       	call   80176d <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 0d                	push   $0xd
  80191a:	e8 4e fe ff ff       	call   80176d <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	ff 75 0c             	pushl  0xc(%ebp)
  801930:	ff 75 08             	pushl  0x8(%ebp)
  801933:	6a 11                	push   $0x11
  801935:	e8 33 fe ff ff       	call   80176d <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
	return;
  80193d:	90                   	nop
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	ff 75 0c             	pushl  0xc(%ebp)
  80194c:	ff 75 08             	pushl  0x8(%ebp)
  80194f:	6a 12                	push   $0x12
  801951:	e8 17 fe ff ff       	call   80176d <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
	return ;
  801959:	90                   	nop
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 0e                	push   $0xe
  80196b:	e8 fd fd ff ff       	call   80176d <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	ff 75 08             	pushl  0x8(%ebp)
  801983:	6a 0f                	push   $0xf
  801985:	e8 e3 fd ff ff       	call   80176d <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 10                	push   $0x10
  80199e:	e8 ca fd ff ff       	call   80176d <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	90                   	nop
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 14                	push   $0x14
  8019b8:	e8 b0 fd ff ff       	call   80176d <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	90                   	nop
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 15                	push   $0x15
  8019d2:	e8 96 fd ff ff       	call   80176d <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	90                   	nop
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_cputc>:


void
sys_cputc(const char c)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 04             	sub    $0x4,%esp
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019e9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	50                   	push   %eax
  8019f6:	6a 16                	push   $0x16
  8019f8:	e8 70 fd ff ff       	call   80176d <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	90                   	nop
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 17                	push   $0x17
  801a12:	e8 56 fd ff ff       	call   80176d <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	90                   	nop
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	ff 75 0c             	pushl  0xc(%ebp)
  801a2c:	50                   	push   %eax
  801a2d:	6a 18                	push   $0x18
  801a2f:	e8 39 fd ff ff       	call   80176d <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	52                   	push   %edx
  801a49:	50                   	push   %eax
  801a4a:	6a 1b                	push   $0x1b
  801a4c:	e8 1c fd ff ff       	call   80176d <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	52                   	push   %edx
  801a66:	50                   	push   %eax
  801a67:	6a 19                	push   $0x19
  801a69:	e8 ff fc ff ff       	call   80176d <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	90                   	nop
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	52                   	push   %edx
  801a84:	50                   	push   %eax
  801a85:	6a 1a                	push   $0x1a
  801a87:	e8 e1 fc ff ff       	call   80176d <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	90                   	nop
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 04             	sub    $0x4,%esp
  801a98:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a9e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	6a 00                	push   $0x0
  801aaa:	51                   	push   %ecx
  801aab:	52                   	push   %edx
  801aac:	ff 75 0c             	pushl  0xc(%ebp)
  801aaf:	50                   	push   %eax
  801ab0:	6a 1c                	push   $0x1c
  801ab2:	e8 b6 fc ff ff       	call   80176d <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801abf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	52                   	push   %edx
  801acc:	50                   	push   %eax
  801acd:	6a 1d                	push   $0x1d
  801acf:	e8 99 fc ff ff       	call   80176d <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801adc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	51                   	push   %ecx
  801aea:	52                   	push   %edx
  801aeb:	50                   	push   %eax
  801aec:	6a 1e                	push   $0x1e
  801aee:	e8 7a fc ff ff       	call   80176d <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	52                   	push   %edx
  801b08:	50                   	push   %eax
  801b09:	6a 1f                	push   $0x1f
  801b0b:	e8 5d fc ff ff       	call   80176d <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 20                	push   $0x20
  801b24:	e8 44 fc ff ff       	call   80176d <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int percent_WS_pages_to_remove)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size, (uint32)percent_WS_pages_to_remove, 0,0);
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	ff 75 10             	pushl  0x10(%ebp)
  801b3b:	ff 75 0c             	pushl  0xc(%ebp)
  801b3e:	50                   	push   %eax
  801b3f:	6a 21                	push   $0x21
  801b41:	e8 27 fc ff ff       	call   80176d <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_run_env>:


void
sys_run_env(int32 envId)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	50                   	push   %eax
  801b5a:	6a 22                	push   $0x22
  801b5c:	e8 0c fc ff ff       	call   80176d <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	90                   	nop
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	50                   	push   %eax
  801b76:	6a 23                	push   $0x23
  801b78:	e8 f0 fb ff ff       	call   80176d <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	90                   	nop
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b89:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b8c:	8d 50 04             	lea    0x4(%eax),%edx
  801b8f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	52                   	push   %edx
  801b99:	50                   	push   %eax
  801b9a:	6a 24                	push   $0x24
  801b9c:	e8 cc fb ff ff       	call   80176d <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
	return result;
  801ba4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801baa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bad:	89 01                	mov    %eax,(%ecx)
  801baf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	c9                   	leave  
  801bb6:	c2 04 00             	ret    $0x4

00801bb9 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	ff 75 10             	pushl  0x10(%ebp)
  801bc3:	ff 75 0c             	pushl  0xc(%ebp)
  801bc6:	ff 75 08             	pushl  0x8(%ebp)
  801bc9:	6a 13                	push   $0x13
  801bcb:	e8 9d fb ff ff       	call   80176d <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd3:	90                   	nop
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 25                	push   $0x25
  801be5:	e8 83 fb ff ff       	call   80176d <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bfb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	50                   	push   %eax
  801c08:	6a 26                	push   $0x26
  801c0a:	e8 5e fb ff ff       	call   80176d <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c12:	90                   	nop
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <rsttst>:
void rsttst()
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 28                	push   $0x28
  801c24:	e8 44 fb ff ff       	call   80176d <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2c:	90                   	nop
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 04             	sub    $0x4,%esp
  801c35:	8b 45 14             	mov    0x14(%ebp),%eax
  801c38:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c3b:	8b 55 18             	mov    0x18(%ebp),%edx
  801c3e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c42:	52                   	push   %edx
  801c43:	50                   	push   %eax
  801c44:	ff 75 10             	pushl  0x10(%ebp)
  801c47:	ff 75 0c             	pushl  0xc(%ebp)
  801c4a:	ff 75 08             	pushl  0x8(%ebp)
  801c4d:	6a 27                	push   $0x27
  801c4f:	e8 19 fb ff ff       	call   80176d <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
	return ;
  801c57:	90                   	nop
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <chktst>:
void chktst(uint32 n)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	ff 75 08             	pushl  0x8(%ebp)
  801c68:	6a 29                	push   $0x29
  801c6a:	e8 fe fa ff ff       	call   80176d <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c72:	90                   	nop
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <inctst>:

void inctst()
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 2a                	push   $0x2a
  801c84:	e8 e4 fa ff ff       	call   80176d <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8c:	90                   	nop
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <gettst>:
uint32 gettst()
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 2b                	push   $0x2b
  801c9e:	e8 ca fa ff ff       	call   80176d <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 2c                	push   $0x2c
  801cba:	e8 ae fa ff ff       	call   80176d <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
  801cc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cc5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cc9:	75 07                	jne    801cd2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ccb:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd0:	eb 05                	jmp    801cd7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 2c                	push   $0x2c
  801ceb:	e8 7d fa ff ff       	call   80176d <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
  801cf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cf6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cfa:	75 07                	jne    801d03 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cfc:	b8 01 00 00 00       	mov    $0x1,%eax
  801d01:	eb 05                	jmp    801d08 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 2c                	push   $0x2c
  801d1c:	e8 4c fa ff ff       	call   80176d <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
  801d24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d27:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d2b:	75 07                	jne    801d34 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d32:	eb 05                	jmp    801d39 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 2c                	push   $0x2c
  801d4d:	e8 1b fa ff ff       	call   80176d <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
  801d55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d58:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d5c:	75 07                	jne    801d65 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d63:	eb 05                	jmp    801d6a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	ff 75 08             	pushl  0x8(%ebp)
  801d7a:	6a 2d                	push   $0x2d
  801d7c:	e8 ec f9 ff ff       	call   80176d <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
	return ;
  801d84:	90                   	nop
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d8b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	6a 00                	push   $0x0
  801d99:	53                   	push   %ebx
  801d9a:	51                   	push   %ecx
  801d9b:	52                   	push   %edx
  801d9c:	50                   	push   %eax
  801d9d:	6a 2e                	push   $0x2e
  801d9f:	e8 c9 f9 ff ff       	call   80176d <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801daf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	52                   	push   %edx
  801dbc:	50                   	push   %eax
  801dbd:	6a 2f                	push   $0x2f
  801dbf:	e8 a9 f9 ff ff       	call   80176d <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    
  801dc9:	66 90                	xchg   %ax,%ax
  801dcb:	90                   	nop

00801dcc <__udivdi3>:
  801dcc:	55                   	push   %ebp
  801dcd:	57                   	push   %edi
  801dce:	56                   	push   %esi
  801dcf:	53                   	push   %ebx
  801dd0:	83 ec 1c             	sub    $0x1c,%esp
  801dd3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801dd7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ddb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ddf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801de3:	89 ca                	mov    %ecx,%edx
  801de5:	89 f8                	mov    %edi,%eax
  801de7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801deb:	85 f6                	test   %esi,%esi
  801ded:	75 2d                	jne    801e1c <__udivdi3+0x50>
  801def:	39 cf                	cmp    %ecx,%edi
  801df1:	77 65                	ja     801e58 <__udivdi3+0x8c>
  801df3:	89 fd                	mov    %edi,%ebp
  801df5:	85 ff                	test   %edi,%edi
  801df7:	75 0b                	jne    801e04 <__udivdi3+0x38>
  801df9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfe:	31 d2                	xor    %edx,%edx
  801e00:	f7 f7                	div    %edi
  801e02:	89 c5                	mov    %eax,%ebp
  801e04:	31 d2                	xor    %edx,%edx
  801e06:	89 c8                	mov    %ecx,%eax
  801e08:	f7 f5                	div    %ebp
  801e0a:	89 c1                	mov    %eax,%ecx
  801e0c:	89 d8                	mov    %ebx,%eax
  801e0e:	f7 f5                	div    %ebp
  801e10:	89 cf                	mov    %ecx,%edi
  801e12:	89 fa                	mov    %edi,%edx
  801e14:	83 c4 1c             	add    $0x1c,%esp
  801e17:	5b                   	pop    %ebx
  801e18:	5e                   	pop    %esi
  801e19:	5f                   	pop    %edi
  801e1a:	5d                   	pop    %ebp
  801e1b:	c3                   	ret    
  801e1c:	39 ce                	cmp    %ecx,%esi
  801e1e:	77 28                	ja     801e48 <__udivdi3+0x7c>
  801e20:	0f bd fe             	bsr    %esi,%edi
  801e23:	83 f7 1f             	xor    $0x1f,%edi
  801e26:	75 40                	jne    801e68 <__udivdi3+0x9c>
  801e28:	39 ce                	cmp    %ecx,%esi
  801e2a:	72 0a                	jb     801e36 <__udivdi3+0x6a>
  801e2c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e30:	0f 87 9e 00 00 00    	ja     801ed4 <__udivdi3+0x108>
  801e36:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3b:	89 fa                	mov    %edi,%edx
  801e3d:	83 c4 1c             	add    $0x1c,%esp
  801e40:	5b                   	pop    %ebx
  801e41:	5e                   	pop    %esi
  801e42:	5f                   	pop    %edi
  801e43:	5d                   	pop    %ebp
  801e44:	c3                   	ret    
  801e45:	8d 76 00             	lea    0x0(%esi),%esi
  801e48:	31 ff                	xor    %edi,%edi
  801e4a:	31 c0                	xor    %eax,%eax
  801e4c:	89 fa                	mov    %edi,%edx
  801e4e:	83 c4 1c             	add    $0x1c,%esp
  801e51:	5b                   	pop    %ebx
  801e52:	5e                   	pop    %esi
  801e53:	5f                   	pop    %edi
  801e54:	5d                   	pop    %ebp
  801e55:	c3                   	ret    
  801e56:	66 90                	xchg   %ax,%ax
  801e58:	89 d8                	mov    %ebx,%eax
  801e5a:	f7 f7                	div    %edi
  801e5c:	31 ff                	xor    %edi,%edi
  801e5e:	89 fa                	mov    %edi,%edx
  801e60:	83 c4 1c             	add    $0x1c,%esp
  801e63:	5b                   	pop    %ebx
  801e64:	5e                   	pop    %esi
  801e65:	5f                   	pop    %edi
  801e66:	5d                   	pop    %ebp
  801e67:	c3                   	ret    
  801e68:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e6d:	89 eb                	mov    %ebp,%ebx
  801e6f:	29 fb                	sub    %edi,%ebx
  801e71:	89 f9                	mov    %edi,%ecx
  801e73:	d3 e6                	shl    %cl,%esi
  801e75:	89 c5                	mov    %eax,%ebp
  801e77:	88 d9                	mov    %bl,%cl
  801e79:	d3 ed                	shr    %cl,%ebp
  801e7b:	89 e9                	mov    %ebp,%ecx
  801e7d:	09 f1                	or     %esi,%ecx
  801e7f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e83:	89 f9                	mov    %edi,%ecx
  801e85:	d3 e0                	shl    %cl,%eax
  801e87:	89 c5                	mov    %eax,%ebp
  801e89:	89 d6                	mov    %edx,%esi
  801e8b:	88 d9                	mov    %bl,%cl
  801e8d:	d3 ee                	shr    %cl,%esi
  801e8f:	89 f9                	mov    %edi,%ecx
  801e91:	d3 e2                	shl    %cl,%edx
  801e93:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e97:	88 d9                	mov    %bl,%cl
  801e99:	d3 e8                	shr    %cl,%eax
  801e9b:	09 c2                	or     %eax,%edx
  801e9d:	89 d0                	mov    %edx,%eax
  801e9f:	89 f2                	mov    %esi,%edx
  801ea1:	f7 74 24 0c          	divl   0xc(%esp)
  801ea5:	89 d6                	mov    %edx,%esi
  801ea7:	89 c3                	mov    %eax,%ebx
  801ea9:	f7 e5                	mul    %ebp
  801eab:	39 d6                	cmp    %edx,%esi
  801ead:	72 19                	jb     801ec8 <__udivdi3+0xfc>
  801eaf:	74 0b                	je     801ebc <__udivdi3+0xf0>
  801eb1:	89 d8                	mov    %ebx,%eax
  801eb3:	31 ff                	xor    %edi,%edi
  801eb5:	e9 58 ff ff ff       	jmp    801e12 <__udivdi3+0x46>
  801eba:	66 90                	xchg   %ax,%ax
  801ebc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ec0:	89 f9                	mov    %edi,%ecx
  801ec2:	d3 e2                	shl    %cl,%edx
  801ec4:	39 c2                	cmp    %eax,%edx
  801ec6:	73 e9                	jae    801eb1 <__udivdi3+0xe5>
  801ec8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ecb:	31 ff                	xor    %edi,%edi
  801ecd:	e9 40 ff ff ff       	jmp    801e12 <__udivdi3+0x46>
  801ed2:	66 90                	xchg   %ax,%ax
  801ed4:	31 c0                	xor    %eax,%eax
  801ed6:	e9 37 ff ff ff       	jmp    801e12 <__udivdi3+0x46>
  801edb:	90                   	nop

00801edc <__umoddi3>:
  801edc:	55                   	push   %ebp
  801edd:	57                   	push   %edi
  801ede:	56                   	push   %esi
  801edf:	53                   	push   %ebx
  801ee0:	83 ec 1c             	sub    $0x1c,%esp
  801ee3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ee7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801eeb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801eef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ef3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ef7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801efb:	89 f3                	mov    %esi,%ebx
  801efd:	89 fa                	mov    %edi,%edx
  801eff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f03:	89 34 24             	mov    %esi,(%esp)
  801f06:	85 c0                	test   %eax,%eax
  801f08:	75 1a                	jne    801f24 <__umoddi3+0x48>
  801f0a:	39 f7                	cmp    %esi,%edi
  801f0c:	0f 86 a2 00 00 00    	jbe    801fb4 <__umoddi3+0xd8>
  801f12:	89 c8                	mov    %ecx,%eax
  801f14:	89 f2                	mov    %esi,%edx
  801f16:	f7 f7                	div    %edi
  801f18:	89 d0                	mov    %edx,%eax
  801f1a:	31 d2                	xor    %edx,%edx
  801f1c:	83 c4 1c             	add    $0x1c,%esp
  801f1f:	5b                   	pop    %ebx
  801f20:	5e                   	pop    %esi
  801f21:	5f                   	pop    %edi
  801f22:	5d                   	pop    %ebp
  801f23:	c3                   	ret    
  801f24:	39 f0                	cmp    %esi,%eax
  801f26:	0f 87 ac 00 00 00    	ja     801fd8 <__umoddi3+0xfc>
  801f2c:	0f bd e8             	bsr    %eax,%ebp
  801f2f:	83 f5 1f             	xor    $0x1f,%ebp
  801f32:	0f 84 ac 00 00 00    	je     801fe4 <__umoddi3+0x108>
  801f38:	bf 20 00 00 00       	mov    $0x20,%edi
  801f3d:	29 ef                	sub    %ebp,%edi
  801f3f:	89 fe                	mov    %edi,%esi
  801f41:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f45:	89 e9                	mov    %ebp,%ecx
  801f47:	d3 e0                	shl    %cl,%eax
  801f49:	89 d7                	mov    %edx,%edi
  801f4b:	89 f1                	mov    %esi,%ecx
  801f4d:	d3 ef                	shr    %cl,%edi
  801f4f:	09 c7                	or     %eax,%edi
  801f51:	89 e9                	mov    %ebp,%ecx
  801f53:	d3 e2                	shl    %cl,%edx
  801f55:	89 14 24             	mov    %edx,(%esp)
  801f58:	89 d8                	mov    %ebx,%eax
  801f5a:	d3 e0                	shl    %cl,%eax
  801f5c:	89 c2                	mov    %eax,%edx
  801f5e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f62:	d3 e0                	shl    %cl,%eax
  801f64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f68:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f6c:	89 f1                	mov    %esi,%ecx
  801f6e:	d3 e8                	shr    %cl,%eax
  801f70:	09 d0                	or     %edx,%eax
  801f72:	d3 eb                	shr    %cl,%ebx
  801f74:	89 da                	mov    %ebx,%edx
  801f76:	f7 f7                	div    %edi
  801f78:	89 d3                	mov    %edx,%ebx
  801f7a:	f7 24 24             	mull   (%esp)
  801f7d:	89 c6                	mov    %eax,%esi
  801f7f:	89 d1                	mov    %edx,%ecx
  801f81:	39 d3                	cmp    %edx,%ebx
  801f83:	0f 82 87 00 00 00    	jb     802010 <__umoddi3+0x134>
  801f89:	0f 84 91 00 00 00    	je     802020 <__umoddi3+0x144>
  801f8f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f93:	29 f2                	sub    %esi,%edx
  801f95:	19 cb                	sbb    %ecx,%ebx
  801f97:	89 d8                	mov    %ebx,%eax
  801f99:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f9d:	d3 e0                	shl    %cl,%eax
  801f9f:	89 e9                	mov    %ebp,%ecx
  801fa1:	d3 ea                	shr    %cl,%edx
  801fa3:	09 d0                	or     %edx,%eax
  801fa5:	89 e9                	mov    %ebp,%ecx
  801fa7:	d3 eb                	shr    %cl,%ebx
  801fa9:	89 da                	mov    %ebx,%edx
  801fab:	83 c4 1c             	add    $0x1c,%esp
  801fae:	5b                   	pop    %ebx
  801faf:	5e                   	pop    %esi
  801fb0:	5f                   	pop    %edi
  801fb1:	5d                   	pop    %ebp
  801fb2:	c3                   	ret    
  801fb3:	90                   	nop
  801fb4:	89 fd                	mov    %edi,%ebp
  801fb6:	85 ff                	test   %edi,%edi
  801fb8:	75 0b                	jne    801fc5 <__umoddi3+0xe9>
  801fba:	b8 01 00 00 00       	mov    $0x1,%eax
  801fbf:	31 d2                	xor    %edx,%edx
  801fc1:	f7 f7                	div    %edi
  801fc3:	89 c5                	mov    %eax,%ebp
  801fc5:	89 f0                	mov    %esi,%eax
  801fc7:	31 d2                	xor    %edx,%edx
  801fc9:	f7 f5                	div    %ebp
  801fcb:	89 c8                	mov    %ecx,%eax
  801fcd:	f7 f5                	div    %ebp
  801fcf:	89 d0                	mov    %edx,%eax
  801fd1:	e9 44 ff ff ff       	jmp    801f1a <__umoddi3+0x3e>
  801fd6:	66 90                	xchg   %ax,%ax
  801fd8:	89 c8                	mov    %ecx,%eax
  801fda:	89 f2                	mov    %esi,%edx
  801fdc:	83 c4 1c             	add    $0x1c,%esp
  801fdf:	5b                   	pop    %ebx
  801fe0:	5e                   	pop    %esi
  801fe1:	5f                   	pop    %edi
  801fe2:	5d                   	pop    %ebp
  801fe3:	c3                   	ret    
  801fe4:	3b 04 24             	cmp    (%esp),%eax
  801fe7:	72 06                	jb     801fef <__umoddi3+0x113>
  801fe9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801fed:	77 0f                	ja     801ffe <__umoddi3+0x122>
  801fef:	89 f2                	mov    %esi,%edx
  801ff1:	29 f9                	sub    %edi,%ecx
  801ff3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ff7:	89 14 24             	mov    %edx,(%esp)
  801ffa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ffe:	8b 44 24 04          	mov    0x4(%esp),%eax
  802002:	8b 14 24             	mov    (%esp),%edx
  802005:	83 c4 1c             	add    $0x1c,%esp
  802008:	5b                   	pop    %ebx
  802009:	5e                   	pop    %esi
  80200a:	5f                   	pop    %edi
  80200b:	5d                   	pop    %ebp
  80200c:	c3                   	ret    
  80200d:	8d 76 00             	lea    0x0(%esi),%esi
  802010:	2b 04 24             	sub    (%esp),%eax
  802013:	19 fa                	sbb    %edi,%edx
  802015:	89 d1                	mov    %edx,%ecx
  802017:	89 c6                	mov    %eax,%esi
  802019:	e9 71 ff ff ff       	jmp    801f8f <__umoddi3+0xb3>
  80201e:	66 90                	xchg   %ax,%ax
  802020:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802024:	72 ea                	jb     802010 <__umoddi3+0x134>
  802026:	89 d9                	mov    %ebx,%ecx
  802028:	e9 62 ff ff ff       	jmp    801f8f <__umoddi3+0xb3>
