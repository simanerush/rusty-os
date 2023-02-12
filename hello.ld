OUTPUT_ARCH( "riscv" )

ENTRY( _hello_entry )

MEMORY
{
  ram  (wxa) : ORIGIN = 0x80000000, LENGTH = 128M
}

/*
PHDRS is short for "program headers", which we specify three here:
text - CPU instructions (executable sections)
data - Global, initialized variables
bss  - Global, uninitialized variables (all will be set to 0 by boot.S)
*/
PHDRS
{
  text PT_LOAD;
  data PT_LOAD;
  bss  PT_LOAD;
}

SECTIONS
{
  .text : {

    PROVIDE(_text_start = .);
    *(.text .text.*)
    PROVIDE(_text_end = .);
    /*
      >ram - This just tells the linker script to put this entire section (.text) into the
             ram region of memory. To my knowledge, the '>' does not mean "greater than". Instead,
             it is a symbol to let the linker know we want to put this in ram.

      AT>ram - This sets the LMA (load memory address) region to the same thing. LMA is the final
               translation of a VMA (virtual memory address). With this linker script, we're loading
               everything into its physical location. We'll let the kernel copy and sort out the 
               virtual memory. That's why >ram and AT>ram are continually the same thing.

      :text  - This tells the linker script to put this into the :text program header. We've only
               defined three: text, data, and bss. In this case, we're telling the linker script
               to go into the text section.
    */
  } >ram AT>ram :text
   PROVIDE(_global_pointer = .);
  .rodata : {
    PROVIDE(_rodata_start = .);
    *(.rodata .rodata.*)
    PROVIDE(_rodata_end = .);
  } >ram AT>ram :text

  .data : {
    . = ALIGN(4096);
    PROVIDE(_data_start = .);
    *(.sdata .sdata.*) *(.data .data.*)
    PROVIDE(_data_end = .);
  } >ram AT>ram :data

  .bss : {
    PROVIDE(_bss_start = .);
    *(.sbss .sbss.*) *(.bss .bss.*)
    PROVIDE(_bss_end = .);
  } >ram AT>ram :bss

  PROVIDE(end = .);
  PROVIDE(_memory_start = ORIGIN(ram));
  PROVIDE(_stack_start = _bss_end);
  PROVIDE(_stack_end = _stack_start + 0x80000);
  PROVIDE(_memory_end = ORIGIN(ram) + LENGTH(ram));

  PROVIDE(_heap_start = _stack_end);
  PROVIDE(_heap_size = _memory_end - _heap_start);
}
