%	Example 1.3-1 Paper Airplane Flight Path
%	Copyright 2005 by Robert Stengel
%	August 23, 2005

clear; clc; close all;

%	a) Equilibrium Glide at Maximum Lift/Drag Ratio
	[V Gam H R] = setup_sim();
	to		=	0;			% Initial Time, sec
	tf		=	6;			% Final Time, sec
	tspan	=	[to tf];
	xo		=	[V;Gam;H;R];
	[ta,xa]	=	ode23('EqMotion',tspan,xo);
	
%% Part 2
%	b1) Oscillating Glide due to Zero Initial Flight Path Angle
%           and lower Initial Velocity 
	xo		=	[2;Gam;H;R];
	[tb1,xb1]	=	ode23('EqMotion',tspan,xo);

%	c1) Effect of nominal Initial Velocity
	xo		=	[3.55;Gam;H;R];
	[tc1,xc1]	=	ode23('EqMotion',tspan,xo);

%	d1) Effect of higher Initial Velocity
	xo		=	[7.5;Gam;H;R];
	[td1,xd1]	=	ode23('EqMotion',tspan,xo);

%	b2) Oscillating Glide due to lower Initial Flight Path Angle
	xo		=	[V;-0.5;H;R];
	[tb2,xb2]	=	ode23('EqMotion',tspan,xo);

%	c2) Effect of nominal Initial Flight Path Angle
	xo		=	[V;-0.18;H;R];
	[tc2,xc2]	=	ode23('EqMotion',tspan,xo);

%	d2) Effect of higher Initial Flight Path Angle
	xo		=	[V;0.4;H;R];
	[td2,xd2]	=	ode23('EqMotion',tspan,xo);

    figure; hold on;
    % TODO: Change labels font size and axes number font/size
    ords = [1, 2];
    for i = 1:length(ords)
        ord = ords(i);
        subplot(2, 1, i);
        if i == 1
            plot(xc1(:,4),xc1(:,3),"k",xd1(:,4),xd1(:,3),"g",xb1(:,4),xb1(:,3),"r");
            title(["Height vs. Range", "Varying Initial Velocity"], "FontName", "Times New Roman", "FontSize", 18);
            xlabel('Range (m)', "FontName", "Times New Roman", "FontSize", 14), ylabel('Height (m)', "FontName", "Times New Roman", "FontSize", 14); grid;
            legend("Nominal (3.55 m/s)", "Higher (7.5 m/s)", "Lower (2 m/s)", "FontName", "Times New Roman");
        else
            plot(xc2(:,4),xc2(:,3),"k",xd2(:,4),xd2(:,3),"g", xb2(:,4),xb2(:,3),"r");
            title(["Height vs. Range", "Varying Initial Flight Path Angle"], "FontName", "Times New Roman", "FontSize", 18);
            xlabel('Range (m)', "FontName", "Times New Roman", "FontSize", 14), ylabel('Height (m)', "FontName", "Times New Roman", "FontSize", 14); grid;
            legend("Nominal (-0.18 rad)", "Higher (0.4 rad)", "Lower (-0.5 rad)", "FontName", "Times New Roman");
        end
    end

%% Parts 3 and 4
figure; hold on;
title(["Height vs. Range", "Random Velocity and Flight Path Angle Parameters"], "FontName", "Times New Roman", "FontSize", 18);
xlabel('Range (m)', "FontName", "Times New Roman", "FontSize", 14), ylabel('Height (m)', "FontName", "Times New Roman", "FontSize", 14); grid;
% Only changing V and Gam randomly or all 4 vars?
% Change oppacity
Vrange = [2, 7.5];
Gamrange = [-0.5, 0.4];
H_array = zeros(100);
R_array = zeros(100);
t_array = zeros(100);
h = 6/99;
tspan = 0:h:6;
for i = 1:100
    Vrand = Vrange(1) + (Vrange(2)-Vrange(1))*rand(1);
    Gamrand = Gamrange(1) + (Gamrange(2)-Gamrange(1))*rand(1);
    xo		=	[Vrand;Gamrand;H;R];
	[t,x]	=	ode23('EqMotion',tspan,xo);   
    plot(x(:,4),x(:,3), "Color", [125, 125, 125]/255); % 107?
    hold on;
    H_array(:, i) = x(:, 3);
    R_array(:, i) = x(:, 4);
    t_array(:, i) = t(:, :);
end

H_array = H_array(:);
R_array = R_array(:);
t_array = t_array(:);

% Polyn. order? 
poly_H = polyfit(t_array, H_array, 10); 
H_fit = polyval(poly_H, t); 
poly_R = polyfit(t_array, R_array, 10);
R_fit = polyval(poly_R, t);
plot(R_fit, H_fit, "r", "LineWidth", 2); % "N-th order poly fit of..."

%% Part 5
H_der = central_der(t, H_fit);
R_der = central_der(t, R_fit);
figure; hold on;
for i = 1:2
    subplot(2, 1, i);
    if i == 1
        plot(t, H_der, 'b', "LineWidth", 2);
        title("Time Derivate of Height", "FontName", "Times New Roman", "FontSize", 18)
        xlabel("Time (sec)", "FontName", "Times New Roman", "FontSize", 14); ylabel("Height Derive (m/sec)", "FontName", "Times New Roman", "FontSize", 14); grid;
    end
    if i == 2
        plot(t, R_der, "r", "LineWidth", 2);
        title("Time Derivate of Range", "FontName", "Times New Roman", "FontSize", 18)
        xlabel("Time (sec)", "FontName", "Times New Roman", "FontSize", 14); ylabel("Range Derive (m/sec)", "FontName", "Times New Roman", "FontSize", 14); grid;
    end
end
