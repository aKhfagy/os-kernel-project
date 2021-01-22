#include <inc/mmu.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>
#include <inc/environment_definitions.h>

#include <kern/shared_memory_manager.h>
#include <kern/memory_manager.h>
#include <kern/syscall.h>
#include <kern/kheap.h>

//2017

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//===========================
// [1] Create "shares" array:
//===========================
//Dynamically allocate the array of shared objects
//initialize the array of shared objects by 0's and empty = 1
void create_shares_array(uint32 numOfElements)
{
#if USE_KHEAP
	shares = kmalloc(numOfElements*sizeof(struct Share));
	if (shares == NULL)
	{
		panic("Kernel runs out of memory\nCan't create the array of shared objects.");
	}
	for (int i = 0; i < MAX_SHARES; ++i)
	{
		memset(&(shares[i]), 0, sizeof(struct Share));
		shares[i].empty = 1;
	}
#else
	for (int i = 0; i < MAX_SHARES; ++i)
		{
			shares[i].empty=1;

		}

#endif
}

//===========================
// [2] Allocate Share Object:
//===========================
//Allocates a new (empty) shared object from the "shares" array
//It dynamically creates the "framesStorage"
//Return:
//	a) if succeed:
//		1. allocatedObject (pointer to struct Share) passed by reference
//		2. sharedObjectID (its index in the array) as a return parameter
//	b) E_NO_SHARE if the the array of shares is full (i.e. reaches "MAX_SHARES")
int allocate_share_object(struct Share **allocatedObject)
{
	int32 sharedObjectID = -1 ;
	for (int i = 0; i < MAX_SHARES; ++i)
	{
		if (shares[i].empty)
		{
			sharedObjectID = i;
			break;
		}
	}

	if (sharedObjectID == -1)
	{
		//try to increase double the size of the "shares" array
		#if USE_KHEAP
		{
			shares = krealloc(shares, 2*MAX_SHARES);
			if (shares == NULL)
			{
				*allocatedObject = NULL;
				return E_NO_SHARE;
			}
			else
			{
				sharedObjectID = MAX_SHARES;
				MAX_SHARES *= 2;
			}
		}
		#else
		{
			//panic("Attempt to dynamically allocate space inside kernel while kheap is disabled .. ");
			*allocatedObject = NULL;
			return E_NO_SHARE;
		}
		#endif
	}

	*allocatedObject = &(shares[sharedObjectID]);
	shares[sharedObjectID].empty = 0;

	#if USE_KHEAP
	{
		shares[sharedObjectID].framesStorage = kmalloc(PAGE_SIZE);
		if (shares[sharedObjectID].framesStorage == NULL)
		{
			panic("Kernel runs out of memory\nCan't create the framesStorage.");
		}
	}
	#endif
	memset(shares[sharedObjectID].framesStorage, 0, PAGE_SIZE);

	return sharedObjectID;
}

//=========================
// [3] Get Share Object ID:
//=========================
//Search for the given shared object in the "shares" array
//Return:
//	a) if found: SharedObjectID (index of the shared object in the array)
//	b) else: E_SHARED_MEM_NOT_EXISTS
int get_share_object_ID(int32 ownerID, char* name)
{
	int i=0;

	for(; i< MAX_SHARES; ++i)
	{
		if (shares[i].empty)
			continue;

		//cprintf("shared var name = %s compared with %s\n", name, shares[i].name);
		if(shares[i].ownerID == ownerID && strcmp(name, shares[i].name)==0)
		{
			//cprintf("%s found\n", name);
			return i;
		}
	}
	return E_SHARED_MEM_NOT_EXISTS;
}
//==============================
// [4] Get Size of Share Object:
//==============================
//Search for the given shared object in the "shares" array
//Return:
//	a) If found, return size of shared object
//	b) Else, return E_SHARED_MEM_NOT_EXISTS
int getSizeOfSharedObject(int32 ownerID, char* shareName)
{
	int shareObjectID = get_share_object_ID(ownerID, shareName);
	if (shareObjectID == E_SHARED_MEM_NOT_EXISTS)
		return E_SHARED_MEM_NOT_EXISTS;
	else
		return shares[shareObjectID].size;

	return 0;
}
//=========================
// [5] Delete Share Object:
//=========================
//delete the given sharedObjectID from the "shares" array
//Return:
//	a) 0 if succeed
//	b) E_SHARED_MEM_NOT_EXISTS if the shared object is not exists
int free_share_object(uint32 sharedObjectID)
{
	if (sharedObjectID >= MAX_SHARES)
		return E_SHARED_MEM_NOT_EXISTS;

	//panic("deleteSharedObject: not implemented yet");
	clear_frames_storage(shares[sharedObjectID].framesStorage);
	#if USE_KHEAP
		kfree(shares[sharedObjectID].framesStorage);
	#endif
	memset(&(shares[sharedObjectID]), 0, sizeof(struct Share));
	shares[sharedObjectID].empty = 1;

	return 0;
}
//===========================================================


//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//=========================
// [1] Create Share Object:
//=========================

int createSharedObject(int32 ownerID, char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{

	struct Env* myenv = curenv; //The calling environment

		// This function should create the shared object at the given virtual address with the given size
		// and return the ShareObjectID
		// RETURN:
		//	a) ShareObjectID (its index in "shares" array) if success
		//	b) E_SHARED_MEM_EXISTS if the shared object already exists
		//	c) E_NO_SHARE if the number of shared objects reaches max "MAX_SHARES"

		if(get_share_object_ID(ownerID, shareName) != E_SHARED_MEM_NOT_EXISTS)
			return E_SHARED_MEM_EXISTS;
		struct Share *NewShareObj;
		int shareObjectID;
		shareObjectID = allocate_share_object(&NewShareObj);
		if(shareObjectID == E_NO_SHARE)
			return E_NO_SHARE;

		else{

			uint32 required_num_pages = size/PAGE_SIZE + (size % PAGE_SIZE != 0);
			virtual_address = ROUNDDOWN(virtual_address,PAGE_SIZE);
			struct Frame_Info *ptr_frameInfo;
			for(int index = 0, va = (uint32)virtual_address; index < required_num_pages; index++, va += PAGE_SIZE){

				int check = allocate_frame(&ptr_frameInfo);

				map_frame(curenv->env_page_directory, ptr_frameInfo, (void*)va, PERM_USER|PERM_PRESENT|PERM_WRITEABLE);

				add_frame_to_storage(NewShareObj->framesStorage, ptr_frameInfo, index);
			}
		}

		strcpy(NewShareObj->name, shareName);
		NewShareObj->ownerID = ownerID;
		NewShareObj->size = size;
		NewShareObj->references = 1;
		NewShareObj->isWritable = isWritable;
		return shareObjectID;

}
//======================
// [2] Get Share Object:
//======================
int getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{

	struct Env* myenv = curenv;

	int id = get_share_object_ID(ownerID, shareName);
	if(id == E_SHARED_MEM_NOT_EXISTS)
		return E_SHARED_MEM_NOT_EXISTS;
	int size = getSizeOfSharedObject(ownerID, shareName);
	int range = size/PAGE_SIZE + (size%PAGE_SIZE == 0 ? 0 : 1);
	uint32 va = (uint32)virtual_address;
	for (int frame_number = 0; frame_number < range; ++frame_number) {
		map_frame(
				myenv->env_page_directory,
				get_frame_from_storage(shares[id].framesStorage, frame_number),
				(void*)va,
				PERM_USER|PERM_PRESENT|(shares[id].isWritable == 1 ? PERM_WRITEABLE : 0)
				);
		va += PAGE_SIZE;
	}
	++shares[id].references;

	return id;
}

//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//

//===================
// Free Share Object:
//===================
int freeSharedObject(int32 sharedObjectID, void *startVA)
{
	struct Env* myenv = curenv; //The calling environment

	//TODO: [PROJECT 2020 - BOUNS3] Free Shared Variable [Kernel Side]
	// your code is here, remove the panic and write your code
	//panic("freeSharedObject() is not implemented yet...!!");

	// This function should free (delete) the shared object from the User Heap of the current environment
	// If this is the last shared env, then the "frames_store" should be cleared and the shared object should be deleted
	// RETURN:
	//	a) 0 if success
	//	b) E_SHARED_MEM_NOT_EXISTS if the shared object is not exists


	// Steps:
	//	1) Get the shared object from the "shares" array (use get_share_object_ID())
	//	2) Unmap it from the current environment "myenv"
	//	3) If one or more table becomes empty, remove it
	//	4) Update references
	//	5) If this is the last share, delete the share object (use free_share_object())
	//	6) Flush the cache "tlbflush()"

	//change this "return" according to your answer
	return 0;
}
