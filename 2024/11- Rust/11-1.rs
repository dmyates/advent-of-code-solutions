use std::fs;
use std::env;

fn main() {
    // Get args
    let args: Vec<String> = env::args().collect();
    if args.len() < 3 {
        println!("Usage: {} <filename> <iterations>", args[0]);
        return;
    }

    let input = fs::read_to_string(&args[1]).unwrap();
    let blinks = args[2].parse::<u32>().unwrap();

    // Parse input
    let mut stones: Vec<u64> = input.split_whitespace()
        .map(|s| s.parse::<u64>().unwrap())
        .collect();

    println!("Starting list: {:?}", stones);

    // Blink
    for _ in 0..blinks {
        let mut new_stones = Vec::new();
        
        for stone in stones {
            match stone {
                // 0 -> 1
                0 => {
                    new_stones.push(1);
                }
                // even-length number -> split in half
                n if n.to_string().len() % 2 == 0 => {
                    let s = stone.to_string();
                    let (first, second) = s.split_at(s.len() / 2);
                    new_stones.push(first.parse::<u64>().unwrap());
                    new_stones.push(second.parse::<u64>().unwrap());
                }
                // all else -> multiply by 2024
                _ => {
                    new_stones.push(stone * 2024);
                }
            }
        }
        stones = new_stones;
    }

    println!("{:?} stones", stones.len());
}
