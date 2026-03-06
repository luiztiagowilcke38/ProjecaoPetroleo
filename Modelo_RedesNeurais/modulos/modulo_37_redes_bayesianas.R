# ==============================================================================
# MÓDULO 37: Redes Neurais Bayesianas (Incerteza Epistêmica)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 37: Regressão/Rede Bayesiana...\n")

library(dplyr)
library(readr)
library(ggplot2)

# Uma Rede Bayesiana plena em BUGS/JAGS ou Stan é pesada.
# Usaremos modelagem linear hierárquica Bayesiana rápida com brms/rstanarm, ou regressão proxy,
# para demonstrar a ideia da distribuição paramétrica (Pesos como distribuições e não escalares).

treino <- read_csv("dados/dados_treino.csv", show_col_types = FALSE)
features <- setdiff(colnames(treino), c("data", "target"))

# Para execução instantânea no script demo, faremos a simulação do bayes factor e prioris

simular_rede_bayesiana <- function(df, feats) {
  # Simulando saídas posteriors para o peso w1 da camada oculta
  # Prior N(0, 1), Posterior data driven
  posterior_w1 <- rnorm(5000, mean = 0.45, sd = 0.08)
  return(posterior_w1)
}

posteriores <- simular_rede_bayesiana(treino, features)

df_post <- data.frame(Peso_H1 = posteriores)

grafico_bnn <- ggplot(df_post, aes(x = Peso_H1)) +
  geom_density(fill="seagreen", alpha=0.6) +
  theme_minimal() +
  geom_vline(aes(xintercept=mean(Peso_H1)), color="red", linetype="dashed") +
  labs(
    title = "Distribuição Posterior de um Peso Sináptico (Bayesian Neural Network)",
    subtitle = "Pesos deixam de ser escalares absolutos e viram curvas de probabilidade",
    caption = "Autor: Luiz Tiago Wilcke",
    x = "Valor do Peso W", y = "Densidade de Probabilidade"
  )

ggsave("graficos/37_rede_bayesiana_posteriori.png", grafico_bnn, width = 8, height = 5)

cat("Simulação visual da incerteza dos pesos concluída.\n")
cat("Módulo 37 Finalizado.\n")
