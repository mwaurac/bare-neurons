use std::env;

unsafe extern "C" {
    fn square(x: i64) -> i64;
}

fn main() {
    let arg = env::args()
        .nth(1)
        .expect("Usage: cargo run -- <number>");

    let n: i64 = arg.parse().expect("Not an integer");

    let ans = unsafe { square(n) };

    println!("{n}² = {ans}");
}