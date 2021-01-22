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
	uint32 index_allocated;
} user_heap[USER_HEAP_MEMORY_ITEMS];

int is_initialized = 0;

void init() {
	if(is_initialized == 1)
		return;
	uint32 va = USER_HEAP_START;
	for(int i = 0; i < USER_HEAP_MEMORY_ITEMS; ++i) {
		user_heap[i].va = va;
		user_heap[i].used = 0;
		user_heap[i].index_allocated = -1;
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
			return idx;
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
				++next_fit_start_idx;
				next_fit_start_idx %= USER_HEAP_MEMORY_ITEMS;
				return idx;
			}
			++next_fit_start_idx;
			next_fit_start_idx %= USER_HEAP_MEMORY_ITEMS;
		}
	}

	return -1;
}

void UH_Allocate(uint32 size, uint32 idx) {
	int req_pages = size/PAGE_SIZE + (size%PAGE_SIZE == 0 ? 0 : 1);
	user_heap[idx].index_allocated = number_allocated;
	for(int i = 0; i < req_pages; ++i) {
		user_heap[(idx + i)%USER_HEAP_MEMORY_ITEMS].used = 1;
	}
	allocated_array[number_allocated].va = user_heap[idx].va;
	allocated_array[number_allocated].size = size;
	++number_allocated;
}

void* malloc(uint32 size)
{
	init();
	uint32 idx = get_address(size/PAGE_SIZE + (size % PAGE_SIZE == 0 ? 0 : 1));
	if(idx == -1)
		return (void*)NULL;

	UH_Allocate(size, idx);

	sys_allocateMem(user_heap[idx].va, size);

	return (void*)user_heap[idx].va;
}

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
	init();
	uint32 required_pages = ROUNDUP(size, PAGE_SIZE)/PAGE_SIZE;
	uint32 idx = get_address(required_pages);
	if(idx!= -1)
	{
		int ret = sys_createSharedObject(sharedVarName, ROUNDUP(size, PAGE_SIZE),isWritable, (void *)user_heap[idx].va );
		if(ret != E_NO_SHARE && ret != E_SHARED_MEM_EXISTS)
		{
			UH_Allocate(size, idx);
			return (void *)user_heap[idx].va;
		}
	}
	return NULL;

}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
	init();
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
	if(size == E_SHARED_MEM_NOT_EXISTS)
		return NULL;
	uint32 idx = get_address(size/PAGE_SIZE + (size%PAGE_SIZE == 0 ? 0 : 1));
	if(idx == -1)
		return NULL;
	int id = sys_getSharedObject(ownerEnvID, sharedVarName, (void*)user_heap[idx].va);
	if(id == E_SHARED_MEM_NOT_EXISTS || id == E_NO_SHARE)
		return NULL;
	UH_Allocate(size, idx);
	return (void*)user_heap[idx].va;
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
	int s = -1, idx = -1;
	for (int i=0;i<number_allocated;i++){
		if (allocated_array[i].va==(uint32)virtual_address){
			s=allocated_array[i].size;
			idx = i;
			break;
		}
	}
	allocated_array[idx] = allocated_array[--number_allocated];
	idx = ((uint32)virtual_address - USER_HEAP_START) / PAGE_SIZE;
	int req_pages = s / PAGE_SIZE + (s % PAGE_SIZE == 0 ? 0 : 1);
	   for(int t = 0; t < req_pages; ++t)
		   user_heap[t + idx].used=0;
	   sys_freeMem((uint32)virtual_address, s);

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
