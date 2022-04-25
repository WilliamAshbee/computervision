obj = VideoReader('h3vid.avi');
vid = read(obj);
  
 % read the total number of frames
frames = obj.NumberOfFrames;
  
% file format of the frames to be saved in
ST ='.jpg';
  
% reading and writing the frames 
images = []

for x = 1 : frames
  
    % converting integer to string
    Sx = num2str(x);
  
    % concatenating 2 strings
    Strc = strcat(Sx, ST);
    Vid = vid(:, :, :, x);
    %cd frames

    if mod(x,30)==0
        disp(size(Vid))
        images = [images Vid];
    end
  
    % exporting the frames
    imshow(Vid);
    %cd ..  
end
