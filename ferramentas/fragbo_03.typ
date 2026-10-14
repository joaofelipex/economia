%%% BEFORE: == 5.3 Consultas SQL
#exemplo("a conciliação completa, com classificação automática da causa")[
  O código reproduz as cinco divergências típicas da seção 2.3 (quantidade a mais, a menos, ativo ausente), mas agora
  em pandas, com uma #strong[primeira triagem automática] da causa provável a partir da razão entre as quantidades. A triagem
  é uma #emph[hipótese]: o analista confirma consultando o custodiante.
]

```python
sis = pd.DataFrame({"conta": ["001", "001", "002", "002", "003", "003"],
                    "ativo": ["PETR4", "ITUB4", "VALE3", "BBDC4", "WEGE3", "MGLU3"],
                    "qtd": [1000, 500, 300, 800, 200, 1000]})
cus = pd.DataFrame({"conta": ["001", "001", "002", "002", "003", "003", "003"],
                    "ativo": ["PETR4", "ITUB4", "VALE3", "BBDC4", "WEGE3", "MGLU3", "PRIO3"],
                    "qtd": [1000, 550, 300, 400, 200, 1040, 50]})
conc = sis.merge(cus, on=["conta", "ativo"], how="outer", suffixes=("_sis", "_cust"), indicator=True)
conc["dif_qtd"] = conc["qtd_cust"].fillna(0) - conc["qtd_sis"].fillna(0)

def triagem(linha):
    if linha["_merge"] == "right_only":
        return "Só no custodiante: aplicação direta/não lançado"
    if linha["_merge"] == "left_only":
        return "Só no sistema: baixa não refletida?"
    razao = linha["qtd_cust"] / linha["qtd_sis"]
    if abs(razao - 1.10) < 1e-9:
        return "Razão 1,10: bonificação 10% não lançada"
    if abs(razao - 0.5) < 1e-9:
        return "Razão 0,5: grupamento 2:1 não lançado"
    if abs(razao - 2.0) < 1e-9:
        return "Razão 2,0: desdobramento não lançado"
    return "Diferença pequena: possível D+2 (timing)"

diverg = conc[conc["dif_qtd"] != 0].copy()
diverg["causa_provavel"] = diverg.apply(triagem, axis=1)
print(f"Linhas conciliadas: {len(conc)} | com divergência: {len(diverg)}")
print(diverg[["conta", "ativo", "qtd_sis", "qtd_cust", "dif_qtd", "causa_provavel"]]
      .rename(columns={"qtd_sis": "sis", "qtd_cust": "custódia", "dif_qtd": "dif", "causa_provavel": "causa provável"}).to_string(index=False))
```

%%% BEFORE: == 5.4 Aplicação de IA em processos financeiros
#exemplo("rodando as consultas da seção em um banco de verdade (SQLite em memória)")[
  O módulo `sqlite3` do Python permite treinar SQL sem instalar nada. As duas consultas da seção, com
  dados pequenos para conferir a lógica à mão:
]

```python
import sqlite3
con = sqlite3.connect(":memory:")
con.executescript("""
CREATE TABLE clientes (id INTEGER PRIMARY KEY, nome TEXT);
CREATE TABLE posicoes (cliente_id INTEGER, ativo TEXT, quantidade REAL, preco REAL, data_base TEXT, valor REAL);
INSERT INTO clientes VALUES (1, 'Ana'), (2, 'Bruno'), (3, 'Carla');
INSERT INTO posicoes VALUES
 (1, 'PETR4', 1000, 38.0, '2026-09-30', 38000), (1, 'TESOURO', 1, 62000, '2026-09-30', 62000),
 (2, 'CRI X', 1, 420000, '2026-09-30', 420000), (2, 'TESOURO', 1, 300000, '2026-09-30', 300000),
 (2, 'ITUB4', 2000, 140, '2026-09-30', 280000),
 (3, 'VALE3', 500, 60, '2026-09-30', 30000), (3, 'TESOURO', 1, 70000, '2026-09-30', 70000);
""")
q1 = """SELECT c.nome, SUM(p.quantidade * p.preco) AS patrimonio
        FROM posicoes p JOIN clientes c ON c.id = p.cliente_id
        WHERE p.data_base = '2026-09-30' GROUP BY c.nome ORDER BY patrimonio DESC"""
q2 = """SELECT cliente_id, ativo, ROUND(peso, 3) AS peso FROM (
          SELECT cliente_id, ativo, valor / SUM(valor) OVER (PARTITION BY cliente_id) AS peso
          FROM posicoes WHERE data_base = '2026-09-30') t WHERE peso > 0.30"""
print("Patrimônio por cliente:")
print(pd.read_sql_query(q1, con).to_string(index=False))
print("\nPosições com mais de 30% do patrimônio do cliente:")
print(pd.read_sql_query(q2, con).to_string(index=False))
```

#intuicao[
  A função de janela `SUM(valor) OVER (PARTITION BY cliente_id)` calcula o total #emph[de cada cliente] #strong[sem
  colapsar as linhas], o que permite dividir cada posição pelo total do seu cliente numa única consulta. Compare com
  `GROUP BY`, que devolve uma linha por grupo.
]

%%% BEFORE: == 5.5 Validação, segurança e controle de erros
#exemplo("validando a saída de uma IA que extrai dados de um documento")[
  Ao pedir à IA que extraia campos de uma lâmina de fundo em formato estruturado (JSON), o back office não
  confia: #strong[valida] cada campo antes de usá-lo. Abaixo, uma resposta correta e uma com erro
  de unidade (taxa de 80 em vez de 0,8):
]

```python
import json
def validar_extracao(texto_json):
    erros = []
    try:
        d = json.loads(texto_json)
    except json.JSONDecodeError as e:
        return [f"JSON inválido: {e.msg}"]
    for campo in ("fundo", "taxa_adm_aa", "prazo_resgate_dias", "perfil"):
        if campo not in d:
            erros.append(f"campo ausente: {campo}")
    if "taxa_adm_aa" in d and not (0 <= d["taxa_adm_aa"] <= 5):
        erros.append(f"taxa de administração implausível: {d['taxa_adm_aa']}% a.a.")
    if "prazo_resgate_dias" in d and not isinstance(d["prazo_resgate_dias"], int):
        erros.append("prazo de resgate não é inteiro")
    if d.get("perfil") not in ("conservador", "moderado", "arrojado", None):
        erros.append(f"perfil desconhecido: {d.get('perfil')}")
    return erros

resposta_ok = '{"fundo": "Alfa RF", "taxa_adm_aa": 0.8, "prazo_resgate_dias": 30, "perfil": "moderado"}'
resposta_ruim = '{"fundo": "Alfa RF", "taxa_adm_aa": 80, "prazo_resgate_dias": "trinta"}'
for nome_r, r_ in (("resposta correta", resposta_ok), ("resposta com erro", resposta_ruim), ("não é JSON", "taxa: 0,8")):
    e_ = validar_extracao(r_)
    print(f"{nome_r}: {'OK' if not e_ else 'REJEITADA -> ' + '; '.join(e_)}")
```

#atencao[
  Validar #strong[formato] não basta: uma taxa plausível (0,8%) pode estar #emph[errada] mesmo assim. Para valores
  que vão ao cliente, a regra é #strong[conferir contra a fonte] (a lâmina) por amostragem ou integralmente.
]

%%% BEFORE: === Exercícios do Módulo 5
#exemplo("totais de controle e log em uma rotina mensal")[
  Toda etapa de uma rotina automatizada deve provar que #emph[não perdeu nem duplicou dados]. O padrão é comparar
  contagem de registros e soma de valores entre origem e destino, registrando o resultado:
]

```python
import logging, io
buffer_log = io.StringIO()
logging.basicConfig(stream=buffer_log, level=logging.INFO, format="%(levelname)s | %(message)s", force=True)

def checar_totais(origem, destino, coluna="valor", etapa=""):
    ok_cont = len(origem) == len(destino)
    ok_soma = abs(origem[coluna].sum() - destino[coluna].sum()) < 0.01
    nivel = logging.INFO if ok_cont and ok_soma else logging.ERROR
    logging.log(nivel, f"{etapa}: registros {len(origem)}->{len(destino)} | soma {origem[coluna].sum():,.2f}->{destino[coluna].sum():,.2f}")
    return ok_cont and ok_soma

origem_m = pd.DataFrame({"conta": list("ABCD"), "valor": [100.0, 250.5, 80.25, 40.0]})
tratada_m = origem_m.assign(valor=origem_m["valor"].round(2))
perdida_m = origem_m.iloc[:3]
checar_totais(origem_m, tratada_m, etapa="Etapa 1 (limpeza)")
checar_totais(origem_m, perdida_m, etapa="Etapa 2 (merge com cadastro)")
print(buffer_log.getvalue())
```

%%% BEFORE: == 6.2 Resolução de problemas de Back Office
#exemplo("Caso A resolvido: de 90 mil de diferença a zero")[
  O relatório mostra R\$ 2,40 milhões e o extrato do custodiante, R\$ 2,31 milhões. Seguindo o roteiro,
  a investigação ativo a ativo encontrou três causas que, somadas, explicam toda a diferença:
]

```python
causas_a = pd.DataFrame({
    "causa": ["Resgate de fundo já cotizado, não liquidado (D+1 do relatório)",
              "Dividendo creditado pelo custodiante, não lançado no sistema",
              "Preço de um CRI marcado em data diferente (D-1 no relatório)"],
    "tipo": ["Timing", "Falha de lançamento", "Fonte de preço"],
    "valor": [60_000, 18_000, 12_000],
})
diferenca_obs = 2_400_000 - 2_310_000
print(causas_a.to_string(index=False))
print(f"\nSoma das causas: R${causas_a['valor'].sum():,.0f} | diferença observada: R${diferenca_obs:,.0f} | resíduo: R${diferenca_obs - causas_a['valor'].sum():,.0f}")
print("Ações corretivas:", "lançar o dividendo; alinhar a data do preço do CRI; documentar o resgate como 'em trânsito'")
```

#exemplo("Caso B resolvido: o que propor para o cliente com 42% em um CRI")[
  Para um cliente moderado com R\$ 1,5 milhão e limite de 20% por emissor privado, o excesso é de R\$ 330 mil
  (cálculo da seção 4.4). O back office #strong[não decide]: prepara três opções para o assessor discutir ---
  (a) vender parte do CRI (se houver liquidez; o mercado secundário pode exigir deságio); (b) direcionar novos aportes para
  classes subponderadas até o peso cair; (c) manter com justificativa formal documentada e reavaliação periódica.
  Material de apoio: concentração por emissor, vencimento e liquidez do papel, e o perfil registrado do cliente.
]

#exemplo("Caso C resolvido: o retorno da automação em horas")[
  Cinco arquivos de 40 minutos de tratamento manual por mês consomem 3h20; com Power Query, a atualização
  leva cerca de 10 minutos. Se o desenvolvimento da rotina custou 12 horas, o #strong[ponto de equilíbrio]
  é $12/(3,33 - 0,17) approx 3,8$ meses --- e a economia seguinte (cerca de 3 horas por mês) vem
  com #strong[menos erro manual], o ganho que mais importa. Meça o tempo antes e depois: é o número que se mostra ao gestor.
]

```python
horas_antes, horas_depois, horas_dev = 5 * 40 / 60, 10 / 60, 12
economia_mes = horas_antes - horas_depois
print(f"Antes: {horas_antes:.2f} h/mês | depois: {horas_depois:.2f} h/mês | economia: {economia_mes:.2f} h/mês")
print(f"Ponto de equilíbrio do desenvolvimento ({horas_dev} h): {horas_dev / economia_mes:.1f} meses | economia em 12 meses: {economia_mes * 12 - horas_dev:.1f} h líquidas")
```

%%% BEFORE: == 6.3 Apresentação de soluções técnicas
#teoria("os cinco porquês: da falha ao controle")[
  Para encontrar a #strong[causa raiz] de um problema recorrente, pergunte "por quê?" repetidamente até
  chegar a algo que o processo pode controlar. Aplicado ao Caso C (relatório sempre atrasado):

  + Por que o relatório atrasa? #emph[Porque o tratamento dos cinco arquivos é manual e longo.]
  + Por que é manual? #emph[Porque os arquivos chegam em layouts diferentes e ninguém padronizou.]
  + Por que não há padrão? #emph[Porque cada custodiante envia no seu formato e não existe uma etapa de normalização.]
  + Por que não existe a etapa? #emph[Porque o processo nunca foi mapeado.]
  + Por que não foi mapeado? #emph[Porque sempre foi tratado como "urgência do mês", sem dono.]

  A ação deixa de ser "trabalhar mais rápido" e passa a ser #strong[mapear o processo, nomear um responsável e
  automatizar a normalização] --- ataca a causa, não o sintoma.
]

#figure(
  align(center)[#table(
    columns: (30%, 35%, 35%),
    align: (left, left, left),
    table.header([Situação], [Prioridade], [Conduta],),
    [Erro em relatório já enviado ao cliente], [#strong[Alta]: impacto externo e de confiança], [Avisar o responsável, corrigir, reenviar com nota objetiva da causa],
    [Pedido de dois assessores conflitantes], [Depende de impacto e prazo], [Alinhar com o gestor, explicar o critério, comunicar o prazo a ambos],
    [Melhoria de processo sem prazo], [Baixa no curto prazo], [Registrar, estimar o ganho e agendar],
  )]
  , kind: table
  )

%%% BEFORE: == 6.4 Entrevistas simuladas
#exemplo("uma apresentação de dois minutos (Contexto, Impacto, Solução, Resultado, Riscos)")[
  #emph["O relatório mensal do comitê dependia de cinco extratos tratados à mão, e a entrega atrasava em média dois
  dias (contexto). Isso reduzia o tempo do comitê para analisar e criava risco de erro de digitação (impacto). Mapeei
  o processo, criei uma consulta no Power Query que empilha e padroniza os arquivos, e uma aba de conciliação que
  compara os totais com o custodiante (solução). O tempo de preparo caiu de cerca de três horas para dez minutos, e
  as divergências passaram a ser detectadas antes do envio (resultado). Os riscos são a mudança de layout dos extratos
  --- o erro aparece na primeira etapa da consulta --- e a dependência de uma pessoa, mitigada com documentação e
  revisão por segunda pessoa (riscos). O próximo passo é automatizar a coleta dos arquivos (próximos passos)."]

  Observe a estrutura: um número em cada bloco, a causa do risco e o controle, e linguagem sem jargão.
]

%%% BEFORE: == 6.5 Comunicação profissional e vocabulário técnico
#exemplo("resposta SAR a uma pergunta comportamental")[
  #strong[Pergunta:] "Conte uma situação em que identificou um erro antes que causasse impacto."

  #emph[Situação:] "Ao conferir o relatório mensal antes do envio, a soma das posições por classe não batia com o total consolidado.
  Ação: em vez de ajustar o total, rastreei a diferença até um ativo duplicado vindo de dois extratos com nomes diferentes; corrigi o
  de-para de ativos e adicionei um teste automático de unicidade. Resultado: o relatório saiu correto, a diferença de R\$ 48 mil
  deixou de existir, e o teste passou a rodar todo mês. Aprendizado: o erro parecia 'arredondamento', mas era estrutural."

  Uma boa resposta SAR tem #strong[um fato específico], #strong[o que você fez] (não o que "a equipe" fez), um
  #strong[resultado mensurável] e o #strong[aprendizado].
]

%%% BEFORE: === Exercícios do Módulo 6
#exemplo("e-mail objetivo de comunicação de um erro")[
  ```text
  Assunto: Correção do relatório de setembro — Cliente Ana S. (ação necessária: nenhuma)

  Olá, [nome],

  Identifiquei um erro no relatório de setembro enviado ontem: o dividendo de R$ 1.100 de PETR4 não estava lançado,
  subestimando o patrimônio em R$ 1.100 (0,06%). A causa foi o provento ter sido creditado após o fechamento da
  base. Já corrigi e reenviei o relatório (anexo). Incluí uma checagem de proventos no fechamento para evitar repetição.

  Qualquer dúvida, estou à disposição.
  ```

  Quatro ingredientes: #strong[o que aconteceu], #strong[o impacto em número], #strong[a causa] e #strong[a prevenção], em tom
  cordial e sem culpar terceiros.
]

%%% BEFORE: == 7.2 Suitability como obrigação regulatória
#exemplo("quem responde a quê: um mapa de decisão")[
  #figure(
    align(center)[#table(
      columns: (40%, 30%, 30%),
      align: (left, left, left),
      table.header([Situação], [Quem decide/age], [Base],),
      [Cliente moderado quer produto arrojado], [Assessor registra; compliance avalia], [Suitability (RCVM 30)],
      [Cliente comum quer produto restrito a qualificados], [Instituição veda sem comprovar condição], [RCVM 21],
      [Movimentação incompatível com a renda], [Back office/compliance comunica ao COAF], [PLD-FT],
      [Posição divergente entre sistema e custodiante], [Back office investiga e corrige], [Controle operacional],
      [Cliente pede dados de outro cliente], [Recusa; registra o pedido], [Sigilo e LGPD],
    )]
    , kind: table
    )
]

%%% BEFORE: == 7.3 KYC, PLD-FT e COAF
#exemplo("relatório de exceção de suitability")[
  O back office cruza o perfil registrado de cada cliente com o risco dos produtos recomendados, listando as
  inadequações para o compliance. A regra do código é uma #emph[simplificação didática] das regras vistas na seção:
  (confirme a norma vigente):
]

```python
perfis = {"conservador": 1, "moderado": 2, "arrojado": 3}
recomendacoes = pd.DataFrame({
    "cliente": ["Ana", "Bruno", "Carla", "Diego"],
    "perfil": ["conservador", "moderado", "arrojado", "moderado"],
    "produto": ["Fundo de ações small caps", "COE de capital não protegido", "Fundo multimercado", "Tesouro IPCA+"],
    "risco_produto": [3, 3, 2, 1],
    "justificativa_formal": [False, True, False, False],
})
recomendacoes["nivel_perfil"] = recomendacoes["perfil"].map(perfis)
recomendacoes["acima_do_perfil"] = recomendacoes["risco_produto"] > recomendacoes["nivel_perfil"]
excecoes = recomendacoes[recomendacoes["acima_do_perfil"]].copy()
excecoes["situacao"] = np.where(excecoes["justificativa_formal"], "Acima do perfil, com justificativa registrada", "INADEQUADA: escalar ao compliance")
print(excecoes[["cliente", "perfil", "produto", "situacao"]].to_string(index=False))
```

%%% BEFORE: == 7.4 Cadastro e onboarding de clientes
#exemplo("sinais de alerta de PLD-FT como regras de monitoramento")[
  Sistemas de monitoramento transformam os "red flags" da seção em regras. O código ilustra duas (com limites #emph[hipotéticos],
  que na prática vêm da política da instituição) --- e lembra o princípio: a regra #strong[sinaliza], quem decide é o compliance:
]

```python
ops = pd.DataFrame({
    "cliente": ["Ana", "Bruno", "Carla", "Diego"],
    "renda": [30_000, 15_000, 50_000, 12_000],
    "aporte": [60_000, 400_000, 80_000, 11_000],
    "terceiros": [0.0, 0.7, 0.0, 0.0],
})
ops["aporte/renda"] = ops["aporte"] / ops["renda"]
ops["alerta_renda"] = ops["aporte/renda"] > 10                    # aporte > 10 meses de renda (limite hipotético)
ops["alerta_terc"] = ops["terceiros"] > 0.5                       # mais da metade via contas de terceiros
alertas = ops[ops["alerta_renda"] | ops["alerta_terc"]]
print(ops.round(2).to_string(index=False))
print(f"\nClientes sinalizados para análise do compliance: {', '.join(alertas['cliente'])}")
```

%%% BEFORE: == 7.5 Eventos corporativos em detalhe
#exemplo("checklist de onboarding com evidências")[
  #figure(
    align(center)[#table(
      columns: (30%, 35%, 35%),
      align: (left, left, left),
      table.header([Etapa], [Verificação], [Evidência arquivada],),
      [Identificação], [Documento válido e foto compatível], [Cópia do documento e data da conferência],
      [Origem dos recursos], [Compatível com renda e patrimônio], [Comprovantes e declaração],
      [Listas restritivas e PEP], [Consulta realizada], [Relatório da consulta com data],
      [Suitability], [Questionário respondido e perfil classificado], [Questionário assinado e perfil registrado],
      [Termos e contratos], [Assinados e arquivados], [Contrato e termos],
    )]
    , kind: table
    )
  O back office sustenta a #strong[trilha de auditoria]: para cada cliente ativo, é possível provar que cada etapa ocorreu, quando e por quem.
]

%%% BEFORE: == 7.6 Previdência: PGBL × VGBL
#exemplo("data-ex, JCP e direito de subscrição com números")[
  - #strong[Data-com e data-ex:] se a data-com é 15/10 (quinta-feira), a data-ex é 16/10. Quem comprou até 15/10 tem
    direito ao provento; quem comprou em 16/10 não tem. Quem #emph[vendeu] em 16/10 já tinha o direito e o recebe.
  - #strong[JCP (retenção ilustrativa de 15%):] um JCP bruto de R\$ 1.000 gera crédito líquido de R\$ 850 ao acionista pessoa
    física; o relatório deve mostrar o #emph[líquido] recebido e o bruto declarado (a retenção é de responsabilidade da companhia,
    e a alíquota pode mudar: confirme a vigente).
  - #strong[Direito de subscrição:] a companhia oferece 1 ação nova a R\$ 20,00 para cada 5 que o acionista possui, quando a ação
    vale R\$ 30,00. O #strong[preço teórico ex-direitos] é $(5 times 30 + 1 times 20)/6 = 28,33$ e o valor do direito é
    $30,00 - 28,33 = 1,67$ por ação. Quem não exerce nem vende o direito perde esse valor: é o que o back
    office acompanha nos prazos.
]

```python
data_com = np.datetime64("2026-10-15")
data_ex = np.busday_offset(data_com, 1, roll="forward")
jcp_bruto, retencao = 1000, 0.15
p_atual, p_sub, razao_n, razao_m = 30.0, 20.0, 5, 1
p_ex_dir = (razao_n * p_atual + razao_m * p_sub) / (razao_n + razao_m)
print(f"Data-com {data_com} | data-ex {data_ex}")
print(f"JCP: bruto R${jcp_bruto:,.2f} | retenção ilustrativa {retencao:.0%} | líquido R${jcp_bruto * (1 - retencao):,.2f}")
print(f"Preço teórico ex-direitos: R${p_ex_dir:.2f} | valor do direito: R${p_atual - p_ex_dir:.2f} por ação")
```

%%% BEFORE: == 7.7 Power BI e o mapa de ferramentas
#exemplo("PGBL × VGBL com números: um modelo simplificado")[
  Cliente com renda tributável de R\$ 300 mil/ano e alíquota marginal de 27,5% (declaração completa). Aporta 12% da renda
  (R\$ 36 mil) e deixa 12 anos a 8% ao ano; resgate no regime regressivo (10% após 10 anos). No #strong[PGBL], a
  contribuição reduz o IR em 27,5% × 36.000 = R\$ 9.900; supomos que a restituição seja investida em um fundo tributado a
  15% sobre o ganho. No #strong[VGBL] não há dedução, e o IR de 10% incide só sobre o rendimento.
]

```python
aporte_p, taxa_p, anos_p, aliq_resg, marginal = 36_000, 0.08, 12, 0.10, 0.275
fv_plano = aporte_p * (1 + taxa_p) ** anos_p
# PGBL: IR sobre o total resgatado; restituição reinvestida fora do plano (IR 15% sobre o ganho)
restituicao = aporte_p * marginal
fv_rest = restituicao * (1 + taxa_p) ** anos_p
liq_pgbl = fv_plano * (1 - aliq_resg) + fv_rest - (fv_rest - restituicao) * 0.15
# VGBL: IR só sobre o rendimento
liq_vgbl = fv_plano - (fv_plano - aporte_p) * aliq_resg
print(f"Valor do plano após {anos_p} anos: R${fv_plano:,.2f} (aporte de R${aporte_p:,.0f})")
print(f"PGBL: líquido do plano R${fv_plano * (1 - aliq_resg):,.2f} + restituição reinvestida líquida R${fv_rest - (fv_rest - restituicao) * 0.15:,.2f} = R${liq_pgbl:,.2f}")
print(f"VGBL: R${liq_vgbl:,.2f} | vantagem do PGBL: R${liq_pgbl - liq_vgbl:,.2f}")
```

#atencao[
  O resultado depende das #strong[premissas]: alíquota marginal, uso da restituição, prazo e regime tributário. Para quem
  declara pelo modelo simplificado, ou já usa o teto de dedução, a vantagem do PGBL desaparece. O exemplo existe para
  mostrar a #emph[lógica] (diferimento mais dedução) e não para recomendar um plano.
]

%%% BEFORE: == 7.8 Preparação específica para a reunião
#exemplo("medidas DAX: as mesmas contas de uma tabela dinâmica, como medidas")[
  No Power BI, cálculos viram #strong[medidas] sensíveis ao filtro do relatório (cliente, período, classe):

  ```dax
  Patrimônio = SUMX(Posicoes, Posicoes[Quantidade] * Posicoes[Preco])

  % da carteira =
      DIVIDE([Patrimônio], CALCULATE([Patrimônio], ALL(Ativos[Classe])))
  ```

  A primeira soma quantidade × preço no contexto atual; a segunda divide pelo total ignorando o filtro de classe, o que dá a composição
  (equivale ao "% do total" da tabela dinâmica). Se o usuário filtra um cliente, ambas recalculam sozinhas.
]

%%% BEFORE: === Exercícios do Módulo 7
#exemplo("\"me conte sobre você\" em 45 segundos")[
  #emph["Sou estudante de economia e venho construindo uma base de método para operações de investimentos: montei um banco de
  estudo com conciliação e relatórios em Excel e SQL, e treino automatizar rotinas com Python. Escolho back office de wealth
  porque o relatório correto é o produto que o cliente recebe, e eu gosto da parte em que o dado precisa estar certo.
  Trago método, curiosidade e disciplina de conferência. Aprendo rápido ferramentas novas."]

  Estrutura: #strong[quem sou] $arrow.r$ #strong[o que fiz] $arrow.r$ #strong[por que esta área] $arrow.r$ #strong[o que trago]. Adapte aos seus fatos reais; um
  exemplo ensaiado em voz alta soa natural, um texto lido soa decorado.
]

%%% APPEND: apendice
= Apêndice A --- Glossário ampliado

#table(
  columns: (auto, 1fr),
  table.header([Termo], [Significado]),
  [Alocação estratégica × tática], [Distribuição de longo prazo entre classes × desvios temporários para aproveitar cenários],
  [Atribuição de performance], [Decomposição do retorno nas contribuições de alocação e seleção],
  [Banda de rebalanceamento], [Desvio máximo tolerado em relação ao peso-alvo antes de reajustar],
  [Câmara de compensação], [Entidade que compensa e liquida operações entre os participantes (na B3)],
  [Conciliação], [Conferência de duas fontes que deveriam concordar, com classificação das divergências],
  [Custodiante], [Instituição que guarda os ativos em nome do investidor; fonte oficial da posição],
  [Data-com / data-ex], [Último dia com direito ao provento / primeiro dia sem o direito],
  [Drawdown], [Maior queda do pico ao vale em um período],
  [FGC], [Fundo Garantidor de Créditos: cobre parte dos depósitos e produtos bancários, dentro de limites],
  [HHI], [Índice de Herfindahl: soma dos pesos ao quadrado, mede concentração],
  [Inplit / grupamento], [Várias ações viram uma: a quantidade cai e o preço sobe pelo mesmo fator],
  [LGPD], [Lei Geral de Proteção de Dados Pessoais],
  [MWR], [Retorno ponderado pelo dinheiro (TIR do cliente)],
  [PEP], [Pessoa exposta politicamente],
  [PTAX], [Taxa de câmbio de referência calculada pelo Banco Central],
  [Rebalanceamento], [Retorno da carteira aos pesos-alvo],
  [Red flag], [Sinal de alerta de possível irregularidade (PLD-FT)],
  [SAR], [Situação, ação, resultado: técnica de resposta comportamental],
  [Split], [Uma ação vira várias: a quantidade sobe e o preço cai pelo mesmo fator],
  [Tracking error], [Desvio-padrão da diferença de retorno entre carteira e benchmark],
  [TWR], [Retorno ponderado pelo tempo (mede o gestor, ignora o timing dos aportes)],
  [Trilha de auditoria], [Registro que permite refazer o caminho do dado até a fonte],
  [VaR], [Perda máxima estimada em um horizonte e com um nível de confiança],
)
%%% END
