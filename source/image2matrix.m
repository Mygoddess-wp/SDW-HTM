function compressed_image = image2matrix(fileload,inputHeight,inputWidth)
image_path = fileload;
rgb_image = imread(image_path);
gray_image = rgb2gray(rgb_image);
newWidth = inputWidth; % joints
newHeight = inputHeight; % xyz
compressed_image = imresize(gray_image, [newHeight, newWidth]);
end

