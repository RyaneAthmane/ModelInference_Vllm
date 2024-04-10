from huggingface_hub import snapshot_download
import os
import sys

print("Llm Model Downloader")
print("")
print("This tool will download a model from HuggingFace.")
print("The model will be saved in the 'models' folder.")
print("")

model = sys.argv[1] if len(sys.argv) > 1 else input("Enter Model: ")

os.environ["HF_HOME"] = os.path.join(os.getcwd(), "models")

print("Downloading model: ", model)

snapshot_download(repo_id=model)

print("Done.")
