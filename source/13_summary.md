# Summary

Bitcoin suffers from scalability issues because of the inherent limited capacity of the Bitcoin blockchain to store transactions. Scalability solutions for Bitcoin take the form of overlays on to the Bitcoin Blockchain that offload a significant percentage of the transactions into this overlay. These type of solutions are called payment channel networks (PCN). With the advent of Decker-Wattenhofer duplex payment channels we now have a solution for payment channels that doesn't sacrifice the property of being able to operate in a trustless environment. This makes them a feasible solution for improving the scalability of Bitcoin.

Because these solutions take transactions, and thus information, off-chain, they have the added benefit of improving the level of privacy and anonymity that can be obtained while performing transactions through these networks. While on-chain privacy is a well studied subject off-chain privacy in the context of PCN's lacks a rigorous analysis of the privacy guarantees offered or required in PCNs.

Malavolta was the first in 2017 to formalize the notions of interest from the perspective of security and privacy in PCNs. Using this definition we set out to prove our hypothesis, namely that LN currently doesn't meet two of the four requirements described by Malavolta, namely value privacy and relationship anonymity. The current LN protocol inherently leaks information about payments (value privacy) or information about the sender and receiver of a transaction (relationship anonymity) to malicious participants in the network.

To prove our hypothesis we will create a test cluster of LN nodes, and collect a data set of messages over the LN network while performing a set of test scenario's on the cluster. The dataset of network messages will be used to prove that the requirements for value privacy and relationship anonymity aren't met. Furthermore we will try to quantify the amount of privacy loss in terms of $\varepsilon$-differential privacy and taint resistance.

We will then proceed to propose improvements to the LN protocol that do meet the requirements of value privacy and relationship anonymity in a way that reduces privacy loss.
\newpage
