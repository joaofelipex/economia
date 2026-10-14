%%% BEFORE: == 1.2 Bancos, corretoras, gestoras e assessorias
#teoria("Selic, CDI e a transmissão da política monetária")[
  O Copom define a #strong[meta da Selic]. A taxa Selic "over" é a média
  das operações diárias entre instituições lastreadas em títulos públicos; o CDI,
  das operações interbancárias sem lastro, costuma ficar um pouco abaixo da meta
  (cerca de 0,10 ponto percentual). Quando o Copom #emph[sobe] a Selic, o custo de
  todo o crédito aumenta, o consumo e o investimento desaceleram, e a
  inflação tende a cair. Para o investidor, o efeito é duplo: títulos
  #strong[pós-fixados] passam a render mais, e títulos #strong[pré-fixados] já
  comprados #strong[perdem valor de mercado] (a taxa que o mercado exige subiu).
  Por isso a leitura da trajetória da Selic orienta a alocação entre
  pós, pré e inflação.
]

#exemplo("spread bancário")[
  Um banco capta em CDB a 100% do CDI (13,25% a.a.) e empresta a 22% a.a. O
  spread, em termos compostos, é $1,22/1,1325 - 1 = 7,73%$ ao ano (ou 8,75 pontos
  percentuais pela diferença simples). Esse é o #strong[spread bruto]: dele saem a
  inadimplência, os custos operacionais, os impostos e a remuneração do capital do
  banco. Quando um cliente pergunta "por que o banco paga 13% e cobra 22%?", essa
  é a resposta honesta --- e a razão de serviços de assessoria independente
  focarem no #emph[custo total] da relação com o sistema financeiro.
]

%%% BEFORE: == 1.3 O que é Wealth Management e Advisory
#exemplo("quem faz o quê numa compra de ações")[
  Acompanhe uma compra de 100 ações de um cliente:

  #figure(
    align(center)[#table(
      columns: (6%, 30%, 64%),
      align: (center, left, left),
      table.header([\#], [Quem], [O que faz],),
      [1], [Assessor], [Entende o perfil, recomenda a compra e registra a recomendação (suitability)],
      [2], [Cliente], [Autoriza a ordem],
      [3], [Corretora], [Envia a ordem ao mercado e a executa],
      [4], [B3], [Casa as ordens (negociação) e, com sua câmara, compensa e liquida a operação em D+2],
      [5], [Custodiante], [Registra as ações em nome do cliente; é a #strong[fonte oficial da posição]],
      [6], [Back Office], [Concilia a posição do sistema interno com o extrato do custodiante e consolida o patrimônio],
    )]
    , kind: table
    )

  Se o back office usar o #emph[relatório da assessoria] como fonte da posição, em vez do extrato do
  custodiante, a conciliação perde o sentido: não se concilia uma fonte consigo mesma.
]

%%% BEFORE: == 1.4 Produtos financeiros e classes de ativos
#teoria("fee fixo versus comissão: um problema de agência")[
  Quem aconselha um investimento pode ser remunerado de duas formas. Na
  #strong[comissão por produto], recebe uma fração do que o cliente aplica em cada
  produto, e o interesse do assessor pode divergir do do cliente (produtos com
  comissão maior, giro desnecessário da carteira). No #strong[fee]
  (honorário fixo ou percentual sobre o patrimônio acompanhado), a remuneração
  independe do produto escolhido, o que alinha melhor os interesses --- ainda que
  o fee percentual crie o incentivo a aumentar o patrimônio sob assessoria.
  Em ambos os modelos, a #strong[transparência] sobre o que é cobrado e a
  qualidade do relatório de acompanhamento são o que sustenta a confiança do
  cliente. Em um modelo de fee, "o relatório é o produto".
]

%%% BEFORE: == 1.5 Funcionamento de uma carteira de investimentos
#exemplo("CDB, LCI e imposto: qual rende mais em um ano?")[
  CDI de 13,25% a.a. e aplicação de 365 dias (alíquota regressiva de 17,5%, conforme a
  tabela acima): um CDB a 100% do CDI rende 13,25% bruto e
  $13,25% times (1 - 0,175) approx 10,93%$ líquido. Uma LCI a 90% do CDI, isenta de IR, rende
  cerca de $0,90 times 13,25% = 11,93%$ #strong[líquido]: a LCI "paga menos" na taxa
  anunciada, mas rende mais no bolso. O percentual do CDI que um CDB precisaria
  pagar para igualar a LCI é $0,90/(1 - 0,175) approx 109%$. #strong[A comparação deve
  ser sempre líquida] (e o FGC cobre ambos, dentro dos limites).
]

#exemplo("come-cotas: o imposto antecipado")[
  Um fundo de renda fixa de longo prazo rende 6,5% por semestre. O come-cotas cobra
  15% (alíquota mínima do longo prazo) sobre o rendimento de cada semestre,
  em maio e novembro, #emph[diminuindo o número de cotas]. Quem aplica em um CDB com
  o mesmo rendimento bruto paga IR só no final. O código compara os dois caminhos
  em três anos:
]

```python
capital_cc, rend_sem, aliq_cc, semestres = 100_000, 0.065, 0.15, 6
sem_cc = capital_cc * (1 + rend_sem) ** semestres
sem_cc_liquido = sem_cc - (sem_cc - capital_cc) * aliq_cc          # IR pago só no resgate (como num CDB)
com_cc = capital_cc * (1 + rend_sem * (1 - aliq_cc)) ** semestres  # IR descontado a cada semestre
print(f"IR só no final (CDB): R${sem_cc_liquido:,.2f} líquidos")
print(f"Com come-cotas (fundo): R${com_cc:,.2f} líquidos")
print(f"Diferença a favor do diferimento: R${sem_cc_liquido - com_cc:,.2f} ({(sem_cc_liquido / com_cc - 1):.2%})")
```

#intuicao[
  O come-cotas não aumenta a alíquota (no resgate, a alíquota final continua
  a mesma), mas #strong[antecipa o pagamento]: o imposto sai do investimento a cada
  semestre e deixa de render juros sobre juros. A vantagem do diferimento é
  pequena em três anos e cresce com o prazo e com a taxa.
]

%%% BEFORE: === Exercícios do Módulo 1
#exemplo("rebalanceando uma carteira de 2 milhões")[
  O perfil moderado do cliente define pesos-alvo e uma banda de tolerância de 5 pontos percentuais. O código
  calcula o desvio e o #emph[valor em reais] a comprar ou vender em cada classe:
]

```python
carteira = pd.DataFrame({
    "classe": ["RF pós-fixada", "RF inflação", "Ações", "Multimercado", "Exterior"],
    "valor": [840_000, 260_000, 560_000, 120_000, 220_000],
    "alvo": [0.35, 0.25, 0.20, 0.10, 0.10],
})
total_c = carteira["valor"].sum()
carteira["peso"] = carteira["valor"] / total_c
carteira["desvio_pp"] = (carteira["peso"] - carteira["alvo"]) * 100
carteira["ajuste_R$"] = carteira["alvo"] * total_c - carteira["valor"]
carteira["fora_da_banda"] = carteira["desvio_pp"].abs() > 5
pd.options.display.float_format = "{:,.2f}".format
print(carteira.round({"peso": 3}).to_string(index=False))
print(f"\nPatrimônio total: R${total_c:,.0f} | soma dos ajustes: R${carteira['ajuste_R$'].sum():,.0f} (deve ser zero)")
```

#atencao[
  Rebalancear tem #strong[custo]: impostos sobre ganhos realizados, taxas e spread de
  negociação. Por isso se usam #strong[bandas] (só ajusta-se quando o desvio passa de um limite)
  ou se direcionam #emph[novos aportes] às classes abaixo do alvo, em vez de vender
  as acima. O ajuste é uma recomendação para o assessor discutir, não uma ordem automática.
]

%%% BEFORE: == 2.2 Custódia e consolidação de carteiras
#exemplo("uma posição ao longo de eventos corporativos")[
  Um cliente tem 1.000 ações compradas a R\$ 30,00 (custo total de R\$ 30.000). Ocorrem:
  desdobramento de 2 para 1 e, depois, bonificação de 10%. #strong[O custo total não muda]
  (nenhum dinheiro entrou ou saiu); mudam a quantidade e o preço médio.
]

```python
qtd_e, custo_total_e = 1000, 30_000
print(f"Inicial      : {qtd_e:>6} ações | preço médio R${custo_total_e / qtd_e:.2f} | custo total R${custo_total_e:,.0f}")
qtd_e *= 2                                  # desdobramento 2:1 -> quantidade dobra, preço médio cai à metade
print(f"Após split   : {qtd_e:>6} ações | preço médio R${custo_total_e / qtd_e:.2f} | custo total R${custo_total_e:,.0f}")
qtd_e = qtd_e * 1.10                        # bonificação de 10% -> ações gratuitas
print(f"Após bonific.: {qtd_e:>6.0f} ações | preço médio R${custo_total_e / qtd_e:.2f} | custo total R${custo_total_e:,.0f}")
print(f"Dividendo de R$0,50/ação sobre {qtd_e:.0f} ações: R${qtd_e * 0.50:,.2f} em caixa (a quantidade não muda)")
```

%%% BEFORE: == 2.3 Liquidação e conciliação
#exemplo("consolidando duas custódias com nomes diferentes")[
  O mesmo ativo aparece com nomes diferentes em cada instituição, e há uma posição em dólar. O
  back office precisa de uma #strong[chave única] e de uma #strong[taxa de câmbio padronizada]:
]

```python
custodia_a = pd.DataFrame({"ativo": ["PETR4", "ITUB4", "TESOURO SELIC 2029"], "valor": [120_000, 80_000, 200_000], "moeda": "BRL"})
custodia_b = pd.DataFrame({"ativo": ["PETROBRAS PN", "ETF S&P500 (US$)"], "valor": [60_000, 25_000], "moeda": ["BRL", "USD"]})
de_para = {"PETROBRAS PN": "PETR4", "ETF S&P500 (US$)": "IVVB11-EXT"}      # chave única de ativo
classes = {"PETR4": "Ações", "ITUB4": "Ações", "TESOURO SELIC 2029": "Renda fixa", "IVVB11-EXT": "Exterior"}
ptax = 5.20                                                                  # câmbio padronizado, mesma data-base

base_c = pd.concat([custodia_a.assign(origem="A"), custodia_b.assign(origem="B")])
base_c["ativo"] = base_c["ativo"].replace(de_para)
base_c["valor_brl"] = base_c["valor"] * base_c["moeda"].map({"BRL": 1, "USD": ptax})
base_c["classe"] = base_c["ativo"].map(classes)
print(base_c[["origem", "ativo", "classe", "valor_brl"]].to_string(index=False))
print("\nConsolidado por classe (R$):")
print(base_c.groupby("classe")["valor_brl"].sum().to_string())
print(f"Total: R${base_c['valor_brl'].sum():,.2f} | PETR4 aparece em {base_c['ativo'].eq('PETR4').sum()} custódias (somadas: R${base_c.loc[base_c['ativo']=='PETR4', 'valor_brl'].sum():,.0f})")
```

#atencao[
  Sem o de-para, "PETR4" e "PETROBRAS PN" seriam tratados como ativos diferentes: a
  posição apareceria dividida, a concentração por emissor, subestimada, e a conciliação
  geraria uma "divergência" falsa. #strong[A qualidade da chave decide a qualidade do relatório.]
]

%%% BEFORE: == 2.4 Rentabilidade e acompanhamento patrimonial
#exemplo("liquidação em D+2 com feriado")[
  Compra de ações na sexta-feira, 30/10/2026. A liquidação é D+2 #emph[úteis]. Como
  segunda-feira, 02/11 (Finados), é feriado, a liquidação é na quarta-feira, 04/11.
  A data de liquidação define quando o caixa sai e quando a posição aparece no extrato do
  custodiante: conferir uma compra "recente" antes dela é a causa mais comum de
  divergência de timing.
]

```python
import numpy as np
compra = np.datetime64("2026-10-30")
liquidacao = np.busday_offset(compra, 2, roll="forward", holidays=["2026-11-02"])
print(f"Compra em {compra} -> liquidação D+2 útil em {liquidacao}")
print("Sem considerar o feriado:", np.busday_offset(compra, 2, roll="forward"))
```

#exemplo("cinco divergências típicas entre o sistema e o custodiante")[
  #figure(
    align(center)[#table(
      columns: (5%, 27%, 36%, 32%),
      align: (center, left, left, left),
      table.header([\#], [Sintoma], [Causa provável], [Tratamento],),
      [1], [Custodiante mostra 100 ações a menos], [Compra liquidando em D+2 (timing)], [Esperar a liquidação; registrar como "em trânsito"],
      [2], [Quantidade do custodiante é o dobro], [Desdobramento não lançado no sistema], [Ajustar a base e o histórico de preços],
      [3], [Custodiante tem 10% a mais], [Bonificação não lançada], [Lançar a bonificação e recalcular o preço médio],
      [4], [Valor difere centavos por cota], [Cota de fundo de datas diferentes], [Alinhar a data-base e a fonte do preço],
      [5], [Ativo existe no custodiante e não no sistema], [Aplicação feita direto pelo cliente], [Incluir, com origem documentada],
    )]
    , kind: table
    )

  O roteiro para qualquer divergência: #strong[(1)] mesma data-base; #strong[(2)] mesma chave; #strong[(3)]
  diferença de quantidade e depois de valor; #strong[(4)] classificar a causa; #strong[(5)] corrigir na
  origem; #strong[(6)] registrar. A seção 5.2 mostra esse roteiro em pandas.
]

%%% BEFORE: == 2.5 Qualidade e integridade das informações
#exemplo("TWR × MWR: o gestor foi bem, o cliente não")[
  Um cliente aplica R\$ 100 mil. No mês 1 a carteira rende +10%; o saldo vai a R\$ 110 mil e
  o cliente, animado, aporta mais R\$ 100 mil (saldo de R\$ 210 mil). No mês 2, o mercado cai e a
  carteira rende −5%, terminando em R\$ 199,5 mil.

  - #strong[TWR] (ignora o momento dos aportes): $(1,10)(0,95) - 1 = +4,50%$ --- é o desempenho
    da #emph[carteira], a medida justa do gestor.
  - #strong[MWR / TIR] (considera os fluxos do cliente): a taxa mensal que iguala
    $100 (1 + r)^2 + 100 (1 + r) = 199,5$ é $r approx -0,17%$ ao mês, ou cerca de
    #strong[−0,33%] em dois meses --- o #emph[cliente] terminou com perda, porque aportou
    mais #emph[antes] da queda.

  Os dois números estão corretos e respondem a perguntas diferentes: "o gestor
  investiu bem?" (TWR) e "como foi a minha experiência?" (MWR).
]

```python
fluxos_cli = [-100_000, -100_000, 199_500]          # t0: aporte, t1: aporte, t2: valor final
tir_mensal = np.roots([-fluxos_cli[0], -fluxos_cli[1], -fluxos_cli[2]])   # 100x² + 100x - 199,5 = 0 em x = 1 + r
x_ok = [x.real - 1 for x in tir_mensal if abs(x.imag) < 1e-12 and x.real > 0][0]
print(f"TWR (2 meses): {(1.10 * 0.95 - 1):+.2%}")
print(f"MWR (taxa mensal): {x_ok:+.3%} | em 2 meses: {(1 + x_ok) ** 2 - 1:+.3%}")
```

%%% BEFORE: === Exercícios do Módulo 2
#exemplo("verificações automáticas de qualidade de dados")[
  As seis dimensões de qualidade podem ser verificadas por regras simples. Veja uma base
  com problemas plantados e o relatório que o back office geraria:
]

```python
base_q = pd.DataFrame({
    "conta": ["001", "002", "002", "003", "004", "005"],
    "ativo": ["PETR4", "ITUB4", "ITUB4", "VALE3", None, "BBDC4"],
    "quantidade": [100, 200, 200, -50, 300, 150],
    "valor": [3000.0, 5000.0, 5000.0, 4500.0, 9000.0, np.nan],
    "data_base": pd.to_datetime(["2026-09-30"] * 5 + ["2026-09-29"]),
})
problemas = {
    "Completude (ativo nulo)": base_q["ativo"].isna().sum(),
    "Completude (valor nulo)": base_q["valor"].isna().sum(),
    "Unicidade (linhas duplicadas)": base_q.duplicated().sum(),
    "Exatidão (quantidade negativa)": (base_q["quantidade"] < 0).sum(),
    "Atualidade (data_base fora do esperado)": (base_q["data_base"] != "2026-09-30").sum(),
}
for nome_q, n_q in problemas.items():
    print(f"{'⚠' if n_q else '✓'} {nome_q}: {n_q}")
print(f"Registros analisados: {len(base_q)}")
```

%%% END
