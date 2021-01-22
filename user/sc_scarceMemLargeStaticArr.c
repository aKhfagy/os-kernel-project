#include <inc/lib.h>

/*[1] CREATE LARGE ARRAY THAT SCARCE MEMORY*/

#define numOfElems 4000*PAGE_SIZE/4
uint32 Elements[numOfElems];

void _main(void)
{
	env_sleep(50000);
	for(uint32 i = 0; i < numOfElems; i+=4)
	{
		Elements[i] = i;
	}
	env_sleep(RAND(10000,50000));
	for(uint32 i = 0; i < numOfElems; i+=4)
	{
		assert(Elements[i] == i);
	}

	cprintf("\nTest scarce memory [Slave2] is finished!!\n");

	//To indicate that it's completed successfully
	inctst();
	sys_signalSemaphore(myEnv->env_parent_id, "finish");
	return;
}
