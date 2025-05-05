#include "../interrupts/trap.h"
#include "../print_function/print.h"
#include "../memory_management/memory.h"
#include "../process/process.h"
#include "../syscalls/syscall.h"

void KMain(void)
{ 
   init_idt();
   init_memory();  
   init_kvm();
   init_system_call();
   init_process();
   launch();
}