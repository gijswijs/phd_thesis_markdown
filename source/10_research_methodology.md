# Research Methodology

We will run a Bitcoin node with a Lightning Network node on top of it, running both in the cloud. We will run both nodes for a period of two months. During that period the following data will be collected:

- Bitcoin exchange rate against the US Dollar
- Topological connectedness of the PCN

The gathered information together with the data available in the blockchain itself, e.g. transaction fees, will be used to predict the activities on the PCN.

Secondly, the information obtained during those two months can be used to test the taint resistance of transactions performed on the PCN in the context of a passive adversary. This also allows for developing an PCN attack model in the context of an active adversary. Following this model we will set up one to multiple Lightning nodes to allow for a second round of data gathering. During this second round we will test multiple active adversary heuristics, and measure the resulting taint resistance of transactions performed on the PCN.

Thirdly, using Supervised Machine Learning algorithms and a training set data gathered in the previous phase, we will produce an inferred function which can be used to decrease the taint resistance of yet to be identified transactions.
