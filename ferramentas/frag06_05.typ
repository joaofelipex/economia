%%% BEFORE: === 5.2. Sistema Price (Sistema Francês)
#intuicao[
  Todo mês o devedor paga uma prestação. Ela faz duas coisas, #strong[nesta
  ordem]: primeiro quita os juros do mês (taxa $times$ saldo devedor) e,
  com o que sobrar, #strong[abate a dívida] (amortização). Os sistemas de
  amortização diferem apenas na #emph[regra de divisão] entre juros e
  amortização --- e, portanto, no formato da sequência de prestações.
]

#teoria("o saldo devedor é o valor presente das prestações que faltam")[
  O empréstimo foi concedido por um valor $"PV"$ exatamente igual ao valor
  presente de todas as prestações, à taxa $i$. Isso vale para qualquer
  sistema e para #strong[qualquer data posterior] (método prospectivo):
  logo após o pagamento $k$, a dívida remanescente é o valor presente, à
  mesma taxa, das prestações que ainda faltam. No Price, com prestação
  constante,

  $ "SD"_k = "PMT" dot a_(n - k | i) = "PMT" dot (1 - (1 + i)^(-(n - k)))/i $

  Esta fórmula é a ferramenta para calcular o #strong[saldo para quitação
  antecipada] sem montar a tabela inteira.
]

#mercado[
  Pelo Código de Defesa do Consumidor (art. 52, § 2º), o consumidor pode
  liquidar antecipadamente o débito, total ou parcialmente, com #strong[redução
  proporcional dos juros]. Na prática, o valor da quitação é o saldo
  devedor da data, calculado pela fórmula acima: os juros dos meses
  futuros não são devidos.
]

#figure(
  align(center)[#table(
    columns: (17%, 21%, 21%, 21%, 20%),
    align: (left, left, left, left, left),
    table.header([Sistema], [Prestação], [Amortização], [Juros], [Uso típico],),
    [Price], [Constante], [Crescente], [Decrescentes], [Crédito direto, veículos],
    [SAC], [Decrescente], [Constante], [Decrescentes], [Financiamento imobiliário],
    [SAM], [Média Price/SAC], [Média Price/SAC], [Decrescentes], [Alguns financiamentos habitacionais],
    [Americano], [Só juros, até o fim], [Tudo no final], [Constantes], [Debêntures, bonds],
  )]
  , kind: table
  )

%%% BEFORE: === 5.3. SAC --- Sistema de Amortizações Constantes
#teoria("por que as amortizações do Price crescem em PG")[
  Seja $"SD"_(k-1)$ o saldo antes do pagamento $k$. Então
  $A_k = "PMT" - i dot "SD"_(k-1)$. Para o pagamento seguinte,
  $A_(k+1) = "PMT" - i dot "SD"_k$. Subtraindo,

  $ A_(k+1) - A_k = -i ("SD"_k - "SD"_(k-1)) = -i dot (-A_k) = i dot A_k $

  pois o saldo cai exatamente a amortização. Logo
  $A_(k+1) = A_k (1 + i)$: #strong[cada amortização é a anterior
  multiplicada por $(1 + i)$]. Com $A_1 = "PMT" - "PV" dot i$:

  $ A_k = A_1 (1 + i)^(k - 1) $
]

#exemplo("as três primeiras linhas da tabela, na mão")[
  R\$ 50.000 em 12 parcelas a 2% a.m. (Price).

  #strong[Prestação:]
  $"PMT" = 50.000 times 0,02 times 1,02^12 / (1,02^12 - 1) = 50.000 times 0,094560 = 4.727,98$.

  - #strong[Mês 1:] juros $= 50.000 times 0,02 = 1.000,00$; amortização
    $= 4.727,98 - 1.000,00 = 3.727,98$; saldo $= 50.000 - 3.727,98 = 46.272,02$.
  - #strong[Mês 2:] juros $= 46.272,02 times 0,02 = 925,44$; amortização
    $= 3.802,54$; saldo $= 42.469,48$.
  - #strong[Mês 3:] juros $= 849,39$; amortização $= 3.878,59$; saldo $= 38.590,89$.

  #strong[Conferências.] (i) $A_2 = A_1 times 1,02 = 3.727,98 times 1,02 =
  3.802,54$ ✓. (ii) A soma de todas as amortizações deve ser $50.000$ e o
  saldo final, zero --- veja a tabela completa na saída abaixo.
]

#atencao[
  #strong["Pagar prestação não é pagar dívida."] No Price, a primeira
  prestação é composta quase só de juros, especialmente em prazos longos.
  Um financiamento de R\$ 200.000 em 360 meses a 1% a.m. tem prestação
  perto de R\$ 2.057, mas só cerca de R\$ 57 amortizam o saldo no primeiro
  mês (o resto, R\$ 2.000, são juros). Veja o cálculo no código.
]

```python
fin_longo_pv, fin_longo_i, fin_longo_n = 200000, 0.01, 360
fin_longo_pmt = fin_longo_pv * fin_longo_i / (1 - (1 + fin_longo_i) ** -fin_longo_n)
juros_1 = fin_longo_pv * fin_longo_i
print(f"Prestação: R${fin_longo_pmt:,.2f}")
print(f"1º mês -> juros R${juros_1:,.2f} ({juros_1 / fin_longo_pmt:.1%}) | amortização R${fin_longo_pmt - juros_1:,.2f}")
print(f"Total pago ao fim de 30 anos: R${fin_longo_pmt * fin_longo_n:,.2f} ({fin_longo_pmt * fin_longo_n / fin_longo_pv:.2f}x o valor financiado)")
```

%%% BEFORE: === 5.4. Comparação Price vs SAC
#teoria("fórmulas fechadas do SAC")[
  Como a amortização é constante, $A = "PV"/n$ e o saldo após $k$
  pagamentos é $"SD"_k = "PV" (n - k)/n$. Portanto

  $ J_k = i dot "SD"_(k-1) = i dot "PV" dot (n - k + 1)/n quad "e" quad
  "PMT"_k = "PV"/n dot (1 + i (n - k + 1)) $

  As prestações formam uma #strong[PA decrescente] de razão $-i dot "PV"/n = -i A$:
  cada prestação é menor que a anterior em $i A$ (os juros do período
  encolhem porque o saldo encolheu $A$). O total de juros é a soma de uma
  PA:

  $ sum_(k = 1)^n J_k = i dot A dot (n + (n-1) + dots.c + 1) = i dot A dot (n (n + 1))/2 = i dot "PV" dot (n + 1)/2 $
]

#exemplo("SAC na mão")[
  Mesmos R\$ 50.000, 12 parcelas, 2% a.m.

  - Amortização constante: $A = 50.000/12 = 4.166,67$.
  - 1ª prestação: $4.166,67 + 50.000 times 0,02 = 5.166,67$.
  - Decréscimo mensal: $i A = 0,02 times 4.166,67 = 83,33$ (5.166,67 → 5.083,33
    → 5.000,00 → ...).
  - Última (12ª): $4.166,67 + 4.166,67 times 0,02 = 4.250,00$.
  - Total de juros: $0,02 times 50.000 times 13/2 = 6.500,00$.

  Comparando com o Price (juros totais R\$ 6.735,76): o SAC economiza
  R\$ 235,76 de juros nesta operação.
]

%%% BEFORE: === 5.5. SAM --- Sistema de Amortização Mista
#intuicao[
  O SAC e o Price têm o #strong[mesmo custo financeiro por real emprestado
  por mês de empréstimo]: a taxa $i$ é a mesma, e o valor presente das
  prestações de ambos, descontado a $i$, é exatamente $"PV"$. Então por que
  o SAC paga menos juros no total? Porque ele #strong[devolve o capital
  mais depressa]: o saldo devedor médio é menor, e os juros incidem sobre
  um saldo menor. Pagar menos juros no total, #emph[por si só], não é
  "ser mais barato" --- você também pagou mais cedo.
]

```python
def vp_dos_fluxos(taxa, prestacoes):
    return sum(p / (1 + taxa) ** (k + 1) for k, p in enumerate(prestacoes))

prest_price = [r["prestacao"] for r in tabela_price(50000, 0.02, 12)[0]]
prest_sac = [r["prestacao"] for r in tabela_sac(50000, 0.02, 12)[0]]
print(f"VP das prestações Price a 2%: R${vp_dos_fluxos(0.02, prest_price):,.2f}")
print(f"VP das prestações SAC   a 2%: R${vp_dos_fluxos(0.02, prest_sac):,.2f}")

cruz = next(k + 1 for k, (a_, b_) in enumerate(zip(prest_price, prest_sac)) if b_ < a_)
print(f"A prestação SAC fica menor que a do Price a partir da parcela {cruz}")
```

#exemplo("qual sistema escolher?")[
  Os bancos aprovam o crédito com base na #strong[renda comprometida]: a
  primeira prestação não pode passar de uma fração da renda (30% é uma
  regra comum). Para o financiamento acima, a renda mínima é
  $4.727,98/0,30 = $ R\$ 15.759,93 no Price e
  $5.166,67/0,30 = $ R\$ 17.222,23 no SAC. Resumo da decisão:

  - #strong[Renda apertada no começo, ou crescente:] Price (prestação
    inicial menor e previsível).
  - #strong[Foco em pagar menos juros / quitar rápido:] SAC (menor custo
    total, prestação cai com o tempo).
  - Em ambos, #strong[amortizações extras no início] reduzem muito mais os
    juros do que no fim.
]

%%% BEFORE: === 5.6. Sistema Americano
#exemplo("SAM: a média dos dois")[
  Para os R\$ 50.000 em 12 parcelas a 2% a.m.: a primeira prestação SAM é
  $(4.727,98 + 5.166,67)/2 = 4.947,32$; a sexta, $(4.727,98 + 4.750,00)/2 =
  4.738,99$; a última, $(4.727,98 + 4.250,00)/2 = 4.488,99$. Como a média é
  linear, o total de juros do SAM também é a média: $(6.735,76 +
  6.500,00)/2 = 6.617,88$. A prestação inicial fica entre a do Price e
  a do SAC, e o sistema "suaviza" os dois extremos.
]

%%% BEFORE: === 5.7. Custo Efetivo Total (CET)
#exemplo("Americano com fundo de amortização")[
  Uma empresa emite um título de R\$ 100.000 por 5 anos, pagando 10% a.a.
  de juros anualmente e devolvendo o principal no fim.

  - Desembolso anual de #strong[juros]: R\$ 10.000.
  - Para ter R\$ 100.000 no ano 5, a empresa abre um #strong[fundo de
    amortização] (sinking fund) e deposita um valor $D$ por ano, remunerado
    a 6% a.a.: $D = 100.000 dot 0,06/(1,06^5 - 1) = $ R\$ 17.739,64.
  - Desembolso anual total: $10.000 + 17.739,64 = $ R\$ 27.739,64.

  Se o mesmo empréstimo fosse pago pelo Price a 10% a.a., a prestação seria
  $100.000 dot 0,10/(1 - 1,1^(-5)) = $ R\$ 26.379,75. O Americano com
  fundo custa #strong[mais por ano] (R\$ 1.359,89 de diferença) porque o
  fundo rende 6% enquanto a dívida custa 10%: a empresa "empresta barato e
  toma emprestado caro". Se o fundo rendesse 10%, os dois sistemas
  coincidiriam.
]

```python
principal_amer, juros_amer, anos_amer, rend_fundo = 100000, 0.10, 5, 0.06
deposito = principal_amer * rend_fundo / ((1 + rend_fundo) ** anos_amer - 1)
price_equivalente = principal_amer * juros_amer / (1 - (1 + juros_amer) ** -anos_amer)
print(f"Depósito anual no fundo: R${deposito:,.2f}")
print(f"Desembolso anual (juros + depósito): R${principal_amer * juros_amer + deposito:,.2f}")
print(f"Prestação anual do Price a 10%: R${price_equivalente:,.2f}")
```

%%% BEFORE_CHAPTER_END: == Capítulo 6 --- Inflação e Correção Monetária
#teoria("o que entra no CET")[
  O CET é a #strong[taxa interna de retorno do fluxo de caixa do cliente]:
  a taxa que iguala o valor realmente #emph[recebido] (o crédito
  liberado, já líquido de tarifas e tributos cobrados na contratação) ao
  valor presente de todos os pagamentos futuros (prestações, seguros
  obrigatórios, tarifas recorrentes). Qualquer despesa que o cliente
  #strong[não teria] se não contratasse a operação deve entrar. A
  divulgação do CET, em % a.m. e % a.a., é exigida pela regulamentação
  bancária para operações de crédito a pessoas físicas (Resolução CMN
  3.517/2007).
]

#exemplo("de 2,08% para 2,32% ao mês")[
  Um empréstimo é anunciado como "R\$ 10.000 em 12 parcelas de R\$ 950".

  - O fluxo do cliente é: $+10.000$ em $t = 0$ e $-950$ em $t = 1, dots, 12$.
    Resolvendo $10.000 = 950 dot a_(12|i)$, obtém-se #strong[2,0757% a.m.]
    (27,96% a.a.).
  - Se, porém, o banco desconta R\$ 150 (tarifa de cadastro e IOF) do valor
    liberado, o cliente recebe só R\$ 9.850 pelas mesmas 12 parcelas. O CET
    sobe para #strong[2,3232% a.m.] (31,73% a.a.).

  Os R\$ 150 "pequenos" elevaram o custo anual em 3,8 pontos percentuais.
  Por isso a comparação entre ofertas deve ser feita pelo CET, e não pelo
  valor da parcela nem pela taxa de juros nominal.
]

#resumo[
  - Prestação = juros do saldo + amortização. O saldo devedor é sempre o
    VP das prestações que faltam.
  - #strong[Price:] prestação constante; amortização cresce em PG de razão
    $(1+i)$. #strong[SAC:] amortização constante; prestações em PA
    decrescente; juros totais $= i dot "PV" (n+1)/2$.
  - SAC paga menos juros no total, mas começa com prestação maior; o
    #emph[custo por real emprestado] é igual nos dois (taxa $i$).
  - #strong[CET] = TIR do fluxo líquido do cliente; inclui tarifas,
    tributos e seguros. É a medida correta para comparar ofertas.
]
%%% END
