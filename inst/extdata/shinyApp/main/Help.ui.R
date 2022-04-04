fluidPage(
  fluidRow(
    div(
      id="mainbody",
      div(style="text-align:center;margin-top:0px;font-size:200%;color:darkred",
          HTML("~~ <em>Dear Users, Welcome to check the help document</em> ~~")),
      includeMarkdown("README.md"),
      column(3)
    )
  )
)
