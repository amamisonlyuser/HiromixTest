import json
import replicate
import os
# Set API token
os.environ["REPLICATE_API_TOKEN"] = "r8_JLgGu6wVdWDkF5LCkMNdiu75Ds8KvGX1my3s0"

image_url = "https://hiromixai.s3.ap-south-1.amazonaws.com/boy7.png"
output = replicate.run(
            "philz1337x/clarity-upscaler:dfad41707589d68ecdccd1dfa600d55a208f9310748e44bfe35b4a6291453d5e",
            input={
                "image": image_url,
                "prompt": "masterpiece, best quality, highres, <lora:more_details:0.5> <lora:SDXLrender_v2.0:1>",
                "dynamic": 6,
                "scheduler": "DPM++ 3M SDE Karras",
                "creativity": 0.25,
                "resemblance": 0.6,
                "scale_factor": 2,
                "negative_prompt": "(worst quality, low quality, normal quality:2 , teeth, tooth, teeths) JuggernautNegative-neg",
                "num_inference_steps": 18
            }
        )
for index, item in enumerate(output):
    with open(f"output_{index}.png", "wb") as file:
        file.write(item.read())
