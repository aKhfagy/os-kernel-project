// #include <inc/lib.h>

// /* This file is dedicated for implementing the BUDDY system
//  * inside the user heap
//  */

// struct BuddyNode FreeNodes[BUDDY_NUM_FREE_NODES];
// void ClearNodeData(struct BuddyNode* node)
// {
// 	node->level = 0;
// 	node->status = FREE;
// 	node->va = 0;
// 	node->parent = NULL;
// 	node->myBuddy = NULL;
// }

// void initialize_buddy()
// {
// 	for (int i = 0; i < BUDDY_NUM_FREE_NODES; ++i)
// 	{
// 		LIST_INSERT_HEAD(&BuddyFreeNodesList, &(FreeNodes[i]));
// 		ClearNodeData(&(FreeNodes[i]));
// 	}
// }

// /*===============================================================*/

// // [PROJECT 2020 - BONUS4] Expand Buddy Free Node List

// void CreateNewBuddySpace()
// {
// 	// [PROJECT 2020 - [3] Buddy System: Create New Buddy Block]
// 	// Write your code here, remove the panic and write your code
// 	panic("CreateNewBuddySpace() is not required yet...!!");

// }

// void* FindAllocationUsingBuddy(int size)
// {
// 	// [PROJECT 2020 - [3] Buddy System: Get Allocation]
// 	// Write your code here, remove the panic and write your code
// 	panic("FindAllocationUsingBuddy() is not required yet...!!");
// }

// void FreeAllocationUsingBuddy(uint32 va)
// {
// 	// [PROJECT 2020 - [3] Buddy System: Free Allocation]
// 	// Write your code here, remove the panic and write your code
// 	panic("FreeAllocationUsingBuddy() is not required yet...!!");

// }
// /*===============================================================*/
