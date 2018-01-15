% Benjamin Getraer  PSET 3    GEO422
% bgetraer@princeton.edu
%% SETUP
frame_rate = 25; % assumed frames per second
interesting_images = 35:54; % ball is visible and in the air
% load frames and locate ball coordinates manually
tycoordinates = pset3_imgtrack(interesting_images,frame_rate);
% measure ball diameter in pixels
edge1 = pset3_imgtrack(43,frame_rate);
edge2 = pset3_imgtrack(43,frame_rate);
% set pixel to meter conversion
pix2m = 0.04/(edge1(2)-edge2(2)); % meters per pixel
% correct the height from the flipped pixel coordinate system so that up is positive y
height_0 = 100;
y = pix2m.*cumsum([height_0; -diff(tycoordinates(:,2))]);
t = tycoordinates(:,1);
%% Basic model assumptions
% y(t) = m1(1) + m1(2)*t - 1/2*m1(3)*t^2

% linear operator G
G = ones(length(t),3);	% position
G(:,2) = t;             % velocity
G(:,3) = -1/2.*t.^2;			% acceleration

%% Load previous data
% previous seperate position vectors in ymat
load ymat t
for h = 1
    y = ymat(:,h);
    % MODEL ONE
    
    % calculate model parameters using a LEFT HAND INVERSE
    % downward acceleration due to gravity is equal to m1(3)
    G_g1 = inv(G'*G)*G';  % generalized inverse G^(-g)
    m1(:,h) = G_g1*y;
    
    % COVARIANCE
    % construct data covariance matrix
    C_y = (y-G*m1(:,h))*(y-G*m1(:,h))';
    % construct model covariance matrix
    C_m = G_g1*C_y*G_g1'./length(t);
    
    % MODEL TWO - Best Linear Unbiased Estimator
    % calculate model parameters using a covariance weighting
    % downward acceleration due to gravity is equal to m2(3)
    G_g2 = inv(G'*inv(C_y)*G)*G'*inv(C_y);
    m2(:,h) = G_g2*y;
    % FIGURE
    % PLOT THE MEASURED TRAJECTORY
    figure(1)
    hold on; grid on;
    xlabel('time [sec]'); ylabel('height [m]');
    % plot(tycoordinates(:,1),tycoordinates(:,2),'o')
    plot(t,y,'kX','linewidth',2,'markersize',9);
    
    % PLOT THE MODELED TRAJECTORIES
    Y1(:,h) = G*m1(:,h);
    Y2(:,h) = G*m2(:,h);
    plot(t,Y1(:,h),'b-','linewidth',2);
    plot(t,Y2(:,h),'r--','linewidth',2);
    
    % CHI SQUARED TEST
    % eq(6) from PSET 2:
    % ChiSq = sum(((error).^2)./var(error) ~ CHISQ(length(y)-length(m))
    % We have a dataset of length(y) measurements
    % We have a 3 parameter model ie 3 independent linear constraints.
    deg_freedom = length(y)-3;
    % error
    y_error1(:,h) = (y-Y1(:,h));
    y_error2(:,h) = (y-Y2(:,h));
    % variances (not sure which one to choose)
%     sigma_2 = sum(C_y.*eye(20))';
    sigma_2 = var(y_error1);
    % calculate the chi squared value for the model fit
    chi_value(:,h) = sum(((y_error1(:,h)).^2)./sigma_2);
    % create an x vector to plot the chi sq pdf
    x_chi = 0:0.01:100;
    % PLOT THE CHI SQ PDF
    figure(h)
    hold on;
    plot(x_chi,chi2pdf(x_chi,deg_freedom));
    plot([chi_value chi_value],ylim);
end

m_confidence = 1.96.*abs((sum(C_m.*eye(3)))).^(1/2)
