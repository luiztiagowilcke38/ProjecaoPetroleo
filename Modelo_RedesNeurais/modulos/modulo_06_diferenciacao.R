# ==============================================================================
# MÓDULO 06: Diferenciação e Transformações
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 06: Diferenciação e Retornos...\n")

library(dplyr)
library(readr)
library(ggplot2)

dados <- read_csv("dados/petroleo_decomposto.csv", show_col_types = FALSE)

# 1. Primeira Diferença Absoluta (Preço t - Preço t-1)
dados$dif_1 <- c(NA, diff(dados$fechamento, differences = 1))

# 2. Retornos Simples
dados$retorno_simples <- (dados$fechamento / lag(dados$fechamento, 1)) - 1

# 3. Log-Retornos (Usado como target na maioria das redes neurais deste projeto)
dados$log_retorno <- log(dados$fechamento / lag(dados$fechamento, 1))

# Remover a primeira linha que ficou com NA devido ao lag
dados_apto <- dados %>% filter(!is.na(log_retorno))

# Verificando a estacionaridade do log-retorno visualmente
grafico_retorno <- ggplot(dados_apto, aes(x = data, y = log_retorno)) +
  geom_line(color = "darkred") +
  theme_minimal() +
  labs(
    title = "Log-Retornos Diários do Petróleo",
    subtitle = "Transformação para atingir estacionaridade na variância e na média",
    x = "Data",
    y = "Log-Retorno",
    caption = "Autor: Luiz Tiago Wilcke"
  )

ggsave("graficos/06_log_retornos.png", grafico_retorno, width = 10, height = 5)

# O log-retorno é praticamente simétrico e tipicamente passa no teste ADF (comprovando a estacionaridade)
library(tseries)
teste_adf_ret <- adf.test(dados_apto$log_retorno, alternative = "stationary")
cat(sprintf("\nTeste ADF no Log-Retorno. p-value: %f\n", teste_adf_ret$p.value))
if(teste_adf_ret$p.value < 0.05) { 
  cat("--> O Log-Retorno é considerado ESTACIONÁRIO.\n") 
}

write_csv(dados_apto, "dados/petroleo_diferenciado.csv")
cat(sprintf("Dataset diferenciado salvo em 'dados/petroleo_diferenciado.csv' com %d linhas limpas.\n", nrow(dados_apto)))
cat("Módulo 06 Finalizado.\n")
