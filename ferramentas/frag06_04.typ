%%% BEFORE: === 4.2. Série Uniforme Postecipada
#intuicao[
  Uma série de pagamentos é um #strong[pacote de pagamentos únicos]. Cada
  um deles pode ser trazido a valor presente com $"FV"/(1 + i)^n$ --- e a
  série vale a #strong[soma] desses valores presentes. As fórmulas deste
  capítulo são apenas atalhos algébricos para essa soma, que é uma
  progressão geométrica. Se alguma vez a fórmula parecer misteriosa, volte
  à soma "por extenso".
]

#strong[Três perguntas para classificar qualquer série] (e escolher a fórmula):

+ #strong[Quando cai o primeiro pagamento?] Um período depois da data zero
  (postecipada), na própria data zero (antecipada) ou mais tarde, após uma
  carência (diferida).
+ #strong[Os valores são iguais?] Se sim, é uma série #emph[uniforme];
  se não, some os valores presentes um a um.
+ #strong[Quantos pagamentos?] Finito, ou infinito (perpetuidade).

#figure(
  align(center)[#table(
    columns: (46%, 54%),
    align: (left, left),
    table.header([Situação], [Tipo de série],),
    [Financiamento "sem entrada", 1ª parcela em 30 dias], [Postecipada],
    [Financiamento "com entrada" de valor igual à parcela], [Antecipada],
    [Aluguel pago no início do mês], [Antecipada],
    [Carnê com 1ª parcela em 120 dias], [Diferida (carência de 3 períodos)],
    [Ação que paga dividendos indefinidamente], [Perpétua],
  )]
  , kind: table
  )

%%% BEFORE: === 4.3. Série Uniforme Antecipada
#teoria("dedução do valor presente da série postecipada")[
  Seja $v = 1/(1 + i)$ o fator de desconto de um período. O valor presente
  da série é a soma dos $n$ pagamentos descontados:

  $ "PV" = "PMT" dot (v + v^2 + dots.c + v^n) $

  A expressão entre parênteses é uma PG de primeiro termo $v$ e razão $v$.
  Pela fórmula da soma (Capítulo 0), $S = v (1 - v^n)/(1 - v)$. Como
  $1 - v = i/(1 + i)$ e $v = 1/(1 + i)$, tem-se $v/(1 - v) = 1/i$, e então

  $ "PV" = "PMT" dot (1 - v^n)/i = "PMT" dot (1 - (1 + i)^(-n))/i $

  Define-se o #strong[fator de valor presente] da série como
  $a_(n | i) = (1 - (1 + i)^(-n))/i$. Assim:

  - $"PV" = "PMT" dot a_(n | i)$ #h(1em) e #h(1em) $"PMT" = "PV"/a_(n | i)$ (o inverso de $a_(n|i)$ é o FRC);
  - $"FV" = "PMT" dot s_(n | i)$, com $s_(n | i) = ((1 + i)^n - 1)/i = a_(n | i) (1 + i)^n$.

  A última igualdade diz que o valor futuro da série é o valor presente
  capitalizado por $n$ períodos --- como deveria ser.
]

#exemplo("somando por extenso (n pequeno)")[
  Três pagamentos de R\$ 100, ao fim de cada mês, a 10% a.m. Quanto valem
  hoje?

  $ "PV" = 100/1,1 + 100/1,1^2 + 100/1,1^3 = 90,91 + 82,64 + 75,13 = 248,69 $

  Pela fórmula: $100 times (1 - 1,1^(-3))/0,1 = 100 times 2,48685 = 248,69$ ✓.
  A fórmula só evita escrever a soma quando $n$ é grande (por exemplo, 360
  parcelas de um financiamento imobiliário).
]

#exemplo("valor futuro: quanto acumula quem poupa todo mês?")[
  Depositar R\$ 500 ao fim de cada mês, durante 10 anos (120 meses), a
  0,6% a.m. Quanto se acumula?

  $ "FV" = 500 times (1,006^120 - 1)/0,006 = 500 times 175,003 approx "R\$ 87.501,50" $

  Dos R\$ 87.501,50, apenas R\$ 60.000 foram depositados; R\$ 27.501,50
  (31%) vêm dos rendimentos.
]

#exemplo("incógnita é o prazo")[
  Uma dívida de R\$ 20.000 é paga com parcelas mensais de R\$ 800 a 2% a.m.
  Em quantos meses será quitada?

  Isolando $n$ em $"PV" = "PMT" dot (1 - (1+i)^(-n))/i$:

  $ n = - ln(1 - ("PV" dot i)/"PMT") / ln(1 + i) = - ln(1 - (20.000 dot 0,02)/800)/ln(1,02) = - ln(0,5)/ln(1,02) approx 35,0 "meses" $

  #strong[Condição de existência:] a expressão só tem solução se
  $"PMT" > "PV" dot i$, isto é, se a parcela for maior que os juros do
  primeiro mês (aqui, R\$ 400). Com parcela de R\$ 300 a dívida #emph[nunca]
  seria quitada --- ela cresceria.
]

```python
import math

def periodos_da_serie(valor_presente, parcela, taxa):
    """Número de parcelas necessário para quitar valor_presente (série postecipada)."""
    juros_do_mes = valor_presente * taxa
    if parcela <= juros_do_mes:
        return math.inf      # a parcela não cobre nem os juros: a dívida nunca acaba
    return -math.log(1 - juros_do_mes / parcela) / math.log(1 + taxa)

print(f"Parcela R$800: {periodos_da_serie(20000, 800, 0.02):.2f} meses")
print(f"Parcela R$401: {periodos_da_serie(20000, 401, 0.02):.1f} meses")
print(f"Parcela R$300: {periodos_da_serie(20000, 300, 0.02)} meses")
```

#exemplo("incógnita é a taxa")[
  Um carro de R\$ 20.000 à vista é vendido em 24 parcelas de R\$ 1.000.
  Qual é a taxa de juros?

  Não existe fórmula fechada para $i$ (a equação
  $20.000 = 1.000 dot a_(24 | i)$ é polinomial de grau 24). Resolve-se por
  tentativas --- exatamente o que a HP-12C e o Excel (`=TAXA`) fazem
  internamente. Em Python usamos a bissecção definida no Capítulo 1.
  A resposta é $i approx 1,5131%$ a.m. ($approx 19,75%$ a.a.).
]

```python
taxa_do_carro = bisseccao(lambda r: vp_das_parcelas(r, 1000, 24) - 20000, 1e-9, 1)
print(f"Taxa: {taxa_do_carro*100:.4f}% a.m. = {((1 + taxa_do_carro) ** 12 - 1)*100:.2f}% a.a.")
```

%%% BEFORE: === 4.4. Série Diferida (com Carência)
#teoria("antecipada = postecipada capitalizada uma vez")[
  Numa série antecipada, cada pagamento ocorre #strong[um período mais
  cedo] que na postecipada. Pagar mais cedo custa mais: cada parcela vale
  $(1 + i)$ vezes mais em valor presente. Logo

  $ "PV"_("ant") = "PV"_("post") dot (1 + i) quad arrow.r.double quad "PMT"_("ant") = "PMT"_("post")/(1 + i) $

  Interpretação alternativa, muito útil em provas: uma série antecipada de
  $n$ parcelas é #strong[uma parcela paga hoje] mais uma série
  #strong[postecipada de $n - 1$ parcelas]:
  $"PV" = "PMT" + "PMT" dot a_(n-1 | i)$.
]

#atencao[
  #strong["Com entrada" nem sempre é série antecipada.] A série antecipada
  exige que a entrada seja #strong[igual às demais parcelas]. Se o
  vendedor pede, por exemplo, 30% de entrada e o restante em parcelas
  iguais postecipadas, a entrada é apenas um abatimento do valor
  financiado: calcula-se a série sobre o #emph[saldo], com as fórmulas
  postecipadas.
]

```python
fin_valor, fin_taxa, fin_n = 30000, 0.018, 24
parcela_post = fin_valor / ((1 - (1 + fin_taxa) ** -fin_n) / fin_taxa)
parcela_ant = parcela_post / (1 + fin_taxa)
# conferência pela interpretação "1 parcela hoje + série postecipada de n-1":
fator_n_menos_1 = (1 - (1 + fin_taxa) ** -(fin_n - 1)) / fin_taxa
parcela_ant_alt = fin_valor / (1 + fator_n_menos_1)
print(f"Postecipada: R${parcela_post:.2f} | antecipada: R${parcela_ant:.2f} | alternativa: R${parcela_ant_alt:.2f}")
```

%%% BEFORE: === 4.5. Perpetuidades
#exemplo("pagar juros na carência ou capitalizá-los?")[
  Voltando ao financiamento de R\$ 30.000 a 1,8% a.m. em 24 parcelas, com
  carência de 3 meses. Há duas formas de tratar a carência:

  - #strong[Juros capitalizados] (padrão da fórmula acima): nada é pago
    nos 3 primeiros meses; os juros se acumulam ao saldo, que chega a
    $30.000 times 1,018^3 = 31.649,33$ no início do pagamento. A parcela
    sobe para R\$ 1.635,66 e o total pago é $24 times 1.635,66 = $ R\$ 39.255,94.
  - #strong[Juros pagos na carência:] o cliente paga só os juros mensais
    ($30.000 times 1,8% = $ R\$ 540,00) nos 3 primeiros meses; o saldo
    continua R\$ 30.000 e as 24 parcelas seguintes valem R\$ 1.550,43. O
    total pago é $3 times 540 + 24 times 1.550,43 = $ R\$ 38.830,20.

  Pagar os juros na carência custa menos no total (R\$ 425,74 a menos),
  porque evita que o juro vire "juros sobre juros". Em ambos os casos a
  taxa efetiva é a mesma, 1,8% a.m.: a diferença é só de #strong[quando]
  o dinheiro sai.
]

```python
saldo_apos_carencia = fin_valor * (1 + fin_taxa) ** 3
parcela_cap = parcela_post * (1 + fin_taxa) ** 3
total_cap = parcela_cap * fin_n
total_pago_juros = 3 * fin_valor * fin_taxa + parcela_post * fin_n
print(f"Saldo ao fim da carência: R${saldo_apos_carencia:,.2f}")
print(f"Juros capitalizados: parcela R${parcela_cap:,.2f} | total pago R${total_cap:,.2f}")
print(f"Juros pagos na carência: parcela R${parcela_post:,.2f} | total pago R${total_pago_juros:,.2f}")
```

%%% BEFORE: === 4.6. Perpetuidade com Crescimento (Modelo de Gordon)
#teoria("a perpetuidade como limite")[
  O valor presente de $n$ pagamentos é $"PMT" dot (1 - (1 + i)^(-n))/i$.
  Se o número de pagamentos cresce sem limite, $(1 + i)^(-n) -> 0$ (porque
  $1 + i > 1$) e o valor presente converge para

  $ "PV"_(infinity) = "PMT"/i $

  Isso confirma uma intuição: se você tem $"PV"$ aplicado a $i$ por
  período, pode sacar os juros $"PV" dot i$ todo período #emph[sem nunca
  tocar no principal] --- e o saque é eterno. Perpetuidades puras são
  raras (o governo britânico emitiu "consols" no século XVIII), mas a
  fórmula é a base de avaliações de imóveis, ações e fundações.
]

#exemplo("quanto vale um imóvel alugado?")[
  Um imóvel gera R\$ 2.400 por mês de aluguel líquido. Se o investidor exige
  0,6% a.m. de retorno, o valor do imóvel é
  $2.400/0,006 = $ R\$ 400.000. Se a taxa exigida sobe para 0,8% a.m.,
  o valor cai para $2.400/0,008 = $ R\$ 300.000 --- uma queda de 25%.

  Este é o mecanismo do #strong[risco de taxa de juros]: o preço de ativos
  de longa duração cai quando a taxa de desconto sobe. Reaparece no
  Capítulo 6 (títulos pré-fixados) e na apostila de Finanças.
]

#atencao[
  A fórmula $"PMT"/i$ vale para pagamentos #strong[postecipados]. Se o
  primeiro pagamento ocorre #emph[hoje] (perpetuidade antecipada), some um
  pagamento: $"PV" = "PMT" + "PMT"/i$.
]

%%% BEFORE_CHAPTER_END: == Capítulo 5 --- Sistemas de Amortização
#teoria("dedução do modelo de Gordon")[
  Seja $D_1$ o #strong[próximo] dividendo (pago em $t = 1$), que cresce à
  taxa $g$ ao período. O valor presente de todos os dividendos é

  $ P_0 = D_1/(1 + i) + (D_1 (1 + g))/(1 + i)^2 + (D_1 (1 + g)^2)/(1 + i)^3 + dots.c $

  É uma PG infinita de primeiro termo $a_1 = D_1/(1 + i)$ e razão
  $q = (1 + g)/(1 + i)$. Se $g < i$ então $q < 1$ e a soma converge:

  $ P_0 = a_1/(1 - q) = (D_1/(1 + i)) / ((i - g)/(1 + i)) = D_1/(i - g) $

  Se $g >= i$, a série diverge: nenhum preço finito remunera o fluxo.
]

#exemplo("sensibilidade do preço ao crescimento")[
  Dividendo esperado $D_1 = $ R\$ 2,00; taxa exigida $i = 11%$ a.a.

  #table(
    columns: (30%, 35%, 35%),
    align: (center, right, right),
    table.header([Crescimento $g$], [Preço justo], [Variação vs. $g = 4%$],),
    [0%], [R\$ 18,18], [−36,4%],
    [2%], [R\$ 22,22], [−22,2%],
    [4%], [R\$ 28,57], [---],
    [6%], [R\$ 40,00], [+40,0%],
    [8%], [R\$ 66,67], [+133,3%],
  )

  #v(0.3em)
  Uma variação de apenas 2 pontos percentuais em $g$ muda o preço em 40%
  --- e quando $g$ se aproxima de $i$ o preço "explode". Por isso o modelo
  de Gordon é #strong[extremamente sensível] à premissa de crescimento, e
  o analista deve sempre testar cenários.
]

#atencao[
  No modelo de Gordon, $"PMT"$ (ou $D_1$) é o #strong[próximo] pagamento,
  o do período 1. Se o enunciado fornece o dividendo #emph[já pago] hoje
  ($D_0$), é preciso crescê-lo antes: $D_1 = D_0 (1 + g)$.
]

#mercado[
  A fórmula $P_0 = D_1/(i - g)$ é o ponto de partida de valuation por
  dividendos descontados (apostila 07). Reordenando, a taxa de retorno
  exigida implícita no preço é $i = D_1/P_0 + g$: o #strong[dividend yield]
  mais o crescimento.
]

#resumo[
  - Série postecipada: $"PV" = "PMT" dot a_(n|i)$, com
    $a_(n|i) = (1 - (1+i)^(-n))/i$; o VP fica #strong[um período antes do
    1º pagamento].
  - Antecipada: $"PV"_("ant") = "PV"_("post")(1 + i)$. Diferida (juros
    capitalizados): $"PMT" = "PV" (1 + i)^m / a_(n|i)$.
  - Perpetuidade: $"PV" = "PMT"/i$. Com crescimento: $"PV" = "PMT"_1/(i - g)$,
    exigindo $i > g$.
  - Quando a incógnita é $i$ não há fórmula fechada: use métodos numéricos
    (HP-12C, `=TAXA`, bissecção).
]
%%% END
