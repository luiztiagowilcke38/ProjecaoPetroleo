# ==============================================================================
# PROJETO: Modelo Estatístico de Previsão do Preço do Petróleo
# AUTOR: Luiz Tiago Wilcke
# ARQUIVO: main.R
# DESCRIÇÃO: Script orquestrador que executa sequencialmente os 40 módulos.
# ==============================================================================

cat("\n========================================================\n")
cat(" INICIANDO PIPELINE - MODELO DE PREVISÃO DO PETRÓLEO\n")
cat(" Autor: Luiz Tiago Wilcke\n")
cat("========================================================\n\n")

# 1. Instalação e Carregamento de Pacotes Necessários
pacotes_necessarios <- c(
  "quantmod", "dplyr", "tidyr", "lubridate", "ggplot2", "plotly", "tseries", 
  "forecast", "keras", "tensorflow", "neuralnet", "caret", "randomForest", 
  "urca", "rugarch", "vars", "patchwork", "ggcorrplot", "rmarkdown", "shiny",
  "xts", "zoo", "readr", "stringr", "glmnet", "shinydashboard"
)

instalar_pacotes <- function(pacotes) {
  novos_pacotes <- pacotes[!(pacotes %in% installed.packages()[,"Package"])]
  if(length(novos_pacotes)) install.packages(novos_pacotes, dependencies = TRUE)
  invisible(lapply(pacotes, require, character.only = TRUE))
}

suppressWarnings(suppressMessages(instalar_pacotes(pacotes_necessarios)))

# Configuração de Ambiente para Keras/Tensorflow (opcional, requer Python instalado)
# install_keras()

# Criar pastas caso não existam
dir.create("dados", showWarnings = FALSE)
dir.create("modulos", showWarnings = FALSE)
dir.create("graficos", showWarnings = FALSE)

# 2. Definição do Caminho dos Módulos
caminho_modulos <- "modulos/"

# Função auxiliar para rodar módulos com tratamento de erro
executar_modulo <- function(nome_arquivo) {
  caminho_completo <- paste0(caminho_modulos, nome_arquivo)
  if(file.exists(caminho_completo)) {
    cat(sprintf("\n---> Executando: %s ...\n", nome_arquivo))
    tryCatch({
      source(caminho_completo, encoding = "UTF-8")
      cat(sprintf("[SUCESSO] %s concluído.\n", nome_arquivo))
    }, error = function(e) {
      cat(sprintf("[ERRO] Falha ao executar %s: %s\n", nome_arquivo, e$message))
    })
  } else {
    cat(sprintf("[AVISO] Arquivo não encontrado: %s\n", nome_arquivo))
  }
}

# 3. Lista de todos os 40 Módulos
lista_modulos <- sprintf("modulo_%02d_%s.R", 1:40, c(
  "coleta_dados", "preprocessamento", "analise_exploratoria", "decomposicao_serie", "estacionaridade",
  "diferenciacao", "correlacao", "outliers", "normalizacao", "janelas_deslizantes",
  "divisao_treino_teste", "rede_neural_simples", "rede_neural_profunda", "lstm", "gru",
  "cnn_1d", "ensemble", "atencao", "transformer", "autoencoder",
  "otimizacao_hiperparametros", "regularizacao", "validacao_cruzada", "metricas_avaliacao", "comparacao_modelos",
  "previsao_curto_prazo", "previsao_medio_prazo", "previsao_longo_prazo", "intervalos_confianca", "backtesting",
  "analise_sentimento", "variaveis_macroeconomicas", "cointegracao", "volatilidade_garch", "quebras_estruturais",
  "analise_espectral", "redes_bayesianas", "explicabilidade", "dashboard", "relatorio_final"
))

# 4. Execução Sequencial (Descomentar para rodar todos de uma vez)
for (modulo in lista_modulos) {
  executar_modulo(modulo)
}

cat("\n========================================================\n")
cat(" PIPELINE FINALIZADA!\n")
cat("========================================================\n")
