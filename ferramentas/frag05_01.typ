%%% BEFORE_CHAPTER_END: == Projeto 1 --- Dashboard Macroeconômico do Brasil
#align(center)[
  #text(size: 11pt, fill: luma(90))[Projetos de portfólio e de TCC, com laboratórios executáveis offline]
]

#v(0.5em)
#outline(title: [Sumário], depth: 2)

#pagebreak()

== Como Usar Esta Apostila
<como-usar-esta-apostila>
Os projetos desta apostila dependem de #strong[APIs externas] (Banco Central, Banco Mundial): bom para portfólio, mas
inconveniente para estudo --- sem internet ou sem as bibliotecas, nada roda. Por isso cada projeto ganha, ao final, um
#strong[laboratório offline]: um bloco de código #emph[executado] (com saídas reais, semente fixa) que usa os dados deste repositório
(`selic_meta.json`, `ipca_12m.json`, `ipca_abertura_grupos.csv`, `taylor_rule_series.csv`) ou dados simulados com mecanismo
conhecido. O laboratório ensina a #strong[ler os resultados] --- o que o script do projeto não faz sozinho --- e destaca as armadilhas de
interpretação. Os #strong[Desafios] de cada projeto continuam sem solução: o laboratório complementa, não resolve.

#exemplo("modelo")[Um laboratório executado com a interpretação.]

#intuicao[A ideia econômica por trás do número.]

#teoria("modelo")[A dedução ou o resultado formal por trás do método.]

#atencao[Uma armadilha de interpretação que invalida conclusões.]

#mercado[Como o projeto se conecta a um trabalho real de economista.]

```python
import statsmodels.api as sm
import matplotlib.dates as mdates

def ler_bcb(caminho):
    d = pd.read_json(caminho, dtype=False)
    d["data"] = pd.to_datetime(d["data"], format="%d/%m/%Y")
    return d.set_index("data")["valor"].astype(float)

sel5, ip5 = ler_bcb("selic_meta.json"), ler_bcb("ipca_12m.json")
tay5 = pd.read_csv("taylor_rule_series.csv", parse_dates=["data"], index_col="data")
print(f"Selic: {len(sel5)} dias | IPCA 12m: {len(ip5)} meses | Taylor: {len(tay5)} meses")
```
%%% END

%%% BEFORE_CHAPTER_END: == Projeto 2 --- Análise de Convergência de Renda
#exemplo("laboratório do Projeto 1: um painel de indicadores com sinal e tendência")[
  Um dashboard útil não é uma coleção de gráficos: é uma #strong[tabela de decisão] que diz, para cada indicador, onde está, como
  se moveu e para onde aponta. O código monta o painel com os dados reais do repositório:
]

```python
juro_real5 = ((1 + sel5.resample("MS").last() / 100) / (1 + ip5 / 100) - 1).dropna() * 100
painel = pd.DataFrame({
    "Selic meta (% a.a.)": sel5.resample("MS").last().reindex(ip5.index),
    "IPCA 12m (%)": ip5,
    "Juro real ex-post (%)": juro_real5,
})
linhas = []
for nome_i, serie_i in painel.items():
    ultimo, ha_12m = serie_i.iloc[-1], serie_i.iloc[-13]
    tendencia = "alta" if ultimo - serie_i.iloc[-4] > 0.15 else ("queda" if ultimo - serie_i.iloc[-4] < -0.15 else "estável")
    linhas.append((nome_i, ultimo, ultimo - ha_12m, serie_i.min(), serie_i.max(), tendencia))
resumo5 = pd.DataFrame(linhas, columns=["indicador", "último", "var. 12m (p.p.)", "mínimo", "máximo", "tendência 3m"]).set_index("indicador")
print(f"Referência: {painel.index[-1]:%m/%Y}")
print(resumo5.round(2).to_string())
```

#intuicao[
  A coluna #emph[tendência] resume a direção dos últimos três meses; #emph[var. 12m] mostra o movimento de um ano, e #emph[mín./máx.] contextualiza
  o valor na série. Um dashboard bom permite responder "isso é alto ou baixo?" sem abrir outro arquivo. O #strong[juro real ex-post] usa a
  inflação já realizada; uma versão #emph[ex-ante] usaria a expectativa de inflação (Focus), mais relevante para decisões de investimento.
]

#atencao[
  #strong[Alinhe as frequências antes de comparar.] A Selic é diária e o IPCA é mensal: compará-los exige reamostrar (`resample`) ou
  casar por data (`merge_asof`). E #strong[defasagem de divulgação]: o IPCA de um mês sai no início do mês seguinte, de modo que o
  último ponto do IPCA é sempre mais antigo que o da Selic --- o painel precisa deixar explícita a #emph[data de referência] de cada indicador.
]

%%% BEFORE_CHAPTER_END: == Projeto 3 --- Curva de Kuznets Ambiental
#teoria("convergência beta e sigma, e a velocidade de convergência")[
  A hipótese de #strong[convergência beta (absoluta)] diz que economias mais pobres crescem mais rápido, de modo que na regressão
  $g_i = alpha + beta ln(y_(i,0)) + epsilon_i$ o coeficiente $beta$ é #strong[negativo]. Já a #strong[convergência sigma] exige que a
  #emph[dispersão] da renda entre países #emph[diminua] ao longo do tempo (desvio padrão de $ln y$ cai). Beta é condição #emph[necessária]
  (mas não suficiente) para sigma: choques podem reabrir a dispersão. Da regressão sai a #strong[velocidade de convergência] $lambda$ e a
  #strong[meia-vida] (tempo para eliminar metade da distância ao estado estacionário): se $g$ é o crescimento médio anual em $T$ anos,
  $beta = -(1 - e^(-lambda T))/T$, portanto $lambda = -ln(1 + beta T)/T$ e a meia-vida é $ln 2/lambda$.
]

```python
rng_c = np.random.default_rng(100)
n_pc = 60
ln_y0 = rng_c.normal(8.5, 0.9, n_pc)                                        # ln da renda per capita inicial
beta_v, T_c = -0.015, 20
cresc_aa = 0.15 + beta_v * ln_y0 + rng_c.normal(0, 0.004, n_pc)                # crescimento médio anual (decimal)
modelo_c = sm.OLS(cresc_aa, sm.add_constant(ln_y0)).fit()
b_c = modelo_c.params[1]
lam = -np.log(1 + b_c * T_c) / T_c
print(f"beta estimado = {b_c:.4f} (verdadeiro {beta_v}) | p-valor = {modelo_c.pvalues[1]:.1e} | R² = {modelo_c.rsquared:.2f}")
print(f"Velocidade de convergência lambda = {lam * 100:.2f}% ao ano | meia-vida = {np.log(2) / lam:.0f} anos")

ln_y_final = ln_y0 + cresc_aa * T_c                                          # ln da renda ao fim de T anos
print(f"Dispersão de ln y: inicial = {ln_y0.std():.3f} | final = {ln_y_final.std():.3f} -> {'convergência sigma' if ln_y_final.std() < ln_y0.std() else 'sem convergência sigma'}")
```

#atencao[
  #strong[Convergência absoluta raramente se verifica em amostras amplas de países]: sem controlar por investimento, capital humano e
  instituições, o $beta$ costuma ser próximo de zero. A #strong[convergência condicional] (controlando por determinantes do estado estacionário)
  é a que a evidência empírica sustenta, com velocidades de cerca de 2% ao ano --- próximas da do exemplo simulado (1,7%). Com dados reais, desconfie
  de $beta$ muito negativo calculado sem controles.
]

%%% BEFORE_CHAPTER_END: == Projeto 4 --- Modelo de Previsão de Inflação
#teoria("o ponto de inflexão da curva e o risco de extrapolar")[
  A especificação quadrática $y = alpha + beta_1 x + beta_2 x^2 + epsilon$ com $beta_1 > 0$ e $beta_2 < 0$ gera um U invertido, com ponto de
  máximo em $x^* = -beta_1/(2 beta_2)$. Duas cautelas essenciais. #strong[(1)] O teste da hipótese de U invertido exige
  $beta_2 < 0$ #emph[significativo] e $x^*$ #emph[dentro do intervalo observado] dos dados: se o ponto de inflexão está acima do maior $x$ da amostra,
  o que se observa é só a parte ascendente --- e a "curva" é uma extrapolação. #strong[(2)] O ponto de inflexão tem incerteza própria
  (é uma razão de coeficientes): reporte um intervalo (método delta ou bootstrap), não só o valor.
]

```python
rng_k = np.random.default_rng(111)
n_k = 120
pib_pc = rng_k.uniform(1, 40, n_k)                                          # PIB per capita (milhares de US$)
emissao = 0.5 + 0.9 * pib_pc - 0.015 * pib_pc ** 2 + rng_k.normal(0, 1.5, n_k)
Xk = sm.add_constant(np.column_stack([pib_pc, pib_pc ** 2]))
mk = sm.OLS(emissao, Xk).fit()
b1, b2 = mk.params[1], mk.params[2]
pico_x = -b1 / (2 * b2)

rng_boot = np.random.default_rng(7)
picos = []
for _ in range(1500):
    idx = rng_boot.integers(0, n_k, n_k)
    mb = sm.OLS(emissao[idx], Xk[idx]).fit()
    picos.append(-mb.params[1] / (2 * mb.params[2]))
print(f"b1 = {b1:.3f}, b2 = {b2:.4f} (p = {mk.pvalues[2]:.1e}) | ponto de inflexão = {pico_x:.1f} mil US$ (verdadeiro: {0.9 / (2 * 0.015):.0f})")
print(f"IC 95% bootstrap do ponto de inflexão: ({np.percentile(picos, 2.5):.1f}, {np.percentile(picos, 97.5):.1f}) | maior PIB per capita da amostra: {pib_pc.max():.1f}")
print("O ponto de inflexão está", "DENTRO" if pico_x < pib_pc.max() else "FORA", "do intervalo observado dos dados")
```

%%% BEFORE_CHAPTER_END: == Projeto 5 --- Regra de Taylor
#teoria("sazonalidade, decomposição e diagnóstico dos resíduos de um modelo de previsão")[
  O IPCA mensal tem #strong[tendência] (nível de inflação), #strong[sazonalidade] (padrões que se repetem a cada 12 meses, como reajustes
  de início de ano) e #strong[ruído]. A decomposição separa as três partes. Um bom modelo de previsão deixa resíduos que parecem
  #strong[ruído branco]: sem autocorrelação, com média zero. O teste de #strong[Ljung-Box] verifica a ausência de autocorrelação nos resíduos; se
  rejeitar, o modelo deixou estrutura temporal sem explicar. O código simula um IPCA mensal com sazonalidade e persistência, decompõe e testa
  os resíduos de um SARIMA:
]

```python
from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.statespace.sarimax import SARIMAX
from statsmodels.stats.diagnostic import acorr_ljungbox
rng_s = np.random.default_rng(77)
meses = pd.date_range("2015-01-01", periods=120, freq="MS")
sazonal = np.tile([0.25, 0.30, 0.10, 0.00, -0.05, -0.05, -0.10, -0.15, -0.05, 0.05, 0.10, 0.25], 10)   # padrão que se repete
base = np.zeros(120)
for t in range(1, 120):
    base[t] = 0.5 + 0.6 * (base[t - 1] - 0.5) + rng_s.normal(0, 0.12)
ipca_sim = pd.Series(base + sazonal, index=meses, name="ipca_mensal")
dec = seasonal_decompose(ipca_sim, model="additive", period=12)
print("Padrão sazonal estimado por mês (jan..dez):", np.round(dec.seasonal[:12].values, 2).tolist())
print(f"Variância explicada pela sazonalidade: {dec.seasonal.var() / ipca_sim.var():.0%} | pela tendência: {dec.trend.dropna().var() / ipca_sim.var():.0%}")

ajuste_s = SARIMAX(ipca_sim, order=(1, 0, 0), seasonal_order=(0, 1, 1, 12)).fit(disp=False)
lb = acorr_ljungbox(ajuste_s.resid[12:], lags=[12], return_df=True)
print(f"AIC do SARIMA(1,0,0)(0,1,1)12: {ajuste_s.aic:.1f} | Ljung-Box (12 defasagens): p = {lb['lb_pvalue'].iloc[0]:.3f} -> "
      f"{'resíduos compatíveis com ruído branco' if lb['lb_pvalue'].iloc[0] > 0.05 else 'sobrou estrutura nos resíduos'}")
prev = ajuste_s.get_forecast(12)
ic = prev.conf_int()
print(f"Previsão para os próximos 12 meses: média = {prev.predicted_mean.mean():.2f}% a.m. | intervalo de 95% no 12º mês: ({ic.iloc[-1, 0]:.2f}, {ic.iloc[-1, 1]:.2f})")
```

#atencao[
  #strong[Previsão sem incerteza é incompleta.] Reporte #emph[sempre] o intervalo de previsão; ele se alarga com o horizonte. E a
  avaliação deve ser #strong[fora da amostra] e respeitar o tempo (treinar no passado, testar no futuro): ajuste bom em dados já vistos
  não significa previsão boa.
]

%%% BEFORE_CHAPTER_END: == Projeto 6 --- Análise de Crise Cambial
#exemplo("laboratório do Projeto 5: decompondo a Selic implícita da regra de Taylor com dados reais")[
  A regra usada no repositório é $i^* = r^* + pi + 0,5 (pi - pi^*)$, com $r^*$ a taxa neutra, $pi$ a inflação em 12 meses e $pi^*$ a meta. Ela
  se lê como #strong[três blocos]: o juro neutro, a compensação da inflação corrente e a reação ao desvio da meta. O
  #strong[princípio de Taylor] exige que o coeficiente total sobre a inflação seja #strong[maior que 1] (aqui, $1 + 0,5 = 1,5$): o juro #emph[nominal] sobe
  mais que um para um com a inflação, de modo que o juro #emph[real] também sobe e a política é de fato contracionista. A decomposição, a partir da série do repositório:
]

```python
ultimo_t = tay5.iloc[-1]
bloco_neutro = ultimo_t["r_star"]
bloco_inflacao = ultimo_t["ipca12m"]
bloco_desvio = 0.5 * (ultimo_t["ipca12m"] - ultimo_t["meta"])
print(f"Referência {tay5.index[-1]:%m/%Y}: Selic implícita = {ultimo_t['taylor_selic']:.2f}% = neutro {bloco_neutro:.2f} + inflação {bloco_inflacao:.2f} + reação ao desvio {bloco_desvio:.2f}")
print(f"Selic efetiva = {ultimo_t['selic']:.2f}% | gap = {ultimo_t['gap_pp']:+.2f} p.p. (política {'mais apertada' if ultimo_t['gap_pp'] > 0 else 'mais frouxa'} que a regra)")

print("\nSensibilidade da Selic implícita ao coeficiente de reação à inflação (a):")
for a_coef in (0.0, 0.5, 1.0, 1.5):
    implicita = tay5["r_star"] + tay5["ipca12m"] + a_coef * (tay5["ipca12m"] - tay5["meta"])
    print(f"  a = {a_coef:.1f} (coeficiente total {1 + a_coef:.1f}) -> Selic implícita média = {implicita.mean():.2f}% | gap médio = {(tay5['selic'] - implicita).mean():+.2f} p.p.")
print(f"\nPrincípio de Taylor satisfeito com a = 0,5? coeficiente total = {1 + 0.5} {'> 1: sim' if 1 + 0.5 > 1 else '<= 1: não'}")
```

#atencao[
  A regra "simples" (sem hiato do produto) é uma #strong[simplificação]: o Copom também olha o hiato, as expectativas e o ambiente
  externo. O gap positivo persistente sugere #emph[política mais apertada que a sugerida pela regra], mas não prova erro do Banco Central:
  a regra tem incerteza forte sobre $r^*$ (inobservável) e sobre os pesos. Use-a como #strong[referência de calibragem], não como veredito.
]

%%% BEFORE_CHAPTER_END: == Projeto 7 --- TCC Estrutura Completa
#teoria("o índice de pressão do mercado de câmbio (EMP): construção passo a passo")[
  Uma crise cambial é um episódio em que a pressão por depreciação é #emph[extrema], seja ela absorvida pela taxa de câmbio (a moeda cai), pelas reservas (o
  Banco Central vende dólares) ou pelos juros (sobem para defender a moeda). O índice EMP combina os três, padronizando cada componente pelo
  seu desvio padrão (para que nenhum domine só por escala):

  $ "EMP"_t = Delta e_t/e_(t-1) dot 1/(sigma_e) - Delta "Res"_t/"Res"_(t-1) dot 1/(sigma_"R") $

  O sinal negativo nas reservas reflete que #emph[queda] de reservas indica pressão. Os pesos $1\/sigma$ equalizam a contribuição de cada componente.
  Um episódio é classificado como crise quando o EMP supera a média por uma quantidade de desvios padrão. O código constrói o índice com
  dados simulados que contêm um #strong[episódio de crise plantado], para ver o mecanismo de composição (a escolha do limiar fica como Desafio do projeto):
]

```python
rng_emp = np.random.default_rng(55)
n_m = 120
var_cambio = rng_emp.normal(0.003, 0.012, n_m)
var_reservas = rng_emp.normal(0.002, 0.008, n_m)
var_cambio[80:83] += [0.09, 0.12, 0.05]                                    # depreciação forte
var_reservas[80:83] -= [0.03, 0.05, 0.02]                                  # perda de reservas
sig_e, sig_r = var_cambio.std(ddof=1), var_reservas.std(ddof=1)
emp = var_cambio / sig_e - var_reservas / sig_r
print(f"Pesos: 1/sigma_e = {1 / sig_e:.1f} | 1/sigma_R = {1 / sig_r:.1f} (a componente de menor variabilidade pesa mais)")
print(f"EMP: média = {emp.mean():.2f} | desvio padrão = {emp.std(ddof=1):.2f}")
top = np.argsort(emp)[-4:][::-1]
print("Quatro maiores valores do EMP (mês, valor):", [(int(i), round(float(emp[i]), 1)) for i in top])
print("Os picos coincidem com o episódio plantado (meses 80 a 82):", set(top[:3]) == {80, 81, 82} or all(80 <= i <= 83 for i in top[:3]))
```

%%% BEFORE_CHAPTER_END: == Checklist para seu TCC
#exemplo("apresentando resultados como num TCC: tabela de modelos lado a lado")[
  Em um trabalho acadêmico, os resultados de várias especificações aparecem numa #strong[única tabela], com os coeficientes e (entre parênteses) os erros-padrão,
  asteriscos de significância e as estatísticas de ajuste. O `summary_col` do statsmodels monta isso. Exemplo com três especificações
  sobre dados simulados de salários:
]

```python
from statsmodels.iolib.summary2 import summary_col
rng_t = np.random.default_rng(91)
n_t = 800
educ_t = rng_t.integers(6, 20, n_t).astype(float)
exp_t = rng_t.uniform(0, 30, n_t)
homem = rng_t.integers(0, 2, n_t).astype(float)
lw_t = 0.6 + 0.085 * educ_t + 0.03 * exp_t - 0.0005 * exp_t ** 2 + 0.12 * homem + rng_t.normal(0, 0.4, n_t)
d_t = pd.DataFrame({"lw": lw_t, "educ": educ_t, "exp": exp_t, "exp2": exp_t ** 2, "homem": homem})
m1 = sm.OLS(d_t["lw"], sm.add_constant(d_t[["educ"]])).fit()
m2 = sm.OLS(d_t["lw"], sm.add_constant(d_t[["educ", "exp", "exp2"]])).fit()
m3 = sm.OLS(d_t["lw"], sm.add_constant(d_t[["educ", "exp", "exp2", "homem"]])).fit()
tabela = summary_col([m1, m2, m3], stars=True, model_names=["(1)", "(2)", "(3)"], float_format="%.3f",
                     info_dict={"N": lambda x: f"{int(x.nobs)}"})
print(tabela)
```

#intuicao[
  Observe o coeficiente de #emph[educ] ao longo das colunas: ele muda ao incluir controles. Se ele fosse #strong[estável] entre especificações plausíveis, seria uma
  evidência de #emph[robustez]; se mudasse muito, o resultado depende do modelo --- e isso precisa ser discutido, não escondido. É a
  base da seção de #strong[robustez] de um TCC.
]

#teoria("como escrever a seção de metodologia: um modelo de parágrafo")[
  #emph["Estima-se a equação de Mincer em sua forma log-linear, $ln(w_i) = beta_0 + beta_1 "educ"_i + beta_2 "exp"_i + beta_3 "exp"_i^2 + epsilon_i$, por
  Mínimos Quadrados Ordinários, com erros-padrão robustos à heterocedasticidade (HC3). A experiência entra em forma quadrática para captar os
  rendimentos decrescentes. Como robustez, reestima-se o modelo sem a experiência ao quadrado e com a dummy de sexo, e reporta-se a estabilidade
  de $beta_1$. A principal ameaça à interpretação causal é a omissão de habilidade não observada, que tende a viesar $beta_1$ para cima; discute-se o sentido
  desse viés na seção de limitações."]

  Estrutura de um bom parágrafo: #strong[modelo] (equação), #strong[estimador e correções] (por que e como), #strong[escolhas de especificação]
  (justificadas), #strong[robustez] e #strong[ameaças à validade]. Cada decisão técnica tem uma justificativa econômica ou estatística explícita.
]

%%% BEFORE_CHAPTER_END: == Conclusão
#strong[Reprodutibilidade em uma célula.] Antes de entregar qualquer projeto, registre o ambiente e fixe as sementes. O trecho abaixo,
colocado no topo do script principal, imprime as versões usadas e garante que a aleatoriedade seja repetível:

```python
import sys, platform, random
random.seed(42); np.random.seed(42)
pacotes = {"pandas": pd.__version__, "numpy": np.__version__, "statsmodels": sm.__version__}
print(f"Python {sys.version.split()[0]} em {platform.system()} | " + " | ".join(f"{k} {v}" for k, v in pacotes.items()))
print("Sementes fixadas: random e numpy = 42 (registre-as no README)")
```

#figure(
  align(center)[#table(
    columns: (4%, 38%, 58%),
    align: (center, left, left),
    table.header([\#], [Erro], [Como evitar],),
    [1], [Dashboard sem data de referência de cada indicador], [Mostre a data e a defasagem de divulgação],
    [2], [Comparar variáveis de frequências diferentes sem alinhar], [`resample` ou `merge_asof`],
    [3], [Afirmar convergência sem controles], [Convergência condicional; reporte a velocidade e a meia-vida],
    [4], [Curva de Kuznets com ponto de inflexão fora da amostra], [Verifique `x*` dentro do intervalo observado; intervalo de confiança],
    [5], [Previsão sem intervalo e sem avaliação fora da amostra], [Intervalo de previsão e treino/teste no tempo],
    [6], [Resíduos autocorrelacionados ignorados (Ljung-Box)], [Ajustar a ordem do modelo],
    [7], [Tomar a regra de Taylor como veredito sobre o Banco Central], [Tratar como referência; discutir incerteza de $r^*$],
    [8], [Índice composto sem padronizar os componentes], [Pesos inversos ao desvio padrão],
    [9], [Apresentar uma só especificação], [Tabela com várias especificações e discussão de robustez],
    [10], [Dados e sementes não registrados], [`requirements.txt`, sementes, README, scripts numerados],
  )]
  , kind: table
  )
%%% END
