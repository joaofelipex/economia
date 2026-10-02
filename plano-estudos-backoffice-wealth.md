# 🎯 Plano de Estudos — Back Office Analítico & Wealth Advisory
**Objetivo:** Entrevista dia 07/10 (quarta-feira) | **Nível:** Iniciante total | **Tempo:** ~6 dias úteis

---

## 📅 Cronograma Dia a Dia

### **Dia 1 (Hoje) — Fundamentos Mercado & Wealth** ⏱️ 4-5h
- [ ] Como funciona o mercado financeiro brasileiro
- [ ] Bancos vs Corretoras vs Gestoras vs Assessorias (diferenças, papéis)
- [ ] O que é Wealth Management / Wealth Advisory
- [ ] Produtos: Renda Fixa (Tesouro, CDB, LCI/LCA, Debêntures), Renda Variável (Ações, FIIs, ETFs), Fundos, Derivativos básicos
- [ ] Classes de ativos e perfil de risco
- [ ] Como funciona uma carteira de investimentos (alocação, diversificação)

**Recursos rápidos:** YouTube "Mercado Financeiro para Iniciantes" (XP, Rico, BTG), site B3 / CVM

---

### **Dia 2 — Operações de Back Office** ⏱️ 4-5h
- [ ] Posições, movimentações e saldos (o que é cada um)
- [ ] Custódia: o que é, quem faz (B3, Cetip, bancos custodiante)
- [ ] Consolidação de carteiras (agregação de posições multi-instituições)
- [ ] Liquidação: D+0, D+1, D+2 — prazos por ativo
- [ ] Conciliação: tipos (custódia vs contábil, posições vs extratos)
- [ ] Rentabilidade: metodologias (TWR vs MWR), benchmark
- [ ] Qualidade e integridade de dados (validações, outliers, gaps)

**Foco:** Entender o *fluxo* da ponta a ponta — ordem → execução → liquidação → custódia → posição → relatório

---

### **Dia 3 — Excel Aplicado (O "Must Have")** ⏱️ 5-6h
- [ ] Organização de bases: tabelas estruturadas, nomes de colunas, tipos de dados
- [ ] Fórmulas essenciais: SE, SEERRO, E/OU, PROCX (ou PROCV + ÍNDICE/CORRESP)
- [ ] SOMASES, CONT.SES, MÉDIASES — uso real em relatórios
- [ ] Tabelas Dinâmicas: agrupar por ativo, instituição, data, tipo
- [ ] Power Query: importar CSV/PDF, limpar, transformar, append de bases mensais
- [ ] Dashboard simples: rentabilidade por classe, concentração, evolução patrimonial

**Prática:** Baixe uma planilha de posições modelo (B3 ou simulada) e monte um mini-relatório

---

### **Dia 4 — Análise de Dados & Indicadores** ⏱️ 4-5h
- [ ] Tratamento de dados: duplicatas, nulos, formatação de datas, moedas
- [ ] Rentabilidade: cálculo bruto vs líquido, peso na carteira, contribuição
- [ ] Alocação: % por classe, por risco, por instituição, por prazo
- [ ] Risco: volatilidade, drawdown, VaR básico, Sharpe (conceito)
- [ ] Desempenho: comparação vs benchmark (CDI, IBOV, IPCA+)
- [ ] Leitura de relatórios: fundo, consolidado, carta gestor

**Entregável:** Saiba explicar *como* você calcularia a rentabilidade de uma carteira multi-produtos

---

### **Dia 5 — Tech: Python + SQL + Automação (Visão Geral)** ⏱️ 3-4h
- [ ] Python: pandas (read_csv, groupby, merge, pivot_table), datetime, numéricos
- [ ] SQL: SELECT, WHERE, JOIN, GROUP BY, funções de data/agregação
- [ ] Automação: conceito de ETL, agendamento, logs, validações
- [ ] IA: casos de uso reais (classificação de ativos, detecção de anomalias, geração de texto)
- [ ] Validação e controle de erros: try/except, testes unitários básicos, reconciliação automatizada

**Meta:** Mostrar que *entende o vocabulário* e sabe *onde* cada ferramenta se encaixa — não precisa codar na hora

---

### **Dia 6 — Casos Práticos & Entrevista** ⏱️ 4-5h
- [ ] **Caso 1:** Conciliar posição custódia vs contábil — 500 linhas, 5 diferenças. Como resolve?
- [ ] **Caso 2:** Cliente quer rentabilidade últimos 12m por classe. Base suja. Passos?
- [ ] **Caso 3:** Gestor pede relatório de concentração por emissor + risk metrics. O que entrega?
- [ ] **Simulação:** Grave-se respondendo: "Me explica o fluxo de liquidação de uma ação" (2 min)
- [ ] **Vocabulário técnico:** Liste 30 termos-chave e defina em 1 frase cada
- [ ] **Perguntas para o gestor:** Prepare 3-5 perguntas inteligentes sobre a área

---

### **Dia 7 (Quarta) — Revisão Leve + Entrevista** ⏱️ 1-2h
- [ ] Revisar: fluxo back office, fórmulas Excel, indicadores-chave
- [ ] Repassar vocabulário técnico
- [ ] Checar: nome do gestor, nome da área, produtos que a casa trabalha
- [ ] Mindset: "Sei o básico bem, tenho sede de aprender, resolvo problemas"

---

## 📋 Checklist de Preparação (Marque conforme avança)

### Conhecimento
- [ ] Explico o que faz um Back Office de Wealth
- [ ] Diferencio custódia, liquidação, conciliação
- [ ] Sei calcular rentabilidade TWR e MWR (conceito)
- [ ] Monto Tabela Dinâmica + PROCX sem olhar tutorial
- [ ] Uso Power Query para limpar base mensal
- [ ] Entendo o que é alocação, concentração, risco
- [ ] Falo Python/SQL no nível "sei o que é, sei para que serve"
- [ ] Tenho 3 casos práticos na ponta da língua

### Materiais Prontos
- [ ] Mini-portfólio: 1 planilha Excel com dashboard (mesmo que simples)
- [ ] 30 termos técnicos definidos
- [ ] 3 perguntas para o gestor
- [ ] Currículo adaptado para Back Office Analítico

---

## 🏷️ Tags para Notion/Obsidian
`#backoffice` `#wealth-management` `#entrevista` `#estudos` `#carreira`

---

## 📌 Dicas de Ouro para a Entrevista
1. **Não invente** — "Não sei, mas sei onde buscar / como validar"
2. **Processo > Ferramenta** — Foque no *porquê* da conciliação, não no Excel
3. **Dados sujos são a norma** — Mostre que espera isso e tem método
4. **Wealth = Atendimento + Técnica** — Cite "experiência do cliente" e "qualidade da entrega"
5. **Pergunte no final:** "Qual o maior gargalo da área hoje?" / "Como medem qualidade dos relatórios?"

---

> **Lembrete:** Em 6 dias você não vira especialista. Vira alguém que *entende o jogo*, fala a língua e demonstra capacidade de aprender rápido. Isso vale mais que decorar fórmulas.

**Boa sorte! 🚀**