# ==============================================================================
# MÓDULO 05: Testes de Estacionaridade
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 05: Testes de Estacionaridade...\n")

library(dplyr)
library(readr)
library(tseries)
library(urca)

dados <- read_csv("dados/petroleo_decomposto.csv", show_col_types = FALSE)
serie_fechamento <- dados$fechamento

# 1. Teste Augmented Dickey-Fuller (ADF)
# Hipótese Nula (H0): A série tem raiz unitária (é não estacionária)
teste_adf <- adf.test(serie_fechamento, alternative = "stationary")

# 2. Teste KPSS (Kwiatkowski-Phillips-Schmidt-Shin)
# Hipótese Nula (H0): A série é estacionária
teste_kpss <- kpss.test(serie_fechamento, null = "Level")

# 3. Teste de Phillips-Perron (PP)
# Hipótese Nula (H0): A série tem raiz unitária
teste_pp <- pp.test(serie_fechamento)

# Consolidar Resultados
cat("\n--- RESULTADOS DOS TESTES DE ESTACIONARIDADE ---\n")
cat("Série Original (Petróleo Nível):\n\n")

cat(sprintf("1. Teste ADF: p-value = %.4f (H0: Não Estacionária)\n", teste_adf$p.value))
if(teste_adf$p.value < 0.05) { cat("   Conclusão ADF: Série ESTACIONÁRIA.\n") } else { cat("   Conclusão ADF: Série NÃO ESTACIONÁRIA.\n") }

cat(sprintf("\n2. Teste KPSS: p-value = %.4f (H0: Estacionária)\n", teste_kpss$p.value))
if(teste_kpss$p.value < 0.05) { cat("   Conclusão KPSS: Série NÃO ESTACIONÁRIA.\n") } else { cat("   Conclusão KPSS: Série ESTACIONÁRIA.\n") }

cat(sprintf("\n3. Teste PP: p-value = %.4f (H0: Não Estacionária)\n", teste_pp$p.value))
if(teste_pp$p.value < 0.05) { cat("   Conclusão PP: Série ESTACIONÁRIA.\n") } else { cat("   Conclusão PP: Série NÃO ESTACIONÁRIA.\n") }

cat("\nNota: Em séries de preços de ativos, tipicamente o nível não é estacionário. Isso será tratado no próximo módulo com diferenciação.\n")

# Salvar relatório estático de resultado do teste
sink("dados/relatorio_estacionaridade.txt")
cat("Relatório de Testes de Raiz Unitária - Autor: Luiz Tiago Wilcke\n")
cat(sprintf("ADF p-value: %f\n", teste_adf$p.value))
cat(sprintf("KPSS p-value: %f\n", teste_kpss$p.value))
cat(sprintf("PP p-value: %f\n", teste_pp$p.value))
sink()

cat("Módulo 05 Finalizado.\n")
