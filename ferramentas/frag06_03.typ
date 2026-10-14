%%% BEFORE: === 3.2. A Regra dos 72
#intuicao[
  No regime composto, cada período multiplica o saldo pelo #strong[fator de
  capitalização] $(1 + i)$. Aplicar $n$ períodos é multiplicar $n$ vezes
  pelo mesmo fator --- daí o expoente. O processo inverso, trazer um valor
  futuro para hoje, é #strong[dividir] por esse fator $n$ vezes, ou
  multiplicar pelo #strong[fator de descapitalização] $(1 + i)^(-n)$.
]

#exemplo("construindo a fórmula período a período")[
  R\$ 1.000 aplicados a 3% a.m. Em cada mês, multiplica-se o saldo por 1,03:

  #figure(
    align(center)[#table(
      columns: (14%, 34%, 26%, 26%),
      align: (center, left, right, right),
      table.header([Mês], [Cálculo], [Juros do mês], [Saldo final],),
      [0], [---], [---], [1.000,00],
      [1], [$1.000 times 1,03$], [30,00], [1.030,00],
      [2], [$1.030 times 1,03$], [30,90], [1.060,90],
      [3], [$1.060,90 times 1,03$], [31,83], [1.092,73],
      [4], [$1.092,73 times 1,03$], [32,78], [1.125,51],
    )]
    , kind: table
    )

  Pela fórmula fechada: $1.000 times 1,03^4 = 1.125,51$ ✓. Note que os
  juros do mês crescem (30,00 → 32,78): é o efeito "juros sobre juros".
]

#exemplo("valor presente de uma dívida")[
  Uma dívida de R\$ 20.000 vence em 18 meses. Se a taxa de mercado é de
  1,5% a.m., quanto vale essa dívida hoje, ou seja, quanto seria preciso
  pagar para quitá-la agora?

  $ "PV" = "FV"/(1 + i)^n = 20.000 / 1,015^18 = 20.000 / 1,30734 approx "R\$ 15.298,23" $

  Interpretação: R\$ 15.298,23 aplicados hoje a 1,5% a.m. rendem
  exatamente R\$ 20.000 em 18 meses. A diferença de R\$ 4.701,77 é o
  #strong[desconto] pela antecipação.
]

```python
vf_divida, taxa_div, meses_div = 20000, 0.015, 18
vp_divida = vf_divida / (1 + taxa_div) ** meses_div
print(f"Valor presente: R${vp_divida:,.2f} | desconto: R${vf_divida - vp_divida:,.2f}")
print(f"Conferência (capitalizando de volta): R${vp_divida * (1 + taxa_div) ** meses_div:,.2f}")
```

#strong[Taxas variáveis ao longo do tempo.] Quando a taxa muda de um período
para outro, o fator acumulado é o #strong[produto] dos fatores de cada
período:

$ (1 + i_("acum")) = (1 + i_1)(1 + i_2) dots.c (1 + i_n) $

Exemplo: inflações mensais de 0,4%, 0,5% e 0,3% acumulam
$1,004 times 1,005 times 1,003 - 1 = 1,2047%$ no trimestre --- não 1,2%
(a soma simples) --- porque cada mês incide sobre o preço já corrigido.

%%% BEFORE: === 3.3. Taxas Equivalentes (Juros Compostos)
#teoria("de onde vem o número 72")[
  Para dobrar um capital, queremos $(1 + i)^n = 2$, ou seja,
  $n = ln 2 / ln(1 + i)$, com $ln 2 approx 0,693$. Para taxas pequenas, a
  série de Taylor dá $ln(1 + i) approx i - i^2/2$, de modo que

  $ n approx 0,693/(i (1 - i/2)) approx (69,3/(100 i)) (1 + i/2) $

  onde, na última expressão, a taxa é percentual. O fator de correção
  $(1 + i/2)$ vale cerca de 1,04 para taxas próximas de 8%, o que leva
  69,3 a aproximadamente 72. A "regra dos 72" é, portanto, uma
  #strong[calibração do 69,3 para a faixa de taxas de 6% a 10%], onde ela
  é praticamente exata (a 8%, o prazo exato é 9,006 períodos; a regra dá
  9,000). Para taxas muito baixas, a "regra dos 70" ou do 69,3 é mais
  precisa; para taxas altas (acima de 15%), a regra dos 72 subestima o
  prazo.
]

#exemplo("usando a regra")[
  - A poupança rende cerca de 6,17% a.a. Quanto tempo para dobrar o
    capital? $72/6,17 approx 11,7$ anos (exato: 11,58).
  - A inflação média é de 6% a.a. Em quanto tempo o poder de compra da
    moeda cai pela metade? $72/6 = 12$ anos (exato: 11,9). Ou seja, em
    12 anos, R\$ 100 compram o que R\$ 50 compram hoje --- é o que
    significa $1/1,06^12 approx 0,497$.
]

%%% BEFORE: === 3.4. Taxa Nominal vs Taxa Efetiva
#teoria("a prova da equivalência")[
  Aplique R\$ 1 por um ano, de duas formas: (a) à taxa anual $i_a$, uma
  vez; (b) à taxa mensal $i_m$, capitalizada 12 vezes. Os montantes são
  $(1 + i_a)$ e $(1 + i_m)^12$. As duas taxas são #strong[equivalentes]
  se os montantes forem iguais:

  $ (1 + i_a) = (1 + i_m)^12 quad arrow.r.double quad i_m = (1 + i_a)^(1\/12) - 1 $

  A generalização é imediata: para $k$ períodos menores dentro de um maior,
  $(1 + i_("maior")) = (1 + i_("menor"))^k$. O erro clássico é aplicar a
  proporcionalidade dos juros simples ($i_m = i_a/12$) a taxas compostas:
  isso dá uma taxa mensal #strong[maior] que a equivalente. Com
  $i_a = 12,68%$, a taxa proporcional seria $1,057%$ a.m., e 12
  capitalizações dariam 13,45% a.a., não 12,68%.
]

#exemplo("conversões do dia a dia")[
  - #strong[1% a.m. em taxa anual:] $1,01^12 - 1 = 12,6825%$ a.a. (e não 12%).
  - #strong[Poupança, 0,5% a.m.:] $1,005^12 - 1 = 6,1678%$ a.a.
  - #strong[5% a.t. em taxa mensal:] $1,05^(1\/3) - 1 = 1,6396%$ a.m.; em
    taxa anual, $1,05^4 - 1 = 21,55%$ a.a.
  - #strong[Inflação:] um IPCA de 4,44% em 12 meses corresponde a uma
    inflação #strong[média] de $1,0444^(1\/12) - 1 = 0,3627%$ a.m. (dado real
    do IPCA acumulado em 12 meses até julho de 2026; série SGS 13522 do BCB,
    arquivo `ipca_12m.json` desta pasta).
]

#mercado[
  #strong[Taxas "over" e base 252.] No mercado de renda fixa brasileiro, o
  CDI e a Selic são cotados em % a.a. na #strong[base de 252 dias úteis].
  A taxa diária equivalente a 13,25% a.a. é $1,1325^(1\/252) - 1 = 0,04939%$
  a.d. Um mês com 21 dias úteis rende $1,1325^(21\/252) - 1 = 1,0423%$ ---
  note que o rendimento de um "mês" #strong[depende de quantos dias úteis ele
  tem]. Já a taxa "over", usada em operações compromissadas, é uma
  taxa diária multiplicada por 30 (proporção simples), exceção histórica
  ao padrão composto.
]

```python
def converte_taxa(taxa, de_dias, para_dias):
    """Converte taxa composta entre bases de tempo (em dias da mesma base: úteis ou corridos)."""
    return (1 + taxa) ** (para_dias / de_dias) - 1

cdi_aa = 0.1325
print(f"CDI 13,25% a.a. -> diária (252 du): {converte_taxa(cdi_aa, 252, 1)*100:.5f}%")
print(f"CDI 13,25% a.a. -> 21 dias úteis : {converte_taxa(cdi_aa, 252, 21)*100:.4f}%")
print(f"CDI 13,25% a.a. -> 63 dias úteis : {converte_taxa(cdi_aa, 252, 63)*100:.4f}%")
print(f"IPCA 12m 4,44% -> média mensal  : {converte_taxa(0.0444, 12, 1)*100:.4f}% a.m.")
```

%%% BEFORE: === 3.5. Juros Compostos com Períodos Fracionários
#teoria("capitalização contínua e o número e")[
  Quanto vale, no limite, a capitalização mais frequente possível? Se uma
  taxa nominal $x$ é capitalizada $k$ vezes ao ano, o fator anual é
  $(1 + x/k)^k$. Tomando o logaritmo e usando $ln(1 + u) approx u - u^2/2$:

  $ ln (1 + x/k)^k = k ln(1 + x/k) approx k (x/k - x^2/(2 k^2)) = x - x^2/(2k) $

  À medida que $k -> infinity$, o termo $x^2/(2k)$ some e o logaritmo tende
  a $x$; portanto $(1 + x/k)^k -> e^x$. Isso mostra duas coisas: a taxa
  efetiva #strong[cresce] com $k$ (o termo subtraído diminui) e tem um
  #strong[teto] --- a capitalização contínua, $e^x - 1$.
]

#exemplo("quanto a frequência importa")[
  Uma taxa nominal de 12% a.a., conforme a frequência de capitalização:

  #table(
    columns: (40%, 30%, 30%),
    align: (left, right, right),
    table.header([Capitalização], [$k$], [Taxa efetiva],),
    [Anual], [1], [12,0000%],
    [Semestral], [2], [12,3600%],
    [Trimestral], [4], [12,5509%],
    [Mensal], [12], [12,6825%],
    [Diária], [365], [12,7475%],
    [Contínua], [$infinity$], [12,7497%],
  )

  #v(0.3em)
  Passar de capitalização anual para mensal acrescenta 0,68 ponto
  percentual; de mensal para diária, só 0,07. Os ganhos são decrescentes,
  e o teto é 12,7497%.
]

#atencao[
  #strong["Juros de 12% ao ano" pode ter dois significados.] Num contrato,
  "12% a.a." pode ser uma taxa #strong[efetiva] (cobrada de fato no ano)
  ou #strong[nominal] (taxa mensal proporcional de 1% a.m., que equivale a
  12,68% a.a.). Quando o contrato diz "capitalizados mensalmente", ou quando
  a taxa mensal é multiplicada por 12 para ser apresentada como anual,
  trata-se de taxa nominal. Compare sempre pela #strong[efetiva].
  Exemplo extremo: o rotativo do cartão de crédito a 12% a.m. equivale a
  $1,12^12 - 1 = 289,60%$ a.a. --- e não a "144% ao ano".
]

%%% BEFORE_CHAPTER_END: == Capítulo 4 --- Séries de Pagamentos
#teoria("por que a convenção linear nunca perde")[
  Seja $f$ a fração do período ($0 < f < 1$) e $i > 0$. A função
  $g(f) = (1 + i)^f$ é #strong[convexa] em $f$ e coincide com a reta
  $1 + i f$ nos pontos $f = 0$ e $f = 1$ (onde ambas valem 1 e $1 + i$).
  Uma função convexa fica #strong[abaixo] da corda que une dois de seus
  pontos; logo $(1 + i)^f <= 1 + i f$ para $0 <= f <= 1$ (essa é a
  desigualdade de Bernoulli). Por isso, na parte fracionária do prazo, a
  convenção linear dá um fator #strong[maior ou igual] ao da exponencial.
]

#exemplo("a diferença em reais")[
  R\$ 100.000 a 2% a.m. por 6,5 meses: a convenção exponencial dá
  $100.000 times 1,02^(6,5) = 113.736,83$ e a linear dá
  $100.000 times 1,02^6 times (1 + 0,02 times 0,5) = 113.742,40$.
  A diferença (R\$ 5,57) é pequena para um prazo curto, mas cresce com o
  valor e com a taxa --- e o contrato deve dizer qual convenção vale.
]

#resumo[
  - $"FV" = "PV"(1 + i)^n$ e $"PV" = "FV"/(1 + i)^n$. O expoente conta
    quantas vezes o fator é aplicado.
  - Taxas compostas #strong[equivalentes]: $(1 + i_("maior")) =
    (1 + i_("menor"))^k$. Taxas proporcionais #strong[não] são equivalentes
    em juros compostos.
  - Taxa nominal capitalizada $k$ vezes: $i_("ef") = (1 + i_("nom")/k)^k - 1$;
    quanto maior $k$, maior a efetiva, até o teto $e^(i_("nom")) - 1$.
  - Regra dos 72: tempo de duplicação $approx 72 / i%$, boa entre 6% e 10%.
  - Bases de tempo (252 dias úteis, 365 dias corridos, 360 comercial) devem
    estar #strong[explícitas] --- mudar a base muda o resultado.
]
%%% END
