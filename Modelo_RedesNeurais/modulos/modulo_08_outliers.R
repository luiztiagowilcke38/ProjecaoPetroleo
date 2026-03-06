# ==============================================================================
# MÓDULO 08: Detecção e Tratamento de Outliers
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 08: Tratamento de Outliers...\n")

library(dplyr)
library(readr)
library(ggplot2)

dados <- read_csv("dados/petroleo_diferenciado.csv", show_col_types = FALSE)

# Vamos tratar outliers nos log_retornos usando Interquartile Range (IQR) e Z-Score
# Como trabalhamos com finanças, outliers agressivos podem estourar neurônios na rede,
# adotamos Winsorization para substituí-los por valores no limite.

tratar_outliers <- function(vetor, limite_z = 3) {
  media <- mean(vetor, na.rm = TRUE)
  desvio <- sd(vetor, na.rm = TRUE)
  
  # Limites
  z_scores <- (vetor - media) / desvio
  
  vetor_tratado <- ifelse(z_scores > limite_z, media + limite_z * desvio, vetor)
  vetor_tratado <- ifelse(z_scores < -limite_z, media - limite_z * desvio, vetor_tratado)
  
  return(vetor_tratado)
}

dados$log_retorno_tratado <- tratar_outliers(dados$log_retorno, limite_z = 3)

# Visualização do impacto do tratamento
df_plot <- data.frame(
  Data = dados$data,
  Original = dados$log_retorno,
  Tratado = dados$log_retorno_tratado
)

grafico_outlier <- ggplot(df_plot) +
  geom_point(aes(x = Data, y = Original), color = "red", alpha = 0.5, size = 1) +
  geom_line(aes(x = Data, y = Tratado), color = "blue", alpha = 0.7) +
  theme_minimal() +
  labs(
    title = "Tratamento de Outliers nos Log-Retornos (Winsorization a 3 Z-Scores)",
    subtitle = "Vermelho: Original | Azul: Tratado",
    x = "Data",
    y = "Log-Retorno",
    caption = "Autor: Luiz Tiago Wilcke"
  )

ggsave("graficos/08_tratamento_outliers.png", grafico_outlier, width = 10, height = 5)

write_csv(dados, "dados/petroleo_sem_outliers.csv")
cat("Outliers tratados via Winsorization. Dataset salvo.\n")
cat("Módulo 08 Finalizado.\n")
