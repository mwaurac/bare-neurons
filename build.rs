use std::process::Command;

fn main() {
    let out_dir = std::env::var("OUT_DIR").unwrap();
    let status = Command::new("nasm")
        .args([
            "-felf64",
            "asm/square.asm",
            "-o",
            &format!("{out_dir}/square.o"),
        ])
        .status()
        .expect("Failed to run nasm.");

    assert!(status.success(), "nasm failed to assemble the assembly code");

    println!("cargo:rustc-link-arg={}/square.o", out_dir);
    println!("cargo:rerun-if-changed=asm/square.asm");
}