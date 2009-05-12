function [W,b,eplisons] = calc_margin_constriants(model,train_data,train_label)
% W = train_data(model.SVs,:)'*(train_label(model.SVs).*abs(model.sv_coef));
% b = -model.rho;
% 
% if model.Label(1) == -1
%     W = -W;
%     b = -b;
% end

W = model.SVs' * model.sv_coef;
b = -model.rho;

% if model.Label(1) == -1
%   W = -W;
%   b = -b;
% end

eplisons = zeros(size(train_data,1),1);
% eplisons(model.SVs) = 1-train_label(model.SVs).*(W'*train_data(model.SVs,:)'+b)';

return;
