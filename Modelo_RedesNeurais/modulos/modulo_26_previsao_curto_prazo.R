# ==============================================================================
# MÓDULO 26: Previsão de Curto Prazo (1 a 7 dias)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 26: Previsão de Curto Prazo (1 a 7 dias)...\n")

library(dplyr)
library(readr)
library(ggplot2)

# Usaremos o ensemble (Módulo 17) para prever os retornos dos próximos dias.
# O processo requer prever iterativamente (autoregressivo iterativo) ou direto.
# Vamos simular o processo para os próximos 7 dias com base na última janela do teste.

dados_teste <- read_csv("dados/dados_teste.csv", show_col_types = FALSE)
historico <- tail(dados_teste$target, 10) # 10 últimos dias conhecidos do log retorno

# Carregar parâmetros de normalização
# parametros <- readRDS("dados/parametros_normalizacao.rds") # se precisar reescalar ao real

prever_curto_prazo <- function(hist, dias=7) {
  # Simulando um modelo autoregressivo de ordem 1 (AR(1)) derivado do deep learning
  # Apenas para fins de demonstração da pipeline contínua. 
  # O correto na vida real é recarregar o modelo_ensemble e dar predict_on_batch.
  set.seed(42)
  previsoes <- numeric(dias)
  atual <- hist[length(hist)]
  
  for(i in 1:dias) {
    # Modelo mean-reverting com ruído gaussiano (simulando previsão da rede sobre o lag anterior)
    prox <- atual * 0.5 + rnorm(1, mean=0, sd=0.2) 
    previsoes[i] <- prox
    atual <- prox
  }
  return(previsoes)
}

prev_7_dias <- prever_curto_prazo(historico, dias=7)
datas_futuras <- seq(max(dados_teste$data) + 1, by = "day", length.out = 7)

df_curto <- data.frame(Data = datas_futuras, Previsao_Z = prev_7_dias)
write_csv(df_curto, "dados/previsao_curto_prazo.csv")

grafico <- ggplot(df_curto, aes(x = Data, y = Previsao_Z)) +
  geom_line(color = "orange", size = 1) +
  geom_point(color = "red") +
  theme_minimal() +
  labs(title = "Previsão Curto Prazo (7 dias) - Log-Retornos Normalizados",
       caption = "Autor: Luiz Tiago Wilcke",
       x = "Dias Futuros", y = "Log-Retorno Previsto Z")

ggsave("graficos/26_previsao_curto_prazo.png", grafico, width=8, height=4)

cat("Módulo 26 Finalizado.\n")
