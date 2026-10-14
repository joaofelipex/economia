%%% BEFORE_CHAPTER_END: == Capítulo 9 --- Exercícios Resolvidos
#strong[Tabela 8.2 --- Fórmulas dos sistemas de amortização e de análise de investimentos.]

#figure(
  align(center)[#table(
    columns: (30%, 42%, 28%),
    align: (left, left, left),
    table.header([Conceito], [Fórmula], [Observação],),
    [Fator de valor presente da série], [$a_(n|i) = (1 - (1+i)^(-n))/i$], [$"PV" = "PMT" dot a_(n|i)$],
    [Fator de valor futuro da série], [$s_(n|i) = ((1+i)^n - 1)/i$], [$"FV" = "PMT" dot s_(n|i)$],
    [Saldo devedor (Price)], [$"SD"_k = "PMT" dot a_(n-k|i)$], [Método prospectivo],
    [Amortização (Price)], [$A_k = A_1 (1+i)^(k-1)$], [$A_1 = "PMT" - "PV" i$],
    [Prestação (SAC)], [$"PMT"_k = "PV"/n (1 + i(n-k+1))$], [PA decrescente],
    [Total de juros (SAC)], [$i dot "PV" (n+1)/2$], [Soma de PA],
    [Juros totais (Price)], [$n dot "PMT" - "PV"$], [Maior que o SAC],
    [Fundo de amortização], [$D = "PV" dot i_("fundo")/((1+i_("fundo"))^n - 1)$], [Sistema Americano],
    [Taxa de desconto → juros], [$i = d/(1 - d n)$], [Desconto comercial simples],
    [Inflação implícita], [$pi_("be") = (1+i_("pré"))/(1 + r) - 1$], [Pré × IPCA+],
    [Índice de lucratividade], [$"IL" = 1 + "VPL"/|"FC"_0|$], [Racionamento de capital],
    [VPLA], [$"VPL" dot i/(1 - (1+i)^(-n))$], [Prazos diferentes],
    [Preço de Gordon], [$P_0 = D_1/(i - g)$], [Exige $i > g$],
  )]
  , kind: table
  )

%%% BEFORE_CHAPTER_END: == Capítulo 10 --- Exercícios para Executar (na mão)
#line()

#strong[E8.] Um fundo de investimento rendeu 0,9%, 1,1% e −0,4% em três
meses consecutivos. Calcule (a) a rentabilidade acumulada no trimestre,
(b) a rentabilidade mensal média e (c) a rentabilidade anualizada, supondo
que o ritmo médio se mantenha.

#strong[Solução.]

- #strong[(a) Acumulada:] taxas sucessivas #strong[multiplicam-se]:
  $1,009 times 1,011 times 0,996 = 1,016019$, ou seja, #strong[1,6019%] no
  trimestre.
- #strong[(b) Média mensal:] a média correta é a #strong[geométrica]:
  $1,016019^(1\/3) - 1 = 0,5311%$ a.m. A média aritmética,
  $(0,9 + 1,1 - 0,4)/3 = 0,5333%$, está #strong[errada] para rentabilidades:
  ela superestima o ganho porque ignora o efeito de a perda de −0,4% ter
  incidido sobre um capital já maior.
- #strong[(c) Anualizada:] $1,016019^4 - 1 = 6,56%$ a.a. (e não
  $12 times 0,5311% = 6,37%$).

```python
rent_mensais = [0.009, 0.011, -0.004]
fator_trim = 1.0
for r_m in rent_mensais:
    fator_trim *= 1 + r_m
media_geo = fator_trim ** (1 / len(rent_mensais)) - 1
print(f"Acumulada no trimestre: {(fator_trim - 1)*100:.4f}%")
print(f"Média geométrica mensal: {media_geo*100:.4f}% | média aritmética (errada): {sum(rent_mensais)/3*100:.4f}%")
print(f"Anualizada: {((1 + media_geo) ** 12 - 1)*100:.2f}% a.a.")
```

#line()

#strong[E9.] Um eletrodoméstico é vendido em 10 parcelas mensais de R\$ 480,
sem entrada, com juros de 2,2% a.m. (a) Qual é o preço à vista implícito?
(b) Quanto de juros está embutido? (c) E se a primeira parcela fosse paga no
ato?

#strong[Solução.]

+ #strong[Tipo:] série postecipada. $"PV" = 480 dot a_(10|2,2%) =
  480 times (1 - 1,022^(-10))/0,022 = $ #strong[R\$ 4.266,87].
+ #strong[Juros embutidos:] $10 times 480 - 4.266,87 = $ #strong[R\$ 533,13]
  (cerca de 11% do valor à vista).
+ #strong[Primeira parcela no ato:] série antecipada,
  $"PV"_("ant") = "PV" dot (1 + i) = 4.266,87 times 1,022 = $ #strong[R\$
  4.360,74]. O produto "vale mais" porque cada parcela foi paga um mês
  mais cedo.

```python
parc_e9, taxa_e9, n_e9 = 480, 0.022, 10
vp_e9 = parc_e9 * (1 - (1 + taxa_e9) ** -n_e9) / taxa_e9
print(f"(a) Preço à vista implícito: R${vp_e9:,.2f}")
print(f"(b) Juros embutidos: R${parc_e9 * n_e9 - vp_e9:,.2f}")
print(f"(c) Valor presente se a 1ª parcela for no ato: R${vp_e9 * (1 + taxa_e9):,.2f}")
```

#line()

#strong[E10.] Um financiamento de R\$ 18.000 será pago em 10 parcelas pelo
Sistema Price, a 1,6% a.m. Passados 4 pagamentos, o cliente quer quitar a
dívida. (a) Qual o valor da prestação? (b) Qual o valor da quitação? (c) Quanto
de juros ele economiza em relação a pagar as 6 parcelas restantes?

#strong[Solução.]

+ $"PMT" = 18.000 dot 0,016/(1 - 1,016^(-10)) = $ #strong[R\$ 1.962,17].
+ Pelo método prospectivo (seção 5.1), o saldo após o 4º pagamento é o VP
  das 6 prestações restantes: $"SD"_4 = 1.962,17 dot a_(6|1,6%) = $
  #strong[R\$ 11.140,88].
+ Pagando as 6 parcelas: $6 times 1.962,17 = 11.773,02$. Economia:
  $11.773,02 - 11.140,88 = $ #strong[R\$ 632,14] --- os juros dos
  meses futuros, que deixam de ser devidos.

```python
parc_e10 = 18000 * 0.016 / (1 - 1.016 ** -10)
saldo_prosp = parc_e10 * (1 - 1.016 ** -6) / 0.016
print(f"(a) Prestação: R${parc_e10:,.2f}")
print(f"(b) Saldo para quitação após 4 pagamentos (prospectivo): R${saldo_prosp:,.2f}")
print(f"(c) Economia vs. pagar as 6 parcelas: R${6 * parc_e10 - saldo_prosp:,.2f}")
tab_e10, _ = tabela_price(18000, 0.016, 10)
print(f"Conferência pela tabela Price (saldo após a 4ª): R${tab_e10[3]['saldo_devedor']:,.2f}")
```

#line()

#strong[E11.] Um CDB prefixado rende 11% a.a. brutos e fica aplicado por 365
dias (alíquota de IR de 17,5%, conforme a tabela regressiva da seção 12.2).
A inflação do período foi de 4,5%. Qual a rentabilidade #strong[líquida real]?

#strong[Solução.] Passos: (1) rendimento bruto $= 11%$; (2) IR sobre o
#strong[rendimento]: $11% times 17,5% = 1,925%$; (3) rendimento líquido
nominal $= 11% - 1,925% = 9,075%$; (4) taxa real pela equação de Fisher,
$1,09075/1,045 - 1 = $ #strong[4,38%] a.a.

#atencao[
  O imposto incide sobre o #strong[rendimento], não sobre o valor
  resgatado: ao calcular o líquido, aplique a alíquota sobre o #emph[ganho]
  (11%), e não sobre 1,11.
]

```python
bruto_e11, aliq_e11, infl_e11 = 0.11, 0.175, 0.045
liquido_nominal = bruto_e11 * (1 - aliq_e11)
liquido_real = (1 + liquido_nominal) / (1 + infl_e11) - 1
print(f"Líquido nominal: {liquido_nominal*100:.3f}% | líquido real: {liquido_real*100:.2f}% a.a.")
```

#line()

#strong[E12.] Um projeto exige R\$ 50.000 e promete fluxos de R\$ 12.000,
R\$ 18.000, R\$ 22.000 e R\$ 25.000 nos quatro anos seguintes. TMA = 12% a.a.
Calcule o VPL, a TIR e os paybacks, e conclua sobre a viabilidade.

#strong[Solução.] O fluxo #strong[não é uniforme], portanto não há atalho
com $a_(n|i)$: desconta-se ano a ano. VPL $= -50.000 + 12.000/1,12 +
18.000/1,12^2 + 22.000/1,12^3 + 25.000/1,12^4$. A TIR (por tentativas ou
pela função `tir`) e os paybacks saem do código:

```python
fluxos_e12 = [-50000, 12000, 18000, 22000, 25000]
print(f"VPL a 12%: R${vpl(0.12, fluxos_e12):,.2f}")
print(f"TIR: {tir(fluxos_e12)*100:.2f}% a.a.")
print(f"Payback simples: {payback(fluxos_e12):.2f} anos | descontado: {payback(fluxos_e12, 0.12):.2f} anos")
```

#strong[Conclusão.] VPL positivo e TIR (17,43%) acima da TMA (12%): o
projeto é #strong[viável]. O payback simples (2,91 anos) é menor que o
descontado (3,58 anos), como deve ser: descontar os fluxos adia a
recuperação. Como o horizonte é de 4 anos, o investimento é recuperado
(já em termos de valor presente) com folga de cerca de 5 meses.

#line()

#strong[E13.] Uma fundação quer pagar uma bolsa de R\$ 60.000 por ano,
#strong[para sempre], com recursos aplicados a 7% a.a. (a) Qual capital
inicial, se a primeira bolsa for paga daqui a um ano? (b) E se o primeiro
pagamento for hoje? (c) E se a bolsa crescer 3% a.a., com a primeira em um
ano?

#strong[Solução.] (a) Perpetuidade postecipada: $60.000/0,07 = $ #strong[R\$ 857.142,86].
(b) Antecipada: soma-se o pagamento de hoje: $60.000 + 857.142,86 = $
#strong[R\$ 917.142,86]. (c) Perpetuidade crescente (Gordon):
$60.000/(0,07 - 0,03) = $ #strong[R\$ 1.500.000,00]. Repare que um crescimento de
3% quase dobra o capital exigido: a "proteção contra a inflação" é cara.

```python
bolsa, taxa_f, cresc_f = 60000, 0.07, 0.03
print(f"(a) Primeira bolsa em 1 ano: R${bolsa / taxa_f:,.2f}")
print(f"(b) Primeira bolsa hoje    : R${bolsa + bolsa / taxa_f:,.2f}")
print(f"(c) Bolsa crescendo {cresc_f:.0%}   : R${bolsa / (taxa_f - cresc_f):,.2f}")
```

%%% BEFORE_CHAPTER_END: == Capítulo 14 --- Glossário
#line()

== Capítulo 12 --- Aplicações no Mercado Brasileiro
<capítulo-12-aplicações-no-mercado-brasileiro>
Este capítulo reúne situações do dia a dia financeiro, resolvidas com as
ferramentas dos capítulos anteriores. A ideia é treinar o olhar: reconhecer
em um anúncio, em um extrato ou em uma proposta qual é o #strong[fluxo de
caixa] escondido por trás e qual é a #strong[taxa efetiva] da operação.

=== 12.1. "Sem juros" é sempre sem juros?
<sem-juros-é-sempre-sem-juros>
O parcelamento "sem juros" é um dos produtos de crédito mais comuns no
varejo. Há dois fatos a considerar. Primeiro: se a loja oferece #strong[desconto
para pagamento à vista], o parcelamento esconde uma taxa de juros. Segundo:
mesmo quando o preço é idêntico, o parcelamento tem valor para o comprador,
porque o dinheiro #emph[fica aplicado] durante o prazo.

#exemplo("o desconto à vista revela a taxa")[
  Um produto custa R\$ 1.200 em 3 parcelas "sem juros" de R\$ 400, ou R\$
  1.140 à vista (5% de desconto). Qual a taxa de juros implícita?

  O fluxo de quem parcela, comparado ao pagamento à vista, é: recebe
  R\$ 1.140 em valor de hoje (o que deixou de pagar) e paga 3 parcelas de R\$
  400. A taxa que iguala $1.140 = 400 dot a_(3|i)$ é
  #strong[2,61% a.m.] (36,2% a.a.). Parcelar nesse caso #strong[é caro]: seria
  melhor pagar à vista, a menos que o dinheiro rendesse mais de 2,61% a.m.

  Já se o preço à vista for igual (R\$ 1.200), a taxa implícita é 0% e o
  parcelamento é vantajoso para quem consegue aplicar o dinheiro: a 1% a.m.,
  as parcelas valem hoje $400 dot a_(3|1%) = $ R\$ 1.176,39, ou seja, uma
  economia de R\$ 23,61.
]

```python
a_vista, parcela_loja, n_loja = 1140, 400, 3
taxa_implicita_loja = bisseccao(lambda r: vp_das_parcelas(r, parcela_loja, n_loja) - a_vista, 1e-9, 1)
print(f"Taxa implícita: {taxa_implicita_loja*100:.2f}% a.m. = {((1 + taxa_implicita_loja) ** 12 - 1)*100:.1f}% a.a.")
print(f"Preço igual: VP das 3 parcelas a 1% a.m. = R${vp_das_parcelas(0.01, 400, 3):,.2f} (vs. R$1.200 à vista)")
```

=== 12.2. CDB, LCI e imposto de renda regressivo
<cdb-lci-e-imposto-de-renda-regressivo>
Os rendimentos de renda fixa tributados têm Imposto de Renda #strong[regressivo
no tempo]: quanto mais tempo o dinheiro fica aplicado, menor a alíquota
sobre o #emph[rendimento] (não sobre o principal).

#figure(
  align(center)[#table(
    columns: (50%, 50%),
    align: (left, center),
    table.header([Prazo da aplicação], [Alíquota de IR],),
    [até 180 dias], [22,5%],
    [de 181 a 360 dias], [20,0%],
    [de 361 a 720 dias], [17,5%],
    [acima de 720 dias], [15,0%],
  )]
  , kind: table
  )

Papéis como #strong[LCI] e #strong[LCA] (e, para pessoa física, debêntures
incentivadas) são #strong[isentos] de IR, e por isso pagam taxas brutas
menores. Para compará-los com um CDB, calcula-se a #strong[taxa bruta
equivalente]: $i_("bruta") = i_("líq")/(1 - "IR")$.

#exemplo("qual rende mais em um ano?")[
  Com CDI de 13,25% a.a. e aplicação por 365 dias (alíquota 17,5%): um CDB a
  100% do CDI rende 13,25% brutos e $13,25% times (1 - 0,175) approx
  10,93%$ líquidos. Uma LCI a 90% do CDI rende #strong[cerca de 11,85% líquidos],
  isentos. Portanto, a LCI é melhor. Qual percentual do CDI um CDB
  precisaria pagar para igualar a LCI de 90%?
  $0,90/(1 - 0,175) approx 1,09$, ou seja, cerca de #strong[109% do CDI].
]

```python
def aliquota_ir(dias):
    if dias <= 180: return 0.225
    if dias <= 360: return 0.20
    if dias <= 720: return 0.175
    return 0.15

def rendimento_renda_fixa(valor, pct_cdi, cdi_aa, dias_corridos, isento=False):
    dias_uteis = round(dias_corridos * 252 / 365)
    cdi_dia = (1 + cdi_aa) ** (1 / 252) - 1
    bruto = valor * ((1 + cdi_dia * pct_cdi) ** dias_uteis - 1)     # % do CDI incide sobre a taxa diária
    ir = 0 if isento else bruto * aliquota_ir(dias_corridos)
    return bruto, ir, bruto - ir

for nome_t, pct_t, iso_t in [("CDB 100% CDI", 1.00, False), ("CDB 110% CDI", 1.10, False), ("LCI 90% CDI (isenta)", 0.90, True)]:
    b_t, ir_t, liq_t = rendimento_renda_fixa(10000, pct_t, 0.1325, 365, iso_t)
    print(f"{nome_t:<22} bruto R${b_t:8.2f} | IR R${ir_t:7.2f} | líquido R${liq_t:8.2f} ({liq_t / 10000:.2%})")
```

#mercado[
  #strong[Poupança.] A caderneta rende, mensalmente, 0,5% mais a Taxa
  Referencial (TR) quando a meta Selic é superior a 8,5% a.a.; quando a
  Selic é igual ou inferior a 8,5%, rende 70% da Selic mais a TR. É isenta de IR
  para pessoas físicas. Como a regra pode ser alterada por lei, confirme
  sempre o texto vigente.
]

=== 12.3. O custo do rotativo do cartão de crédito
<o-custo-do-rotativo-do-cartão-de-crédito>
Juros mensais altos, compostos, produzem números impressionantes. Uma dívida
de R\$ 1.000 a 12% a.m. (taxa comum em linhas de crédito rotativo e
cheque especial no passado recente) cresce, sem pagamentos, para
$1.000 times 1,12^6 = $ R\$ 1.973,82 em 6 meses e para
$1.000 times 1,12^12 = $ R\$ 3.895,98 em um ano --- um acréscimo de
#strong[289,6% ao ano]. Lembre-se do Capítulo 3: a taxa anual #strong[não] é
12 $times$ 12% = 144%, e sim $1,12^12 - 1$.

#atencao[
  A legislação mais recente passou a limitar o custo total do rotativo, e a
  regulamentação do cheque especial também tem limites. Esses tetos mudam
  com o tempo: consulte a regra vigente. Mas a #strong[matemática] do
  composto, mostrada aqui, não muda --- é por ela que as dívidas de
  juros altos crescem tão depressa.
]

=== 12.4. Financiamento imobiliário: Price × SAC em 30 anos
<financiamento-imobiliário-price-sac-em-30-anos>
#exemplo("financiamento de 300 mil em 360 meses a 10% a.a.")[
  A taxa mensal equivalente é $1,10^(1\/12) - 1 = 0,7974%$ a.m. (e não
  $10%/12 = 0,8333%$). Sem considerar TR, seguros e tarifas:

  - #strong[SAC:] amortização de R\$ 833,33 por mês; 1ª prestação
    $833,33 + 300.000 times 0,007974 = $ R\$ 3.225,58; última, R\$ 839,98.
  - #strong[Price:] prestação fixa de R\$ 2.537,67.
]

```python
imob_pv, imob_aa, imob_n = 300000, 0.10, 360
imob_i = (1 + imob_aa) ** (1 / 12) - 1
tab_p, juros_p = tabela_price(imob_pv, imob_i, imob_n)
tab_s, juros_s = tabela_sac(imob_pv, imob_i, imob_n)
print(f"Taxa mensal equivalente: {imob_i*100:.4f}% a.m.")
print(f"Price: prestação R${tab_p[0]['prestacao']:,.2f} | juros totais R${juros_p:,.2f}")
print(f"SAC  : 1ª R${tab_s[0]['prestacao']:,.2f} -> última R${tab_s[-1]['prestacao']:,.2f} | juros totais R${juros_s:,.2f}")
print(f"Diferença de juros (Price - SAC): R${juros_p - juros_s:,.2f}")
print(f"Renda mínima (30%): Price R${tab_p[0]['prestacao']/0.3:,.2f} | SAC R${tab_s[0]['prestacao']/0.3:,.2f}")
```

Em prazos longos, a diferença de juros totais entre Price e SAC é
enorme (mais de R\$ 180 mil neste exemplo), mas o SAC exige uma renda inicial
maior. Quem escolhe o Price, em geral, paga o preço da entrada mais fácil
ao longo de décadas.

=== 12.5. Planejamento de aposentadoria: acumular e depois consumir
<planejamento-de-aposentadoria-acumular-e-depois-consumir>
O planejamento de aposentadoria combina duas séries: a #strong[fase de
acumulação] (valor futuro de aportes) e a #strong[fase de consumo] (valor
presente de saques, ou perpetuidade). Trabalhar em #strong[termos reais]
(descontando a inflação) evita erros: usa-se uma taxa #strong[real] de retorno e valores
em reais de hoje.

#exemplo("de quanto poupar por mês?")[
  Meta: viver de uma renda de R\$ 5.000 por mês (em reais de hoje), para
  sempre, com retorno real de 0,5% a.m. (cerca de 6,2% a.a. reais).

  + #strong[Capital necessário] (perpetuidade): $5.000/0,005 = $ R\$ 1.000.000.
  + #strong[Aporte para acumulá-lo em 30 anos] (360 meses), à mesma taxa
    real: $"PMT" = "FV" dot i/((1 + i)^n - 1) = 1.000.000 times
    0,005/(1,005^360 - 1) = $ #strong[R\$ 995,51 por mês].

  O resultado surpreende: cerca de 64% do patrimônio final vem de #emph[rendimentos] (os aportes somam R\$ 358 mil dos R\$ 1 milhão).
  Atrasar o início por 10 anos (acumular em 20 anos) mais que dobra o aporte
  necessário --- é o efeito do tempo sobre o composto.
]

```python
renda_alvo, taxa_real_m = 5000, 0.005
capital_alvo = renda_alvo / taxa_real_m
for anos_ac in (30, 20, 10):
    n_m = anos_ac * 12
    aporte_ac = capital_alvo * taxa_real_m / ((1 + taxa_real_m) ** n_m - 1)
    print(f"Acumular em {anos_ac} anos: aporte de R${aporte_ac:,.2f}/mês "
          f"(total aportado R${aporte_ac * n_m:,.0f} = {aporte_ac * n_m / capital_alvo:.0%} do capital)")
```

#line()

== Capítulo 13 --- Erros Comuns e Teste Rápido
<capítulo-13-erros-comuns-e-teste-rápido>
=== 13.1. Os dez erros que mais reprovam
<os-dez-erros-que-mais-reprovam>
#figure(
  align(center)[#table(
    columns: (4%, 38%, 58%),
    align: (center, left, left),
    table.header([\#], [Erro], [Como evitar],),
    [1], [Taxa mensal com prazo em anos (ou o contrário)], [Escreva a unidade ao lado de cada número; padronize antes de calcular],
    [2], [Dividir a taxa anual por 12 em juros compostos], [Use a taxa #strong[equivalente]: $(1 + i_a)^(1\/12) - 1$],
    [3], [Somar inflações mensais em vez de multiplicar fatores], [Acumule com $product (1 + pi_t)$],
    [4], [Subtrair inflação da taxa nominal em taxas altas], [Use Fisher: $(1+i_n)/(1+pi) - 1$],
    [5], [Somar valores de datas diferentes], [Leve tudo para a #strong[mesma data focal]],
    [6], [Confundir "com entrada" com série antecipada], [Antecipada só se a entrada for igual às demais parcelas],
    [7], [Trocar o primeiro pagamento: série postecipada × antecipada], [O VP da postecipada fica #strong[um período antes] do 1º pagamento],
    [8], [Usar a taxa de desconto comercial como se fosse taxa de juros], [Converta: $i = d/(1 - d n)$],
    [9], [Escolher projeto pela maior TIR (excludentes)], [Decida pelo #strong[maior VPL] à TMA],
    [10], [Arredondar taxas intermediárias], [Guarde todas as casas até o resultado final],
  )]
  , kind: table
  )

=== 13.2. Teste rápido: verdadeiro ou falso (com gabarito)
<teste-rápido-verdadeiro-ou-falso-com-gabarito>
+ #strong[V ou F:] 2% a.m. em juros compostos equivalem a 24% a.a.
  #strong[Falso.] Equivalem a $1,02^12 - 1 = 26,82%$ a.a.; 24% é a taxa
  proporcional (nominal).
+ #strong[V ou F:] No desconto comercial, a taxa efetiva de juros é maior
  que a taxa de desconto. #strong[Verdadeiro.] $i = d/(1 - d n) > d$.
+ #strong[V ou F:] Em um financiamento SAC, a 1ª prestação é menor que no
  Price. #strong[Falso.] A 1ª prestação do SAC é #strong[maior]; é a
  última que é menor.
+ #strong[V ou F:] O SAC e o Price têm o mesmo custo efetivo (taxa $i$)
  quando a taxa contratada é a mesma. #strong[Verdadeiro.] Os valores
  presentes das prestações, descontados a $i$, são iguais ao valor financiado.
+ #strong[V ou F:] Quanto maior a TMA, maior o VPL. #strong[Falso.] O VPL é
  #strong[decrescente] em relação à taxa de desconto (fluxos positivos futuros).
+ #strong[V ou F:] Um projeto com TIR de 30% é sempre melhor que outro com
  TIR de 18%. #strong[Falso.] Para projetos excludentes, a escala e o prazo
  importam; decide-se pelo VPL.
+ #strong[V ou F:] Se a inflação é 6% e a taxa nominal 6%, o ganho real é
  zero. #strong[Verdadeiro.] $1,06/1,06 - 1 = 0$.
+ #strong[V ou F:] Em perpetuidade com crescimento, o valor presente existe
  para qualquer $g$. #strong[Falso.] Exige $g < i$.
+ #strong[V ou F:] Pagamentos de aluguel feitos no início do mês formam uma
  série postecipada. #strong[Falso.] São #strong[antecipados].
+ #strong[V ou F:] A média aritmética das rentabilidades mensais é a
  rentabilidade mensal média correta. #strong[Falso.] Use a média
  #strong[geométrica], pois rentabilidades se compõem.

#line()
%%% END
