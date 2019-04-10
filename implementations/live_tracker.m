try
    stop(vidObj);
    delete(vidObj);
catch
    clear all;
end;
    
params = struct;
params.sigma = 2;           % gaussian sigma
params.peak = 100;          % gaussian peak
params.s2tr = 5;          % search to target region ration
params.alpha = 0.1;       % learning rate
params.psr = 0.30;

vidObj = videoinput('linuxvideo', 1, 'YUY2_640x360');
vidObj.ReturnedColorspace = 'rgb';
vidObj.Timeout = 500;
triggerconfig(vidObj, 'manual');

start(vidObj)

global init;
init = true;

frame = 1;
while true
    I = getsnapshot(vidObj);
    
    if init
        figure(1); clf;
        subplot(4, 4, 1:12);
        imagesc(I);
        uicontrol('String', 'Init', 'Callback', @initialize);
        drawnow;
        frame = 1;
        init = false;
        bbox = getrect;
        tic;
        tracker = mosse_initialize(I, bbox, params); 
    else
       [tracker, bbox] = mosse_update(tracker, I, params); 
    end
    
    subplot(4, 4, 1:12);
    hold on;
    if mod(frame, 20) == 0
       cla;
    end
    imagesc(I);
    color = 'y';
    if tracker.m(end) < params.peak*params.psr;
        color = 'r';
    end
    rectangle('Position',bbox, 'LineWidth',2, 'EdgeColor',color);
    text(12, 15, sprintf('Frame: #%d\nFPS: %d', frame, round(frame/toc)), 'Color','w', ...
        'FontSize',10, 'FontWeight','normal', ...
        'BackgroundColor','k', 'Margin',1);   
    hold off;
        
    subplot(4, 4, 13:16);
    hold on;
    if mod(frame, 20) == 0
       cla;
    end
    plot(1:frame, tracker.m, 'b'); ylim([0 params.peak]);
    plot([1 frame], [params.peak*params.psr params.peak*params.psr], 'r'); ylim([0 params.peak]);
    hold off;
    drawnow;
    
    frame = frame + 1;
end

stop(vidObj);
delete(vidObj);

function initialize(src, evt)
    global init;
    init = true;
end