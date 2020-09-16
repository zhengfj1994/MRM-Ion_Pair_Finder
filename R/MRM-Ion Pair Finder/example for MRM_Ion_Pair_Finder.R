# An example code to show how to use MRM_Ion_Pair_Finder.

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("xcms")
BiocManager::install("CAMERA")

source("D:\\github\\MRM-Ion_Pair_Finder\\R\\MRM-Ion Pair Finder\\MRM_Ion_Pair_Finder.R")

data_ms1ms2_final <- MRM_Ion_Pair_Finder(file_MS1 = "D:\\github\\MRM-Ion_Pair_Finder\\Data\\MS1\\Delete Iso-Add Result.csv",
                                         filepath_MS2 = "F:\\MRM-Ion_Pair_Finder-test\\MRM-Ion_Pair_Finder-master\\Data\\MS2",
                                         tol_mz = 0.01,
                                         tol_tr = 0.2,
                                         diff_MS2MS1 = 13.9,
                                         ms2_intensity = 750,
                                         resultpath = "D:\\github\\MRM-Ion_Pair_Finder\\Data")