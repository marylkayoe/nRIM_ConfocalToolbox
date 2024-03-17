
# nRIM_ConfocalToolbox

A collection of tools developed by the nRIM lab for analyzing confocal microscopy data. This toolbox focuses on alignment, morphometric analysis, and generating overview sheets for whole-slide images. Mostly MatLAB.

## Table of Contents

- [nRIM\_ConfocalToolbox](#nrim_confocaltoolbox)
  - [Table of Contents](#table-of-contents)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
      - [Bio-Formats tools](#bio-formats-tools)
      - [MATLAB toolboxes](#matlab-toolboxes)
      - [Other packages:](#other-packages)
    - [Installation](#installation)
  - [Components](#components)
    - [FileHandling](#filehandling)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Prerequisites
#### Bio-Formats tools
Currently only ZEISS CZI files are supported. 
The functions make use of the Bio-Formats library, which can be downloaded from [here](https://github.com/Biofrontiers-ALMC/bioformats-matlab).
Alternatively, you can find the library via the MATLAB Add-On Explorer. If you have trouble, try finding help [here] (https://github.com/Biofrontiers-ALMC/bioformats-matlab/wiki/getting-started#installation).

Note that when you use the Bio-Formats library for the first time, the most updated library will be automatically downloaded.

#### MATLAB toolboxes
What things you need to install the software and how to install them:

```text
MATLAB (R2023a or newer recommended)
Image Processing Toolbox
Signal Processing Toolbox
Statistics and Machine Learning Toolbox
```

#### Other packages:
 will add here links to other packages that are used in the toolbox
 

### Installation

To use the toolbox, download or clone the repository and add the folder to your MATLAB path. 

```matlab
addpath(genpath('path\to\nRIM_ConfocalToolbox'))
```

## Components

### FileHandling
These functions are used to read microscopy files into MATLAB so that they can be processed.


```matlab
