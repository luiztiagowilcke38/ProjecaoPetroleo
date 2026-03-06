# ==============================================================================
# MÓDULO 28: Previsão de Longo Prazo (90 a 180 dias)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 28: Previsão de Longo Prazo (180 dias)...\n")

library(dplyr)
library(readr)
library(ggplot2)

dados_teste <- read_csv("dados/dados_teste.csv", show_col_types = FALSE)
historico <- tail(dados_teste$target, 10)

# Para longo prazo em redes neurais de séries financeiras, as incertezas são brutais.
# Utilizaremos um Monte Carlo Path Simulation acoplado com drift (tendência histórica).

prever_longo_prazo_mc <- function(dias = 180, n_simulacoes = 100) {
  set.seed(42)
  
  # CENÁRIO MACROECOLÍTICO 2026: Guerra EUA e Israel contra o Irã
  # Prêmio de risco geopolítico (War Risk Premium) por disrupção no Estreito de Ormuz.
  
  drift_historico <- mean(dados_teste$target, na.rm=TRUE)
  
  # Drift de choque positivo altíssimo (prêmio de risco de guerra aguda no Oriente Médio)
  drift_guerra_2026 <- 0.008 # Choque altista fortíssimo no log-retorno diário
  drift_total <- drift_historico + drift_guerra_2026
  
  volatilidade <- sd(dados_teste$target, na.rm=TRUE) * 2.5 # Guerra aumenta a volatilidade brutalmente
  
  caminhos_log_ret <- matrix(0, nrow = dias, ncol = n_simulacoes)
  
  # Vamos ler os dados originais brutos para ancorar o ÚLTIMO PREÇO ABSOLUTO REAL
  dados_brutos <- read_csv("dados/petroleo_bruto.csv", show_col_types = FALSE)
  ultimo_preco_real <- tail(dados_brutos$fechamento, 1)
  
  caminhos_preco <- matrix(0, nrow = dias, ncol = n_simulacoes)
  
  for(s in 1:n_simulacoes) {
    preco_atual <- ultimo_preco_real
    
    for(i in 1:dias) {
      # 1. Simula o próximo preço diretamente (Random Walk com drift em USD absolutps)
      # O choque de guerra equivale a adicionar algo entre $0 e $0.50 cents por dia em média no pior dos casos
      drift_absoluto <- 0.25 # Média de avanço por barril ao dia na guerra
      volatilidade_absoluta <- 1.5 # Volatilidade do preço em USD
      
      prox_preco <- preco_atual + drift_absoluto + rnorm(1, mean=0, sd=volatilidade_absoluta)
      
      caminhos_preco[i, s] <- prox_preco
      preco_atual <- prox_preco
    }
  }
  
  media_caminhos_preco <- rowMeans(caminhos_preco)
  return(list(media = media_caminhos_preco, matriz_mc = caminhos_preco))
}

mc_result <- prever_longo_prazo_mc()
datas_futuras <- seq(max(dados_teste$data) + 1, by = "day", length.out = 180)

df_longo <- data.frame(Data = datas_futuras, Previsao_Preco = mc_result$media)
write_csv(df_longo, "dados/previsao_longo_prazo_absoluto.csv")

# Grafico das trilhas Monte Carlo vs Média
df_matriz <- as.data.frame(mc_result$matriz_mc)
df_matriz$Data <- datas_futuras

library(tidyr)
df_matriz_long <- df_matriz %>% pivot_longer(cols = -Data, names_to = "Simulacao", values_to = "Previsao_Preco")

grafico <- ggplot() +
  geom_line(data=df_matriz_long, aes(x=Data, y=Previsao_Preco, group=Simulacao), color="gray", alpha=0.1) +
  geom_line(data=df_longo, aes(x=Data, y=Previsao_Preco), color="blue", size=1.2) +
  theme_minimal() +
  labs(title = "Previsão Longo Prazo (180 dias) - Cenário Choque de Guerra (Irã)",
       subtitle = "Simulação Monte Carlo Convertida para Preços Absolutos (Base > $92)",
       caption = "Autor: Luiz Tiago Wilcke",
       x = "Dias Futuros", y = "Preço USD/Barril")

ggsave("graficos/28_previsao_longo_prazo.png", grafico, width=12, height=6)

cat("Módulo 28 Finalizado.\n")
