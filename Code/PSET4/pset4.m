% Benjamin Getraer  PSET 3    GEO422
% bgetraer@princeton.edu, 11/27/2017
%
% Iterative changes to model from guessed parameters to minimize error

%load data from http://geoweb.princeton.edu/people/simons/geiger_student.mat
%into MEDIUMVELOCITY NOISYARRIVALTIMES and STATIONLOCATIONS
load geiger_student.mat

%generate 50 'starting models' and minimize error iteratively
minerror = inf.*ones(size(noisyarrivaltimes));
for j = 1:50
    %generate random model parameters guesses between -300 and 300
    m = (-1 + (2).*rand([1,4])).*300;
    %attempt model improvements for 20 iterations
    for i = 1:20
        %call function to return linearized operator and error data
        [ G, delta_t ] = guessarrivaltime(m);
        %invert and find correction parameters
        dm = G\delta_t;
        %correct model and repeat
        m = m+dm';
    end
    %store improved model if error has been improved
    if sum(delta_t.^2) < sum(minerror.^2)
        minerror = delta_t;
        m_min = m;
    end
end

%plot results
circlesize = (noisyarrivaltimes/10).^3; %circle sizes based on arrival time
figure(1);hold on;
scatter3(stationlocations(:,1),stationlocations(:,2),stationlocations(:,3),circlesize,'ko','markerfacecolor','k')
scatter3(m_min(2),m_min(3),m_min(4),'r^','markerfacecolor','r')
grid on
xlabel('x');ylabel('y');zlabel('z');

figure(2)
hold on
plot(minerror,'-xk')
plot([0 1+length(minerror)],[mean(minerror) mean(minerror)],'r')
plot([0 1+length(minerror)],[mean(minerror)+std(minerror) mean(minerror)+std(minerror)],'--b')
plot([0 1+length(minerror)],[mean(minerror)-std(minerror) mean(minerror)-std(minerror)],'--b')
xlabel('station number')
ylabel('seconds')
set(gca,'xtick',1:length(minerror),'xlim',[0 1+length(minerror)])
legend({'Error ($$model arrivals - observed arrivals$$)',...
    strcat('$$mean\{error\}$$=', sprintf(' %0.2e',mean(minerror))),...
    strcat('$$\sqrt{var\{error\}}=$$ ',sprintf(' %0.2f',std(minerror)))},...
    'Interpreter','latex','Location','northwest')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ G, delta_t ] = guessarrivaltime( m0 )
%GUESSARRIVALTIME calculates the arrival time of a seismic wave based on 
%guessed incident t,x,y,z parameters. Medium velocity and detector
%locations are given by PSET4, GEO422.
%
%INPUT
%   m0      vector of [t0,x0,y0,z0] guessed parameters
%
%OUTPUT
%   G       linear operator on model differences
%   delta_t vector of error in predicted arrival times

load geiger_student.mat
v = mediumvelocity; %siesmic wave celerity
guessedlocations = m0(2:end); %location parameters
t0 = m0(1);%time parameter
%vector of predicted arrival times based model parameters
T0 = t0 + (1/v).*sqrt(sum((stationlocations-guessedlocations).^2,2));
%error of model results
delta_t = noisyarrivaltimes - T0;
%linear operator on changes to model parameters (n_stations)x(m_parameters)
G = [ones(size(noisyarrivaltimes)) (stationlocations-guessedlocations)./(-v^2.*(noisyarrivaltimes-t0))];
end