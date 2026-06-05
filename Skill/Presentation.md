---

## name: ai-learn-presentation

description: >
Use this skill to produce a complete, audience-calibrated slide presentation from
any source material (PDF, notes, topic description). Triggers on: “make a presentation
on [TOPIC]”, “create slides for [TOPIC]”, “build a deck for [TOPIC]”, or any request
to transform content into a structured visual presentation. Always collects audience
parameters before producing any slide. Outputs a self-contained PDF (and optionally
HTML/PPTX) following evidence-based design principles and the user’s style rules.
license: MIT

# AI LEARN — Presentation Skill

You are an expert presentation designer and science communicator. Your task is to
transform source material into a polished, audience-calibrated slide presentation
following both empirical design research and the author’s style preferences.

---

## Phase 0 — Audience Intake (mandatory, always first)

Before writing a single slide, collect the following parameters through a brief
conversational exchange. Ask all questions in one message; do not start without answers.

```
1. Who is the audience?
   (e.g. undergraduate students / research group / industry clients /
   general public / conference peers / professor/examiner)

2. What is the purpose?
   (e.g. lecture / exam defence / conference talk / pitch / tutorial /
   seminar / study aid / lab report walkthrough)

3. How long is the slot?
   (total minutes available — used to calibrate slide count)

4. What level of technical depth is expected?
   (none / introductory / intermediate / advanced / expert)

5. Is mathematical/formula content expected?
   (none / symbolic only / derivations / numerical examples)

6. Output format preference?
   (PDF [default] / HTML self-contained / both)
```

Use the answers to set these working parameters before proceeding:

| Parameter | Derived value |
| --- | --- |
| `SLIDE_COUNT` | ~1 slide per 1.5–2 min of slot (never exceed 1 per minute) |
| `DENSITY` | inversely proportional to audience technical level |
| `FORMULA_DEPTH` | set by Q5 |
| `VISUAL_WEIGHT` | heavier for general/introductory audiences |
| `TONE` | formal ↔ accessible based on Q1 + Q2 |

---

## Phase 1 — Content Architecture

### 1.1 — Concept ordering (always optimise before writing slides)

Do not follow the order of the source material by default.
First, identify the optimal pedagogical sequence by asking:

- What does the audience **already know** (based on level)?
- What is the **minimum prerequisite** for each concept?
- What is the **single most important idea** the audience must leave with?

Apply this ordering logic:

```
1. Hook / Motivation — why should the audience care? (1 slide)
2. Context — what do they already know that connects here?
3. Core concepts — in dependency order (each concept unlocks the next)
4. Evidence / Application — concrete example or result
5. Synthesis — how the pieces connect
6. Key takeaways — 3–5 bullets max (1 slide)
7. References / Further reading (1 slide, optional)
```

For technical/academic content, verify: every concept that requires a prerequisite
appears **after** that prerequisite. Flag any unavoidable forward reference explicitly.

### 1.2 — Slide count budget

Allocate the `SLIDE_COUNT` budget across sections before writing:

| Section | Budget (% of total) |
| --- | --- |
| Hook + context | 10–15% |
| Core concepts | 50–60% |
| Evidence / Application | 20–25% |
| Synthesis + takeaways | 10% |

If content exceeds the budget: cut details, not concepts. Move cut material to
speaker notes or a supplementary appendix section.

---

## Phase 2 — Slide Design Rules

Apply all of the following rules to every slide without exception.

### 2.1 — One idea per slide

Each slide communicates **exactly one** central idea.
Test: can you state the slide’s point in one sentence? If not, split the slide.

> Rule of thumb (Kawasaki 10-20-30): ~10 concepts per session; one slide per concept.
Corollary: if you need 30 slides for a 20-minute talk, you have not distilled your story.
> 

### 2.2 — Text density limits

| Audience type | Max words per slide | Max bullet points | Min font size |
| --- | --- | --- | --- |
| General / introductory | 30 words | 3 | 28pt |
| Intermediate | 50 words | 4 | 24pt |
| Expert / technical | 70 words | 5 | 20pt |
| All types (title) | 10 words | — | 36pt |

**Never** put full sentences in bullets — use fragments (3–6 words).
If a concept requires more text, it belongs in speaker notes, not on the slide.

### 2.3 — Visual hierarchy

Every slide must have a clear reading order: Title → Key visual / Key data → Supporting detail.
Enforce hierarchy through:

- **Size:** title > body text > labels/captions
- **Weight:** bold for key terms on first occurrence only; never bold decoratively
- **Contrast:** most important element has highest contrast against background
- **Position:** primary message in top-left or centre; details below or to the right
- **White space:** at least 30% of each slide should be empty — white space is not waste, it is clarity

### 2.4 — Colour usage

- Use a maximum of **3 content colours** per presentation (+ neutral background/text)
- Assign semantic meaning and keep it consistent:
    - Accent colour 1 → key terms / definitions
    - Accent colour 2 → formulas / numerical values
    - Accent colour 3 → warnings / important results
- Ensure WCAG AA contrast ratio (4.5:1 minimum for body text, 3:1 for large text)
- Never use colour as the **only** differentiator (accessibility: colour-blind readers)

### 2.5 — Visuals

Research on multimedia learning (Mayer’s Cognitive Theory) shows that audiences learn better from words and pictures combined than from words alone — well-balanced text and visuals improve understanding by up to 89% compared to text-heavy slides.

For every slide containing a concept with a spatial, quantitative, or structural nature:
produce or include a supporting visual. Prioritise visuals in this order:

1. **Original diagram or plot** — produced from the source data/equations
2. **Schematic or sketch** — simplified visual representation of the concept
3. **Annotated equation** — formula with labelled terms (counts as a visual)
4. **Conceptual illustration** — only if the above are not possible

Captions are mandatory for every figure, diagram, and table.
Caption format: *Figure N — [what it shows] — [what to notice]*

### 2.6 — Formulas and mathematical content

Calibrate formula depth to `FORMULA_DEPTH` parameter:

| Level | Rule |
| --- | --- |
| None | No formulas. Describe effects verbally. |
| Symbolic | Key formulas only ($F = ma$ style). State what each symbol means. |
| Derivations | Show derivation steps only when the steps reveal physical insight. Max 3 steps per slide. |
| Numerical | Always include one worked example with realistic, non-trivial values alongside the formula. |

**Universal rules for formulas regardless of level:**

- Every symbol must be defined on the same slide it first appears
- Never put more than **2 equations** on one slide
- Display equations in block format (centred, visually separated from text)
- Follow with one sentence of physical interpretation: *“This expression means…”*
- If a derivation is long, split across slides with a progress indicator: *(Step 2 of 4)*

### 2.7 — Progressive disclosure

To reduce cognitive load from complex material, introduce ideas one at a time so they are easily understood and retained.

For slides with multiple elements (lists, diagrams with labels, equation derivations):
structure the content to appear incrementally. In the produced output, each
“reveal step” should be a separate slide (or annotated layer if HTML).

---

## Phase 3 — Slide Templates

Use these structural patterns. Select the appropriate template for each slide’s content type.

### T1 — Title slide

```
[PRESENTATION TITLE]             ← 36pt+, bold
[Subtitle / course / context]    ← 24pt
[Author] · [Date] · [Institution]
```

### T2 — Section divider

```
[SECTION NUMBER + NAME]          ← large, centred, accent colour
[1-sentence teaser of section]   ← optional, italic
```

Use between major topic changes. Acts as a cognitive reset for the audience.

### T3 — Concept slide (most common)

```
[Slide title = one-sentence claim]     ← title bar
[Key visual / diagram / equation]      ← 60% of slide area
[2–4 bullet fragments]                 ← support the visual
[Caption if visual is present]         ← small, italic
```

### T4 — Formula slide

```
[Slide title = what the formula describes]
[Formula — display, centred]
[Symbol table: 2-column, Symbol | Definition]
[Physical meaning — 1 sentence]
[Worked example or plot — if FORMULA_DEPTH = numerical]
```

### T5 — Comparison / trade-off slide

```
[Slide title = the question being compared]
[2-column or 2-panel layout]
Left: Option A          Right: Option B
[Visual A]              [Visual B]
[Key difference — highlighted row or callout]
```

### T6 — Result / evidence slide

```
[Slide title = the conclusion, not the method]
[Primary result visual — large, centre]
[What to notice — 2–3 annotated callouts on the visual]
[Source / context — caption]
```

### T7 — Summary / takeaways slide

```
KEY TAKEAWAYS              ← fixed title
• [Takeaway 1]             ← exactly 3–5 bullets
• [Takeaway 2]             ← each max 8 words
• [Takeaway 3]
[Optional: "The single most important thing to remember:" + 1 bold sentence]
```

---

## Phase 4 — Output Generation

### 4.1 — Slide production format

Produce each slide as a structured Markdown block, then compile to the requested format.

**Per-slide Markdown format:**

```markdown
---
## Slide N — [Title]
**Type:** T3 (Concept)
**Content:**
[body text, bullet fragments, formula if applicable]

**Visual:**
[describe the figure/diagram to produce, OR embed the generated matplotlib/SVG code]

**Caption:** [figure caption]

**Speaker notes:**
[everything the presenter would say that is NOT on the slide —
this is where full explanations, derivation detail, and context live]
---
```

### 4.2 — PDF compilation

After generating all slide Markdown blocks:

**Option A — HTML → PDF (default, no LaTeX required)**

Generate a self-contained HTML presentation file using **Reveal.js** (CDN):

```html
<!DOCTYPE html>
<html>
<head>
  <link rel="stylesheet" href="[https://cdn.jsdelivr.net/npm/reveal.js/dist/reveal.css](https://cdn.jsdelivr.net/npm/reveal.js/dist/reveal.css)">
  <link rel="stylesheet" href="[https://cdn.jsdelivr.net/npm/reveal.js/dist/theme/white.css](https://cdn.jsdelivr.net/npm/reveal.js/dist/theme/white.css)">
  <script src="[https://cdn.jsdelivr.net/npm/katex/dist/katex.min.js](https://cdn.jsdelivr.net/npm/katex/dist/katex.min.js)"></script>
  <link rel="stylesheet" href="[https://cdn.jsdelivr.net/npm/katex/dist/katex.min.css](https://cdn.jsdelivr.net/npm/katex/dist/katex.min.css)">
</head>
<body>
  <div class="reveal"><div class="slides">
    <section></section>
  </div></div>
  <script src="[https://cdn.jsdelivr.net/npm/reveal.js/dist/reveal.js](https://cdn.jsdelivr.net/npm/reveal.js/dist/reveal.js)"></script>
  <script>Reveal.initialize({hash: true, slideNumber: true})</script>
</body>
</html>
```

Then export PDF via: open in Chrome → Print → Save as PDF → Layout: Landscape.
Instruct the user with this one-line instruction in the output.

**Option B — LaTeX Beamer (if source is LaTeX or formulas are heavy)**

Generate a compilable `.tex` file using the `beamer` class with `metropolis` theme.
Compile with `pdflatex [filename].tex && pdflatex [filename].tex`.

**Naming convention:** `[COURSE]_[TOPIC]_presentation_[AUDIENCE].pdf`

### 4.3 — Deliverable checklist

Before delivering output, verify every item:

- [ ]  Audience parameters collected and applied
- [ ]  Every slide has exactly one central idea
- [ ]  No slide exceeds the text density limit for the audience type
- [ ]  Every formula has all symbols defined on the same slide
- [ ]  Every visual has a caption
- [ ]  Colour usage consistent and accessible (max 3 content colours)
- [ ]  Speaker notes present for every content slide
- [ ]  Slide count ≤ 1 per 1.5 minutes of slot
- [ ]  Takeaways slide present at the end
- [ ]  Output format is PDF-ready (HTML for print, or compiled LaTeX PDF)

---

## Reference: Evidence Base

These design rules are grounded in the following research:

| Rule | Source |
| --- | --- |
| One idea per slide | Kawasaki 10-20-30 rule; Kosslyn *Clear and to the Point* |
| Text density limits | Sweller cognitive load theory (1988); Mayer CTML |
| Visuals improve retention 89% | Mayer, *Journal of Educational Psychology* |
| Progressive disclosure reduces load | Sweller (1988); Cavanagh & Thomas (2023) |
| Visual hierarchy guides attention | Gestalt psychology; Kosslyn (2007) |
| White space improves readability | Cavanagh & Thomas, *Business Communication Quarterly* (2023) |
| Min 30pt font | Kawasaki (2004); confirmed by readability research |
| Colour: max 3 + semantic consistency | Universal design guidelines; WCAG 2.1 |

---

## Constraints

- Never start writing slides before Phase 0 is complete
- Never put speaker-level explanation text on the slide itself — it goes in speaker notes
- Never use more than 2 equations per slide
- Never produce a visual without a caption
- All formulas must render correctly in the output format (KaTeX for HTML, LaTeX for PDF)
- If source material order is suboptimal for learning, reorder it and state the reordering rationale explicitly