# MRM-Ion Pair Finder

## Introduction
Pseudotargeted metabolomics is a novel method that perform high coverage metabolomics analysis based on UHPLC-TQMS. MRM-Ion Pair Finder software is an independently developed and written program in our laboratory for large-scale selection of MRM transitions for pseudotargeted metabolomics. The Matlab (Version 7.14.739, R2012a,64-bit) is used. MRM-Ion Pair Finder v2.0 is improved on the basis of the original version, which simplifies the program and improves the running efficiency. Matlab language (R2018b, 64-bit) is used. To make MRM-Ion Pair Finder can be used by more researchers, we also provide a version based on R.

## Development
MRM-Ion Pair Finder is used to automatically and systematically define MRM transitions from untargeted metabolomics data. Our research group first introduced the concept of pseudotargeted metabolomics using the retention time locking GC-MS-selected ions monitoring in 2012. The pseudotargeted metabolomics method was extended to LC-MS in 2013. To define ion pairs automatically and systematically, the in-house software “Mul-tiple Reaction Monitoring-Ion Pair Finder (MRM-Ion Pair Finder)” was developed, which made defining of the MRM transitions for untargeted metabolic profiling easier and less time consuming. Recently, MRM-Ion Pair Finder was updated to version 2.0. The new version is more convenient, consumes less time and is also suitable for negative ion mode. And the function of MRM-Ion Pair Finder is also performed in R so that users have more options when using pseudotargeted method.

## How to use
#### R

We package the functions of MRM-Ion Pair Finder into an R language package called MRMFinder, which is convenient for users to download, install and use.

To install MRMFinder, you need to install devtools first, use the following code in R language.

```R
install.packages("devtools")
```

After installing devtools, install MRMFinder using the code below:

```R
devtools::install_github("zhengfj1994/MRM-Ion_Pair_Finder")
```

After successful installation, you can use the MRM_Ion_Pair_Finder function to select transitions.

```R
library(MRMFinder)
data_ms1ms2_final <- MRM_Ion_Pair_Finder(file_MS1 = "F:\\MRM-Ion Pair Finder\\MS1\\Delete Iso-Add Result.csv",
                                         filepath_MS2 = "F:\\MRM-Ion Pair Finder\\MS2",
                                         tol_mz = 0.01,
                                         tol_tr = 0.2,
                                         diff_MS2MS1 = 13.9,
                                         ms2_intensity = 750,
                                         resultpath = "F:\\MRM-Ion Pair Finder",
                                         OnlyKeepChargeEqual1 = T,
                       					 NumOfProductIons = 1,
                                         cores = 4)
```

The meaning of parameters are shown below:

| Parameters           | Meaning                                                      |
| :------------------- | :----------------------------------------------------------- |
| file_MS1             | MS1 file (.csv)                                              |
| filepath_MS2         | filepath of MS2 file (.mgf)                                  |
| tol_mz               | m/z tolerance between MS1 and MS2 files                      |
| tol_rt               | retention time tolerance between MS1 and MS2 files           |
| diff_MS2MS1          | smallest tolerance between precusor and product ion          |
| ms2_intensity        | smallest intensity of product ion                            |
| resultpath           | result(.csv) filepath                                        |
| OnlyKeepChargeEqual1 | If TRUE, only keep the MS2 spectra with charge = 1.          |
| NumOfProductIons     | Number of product ions kept for each precursor ion. The default is 1. |
| cores                | Number of CPU cores used for parallel computing. The default is 4. |


##### Notice！！！

The csv file of file_MS1 should follow the format as described in the pseudotargeted metabolomics paper (https://pubmed.ncbi.nlm.nih.gov/32581297/). It should contains "mz", "tr", and the columns for intensity.



#### Shiny

In order to facilitate the use of users who are not used to using the R language, we also visualized based on shiny. After the MRMFinder is installed successfully, the user can use the following command to invoke the shiny visual interface.

```R
shiny::runApp(system.file('extdata/shinyApp', package = 'MRMFinder'))
```

<div align=center><img width="800" src="screenshot_of_shiny.png"/></div>
<h4 align="center">
Figure 1. Screenshot of Shiny
</h4>


#### Independent of R language

For users who don't want to use R language, we provide a packaged independent program, users do not need to install R language. The download address is https://sourceforge.net/projects/mrm-ion-pair-finder/files/latest/download

After downloading, unzip it, double-click MRMFinder.vbs to open an interface in your default browser, set the parameters, set the parameters and click the Run button to run.



### Codes for peak detection and annotation
We provide the codes for peak detection, peak annotation and removing rundant features in the folder named "PeakDetectionAndAnnotation". Users should used suitable parameters for peak detection and annoation and notice the ion mode.

### Codes for retention time calibration
We provide the codes for retention time calibration in the folder named "RetentionTimeCalibration". And we give the example data which are saved in .txt files. Users can easily calibrate retention time by using these codes.

## Contact us
If you have any problems when you use MRM_Ion_Pair_Finder. Please contact us, you can send an emial to zhengfj@dicp.ac.cn

## revision history

### 2020/09/16
Modified column name support in MS1 file. The modified version supports the use of "tr" or "rt" abbreviations for retention time column names.

### 2020/09/28
Expanded format support for mgf files.

### 2021/02/16
Improve the efficiency of the R language and visualize it based on shiny. Remove the Matlab version.

### 2021/02/24
Add error notification.

### 2021/04/04
Parallel computing increases speed.

### 2021/04/07
Added option to retain multiple product ions.

### 2022/07/19
Expanded format support for mgf files.

