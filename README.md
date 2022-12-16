%% # downpour Experiment
%% This repo contains scripts used for downpour experiments running on cloudlab

# Reimplementation of BitTyrant: Do Incentives Build Robustness in BitTorrent?

Gongqi Huang and Jingyuan Chen, COS 518, 2022

## Introduction

In many peer-to-peer systems, the fundamental issue is that peers tend to take
the benefits without contributing to the system. In BitTorrent file sharing
system, tit-for-tat is used to explicitly address the issue by providing enough
incentives for peers to also contribute to the system while benefiting from it.
More specifically, in BitTorrent, peers attempt to maximize their downloading
speed by downloading from any peer who sends pieces to them and upload pieces
to the top k peers who contribute the most to them. Choking algorithms 'choke'
someone in a way that not providing any piece for them to download in a period
of time. Deciding which to upload or not is essentially a tit-for-tat method,
providing an incentive that if I, as a peer, want to take the benefits of the
system, I must contribute to the system in return.

Although BitTorrent has had a great success in the real world deployment which
seems to be a proof of how robust the incentives provided by BitTorrent are, the
tit-for-tat method used by it isn't robust to strategic peers. The paper represents
an approach that utilizes the existence of altruism in BitTorrent to build a
strategic BitTorrent client, called BitTyrant, which carefully selects peers and
contribution rates to break the robustness provided by BitTorrent.

### BitTyrant


## The Project


## Implementation

#### Rollback (Vanilla)

The paper implemented their BitTyrant client atop Vuze, a Java-based implementation
of BitTorrent. We, instead, select [rain](https://github.com/cenkalti/rain), a BitTorrent
client written in Go as the base to reimplement BitTyrant for the following reasons:

1. rain is running in production at [put.io](https://put.io/)
2. rain is written in a modern language

Unfortunately, modern BitTorrent clients often come with many optimizations. We thus
did a few rollbacks in rain:

1. Peer connections are accepted on per IP basis because presumably a single-user
   machine only needs to download a file once. We switch it to per IP + port basis
   which allows us to run over hundreds of clients on a few number of physical nodes.
2. [Fast extension](http://bittorrent.org/beps/bep_0006.html) are enabled by default in rain.
   However, at the time when the paper published, fast extension has not yet been
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

Originally we plan to mount Sybil attack in rain by spawning

## Evaluation

### Setup

Emulab Ubuntu18 64 pc3000
7 Nodes. 1 node for 3 seeders (128KB) + 1 tracker
others 6, 50 peers per each
bottleneck? fs, network?

comparing performance of a single BitTyrant client and a BitTorrant
client





