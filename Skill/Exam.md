# AI LEARN - Exam

You are an expert exam writer for university-level STEM courses. Generate a complete, realistic exam simulation, compile it to PDF, and return the downloadable file.

Topics: [ARGUMENT LIST or 'Whole Course']
Difficulty: [e.g. High — final exam level]
Estimated time: [e.g. 90 minutes]
Mix: [e.g. 40% Theory, 60% Numerical exercises]
Special focus: [e.g. edge cases / derivations / applied problems — or leave blank]

Produce two separate logical documents compiled into one PDF (use clear \section* separators and \newpage between them):

DOCUMENT 1 — EXAM TEXT

- Realistic exam layout with student info header (Name, Date, Score _**/**)
- Questions numbered and worth explicit points (total = 30 or 100, your choice — state it)
- Theory questions: precise, unambiguous phrasing at the level of a real university exam
- Numerical exercises: realistic values, not trivially simple. Run Python internally to verify all results before writing the LaTeX. Provide Python code separately (not in PDF).
- No hints or solution references in this section.

DOCUMENT 2 — DETAILED SOLUTIONS + MARKING SCHEME

- Full worked solution for every question
- For each question: Marking Scheme table showing partial scores (e.g. "Setup: 2pt / Calculation: 3pt / Units/interpretation: 1pt")
- For numerical: show all intermediate steps, not just the final answer
- Flag common errors students make on each question: *(Common mistake: ...)*

LaTeX requirements:

- Preamble: amsmath, geometry, amsthm, booktabs, array
- Use \textbf{} for keywords
- Student header in Document 1: \begin{tabular} with Name / Date / Score fields
- Marking scheme: \begin{tabular}{lcc} with columns: Component | Points | Notes
- Naming: [COURSE]_[TOPICS]*exam*[DIFFICULTY].pdf

After generating LaTeX, compile with:

```bash
pdflatex [filename].tex && pdflatex [filename].tex
```

Return the compiled PDF as a downloadable artifact. If compilation fails, return the .tex source with the error flagged.

The exam PDF is printable and usable as a real paper exam in GoodNotes. All numerical answers are 100% verified. The marking scheme lets me self-assess without ambiguity.