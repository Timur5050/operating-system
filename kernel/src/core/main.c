#include "../interrupts/trap.h"
#include "../print_function/print.h"
#include "../memory_management/memory.h"
#include "../process/process.h"

void KMain(void)
{ 
   init_idt();
   init_memory();  
   init_kvm();
   init_process();
   launch();
}