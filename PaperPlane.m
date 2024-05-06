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
	
%% Part 2: Single Parameter Variation
%	b1) Oscillating Glide due to lower Initial Velocity 
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
set(gcf,"PaperUnits","inches");
set(gcf,"PaperSize", [7.5 11]);
set(gcf,"PaperPosition",[0 0 7.5 11]);
set(gcf,"PaperPositionMode","Manual");
for i = 1:2
    subplot(2, 1, i);
    if i == 1
        plot(xb1(:,4),xb1(:,3),"r",xc1(:,4),xc1(:,3),"k",...
                xd1(:,4),xd1(:,3),"g", "LineWidth", 2); grid; box off;
        ax = gca; 
        set(ax, 'FontName', 'Times New Roman', 'FontSize', 18);
        set(title("Paper Plane Height vs. Range", "FontName", ...
                "Times New Roman", "FontSize", 29, "FontWeight","Bold"));
        set(subtitle(["2D Flight Trajectories by",...
                "Varying Initial Velocity"], "FontName",...
                "Times New Roman", "FontSize", 20));
        set(xlabel('Range (m)', "FontName", "Times New Roman",...
                "FontSize", 24, "FontWeight","Bold"));
        set(ylabel('Height (m)', "FontName", "Times New Roman",...
                "FontSize", 24, "FontWeight","Bold"));
        set(legend("Lower (2 m/s)", "Nominal (3.55 m/s)", ...
                "Higher (7.5 m/s)", "FontName", "Times New Roman", ...
                "FontSize", 16));
        pbaspect([3.5 2 1]);
        yticks(-3:1:4);
    else
        plot(xb2(:,4),xb2(:,3),"r",xc2(:,4),xc2(:,3),"k",...
                xd2(:,4),xd2(:,3),"g", "LineWidth", 2); grid; box off;
        ax = gca; 
        set(ax, 'FontName', 'Times New Roman', 'FontSize', 18);
        set(title("Paper Plane Height vs. Range", "FontName",...
                "Times New Roman", "FontSize", 29, "FontWeight","Bold"));
        set(subtitle(["2D Flight Trajectories by",...
                "Varying Initial Flight Path Angle"], "FontName",...
                "Times New Roman", "FontSize", 20));
        set(xlabel('Range (m)', "FontName", "Times New Roman",...
                "FontSize", 24, "FontWeight", "Bold"));
        set(ylabel('Height (m)', "FontName", "Times New Roman",...
                "FontSize", 24, "FontWeight", "Bold"));
        set(legend("Lower (-0.5 rad)", "Nominal (-0.18 rad)",...
                "Higher (0.4 rad)", "FontName", "Times New Roman",...
                "FontSize", 16));
        pbaspect([3.5 2 1]);
    end
end

saveas(gcf, "Fig_1_single_param_var.png");

%% Parts 3 and 4: Monte Carlo Simulation
figure; hold on;
set(gcf,"PaperUnits","inches");
set(gcf,"PaperSize", [9.5 8.5]);
set(gcf,"PaperPosition",[0 0 9.5 8.5]);
set(gcf,"PaperPositionMode","Manual");
ax = gca; 
set(ax, 'FontName', 'Times New Roman', 'FontSize', 18);
ax.XLim = [0 25];
set(title("Paper Plane Height vs. Range", "FontName",...
    "Times New Roman", "FontSize", 29, "FontWeight", "Bold"));
set(subtitle(["10th Order Polynomial Fit to 100 2D Flight Trajectories",...
    "of Random Initial Velocities and Flight Path Angles"],...
    "FontName", "Times New Roman", "FontSize", 20));
set(xlabel('Range (m)', "FontName", "Times New Roman",...
    "FontSize", 24, "FontWeight", "Bold"));
set(ylabel('Height (m)', "FontName", "Times New Roman",...
    "FontSize", 24, "FontWeight", "Bold")); grid;
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
    p = plot(x(:,4),x(:,3), "Color", [70, 70, 70]/255,...
        "HandleVisibility","off");
    p.Color(4) = 0.7;
    hold on;
    H_array(:, i) = x(:, 3);
    R_array(:, i) = x(:, 4);
    t_array(:, i) = t(:, :);
end

H_array = H_array(:);
R_array = R_array(:);
t_array = t_array(:);

poly_H = polyfit(t_array, H_array, 10); 
H_fit = polyval(poly_H, t); 
poly_R = polyfit(t_array, R_array, 10);
R_fit = polyval(poly_R, t);
plot(R_fit, H_fit, "r", "LineWidth", 5);
set(legend("Average 2D Trajectory", "FontSize", 18));
saveas(gcf, "Fig_2_monte_carlo_sim.png");

%% Part 5: Time Derivatives
H_der = central_der(t, H_fit);
R_der = central_der(t, R_fit);
figure; hold on;
set(gcf,"PaperUnits","inches");
set(gcf,"PaperSize", [7.5 9.5]);
set(gcf,"PaperPosition",[0.2 0 7.5 9.5]);
set(gcf,"PaperPositionMode","Manual");
for i = 1:2
    subplot(2, 1, i); box off;
    if i == 1
        plot(t, H_der, 'b', "LineWidth", 2); grid; box off;
        ax = gca; 
        set(ax, 'FontName', 'Times New Roman', 'FontSize', 18);
        ax.YLim = [-1.5 1.5];
        set(title(["Average 2D Trajectory",...
            "Height Time Derivate vs. Time"], "FontName",...
            "Times New Roman", "FontSize", 24, "FontWeight", "Bold"));
        set(xlabel("Time (s)", "FontName", "Times New Roman",...
            "FontSize", 20, "FontWeight", "Bold")); 
        set(ylabel(["Height Time Derivative", "(m/s)"], "FontName",...
            "Times New Roman", "FontSize", 20, "Fontweight", "Bold"));
        pbaspect([3.5 2 1]);
    end
    if i == 2
        plot(t, R_der, "r", "LineWidth", 2); grid; box off;
        ax = gca; 
        set(ax, 'FontName', 'Times New Roman', 'FontSize', 18);
        ax.YLim = [2 5];
        yticks(2:0.5:5)
        set(title(["Average 2D Trajectory",...
            "Range Time Derivate vs. Time"], "FontName", ...
            "Times New Roman", "FontSize", 24, "FontWeight", "Bold"));
        set(xlabel("Time (s)", "FontName", "Times New Roman",...
            "FontSize", 20, "Fontweight", "Bold")); 
        set(ylabel(["Range Time Derivative", "(m/s)"], "FontName",...
            "Times New Roman", "FontSize", 20, "FontWeight", "Bold"));
        pbaspect([3.5 2 1]);
    end
end

saveas(gcf, "Fig_3_time_der.png");
