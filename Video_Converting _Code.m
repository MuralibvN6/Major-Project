 % Prompt the user to select an MP4 file
[filename, filepath] = uigetfile('*.File_Format', 'Input_Video_File');

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
outputVideoFile = 'Output_File_Name.File_Format';
vidWriter = VideoWriter(outputVideoFile, 'MPEG-4');
open(vidWriter);

% Parameters for cartoon effect
edgeThreshold = 0.05; % Adjust edge detection threshold
numColors = 8; % Number of colors for color quantization

% Read and process each frame
% Read and process each frame
while hasFrame(vidReader)
    frame = readFrame(vidReader);
    
    % Convert the frame to grayscale
    grayFrame = rgb2gray(frame);
    
    % Perform edge detection
    edgeFrame = edge(grayFrame, 'Canny', edgeThreshold);
    
    % Perform color quantization
    quantizedFrame = imquantize(frame, linspace(0, 1, numColors));
    
    % Create a mask for edges
    edgeMask = repmat(edgeFrame, [1, 1, 3]); % Convert to 3 channels
    
    % Set edges to white in cartoonFrame
    cartoonFrame = quantizedFrame;
    cartoonFrame(edgeMask) = 255; % Set edges to white
    
    % Write the frame to the output video
    writeVideo(vidWriter, uint8(cartoonFrame));
end
% Close the video writer
close(vidWriter);

% Release the video object
delete(vidReader);
