function cineq = BergmanIneqConFcn(X, ~, e, data, ~)

G_min = 3.9;
Np    = data.PredictionHorizon;

if length(e) < Np
    e = zeros(Np, 1);
end

cineq = zeros(2*Np, 1);

for k = 1 : Np
    G_k = X(k+1, 1);
    e_k = e(k);

    cineq(k)      = G_min - G_k - e_k;   % soft floor: <= 0
    cineq(Np + k) = -e_k;                 % non-negativity: <= 0
end

end