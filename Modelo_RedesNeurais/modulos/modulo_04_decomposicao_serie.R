# ==============================================================================
# MÓDULO 04: Decomposição de Série Temporal
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 04: Decomposição da Série...\n")

library(dplyr)
library(readr)
library(forecast)
library(ggplot2)

dados <- read_csv("dados/petroleo_processado.csv", show_col_types = FALSE)

# Converter a coluna de fechamento para objeto de série temporal (ts)
# Assumindo frequência de dias úteis aproximados no ano financeiro (252 dias)
dados_ts <- ts(dados$fechamento, frequency = 252)

# Decomposição STL (Seasonal and Trend decomposition using Loess)
decomposicao_stl <- stl(dados_ts, s.window = "periodic")

# Extrair componentes
tendencia <- decomposicao_stl$time.series[, "trend"]
sazonalidade <- decomposicao_stl$time.series[, "seasonal"]
residuos <- decomposicao_stl$time.series[, "remainder"]

cat("Gerando gráfico da decomposição STL...\n")

# Gráfico da Decomposição Completa
pdf("graficos/04_decomposicao_stl.pdf", width=10, height=8)
plot(decomposicao_stl, main = "Decomposição STL do Preço do Petróleo (Autor: Luiz Tiago Wilcke)")
dev.off()

# Salvar os componentes no dataframe original
dados$tendencia <- as.numeric(tendencia)
dados$sazonalidade <- as.numeric(sazonalidade)
dados$residuos_stl <- as.numeric(residuos)

# Salvar dataset enriquecido
caminho_salvamento <- "dados/petroleo_decomposto.csv"
write_csv(dados, caminho_salvamento)

cat(sprintf("Série decomposta. Componentes adicionados a %s\n", caminho_salvamento))
cat("Módulo 04 Finalizado.\n")
