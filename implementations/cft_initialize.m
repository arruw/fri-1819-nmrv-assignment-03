function [state, location] = cft_initialize(I, region, varargin)

    % get search bounding box
    bbox_s = get_search_bbox(region);
    
    % get target bounding box
    bbox_t = [bbox_s(1)-bbox_s(3) bbox_s(2)-bbox_s(4) bbox_s(3)*3 bbox_s(4)*3];
    
    % get target patch
    P = rgb2gray(get_patch(I, [bbox_t(1)+bbox_t(3)/2 bbox_t(2)+bbox_t(4)/2], 1, [bbox_t(3) bbox_t(4)]));
    
    % get ground truth
    G = create_gauss_peak([bbox_t(3) bbox_t(4)], 1, 0.00001);
    
    % precalculate
    Pf = fft2(P);
    Pfc = conj(Pf);
    Gf = fft2(G);
    
    % calculate filter
    Hfc = (Gf .* Pfc) ./ (Pf .* Pfc);

    % construct state
    state = struct;
    state.alpha = 0.01;    
    state.Hfc = Hfc;
    state.Gf = Gf;
    state.bbox_s = bbox_s;
    state.bbox_t = bbox_t;
    
    % location
    location = bbox_s;
    
end

function bbox_s = get_search_bbox(region)
    % If the provided region is a polygon ...
    if numel(region) > 4
        x1 = round(min(region(1:2:end)));
        x2 = round(max(region(1:2:end)));
        y1 = round(min(region(2:2:end)));
        y2 = round(max(region(2:2:end)));
        region = round([x1, y1, x2 - x1, y2 - y1]);
    else
        region = round([round(region(1)), round(region(2)), ... 
            round(region(1) + region(3)) - round(region(1)), ...
            round(region(2) + region(4)) - round(region(2))]);
    end;

    bbox_s = region;
end