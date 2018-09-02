appleTest = imread('C:\Users\cais1\Desktop\CSSE463\Project 1\fruit\fruit\apples_day.tiff');
r = appleTest(:,:,1);
g = appleTest(:,:,2);
b = appleTest(:,:,3);
imtool(appleTest);

hsvapple = rgb2hsv(appleTest);
h = hsvapple(:, :, 1);
s = hsvapple(:, :, 2);
v = hsvapple(:, :, 3);
% 
% figure(1);imhist(h);title('hue');
% figure(2);imhist(s);title('saturation');
% figure(3);imhist(v);title('value');
% 
% figure(4);imhist(r);title('red');
% figure(5);imhist(g);title('green');
% figure(6);imhist(b);title('blue');

hsvmask = zeros(size(hsvapple(:,:,1)));
hsvmask(find((h<= 0.065 | h >= 0.9) & (s >= 0.4 & v >= 0.1))) = 1;
figure(7);
imshow(hsvmask);


