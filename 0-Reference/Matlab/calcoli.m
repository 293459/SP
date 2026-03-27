close all
clear
clc



%norm = [3.17037315E-03, 2.04207515E-03, 1.39975804E-03,1.02902157E-03];

nodi = [750, 3000, 6750, 12000];
norm_lax =[3.00047500E-03,2.16603652E-03, 1.72955834E-03, 1.45252375E-03];
norm_roe = [2.51772022E-03,1.61754014E-03,1.16883812E-03,9.11165902E-04];
lc =[2.05965936E-02, 1.01942774E-02, 6.77337218E-03, 5.07152174E-03];
color = [0.9290 0.6940 0.1250];


figure

plot(nodi, norm_lax, 'o-', 'Color',color, LineWidth=1.5);
grid on

ylabel('||S||_2')
xlabel('Number of nodes')

figure

plot(lc, norm_lax, 'o-', 'Color',color, LineWidth=1.5);
grid on
hold on
plot(lc, norm_roe, 'go-',LineWidth=1.5)
ylabel('||S||_2')
xlabel('Characteristic length - lc')
legend('Lax–Friedrichs', 'Roe')



figure
loglog(lc, norm_lax, 'o-', 'Color',color, LineWidth=1.5);
hold on
loglog(lc, norm_roe, 'go-', LineWidth=1.5);
hold on
loglog(lc, lc, 'b-',LineStyle='--' ,LineWidth=1);


grid on
ylabel('||S||_2')
xlabel('Characteristic length - lc')
legend('Lax–Friedrichs', 'Roe')

% soluzione esatta
p_lax = (log(norm_lax(end))-log(norm_lax(end-1)))/(log(lc(end))-log(lc(end-1)));
p_roe = (log(norm_roe(end))-log(norm_roe(end-1)))/(log(lc(end))-log(lc(end-1)));


% ordine teorico 
p_teo=1;
r=4;
Fs = 3;
uo_lax_teo = (r^p_teo*norm_lax(end)-norm_lax(1))/(r^p_teo-1);
E_lax_teo= abs(norm_lax(end) - uo_lax_teo);
GCI_lax_teo =  E_lax_teo*Fs;

uo_roe_teo = (r^p_teo*norm_roe(end)-norm_roe(end-1))/(r^p_teo-1);
E_roe_teo = abs(norm_roe(end) - uo_roe_teo);
GCI_roe_teo =  E_roe_teo*Fs;

% ordine effettivo

p_lax_eff = log((norm_lax(1)-norm_lax(2))/(norm_lax(2)-norm_lax(end)))/log(2);
p_roe_eff = log((norm_roe(1)-norm_roe(2))/(norm_roe(2)-norm_roe(end)))/log(2);

uo_lax_eff = norm_lax(end)+(norm_lax(2)-norm_lax(end))/(2^p_lax_eff-1);
uo_roe_eff = norm_roe(end)+(norm_roe(2)-norm_roe(end))/(2^p_roe_eff-1);

E_lax_eff = (norm_lax(end) - uo_lax_eff);
E_roe_eff = (norm_roe(end) - uo_roe_eff);

GCI_lax_eff = E_lax_eff*Fs;
GCI_roe_eff = E_roe_eff*Fs;

%% pressione

close all
clear
clc

gamma =1.4;
color = [0.9290 0.6940 0.1250];


data_lax = importdata('wall_data_lax.txt');
sorted_data_lax = sortrows(data_lax, 1);

threshold = (max(sorted_data_lax(:, 2))-min(sorted_data_lax(:, 2)))/2;
up_wall_lax = sorted_data_lax((sorted_data_lax(:, 2) >= threshold), :);
down_wall_lax = sorted_data_lax((sorted_data_lax(:, 2) < threshold), :);

Mis_up_lax = sqrt(2/(1.4-1).*((1./up_wall_lax(:,3)).^((gamma-1)/gamma)-1));
Mis_down_lax = sqrt(2/(1.4-1).*((1./down_wall_lax(:,3)).^((gamma-1)/gamma)-1));

figure
plot(up_wall_lax(:, 1), Mis_up_lax, '-o', 'Color',color, 'LineWidth',1.5)
grid on
xlabel('x')
ylabel('M_{is}')
title('Wall pressure up -- Lax–Friedrichs')

figure
plot(down_wall_lax(:, 1), Mis_down_lax, '-o', 'Color',color, 'LineWidth',1.5)
grid on
xlabel('x')
ylabel('M_{is}')
title('Wall pressure down --  Lax–Friedrichs')

data_roe = importdata('wall_data_roe.txt');
sorted_data_roe = sortrows(data_roe, 1);

threshold = (max(sorted_data_roe(:, 2))-min(sorted_data_roe(:, 2)))/2;
up_wall_roe = sorted_data_roe((sorted_data_roe(:, 2) >= threshold), :);
down_wall_roe = sorted_data_roe((sorted_data_roe(:, 2) < threshold), :);

Mis_up_roe= sqrt(2/(1.4-1).*((1./up_wall_roe(:,3)).^((gamma-1)/gamma)-1));
Mis_down_roe = sqrt(2/(1.4-1).*((1./down_wall_roe(:,3)).^((gamma-1)/gamma)-1));


figure
plot(up_wall_roe(:, 1),Mis_up_roe, '-o', 'Color',color, 'LineWidth',1.5)
grid on
xlabel('x')
ylabel('M_{is}')
title('Wall pressure up -- Roe')

figure
plot(down_wall_roe(:, 1), Mis_down_roe, '-o', 'Color',color, 'LineWidth',1.5)
grid on
xlabel('x')
ylabel('M_{is}')
title('Wall pressure down --  Roe')



%% paletta

clear

clc


color = [0.9290 0.6940 0.1250];

data_LS59 = importdata('wall_data_LS59.txt');
sorted_data_LS59 = sortrows(data_LS59, 1);
gamma =1.4;

xx = sorted_data_LS59(1:25:end, 1);
yy = sorted_data_LS59(1:25:end, 2);
p = polyfit(xx, yy, 2);
parab = polyval(p, sorted_data_LS59(:,1));

figure

plot(sorted_data_LS59(:,1), parab)
xlabel('X')
ylabel('Y')
grid on 

up_wall_LS59 = sorted_data_LS59((sorted_data_LS59(:, 2) >=parab) , :);
down_wall_LS59 = sorted_data_LS59((sorted_data_LS59(:, 2) < parab), :);


 Mis_up_LS59= sqrt(2/(1.4-1).*((1./up_wall_LS59(:,3)).^((gamma-1)/gamma)-1));
 Mis_down_LS59 = sqrt(2/(1.4-1).*((1./down_wall_LS59(:,3)).^((gamma-1)/gamma)-1));
Mis = sqrt(2/(gamma-1).*((1./sorted_data_LS59(:,3)).^((gamma-1)/gamma)-1));

% figure
% plot(up_wall_LS59(:, 1), up_wall_LS59(:, 3), 'r-o', 'LineWidth',1.5)
% hold on
% plot(down_wall_LS59(:, 1), down_wall_LS59(:, 3), 'b-o', 'LineWidth',1.5)

% grid on
% xlabel('x')
% ylabel('P_{is}')
% title('Wall pressure up -- LS59')





% figure
% plot(up_wall_LS59(:, 1), Mis_up_LS59, '-o', 'Color',color, 'LineWidth',1.5)
% 
% grid on
% xlabel('x')
% ylabel('M_{is}')
% title('Wall pressure up -- LS59')
% 
% 
% figure
% plot(down_wall_LS59(:, 1), Mis_down_LS59, '-o', 'Color',color, 'LineWidth',1.5)
% grid on
% xlabel('x')
% ylabel('M_{is}')
% title('Wall pressure down --  LS59')


betas = 33.3*pi/180;

data_LS59_exp= importdata('exp_data_LS59_wall_Mis_alpha30_Misexit1_2.txt');
sorted_data_LS59_exp = sortrows(data_LS59_exp, 1);


 x_rot_up = cos(betas)*up_wall_LS59(:, 1) - sin(betas)*up_wall_LS59(:, 2);
 x_rot_down = cos(betas)*down_wall_LS59(:, 1) - sin(betas)*down_wall_LS59(:, 2);
 x_rot = cos(betas)*sorted_data_LS59(:, 1) - sin(betas)*sorted_data_LS59(:, 2);
 corda = 1/cos(betas);


 figure
 plot(x_rot_up/corda, Mis_up_LS59, '.','Color',color, 'LineWidth',0.25)
 hold on

 plot(x_rot_down/corda, Mis_down_LS59, 'b.', 'LineWidth',0.25)
 hold on
 plot(sorted_data_LS59_exp(:, 1), sorted_data_LS59_exp(:, 2), 'k^', 'LineWidth',1.5)
 
 grid on
 xlabel('x^\prime/c')
 ylabel('M_{is}')
 %title('M_{is} -- LS59')
 legend ('CFD - Dorso','CFD - Ventre', 'Exp')


figure
plot(x_rot/corda, Mis, '.','Color',color, 'LineWidth',0.25)
hold on
plot(sorted_data_LS59_exp(:, 1), sorted_data_LS59_exp(:, 2), 'k^', 'LineWidth',1.5)

grid on
xlabel('x')
ylabel('M_{is}')
title('M_{is} -- LS59')
legend ('CFD', 'exp')


%fluent

fluent_LS59_inv_x = importdata("pressure_x.dat");
fluent_LS59_inv_y = importdata("pressure_y.dat");

fluent_LS59_inv = [fluent_LS59_inv_x(:,1), fluent_LS59_inv_y(:,1), fluent_LS59_inv_x(:,2)/100000];

Mis_inv = sqrt(2/(gamma-1).*((1./fluent_LS59_inv(:,3)).^((gamma-1)/gamma)-1));
x_rot_inv = cos(betas)*fluent_LS59_inv(:,1) - sin(betas)*fluent_LS59_inv(:,2);


fluent_LS59_visc_x = importdata("pressure_x_spalat.dat");
fluent_LS59_visc_y = importdata("pressure_y_spalat.dat");

fluent_LS59_visc = [fluent_LS59_visc_x(:,1), fluent_LS59_inv_y(:,1), fluent_LS59_visc_x(:,2)/100000];
Mis_visc = sqrt(2/(gamma-1).*((1./fluent_LS59_visc(:,3)).^((gamma-1)/gamma)-1));
x_rot_visc = cos(betas)*fluent_LS59_visc(:,1) - sin(betas)*fluent_LS59_visc(:,2);


figure
plot(x_rot/corda, Mis, '.','Color',color, 'LineWidth',0.25)
hold on
plot(sorted_data_LS59_exp(:, 1), sorted_data_LS59_exp(:, 2), 'k^', 'LineWidth',1.5)
hold on
plot(x_rot_inv/corda, Mis_inv, 'b.', 'LineWidth',1.5)
hold on
plot(x_rot_visc/corda, Mis_visc, 'g.', 'LineWidth',1.5)


grid on
xlabel('x')
ylabel('M_{is}')
title('M_{is} -- LS59')
legend ('CFD', 'exp', 'Fluent - inviscid', 'Fluent - viscous')









%% convergenza paletta
% ordine teorico 
clear
close all
clc

p_teo=1;
r=4;
Fs = 3;
lc_paletta =  [0.02, 0.01, 0.005];
norm_paletta_roe = [3.55573073E-02 , 2.91592609E-02, 2.82139089E-02]; %rho u
uo_roe_teo_paletta = (r^p_teo*norm_paletta_roe(end)-norm_paletta_roe(1))/(r^p_teo-1);
E_teo_paletta_roe= abs(norm_paletta_roe(end) - uo_roe_teo_paletta);
GCI_teo_paletta_roe=  E_teo_paletta_roe*Fs;

p_roe_paletta = log((norm_paletta_roe(1)-norm_paletta_roe(2))/(norm_paletta_roe(2)-norm_paletta_roe(end)))/log(2);

uo_roe_eff_paletta = norm_paletta_roe(end)+(norm_paletta_roe(2)-norm_paletta_roe(end))/(2^p_roe_paletta-1);

E_roe_paletta = abs(norm_paletta_roe(end) - uo_roe_eff_paletta);


GCI_roe_eff = E_roe_paletta*Fs;

%lax 

lc_paletta =  [0.02, 0.01, 0.005];
norm_paletta_lax = [4.93137129E-02 , 3.70688178E-02, 3.11164968E-02]; 
uo_lax_teo_paletta = (r^p_teo*norm_paletta_lax(end)-norm_paletta_lax(1))/(r^p_teo-1);
E_teo_paletta_lax= abs(norm_paletta_lax(end) - uo_lax_teo_paletta);
GCI_teo_paletta_lax=  E_teo_paletta_lax*Fs;

p_lax_paletta = log((norm_paletta_lax(1)-norm_paletta_lax(2))/(norm_paletta_lax(2)-norm_paletta_lax(end)))/log(2);

uo_lax_eff_paletta = norm_paletta_lax(end)+(norm_paletta_lax(2)-norm_paletta_lax(end))/(2^p_lax_paletta-1);

E_lax_paletta = abs(norm_paletta_lax(end) - uo_lax_eff_paletta);


GCI_lax_eff = E_lax_paletta*Fs;

color = [0.9290 0.6940 0.1250];


figure
loglog(lc_paletta, norm_paletta_lax, 'o-', 'Color',color, LineWidth=1.5);
hold on
loglog(lc_paletta, norm_paletta_roe, 'go-', LineWidth=1.5);
hold on


grid on
ylabel('||S||_2')
xlabel('Characteristic length - lc')
legend('Lax–Friedrichs', 'Roe')



%% doppia rampa

close all
clear
clc


color = [0.9290 0.6940 0.1250];
data_rampa = importdata('wall_data_rampa.txt');
sorted_data_rampa = sortrows(data_rampa, 1);
gamma =1.4;
threshold = 0.25;

down_rampa = sorted_data_rampa((sorted_data_rampa(:, 2) < threshold ), :);

% Mis = sqrt(2/(gamma-1).*((1./sorted_data_rampa(:,3)).^((gamma-1)/gamma)-1));


data_rampa_exp = importdata('exp_data_double_wedge_inlet_Mach3.txt');
sorted_data_rampa_exp = sortrows(data_rampa_exp, 1);

figure
plot(down_rampa(:,1), down_rampa(:,3) , 'o','Color',color, 'LineWidth',1)
hold on
plot(sorted_data_rampa_exp(:, 1), sorted_data_rampa_exp(:, 2), 'k^', 'LineWidth',1.5)

grid on

xlabel('x')
ylabel('P_w/P^\circ')
legend ('CFD', 'exp')


%fluent

fluent_inv = importdata('wall_data_fluent_inv.txt');
fluent_visc = importdata('wall_data_fluent_visc.txt');

Ptot= 100000;
figure
plot(down_rampa(:,1), down_rampa(:,3) , 'o','Color',color, 'LineWidth',0.5)
hold on
plot(sorted_data_rampa_exp(:, 1), sorted_data_rampa_exp(:, 2), 'k^', 'LineWidth',1.5)
hold on
plot(fluent_inv(:, 1), fluent_inv(:, 2)/Ptot, 'b.', 'LineWidth',1.5)
hold on
plot(fluent_visc(:, 1), fluent_visc(:, 2)/Ptot, 'g.', 'LineWidth',1.5)

grid on

xlabel('x')
ylabel('P_w/P^\circ')
legend ('CFD', 'exp', 'Fluent - inviscid', 'Fluent - viscous')





%% convergenza rampa
% ordine teorico 
clear
close all
clc

p_teo=1;
r=4;
Fs = 3;
lc_rampa =  [0.02, 0.01, 0.005];
norm_rampa_roe = [2.32951231E-02, 1.83160696E-02, 1.65075790E-02]; 
uo_roe_teo_rampa = (r^p_teo*norm_rampa_roe(end)-norm_rampa_roe(1))/(r^p_teo-1);
E_teo_rampa_roe= abs(norm_rampa_roe(end) - uo_roe_teo_rampa);
GCI_teo_rampa_roe =  E_teo_rampa_roe*Fs;

p_roe_rampa = log((norm_rampa_roe(1)-norm_rampa_roe(2))/(norm_rampa_roe(2)-norm_rampa_roe(end)))/log(2);

uo_roe_eff_rampa = norm_rampa_roe(end)+(norm_rampa_roe(2)-norm_rampa_roe(end))/(2^p_roe_rampa-1);

E_roe_rampa = abs(norm_rampa_roe(end) - uo_roe_eff_rampa);


GCI_roe_eff = E_roe_rampa*Fs;



norm_rampa_lax = [3.05405725E-02, 2.46864799E-02, 1.97092928E-02]; 
uo_lax_teo_rampa = (r^p_teo*norm_rampa_lax(end)-norm_rampa_lax(1))/(r^p_teo-1);
E_teo_rampa_lax= abs(norm_rampa_lax(end) - uo_lax_teo_rampa);
GCI_teo_rampa_lax =  E_teo_rampa_lax*Fs;

p_lax_rampa = log((norm_rampa_lax(1)-norm_rampa_lax(2))/(norm_rampa_lax(2)-norm_rampa_lax(end)))/log(2);

uo_lax_eff_rampa = norm_rampa_lax(end)+(norm_rampa_lax(2)-norm_rampa_lax(end))/(2^p_lax_rampa-1);

E_lax_rampa = abs(norm_rampa_lax(end) - uo_lax_eff_rampa);


GCI_lax_eff = E_lax_rampa*Fs;


color = [0.9290 0.6940 0.1250];


figure
loglog(lc_rampa, norm_rampa_lax, 'o-', 'Color',color, LineWidth=1.5);
hold on
loglog(lc_rampa, norm_rampa_roe, 'go-', LineWidth=1.5);
hold on


grid on
ylabel('||S||_2')
xlabel('Characteristic length - lc')
legend('Lax–Friedrichs', 'Roe')
