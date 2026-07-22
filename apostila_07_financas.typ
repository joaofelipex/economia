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

$ V a l o r = sum_(t = 1)^oo frac(F C L_t, \(1 + W A C C\)^t) $

Onde $F C L_t$ são os fluxos de caixa livres gerados em cada período.

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

#strong[Regra fundamental:] Se $R O I C > W A C C$, a empresa está
#strong[criando valor]. Se $R O I C < W A C C$, está #strong[destruindo
valor].

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

$ sigma_p^2 = sum_(i = 1)^n sum_(j = 1)^n w_i w_j sigma_(i j) $

Onde $sigma_(i j) = rho_(i j) times sigma_i times sigma_j$ é a
covariância.

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

$ beta_i = frac(C o v\(R_i\,R_m\), V a r\(R_m\)) $

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

#strong[\1. CAPM:] $ K e = R_f + beta times\(R_m - R_f\) $

#strong[\2. Modelo de Gordon (Dividend Discount Model):]
$ K e = D_1 / P_0 + g $

#strong[\3. Bond Yield + Risk Premium:] $ K e = K d + P r ê m i o $

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

$ K d_(l í q u i d o) = K d_(b r u t o) times\(1 - I R\) $

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

$ W A C C = E / V times K e + D / V times K d times\(1 - I R\) $

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

$ E V = sum_(t = 1)^n frac(F C F_t, \(1 + W A C C\)^t) + frac(V T, \(1 + W A C C\)^n) $

#strong[Onde:] - $E V$ = Enterprise Value (valor da firma) - $F C F_t$ =
Fluxo de Caixa Livre no ano t - $W A C C$ = custo médio ponderado de
capital - $V T$ = Valor Terminal (perpetuidade)

#strong[Valor Terminal (Gordon):]

$ V T = frac(F C F_n times\(1 + g\), W A C C - g) $

#strong[Equity Value:]
$ E q u i t y med V a l u e = E V - D í v i d a + C a i x a $

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
    [#strong[P/L] (Preço/Lucro)], [$P\/L P A$], [Mais
    popular], [Empresas maduras, lucro estável],
    [#strong[EV/EBITDA]], [$E V\/E B I T D A$], [Ignora
    depreciação], [Empresas de capital intensivo],
    [#strong[P/VP]], [$P\/V P A$], [Valor patrimonial], [Bancos,
    seguradoras],
    [#strong[Div. Yield]], [$D P A\/P$], [Retorno em
    dividendos], [Empresas que distribuem lucro],
    [#strong[P/Receita]], [$P\/R e c e i t a$], [Empresas sem
    lucro], [Startups, crescimento],
    [#strong[EV/FCF]], [$E V\/F C F$], [Geração de caixa], [Qualquer
    empresa],
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

$ A t i v o = P a s s i v o + P a t r i m ô n i o L í q u i d o $

#strong[\2. Demonstração do Resultado (DRE) --- "Filme"] Mostra a
geração de lucro em um período:

$ R e c e i t a - C u s t o s - D e s p e s a s = L u c r o L í q u i d o $

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
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Indicador], [Fórmula], [Interpretação],),
    table.hline(),
    [#strong[Liquidez Corrente]], [$A C\/P C$], [Ideal \> 1,5],
    [#strong[Liquidez Seca]], [$\(A C - E s t o q u e s\)\/P C$], [Ideal
    \> 1,0],
    [#strong[Liquidez
    Imediata]], [$D i s p o n í v e l\/P C$], [Capacidade imediata],
    [#strong[Liquidez
    Geral]], [$\(A C + R L P\)\/\(P C + E L P\)$], [Longo prazo],
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
    [#strong[Dívida/PL]], [$P a s s i v o\/P L$], [Quanto maior, mais
    alavancado],
    [#strong[Dívida/Ativo]], [$P a s s i v o\/A t i v o$], [Percentual
    financiado por terceiros],
    [#strong[ICJ]], [$L A J I R\/D F$], [Cobertura de juros],
    [#strong[Composição do
    Endividamento]], [$P C\/\(P C + E L P\)$], [Perfil da dívida],
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
    [#strong[ROE]], [$L L\/P L$], [Retorno do acionista],
    [#strong[ROA]], [$L L\/A t i v o$], [Retorno sobre ativos],
    [#strong[ROIC]], [$N O P A T\/C a p i t a l I n v e s t i d o$], [Retorno
    operacional],
    [#strong[Margem Líquida]], [$L L\/R e c e i t a$], [Lucratividade
    sobre vendas],
    [#strong[Margem
    Bruta]], [$\(R e c e i t a - C P V\)\/R e c e i t a$], [Lucro após
    custo dos produtos],
    [#strong[Giro do Ativo]], [$R e c e i t a\/A t i v o$], [Eficiência
    no uso dos ativos],
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

$ R O E = frac(L L, V e n d a s) times frac(V e n d a s, A t i v o) times frac(A t i v o, P L) $

$ R O E = M a r g e m med L í q u i d a times G i r o med d o med A t i v o times A l a v a n c a g e m med F i n a n c e i r a $

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

$ E B I T D A = L A J I R + D e p r e c i a ç ã o + A m o r t i z a ç ã o $

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

$ K e = K e_U +\(K e_U - K d\)times D / E $

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

$ V_L = V_U + D times I R $

O termo $D times I R$ é o #strong[benefício fiscal] (escudo fiscal) da
dívida.

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

$ V_L = V_U + V P\(B e n e f í c i o med F i s c a l\)- V P\(C u s t o med d e med F a l ê n c i a\) $

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
$ D P A = frac(D i v i d e n d o s med T o t a i s, N ú m e r o med d e med A ç õ e s) $

$ P a y - o u t = frac(D i v i d e n d o s, L u c r o med L í q u i d o) $

$ D i v i d e n d med Y i e l d = frac(D P A, P r e ç o med d a med A ç ã o) $

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

$ C C L = A t i v o med C i r c u l a n t e - P a s s i v o med C i r c u l a n t e $

$ N C G = A C med O p e r a c i o n a l - P C med O p e r a c i o n a l $

$ S T = C C L - N C G $

#strong[Onde:] - $A C med O p e r a c i o n a l$ = contas a receber +
estoques + adiantamentos - $P C med O p e r a c i o n a l$ =
fornecedores + salários + impostos a pagar - $S T$ (Saldo de Tesouraria)
\> 0 indica folga financeira

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
$ V\(A B\)> V\(A\)+ V\(B\) $

$ S i n e r g i a = V\(A B\)-\[V\(A\)+ V\(B\)\] $

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

$ R\$\/U S\$= frac(R\$, U S\$) $

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
$ T a x a med d e med C â m b i o = frac(N í v e l med d e med P r e ç o s med\(P a í s med A\), N í v e l med d e med P r e ç o s med\(P a í s med B\)) $

#strong[PPP Relativa:] a variação cambial reflete o diferencial de
inflação:

$ E_t / E_(t - 1) = frac(1 + pi_(d o m é s t i c a), 1 + pi_(e s t r a n g e i r a)) $

#line()

== Capítulo 13 --- Tabela Resumo de Fórmulas
<capítulo-13-tabela-resumo-de-fórmulas>
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
    [#strong[Beta]], [$beta_i = C o v\(R_i\,R_m\)\/V a r\(R_m\)$], [Risco
    sistemático],
    [#strong[Retorno
    Carteira]], [$E\(R_p\)= sum w_i times E\(R_i\)$], [Portfólio],
    [#strong[Risco Carteira (2
    ativos)]], [$sigma_p^2 = w_1^2 sigma_1^2 + w_2^2 sigma_2^2 + 2 w_1 w_2 sigma_1 sigma_2 rho_12$], [Diversificação],
    [#strong[WACC]], [$W A C C =\(E\/V\)times K e +\(D\/V\)times K d times\(1 - I R\)$], [TMA
    para projetos],
    [#strong[Ke (Gordon)]], [$K e = D_1\/P_0 + g$], [Ações que pagam
    dividendos],
    [#strong[Kd
    líquido]], [$K d_(l i q) = K d_(b r u t o) times\(1 - I R\)$], [Custo
    da dívida],
    [#strong[EVA]], [$E V A = N O P A T -\(C a p i t a l times W A C C\)$], [Criação
    de valor],
    [#strong[ROE]], [$R O E = L L\/P L$], [Rentabilidade do acionista],
    [#strong[DuPont]], [$R O E =\(L L\/V\)times\(V\/A\)times\(A\/P L\)$], [Decomposição
    ROE],
    [#strong[Valuation
    FCD]], [$E V = sum F C F_t\/\(1 + W A C C\)^t+ V T\/\(1 + W A C C\)^n$], [Valor
    intrínseco],
    [#strong[Valor
    Terminal]], [$V T = F C F_n times\(1 + g\)\/\(W A C C - g\)$], [Perpetuidade],
    [#strong[P/L]], [$P L = P r e ç o\/L P A$], [Múltiplo],
    [#strong[MM I (s/ imposto)]], [$V_L = V_U$], [Irrelevância],
    [#strong[MM II (c/
    imposto)]], [$V_L = V_U + D times I R$], [Benefício fiscal],
    [#strong[Dividend Yield]], [$D Y = D P A\/P r e ç o$], [Retorno em
    dividendos],
    [#strong[Pay-out]], [$P O = D i v i d e n d o s\/L L$], [Distribuição
    de lucro],
    [#strong[CCL]], [$A C - P C$], [Capital de giro],
    [#strong[Fisher]], [$\(1 + i_n\)=\(1 + i_r\)times\(1 + pi\)$], [Inflação],
    [#strong[PPP]], [$Delta E =\(1 + pi_(d o m)\)\/\(1 + pi_(e s t)\)$], [Câmbio],
  )]
  , kind: table
  )

#line()

== Capítulo 14 --- Glossário
<capítulo-14-glossário>
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
