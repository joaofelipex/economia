"""
Regra de Taylor aplicada a Selic (Brasil)
Fontes: BCB SGS API (Selic meta, IPCA 12m), BCB Focus (Olinda API - expectativas
de mercado), Relatorios de Politica Monetaria do BCB (taxa neutra r*), Pre-Copom
(hiato do produto).
"""
import json
from datetime import datetime
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

# ---------------------------------------------------------------
# 1) Carrega series baixadas da API do BCB (SGS)
# ---------------------------------------------------------------
def load_sgs(path):
    with open(path, encoding="utf-8") as f:
        raw = json.load(f)
    df = pd.DataFrame(raw)
    df["data"] = pd.to_datetime(df["data"], format="%d/%m/%Y")
    df["valor"] = df["valor"].astype(float)
    return df.set_index("data")["valor"]

selic_diaria = load_sgs("selic_meta.json")           # meta Selic definida pelo Copom (% a.a.)
ipca12 = load_sgs("ipca_12m.json")                    # IPCA acumulado 12 meses (%)

# Selic mensal = ultimo valor vigente no mes
selic_m = selic_diaria.resample("MS").last()
ipca_m = ipca12.resample("MS").last()

df = pd.concat({"selic": selic_m, "ipca12m": ipca_m}, axis=1).dropna()

# ---------------------------------------------------------------
# 2) Meta de inflacao (CMN) e taxa neutra r* (RPM/BCB) -- piecewise documentado
#    Meta: 2023 = 3,25% | 2024 em diante = 3,00% (meta continua, Res. CMN 5.089/2024)
#    r*:   ate mai/2024 = 4,50% | jun-nov/2024 = 4,75% | dez/2024 em diante = 5,00%
#    (RPM jun/2024 elevou 4,50->4,75; RPM dez/2024 elevou 4,75->5,00, mantida ate RPM jun/2026)
# ---------------------------------------------------------------
def meta_inflacao(dt):
    return 3.25 if dt.year == 2023 else 3.00

def r_estrela(dt):
    if dt < pd.Timestamp("2024-06-01"):
        return 4.50
    elif dt < pd.Timestamp("2024-12-01"):
        return 4.75
    else:
        return 5.00

df["meta"] = [meta_inflacao(d) for d in df.index]
df["r_star"] = [r_estrela(d) for d in df.index]

# Regra de Taylor simplificada (sem hiato do produto, coef. padrao 0,5 no gap de inflacao)
# i* = r* + pi + 0,5*(pi - meta)
df["taylor_selic"] = df["r_star"] + df["ipca12m"] + 0.5 * (df["ipca12m"] - df["meta"])
df["gap_pp"] = df["selic"] - df["taylor_selic"]

df.to_csv("taylor_rule_series.csv", float_format="%.2f")
print(df.tail(10).round(2))

# ---------------------------------------------------------------
# 3) Ponto atual: regra completa com hiato do produto e expectativa Focus 12m
# ---------------------------------------------------------------
selic_atual = selic_diaria.iloc[-1]           # ultimo valor diario (mais recente que o IPCA)
ipca_atual = df["ipca12m"].iloc[-1]            # ultimo IPCA 12m divulgado (defasado ~1 mes)
r_star_atual = df["r_star"].iloc[-1]
meta_atual = df["meta"].iloc[-1]
print(f"\n[nota] Selic mais recente (diaria): {selic_atual:.2f}% em {selic_diaria.index[-1].date()}"
      f" | IPCA 12m mais recente: {ipca_atual:.2f}% em {df.index[-1].date()}")

focus_ipca_12m_frente = 4.4151      # Focus, expectativa suavizada 12m a frente, mediana (21/08/2026)
hiato_min, hiato_central, hiato_max = 0.2, 0.4, 0.6   # Pre-Copom, %PIB (2026)

def taylor_full(pi, gap, a=0.5, b=0.5):
    return r_star_atual + pi + a * (pi - meta_atual) + b * gap

cenarios = {
    "IPCA 12m retrospectivo, hiato central": taylor_full(ipca_atual, hiato_central),
    "IPCA 12m retrospectivo, hiato min":     taylor_full(ipca_atual, hiato_min),
    "IPCA 12m retrospectivo, hiato max":     taylor_full(ipca_atual, hiato_max),
    "Focus 12m a frente, hiato central":     taylor_full(focus_ipca_12m_frente, hiato_central),
    "Focus 12m a frente, hiato min":         taylor_full(focus_ipca_12m_frente, hiato_min),
    "Focus 12m a frente, hiato max":         taylor_full(focus_ipca_12m_frente, hiato_max),
}

print("\n=== Selic atual (meta):", selic_atual, "% ===")
for k, v in cenarios.items():
    print(f"{k:45s} -> Taylor = {v:5.2f}%  |  Selic - Taylor = {selic_atual - v:+.2f} p.p.")

# ---------------------------------------------------------------
# 4) Grafico estilo Bloomberg Terminal
# ---------------------------------------------------------------
BG = "#000000"
ORANGE = "#FF9500"
WHITE = "#F5F5F5"
CYAN = "#00C8FF"
GRID = "#2A2A2A"
MUTED = "#8C8C8C"

plt.rcParams["font.family"] = "Consolas"
fig, ax = plt.subplots(figsize=(13, 7), dpi=150)
fig.patch.set_facecolor(BG)
ax.set_facecolor(BG)

ax.plot(df.index, df["selic"], color=ORANGE, linewidth=2.0, label="SELIC META (efetiva)")
ax.plot(df.index, df["taylor_selic"], color=CYAN, linewidth=2.0, label="SELIC IMPLICITA (Regra de Taylor)")
ax.fill_between(df.index, df["selic"], df["taylor_selic"],
                 where=(df["selic"] >= df["taylor_selic"]), color=ORANGE, alpha=0.12, interpolate=True)
ax.fill_between(df.index, df["selic"], df["taylor_selic"],
                 where=(df["selic"] < df["taylor_selic"]), color=CYAN, alpha=0.12, interpolate=True)

# Ponto atual com faixa de sensibilidade (hiato do produto)
last_dt = df.index[-1]
ax.scatter([last_dt], [selic_atual], color=ORANGE, s=45, zorder=5, edgecolor=WHITE, linewidth=0.6)
ax.errorbar([last_dt], [taylor_full(ipca_atual, hiato_central)],
            yerr=[[taylor_full(ipca_atual, hiato_central) - taylor_full(ipca_atual, hiato_min)],
                  [taylor_full(ipca_atual, hiato_max) - taylor_full(ipca_atual, hiato_central)]],
            fmt="o", color=CYAN, ecolor=CYAN, elinewidth=1.6, capsize=4, zorder=5,
            markeredgecolor=WHITE, markeredgewidth=0.6)

fig.subplots_adjust(top=0.86)
ax.set_title("BRASIL: SELIC vs SELIC IMPLICITA PELA REGRA DE TAYLOR", color=WHITE,
              fontsize=14, fontweight="bold", loc="left", pad=32)
ax.text(0.0, 1.06, "i* = r* + π + 0,5×(π-π*) + 0,5×hiato   |   r*=BCB (RPM), π*=meta CMN, π=IPCA 12m",
        transform=ax.transAxes, color=MUTED, fontsize=9, fontfamily="Consolas")

ax.set_ylabel("% a.a.", color=WHITE, fontsize=10)
ax.tick_params(colors=WHITE, labelsize=9)
ax.xaxis.set_major_locator(mdates.MonthLocator(interval=3))
ax.xaxis.set_major_formatter(mdates.DateFormatter("%b/%y"))
ax.grid(True, color=GRID, linewidth=0.6, alpha=0.9)
for spine in ax.spines.values():
    spine.set_color(GRID)

legend = ax.legend(loc="upper left", frameon=False, fontsize=9, labelcolor=WHITE)

# Box com leitura atual (estilo terminal)
box_txt = (
    f"SELIC ATUAL:      {selic_atual:5.2f}%\n"
    f"TAYLOR (central):  {taylor_full(ipca_atual, hiato_central):5.2f}%\n"
    f"DESVIO:            {selic_atual - taylor_full(ipca_atual, hiato_central):+5.2f} p.p.\n"
    f"r* (BCB):          {r_star_atual:5.2f}%\n"
    f"meta π* (CMN):     {meta_atual:5.2f}%\n"
    f"IPCA 12m:          {ipca_atual:5.2f}%"
)
ax.text(0.985, 0.97, box_txt, transform=ax.transAxes, color=ORANGE, fontsize=9.5,
         fontfamily="Consolas", ha="right", va="top",
         bbox=dict(boxstyle="square,pad=0.6", facecolor="#0A0A0A", edgecolor=GRID, linewidth=1))

ax.text(0.0, -0.14, "Fontes: BCB-SGS (series 432, 13522), BCB Focus/Olinda (expectativas de mercado),\n"
                     "Relatorio de Politica Monetaria BCB (taxa neutra r*), Pre-Copom (hiato do produto).",
        transform=ax.transAxes, color=MUTED, fontsize=7.5, fontfamily="Consolas")

fig.tight_layout()
fig.savefig("selic_taylor_rule_bloomberg.png", facecolor=BG, dpi=150, bbox_inches="tight")
print("\nGrafico salvo em selic_taylor_rule_bloomberg.png")
