# Literature Review

## Bitcoin

At its core a distributed ledger like the Bitcoin blockchain is an asset database that is shared across multiple sites [@Walport2015]. The entities or nodes involved in the ledger have a replicated version of the ledger available to them. Changes to the ledger are synchronized to all replicas by means of a peer-to-peer network. To ensure consistent replication across all nodes in a distributed ledger, a consensus algorithm is put in place. The peer-to-peer network in combination with the consensus algorithm enables the distributed ledger to exist without a central administrator or centralized storage.

## Privacy and anonymity

The nature of a distributed ledger, without a central trusted party, requires that all transactions are transparent and broadcasted to the nodes in the network. As a result, privacy can only be obtained by making it impossible to link transactions to identities [@Yli-Huumo2016].
The separation of transaction and identity is obtained by an asymmetric encryption system in which the hash of the public key acts as an account number or address.  These addresses should be interpreted  as pseudonyms for the account holder [@Breuker2013]. Account ownership is established by owning the corresponding private key, thus making it possible for the account holder to claim ownership of an address without revealing its identity.
Whether this can be considered anonymous depends on your definition of anonymity. Since the advent of bitcoin several alternatives (alt-coins) have been proposed that commit to stronger privacy requirements and as such adhere to a stricter definition of anonymity. E.g. Zerocoin uses a definition that stays true to the cryptographic notion of unlinkability, resulting in a system where one coin can never be distinguished from another. [@Miers2013]
Strong anonymity a proposed by Zerocoin was never a design goal of the Bitcoin system [@Reid2013], and the resulting protocol leaks information that can be used to de-anonymize participants. The underlaying, non-anonymous infrastructure of the internet and the inherent transparency of all transactions in the blockchain make this possible [@Herrera-Joancomart2015].
The amount of privacy that Bitcoin *does* provide is a well studied subject [@spagnuolo2014bitiodine; @koshy2014analysis; @barber2012bitter; @androulaki2013evaluating; @Meiklejohn2015; @Meiklejohn2013; @Reid2013]

## Taint resistance

Taking the original design of Bitcoin as a given, one can arrive at a different notion of anonymity, coined *taint resistance* [@Meiklejohn2015]. Taint resistance embraces the fact that a coin and its spending history are inseparable and as such focusses on obscuring the ownership of a coin at each point in its spending history.
Taint resistance is a quantifiable measure of anonymity. It is a property of the transaction and can be applied to each transaction of a coin in its spending history.
Taint resistance has a value ranging from 0 to 1, where 1 means an adversary can't achieve any accuracy in identifying the inputs of the Tx that tainted the output (also called the *taint set*) and 0 means that an adversary can identify the exact set of Txs that tainted the output. The latter means an adversary has exact knowledge of the taint set.

## Account clustering

Account clustering is one of the techniques being used to reveal participants. In a longitudinal analysis of the flow of coins through the Bitcoin network, properties of transactions in the blockchain can be used to deduce statements about the entities performing the transactions. E.g. if two ore more addresses are inputs to a single transaction, one can assume that the addresses are controlled by the same entity [@Ron2013]. Additionally, one can assume that a one-time change address is controlled by the same entity that controls the input addresses [@Meiklejohn2013]. These heuristics enable clustering of addresses and linking them to entities.
More recently Supervised Machine Learning techniques have been proven to be successful in uncovering anonymity by using training set data consisting of ≈ 200 million transactions that had previously been clustered and whose participants had been identified [@Harlev2018].

## Overlays and the Second layer

Overlays are Bitcoin improvements, proposed as solutions that run on top of the Bitcoin blockchain and don't require modifying the Bitcoin protocol. In some case small adjustments are needed to the Bitcoin protocol to make these overlays possible, which tend to be achieved via BIPs. Overlays are sometimes jointly described as Bitcoin's Second Layer and should be distinguished from initiatives that seek improvements by introducing new virtual currencies altogether.

## Active or passive adversaries

Using the definition of taint resistance to measure anonymity, one can measure this in two ways. Using only passive adversaries or using active adversaries. A passive adversary can only use the blockchain to get information on the taint set of a specific output. This means that information that is available in the second layer, but doesn't reach the blockchain is unavailable to a passive adversary. An active adversary on the other hand can participate in the second layer and can use this extra information to his or her advantage to identify the taint set.

## Trustless Payment Channels

It was Satoshi Nakamoto, the mysterious pseudonymous person or persons famous for being the developer of Bitcoin, who suggested the use of transaction replacement for something he called high frequency trading [@Hearn2013]. In Nakamoto's proposal a group of parties could keep updating a transaction that had yet to be broadcasted to the Blockchain. The order of the updates was kept by a sequence number. Only the last agreed upon transaction needed to be broadcast. By doing so all the transactions prior to the final transaction were kept off-chain. The proposed solution depended on miners to commit the final transaction (the transaction with the highest sequence number) to the Blockchain. Since there is no incentive for miners to respect the sequence number [@Harding2015], one of the involved parties could collude with a miner to have a non-final version committed to the Blockchain, possibly stealing funds from the other parties. As such the solution couldn't operate in a trustless environment.

The scalability issues that face Bitcoin have renewed the interest in some form of transaction replacement to improve the scalability of Bitcoin. Micropayment channels or Payment channels are a class of techniques designed to make it possible to make Bitcoin transactions that aren't committed to the blockchain. In a typical setting of a payment channel, 2 or more participants keep an off-chain ledger amongst themselves that keeps track of the outstanding balances between the participants. Upon closing of the payment channel, the final balance is broadcasted to the blockchain.

*Decker-Wattenhofer duplex payment channels* was the first proposal for payment channels that didn't sacrifice the property of being able to operate in a trustless environment [@Decker2015].

*Poon-Dryja payment channels* was the second in this new class of trustless payment channels [@Poon2016]. Poon-Dryja payment channels form the foundation of the Lightning Network. The Lightning Network has emerged as the most prominent PCN to date [@Malavolta2017].

The most recent addition to the trustless PCN's is *Decker-Russell-Osuntokun eltoo Channels* [@Decker2018]. The Eltoo PCN tries to improve several aspects of its two predecessors, e.g. the absence of a punishment branch and simplifying watchtower design.

## PCN Privacy Threat Model

In contrast with the privacy research pertaining Bitcoin, the research on privacy guarantees offered or desired by PCNs is lacking [@Malavolta2017].
For a formal analysis of privacy in the setting of trustless PCN's a privacy threat model is a necessity. We use the threat model proposed by Malavolta [@Malavolta2017]. This threat model describes four notions of interest:

- Balance security: participants don't run the risk of losing coins to a malevolent adversary.
- Serializability: executions of a PCN are serializable as understood in concurrency control of transaction processing, i.e. for every concurrent processing of payments there exists an equivalent sequential execution.
- (Off-path) value privacy: malicious participants in the network cannot learn information about payments they aren't part of.
- (On-path) relationship anonymity: given at least on honest intermediary, corrupted intermediaries cannot determine the sender and the receiver of a transaction better than just by guessing.

## Onion Routing, Mix Networks and Sphinx

Mix networks [@Chaum1981] are routing protocols that work by chaining a set of proxy servers to create difficult to trace communication. This is done by taking in multiple messages from multiple senders, shuffling them and sending them along in random order to the next server in a chain. This process breaks the connection between sender and receiver, making it harder to listen in on communication between two participants. Because a proxy server only knows the direct sender of the message and the direct receiver of the message, neither of which has to be the actual sender or receiver, a mix network is resistant to malicious proxy servers.

Onion routing [@Reed1998] is a routing scheme used for anonymous communication over a network. In an onion network messages are sent over a route of proxy servers. The message is wrapped in layers of encryption that need to be decrypted by each server successively. By unwrapping a layer of encryption a proxy server gets to know where to send the message wrapped with the remaining layers of encryption next. This peeling of layers is why the entire data structure of a message is called an onion.

Onion routing gets it security from the assumption that an adversary can't see the entire route, but only a subset of it. If an adversary does see the entire route, the anonymity breaks down completely. Mix networks however, do work in a situation where an adversary would see the entire network and the traffic within it, because the mixing of messages from multiple senders makes it impossible to detect who is communicating with whom. This security comes at trade-off in the form of loss of real-time communication, since the proxy servers have to wait for messages from other senders to be able to perform a mix.

The Sphinx protocol is a mix protocol that uses onion routing. It has all the security properties set out by Camenisch and Lysyanskaya [@Camenisch2006a] with the added property that an adversary in the middle of a path is even unable to distinguish forward messages from replies. The Sphinx protocol is the protocol used in Lightning Network.

## Balance Discovery Attack

Recent research has already proven that value privacy isn't fully obtainable in the Lightning Network. With an attack coined the balance discovery attack [@Herrera-Joancomarti2019] it is possible to obtain information about Lightning payments.  In the basic scenario for channel balance discovery  it is assumed that there is an open payment channel $AB$ between Alice, $A$, and Bob, $B$, with capacity $C_{AB}$. The goal of the adversary, Mallory, $M$, is to discover the balances of each node in channel $AB$: $balance_{AB}$ and $balance_{BA}$. To do so Mallory opens up a channel with Alice (see [@fig:simple]).

<div id="fig:simple">
\tikzset{
    auto,node distance =1 cm and 1 cm,semithick,
    state/.style ={circle, draw, minimum width = 0.9 cm}
}
\begin{tikzpicture}
  \node[state] (m) at (0,0) {$M$};
  \node[state] (a) [right =of m] {$A$};
  \node[state] (b) [right =of a] {$B$};
  \path (m) edge (a);
  \path (a) edge (b);
\end{tikzpicture}

Basic BDA were the adversary Mallory tries to disclose the balance between Alice and Bob
</div>

Mallory tries to to disclose $balance_{AB}$ by routing invalid payments through $M \leftrightarrow A \leftrightarrow B$, using the basic BDA algorithm. The inputs parameters for the algorithm are the target node $B$, the route to the target node, the value range to search in, given by 0 and $C_{AB}$, and the required accuracy for the algorithm. The algorithm creates invalid payments by using random, invalid payment hashes for each payment. The value for each payment follows a binary search pattern for which the initial lower and upper bounds are given by the value range input.

Bob, the recipient of the payment, is the only one who can determine that a payment from Mallory is invalid. Therefore, receiving an error stating the payment hash is invalid, means that $balance_{AB}$ was sufficient to route the payment, because if it was not, Alice would have returned an error stating insufficient funds and Bob would never have known about the payment. This fact is leveraged by updating the lower bound of the binary search to the value of the last payment. If however the failure message states insufficient funds, the upper bound is updated with the value of the last payment. This process repeats itself recursively until the difference between the upper bound and the lower bound of the binary search is within the threshold set by the accuracy input. The algorithm returns a tuple that gives the range within which $balance_{AB}$ sits. Since the capacity of the channel $C_{AB}$ is known, the $balance_{BA}$ can be calculated with $balance_{BA} = C_{BA} - balance_{AB}$.

By periodically executing a BDA, an adversary van monitor balances over time. This allows for tracing transactions. Therefore, this type of attack poses a threat for the value privacy as described in the threat model above.

## Network shares

LN nodes do not broadcast the type of software that is being used to run that node. It is possible, however, to use the different default settings for channel policies amongst the three main clients to infer the type of client a specific node uses [@Pérez-Solà2019]. Another way of detecting the type of software a node runs is by using 1ML Lightning Network Search and Analysis Engine[^1ml]. 1ML is a website that publishes the current state of the LN graph and allows for node owners to self-report on a voluntary basis the type of client they use. 1ML is the largest LN search engine and to my knowledge currently the only one that allows for self-reporting.

[^1ml]: https://1ml.com/

## Differential Privacy

Differential privacy is the concept of sharing information about a dataset without sharing information about a particular entry in that data set. An algorithm is said to be differential private if an observer cannot tell whether a calculation on that data set included a particular entry or not. It was shown that it is impossible to publish arbitrary queries on a dataset without revealing some amount of private data [@Dinur2003]. This led to the ascertainment that it is impossible to protect privacy in such datasets without injecting noise into the results of the queries. This led to the development of differential privacy in which the amount of noise needed and a general mechanism for doing so were formalized [@Dwork2006].
