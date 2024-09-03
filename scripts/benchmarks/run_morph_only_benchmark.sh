mkdir -p logs/experiments/MORPH_only_256x256

python prepare_data.py facebase/configs/MORPH_only_256x256.yaml 2>&1 | tee -a logs/experiments/MORPH_only_256x256/prepare_data.log

python train.py facebase/configs/MORPH_only_256x256.yaml 0 2>&1 | tee -a logs/experiments/MORPH_only_256x256/train_split0.log
python train.py facebase/configs/MORPH_only_256x256.yaml 1 2>&1 | tee -a logs/experiments/MORPH_only_256x256/train_split1.log
python train.py facebase/configs/MORPH_only_256x256.yaml 2 2>&1 | tee -a logs/experiments/MORPH_only_256x256/train_split2.log
python train.py facebase/configs/MORPH_only_256x256.yaml 3 2>&1 | tee -a logs/experiments/MORPH_only_256x256/train_split3.log
python train.py facebase/configs/MORPH_only_256x256.yaml 4 2>&1 | tee -a logs/experiments/MORPH_only_256x256/train_split4.log

python evaluate.py facebase/configs/MORPH_only_256x256.yaml 2>&1 | tee -a logs/experiments/MORPH_only_256x256/evaluate.log
