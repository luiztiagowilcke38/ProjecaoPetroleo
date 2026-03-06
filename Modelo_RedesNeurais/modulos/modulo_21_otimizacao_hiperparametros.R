# ==============================================================================
# MÓDULO 21: Otimização de Hiperparâmetros
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 21: Busca de Hiperparâmetros...\n")

library(dplyr)
library(readr)
library(caret)
library(randomForest)

treino <- read_csv("dados/dados_treino.csv", show_col_types = FALSE)

# Devido ao custo computacional no R puro para Keras (grid search),
# faremos a otimização de parâmetros de um proxy ensemble nativo rápido: RandomForest.
# Ele valida a não-linearidade e define pesos ótimos usando Random Search.

features <- setdiff(colnames(treino), c("data", "target"))

# Controle de treino para o caret (Time Slice validation ideal para séries temporais)
# Deixamos simples CV por brevidade didática num script genérico, 
# mas em prod usamos timeslice
fitControl <- trainControl(
  method = "cv",
  number = 3,
  search = "random" # Random Search
)

cat("Iniciando Random Search para modelo Baseline Random Forest...\n")

# Para poupar CPU do usuário na demonstração, amostragem dos dados
treino_sample <- treino %>% sample_n(min(nrow(treino), 500))

tryCatch({
  set.seed(825)
  modelo_rf_grid <- train(
    x = treino_sample[, features],
    y = treino_sample$target,
    method = "rf",
    tuneLength = 3, # Tenta 3 combinações aleatórias de mtry
    trControl = fitControl
  )
  
  cat("Melhores Parâmetros Encontrados:\n")
  print(modelo_rf_grid$bestTune)
  
  saveRDS(modelo_rf_grid, "dados/modelo_rf_otimizado.rds")
  
}, error = function(e){
  cat("Aviso na Otimização:", e$message, "\n")
})

cat("Módulo 21 Finalizado.\n")
