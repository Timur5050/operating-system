#include "../interrupts/trap.h"
#include "../print_function/print.h"

void KMain(void)
{
   char *string = "Hello and Welcome";
   int64_t value = 0x123456789ABCD;
   
   init_idt();

   printk("%s\n", string);
   printk("This value is equal to %x", value);
}