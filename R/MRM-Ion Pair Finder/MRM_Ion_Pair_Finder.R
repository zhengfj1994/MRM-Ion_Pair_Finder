# Function: MRM_Ion_Pair_Finder
# Description: MRM-Ion Pair Finder performed in R
# References: Analytical Chemistry 87.10(2015):5050-5055.
# Parameters: file_MS1: MS1 peak detection result save in .csv filetype, the first column is m/z named 'mz',
#                       the second column is retention time(s) named 'tr',
#                       intensity of samples is located begin the third column.
#             filepath_MS2: The folder path which have mgf files.
#             tol_mz(Da): The tolerence of m/z between MS1 peak detection result and mgf files. 0.01 is suitable for Q-TOF.
#             tol_tr(min): The tolerence of retention time between MS1 peak detection result and mgf files.
#             diff_MS2MS1(Da): The smallest difference between product ion and precusor ion.
#             ms2_intensity: The smallest intensity of product ion.
#             resultpath: A csv file named "MRM transitions list.csv" will saved in the path.

MRM_Ion_Pair_Finder <- function(file_MS1,
                       filepath_MS2,
                       tol_mz,
                       tol_tr,
                       diff_MS2MS1,
                       ms2_intensity,
                       resultpath){
  # Some packages used in the function
  ##########
  require(tcltk)
  require(stringr)
  require(readr)
  require(dplyr)
  ##########
  
  # Function: exact a matrix from mgf_data
  ##########
  createmgfmatrix <- function(mgf_data){
    Begin_num <- grep("BEGIN IONS", mgf_data)
    Pepmass_num <- grep("PEPMASS=",mgf_data)
    TR_num <- grep("RTINSECONDS=",mgf_data)
    End_num <- grep("END IONS", mgf_data)
    mgf_matrix <- cbind(Begin_num,TR_num,Pepmass_num,End_num)
    
    for (i in c(1:length(Pepmass_num)))
    {
      pepmass <- gsub("[^0-9,.]", "", mgf_data[Pepmass_num[i]])
      mgf_matrix[i,"Pepmass_num"] <- pepmass
      
      tr <- gsub("[^0-9,.]", "", mgf_data[TR_num[i]])
      mgf_matrix[i,"TR_num"] <- tr
    }
    return(mgf_matrix)
  } 
  ##########
  
  # Reading csv file containing peak detection result of MS1.
  ##########
  before_pretreatment <- read.csv(file = file_MS1)
  if (length(which(colnames(before_pretreatment)=="tr")) >= 1) {}
  else if (length(which(colnames(before_pretreatment)=="tr")) == 0 & length(which(colnames(before_pretreatment)=="rt")) >= 1){
    colnames(before_pretreatment)[which(colnames(before_pretreatment)=="rt")] = "tr"
  }
  else {
    packageStartupMessage("Row names of MS1 file is wrong!")
    break()
  }
  mz <- before_pretreatment$mz
  tr <- before_pretreatment$tr
  int <- before_pretreatment[ ,3:ncol(before_pretreatment)]
  packageStartupMessage("MS1 reading is finished.")
  ##########
  
  MS2_filename <- list.files(filepath_MS2)
  data_ms1ms2 <- cbind(before_pretreatment[1,], mzinmgf=1, trinmgf=1, mz_ms2=1, int_ms2=1, CE=1)[-1,]  # Create data.frame to store information of ms1ms2 information

  # Reading and processing mgf files one by one.
  for (i_new in MS2_filename){
    mgf_data <- scan(paste0(filepath_MS2,'\\',i_new), what = character(0), sep = "\n")  # Read mgf file
    mgf_matrix <- createmgfmatrix(mgf_data)  # create mgf_matrix
    CE <- parse_number(i_new) # get CE value in the filename of mgf
    
    # Delete the data with charge > 1
    ##########
    pb <- tkProgressBar(paste("Delete the data in", i_new, "with charge > 1"),"rate of progress %", 0, 100)
    for (i in c(1:length(mgf_data))){
      info<- sprintf("rate of progress %d%%", round(i*100/length(mgf_data))) 
      setTkProgressBar(pb, i*100/length(mgf_data), sprintf(paste("Delete the data in", i_new, "with charge > 1 (%s)"), info),info)
      # If the row of mgf_data is contain the "CHARGE=", 
      if (!is.na(mgf_data[i]) & str_detect(mgf_data[i],"CHARGE=")){
        if (!str_detect(mgf_data[i],"CHARGE=1")){
          mgf_data[mgf_matrix[tail(which(as.numeric(mgf_matrix[,"Begin_num"]) < i),1),"Begin_num"]:
                   mgf_matrix[which(as.numeric(mgf_matrix[,"End_num"]) > i)[1],"End_num"]] <- NA          
        }
      }
    }
    close(pb)
    mgf_data <- na.omit(mgf_data)
    packageStartupMessage(paste("Deleting the data in", i_new, "with charge > 1 is finished."))
    ########
    
    # Delete the data by diff_MS2MS1 and ms2_intensity
    ########
    mgf_matrix <- createmgfmatrix(mgf_data)  # create mgf_matrix
    pb <- tkProgressBar(paste("Delete the data in", i_new, "by diff_MS2MS1 and ms2_intensity"),"rate of progress %", 0, 100)
    for (i in c(1:length(mgf_data))){
      info<- sprintf("rate of progress %d%%", round(i*100/length(mgf_data))) 
      setTkProgressBar(pb, i*100/length(mgf_data), sprintf(paste("Delete the data in", i_new, "by diff_MS2MS1 and ms2_intensity (%s)"), info),info)
      if (!grepl("[a-zA-Z]", mgf_data[i])){
        mz_ms2 <- as.numeric(unlist(strsplit(mgf_data[i], " "))[1])
        int_ms2 <- as.numeric(unlist(strsplit(mgf_data[i], " "))[2])
        mz_ms1 <- as.numeric(mgf_matrix[tail(which(as.numeric(mgf_matrix[,"Begin_num"]) < i),1),"Pepmass_num"])
        if (mz_ms1-mz_ms2 <= diff_MS2MS1 | int_ms2 <= ms2_intensity){
          mgf_data[i] <- NA
        }
      }
    }
    close(pb)
    mgf_data <- na.omit(mgf_data)
    packageStartupMessage(paste("Deleting the data in", i_new, "by diff_MS2MS1 and ms2_intensity is finished."))
    ########
    
    # Delete the data without useful MS2
    ########
    mgf_matrix <- as.data.frame(createmgfmatrix(mgf_data))  # creat mgf_matrix
    pb <- tkProgressBar(paste("Delete the data in", i_new, "without useful MS2"),"rate of progress %", 0, 100)
    for (i in c(1:nrow(mgf_matrix))){
      info<- sprintf("rate of progress %d%%", round(i*100/nrow(mgf_matrix)))  
      setTkProgressBar(pb, i*100/nrow(mgf_matrix), sprintf(paste("Delete the data in", i_new, "without useful MS2 (%s)"), info),info)
      if (as.numeric(as.character(mgf_matrix$End_num[i])) - as.numeric(as.character(mgf_matrix$Begin_num[i])) < 5){
        mgf_data[as.numeric(as.character(mgf_matrix$Begin_num[i])):as.numeric(as.character(mgf_matrix$End_num[i]))] <- NA
      }
    }
    close(pb)
    mgf_data <- na.omit(mgf_data)
    packageStartupMessage(paste("Deleting the data in", i_new, "without useful MS2 is finished."))
    ########
    
    # Combine ms1 and ms2
    mgf_matrix <- as.data.frame(createmgfmatrix(mgf_data))
    for (i in c(1:nrow(mgf_matrix))){
      mzinmgf <- as.numeric(as.character(mgf_matrix$Pepmass_num[i]))
      trinmgf <- as.numeric(as.character(mgf_matrix$TR_num[i]))
      posi <- which(abs(before_pretreatment$mz-mzinmgf) < tol_mz & abs(before_pretreatment$tr-trinmgf) < tol_tr*60)
      if (length(posi)>=1){
        posi <- posi[1]
        ms1info <- before_pretreatment[posi,]
        for (j in mgf_data[as.numeric(as.character(mgf_matrix$Begin_num[i])):as.numeric(as.character(mgf_matrix$End_num[i]))]){
          if (grepl("[a-zA-Z]", j)){
            next()
          }else{
            mz_ms2 <- as.numeric(unlist(strsplit(j, " "))[1])
            int_ms2 <- as.numeric(unlist(strsplit(j, " "))[2])
            ms1ms2conb <- cbind(ms1info,mzinmgf,trinmgf,mz_ms2,int_ms2,CE)
            data_ms1ms2 <- rbind(data_ms1ms2,ms1ms2conb)
          }
        }
      }
    }
  }
  
  data_ms1ms2_final <- data_ms1ms2[1,][-1,]
  uniquedata_ms1ms2 <- distinct(data_ms1ms2[,1:ncol(before_pretreatment)])
  for (i in c(1:nrow(uniquedata_ms1ms2))){
    posi <- which(data_ms1ms2$mz==uniquedata_ms1ms2$mz[i] & data_ms1ms2$tr==uniquedata_ms1ms2$tr[i])
    temp <- data_ms1ms2[posi,]
    posi <- which(temp$int_ms2 == max(temp$int_ms2))
    temp <- temp[posi[1],]
    data_ms1ms2_final <- rbind(data_ms1ms2_final,temp)
  }
  setwd(resultpath)
  write.csv(data_ms1ms2_final,file = "MRM transitions list.csv",row.names = FALSE)
  return(data_ms1ms2_final)
}