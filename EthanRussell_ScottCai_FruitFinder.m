Paths = [
    "C:\Users\Ethan\Documents\School\CSSE463 Image Recognition\Projects\FruitFinder\fruit\fruit\mixed_fruit1.tiff",
    "C:\Users\Ethan\Documents\School\CSSE463 Image Recognition\Projects\FruitFinder\fruit\fruit\mixed_fruit2.tiff",
    "C:\Users\Ethan\Documents\School\CSSE463 Image Recognition\Projects\FruitFinder\fruit\fruit\mixed_fruit3.tiff",
    "C:\Users\Ethan\Documents\School\CSSE463 Image Recognition\Projects\FruitFinder\fruit\fruit\fruit_tray.tiff"
    ];
num_pics = size(Paths);

%Loop through each image
for path = 1:num_pics
    
    %Load the image
    Test = imread(char(Paths(path)));
    r = Test(:,:,1);
    g = Test(:,:,2);
    b = Test(:,:,3);

    hsvimg = rgb2hsv(Test);
    h = hsvimg(:, :, 1);
    s = hsvimg(:, :, 2);
    v = hsvimg(:, :, 3);

    rgbmask = zeros(size(hsvimg(:,:,:)));
    
    %apple threshold
    hsvmask = zeros(size(hsvimg(:,:,1)));
    hsvmask(find((h <= 0.06 | h >= 0.89) & (s >= 0.5)& (v >= 0.05))) = 1;    
    rgbmask(:,:,1) = hsvmask;
    
    %orange threshold
    hsvmask = zeros(size(hsvimg(:,:,1)));
    hsvmask(find((h <= 0.115 & h >= 0.06) & (s >= 0.4)& (v >= 0.25))) = 1;
    rgbmask(:,:,2) = hsvmask;

    %banana threshold
    hsvmask = zeros(size(hsvimg(:,:,1)));
    hsvmask(find((h <= 0.25 & h >= 0.125) & (s >= 0.5)& (v >= 0.25))) = 1;
    rgbmask(:,:,3) = hsvmask;
    
    %Loop through each of the masks
    for k=1:3
        
        %Remove every cluster of pixels smaller than 50
        BW = rgbmask(:,:,k);
        CC = bwconncomp(BW);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        idx = find(numPixels<50);
        [a,b] = size(idx);
        for i = 1:b            
            BW(CC.PixelIdxList{idx(i)}) = 0;
        end
        
        %Remove every cluster of pixels < 1/3 of the average
        CC = bwconncomp(BW);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        avg_size = mean(numPixels);
        idx = find(numPixels<avg_size/3);
        [a,b] = size(idx);
        for i = 1:b            
            BW(CC.PixelIdxList{idx(i)}) = 0;
        end
        rgbmask(:,:,k) = BW;
        
        %Close then open
        rgbmask(:,:,k)=imclose(rgbmask(:,:,k),strel('square',3));
        rgbmask(:,:,k)=imopen(rgbmask(:,:,k),strel('square',3));

        %Remove every cluster of pixels < 1/4 of the average
        BW = rgbmask(:,:,k);
        CC = bwconncomp(BW);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        avg_size = mean(numPixels);
        idx = find(numPixels<avg_size/4);
        [a,b] = size(idx);
        for i = 1:b            
            BW(CC.PixelIdxList{idx(i)}) = 0;
        end
        rgbmask(:,:,k) = BW;
    end

    figure(path);
    imshowpair(rgbmask,Test,'montage'); title('RGB Mask vs. Original Image');
    
    CCapples = bwconncomp(rgbmask(:,:,1));
    applecentroids = regionprops('table',CCapples,'Centroid','Area')   
    CCoranges = bwconncomp(rgbmask(:,:,2)); 
    orangecentroids = regionprops('table',CCoranges,'Centroid','Area')
    CCbananas = bwconncomp(rgbmask(:,:,3));
    bananacentroids = regionprops('table',CCbananas,'Centroid','Area')
end


