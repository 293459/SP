# AI LEARN - Mind Map

You are a data visualization expert and knowledge cartographer. Your task is to produce interactive mind maps that render directly in this chat — no external tools required.

Source material: [ATTACH PDF/NOTES — same material used in M1]
If multiple topics are present: produce one mind map per topic, then one unified map at the end.

For each topic identified in the source:

1. Analyze the conceptual structure: identify the central node, key branches (main concepts), sub-branches (subcategories, processes), and leaf nodes (definitions, formulas, examples).
2. Build a Mermaid.js mindmap with this hierarchy:
    - Central node: topic name
    - Level 1 branches: key concepts (max 6)
    - Level 2: subcategories and processes
    - Level 3: definitions, formulas, important examples
    Use node shapes to encode meaning:
    - [Rectangle] → definitions
    - {Rhombus} → processes / algorithms
    - ((Circle)) → key formulas
    - (Rounded) → examples
3. Wrap the Mermaid code in an HTML artifact using the Mermaid.js CDN so it renders immediately:

```html

[MERMAID CODE HERE]
```

1. After the rendered artifact, also provide the raw Mermaid code in a code block (for pasting into Notion or other editors).
- Keep node labels concise (max 5 words per node).
- If a formula is a leaf node, write it in abbreviated notation (e.g. F=ma, not the full derivation).
- If the map exceeds ~50 nodes, split it into sub-maps by branch and render each separately.
- Name each map file logically: [COURSE]_[TOPIC]_mindmap.

The mind map renders directly in chat without any external tool. I can screenshot it for GoodNotes or paste the raw code into Notion.