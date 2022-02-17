source(
  file = "global.R",
  local = T,
  encoding = "UTF-8"
)

shinyUI(
  dashboardPage(
    skin = "blue",
    title = "MRM-Ion Pair Finder",
    header = dashboardHeader(
      title = div("MRM-Ion Pair Finder")
      # titleWidth = 250
    ),
    sidebar = dashboardSidebar(
      sidebarMenu(
        menuItem("Introduction", tabName = "Introduction", icon = icon("laugh-wink")),
        menuItem("MRM-Ion Pair Finder", tabName = "MRM_Ion_Pair_Finder", icon = icon("chart-bar")),
        menuItem("Help document", tabName = "Help", icon = icon("hands-helping"))
      )
    ),
    body = body
  )
)

