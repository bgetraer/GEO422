%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSET 5 --- DEAN'S DATE ASSIGNMENT ON SPECTRAL ANALYSIS --- GEO-422
%
%       4) Windowing
%
% bgetraer@princeton.edu 1/15/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% some setup
addpath('/Users/benjamingetraer/Documents/JuniorPaper/SH_Workspace/slepian_alpha')
addpath('/Users/benjamingetraer/Documents/JuniorPaper/slepian_bgetraer/functions')

% load the data from yearly
%       'yearlyyear' 'yearlydata' 'yearlydata_prime'
load('yearly.mat')

% choose the data
x = yearlyyear;
f = yearlydata;
f_prime = yearlydata_prime;

% use different window functions
windowtype = {'rectwin';'bartlett';'blackman';'hann'};
windowlabel = strcat('\textbf{',{'box-car';'Bartlett';'Blackman';'Hann'},'}');

figure(4); clf;

subplot(length(windowtype)+1,2,1:2); hold on;
plot(x,f)
title('\textbf{Data from \texttt{YEARLY.PLT}}','interpreter','latex')
ylabel('measurements','Interpreter','latex')
set(gca,'ylim',[0 200],'xlim',[x(1)-2 x(end)+2],'fontsize',12)

for i = 1:length(windowtype)
    % get the PSD and the window
    [PSD,X,thiswindow] = prdgram(f_prime,1,windowtype{i});
    
    % plot the window
    subplot(length(windowtype)+1,2,3+2*(i-1)); hold on;
    plot(x,f_prime)
    plot(x,thiswindow)
    axis('tight')
    xlabel('\rm{x}','interpreter','latex')
    ylabel('f(\rm{x})','interpreter','latex')
    text(mean(x),3,windowlabel{i},'interpreter','latex','horizontalalignment','center','fontsize',12)
    set(gca,'xtick','','fontsize',12)
    
    % plot the PSD
    subplot(length(windowtype)+1,2,4+2*(i-1));hold on;
    plot(X,PSD)
    axis([0 0.2 0 65])
    xlabel('freq.','interpreter','latex')
    ylabel('PSD','interpreter','latex')
    set(gca,'fontsize',12)
end

%%
f5 = figure(5); clf;
for i = 1:length(windowtype)
    % get the window
    thiswindow = eval(strcat(windowtype{i},'(1000)'));
    
    % plot the window
    subplot(length(windowtype),2,1+2*(i-1)); hold on;
    plot(linspace(-1,1,1000),thiswindow)
    set(gca,'ylim',[0 1.1],'xlim',[-1 1],'fontsize',12)
    xlabel('\rm{x}','interpreter','latex')
    ylabel('f(\rm{x})','interpreter','latex')
    text(0,0.3,windowlabel{i},'interpreter','latex','horizontalalignment','center','fontsize',12)
    set(gca,'xtick','','fontsize',12)
    % plot the PSD
    subplot(length(windowtype),2,2+2*(i-1));hold on;
    [PSD,X] = prdgram(thiswindow,1);
    plot(X,log10(PSD))
    axis('tight')
    xlabel('freq.','interpreter','latex')
    ylabel('$\log_{10}$(PSD)','interpreter','latex')
    set(gca,'fontsize',12)
end
axes(f5,'position',[0.1300 0.1100 0.7750 0.82])
title('\textbf{Windowing Function Examples}','interpreter','latex','fontsize',14);
axis off

% BARTLETT, BLACKMAN, CHEBWIN, HAMMING, HANN, KAISER.