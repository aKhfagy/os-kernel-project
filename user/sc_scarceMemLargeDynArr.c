#include <inc/lib.h>

void _main(void)
{
	/*[1] CREATE LARGE ARRAY THAT SCARCE MEMORY*/
	//env_sleep(RAND(100,5000));
	uint32 required_size = PAGE_SIZE * myEnv->page_WS_max_size;
	uint32 *Elements = malloc(required_size) ;
	uint32 numOfElems = required_size / sizeof(int);
	for(uint32 i = 0; i < numOfElems; i+=8)
	{
		Elements[i] = i;
	}
	//env_sleep(RAND(100,5000));
	for(uint32 i = 0; i < numOfElems; i+=8)
	{
		assert(Elements[i] == i);
	}

	cprintf("\nTest scarce memory [Slave1] is finished!!\n");

	//To indicate that it's completed successfully
	inctst();
	sys_signalSemaphore(myEnv->env_parent_id, "finish");

	return;
}
