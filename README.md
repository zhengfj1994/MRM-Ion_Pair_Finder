MRM-Ion Pair Finder v2.0 user manual

MRM-Ion Pair Finder software is an independently developed and written program in our laboratory for large-scale selection of MRM transitions for pseudotargeted metabolomics. The Matlab (Version 7.14.739, R2012a,64-bit) is used. MRM-Ion Pair Finder v2.0 is improved on the basis of the original version, which simplifies the program and improves the running efficiency. Matlab language (R2018b, 64-bit) is used. 
The whole process of running the software is as follows: (1) Establish folders containing parent ion information (parent ion information from the results of XCMS and CAMERA) and product ion information (product ion information from MGF files). (2) Set parameters, run MRM-Ion Pair Finder v2.0 software, automatically select ion pairs, output results.
The instructions for the installation and use of the software are shown below:
1	Download and extract MRM-Ion Pair Finder v2.0.zip.
2	Select the extracted MRM-Ion Pair Finder v2.0 software folder in Matlab, as shown in Figure 1.
3	Load data file path: Add to Path → Selected Folders and Subfolders
4	Prepare MS1 file (csv) and MS2 files (mgf). MS1 format for MRM-Ion Pair Finder v2.0 is shown in Figure 6. PeakView (AB SCIEX, Version: 1.2.0.3) is used for transfer raw data (.wiff) to mgf file. MSConvert can also be used to get mgf files from different instruments raw file types. Peak peaking algorithm are set as continuous wavelet transform (cwt) in MSConvert. Other filters can make the data simpler and reduce the running time of MRM-Ion Pair Finder v2.0.
5	Open folder of MRM-Ion Pair Finder v2.0, Double-click "NEW_FINDER.fig" in the left column.
6	According to the specific experimental situation, set the software parameters, click "START" to start running the program. The functions of each parameter are shown in Table 1.
7	The result (csv file) is automatically saved under the subfolder named with the software run-end time.      

Table 1. MRM-Ion Pair Founder parameter meaning
Parameters                              Meaning
—————————————————————————————————————————————————————————————————————————————————————————————————————————
file path (MS1)	                        MS1 and MS2 file path.
                                        Notice：MS1 file format must be same as Figure 6, MS2 file must name as CE voltage such as 15V.mgf, 30V.mgf and 45V.mgf. The two folders are separate, and there should be no other files under the folders.
file path (MS2)
—————————————————————————————————————————————————————————————————————————————————————————————————————————
tR tolerance (min)	                    tr tolerance between MS1 and MS2 files
—————————————————————————————————————————————————————————————————————————————————————————————————————————
m/z tolerance (Da)	                    m/z tolerance between MS1 and MS2 files
—————————————————————————————————————————————————————————————————————————————————————————————————————————
tolerance (MS2 intensity)	            If the response of product ion is smaller than threshold, it                                             will be deleted.
—————————————————————————————————————————————————————————————————————————————————————————————————————————
tolerance of MS1 and MS2	            If the m/z difference between precursor and produce ion is                                               smaller than tolerance (MS1~MS2), it will be deleted.
