#set document(title: "Finanças — Teoria Completa com Python", author: "Felipe")
#set text(lang: "pt", region: "br", size: 10.5pt)
#set page(
  paper: "a4",
  margin: (x: 2.2cm, y: 2.4cm),
  numbering: "1",
  footer: context [
    #set text(size: 8.5pt, fill: luma(110))
    Finanças — Teoria Completa com Python #h(1fr) #counter(page).display("1")
  ],
)
#set par(justify: true, leading: 0.62em)
#set heading(numbering: none)
#show heading.where(level: 2): it => block(above: 1.6em, below: 0.9em)[
  #set text(size: 16pt)
  #it.body
  #v(-0.3em)
  #line(length: 100%, stroke: 1pt + rgb("#2c3e50"))
]
#show heading.where(level: 3): set block(above: 1.3em, below: 0.7em)
#show heading.where(level: 4): set block(above: 1.1em, below: 0.6em)
#show raw: set text(size: 8.3pt)
#show raw.where(block: true): it => block(
  width: 100%,
  fill: if it.lang == none { rgb("#fbfcf8") } else { luma(247) },
  stroke: if it.lang == none {
    (left: 2.5pt + rgb("#7aa37a"), rest: 0.5pt + luma(225))
  } else {
    0.5pt + luma(215)
  },
  inset: 7pt,
  radius: 2pt,
  it,
)
#set line(length: 100%, stroke: 0.6pt + luma(170))
#set table(
  inset: 5pt,
  stroke: 0.4pt + luma(175),
  fill: (x, y) => if y == 0 { luma(232) },
)
#show table: set text(size: 9.5pt)
#show figure.where(kind: table): set block(breakable: true)
#show link: set text(fill: rgb("#1d4f91"))

// ---- Caixas de destaque -------------------------------------------------
#let caixa(titulo, cor, fundo, corpo) = block(
  width: 100%,
  inset: (x: 10pt, y: 8pt),
  radius: 3pt,
  fill: fundo,
  stroke: (left: 3pt + cor),
  above: 1em,
  below: 1em,
  breakable: true,
)[
  #block(sticky: true, below: 4pt)[#text(weight: "bold", fill: cor, size: 9.5pt)[#titulo]]
  #corpo
]
#let exemplo(titulo, corpo) = caixa("Exemplo resolvido — " + titulo, rgb("#1f6f4a"), rgb("#eef7f1"), corpo)
#let intuicao(corpo) = caixa("Intuição", rgb("#1d4f91"), rgb("#edf3fb"), corpo)
#let atencao(corpo) = caixa("Atenção — erro comum", rgb("#a33a1c"), rgb("#fcf1ec"), corpo)
#let teoria(titulo, corpo) = caixa("Aprofundando a teoria — " + titulo, rgb("#5b3a8c"), rgb("#f4f0fa"), corpo)
#let mercado(corpo) = caixa("No mercado brasileiro", rgb("#8a6100"), rgb("#fdf6e3"), corpo)
#let resumo(corpo) = caixa("Em resumo", rgb("#444444"), rgb("#f2f2f2"), corpo)

// ---- Linha do tempo de fluxo de caixa ------------------------------------
// valores: strings; começando com "-" = saída (seta para baixo), "" = nada.
#let fluxo(..valores) = {
  let v = valores.pos()
  let n = v.len()
  block(width: 100%, inset: 8pt, stroke: 0.5pt + luma(210), radius: 3pt, above: 1em, below: 1em)[
    #set text(size: 8.5pt)
    #grid(
      columns: (1fr,) * n,
      row-gutter: 3pt,
      align: center,
      ..v.map(x => if x == "" { [] } else if x.starts-with("-") {
        text(fill: rgb("#a33a1c"))[↓ #x.slice(1)]
      } else {
        text(fill: rgb("#1f6f4a"))[↑ #x]
      }),
      ..range(n).map(_ => line(length: 100%, stroke: 0.7pt + luma(90))),
      ..range(n).map(t => text(fill: luma(90))[t = #t]),
    )
  ]
}

= Finanças --- Teoria Completa com Python
<finanças-teoria-completa-com-python>

#align(center)[
  #text(size: 11pt, fill: luma(90))[Teoria, exemplos resolvidos passo a passo e implementação em Python]
]

#v(0.5em)
#outline(title: [Sumário], depth: 3)

#pagebreak()

== Como Usar Esta Apostila
<como-usar-esta-apostila>
Esta apostila trata de #strong[finanças corporativas e de investimentos]:
como decidir onde aplicar dinheiro, como financiá-lo e como medir se uma
decisão criou ou destruiu valor. Ela pressupõe o conteúdo da apostila de
#strong[Matemática Financeira] (valor do dinheiro no tempo, VPL, TIR, séries
e perpetuidades), que é a linguagem sobre a qual tudo aqui é construído.

Cada tópico segue três camadas: #strong[(1) o porquê] (teoria e dedução),
#strong[(2) o como] (exemplo numérico resolvido à mão) e
#strong[(3) o automatizar] (código em Python, cujos resultados impressos
foram obtidos executando o código mostrado). As caixas coloridas indicam o
tipo de conteúdo:

#exemplo("modelo")[Um problema numérico resolvido em etapas. Refaça antes de ler a solução.]

#intuicao[A ideia por trás da fórmula, em linguagem comum.]

#teoria("modelo")[Demonstrações e detalhes que explicam #emph[por que] algo funciona.]

#atencao[Um erro que costuma aparecer em provas e na prática profissional.]

#mercado[Como o conceito aparece no mercado e na regulação brasileiros.]

#strong[Mapa da apostila.] Os capítulos 1 a 4 formam o núcleo teórico
(objetivo da empresa, risco e retorno, custo de capital, valuation). O
capítulo 5 ensina a ler as demonstrações financeiras. Os capítulos 6 a 9
tratam de decisões corporativas (estrutura de capital, dividendos, capital
de giro, fusões). Os capítulos 10 a 12 cobrem comportamento, mercados e
câmbio. Os capítulos 13 a 17 trazem exercícios resolvidos, resumos e
exercícios para você resolver; o capítulo 18 reúne tudo num estudo de caso e
o 19 lista os erros mais comuns.

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

#intuicao[
  Finanças difere da #strong[contabilidade] em dois pontos essenciais. A
  contabilidade registra o #emph[passado] pelo regime de competência; finanças
  olha para o #emph[futuro] e trabalha com #strong[fluxos de caixa], #strong[risco] e
  #strong[valor do dinheiro no tempo]. E difere da #strong[economia] no foco:
  a economia estuda como a sociedade aloca recursos escassos; finanças
  estuda como #emph[um agente específico] (empresa, investidor) toma decisões
  de investimento e financiamento sob incerteza.
]

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

#exemplo("as três decisões no balanço patrimonial")[
  As três decisões fundamentais correspondem a três pontos do balanço:

  #figure(
    align(center)[#table(
      columns: (24%, 38%, 38%),
      align: (left, left, left),
      table.header([Decisão], [Onde aparece], [Ferramenta principal],),
      [Investimento], [Lado do #strong[ativo]: o que a empresa possui], [VPL, TIR, EVA],
      [Financiamento], [Lado do #strong[passivo e PL]: como foi pago], [WACC, estrutura de capital],
      [Dividendos], [#strong[Lucros acumulados]: o que foi retido ou distribuído], [Pay-out, recompras],
    )]
    , kind: table
    )

  As três se influenciam: um projeto bom (investimento) pode exigir mais
  caixa do que a empresa tem (financiamento), o que pode levar a reter lucros
  (dividendos). Por isso o gestor financeiro as trata em conjunto.
]

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
print(f"Valor presente dos fluxos (5 anos): R${v:.2f} milhões")
```

```
Valor presente dos fluxos (5 anos): R$470.82 milhões
```

#teoria("o conflito de agência")[
  Em empresas de capital aberto, #strong[proprietários] (acionistas) e
  #strong[gestores] são pessoas diferentes. O gestor pode ter objetivos
  próprios --- crescer a empresa além do ótimo (por prestígio), proteger o
  emprego, evitar riscos que os acionistas, diversificados, aceitariam. Jensen
  e Meckling (1976) chamaram isso de #strong[problema de agência] e os custos
  de mitigá-lo (monitoramento, remuneração atrelada ao valor, conselho
  independente) de #strong[custos de agência].

  Maximizar a riqueza do acionista é o objetivo "consensual" por três
  razões práticas: ele é mensurável (preço da ação), considera risco e
  tempo, e o acionista é o #emph[residual claimant] --- só recebe depois que
  funcionários, fornecedores e credores foram pagos, de modo que, se a
  empresa gera valor para o residual, gerou valor para todos. Perspectivas
  mais amplas (#emph[stakeholders]) argumentam que a empresa deve considerar
  também empregados, clientes e sociedade; na prática, muitas dessas
  preocupações aumentam o valor de longo prazo, e as duas visões convergem
  mais do que parecem.
]

#exemplo("lucro positivo, valor destruído")[
  Dois projetos geram o mesmo lucro operacional após impostos (NOPAT) de
  R\$ 100 milhões por ano, mas o projeto A exige R\$ 500 milhões de capital
  e o projeto B, R\$ 1.000 milhões. O custo de capital (WACC) é 12%.

  - #strong[Projeto A:] retorno sobre o capital = $100/500 = 20%$; o custo
    do capital é $12% times 500 = 60$; #strong[lucro econômico] (EVA)
    $= 100 - 60 = +40$ milhões por ano.
  - #strong[Projeto B:] retorno = $100/1.000 = 10%$; custo do capital
    $= 12% times 1.000 = 120$; EVA $= 100 - 120 = -20$ milhões por ano.

  Os dois "dão lucro", mas só o A cria valor. O B consome capital que
  renderia 12% em outra aplicação e devolve só 10%. A contabilidade tradicional
  não desconta o #emph[custo do capital próprio], por isso enxerga lucro
  onde há destruição de valor.
]

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
        print(f"{k}: R${v:,.2f}")
```

```
EVA: R$20.00
MVA: R$2,500.00
ROIC: 12.50%
ROE: 11.67%
```

#teoria("EVA como spread vezes capital")[
  Reescreva o EVA usando o ROIC $= "NOPAT"/K$ (com $K$ o capital investido):

  $ "EVA" = "NOPAT" - K dot "WACC" = K dot ("ROIC" - "WACC") $

  O EVA é o #strong[spread] (ROIC − WACC) multiplicado pelo #strong[capital]
  empregado: criar valor exige (1) ter spread positivo e (2) ter capital
  para aplicar à taxa superior. Crescer com ROIC < WACC #emph[destrói] valor,
  porque cada real adicional de capital vale menos do que custa. Já o MVA
  (valor de mercado menos capital investido) é, em teoria, o valor presente
  de todos os EVAs futuros esperados: o mercado "paga" hoje pela expectativa
  de spreads positivos duradouros.
]

#exemplo("lendo os números do exemplo do capítulo")[
  Com NOPAT = 500, capital = 4.000 e WACC = 12%: ROIC $= 500/4.000 = "12,5"%$,
  spread de $+"0,5"$ p.p. e EVA $= 4.000 times "0,005" = $ R\$ 20 milhões. O MVA
  é 6.500 − 4.000 = R\$ 2.500 milhões: o mercado espera que a empresa
  continue criando valor por muitos anos (um EVA de R\$ 20 milhões por ano,
  como perpetuidade a 12%, valeria só R\$ 167 milhões --- o mercado está
  precificando #emph[crescimento] do EVA ou spreads maiores no futuro).
  O ROE (11,67%) usa outra base (lucro líquido sobre patrimônio líquido) e
  não é diretamente comparável ao ROIC; a seção 5.5 mostra a relação entre
  os dois por meio da alavancagem.
]

```python
def eva_por_spread(nopat, capital, wacc):
    roic = nopat / capital
    return roic, roic - wacc, capital * (roic - wacc)

for projeto_v, nopat_v, cap_v in (("A", 100, 500), ("B", 100, 1000)):
    roic_v, spread_v, eva_v = eva_por_spread(nopat_v, cap_v, 0.12)
    print(f"Projeto {projeto_v}: ROIC {roic_v:.1%} | spread {spread_v:+.1%} | EVA R${eva_v:+.1f} milhões/ano")
```

```
Projeto A: ROIC 20.0% | spread +8.0% | EVA R$+40.0 milhões/ano
Projeto B: ROIC 10.0% | spread -2.0% | EVA R$-20.0 milhões/ano
```

#resumo[
  - Finanças decide sob #strong[incerteza] e usa #strong[fluxos de caixa], não lucro contábil.
  - Três decisões: investimento (ativo), financiamento (passivo e PL), dividendos (lucros).
  - Objetivo: maximizar o valor para o acionista; o EVA $= K("ROIC" - "WACC")$
    mostra se o crescimento cria ou destrói valor.
]

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

#exemplo("retorno total, logarítmico e médias")[
  Uma ação comprada a R\$ 20 vale R\$ 22 um ano depois e pagou R\$ 1
  de dividendos. O retorno total é
  $R = (22 - 20 + 1)/20 = 15%$ (10% de ganho de capital mais 5% de dividend
  yield). O retorno #strong[logarítmico] (contínuo) do ganho de capital é
  $ln(22/20) = "9,53"%$; ele é aditivo no tempo (a soma dos retornos
  logarítmicos diários é o retorno logarítmico do período), enquanto os
  retornos simples são #strong[multiplicativos].

  #strong[Média aritmética × geométrica.] Retornos anuais de +10%, −5%, +20% e
  −15%: a média aritmética é 2,5% a.a., mas o capital cresce
  $"1,10" times "0,95" times "1,20" times "0,85" = "1,0659"$ em 4 anos, ou
  $"1,0659"^(1\/4) - 1 = "1,61"%$ a.a. (média #strong[geométrica]). A geométrica
  sempre é menor ou igual à aritmética e é a que mede o crescimento real do
  patrimônio. O exemplo extremo: uma perda de 50% exige um ganho de 100%
  para recuperar o capital --- retornos negativos "pesam" mais.
]

#teoria("por que a volatilidade é multiplicada por raiz de 252")[
  Se os retornos diários são independentes e têm variância $sigma_d^2$, a
  variância se #strong[soma] ao longo de $T$ dias: $sigma_T^2 = T sigma_d^2$, e o
  desvio padrão cresce com a #strong[raiz] do tempo: $sigma_T = sigma_d sqrt(T)$.
  Com 252 pregões por ano, $sigma_("anual") = sigma_d sqrt(252)$. A hipótese de
  independência é uma aproximação (os retornos reais têm autocorrelação de
  volatilidade e "caudas gordas"), mas é a convenção universal.
]

#atencao[
  O bloco acima baixa dados da internet com a biblioteca `yfinance`: ele
  #strong[só funciona com o pacote instalado e conexão ativa], e seus números
  mudam conforme a data de execução. Por isso, os exemplos seguintes usam
  #strong[dados simulados com semente fixa] --- reproduzíveis por qualquer
  leitor.
]

```python
rng_ex = np.random.default_rng(42)
# 4 anos de pregões simulados: retorno diário ~ t de Student (caudas gordas), média 0,05%, vol ~1,8%
ret_sim = 0.0005 + 0.018 * rng_ex.standard_t(df=5, size=1008) / np.sqrt(5 / 3)

print(f"Retorno médio diário : {ret_sim.mean()*100:.4f}%")
print(f"Volatilidade diária  : {ret_sim.std(ddof=1)*100:.4f}%")
print(f"Volatilidade anual   : {ret_sim.std(ddof=1) * np.sqrt(252) * 100:.2f}%")
print(f"Assimetria / curtose : {stats.skew(ret_sim):.3f} / {stats.kurtosis(ret_sim):.3f} (normal = 0 / 0)")
print(f"VaR 95% histórico    : {np.quantile(ret_sim, 0.05)*100:.2f}% | paramétrico: {(ret_sim.mean() - 1.645*ret_sim.std(ddof=1))*100:.2f}%")
print(f"VaR 99% histórico    : {np.quantile(ret_sim, 0.01)*100:.2f}% | paramétrico: {(ret_sim.mean() - 2.326*ret_sim.std(ddof=1))*100:.2f}%")
```

```
Retorno médio diário : -0.0096%
Volatilidade diária  : 1.8559%
Volatilidade anual   : 29.46%
Assimetria / curtose : 0.012 / 3.184 (normal = 0 / 0)
VaR 95% histórico    : -2.90% | paramétrico: -3.06%
VaR 99% histórico    : -5.05% | paramétrico: -4.33%
```

#intuicao[
  O #strong[VaR] (Value at Risk) responde: "com 95% de confiança, qual é a
  #emph[maior perda] em um dia?" Um VaR 95% de −2,9% significa que, em 5% dos
  dias, a perda é #emph[pior] que 2,9% --- ele não diz o quanto pior. Com
  caudas gordas (curtose alta), o VaR paramétrico (que supõe normalidade)
  #strong[subestima] as perdas extremas, o que a comparação histórico ×
  paramétrico no código ilustra.
]

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

```
Retorno esperado: 10.30%
Risco (desv. pad.): 15.42%
Relação retorno/risco: 0.67
```

#exemplo("retorno esperado e risco por cenários, passo a passo")[
  Para os cenários do código acima (boom, expansão, normal, recessão,
  crise): o #strong[retorno esperado] é a média ponderada pelas
  probabilidades:

  $ E(R) = "0,15" dot 35% + "0,30" dot 18% + "0,30" dot 8% + "0,15" dot (-5%) + "0,10" dot (-20%) = "10,30"% $

  A #strong[variância] pondera os desvios quadráticos
  $p_i (R_i - E(R))^2$:

  #figure(
    align(center)[#table(
      columns: (22%, 12%, 12%, 26%, 28%),
      align: (left, right, right, right, right),
      table.header([Cenário], [$p_i$], [$R_i$], [$R_i - E(R)$], [$p_i (R_i - E(R))^2$],),
      [Boom], [0,15], [35%], [+24,70%], [0,00915],
      [Expansão], [0,30], [18%], [+7,70%], [0,00178],
      [Normal], [0,30], [8%], [−2,30%], [0,00016],
      [Recessão], [0,15], [−5%], [−15,30%], [0,00351],
      [Crise], [0,10], [−20%], [−30,30%], [0,00918],
      [], [], [], [#strong[Variância]], [#strong[0,02378]],
    )]
    , kind: table
    )

  Logo $sigma = sqrt("0,02378") = "15,42"%$. Dois indicadores derivados:
  o #strong[coeficiente de variação] $sigma/E(R) = "1,50"$ (risco por unidade de
  retorno) e o #strong[Índice de Sharpe] $(E(R) - R_f)/sigma$, que desconta a taxa
  livre de risco. Com $R_f = "10,5"%$, o Sharpe é −0,01: a ação rende menos que a
  Selic --- não compensa o risco.
]

#atencao[
  O "retorno/risco" impresso no código ($E(R)/sigma$) #strong[não é o Sharpe]:
  ele ignora o ativo livre de risco. Um ativo de risco que rende menos que a
  renda fixa tem Sharpe negativo, por mais que $E(R)/sigma$ seja positivo.
]

#teoria("aversão a risco, utilidade e equivalente certo")[
  Por que variância é a medida de risco? Para um investidor com utilidade
  média-variância, $U = E(R) - (A/2) sigma^2$, onde $A > 0$ é o coeficiente de
  #strong[aversão a risco]. O #strong[equivalente certo] é o retorno sem risco que
  deixaria o investidor indiferente: igual a $U$. Para $A = 4$, o ativo dos
  cenários tem $U = "10,30"% - 2 times "2,378"% = "5,54"%$: um investidor tão
  avesso a risco preferiria um título que paga 5,54% garantidos a essa ação.
  Quanto maior $A$, maior a exigência de prêmio por unidade de variância.
]

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
            # variância = σ²/N + (1 - 1/N)·ρ·σ²  (o termo sistemático só pesa 1 - 1/N)
            risco_total = np.sqrt(risco_nao_sistematico**2 + (1 - 1 / n_ativos) * risco_sistematico**2)
        print(f"N = {n_ativos:3d} ativos -> Risco da carteira: {risco_total*100:.2f}%")

simulacao_diversificacao()
```

```
N =   1 ativos -> Risco da carteira: 40.00%
N =   2 ativos -> Risco da carteira: 30.33%
N =   5 ativos -> Risco da carteira: 22.63%
N =  10 ativos -> Risco da carteira: 19.39%
N =  20 ativos -> Risco da carteira: 17.55%
N =  50 ativos -> Risco da carteira: 16.35%
N = 100 ativos -> Risco da carteira: 15.92%
```

#strong[Conclusão fundamental:] A diversificação reduz o risco, mas há
um limite mínimo --- o #strong[risco sistemático] (de mercado) --- que
não pode ser eliminado por mais que se diversifique.

```
Risco Total = Risco Sistemático (mercado) + Risco Não-Sistemático (empresa)
```

#teoria("dedução do risco de uma carteira e do limite da diversificação")[
  Para dois ativos com pesos $w_1$ e $w_2 = 1 - w_1$,

  $ sigma_p^2 = w_1^2 sigma_1^2 + w_2^2 sigma_2^2 + 2 w_1 w_2 rho sigma_1 sigma_2 $

  O terceiro termo é a #strong[covariância]. Como $-1 <= rho <= 1$, o risco da
  carteira vai de $|w_1 sigma_1 - w_2 sigma_2|$ (correlação perfeitamente negativa) até
  $w_1 sigma_1 + w_2 sigma_2$ (perfeitamente positiva): #strong[só no segundo caso o risco
  é a média ponderada dos riscos individuais]. Para $N$ ativos de mesmo
  peso $1/N$, desvio $sigma$ e correlação média $rho$:

  $ sigma_p^2 = sigma^2/N + (1 - 1/N) rho sigma^2 $

  Quando $N$ cresce, o primeiro termo (risco #emph[específico], ou diversificável)
  tende a zero e sobra $rho sigma^2$ (o risco #emph[sistemático] ou de mercado):
  $sigma_p -> sigma sqrt(rho)$. Com $sigma = 40%$ e $rho = "0,15"$, o piso é
  $40% times sqrt("0,15") = "15,5"%$ --- por mais ativos que se compre, nunca se
  chega abaixo disso.
]

#exemplo("o efeito da correlação")[
  Dois ativos, $sigma_1 = 20%$ e $sigma_2 = 30%$, carteira 50/50:

  #table(
    columns: (24%, 24%, 52%),
    align: (center, right, left),
    table.header([Correlação $rho$], [Risco da carteira], [Comentário],),
    [+1,0], [25,00%], [Média ponderada dos riscos: sem ganho de diversificação],
    [+0,5], [21,79%], [],
    [0,0], [18,03%], [Menor que ambos os pesos médios],
    [−0,5], [13,23%], [],
    [−1,0], [5,00%], [Hedge quase perfeito (e zero com pesos 60/40)],
  )

  #v(0.3em)
  Com $rho = 0$, os pesos de #strong[mínima variância] são
  $w_1^* = sigma_2^2/(sigma_1^2 + sigma_2^2) = "69,2"%$, e o risco mínimo é 16,64% ---
  #emph[menor] que o do ativo menos arriscado (20%). Esse é o "almoço
  grátis" da diversificação: reduzir risco sem sacrificar proporcionalmente
  o retorno.
]

```python
def risco_n_ativos(sigma, rho, n):
    """Risco de uma carteira igualmente ponderada com N ativos de correlação média rho."""
    return np.sqrt(sigma ** 2 / n + (1 - 1 / n) * rho * sigma ** 2)

ns = [1, 2, 5, 10, 20, 50, 100, 1000]
riscos_n = [risco_n_ativos(0.40, 0.15, n) for n in ns]
for n_, r_ in zip(ns, riscos_n):
    print(f"N = {n_:4d} ativos -> risco da carteira: {r_*100:.2f}%")
print(f"Piso (risco sistemático): {0.40 * np.sqrt(0.15) * 100:.2f}%")

plt.figure(figsize=(8.5, 4.2))
ns_curva = np.arange(1, 101)
plt.plot(ns_curva, [risco_n_ativos(0.40, 0.15, n) * 100 for n in ns_curva], color="#1d4f91", linewidth=2)
plt.axhline(0.40 * np.sqrt(0.15) * 100, color="#a33a1c", linestyle="--", label="Risco sistemático (piso)")
plt.fill_between(ns_curva, 0.40 * np.sqrt(0.15) * 100, [risco_n_ativos(0.40, 0.15, n) * 100 for n in ns_curva],
                 color="#1d4f91", alpha=0.12, label="Risco específico (diversificável)")
plt.xlabel("Número de ativos (N)"); plt.ylabel("Risco da carteira (% a.a.)")
plt.title("Diversificação: o risco específico some, o sistemático permanece")
plt.legend(); plt.grid(alpha=0.3)
plt.savefig("figuras07/diversificacao.png", dpi=170, bbox_inches="tight")
```

```
N =    1 ativos -> risco da carteira: 40.00%
N =    2 ativos -> risco da carteira: 30.33%
N =    5 ativos -> risco da carteira: 22.63%
N =   10 ativos -> risco da carteira: 19.39%
N =   20 ativos -> risco da carteira: 17.55%
N =   50 ativos -> risco da carteira: 16.35%
N =  100 ativos -> risco da carteira: 15.92%
N = 1000 ativos -> risco da carteira: 15.54%
Piso (risco sistemático): 15.49%
```

#figure(
  image("figuras07/diversificacao.png", width: 85%),
  caption: [O risco de uma carteira cai rapidamente nos primeiros ativos e converge para o risco sistemático (piso).],
)

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

rf = 0.105      # 10.5% (Selic nominal)
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

```
Selic (Rf): 10.5%
Prêmio de risco: 5.5%

Beta     Retorno Esperado     Perfil
---------------------------------------------
0.0      10.50              % Livre de risco
0.5      13.25              % Defensivo
0.8      14.90              % Moderado
1.0      16.00              % Mercado
1.2      17.10              % Agressivo
1.5      18.75              % Agressivo+
2.0      21.50              % Alavancado
```

#intuicao[
  O CAPM diz algo contraintuitivo: o mercado #strong[não paga] por risco que
  o investidor pode eliminar sozinho. Se você pode diversificar o risco
  específico de uma empresa de graça (comprando outras ações), o preço de
  equilíbrio não pode remunerá-lo --- senão todos comprariam aquela ação, o
  preço subiria e o retorno cairia. Só o #strong[risco sistemático],
  que não se elimina, tem prêmio, e o beta o mede.
]

#exemplo("lendo a reta do mercado de títulos (SML)")[
  Com $R_f = "10,5"%$ e prêmio de mercado de 5,5%: uma ação de beta 1,2 deve
  render $E(R) = "10,5"% + "1,2" times "5,5"% = "17,1"%$. Se o analista projeta 19%,
  o #strong[alfa] (retorno acima do exigido pelo risco) é $+"1,9"%$: a ação
  está "barata" (acima da SML) e vale a pena comprar; se projetasse 15%,
  o alfa seria $-"2,1"%$ e ela estaria "cara". O CAPM transforma a pergunta
  "o retorno esperado é bom?" em "é #emph[bom o bastante para o seu beta]?".
]

#mercado[
  #strong[O CAPM no Brasil.] Três cuidados práticos. (1) #strong[Taxa livre de
  risco:] usa-se a Selic ou o juro real de títulos longos (NTN-B) mais a
  inflação esperada; não há "ativo sem risco" perfeito porque o governo
  brasileiro também tem risco de crédito. (2) #strong[Prêmio de mercado:]
  estimado em dados históricos ou implícitos (Damodaran, por exemplo), com
  grande incerteza. (3) #strong[Moeda e risco-país:] um método comum é calcular
  o Ke em dólares (taxa livre de risco americana + beta × prêmio + prêmio de
  risco-país) e convertê-lo para reais pelo diferencial de inflação:
  $K_(e,"BRL") = (1 + K_(e,"USD")) (1 + pi_("BR"))/(1 + pi_("EUA")) - 1$. Com
  $K_(e,"USD") = 11%$, inflação de 4,5% no Brasil e 3% nos EUA, o
  $K_(e,"BRL") approx "12,6"%$.
]

```python
# a "taxa livre de risco" (Selic nominal) neste exemplo é nominal, não real
rf_ex, premio_ex = 0.105, 0.055
for beta_ex, proj_ex in ((1.2, 0.19), (1.2, 0.15)):
    exigido = rf_ex + beta_ex * premio_ex
    print(f"Beta {beta_ex}: exigido {exigido*100:.2f}% | projetado {proj_ex*100:.1f}% | alfa {(proj_ex - exigido)*100:+.2f} p.p.")
```

```
Beta 1.2: exigido 17.10% | projetado 19.0% | alfa +1.90 p.p.
Beta 1.2: exigido 17.10% | projetado 15.0% | alfa -2.10 p.p.
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

#teoria("beta como razão de covariância e como inclinação")[
  A definição $beta_i = "Cov"(R_i, R_m)/"Var"(R_m)$ equivale a
  $beta_i = rho_(i m) dot sigma_i/sigma_m$: o beta é a correlação com o
  mercado, #strong[escalada] pela volatilidade relativa. E é a inclinação da
  regressão $R_i - R_f = alpha + beta (R_m - R_f) + epsilon$: se o mercado sobe
  1 ponto, a ação sobe em média $beta$ pontos. O $R^2$ da regressão mede a
  fração do risco da ação que é sistemática; o restante ($1 - R^2$) é
  específico.

  #strong[Beta alavancado × desalavancado.] O risco do negócio ($beta_U$) é
  amplificado pelo endividamento (risco financeiro). Pela fórmula de Hamada,

  $ beta_L = beta_U [1 + (1 - "IR") D/E] $

  Por exemplo, com $beta_U = "0,8"$, $D/E = "0,5"$ e IR de 34%, $beta_L = "0,8" times
  (1 + "0,66" times "0,5") = "1,064"$. Para avaliar uma empresa com estrutura de
  capital diferente da das comparáveis, desalavanca-se o beta das comparáveis
  e realavanca-se com a estrutura-alvo.
]

#exemplo("estimando um beta com seis observações")[
  Retornos mensais do mercado: 2%, −1%, 3%, 0%, −2%, 4%; da ação: 3%, −2%, 5%,
  0,5%, −4%, 6%. A covariância amostral dividida pela variância do mercado
  dá $beta = "1,66"$: a ação amplifica o mercado em 66%. Com apenas seis
  pontos, o erro padrão da estimativa é grande --- na prática usam-se 2 a 5
  anos de dados, com retornos semanais ou mensais.
]

```python
mercado_ex = np.array([0.02, -0.01, 0.03, 0.0, -0.02, 0.04])
acao_ex = np.array([0.03, -0.02, 0.05, 0.005, -0.04, 0.06])
cov_ex = np.cov(acao_ex, mercado_ex, ddof=1)[0, 1]
beta_ex2 = cov_ex / np.var(mercado_ex, ddof=1)
reg_ex = stats.linregress(mercado_ex, acao_ex)
print(f"Beta (Cov/Var): {beta_ex2:.4f} | beta (regressão): {reg_ex.slope:.4f} | alfa: {reg_ex.intercept*100:.3f}% | R²: {reg_ex.rvalue**2:.3f}")
print(f"Hamada: beta_U 0,8 com D/E 0,5 e IR 34% -> beta alavancado {0.8 * (1 + (1 - 0.34) * 0.5):.3f}")
```

```
Beta (Cov/Var): 1.6607 | beta (regressão): 1.6607 | alfa: -0.244% | R²: 0.987
Hamada: beta_U 0,8 com D/E 0,5 e IR 34% -> beta alavancado 1.064
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

#teoria("medidas de desempenho ajustadas ao risco")[
  Para comparar fundos com riscos diferentes, usam-se três medidas:

  - #strong[Índice de Sharpe:] $(R_p - R_f)/sigma_p$ --- retorno excedente por
    unidade de #emph[risco total]. Adequado quando a carteira é "toda" a
    riqueza do investidor.
  - #strong[Índice de Treynor:] $(R_p - R_f)/beta_p$ --- por unidade de #emph[risco
    sistemático]. Adequado quando a carteira é uma parte de uma carteira
    maior e diversificada.
  - #strong[Alfa de Jensen:] $alpha_p = R_p - [R_f + beta_p (R_m - R_f)]$ --- o
    retorno acima do que o CAPM exige.

  Exemplo (Selic 10,5%; prêmio de mercado 6%): o fundo A rende 16% com
  $sigma = 22%$ e $beta = "1,3"$; o fundo B rende 14% com $sigma = 15%$ e $beta = "0,9"$.
  Sharpe: A 0,25; B 0,23. Treynor: A 4,2%; B 3,9%. Jensen: A $-"2,3"%$; B $-"1,9"%$. O
  A "ganha" no Sharpe e no Treynor, mas ambos têm #strong[alfa negativo]: nenhum
  entregou retorno acima do exigido pelo seu risco.
]

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

```
Carteira de Máximo Sharpe:
  Retorno: 11.86%
  Risco: 14.35%
  Sharpe: 0.827

Carteira de Mínima Volatilidade:
  Retorno: 10.99%
  Risco: 13.82%
  Sharpe: 0.795
```

#teoria("a fronteira, a linha de alocação de capital e a separação em dois fundos")[
  Para um conjunto de ativos de risco, a #strong[fronteira eficiente] é a curva
  das carteiras de menor risco para cada retorno. Ao incluir um ativo livre de risco,
  surge a #strong[Linha de Alocação de Capital] (CAL): qualquer combinação
  entre o ativo livre de risco e uma carteira de risco $P$ fica numa reta no plano
  retorno × risco, cuja inclinação é o Sharpe de $P$. O investidor racional
  escolhe a carteira $P$ que #strong[maximiza o Sharpe] --- a #strong[carteira
  tangente] --- e ajusta o risco total só pela proporção investida no ativo
  livre de risco. É o teorema da #strong[separação em dois fundos]: todos os
  investidores, independentemente da aversão a risco, mantêm a mesma carteira
  de risco; só a mistura com o caixa muda. A carteira de mercado do CAPM é
  essa carteira tangente.

  #strong[Limitação.] A otimização é muito sensível aos retornos esperados
  informados: pequenos erros geram pesos extremos (incluindo posições vendidas
  grandes). Na prática, impõem-se restrições (sem venda a descoberto, limites
  por ativo) ou modelos mais robustos (Black-Litterman).
]

```python
mu_ex = np.array([0.12, 0.15, 0.09, 0.14])
cov_mk = np.array([
    [0.04, 0.012, 0.008, 0.015],
    [0.012, 0.09, 0.01, 0.025],
    [0.008, 0.01, 0.03, 0.009],
    [0.015, 0.025, 0.009, 0.07],
])
um = np.ones(4)
cov_inv = np.linalg.inv(cov_mk)
w_minvar = cov_inv @ um / (um @ cov_inv @ um)          # solução analítica de mínima variância (sem restrições)
print("Pesos de mínima variância:", np.round(w_minvar, 4))
print(f"Retorno {mu_ex @ w_minvar:.2%} | risco {np.sqrt(w_minvar @ cov_mk @ w_minvar):.2%}")

rng_mk = np.random.default_rng(7)
w_sim = rng_mk.dirichlet(np.ones(4), size=8000)
ret_sim_mk = w_sim @ mu_ex
risco_sim_mk = np.sqrt(np.einsum("ij,jk,ik->i", w_sim, cov_mk, w_sim))
sharpe_sim = (ret_sim_mk - 0.10) / risco_sim_mk
i_max = sharpe_sim.argmax()
print(f"Melhor Sharpe simulado (Rf 10%): {sharpe_sim[i_max]:.3f} com pesos {np.round(w_sim[i_max], 3)}")

plt.figure(figsize=(8.5, 4.6))
sc = plt.scatter(risco_sim_mk * 100, ret_sim_mk * 100, c=sharpe_sim, cmap="viridis", s=6, alpha=0.7)
plt.colorbar(sc, label="Índice de Sharpe (Rf = 10%)")
plt.scatter([np.sqrt(w_minvar @ cov_mk @ w_minvar) * 100], [mu_ex @ w_minvar * 100], color="#a33a1c", s=70, zorder=5, label="Mínima variância")
plt.scatter([risco_sim_mk[i_max] * 100], [ret_sim_mk[i_max] * 100], color="orange", s=70, zorder=5, edgecolor="black", label="Máximo Sharpe")
plt.plot([0, risco_sim_mk[i_max] * 130], [10, 10 + sharpe_sim[i_max] * risco_sim_mk[i_max] * 130], color="gray", linestyle="--", label="Linha de alocação de capital")
plt.xlabel("Risco (desvio padrão, %)"); plt.ylabel("Retorno esperado (%)")
plt.title("Carteiras aleatórias e a fronteira eficiente")
plt.legend(); plt.grid(alpha=0.3)
plt.savefig("figuras07/fronteira.png", dpi=170, bbox_inches="tight")
```

```
Pesos de mínima variância: [0.3114 0.0847 0.4913 0.1126]
Retorno 11.01% | risco 13.82%
Melhor Sharpe simulado (Rf 10%): 0.201 com pesos [0.232 0.436 0.004 0.328]
```

#figure(
  image("figuras07/fronteira.png", width: 88%),
  caption: [Cada ponto é uma carteira dos quatro ativos. A fronteira eficiente é o limite superior da nuvem; a reta tangente (CAL) toca a carteira de maior Sharpe.],
)

#resumo[
  - Retorno composto: use média #strong[geométrica]; a volatilidade anual é $sigma_d sqrt(252)$.
  - Risco de carteira depende da #strong[covariância]; diversificar elimina o risco
    específico, não o sistemático ($sigma sqrt(rho)$).
  - CAPM: $E(R) = R_f + beta (R_m - R_f)$. O beta é $"Cov"/"Var"$, a inclinação da
    regressão; desalavanca-se e realavanca-se pela fórmula de Hamada.
  - Sharpe, Treynor e alfa de Jensen comparam desempenho ajustado ao risco.
  - Markowitz: fronteira eficiente, carteira tangente e separação em dois fundos.
]

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

#intuicao[
  Todo capital tem dono, e o dono poderia ter aplicado o dinheiro em outro
  lugar. O custo de capital é o #strong[custo de oportunidade] dessas fontes: a
  menor taxa que faz o credor ou o acionista aceitar financiar a empresa
  em vez de investir em alternativa de risco comparável. Por isso ele
  depende do #strong[risco do projeto], não de quem o financia: um projeto
  arriscado exige mais retorno mesmo que a empresa seja sólida.
]

#atencao[
  #strong[Consistência de moeda e inflação.] Fluxos de caixa em reais
  nominais devem ser descontados por uma taxa nominal; fluxos em termos
  reais, por uma taxa real. Misturar os dois (por exemplo, descontar fluxos
  nominais pela taxa real) infla o valor artificialmente. A mesma regra vale
  para a moeda: fluxos em dólares usam custo de capital em dólares.
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

```
Ke (CAPM):   17.10%
Ke (Gordon): 9.56%
```

#exemplo("três métodos para o Ke da mesma empresa")[
  Os dados do código acima levam a #strong[Ke (CAPM) = 17,10%] e
  #strong[Ke (Gordon) = 9,56%]. Uma diferença dessas é um #strong[alerta], não
  uma curiosidade:

  - O Ke de Gordon (9,56%) é #emph[menor que a própria Selic] (10,5%): nenhum
    acionista aceitaria risco de ações por menos que o título público. Ou o
    preço está inflado, ou o dividendo/crescimento usados (R\$ 2,50 e 4%)
    subestimam a realidade.
  - Para o CAPM e o Gordon coincidirem a $"17,1"%$, o crescimento implícito
    precisaria ser $g = K_e - D_1/P_0 = "17,1"% - "5,56"% = "11,5"%$ ao ano
    para sempre --- superior ao crescimento da economia, portanto
    #strong[implausível].

  A lição: os métodos devem ser #strong[reconciliados], não escolhidos ao gosto.
  Quando divergem, investigue qual premissa está fraca (prêmio de risco,
  beta, crescimento perpétuo, preço de mercado). Um terceiro método,
  o #strong[Kd + prêmio] (por exemplo, juro da dívida da empresa mais 3 a 5 pontos
  percentuais), serve de verificação de ordem de grandeza.
]

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

```
Custo bruto da dívida: 16.08% a.a.
Alíquota de IR: 34%
Custo líquido da dívida: 10.61% a.a.
```

#teoria("por que o custo da dívida é líquido de imposto, e quando")[
  Os juros são #strong[dedutíveis] da base do imposto de renda: pagar
  $J$ de juros reduz o imposto em $"IR" dot J$, de modo que o custo
  efetivo é $J(1 - "IR")$. Isso só vale se a empresa #strong[tem lucro
  tributável] para deduzir: uma empresa em prejuízo fiscal não obtém o
  benefício (pelo menos não imediatamente). Em termos de fluxo de caixa, o
  benefício fiscal entra como entrada de caixa adicional; no WACC, ele aparece
  uma única vez, pelo termo $(1 - "IR")$ no custo da dívida --- nunca
  também nos fluxos de caixa projetados (dupla contagem).
]

#exemplo("custo da dívida pós-fixada")[
  Uma empresa paga CDI + 2,5% a.a., com CDI a 13,25%. O custo bruto é a
  composição das duas taxas: $("1,1325")("1,025") - 1 = "16,08"%$ a.a. (e não
  15,75%, a soma). Com IR de 34%, o custo líquido é
  $"16,08"% times "0,66" = "10,61"%$. Note que o custo da dívida #emph[atual]
  (histórica) não é o relevante para decisões novas: o que importa é o
  custo de #strong[captar hoje], a taxa marginal.
]

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
------------------------------------
0          % 100        % 14.50     %
10         % 90         % 13.84     %
20         % 80         % 13.18     %
30         % 70         % 12.53     %
40         % 60         % 11.87     %
50         % 50         % 11.21     %
60         % 40         % 10.55     %
70         % 30         % 9.89      %
80         % 20         % 9.24      %
90         % 10         % 8.58      %
```

#strong[Atenção:] O WACC diminui com mais dívida apenas até certo ponto.
Com endividamento excessivo, o risco de falência aumenta, elevando tanto
Ke quanto Kd.

#exemplo("WACC na mão")[
  Uma empresa tem R\$ 600 milhões de capital próprio (valor de mercado) e R\$
  400 milhões de dívida; $K_e = 16%$, $K_d = 12%$ bruto e IR de 34%.

  - Pesos: $E/V = 600/1.000 = 60%$; $D/V = 40%$.
  - $K_d$ líquido $= 12% times "0,66" = "7,92"%$.
  - $"WACC" = "0,60" times 16% + "0,40" times "7,92"% = "9,60"% + "3,17"% = $
    #strong[12,77%].

  Esse é o retorno mínimo que os #emph[novos projetos] da empresa precisam
  oferecer para não destruir valor (se tiverem o mesmo risco do negócio atual).
]

#atencao[
  #strong[Pesos a valor de mercado, não contábil.] Use o valor de mercado do
  patrimônio (preço da ação $times$ número de ações) e, quando possível, da dívida.
  O patrimônio líquido contábil costuma ser muito menor que o valor de mercado
  em empresas lucrativas, o que superestimaria o peso da dívida e
  subestimaria o WACC.
]

#teoria("o WACC não cai para sempre: a curva em U")[
  A tabela impressa acima (Ke e Kd constantes) mostra o WACC caindo sem fim
  com a dívida --- o que seria um convite ao endividamento infinito. É uma
  simplificação enganosa. Na realidade, mais dívida eleva o risco do
  acionista (o beta alavancado sobe, pela fórmula de Hamada) e o spread
  cobrado pelos credores. O modelo abaixo incorpora os dois efeitos e
  produz a clássica curva em U, com um #strong[mínimo] (a estrutura de capital
  ótima segundo o trade-off, capítulo 6).
]

```python
def wacc_realista(peso_div, beta_u=0.9, rf=0.10, premio=0.06, ir=0.34):
    """WACC com beta realavancado (Hamada) e spread de crédito crescente com a alavancagem (ilustrativo)."""
    d_e = peso_div / (1 - peso_div)
    beta_l = beta_u * (1 + (1 - ir) * d_e)
    ke_ = rf + beta_l * premio
    kd_ = rf + 0.02 + 0.10 * peso_div ** 2          # spread de 2% + componente que cresce com o endividamento
    return ke_, kd_, (1 - peso_div) * ke_ + peso_div * kd_ * (1 - ir)

print(f"{'D/V':>5} {'Ke':>7} {'Kd':>7} {'WACC':>7}")
for pd_ in np.arange(0, 0.75, 0.1):
    ke_r, kd_r, w_r = wacc_realista(pd_)
    print(f"{pd_:>5.0%} {ke_r:>7.2%} {kd_r:>7.2%} {w_r:>7.2%}")

grade = np.arange(0, 0.9, 0.01)
curva_w = [wacc_realista(x)[2] for x in grade]
otimo = grade[int(np.argmin(curva_w))]
print(f"WACC mínimo: {min(curva_w):.2%} com D/V = {otimo:.0%}")

plt.figure(figsize=(8.5, 4.2))
plt.plot(grade * 100, curva_w, color="#1d4f91", linewidth=2, label="WACC")
plt.plot(grade * 100, [wacc_realista(x)[0] for x in grade], color="#a33a1c", linestyle="--", label="Ke")
plt.plot(grade * 100, [wacc_realista(x)[1] * (1 - 0.34) for x in grade], color="#1f6f4a", linestyle="--", label="Kd líquido")
plt.axvline(otimo * 100, color="gray", linestyle=":")
plt.xlabel("Dívida / valor da empresa (%)"); plt.ylabel("% a.a.")
plt.title("WACC em função da estrutura de capital: a curva em U")
plt.legend(); plt.grid(alpha=0.3)
plt.savefig("figuras07/wacc_u.png", dpi=170, bbox_inches="tight")
```

```
  D/V      Ke      Kd    WACC
   0%  15.40%  12.00%  15.40%
  10%  15.80%  12.10%  15.01%
  20%  16.29%  12.40%  14.67%
  30%  16.93%  12.90%  14.40%
  40%  17.78%  13.60%  14.26%
  50%  18.96%  14.50%  14.27%
  60%  20.75%  15.60%  14.48%
  70%  23.72%  16.90%  14.92%
WACC mínimo: 14.24% com D/V = 44%
```

#figure(
  image("figuras07/wacc_u.png", width: 85%),
  caption: [Com beta realavancado e spread crescente, o WACC cai no início (benefício fiscal e dívida barata) e depois sobe (risco de insolvência).],
)

=== 3.5. Teoria do Custo de Capital
<teoria-do-custo-de-capital>
A estrutura de capital ótima é aquela que #strong[minimiza o WACC] e,
consequentemente, #strong[maximiza o valor da empresa].

```python
def valor_empresa_modelo(fcf_perpetuo, wacc):
    """Valor da empresa pela perpetuidade do FCF."""
    return fcf_perpetuo / wacc

fcf = 100  # fluxo de caixa livre perpétuo (milhões)
print(f"FCF perpétuo: R${fcf} milhões\n")

for w in [0.08, 0.10, 0.12, 0.14, 0.16]:
    v = valor_empresa_modelo(fcf, w)
    print(f"WACC = {w*100:.0f}% -> Valor = R${v:,.0f} milhões")
```

```
FCF perpétuo: R$100 milhões

WACC = 8% -> Valor = R$1,250 milhões
WACC = 10% -> Valor = R$1,000 milhões
WACC = 12% -> Valor = R$833 milhões
WACC = 14% -> Valor = R$714 milhões
WACC = 16% -> Valor = R$625 milhões
```

#teoria("projetos do mesmo setor, mas risco diferente: use o custo de capital do projeto")[
  O WACC da empresa só é a taxa de desconto correta para projetos com o
  mesmo risco do negócio atual. Um projeto de risco maior (nova linha de
  negócio, mercado externo) deve usar um custo de capital #strong[próprio do
  projeto]: estima-se o beta de empresas "puras" do setor-alvo (comparáveis),
  desalavanca-se, realavanca-se pela estrutura-alvo e recalcula-se o WACC.
  Usar o WACC médio da empresa para todos os projetos leva a #strong[aceitar projetos
  de alto risco que destroem valor] e #strong[rejeitar projetos seguros que
  criariam valor].
]

#resumo[
  - Custo de capital = custo de oportunidade; depende do #strong[risco do projeto].
  - $K_e$ pelo CAPM (ou Gordon, ou $K_d$ + prêmio): os métodos devem ser reconciliados.
  - $K_d$ líquido $= K_d (1 - "IR")$, e só se há lucro tributável a deduzir.
  - $"WACC" = (E/V) K_e + (D/V) K_d (1 - "IR")$ com pesos a #strong[valor de mercado]; a curva
    real tem forma de U.
]

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
    print(f"{k:25s}: R${v:>10,.2f}")
```

```
=== Valuation por FCD ===
VP_FCFs                  : R$    470.82
VP_Valor_Terminal        : R$  1,209.12
Enterprise_Value         : R$  1,679.94
(-) Dívida               : R$   -300.00
(+) Caixa                : R$     80.00
Equity_Value             : R$  1,459.94
```

#intuicao[
  O valuation por FCD responde "quanto vale esta empresa se as previsões
  se realizarem?". Por isso, #strong[todo valuation é uma história
  traduzida em números]: crescimento, margens, necessidade de investimento e
  risco. O resultado é tão bom quanto as premissas --- e a parte mais
  sensível, o #strong[valor terminal], costuma responder por 60% a 80% do valor
  total (no exemplo, 72% do EV).
]

#teoria("do lucro ao fluxo de caixa livre (FCFF)")[
  O fluxo de caixa que se desconta pelo WACC é o #strong[fluxo de caixa livre
  da firma] (FCFF): o caixa gerado pelas operações, após impostos e investimentos,
  #emph[disponível para credores e acionistas]:

  $ "FCFF" = "EBIT" (1 - "IR") + "Depreciação" - "CapEx" - Delta "NCG" $

  O primeiro termo é o #strong[NOPAT]. Soma-se a depreciação por ser despesa
  sem saída de caixa; subtraem-se os investimentos em ativo fixo (CapEx) e
  em capital de giro ($Delta "NCG"$). Os #strong[juros ficam de fora]: pertencem
  aos credores e já estão no WACC. Exemplo: EBIT 200, IR 34%, depreciação 80,
  CapEx 120, $Delta "NCG"$ 30: $"FCFF" = 200 times "0,66" + 80 - 120 - 30 = 62$.

  Para avaliar #emph[apenas o acionista] (FCFE) subtrai-se também o serviço da
  dívida e soma-se a nova captação, e desconta-se pelo $K_e$.
]

#atencao[
  #strong[Quatro erros clássicos no FCD.] (1) Usar $g >= "WACC"$ no valor
  terminal (o valor "explode"). (2) $g$ perpétuo acima do crescimento da
  economia (um negócio não cresce acima do PIB para sempre). (3) Esquecer de
  que o valor terminal tem de assumir #strong[reinvestimento] compatível com o
  crescimento: crescer exige investir. (4) Subtrair a dívida #emph[bruta] e
  somar o caixa sem checar se o caixa é "livre" ou é caixa operacional necessário.
]

```python
def fcd_simples(fcfs_x, wacc_x, g_x, divida_x, caixa_x):
    vp_f = sum(f / (1 + wacc_x) ** (t + 1) for t, f in enumerate(fcfs_x))
    vt_x = fcfs_x[-1] * (1 + g_x) / (wacc_x - g_x)
    vp_vt_x = vt_x / (1 + wacc_x) ** len(fcfs_x)
    ev_x = vp_f + vp_vt_x
    return ev_x, ev_x - divida_x + caixa_x, vp_vt_x / ev_x, vt_x / fcfs_x[-1]

fcfs_ex = [100, 115, 132, 152, 175]
ev_b, eq_b, share_vt, mult_vt = fcd_simples(fcfs_ex, 0.12, 0.035, 300, 80)
print(f"EV = R${ev_b:,.2f} | Equity = R${eq_b:,.2f} | valor terminal = {share_vt:.1%} do EV | VT = {mult_vt:.1f}x o FCF do ano 5")

print("\nEquity Value (R$ milhões) em função do WACC (linhas) e de g (colunas):")
gs = [0.02, 0.03, 0.035, 0.04, 0.05]
print(f"{'WACC':>6} " + " ".join(f"{g_*100:>8.1f}%" for g_ in gs))
for w_ in (0.10, 0.11, 0.12, 0.13, 0.14):
    print(f"{w_:>6.0%} " + " ".join(f"{fcd_simples(fcfs_ex, w_, g_, 300, 80)[1]:>9,.0f}" for g_ in gs))
```

```
EV = R$1,679.94 | Equity = R$1,459.94 | valor terminal = 72.0% do EV | VT = 12.2x o FCF do ano 5

Equity Value (R$ milhões) em função do WACC (linhas) e de g (colunas):
  WACC      2.0%      3.0%      3.5%      4.0%      5.0%
   10%     1,663     1,876     2,008     2,161     2,559
   11%     1,441     1,601     1,697     1,807     2,081
   12%     1,264     1,387     1,460     1,542     1,740
   13%     1,119     1,217     1,273     1,336     1,485
   14%       999     1,077     1,122     1,171     1,287
```

#intuicao[
  A tabela de sensibilidade mostra por que valuations divergem tanto entre
  analistas: variar o WACC em 1 ponto e o crescimento em 0,5 ponto muda o
  valor em dezenas de porcento. Uma boa prática é #strong[sempre apresentar
  o valor como uma faixa], nunca como um número único.
]

#exemplo("de equity value a preço por ação")[
  Com o equity value de R\$ 1.459,94 milhões (EV de R\$ 1.679,94 milhões,
  menos dívida de R\$ 300 milhões, mais caixa de R\$ 80 milhões) e 200 milhões
  de ações: preço justo $= "1.459,94"/200 = $ R\$ 7,30 por ação. Compara-se com
  o preço de mercado: se a ação negocia a R\$ 5,50, há margem de segurança
  de 25% (preço de mercado 25% abaixo do valor intrínseco); a R\$ 9,00, o
  mercado estaria precificando premissas mais otimistas que as suas.
]

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
    print(f"{'P/L':<15} {pl_setor:<18.2f}x R${preco_pl:<10.2f}")
    print(f"{'EV/EBITDA':<15} {ev_ebitda_setor:<18.2f}x ---")
    print(f"{'P/VP':<15} {pvp_setor:<18.2f}x R${preco_pvp:<10.2f}")

    return {'P/L': preco_pl, 'P/VP': preco_pvp}

# Empresa com LPA = R$3,50; valor patrimonial por ação = R$20
multiplos_empresa(
    lucro=350e6, ebitda=600e6, receita=1.2e9,
    valor_patrimonial=2e9, num_acoes=100e6,
    pl_setor=12, ev_ebitda_setor=7, pvp_setor=1.5
)
```

```
Múltiplo        Múltiplo Setor     Preço Justo
------------------------------------------------
P/L             12.00             x R$42.00
EV/EBITDA       7.00              x ---
P/VP            1.50              x R$30.00
```

#teoria("de onde vêm os múltiplos: P/L implícito no modelo de Gordon")[
  Os múltiplos não são "regras de bolso": decorrem do valor intrínseco. Partindo
  de $P_0 = D_1/(K_e - g)$ e de $D_1 = "LPA"_1 times "payout"$:

  $ P_0/"LPA"_1 = "payout"/(K_e - g) $

  O P/L #strong[prospectivo] aumenta com o pay-out e com o crescimento $g$, e
  diminui com o risco ($K_e$). Duas empresas só são comparáveis por P/L se tiverem
  perspectivas de crescimento e risco parecidos --- o que explica por que
  empresas de tecnologia negociam a múltiplos muito maiores que as de
  utilidade pública. O mesmo raciocínio vale para o #strong[EV/EBITDA]: ele sobe com
  o crescimento e com a conversão de EBITDA em caixa, e cai com o risco.
]

#exemplo("do EV/EBITDA ao preço por ação")[
  Retomando a empresa do exemplo (EBITDA R\$ 600 milhões, 100 milhões de
  ações): a um EV/EBITDA de 7x do setor, o #strong[EV] é R\$ 4.200 milhões.
  Para chegar ao preço por ação é preciso subtrair a #strong[dívida líquida]:
  com R\$ 500 milhões de dívida líquida, o equity vale R\$ 3.700 milhões e o
  preço justo é R\$ 37,00 por ação. O EV/EBITDA é neutro em relação à estrutura
  de capital (compara o negócio, antes de quem o financia), o P/L não.
]

#atencao[
  #strong[Armadilhas dos múltiplos.] (1) P/L de empresa com lucro negativo
  não faz sentido (use EV/Receita ou EV/EBITDA). (2) Lucros #emph[cíclicos] no
  pico de ciclo geram P/L baixo "enganoso": a empresa parece barata justo
  quando está mais cara (normalize o lucro). (3) Itens extraordinários e
  contabilidade distorcem o lucro. (4) O #strong[PEG] ($"P/L"$ dividido pelo
  crescimento do lucro em %) ajuda a comparar empresas com crescimentos
  diferentes, mas é só uma aproximação.
]

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

#resumo[
  - #strong[FCFF] $= "EBIT"(1 - "IR") + "Dep" - "CapEx" - Delta "NCG"$; desconta-se
    pelo WACC e soma-se o valor terminal $"FCF"_n (1 + g)/("WACC" - g)$.
  - $"Equity" = "EV" - "Dívida líquida"$. O valor terminal costuma pesar 60% a 80%.
  - O valor depende de premissas: apresente #strong[faixas] e sensibilidade, não um único número.
  - Múltiplos derivam do valor intrínseco (P/L $= "payout"/(K_e - g)$) e só comparam
    empresas de risco e crescimento semelhantes.
]

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

#intuicao[
  As três demonstrações são #strong[três ângulos da mesma empresa] e precisam
  "fechar" entre si: o lucro da DRE aumenta o patrimônio líquido no balanço, e a
  variação do caixa no balanço é explicada pela DFC. A pergunta mais útil que
  uma análise financeira faz é: #strong[por que o lucro não é igual ao caixa?]
  A resposta está nas diferenças de #emph[tempo] (vendas a prazo, estoques
  acumulados, compras a prazo) e de #emph[natureza] (depreciação não é saída
  de caixa; investimento em máquinas é saída de caixa que não passa pela DRE).
]

#exemplo("do lucro ao caixa: a DFC pelo método indireto")[
  Uma empresa teve lucro líquido de R\$ 100 mil no ano. Além disso: depreciação
  de R\$ 80 mil (despesa sem saída de caixa); contas a receber aumentaram R\$
  30 mil (vendeu, mas ainda não recebeu); estoques aumentaram R\$ 20 mil
  (comprou e não vendeu); fornecedores aumentaram R\$ 25 mil (comprou a
  prazo). Investiu R\$ 120 mil em máquinas, captou R\$ 50 mil de dívida e
  pagou R\$ 40 mil de dividendos.

  #figure(
    align(center)[#table(
      columns: (62%, 38%),
      align: (left, right),
      table.header([Item], [R\$ mil],),
      [Lucro líquido], [100],
      [(+) Depreciação (não é caixa)], [+80],
      [(−) Aumento de contas a receber], [−30],
      [(−) Aumento de estoques], [−20],
      [(+) Aumento de fornecedores], [+25],
      [#strong[= Caixa operacional (CFO)]], [#strong[155]],
      [(−) Investimento em máquinas (CapEx)], [−120],
      [#strong[= Caixa de investimento]], [#strong[−120]],
      [(+) Captação de dívida], [+50],
      [(−) Dividendos pagos], [−40],
      [#strong[= Caixa de financiamento]], [#strong[+10]],
      [#strong[Variação do caixa]], [#strong[+45]],
    )]
    , kind: table
    )

  Um lucro de R\$ 100 mil virou R\$ 155 mil de caixa operacional (por conta da
  depreciação e do crédito dos fornecedores), mas só R\$ 45 mil de variação
  de caixa líquida. Uma empresa pode ter lucro e quebrar por falta de caixa
  --- é a ideia central do capítulo 8 (capital de giro).
]

```python
lucro_l, deprec_l = 100, 80
d_receber, d_estoque, d_fornec = -30, -20, +25
capex_l, captacao_l, dividendos_l = -120, +50, -40

cfo = lucro_l + deprec_l + d_receber + d_estoque + d_fornec
cfi = capex_l
cff = captacao_l + dividendos_l
print(f"Caixa operacional (CFO)   : {cfo:>5}")
print(f"Caixa de investimento (CFI): {cfi:>5}")
print(f"Caixa de financiamento (CFF): {cff:>4}")
print(f"Variação líquida do caixa : {cfo + cfi + cff:>5}")
print(f"Conversão lucro -> caixa operacional: {cfo / lucro_l:.0%}")
```

```
Caixa operacional (CFO)   :   155
Caixa de investimento (CFI):  -120
Caixa de financiamento (CFF):   10
Variação líquida do caixa :    45
Conversão lucro -> caixa operacional: 155%
```

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
        print(f"{item:<30} R${valor:<13,.0f} {pct:<9.2f}%")

dre_exemplo = {
    'receita_liquida': 1000000,
    'custo_produtos': -550000,
    'despesas_operacionais': -200000,
    'despesas_financeiras': -50000,
    'imposto_renda': -68000
}
analise_vertical(dre_exemplo)
```

```
Item                           Valor (R$ mil)     % Receita
----------------------------------------------------------
receita_liquida                R$1,000,000     100.00   %
custo_produtos                 R$-550,000      -55.00   %
despesas_operacionais          R$-200,000      -20.00   %
despesas_financeiras           R$-50,000       -5.00    %
imposto_renda                  R$-68,000       -6.80    %
```

#exemplo("análise horizontal: crescimento e CAGR")[
  A análise #strong[horizontal] compara um mesmo item em vários períodos.
  Receita de R\$ 800 milhões (ano 1), 880 (ano 2), 990 (ano 3) e 1.100 (ano 4):

  - Variação ano a ano: $+"10,0"%$, $+"12,5"%$, $+"11,1"%$.
  - #strong[CAGR] (taxa composta de crescimento anual) em 3 anos:
    $(1.100/800)^(1\/3) - 1 = "11,2"%$ a.a.

  Compare com a variação do custo e das despesas: se a receita cresce 11%
  e as despesas operacionais 15%, a margem está sendo comprimida mesmo
  que o lucro absoluto ainda suba. A análise #strong[vertical] (tudo como %
  da receita) mostra a estrutura num ano; a horizontal mostra a #emph[dinâmica].
]

```python
receita_h = [800, 880, 990, 1100]
variacoes = [receita_h[i + 1] / receita_h[i] - 1 for i in range(len(receita_h) - 1)]
cagr_h = (receita_h[-1] / receita_h[0]) ** (1 / (len(receita_h) - 1)) - 1
print("Variações anuais:", [f"{v:+.1%}" for v in variacoes])
print(f"CAGR em {len(receita_h) - 1} anos: {cagr_h:.2%} a.a.")
```

```
Variações anuais: ['+10.0%', '+12.5%', '+11.1%']
CAGR em 3 anos: 11.20% a.a.
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

```
Liquidez Corrente: 1.60 [OK]
Liquidez Seca: 1.20 [OK]
Liquidez Imediata: 0.20 [ATENÇÃO]
Liquidez Geral: 1.57 [OK]
```

#teoria("como interpretar a liquidez --- e quando ela engana")[
  Os quatro índices formam uma #strong[escada de rigor]: a liquidez corrente
  inclui estoques e outros itens de difícil conversão; a seca retira os estoques;
  a imediata considera só o caixa; a geral amplia para o longo prazo. Leitura
  típica:

  - #strong[Corrente alta, seca baixa:] o ativo circulante é composto de
    estoques --- a empresa depende de #emph[vender] para pagar as dívidas de curto
    prazo.
  - #strong[Imediata muito baixa] não é, sozinha, sinal de crise: muitas empresas
    saudáveis mantêm pouco caixa porque conseguem renovar linhas de crédito.
  - #strong[Os limites "ideais" (1,5 e 1,0) são convenções] que dependem do setor:
    varejo e supermercados operam com liquidez corrente abaixo de 1 de forma
    saudável (capítulo 8); indústria pesada precisa de mais folga.
]

#atencao[
  Liquidez alta pode esconder problemas: estoques obsoletos, contas a receber
  de clientes inadimplentes ou caixa "preso" (garantias, depósitos judiciais)
  inflam o ativo circulante sem poder pagar contas. Sempre pergunte
  #strong[qual é a qualidade] do ativo circulante, além de olhar a razão.
]

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

```
Dívida/PL: 1.14
Dívida/Ativo: 0.53
ICJ: 3.00
Composição CP: 0.62
```

#exemplo("dívida líquida e alavancagem operacional")[
  Mais usado por bancos e agências de rating que a razão Dívida/PL é a
  #strong[Dívida Líquida/EBITDA]: quantos anos de geração operacional de
  caixa seriam necessários para quitar a dívida líquida. Com dívida bruta de R\$
  900 milhões, caixa de R\$ 200 milhões e EBITDA de R\$ 300 milhões:

  $ "Dívida líquida"/"EBITDA" = (900 - 200)/300 = "2,33" "x" $

  Contratos de dívida (debêntures, empréstimos) costumam ter #strong[covenants]:
  cláusulas que obrigam a empresa a manter, por exemplo, Dívida Líquida/EBITDA
  abaixo de 3,0x e cobertura de juros acima de 2,0x --- a quebra do covenant
  permite aos credores exigir o vencimento antecipado da dívida.
]

```python
divida_bruta, caixa_l, ebitda_l = 900, 200, 300
print(f"Dívida líquida/EBITDA: {(divida_bruta - caixa_l) / ebitda_l:.2f}x")
print(f"Folga até o covenant de 3,0x: EBITDA pode cair até R${(divida_bruta - caixa_l) / 3:.1f} milhões "
      f"({1 - (divida_bruta - caixa_l) / 3 / ebitda_l:.0%} de queda)")
```

```
Dívida líquida/EBITDA: 2.33x
Folga até o covenant de 3,0x: EBITDA pode cair até R$233.3 milhões (22% de queda)
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
        'Giro do Ativo': receita / ativo
    }

rent = indicadores_rentabilidade(800, 1100, 15000, 12000, 7000, 9000)
for k, v in rent.items():
    if k in ('Giro do Ativo',):
        print(f"{k}: {v:.2f}x")
    else:
        print(f"{k}: {v*100:.2f}%")
```

```
ROE: 11.43%
ROA: 6.67%
ROIC: 12.22%
Margem Líquida: 5.33%
Giro do Ativo: 1.25x
```

#teoria("a relação entre ROE, ROIC e alavancagem")[
  O ROE e o ROIC medem retornos sobre bases diferentes: o ROE sobre o capital
  #emph[do acionista]; o ROIC sobre #emph[todo] o capital investido (próprio + de
  terceiros). A ponte entre os dois é a alavancagem:

  $ "ROE" = "ROIC" + ("ROIC" - K_d (1 - "IR")) dot D/E $

  Se o retorno do negócio (ROIC) supera o custo líquido da dívida, cada real
  tomado emprestado #strong[eleva] o ROE; se não supera, #strong[reduz]. Com
  ROIC = 15%, $K_d = 12%$, IR de 34% e $D/E = "0,8"$, o ROE é
  $15% + (15% - "7,92"%) times "0,8" = "20,7"%$ --- a alavancagem acrescenta 5,7
  pontos. Por isso um ROE alto sozinho não prova qualidade: pode ser só dívida.
  O ROIC é o indicador mais limpo da qualidade do #emph[negócio].

  #strong[Definições práticas.] $"NOPAT" = "EBIT" (1 - "IR")$ (o lucro operacional
  após impostos, como se não houvesse dívida). O #strong[capital investido] é a
  soma de capital de giro operacional líquido e ativo fixo (ou, equivalentemente,
  dívida líquida + patrimônio líquido).
]

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

```
=== Análise DuPont ===
Margem Líquida:          5.33%
Giro do Ativo:           1.25x
Alavancagem Financeira:  1.71x
---
ROE: 5.33% × 1.25x × 1.71x = 11.43%

Contribuição marginal:
  Margem isolada: 5.33%
  + Giro: 6.67%
  + Alavancagem: 11.43%
```

#teoria("DuPont estendido: cinco componentes")[
  O DuPont de três fatores esconde o efeito dos impostos e dos juros. Decompor
  em cinco:

  $ "ROE" = underbrace("LL"/"LAIR", "carga tributária") times underbrace("LAIR"/"EBIT", "carga de juros")
  times underbrace("EBIT"/"Receita", "margem EBIT") times underbrace("Receita"/"Ativo", "giro")
  times underbrace("Ativo"/"PL", "alavancagem") $

  Exemplo: LL = 90, LAIR = 130, EBIT = 170, Receita = 1.500, Ativo = 1.000,
  PL = 500. Os fatores são: $90/130 = "0,692"$ (a empresa fica com 69,2% do
  lucro antes de impostos), $130/170 = "0,765"$ (os juros consomem 23,5% do
  EBIT), margem EBIT de 11,33%, giro de 1,5x e alavancagem de 2,0x. Produto:
  $"0,692" times "0,765" times "11,33"% times "1,5" times "2,0" = "18,0"%$, igual a $90/500$.
  A vantagem do modelo estendido é separar o que a gestão controla
  (margem e giro), o que depende da estrutura de capital (juros e alavancagem)
  e o que é fiscal.
]

```python
ll_d, lair_d, ebit_d, rec_d, ativo_d, pl_d = 90, 130, 170, 1500, 1000, 500
fatores = {
    "Carga tributária (LL/LAIR)": ll_d / lair_d,
    "Carga de juros (LAIR/EBIT)": lair_d / ebit_d,
    "Margem EBIT (EBIT/Receita)": ebit_d / rec_d,
    "Giro do ativo (Receita/Ativo)": rec_d / ativo_d,
    "Alavancagem (Ativo/PL)": ativo_d / pl_d,
}
roe_5 = 1.0
for nome_f, f_ in fatores.items():
    roe_5 *= f_
    print(f"{nome_f:<32} {f_:8.4f}   ROE acumulado: {roe_5:.2%}")
print(f"ROE direto (LL/PL): {ll_d / pl_d:.2%}")
```

```
Carga tributária (LL/LAIR)         0.6923   ROE acumulado: 69.23%
Carga de juros (LAIR/EBIT)         0.7647   ROE acumulado: 52.94%
Margem EBIT (EBIT/Receita)         0.1133   ROE acumulado: 6.00%
Giro do ativo (Receita/Ativo)      1.5000   ROE acumulado: 9.00%
Alavancagem (Ativo/PL)             2.0000   ROE acumulado: 18.00%
ROE direto (LL/PL): 18.00%
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

```
Receita: 1000
CPV: -600
Despesas Op: -150
= LAJIR (EBIT): 250
+ Depreciação: +80
+ Amortização: +30
= EBITDA: 360
Margem EBITDA: 36.0%
```

#exemplo("EBITDA não é caixa: duas empresas com o mesmo EBITDA")[
  A e B têm EBITDA de R\$ 300 milhões. A é um negócio de serviços, com CapEx de
  R\$ 50 milhões por ano; B é uma siderúrgica, com CapEx de R\$ 250 milhões.
  Ignorando variação do capital de giro e impostos, o caixa disponível
  após investimentos é $300 - 50 = 250$ para A e $300 - 250 = 50$ para B.
  Com o mesmo EBITDA, A gera #strong[cinco vezes mais caixa] para pagar dívidas e
  dividendos. Por isso, em setores de capital intensivo, o indicador
  #strong[EBITDA − CapEx] (ou o fluxo de caixa livre) é mais honesto que o EBITDA.
]

#atencao[
  #strong[EBITDA "ajustado" é opinião.] Cada empresa define seus ajustes (itens
  não recorrentes, despesas com remuneração em ações, custos de
  reestruturação). Antes de comparar, verifique o que foi excluído e se os
  ajustes "não recorrentes" se repetem todos os anos. A regulamentação
  da CVM exige a divulgação da conciliação entre EBITDA e lucro líquido, o que
  facilita o escrutínio.
]

#resumo[
  - As três demonstrações precisam fechar entre si; a DFC explica por que lucro #strong[não é] caixa.
  - Análise vertical (estrutura) e horizontal (dinâmica, CAGR).
  - Liquidez, endividamento e rentabilidade devem ser lidos #strong[por setor] e pela qualidade dos ativos.
  - $"ROE" = "ROIC" + ("ROIC" - K_d(1 - "IR")) D/E$: a alavancagem amplifica o retorno só se o ROIC supera o $K_d$ líquido.
  - DuPont estendido separa carga fiscal, juros, margem, giro e alavancagem.
  - EBITDA ignora CapEx, capital de giro, impostos e juros: não é fluxo de caixa.
]

#line()

== Capítulo 6 --- Estrutura de Capital
<capítulo-6-estrutura-de-capital>
=== 6.1. A Pergunta Fundamental
<a-pergunta-fundamental>
#strong[Existe uma estrutura de capital ótima?] Isto é, uma combinação
dívida/capital próprio que maximiza o valor da empresa?

Esta é uma das questões mais debatidas em finanças corporativas.

#intuicao[
  Pense numa pizza. O tamanho da pizza (o valor da empresa) é determinado pelo
  que ela #emph[produz] --- seus fluxos de caixa operacionais ---, e não pela forma como
  é fatiada entre credores e acionistas. Trocar fatias de dívida por fatias de ações
  não faz a pizza crescer. Esse é o coração da irrelevância de M&M: sem
  atritos (impostos, falências, assimetria de informação), #strong[financiamento
  não cria valor]. É um resultado de referência: os desvios da realidade (impostos,
  custos de falência) é que explicam a estrutura de capital que vemos.
]

=== 6.2. Modigliani-Miller (1958) --- Sem Impostos
<modigliani-miller-1958-sem-impostos>
#strong[Proposição I --- Irrelevância da Estrutura de Capital:]

Em mercados perfeitos (sem impostos, sem custos de falência, sem
assimetria de informação), o valor da empresa #strong[independe] da
estrutura de capital.

$ V_L = V_U $

#strong[Por que isso é verdade: o argumento da arbitragem (alavancagem
caseira).] A prova original de Modigliani-Miller não é um resultado
empírico --- é um argumento de #strong[não-arbitragem]: se as duas
proposições fossem falsas, um investidor poderia montar uma operação
sem risco adicional que gera lucro garantido, o que não pode persistir
em equilíbrio. Suponha que $V_L > V_U$ (a empresa alavancada valha mais
que a desalavancada, para o mesmo fluxo de caixa operacional). Um
investidor que possui uma fração $alpha$ das ações da empresa
alavancada pode:

+ Vender sua posição na empresa alavancada, recebendo $alpha E_L$.
+ Tomar emprestado, por conta própria, uma quantia igual a
  $alpha D$ (reproduzindo, pessoalmente, a mesma proporção de dívida que
  a empresa $L$ tem) --- isso é a #strong[alavancagem caseira]
  (#emph[homemade leverage]).
+ Usar o total ($alpha E_L + alpha D = alpha V_L$) para comprar uma
  fração $alpha$ da empresa desalavancada $U$, ao custo $alpha V_U$.

Como $V_L > V_U$, sobra dinheiro no bolso do investidor
($alpha\(V_L - V_U\) > 0$) --- e, crucialmente, o fluxo de caixa que ele
recebe da nova posição (ações de $U$ menos os juros da dívida pessoal
que contraiu) é #strong[idêntico], estado por estado da natureza, ao que
ele recebia antes como acionista de $L$. Ele replicou exatamente a mesma
exposição a risco e retorno, mas embolsou uma diferença positiva
imediata --- um #strong[almoço grátis], que outros investidores
também tentariam capturar, comprando $U$ e vendendo $L$ até que os
preços se ajustem e $V_L = V_U$. É esse mecanismo --- não uma hipótese
sobre o comportamento de gestores --- que sustenta a Proposição I sob os
pressupostos de mercado perfeito (sem impostos, sem custos de falência,
sem assimetria de informação, e a capacidade de qualquer investidor
tomar emprestado à mesma taxa que a empresa). A Proposição II
(abaixo) é uma consequência algébrica direta de $V_L = V_U$ combinada
com a definição de WACC --- não uma hipótese independente.

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

```
M&M sem impostos:
  D/E = 0.00: Ke = 15.00%, WACC = 15.00%
  D/E = 0.25: Ke = 16.25%, WACC = 15.00%
  D/E = 0.50: Ke = 17.50%, WACC = 15.00%
  D/E = 1.00: Ke = 20.00%, WACC = 15.00%
  D/E = 2.00: Ke = 25.00%, WACC = 15.00%
```

#exemplo("a arbitragem de M&M com números")[
  Duas empresas idênticas (mesmo lucro operacional perpétuo, EBIT de R\$ 150
  milhões, sem impostos), com custo de capital do ativo $K_u = 15%$. A empresa
  desalavancada U vale $150/"0,15" = 1.000$ milhões. A empresa L deve R\$ 400 milhões
  a 10% (juros de R\$ 40 milhões) e suponha que o mercado a avalie em
  $V_L = 1.100$, ou seja, $E_L = 700$ --- mais do que U, só por ter dívida.

  Um investidor que possui 10% de L (R\$ 70 milhões) recebe $10% times
  (150 - 40) = 11$ por ano. Ele pode, em vez disso: (1) vender a posição em L
  (+70); (2) tomar emprestado 10% do endividamento de L, ou seja, R\$ 40
  milhões, a 10% (juros de 4); (3) comprar 10% de U por R\$ 100 milhões.
  Entradas: $70 + 40 = 110$; saída: 100; #strong[sobram R\$ 10 milhões hoje].
  O fluxo anual da nova posição é $10% times 150 - 4 = 11$: #strong[o mesmo] de
  antes. É dinheiro grátis sem risco adicional; os investidores correm para
  vender L e comprar U até que $V_L = V_U$. Se o mercado avaliasse L
  em menos que U, a arbitragem seria no sentido oposto.
]

#teoria("dedução da Proposição II")[
  Se o valor da empresa é o mesmo, seu custo médio de capital também é: o
  WACC (sem impostos) iguala o custo do ativo $K_u$. Então

  $ K_u dot V = K_e dot E + K_d dot D quad arrow.r.double quad K_e = K_u dot V/E - K_d dot D/E $

  Como $V/E = (E + D)/E = 1 + D/E$, obtém-se
  $K_e = K_u + (K_u - K_d) D/E$ (a Proposição II). O custo do capital próprio
  cresce #strong[linearmente] com a alavancagem, na proporção do spread entre
  o retorno do ativo e o custo da dívida. O acionista de uma empresa
  alavancada exige mais porque seu fluxo é mais arriscado (risco
  financeiro): a dívida é "mais barata" mas torna o patrimônio "mais caro",
  e os dois efeitos se anulam. #strong[Premissa:] a fórmula supõe dívida sem
  risco de inadimplência ($K_d$ constante); com dívida arriscada, o $K_e$ sobe mais
  devagar, porque parte do risco passa aos credores.
]

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
    print(f"  Dívida = {d:3d}: VL = R${res['VL']:,.0f} (Benefício = R${res['Benefício Fiscal']:,.0f})")
```

```
M&M com impostos (IR = 34%):
  Dívida =   0: VL = R$1,000 (Benefício = R$0)
  Dívida = 100: VL = R$1,034 (Benefício = R$34)
  Dívida = 200: VL = R$1,068 (Benefício = R$68)
  Dívida = 300: VL = R$1,102 (Benefício = R$102)
  Dívida = 400: VL = R$1,136 (Benefício = R$136)
```

#teoria("dedução do benefício fiscal e das fórmulas com impostos")[
  Com dívida perpétua $D$ a custo $K_d$, os juros anuais são $K_d D$ e a economia
  fiscal anual é $"IR" dot K_d D$. Descontada à taxa $K_d$ (o risco do
  benefício é o da dívida), o #strong[valor presente do escudo fiscal] é

  $ "VP"("escudo") = ("IR" dot K_d dot D)/K_d = "IR" dot D $

  Daí $V_L = V_U + "IR" dot D$. Com impostos, a Proposição II e o WACC passam a ser

  $ K_e = K_u + (K_u - K_d)(1 - "IR") D/E quad "e" quad "WACC" = K_u (1 - "IR" dot D/V) $

  O WACC #strong[cai] com a dívida (cada real de dívida corta o custo de capital por
  causa do escudo). Exemplo: $V_U = 2.000$, $D = 600$, $K_u = 14%$, $K_d = 9%$ e IR de 34%:
  $V_L = 2.000 + "0,34" times 600 = 2.204$; $E = 1.604$; $K_e = 14% + 5% times "0,66"
  times 600/1.604 = "15,23"%$; e o WACC $= 14% times (1 - "0,34" times 600/2.204) = "12,70"%$.
  A conta direta $(E/V) K_e + (D/V) K_d (1 - "IR")$ dá o mesmo resultado.
]

```python
vu_x, d_x, ir_x, ku_x, kd_x = 2000, 600, 0.34, 0.14, 0.09
vl_x = vu_x + ir_x * d_x
e_x = vl_x - d_x
ke_x = ku_x + (ku_x - kd_x) * (1 - ir_x) * d_x / e_x
wacc_direto = (e_x / vl_x) * ke_x + (d_x / vl_x) * kd_x * (1 - ir_x)
wacc_formula = ku_x * (1 - ir_x * d_x / vl_x)
print(f"VL = R${vl_x:,.0f} | E = R${e_x:,.0f} | Ke = {ke_x:.2%}")
print(f"WACC (média ponderada): {wacc_direto:.4%} | WACC = Ku(1 - IR·D/V): {wacc_formula:.4%}")
```

```
VL = R$2,204 | E = R$1,604 | Ke = 15.23%
WACC (média ponderada): 12.7042% | WACC = Ku(1 - IR·D/V): 12.7042%
```

#atencao[
  O exemplo resolvido E6 do capítulo 13 usa a Proposição II #strong[sem
  impostos] para o novo $K_e$, "para efeito didático". A fórmula coerente com a
  versão com impostos de M&M é a acima, com o termo $(1 - "IR")$.
]

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

#teoria("o ponto ótimo do trade-off, com números")[
  Some ao valor de M&M com impostos um #strong[custo esperado de falência] que
  cresce mais que proporcionalmente com a dívida. Em um modelo simples,
  $V_L = V_U + "IR" dot D - k D^2$. Igualando a derivada a zero,
  $"IR" - 2 k D = 0$, o nível ótimo de dívida é

  $ D^* = "IR"/(2 k) $

  O benefício marginal (IR, constante) iguala o custo marginal de
  falência (crescente). Com $V_U = 1.500$, IR de 34% e $k = "0,0012"$,
  $D^* = "0,34"/"0,0024" = "141,7"$ e o valor máximo é R\$ 1.524,08 --- apenas 1,6%
  acima do valor sem dívida: o ganho de otimizar é modesto, e a curva é
  #strong[achatada] perto do ótimo.
]

```python
vu_t, ir_t, k_t = 1500, 0.34, 0.0012
div = np.arange(0, 601, 10)
v_sem = np.full(div.shape, vu_t, dtype=float)
v_escudo = vu_t + ir_t * div
v_tradeoff = vu_t + ir_t * div - k_t * div ** 2
i_ot = int(np.argmax(v_tradeoff))
print(f"Dívida ótima (grade): R${div[i_ot]} | valor máximo R${v_tradeoff[i_ot]:,.2f} | fórmula D* = {ir_t / (2 * k_t):.1f}")

plt.figure(figsize=(8.5, 4.4))
plt.plot(div, v_sem, color="gray", linestyle=":", label="V_U (sem dívida)")
plt.plot(div, v_escudo, color="#1d4f91", linestyle="--", label="M&M com impostos (escudo fiscal)")
plt.plot(div, v_tradeoff, color="#a33a1c", linewidth=2, label="Trade-off (escudo − custo de falência)")
plt.axvline(div[i_ot], color="black", linestyle=":", linewidth=0.8)
plt.xlabel("Dívida (R$ milhões)"); plt.ylabel("Valor da empresa (R$ milhões)")
plt.title("Trade-off: o valor máximo está num nível intermediário de dívida")
plt.legend(); plt.grid(alpha=0.3)
plt.savefig("figuras07/tradeoff.png", dpi=170, bbox_inches="tight")
```

```
Dívida ótima (grade): R$140 | valor máximo R$1,524.08 | fórmula D* = 141.7
```

#figure(
  image("figuras07/tradeoff.png", width: 85%),
  caption: [Com custos de falência crescentes, o valor da empresa tem um máximo interior; antes dele a dívida agrega valor, depois destrói.],
)

#strong[Determinantes da capacidade de endividamento.] O ótimo $D^*$ depende
de quão altos são os custos de falência, que variam entre empresas: ativos
#strong[tangíveis] e fáceis de vender (imóveis, máquinas) como garantia reduzem
o custo de falência; ativos #strong[intangíveis] (marca, tecnologia, capital humano)
e fluxos de caixa #strong[voláteis] o aumentam. Isso explica por que empresas de
tecnologia e farmacêuticas usam menos dívida que utilidades e imobiliárias.
Há ainda #strong[custos de agência da dívida]: com muita dívida, os acionistas
podem preferir projetos arriscados (que lhes transferem valor dos credores)
ou recusar bons projetos que beneficiariam sobretudo os credores
(subinvestimento).

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

#figure(
  align(center)[#table(
    columns: (20%, 27%, 27%, 26%),
    align: (left, left, left, left),
    table.header([Teoria], [Ideia central], [Previsão], [Evidência],),
    [M&M (1958)], [Sem atritos, estrutura de capital é irrelevante], [Sem estrutura ótima], [Referência teórica; desvios existem],
    [M&M (1963)], [Escudo fiscal agrega $"IR" dot D$], [100% de dívida seria ótimo], [Empresas não se endividam ao máximo],
    [Trade-off], [Escudo fiscal × custos de falência], [Existe um alvo de endividamento por setor], [Convergência parcial ao alvo; setores diferem],
    [Pecking order], [Assimetria de informação: recursos internos > dívida > ações], [Empresas lucrativas se endividam menos; emissões de ações são raras], [Boa explicação do comportamento de empresas de crescimento],
  )]
  , kind: table
  )

#mercado[
  No Brasil, a estrutura de capital sofre influências específicas: o crédito
  subsidiado de bancos de fomento (BNDES) por décadas tornou a dívida de longo
  prazo mais barata que a do mercado; juros básicos altos encarecem o endividamento
  em reais; o mercado de debêntures cresceu com incentivos fiscais
  (debêntures incentivadas); e a possibilidade de pagar #strong[juros sobre capital
  próprio] (JCP) dedutíveis cria um escudo fiscal mesmo para o capital dos
  acionistas (capítulo 7). Esses elementos deslocam o "ótimo" brasileiro em relação ao
  de países com juros baixos.
]

#resumo[
  - M&M sem impostos: $V_L = V_U$ (arbitragem); $K_e = K_u + (K_u - K_d) D/E$; WACC constante.
  - Com impostos: $V_L = V_U + "IR" dot D$; $"WACC" = K_u(1 - "IR" dot D/V)$ cai com a dívida.
  - Trade-off: escudo fiscal contra custos de falência; $D^* = "IR"/(2k)$ no modelo quadrático.
  - Pecking order: recursos internos, depois dívida, por último ações (assimetria de informação).
]

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
    print(f"{'LPA':<20} R${lpa:.2f}")
    print(f"{'DPA':<20} R${dpa:.2f}")
    print(f"{'Pay-out':<20} {pay_out*100:.1f}%")
    print(f"{'Dividend Yield':<20} {dy*100:.2f}%")
    print(f"{'Retenção (1-pay-out)':<20} {(1-pay_out)*100:.1f}%")

metricas_dividendos(500e6, 200e6, 100e6, 35)
```

```
Métrica              Valor
------------------------------
LPA                  R$5.00
DPA                  R$2.00
Pay-out              40.0%
Dividend Yield       5.71%
Retenção (1-pay-out) 60.0%
```

#teoria("crescimento sustentável e a conexão com o valor")[
  O crescimento que a empresa consegue financiar #strong[sem emitir ações nem
  mudar a alavancagem] é $g = "ROE" times "retenção"$, onde
  $"retenção" = 1 - "payout"$. Retém-se mais lucro para reinvestir, cresce-se
  mais, mas pagam-se menos dividendos. A pergunta de valor é: reter lucro cria
  valor? Pelo modelo de Gordon, $P_0 = D_1/(K_e - g)$, e a resposta
  depende da relação entre o #strong[ROE (retorno do reinvestimento)] e o
  #strong[$K_e$ (retorno exigido)].
]

```python
lpa_1, ke_dv = 5.00, 0.15      # LPA esperado no próximo ano e custo de capital próprio
print(f"{'ROE':>5} {'Payout':>7} {'g':>6} {'D1':>6} {'Preço (Gordon)':>15}")
for roe_p in (0.20, 0.15, 0.10):
    for payout_p in (0.40, 0.70):
        g_p = roe_p * (1 - payout_p)
        d1_p = lpa_1 * payout_p
        print(f"{roe_p:>5.0%} {payout_p:>7.0%} {g_p:>6.1%} {d1_p:>6.2f} {d1_p / (ke_dv - g_p):>15.2f}")
```

```
  ROE  Payout      g     D1  Preço (Gordon)
  20%     40%  12.0%   2.00           66.67
  20%     70%   6.0%   3.50           38.89
  15%     40%   9.0%   2.00           33.33
  15%     70%   4.5%   3.50           33.33
  10%     40%   6.0%   2.00           22.22
  10%     70%   3.0%   3.50           29.17
```

#exemplo("quando reter lucro vale a pena")[
  Na tabela, com $K_e = 15%$:

  - #strong[ROE = 20% > $K_e$:] reinvestir cria valor. Com pay-out de 40% o preço
    é R\$ 66,67; com 70%, só R\$ 38,89. #strong[Reter vale mais].
  - #strong[ROE = 15% = $K_e$:] os dois pay-outs dão R\$ 33,33. #strong[A política é
    irrelevante] --- a empresa reinveste a uma taxa igual à que o acionista
    exigiria. É a irrelevância de M&M.
  - #strong[ROE = 10% < $K_e$:] reinvestir destrói valor: 40% de pay-out dá
    R\$ 22,22; 70% dá R\$ 29,17. #strong[Distribuir vale mais].

  Dividendos não "criam" nem "destroem" valor por si; o que importa é a
  #strong[qualidade do reinvestimento]. Uma empresa madura sem projetos com
  retorno acima do custo de capital deveria distribuir o caixa.
]

#mercado[
  Pela Lei das S.A., o estatuto pode fixar o dividendo obrigatório; na
  ausência de previsão, o mínimo é de #strong[25% do lucro líquido ajustado].
  A empresa também pode remunerar o acionista com #strong[juros sobre capital
  próprio] (JCP): dedutíveis do IR da empresa (dentro de limites), com retenção de imposto na fonte para o
  acionista. A tributação dos dividendos de pessoas físicas foi alvo de
  reformas recentes; confirme as regras vigentes antes de basear uma
  decisão nelas.
]

=== 7.3. Teoria da Irrelevância (M&M, 1961)
<teoria-da-irrelevância-mm-1961>
Em mercados perfeitos, a política de dividendos #strong[não afeta o
valor da empresa]. O valor deriva da capacidade de gerar lucro e da
política de investimentos, não da forma como o lucro é distribuído.

#strong[Argumento:] se a empresa retém lucros em vez de distribuir, o
preço da ação aumenta compensando o dividendo não recebido. O acionista
pode criar seu próprio dividendo vendendo ações.

#exemplo("a irrelevância com números: dividendo caseiro")[
  Uma empresa tem 1.000 ações cotadas a R\$ 10,00 (valor de mercado R\$ 10.000)
  e R\$ 1.000 em caixa excedente. Um investidor tem 100 ações (R\$ 1.000).

  #figure(
    align(center)[#table(
      columns: (34%, 33%, 33%),
      align: (left, right, right),
      table.header([], [Empresa paga R\$ 1/ação], [Empresa retém],),
      [Preço ex-dividendo], [R\$ 9,00], [R\$ 10,00],
      [Dividendos do investidor], [R\$ 100], [R\$ 0],
      [Valor das ações do investidor], [R\$ 900], [R\$ 1.000],
      [#strong[Riqueza total]], [#strong[R\$ 1.000]], [#strong[R\$ 1.000]],
    )]
    , kind: table
    )

  Se a empresa retém e o investidor #emph[quer] caixa, ele vende 10 ações a R\$
  10,00 e obtém os mesmos R\$ 100: um #strong[dividendo caseiro]. Se a empresa
  paga e o investidor não quer caixa, reinveste os R\$ 100 comprando 11,1
  ações. Sem impostos e custos de transação, o investidor chega ao mesmo
  lugar --- a política da empresa é irrelevante.
]

#exemplo("dividendo ou recompra de ações?")[
  Uma empresa com 100 milhões de ações a R\$ 20 (valor de mercado de R\$ 2.000
  milhões) e lucro de R\$ 200 milhões distribui R\$ 100 milhões.

  - #strong[Dividendo:] R\$ 1,00 por ação; o preço cai para R\$ 19,00 (a empresa
    ficou R\$ 100 milhões menor). Riqueza do acionista: $19 + 1 = 20$.
  - #strong[Recompra:] compra 5 milhões de ações a R\$ 20; sobram 95 milhões de ações e
    valor de mercado de R\$ 1.900 milhões, ou $1.900/95 = $ R\$ 20,00 por ação.
    Riqueza: 20.

  A riqueza é a mesma, mas o #strong[LPA] sobe de $200/100 = "2,00"$ para
  $200/95 = "2,11"$ (+5,3%) na recompra --- uma "melhora" meramente
  aritmética, que não cria valor. A escolha entre as duas depende de
  tributação, flexibilidade (dividendos criam expectativa de continuidade;
  recompras são pontuais) e sinalização (uma recompra pode indicar que
  a diretoria considera a ação barata).
]

=== 7.4. Teoria do Pássaro na Mão (Gordon, 1963)
<teoria-do-pássaro-na-mão-gordon-1963>
#strong[Contraria M&M:] investidores preferem dividendos hoje a ganhos
de capital futuros (mais arriscados). Portanto, um aumento no pay-out
reduz o Ke e aumenta o valor da empresa.

#teoria("por que o 'pássaro na mão' é questionado e o que é sinalização")[
  O argumento de Gordon e Lintner --- dividendos são menos arriscados que
  ganhos de capital, logo reduzem $K_e$ --- foi criticado por M&M: o risco
  de uma empresa é determinado por seus #strong[fluxos operacionais], não pelo
  rótulo dado ao retorno (dividendo ou valorização). Quem recebe dividendos
  continua exposto ao risco do negócio, e precisa #emph[reinvestir] os dividendos.

  Há, porém, uma explicação empírica forte para a reação positiva dos preços a
  aumentos de dividendos: a #strong[teoria da sinalização]. Os gestores têm
  informação privilegiada; aumentar o dividendo é um #strong[compromisso
  caro de manter], pois cortá-lo depois é punido pelo mercado. Logo, só gestores
  confiantes em fluxos de caixa futuros o aumentam. O aumento comunica
  #emph[informação], não "valor intrínseco do dividendo". E o corte de
  dividendos para financiar projetos de alto retorno pode ser #emph[bem recebido] ---
  quando a empresa convence o mercado de que o reinvestimento tem ROE acima
  do $K_e$ (tabela da seção 7.2).
]

=== 7.5. Efeito Clientela
<efeito-clientela>
Diferentes grupos de investidores preferem diferentes políticas de
dividendos: - #strong[Aposentados:] preferem alta distribuição (renda) -
#strong[Fundos de pensão:] podem preferir retenção (crescimento) -
#strong[Empresas:] podem preferir recompra de ações (tributação menor)

#figure(
  align(center)[#table(
    columns: (22%, 26%, 26%, 26%),
    align: (left, left, left, left),
    table.header([Teoria], [Quem ganha?], [Ideia], [Quando faz sentido],),
    [Irrelevância (M&M)], [Ninguém], [Política não afeta valor], [Mercados perfeitos],
    [Pássaro na mão], [Quem prefere renda], [Dividendo reduz o risco percebido], [Investidores que precisam de renda (críticas fortes)],
    [Clientela], [Cada grupo na sua política], [Investidores escolhem ações pela política], [Tributação e necessidade de renda diferem],
    [Sinalização], [Mercado informado], [Dividendo transmite informação], [Assimetria de informação],
    [Residual], [A empresa], [Distribui só o que sobra após bons projetos], [Empresas com oportunidades de crescimento],
  )]
  , kind: table
  )

#resumo[
  - Dividendos não criam valor por si: o que importa é o #strong[retorno do reinvestimento] versus o $K_e$.
  - Crescimento sustentável $g = "ROE" times "retenção"$; $P_0 = D_1/(K_e - g)$.
  - Dividendo caseiro e recompra mostram a irrelevância sem atritos; impostos, sinalização e clientela quebram a equivalência.
]

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

    print(f"{'Indicador':<25} {'Valor (R$)'}")
    print("-" * 35)
    print(f"{'Capital Circulante Líquido':<25} R${ccl:,.2f}")
    print(f"{'Necessidade de Capital de Giro':<25} R${ncg:,.2f}")
    print(f"{'Saldo de Tesouraria':<25} R${st:,.2f}")

    if st >= 0:
        print("\nSituação: CONFORTO FINANCEIRO (ST >= 0)")
    elif st >= -ncg * 0.3:
        print("\nSituação: ATENÇÃO (ST negativo moderado)")
    else:
        print("\nSituação: RISCO (ST muito negativo)")

diagnostico_capital_giro(8000, 5000, 6000, 3000)
```

```
Indicador                 Valor (R$)
-----------------------------------
Capital Circulante Líquido R$3,000.00
Necessidade de Capital de Giro R$3,000.00
Saldo de Tesouraria       R$0.00

Situação: CONFORTO FINANCEIRO (ST >= 0)
```

#teoria("de onde vem a fórmula ST = CCL − NCG")[
  O capital circulante líquido (CCL) é apenas a diferença entre o ativo
  circulante (AC) e o passivo circulante (PC). A análise dinâmica (modelo de Fleuriet)
  separa cada um deles em parte #strong[operacional] (ligada ao ciclo do
  negócio) e #strong[financeira] (caixa, aplicações e empréstimos de curto prazo):

  $ "CCL" = ("AC"_("op") + "AC"_("fin")) - ("PC"_("op") + "PC"_("fin")) $

  Reagrupando: $"CCL" = underbrace("AC"_("op") - "PC"_("op"), "NCG") + underbrace("AC"_("fin") - "PC"_("fin"), "ST")$, logo $"ST" = "CCL" - "NCG"$.
  A NCG é o #strong[investimento permanente] em estoques e clientes, líquido do
  crédito de fornecedores e obrigações operacionais: se positiva, alguém
  precisa financiá-la --- com recursos de longo prazo (CCL), caixa próprio
  ou, pior, #strong[empréstimos de curto prazo] (ST negativo).
]

#exemplo("efeito tesoura: crescer consome caixa")[
  Uma empresa tem NCG equivalente a 20% da receita e margem líquida de 3%.
  Cada R\$ 100 de vendas a mais exigem R\$ 20 de capital de giro adicional e
  geram apenas R\$ 3 de lucro: o #strong[crescimento consome caixa]. Com receita
  de R\$ 1.000 crescendo 20% ao ano, a empresa precisa de mais R\$ 40 de NCG
  no primeiro ano para um lucro adicional de R\$ 6 --- se não houver
  financiamento, o ST fica cada vez mais negativo. É o "efeito tesoura":
  as necessidades de caixa crescem mais rápido que a geração de caixa,
  e muitas empresas lucrativas quebram assim.
]

```python
receita_t, margem_t, ncg_pct, cresc_t = 1000, 0.03, 0.20, 0.20
ncg_ant = receita_t * ncg_pct
print(f"{'Ano':>4} {'Receita':>9} {'Lucro':>7} {'NCG':>7} {'ΔNCG':>7} {'Caixa gerado':>13}")
for ano_t in range(1, 5):
    receita_t *= 1 + cresc_t
    ncg_t = receita_t * ncg_pct
    lucro_t = receita_t * margem_t
    print(f"{ano_t:>4} {receita_t:>9.0f} {lucro_t:>7.1f} {ncg_t:>7.1f} {ncg_t - ncg_ant:>7.1f} {lucro_t - (ncg_t - ncg_ant):>13.1f}")
    ncg_ant = ncg_t
```

```
 Ano   Receita   Lucro     NCG    ΔNCG  Caixa gerado
   1      1200    36.0   240.0    40.0          -4.0
   2      1440    43.2   288.0    48.0          -4.8
   3      1728    51.8   345.6    57.6          -5.8
   4      2074    62.2   414.7    69.1          -6.9
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

```
=== Indústria ===
Prazo médio de estocagem: 60 dias
Prazo médio de recebimento: 45 dias
Prazo médio de pagamento: 30 dias
---
Ciclo Operacional (CO): 105 dias
Ciclo Financeiro (CF): 75 dias

A empresa precisa financiar 75 dias de operação.

=== Varejo (supermercado) ===
Prazo médio de estocagem: 30 dias
Prazo médio de recebimento: 7 dias
Prazo médio de pagamento: 45 dias
---
Ciclo Operacional (CO): 37 dias
Ciclo Financeiro (CF): -8 dias

A empresa opera com capital de giro negativo (vantagem competitiva).
```

#teoria("como calcular os prazos a partir do balanço")[
  Os prazos médios se obtêm dividindo a conta de balanço pelo fluxo da DRE
  correspondente e multiplicando por 360 (ou 365) dias:

  $ "PME" = "Estoques"/"CPV" times 360 quad "PMR" = "Contas a receber"/"Receita" times 360 quad "PMP" = "Fornecedores"/"Compras" times 360 $

  O #strong[ciclo operacional] é $"PME" + "PMR"$ (do dinheiro virar estoque até virar
  caixa de clientes); o #strong[ciclo financeiro] é $"CO" - "PMP"$ (quantos dias
  a empresa financia com recursos próprios ou de terceiros). A NCG é aproximadamente
  $"Receita"/360 times "Ciclo financeiro"$.
]

#exemplo("quanto vale encurtar o ciclo?")[
  Estoques de R\$ 300, CPV de R\$ 1.800, contas a receber de R\$ 400, receita de
  R\$ 2.400, fornecedores de R\$ 150, compras de R\$ 1.500:

  - $"PME" = 300/1.800 times 360 = 60$ dias; $"PMR" = 400/2.400 times 360 = 60$ dias;
    $"PMP" = 150/1.500 times 360 = 36$ dias.
  - Ciclo operacional: 120 dias. Ciclo financeiro: $120 - 36 = 84$ dias.

  Se a empresa reduzir o prazo de recebimento em 10 dias (cobrança mais
  eficiente), libera $2.400/360 times 10 = "66,7"$ de caixa. Aplicado ao CDI de
  13,25%, isso vale R\$ 8,8 por ano de economia financeira. Nenhuma venda a mais:
  só gestão do capital de giro. Cada dia de ciclo tem custo.
]

```python
estoques_c, cpv_c, receber_c, receita_c, fornec_c, compras_c = 300, 1800, 400, 2400, 150, 1500
pme_c = estoques_c / cpv_c * 360
pmr_c = receber_c / receita_c * 360
pmp_c = fornec_c / compras_c * 360
co_c, cf_c = pme_c + pmr_c, pme_c + pmr_c - pmp_c
print(f"PME {pme_c:.0f} d | PMR {pmr_c:.0f} d | PMP {pmp_c:.0f} d | ciclo operacional {co_c:.0f} d | ciclo financeiro {cf_c:.0f} d")
print(f"NCG aproximada: R${receita_c / 360 * cf_c:,.1f}")
liberado = receita_c / 360 * 10
print(f"Reduzir o PMR em 10 dias libera R${liberado:.1f} e economiza R${liberado * 0.1325:.2f}/ano a 13,25% a.a.")
```

```
PME 60 d | PMR 60 d | PMP 36 d | ciclo operacional 120 d | ciclo financeiro 84 d
NCG aproximada: R$560.0
Reduzir o PMR em 10 dias libera R$66.7 e economiza R$8.83/ano a 13,25% a.a.
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

#atencao[
  #strong[Capital de giro negativo tem um calcanhar de Aquiles.] A empresa
  que financia ativos com crédito de fornecedores opera com folga #emph[enquanto
  o crédito é renovado]. Se os fornecedores cortarem o prazo (por perda de
  confiança, por exemplo), o caixa some depressa. Daí o paradoxo de
  varejistas com capital de giro negativo que quebram rápido ao perder a
  confiança do mercado. E um capital de giro negativo #strong[não equivale] a
  problema de liquidez, mas exige atenção ao risco de #emph[renovação].
]

#resumo[
  - $"ST" = "CCL" - "NCG"$; ST negativo significa financiar a operação com dívida de curto prazo.
  - Prazos: $"PME" = "Estoque"/"CPV" times 360$; $"PMR"$ e $"PMP"$ análogos; ciclo financeiro $= "PME" + "PMR" - "PMP"$.
  - Crescer consome caixa (efeito tesoura); cada dia de ciclo financeiro tem custo de oportunidade.
]

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

#atencao[
  #strong[Diversificação não é motivo válido para o acionista.] O argumento
  "reduz o risco" é fraco: o acionista pode diversificar sozinho, comprando ações de
  outras empresas, sem pagar prêmio de controle. A diversificação corporativa
  só interessa a #emph[gestores] cujo emprego depende da empresa --- uma
  fonte clássica de conflito de agência. A evidência empírica mostra que, na
  média, as fusões #strong[criam valor para os acionistas do alvo] (que
  recebem o prêmio) e valor ao redor de zero, às vezes negativo, para os da
  adquirente, o que reforça o problema do "vencedor amaldiçoado": quem
  vence um leilão tende a ser quem mais superestimou as sinergias.
]

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

    print(f"Valor A (isolado): R${v_a:,.0f} M")
    print(f"Valor B (isolado): R${v_b:,.0f} M")
    print(f"Valor AB (combinado): R${v_ab:,.0f} M")
    print(f"---")
    print(f"Sinergia total: R${sinergia:,.0f} M")
    print(f"Prêmio pago aos acionistas de B: R${premio_pago:,.0f} M")
    print(f"Valor líquido para acionistas de A: R${valor_comprador:,.0f} M")

    if valor_comprador > 0:
        print("Fusão CRIADORA de valor para A")
    else:
        print("Fusão DESTRUIDORA de valor para A")

analise_sinergia(500, 300, 950, 60)
```

```
Valor A (isolado): R$500 M
Valor B (isolado): R$300 M
Valor AB (combinado): R$950 M
---
Sinergia total: R$150 M
Prêmio pago aos acionistas de B: R$60 M
Valor líquido para acionistas de A: R$90 M
Fusão CRIADORA de valor para A
```

#teoria("quanto valem as sinergias e quem fica com elas")[
  As sinergias de #strong[custo] (eliminar áreas duplicadas, ganhar escala nas
  compras) são as mais previsíveis; as de #strong[receita] (vendas cruzadas) são
  incertas. Para valorá-las, projetam-se os fluxos incrementais, desconta-se
  a uma taxa compatível com o risco (maior para sinergias de receita) e
  subtraem-se os #strong[custos de integração] (únicos).

  Exemplo: economia de R\$ 30 milhões por ano antes de impostos, perpétua; IR
  de 34%; custo de integração único de R\$ 40 milhões; taxa de 12%. Valor presente
  $= 30 times "0,66"/"0,12" - 40 = 165 - 40 = $ R\$ 125 milhões. Esse é o #strong[teto]
  do prêmio: pagar mais que R\$ 125 milhões transfere para os acionistas do alvo
  todo o valor criado --- e mais.

  $ "Valor para A" = "Sinergia" - "Prêmio" $
  $ "Valor para B" = "Prêmio" $
]

#exemplo("pagar em dinheiro ou em ações?")[
  A tem 100 milhões de ações a R\$ 30,00 (valor R\$ 3.000 milhões); B vale R\$
  800 milhões e há sinergia de R\$ 200 milhões. A oferece R\$ 950 milhões por B
  (prêmio de R\$ 150 milhões). Valor combinado: $3.000 + 800 + 200 = 4.000$.

  - #strong[Em dinheiro] (financiado por dívida): os acionistas de A ficam com o que
    sobra, $4.000 - 950 = 3.050$, ou R\$ 30,50 por ação (+1,7%).
  - #strong[Em ações:] A emite $950/30 = "31,67"$ milhões de ações novas; passa a ter
    131,67 milhões; valor por ação $= 4.000/"131,67" = $ R\$ 30,38 (+1,3%).

  No pagamento em ações, os acionistas do alvo passam a #strong[dividir] os
  ganhos (e as perdas) da combinação, em proporção à participação;
  em dinheiro, a adquirente assume todo o risco de as sinergias não se
  concretizarem. Por isso o adquirente confiante nas sinergias prefere
  dinheiro, e o inseguro, ações.
]

```python
def fusao_dinheiro_acoes(acoes_a, preco_a, v_b, sinergia_s, oferta):
    valor_comb = acoes_a * preco_a + v_b + sinergia_s
    por_acao_cash = (valor_comb - oferta) / acoes_a
    novas = oferta / preco_a
    por_acao_stock = valor_comb / (acoes_a + novas)
    return por_acao_cash, por_acao_stock, novas

cash_p, stock_p, novas_p = fusao_dinheiro_acoes(100, 30, 800, 200, 950)
print(f"Dinheiro: R${cash_p:.2f}/ação ({cash_p / 30 - 1:+.2%}) | ações: R${stock_p:.2f}/ação ({stock_p / 30 - 1:+.2%}) | ações novas: {novas_p:.2f} milhões")
print("Se a sinergia fosse zero:")
cash0, stock0, _ = fusao_dinheiro_acoes(100, 30, 800, 0, 950)
print(f"Dinheiro: R${cash0:.2f}/ação ({cash0 / 30 - 1:+.2%}) | ações: R${stock0:.2f}/ação ({stock0 / 30 - 1:+.2%})")
```

```
Dinheiro: R$30.50/ação (+1.67%) | ações: R$30.38/ação (+1.27%) | ações novas: 31.67 milhões
Se a sinergia fosse zero:
Dinheiro: R$28.50/ação (-5.00%) | ações: R$28.86/ação (-3.80%)
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

#mercado[
  #strong[Defesa da concorrência.] Fusões entre empresas de porte relevante
  precisam ser submetidas ao CADE (#emph[ato de concentração]), que pode
  aprovar, impor remédios (como venda de ativos) ou vetar. Fusões
  horizontais (concorrentes) sofrem escrutínio mais rigoroso. Para
  empresas de capital aberto, há ainda regras da CVM (fato relevante, oferta
  pública de aquisição) para proteger acionistas minoritários.
]

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

#resumo[
  - Sinergia $= V("AB") - [V("A") + V("B")]$; o valor para o adquirente é #strong[sinergia menos prêmio].
  - Sinergias de custo são mais confiáveis que as de receita; desconte e subtraia custos de integração.
  - O prêmio máximo racional é o valor da sinergia; pagar mais transfere toda a riqueza ao alvo.
  - Pagamento em ações divide o risco das sinergias com os acionistas do alvo; em dinheiro, não.
  - O processo (due diligence, valuation, negociação, integração) é tão importante quanto o preço.
]

#line()

== Capítulo 10 --- Finanças Comportamentais
<capítulo-10-finanças-comportamentais>
=== 10.1. Racionalidade Limitada
<racionalidade-limitada>
A teoria financeira clássica assume que investidores são
#strong[racionais] e mercados são #strong[eficientes]. As finanças
comportamentais relaxam essas premissas, incorporando insights da
psicologia.

#teoria("a hipótese de mercado eficiente (EMH) e seus limites")[
  Fama (1970) classificou a eficiência em três formas, conforme a informação
  incorporada aos preços:

  #figure(
    align(center)[#table(
      columns: (20%, 40%, 40%),
      align: (left, left, left),
      table.header([Forma], [Informação refletida no preço], [Consequência],),
      [#strong[Fraca]], [Preços e volumes passados], [Análise técnica não gera retorno anormal],
      [#strong[Semiforte]], [Toda informação pública], [Análise fundamentalista também não],
      [#strong[Forte]], [Também informação privada], [Nem informação privilegiada gera ganho],
    )]
    , kind: table
    )

  A EMH não diz que os preços estão sempre "certos", mas que
  #strong[não se pode prever consistentemente os desvios]. As finanças
  comportamentais contestam a premissa de racionalidade; os defensores da EMH
  respondem com os #strong[limites da arbitragem]: mesmo que existam
  preços "errados", corrigir exige capital, tempo e tolerância ao risco de
  o erro aumentar antes de diminuir ("o mercado pode ficar irracional por mais
  tempo do que você consegue ficar solvente").
]

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

#teoria("teoria da perspectiva: a função valor de Kahneman e Tversky")[
  Pela teoria da utilidade esperada, o investidor avalia a #emph[riqueza final]
  e é avesso a risco. Kahneman e Tversky (1979) mostraram que as pessoas avaliam
  #strong[ganhos e perdas em relação a um ponto de referência], e que a função valor é:
  #strong[côncava nos ganhos] (aversão a risco), #strong[convexa nas perdas]
  (busca de risco) e #strong[mais íngreme nas perdas] (aversão à perda). Uma forma
  funcional usual é

  $ v(x) = cases(x^alpha "se" x >= 0, -lambda (-x)^alpha "se" x < 0) $

  com $alpha approx "0,88"$ e $lambda approx "2,25"$ (estimativas de Tversky e
  Kahneman, 1992): uma perda "dói" cerca de 2,25 vezes mais que um ganho
  equivalente "alegra".
]

#exemplo("rejeitar um jogo vantajoso")[
  Um jogo paga +R\$ 150 com 50% de chance e −R\$ 100 com 50%. O #strong[valor
  esperado] é $"0,5" times 150 - "0,5" times 100 = +25$: um investidor neutro ao
  risco aceita. Pela função valor, porém, $v(150) = 150^("0,88") = "82,2"$ e
  $v(-100) = -"2,25" times 100^("0,88") = -"129,5"$, de modo que o valor
  subjetivo é $"0,5" times "82,2" + "0,5" times (-"129,5") = -"23,6"$ --- #strong[negativo]. A
  maioria das pessoas rejeita o jogo, o que a teoria da utilidade esperada
  (com riqueza total) mal explica. É a #strong[aversão à perda] em ação, e
  é o motor do #emph[disposition effect]: vender vencedoras cedo (para
  "realizar o ganho", côncavo) e segurar perdedoras (para não
  "realizar a perda", convexo).
]

```python
def valor_prospecto(x, alpha=0.88, lam=2.25):
    return x ** alpha if x >= 0 else -lam * (-x) ** alpha

print(f"v(+100) = {valor_prospecto(100):.1f} | v(-100) = {valor_prospecto(-100):.1f} -> a perda pesa {-valor_prospecto(-100) / valor_prospecto(100):.2f}x o ganho")
ev_jogo = 0.5 * 150 + 0.5 * (-100)
vp_jogo = 0.5 * valor_prospecto(150) + 0.5 * valor_prospecto(-100)
print(f"Jogo +150/-100: valor esperado R${ev_jogo:+.1f} | valor pela teoria da perspectiva {vp_jogo:+.1f} -> {'aceita' if vp_jogo > 0 else 'rejeita'}")
```

```
v(+100) = 57.5 | v(-100) = -129.5 -> a perda pesa 2.25x o ganho
Jogo +150/-100: valor esperado R$+25.0 | valor pela teoria da perspectiva -23.6 -> rejeita
```

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

```
=== Anomalias de Mercado ===
Efeito Janeiro       -> Retornos anormais em janeiro, especialmente small caps
Efeito Segunda-feira -> Retornos negativos nas segundas-feiras
Momentum             -> Ações que subiram nos últimos 6-12 meses continuam subindo
Reversão             -> Ações que perderam muito nos últimos 3-5 anos se recuperam
Valor                -> Baixo P/L e P/VP geram retornos superiores (Fama-French)
Tamanho              -> Small caps têm retorno superior ajustado ao risco
Baixo Risco          -> Ações de baixa volatilidade têm retornos superiores (paradoxalmente)
IPO                  -> IPOs têm performance inferior no longo prazo
```

#atencao[
  #strong[Cuidado com as "anomalias".] Muitos padrões documentados
  desaparecem depois de publicados ou não sobrevivem a custos de transação,
  e muitos resultam de #strong[mineração de dados] (testar centenas de
  estratégias e relatar a que "funcionou"). Antes de aceitar uma anomalia,
  pergunte: ela tem uma explicação econômica plausível? Resiste fora da
  amostra e em outros países? Sobrevive a custos e a impostos?
]

#mercado[
  #strong[Como reduzir os vieses na prática.] (1) Regras de decisão escritas
  antes (política de investimento, critérios de compra e venda). (2)
  #strong[Automatizar] aportes e rebalanceamentos (reduz o impulso de seguir a manada).
  (3) Diário de decisões, para combater o viés retrospectivo. (4) Buscar
  ativamente #emph[evidência contrária] à tese (combate o viés de confirmação).
  (5) Separar a decisão do #emph[processo] do resultado de curto prazo.
]

#resumo[
  - A EMH diz que desvios de preços não são previsíveis; os limites da arbitragem explicam por que erros de preço persistem.
  - Teoria da perspectiva: ganhos e perdas relativos a uma referência; perdas pesam ~2,25 vezes mais.
  - Vieses (excesso de confiança, aversão à perda, ancoragem, manada) geram negociação excessiva e bolhas.
  - Anomalias exigem ceticismo estatístico e econômico.
]

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

#exemplo("quem faz o quê no Sistema Financeiro Nacional")[
  #figure(
    align(center)[#table(
      columns: (18%, 82%),
      align: (left, left),
      table.header([Órgão], [Papel],),
      [#strong[CMN]], [Conselho Monetário Nacional: define as normas e as metas (inclusive a meta de inflação)],
      [#strong[BCB]], [Banco Central: executa a política monetária, supervisiona bancos e opera o câmbio],
      [#strong[CVM]], [Comissão de Valores Mobiliários: regula o mercado de capitais (ações, debêntures, fundos)],
      [#strong[SUSEP]], [Supervisiona seguros e previdência aberta],
      [#strong[PREVIC]], [Supervisiona fundos de pensão (previdência fechada)],
      [#strong[B3]], [Bolsa e infraestrutura: negociação, compensação e liquidação],
    )]
    , kind: table
    )

  No #strong[mercado primário] a empresa ou o governo emite títulos e recebe o
  dinheiro (IPO, emissão de debêntures, leilão do Tesouro); no
  #strong[mercado secundário] os investidores negociam entre si, o que dá
  #strong[liquidez] e forma o preço de referência.
]

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
        print(f"{k}: R${v:.2f}")
```

```
Valor Nominal: R$1590.12
Valor Real: R$1306.96
Taxa Total: 9.72%
```

#teoria("preço, rendimento (YTM), duration e convexidade de um título")[
  O preço de um título é o valor presente de seus fluxos (cupons $C$ e principal
  $F$) à taxa de mercado $y$ --- o #strong[rendimento até o vencimento]
  (YTM):

  $ P = sum_(t=1)^n C/(1 + y)^t + F/(1 + y)^n $

  Preço e rendimento se movem em #strong[sentidos opostos]. A sensibilidade é
  medida pela #strong[duration de Macaulay], a média ponderada dos prazos dos fluxos
  (cada prazo pesado pela fração do preço que o fluxo representa):

  $ D_("Mac") = (sum_(t=1)^n t dot "VP"("FC"_t))/P quad "e" quad D_("mod") = D_("Mac")/(1 + y) $

  Para pequenas variações, $Delta P/P approx -D_("mod") dot Delta y$. A
  aproximação de primeira ordem subestima o preço quando os juros caem e
  superestima a queda quando sobem, porque a relação preço × taxa é #strong[convexa];
  o termo de #strong[convexidade] corrige: $Delta P/P approx -D_("mod") Delta y + 1/2
  "Conv" (Delta y)^2$. A duration é, em essência, o "prazo médio efetivo" do título:
  títulos de cupom zero têm duration igual ao prazo; cupons altos a reduzem.
]

#exemplo("duration na prática")[
  Título com valor de face R\$ 1.000, cupom de 10% a.a. e 5 anos, a um
  rendimento de 12% a.a.: o preço é #strong[R\$ 927,90] (abaixo do valor de face, porque
  o cupom é menor que o rendimento exigido). A duration de Macaulay é 4,14 anos e a
  modificada, 3,69. Se o rendimento sobe 1 ponto (12% → 13%), o preço cai
  3,60%; a duration prevê −3,69% e, com a convexidade, −3,60%.
  Regra de bolso: #strong[cada ano de duration modificada equivale a cerca de 1%
  de variação de preço por 1 ponto de variação na taxa].
]

```python
def preco_duration(face, cupom, y, n):
    fluxos_b = [face * cupom] * n
    fluxos_b[-1] += face
    vps = [f / (1 + y) ** (t + 1) for t, f in enumerate(fluxos_b)]
    preco_b = sum(vps)
    mac = sum((t + 1) * vp for t, vp in enumerate(vps)) / preco_b
    conv = sum((t + 1) * (t + 2) * vp / (1 + y) ** 2 for t, vp in enumerate(vps)) / preco_b
    return preco_b, mac, mac / (1 + y), conv

p0_b, mac_b, mod_b, conv_b = preco_duration(1000, 0.10, 0.12, 5)
p1_b = preco_duration(1000, 0.10, 0.13, 5)[0]
print(f"Preço R${p0_b:.2f} | duration Macaulay {mac_b:.3f} | modificada {mod_b:.3f} | convexidade {conv_b:.2f}")
print(f"Alta de 1 p.p. nos juros: variação real {p1_b / p0_b - 1:+.3%} | pela duration {-mod_b * 0.01:+.3%} | com convexidade {-mod_b * 0.01 + 0.5 * conv_b * 0.01 ** 2:+.3%}")
```

```
Preço R$927.90 | duration Macaulay 4.135 | modificada 3.692 | convexidade 18.48
Alta de 1 p.p. nos juros: variação real -3.602% | pela duration -3.692% | com convexidade -3.600%
```

#mercado[
  No Tesouro Direto, o #strong[Tesouro Selic] (LFT) tem duration próxima de zero:
  como paga a taxa de juros do momento, seu preço oscila pouco; é a
  referência de #emph[baixo risco de mercado]. O #strong[Tesouro Prefixado] e o
  #strong[Tesouro IPCA+] têm duration longa e, por isso, preços muito sensíveis às
  variações da taxa (marcação a mercado), como mostramos no capítulo 6 da apostila
  de Matemática Financeira. Um investidor com horizonte longo, que mantém o
  título até o vencimento, não sofre a oscilação --- mas quem precisa vender antes sim.
]

=== 11.3. Renda Variável
<renda-variável>
#strong[Ações:] - #strong[ON (Ordinária):] com direito a voto -
#strong[PN (Preferencial):] preferência no recebimento de dividendos,
sem voto - #strong[Units:] conjunto de ON + PN negociado como um ativo

#strong[Derivativos:] - #strong[Opções:] direito de comprar (call) ou
vender (put) a um preço fixo - #strong[Futuros:] obrigação de
comprar/vender no futuro - #strong[Swaps:] troca de fluxos financeiros
(ex: CDI x IPCA)

#teoria("opções: payoffs, paridade put-call e Black-Scholes")[
  Uma #strong[opção de compra] (call) dá o direito de comprar o ativo a um preço de
  exercício $K$; seu valor no vencimento é $max(S_T - K, 0)$. Uma #strong[opção de venda]
  (put) dá o direito de vender: $max(K - S_T, 0)$. A opção tem um custo (prêmio),
  mas #strong[perda máxima limitada] ao prêmio para o comprador.

  #strong[Paridade put-call:] comprar uma call e vender uma put de mesmo $K$ e
  vencimento replica comprar o ativo a prazo: $C - P = S - K e^(-r T)$. Se a
  relação não vale, há arbitragem.

  #strong[Black-Scholes (call europeia, sem dividendos):]

  $ C = S N(d_1) - K e^(-r T) N(d_2), quad d_1 = (ln(S\/K) + (r + sigma^2\/2) T)/(sigma sqrt(T)), quad d_2 = d_1 - sigma sqrt(T) $

  onde $N(dot)$ é a distribuição normal acumulada. O valor da opção cresce com
  a #strong[volatilidade] (mais incerteza, mais chance de ganho grande, e a
  perda é limitada), com o prazo e com a taxa de juros. O $N(d_1)$ é o #strong[delta]:
  quanto o preço da opção varia por R\$ 1 de variação do ativo.
]

#exemplo("precificando uma call")[
  Ação a R\$ 30, preço de exercício R\$ 32, vencimento em 6 meses ($T = "0,5"$),
  taxa livre de risco de 10,5% a.a. (contínua, simplificação) e volatilidade de 35%
  a.a. O modelo dá call de #strong[R\$ 2,79], put de #strong[R\$ 3,16] e #strong[delta de
  0,53]: se a ação subir R\$ 1, a call tende a subir R\$ 0,53. Compre a call: o
  risco é perder no máximo R\$ 2,79 por opção; a alta, ilimitada.
]

```python
def black_scholes(s, k, r, sigma, t):
    d1 = (np.log(s / k) + (r + sigma ** 2 / 2) * t) / (sigma * np.sqrt(t))
    d2 = d1 - sigma * np.sqrt(t)
    call = s * stats.norm.cdf(d1) - k * np.exp(-r * t) * stats.norm.cdf(d2)
    put = k * np.exp(-r * t) * stats.norm.cdf(-d2) - s * stats.norm.cdf(-d1)
    return call, put, stats.norm.cdf(d1)

call_bs, put_bs, delta_bs = black_scholes(30, 32, 0.105, 0.35, 0.5)
print(f"Call R${call_bs:.2f} | put R${put_bs:.2f} | delta {delta_bs:.3f}")
print(f"Paridade put-call: C - P = {call_bs - put_bs:.4f} | S - K·e^(-rT) = {30 - 32 * np.exp(-0.105 * 0.5):.4f}")
for vol_ex in (0.20, 0.35, 0.50):
    print(f"Volatilidade {vol_ex:.0%}: call = R${black_scholes(30, 32, 0.105, vol_ex, 0.5)[0]:.2f}")
```

```
Call R$2.79 | put R$3.16 | delta 0.530
Paridade put-call: C - P = -0.3633 | S - K·e^(-rT) = -0.3633
Volatilidade 20%: call = R$1.53
Volatilidade 35%: call = R$2.79
Volatilidade 50%: call = R$4.06
```

#teoria("futuros e custo de carregamento")[
  Um contrato futuro obriga a comprar/vender no futuro por um preço fixado hoje. O
  preço justo decorre de uma arbitragem: comprar o ativo hoje (financiado a
  taxa $r$) e vendê-lo a termo. Sem rendimentos no ativo, $F = S (1 + r)^T$; é o
  #strong[custo de carregamento]. Para a moeda, o carregamento é o diferencial de juros:
  $F = S (1 + i_("BR"))/(1 + i_("EUA"))$ --- a paridade coberta de juros, vista no
  capítulo 12. Um #strong[swap] troca fluxos de dois indexadores (por exemplo, pré × CDI),
  e é, na prática, uma carteira de contratos a termo.
]

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
    print(f"Preço atual: R${preco_atual:.2f}")
    print(f"Mínimo do período: R${preco_min:.2f}")
    print(f"Máximo do período: R${preco_max:.2f}")
    print(f"Retorno anualizado: {retorno_anual*100:.2f}%")
    print(f"Volatilidade anual: {volatilidade*100:.2f}%")
    print(f"Drawdown máximo: {max_drawdown*100:.2f}%")
    print(f"Retorno/Vol (Sharpe): {retorno_anual/volatilidade:.2f}")

# analisar_acao("PETR4.SA", "3y")
```

#exemplo("análise de risco de uma série de preços (dados simulados)")[
  A função `analisar_acao` baixa dados da internet. Para estudar as mesmas
  métricas sem depender da conexão, o código a seguir as calcula sobre uma
  trajetória #strong[simulada] (movimento browniano geométrico, semente fixa):
  retorno anualizado, volatilidade, Sharpe e #strong[drawdown máximo] (maior queda
  do pico ao vale --- o pior momento para quem investiu no pico).
]

```python
def metricas_serie(precos_s, rf=0.10):
    ret_s = precos_s[1:] / precos_s[:-1] - 1
    anos_s = len(ret_s) / 252
    cagr_s = (precos_s[-1] / precos_s[0]) ** (1 / anos_s) - 1
    vol_s = ret_s.std(ddof=1) * np.sqrt(252)
    pico_s = np.maximum.accumulate(precos_s)
    dd_s = (precos_s - pico_s) / pico_s
    return cagr_s, vol_s, (cagr_s - rf) / vol_s, dd_s.min()

rng_p = np.random.default_rng(11)
mu_d, sig_d = 0.13 / 252, 0.30 / np.sqrt(252)
precos_sim = 20 * np.exp(np.cumsum(rng_p.normal(mu_d - sig_d ** 2 / 2, sig_d, 756)))
precos_sim = np.concatenate(([20.0], precos_sim))
cagr_s, vol_s, sharpe_s, dd_s = metricas_serie(precos_sim)
print(f"Retorno anualizado: {cagr_s:.2%} | volatilidade: {vol_s:.2%} | Sharpe (Rf 10%): {sharpe_s:.2f} | drawdown máximo: {dd_s:.2%}")
```

```
Retorno anualizado: 22.43% | volatilidade: 29.51% | Sharpe (Rf 10%): 0.42 | drawdown máximo: -20.31%
```

#resumo[
  - O SFN tem reguladores distintos (CMN, BCB, CVM, SUSEP, PREVIC); o mercado primário capta, o secundário dá liquidez.
  - $P = sum "FC"_t/(1 + y)^t$; $D_("mod")$ mede a sensibilidade do preço a $y$; a convexidade refina.
  - Opções: payoffs assimétricos; Black-Scholes; paridade put-call; futuros pelo custo de carregamento.
  - Retorno, volatilidade, Sharpe e #strong[drawdown] são o painel mínimo de risco de um ativo.
]

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
j_usa = 0.05  # Fed Funds
futuro = paridade_descoberta_juros(j_br, j_usa, spot, 1)
print(f"Câmbio spot: R${spot:.2f}")
print(f"Juros Brasil: {j_br*100:.1f}%")
print(f"Juros EUA: {j_usa*100:.1f}%")
print(f"Câmbio futuro esperado (1 ano): R${futuro:.2f}")
print(f"Desvalorização esperada: {(futuro/spot - 1)*100:.2f}%")
```

```
Câmbio spot: R$5.20
Juros Brasil: 13.2%
Juros EUA: 5.0%
Câmbio futuro esperado (1 ano): R$5.61
Desvalorização esperada: 7.86%
```

#teoria("paridade coberta de juros: a dedução")[
  Um investidor com R\$ 1 pode (a) aplicar no Brasil a $i_("BR")$, obtendo $(1 + i_("BR"))$; ou
  (b) converter em dólares ao câmbio spot $S$, aplicar nos EUA a $i_("EUA")$ e
  #strong[travar] a reconversão a um câmbio a termo $F$: obtém $(1/S)(1 + i_("EUA")) F$. Sem
  arbitragem, os dois retornos são iguais:

  $ (1 + i_("BR")) = (1 + i_("EUA")) F/S quad arrow.r.double quad F = S (1 + i_("BR"))/(1 + i_("EUA")) $

  É a #strong[paridade coberta de juros] (CIP), uma relação de #emph[arbitragem]
  (vale exatamente, a menos de custos). Já a #strong[paridade
  #emph[descoberta]] (UIP) afirma que o câmbio #emph[esperado] no futuro é
  $F$: ela é uma hipótese de #emph[comportamento], que a evidência empírica
  rejeita --- moedas de juros altos tendem a #emph[não] se depreciar tanto quanto o
  diferencial prevê. Essa falha (o "enigma do prêmio a termo") é a base da
  operação de #strong[carry trade]. A função do código acima, apesar de
  chamada "paridade descoberta", calcula a fórmula do #emph[câmbio a termo]
  (CIP).
]

#exemplo("câmbio a termo e o ponto de equilíbrio do carry trade")[
  Com câmbio spot R\$ 5,20/US\$, juros de 13,25% no Brasil e 5% nos EUA, o câmbio a
  termo de 1 ano é $"5,20" times "1,1325"/"1,05" = $ R\$ 5,61, uma "desvalorização" implícita
  de 7,86%. Um investidor que toma dólares a 5% e aplica em reais a 13,25%
  (#strong[carry trade]) lucra se o real se desvalorizar #emph[menos] que 7,86% no ano;
  perde se desvalorizar mais. O ganho de "carregar" juros altos é compensação
  pelo #strong[risco cambial] --- que pode se materializar de uma vez.
]

=== 12.2. Risco-País (EMBI+)
<risco-país-embi>
Prêmio de risco que o mercado exige para investir em títulos de um país.
Medido pelo spread dos títulos soberanos sobre os Treasuries americanos.

#exemplo("do Ke em dólares ao Ke em reais, com risco-país")[
  O #strong[risco-país] (spread do EMBI sobre os Treasuries, ou o CDS soberano)
  mede o prêmio pelo risco de investir em um país emergente. Em avaliações em
  moeda forte, soma-se um prêmio de risco-país ao custo do capital. Exemplo
  (números #emph[ilustrativos]): taxa livre de risco americana de 4,5%, beta de 1,1,
  prêmio de mercado de 5% e prêmio de risco-país de 3%:

  $ K_(e,"USD") = "4,5"% + "1,1" times 5% + 3% = "13,0"% $

  Para descontar fluxos em #strong[reais], converte-se pela diferença de inflações
  (como na seção 2.4): com inflação de 4,5% no Brasil e 3% nos EUA,
  $K_(e,"BRL") = "1,13" times "1,045"/"1,03" - 1 = "14,65"%$.
]

=== 12.3. Teoria da Paridade do Poder de Compra (PPP)
<teoria-da-paridade-do-poder-de-compra-ppp>
$ upright("Taxa") med upright("de") med upright("Câmbio") = frac(upright("Nível") med upright("de") med upright("Preços") med\(upright("País") med A\), upright("Nível") med upright("de") med upright("Preços") med\(upright("País") med B\)) $

#strong[PPP Relativa:] a variação cambial reflete o diferencial de
inflação:

$ E_t / E_(t - 1) = frac(1 + pi_(upright("doméstica")), 1 + pi_(upright("estrangeira"))) $

#exemplo("as cinco condições de paridade, juntas")[
  Brasil com inflação de 4,5% e EUA com 3,0%; juros de 13,25% (BR) e 5,0% (EUA);
  câmbio spot R\$ 5,20.

  - #strong[PPP relativa:] o real deve se desvalorizar pelo diferencial de
    inflação: $"1,045"/"1,03" - 1 = "1,46"%$ no ano.
  - #strong[Efeito Fisher internacional:] as taxas nominais refletem as inflações
    esperadas mais uma taxa real; diferenças de juros nominais $approx$ diferenças
    de inflação esperada (mais prêmio de risco). Aqui, o diferencial de juros (7,86%)
    é muito maior que o de inflação (1,46%): o juro real brasileiro é bem mais alto.
  - #strong[Paridade descoberta (UIP):] o câmbio esperado deveria se depreciar 7,86%.
  - #strong[Paridade coberta (CIP):] o câmbio a termo é R\$ 5,61 (+7,86%).

  O resultado revela que as condições #strong[não se verificam todas] ao
  mesmo tempo: se valesse a PPP (1,46% de desvalorização), o carry trade
  daria um ganho de 6,4 pontos --- é essa distância entre o que a PPP prevê e
  o que o juro cobra que alimenta o carry trade. A PPP vale melhor no #strong[longo prazo]
  (muitos anos), e é um bom guia para o câmbio #emph[real]:
  $q = S P^* / P$ (preço relativo da cesta entre os países).
]

#resumo[
  - CIP: $F = S (1 + i_("BR"))/(1 + i_("EUA"))$ (arbitragem). UIP: o câmbio esperado é $F$ (hipótese empírica fraca).
  - Carry trade: lucra se a moeda de juro alto se depreciar menos que o diferencial; carrega risco cambial.
  - Custo de capital em moeda forte: inclui risco-país; convertido para reais pelo diferencial de inflação.
  - PPP relativa: $Delta S approx (1 + pi)/(1 + pi^*) - 1$; vale melhor no longo prazo.
]

#line()

== Capítulo 13 --- Exercícios Resolvidos
<capítulo-13-exercícios-resolvidos>
#strong[E1.] Uma ação tem beta de 1,3. A taxa livre de risco (Selic)
está em 10,5% a.a. e o retorno esperado da carteira de mercado
(Ibovespa) é de 16% a.a. Calcule o custo de capital próprio (Ke) pelo
CAPM.

$ upright("Ke") = R_f + beta times\(R_m - R_f\)= "0,105" + "1,3" times\("0,16" - "0,105"\) $

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
    print(f"{k:12s}: R${v:,.2f} milhões")
```

```
VP_FCFs     : R$352.63 milhões
VP_VT       : R$664.94 milhões
EV          : R$1,017.57 milhões
Equity_Value: R$827.57 milhões
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
print(f"(a) Benefício fiscal: R${beneficio_fiscal:.2f} milhões")
print(f"(a) Valor da empresa alavancada (VL): R${vl:.2f} milhões")

e = vl - d  # capital próprio remanescente após alavancagem
ke = ke_u + (ke_u - kd) * (d / e)
print(f"(b) Ke após alavancagem: {ke*100:.2f}%")
```

```
(a) Benefício fiscal: R$136.00 milhões
(a) Valor da empresa alavancada (VL): R$1136.00 milhões
(b) Ke após alavancagem: 17.72%
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

print(f"LPA:            R${lpa:.2f}")
print(f"DPA:            R${dpa:.2f}")
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

print(f"Sinergia total: R${sinergia:.2f} milhões")
print(f"Prêmio pago aos acionistas de B: R${premio:.2f} milhões")
print(f"Valor líquido para acionistas de A: R${valor_liquido_a:.2f} milhões")
print("Decisão:", "fusão CRIA valor para A" if valor_liquido_a > 0 else "fusão DESTRÓI valor para A")
```

```
Sinergia total: R$100.00 milhões
Prêmio pago aos acionistas de B: R$40.00 milhões
Valor líquido para acionistas de A: R$60.00 milhões
Decisão: fusão CRIA valor para A
```

#line()

#strong[E9.] O ativo A tem retorno esperado de 14% e desvio de 25%; o ativo B, 9% e
12%; a correlação é 0,30. (a) Qual o retorno e o risco de uma carteira 60% A / 40% B?
(b) Qual a carteira de mínima variância?

#strong[Solução.] (a) $E(R_p) = "0,6" times 14% + "0,4" times 9% = "12,0"%$. A variância é
$"0,6"^2 times "0,25"^2 + "0,4"^2 times "0,12"^2 + 2 times "0,6" times "0,4" times "0,30" times "0,25" times "0,12" = "0,02912"$,
portanto $sigma_p = "17,07"%$ --- menor que a média ponderada dos desvios
($"0,6" times 25% + "0,4" times 12% = "19,8"%$), efeito da correlação menor que 1.
(b) Pesos de mínima variância: $w_A^* = (sigma_B^2 - rho sigma_A sigma_B)/(sigma_A^2 + sigma_B^2 - 2 rho sigma_A sigma_B) = "9,17"%$ em A e 90,83% em B,
com risco de 11,79% e retorno de 9,46%: menos risco que o do próprio ativo B.

```python
e_a, s_a, e_b, s_b, corr_ab, peso_a = 0.14, 0.25, 0.09, 0.12, 0.30, 0.60
ret_p = peso_a * e_a + (1 - peso_a) * e_b
var_p = (peso_a * s_a) ** 2 + ((1 - peso_a) * s_b) ** 2 + 2 * peso_a * (1 - peso_a) * corr_ab * s_a * s_b
w_min = (s_b ** 2 - corr_ab * s_a * s_b) / (s_a ** 2 + s_b ** 2 - 2 * corr_ab * s_a * s_b)
risco_min = np.sqrt((w_min * s_a) ** 2 + ((1 - w_min) * s_b) ** 2 + 2 * w_min * (1 - w_min) * corr_ab * s_a * s_b)
print(f"(a) Retorno {ret_p:.2%} | risco {np.sqrt(var_p):.2%} (média ponderada dos riscos: {peso_a * s_a + (1 - peso_a) * s_b:.2%})")
print(f"(b) Mínima variância: {w_min:.2%} em A e {1 - w_min:.2%} em B | retorno {w_min * e_a + (1 - w_min) * e_b:.2%} | risco {risco_min:.2%}")
```

```
(a) Retorno 12.00% | risco 17.07% (média ponderada dos riscos: 19.80%)
(b) Mínima variância: 9.17% em A e 90.83% em B | retorno 9.46% | risco 11.79%
```

#line()

#strong[E10.] Uma empresa comparável tem beta de 1,25, com D/E de 0,9 e IR de 34%.
Estime o beta desalavancado e o beta de uma empresa do mesmo setor que pretende operar
com D/E de 0,4. Calcule o Ke com Selic de 10,5% e prêmio de mercado de 5,5%.

#strong[Solução.] Desalavancar (Hamada): $beta_U = "1,25"/(1 + "0,66" times "0,9") = "0,784"$.
Realavancar: $beta_L = "0,784" times (1 + "0,66" times "0,4") = "0,991"$. O Ke é
$"10,5"% + "0,991" times "5,5"% = "15,95"%$. Menos dívida, menos risco do acionista:
o beta cai de 1,25 para 0,99.

```python
beta_comp, de_comp, ir_h, de_alvo = 1.25, 0.9, 0.34, 0.4
beta_u_h = beta_comp / (1 + (1 - ir_h) * de_comp)
beta_alvo = beta_u_h * (1 + (1 - ir_h) * de_alvo)
print(f"Beta desalavancado: {beta_u_h:.3f} | beta realavancado (D/E {de_alvo}): {beta_alvo:.3f} | Ke: {0.105 + beta_alvo * 0.055:.2%}")
```

```
Beta desalavancado: 0.784 | beta realavancado (D/E 0.4): 0.991 | Ke: 15.95%
```

#line()

#strong[E11.] Uma empresa tem NOPAT de R\$ 340 milhões e capital investido de R\$ 2.500
milhões; o WACC é 11,5%. Calcule ROIC, spread e EVA, e diga quanto o NOPAT
precisaria ser para o EVA ser zero.

#strong[Solução.] ROIC $= 340/2.500 = "13,6"%$; spread $= "13,6"% - "11,5"% = "2,1"$ p.p.;
EVA $= 2.500 times "2,1"% = $ R\$ 52,5 milhões. O EVA zera quando o NOPAT iguala o
custo do capital: $2.500 times "11,5"% = $ R\$ 287,5 milhões --- uma margem de
segurança de $(340 - "287,5")/340 = "15,4"%$.

```python
nopat_e, capital_e, wacc_e = 340, 2500, 0.115
roic_e = nopat_e / capital_e
print(f"ROIC {roic_e:.2%} | spread {(roic_e - wacc_e)*100:.2f} p.p. | EVA R${nopat_e - capital_e * wacc_e:.1f} milhões")
print(f"NOPAT de equilíbrio (EVA = 0): R${capital_e * wacc_e:.1f} milhões (folga de {1 - capital_e * wacc_e / nopat_e:.1%})")
```

```
ROIC 13.60% | spread 2.10 p.p. | EVA R$52.5 milhões
NOPAT de equilíbrio (EVA = 0): R$287.5 milhões (folga de 15.4%)
```

#line()

#strong[E12.] Uma empresa tem EBIT de R\$ 300 milhões, IR de 34%, depreciação de R\$ 100
milhões, CapEx de R\$ 140 milhões e aumento de capital de giro de R\$ 30 milhões, todos
no ano 0. Esses valores crescem 5% ao ano nos próximos 4 anos; depois, o FCFF
cresce 3% para sempre. WACC de 11%; dívida líquida de R\$ 400 milhões. Calcule o EV e o
equity value.

#strong[Solução.] Para cada ano $t$, o FCFF é $(300 times "0,66" + 100 - 140 - 30) times "1,05"^t$
$= 128 times "1,05"^t$: de R\$ 134,4 milhões (ano 1) a R\$ 155,6 milhões (ano 4). O valor terminal
no ano 4 é $"155,6" times "1,03"/("0,11" - "0,03") = "2.003,2"$; descontado, vale 1.319,5. A soma
dos FCFF descontados é R\$ 446,5. #strong[EV $=$ R\$ 1.766,0 milhões]; equity $= "1.766,0" - 400 = $
R\$ 1.366,0 milhões. O valor terminal responde por 75% do EV.

```python
fcff_0 = 300 * (1 - 0.34) + 100 - 140 - 30
fcffs_e12 = [fcff_0 * 1.05 ** t for t in range(1, 5)]
ev_e12, eq_e12, share_e12, _ = fcd_simples(fcffs_e12, 0.11, 0.03, 400, 0)
print("FCFF projetados:", [f"{f:.1f}" for f in fcffs_e12])
print(f"EV = R${ev_e12:,.1f} | equity = R${eq_e12:,.1f} | valor terminal = {share_e12:.1%} do EV")
```

```
FCFF projetados: ['134.4', '141.1', '148.2', '155.6']
EV = R$1,766.0 | equity = R$1,366.0 | valor terminal = 74.7% do EV
```

#line()

#strong[E13.] Uma empresa tem ROIC de 14%, custo da dívida de 11% (IR de 34%) e D/E de 1,2.
Qual o ROE? E se o ROIC cair para 6%?

#strong[Solução.] $"ROE" = "ROIC" + ("ROIC" - K_d(1 - "IR")) D/E$. Com $K_d$ líquido
$= 11% times "0,66" = "7,26"%$: ROE $= 14% + (14% - "7,26"%) times "1,2" = "22,09"%$. Com ROIC de 6%:
$6% + (6% - "7,26"%) times "1,2" = "4,49"%$ --- #strong[abaixo do próprio ROIC]. A alavancagem amplifica
nos dois sentidos: acima do custo líquido da dívida, ajuda; abaixo, machuca.

```python
def roe_alavancado(roic_a, kd_a, ir_a, de_a):
    return roic_a + (roic_a - kd_a * (1 - ir_a)) * de_a

for roic_v in (0.14, 0.06):
    print(f"ROIC {roic_v:.0%} -> ROE {roe_alavancado(roic_v, 0.11, 0.34, 1.2):.2%}")
```

```
ROIC 14% -> ROE 22.09%
ROIC 6% -> ROE 4.49%
```

#line()

#strong[E14.] Uma empresa vende R\$ 3.600 por ano e tem PME de 45 dias, PMR de 38 e PMP de
30. Qual o ciclo financeiro, a NCG aproximada e o custo anual do financiamento a 14% a.a.?

#strong[Solução.] Ciclo financeiro $= 45 + 38 - 30 = 53$ dias. NCG $approx 3.600/360 times 53 = $ R\$ 530.
Custo de financiá-la: $530 times 14% = $ R\$ 74,2 por ano. Cada dia de ciclo reduzido
libera $3.600/360 = 10$ de caixa e economiza R\$ 1,4 por ano.

```python
vendas_e14, pme_e, pmr_e, pmp_e = 3600, 45, 38, 30
cf_e14 = pme_e + pmr_e - pmp_e
ncg_e14 = vendas_e14 / 360 * cf_e14
print(f"Ciclo financeiro {cf_e14} dias | NCG ≈ R${ncg_e14:,.0f} | custo anual a 14%: R${ncg_e14 * 0.14:,.1f}")
print(f"Cada dia de ciclo = R${vendas_e14 / 360:.0f} de caixa e R${vendas_e14 / 360 * 0.14:.2f}/ano")
```

```
Ciclo financeiro 53 dias | NCG ≈ R$530 | custo anual a 14%: R$74.2
Cada dia de ciclo = R$10 de caixa e R$1.40/ano
```

#line()

#strong[E15.] Um título de R\$ 1.000, cupom de 8% a.a., 4 anos, é negociado a um rendimento de 10%.
Calcule o preço, a duration modificada e a variação de preço se o rendimento subir para 10,5%.

#strong[Solução.] O preço é R\$ 936,60 (desconto, pois o cupom é menor que o rendimento). A duration
de Macaulay é 3,56 anos e a modificada 3,24. Para $Delta y = +"0,5"%$, a variação aproximada
é $-"3,24" times "0,5"% = -"1,62"%$; a variação exata é $-"1,60"%$.

```python
p_e15, mac_e15, mod_e15, _ = preco_duration(1000, 0.08, 0.10, 4)
p_novo = preco_duration(1000, 0.08, 0.105, 4)[0]
print(f"Preço R${p_e15:.2f} | duration {mac_e15:.2f} (modificada {mod_e15:.2f})")
print(f"Rendimento 10,5%: preço R${p_novo:.2f} ({p_novo / p_e15 - 1:+.2%}) | previsto pela duration {-mod_e15 * 0.005:+.2%}")
```

```
Preço R$936.60 | duration 3.56 (modificada 3.24)
Rendimento 10,5%: preço R$921.60 (-1.60%) | previsto pela duration -1.62%
```

#line()

#strong[E16.] Câmbio spot de R\$ 5,00/US\$; juros de 12% a.a. no Brasil e 4% a.a. nos EUA; prazo de 6
meses. O mercado cota o câmbio a termo em R\$ 5,30. Há arbitragem?

#strong[Solução.] Pela paridade coberta, o termo justo é $"5,00" times ("1,12"/"1,04")^("0,5") = "5,19"$.
Como o mercado cota 5,30 (acima), vale a pena #strong[vender dólares a termo]:
toma-se R\$ 1.000.000 emprestados a 12%; converte-se a 5,00 (US\$ 200.000); aplica-se a 4% (US\$
203.961 em 6 meses); vende-se a termo a 5,30 (R\$ 1.080.992); paga-se a dívida
(R\$ 1.058.301). #strong[Lucro sem risco: R\$ 22.692.] Operações assim empurram o termo
de volta ao valor de paridade.

```python
spot_e, i_br_e, i_us_e, t_e, termo_mercado = 5.00, 0.12, 0.04, 0.5, 5.30
termo_justo = spot_e * ((1 + i_br_e) / (1 + i_us_e)) ** t_e
brl_ini = 1_000_000
usd_fim = brl_ini / spot_e * (1 + i_us_e) ** t_e
lucro_arb = usd_fim * termo_mercado - brl_ini * (1 + i_br_e) ** t_e
print(f"Termo justo (CIP): R${termo_justo:.4f} | mercado: R${termo_mercado:.2f}")
print(f"Arbitragem: recebe US${usd_fim:,.0f} -> vende a termo por R${usd_fim * termo_mercado:,.0f}; dívida R${brl_ini * (1 + i_br_e) ** t_e:,.0f}; lucro R${lucro_arb:,.0f}")
```

```
Termo justo (CIP): R$5.1887 | mercado: R$5.30
Arbitragem: recebe US$203,961 -> vende a termo por R$1,080,992; dívida R$1,058,301; lucro R$22,692
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

#strong[Tabela 14.2 --- Fórmulas adicionais.]

#figure(
  align(center)[#table(
    columns: (32%, 44%, 24%),
    align: (left, left, left),
    table.header([Conceito], [Fórmula], [Uso],),
    [EVA como spread], [$"EVA" = K ("ROIC" - "WACC")$], [Criação de valor],
    [Retorno logarítmico], [$ln(P_t/P_(t-1))$], [Aditivo no tempo],
    [Volatilidade anual], [$sigma_d sqrt(252)$], [Escala de risco],
    [Índice de Sharpe], [$(R_p - R_f)/sigma_p$], [Retorno por risco total],
    [Índice de Treynor], [$(R_p - R_f)/beta_p$], [Retorno por risco sistemático],
    [Alfa de Jensen], [$R_p - [R_f + beta_p (R_m - R_f)]$], [Retorno anormal],
    [Risco de $N$ ativos], [$sqrt(sigma^2/N + (1 - 1/N) rho sigma^2)$], [Limite da diversificação],
    [Hamada], [$beta_L = beta_U [1 + (1 - "IR") D/E]$], [Realavancar beta],
    [Fluxo de caixa livre], [$"EBIT"(1 - "IR") + "Dep" - "CapEx" - Delta "NCG"$], [FCFF],
    [P/L implícito], [$"payout"/(K_e - g)$], [Múltiplos],
    [M&M com impostos (WACC)], [$K_u (1 - "IR" dot D/V)$], [Estrutura de capital],
    [Dívida ótima (trade-off)], [$D^* = "IR"/(2k)$], [Modelo quadrático],
    [ROE com alavancagem], [$"ROIC" + ("ROIC" - K_d(1 - "IR")) D/E$], [Ponte ROE–ROIC],
    [Crescimento sustentável], [$g = "ROE" times "retenção"$], [Política de dividendos],
    [Duration modificada], [$D_("Mac")/(1 + y)$], [Sensibilidade do preço],
    [Paridade coberta], [$F = S (1 + i_("BR"))/(1 + i_("EUA"))$], [Câmbio a termo],
  )]
  , kind: table
  )

#line()

== Capítulo 15 --- Glossário
<capítulo-15-glossário>
Termos em ordem alfabética; os números entre parênteses indicam o capítulo.

#figure(
  align(center)[#table(
    columns: (28%, 72%),
    align: (left, left),
    table.header([Termo], [Definição],),
    [#strong[Alavancagem] (5, 6)], [Uso de capital de terceiros para ampliar o retorno do acionista; amplifica ganhos e perdas.],
    [#strong[Alfa] (2)], [Retorno acima do exigido pelo risco (pelo CAPM): $alpha = R - [R_f + beta(R_m - R_f)]$.],
    [#strong[Beta] (2)], [Sensibilidade do ativo ao mercado: $"Cov"(R_i, R_m)/"Var"(R_m)$.],
    [#strong[CAGR] (5)], [Taxa composta de crescimento anual entre dois pontos.],
    [#strong[CAPM] (2)], [Modelo que relaciona retorno esperado ao risco sistemático: $R_f + beta(R_m - R_f)$.],
    [#strong[CapEx] (4, 5)], [Investimento em ativo fixo (capital expenditure).],
    [#strong[CCL / NCG / ST] (8)], [Capital circulante líquido; necessidade de capital de giro; saldo de tesouraria ($"ST" = "CCL" - "NCG"$).],
    [#strong[Ciclo financeiro] (8)], [$"PME" + "PMR" - "PMP"$: dias que a empresa financia a operação.],
    [#strong[Convexidade] (11)], [Curvatura da relação preço × taxa de um título; refina a estimativa da duration.],
    [#strong[Covenant] (5)], [Cláusula de contrato de dívida que impõe limites financeiros (por exemplo, dívida líquida/EBITDA).],
    [#strong[Custo de capital] (3)], [Retorno mínimo exigido pelos provedores de capital; custo de oportunidade.],
    [#strong[Dívida líquida] (5)], [Dívida bruta menos caixa e aplicações financeiras.],
    [#strong[Dividend yield] (7)], [Dividendo por ação dividido pelo preço da ação.],
    [#strong[Drawdown] (11)], [Maior queda de um ativo ou carteira do pico ao vale.],
    [#strong[Due diligence] (9)], [Investigação financeira, fiscal, legal e operacional da empresa-alvo.],
    [#strong[Duration] (11)], [Prazo médio ponderado dos fluxos de um título; mede sua sensibilidade a juros.],
    [#strong[DuPont] (5)], [Decomposição do ROE em margem, giro e alavancagem (e, na versão estendida, impostos e juros).],
    [#strong[EBITDA] (5)], [Lucro antes de juros, impostos, depreciação e amortização; não é fluxo de caixa.],
    [#strong[EMH] (10)], [Hipótese de mercado eficiente: preços refletem a informação disponível.],
    [#strong[EVA / MVA] (1)], [Lucro econômico ($K ("ROIC" - "WACC")$); valor de mercado menos capital investido.],
    [#strong[Fronteira eficiente] (2)], [Carteiras de máximo retorno para cada nível de risco.],
    [#strong[FCFF / FCFE] (4)], [Fluxo de caixa livre da firma (para credores e acionistas) / do acionista.],
    [#strong[Gordon (modelo de)] (3, 4)], [Valor de um fluxo perpétuo crescente: $D_1/(K - g)$.],
    [#strong[Hamada (fórmula de)] (2, 3)], [Relação entre beta alavancado e desalavancado.],
    [#strong[Hedge] (12)], [Proteção contra movimentos adversos de preço.],
    [#strong[ICJ] (5)], [Índice de cobertura de juros: LAJIR / despesas financeiras.],
    [#strong[JCP] (7)], [Juros sobre capital próprio: remuneração ao acionista dedutível do IR da empresa, dentro de limites.],
    [#strong[Ke / Kd] (3)], [Custo do capital próprio / custo da dívida.],
    [#strong[LPA / DPA] (7)], [Lucro por ação / dividendo por ação.],
    [#strong[M&M] (6, 7)], [Modigliani-Miller: irrelevância (sem atritos) da estrutura de capital e da política de dividendos.],
    [#strong[Marcação a mercado] (11)], [Atualização do preço de um título ao valor de mercado vigente.],
    [#strong[Múltiplo] (4)], [Razão entre valor e uma métrica (P/L, EV/EBITDA, P/VP).],
    [#strong[NOPAT] (1, 5)], [Lucro operacional após impostos: $"EBIT"(1 - "IR")$.],
    [#strong[Opção] (11)], [Direito de comprar (call) ou vender (put) a um preço fixo.],
    [#strong[Pay-out] (7)], [Percentual do lucro líquido distribuído como dividendos.],
    [#strong[PEG] (4)], [P/L dividido pelo crescimento do lucro (em %).],
    [#strong[Pecking order] (6)], [Hierarquia de financiamento: recursos internos, dívida, ações.],
    [#strong[PPP] (12)], [Paridade do poder de compra: câmbio reflete os níveis de preços.],
    [#strong[Prêmio de risco] (2, 3)], [Retorno exigido acima da taxa livre de risco.],
    [#strong[Risco sistemático / específico] (2)], [Não diversificável (mercado) / diversificável (empresa).],
    [#strong[ROE / ROA / ROIC] (5)], [Retorno sobre patrimônio líquido / ativos / capital investido.],
    [#strong[Selic] (3)], [Taxa básica de juros da economia brasileira.],
    [#strong[Sharpe / Treynor] (2)], [Retorno excedente por unidade de risco total / sistemático.],
    [#strong[Sinergia] (9)], [Valor extra criado pela combinação de empresas.],
    [#strong[Spread] (3, 12)], [Diferença entre taxas (crédito sobre juro livre de risco, risco-país).],
    [#strong[Trade-off (teoria)] (6)], [Estrutura de capital ótima equilibra escudo fiscal e custos de falência.],
    [#strong[Valor terminal] (4)], [Valor presente dos fluxos após o período explícito de projeção.],
    [#strong[VaR] (2)], [Value at Risk: perda máxima esperada a um dado nível de confiança.],
    [#strong[VBM] (1)], [Gestão baseada em valor: decisões alinhadas à criação de valor ao acionista.],
    [#strong[WACC] (3)], [Custo médio ponderado de capital: $(E/V) K_e + (D/V) K_d (1 - "IR")$.],
    [#strong[YTM] (11)], [Rendimento até o vencimento de um título (taxa que iguala preço e fluxos).],
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


#line()

== Capítulo 18 --- Estudo de Caso Integrador: Alfa Indústria S.A.
<capítulo-18-estudo-de-caso-integrador>
Este capítulo reúne as ferramentas da apostila em uma análise completa de uma
empresa fictícia, a #strong[Alfa Indústria S.A.]: diagnóstico das
demonstrações, retorno, custo de capital, valuation por FCD e por múltiplos, e
veredito. Todos os valores em R\$ milhões. Siga o código executando-o; as
interpretações vêm logo abaixo de cada resultado.

=== 18.1. Os dados
<os-dados>
#figure(
  align(center)[#table(
    columns: (50%, 50%),
    align: (left, left),
    table.header([Demonstração do resultado], [Balanço patrimonial],),
    [Receita líquida: 2.000], [Caixa: 100 | Contas a receber: 330],
    [CPV (caixa): 1.200 | Despesas operacionais: 300], [Estoques: 220 | Imobilizado: 900 (Ativo: 1.550)],
    [Depreciação: 100 | Despesas financeiras: 80], [Fornecedores: 130 | Dívida CP: 120 | Dívida LP: 480],
    [IR: 34% | LL resultante: 211,2], [Patrimônio líquido: 820],
  )]
  , kind: table
  )

#strong[Dados de mercado:] 100 milhões de ações a R\$ 22,00; beta de 1,10; Selic de
10,5%; prêmio de mercado de 5,5%; custo bruto da dívida de 13,5% a.a.

```python
caso = dict(receita=2000, cpv=1200, desp_op=300, deprec=100, desp_fin=80, ir=0.34,
            caixa=100, receber=330, estoques=220, imobilizado=900,
            fornec=130, div_cp=120, div_lp=480, pl=820,
            acoes=100, preco=22.0, beta=1.10, rf=0.105, premio=0.055, kd_bruto=0.135)

ebitda_c = caso["receita"] - caso["cpv"] - caso["desp_op"]
ebit_c = ebitda_c - caso["deprec"]
lair_c = ebit_c - caso["desp_fin"]
ll_c = lair_c * (1 - caso["ir"])
ativo_c = caso["caixa"] + caso["receber"] + caso["estoques"] + caso["imobilizado"]
passivo_c = caso["fornec"] + caso["div_cp"] + caso["div_lp"] + caso["pl"]
divida_c = caso["div_cp"] + caso["div_lp"]
print(f"EBITDA {ebitda_c} ({ebitda_c/caso['receita']:.1%}) | EBIT {ebit_c} | LAIR {lair_c} | LL {ll_c:.1f}")
print(f"Ativo {ativo_c} = Passivo+PL {passivo_c}: {'OK, o balanço fecha' if ativo_c == passivo_c else 'ERRO'}")
```

```
EBITDA 500 (25.0%) | EBIT 400 | LAIR 320 | LL 211.2
Ativo 1550 = Passivo+PL 1550: OK, o balanço fecha
```

=== 18.2. Diagnóstico: liquidez, endividamento, rentabilidade e DuPont
<diagnóstico-liquidez-endividamento-rentabilidade-e-dupont>
```python
ac_c = caso["caixa"] + caso["receber"] + caso["estoques"]
pc_c = caso["fornec"] + caso["div_cp"]
print(f"Liquidez corrente {ac_c/pc_c:.2f} | seca {(ac_c - caso['estoques'])/pc_c:.2f} | imediata {caso['caixa']/pc_c:.2f}")
print(f"Dívida líquida {divida_c - caso['caixa']} | DL/EBITDA {(divida_c - caso['caixa'])/ebitda_c:.2f}x | cobertura de juros (EBIT/desp. fin.) {ebit_c/caso['desp_fin']:.2f}x")
print(f"Dívida/PL {divida_c/caso['pl']:.2f} | passivo exigível/ativo {(ativo_c - caso['pl'])/ativo_c:.1%}")

nopat_c = ebit_c * (1 - caso["ir"])
capital_inv = divida_c - caso["caixa"] + caso["pl"]
print(f"NOPAT {nopat_c:.1f} | capital investido {capital_inv} | ROIC {nopat_c/capital_inv:.2%} | ROE {ll_c/caso['pl']:.2%} | ROA {ll_c/ativo_c:.2%}")

dupont_c = [("Carga tributária", ll_c / lair_c), ("Carga de juros", lair_c / ebit_c), ("Margem EBIT", ebit_c / caso["receita"]),
            ("Giro do ativo", caso["receita"] / ativo_c), ("Alavancagem", ativo_c / caso["pl"])]
print("DuPont:", " × ".join(f"{n}: {v:.3f}" for n, v in dupont_c), f"= ROE {np.prod([v for _, v in dupont_c]):.2%}")

pme_a = caso["estoques"] / caso["cpv"] * 360
pmr_a = caso["receber"] / caso["receita"] * 360
pmp_a = caso["fornec"] / caso["cpv"] * 360
print(f"PME {pme_a:.0f} d | PMR {pmr_a:.0f} d | PMP {pmp_a:.0f} d | ciclo financeiro {pme_a + pmr_a - pmp_a:.0f} dias")
```

```
Liquidez corrente 2.60 | seca 1.72 | imediata 0.40
Dívida líquida 500 | DL/EBITDA 1.00x | cobertura de juros (EBIT/desp. fin.) 5.00x
Dívida/PL 0.73 | passivo exigível/ativo 47.1%
NOPAT 264.0 | capital investido 1320 | ROIC 20.00% | ROE 25.76% | ROA 13.63%
DuPont: Carga tributária: 0.660 × Carga de juros: 0.800 × Margem EBIT: 0.200 × Giro do ativo: 1.290 × Alavancagem: 1.890 = ROE 25.76%
PME 66 d | PMR 59 d | PMP 39 d | ciclo financeiro 86 dias
```

=== 18.3. Custo de capital
<custo-de-capital-alfa>
```python
ke_c = caso["rf"] + caso["beta"] * caso["premio"]
e_c = caso["acoes"] * caso["preco"]
v_c = e_c + divida_c
kd_liq_c = caso["kd_bruto"] * (1 - caso["ir"])
wacc_c = e_c / v_c * ke_c + divida_c / v_c * kd_liq_c
print(f"Ke (CAPM) {ke_c:.2%} | valor de mercado do PL R${e_c:,.0f} (pesos: PL {e_c/v_c:.1%}, dívida {divida_c/v_c:.1%})")
print(f"Kd líquido {kd_liq_c:.2%} | WACC {wacc_c:.2%}")
roic_c = nopat_c / capital_inv
print(f"Spread ROIC - WACC: {(roic_c - wacc_c)*100:+.2f} p.p. | EVA = R${capital_inv * (roic_c - wacc_c):,.1f} milhões/ano")
```

```
Ke (CAPM) 16.55% | valor de mercado do PL R$2,200 (pesos: PL 78.6%, dívida 21.4%)
Kd líquido 8.91% | WACC 14.91%
Spread ROIC - WACC: +5.09 p.p. | EVA = R$67.2 milhões/ano
```

=== 18.4. Valuation por fluxo de caixa descontado
<valuation-por-fcd-alfa>
A empresa investe para crescer, e investir consome fluxo de caixa. Para manter
a coerência, o fluxo é derivado do #strong[crescimento e do retorno do
reinvestimento]: se o NOPAT cresce a uma taxa $g$ com retorno $"RONIC"$ sobre o novo capital, a
fração do NOPAT reinvestida é $g/"RONIC"$ e $"FCFF" = "NOPAT" (1 - g/"RONIC")$. Projetamos
cinco anos de crescimento de 8% com RONIC de 20% (40% do NOPAT reinvestido) e, depois,
crescimento perpétuo de 3,5% com RONIC terminal de 16% (21,9% reinvestido).

```python
g_exp, ronic_exp, g_term, ronic_term = 0.08, 0.20, 0.035, 0.16
nopat_proj = [nopat_c * (1 + g_exp) ** t for t in range(1, 6)]
fcff_proj = [n * (1 - g_exp / ronic_exp) for n in nopat_proj]
nopat_6 = nopat_proj[-1] * (1 + g_term)
fcff_6 = nopat_6 * (1 - g_term / ronic_term)
vt_c = fcff_6 / (wacc_c - g_term)
vp_fcff = sum(f / (1 + wacc_c) ** (t + 1) for t, f in enumerate(fcff_proj))
vp_vt_c = vt_c / (1 + wacc_c) ** 5
ev_c = vp_fcff + vp_vt_c
equity_c = ev_c - (divida_c - caso["caixa"])
print("FCFF projetados:", [f"{f:.1f}" for f in fcff_proj])
print(f"VP dos FCFF R${vp_fcff:,.1f} | VP do valor terminal R${vp_vt_c:,.1f} ({vp_vt_c/ev_c:.1%} do EV)")
print(f"EV R${ev_c:,.1f} | dívida líquida R${divida_c - caso['caixa']} | equity R${equity_c:,.1f}")
print(f"Preço justo por ação: R${equity_c / caso['acoes']:.2f} vs. mercado R${caso['preco']:.2f} ({equity_c / caso['acoes'] / caso['preco'] - 1:+.1%})")

print("\nPreço justo por ação (R$) variando o WACC e o crescimento terminal:")
gs_c = [0.025, 0.030, 0.035, 0.040, 0.045]
print(f"{'WACC':>7} " + " ".join(f"{g_*100:>7.1f}%" for g_ in gs_c))
for w_off in (-0.015, -0.0075, 0.0, 0.0075, 0.015):
    w_ = wacc_c + w_off
    linha = []
    for g_ in gs_c:
        f6 = nopat_proj[-1] * (1 + g_) * (1 - g_ / ronic_term)
        ev_ = sum(f / (1 + w_) ** (t + 1) for t, f in enumerate(fcff_proj)) + f6 / (w_ - g_) / (1 + w_) ** 5
        linha.append((ev_ - (divida_c - caso["caixa"])) / caso["acoes"])
    print(f"{w_:>7.2%} " + " ".join(f"{p:>8.2f}" for p in linha))
```

```
FCFF projetados: ['171.1', '184.8', '199.5', '215.5', '232.7']
VP dos FCFF R$660.0 | VP do valor terminal R$1,371.6 (67.5% do EV)
EV R$2,031.6 | dívida líquida R$500 | equity R$1,531.6
Preço justo por ação: R$15.32 vs. mercado R$22.00 (-30.4%)

Preço justo por ação (R$) variando o WACC e o crescimento terminal:
   WACC     2.5%     3.0%     3.5%     4.0%     4.5%
 13.41%    18.24    18.47    18.72    18.99    19.28
 14.16%    16.56    16.72    16.89    17.08    17.27
 14.91%    15.09    15.20    15.32    15.44    15.56
 15.66%    13.79    13.86    13.94    14.01    14.09
 16.41%    12.64    12.68    12.72    12.76    12.80
```

=== 18.5. Validação por múltiplos
<validação-por-múltiplos-alfa>
```python
lpa_c = ll_c / caso["acoes"]
ev_mercado = e_c + divida_c - caso["caixa"]
print(f"LPA R${lpa_c:.2f} | P/L de mercado {caso['preco'] / lpa_c:.1f}x | EV/EBITDA de mercado {ev_mercado / ebitda_c:.2f}x | P/VP {e_c / caso['pl']:.2f}x")
print(f"Pelo FCD: EV/EBITDA implícito {ev_c / ebitda_c:.2f}x | P/L implícito {equity_c / ll_c:.1f}x")
for nome_m, mult_m in (("EV/EBITDA setorial 6,0x", 6.0), ("EV/EBITDA setorial 7,0x", 7.0)):
    preco_m = (mult_m * ebitda_c - (divida_c - caso["caixa"])) / caso["acoes"]
    print(f"{nome_m}: preço justo R${preco_m:.2f}")
```

```
LPA R$2.11 | P/L de mercado 10.4x | EV/EBITDA de mercado 5.40x | P/VP 2.68x
Pelo FCD: EV/EBITDA implícito 4.06x | P/L implícito 7.3x
EV/EBITDA setorial 6,0x: preço justo R$25.00
EV/EBITDA setorial 7,0x: preço justo R$30.00
```

#strong[FCD reverso: o que o mercado "precifica"?] Em vez de perguntar "quanto vale?", pergunta-se
"#emph[que premissa] justificaria o preço de R\$ 22,00?". Primeiro testamos o #strong[crescimento]; depois a
#strong[taxa de desconto]:

```python
def preco_fcd_alfa(g_cinco, wacc_a=wacc_c, ronic_a=0.20, g_t=0.035, ronic_t=0.16):
    nopat_a = [nopat_c * (1 + g_cinco) ** t for t in range(1, 6)]
    fcff_a = [n * (1 - g_cinco / ronic_a) for n in nopat_a]
    f6_a = nopat_a[-1] * (1 + g_t) * (1 - g_t / ronic_t)
    ev_a = sum(f / (1 + wacc_a) ** (t + 1) for t, f in enumerate(fcff_a)) + f6_a / (wacc_a - g_t) / (1 + wacc_a) ** 5
    return (ev_a - (divida_c - caso["caixa"])) / caso["acoes"]

def bisseccao(funcao, baixo, alto, passos=200):
    for _ in range(passos):
        meio = (baixo + alto) / 2
        if funcao(baixo) * funcao(meio) > 0:
            baixo = meio
        else:
            alto = meio
    return (baixo + alto) / 2

for g_teste in (0.05, 0.08, 0.12, 0.16):
    print(f"Crescimento de {g_teste:.0%} ao ano por 5 anos -> preço justo R${preco_fcd_alfa(g_teste):.2f}")
wacc_impl = bisseccao(lambda w_: preco_fcd_alfa(0.08, wacc_a=w_) - caso["preco"], 0.08, wacc_c)
print(f"WACC que iguala o FCD ao preço de mercado (g = 8%): {wacc_impl:.2%} (vs. {wacc_c:.2%} calculado)")
```

```
Crescimento de 5% ao ano por 5 anos -> preço justo R$14.53
Crescimento de 8% ao ano por 5 anos -> preço justo R$15.32
Crescimento de 12% ao ano por 5 anos -> preço justo R$16.34
Crescimento de 16% ao ano por 5 anos -> preço justo R$17.32
WACC que iguala o FCD ao preço de mercado (g = 8%): 12.30% (vs. 14.91% calculado)
```

=== 18.6. Veredito
<veredito-alfa>
#strong[1. A empresa é saudável.] O balanço fecha; a margem EBITDA é de 25%. Liquidez
corrente de 2,60 (seca de 1,72), dívida líquida de apenas 1,0x o EBITDA e cobertura de
juros de 5,0x: bem abaixo de covenants típicos, com folga para se endividar mais.

#strong[2. Cria valor.] O ROIC de 20,0% supera o WACC de 14,91% em 5,1 pontos
percentuais, o que significa um #strong[EVA de R\$ 67 milhões por ano]. O ROE de 25,8% é o ROIC mais
um pouco de alavancagem. O DuPont mostra de onde vem o retorno: margem EBIT de 20% (o ponto
forte), giro de 1,29x e alavancagem moderada de 1,89x; a carga tributária (0,66) e os juros
(0,80) consomem o resto.

#strong[3. Há oportunidade no capital de giro.] O ciclo financeiro é de 86 dias.
Cada 10 dias a menos no prazo de recebimento liberam cerca de R\$ 56 milhões
($2.000/360 times 10$) --- um ganho de aproximadamente R\$ 8 milhões por ano ao custo de
capital de 14,9%, sem vender nada a mais.

#strong[4. O FCD dá R\$ 15,32 por ação, 30% abaixo do mercado.] O valor terminal
responde por 67,5% do EV. Duas leituras importantes da tabela de sensibilidade:
(i) o valor é #strong[pouco sensível ao crescimento terminal] --- como o retorno do
reinvestimento terminal (16%) está próximo do WACC (14,9%), #emph[crescer cria pouco valor]:
ao passar o crescimento de 5 para 16% ao ano nos cinco primeiros anos, o preço sobe de
R\$ 14,53 para R\$ 17,32; (ii) é #strong[muito sensível ao WACC]: cada 0,75 ponto
percentual a mais ou a menos mexe no preço em cerca de R\$ 1,5 a 1,7 (aproximadamente 10%).
A lição reforça o capítulo 1: crescer só cria valor se o retorno sobre o novo capital supera o
custo de capital por uma margem relevante.

#strong[5. Os múltiplos contam outra história.] O mercado negocia a Alfa a 5,40x
EV/EBITDA e a 10,4x o lucro. Múltiplos setoriais de 6x a 7x o EBITDA indicariam R\$ 25 a R\$ 30
por ação; o FCD de base equivale a apenas 4,06x EBITDA.

#strong[6. Reconciliando.] As duas abordagens divergem (de R\$ 15 a R\$ 30), e a divergência
é informativa. Para o FCD igualar o preço de mercado, o WACC teria de ser 12,3% (e não
14,9%): o mercado usa uma taxa de desconto menor, ou espera retornos terminais e
margens maiores que as do nosso cenário-base. Um múltiplo setorial, por sua vez, "herda" as
premissas implícitas dos pares --- que podem estar caras.

#atencao[
  #strong["Boa empresa" não é o mesmo que "boa ação".] A Alfa cria valor (ROIC > WACC) e tem
  balanço sólido, mas a R\$ 22,00 o mercado já paga por premissas mais otimistas que as do
  cenário-base. A conclusão honesta é uma #strong[faixa], de cerca de R\$ 15 (FCD
  conservador) a R\$ 30 (múltiplos setoriais), e a decisão depende de qual premissa o analista
  considera mais crível --- não de um número único.
]

#resumo[
  - Uma análise completa integra: diagnóstico das demonstrações, retorno (ROIC × WACC, EVA, DuPont), custo de capital, FCD e múltiplos.
  - O valor terminal domina o FCD; a sensibilidade ao WACC é maior que ao crescimento quando o retorno do reinvestimento é próximo do WACC.
  - O FCD reverso (qual premissa justifica o preço?) é uma forma útil de ler o mercado.
  - O resultado é uma faixa de valor, não um número.
]

== Capítulo 19 --- Erros Comuns e Teste Rápido
<capítulo-19-erros-comuns-e-teste-rápido>
=== 19.1. Os erros mais comuns em finanças
<os-erros-mais-comuns-em-finanças>
#figure(
  align(center)[#table(
    columns: (4%, 38%, 58%),
    align: (center, left, left),
    table.header([\#], [Erro], [Como evitar],),
    [1], [Descontar fluxos nominais por taxa real (ou o contrário)], [Alinhe moeda e inflação do fluxo com a taxa de desconto],
    [2], [Usar valor contábil nos pesos do WACC], [Use valor de #strong[mercado] do patrimônio e da dívida],
    [3], [Contar duas vezes o escudo fiscal (no fluxo e no $K_d$)], [Ele aparece só no $(1 - "IR")$ do WACC],
    [4], [Valor terminal com $g >= "WACC"$ ou crescimento acima do PIB], [Limite $g$ ao crescimento de longo prazo da economia],
    [5], [Apresentar um único valor de DCF], [Mostre faixas e a sensibilidade WACC × $g$],
    [6], [Comparar P/L de empresas com crescimentos e riscos diferentes], [Compare pares; considere PEG e EV/EBITDA],
    [7], [Confundir EBITDA com caixa], [Desconte CapEx, capital de giro, impostos e juros],
    [8], [Tratar ROE alto como qualidade], [Verifique ROIC e alavancagem (DuPont)],
    [9], [Usar a média aritmética de retornos para crescimento do patrimônio], [Use a média #strong[geométrica]],
    [10], [Aceitar projeto de alto risco ao WACC médio da empresa], [Use o custo de capital do #strong[projeto]],
  )]
  , kind: table
  )

=== 19.2. Teste rápido: verdadeiro ou falso (com gabarito)
<teste-rápido-verdadeiro-ou-falso-com-gabarito-fin>
+ #strong[V ou F:] Diversificar elimina todo o risco de uma carteira. #strong[Falso.] Elimina o risco
  específico; o risco sistemático permanece ($sigma sqrt(rho)$).
+ #strong[V ou F:] Um ativo com beta 1,5 deve render mais que o mercado, pelo CAPM.
  #strong[Verdadeiro.] $E(R) = R_f + "1,5" (R_m - R_f) > R_m$ se o prêmio de mercado for positivo.
+ #strong[V ou F:] O custo da dívida usado no WACC é o custo bruto. #strong[Falso.] É o custo
  #strong[líquido] de IR, $K_d (1 - "IR")$, se há lucro tributável.
+ #strong[V ou F:] Em M&M sem impostos, endividar-se mais reduz o WACC. #strong[Falso.] O WACC permanece
  constante: o $K_e$ sobe na mesma medida.
+ #strong[V ou F:] Com impostos e sem custos de falência, o valor da empresa aumenta
  com a dívida. #strong[Verdadeiro.] $V_L = V_U + "IR" dot D$.
+ #strong[V ou F:] O EVA é positivo sempre que a empresa tem lucro contábil. #strong[Falso.] Exige
  ROIC > WACC: lucro positivo com retorno abaixo do custo de capital destrói valor.
+ #strong[V ou F:] Aumentar o pay-out sempre aumenta o valor da ação. #strong[Falso.] Depende do ROE
  do reinvestimento comparado ao $K_e$.
+ #strong[V ou F:] Um título de maior duration tem preço mais sensível às taxas de juros.
  #strong[Verdadeiro.] $Delta P/P approx -D_("mod") Delta y$.
+ #strong[V ou F:] Pela paridade coberta, a moeda de juro maior tem câmbio a termo mais desvalorizado.
  #strong[Verdadeiro.] $F = S (1 + i)/(1 + i^*)$.
+ #strong[V ou F:] O valor terminal pesa pouco no valuation por FCD. #strong[Falso.] Costuma pesar 60% a 80%.
