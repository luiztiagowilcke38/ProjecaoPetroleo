# ==============================================================================
# MÓDULO 24: Métricas de Avaliação
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 24: Cálculo Estruturado de Métricas...\n")

library(dplyr)
library(readr)

# Carrega todas as previsões da base de teste
dados_teste <- read_csv("dados/dados_teste.csv", show_col_types = FALSE)
y_real <- dados_teste$target

# Lista de arquivos previstos
arquivos_prev <- c(
  "previsoes_mlp_simples.csv", "previsoes_deep_mlp.csv",
  "previsoes_lstm.csv", "previsoes_gru.csv", "previsoes_cnn.csv",
  "previsoes_ensemble.csv", "previsoes_attention.csv", "previsoes_transformer.csv"
)

# Funções de métricas
calc_rmse <- function(y, p) { sqrt(mean((y - p)^2, na.rm=TRUE)) }
calc_mae <- function(y, p) { mean(abs(y - p), na.rm=TRUE) }
calc_r2 <- function(y, p) { 1 - (sum((y - p)^2) / sum((y - mean(y))^2)) }
# RMSE escalado serve similarmente ao MAPE num cenário Z-score 
# E Theil's U indica se é melhor que walk-forward ingênuo

metricas_gerais <- data.frame(Modelo = character(), RMSE = numeric(), MAE = numeric(), R2 = numeric())

# Computando para todos que existem validamente
for(arq in arquivos_prev) {
  caminho <- paste0("dados/", arq)
  if(file.exists(caminho)) {
    df_p <- read_csv(caminho, show_col_types = FALSE)
    # Achar coluna de previsão
    col_prev <- setdiff(colnames(df_p), c("Target", "target", "Data", "data"))[1]
    
    # Se for o ensemble pega o col específico
    if(arq == "previsoes_ensemble.csv"){
      col_prev <- "Ensemble_Media"
    }
    
    vetor_p <- unlist(df_p[[col_prev]])
    
    r <- calc_rmse(y_real, vetor_p)
    m <- calc_mae(y_real, vetor_p)
    r2 <- calc_r2(y_real, vetor_p)
    
    nome_modelo <- gsub("previsoes_", "", arq)
    nome_modelo <- gsub(".csv", "", nome_modelo)
    
    metricas_gerais <- rbind(metricas_gerais, data.frame(Modelo = nome_modelo, RMSE = r, MAE = m, R2 = r2))
  }
}

write_csv(metricas_gerais, "dados/metricas_agregadas.csv")

cat("\n--- TABELA DE MÉTRICAS CONSOLIDADA ---\n")
print(metricas_gerais %>% arrange(RMSE))

cat("Módulo 24 Finalizado.\n")
