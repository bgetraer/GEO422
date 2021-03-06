%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSET 5 --- DEAN'S DATE ASSIGNMENT ON SPECTRAL ANALYSIS --- GEO-422
%
%       2) Analysis of YEARLY.PLT
%
% bgetraer@princeton.edu 1/14/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% some setup
addpath('/Users/benjamingetraer/Documents/JuniorPaper/SH_Workspace/slepian_alpha')
addpath('/Users/benjamingetraer/Documents/JuniorPaper/slepian_bgetraer/functions')

% load the YEARLY data
yearly = dlmread('yearly.txt');
yearlyyear = yearly(:,1);
yearlydata = yearly(:,2);

% lets do some normalization by mean and by variance
yearlydata_prime = (yearlydata-mean(yearlydata))/std(yearlydata);

% here we can do default boxcar window periodograms
[PSD_yearly,X_yearly] = prdgram(yearlydata_prime,1);

save('yearly','yearlyyear','yearlydata','yearlydata_prime')
%% PLOTTING

f2 = figure(2); clf; 
subplot(2,1,1)
title('\textbf{Data from \texttt{YEARLY.PLT}}','interpreter','latex')

% plot the data
yyaxis left
ylimleft = [0 200];
set(gca,'ylim',ylimleft,'xlim',[yearlyyear(1)-2 yearlyyear(end)+2])
hold on
plot(yearlyyear,yearlydata,'linewidth',1)
ylabel('measurements','Interpreter','latex')

% plot the normalized axes
yyaxis right
hold on
%plot(theyear,thedata_prime,'linewidth',1)
colors = get(f2,'defaultAxesColorOrder');
stdline(yearlyyear,yearlydata_prime,colors(2,:));

ylimright = (ylimleft-mean(yearlydata))/std(yearlydata);
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
plot(log10(1./X_yearly),PSD_yearly,'linewidth',1)
xlim([0,log10(1/X_yearly(2))])
set(gca,'TickLabelInterpreter','latex','tickdir','out','fontsize',12,...
    'xtick',[0 1 2],'xticklabels',{'0';'$10^{1}$';'$10^{2}$'},...
    'yaxislocation','right')
xlabel('period (years) $=\frac{1}{\textrm{frequency}}$','Interpreter','latex')
ylabel('PSD','Interpreter','latex')
grid on;box off