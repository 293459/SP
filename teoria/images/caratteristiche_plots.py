#!/usr/bin/env python3
"""
Genera le figure per il capitolo `teoria/caratteristiche.md`.

Concetto: advezione lineare scalare  u_t + a u_x = 0  (a = cost > 0).
Soluzione esatta:  u(x,t) = u0(x - a t)  -> il profilo trasla rigidamente.

Con dato iniziale a "tenda" (triangolo) u resta CONTINUA, ma le derivate
parziali u_x e u_t sono COSTANTI A TRATTI e presentano un SALTO (discontinuita'
debole) attraverso le linee caratteristiche  x = x0 + a t.  Vale ovunque la
relazione di compatibilita'  u_t = -a u_x.

Output (in teoria/images/):
  - caratteristiche_derivate_3d.png   : due superfici 3D, u_x(x,t) e u_t(x,t)
  - caratteristiche_2d_overview.png   : pannello 2D riassuntivo (mappe + profili)
"""
import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D

OUT = os.path.dirname(os.path.abspath(__file__))

a = 1.0                       # velocita' di propagazione (a > 0)
x0s = np.array([1.0, 2.0, 3.0])   # punti di rottura del profilo iniziale (-> caratteristiche)

def u0(xi):
    """Dato iniziale a tenda: continuo, picco 1 in x=2, base [1,3]."""
    return np.clip(1.0 - np.abs(xi - 2.0), 0.0, None)

def u0p(xi):
    """Derivata del dato iniziale: costante a tratti, salta in x = 1,2,3."""
    r = np.zeros_like(xi)
    r[(xi > 1.0) & (xi < 2.0)] = 1.0
    r[(xi > 2.0) & (xi < 3.0)] = -1.0
    return r

# campo (x,t)
x = np.linspace(-1.0, 7.0, 480)
t = np.linspace(0.0, 3.5, 360)
X, T = np.meshgrid(x, t)
XI = X - a * T                # variabile caratteristica
U   = u0(XI)
UX  = u0p(XI)                 # du/dx (x,t)
UT  = -a * UX                 # du/dt (x,t) = -a du/dx

t1 = 2.0                      # istante di snapshot

# ---------------------------------------------------------------------------
# FIGURA 1 — superfici 3D di du/dx e du/dt
# ---------------------------------------------------------------------------
fig = plt.figure(figsize=(13, 5.4))
for k, (Z, lab, cmap) in enumerate([
        (UX, r"$\partial u/\partial x\,(x,t)$", "RdBu_r"),
        (UT, r"$\partial u/\partial t\,(x,t)=-a\,\partial u/\partial x$", "PuOr_r")]):
    ax = fig.add_subplot(1, 2, k + 1, projection="3d")
    ax.plot_surface(X, T, Z, cmap=cmap, vmin=-1, vmax=1,
                    linewidth=0, antialiased=True, rcount=160, ccount=160)
    # tracce delle caratteristiche sulla superficie (in alto)
    for xc in x0s:
        tt = t.copy()
        xx = xc + a * tt
        ax.plot(xx, tt, np.full_like(tt, 1.15), color="k", lw=1.2, ls="--")
    ax.set_xlabel("x"); ax.set_ylabel("t"); ax.set_zlabel(lab)
    ax.set_title(lab, fontsize=12)
    ax.set_zlim(-1.2, 1.2)
    ax.view_init(elev=22, azim=-60)
fig.suptitle(r"Advezione lineare $u_t + a\,u_x = 0$  ($a={:.0f}>0$): le derivate sono "
             r"costanti a tratti e saltano lungo le caratteristiche  $x = x_0 + a t$"
             .format(a), fontsize=12)
fig.tight_layout(rect=(0, 0, 1, 0.95))
f1 = os.path.join(OUT, "caratteristiche_derivate_3d.png")
fig.savefig(f1, dpi=130)
plt.close(fig)

# ---------------------------------------------------------------------------
# FIGURA 2 — riassunto 2D: mappe (x,t) + profili agli istanti t=0 e t=t1
# ---------------------------------------------------------------------------
fig, axs = plt.subplots(2, 2, figsize=(13, 9))
ext = [x.min(), x.max(), t.min(), t.max()]

def add_chars(ax, label=False):
    for i, xc in enumerate(x0s):
        ax.plot(xc + a * t, t, "k--", lw=1.3)
    ax.axhline(t1, color="0.3", lw=1.0, ls=":")
    if label:
        ax.text(x0s[-1] + a * t.max() + 0.05, t.max() - 0.2,
                r"$x=x_0+a\,t$", fontsize=10, rotation=90, va="top")

# (a) u(x,t)
im0 = axs[0, 0].imshow(U, origin="lower", extent=ext, aspect="auto", cmap="viridis")
add_chars(axs[0, 0], label=True)
axs[0, 0].set_title(r"(a) $u(x,t)=u_0(x-a t)$  — continua")
axs[0, 0].set_xlabel("x"); axs[0, 0].set_ylabel("t")
fig.colorbar(im0, ax=axs[0, 0], shrink=0.85, label="u")

# (b) du/dx
im1 = axs[0, 1].imshow(UX, origin="lower", extent=ext, aspect="auto",
                       cmap="RdBu_r", vmin=-1, vmax=1)
add_chars(axs[0, 1])
axs[0, 1].set_title(r"(b) $\partial u/\partial x$  — costante a tratti, salta sulle caratteristiche")
axs[0, 1].set_xlabel("x"); axs[0, 1].set_ylabel("t")
fig.colorbar(im1, ax=axs[0, 1], shrink=0.85, label=r"$\partial u/\partial x$")

# (c) du/dt
im2 = axs[1, 0].imshow(UT, origin="lower", extent=ext, aspect="auto",
                       cmap="PuOr_r", vmin=-1, vmax=1)
add_chars(axs[1, 0])
axs[1, 0].set_title(r"(c) $\partial u/\partial t=-a\,\partial u/\partial x$")
axs[1, 0].set_xlabel("x"); axs[1, 0].set_ylabel("t")
fig.colorbar(im2, ax=axs[1, 0], shrink=0.85, label=r"$\partial u/\partial t$")

# (d) profili a t=0 e t=t1
ax = axs[1, 1]
ax.plot(x, u0(x),            color="tab:blue",  lw=2.0, label=r"$u$  ($t=0$)")
ax.plot(x, u0p(x),           color="tab:red",   lw=1.6, label=r"$\partial u/\partial x$  ($t=0$)")
ax.plot(x, u0(x - a * t1),   color="tab:blue",  lw=2.0, ls="--",
        label=r"$u$  ($t=t_1$)")
ax.plot(x, u0p(x - a * t1),  color="tab:red",   lw=1.6, ls="--",
        label=r"$\partial u/\partial x$  ($t=t_1$)")
ax.plot(x, -a * u0p(x - a*t1), color="tab:orange", lw=1.6, ls=":",
        label=r"$\partial u/\partial t$  ($t=t_1$)")
for xc in x0s:
    ax.axvline(xc, color="0.8", lw=0.8)
    ax.axvline(xc + a * t1, color="0.8", lw=0.8, ls="--")
ax.set_title(r"(d) Profili: tutto trasla di $a\,t_1$, i salti restano sulle caratteristiche")
ax.set_xlabel("x"); ax.set_ylabel("valore")
ax.legend(fontsize=8, ncol=2, loc="upper right")
ax.set_ylim(-1.4, 1.4)

fig.suptitle(r"$u_t + a\,u_x = 0$  ($a={:.0f}>0$): la discontinuita' delle derivate "
             r"(discontinuita' debole) viaggia lungo le caratteristiche".format(a),
             fontsize=13)
fig.tight_layout(rect=(0, 0, 1, 0.96))
f2 = os.path.join(OUT, "caratteristiche_2d_overview.png")
fig.savefig(f2, dpi=130)
plt.close(fig)

# ---------------------------------------------------------------------------
# FIGURA 3 — condizioni al contorno: caratteristiche entranti vs uscenti
# ---------------------------------------------------------------------------
fig, axs = plt.subplots(1, 2, figsize=(13, 5.2))
L, Tb = 6.0, 4.0          # dominio [0,L] x [0,Tb]

def bc_panel(ax, aa, title):
    # bordo del dominio
    ax.add_patch(plt.Rectangle((0, 0), L, Tb, fill=False, lw=1.5, ec="k"))
    # famiglia di caratteristiche x = x0 + aa*t
    tt = np.linspace(0, Tb, 50)
    starts = np.arange(-Tb * abs(aa), L + Tb * abs(aa), 0.8)
    for x0 in starts:
        xx = x0 + aa * tt
        m = (xx >= 0) & (xx <= L)
        if m.sum() > 1:
            ax.plot(xx[m], tt[m], color="tab:green", lw=1.4,
                    alpha=0.9, zorder=1)
            # freccia a meta' per indicare il verso di propagazione
            i = m.nonzero()[0][len(m.nonzero()[0]) // 2]
            ax.annotate("", xy=(xx[i] + 0.25 * aa, tt[i] + 0.25),
                        xytext=(xx[i], tt[i]),
                        arrowprops=dict(arrowstyle="-|>", color="tab:green", lw=1.2))
    # bordo su cui imporre la BC (dove le caratteristiche ENTRANO)
    if aa > 0:
        ax.plot([0, 0], [0, Tb], color="red", lw=4, zorder=3)
        ax.text(0.15, Tb * 0.5, "BC qui\n$u(0,t)=g(t)$", color="red",
                fontsize=11, va="center", ha="left", fontweight="bold")
        ax.text(L - 0.1, Tb * 0.5, "niente BC\n(uscente)", color="0.35",
                fontsize=10, va="center", ha="right")
    else:
        ax.plot([L, L], [0, Tb], color="red", lw=4, zorder=3)
        ax.text(L - 0.15, Tb * 0.5, "BC qui\n$u(L,t)=g(t)$", color="red",
                fontsize=11, va="center", ha="right", fontweight="bold")
        ax.text(0.1, Tb * 0.5, "niente BC\n(uscente)", color="0.35",
                fontsize=10, va="center", ha="left")
    ax.set_xlim(-0.6, L + 0.6); ax.set_ylim(-0.4, Tb + 0.4)
    ax.set_xlabel("x"); ax.set_ylabel("t")
    ax.set_title(title, fontsize=12)

bc_panel(axs[0], +1.0, r"$a>0$: caratteristiche entrano da SINISTRA")
bc_panel(axs[1], -1.0, r"$a<0$: caratteristiche entrano da DESTRA")
fig.suptitle(r"Condizioni al contorno per $u_t+a\,u_x=0$: si impone $u$ solo sul bordo "
             r"dove le caratteristiche ENTRANO nel dominio", fontsize=12.5)
fig.tight_layout(rect=(0, 0, 1, 0.94))
f3 = os.path.join(OUT, "caratteristiche_condizioni_contorno.png")
fig.savefig(f3, dpi=130)
plt.close(fig)

print("scritti:")
print(" ", f1)
print(" ", f2)
print(" ", f3)
