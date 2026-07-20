# Roadmap: Estudante de Economia → Economista Tecnológico

## Semana 1-2: Python básico

### O que aprender
- Variáveis, tipos (int, float, string, bool)
- Listas e dicionários
- Condicionais (if/else)
- Loops (for, while)
- Funções

### Recursos
- [Python para Economistas - QuantEcon](https://quantecon.org/python-training/)
- [Automate the Boring Stuff](https://automatetheboringstuff.com/) — gratuito

### Prática
- Calcular inflação acumulada manualmente
- Simular juros compostos
- Criar função que calcula PIB per capita

---

## Semana 3-4: pandas + dados reais

### O que aprender
- Ler CSV/Excel com pandas
- Filtrar, ordenar, agrupar dados
- Juntar tabelas (merge)
- Estatísticas descritivas

### Acesso a dados
- **BCB SGS** — IPCA, SELIC, câmbio, PIB (via `python-bcb`)
- **Ipeadata** — séries históricas brasileiras
- **Banco Mundial** — WDI (World Development Indicators)
- **FMI** — IMF Data

### Projetos
1. Baixar IPCA mensal desde 1994 e plotar
2. Comparar PIB per capita Brasil vs Argentina (WDI)
3. Criar tabela com média, mediana, min, max do PIB dos BRICS

---

## Semana 5-6: Visualização de dados

### O que aprender
- matplotlib: gráficos de linha, barra, dispersão
- seaborn: heatmaps, boxplots, pairplots
- Personalizar: cores, legendas, títulos, anotações

### Projetos
1. Gráfico da inflação brasileira com marcações de planos econômicos
2. Boxplot da distribuição de renda por região
3. Scatter plot: PIB per capita x Expectativa de vida (100+ países)

---

## Semana 7-8: Econometria básica

### O que aprender
- Regressão linear com `statsmodels`
- Interpretação de coeficientes, R², p-valor
- Testes de hipótese

### Projetos
1. Regredir consumo x renda (dados do BCB)
2. Curva de Phillips: inflação x desemprego
3. Modelo de Mincer: salário x escolaridade (PNAD)

---

## Mês 3-4: Séries temporais

### O que aprender
- Estacionariedade, testes ADF
- Autocorrelação (ACF, PACF)
- ARIMA e SARIMA
- Cointegração

### Projetos
1. Prever IPCA com SARIMA
2. Testar PPP (Paridade do Poder de Compra) com cointegração
3. Modelo VAR: PIB, inflação e desemprego

---

## Mês 5-6: Modelos de desenvolvimento

### O que aprender
- Dados de painel com `linearmodels`
- Efeitos fixos e aleatórios
- Regressão logística

### Projetos
1. Determinantes do crescimento econômico (painel 100+ países, 30 anos)
2. Probabilidade de crise cambial (logit)
3. Curva de Kuznets ambiental

---

## Projetos finais (portfólio)

1. **Dashboard macroeconômico brasileiro** — Streamlit com IPCA, PIB,
   desemprego, SELIC atualizados automaticamente
2. **Modelo de previsão de inflação** — SARIMA + redes neurais simples
3. **Análise de convergência de renda** — β-convergência e σ-convergência
   para países em desenvolvimento
4. **TCC com análise computacional** — use Python para toda a parte
   empírica do seu trabalho de conclusão

---

## Ferramentas

| Ferramenta | Quando usar |
|------------|-------------|
| VS Code | Editor principal (extensões: Python, Jupyter) |
| Jupyter Notebook | Exploração e análise interativa |
| Git/GitHub | Versionar projetos e portfólio |
| Terminal | Executar scripts, automatizar |

---

## Checklist semanal

- [ ] 30 min de teoria (vídeo/artigo)
- [ ] 1h de prática (codando)
- [ ] Escrever tudo no GitHub
- [ ] Tentar aplicar a uma pergunta econômica real

---

---

## Materiais do Repositório

| Arquivo | Conteúdo |
|---------|----------|
| `apostila_01_fundamentos.md` | Fundamentos de Python para Economia |
| `apostila_02_pandas.md` | Pandas para análise de dados econômicos |
| `apostila_03_visualizacao.md` | Visualização de dados (matplotlib, seaborn) |
| `apostila_04_econometria.md` | Econometria com Python (statsmodels) |
| `apostila_05_projetos.md` | Projetos práticos de portfólio |
| `apostila_06_matematica_financeira.md` | Matemática Financeira com Python (juros, amortização, VPL, TIR) |
| `apostila_07_financas.md` | Finanças com Python (CAPM, WACC, valuation, indicadores) |
| `livro_python_economia.md` | Livro completo: Python para Economia |
| `python_para_economia.md` | Guia de Python para Economia |

> Lema: Programação é igual econometria — só se aprende fazendo.
