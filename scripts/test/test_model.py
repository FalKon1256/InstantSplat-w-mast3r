import os
import torch

model_path = "submodules/dust3r/checkpoints/DUSt3R_ViTLarge_BaseDecoder_512_dpt.pth"
#model_path = "submodules/mast3r/checkpoints/MASt3R_ViTLarge_BaseDecoder_512_catmlpdpt_metric.pth"

# Check if file exits
assert os.path.exists(model_path), f"File not found: {model_path}"

# Load model
state_dict = torch.load(model_path, map_location=torch.device('cpu'))

# Check if need to open by state_dict['model']
if isinstance(state_dict, dict) and 'model' in state_dict:
    state_dict = state_dict['model']

# Print all keys of the model
print("--------------------------------Start print model info--------------------------------")
print(state_dict.keys())