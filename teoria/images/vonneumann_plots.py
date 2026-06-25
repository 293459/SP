#!/usr/bin/env python3
"""
Figura per teoria/metodi_numerici.md, sez. 1: analisi di stabilita' di von Neumann
dell'upwind esplicito. Il fattore di amplificazione

    G(theta) = 1 - nu (1 - e^{-i theta}) = (1-nu) + nu e^{-i theta},  nu = a dt/dx

descrive nel piano complesso un CERCHIO di centro (1-nu, 0) e raggio nu.
Stabile se il cerchio sta dentro il cerchio unitario  <=>  nu <= 1 (CFL).

Output: vonneumann_upwind.svg
Uso:    python3 teoria/images/vonneumann_plots.py
"""
import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

OUT = os.path.dirname(os.path.abspath(__file__))
plt.rcParams.update({"font.size": 11})

theta = np.linspace(0, 2*np.pi, 400)
cases = [(0.5, "tab:green",  "ν = 0.5 < 1  → STABILE"),
         (1.0, "tab:orange", "ν = 1  → limite (|G|=1, neutro)"),
         (1.5, "tab:red",    "ν = 1.5 > 1  → INSTABILE")]

fig, ax = plt.subplots(figsize=(7.2, 7.0))
# cerchio unitario (frontiera di stabilita')
uc = np.exp(1j*theta)
ax.plot(uc.real, uc.imag, "k--", lw=1.6, label="cerchio unitario |G|=1")
ax.fill(uc.real, uc.imag, color="0.92", zorder=0)
for nu, c, lab in cases:
    G = (1-nu) + nu*np.exp(-1j*theta)
    ax.plot(G.real, G.imag, color=c, lw=2.2, label=lab)
    ax.plot(1-nu, 0, "o", color=c, ms=6)
ax.axhline(0, color="0.7", lw=0.6); ax.axvline(0, color="0.7", lw=0.6)
ax.plot(1, 0, "k.", ms=8); ax.annotate("$G=1$ ($\\theta=0$)", xy=(1,0), xytext=(1.05,0.12), fontsize=9)
ax.set_aspect("equal")
ax.set_xlim(-2.0, 2.0); ax.set_ylim(-1.8, 1.8)
ax.set_xlabel(r"Re$(G)$"); ax.set_ylabel(r"Im$(G)$")
ax.set_title("Upwind esplicito — fattore di amplificazione $G=(1-\\nu)+\\nu e^{-i\\theta}$\n"
             "cerchio di centro $(1-\\nu)$ e raggio $\\nu$; stabile se sta nel cerchio unitario")
ax.legend(loc="lower left", fontsize=9)
ax.grid(alpha=0.2)
fig.tight_layout()
fig.savefig(os.path.join(OUT, "vonneumann_upwind.svg"))
plt.close(fig)

# verifica: max |G| per i tre casi
for nu,_,_ in cases:
    G=(1-nu)+nu*np.exp(-1j*theta)
    print(f"nu={nu}: max|G|={np.abs(G).max():.4f}  -> {'stabile' if np.abs(G).max()<=1+1e-9 else 'INSTABILE'}")
print("scritto: vonneumann_upwind.svg")
