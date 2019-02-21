# README #

### Source code for ICLR2019 paper: Conditional Network Embeddings ###

### Set up ###

* Environment: Matlab 2016b+, Python 2.7/3.6

* Configuration:
	* Compile lbfgsb optimization tool under folder 'methods/lbfgsb'. Please follow the instructions in README.md under the same folder.
	* Download and compile the following baseline methods in 'methods' folder, under the subfolders same as method names.
        * Deepwalk: https://github.com/phanein/deepwalk
        * LINE: https://github.com/tangjianpku/LINE
        * node2vec: https://github.com/aditya-grover/node2vec
        * metapath2vec: https://ericdongyx.github.io/metapath2vec/m2v.html    
    * Configure file 'methods/init.m' to indicate the local python path.

### Datasets ###
* Facebook: https://snap.stanford.edu/data/egonets-Facebook.html
* PPI: http://snap.stanford.edu/node2vec/Homo_sapiens.mat
* arXiv ASTRO-PH: http://snap.stanford.edu/data/ca-AstroPh.html
* BlogCatalog: http://socialcomputing.asu.edu/datasets/BlogCatalog3
* Wikipedia: http://snap.stanford.edu/node2vec/POS.mat
* studentdb: http://adrem.ua.ac.be/smurfig
* Gowalla: http://snap.stanford.edu/data/loc-Gowalla.html

### Run ###

* __link prediction experiment__: run script 'split_train_test.py' under folder 'link_prediction/train_test' to generate Train/Test splits. Run script 'run_batch.m' under folder 'link_prediction'.
* __multilabel classification with link prediction__: run script 'run_batch.m' under folder 'multilabel_lp'
* __multilabel classification with logistic regression__: run script 'run_batch.m' under folder 'multilabel_lr'
* __multi-relational data visualization__: run script 'run.m' under folder 'visualization_multi_relation' to have an interactive visualization, run script 'plotFigures.m' to reproduce the figures.
* __Intuition about the objective function__: run script 'objIntuition.m' under folder 'objective_intuition'.
* __run time__: the runtime can be measured by putting 'tic' and 'toc' commands in script 'link_prediction/run_batch.m' for each method and setting.

### Results ###
* After the executions are finished, all results can be found in the same folder as the run scripts.
