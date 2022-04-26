
msg = "Choose your reference frame gap";
opts = ["1" "11" "31"];
choice = menu(msg,opts)
vidReader = VideoReader('h3vid_shortend.avi');
opticFlow = opticalFlowHS;
%opticFlowii = opticalFlowHS;
%opticFlowiii = opticalFlowHS;
h = figure;
movegui(h);
hViewPanel = uipanel(h,'Position',[0 0 1 1],'Title','Plot of Optical Flow Vectors');
hPlot = axes(hViewPanel);

hold on
i = 1;
frameRGB = readFrame(vidReader);
frameGray = rgb2gray(frameRGB);
referenceFrame = frameGray;
if choice == 1
    gap = 1
elseif choice == 2
    gap = 11
else
    gap == 31
end
while hasFrame(vidReader)
    frameRGB = readFrame(vidReader);
    if mod(i,gap) == 0
        referenceFrame = frameGray;
    end
    
    frameGray = rgb2gray(frameRGB);
    imshow(frameRGB)
    hold on
    opticFlow.reset()
    flow = estimateFlow(opticFlow,referenceFrame);
    flow = estimateFlow(opticFlow,frameGray);
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',200,'Parent',hPlot);
    hold off
    pause(10^(-3))
    i=i+1;
end
