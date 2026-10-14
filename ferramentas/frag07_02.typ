%%% BEFORE: === 1.2. As Três Decisões Fundamentais
#intuicao[
  Finanças difere da #strong[contabilidade] em dois pontos essenciais. A
  contabilidade registra o #emph[passado] pelo regime de competência; finanças
  olha para o #emph[futuro] e trabalha com #strong[fluxos de caixa], #strong[risco] e
  #strong[valor do dinheiro no tempo]. E difere da #strong[economia] no foco:
  a economia estuda como a sociedade aloca recursos escassos; finanças
  estuda como #emph[um agente específico] (empresa, investidor) toma decisões
  de investimento e financiamento sob incerteza.
]

%%% BEFORE: === 1.3. Objetivo da Empresa
#exemplo("as três decisões no balanço patrimonial")[
  As três decisões fundamentais correspondem a três pontos do balanço:

  #figure(
    align(center)[#table(
      columns: (24%, 38%, 38%),
      align: (left, left, left),
      table.header([Decisão], [Onde aparece], [Ferramenta principal],),
      [Investimento], [Lado do #strong[ativo]: o que a empresa possui], [VPL, TIR, EVA],
      [Financiamento], [Lado do #strong[passivo e PL]: como foi pago], [WACC, estrutura de capital],
      [Dividendos], [#strong[Lucros acumulados]: o que foi retido ou distribuído], [Pay-out, recompras],
    )]
    , kind: table
    )

  As três se influenciam: um projeto bom (investimento) pode exigir mais
  caixa do que a empresa tem (financiamento), o que pode levar a reter lucros
  (dividendos). Por isso o gestor financeiro as trata em conjunto.
]

%%% BEFORE: === 1.4. Gestão Baseada em Valor (VBM)
#teoria("o conflito de agência")[
  Em empresas de capital aberto, #strong[proprietários] (acionistas) e
  #strong[gestores] são pessoas diferentes. O gestor pode ter objetivos
  próprios --- crescer a empresa além do ótimo (por prestígio), proteger o
  emprego, evitar riscos que os acionistas, diversificados, aceitariam. Jensen
  e Meckling (1976) chamaram isso de #strong[problema de agência] e os custos
  de mitigá-lo (monitoramento, remuneração atrelada ao valor, conselho
  independente) de #strong[custos de agência].

  Maximizar a riqueza do acionista é o objetivo "consensual" por três
  razões práticas: ele é mensurável (preço da ação), considera risco e
  tempo, e o acionista é o #emph[residual claimant] --- só recebe depois que
  funcionários, fornecedores e credores foram pagos, de modo que, se a
  empresa gera valor para o residual, gerou valor para todos. Perspectivas
  mais amplas (#emph[stakeholders]) argumentam que a empresa deve considerar
  também empregados, clientes e sociedade; na prática, muitas dessas
  preocupações aumentam o valor de longo prazo, e as duas visões convergem
  mais do que parecem.
]

#exemplo("lucro positivo, valor destruído")[
  Dois projetos geram o mesmo lucro operacional após impostos (NOPAT) de
  R\$ 100 milhões por ano, mas o projeto A exige R\$ 500 milhões de capital
  e o projeto B, R\$ 1.000 milhões. O custo de capital (WACC) é 12%.

  - #strong[Projeto A:] retorno sobre o capital = $100/500 = 20%$; o custo
    do capital é $12% times 500 = 60$; #strong[lucro econômico] (EVA)
    $= 100 - 60 = +40$ milhões por ano.
  - #strong[Projeto B:] retorno = $100/1.000 = 10%$; custo do capital
    $= 12% times 1.000 = 120$; EVA $= 100 - 120 = -20$ milhões por ano.

  Os dois "dão lucro", mas só o A cria valor. O B consome capital que
  renderia 12% em outra aplicação e devolve só 10%. A contabilidade tradicional
  não desconta o #emph[custo do capital próprio], por isso enxerga lucro
  onde há destruição de valor.
]

%%% BEFORE_CHAPTER_END: == Capítulo 2 --- Risco e Retorno
#teoria("EVA como spread vezes capital")[
  Reescreva o EVA usando o ROIC $= "NOPAT"/K$ (com $K$ o capital investido):

  $ "EVA" = "NOPAT" - K dot "WACC" = K dot ("ROIC" - "WACC") $

  O EVA é o #strong[spread] (ROIC − WACC) multiplicado pelo #strong[capital]
  empregado: criar valor exige (1) ter spread positivo e (2) ter capital
  para aplicar à taxa superior. Crescer com ROIC < WACC #emph[destrói] valor,
  porque cada real adicional de capital vale menos do que custa. Já o MVA
  (valor de mercado menos capital investido) é, em teoria, o valor presente
  de todos os EVAs futuros esperados: o mercado "paga" hoje pela expectativa
  de spreads positivos duradouros.
]

#exemplo("lendo os números do exemplo do capítulo")[
  Com NOPAT = 500, capital = 4.000 e WACC = 12%: ROIC $= 500/4.000 = 12,5%$,
  spread de $+0,5$ p.p. e EVA $= 4.000 times 0,005 = $ R\$ 20 milhões. O MVA
  é 6.500 − 4.000 = R\$ 2.500 milhões: o mercado espera que a empresa
  continue criando valor por muitos anos (um EVA de R\$ 20 milhões por ano,
  como perpetuidade a 12%, valeria só R\$ 167 milhões --- o mercado está
  precificando #emph[crescimento] do EVA ou spreads maiores no futuro).
  O ROE (11,67%) usa outra base (lucro líquido sobre patrimônio líquido) e
  não é diretamente comparável ao ROIC; a seção 5.5 mostra a relação entre
  os dois por meio da alavancagem.
]

```python
def eva_por_spread(nopat, capital, wacc):
    roic = nopat / capital
    return roic, roic - wacc, capital * (roic - wacc)

for projeto_v, nopat_v, cap_v in (("A", 100, 500), ("B", 100, 1000)):
    roic_v, spread_v, eva_v = eva_por_spread(nopat_v, cap_v, 0.12)
    print(f"Projeto {projeto_v}: ROIC {roic_v:.1%} | spread {spread_v:+.1%} | EVA R${eva_v:+.1f} milhões/ano")
```

#resumo[
  - Finanças decide sob #strong[incerteza] e usa #strong[fluxos de caixa], não lucro contábil.
  - Três decisões: investimento (ativo), financiamento (passivo e PL), dividendos (lucros).
  - Objetivo: maximizar o valor para o acionista; o EVA $= K("ROIC" - "WACC")$
    mostra se o crescimento cria ou destrói valor.
]

%%% BEFORE: === 2.2. Retorno Esperado
#exemplo("retorno total, logarítmico e médias")[
  Uma ação comprada a R\$ 20 vale R\$ 22 um ano depois e pagou R\$ 1
  de dividendos. O retorno total é
  $R = (22 - 20 + 1)/20 = 15%$ (10% de ganho de capital mais 5% de dividend
  yield). O retorno #strong[logarítmico] (contínuo) do ganho de capital é
  $ln(22/20) = 9,53%$; ele é aditivo no tempo (a soma dos retornos
  logarítmicos diários é o retorno logarítmico do período), enquanto os
  retornos simples são #strong[multiplicativos].

  #strong[Média aritmética × geométrica.] Retornos anuais de +10%, −5%, +20% e
  −15%: a média aritmética é 2,5% a.a., mas o capital cresce
  $1,10 times 0,95 times 1,20 times 0,85 = 1,0659$ em 4 anos, ou
  $1,0659^(1\/4) - 1 = 1,61%$ a.a. (média #strong[geométrica]). A geométrica
  sempre é menor ou igual à aritmética e é a que mede o crescimento real do
  patrimônio. O exemplo extremo: uma perda de 50% exige um ganho de 100%
  para recuperar o capital --- retornos negativos "pesam" mais.
]

#teoria("por que a volatilidade é multiplicada por raiz de 252")[
  Se os retornos diários são independentes e têm variância $sigma_d^2$, a
  variância se #strong[soma] ao longo de $T$ dias: $sigma_T^2 = T sigma_d^2$, e o
  desvio padrão cresce com a #strong[raiz] do tempo: $sigma_T = sigma_d sqrt(T)$.
  Com 252 pregões por ano, $sigma_("anual") = sigma_d sqrt(252)$. A hipótese de
  independência é uma aproximação (os retornos reais têm autocorrelação de
  volatilidade e "caudas gordas"), mas é a convenção universal.
]

#atencao[
  O bloco acima baixa dados da internet com a biblioteca `yfinance`: ele
  #strong[só funciona com o pacote instalado e conexão ativa], e seus números
  mudam conforme a data de execução. Por isso, os exemplos seguintes usam
  #strong[dados simulados com semente fixa] --- reproduzíveis por qualquer
  leitor.
]

```python
rng_ex = np.random.default_rng(42)
# 4 anos de pregões simulados: retorno diário ~ t de Student (caudas gordas), média 0,05%, vol ~1,8%
ret_sim = 0.0005 + 0.018 * rng_ex.standard_t(df=5, size=1008) / np.sqrt(5 / 3)

print(f"Retorno médio diário : {ret_sim.mean()*100:.4f}%")
print(f"Volatilidade diária  : {ret_sim.std(ddof=1)*100:.4f}%")
print(f"Volatilidade anual   : {ret_sim.std(ddof=1) * np.sqrt(252) * 100:.2f}%")
print(f"Assimetria / curtose : {stats.skew(ret_sim):.3f} / {stats.kurtosis(ret_sim):.3f} (normal = 0 / 0)")
print(f"VaR 95% histórico    : {np.quantile(ret_sim, 0.05)*100:.2f}% | paramétrico: {(ret_sim.mean() - 1.645*ret_sim.std(ddof=1))*100:.2f}%")
print(f"VaR 99% histórico    : {np.quantile(ret_sim, 0.01)*100:.2f}% | paramétrico: {(ret_sim.mean() - 2.326*ret_sim.std(ddof=1))*100:.2f}%")
```

#intuicao[
  O #strong[VaR] (Value at Risk) responde: "com 95% de confiança, qual é a
  #emph[maior perda] em um dia?" Um VaR 95% de −2,9% significa que, em 5% dos
  dias, a perda é #emph[pior] que 2,9% --- ele não diz o quanto pior. Com
  caudas gordas (curtose alta), o VaR paramétrico (que supõe normalidade)
  #strong[subestima] as perdas extremas, o que a comparação histórico ×
  paramétrico no código ilustra.
]

%%% BEFORE: === 2.3. Risco de uma Carteira (Portfólio)
#exemplo("retorno esperado e risco por cenários, passo a passo")[
  Para os cenários do código acima (boom, expansão, normal, recessão,
  crise): o #strong[retorno esperado] é a média ponderada pelas
  probabilidades:

  $ E(R) = 0,15 dot 35% + 0,30 dot 18% + 0,30 dot 8% + 0,15 dot (-5%) + 0,10 dot (-20%) = 10,30% $

  A #strong[variância] pondera os desvios quadráticos
  $p_i (R_i - E(R))^2$:

  #figure(
    align(center)[#table(
      columns: (22%, 12%, 12%, 26%, 28%),
      align: (left, right, right, right, right),
      table.header([Cenário], [$p_i$], [$R_i$], [$R_i - E(R)$], [$p_i (R_i - E(R))^2$],),
      [Boom], [0,15], [35%], [+24,70%], [0,00915],
      [Expansão], [0,30], [18%], [+7,70%], [0,00178],
      [Normal], [0,30], [8%], [−2,30%], [0,00016],
      [Recessão], [0,15], [−5%], [−15,30%], [0,00351],
      [Crise], [0,10], [−20%], [−30,30%], [0,00918],
      [], [], [], [#strong[Variância]], [#strong[0,02378]],
    )]
    , kind: table
    )

  Logo $sigma = sqrt(0,02378) = 15,42%$. Dois indicadores derivados:
  o #strong[coeficiente de variação] $sigma/E(R) = 1,50$ (risco por unidade de
  retorno) e o #strong[Índice de Sharpe] $(E(R) - R_f)/sigma$, que desconta a taxa
  livre de risco. Com $R_f = 10,5%$, o Sharpe é −0,01: a ação rende menos que a
  Selic --- não compensa o risco.
]

#atencao[
  O "retorno/risco" impresso no código ($E(R)/sigma$) #strong[não é o Sharpe]:
  ele ignora o ativo livre de risco. Um ativo de risco que rende menos que a
  renda fixa tem Sharpe negativo, por mais que $E(R)/sigma$ seja positivo.
]

#teoria("aversão a risco, utilidade e equivalente certo")[
  Por que variância é a medida de risco? Para um investidor com utilidade
  média-variância, $U = E(R) - (A/2) sigma^2$, onde $A > 0$ é o coeficiente de
  #strong[aversão a risco]. O #strong[equivalente certo] é o retorno sem risco que
  deixaria o investidor indiferente: igual a $U$. Para $A = 4$, o ativo dos
  cenários tem $U = 10,30% - 2 times 2,378% = 5,54%$: um investidor tão
  avesso a risco preferiria um título que paga 5,54% garantidos a essa ação.
  Quanto maior $A$, maior a exigência de prêmio por unidade de variância.
]

%%% BEFORE: === 2.4. CAPM --- Capital Asset Pricing Model
#teoria("dedução do risco de uma carteira e do limite da diversificação")[
  Para dois ativos com pesos $w_1$ e $w_2 = 1 - w_1$,

  $ sigma_p^2 = w_1^2 sigma_1^2 + w_2^2 sigma_2^2 + 2 w_1 w_2 rho sigma_1 sigma_2 $

  O terceiro termo é a #strong[covariância]. Como $-1 <= rho <= 1$, o risco da
  carteira vai de $|w_1 sigma_1 - w_2 sigma_2|$ (correlação perfeitamente negativa) até
  $w_1 sigma_1 + w_2 sigma_2$ (perfeitamente positiva): #strong[só no segundo caso o risco
  é a média ponderada dos riscos individuais]. Para $N$ ativos de mesmo
  peso $1/N$, desvio $sigma$ e correlação média $rho$:

  $ sigma_p^2 = sigma^2/N + (1 - 1/N) rho sigma^2 $

  Quando $N$ cresce, o primeiro termo (risco #emph[específico], ou diversificável)
  tende a zero e sobra $rho sigma^2$ (o risco #emph[sistemático] ou de mercado):
  $sigma_p -> sigma sqrt(rho)$. Com $sigma = 40%$ e $rho = 0,15$, o piso é
  $40% times sqrt(0,15) = 15,5%$ --- por mais ativos que se compre, nunca se
  chega abaixo disso.
]

#exemplo("o efeito da correlação")[
  Dois ativos, $sigma_1 = 20%$ e $sigma_2 = 30%$, carteira 50/50:

  #table(
    columns: (24%, 24%, 52%),
    align: (center, right, left),
    table.header([Correlação $rho$], [Risco da carteira], [Comentário],),
    [+1,0], [25,00%], [Média ponderada dos riscos: sem ganho de diversificação],
    [+0,5], [21,79%], [],
    [0,0], [18,03%], [Menor que ambos os pesos médios],
    [−0,5], [13,23%], [],
    [−1,0], [5,00%], [Hedge quase perfeito (e zero com pesos 60/40)],
  )

  #v(0.3em)
  Com $rho = 0$, os pesos de #strong[mínima variância] são
  $w_1^* = sigma_2^2/(sigma_1^2 + sigma_2^2) = 69,2%$, e o risco mínimo é 16,64% ---
  #emph[menor] que o do ativo menos arriscado (20%). Esse é o "almoço
  grátis" da diversificação: reduzir risco sem sacrificar proporcionalmente
  o retorno.
]

```python
def risco_n_ativos(sigma, rho, n):
    """Risco de uma carteira igualmente ponderada com N ativos de correlação média rho."""
    return np.sqrt(sigma ** 2 / n + (1 - 1 / n) * rho * sigma ** 2)

ns = [1, 2, 5, 10, 20, 50, 100, 1000]
riscos_n = [risco_n_ativos(0.40, 0.15, n) for n in ns]
for n_, r_ in zip(ns, riscos_n):
    print(f"N = {n_:4d} ativos -> risco da carteira: {r_*100:.2f}%")
print(f"Piso (risco sistemático): {0.40 * np.sqrt(0.15) * 100:.2f}%")

plt.figure(figsize=(8.5, 4.2))
ns_curva = np.arange(1, 101)
plt.plot(ns_curva, [risco_n_ativos(0.40, 0.15, n) * 100 for n in ns_curva], color="#1d4f91", linewidth=2)
plt.axhline(0.40 * np.sqrt(0.15) * 100, color="#a33a1c", linestyle="--", label="Risco sistemático (piso)")
plt.fill_between(ns_curva, 0.40 * np.sqrt(0.15) * 100, [risco_n_ativos(0.40, 0.15, n) * 100 for n in ns_curva],
                 color="#1d4f91", alpha=0.12, label="Risco específico (diversificável)")
plt.xlabel("Número de ativos (N)"); plt.ylabel("Risco da carteira (% a.a.)")
plt.title("Diversificação: o risco específico some, o sistemático permanece")
plt.legend(); plt.grid(alpha=0.3)
plt.savefig("figuras07/diversificacao.png", dpi=170, bbox_inches="tight")
```

#figure(
  image("figuras07/diversificacao.png", width: 85%),
  caption: [O risco de uma carteira cai rapidamente nos primeiros ativos e converge para o risco sistemático (piso).],
)

%%% BEFORE: === 2.5. Beta ($beta$)
#intuicao[
  O CAPM diz algo contraintuitivo: o mercado #strong[não paga] por risco que
  o investidor pode eliminar sozinho. Se você pode diversificar o risco
  específico de uma empresa de graça (comprando outras ações), o preço de
  equilíbrio não pode remunerá-lo --- senão todos comprariam aquela ação, o
  preço subiria e o retorno cairia. Só o #strong[risco sistemático],
  que não se elimina, tem prêmio, e o beta o mede.
]

#exemplo("lendo a reta do mercado de títulos (SML)")[
  Com $R_f = 10,5%$ e prêmio de mercado de 5,5%: uma ação de beta 1,2 deve
  render $E(R) = 10,5% + 1,2 times 5,5% = 17,1%$. Se o analista projeta 19%,
  o #strong[alfa] (retorno acima do exigido pelo risco) é $+1,9%$: a ação
  está "barata" (acima da SML) e vale a pena comprar; se projetasse 15%,
  o alfa seria $-2,1%$ e ela estaria "cara". O CAPM transforma a pergunta
  "o retorno esperado é bom?" em "é #emph[bom o bastante para o seu beta]?".
]

#mercado[
  #strong[O CAPM no Brasil.] Três cuidados práticos. (1) #strong[Taxa livre de
  risco:] usa-se a Selic ou o juro real de títulos longos (NTN-B) mais a
  inflação esperada; não há "ativo sem risco" perfeito porque o governo
  brasileiro também tem risco de crédito. (2) #strong[Prêmio de mercado:]
  estimado em dados históricos ou implícitos (Damodaran, por exemplo), com
  grande incerteza. (3) #strong[Moeda e risco-país:] um método comum é calcular
  o Ke em dólares (taxa livre de risco americana + beta × prêmio + prêmio de
  risco-país) e convertê-lo para reais pelo diferencial de inflação:
  $K_(e,"BRL") = (1 + K_(e,"USD")) (1 + pi_("BR"))/(1 + pi_("EUA")) - 1$. Com
  $K_(e,"USD") = 11%$, inflação de 4,5% no Brasil e 3% nos EUA, o
  $K_(e,"BRL") approx 12,6%$.
]

```python
# a "taxa livre de risco" (Selic nominal) neste exemplo é nominal, não real
rf_ex, premio_ex = 0.105, 0.055
for beta_ex, proj_ex in ((1.2, 0.19), (1.2, 0.15)):
    exigido = rf_ex + beta_ex * premio_ex
    print(f"Beta {beta_ex}: exigido {exigido*100:.2f}% | projetado {proj_ex*100:.1f}% | alfa {(proj_ex - exigido)*100:+.2f} p.p.")
```

%%% BEFORE: === 2.6. Críticas e Limitações do CAPM
#teoria("beta como razão de covariância e como inclinação")[
  A definição $beta_i = "Cov"(R_i, R_m)/"Var"(R_m)$ equivale a
  $beta_i = rho_(i m) dot sigma_i/sigma_m$: o beta é a correlação com o
  mercado, #strong[escalada] pela volatilidade relativa. E é a inclinação da
  regressão $R_i - R_f = alpha + beta (R_m - R_f) + epsilon$: se o mercado sobe
  1 ponto, a ação sobe em média $beta$ pontos. O $R^2$ da regressão mede a
  fração do risco da ação que é sistemática; o restante ($1 - R^2$) é
  específico.

  #strong[Beta alavancado × desalavancado.] O risco do negócio ($beta_U$) é
  amplificado pelo endividamento (risco financeiro). Pela fórmula de Hamada,

  $ beta_L = beta_U [1 + (1 - "IR") D/E] $

  Por exemplo, com $beta_U = 0,8$, $D/E = 0,5$ e IR de 34%, $beta_L = 0,8 times
  (1 + 0,66 times 0,5) = 1,064$. Para avaliar uma empresa com estrutura de
  capital diferente da das comparáveis, desalavanca-se o beta das comparáveis
  e realavanca-se com a estrutura-alvo.
]

#exemplo("estimando um beta com seis observações")[
  Retornos mensais do mercado: 2%, −1%, 3%, 0%, −2%, 4%; da ação: 3%, −2%, 5%,
  0,5%, −4%, 6%. A covariância amostral dividida pela variância do mercado
  dá $beta = 1,66$: a ação amplifica o mercado em 66%. Com apenas seis
  pontos, o erro padrão da estimativa é grande --- na prática usam-se 2 a 5
  anos de dados, com retornos semanais ou mensais.
]

```python
mercado_ex = np.array([0.02, -0.01, 0.03, 0.0, -0.02, 0.04])
acao_ex = np.array([0.03, -0.02, 0.05, 0.005, -0.04, 0.06])
cov_ex = np.cov(acao_ex, mercado_ex, ddof=1)[0, 1]
beta_ex2 = cov_ex / np.var(mercado_ex, ddof=1)
reg_ex = stats.linregress(mercado_ex, acao_ex)
print(f"Beta (Cov/Var): {beta_ex2:.4f} | beta (regressão): {reg_ex.slope:.4f} | alfa: {reg_ex.intercept*100:.3f}% | R²: {reg_ex.rvalue**2:.3f}")
print(f"Hamada: beta_U 0,8 com D/E 0,5 e IR 34% -> beta alavancado {0.8 * (1 + (1 - 0.34) * 0.5):.3f}")
```

%%% BEFORE: === 2.7. Fronteira Eficiente de Markowitz
#teoria("medidas de desempenho ajustadas ao risco")[
  Para comparar fundos com riscos diferentes, usam-se três medidas:

  - #strong[Índice de Sharpe:] $(R_p - R_f)/sigma_p$ --- retorno excedente por
    unidade de #emph[risco total]. Adequado quando a carteira é "toda" a
    riqueza do investidor.
  - #strong[Índice de Treynor:] $(R_p - R_f)/beta_p$ --- por unidade de #emph[risco
    sistemático]. Adequado quando a carteira é uma parte de uma carteira
    maior e diversificada.
  - #strong[Alfa de Jensen:] $alpha_p = R_p - [R_f + beta_p (R_m - R_f)]$ --- o
    retorno acima do que o CAPM exige.

  Exemplo (Selic 10,5%; prêmio de mercado 6%): o fundo A rende 16% com
  $sigma = 22%$ e $beta = 1,3$; o fundo B rende 14% com $sigma = 15%$ e $beta = 0,9$.
  Sharpe: A 0,25; B 0,23. Treynor: A 4,2%; B 3,9%. Jensen: A $-2,3%$; B $-1,9%$. O
  A "ganha" no Sharpe e no Treynor, mas ambos têm #strong[alfa negativo]: nenhum
  entregou retorno acima do exigido pelo seu risco.
]

%%% BEFORE_CHAPTER_END: == Capítulo 3 --- Custo de Capital
#teoria("a fronteira, a linha de alocação de capital e a separação em dois fundos")[
  Para um conjunto de ativos de risco, a #strong[fronteira eficiente] é a curva
  das carteiras de menor risco para cada retorno. Ao incluir um ativo livre de risco,
  surge a #strong[Linha de Alocação de Capital] (CAL): qualquer combinação
  entre o ativo livre de risco e uma carteira de risco $P$ fica numa reta no plano
  retorno × risco, cuja inclinação é o Sharpe de $P$. O investidor racional
  escolhe a carteira $P$ que #strong[maximiza o Sharpe] --- a #strong[carteira
  tangente] --- e ajusta o risco total só pela proporção investida no ativo
  livre de risco. É o teorema da #strong[separação em dois fundos]: todos os
  investidores, independentemente da aversão a risco, mantêm a mesma carteira
  de risco; só a mistura com o caixa muda. A carteira de mercado do CAPM é
  essa carteira tangente.

  #strong[Limitação.] A otimização é muito sensível aos retornos esperados
  informados: pequenos erros geram pesos extremos (incluindo posições vendidas
  grandes). Na prática, impõem-se restrições (sem venda a descoberto, limites
  por ativo) ou modelos mais robustos (Black-Litterman).
]

```python
mu_ex = np.array([0.12, 0.15, 0.09, 0.14])
cov_mk = np.array([
    [0.04, 0.012, 0.008, 0.015],
    [0.012, 0.09, 0.01, 0.025],
    [0.008, 0.01, 0.03, 0.009],
    [0.015, 0.025, 0.009, 0.07],
])
um = np.ones(4)
cov_inv = np.linalg.inv(cov_mk)
w_minvar = cov_inv @ um / (um @ cov_inv @ um)          # solução analítica de mínima variância (sem restrições)
print("Pesos de mínima variância:", np.round(w_minvar, 4))
print(f"Retorno {mu_ex @ w_minvar:.2%} | risco {np.sqrt(w_minvar @ cov_mk @ w_minvar):.2%}")

rng_mk = np.random.default_rng(7)
w_sim = rng_mk.dirichlet(np.ones(4), size=8000)
ret_sim_mk = w_sim @ mu_ex
risco_sim_mk = np.sqrt(np.einsum("ij,jk,ik->i", w_sim, cov_mk, w_sim))
sharpe_sim = (ret_sim_mk - 0.10) / risco_sim_mk
i_max = sharpe_sim.argmax()
print(f"Melhor Sharpe simulado (Rf 10%): {sharpe_sim[i_max]:.3f} com pesos {np.round(w_sim[i_max], 3)}")

plt.figure(figsize=(8.5, 4.6))
sc = plt.scatter(risco_sim_mk * 100, ret_sim_mk * 100, c=sharpe_sim, cmap="viridis", s=6, alpha=0.7)
plt.colorbar(sc, label="Índice de Sharpe (Rf = 10%)")
plt.scatter([np.sqrt(w_minvar @ cov_mk @ w_minvar) * 100], [mu_ex @ w_minvar * 100], color="#a33a1c", s=70, zorder=5, label="Mínima variância")
plt.scatter([risco_sim_mk[i_max] * 100], [ret_sim_mk[i_max] * 100], color="orange", s=70, zorder=5, edgecolor="black", label="Máximo Sharpe")
plt.plot([0, risco_sim_mk[i_max] * 130], [10, 10 + sharpe_sim[i_max] * risco_sim_mk[i_max] * 130], color="gray", linestyle="--", label="Linha de alocação de capital")
plt.xlabel("Risco (desvio padrão, %)"); plt.ylabel("Retorno esperado (%)")
plt.title("Carteiras aleatórias e a fronteira eficiente")
plt.legend(); plt.grid(alpha=0.3)
plt.savefig("figuras07/fronteira.png", dpi=170, bbox_inches="tight")
```

#figure(
  image("figuras07/fronteira.png", width: 88%),
  caption: [Cada ponto é uma carteira dos quatro ativos. A fronteira eficiente é o limite superior da nuvem; a reta tangente (CAL) toca a carteira de maior Sharpe.],
)

#resumo[
  - Retorno composto: use média #strong[geométrica]; a volatilidade anual é $sigma_d sqrt(252)$.
  - Risco de carteira depende da #strong[covariância]; diversificar elimina o risco
    específico, não o sistemático ($sigma sqrt(rho)$).
  - CAPM: $E(R) = R_f + beta (R_m - R_f)$. O beta é $"Cov"/"Var"$, a inclinação da
    regressão; desalavanca-se e realavanca-se pela fórmula de Hamada.
  - Sharpe, Treynor e alfa de Jensen comparam desempenho ajustado ao risco.
  - Markowitz: fronteira eficiente, carteira tangente e separação em dois fundos.
]
%%% END
