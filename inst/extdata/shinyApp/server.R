source(
  file = "global.R",
  local = TRUE,
  encoding = "UTF-8"
)

shinyServer(function(input, output, session) {
  source(file = "main/MRM_Ion_Pair_Finder.server.R", local = T, encoding = "UTF-8")
  
  session$onSessionEnded(function() {
    stopApp()
  })
})
