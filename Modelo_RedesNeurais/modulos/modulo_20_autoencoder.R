# ==============================================================================
# MÓDULO 20: Autoencoder (Extração de Sub-Features / Redução de Dimensionalidade)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 20: Autoencoder...\n")

library(dplyr)
library(readr)
library(keras)

treino <- read_csv("dados/dados_treino.csv", show_col_types = FALSE)
validacao <- read_csv("dados/dados_validacao.csv", show_col_types = FALSE)
teste <- read_csv("dados/dados_teste.csv", show_col_types = FALSE)

# O Autoencoder vai tentar reconstruir os lags (aprendizado não supervisionado na entrada)
features <- setdiff(colnames(treino), c("data", "target"))

X_treino <- as.matrix(treino[, features])
X_val <- as.matrix(validacao[, features])
X_teste <- as.matrix(teste[, features])

input_dim <- ncol(X_treino)
encoding_dim <- 4 # Comprimimos 10 lags em 4 dimensões (features densas latentes)

cat("Montando Autoencoder (Encoder + Decoder)...\n")

tryCatch({
  # Arquitetura
  input_layer <- layer_input(shape = input_dim)
  
  # Encoder
  encoded <- input_layer %>%
    layer_dense(units = 8, activation = "relu") %>%
    layer_dense(units = encoding_dim, activation = "relu", name = "bottleneck")
  
  # Decoder
  decoded <- encoded %>%
    layer_dense(units = 8, activation = "relu") %>%
    layer_dense(units = input_dim, activation = "linear")
  
  autoencoder <- keras_model(inputs = input_layer, outputs = decoded)
  
  # O modelo isolado do encoder para usarmos como gerador de features
  encoder_interno <- keras_model(inputs = input_layer, outputs = encoded)
  
  autoencoder %>% compile(
    loss = "mse",
    optimizer = "adam"
  )
  
  cat("Treinando autoencoder para reconstruir a própria entrada...\n")
  autoencoder %>% fit(
    X_treino, X_treino, # Target é o próprio input X
    epochs = 100,
    batch_size = 32,
    validation_data = list(X_val, X_val),
    verbose = 0
  )
  
  # Gerando o dataset comprimido com as novas features
  X_treino_comprimido <- encoder_interno %>% predict(X_treino)
  X_teste_comprimido <- encoder_interno %>% predict(X_teste)
  
  # Salvar para eventual uso por outros algoritmos no futuro
  df_treino_novo <- data.frame(X_treino_comprimido)
  colnames(df_treino_novo) <- paste0("latent_", 1:encoding_dim)
  df_treino_novo$target <- treino$target
  write_csv(df_treino_novo, "dados/treino_autoencoder_features.csv")
  
  cat("Autoencoder treinado. Features latentes extraídas.\n")
  
}, error = function(e){
  cat("[AVISO] TensorFlow indisponível para Autoencoder real. Gerando PCA como proxy heurístico.\n")
  # Se o keras falhar, uso PCA (Principal Component Analysis) que cumpre função análoga matematicamente
  pca <- prcomp(X_treino, center = TRUE, scale. = TRUE)
  X_treino_comprimido <- pca$x[, 1:encoding_dim]
  
  df_treino_novo <- data.frame(X_treino_comprimido)
  colnames(df_treino_novo) <- paste0("latent_", 1:encoding_dim)
  df_treino_novo$target <- treino$target
  write_csv(df_treino_novo, "dados/treino_autoencoder_features.csv")
})

cat("Módulo 20 Finalizado.\n")
