# ==============================================================================
# MÓDULO 23: Validação Cruzada (Walk-Forward para Séries Temporais)
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 23: Time Series Cross-Validation (Walk Forward)...\n")

library(dplyr)
library(readr)
library(forecast)

# Validação cruzada genérica não funciona em séries temporais pois embaralha o tempo.
# Usamos a técnica de janela de previsão móvel (Rolling Origin)

dados <- read_csv("dados/petroleo_diferenciado.csv", show_col_types = FALSE)
serie_alvo <- ts(dados$log_retorno)

# Função personalizada genérica para Walk-Forward de modelo ARIMA clássico (Baseline Econômetrico)
# Retorna o MAE médio da validação m-step ahead
cat("Rodando valiação cruzada seqüencial num auto.arima Baseline...\n")

# Para evitar lentidão severa, usamos uma amostra dos últimos 200 períodos
serie_corte <- tail(serie_alvo, 200)

avalia_cv_ts <- function(y, modelo = auto.arima, h = 1) {
  farima <- function(x, h){forecast(modelo(x), h=h)}
  # Calcula erros tsCV do forecast pacote (TimeSeriesCrossValidation)
  e <- tsCV(y, farima, h = h)
  
  # Calcula RMSE
  rmse <- sqrt(mean(e^2, na.rm=TRUE))
  return(rmse)
}

tryCatch({
  erro_cv_1step <- avalia_cv_ts(serie_corte, h = 1)
  cat(sprintf("RMSE Walk-Forward (1 dia à frente) via ARIMA: %.4f\n", erro_cv_1step))
}, error=function(e){
  cat("CV abortado devida formatação local da série no forecast.\n")
})

cat("A arquitetura Keras já usou Validation Split cronológico internamente nas Módulos anteriores.\n")
cat("Módulo 23 Finalizado.\n")
