#!/usr/bin/env python3
"""
Figure per teoria/bilancio.md.

Genera:
  bilancio_classificazione_mach.svg
    - (a) natura della PDE del potenziale (1-M^2)phixx+phiyy=0 al variare di M:
          discriminante Delta=-4(1-M^2); ellittico (M<1) / parabolico (M=1) / iperbolico (M>1)
    - (b) schema del cono di Mach: subsonico (nessuna direzione privilegiata) vs
          supersonico (cono di apertura mu=asin(1/M))

Uso: python3 teoria/images/bilancio_plots.py
"""
import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

OUT = os.path.dirname(os.path.abspath(__file__))
plt.rcParams.update({"font.size": 11})

fig, (axL, axR) = plt.subplots(1, 2, figsize=(13, 5.2))

# ---- (a) discriminante e natura vs Mach ----
M = np.linspace(0, 2.2, 500)
Delta = -4.0 * (1.0 - M**2)          # Delta = B^2-4AC con A=(1-M^2), C=1, B=0
axL.axhline(0, color="k", lw=0.8)
axL.axvspan(0, 1, color="#cfe3ff", alpha=0.6)
axL.axvspan(1, 2.2, color="#ffd9b3", alpha=0.6)
axL.plot(M, Delta, color="tab:red", lw=2.2, label=r"$\Delta=-4(1-M^2)$")
axL.axvline(1, color="0.4", ls="--", lw=1.2)
axL.text(0.5, axL.get_ylim()[1]*0.8 if False else 6.5, "ELLITTICO\n$M<1$\n$\\Delta<0$",
         ha="center", color="tab:blue", fontsize=11, fontweight="bold")
axL.text(1.7, 6.5, "IPERBOLICO\n$M>1$\n$\\Delta>0$", ha="center", color="#b35a00",
         fontsize=11, fontweight="bold")
axL.text(1.0, -9, "PARABOLICO\n$M=1$", ha="center", color="0.3", fontsize=9)
axL.set_xlabel("numero di Mach $M$"); axL.set_ylabel(r"$\Delta$")
axL.set_title(r"(a) Natura di $(1-M^2)\phi_{xx}+\phi_{yy}=0$")
axL.set_xlim(0, 2.2); axL.set_ylim(-13, 13)
axL.legend(loc="lower right", fontsize=9)

# ---- (b) cono di Mach ----
axR.set_aspect("equal")
# subsonico: cerchi concentrici (perturbazione ovunque)
for r in [0.3, 0.6, 0.9]:
    th = np.linspace(0, 2*np.pi, 100)
    axR.plot(-2.2 + r*np.cos(th), 1.4 + r*np.sin(th), color="tab:blue", lw=1, alpha=0.7)
axR.plot(-2.2, 1.4, "ko", ms=4)
axR.text(-2.2, 0.1, "subsonico\n(info OVUNQUE)", ha="center", color="tab:blue", fontsize=9)
# supersonico: cono di Mach
Mnum = 2.0
mu = np.arcsin(1.0/Mnum)              # semi-apertura
x0, y0 = 0.6, 1.4
L = 2.2
for s in (+1, -1):
    axR.plot([x0, x0 + L*np.cos(mu)], [y0, y0 + s*L*np.sin(mu)], color="#b35a00", lw=2)
# fronti d'onda (cerchi che il punto si lascia dietro)
for k, xc in enumerate([0.6, 0.1, -0.4]):
    r = 0.5*(k+1)
    th = np.linspace(0, 2*np.pi, 100)
    axR.plot(xc + r*np.cos(th), y0 + r*np.sin(th), color="0.6", lw=0.8, alpha=0.6)
axR.plot(x0, y0, "ko", ms=4)
axR.annotate(r"$\mu=\arcsin(1/M)$", xy=(x0+1.4*np.cos(mu), y0+1.4*np.sin(mu)),
             xytext=(x0+0.9, y0+1.6), fontsize=9, color="#b35a00",
             arrowprops=dict(arrowstyle="->", color="#b35a00"))
axR.text(1.4, 0.1, "supersonico\n(info nel CONO)", ha="center", color="#b35a00", fontsize=9)
axR.set_xlim(-3.4, 3.2); axR.set_ylim(-0.3, 3.0)
axR.axis("off")
axR.set_title("(b) Cono di Mach: dove arriva l'informazione")

fig.suptitle("Classificazione della PDE comprimibile: il numero di Mach decide la natura "
             "(ellittica/iperbolica) e come si propaga l'informazione", fontsize=11.5)
fig.tight_layout(rect=(0, 0, 1, 0.95))
fig.savefig(os.path.join(OUT, "bilancio_classificazione_mach.svg"))
plt.close(fig)
print("scritto: bilancio_classificazione_mach.svg")
