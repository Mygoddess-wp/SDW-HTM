function [processedFrames,numFrames] = avi2matrix(fileload,newHeight,newWidth)
videoFile = fileload;
videoObj = VideoReader(videoFile);
numFrames = round(videoObj.FrameRate * videoObj.Duration);
frameRate = videoObj.FrameRate;
if nargin == 3
    processedFrames = zeros(newHeight, newWidth, numFrames);
else
    processedFrames = zeros(videoObj.Height, videoObj.Width, numFrames);
end
for i = 1:numFrames
    frame = read(videoObj, i);
    grayFrame = rgb2gray(frame);
    if nargin == 3
        grayFrame = imresize(grayFrame, [newHeight, newWidth]);
    end
    processedFrames(:,:,i) = grayFrame;
end
[folder, name, ~] = fileparts(videoFile); 
matFilePath = fullfile(folder, [name, '.mat']);
% save(matFilePath, 'processedFrames', 'numFrames', '-v7.3');
end

