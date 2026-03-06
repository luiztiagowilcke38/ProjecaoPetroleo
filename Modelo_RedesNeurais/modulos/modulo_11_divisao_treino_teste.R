# ==============================================================================
# MÓDULO 11: Divisão Treino, Validação e Teste
# AUTOR: Luiz Tiago Wilcke
# ==============================================================================

cat("Iniciando Módulo 11: Divisão de Dados temporal...\n")

library(dplyr)
library(readr)

dados <- read_csv("dados/dataset_matriz_janelas.csv", show_col_types = FALSE)

# Para séries temporais, não usamos sample() aleatório para não causar data leakage
# Usamos split cronológico.
# Proporção típica em finanças: 70% Treino, 15% Validação, 15% Teste

n_total <- nrow(dados)
idx_treino <- floor(0.70 * n_total)
idx_val <- floor(0.85 * n_total)

treino <- dados[1:idx_treino, ]
validacao <- dados[(idx_treino + 1):idx_val, ]
teste <- dados[(idx_val + 1):n_total, ]

cat(sprintf("Total de Amostras: %d\n", n_total))
cat(sprintf("Treino: %d (%.1f%%) | De %s a %s\n", nrow(treino), nrow(treino)/n_total*100, min(treino$data), max(treino$data)))
cat(sprintf("Validação: %d (%.1f%%) | De %s a %s\n", nrow(validacao), nrow(validacao)/n_total*100, min(validacao$data), max(validacao$data)))
cat(sprintf("Teste: %d (%.1f%%) | De %s a %s\n", nrow(teste), nrow(teste)/n_total*100, min(teste$data), max(teste$data)))

write_csv(treino, "dados/dados_treino.csv")
write_csv(validacao, "dados/dados_validacao.csv")
write_csv(teste, "dados/dados_teste.csv")

cat("Divisão concluída e arquivos salvos separadamente.\n")
cat("Módulo 11 Finalizado.\n")
