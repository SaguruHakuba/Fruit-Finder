% Test = imread('C:\Users\cais1\Desktop\CSSE463\Project 1\fruit\fruit\apples_day.tiff');
% Test = imread('C:\Users\cais1\Desktop\CSSE463\Project 1\fruit\fruit\oranges_day.tiff');
% Test = imread('C:\Users\cais1\Desktop\CSSE463\Project 1\fruit\fruit\bananas_day.tiff');
Test = imread('C:\Users\cais1\Desktop\CSSE463\Project 1\fruit\fruit\mixed_fruit3.tiff');
r = Test(:,:,1);
g = Test(:,:,2);
b = Test(:,:,3);
imtool(Test);

hsvimg = rgb2hsv(Test);
h = hsvimg(:, :, 1);
s = hsvimg(:, :, 2);
v = hsvimg(:, :, 3);


% figure(1);imhist(h);title('hue');
% figure(2);imhist(s);title('saturation');
% figure(3);imhist(v);title('value');
% 
% figure(4);imhist(r);title('red');
% figure(5);imhist(g);title('green');
% figure(6);imhist(b);title('blue');
rgbmask = zeros(size(hsvimg(:,:,:)));
%apple
hsvmask = zeros(size(hsvimg(:,:,1)));
hsvmask(find((h <= 0.05 | h >= 0.9) & (s >= 0.4)& (v >= 0.05))) = 1;
rgbmask(:,:,1) = hsvmask;
%orange
hsvmask = zeros(size(hsvimg(:,:,1)));
hsvmask(find((h <= 0.12 & h >= 0.05) & (s >= 0.4)& (v >= 0.2))) = 1;
rgbmask(:,:,2) = hsvmask;

%banana
hsvmask = zeros(size(hsvimg(:,:,1)));
hsvmask(find((h <= 0.25 & h >= 0.12) & (s >= 0.5)& (v >= 0.3))) = 1;
rgbmask(:,:,3) = hsvmask;

% hsvmask = medfilt2(hsvmask);
if(1)
    for k=1:3
        for i=1:1
            rgbmask(:,:,k) = imerode(rgbmask(:,:,k), strel('square',3));
            rgbmask(:,:,k) = imerode(rgbmask(:,:,k), strel([0 1 0;1 1 1;0 1 0]));
        end
        for i=1:3
            rgbmask(:,:,k) = imdilate(rgbmask(:,:,k), strel('square',2));
            rgbmask(:,:,k) = imdilate(rgbmask(:,:,k), strel([0 1 0;1 1 1;0 1 0]));
        end
        % for i=1:3
        %     hsvmask = imdilate(hsvmask, strel('square',3));
        % end
        % for i=1:3
        %     hsvmask = imerode(hsvmask, strel('square',3));
        % end
    end
end


figure(700);
imshow(rgbmask);


