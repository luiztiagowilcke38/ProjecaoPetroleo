# ==============================================================================
# MÓDULO 35: Detecção de Quebras Estruturais (Structural Breaks)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 35: Detecção de Quebras Estruturais...\n")

library(dplyr)
library(readr)
library(strucchange)
library(ggplot2)

dados <- read_csv("dados/petroleo_com_garch.csv", show_col_types = FALSE)

# Quebras estruturais podem destruir as previsões das NNs se não tratadas.
# Usamos o Teste de Chow (strucchange via F-statistics) ou Bai-Perron

ts_preco <- ts(dados$fechamento)

# Calcula o F-statistics para as potenciais quebras ao longo do tempo (F-Test suprimindo as pontas)
cat("Calculando quebras (Bai-Perron / F-Stats)...\n")
quebras <- breakpoints(ts_preco ~ 1, breaks = 3) # Buscando até 3 grandes choques (Ex: COVID, Guerra)

pontos <- quebras$breakpoints
datas_quebras <- dados$data[pontos]

df_plot <- data.frame(Data = dados$data, Preco = dados$fechamento)

grafico_breaks <- ggplot(df_plot, aes(x = Data, y = Preco)) +
  geom_line(color="black") +
  geom_vline(xintercept = as.numeric(datas_quebras), color="red", linetype="dashed", size=1) +
  theme_minimal() +
  labs(
    title = "Detecção de Quebras Estruturais (Structural Breaks)",
    subtitle = paste("Choques de Regime Detectados em:", paste(datas_quebras, collapse=", ")),
    caption = "Autor: Luiz Tiago Wilcke",
    x = "Data", y = "Preço do Petróleo"
  )

ggsave("graficos/35_quebras_estruturais.png", grafico_breaks, width=10, height=5)

cat(sprintf("Detectadas %d quebras estruturais no regime de preço.\n", length(pontos)))
cat("Módulo 35 Finalizado.\n")
