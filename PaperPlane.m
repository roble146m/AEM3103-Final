%	Example 1.3-1 Paper Airplane Flight Path
%	Copyright 2005 by Robert Stengel
%	August 23, 2005
% For part 3: Don't need params. vs. time graphs, want height vs. range 
%   (w/multiple ~100 trajectories) with a single curve fit. 
%   Recommended to use a single line color

clc; clear; close all;

%	a) Equilibrium Glide at Maximum Lift/Drag Ratio
	[V Gam H R] = setup_sim();
	to		=	0;			% Initial Time, sec
	tf		=	6;			% Final Time, sec
	tspan	=	[to tf];
	xo		=	[V;Gam;H;R];
	[ta,xa]	=	ode23('EqMotion',tspan,xo);
	
%	b1) Oscillating Glide due to Zero Initial Flight Path Angle
%           and lower Initial Velocity -- DO WE LEAVE GAM = 0??
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

% 	figure
% 	plot(xa(:,4),xa(:,3),xb1(:,4),xb1(:,3),xc1(:,4),xc1(:,3),xd1(:,4),xd1(:,3))
% 	xlabel('Range, m'), ylabel('Height, m'), grid
%   legend("a", "b1", "c1", "d1");

    figure; hold on;
    ords = [1, 2];
    for i = 1:length(ords)
        ord = ords(i);
        subplot(2, 1, i);
        if i == 1
            plot(xc1(:,4),xc1(:,3),"k",xd1(:,4),xd1(:,3),"g",xb1(:,4),xb1(:,3),"r");
            title(["Height vs. Range", "Varying Initial Velocity"]);
            xlabel('Range (m)'), ylabel('Height (m)'), grid
            legend("Nominal", "Higher", "Lower");
        else
            plot(xc2(:,4),xc2(:,3),"k",xd2(:,4),xd2(:,3),"g", xb2(:,4),xb2(:,3),"r");
            title(["Height vs. Range", "Varying Initial Flight Path Angle"]);
            xlabel('Range (m)'), ylabel('Height (m)'), grid
            legend("Nominal", "Higher", "Lower");
        end
    end

% 	figure
% 	subplot(2,2,1)
% 	plot(ta,xa(:,1),tb,xb(:,1),tc,xc(:,1),td,xd(:,1))
% 	xlabel('Time, s'), ylabel('Velocity, m/s'), grid
% 	subplot(2,2,2)
% 	plot(ta,xa(:,2),tb,xb(:,2),tc,xc(:,2),td,xd(:,2))
% 	xlabel('Time, s'), ylabel('Flight Path Angle, rad'), grid
% 	subplot(2,2,3)
% 	plot(ta,xa(:,3),tb,xb(:,3),tc,xc(:,3),td,xd(:,3))
% 	xlabel('Time, s'), ylabel('Altitude, m'), grid
% 	subplot(2,2,4)
% 	plot(ta,xa(:,4),tb,xb(:,4),tc,xc(:,4),td,xd(:,4))
% 	xlabel('Time, s'), ylabel('Range, m'), grid

