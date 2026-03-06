# ==============================================================================
# MÓDULO 33: Cointegração e Vector Error Correction (VECM)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 33: Testes de Cointegração (Johansen)...\n")

library(dplyr)
library(readr)
library(urca)

dados_macro <- read_csv("dados/petroleo_macro_final.csv", show_col_types = FALSE)

# Séries não estacionárias podem andar juntas a longo prazo (Cointegração)
# Testando entre Preço do Petróleo e o Dólar Index (DXY)
df_coint <- dados_macro %>% select(fechamento, dxy_close) %>% na.omit()
series_coint <- as.matrix(df_coint)

# Teste de Johansen
cat("Executando Teste Trace de Johansen...\n")
tryCatch({
  teste_johansen <- ca.jo(series_coint, type = "trace", ecdet = "const", K = 2)
  print(summary(teste_johansen))
  
  sink("dados/relatorio_cointegracao.txt")
  cat("=== Relatório de Cointegração (Autor: Luiz Tiago Wilcke) ===\n")
  cat("Variáveis: Petróleo (Série Real) e DXY (Dollas Index)\n\n")
  print(summary(teste_johansen))
  sink()
  
  cat("Relatório técnico de Cointegração e Autovetores salvo em dados/relatorio_cointegracao.txt\n")
}, error = function(e){
  cat("Erro na decomposição espectral ao calcular Johansen. Matrizes podem ser singulares.\n")
})

cat("A cointegração nos dita se no longo prazo, choques temporais se dissipam e a relação de equilíbrio é resgatada.\n")
cat("Módulo 33 Finalizado.\n")
