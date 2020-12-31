
#include <inc/lib.h>
// malloc()
//	This function use FIRST FIT strategy to allocate space in heap
//  with the given size and return void pointer to the start of the allocated space

//	To do this, we need to switch to the kernel, allocate the required space
//	in Page File then switch back to the user again.
//
//	We can use sys_allocateMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls allocateMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the allocateMem function is empty, make sure to implement it.

#define USER_HEAP_SIZE (USER_HEAP_MAX - USER_HEAP_START)
#define USER_HEAP_MEMORY_ITEMS (USER_HEAP_SIZE / PAGE_SIZE)
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
uint32 number_allocated = 0;
struct allocated_memory {
	uint32 va;
	uint32 size;
} allocated_array[USER_HEAP_MEMORY_ITEMS];

struct user_heap_file {
	uint32 va;
	uint32 used;
} user_heap[USER_HEAP_MEMORY_ITEMS];

int is_initialized = 0;

void init() {
	if(is_initialized == 1)
		return;
	//cprintf("HAHA\n");
	uint32 va = USER_HEAP_START;
	for(int i = 0; i < USER_HEAP_MEMORY_ITEMS; ++i) {
		user_heap[i].va = va;
		user_heap[i].used = 0;
		va += PAGE_SIZE;
	}
	is_initialized = 1;
}

uint32 next_fit_start_idx = 0;

uint32 get_address(uint32 req_pages) {
	uint32 va = -1;

	if(sys_isUHeapPlacementStrategyWORSTFIT()) {
		int freq_free = 0, max_free = -1, temp_idx = -1, idx = -1;
		uint32 start_va = -1;
		for(int i = 0; i < USER_HEAP_MEMORY_ITEMS; ++i) {
			if(user_heap[i].used == 0) {
				if(start_va == -1) {
					start_va = user_heap[i].va;
					temp_idx = i;
				}
				++freq_free;
			}
			else {
				if(freq_free > max_free && freq_free >= req_pages && freq_free > 0) {
					max_free = freq_free;
					va = start_va;
					idx = temp_idx;
				}
				start_va = -1;
				freq_free = 0;
			}
		}

		if(freq_free > max_free && freq_free >= req_pages) {
			max_free = freq_free;
			va = start_va;
			idx = temp_idx;
		}

		if(va != -1) {
			for(int i = 0; i < req_pages; ++i)
				user_heap[idx + i].used = 1;
			return va;
		}
	}
	else if(sys_isUHeapPlacementStrategyNEXTFIT()) {
		int freq_free = 0, start_va = -1, idx = -1;
		for(int i = 0; i < USER_HEAP_MEMORY_ITEMS; ++i) {
			if(user_heap[next_fit_start_idx].used == 0) {
				if(start_va == -1) {
					start_va = user_heap[next_fit_start_idx].va;
					idx = next_fit_start_idx;
				}
				++freq_free;
			}
			else {
				start_va = -1;
				idx = -1;
				freq_free = 0;
			}
			if(freq_free >= req_pages) {
				//cprintf("HAHA\n");
				for(int i = 0; i < req_pages; ++i)
					user_heap[idx + i].used = 1;
				++next_fit_start_idx;
				next_fit_start_idx %= USER_HEAP_MEMORY_ITEMS;
				return start_va;
			}
			++next_fit_start_idx;
			next_fit_start_idx %= USER_HEAP_MEMORY_ITEMS;
		}
	}

	return va;
}

void* malloc(uint32 size)
{


	init();
	uint32 address = get_address(size/PAGE_SIZE + (size % PAGE_SIZE == 0 ? 0 : 1));

	if(address == -1)
		return (void*)NULL;

	allocated_array[number_allocated].va = address;
	allocated_array[number_allocated].size = size;
	++number_allocated;

	sys_allocateMem(address, size);

	return (void*)address;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
	//TODO: [PROJECT 2020 - [6] Shared Variables: Creation] smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");

	// Steps:
	//	1) Implement FIRST FIT strategy to search the heap for suitable space
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	//	 Else,
	//	3) Call sys_createSharedObject(...) to invoke the Kernel for allocation of shared variable
	//		sys_createSharedObject(): if succeed, it returns the ID of the created variable. Else, it returns -ve
	//	4) If the Kernel successfully creates the shared variable, return its virtual address
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
	//TODO: [PROJECT 2020 - [6] Shared Variables: Get] sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");

	// Steps:
	//	1) Get the size of the shared variable (use sys_getSizeOfSharedObject())
	//	2) If not exists, return NULL
	//	3) Implement FIRST FIT strategy to search the heap for suitable space
	//		to share the variable (should be on 4 KB BOUNDARY)
	//	4) if no suitable space found, return NULL
	//	 Else,
	//	5) Call sys_getSharedObject(...) to invoke the Kernel for sharing this variable
	//		sys_getSharedObject(): if succeed, it returns the ID of the shared variable. Else, it returns -ve
	//	6) If the Kernel successfully share the variable, return its virtual address
	//	   Else, return NULL
	//

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	return 0;
}

// free():
//	This function frees the allocation of the given virtual_address
//	To do this, we need to switch to the kernel, free the pages AND "EMPTY" PAGE TABLES
//	from page file and main memory then switch back to the user again.
//
//	We can use sys_freeMem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
   //cprintf("HAHA\n");
	int s;
	//TODO: [PROJECT 2020 - [5] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code
	for (int i=0;i<number_allocated;i++){
		if (allocated_array[i].va==(uint32)virtual_address){
			s=allocated_array[i].size;

		}
	}


   for (int i=0;i<number_allocated;i++){
	   if (allocated_array[i].va==(uint32)virtual_address){

		   uint32 temp = allocated_array[i].va;
		   allocated_array[i].va= allocated_array[number_allocated-1].va;
		   allocated_array[number_allocated-1].va = temp;


		   uint32 temp2 = allocated_array[i].size;
				   allocated_array[i].size= allocated_array[number_allocated-1].size;
				   allocated_array[number_allocated-1].size = temp2;
				   number_allocated--;
				   break;


   }

   }
   for (int j=0;j<USER_HEAP_MEMORY_ITEMS;j++){

 	   if (user_heap[j].va==(uint32)virtual_address){
 		   int req_pages = s / PAGE_SIZE + (s % PAGE_SIZE == 0 ? 0 : 1);
 		   for(int t = 0; t < req_pages; ++t)
 			   user_heap[t + j].used=0;
		  sys_freeMem((uint32)virtual_address, s);
		  break;
 	   		}

    }
	//you shold get the size of the given allocation using its address
	//you need to call sys_freeMem()
	//refer to the project presentation and documentation for details

}

//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//

//=============
// [1] sfree():
//=============
//	This function frees the shared variable at the given virtual_address
//	To do this, we need to switch to the kernel, free the pages AND "EMPTY" PAGE TABLES
//	from main memory then switch back to the user again.
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()

}


//===============
// [2] realloc():
//===============

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to malloc().
//	A call with new_size = zero is equivalent to free().

//  Hint: you may need to use the sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		which switches to the kernel mode, calls moveMem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
//		in "memory_manager.c", then switch back to the user mode here
//	the moveMem function is empty, make sure to implement it.

void *realloc(void *virtual_address, uint32 new_size)
{
	//TODO: [PROJECT 2020 - BONUS1] User Heap Realloc [User Side]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");

}
