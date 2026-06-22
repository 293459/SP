#!/usr/bin/env python3
"""
Figure per teoria/flussi_rarefatti.md.

Genera:
  rarefatti_knudsen_regimi.svg
    - asse logaritmico del numero di Knudsen con i 4 regimi (continuo, slip,
      transizione, molecolare libero), soglie 0.01/0.1/1 e modelli associati;
    - schema di un plume in cui Kn cresce a valle (densita' che cala).

Uso: python3 teoria/images/rarefatti_plots.py
"""
import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

OUT = os.path.dirname(os.path.abspath(__file__))
plt.rcParams.update({"font.size": 11})

fig, (axL, axR) = plt.subplots(1, 2, figsize=(13, 4.6),
                               gridspec_kw={"width_ratios": [1.5, 1]})

# ---- (a) asse di Knudsen ----
bounds = [1e-4, 1e-2, 1e-1, 1e0, 1e2]
labels = ["CONTINUO", "SLIP\n(scivolamento)", "TRANSIZIONE", "MOLECOLARE\nLIBERO"]
models = ["Navier-Stokes / CFD", "NS + BC di slip", "DSMC / cinetici", "Boltzmann / DSMC"]
colors = ["#a8d5a2", "#ffe08a", "#ffb27a", "#ef9a9a"]
for i in range(4):
    axL.axvspan(bounds[i], bounds[i+1], color=colors[i], alpha=0.8)
    xc = np.sqrt(bounds[i]*bounds[i+1])
    axL.text(xc, 0.62, labels[i], ha="center", va="center", fontsize=10, fontweight="bold")
    axL.text(xc, 0.30, models[i], ha="center", va="center", fontsize=8.5, color="0.25")
for b in [1e-2, 1e-1, 1e0]:
    axL.axvline(b, color="0.3", ls="--", lw=1)
    axL.text(b, 0.93, f"$Kn={b:g}$", ha="center", fontsize=8, color="0.3")
axL.set_xscale("log"); axL.set_xlim(1e-4, 1e2); axL.set_ylim(0, 1)
axL.set_yticks([]); axL.set_xlabel(r"numero di Knudsen  $Kn=\lambda/L$  (scala log)")
axL.set_title("(a) Regimi di rarefazione e modello da usare")

# ---- (b) plume: Kn cresce a valle ----
axR.set_title("(b) Plume nel vuoto: $Kn$ cresce a valle")
# ugello + cono del getto
axR.fill([0, 0, 0.6], [0.35, 0.65, 0.5], color="0.6")
xx = np.linspace(0.6, 5, 100)
yu = 0.5 + 0.09*(xx-0.6)
yl = 0.5 - 0.09*(xx-0.6)
axR.fill_between(xx, yl, yu, color="#cfe3ff", alpha=0.7)
axR.text(0.2, 0.5, "ugello", rotation=90, va="center", ha="center", fontsize=8, color="w")
# gradiente di Kn (densita' cala -> lambda sale)
for xc, kn, c in [(1.0, r"$Kn\approx5\cdot10^{-3}$ (gola, continuo)", "#2f7d23"),
                  (4.3, r"$Kn\approx8$ (valle, molecolare libero)", "#c62828")]:
    axR.annotate(kn, xy=(xc, 0.5), xytext=(xc, 0.92 if xc<2 else 0.10),
                 ha="center", fontsize=8.5, color=c,
                 arrowprops=dict(arrowstyle="->", color=c))
axR.annotate("", xy=(4.6, 0.5), xytext=(1.0, 0.5),
             arrowprops=dict(arrowstyle="-|>", color="0.4", lw=1.4))
axR.text(2.8, 0.55, r"$n\downarrow\Rightarrow\lambda\uparrow\Rightarrow Kn\uparrow$",
         ha="center", fontsize=9, color="0.3")
axR.set_xlim(0, 5.2); axR.set_ylim(0, 1); axR.axis("off")

fig.suptitle("Flussi rarefatti: il numero di Knudsen (campo) decide il modello; "
             "in un getto nel vuoto si attraversano piu' regimi", fontsize=11)
fig.tight_layout(rect=(0, 0, 1, 0.94))
fig.savefig(os.path.join(OUT, "rarefatti_knudsen_regimi.svg"))
plt.close(fig)
print("scritto: rarefatti_knudsen_regimi.svg")
