% Benjamin Getraer  PSET 2    GEO422
% bgetraer@princeton.edu
%% PART I
% Demonstration of "Central Limit Theorem" through convolution of uniform
% probability density functions of multiple independent random variables.

% the number of convolutions to perform
N = 30;

% the cell array of random variable x for 0:N convolutions and its interval
interval = 0.1;
x = cell(1,N+1);
x{1} = [0 0:interval:1 1];

% probability density function f
%   uniform over domain 0:1
f = [0 ones(1,length(x{1})-2) 0];

% the cell array of pdf's z of 0:N convolutions
z = cell(1,N+1);
z{1} = [0 ones(1,length(x{1})-2) 0];

for i = 1:N+1
    % normalize the pdf z st the area under the curve is 1
    z{i} = z{i}./trapz(x{i},z{i});
    % the expectation of z
    mu(i) = trapz(x{i},z{i}.*x{i});
    % the variance of z
    s2(i) = trapz(x{i},z{i}.*(x{i}-mu(i)).^2);
    % rescale pdf normalized by exp. and var.
    x{i} = (x{i}-mu(i))./sqrt(s2(i));
    % normalize the rescaled pdf z st the area under the curve is 1
    z{i} = z{i}./trapz(x{i},z{i});
    
    % convolve the cumulative distribution function z
    % with the uniform pdf f
    z{i+1} = conv(f,z{i});
    % redefine the indendent variable x to reflect the 
    % cumulative possible values after convolution
    x{i+1} = (0:length(z{i+1})-1).*interval;
end

% normalize thelast pdf z st the area under the curve is 1
z{i} = z{i}./trapz(x{i},z{i});
% the expectation of z
mu(i) = trapz(x{i},z{i}.*x{i});
% the variance of z
s2(i) = trapz(x{i},z{i}.*(x{i}-mu(i)).^2);
% rescale pdf normalized by exp. and var.
x{i} = (x{i}-mu(i))./sqrt(s2(i));
% normalize the rescaled pdf z st the area under the curve is 1
z{i} = z{i}./trapz(x{i},z{i});

% plot the pdf z{i} where i is the #covolutions+1 
%   against the independent variable, and compare to Gaussian pdf
figure(1);
conv_index = [0 1 5 30];
for loop_index = 1:length(conv_index)
    Nconv = conv_index(loop_index)+1;
    subplot(2,2,loop_index); hold on; grid on;
    if Nconv~=2,plural_exception ='s'; 
    else plural_exception =''; end
    title(sprintf('%i Convolution%s',Nconv-1,plural_exception));
    xlabel('the random variable');
    ylabel('the probability density distribution');
    ylim([0,0.5]);
    xlim([-5,5]);
    % plot the location of the Gaussian pdf
    x_pdf = -5:0.1:5;
    plot(x_pdf,pdf('norm',x_pdf,0,1),'k','linewidth',2);
    % plot the location of the convolved pdf
    plot(x{Nconv},z{Nconv},'r','linewidth',2);
    
    if loop_index==1,legend('convolved pdf','Gaussian pdf','location',...
            'Northwest');end

end