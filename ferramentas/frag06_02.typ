%%% BEFORE: === 2.2. Taxas Proporcionais (Juros Simples)
#intuicao[
  Pense em um aluguel: o proprietário cobra R\$ 800 por mês, #emph[sempre]
  R\$ 800, mesmo que o inquilino fique cinco anos. O ganho em reais é
  constante, e o ganho total cresce em linha reta com o tempo. É isso que
  os juros simples fazem: o juro de cada período é uma constante
  ($"PV" dot i$), e o juro total é essa constante multiplicada pelo número
  de períodos.
]

#exemplo("multa e juros de mora de um boleto")[
  Um boleto de R\$ 1.500,00 foi pago com 17 dias de atraso. O contrato
  prevê multa de 2% (cobrada uma só vez) e juros de mora de 1% a.m.,
  proporcionais ao número de dias ("#emph[pro rata die]"). Quanto se paga?

  - Multa: $1.500 times 2% = 30,00$.
  - Juros de mora: taxa diária proporcional $= 1% / 30$; em 17 dias,
    $1.500 times 1%/30 times 17 = 8,50$.
  - Total: $1.500 + 30,00 + 8,50 = $ #strong[R\$ 1.538,50].

  Repare que a taxa foi dividida por 30 --- uma #strong[proporção] simples,
  característica do regime simples.
]

```python
def boleto_atrasado(valor, dias, multa=0.02, mora_am=0.01):
    """Multa fixa + juros de mora simples pro rata die (mês comercial de 30 dias)."""
    v_multa = valor * multa
    v_mora = valor * mora_am / 30 * dias
    return v_multa, v_mora, valor + v_multa + v_mora

m, j, total_boleto = boleto_atrasado(1500, 17)
print(f"Multa: R${m:.2f} | Juros de mora: R${j:.2f} | Total: R${total_boleto:.2f}")
```

#exemplo("incógnitas diferentes")[
  Um capital rendeu R\$ 480,00 de juros simples em 6 meses a 1,6% a.m. De
  quanto era o capital?

  $ J = "PV" dot i dot n quad arrow.r.double quad "PV" = J / (i dot n) = 480 / ("0,016" dot 6) = 5.000 $

  E se o capital fosse conhecido (R\$ 5.000) e o prazo, não? A fórmula
  explicita $n = J/("PV" dot i) = 480/(5.000 dot 0,016) = 6$ meses. A
  mesma equação resolve as quatro situações --- por isso os livros
  costumam apresentar um único "triângulo" $J = "PV" dot i dot n$.
]

%%% BEFORE: === 2.3. Juros Exatos vs Juros Comerciais
#exemplo("proporcional não é só uma regra de três")[
  Uma taxa de 18% a.a. em juros simples equivale a 1,5% a.m. e a 4,5% a.t.
  Para R\$ 1.000 em um ano:

  - Taxa anual: $1.000 times (1 + 0,18 times 1) = 1.180,00$
  - Taxa mensal: $1.000 times (1 + 0,015 times 12) = 1.180,00$
  - Taxa trimestral: $1.000 times (1 + 0,045 times 4) = 1.180,00$

  Todas dão o mesmo montante: em juros simples, taxas proporcionais são
  #strong[equivalentes]. Essa propriedade #strong[não vale] no regime
  composto: 1,5% a.m. capitalizados 12 vezes produzem $1,015^12 = 1,1956$
  (19,56% a.a.), não 18%.
]

%%% BEFORE: === 2.4. Descontos Simples
#teoria("o que significa \"ano de 360 dias\"")[
  O mercado usa três convenções de contagem de dias, e a escolha altera o
  valor dos juros:

  #figure(
    align(center)[#table(
      columns: (24%, 40%, 36%),
      align: (left, left, left),
      table.header([Convenção], [Como conta], [Fórmula do juro simples],),
      [Comercial (30/360)], [Cada mês tem 30 dias; o ano, 360], [$J = "PV" dot i_(a a) dot d_(30\/360)/360$],
      [Bancária (real/360)], [Dias corridos reais; ano de 360 dias], [$J = "PV" dot i_(a a) dot d_("real")/360$],
      [Exata (real/365)], [Dias corridos reais; ano de 365 dias], [$J = "PV" dot i_(a a) dot d_("real")/365$],
    )]
    , kind: table
    )

  A convenção #strong[bancária] é a mais usada em operações de crédito de
  curto prazo: ela divide por 360, mas conta os dias reais do calendário.
  Isso a torna #strong[mais cara] que a exata em 365/360 $approx$ 1,39%.
]

```python
from datetime import date

def dias_30_360(d1, d2):
    """Contagem de dias pelo método comercial: todo mês tem 30 dias."""
    return (d2.year - d1.year) * 360 + (d2.month - d1.month) * 30 + (min(d2.day, 30) - min(d1.day, 30))

inicio, fim = date(2026, 3, 10), date(2026, 6, 18)
capital_ex2, taxa_aa_ex2 = 50000, 0.12
d_real = (fim - inicio).days
d_com = dias_30_360(inicio, fim)

print(f"Dias reais: {d_real} | dias na contagem 30/360: {d_com}")
print(f"Comercial 30/360 : R${capital_ex2 * taxa_aa_ex2 * d_com / 360:,.2f}")
print(f"Bancária real/360: R${capital_ex2 * taxa_aa_ex2 * d_real / 360:,.2f}")
print(f"Exata real/365   : R${capital_ex2 * taxa_aa_ex2 * d_real / 365:,.2f}")
```

%%% BEFORE: === 2.5. Equivalência entre Taxa de Desconto e Taxa de Juros
#intuicao[
  Descontar um título é #strong[comprá-lo com deságio]. Quem desconta
  recebe hoje menos que o valor de face, e a diferença é o ganho de quem
  compra o título. A pergunta decisiva é: #emph[sobre que valor] a taxa
  incide? No desconto #strong[comercial] (por fora), incide sobre o valor
  #emph[futuro], que é maior que o valor efetivamente emprestado --- por
  isso a taxa "de desconto" #strong[subestima] o custo real.
]

#exemplo("antecipação de uma duplicata")[
  Uma empresa antecipa uma duplicata de R\$ 20.000 que vence em 90 dias.
  O banco cobra taxa de desconto comercial de 2,5% a.m.

  - Desconto: $D_c = 20.000 times 0,025 times 3 = 1.500,00$.
  - Valor líquido recebido: $20.000 - 1.500 = 18.500,00$.
  - Taxa de juros efetiva (simples): a empresa pegou R\$ 18.500 e devolve
    R\$ 20.000 em 3 meses, logo
    $i = 1.500 / (18.500 dot 3) = 2,70%$ a.m. --- maior que os 2,5%
    anunciados. Pela fórmula da seção 2.5,
    $i = d/(1 - d n) = 0,025/(1 - 0,075) = 2,70%$.
  - Em juros #strong[compostos], a taxa efetiva seria
    $(20.000/18.500)^(1\/3) - 1 = 2,63%$ a.m.

  Pelo desconto #strong[racional] à mesma taxa, o valor líquido seria
  $20.000/(1 + 0,025 times 3) = 18.604,65$: R\$ 104,65 a mais para a empresa.
]

```python
face, d_mensal, meses_dup = 20000, 0.025, 3
desc_comercial = face * d_mensal * meses_dup
liquido_comercial = face - desc_comercial
liquido_racional = face / (1 + d_mensal * meses_dup)

print(f"Desconto comercial: R${desc_comercial:,.2f} | líquido: R${liquido_comercial:,.2f}")
print(f"Desconto racional : R${face - liquido_racional:,.2f} | líquido: R${liquido_racional:,.2f}")
print(f"Taxa efetiva simples : {desc_comercial / liquido_comercial / meses_dup * 100:.2f}% a.m.")
print(f"Taxa efetiva composta: {((face / liquido_comercial) ** (1 / meses_dup) - 1) * 100:.2f}% a.m.")
```

#teoria("a relação entre os dois descontos")[
  Seja $"FV"$ o valor de face. Pelas definições,

  $ D_c = "FV" dot i dot n quad "e" quad D_r = ("FV" dot i dot n)/(1 + i n) $

  (o desconto racional é calculado sobre $"PV" = "FV"/(1 + i n)$).
  Dividindo uma expressão pela outra, obtém-se
  $D_c = D_r dot (1 + i n)$. Como $1 + i n > 1$, o desconto comercial é
  sempre #strong[maior] que o racional, #strong[à mesma taxa]. Verificação
  com a tabela da seção 2.4: $283,02 times 1,06 = 300,00$ ✓.
]

#mercado[
  #strong[Desconto de recebíveis.] Empresas antecipam duplicatas, cheques
  pré-datados e recebíveis de cartão cotando a #emph[taxa de desconto] em
  % ao mês. Além do deságio, incidem IOF e tarifas, o que eleva o custo
  efetivo acima do $d/(1 - d n)$ calculado aqui. A comparação correta entre
  propostas de dois bancos é sempre pela #strong[taxa efetiva] (ou CET, seção
  5.7), nunca pela taxa de desconto anunciada.
]

%%% BEFORE: === 2.6. Prazo Médio de um Conjunto de Títulos
#exemplo("de desconto para juros")[
  Um título de R\$ 10.000 vence em 60 dias e é descontado a 3,5% a.m.
  (desconto comercial).

  - Valor líquido: $10.000 times (1 - 0,035 times 2) = 9.300,00$.
  - Taxa de juros equivalente: $i = d/(1 - d n) = 0,035/(1 - 0,07) = 3,76%$ a.m.

  #strong[Demonstração da fórmula.] No desconto comercial,
  $"PV" = "FV"(1 - d n)$. Na ótica dos juros simples, $"FV" = "PV"(1 + i n)$.
  Substituindo uma na outra: $(1 - d n)(1 + i n) = 1$, e isolando $i$,
  $i = d/(1 - d n)$ --- que existe apenas se $d n < 1$.
]

%%% BEFORE_CHAPTER_END: == Capítulo 3 --- Juros Compostos
#teoria("equivalência de capitais e a data focal")[
  Dois valores em datas distintas são #strong[equivalentes] quando valem o
  mesmo na data focal escolhida. É o princípio que sustenta a troca de
  um conjunto de títulos por outro (renegociação, refinanciamento).

  Em juros simples há um problema sutil: o resultado #strong[depende da
  data focal] escolhida. Exemplo: substituir dois títulos de R\$ 6.000
  (vencimentos em 30 e 60 dias) por um único título com vencimento em 90
  dias, a 2% a.m. de juros simples.

  - Focal em #strong[hoje] (desconto racional): $"VP" = 6.000/1,02 +
    6.000/1,04 = 11.651,58$; no dia 90, $11.651,58 times 1,06 = 12.350,68$.
  - Focal no #strong[dia 90] (capitalizando): $6.000 times 1,04 + 6.000
    times 1,02 = 12.360,00$.

  Os dois resultados diferem em R\$ 9,32. Em juros #strong[compostos] a
  diferença desaparece: dinheiro cresce exponencialmente e o resultado é
  independente da data focal --- uma das razões de o regime composto ser
  o padrão no mercado.
]

#exemplo("prazo médio na prática")[
  Três títulos (R\$ 5.000 em 30 dias, R\$ 8.000 em 60 e R\$ 7.000 em 90)
  serão substituídos por um único de R\$ 20.000. Em que prazo ele deve
  vencer para que a troca seja justa?

  $ n_("médio") = (5.000 dot 30 + 8.000 dot 60 + 7.000 dot 90)/(5.000 + 8.000 + 7.000) = 1.260.000/20.000 = 63 "dias" $

  #strong[Cuidado:] o prazo médio é #strong[exato apenas no desconto
  comercial simples]. Com desconto de 2% a.m.:
  os três títulos valem hoje $19.160,00$ e o título único de 63 dias também
  ($20.000 times (1 - 0,02 times 2,1) = 19.160,00$). No desconto
  #strong[racional], os valores são R\$ 19.198,04 e R\$ 19.193,86: próximos,
  mas não iguais.
]

```python
titulos_ex = [(5000, 30), (8000, 60), (7000, 90)]   # (valor de face, dias)
taxa_dia = 0.02 / 30
soma_face = sum(v for v, _ in titulos_ex)
pm = sum(v * d for v, d in titulos_ex) / soma_face

vp_com_orig = sum(v * (1 - taxa_dia * d) for v, d in titulos_ex)
vp_com_unico = soma_face * (1 - taxa_dia * pm)
vp_rac_orig = sum(v / (1 + taxa_dia * d) for v, d in titulos_ex)
vp_rac_unico = soma_face / (1 + taxa_dia * pm)

print(f"Prazo médio: {pm:.1f} dias")
print(f"Desconto comercial -> originais: R${vp_com_orig:,.2f} | título único: R${vp_com_unico:,.2f}")
print(f"Desconto racional  -> originais: R${vp_rac_orig:,.2f} | título único: R${vp_rac_unico:,.2f}")
```

#resumo[
  - Juros simples: $J = "PV" dot i dot n$ e $"FV" = "PV"(1 + i n)$; o
    crescimento é linear. Taxas proporcionais são equivalentes.
  - O número de dias depende da #strong[convenção]: 30/360, real/360 ou
    real/365. Em crédito bancário usa-se geralmente real/360.
  - Desconto comercial: $D_c = "FV" dot d dot n$. Desconto racional:
    $D_r = D_c/(1 + i n)$. O comercial é maior, e a taxa efetiva do
    comercial é $d/(1 - d n)$.
  - Prazo médio e equivalência de capitais dependem da data focal em juros
    simples --- outra razão para preferir o regime composto.
]
%%% END
