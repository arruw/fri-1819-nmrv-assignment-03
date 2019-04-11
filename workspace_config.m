function c = workspace_config()

% name of the tracker
c.tracker_name = 'mosse';
% additional paths: where source code is located
c.additional_paths = {'helpers', 'implementations'};
% path to the sequences directory
c.dataset_path = 'resources/vot2014';

end  % endfunction
