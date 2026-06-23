#!/usr/bin/env python3
"""
Figure per la sezione DIFFERENZE FINITE di teoria/metodi_numerici.md
(dalla lavagna: dominio + condizioni al contorno, discretizzazione spaziale e temporale).

Genera:
  fd_dominio_bc.svg          - dominio (x,t) con dato iniziale (bordo basso) e BC (bordo sinistro)
  fd_discretizzazione.svg    - discretizzazione dell'asse spaziale e di quello temporale

Uso: python3 teoria/images/fd_plots.py
"""
import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle

OUT = os.path.dirname(os.path.abspath(__file__))
plt.rcParams.update({"font.size": 11})

# ===========================================================================
# 1) DOMINIO + CONDIZIONI AL CONTORNO / INIZIALI
# ===========================================================================
L, T = 4.0, 3.0
fig, ax = plt.subplots(figsize=(8.2, 5.6))
ax.add_patch(Rectangle((0, 0), L, T, fill=False, lw=1.2, ec="0.5"))
# bordo INFERIORE: dato iniziale (tutti gli x, t=0)
ax.plot([0, L], [0, 0], color="tab:blue", lw=5, solid_capstyle="butt")
ax.text(L/2, -0.32, "DATO INIZIALE  $u(x,0)$  —  bordo INFERIORE ($t=0$, tutti gli $x$)",
        ha="center", color="tab:blue", fontsize=9.5)
# bordo SINISTRO: condizione al contorno (tutti i t, x=0) per a>0
ax.plot([0, 0], [0, T], color="red", lw=5, solid_capstyle="butt")
ax.text(-0.18, T/2, "BC  $u(0,t)$\n(tutti i $t$, $x=0$)", ha="right", va="center",
        color="red", fontsize=9.5, rotation=90)
# bordo DESTRO: uscita, nessuna BC (a>0)
ax.plot([L, L], [0, T], color="0.6", lw=2, ls="--")
ax.text(L+0.12, T/2, "uscita\n(no BC, $a>0$)", ha="left", va="center", color="0.5", fontsize=9)
# caratteristiche a>0 (dx/dt=a -> info da sinistra/basso)
a = 1.0
for x0 in [0, 0, 1.2, 2.4]:
    t0 = 0.0
for (x0, t0) in [(0, 0.6), (0, 1.6), (0.7, 0.0), (2.0, 0.0)]:
    ax.plot([x0, x0 + a*(T-t0)], [t0, T], color="tab:green", lw=1.1, alpha=0.8)
ax.annotate("", xy=(-0.5, 0.9*T), xytext=(-0.5, 0.1*T),
            arrowprops=dict(arrowstyle="-|>", color="0.4", lw=1.4))
ax.text(-0.5, 0.5*T, "$t$", color="0.4", fontsize=11, ha="right")
# nodi di griglia (discretizzazione)
xs = np.linspace(0, L, 6); ts = np.linspace(0, T, 5)
for xx in xs:
    for tt in ts:
        ax.plot(xx, tt, "o", ms=3, color="0.7", zorder=1)
ax.text(0.05, -0.32, "O", fontsize=10); ax.text(L, -0.32, "$L$", fontsize=10, ha="center")
ax.text(-0.18, T, "$T$", fontsize=10, va="center", ha="right")
ax.set_xlim(-1.0, L+1.0); ax.set_ylim(-0.6, T+0.4)
ax.set_xlabel("x"); ax.set_ylabel("t")
ax.set_title("Dominio $(x,t)$: il DATO INIZIALE sta sul bordo basso, la BC sul bordo sinistro\n"
             "(per $a>0$ l'informazione entra da sinistra e dal basso)")
ax.set_aspect("auto")
fig.tight_layout()
fig.savefig(os.path.join(OUT, "fd_dominio_bc.svg"))
plt.close(fig)
print("scritto: fd_dominio_bc.svg")

# ===========================================================================
# 2) DISCRETIZZAZIONE SPAZIALE E TEMPORALE
# ===========================================================================
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(9, 4.6))

def axis_disc(ax, n, length, var, node, expr, color):
    ax.plot([0, length], [0, 0], "k-", lw=1.5)
    nodes = np.linspace(0, length, n+1)
    ax.plot(nodes, np.zeros_like(nodes), "o", color=color, ms=8)
    for j, xx in enumerate(nodes):
        lab = {0: f"${node}_0=0$", n: f"${node}_{{{var}}}={length:.0f}$"}.get(
            j, f"${node}_{j}$" if j in (1,) else "")
        ax.text(xx, -0.28, f"{var}={j}", ha="center", fontsize=8, color="0.4")
    # bracket Delta
    ax.annotate("", xy=(nodes[1], 0.25), xytext=(nodes[0], 0.25),
                arrowprops=dict(arrowstyle="<->", color=color))
    ax.text((nodes[0]+nodes[1])/2, 0.42, expr, ha="center", color=color, fontsize=10)
    ax.set_xlim(-0.3, length+0.3); ax.set_ylim(-0.6, 0.8); ax.axis("off")

axis_disc(ax1, 5, 4.0, "x", "x", r"$\Delta x$", "tab:blue")
ax1.set_title(r"Discretizzazione SPAZIALE: $x_j=j\,\Delta x=j\,\dfrac{L}{N}$,  $j=0,\dots,N$ (qui $N=5$)",
              fontsize=10, loc="left")
axis_disc(ax2, 3, 4.0, "n", "t", r"$\Delta t$", "tab:red")
ax2.set_title(r"Discretizzazione TEMPORALE: $t_n=n\,\Delta t=n\,\dfrac{T}{M}$,  $n=0,\dots,M$ (qui $M=3$)",
              fontsize=10, loc="left")
fig.suptitle(r"$\Delta x,\Delta t$ COSTANTI (uniformi); $N$ (spazio) e $M$ (tempo) possono DIFFERIRE",
             fontsize=11)
fig.tight_layout(rect=(0, 0, 1, 0.93))
fig.savefig(os.path.join(OUT, "fd_discretizzazione.svg"))
plt.close(fig)
print("scritto: fd_discretizzazione.svg")
