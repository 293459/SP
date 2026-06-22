#!/usr/bin/env python3
"""
Figure per teoria/meshing.md.

Genera:
  mesh_metriche_qualita.svg
    - 3 pannelli "buono vs cattivo" per le metriche principali:
      Aspect Ratio, Skewness, Ortogonalita'.

Uso: python3 teoria/images/meshing_plots.py
"""
import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon

OUT = os.path.dirname(os.path.abspath(__file__))
plt.rcParams.update({"font.size": 11})

GOOD = "#a8d5a2"
BAD = "#ef9a9a"

def cell(ax, pts, color, label, x0):
    p = np.array(pts) + np.array([x0, 0])
    ax.add_patch(Polygon(p, closed=True, fc=color, ec="0.2", lw=1.6))
    ax.text(x0 + 0.5, -0.35, label, ha="center", fontsize=9)

fig, axs = plt.subplots(1, 3, figsize=(13, 4.2))

# --- Aspect Ratio ---
ax = axs[0]
cell(ax, [(0,0),(1,0),(1,1),(0,1)], GOOD, "AR ≈ 1  (buono)", 0)
cell(ax, [(0,0.35),(2.3,0.35),(2.3,0.65),(0,0.65)], BAD, "AR >> 1  (allungato)", 2.0)
ax.set_title("Aspect Ratio = lato max / lato min")
ax.set_xlim(-0.3, 4.6); ax.set_ylim(-0.7, 1.3)

# --- Skewness ---
ax = axs[1]
cell(ax, [(0,0),(1,0),(1,1),(0,1)], GOOD, "skew ≈ 0  (regolare)", 0)
cell(ax, [(0.0,0),(1.0,0),(1.6,1.0),(0.6,1.0)], BAD, "skew alto  (deformato)", 2.0)
ax.set_title("Skewness = scostamento dalla forma regolare")
ax.set_xlim(-0.3, 4.7); ax.set_ylim(-0.7, 1.3)

# --- Orthogonality ---
ax = axs[2]
# buono: connettore baricentri perpendicolare alla faccia comune
ax.add_patch(Polygon(np.array([(0,0),(1,0),(1,1),(0,1)]), closed=True, fc=GOOD, ec="0.2", lw=1.4))
ax.add_patch(Polygon(np.array([(1,0),(2,0),(2,1),(1,1)]), closed=True, fc=GOOD, ec="0.2", lw=1.4))
ax.annotate("", xy=(1.5,0.5), xytext=(0.5,0.5), arrowprops=dict(arrowstyle="-|>", color="b"))
ax.plot([1,1],[0,1], "b-", lw=2)
ax.text(1.0, -0.35, "ortog. ≈ 1 (normale ∥ connettore)", ha="center", fontsize=9, color="b")
# cattivo: connettore obliquo rispetto alla faccia
ax.add_patch(Polygon(np.array([(3,0),(4,0.0),(4.2,1),(3.2,1)]), closed=True, fc=BAD, ec="0.2", lw=1.4))
ax.add_patch(Polygon(np.array([(4,0.0),(5.1,0.2),(5.2,1.1),(4.2,1)]), closed=True, fc=BAD, ec="0.2", lw=1.4))
ax.annotate("", xy=(4.6,0.7), xytext=(3.6,0.45), arrowprops=dict(arrowstyle="-|>", color="r"))
ax.plot([4,4.2],[0.0,1.0], "r-", lw=2)
ax.text(4.2, -0.35, "ortog. bassa (obliquo)", ha="center", fontsize=9, color="r")
ax.set_title("Ortogonalità = allineamento normale/connettore")
ax.set_xlim(-0.3, 5.6); ax.set_ylim(-0.7, 1.3)

for ax in axs:
    ax.set_aspect("equal"); ax.axis("off")
fig.suptitle("Metriche di qualità della mesh: confronto elemento BUONO (verde) vs CATTIVO (rosso)",
             fontsize=12)
fig.tight_layout(rect=(0, 0, 1, 0.93))
fig.savefig(os.path.join(OUT, "mesh_metriche_qualita.svg"))
plt.close(fig)
print("scritto: mesh_metriche_qualita.svg")
