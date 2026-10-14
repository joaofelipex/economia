%%% BEFORE: === 7.2. Taxa Interna de Retorno (TIR / IRR)
#teoria("por que o VPL é o critério central")[
  Quatro razões fazem do VPL o critério preferido na teoria financeira:

  + #strong[Mede riqueza criada, em reais de hoje.] Um VPL de R\$ 2.000
    significa que o projeto gera R\$ 2.000 de valor #emph[além] do que o
    capital renderia na melhor alternativa (a TMA).
  + #strong[Considera todos os fluxos], de todas as datas, sem ignorar nenhum.
  + #strong[Considera o valor do dinheiro no tempo] à taxa de oportunidade.
  + #strong[É aditivo:] $"VPL"(A + B) = "VPL"(A) + "VPL"(B)$. Isso permite
    avaliar projetos em pacote, ou isolar o efeito de uma decisão. A TIR
    #emph[não] é aditiva.

  A #strong[TMA] não é um número arbitrário: é o #strong[custo de
  oportunidade do capital] --- o retorno que se obteria em outro uso
  de risco comparável. Para empresas, costuma-se usar o WACC (apostila 07);
  para pessoas físicas, a melhor alternativa de investimento livre de
  esforço (por exemplo, o Tesouro Selic ou o CDI).
]

#exemplo("VPL na mão: Projeto A")[
  Investimento de R\$ 15.000 e entradas de R\$ 4.500 por 5 anos; TMA = 10% a.a.

  #fluxo("-15.000", "+4.500", "+4.500", "+4.500", "+4.500", "+4.500")

  Traga cada entrada a valor presente:

  #figure(
    align(center)[#table(
      columns: (12%, 30%, 34%),
      align: (center, right, right),
      table.header([Ano], [Cálculo], [Valor presente],),
      [1], [$4.500/1,10$], [4.090,91],
      [2], [$4.500/1,10^2$], [3.719,01],
      [3], [$4.500/1,10^3$], [3.380,92],
      [4], [$4.500/1,10^4$], [3.073,56],
      [5], [$4.500/1,10^5$], [2.794,15],
      [], [#strong[Soma]], [#strong[17.058,54]],
    )]
    , kind: table
    )

  $"VPL" = 17.058,54 - 15.000 = $ #strong[R\$ 2.058,54]. Atalho: como as
  entradas são uniformes, $"VP" = 4.500 dot a_(5|10%) = 4.500 times 3,79079
  = 17.058,54$. O VPL positivo indica que o projeto #strong[cria valor].
]

#atencao[
  #strong["VPL positivo" não significa "melhor projeto" automaticamente.]
  Para projetos #emph[independentes], aceitam-se todos com VPL > 0. Para
  projetos #emph[mutuamente excludentes] (só um pode ser escolhido), escolhe-se
  o de #strong[maior VPL]. Para projetos limitados por orçamento (racionamento de
  capital), veja o índice de lucratividade (seção 7.5).
]

%%% BEFORE: === 7.3. Limitações da TIR
#intuicao[
  A TIR é a #strong["taxa de juros própria" do projeto]: a rentabilidade
  anual média sobre o capital que permanece investido. Compare a TIR com o
  CET do Capítulo 5: o CET é, tecnicamente, a TIR do fluxo do tomador de
  crédito. Um projeto com TIR de 15% rende como uma aplicação que pagasse
  15% a.a. durante toda a vida do projeto.
]

#exemplo("achando a TIR por interpolação")[
  Para o Projeto A, procuramos a taxa que zera $4.500 dot a_(5|i) - 15.000$.
  Tentativas:

  - Com $i = 15%$: $"VPL" = +84,70$ (ainda positivo: a TIR é maior que 15%).
  - Com $i = 16%$: $"VPL" = -265,68$ (negativo: a TIR é menor que 16%).

  Interpolando linearmente: $"TIR" approx 15% + 84,70/(84,70 + 265,68)
  times 1% = 15,24%$. O resultado exato é #strong[15,2382%]. Como
  $15,24% > "TMA" = 10%$, o projeto é viável --- a mesma conclusão do VPL.
  Calculadoras e planilhas fazem exatamente esse refinamento por tentativas
  (Newton-Raphson ou bissecção), com muitas iterações.
]

#teoria("o método de Newton-Raphson")[
  Para resolver $f(i) = "VPL"(i) = 0$, parte-se de um palpite $i_0$ e
  melhora-se a estimativa usando a #strong[reta tangente] à curva do VPL:

  $ i_(k+1) = i_k - f(i_k)/(f'(i_k)) $

  com $f'(i) = - sum_(t=1)^n t dot "FC"_t/(1 + i)^(t+1)$. A convergência é
  rápida (quadrática) quando o palpite é razoável. Para fluxos
  convencionais (uma só troca de sinal), a curva do VPL é #strong[decrescente
  e convexa], o que favorece a convergência (com o cuidado de não sair do domínio $i > -1$).
]

%%% BEFORE: === 7.4. Payback Simples e Descontado
#exemplo("quando a TIR e o VPL discordam: escala")[
  TMA de 10%. Dois projetos mutuamente excludentes:

  - #strong[C:] investe R\$ 1.000 e recebe R\$ 1.300 em um ano: TIR de 30%,
    VPL $= 1.300/1,1 - 1.000 = $ R\$ 181,82.
  - #strong[D:] investe R\$ 10.000 e recebe R\$ 11.800 em um ano: TIR de 18%,
    VPL $= 11.800/1,1 - 10.000 = $ R\$ 727,27.

  A TIR prefere C; o VPL prefere D. Quem tem razão? O VPL: com R\$ 10.000
  disponíveis, escolher C deixa R\$ 9.000 aplicados à TMA (VPL zero), e o
  total de valor criado é só R\$ 181,82. A TIR é uma #strong[taxa], e ignora a
  #strong[escala] do investimento.
]

#exemplo("TIR de dois valores: o fluxo não convencional")[
  Fluxo $(-1.000, +2.500, -1.500)$: investe-se, recebe-se e, no último ano, há
  um desembolso (por exemplo, descomissionamento). Escreva a TIR com
  $x = 1/(1 + "TIR")$: $-1.000 + 2.500 x - 1.500 x^2 = 0$, que simplifica para
  $3 x^2 - 5 x + 2 = 0$, com raízes $x = 1$ e $x = 2/3$. Ou seja:
  #strong[TIR = 0% e TIR = 50%] --- duas taxas, e nenhuma delas diz se o
  projeto é bom. O VPL ao longo de várias taxas mostra o que acontece:

  #table(
    columns: (20%, 20%, 20%, 20%, 20%),
    align: center,
    table.header([Taxa], [0%], [10%], [20%], [50%],),
    [VPL], [0,00], [33,06], [41,67], [0,00],
  )

  #v(0.3em)
  Entre 0% e 50% o VPL é positivo; fora desse intervalo é negativo. A regra
  "TIR > TMA" perde sentido: só o VPL (a uma TMA bem definida) decide.
]

```python
import numpy as np

fluxo_atipico = [-1000, 2500, -1500]
x_raizes = np.roots([-1500, 2500, -1000])          # em x = 1/(1+TIR)
print("TIRs encontradas:", sorted(f"{round((1 / x - 1) * 100, 1) + 0:.1f}%" for x in x_raizes))
print(f"VPL a 10%: R${vpl(0.10, fluxo_atipico):.2f}")
print(f"MTIR de A reinvestindo a 10%: {mtir(fluxos_a, 0.10)*100:.2f}% | a 6%: {mtir(fluxos_a, 0.06)*100:.2f}% | TIR: {tir_a*100:.2f}%")
```

#exemplo("o cruzamento de Fisher: Projetos A e B")[
  Ao variar a taxa de desconto, os VPLs dos Projetos A e B (seção 7.1) variam
  de modo diferente. Entre 0% e cerca de 5,4% o Projeto A tem VPL maior; a
  partir daí, o B. A taxa em que as curvas se cruzam é a #strong[taxa de
  Fisher] (não confundir com a equação de Fisher do Capítulo 6): aqui, 5,37%.
  Como a TMA é 10% --- acima do cruzamento ---, o projeto B é o melhor.
  Observe também as TIRs: A, 15,24%; B, 17,57%.
]

```python
taxas_perfil = np.linspace(0, 0.25, 200)
curva_a = [vpl(t, fluxos_a) for t in taxas_perfil]
curva_b = [vpl(t, fluxos_b) for t in taxas_perfil]
taxa_fisher = bisseccao(lambda r: vpl(r, fluxos_a) - vpl(r, fluxos_b), 1e-6, 0.5)

plt.figure(figsize=(9, 4.6))
plt.plot(taxas_perfil * 100, curva_a, label="Projeto A", color="#c0392b", linewidth=2)
plt.plot(taxas_perfil * 100, curva_b, label="Projeto B", color="#1d4f91", linewidth=2)
plt.axhline(0, color="gray", linewidth=0.8)
plt.axvline(taxa_fisher * 100, color="purple", linestyle="--", linewidth=1)
plt.annotate(f"Cruzamento (Fisher)\n{taxa_fisher*100:.2f}%", (taxa_fisher * 100, vpl(taxa_fisher, fluxos_a)),
             textcoords="offset points", xytext=(12, 12), color="purple")
plt.scatter([tir_a * 100, tir_b * 100], [0, 0], color=["#c0392b", "#1d4f91"], zorder=5)
plt.annotate(f"TIR A = {tir_a*100:.2f}%", (tir_a * 100, 0), textcoords="offset points", xytext=(-85, -26), color="#c0392b", arrowprops=dict(arrowstyle="-", color="#c0392b", lw=0.8))
plt.annotate(f"TIR B = {tir_b*100:.2f}%", (tir_b * 100, 0), textcoords="offset points", xytext=(14, 18), color="#1d4f91", arrowprops=dict(arrowstyle="-", color="#1d4f91", lw=0.8))
plt.axvline(10, color="gray", linestyle=":", linewidth=1)
plt.text(10.2, plt.ylim()[1] * 0.85, "TMA = 10%", color="gray")
plt.xlabel("Taxa de desconto (% a.a.)")
plt.ylabel("VPL (R$)")
plt.title("Perfil do VPL dos Projetos A e B")
plt.legend()
plt.grid(alpha=0.3)
plt.savefig("figuras06/perfil_vpl.png", dpi=170, bbox_inches="tight")
print(f"Taxa de Fisher (cruzamento): {taxa_fisher*100:.2f}%")
```

#figure(
  image("figuras06/perfil_vpl.png", width: 92%),
  caption: [Perfil do VPL: cada curva cruza o eixo na sua TIR; as curvas se cruzam na taxa de Fisher. À esquerda do cruzamento, A é preferível; à direita, B.],
)

%%% BEFORE: === 7.5. Índice de Lucratividade (IL)
#exemplo("payback na mão")[
  #strong[Payback simples do Projeto A.] Saldo acumulado dos fluxos:

  #figure(
    align(center)[#table(
      columns: (14%, 28%, 28%),
      align: (center, right, right),
      table.header([Ano], [Acumulado simples], [Acumulado descontado a 10%],),
      [0], [−15.000,00], [−15.000,00],
      [1], [−10.500,00], [−10.909,09],
      [2], [−6.000,00], [−7.190,08],
      [3], [−1.500,00], [−3.809,17],
      [4], [+3.000,00], [−735,61],
      [5], [+7.500,00], [+2.058,54],
    )]
    , kind: table
    )

  Simples: o saldo vira positivo durante o ano 4. No início do ano 4 faltavam
  R\$ 1.500 e o fluxo do ano é R\$ 4.500; logo
  $"payback" = 3 + 1.500/4.500 = $ #strong[3,33 anos]. Descontado: o saldo
  só vira positivo no ano 5; faltavam R\$ 735,61 e o fluxo descontado do ano
  é R\$ 2.794,15, de modo que $"payback"_D = 4 + 735,61/2.794,15 =$
  #strong[4,26 anos]. O último valor acumulado descontado (+2.058,54) é o
  próprio VPL.
]

#atencao[
  #strong[Limitações do payback.] (1) Ignora tudo o que ocorre #emph[depois]
  da recuperação. (2) O simples ignora o valor do dinheiro no tempo. (3) Não
  mede criação de valor. É um indicador de #strong[liquidez e risco] (quanto
  tempo o capital fica exposto), não de rentabilidade. Veja dois projetos
  com o mesmo payback e destinos opostos:
]

```python
projeto_e = [-1000, 600, 400, 100, 100]
projeto_f = [-1000, 500, 500, 5000, 5000]
for nome_p, fl_p in (("E", projeto_e), ("F", projeto_f)):
    print(f"Projeto {nome_p}: payback = {payback(fl_p):.2f} anos | VPL a 10% = R${vpl(0.10, fl_p):,.2f}")
```

%%% BEFORE: === 7.6. VPLA --- Valor Presente Líquido Anualizado
#teoria("o IL e o racionamento de capital")[
  O índice de lucratividade se relaciona com o VPL por
  $"IL" = 1 + "VPL"/|"FC"_0|$. Por isso, o IL mede o #strong[VPL por real
  investido], e a regra "IL > 1" equivale a "VPL > 0".

  Quando o orçamento é limitado (#emph[racionamento de capital]), a
  seleção ótima maximiza o VPL #strong[total] dentro do orçamento, e o IL
  ajuda a ordenar os projetos --- embora, com projetos indivisíveis, seja
  preciso comparar as combinações possíveis.
]

#exemplo("IL de A e B e a escolha com orçamento limitado")[
  $"IL"_A = 17.058,54/15.000 = 1,1372$; $"IL"_B = 14.404,99/12.000 = 1,2004$.
  O B rende mais VPL por real investido (R\$ 0,20 contra R\$ 0,14).

  Se o orçamento fosse de R\$ 15.000, só um dos dois caberia: A (VPL de
  R\$ 2.058,54, usando todo o orçamento) ou B (VPL de R\$ 2.404,99, e R\$
  3.000 sobrando, que podem ser aplicados à TMA com VPL zero). A
  melhor escolha é o #strong[B]. Com orçamento de R\$ 27.000, os dois
  cabem, e a soma dos VPLs é R\$ 4.463,53 (aditividade).
]

%%% BEFORE: === 7.7. Análise de Sensibilidade
#teoria("o problema dos prazos diferentes")[
  Comparar VPLs de projetos com vidas diferentes é injusto: um projeto de
  5 anos "gasta" mais tempo do capital que um de 3 anos. A solução usual
  é supor que o projeto será #strong[repetido indefinidamente]
  (cadeia de reposição). O VPL da cadeia infinita é

  $ "VPL"_infinity = "VPL" dot 1/(1 - (1 + i)^(-n)) $

  e o VPLA é simplesmente a prestação perpétua equivalente:
  $"VPLA" = "VPL"_infinity dot i$. Para os projetos X (3 anos, VPL de
  R\$ 10.000) e Y (5 anos, VPL de R\$ 14.000), a 10% a.a.:
  $"VPL"_infinity(X) = $ R\$ 40.211,48 e
  $"VPL"_infinity(Y) = $ R\$ 36.931,65. Apesar do VPL menor, o #strong[X é
  melhor]: gera mais valor por unidade de tempo. A hipótese de repetição é
  forte --- só faz sentido se for razoável replicar o projeto nas mesmas
  condições.
]

%%% BEFORE_CHAPTER_END: == Capítulo 8 --- Tabela Resumo de Fórmulas
#intuicao[
  A análise de sensibilidade responde: #strong[qual premissa, se estiver
  errada, mais prejudica a decisão?] Variam-se as hipóteses uma de cada vez
  e observa-se o efeito no VPL; as que movem mais o resultado merecem mais
  esforço de estimação (e mais cautela).
]

#exemplo("lendo a tabela de sensibilidade do Projeto A")[
  Na tabela impressa acima (variações de ±15% e ±30%):

  - #strong[Investimento:] o VPL fica negativo se o investimento exceder
    15.000 em mais de 13,7%: o limite é $17.058,54$ (o VP das entradas).
  - #strong[Receita anual:] é a variável mais sensível. Uma queda de 15% já
    leva o VPL a −R\$ 500; o #strong[ponto de equilíbrio] está em
    $15.000/3,79079 = $ R\$ 3.956,96 por ano, 12,07% abaixo do previsto.
  - #strong[TMA:] a menos sensível dentro desse intervalo; mesmo com TMA 30% maior
    (13% a.a.), o VPL continua positivo (R\$ 828).
]

```python
cenarios_ex = {
    "Pessimista": dict(inv=16500, receita=3900, taxa=0.12),
    "Base":       dict(inv=15000, receita=4500, taxa=0.10),
    "Otimista":   dict(inv=13500, receita=5000, taxa=0.09),
}
for nome_c, c in cenarios_ex.items():
    fl_c = [-c["inv"]] + [c["receita"]] * 5
    print(f"{nome_c:<11} VPL = R${vpl(c['taxa'], fl_c):>9,.2f}")

fator_a5 = (1 - 1.10 ** -5) / 0.10
print(f"Receita mínima (VPL = 0): R${15000 / fator_a5:,.2f} ({15000 / fator_a5 / 4500 - 1:.2%})")
```

#mercado[
  Na prática profissional, a sensibilidade de uma variável por vez é só o
  começo. Os próximos passos são a #strong[análise de cenários] (conjuntos
  coerentes de premissas, como no código acima), o #strong[gráfico de
  tornado] (variáveis ordenadas pelo impacto no VPL) e a #strong[simulação de Monte Carlo]
  (distribuições de probabilidade para as variáveis incertas, gerando
  uma distribuição de VPLs).
]

#resumo[
  - $"VPL" = sum "FC"_t/(1 + "TMA")^t$: valor criado em reais de hoje;
    decisão: VPL > 0. É #strong[aditivo] e é o critério soberano para projetos
    excludentes.
  - $"TIR"$: taxa que zera o VPL. Calcula-se por tentativas. Problemas:
    múltiplas raízes em fluxos não convencionais; ignora escala; presume
    reinvestimento à própria TIR (a MTIR corrige).
  - Payback: tempo de recuperação; mede liquidez, não valor. O descontado
    considera a TMA, e termina exatamente onde o VPL acumulado fica positivo.
  - $"IL" = 1 + "VPL"/|"FC"_0|$: útil sob racionamento de capital.
  - VPLA: compara projetos de prazos diferentes (hipótese de repetição).
  - Sensibilidade e cenários mostram #strong[quais premissas importam].
]
%%% END
