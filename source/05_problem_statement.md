# Problem statement

The level of anonymity to be attained in Bitcoin transactions is well studied [@spagnuolo2014bitiodine; @koshy2014analysis; @barber2012bitter; @androulaki2013evaluating; @Meiklejohn2015; @Meiklejohn2013; @Reid2013], but the amount of anonymity to be attained in Lightning Network (LN) running on top of Bitcoin, has yet to be determined through formal privacy analysis [@Malavolta2017]. In recent years contributions have been made to close this gap, by studying the tension between utility and privacy [@Tang2019] and privacy preserving cryptographic primitives [@Malavolta2019].
This study adds to this emerging body of knowledge by quantifying the achievable anonymity of participants in LN under attack of both passive and active adversaries.
It does so by using a formal threat model [@Malavolta2017] and using $\varepsilon$-differential privacy [@Dwork2006] and taint resistance [@Meiklejohn2015] as a quantities for measuring privacy loss.
With LN being touted as *the* solution for Bitcoin's scalability problem, a proper assessment of the anonymity risks of LN is of great importance.
