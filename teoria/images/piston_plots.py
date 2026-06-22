#!/usr/bin/env python3
"""
Figure per il caso del PISTONE (teoria/caratteristiche.md + simulazione d'esame).

Genera:
  piston_due_stati.svg
    - schema in spazio fisico: pistone a riposo (condizione iniziale) e dopo
      essersi mosso (condizione intermedia); evidenzia dove c'e' GAS e dove NO.
  piston_caratteristiche_pistone.svg
    - piano x-t: dalle caratteristiche che ORIGINANO sul pistone, lambda1<u_p va
      nel vuoto, lambda2=u resta sul pistone, solo lambda3>u_p entra nel gas.

Uso: python3 teoria/images/piston_plots.py
"""
import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, FancyArrow

OUT = os.path.dirname(os.path.abspath(__file__))
plt.rcParams.update({"font.size": 11})
GAS = "#bcd9f2"
GASC = "#6fb0e0"
VUOTO = "#dddddd"

# ===========================================================================
# 1) DUE STATI DEL PISTONE (spazio fisico)
# ===========================================================================
fig, (a1, a2) = plt.subplots(2, 1, figsize=(9, 5.2))

def tube(ax, xp, gas_x0, gas_x1, gas_color, title, moving=False, compress=False):
    # cilindro
    ax.add_patch(Rectangle((0, 0), 9, 1.2, fill=False, lw=2, ec="k"))
    # zona senza gas (a sinistra del pistone)
    ax.add_patch(Rectangle((0, 0), xp, 1.2, fc=VUOTO, ec="none"))
    ax.text(xp/2 if xp > 0.6 else 0.0, 1.45, "NO GAS" if xp > 0.3 else "",
            ha="center", fontsize=9, color="0.4")
    # gas
    if compress:
        # gradiente di densita' (piu' denso vicino al pistone)
        n = 40
        for i in range(n):
            xx = gas_x0 + (gas_x1-gas_x0)*i/n
            shade = 0.4 + 0.6*(1 - i/n)
            ax.add_patch(Rectangle((xx, 0), (gas_x1-gas_x0)/n+0.02, 1.2,
                                   fc=GASC, alpha=0.3+0.5*(1-i/n), ec="none"))
    else:
        ax.add_patch(Rectangle((gas_x0, 0), gas_x1-gas_x0, 1.2, fc=gas_color, ec="none"))
    ax.text((gas_x0+gas_x1)/2, 1.45, "GAS" + (" (compresso)" if compress else " (a riposo)"),
            ha="center", fontsize=9, color="#1f6aa5")
    # pistone (blocco)
    ax.add_patch(Rectangle((xp-0.35, 0.05), 0.35, 1.1, fc="0.45", ec="k"))
    ax.text(xp-0.18, -0.45, "pistone", ha="center", fontsize=8)
    if moving:
        ax.add_patch(FancyArrow(xp+0.15, 0.6, 0.9, 0, width=0.05, color="green",
                                length_includes_head=True, head_width=0.18))
        ax.text(xp+0.7, 0.85, "u", color="green", fontsize=10)
    ax.set_xlim(-0.3, 9.3); ax.set_ylim(-0.8, 1.9); ax.axis("off")
    ax.set_title(title, fontsize=11, loc="left")

tube(a1, 0.35, 0.35, 9, GAS, "Condizione INIZIALE ($t_0$): pistone fermo (al punto morto), tutto il tubo è gas a riposo")
tube(a2, 3.2, 3.2, 8.2, GASC, "Condizione INTERMEDIA ($t_1$): pistone avanzato → a sinistra NO gas, a destra gas COMPRESSO",
     moving=True, compress=True)
fig.suptitle("Il pistone comprime il gas davanti a sé; dietro la sua faccia non c'è gas", fontsize=12)
fig.tight_layout(rect=(0, 0, 1, 0.94))
fig.savefig(os.path.join(OUT, "piston_due_stati.svg"))
plt.close(fig)
print("scritto: piston_due_stati.svg")

# ===========================================================================
# 2) CARATTERISTICHE DAL PISTONE (x-t)
# ===========================================================================
fig, ax = plt.subplots(figsize=(8.5, 6))
# traiettoria del pistone: verticale poi accelera
t = np.linspace(0, 4, 200)
xp = np.where(t < 0.6, 0.8, 0.8 + 0.18*(t-0.6)**2)
ax.fill_betweenx(t, 0, np.interp(t, t, xp), color=VUOTO)          # vuoto a sinistra
ax.fill_betweenx(t, np.interp(t, t, xp), 8, color=GAS, alpha=0.5) # gas a destra
ax.plot(xp, t, "k-", lw=2.6, label="pistone ($\\lambda_2=u$)")
ax.text(0.5, 3.6, "VUOTO\n(no gas)", ha="center", fontsize=10, color="0.4")
ax.text(5.5, 1.0, "GAS", ha="center", fontsize=11, color="#1f6aa5")

# punto Q sul pistone a t=2
tQ = 2.0
xQ = 0.8 + 0.18*(tQ-0.6)**2
uQ = 2*0.18*(tQ-0.6)        # velocita' del pistone = derivata
a0 = 1.2                    # velocita' del suono (subsonico: uQ < a0)
ax.plot(xQ, tQ, "ko", ms=8); ax.text(xQ-0.15, tQ, "Q ", ha="right", fontsize=12)
T2 = 4.0
# lambda3 = u+a (nel gas, in avanti)
ax.annotate("", xy=(xQ+(uQ+a0)*(T2-tQ), T2), xytext=(xQ, tQ),
            arrowprops=dict(arrowstyle="-|>", color="red", lw=2.2))
ax.text(xQ+(uQ+a0)*(T2-tQ)-0.2, T2+0.05, r"$\lambda_3=u+a$  (nel GAS ✓)", color="red", fontsize=10, ha="right")
# lambda2 = u (sul pistone) gia' tracciata (traiettoria)
ax.text(xQ+0.05, tQ+1.0, r"$\lambda_2=u$ (sul pistone)", color="k", fontsize=9)
# lambda1 = u-a (verso il vuoto, indietro)
ax.annotate("", xy=(xQ+(uQ-a0)*(T2-tQ), T2), xytext=(xQ, tQ),
            arrowprops=dict(arrowstyle="-|>", color="0.5", lw=2.0, ls="--"))
ax.text(xQ+(uQ-a0)*(T2-tQ)-0.1, T2+0.05, r"$\lambda_1=u-a<u_p$  (nel VUOTO ✗)", color="0.45", fontsize=10)
ax.set_xlim(0, 8); ax.set_ylim(0, T2+0.4)
ax.set_xlabel("x"); ax.set_ylabel("t")
ax.set_title("Caratteristiche che ORIGINANO sul pistone: solo $\\lambda_3$ entra nel gas\n"
             "($\\lambda_1$ andrebbe nel vuoto, $\\lambda_2$ resta sul pistone)")
fig.tight_layout()
fig.savefig(os.path.join(OUT, "piston_caratteristiche_pistone.svg"))
plt.close(fig)
print("scritto: piston_caratteristiche_pistone.svg")

# ===========================================================================
# 3) COSTRUZIONE DELLA SOLUZIONE IN P (frecce: da noto -> P)
# ===========================================================================
fig, ax = plt.subplots(figsize=(9, 6))
# traiettoria pistone
t = np.linspace(0, 4, 200)
xp = np.where(t < 0.5, 0.7, 0.7 + 0.16*(t-0.5)**2)
ax.plot(xp, t, "k-", lw=2.4)
# prima caratteristica dall'origine (limite della zona indisturbata)
ax.plot([0.7, 0.7+1.3*4], [0, 4], color="tab:green", lw=1.6, ls="--")
# zona indisturbata (sotto la prima caratteristica)
ax.fill_between([0.7, 6.2, 7], [0, 0, 0], [0, 0, 0], color="none")
ax.text(4.6, 0.35, "ZONA INDISTURBATA (condizioni iniziali, sotto la 1ª caratteristica)",
        fontsize=8.5, color="#2f7d23", ha="center")

# punti noti e P (schematico)
P = (4.2, 3.0); p2 = (1.55, 1.7); p5 = (5.6, 0.0); p4 = (3.9, 0.0)
def arrow(a, b, color, lab, dx=0.0, dy=0.0):
    ax.annotate("", xy=b, xytext=a, arrowprops=dict(arrowstyle="-|>", color=color, lw=2.2))
    ax.text((a[0]+b[0])/2+dx, (a[1]+b[1])/2+dy, lab, color=color, fontsize=10, ha="center")
arrow(p5, p2, "tab:blue",   r"$\lambda_1(5)$", dy=0.15)        # 5 -> 2
arrow(p2, P,  "red",        r"$\lambda_3(2)$", dx=-0.3)         # 2 -> P
arrow(p4, P,  "tab:purple", r"$\lambda_1(4)$", dx=0.45)         # 4 -> P
# percorso particellare (dal pistone a P), spezzato
ax.annotate("", xy=P, xytext=(2.6, 1.05),
            arrowprops=dict(arrowstyle="-|>", color="#b8860b", lw=2.0, ls=":"))
ax.text(3.2, 2.0, r"$\lambda_2$ (percorso particellare)", color="#b8860b", fontsize=9)
for pt, nm in [(P, "P"), (p2, "2"), (p5, "5"), (p4, "4")]:
    ax.plot(*pt, "ko", ms=8)
    ax.text(pt[0]+0.12, pt[1]+0.12, nm, fontsize=13, fontweight="bold")
ax.text(0.9, 3.6, "pistone\n($\\lambda_2=u$)", fontsize=9)
ax.set_xlim(0, 6.6); ax.set_ylim(-0.25, 4.1)
ax.set_xlabel("x"); ax.set_ylabel("t")
ax.set_title("Costruzione della soluzione in P: le FRECCE vanno dal noto verso P\n"
             "(5 →$\\lambda_1$→ 2 →$\\lambda_3$→ P ; 4 →$\\lambda_1$→ P ; pistone →$\\lambda_2$→ P)")
fig.tight_layout()
fig.savefig(os.path.join(OUT, "piston_costruzione_P.svg"))
plt.close(fig)
print("scritto: piston_costruzione_P.svg")

