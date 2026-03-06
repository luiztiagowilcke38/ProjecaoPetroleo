# ==============================================================================
# MÓDULO 38: Explicabilidade (Identificação de Importância SHAP)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 38: Explicabilidade e Interpretabilidade do Modelo...\n")

library(dplyr)
library(readr)
library(randomForest)
library(ggplot2)
library(caret)

# Inteligência Artificial não deve ser caixa-preta.
# Usaremos o modelo_rf_otimizado do Módulo 21 que atua como proxy explicável do Ensemble
# para extrair a importância das features (SHAP proxy / Gini impurity map)

if(file.exists("dados/modelo_rf_otimizado.rds")) {
  modelo_rf <- readRDS("dados/modelo_rf_otimizado.rds")
  
  # Extraindo Importance
  # O caret model embute o forest object em $finalModel
  importancia <- varImp(modelo_rf, scale = TRUE)
  
  df_imp <- as.data.frame(importancia$importance)
  df_imp$Feature <- rownames(df_imp)
  colnames(df_imp)[1] <- "Importancia"
  
  # Ordenar
  df_imp <- df_imp %>% arrange(desc(Importancia)) %>% head(15)
  
  grafico_shap <- ggplot(df_imp, aes(x = reorder(Feature, Importancia), y = Importancia)) +
    geom_bar(stat="identity", fill="steelblue") +
    coord_flip() +
    theme_minimal() +
    labs(
      title = "Global Feature Importance (Proxy SHAP Values)",
      subtitle = "Quais lags/variáveis mais influenciam a decisão da Rede Neural?",
      caption = "Autor: Luiz Tiago Wilcke",
      x = "Variável / Lag Temporal", y = "Importância Relativa (Scaled)"
    )
  
  ggsave("graficos/38_importancia_variaveis_explicabilidade.png", grafico_shap, width = 8, height = 6)
  
  cat("Gráfico de Feature Importance renderizado.\n")
} else {
  cat("[AVISO] O modelo base RandomForest não foi encontrado na pasta dados/.\n")
}

cat("Módulo 38 Finalizado.\n")
