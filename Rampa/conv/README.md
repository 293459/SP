# Convergenza presa a doppia rampa (Richardson, schema di Roe)

Norma L2 dell'entropia calcolata dal codice Euler sulle 3 mesh non strutturate
(lc = 1, 0.5, 0.25), a convergenza dei residui:

| Mesh | lc | nodi | ||S||_2 |
|---|---|---|---|
| M1 | 1.00 | 4320  | 1.973e-2 |
| M2 | 0.50 | 16564 | 1.651e-2 |
| M3 | 0.25 | 65130 | 1.443e-2 |

Estrapolazione di Richardson (r=2):
- Ordine teorico (p=1):  u_esatto=1.236e-2, E=2.08e-3, GCI=6.23e-3
- Ordine effettivo:      p_eff=0.636, u_esatto=1.069e-2, E=3.75e-3, GCI=1.12e-2

Grandezza integrale = norma L2 entropia: per un flusso con urti non tende a zero
ma converge all'entropia fisica degli urti (si annulla solo la parte numerica).
p_eff<1 e' coerente con la presenza di urti (degradano l'ordine).
