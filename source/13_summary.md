# Summary

Scalability solutions for Bitcoin take the form of overlays on to the Bitcoin Blockchain, that offload a significant percentage of the transactions into this overlay, dubbed the second layer. These solutions, called Payment Channel Networks have recently found ways to make this work in a trustless environment, making them a feasible solution for extending and improving upon the success of Bitcoin. Because these solutions take transactions, and thus information, off-chain, they have the added benefit of improving the level of privacy and anonymity that can be obtained while performing transactions through these networks.

Formal research into the actual, obtainable privacy in these networks has been sparse to non-existent. This study seeks to analyze and measure the privacy that can be obtained by participants in Lightning Network, the first, and currently only second layer network in production. It does so by running both Bitcoin and Lightning nodes, and collecting a data set of network traffic of Lightning Network. It will measure privacy of participants while being under attack from known and yet to be developed privacy attacks in terms of \varepsilon-differential privacy.

The research will formally analyze privacy in the context of LN and suggest ways of improving it through changes in the Ligtning protocol.

\newpage
