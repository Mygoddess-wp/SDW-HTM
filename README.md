# SDW-HTM: A Spatiotemporal Dynamic Weighting Method Based on Hyperspherical Tensor Mapping for Action Recognition


## 📂 Project Structure
SDW_HTM_code/
├── Dataset/ # Directory for raw datasets (not included)
│ ├── Cambridge_Hand_Gesture/
│ ├── KTH/
│ ├── MHAD/
│ ├── Northwestern_Hand_Gesture/
│ └── UT-Kinect/
├── source/ # Core algorithm implementations (e.g., model definition, training functions)
├── stm_feature_make/ # Scripts for feature extraction and preprocessing (e.g., STM features)
├── outputdata/ # Model output results (e.g., predictions, evaluation metrics)
├── main.py # Main program entry point
└── README.md # Project description and usage instructions


## 📥 Dataset Download

Please manually download the following publicly available datasets and place them inside the `Dataset/` directory. We do **not** include any raw data in this repository.

| Dataset Name                        | Target Directory                              | Download Link |
|------------------------------------|-----------------------------------------------|----------------|
| Cambridge Hand Gesture             | `Dataset/Cambridge_Hand_Gesture/`             | [Link](https://labicvl.github.io/ges_db.htm) |
| KTH Human Action                   | `Dataset/KTH/`                                | [Link](https://www.csc.kth.se/cvap/actions/) |
| Berkeley MHAD                      | `Dataset/MHAD/`                               | [Link](https://www.kaggle.com/datasets/dasmehdixtr/berkeley-multimodal-human-action-database) |
| Northwestern Hand Gesture          | `Dataset/Northwestern_Hand_Gesture/`          | [Link](http://users.eecs.northwestern.edu/~xsh835/assets/gesture_ivc2012.pdf) |
| UT-Kinect Action Dataset           | `Dataset/UT-Kinect/`                          | [Link](https://cvrc.ece.utexas.edu/KinectDatasets/HOJ3D.html) |

> ⚠️ **Note**: Ensure folder names match exactly as listed above. Otherwise, the code will not find the datasets correctly.


## 🚀 How to Run

1. Open MATLAB and set the working directory to the root of the project:
2. Make sure all required datasets are correctly placed.
3. Run the main script:
```matlab
>> main
4. Results (accuracy, predictions) will be saved in the outputdata/ folder.


### Requirements

- MATLAB R2022a or above  


