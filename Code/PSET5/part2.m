%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSET 5 --- DEAN'S DATE ASSIGNMENT ON SPECTRAL ANALYSIS --- GEO-422
%
%       2) Analysis of YEARLY.PLT
%
% bgetraer@princeton.edu 1/14/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% some setup
addpath('/Users/benjamingetraer/Documents/JuniorPaper/SH_Workspace/slepian_alpha')

% some useful constants
twopi = 2*pi;

% load the YEARLY data
yearly = dlmread('yearly.txt');
theyear = yearly(:,1);
thedata = yearly(:,2);

% lets do some normalization by mean and by variance
thedata_prime = (thedata-mean(thedata))/std(thedata);

% here we can do default boxcar window periodograms
[PSD_yearly,X_yearly] = prdgram(thedata_prime,1);


%% PLOT IT

f2 = figure(2); clf; 
subplot(2,1,1)
title('\textbf{Data from \texttt{yearly.plt}}','interpreter','latex')

% plot the data
yyaxis left
ylimleft = [0 200];
set(gca,'ylim',ylimleft,'xlim',[theyear(1)-2 theyear(end)+2])
hold on
plot(theyear,thedata,'linewidth',1)
xlabel('year','Interpreter','latex')
ylabel('measurements','Interpreter','latex')

% plot the normalized axes
yyaxis right
hold on
%plot(theyear,thedata_prime,'linewidth',1)
colors = get(f2,'defaultAxesColorOrder');
stdline(theyear,thedata_prime,colors(2,:));

ylimright = (ylimleft-mean(thedata))/std(thedata);
set(gca,'ylim',ylimright)
ylabels = strcat('$',get(gca,'yticklabels'),'\sigma$');
ylabels{2}='mean';
set(gca,'yticklabels',ylabels,'TickLabelInterpreter','latex','tickdir','out',...
    'fontsize',12)
ylabel('normalized measurements','Interpreter','latex')
grid on

% subplot(2,1,2)
pos2 = [0.1300    0.1100    0.775/2-0.02    0.3412];
ax2 = axes(f2,'position',pos2);
hold on
plot(X_yearly,PSD_yearly,'linewidth',1)
xlim([0,0.3])
set(gca,'TickLabelInterpreter','latex','tickdir','out','fontsize',12)
xlabel('frequency ($\frac{1}{\textrm{years}}$)','Interpreter','latex')
ylabel('PSD','Interpreter','latex')
grid on

pos2 = [0.775/2+0.1500    0.1100    0.775/2-0.02   0.3412];
ax2 = axes(f2,'position',pos2);
semilogx(1./X_yearly,PSD_yearly,'linewidth',1)
xlim([0,1/X_yearly(2)])
set(gca,'TickLabelInterpreter','latex','tickdir','out','fontsize',12,...
    'yticklabels','')
xlabel('period $=\frac{1}{\textrm{frequency}}$ (years)','Interpreter','latex')
grid on