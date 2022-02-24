fluidPage(
  fluidRow(id = "parameters",
           column(div(style="text-align:center;margin-top:0px;font-size:200%;color:darkred",
                      HTML("~~ <em>MRM-Ion Pair Finder</em> ~~")),
                  align = "center", width = 12),
           box(
             id = "MS1.MS2.data.file",
             h3("MS1, MS2 data and result file path"),
             textInput("MS1FilePath", label = "file path (MS1)", value = "D:\\github\\MRM-Ion_Pair_Finder\\DemoData\\DemoMS1Data\\peakTable.csv"),

             textInput("MS2FileFolder", label = "file folder (MS2)", value = "D:\\github\\MRM-Ion_Pair_Finder\\DemoData\\DemoMS2Data"),
             textInput("resultpath", label = "Result Path", value = "D:\\github\\MRM-Ion_Pair_Finder"),
             width = 4,
             height = 400,
           ),
           box(
             id = "Parameters.setting.peak.match",
             h3("Parameters setting for MS1 and MS2 peak match"),
             numericInput(inputId = "tRtoleranceMin", label = "tR tolerance (min): tr tolerance between MS1 and MS2 files", value = 0.2),
             numericInput(inputId = "mzToleranceDa", label = "m/z tolerance (Da): m/z tolerance between MS1 and MS2 files", value = 0.01),
             width = 4,
             height = 400
           ),
           box(
             id = "Ion.removal.setting",
             h3("Ion removal setting"),
             numericInput(inputId = "toleranceMS2Intensity", label = "tolerance (MS2 intensity): If the response of product ion is smaller than threshold, it will be deleted.", value = 750),
             numericInput(inputId = "toleranceMS1MS2", label = "tolerance (@MS1~MS2): If the m/z difference between precursor and produce ion is smaller than tolerance (MS1~MS2), it will be deleted.", value = 13.9),
             selectInput("OnlyKeepChargeEqual1", label = "Only keep charge equal 1",
                         choices = list("Yes" = T, "No" = F),
                         selected = T),
             width = 4,
             height = 400
           ),

  ),
  fluidRow(
    box(
      id = "start.button",
      h3("If all parameters were set, click the button.", align = "center"),
      actionButton("startMetEx", h3("Run"), width = "100%", height = "100%"),
      h3("_____________________________________________", align = "center"),
      box(
        h3("Running Information", align = "center"),
        h3("   ", align = "center"),
        shinyjs::useShinyjs(),
        textOutput("text"),
        # status = "success",
        background = "light-blue",
        collapsible = TRUE,
        width = 12,
        height = 200
      ),
      width = 8,
      height = 400
    ),

    box(
      id = "icon.figure",
      h3("Please wait while the icon appears.", align = "center"),
      withSpinner(uiOutput("logo"), type = 6, size = 1),
      width = 4,
      height = 400
    )
  )
)
