% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This code is a main script for the image representations of 
% "single activation" and "average pooling".

%% SET PARAMETERS ONLY.
clc; close all; fclose all; clear all;
addpath( genpath( './' ) ); init;
setting.gpu                         = 1;                    % GPU ID you use. If you do not have any available gpu, set 0.
setting.db                          = path.db.scene67;      % DO NOT TOUCH) Target db informations.
setting.net                         = path.net.vgg_m;       % DO NOT TOUCH) Pre-trained network used for your feature extractor.
setting.neuralDesc.layerId          = 19;                   % DO NOT TOUCH) Target layer ID where activations are extracted.
setting.neuralDesc.augmentationType = 'SINGLE';             % Set 'SINGLE' for "single activation" and 'AP' for "average pooling".
setting.svm.kernel                  = 'NONE';               % DO NOT TOUCH) Additive kernel map before training SVMs.
setting.svm.norm                    = 'L2';                 % DO NOT TOUCH) Normalization type before training SVMs.
setting.svm.c                       = 10;                   % DO NOT TOUCH) SVM parameter.
setting.svm.epsilon                 = 1e-3;                 % DO NOT TOUCH) SVM parameter.
setting.svm.biasMultiplier          = 1;                    % DO NOT TOUCH) SVM parameter.
setting.svm.biasLearningRate        = 0.5;                  % DO NOT TOUCH) SVM parameter.
setting.svm.loss                    = 'HINGE';              % DO NOT TOUCH) SVM parameter.
setting.svm.solver                  = 'SDCA';               % DO NOT TOUCH) SVM parameter.
if setting.gpu, reset( gpuDevice( setting.gpu ) ); end;     
db = Db( setting.db, path.dstDir );
db.genDb;
net = load( setting.net.path );
net.name = setting.net.name;
neuralDesc = NeuralDscrbr( db, net, setting.neuralDesc );
neuralDesc.init( setting.gpu );
imDscrber = ImDscrber( db, { neuralDesc }, [  ] );
imDscrber.descDb;

%% APPLICATION 1) IMAGE CLASSIFICATION.
svm = Svm( db, imDscrber, setting.svm );
svm.trainSvm;
svm.evalSvm( path.email );

%% APPLICATION 2) IMAGE RETRIEVAL.
irdb = makeImageRetrievalDb( imDscrber );
iid = db.getTeiids;
iid = randsample( iid', 1 );
rank2iid = retriveIms( iid, irdb, imDscrber );