# ==============================================================================
# MÓDULO 03: Análise Exploratória de Dados (EDA)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 03: Análise Exploratória...\n")

library(dplyr)
library(readr)
library(ggplot2)
library(plotly)

# Carregar dados processados
dados <- read_csv("dados/petroleo_processado.csv", show_col_types = FALSE)

# 1. Estatísticas Descritivas
cat("Resumo Estatístico do Preço de Fechamento do Petróleo:\n")
resumo <- summary(dados$fechamento)
print(resumo)

# Calcular desvio padrão e variância
desvio_padrao <- sd(dados$fechamento)
variancia <- var(dados$fechamento)
cat(sprintf("Desvio Padrão: %.2f | Variância: %.2f\n", desvio_padrao, variancia))

# 2. Gráficos Exploratórios usando ggplot2

# Gráfico 1: Linha do tempo dos preços de fechamento
grafico_linha <- ggplot(dados, aes(x = data, y = fechamento)) +
  geom_line(color = "darkblue", size = 0.8) +
  theme_minimal() +
  labs(
    title = "Evolução do Preço do Petróleo (Fechamento)",
    subtitle = "Série Histórica Diária",
    x = "Data",
    y = "Preço (USD)",
    caption = "Autor: Luiz Tiago Wilcke"
  )

ggsave("graficos/03_linha_tempo_preco.png", grafico_linha, width = 10, height = 6)

# Gráfico 2: Histograma de distribuição dos preços
grafico_hist <- ggplot(dados, aes(x = fechamento)) +
  geom_histogram(fill = "steelblue", color = "white", bins = 50, alpha = 0.8) +
  theme_minimal() +
  labs(
    title = "Distribuição de Frequência dos Preços do Petróleo",
    x = "Preço de Fechamento (USD)",
    y = "Frequência",
    caption = "Autor: Luiz Tiago Wilcke"
  )

ggsave("graficos/03_histograma_precos.png", grafico_hist, width = 8, height = 6)

# Gráfico 3: Boxplot por Ano (Identificação visual de volatilidade)
dados_boxplot <- dados %>% mutate(ano_fator = as.factor(ano))

grafico_box <- ggplot(dados_boxplot, aes(x = ano_fator, y = fechamento, fill = ano_fator)) +
  geom_boxplot(alpha = 0.7) +
  theme_minimal() +
  theme(legend.position = "none") +
  labs(
    title = "Boxplot dos Preços do Petróleo por Ano",
    x = "Ano",
    y = "Preço (USD)",
    caption = "Autor: Luiz Tiago Wilcke"
  )

ggsave("graficos/03_boxplot_anual.png", grafico_box, width = 10, height = 6)

cat("Gráficos exploratórios gerados e salvos na pasta 'graficos/'.\n")
cat("Módulo 03 Finalizado.\n")
