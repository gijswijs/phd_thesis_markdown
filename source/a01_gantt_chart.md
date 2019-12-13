\newpage
\appendix

# Gantt chart

~~~{.mermaid loc=source/figures width=1000 format=pdf}
gantt
    title Research planning
    dateFormat  YYYY-MM-DD
    section Phase 0
         Reading literature           :done, a1, 2018-09-14, 2019-11-30
         Research proposal version RARA    :done, a2, 2018-11-01, 2018-12-20
         Research proposal final version   :active, a2, 2019-12-01, 2019-12-20
         Proposal defense: a3, 2020-01-15, 2020-01-16
    section Phase 1 BDA
         Setting up Bitcoin & Lightning node      : done, b1, 2018-11-01, 2019-07-01
         Data collection for 1st article      : done, 2019-10-10
         Writing article: done, 2019-06-18, 2019-11-30
    section Phase 2 Payment correlation
        Data collection for 2st article      : c1, 2019-12-01, 2020-01-31
        Writing article: c2, after c1, 90d
    section Phase 3 Countermeasures
        Data collection for 3rd article      : d1, after c2, 60d
        Writing article: d2, after d1,  90d
    section Writing thesis
        Writing: after d2, 210d
        Viva: 1d
    section Conferences
        Financial Cryptography and Data Security: 2020-02-10, 2020-02-14
        International Information Security and Privacy: 2020-05-26, 2020-05-28
~~~