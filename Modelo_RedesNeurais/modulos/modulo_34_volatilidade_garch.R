# ==============================================================================
# MÓDULO 34: Volatilidade GARCH (Modelo Híbrido)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 34: Modelagem de Volatilidade GARCH(1,1)...\n")

library(dplyr)
library(readr)
library(rugarch)
library(ggplot2)

dados <- read_csv("dados/petroleo_macro_final.csv", show_col_types = FALSE)

# O GARCH(1,1) modela o "agrupamento de volatilidade" (volatility clustering)
# comum em finance (grandes variações seguidas de grandes, pequenas de pequenas)

retornos <- dados$log_retorno_tratado[!is.na(dados$log_retorno_tratado)]
datas <- dados$data[!is.na(dados$log_retorno_tratado)]

# Especificando GARCH(1,1) padrão com distribuição normal para a variância dos erros
especificacao <- ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
  mean.model = list(armaOrder = c(0, 0), include.mean = TRUE),
  distribution.model = "norm"
)

cat("Ajustando GARCH(1,1). Isso pode levar alguns segundos...\n")

ajuste_garch <- ugarchfit(spec = especificacao, data = retornos)

# Extrair a volatilidade condicional (Sigma) estimada
volatilidade_condicional <- sigma(ajuste_garch)

df_volat <- data.frame(Data = datas, Volatilidade_GARCH = as.numeric(volatilidade_condicional))

grafico_vol <- ggplot(df_volat, aes(x = Data, y = Volatilidade_GARCH)) +
  geom_line(color = "darkred") +
  theme_minimal() +
  labs(
    title = "Volatilidade Condicional GARCH(1,1)",
    subtitle = "Identificando períodos de estresse (Volatility Clustering)",
    caption = "Autor: Luiz Tiago Wilcke",
    x = "Data", y = "Sigma (Desvio Padrão Condicional)"
  )

ggsave("graficos/34_volatilidade_garch.png", grafico_vol, width = 10, height = 5)

# Integrar feature garch ao dataset para as Redes Híbridas futuras
dados_finais <- dados %>% left_join(df_volat, by=c("data"="Data"))
write_csv(dados_finais, "dados/petroleo_com_garch.csv")

cat("A volatilidade GARCH foi salva e enxertada como feature preditiva na base.\n")
cat("Módulo 34 Finalizado.\n")
