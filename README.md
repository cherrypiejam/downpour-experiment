%% # downpour Experiment
%% This repo contains scripts used for downpour experiments running on cloudlab

# Reimplementation of BitTyrant: Do Incentives Build Robustness in BitTorrent?

Gongqi Huang and Jingyuan Chen, COS 518, 2022

## Introduction
In peer-to-peer systems, a fundamental challenge is to disincentivize peers to 
free-ride by consuming others' resources without contributing to the system. In 
the BitTorrent file distribution protocol, each peer downloads file contents from
other peers while contributing its own upload bandwidth to transfer contents to 
others. A strategy called tit-for-tat is used to explicitly address the issue,
under which each peer only donate certain amount of upload bandwidth to another peer 
if that peer has donated relatively the same amount to it. Such a rule encourages
the peers to be altruistic since peers who don't upload can't expect to download 
from other peers.

More specifically, BitTorrent peers attempt to maximize their downloading
speed by downloading from any peer who sends pieces (file blocks of fixed size)
to them and upload pieces to the top k peers who contribute the most to them. 
In addition, they will split their upload bandwidth into k "fractions" and allocate
each fraction to one of the top k peers. This bandwidth is called the 
"equal-split bandwidth", and the set of the top k peers is called the "active set".
The action of not sending to peers who didn't contribute enough is called "choking",
and the action of sending to the peers who reciprocated is called "unchoking". 
To prevent low capacity peers from being starved, the Bittorrent protocol also
let peers to "optimistically unchoke" random selected peers periodically. If a peer A
is optimiscially unchoked by a peer B, B will uploads at the equal-split rate to
A for a period of time no matter how much A has contributed to B.

Although BitTorrent has had a great success in the real world deployment, which
seems to be a proof of how robust the incentive mechanism is, it is actually
amenable to strategic peers. The paper [] represents an approach that
utilizes the existence of altruism in BitTorrent to build a selfish strategic BitTorrent 
client called BitTyrant. BitTyrant carefully selects peers and contribution rates and 
could break the robustness of BitTorrent by benefiting from other peers' uploads while 
contributing at only much lower rate.

### BitTyrant
BitTyrant can achieve higher download speeds at lower "uploading costs" by utilizing
a few facts of the basic BitTorrent protocol. First, a selfish peer can skip the
altruistic optimisic unchoke behavior, since these unchokes have a lower chance
to result in a reward. Second, BitTyrants can dynamically adjust their active set sizes
to maximize expected uploads from other peers. Last but not least, BitTyrants can harvest
the "excessive" amount of altruism in the system provided by a small amount of peers 
with very high upload capacities []. More specifically, these high capacity peers have 
higher equal-split bandwidths than the rest of the peers. Since the other peers can only 
contribute with a lower bandwidth to the high capacity peers, the high cap peers
are forced to contribute more bandwidth than they received from others. Such
excessive altruism can then be utilized by selfish BitTyrants. BitTyrants could 
speculatively uploads to these high capacity peers as much as possible. 

To infer the upload capacity of a peer, BitTyrant uses the following method. First, it 
assumes that the download speed of a peer is approximately the same as its upload speed. 
Thus, they can use a peer's download speed as its estimated upload speed. Second,
the download speed of a peer can be inferred from its "announcement rate". In BitTorrent,
a peer will make an announcement to every other peer when it finished downloading a piece. 
Therefore, BitTyrants could estimate the download speed with annoucement rate * piece size.

The basic strategy of BitTyrant is as following. It tries to maintain a list of peers, sorted
by $d(p)/u(p)$,


## The Project


## Implementation


## Evaluation

### Setup

Emulab Ubuntu18 64 pc3000
7 Nodes. 1 node for 3 seeders (128KB) + 1 tracker
others 5 peers for each
bottleneck? fs, network?





