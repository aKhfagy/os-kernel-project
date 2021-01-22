// Test the filling memory till reaching the scarce level
// Master program: run slave programs that create and use large static & dynamic arrays
#include <inc/lib.h>

#define NUM_OF_STATARR_SLAVES 10
#define NUM_OF_DYNARR_SLAVES 1
void
_main(void)
{
	//to check that the slave environments completed successfully
	rsttst();
	sys_createSemaphore("finish", 0);

	int slave1IDs[NUM_OF_STATARR_SLAVES];
	int slave2IDs[NUM_OF_DYNARR_SLAVES];
	for (int i = 0; i < NUM_OF_DYNARR_SLAVES; ++i)
	{
		slave1IDs[i] = sys_create_env("tscarceSlave1", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
		sys_run_env(slave1IDs[i]);
	}

	for (int i = 0; i < NUM_OF_STATARR_SLAVES; ++i)
	{
		slave2IDs[i] = sys_create_env("tscarceSlave2", (myEnv->page_WS_max_size), (myEnv->percentage_of_WS_pages_to_be_removed));
		sys_run_env(slave2IDs[i]);
	}
	//to ensure that the slave environments completed successfully
	//while (gettst()!= (NUM_OF_STATARR_SLAVES + NUM_OF_DYNARR_SLAVES)) ;
	for (int i = 0; i < NUM_OF_STATARR_SLAVES + NUM_OF_DYNARR_SLAVES; ++i)
	{
		sys_waitSemaphore(myEnv->env_id, "finish");
	}
	cprintf("Congratulations!! Test of Handling SCARCE MEM is completed successfully!!\n\n\n");

	return;
}

