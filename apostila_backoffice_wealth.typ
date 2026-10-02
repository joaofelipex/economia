// Apostila — Back Office Analítico e Wealth Advisory
// Versão estendida: conteúdo original (Módulos 1-6) + Módulo 7 (compliance,
// regulamentação, eventos corporativos, previdência e preparação para a reunião).
// Compilar: typst compile apostila_backoffice_wealth.typ

#set document(
  title: "Apostila — Back Office Analítico e Wealth Advisory",
  author: "Material de estudo",
)
#set page(paper: "a4", margin: (x: 2.2cm, y: 2.4cm), numbering: "1")
#set text(lang: "pt", size: 10.5pt)
#set par(justify: true)
#show heading.where(level: 1): it => pagebreak(weak: true) + it
#set table(stroke: 0.5pt, inset: 6pt)
#set list(indent: 1em, tight: false)
#set enum(indent: 1em, tight: false)

#align(center)[
  #v(4cm)
  #text(size: 24pt, weight: "bold")[Apostila]
  #v(0.2cm)
  #text(size: 16pt)[Back Office Analítico e Wealth Advisory]
  #v(0.6cm)
  #text(size: 11pt, fill: luma(100))[Sete módulos: do mercado financeiro à entrevista com o gestor]
  #v(0.3cm)
  #text(size: 9pt, fill: luma(120))[Versão estendida --- inclui o Módulo 7: compliance, regulamentação e preparação específica para a reunião]
]
#pagebreak()
#outline(title: [Sumário], depth: 2)

= Como usar esta apostila

Material de estudo organizado em sete módulos, do mercado financeiro à
preparação para a entrevista com o gestor. Cada módulo traz conceitos,
exemplos e exercícios. As regras de tributação, liquidação e
regulamentação citadas são referências didáticas: confirme sempre a norma
vigente antes de aplicar na prática ou de afirmar algo em entrevista.

- Estude um módulo por vez e resolva os exercícios ao final de cada um.
- Monte, ao longo do estudo, uma base fictícia de clientes e operações em Excel: ela será reaproveitada nos módulos 3, 4 e 5.
- Mantenha um glossário próprio. Vocabulário técnico preciso é parte da avaliação em entrevistas.

#line()

= Módulo 1 --- Fundamentos do mercado financeiro e Wealth Management

== 1.1 Como funciona o mercado financeiro

O sistema financeiro conecta quem tem recursos sobrando (poupadores e
investidores) a quem precisa de recursos (empresas, governo, famílias).
Essa conexão acontece de duas formas:

- *Intermediação financeira*: o banco capta dinheiro (depósitos, CDBs) e empresta com uma margem (spread).
- *Mercado de capitais*: o investidor aplica diretamente em títulos emitidos por empresas ou pelo governo, como ações e debêntures.

No Brasil, a estrutura de regulação e supervisão se organiza assim:

#table(
  columns: (auto, 1fr),
  table.header([Instituição], [Papel principal]),
  [CMN], [Define as diretrizes gerais do sistema financeiro],
  [Banco Central], [Supervisiona bancos, conduz a política monetária (Selic)],
  [CVM], [Regula e fiscaliza o mercado de capitais e os fundos],
  [ANBIMA], [Autorregulação e códigos de conduta; divulga índices e taxas de referência],
  [B3], [Bolsa e infraestrutura de negociação, registro, custódia e liquidação],
)

Taxas de referência que você precisa dominar: *Selic* (taxa básica), *CDI*
(taxa dos empréstimos interbancários, muito próxima da Selic e benchmark da
renda fixa), *IPCA* (inflação oficial) e *câmbio* (dólar/real).

== 1.2 Bancos, corretoras, gestoras e assessorias

- *Bancos*: captam, emprestam, oferecem produtos próprios e, muitas vezes, têm braço de investimentos e de private banking.
- *Corretoras e distribuidoras*: executam ordens de compra e venda e distribuem produtos de terceiros. O cliente acessa a bolsa por meio delas.
- *Gestoras de recursos*: administram carteiras e fundos, tomando as decisões de investimento dentro de um mandato.
- *Administradores fiduciários e custodiantes*: cuidam da parte regulatória, contábil e da guarda dos ativos dos fundos.
- *Assessorias de investimento (e agentes autônomos)*: orientam clientes e distribuem produtos, vinculadas a uma corretora ou distribuidora. Não custodiam o patrimônio do cliente.

Um ponto de atenção para o Back Office: saber quem faz o quê evita erros
de responsabilidade, por exemplo, quem é a fonte oficial de uma posição
(custodiante) e quem apenas a reporta (assessoria).

== 1.3 O que é Wealth Management e Advisory

Wealth Management é a gestão integrada do patrimônio de clientes de alta
renda ou grande patrimônio. Vai além de escolher investimentos e inclui:

- planejamento financeiro e definição de objetivos;
- alocação de ativos e rebalanceamento;
- planejamento tributário e sucessório;
- proteção (seguros, previdência);
- gestão de liquidez e de passivos.

Advisory (assessoria) é o serviço de recomendação e acompanhamento: o
assessor entende o perfil do cliente, propõe uma estratégia e acompanha o
resultado, enquanto a execução é feita por meio da corretora ou do banco.

O papel do *Back Office Analítico* nesse ecossistema é sustentar a operação
com informação correta: consolidar posições, conferir movimentações,
preparar relatórios e dar ao assessor dados confiáveis para a conversa com
o cliente.

== 1.4 Produtos financeiros e classes de ativos

*Renda fixa*

- Pós-fixados: rendem conforme um indicador, como o CDI (ex.: CDB a 100% do CDI), ou a Selic (Tesouro Selic).
- Prefixados: a taxa é conhecida na compra (ex.: 13% ao ano).
- Híbridos: parte fixa mais inflação (ex.: IPCA + 6% ao ano).
- Isentos de IR para pessoa física: LCI, LCA, CRI, CRA e debêntures incentivadas (regra vigente à época desta apostila; confira).
- Crédito privado: CDB, LC, debêntures, CRI, CRA. Envolvem risco de crédito do emissor, e o FGC cobre apenas parte dos produtos bancários, dentro de limites.
- Títulos públicos: Tesouro Selic, Tesouro Prefixado, Tesouro IPCA+.

*Renda variável*

- Ações, ETFs, fundos imobiliários (FIIs), BDRs.

*Fundos de investimento*

- Renda fixa, multimercado, ações, cambiais, FIIs, fundos exclusivos e reservados. O cliente compra cotas; o valor da cota varia conforme o patrimônio do fundo.
- Cobram taxa de administração e, em alguns casos, taxa de performance.
- Fundos abertos de renda fixa e multimercado têm o *come-cotas*, antecipação semestral de IR (maio e novembro).

*Outros*

- Previdência privada (PGBL e VGBL, detalhados no Módulo 7), moedas e ativos no exterior, produtos estruturados, COE.

Tributação, de forma resumida (verifique a regra vigente):

#table(
  columns: (auto, 1fr),
  table.header([Produto], [Regra geral]),
  [Renda fixa tradicional], [Tabela regressiva de 22,5% (até 180 dias) a 15% (acima de 720 dias), sobre o rendimento; IOF nos primeiros 30 dias],
  [Ações à vista], [15% sobre o ganho, com regras de isenção por volume mensal de vendas e day trade a 20%],
  [Fundos de renda fixa e multimercado], [Come-cotas semestral e alíquota final conforme o prazo],
)

== 1.5 Funcionamento de uma carteira de investimentos

Uma carteira é o conjunto de ativos de um cliente (ou de uma família),
organizado para atender objetivos com um nível de risco compatível com o
perfil.

Conceitos-chave:

- *Perfil de investidor (suitability)*: conservador, moderado ou arrojado, definido por questionário. É obrigatório verificar a adequação do produto ao perfil (ver seção 7.2).
- *Alocação estratégica*: a divisão de longo prazo entre classes (ex.: 60% renda fixa, 20% renda variável, 10% multimercado, 10% exterior).
- *Alocação tática*: desvios temporários da estratégica para aproveitar cenários.
- *Rebalanceamento*: voltar aos pesos-alvo quando o mercado os distorce.
- *Diversificação*: reduzir risco específico distribuindo o capital entre ativos pouco correlacionados.
- *Liquidez*: em quanto tempo e a que custo o ativo vira dinheiro.

=== Exercícios do Módulo 1

+ Explique a diferença entre uma corretora, uma gestora e uma assessoria de investimentos.
+ Um cliente conservador quer investir em um fundo de ações de pequenas empresas. O que o Back Office e o assessor devem verificar?
+ Monte uma alocação estratégica para um perfil moderado e justifique cada faixa.

#line()

= Módulo 2 --- Fundamentos de operações de investimentos

== 2.1 Posições, movimentações e saldos

- *Posição*: o que o cliente tem em determinada data (ativo, quantidade, preço, valor de mercado).
- *Movimentação*: qualquer evento que altera a posição: compra, venda, aplicação, resgate, transferência, amortização, pagamento de juros e dividendos, desdobramento, grupamento, bonificação.
- *Saldo*: o resultado das movimentações sobre a posição inicial.

A relação básica é:

$
"Posição final" = "Posição inicial" + "Entradas" - "Saídas" plus.minus "Proventos e ajustes"
$

O valor de mercado de um ativo é quantidade × preço. A fonte do preço
importa: preço de fechamento da B3, cota divulgada pelo administrador,
preço de mercado do título público (ANBIMA) ou curva do papel (marcação na
curva em alguns produtos de renda fixa).

== 2.2 Custódia e consolidação de carteiras

Custódia é a guarda e o registro dos ativos em nome do investidor. Na
bolsa, o custodiante é o responsável perante a B3. Na renda fixa privada,
o registro é feito em câmaras como a B3 e a CERC (verifique o ambiente de
registro aplicável a cada produto).

Quando o cliente tem ativos em várias instituições, surge a necessidade de
*consolidação*: reunir posições de custodiantes diferentes em uma visão
única de patrimônio. Desafios comuns:

- nomes de ativos diferentes para o mesmo papel;
- datas de referência diferentes entre instituições;
- ativos fora do sistema (imóveis, participações, previdência);
- moedas distintas, exigindo conversão por uma taxa de câmbio padronizada.

Boas práticas: definir uma fonte oficial para cada tipo de informação, uma
data-base única e um identificador único de ativo (ticker, ISIN ou código
interno).

== 2.3 Liquidação e conciliação

Liquidação é o momento em que a operação se completa financeiramente, com
a entrega do ativo contra o pagamento. Prazos de referência (confirme a
regra de cada mercado):

- ações à vista na B3: em geral D+2;
- Tesouro Direto: tipicamente D+1 útil;
- fundos: variam. Há prazo de cotização (quando o dinheiro vira cotas ou cotas viram dinheiro) e de liquidação financeira (quando o dinheiro entra na conta), definidos em regulamento.

Conciliação é a conferência entre duas fontes que deveriam concordar.
Exemplos:

- posição no sistema interno × posição no extrato do custodiante;
- movimentações do cliente × lançamentos na conta corrente;
- saldo contábil × saldo de gestão.

Passo a passo de uma conciliação:

+ Reunir as duas bases com a mesma data-base.
+ Padronizar chaves (código do ativo, conta do cliente).
+ Cruzar as bases e calcular as diferenças de quantidade e de valor.
+ Classificar as diferenças (timing, preço, falha de lançamento, evento corporativo não registrado).
+ Corrigir, documentar e registrar a causa para evitar reincidência.

== 2.4 Rentabilidade e acompanhamento patrimonial

- *Rentabilidade nominal*: variação percentual do valor investido.
- *Rentabilidade líquida*: após custos, taxas e impostos.
- *Rentabilidade real*: descontada a inflação.
- *Comparação com benchmark*: resultado em relação a CDI, IPCA + taxa, Ibovespa ou outro índice adequado.

O cálculo correto precisa tratar aportes e resgates:

- *Retorno ponderado pelo tempo (TWR)*: isola a decisão de investimento, eliminando o efeito do momento dos aportes. É o padrão para comparar gestores e carteiras.
- *Retorno ponderado pelo dinheiro (MWR / TIR)*: considera o momento e o tamanho dos fluxos, refletindo a experiência real do cliente.

Exemplo simples de rentabilidade acumulada a partir de retornos mensais:

$
(1 + r_1) times (1 + r_2) times dots.h times (1 + r_n) - 1
$

Para converter taxa anual em mensal equivalente:

$
(1 + i_"anual")^(frac(1, 12)) - 1
$

O acompanhamento patrimonial inclui evolução do patrimônio, composição por
classe, concentração por emissor, vencimentos próximos e fluxo de caixa
esperado (cupons, dividendos, vencimentos).

== 2.5 Qualidade e integridade das informações

Decisões de investimento dependem de dados confiáveis. As dimensões de
qualidade a monitorar:

- *Completude*: todos os campos e todas as contas estão presentes.
- *Exatidão*: valores batem com a fonte.
- *Consistência*: o mesmo dado tem o mesmo valor em todos os sistemas.
- *Atualidade*: a data-base é a esperada.
- *Unicidade*: sem registros duplicados.
- *Rastreabilidade*: é possível voltar do relatório até a fonte.

Controles práticos: checagens automáticas (soma das partes = total),
alertas para variações atípicas, dupla conferência em eventos manuais e
trilha de auditoria de alterações.

=== Exercícios do Módulo 2

+ O sistema mostra 1.000 ações da empresa X e o extrato do custodiante mostra 900. Liste três causas possíveis e como investigaria cada uma.
+ Calcule a rentabilidade acumulada de três meses com retornos de 1,0%, −0,5% e 1,5%.
+ Explique por que TWR e MWR podem divergir para o mesmo cliente.

#line()

= Módulo 3 --- Excel aplicado ao mercado financeiro

== 3.1 Organização de bases

Antes de qualquer fórmula, a base precisa estar bem estruturada:

- uma linha por registro e uma coluna por atributo (formato tabular);
- cabeçalho único na primeira linha, sem células mescladas;
- um tipo de dado por coluna (datas como data, valores como número);
- sem linhas de subtotal no meio dos dados;
- uso de Tabelas do Excel (Ctrl+T), que expandem sozinhas e permitem referências estruturadas como `Movimentos[Valor]`.

Exemplo de colunas de uma base de movimentações: Data, Cliente, Conta,
Ativo, Classe, Tipo (compra, venda, provento), Quantidade, Preço, Valor.

== 3.2 Fórmulas e funções essenciais

#table(
  columns: (auto, 1fr),
  table.header([Função], [Uso]),
  [SOMA, MÉDIA, MÁXIMO, MÍNIMO], [Agregações básicas],
  [SE, E, OU], [Lógica condicional],
  [SEERRO], [Tratar erros de forma controlada],
  [ARRUMAR, ESQUERDA, DIREITA, EXT.TEXTO, TEXTO], [Limpeza e padronização de texto],
  [DATA, DIA.DA.SEMANA, DIATRABALHO, FIMMÊS], [Datas e dias úteis],
  [ARRED], [Arredondamento consistente],
)

Dica de qualidade: evite números digitados dentro de fórmulas. Coloque
premissas (taxas, datas-base) em células identificadas.

== 3.3 PROCX, SOMASES, CONT.SES e funções condicionais

PROCX busca um valor e retorna outro, substituindo o PROCV com mais
flexibilidade:

` =PROCX(A2; Cadastro[Ativo]; Cadastro[Classe]; "Não encontrado") `

O quarto argumento trata a ausência do item, o que já evita muitos erros
\#N/D. Vale conhecer também o parâmetro de modo de correspondência e a
busca do último para o primeiro.

SOMASES soma valores que atendem a vários critérios:

` =SOMASES(Movimentos[Valor]; Movimentos[Cliente]; A2; Movimentos[Tipo]; "Compra") `

CONT.SES conta registros por critérios:

` =CONT.SES(Movimentos[Conta]; A2; Movimentos[Data]; ">="&DATA(2026;1;1)) `

Outras funções condicionais úteis: SOMASE, CONT.SE, MÉDIASES, MÁXIMOSES e
MÍNIMOSES.

Conciliação em Excel (padrão de uso):

` =SEERRO(PROCX(C2; Custodia[Chave]; Custodia[Quantidade]); 0) - D2 `

Essa fórmula traz a quantidade do custodiante e subtrai a quantidade do
sistema interno. Filtre as linhas com diferença diferente de zero para
tratar as exceções.

== 3.4 Tabelas dinâmicas

Tabelas dinâmicas resumem grandes bases sem fórmulas. Estrutura:

- *Linhas*: como você quer agrupar (cliente, classe de ativo).
- *Colunas*: como quer abrir (mês, instituição).
- *Valores*: o que quer medir (soma de valor, contagem, média).
- *Filtros e segmentações*: recortes interativos.

Boas práticas: partir de uma Tabela do Excel, atualizar com Dados >
Atualizar tudo, formatar valores como moeda e usar Mostrar valores como >
% do total para ver a composição da carteira.

== 3.5 Power Query

O Power Query automatiza a importação e a limpeza dos dados e guarda cada
passo, de modo que basta atualizar para repetir o tratamento.

Operações mais usadas:

- importar de pastas, planilhas, CSV e bancos de dados;
- remover colunas e linhas indesejadas, promover cabeçalhos;
- alterar tipos de dados;
- dividir e mesclar colunas;
- acrescentar consultas (empilhar arquivos de vários meses);
- mesclar consultas (equivale a um join, para cruzar bases);
- desdinamizar colunas (transformar colunas de meses em linhas).

Um fluxo típico de Back Office: arquivos mensais de extratos em uma pasta,
tratados e empilhados por uma única consulta, alimentando a base de
conciliação.

== 3.6 Relatórios e dashboards

Princípios de um bom relatório:

- responda a uma pergunta clara (ex.: "como está a composição do patrimônio de cada cliente?");
- destaque poucos indicadores principais no topo;
- use gráficos adequados: barras para comparar categorias, linhas para evolução no tempo, rosca ou pizza só para poucas fatias;
- padronize formatos, cores e unidades;
- documente a fonte e a data-base.

Para dashboards: conecte gráficos a tabelas dinâmicas, adicione segmentações
e proteja as abas de cálculo.

=== Exercícios do Módulo 3

+ Com uma base de movimentações, calcule o total comprado por cliente em um período usando SOMASES.
+ Cruze duas bases (sistema × custodiante) com PROCX e liste as divergências.
+ Empilhe três arquivos mensais com Power Query e gere uma tabela dinâmica de patrimônio por classe.

#line()

= Módulo 4 --- Análise de dados e indicadores financeiros

== 4.1 Tratamento e estruturação de dados

O ciclo de tratamento de dados segue uma sequência estável:

+ Coletar das fontes oficiais.
+ Inspecionar: tipos, nulos, duplicados, valores fora do esperado.
+ Limpar e padronizar: nomes, datas, moedas, chaves.
+ Estruturar em formato tabular e, quando possível, separar cadastros (clientes, ativos) de fatos (movimentações, preços).
+ Validar com totais de controle e contra a fonte.
+ Documentar as regras aplicadas.

Separe sempre dados brutos de dados tratados: o bruto nunca deve ser
sobrescrito.

== 4.2 Análise de rentabilidade

Perguntas que a análise deve responder:

- Quanto a carteira rendeu no período e contra qual benchmark?
- Quais ativos ou classes mais contribuíram para o resultado (atribuição de performance)?
- Qual foi o efeito dos custos e dos impostos?
- O resultado foi compatível com o risco assumido?

A contribuição de um ativo é, em primeira aproximação, o seu peso inicial
multiplicado pelo seu retorno. A soma das contribuições aproxima o retorno
total da carteira.

Para comparar com o CDI, use o *percentual do CDI*: rentabilidade do
período dividida pelo CDI do mesmo período.

== 4.3 Alocação de ativos

A análise de alocação compara a carteira atual com a alvo:

#table(
  columns: (1fr, auto, auto, auto),
  table.header([Classe], [Peso atual], [Peso alvo], [Desvio]),
  [Renda fixa pós-fixada], [45%], [40%], [+5 p.p.],
  [Renda fixa inflação], [15%], [20%], [−5 p.p.],
  [Ações], [25%], [25%], [0],
  [Exterior], [15%], [15%], [0],
)

Indicadores úteis: concentração por emissor, por instituição, por
vencimento e por moeda. Desvios acima de uma banda de tolerância (por
exemplo, 5 p.p.) sinalizam necessidade de rebalanceamento.

== 4.4 Indicadores de risco e desempenho

- *Volatilidade*: desvio-padrão dos retornos. Mede a oscilação; costuma ser anualizada.
- *Drawdown máximo*: maior queda do pico ao vale no período.
- *Índice de Sharpe*: retorno excedente ao ativo livre de risco dividido pela volatilidade. Mede retorno por unidade de risco.
- *Beta*: sensibilidade do ativo ou da carteira ao mercado de referência.
- *Tracking error*: volatilidade da diferença de retorno em relação ao benchmark.
- *VaR (Value at Risk)*: perda máxima estimada, em um horizonte e com um nível de confiança, em condições normais.
- *Risco de crédito, de liquidez e de concentração*: nem sempre aparecem na volatilidade e precisam de análise própria.

Cuidado de interpretação: indicadores calculados sobre janelas curtas ou
sobre ativos pouco líquidos podem enganar. Sempre informe o período
utilizado.

== 4.5 Interpretação de informações financeiras

Analisar não é apenas calcular, é explicar. Estrutura sugerida para um
comentário de carteira:

+ *Resultado*: o que aconteceu (ex.: carteira rendeu 1,1% no mês, equivalente a 98% do CDI).
+ *Causa*: o que explicou o resultado (ex.: queda das taxas de juros longas ajudou os títulos IPCA+, enquanto ações foram o principal detrator).
+ *Risco*: o que mudou na exposição.
+ *Ação sugerida*: o que o assessor pode discutir com o cliente.

Leia também demonstrações e relatórios gerenciais de fundos (lâmina,
regulamento, relatório do gestor), entendendo política de investimento,
taxas, prazos de resgate e principais posições.

=== Exercícios do Módulo 4

+ Uma carteira rendeu 0,95% no mês e o CDI foi 1,00%. Quanto foi em percentual do CDI?
+ Calcule o desvio entre alocação atual e alvo para uma carteira de sua escolha e proponha um rebalanceamento.
+ Escreva um comentário de carteira de cinco linhas seguindo a estrutura da seção 4.5.

#line()

= Módulo 5 --- Automação, Python, SQL e IA

== 5.1 Automação de rotinas

Candidatas à automação são tarefas repetitivas, regradas e frequentes:
baixar extratos, padronizar arquivos, conciliar, gerar relatórios mensais.

Escada de automação, do mais simples ao mais robusto:

+ Atalhos, fórmulas e tabelas dinâmicas.
+ Power Query com atualização em um clique.
+ Macros VBA ou Office Scripts para ações no Excel.
+ Scripts em Python agendados.
+ Pipelines com banco de dados e orquestração.

Antes de automatizar, mapeie o processo manual e defina o resultado
esperado e os controles. Automatizar um processo mal definido apenas
acelera o erro.

== 5.2 Manipulação de dados com Python

A biblioteca pandas é a ferramenta central. Exemplo de conciliação entre
duas bases:

```python
import pandas as pd

sistema = pd.read_excel("sistema.xlsx")
custodia = pd.read_excel("custodia.xlsx")

# padronizar chave
for df in (sistema, custodia):
    df["ativo"] = df["ativo"].str.strip().str.upper()

# cruzar as bases
conc = sistema.merge(
    custodia,
    on=["conta", "ativo"],
    how="outer",
    suffixes=("_sis", "_cust"),
    indicator=True,
)

conc["dif_qtd"] = conc["qtd_sis"].fillna(0) - conc["qtd_cust"].fillna(0)
divergencias = conc[conc["dif_qtd"] != 0]
divergencias.to_excel("divergencias.xlsx", index=False)
```

Operações essenciais de pandas: `read_csv` e `read_excel`, filtros
booleanos, `groupby`, `merge`, `pivot_table`, `to_datetime`, tratamento de
nulos (`fillna`, `dropna`) e `drop_duplicates`.

Exemplo de rentabilidade acumulada:

```python
retornos = pd.Series([0.010, -0.005, 0.015])
acumulado = (1 + retornos).prod() - 1
print(f"{acumulado:.2%}")
```

== 5.3 Consultas SQL

SQL permite consultar bases grandes e centralizadas. Comandos
fundamentais:

```sql
-- patrimônio por cliente na data-base
SELECT c.nome,
       SUM(p.quantidade * p.preco) AS patrimonio
FROM posicoes p
JOIN clientes c ON c.id = p.cliente_id
WHERE p.data_base = '2026-09-30'
GROUP BY c.nome
ORDER BY patrimonio DESC;
```

```sql
-- clientes com concentração acima de 30% em um único ativo
SELECT cliente_id, ativo, peso
FROM (
    SELECT cliente_id,
           ativo,
           valor / SUM(valor) OVER (PARTITION BY cliente_id) AS peso
    FROM posicoes
    WHERE data_base = '2026-09-30'
) t
WHERE peso > 0.30;
```

Conceitos a dominar: SELECT, WHERE, GROUP BY, HAVING, ORDER BY, JOIN
(inner, left), CASE WHEN, subconsultas, funções de janela (OVER,
PARTITION BY) e datas.

== 5.4 Aplicação de IA em processos financeiros

Usos adequados de IA no Back Office e na assessoria:

- Extração de informações de documentos (extratos, lâminas, contratos) para planilhas;
- Resumo de relatórios de gestores e de comunicados;
- Apoio à escrita de e-mails e comentários de carteira;
- Geração de código (fórmulas, scripts, consultas) com revisão humana;
- Classificação de ocorrências e detecção de padrões anormais.

Cuidados essenciais:

- IA pode errar com segurança aparente. Todo resultado que alimenta uma decisão ou um cliente precisa de conferência.
- Não inclua dados pessoais ou sigilosos em ferramentas não autorizadas pela instituição.
- Peça saídas estruturadas (tabela, JSON) para facilitar a validação.
- Registre qual ferramenta e qual versão geraram o resultado, quando relevante.

== 5.5 Validação, segurança e controle de erros

*Validação*

- Totais de controle: soma de entradas e saídas bate com a origem.
- Contagem de registros antes e depois de cada etapa.
- Testes com casos conhecidos e com casos de borda (base vazia, datas inválidas).
- Revisão por uma segunda pessoa (princípio dos quatro olhos).

*Segurança*

- Nunca deixe senhas ou chaves dentro do código ou de planilhas.
- Limite o acesso a dados de clientes ao necessário.
- Mantenha cópias de segurança e versionamento.
- Atenção à LGPD no tratamento de dados pessoais (ver também a seção 7.3).

*Controle de erros em código*

```python
try:
    df = pd.read_excel("extrato.xlsx")
except FileNotFoundError:
    raise SystemExit("Arquivo de extrato não encontrado.")

assert df["valor"].notna().all(), "Existem valores nulos na base."
assert not df.duplicated().any(), "Existem linhas duplicadas."
```

Registre logs do que foi processado e crie alertas para falhas, para que
ninguém dependa de perceber o erro por acaso.

=== Exercícios do Módulo 5

+ Escreva um script em Python que leia dois arquivos e liste as divergências de quantidade.
+ Escreva uma consulta SQL que retorne os cinco maiores clientes por patrimônio.
+ Descreva três controles que você colocaria em uma rotina automatizada de relatório mensal.

#line()

= Módulo 6 --- Aplicação prática e preparação para o gestor

== 6.1 Estudos de caso

*Caso A --- Divergência de posição* O relatório do cliente mostra
patrimônio de R\$ 2,40 milhões, mas o extrato do custodiante mostra R\$ 2,31
milhões. Há diferença de R\$ 90 mil.

Roteiro de análise:

+ Confirmar a data-base e a fonte dos preços nas duas pontas.
+ Comparar posição ativo a ativo para localizar a origem.
+ Verificar eventos recentes: aplicações e resgates ainda não cotizados, proventos, vencimentos, evento corporativo.
+ Corrigir a causa, registrar e comunicar o assessor.

*Caso B --- Cliente com concentração* Um cliente moderado tem 42% do
patrimônio em um único CRI de um emissor.

Roteiro: calcular concentração por ativo e por emissor, comparar com a
política de alocação e com o perfil, apontar risco de crédito e liquidez e
preparar material para o assessor discutir diversificação.

*Caso C --- Relatório mensal atrasado* O relatório consolidado depende de
cinco arquivos e sempre é entregue com atraso por retrabalho manual.

Roteiro: mapear o processo, identificar gargalos, automatizar importação e
limpeza com Power Query ou Python, definir checagens e medir o tempo antes
e depois.

== 6.2 Resolução de problemas de Back Office

Método recomendado para qualquer problema operacional:

+ Entender: qual é o sintoma e qual é o impacto no cliente?
+ Delimitar: quando começou, quem e o que são afetados?
+ Levantar hipóteses ordenadas por probabilidade e esforço de verificação.
+ Testar com dados, não com suposições.
+ Corrigir a causa e não apenas o sintoma.
+ Prevenir: criar controle ou automação que evite repetição.
+ Comunicar de forma objetiva, com status, impacto, causa e próximo passo.

Erros comuns: corrigir direto na planilha final sem rastrear a origem,
ignorar diferenças pequenas que escondem falhas sistêmicas e não
documentar a solução.

== 6.3 Apresentação de soluções técnicas

Ao apresentar uma solução a um gestor, use a estrutura:

- *Contexto*: o problema em uma frase.
- *Impacto*: tempo, risco ou custo envolvidos.
- *Solução*: o que foi feito, em linguagem simples, com um exemplo.
- *Resultado*: ganho mensurável (horas economizadas, redução de erros).
- *Riscos e controles*: o que pode falhar e como foi mitigado.
- *Próximos passos*.

Adapte o nível técnico ao público: o gestor quer saber o que muda e que
risco existe, e só entra em detalhes de fórmula ou código se perguntar.

== 6.4 Entrevistas simuladas

Perguntas para treinar em voz alta:

*Conhecimento*

- Qual a diferença entre custódia e gestão?
- O que é come-cotas e quando acontece?
- Como você calcularia a rentabilidade de uma carteira com aportes e resgates?
- O que é suitability e por que importa?

*Técnicas*

- Como você concilia duas bases com chaves diferentes?
- Quando usaria PROCX, quando usaria Power Query e quando partiria para Python?
- Como garantiria que um relatório automatizado está correto?

*Situacionais*

- Você percebe um erro em um relatório já enviado ao cliente. O que faz?
- Dois assessores pedem prioridades conflitantes ao mesmo tempo. Como decide?
- Descreva uma rotina que você automatizou e o resultado.

*Comportamentais*

- Conte uma situação em que identificou um erro antes que causasse impacto.
- Como você lida com prazos curtos e alto volume de demandas?

Técnica de resposta: *SITUAÇÃO, AÇÃO, RESULTADO*. Seja específico, cite
números e admita o que aprendeu.

== 6.5 Comunicação profissional e vocabulário técnico

Glossário essencial:

#table(
  columns: (auto, 1fr),
  table.header([Termo], [Significado resumido]),
  [AuC / AuM], [Patrimônio sob custódia / sob gestão],
  [Benchmark], [Índice de referência para comparar o desempenho],
  [Come-cotas], [Antecipação semestral de IR em certos fundos],
  [Cotização], [Data em que aplicação ou resgate vira cotas ou dinheiro],
  [Duration], [Prazo médio ponderado dos fluxos de um título; mede sensibilidade a juros],
  [Marcação a mercado], [Avaliação do ativo pelo preço de mercado],
  [Marcação na curva], [Avaliação pela taxa contratada na compra],
  [Rebalanceamento], [Retorno da carteira aos pesos-alvo],
  [Spread], [Diferença de taxa entre dois instrumentos ou a margem de crédito],
  [Suitability], [Adequação do produto ao perfil do investidor],
  [Slippage], [Diferença entre preço esperado e preço executado],
  [KYC], [Conheça seu cliente: identificação, perfil e monitoramento contínuo (ver Módulo 7)],
  [PLD-FT], [Prevenção à lavagem de dinheiro e ao financiamento ao terrorismo (ver Módulo 7)],
)

Boas práticas de comunicação escrita:

- assunto de e-mail que diga a ação ou o tema;
- primeira frase com a conclusão, detalhes depois;
- números com unidade, período e fonte;
- tom cordial e objetivo, sem jargão desnecessário com quem não é da área;
- revisão antes de enviar, em especial de valores e nomes de clientes.

=== Exercícios do Módulo 6

+ Resolva o Caso A criando uma base fictícia com uma divergência e documente o passo a passo.
+ Prepare uma apresentação de dois minutos sobre uma rotina que você automatizaria.
+ Grave suas respostas a cinco perguntas da seção 6.4 e reavalie clareza e objetividade.

#line()

= Módulo 7 --- Compliance, regulamentação e preparação para a reunião

Este módulo cobre os temas que costumam faltar em apostilas técnicas e que
diferenciam um candidato bem preparado: as normas que moldam o dia a dia de
uma assessoria, o fluxo de cadastro de clientes, eventos corporativos,
previdência e o preparo específico dos últimos dias antes da entrevista.
Regulamentação muda: use os nomes e números abaixo como mapa de estudo e
confirme a norma vigente.

== 7.1 O quadro regulatório do advisory

#table(
  columns: (auto, 1fr, 1fr),
  table.header([Norma], [Objeto], [Por que importa para o Back Office]),
  [Resolução CVM 178], [Disciplina a atividade de assessoria de investimento (substituiu a Instrução CVM 527)], [Define o que a assessoria pode e não pode fazer: orienta e recomenda, sempre vinculada a uma corretora ou distribuidora; não custodia recursos nem administra carteiras],
  [Resolução CVM 30], [Suitability: adequação do produto ao perfil do investidor], [Torna obrigatório conhecer cliente, conhecer produto e verificar adequação (seção 7.2)],
  [Resolução CVM 21], [Define públicos de investidores (varejo, qualificado, profissional)], [Determina a que produtos cada cliente pode acessar (seção 7.4)],
  [Código ANBIMA de assessoria], [Autorregulação e melhores práticas de conduta], [Complementa as regras da CVM com padrões de conduta esperados pela indústria],
  [Resolução CVM 50 e normas do CMN/BCB], [Prevenção à lavagem de dinheiro (PLD-FT)], [Obriga a instituição a monitorar e comunicar operações suspeitas (seção 7.3)],
  [LGPD], [Proteção de dados pessoais], [Rege o tratamento de dados de clientes em relatórios, bases e ferramentas de IA],
)

Essa tabela reforça o mapa de responsabilidades do Módulo 1: a assessoria
orienta e distribui; a corretora executa e custodia via custodiante; a
gestora decide; o back office consolida, confere e sustenta o compliance
operacional com dados corretos.

== 7.2 Suitability como obrigação regulatória

No Módulo 1, suitability apareceu como conceito de perfil. Aqui está o que
a regra exige, em três deveres encadeados:

+ *Conhecer o cliente*: coletar e manter atualizado o questionário de perfil (objetivos, horizonte, experiência, situação financeira e tolerância a perdas), classificando-o em conservador, moderado ou arrojado.
+ *Conhecer o produto*: a instituição deve classificar os produtos que distribui por complexidade e risco.
+ *Verificar a adequação*: só recomendar produtos compatíveis com o perfil. Em linhas gerais, é vedado recomendar a clientes conservadores produtos moderados ou agressivos, e recomendar a moderados produtos agressivos exige justificativa formal e registro (confirme os detalhes na norma vigente).

O papel do back office na prática:

- gerar e acompanhar *relatórios de exceção* de suitability (recomendações fora do perfil);
- monitorar a validade dos questionários e cobrar atualização periódica;
- garantir que o registro da recomendação fique rastreável (quem recomendou, o quê, quando, para qual perfil).

Pergunta clássica de entrevista: *"um cliente moderado insiste em um
produto arrojado, o que você faz?"* --- a resposta espera o conceito de
inadequação registrada, o papel do compliance e a demonstração de que o
back office sustenta esse controle com dados.

== 7.3 KYC, PLD-FT e COAF

*KYC (know your customer)* é a base de tudo: identificar o cliente,
entender sua atividade econômica e origem dos recursos, e manter o
cadastro atualizado. O mesmo cadastro alimenta o suitability e os
controles de lavagem de dinheiro.

*PLD-FT* é o conjunto de regras de prevenção à lavagem de dinheiro e ao
financiamento ao terrorismo. As instituições financeiras e as reguladas
pela CVM devem ter política interna, cadastrar clientes com dossiê,
monitorar operações e comunicar as suspeitas ao *COAF* (Conselho de
Controle de Atividades Financeiras), que é quem centraliza essas
comunicações no Brasil.

*PEP (pessoa exposta politicamente)* é quem exerce ou exerceu cargos
públicos relevantes (e seus familiares e estreitos associados): exige
tratamento reforçado de cadastramento e aprovação superior.

Sinais de alerta (*red flags*) que o back office pode ser o primeiro a
notar:

- movimentações incompatíveis com a renda e o patrimônio declarados;
- recusa ou demora em apresentar documentos de origem dos recursos;
- uso recorrente de contas de terceiros;
- instruções atípicas sem justificativa econômica.

Conduta esperada: registrar, escalar ao compliance e manter sigilo --- a
suspeita nunca se discute com o cliente. LGPD e sigilo bancário se
aplicam a tudo que passa pelas suas mãos.

== 7.4 Cadastro e onboarding de clientes

Fluxo típico de abertura:

+ Coleta de documentos (identificação, comprovantes, dados fiscais).
+ Verificação de identidade e da lista de restrições (PEP, sanctions).
+ Questionário de suitability e definição do perfil.
+ Assinatura de termos (contrato de intermediação, adesões, avisos legais).
+ Vinculação bancária e primeira movimentação.

Pontos que aparecem em entrevista:

- *Atualização cadastral periódica*: perfis e documentos vencem; o back office acompanha e cobra.
- *Investidor qualificado*: acessa produtos restritos mediante condições da Resolução CVM 21 (ex.: investimentos acima de R\$ 1 milhão ou certificações aprovadas --- confira valores vigentes); o cadastro precisa comprovar a condição.
- *FATCA/CRS*: clientes com vínculo ou ativos no exterior exigem declarações adicionas; o processo é da instituição, mas o back office trata os dados.

== 7.5 Eventos corporativos em detalhe

O Módulo 2 listou eventos como tipos de movimentação; aqui está o efeito
prático de cada um na base de posições:

#table(
  columns: (auto, 1fr, 1fr),
  table.header([Evento], [Efeito na posição], [Ponto de atenção do Back Office]),
  [Dividendos e JCP], [Crédito em conta (caixa); não altera quantidade], [Conferir datas (data-com, data-ex, pagamento) e reconciliar recebido × previstos; IR de dividendos para PF passou a incidir acima de faixa de isenção a partir de 2026 (Lei 15.270/2025) --- confirme a regra vigente; JCP têm retenção na fonte],
  [Desdobramento (split)], [Quantidade multiplica pelo fator; preço divide pelo mesmo fator], [Ajustar a base histórica, senão o gráfico de rentabilidade distorce],
  [Grupamento (inplit)], [Quantidade divide; preço multiplica], [Mesmo ajuste espelhado do split],
  [Bonificação], [Novas ações gratuitas em proporção à posição], [Quantidade aumenta sem fluxo de caixa; ajustar preço de aquisição médio],
  [Direito de subscrição], [Opção de comprar novas ações a preço fixado, em prazo determinado], [Acompanhar prazo: não exercer nem vender o direito significa perder valor; posição temporária de um ativo novo],
  [Amortização (CRI, CRA, debêntures)], [Devolução parcial do valor de face ao investidor], [Reduz o preço/valor de face do papel; ajustar marcação e fluxo futuro],
)

Datas que importam em proventos: *data-com* (último dia com direito),
*data-ex* (primeiro dia sem o direito) e *data de pagamento*. Uma posição
vendida na data-ex não recebe o provento --- erro clássico de conciliação
de caixa.

Roteiro do back office diante de um evento:

+ Identificar o evento e os clientes afetados (por posição na data-com).
+ Calcular o efeito esperado (quantidade, preço, caixa).
+ Registrar na base e conferir o que o custodiante efetivou.
+ Comunicar divergências e documentar.

== 7.6 Previdência: PGBL × VGBL

#table(
  columns: (auto, 1fr, 1fr),
  table.header([Aspecto], [PGBL], [VGBL]),
  [Dedução no IR], [Contribuições dedutíveis até o limite de 12% da renda tributável anual (exige declaração completa)], [Não dedutível],
  [Tributação no resgate], [Incide sobre o valor total resgatado (contribuições + rendimento)], [Incide apenas sobre os rendimentos],
  [Faz sentido para], [Quem declara IR completo e contribui até o teto dedutível], [Quem usa declaração simplificada ou já contribui acima do teto],
)

Regras comuns aos dois:

- *Regime tributário*: progressivo composto (alíquotas da tabela do IR) ou regressivo (começa em 35% e chega a 10% para aplicações com mais de 10 anos --- confirme a tabela vigente).
- A Lei 14.754/2023 padronizou prazos e passou a exigir que os planos permitam saque anual de até 10% do saldo acumulado; a tributação segue o regime escolhido. Confirme os detalhes no regulamento do plano.

Pergunta de entrevista pronta: *"PGBL ou VGBL?"* --- responda em três
frases: depende da declaração de IR e do teto de 12%; no PGBL o IR atinge
total resgatado, no VGBL só os rendimentos; a escolha errada transforma
dedução em armadilha.

== 7.7 Power BI e o mapa de ferramentas

Onde o Power BI entra em relação ao que você já estudou:

- *Excel + tabelas dinâmicas*: resolve análises pontuais de um analista por vez.
- *Power Query*: comum ao Excel e ao Power BI --- tudo o que o Módulo 3 ensina reaproveita.
- *Power BI*: quando o relatório precisa ser consultado por várias pessoas, atualizado recorrentemente contra fontes múltiples e interativo (filtros por cliente, período, classe). Usa *DAX* para criar medidas calculadas (a lógica é parente das fórmulas de tabela dinâmica).

Como posicionar na entrevista, sem inflar: "domino Excel a fundo, entendo
modelo de dados e o conceito de medidas; Power BI entra naturalmente
quando a audiência e a recorrência do relatório crescem".

== 7.8 Preparação específica para a reunião

Nos dias finais, o estudo técnico rende menos que o preparo dirigido:

- *Pesquise a casa*: site institucional, produtos que distribui, porte e dono (banco, gestora independente, plataforma), notícias recentes, área de atuação do gestor.
- *Saiba com quem vai falar*: nome do entrevistador, área (back office, middle office, dados) e o que a área mede (prazo, qualidade, volume).
- *Prepare 3 a 5 perguntas para o gestor*, por exemplo: "qual o maior gargalo operacional da área hoje?", "como vocês medem a qualidade de um relatório?", "como é a divisão entre Excel e ferramentas próprias no dia a dia?", "o que um analista entrega bem no primeiro mês?".
- *"Me conte sobre você"* em 30--60 segundos: quem sou → o que estudo/fiz → por que back office de wealth → o que trago (método, Excel, dados).
- *Se a vaga exigir inglês*, treine essa mesma apresentação de 1 minuto em inglês.
- *Logística*: confirmar horário e link/endereço, chegar 10 minutos antes, ambiente silencioso, currículo à mão e seu mini-projeto de Excel aberto, se houver.

=== Exercícios do Módulo 7

+ Explique em voz alta, em 1 minuto, a diferença entre KYC, suitability e PLD-FT, sem consultar.
+ Um cliente arrojado quer um produto reservado a qualificados; um moderado insiste em produto arrojado. O que fazer em cada caso?
+ Classifique os eventos corporativos da seção 7.5 em: alteram quantidade, alteram preço, geram caixa.
+ Responda em 3 frases: "PGBL ou VGBL para quem declara IR completo?".
+ Liste três perguntas que você faria ao gestor, adaptadas à empresa depois de pesquisá-la.

#line()

= Aplix Capital Group --- preparação específica para a vaga

Dossiê da empresa da vaga, montado a partir do site institucional e de
pesquisa pública (outubro de 2026). Releia na véspera e confirme os
detalhes que puder diretamente com a empresa.

== Quem é a Aplix

- *Origem*: fundada em 2010 em Fortaleza por *Alberto Saboia* e *Felipe Romcy*, com escritório também em São Paulo (desde 2022). Great Place to Work por três anos consecutivos.
- *Porte*: mais de 1.700 famílias e empresas clientes, *+R\$ 2,6 bilhões acompanhados*, NPS 95.
- *Cinco áreas*: Aplix Investments (assessoria credenciada à *XP Investimentos* desde 2011), Aplix Advisory (consultoria patrimonial independente, modelo family office para grandes patrimônios), Aplix Corporate (empresas), Aplix Protect (seguros e sucessão) e Aplix Learning (educação financeira).
- *Modelo de remuneração*: desde 2023, *honorários fixos (fee)* --- não comissão por produto. É o grande diferencial declarado da casa: "o alinhamento com o objetivo do cliente deixa de ser discurso e vira desenho".
- *Metodologia*: cinco etapas --- Introdução, Histórias (entrevista de profundidade), Análise, Planejamento e Acompanhamento contínuo com *comitê de investimentos mensal*. Princípio de "proteção primeiro".
- *Valores declarados*: Integridade, Humildade, Responsabilidade, Transparência, Resiliência e Pertencimento. A casa busca perfis de longo prazo, que "tratam o patrimônio dos outros como cuidariam do próprio".

== Por que isso importa para a vaga de back office

+ *Consolidação multi-instituição é o coração do trabalho.* Como advisory independente que cuida do patrimônio do cliente "em qualquer banco", o back office vive do problema do Módulo 2.2: consolidar posições de custodiantes diferentes (XP, bancos privados etc.) em uma visão única, com data-base e preços padronizados. Estude essa seção como prioridade máxima.
+ *Fee fixo muda a métrica de qualidade do relatório.* Sem comissão por produto, o valor percebido pelo cliente está no relatório de acompanhamento: rentabilidade vs. benchmark, atribuição, alocação vs. alvo (Módulos 2.4 e 4.5).
+ *Comitê mensal* significa rotina de preparar dados com prazo fixo e qualidade auditável todo mês --- é o Caso C do Módulo 6 com os controles do 5.5.
+ *Credenciamento à XP*: as operações executam via XP Investimentos; o extrato/posição da XP é uma das pontas da conciliação.
+ *Founder + cultura declarada*: fundadores avaliam fit pesadamente. Conecte seu método aos valores da casa --- transparência e responsabilidade aplicadas à conferência e à documentação (trilha de auditoria, quatro olhos, seções 2.5 e 5.5).

== Perguntas prontas para o founder

- "Como é hoje o fluxo de consolidação das posições entre custodiantes --- o que é manual e o que já é automatizado?"
- "O que o comitê mensal consome de informação da área de operações, e onde está o maior gargalo de prazo?"
- "Com o modelo de fee fixo, como vocês medem a qualidade da entrega ao cliente --- quais indicadores o back office alimenta?"
- "Onde um analista de back office entrega mais valor nos primeiros 90 dias, na sua leitura?"

== Como citar a casa na conversa

Sem parecer decorado, em uma frase: *"Li que vocês migraram para
honorários fixos em 2023 e cuidam do patrimônio do cliente em qualquer
instituição --- isso torna a consolidação multi-custodiante e a qualidade
do relatório mensal o coração da operação, que é exatamente a área que eu
quero fazer."*

== Fontes consultadas

- `aplix.com.br` (institucional, modelo e números)
- `aplix.com.br/advisory` (Aplix Advisory)
- `aplix.com.br/carreiras` (valores, cultura e GPTW)

#line()

= Cronograma sugerido

#table(
  columns: (auto, 1fr),
  table.header([Semana], [Foco]),
  [1], [Módulo 1 --- mercado, instituições, produtos e carteira],
  [2], [Módulo 2 --- posições, custódia, conciliação e rentabilidade],
  [3 a 4], [Módulo 3 --- Excel, tabelas dinâmicas e Power Query],
  [5], [Módulo 4 --- indicadores, alocação e análise],
  [6], [Módulo 5 --- Python, SQL, IA e controles],
  [7], [Módulo 6 --- casos, simulados e comunicação],
  [8], [Módulo 7 --- compliance, regulamentação e revisão geral],
)

Ajuste o ritmo à sua disponibilidade e ao prazo da vaga.

#block(fill: rgb("#f4f6f8"), inset: 10pt, radius: 4pt, width: 100%)[
  #strong[Prazo curto?] Se a entrevista estiver próxima, siga o cronograma
  dia a dia do arquivo `plano-estudos-backoffice-wealth.md` e use esta
  apostila como fonte de conteúdo, priorizando os Módulos 2, 3, 6 e 7.
]

= Checklist final

- ☐ Explico cada tipo de instituição e produto sem consultar material.
- ☐ Concilio duas bases em Excel e em Python.
- ☐ Calculo rentabilidade, alocação e indicadores de risco com segurança.
- ☐ Construo um relatório ou dashboard a partir de dados brutos.
- ☐ Escrevo consultas SQL com JOIN e agregações.
- ☐ Sei apontar os cuidados no uso de IA e na proteção de dados.
- ☐ Apresento uma solução técnica em dois minutos, com impacto e controles.
- ☐ Explico KYC, PLD-FT e COAF --- e o papel do back office nesses controles.
- ☐ Sei o que suitability exige (RCVM 30) e o que fazer diante de produto inadequado ao perfil.
- ☐ Descrevo o efeito dos principais eventos corporativos na posição e no caixa.
- ☐ Explico a diferença tributária entre PGBL e VGBL em três frases.
- ☐ Tenho 3 a 5 perguntas prontas para o gestor, adaptadas à empresa.
