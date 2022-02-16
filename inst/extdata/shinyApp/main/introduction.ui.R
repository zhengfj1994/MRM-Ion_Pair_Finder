fluidPage(
  # helpText(h3("MetEx is a calculation tool for metabolite annotation. It can easily mine metabolite information directly from raw data. We provide the R package, web server version and offline shiny UI version of MetEx, and the three will be updated simultaneously.")),
  # hr(),
  # img(src = "The_workflow_of_MetEx.png", align = "center", width = "100%"),
  fluidRow(
    div(
      id="mainbody",
      column(
        12,
        div(style="text-align:center;margin-top:0px;font-size:200%;color:darkred",
            HTML("~~ <em>Welcome to MRM-Ion Pair Finder</em> ~~")),
        div(style="width:fit-content;width:-webkit-fit-content;width:-moz-fit-content;font-size:150%;margin-top:20px",
            HTML("Pseudotargeted metabolomics is a novel method that perform high coverage metabolomics analysis based on UHPLC-TQMS. MRM-Ion Pair Finder software is an independently developed and written program in our laboratory for large-scale selection of MRM transitions for pseudotargeted metabolomics.")),
        
        div(style="width:fit-content;width:-webkit-fit-content;width:-moz-fit-content;font-size:150%;margin-top:20px",
            HTML("<b>MRM-Ion Pair Finder</b> is used to automatically and systematically define MRM transitions from untargeted metabolomics data. Our research group first introduced the concept of pseudotargeted metabolomics using the retention time locking GC-MS-selected ions monitoring in 2012. The pseudotargeted metabolomics method was extended to LC-MS in 2013. To define ion pairs automatically and systematically, the in-house software “Mul-tiple Reaction Monitoring-Ion Pair Finder (MRM-Ion Pair Finder)” was developed, which made defining of the MRM transitions for untargeted metabolic profiling easier and less time consuming. Recently, MRM-Ion Pair Finder was updated to version 2.0. The new version is more convenient, consumes less time and is also suitable for negative ion mode. And the function of MRM-Ion Pair Finder is also performed in R so that users have more options when using pseudotargeted method.")),

        tags$hr(style="border-color: grey60;"),
        div(style="text-align:center;margin-top: 20px;font-size:120%",
            HTML(" &copy; 2021 <a href='http://www.402.dicp.ac.cn/index.htm' target='_blank'>Guowang Xu's Group</a>. All Rights Reserved.")),
        div(style="text-align:center;margin-bottom: 20px;font-size:120%",
            HTML("&nbsp;&nbsp; Created by Fujian Zheng. E-mail: <u>zhengfj@dicp.ac.cn</u>."))
      ),
      column(3)
    )
  )
)


