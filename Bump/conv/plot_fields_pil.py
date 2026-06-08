#!/usr/bin/env python3
# Renderer dei campi (Mach/Pressione/Temperatura) da .plt SENZA matplotlib,
# per evitare l'hang della ricostruzione della font-cache su Windows.
# Usa solo numpy + PIL (font bitmap incluso in PIL, nessuna scansione di sistema).
# Uso: python plot_fields_pil.py <file.plt> <prefix>
import sys, numpy as np
from PIL import Image, ImageDraw, ImageFont

def read_plt(path):
    with open(path) as f:
        lines = f.readlines()
    iz = next(i for i,l in enumerate(lines) if l.strip().lower().startswith('zone'))
    zl = lines[iz].lower().replace('=',' ').split()
    n = int(zl[zl.index('n')+1]); e = int(zl[zl.index('e')+1])
    data = np.array([[float(x) for x in lines[iz+1+i].split()] for i in range(n)])
    conn = np.array([[int(x) for x in lines[iz+1+n+i].split()] for i in range(e)], dtype=int)
    return data, conn

def jet(t):  # t in [0,1] -> (r,g,b) 0..255, classica jet
    t = np.clip(t, 0, 1)
    r = np.clip(1.5 - abs(4*t-3), 0, 1)
    g = np.clip(1.5 - abs(4*t-2), 0, 1)
    b = np.clip(1.5 - abs(4*t-1), 0, 1)
    return (int(r*255), int(g*255), int(b*255))

def render(data, conn, col, title, fname, W=1100, H=560):
    x = data[:,0]; y = data[:,1]; v = data[:,col]
    vmin, vmax = float(np.nanmin(v)), float(np.nanmax(v))
    xmin,xmax,ymin,ymax = x.min(),x.max(),y.min(),y.max()
    padL,padR,padT,padB = 70, 170, 50, 60
    pw, ph = W-padL-padR, H-padT-padB
    sx = pw/(xmax-xmin); sy = ph/(ymax-ymin); s = min(sx,sy)
    def px(xi,yi):
        return (padL + (xi-xmin)*s, padT + (ymax-yi)*s)  # y flip
    img = Image.new('RGB',(W,H),'white'); dr = ImageDraw.Draw(img)
    rng = (vmax-vmin) or 1.0
    # triangola i quad e riempi
    for q in conn:
        idx = q-1
        nodes = [idx[0],idx[1],idx[2]],[idx[0],idx[2],idx[3]]
        for tri in nodes:
            poly = [px(x[k],y[k]) for k in tri]
            tval = float(np.mean(v[tri]))
            dr.polygon(poly, fill=jet((tval-vmin)/rng))
    # cornice
    dr.rectangle([padL,padT,padL+pw,padT+ph], outline='black')
    # colorbar
    cbx = W-padR+40; cbw=26; cby0=padT; cbh=ph
    for j in range(cbh):
        t = 1-j/cbh
        dr.line([(cbx,cby0+j),(cbx+cbw,cby0+j)], fill=jet(t))
    dr.rectangle([cbx,cby0,cbx+cbw,cby0+cbh], outline='black')
    try: font = ImageFont.truetype("arial.ttf", 14); fontS=ImageFont.truetype("arial.ttf",12)
    except Exception: font = ImageFont.load_default(); fontS=font
    for j in range(6):
        val = vmax - (vmax-vmin)*j/5
        yy = cby0 + cbh*j/5
        dr.line([(cbx+cbw,yy),(cbx+cbw+5,yy)], fill='black')
        dr.text((cbx+cbw+8,yy-7), f'{val:.3g}', fill='black', font=fontS)
    dr.text((padL, 14), f'{title}   (min={vmin:.4g}, max={vmax:.4g})', fill='black', font=font)
    dr.text((padL+pw/2-10, H-30), 'x', fill='black', font=fontS)
    img.save(fname)
    print(f'  scritto {fname}  range[{vmin:.4g}, {vmax:.4g}]')

def main():
    p, prefix = sys.argv[1], sys.argv[2]
    data, conn = read_plt(p)
    rho = data[:,2]; P = data[:,3]
    T = P/rho
    data_T = data.copy();
    print(f'plt {p}: nodi={len(data)} elem={len(conn)}')
    render(data, conn, 6, 'Numero di Mach', f'{prefix}_mach.png')
    render(data, conn, 3, 'Pressione  P/P0', f'{prefix}_pressione.png')
    # temperatura: aggiungo colonna T
    dT = np.column_stack([data, T])
    render(dT, conn, dT.shape[1]-1, 'Temperatura  T/T0', f'{prefix}_temperatura.png')

if __name__ == '__main__':
    main()
