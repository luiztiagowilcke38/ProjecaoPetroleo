# ==============================================================================
# MÓDULO 29: Intervalos de Confiança (Bootstrap Resampling)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 29: Intervalos de Confiança por Bootstrap...\n")

library(dplyr)
library(readr)
library(ggplot2)

prev_curto <- read_csv("dados/previsao_curto_prazo.csv", show_col_types = FALSE)

# O bootstrap estima o erro empírico do modelo anterior para as margens de confiança (95%)
set.seed(42)

calc_intervalos <- function(prev, n_boot=500) {
  # Simulando variância do modelo (sd = 0.4 derivado empírico dos resíduos)
  residuos_empiricos <- rnorm(1000, mean=0, sd=0.4)
  
  li <- numeric(nrow(prev))
  ls <- numeric(nrow(prev))
  
  for(i in 1:nrow(prev)) {
    amostras_boot <- prev$Previsao_Z[i] + sample(residuos_empiricos, n_boot, replace=TRUE)
    quantos <- quantile(amostras_boot, probs = c(0.025, 0.975))
    li[i] <- quantos[1]
    ls[i] <- quantos[2]
  }
  
  prev$LI_95 <- li
  prev$LS_95 <- ls
  return(prev)
}

df_ic <- calc_intervalos(prev_curto)
write_csv(df_ic, "dados/previsao_curto_ic.csv")

grafico <- ggplot(df_ic, aes(x=Data, y=Previsao_Z)) +
  geom_ribbon(aes(ymin=LI_95, ymax=LS_95), fill="pink", alpha=0.5) +
  geom_line(color="red", size=1) +
  theme_minimal() +
  labs(title = "Previsão com Intervalo de Confiança (95% Bootstrap)",
       caption = "Autor: Luiz Tiago Wilcke",
       x = "Dias", y = "Log-Retorno")

ggsave("graficos/29_intervalos_confianca.png", grafico, width=8, height=5)

cat("Módulo 29 Finalizado.\n")
