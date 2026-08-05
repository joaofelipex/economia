= Apostila 5 --- Projetos Práticos de Economia
<apostila-5-projetos-práticos-de-economia>
Esta apostila reúne projetos completos que integram tudo que você
aprendeu nas Apostilas 1 a 4 (Python, pandas, visualização e
econometria). Diferente das apostilas anteriores, ela não está
organizada em capítulos de teoria progressiva --- está organizada em
#strong[projetos independentes], cada um pensado para virar um item de
portfólio, um capítulo de TCC ou uma rotina de trabalho real de um
economista.

Cada projeto segue a mesma estrutura: primeiro o #strong[objetivo] (o
que o script resolve e por que alguém pagaria ou publicaria por isso),
depois a #strong[fundamentação teórica] (o modelo econômico por trás do
código --- sem entender essa parte, o script vira uma caixa-preta que
produz números sem significado), depois um pequeno bloco #strong["Antes
de rodar"] com perguntas conceituais que você deveria conseguir
responder #emph[antes] de apertar "executar" (se você não consegue
prever ao menos o sinal do resultado, o modelo ainda não foi entendido
--- só copiado), e só então o #strong[script completo], comentado,
seguido de um #strong[Desafio] para você estender o projeto sozinho, sem
solução fornecida.

O Projeto 8, ao final, foge um pouco desse padrão: é uma lista de
exercícios curtos e pontuais --- não projetos inteiros --- para praticar
conceitos específicos das apostilas anteriores em dados reais, um de
cada vez.

#line()

== Projeto 1 --- Dashboard Macroeconômico do Brasil
<projeto-1-dashboard-macroeconômico-do-brasil>
=== Objetivo
<objetivo>
Criar um script que baixa, analisa e gera um relatório completo com os
principais indicadores.

=== Indicadores
<indicadores>
#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Variável], [Código BCB],),
    table.hline(),
    [IPCA (mensal)], [433],
    [SELIC (meta)], [11],
    [Desemprego], [24369],
    [Câmbio (USD)], [1],
    [PIB mensal], [4380],
  )]
  , kind: table
  )

=== Fundamentação teórica
<fundamentação-teórica>
Um dashboard macroeconômico não é uma coleção arbitrária de gráficos ---
cada indicador escolhido corresponde a uma peça de um arcabouço teórico
específico, e o valor de colocá-los lado a lado é deixar visíveis os
canais de transmissão que os conectam.

#strong[IPCA e a mensuração da inflação.] O IPCA (Índice de Preços ao
Consumidor Amplo) mede a variação de preços de uma cesta consumida pelas
famílias urbanas de renda entre 1 e 40 salários mínimos --- é o
índice-alvo do regime de metas de inflação brasileiro. A inflação
acumulada em 12 meses #strong[não] é a soma simples das taxas mensais
(como o script calcula, de forma aproximada, com `.rolling(12).sum()`),
e sim o produto encadeado, já que inflação composta funciona como juros
compostos aplicados a preços:

$ upright("IPCA")_(12 m) = [product_(i = 1)^12 \( 1 + pi_i \)] - 1 $

onde $pi_i$ é a inflação do mês $i$ em proporção (não em %). Para taxas
mensais pequenas, a soma simples é uma boa aproximação de primeira ordem
--- mas em ambientes de inflação mais alta a diferença entre soma e
produto deixa de ser desprezível (voltamos a isso no Desafio).

#strong[Juro real e a equação de Fisher.] A SELIC é a taxa de juros
nominal de política monetária; o que importa para decisões de consumo e
investimento é o juro real, o retorno depois de descontada a perda de
poder de compra da moeda. A relação exata entre as três variáveis é a
equação de Fisher:

$ \(1 + i\)=\(1 + r\)\(1 + pi^e\) $

Isolando o juro real $r$:

$ r = frac(1 + i, 1 + pi^e) - 1 $

O script usa a aproximação linear $r approx i - pi^e$ (a variável
`JURO_REAL`), válida quando $i$ e $pi^e$ são pequenos --- o termo de
segunda ordem $r dot.op pi^e$ se torna desprezível. É a mesma
aproximação e o mesmo trade-off vistos na Apostila 1 (Capítulo 5) e
retomados com rigor na Apostila 6.

#strong[Desemprego, câmbio e a leitura conjunta.] O desemprego é o
principal indicador do lado real da economia --- junto ao hiato do
produto (Projeto 5), é a variável que a política monetária tenta
estabilizar sem gerar inflação excessiva, o trade-off por trás da Curva
de Phillips (Apostila 4). O câmbio nominal conecta a economia doméstica
ao resto do mundo: uma desvalorização cambial pressiona a inflação via
preços de importados (o #emph[pass-through] cambial) e afeta a
competitividade externa --- e episódios extremos de pressão cambial são
o objeto do Projeto 6.

Um dashboard bem desenhado deixa visível essa cadeia causal: câmbio →
inflação → juro (via regra de política monetária) → hiato do
produto/desemprego → e de volta à inflação, fechando o ciclo de
transmissão da política monetária.

#strong[Dois indicadores derivados que valem a pena conhecer.] Embora
não estejam no script, dois índices simples costumam complementar um
dashboard como este, e são bons candidatos para o Desafio:

- #strong[Índice de Miséria] (Okun, 1962):
  $upright("IM")_t = pi_t + u_t$, a soma simples da inflação e da taxa
  de desemprego --- uma medida informal (não derivada de um modelo
  formal de bem-estar) de quão "desconfortável" está a situação
  macroeconômica para o cidadão médio.
- #strong[Lei de Okun] (Okun, 1962): relaciona variações no hiato do
  produto a variações na taxa de desemprego,
  $#h(0em) u_t - u_(t - 1) approx - kappa thin\(g_t - g^(*)\)$, onde
  $g_t$ é o crescimento do PIB, $g^(*)$ a taxa de crescimento potencial
  e $kappa > 0$ um coeficiente empírico (tipicamente entre 0,3 e 0,5 nos
  EUA; a magnitude varia bastante entre países e é objeto de estimação
  própria no caso brasileiro).

Um trecho de código isolado ajuda a fixar a diferença entre a
aproximação linear de Fisher e a fórmula exata, discutidas acima:

```python
def juro_real_exato(selic_pct, ipca_pct):
    i, pi = selic_pct / 100, ipca_pct / 100
    return ((1 + i) / (1 + pi) - 1) * 100

def juro_real_aproximado(selic_pct, ipca_pct):
    return selic_pct - ipca_pct

# Com SELIC = 13,25% e IPCA acumulado = 4,50%:
print(juro_real_exato(13.25, 4.50))       # ~8,37%
print(juro_real_aproximado(13.25, 4.50))  # 8,75%
```

A diferença de quase 0,4 p.p. entre os dois números acima, num cenário
de juros bem mais altos que a inflação, é o tipo de erro que se acumula
de forma relevante num relatório que reporta juro real mês a mês.

=== Antes de rodar
<antes-de-rodar>
- Dado o cenário macroeconômico atual do Brasil, você espera que o juro
  real (SELIC menos IPCA acumulado) esteja positivo ou negativo? O que
  isso sugere sobre a postura da política monetária (contracionista
  vs.~expansionista)?
- Se o câmbio se desvalorizasse 10% em um único mês, qual dos outros
  indicadores do dashboard você esperaria reagir primeiro, e com que
  defasagem aproximada (meses)?

=== Script completo
<script-completo>
```python
from bcb import sgs
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

# 1. BAIXAR DADOS
codigos = {
    "IPCA": 433,
    "SELIC": 11,
    "DESEMPREGO": 24369,
    "CAMBIO": 1,
    "PIB": 4380
}

dados = sgs.get(codigos, start="2010-01-01")

# 2. PROCESSAR
# Inflação acumulada 12 meses
dados["IPCA_ACUM"] = dados["IPCA"].rolling(12).sum()

# Juro real
dados["JURO_REAL"] = dados["SELIC"] - dados["IPCA_ACUM"]

# Variação do câmbio
dados["CAMBIO_VAR"] = dados["CAMBIO"].pct_change() * 100

# 3. RELATÓRIO TEXTO
print("=" * 60)
print("RELATÓRIO MACROECONÔMICO - BRASIL")
print("=" * 60)

ultimos = dados.tail(1)
print(f"\n📅 Referência: {ultimos.index[0].date()}")
print(f"\n📍 INFLAÇÃO")
print(f"   IPCA mensal: {ultimos['IPCA'].values[0]:.2f}%")
print(f"   IPCA acum. 12m: {ultimos['IPCA_ACUM'].values[0]:.2f}%")

print(f"\n📍 JUROS")
print(f"   SELIC: {ultimos['SELIC'].values[0]:.2f}%")
print(f"   Juro real: {ultimos['JURO_REAL'].values[0]:.2f}%")

print(f"\n📍 MERCADO DE TRABALHO")
print(f"   Desemprego: {ultimos['DESEMPREGO'].values[0]:.2f}%")

print(f"\n📍 CÂMBIO")
print(f"   USD/BRL: {ultimos['CAMBIO'].values[0]:.2f}")

# 4. GRÁFICOS
fig, axes = plt.subplots(3, 2, figsize=(14, 10))
axes = axes.flatten()

titulos = [
    ("IPCA (mensal)", "crimson"),
    ("SELIC", "navy"),
    ("IPCA Acum. 12m", "darkred"),
    ("Desemprego", "darkgreen"),
    ("Câmbio (USD/BRL)", "purple"),
    ("Juro Real", "orange")
]

for ax, (titulo, cor), (_, serie) in zip(axes, titulos, dados[titulos]):
    ax.plot(dados.index, serie, color=cor, linewidth=1.2)
    ax.set_title(titulo, fontsize=12, fontweight="bold")
    ax.grid(True, alpha=0.3)

fig.delaxes(axes[5])  # remove último (vazio)
fig.tight_layout()
fig.savefig("dashboard_macro.png", dpi=200, bbox_inches="tight")
plt.close()

print("\n📊 Dashboard salvo: dashboard_macro.png")
```

=== Desafio
<desafio>
Adicione mais 2 indicadores de sua escolha (pesquise códigos no site do
BCB SGS).

#line()

== Projeto 2 --- Análise de Convergência de Renda
<projeto-2-análise-de-convergência-de-renda>
=== Objetivo
<objetivo-1>
Testar a hipótese de β-convergência: países pobres crescem mais rápido
que países ricos.

=== Fundamentação teórica
<fundamentação-teórica-1>
A hipótese de convergência de renda deriva do modelo de crescimento de
Solow-Swan (Solow, 1956), no qual o produto por trabalhador em estado
estacionário é determinado por parâmetros estruturais (taxa de poupança
$s$, depreciação $delta$, crescimento populacional $n$, progresso
tecnológico $g$) --- não pelo nível inicial de capital. A intuição:
economias com menos capital por trabalhador têm produtividade marginal
do capital mais alta (retornos marginais decrescentes) e por isso
crescem mais rápido até convergir ao seu estado estacionário.

#strong[Função de produção e acumulação de capital.] O modelo parte de
uma função de produção neoclássica com retornos constantes de escala,
tipicamente Cobb-Douglas, $Y = K^alpha\(upright("AL")\)^(1 - alpha)$ com
$0 < alpha < 1$. Em termos per capita efetivo ($k = K\/upright("AL")$,
$y = Y\/upright("AL") = k^alpha$), a acumulação de capital segue:

$ dot(k) = s thin k^alpha -\(n + g + delta\)thin k $

Perto do estado estacionário $k^(*)$ (onde $dot(k) = 0$), a linearização
dessa equação diferencial mostra que a velocidade de convergência é
aproximadamente constante e proporcional à distância até o estado
estacionário --- esse é o fundamento microeconômico por trás da equação
de β-convergência testada empiricamente.

#strong[β-convergência (absoluta).] A forma reduzida, testável com uma
regressão simples, relaciona o crescimento médio do PIB per capita entre
dois períodos ao #emph[log] do PIB per capita inicial:

$ g_(i\,\[0\,T\]) = alpha + beta ln\(y_(i\,0)\)+ epsilon_i\,#h(2em) g_(i\,\[0\,T\]) = 1 / T ln #h(-1em) (y_(i\,T) / y_(i\,0)) $

A convergência absoluta é confirmada se $hat(beta) < 0$ e
estatisticamente significativo: países que partiram mais pobres
cresceram mais rápido. É exatamente essa regressão que `sm.OLS` estima
no script. Da teoria de Solow linearizada, deriva-se uma relação entre
$beta$ e a velocidade de convergência $lambda$:

$ beta approx -\(1 - e^(- lambda T)\)quad arrow.r.double quad lambda = - frac(ln\(1 + beta\), T) $

Um $lambda$ próximo de 2% ao ano é o resultado clássico de Barro e
Sala-i-Martin (1992) em países e regiões --- a chamada "regra dos 2%".

#strong[Exemplo numérico.] Suponha que a regressão do script produza
$hat(beta) = - 0\,015$ para uma janela de $T = 20$ anos (o mesmo
horizonte 2000--2020 usado no código). A velocidade de convergência
implícita seria $lambda = - ln\(1 - 0\,015\)\/20 approx 0\,00076$, ou
cerca de 0,076% ao ano --- bem abaixo da "regra dos 2%", o que
sinalizaria convergência extremamente lenta (o hiato entre países ricos
e pobres levaria séculos para se fechar pela metade). Comparar o
$lambda$ implícito do seu resultado com esse benchmark de 2% é uma forma
rápida de julgar se a magnitude encontrada é economicamente relevante, e
não apenas estatisticamente significativa. Em código:

```python
import numpy as np

def velocidade_convergencia(beta, T):
    """beta: coeficiente estimado da regressão; T: horizonte em anos."""
    return -np.log(1 + beta) / T

lam = velocidade_convergencia(beta=-0.015, T=20)
print(f"lambda = {lam:.5f} ({lam*100:.3f}% ao ano)")
```

#strong[Convergência absoluta vs.~condicional.] A regressão simples
testa convergência #emph[absoluta]: a previsão de que todo país
convergiria para o mesmo nível de renda per capita de longo prazo ---
hipótese fortemente rejeitada em amostras heterogêneas de países ricos e
pobres. A resposta da literatura é a convergência #emph[condicional]:
cada país converge para o seu #strong[próprio] estado estacionário,
condicional a variáveis de controle (poupança, educação, instituições):

$ g_(i\,\[0\,T\]) = alpha + beta ln\(y_(i\,0)\)+ gamma' X_i + epsilon_i $

Nesse caso, $hat(beta) < 0$ é esperado mesmo sem convergência a um nível
comum --- apenas a trajetórias paralelas em log. Sem a variável de
controle, a regressão do script mistura os dois conceitos.

#strong[σ-convergência.] Um conceito distinto, por vezes confundido com
β-convergência, é a redução ao longo do tempo da dispersão
(desvio-padrão) da renda per capita em log entre os países da amostra:
$sigma_t = upright("dp")\[ln\(y_(i\,t)\)\]_i$. Há σ-convergência se
$sigma_T < sigma_0$. É possível ter β-convergência sem σ-convergência
--- choques idiossincráticos podem ampliar a dispersão mesmo que, em
média, os pobres cresçam mais rápido. Esse fenômeno é por vezes chamado
de "falácia de Galton" aplicada a crescimento, em referência à regressão
à média observada originalmente por Francis Galton em alturas de pais e
filhos.

#strong[Uma ressalva sobre o script.] O código usa dados
#strong[simulados aleatoriamente] (`np.random.uniform`) apenas para fins
didáticos --- qualquer padrão de convergência encontrado no exemplo é
artefato do gerador aleatório, não um fato sobre a economia mundial.
Para uma análise real, é necessário substituir os dados simulados pelos
dados efetivos do WDI (indicador `NY.GDP.PCAP.PP.KD`, PIB per capita
PPC), como o próprio comentário no código sugere.

=== Antes de rodar
<antes-de-rodar-1>
- Qual sinal você espera para o coeficiente β se a hipótese de
  convergência absoluta for verdadeira? Se você adicionasse uma variável
  de controle (ex: taxa de investimento), o que aconteceria com a
  magnitude do β ao passar de convergência absoluta para condicional?
- Como os dados do script são simulados aleatoriamente (sem relação
  causal real entre PIB inicial e crescimento), que valor de β você
  espera obter em expectativa, e por quê?

=== Dados
<dados>
Vamos usar o World Development Indicators (WDI) do Banco Mundial.

```python
import pandas as pd
import numpy as np
import statsmodels.api as sm
import matplotlib.pyplot as plt
from pandas_datareader import wb  # alternativa: baixar CSV manualmente

# Baixar PIB per capita (método alternativo)
# NY.GDP.PCAP.PP.KD = PIB per capita PPP (US$ constantes)
paises = ["BRA", "ARG", "CHL", "COL", "PER", "MEX", "URY", "ECU",
          "USA", "CAN", "GBR", "DEU", "FRA", "JPN", "KOR", "CHN",
          "IND", "ZAF", "NGA", "KEN", "ETH", "VNM", "IDN", "PHL",
          "TUR", "RUS", "SAU", "ARE"]

# NOTA: Se pandas_datareader não estiver instalado:
# pip install pandas_datareader
# Se falhar, baixe manualmente de https://data.worldbank.org/

# Vou usar dados simulados para demonstração:
np.random.seed(42)
anos_dados = {pais: {"pib_2000": np.random.uniform(1000, 40000),
                      "pib_2020": np.random.uniform(2000, 60000)}
              for pais in paises}

df = pd.DataFrame.from_dict(anos_dados, orient="index")
df["crescimento"] = (df["pib_2020"] / df["pib_2000"]) ** (1/20) - 1
df["crescimento"] *= 100  # em %
df["log_pib_2000"] = np.log(df["pib_2000"])

# β-convergência: crescimento ~ β * log(PIB inicial)
X = sm.add_constant(df["log_pib_2000"])
y = df["crescimento"]

modelo = sm.OLS(y, X).fit()
print("TESTE DE β-CONVERGÊNCIA")
print("=" * 40)
print(modelo.summary())

# Coeficiente β negativo confirma convergência
beta = modelo.params["log_pib_2000"]
print(f"\nβ = {beta:.4f}")
if beta < 0 and modelo.pvalues["log_pib_2000"] < 0.05:
    print("✅ Evidência de β-convergência (pobres crescem mais rápido)")
else:
    print("❌ Sem evidência de convergência")

# Gráfico
fig, ax = plt.subplots(figsize=(10, 6))
ax.scatter(df["log_pib_2000"], df["crescimento"], alpha=0.6, edgecolors="black")
ax.plot(df["log_pib_2000"], modelo.fittedvalues, color="red", linestyle="--")

ax.set_xlabel("Log PIB per capita (2000)")
ax.set_ylabel("Crescimento médio anual (%) 2000-2020")
ax.set_title("β-Convergência: Países Pobres Crescem Mais?")
ax.grid(True, alpha=0.3)
fig.tight_layout()
fig.savefig("convergencia.png", dpi=150)
```

=== Desafio
<desafio-1>
Substitua os dados simulados por dados reais do WDI
(`NY.GDP.PCAP.PP.KD`, 2000 vs.~2020, para os mesmos países). Refaça a
regressão e verifique se a hipótese de convergência absoluta se
sustenta. Em seguida, adicione uma variável de controle (ex: taxa de
investimento ou escolaridade média) e compare o β estimado antes e
depois --- a magnitude aumentou ou diminuiu?

#line()

== Projeto 3 --- Curva de Kuznets Ambiental
<projeto-3-curva-de-kuznets-ambiental>
=== Objetivo
<objetivo-2>
Testar se a relação entre PIB per capita e emissões de CO₂ tem forma de
U invertido.

=== Fundamentação teórica
<fundamentação-teórica-2>
A Curva de Kuznets Ambiental (Environmental Kuznets Curve, EKC) é uma
hipótese proposta por Grossman e Krueger (1991, 1995), a partir de uma
analogia com a curva de Kuznets original (Kuznets, 1955, sobre
desigualdade de renda e desenvolvimento), segundo a qual a relação entre
renda per capita e degradação ambiental tem formato de #strong[U
invertido]: a poluição cresce nos estágios iniciais de industrialização
e cai depois que o país atinge um determinado nível de renda.

#strong[Os três canais por trás da hipótese] (Grossman & Krueger, 1995;
Panayotou, 2000):

+ #strong[Efeito escala] (#emph[scale effect]): mais produção, tudo o
  mais constante, significa mais uso de recursos e mais poluição ---
  efeito positivo sobre emissões.
+ #strong[Efeito composição] (#emph[composition effect]): à medida que a
  renda cresce, a estrutura da economia se desloca de agricultura para
  indústria (mais poluente) e depois para serviços (menos poluente).
+ #strong[Efeito técnica] (#emph[technique effect]): renda mais alta
  financia tecnologias mais limpas e gera demanda por regulação
  ambiental mais rígida --- qualidade ambiental é, em parte, um bem de
  luxo, com elasticidade-renda da demanda por regulação maior que 1.

A hipótese do U invertido é que, em baixa renda, o efeito escala domina;
em renda mais alta, composição e técnica passam a dominar, revertendo a
trajetória.

#strong[Especificação econométrica.] A forma funcional padrão é uma
regressão quadrática de emissões per capita sobre o PIB per capita (o
script usa níveis, não logs, mas a lógica é idêntica):

$ upright("CO")_2 = beta_0 + beta_1 thin upright("PIB") + beta_2 thin upright("PIB")^2 + epsilon $

A hipótese de U-invertido corresponde a $beta_1 > 0$ e $beta_2 < 0$. O
#strong[ponto de virada] --- o nível de renda em que as emissões atingem
o máximo --- vem da condição de primeira ordem:

$ frac(d thin upright("CO")_2, d thin upright("PIB")) = beta_1 + 2 beta_2 thin upright("PIB") = 0 quad arrow.r.double quad upright("PIB")^(*) = - frac(beta_1, 2 beta_2) $

É esse cálculo que o script faz com `turning_point = -b1 / (2*b2)`. A
condição de segunda ordem ($beta_2 < 0$) garante que o ponto crítico é
um #strong[máximo] --- se $beta_2 > 0$, a curva teria formato de U (não
invertido), contradizendo a hipótese.

#strong[Log-log vs.~níveis.] O script do Projeto 3 estima a
especificação em #strong[níveis] (PIB e CO₂ em suas unidades originais),
que é a forma mais simples de visualizar o U invertido diretamente num
gráfico de dispersão. Grande parte da literatura empírica, porém, estima
em #strong[log-log] ---
$ln\(upright("CO")_2\)= beta_0 + beta_1 ln\(upright("PIB")\)+ beta_2\[ln\(upright("PIB")\)\]^2+ epsilon$
--- porque essa forma funcional lida melhor com a distribuição
tipicamente assimétrica (poucos países muito ricos, muitos países
pobres) tanto do PIB per capita quanto das emissões, e os coeficientes
passam a ter interpretação direta de elasticidade. O ponto de virada,
nesse caso, é obtido da mesma forma (derivada igual a zero), mas
expresso em log do PIB --- depois é preciso desfazer o log
($e^(ln\(upright("PIB")^(*)\))$) para reportar o valor em dólares.

#strong[Críticas à hipótese.] A EKC é um dos resultados empíricos mais
contestados da economia ambiental: (i) parte da redução de emissões em
países ricos reflete deslocamento da produção poluente para países
pobres (#emph[pollution haven]), não redução real da pegada de consumo;
(ii) a EKC tem suporte mais forte para poluentes locais e imediatos
(SO₂, particulados) do que para CO₂, um poluente global cujo custo é
diluído entre todos os países; (iii) o ponto de virada estimado costuma
ser muito sensível à amostra de países e ao período usado, tornando
arriscada qualquer extrapolação para prever o comportamento futuro de
países ainda no ramo ascendente.

=== Antes de rodar
<antes-de-rodar-2>
- Para qual tipo de poluente (CO₂ global vs.~poluição do ar local) você
  esperaria uma curva de Kuznets mais nítida, dado os incentivos
  políticos discutidos acima?
- Os dados simulados já embutem uma relação quadrática
  (`0.5*pib - 0.000006*pib**2`). Calcule à mão o ponto de virada teórico
  exato a partir desses coeficientes antes de rodar a regressão --- o
  valor estimado deveria ser idêntico ou apenas parecido? Por quê?

```python
import numpy as np
import pandas as pd
import statsmodels.api as sm
import matplotlib.pyplot as plt

np.random.seed(42)
n = 100

# Simular dados com relação U-invertido
pib_per_capita = np.random.uniform(1000, 50000, n)
# emissões = termo_quadratico com máximo no meio
emissao = 0.5 * pib_per_capita - 0.000006 * pib_per_capita**2
emissao += np.random.normal(0, 10, n)  # ruído
emissao = np.maximum(emissao, 0)  # não negativa

df = pd.DataFrame({"pib": pib_per_capita, "co2": emissao})
df["pib2"] = df["pib"] ** 2
df["log_pib"] = np.log(df["pib"])

# Modelo: CO₂ = β₀ + β₁*PIB + β₂*PIB²
X = sm.add_constant(df[["pib", "pib2"]])
y = df["co2"]

modelo = sm.OLS(y, X).fit()
print(modelo.summary())

b1 = modelo.params["pib"]
b2 = modelo.params["pib2"]

if b1 > 0 and b2 < 0:
    # Ponto de virada
    turning_point = -b1 / (2 * b2)
    print(f"\nPonto de virada do PIB per capita: ${turning_point:,.0f}")
    print("✅ Evidência de Curva de Kuznets Ambiental")
else:
    print("❌ Sem evidência de U-invertido")

# Gráfico
fig, ax = plt.subplots(figsize=(10, 6))
ax.scatter(df["pib"], df["co2"], alpha=0.5, edgecolors="black")

# Linha ajustada
x_range = np.linspace(df["pib"].min(), df["pib"].max(), 100)
y_pred = modelo.params["const"] + modelo.params["pib"] * x_range + \
         modelo.params["pib2"] * x_range**2
ax.plot(x_range, y_pred, color="red", linewidth=2, label="Ajuste quadrático")

ax.axvline(turning_point, color="gray", linestyle=":", label=f"Ponto virada: ${turning_point:,.0f}")
ax.legend()
ax.set_xlabel("PIB per capita (US$)")
ax.set_ylabel("Emissões de CO₂ per capita")
ax.set_title("Curva de Kuznets Ambiental")
ax.grid(True, alpha=0.3)
fig.tight_layout()
fig.savefig("kuznets.png", dpi=150)
```

=== Desafio
<desafio-2>
Substitua os dados simulados por uma série real (ex: emissões de CO₂ per
capita vs.~PIB per capita PPC de um painel de países, disponível no Our
World in Data ou no WDI). O formato de U invertido se mantém com dados
reais? Teste também uma especificação cúbica
($beta_3 thin upright("PIB")^3$) e verifique se ela é estatisticamente
significativa --- isso mudaria sua conclusão sobre a forma da curva?

#line()

== Projeto 4 --- Modelo de Previsão de Inflação
<projeto-4-modelo-de-previsão-de-inflação>
=== Objetivo
<objetivo-3>
Criar um modelo SARIMA que prevê o IPCA para os próximos 12 meses.

=== Fundamentação teórica
<fundamentação-teórica-3>
Prever uma série temporal como o IPCA é fundamentalmente diferente de
rodar uma regressão de corte transversal (Projetos 2 e 3): aqui a única
"variável explicativa" disponível é o próprio passado da série, e a
metodologia dominante é a abordagem Box-Jenkins, formalizada nos modelos
ARIMA (AutoRegressive Integrated Moving Average) e sua extensão sazonal,
SARIMA.

#strong[Os três componentes de um ARIMA(p,d,q).]

- #strong[AR(p) --- autorregressivo:] o valor atual é combinação linear
  de seus próprios $p$ valores passados,
  $ y_t = c + phi.alt_1 y_(t - 1) + phi.alt_2 y_(t - 2) + dots.h + phi.alt_p y_(t - p) + epsilon_t $
- #strong[I(d) --- integração:] número de diferenciações
  ($Delta y_t = y_t - y_(t - 1)$) necessárias até a série se tornar
  estacionária.
- #strong[MA(q) --- médias móveis:] o valor atual depende de erros
  (choques) passados, não de valores passados,
  $ y_t = c + epsilon_t + theta_1 epsilon_(t - 1) + dots.h + theta_q epsilon_(t - q) $

Um SARIMA$\(p\,d\,q\)\(P\,D\,Q\)_s$ adiciona uma estrutura sazonal
análoga, operando sobre múltiplos do período sazonal $s$ (aqui $s = 12$,
sazonalidade anual em dados mensais --- por exemplo, reajustes
concentrados em determinados meses).

#strong[Identificando as ordens (p, q): ACF e PACF.] Antes de
simplesmente "chutar" $\(1\,d\,1\)\(1\,1\,1\,12\)$ como o script faz por
conveniência didática, a metodologia Box-Jenkins clássica identifica $p$
e $q$ examinando dois gráficos da série já estacionária: a
#strong[função de autocorrelação] (ACF),
$rho_k = upright("Corr")\(y_t\,y_(t - k)\)$, e a #strong[função de
autocorrelação parcial] (PACF), que mede a correlação entre $y_t$ e
$y_(t - k)$ #strong[líquida] do efeito das defasagens intermediárias
$y_(t - 1)\,dots.h\,y_(t - k + 1)$. A regra prática: um processo AR(p)
puro tem PACF que "corta" abruptamente após a defasagem $p$ (e ACF que
decai geometricamente); um processo MA(q) puro tem o padrão oposto ---
ACF corta após $q$, PACF decai geometricamente. Na prática moderna, é
mais comum comparar vários modelos candidatos pelo critério de
informação de Akaike (AIC) ou Bayesiano (BIC), que penalizam o ganho de
ajuste pelo número de parâmetros --- e escolher a especificação com
menor critério, em vez de inspecionar ACF/PACF visualmente a cada série.
Em código, gerar os dois gráficos é direto:

```python
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
import matplotlib.pyplot as plt

fig, axes = plt.subplots(1, 2, figsize=(12, 4))
plot_acf(serie.dropna(), lags=24, ax=axes[0])
plot_pacf(serie.dropna(), lags=24, ax=axes[1])
axes[0].set_title("ACF - IPCA mensal")
axes[1].set_title("PACF - IPCA mensal")
fig.tight_layout()
fig.savefig("acf_pacf_ipca.png", dpi=150)
```

#strong[Por que testar estacionariedade antes de tudo: o teste ADF.] Um
modelo ARIMA só é bem definido sobre uma série estacionária (média e
variância constantes no tempo, autocovariância dependendo apenas da
defasagem). O teste Aumentado de Dickey-Fuller (ADF) testa a hipótese
nula de #strong[raiz unitária] (não estacionariedade) contra a
alternativa de estacionariedade, a partir da regressão:

$ Delta y_t = alpha + rho thin y_(t - 1) + sum_(i = 1)^k delta_i thin Delta y_(t - i) + epsilon_t $

A hipótese nula é $H_0 : rho = 0$\; rejeitar $H_0$ (p-valor baixo) é
evidência de estacionariedade. A estatística de teste sob $H_0$
#strong[não] segue uma distribuição t-Student usual --- segue a
distribuição não-padrão de Dickey-Fuller, motivo pelo qual `adfuller()`
usa valores críticos tabelados separadamente.

#strong[Por que a taxa de inflação (e não o índice de preços em nível)
costuma já ser estacionária.] Séries de preços em nível têm tendência e,
portanto, raiz unitária --- mas a taxa de inflação mensal, que já é uma
variação percentual, frequentemente é estacionária em torno de uma média
(ou próxima disso), o que explica por que o teste do script é aplicado
sobre o IPCA mensal diretamente.

#strong[Avaliação fora da amostra.] Separar treino/teste é essencial
porque um modelo pode se ajustar muito bem aos dados de estimação
(overfitting) e ainda assim prever mal o futuro. As duas métricas usadas
respondem perguntas ligeiramente diferentes:

$ upright("MAE") = 1 / n sum_(t = 1)^n\|y_t - hat(y)_t\|#h(2em) upright("MAPE") = 100 / n sum_(t = 1)^n lr(|frac(y_t - hat(y)_t, y_t)|) $

MAE está na mesma unidade da série (pontos percentuais de IPCA); MAPE é
adimensional (%), o que facilita comparar séries de escalas diferentes,
mas se torna instável quando $y_t$ está próximo de zero --- um problema
real ao prever IPCA mensal, que ocasionalmente passa perto de 0%.

=== Antes de rodar
<antes-de-rodar-3>
- Você espera que a série de IPCA mensal (taxa mês a mês, não o índice
  acumulado) seja estacionária ou não? Justifique com a definição de
  estacionariedade.
- Por que faz mais sentido reservar os últimos 12 meses como teste do
  que escolher 12 meses aleatórios no meio da amostra?

```python
from bcb import sgs
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from statsmodels.tsa.statespace.sarimax import SARIMAX
from statsmodels.tsa.stattools import adfuller
import warnings
warnings.filterwarnings("ignore")

# 1. DADOS
ipca = sgs.get({"IPCA": 433}, start="2005-01-01")
serie = ipca["IPCA"]

# 2. TESTE DE ESTACIONARIEDADE
result = adfuller(serie.dropna())
print(f"ADF p-valor: {result[1]:.4f}")
if result[1] > 0.05:
    d = 1
    print("Série não estacionária → diferenciando (d=1)")
else:
    d = 0
    print("Série estacionária (d=0)")

# 3. SEPARAR TREINO/TESTE
train = serie[:-12]
test = serie[-12:]

# 4. SARIMA
# Ordem: (p, d, q) x (P, D, Q, s)
# s=12 para sazonalidade anual
modelo = SARIMAX(train,
                 order=(1, d, 1),
                 seasonal_order=(1, 1, 1, 12),
                 enforce_stationarity=False,
                 enforce_invertibility=False)

resultado = modelo.fit(disp=False)
print(resultado.summary())

# 5. PREVISÃO
forecast = resultado.forecast(steps=12)

# 6. AVALIAÇÃO
from sklearn.metrics import mean_absolute_error, mean_absolute_percentage_error

mae = mean_absolute_error(test, forecast)
mape = mean_absolute_percentage_error(test, forecast)

print(f"\n📊 AVALIAÇÃO DO MODELO")
print(f"Erro médio absoluto (MAE): {mae:.2f} pp")
print(f"Erro percentual (MAPE): {mape:.2f}%")

# 7. GRÁFICO
fig, ax = plt.subplots(figsize=(12, 5))
ax.plot(train.index[-60:], train[-60:], label="Histórico", linewidth=1.5)
ax.plot(test.index, test, label="Real", color="green", linewidth=1.5)
ax.plot(forecast.index, forecast, label="Previsão", color="red", linestyle="--", linewidth=1.5)
ax.fill_between(forecast.index,
                resultado.get_forecast(12).conf_int().iloc[:, 0],
                resultado.get_forecast(12).conf_int().iloc[:, 1],
                alpha=0.2, color="red", label="IC 95%")
ax.legend()
ax.set_title("Previsão IPCA - SARIMA(1,1,1)(1,1,1,12)")
ax.set_ylabel("IPCA mensal (%)")
ax.grid(True, alpha=0.3)
fig.tight_layout()
fig.savefig("previsao_ipca.png", dpi=150)
plt.close()

print("\n📈 Gráfico salvo: previsao_ipca.png")
print("\nPrevisões:")
for data, valor in zip(forecast.index, forecast.values):
    print(f"  {data.date()}: {valor:.2f}%")
```

=== Desafio
<desafio-3>
Compare o SARIMA do script com um modelo auto-selecionado (ex:
`pmdarima.auto_arima`) e com um modelo ingênuo de referência
(#emph[naive forecast], prever que o próximo valor será igual à média
dos últimos 12 meses). O SARIMA supera o modelo ingênuo em MAE/MAPE fora
da amostra? Um modelo sofisticado que não supera uma referência simples
é um resultado importante --- não descarte essa possibilidade.

#line()

== Projeto 5 --- Regra de Taylor
<projeto-5-regra-de-taylor>
=== Objetivo
<objetivo-4>
Estimar a regra de Taylor para o Brasil: SELIC resposta à inflação e ao
hiato do produto.

=== Fundamentação teórica
<fundamentação-teórica-4>
A regra de Taylor (Taylor, 1993) é a formalização mais influente de como
um banco central deveria (ou efetivamente costuma) ajustar sua taxa de
juros de curto prazo em resposta a desvios da inflação em relação à meta
e do produto em relação ao seu potencial:

$ i_t = r^(*) + pi_t + phi.alt_pi\(pi_t - pi^(*)\)+ phi.alt_y thin\(y_t - y_t^(*)\) $

onde $i_t$ é a taxa de juros nominal de curto prazo (a SELIC), $r^(*)$ é
a taxa de juros real de equilíbrio ("neutra"), $pi_t$ é a inflação
corrente (ou esperada) e $pi^(*)$ a meta, $y_t - y_t^(*)$ é o hiato do
produto (PIB efetivo menos potencial, em %), e $phi.alt_pi$, $phi.alt_y$
são os coeficientes de reação do banco central. Taylor (1993) propôs
$phi.alt_pi = 0\,5$ e $phi.alt_y = 0\,5$ com base em dados dos EUA ---
não derivados de otimização formal, mas como regra simples que descrevia
bem o Fed da época.

#strong[O Princípio de Taylor.] Para a regra estabilizar a inflação
(evitar espirais auto-realizáveis), o banco central precisa reagir
#emph[mais que proporcionalmente] a desvios da inflação:
$phi.alt_pi > 1$. A intuição: se $phi.alt_pi < 1$, a SELIC nominal sobe
menos que a própria inflação quando esta se acelera --- o juro
#strong[real] cai, estimulando ainda mais demanda e realimentando a
inflação (instabilidade). Com $phi.alt_pi > 1$, o juro real sobe quando
a inflação sobe, contendo a demanda. Esse resultado é conhecido como
#strong[Princípio de Taylor].

#strong[Suavização da taxa de juros.] Bancos centrais raramente saltam
para o nível "ótimo" segundo a regra --- movem-se gradualmente, em
passos pequenos e persistentes. Isso é capturado acrescentando a taxa
defasada como regressor:

$ i_t =\(1 - rho\)thin i_t^(upright("regra")) + rho thin i_(t - 1) + eta_t $

com $rho in\(0\,1\)$ medindo o grau de suavização. O script cria
`selic_lag1` para permitir esse tipo de especificação, embora a
regressão principal, por simplicidade didática, estime a versão sem
suavização.

#strong[O filtro Hodrick-Prescott (HP) e o hiato do produto.] O hiato
não é diretamente observável --- requer estimar o PIB "potencial"
(tendência de longo prazo). O filtro HP decompõe $y_t$ em tendência
$tau_t$ e ciclo $c_t = y_t - tau_t$, minimizando:

$ min_({ tau_t }) med sum_(t = 1)^T\(y_t - tau_t\)^2+ lambda sum_(t = 2)^(T - 1) #scale(x: 120%, y: 120%)[\[]\(tau_(t + 1) - tau_t\)-\(tau_t - tau_(t - 1)\)#scale(x: 120%, y: 120%)[\]]^2 $

O primeiro termo penaliza o ciclo; o segundo penaliza mudanças na
inclinação da tendência. O parâmetro $lambda$ controla o trade-off:
$lambda arrow.r 0$ faz a tendência seguir os dados perfeitamente;
$lambda arrow.r oo$ força uma tendência linear. O valor $lambda = 14400$
do script é a convenção de Hodrick e Prescott (1997) para dados
#strong[mensais] (para trimestrais, a convenção é $lambda = 1600$\; para
anuais, $lambda = 100$) --- um detalhe frequentemente esquecido que muda
substancialmente o resultado se aplicado com o $lambda$ errado.

#strong[Uma ressalva conhecida.] O filtro HP sofre de viés de borda
(#emph[end-point bias]): a tendência estimada nos últimos períodos da
amostra é instável e tende a ser revisada para trás à medida que novos
dados chegam --- o hiato estimado para o mês mais recente é o menos
confiável de toda a série, um problema relevante ao interpretar a regra
de Taylor em tempo real.

#strong[Dados em tempo real vs.~dados revisados.] Uma crítica influente
de Orphanides (2001) mostrou que regras de Taylor estimadas com dados
#strong[revisados] (como os que o script baixa hoje, já ajustados por
revisões posteriores do IBGE/BCB) podem indicar decisões de política
monetária muito diferentes das que o banco central via #strong[no
momento da decisão], com os dados preliminares então disponíveis. Isso é
especialmente relevante para o hiato do produto: a estimativa do PIB
potencial em tempo real é sistematicamente menos precisa do que a
estimativa feita anos depois, quando mais dados estão disponíveis --- um
lembrete de que "replicar" a regra de Taylor de um período passado
usando dados de hoje não é o mesmo que reconstruir a informação que o
Copom realmente tinha em mãos.

=== Antes de rodar
<antes-de-rodar-4>
- Qual sinal você espera para o coeficiente de `ipca_acum` na regra
  estimada? Segundo o Princípio de Taylor, que magnitude sinalizaria uma
  política monetária estabilizadora?
- Por que a escolha de $lambda = 14400$ (em vez de 1600) importa neste
  script especificamente? O que aconteceria com o hiato estimado se você
  usasse o $lambda$ errado para a periodicidade dos dados?

```python
from bcb import sgs
import pandas as pd
import statsmodels.api as sm
import matplotlib.pyplot as plt

# SELIC (11), IPCA acum 12m (13522), PIB (4380)
selic = sgs.get({"SELIC": 11}, start="2005-01-01")
ipca_acum = sgs.get({"IPCA_ACUM": 13522}, start="2005-01-01")
pib = sgs.get({"PIB": 4380}, start="2005-01-01")

df = pd.merge(selic, ipca_acum, on="Date")
df = pd.merge(df, pib, on="Date").dropna()
df.columns = ["selic", "ipca_acum", "pib"]

# Hiato do produto (desvio da tendência)
# Usando filtro HP
from statsmodels.tsa.filters.hp_filter import hpfilter
cycle, trend = hpfilter(df["pib"], lamb=14400)
df["hiato"] = cycle

# SELIC defasada (suavização)
df["selic_lag1"] = df["selic"].shift(1)

df = df.dropna()

# Regra de Taylor: SELIC = β₀ + β₁*inflação + β₂*hiato
X = sm.add_constant(df[["ipca_acum", "hiato"]])
y = df["selic"]

modelo = sm.OLS(y, X).fit()
print("REGRAS DE TAYLOR - BRASIL")
print("=" * 40)
print(modelo.summary())

# SELIC prevista vs real
df["selic_prevista"] = modelo.fittedvalues

fig, ax = plt.subplots(figsize=(12, 5))
ax.plot(df.index, df["selic"], label="SELIC real", color="navy", linewidth=1.5)
ax.plot(df.index, df["selic_prevista"], label="SELIC prevista (Taylor)",
        color="crimson", linestyle="--", linewidth=1.5)
ax.legend()
ax.set_title("Regra de Taylor - Brasil")
ax.set_ylabel("SELIC (%)")
ax.grid(True, alpha=0.3)
fig.tight_layout()
fig.savefig("regra_taylor.png", dpi=150)
plt.close()

print("\n📈 Gráfico salvo: regra_taylor.png")
```

=== Desafio
<desafio-4>
Adicione um termo de suavização (`selic_lag1`) à regressão e reestime. O
coeficiente $rho$ implícito é alto ou baixo? Compare o ajuste (R²) do
modelo com e sem suavização, e discuta se a regra estimada é mais
compatível com um Copom que reage rápido ou gradualmente.

#line()

== Projeto 6 --- Análise de Crise Cambial
<projeto-6-análise-de-crise-cambial>
=== Objetivo
<objetivo-5>
Identificar períodos de crise cambial usando pressão no mercado de
câmbio.

=== Fundamentação teórica
<fundamentação-teórica-5>
Crises cambiais são momentos em que a moeda de um país sofre ataque
especulativo ou desvalorização abrupta, forçando o banco central a
escolher entre deixar a moeda depreciar ou queimar reservas
internacionais para defendê-la. A dificuldade de identificar uma "crise"
objetivamente --- não existe um evento discreto e inequívoco --- motivou
a construção de índices contínuos de #strong[pressão no mercado de
câmbio] (Exchange Market Pressure, EMP), que capturam estresse cambial
mesmo quando o banco central evita uma desvalorização visível via
intervenção.

#strong[A lógica do índice EMP.] A ideia, de Girton e Roper (1977) e
refinada por Eichengreen, Rose e Wyplosz (1996), é que a pressão
especulativa contra uma moeda se manifesta de duas formas observáveis e
#emph[substitutas] do ponto de vista do banco central: (i)
desvalorização cambial efetiva, se ele deixa a moeda flutuar; ou (ii)
perda de reservas internacionais, se ele intervém vendendo dólares para
segurar o câmbio. Um índice que olhasse só para a variação cambial
subestimaria a pressão em episódios em que o banco central "aguentou o
tranco" gastando reservas. A formulação clássica combina as duas
variáveis:

$ upright("EMP")_t = frac(Delta e_t, e_(t - 1)) - 1 / sigma_(Delta r) dot.op frac(Delta r_t, r_(t - 1)) $

onde $e_t$ é a taxa de câmbio nominal e $r_t$ as reservas
internacionais. A normalização pelo desvio-padrão de cada componente é
necessária porque variações cambiais e de reservas têm escalas e
volatilidades muito diferentes --- sem ela, o componente mais volátil
dominaria o índice artificialmente. O script simplifica essa
normalização, dividindo apenas o termo de reservas pelo desvio-padrão da
própria série.

#strong[Definindo "crise" a partir de um índice contínuo.] Como o EMP é
uma variável contínua, é preciso uma regra para transformá-lo em evento
binário. A convenção mais usada (Eichengreen, Rose & Wyplosz, 1996;
Kaminsky & Reinhart, 1999) é marcar como crise qualquer observação que
ultrapasse a média histórica por uma margem de 1,5 a 3 desvios-padrão:

$ upright("Crise")_t = bb(1) [upright("EMP")_t > overline(upright("EMP")) + k dot.op sigma_(upright("EMP"))]\,#h(2em) k in\[1\,5\,thin 3\] $

O script usa $k = 2$ --- um parâmetro de julgamento, não um valor
"correto" derivado de teoria: $k$ menor identifica mais episódios
(inclusive falsos positivos); $k$ maior é mais conservador, mas pode
deixar passar crises reais.

#strong[Um exemplo numérico simplificado.] Suponha que, em um mês, o
câmbio se desvalorizou 3% ($Delta e\/e_(t - 1) = 0\,03$) enquanto as
reservas caíram 1% ($Delta r\/r_(t - 1) = - 0\,01$), e que o
desvio-padrão histórico da variação de reservas seja
$sigma_(Delta r) = 0\,02$ (2%). O índice fica
$upright("EMP") = 0\,03 - frac(1, 0\,02) times\(- 0\,01\)= 0\,03 + 0\,5 = 0\,53$,
um valor bem acima de um mês "normal" (em que ambos os componentes ficam
próximos de zero) --- ilustrando como uma queda de reservas
relativamente pequena, mas grande frente à sua própria volatilidade
histórica, pode contribuir tanto para o índice quanto uma desvalorização
cambial notável.

```python
def emp_simplificado(delta_e_pct, delta_r_pct, sigma_delta_r_pct):
    """Todos os argumentos em proporção (ex: 0.03 para 3%)."""
    return delta_e_pct - (delta_r_pct / sigma_delta_r_pct)

print(emp_simplificado(0.03, -0.01, 0.02))  # 0.53
```

#strong[Modelos teóricos de crise cambial (contexto).] A literatura
distingue três "gerações": #strong[primeira geração] (Krugman, 1979), em
que a crise resulta de fundamentos fiscais insustentáveis e o colapso do
câmbio fixo é previsível; #strong[segunda geração] (Obstfeld, 1994,
1996), em que a crise pode ocorrer mesmo com fundamentos razoáveis, por
#strong[múltiplos equilíbrios auto-realizáveis] (um ataque coordenado se
torna racional se investidores acreditam que outros vão atacar);
#strong[terceira geração] (Krugman, 1999, pós-crise asiática de 1997),
que incorpora fragilidade bancária e descasamento de moedas (dívida em
dólar, receita em moeda local) como canal adicional de instabilidade. O
índice EMP não distingue entre essas causas --- é uma ferramenta de
#strong[datação] de episódios de estresse, não um teste de qual modelo
está correto.

=== Antes de rodar
<antes-de-rodar-5>
- Quantos episódios de crise cambial brasileira você consegue
  identificar no período coberto pelos dados (desde 2000)? Você espera
  que o índice EMP capture esses episódios conhecidos?
- Se você aumentasse o limiar de $k = 2$ para $k = 3$ desvios-padrão, o
  número de períodos classificados como "crise" aumentaria ou
  diminuiria? Por quê?

```python
from bcb import sgs
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Câmbio (1) e Reservas (3546)
cambio = sgs.get({"CAMBIO": 1}, start="2000-01-01")
reservas = sgs.get({"RESERVAS": 3546}, start="2000-01-01")

df = pd.merge(cambio, reservas, on="Date").dropna()
df.columns = ["cambio", "reservas"]

# Variação cambial
df["cambio_var"] = df["cambio"].pct_change() * 100

# Índice de Pressão Cambial (EMP)
# Combina desvalorização cambial + perda de reservas
df["reservas_var"] = df["reservas"].pct_change() * 100
df["emp"] = df["cambio_var"] - df["reservas_var"] / df["reservas"].std()

# Identificar crises: EMP > 2 desvios padrão
threshold = df["emp"].mean() + 2 * df["emp"].std()
df["crise"] = df["emp"] > threshold

print(f"Períodos de crise cambial (EMP > {threshold:.1f}):")
crises = df[df["crise"]].index
for data in crises:
    print(f"  {data.date()}")

# Gráfico
fig, ax = plt.subplots(figsize=(12, 5))
ax.plot(df.index, df["emp"], color="steelblue", linewidth=1)
ax.axhline(threshold, color="red", linestyle="--", label=f"Limiar crise ({threshold:.1f})")
ax.fill_between(df.index, threshold, df["emp"].max(),
                where=df["crise"], color="red", alpha=0.3, label="Crise")
ax.legend()
ax.set_title("Índice de Pressão Cambial - Brasil")
ax.set_ylabel("EMP (desvios padrão)")
ax.grid(True, alpha=0.3)
fig.tight_layout()
fig.savefig("crise_cambial.png", dpi=150)
```

=== Desafio
<desafio-5>
Estenda o índice EMP para incluir o diferencial de juros (SELIC menos
Fed Funds) como terceiro componente, seguindo a formulação estendida de
Eichengreen, Rose e Wyplosz (1996). O número de crises identificadas
muda? Compare também os resultados usando $k = 1\,5$ e $k = 3$ e discuta
o trade-off entre falsos positivos e crises não detectadas.

#line()

== Projeto 7 --- TCC Estrutura Completa
<projeto-7-tcc-estrutura-completa>
Estrutura de um TCC em economia com Python:

```
meu_tcc/
├── dados/                  # Dados brutos (nunca modificados)
│   ├── bcb/               # Baixados do BCB
│   ├── ipea/              # Baixados do Ipeadata
│   └── externos/          # Banco Mundial, FMI
├── scripts/               # Código
│   ├── 01_baixar_dados.py
│   ├── 02_limpeza.py
│   ├── 03_analise_descritiva.py
│   ├── 04_modelos.py
│   └── 05_graficos.py
├── output/                # Resultados
│   ├── tabelas/
│   ├── graficos/
│   └── relatorio/
├── environment.yml        # Ambiente replicável
└── README.md
```

=== Fundamentação teórica
<fundamentação-teórica-6>
Um TCC (ou artigo de pesquisa) em economia aplicada normalmente evolui
de uma pergunta descritiva para uma tentativa de identificação causal, e
a estrutura de pastas acima reflete diretamente essa lógica: dados
brutos nunca são modificados (permitindo auditoria --- qualquer revisor
deveria conseguir refazer sua análise do zero a partir do dado
original), scripts são numerados na ordem de execução, e resultados são
exportados para tabelas e gráficos versionáveis.

#strong[Por que dados em painel, e não corte transversal ou série
temporal isolada.] O script-modelo estima tanto um OLS simples quanto um
modelo de efeitos fixos (`PanelOLS.from_formula(... + EntityEffects)`),
o que introduz uma questão central de dados em painel: como controlar
por características não observadas de cada unidade (país, estado, firma)
que são constantes no tempo mas afetam tanto a variável dependente
quanto os regressores. No modelo geral de painel,

$ y_(upright("it")) = beta' X_(upright("it")) + alpha_i + epsilon_(upright("it")) $

$alpha_i$ é o #strong[efeito individual não observado] (por exemplo,
qualidade institucional de um país, constante ano a ano). Se $alpha_i$
está correlacionado com algum regressor em $X_(upright("it"))$ --- o
caso mais comum e mais preocupante em economia ---, estimar por OLS
agrupado (#emph[pooled OLS], ignorando a estrutura de painel) produz
#strong[viés de variável omitida].

#strong[Efeitos fixos: eliminando $alpha_i$ por transformação.] O
estimador de efeitos fixos resolve isso subtraindo a média de cada
unidade ao longo do tempo (transformação #emph[within]):

$ y_(upright("it")) - macron(y)_i = beta'\(X_(upright("it")) - macron(X)_i\)+\(epsilon_(upright("it")) - macron(epsilon)_i\) $

Como $alpha_i$ é constante no tempo, ele desaparece na subtração
($macron(alpha)_i = alpha_i$) --- o preço é que qualquer variável
igualmente constante no tempo dentro de cada unidade (ex: um país que
não muda de continente) também é eliminada e não pode ser estimada.

#strong[Efeitos aleatórios e o teste de Hausman.] O estimador de efeitos
aleatórios trata $alpha_i$ como parte do erro (não o remove por
transformação), o que é mais eficiente --- mas só é não viesado sob a
hipótese, frequentemente implausível em economia, de que $alpha_i$ não é
correlacionado com os regressores. O teste de especificação padrão para
decidir entre os dois é o #strong[teste de Hausman] (Hausman, 1978):

$ H =\(hat(beta)_(upright("FE")) - hat(beta)_(upright("RE"))\)'#scale(x: 120%, y: 120%)[\[] upright("Var")\(hat(beta)_(upright("FE"))\)- upright("Var")\(hat(beta)_(upright("RE"))\)#scale(x: 120%, y: 120%)[\]]^(- 1)\(hat(beta)_(upright("FE")) - hat(beta)_(upright("RE"))\)tilde.op chi_k^2 $

Sob $H_0$ (efeitos aleatórios consistente), os dois estimadores deveriam
ser parecidos; uma diferença estatisticamente grande rejeita $H_0$ e
recomenda efeitos fixos, apesar do custo de eficiência.

#strong[Erros-padrão clusterizados.] Mesmo depois de escolher entre
efeitos fixos e aleatórios, um problema separado costuma passar
despercebido em TCCs: os erros $epsilon_(upright("it"))$ de uma mesma
unidade $i$ ao longo do tempo tendem a ser correlacionados entre si
(autocorrelação serial dentro de cada país/firma), o que viola a
hipótese de erros independentes do OLS clássico e faz os erros-padrão
"de fábrica" subestimarem a incerteza real --- inflando artificialmente
a significância estatística. A correção padrão é usar erros-padrão
#strong[clusterizados por entidade]
(`.fit(cov_type="clustered", cluster_entity=True)` no `linearmodels`),
que permitem correlação arbitrária dentro de cada cluster (cada país,
por exemplo) sem exigir que se conheça a estrutura exata dessa
correlação. Reportar um modelo de efeitos fixos sem esse ajuste é um dos
erros metodológicos mais comuns --- e mais fáceis de corrigir --- em
TCCs com dados em painel.

#strong[Correlação ainda não é causalidade.] Mesmo com efeitos fixos bem
especificados, o modelo só produz estimativas causais válidas se não
houver viés de variável omitida #strong[variante no tempo], nem
causalidade reversa (educação causa crescimento, ou países que já
crescem mais investem mais em educação?). Um TCC rigoroso discute essas
ameaças à identificação explicitamente na seção de limitações --- não
como formalidade, mas porque é exatamente o que um orientador ou
parecerista vai procurar.

#strong[Robustez como parte do método, não como apêndice.] Um resultado
empírico único, de uma única especificação, convence pouco --- inclusive
porque a escolha de variáveis de controle, amostra e forma funcional
envolve graus de liberdade que o próprio pesquisador tem, o que a
literatura recente chama de "jardim de caminhos que se bifurcam"
(#emph[garden of forking paths], Gelman & Loken, 2013) ou, na versão
mais conhecida em economia, os "muitos universos" de especificações
possíveis (#emph[specification curve], Simonsohn et al., 2020). A
prática recomendada --- e o que um bom TCC deveria reportar, mesmo que
resumidamente --- é testar se o resultado central se mantém sob
especificações alternativas razoáveis: outro conjunto de controles,
outra janela temporal, outra forma funcional (níveis vs.~logs),
erros-padrão clusterizados de formas diferentes. Se o coeficiente de
interesse muda de sinal ou perde significância nessas variações, isso é
informação tão importante quanto o resultado da especificação preferida.

=== Antes de rodar
<antes-de-rodar-6>
- Quais variáveis do seu tema de TCC são plausivelmente correlacionadas
  com um efeito não observado de país/firma/indivíduo ($alpha_i$)? Isso
  te faz preferir efeitos fixos a efeitos aleatórios, ou o contrário?
- Se o coeficiente de uma variável de interesse mudar substancialmente
  entre o OLS agrupado e o modelo de efeitos fixos, o que isso sugere
  sobre a importância do viés de variável omitida no seu caso?

=== Template de script de TCC
<template-de-script-de-tcc>
```python
"""
TCC: [TÍTULO]
Autor: [SEU NOME]
Script: 04_modelos.py
Descrição: Estima modelos econométricos
"""

import pandas as pd
import numpy as np
import statsmodels.api as sm
from linearmodels.panel import PanelOLS
import warnings
warnings.filterwarnings("ignore")

# Configuração
np.random.seed(42)
SAVE_TABLES = True

# 1. CARREGAR DADOS
df = pd.read_csv("dados/painel_paises.csv", decimal=",")
print(f"Dados carregados: {df.shape[0]} observações, {df.shape[1]} variáveis")

# 2. ESTATÍSTICAS DESCRITIVAS
desc = df.describe().round(3)
if SAVE_TABLES:
    desc.to_csv("output/tabelas/descritivas.csv", decimal=",")
print("\nEstatísticas descritivas salvas")

# 3. MODELO BASE
X = sm.add_constant(df[["inflacao", "educacao", "investimento"]])
y = df["crescimento_pib"]

modelo_base = sm.OLS(y, X).fit()
print("\nMODELO BASE (OLS)")
print("=" * 50)
print(modelo_base.summary())

# 4. MODELO COM EFEITOS FIXOS
df_panel = df.set_index(["pais", "ano"])
modelo_fe = PanelOLS.from_formula(
    "crescimento_pib ~ inflacao + educacao + investimento + EntityEffects",
    data=df_panel
).fit()

print("\nMODELO EFEITOS FIXOS")
print("=" * 50)
print(modelo_fe)

# 5. SALVAR RESULTADOS
# Coeficientes em CSV
coefs = pd.DataFrame({
    "variavel": modelo_fe.params.index,
    "coeficiente": modelo_fe.params.values,
    "p_valor": modelo_fe.pvalues.values,
    "erro_padrao": modelo_fe.std_errors.values
})
coefs.to_csv("output/tabelas/resultados_fe.csv", index=False, decimal=",")
print("\nResultados salvos em output/tabelas/")

print("\n✅ Modelos estimados com sucesso!")
```

=== Desafio
<desafio-6>
Adicione ao template um teste de Hausman comparando o modelo de efeitos
fixos com um modelo de efeitos aleatórios (`RandomEffects` do
`linearmodels`) para os mesmos dados. Com base no resultado, justifique
por escrito (como faria na seção de metodologia de um TCC) qual dos dois
modelos você reportaria como principal.

#line()

== Checklist para seu TCC
<checklist-para-seu-tcc>
- ☐ Dados brutos salvos em `dados/` (nunca modificá-los)
- ☐ Scripts numerados na ordem de execução
- ☐ Mesma seed (`np.random.seed(42)`) em todos os scripts
- ☐ Tabelas exportadas para CSV com `decimal=","`
- ☐ Gráficos em PNG 300dpi
- ☐ Ambiente replicável (`environment.yml` ou `requirements.txt`)
- ☐ README explicando como reproduzir

#line()

== Projeto 8 --- Desafios Adicionais para Executar
<projeto-8-desafios-adicionais-para-executar>
Diferente dos Projetos 1 a 7, esta seção não é um projeto completo --- é
uma lista de exercícios pontuais, mais curtos, cada um reforçando um
conceito específico das Apostilas 1 a 4, aplicado a dados reais.
#strong[Nenhuma solução é apresentada aqui]: o objetivo é que você
escreva o código do zero, execute, confira o resultado contra sua
própria expectativa (formada na seção "Antes de rodar" de cada projeto
anterior) e só então avance para o próximo. Se travar, revisite o
capítulo indicado entre parênteses antes de espiar qualquer solução de
terceiros.

+ #strong[Fisher exato vs.~aproximado em série longa.] Baixe a SELIC e o
  IPCA acumulado em 12 meses via `bcb.sgs` desde 2000. Calcule o juro
  real pela aproximação simples (`selic - ipca`) e pela fórmula exata de
  Fisher (Apostila 1, Capítulo 5) para toda a série. Plote a diferença
  entre as duas ao longo do tempo --- em quais períodos (alta ou baixa
  inflação) a diferença é maior?

+ #strong[Limpeza de dado "sujo".] Baixe uma tabela do IPEADATA ou do
  SIDRA/IBGE em formato bruto (números brasileiros com `.` de milhar e
  `,` decimal). Escreva uma função que limpe a coluna de valores e
  converta para `float`, reaproveitando o raciocínio "limpar → ajustar →
  converter" da Apostila 1 (Capítulo 4).

+ #strong[Aliasing em um pipeline real.] Carregue uma série do BCB em um
  DataFrame, crie uma "cópia" sem usar `.copy()` e aplique uma
  transformação (ex: preencher valores ausentes). Mostre que a série
  original também foi alterada, e depois corrija usando `.copy()`
  (Apostila 1, Capítulo 7; Apostila 2).

+ #strong[Outliers em série real.] Usando a série de câmbio diário (BCB,
  código 1) desde 1999 (inclui o regime de bandas cambiais pré-1999 se
  você estender o período), identifique observações que sejam outliers
  pelo critério de desvio-padrão (ex: variação diária acima de 3
  desvios-padrão da série) e liste as datas --- elas coincidem com
  eventos macroeconômicos conhecidos?

+ #strong[Estatísticas descritivas comparadas.] Baixe o IPCA mensal para
  dois subperíodos de sua escolha (ex: regime de metas de inflação em
  dois governos diferentes) e compare média, desvio-padrão e assimetria
  (`.skew()`) entre eles. A volatilidade da inflação foi diferente entre
  os dois períodos?

+ #strong[Regressão simples com dado real (não simulado).] Refaça a
  regressão do Projeto 2 (β-convergência) substituindo os dados
  simulados por dados reais do WDI para pelo menos 15 países de sua
  escolha. Reporte se o sinal e a significância do β mudam em relação ao
  exemplo simulado do projeto.

+ #strong[Teste de estacionariedade em três séries diferentes.] Aplique
  o teste ADF (Apostila 4) a três séries do BCB com características
  distintas: uma taxa de juros (deveria ser mais persistente), uma
  variação percentual (deveria ser mais estacionária) e um índice de
  preços em nível (deveria ter raiz unitária clara). Compare os
  p-valores e explique o padrão encontrado.

+ #strong[Curva de Phillips com dados atualizados.] Reestime a Curva de
  Phillips (Apostila 4, Capítulo 4) usando os dados mais recentes
  disponíveis de desemprego (PNAD Contínua) e inflação. O trade-off
  (inclinação negativa) se mantém na amostra mais recente?

+ #strong[Visualização de múltiplas séries com eixos duplos.] Usando a
  técnica de eixo duplo (`ax.twinx()`, Apostila 3), plote SELIC e câmbio
  na mesma figura com escalas diferentes. Adicione uma linha vertical
  (`axvline`) marcando o início de um ciclo de aperto monetário à sua
  escolha.

+ #strong[Painel simples com efeitos fixos em dados reais.] Monte um
  pequeno painel (ex: PIB per capita e escolaridade de 10 estados
  brasileiros ao longo de 5 anos, via IBGE/SIDRA) e estime um modelo de
  efeitos fixos por entidade (Projeto 7). Compare com a versão sem
  efeitos fixos (`pooled OLS`) --- o coeficiente de interesse muda de
  sinal ou magnitude?

+ #strong[Índice de pressão cambial para outro país.] Adapte o índice
  EMP do Projeto 6 para outro país emergente (ex: Argentina, Turquia)
  usando série de câmbio e reservas de fontes públicas (FMI IFS, banco
  central local). Os períodos de crise identificados coincidem com
  eventos históricos conhecidos desse país?

+ #strong[Regra de Taylor com suavização.] A partir do Projeto 5, estime
  a regra de Taylor #strong[com] o termo de suavização ($i_(t - 1)$ como
  regressor) e calcule o $rho$ implícito de suavização. Compare o R²
  ajustado com e sem esse termo.

+ #strong[Função pura para relatório reprodutível.] Escreva uma função
  `gerar_relatorio(df, indicadores)` que receba um DataFrame e uma lista
  de nomes de colunas e devolva um dicionário com média, mínimo, máximo
  e variação percentual do último valor de cada indicador --- sem
  modificar o DataFrame original (Apostila 1, Capítulo 11, função pura
  vs.~impura). Teste que rodar a função duas vezes seguidas produz
  exatamente o mesmo resultado.

+ #strong[Índice de Miséria brasileiro.] Usando IPCA acumulado 12 meses
  e taxa de desocupação (PNAD Contínua, ambos via BCB), construa a série
  do Índice de Miséria (Projeto 1) desde 2012 e identifique o mês em que
  ele atingiu seu valor máximo e mínimo na amostra. O que estava
  acontecendo na economia brasileira nesses dois momentos?

+ #strong[ACF e PACF na prática.] Para a série de IPCA mensal, plote a
  ACF e a PACF (`statsmodels.graphics.tsaplots.plot_acf` e `plot_pacf`,
  Projeto 4) até 24 defasagens. Com base no padrão visual (corte abrupto
  vs.~decaimento geométrico), proponha uma ordem $\(p\,q\)$ para um
  ARIMA e compare com a ordem usada no script do Projeto 4.

+ #strong[AIC/BIC para seleção de modelo.] Ainda sobre a série de IPCA,
  estime três ARIMAs com ordens diferentes (por exemplo, $\(1\,1\,1\)$,
  $\(2\,1\,1\)$, $\(1\,1\,2\)$) e compare o AIC e o BIC de cada um. O
  modelo com menor AIC é o mesmo com menor BIC? Se não for, qual
  critério você prefere seguir, e por quê (pesquise a diferença de
  penalização entre os dois critérios)?

+ #strong[Testando o Princípio de Taylor em outro país.] Repita a
  regressão do Projeto 5 usando dados de outro banco central com séries
  públicas (ex: Fed dos EUA, via FRED) e verifique se o coeficiente
  estimado para a inflação é maior que 1, como o Princípio de Taylor
  recomenda para uma política monetária estabilizadora.

Nenhuma dessas soluções está incluída neste documento --- a ideia é que
você as implemente, rode com dados reais, e compare o resultado com a
intuição que você registrou antes de escrever a primeira linha de
código.

#line()

== Notas e referências bibliográficas
<notas-e-referências-bibliográficas>
As seções de fundamentação teórica desta apostila se apoiam em
resultados e conceitos consolidados na literatura de macroeconomia,
crescimento e econometria. Para quem quiser aprofundar qualquer um dos
sete projetos, os textos originais (ou os manuais que os resumem) são:

- #strong[Projeto 1 (Fisher, Okun):] Fisher, I. (1930). #emph[The Theory
  of Interest]. Okun, A. (1962). "Potential GNP: Its Measurement and
  Significance".
- #strong[Projeto 2 (Solow, convergência):] Solow, R. (1956). "A
  Contribution to the Theory of Economic Growth". #emph[QJE]. Barro, R.
  & Sala-i-Martin, X. (1992). "Convergence". #emph[Journal of Political
  Economy]. Barro & Sala-i-Martin também têm um livro-texto de
  referência, #emph[Economic Growth] (MIT Press), com um capítulo
  inteiro dedicado a β- e σ-convergência.
- #strong[Projeto 3 (Kuznets Ambiental):] Kuznets, S. (1955). "Economic
  Growth and Income Inequality". #emph[American Economic Review].
  Grossman, G. & Krueger, A. (1991, 1995). "Environmental Impacts of a
  North American Free Trade Agreement" e "Economic Growth and the
  Environment". Panayotou, T. (2000), levantamento crítico da EKC para a
  OIT.
- #strong[Projeto 4 (Box-Jenkins, SARIMA):] Box, G. & Jenkins, G.
  (1970). #emph[Time Series Analysis: Forecasting and Control] --- a
  referência original da metodologia. Dickey, D. & Fuller, W. (1979).
  "Distribution of the Estimators for Autoregressive Time Series with a
  Unit Root". #emph[JASA].
- #strong[Projeto 5 (Regra de Taylor, filtro HP):] Taylor, J. (1993).
  "Discretion versus Policy Rules in Practice". #emph[Carnegie-Rochester
  Conference Series]. Hodrick, R. & Prescott, E. (1997). "Postwar U.S.
  Business Cycles: An Empirical Investigation". Orphanides, A. (2001).
  "Monetary Policy Rules Based on Real-Time Data".
- #strong[Projeto 6 (Crise cambial, EMP):] Girton, L. & Roper, D.
  (1977). "A Monetary Model of Exchange Market Pressure". Eichengreen,
  B., Rose, A. & Wyplosz, C. (1996). "Contagious Currency Crises".
  Krugman, P. (1979). "A Model of Balance-of-Payments Crises"\; (1999)
  "Balance Sheets, the Transfer Problem, and Financial Crises".
  Obstfeld, M. (1994, 1996) sobre modelos de segunda geração e
  equilíbrios múltiplos.
- #strong[Projeto 7 (Painel, Hausman):] Hausman, J. (1978).
  "Specification Tests in Econometrics". #emph[Econometrica].
  Wooldridge, J. (edição mais recente). #emph[Econometric Analysis of
  Cross Section and Panel Data] --- referência-padrão de pós-graduação
  para efeitos fixos, aleatórios e erros clusterizados.

Nenhuma dessas referências é necessária para rodar os scripts --- mas
qualquer um dos Desafios ou dos exercícios do Projeto 8 que você decidir
aprofundar em um artigo, TCC ou dissertação deveria, em algum momento,
remeter a esses textos originais, não apenas a este material
introdutório.

#line()

== Conclusão
<conclusão>
Você tem agora 7 projetos completos, mais uma lista de exercícios
pontuais adicionais (Projeto 8), cobrindo tanto a técnica quanto a
teoria por trás dela:

#figure(
  align(center)[#table(
    columns: (19.57%, 21.74%, 58.7%),
    align: (auto,auto,auto,),
    table.header([Projeto], [Técnicas], [Teoria econômica central],),
    table.hline(),
    [1. Dashboard Macro], [API BCB, pandas, matplotlib], [Equação de
    Fisher, transmissão de política monetária],
    [2. β-Convergência], [Regressão, scatter], [Modelo de Solow-Swan, β-
    e σ-convergência],
    [3. Curva de Kuznets], [Regressão quadrática], [Efeitos
    escala/composição/técnica, EKC],
    [4. Previsão IPCA], [SARIMA, séries temporais], [Box-Jenkins, raiz
    unitária, teste ADF],
    [5. Regra de Taylor], [Econometria, filtro HP], [Princípio de
    Taylor, suavização de juros],
    [6. Crise Cambial], [Análise de indicadores], [Índice EMP, modelos
    de crise cambial (1ª/2ª/3ª geração)],
    [7. TCC], [Estrutura completa], [Dados em painel, efeitos fixos
    vs.~aleatórios, teste de Hausman],
    [8. Desafios adicionais], [13 exercícios curtos], [Revisão aplicada
    das Apostilas 1--4],
  )]
  , kind: table
  )

Um padrão comum aos sete projetos vale destacar: em nenhum deles o
script sozinho "prova" a teoria. Um coeficiente com o sinal esperado é
#strong[consistente] com a hipótese testada, não uma prova definitiva
--- outras variáveis omitidas, escolhas de amostra e forma funcional
sempre podem estar por trás do resultado. É por isso que cada seção
"Antes de rodar" pede que você registre uma expectativa antes de ver o
resultado: o valor de um exercício empírico está tanto em confirmar
quanto em #strong[surpreender] sua intuição teórica, e só dá para
perceber a surpresa se a expectativa foi anotada com antecedência.

Pegue qualquer um dos projetos, adapte com seus próprios dados e sua
própria pergunta de pesquisa, resolva os desafios e os exercícios do
Projeto 8 sem consultar solução pronta --- e está pronto para virar
portfólio, TCC ou relatório de research.
