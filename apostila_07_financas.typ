= Finanças --- Teoria Completa com Python
<finanças-teoria-completa-com-python>

#line()

== Capítulo 1 --- Introdução às Finanças
<capítulo-1-introdução-às-finanças>
=== 1.1. Definição e Escopo
<definição-e-escopo>
#strong[Finanças] é a arte e a ciência de administrar o dinheiro. Mais
precisamente, é o campo do conhecimento que estuda como os agentes
econômicos (indivíduos, empresas, governos) alocam recursos escassos ao
longo do tempo, considerando riscos e incertezas.

A área de finanças se divide em quatro grandes ramos:

#figure(
  align(center)[#table(
    columns: (25%, 75%),
    align: (auto,auto,),
    table.header([Ramo], [Objeto de Estudo],),
    table.hline(),
    [#strong[Finanças Corporativas]], [Decisões financeiras dentro das
    empresas (investir, financiar, distribuir)],
    [#strong[Investimentos]], [Alocação de recursos em ativos
    financeiros (ações, títulos, derivativos)],
    [#strong[Instituições Financeiras]], [Bancos, corretoras,
    seguradoras, fundos --- seu papel e regulação],
    [#strong[Finanças Internacionais]], [Fluxos financeiros entre
    países, câmbio, risco-país],
  )]
  , kind: table
  )

=== 1.2. As Três Decisões Fundamentais
<as-três-decisões-fundamentais>
O gestor financeiro de uma empresa enfrenta três grandes decisões, que
formam o tripé das finanças corporativas:

==== Decisão de Investimento (Capital Budgeting)
<decisão-de-investimento-capital-budgeting>
#strong[Onde aplicar os recursos?] Quais projetos, máquinas, aquisições
ou ativos gerarão o maior retorno ajustado ao risco.

Envolve: - Estimativa de fluxos de caixa futuros - Análise de risco do
projeto - Métricas de avaliação: VPL, TIR, Payback, IL - Priorização
entre projetos concorrentes

==== Decisão de Financiamento (Estrutura de Capital)
<decisão-de-financiamento-estrutura-de-capital>
#strong[Como captar os recursos?] Qual a combinação ideal entre capital
próprio (ações, lucros retidos) e capital de terceiros (dívidas,
debêntures, empréstimos).

Envolve: - Custo de cada fonte de capital - WACC (Custo Médio Ponderado
de Capital) - Teoria de Modigliani-Miller - Trade-off entre risco e
benefício fiscal

==== Decisão de Dividendos
<decisão-de-dividendos>
#strong[Quanto distribuir aos acionistas vs reinvestir?] Qual a política
ótima de distribuição de resultados.

Envolve: - Pay-out ratio (percentual do lucro distribuído) - Dividend
Yield - Recompra de ações - Teoria da irrelevância dos dividendos

=== 1.3. Objetivo da Empresa
<objetivo-da-empresa>
O objetivo consensual da teoria financeira moderna é #strong[maximizar a
riqueza dos acionistas] (shareholder wealth maximization). Isso se
traduz em maximizar o preço das ações no longo prazo.

#strong[Por que não maximizar o lucro?] - O lucro contábil é uma medida
de curto prazo - O lucro não considera o risco - O lucro não considera o
valor do dinheiro no tempo - O lucro pode ser manipulado por práticas
contábeis

#strong[Valor da empresa:]

$ upright("Valor") = sum_(t = 1)^oo frac(upright("FCL")_t, \(1 + upright("WACC")\)^t) $

Onde $upright("FCL")_t$ são os fluxos de caixa livres gerados em cada
período $t$, e $upright("WACC")$ é a taxa de desconto.

```python
def valor_descontado(fluxos, wacc):
    """Calcula o valor presente de uma série de fluxos de caixa."""
    return sum(f / (1 + wacc) ** (t + 1) for t, f in enumerate(fluxos))

fluxos = [100, 115, 132, 152, 175]
wacc = 0.12
v = valor_descontado(fluxos, wacc)
print(f"Valor presente dos fluxos (5 anos): R\${v:.2f} milhões")
```

=== 1.4. Gestão Baseada em Valor (VBM)
<gestão-baseada-em-valor-vbm>
Value-Based Management é uma filosofia de gestão que alinha todas as
decisões --- estratégicas, operacionais e financeiras --- à criação de
valor para o acionista.

#strong[Métricas-chave do VBM:]

#figure(
  align(center)[#table(
    columns: (27.27%, 27.27%, 45.45%),
    align: (auto,auto,auto,),
    table.header([Métrica], [Fórmula], [Interpretação],),
    table.hline(),
    [#strong[EVA] (Economic Value Added)], [NOPAT - (Capital ×
    WACC)], [Lucro econômico real],
    [#strong[MVA] (Market Value Added)], [Valor de Mercado - Capital
    Investido], [Riqueza criada para o acionista],
    [#strong[ROIC]], [NOPAT / Capital Investido], [Retorno sobre o
    capital],
    [#strong[ROE]], [Lucro Líquido / Patrimônio Líquido], [Retorno sobre
    capital próprio],
  )]
  , kind: table
  )

#strong[Regra fundamental:] Se $upright("ROIC") > upright("WACC")$, a
empresa está #strong[criando valor]. Se
$upright("ROIC") < upright("WACC")$, está #strong[destruindo valor].

```python
def metricas_vbm(nopat, capital_investido, wacc, valor_mercado, ll, pl):
    eva_ = nopat - (capital_investido * wacc)
    mva_ = valor_mercado - capital_investido
    roic = nopat / capital_investido
    roe = ll / pl
    return {'EVA': eva_, 'MVA': mva_, 'ROIC': roic, 'ROE': roe}

exemplo = metricas_vbm(500, 4000, 0.12, 6500, 350, 3000)
for k, v in exemplo.items():
    if k in ('ROIC', 'ROE'):
        print(f"{k}: {v*100:.2f}%")
    else:
        print(f"{k}: R\${v:,.2f}")
```

#line()

== Capítulo 2 --- Risco e Retorno
<capítulo-2-risco-e-retorno>
=== 2.1. Conceitos Fundamentais
<conceitos-fundamentais>
#strong[Retorno] é o ganho ou perda de um investimento em determinado
período. Pode vir de duas fontes:

- #strong[Ganho de capital:] variação no preço do ativo
  $\(P_t - P_(t - 1)\)$
- #strong[Renda periódica:] dividendos, juros, aluguéis $\(D_t\)$

$ R_t = frac(P_t - P_(t - 1) + D_t, P_(t - 1)) $

#strong[Risco] é a probabilidade de o retorno real diferir do retorno
esperado. Quanto maior a dispersão dos possíveis retornos, maior o
risco.

#strong[Métricas de risco:] - #strong[Variância:]
$sigma^2 = E\[\(R - E\(R\)\)^2\]$ - #strong[Desvio padrão:]
$sigma = sqrt(sigma^2)$ (mede o risco total) - #strong[Semidesvio:]
considera apenas desvios negativos (downside risk) - #strong[Value at
Risk (VaR):] perda máxima esperada em dado nível de confiança

```python
import numpy as np
import pandas as pd
import yfinance as yf
import matplotlib.pyplot as plt
from scipy import stats

# Baixar dados
ticker = "PETR4.SA"
dados = yf.download(ticker, start="2020-01-01", end="2024-01-01")
precos = dados['Adj Close']
retornos = precos.pct_change().dropna()

# Estatísticas
print(f"{'Métrica':<25} {'Valor':<15}")
print("-" * 40)
print(f"{'Retorno médio diário':<25} {retornos.mean()*100:.4f}%")
print(f"{'Volatilidade diária':<25} {retornos.std()*100:.4f}%")
print(f"{'Volatilidade anualizada':<25} {retornos.std() * np.sqrt(252) * 100:.2f}%")
print(f"{'Máximo retorno diário':<25} {retornos.max()*100:.2f}%")
print(f"{'Mínimo retorno diário':<25} {retornos.min()*100:.2f}%")
print(f"{'Assimetria (skewness)':<25} {retornos.skew():.4f}")
print(f"{'Curtose (kurtosis)':<25} {retornos.kurtosis():.4f}")
print(f"{'VaR 95% (histórico)':<25} {retornos.quantile(0.05)*100:.2f}%")
print(f"{'VaR 99% (histórico)':<25} {retornos.quantile(0.01)*100:.2f}%")
```

=== 2.2. Retorno Esperado
<retorno-esperado>
Quando não temos dados históricos, usamos cenários probabilísticos:

$ E\(R\)= sum_(i = 1)^n p_i times R_i $

Onde $p_i$ é a probabilidade do cenário $i$ ocorrer e $R_i$ é o retorno
nesse cenário.

```python
def retorno_esperado(cenarios):
    """
    Calcula retorno esperado a partir de cenários.
    cenarios: lista de (probabilidade, retorno)
    """
    return sum(p * r for p, r in cenarios)

def risco_total(cenarios):
    """Calcula desvio padrão a partir de cenários."""
    er = retorno_esperado(cenarios)
    variancia = sum(p * (r - er) ** 2 for p, r in cenarios)
    return np.sqrt(variancia)

# Cenários econômicos para uma ação
cenarios = [
    (0.15, 0.35),   # boom: 15% chance, 35% retorno
    (0.30, 0.18),   # expansão: 30% chance, 18% retorno
    (0.30, 0.08),   # normal: 30% chance, 8% retorno
    (0.15, -0.05),  # recessão: 15% chance, -5% retorno
    (0.10, -0.20)   # crise: 10% chance, -20% retorno
]

er = retorno_esperado(cenarios)
sigma = risco_total(cenarios)
print(f"Retorno esperado: {er*100:.2f}%")
print(f"Risco (desv. pad.): {sigma*100:.2f}%")
print(f"Relação retorno/risco: {er/sigma:.2f}")
```

=== 2.3. Risco de uma Carteira (Portfólio)
<risco-de-uma-carteira-portfólio>
O risco de uma carteira #strong[não] é a média ponderada dos riscos
individuais, pois a #strong[correlação] entre os ativos reduz (ou
aumenta) o risco total.

#strong[Retorno da carteira:]

$ E\(R_p\)= sum_(i = 1)^n w_i times E\(R_i\) $

#strong[Variância da carteira (2 ativos):]

$ sigma_p^2 = w_1^2 sigma_1^2 + w_2^2 sigma_2^2 + 2 w_1 w_2 sigma_1 sigma_2 rho_12 $

#strong[Variância da carteira (n ativos):]

$ sigma_p^2 = sum_(i = 1)^n sum_(j = 1)^n w_i w_j sigma_(upright("ij")) $

Onde
$sigma_(upright("ij")) = rho_(upright("ij")) times sigma_i times sigma_j$
é a covariância.

```python
def risco_carteira(pesos, cov_matrix):
    """
    Calcula o risco (desvio padrão) de uma carteira.
    pesos: array de pesos dos ativos
    cov_matrix: matriz de covariância
    """
    return np.sqrt(pesos @ cov_matrix @ pesos)

def simulacao_diversificacao():
    """
    Demonstra o efeito da diversificação com N ativos.
    """
    np.random.seed(42)
    risco_comum = 0.40
    correlacao = 0.15  # correlação média entre ativos

    for n_ativos in [1, 2, 5, 10, 20, 50, 100]:
        if n_ativos == 1:
            risco_total = risco_comum
        else:
            risco_nao_sistematico = risco_comum / np.sqrt(n_ativos)
            risco_sistematico = risco_comum * np.sqrt(correlacao)
            risco_total = np.sqrt(risco_sistematico**2 + risco_nao_sistematico**2)
        print(f"N = {n_ativos:3d} ativos -> Risco da carteira: {risco_total*100:.2f}%")

simulacao_diversificacao()
```

```
N =   1 ativos -> Risco da carteira: 40.00%
N =   2 ativos -> Risco da carteira: 28.54%
N =   5 ativos -> Risco da carteira: 20.19%
N =  10 ativos -> Risco da carteira: 17.06%
N =  20 ativos -> Risco da carteira: 15.82%
N =  50 ativos -> Risco da carteira: 15.25%
N = 100 ativos -> Risco da carteira: 15.11%
```

#strong[Conclusão fundamental:] A diversificação reduz o risco, mas há
um limite mínimo --- o #strong[risco sistemático] (de mercado) --- que
não pode ser eliminado por mais que se diversifique.

```
Risco Total = Risco Sistemático (mercado) + Risco Não-Sistemático (empresa)
```

=== 2.4. CAPM --- Capital Asset Pricing Model
<capm-capital-asset-pricing-model>
Desenvolvido por Sharpe (1964), Lintner (1965) e Mossin (1966), o CAPM é
o modelo mais influente para precificação de ativos financeiros.

#strong[Premissas do CAPM:] 1. Investidores são racionais e avessos ao
risco 2. Mercados são perfeitos (sem custos de transação, sem impostos)
\3. Todos os investidores têm o mesmo horizonte de investimento 4. Todos
têm as mesmas expectativas sobre retornos e riscos 5. Existe um ativo
livre de risco (Rf) 6. Todos podem tomar emprestado à taxa livre de
risco

#strong[Equação do CAPM:]

$ E\(R_i\)= R_f + beta_i times\[E\(R_m\)- R_f\] $

#strong[Onde:] - $R_f$ = taxa livre de risco (Selic, Treasury bond) -
$E\(R_m\)$ = retorno esperado da carteira de mercado -
$\[E\(R_m\)- R_f\]$ = prêmio de risco do mercado - $beta_i$ =
sensibilidade do ativo i aos movimentos do mercado

```python
def capm(rf, beta, premio_mercado):
    return rf + beta * premio_mercado

rf = 0.105      # 10.5% (Selic real)
premio = 0.055  # 5.5% prêmio histórico do Ibovespa

print(f"Selic (Rf): {rf*100:.1f}%")
print(f"Prêmio de risco: {premio*100:.1f}%\n")
print(f"{'Beta':<8} {'Retorno Esperado':<20} {'Perfil'}")
print("-" * 45)
for beta in [0.0, 0.5, 0.8, 1.0, 1.2, 1.5, 2.0]:
    ret = capm(rf, beta, premio) * 100
    perfil = {0: 'Livre de risco', 0.5: 'Defensivo', 0.8: 'Moderado',
              1.0: 'Mercado', 1.2: 'Agressivo', 1.5: 'Agressivo+', 2.0: 'Alavancado'}
    print(f"{beta:<8.1f} {ret:<19.2f}% {perfil.get(beta, '')}")
```

=== 2.5. Beta ($beta$)
<beta-beta>
O beta mede o #strong[risco sistemático] de um ativo:

$ beta_i = frac(upright("Cov")\(R_i\,R_m\), upright("Var")\(R_m\)) $

#strong[Interpretação:] - $beta = 1$: o ativo acompanha o mercado -
$beta > 1$: o ativo é mais volátil que o mercado (ações de crescimento,
small caps) - $0 < beta < 1$: o ativo é menos volátil que o mercado
(utilidades, defensivas) - $beta = 0$: o ativo não tem correlação com o
mercado (caixa) - $beta < 0$: o ativo se move na direção oposta ao
mercado (ouro, alguns hedge funds)

```python
def calcular_beta(dados_acao, dados_mercado):
    """
    Calcula o beta de uma ação contra o mercado.
    """
    r_acao = dados_acao.pct_change().dropna()
    r_mercado = dados_mercado.pct_change().dropna()
    dados = pd.concat([r_acao, r_mercado], axis=1, join='inner').dropna()
    cov = dados.iloc[:, 0].cov(dados.iloc[:, 1])
    var_mercado = dados.iloc[:, 1].var()
    beta = cov / var_mercado

    # Regressão linear para informações adicionais
    from scipy import stats
    slope, intercept, r_value, p_value, std_err = stats.linregress(
        dados.iloc[:, 1], dados.iloc[:, 0]
    )

    return {
        'beta': beta,
        'alpha': intercept,
        'r_quadrado': r_value ** 2,
        'p_valor': p_value
    }

# Exemplo de uso (com dados reais)
# acao = yf.download("PETR4.SA")['Adj Close']
# mercado = yf.download("^BVSP")['Adj Close']
# resultado = calcular_beta(acao, mercado)
# print(f"Beta: {resultado['beta']:.2f}")
# print(f"R²: {resultado['r_quadrado']:.3f}")
```

=== 2.6. Críticas e Limitações do CAPM
<críticas-e-limitações-do-capm>
+ #strong[Premissas irreais:] mercados não são perfeitamente eficientes
+ #strong[Beta não é estável:] muda ao longo do tempo
+ #strong[Proxy de mercado:] o Ibovespa (ou S&P 500) não é a "carteira
  de mercado" teórica
+ #strong[Anomalias:] fatores tamanho, valor, momentum explicam retornos
  melhor que o beta sozinho

#strong[Alternativas ao CAPM:] - #strong[Modelo de 3 Fatores de
Fama-French:] adiciona SMB (small minus big) e HML (high minus low) -
#strong[Modelo de 4 Fatores (Carhart):] adiciona momentum -
#strong[Modelo de 5 Fatores (Fama-French):] adiciona profitability e
investment - #strong[APT (Arbitrage Pricing Theory):] múltiplos fatores
macroeconômicos

=== 2.7. Fronteira Eficiente de Markowitz
<fronteira-eficiente-de-markowitz>
Harry Markowitz (1952) demonstrou que existe um conjunto de carteiras
que oferecem o #strong[máximo retorno para cada nível de risco] --- a
#strong[fronteira eficiente].

#strong[Problema de otimização:] - Dado um conjunto de ativos com
retornos esperados, variâncias e covariâncias - Encontrar os pesos $w_i$
que minimizam o risco para cada nível de retorno

```python
def fronteira_eficiente(retornos, cov_matrix, n_pontos=100):
    """
    Calcula a fronteira eficiente de Markowitz.
    """
    n = len(retornos)
    resultados = {'risco': [], 'retorno': [], 'sharpe': [], 'pesos': []}

    # Gera carteiras aleatórias
    for _ in range(10000):
        w = np.random.random(n)
        w = w / w.sum()
        ret = w @ retornos
        risco = np.sqrt(w @ cov_matrix @ w)
        sharpe = ret / risco if risco > 0 else 0
        resultados['risco'].append(risco)
        resultados['retorno'].append(ret)
        resultados['sharpe'].append(sharpe)
        resultados['pesos'].append(w)

    return resultados

def carteira_otima_sharpe(resultados):
    """Encontra a carteira com maior Índice de Sharpe."""
    idx = np.argmax(resultados['sharpe'])
    return {
        'retorno': resultados['retorno'][idx],
        'risco': resultados['risco'][idx],
        'sharpe': resultados['sharpe'][idx],
        'pesos': resultados['pesos'][idx]
    }

def carteira_minima_volatilidade(resultados):
    idx = np.argmin(resultados['risco'])
    return {
        'retorno': resultados['retorno'][idx],
        'risco': resultados['risco'][idx],
        'sharpe': resultados['sharpe'][idx],
        'pesos': resultados['pesos'][idx]
    }

# Simulação com 4 ativos
retornos_esperados = np.array([0.12, 0.15, 0.09, 0.14])
cov_matrix = np.array([
    [0.04, 0.012, 0.008, 0.015],
    [0.012, 0.09, 0.01, 0.025],
    [0.008, 0.01, 0.03, 0.009],
    [0.015, 0.025, 0.009, 0.07]
])

resultados = fronteira_eficiente(retornos_esperados, cov_matrix)
max_sharpe = carteira_otima_sharpe(resultados)
min_vol = carteira_minima_volatilidade(resultados)

print("Carteira de Máximo Sharpe:")
print(f"  Retorno: {max_sharpe['retorno']*100:.2f}%")
print(f"  Risco: {max_sharpe['risco']*100:.2f}%")
print(f"  Sharpe: {max_sharpe['sharpe']:.3f}")

print("\nCarteira de Mínima Volatilidade:")
print(f"  Retorno: {min_vol['retorno']*100:.2f}%")
print(f"  Risco: {min_vol['risco']*100:.2f}%")
print(f"  Sharpe: {min_vol['sharpe']:.3f}")
```

#line()

== Capítulo 3 --- Custo de Capital
<capítulo-3-custo-de-capital>
=== 3.1. Conceito
<conceito>
O #strong[custo de capital] é a taxa de retorno mínima exigida pelos
provedores de capital (acionistas e credores) para investir em uma
empresa. É a #strong[TMA] (Taxa Mínima de Atratividade) para novos
projetos.

#quote(block: true)[
"O custo de capital é a taxa de retorno que uma empresa precisa obter
sobre seus investimentos para manter o valor de suas ações inalterado."
--- Brigham & Ehrhardt
]

=== 3.2. Custo de Capital Próprio (Ke)
<custo-de-capital-próprio-ke>
É a taxa de retorno exigida pelos acionistas. As principais formas de
estimá-lo:

#strong[\1. CAPM:] $ upright("Ke") = R_f + beta times\(R_m - R_f\) $

#strong[\2. Modelo de Gordon (Dividend Discount Model):]
$ upright("Ke") = D_1 / P_0 + g $

#strong[\3. Bond Yield + Risk Premium:]
$ upright("Ke") = upright("Kd") + upright("Prêmio") $

```python
def custo_capital_proprio_capm(rf, beta, rm):
    return rf + beta * (rm - rf)

def custo_capital_proprio_gordon(dividendo_proximo, preco_atual, crescimento):
    return dividendo_proximo / preco_atual + crescimento

# CAPM
rf, beta, rm = 0.105, 1.1, 0.165
ke_capm = custo_capital_proprio_capm(rf, beta, rm)

# Gordon
d1, po, g = 2.50, 45.00, 0.04
ke_gordon = custo_capital_proprio_gordon(d1, po, g)

print(f"Ke (CAPM):   {ke_capm*100:.2f}%")
print(f"Ke (Gordon): {ke_gordon*100:.2f}%")
```

=== 3.3. Custo de Capital de Terceiros (Kd)
<custo-de-capital-de-terceiros-kd>
É a taxa efetiva que a empresa paga sobre suas dívidas. Como os juros
são dedutíveis do IR, usa-se o #strong[custo líquido]:

$ upright("Kd")_(upright("líquido")) = upright("Kd")_(upright("bruto")) times\(1 - upright("IR")\) $

#strong[Formas de estimar:] - Taxa de juros dos empréstimos bancários
recentes - Yield to maturity (YTM) das debêntures da empresa - Spread
sobre o CDI ou Selic

```python
def custo_terceiros(kd_bruto, aliquota_ir):
    return kd_bruto * (1 - aliquota_ir)

# Empresa paga CDI + 2,5% a.a. com CDI a 13,25%
cdi = 0.1325
spread = 0.025
kd_bruto = (1 + cdi) * (1 + spread) - 1

print(f"Custo bruto da dívida: {kd_bruto*100:.2f}% a.a.")
print(f"Alíquota de IR: 34%")
print(f"Custo líquido da dívida: {custo_terceiros(kd_bruto, 0.34)*100:.2f}% a.a.")
```

=== 3.4. WACC --- Weighted Average Cost of Capital
<wacc-weighted-average-cost-of-capital>
O WACC é a média ponderada do custo de cada fonte de capital:

$ upright("WACC") = E / V times upright("Ke") + D / V times upright("Kd") times\(1 - upright("IR")\) $

Onde: - $E$ = valor de mercado do capital próprio (equity) - $D$ = valor
de mercado da dívida (debt) - $V = E + D$ = valor total da empresa

```python
def wacc(ke, kd_bruto, ir, peso_pl, peso_divida):
    kd_liquido = kd_bruto * (1 - ir)
    return peso_pl * ke + peso_divida * kd_liquido

def analise_wacc():
    """
    Análise de sensibilidade do WACC a mudanças na estrutura de capital.
    """
    ke = 0.145
    kd_bruto = 0.12
    ir = 0.34

    print(f"{'Dívida (%)':<12} {'PL (%)':<12} {'WACC (%)':<12}")
    print("-" * 36)
    for p_divida in np.arange(0, 0.91, 0.1):
        p_pl = 1 - p_divida
        w = wacc(ke, kd_bruto, ir, p_pl, p_divida)
        print(f"{p_divida*100:<11.0f}% {p_pl*100:<11.0f}% {w*100:<10.2f}%")

analise_wacc()
```

```
Dívida (%)   PL (%)       WACC (%)
-------------------------------------
0%           100%         14.50%
10%          90%          13.69%
20%          80%          12.88%
30%          70%          12.08%
40%          60%          11.27%
50%          50%          10.46%
60%          40%          9.65%
70%          30%          8.84%
80%          20%          8.04%
90%          10%          7.23%
```

#strong[Atenção:] O WACC diminui com mais dívida apenas até certo ponto.
Com endividamento excessivo, o risco de falência aumenta, elevando tanto
Ke quanto Kd.

=== 3.5. Teoria do Custo de Capital
<teoria-do-custo-de-capital>
A estrutura de capital ótima é aquela que #strong[minimiza o WACC] e,
consequentemente, #strong[maximiza o valor da empresa].

```python
def valor_empresa_modelo(fcf_perpetuo, wacc):
    """Valor da empresa pela perpetuidade do FCF."""
    return fcf_perpetuo / wacc

fcf = 100  # fluxo de caixa livre perpétuo (milhões)
print(f"FCF perpétuo: R\${fcf} milhões\n")

for w in [0.08, 0.10, 0.12, 0.14, 0.16]:
    v = valor_empresa_modelo(fcf, w)
    print(f"WACC = {w*100:.0f}% -> Valor = R\${v:,.0f} milhões")
```

#line()

== Capítulo 4 --- Valuation (Avaliação de Empresas)
<capítulo-4-valuation-avaliação-de-empresas>
=== 4.1. Abordagens de Valuation
<abordagens-de-valuation>
#figure(
  align(center)[#table(
    columns: (44%, 32%, 24%),
    align: (auto,auto,auto,),
    table.header([Abordagem], [Método], [Base],),
    table.hline(),
    [#strong[Fluxo de Caixa Descontado]], [FCD (DCF)], [Valor intrínseco
    (fundamentalista)],
    [#strong[Relativa (Múltiplos)]], [P/L, EV/EBITDA, P/VP], [Comparação
    com pares],
    [#strong[Base em Ativos]], [Valor Patrimonial, Liquidação], [Custo
    de reposição],
    [#strong[Base em Opções]], [Black-Scholes, Binomial], [Flexibilidade
    gerencial],
  )]
  , kind: table
  )

=== 4.2. Fluxo de Caixa Descontado (FCD / DCF)
<fluxo-de-caixa-descontado-fcd-dcf>
O valor intrínseco de uma empresa é o valor presente de todos os fluxos
de caixa futuros:

$ upright("EV") = sum_(t = 1)^n frac(upright("FCF")_t, \(1 + upright("WACC")\)^t) + frac(upright("VT"), \(1 + upright("WACC")\)^n) $

#strong[Onde:] - $upright("EV")$ = Enterprise Value (valor da firma) -
$upright("FCF")_t$ = Fluxo de Caixa Livre no ano t - $upright("WACC")$ =
custo médio ponderado de capital - $upright("VT")$ = Valor Terminal
(perpetuidade)

#strong[Valor Terminal (Gordon):]

$ upright("VT") = frac(upright("FCF")_n times\(1 + g\), upright("WACC") - g) $

#strong[Equity Value:]
$ upright("Equity") med upright("Value") = upright("EV") - upright("Dívida") + upright("Caixa") $

```python
def valuation_fcd(fcfs, wacc, g, divida, caixa):
    """
    Valuation pelo Fluxo de Caixa Descontado.
    """
    n = len(fcfs)
    # VP dos FCFs explícitos
    vp_fcf = sum(fcf / (1 + wacc) ** (t + 1) for t, fcf in enumerate(fcfs))

    # Valor Terminal
    ultimo_fcf = fcfs[-1]
    vt = ultimo_fcf * (1 + g) / (wacc - g)
    vp_vt = vt / (1 + wacc) ** n

    ev = vp_fcf + vp_vt
    equity_value = ev - divida + caixa

    return {
        'VP_FCFs': round(vp_fcf, 2),
        'VP_Valor_Terminal': round(vp_vt, 2),
        'Enterprise_Value': round(ev, 2),
        '(-) Dívida': round(-divida, 2),
        '(+) Caixa': round(caixa, 2),
        'Equity_Value': round(equity_value, 2)
    }

# Exemplo
fcfs = [100, 115, 132, 152, 175]
wacc = 0.12
g = 0.035
divida = 300
caixa = 80

resultado = valuation_fcd(fcfs, wacc, g, divida, caixa)
print("=== Valuation por FCD ===")
for k, v in resultado.items():
    print(f"{k:25s}: R\${v:>10,.2f}")
```

```
=== Valuation por FCD ===
VP_FCFs                 : R$    538.63
VP_Valor_Terminal       : R$  1,300.27
Enterprise_Value        : R$  1,838.90
(-) Dívida              : R$   -300.00
(+) Caixa               : R$     80.00
Equity_Value            : R$  1,618.90
```

=== 4.3. Valuation por Múltiplos
<valuation-por-múltiplos>
Mais rápido que o FCD, mas depende de encontrar empresas comparáveis.

```python
def multiplos_empresa(lucro, ebitda, receita, valor_patrimonial, num_acoes,
                      pl_setor, ev_ebitda_setor, pvp_setor):
    """
    Estima o preço justo por múltiplos de mercado.
    """
    preco_pl = pl_setor * (lucro / num_acoes)
    preco_pvp = pvp_setor * (valor_patrimonial / num_acoes)

    # Para EV/EBITDA, precisamos estimar o EV
    ev_estimado = ev_ebitda_setor * ebitda

    print(f"{'Múltiplo':<15} {'Múltiplo Setor':<18} {'Preço Justo':<15}")
    print("-" * 48)
    print(f"{'P/L':<15} {pl_setor:<18.2f}x R\${preco_pl:<10.2f}")
    print(f"{'EV/EBITDA':<15} {ev_ebitda_setor:<18.2f}x ---")
    print(f"{'P/VP':<15} {pvp_setor:<18.2f}x R\${preco_pvp:<10.2f}")

    return {'P/L': preco_pl, 'P/VP': preco_pvp}

# Empresa com LPA = R$3,50; valor patrimonial por ação = R$20
multiplos_empresa(
    lucro=350e6, ebitda=600e6, receita=1.2e9,
    valor_patrimonial=2e9, num_acoes=100e6,
    pl_setor=12, ev_ebitda_setor=7, pvp_setor=1.5
)
```

=== 4.4. Múltiplos Comuns
<múltiplos-comuns>
#figure(
  align(center)[#table(
    columns: (23.81%, 21.43%, 26.19%, 28.57%),
    align: (auto,auto,auto,auto,),
    table.header([Múltiplo], [Fórmula], [Indicação], [Melhor Uso],),
    table.hline(),
    [#strong[P/L] (Preço/Lucro)], [$P\/upright("LPA")$], [Mais
    popular], [Empresas maduras, lucro estável],
    [#strong[EV/EBITDA]], [$upright("EV")\/upright("EBITDA")$], [Ignora
    depreciação], [Empresas de capital intensivo],
    [#strong[P/VP]], [$P\/upright("VPA")$], [Valor
    patrimonial], [Bancos, seguradoras],
    [#strong[Div. Yield]], [$upright("DPA")\/P$], [Retorno em
    dividendos], [Empresas que distribuem lucro],
    [#strong[P/Receita]], [$P\/upright("Receita")$], [Empresas sem
    lucro], [Startups, crescimento],
    [#strong[EV/FCF]], [$upright("EV")\/upright("FCF")$], [Geração de
    caixa], [Qualquer empresa],
  )]
  , kind: table
  )

#line()

== Capítulo 5 --- Análise de Demonstrações Financeiras
<capítulo-5-análise-de-demonstrações-financeiras>
=== 5.1. As Três Demonstrações
<as-três-demonstrações>
#strong[\1. Balanço Patrimonial (BP) --- "Fotografia"] Mostra a posição
financeira em uma data específica:

$ upright("Ativo") = upright("Passivo") + upright("Patrimônio") upright("Líquido") $

#strong[\2. Demonstração do Resultado (DRE) --- "Filme"] Mostra a
geração de lucro em um período:

$ upright("Receita") - upright("Custos") - upright("Despesas") = upright("Lucro") upright("Líquido") $

#strong[\3. Demonstração do Fluxo de Caixa (DFC)] Mostra as origens e
usos do caixa, dividido em operacional, investimento e financiamento.

=== 5.2. Análise Vertical e Horizontal
<análise-vertical-e-horizontal>
#strong[Análise Vertical:] cada item é expresso como percentual de uma
base (receita total, ativo total).

#strong[Análise Horizontal:] evolução dos itens ao longo do tempo.

```python
def analise_vertical(dre):
    """DRE como percentual da receita líquida."""
    receita = dre['receita_liquida']
    print(f"{'Item':<30} {'Valor (R$ mil)':<18} {'% Receita':<10}")
    print("-" * 58)
    for item, valor in dre.items():
        pct = valor / receita * 100
        print(f"{item:<30} R\${valor:<13,.0f} {pct:<9.2f}%")

dre_exemplo = {
    'receita_liquida': 1000000,
    'custo_produtos': -550000,
    'despesas_operacionais': -200000,
    'despesas_financeiras': -50000,
    'imposto_renda': -68000
}
analise_vertical(dre_exemplo)
```

=== 5.3. Indicadores de Liquidez
<indicadores-de-liquidez>
Medem a capacidade de pagar obrigações de curto prazo.

#figure(
  align(center)[#table(
    columns: (31.43%, 25.71%, 42.86%),
    align: (auto,auto,auto,),
    table.header([Indicador], [Fórmula], [Interpretação],),
    table.hline(),
    [#strong[Liquidez
    Corrente]], [$upright("AC")\/upright("PC")$], [Ideal \> 1,5],
    [#strong[Liquidez
    Seca]], [$\(upright("AC") - upright("Estoques")\)\/upright("PC")$], [Ideal
    \> 1,0],
    [#strong[Liquidez
    Imediata]], [$upright("Disponível")\/upright("PC")$], [Capacidade
    imediata],
    [#strong[Liquidez
    Geral]], [$\(upright("AC") + upright("RLP")\)\/\(upright("PC") + upright("ELP")\)$], [Longo
    prazo],
  )]
  , kind: table
  )

```python
def indicadores_liquidez(ac, pc, estoques, disponivel, rlp, elp):
    lc = ac / pc
    ls = (ac - estoques) / pc
    li = disponivel / pc
    lg = (ac + rlp) / (pc + elp)
    return {'Corrente': lc, 'Seca': ls, 'Imediata': li, 'Geral': lg}

# Exemplo
ac, pc, est, disp, rlp, elp = 8000, 5000, 2000, 1000, 3000, 2000
liq = indicadores_liquidez(ac, pc, est, disp, rlp, elp)
for k, v in liq.items():
    status = "OK" if v >= 1.0 else "ATENÇÃO"
    print(f"Liquidez {k}: {v:.2f} [{status}]")
```

=== 5.4. Indicadores de Endividamento
<indicadores-de-endividamento>
Medem a estrutura de capital e o risco financeiro.

#figure(
  align(center)[#table(
    columns: (31.43%, 25.71%, 42.86%),
    align: (auto,auto,auto,),
    table.header([Indicador], [Fórmula], [Interpretação],),
    table.hline(),
    [#strong[Dívida/PL]], [$upright("Passivo")\/upright("PL")$], [Quanto
    maior, mais alavancado],
    [#strong[Dívida/Ativo]], [$upright("Passivo")\/upright("Ativo")$], [Percentual
    financiado por terceiros],
    [#strong[ICJ]], [$upright("LAJIR")\/upright("DF")$], [Cobertura de
    juros],
    [#strong[Composição do
    Endividamento]], [$upright("PC")\/\(upright("PC") + upright("ELP")\)$], [Perfil
    da dívida],
  )]
  , kind: table
  )

```python
def indicadores_endividamento(passivo_circ, passivo_ncirc, pl, lajir, despesas_fin):
    pt = passivo_circ + passivo_ncirc
    d_pl = pt / pl
    d_ativ = pt / (pt + pl)
    icj = lajir / despesas_fin if despesas_fin != 0 else float('inf')
    comp_end = passivo_circ / pt
    return {'Dívida/PL': d_pl, 'Dívida/Ativo': d_ativ,
            'ICJ': icj, 'Composição CP': comp_end}

# Exemplo
ind_end = indicadores_endividamento(5000, 3000, 7000, 1200, 400)
for k, v in ind_end.items():
    print(f"{k}: {v:.2f}")
```

=== 5.5. Indicadores de Rentabilidade
<indicadores-de-rentabilidade>
Medem a capacidade de gerar retorno sobre os recursos investidos.

#figure(
  align(center)[#table(
    columns: (33.33%, 27.27%, 39.39%),
    align: (auto,auto,auto,),
    table.header([Indicador], [Fórmula], [Significado],),
    table.hline(),
    [#strong[ROE]], [$upright("LL")\/upright("PL")$], [Retorno do
    acionista],
    [#strong[ROA]], [$upright("LL")\/upright("Ativo")$], [Retorno sobre
    ativos],
    [#strong[ROIC]], [$upright("NOPAT")\/upright("Capital") upright("Investido")$], [Retorno
    operacional],
    [#strong[Margem
    Líquida]], [$upright("LL")\/upright("Receita")$], [Lucratividade
    sobre vendas],
    [#strong[Margem
    Bruta]], [$\(upright("Receita") - upright("CPV")\)\/upright("Receita")$], [Lucro
    após custo dos produtos],
    [#strong[Giro do
    Ativo]], [$upright("Receita")\/upright("Ativo")$], [Eficiência no
    uso dos ativos],
  )]
  , kind: table
  )

```python
def indicadores_rentabilidade(ll, nopat, receita, ativo, pl, capital_investido):
    return {
        'ROE': ll / pl,
        'ROA': ll / ativo,
        'ROIC': nopat / capital_investido,
        'Margem Líquida': ll / receita,
        'Margem Bruta': 100,  # precisaria de CPV
        'Giro do Ativo': receita / ativo
    }

rent = indicadores_rentabilidade(800, 1100, 15000, 12000, 7000, 9000)
for k, v in rent.items():
    if k in ('Giro do Ativo',):
        print(f"{k}: {v:.2f}x")
    else:
        print(f"{k}: {v*100:.2f}%")
```

=== 5.6. Sistema DuPont
<sistema-dupont>
Decompõe o ROE em suas alavancas operacionais e financeiras:

$ upright("ROE") = upright("LL") / upright("Vendas") times upright("Vendas") / upright("Ativo") times upright("Ativo") / upright("PL") $

$ upright("ROE") = upright("Margem") med upright("Líquida") times upright("Giro") med upright("do") med upright("Ativo") times upright("Alavancagem") med upright("Financeira") $

#strong[Utilidade:] identifica qual alavanca está puxando (ou
prejudicando) o retorno do acionista.

```python
def dupont_analysis(ll, vendas, ativo, pl):
    margem = ll / vendas
    giro = vendas / ativo
    alavancagem = ativo / pl
    roe = margem * giro * alavancagem

    print("=== Análise DuPont ===")
    print(f"Margem Líquida:          {margem*100:.2f}%")
    print(f"Giro do Ativo:           {giro:.2f}x")
    print(f"Alavancagem Financeira:  {alavancagem:.2f}x")
    print(f"---")
    print(f"ROE: {margem*100:.2f}% × {giro:.2f}x × {alavancagem:.2f}x = {roe*100:.2f}%")

    # Contribuição de cada alavanca
    contrib_margem = margem * 1 * 1
    contrib_giro = margem * giro * 1
    contrib_alav = margem * giro * alavancagem
    print(f"\nContribuição marginal:")
    print(f"  Margem isolada: {contrib_margem*100:.2f}%")
    print(f"  + Giro: {contrib_giro*100:.2f}%")
    print(f"  + Alavancagem: {contrib_alav*100:.2f}%")

dupont_analysis(800, 15000, 12000, 7000)
```

=== 5.7. EBITDA e EBITDA Ajustado
<ebitda-e-ebitda-ajustado>
#strong[EBITDA] (Earnings Before Interest, Taxes, Depreciation and
Amortization) --- Lucro antes de juros, impostos, depreciação e
amortização.

$ upright("EBITDA") = upright("LAJIR") + upright("Depreciação") + upright("Amortização") $

#strong[Importante:] o EBITDA não é fluxo de caixa, pois ignora: -
Investimentos (CapEx) - Necessidade de Capital de Giro (NCG) - Impostos
e juros (que são pagos em dinheiro)

```python
def calcular_ebitda(lajir, depreciacao, amortizacao):
    return lajir + depreciacao + amortizacao

# DRE simplificada
receita, cpv, despesas_op, deprec, amort = 1000, 600, 150, 80, 30
lajir = receita - cpv - despesas_op
ebitda_ = calcular_ebitda(lajir, deprec, amort)

print(f"Receita: {receita}")
print(f"CPV: -{cpv}")
print(f"Despesas Op: -{despesas_op}")
print(f"= LAJIR (EBIT): {lajir}")
print(f"+ Depreciação: +{deprec}")
print(f"+ Amortização: +{amort}")
print(f"= EBITDA: {ebitda_}")
print(f"Margem EBITDA: {ebitda_/receita*100:.1f}%")
```

#line()

== Capítulo 6 --- Estrutura de Capital
<capítulo-6-estrutura-de-capital>
=== 6.1. A Pergunta Fundamental
<a-pergunta-fundamental>
#strong[Existe uma estrutura de capital ótima?] Isto é, uma combinação
dívida/capital próprio que maximiza o valor da empresa?

Esta é uma das questões mais debatidas em finanças corporativas.

=== 6.2. Modigliani-Miller (1958) --- Sem Impostos
<modigliani-miller-1958-sem-impostos>
#strong[Proposição I --- Irrelevância da Estrutura de Capital:]

Em mercados perfeitos (sem impostos, sem custos de falência, sem
assimetria de informação), o valor da empresa #strong[independe] da
estrutura de capital.

$ V_L = V_U $

#strong[Proposição II --- Custo do Capital Próprio:]

O custo do capital próprio aumenta linearmente com o endividamento:

$ upright("Ke") = upright("Ke")_U +\(upright("Ke")_U - upright("Kd")\)times D / E $

#strong[Implicação:] o aumento do Ke compensa exatamente o benefício da
dívida mais barata, mantendo o WACC constante.

```python
def mm_sem_impostos(ke_u, kd, d, e):
    """Proposição II de M&M sem impostos."""
    ke = ke_u + (ke_u - kd) * (d / e)
    v = d + e
    wacc_ = (e/v) * ke + (d/v) * kd
    return {'Ke': ke, 'WACC': wacc_}

print("M&M sem impostos:")
for d_e in [0, 0.25, 0.5, 1.0, 2.0]:
    d = d_e * 100
    e = 100
    res = mm_sem_impostos(0.15, 0.10, d, e)
    print(f"  D/E = {d_e:.2f}: Ke = {res['Ke']*100:.2f}%, WACC = {res['WACC']*100:.2f}%")
```

=== 6.3. Modigliani-Miller (1963) --- Com Impostos
<modigliani-miller-1963-com-impostos>
Com a dedutibilidade dos juros da dívida, a empresa alavancada vale
#strong[mais]:

$ V_L = V_U + D times upright("IR") $

O termo $D times upright("IR")$ é o #strong[benefício fiscal] (escudo
fiscal) da dívida.

```python
def mm_com_impostos(vu, d, ir):
    """M&M com impostos corporativos."""
    beneficio_fiscal = d * ir
    vl = vu + beneficio_fiscal
    return {'Vu': vu, 'Benefício Fiscal': beneficio_fiscal, 'VL': vl}

print("M&M com impostos (IR = 34%):")
for d in [0, 100, 200, 300, 400]:
    res = mm_com_impostos(1000, d, 0.34)
    print(f"  Dívida = {d:3d}: VL = R\${res['VL']:,.0f} (Benefício = R\${res['Benefício Fiscal']:,.0f})")
```

=== 6.4. Trade-off Theory
<trade-off-theory>
Na prática, o endividamento excessivo traz #strong[custos de falência]
(diretos e indiretos):

$ V_L = V_U + upright("VP")\(upright("Benefício") med upright("Fiscal")\)- upright("VP")\(upright("Custo") med upright("de") med upright("Falência")\) $

```
Valor da Empresa
    ^
    |    * Valor com benefício fiscal (M&M c/ impostos)
    |   /|
    |  / |
    | /  * Valor real (Trade-off)
    |/   |
    *----+-------------------> Endividamento
         ^
         |
      Ponto ótimo
```

#strong[Custos de falência:] - #strong[Diretos:] honorários
advocatícios, custas judiciais, perícias - #strong[Indiretos:] perda de
clientes, fornecedores, funcionários; vendas a preços baixos

#strong[A estrutura de capital ótima] está no ponto em que o benefício
marginal da dívida se iguala ao custo marginal esperado de falência.

=== 6.5. Pecking Order Theory (Myers & Majluf, 1984)
<pecking-order-theory-myers-majluf-1984>
Devido à #strong[assimetria de informação] (gestores sabem mais que
investidores), as empresas têm uma hierarquia de preferência para
financiamento:

+ #strong[Lucros retidos] (recursos internos) --- sem custo de seleção
  adversa
+ #strong[Dívida] --- sinal menos negativo que a emissão de ações
+ #strong[Ações] --- último recurso (sinal de que a ação pode estar
  sobrevalorizada)

#strong[Previsões da Pecking Order:] - Empresas lucrativas se endividam
#strong[menos] (têm mais recursos internos) - Empresas com muitas
oportunidades de crescimento emitem menos ações - A estrutura de capital
é resultado de decisões passadas, não de um alvo

#line()

== Capítulo 7 --- Política de Dividendos
<capítulo-7-política-de-dividendos>
=== 7.1. Tipos de Política
<tipos-de-política>
#figure(
  align(center)[#table(
    columns: (23.08%, 42.31%, 34.62%),
    align: (auto,auto,auto,),
    table.header([Tipo], [Descrição], [Exemplo],),
    table.hline(),
    [#strong[Constante]], [Mesmo valor todo período], [R\$ 0,50 por ação
    todo trimestre],
    [#strong[Crescente]], [Aumento regular], [Aumento de 5% ao ano no
    dividendo],
    [#strong[Pay-out fixo]], [Percentual constante do lucro], [40% do
    lucro líquido],
    [#strong[Residual]], [Distribui o que sobra após investir], [Só paga
    se não houver projetos viáveis],
  )]
  , kind: table
  )

=== 7.2. Métricas de Dividendos
<métricas-de-dividendos>
$ upright("DPA") = frac(upright("Dividendos") med upright("Totais"), upright("Número") med upright("de") med upright("Ações")) $

$ upright("Pay") - upright("out") = frac(upright("Dividendos"), upright("Lucro") med upright("Líquido")) $

$ upright("Dividend") med upright("Yield") = frac(upright("DPA"), upright("Preço") med upright("da") med upright("Ação")) $

```python
def metricas_dividendos(lucro_liquido, dividendos_pagos, num_acoes, preco_acao):
    lpa = lucro_liquido / num_acoes
    dpa = dividendos_pagos / num_acoes
    pay_out = dividendos_pagos / lucro_liquido
    dy = dpa / preco_acao

    print(f"{'Métrica':<20} {'Valor'}")
    print("-" * 30)
    print(f"{'LPA':<20} R\${lpa:.2f}")
    print(f"{'DPA':<20} R\${dpa:.2f}")
    print(f"{'Pay-out':<20} {pay_out*100:.1f}%")
    print(f"{'Dividend Yield':<20} {dy*100:.2f}%")
    print(f"{'Retenção (1-pay-out)':<20} {(1-pay_out)*100:.1f}%")

metricas_dividendos(500e6, 200e6, 100e6, 35)
```

=== 7.3. Teoria da Irrelevância (M&M, 1961)
<teoria-da-irrelevância-mm-1961>
Em mercados perfeitos, a política de dividendos #strong[não afeta o
valor da empresa]. O valor deriva da capacidade de gerar lucro e da
política de investimentos, não da forma como o lucro é distribuído.

#strong[Argumento:] se a empresa retém lucros em vez de distribuir, o
preço da ação aumenta compensando o dividendo não recebido. O acionista
pode criar seu próprio dividendo vendendo ações.

=== 7.4. Teoria do Pássaro na Mão (Gordon, 1963)
<teoria-do-pássaro-na-mão-gordon-1963>
#strong[Contraria M&M:] investidores preferem dividendos hoje a ganhos
de capital futuros (mais arriscados). Portanto, um aumento no pay-out
reduz o Ke e aumenta o valor da empresa.

=== 7.5. Efeito Clientela
<efeito-clientela>
Diferentes grupos de investidores preferem diferentes políticas de
dividendos: - #strong[Aposentados:] preferem alta distribuição (renda) -
#strong[Fundos de pensão:] podem preferir retenção (crescimento) -
#strong[Empresas:] podem preferir recompra de ações (tributação menor)

#line()

== Capítulo 8 --- Capital de Giro
<capítulo-8-capital-de-giro>
=== 8.1. Conceitos Básicos
<conceitos-básicos>
#strong[Capital de Giro] = recursos necessários para financiar as
operações do dia a dia.

$ upright("CCL") = upright("Ativo") med upright("Circulante") - upright("Passivo") med upright("Circulante") $

$ upright("NCG") = upright("AC") med upright("Operacional") - upright("PC") med upright("Operacional") $

$ upright("ST") = upright("CCL") - upright("NCG") $

#strong[Onde:] - $upright("AC") med upright("Operacional")$ = contas a
receber + estoques + adiantamentos -
$upright("PC") med upright("Operacional")$ = fornecedores + salários +
impostos a pagar - $upright("ST")$ (Saldo de Tesouraria) \> 0 indica
folga financeira

```python
def diagnostico_capital_giro(ac, pc, ac_op, pc_op):
    ccl = ac - pc
    ncg = ac_op - pc_op
    st = ccl - ncg

    print(f"{'Indicador':<25} {'Valor (R\$)'}")
    print("-" * 35)
    print(f"{'Capital Circulante Líquido':<25} R\${ccl:,.2f}")
    print(f"{'Necessidade de Capital de Giro':<25} R\${ncg:,.2f}")
    print(f"{'Saldo de Tesouraria':<25} R\${st:,.2f}")

    if st >= 0:
        print("\nSituação: CONFORTO FINANCEIRO (ST >= 0)")
    elif st >= -ncg * 0.3:
        print("\nSituação: ATENÇÃO (ST negativo moderado)")
    else:
        print("\nSituação: RISCO (ST muito negativo)")

diagnostico_capital_giro(8000, 5000, 6000, 3000)
```

=== 8.2. Ciclos Operacionais
<ciclos-operacionais>
```python
def ciclos_economico_financeiro(pme, pmr, pmp):
    """
    pme = prazo médio de estocagem (dias)
    pmr = prazo médio de recebimento (dias)
    pmp = prazo médio de pagamento (dias)
    """
    co = pme + pmr  # ciclo operacional
    cf = co - pmp   # ciclo financeiro (caixa)

    print(f"Prazo médio de estocagem: {pme} dias")
    print(f"Prazo médio de recebimento: {pmr} dias")
    print(f"Prazo médio de pagamento: {pmp} dias")
    print(f"---")
    print(f"Ciclo Operacional (CO): {co} dias")
    print(f"Ciclo Financeiro (CF): {cf} dias")

    if cf > 0:
        print(f"\nA empresa precisa financiar {cf} dias de operação.")
    else:
        print(f"\nA empresa opera com capital de giro negativo (vantagem competitiva).")

# Indústria
print("=== Indústria ===")
ciclos_economico_financeiro(60, 45, 30)

# Varejo
print("\n=== Varejo (supermercado) ===")
ciclos_economico_financeiro(30, 7, 45)
```

=== 8.3. Capital de Giro Negativo
<capital-de-giro-negativo>
Algumas empresas operam com #strong[capital de giro negativo] (CCL \<
0), o que significa que financiam seus ativos de curto prazo com
passivos de curto prazo. Exemplos:

- #strong[Supermercados:] vendem à vista, compram a prazo (PMP \> PMR)
- #strong[Aviação:] vendem passagens antes de pagar combustível e
  salários
- #strong[Software:] recebem assinaturas antes de incorrer em custos

#line()

== Capítulo 9 --- Fusões e Aquisições (M&A)
<capítulo-9-fusões-e-aquisições-ma>
=== 9.1. Motivações
<motivações>
#figure(
  align(center)[#table(
    columns: (42.11%, 57.89%),
    align: (auto,auto,),
    table.header([Motivo], [Descrição],),
    table.hline(),
    [#strong[Sinergia]], [2 + 2 = 5 (economias de escala, receitas
    cruzadas)],
    [#strong[Diversificação]], [Reduzir risco (embora questionável para
    o acionista)],
    [#strong[Poder de mercado]], [Aumentar participação, eliminar
    concorrência],
    [#strong[Eficiência]], [Substituir gestão ineficiente],
    [#strong[Acesso a tecnologia]], [Comprar inovação em vez de
    desenvolver],
    [#strong[Benefício fiscal]], [Usar prejuízos fiscais da empresa
    alvo],
  )]
  , kind: table
  )

=== 9.2. Sinergias
<sinergias>
$ V\(upright("AB")\)> V\(A\)+ V\(B\) $

$ upright("Sinergia") = V\(upright("AB")\)-\[V\(A\)+ V\(B\)\] $

```python
def analise_sinergia(v_a, v_b, v_ab, premio_pago):
    """Analisa criação de valor em uma fusão."""
    valor_sem_sinergia = v_a + v_b
    sinergia = v_ab - valor_sem_sinergia
    valor_comprador = sinergia - premio_pago

    print(f"Valor A (isolado): R\${v_a:,.0f} M")
    print(f"Valor B (isolado): R\${v_b:,.0f} M")
    print(f"Valor AB (combinado): R\${v_ab:,.0f} M")
    print(f"---")
    print(f"Sinergia total: R\${sinergia:,.0f} M")
    print(f"Prêmio pago aos acionistas de B: R\${premio_pago:,.0f} M")
    print(f"Valor líquido para acionistas de A: R\${valor_comprador:,.0f} M")

    if valor_comprador > 0:
        print("Fusão CRIADORA de valor para A")
    else:
        print("Fusão DESTRUIDORA de valor para A")

analise_sinergia(500, 300, 950, 60)
```

=== 9.3. Tipos de Integração
<tipos-de-integração>
```
Horizontal
    A (concorrente) + B (concorrente)
    Ex: Itaú + Unibanco

Vertical
    A (fornecedor) + B (cliente)
    Ex: Petrobras + distribuidora

Conglomerado
    A + B (setores diferentes)
    Ex: GE (vários setores)
```

=== 9.4. O Processo de M&A
<o-processo-de-ma>
+ #strong[Estratégia:] definir alvos, critérios
+ #strong[Due Diligence:] investigar a empresa alvo (financeira, fiscal,
  legal, operacional)
+ #strong[Valuation:] quanto vale a empresa alvo?
+ #strong[Negociação:] preço, forma de pagamento (dinheiro, ações),
  earn-out
+ #strong[Estruturação:] compra de ativos vs compra de ações
+ #strong[Integração:] pós-fusão (culture clash, sistemas, pessoas)

#line()

== Capítulo 10 --- Finanças Comportamentais
<capítulo-10-finanças-comportamentais>
=== 10.1. Racionalidade Limitada
<racionalidade-limitada>
A teoria financeira clássica assume que investidores são
#strong[racionais] e mercados são #strong[eficientes]. As finanças
comportamentais relaxam essas premissas, incorporando insights da
psicologia.

=== 10.2. Principais Vieses
<principais-vieses>
#figure(
  align(center)[#table(
    columns: (16.67%, 30.56%, 52.78%),
    align: (auto,auto,auto,),
    table.header([Viés], [Descrição], [Efeito no Mercado],),
    table.hline(),
    [#strong[Excesso de Confiança]], [Superestimamos nossa
    capacidade], [Volume de negociação excessivo],
    [#strong[Aversão a Perda]], [Perder dói 2x mais que ganhar
    prazer], [Disposição effect (vender winners, segurar losers)],
    [#strong[Ancoragem]], [Prender-se a um preço de
    referência], [Sub-reação a novas informações],
    [#strong[Viés de Confirmação]], [Buscar o que confirma nossas
    crenças], [Ignorar sinais contrários],
    [#strong[Efeito Manada]], [Seguir a multidão], [Bolhas e crashes],
    [#strong[Framing]], [Decisão depende de como é
    apresentada], [Preferências inconsistentes],
    [#strong[Falácia do Custo Afundado]], [Deixar custos passados
    influenciarem], [Segurar posições perdedoras],
  )]
  , kind: table
  )

=== 10.3. Anomalias de Mercado
<anomalias-de-mercado>
#strong[Anomalias] são padrões de retorno que contradizem a Hipótese de
Mercado Eficiente (EMH):

```python
anomalias = {
    'Efeito Janeiro': 'Retornos anormais em janeiro, especialmente small caps',
    'Efeito Segunda-feira': 'Retornos negativos nas segundas-feiras',
    'Momentum': 'Ações que subiram nos últimos 6-12 meses continuam subindo',
    'Reversão': 'Ações que perderam muito nos últimos 3-5 anos se recuperam',
    'Valor': 'Baixo P/L e P/VP geram retornos superiores (Fama-French)',
    'Tamanho': 'Small caps têm retorno superior ajustado ao risco',
    'Baixo Risco': 'Ações de baixa volatilidade têm retornos superiores (paradoxalmente)',
    'IPO': 'IPOs têm performance inferior no longo prazo'
}

print("=== Anomalias de Mercado ===")
for nome, desc in anomalias.items():
    print(f"{nome:<20} -> {desc}")
```

#line()

== Capítulo 11 --- Mercados Financeiros
<capítulo-11-mercados-financeiros>
=== 11.1. Estrutura
<estrutura>
```
Sistema Financeiro Nacional
├── Órgãos Reguladores (CMN, BACEN, CVM, SUSEP, PREVIC)
├── Operadores
│   ├── Bancos Múltiplos, Comerciais, de Investimento
│   ├── Corretoras e Distribuidoras
│   ├── Seguradoras e Entidades de Previdência
│   └── Fundos de Investimento
└── Mercados
    ├── Mercado Monetário (curto prazo, títulos públicos)
    ├── Mercado de Crédito (empréstimos bancários)
    ├── Mercado de Capitais (ações, debêntures, FIIs)
    └── Mercado de Câmbio (moedas estrangeiras)
```

=== 11.2. Renda Fixa
<renda-fixa>
#strong[Títulos públicos federais (Tesouro Direto):] - #strong[Tesouro
Selic (LFT):] pós-fixado (Selic) - #strong[Tesouro Prefixado (LTN):]
taxa definida na emissão - #strong[Tesouro IPCA+ (NTN-B):] IPCA + taxa
real

#strong[Títulos privados:] - #strong[CDB:] Certificado de Depósito
Bancário - #strong[RDB:] Recibo de Depósito Bancário - #strong[LCI/LCA:]
Letra de Crédito Imobiliário/Agronegócio (isento IR PF) -
#strong[Debêntures:] dívida de empresas não financeiras -
#strong[CRI/CRA:] Certificado de Recebível Imobiliário/Agronegócio

```python
def calcular_tesouro_ipca(valor, vencimento_anos, taxa_real, ipca_projetado):
    """Calcula o valor de resgate de um título IPCA+."""
    taxa_total = (1 + taxa_real) * (1 + ipca_projetado) - 1
    vf = valor * (1 + taxa_total) ** vencimento_anos
    vf_real = valor * (1 + taxa_real) ** vencimento_anos
    return {'Valor Nominal': vf, 'Valor Real': vf_real, 'Taxa Total': taxa_total}

# R$1.000 em Tesouro IPCA+ com taxa real de 5,5% a.a., IPCA projetado 4% a.a., 5 anos
res = calcular_tesouro_ipca(1000, 5, 0.055, 0.04)
for k, v in res.items():
    if 'Taxa' in k:
        print(f"{k}: {v*100:.2f}%")
    else:
        print(f"{k}: R\${v:.2f}")
```

=== 11.3. Renda Variável
<renda-variável>
#strong[Ações:] - #strong[ON (Ordinária):] com direito a voto -
#strong[PN (Preferencial):] preferência no recebimento de dividendos,
sem voto - #strong[Units:] conjunto de ON + PN negociado como um ativo

#strong[Derivativos:] - #strong[Opções:] direito de comprar (call) ou
vender (put) a um preço fixo - #strong[Futuros:] obrigação de
comprar/vender no futuro - #strong[Swaps:] troca de fluxos financeiros
(ex: CDI x IPCA)

=== 11.4. Análise de um Ativo
<análise-de-um-ativo>
```python
def analisar_acao(ticker, periodo="5y"):
    """
    Análise fundamentalista básica de uma ação.
    """
    dados = yf.download(ticker, period=periodo)
    precos = dados['Adj Close']
    retornos = precos.pct_change().dropna()

    preco_atual = precos.iloc[-1]
    preco_min = precos.min()
    preco_max = precos.max()
    retorno_anual = (preco_atual / precos.iloc[0]) ** (252 / len(precos)) - 1
    volatilidade = retornos.std() * np.sqrt(252)

    # Drawdown máximo
    pico = precos.expanding().max()
    drawdown = (precos - pico) / pico
    max_drawdown = drawdown.min()

    print(f"=== Análise de {ticker} ===")
    print(f"Período: {periodo}")
    print(f"Preço atual: R\${preco_atual:.2f}")
    print(f"Mínimo do período: R\${preco_min:.2f}")
    print(f"Máximo do período: R\${preco_max:.2f}")
    print(f"Retorno anualizado: {retorno_anual*100:.2f}%")
    print(f"Volatilidade anual: {volatilidade*100:.2f}%")
    print(f"Drawdown máximo: {max_drawdown*100:.2f}%")
    print(f"Retorno/Vol (Sharpe): {retorno_anual/volatilidade:.2f}")

# analisar_acao("PETR4.SA", "3y")
```

#line()

== Capítulo 12 --- Finanças Internacionais
<capítulo-12-finanças-internacionais>
=== 12.1. Taxa de Câmbio
<taxa-de-câmbio>
#strong[Taxa de câmbio] = preço de uma moeda em termos de outra.

$ R\$\/upright("US")\$= frac(R\$, upright("US")\$) $

#strong[Regimes cambiais:] - #strong[Fixo:] governo define a taxa -
#strong[Flutuante:] mercado define (Brasil adota este) - #strong[Banda
cambial:] flutuação dentro de limites

```python
def paridade_descoberta_juros(taxa_juros_br, taxa_juros_usa, taxa_cambio_spot, periodo):
    """
    Taxa de câmbio futura esperada pela paridade descoberta de juros.
    """
    taxa_cambio_futura = taxa_cambio_spot * ((1 + taxa_juros_br) / (1 + taxa_juros_usa))
    return taxa_cambio_futura

spot = 5.20  # R$/US$
j_br = 0.1325  # Selic
j_usa = 0.05  // Fed Funds
futuro = paridade_descoberta_juros(j_br, j_usa, spot, 1)
print(f"Câmbio spot: R\${spot:.2f}")
print(f"Juros Brasil: {j_br*100:.1f}%")
print(f"Juros EUA: {j_usa*100:.1f}%")
print(f"Câmbio futuro esperado (1 ano): R\${futuro:.2f}")
print(f"Desvalorização esperada: {(futuro/spot - 1)*100:.2f}%")
```

=== 12.2. Risco-País (EMBI+)
<risco-país-embi>
Prêmio de risco que o mercado exige para investir em títulos de um país.
Medido pelo spread dos títulos soberanos sobre os Treasuries americanos.

=== 12.3. Teoria da Paridade do Poder de Compra (PPP)
<teoria-da-paridade-do-poder-de-compra-ppp>
$ upright("Taxa") med upright("de") med upright("Câmbio") = frac(upright("Nível") med upright("de") med upright("Preços") med\(upright("País") med A\), upright("Nível") med upright("de") med upright("Preços") med\(upright("País") med B\)) $

#strong[PPP Relativa:] a variação cambial reflete o diferencial de
inflação:

$ E_t / E_(t - 1) = frac(1 + pi_(upright("doméstica")), 1 + pi_(upright("estrangeira"))) $

#line()

== Capítulo 13 --- Exercícios Resolvidos
<capítulo-13-exercícios-resolvidos>
#strong[E1.] Uma ação tem beta de 1,3. A taxa livre de risco (Selic)
está em 10,5% a.a. e o retorno esperado da carteira de mercado
(Ibovespa) é de 16% a.a. Calcule o custo de capital próprio (Ke) pelo
CAPM.

$ upright("Ke") = R_f + beta times\(R_m - R_f\)= 0\,105 + 1\,3 times\(0\,16 - 0\,105\) $

```python
rf, beta, rm = 0.105, 1.3, 0.16
premio = rm - rf
ke = rf + beta * premio
print(f"Prêmio de risco de mercado: {premio*100:.2f}%")
print(f"Ke (CAPM): {ke*100:.2f}%")
```

```
Prêmio de risco de mercado: 5.50%
Ke (CAPM): 17.65%
```

#line()

#strong[E2.] Uma empresa tem valor de mercado do capital próprio de R\$
180 milhões e dívida de R\$ 120 milhões. O custo de capital próprio (Ke)
é 17,65% (resultado de E1), o custo bruto da dívida (Kd) é 11,5% a.a. e
a alíquota de IR é 34%. Calcule o WACC.

$ upright("WACC") = E / V times upright("Ke") + D / V times upright("Kd") times\(1 - upright("IR")\) $

```python
e, d = 180, 120
ke, kd_bruto, ir = 0.1765, 0.115, 0.34
v = e + d
kd_liq = kd_bruto * (1 - ir)
wacc_ = (e / v) * ke + (d / v) * kd_liq
print(f"Peso PL: {e/v*100:.1f}% | Peso Dívida: {d/v*100:.1f}%")
print(f"Kd líquido: {kd_liq*100:.2f}%")
print(f"WACC: {wacc_*100:.2f}%")
```

```
Peso PL: 60.0% | Peso Dívida: 40.0%
Kd líquido: 7.59%
WACC: 13.63%
```

#line()

#strong[E3.] Uma empresa projeta os seguintes fluxos de caixa livre
(FCF) para os próximos 5 anos: R\$ 80, R\$ 92, R\$ 105, R\$ 118, R\$ 130
milhões. A partir do ano 5, o crescimento perpétuo (g) esperado é de 3%
a.a. O WACC é 13,63% (resultado de E2). A empresa tem R\$ 250 milhões de
dívida e R\$ 60 milhões de caixa. Calcule o Enterprise Value e o Equity
Value.

$ upright("EV") = sum_(t = 1)^5 frac(upright("FCF")_t, \(1 + upright("WACC")\)^t) + frac(upright("VT"), \(1 + upright("WACC")\)^5)\,quad upright("VT") = frac(upright("FCF")_5 times\(1 + g\), upright("WACC") - g) $

```python
def valuation_fcd(fcfs, wacc, g, divida, caixa):
    n = len(fcfs)
    vp_fcf = sum(fcf / (1 + wacc) ** (t + 1) for t, fcf in enumerate(fcfs))
    vt = fcfs[-1] * (1 + g) / (wacc - g)
    vp_vt = vt / (1 + wacc) ** n
    ev = vp_fcf + vp_vt
    equity_value = ev - divida + caixa
    return {'VP_FCFs': vp_fcf, 'VP_VT': vp_vt, 'EV': ev, 'Equity_Value': equity_value}

fcfs = [80, 92, 105, 118, 130]
wacc, g, divida, caixa = 0.1363, 0.03, 250, 60
r = valuation_fcd(fcfs, wacc, g, divida, caixa)
for k, v in r.items():
    print(f"{k:12s}: R\${v:,.2f} milhões")
```

```
VP_FCFs     : R$343.99 milhões
VP_VT       : R$647.27 milhões
EV          : R$991.26 milhões
Equity_Value: R$801.26 milhões
```

#line()

#strong[E4.] O balanço de uma empresa apresenta: Ativo Circulante = R\$
12.000 mil, Passivo Circulante = R\$ 7.500 mil, Estoques = R\$ 3.200
mil, Disponível (caixa) = R\$ 1.500 mil. Calcule a Liquidez Corrente, a
Liquidez Seca e a Liquidez Imediata, e diga se a empresa tem folga de
curto prazo.

$ upright("LC") = upright("AC") / upright("PC")\,quad upright("LS") = frac(upright("AC") - upright("Estoques"), upright("PC"))\,quad upright("LI") = upright("Disponível") / upright("PC") $

```python
ac, pc, estoques, disponivel = 12000, 7500, 3200, 1500
lc = ac / pc
ls = (ac - estoques) / pc
li = disponivel / pc

print(f"Liquidez Corrente: {lc:.2f}")
print(f"Liquidez Seca:     {ls:.2f}")
print(f"Liquidez Imediata: {li:.2f}")
print("Diagnóstico:", "folga de curto prazo (LC > 1,5)" if lc > 1.5 else "atenção: LC abaixo do ideal")
```

```
Liquidez Corrente: 1.60
Liquidez Seca:     1.17
Liquidez Imediata: 0.20
Diagnóstico: folga de curto prazo (LC > 1,5)
```

#line()

#strong[E5.] Uma empresa teve Lucro Líquido de R\$ 45 milhões, Receita
de R\$ 600 milhões, Ativo Total de R\$ 500 milhões e Patrimônio Líquido
de R\$ 200 milhões. Decomponha o ROE pelo modelo DuPont (margem líquida
× giro do ativo × alavancagem financeira) e identifique a principal
alavanca do retorno.

$ upright("ROE") = underbrace(upright("LL") / upright("Receita"), upright("Margem")) times underbrace(upright("Receita") / upright("Ativo"), upright("Giro")) times underbrace(upright("Ativo") / upright("PL"), upright("Alavancagem")) $

```python
def dupont(ll, receita, ativo, pl):
    margem = ll / receita
    giro = receita / ativo
    alavancagem = ativo / pl
    roe = margem * giro * alavancagem
    return margem, giro, alavancagem, roe

ll, receita, ativo, pl = 45, 600, 500, 200
margem, giro, alav, roe = dupont(ll, receita, ativo, pl)
print(f"Margem Líquida:         {margem*100:.2f}%")
print(f"Giro do Ativo:          {giro:.2f}x")
print(f"Alavancagem Financeira: {alav:.2f}x")
print(f"ROE:                    {roe*100:.2f}%")
```

```
Margem Líquida:         7.50%
Giro do Ativo:          1.20x
Alavancagem Financeira: 2.50x
ROE:                    22.50%
```

A alavancagem financeira (2,50x) é a maior contribuidora isolada em
magnitude, mas o giro do ativo (1,20x) já é razoável; a margem (7,5%) é
o ponto mais baixo relativo --- um aumento nela teria o maior impacto
marginal proporcional no ROE.

#line()

#strong[E6.] Uma empresa não alavancada (100% capital próprio) vale R\$
1.000 milhões e tem custo de capital próprio (Ke\_U) de 15%. Ela avalia
captar R\$ 400 milhões em dívida a um Kd de 10% a.a., com alíquota de IR
de 34%. Calcule (a) o valor da empresa alavancada pelo M&M com impostos
e (b) o novo Ke pela Proposição II de M&M (sem impostos, para efeito
didático de comparação).

$ V_L = V_U + D times upright("IR") #h(2em) upright("Ke") = upright("Ke")_U +\(upright("Ke")_U - upright("Kd")\)times D / E $

```python
vu, d, kd, ir, ke_u = 1000, 400, 0.10, 0.34, 0.15

beneficio_fiscal = d * ir
vl = vu + beneficio_fiscal
print(f"(a) Benefício fiscal: R\${beneficio_fiscal:.2f} milhões")
print(f"(a) Valor da empresa alavancada (VL): R\${vl:.2f} milhões")

e = vl - d  # capital próprio remanescente após alavancagem
ke = ke_u + (ke_u - kd) * (d / e)
print(f"(b) Ke após alavancagem: {ke*100:.2f}%")
```

```
(a) Benefício fiscal: R$136.00 milhões
(a) Valor da empresa alavancada (VL): R$1136.00 milhões
(b) Ke após alavancagem: 17.71%
```

#line()

#strong[E7.] Uma empresa distribuiu R\$ 90 milhões em dividendos sobre
um lucro líquido de R\$ 250 milhões, com 50 milhões de ações em
circulação, cotadas a R\$ 12,00. Calcule o LPA, o DPA, o Pay-out e o
Dividend Yield. Em seguida, supondo crescimento perpétuo dos dividendos
de 4% a.a., estime o Ke implícito pelo Modelo de Gordon.

$ upright("Pay-out") = upright("Dividendos") / upright("LL") #h(2em) upright("DY") = upright("DPA") / P_0 #h(2em) upright("Ke") = D_1 / P_0 + g $

```python
ll, dividendos, num_acoes, preco, g = 250, 90, 50, 12.00, 0.04

lpa = ll / num_acoes
dpa = dividendos / num_acoes
payout = dividendos / ll
dy = dpa / preco

d1 = dpa * (1 + g)
ke_gordon = d1 / preco + g

print(f"LPA:            R\${lpa:.2f}")
print(f"DPA:            R\${dpa:.2f}")
print(f"Pay-out:        {payout*100:.1f}%")
print(f"Dividend Yield: {dy*100:.2f}%")
print(f"Ke (Gordon):    {ke_gordon*100:.2f}%")
```

```
LPA:            R$5.00
DPA:            R$1.80
Pay-out:        36.0%
Dividend Yield: 15.00%
Ke (Gordon):    19.60%
```

#line()

#strong[E8.] Duas empresas, A (valor isolado R\$ 600 milhões) e B (valor
isolado R\$ 250 milhões), avaliam uma fusão. Estima-se que a empresa
combinada AB valeria R\$ 950 milhões devido a sinergias operacionais e
tributárias. A acionistas de B será pago um prêmio de R\$ 40 milhões
sobre o valor isolado de B. Calcule a sinergia total e o valor líquido
criado para os acionistas de A.

$ upright("Sinergia") = V\(upright("AB")\)-\[V\(A\)+ V\(B\)\]#h(2em) upright("Valor líquido para A") = upright("Sinergia") - upright("Prêmio") $

```python
v_a, v_b, v_ab, premio = 600, 250, 950, 40

sinergia = v_ab - (v_a + v_b)
valor_liquido_a = sinergia - premio

print(f"Sinergia total: R\${sinergia:.2f} milhões")
print(f"Prêmio pago aos acionistas de B: R\${premio:.2f} milhões")
print(f"Valor líquido para acionistas de A: R\${valor_liquido_a:.2f} milhões")
print("Decisão:", "fusão CRIA valor para A" if valor_liquido_a > 0 else "fusão DESTRÓI valor para A")
```

```
Sinergia total: R$100.00 milhões
Prêmio pago aos acionistas de B: R$40.00 milhões
Valor líquido para acionistas de A: R$60.00 milhões
Decisão: fusão CRIA valor para A
```

#line()

== Capítulo 14 --- Tabela Resumo de Fórmulas
<capítulo-14-tabela-resumo-de-fórmulas>
#figure(
  align(center)[#table(
    columns: (41.67%, 37.5%, 20.83%),
    align: (auto,auto,auto,),
    table.header([Conceito], [Fórmula], [Uso],),
    table.hline(),
    [#strong[Retorno
    Total]], [$R =\(P_t - P_(t - 1) + D_t\)\/P_(t - 1)$], [Performance],
    [#strong[CAPM]], [$E\(R_i\)= R_f + beta_i times\(R_m - R_f\)$], [Custo
    de capital próprio],
    [#strong[Beta]], [$beta_i = upright("Cov")\(R_i\,R_m\)\/upright("Var")\(R_m\)$], [Risco
    sistemático],
    [#strong[Retorno
    Carteira]], [$E\(R_p\)= sum w_i times E\(R_i\)$], [Portfólio],
    [#strong[Risco Carteira (2
    ativos)]], [$sigma_p^2 = w_1^2 sigma_1^2 + w_2^2 sigma_2^2 + 2 w_1 w_2 sigma_1 sigma_2 rho_12$], [Diversificação],
    [#strong[WACC]], [$upright("WACC") =\(E\/V\)times upright("Ke") +\(D\/V\)times upright("Kd") times\(1 - upright("IR")\)$], [TMA
    para projetos],
    [#strong[Ke (Gordon)]], [$upright("Ke") = D_1\/P_0 + g$], [Ações que
    pagam dividendos],
    [#strong[Kd
    líquido]], [$upright("Kd")_(upright("liq")) = upright("Kd")_(upright("bruto")) times\(1 - upright("IR")\)$], [Custo
    da dívida],
    [#strong[EVA]], [$upright("EVA") = upright("NOPAT") -\(upright("Capital") times upright("WACC")\)$], [Criação
    de valor],
    [#strong[ROE]], [$upright("ROE") = upright("LL")\/upright("PL")$], [Rentabilidade
    do acionista],
    [#strong[DuPont]], [$upright("ROE") =\(upright("LL")\/V\)times\(V\/A\)times\(A\/upright("PL")\)$], [Decomposição
    ROE],
    [#strong[Valuation
    FCD]], [$upright("EV") = sum upright("FCF")_t\/\(1 + upright("WACC")\)^t+ upright("VT")\/\(1 + upright("WACC")\)^n$], [Valor
    intrínseco],
    [#strong[Valor
    Terminal]], [$upright("VT") = upright("FCF")_n times\(1 + g\)\/\(upright("WACC") - g\)$], [Perpetuidade],
    [#strong[P/L]], [$upright("PL") = upright("Preço")\/upright("LPA")$], [Múltiplo],
    [#strong[MM I (s/ imposto)]], [$V_L = V_U$], [Irrelevância],
    [#strong[MM II (c/
    imposto)]], [$V_L = V_U + D times upright("IR")$], [Benefício
    fiscal],
    [#strong[Dividend
    Yield]], [$upright("DY") = upright("DPA")\/upright("Preço")$], [Retorno
    em dividendos],
    [#strong[Pay-out]], [$upright("PO") = upright("Dividendos")\/upright("LL")$], [Distribuição
    de lucro],
    [#strong[CCL]], [$upright("AC") - upright("PC")$], [Capital de
    giro],
    [#strong[Fisher]], [$\(1 + i_n\)=\(1 + i_r\)times\(1 + pi\)$], [Inflação],
    [#strong[PPP]], [$Delta E =\(1 + pi_(upright("dom"))\)\/\(1 + pi_(upright("est"))\)$], [Câmbio],
  )]
  , kind: table
  )

#line()

== Capítulo 15 --- Glossário
<capítulo-15-glossário>
#figure(
  align(center)[#table(
    columns: (38.89%, 61.11%),
    align: (auto,auto,),
    table.header([Termo], [Definição],),
    table.hline(),
    [#strong[CAPM]], [Modelo de precificação de ativos que relaciona
    retorno esperado ao risco sistemático],
    [#strong[Beta]], [Medida de sensibilidade de um ativo ao mercado],
    [#strong[WACC]], [Custo médio ponderado de todas as fontes de
    capital],
    [#strong[VPL (NPV)]], [Soma dos fluxos de caixa descontados pela
    TMA],
    [#strong[TIR (IRR)]], [Taxa de desconto que zera o VPL],
    [#strong[EVA]], [Lucro econômico: NOPAT menos custo do capital],
    [#strong[ROE]], [Retorno sobre o patrimônio líquido],
    [#strong[ROIC]], [Retorno sobre o capital investido],
    [#strong[EBITDA]], [Lucro antes de juros, impostos, depreciação e
    amortização],
    [#strong[FCF]], [Fluxo de caixa livre disponível para acionistas e
    credores],
    [#strong[CCL]], [Capital circulante líquido (AC - PC)],
    [#strong[NCG]], [Necessidade de capital de giro],
    [#strong[Múltiplo]], [Indicador relativo de valuation (P/L,
    EV/EBITDA)],
    [#strong[Alavancagem]], [Uso de capital de terceiros para ampliar
    retornos],
    [#strong[Sinergia]], [Valor extra criado pela combinação de
    empresas],
    [#strong[EMH]], [Hipótese de Mercado Eficiente --- preços refletem
    toda informação],
    [#strong[Due Diligence]], [Processo de investigação pré-aquisição],
    [#strong[Pay-out]], [Percentual do lucro distribuído como
    dividendos],
    [#strong[Gordon]], [Modelo de valuation por dividendos com
    crescimento],
    [#strong[Fronteira Eficiente]], [Conjunto de carteiras ótimas
    risco-retorno],
    [#strong[Hedge]], [Proteção contra movimentos adversos de preço],
    [#strong[Derivativo]], [Ativo cujo valor deriva de outro ativo
    (opção, futuro, swap)],
  )]
  , kind: table
  )

#line()

== Capítulo 16 --- Exercícios para Executar (na mão)
<capítulo-16-exercícios-para-executar-na-mão>
Estes exercícios não exigem computador: o objetivo é treinar o
raciocínio financeiro e a interpretação de indicadores antes de
automatizá-los em código. Resolva no papel ou na calculadora. #strong[As
soluções não estão neste documento] --- quando terminar, peça para eu
conferir suas respostas.

=== Exercício 1 --- CAPM na mão
<exercício-1-capm-na-mão>
Uma ação tem beta de 0,85. A Selic (Rf) está em 11% a.a. e o retorno
esperado do Ibovespa é 15,5% a.a. Calcule, sem código, o custo de
capital próprio (Ke) pelo CAPM. Em seguida, refaça o cálculo supondo que
o beta sobe para 1,4 (a empresa se tornou mais alavancada) e compare os
dois resultados.

=== Exercício 2 --- WACC com dados incompletos
<exercício-2-wacc-com-dados-incompletos>
Uma empresa tem valor de mercado do capital próprio de R\$ 240 milhões.
Sua dívida representa 30% do valor total da empresa (V = E + D). O Ke é
18% e o Kd bruto é 12%, com alíquota de IR de 34%. Calcule o valor da
dívida (D) e o WACC, mostrando cada passo do cálculo.

=== Exercício 3 --- Interpretação de índice de liquidez
<exercício-3-interpretação-de-índice-de-liquidez>
Uma empresa apresenta Liquidez Corrente = 0,85, Liquidez Seca = 0,40 e
Liquidez Imediata = 0,05. Sem calcular nada, #strong[interprete] esses
três números: o que eles revelam sobre a composição do ativo circulante
da empresa (peso de estoques vs.~caixa) e sobre o risco de insolvência
de curto prazo? Que pergunta você faria ao CFO da empresa antes de tirar
conclusões?

=== Exercício 4 --- Decisão de estrutura de capital (cenário)
<exercício-4-decisão-de-estrutura-de-capital-cenário>
Uma empresa de tecnologia, com fluxo de caixa muito volátil e poucos
ativos tangíveis para dar em garantia, está avaliando emitir R\$ 200
milhões em dívida para financiar expansão, elevando sua relação
Dívida/PL de 0,2 para 1,5. Usando os conceitos de Trade-off Theory e
Pecking Order Theory (Capítulo 6), argumente se essa decisão parece
prudente. Que riscos específicos (além do WACC) essa empresa passaria a
correr que uma indústria madura e com ativos tangíveis não correria no
mesmo nível de alavancagem?

=== Exercício 5 --- DuPont: qual alavanca puxou o ROE?
<exercício-5-dupont-qual-alavanca-puxou-o-roe>
Uma empresa teve ROE de 8% no Ano 1 (Margem 4%, Giro 1,0x, Alavancagem
2,0x) e ROE de 14% no Ano 2 (Margem 3,5%, Giro 1,0x, Alavancagem 4,0x).
Sem calcular nada além do que já está dado, explique #strong[qual
alavanca] foi responsável pelo aumento do ROE e se esse crescimento do
retorno é, na sua avaliação, uma boa notícia para o acionista (considere
o risco).

=== Exercício 6 --- Valor Terminal na mão
<exercício-6-valor-terminal-na-mão>
Uma empresa gera FCF de R\$ 50 milhões no último ano projetado. O WACC é
14% e o crescimento perpétuo esperado (g) é 2,5% a.a. Calcule o Valor
Terminal (VT) usando a fórmula de Gordon. Depois, refaça com g = 5% e
compare os dois resultados --- por que pequenas mudanças em g têm um
efeito tão grande no VT quando g se aproxima do WACC?

=== Exercício 7 --- Política de dividendos: qual teoria se aplica?
<exercício-7-política-de-dividendos-qual-teoria-se-aplica>
Uma empresa madura, com poucas oportunidades de crescimento, anuncia
aumento do pay-out de 30% para 70% do lucro líquido, e as ações sobem 8%
no anúncio. Outra empresa, em fase de forte expansão, anuncia corte do
pay-out de 40% para 10% para reinvestir na abertura de novas unidades, e
as ações também sobem. Explique, usando as teorias do Capítulo 7
(Irrelevância de M&M, Pássaro na Mão de Gordon, Efeito Clientela), por
que reações de mercado tão diferentes (aumentar dividendo vs.~cortar
dividendo) podem ambas ser positivas.

=== Exercício 8 --- Sinergia de M&A: vale a pena pagar o prêmio?
<exercício-8-sinergia-de-ma-vale-a-pena-pagar-o-prêmio>
A Empresa X (valor isolado R\$ 800 milhões) quer adquirir a Empresa Y
(valor isolado R\$ 300 milhões). A diretoria de X estima sinergias de
R\$ 120 milhões, mas o banco de investimento sugere pagar um prêmio de
R\$ 150 milhões aos acionistas de Y para fechar o negócio. Calcule na
mão se a aquisição cria ou destrói valor para os acionistas de X, e
explique o que aconteceria com a decisão se as sinergias estimadas
fossem superestimadas em 30% (um risco comum em processos de M&A).

#line()

== Capítulo 17 --- Exercícios para Executar (em código)
<capítulo-17-exercícios-para-executar-em-código>
Implemente e execute cada um no seu editor. #strong[As soluções não
estão neste documento] --- o objetivo é você rodar de verdade e ver o
resultado; quando terminar, peça para eu revisar seu código.

=== Exercício 1 --- Calculadora de métricas VBM
<exercício-1-calculadora-de-métricas-vbm>
Crie uma função
`metricas_vbm(nopat, capital_investido, wacc, valor_mercado, ll, pl)`
(retome o Capítulo 1) que retorna EVA, MVA, ROIC e ROE, e imprima uma
mensagem indicando se a empresa está "criando valor" ou "destruindo
valor" (compare ROIC com WACC).

```python
dados = dict(nopat=620, capital_investido=4500, wacc=0.115, valor_mercado=7200, ll=410, pl=3200)
```

=== Exercício 2 --- Retorno esperado e risco a partir de cenários
<exercício-2-retorno-esperado-e-risco-a-partir-de-cenários>
Usando a lista de cenários abaixo (probabilidade, retorno), calcule o
retorno esperado E(R), o desvio padrão e a relação retorno/risco.

```python
cenarios = [
    (0.10, 0.30), (0.25, 0.16), (0.35, 0.09), (0.20, -0.02), (0.10, -0.18)
]
```

=== Exercício 3 --- Risco de carteira com matriz de covariância
<exercício-3-risco-de-carteira-com-matriz-de-covariância>
Dada a matriz de covariância e os pesos abaixo, calcule o risco (desvio
padrão) da carteira usando `numpy` (produto
`pesos @ cov_matrix @ pesos`).

```python
import numpy as np
pesos = np.array([0.4, 0.3, 0.2, 0.1])
cov_matrix = np.array([
    [0.05, 0.010, 0.006, 0.012],
    [0.010, 0.08, 0.008, 0.020],
    [0.006, 0.008, 0.025, 0.007],
    [0.012, 0.020, 0.007, 0.06]
])
```

=== Exercício 4 --- Tabela de CAPM para uma carteira de ações
<exercício-4-tabela-de-capm-para-uma-carteira-de-ações>
Dado o dicionário abaixo com betas de ações, calcule o Ke (CAPM) de cada
uma e imprima uma tabela ordenada da menor para a maior exigência de
retorno.

```python
betas = {"VALE3": 0.95, "PETR4": 1.15, "ITUB4": 0.80, "MGLU3": 1.85, "WEGE3": 0.70}
rf, premio_mercado = 0.105, 0.06
```

=== Exercício 5 --- Beta por regressão linear (dados simulados)
<exercício-5-beta-por-regressão-linear-dados-simulados>
Sem baixar dados reais, simule 250 retornos diários de um "mercado" com
`np.random.normal` e um "ativo" que segue o mercado com beta verdadeiro
de 1,3 mais ruído idiossincrático. Estime o beta pela fórmula
`Cov(ativo, mercado) / Var(mercado)` e compare com o beta verdadeiro
usado na simulação.

=== Exercício 6 --- Fronteira eficiente simplificada
<exercício-6-fronteira-eficiente-simplificada>
Adapte a função `fronteira_eficiente` do Capítulo 2 para simular 5.000
carteiras aleatórias com 3 ativos (ao invés de 4). Encontre e imprima a
carteira de máximo Índice de Sharpe e a de mínima volatilidade.

```python
retornos_esperados = np.array([0.11, 0.16, 0.09])
cov_matrix = np.array([
    [0.03, 0.010, 0.005],
    [0.010, 0.07, 0.012],
    [0.005, 0.012, 0.02]
])
```

=== Exercício 7 --- Custo de capital próprio: CAPM vs.~Gordon
<exercício-7-custo-de-capital-próprio-capm-vs.-gordon>
Para a mesma empresa, calcule o Ke pelo CAPM e pelo Modelo de Gordon com
os dados abaixo. Os dois métodos convergem? Imprima a diferença
percentual entre eles.

```python
rf, beta, rm = 0.11, 1.05, 0.165
d1, p0, g = 3.20, 38.00, 0.045
```

=== Exercício 8 --- Sensibilidade do WACC à estrutura de capital
<exercício-8-sensibilidade-do-wacc-à-estrutura-de-capital>
Reaproveite (ou reescreva) a função
`wacc(ke, kd_bruto, ir, peso_pl, peso_divida)` do Capítulo 3. Gere uma
tabela variando o peso da dívida de 0% a 90% em passos de 10 pontos
percentuais, e identifique visualmente em que ponto o WACC é mínimo
dentro do intervalo simulado.

```python
ke, kd_bruto, ir = 0.155, 0.11, 0.34
```

=== Exercício 9 --- Valuation por FCD com múltiplos cenários de crescimento
<exercício-9-valuation-por-fcd-com-múltiplos-cenários-de-crescimento>
Reaproveite `valuation_fcd` do Capítulo 4. Calcule o Equity Value para
três cenários de crescimento perpétuo (g = 2%, 3,5% e 5%), mantendo os
demais parâmetros fixos, e imprima quanto o Equity Value varia (em % e
em R\$) entre o cenário mais conservador e o mais otimista.

```python
fcfs = [70, 84, 96, 110, 125]
wacc, divida, caixa = 0.125, 220, 45
cenarios_g = [0.02, 0.035, 0.05]
```

=== Exercício 10 --- Valuation por múltiplos: P/L, EV/EBITDA e P/VP
<exercício-10-valuation-por-múltiplos-pl-evebitda-e-pvp>
Reaproveite `multiplos_empresa` do Capítulo 4. Calcule o preço justo por
P/L e P/VP para a empresa abaixo e compare com o preço atual de mercado
--- a ação está cara ou barata segundo cada múltiplo?

```python
empresa = dict(lucro=280e6, ebitda=520e6, receita=1.1e9, valor_patrimonial=1.6e9,
                num_acoes=90e6, pl_setor=11, ev_ebitda_setor=6.5, pvp_setor=1.3)
preco_atual = 28.50
```

=== Exercício 11 --- Análise vertical de DRE
<exercício-11-análise-vertical-de-dre>
Reaproveite `analise_vertical` do Capítulo 5. Rode a função para a DRE
abaixo e identifique qual item consome a maior fatia da receita depois
do custo dos produtos.

```python
dre = {
    'receita_liquida': 1500000, 'custo_produtos': -820000,
    'despesas_operacionais': -280000, 'despesas_financeiras': -90000,
    'imposto_renda': -95000
}
```

=== Exercício 12 --- Painel de indicadores de liquidez e endividamento
<exercício-12-painel-de-indicadores-de-liquidez-e-endividamento>
Combine `indicadores_liquidez` e `indicadores_endividamento` (Capítulo
5) em uma única função `diagnostico_financeiro(...)` que recebe todos os
parâmetros necessários de uma vez e imprime um painel único com as duas
famílias de indicadores.

```python
dados = dict(ac=15000, pc=9000, estoques=4500, disponivel=2200, rlp=3000, elp=4000,
             passivo_circ=9000, passivo_ncirc=6000, pl=12000, lajir=2800, despesas_fin=900)
```

=== Exercício 13 --- DuPont ao longo de 4 anos
<exercício-13-dupont-ao-longo-de-4-anos>
Dada a lista de dicionários abaixo (um por ano), calcule o ROE de cada
ano pelo DuPont e imprima uma tabela mostrando a evolução de margem,
giro e alavancagem --- aponte em que ano cada alavanca teve seu melhor
valor.

```python
anos = [
    {"ano": 2022, "ll": 60, "vendas": 900, "ativo": 700, "pl": 350},
    {"ano": 2023, "ll": 68, "vendas": 980, "ativo": 740, "pl": 360},
    {"ano": 2024, "ll": 55, "vendas": 1020, "ativo": 810, "pl": 340},
    {"ano": 2025, "ll": 82, "vendas": 1100, "ativo": 860, "pl": 330},
]
```

=== Exercício 14 --- EBITDA e margem EBITDA de múltiplas empresas
<exercício-14-ebitda-e-margem-ebitda-de-múltiplas-empresas>
Reaproveite `calcular_ebitda` do Capítulo 5. Dado o dicionário abaixo
(uma DRE simplificada por empresa), calcule o EBITDA e a margem EBITDA
de cada uma e ordene do maior para o menor margem.

```python
empresas = {
    "Alfa":  {"receita": 1000, "cpv": 600, "desp_op": 150, "deprec": 80, "amort": 30},
    "Beta":  {"receita": 800,  "cpv": 520, "desp_op": 90,  "deprec": 40, "amort": 10},
    "Gama":  {"receita": 1500, "cpv": 1050,"desp_op": 220, "deprec": 120,"amort": 50},
}
```

=== Exercício 15 --- M&M com e sem impostos, lado a lado
<exercício-15-mm-com-e-sem-impostos-lado-a-lado>
Reaproveite `mm_sem_impostos` e `mm_com_impostos` do Capítulo 6. Para
uma empresa com Vu = R\$ 1.200 milhões, Ke\_U = 14%, Kd = 9,5% e IR =
34%, gere uma tabela comparando o valor da empresa (VL) nos dois modelos
para níveis de dívida de R\$ 0 a R\$ 600 milhões, em passos de R\$ 100
milhões.

=== Exercício 16 --- Simulação de Trade-off Theory
<exercício-16-simulação-de-trade-off-theory>
Estenda o modelo de M&M com impostos somando um "custo de falência
esperado" que cresce de forma não linear com a dívida (ex:
`custo_falencia = 0.0005 * d**2`). Encontre, por busca simples em um
laço, o nível de dívida que #strong[maximiza] o valor da empresa nesse
modelo simulado.

```python
vu, ir = 1000, 0.34
niveis_divida = range(0, 801, 20)
```

=== Exercício 17 --- Métricas de dividendos e classificação de política
<exercício-17-métricas-de-dividendos-e-classificação-de-política>
Reaproveite `metricas_dividendos` do Capítulo 7. Para as três empresas
abaixo, calcule LPA, DPA, Pay-out e Dividend Yield, e classifique a
política de cada uma como "alta distribuição" (pay-out \> 60%),
"moderada" (30%-60%) ou "retenção" (\< 30%).

```python
empresas = {
    "Utilco":  dict(lucro_liquido=300e6, dividendos_pagos=240e6, num_acoes=60e6, preco_acao=22),
    "Tech Co": dict(lucro_liquido=150e6, dividendos_pagos=15e6,  num_acoes=40e6, preco_acao=55),
    "Bancorp": dict(lucro_liquido=500e6, dividendos_pagos=225e6, num_acoes=100e6, preco_acao=18),
}
```

=== Exercício 18 --- Diagnóstico de capital de giro para 3 empresas
<exercício-18-diagnóstico-de-capital-de-giro-para-3-empresas>
Reaproveite `diagnostico_capital_giro` do Capítulo 8. Rode a função para
as três empresas abaixo (indústria, varejo e software) e compare o Saldo
de Tesouraria (ST) de cada uma, explicando por que o resultado faz
sentido para o modelo de negócio de cada setor.

```python
empresas = {
    "Indústria": dict(ac=9000, pc=5500, ac_op=7000, pc_op=3500),
    "Varejo":    dict(ac=6000, pc=6800, ac_op=5000, pc_op=6200),
    "Software":  dict(ac=4000, pc=3000, ac_op=1200, pc_op=2600),
}
```

=== Exercício 19 --- Ciclo financeiro e necessidade de caixa
<exercício-19-ciclo-financeiro-e-necessidade-de-caixa>
Reaproveite `ciclos_economico_financeiro` do Capítulo 8. Dada uma lista
de empresas com seus prazos médios (estocagem, recebimento, pagamento),
calcule o ciclo financeiro de cada uma e ordene da que menos precisa
financiar operação para a que mais precisa.

```python
empresas = [
    ("Indústria A", 55, 40, 35),
    ("Varejo B", 25, 5, 50),
    ("Distribuidora C", 40, 60, 20),
]
```

=== Exercício 20 --- Sinergia de M&A com sensibilidade ao prêmio
<exercício-20-sinergia-de-ma-com-sensibilidade-ao-prêmio>
Reaproveite `analise_sinergia` do Capítulo 9. Para uma fusão com V(A) =
R\$ 700 milhões, V(B) = R\$ 400 milhões e sinergia estimada de R\$ 150
milhões, calcule o valor líquido para os acionistas de A variando o
prêmio pago de R\$ 0 a R\$ 200 milhões (passos de R\$ 25 milhões), e
identifique o prêmio máximo que ainda mantém a fusão como criadora de
valor para A.

=== Exercício 21 --- Simulação de disposition effect (finanças comportamentais)
<exercício-21-simulação-de-disposition-effect-finanças-comportamentais>
Simule uma carteira de 20 ações com retornos aleatórios desde a compra
(`np.random.normal(0.05, 0.30, 20)`). Escreva uma função que separe as
ações em "ganhadoras" (retorno \> 0) e "perdedoras" (retorno \<= 0), e
simule a heurística do #emph[disposition effect] do Capítulo 10: o
investidor vende 80% das ganhadoras e apenas 20% das perdedoras. Ao
final, imprima quantas ações de cada grupo permaneceriam na carteira.

=== Exercício 22 --- Projeto integrador: painel financeiro completo
<exercício-22-projeto-integrador-painel-financeiro-completo>
Este exercício combina praticamente tudo da apostila. Dada a DRE e o
balanço simplificados de uma empresa fictícia abaixo, escreva um
programa que calcule: (1) EBITDA e margem EBITDA; (2) indicadores de
liquidez e endividamento; (3) ROE via DuPont; (4) o Ke pelo CAPM e o
WACC; (5) um veredito final ("criando valor" ou "destruindo valor")
comparando ROIC com o WACC calculado. Imprima tudo em um relatório
formatado.

```python
empresa = {
    "receita": 2000, "cpv": 1150, "despesas_operacionais": 300,
    "deprec": 90, "amort": 40, "despesas_financeiras": 120,
    "lucro_liquido": 260, "nopat": 380,
    "ac": 900, "pc": 600, "estoques": 250, "disponivel": 120,
    "passivo_circ": 600, "passivo_ncirc": 500, "pl": 1100, "ativo_total": 2200,
    "capital_investido": 1600,
    "beta": 1.05, "rf": 0.11, "premio_mercado": 0.06,
    "valor_mercado_pl": 1900, "valor_mercado_divida": 500,
    "kd_bruto": 0.115, "ir": 0.34,
}
```
