# ==============================================================================
# MÓDULO 07: Correlação e Correlograma (ACF/PACF)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 07: Análise de Correlação...\n")

library(dplyr)
library(readr)
library(ggplot2)
library(ggcorrplot)
library(forecast)

dados <- read_csv("dados/petroleo_diferenciado.csv", show_col_types = FALSE)

# 1. Matriz de Correlação das Variáveis Numéricas
vars_numericas <- dados %>% dplyr::select(abertura, maxima, minima, fechamento, volume, ajustado)
matriz_correlacao <- cor(vars_numericas, use = "complete.obs", method = "pearson")

grafico_corr <- ggcorrplot(matriz_correlacao, hc.order = TRUE, type = "lower",
                           lab = TRUE, lab_size = 4, method = "circle",
                           colors = c("red", "white", "blue"),
                           title = "Matriz de Correlação - Variáveis do Petróleo",
                           ggtheme = theme_minimal())

ggsave("graficos/07_matriz_correlacao.png", grafico_corr, width = 8, height = 8)

# 2. ACF e PACF da série de Log-Retorno (importante para AR/MA e janelas deslizantes)
log_retornos <- ts(dados$log_retorno)

# Autocorrelação (ACF)
pdf("graficos/07_acf_pacf.pdf", width=10, height=6)
par(mfrow=c(1,2))
Acf(log_retornos, main = "Função de Autocorrelação (ACF) - Retornos", lag.max = 30)
Pacf(log_retornos, main = "Autocorrelação Parcial (PACF) - Retornos", lag.max = 30)
dev.off()

cat("Gráficos de correlação, ACF e PACF salvos em 'graficos/'.\n")
cat("Módulo 07 Finalizado.\n")
