python prepare_data.py facebase/benchmarks/MORPH_only.yaml

python train.py facebase/benchmarks/MORPH_only.yaml 0
python train.py facebase/benchmarks/MORPH_only.yaml 1
python train.py facebase/benchmarks/MORPH_only.yaml 2
python train.py facebase/benchmarks/MORPH_only.yaml 3
python train.py facebase/benchmarks/MORPH_only.yaml 4

python evaluate.py facebase/benchmarks/MORPH_only.yaml