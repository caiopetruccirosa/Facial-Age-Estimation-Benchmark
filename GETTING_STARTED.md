# Getting started with the project

## Install missing dependencies

Missing dependencies:
- `albumentations`
- `pandas`
- `matplotlib`

## Dataset storage structure

Paths mapping structure:
```
/hadatasets/facial-age-estimation -> /local/xfrancv/Faces/
├── /afad -> /AFAD
├── /cacd -> /CACD2000
├── /clap16/appa-real-release -> /ChaLearn2016
├── /fairface/fairface-img-margin025-trainval -> /FairFace
├── /fg-net/FGNET -> /FG-NET
├── /imdb-clean/data -> /IMDB_WIKI
├── /morph2/CD2 -> /MORPH
├── /unofficial-agedb -> /AgeDB
└── /utk-face -> /UTKFace
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