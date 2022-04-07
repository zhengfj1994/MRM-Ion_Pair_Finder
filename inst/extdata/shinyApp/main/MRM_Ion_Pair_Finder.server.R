##############################################################################

observeEvent(input$startMetEx, {
  withCallingHandlers({
    shinyjs::html("text", "")

    file_MS1 <- input$MS1FilePath
    filepath_MS2 <- input$MS2FileFolder
    resultpath <- input$resultpath

    data_ms1ms2_final <- MRMFinder::MRM_Ion_Pair_Finder(file_MS1 = file_MS1,
                                             filepath_MS2 = filepath_MS2,
                                             tol_mz = input$mzToleranceDa,
                                             tol_tr = input$tRtoleranceMin,
                                             diff_MS2MS1 = input$toleranceMS1MS2,
                                             ms2_intensity = input$toleranceMS2Intensity,
                                             resultpath = resultpath,
                                             OnlyKeepChargeEqual1 = input$OnlyKeepChargeEqual1,
                                             NumOfProductIons = input$NumOfProductIons,
                                             cores = input$cores)
    if (class(data_ms1ms2_final) == "logical"){
      URL <<- "Error.png"
    }
    else {
      URL <<- "Finished.png"
    }

  },
  message = function(m) {
    shinyjs::html(id = "text", html = m$message, add = F)
  })
})

output$logo <- renderText({
  validate(need(input$startMetEx, "")) #I'm sending an empty string as message.
  input$startMetEx
  Sys.sleep(2)
  # URL <- "Finished.png"
  c('<center><img src="', URL, '"width="100%" height="100%" align="middle"></center>')})
##############################################################################
