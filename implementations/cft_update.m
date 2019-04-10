function [state, location] = cft_update(state, I, varargin)

	params = varargin{1};

    % state.Hfc = Hfc;
    % state.Gf = Gf;
    % state.bbox_s = bbox_s;
    % state.bbox_t = bbox_t;

    % get current center
    x_c = state.bbox_t(1)+state.bbox_t(3)/2;
    y_c = state.bbox_t(2)+state.bbox_t(4)/2;

    % get localization patch
    L = double(rgb2gray(get_patch(I, [x_c y_c], 1, [state.bbox_t(3) state.bbox_t(4)]))) .* state.Cw;

    % precalculate
    Lf = fft2(L);
    Lfc = conj(Lf);
    
    % get next center
    Gp = ifft2(Lf .* state.Hfc);
    [y_n, x_n] = find(Gp==max(max(Gp)));
    x_n = x_n + state.bbox_t(1);
    y_n = y_n + state.bbox_t(2);
           
    % get displacement vector
    dx = x_n - x_c;
    dy = y_n - y_c;
    
    % update state
    state.Hfc = (1-params.alpha)*state.Hfc + params.alpha*((state.Gf .* Lfc) ./ (Lf .* Lfc));
    state.bbox_s = [state.bbox_s(1)+dx state.bbox_s(2)+dy state.bbox_s(3:4)];
    state.bbox_t = [state.bbox_t(1)+dx state.bbox_t(2)+dy state.bbox_t(3:4)];

    % location
    location = state.bbox_s;
    
end