#!/usr/bin/env python3
"""
Figure per teoria/caratteristiche.md  (capitolo "Linee caratteristiche").

Ridisegna in modo pulito (grafica vettoriale SVG per i 2D, PNG per i 3D) le
figure che negli appunti erano fatte a mano, usando un DATO INIZIALE PERIODICO.

Genera:
  lc_scalare_lineare.svg      - advezione lineare: piano x-t (caratteristiche
                                parallele, frecce del tempo, punti A,B, t1,x1)
                                + piano x-u con snapshot a t=0 e t=t1
  lc_condizioni_contorno.svg  - BC: casi a>0 e a<0, bordo entrante evidenziato
  lc_derivate_2d.svg          - mappe (x,t) di u, du/dx, du/dt (costanti lungo le
                                caratteristiche; du/dt = -a du/dx)
  lc_derivate_3d.png          - superfici 3D di du/dx e du/dt
  lc_burgers_urto.svg         - Burgers: caratteristiche che CONVERGONO -> urto
                                + snapshot x-u che si irripidiscono
  lc_burgers_espansione.svg   - Burgers: ventaglio di espansione + snapshot x-u

Uso:  python3 teoria/images/caratteristiche_plots.py
"""
import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

OUT = os.path.dirname(os.path.abspath(__file__))
plt.rcParams.update({"font.size": 11, "axes.grid": False})

GREEN = "#2ca02c"

def time_arrow(ax, x=-0.6, y0=0.05, y1=0.9):
    """Freccia verticale che indica la direzione del tempo crescente."""
    ax.annotate("", xy=(x, y1), xytext=(x, y0),
                xycoords=("data", "axes fraction"),
                arrowprops=dict(arrowstyle="-|>", color="0.3", lw=1.6))
    ax.text(x, 0.5 * (y0 + y1), "$t$ cresce", color="0.3", fontsize=9,
            transform=ax.get_xaxis_transform(), va="center", ha="center",
            rotation=90, backgroundcolor="white")

# ===========================================================================
# 1) ADVEZIONE LINEARE: x-t (caratteristiche) + x-u (snapshot)
# ===========================================================================
a = 0.5
k = 2 * np.pi / 4.0
u0 = lambda xi: np.sin(k * xi)          # onda periodica
xL, xR, Tmax = -1.0, 9.0, 6.0
t1 = 4.0
xA, xB = 0.0, 1.0                       # due punti notevoli sull'asse t=0

fig, (axL, axR) = plt.subplots(1, 2, figsize=(13, 5.6))

# --- pannello sinistro: piano x-t ---
xx = np.linspace(xL, xR, 600)
tt = np.linspace(0, Tmax, 400)
XX, TT = np.meshgrid(xx, tt)
U = u0(XX - a * TT)
axL.imshow(U, origin="lower", extent=[xL, xR, 0, Tmax], aspect="auto",
           cmap="coolwarm", alpha=0.45, vmin=-1, vmax=1)
# famiglia di caratteristiche parallele (stessa pendenza = stessa velocita')
for x0 in np.arange(xL, xR + 0.1, 1.0):
    axL.plot([x0, x0 + a * Tmax], [0, Tmax], color=GREEN, lw=1.2, alpha=0.9)
# caratteristiche per A e B evidenziate
for x0, name, col in [(xA, "A", "tab:purple"), (xB, "B", "tab:orange")]:
    axL.plot([x0, x0 + a * Tmax], [0, Tmax], color=col, lw=2.4)
    axL.plot(x0, 0, "o", color=col, ms=8)
    axL.text(x0 - 0.15, -0.45, name, color=col, fontsize=13, ha="center")
    axL.plot(x0 + a * t1, t1, "o", color=col, ms=8)
    axL.text(x0 + a * t1 + 0.15, t1 + 0.12, name + "'", color=col, fontsize=13)
# linea t = t1 e stazione x = x1
axL.axhline(t1, color="0.25", ls="--", lw=1.2)
axL.text(xR - 0.1, t1 + 0.1, "$t_1$ (istante di osservazione)", color="0.25",
         ha="right", fontsize=9)
x1 = 6.0
axL.axvline(x1, color="saddlebrown", ls=":", lw=1.6)
axL.text(x1 + 0.1, Tmax - 0.4, "$x_1$ (stazione)", color="saddlebrown", fontsize=9)
time_arrow(axL)
axL.text(xL + 0.1, Tmax - 0.5, r"$a>0$: le caratteristiche $x=x_0+a\,t$"
         "\n" r"sono PARALLELE (pendenza = $1/a$)", fontsize=9,
         bbox=dict(fc="white", ec="0.7", alpha=0.85))
axL.set_xlim(xL, xR); axL.set_ylim(-0.05, Tmax)
axL.set_xlabel("x"); axL.set_ylabel("t")
axL.set_title("(a) Piano spazio–tempo $(x,t)$")

# --- pannello destro: piano x-u (snapshot) ---
xs = np.linspace(xL, xR, 800)
axR.plot(xs, u0(xs), color="tab:blue", lw=2.0, label="$u(x,0)$")
axR.plot(xs, u0(xs - a * t1), color="tab:blue", lw=2.0, ls="--",
         label="$u(x,t_1)=u_0(x-a\\,t_1)$")
for x0, name, col in [(xA, "A", "tab:purple"), (xB, "B", "tab:orange")]:
    axR.plot(x0, u0(x0), "o", color=col, ms=8)
    axR.text(x0, u0(x0) + 0.08, name, color=col, ha="center", fontsize=13)
    axR.plot(x0 + a * t1, u0(x0), "o", color=col, ms=8)
    axR.text(x0 + a * t1, u0(x0) + 0.08, name + "'", color=col, ha="center", fontsize=13)
    axR.annotate("", xy=(x0 + a * t1, u0(x0)), xytext=(x0, u0(x0)),
                 arrowprops=dict(arrowstyle="-|>", color=col, lw=1.3, ls=":"))
axR.text(0.5 * (xA + xA + a * t1), u0(xA) - 0.22, r"$\Delta x = a\,t_1$",
         color="tab:purple", ha="center", fontsize=10)
axR.axhline(0, color="0.7", lw=0.8)
axR.set_xlim(xL, xR); axR.set_ylim(-1.5, 1.5)
axR.set_xlabel("x"); axR.set_ylabel("u")
axR.set_title("(b) Piano spazio–soluzione $(x,u)$: traslazione rigida")
axR.legend(loc="lower right", fontsize=9)

fig.suptitle(r"Advezione lineare $u_t+a\,u_x=0$: $u(x,t)=u_0(x-a t)$ — "
             r"A e B si spostano nello SPAZIO di $a\,t_1$, stesso valore di $u$",
             fontsize=12)
fig.tight_layout(rect=(0, 0, 1, 0.95))
fig.savefig(os.path.join(OUT, "lc_scalare_lineare.svg"))
plt.close(fig)

# ===========================================================================
# 2) CONDIZIONI AL CONTORNO: a>0 e a<0
# ===========================================================================
fig, axs = plt.subplots(1, 2, figsize=(13, 5.4))
L, Tb = 6.0, 4.0

def bc_panel(ax, aa, title):
    ax.add_patch(plt.Rectangle((0, 0), L, Tb, fill=False, lw=1.6, ec="k"))
    ttt = np.linspace(0, Tb, 40)
    for x0 in np.arange(-Tb * abs(aa), L + Tb * abs(aa) + 0.1, 0.8):
        xx = x0 + aa * ttt
        m = (xx >= 0) & (xx <= L)
        if m.sum() > 1:
            ax.plot(xx[m], ttt[m], color=GREEN, lw=1.4)
            i = np.where(m)[0][len(np.where(m)[0]) // 2]
            ax.annotate("", xy=(xx[i] + 0.22 * aa, ttt[i] + 0.22),
                        xytext=(xx[i], ttt[i]),
                        arrowprops=dict(arrowstyle="-|>", color=GREEN, lw=1.1))
    if aa > 0:
        ax.plot([0, 0], [0, Tb], color="red", lw=5)
        ax.text(0.2, Tb * 0.55, "BC qui\n$u(0,t)=g(t)$", color="red",
                fontsize=11, va="center", fontweight="bold")
        ax.text(L - 0.2, Tb * 0.5, "niente BC\n(uscente)", color="0.35",
                fontsize=10, va="center", ha="right")
    else:
        ax.plot([L, L], [0, Tb], color="red", lw=5)
        ax.text(L - 0.2, Tb * 0.55, "BC qui\n$u(L,t)=g(t)$", color="red",
                fontsize=11, va="center", ha="right", fontweight="bold")
        ax.text(0.2, Tb * 0.5, "niente BC\n(uscente)", color="0.35",
                fontsize=10, va="center")
    time_arrow(ax, x=-0.55, y0=0.05, y1=0.9)
    ax.set_xlim(-0.7, L + 0.5); ax.set_ylim(-0.35, Tb + 0.35)
    ax.set_xlabel("x"); ax.set_ylabel("t"); ax.set_title(title)

bc_panel(axs[0], +1.0, r"$a>0$: caratteristiche entrano da SINISTRA (monte)")
bc_panel(axs[1], -1.0, r"$a<0$: caratteristiche entrano da DESTRA")
fig.suptitle("Condizioni al contorno: si impone $u$ solo sul bordo dove le "
             "caratteristiche ENTRANO nel dominio", fontsize=12)
fig.tight_layout(rect=(0, 0, 1, 0.94))
fig.savefig(os.path.join(OUT, "lc_condizioni_contorno.svg"))
plt.close(fig)

# ===========================================================================
# 3) CAMPI DELLE DERIVATE (onda periodica)
# ===========================================================================
xx = np.linspace(xL, xR, 360); tt = np.linspace(0, Tmax, 300)
XX, TT = np.meshgrid(xx, tt)
XI = XX - a * TT
U = np.sin(k * XI)
UX = k * np.cos(k * XI)
UT = -a * UX

# --- 3D (PNG) ---
fig = plt.figure(figsize=(13, 5.2))
for j, (Z, lab, cmap) in enumerate([(UX, r"$\partial u/\partial x$", "RdBu_r"),
                                    (UT, r"$\partial u/\partial t=-a\,\partial u/\partial x$", "PuOr_r")]):
    ax = fig.add_subplot(1, 2, j + 1, projection="3d")
    ax.plot_surface(XX, TT, Z, cmap=cmap, linewidth=0, antialiased=True,
                    rcount=140, ccount=140)
    ax.set_xlabel("x"); ax.set_ylabel("t"); ax.set_zlabel(lab)
    ax.set_title(lab); ax.view_init(elev=24, azim=-62)
fig.suptitle("Le derivate sono COSTANTI lungo le caratteristiche (cresta/valle "
             "traslate): ogni caratteristica trasporta un valore diverso", fontsize=11)
fig.tight_layout(rect=(0, 0, 1, 0.94))
fig.savefig(os.path.join(OUT, "lc_derivate_3d.png"), dpi=130)
plt.close(fig)

# --- 2D maps (SVG) ---
fig, axs = plt.subplots(1, 3, figsize=(15, 4.6))
ext = [xL, xR, 0, Tmax]
for ax, Z, lab, cmap in [(axs[0], U, "$u$", "coolwarm"),
                         (axs[1], UX, r"$\partial u/\partial x$", "RdBu_r"),
                         (axs[2], UT, r"$\partial u/\partial t$", "PuOr_r")]:
    vm = np.max(np.abs(Z))
    im = ax.imshow(Z, origin="lower", extent=ext, aspect="auto", cmap=cmap,
                   vmin=-vm, vmax=vm)
    for x0 in np.arange(xL, xR + 0.1, 1.0):
        ax.plot([x0, x0 + a * Tmax], [0, Tmax], color="k", lw=0.6, alpha=0.35)
    ax.set_xlabel("x"); ax.set_ylabel("t"); ax.set_title(lab)
    fig.colorbar(im, ax=ax, shrink=0.85)
fig.suptitle(r"Mappe $(x,t)$: iso-valori PARALLELI alle caratteristiche; "
             r"$\partial u/\partial t=-a\,\partial u/\partial x$", fontsize=12)
fig.tight_layout(rect=(0, 0, 1, 0.95))
fig.savefig(os.path.join(OUT, "lc_derivate_2d.svg"))
plt.close(fig)

# ===========================================================================
# 4) BURGERS: URTO (compressione)
# ===========================================================================
# dato iniziale: rampa DECRESCENTE da uL a uR (A=alto a sx, B=basso a dx)
uLs, uRs = 1.0, 0.2
def u0_shock(xi):
    return np.where(xi < 0, uLs,
           np.where(xi > 1, uRs, uLs + (uRs - uLs) * xi))
s = 0.5 * (uLs + uRs)                  # velocita' urto (Rankine-Hugoniot)
tb = 1.0 / (uLs - uRs)                 # tempo di breaking (rampa lunga 1)

fig, (axL, axR) = plt.subplots(1, 2, figsize=(13, 5.6))
# x-t: caratteristiche x = xi + u0(xi) t (pendenza diversa -> convergono),
#      CLIPPATE sull'urto (le caratteristiche TERMINANO sull'urto, non lo attraversano)
for xi in np.arange(-1.5, 2.61, 0.2):
    u = u0_shock(np.array([xi]))[0]
    if abs(u - s) > 1e-9:
        t_hit = (0.5 - xi) / (u - s)          # intersezione con la retta d'urto x=0.5+s t
    else:
        t_hit = Tmax
    t_end = Tmax if (t_hit <= 0 or t_hit > Tmax) else t_hit
    axL.plot([xi, xi + u * t_end], [0, t_end], color=GREEN, lw=1.1, alpha=0.9)
# urto a partire dal breaking
x_b = 0.5 + uLs * tb  # posizione approssimata di formazione
axL.plot([0.5 + s * tb, 0.5 + s * Tmax], [tb, Tmax], color="red", lw=2.6,
         label="urto  $dx/dt=s=(u_L+u_R)/2$")
axL.plot(0.5 + s * tb, tb, "ko", ms=6)
axL.text(0.5 + s * tb + 0.2, tb, "  formazione urto", fontsize=9)
axL.text(-1.3, Tmax - 0.6, "A: $u=u_L$ (veloce)", color="0.2", fontsize=9)
axL.text(2.0, 0.4, "B: $u=u_R$ (lento)", color="0.2", fontsize=9)
time_arrow(axL, x=-1.9)
for tlev in (0, tb, Tmax * 0.8):
    axL.axhline(tlev, color="0.8", lw=0.6)
axL.set_xlim(-2.0, 6.0); axL.set_ylim(-0.05, Tmax)
axL.set_xlabel("x"); axL.set_ylabel("t")
axL.set_title("(a) $x$–$t$: caratteristiche che CONVERGONO")
axL.legend(loc="upper right", fontsize=9)
# x-u snapshots
for tt_s, c in [(0.0, "tab:blue"), (0.6 * tb, "tab:green"), (tb, "tab:red")]:
    xi = np.linspace(-2, 3, 400)
    xpos = xi + u0_shock(xi) * tt_s
    axR.plot(xpos, u0_shock(xi), color=c, lw=2.0,
             label=f"t = {tt_s:.2f}" + (" (breaking)" if abs(tt_s-tb)<1e-9 else ""))
axR.set_xlim(-2, 4); axR.set_ylim(0, 1.2)
axR.set_xlabel("x"); axR.set_ylabel("u")
axR.set_title("(b) $x$–$u$: il fronte si irripidisce fino al salto")
axR.legend(fontsize=9)
fig.suptitle("Burgers — COMPRESSIONE: velocita' $f'(u)=u$ non costante → le "
             "caratteristiche convergono e nasce l'urto", fontsize=12)
fig.tight_layout(rect=(0, 0, 1, 0.95))
fig.savefig(os.path.join(OUT, "lc_burgers_urto.svg"))
plt.close(fig)

# ===========================================================================
# 5) BURGERS: ESPANSIONE (ventaglio)
# ===========================================================================
uLe, uRe = 0.0, 1.0                    # salto crescente -> rarefazione
fig, (axL, axR) = plt.subplots(1, 2, figsize=(13, 5.6))
# x-t: sinistra verticali (u=0), destra pendenza 1 (u=1), ventaglio in mezzo
for xi in np.arange(-2.0, -0.01, 0.3):
    axL.plot([xi, xi], [0, Tmax], color=GREEN, lw=1.1)          # u=0 verticali
for xi in np.arange(0.01, 2.01, 0.3):
    axL.plot([xi, xi + uRe * Tmax], [0, Tmax], color=GREEN, lw=1.1)  # u=1
for frac in np.linspace(0, 1, 7):                               # ventaglio
    axL.plot([0, frac * uRe * Tmax], [0, Tmax], color="tab:orange", lw=1.0, ls="--")
axL.text(-1.8, Tmax - 0.5, "$u=0$:\ncaratt. verticali", color="0.2", fontsize=9)
axL.text(3.2, Tmax - 0.6, "$u=1$:\npendenza $1/u$", color="0.2", fontsize=9)
axL.text(0.6, Tmax * 0.5, "ventaglio di\nespansione", color="tab:orange", fontsize=9)
time_arrow(axL, x=-2.5)
axL.set_xlim(-2.6, 6.0); axL.set_ylim(-0.05, Tmax)
axL.set_xlabel("x"); axL.set_ylabel("t")
axL.set_title("(a) $x$–$t$: caratteristiche che DIVERGONO (ventaglio)")
# x-u snapshots: rarefazione u = x/t
for tt_s, c in [(0.0, "tab:blue"), (2.0, "tab:green"), (4.0, "tab:red")]:
    xs = np.linspace(-2, 6, 500)
    if tt_s == 0:
        uu = np.where(xs < 0, uLe, uRe)
    else:
        uu = np.clip(xs / tt_s, uLe, uRe)
    axR.plot(xs, uu, color=c, lw=2.0, label=f"t = {tt_s:.0f}")
axR.set_xlim(-2, 6); axR.set_ylim(-0.2, 1.3)
axR.set_xlabel("x"); axR.set_ylabel("u")
axR.set_title("(b) $x$–$u$: il salto si apre in rampa (rarefazione $u=x/t$)")
axR.legend(fontsize=9)
fig.suptitle("Burgers — ESPANSIONE: il salto crescente collassa subito in un "
             "ventaglio di onde rarefatte", fontsize=12)
fig.tight_layout(rect=(0, 0, 1, 0.95))
fig.savefig(os.path.join(OUT, "lc_burgers_espansione.svg"))
plt.close(fig)

print("OK - figure generate in", OUT)
for f in ["lc_scalare_lineare.svg", "lc_condizioni_contorno.svg",
          "lc_derivate_2d.svg", "lc_derivate_3d.png",
          "lc_burgers_urto.svg", "lc_burgers_espansione.svg"]:
    print("  ", f)

# ===========================================================================
# 6) DOMINIO DI DIPENDENZA / INFLUENZA (Eulero): subsonico vs supersonico
# ===========================================================================
def dominio_panel(ax, l1, l2, l3, title, xP=0.0, tP=2.0, Tmax=4.0):
    import matplotlib.patches as mpatches
    def xof(l, t):
        return xP + l * (t - tP)
    # cono di INFLUENZA (futuro, verso l'alto): tra l1 e l3
    fut = [(xP, tP), (xof(l1, Tmax), Tmax), (xof(l3, Tmax), Tmax)]
    ax.add_patch(mpatches.Polygon(fut, closed=True, fc="#bce5b4", ec="none", zorder=0))
    # cono di DIPENDENZA (passato, verso il basso)
    pas = [(xP, tP), (xof(l1, 0), 0), (xof(l3, 0), 0)]
    ax.add_patch(mpatches.Polygon(pas, closed=True, fc="#fff3b0", ec="none", zorder=0))
    # le 3 caratteristiche (con FRECCE: verso l'alto = futuro, verso il basso = passato)
    for l, name in [(l1, r"$\lambda_1=u-a$"), (l2, r"$\lambda_2=u$"), (l3, r"$\lambda_3=u+a$")]:
        ax.annotate("", xy=(xof(l, Tmax), Tmax), xytext=(xP, tP),
                    arrowprops=dict(arrowstyle="-|>", color="k", lw=1.8))   # futuro
        ax.annotate("", xy=(xof(l, 0), 0), xytext=(xP, tP),
                    arrowprops=dict(arrowstyle="-|>", color="0.45", lw=1.4))  # passato
        ax.text(xof(l, Tmax), Tmax + 0.08, name, ha="center", fontsize=9)
    ax.plot(xP, tP, "ko", ms=8)
    ax.text(xP - 0.15, tP, "P ", ha="right", va="center", fontsize=12)
    ax.text(0.5 * (xof(l1, Tmax) + xof(l3, Tmax)), Tmax - 0.55, "influenza\n(futuro)",
            color="#2f7d23", ha="center", fontsize=9, fontweight="bold")
    ax.text(0.5 * (xof(l1, 0) + xof(l3, 0)), 0.5, "dipendenza\n(passato)",
            color="#b8860b", ha="center", fontsize=9, fontweight="bold")
    time_arrow(ax, x=ax_xmin_for(l1, l3, xP, tP, Tmax))
    ax.set_xlim(min(xof(l1, 0), xof(l1, Tmax)) - 1.0,
                max(xof(l3, Tmax), xof(l3, 0)) + 1.0)
    ax.set_ylim(-0.15, Tmax + 0.5)
    ax.set_xlabel("x"); ax.set_ylabel("t"); ax.set_title(title)

def ax_xmin_for(l1, l3, xP, tP, Tmax):
    return min(xP + l1 * (0 - tP), xP + l1 * (Tmax - tP)) - 0.6

fig, axs = plt.subplots(1, 2, figsize=(13, 5.6))
dominio_panel(axs[0], -0.5, 0.5, 1.5,
              r"SUBSONICO ($u=0.5,\ a=1$): $\lambda_1=u-a<0$ (verso sinistra)")
dominio_panel(axs[1], 1.0, 2.0, 3.0,
              r"SUPERSONICO ($u=2,\ a=1$): tutte $\lambda>0$ (cono inclinato a valle)")
fig.suptitle("Dominio di dipendenza (giallo, passato) e di influenza (verde, futuro) di P. "
             "Il segno di $\\lambda$ è la direzione in x, NON nel tempo", fontsize=12)
fig.tight_layout(rect=(0, 0, 1, 0.95))
fig.savefig(os.path.join(OUT, "lc_dominio_dipendenza_xt.svg"))
plt.close(fig)
print("   lc_dominio_dipendenza_xt.svg")

# ===========================================================================
# 7) PROBLEMA DI RIEMANN GENERALE (schema x-t)
# ===========================================================================
fig, ax = plt.subplots(figsize=(8.5, 5.6))
Tm = 4.0
# rarefazione (1-famiglia) a sinistra: ventaglio
for fr in np.linspace(0, 1, 6):
    sl = -2.2 + fr * 1.4
    ax.plot([0, sl * Tm], [0, Tm], color="tab:green", lw=1.0, ls="-")
ax.plot([0, -2.2 * Tm / 4], [0, Tm], color="tab:green", lw=2.0)
ax.plot([0, -0.8 * Tm / 4], [0, Tm], color="tab:green", lw=2.0)
# contatto (2-famiglia)
ax.plot([0, 0.6 * Tm / 2], [0, Tm], color="tab:orange", lw=2.2, ls="--")
# urto (3-famiglia)
ax.plot([0, 1.6 * Tm / 2], [0, Tm], color="red", lw=2.6)
ax.plot(0, 0, "ko", ms=6)
ax.text(-2.6, Tm - 0.3, "stato L", fontsize=11, fontweight="bold")
ax.text(2.0, Tm - 0.3, "stato R", fontsize=11, fontweight="bold", ha="right")
ax.text(-1.05, Tm - 0.7, "$L^{*}$", fontsize=11, color="0.3")
ax.text(0.35, Tm - 0.7, "$R^{*}$", fontsize=11, color="0.3")
ax.text(-1.7, 1.5, "rarefazione\n(1: $u-a$)", color="tab:green", fontsize=9, ha="center")
ax.text(0.42, 2.6, "contatto\n(2: $u$)", color="#b8860b", fontsize=9, ha="center")
ax.text(1.7, 1.6, "urto\n(3: $u+a$)", color="red", fontsize=9, ha="center")
time_arrow(ax, x=-2.9)
ax.text(0, -0.45, "discontinuità iniziale", ha="center", fontsize=9, color="0.3")
ax.set_xlim(-3.0, 2.3); ax.set_ylim(-0.6, Tm + 0.2)
ax.set_xlabel("x"); ax.set_ylabel("t")
ax.set_title("Problema di Riemann (Eulero): soluzione AUTOSIMILE in $x/t$ — 3 onde dalla discontinuità")
fig.tight_layout()
fig.savefig(os.path.join(OUT, "lc_riemann_generale.svg"))
plt.close(fig)
print("   lc_riemann_generale.svg")

# ===========================================================================
# 8) PROFILI DI SOD a t=t1: rho, u, p, T (qualitativi, struttura corretta)
# ===========================================================================
xH, xT, xC, xS = -0.6, -0.1, 0.25, 0.6        # head/tail espansione, contatto, urto
xs = np.linspace(-1, 1, 1000)
def sod_profile(L, s3, s4, R):
    """L (sx), s3 (*L), s4 (*R), R (dx); rampa nel ventaglio xH..xT."""
    y = np.empty_like(xs)
    y[xs < xH] = L
    fan = (xs >= xH) & (xs <= xT)
    y[fan] = L + (s3 - L) * (xs[fan] - xH) / (xT - xH)
    y[(xs > xT) & (xs <= xC)] = s3
    y[(xs > xC) & (xs <= xS)] = s4
    y[xs > xS] = R
    return y
rho = sod_profile(1.0, 0.42, 0.27, 0.125)
p   = sod_profile(1.0, 0.30, 0.30, 0.10)      # p continua sul contatto (s3=s4)
u   = sod_profile(0.0, 0.93, 0.93, 0.00)      # u continua sul contatto
T   = p / rho                                  # T = p/(rho R), R=1 adim

fig, axs = plt.subplots(2, 2, figsize=(13, 8))
panels = [(axs[0,0], rho, r"$\rho$ (densità)", "tab:green", True),
          (axs[0,1], p, "$p$ (pressione)", "tab:blue", False),
          (axs[1,0], u, "$u$ (velocità)", "tab:purple", False),
          (axs[1,1], T, "$T$ (temperatura)", "tab:red", True)]
for ax, y, lab, c, shows_contact in panels:
    ax.plot(xs, y, color=c, lw=2.2)
    for xv, nm, st in [(xH, "", ":"), (xT, "", ":"), (xC, "contatto", "--"), (xS, "urto", "-")]:
        ax.axvline(xv, color="0.7", lw=1.0, ls=st)
    ax.axvspan(xH, xT, color="0.92")
    ax.set_title(lab + ("   [mostra il contatto]" if shows_contact else "   [contatto INVISIBILE]"),
                 fontsize=11)
    ax.set_xlabel("x"); ax.set_ylabel(lab.split(" ")[0])
    ax.text(xH-0.02, ax.get_ylim()[1]*0.9, "espansione", ha="right", fontsize=8, color="0.4")
fig.suptitle("Tubo di Sod a $t=t_1$: $p,u$ continue sul contatto (invisibile); "
             r"$\rho,T$ saltano (visibile). Tutte mostrano espansione e urto", fontsize=12)
fig.tight_layout(rect=(0, 0, 1, 0.96))
fig.savefig(os.path.join(OUT, "lc_sod_profili.svg"))
plt.close(fig)
print("   lc_sod_profili.svg")

# ===========================================================================
# 9) CARATTERISTICHE DA OGNI PUNTO (campo completo)
# ===========================================================================
fig, ax = plt.subplots(figsize=(9, 5.6))
uc, ac = 0.6, 1.0
Lx, Ty = 6.0, 4.0
for x0 in np.arange(-Ty*1.6, Lx + Ty*1.6, 0.7):
    ax.plot([x0, x0 + (uc+ac)*Ty], [0, Ty], color="red", lw=0.7, alpha=0.6)      # u+a
    ax.plot([x0, x0 + uc*Ty], [0, Ty], color="tab:orange", lw=0.7, alpha=0.6)    # u
    ax.plot([x0, x0 + (uc-ac)*Ty], [0, Ty], color="tab:blue", lw=0.7, alpha=0.6) # u-a
# evidenzio due punti con il loro "ventaglio" a 3
for (xp, tp) in [(1.5, 1.5), (3.5, 2.5)]:
    for l, c in [(uc+ac, "red"), (uc, "tab:orange"), (uc-ac, "tab:blue")]:
        ax.plot([xp, xp + l*(Ty-tp)], [tp, Ty], c, lw=2.0)
    ax.plot(xp, tp, "ko", ms=7)
import matplotlib.lines as ml
ax.legend([ml.Line2D([],[],color="red"), ml.Line2D([],[],color="tab:orange"),
           ml.Line2D([],[],color="tab:blue")],
          [r"$u+a$", r"$u$", r"$u-a$"], loc="upper left", fontsize=9)
time_arrow(ax, x=-2.4)
ax.set_xlim(-2.6, Lx+0.5); ax.set_ylim(-0.1, Ty+0.3)
ax.set_xlabel("x"); ax.set_ylabel("t")
ax.set_title("Da OGNI punto partono 3 caratteristiche: il piano è coperto da 3 famiglie")
fig.tight_layout()
fig.savefig(os.path.join(OUT, "lc_caratteristiche_ovunque.svg"))
plt.close(fig)
print("   lc_caratteristiche_ovunque.svg")

# ===========================================================================
# 10) LE 4 CASISTICHE DI CONDIZIONI AL CONTORNO (Eulero 1D)
# ===========================================================================
def bc_case(ax, lambdas, side, title, nbc):
    """side='in' bordo a sinistra (dominio a destra); 'out' bordo a destra (dominio a sinistra)."""
    Tb = 3.0
    xb = 0.0
    ax.axvline(xb, color="k", lw=3)                       # bordo
    # dominio ombreggiato
    if side == "in":
        ax.axvspan(0, 4, color="0.96")
    else:
        ax.axvspan(-4, 0, color="0.96")
    names = [r"$\lambda_1$", r"$\lambda_2$", r"$\lambda_3$"]
    Larr = 2.6
    n_in = 0
    for lam, nm in zip(lambdas, names):
        into = (lam > 0) if side == "in" else (lam < 0)   # entra nel dominio?
        col = "tab:green" if into else "0.55"
        nrm = (lam**2 + 1.0) ** 0.5                        # freccia a lunghezza fissa (conta la direzione)
        ex, ey = xb + Larr * lam / nrm, Larr / nrm
        ax.annotate("", xy=(ex, ey), xytext=(xb, 0),
                    arrowprops=dict(arrowstyle="-|>", color=col, lw=2.4))
        ax.text(ex + 0.12 * (1 if lam >= 0 else -1), ey + 0.05, nm, color=col,
                fontsize=11, ha="center")
        n_in += into
    ax.plot(xb, 0, "ko", ms=6)
    ax.text(0.5, 0.5, f"entranti: {n_in}\n→ {nbc} BC", transform=ax.transAxes,
            fontsize=10, ha="center", fontweight="bold",
            bbox=dict(fc="#fff3b0", ec="0.6"))
    ax.set_xlim(-3.2, 3.2); ax.set_ylim(-0.2, Tb + 0.4)
    ax.set_xlabel("x"); ax.set_ylabel("t"); ax.set_title(title, fontsize=11)

fig, axs = plt.subplots(2, 2, figsize=(12, 9))
sub = [-0.5, 0.5, 1.5]      # subsonico u=0.5, a=1
sup = [1.0, 2.0, 3.0]       # supersonico u=2, a=1
bc_case(axs[0,0], sup, "in",  "A) INGRESSO supersonico (tutte entrano)", 3)
bc_case(axs[0,1], sub, "in",  "B) INGRESSO subsonico ($\\lambda_1$ esce)", 2)
bc_case(axs[1,0], sup, "out", "C) USCITA supersonica (tutte escono)", 0)
bc_case(axs[1,1], sub, "out", "D) USCITA subsonica ($\\lambda_1$ rientra)", 1)
fig.suptitle(r"Condizioni al contorno per Eulero 1D: #BC = #caratteristiche ENTRANTI "
             r"(verde). Pendenza $dt/dx=1/\lambda$", fontsize=12)
fig.tight_layout(rect=(0, 0, 1, 0.96))
fig.savefig(os.path.join(OUT, "lc_bc_quattro_casi.svg"))
plt.close(fig)
print("   lc_bc_quattro_casi.svg")
