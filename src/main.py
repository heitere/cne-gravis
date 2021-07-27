#!/usr/bin/env python
# -*- coding: utf-8 -*-
# This file was originally developed for EvalNE by Alexandru Cristian Mara

import argparse
import numpy as np
import networkx as nx
from scipy import sparse

from cne import ConditionalNetworkEmbedding
from maxent import UniformBGDistr, DegreeBGDistr

# The lbfgs optimizer does not work with the latest versin of the CNE python code.
# Better stick to adam exclusively. The learning rate now has to be optimised (0.01 seems quite low)
# the algorithm need about 500 iter to converge.


def parse_args():
    """ Parses CNE arguments."""

    parser = argparse.ArgumentParser(description="Run CNE.")

    parser.add_argument("--inputgraph", nargs="?", default="sample/network.edgelist",
                        help="Input graph path")

    parser.add_argument("--output", nargs="?", default=None,
                        help="Path where the embeddings will be stored.")

    parser.add_argument("--tr_e", nargs="?", default=None,
                        help="Path of the input train edges. Default None (only returns embeddings)")

    parser.add_argument("--tr_pred", nargs="?", default="tr_pred_.csv",
                        help="Path where the train predictions will be stored.")

    parser.add_argument("--te_e", nargs="?", default=None,
                        help="Path of the input test edges.")

    parser.add_argument("--te_pred", nargs="?", default=None,
                        help="Path where the test predictions will be stored.")

    parser.add_argument("--dimension", type=int, default=16,
                        help="Embedding dimension. Default is 16.")

    parser.add_argument("--learning_rate", type=float, default=0.05,
                        help="Learning rate for grad_desc. Default is 0.05.")

    parser.add_argument("--epochs", type=int, default=500,
                        help="Training epochs. Default is 500.")

    parser.add_argument("--optimizer", default="adam",
                        help="Optimizer to be used. Options are `adam`, `lbfgs`, `grad_desc` Default is `adam`.")

    parser.add_argument("--neg_pos_ratio", type=int, default=5,
                        help="Ratio of negative samples to positive samples when sampling \
                        during embedding optimization.")

    parser.add_argument("--s1", type=float, default=1,
                        help="Sigma 1. Default is 1.")

    parser.add_argument("--s2", type=float, default=2,
                        help="Sigma 2. Default is 2.")

    parser.add_argument("--prior", default="uniform", choices=["uniform", "degree"],
                        help="The CNE prior to use.")

    parser.add_argument("--pred_prior", default=None, choices=["uniform", "degree"],
                        help="The prior to use for link prediction. If None same prior as \
                        for background distribution will be used.")

    parser.add_argument("--delimiter", default=",",
                        help="The delimiter used to separate the edgelist.")

    parser.add_argument("--seed", default=None, type=int,
                        help="Set a random seed. Initial node embeddings depend on the seed. Default None.")

    parser.add_argument("--ftol", default=1e-3, type=float,
                        help="Tolerance to stop the optimization process. Computed based on the gradient norm when subsampling.")

    return parser.parse_args()


def main(args):
    """
    Pipeline for unsupervised node embeddings
    preserving proximity and global ranking properties
    """
    if args.seed is not None:
        np.random.seed(args.seed)

    # Load edgelist
    E = np.loadtxt(args.inputgraph, delimiter=args.delimiter, dtype=int)

    # Create a graph
    G = nx.DiGraph()

    # We make sure the graph is unweighted
    G.add_edges_from(E[:, :2])

    # Get number of nodes and adj matrix of the graph
    G = G.to_undirected()
    tr_A = nx.adjacency_matrix(
        G.to_undirected(), nodelist=sorted(G.nodes()), weight=None
    )
    sparse_A = sparse.csr_matrix(tr_A)

    if args.prior == "uniform":
        bg_dist = UniformBGDistr(sparse_A)
    elif args.prior == "degree":
        bg_dist = DegreeBGDistr(sparse_A)
    else:
        raise ValueError("Prior {:s} is not implemented".format(args.prior))

    # Compute different prediction distribution if necessary
    if (args.pred_prior is None) or (args.pred_prior == args.prior):
        pred_dist = bg_dist
    elif args.pred_prior == "uniform":
        pred_dist = UniformBGDistr(sparse_A)
        pred_dist.fit()
    elif args.pred_prior == "degree":
        pred_dist = DegreeBGDistr(sparse_A)
        pred_dist.fit(verbose=False)
    else:
        raise ValueError(
            "Prediction prior {:s} is not implemented.".format(args.pred_prior)
        )

    bg_dist.fit(verbose=False)

    cne = ConditionalNetworkEmbedding(
        sparse_A,
        args.dimension,
        args.s1,
        args.s2,
        bg_dist,
        pred_dist
    )
    cne_embedding = cne.fit(
        lr=args.learning_rate,
        max_iter=args.epochs,
        ftol=args.ftol,
        subsample=True,
        neg_pos_ratio=5,
        verbose=False
    )

    # Read the train edges and run predictions
    if args.tr_e is not None:
        train_edges = np.loadtxt(
            args.tr_e, delimiter=args.delimiter, dtype=int)
        pred_tr = cne.predict(train_edges)
        np.savetxt(args.tr_pred, pred_tr, delimiter=args.delimiter)

        # Read the test edges and run predictions
        if args.te_e is not None:
            test_edges = np.loadtxt(
                args.te_e, delimiter=args.delimiter, dtype=int)
            pred_te = cne.predict(test_edges)
            np.savetxt(args.te_pred, pred_te, delimiter=args.delimiter)

    # Store the embedding in output file
    if args.output is not None:
        np.savetxt(args.output, cne_embedding, delimiter=args.delimiter)


if __name__ == "__main__":
    args = parse_args()
    main(args)
