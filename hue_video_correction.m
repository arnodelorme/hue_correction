% input file
vidObj = VideoReader('original.mp4');

% output file
vidObjOut1 = VideoWriter('corrected.avi', 'Uncompressed AVI'); % this is very large, use Handrake to convert to mp4
vidObjOut2 = VideoWriter('corrected.mp4', 'MPEG-4'); % sometimes does not work
open(vidObjOut1);
open(vidObjOut2);

% range defining a background region
yRange = 1:300;
xRange = 1:500;

frame = 1;
vidObj.CurrentTime = 0;

% Read video frames until available
while hasFrame(vidObj)
    vidFrame = readFrame(vidObj);

    lum = mean(mean(vidFrame(yRange,xRange,:),1), 2);
    
    if 0
        % check that the range you are using 
        % always contain background
        figure;
        image(vidFrame(yRange,xRange,:));
        axis equal;
        return;
    end

    if frame == 1
        orilum = lum;
    end
    vidFrame = uint8(bsxfun(@plus,bsxfun(@minus, double(vidFrame), lum), orilum));
    writeVideo(vidObjOut1,vidFrame);
    writeVideo(vidObjOut2,vidFrame);

    frame = frame+1;
    if mod(frame, 30) == 0
        fprintf('.');
    end
end
close(vidObjOut1)
close(vidObjOut2)