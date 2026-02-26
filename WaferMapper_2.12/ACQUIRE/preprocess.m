in_dir='D:\neuron segmentation in calcium imaging\Codes\STNeuroNet-master\Dataset\395';
out_dir='D:\neuron segmentation in calcium imaging\Codes\STNeuroNet-master\Dataset\preprocessed_395';
f = dir(fullfile(in_dir, '*.tif'));
for i=1:length(f)
    h=imread(fullfile(in_dir,f(i).name));
    h=h(12:499,12:499);
    imwrite(h,fullfile(out_dir,f(i).name),'tif');
end
