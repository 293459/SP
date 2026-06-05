# ai-learn-graphics-v2-SKILL

---

## name: ai-learn-graphics-v2

description: >
Use this skill whenever source material contains or references visual elements:
figures, plots, diagrams, schematics, geometric constructions, time-evolving
phenomena, or any content where a visual representation aids understanding.
Triggers on: “extract images from PDF”, “reproduce this figure”, “visualize
[CONCEPT]”, “make this interactive”, or implicitly when the source material
contains LaTeX \includegraphics, TikZ, PGFPlots, or figure environments.
Produces extracted images (ZIP), high-quality reproductions (SVG/PNG/PDF),
interactive HTML artifacts (in-chat), and Notion-compatible export packages.
license: MIT

# AI LEARN — Graphics & Visualization Skill

You are an expert in scientific visualization, data graphics, and learning design.
Your task is to process all visual content in the source material and produce
the highest-quality, most pedagogically effective representation of each element,
choosing the optimal format for both in-chat rendering and Notion export.

---

## Context

- **Source material:** [ATTACH PDF/NOTES — required]
- **Primary output destinations:** Claude chat (in-chat rendering) + Notion (upload/embed)
- **Secondary destination:** GoodNotes (for annotation — PNG/PDF preferred)

---

## Step 0 — Source Analysis

Before producing any output, analyze the source material and report:

1. **Is the PDF LaTeX-compiled?** Check for: embedded fonts (Type1/OTF), PDF metadata
(`Producer: pdfTeX`), vector graphics, TikZ/PGFPlots patterns in structure.
2. **Inventory all visual elements** found or referenced:
- Raster images embedded in the PDF (`\includegraphics`)
- Vector graphics (TikZ, PGFPlots, Asymptote)
- Mathematical plots (explicit functions, data curves)
- Geometric constructions (planes, lines, 3D objects)
- Flow diagrams, block diagrams, circuit schematics
- Time-evolving or parametric phenomena
1. Present the inventory as a table before proceeding:

| # | Type | Description | Source | Recommended format |
| --- | --- | --- | --- | --- |
| 1 | Raster | Fig. 3 — boundary layer profile | embedded | extract → PNG |
| 2 | Plot | CL vs alpha curve | PGFPlots | reproduce → SVG |
| 3 | Geometry | Intersection of two planes | text description | interactive HTML |

---

## Step 1 — Raster Image Extraction (LaTeX PDFs)

If the PDF is LaTeX-compiled and contains embedded raster images:

```python
# Use PyMuPDF (fitz) to extract all embedded images
import fitz  # pip install pymupdf
import zipfile, os

doc = fitz.open("source.pdf")
images = []
for page_num, page in enumerate(doc):
    for img_index, img in enumerate(page.get_images(full=True)):
        xref = img[0]
        base_image = doc.extract_image(xref)
        filename = f"fig_p{page_num+1}_{img_index+1}.{base_image['ext']}"
        with open(filename, "wb") as f:
            f.write(base_image["image"])
        images.append(filename)

# Package into ZIP
with zipfile.ZipFile("[COURSE]_[TOPIC]_figures.zip", "w") as zf:
    for img in images:
        zf.write(img)
```

- Extract all embedded images at native resolution
- Name each file descriptively: `fig_p{page}_{index}_{caption_slug}.{ext}`
- Preserve original resolution — do not downsample
- Package all extracted images into `[COURSE]_[TOPIC]_figures.zip`
- Return the ZIP as a downloadable artifact
- For each extracted image: include the caption/description from the surrounding text

---

## Step 2 — Format Decision Tree

For each visual element identified in Step 0, apply this decision logic:

```
Is it a raster image embedded in the PDF?
  └─ YES → Extract (Step 1) + attempt vector reproduction if simple enough (Step 3)
  └─ NO ↓

Is it a mathematical function or data plot (2D/3D)?
  └─ YES → Reproduce with matplotlib/numpy (Step 3A) → SVG + PNG
  └─ NO ↓

Is it a geometric construction or spatial concept (planes, vectors, solids)?
  └─ YES → Does it benefit from interactive parameter exploration?
      └─ YES → Interactive HTML artifact with Three.js or matplotlib widgets (Step 4)
      └─ NO  → Static SVG via matplotlib/mpl_toolkits (Step 3B)
  └─ NO ↓

Is it a flow diagram, block diagram, or process schematic?
  └─ YES → Mermaid.js flowchart/graph in HTML artifact (Step 3C)
  └─ NO ↓

Is it a time-evolving or animated phenomenon?
  └─ YES → GIF via matplotlib.animation (Step 5) + static keyframe PNG
  └─ NO ↓

Is it a complex figure requiring description only?
  └─ YES → Detailed textual description + placeholder tag for manual insertion
```

---

## Step 3 — Static Reproduction

### 3A — Mathematical Plots (matplotlib)

Reproduce any plot that can be defined analytically or from data in the source:

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl

# Style: clean, publication-quality
mpl.rcParams.update({
    'font.family': 'serif',
    'font.size': 11,
    'axes.labelsize': 12,
    'axes.titlesize': 13,
    'legend.fontsize': 10,
    'figure.dpi': 150,
    'axes.grid': True,
    'grid.alpha': 0.3,
})

fig, ax = plt.subplots(figsize=(7, 5))
# ... plot logic ...
ax.set_xlabel(r'$\alpha$[deg]')          # LaTeX axis labels preserved
ax.set_ylabel(r'$C_L$[-]')
ax.set_title('Lift curve — NACA 0012')
ax.legend(loc='best')
fig.tight_layout()

# Export both formats
fig.savefig('[COURSE]_[TOPIC]_fig{N}.svg', format='svg', bbox_inches='tight')
fig.savefig('[COURSE]_[TOPIC]_fig{N}.png', dpi=300, bbox_inches='tight')
```

**Always preserve from source:**

- Axis labels (including LaTeX notation)
- Legend entries and their order
- Annotations and callout text
- Axis ranges and tick marks if specified
- Color conventions if described in the text

### 3B — Geometric Constructions (matplotlib 3D / SVG)

For spatial geometry (planes, lines, vectors, solids):

- Use `mpl_toolkits.mplot3d` for 3D scenes
- Use `matplotlib.patches` for 2D geometric constructions
- Label all geometric elements as in the source
- Export as SVG (scalable, embeds in Notion) + PNG fallback

### 3C — Flow Diagrams and Schematics (Mermaid.js)

For process flows, algorithm diagrams, system block diagrams:

- Use Mermaid `flowchart TD` or `graph LR`
- Wrap in HTML artifact for in-chat rendering (same CDN pattern as Mind Map skill)
- Also provide raw Mermaid code block for Notion paste
- Node shape conventions: `[rect]` process, `{diamond}` decision, `((circle))` start/end, `[/parallelogram/]` I/O

---

## Step 4 — Interactive Elements

### When to make something interactive

Produce an interactive HTML artifact when the concept involves:

- Parameter dependence (changing a value changes the geometry/curve)
- Spatial relationships best understood by rotation (3D geometry)
- Superposition of multiple elements (on/off toggles)
- Threshold or limiting behavior (show what happens as parameter → 0 or ∞)

**Examples:**

- Intersection of two planes → sliders for normal vectors, renders resulting line
- Joukowski transform → slider for circle radius/offset, renders airfoil
- Von Kármán vortex street frequency → slider for Reynolds number
- Stress tensor rotation → drag to rotate, updates Mohr’s circle

### Technical implementation

All interactive artifacts are **self-contained single HTML files** using CDN-only dependencies:

```html
<!DOCTYPE html>
<html>
<head>
  <script src="[https://cdn.jsdelivr.net/npm/three@0.128.0/build/three.min.js](https://cdn.jsdelivr.net/npm/three@0.128.0/build/three.min.js)"></script>
  <script src="[https://cdn.plot.ly/plotly-latest.min.js](https://cdn.plot.ly/plotly-latest.min.js)"></script>
  <script src="[https://cdn.jsdelivr.net/npm/katex/dist/katex.min.js](https://cdn.jsdelivr.net/npm/katex/dist/katex.min.js)"></script>
  <link rel="stylesheet" href="[https://cdn.jsdelivr.net/npm/katex/dist/katex.min.css](https://cdn.jsdelivr.net/npm/katex/dist/katex.min.css)">
</head>
<body>
  </body>
</html>
```

**Library selection by use case:**

| Use case | Library | Why |
| --- | --- | --- |
| 2D parametric plots | Plotly.js | Sliders built-in, hover tooltips |
| 3D geometry / rotation | Three.js | Full WebGL, orbit controls |
| Math formula rendering | KaTeX | Fast, CDN, Notion-compatible rendering |
| Simple animations | CSS + JS | No dependency, lightest weight |
| Statistical / data plots | Plotly.js | Interactive zoom, pan, export |

### Notion compatibility for interactive content

Notion does **not** support inline HTML. Export strategy:

| Format | Notion support | Method |
| --- | --- | --- |
| PNG / JPG / GIF | ✅ Native upload | Direct upload to page |
| SVG | ✅ Native upload | Direct upload (renders inline) |
| HTML interactive | ⚠️ Embed only | Host on GitHub Pages / Vercel → paste URL in Embed block |
| MP4 video | ✅ Native upload | Upload directly |
| GIF animation | ✅ Native upload | Upload directly |
| Mermaid code | ✅ Code block | Paste in `/code` block, language: `mermaid` |
| Plotly static export | ✅ PNG upload | `plotly.io.write_image()` |

**For every interactive HTML artifact:** also export a static PNG snapshot so the content is usable in Notion immediately, without hosting.

---

## Step 5 — Animated Content

For time-evolving phenomena (fluid dynamics, oscillations, wave propagation, orbital mechanics):

### GIF via matplotlib.animation

```python
from matplotlib.animation import FuncAnimation, PillowWriter

fig, ax = plt.subplots()
# ... setup ...

def update(frame):
    # ... update plot state ...
    return artists

anim = FuncAnimation(fig, update, frames=60, interval=50, blit=True)
anim.save('[COURSE]_[TOPIC]_anim.gif',
          writer=PillowWriter(fps=20),
          dpi=120)
```

- Target: 15–30 fps, <5 MB file size
- Always include a static “representative frame” PNG alongside the GIF
- Add frame counter or time label if the animation represents a time sequence

### When to prefer video over GIF

Use MP4 (via `FFMpegWriter`) instead of GIF when:

- Animation > 5 seconds
- High color depth required (gradients, pressure fields)
- File size would exceed 5 MB as GIF

---

## Step 6 — Caption and Metadata Preservation

For **every** visual element produced, include:

```markdown
**Figure N** — [Title from source or inferred title]
*Caption:* [Full caption text from source, verbatim if available]
*Description:* [What the figure shows, why it has that shape/behavior,
what happens at boundary conditions, what the key trends mean physically]
*Source:* [Page/section number in original document]
*Format produced:* [SVG + PNG | GIF | HTML interactive | extracted raster]
*Notion upload:* [filename to upload] | [embed URL if interactive]
```

Never produce a visual without its accompanying description. The description must answer:

- What is shown (axes, quantities, units)
- Why it has that shape or behavior
- What the physically or mathematically significant features are
- What a student must notice to understand the concept

---

## Step 7 — Packaging and Delivery

### Per-session output ZIP

At the end of processing, package all produced files into a single ZIP:

```
[COURSE]_[TOPIC]_visuals.zip
├── figures/
│   ├── extracted/          # raster images from PDF
│   ├── reproduced/         # matplotlib SVG + PNG reproductions
│   └── animated/           # GIF / MP4 animations
├── interactive/
│   ├── [concept]_interactive.html   # self-contained HTML artifacts
│   └── [concept]_static.png         # static snapshot for Notion
├── diagrams/
│   └── [diagram]_mermaid.md        # raw Mermaid code blocks
└── manifest.md             # table listing every file with description and Notion upload instructions
```

### `manifest.md` format

```markdown
# Visual Manifest — [COURSE] [TOPIC]

| File | Type | Description | Notion action |
|------|------|-------------|---------------|
| figures/reproduced/fig1_lift_curve.svg | SVG plot | CL vs alpha, NACA 0012 | Upload to page |
| figures/animated/karman_vortex.gif | GIF | Von Kármán vortex shedding | Upload to page |
| interactive/plane_intersection.html | HTML | Parametric plane intersection | Host → Embed block |
| interactive/plane_intersection_static.png | PNG | Static snapshot of above | Upload as fallback |
| diagrams/control_loop_mermaid.md | Mermaid | PID control loop block diagram | /code block → mermaid |
```

---

## Format Taxonomy Reference

| Category | Format | Notion | In-chat | GoodNotes | Best for |
| --- | --- | --- | --- | --- | --- |
| Static plot | SVG | ✅ upload | ✅ artifact | ✅ | Functions, curves, data |
| Static plot | PNG (300dpi) | ✅ upload | ✅ artifact | ✅ | All static content |
| Diagram | Mermaid (HTML) | ⚠️ code block | ✅ artifact | screenshot | Flows, graphs, schemas |
| Geometry | matplotlib 3D PNG | ✅ upload | ✅ artifact | ✅ | Spatial constructions |
| Interactive | HTML (Plotly) | ⚠️ embed URL | ✅ artifact | ✗ | Parametric exploration |
| Interactive | HTML (Three.js) | ⚠️ embed URL | ✅ artifact | ✗ | 3D rotation / geometry |
| Animation | GIF | ✅ upload | ✅ artifact | ✅ | Short loops < 5s |
| Animation | MP4 | ✅ upload | ✅ artifact | ✗ | Long / high-quality |
| Extracted raster | PNG/JPG | ✅ upload | ✅ display | ✅ | Original PDF images |

✅ = fully supported | ⚠️ = partial/workaround needed | ✗ = not supported

---

## Constraints

- Never produce a visual without an accompanying caption and description
- Never invent data not present in the source material — if a curve is described qualitatively, draw it qualitatively and label it as schematic
- All Python code must be executable with standard scientific Python stack: `numpy`, `matplotlib`, `scipy`, `pymupdf`
- All HTML artifacts must work by double-clicking the file (no local server required)
- Interactive HTML artifacts must also have a static PNG fallback
- If a figure cannot be reproduced faithfully, include a descriptive placeholder: `[Figure: description]` and explain why

## Success Criteria

- Every figure in the source material has a corresponding output (extracted, reproduced, or described)
- The ZIP opens and all files are correctly named and described in `manifest.md`
- All static images render correctly when uploaded to Notion
- All interactive HTML files open in a browser without a server
- No figure is missing its caption/description