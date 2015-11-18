% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr )
% This code is a main script for the image representations of "Fisher-pooling".

%% SET PARAMETERS ONLY.
clc; close all; fclose all; clear all; 
addpath( genpath( './' ) ); init;
setting.gpu                             = 1;                    % GPU ID you use. If you do not have any available gpu, set 0.
setting.db                              = path.db.scene67;      % DO NOT TOUCH) Target db informations.
setting.net                             = path.net.vgg_m;       % DO NOT TOUCH) Pre-trained network used for your feature extractor.
setting.neuralRegnDesc.layerId          = 19;                   % DO NOT TOUCH) Target layer ID where activations are extracted.
setting.neuralRegnDesc.numScale         = 6;                    % DO NOT TOUCH) Number of scales for extracting multi-scale dense activations.
setting.neuralRegnDesc.pcaDim           = 128;                  % DO NOT TOUCH) Target dimention of an activation after dimensionality reduction by PCA.
setting.neuralRegnDesc.normBeforePca    = 'L2';                 % DO NOT TOUCH) Normalization type before PCA.
setting.neuralRegnDesc.normAfterPca     = 'L2';                 % DO NOT TOUCH) Normalization type after PCA.
setting.neuralRegnDic.numGaussian       = 256;                  % DO NOT TOUCH) Number of Gaussians for GMM dictionary.
setting.fisher.spatialPyramid           = '1131';               % DO NOT TOUCH) Spatial pyramid layout. '1131' denotes '1 by 1' and '3 by 1'.
setting.svm.kernel                      = 'NONE';               % DO NOT TOUCH) Additive kernel map before training SVMs.
setting.svm.norm                        = 'L2';                 % DO NOT TOUCH) Normalization type before training SVMs.
setting.svm.c                           = 10;                   % DO NOT TOUCH) SVM parameter.
setting.svm.epsilon                     = 1e-3;                 % DO NOT TOUCH) SVM parameter.
setting.svm.biasMultiplier              = 1;                    % DO NOT TOUCH) SVM parameter.
setting.svm.biasLearningRate            = 0.5;                  % DO NOT TOUCH) SVM parameter.
setting.svm.loss                        = 'HINGE';              % DO NOT TOUCH) SVM parameter.
setting.svm.solver                      = 'SDCA';               % DO NOT TOUCH) SVM parameter.
if setting.gpu, reset( gpuDevice( setting.gpu ) ); end;
db = Db( setting.db, path.dstDir );
db.genDb;
net = load( setting.net.path );
net.name = setting.net.name;
neuralRegnDscrber = ...
    NeuralRegnDscrber( db, net, ...
    setting.neuralRegnDesc, ...
    setting.neuralRegnDic );
neuralRegnDscrber.init( setting.gpu );
neuralRegnDscrber.trainDic;
% neuralRegnDscrber.descDb;                                     % Uncommant this line if you want to store multi-scale dense activations in your disk.
fisher = Fisher( neuralRegnDscrber, setting.fisher );
imDscrber = ImDscrber( db, { fisher }, [  ] );
imDscrber.descDb;

%% APPLICATION 1) IMAGE CLASSIFICATION.
svm = Svm( db, imDscrber, setting.svm );
svm.trainSvm;
svm.evalSvm( path.email );

%% APPLICATION 2) WEAKLY-SUPERVISED PER-CLASS CONFIDENCE MAP.
iid = db.getTeiids;
iid = randsample( iid', 1 );
map = genConfMap( iid, svm );

%% APPLICATION 3) IMAGE RETRIEVAL.
irdb = makeImageRetrievalDb( imDscrber );
iid = db.getTeiids;
iid = randsample( iid', 1 );
rank2iid = retriveIms( iid, irdb, imDscrber );