use rofi;
use serde_json::Value;
use std::env;
use std::fs::File;
use std::io::prelude::*;
use std::process::Command;

fn recursive_swallowers(v: Value) -> Vec<Value> {
    if v.is_object() && v["swallows"].is_array() {
        return vec![v];
    } else if v.is_object() && v["nodes"].is_array() {
        let mut result = vec![];
        for node in v["nodes"].as_array().unwrap() {
            result.append(&mut recursive_swallowers(node.clone()));
        }
        return result;
    }
    return vec![];
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // read ~/.config/i3/workspace-2.json
    let mut file = File::open(env::args().skip(1).next().unwrap())?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    let v: Value = serde_json::from_str(&contents)?;
    let entries = recursive_swallowers(v);
    let rofi_entries = entries
        .iter()
        .map(|x| x["name"].as_str().unwrap())
        .collect();

    match rofi::Rofi::new(&rofi_entries).run_index() {
        Ok(index) => {
            // user chose index
            let chosen = &entries[index];
            // try to focus it, if it doesn't work then open it
            let mut focus_target = String::new();
            let criteria = &chosen["swallows"][0].as_object().unwrap();
            for key in criteria.keys() {
                focus_target += &format!("{}={} ", key, criteria[key].as_str().unwrap())
            }
            let output: Value = serde_json::from_str(
                &String::from_utf8(
                    Command::new("i3-msg")
                        .arg(format!("[{}] focus", focus_target))
                        .output()
                        .expect("failed to execute i3-msg")
                        .stdout,
                )
                .unwrap(),
            )
            .unwrap();
            if output[0]["success"].as_bool() == Some(true) {
                println!("Success.");
            } else {
                if chosen["run"].is_string() {
                    let to_run = String::from("nohup ") + chosen["run"].as_str().unwrap();
                    Command::new("bash")
                        .args(&["-c", &to_run])
                        .spawn()
                        .expect("failed to run, you may not hav ebash");
                }
            }
        }
        Err(rofi::Error::Interrupted) => println!("Interrupted"),
        Err(rofi::Error::NotFound) => println!("User input was not found"),
        Err(e) => println!("Error: {}", e),
    };

    Ok(())
}
