% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This script is for setting your environment.
global path;
% Please set YOUR!!! email address.
path.email              = 'dgyoo@rcv.kaist.ac.kr';
% Set lib path only.
path.lib.matConvNet     = '/iron/lib/matconvnet_v1.0_beta16';
path.lib.vlfeat         = '/iron/lib/vlfeat/vlfeat-0.9.19/';
% Set a directory path to save processed data.
path.dstDir             = '/nickel/data_pa3/';
% Set image DB path only.
path.db.scene67.name    = 'SCENE67';
path.db.scene67.funh    = @DB_SCENE67;
path.db.scene67.root    = '/iron/db/SCENE67';
% Set pre-trained CNN path only.
path.net.vgg_m.name     = 'VGGM';
path.net.vgg_m.path     = '/iron/net/imagenet-vgg-m.mat';
% DO NOT TOUCH the following.
run( fullfile( path.lib.vlfeat, 'toolbox/vl_setup.m' ) );       % VLFeat.
run( fullfile( path.lib.matConvNet, 'matlab/vl_setupnn.m' ) );  % MatConvnet.