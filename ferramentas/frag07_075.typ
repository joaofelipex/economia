%%% APPEND: caso
== Capítulo 18 --- Estudo de Caso Integrador: Alfa Indústria S.A.
<capítulo-18-estudo-de-caso-integrador>
Este capítulo reúne as ferramentas da apostila em uma análise completa de uma
empresa fictícia, a #strong[Alfa Indústria S.A.]: diagnóstico das
demonstrações, retorno, custo de capital, valuation por FCD e por múltiplos, e
veredito. Todos os valores em R\$ milhões. Siga o código executando-o; as
interpretações vêm logo abaixo de cada resultado.

=== 18.1. Os dados
<os-dados>
#figure(
  align(center)[#table(
    columns: (50%, 50%),
    align: (left, left),
    table.header([Demonstração do resultado], [Balanço patrimonial],),
    [Receita líquida: 2.000], [Caixa: 100 | Contas a receber: 330],
    [CPV (caixa): 1.200 | Despesas operacionais: 300], [Estoques: 220 | Imobilizado: 900 (Ativo: 1.550)],
    [Depreciação: 100 | Despesas financeiras: 80], [Fornecedores: 130 | Dívida CP: 120 | Dívida LP: 480],
    [IR: 34% | LL resultante: 211,2], [Patrimônio líquido: 820],
  )]
  , kind: table
  )

#strong[Dados de mercado:] 100 milhões de ações a R\$ 22,00; beta de 1,10; Selic de
10,5%; prêmio de mercado de 5,5%; custo bruto da dívida de 13,5% a.a.

```python
caso = dict(receita=2000, cpv=1200, desp_op=300, deprec=100, desp_fin=80, ir=0.34,
            caixa=100, receber=330, estoques=220, imobilizado=900,
            fornec=130, div_cp=120, div_lp=480, pl=820,
            acoes=100, preco=22.0, beta=1.10, rf=0.105, premio=0.055, kd_bruto=0.135)

ebitda_c = caso["receita"] - caso["cpv"] - caso["desp_op"]
ebit_c = ebitda_c - caso["deprec"]
lair_c = ebit_c - caso["desp_fin"]
ll_c = lair_c * (1 - caso["ir"])
ativo_c = caso["caixa"] + caso["receber"] + caso["estoques"] + caso["imobilizado"]
passivo_c = caso["fornec"] + caso["div_cp"] + caso["div_lp"] + caso["pl"]
divida_c = caso["div_cp"] + caso["div_lp"]
print(f"EBITDA {ebitda_c} ({ebitda_c/caso['receita']:.1%}) | EBIT {ebit_c} | LAIR {lair_c} | LL {ll_c:.1f}")
print(f"Ativo {ativo_c} = Passivo+PL {passivo_c}: {'OK, o balanço fecha' if ativo_c == passivo_c else 'ERRO'}")
```

=== 18.2. Diagnóstico: liquidez, endividamento, rentabilidade e DuPont
<diagnóstico-liquidez-endividamento-rentabilidade-e-dupont>
```python
ac_c = caso["caixa"] + caso["receber"] + caso["estoques"]
pc_c = caso["fornec"] + caso["div_cp"]
print(f"Liquidez corrente {ac_c/pc_c:.2f} | seca {(ac_c - caso['estoques'])/pc_c:.2f} | imediata {caso['caixa']/pc_c:.2f}")
print(f"Dívida líquida {divida_c - caso['caixa']} | DL/EBITDA {(divida_c - caso['caixa'])/ebitda_c:.2f}x | cobertura de juros (EBIT/desp. fin.) {ebit_c/caso['desp_fin']:.2f}x")
print(f"Dívida/PL {divida_c/caso['pl']:.2f} | passivo exigível/ativo {(ativo_c - caso['pl'])/ativo_c:.1%}")

nopat_c = ebit_c * (1 - caso["ir"])
capital_inv = divida_c - caso["caixa"] + caso["pl"]
print(f"NOPAT {nopat_c:.1f} | capital investido {capital_inv} | ROIC {nopat_c/capital_inv:.2%} | ROE {ll_c/caso['pl']:.2%} | ROA {ll_c/ativo_c:.2%}")

dupont_c = [("Carga tributária", ll_c / lair_c), ("Carga de juros", lair_c / ebit_c), ("Margem EBIT", ebit_c / caso["receita"]),
            ("Giro do ativo", caso["receita"] / ativo_c), ("Alavancagem", ativo_c / caso["pl"])]
print("DuPont:", " × ".join(f"{n}: {v:.3f}" for n, v in dupont_c), f"= ROE {np.prod([v for _, v in dupont_c]):.2%}")

pme_a = caso["estoques"] / caso["cpv"] * 360
pmr_a = caso["receber"] / caso["receita"] * 360
pmp_a = caso["fornec"] / caso["cpv"] * 360
print(f"PME {pme_a:.0f} d | PMR {pmr_a:.0f} d | PMP {pmp_a:.0f} d | ciclo financeiro {pme_a + pmr_a - pmp_a:.0f} dias")
```

=== 18.3. Custo de capital
<custo-de-capital-alfa>
```python
ke_c = caso["rf"] + caso["beta"] * caso["premio"]
e_c = caso["acoes"] * caso["preco"]
v_c = e_c + divida_c
kd_liq_c = caso["kd_bruto"] * (1 - caso["ir"])
wacc_c = e_c / v_c * ke_c + divida_c / v_c * kd_liq_c
print(f"Ke (CAPM) {ke_c:.2%} | valor de mercado do PL R${e_c:,.0f} (pesos: PL {e_c/v_c:.1%}, dívida {divida_c/v_c:.1%})")
print(f"Kd líquido {kd_liq_c:.2%} | WACC {wacc_c:.2%}")
roic_c = nopat_c / capital_inv
print(f"Spread ROIC - WACC: {(roic_c - wacc_c)*100:+.2f} p.p. | EVA = R${capital_inv * (roic_c - wacc_c):,.1f} milhões/ano")
```

=== 18.4. Valuation por fluxo de caixa descontado
<valuation-por-fcd-alfa>
A empresa investe para crescer, e investir consome fluxo de caixa. Para manter
a coerência, o fluxo é derivado do #strong[crescimento e do retorno do
reinvestimento]: se o NOPAT cresce a uma taxa $g$ com retorno $"RONIC"$ sobre o novo capital, a
fração do NOPAT reinvestida é $g/"RONIC"$ e $"FCFF" = "NOPAT" (1 - g/"RONIC")$. Projetamos
cinco anos de crescimento de 8% com RONIC de 20% (40% do NOPAT reinvestido) e, depois,
crescimento perpétuo de 3,5% com RONIC terminal de 16% (21,9% reinvestido).

```python
g_exp, ronic_exp, g_term, ronic_term = 0.08, 0.20, 0.035, 0.16
nopat_proj = [nopat_c * (1 + g_exp) ** t for t in range(1, 6)]
fcff_proj = [n * (1 - g_exp / ronic_exp) for n in nopat_proj]
nopat_6 = nopat_proj[-1] * (1 + g_term)
fcff_6 = nopat_6 * (1 - g_term / ronic_term)
vt_c = fcff_6 / (wacc_c - g_term)
vp_fcff = sum(f / (1 + wacc_c) ** (t + 1) for t, f in enumerate(fcff_proj))
vp_vt_c = vt_c / (1 + wacc_c) ** 5
ev_c = vp_fcff + vp_vt_c
equity_c = ev_c - (divida_c - caso["caixa"])
print("FCFF projetados:", [f"{f:.1f}" for f in fcff_proj])
print(f"VP dos FCFF R${vp_fcff:,.1f} | VP do valor terminal R${vp_vt_c:,.1f} ({vp_vt_c/ev_c:.1%} do EV)")
print(f"EV R${ev_c:,.1f} | dívida líquida R${divida_c - caso['caixa']} | equity R${equity_c:,.1f}")
print(f"Preço justo por ação: R${equity_c / caso['acoes']:.2f} vs. mercado R${caso['preco']:.2f} ({equity_c / caso['acoes'] / caso['preco'] - 1:+.1%})")

print("\nPreço justo por ação (R$) variando o WACC e o crescimento terminal:")
gs_c = [0.025, 0.030, 0.035, 0.040, 0.045]
print(f"{'WACC':>7} " + " ".join(f"{g_*100:>7.1f}%" for g_ in gs_c))
for w_off in (-0.015, -0.0075, 0.0, 0.0075, 0.015):
    w_ = wacc_c + w_off
    linha = []
    for g_ in gs_c:
        f6 = nopat_proj[-1] * (1 + g_) * (1 - g_ / ronic_term)
        ev_ = sum(f / (1 + w_) ** (t + 1) for t, f in enumerate(fcff_proj)) + f6 / (w_ - g_) / (1 + w_) ** 5
        linha.append((ev_ - (divida_c - caso["caixa"])) / caso["acoes"])
    print(f"{w_:>7.2%} " + " ".join(f"{p:>8.2f}" for p in linha))
```

=== 18.5. Validação por múltiplos
<validação-por-múltiplos-alfa>
```python
lpa_c = ll_c / caso["acoes"]
ev_mercado = e_c + divida_c - caso["caixa"]
print(f"LPA R${lpa_c:.2f} | P/L de mercado {caso['preco'] / lpa_c:.1f}x | EV/EBITDA de mercado {ev_mercado / ebitda_c:.2f}x | P/VP {e_c / caso['pl']:.2f}x")
print(f"Pelo FCD: EV/EBITDA implícito {ev_c / ebitda_c:.2f}x | P/L implícito {equity_c / ll_c:.1f}x")
for nome_m, mult_m in (("EV/EBITDA setorial 6,0x", 6.0), ("EV/EBITDA setorial 7,0x", 7.0)):
    preco_m = (mult_m * ebitda_c - (divida_c - caso["caixa"])) / caso["acoes"]
    print(f"{nome_m}: preço justo R${preco_m:.2f}")
```

#strong[FCD reverso: o que o mercado "precifica"?] Em vez de perguntar "quanto vale?", pergunta-se
"#emph[que premissa] justificaria o preço de R\$ 22,00?". Primeiro testamos o #strong[crescimento]; depois a
#strong[taxa de desconto]:

```python
def preco_fcd_alfa(g_cinco, wacc_a=wacc_c, ronic_a=0.20, g_t=0.035, ronic_t=0.16):
    nopat_a = [nopat_c * (1 + g_cinco) ** t for t in range(1, 6)]
    fcff_a = [n * (1 - g_cinco / ronic_a) for n in nopat_a]
    f6_a = nopat_a[-1] * (1 + g_t) * (1 - g_t / ronic_t)
    ev_a = sum(f / (1 + wacc_a) ** (t + 1) for t, f in enumerate(fcff_a)) + f6_a / (wacc_a - g_t) / (1 + wacc_a) ** 5
    return (ev_a - (divida_c - caso["caixa"])) / caso["acoes"]

def bisseccao(funcao, baixo, alto, passos=200):
    for _ in range(passos):
        meio = (baixo + alto) / 2
        if funcao(baixo) * funcao(meio) > 0:
            baixo = meio
        else:
            alto = meio
    return (baixo + alto) / 2

for g_teste in (0.05, 0.08, 0.12, 0.16):
    print(f"Crescimento de {g_teste:.0%} ao ano por 5 anos -> preço justo R${preco_fcd_alfa(g_teste):.2f}")
wacc_impl = bisseccao(lambda w_: preco_fcd_alfa(0.08, wacc_a=w_) - caso["preco"], 0.08, wacc_c)
print(f"WACC que iguala o FCD ao preço de mercado (g = 8%): {wacc_impl:.2%} (vs. {wacc_c:.2%} calculado)")
```

=== 18.6. Veredito
<veredito-alfa>
#strong[1. A empresa é saudável.] O balanço fecha; a margem EBITDA é de 25%. Liquidez
corrente de 2,60 (seca de 1,72), dívida líquida de apenas 1,0x o EBITDA e cobertura de
juros de 5,0x: bem abaixo de covenants típicos, com folga para se endividar mais.

#strong[2. Cria valor.] O ROIC de 20,0% supera o WACC de 14,91% em 5,1 pontos
percentuais, o que significa um #strong[EVA de R\$ 67 milhões por ano]. O ROE de 25,8% é o ROIC mais
um pouco de alavancagem. O DuPont mostra de onde vem o retorno: margem EBIT de 20% (o ponto
forte), giro de 1,29x e alavancagem moderada de 1,89x; a carga tributária (0,66) e os juros
(0,80) consomem o resto.

#strong[3. Há oportunidade no capital de giro.] O ciclo financeiro é de 86 dias.
Cada 10 dias a menos no prazo de recebimento liberam cerca de R\$ 56 milhões
($2.000/360 times 10$) --- um ganho de aproximadamente R\$ 8 milhões por ano ao custo de
capital de 14,9%, sem vender nada a mais.

#strong[4. O FCD dá R\$ 15,32 por ação, 30% abaixo do mercado.] O valor terminal
responde por 67,5% do EV. Duas leituras importantes da tabela de sensibilidade:
(i) o valor é #strong[pouco sensível ao crescimento terminal] --- como o retorno do
reinvestimento terminal (16%) está próximo do WACC (14,9%), #emph[crescer cria pouco valor]:
ao passar o crescimento de 5 para 16% ao ano nos cinco primeiros anos, o preço sobe de
R\$ 14,53 para R\$ 17,32; (ii) é #strong[muito sensível ao WACC]: cada 0,75 ponto
percentual a mais ou a menos mexe no preço em cerca de R\$ 1,5 a 1,7 (aproximadamente 10%).
A lição reforça o capítulo 1: crescer só cria valor se o retorno sobre o novo capital supera o
custo de capital por uma margem relevante.

#strong[5. Os múltiplos contam outra história.] O mercado negocia a Alfa a 5,40x
EV/EBITDA e a 10,4x o lucro. Múltiplos setoriais de 6x a 7x o EBITDA indicariam R\$ 25 a R\$ 30
por ação; o FCD de base equivale a apenas 4,06x EBITDA.

#strong[6. Reconciliando.] As duas abordagens divergem (de R\$ 15 a R\$ 30), e a divergência
é informativa. Para o FCD igualar o preço de mercado, o WACC teria de ser 12,3% (e não
14,9%): o mercado usa uma taxa de desconto menor, ou espera retornos terminais e
margens maiores que as do nosso cenário-base. Um múltiplo setorial, por sua vez, "herda" as
premissas implícitas dos pares --- que podem estar caras.

#atencao[
  #strong["Boa empresa" não é o mesmo que "boa ação".] A Alfa cria valor (ROIC > WACC) e tem
  balanço sólido, mas a R\$ 22,00 o mercado já paga por premissas mais otimistas que as do
  cenário-base. A conclusão honesta é uma #strong[faixa], de cerca de R\$ 15 (FCD
  conservador) a R\$ 30 (múltiplos setoriais), e a decisão depende de qual premissa o analista
  considera mais crível --- não de um número único.
]

#resumo[
  - Uma análise completa integra: diagnóstico das demonstrações, retorno (ROIC × WACC, EVA, DuPont), custo de capital, FCD e múltiplos.
  - O valor terminal domina o FCD; a sensibilidade ao WACC é maior que ao crescimento quando o retorno do reinvestimento é próximo do WACC.
  - O FCD reverso (qual premissa justifica o preço?) é uma forma útil de ler o mercado.
  - O resultado é uma faixa de valor, não um número.
]
%%% END
