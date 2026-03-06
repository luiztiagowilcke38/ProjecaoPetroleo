# ==============================================================================
# MÓDULO 02: Limpeza e Pré-processamento
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 02: Pré-processamento...\n")

library(dplyr)
library(readr)
library(lubridate)
library(tidyr)
library(zoo)

# 1. Carregar os dados brutos salvos no Módulo 01
caminho_dados <- "dados/petroleo_bruto.csv"

if(!file.exists(caminho_dados)) {
  stop("Erro: Arquivo petroleo_bruto.csv não encontrado. Execute o Módulo 01 primeiro.")
}

dados <- read_csv(caminho_dados, show_col_types = FALSE)

# 2. Verificar Valores Ausentes (NA) e Tratamento
cat("Valores ausentes antes do tratamento:\n")
print(colSums(is.na(dados)))

# Vamos preencher eventuais NA usando LOCF (Last Observation Carried Forward)
dados_preenchidos <- dados %>%
  arrange(data) %>%
  mutate(across(c(abertura, maxima, minima, fechamento, volume, ajustado), ~na.locf(., na.rm = FALSE)))

# Para NAs iniciais (se houver), usar NOCB (Next Observation Carried Backward)
dados_preenchidos <- dados_preenchidos %>%
  mutate(across(c(abertura, maxima, minima, fechamento, volume, ajustado), ~na.locf(., fromLast = TRUE, na.rm = FALSE)))

# 3. Engenharia de Features Básicas (Datas)
dados_processados <- dados_preenchidos %>%
  mutate(
    ano = year(data),
    mes = month(data),
    dia_semana = wday(data, label = TRUE, abbr = FALSE),
    trimestre = quarter(data)
  )

# Verificar se há volumes nulos ou negativos e corrigir
dados_processados <- dados_processados %>%
  mutate(volume = ifelse(volume <= 0 | is.na(volume), median(volume, na.rm=TRUE), volume))

cat("Valores ausentes APÓS tratamento:\n")
print(colSums(is.na(dados_processados)))

# Salvar dataset limpo
write_csv(dados_processados, "dados/petroleo_processado.csv")

cat("Dataset processado salvo em dados/petroleo_processado.csv\n")
cat("Módulo 02 Finalizado.\n")
