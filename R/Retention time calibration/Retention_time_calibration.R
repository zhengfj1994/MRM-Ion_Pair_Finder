# Function name: RT_calibration
# Anthor: Fujian Zheng
# Function: Use internal standard retention time of HRMS and TQMS to cailbrate MRM transition retention time of HRMS.
# Input: ISHRMS_txt: The retention time of internal standards on HRMS, saved in a txt file;
#        ISTQMS_txt: The retention time of internal standards on TQMS, saved in a txt file;
#        MTHRMS_txt: The retention time of MRM transition on HRMS before calibration, save in a txt file;
#        MTTQMS_txt: The result file path contain calibrated retention timem, saved in a txt file.
# Reference: Huan, T. et al. DnsID in MyCompoundID for rapid identification of dansylated amine- and phenol-containing metabolites in LC-MS-based metabolomics. Anal. Chem. 87, 9838-9845 (2015).

RT_calibration <- function(ISHRMS_txt,ISTQMS_txt,MTHRMS_txt,MTTQMS_txt){
  ISHRMS <- sort(read.table(ISHRMS_txt)$V1)
  ISTQMS <- sort(read.table(ISTQMS_txt)$V1)
  deltaISRT <- ISHRMS-ISTQMS
  MTHRMS <- read.table(MTHRMS_txt)$V1
  MTTQMS <- MTHRMS
  for (i in c(1:length(MTHRMS))){
    MTHRMSi <- MTHRMS[i]
    if (MTHRMSi <= ISHRMS[1]){
      MTTQMS[i] <- MTHRMSi-(ISHRMS[1]-ISTQMS[1])
    }
    else if (MTHRMSi >= ISHRMS[length(ISHRMS)]){
      MTTQMS[i] <- MTHRMSi-(ISHRMS[length(ISHRMS)]-ISTQMS[length(ISHRMS)])
    }
    else{
      deltaISRT1 <- deltaISRT[which(ISHRMS > MTHRMSi)[1]-1]
      deltaISRT2 <- deltaISRT[which(ISHRMS > MTHRMSi)[1]]
      MTTQMS[i] <- MTHRMSi-(deltaISRT1+(deltaISRT2-deltaISRT1)*(MTHRMSi-ISHRMS[which(ISHRMS > MTHRMSi)[1]-1])/(ISHRMS[which(ISHRMS > MTHRMSi)[1]]-ISHRMS[which(ISHRMS > MTHRMSi)[1]-1]))
    }
  }
  write.table(MTTQMS, file = MTTQMS_txt, row.names = FALSE, col.names = FALSE)
  return(MTTQMS)
}

MTTQMS <- RT_calibration(ISHRMS_txt = "D:\\github\\MRM-Ion_Pair_Finder\\R\\Retention time calibration\\Test data\\Retention time of internal standards on UHPLC-HRMS.txt",
                         ISTQMS_txt = "D:\\github\\MRM-Ion_Pair_Finder\\R\\Retention time calibration\\Test data\\Retention time of internal standards on UHPLC-TQMS.txt",
                         MTHRMS_txt = "D:\\github\\MRM-Ion_Pair_Finder\\R\\Retention time calibration\\Test data\\Retention time of MRM transitions on UHPLC-HRMS.txt",
                         MTTQMS_txt = "D:\\github\\MRM-Ion_Pair_Finder\\R\\Retention time calibration\\Test data\\Retention calibration result.txt")