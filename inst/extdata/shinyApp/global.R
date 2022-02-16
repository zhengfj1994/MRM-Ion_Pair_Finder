library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(shinyjs)

# options(shiny.maxRequestSize=5000*1024^2)

body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "Introduction",
      source(
        file = "main/introduction.ui.R",
        local = T,
        encoding = "UTF-8"
      )$value
    ),
    ############################################################################
    # Second tab content
    tabItem(
      tabName = "MRM_Ion_Pair_Finder",
      source(
        file = "main/MRM_Ion_Pair_Finder.ui.R",
        local = T,
        encoding = "UTF-8"
      )$value
    ),
    ############################################################################
    tabItem(
      tabName = "Help",
      source(
        file = "main/Help.ui.R",
        local = T,
        encoding = "UTF-8"
      )$value
    )
  )
)
