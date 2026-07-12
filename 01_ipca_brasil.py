"""
IPCA - Variação mensal (%)
Fonte: BCB SGS - código 433
"""
from bcb import sgs
import matplotlib.pyplot as plt

ipca = sgs.get({"IPCA": 433}, start="1995-01-01")

print("ÚLTIMOS 5 VALORES — IPCA (variação mensal em %)")
print(ipca.tail())

media = ipca.mean().iloc[0]
minimo = ipca.min().iloc[0]
maximo = ipca.max().iloc[0]

print(f"\nResumo (1995-2026):")
print(f"Média mensal: {media:.2f}%")
print(f"Mínimo mensal: {minimo:.2f}%")
print(f"Máximo mensal: {maximo:.2f}%")

fig, ax = plt.subplots(figsize=(12, 5))
ipca.plot(ax=ax, color="crimson", linewidth=1)
ax.axhline(media, color="blue", linestyle="--", linewidth=0.8, label=f"Média ({media:.1f}%)")
ax.axhline(minimo, color="red", linestyle="--", linewidth=0.8, label=f"Mínimo ({minimo:.1f}%)")
ax.axhline(maximo, color="green", linestyle="--", linewidth=0.8, label=f"Máximo ({maximo:.1f}%)")
ax.legend()
ax.set_title("IPCA - Variação Mensal (%)", fontsize=14)
ax.set_ylabel("Variação mensal (%)")
ax.set_xlabel("")
ax.grid(True, alpha=0.3)
fig.tight_layout()
fig.savefig("ipca_brasil_att.png", dpi=150)
plt.close()

print(f"\nGráfico salvo: ipca_brasil_att.png")
