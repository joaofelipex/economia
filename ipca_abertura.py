"""
Abertura do IPCA por grupo: Livres, Administrados (monitorados), Comercializaveis,
Nao-comercializaveis, Servicos -- comparado ao IPCA cheio.
Fonte: BCB-SGS (series 433, 10844, 4449, 11428, 4447, 4448).
"""
import json
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

def load_sgs(path):
    with open(path, encoding="utf-8") as f:
        raw = json.load(f)
    df = pd.DataFrame(raw)
    df["data"] = pd.to_datetime(df["data"], format="%d/%m/%Y")
    df["valor"] = df["valor"].astype(float)
    return df.set_index("data")["valor"]

series = {
    "IPCA cheio": "ipca_grp_433.json" if False else None,
    "Servicos": "ipca_grp_10844.json",
    "Administrados": "ipca_grp_4449.json",
    "Livres": "ipca_grp_11428.json",
    "Comercializaveis": "ipca_grp_4447.json",
    "Nao-comercializaveis": "ipca_grp_4448.json",
}

def acum12(monthly):
    return (monthly.rolling(12).apply(lambda x: ((1 + x/100).prod() - 1) * 100, raw=True))

data = {}
for name, path in series.items():
    if path is None:
        continue
    m = load_sgs(path)
    data[name] = acum12(m)

# IPCA cheio ja temos em ipca_12m.json (acumulado 12m oficial)
ipca_full = load_sgs("ipca_12m.json")
data["IPCA cheio"] = ipca_full

df = pd.DataFrame(data).dropna()
df = df[df.index >= "2023-01-01"]
df.to_csv("ipca_abertura_grupos.csv", float_format="%.2f")
print(df.tail(12).round(2))

# ---------------------------------------------------------------
# Grafico estilo Bloomberg Terminal
# ---------------------------------------------------------------
BG = "#000000"
WHITE = "#F5F5F5"
GRID = "#2A2A2A"
MUTED = "#8C8C8C"
COLORS = {
    "IPCA cheio": "#F5F5F5",
    "Servicos": "#FF9500",
    "Administrados": "#FF3B30",
    "Livres": "#00C8FF",
    "Comercializaveis": "#34C759",
    "Nao-comercializaveis": "#BF5AF2",
}
STYLES = {"IPCA cheio": "--"}

plt.rcParams["font.family"] = "Consolas"
fig, ax = plt.subplots(figsize=(13, 7.5), dpi=150)
fig.patch.set_facecolor(BG)
ax.set_facecolor(BG)
fig.subplots_adjust(top=0.86)

for name in ["IPCA cheio", "Servicos", "Administrados", "Livres", "Comercializaveis", "Nao-comercializaveis"]:
    lw = 2.2 if name == "IPCA cheio" else 1.8
    ax.plot(df.index, df[name], color=COLORS[name], linewidth=lw,
             linestyle=STYLES.get(name, "-"), label=name.upper())

ax.axhline(3.0, color=MUTED, linewidth=1.0, linestyle=":")
ax.axhline(4.5, color=MUTED, linewidth=1.0, linestyle=":")
ax.text(df.index[0], 4.55, "teto da banda (4,5%)", color=MUTED, fontsize=8, fontfamily="Consolas")
ax.text(df.index[0], 3.1, "meta (3,0%)", color=MUTED, fontsize=8, fontfamily="Consolas")

ax.set_title("BRASIL: IPCA - ABERTURA POR GRUPO (ACUM. 12 MESES)", color=WHITE,
              fontsize=14, fontweight="bold", loc="left", pad=32)
ax.text(0.0, 1.06, "Livres vs Administrados | Comercializaveis vs Nao-comercializaveis | Servicos",
        transform=ax.transAxes, color=MUTED, fontsize=9, fontfamily="Consolas")

ax.set_ylabel("% acum. 12m", color=WHITE, fontsize=10)
ax.tick_params(colors=WHITE, labelsize=9)
ax.xaxis.set_major_locator(mdates.MonthLocator(interval=2))
ax.xaxis.set_major_formatter(mdates.DateFormatter("%b/%y"))
ax.grid(True, color=GRID, linewidth=0.6, alpha=0.9)
for spine in ax.spines.values():
    spine.set_color(GRID)

ax.legend(loc="upper left", frameon=False, fontsize=8.5, labelcolor=WHITE, ncol=2)

last = df.iloc[-1]
box_lines = "\n".join(f"{k.upper():22s}{last[k]:6.2f}%" for k in
                       ["IPCA cheio","Servicos","Administrados","Livres","Comercializaveis","Nao-comercializaveis"])
ax.text(0.985, 0.97, box_lines, transform=ax.transAxes, color="#FF9500", fontsize=8.7,
         fontfamily="Consolas", ha="right", va="top",
         bbox=dict(boxstyle="square,pad=0.6", facecolor="#0A0A0A", edgecolor=GRID, linewidth=1))

ax.text(0.0, -0.13, f"Fontes: BCB-SGS (series 433/13522, 10844, 4449, 11428, 4447, 4448). Ultimo dado: {df.index[-1].strftime('%m/%Y')}.",
        transform=ax.transAxes, color=MUTED, fontsize=7.5, fontfamily="Consolas")

fig.savefig("ipca_abertura_bloomberg.png", facecolor=BG, dpi=150, bbox_inches="tight")
print("\nGrafico salvo em ipca_abertura_bloomberg.png")
