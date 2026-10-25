%% Analog Electronics final project

clc; 
close all; 
clear;

addpath(genpath('circuitDesign'));
addpath(genpath('models'));

load('UMC65_RVT.mat');

%% Initializations
designkitName		= 'umc65';
circuitTitle		= 'Analog Design - Project';
elementList.nmos	= {'Mn3','Mn4','Mn6'};
elementList.pmos	= {'Mp1','Mp2','Mp5','Mp7','Mp8'};

choice.maxFingerWidth = 10e-6;
choice.minFingerWidth = 200e-9;

simulator			= 'spectre';
simulFile			= 0;
simulSkelFile		= 0;
spec				= [];
analog			= cirInit('analog',circuitTitle,'top',elementList,spec,choice,...
						designkitName,NRVT,PRVT,simulator,simulFile,simulSkelFile);
analog			= cirCheckInChoice(analog, choice);


%% Project: circuit
disp('                                                       ');
disp('  VDD          VDD                    VDD              ');
disp('   |             |                      |              ');
disp('  Mp8-+---------Mp7---------------------Mp5            ');
disp('   |--+          |                      |              ');
disp('   |          +--+--+         node 3->  +-----+---OUT  ');
disp('   |          |     |                   |     |        ');
disp('   |    IN1--Mp1   Mp2--IN2             |     |        ');
disp('   |          |     |                   |     |        ');
disp('   | node 1-> |     | <-node 2          |     Cl       ');
disp('   |          |--+  +------+-Cm---Rm----+     |        ');
disp(' Ibias        |  |  |      |    ↑       |     |        ');
disp('   |         Mn3-+-Mn4     |  node 4    |     |        ');
disp('   |          |     |      +-----------Mn6    |        ');
disp('   |          |     |                   |     |        ');
disp('  GND        GND   GND                 GND   GND       ');

%% AI: Implement your OpAmp according to your handcalculations
Ibias=56.8e-6; 
fGBW=55e6; 
Cl=10e-12; 
Cm=2.5e-12;% To have a good stability increasing Cc will increase stability 
GBW=fGBW*2*pi; 
VDD=1.1;

%%Mp1 
Mp1.lg=100e-9; 
Mp1.vov=-0.43; 
Mp1.gm=GBW*Cm; 
Mp1.vds=-0.2; 
Mp1.vsb=0; 
Mp1.vth=tableValueWref('vth',PRVT,Mp1.lg,0,Mp1.vds,Mp1.vsb);
Mp1.vgs=Mp1.vth + Mp1.vov; 
Mp1.w=mosWidth('gm',Mp1.gm,Mp1); 
Mp1=mosNfingers(Mp1); 
Mp1=mosOpValues(Mp1); 
  
%%Mp2 
Mp2.lg=Mp1.lg; 
Mp2.vov=Mp1.vov; 
Mp2.gm=Mp1.gm;
Mp2.vds= Mp1.vds; 
Mp2.vsb=0; 
Mp2.vth=tableValueWref('vth',PRVT,Mp2.lg,0,Mp2.vds,Mp2.vsb); 
Mp2.vgs=Mp2.vth + Mp2.vov; 
Mp2.w=mosWidth('gm',Mp2.gm,Mp2); 
Mp2=mosNfingers(Mp2); 
Mp2=mosOpValues(Mp2); 

%%Mn6 
Mn6.lg=80e-9; 
Mn6.vov=0.18; 
%Mn6.vov=0.2; 
Mn6.gm=GBW*Cl/tan(deg2rad(10)); 
Mn6.vds=0.55; 
Mn6.vsb=0; 
Mn6.vth=tableValueWref('vth',NRVT,Mn6.lg,0,Mn6.vds,Mn6.vsb); 
Mn6.vgs=Mn6.vth + Mn6.vov; 
Mn6.w=mosWidth('gm',Mn6.gm,Mn6); 
Mn6=mosNfingers(Mn6); 
Mn6=mosOpValues(Mn6); 

%%Mn3 
Mn3.lg=500e-9; 
Mn3.ids=Mp1.ids; 
Mn3.vds=0.4; 
Mn3.vsb=0; 
Mn3.vgs=Mn6.vgs; 
Mn3.vth=tableValueWref('vth',NRVT,Mn3.lg,0,Mn3.vds,Mn3.vsb); 
Mn3.vov=Mn3.vgs+Mn3.vth;% 
Mn3.w=mosWidth('ids',Mn3.ids,Mn3); 
Mn3=mosNfingers(Mn3); 
Mn3=mosOpValues(Mn3); 

%%Mn4 
Mn4.lg=Mn3.lg; 
Mn4.ids=Mn3.ids;%microAmper 
Mn4.vds=Mn3.vds; 
Mn4.vsb=0; 
Mn4.vgs=Mn6.vgs; 
Mn4.vth=tableValueWref('vth',NRVT,Mn4.lg,0,Mn4.vds,Mn4.vsb); 
Mn4.vov=Mn4.vgs-Mn4.vth; 
Mn4.w=mosWidth('ids',Mn4.ids,Mn4); 
Mn4=mosNfingers(Mn4); 
Mn4=mosOpValues(Mn4); 

%%Mp5 
Mp5.lg=1000e-9; 
Mp5.vov=-0.2; 
Mp5.ids=Mn6.ids;%microAmper 
Mp5.vds=-0.2; 
Mp5.vsb=0; 
Mp5.vth=tableValueWref('vth',PRVT,Mp5.lg,0,Mp5.vds,Mp5.vsb); 
Mp5.vgs=Mp5.vth + Mp5.vov; 
Mp5.w=mosWidth('ids',Mp5.ids,Mp5); 
Mp5=mosNfingers(Mp5); 
Mp5=mosOpValues(Mp5); 


%%Mp7 
Mp7.lg=1000e-9; 
Mp7.vov=Mp5.vov; 
Mp7.ids=Mp1.ids+Mp2.ids;%microAmper 
Mp7.vds=-VDD-Mp1.vds+Mn3.vds; 
Mp7.vsb=0; 
Mp7.vth=tableValueWref('vth',PRVT,Mp7.lg,0,Mp7.vds,Mp7.vsb); 
Mp7.vgs=Mp7.vth + Mp7.vov; 
Mp7.w=mosWidth('ids',Mp7.ids,Mp7); 
Mp7=mosNfingers(Mp7); 
Mp7=mosOpValues(Mp7); 


%%Mp8 
Mp8.lg=1000e-9; 
Mp8.vov=Mp5.vov;
Mp8.ids=Ibias;%microAmper 
Mp8.vds=-0.55; 
Mp8.vsb=0; 
Mp8.vth=tableValueWref('vth',PRVT,Mp8.lg,0,Mp8.vds,Mp8.vsb); 
Mp8.vgs=Mp8.vth + Mp8.vov; 
Mp8.w=mosWidth('ids',Mp8.ids,Mp8); 
Mp8=mosNfingers(Mp8); 
Mp8=mosOpValues(Mp8);


%% AI: Fill out the empty variables required to plot the transfer-function.
%  meaning of each variable see comment and
%  location of nodes see line 31 

AvDC1 =(Mp2.gm)/(Mp2.gds+Mn4.gds);
AvDC2 =(Mn6.gm)/(Mp5.gds+Mn6.gds);  % DC gain 2nd stage
C1 =Mn3.cdb+Mn3.cgb+Mn3.cgs+Mp1.cdb+Mp1.cgd+Mn4.cgd+Mn4.cgb+Mn4.cgb ; % Capacitance on node 1
G1 = Mn3.gm; % Admittance on node 1
C2 =Cm*(1+AvDC2)+Mn4.cdb+Mn4.cgd+Mp2.cgd+Mp2.cdb+Mn6.cgd+Mn6.cgs+Mn6.cgb; % Capacitance on node 2
G2 = Mp2.gds+Mn4.gds; % Admittance on node 2
C3 = Cl; % Capacitance on node 3
G3 = Mn6.gm; % Admittance on node 3
C4 = Cm*(1+AvDC2)+Mn6.cdb+Mn6.cgb+Mn6.cgs; % Capacitance on node 4
G4 = Mn6.gm; % Admittance on node 4 (hint: what happens with CL at very high frequencies?)


%% AI: Set-up Rm, Cc and CL and calculate the zero required for the transfer-fct

spec.Cm = 2.5e-12;
spec.Cl = 10e-12;
spec.Rm = -173.7;
z2 = 1/(1/spec.Rm-Mn6.gm);  % expression of zero due to the nulling resistor [rad/s]

%% AI: Fill out the empty variables required for the performance summary
 Vin_cm_min=50e-3+Mp1.vgs+Mn3.vgs;
 Vin_cm_max=VDD+Mp1.vgs+Mp7.vov;
 Vout_cm_min = Mn6.vdsat;
 Vout_cm_max = VDD - abs(Mp5.vdsat);
 Pdiss = VDD * (Mp5.ids + Mp7.ids + Mp8.ids);

%% Sanity check (do not modify)

disp('======================================');
disp('=      Transistors in saturation     =');
disp('======================================');
if mosCheckSaturation(Mp1)
	fprintf('\nMp1:Success\n')
end
if mosCheckSaturation(Mp2)
	fprintf('Mp2:Success\n')
end
if mosCheckSaturation(Mn3)
	fprintf('Mn3:Success\n')
end
if mosCheckSaturation(Mn4)
	fprintf('Mn4:Success\n')
end
if mosCheckSaturation(Mp5)
	fprintf('Mp5:Success\n')
end
if mosCheckSaturation(Mn6)
	fprintf('Mn6:Success\n')
end
if mosCheckSaturation(Mp7)
	fprintf('Mp7:Success\n')
end
if mosCheckSaturation(Mp8)
	fprintf('Mp8:Success\n\n')
end


%% Summary of sizes and biasing points (do not modify)

disp('======================================');
disp('=    Sizes and operating points      =');
disp('======================================');
analog = cirElementsCheckOut(analog); % Update circuit file with 
% transistor sizes
mosPrintSizesAndOpInfo(1,analog); % Print the sizes of the 
% transistors in the circuit file
fprintf('IBIAS\t= %6.2fmA\nRm\t= %6.2f Ohm\nCm\t= %6.2fpF\n\n',Mp8.ids/1e-3,spec.Rm,spec.Cm/1e-12);

%% Performance summary (do not modify)

disp('======================================');
disp('=        Performance                 =');
disp('======================================');

fprintf('\nmetric        \t result\n');
fprintf('Vin,cm,min [mV] \t%.0f\n',Vin_cm_min/1e-3);
fprintf('Vin,cm,max [mV] \t%.0f\n',Vin_cm_max/1e-3);
fprintf('Vout,cm,min [mV] \t%.0f\n',Vout_cm_min/1e-3);
fprintf('Vout,cm,max [mV] \t%.0f\n',Vout_cm_max/1e-3);
fprintf('Pdiss [mW]       \t%.1f\n\n',Pdiss/1e-3);

disp('======================================');
disp('=        Poles/Zeros                 =');
disp('======================================');

fprintf('\np1 = %.1f\tMHz\n', G1/(2*pi*C1*1e6));
fprintf('p2 = %.1f\tkHz\n', G2/(2*pi*C2*1e3));
fprintf('p3 = %.1f\tMHz\n', G3/(2*pi*C3*1e6));
fprintf('p4 = %.1f\tGHz\n', G4/(2*pi*C4*1e9));
fprintf('z1 = %.1f\tMHz\n', 2*G1/(2*pi*C1*1e6));
fprintf('z2 = %.1f\tMHz\n', z2);

%% Ploting transfer function (do not modify)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if control toolbox in Matlab is available
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s   = tf('s');
% transfer function
TF1   = AvDC1*AvDC2*((1+s*C1/(2*G1))*(1-s*(1/z2)))/ ...
                ((1+s*C1/G1)*(1+s*C2/G2)*(1+s*C3/G3)*(1+s*C4/G4));

freq = logspace(1,12,1e3);
figure(1)
bode(TF1,2*pi*freq); grid on;
h = gcr;
setoptions(h,'FreqUnits','Hz');
title('Frequency response Opamp');
hold all

spice_tbl = read_LTspice_data("final_project_data.txt");
[matlab_mag, matlab_phase] = bode(TF1, 2*pi*spice_tbl.freq);

figure
subplot(2, 1, 1);
semilogx(spice_tbl.freq*1e-6, 20*log10(squeeze(matlab_mag)));
hold on;
semilogx(spice_tbl.freq*1e-6, 20*log10(abs(spice_tbl.G1)));
grid on;
xlabel('Frequency (MHz)')
ylabel('Gain (dB)')
title('Full Bode Comparison')
subplot(2, 1, 2);
semilogx(spice_tbl.freq*1e-6, squeeze(matlab_phase));
hold on;
semilogx(spice_tbl.freq*1e-6, unwrap(angle(spice_tbl.G1))*180/pi);
grid on;
xlabel('Frequency (MHz)')
ylabel('Phase (°)')

fGBW = Mp2.gm / (2*pi*spec.Cm);
[~, minidx] = min(abs(2*fGBW - spice_tbl.freq));
roi = 1:(minidx+1);

figure
subplot(2, 1, 1);
semilogx(spice_tbl.freq(roi)*1e-6, 20*log10(squeeze(matlab_mag(:, :, roi))));
hold on;
semilogx(spice_tbl.freq(roi)*1e-6, 20*log10(abs(spice_tbl.G1(roi))));
grid on;
xlabel('Frequency (MHz)')
ylabel('Gain (dB)')
title('Zoomed-in Bode Comparison')
subplot(2, 1, 2);
semilogx(spice_tbl.freq(roi)*1e-6, squeeze(matlab_phase(:, :, roi)));
hold on;
semilogx(spice_tbl.freq(roi)*1e-6, unwrap(angle(spice_tbl.G1(roi)))*180/pi);
grid on;
xlabel('Frequency (MHz)')
ylabel('Phase (°)')

