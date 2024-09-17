% Prompt the user to select an MP4 file
[filename, filepath] = uigetfile('*.File_format', 'Video_File_Name');

% Check if the user canceled the selection
if isequal(filename,0)
    disp('User canceled the operation.');
    return;
end

% Construct the full file path
fullFilePath = fullfile(filepath, filename);

% Create a VideoReader object to read the video
vidReader = VideoReader(fullFilePath);

% Create a VideoWriter object to write the cartoon video
outputVideoFile = 'Video_File_Name.File_format';
vidWriter = VideoWriter(outputVideoFile, 'MPEG-4');
open(vidWriter);

% Parameters for cartoon effect
edgeThreshold = 0.08; % Adjust edge detection threshold
numColors = 8; % Number of colors for color quantization

% Read and process each frame
while hasFrame(vidReader)
    frame = readFrame(vidReader);
    
    % Convert the frame to grayscale
    grayFrame = rgb2gray(frame);
    
    % Perform edge detection
    edgeFrame = edge(grayFrame, 'Canny', edgeThreshold);
    
    % Perform color quantization
    quantizedFrame = imquantize(frame, linspace(0, 1, numColors));
    
    % Combine edge and quantized frames to create cartoon effect
    % Set the values of the edge pixels to white in each color channel
    for c = 1:size(frame, 3)
        quantizedFrame(:,:,c) = quantizedFrame(:,:,c) .* (1 - edgeFrame) + 255 * edgeFrame;
    end
    
    % Write the frame to the output video
    writeVideo(vidWriter, uint8(quantizedFrame));
end

% Close the video writer
close(vidWriter);

% Release the video object
delete(vidReader);
