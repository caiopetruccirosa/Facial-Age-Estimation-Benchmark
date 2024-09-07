configs=( \
    "facebase/configs/AFAD_256x256.yaml" \
    "facebase/configs/AgeDB_256x256.yaml" \
    "facebase/configs/CACD2000_256x256.yaml" \
    "facebase/configs/CLAP2016_256x256.yaml" \
    "facebase/configs/IMDB-CLEAN-EM-CNN_256x256.yaml" \
    "facebase/configs/IMDB-CLEAN-FP-AGE_256x256.yaml" \
    "facebase/configs/MORPH_256x256.yaml" \
    "facebase/configs/UTKFace_256x256.yaml" \
)

for experiment_config in "${configs[@]}"; do
    # extract experiment name from experiment config file path
    experiment_name="${experiment_config##*/}" # remove directory from path
    experiment_name="${experiment_name%.*}"    # remove extension from path

    # log experiment name on log file
    echo "Running experiment: "$experiment_name"" &> logs/experiments/"$experiment_name".log
    ./scripts/experiments/run_experiment.sh \
        --cuda_devices=0 \
        --splits=0,1,2,3,4 \
        --experiment_config="$experiment_config"
done