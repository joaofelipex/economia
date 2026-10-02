= Apostila 4 --- Econometria com Python (Teoria Completa)
<apostila-4-econometria-com-python-teoria-completa>

#line()

== Capítulo 1 --- O que é Econometria
<capítulo-1-o-que-é-econometria>
=== 1.1. Um pouco de história
<um-pouco-de-história>
O termo "econometria" foi cunhado pelo economista norueguês Ragnar
Frisch em 1926, e a #strong[Econometric Society] foi fundada em 1930 por
Frisch, Irving Fisher e Charles Roos, com o objetivo declarado de unir
teoria econômica, matemática e estatística num único corpo de método.
Frisch e Jan Tinbergen dividiram o primeiro Prêmio Nobel de Economia, em
1969, precisamente por terem desenvolvido e aplicado os primeiros
modelos econométricos dinâmicos.

A motivação original era simples de enunciar e difícil de resolver: a
teoria econômica produz afirmações qualitativas ("um aumento da renda
eleva o consumo") ou, no máximo, modelos matemáticos com parâmetros
livres ("consumo é uma função linear da renda, com inclinação $beta$").
Mas a teoria, sozinha, não diz #strong[qual é o valor de $beta$] no
mundo real, nem se a relação proposta realmente se sustenta quando
confrontada com dados observados. Preencher essa lacuna --- estimar
parâmetros, testar hipóteses, quantificar incerteza --- é o objeto da
econometria.

Vale registrar a definição clássica, ainda citada em praticamente todo
curso de graduação, do próprio Frisch: econometria não é matemática
aplicada à economia, nem é estatística aplicada a dados econômicos --- é
a #strong[fusão das três coisas] (teoria econômica, matemática e
estatística) em uma disciplina própria, com problemas e métodos que
nenhuma das três, isoladamente, resolveria.

=== 1.2. Econometria, estatística e machine learning --- em que cada uma difere
<econometria-estatística-e-machine-learning-em-que-cada-uma-difere>
É comum confundir as três, porque compartilham ferramentas (regressão,
por exemplo, aparece nas três). A diferença está no #strong[objetivo]:

#figure(
  align(center)[#table(
    columns: (25%, 25%, 25%, 25%),
    align: (auto,auto,auto,auto,),
    table.header([Disciplina], [Pergunta
      central], [Prioridade], [Exemplo típico],),
    table.hline(),
    [#strong[Estatística pura]], [Como descrever/inferir propriedades de
    uma população a partir de uma amostra?], [Rigor matemático,
    generalidade], [Testar se duas médias são diferentes],
    [#strong[Econometria]], [Qual é a relação #strong[causal ou
    estrutural] entre variáveis econômicas, e com que grau de
    confiança?], [Interpretabilidade dos parâmetros ($beta$ tem
    significado econômico)], [Estimar a propensão marginal a consumir],
    [#strong[Machine learning]], [Como prever $y$ da forma mais precisa
    possível, mesmo sem entender o mecanismo?], [Poder preditivo fora da
    amostra], [Prever inadimplência de um cliente],
  )]
  , kind: table
  )

Um economista que estima
$upright("consumo") = beta_0 + beta_1 dot.op upright("renda")$ não está
interessado apenas em prever o consumo do mês que vem --- está
interessado em #strong[interpretar] $beta_1$ como a propensão marginal a
consumir, um parâmetro com significado teórico (a Teoria Geral de Keynes
prevê que $0 < beta_1 < 1$). Um cientista de dados que treina uma
floresta aleatória para prever inadimplência normalmente não se importa
em interpretar cada "coeficiente" --- só que o modelo acerte. Essa
diferença de propósito é o que faz um economista escolher `statsmodels`
(que expõe erros-padrão, p-valores, testes de hipótese) em vez de
`scikit-learn` (otimizado para previsão, com interpretabilidade
secundária) como ferramenta primária.

=== 1.3. O ecossistema Python para econometria
<o-ecossistema-python-para-econometria>
#figure(
  align(center)[#table(
    columns: (33.33%, 33.33%, 33.33%),
    align: (auto,auto,auto,),
    table.header([Biblioteca], [Ponto forte], [Quando usar],),
    table.hline(),
    [#strong[statsmodels]], [Saída estatística completa (erros-padrão,
    testes, diagnósticos), sintaxe próxima da literatura
    econométrica], [Regressão OLS/GLS, séries temporais (ARIMA, VAR),
    testes de hipótese],
    [#strong[linearmodels]], [Estende o statsmodels para dados em painel
    (efeitos fixos/aleatórios) e variáveis instrumentais], [Painéis de
    países/empresas, IV/2SLS],
    [#strong[scikit-learn]], [Algoritmos de machine learning, validação
    cruzada, pipelines], [Previsão pura, quando interpretar $beta$ não é
    o objetivo],
    [#strong[scipy.stats]], [Testes estatísticos genéricos (normalidade,
    distribuições)], [Complementa o statsmodels em diagnósticos],
    [#strong[numpy/pandas]], [Álgebra linear e manipulação
    tabular], [Base de tudo o que vem acima],
  )]
  , kind: table
  )

Nesta apostila trabalharemos majoritariamente com `statsmodels`, porque
sua filosofia --- expor toda a incerteza estatística por trás de uma
estimativa, não apenas o valor pontual --- é exatamente o que a formação
econômica exige.

```python
import pandas as pd
import numpy as np
import statsmodels.api as sm
import statsmodels.formula.api as smf
from statsmodels.tsa.stattools import adfuller
from bcb import sgs
```

=== 1.4. O que você vai construir nesta apostila
<o-que-você-vai-construir-nesta-apostila>
Ao final, você será capaz de: estimar e interpretar regressões lineares
simples e múltiplas; reconhecer e testar as premissas por trás da
regressão (Gauss-Markov); diagnosticar e corrigir heterocedasticidade,
multicolinearidade e autocorrelação; interpretar variáveis dummy e
transformações logarítmicas; e aplicar os principais modelos de séries
temporais (estacionariedade, ARIMA, cointegração, VAR, causalidade de
Granger) e de dados em painel usados em pesquisa aplicada e em bancos
centrais.

O fio condutor será sempre um exemplo econômico concreto --- a função
consumo keynesiana, a Curva de Phillips, a equação de Mincer para
retornos à educação --- porque econometria sem uma pergunta econômica
por trás é apenas álgebra linear.

#line()

== Capítulo 2 --- O Modelo de Regressão Linear Simples
<capítulo-2-o-modelo-de-regressão-linear-simples>
=== 2.1. Modelo populacional vs.~modelo estimado
<modelo-populacional-vs.-modelo-estimado>
A distinção mais importante deste capítulo --- e a que mais confunde
iniciantes --- é entre o #strong[modelo populacional] (o que é
verdadeiro no mundo, mas nunca observamos diretamente) e o
#strong[modelo estimado] (o que calculamos a partir de uma amostra de
dados).

O modelo populacional de regressão linear simples é:

$ y_i = beta_0 + beta_1 x_i + u_i $

onde $y_i$ é a variável dependente (o que queremos explicar), $x_i$ é a
variável explicativa, $beta_0$ e $beta_1$ são os #strong[parâmetros
populacionais verdadeiros] (desconhecidos, fixos, não observados), e
$u_i$ é o #strong[termo de erro] --- tudo o que afeta $y_i$ e não é
capturado por $x_i$ (variáveis omitidas, erro de medida, aleatoriedade
genuína).

Como nunca observamos $beta_0$ e $beta_1$ diretamente, o que fazemos é
#strong[estimá-los] a partir de uma amostra de $n$ observações,
produzindo:

$ hat(y)_i = hat(beta)_0 + hat(beta)_1 x_i $

O "chapéu" ($hat(med)$) é a convenção universal em econometria para
indicar "isto é uma estimativa, não o valor verdadeiro". A diferença
entre o valor observado e o valor predito é o #strong[resíduo]:

$ hat(u)_i = y_i - hat(y)_i $

O resíduo $hat(u)_i$ é uma #strong[estimativa observável] do erro $u_i$
(não observável) --- outra confusão comum é tratá-los como sinônimos.

=== 2.2. O método dos Mínimos Quadrados Ordinários (OLS)
<o-método-dos-mínimos-quadrados-ordinários-ols>
A pergunta natural é: como escolher $hat(beta)_0$ e $hat(beta)_1$? O
critério de #strong[Mínimos Quadrados Ordinários] (#emph[Ordinary Least
Squares], OLS) escolhe os valores que #strong[minimizam a soma dos
quadrados dos resíduos]:

$ min_(hat(beta)_0\,hat(beta)_1) sum_(i = 1)^n hat(u)_i^2 = sum_(i = 1)^n\(y_i - hat(beta)_0 - hat(beta)_1 x_i\)^2 $

Por que #strong[quadrados], e não a soma dos resíduos em valor absoluto,
por exemplo? Duas razões práticas: (1) elevar ao quadrado penaliza
desproporcionalmente erros grandes, o que geralmente é desejável; e (2)
a função objetivo resultante é diferenciável em toda parte, o que
permite resolver o problema analiticamente (derivando e igualando a
zero), em vez de recorrer a métodos numéricos iterativos. Resolvendo
esse sistema (as chamadas #strong[equações normais]), chega-se a uma
fórmula fechada.

#strong[A derivação, passo a passo.] Chame a soma dos quadrados dos
resíduos de $S(hat(beta)_0, hat(beta)_1)$. Minimizar uma função de duas
variáveis exige que #strong[ambas] as derivadas parciais sejam nulas
simultaneamente (condição de primeira ordem):

$ frac(partial S, partial hat(beta)_0) = -2 sum_(i=1)^n (y_i - hat(beta)_0 - hat(beta)_1 x_i) = 0 $

$ frac(partial S, partial hat(beta)_1) = -2 sum_(i=1)^n x_i (y_i - hat(beta)_0 - hat(beta)_1 x_i) = 0 $

A primeira equação, dividida por $-2n$, diz que a soma dos resíduos
precisa ser exatamente zero --- é #strong[por construção do próprio
método], não uma hipótese adicional, que a reta de OLS sempre passa
pelo ponto médio $(macron(x), macron(y))$:

$ macron(y) - hat(beta)_0 - hat(beta)_1 macron(x) = 0 quad arrow.r.double quad hat(beta)_0 = macron(y) - hat(beta)_1 macron(x) $

Substituindo esse $hat(beta)_0$ na segunda equação e isolando
$hat(beta)_1$ (álgebra que aqui se omite, mas que é apenas expandir o
produto e agrupar termos em $hat(beta)_1$), chega-se à fórmula fechada
abaixo. O ponto que costuma passar despercebido: essas duas equações
não são um "truque de cálculo" isolado --- são o motivo estrutural pelo
qual os #strong[resíduos de uma regressão OLS sempre somam zero] e
#strong[nunca são correlacionados com o regressor $x$] (a segunda
equação, reescrita, diz exatamente $sum x_i hat(u)_i = 0$). Essas duas
propriedades reaparecerão no Capítulo 3 como consequência direta --- não
coincidência --- do próprio critério de minimização.

$ hat(beta)_1 = frac(sum_(i = 1)^n\(x_i - macron(x)\)\(y_i - macron(y)\), sum_(i = 1)^n\(x_i - macron(x)\)^2) = frac(upright("Cov")\(x\,y\), upright("Var")\(x\)) $

$ hat(beta)_0 = macron(y) - hat(beta)_1 macron(x) $

Repare que $hat(beta)_1$ é, essencialmente, a covariância entre $x$ e
$y$ escalada pela variância de $x$ --- o que já antecipa por que
regressão simples e correlação estão tão intimamente ligadas (voltaremos
a isso, e a por que são conceitos diferentes, no Capítulo 7).

=== 2.3. Primeiro modelo: a função consumo keynesiana
<primeiro-modelo-a-função-consumo-keynesiana>
A relação entre consumo e renda é um dos pontos de partida clássicos da
macroeconomia --- a "função consumo" de Keynes, formalizada como
$C = C_0 + c dot.op Y$, onde $C_0$ é o consumo autônomo (o que se
consome mesmo com renda zero, financiado por poupança ou crédito) e $c$
é a #strong[propensão marginal a consumir] (PMgC), a fração de cada
unidade adicional de renda que é destinada ao consumo em vez de
poupança.

```python
# Dados simulados de consumo e renda (função consumo keynesiana)
np.random.seed(42)
renda = np.arange(1000, 11000, 1000)
consumo = 200 + 0.8 * renda + np.random.normal(0, 100, len(renda))

df = pd.DataFrame({"renda": renda, "consumo": consumo})

# statsmodels NÃO adiciona o intercepto (beta_0) automaticamente —
# é preciso pedir explicitamente com sm.add_constant()
X = sm.add_constant(df["renda"])
y = df["consumo"]

modelo = sm.OLS(y, X).fit()
print(modelo.summary())
```

#strong[Atenção --- a armadilha mais comum de quem começa com
statsmodels:] esquecer `sm.add_constant(X)`. Sem ela, o `sm.OLS` estima
um modelo #strong[forçado a passar pela origem] ($hat(beta)_0 = 0$), o
que quase nunca é o que se pretende economicamente (implicaria consumo
zero para renda zero) e distorce todos os coeficientes, inclusive o
$R^2$. Isso é diferente de `smf.ols("consumo ~ renda", data=df)` (a
interface por fórmula, no estilo R), que adiciona o intercepto
automaticamente --- as duas interfaces do statsmodels têm essa diferença
de comportamento padrão, e vale saber qual delas você está usando.

```python
# Interface por fórmula — adiciona o intercepto por padrão
modelo2 = smf.ols("consumo ~ renda", data=df).fit()
print(modelo2.params)  # idênticos aos de "modelo" acima
```

=== 2.4. Exemplo Resolvido --- Interpretando os coeficientes da função consumo
<exemplo-resolvido-interpretando-os-coeficientes-da-função-consumo>
#strong[Enunciado:] rodando o modelo do item 2.3, o statsmodels retorna
aproximadamente $hat(beta)_0 = 226\,72$ e $hat(beta)_1 = 0\,796$.
Interprete cada um em português econômico, e calcule o consumo previsto
para uma renda de `R\$ 7.500`.

#strong[Solução comentada:]

```python
beta0, beta1 = modelo.params["const"], modelo.params["renda"]
print(f"Consumo autônomo (const): {beta0:.2f}")
print(f"Propensão marginal a consumir (renda): {beta1:.4f}")

renda_nova = 7500
consumo_previsto = beta0 + beta1 * renda_nova
print(f"Consumo previsto para renda = {renda_nova}: {consumo_previsto:.2f}")
```

- $hat(beta)_0 = 226\,72$: é o consumo previsto quando a renda é zero
  --- o #strong[consumo autônomo]. Note que essa interpretação literal
  só faz sentido dentro (ou perto) do intervalo de renda observado nos
  dados (`R\$ 1.000` a `R\$ 10.000`); extrapolar para renda = 0 é um
  exercício algébrico, não necessariamente uma afirmação econômica
  confiável (esse problema tem nome --- #strong[extrapolação fora da
  amostra] --- e reaparecerá na Apostila 6/7 ao falar de previsão).
- $hat(beta)_1 = 0\,796$: para cada `R\$ 1,00` adicional de renda, o
  consumo aumenta, em média, `R\$ 0,796`, #strong[mantendo tudo o mais
  constante] (aqui, "tudo o mais" é vazio, porque é regressão simples
  --- a expressão ganha peso reforçado no Capítulo 6, regressão
  múltipla). O valor está dentro do intervalo teórico esperado pela
  Teoria Geral de Keynes ($0 < c < 1$), o que é uma checagem de sanidade
  útil: um $hat(beta)_1$ estimado fora desse intervalo (negativo, ou
  maior que 1) pediria investigação antes de aceitar o resultado.
- O consumo previsto para renda `R\$ 7.500` é
  $226\,72 + 0\,796 times 7500 approx upright("R$") 6.196\,72$.

#line()

== Capítulo 3 --- As Premissas de Gauss-Markov e o Teorema BLUE
<capítulo-3-as-premissas-de-gauss-markov-e-o-teorema-blue>
=== 3.1. Por que "só rodar a regressão" não basta
<por-que-só-rodar-a-regressão-não-basta>
O estimador de OLS existe e produz um número mesmo quando os dados são
inadequados --- o computador não vai recusar rodar uma regressão só
porque as premissas estatísticas por trás dela foram violadas. É por
isso que a etapa de #strong[verificar premissas] (Capítulos 3, 8 e 9
desta apostila) não é burocracia acadêmica: é o que separa uma
estimativa confiável de um número sem sentido estatístico, ainda que o
`summary()` pareça, à primeira vista, igualmente "sério" nos dois casos.

O #strong[Teorema de Gauss-Markov] afirma que, sob um conjunto de seis
premissas, o estimador de OLS é o #strong[BLUE] --- #emph[Best Linear
Unbiased Estimator] (Melhor Estimador Linear Não Viesado). Cada palavra
desse acrônimo carrega um significado técnico preciso:

- #strong[Linear]: $hat(beta)$ é uma função linear dos valores de $y$.
- #strong[Unbiased (não viesado)]: em média, ao longo de infinitas
  amostras hipotéticas, $hat(beta)$ acerta o valor verdadeiro $beta$:
  $E\[hat(beta)\]= beta$.
- #strong[Best (melhor)]: entre todos os estimadores lineares não
  viesados, o OLS é o que tem a #strong[menor variância] --- ou seja, a
  estimativa mais precisa possível dentro dessa classe.

=== 3.2. As seis premissas, uma a uma
<as-seis-premissas-uma-a-uma>
#figure(
  align(center)[#table(
    columns: (25%, 25%, 25%, 25%),
    align: (auto,auto,auto,auto,),
    table.header([\#], [Premissa], [Enunciado técnico], [Violação comum
      em economia],),
    table.hline(),
    [1], [#strong[Linearidade nos
    parâmetros]], [$y = beta_0 + beta_1 x + u$ (linear nos $beta$'s, não
    necessariamente em $x$)], [Relação verdadeira é não-linear (ex:
    retornos decrescentes de capital) --- resolve-se com transformações
    (Capítulo 11)],
    [2], [#strong[Amostragem aleatória]], [As observações $\(x_i\,y_i\)$
    são extraídas aleatoriamente da população], [Amostra viesada (ex: só
    empresas que sobreviveram --- #emph[survivorship bias])],
    [3], [#strong[Ausência de colinearidade perfeita]], [Nenhuma
    variável explicativa é combinação linear exata de outra], [Duas
    variáveis medindo essencialmente a mesma coisa (Capítulo 8)],
    [4], [#strong[Exogeneidade / média condicional
    zero]], [$E\[u divides x\]= 0$ --- o erro não está correlacionado
    com $x$], [Variável omitida correlacionada com $x$ e com $y$
    (Capítulo 7) --- a mais grave e mais difícil de garantir],
    [5], [#strong[Homocedasticidade]], [$upright("Var")\(u divides x\)= sigma^2$
    constante para todo $x$], [Variância do erro cresce com o nível de
    $x$ (ex: erro de previsão de gasto cresce com a renda) (Capítulo
    9)],
    [6], [#strong[Normalidade dos erros] #emph[\(opcional, para
    inferência em amostras
    pequenas)]], [$u tilde.op N\(0\,sigma^2\)$], [Erros com caudas
    pesadas ou assimetria --- menos grave em amostras grandes (Teorema
    Central do Limite)],
  )]
  , kind: table
  )

As premissas 1 a 5 garantem que o OLS é BLUE (Gauss-Markov não exige
normalidade). A premissa 6 é necessária apenas para que os testes de
hipótese (t, F) tenham validade #strong[exata] em amostras pequenas; em
amostras grandes, o Teorema Central do Limite garante uma aproximação
razoável mesmo sem normalidade exata dos erros.

=== 3.3. A premissa que mais importa: exogeneidade
<a-premissa-que-mais-importa-exogeneidade>
Das seis, a premissa 4 (exogeneidade, $E\[u\|x\]= 0$) é sistematicamente
a mais violada em dados observacionais econômicos, e a mais consequente:
sua violação gera #strong[viés], que não desaparece nem com uma amostra
infinita --- diferente, por exemplo, da falta de eficiência causada por
heterocedasticidade, que "só" torna os erros-padrão incorretos.
Voltaremos a isso com profundidade no Capítulo 7 (correlação
vs.~causalidade), porque é o ponto onde mais pesquisa aplicada em
economia tropeça.

=== 3.4. Exemplo Resolvido --- Diagnosticando premissas a partir de um gráfico de resíduos
<exemplo-resolvido-diagnosticando-premissas-a-partir-de-um-gráfico-de-resíduos>
#strong[Enunciado:] você roda uma regressão de gasto das famílias com
alimentação (`gasto_alimentacao`) contra renda (`renda`), e plota os
resíduos ($hat(u)_i$, eixo y) contra os valores previstos ($hat(y)_i$,
eixo x). O gráfico mostra os pontos formando um "leque" --- dispersos
bem próximos de zero para valores previstos baixos, e cada vez mais
espalhados (para cima e para baixo) conforme o valor previsto cresce.
Qual premissa de Gauss-Markov está sendo violada, e qual é a
consequência prática?

#strong[Solução comentada:]

O padrão de "leque" (variância dos resíduos crescendo com o nível da
variável prevista) é a assinatura visual clássica de
#strong[heterocedasticidade] --- violação da premissa 5. Faz sentido
economicamente: famílias de renda baixa têm pouca margem de escolha no
gasto com alimentação (o piso de subsistência limita a variação),
enquanto famílias de renda alta têm muito mais liberdade --- algumas
gastam pouco (poupam ou têm hábitos frugais), outras gastam muito
(alimentação sofisticada) --- logo a dispersão do gasto em torno da
média prevista aumenta com a renda.

A consequência prática, importante para não confundir:
heterocedasticidade #strong[não torna $hat(beta)_1$ viesado] (o
Gauss-Markov ainda garante um estimador não viesado sem a premissa 5)
--- mas torna os #strong[erros-padrão calculados pelo OLS incorretos], o
que invalida os testes t e F e os intervalos de confiança relatados no
`summary()`. Ou seja: o coeficiente pode estar certo, mas a "confiança"
que você tem nele (o p-valor) pode estar errada. A correção ---
erros-padrão robustos --- é o assunto do Capítulo 9.

#line()

== Capítulo 4 --- Interpretando a Saída da Regressão
<capítulo-4-interpretando-a-saída-da-regressão>
=== 4.1. O `summary()` completo
<o-summary-completo>
```python
modelo = sm.OLS(y, X).fit()
print(modelo.summary())
```

```
                            OLS Regression Results
==============================================================================
Dep. Variable:                consumo   R-squared:                       0.996
Model:                            OLS   Adj. R-squared:                  0.995
Method:                 Least Squares   F-statistic:                     1782.
Date:                                   Prob (F-statistic):           2.58e-10
==============================================================================
                 coef    std err          t      P>|t|      [0.025      0.975]
------------------------------------------------------------------------------
const        226.7169     67.233      3.372      0.010      69.812     383.622
renda          0.7959      0.019     42.214      0.000       0.752       0.840
==============================================================================
```

=== 4.2. R² --- o quanto o modelo explica
#label("r²-o-quanto-o-modelo-explica")
O #strong[coeficiente de determinação] $R^2$ mede a proporção da
variação total de $y$ que é explicada pelo modelo:

$ R^2 = upright("SQE") / upright("SQT") = 1 - upright("SQR") / upright("SQT") $

onde $upright("SQT") = sum\(y_i - macron(y)\)^2$ é a soma dos quadrados
totais (a variação de $y$ em torno de sua média),
$upright("SQE") = sum\(hat(y)_i - macron(y)\)^2$ é a soma dos quadrados
explicados pelo modelo, e $upright("SQR") = sum hat(u)_i^2$ é a soma dos
quadrados dos resíduos (o que sobra, não explicado). $R^2 = 0\,996$
significa que 99,6% da variação do consumo entre as observações é
explicada pela variação da renda --- um valor artificialmente alto aqui
porque os dados foram simulados com pouco ruído; em dados reais de corte
transversal com uma única variável explicativa, $R^2$ acima de 0,5 já
costuma ser considerado alto.

#strong[Gotcha:] $R^2$ #strong[sempre aumenta] (ou, no limite, permanece
igual) quando se adiciona qualquer variável explicativa nova ao modelo
--- mesmo uma variável sem qualquer relação teórica com $y$ (ex: o
número de letras do nome do presidente do Banco Central). Isso torna o
$R^2$ simples um péssimo critério para decidir se vale a pena incluir
uma variável adicional --- para isso existe o $R^2$ ajustado:

$ macron(R)^2 = 1 -\(1 - R^2\)frac(n - 1, n - k - 1) $

onde $n$ é o número de observações e $k$ o número de variáveis
explicativas (sem contar a constante). O $R^2$ ajustado penaliza a
inclusão de variáveis que não contribuem o suficiente, podendo até
#strong[cair] quando uma variável irrelevante é adicionada --- o que o
torna a métrica preferida para comparar modelos com número diferente de
regressores.

=== 4.3. Erro padrão, estatística t e p-valor
<erro-padrão-estatística-t-e-p-valor>
Cada coeficiente estimado $hat(beta)_1$ tem um #strong[erro padrão]
($upright("std err")$), que mede a variabilidade esperada de
$hat(beta)_1$ se repetíssemos o processo de amostragem inúmeras vezes. A
partir dele, constrói-se a #strong[estatística t] para testar a hipótese
nula de que o coeficiente populacional verdadeiro é zero (isto é, que a
variável não tem efeito):

$ t = frac(hat(beta)_1 - 0, upright("se")\(hat(beta)_1\)) $

O #strong[p-valor] é a probabilidade de observar uma estatística t tão
extrema quanto a calculada (ou mais), #strong[assumindo que a hipótese
nula é verdadeira]. A convenção universal (mas arbitrária --- ver
Capítulo 5.4) é rejeitar $H_0$ quando $p < 0\,05$: para `renda`,
$p < 0\,001$, uma evidência estatística muito forte de que a renda afeta
o consumo.

#strong[Gotcha de interpretação, frequente até em trabalhos publicados:]
p-valor #strong[não é] "a probabilidade de $H_0$ ser verdadeira". É a
probabilidade de observar um dado tão extremo quanto o observado
#strong[dado que] $H_0$ é verdadeira --- uma afirmação condicional, não
a afirmação invertida. Confundir as duas é um dos erros conceituais mais
comuns em estatística aplicada.

=== 4.4. Intervalos de confiança
<intervalos-de-confiança>
A coluna `[0.025  0.975]` do `summary()` mostra o #strong[intervalo de
confiança de 95%] para cada coeficiente:

$ hat(beta)_1 plus.minus t_(alpha\/2\,thin n - k - 1) dot.op upright("se")\(hat(beta)_1\) $

Interpretação correta (e sutil): "se repetíssemos esse procedimento de
amostragem muitas vezes, 95% dos intervalos construídos dessa forma
conteriam o verdadeiro $beta_1$". #strong[Não] significa "há 95% de
chance de o $beta_1$ verdadeiro estar neste intervalo específico" --- o
$beta_1$ verdadeiro é um número fixo (embora desconhecido), não uma
variável aleatória; quem é aleatório é o intervalo, que muda a cada
amostra.

```python
modelo.conf_int()          # intervalos de confiança (95% por padrão)
modelo.conf_int(alpha=0.01)  # intervalo de 99%
```

=== 4.5. F-statistic --- significância conjunta
<f-statistic-significância-conjunta>
Enquanto o teste t avalia #strong[um] coeficiente de cada vez, a
estatística F testa a hipótese conjunta de que #strong[todos] os
coeficientes (exceto a constante) são simultaneamente zero:

$ H_0 : beta_1 = beta_2 = dots.h = beta_k = 0 quad upright("vs.") quad H_1 : upright("pelo menos um ") beta_j eq.not 0 $

`Prob (F-statistic)` extremamente baixo (`2.58e-10`) rejeita fortemente
$H_0$ --- o modelo, como um todo, tem poder explicativo estatisticamente
significativo. Isso importa especialmente em regressão múltipla: é
possível (embora incomum) que nenhum coeficiente individual seja
significativo no teste t, mas o F conjunto seja significativo ---
sintoma típico de multicolinearidade (Capítulo 8).

=== 4.6. Extraindo cada peça programaticamente
<extraindo-cada-peça-programaticamente>
```python
modelo.params         # coeficientes (Series indexada pelo nome da variável)
modelo.pvalues        # p-valores
modelo.rsquared       # R²
modelo.rsquared_adj   # R² ajustado
modelo.resid          # resíduos
modelo.fittedvalues   # valores preditos (y-chapéu)
modelo.conf_int()     # intervalos de confiança (95%)
modelo.bse            # erros padrão (bse = "beta standard errors")
modelo.fvalue         # estatística F
modelo.f_pvalue       # p-valor da estatística F
```

=== 4.7. Exemplo Resolvido --- Lendo uma saída de regressão fornecida como texto
<exemplo-resolvido-lendo-uma-saída-de-regressão-fornecida-como-texto>
#strong[Enunciado:] um colega enviou apenas o texto abaixo, resultado de
uma regressão de salário (em milhares de `R\$` por ano) contra anos de
escolaridade e experiência, com $n = 200$ observações. Sem rodar nenhum
código, responda: (a) qual o efeito estimado de mais um ano de
escolaridade sobre o salário? (b) o coeficiente de experiência é
estatisticamente significativo a 5%? (c) o modelo como um todo é
significativo? (d) o que representa o `R-squared` de 0,312 neste
contexto?

```
                 coef    std err          t      P>|t|
------------------------------------------------------------------------------
const          8.2000      1.500      5.467      0.000
escolaridade    2.1000      0.310      6.774      0.000
experiencia     0.4500      0.290      1.552      0.122
==============================================================================
R-squared: 0.312           F-statistic: 44.68        Prob (F-statistic): 1.2e-16
```

#strong[Solução comentada:]

#block[
#set enum(numbering: "(a)", start: 1)
+ Mantendo a experiência constante, cada ano adicional de escolaridade
  está associado, em média, a um aumento de `R\$ 2.100,00` por ano no
  salário (o coeficiente `2.100` está em milhares de reais).

+ Não. O p-valor de `experiencia` é `0,122`, maior que `0,05` --- não há
  evidência estatística suficiente, a 5% de significância, para rejeitar
  a hipótese de que o efeito da experiência sobre o salário é zero,
  #strong[neste modelo e nesta amostra]. Importante: isso #strong[não
  prova] que experiência não afeta salário na população --- apenas que
  esta amostra não forneceu evidência forte o bastante para essa
  variável específica (possivelmente por colinearidade com escolaridade,
  ou por tamanho de amostra insuficiente para detectar um efeito
  verdadeiro, mas pequeno).

+ Sim. `Prob (F-statistic) = 1.2e-16` é essencialmente zero ---
  rejeita-se fortemente a hipótese conjunta de que escolaridade e
  experiência juntas não têm efeito nenhum sobre o salário, mesmo que,
  isoladamente, `experiencia` não tenha passado no teste t individual.

+ $R^2 = 0\,312$ significa que 31,2% da variação do salário entre os 200
  indivíduos da amostra é explicada pelas duas variáveis do modelo. Isso
  é um valor tipicamente razoável (não alto) para dados de corte
  transversal de indivíduos --- salário depende de dezenas de fatores
  não observados (habilidade inata, rede de contatos, sorte, setor de
  atuação), então é esperado que a maior parte da variação (68,8%) fique
  no termo de erro.
]

#line()

== Capítulo 5 --- Testes de Hipótese em Regressão
<capítulo-5-testes-de-hipótese-em-regressão>
=== 5.1. A lógica de um teste de hipótese
<a-lógica-de-um-teste-de-hipótese>
Todo teste de hipótese em econometria segue a mesma estrutura lógica,
emprestada da estatística clássica (Neyman-Pearson): formula-se uma
#strong[hipótese nula] ($H_0$), tipicamente representando "nenhum
efeito" ou "o status quo"\; formula-se uma #strong[hipótese alternativa]
($H_1$); calcula-se uma estatística de teste a partir dos dados; e
compara-se essa estatística (ou o p-valor associado) contra um limiar de
significância pré-definido, geralmente $alpha = 0\,05$.

Em regressão, a hipótese nula mais comum é $H_0 : beta_j = 0$ --- a
variável $x_j$ não tem efeito sobre $y$. Rejeitar $H_0$ não "prova" que
$beta_j eq.not 0$ no sentido matemático absoluto --- é uma afirmação
probabilística: "os dados observados seriam muito improváveis se
$beta_j$ realmente fosse zero".

=== 5.2. Erro Tipo I e Tipo II
<erro-tipo-i-e-tipo-ii>
#figure(
  align(center)[#table(
    columns: (33.33%, 33.33%, 33.33%),
    align: (auto,auto,auto,),
    table.header([], [$H_0$ verdadeira], [$H_0$ falsa],),
    table.hline(),
    [#strong[Rejeita $H_0$]], [Erro Tipo I (falso positivo) ---
    probabilidade $alpha$], [Decisão correta],
    [#strong[Não rejeita $H_0$]], [Decisão correta], [Erro Tipo II
    (falso negativo) --- probabilidade $beta$],
  )]
  , kind: table
  )

Escolher $alpha = 0\,05$ significa aceitar, por convenção, uma chance de
5% de rejeitar $H_0$ quando ela é, na verdade, verdadeira. Reduzir
$alpha$ (para 0,01, por exemplo) torna o teste mais "conservador" ---
reduz o erro Tipo I, mas aumenta o erro Tipo II (menos poder para
detectar efeitos verdadeiros pequenos). Não existe almoço grátis: a
escolha de $alpha$ é uma escolha sobre qual tipo de erro você está mais
disposto a tolerar, algo que deveria depender do contexto da pergunta
(um teste clínico de segurança de medicamento tolera erro Tipo I muito
menor que um teste exploratório em pesquisa econômica).

=== 5.3. Teste t vs.~teste F --- quando usar cada um
<teste-t-vs.-teste-f-quando-usar-cada-um>
#figure(
  align(center)[#table(
    columns: (50%, 50%),
    align: (auto,auto,),
    table.header([Situação], [Teste apropriado],),
    table.hline(),
    ["A variável `desemprego`, isoladamente, afeta a inflação?"], [Teste
    t sobre $hat(beta)_(upright("desemprego"))$],
    ["As variáveis `desemprego` e `câmbio`, #strong[juntas], melhoram o
    modelo em relação a um modelo só com `ipca_lag`?"], [Teste F de
    restrições conjuntas (comparação de modelos aninhados)],
    ["Todos os coeficientes do modelo são conjuntamente zero?"], [Teste
    F reportado no `summary()`],
  )]
  , kind: table
  )

O teste F para restrições conjuntas (não apenas "todos os betas são
zero", mas um subconjunto específico) pode ser calculado comparando um
#strong[modelo restrito] (sem as variáveis de interesse) contra o
#strong[modelo irrestrito] (com elas):

$ F = frac(\(upright("SQR")_r - upright("SQR")_(upright("ir"))\)\/q, upright("SQR")_(upright("ir"))\/\(n - k - 1\)) $

onde $q$ é o número de restrições testadas, $upright("SQR")_r$ e
$upright("SQR")_(upright("ir"))$ são as somas dos quadrados dos resíduos
dos modelos restrito e irrestrito, respectivamente.

```python
modelo_irrestrito = smf.ols("ipca ~ desemprego + ipca_lag1 + cambio", data=df).fit()
modelo_restrito = smf.ols("ipca ~ ipca_lag1", data=df).fit()

# statsmodels tem um método pronto para o teste F de restrições
f_test = modelo_irrestrito.compare_f_test(modelo_restrito)
print(f"F-statistic: {f_test[0]:.4f}, p-valor: {f_test[1]:.4f}")
```

=== 5.4. O debate sobre o limiar de 0,05
<o-debate-sobre-o-limiar-de-005>
Vale um comentário honesto: o limiar $alpha = 0\,05$ é uma convenção
histórica (popularizada por Ronald Fisher nos anos 1920), não uma lei da
natureza. A American Statistical Association publicou, em 2016, um
posicionamento oficial alertando contra o uso mecânico de "p \< 0,05 =
significativo, p \> 0,05 = não significativo" como critério binário de
"verdade" --- um efeito com $p = 0\,06$ não é qualitativamente diferente
de um com $p = 0\,04$\; é uma diferença de grau, não de natureza. Em
pesquisa econômica aplicada, é considerada boa prática reportar o
p-valor exato (não apenas "significativo/não significativo") e discutir
a #strong[magnitude econômica] do efeito (o coeficiente em si), não
apenas sua significância estatística --- um efeito pode ser
estatisticamente significativo e economicamente irrelevante (amostras
muito grandes detectam como "significativo" até efeitos triviais).

=== 5.5. Exemplo Resolvido --- Testando a Curva de Phillips
<exemplo-resolvido-testando-a-curva-de-phillips>
#strong[Enunciado:] a Curva de Phillips original propõe uma relação
#strong[negativa] entre desemprego e inflação. Rode a regressão abaixo
com dados reais do BCB e teste formalmente a hipótese
$H_0 : beta_(upright("desemprego")) gt.eq 0$ contra
$H_1 : beta_(upright("desemprego")) < 0$ (teste unilateral).

```python
ipca = sgs.get({"ipca": 433}, start="2012-01-01")
desemprego = sgs.get({"desemprego": 24369}, start="2012-01-01")

df = pd.merge(ipca, desemprego, on="Date")
df["ipca_lag1"] = df["ipca"].shift(1)
df = df.dropna()

X = sm.add_constant(df[["desemprego", "ipca_lag1"]])
y = df["ipca"]
modelo = sm.OLS(y, X).fit()
```

#strong[Solução comentada:]

```python
coef = modelo.params["desemprego"]
p_bilateral = modelo.pvalues["desemprego"]

print(f"Coeficiente desemprego: {coef:.4f}")
print(f"p-valor (bilateral, reportado pelo statsmodels): {p_bilateral:.4f}")

# Para um teste UNILATERAL (H1: beta < 0), quando o coeficiente
# estimado tem o sinal esperado (negativo), o p-valor unilateral
# é METADE do p-valor bilateral reportado pelo summary()
if coef < 0:
    p_unilateral = p_bilateral / 2
    print(f"p-valor (unilateral): {p_unilateral:.4f}")
else:
    print("Coeficiente com sinal contrário ao esperado — não rejeita H0 de forma alguma")
```

O ponto conceitual central: o `summary()` do statsmodels sempre reporta
o p-valor de um teste #strong[bilateral] ($H_1 : beta eq.not 0$), porque
é o caso mais genérico e conservador. Quando a teoria econômica prevê um
sinal específico (aqui, negativo, conforme a Curva de Phillips original)
e o coeficiente estimado tem, de fato, esse sinal, o pesquisador pode
legitimamente usar um teste #strong[unilateral], que divide o p-valor
por dois (fica mais fácil rejeitar $H_0$, porque toda a "massa" de
rejeição está concentrada de um lado da distribuição). O cuidado
necessário: essa divisão só é válida se o sinal do coeficiente
#strong[já era esperado antes de ver os dados] --- decidir "agora que vi
que deu negativo, vou fazer o teste unilateral" depois de observar o
resultado é uma forma de viés de confirmação estatística (às vezes
chamado informalmente de "p-hacking").

#line()

== Capítulo 6 --- Regressão Múltipla
<capítulo-6-regressão-múltipla>
=== 6.1. Por que adicionar mais variáveis
<por-que-adicionar-mais-variáveis>
O modelo de regressão múltipla generaliza o simples para $k$ variáveis
explicativas:

$ y_i = beta_0 + beta_1 x_(1 i) + beta_2 x_(2 i) + dots.h + beta_k x_(upright("ki")) + u_i $

A motivação principal não é apenas "melhorar o $R^2$" --- é
#strong[controlar por outros fatores] que poderiam confundir a relação
de interesse, aproximando-se do que a premissa de exogeneidade (Capítulo
3) exige. Cada $hat(beta)_j$ passa a ser interpretado #strong[ceteris
paribus] --- "mantendo todas as outras variáveis do modelo constantes"
--- uma expressão em latim que aparece o tempo todo em econometria e que
vale memorizar precisamente: sem ela, a interpretação de um coeficiente
múltiplo perde o sentido.

```python
df["poupanca"] = df["renda"] - df["consumo"]
df["juros"] = 5 + np.random.normal(0, 1, len(df))

X = sm.add_constant(df[["renda", "juros", "poupanca"]])
y = df["consumo"]

modelo = sm.OLS(y, X).fit()
print(modelo.summary())
```

=== 6.2. R² ajustado como critério de comparação
#label("r²-ajustado-como-critério-de-comparação")
Como visto no Capítulo 4.2, use sempre o $R^2$ #strong[ajustado]
(`modelo.rsquared_adj`), nunca o $R^2$ simples, para decidir se vale a
pena manter uma variável adicional no modelo --- ou, melhor ainda,
apoie-se em teoria econômica (a variável tem uma justificativa causal
para estar no modelo?) mais do que em uma busca puramente estatística
por "o que aumenta o $R^2$".

=== 6.3. Exemplo Resolvido --- Comparando regressão simples e múltipla
<exemplo-resolvido-comparando-regressão-simples-e-múltipla>
#strong[Enunciado:] usando os dados de consumo, renda, juros e poupança
do item 6.1, compare o $hat(beta)_(upright("renda"))$ estimado na
regressão simples (Capítulo 2.3, apenas `renda`) com o estimado na
regressão múltipla (com `juros` e `poupanca` adicionados). Eles são
iguais? Por que isso é ou não é esperado?

#strong[Solução comentada:]

```python
simples = sm.OLS(df["consumo"], sm.add_constant(df["renda"])).fit()
multipla = sm.OLS(df["consumo"], sm.add_constant(df[["renda", "juros", "poupanca"]])).fit()

print(f"Beta_renda (simples):  {simples.params['renda']:.4f}")
print(f"Beta_renda (múltipla): {multipla.params['renda']:.4f}")
```

Em geral, #strong[não] são exatamente iguais --- e essa é a regra, não a
exceção. O coeficiente de `renda` muda entre as duas especificações na
exata medida em que `renda` é correlacionada com as variáveis
adicionadas (`juros`, `poupanca`) #strong[e] essas variáveis adicionadas
têm efeito próprio sobre `consumo`. Neste exemplo específico, `poupanca`
foi construída como `renda - consumo` --- ou seja, é quase uma
transformação determinística das próprias variáveis já no modelo, o que
tende a inflar a colinearidade (assunto do próximo capítulo) e tornar os
coeficientes individualmente instáveis, mesmo que o ajuste conjunto do
modelo pareça bom. Isso ilustra, de forma propositalmente exagerada, por
que a escolha de quais variáveis incluir numa regressão múltipla é uma
decisão teórica, não apenas mecânica.

#line()

== Capítulo 7 --- Correlação Não é Causalidade
<capítulo-7-correlação-não-é-causalidade>
=== 7.1. Por que este é o capítulo mais importante da apostila
<por-que-este-é-o-capítulo-mais-importante-da-apostila>
Se há um único conceito que um curso de econometria precisa deixar
gravado, é este: #strong[um coeficiente de regressão estatisticamente
significativo não implica, por si só, uma relação causal]. Essa
afirmação parece óbvia quando enunciada assim, mas é sistematicamente
esquecida na prática --- inclusive por pesquisadores experientes ---
porque o software não distingue: `sm.OLS(y, X).fit()` roda exatamente
igual, produz um `summary()` igualmente "sério", esteja ou não a relação
estimada sendo causal.

O exemplo didático clássico (repetido em praticamente todo curso
introdutório) é a correlação positiva entre venda de sorvetes e número
de afogamentos em praias. Ninguém defende que sorvete causa afogamento
--- ambos são causados por uma terceira variável, a temperatura (dias
quentes aumentam tanto o consumo de sorvete quanto a frequência de
banhistas, logo o número de afogamentos). Essa terceira variável é
chamada de #strong[variável de confusão] (#emph[confounder]), e sua
omissão do modelo é a causa mais comum de correlação espúria.

=== 7.2. Viés de variável omitida (Omitted Variable Bias)
<viés-de-variável-omitida-omitted-variable-bias>
Formalmente: suponha que o modelo verdadeiro seja

$ y = beta_0 + beta_1 x_1 + beta_2 x_2 + u $

mas você estima, por falta de dados ou desconhecimento, apenas

$ y = beta_0 + tilde(beta)_1 x_1 + v $

Se $x_2$ (a variável omitida) está correlacionada com $x_1$ #strong[e]
afeta $y$ (isto é, $beta_2 eq.not 0$), então $tilde(beta)_1$ é um
estimador #strong[viesado] de $beta_1$ --- o viés não desaparece com
mais dados; ele é uma propriedade estrutural da má especificação do
modelo. A direção do viés segue uma regra prática:

$ upright("Viés") = beta_2 dot.op frac(upright("Cov")\(x_1\,x_2\), upright("Var")\(x_1\)) $

Ou seja: o viés é positivo quando $beta_2$ e a correlação entre $x_1$ e
$x_2$ têm o #strong[mesmo sinal], e negativo quando têm sinais opostos.

#strong[Exemplo econômico clássico:] estimar o retorno da educação sobre
o salário (equação de Mincer, ver Capítulo 10) omitindo a
#strong[habilidade inata] do indivíduo. Pessoas mais habilidosas tendem
a estudar mais (correlação positiva entre `escolaridade` e `habilidade`)
e a habilidade, por si só, também eleva o salário --- logo, uma
regressão simples de `salario` contra `escolaridade` tende a
#strong[superestimar] o verdadeiro retorno causal da educação,
atribuindo a ela parte do efeito que, na verdade, vem da habilidade
inata (não observada, e por isso frequentemente chamada de "viés de
habilidade" na literatura de economia do trabalho).

=== 7.3. Causalidade reversa
<causalidade-reversa>
Outro mecanismo que gera correlação sem causalidade (na direção
assumida) é a #strong[causalidade reversa]: $x$ parece afetar $y$, mas
na verdade é $y$ que afeta $x$, ou os dois se afetam mutuamente. Exemplo
clássico em macroeconomia: uma regressão simples de crescimento do PIB
contra gastos públicos em saúde pode mostrar correlação positiva --- mas
países mais ricos (PIB per capita mais alto) também têm mais recursos
para gastar em saúde, então parte da correlação vem do PIB
#strong[causando] mais gasto em saúde, não o oposto. Distinguir as duas
direções exige desenho de pesquisa (dados em painel com defasagens,
variáveis instrumentais, experimentos naturais) --- não é algo que uma
única regressão de corte transversal resolve.

=== 7.4. O padrão-ouro: desenho experimental vs.~dados observacionais
<o-padrão-ouro-desenho-experimental-vs.-dados-observacionais>
#figure(
  align(center)[#table(
    columns: (33.33%, 33.33%, 33.33%),
    align: (auto,auto,auto,),
    table.header([], [Experimento controlado], [Dados observacionais],),
    table.hline(),
    [#strong[Atribuição do tratamento]], [Aleatória (o pesquisador
    decide quem recebe o "tratamento")], [Não aleatória (as próprias
    pessoas/empresas/países "escolhem" seu valor de $x$)],
    [#strong[Variáveis de confusão]], [Balanceadas entre grupos por
    construção (a aleatorização "quebra" a correlação entre $x$ e
    possíveis confounders)], [Podem estar presentes e não observadas],
    [#strong[Exemplo em economia]], [Testes A/B de política pública (ex:
    transferência de renda condicionada, sorteada por loteria entre
    elegíveis)], [A maioria dos dados macro/micro disponíveis (PIB,
    inflação, salários)],
  )]
  , kind: table
  )

Como experimentos controlados são raros e caros em economia, a
disciplina desenvolveu métodos para se aproximar da lógica experimental
usando dados observacionais --- variáveis instrumentais (IV),
diferenças-em-diferenças (DiD), descontinuidade de regressão (RDD) ---
que ficam fora do escopo desta apostila introdutória, mas que valem
menção porque são a resposta metodológica ao problema deste capítulo,
não à correlação simples.

=== 7.5. Exemplo Resolvido --- Identificando um confounder plausível
<exemplo-resolvido-identificando-um-confounder-plausível>
#strong[Enunciado:] uma regressão simples mostra correlação positiva e
estatisticamente significativa entre `numero_de_bancos_centrais_no_pais`
(sempre 1, então descartado) --- na verdade, entre
`gasto_militar_per_capita` e `expectativa_de_vida` entre países. Antes
de concluir que gasto militar aumenta expectativa de vida, que variável
de confusão óbvia deveria ser investigada, e por quê?

#strong[Solução comentada:]

O candidato mais óbvio é o #strong[PIB per capita] (ou, de forma
equivalente, o nível de desenvolvimento econômico do país). Países mais
ricos tendem a ter tanto orçamento maior para gastos públicos em geral
(incluindo militar) quanto melhor infraestrutura de saúde, saneamento e
nutrição --- o que eleva diretamente a expectativa de vida,
independentemente do gasto militar em si. A correlação observada entre
gasto militar e expectativa de vida é plausivelmente #strong[espúria],
no sentido de ser inteiramente (ou majoritariamente) explicada pelo PIB
per capita como variável de confusão comum.

O teste correto #strong[não é] simplesmente "adicionar PIB per capita e
ver se o coeficiente de gasto militar continua significativo" (embora
seja um primeiro passo razoável) --- é reconhecer que, mesmo controlando
por PIB, poderiam existir outras variáveis de confusão não observadas
(qualidade institucional, por exemplo), e que a ausência de um desenho
experimental (Capítulo 7.4) significa que #strong[nenhuma regressão
observacional, por si só, estabelece causalidade com certeza] --- apenas
fornece evidência mais ou menos consistente com uma hipótese causal, a
depender de quão bem controlados estão os confounders plausíveis.

```python
# Passo mínimo de investigação: comparar coeficiente com e sem o confounder
simples = smf.ols("expectativa_vida ~ gasto_militar_per_capita", data=df).fit()
controlado = smf.ols("expectativa_vida ~ gasto_militar_per_capita + pib_per_capita", data=df).fit()

print(f"Sem controle:  {simples.params['gasto_militar_per_capita']:.4f}")
print(f"Com controle:  {controlado.params['gasto_militar_per_capita']:.4f}")
# Se o coeficiente cair para perto de zero (ou perder significância) ao
# controlar por PIB, isso reforça a hipótese de que a correlação original
# era espúria, mediada pelo PIB per capita.
```

#line()

== Capítulo 8 --- Multicolinearidade
<capítulo-8-multicolinearidade>
=== 8.1. O que é e por que é um problema
<o-que-é-e-por-que-é-um-problema>
Multicolinearidade ocorre quando duas ou mais variáveis explicativas
estão fortemente correlacionadas entre si. Tecnicamente, ela
#strong[não] viola nenhuma das premissas de Gauss-Markov necessárias
para que o OLS seja não viesado (desde que não haja colinearidade
#strong[perfeita] --- premissa 3) --- mas ela infla drasticamente a
#strong[variância] dos coeficientes estimados, tornando-os imprecisos e
instáveis: pequenas mudanças na amostra podem alterar substancialmente
$hat(beta)_1$ e $hat(beta)_2$, e às vezes até seus sinais.

A intuição: se `renda` e `poupanca` são quase colineares (como no
exemplo do Capítulo 6.3), o modelo tem dificuldade em "separar" o efeito
de uma da outra --- geometricamente, as duas variáveis se movem quase
juntas, então não há variação independente suficiente em cada uma para
estimar seu efeito isolado com precisão.

=== 8.2. Sintomas e o VIF (Variance Inflation Factor)
<sintomas-e-o-vif-variance-inflation-factor>
Um sintoma clássico: coeficientes individuais não significativos no
teste t (Capítulo 5), mas o teste F conjunto fortemente significativo
--- o modelo como um todo explica bem $y$, mas o software "não sabe" a
qual variável atribuir esse poder explicativo.

O diagnóstico formal é o #strong[Fator de Inflação da Variância] (VIF),
calculado para cada variável explicativa regredindo-a contra todas as
outras:

$ upright("VIF")_j = frac(1, 1 - R_j^2) $

onde $R_j^2$ é o $R^2$ de uma regressão auxiliar de $x_j$ contra todas
as demais variáveis explicativas do modelo. Um $upright("VIF")_j = 1$
indica ausência de colinearidade; a regra prática mais citada na
literatura é que $upright("VIF") > 10$ (equivalente a $R_j^2 > 0\,9$ na
regressão auxiliar) sinaliza multicolinearidade preocupante, embora
alguns autores usem o limiar mais conservador de 5.

```python
from statsmodels.stats.outliers_influence import variance_inflation_factor

X = sm.add_constant(df[["renda", "juros", "poupanca"]])
vif = pd.DataFrame()
vif["variavel"] = X.columns
vif["VIF"] = [variance_inflation_factor(X.values, i) for i in range(X.shape[1])]
print(vif)
```

=== 8.3. O que fazer diante de multicolinearidade
<o-que-fazer-diante-de-multicolinearidade>
#figure(
  align(center)[#table(
    columns: (50%, 50%),
    align: (auto,auto,),
    table.header([Estratégia], [Quando usar],),
    table.hline(),
    [Remover uma das variáveis redundantes], [Quando as duas variáveis
    medem, na prática, o mesmo conceito],
    [Combinar as variáveis num índice], [Quando ambas são dimensões
    legítimas de um mesmo construto (ex: índice de qualidade
    institucional)],
    [Aumentar o tamanho da amostra], [Reduz a variância dos coeficientes
    mesmo sem resolver a colinearidade em si],
    [Aceitar e reportar], [Quando o objetivo é apenas #strong[prever]
    $y$ (não interpretar $beta_j$ individualmente) ---
    multicolinearidade não prejudica a previsão do modelo como um todo],
  )]
  , kind: table
  )

O último item merece destaque: se o objetivo do modelo é puramente
preditivo (o valor de $hat(y)$ importa, não a interpretação de cada
$hat(beta)_j$ isoladamente), multicolinearidade é um problema bem menos
grave --- é precisamente quando se quer #strong[interpretar] cada
coeficiente separadamente que ela se torna uma preocupação central.

=== 8.4. Exemplo Resolvido --- Diagnosticando e corrigindo multicolinearidade
<exemplo-resolvido-diagnosticando-e-corrigindo-multicolinearidade>
#strong[Enunciado:] você suspeita que `juros` e `taxa_selic_media` (duas
variáveis do seu dataset) sejam quase a mesma coisa medida de formas
ligeiramente diferentes. Calcule o VIF de um modelo que inclui as duas e
decida o que fazer.

#strong[Solução comentada:]

```python
np.random.seed(0)
n = 100
juros = np.random.normal(10, 2, n)
taxa_selic_media = juros + np.random.normal(0, 0.1, n)  # quase idêntica a "juros"
y_sim = 100 + 2 * juros + np.random.normal(0, 5, n)

df_vif = pd.DataFrame({"juros": juros, "taxa_selic_media": taxa_selic_media, "y": y_sim})
X = sm.add_constant(df_vif[["juros", "taxa_selic_media"]])

vif = pd.DataFrame()
vif["variavel"] = X.columns
vif["VIF"] = [variance_inflation_factor(X.values, i) for i in range(X.shape[1])]
print(vif)
# VIF de "juros" e "taxa_selic_media" tipicamente na casa de centenas —
# muito acima do limiar de 10

modelo_colinear = sm.OLS(df_vif["y"], X).fit()
print(modelo_colinear.pvalues)  # provavelmente nenhum dos dois é individualmente significativo

# Correção: manter apenas uma das duas variáveis
X_corrigido = sm.add_constant(df_vif[["juros"]])
modelo_corrigido = sm.OLS(df_vif["y"], X_corrigido).fit()
print(modelo_corrigido.pvalues)  # agora "juros" é claramente significativo
```

O VIF confirma a suspeita (valores muito acima de 10), e o `summary()`
do modelo com as duas variáveis mostra exatamente o sintoma descrito no
item 8.2: nenhum dos dois coeficientes é individualmente significativo,
apesar de existir, de fato, uma relação forte entre `juros` e `y`. Ao
remover a variável redundante, o coeficiente restante recupera
significância --- a informação estava lá o tempo todo, apenas "diluída"
entre duas variáveis que carregavam essencialmente o mesmo conteúdo
informacional.

#line()

== Capítulo 9 --- Heterocedasticidade
<capítulo-9-heterocedasticidade>
=== 9.1. Revisitando o conceito
<revisitando-o-conceito>
Já introduzida no Capítulo 3.4: heterocedasticidade é a violação da
premissa de que a variância do erro é constante
($upright("Var")\(u\|x\)= sigma^2$ para todo $x$). O nome vem do grego
(#emph[hetero] = diferente, #emph[skedasis] = dispersão) --- o oposto,
variância constante, é a #strong[homocedasticidade].

=== 9.2. Consequência: coeficientes certos, confiança errada
<consequência-coeficientes-certos-confiança-errada>
Vale repetir, porque é frequentemente mal entendido: heterocedasticidade
#strong[não] torna $hat(beta)$ viesado --- o OLS continua sendo não
viesado. O que ela invalida são os erros-padrão calculados pela fórmula
usual do OLS, e por consequência os testes t, F e os intervalos de
confiança. Isso significa que um pesquisador pode, sem saber, reportar
uma variável como "estatisticamente significativa" (ou "não
significativa") quando o erro-padrão correto diria o contrário.

=== 9.3. Testando heterocedasticidade --- Breusch-Pagan e White
<testando-heterocedasticidade-breusch-pagan-e-white>
O #strong[teste de Breusch-Pagan] regride o quadrado dos resíduos
($hat(u)_i^2$) contra as variáveis explicativas do modelo original,
testando se essas variáveis ajudam a explicar a magnitude do erro:

$ H_0 : upright("homocedasticidade") quad upright("vs.") quad H_1 : upright("heterocedasticidade") $

```python
from statsmodels.stats.diagnostic import het_breuschpagan

residuos = modelo.resid
bp_test = het_breuschpagan(residuos, modelo.model.exog)
labels = ["LM Statistic", "LM p-valor", "F Statistic", "F p-valor"]
print(dict(zip(labels, bp_test)))
# Se p > 0.05: não rejeita H0 (homocedástico)
# Se p < 0.05: rejeita H0 (heterocedástico)
```

O #strong[teste de White] é uma generalização mais flexível (inclui
termos quadráticos e produtos cruzados das variáveis explicativas), com
a vantagem de não exigir suposição sobre a forma funcional da
heterocedasticidade, mas com o custo de menor poder estatístico em
amostras pequenas (mais parâmetros estimados na regressão auxiliar).

=== 9.4. Correção: erros-padrão robustos
<correção-erros-padrão-robustos>
A solução mais usada na prática #strong[não] é "consertar" o modelo, mas
recalcular os erros-padrão de forma que continuem válidos mesmo sob
heterocedasticidade --- os chamados #strong[erros-padrão robustos] (ou
"erros-padrão de White", ou HC ---
#emph[Heteroskedasticity-Consistent]). Os coeficientes estimados
($hat(beta)$) permanecem exatamente os mesmos; apenas os erros-padrão, e
por consequência os testes t/F e intervalos de confiança, mudam.

```python
# Erros-padrão robustos a heterocedasticidade (HC1 é uma correção comum)
modelo_robusto = sm.OLS(y, X).fit(cov_type="HC1")
print(modelo_robusto.summary())

# Compare os erros-padrão "normais" com os robustos
print("Normal:  ", modelo.bse.values)
print("Robusto: ", modelo_robusto.bse.values)
```

Em pesquisa econômica aplicada moderna, é considerada boa prática usar
erros-padrão robustos #strong[por padrão] em dados de corte transversal,
mesmo sem um teste formal de heterocedasticidade prévio --- o custo de
usá-los quando não são necessários é pequeno (os erros-padrão robustos
convergem para os usuais quando a homocedasticidade de fato vale),
enquanto o custo de não usá-los quando são necessários pode ser uma
inferência inteiramente equivocada.

=== 9.5. Exemplo Resolvido --- Heterocedasticidade no gasto com alimentação
<exemplo-resolvido-heterocedasticidade-no-gasto-com-alimentação>
#strong[Enunciado:] retomando o cenário do Capítulo 3.4 (gasto com
alimentação vs.~renda, com variância do erro crescente na renda), simule
os dados, teste formalmente a heterocedasticidade com Breusch-Pagan, e
compare os erros-padrão usuais com os robustos.

#strong[Solução comentada:]

```python
np.random.seed(1)
n = 300
renda_fam = np.random.uniform(1000, 20000, n)
# erro com variancia crescente na renda -> heterocedasticidade por construcao
erro = np.random.normal(0, 1, n) * (renda_fam / 2000)
gasto_alimentacao = 300 + 0.15 * renda_fam + erro

df_hetero = pd.DataFrame({"renda": renda_fam, "gasto": gasto_alimentacao})
X = sm.add_constant(df_hetero["renda"])
y = df_hetero["gasto"]

modelo = sm.OLS(y, X).fit()

bp_test = het_breuschpagan(modelo.resid, modelo.model.exog)
print(f"Breusch-Pagan p-valor: {bp_test[1]:.6f}")  # tipicamente muito < 0.05

modelo_robusto = sm.OLS(y, X).fit(cov_type="HC1")

print(f"SE(renda) usual:   {modelo.bse['renda']:.5f}")
print(f"SE(renda) robusto:  {modelo_robusto.bse['renda']:.5f}")
```

O teste de Breusch-Pagan rejeita fortemente a homocedasticidade (p-valor
muito abaixo de 0,05), confirmando o padrão de "leque" esperado por
construção dos dados. Nesse tipo de heterocedasticidade (variância
crescendo com o nível de $x$), é comum que o erro-padrão robusto seja
#strong[maior] que o usual --- o que significa que o modelo OLS
"ingênuo" estava #strong[superestimando a precisão] do coeficiente de
`renda`, um erro que, sem o teste e a correção, passaria despercebido no
`summary()` padrão.

#line()

== Capítulo 10 --- Variáveis Dummy e a Equação de Mincer
<capítulo-10-variáveis-dummy-e-a-equação-de-mincer>
=== 10.1. Codificando categorias como números
<codificando-categorias-como-números>
Regressão linear opera sobre números, mas muitas variáveis econômicas
relevantes são categóricas: região, gênero, setor de atividade, regime
cambial. A solução é a #strong[variável dummy] (ou #emph[indicadora]):
uma variável que assume valor 1 quando uma categoria está presente, e 0
caso contrário.

```python
df["dummy_sul"] = (df["regiao"] == "Sul").astype(int)
# ou, de forma automática para múltiplas categorias:
dummies = pd.get_dummies(df["regiao"], prefix="regiao", drop_first=True)
```

=== 10.2. A armadilha da dummy (dummy trap)
<a-armadilha-da-dummy-dummy-trap>
Se uma variável categórica tem $m$ categorias (por exemplo, 5 regiões do
Brasil), deve-se incluir no modelo apenas $m - 1$ dummies, nunca as $m$
--- a categoria excluída se torna a #strong[categoria de referência] (ou
#emph[baseline]), contra a qual todas as demais são comparadas. Incluir
as $m$ dummies #strong[e] o intercepto gera colinearidade perfeita (a
soma de todas as dummies é sempre igual a 1, exatamente igual à coluna
de constante) --- o software geralmente detecta isso e descarta uma
coluna automaticamente, mas contar com esse comportamento automático é
frágil; melhor especificar `drop_first=True` explicitamente, como no
Capítulo 10.1.

=== 10.3. A Equação de Mincer: retornos à educação
<a-equação-de-mincer-retornos-à-educação>
Um dos modelos mais replicados em economia do trabalho é a
#strong[equação de Mincer] (Jacob Mincer, 1974), que relaciona o
logaritmo do salário à escolaridade e à experiência:

$ ln\(upright("salário")\)= beta_0 + beta_1 dot.op upright("escolaridade") + beta_2 dot.op upright("experiência") + beta_3 dot.op upright("experiência")^2 + u $

O uso do log do salário (em vez do salário em nível) e o termo
quadrático de experiência serão explicados formalmente no Capítulo 11
--- por ora, o ponto de interesse é como incorporar uma dummy de gênero
para estimar o chamado "hiato salarial" (#emph[gender wage gap]):

```python
np.random.seed(7)
n = 500
escolaridade = np.random.randint(4, 18, n)
experiencia = np.random.randint(0, 40, n)
mulher = np.random.binomial(1, 0.5, n)

# Hiato salarial simulado de -15% para mulheres, ceteris paribus
log_salario = (7.0 + 0.10 * escolaridade + 0.03 * experiencia
               - 0.0004 * experiencia**2 - 0.15 * mulher
               + np.random.normal(0, 0.3, n))

df_mincer = pd.DataFrame({
    "log_salario": log_salario, "escolaridade": escolaridade,
    "experiencia": experiencia, "mulher": mulher
})

modelo_mincer = smf.ols(
    "log_salario ~ escolaridade + experiencia + I(experiencia**2) + mulher",
    data=df_mincer
).fit()
print(modelo_mincer.summary())
```

=== 10.4. Interpretando o coeficiente de uma dummy em modelo log-linear
<interpretando-o-coeficiente-de-uma-dummy-em-modelo-log-linear>
Quando a variável dependente está em log e o regressor é uma dummy, a
interpretação exata do coeficiente #strong[não é simplesmente
"multiplicar por 100"] --- para coeficientes grandes, a aproximação
usual (Capítulo 11.2) tem um viés conhecido. A interpretação exata
(correção de Halvorsen-Palmquist) é:

$ % Delta y = (e^(hat(beta)) - 1) times 100 $

```python
beta_mulher = modelo_mincer.params["mulher"]
efeito_aproximado = beta_mulher * 100
efeito_exato = (np.exp(beta_mulher) - 1) * 100

print(f"Efeito aproximado: {efeito_aproximado:.2f}%")
print(f"Efeito exato:       {efeito_exato:.2f}%")
```

Para $hat(beta)_(upright("mulher")) approx - 0\,15$, a aproximação
simples ($- 15\,0 %$) e a fórmula exata (algo em torno de $- 13\,9 %$)
já divergem de forma perceptível --- a diferença cresce com a magnitude
do coeficiente, e é mais um motivo para preferir sempre a fórmula exata
em variáveis dummy, cujo coeficiente costuma ser maior, em valor
absoluto, do que os coeficientes de variáveis contínuas.

=== 10.5. Interação entre dummy e variável contínua
<interação-entre-dummy-e-variável-contínua>
Uma pergunta natural de pesquisa é: "o retorno da escolaridade sobre o
salário é o mesmo para homens e mulheres?" Isso se testa com um
#strong[termo de interação] --- o produto entre a dummy e a variável
contínua:

```python
modelo_interacao = smf.ols(
    "log_salario ~ escolaridade * mulher + experiencia + I(experiencia**2)",
    data=df_mincer
).fit()
print(modelo_interacao.summary())
# "escolaridade * mulher" no statsmodels expande automaticamente para
# escolaridade + mulher + escolaridade:mulher (o termo de interação)
```

O coeficiente de `escolaridade:mulher` mede a #strong[diferença] no
retorno da escolaridade entre mulheres e homens --- se for
estatisticamente significativo, é evidência de que a inclinação da
relação escolaridade-salário difere por gênero, não apenas o intercepto
(o "nível" do salário).

=== 10.6. Exemplo Resolvido --- Decompondo o hiato salarial estimado
<exemplo-resolvido-decompondo-o-hiato-salarial-estimado>
#strong[Enunciado:] usando o modelo `modelo_mincer` do item 10.3,
calcule o hiato salarial exato (fórmula de Halvorsen-Palmquist) e
verifique se ele é estatisticamente diferente de zero. Depois, discuta
por que este número, mesmo sendo estatisticamente significativo, não
deveria ser automaticamente interpretado como "discriminação" no mercado
de trabalho.

#strong[Solução comentada:]

```python
beta = modelo_mincer.params["mulher"]
p_valor = modelo_mincer.pvalues["mulher"]
hiato_exato = (np.exp(beta) - 1) * 100

print(f"Hiato salarial estimado: {hiato_exato:.2f}%")
print(f"p-valor: {p_valor:.4f}")
```

O modelo estima um hiato de aproximadamente 14% (mulheres ganhando, em
média, 14% menos que homens de mesma escolaridade e experiência), com
p-valor tipicamente muito baixo dado o tamanho da amostra simulada
(n=500) --- estatisticamente significativo.

O ponto de discussão crítica: o coeficiente de `mulher` captura
#strong[toda] a diferença salarial entre os grupos que não é explicada
por `escolaridade` e `experiência` --- mas isso inclui, potencialmente,
discriminação #strong[e] qualquer outro fator não observado
correlacionado com gênero e não incluído no modelo (diferenças em setor
de atuação, jornada de trabalho, interrupções de carreira por
licença-maternidade, negociação salarial, entre outros --- a literatura
de economia do trabalho sobre o tema é extensa precisamente por essa
dificuldade de identificação). Isso é exatamente o problema de
#strong[viés de variável omitida] do Capítulo 7.2 aplicado a este
contexto específico: o coeficiente de uma dummy num modelo com controles
limitados é, na melhor das hipóteses, um limite superior para o
componente puramente discriminatório do hiato --- não uma medida isolada
e definitiva dele.

#line()

== Capítulo 11 --- Transformações Logarítmicas e Elasticidades
<capítulo-11-transformações-logarítmicas-e-elasticidades>
=== 11.1. Por que usar logaritmo
<por-que-usar-logaritmo>
Três motivos práticos levam economistas a trabalhar frequentemente com o
log de variáveis monetárias (PIB, salário, preços): (1) variáveis
econômicas costumam ter distribuição assimétrica à direita (poucos
valores muito altos, muitos valores baixos/moderados) --- o log aproxima
essa distribuição de uma normal, ajudando a satisfazer a premissa de
normalidade dos erros; (2) o log estabiliza a variância, atenuando
heterocedasticidade (Capítulo 9) quando ela decorre da escala da
variável; e (3), o motivo mais citado na prática, o log transforma
#strong[variações absolutas em variações percentuais], o que confere aos
coeficientes uma interpretação de #strong[elasticidade] --- a métrica
preferida em teoria econômica.

=== 11.2. As quatro combinações log/nível e suas interpretações
<as-quatro-combinações-lognível-e-suas-interpretações>
#figure(
  align(center)[#table(
    columns: (33.33%, 33.33%, 33.33%),
    align: (auto,auto,auto,),
    table.header([Especificação], [Modelo], [Interpretação de $beta_1$],),
    table.hline(),
    [#strong[Linear-linear
    (nível-nível)]], [$y = beta_0 + beta_1 x + u$], [Uma unidade a mais
    em $x$ está associada a $beta_1$ unidades a mais em $y$],
    [#strong[Log-linear] (variável dependente em
    log)], [$ln\(y\)= beta_0 + beta_1 x + u$], [Uma unidade a mais em
    $x$ está associada a uma variação de $\(beta_1 times 100\)%$ em $y$
    (#strong[semi-elasticidade])],
    [#strong[Linear-log] (variável explicativa em
    log)], [$y = beta_0 + beta_1 ln\(x\)+ u$], [Um aumento de 1% em $x$
    está associado a uma variação de $\(beta_1\/100\)$ unidades em $y$],
    [#strong[Log-log]], [$ln\(y\)= beta_0 + beta_1 ln\(x\)+ u$], [Um
    aumento de 1% em $x$ está associado a uma variação de $beta_1 %$ em
    $y$ (#strong[elasticidade constante])],
  )]
  , kind: table
  )

A forma #strong[log-log] é a mais usada em economia sempre que o
parâmetro de interesse teórico já é, por definição, uma elasticidade ---
elasticidade-preço da demanda, elasticidade-renda,
elasticidade-substituição entre insumos --- porque, nesse caso,
$hat(beta)_1$ #strong[é diretamente] a elasticidade estimada, sem
necessidade de conversão.

=== 11.3. Exemplo clássico: elasticidade-renda da demanda (Curva de Engel)
<exemplo-clássico-elasticidade-renda-da-demanda-curva-de-engel>
A #strong[Curva de Engel] descreve como o consumo de um bem varia com a
renda. Estimando-a em log-log, o coeficiente da renda é diretamente a
#strong[elasticidade-renda da demanda]:

$ ln\(upright("quantidade demandada")\)= beta_0 + beta_1 ln\(upright("renda")\)+ u $

```python
np.random.seed(3)
n = 200
renda_domicilio = np.random.lognormal(8.5, 0.6, n)
# elasticidade-renda de 0.6 (bem normal, mas "necessidade" -- cresce menos que renda)
qtd_alimento = 2 * renda_domicilio**0.6 * np.random.lognormal(0, 0.15, n)

df_engel = pd.DataFrame({"renda": renda_domicilio, "qtd": qtd_alimento})
df_engel["log_renda"] = np.log(df_engel["renda"])
df_engel["log_qtd"] = np.log(df_engel["qtd"])

modelo_engel = smf.ols("log_qtd ~ log_renda", data=df_engel).fit()
print(f"Elasticidade-renda estimada: {modelo_engel.params['log_renda']:.3f}")
```

A classificação econômica do bem depende diretamente dessa elasticidade
estimada:

#figure(
  align(center)[#table(
    columns: (50%, 50%),
    align: (auto,auto,),
    table.header([Elasticidade-renda ($beta_1$)], [Classificação do
      bem],),
    table.hline(),
    [$beta_1 < 0$], [Bem inferior (consumo cai quando a renda sobe)],
    [$0 < beta_1 < 1$], [Bem normal, necessidade (cresce mais devagar
    que a renda)],
    [$beta_1 > 1$], [Bem normal, de luxo (cresce mais rápido que a
    renda)],
  )]
  , kind: table
  )

=== 11.4. Cuidado com valores zero ou negativos
<cuidado-com-valores-zero-ou-negativos>
$ln\(x\)$ não é definido para $x lt.eq 0$. Isso é um problema prático
recorrente com dados econômicos reais: lucro pode ser negativo, algumas
observações de gasto podem ser exatamente zero. Não existe solução
universalmente aceita --- algumas práticas comuns (cada uma com suas
próprias críticas na literatura) são usar $ln\(x + 1\)$ quando
$x gt.eq 0$ pode ser zero, ou restringir a amostra às observações
estritamente positivas quando isso é economicamente justificável,
documentando sempre a escolha feita.

=== 11.5. Exemplo Resolvido --- Elasticidade-preço da demanda
<exemplo-resolvido-elasticidade-preço-da-demanda>
#strong[Enunciado:] dados simulados de preço e quantidade demandada de
um bem, estime a elasticidade-preço da demanda em log-log e classifique
a demanda como elástica ou inelástica.

```python
np.random.seed(11)
n = 150
preco = np.random.uniform(2, 20, n)
qtd_demandada = 500 * preco**(-1.3) * np.random.lognormal(0, 0.1, n)
```

#strong[Solução comentada:]

```python
df_demanda = pd.DataFrame({"preco": preco, "qtd": qtd_demandada})
df_demanda["log_preco"] = np.log(df_demanda["preco"])
df_demanda["log_qtd"] = np.log(df_demanda["qtd"])

modelo_demanda = smf.ols("log_qtd ~ log_preco", data=df_demanda).fit()
elasticidade_preco = modelo_demanda.params["log_preco"]

print(f"Elasticidade-preço da demanda: {elasticidade_preco:.3f}")
if abs(elasticidade_preco) > 1:
    print("Demanda ELÁSTICA (variação percentual na quantidade > variação no preço)")
else:
    print("Demanda INELÁSTICA (variação percentual na quantidade < variação no preço)")
```

A elasticidade estimada deve ficar próxima de $- 1\,3$ (o valor usado
para simular os dados), confirmando demanda #strong[elástica]: um
aumento de 1% no preço reduz a quantidade demandada em aproximadamente
1,3%. Isso tem implicação direta de política de precificação: para um
bem com demanda elástica, um aumento de preço reduz a #strong[receita
total] ($P times Q$), porque a queda percentual em $Q$ supera o aumento
percentual em $P$ --- o tipo de conclusão que só emerge naturalmente de
uma especificação log-log, e que exigiria cálculo adicional numa
especificação em nível.

#line()

== Capítulo 12 --- Autocorrelação e a Curva de Phillips
<capítulo-12-autocorrelação-e-a-curva-de-phillips>
=== 12.1. O que é autocorrelação e por que é comum em séries temporais
<o-que-é-autocorrelação-e-por-que-é-comum-em-séries-temporais>
Autocorrelação (ou correlação serial) ocorre quando o erro de um período
está correlacionado com o erro de período(s) anterior(es):
$upright("Cov")\(u_t\,u_(t - 1)\)eq.not 0$. É a violação, em contexto de
séries temporais, de uma premissa análoga à premissa 5 (Capítulo 3), e é
#strong[extremamente comum] em dados macroeconômicos --- choques que
afetam a economia (uma crise, uma mudança de política monetária)
tipicamente têm efeitos que persistem por vários períodos, não apenas no
período em que ocorrem, gerando erros correlacionados ao longo do tempo
mesmo quando o modelo está corretamente especificado.

Assim como a heterocedasticidade, a autocorrelação não viesa
$hat(beta)$, mas invalida os erros-padrão usuais do OLS --- tipicamente
#strong[subestimando-os], o que faz variáveis parecerem mais
significativas do que realmente são (o oposto do padrão mais comum de
heterocedasticidade).

=== 12.2. Testando autocorrelação: Durbin-Watson
<testando-autocorrelação-durbin-watson>
O teste de #strong[Durbin-Watson] é o mais tradicional, definido como:

$ upright("DW") = frac(sum_(t = 2)^n\(hat(u)_t - hat(u)_(t - 1)\)^2, sum_(t = 1)^n hat(u)_t^2) $

```python
from statsmodels.stats.stattools import durbin_watson

dw = durbin_watson(modelo.resid)
print(f"Durbin-Watson: {dw:.4f}")
```

#figure(
  align(center)[#table(
    columns: (50%, 50%),
    align: (auto,auto,),
    table.header([Valor de DW], [Interpretação],),
    table.hline(),
    [Próximo de 2], [Sem evidência de autocorrelação],
    [Próximo de 0 (\< 1,5, regra prática)], [Autocorrelação positiva
    forte (erro de hoje parecido com o de ontem)],
    [Próximo de 4 (\> 2,5, regra prática)], [Autocorrelação negativa
    (erro de hoje tende a ser oposto ao de ontem)],
  )]
  , kind: table
  )

O teste de Durbin-Watson tem uma limitação relevante: só testa
autocorrelação de #strong[primeira ordem] (defasagem de 1 período) e
exige que o modelo tenha intercepto e não tenha a variável dependente
defasada como regressor. Para defasagens múltiplas, usa-se o teste de
#strong[Breusch-Godfrey], mais geral.

=== 12.3. Correção: erros-padrão de Newey-West
<correção-erros-padrão-de-newey-west>
Análogo aos erros-padrão robustos a heterocedasticidade (Capítulo 9.4),
existem erros-padrão robustos a autocorrelação (e heterocedasticidade
simultaneamente) --- os erros-padrão de #strong[Newey-West] (HAC ---
#emph[Heteroskedasticity and Autocorrelation Consistent]):

```python
modelo_hac = sm.OLS(y, X).fit(cov_type="HAC", cov_kwds={"maxlags": 2})
print(modelo_hac.summary())
```

O parâmetro `maxlags` define até que defasagem a autocorrelação é
considerada na correção --- uma escolha que, na prática, costuma seguir
a regra empírica $upright("maxlags") approx 0\,75 dot.op n^(1\/3)$
(Newey e West, 1994) ou ser fixada com base na periodicidade dos dados
(por exemplo, 12 para dados mensais, quando se espera sazonalidade
residual nos erros).

=== 12.4. Exemplo Resolvido --- A Curva de Phillips completa, com diagnóstico
<exemplo-resolvido-a-curva-de-phillips-completa-com-diagnóstico>
#strong[Enunciado:] estime a Curva de Phillips com dados reais do BCB
(IPCA contra taxa de desemprego e IPCA defasado), teste autocorrelação
nos resíduos, e reporte o modelo com a correção apropriada se
necessário.

#strong[Solução comentada:]

```python
ipca = sgs.get({"ipca": 433}, start="2012-01-01")
desemprego = sgs.get({"desemprego": 24369}, start="2012-01-01")

df = pd.merge(ipca, desemprego, on="Date")
df["ipca_lag1"] = df["ipca"].shift(1)
df = df.dropna()

X = sm.add_constant(df[["desemprego", "ipca_lag1"]])
y = df["ipca"]
modelo = sm.OLS(y, X).fit()

dw = durbin_watson(modelo.resid)
print(f"Durbin-Watson: {dw:.4f}")

if dw < 1.5 or dw > 2.5:
    print("Evidência de autocorrelação — recorrendo a erros-padrão HAC")
    modelo_final = sm.OLS(y, X).fit(cov_type="HAC", cov_kwds={"maxlags": 4})
else:
    print("Sem evidência forte de autocorrelação — erros-padrão usuais são razoáveis")
    modelo_final = modelo

print(modelo_final.summary())
print(f"\nCoeficiente desemprego: {modelo_final.params['desemprego']:.4f}")
print(f"P-valor (com correção, se aplicável): {modelo_final.pvalues['desemprego']:.4f}")
```

Dados de inflação mensal frequentemente exibem `Durbin-Watson` abaixo de
1,5, refletindo a persistência natural de choques inflacionários (um
choque de custos, por exemplo, tende a se propagar por vários meses via
reajustes de contratos e expectativas). Isso reforça por que a inclusão
de `ipca_lag1` como regressor já é, em parte, uma tentativa de capturar
essa dinâmica dentro do próprio modelo --- mas mesmo assim é prudente
checar se ainda resta autocorrelação residual não capturada, e reportar
erros-padrão HAC quando ela persistir, em vez de confiar cegamente nos
erros-padrão do OLS simples.

#line()

== Capítulo 13 --- Dados em Painel
<capítulo-13-dados-em-painel>
=== 13.1. O que é um painel e por que ele resolve parte do problema de exogeneidade
<o-que-é-um-painel-e-por-que-ele-resolve-parte-do-problema-de-exogeneidade>
Dados em #strong[painel] combinam a dimensão de corte transversal
(várias unidades --- países, empresas, indivíduos) com a dimensão
temporal (várias observações ao longo do tempo para cada unidade). A
grande vantagem sobre um corte transversal puro é permitir controlar por
características #strong[não observadas, mas fixas ao longo do tempo], de
cada unidade --- os chamados #strong[efeitos fixos individuais], um
instrumento poderoso contra o viés de variável omitida do Capítulo 7, na
medida em que a variável omitida seja constante no tempo (ex: cultura
institucional de um país, "qualidade de gestão" não mensurada de uma
empresa).

```python
np.random.seed(42)
anos = range(2010, 2025)
paises = ["Brasil", "Chile", "Colômbia", "Peru", "México"]

dados = []
for pais in paises:
    efeito_fixo = np.random.normal(0, 1)  # característica não observada, fixa no tempo
    for ano in anos:
        pib = 2.0 + efeito_fixo + 0.5 * (ano - 2010) + np.random.normal(0, 1)
        inflacao = np.random.gamma(2, 2) + efeito_fixo
        dados.append({"pais": pais, "ano": ano, "pib": pib, "inflacao": inflacao})

df_painel = pd.DataFrame(dados)
```

=== 13.2. Pooled OLS vs.~Efeitos Fixos
<pooled-ols-vs.-efeitos-fixos>
O #strong[Pooled OLS] simplesmente ignora a estrutura de painel,
tratando cada observação (país-ano) como independente:

```python
X = sm.add_constant(df_painel[["inflacao"]])
y = df_painel["pib"]
pooled = sm.OLS(y, X).fit()
print("POOLED OLS")
print(pooled.summary())
```

O problema: se `efeito_fixo` (não observado) está correlacionado com
`inflacao` --- como está, por construção, neste exemplo simulado --- o
Pooled OLS sofre exatamente o viés de variável omitida do Capítulo 7.2.
O modelo de #strong[Efeitos Fixos] resolve isso introduzindo uma dummy
para cada unidade (país), absorvendo qualquer característica não
observada que seja #strong[constante no tempo] para aquela unidade:

```python
X_fe = sm.add_constant(pd.get_dummies(df_painel[["inflacao", "pais"]], columns=["pais"], drop_first=True))
y = df_painel["pib"]
fe = sm.OLS(y, X_fe).fit()
print("\nEFEITOS FIXOS (via dummies)")
print(fe.summary())
```

Na prática, a biblioteca `linearmodels` oferece uma sintaxe mais direta
e eficiente (sem precisar criar manualmente uma dummy por país):

```python
from linearmodels.panel import PanelOLS, RandomEffects

df_idx = df_painel.set_index(["pais", "ano"])

fe = PanelOLS.from_formula("pib ~ inflacao + EntityEffects", data=df_idx)
print(fe.fit())

re = RandomEffects.from_formula("pib ~ inflacao", data=df_idx)
print(re.fit())
```

=== 13.3. Efeitos fixos vs.~efeitos aleatórios: o Teste de Hausman
<efeitos-fixos-vs.-efeitos-aleatórios-o-teste-de-hausman>
O modelo de #strong[Efeitos Aleatórios] trata o efeito específico da
unidade como parte do termo de erro (aleatório, não correlacionado com
os regressores) --- é mais eficiente (erros-padrão menores) que efeitos
fixos #strong[se] essa suposição de não correlação for válida, mas é
#strong[inconsistente] (viesado mesmo com amostra infinita) se ela não
for. O #strong[Teste de Hausman] compara os dois formalmente:

$ H_0 : upright("efeitos aleatórios são consistentes (não há correlação entre efeito individual e regressores)") $

```python
from linearmodels.panel import compare
print(compare({"FE": fe.fit(), "RE": re.fit()}))
```

Regra prática de decisão: se o teste de Hausman #strong[rejeita] $H_0$
(p-valor baixo), use efeitos fixos --- há evidência de que o efeito
específico da unidade está correlacionado com os regressores, e efeitos
aleatórios estaria viesado. Se #strong[não rejeita], efeitos aleatórios
é preferível por ser mais eficiente (aproveita melhor a variação entre
unidades, não apenas dentro de cada unidade ao longo do tempo).

=== 13.4. Exemplo Resolvido --- Comparando Pooled, FE e RE na prática
<exemplo-resolvido-comparando-pooled-fe-e-re-na-prática>
#strong[Enunciado:] usando os dados simulados de `df_painel` (onde, por
construção, `efeito_fixo` está correlacionado com `inflacao`), compare o
coeficiente de `inflacao` nos três modelos (Pooled, FE, RE) e discuta
qual deveria ser mais confiável neste caso específico.

#strong[Solução comentada:]

```python
X_pooled = sm.add_constant(df_painel["inflacao"])
pooled = sm.OLS(df_painel["pib"], X_pooled).fit()

df_idx = df_painel.set_index(["pais", "ano"])
fe_res = PanelOLS.from_formula("pib ~ inflacao + EntityEffects", data=df_idx).fit()
re_res = RandomEffects.from_formula("pib ~ inflacao", data=df_idx).fit()

print(f"Pooled OLS: {pooled.params['inflacao']:.4f}")
print(f"Efeitos Fixos: {fe_res.params['inflacao']:.4f}")
print(f"Efeitos Aleatórios: {re_res.params['inflacao']:.4f}")
```

Como, por construção, `efeito_fixo` afeta tanto `pib` quanto `inflacao`
(ambos somam `efeito_fixo` na simulação), o Pooled OLS tende a produzir
um coeficiente de `inflacao` #strong[viesado] --- capturando parte do
efeito de `efeito_fixo`, que fica escondido no termo de erro. O modelo
de Efeitos Fixos, ao introduzir uma dummy por país, absorve exatamente
essa fonte de viés (qualquer característica constante do país, observada
ou não, é removida da comparação), tornando o coeficiente de `inflacao`
estimado #strong[dentro de cada país ao longo do tempo] --- mais próximo
do verdadeiro efeito causal simulado, neste caso controlado. O modelo de
Efeitos Aleatórios, por assumir (incorretamente, neste exemplo) que o
efeito individual não é correlacionado com `inflacao`, tende a ficar
mais próximo do Pooled OLS viesado do que do Efeitos Fixos ---
exatamente o cenário em que o Teste de Hausman rejeitaria a adequação de
efeitos aleatórios.

#line()

== Capítulo 14 --- Séries Temporais: Estacionariedade
<capítulo-14-séries-temporais-estacionariedade>
=== 14.1. Por que estacionariedade importa
<por-que-estacionariedade-importa>
Uma série temporal é #strong[estacionária] (em sentido fraco) quando sua
média, variância e estrutura de autocorrelação não mudam ao longo do
tempo. A maior parte da teoria de séries temporais (incluindo tudo o que
vem no Capítulo 15) pressupõe estacionariedade --- regredir uma série
não estacionária contra outra não estacionária pode produzir o fenômeno
da #strong[regressão espúria]: $R^2$ e estatísticas t enganosamente
altos entre duas séries que não têm nenhuma relação causal real, apenas
porque ambas têm tendência.

O exemplo didático clássico (Granger e Newbold, 1974): regredir o PIB do
Brasil contra a população da Índia ao longo do tempo produziria, quase
certamente, um coeficiente "significativo" --- porque ambas as séries
#strong[crescem] ao longo do tempo (tendência), não porque exista
qualquer relação causal.

=== 14.2. Raiz unitária e passeio aleatório
<raiz-unitária-e-passeio-aleatório>
O caso canônico de série não estacionária é o #strong[passeio aleatório]
(#emph[random walk]): $y_t = y_(t - 1) + epsilon_t$. Séries de preços de
ativos financeiros e, em boa aproximação, muitas séries macroeconômicas
em nível (PIB, índice de preços) se comportam como passeios aleatórios
ou próximo disso --- tecnicamente, dizem ter uma #strong[raiz unitária].

=== 14.3. O teste ADF (Augmented Dickey-Fuller)
<o-teste-adf-augmented-dickey-fuller>
O teste mais usado para diagnosticar raiz unitária é o #strong[ADF]:

$ H_0 : upright("a série tem raiz unitária (não é estacionária)") quad upright("vs.") quad H_1 : upright("a série é estacionária") $

Repare que a hipótese nula do ADF é o #strong[oposto] do padrão usual em
outros testes deste capítulo (onde $H_0$ costuma ser "nenhum problema")
--- aqui, $H_0$ é "a série TEM o problema" (raiz unitária). Isso
significa que #strong[não rejeitar] $H_0$ (p-valor alto) é a má notícia
(série não estacionária), e #strong[rejeitar] $H_0$ (p-valor baixo) é a
boa notícia (série estacionária) --- o inverso do que a intuição de "p
baixo é ruim" sugeriria em outros contextos, e uma fonte comum de
confusão.

```python
from statsmodels.tsa.stattools import adfuller

ipca = sgs.get({"ipca": 433}, start="2000-01-01")
result = adfuller(ipca["ipca"].dropna())

print(f"ADF Statistic: {result[0]:.4f}")
print(f"p-valor: {result[1]:.4f}")
print("Valores críticos:")
for chave, valor in result[4].items():
    print(f"  {chave}: {valor:.4f}")

# Se p-valor < 0.05: rejeita H0 -> série é estacionária
```

=== 14.4. O que fazer com uma série não estacionária: diferenciação
<o-que-fazer-com-uma-série-não-estacionária-diferenciação>
Quando o ADF não rejeita $H_0$ (série não estacionária), a correção mais
comum é #strong[diferenciar] a série --- trabalhar com
$Delta y_t = y_t - y_(t - 1)$ em vez de $y_t$ em nível. Séries que se
tornam estacionárias após uma diferenciação são chamadas
#strong[integradas de ordem 1], denotadas $I\(1\)$\; séries já
estacionárias em nível são $I\(0\)$. Esse "$d$" (grau de diferenciação
necessário) é exatamente o parâmetro $d$ do modelo ARIMA($p\,d\,q$),
assunto do próximo capítulo.

```python
ipca_diff = ipca["ipca"].diff().dropna()
result_diff = adfuller(ipca_diff)
print(f"ADF (série diferenciada) p-valor: {result_diff[1]:.4f}")
```

=== 14.5. Exemplo Resolvido --- Diagnosticando estacionariedade da Selic
<exemplo-resolvido-diagnosticando-estacionariedade-da-selic>
#strong[Enunciado:] teste se a série da taxa Selic (nível) é
estacionária. Se não for, diferencie e teste novamente. Interprete o
resultado economicamente.

#strong[Solução comentada:]

```python
selic = sgs.get({"selic": 11}, start="2000-01-01").dropna()

result_nivel = adfuller(selic["selic"])
print(f"Selic (nível) — p-valor ADF: {result_nivel[1]:.4f}")

if result_nivel[1] > 0.05:
    print("Não estacionária em nível — diferenciando...")
    selic_diff = selic["selic"].diff().dropna()
    result_diff = adfuller(selic_diff)
    print(f"Selic (diferenciada) — p-valor ADF: {result_diff[1]:.4f}")
```

É comum que a Selic em #strong[nível] não rejeite a hipótese de raiz
unitária --- faz sentido econômico, já que a taxa de juros passa longos
períodos em patamares específicos definidos pela política monetária, sem
reverter rapidamente a uma média fixa de longo prazo (o Banco Central
muda a meta e a série "persiste" no novo patamar por vários meses ou
anos, um comportamento consistente com não estacionariedade em amostras
finitas). Já a série #strong[diferenciada] (a variação da Selic reunião
a reunião) tende a ser estacionária, porque reflete decisões de ajuste
que não se acumulam indefinidamente na mesma direção --- o Copom sobe e
desce a taxa ao longo dos ciclos, então $Delta upright("Selic")$ oscila
em torno de zero, sem tendência de longo prazo.

#line()

== Capítulo 15 --- ARIMA, Cointegração, VAR e Causalidade de Granger
<capítulo-15-arima-cointegração-var-e-causalidade-de-granger>
=== 15.1. Modelos ARIMA
<modelos-arima>
Um modelo #strong[ARIMA(p, d, q)] combina três componentes: #strong[AR]
(autorregressivo, de ordem $p$ --- a série depende de seus próprios
valores passados), #strong[I] (integrado, de ordem $d$ --- quantas
diferenciações são necessárias para estacionariedade, Capítulo 14.4) e
#strong[MA] (médias móveis, de ordem $q$ --- a série depende de erros
passados).

$ y_t = c + sum_(i = 1)^p phi.alt_i y_(t - i) + sum_(j = 1)^q theta_j epsilon_(t - j) + epsilon_t $

\(equação escrita para a série já diferenciada $d$ vezes, se $d > 0$).

```python
from statsmodels.tsa.arima.model import ARIMA
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf

ipca = sgs.get({"ipca": 433}, start="2000-01-01")

# ACF e PACF ajudam a identificar p e q "a olho"
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 8))
plot_acf(ipca["ipca"], lags=24, ax=ax1)
plot_pacf(ipca["ipca"], lags=24, ax=ax2)
fig.tight_layout()

modelo_arima = ARIMA(ipca["ipca"], order=(1, 0, 1))
resultado = modelo_arima.fit()
print(resultado.summary())

forecast = resultado.forecast(steps=12)
print("Previsão para os próximos 12 meses:")
print(forecast)
```

A seleção de $\(p\,d\,q\)$ pode ser guiada visualmente pelos gráficos
ACF/PACF, ou automatizada por busca em grade, escolhendo a combinação
com menor #strong[AIC] (Critério de Informação de Akaike, que penaliza
modelos com mais parâmetros, análogo em espírito ao $R^2$ ajustado do
Capítulo 4.2):

```python
import itertools

melhor_aic = float("inf")
melhor_ordem = None
for p, d, q in itertools.product(range(4), range(2), range(4)):
    try:
        res = ARIMA(ipca["ipca"], order=(p, d, q)).fit()
        if res.aic < melhor_aic:
            melhor_aic, melhor_ordem = res.aic, (p, d, q)
    except Exception:
        continue

print(f"Melhor ARIMA{melhor_ordem} com AIC = {melhor_aic:.2f}")
```

=== 15.2. Cointegração: quando duas séries não estacionárias "andam juntas"
<cointegração-quando-duas-séries-não-estacionárias-andam-juntas>
Duas séries individualmente não estacionárias --- como câmbio e Selic,
ou preço doméstico e preço internacional de uma commodity --- podem,
ainda assim, ter uma combinação linear entre elas que #strong[é]
estacionária. Quando isso ocorre, diz-se que as séries são
#strong[cointegradas]: mesmo se afastando temporariamente, existe uma
relação de equilíbrio de longo prazo para a qual tendem a retornar --- o
que evita o problema de regressão espúria do Capítulo 14.1, apesar de
ambas as séries serem $I\(1\)$.

```python
from statsmodels.tsa.stattools import coint

cambio = sgs.get({"cambio": 1}, start="2000-01-01")
selic = sgs.get({"selic": 11}, start="2000-01-01")
df_ci = pd.merge(cambio, selic, on="Date").dropna()

score, pvalue, _ = coint(df_ci.iloc[:, 0], df_ci.iloc[:, 1])
print(f"Teste de Cointegração (Engle-Granger) — p-valor: {pvalue:.4f}")
if pvalue < 0.05:
    print("As séries são cointegradas (relação de longo prazo)")
else:
    print("Sem evidência de cointegração")
```

=== 15.3. Modelos VAR e Função Impulso-Resposta
<modelos-var-e-função-impulso-resposta>
Um #strong[VAR (Vetor Autorregressivo)] generaliza o AR de uma única
série para um sistema de várias séries que se afetam mutuamente, sem
impor de antemão qual variável é "causa" e qual é "efeito" --- cada
variável do sistema é modelada como função de valores passados de si
mesma #strong[e] de todas as outras variáveis do sistema:

```python
from statsmodels.tsa.api import VAR

pib = sgs.get({"pib": 4380}, start="2005-01-01")
ipca = sgs.get({"ipca": 433}, start="2005-01-01")
selic = sgs.get({"selic": 11}, start="2005-01-01")

df_var = pd.merge(pib, ipca, on="Date")
df_var = pd.merge(df_var, selic, on="Date").dropna()
df_var.columns = ["pib", "ipca", "selic"]

modelo_var = VAR(df_var)
resultado_var = modelo_var.fit(maxlags=6, ic="aic")
print(f"Defasagens ótimas: {resultado_var.k_ar}")
print(resultado_var.summary())

# Função Impulso-Resposta: como um choque em uma variável se propaga às demais
irf = resultado_var.irf(12)
fig = irf.plot()
fig.tight_layout()

forecast = resultado_var.forecast(df_var.values[-resultado_var.k_ar:], steps=6)
forecast_df = pd.DataFrame(forecast, columns=df_var.columns)
print("Previsão 6 meses:")
print(forecast_df)
```

A #strong[Função Impulso-Resposta] (IRF) responde a uma pergunta central
de política econômica: "se a Selic sofrer um choque de um desvio-padrão
hoje, como o PIB e o IPCA reagem nos próximos meses?" --- é a ferramenta
padrão para simular o efeito dinâmico de um choque de política monetária
num sistema macroeconômico, sem precisar especificar a priori a direção
da causalidade entre as variáveis.

=== 15.4. Causalidade de Granger
<causalidade-de-granger>
Apesar do nome, a #strong[causalidade de Granger] não testa causalidade
no sentido filosófico/estrutural do Capítulo 7 --- testa uma noção mais
restrita e puramente preditiva: "os valores passados de $x$ ajudam a
prever $y$, além do que os valores passados do próprio $y$ já prevêem?".
Se sim, diz-se que "$x$ Granger-causa $y$".

```python
from statsmodels.tsa.stattools import grangercausalitytests

gc = grangercausalitytests(df_var[["ipca", "selic"]], maxlag=6, verbose=False)

for lag in range(1, 7):
    p = gc[lag][0]["ssr_ftest"][1]
    print(f"Lag {lag}: p-valor = {p:.4f} {'Selic Granger-causa IPCA' if p < 0.05 else 'Não causa (Granger)'}")
```

#strong[Gotcha importante:] causalidade de Granger é sobre
#strong[precedência temporal e poder preditivo], não sobre mecanismo
causal estrutural. É inteiramente possível que $x$ Granger-cause $y$ sem
que exista qualquer relação causal genuína --- por exemplo, se ambas
respondem, com defasagens diferentes, a um terceiro fator comum
(voltando ao tema central do Capítulo 7). O teste é uma ferramenta útil
e amplamente usada, mas seu nome é, reconhecidamente, uma fonte perene
de mal-entendidos --- o próprio Clive Granger, ao propor o teste em
1969, foi cuidadoso em ressaltar essa limitação.

=== 15.5. Exemplo Resolvido --- Selic causa IPCA no sentido de Granger?
<exemplo-resolvido-selic-causa-ipca-no-sentido-de-granger>
#strong[Enunciado:] usando os dados de `df_var` do item 15.3, teste se a
Selic Granger-causa o IPCA e, separadamente, se o IPCA Granger-causa a
Selic. Interprete o resultado à luz da lógica de transmissão de política
monetária (a Selic deveria afetar a inflação com defasagem, dado o
mecanismo de transmissão da política monetária).

#strong[Solução comentada:]

```python
print("SELIC -> IPCA")
gc_selic_ipca = grangercausalitytests(df_var[["ipca", "selic"]], maxlag=6, verbose=False)
for lag in range(1, 7):
    p = gc_selic_ipca[lag][0]["ssr_ftest"][1]
    print(f"  Lag {lag}: p = {p:.4f}")

print("\nIPCA -> SELIC")
gc_ipca_selic = grangercausalitytests(df_var[["selic", "ipca"]], maxlag=6, verbose=False)
for lag in range(1, 7):
    p = gc_ipca_selic[lag][0]["ssr_ftest"][1]
    print(f"  Lag {lag}: p = {p:.4f}")
```

Um resultado tipicamente esperado (e consistente com a teoria de
transmissão de política monetária, que prevê defasagens de vários meses
até trimestres entre a decisão do Copom e seu efeito pleno sobre a
inflação) é encontrar Granger-causalidade de `selic` para `ipca` em
defasagens intermediárias (por exemplo, 3 a 6 meses), e possivelmente
também de `ipca` para `selic` em defasagens curtas --- o que faria
sentido, já que o Copom #strong[reage] à inflação corrente e esperada ao
definir a Selic (a chamada regra de Taylor, Apostila 5). Encontrar
Granger-causalidade nas duas direções não é uma contradição: reflete
exatamente a natureza de retroalimentação entre política monetária e
inflação, que é a razão pela qual o VAR (que modela as duas variáveis
simetricamente, sem impor uma direção única) é a ferramenta mais
adequada para este tipo de sistema --- em vez de uma regressão simples
de uma variável contra a outra, que precisaria escolher arbitrariamente
qual é "a variável dependente".

#line()

== Capítulo 16 --- Exercícios para Executar (na mão)
<capítulo-16-exercícios-para-executar-na-mão>
Estes exercícios não exigem computador: o objetivo é treinar a leitura e
o raciocínio estatístico sobre resultados já prontos, antes de rodar
código. Resolva no papel. #strong[As soluções não estão neste documento]
--- quando terminar, peça para eu conferir suas respostas.

=== Exercício 1 --- Interpretando um coeficiente log-linear
<exercício-1-interpretando-um-coeficiente-log-linear>
Uma regressão estima
$ln\(upright("salário")\)= 6\,2 + 0\,085 dot.op upright("escolaridade")$.
Interprete o coeficiente `0,085` em português econômico (use tanto a
aproximação simples quanto a fórmula exata de Halvorsen-Palmquist, e
compare os dois valores numericamente).

=== Exercício 2 --- Calculando um resíduo manualmente
<exercício-2-calculando-um-resíduo-manualmente>
Um modelo estimado é $hat(y) = 50 + 2 x$. Para uma observação com
$x = 30$ e $y$ observado $= 115$, calcule $hat(y)$, o resíduo $hat(u)$,
e diga se o modelo superestimou ou subestimou o valor observado.

=== Exercício 3 --- Lendo uma saída de regressão fornecida como texto
<exercício-3-lendo-uma-saída-de-regressão-fornecida-como-texto>
Dada a saída abaixo (regressão de investimento empresarial contra taxa
de juros e crescimento esperado do PIB, $n = 80$), responda: (a) qual
variável tem maior significância estatística? (b) o $R^2$ ajustado
sugere um bom ajuste para dados de corte transversal de empresas? (c) o
sinal do coeficiente de `juros` é consistente com a teoria econômica de
investimento?

```
                 coef    std err          t      P>|t|
------------------------------------------------------------------------------
const           12.400      3.100      4.000      0.000
juros           -1.850      0.510     -3.627      0.001
crescimento_pib  0.640      0.290      2.207      0.030
==============================================================================
R-squared: 0.187        Adj. R-squared: 0.166
```

=== Exercício 4 --- Identificando violação de premissa a partir de um gráfico descrito
<exercício-4-identificando-violação-de-premissa-a-partir-de-um-gráfico-descrito>
Um pesquisador plota os resíduos de uma regressão de preço de imóveis
contra área construída (eixo x: valores previstos; eixo y: resíduos).
Ele descreve o gráfico: "os pontos formam uma curva em U --- resíduos
positivos para valores previstos baixos e altos, e negativos para
valores previstos intermediários". Qual premissa de Gauss-Markov está
provavelmente sendo violada, e que mudança na especificação do modelo
(não no método de estimação) resolveria o problema?

=== Exercício 5 --- Correlação vs.~causalidade num caso concreto
<exercício-5-correlação-vs.-causalidade-num-caso-concreto>
Um estudo encontra correlação positiva e estatisticamente significativa
entre "número de bombeiros presentes em um incêndio" e "valor total dos
danos causados pelo incêndio", em uma amostra de incêndios urbanos. Um
jornal manchete: "Mais bombeiros causam mais danos". Explique, usando os
conceitos do Capítulo 7 (viés de variável omitida ou causalidade
reversa), por que essa conclusão causal é equivocada, identificando
explicitamente a variável de confusão mais plausível.

=== Exercício 6 --- Comparando dois intervalos de confiança
<exercício-6-comparando-dois-intervalos-de-confiança>
Dois modelos estimam o efeito da escolaridade sobre o salário: Modelo A,
com $n = 50$, encontra $hat(beta) = 0\,09$ com IC 95%
$\[0\,01\;0\,17\]$\; Modelo B, com $n = 2000$, encontra
$hat(beta) = 0\,07$ com IC 95% $\[0\,065\;0\,075\]$. Qual estimativa
você reportaria como mais confiável e por quê? A diferença de magnitude
entre os dois pontos estimados ($0\,09$ vs.~$0\,07$) é necessariamente
evidência de que um dos dois modelos está "errado"?

#line()

== Capítulo 17 --- Exercícios para Executar (em código)
<capítulo-17-exercícios-para-executar-em-código>
Implemente e execute cada um no seu editor, com `statsmodels`.
#strong[As soluções não estão neste documento] --- o objetivo é rodar de
verdade, ver a saída, e comparar com sua expectativa teórica; quando
terminar, peça para eu revisar seu código.

=== Exercício 1 --- Sua primeira regressão simples
<exercício-1-sua-primeira-regressão-simples>
Simule uma série de `renda` (valores de 1000 a 10000, em passos de 500)
e uma série de `consumo = 300 + 0.75 * renda + ruído normal(0, 150)`.
Rode `sm.OLS` com constante e interprete `const` e o coeficiente de
`renda`.

=== Exercício 2 --- Esquecendo o intercepto de propósito
<exercício-2-esquecendo-o-intercepto-de-propósito>
Repita o Exercício 1, mas #strong[sem] usar `sm.add_constant`. Compare o
$R^2$ e o coeficiente de `renda` com o modelo correto. Explique a
diferença.

=== Exercício 3 --- Regressão por fórmula vs.~por matriz
<exercício-3-regressão-por-fórmula-vs.-por-matriz>
Rode o mesmo modelo do Exercício 1 usando
`smf.ols("consumo ~ renda", data=df).fit()`. Confirme que os
coeficientes são idênticos aos obtidos com `sm.OLS`.

=== Exercício 4 --- Intervalos de confiança em diferentes níveis
<exercício-4-intervalos-de-confiança-em-diferentes-níveis>
Usando o modelo do Exercício 1, calcule os intervalos de confiança a
90%, 95% e 99% com `modelo.conf_int(alpha=...)`. Qual fica mais largo?
Por quê, do ponto de vista da lógica de "confiança"?

=== Exercício 5 --- Regressão múltipla com três regressores
<exercício-5-regressão-múltipla-com-três-regressores>
Baixe (ou simule) dados de `pib`, `inflacao` e `desemprego`. Rode uma
regressão de `pib` contra `inflacao` e `desemprego` simultaneamente.
Compare o $R^2$ ajustado desse modelo com o de duas regressões simples
separadas.

=== Exercício 6 --- Calculando VIF
<exercício-6-calculando-vif>
Usando os dados do Exercício 5, calcule o VIF de cada variável
explicativa com `variance_inflation_factor`. Há sinal de
multicolinearidade preocupante?

=== Exercício 7 --- Teste de Breusch-Pagan
<exercício-7-teste-de-breusch-pagan>
Simule dados com heterocedasticidade proposital (erro cuja variância
cresce com uma variável `x`, como no Capítulo 9.5) e rode o teste de
Breusch-Pagan com `het_breuschpagan`. Confirme que o teste rejeita
homocedasticidade.

=== Exercício 8 --- Erros-padrão robustos
<exercício-8-erros-padrão-robustos>
Usando o mesmo modelo do Exercício 7, rode a regressão novamente com
`cov_type="HC1"` e compare os erros-padrão (`modelo.bse`) com os do
modelo original.

=== Exercício 9 --- Durbin-Watson em dados reais
<exercício-9-durbin-watson-em-dados-reais>
Baixe o IPCA mensal do BCB (`sgs.get({"ipca": 433}, ...)`), regrida-o
contra sua própria defasagem de 1 mês, e calcule o Durbin-Watson dos
resíduos com `durbin_watson`.

=== Exercício 10 --- Erros-padrão de Newey-West (HAC)
<exercício-10-erros-padrão-de-newey-west-hac>
Usando o modelo do Exercício 9, se o Durbin-Watson indicar
autocorrelação, reestime com `cov_type="HAC"` e
`cov_kwds={"maxlags": 4}`. Compare o p-valor do coeficiente antes e
depois da correção.

=== Exercício 11 --- Variável dummy simples
<exercício-11-variável-dummy-simples>
Simule uma variável `salario`, uma variável contínua `experiencia` e uma
dummy `setor_publico` (0/1). Construa
`salario = 3000 + 200*experiencia + 800*setor_publico + ruído`, rode a
regressão e interprete o coeficiente da dummy.

=== Exercício 12 --- Termo de interação
<exercício-12-termo-de-interação>
Repita o Exercício 11, mas adicione um termo de interação
`experiencia * setor_publico` usando a sintaxe
`smf.ols("salario ~ experiencia * setor_publico", data=df)`. O retorno
da experiência é o mesmo nos dois setores?

=== Exercício 13 --- Log-linear e a correção de Halvorsen-Palmquist
<exercício-13-log-linear-e-a-correção-de-halvorsen-palmquist>
Usando os dados do Exercício 11, rode a regressão com `np.log(salario)`
como variável dependente. Calcule o efeito percentual do setor público
sobre o salário usando a aproximação simples e a fórmula exata; compare
os dois números.

=== Exercício 14 --- Elasticidade em log-log
<exercício-14-elasticidade-em-log-log>
Simule `preco` (uniforme entre 5 e 50) e
`quantidade = 1000 * preco**(-0.8) * ruído_lognormal`. Rode a regressão
em log-log e verifique se a elasticidade estimada recupera o valor
`-0.8` usado na simulação. Classifique a demanda como elástica ou
inelástica.

=== Exercício 15 --- Teste ADF em duas séries diferentes
<exercício-15-teste-adf-em-duas-séries-diferentes>
Baixe a série da Selic e a série do câmbio (BCB). Rode o teste ADF em
nível para as duas. Diferencie cada uma e rode o ADF novamente. Reporte
qual(is) série(s) precisou(aram) de diferenciação para ficar
estacionária.

=== Exercício 16 --- Teste de cointegração
<exercício-16-teste-de-cointegração>
Usando as séries de Selic e câmbio do Exercício 15 (ambas em nível,
mesmo que não estacionárias individualmente), rode o teste de
cointegração de Engle-Granger com `coint`. Há evidência de relação de
longo prazo entre as duas?

=== Exercício 17 --- Ajustando um ARIMA e prevendo
<exercício-17-ajustando-um-arima-e-prevendo>
Baixe o IPCA mensal desde 2010. Ajuste um `ARIMA(1,0,1)`, gere uma
previsão de 12 meses com `.forecast(steps=12)`, e plote o histórico dos
últimos 24 meses junto com a previsão.

=== Exercício 18 --- Selecionando a melhor ordem ARIMA por AIC
<exercício-18-selecionando-a-melhor-ordem-arima-por-aic>
Repita o Exercício 17, mas faça uma busca em grade (`itertools.product`)
sobre `p` em `range(0,4)`, `d` em `range(0,2)`, `q` em `range(0,4)`,
escolhendo a combinação de menor AIC.

=== Exercício 19 --- Modelo VAR e Função Impulso-Resposta
<exercício-19-modelo-var-e-função-impulso-resposta>
Monte um DataFrame com PIB, IPCA e Selic mensais (BCB). Estime um `VAR`
com `maxlags=6` e `ic="aic"`. Plote a função impulso-resposta
(`resultado.irf(12).plot()`) e descreva, em texto, o que acontece com o
PIB após um choque na Selic.

=== Exercício 20 --- Causalidade de Granger nas duas direções
<exercício-20-causalidade-de-granger-nas-duas-direções>
Usando o mesmo `df_var` do Exercício 19, teste se a Selic Granger-causa
o IPCA e se o IPCA Granger-causa a Selic, para defasagens de 1 a 6
meses. Reporte em qual(is) defasagem(ns) cada relação é significativa a
5%.

=== Exercício 21 --- Painel: Pooled OLS vs.~Efeitos Fixos
<exercício-21-painel-pooled-ols-vs.-efeitos-fixos>
Monte um painel simulado com 6 países e 15 anos (como no Capítulo 13.1),
com um `efeito_fixo` por país correlacionado com a variável explicativa.
Rode Pooled OLS e Efeitos Fixos (via dummies ou via
`linearmodels.PanelOLS`) e compare os coeficientes.

=== Exercício 22 --- Teste de Hausman
<exercício-22-teste-de-hausman>
Usando os dados do Exercício 21, rode também o modelo de Efeitos
Aleatórios com `RandomEffects` e compare os dois modelos com
`linearmodels.panel.compare`. Com base na comparação, qual dos dois
modelos (FE ou RE) parece mais adequado?

#line()

== Capítulo Final --- Resumo
<capítulo-final-resumo>
#figure(
  align(center)[#table(
    columns: (50%, 50%),
    align: (auto,auto,),
    table.header([Conceito], [Código],),
    table.hline(),
    [OLS simples/múltiplo], [`sm.OLS(y, sm.add_constant(X)).fit()`],
    [Regressão por fórmula], [`smf.ols("y ~ x1 + x2", data=df).fit()`],
    [Coeficientes / p-valores / R²], [`modelo.params` / `modelo.pvalues`
    \/ `modelo.rsquared_adj`],
    [Intervalo de confiança], [`modelo.conf_int(alpha=0.05)`],
    [VIF
    (multicolinearidade)], [`variance_inflation_factor(X.values, i)`],
    [Teste de Breusch-Pagan], [`het_breuschpagan(resid, exog)`],
    [Erros-padrão robustos (HC)], [`modelo.fit(cov_type="HC1")`],
    [Durbin-Watson], [`durbin_watson(modelo.resid)`],
    [Erros-padrão HAC
    (Newey-West)], [`modelo.fit(cov_type="HAC", cov_kwds={"maxlags": k})`],
    [Dummy / interação], [`pd.get_dummies(..., drop_first=True)` /
    `"y ~ x * dummy"`],
    [Painel --- Efeitos
    Fixos], [`PanelOLS.from_formula("y ~ x + EntityEffects", data=df)`],
    [Painel --- Efeitos
    Aleatórios], [`RandomEffects.from_formula("y ~ x", data=df)`],
    [Teste de Hausman], [`compare({"FE": fe.fit(), "RE": re.fit()})`],
    [Teste ADF (estacionariedade)], [`adfuller(serie)`],
    [ARIMA], [`ARIMA(y, order=(p,d,q)).fit()`],
    [Cointegração], [`coint(y1, y2)`],
    [VAR], [`VAR(df).fit(maxlags=6, ic="aic")`],
    [Causalidade de Granger], [`grangercausalitytests(df, maxlag=6)`],
  )]
  , kind: table
  )

Os conceitos centrais para carregar desta apostila: um coeficiente de
regressão só é confiável na medida em que as premissas de Gauss-Markov
(Capítulo 3) se sustentam; $R^2$ alto não é sinônimo de modelo bem
especificado; e --- o ponto mais importante de todos ---
#strong[correlação não é causalidade] (Capítulo 7), a lição que mais
separa um uso ingênuo de um uso rigoroso de regressão em economia.

#line()

== Próxima apostila
<próxima-apostila>
Com a base de manipulação de dados (Apostila 2), visualização (Apostila
3) e agora econometria (Apostila 4) estabelecida, siga para a
#strong[Apostila 5 --- Projetos], onde essas três apostilas se juntam em
projetos completos e realistas --- dashboards macroeconômicos, testes de
convergência de renda, modelos de previsão de inflação e a estrutura de
um TCC aplicado --- do levantamento de dados brutos até a conclusão
escrita.
