# ==============================================================================
# MÓDULO 25: Comparação Visual dos Modelos
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 25: Gráficos e Comparação de Desempenho...\n")

library(dplyr)
library(readr)
library(ggplot2)

if(file.exists("dados/metricas_agregadas.csv")){
  metricas <- read_csv("dados/metricas_agregadas.csv", show_col_types = FALSE)
  
  # Gráfico de barras RMSE
  grafico_rmse <- ggplot(metricas, aes(x = reorder(Modelo, RMSE), y = RMSE, fill = Modelo)) +
    geom_bar(stat = "identity", color = "black", alpha = 0.8) +
    coord_flip() +
    theme_minimal() +
    theme(legend.position = "none") +
    labs(
      title = "Comparação de Erro (RMSE) por Arquitetura",
      subtitle = "Quanto menor, melhor o desempenho preditivo.",
      x = "Módulo/Arquitetura de Rede",
      y = "RMSE em Escala Z-Score",
      caption = "Autor: Luiz Tiago Wilcke"
    )
  
  ggsave("graficos/25_comparacao_rmse.png", grafico_rmse, width = 8, height = 5)
  cat("Gráfico '25_comparacao_rmse.png' salvo com sucesso.\n")
  
} else {
  cat("[AVISO] Arquivo de métricas não encontrado.\n")
}

# Gráfico Linha do Tempo: Real vs Melhor Previsão (Ensemble)
ensemble <- read_csv("dados/previsoes_ensemble.csv", show_col_types = FALSE)

grafico_prev <- ggplot(ensemble) +
  geom_line(aes(x = Data, y = Target, color = "Real"), size = 0.8) +
  geom_line(aes(x = Data, y = Ensemble_Media, color = "Previsão (Ensemble)"), alpha = 0.8, linetype = "dashed") +
  theme_minimal() +
  scale_color_manual(values = c("Real" = "black", "Previsão (Ensemble)" = "red")) +
  labs(
    title = "Previsão de Log-Retornos no Conjunto de Teste",
    subtitle = "Avaliação Out-Of-Sample das Séries Temporais",
    x = "Data",
    y = "Log-Retorno Normalizado",
    color = "Legenda",
    caption = "Autor: Luiz Tiago Wilcke"
  )

ggsave("graficos/25_real_vs_previsao.png", grafico_prev, width = 10, height = 5)

cat("Módulo 25 Finalizado.\n")
