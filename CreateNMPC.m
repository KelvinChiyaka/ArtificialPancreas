clc;

%system dimensions
nx = 3;   %states
ny = 1;   %output
nu = 1;   %input

%horizons and sampling
Ts = 1;    %sampling time [min]
Np = 160;  %prediction horizon
Nc = 5;    %control horizon

%nmpc object
nlobj = nlmpc(nx, ny, nu);
nlobj.Ts                    = Ts;
nlobj.PredictionHorizon     = Np;
nlobj.ControlHorizon        = Nc;

%model configuration
nlobj.Model.StateFcn          = "BergmanNMPC";
nlobj.Model.OutputFcn         = "BergmanOutput";
nlobj.Model.IsContinuousTime  = true;
nlobj.Model.NumberOfParameters = 1;  %meal disturbance D passed as parameter

%calling the cost function from the other file
nlobj.Optimization.CustomCostFcn       = @BergmanCustomCost;
nlobj.Optimization.ReplaceStandardCost = true;

%for soft constraint
nlobj.Optimization.CustomIneqConFcn = @BergmanIneqConFcn;

nlobj.Weights.OutputVariables          = 0;
nlobj.Weights.ManipulatedVariables     = 0;
nlobj.Weights.ManipulatedVariablesRate = 0;

%Physical pump constraints
umax   = 0.5;    %maximum insulin delivery above basal [mU/min]
du_max = 0.05;   %maximum slew rate [mU/min per min]

nlobj.MV.Min     =  0;
nlobj.MV.Max     =  umax;
nlobj.MV.RateMin = -du_max;
nlobj.MV.RateMax =  du_max;

%initial conditions
x0 = [5.0; 0; 0.0];  
u0 = 0;           
d0 = 0;              

%simulink parameter bus
mdl     = 'Bergman_Model_Non_Linear';
blkPath = [mdl, '/Nonlinear MPC Controller'];

e1            = Simulink.BusElement;
e1.Name       = 'D';
e1.DataType   = 'double';
e1.Dimensions = 1;

myParamBus          = Simulink.Bus;
myParamBus.Elements = e1;

assignin('base', 'myParamBus', myParamBus);

%function validations
validateFcns(nlobj, x0, u0, [], {d0});

%move options
options            = nlmpcmoveopt;
options.Parameters = {0};   %initial meal disturbance D = 0