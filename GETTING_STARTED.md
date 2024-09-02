# Getting started with the project

## Understanding the repository

The `Facial-Age-Estimation-Benchmark` repository contains the following:

- Definition of dataset annotation/indexing scripts, contained inside the `/facebase/to_json` folder;

    * These scripts output JSONs files with all annotations in the directory (or a link to) `/facebase/benchmarks/databases`.

- Standardization of age estimation benchmarks. Each benchmark uses (part of) one dataset as its training data and other datasets (except `IMDB-CLEAN-EM-CNN` and `IMDB-CLEAN-FP-AGE`) as its testing data. There are the following benchmarks:

    * **AFAD** (`/facebase/benchmarks/AFAD.yaml`): 
        **Training, validation & testing set**: `AFAD-Full`.
        **Testing-only set**: `AgeDB`, `CACD2000`, `CLAP2016`, `MORPH`, `UTKFace`.

    * **AgeDB** (`/facebase/benchmarks/AgeDB.yaml`): 
        **Training, validation & testing set**: `AgeDB`.
        **Testing-only set**: `AFAD-Full`, `CACD2000`, `CLAP2016`, `MORPH`, `UTKFace`.

    * **CACD2000** (`/facebase/benchmarks/CACD2000.yaml`): 
        **Training, validation & testing set**: `CACD2000`.
        **Testing-only set**: `AFAD-Full`, `AgeDB`, `CLAP2016`, `MORPH`, `UTKFace`.

    * **CLAP2016** (`/facebase/benchmarks/CLAP2016.yaml`): 
        **Training, validation & testing set**: `CLAP2016` (I am not sure of which dataset `CLAP16` refers to, if its either `ChaLearn16` or `APPA-REAL`).
        **Testing-only set**: `AFAD-Full`, `AgeDB`, `CACD2000`, `MORPH`, `UTKFace`.

    * **IMDB-CLEAN-EM-CNN** (`/facebase/benchmarks/IMDB-CLEAN-EM-CNN.yaml`): 
        **Training, validation & testing set**: `IMDB-CLEAN-EM-CNN` (I am not sure of which dataset `IMDB-CLEAN-EM-CNN` refers to, if its either `IMDB-WIKI` or `IMDB-Clean`).
        **Testing-only set**: `AFAD-Full`, `AgeDB`, `CACD2000`, `CLAP2016`, `MORPH`, `UTKFace`.

    * **IMDB-CLEAN-FP-AGE** (`/facebase/benchmarks/IMDB-CLEAN-FP-AGE.yaml`): 
        **Training, validation & testing set**: `IMDB-CLEAN-FP-AGE` (I am not sure of which dataset `IMDB-CLEAN-FP-AGE` refers to, if its either `IMDB-WIKI` or `IMDB-Clean`).
        **Testing-only set**: `AFAD-Full`, `AgeDB`, `CACD2000`, `CLAP2016`, `MORPH`, `UTKFace`.

    * **MORPH** (`/facebase/benchmarks/MORPH.yaml`): 
        **Training, validation & testing set**: `MORPH` (I think it refers to the `CD2` subfolder of `MORPH`).
        **Testing-only set**: `AFAD-Full`, `AgeDB`, `CACD2000`, `CLAP2016`, `UTKFace`.

    * **UTKFace** (`/facebase/benchmarks/UTKFace.yaml`): 
        **Training, validation & testing set**: `UTKFace`.
        **Testing-only set**: `AFAD-Full`, `AgeDB`, `CACD2000`, `CLAP2016`, `MORPH`.


- `/doc`

- `/lib`

- `/prepare_data.py`

- `/prepare_alignment.py`

- `/train.py`

- `/evaluate.py`

- `/build_jit_backbone.py`

- `/environment.yaml`

## Files added on fork

- `Dockerfile`

- `/scripts`

- `requirements.txt`

- `GETTING_STARTED.md`

## Benchmarks and databases not contemplated

Lorem ipsu

## Dataset storage structure

Dataset storage structure on Recod cluster:

```
/hadatasets/facial-age-estimation
├── /afad
├── /cacd
├── /clap16/appa-real-release
├── /fairface/fairface-img-margin025-trainval
├── /fg-net/FGNET
├── /imdb-clean/data
├── /morph2/CD2
├── /unofficial-agedb
└── /utk-face
```

Dataset storage structure necessary to match the project specifications:

```
/local/xfrancv/Faces/
├── /AFAD
├── /CACD2000
├── /ChaLearn2016
├── /FairFace
├── /FG-NET
├── /IMDB_WIKI
├── /MORPH
├── /AgeDB
└── /UTKFace
```

Volume mapping for Docker container:

```
...
    -v /hadatasets/facial-age-estimation/afad:/local/xfrancv/Faces/AFAD
    -v /hadatasets/facial-age-estimation/cacd:/local/xfrancv/Faces/CACD2000
    -v /hadatasets/facial-age-estimation/clap16/appa-real-release:/local/xfrancv/Faces/ChaLearn2016
    -v /hadatasets/facial-age-estimation/fairface/fairface-img-margin025-trainval:/local/xfrancv/Faces/FairFace
    -v /hadatasets/facial-age-estimation/fg-net/FGNET:/local/xfrancv/Faces/FG-NET
    -v /hadatasets/facial-age-estimation/imdb-clean/data:/local/xfrancv/Faces/IMDB_WIKI
    -v /hadatasets/facial-age-estimation/morph2/CD2:/local/xfrancv/Faces/MORPH
    -v /hadatasets/facial-age-estimation/unofficial-agedb:/local/xfrancv/Faces/AgeDB
    -v /hadatasets/facial-age-estimation/utk-face:/local/xfrancv/Faces/UTKFace
...
```