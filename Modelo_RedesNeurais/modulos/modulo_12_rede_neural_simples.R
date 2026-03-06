# ==============================================================================
# MÓDULO 12: Rede Neural Simples (MLP Raso)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 12: MLP Simples com neuralnet...\n")

library(dplyr)
library(readr)
library(neuralnet)
library(ggplot2)

treino <- read_csv("dados/dados_treino.csv", show_col_types = FALSE)
teste <- read_csv("dados/dados_teste.csv", show_col_types = FALSE)

# Remover a coluna de data para o modelo (o algoritmo só entende numéricos)
df_treino_modelo <- treino %>% select(-data)
df_teste_modelo <- teste %>% select(-data)

# Fórmula dinámica (target ~ lag_1 + lag_2 + ... + lag_10)
nomes_vars <- colnames(df_treino_modelo)
features <- nomes_vars[nomes_vars != "target"]
formula_nn <- as.formula(paste("target ~", paste(features, collapse = " + ")))

cat("Treinando rede neural perceptron multicamadas (MLP) rasa (1 camada, 5 neurônios)...\n")
# Usando neuralnet (pode ser lento dependendo do tamanho dos dados)
set.seed(42)
modelo_mlp_simples <- neuralnet(
  formula_nn, 
  data = df_treino_modelo, 
  hidden = c(5), # 1 camada, 5 neurônios
  linear.output = TRUE, 
  stepmax = 1e6
)

# Previsão
previsoes <- compute(modelo_mlp_simples, df_teste_modelo[, features])
previsoes_valores <- previsoes$net.result

# Avaliação Rápida RMSE (z-score space)
rmse <- sqrt(mean((df_teste_modelo$target - previsoes_valores)^2))
cat(sprintf("RMSE no Teste (escala Normalizada Z): %.4f\n", rmse))

# Gráfico da arquitetura
# plot(modelo_mlp_simples) # Omitido no batch mode, causa plotagem interativa

# Salvar modelo para comparações futuras
saveRDS(modelo_mlp_simples, "dados/modelo_mlp_simples.rds")

# Guardar as previsões
df_teste_modelo$previsao_mlp_simples <- previsoes_valores
write_csv(df_teste_modelo, "dados/previsoes_mlp_simples.csv")

cat("Módulo 12 Finalizado.\n")
