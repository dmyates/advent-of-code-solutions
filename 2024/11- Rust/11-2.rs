use std::fs;
use std::env;
use std::collections::HashMap;

fn main() {
    // Get args
    let args: Vec<String> = env::args().collect();
    if args.len() < 3 {
        println!("Usage: {} <filename> <iterations>", args[0]);
        return;
    }

    let input = fs::read_to_string(&args[1]).unwrap();
    let iterations = args[2].parse::<u32>().unwrap();

    // Parse input
    let mut stones: HashMap<u64, u64> = input.split_whitespace()
        .map(|s| s.parse::<u64>().unwrap())
        .fold(HashMap::new(), |mut map, num| {
            *map.entry(num).or_insert(0) += 1;
            map
        });

    println!("{:?}", stones);

    let mut cache: HashMap<u64, Vec<u64>> = HashMap::new();
    for _ in 0..iterations {
        let old_stones = stones.clone();
        stones.clear();

        for (stone, count) in old_stones {
            let mut added: Vec<u64> = Vec::new();

            match stone {
                // get from cache
                n if cache.contains_key(&n) => {
                    added.extend(cache[&n].clone());
                }
                // 0 -> 1
                0 => {
                    added.push(1);
                }
                // even-length number -> split in half
                n if n.to_string().len() % 2 == 0 => {
                    let s = stone.to_string();
                    let (first, second) = s.split_at(s.len() / 2);
                    added.push(first.parse::<u64>().unwrap());
                    added.push(second.parse::<u64>().unwrap());
                }
                // all else -> multiply by 2024
                _ => {
                    added.push(stone * 2024);
                }
            }

            // add to stones
            for &n in &added {
                *stones.entry(n).or_insert(0) += count;
            }

            // add to cache
            if !cache.contains_key(&stone) {
                cache.insert(stone, added);
            }
        }
    }

    println!("{:?} stones", stones.values().sum::<u64>());
}
