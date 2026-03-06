# ==============================================================================
# MÓDULO 09: Normalização e Padronização
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 09: Normalização...\n")

library(dplyr)
library(readr)

dados <- read_csv("dados/petroleo_sem_outliers.csv", show_col_types = FALSE)

# Redes Neurais são sensíveis à escala. Normalizar/Padronizar é crucial.
# O método Min-Max Scaler coloca tudo entre 0 e 1, bom para sigmóides clássicas.
# O método Z-score ajusta média 0 e desvio 1, excelente para deep learning.

# Usaremos Min-Max para volume e Z-score para log_retorno_tratado (nossa target/feature)

normaliza_minmax <- function(x) {
  return ((x - min(x, na.rm=TRUE)) / (max(x, na.rm=TRUE) - min(x, na.rm=TRUE)))
}

normaliza_zscore <- function(x) {
  return ((x - mean(x, na.rm=TRUE)) / sd(x, na.rm=TRUE))
}

# Aplicando as transformações e guardando os parâmetros para desnormalizar no final se prever preço
parametros_norm <- list(
  log_ret_media = mean(dados$log_retorno_tratado, na.rm=TRUE),
  log_ret_sd = sd(dados$log_retorno_tratado, na.rm=TRUE),
  preco_media = mean(dados$fechamento, na.rm=TRUE),
  preco_sd = sd(dados$fechamento, na.rm=TRUE)
)
saveRDS(parametros_norm, "dados/parametros_normalizacao.rds")

dados_norm <- dados %>%
  mutate(
    volume_norm = normaliza_minmax(volume),
    log_retorno_z = normaliza_zscore(log_retorno_tratado),
    fechamento_z = normaliza_zscore(fechamento), # Caso usemos preço direto em algum modelo
    tendencia_z = normaliza_zscore(tendencia)
  )

write_csv(dados_norm, "dados/petroleo_normalizado.csv")
cat("Dataset normalizado. Parâmetros de escalonamento salvos em 'dados/parametros_normalizacao.rds'.\n")
cat("Módulo 09 Finalizado.\n")
