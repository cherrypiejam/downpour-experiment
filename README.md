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
to them and upload pieces to the top $k$ peers who contribute the most to them.
In addition, they will split their upload bandwidth into $k$ "fractions" and allocate
each fraction to one of the top k peers. This bandwidth is called the
"equal-split bandwidth", and the set of the top k peers is called the "active set".
The action of not sending to peers who didn't contribute enough is called "choking",
and the action of sending to the peers who reciprocated is called "unchoking".
To prevent low capacity peers from being starved, the Bittorrent protocol also
let peers to "optimistically unchoke" random selected peers periodically. If a peer A
is optimiscially unchoked by a peer B, B will uploads at the equal-split rate to
A for a period of time no matter how much A has contributed to B.

Although BitTorrent has had a great success in the real world deployment, which
seems to be a proof of how robust the incentive mechanism is [[1]](#1), it is actually
amenable to strategic peers. The BitTyrant paper [[2]](#2) represented an approach that
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
with very high upload capacities [[2]](#2). More specifically, these high capacity peers have
higher equal-split bandwidths than the rest of the peers. Since the other peers can only
contribute with a lower bandwidth to the high capacity peers, the high cap peers
are forced to contribute more bandwidth than they received from others. Such
excessive altruism can then be utilized by selfish BitTyrants. BitTyrants could
speculatively uploads to these high capacity peers as much as possible.

To infer the upload capacity of a peer, BitTyrant uses the following method. First, it
assumes that $u_p \approx d_p$, where $u_p$ is the upload speed of $p$ and $d_p$ the download
speed. Thus, they can use a peer's download speed as its estimated upload speed. Second,
the download speed of a peer can be inferred from its "announcement rate" $r_p$. In BitTorrent,
a peer will make an announcement to every other peer when it finished downloading a piece.
Therefore, BitTyrants could estimate the upload speed as $u_p \approx d_p \approx r_p \cdot S$,
where $S$ is the size of a piece.

The basic strategy of a BitTyrant is as following. It tries to maintain a list of peers, sorted
by $\frac{d(p)}{u(p)}$, where $d(p)$ is the expected received download speed from $p$, and
$u(p)$ is the expected upload speed the BitTyrant peer must contribute in order to receive
the $d(p)$ reward from $p$. Both values are estimated at an initial value, but once a BitTyrant
has received downloads from a peer $q$, it can update $d(q)$ with the real download speed
instead of the estimated one. If the Tyrant peer did not receive uploads from peer $p$, it will
gradually increase $u(p)$ since it needs to contribute more uploads to get the reward from $p$;
otherwise, if it keeps receiving from a peer $p$, it will gradually decrease $u(p)$, since it
may be able to receive $d(p)$ from $p$ even at a lower $u(p)$.


## The Project
In this project, we tried to reproduce the results from the original paper [[2]](#2). We implemented the
basic BitTyrant cheating strategy as specified in the previous section with a recent BitTorrent
implementation in Go. We intend to reproduce the main results from the original paper that:
1. A single peer can improve its download speed given the same upload capacity by using BitTyrant;
2. The overall download speeds of all peers in the system can be improved if they all use BitTyrant.

In addition to the basic BitTyrant strategy, we also implemented two additional cheating strategies
indicated in the paper. First, we implemented BitRebel, a strategic peer intended to counter BitTyrants.
BitRebel can utilize one of BitTyrant's weakness, that is, BitTyrants infer the upload capacity of
a peer through its annoucement rate. Therefore, BitRebels can make fast fake annoucements to trick
BitTyrants into donate their capacities to BitRebels. As a result, the download speed of BitRebels
is expected to be high as more BitTyrant peers exist, and the BitTyrant peers' download speeds will
be low if BitRebels exist.

Last but not least, we implemented BitSybil, where a BitTorrent peer launches a Sybil attack by
join the system as $N$ sybil identities and split its upload capacity evenly among the Sybils.
This strategy could be beneficial since the BitSybil peer has a higher chance to receive optimistic
unchokes, which are essentially "free lunches".

## Implementation

The paper implemented their BitTyrant client atop Vuze, a Java-based implementation
of BitTorrent. Instead, We select [rain](https://github.com/cenkalti/rain), a BitTorrent
client written in Go as the base to reimplement BitTyrant on top of it.

We added approximately 500 LOC in Go and 80 LOC in Haskell to rollback to vanilla version
and implement BitTyrant, BitRebel, and Sybil Attack. The actual lines added are a lot higher
than this (roughly over 3000 LOC), but mostly they are code ported from a library that
requires minor changes for our use and duplicated code to workaround with changes that
break the program.

#### Rollback (Vanilla)

We choose rain as our base BitTorrent implementation for two reasons. Firstly rain is serious
enough as a BitTorrent client since it is running in production at [put.io](https://put.io/).
Furthermore, rain is written in a modern language so we would like to see how a BitTorrent
is implemented today.
Unfortunately, modern BitTorrent clients often come with many optimizations. We thus
did a few rollbacks in rain:

1. Peer connections are accepted on per IP basis because presumably a single-user
   machine only needs to download a file once. We switch it to per IP + port basis
   which allows us to run over hundreds of clients on a few physical nodes.
2. [Fast extension](http://bittorrent.org/beps/bep_0006.html) are enabled by default in rain.
   However, at the time when the paper was published, fast extension has not yet been
   created which makes it impossible to be implemented in Vuze. Therefore, we disable
   this feature to better simulate the original experiment.
3. Rarest first policy is implemented for piece selection in rain, which follows the
   original BitTorrent implementation. However, when multiples share the same level
   of rarity, rain tends to select the one with the lowest index number. However,
   this is bad for our experiments. In a fresh swarm, whoever starts to download first
   has the advantage to have rare pieces which makes the system to have a slow start.
   Instead, we implement a random tie breaker to select a piece among pieces that
   have the same level of rarity.

#### Tyrant

We implemented BitTyrant unchoke algorithm [figure]
One challenge bucket, ported

#### Rebel


#### Sybil

Originally we plan to mount Sybil attack in rain by spawning many event loops, that
each is responsible for a portion of the target file and thus behaves like a small
torrent client in a swarm. While implementing this approach, we found it is difficult
to avoid race conditions between event loops, and the fact that rain has a intersected
structure of channels to pass messages makes it more complex. Alternatively, we switch
to another approach to move the multiple identities part out of the program logic,
by adding a wrapper program that spawns many system processes and combine the outputs
into one file. Intuitively, this approach is more practical in real life, because it
uses system processes instead of threads that requires shared memory, meaning that
it can be easily scaled to several collaborative remote machines with different IP
addresses. Also, it is often true that real-world BitTorrent implementation assumes
one client per IP to avoid redundant sharing, such as rain.

We modify rain to only be responsible for a small portion of the target file on a
number of pieces granularity. For the wrapper program, we wrote it in Haskell for
its lazy IO. Unfortunately, we have to force the wrapper to drain its lazy IO in the
end to avoid crashing the itself at some point. Although Haskell may not be suitable
for implementing a wrapper program, it definitely a good practice for mounting
a Sybil attack in a scenario where peers allow multiple connections from the same IP.
Haskell's green thread library make it possible to spawn thousands of threads for a
single file and have multiple threads race for a small portion of that file. A side
story is that initially we tried to build it atop a Haskell implementation of BitTyrant
but failed due to some dependency issue.

## Evaluation

The goal of our evaluation is to reproduce the performance comparison between a single
BitTyrant client and a vanilla BitTorrent client under a same setting.

1. sweet spot of estimated reciprocation
2. the present of very high cap matters
3. peer max connection & tracker matter (discoverability)


1. Distribution Approximation
2. File size, #Peers, #Seeders, etc.
3. Single Tyrant exp, with:
    a) k = 1
    b) k = 0.44
    c) Constant active setsize
4. All Tyrant exp
5. BitRebel vs. BitTyrant
6. BitSybil vs. BitTorrent

### Setup

Our evaluation runs on 7 Emulab pc3000 nodes. Three seeders with a combined upload
capacity of 128KB/s and a tracker are hosted on a single node. We evaluate our
implementation under multiple swarm settings.

%% Thirty peers are distributed into the other 6 nodes, 5 peers per node.
%% Three hundreds peers are equally distributed into other 6 nodes, which is 50 peers per node.
%% By scaling down the download file size and the overall peer capacities,
%% we can prevent the potential bottlenecks from the disk and network.


#### A Highly Skewed Bandwidth Distribution

The paper reports that the raw bandwidth capacity for peers is a highly skewed distribution
based on their measurements of real-world swarms. The curve is a logarithmic curve itself,
but it is difficult to find such a logarithmic formula that fits the distribution. Alternatively,
we use Four Parameter Logistic (4PL) and our eyes to approximate the actual distribution.

```python
def truly_magic(x):
    return np.log(7.991586+(-4.094174-20.891589)/(1+(x/14.42096)**2.158334))
```

Setting a proper x and y axis, we get a similar distribution as in the paper.

For experiments, we wrote a script to use the function above to generate a swarm that peer
capacities follow the similar distribution as stated in the paper.

### Performance of a Single BitTyrant

#### 30 Clients, k=1, Real Distribution

#### 30 Clients, k=1, Normal Distribution

#### 300 Clients, k=3/sqrt(mean(d)), Real Distribution

#### 300 Clients, k=1, Real Distribution

#### 60 Clients, k=3/sqrt(mean(d)), Real Distribution

#### 60 Clients, k=1, Real Distribution


### Performance of a BitTyrant Swarm

### BitRebel

### Sybil Attack

=======
## References
<a id="1">[1]</a>
Cohen, Bram. "Incentives build robustness in BitTorrent." Workshop on Economics of Peer-to-Peer systems. Vol. 6. 2003.

<a id="2">[2]</a>
Piatek, Michael, et al. "Do incentives build robustness in BitTorrent." Proc. of NSDI. Vol. 7. 2007.

