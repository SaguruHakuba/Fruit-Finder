BW = imread('test.tiff');
BW=BW(:,:,3);
BWorig = BW;

imshow(BW);
CC = bwconncomp(BW);
numPixels = cellfun(@numel,CC.PixelIdxList);
idx = find(numPixels<20);
[a,b] = size(idx);
for i = 1:b            
    BW(CC.PixelIdxList{idx(i)}) = 0;
end
figure;
CC = bwconncomp(BW);
imshowpair(BWorig,BW,'montage')