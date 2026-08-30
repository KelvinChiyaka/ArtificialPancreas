
function dxdt = BergmanNMPC(x, u, D)
%model parameters
p1 = 0.005; %set to almost to provide the modification to represent a patient with no pancreas at all and avoid glucose falling automatically without the controller
p2 = 0.025; % 1/min
p3 = 7.00e-5;  % L/(mU*min^2)
n  = 0.0926;  % 1/min

Gb = 5.0;   %basal glucose (mmol/L)
Ib = 0;    %basal insulin (mU/L)

%states
G = x(1);
X = x(2);
I = x(3);

%continuous state derivatives
dG    = -p1*(G - Gb) - X*G + D; % D.E affected by the modification
dX = -p2*X + p3*max(0, I - Ib); % Insulin action active when I > Ib
dI = -n*(I - Ib) + u;

dxdt = [dG; dX; dI];
end
