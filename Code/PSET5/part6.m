%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSET 5 --- DEAN'S DATE ASSIGNMENT ON SPECTRAL ANALYSIS --- GEO-422
%
%       5) PSD Estimate from scratch
%
% bgetraer@princeton.edu 1/16/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% some setup
addpath('/Users/benjamingetraer/Documents/JuniorPaper/SH_Workspace/slepian_alpha')
addpath('/Users/benjamingetraer/Documents/JuniorPaper/slepian_bgetraer/functions')

% load the data from decadal
%       'decadalyear','decadaldata','decadaldata_prime'
load('decadal.mat')
x = decadalyear;
f = decadaldata_prime;
dx = 10; % the sample interval

% number of points in data
N = length(f);

% physical length of data
L = diff(minmax(x));

% number of points in fft (let's stick with the default from PERIODOGRAM
Nfft = 2^nextpow2(N);

% window function
window = blackman(N);

% Fourier transform
F = fft(f.*window,Nfft);    % do the transform on the windowed function

% Power-spectral-density
F = F(1:Nfft/2+1);          % grab half
psd = (1/(Fs*N)) * abs(F).^2;   % square it, normalize it
psd(2:end-1) = 2*psd(2:end-1);  % center it, scale it 
freq = 0:Fs/Nfft:Fs/2;          % make a frequency axis
%% PLOTTING
figure(6); clf

subplot(2,2,1:2); hold on;
yyaxis left
plot(decadalyear,decadaldata)
title('\textbf{Data from \texttt{DECADAL.PLT}}','interpreter','latex')
ylabel('measurements','Interpreter','latex')
set(gca,'ylim',[-10 110],'xlim',[x(1)-2 x(end)+2],'fontsize',12)

yyaxis right
plot(x,window)
ylabel('window','Interpreter','latex')



subplot(2,2,3)
plot(freq,psd)
hold on
xlim([0 0.025])
set(gca,'TickLabelInterpreter','latex','tickdir','out','fontsize',12)
xlabel('frequency ($\frac{1}{\textrm{years}}$)','Interpreter','latex')
ylabel('PSD','Interpreter','latex')
grid on

subplot(2,2,4)
hold on
plot(log10(1./freq),psd,'linewidth',1)

xlim([log10(20),log10(1/freq_psd(1))])
xtix = [log10(20) 1.944 log10(350) log10(950) log10(2100) log10(6000)];
xlabs = strcat('$',num2str(round(10.^xtix')),'$');
set(gca,'TickLabelInterpreter','latex','tickdir','out','fontsize',12,...
   'xtick',xtix,'xticklabels',xlabs,...
   'yaxislocation','right')
xlabel('period (years) $=\frac{1}{\textrm{frequency}}$','Interpreter','latex')
ylabel('PSD','Interpreter','latex')
grid on;box on

