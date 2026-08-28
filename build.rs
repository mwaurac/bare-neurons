use std::process::Command;

fn main() {
    let out_dir = std::env::var("OUT_DIR").unwrap();
    let status = Command::new("nasm")
        .args(["-felf64", "asm/ops.asm", "-o", &format!("{out_dir}/ops.o")])
        .status()
        .expect("Failed to run nasm");

    assert!(
        status.success(),
        "nasm failed to assemble the assembly code"
    );
    println!("cargo:rustc-link-arg={}/ops.o", out_dir);
    println!("cargo:rerun-if-changed=asm/ops.asm");
}
