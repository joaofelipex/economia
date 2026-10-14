%%% BEFORE: === 8.2. Ciclos Operacionais
#teoria("de onde vem a fórmula ST = CCL − NCG")[
  O capital circulante líquido (CCL) é apenas a diferença entre o ativo
  circulante (AC) e o passivo circulante (PC). A análise dinâmica (modelo de Fleuriet)
  separa cada um deles em parte #strong[operacional] (ligada ao ciclo do
  negócio) e #strong[financeira] (caixa, aplicações e empréstimos de curto prazo):

  $ "CCL" = ("AC"_("op") + "AC"_("fin")) - ("PC"_("op") + "PC"_("fin")) $

  Reagrupando: $"CCL" = underbrace("AC"_("op") - "PC"_("op"), "NCG") + underbrace("AC"_("fin") - "PC"_("fin"), "ST")$, logo $"ST" = "CCL" - "NCG"$.
  A NCG é o #strong[investimento permanente] em estoques e clientes, líquido do
  crédito de fornecedores e obrigações operacionais: se positiva, alguém
  precisa financiá-la --- com recursos de longo prazo (CCL), caixa próprio
  ou, pior, #strong[empréstimos de curto prazo] (ST negativo).
]

#exemplo("efeito tesoura: crescer consome caixa")[
  Uma empresa tem NCG equivalente a 20% da receita e margem líquida de 3%.
  Cada R\$ 100 de vendas a mais exigem R\$ 20 de capital de giro adicional e
  geram apenas R\$ 3 de lucro: o #strong[crescimento consome caixa]. Com receita
  de R\$ 1.000 crescendo 20% ao ano, a empresa precisa de mais R\$ 40 de NCG
  no primeiro ano para um lucro adicional de R\$ 6 --- se não houver
  financiamento, o ST fica cada vez mais negativo. É o "efeito tesoura":
  as necessidades de caixa crescem mais rápido que a geração de caixa,
  e muitas empresas lucrativas quebram assim.
]

```python
receita_t, margem_t, ncg_pct, cresc_t = 1000, 0.03, 0.20, 0.20
ncg_ant = receita_t * ncg_pct
print(f"{'Ano':>4} {'Receita':>9} {'Lucro':>7} {'NCG':>7} {'ΔNCG':>7} {'Caixa gerado':>13}")
for ano_t in range(1, 5):
    receita_t *= 1 + cresc_t
    ncg_t = receita_t * ncg_pct
    lucro_t = receita_t * margem_t
    print(f"{ano_t:>4} {receita_t:>9.0f} {lucro_t:>7.1f} {ncg_t:>7.1f} {ncg_t - ncg_ant:>7.1f} {lucro_t - (ncg_t - ncg_ant):>13.1f}")
    ncg_ant = ncg_t
```

%%% BEFORE: === 8.3. Capital de Giro Negativo
#teoria("como calcular os prazos a partir do balanço")[
  Os prazos médios se obtêm dividindo a conta de balanço pelo fluxo da DRE
  correspondente e multiplicando por 360 (ou 365) dias:

  $ "PME" = "Estoques"/"CPV" times 360 quad "PMR" = "Contas a receber"/"Receita" times 360 quad "PMP" = "Fornecedores"/"Compras" times 360 $

  O #strong[ciclo operacional] é $"PME" + "PMR"$ (do dinheiro virar estoque até virar
  caixa de clientes); o #strong[ciclo financeiro] é $"CO" - "PMP"$ (quantos dias
  a empresa financia com recursos próprios ou de terceiros). A NCG é aproximadamente
  $"Receita"/360 times "Ciclo financeiro"$.
]

#exemplo("quanto vale encurtar o ciclo?")[
  Estoques de R\$ 300, CPV de R\$ 1.800, contas a receber de R\$ 400, receita de
  R\$ 2.400, fornecedores de R\$ 150, compras de R\$ 1.500:

  - $"PME" = 300/1.800 times 360 = 60$ dias; $"PMR" = 400/2.400 times 360 = 60$ dias;
    $"PMP" = 150/1.500 times 360 = 36$ dias.
  - Ciclo operacional: 120 dias. Ciclo financeiro: $120 - 36 = 84$ dias.

  Se a empresa reduzir o prazo de recebimento em 10 dias (cobrança mais
  eficiente), libera $2.400/360 times 10 = 66,7$ de caixa. Aplicado ao CDI de
  13,25%, isso vale R\$ 8,8 por ano de economia financeira. Nenhuma venda a mais:
  só gestão do capital de giro. Cada dia de ciclo tem custo.
]

```python
estoques_c, cpv_c, receber_c, receita_c, fornec_c, compras_c = 300, 1800, 400, 2400, 150, 1500
pme_c = estoques_c / cpv_c * 360
pmr_c = receber_c / receita_c * 360
pmp_c = fornec_c / compras_c * 360
co_c, cf_c = pme_c + pmr_c, pme_c + pmr_c - pmp_c
print(f"PME {pme_c:.0f} d | PMR {pmr_c:.0f} d | PMP {pmp_c:.0f} d | ciclo operacional {co_c:.0f} d | ciclo financeiro {cf_c:.0f} d")
print(f"NCG aproximada: R${receita_c / 360 * cf_c:,.1f}")
liberado = receita_c / 360 * 10
print(f"Reduzir o PMR em 10 dias libera R${liberado:.1f} e economiza R${liberado * 0.1325:.2f}/ano a 13,25% a.a.")
```

%%% BEFORE_CHAPTER_END: == Capítulo 9 --- Fusões e Aquisições (M&A)
#atencao[
  #strong[Capital de giro negativo tem um calcanhar de Aquiles.] A empresa
  que financia ativos com crédito de fornecedores opera com folga #emph[enquanto
  o crédito é renovado]. Se os fornecedores cortarem o prazo (por perda de
  confiança, por exemplo), o caixa some depressa. Daí o paradoxo de
  varejistas com capital de giro negativo que quebram rápido ao perder a
  confiança do mercado. E um capital de giro negativo #strong[não equivale] a
  problema de liquidez, mas exige atenção ao risco de #emph[renovação].
]

#resumo[
  - $"ST" = "CCL" - "NCG"$; ST negativo significa financiar a operação com dívida de curto prazo.
  - Prazos: $"PME" = "Estoque"/"CPV" times 360$; $"PMR"$ e $"PMP"$ análogos; ciclo financeiro $= "PME" + "PMR" - "PMP"$.
  - Crescer consome caixa (efeito tesoura); cada dia de ciclo financeiro tem custo de oportunidade.
]

%%% BEFORE: === 9.2. Sinergias
#atencao[
  #strong[Diversificação não é motivo válido para o acionista.] O argumento
  "reduz o risco" é fraco: o acionista pode diversificar sozinho, comprando ações de
  outras empresas, sem pagar prêmio de controle. A diversificação corporativa
  só interessa a #emph[gestores] cujo emprego depende da empresa --- uma
  fonte clássica de conflito de agência. A evidência empírica mostra que, na
  média, as fusões #strong[criam valor para os acionistas do alvo] (que
  recebem o prêmio) e valor ao redor de zero, às vezes negativo, para os da
  adquirente, o que reforça o problema do "vencedor amaldiçoado": quem
  vence um leilão tende a ser quem mais superestimou as sinergias.
]

%%% BEFORE: === 9.3. Tipos de Integração
#teoria("quanto valem as sinergias e quem fica com elas")[
  As sinergias de #strong[custo] (eliminar áreas duplicadas, ganhar escala nas
  compras) são as mais previsíveis; as de #strong[receita] (vendas cruzadas) são
  incertas. Para valorá-las, projetam-se os fluxos incrementais, desconta-se
  a uma taxa compatível com o risco (maior para sinergias de receita) e
  subtraem-se os #strong[custos de integração] (únicos).

  Exemplo: economia de R\$ 30 milhões por ano antes de impostos, perpétua; IR
  de 34%; custo de integração único de R\$ 40 milhões; taxa de 12%. Valor presente
  $= 30 times 0,66/0,12 - 40 = 165 - 40 = $ R\$ 125 milhões. Esse é o #strong[teto]
  do prêmio: pagar mais que R\$ 125 milhões transfere para os acionistas do alvo
  todo o valor criado --- e mais.

  $ "Valor para A" = "Sinergia" - "Prêmio" $
  $ "Valor para B" = "Prêmio" $
]

#exemplo("pagar em dinheiro ou em ações?")[
  A tem 100 milhões de ações a R\$ 30,00 (valor R\$ 3.000 milhões); B vale R\$
  800 milhões e há sinergia de R\$ 200 milhões. A oferece R\$ 950 milhões por B
  (prêmio de R\$ 150 milhões). Valor combinado: $3.000 + 800 + 200 = 4.000$.

  - #strong[Em dinheiro] (financiado por dívida): os acionistas de A ficam com o que
    sobra, $4.000 - 950 = 3.050$, ou R\$ 30,50 por ação (+1,7%).
  - #strong[Em ações:] A emite $950/30 = 31,67$ milhões de ações novas; passa a ter
    131,67 milhões; valor por ação $= 4.000/131,67 = $ R\$ 30,38 (+1,3%).

  No pagamento em ações, os acionistas do alvo passam a #strong[dividir] os
  ganhos (e as perdas) da combinação, em proporção à participação;
  em dinheiro, a adquirente assume todo o risco de as sinergias não se
  concretizarem. Por isso o adquirente confiante nas sinergias prefere
  dinheiro, e o inseguro, ações.
]

```python
def fusao_dinheiro_acoes(acoes_a, preco_a, v_b, sinergia_s, oferta):
    valor_comb = acoes_a * preco_a + v_b + sinergia_s
    por_acao_cash = (valor_comb - oferta) / acoes_a
    novas = oferta / preco_a
    por_acao_stock = valor_comb / (acoes_a + novas)
    return por_acao_cash, por_acao_stock, novas

cash_p, stock_p, novas_p = fusao_dinheiro_acoes(100, 30, 800, 200, 950)
print(f"Dinheiro: R${cash_p:.2f}/ação ({cash_p / 30 - 1:+.2%}) | ações: R${stock_p:.2f}/ação ({stock_p / 30 - 1:+.2%}) | ações novas: {novas_p:.2f} milhões")
print("Se a sinergia fosse zero:")
cash0, stock0, _ = fusao_dinheiro_acoes(100, 30, 800, 0, 950)
print(f"Dinheiro: R${cash0:.2f}/ação ({cash0 / 30 - 1:+.2%}) | ações: R${stock0:.2f}/ação ({stock0 / 30 - 1:+.2%})")
```

%%% BEFORE: === 9.4. O Processo de M&A
#mercado[
  #strong[Defesa da concorrência.] Fusões entre empresas de porte relevante
  precisam ser submetidas ao CADE (#emph[ato de concentração]), que pode
  aprovar, impor remédios (como venda de ativos) ou vetar. Fusões
  horizontais (concorrentes) sofrem escrutínio mais rigoroso. Para
  empresas de capital aberto, há ainda regras da CVM (fato relevante, oferta
  pública de aquisição) para proteger acionistas minoritários.
]

%%% BEFORE_CHAPTER_END: == Capítulo 10 --- Finanças Comportamentais
#resumo[
  - Sinergia $= V("AB") - [V("A") + V("B")]$; o valor para o adquirente é #strong[sinergia menos prêmio].
  - Sinergias de custo são mais confiáveis que as de receita; desconte e subtraia custos de integração.
  - O prêmio máximo racional é o valor da sinergia; pagar mais transfere toda a riqueza ao alvo.
  - Pagamento em ações divide o risco das sinergias com os acionistas do alvo; em dinheiro, não.
  - O processo (due diligence, valuation, negociação, integração) é tão importante quanto o preço.
]

%%% BEFORE: === 10.2. Principais Vieses
#teoria("a hipótese de mercado eficiente (EMH) e seus limites")[
  Fama (1970) classificou a eficiência em três formas, conforme a informação
  incorporada aos preços:

  #figure(
    align(center)[#table(
      columns: (20%, 40%, 40%),
      align: (left, left, left),
      table.header([Forma], [Informação refletida no preço], [Consequência],),
      [#strong[Fraca]], [Preços e volumes passados], [Análise técnica não gera retorno anormal],
      [#strong[Semiforte]], [Toda informação pública], [Análise fundamentalista também não],
      [#strong[Forte]], [Também informação privada], [Nem informação privilegiada gera ganho],
    )]
    , kind: table
    )

  A EMH não diz que os preços estão sempre "certos", mas que
  #strong[não se pode prever consistentemente os desvios]. As finanças
  comportamentais contestam a premissa de racionalidade; os defensores da EMH
  respondem com os #strong[limites da arbitragem]: mesmo que existam
  preços "errados", corrigir exige capital, tempo e tolerância ao risco de
  o erro aumentar antes de diminuir ("o mercado pode ficar irracional por mais
  tempo do que você consegue ficar solvente").
]

%%% BEFORE: === 10.3. Anomalias de Mercado
#teoria("teoria da perspectiva: a função valor de Kahneman e Tversky")[
  Pela teoria da utilidade esperada, o investidor avalia a #emph[riqueza final]
  e é avesso a risco. Kahneman e Tversky (1979) mostraram que as pessoas avaliam
  #strong[ganhos e perdas em relação a um ponto de referência], e que a função valor é:
  #strong[côncava nos ganhos] (aversão a risco), #strong[convexa nas perdas]
  (busca de risco) e #strong[mais íngreme nas perdas] (aversão à perda). Uma forma
  funcional usual é

  $ v(x) = cases(x^alpha "se" x >= 0, -lambda (-x)^alpha "se" x < 0) $

  com $alpha approx 0,88$ e $lambda approx 2,25$ (estimativas de Tversky e
  Kahneman, 1992): uma perda "dói" cerca de 2,25 vezes mais que um ganho
  equivalente "alegra".
]

#exemplo("rejeitar um jogo vantajoso")[
  Um jogo paga +R\$ 150 com 50% de chance e −R\$ 100 com 50%. O #strong[valor
  esperado] é $0,5 times 150 - 0,5 times 100 = +25$: um investidor neutro ao
  risco aceita. Pela função valor, porém, $v(150) = 150^(0,88) = 82,2$ e
  $v(-100) = -2,25 times 100^(0,88) = -129,5$, de modo que o valor
  subjetivo é $0,5 times 82,2 + 0,5 times (-129,5) = -23,6$ --- #strong[negativo]. A
  maioria das pessoas rejeita o jogo, o que a teoria da utilidade esperada
  (com riqueza total) mal explica. É a #strong[aversão à perda] em ação, e
  é o motor do #emph[disposition effect]: vender vencedoras cedo (para
  "realizar o ganho", côncavo) e segurar perdedoras (para não
  "realizar a perda", convexo).
]

```python
def valor_prospecto(x, alpha=0.88, lam=2.25):
    return x ** alpha if x >= 0 else -lam * (-x) ** alpha

print(f"v(+100) = {valor_prospecto(100):.1f} | v(-100) = {valor_prospecto(-100):.1f} -> a perda pesa {-valor_prospecto(-100) / valor_prospecto(100):.2f}x o ganho")
ev_jogo = 0.5 * 150 + 0.5 * (-100)
vp_jogo = 0.5 * valor_prospecto(150) + 0.5 * valor_prospecto(-100)
print(f"Jogo +150/-100: valor esperado R${ev_jogo:+.1f} | valor pela teoria da perspectiva {vp_jogo:+.1f} -> {'aceita' if vp_jogo > 0 else 'rejeita'}")
```

%%% BEFORE_CHAPTER_END: == Capítulo 11 --- Mercados Financeiros
#atencao[
  #strong[Cuidado com as "anomalias".] Muitos padrões documentados
  desaparecem depois de publicados ou não sobrevivem a custos de transação,
  e muitos resultam de #strong[mineração de dados] (testar centenas de
  estratégias e relatar a que "funcionou"). Antes de aceitar uma anomalia,
  pergunte: ela tem uma explicação econômica plausível? Resiste fora da
  amostra e em outros países? Sobrevive a custos e a impostos?
]

#mercado[
  #strong[Como reduzir os vieses na prática.] (1) Regras de decisão escritas
  antes (política de investimento, critérios de compra e venda). (2)
  #strong[Automatizar] aportes e rebalanceamentos (reduz o impulso de seguir a manada).
  (3) Diário de decisões, para combater o viés retrospectivo. (4) Buscar
  ativamente #emph[evidência contrária] à tese (combate o viés de confirmação).
  (5) Separar a decisão do #emph[processo] do resultado de curto prazo.
]

#resumo[
  - A EMH diz que desvios de preços não são previsíveis; os limites da arbitragem explicam por que erros de preço persistem.
  - Teoria da perspectiva: ganhos e perdas relativos a uma referência; perdas pesam ~2,25 vezes mais.
  - Vieses (excesso de confiança, aversão à perda, ancoragem, manada) geram negociação excessiva e bolhas.
  - Anomalias exigem ceticismo estatístico e econômico.
]
%%% END
