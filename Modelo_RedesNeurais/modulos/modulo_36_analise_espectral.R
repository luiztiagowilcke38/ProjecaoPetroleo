# ==============================================================================
# MÓDULO 36: Análise Espectral (Transformada de Fourier - FFT)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 36: Análise Espectral via FFT...\n")

library(dplyr)
library(readr)
library(ggplot2)

dados <- read_csv("dados/petroleo_com_garch.csv", show_col_types = FALSE)

# Filtrar NAs no log-retorno
retornos <- na.omit(dados$log_retorno)

# Transformada Rápida de Fourier (FFT) no log-retorno do petróleo
# Isso mapeia do domínio do tempo para o domínio da freqüência
espectro <- fft(retornos)
n <- length(espectro)

# Cálculo da Densidade Espectral (Periodograma)
magnetudes <- Mod(espectro)
periodograma <- (magnetudes^2) / n

# Frequências
freq_range <- (0:(n-1)) / n

df_fft <- data.frame(
  Frequencia = freq_range[2:(n/2)], # Ignora freq 0 (média) e espelho de Nyquist
  Densidade = periodograma[2:(n/2)]
)

# Achar os picos (ciclos dominantes)
# O período (dias) = 1 / Frequencia
df_fft <- df_fft %>% mutate(Periodo_Dias = 1 / Frequencia)

# Plotando os ciclos mais relevantes
grafico_fft <- ggplot(df_fft, aes(x = Periodo_Dias, y = Densidade)) +
  geom_line(color="darkblue") +
  xlim(0, 252) + # Analisa ciclos de até 1 ano útil
  theme_minimal() +
  labs(
    title = "Periodograma (FFT) - Ciclos de Mercado do Petróleo",
    subtitle = "Domínio da Frequência para descobrir micro-sazonalidades ocultas",
    caption = "Autor: Luiz Tiago Wilcke",
    x = "Período (Dias)", y = "Densidade Espectral de Potência"
  )

ggsave("graficos/36_espectro_fft.png", grafico_fft, width = 10, height = 5)

cat("A análise de Fourier extraiu as frequências de ressonância do mercado petrolífero.\n")
cat("Módulo 36 Finalizado.\n")
