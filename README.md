# Enhancing 3D Scene Matching of InstantSplat for Sparse-view Scene Reconstruction with MASt3R

## Course
CPSC 533Y - 3D Computer Vision with Deep Learning @ UBC

## Semester
2024 Winter Session Term 1

## Outline
This is the repo for the final project of the course CPSC 533Y, while this work is an extension based on the original [InstantSplat](https://github.com/NVlabs/InstantSplat) codebase and its paper research. This project aims to enhance the InstantSplat pipeline by replacing the DUSt3R model with MASt3R, a more advanced version released recently. The instructions below are slightly modified for this work, while make sure to check the original codebase for more details if there are any issues during the setup. The DUSt3R model version used in this work is `DUSt3R_ViTLarge_BaseDecoder_512_dpt` and the MASt3R is `MASt3R_ViTLarge_BaseDecoder_512_catmlpdpt_metric`.


## Get Started

### Installation
1. Clone this repo and download pre-trained DUSt3R and MASt3R model.
```bash
git clone https://github.com/FalKon1256/InstantSplat-w-mast3r.git
cd InstantSplat
git submodule update --init --recursive
cd submodules/dust3r/
mkdir -p checkpoints/
wget https://download.europe.naverlabs.com/ComputerVision/DUSt3R/DUSt3R_ViTLarge_BaseDecoder_512_dpt.pth -P checkpoints/
cd ../../
cd submodules/mast3r/
mkdir -p checkpoints/
wget https://download.europe.naverlabs.com/ComputerVision/MASt3R/MASt3R_ViTLarge_BaseDecoder_512_catmlpdpt_metric.pth -P checkpoints/
cd ../../
```

2. Create the environment using conda.
```bash
conda create -n instantsplat python=3.11 cmake=3.14.0
conda activate instantsplat
conda install pytorch torchvision pytorch-cuda=12.1 -c pytorch -c nvidia  # use the correct version of cuda for your system
pip install -r requirements.txt
pip install submodules/simple-knn
# modify the rasterizer
vim submodules/diff-gaussian-rasterization/cuda_rasterizer/auxiliary.h
'p_view.z <= 0.2f' -> 'p_view.z <= 0.001f' # line 154
pip install submodules/diff-gaussian-rasterization
```

3. Optional but highly suggested, compile the cuda kernels for RoPE (as in CroCo v2).
```bash
# DUST3R and MASt3R relies on RoPE positional embeddings for which you can compile some cuda kernels for faster runtime.
cd submodules/dust3r/croco/models/curope/
python setup.py build_ext --inplace
```

### Usage
1. Data preparation
```bash
  # Create folders as names like Mipnerf_colmap, MVimgNet_colmap, Tanks_colmap. 
  # Put the COLMAP data (for evaluation) in the created folder:
  InstantSplat\data\Tanks_colmap\

  # Create the folder structure as below. 
  # Then put the image data for a specific scene in the created folder. 
  InstantSplat\data\TT\Family\24_views\images
```

2. Command
```bash
  # Please change the DATA_ROOT_DIR=[YOUR PATH]/InstantSplat/data", 
  # and also check if your GPU_ID is 0 (if not, please change it). 
  # Modify DATASETS, SCENES, and N_VIEWS parameters to implement different experiments. 

  # To run InstantSplat + DUSt3R training and evaluation (with GT reference):
  conda activate instantsplat
  bash scripts/run_train_eval.sh

  # To run InstantSplat + MASt3R training and evaluation (with GT reference):
  conda activate instantsplat
  bash scripts/run_train_eval_mast3r.sh
```

### Output
```bash
  # Evaluation data will be in the output folder:
  InstantSplat\output

  # The DUSt3R and MASt3R estimation output will be in these folders:
  # The name depends on your training views. 
  InstantSplat\data\TT\Family\24_views\dust3r_3_views
  InstantSplat\data\TT\Family\24_views\mast3r_3_views
```


## Acknowledgement

This work is built on many amazing research works and open-source projects, thanks a lot to all the authors for sharing!

- [InstantSplat](https://github.com/NVlabs/InstantSplat)
- [DUSt3R](https://github.com/naver/dust3r)
- [MASt3R](https://github.com/naver/mast3r)
- [Gaussian-Splatting](https://github.com/graphdeco-inria/gaussian-splatting)
- [diff-gaussian-rasterization](https://github.com/graphdeco-inria/diff-gaussian-rasterization)
