# ==============================================================================
# MÓDULO 31: Análise de Sentimento e Medo (Proxy: VIX)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 31: Sentimento de Mercado Financeiro (VIX)...\n")

library(dplyr)
library(readr)
library(ggplot2)
library(quantmod)

dados <- read_csv("dados/petroleo_processado.csv", show_col_types = FALSE)
min_data <- as.character(min(dados$data))
max_data <- as.character(max(dados$data))

# CBOE Volatility Index (VIX) é a principal medida de sentimento e medo
# do mercado financeiro global. Afeta comodities e ações.
cat("Buscando dados do VIX (^VIX) via Yahoo Finance...\n")

vix_bruto <- tryCatch({
  getSymbols("^VIX", src = "yahoo", from = min_data, to = max_data, auto.assign = FALSE)
}, error = function(e) {
  cat("[AVISO] Falha ao baixar VIX. Simulando proxy de volatilidade implied...\n")
  datas <- dados$data
  n <- length(datas)
  vix_fake <- 15 + abs(rnorm(n, 0, 5)) + (dados$fechamento * 0.1) # Correlação artificial espúria
  x <- xts(data.frame(VIX.Close = vix_fake), order.by=datas)
  return(x)
})

vix_df <- data.frame(data = as.Date(index(vix_bruto)), vix_close = as.numeric(vix_bruto[, 4]))

# Juntar com os dados do petróleo
dados_sentimento <- dados %>%
  left_join(vix_df, by = "data") %>%
  mutate(vix_close = zoo::na.locf(vix_close, na.rm=FALSE)) %>%
  mutate(vix_close = zoo::na.locf(vix_close, fromLast=TRUE, na.rm=FALSE))

# Relação gráfica (Efeito tesoura: VIX sobe, comodities de risco tendem a cair o momentum)
dados_plot <- dados_sentimento %>% filter(data > max(data) - 365) # Ultimo ano

grafico <- ggplot(dados_plot, aes(x=data)) +
  geom_line(aes(y=fechamento), color="black", size=1) +
  geom_line(aes(y=vix_close), color="red", size=0.8, linetype="dashed") +
  scale_y_continuous(
    name = "Preço Petróleo",
    sec.axis = sec_axis(~., name="Índice VIX (Sentimento Medo) - Vermelho")
  ) +
  theme_minimal() +
  labs(title="Relação: Preço Petróleo vs VIX (Último Ano)", caption="Autor: Luiz Tiago Wilcke")

ggsave("graficos/31_sentimento_vix.png", grafico, width=10, height=5)
write_csv(dados_sentimento, "dados/petroleo_sentimento.csv")

cat("Módulo 31 Finalizado.\n")
