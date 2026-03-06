# ==============================================================================
# MÓDULO 27: Previsão de Médio Prazo (30 dias)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 27: Previsão de Médio Prazo (30 dias)...\n")

library(dplyr)
library(readr)
library(ggplot2)

dados_teste <- read_csv("dados/dados_teste.csv", show_col_types = FALSE)
historico <- tail(dados_teste$target, 10)

prever_medio_prazo <- function(hist, dias=30) {
  set.seed(42)
  previsoes <- numeric(dias)
  atual <- hist[length(hist)]
  
  for(i in 1:dias) {
    # Mais ruído acumulado e mean-reversion para o médio prazo
    prox <- (atual * 0.3) + rnorm(1, mean=0, sd=0.3)
    previsoes[i] <- prox
    atual <- prox
  }
  return(previsoes)
}

prev_30_dias <- prever_medio_prazo(historico, dias=30)
datas_futuras <- seq(max(dados_teste$data) + 1, by = "day", length.out = 30)

df_medio <- data.frame(Data = datas_futuras, Previsao_Z = prev_30_dias)
write_csv(df_medio, "dados/previsao_medio_prazo.csv")

grafico <- ggplot(df_medio, aes(x = Data, y = Previsao_Z)) +
  geom_line(color = "purple", size = 1) +
  theme_minimal() +
  labs(title = "Previsão Médio Prazo (30 dias) - Interpolação",
       caption = "Autor: Luiz Tiago Wilcke",
       x = "Dias Futuros", y = "Log-Retorno Previsto Z")

ggsave("graficos/27_previsao_medio_prazo.png", grafico, width=10, height=4)

cat("Módulo 27 Finalizado.\n")
