# ==============================================================================
# MÓDULO 39: Dashboard Interativo (Shiny)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 39: Compilando UI/Server para Shiny Dashboard...\n")

library(shiny)
library(shinydashboard)
library(dplyr)
library(readr)
library(ggplot2)
library(plotly)

# O Dashboard não vai rodar o runApp() no script de batch para não travar a esteira.
# Mas preparamos a UI e Server prontos para uso manual.

ui <- dashboardPage(
  dashboardHeader(title = "Previsão Petróleo AI"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Visão Geral", tabName = "visao_geral", icon = icon("dashboard")),
      menuItem("Previsões", tabName = "previsoes", icon = icon("chart-line")),
      menuItem("Métricas", tabName = "metricas", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "visao_geral",
              fluidRow(
                box(plotlyOutput("plot_serie"), width = 12, title = "Preço Real (Histórico)", status="primary")
              )
      ),
      tabItem(tabName = "previsoes",
              fluidRow(
                box(plotlyOutput("plot_previsao"), width = 12, title = "Ensemble vs Real", status="danger")
              )
      ),
      tabItem(tabName = "metricas",
              fluidRow(
                box(dataTableOutput("tabela_metricas"), width = 12, title = "Comparação de Arquiteturas", status="success")
              )
      )
    )
  )
)

server <- function(input, output) {
  # Carrega dados on-demand
  serie_hist <- read_csv("dados/petroleo_processado.csv", show_col_types = FALSE)
  prev_ens <- read_csv("dados/previsoes_ensemble.csv", show_col_types = FALSE)
  met_gerais <- read_csv("dados/metricas_agregadas.csv", show_col_types = FALSE)
  
  output$plot_serie <- renderPlotly({
    p <- ggplot(serie_hist, aes(x=data, y=fechamento)) + geom_line(color="darkblue") + theme_minimal()
    ggplotly(p)
  })
  
  output$plot_previsao <- renderPlotly({
    p <- ggplot(prev_ens, aes(x=Data)) + 
      geom_line(aes(y=Target, color="Real")) + 
      geom_line(aes(y=Ensemble_Media, color="Previsão"), linetype="dashed") +
      theme_minimal()
    ggplotly(p)
  })
  
  output$tabela_metricas <- renderDataTable({
    met_gerais
  }, options = list(pageLength = 10))
}

# Em ambiente interativo, o usuário faria:
# shinyApp(ui, server)

cat("Estrutura do Dashboard Shiny criada no Módulo 39.\n")
cat("Para visualizar interativamente o dashboard, rode o comando 'shinyApp(ui, server)' neste script em um RStudio.\n")
cat("Módulo 39 Finalizado.\n")
