%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSET 5 --- DEAN'S DATE ASSIGNMENT ON SPECTRAL ANALYSIS --- GEO-422
%
%       3) Analysis of DECADAL.PLT
%
% bgetraer@princeton.edu 1/14/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% some setup
addpath('/Users/benjamingetraer/Documents/JuniorPaper/SH_Workspace/slepian_alpha')
addpath('/Users/benjamingetraer/Documents/JuniorPaper/slepian_bgetraer/functions')

% load the YEARLY data
decadal = dlmread('decadal.txt');
decadalyear = 1950-decadal(:,1);
decadaldata = decadal(:,2);
decadalerror = decadal(:,3);

% lets do some normalization by mean and by variance
decadaldata_prime = (decadaldata-mean(decadaldata))/std(decadaldata);

% here we can do default boxcar window periodograms
[PSD_decadal,X_decadal] = prdgram(decadaldata_prime,1/10);

save('decadal','decadalyear','decadaldata','decadaldata_prime')
%% PLOTTING

f3 = figure(2); clf; 
subplot(2,1,1)
title('\textbf{Data from \texttt{DECADAL.PLT}}','interpreter','latex')

% plot the data
yyaxis left
ylimleft = [-20 120];
set(gca,'ylim',ylimleft,'xlim',[decadalyear(1)-2 decadalyear(end)+2])
hold on
plot(decadalyear,decadaldata,'linewidth',1)
ylabel('measurements','Interpreter','latex')

% plot the normalized axes
yyaxis right
hold on
%plot(theyear,thedata_prime,'linewidth',1)
colors = get(f3,'defaultAxesColorOrder');
stdline(decadalyear,decadaldata_prime,colors(2,:));

ylimright = (ylimleft-mean(decadaldata))/std(decadaldata);
set(gca,'ylim',ylimright)
ylabels = strcat('$',get(gca,'yticklabels'),'\sigma$');
ylabels{2}='mean';
set(gca,'yticklabels',ylabels,'TickLabelInterpreter','latex','tickdir','out',...
    'fontsize',12)
ylabel('normalized measurements','Interpreter','latex')
grid on

% subplot(2,1,2)
pos2 = [0.1300    0.1100    0.775/2-0.02    0.3412];
ax2 = axes(f3,'position',pos2);
hold on
plot(X_decadal,PSD_decadal,'linewidth',1)
xlim([0,0.015])
set(gca,'TickLabelInterpreter','latex','tickdir','out','fontsize',12)
xlabel('frequency ($\frac{1}{\textrm{years}}$)','Interpreter','latex')
ylabel('PSD','Interpreter','latex')
grid on

pos2 = [0.775/2+0.1500    0.1100    0.775/2-0.02   0.3412];
ax2 = axes(f3,'position',pos2);

plot(log10(1./X_decadal),PSD_decadal,'linewidth',1)
xlim([log10(20),log10(1/X_decadal(1))])
xtix = [log10(20) 2 2.72 3 3.36 3.834];
xlabs = strcat('$',num2str(round(10.^xtix')),'$');
set(gca,'TickLabelInterpreter','latex','tickdir','out','fontsize',12,...
    'xtick',xtix,'xticklabels',xlabs,...
    'yaxislocation','right')
xlabel('period (years) $=\frac{1}{\textrm{frequency}}$','Interpreter','latex')
ylabel('PSD','Interpreter','latex')
grid on;box off