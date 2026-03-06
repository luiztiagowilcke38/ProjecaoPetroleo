# ==============================================================================
# MÓDULO 10: Criação de Janelas Temporais (Sliding Windows)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 10: Janelas Deslizantes...\n")

library(dplyr)
library(readr)

dados <- read_csv("dados/petroleo_normalizado.csv", show_col_types = FALSE)

# Para séries temporais em ML, transformamos dados sequenciais em formato tabular supervisionado
# usando a técnica de n lags.
# X = [x_t-1, x_t-2, ..., x_t-n] => Y = [x_t]

criar_janelas <- function(serie, lags = 5) {
  n <- length(serie)
  if (n <= lags) stop("Série muito curta para os lags especificados.")
  
  matriz_x <- matrix(NA, nrow = n - lags, ncol = lags)
  vetor_y <- rep(NA, n - lags)
  
  for (i in 1:(n - lags)) {
    matriz_x[i, ] <- serie[i:(i + lags - 1)]
    vetor_y[i] <- serie[i + lags]
  }
  
  df_janelas <- as.data.frame(matriz_x)
  colnames(df_janelas) <- paste0("lag_", lags:1)
  df_janelas$target <- vetor_y
  
  return(df_janelas)
}

# Escolhemos 10 lags (duas semanas de mercado aproximadamente)
Lags_Selecionados <- 10
serie_alvo <- dados$log_retorno_z

dataset_lags <- criar_janelas(serie_alvo, lags = Lags_Selecionados)

# Para alinhar temporalmente, pegamos as datas correspondentes ao target
datas_alinhadas <- dados$data[(Lags_Selecionados + 1):nrow(dados)]
dataset_lags <- cbind(data = datas_alinhadas, dataset_lags)

write_csv(dataset_lags, "dados/dataset_matriz_janelas.csv")

cat(sprintf("Criada matriz com %d lags. Dimensões do dataset: %d x %d\n", 
            Lags_Selecionados, nrow(dataset_lags), ncol(dataset_lags)))
cat("Esse é o dataset final de features para aprendizado supervisionado de redes neurais.\n")
cat("Módulo 10 Finalizado.\n")
