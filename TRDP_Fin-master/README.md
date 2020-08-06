# Object Detection in wide angle/Immersive Formats.

This repository contains functions and scripts for detecting objects in 360 degree images. It is an end to end algorithm from making the dataset to detect the final objects in a distorted type of images. The objective of this project is to detect the objects for wide angle/immersive formats. There are three portions of this repository:
* [Spherical Database Generator](https://github.com/rupayan-mallick/TRDP_Fin/tree/master/Spherical-Database-Generator) - Genertion of the Dataset.
* [Spherenet](https://github.com/rupayan-mallick/TRDP_Fin/tree/master/spherenet)- Used for using Spherical CNNs
* Scripts for detection. (Single Shot Multibox Detector) - For obbject detection.

**Mininimum Pre Requirements for running the codes**

* Intel Core i7 or Higher Processors
* GPU- NVIDIA 1060 6GB or Higher GPUs
* CUDA 10.2 Used Here but recommended CUDA 3.5 or Higher.
* Pytorch 0.4.1 or hihgher but used Pytorch 1.2.
* Python 3.5 or Higher.

**How to run the Code**
* Download the repository.
* Inside the create_data_list.py, change the path to the path of the dataset you need to train upon and run the script.
* Then for Training, run the script train.py but run initially with the prameter of checkpoint as NONE and then a .tar file will be generated for saving the weights as a checkpoint.
* In the utils.py kindly change the checkpoint.
* Then after you run the training, for detection (detect.py) also change the parameter checkpoint to the .tar file with the saved weights for the detection. Here you can specify the input directory of the images that will be used to perform the object detection.

# Authors

- [Jaideep Bommidi](https://github.com/JaideepBgit)
- [Rupayan Mallick](https://github.com/rupayan-mallick)
- [David Eduardo Moreno Villamarin](https://github.com/ujemd/)

# References

- Coors, Benjamin, Alexandru Paul Condurache, and Andreas Geiger. "Spherenet: Learning spherical representations for detection and classification in omnidirectional images." Proceedings of the European Conference on Computer Vision (ECCV). 2018. Part of implementation taken from: [ChiWeiHsiao](https://github.com/ChiWeiHsiao/SphereNet-pytorch).
- Liu, Wei, et al. "Ssd: Single shot multibox detector." European conference on computer vision. Springer, Cham, 2016.
- Everingham, Mark, et al. "The pascal visual object classes (voc) challenge." International journal of computer vision 88.2 (2010): 303-338.
