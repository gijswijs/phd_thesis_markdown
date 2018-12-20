# Summary

Scalability solutions for Bitcoin take the form of overlays on to the Bitcoin Blockchain, that offload a significant percentage of the transactions into this overlay, dubbed the second layer. These solutions, called Payment Channel Networks have recently found ways to make this work in a trustless environment, making them a feasible solution for extending and improving upon the success of Bitcoin. Because these solutions take transactions, and thus information, off-chain, they have the added benefit of improving the level of privacy and anonymity that can be obtained while performing transactions through these networks.

These privacy improvements are as of yet mostly theoretical, and formal research into the actual, obtainable privacy has been sparse to non-existent. This study seeks to analyze and measure the privacy that can be obtained by participants in those second layer networks. It does so by running both Bitcoin and Lightning nodes, and collecting data to determine the predictors of activity on the Lightning Network. Furthermore, this study will use inherent properties of payment channel networks to develop heuristics that can be used in the context of either passive or active adversaries to decrease the level of anonymity, measured as taint resistance.

Upon developing those heuristics we will use Supervised Machine Learning to produce an inferred function which can be used to decrease the taint resistance of yet to be identified transactions.

\newpage
