# Research Methodology

In order to research whether interactions between different LN client software implementations play a role, we must first determine which LN clients are available. By determining the network share of each client type, we are able to determine the most important clients. We will then create a wrapper for each client to make it possible to control each client through their respective API's in a uniform way.
Those clients are then used to run a local testing cluster of LN nodes. On this cluster we first analyze the impact of BDA on value privacy. Subsequently we will analyze the whether the onion routing protocol is resilient enough to provide relationship anonymity. Finally we will develop or propose countermeasures for the attacks we describe.

## Network shares

We will use 1ML Lightning Network Search and Analysis Engine[^1ml] to estimate respective proportions of each client in LN. 1ML is a website that publishes the current state of the LN graph and allows for node owners to self-report on a voluntary basis the type of client they use. We will choose the three top  LN clients with the largest network share for analysis in our local test cluster.

[^1ml]: https://1ml.com/

## Client Wrapper

All clients have an API that allows for communication with a local instance of a client. Although all clients follow the same LN specifications, the implementations of those API's differ on details. E.g. the commands used for connecting to peers, or opening up payment channels, and the parameters needed to do so, differ slightly across the three clients. Some commands run synchronously on one client while asynchronously on another. Therefor it is necessary to develop a wrapper for each of the clients' API, making it possible to address the API programmatically in a uniform way, independent of the type of client.

All three clients offer route discovery functionality, that searches the network graph for a feasible route for a given payment between two nodes. In a basic scenario, where three nodes are connected using two channels, it's a given which route will be returned, since there's only one possibility. It is to be expected that in more complex test clusters the discovered route might differ, depending on the implementation of the client. For a BDA to be successful, the route needs to be exactly as expected. We need to develop a route creation algorithm, that returns a route in the required format for each client along a predetermined route.

In the end the wrapper will support the commands listed in [@tbl:clients].

\footnotesize
|    generic     |        LND        |         c-lightning          |          Eclair          |
| :------------- | :---------------- | :--------------------------- | :----------------------- |
| getInfo        | getinfo           | getinfo                      | getinfo                  |
| connect        | peers (POST)      | connect                      | connect                  |
| disconnect     | peers (DELETE)    | disconnect                   | disconnect               |
| listPeers      | peers (GET)       | listpeers                    | peers                    |
| openChannel    | channels (POST)   | fundchannel                  | open                     |
| closeChannel   | channels (DELETE) | close                        | close                    |
| listChannels   | channels (GET)    | listchannels                 | channels                 |
| describeGraph  | graph (GET)       | listchannels [^listchannels] | allchannels &            |
|                |                   |                              | allnodes                 |
| newAddressIso  | newaddress (GET)  | newaddr                      | newaddress [^newaddress] |
| sendToRoute    | channels/         | sendpay &                    | sendToRoute              |
|                | transactions/     | waitsendpay                  |                          |
|                | route (POST)      |                              |                          |
| getForcedRoute | -                 | -                            | -                        |

Table: Different commands used by the top three clients, and their translation to a generic command used by the wrapper {#tbl:clients}

\normalsize

Using the wrapper it is possible to implement several algorithms, and run them on any possible configuration of different clients across three nodes.

[^listchannels]: c-lightning returns all channels out of the network graph as it is known to the client, when using listchannels, whereas the other clients return the channels of that specific node. The other clients have a separate command for returning the network graph as it is known to the client.
[^newaddress]: Eclair doesn't support a wallet, instead it uses bitcoind's wallet

## Testing cluster

The open source tool Simverse[^simverse] will be used to create a testing environment. Simverse generates a local cluster of LN  nodes, each running one of three supported clients. Those clients align with the clients with the largest share. Each LN node runs in it's own Docker container and Docker-compose is used to manage the cluster.

The LN nodes use Bitcoin Core's Bitcoind implementation as a Bitcoin backend. Bitcoind will run in regression testing mode, known as regtest mode. This is a local test mode, making it possible to almost instantly create blocks with no real world value. Using regtest mode, the different implementations can be tested without incurring transaction fees for the on-chain transactions and without having to wait for blocks to be mined.

[^simverse]: https://github.com/darwin/simverse

## Improve BDA algorithm

The original minmaxBandwidth algorithm proposed by Herrera-Joancomarti [-@Herrera-Joancomarti2019] is bound by an upper limit set by MAX_PAYMENT_ALLOWED. This limit makes it impossible to probe balances that are higher than $2^{32} - 1 msat$.

Consider a channel $AB$ with capacity $C_{AB}$. Since $C_{AB} = C_{BA} = balance_{AB} + balance_{BA}$, the following holds

$C_{AB} < 2^{33} \implies min\left \{ balance_{AB}, balance_{BA} \right \} < 2^{32}$

For all channels with a capacity $C_{AB} < 2^{33}$ there's always a balance lower than  $2^{32}$ on one of the ends of the channel. With this knowledge we can extend the algorithm by letting it probe the channel from the other side, once we assess that the balance is higher than MAX_PAYMENT_ALLOWED on the initial probing side. This setup requires an optional second channel from the adversary Node M to Node B, to be able to probe the channel between Node A and Node B from the side of Node B.

(See [@fig:twoway])

<div id="fig:twoway">
\tikzset{
    auto,node distance =1 cm and 1 cm,semithick,
    state/.style ={circle, draw, minimum width = 0.9 cm},
    optional/.style={dashed},
}
\begin{tikzpicture}
  \node[state] (m) at (0,0) {$M$};
  \node[state] (a) [below left =of m, xshift=0.4cm] {$A$};
  \node[state] (b) [below right =of m, xshift=-0.4cm] {$B$};
  \path (m) edge[bend right=20] (a);
  \path (a) edge[bend right=20] (b);
  \path[optional] (m) edge[bend left=20] (b);
\end{tikzpicture}

Basic scenario with an optional second channel for two-way probing
</div>

We will leverage this fact to create an algorithm that can disclose balances from channels with a higher capacity.

## Payment correlation

We will first confirm payment correlation in our test cluster, using the hash for the secret preimage, which remains the same throughout the entire payment route. By using two collaborating nodes on a payment path, they both can monitor the HTLC's for the same hash. In doing so it's possible to connect the sender with the receiver in situations where the collaborating nodes are the entry relay and exiting relay of a route. This passive payment correlation is similar to passive traffic-analysis used for end-to-end correlation in Tor networks. We will also assess the feasibility of using other parameters for payment correlation like expiry and payment amounts.

Subsequently we will try to use active payment correlation. By delaying Sphinx packets at the entry relay and by measuring the delay at the exit relay, it's possible to link entry and exit.

Both passive and active payment correlation will both be evaluated in our test cluster and in Lightning Network running on Bitcoin Mainnet to assess whether our attacks are robust against the noise added by a full scale production network.

## Countermeasures

The improved BDA and the Payment correlation attack are attacks on value privacy and relationship anonymity. Based on our analysis of these attacks we will suggest and develop countermeasures. When possible we will include the countermeasures in our analysis to measure the effect. Countermeasures can take the form of suggesting improvements that make it impossible to leak information, or, when the protocol requires us to leak information to a certain extent, add noise to the information in a way that insures differential privacy.

TODO: LEESVOER! Niet vergeten te verwijderen uit het voorstel!
Papers
Sphinx: A compact and provably secure mix format
Hijacking Routes in Payment Channel Networks : A Predictability Tradeoff
Anonymous Multi-Hop Locks for Blockchain Scalability and Interoperability
Split Payments in Payment Networks
Sprites and State Channels: Payment Networks that Go Faster than Lightning

Mimblewimble?

TOR papers:
DeepCorr: Strong flow correlation attacks on tor using deep learning
Users get routed
On Flow Correlation Attacks and Countermeasures in Mix Networks

Links:
https://github.com/ElementsProject/scriptless-scripts/blob/master/md/multi-hop-locks.md#notation
https://suredbits.com/payment-points-part-2-stuckless-payments/
https://suredbits.com/payment-points-part-3-escrow-contracts/
https://suredbits.com/payment-points-part-4-selling-signatures/

Al gelezen:
https://en.wikipedia.org/wiki/Tor_(anonymity_network)#Weaknesses
https://cyber.stanford.edu/sites/g/files/sbiybj9936/f/olaoluwaosuntokun.pdf
https://medium.com/@rusty_lightning/decorrelation-of-lightning-payments-7b6579db96b0
https://suredbits.com/payment-points-part-1/

Courses:
https://www.udemy.com/course/graph-theory/?ranMID=39197&ranEAID=QB%2FWso%2FfaNU&ranSiteID=QB_Wso_faNU-xeG_BsmmddWgxA4neStgpw&LSNPUBID=QB%2FWso%2FfaNU
https://www.coursera.org/learn/graphs?ranMID=40328&ranEAID=QB%2FWso%2FfaNU&ranSiteID=QB_Wso_faNU-tUJNKrk0LEXEgaj3b1QG_w&siteID=QB_Wso_faNU-tUJNKrk0LEXEgaj3b1QG_w&utm_content=10&utm_medium=partners&utm_source=linkshare&utm_campaign=QB%2FWso%2FfaNU

Deze? https://eliademy.com/catalog/fundamentals-of-classical-set-theory.html

https://www.coursera.org/learn/datasciencemathskills
https://www.coursera.org/learn/formal-concept-analysis