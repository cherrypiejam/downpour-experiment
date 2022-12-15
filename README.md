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


## Evaluation

### Setup

Emulab Ubuntu18 64 pc3000
7 Nodes. 1 node for 3 seeders (128KB) + 1 tracker
others 5 peers for each
bottleneck? fs, network?





