% Convert the image to grayscale
inputImage = imread('Image_Name.Image_Format');

% Convert the image to grayscale
grayImage = rgb2gray(inputImage);

% Apply bilateral filtering to smooth the image while preserving edges
smoothedImage = imbilatfilt(grayImage);

% Perform edge detection using the Canny edge detector
edgesImage = edge(smoothedImage, ‘'Canny',0.20);

se = strel('square', 2);
dilatedImage = imdilate(edgesImage, se);

% Combine the edges with the smoothed image to create a cartoon effect
cartoonFrame = inputImage;
cartoonFrame(repmat(edgesImage, [1, 1, size(inputImage, 3)])) = 220;
OutputImage = imfuse(smoothedImage, edgesImage, 'blend');

% This line indicates the 4 parameters which we would measure for the 
images
[psnr, mse, maxerr, L2rat] = measerr(inputImage, cartoonFrame)
Display the original and cartoon images side by side

figure;
imshow(inputImage);
title('Original Image');
figure;
imshow(grayImage);
title('Gray Image');
figure;
imshow(smoothedImage);
title('smoothed Image');
figure;
imshow(edgesImage);
title('Edged Image');
figure;
imshow(dilatedImage);
title('dialte Image');
figure;
imshow(cartoonFrame);
title('Cartoon Image');