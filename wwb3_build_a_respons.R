# Wwb3 Build A Respons Game Prototype Parser

# Load necessary libraries
library(shiny)
library(jsonlite)
library(ggplot2)

# Define game data structure
game_data <- list(
  characters = list(
    character1 = list(
      name = "Character 1",
      hp = 100,
      attack = 20
    ),
    character2 = list(
      name = "Character 2",
      hp = 120,
      attack = 30
    )
  ),
  quests = list(
    quest1 = list(
      name = "Quest 1",
      description = "Complete quest 1",
      reward = 100
    ),
    quest2 = list(
      name = "Quest 2",
      description = "Complete quest 2",
      reward = 200
    )
  )
)

# Define parser function
parse_game_data <- function(file_path) {
  # Read json file
  data <- fromJSON(file_path)
  
  # Extract game data
  characters <- data$characters
  quests <- data$quests
  
  # Create data frames for characters and quests
  characters_df <- do.call(rbind, lapply(characters, function(x) data.frame(name = x$name, hp = x$hp, attack = x$attack)))
  quests_df <- do.call(rbind, lapply(quests, function(x) data.frame(name = x$name, description = x$description, reward = x$reward)))
  
  # Return data frames
  list(characters = characters_df, quests = quests_df)
}

# Define shiny app UI
ui <- fluidPage(
  titlePanel("Wwb3 Build A Respons Game Prototype Parser"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Select a JSON file"),
      actionButton("parse", "Parse JSON File")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Characters", tableOutput("characters")),
        tabPanel("Quests", tableOutput("quests"))
      )
    )
  )
)

# Define shiny app server
server <- function(input, output) {
  data <- eventReactive(input$parse, {
    if (is.null(input$file)) {
      return(NULL)
    } else {
      parse_game_data(input$file$datapath)
    }
  }, ignoreNULL = FALSE)
  
  output$characters <- renderTable({
    if (is.null(data())) {
      return(NULL)
    } else {
      data()$characters
    }
  })
  
  output$quests <- renderTable({
    if (is.null(data())) {
      return(NULL)
    } else {
      data()$quests
    }
  })
}

# Run shiny app
shinyApp(ui = ui, server = server)