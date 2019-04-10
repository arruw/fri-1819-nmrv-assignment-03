I1 = rgb2gray(imread('./resources/vot/ball1/00000001.jpg'));
I2 = rgb2gray(imread('./resources/vot/ball1/00000020.jpg'));

% ground truth
gt = [200.35,159.32,200.35,113.74,245.48,113.74,245.48,159.32];
x1 = gt(3);
y1 = gt(4);
x2 = gt(7);
y2 = gt(8);

% search & target bounding box
bbox_s = get_search_bbox(gt);
bbox_t = [x1-bbox_s(3)/2 y1-bbox_s(4)/2 bbox_s(3)*2 bbox_s(4)*2];

Cw = create_cos_window([bbox_t(3) bbox_t(4)]);

% get patch
x_c = bbox_t(1)+bbox_t(3)/2;
y_c = bbox_t(2)+bbox_t(4)/2;
P = double(get_patch(I1, [bbox_t(1)+bbox_t(3)/2 bbox_t(2)+bbox_t(4)/2], 1, [bbox_t(3) bbox_t(4)])) .* Cw;
L = double(get_patch(I2, [x_c y_c], 1, [bbox_t(3) bbox_t(4)])) .* Cw;

% get ground truth
G = create_gauss_peak([bbox_t(3) bbox_t(4)], 1, 0.00001);

figure(1); clf;
subplot(2, 3, 1); imshow(I1); axis([0 size(I1, 2) 0 size(I1, 1)]); axis on;

hold on;
rectangle('Position',bbox_t, 'LineWidth',2, 'EdgeColor','r');
rectangle('Position',bbox_s, 'LineWidth',2, 'EdgeColor','g');
drawnow;
hold off;

subplot(2, 3, 2); imshow(I2); axis([0 size(I2, 2) 0 size(I2, 1)]); axis on;

hold on;
rectangle('Position',bbox_t, 'LineWidth',2, 'EdgeColor','r');
rectangle('Position',bbox_s, 'LineWidth',2, 'EdgeColor','g');
drawnow;
hold off;

subplot(2, 3, 4); imshow(Cw);
subplot(2, 3, 5); imshow(uint8(P));

Pf = fft2(P);
Pfc = conj(Pf);
Gf = fft2(G);

Hfc = (Gf .* Pfc) ./ (Pf .* Pfc);

Gp = ifft2(fft2(L) .* Hfc);

subplot(2, 3, 3); imshow(Gp); axis([0 bbox_t(3) 0 bbox_t(4)]); axis square;

[y, x] = find(Gp==max(max(Gp)));

subplot(2, 3, 2); hold on; plot(x+bbox_t(1), y+bbox_t(2), 'rx', 'MarkerSize', 20); hold off;

tx = normalize(ifft2(conj(Hfc)));

subplot(2, 3, 6); imshow(tx);

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

function A = normalize(A)
    A = A - min(A(:));
    A = A ./ max(A(:));
end
