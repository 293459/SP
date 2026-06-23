#!/usr/bin/env python3
"""
Stencil degli schemi alle differenze finite (per teoria/metodi_numerici.md, §2).

Disegna i PUNTI usati nel piano (x,t) per: upwind esplicito, downwind esplicito,
centrato esplicito, centrato implicito, Lax-Friedrichs.

Output: fd_schemi_stencil.svg
Uso:    python3 teoria/images/fd_schemi_plots.py
"""
import os
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

OUT = os.path.dirname(os.path.abspath(__file__))
plt.rcParams.update({"font.size": 10})
USED = "#1f77b4"
TARGET = "#d62728"

def stencil(ax, used, target, time_pair, space_pair, title, stable):
    # griglia: x in {0,1,2} = j-1,j,j+1 ; t in {0,1} = n,n+1
    for xi in range(3):
        for ti in range(2):
            ax.plot(xi, ti, "o", ms=6, color="0.8", zorder=1)
    # punti usati
    for (xi, ti) in used:
        ax.plot(xi, ti, "o", ms=12, color=USED, zorder=3)
    # target (incognita)
    ax.plot(*target, "o", ms=13, color=TARGET, zorder=4)
    # freccia tempo (verticale)
    (x0, t0), (x1, t1) = time_pair
    ax.annotate("", xy=(x1, t1-0.06), xytext=(x0, t0+0.06),
                arrowprops=dict(arrowstyle="-|>", color="0.3", lw=1.6))
    ax.text(x0+0.08, 0.5, r"$\Delta u/\Delta t$", fontsize=8, color="0.3")
    # freccia spazio (orizzontale)
    (xa, ta), (xb, tb) = space_pair
    ax.annotate("", xy=(xb-0.06, tb), xytext=(xa+0.06, ta),
                arrowprops=dict(arrowstyle="-|>", color=USED, lw=1.6))
    ax.text((xa+xb)/2, ta-0.20, r"$\Delta u/\Delta x$", fontsize=8, color=USED, ha="center")
    ax.set_xticks([0,1,2]); ax.set_xticklabels(["$j-1$","$j$","$j+1$"])
    ax.set_yticks([0,1]); ax.set_yticklabels(["$n$","$n+1$"])
    ax.set_xlim(-0.5, 2.5); ax.set_ylim(-0.45, 1.4)
    col = "#2e7d32" if stable else "#c62828"
    ax.set_title(title + ("  ✓ stabile" if stable else "  ✗ instabile"),
                 fontsize=10, color=col)
    ax.set_xlabel("x"); ax.set_ylabel("t")

fig, axs = plt.subplots(2, 3, figsize=(13, 7.4))

# 1) UPWIND esplicito: usa (j-1,n),(j,n),(j,n+1); spazio backward
stencil(axs[0,0], [(0,0),(1,0)], (1,1), ((1,0),(1,1)), ((0,0),(1,0)),
        "Upwind esplicito (FTBS)", True)
# 2) DOWNWIND esplicito: (j,n),(j+1,n),(j,n+1); spazio forward
stencil(axs[0,1], [(1,0),(2,0)], (1,1), ((1,0),(1,1)), ((1,0),(2,0)),
        "Downwind esplicito", False)
# 3) CENTRATO esplicito (FTCS): (j-1,n),(j+1,n),(j,n),(j,n+1)
stencil(axs[0,2], [(0,0),(1,0),(2,0)], (1,1), ((1,0),(1,1)), ((0,0),(2,0)),
        "Centrato esplicito (FTCS)", False)
# 4) CENTRATO implicito: spazio al livello n+1 -> (j-1,n+1),(j+1,n+1)
stencil(axs[1,0], [(1,0),(0,1),(2,1)], (1,1), ((1,0),(1,1)), ((0,1),(2,1)),
        "Centrato implicito", True)
# 5) LAX-FRIEDRICHS: (j-1,n),(j+1,n),(j,n+1) (media, NON usa (j,n))
stencil(axs[1,1], [(0,0),(2,0)], (1,1), ((1,0),(1,1)), ((0,0),(2,0)),
        "Lax-Friedrichs (media)", True)

# legenda nel 6° pannello
lg = axs[1,2]; lg.axis("off")
lg.plot(0.12, 0.8, "o", ms=12, color=USED); lg.text(0.2, 0.8, "punto USATO (dato, passo $n$)", va="center")
lg.plot(0.12, 0.6, "o", ms=13, color=TARGET); lg.text(0.2, 0.6, "incognita $u_j^{n+1}$ (target)", va="center")
lg.plot(0.12, 0.4, "o", ms=6, color="0.8"); lg.text(0.2, 0.4, "nodo della griglia (non usato)", va="center")
lg.text(0.0, 0.15, "Esplicito: target da soli punti a $n$.\nImplicito: lo spazio usa il livello $n+1$\n→ serve risolvere un SISTEMA.",
        fontsize=9, color="0.3")
lg.set_xlim(0,1); lg.set_ylim(0,1)

fig.suptitle("Stencil degli schemi alle differenze finite per $u_t+a\\,u_x=0$ ($a>0$): i PUNTI usati",
             fontsize=12)
fig.tight_layout(rect=(0,0,1,0.95))
fig.savefig(os.path.join(OUT, "fd_schemi_stencil.svg"))
plt.close(fig)
print("scritto: fd_schemi_stencil.svg")
