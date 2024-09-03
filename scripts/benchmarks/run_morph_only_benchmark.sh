mkdir -p logs/benchmarks/MORPH_only

python prepare_data.py facebase/benchmarks/MORPH_only.yaml &> logs/benchmarks/MORPH_only/prepare_data.log

python train.py facebase/benchmarks/MORPH_only.yaml 0 &> logs/benchmarks/MORPH_only/train_split0.log
python train.py facebase/benchmarks/MORPH_only.yaml 1 &> logs/benchmarks/MORPH_only/train_split1.log
python train.py facebase/benchmarks/MORPH_only.yaml 2 &> logs/benchmarks/MORPH_only/train_split2.log
python train.py facebase/benchmarks/MORPH_only.yaml 3 &> logs/benchmarks/MORPH_only/train_split3.log
python train.py facebase/benchmarks/MORPH_only.yaml 4 &> logs/benchmarks/MORPH_only/train_split4.log

python evaluate.py facebase/benchmarks/MORPH_only.yaml &> logs/benchmarks/MORPH_only/evaluate.log
