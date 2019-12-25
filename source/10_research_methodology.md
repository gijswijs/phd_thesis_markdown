# Research Methodology

Our research is quantitative in nature and therefor uses an experimental approach. An overview of the methodology is provided below (See [@fig:method]) and subsequently explained in more detail.

<div id="fig:method">
\tikzset{
    auto,
    node distance=0.5cm,
    arrow/.style ={thick,->,>=stealth},
    process/.style={rectangle, minimum width=2.5cm, minimum height=1cm, text centered, draw=black, text width=2.5cm, font=\footnotesize},
    title/.style={text centered, text width=2.5cm, minimum width=2.5cm, align=right, font=\bfseries \footnotesize},
    row/.style={text centered, text width=2.5cm, minimum width=2.5cm, align=left, font=\bfseries \footnotesize}
}
\begin{tikzpicture}[]

\node (a) [process] {Capture LN network traffic};
\node (b) [process, below = of a] {Create BDA test scenario's};
\node (c) [process, right = of a] {Capture LN network traffic};
\node (d) [process, below = of c] {Create PC test scenario's};
\node (e) [process, left = of b] {Extract 1ML data};
\node (f) [process, below = of b] {Improved BDA algorithm};
\node (g) [process, below = of d] {PC algorithm};
\node (h) [process, below = of f] {BDA with mitigations};
\node (i) [process, below = of g] {PC with mitigations};
\node (j) [process, below = of h] {$\varepsilon$-differential privacy};
\node (k) [process, below = of i] {$\varepsilon$-differential privacy and/or taint resistance};
\node (l) [process, left = of j] {Calculate proportions with FPCF};


\node (bda) [title, above = of a] {Value\\Privacy};
\node (pc) [title, above = of c] {Payment Correlation};

\node (analysis) [row, left = of l] {Data Analysis};
\node (data) [row, above = of analysis, yshift=6.5cm] {Data\\Collection};

\draw [arrow] (a) -- (b);
\draw [arrow] (a) -- (e);
\draw [arrow] (c) -- (d);
\draw [arrow] (b) -- (f);
\draw [arrow] (d) -- (g);
\draw [arrow] (f) -- (h);
\draw [arrow] (g) -- (i);
\draw [arrow] (h) -- (j);
\draw [arrow] (i) -- (k);
\draw [arrow] (e) -- (l);

\node [fit={(a) (b) (e) (f) (h) (j) (bda) ($(l.south)+(0,-9pt)$)},draw, dashed] {};
\node [fit={(c) (d) (g) (i) ($(k.south)+(0,-10pt)$) ($(pc.north)+(0,2pt)$)},draw,dashed] {};
\node [fit=(analysis) (j) (k) (l),draw,dotted, inner xsep=10pt] {};
\node [fit=(data) (a) (b) (c) (d) (e) (f) (g) (h) (i),draw,dotted, inner xsep=10pt] {};

\end{tikzpicture}

Schematic representation of the research methodology
</div>

## Data Collection

In order to research whether interactions between different LN client software implementations play a role, we must first determine which LN clients are available. By determining the network share of each client type, we are able to determine the most important clients. We will then create a wrapper for each client to make it possible to control each client through their respective API's in a uniform way. Those clients are then used to run a local testing cluster of LN nodes. On the testing cluster we will run test scenario's to evaluate BDA and payment correlation algorithms and their mitigations.

### Extract 1ML data

We will use 1ML to estimate respective proportions of each client in LN. We will choose the three top LN clients with the largest network share for analysis in our local test cluster.

\FloatBarrier

### Client Wrapper

The top three LN clients will be used to run certain test scenario's on. To be able to run a scenario regardless of the type of software a LN node runs, we need a way to uniformly control each of the three clients.

All clients have an API that allows for communication with a local instance of a client. Although all clients follow the same LN specifications, the implementations of those API's differ on details. E.g. the commands used for connecting to peers, or opening up payment channels, and the parameters needed to do so, differ slightly across the three clients. Some commands run synchronously on one client while asynchronously on another. Therefore it is necessary to develop a wrapper for each of the clients' API, making it possible to address the API programmatically in a uniform way, independent of the type of client.

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

Using the wrapper it is possible to implement several test scenarios, and run them on any possible configuration of different clients across multiple nodes.

[^listchannels]: c-lightning returns all channels out of the network graph as it is known to the client, when using listchannels, whereas the other clients return the channels of that specific node. The other clients have a separate command for returning the network graph as it is known to the client.
[^newaddress]: Eclair doesn't support a wallet, instead it uses bitcoind's wallet

### Testing cluster

The open source tool Simverse[^simverse] will be used to create a testing environment. Simverse generates a local cluster of LN nodes, each running one of three supported clients. Those clients align with the clients with the largest share. Each LN node runs in it's own Docker container and Docker-compose is used to manage the cluster.

The LN nodes use Bitcoin Core's Bitcoind implementation as a Bitcoin backend. Bitcoind will run in regression testing mode, known as regtest mode. This is a local test mode, making it possible to almost instantly create blocks with no real world value. Using regtest mode, the different implementations can be tested without incurring transaction fees for the on-chain transactions and without having to wait for blocks to be mined.

With the testing cluster in place we can use the wrapper is the intermediary between the test scenario and the node.

[^simverse]: https://github.com/darwin/simverse

### Improve BDA algorithm

The first test scenarios will consider the existing BDA algorithm. The original minmaxBandwidth algorithm proposed by Herrera-Joancomarti [-@Herrera-Joancomarti2019] is bound by an upper limit set by MAX_PAYMENT_ALLOWED. This limit makes it impossible to probe balances that are higher than $2^{32} - 1 msat$.

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

We will leverage this fact to create an algorithm that can disclose balances from channels with a higher capacity (See \ref{twowayProbing}).

\begin{algorithm}
\caption{Two-way Probing}\label{twowayProbing}
\begin{algorithmic}[1]
\Require route, target, maxFlow, minFlow, accuracy\_treshold
\Ensure bwidth, an array of tuples that gives the range of bandwidth discovered for each channel
\State $missingTests \gets True$
\State $bwidth.max \gets maxFlow$
\State $bwidth.min \gets minFlow$
\LState $channelCapacity \gets getInfo(target).capacity$
\While{missingTests}
  \If{$bwidth.max - bwidth.min \leq accuracy\_threshold$}
    \LState $missingTests \gets False$
  \EndIf
  \If{$bwidth.max \geq 2^{32}$}
    \LState $flow \gets 2^{32} - 1$
  \Else
    \LState $flow \gets (bwidth.min + bwidth.max) / 2$
  \EndIf
  \LState $h(x) \gets RandomValue$
  \LState $response \gets sendFakePayment(route = [route, target], h(x), flow)$
  \If{$response = UnknownPaymentHash$}
    \If{$bwidth.min < flow$}
      \LState $bwidth.min \gets flow$
    \EndIf
  \ElsIf{$response = InsufficientFunds$}
    \If{$bwidth.max > flow$}
      \LState $bwidth.max \gets flow$
    \EndIf
  \EndIf
  \If{$bwidth.min = 2^{32} - 1$}
    \LState $newTarget \gets route.pop()$
    \LState $route \gets route.push(target)$
    \LState $bwidthBA \gets twowayProbing(route, newTarget, bwidth.min, 0, accuracy\_treshold)$
    \LState $bwidth.min \gets channelCapacity - bwidthBA.max$
    \LState $bwidth.max \gets channelCapacity - bwidthBA.min$
    \LState $missingTests \gets False$
  \EndIf
\EndWhile
\State \textbf{return} $bwidth$
\end{algorithmic}
\end{algorithm}

### Payment correlation

The second set of testing scenarios to be run on the test cluster will consider payment correlation. We will first confirm payment correlation in our test cluster, using the hash for the secret preimage, which remains the same throughout the entire payment route. By using two collaborating nodes on a payment path, they both can monitor the HTLC's for the same hash. In doing so it's possible to connect the sender with the receiver in situations where the collaborating nodes are the entry relay and exiting relay of a route. This passive payment correlation is similar to passive traffic-analysis used for end-to-end correlation in Tor networks. We will also assess the feasibility of using other parameters for payment correlation like expiry and payment amounts.

Subsequently we will try to use active payment correlation. By delaying Sphinx packets at the entry relay and by measuring the delay at the exit relay, it's possible to link entry and exit.

Both passive and active payment correlation will both be evaluated in our test cluster and in Lightning Network running on Bitcoin Mainnet to assess whether our attacks are robust against the noise added by a full scale production network.

### Mitigations

The improved BDA and the Payment correlation attack are attacks on value privacy and relationship anonymity. Based on our analysis of these attacks we will suggest and develop countermeasures. When possible we will include the countermeasures in our analysis to measure the effect. Countermeasures can take the form of suggesting improvements that make it impossible to leak information, or, when the protocol requires us to leak information to a certain extent, add noise to the information in a way that insures differential privacy.

## Data Analysis

The 1ML data will be used as a sample of the population of LN nodes to determine the proportion of the different LN clients in the network. To determine the confidence interval we will apply a Correction Factor for Finite Populations (FPCF) because the population size is small (less than 1 million) and the sample size represents more than 5% of the population. The results of this analysis are already available and are summarized in appendix C.

We will measure this impact by means of increased $\varepsilon$-differential privacy and decreased taint resistance.

<div>
<!-- 
TODO: LEESVOER!
Papers
Sphinx: A compact and provably secure mix format
Hijacking Routes in Payment Channel Networks : A Predictability Tradeoff
Anonymous Multi-Hop Locks for Blockchain Scalability and Interoperability
Split Payments in Payment Networks
Sprites and State Channels: Payment Networks that Go Faster than Lightning
Privacy-Utility Tradeoffs in Routing Cryptocurrency over Payment Channel Networks
Foundations of State Channel Networks
Towards Secure and Efficient Payment Channels

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
https://towardsdatascience.com/understanding-differential-privacy-85ce191e198a

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

NOTES: 2019-12-18
http://acqnotes.com/acqnote/careerfields/5-steps-in-the-reasearch-process

Put in the algorithm
-->
</div>