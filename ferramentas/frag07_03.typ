%%% BEFORE: === 3.2. Custo de Capital Próprio (Ke)
#intuicao[
  Todo capital tem dono, e o dono poderia ter aplicado o dinheiro em outro
  lugar. O custo de capital é o #strong[custo de oportunidade] dessas fontes: a
  menor taxa que faz o credor ou o acionista aceitar financiar a empresa
  em vez de investir em alternativa de risco comparável. Por isso ele
  depende do #strong[risco do projeto], não de quem o financia: um projeto
  arriscado exige mais retorno mesmo que a empresa seja sólida.
]

#atencao[
  #strong[Consistência de moeda e inflação.] Fluxos de caixa em reais
  nominais devem ser descontados por uma taxa nominal; fluxos em termos
  reais, por uma taxa real. Misturar os dois (por exemplo, descontar fluxos
  nominais pela taxa real) infla o valor artificialmente. A mesma regra vale
  para a moeda: fluxos em dólares usam custo de capital em dólares.
]

%%% BEFORE: === 3.3. Custo de Capital de Terceiros (Kd)
#exemplo("três métodos para o Ke da mesma empresa")[
  Os dados do código acima levam a #strong[Ke (CAPM) = 17,10%] e
  #strong[Ke (Gordon) = 9,56%]. Uma diferença dessas é um #strong[alerta], não
  uma curiosidade:

  - O Ke de Gordon (9,56%) é #emph[menor que a própria Selic] (10,5%): nenhum
    acionista aceitaria risco de ações por menos que o título público. Ou o
    preço está inflado, ou o dividendo/crescimento usados (R\$ 2,50 e 4%)
    subestimam a realidade.
  - Para o CAPM e o Gordon coincidirem a $17,1%$, o crescimento implícito
    precisaria ser $g = K_e - D_1/P_0 = 17,1% - 5,56% = 11,5%$ ao ano
    para sempre --- superior ao crescimento da economia, portanto
    #strong[implausível].

  A lição: os métodos devem ser #strong[reconciliados], não escolhidos ao gosto.
  Quando divergem, investigue qual premissa está fraca (prêmio de risco,
  beta, crescimento perpétuo, preço de mercado). Um terceiro método,
  o #strong[Kd + prêmio] (por exemplo, juro da dívida da empresa mais 3 a 5 pontos
  percentuais), serve de verificação de ordem de grandeza.
]

%%% BEFORE: === 3.4. WACC --- Weighted Average Cost of Capital
#teoria("por que o custo da dívida é líquido de imposto, e quando")[
  Os juros são #strong[dedutíveis] da base do imposto de renda: pagar
  $J$ de juros reduz o imposto em $"IR" dot J$, de modo que o custo
  efetivo é $J(1 - "IR")$. Isso só vale se a empresa #strong[tem lucro
  tributável] para deduzir: uma empresa em prejuízo fiscal não obtém o
  benefício (pelo menos não imediatamente). Em termos de fluxo de caixa, o
  benefício fiscal entra como entrada de caixa adicional; no WACC, ele aparece
  uma única vez, pelo termo $(1 - "IR")$ no custo da dívida --- nunca
  também nos fluxos de caixa projetados (dupla contagem).
]

#exemplo("custo da dívida pós-fixada")[
  Uma empresa paga CDI + 2,5% a.a., com CDI a 13,25%. O custo bruto é a
  composição das duas taxas: $(1,1325)(1,025) - 1 = 16,08%$ a.a. (e não
  15,75%, a soma). Com IR de 34%, o custo líquido é
  $16,08% times 0,66 = 10,61%$. Note que o custo da dívida #emph[atual]
  (histórica) não é o relevante para decisões novas: o que importa é o
  custo de #strong[captar hoje], a taxa marginal.
]

%%% BEFORE: === 3.5. Teoria do Custo de Capital
#exemplo("WACC na mão")[
  Uma empresa tem R\$ 600 milhões de capital próprio (valor de mercado) e R\$
  400 milhões de dívida; $K_e = 16%$, $K_d = 12%$ bruto e IR de 34%.

  - Pesos: $E/V = 600/1.000 = 60%$; $D/V = 40%$.
  - $K_d$ líquido $= 12% times 0,66 = 7,92%$.
  - $"WACC" = 0,60 times 16% + 0,40 times 7,92% = 9,60% + 3,17% = $
    #strong[12,77%].

  Esse é o retorno mínimo que os #emph[novos projetos] da empresa precisam
  oferecer para não destruir valor (se tiverem o mesmo risco do negócio atual).
]

#atencao[
  #strong[Pesos a valor de mercado, não contábil.] Use o valor de mercado do
  patrimônio (preço da ação $times$ número de ações) e, quando possível, da dívida.
  O patrimônio líquido contábil costuma ser muito menor que o valor de mercado
  em empresas lucrativas, o que superestimaria o peso da dívida e
  subestimaria o WACC.
]

#teoria("o WACC não cai para sempre: a curva em U")[
  A tabela impressa acima (Ke e Kd constantes) mostra o WACC caindo sem fim
  com a dívida --- o que seria um convite ao endividamento infinito. É uma
  simplificação enganosa. Na realidade, mais dívida eleva o risco do
  acionista (o beta alavancado sobe, pela fórmula de Hamada) e o spread
  cobrado pelos credores. O modelo abaixo incorpora os dois efeitos e
  produz a clássica curva em U, com um #strong[mínimo] (a estrutura de capital
  ótima segundo o trade-off, capítulo 6).
]

```python
def wacc_realista(peso_div, beta_u=0.9, rf=0.10, premio=0.06, ir=0.34):
    """WACC com beta realavancado (Hamada) e spread de crédito crescente com a alavancagem (ilustrativo)."""
    d_e = peso_div / (1 - peso_div)
    beta_l = beta_u * (1 + (1 - ir) * d_e)
    ke_ = rf + beta_l * premio
    kd_ = rf + 0.02 + 0.10 * peso_div ** 2          # spread de 2% + componente que cresce com o endividamento
    return ke_, kd_, (1 - peso_div) * ke_ + peso_div * kd_ * (1 - ir)

print(f"{'D/V':>5} {'Ke':>7} {'Kd':>7} {'WACC':>7}")
for pd_ in np.arange(0, 0.75, 0.1):
    ke_r, kd_r, w_r = wacc_realista(pd_)
    print(f"{pd_:>5.0%} {ke_r:>7.2%} {kd_r:>7.2%} {w_r:>7.2%}")

grade = np.arange(0, 0.9, 0.01)
curva_w = [wacc_realista(x)[2] for x in grade]
otimo = grade[int(np.argmin(curva_w))]
print(f"WACC mínimo: {min(curva_w):.2%} com D/V = {otimo:.0%}")

plt.figure(figsize=(8.5, 4.2))
plt.plot(grade * 100, curva_w, color="#1d4f91", linewidth=2, label="WACC")
plt.plot(grade * 100, [wacc_realista(x)[0] for x in grade], color="#a33a1c", linestyle="--", label="Ke")
plt.plot(grade * 100, [wacc_realista(x)[1] * (1 - 0.34) for x in grade], color="#1f6f4a", linestyle="--", label="Kd líquido")
plt.axvline(otimo * 100, color="gray", linestyle=":")
plt.xlabel("Dívida / valor da empresa (%)"); plt.ylabel("% a.a.")
plt.title("WACC em função da estrutura de capital: a curva em U")
plt.legend(); plt.grid(alpha=0.3)
plt.savefig("figuras07/wacc_u.png", dpi=170, bbox_inches="tight")
```

#figure(
  image("figuras07/wacc_u.png", width: 85%),
  caption: [Com beta realavancado e spread crescente, o WACC cai no início (benefício fiscal e dívida barata) e depois sobe (risco de insolvência).],
)

%%% BEFORE_CHAPTER_END: == Capítulo 4 --- Valuation (Avaliação de Empresas)
#teoria("projetos do mesmo setor, mas risco diferente: use o custo de capital do projeto")[
  O WACC da empresa só é a taxa de desconto correta para projetos com o
  mesmo risco do negócio atual. Um projeto de risco maior (nova linha de
  negócio, mercado externo) deve usar um custo de capital #strong[próprio do
  projeto]: estima-se o beta de empresas "puras" do setor-alvo (comparáveis),
  desalavanca-se, realavanca-se pela estrutura-alvo e recalcula-se o WACC.
  Usar o WACC médio da empresa para todos os projetos leva a #strong[aceitar projetos
  de alto risco que destroem valor] e #strong[rejeitar projetos seguros que
  criariam valor].
]

#resumo[
  - Custo de capital = custo de oportunidade; depende do #strong[risco do projeto].
  - $K_e$ pelo CAPM (ou Gordon, ou $K_d$ + prêmio): os métodos devem ser reconciliados.
  - $K_d$ líquido $= K_d (1 - "IR")$, e só se há lucro tributável a deduzir.
  - $"WACC" = (E/V) K_e + (D/V) K_d (1 - "IR")$ com pesos a #strong[valor de mercado]; a curva
    real tem forma de U.
]

%%% BEFORE: === 4.3. Valuation por Múltiplos
#intuicao[
  O valuation por FCD responde "quanto vale esta empresa se as previsões
  se realizarem?". Por isso, #strong[todo valuation é uma história
  traduzida em números]: crescimento, margens, necessidade de investimento e
  risco. O resultado é tão bom quanto as premissas --- e a parte mais
  sensível, o #strong[valor terminal], costuma responder por 60% a 80% do valor
  total (no exemplo, 72% do EV).
]

#teoria("do lucro ao fluxo de caixa livre (FCFF)")[
  O fluxo de caixa que se desconta pelo WACC é o #strong[fluxo de caixa livre
  da firma] (FCFF): o caixa gerado pelas operações, após impostos e investimentos,
  #emph[disponível para credores e acionistas]:

  $ "FCFF" = "EBIT" (1 - "IR") + "Depreciação" - "CapEx" - Delta "NCG" $

  O primeiro termo é o #strong[NOPAT]. Soma-se a depreciação por ser despesa
  sem saída de caixa; subtraem-se os investimentos em ativo fixo (CapEx) e
  em capital de giro ($Delta "NCG"$). Os #strong[juros ficam de fora]: pertencem
  aos credores e já estão no WACC. Exemplo: EBIT 200, IR 34%, depreciação 80,
  CapEx 120, $Delta "NCG"$ 30: $"FCFF" = 200 times 0,66 + 80 - 120 - 30 = 62$.

  Para avaliar #emph[apenas o acionista] (FCFE) subtrai-se também o serviço da
  dívida e soma-se a nova captação, e desconta-se pelo $K_e$.
]

#atencao[
  #strong[Quatro erros clássicos no FCD.] (1) Usar $g >= "WACC"$ no valor
  terminal (o valor "explode"). (2) $g$ perpétuo acima do crescimento da
  economia (um negócio não cresce acima do PIB para sempre). (3) Esquecer de
  que o valor terminal tem de assumir #strong[reinvestimento] compatível com o
  crescimento: crescer exige investir. (4) Subtrair a dívida #emph[bruta] e
  somar o caixa sem checar se o caixa é "livre" ou é caixa operacional necessário.
]

```python
def fcd_simples(fcfs_x, wacc_x, g_x, divida_x, caixa_x):
    vp_f = sum(f / (1 + wacc_x) ** (t + 1) for t, f in enumerate(fcfs_x))
    vt_x = fcfs_x[-1] * (1 + g_x) / (wacc_x - g_x)
    vp_vt_x = vt_x / (1 + wacc_x) ** len(fcfs_x)
    ev_x = vp_f + vp_vt_x
    return ev_x, ev_x - divida_x + caixa_x, vp_vt_x / ev_x, vt_x / fcfs_x[-1]

fcfs_ex = [100, 115, 132, 152, 175]
ev_b, eq_b, share_vt, mult_vt = fcd_simples(fcfs_ex, 0.12, 0.035, 300, 80)
print(f"EV = R${ev_b:,.2f} | Equity = R${eq_b:,.2f} | valor terminal = {share_vt:.1%} do EV | VT = {mult_vt:.1f}x o FCF do ano 5")

print("\nEquity Value (R$ milhões) em função do WACC (linhas) e de g (colunas):")
gs = [0.02, 0.03, 0.035, 0.04, 0.05]
print(f"{'WACC':>6} " + " ".join(f"{g_*100:>8.1f}%" for g_ in gs))
for w_ in (0.10, 0.11, 0.12, 0.13, 0.14):
    print(f"{w_:>6.0%} " + " ".join(f"{fcd_simples(fcfs_ex, w_, g_, 300, 80)[1]:>9,.0f}" for g_ in gs))
```

#intuicao[
  A tabela de sensibilidade mostra por que valuations divergem tanto entre
  analistas: variar o WACC em 1 ponto e o crescimento em 0,5 ponto muda o
  valor em dezenas de porcento. Uma boa prática é #strong[sempre apresentar
  o valor como uma faixa], nunca como um número único.
]

#exemplo("de equity value a preço por ação")[
  Com o equity value de R\$ 1.459,94 milhões (EV de R\$ 1.679,94 milhões,
  menos dívida de R\$ 300 milhões, mais caixa de R\$ 80 milhões) e 200 milhões
  de ações: preço justo $= 1.459,94/200 = $ R\$ 7,30 por ação. Compara-se com
  o preço de mercado: se a ação negocia a R\$ 5,50, há margem de segurança
  de 25% (preço de mercado 25% abaixo do valor intrínseco); a R\$ 9,00, o
  mercado estaria precificando premissas mais otimistas que as suas.
]

%%% BEFORE: === 4.4. Múltiplos Comuns
#teoria("de onde vêm os múltiplos: P/L implícito no modelo de Gordon")[
  Os múltiplos não são "regras de bolso": decorrem do valor intrínseco. Partindo
  de $P_0 = D_1/(K_e - g)$ e de $D_1 = "LPA"_1 times "payout"$:

  $ P_0/"LPA"_1 = "payout"/(K_e - g) $

  O P/L #strong[prospectivo] aumenta com o pay-out e com o crescimento $g$, e
  diminui com o risco ($K_e$). Duas empresas só são comparáveis por P/L se tiverem
  perspectivas de crescimento e risco parecidos --- o que explica por que
  empresas de tecnologia negociam a múltiplos muito maiores que as de
  utilidade pública. O mesmo raciocínio vale para o #strong[EV/EBITDA]: ele sobe com
  o crescimento e com a conversão de EBITDA em caixa, e cai com o risco.
]

#exemplo("do EV/EBITDA ao preço por ação")[
  Retomando a empresa do exemplo (EBITDA R\$ 600 milhões, 100 milhões de
  ações): a um EV/EBITDA de 7x do setor, o #strong[EV] é R\$ 4.200 milhões.
  Para chegar ao preço por ação é preciso subtrair a #strong[dívida líquida]:
  com R\$ 500 milhões de dívida líquida, o equity vale R\$ 3.700 milhões e o
  preço justo é R\$ 37,00 por ação. O EV/EBITDA é neutro em relação à estrutura
  de capital (compara o negócio, antes de quem o financia), o P/L não.
]

#atencao[
  #strong[Armadilhas dos múltiplos.] (1) P/L de empresa com lucro negativo
  não faz sentido (use EV/Receita ou EV/EBITDA). (2) Lucros #emph[cíclicos] no
  pico de ciclo geram P/L baixo "enganoso": a empresa parece barata justo
  quando está mais cara (normalize o lucro). (3) Itens extraordinários e
  contabilidade distorcem o lucro. (4) O #strong[PEG] ($"P/L"$ dividido pelo
  crescimento do lucro em %) ajuda a comparar empresas com crescimentos
  diferentes, mas é só uma aproximação.
]

%%% BEFORE_CHAPTER_END: == Capítulo 5 --- Análise de Demonstrações Financeiras
#resumo[
  - #strong[FCFF] $= "EBIT"(1 - "IR") + "Dep" - "CapEx" - Delta "NCG"$; desconta-se
    pelo WACC e soma-se o valor terminal $"FCF"_n (1 + g)/("WACC" - g)$.
  - $"Equity" = "EV" - "Dívida líquida"$. O valor terminal costuma pesar 60% a 80%.
  - O valor depende de premissas: apresente #strong[faixas] e sensibilidade, não um único número.
  - Múltiplos derivam do valor intrínseco (P/L $= "payout"/(K_e - g)$) e só comparam
    empresas de risco e crescimento semelhantes.
]
%%% END
