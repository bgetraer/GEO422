% Benjamin Getraer  PSET 2    GEO422
% bgetraer@princeton.edu
%% PART II
% Demonstration of "Central Limit Theorem" through convolution of non-
% uniform probability density functions of multiple independent random 
% variables.

% a semi-circle
x1 = 0:0.01:1;
a = sqrt((1/2)^2-(x1-1/2).^2);
a = a./trapz(x1,a);

% a step
x2 = [0 0:3 3:6 6];
b = [0 4 4 4 4 8 8 8 8 0];
b = b./trapz(x2,b);

% an exponential
x3 = 0:0.01:5;
c = exp(x3)-1;
c = c./trapz(x3,c);

% a house
x4 = [0 0:5 5 6 6 7 7];
d = [0 4 4.5 5 5.5 6 5.33 6.25 6.25 4.66 4 0];
d = d./trapz(x4,d);

%% ex: 1 a semi-circle and a step
N = 10; % number of convolutions
z = b; % start with step
for i = 1:N
    % switch off btwn convolving with semi-circle and step
    if rem(i,2)
        f = a;
    else
        f = b;
    end
    % convolve the cumulative distribution function z
    % with the pdf f
    z = conv(f,z);
end
% create x-axis
x_z = (0:length(z)-1).*0.1;
% normalize area of z
z = z./trapz(x_z,z);
% expectation of z
mu = trapz(x_z,z.*x_z);
% variance of z
s2 = trapz(x_z,z.*(x_z-mu).^2);

% plot the results
figure(2)
subplot(1,3,1); hold on; grid on;
plot(x1,a,'r','linewidth',2)
xlabel('the random variable');
ylabel('probability density distribution a');

subplot(1,3,2); hold on; grid on;
plot(x2,b,'r','linewidth',2)
xlabel('the random variable');
ylabel('probability density distribution b');

subplot(1,3,3); hold on; grid on;
plot(x_z,pdf('norm',x_z,mu,sqrt(s2)),'k','linewidth',2);
plot(x_z,z,'r','linewidth',1.5);
xlim([x_z(1),x_z(end)]);
xlabel('the random variable');
ylabel('the probability density distribution');
legend('Gaussian pdf',sprintf('%i convolutions of a and b',N),'location','South');

%% ex: 2 a house and an exponential
N = 100; % number of convolutions
z = c; % start with step
for i = 1:N
    % switch off btwn convolving with semi-circle and step
    if rem(i,2)
        f = d;
    else
        f = c;
    end
    % convolve the cumulative distribution function z
    % with the pdf f
    z = conv(f,z);
end
% create x-axis
x_z = (0:length(z)-1).*0.1;
% normalize area of z
z = z./trapz(x_z,z);
% expectation of z
mu = trapz(x_z,z.*x_z);
% variance of z
s2 = trapz(x_z,z.*(x_z-mu).^2);

% plot the results
figure(2)
subplot(1,3,1); hold on; grid on;
plot(x3,c,'r','linewidth',2)
xlabel('the random variable');
ylabel('probability density distribution c');
xlim([x3(1),x3(end)]);

subplot(1,3,2); hold on; grid on;
plot(x4,d,'r','linewidth',2)
xlabel('the random variable');
ylabel('probability density distribution d');
xlim([x4(1),x4(end)]);

subplot(1,3,3); hold on; grid on;
plot(x_z,pdf('norm',x_z,mu,sqrt(s2)),'k','linewidth',2);
plot(x_z,z,'r','linewidth',1.5);
xlim([x_z(1),x_z(end)]);
xlabel('the random variable');
ylabel('the probability density distribution');
legend('Gaussian pdf',sprintf('%i convolutions of a and b',N),'location','South');