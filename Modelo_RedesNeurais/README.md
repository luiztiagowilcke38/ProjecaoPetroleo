# Modelo Estatístico de Previsão do Preço do Petróleo

**Autor**: Luiz Tiago Wilcke  
**Versão**: 1.0  
**Linguagem**: R  

## Descrição do Projeto

Este projeto consiste em um modelo estatístico e computacional avançado, estruturado em **40 módulos** distintos, com o objetivo de analisar e prever o preço do petróleo (focado na série WTI/Brent). O sistema utiliza uma abordagem profissional, englobando desde a coleta automatizada de dados financeiros e macroeconômicos até a aplicação de arquiteturas complexas de **Redes Neurais** (MLP, LSTM, GRU, CNN, Transformers e Ensembles) e modelos híbridos econométricos (GARCH, Cointegração).

Todas as variáveis, comentários e documentações estão em **Português**, garantindo clareza e padronização para equipes brasileiras de Ciência de Dados e Quantitativas.

## Estrutura de Diretórios

- `/dados/`: Armazena os datasets brutos e processados (ex: `petroleo_bruto.csv`).
- `/modulos/`: Contém os 40 scripts R (`modulo_01_*.R` a `modulo_40_*.R`), representando a pipeline completa do projeto.
- `/graficos/`: Destino de exportação para todas as visualizações dinâmicas e estáticas geradas ao longo da modelagem.
- `main.R`: Script orquestrador responsável por carregar o ambiente, instalar dependências e executar a pipeline sequencialmente.

## Arquitetura Matemática e Equações do Modelo

O projeto é calcado em rigor econométrico e avanços de deep learning. Algumas das equações centrais modeladas nos scripts incluem:

### 1. Transformação de Box-Cox e Log-Retorno
Para atingir a estacionaridade da variância, aplicamos o logaritmo natural na razão dos preços \( P \), garantindo que os retornos \( R_t \) espelhem o retorno contínuo:

$$ R_t = \ln\left(\frac{P_t}{P_{t-1}}\right) $$

### 2. Multi-Layer Perceptron (MLP)
Nos módulos básicos (12 e 13), dado o vetor de lags de entrada $X \in \mathbb{R}^{n}$, a saída $Y$ de uma camada oculta é computada via função de ativação ReLU ($f(x) = \max(0, x)$):

$$ H = f(W_1 X + b_1) $$

$$ \hat{Y} = W_2 H + b_2 $$

### 3. Long Short-Term Memory (LSTM)
No Módulo 14, as células LSTM mitigam o dissipamento de gradiente aprendendo fluxos lógicos de longo prazo. A equação da "Gated Forget Cell" é definida como:

$$ f_t = \sigma(W_f \cdot [h_{t-1}, x_t] + b_f) $$

E a atualização do estado da célula:

$$ C_t = f_t * C_{t-1} + i_t * \tilde{C}_t $$

### 4. Gated Recurrent Unit (GRU)
Mais eficiente em datasets menores, o Módulo 15 computa a porta de atualização $z_t$:

$$ z_t = \sigma(W_z \cdot [h_{t-1}, x_t] + b_z) $$

$$ h_t = (1 - z_t) * h_{t-1} + z_t * \tilde{h}_t $$

### 5. Mecanismo de Atenção (Attention Mechanism)
Implementado no Módulo 18, os pesos neurais se concentram temporalmente nos "picos de relevância", derivando os vetores *Query* ($Q$), *Key* ($K$) e *Value* ($V$):

$$ \text{Attention}(Q, K, V) = \text{softmax}\left(\frac{QK^T}{\sqrt{d_k}}\right)V $$

### 6. Volatilidade GARCH(1,1) Híbrida
Para compor as variâncias financeiras, usamos o clássico GARCH(1,1) incorporado (via feature proxy) na inteligência artificial:

$$ \sigma_t^2 = \omega + \alpha \epsilon_{t-1}^2 + \beta \sigma_{t-1}^2 $$

## Principais Tecnologias e Pacotes R
- **Modelagem Estatística/Econométrica**: `forecast`, `tseries`, `urca`, `rugarch`, `vars`
- **Redes Neurais e Machine Learning**: `keras`, `tensorflow`, `neuralnet`, `caret`, `randomForest`
- **Visualização**: `ggplot2`, `plotly`, `patchwork`, `ggcorrplot`
- **Relatórios**: `rmarkdown`, `shiny`

## Como Executar

Para rodar todo o modelo, basta executar o arquivo orquestrador na raiz do projeto:

```r
source("main.R")
```

A execução passará pelas seguintes fases principais:
1. **Módulos 1-10**: Coleta, Limpeza e Análise Exploratória (EDA).
2. **Módulos 11-20**: Divisão temporal e Treinamento de Redes Neurais (Deep Learning).
3. **Módulos 21-30**: Otimização, Validação e Previsão (Curto, Médio e Longo Prazos).
4. **Módulos 31-40**: Modelagem Híbrida, Macroeconomia, Explicabilidade (SHAP) e Dashboard.

## Autoria e Direitos

Desenvolvido por **Luiz Tiago Wilcke**.
Este projeto tem fins acadêmicos e profissionais voltados à pesquisa em Inteligência Artificial aplicada ao Mercado Financeiro.
