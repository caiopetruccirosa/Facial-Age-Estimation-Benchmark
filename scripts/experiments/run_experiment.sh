#!/bin/bash
# usage: run_experiment.sh --cuda_devices=<cuda_devices> --experiment_config=<experiment_config> --splits=<splits>
#     - <cuda_devices>: a string with the CUDA devices to be used, separated by commas, e.g. "0,1,2,3"
#     - <experiment_config>: the path to the experiment configuration file, e.g. "configs/experiment1.yaml"
#     - <splits>: a string with the splits to be used, separated by commas, e.g. "0,1,2,3,4"
# author: Caio Petrucci Rosa

# initialize variables
cuda_devices=""
experiment_config=""
experiment_name=""
logs_dir=""
splits=()

# loop through arguments, searching for --cuda_devices argument
for arg in "$@"; do
    case $arg in
    --cuda_devices=*)
        cuda_devices="${arg#*=}"
        ;;
    --experiment_config=*)
        experiment_config="${arg#*=}"
        ;;
    --splits=*)
        splits_raw="${arg#*=}"

        # convert the splits_raw string into the array splits using read and IFS
        IFS=',' read -a splits <<< "$splits_raw"
        
        ;;
    esac
done

# extract experiment name from experiment config file path
experiment_name="${experiment_config##*/}" # remove directory from path
experiment_name="${experiment_name%.*}"    # remove extension from path

# define logs directory
logs_dir="logs/experiments/"$experiment_name""

# create logs directory
mkdir -p $logs_dir

# run prepare_data.py step
python prepare_data.py "$experiment_config" &> "$logs_dir"/prepare_data.log

# run train.py step for each split
for split in "${splits[@]}"; do
    echo "Training model on split "$split"..."
    CUDA_VISIBLE_DEVICES="$cuda_devices" python train.py "$experiment_config" 0 &> "$logs_dir"/train_split"$split".log
done

# run evaluate.py step for all splits results
python evaluate.py "$experiment_config" &> "$logs_dir"/evaluate.log
