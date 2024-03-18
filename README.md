
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
      - [importZeissStack.m](#importzeissstackm)
      - [getZeissMetadata.m](#getzeissmetadatam)
    - [Visualization](#visualization)
      - [makeSlideOverviewPlot.m](#makeslideoverviewplotm)

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

#### importZeissStack.m
This function reads a ZEISS CZI file and returns a 3D matrix of the image data. 
If the file contains multiple stacks ("scenes"), the result will be a cell array of 3D matrices. 
The function will also return some acquisition metadata for the file.
**Note**: the metadata is extracted from the first scene only. 

Currently the metadata includes (not exclusive):
- SeriesCount: how many scenes the file contains
- SizeX, SizeY: the dimensions of the image
- SizeZ: the number of z-slices
- ScaleX, ScaleY: size of pixels in microns
- ScaleZ: size of z-steps in microns
- ObjMag: objective magnification
- zoom: magnification zoom
- ObjNA: objective numerical aperture
- LaserWL: laser wavelength (nm)
- LaserPower: laser power (%)
- AcqDate: acquisition date

**example use** 
```matlab

[scenes, metadata] = importZeissStack(datafolderpath, filename);
```

#### getZeissMetadata.m
This function parses the hashtable metadata found in the ZEISS CZI file opened with bfopen.
The function returns a struct containing the metadata. 

### Visualization
These functions are used to visualize the image data in MATLAB.

#### makeSlideOverviewPlot.m
This function is meant for visualizing all slices imaged on a slide.
The function takes a 3D matrix of the image data and a struct of metadata as input.
The function will return a figure with a plot of the image data, with slices labelled and a scale bar.

Scale and other information is extracted from the metadata struct.

By default the images are shown as std projections, but you can also specify to show max projections by setting the 'maxProject' parameter to true.

You can specify the grid layout of the resulting image so that it matches the physical layout of the slide.
**note** this works well only if your slide is imaged in a grid pattern with no missing slices.

**example use** 
```matlab
makeSlideOverviewPlot(scenes, 'metaData', metadata, 'gridLayout', [2, 4], 'maxProject', true);
 

```
