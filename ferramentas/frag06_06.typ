%%% BEFORE: === 6.2. Taxa Nominal vs Taxa Real (Equação de Fisher)
#teoria("causas e medição da inflação")[
  A inflação é o aumento #strong[persistente e generalizado] dos preços; um
  choque pontual (a gasolina sobe num mês) não é inflação, mas pode
  desencadeá-la. Os economistas costumam distinguir:

  - #strong[Inflação de demanda:] a procura agregada excede a capacidade de
    produção; o aquecimento da economia pressiona os preços.
  - #strong[Inflação de custos:] choques de oferta (câmbio, energia, safra)
    encarecem a produção e são repassados ao consumidor.
  - #strong[Inflação inercial e expectativas:] contratos indexados e
    expectativas elevadas fazem a inflação passada se repetir. É por isso
    que o regime de #strong[metas] (o CMN fixa 3% a.a., com tolerância de
    ±1,5 ponto percentual) depende tanto da credibilidade do Banco Central.

  Cada índice mede uma "cesta" diferente, e por isso os números divergem:
  o #strong[IPCA] cobre famílias com renda de 1 a 40 salários mínimos; o
  #strong[INPC], de 1 a 5; o #strong[IGP-M] combina preços no atacado (60%),
  no consumidor (30%) e na construção (10%) --- por isso é muito mais
  volátil, sensível ao câmbio e às commodities.
]

#intuicao[
  Inflação é um imposto invisível sobre quem guarda dinheiro: com inflação
  $pi$, o mesmo valor nominal compra $1/(1 + pi)$ do que comprava antes.
  A 4,5% a.a., R\$ 100 mantidos "debaixo do colchão" por 10 anos compram só
  $1/1,045^10 = 64,4%$ do que compram hoje. A taxa de juros nominal só
  gera #emph[riqueza real] se superar a inflação.
]

%%% BEFORE: === 6.3. Correção Monetária
#teoria("dedução da equação de Fisher")[
  Considere R\$ 1 aplicado a uma taxa nominal $i_n$. Daqui a um período:

  - o investidor terá $(1 + i_n)$ reais;
  - o preço da cesta de consumo, que custava $P$ e é reajustado pela
    inflação, passa a valer $P (1 + pi)$.

  Antes, R\$ 1 comprava $1/P$ unidades da cesta. Depois, $(1 + i_n)$ reais
  compram $(1 + i_n)/(P (1 + pi))$ unidades. O #strong[ganho de poder de
  compra] é a razão entre as duas quantidades:

  $ (1 + i_r) = ((1 + i_n)/(P (1 + pi))) / (1/P) = (1 + i_n)/(1 + pi) $

  que é a equação de Fisher. Duas leituras: (1) a taxa real é um #strong[ganho em
  unidades de bens], não em reais; (2) distinguem-se a taxa real
  #strong[ex-post] (calculada com a inflação #emph[realizada]) e a #strong[ex-ante]
  (calculada com a inflação #emph[esperada], que é a base da decisão de
  investir).
]

#atencao[
  #strong["Juro real = nominal menos inflação" só vale para taxas baixas.]
  A subtração ignora o termo cruzado $i_r dot pi$. Com inflação de 4,5% o
  erro é de décimos de ponto percentual (veja a saída do código da seção);
  com inflação alta ele é grande. Com juros nominais de 30% a.a. e inflação
  de 20% a.a., a conta rápida dá 10%, mas a taxa real correta é
  $1,30/1,20 - 1 = 8,33%$.
]

#exemplo("a mesma regra, em outros sentidos")[
  - #strong[Tesouro IPCA+ a 5,5%:] o título paga IPCA mais 5,5% a.a. de taxa
    #emph[real]. Com IPCA de 3,8%, o retorno nominal é
    $1,055 times 1,038 - 1 = 9,51%$ (e não 9,3%, a soma simples). Com IPCA
    de 5,0%, $1,055 times 1,05 - 1 = 10,78%$.
  - #strong[Poupança] a 6,1678% a.a. com IPCA de 4,44% a.a. (12 meses até
    julho de 2026, arquivo `ipca_12m.json`): taxa real
    $1,061678/1,0444 - 1 = 1,65%$ a.a. --- positiva, mas modesta.
  - #strong[Taxa real negativa:] um investimento que rende 4% quando a
    inflação é 6% tem $1,04/1,06 - 1 = -1,89%$: perde poder de compra mesmo
    aumentando o saldo em reais.
]

```python
print(f"{'Inflação':>9} {'Nominal':>8} {'Real (Fisher)':>14} {'Real (aprox.)':>14} {'Erro (p.p.)':>12}")
for infl_ex, nominal_ex in [(0.03, 0.08), (0.045, 0.1325), (0.10, 0.20), (0.20, 0.30), (0.50, 0.65)]:
    real_ex = fisher(i_nominal=nominal_ex, inflacao=infl_ex)
    aprox_ex = nominal_ex - infl_ex
    print(f"{infl_ex:>8.1%} {nominal_ex:>8.2%} {real_ex:>13.2%} {aprox_ex:>13.2%} {(aprox_ex - real_ex)*100:>12.2f}")
```

%%% BEFORE: === 6.4. Taxa Pré-fixada vs Pós-fixada
#exemplo("reajuste de aluguel e perda real de salário")[
  - #strong[Aluguel.] Um contrato de R\$ 2.000 é reajustado pelo IPCA
    acumulado em 12 meses, 4,44% (dado do repositório). Novo aluguel:
    $2.000 times 1,0444 = $ R\$ 2.088,80.
  - #strong[Salário.] Para manter o poder de compra, um salário de R\$ 3.000
    precisaria subir para $3.000 times 1,0444 = $ R\$ 3.133,20. Se o
    reajuste concedido foi de 3%, o salário vai a R\$ 3.090,00 e a
    #strong[variação real] é $1,03/1,0444 - 1 = -1,38%$: o trabalhador perdeu
    poder de compra mesmo recebendo aumento.
]

#teoria("valores nominais, valores reais e o deflator")[
  Para comparar valores em datas diferentes, é preciso expressá-los na
  mesma "moeda de poder de compra". Escolhe-se uma data-base e divide-se o
  valor nominal pelo #strong[fator acumulado do índice] até aquela data:

  $ "Valor real"_t = "Valor nominal"_t / "Fator acumulado"_(0 -> t) $

  O resultado está em #strong[reais da data-base]. Dividir (e não
  multiplicar) é a operação correta: o dinheiro de hoje é "menos
  valioso" que o do passado, então o valor atual precisa ser reduzido para
  ser comparável. Séries econômicas (PIB, salário, renda) só têm sentido
  comparativo ao longo do tempo quando #strong[deflacionadas].
]

```python
def deflacionar(valores_nominais, inflacoes_mensais):
    """Converte uma série nominal para reais do 1º mês (índices em decimal)."""
    fator, reais = 1.0, []
    for k, v in enumerate(valores_nominais):
        if k > 0:
            fator *= 1 + inflacoes_mensais[k - 1]
        reais.append(v / fator)
    return reais

salario_nominal = [3000, 3000, 3000, 3090, 3090, 3090]     # reajuste de 3% no 4º mês
inflacao_mensal = [0.004, 0.005, 0.004, 0.005, 0.004]       # IPCA mensal (ilustrativo)
for mes, (nom, real) in enumerate(zip(salario_nominal, deflacionar(salario_nominal, inflacao_mensal)), 1):
    print(f"Mês {mes}: nominal R${nom:,.2f} | real (R$ do mês 1) R${real:,.2f}")
```

%%% BEFORE_CHAPTER_END: == Capítulo 7 --- Análise de Investimentos
#atencao[
  A fórmula $"FV" = "PV"(1 + "indexador" + "spread")^n$ da seção 6.4 é uma
  #strong[simplificação didática]. Um título pós-fixado de verdade rende
  o #strong[produto dos fatores]: $"FV" = "PV" dot (1 + "indexador")^n dot
  (1 + "spread")^n$ (indexador e spread se compõem, não se somam). Além
  disso, "CDI + 0,5%" e "110% do CDI" são coisas diferentes: no primeiro, o
  spread é uma #strong[taxa] somada ao CDI; no segundo, o percentual
  multiplica a #strong[taxa diária] do CDI, dia a dia. Por isso, 110% de
  um CDI de 13,25% a.a. rende #strong[14,67%] a.a. (e não $1,10 times
  13,25% = 14,575%$).
]

#teoria("a inflação implícita (break-even) e a escolha pré × IPCA+")[
  Um investidor tem duas opções de mesmo prazo: um título #strong[pré-fixado]
  a $i_("pré")$ e um título #strong[IPCA+] que paga $r$ real mais a inflação
  realizada. Os dois rendem o mesmo quando

  $ (1 + i_("pré")) = (1 + r)(1 + pi_("be")) quad arrow.r.double quad pi_("be") = (1 + i_("pré"))/(1 + r) - 1 $

  $pi_("be")$ é a #strong[inflação implícita] (break-even). Com pré de 12,5% a.a. e IPCA+ de
  6,0% a.a., $pi_("be") = 1,125/1,06 - 1 = 6,13%$. Se o investidor
  #emph[espera] inflação maior que 6,13% durante o prazo, o IPCA+ é melhor;
  se espera menos, o pré-fixado vence. Estamos, no fundo, comparando a
  expectativa do investidor com a expectativa embutida no preço do mercado.
]

#exemplo("o risco de marcação a mercado")[
  O Tesouro Prefixado (LTN) paga R\$ 1.000 no vencimento. Seu preço
  unitário (PU) é $"PU" = 1.000/(1 + i)^("du"/252)$. Se a taxa de mercado
  sobe de 13% para 14% a.a.:

  - Vencimento em 252 dias úteis (1 ano): PU passa de R\$ 884,96 para
    R\$ 877,19 (−0,88%).
  - Vencimento em 504 dias úteis (2 anos): PU passa de R\$ 783,15 para
    R\$ 769,47 (−1,75%).

  Quem carrega o título até o vencimento recebe os R\$ 1.000 prometidos,
  mas quem precisa vendê-lo antes sofre a perda. Quanto #strong[mais longo]
  o prazo, #strong[maior] a sensibilidade do preço à taxa --- o mesmo
  mecanismo da perpetuidade do Capítulo 4.
]

```python
def pu_ltn(taxa_aa, dias_uteis, face=1000):
    return face / (1 + taxa_aa) ** (dias_uteis / 252)

for dias_ex in (252, 504, 1260):
    pu_a, pu_b = pu_ltn(0.13, dias_ex), pu_ltn(0.14, dias_ex)
    print(f"{dias_ex:>4} du: PU a 13% = R${pu_a:7.2f} | a 14% = R${pu_b:7.2f} | variação = {pu_b / pu_a - 1:+.2%}")
```

#resumo[
  - $(1 + i_n) = (1 + i_r)(1 + pi)$: a taxa real é o ganho em poder de
    compra. Aproximar por $i_n - pi$ só é aceitável com taxas baixas.
  - Valores em datas diferentes só se comparam depois de #strong[deflacionados];
    dividir pelo fator acumulado do índice.
  - Pós-fixado: indexador e spread #strong[se compõem]; "% do CDI"
    multiplica a taxa #strong[diária]. Pré-fixado: a taxa é conhecida, mas
    o preço de mercado oscila com os juros.
  - Inflação implícita: $pi_("be") = (1 + i_("pré"))/(1 + r) - 1$.
]
%%% END
