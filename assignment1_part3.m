function [newImg, map] = assignment1_part3(inputFilename, referenceFilename)

img = imread(inputFilename);
refimg = imread(referenceFilename);
[m, n] = size(img); %Obtain width and height of image.
[rm, rn] = size(refimg);

ratio = (m*n)/(rm*rn);

hist = imhist(img); %Histogram of this image
histc = cumsum(hist); %Cumulative histogram

L = 256; %Number of gray levels

%Construct histogram of a perfectly equalized image
%Assuming L bins, each bin will contain (m*n)/L pixels
idealHist = imhist(refimg)*ratio; %resizes histogram to be the same size as other histogram
idealHistc = cumsum(idealHist); %Cumulative histogram

%Initialize the map that will store the transformation to all zeros. 
%In addition, specify the type 'uint8' to ensure that the transform doesn't go out of bounds [0, 255] (see part 1)
map =  zeros(L,1, 'uint8');%Enter code here...

for i=1:L
    %For each gray-level, find the **index** ind that minimizes the difference
    %between histc(i) (defined above) and the array idealHistc (defined
    %above). Again, avoid for loops! This can be done in couple of statements that
    % 1) finds the difference (stored in an array) and 2) finds the minimum
    histdiff = abs(idealHistc - histc(i));
    [~,ind] = min(histdiff);
    %Index ind is between 1 to 256; %Bring it back to range [0, 255]
    map(i) = ind - 1;%Enter code here...
end

%Histogram equalized image is simply applying the map to the image. (see part 1)
newImg = map(double(img)+1);%Enter code here...
newHist = imhist(newImg);

figure, subplot('Position',[0.02, 0, 0.3, 0.9])
imshow(img), axis image,  title('Original')
subplot('Position',[0.02+1/3, 0, 0.3, 0.9])
imshow(refimg), axis image,  title('Reference')
subplot('Position',[0.02+2/3, 0, 0.3, 0.9])
imshow(newImg), axis image,  title('Matched')
 
figure, subplot('Position',[0.05, 0.04, 0.9, 0.28])
plot(hist), legend('Original'); 
subplot('Position',[0.05, 0.04+1/3, 0.9, 0.28])
plot(idealHist), legend('Reference');  
subplot('Position',[0.05, 0.04+2/3, 0.9, 0.28])
plot(newHist), legend('Matched'); 

imgSize = n*m;
[matlabHistMatch, matlabMap] = imhistmatch(img, refimg);
fprintf('Diff between homegrown and matlab implementation (per pixel) = %f\n',sum(sum(abs(double(matlabHistMatch) - double(newImg))))/imgSize);

end

