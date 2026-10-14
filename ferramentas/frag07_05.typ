%%% BEFORE: === 6.2. Modigliani-Miller (1958) --- Sem Impostos
#intuicao[
  Pense numa pizza. O tamanho da pizza (o valor da empresa) é determinado pelo
  que ela #emph[produz] --- seus fluxos de caixa operacionais ---, e não pela forma como
  é fatiada entre credores e acionistas. Trocar fatias de dívida por fatias de ações
  não faz a pizza crescer. Esse é o coração da irrelevância de M&M: sem
  atritos (impostos, falências, assimetria de informação), #strong[financiamento
  não cria valor]. É um resultado de referência: os desvios da realidade (impostos,
  custos de falência) é que explicam a estrutura de capital que vemos.
]

%%% BEFORE: === 6.3. Modigliani-Miller (1963) --- Com Impostos
#exemplo("a arbitragem de M&M com números")[
  Duas empresas idênticas (mesmo lucro operacional perpétuo, EBIT de R\$ 150
  milhões, sem impostos), com custo de capital do ativo $K_u = 15%$. A empresa
  desalavancada U vale $150/0,15 = 1.000$ milhões. A empresa L deve R\$ 400 milhões
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

%%% BEFORE: === 6.4. Trade-off Theory
#teoria("dedução do benefício fiscal e das fórmulas com impostos")[
  Com dívida perpétua $D$ a custo $K_d$, os juros anuais são $K_d D$ e a economia
  fiscal anual é $"IR" dot K_d D$. Descontada à taxa $K_d$ (o risco do
  benefício é o da dívida), o #strong[valor presente do escudo fiscal] é

  $ "VP"("escudo") = ("IR" dot K_d dot D)/K_d = "IR" dot D $

  Daí $V_L = V_U + "IR" dot D$. Com impostos, a Proposição II e o WACC passam a ser

  $ K_e = K_u + (K_u - K_d)(1 - "IR") D/E quad "e" quad "WACC" = K_u (1 - "IR" dot D/V) $

  O WACC #strong[cai] com a dívida (cada real de dívida corta o custo de capital por
  causa do escudo). Exemplo: $V_U = 2.000$, $D = 600$, $K_u = 14%$, $K_d = 9%$ e IR de 34%:
  $V_L = 2.000 + 0,34 times 600 = 2.204$; $E = 1.604$; $K_e = 14% + 5% times 0,66
  times 600/1.604 = 15,23%$; e o WACC $= 14% times (1 - 0,34 times 600/2.204) = 12,70%$.
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

#atencao[
  O exemplo resolvido E6 do capítulo 13 usa a Proposição II #strong[sem
  impostos] para o novo $K_e$, "para efeito didático". A fórmula coerente com a
  versão com impostos de M&M é a acima, com o termo $(1 - "IR")$.
]

%%% BEFORE: === 6.5. Pecking Order Theory (Myers & Majluf, 1984)
#teoria("o ponto ótimo do trade-off, com números")[
  Some ao valor de M&M com impostos um #strong[custo esperado de falência] que
  cresce mais que proporcionalmente com a dívida. Em um modelo simples,
  $V_L = V_U + "IR" dot D - k D^2$. Igualando a derivada a zero,
  $"IR" - 2 k D = 0$, o nível ótimo de dívida é

  $ D^* = "IR"/(2 k) $

  O benefício marginal (IR, constante) iguala o custo marginal de
  falência (crescente). Com $V_U = 1.500$, IR de 34% e $k = 0,0012$,
  $D^* = 0,34/0,0024 = 141,7$ e o valor máximo é R\$ 1.524,08 --- apenas 1,6%
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

%%% BEFORE_CHAPTER_END: == Capítulo 7 --- Política de Dividendos
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

%%% BEFORE: === 7.3. Teoria da Irrelevância (M&M, 1961)
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

%%% BEFORE: === 7.4. Teoria do Pássaro na Mão (Gordon, 1963)
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

  A riqueza é a mesma, mas o #strong[LPA] sobe de $200/100 = 2,00$ para
  $200/95 = 2,11$ (+5,3%) na recompra --- uma "melhora" meramente
  aritmética, que não cria valor. A escolha entre as duas depende de
  tributação, flexibilidade (dividendos criam expectativa de continuidade;
  recompras são pontuais) e sinalização (uma recompra pode indicar que
  a diretoria considera a ação barata).
]

%%% BEFORE: === 7.5. Efeito Clientela
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

%%% BEFORE_CHAPTER_END: == Capítulo 8 --- Capital de Giro
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
%%% END
