%%% BEFORE_CHAPTER_END: == Capítulo 14 --- Tabela Resumo de Fórmulas
#line()

#strong[E9.] O ativo A tem retorno esperado de 14% e desvio de 25%; o ativo B, 9% e
12%; a correlação é 0,30. (a) Qual o retorno e o risco de uma carteira 60% A / 40% B?
(b) Qual a carteira de mínima variância?

#strong[Solução.] (a) $E(R_p) = 0,6 times 14% + 0,4 times 9% = 12,0%$. A variância é
$0,6^2 times 0,25^2 + 0,4^2 times 0,12^2 + 2 times 0,6 times 0,4 times 0,30 times 0,25 times 0,12 = 0,02912$,
portanto $sigma_p = 17,07%$ --- menor que a média ponderada dos desvios
($0,6 times 25% + 0,4 times 12% = 19,8%$), efeito da correlação menor que 1.
(b) Pesos de mínima variância: $w_A^* = (sigma_B^2 - rho sigma_A sigma_B)/(sigma_A^2 + sigma_B^2 - 2 rho sigma_A sigma_B) = 9,17%$ em A e 90,83% em B,
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

#line()

#strong[E10.] Uma empresa comparável tem beta de 1,25, com D/E de 0,9 e IR de 34%.
Estime o beta desalavancado e o beta de uma empresa do mesmo setor que pretende operar
com D/E de 0,4. Calcule o Ke com Selic de 10,5% e prêmio de mercado de 5,5%.

#strong[Solução.] Desalavancar (Hamada): $beta_U = 1,25/(1 + 0,66 times 0,9) = 0,784$.
Realavancar: $beta_L = 0,784 times (1 + 0,66 times 0,4) = 0,991$. O Ke é
$10,5% + 0,991 times 5,5% = 15,95%$. Menos dívida, menos risco do acionista:
o beta cai de 1,25 para 0,99.

```python
beta_comp, de_comp, ir_h, de_alvo = 1.25, 0.9, 0.34, 0.4
beta_u_h = beta_comp / (1 + (1 - ir_h) * de_comp)
beta_alvo = beta_u_h * (1 + (1 - ir_h) * de_alvo)
print(f"Beta desalavancado: {beta_u_h:.3f} | beta realavancado (D/E {de_alvo}): {beta_alvo:.3f} | Ke: {0.105 + beta_alvo * 0.055:.2%}")
```

#line()

#strong[E11.] Uma empresa tem NOPAT de R\$ 340 milhões e capital investido de R\$ 2.500
milhões; o WACC é 11,5%. Calcule ROIC, spread e EVA, e diga quanto o NOPAT
precisaria ser para o EVA ser zero.

#strong[Solução.] ROIC $= 340/2.500 = 13,6%$; spread $= 13,6% - 11,5% = 2,1$ p.p.;
EVA $= 2.500 times 2,1% = $ R\$ 52,5 milhões. O EVA zera quando o NOPAT iguala o
custo do capital: $2.500 times 11,5% = $ R\$ 287,5 milhões --- uma margem de
segurança de $(340 - 287,5)/340 = 15,4%$.

```python
nopat_e, capital_e, wacc_e = 340, 2500, 0.115
roic_e = nopat_e / capital_e
print(f"ROIC {roic_e:.2%} | spread {(roic_e - wacc_e)*100:.2f} p.p. | EVA R${nopat_e - capital_e * wacc_e:.1f} milhões")
print(f"NOPAT de equilíbrio (EVA = 0): R${capital_e * wacc_e:.1f} milhões (folga de {1 - capital_e * wacc_e / nopat_e:.1%})")
```

#line()

#strong[E12.] Uma empresa tem EBIT de R\$ 300 milhões, IR de 34%, depreciação de R\$ 100
milhões, CapEx de R\$ 140 milhões e aumento de capital de giro de R\$ 30 milhões, todos
no ano 0. Esses valores crescem 5% ao ano nos próximos 4 anos; depois, o FCFF
cresce 3% para sempre. WACC de 11%; dívida líquida de R\$ 400 milhões. Calcule o EV e o
equity value.

#strong[Solução.] Para cada ano $t$, o FCFF é $(300 times 0,66 + 100 - 140 - 30) times 1,05^t$
$= 128 times 1,05^t$: de R\$ 134,4 milhões (ano 1) a R\$ 155,6 milhões (ano 4). O valor terminal
no ano 4 é $155,6 times 1,03/(0,11 - 0,03) = 2.003,2$; descontado, vale 1.319,5. A soma
dos FCFF descontados é R\$ 446,5. #strong[EV $=$ R\$ 1.766,0 milhões]; equity $= 1.766,0 - 400 = $
R\$ 1.366,0 milhões. O valor terminal responde por 75% do EV.

```python
fcff_0 = 300 * (1 - 0.34) + 100 - 140 - 30
fcffs_e12 = [fcff_0 * 1.05 ** t for t in range(1, 5)]
ev_e12, eq_e12, share_e12, _ = fcd_simples(fcffs_e12, 0.11, 0.03, 400, 0)
print("FCFF projetados:", [f"{f:.1f}" for f in fcffs_e12])
print(f"EV = R${ev_e12:,.1f} | equity = R${eq_e12:,.1f} | valor terminal = {share_e12:.1%} do EV")
```

#line()

#strong[E13.] Uma empresa tem ROIC de 14%, custo da dívida de 11% (IR de 34%) e D/E de 1,2.
Qual o ROE? E se o ROIC cair para 6%?

#strong[Solução.] $"ROE" = "ROIC" + ("ROIC" - K_d(1 - "IR")) D/E$. Com $K_d$ líquido
$= 11% times 0,66 = 7,26%$: ROE $= 14% + (14% - 7,26%) times 1,2 = 22,09%$. Com ROIC de 6%:
$6% + (6% - 7,26%) times 1,2 = 4,49%$ --- #strong[abaixo do próprio ROIC]. A alavancagem amplifica
nos dois sentidos: acima do custo líquido da dívida, ajuda; abaixo, machuca.

```python
def roe_alavancado(roic_a, kd_a, ir_a, de_a):
    return roic_a + (roic_a - kd_a * (1 - ir_a)) * de_a

for roic_v in (0.14, 0.06):
    print(f"ROIC {roic_v:.0%} -> ROE {roe_alavancado(roic_v, 0.11, 0.34, 1.2):.2%}")
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

#line()

#strong[E15.] Um título de R\$ 1.000, cupom de 8% a.a., 4 anos, é negociado a um rendimento de 10%.
Calcule o preço, a duration modificada e a variação de preço se o rendimento subir para 10,5%.

#strong[Solução.] O preço é R\$ 936,60 (desconto, pois o cupom é menor que o rendimento). A duration
de Macaulay é 3,56 anos e a modificada 3,24. Para $Delta y = +0,5%$, a variação aproximada
é $-3,24 times 0,5% = -1,62%$; a variação exata é $-1,60%$.

```python
p_e15, mac_e15, mod_e15, _ = preco_duration(1000, 0.08, 0.10, 4)
p_novo = preco_duration(1000, 0.08, 0.105, 4)[0]
print(f"Preço R${p_e15:.2f} | duration {mac_e15:.2f} (modificada {mod_e15:.2f})")
print(f"Rendimento 10,5%: preço R${p_novo:.2f} ({p_novo / p_e15 - 1:+.2%}) | previsto pela duration {-mod_e15 * 0.005:+.2%}")
```

#line()

#strong[E16.] Câmbio spot de R\$ 5,00/US\$; juros de 12% a.a. no Brasil e 4% a.a. nos EUA; prazo de 6
meses. O mercado cota o câmbio a termo em R\$ 5,30. Há arbitragem?

#strong[Solução.] Pela paridade coberta, o termo justo é $5,00 times (1,12/1,04)^(0,5) = 5,19$.
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

%%% BEFORE_CHAPTER_END: == Capítulo 15 --- Glossário
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

%%% APPEND: fim
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
  #strong[Verdadeiro.] $E(R) = R_f + 1,5 (R_m - R_f) > R_m$ se o prêmio de mercado for positivo.
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
%%% END
