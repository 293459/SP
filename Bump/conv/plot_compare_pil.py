#!/usr/bin/env python3
# Confronto Roe vs Lax-Friedrichs di una variabile da due .plt, in un'unica immagine
# (pannello sopra = Roe, sotto = LLF), scala colore condivisa. Niente matplotlib.
# Uso: python plot_compare_pil.py <roe.plt> <llf.plt> <col> <titolo> <out.png>
#   col: 6=Mach, 3=Pressione (oppure 'T' per temperatura=P/rho)
import sys, numpy as np
from PIL import Image, ImageDraw, ImageFont

def read_plt(path):
    L=open(path).readlines()
    iz=next(i for i,l in enumerate(L) if l.strip().lower().startswith('zone'))
    z=L[iz].lower().replace('=',' ').split(); n=int(z[z.index('n')+1]); e=int(z[z.index('e')+1])
    d=np.array([[float(x) for x in L[iz+1+i].split()] for i in range(n)])
    c=np.array([[int(x) for x in L[iz+1+n+i].split()] for i in range(e)],dtype=int)
    return d,c

def jet(t):
    t=max(0.0,min(1.0,t))
    r=max(0,min(1,1.5-abs(4*t-3))); g=max(0,min(1,1.5-abs(4*t-2))); b=max(0,min(1,1.5-abs(4*t-1)))
    return (int(r*255),int(g*255),int(b*255))

def getvar(d,col):
    if col=='T': return d[:,3]/d[:,2]
    return d[:,int(col)]

def panel(dr, d, c, val, x0,y0,pw,ph, vmin,vmax):
    x=d[:,0]; y=d[:,1]; xmn,xmx,ymn,ymx=x.min(),x.max(),y.min(),y.max()
    s=min(pw/(xmx-xmn), ph/(ymx-ymn)); ox=x0+(pw-(xmx-xmn)*s)/2; oy=y0+(ph-(ymx-ymn)*s)/2
    def px(xi,yi): return (ox+(xi-xmn)*s, oy+(ymx-yi)*s)
    rng=(vmax-vmin) or 1.0
    for q in c:
        idx=q-1
        for tri in ([idx[0],idx[1],idx[2]],[idx[0],idx[2],idx[3]] if len(idx)==4 else [idx[0],idx[1],idx[2]]):
            dr.polygon([px(x[k],y[k]) for k in tri], fill=jet((np.mean(val[tri])-vmin)/rng))

def main():
    roe,llf,col,title,out=sys.argv[1:6]
    dR,cR=read_plt(roe); dL,cL=read_plt(llf)
    vR=getvar(dR,col); vL=getvar(dL,col)
    vmin=float(min(vR.min(),vL.min())); vmax=float(max(vR.max(),vL.max()))
    W,H=1000,620; img=Image.new('RGB',(W,H),'white'); dr=ImageDraw.Draw(img)
    pw,ph=W-200,(H-90)//2
    panel(dr,dR,cR,vR,20,40,pw,ph,vmin,vmax)
    panel(dr,dL,cL,vL,20,40+ph+30,pw,ph,vmin,vmax)
    # colorbar condivisa
    cbx=W-150; cby0=40; cbh=H-90
    for j in range(cbh):
        dr.line([(cbx,cby0+j),(cbx+28,cby0+j)],fill=jet(1-j/cbh))
    dr.rectangle([cbx,cby0,cbx+28,cby0+cbh],outline='black')
    try: f=ImageFont.truetype("arial.ttf",17); fs=ImageFont.truetype("arial.ttf",13)
    except Exception: f=ImageFont.load_default(); fs=f
    for j in range(6):
        v=vmax-(vmax-vmin)*j/5; yy=cby0+cbh*j/5
        dr.text((cbx+32,yy-7),f'{v:.3g}',fill='black',font=fs)
    dr.text((20,8),f'{title}  (min={vmin:.3g}, max={vmax:.3g})',fill='black',font=f)
    dr.text((24,44),'Roe',fill='white',font=f)
    dr.text((24,44+ph+30),'Lax-Friedrichs',fill='white',font=f)
    img.save(out); print(f'  {out}  [{vmin:.3g},{vmax:.3g}]')

if __name__=='__main__': main()
