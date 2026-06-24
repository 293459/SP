#!/usr/bin/env python3
"""
Figura per teoria/metodi_numerici.md, sez. 1: interpretazione degli errori
(troncamento/discretizzazione, propagazione, globale).

Sostituisce la vecchia 'errori_interpretazione_grafica.jpg' con una versione
Python pulita, con simbologia coerente.

Output: errori_interpretazione.svg
Uso:    python3 teoria/images/errori_plots.py
"""
import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

OUT = os.path.dirname(os.path.abspath(__file__))
plt.rcParams.update({"font.size": 11})

C_EXA = "k"            # soluzione esatta
C_NUM = "tab:blue"     # soluzione numerica
C_RES = "tab:green"    # numerica se partissi dall'esatta (un passo)
C_TRO = "tab:red"      # errore di troncamento (locale)
C_PRO = "tab:orange"   # errore di propagazione

# y' = -0.2 y ;  esatto -> exp(-0.2)=0.8187 ; numerico (didattico, drift marcato) -> 0.70
dt = 1.0
FNUM = 0.70
k = np.arange(0, 6)
t = k * dt
y_ex = 4.0 * np.exp(-0.2 * t)                 # soluzione ESATTA
y_num = np.empty_like(t); y_num[0] = y_ex[0]  # numerica: parte dall'esatta (= BC) a k=0
for i in range(len(t)-1):
    y_num[i+1] = y_num[i] * FNUM              # passo numerico (sotto-stima, didattico)
# "numerica se partissi dall'esatta" al passo k -> un passo da y_ex[k]
y_res = y_ex * FNUM                            # y_res[i] valido a t[i+1]

fig, ax = plt.subplots(figsize=(10, 6))
tt = np.linspace(0, 5, 200)
ax.plot(tt, 4.0*np.exp(-0.2*tt), color=C_EXA, lw=2.4, label="soluzione ESATTA  $y(t_k)$", zorder=4)
ax.plot(t, y_num, "o-", color=C_NUM, lw=2.0, ms=7, label="soluzione NUMERICA  $y_k$", zorder=5)

# banda dell'errore GLOBALE (esatta - numerica)
ax.fill_between(t, y_num, y_ex, color="tab:blue", alpha=0.10, zorder=1)

# step rappresentativo k=2 -> 3
ki = 2
yres = y_res[ki]
ax.plot(t[ki+1], yres, "s", color=C_RES, ms=11, zorder=6)
ax.annotate("numerica se partissi\ndall'ESATTA a $t_k$ (un passo)  $\\hat y_{k+1}$",
            xy=(t[ki+1], yres), xytext=(t[ki+1]+0.25, yres+0.65),
            color=C_RES, fontsize=9,
            arrowprops=dict(arrowstyle="->", color=C_RES))
# segmento ESATTA <-> y_res = errore di TRONCAMENTO (locale)
ax.annotate("", xy=(t[ki+1], y_ex[ki+1]), xytext=(t[ki+1], yres),
            arrowprops=dict(arrowstyle="<->", color=C_TRO, lw=2.6))
ax.text(t[ki+1]+0.08, 0.5*(y_ex[ki+1]+yres), "errore di TRONCAMENTO\n(locale, per passo)",
        color=C_TRO, fontsize=9, va="center")
# segmento y_res <-> numerica = errore di PROPAGAZIONE
ax.annotate("", xy=(t[ki+1], yres), xytext=(t[ki+1], y_num[ki+1]),
            arrowprops=dict(arrowstyle="<->", color=C_PRO, lw=2.6))
ax.text(t[ki+1]+0.08, 0.5*(yres+y_num[ki+1]), "errore di\nPROPAGAZIONE",
        color=C_PRO, fontsize=9, va="center")
# parentesi GLOBALE a sinistra
ax.annotate("", xy=(t[ki+1]-0.16, y_ex[ki+1]), xytext=(t[ki+1]-0.16, y_num[ki+1]),
            arrowprops=dict(arrowstyle="<->", color="tab:blue", lw=1.8))
ax.text(t[ki+1]-0.95, 0.5*(y_ex[ki+1]+y_num[ki+1]),
        "errore GLOBALE\n= troncamento\n+ propagazione", color="tab:blue", fontsize=9,
        va="center", ha="center")
# punti al passo precedente (da dove parte lo step)
ax.plot([t[ki], t[ki]], [y_num[ki], y_ex[ki]], ":", color="0.6", lw=1)
ax.plot(t[ki], y_ex[ki], "o", mfc="none", mec=C_EXA, ms=8)

# coincidenza a k=0 (parto dalla BC = esatta -> nessun errore di propagazione)
ax.annotate("a $t_0$: numerica = esatta\n(parto dalla BC = esatta)\n→ errore globale NULLO",
            xy=(0, y_ex[0]), xytext=(0.55, 3.05), fontsize=9, color="0.3",
            arrowprops=dict(arrowstyle="->", color="0.4"))

ax.set_xlabel("iterazione / tempo  $t_k$"); ax.set_ylabel("soluzione")
ax.set_title("Interpretazione degli errori: globale = troncamento (locale) + propagazione")
ax.legend(loc="upper right", fontsize=9)
ax.set_xlim(-0.3, 5.3); ax.set_ylim(0, 4.6)
ax.grid(alpha=0.2)
fig.tight_layout()
fig.savefig(os.path.join(OUT, "errori_interpretazione.svg"))
plt.close(fig)

# verifica numerica della decomposizione (globale = tronc + prop) al passo ki
glob = y_ex[ki+1] - y_num[ki+1]
tro = y_ex[ki+1] - y_res[ki]
pro = y_res[ki] - y_num[ki+1]
print(f"check passo {ki}->{ki+1}:  globale={glob:.4f}  tronc={tro:.4f}  prop={pro:.4f}  somma={tro+pro:.4f}")
print("OK" if abs(glob-(tro+pro))<1e-9 else "ERRORE")
print("scritto: errori_interpretazione.svg")
