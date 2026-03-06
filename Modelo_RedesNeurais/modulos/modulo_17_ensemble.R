# ==============================================================================
# MÓDULO 17: Ensemble de Redes Neurais
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 17: Ensemble (Média Ponderada/Simples dos Modelos)...\n")

library(dplyr)
library(readr)

# Carregar previsões de diferentes arquiteturas na base de teste
# Nota: usamos left_join ou cbind caso garantamos a mesma ordem (temos a mesma ordem cronológica)

dados_alvo <- read_csv("dados/dados_teste.csv", show_col_types = FALSE)

prev_mlp <- read_csv("dados/previsoes_deep_mlp.csv", show_col_types = FALSE)
prev_lstm <- read_csv("dados/previsoes_lstm.csv", show_col_types = FALSE)
prev_gru <- read_csv("dados/previsoes_gru.csv", show_col_types = FALSE)
prev_cnn <- read_csv("dados/previsoes_cnn.csv", show_col_types = FALSE)

df_ensemble <- data.frame(
  Data = dados_alvo$data,
  Target = dados_alvo$target,
  MLP = prev_mlp$previsao_deep_mlp,
  LSTM = prev_lstm$previsao_lstm,
  GRU = prev_gru$previsao_gru,
  CNN = prev_cnn$previsao_cnn
)

# 1. Ensemble por Média Simples
df_ensemble$Ensemble_Media <- rowMeans(df_ensemble[, c("MLP", "LSTM", "GRU", "CNN")], na.rm = TRUE)

# RMSE dos modelos individuais vs Ensemble
calc_rmse <- function(real, prev) { sqrt(mean((real - prev)^2, na.rm=TRUE)) }

rmse_mlp <- calc_rmse(df_ensemble$Target, df_ensemble$MLP)
rmse_lstm <- calc_rmse(df_ensemble$Target, df_ensemble$LSTM)
rmse_gru <- calc_rmse(df_ensemble$Target, df_ensemble$GRU)
rmse_cnn <- calc_rmse(df_ensemble$Target, df_ensemble$CNN)
rmse_ens <- calc_rmse(df_ensemble$Target, df_ensemble$Ensemble_Media)

cat("--- RMSE no Conjunto de Teste ---\n")
cat(sprintf("Deep MLP: %.4f\n", rmse_mlp))
cat(sprintf("LSTM: %.4f\n", rmse_lstm))
cat(sprintf("GRU: %.4f\n", rmse_gru))
cat(sprintf("CNN 1D: %.4f\n", rmse_cnn))
cat(sprintf(">>> ENSEMBLE: %.4f <<<\n", rmse_ens))

write_csv(df_ensemble, "dados/previsoes_ensemble.csv")

cat("Módulo 17 Finalizado.\n")
