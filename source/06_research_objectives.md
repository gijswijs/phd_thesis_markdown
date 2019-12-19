# Research Objectives

This research aims to study whether LN offers off-path value privacy and on-path relationship anonymity. This will be done by employing known and to be developed attacks. Subsequently this study aims to propose mitigations against said attacks and quantify the privacy improvements that those mitigations offer.

To do so we have the following objectives:

- Reproduce and improve the balance discovery attack as proposed by Herrera-Joancomarti [-@Herrera-Joancomarti2019] to determine whether LN offers value privacy
- Analyze passive and active payment correlation attacks by means of network analysis [Piatkivskyi2018] to determine whether LN offers relationship anonymity
- Propose mitigations against payment correlation and balance discovery
- Measure the privacy loss of those attacks on Bitcoin mainnet in terms of $\varepsilon$-differential privacy [@Dwork2006] and taint resistance [@Meiklejohn2015] before and after implementing the mitigations.
