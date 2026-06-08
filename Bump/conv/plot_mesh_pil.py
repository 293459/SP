#!/usr/bin/env python3
# Renderizza la mesh (edge) da un file .msh Gmsh v2.2 in PNG, senza matplotlib.
# Uso: python plot_mesh_pil.py <file.msh> <out.png> "<titolo>"
import sys
from PIL import Image, ImageDraw, ImageFont

def read_msh(path):
    nodes = {}; elems = []
    with open(path) as f:
        lines = f.readlines()
    i = 0
    while i < len(lines):
        l = lines[i].strip()
        if l == '$Nodes':
            n = int(lines[i+1]);
            for k in range(n):
                p = lines[i+2+k].split()
                nodes[int(p[0])] = (float(p[1]), float(p[2]))
            i += 2+n
        elif l == '$Elements':
            m = int(lines[i+1])
            for k in range(m):
                p = lines[i+2+k].split()
                etype = int(p[1]); ntags = int(p[2])
                nd = list(map(int, p[3+ntags:]))
                if etype in (2,3):  # triangolo o quad
                    elems.append(nd)
            i += 2+m
        else:
            i += 1
    return nodes, elems

def render(path, out, title, W=1100, H=420):
    nodes, elems = read_msh(path)
    xs = [p[0] for p in nodes.values()]; ys = [p[1] for p in nodes.values()]
    xmin,xmax,ymin,ymax = min(xs),max(xs),min(ys),max(ys)
    padL,padR,padT,padB = 20,20,40,20
    pw,ph = W-padL-padR, H-padT-padB
    s = min(pw/(xmax-xmin), ph/(ymax-ymin))
    ox = padL + (pw-(xmax-xmin)*s)/2; oy = padT + (ph-(ymax-ymin)*s)/2
    def px(x,y): return (ox+(x-xmin)*s, oy+(ymax-y)*s)
    img = Image.new('RGB',(W,H),'white'); dr = ImageDraw.Draw(img)
    for e in elems:
        pts = [px(*nodes[n]) for n in e]
        dr.polygon(pts, outline=(30,60,150))
    try: font = ImageFont.truetype("arial.ttf", 18)
    except Exception: font = ImageFont.load_default()
    dr.text((padL, 8), title, fill='black', font=font)
    img.save(out)
    print(f'  {out}: {len(nodes)} nodi, {len(elems)} elementi')

if __name__ == '__main__':
    render(sys.argv[1], sys.argv[2], sys.argv[3] if len(sys.argv)>3 else '')
