%%% BEFORE: === 11.2. Renda Fixa
#exemplo("quem faz o quê no Sistema Financeiro Nacional")[
  #figure(
    align(center)[#table(
      columns: (18%, 82%),
      align: (left, left),
      table.header([Órgão], [Papel],),
      [#strong[CMN]], [Conselho Monetário Nacional: define as normas e as metas (inclusive a meta de inflação)],
      [#strong[BCB]], [Banco Central: executa a política monetária, supervisiona bancos e opera o câmbio],
      [#strong[CVM]], [Comissão de Valores Mobiliários: regula o mercado de capitais (ações, debêntures, fundos)],
      [#strong[SUSEP]], [Supervisiona seguros e previdência aberta],
      [#strong[PREVIC]], [Supervisiona fundos de pensão (previdência fechada)],
      [#strong[B3]], [Bolsa e infraestrutura: negociação, compensação e liquidação],
    )]
    , kind: table
    )

  No #strong[mercado primário] a empresa ou o governo emite títulos e recebe o
  dinheiro (IPO, emissão de debêntures, leilão do Tesouro); no
  #strong[mercado secundário] os investidores negociam entre si, o que dá
  #strong[liquidez] e forma o preço de referência.
]

%%% BEFORE: === 11.3. Renda Variável
#teoria("preço, rendimento (YTM), duration e convexidade de um título")[
  O preço de um título é o valor presente de seus fluxos (cupons $C$ e principal
  $F$) à taxa de mercado $y$ --- o #strong[rendimento até o vencimento]
  (YTM):

  $ P = sum_(t=1)^n C/(1 + y)^t + F/(1 + y)^n $

  Preço e rendimento se movem em #strong[sentidos opostos]. A sensibilidade é
  medida pela #strong[duration de Macaulay], a média ponderada dos prazos dos fluxos
  (cada prazo pesado pela fração do preço que o fluxo representa):

  $ D_("Mac") = (sum_(t=1)^n t dot "VP"("FC"_t))/P quad "e" quad D_("mod") = D_("Mac")/(1 + y) $

  Para pequenas variações, $Delta P/P approx -D_("mod") dot Delta y$. A
  aproximação de primeira ordem subestima o preço quando os juros caem e
  superestima a queda quando sobem, porque a relação preço × taxa é #strong[convexa];
  o termo de #strong[convexidade] corrige: $Delta P/P approx -D_("mod") Delta y + 1/2
  "Conv" (Delta y)^2$. A duration é, em essência, o "prazo médio efetivo" do título:
  títulos de cupom zero têm duration igual ao prazo; cupons altos a reduzem.
]

#exemplo("duration na prática")[
  Título com valor de face R\$ 1.000, cupom de 10% a.a. e 5 anos, a um
  rendimento de 12% a.a.: o preço é #strong[R\$ 927,90] (abaixo do valor de face, porque
  o cupom é menor que o rendimento exigido). A duration de Macaulay é 4,14 anos e a
  modificada, 3,69. Se o rendimento sobe 1 ponto (12% → 13%), o preço cai
  3,60%; a duration prevê −3,69% e, com a convexidade, −3,60%.
  Regra de bolso: #strong[cada ano de duration modificada equivale a cerca de 1%
  de variação de preço por 1 ponto de variação na taxa].
]

```python
def preco_duration(face, cupom, y, n):
    fluxos_b = [face * cupom] * n
    fluxos_b[-1] += face
    vps = [f / (1 + y) ** (t + 1) for t, f in enumerate(fluxos_b)]
    preco_b = sum(vps)
    mac = sum((t + 1) * vp for t, vp in enumerate(vps)) / preco_b
    conv = sum((t + 1) * (t + 2) * vp / (1 + y) ** 2 for t, vp in enumerate(vps)) / preco_b
    return preco_b, mac, mac / (1 + y), conv

p0_b, mac_b, mod_b, conv_b = preco_duration(1000, 0.10, 0.12, 5)
p1_b = preco_duration(1000, 0.10, 0.13, 5)[0]
print(f"Preço R${p0_b:.2f} | duration Macaulay {mac_b:.3f} | modificada {mod_b:.3f} | convexidade {conv_b:.2f}")
print(f"Alta de 1 p.p. nos juros: variação real {p1_b / p0_b - 1:+.3%} | pela duration {-mod_b * 0.01:+.3%} | com convexidade {-mod_b * 0.01 + 0.5 * conv_b * 0.01 ** 2:+.3%}")
```

#mercado[
  No Tesouro Direto, o #strong[Tesouro Selic] (LFT) tem duration próxima de zero:
  como paga a taxa de juros do momento, seu preço oscila pouco; é a
  referência de #emph[baixo risco de mercado]. O #strong[Tesouro Prefixado] e o
  #strong[Tesouro IPCA+] têm duration longa e, por isso, preços muito sensíveis às
  variações da taxa (marcação a mercado), como mostramos no capítulo 6 da apostila
  de Matemática Financeira. Um investidor com horizonte longo, que mantém o
  título até o vencimento, não sofre a oscilação --- mas quem precisa vender antes sim.
]

%%% BEFORE: === 11.4. Análise de um Ativo
#teoria("opções: payoffs, paridade put-call e Black-Scholes")[
  Uma #strong[opção de compra] (call) dá o direito de comprar o ativo a um preço de
  exercício $K$; seu valor no vencimento é $max(S_T - K, 0)$. Uma #strong[opção de venda]
  (put) dá o direito de vender: $max(K - S_T, 0)$. A opção tem um custo (prêmio),
  mas #strong[perda máxima limitada] ao prêmio para o comprador.

  #strong[Paridade put-call:] comprar uma call e vender uma put de mesmo $K$ e
  vencimento replica comprar o ativo a prazo: $C - P = S - K e^(-r T)$. Se a
  relação não vale, há arbitragem.

  #strong[Black-Scholes (call europeia, sem dividendos):]

  $ C = S N(d_1) - K e^(-r T) N(d_2), quad d_1 = (ln(S\/K) + (r + sigma^2\/2) T)/(sigma sqrt(T)), quad d_2 = d_1 - sigma sqrt(T) $

  onde $N(dot)$ é a distribuição normal acumulada. O valor da opção cresce com
  a #strong[volatilidade] (mais incerteza, mais chance de ganho grande, e a
  perda é limitada), com o prazo e com a taxa de juros. O $N(d_1)$ é o #strong[delta]:
  quanto o preço da opção varia por R\$ 1 de variação do ativo.
]

#exemplo("precificando uma call")[
  Ação a R\$ 30, preço de exercício R\$ 32, vencimento em 6 meses ($T = 0,5$),
  taxa livre de risco de 10,5% a.a. (contínua, simplificação) e volatilidade de 35%
  a.a. O modelo dá call de #strong[R\$ 2,79], put de #strong[R\$ 3,16] e #strong[delta de
  0,53]: se a ação subir R\$ 1, a call tende a subir R\$ 0,53. Compre a call: o
  risco é perder no máximo R\$ 2,79 por opção; a alta, ilimitada.
]

```python
def black_scholes(s, k, r, sigma, t):
    d1 = (np.log(s / k) + (r + sigma ** 2 / 2) * t) / (sigma * np.sqrt(t))
    d2 = d1 - sigma * np.sqrt(t)
    call = s * stats.norm.cdf(d1) - k * np.exp(-r * t) * stats.norm.cdf(d2)
    put = k * np.exp(-r * t) * stats.norm.cdf(-d2) - s * stats.norm.cdf(-d1)
    return call, put, stats.norm.cdf(d1)

call_bs, put_bs, delta_bs = black_scholes(30, 32, 0.105, 0.35, 0.5)
print(f"Call R${call_bs:.2f} | put R${put_bs:.2f} | delta {delta_bs:.3f}")
print(f"Paridade put-call: C - P = {call_bs - put_bs:.4f} | S - K·e^(-rT) = {30 - 32 * np.exp(-0.105 * 0.5):.4f}")
for vol_ex in (0.20, 0.35, 0.50):
    print(f"Volatilidade {vol_ex:.0%}: call = R${black_scholes(30, 32, 0.105, vol_ex, 0.5)[0]:.2f}")
```

#teoria("futuros e custo de carregamento")[
  Um contrato futuro obriga a comprar/vender no futuro por um preço fixado hoje. O
  preço justo decorre de uma arbitragem: comprar o ativo hoje (financiado a
  taxa $r$) e vendê-lo a termo. Sem rendimentos no ativo, $F = S (1 + r)^T$; é o
  #strong[custo de carregamento]. Para a moeda, o carregamento é o diferencial de juros:
  $F = S (1 + i_("BR"))/(1 + i_("EUA"))$ --- a paridade coberta de juros, vista no
  capítulo 12. Um #strong[swap] troca fluxos de dois indexadores (por exemplo, pré × CDI),
  e é, na prática, uma carteira de contratos a termo.
]

%%% BEFORE_CHAPTER_END: == Capítulo 12 --- Finanças Internacionais
#exemplo("análise de risco de uma série de preços (dados simulados)")[
  A função `analisar_acao` baixa dados da internet. Para estudar as mesmas
  métricas sem depender da conexão, o código a seguir as calcula sobre uma
  trajetória #strong[simulada] (movimento browniano geométrico, semente fixa):
  retorno anualizado, volatilidade, Sharpe e #strong[drawdown máximo] (maior queda
  do pico ao vale --- o pior momento para quem investiu no pico).
]

```python
def metricas_serie(precos_s, rf=0.10):
    ret_s = precos_s[1:] / precos_s[:-1] - 1
    anos_s = len(ret_s) / 252
    cagr_s = (precos_s[-1] / precos_s[0]) ** (1 / anos_s) - 1
    vol_s = ret_s.std(ddof=1) * np.sqrt(252)
    pico_s = np.maximum.accumulate(precos_s)
    dd_s = (precos_s - pico_s) / pico_s
    return cagr_s, vol_s, (cagr_s - rf) / vol_s, dd_s.min()

rng_p = np.random.default_rng(11)
mu_d, sig_d = 0.13 / 252, 0.30 / np.sqrt(252)
precos_sim = 20 * np.exp(np.cumsum(rng_p.normal(mu_d - sig_d ** 2 / 2, sig_d, 756)))
precos_sim = np.concatenate(([20.0], precos_sim))
cagr_s, vol_s, sharpe_s, dd_s = metricas_serie(precos_sim)
print(f"Retorno anualizado: {cagr_s:.2%} | volatilidade: {vol_s:.2%} | Sharpe (Rf 10%): {sharpe_s:.2f} | drawdown máximo: {dd_s:.2%}")
```

#resumo[
  - O SFN tem reguladores distintos (CMN, BCB, CVM, SUSEP, PREVIC); o mercado primário capta, o secundário dá liquidez.
  - $P = sum "FC"_t/(1 + y)^t$; $D_("mod")$ mede a sensibilidade do preço a $y$; a convexidade refina.
  - Opções: payoffs assimétricos; Black-Scholes; paridade put-call; futuros pelo custo de carregamento.
  - Retorno, volatilidade, Sharpe e #strong[drawdown] são o painel mínimo de risco de um ativo.
]

%%% BEFORE: === 12.2. Risco-País (EMBI+)
#teoria("paridade coberta de juros: a dedução")[
  Um investidor com R\$ 1 pode (a) aplicar no Brasil a $i_("BR")$, obtendo $(1 + i_("BR"))$; ou
  (b) converter em dólares ao câmbio spot $S$, aplicar nos EUA a $i_("EUA")$ e
  #strong[travar] a reconversão a um câmbio a termo $F$: obtém $(1/S)(1 + i_("EUA")) F$. Sem
  arbitragem, os dois retornos são iguais:

  $ (1 + i_("BR")) = (1 + i_("EUA")) F/S quad arrow.r.double quad F = S (1 + i_("BR"))/(1 + i_("EUA")) $

  É a #strong[paridade coberta de juros] (CIP), uma relação de #emph[arbitragem]
  (vale exatamente, a menos de custos). Já a #strong[paridade
  #emph[descoberta]] (UIP) afirma que o câmbio #emph[esperado] no futuro é
  $F$: ela é uma hipótese de #emph[comportamento], que a evidência empírica
  rejeita --- moedas de juros altos tendem a #emph[não] se depreciar tanto quanto o
  diferencial prevê. Essa falha (o "enigma do prêmio a termo") é a base da
  operação de #strong[carry trade]. A função do código acima, apesar de
  chamada "paridade descoberta", calcula a fórmula do #emph[câmbio a termo]
  (CIP).
]

#exemplo("câmbio a termo e o ponto de equilíbrio do carry trade")[
  Com câmbio spot R\$ 5,20/US\$, juros de 13,25% no Brasil e 5% nos EUA, o câmbio a
  termo de 1 ano é $5,20 times 1,1325/1,05 = $ R\$ 5,61, uma "desvalorização" implícita
  de 7,86%. Um investidor que toma dólares a 5% e aplica em reais a 13,25%
  (#strong[carry trade]) lucra se o real se desvalorizar #emph[menos] que 7,86% no ano;
  perde se desvalorizar mais. O ganho de "carregar" juros altos é compensação
  pelo #strong[risco cambial] --- que pode se materializar de uma vez.
]

%%% BEFORE: === 12.3. Teoria da Paridade do Poder de Compra (PPP)
#exemplo("do Ke em dólares ao Ke em reais, com risco-país")[
  O #strong[risco-país] (spread do EMBI sobre os Treasuries, ou o CDS soberano)
  mede o prêmio pelo risco de investir em um país emergente. Em avaliações em
  moeda forte, soma-se um prêmio de risco-país ao custo do capital. Exemplo
  (números #emph[ilustrativos]): taxa livre de risco americana de 4,5%, beta de 1,1,
  prêmio de mercado de 5% e prêmio de risco-país de 3%:

  $ K_(e,"USD") = 4,5% + 1,1 times 5% + 3% = 13,0% $

  Para descontar fluxos em #strong[reais], converte-se pela diferença de inflações
  (como na seção 2.4): com inflação de 4,5% no Brasil e 3% nos EUA,
  $K_(e,"BRL") = 1,13 times 1,045/1,03 - 1 = 14,65%$.
]

%%% BEFORE_CHAPTER_END: == Capítulo 13 --- Exercícios Resolvidos
#exemplo("as cinco condições de paridade, juntas")[
  Brasil com inflação de 4,5% e EUA com 3,0%; juros de 13,25% (BR) e 5,0% (EUA);
  câmbio spot R\$ 5,20.

  - #strong[PPP relativa:] o real deve se desvalorizar pelo diferencial de
    inflação: $1,045/1,03 - 1 = 1,46%$ no ano.
  - #strong[Efeito Fisher internacional:] as taxas nominais refletem as inflações
    esperadas mais uma taxa real; diferenças de juros nominais $approx$ diferenças
    de inflação esperada (mais prêmio de risco). Aqui, o diferencial de juros (7,86%)
    é muito maior que o de inflação (1,46%): o juro real brasileiro é bem mais alto.
  - #strong[Paridade descoberta (UIP):] o câmbio esperado deveria se depreciar 7,86%.
  - #strong[Paridade coberta (CIP):] o câmbio a termo é R\$ 5,61 (+7,86%).

  O resultado revela que as condições #strong[não se verificam todas] ao
  mesmo tempo: se valesse a PPP (1,46% de desvalorização), o carry trade
  daria um ganho de 6,4 pontos --- é essa distância entre o que a PPP prevê e
  o que o juro cobra que alimenta o carry trade. A PPP vale melhor no #strong[longo prazo]
  (muitos anos), e é um bom guia para o câmbio #emph[real]:
  $q = S P^* / P$ (preço relativo da cesta entre os países).
]

#resumo[
  - CIP: $F = S (1 + i_("BR"))/(1 + i_("EUA"))$ (arbitragem). UIP: o câmbio esperado é $F$ (hipótese empírica fraca).
  - Carry trade: lucra se a moeda de juro alto se depreciar menos que o diferencial; carrega risco cambial.
  - Custo de capital em moeda forte: inclui risco-país; convertido para reais pelo diferencial de inflação.
  - PPP relativa: $Delta S approx (1 + pi)/(1 + pi^*) - 1$; vale melhor no longo prazo.
]
%%% END
