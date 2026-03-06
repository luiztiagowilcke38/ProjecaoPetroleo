# ==============================================================================
# MÓDULO 32: Variáveis Macroeconômicas Exógenas (DXY, Câmbio)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 32: Variáveis Macro do Petróleo...\n")

library(dplyr)
library(readr)
library(quantmod)

dados <- read_csv("dados/petroleo_sentimento.csv", show_col_types = FALSE)
min_data <- as.character(min(dados$data))
max_data <- as.character(max(dados$data))

# Petróleo é tabelado em Dólar. O índice do dólar (DXY) tem correlação inversíssima clássica.
cat("Buscando dados do US Dollar Index (DX-Y.NYB)...\n")

dxy_bruto <- tryCatch({
  getSymbols("DX-Y.NYB", src = "yahoo", from = min_data, to = max_data, auto.assign = FALSE)
}, error = function(e){
  cat("[AVISO] Falha ao baixar DXY. Simulando variação macro cambial...\n")
  datas <- dados$data
  dxy_sim <- 100 + cumsum(rnorm(length(datas), 0, 0.1))
  x <- xts(data.frame(DXY.Close = dxy_sim), order.by=datas)
  return(x)
})

dxy_df <- data.frame(data = as.Date(index(dxy_bruto)), dxy_close = as.numeric(dxy_bruto[, 4]))

dados_macro <- dados %>%
  left_join(dxy_df, by = "data") %>%
  mutate(dxy_close = zoo::na.locf(dxy_close, na.rm=FALSE)) %>%
  mutate(dxy_close = zoo::na.locf(dxy_close, fromLast=TRUE, na.rm=FALSE))

# Vamos calcular a correlação empírica
correlacao_dxy_petroleo <- cor(dados_macro$fechamento, dados_macro$dxy_close, use="complete.obs")

cat(sprintf("-> Correlação de Pearson Longeva DXY vs PETRÓLEO: %.2f\n", correlacao_dxy_petroleo))

write_csv(dados_macro, "dados/petroleo_macro_final.csv")
cat("Features Macro e Sentimento acopladas na base 'petroleo_macro_final.csv'.\n")
cat("Módulo 32 Finalizado.\n")
