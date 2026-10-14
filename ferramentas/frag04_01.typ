%%% BEFORE_CHAPTER_END: == Capítulo 1 --- O que é Econometria
#align(center)[
  #text(size: 11pt, fill: luma(90))[Teoria, demonstrações por simulação e diagnóstico, com foco em economia]
]

#v(0.5em)
#outline(title: [Sumário], depth: 3)

#pagebreak()

== Como Usar Esta Apostila
<como-usar-esta-apostila>
A quarta apostila da série trata de #strong[inferência estatística aplicada a dados econômicos]. Pressupõe as Apostilas 1
a 3 e noções de estatística (média, variância, distribuição normal). O desafio da econometria não é rodar a regressão ---
isso é uma linha de código --- e sim saber #emph[quando o resultado merece confiança]. Por isso, ao final de cada capítulo
há um bloco de #strong[aprofundamento] que usa #strong[simulação de Monte Carlo]: criamos dados cujo mecanismo verdadeiro
conhecemos, repetimos o experimento milhares de vezes e #emph[vemos] o que acontece com o estimador. Assim, "viés",
"erro-padrão", "erro tipo I" e "multicolinearidade" deixam de ser palavras e viram números que você pode reproduzir (todos
os resultados impressos vêm da execução do código, com semente fixa).

#exemplo("modelo")[Um experimento numérico, executado, com a interpretação.]

#intuicao[A ideia por trás do conceito, sem fórmula.]

#teoria("modelo")[A dedução ou o resultado formal.]

#atencao[Um erro que gera conclusões erradas com cara de rigor.]

#mercado[Como o conceito aparece em trabalhos aplicados e em análises de política econômica.]

#strong[O fluxo de uma análise econométrica.] (1) Formular a #emph[pergunta] e o #emph[mecanismo]; (2) escolher o #emph[modelo] e as
variáveis; (3) coletar e limpar os dados; (4) #emph[estimar]; (5) #emph[diagnosticar] as premissas; (6) corrigir
(erros robustos, outras variáveis, transformações); (7) #emph[interpretar] com cuidado (efeito, incerteza, causalidade).
Os passos 5 e 7 são os que separam análise de ritual.
%%% END

%%% BEFORE_CHAPTER_END: == Capítulo 2 --- O Modelo de Regressão Linear Simples
#teoria("OLS em forma matricial: o que o `summary()` faz por baixo")[
  Para o modelo $y = X beta + epsilon$, com $X$ a matriz de regressores (incluindo uma coluna de 1 para o intercepto), o estimador
  de Mínimos Quadrados Ordinários minimiza a soma dos quadrados dos resíduos, $min_beta (y - X beta)^T (y - X beta)$. A condição de
  primeira ordem dá as #strong[equações normais] $X^T X hat(beta) = X^T y$, e portanto

  $ hat(beta) = (X^T X)^(-1) X^T y quad "e" quad hat("Var")(hat(beta)) = hat(sigma)^2 (X^T X)^(-1), quad hat(sigma)^2 = (hat(epsilon)^T hat(epsilon))/(n - k) $

  No caso simples ($y = beta_0 + beta_1 x$), isso se reduz a
  $hat(beta)_1 = "Cov"(x, y) / "Var"(x)$ e $hat(beta)_0 = bar(y) - hat(beta)_1 bar(x)$. O `statsmodels` faz exatamente essas contas;
  o código abaixo refaz tudo "à mão" com NumPy para demonstrar que não há mistério.
]

```python
import statsmodels.api as sm
rng_e = np.random.default_rng(10)
n_e = 200
renda_e = rng_e.uniform(2, 20, n_e)                                  # renda em milhares de R$
consumo_e = 1.5 + 0.8 * renda_e + rng_e.normal(0, 1.2, n_e)         # mecanismo verdadeiro: b0 = 1.5, b1 = 0.8

X_e = np.column_stack([np.ones(n_e), renda_e])
beta_e = np.linalg.solve(X_e.T @ X_e, X_e.T @ consumo_e)             # equações normais
resid_e = consumo_e - X_e @ beta_e
sigma2_e = resid_e @ resid_e / (n_e - 2)
ep_e = np.sqrt(np.diag(sigma2_e * np.linalg.inv(X_e.T @ X_e)))

ajuste_e = sm.OLS(consumo_e, X_e).fit()
print("À mão       : b0 = %.4f, b1 = %.4f | erros-padrão: %.4f, %.4f" % (*beta_e, *ep_e))
print("statsmodels : b0 = %.4f, b1 = %.4f | erros-padrão: %.4f, %.4f" % (*ajuste_e.params, *ajuste_e.bse))
print("Cov(x,y)/Var(x) =", round(np.cov(renda_e, consumo_e, ddof=1)[0, 1] / np.var(renda_e, ddof=1), 4))
```

%%% BEFORE_CHAPTER_END: == Capítulo 3 --- As Premissas de Gauss-Markov e o Teorema BLUE
#teoria("o que significa \"não viesado\" e \"erro-padrão\": a distribuição amostral")[
  O estimador $hat(beta)_1$ é uma #strong[variável aleatória]: se coletássemos outra amostra, obteríamos outro valor. Dizer que o OLS
  é #strong[não viesado] é dizer que, #emph[na média sobre infinitas amostras], $E[hat(beta)_1] = beta_1$. O #strong[erro-padrão] é o desvio
  padrão desse estimador entre amostras. Como só temos uma amostra, o erro-padrão é #emph[estimado] pela fórmula; com simulação, podemos
  conferir se a fórmula acerta. O experimento: 3.000 amostras de 60 observações do mesmo mecanismo.
]

```python
rng_mc = np.random.default_rng(1)
b1_verdadeiro, n_mc, reps = 0.8, 60, 3000
b1_hat, ep_hat = np.empty(reps), np.empty(reps)
for r in range(reps):
    x = rng_mc.uniform(2, 20, n_mc)
    y = 1.5 + b1_verdadeiro * x + rng_mc.normal(0, 1.2, n_mc)
    Xm = np.column_stack([np.ones(n_mc), x])
    bh = np.linalg.solve(Xm.T @ Xm, Xm.T @ y)
    res = y - Xm @ bh
    b1_hat[r] = bh[1]
    ep_hat[r] = np.sqrt((res @ res / (n_mc - 2)) * np.linalg.inv(Xm.T @ Xm)[1, 1])
print(f"Verdadeiro: {b1_verdadeiro} | média das {reps} estimativas: {b1_hat.mean():.4f} (viés ≈ {b1_hat.mean() - b1_verdadeiro:+.4f})")
print(f"Desvio padrão REAL das estimativas: {b1_hat.std(ddof=1):.4f} | média do erro-padrão ESTIMADO: {ep_hat.mean():.4f}")
```

#intuicao[
  O OLS acerta #strong[em média] (viés quase zero) e o erro-padrão calculado pela fórmula reproduz a dispersão #emph[real] das
  estimativas: é por isso que se pode confiar na inferência (intervalos e testes) #strong[quando as premissas valem]. Os próximos
  experimentos mostram o que acontece quando elas falham.
]

#exemplo("quando a premissa de linearidade falha: RESET e normalidade dos resíduos")[
  O verdadeiro efeito é #emph[quadrático] (retornos decrescentes), mas ajustamos uma reta. Dois diagnósticos formais: o teste
  #strong[RESET de Ramsey] (a forma funcional está correta?) e o de #strong[Jarque-Bera] (os resíduos são normais?).
]

```python
from statsmodels.stats.diagnostic import linear_reset
from statsmodels.stats.stattools import jarque_bera
rng_q = np.random.default_rng(5)
x_q = rng_q.uniform(0, 10, 300)
y_q = 2 + 3 * x_q - 0.25 * x_q ** 2 + rng_q.normal(0, 1, 300)
reta = sm.OLS(y_q, sm.add_constant(x_q)).fit()
curva = sm.OLS(y_q, sm.add_constant(np.column_stack([x_q, x_q ** 2]))).fit()
print(f"R² da reta: {reta.rsquared:.3f} | R² do modelo quadrático: {curva.rsquared:.3f}")
print(f"RESET (reta): p-valor = {linear_reset(reta, power=2, use_f=True).pvalue:.2e} -> {'rejeita' if linear_reset(reta, power=2, use_f=True).pvalue < 0.05 else 'não rejeita'} a forma linear")
print(f"RESET (quadrático): p-valor = {linear_reset(curva, power=2, use_f=True).pvalue:.3f}")
print(f"Jarque-Bera dos resíduos da reta: p = {jarque_bera(reta.resid)[1]:.3f} | do modelo quadrático: p = {jarque_bera(curva.resid)[1]:.3f}")
```

%%% BEFORE_CHAPTER_END: == Capítulo 4 --- Interpretando a Saída da Regressão
#teoria("R², F, t e intervalo de confiança: refazendo o `summary()` na mão")[
  A variação total se decompõe em explicada e residual: $"SST" = "SSE" + "SSR"$ (soma dos quadrados total = explicada + dos
  resíduos). Daí $R^2 = "SSE"/"SST" = 1 - "SSR"/"SST"$ e $R^2_("aj") = 1 - (1 - R^2)(n - 1)/(n - k)$, que penaliza regressores
  inúteis. A estatística $t = hat(beta)_j / "ep"(hat(beta)_j)$ testa $H_0: beta_j = 0$; o #strong[intervalo de confiança] de 95% é
  $hat(beta)_j plus.minus t_(0,975; n-k) dot "ep"(hat(beta)_j)$; a estatística $F$ testa a significância #emph[conjunta]:
  $F = ("SSE"\/(k-1))/("SSR"\/(n-k))$. Tudo calculável com poucas linhas:
]

```python
from scipy import stats as sps
sst = ((consumo_e - consumo_e.mean()) ** 2).sum()
ssr = (resid_e ** 2).sum()
sse = sst - ssr
k_e = 2
r2 = sse / sst
r2_aj = 1 - (1 - r2) * (n_e - 1) / (n_e - k_e)
t_b1 = beta_e[1] / ep_e[1]
p_b1 = 2 * (1 - sps.t.cdf(abs(t_b1), n_e - k_e))
ic = (beta_e[1] - sps.t.ppf(0.975, n_e - k_e) * ep_e[1], beta_e[1] + sps.t.ppf(0.975, n_e - k_e) * ep_e[1])
f_stat = (sse / (k_e - 1)) / (ssr / (n_e - k_e))
print(f"SST = {sst:.1f} = SSE {sse:.1f} + SSR {ssr:.1f} | R² = {r2:.4f} (statsmodels: {ajuste_e.rsquared:.4f}) | R² ajustado = {r2_aj:.4f}")
print(f"t(b1) = {t_b1:.2f} (statsmodels: {ajuste_e.tvalues[1]:.2f}) | p = {p_b1:.2e} | IC 95%: ({ic[0]:.4f}, {ic[1]:.4f})")
print(f"F = {f_stat:.1f} (statsmodels: {ajuste_e.fvalue:.1f}) | note: com um só regressor, F = t² = {t_b1 ** 2:.1f}")
```

#atencao[
  #strong[R² alto não é sinônimo de bom modelo.] Regredir duas séries que crescem no tempo produz R² próximo de 1 sem qualquer relação
  causal (capítulo 14). E um R² baixo não invalida o resultado: em dados micro (renda individual), R² de 0,10 a 0,30 é comum e os
  coeficientes podem ser estimados com precisão. O R² mede #emph[ajuste]; a causalidade e a adequação do modelo se julgam por outros meios.
]

%%% BEFORE_CHAPTER_END: == Capítulo 5 --- Testes de Hipótese em Regressão
#teoria("erro tipo I, poder e a distribuição do p-valor sob a hipótese nula")[
  Se $H_0$ é #emph[verdadeira], o p-valor tem distribuição #strong[uniforme] em $[0, 1]$: em 5% dos casos ele cai abaixo de 0,05 por puro
  acaso. É o #strong[erro tipo I] --- rejeitar uma hipótese nula verdadeira --- e sua taxa é, por construção, o nível de significância
  $alpha$. O #strong[poder] do teste é a probabilidade de rejeitar $H_0$ quando ela é #emph[falsa]; cresce com o tamanho do efeito, o
  tamanho da amostra e diminui com o ruído. Simulação: um regressor #strong[sem nenhum efeito] (erro tipo I) e outros com efeitos
  crescentes (poder), em amostras de 100:
]

```python
rng_p = np.random.default_rng(2)
reps_p, n_p = 4000, 100
for efeito in (0.0, 0.1, 0.2, 0.4):
    rejeita = 0
    for _ in range(reps_p):
        x = rng_p.normal(size=n_p)
        y = efeito * x + rng_p.normal(size=n_p)
        xc = x - x.mean()
        b = (xc @ (y - y.mean())) / (xc @ xc)
        res = y - y.mean() - b * xc
        ep = np.sqrt((res @ res / (n_p - 2)) / (xc @ xc))
        rejeita += abs(b / ep) > sps.t.ppf(0.975, n_p - 2)
    rot = "erro tipo I (efeito nulo)" if efeito == 0 else "poder"
    print(f"efeito verdadeiro = {efeito:.1f} -> rejeita H0 em {rejeita / reps_p:.1%} das amostras ({rot})")
```

#exemplo("o problema das comparações múltiplas")[
  Se você testa 20 variáveis #strong[sem nenhum efeito real] a 5% de significância, a probabilidade de encontrar #emph[pelo menos uma]
  "significativa" é $1 - 0,95^20 approx 64%$. É assim que "mineração de dados" produz "descobertas" espúrias. Correções simples: o ajuste de
  #strong[Bonferroni] (usar $alpha\/m$) ou, melhor, #strong[pré-registrar] as hipóteses antes de olhar os dados.
]

```python
print(f"P(ao menos 1 falso positivo em 20 testes a 5%) = {1 - 0.95 ** 20:.1%}")
print(f"Com Bonferroni (alfa = 0,05/20 = {0.05 / 20:.4f}): {1 - (1 - 0.05 / 20) ** 20:.1%}")
```

%%% BEFORE_CHAPTER_END: == Capítulo 6 --- Regressão Múltipla
#teoria("o significado de \"mantendo as demais constantes\": o teorema de Frisch-Waugh-Lovell")[
  Em $y = beta_0 + beta_1 x_1 + beta_2 x_2 + epsilon$, o coeficiente $beta_1$ é o efeito de $x_1$ #emph[mantido $x_2$ constante].
  O teorema de Frisch-Waugh-Lovell mostra o que isso significa: $hat(beta)_1$ pode ser obtido em três passos --- (1) regredir $y$ em
  $x_2$ e guardar os resíduos (a parte de $y$ não explicada por $x_2$); (2) regredir $x_1$ em $x_2$ e guardar os resíduos (a parte de $x_1$ não
  explicada por $x_2$); (3) regredir um resíduo no outro. O coeficiente é o mesmo da regressão múltipla. Ou seja, a regressão múltipla
  "limpa" cada variável da influência das outras e usa só a variação restante:
]

```python
rng_f = np.random.default_rng(8)
n_f = 500
escolaridade = rng_f.normal(12, 3, n_f)
experiencia = 0.5 * escolaridade + rng_f.normal(10, 4, n_f)                 # correlacionada com escolaridade
log_salario = 0.5 + 0.09 * escolaridade + 0.03 * experiencia + rng_f.normal(0, 0.3, n_f)

multipla = sm.OLS(log_salario, sm.add_constant(np.column_stack([escolaridade, experiencia]))).fit()
res_y = sm.OLS(log_salario, sm.add_constant(experiencia)).fit().resid         # passo 1
res_x = sm.OLS(escolaridade, sm.add_constant(experiencia)).fit().resid        # passo 2
fwl = sm.OLS(res_y, res_x).fit()                                               # passo 3
simples = sm.OLS(log_salario, sm.add_constant(escolaridade)).fit()
print(f"Coeficiente de escolaridade -> múltipla: {multipla.params[1]:.5f} | Frisch-Waugh-Lovell: {fwl.params[0]:.5f} (idênticos)")
print(f"Regressão simples (sem controlar experiência): {simples.params[1]:.4f} | verdadeiro: 0.09 | correlação escolaridade-experiência: {np.corrcoef(escolaridade, experiencia)[0, 1]:.2f}")
print(f"R² múltipla: {multipla.rsquared:.3f} | R² ajustado: {multipla.rsquared_adj:.3f}")
```

%%% BEFORE_CHAPTER_END: == Capítulo 7 --- Correlação Não é Causalidade
#teoria("a fórmula do viés de variável omitida")[
  Suponha o modelo verdadeiro $y = beta_0 + beta_1 x + beta_2 z + epsilon$, mas o analista omite $z$ e regride $y$ só em $x$. O coeficiente
  estimado converge para

  $ hat(beta)_1^("curto") -> beta_1 + beta_2 dot (op("Cov")(x, z))/(op("Var")(x)) $

  O segundo termo é o #strong[viés]: o efeito omitido ($beta_2$) multiplicado pela relação entre a variável incluída e a omitida
  ($delta = "Cov"(x, z)/"Var"(x)$). O sinal do viés é o produto dos sinais de $beta_2$ e de $delta$; o viés some se $z$ não afeta $y$
  ($beta_2 = 0$) #emph[ou] se $z$ não se relaciona com $x$ ($delta = 0$). Simulação, com $beta_1 = 2$, $beta_2 = 3$ e correlação entre $x$ e $z$:
]

```python
rng_v = np.random.default_rng(4)
n_v = 5000
z = rng_v.normal(size=n_v)
x = 0.6 * z + rng_v.normal(scale=0.8, size=n_v)
y = 1 + 2 * x + 3 * z + rng_v.normal(size=n_v)
curta = sm.OLS(y, sm.add_constant(x)).fit()
longa = sm.OLS(y, sm.add_constant(np.column_stack([x, z]))).fit()
delta = np.cov(x, z)[0, 1] / np.var(x, ddof=1)
print(f"Modelo CURTO (omite z): b1 = {curta.params[1]:.3f} | modelo COMPLETO: b1 = {longa.params[1]:.3f} | verdadeiro: 2")
print(f"Viés previsto = b2 * Cov(x,z)/Var(x) = 3 x {delta:.3f} = {3 * delta:.3f} | viés observado = {curta.params[1] - 2:.3f}")
```

#exemplo("causalidade reversa e simultaneidade")[
  A regressão de gastos com segurança sobre criminalidade pode dar um coeficiente #emph[positivo] ("mais policiais, mais crime")
  porque a causalidade corre nos dois sentidos: o crime #emph[atrai] gastos. Quando $y$ também afeta $x$, o regressor fica correlacionado com
  o erro e o OLS é #strong[viesado e inconsistente] (violação da exogeneidade). Soluções vão além do OLS (variáveis instrumentais, experimentos naturais,
  diferenças em diferenças) e exigem pensar no #emph[desenho], não só no estimador.
]

%%% BEFORE_CHAPTER_END: == Capítulo 8 --- Multicolinearidade
#teoria("VIF e a inflação do erro-padrão")[
  A multicolinearidade #strong[não viesa] os coeficientes; ela #strong[infla seus erros-padrão]. O fator de inflação da variância do regressor
  $j$ é $"VIF"_j = 1/(1 - R_j^2)$, onde $R_j^2$ vem da regressão de $x_j$ nos demais regressores; então
  $"ep"(hat(beta)_j) approx sqrt("VIF"_j) times "ep"_("sem colinearidade")$. Um VIF de 10 multiplica o erro-padrão por $sqrt(10) approx 3,2$. O experimento
  varia a correlação entre dois regressores de 0 a 0,99:
]

```python
rng_m = np.random.default_rng(6)
n_m = 400
print(f"{'corr(x1,x2)':>12} {'VIF':>7} {'b1 (média)':>11} {'ep(b1) médio':>13}")
for rho in (0.0, 0.5, 0.9, 0.99):
    b_s, ep_s = [], []
    for _ in range(600):
        x1 = rng_m.normal(size=n_m)
        x2 = rho * x1 + np.sqrt(1 - rho ** 2) * rng_m.normal(size=n_m)
        y = 1 + 1.0 * x1 + 1.0 * x2 + rng_m.normal(size=n_m)
        ajuste = sm.OLS(y, sm.add_constant(np.column_stack([x1, x2]))).fit()
        b_s.append(ajuste.params[1]); ep_s.append(ajuste.bse[1])
    print(f"{rho:>12.2f} {1 / (1 - rho ** 2):>7.1f} {np.mean(b_s):>11.3f} {np.mean(ep_s):>13.4f}")
```

#intuicao[
  A média de $hat(beta)_1$ continua em 1,0 (sem viés), mas o erro-padrão explode quando as variáveis se confundem: o modelo "não
  sabe" qual das duas é responsável pelo efeito. É um problema de #emph[informação insuficiente], não de erro de método: a saída é mais
  dados, combinar as variáveis (índice) ou aceitar que só o efeito #emph[conjunto] é identificado.
]

%%% BEFORE_CHAPTER_END: == Capítulo 9 --- Heterocedasticidade
#teoria("por que os erros-padrão robustos importam: cobertura do intervalo de confiança")[
  Com heterocedasticidade ($"Var"(epsilon | x)$ varia com $x$), os coeficientes OLS continuam #strong[não viesados], mas a fórmula usual do
  erro-padrão fica #strong[errada], e os intervalos de confiança não cobrem o valor verdadeiro com a probabilidade anunciada. O erro-padrão
  robusto (White/HC) corrige. Para medir, simulamos 3.000 amostras com $"Var"(epsilon) prop x^2$ e contamos quantas vezes o
  intervalo de 95% #emph[contém] o verdadeiro $beta_1 = 1$ (a "cobertura" deveria ser 95%):
]

```python
rng_h = np.random.default_rng(12)
n_h, reps_h = 100, 3000
cobre_classico = cobre_robusto = 0
for _ in range(reps_h):
    x = rng_h.uniform(1, 10, n_h)
    y = 1 + 1.0 * x + rng_h.normal(0, 0.5 * x)                           # desvio padrão do erro cresce com x
    ajuste = sm.OLS(y, sm.add_constant(x)).fit()
    robusto = ajuste.get_robustcov_results(cov_type="HC3")
    cobre_classico += ajuste.conf_int()[1, 0] <= 1.0 <= ajuste.conf_int()[1, 1]
    cobre_robusto += robusto.conf_int()[1, 0] <= 1.0 <= robusto.conf_int()[1, 1]
print(f"Cobertura do IC de 95% com erro-padrão clássico: {cobre_classico / reps_h:.1%}")
print(f"Cobertura do IC de 95% com erro-padrão robusto (HC3): {cobre_robusto / reps_h:.1%}")
```

#intuicao[
  Com o erro-padrão clássico o intervalo "de 95%" cobre o valor verdadeiro em cerca de 93% das amostras: o nível anunciado não
  é o real. Com o robusto (HC3), a cobertura volta a ficar próxima de 95%. A diferença parece pequena aqui, mas cresce com a
  intensidade da heterocedasticidade e com a presença de pontos de alavanca.
]

#atencao[
  Erros-padrão robustos #strong[não corrigem viés], só a inferência. E há quem recomende usá-los #emph[sempre] em trabalho aplicado,
  porque quando a variância é constante eles perdem pouco, e quando não é, evitam conclusões erradas. O custo de usar o erro-padrão
  clássico "por padrão" sem checar é maior que o de usar o robusto sem necessidade.
]

%%% BEFORE_CHAPTER_END: == Capítulo 10 --- Variáveis Dummy e a Equação de Mincer
#teoria("a armadilha da dummy e a dummy como diferença de médias")[
  Com $G$ categorias, inclui-se #strong[$G - 1$ dummies] mais o intercepto: incluir todas as $G$ cria #strong[colinearidade perfeita] (a
  soma das dummies é igual à coluna de 1), e a matriz $X^T X$ deixa de ser inversível. Além disso, o coeficiente de uma dummy
  é simplesmente a #strong[diferença de médias] entre o grupo e a categoria de referência: uma regressão com uma só dummy reproduz o teste
  $t$ de duas amostras. A demonstração numérica:
]

```python
rng_d = np.random.default_rng(14)
n_d = 400
mulher = rng_d.integers(0, 2, n_d)
log_sal = 2.0 - 0.15 * mulher + rng_d.normal(0, 0.4, n_d)
df_d = pd.DataFrame({"log_sal": log_sal, "mulher": mulher, "homem": 1 - mulher})
ajuste_d = sm.OLS(df_d["log_sal"], sm.add_constant(df_d[["mulher"]])).fit()
dif_medias = df_d.loc[df_d.mulher == 1, "log_sal"].mean() - df_d.loc[df_d.mulher == 0, "log_sal"].mean()
t_welch = sps.ttest_ind(df_d.loc[df_d.mulher == 1, "log_sal"], df_d.loc[df_d.mulher == 0, "log_sal"], equal_var=True)
print(f"Coeficiente da dummy: {ajuste_d.params['mulher']:.4f} | diferença de médias: {dif_medias:.4f}")
print(f"t da regressão: {ajuste_d.tvalues['mulher']:.3f} | t do teste de duas amostras: {t_welch.statistic:.3f}")

X_armadilha = sm.add_constant(df_d[["mulher", "homem"]])                    # intercepto + as DUAS dummies
print(f"Posto da matriz: {np.linalg.matrix_rank(X_armadilha.values)} de {X_armadilha.shape[1]} colunas -> colinearidade perfeita")
print(f"Efeito percentual exato da dummy em log-linear: {(np.exp(ajuste_d.params['mulher']) - 1) * 100:.1f}% (a aproximação seria {ajuste_d.params['mulher'] * 100:.1f}%)")
```

%%% BEFORE_CHAPTER_END: == Capítulo 11 --- Transformações Logarítmicas e Elasticidades
#exemplo("recuperando os parâmetros da equação de Mincer em dados simulados")[
  Gera-se um salário com retorno à educação de 9% por ano, retorno à experiência de 4% (com rendimentos decrescentes) e verifica-se se a
  regressão recupera os valores, #strong[e] o que ocorre se omitirmos a experiência ao quadrado:
]

```python
rng_mi = np.random.default_rng(21)
n_mi = 3000
educ = rng_mi.integers(4, 20, n_mi)
exper = rng_mi.uniform(0, 35, n_mi)
lw = 0.8 + 0.09 * educ + 0.04 * exper - 0.0006 * exper ** 2 + rng_mi.normal(0, 0.35, n_mi)
completo = sm.OLS(lw, sm.add_constant(np.column_stack([educ, exper, exper ** 2]))).fit()
sem_quad = sm.OLS(lw, sm.add_constant(np.column_stack([educ, exper]))).fit()
print("Verdadeiros:  educ = 0.090 | exper = 0.0400 | exper² = -0.00060")
print(f"Mincer completo: educ = {completo.params[1]:.3f} | exper = {completo.params[2]:.4f} | exper² = {completo.params[3]:.5f} | R² = {completo.rsquared:.3f}")
print(f"Sem exper²     : educ = {sem_quad.params[1]:.3f} | exper = {sem_quad.params[2]:.4f} | R² = {sem_quad.rsquared:.3f}")
pico = -completo.params[2] / (2 * completo.params[3])
print(f"Experiência em que o salário para de crescer (pico): {pico:.1f} anos")
```

#teoria("as quatro formas log-nível: um quadro numérico")[
  Para um aumento no regressor $x$, o efeito em $y$ depende da forma funcional:

  #figure(
    align(center)[#table(
      columns: (20%, 24%, 56%),
      align: (left, left, left),
      table.header([Modelo], [Forma], [Interpretação de $beta$],),
      [Nível-nível], [$y = beta_0 + beta_1 x$], [+1 unidade de $x$ muda $y$ em $beta_1$ unidades],
      [Log-nível], [$ln y = beta_0 + beta_1 x$], [+1 unidade de $x$ muda $y$ em aproximadamente $100 beta_1$%],
      [Nível-log], [$y = beta_0 + beta_1 ln x$], [+1% em $x$ muda $y$ em aproximadamente $beta_1 \/ 100$ unidades],
      [Log-log], [$ln y = beta_0 + beta_1 ln x$], [+1% em $x$ muda $y$ em $beta_1$% (#strong[elasticidade])],
    )]
    , kind: table
    )

  A aproximação $Delta ln y approx Delta y/y$ vale para variações pequenas; para variações grandes, usa-se $e^beta - 1$. O logaritmo
  também #strong[comprime a assimetria] de variáveis como renda e preços e tende a estabilizar a variância, o que aproxima os
  dados das premissas do OLS.
]

%%% BEFORE_CHAPTER_END: == Capítulo 12 --- Autocorrelação e a Curva de Phillips
#teoria("o efeito da autocorrelação: tamanho do teste e a estatística de Durbin-Watson")[
  Em séries temporais, o erro de hoje costuma se parecer com o de ontem: $epsilon_t = rho epsilon_(t-1) + u_t$. O OLS continua não
  viesado (se a exogeneidade vale), mas o erro-padrão usual #strong[subestima] a incerteza quando $rho > 0$: testes rejeitam hipóteses
  verdadeiras bem mais que os 5% nominais. A estatística de Durbin-Watson satisfaz $"DW" approx 2(1 - hat(rho))$: perto de 2 indica ausência
  de autocorrelação de primeira ordem; perto de 0, autocorrelação positiva. Simulação: $H_0: beta_1 = 0$ #strong[verdadeira], com erros AR(1) e regressor
  persistente; contamos quantas vezes o teste a 5% rejeita:
]

```python
from statsmodels.stats.stattools import durbin_watson
rng_a = np.random.default_rng(31)
n_a, reps_a, rho_a = 120, 1500, 0.7
rej_ols = rej_hac = 0
dw_lista = []
for _ in range(reps_a):
    x = np.zeros(n_a); e = np.zeros(n_a)
    for t in range(1, n_a):
        x[t] = 0.8 * x[t - 1] + rng_a.normal()                       # regressor persistente
        e[t] = rho_a * e[t - 1] + rng_a.normal()                      # erro AR(1)
    y = 0.0 * x + e                                                    # efeito verdadeiro NULO
    ajuste = sm.OLS(y, sm.add_constant(x)).fit()
    rej_ols += ajuste.pvalues[1] < 0.05
    rej_hac += ajuste.get_robustcov_results(cov_type="HAC", maxlags=6).pvalues[1] < 0.05
    dw_lista.append(durbin_watson(ajuste.resid))
print(f"Rejeição de H0 (verdadeira) a 5%: OLS clássico = {rej_ols / reps_a:.1%} | Newey-West (HAC) = {rej_hac / reps_a:.1%}")
print(f"Durbin-Watson médio = {np.mean(dw_lista):.2f} (teórico ≈ 2(1 - {rho_a}) = {2 * (1 - rho_a):.2f})")
```

#intuicao[
  O teste "de 5%" do OLS clássico rejeita uma hipótese #strong[verdadeira] em cerca de 29% das amostras: a autocorrelação faz o
  erro-padrão subestimar a incerteza real. O Newey-West reduz bastante a distorção (para cerca de 13%), mas #strong[não a elimina] em
  amostras pequenas com erros muito persistentes --- por isso, em séries temporais, convém também modelar a dinâmica (incluir
  defasagens) em vez de só corrigir o erro-padrão.
]

%%% BEFORE_CHAPTER_END: == Capítulo 13 --- Dados em Painel
#teoria("efeitos fixos por dentro: a transformação \"within\" é igual às dummies de unidade")[
  No modelo $y_(i t) = alpha_i + beta x_(i t) + epsilon_(i t)$, o efeito específico $alpha_i$ (cultura, geografia, qualidade das instituições)
  é #emph[constante no tempo] e, se correlacionado com $x$, enviesa o OLS agrupado. O estimador de #strong[efeitos fixos] elimina $alpha_i$ subtraindo de cada
  variável a média da própria unidade (transformação #emph[within]): $y_(i t) - bar(y)_i = beta (x_(i t) - bar(x)_i) + (epsilon_(i t) - bar(epsilon)_i)$.
  É numericamente idêntico a incluir uma dummy para cada unidade (LSDV). A simulação cria um painel onde #strong[países mais ricos em $alpha_i$ têm maior $x$],
  e o verdadeiro efeito é $beta = 1$:
]

```python
import statsmodels.formula.api as smf
rng_pn = np.random.default_rng(40)
N, T = 40, 8
alfa = rng_pn.normal(0, 3, N)                                         # efeito fixo de cada país
dados_pn = pd.DataFrame({"pais": np.repeat(np.arange(N), T), "ano": np.tile(np.arange(T), N)})
dados_pn["x"] = alfa[dados_pn["pais"]] + rng_pn.normal(0, 1, N * T)    # x correlacionado com o efeito fixo
dados_pn["y"] = alfa[dados_pn["pais"]] + 1.0 * dados_pn["x"] + rng_pn.normal(0, 1, N * T)

pooled = smf.ols("y ~ x", dados_pn).fit()
lsdv = smf.ols("y ~ x + C(pais)", dados_pn).fit()
dentro = dados_pn.assign(**{c: dados_pn[c] - dados_pn.groupby("pais")[c].transform("mean") for c in ("x", "y")})
within = smf.ols("y ~ x - 1", dentro).fit()
print(f"Verdadeiro: beta = 1.0 | OLS agrupado (pooled): {pooled.params['x']:.3f} (enviesado) | LSDV: {lsdv.params['x']:.3f} | within: {within.params['x']:.3f}")
print(f"Pooled R² = {pooled.rsquared:.3f}, mas viesado: o x absorve o efeito fixo omitido (correlação x-alfa = {np.corrcoef(dados_pn['x'], alfa[dados_pn['pais']])[0, 1]:.2f})")
```

%%% BEFORE_CHAPTER_END: == Capítulo 14 --- Séries Temporais: Estacionariedade
#teoria("a regressão espúria de Granger e Newbold")[
  Duas séries #strong[independentes] com raiz unitária (passeios aleatórios) costumam produzir, ao serem regredidas uma na outra, R² alto e
  estatísticas $t$ "significativas" --- um resultado puramente #emph[espúrio], porque os erros herdam a não estacionariedade e a inferência padrão
  deixa de valer (Granger e Newbold, 1974). É a razão central para testar estacionariedade (ADF) antes de regredir séries em níveis, e para
  trabalhar com diferenças (ou testar cointegração). A simulação regride 1.000 pares de passeios aleatórios #strong[independentes]:
]

```python
from statsmodels.tsa.stattools import adfuller
rng_r = np.random.default_rng(50)
n_r, reps_r = 200, 1000
sig_niveis = sig_difs = 0
r2_niveis = []
for _ in range(reps_r):
    a = np.cumsum(rng_r.normal(size=n_r)); b = np.cumsum(rng_r.normal(size=n_r))    # passeios aleatórios independentes
    ajuste_n = sm.OLS(a, sm.add_constant(b)).fit()
    ajuste_d = sm.OLS(np.diff(a), sm.add_constant(np.diff(b))).fit()
    sig_niveis += ajuste_n.pvalues[1] < 0.05
    sig_difs += ajuste_d.pvalues[1] < 0.05
    r2_niveis.append(ajuste_n.rsquared)
print(f"Regressão em NÍVEIS: 'significativa' a 5% em {sig_niveis / reps_r:.0%} dos pares (esperado: 5%) | R² médio = {np.mean(r2_niveis):.2f}")
print(f"Regressão em DIFERENÇAS: 'significativa' a 5% em {sig_difs / reps_r:.1%} dos pares")

caminho = np.cumsum(rng_r.normal(size=300))
print(f"ADF do passeio aleatório: p = {adfuller(caminho)[1]:.2f} (não rejeita raiz unitária) | ADF da série diferenciada: p = {adfuller(np.diff(caminho))[1]:.4f}")
```

%%% BEFORE_CHAPTER_END: == Capítulo 15 --- ARIMA, Cointegração, VAR e Causalidade de Granger
#exemplo("simulando um AR(1), recuperando o parâmetro e separando treino de teste")[
  Gera-se uma série AR(1), $y_t = 0,7 y_(t-1) + epsilon_t$, ajusta-se um ARIMA(1,0,0) e compara-se a previsão com a de um modelo ingênuo
  ("amanhã igual a hoje"). Em séries temporais, a avaliação #strong[respeita a ordem do tempo]: treina-se no passado e testa-se no futuro
  (embaralhar as observações vaza informação do futuro para o treino).
]

```python
from statsmodels.tsa.arima.model import ARIMA
rng_ar = np.random.default_rng(60)
n_ar = 520
y_ar = np.zeros(n_ar)
for t in range(1, n_ar):
    y_ar[t] = 0.7 * y_ar[t - 1] + rng_ar.normal()
n_treino = 300
mod = ARIMA(y_ar[:n_treino], order=(1, 0, 0)).fit()                        # parâmetros estimados SÓ com o passado
um_passo = mod.apply(y_ar).get_prediction(start=n_treino).predicted_mean     # previsões 1 passo à frente no período de teste
real = y_ar[n_treino:]
ingenuo = y_ar[n_treino - 1:-1]                                              # "amanhã igual a hoje"
print(f"phi estimado: {mod.params[1]:.3f} (verdadeiro 0.700) | erro-padrão: {mod.bse[1]:.3f} | AIC: {mod.aic:.1f}")
print(f"{len(real)} previsões fora da amostra | RMSE do ARIMA(1,0,0): {np.sqrt(np.mean((real - um_passo) ** 2)):.3f} | RMSE do ingênuo: {np.sqrt(np.mean((real - ingenuo) ** 2)):.3f}")
prev = mod.get_forecast(steps=10)
ic = prev.conf_int(alpha=0.05)
print(f"Previsão a 10 passos: {prev.predicted_mean[-1]:.2f} (a série tende à média, 0) com IC 95% = ({ic[-1, 0]:.2f}, {ic[-1, 1]:.2f})")
```

#intuicao[
  O ARIMA tem erro de previsão menor que o ingênuo porque #emph[usa a estrutura] da série (reversão à média com $phi = 0,7$): o
  ingênuo carrega o ruído de hoje inteiro para amanhã. A diferença é modesta (a série é muito ruidosa), e em alguns trechos curtos o
  ingênuo pode ganhar por acaso --- um motivo para avaliar com #strong[muitas] previsões fora da amostra, e não com poucas. Note também
  que o intervalo de confiança a #strong[10 passos] é muito mais largo: a incerteza cresce com o horizonte.
]

#atencao[
  Um modelo ARIMA previsor #strong[não explica causas]: ele extrapola a estrutura temporal passada. Um bom ajuste in-sample (AIC baixo) não
  garante boa previsão fora da amostra; compare sempre com um #emph[benchmark simples] (o modelo ingênuo, a média móvel). A causalidade de
  Granger, por sua vez, é um conceito de #emph[precedência preditiva] ("os valores passados de $x$ ajudam a prever $y$?"), não de causalidade
  em sentido estrutural.
]

%%% BEFORE_CHAPTER_END: == Capítulo 16 --- Exercícios para Executar (na mão)
#figure(
  align(center)[#table(
    columns: (28%, 36%, 36%),
    align: (left, left, left),
    table.header([Problema], [Sintoma], [Remédio],),
    [Forma funcional errada], [RESET rejeita; padrão curvo nos resíduos], [Termos quadráticos, logs, interações],
    [Variável omitida], [Coeficiente muda muito ao incluir controles], [Incluir controles; identificação (IV, DiD)],
    [Multicolinearidade], [VIF alto; erros-padrão grandes], [Mais dados, índice, remover redundância],
    [Heterocedasticidade], [Breusch-Pagan rejeita; funil nos resíduos], [Erros-padrão robustos (HC3)],
    [Autocorrelação], [Durbin-Watson longe de 2], [Newey-West; modelar a dinâmica],
    [Raiz unitária], [ADF não rejeita; R² alto espúrio], [Diferenciar; testar cointegração],
    [Efeito não observado constante], [Pooled difere de FE (Hausman)], [Efeitos fixos],
  )]
  , kind: table
  )

%%% BEFORE_CHAPTER_END: == Próxima apostila
#line()

== Capítulo 18 --- Erros Comuns e Teste Rápido
<capítulo-18-erros-comuns-e-teste-rapido>
=== 18.1. Os erros mais comuns em econometria aplicada
<os-erros-mais-comuns-em-econometria>
#figure(
  align(center)[#table(
    columns: (4%, 38%, 58%),
    align: (center, left, left),
    table.header([\#], [Erro], [Como evitar],),
    [1], [Interpretar correlação como causalidade], [Pergunte pelo mecanismo, confundidores e causalidade reversa],
    [2], [Confiar no R² alto], [Cheque forma funcional e estacionariedade; R² mede ajuste, não validade],
    [3], [Ignorar o diagnóstico de premissas], [Resíduos, RESET, BP, DW, VIF],
    [4], [Usar erro-padrão clássico "por padrão"], [Robusto (HC3) ou HAC conforme os dados],
    [5], [Regredir séries em nível sem testar raiz unitária], [ADF; diferenciar ou cointegração],
    [6], [Caçar significância (p-hacking)], [Pré-especificar; corrigir comparações múltiplas],
    [7], [Incluir todas as dummies de uma categoria], [$G - 1$ dummies],
    [8], [Interpretar um log-linear como se fosse nível], [Aproximação $100 beta$% ou exata $e^beta - 1$],
    [9], [Dizer que um coeficiente não significativo "prova" ausência de efeito], [Ausência de evidência não é evidência de ausência (veja o poder)],
    [10], [Avaliar previsão no mesmo período em que o modelo foi ajustado], [Treino/teste respeitando o tempo],
  )]
  , kind: table
  )

=== 18.2. Teste rápido: verdadeiro ou falso (com gabarito)
<teste-rapido-verdadeiro-ou-falso-econ>
+ #strong[V ou F:] Sob $H_0$ verdadeira, 5% dos p-valores ficam abaixo de 0,05. #strong[Verdadeiro.] É o erro tipo I.
+ #strong[V ou F:] A multicolinearidade viesa os coeficientes. #strong[Falso.] Infla os erros-padrão; não gera viés.
+ #strong[V ou F:] Com heterocedasticidade, o OLS deixa de ser não viesado. #strong[Falso.] Continua não viesado; o erro-padrão usual é que fica errado.
+ #strong[V ou F:] Uma regressão com R² de 0,95 entre duas séries em nível prova relação causal. #strong[Falso.] Pode ser espúria (raiz unitária).
+ #strong[V ou F:] Omitir uma variável correlacionada com $x$ e que afeta $y$ viesa o coeficiente de $x$. #strong[Verdadeiro.]
+ #strong[V ou F:] Em log-log, $beta$ é uma elasticidade. #strong[Verdadeiro.]
+ #strong[V ou F:] O Durbin-Watson próximo de 2 indica autocorrelação forte. #strong[Falso.] Indica ausência.
+ #strong[V ou F:] Efeitos fixos eliminam efeitos não observados constantes no tempo. #strong[Verdadeiro.]
+ #strong[V ou F:] Em séries temporais, embaralhar os dados antes de separar treino e teste é uma boa prática. #strong[Falso.] Vaza informação do futuro.
+ #strong[V ou F:] Incluir $G$ dummies e o intercepto é correto. #strong[Falso.] Gera colinearidade perfeita.
%%% END
