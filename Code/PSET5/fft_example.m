addpath('/Users/benjamingetraer/Documents/JuniorPaper/SH_Workspace/slepian_alpha')
%% FFT for random samples
% number of samples - most efficient at N=2^a
N=256; 
% accounting to set up the plotting axis
fsize = [1 N];
ftsize = [1 N];
spun = [0 N-1];
[xfaks,~,fnx,~,xsint,~]=fftaxis(fsize,ftsize,spun);
% the samples
Xrand = rand(N,1);
% the transform
Frand = fft(Xrand);
% center it all
Fcent = fftshift(Frand);
% plot it all
figure(1)
plot(xfaks',abs(Fcent))

%% FFT for non-random samples
% the samples
X1 = [0 2 4 0 2 4 0 2 4];
% number of samples - most efficient at N=2^a
N=length(X1); 
% accounting to set up the plotting axis
fsize = [1 N];
ftsize = [1 N];
spun = [0 N-1];
[xf1,~,fnx1,~,xsint1,~]=fftaxis(fsize,ftsize,spun);
% the centered transform
F1 = fftshift(fft(X1));
% plot it all
figure(2)
subplot(2,1,1)
plot(X1)
title('original function')
subplot(2,1,2)
plot(xf1',abs(F1),'-ro')
title('fft')

%% FFT for analytical function samples
% analytical function
f=@(x) sin(2*pi*x) + sin(2*pi*2*x);
x= -1:0.01:1;
X2 = zeros(1,length(x));
for i = 1:length(x)
    X2(i) = f(x(i));
end
% number of samples - most efficient at N=2^a
N=length(X2); 
% accounting to set up the plotting axis
fsize = [1 N];
ftsize = [1 N];
spun = [0 2];
[xf2,~,fnx2,~,xsint2,~]=fftaxis(fsize,ftsize,spun);
% the centered transform
F2 = fftshift(fft(X2));
% plot it all
figure(3)
subplot(2,1,1)
plot(x,X2,x,sin(2*pi*x),x,sin(2*pi*2*x))
title('analytical function')
subplot(2,1,2)
plot(xf2',abs(F2)./length(X2),'-r')
title('fft')
xlim([-3 3])
%% fs = {1 2}, fmax = 2, NYQUIST rate 2*fmax = 4
% sample at NYQUIST rate fs = 4 -> dx = 1/fs = 0.25
dx = 0.2;
X = -2:dx:2;
Nn = length(X);
Xn = zeros(1,Nn);
for i = 1:Nn
    Xn(i) = f(X(i));
end
% accounting to set up the plotting axis
fsize = [1 Nn];
ftsize = [1 Nn];
spun = [0 4];
[xf3,~,fnx3,~,xsint3,~]=fftaxis(fsize,ftsize,spun);
% the centered transform
F3 = fftshift(fft(Xn));
% plot it all
figure(4)
subplot(2,1,1)
plot(X,Xn)
title('analytical function sampled at NYQUIST rate')
subplot(2,1,2)
plot(xf3',abs(F3)./length(Xn),'-r')
title('fft')
xlim([-3,3])

%% periodogram function
figure(5)
psdx = abs(F3(find(X==0):end)).^2*dx/Nn;
plot(xf3(find(X==0):end)',psdx)
xlim([0,3])