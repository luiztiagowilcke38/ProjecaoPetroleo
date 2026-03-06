# ==============================================================================
# MÓDULO 22: Regularização (L1, L2, Dropout Explícito)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 22: Demonstração de Regularização L1/L2 (Elastic Net)...\n")

library(dplyr)
library(readr)
library(glmnet)

treino <- read_csv("dados/dados_treino.csv", show_col_types = FALSE)
teste <- read_csv("dados/dados_teste.csv", show_col_types = FALSE)

features <- setdiff(colnames(treino), c("data", "target"))

X_treino <- as.matrix(treino[, features])
y_treino <- as.numeric(treino$target)

X_teste <- as.matrix(teste[, features])
y_teste <- as.numeric(teste$target)

# O Elastic Net combina norma L1 (Lasso) e L2 (Ridge)
# Muito usado para baseline não neural robusto contra overfitting

cat("Ajustando modelo contendo forte penalização a coeficientes inúteis...\n")

# alpha = 0.5 (Mistura balanceada L1/L2)
modelo_elastic <- cv.glmnet(X_treino, y_treino, alpha = 0.5)

previsao_regularizada <- predict(modelo_elastic, s = modelo_elastic$lambda.min, newx = X_teste)

rmse_reg <- sqrt(mean((y_teste - previsao_regularizada)^2))

cat(sprintf("RMSE com Elastic Net (L1/L2): %.4f\n", rmse_reg))

saveRDS(modelo_elastic, "dados/modelo_elasticnet.rds")

# Salvar previsoes
df_reg <- data.frame(target = y_teste, previsao_elast = as.vector(previsao_regularizada))
write_csv(df_reg, "dados/previsoes_regularizacao.csv")

cat("Módulo 22 Finalizado.\n")
