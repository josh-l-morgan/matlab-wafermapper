SPN = 'G:\joshm\MasterRaw\hxQ_waf014_IL_1\waf014_Sec001_Montage\';
imageName = 'Tile_r1-c1_waf014_sec001tmp.tif';


fileName = [SPN imageName];
exist(fileName,'file')
I = imread(fileName,'PixelRegion',{[1 10],[ 1 10]};