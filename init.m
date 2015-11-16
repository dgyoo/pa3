% Set lib path only.
global path;
path.lib.matConvNet     = '/iron/lib/matconvnet_v1.0_beta12_cuda6.5_cudnn/';
path.lib.vlfeat         = '/iron/lib/vlfeat/vlfeat-0.9.19/';
% Set dst dir.
path.dstDir             = '/nickel/data_attnet_clsagn/';
% Set image DB path only.
path.db.voc2007.name    = 'VOC2007';
path.db.voc2007.funh    = @DB_VOC2007;
path.db.voc2007.root    = '/iron/db/VOC2007';
% Set pre-trained CNN path only.
path.net.vgg_m.name     = 'VGGM';
path.net.vgg_m.path     = '/iron/net/imagenet-vgg-m.mat';
% Do not touch the following codes.
run( fullfile( path.lib.vlfeat, 'toolbox/vl_setup.m' ) );       % VLFeat.
run( fullfile( path.lib.matConvNet, 'matlab/vl_setupnn.m' ) );  % MatConvnet.