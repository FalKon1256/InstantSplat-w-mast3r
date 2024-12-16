#! /bin/bash

GPU_ID=0
DATA_ROOT_DIR="[YOUR PATH]/InstantSplat/data"
DATASETS=(
    TT
    # MVimgNet
    )

SCENES=(
    # Barn
    Family
    # Francis
    # Horse
    # Ignatius
    )

N_VIEWS=(
    3
    # 5
    # 9
    # 12
    # 24
    )

# increase iteration to get better metrics (e.g. gs_train_iter=5000)
gs_train_iter=1000

for DATASET in "${DATASETS[@]}"; do
    for SCENE in "${SCENES[@]}"; do
        for N_VIEW in "${N_VIEWS[@]}"; do

            # Sparse_image_folder must be Absolute path
            Sparse_image_folder=${DATA_ROOT_DIR}/${DATASET}/${SCENE}/24_views


            # [Change for MASt3R]
            ### Original ###
            SOURCE_PATH=${Sparse_image_folder}/dust3r_${N_VIEW}_views
            ### Revised ###
            #SOURCE_PATH=${Sparse_image_folder}/mast3r_${N_VIEW}_views


            # [Change for MASt3R]
            ### Original ###
            #MODEL_PATH=./output/eval/${DATASET}/${SCENE}/${N_VIEW}_views/
            ### Revised ###
            MODEL_PATH=./output/mast3r_eval/${DATASET}/${SCENE}/${N_VIEW}_views/


            GT_POSE_PATH=${DATA_ROOT_DIR}/Tanks_colmap/${SCENE}/24_views

            # ----- (5) Metrics -----
            CMD_M="CUDA_VISIBLE_DEVICES=${GPU_ID} python ./metrics.py \
            -m ${MODEL_PATH}  \
            --gt_pose_path ${GT_POSE_PATH} \
            --iter ${gs_train_iter} \
            --n_views ${N_VIEW}  \
            "

            echo "========= ${SCENE}: Dust3r_coarse_geometric_initialization ========="
            eval $CMD_D1
            echo "========= ${SCENE}: Train: jointly optimize pose ========="
            eval $CMD_T
            echo "========= ${SCENE}: Dust3r_test_pose_initialization ========="
            eval $CMD_D2
            echo "========= ${SCENE}: Render ========="
            eval $CMD_R
            echo "========= ${SCENE}: Metric ========="
            eval $CMD_M
            done
        done
    done