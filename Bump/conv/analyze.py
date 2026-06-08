#!/usr/bin/env python3
# Analisi di convergenza del bump dai risultati rigenerati col codice di Eulero.
# Replica la metodologia di report/notebook/MATLAB:
#  - errore = norma2 entropia (soluzione esatta nota S=0)
#  - ordine via fit log-log (E vs h)
#  - Richardson ordine teorico (p=1) su una coppia
#  - Richardson ordine effettivo su terna a rapporto costante r=2 (n1,n2,n4)
#  - GCI = Fs * |u_h - u_esatto|, Fs=3
import csv, math, os

Fs = 3.0
HERE = os.path.dirname(os.path.abspath(__file__))

def load(scheme):
    path = os.path.join(HERE, f'results_{scheme}.csv')
    d = {}
    if not os.path.exists(path):
        return d
    with open(path) as f:
        for row in csv.DictReader(f):
            try:
                ent = float(row['entropy_norm'])
            except (ValueError, KeyError):
                ent = float('nan')
            d[row['grid']] = {'h': float(row['h']), 'nodes': int(row['nodes']),
                              'norm': ent, 'kfinal': row['kfinal'], 'sec': row.get('seconds','')}
    return d

# valori del report per confronto (u_4h=n1 coarsest, u_2h=n2, u_h=n4 finest)
REPORT = {
    'llf': {'n1':3.00e-3, 'n2':2.17e-3, 'n4':1.45e-3},
    'roe': {'n1':2.52e-3, 'n2':1.62e-3, 'n4':9.11e-4},
}

def order_loglog(grids, d):
    pts = [(d[g]['h'], d[g]['norm']) for g in grids if g in d and math.isfinite(d[g]['norm'])]
    if len(pts) < 2:
        return None
    xs = [math.log(h) for h,_ in pts]
    ys = [math.log(e) for _,e in pts]
    n = len(xs); sx=sum(xs); sy=sum(ys); sxx=sum(x*x for x in xs); sxy=sum(x*y for x,y in zip(xs,ys))
    return (n*sxy - sx*sy)/(n*sxx - sx*sx)

def richardson_theoretical(u_fine, u_coarse, r=2.0, p=1.0):
    u_ex = (r**p * u_fine - u_coarse)/(r**p - 1)
    E = abs(u_fine - u_ex)
    return u_ex, E, Fs*E

def richardson_effective(u_h, u_2h, u_4h, r=2.0):
    p = math.log((u_4h - u_2h)/(u_2h - u_h))/math.log(r)
    u_ex = u_h + (u_2h - u_h)/(r**p - 1)
    E = abs(u_h - u_ex)
    return p, u_ex, E, Fs*E

for scheme in ('llf','roe'):
    d = load(scheme)
    if not d:
        print(f'\n### {scheme.upper()}: nessun dato\n'); continue
    print(f'\n=================== {scheme.upper()} ===================')
    print(f'{"grid":<5}{"h":>8}{"nodi":>7}{"norma2_S (mio)":>18}{"report":>12}{"scarto%":>10}')
    for g in ('n1','n2','n3','n4'):
        if g in d:
            mine = d[g]['norm']; rep = REPORT[scheme].get(g)
            sc = (f'{100*(mine-rep)/rep:+.1f}' if (rep and math.isfinite(mine)) else '-')
            print(f'{g:<5}{d[g]["h"]:>8.4f}{d[g]["nodes"]:>7}{mine:>18.4e}{(rep if rep else float("nan")):>12.3e}{sc:>10}')
    # ordine log-log su tutte le griglie disponibili
    p_ll = order_loglog(['n1','n2','n3','n4'], d)
    if p_ll: print(f'Ordine (fit log-log, griglie disponibili): p = {p_ll:.3f}')
    # Richardson teorico sulla coppia piu' fine disponibile
    fine_pair = [g for g in ('n4','n3','n2','n1') if g in d and math.isfinite(d[g]['norm'])]
    if len(fine_pair) >= 2:
        gf, gc = fine_pair[0], fine_pair[1]
        # assicura r=2: usa coppia a rapporto 2 se possibile (n1-n2 o n2-n4)
        u_ex,E,gci = richardson_theoretical(d[gf]['norm'], d[gc]['norm'])
        print(f'Richardson teorico (p=1) [{gf} vs {gc}]: u_esatto={u_ex:.3e}  E={E:.3e}  GCI={gci:.3e}')
    # Richardson effettivo su terna r=2 = (n1,n2,n4)
    if all(g in d and math.isfinite(d[g]['norm']) for g in ('n1','n2','n4')):
        u_h, u_2h, u_4h = d['n4']['norm'], d['n2']['norm'], d['n1']['norm']
        try:
            p_eff,u_ex,E,gci = richardson_effective(u_h,u_2h,u_4h)
            print(f'Richardson effettivo (terna n1,n2,n4, r=2): p_eff={p_eff:.3f}  u_esatto={u_ex:.3e}  E={E:.3e}  GCI={gci:.3e}')
        except (ValueError, ZeroDivisionError) as e:
            print(f'Richardson effettivo: non calcolabile ({e})')
print('\n=== fine analisi ===')
