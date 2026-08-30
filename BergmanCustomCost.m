function J = BergmanCustomCost(X, U, e, data, ~)

%clinical parameters
G_ref    = 5.0;
G_hypo  = 3.9;
G_hyper = 10.0;

%asymmetric glucose zone weightd
w_hypo  = 100.0;  % hypoglycaemia weight
w_eu    =   1.0;  % euglycaemia weight
w_hyper =  10.0;  % hyperglycaemia weight

%input penalty weights
r_u  = 0.01;
r_du = 0.10;

Np = data.PredictionHorizon;

%glucose tracking cost
J_glucose = 0.0;

for k = 2 : Np + 1
    G_k = X(k, 1);
    e_k = G_k - G_ref;

    if G_k < G_hypo
        w_k = w_hypo;
    elseif G_k > G_hyper
        w_k = w_hyper;
    else
        w_k = w_eu;
    end

    J_glucose = J_glucose + w_k * (e_k^2);
end

%input cost
J_input = 0.0;

for k = 1 : Np
    u_k = U(k, 1);

    if k == 1
        du_k = u_k - data.LastMV(1);
    else
        du_k = U(k, 1) - U(k-1, 1);
    end

    J_input = J_input + r_u * (u_k^2) + r_du * (du_k^2);
end

%soft hypoglycemia constraint
J_soft = 0.0;
w_e1   = 1000.0;
w_e2   =  100.0;

if length(e) == Np         
    for k = 1 : Np
        e_k    = e(k);
        J_soft = J_soft + w_e1*(e_k^2) + w_e2*e_k;
    end
elseif ~isempty(e)          % placeholder scalar during validateFcns
    J_soft = w_e1*(e(1)^2) + w_e2*e(1);
end
% if e is empty, J_soft stays 0. safe fallback

%total cost function 
J = J_glucose + J_input + J_soft;

end

