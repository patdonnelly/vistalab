function mrtrix_itkclass_wmmask(classfile, fname)

% Convert the white matter segmentation file in itkGray (mrVista) into
% binary white matter mask in mrTrix.
% 
% In itkGray (mrVista), white matter is described as 3 and 4 in the matrix
% in nifti file. This code converts itkGray segmentation into binary white
% matter mask (white matter:1, others:0) in order to use it in fiber tractography. 
% 
% INPUT: 
% classfile: A full path to nifti file storing segmentation information in itkGray format
% fname: The name of the output file (does not require filename extension)
% 
% EXAMPLE:
% classfile = 't1_class.nii.gz';
% fname = 't1_class_binary';
% (C) Hiromasa Takemura, CiNet/Stanford VISTA Team, 2015

if notDefined('fname')
    fname = 't1_class_binary';
end

% Set savefile name
niftiname = [fname '.nii.gz'];
mifname = [fname '.mif'];

% Load file
class = niftiRead(classfile);

% Make new nifti structure and set file name
nii = class;
nii.fname = niftiname;

%% Make binary white matter mask. 
% In ITKGray format, white matter is described as 3 and 4. Here, we put
% 1 for all white matter voxels and 0 for all other voxels.

% Set zero for all voxels
nii.data = zeros(size(class.data));

% Set one for white matter voxels
nii.data(class.data == 3) = 1;
nii.data(class.data == 4) = 1;

% Save binary nifti file
niftiWrite(nii);

%% Convert nifti to .mif format
mrtrix_mrconvert(niftiname, mifname);

