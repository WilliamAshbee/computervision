for x = 1:(size(images,2))/1920
    tempI = images(:,1920*(x-1)+1:1920*(x)+1,:);
    
    grayI = rgb2gray(tempI);
    graycup = rgb2gray(checker);
    
    smallGrayI = imresize(grayI,.5);
    smallgraycup = imresize(graycup,.5);
    imshow(smallGrayI)
    
    results = zeros(size(smallGrayI,1)-size(smallgraycup,1)-1,size(smallGrayI,2)-size(smallgraycup,2)-1);
    
    for j = 1:size(smallGrayI,1)-size(smallgraycup,1)
        for i = 1:size(smallGrayI,2)-size(smallgraycup,2)
            results(j,i) = dist(smallGrayI(j:j+size(smallgraycup,1)-1,i:i+size(smallgraycup,2)-1),smallgraycup);
            %break
        end
    end
    
    [aj,ai,res] = argmax(results);
    ai = ai + ceil(size(smallgraycup,2)/2)-1
    aj = aj + ceil(size(smallgraycup,1)/2)-1

    [xx,yy] = ginput(2)
    if ai < max(xx) & ai > min(xx) & aj < max(yy) & aj > min(yy)
        disp('successful')
        disp(x)
    end
    pause(5)
end


function d = dist(a,b)
    d = sum(sum((cast(a,"int32").*cast(b,"int32"))))/sqrt(sum(sum(cast(a,"int32").^2))*sum(sum(cast(b,"int32").^2)));
end
function [aj,ai,res] =  argmax(m)
    [rem,argjs] = max(m);
    [res,ai] = max(rem);
    aj = argjs(ai);
end
