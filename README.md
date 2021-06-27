# AICUP 2021 教育部全國大專校院人工智慧競賽 春季賽：醫病決策預判與問答
- [Webpage](https://aidea-web.tw/topic/3665319f-cd5d-4f92-8902-00ebbd8e871d)
    - 1st place / 81 teams

## Installation
- Install packages in `Pipfile`:
    ```
    pipenv install
    ```
    or 
    ```
    pipenv install --dev
    ```
    if you need to log training metrics by `wandb`.
    - After `pipenv install`, run `pipenv shell` to get into the virtual environment you built.
    - You can also manually install packages in `Pipfile` by `pip` or `conda` with Python 3.8

## Testing
- Download trained model:
    - By script (download and unzip):
    ```
    bash download_model.sh
    ```
    - Direct download:
        - `rc_model.zip`: https://drive.google.com/file/d/1GHO_PUPwRSYaHLgmWb8wKUD8dvsYw50w/view?usp=sharing
        - `qa_model.zip`: https://drive.google.com/file/d/1OH2J6m9j_sUmecbpsW3aYrUDCgxJ-W-P/view?usp=sharing
        - Unzip and place models under `ckpt/`.
- Test data is recommended to be placed at `data/rc/test.csv` and `data/qa/test.json` for Risk Classification and QA respectively.
- The data of QA have to be preprocessed before predicting:
    ```
    python query_qa.py \
        --data_path data/qa/test.json \
        --model_name model_test.pkl \
        --processed_data_path data/qa/processed_test.json
    ```
- We ensembled 3 models for Risk Classification and 4 models for QA. To predict them all:
    ```
    bash predict_rc.sh
    bash predict_qa.sh
    ```
    - Path of test data changed by `--data_path` in the scripts.
    - Batch size can be modified by `--batch_size` in the scripts to fit your GPU.
    - Predicting uses `cuda:0` by default (can be changed by `--device`), and note that using `cpu` is not tested.
    - Predictions will be saved at `prediction/`.
- To ensemble the prediction of models:
    ```
    python ensemble.py \
        --task rc \
        --data_dir prediction/ \
        --pred_path prediction/rc_final.csv
    python ensemble.py \
        --task qa \
        --data_dir prediction/ \
        --pred_path prediction/qa_final.csv
    ```
    - The file at `--pred_path` is the final predictions.
    - Note that for QA, the program randomly chooses an option from those getting the same votes. Since we did not set a random seed, the result varies between every execution.

## Training
### Risk Classification
- Training data is strongly recommended to be placed at `data/rc/train.csv`.
- To train:
    ```
    python train_rc.py
    ```
    - Validation data will be split from training data with a ratio of 10% automatically.
    - The program saves the best model by the AUROC of validation data (can be changed by `--metric_for_best`).
    - Model will be saved in `--ckpt_dir` (default: `ckpt/rc`).
    - Training uses `cuda:0` by default (can be changed by `--device`), and note that using `cpu` is not tested.
### QA
- Training data is strongly recommended to be placed at `data/qa/train.json`.
- The data have to be preprocessed before training:
    ```
    python query_qa.py \
        --data_path data/qa/train.json \
        --model_name model_train.pkl \
        --processed_data_path data/qa/processed_train.json
    ```
- We also use C3 dialog data to boost performance.
    - Download `c3-d-train.json`, `c3-d-dev.json`, and `c3-d-test.json` at https://github.com/nlpdata/c3/tree/master/data and place them at `data/c3/train.json`, `data/c3/dev.json`, and `data/c3/test.json`.
- To train:
    ```
    python train_qa.py
    ```
    - Validation data will be split from training data with a ratio of 10% automatically.
        - The splitting process requires `data/rc/train.csv` to get the exact split as risk classification, so make sure the file exists.
    - The program saves the best model by the accuracy of validation data (can be changed by `--metric_for_best`).
    - Model will be saved in `--ckpt_dir` (default: `ckpt/qa`).
    - Training uses `cuda:0` by default (can be changed by `--device`), and note that using `cpu` is not tested.
