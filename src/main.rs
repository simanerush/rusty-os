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

    let mut num1 = 0_u64;
    let mut num2 = 1_u64;
    let mut res = 0_u64;
    let mut i = 0_u16;

    // compute fibonacci sequence
    while i < 10 {
        #[cfg(target_arch="riscv64")]
        unsafe {
            asm!(
                "li {res}, 0",
                "add {res}, {num1}, {num2}",
                "mv {num1}, {num2}",
                "mv {num2}, {res}",
                res = inout(reg) res,
                num1 = inout(reg) num1,
                num2 = inout(reg) num2,
            );
        }
        i += 1;
    }

    loop {
        // loop forever
    }
}
