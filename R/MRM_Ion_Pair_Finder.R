#' Title MRM_Ion_Pair_Finder
#'
#' @param file_MS1 MS1 peak detection result save in .csv filetype, the first column is m/z named 'mz',
#'                 the second column is retention time(s) named 'tr',
#'                 intensity of samples is located begin the third column.
#' @param filepath_MS2 The folder path which have mgf files.
#' @param tol_mz The tolerence of m/z between MS1 peak detection result and mgf files. 0.01 is suitable for Q-TOF.
#' @param tol_tr The tolerence of retention time between MS1 peak detection result and mgf files.
#' @param diff_MS2MS1 The smallest difference between product ion and precusor ion.
#' @param ms2_intensity The smallest intensity of product ion.
#' @param resultpath A csv file named "MRM transitions list.csv" will saved in the path.
#' @param OnlyKeepChargeEqual1 T or F
#'
#' @return data_ms1ms2_final
#' @export MRM_Ion_Pair_Finder
#' @import doSNOW
#' @import progress
#' @importFrom readr parse_number
#' @importFrom stringr str_detect
#' @importFrom tcltk tkProgressBar setTkProgressBar
#' @importFrom tidyr separate
#' @importFrom dplyr distinct
#' @importFrom utils write.csv read.csv
#' @importFrom stats na.omit

MRM_Ion_Pair_Finder <- function(file_MS1,
                       filepath_MS2,
                       tol_mz,
                       tol_tr,
                       diff_MS2MS1,
                       ms2_intensity,
                       resultpath,
                       OnlyKeepChargeEqual1 = TRUE,
                       cores = 4){

  library(doSNOW)
  library(progress)

  # Function: exact a matrix from mgf_data
  ##########
  createmgfmatrix <- function(mgf_data){
    Begin_num <- grep("BEGIN IONS", mgf_data)
    Pepmass_num <- grep("PEPMASS=",mgf_data)
    TR_num <- grep("RTINSECONDS=",mgf_data)
    End_num <- grep("END IONS", mgf_data)
    mgf_matrix <- as.data.frame(cbind(Begin_num,TR_num,Pepmass_num,End_num))

    Charge_num <- grep("CHARGE=", mgf_data)
    for (i in c(1:nrow(mgf_matrix))){
      Begin_num_i <- mgf_matrix[i,"Begin_num"]
      End_num_i <- mgf_matrix[i,"End_num"]
      position <- which(Charge_num > Begin_num_i & Charge_num < End_num_i)
      if (length(position) == 0){
        mgf_matrix[i,"Charge_num"] <- NA
      }
      else {
        mgf_matrix[i,"Charge_num"] <- strsplit(mgf_data[Charge_num[position]], split = "=")[[1]][2]
      }
    }

    for (i in c(1:length(Pepmass_num)))
    {
      pepmass <- gsub("[^0-9,.]", "", strsplit(mgf_data[Pepmass_num[i]],split = " ")[[1]][1])
      mgf_matrix[i,"Pepmass_num"] <- pepmass

      tr <- gsub("[^0-9,.]", "", mgf_data[TR_num[i]])
      mgf_matrix[i,"TR_num"] <- tr
    }
    return(mgf_matrix)
  }
  ##########

  # Reading csv file containing peak detection result of MS1.
  ##########
  packageStartupMessage("MS1 reading.")
  before_pretreatment = tryCatch({
    read.csv(file = file_MS1)
  },warning = function(w){
    packageStartupMessage(w)
    print("Warning")
  },error = function(e){
    packageStartupMessage(e)
    print("Error")
  })

  if (!is.character(before_pretreatment)){
    if (length(which(colnames(before_pretreatment)=="tr")) >= 1){}
    else if (length(which(colnames(before_pretreatment)=="tr")) == 0 & length(which(colnames(before_pretreatment)=="rt")) >= 1){
      colnames(before_pretreatment)[which(colnames(before_pretreatment)=="rt")] = "tr"
    }
    else {
      packageStartupMessage("Row names of MS1 file is wrong!")
    }

    RowNamesChecker = tryCatch({
      mz <- before_pretreatment$mz
      tr <- before_pretreatment$tr
    },warning = function(w){
      packageStartupMessage(w)
      print("Warning")
    },error = function(e){
      packageStartupMessage(e)
      print("Error")
    })
    if (!is.character(RowNamesChecker)){
      int <- before_pretreatment[ ,3:ncol(before_pretreatment)]
      packageStartupMessage("MS1 reading is finished.")
      # MS2
      MS2_filename <- list.files(filepath_MS2)
      MS2_filename <- MS2_filename[grep(".mgf",basename(MS2_filename))]
      if (length(MS2_filename) == 0){
        packageStartupMessage("Error! Please check whether the file folder (MS2) is correct, it must be a folder instead of a file, we recommend that only mgf files are stored in this folder, and each mgf file is named according to their collision energy, such as 15V.mgf.")
        data_ms1ms2_final <- NA
      }
      else {
        data_ms1ms2 <- cbind(before_pretreatment[1,], mzinmgf=1, trinmgf=1, mz_ms2=1, int_ms2=1, CE=1)[-1,]  # Create data.frame to store information of ms1ms2 information

        # Reading and processing mgf files one by one.
        for (i_new in MS2_filename){
          mgf_data <- scan(paste0(filepath_MS2,'\\',i_new), what = character(0), sep = "\n")  # Read mgf file
          mgf_matrix <- createmgfmatrix(mgf_data)  # create mgf_matrix
          CE <- readr::parse_number(i_new) # get CE value in the filename of mgf

          if (OnlyKeepChargeEqual1 == TRUE){
            # Delete the data with charge > 1
            ##########
            packageStartupMessage(paste("Deleting the data in", i_new, "with charge > 1."))
            pb <- tcltk::tkProgressBar(paste("Delete the data in", i_new, "with charge > 1"),"rate of progress %", 0, 100)
            for (i in c(1:nrow(mgf_matrix))){
              info<- sprintf("rate of progress %d%%", round(i*100/nrow(mgf_matrix)))
              tcltk::setTkProgressBar(pb, i*100/nrow(mgf_matrix), sprintf(paste("Delete the data in", i_new, "with charge > 1 (%s)"), info),info)
              # If the row of mgf_data is contain the "CHARGE=",
              if (!(is.na(mgf_matrix[i, "Charge_num"]) | stringr::str_detect(mgf_matrix[i, "Charge_num"],"1"))){
                mgf_data[mgf_matrix[i, "Begin_num"]:mgf_matrix[i, "End_num"]] <- NA
              }
            }
            close(pb)
            mgf_data <- na.omit(mgf_data)
            packageStartupMessage(paste("Deleting the data in", i_new, "with charge > 1 is finished."))
            ########
          }

          # Delete the data by diff_MS2MS1 and ms2_intensity
          ########
          mgf_matrix <- createmgfmatrix(mgf_data)  # create mgf_matrix
          packageStartupMessage(paste("Deleting the data in", i_new, "by diff_MS2MS1 and ms2_intensity."))
          pb <- tcltk::tkProgressBar(paste("Delete the data in", i_new, "by diff_MS2MS1 and ms2_intensity"),"rate of progress %", 0, 100)

          mgf_data_1 <- mgf_data[mgf_matrix$Begin_num[1]:mgf_matrix$End_num[1]]
          firstID <- !grepl("[a-zA-Z]", mgf_data_1)
          first.temp.df <- as.data.frame(mgf_data_1[firstID])

          if (length(strsplit(first.temp.df[1,1], split = " ")[[1]]) == 2){
            for (i in c(1:nrow(mgf_matrix))){
              info <- sprintf("rate of progress %d%%", round(i*100/nrow(mgf_matrix)))
              tcltk::setTkProgressBar(pb, i*100/nrow(mgf_matrix), sprintf(paste("Delete the data in", i_new, "by diff_MS2MS1 and ms2_intensity (%s)"), info),info)
              mgf_data_i <- mgf_data[mgf_matrix$Begin_num[i]:mgf_matrix$End_num[i]]
              ithID <- !grepl("[a-zA-Z]", mgf_data_i)
              ith.temp.df <- as.data.frame(mgf_data_i[ithID])
              colnames(ith.temp.df) <- "ion_int"
              ith.temp.df <- tidyr::separate(ith.temp.df,"ion_int",into = c("ion", "intensity"),sep = " ")

              mz_ms1 <- as.numeric(mgf_matrix[i,"Pepmass_num"])
              deleteID <- which(mz_ms1-as.numeric(ith.temp.df$ion) <= diff_MS2MS1 | as.numeric(ith.temp.df$intensity) <= ms2_intensity)
              deleteID <- which(ithID)[deleteID]
              mgf_data[(mgf_matrix$Begin_num[i]:mgf_matrix$End_num[i])[deleteID]] <- NA
            }
            close(pb)
          }
          else {
            for (i in c(1:nrow(mgf_matrix))){
              info <- sprintf("rate of progress %d%%", round(i*100/nrow(mgf_matrix)))
              tcltk::setTkProgressBar(pb, i*100/nrow(mgf_matrix), sprintf(paste("Delete the data in", i_new, "by diff_MS2MS1 and ms2_intensity (%s)"), info),info)
              mgf_data_i <- mgf_data[mgf_matrix$Begin_num[i]:mgf_matrix$End_num[i]]
              ithID <- !grepl("[a-zA-Z]", mgf_data_i)
              ith.temp.df <- as.data.frame(mgf_data_i[ithID])
              colnames(ith.temp.df) <- "ion_int_charge"
              ith.temp.df <- tidyr::separate(ith.temp.df,"ion_int_charge",into = c("ion", "intensity","charge"),sep = " ")

              mz_ms1 <- as.numeric(mgf_matrix[i,"Pepmass_num"])
              deleteID <- which(mz_ms1-as.numeric(ith.temp.df$ion) <= diff_MS2MS1 | as.numeric(ith.temp.df$intensity) <= ms2_intensity)
              deleteID <- which(ithID)[deleteID]
              mgf_data[(mgf_matrix$Begin_num[i]:mgf_matrix$End_num[i])[deleteID]] <- NA
            }
            close(pb)
          }

          mgf_data <- na.omit(mgf_data)
          packageStartupMessage(paste("Deleting the data in", i_new, "by diff_MS2MS1 and ms2_intensity is finished."))
          ########

          # Delete the data without useful MS2
          ########
          mgf_matrix <- as.data.frame(createmgfmatrix(mgf_data))  # creat mgf_matrix
          packageStartupMessage(paste("Deleting the data in", i_new, "without useful MS2."))
          pb <- tcltk::tkProgressBar(paste("Delete the data in", i_new, "without useful MS2"),"rate of progress %", 0, 100)
          for (i in c(1:nrow(mgf_matrix))){
            info <- sprintf("rate of progress %d%%", round(i*100/nrow(mgf_matrix)))
            tcltk::setTkProgressBar(pb, i*100/nrow(mgf_matrix), sprintf(paste("Delete the data in", i_new, "without useful MS2 (%s)"), info),info)
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
          packageStartupMessage(paste("Combining MS1 and MS2."))

          # cores <- parallel::detectCores()
          cl <- makeSOCKcluster(cores)
          registerDoSNOW(cl)

          ptm <- proc.time()

          # progress bar ------------------------------------------------------------
          iterations <- nrow(mgf_matrix)
          pb <- progress_bar$new(
            format = ":letter [:bar] :elapsed | Remaining time: :eta <br>",
            total = iterations,
            width = 120)
          # allowing progress bar to be used in foreach -----------------------------
          progress <- function(n){
            pb$tick(tokens = list(letter = "Progress of Combining MS1 and MS2."))
          }
          opts <- list(progress = progress)

          ms1ms2Combiner <- function(i){
            mzinmgf <- as.numeric(as.character(mgf_matrix$Pepmass_num[i]))
            trinmgf <- as.numeric(as.character(mgf_matrix$TR_num[i]))
            posi <- which(abs(before_pretreatment$mz-mzinmgf) < tol_mz & abs(before_pretreatment$tr-trinmgf) < tol_tr*60)
            if (length(posi)>=1){
              posi <- posi[1]
              ms1info <- before_pretreatment[posi,]
              tempMS2 <- mgf_data[as.numeric(as.character(mgf_matrix$Begin_num[i])):as.numeric(as.character(mgf_matrix$End_num[i]))]
              tempMS2 <- tempMS2[which(!grepl("[a-zA-Z]", tempMS2))]
              tempMS2 <- strsplit(tempMS2,split = " ")
              tempMS2 <- do.call(rbind,lapply(tempMS2, rbind))
              tempMS2 <- tempMS2[,c(1:2),drop=FALSE]
              colnames(tempMS2)[1:2] <- c("mz_ms2", "int_ms2")
              ms1ms2conb <- cbind(ms1info[rep(1,nrow(tempMS2)),],
                                  rep(mzinmgf,nrow(tempMS2)),
                                  rep(trinmgf,nrow(tempMS2)),
                                  tempMS2,
                                  rep(CE,nrow(tempMS2)))
              colnames(ms1ms2conb) <- c(colnames(ms1info),"mzinmgf","trinmgf","mz_ms2","int_ms2","CE")
            }
            else {
              ms1ms2conb <- cbind(before_pretreatment[1,], mzinmgf=1, trinmgf=1, mz_ms2=1, int_ms2=1, CE=1)[-1,]
            }
            return(ms1ms2conb)
          }

          ith_data_ms1ms2 <- foreach(i=1:nrow(mgf_matrix), .options.snow=opts, .combine='rbind') %dopar% ms1ms2Combiner(i)
          stopCluster(cl)
          data_ms1ms2 <- rbind(data_ms1ms2,ith_data_ms1ms2)

          print(proc.time()-ptm)
          packageStartupMessage("Combining MS1 and MS2 is finished")

          # pb <- tcltk::tkProgressBar(paste("Combining MS1 and MS2 of", i_new),"rate of progress %", 0, 100)
          # for (i in c(1:nrow(mgf_matrix))){
          #   info <- sprintf("rate of progress %d%%", round(i*100/nrow(mgf_matrix)))
          #   tcltk::setTkProgressBar(pb, i*100/nrow(mgf_matrix), sprintf(paste("Combining MS1 and MS2 of", i_new, "(%s)"), info),info)
          #   mzinmgf <- as.numeric(as.character(mgf_matrix$Pepmass_num[i]))
          #   trinmgf <- as.numeric(as.character(mgf_matrix$TR_num[i]))
          #   posi <- which(abs(before_pretreatment$mz-mzinmgf) < tol_mz & abs(before_pretreatment$tr-trinmgf) < tol_tr*60)
          #   if (length(posi)>=1){
          #     posi <- posi[1]
          #     ms1info <- before_pretreatment[posi,]
          #     for (j in mgf_data[as.numeric(as.character(mgf_matrix$Begin_num[i])):as.numeric(as.character(mgf_matrix$End_num[i]))]){
          #       if (grepl("[a-zA-Z]", j)){
          #         next()
          #       }else{
          #         mz_ms2 <- as.numeric(unlist(strsplit(j, " "))[1])
          #         int_ms2 <- as.numeric(unlist(strsplit(j, " "))[2])
          #         ms1ms2conb <- cbind(ms1info,mzinmgf,trinmgf,mz_ms2,int_ms2,CE)
          #         data_ms1ms2 <- rbind(data_ms1ms2,ms1ms2conb)
          #       }
          #     }
          #   }
          # }
          # close(pb)
        }

        data_ms1ms2$int_ms2 <- as.numeric(data_ms1ms2$int_ms2)
        data_ms1ms2$mz_ms2 <- as.numeric(data_ms1ms2$mz_ms2)
        data_ms1ms2_final <- data_ms1ms2[1,][-1,]
        uniquedata_ms1ms2 <- dplyr::distinct(data_ms1ms2[,1:ncol(before_pretreatment)])
        for (i in c(1:nrow(uniquedata_ms1ms2))){
          posi <- which(data_ms1ms2$mz==uniquedata_ms1ms2$mz[i] & data_ms1ms2$tr==uniquedata_ms1ms2$tr[i])
          temp <- data_ms1ms2[posi,]
          posi <- which(temp$int_ms2 == max(temp$int_ms2))
          temp <- temp[posi[1],]
          data_ms1ms2_final <- rbind(data_ms1ms2_final,temp)
        }

        WriteCsvChecker = tryCatch({
          write.csv(data_ms1ms2_final,file = paste0(resultpath, "/", "MRM transitions list.csv"),row.names = FALSE)
        },warning = function(w){
          packageStartupMessage(w)
          print("Warning")
        },error = function(e){
          packageStartupMessage(e)
          print("Error")
        })

        if (!is.character(WriteCsvChecker)){
          packageStartupMessage("MRM Ion Pair Finder is finished.")
          ########################Finish###########################
        }
        else {
          packageStartupMessage("Error! Please confirm that the Result Path is correct and already exists. Such as D:\\MRMFinder\\Result.")
          data_ms1ms2_final <- NA
          ########################Finish###########################
        }
      }
    }
  }
  else {
    packageStartupMessage("Error! Please check that the file path (MS1) is correct and that your MS1 file is correct. The MS1 file must be a .csv file and the first column name is mz and the second column name is tr.")
    data_ms1ms2_final <- NA
  }
  return(data_ms1ms2_final)
}
