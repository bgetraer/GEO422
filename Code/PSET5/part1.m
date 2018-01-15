%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSET 5 --- DEAN'S DATE ASSIGNMENT ON SPECTRAL ANALYSIS --- GEO-422
%
%       1) NYQUIST SAMPLING
%
% bgetraer@princeton.edu 1/14/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% some setup
addpath('/Users/benjamingetraer/Documents/JuniorPaper/SH_Workspace/slepian_alpha')

% some useful constants
twopi = 2*pi;
%% PART ONE NYQUIST SAMPLING

% an example of a signal of known analytical function
thefrequencies = [1 2 5.6];
f1 = @(x) cos(twopi*thefrequencies(1)*x);
f2 = @(x) sin(twopi*thefrequencies(2)*x);
f3 = @(x) sin(twopi*thefrequencies(3)*x);
% the signal!
x= -1:0.001:1;
f = f1(x) + f2(x) + f3(x);


% Let's sample the signal

% Nyquist rate is 2*fmax
NQrate = 2*max(thefrequencies);
lowrate = NQrate/2;
highrate = NQrate*2;

xNQ = -1:1/NQrate:1;
xlow = -1:1/lowrate:1;
xhigh = -1:1/highrate:1;

fNQ = f1(xNQ) + f2(xNQ) + f3(xNQ);
flow = f1(xlow) + f2(xlow) + f3(xlow);
fhigh = f1(xhigh) + f2(xhigh) + f3(xhigh);

% Periodograms of the sampled signal, using default boxcar window
% use my function prdgram to return normalized x axis as well

[PSD_NQ,X_NQ] = prdgram(fNQ,NQrate);
[PSD_low,X_low] = prdgram(flow,lowrate);
[PSD_high,X_high] = prdgram(fhigh,highrate);

%% plot the sampling examples
fig1 = figure(1);
clf
subplot(2,3,1); hold on;
plot(x,f)
hlow = plot(xlow,flow,'.','markersize',12);
plot(xlow,flow,'-','linewidth',1,'color',hlow.Color)
title('\bf{ $\mathbf{\frac{1}{2}\times}$ Nyquist Sampling}','interpreter','latex')
xlabel('$\rm{x}$','interpreter','latex');ylabel('$f(\rm{x})$','interpreter','latex')
grid on
set(gca,'fontsize',12)

subplot(2,3,2); hold on;
plot(x,f)
hNQ = plot(xNQ,fNQ,'.','markersize',12);
plot(xNQ,fNQ,'-','linewidth',1,'color',hNQ.Color)
title('\textbf{ Nyquist Sampling}','interpreter','latex')
xlabel('$\rm{x}$','interpreter','latex');ylabel('$f(\rm{x})$','interpreter','latex')
grid on
set(gca,'fontsize',12)

subplot(2,3,3); hold on;
plot(x,f)
hhigh = plot(xhigh,fhigh,'.','markersize',12);
plot(xhigh,fhigh,'-','linewidth',1,'color',hhigh.Color)
title('\textbf{ $\mathbf{2\times}$ Nyquist Sampling}','interpreter','latex')
xlabel('$\rm{x}$','interpreter','latex');ylabel('$f(\rm{x})$','interpreter','latex')
grid on
set(gca,'fontsize',12)

subplot(2,3,4); hold on;
axis([0 6 0 2]);
vline(thefrequencies, ylim,'--');
plot(X_low,PSD_low,'linewidth',1.5)
xlabel('$frequency$','interpreter','latex');ylabel('PSD','interpreter','latex')
grid on
set(gca,'fontsize',12)

subplot(2,3,5); hold on;
axis([0 6 0 2]);
vline(thefrequencies, ylim,'--');
plot(X_NQ,PSD_NQ,'linewidth',1.5)
xlabel('$frequency$','interpreter','latex');ylabel('PSD','interpreter','latex')
grid on
set(gca,'fontsize',12)

subplot(2,3,6); hold on;
axis([0 max(X_high) 0 1.2]);
vline(thefrequencies, ylim,'--');
plot(X_high,PSD_high,'linewidth',1.5)
xlabel('$frequency$','interpreter','latex');ylabel('PSD','interpreter','latex')
grid on
set(gca,'fontsize',12)

%% 
%% FUNCTIONS

function [PSD,X] = prdgram(sampled_signal,sample_rate)
%PRDGRAM Takes a sampled signal and returns the Power Spectral Density
%   estimate using the default parameters of PERIODGRAM, along with a 
%   length normalized X frequency variable.
%
%   See also: PERIODGRAM
[PSD,X] = periodogram(sampled_signal,rectwin(length(sampled_signal)),...
    max(256,2^nextpow2(length(sampled_signal))),sample_rate);
end

function [vline_handle] = vline(x_values,ylimit,style)
%VLINE Plots vertical lines at given values of x for a given ylimit
%

defval('style','-')

% put in form [x1 x1 nan nan x2 x2 nan nan etc]
x1 = [x_values; nan(1,length(x_values))]; 
x2 = [x1(:)';x1(:)'];
X = x2(:);

% put in form [y1 y2 nan nan y1 y2 nan nan etc]
Y = repmat([ylimit nan nan],1,length(x_values));

vline_handle = plot(X,Y,style);
end
