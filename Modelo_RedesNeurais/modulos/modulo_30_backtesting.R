# ==============================================================================
# MÓDULO 30: Backtesting das Previsões
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 30: Backtesting Histórico...\n")

library(dplyr)
library(readr)
library(ggplot2)

dados_teste <- read_csv("dados/dados_teste.csv", show_col_types = FALSE)
prev_ensemble <- read_csv("dados/previsoes_ensemble.csv", show_col_types = FALSE)

# Backtest financeiro básico: Hit Rate Direcional
# Quantas vezes o modelo acertou o SINAL do retorno? (Subida vs Descida)

df_backtest <- inner_join(dados_teste %>% select(data, target),
                          prev_ensemble %>% select(Data, Ensemble_Media),
                          by = c("data" = "Data"))

df_backtest <- df_backtest %>%
  mutate(
    sinal_real = sign(target),
    sinal_previsto = sign(Ensemble_Media),
    acerto_direcional = (sinal_real == sinal_previsto)
  )

hit_rate <- sum(df_backtest$acerto_direcional) / nrow(df_backtest)

cat(sprintf("\n[BACKTEST] Acurácia Direcional (Hit Rate): %.2f%%\n", hit_rate * 100))
# Acima de 50% é considerado ter um edge no mercado

# Curva de Capital (Equity Curve) teórica simples (ignora corretagem)
df_backtest <- df_backtest %>%
  mutate(
    retorno_estrategia = sinal_previsto * target, # Se previu subir e subiu, ganha. Se previu subir e desceu, perde.
    capital_acumulado = cumsum(retorno_estrategia)
  )

grafico_curva <- ggplot(df_backtest, aes(x = data)) +
  geom_line(aes(y = cumsum(target), color = "Buy and Hold"), size=1) +
  geom_line(aes(y = capital_acumulado, color = "Modelo de Rede Neural (Long/Short)"), size=1.2) +
  theme_minimal() +
  scale_color_manual(values=c("black", "darkgreen")) +
  labs(title = "Curva de Capital no Backtest Out-of-Sample",
       subtitle = sprintf("Acurácia Direcional (Hit Rate): %.2f%%", hit_rate*100),
       caption = "Autor: Luiz Tiago Wilcke",
       y = "Retorno Acumulado (Z)", x = "Data")

ggsave("graficos/30_backtesting_equity_curve.png", grafico_curva, width=10, height=6)

cat("Módulo 30 Finalizado.\n")
