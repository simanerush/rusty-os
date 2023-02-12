#![no_std]
#![no_main]

use core::panic::PanicInfo;
use core::arch::asm;

pub mod entry;

// The never type "!" means diverging function (never returns).
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn _hello_main() -> ! {

    let mut x = 0_u64;
    loop {
#[cfg(target_arch="aarch64")]
        unsafe {
            asm!(
                "add {x}, {x}, #1",
                x = inout(reg) x,
            );
        }
#[cfg(target_arch="x86_64")]
        unsafe {
            asm!(
                "add {x}, 1",
                x = inout(reg) x,
            );
        }
#[cfg(target_arch="riscv64")]
        unsafe {
            asm!(
                "addi {x}, {x}, 1",
                x = inout(reg) x,
            );
        }
    }
}
