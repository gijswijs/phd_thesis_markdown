\newpage
\appendix

# Gantt chart

~~~{.mermaid loc=source/figures width=1000 format=pdf}
gantt
    title Research planning
    dateFormat  YYYY-MM-DD
    section Phase 0
         Reading literature           :active, a1, 2018-09-14, 2019-02-28
         Writing proposal     :active, a2, 2018-11-01, 2019-04-30
         Proposal defense: a3, after a2, 1d
    section Phase 1 Predictors
         Setting up Bitcoin & Lightning node      : crit, active, b1, 2018-11-01  , 2018-12-31
         Data collection for 1st article      : crit, 182d
         Writing article: 2019-06-01, 60d
    section Phase 2 Heuristics
        Data collection for 2st article      : 2019-07-01, 184d
        Writing article: c2, 2019-12-01, 60d
    section Phase 3 AML
        Data collection for 3rd article      : d1, after c2, 184d
        Writing article: d2 , 2020-07-01, 60d
    section Writing thesis
        Writing: after d2, 300d
~~~