%% Load image
%Example image filenames below are among the images shown in textbook (Alasdair McAndrew).
%http://numbersandshapes.net/book-computational-introduction-to-image-processing/

%Download these from the website/Moodle by clicking on original_images.zip and store them onto /Users/Shared of your Mac. 

%You can then use the full path to these images 
%or add them to the path using Set Path option from the main Matlab window

% filename = 'engineer.png';
% filename = 'cameraman.png'; 
filename = 'bergen.jpg';

L = 256; %Number of gray-levels we will be dealing with

%Read the image and store into variable img
img = imread(filename);
%


%% Home-grown histogram: Create a histogram without using Matlab's toolbox
%Initialize a vector of size L (because there are L gray-values) to all zeros. This will store the histogram.
mat = zeros(L, 1);

%Loop over the pixels in image. 
%Note: size(img) returns width and height of the image
[width, height] = size(img);

%...Enter code here 
%loop index i iterates over rows
for i = 1:width
   %loop index j iterates over columns
   for j = 1:height
          gray = double(img(i,j)); %value between 0 and 255
          
          %Now, increment mat for the grayvalue "gray" 
          mat(gray+1) = mat(gray+1)+1;
          %While incrementing, keep in mind that index of matrices in
          %Matlab starts from 1 but gray value can be 0. Secondly, if img is
          %of type uint8, then it can't store values above 255.
          ...
    %end loop columns
    end
%end loop rows
end

%
hist = imhist(img); %Matlab's implementation of histogram
%Compare with matlab's implementation..they should be exactly same. 
%Check for all different filenames in section above
fprintf('Diff hist = %d\n',sum(sum(abs(double(hist) - double(mat))))); %Should return 0

%If not same, why? Debug by storing the difference (hist-mat) in a
%variable and checking where they are different


%% Home-grown cumulative histogram: Create a cumulative histogram without using Matlab's toolbox
matc = zeros(L, 1); %Initialize a vector of size L (because there are L gray-values). This will store the cumulative histogram.

%Recall, Histogram is stored in vector mat. 
%Use the formula of cumulative histogram to update matc. c_{i+1} = c_{i} + n_i
matc(1)=mat(1);
%...Enter code here 
for i = 2:L
    matc(i) = matc(i-1) + mat(i);
end


histc = cumsum(hist); %Compare with matlab's implementation.. are they exactly same? They should be...
fprintf('Diff cumulative hist = %d\n',sum(sum(abs(double(histc) - double(matc)))));


%% Home-grown histogram equalization: Perform histogram equalization without using Matlab's toolbox
map = zeros(L,1,'uint8'); %This will store the transformation. Specifying the type uint8 ensures that the transform doesn't go out of bounds [0, 255]

%n = Total number of pixels
n = size(img,1)*size(img,2);

%Apply formula matc(i)*(L-1)/n to populate the values in map.
% ...Enter code here
map = uint8(matc * (L-1) / n);
    
%Apply the map to the image. Section 4.4 of the textbook shows a compact syntax for doing this: map(img)
%But what should be really  provided as the parameter? Recall that img is of type uint8. And Matlab's indexing begins from 1 (not 0)
matEq = map(img+1);
figure, imshow(matEq), impixelinfo;

%Compare with matlab's implementation.
[imEq, mapEq] = histeq(img);  %Need to update this since the default implementation of histeq outputs 64 discrete graylevels (from Matlab help). Our home-grown version uses 256. 
figure, imshow(imEq), impixelinfo;

%Because Matlab uses a slightly different algorithm, the difference per
%pixel (see below) will not be zero but a very small value 
fprintf('Diff between homegrown and matlab implementation (per pixel) = %f\n',sum(sum(abs(double(imEq) - double(matEq))))/n);