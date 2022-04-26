clear
msg = "Choose your reference frame gap";
opts = ["1" "11" "31"];
choice = menu(msg,opts)
vidReader = VideoReader('h3vid_shortend.avi');
frames = vidReader.NumberOfFrames;
vid = read(vidReader);

opticFlow = opticalFlowHS;
%opticFlowii = opticalFlowHS;
%opticFlowiii = opticalFlowHS;
h = figure;
movegui(h);
hViewPanel = uipanel(h,'Position',[0 0 1 1],'Title','Plot of Optical Flow Vectors');
hPlot = axes(hViewPanel);

hold on
if choice == 1
    gap = 1
elseif choice == 2
    gap = 11
else
    gap = 31
end

for x = 1: floor(frames/gap)
    frameRGB = vid(:, :, :, x*gap);
    %referenceFrame = frameGray %no longer necessary since i'm skipping frames
    frameGray = rgb2gray(frameRGB);
    imshow(frameRGB)
    hold on
    %opticFlow.reset() i used this when i wasn't skipping frames
    %flow = estimateFlow(opticFlow,referenceFrame);now i'm just skipping
    %the gap 
    flow = estimateFlow(opticFlow,frameGray);
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',200,'Parent',hPlot);
    hold off
    pause(gap/15)
end
