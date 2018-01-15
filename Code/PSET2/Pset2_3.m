% Benjamin Getraer  PSET 2    GEO422
% bgetraer@princeton.edu
%% pseudorandom samples from a Normal Distribution
mu = 0; % expectation
s2 = 1; % variance
N = 1000;   % N number of samples per set
S = 1000;   % S number of sets

for i = 1:S
    z = random('norm',mu,s2,N,1);
    
    % % make a plot of the location of samples in the set
    % figure(3)
    % clf
    % grid on;hold on;
    % xlabel('the independent variable');
    % ylabel('frequency');
    %
    % % make a normalized histogram of the data
    % hist_z = histogram(z,'normalization','pdf');
    
    % bin and normalize the sample set
    [hist_values, x_edges] = histcounts(z,'normalization','pdf');
    
%     % location of bins
%     x_edges = hist_z.BinEdges;
%     % number of bins
    k = length(x_edges)-1;
    
    % set the location of the TRUE pdf
    x = x_edges(1):0.001:x_edges(end);
    GaussPdf = pdf('norm',x,mu,s2);
    
    % plot(x,GaussPdf,'linewidth',1.5);
    % xlabel('the indendent variable');
    % ylabel('frequency');
    % legend(sprintf('%i samples; %i bins',N,k),'Normal Distribution')
    % compare sample bins to the TRUE pdf
    % vector f_i of bin areas
    f_i = diff(x_edges(1:2)).*hist_values;
    clear F_i
    % vector F_i of area under the GaussPdf curve limited by bin edges
    for index = 1:k
        x_dummy_index = x>=x_edges(index) & x<=x_edges(index+1);
        F_i(index) = trapz(x(x_dummy_index), GaussPdf(x_dummy_index));
    end
    
    % % visually highlight the GaussPdf curve over a specific bin number
    % bin_no = 10;
    % for index = bin_no
    %       x_dummy_index = x>=x_edges(index) & x<=x_edges(index+1);
    % %     plot(x(x_dummy_index), GaussPdf(x_dummy_index),'k');
    % end
    
    % X^2 equation (eq. 6)
    %   requires scaling of pdf values to the actual sampling frequencies
    f_i_sc = f_i.*N;
    F_i_sc = F_i.*N;
    Chi2 = sum(((f_i_sc-F_i_sc).^2)./F_i_sc);
    
    % X^2 pdf for Gaussian distribution
    deg_freedom = k-3;
    Chi_mu = deg_freedom;
    Chi_s2 = 2*Chi_mu;
    x_chi = 0:0.1:10*Chi_s2;
    ChiPdf = chi2pdf(x_chi,deg_freedom);

    
    % figure(4)
    % clf
    % hold on;
    % plot the X^2 value from our sample
    [c index] = min(abs(x_chi-Chi2));
    
    % p3 = fill([x_chi(index) x_chi(index:end)],[0 ChiPdf(index:end)],'b');
    % p2 = line([Chi2 Chi2],[0 ChiPdf(index)],'color','r','linewidth',2);
    % p1 = plot(x_chi, ChiPdf,'k','linewidth',2);
    % xlabel('\chi^2'); ylabel('probability density');
    % xlim([0 60]);
    % legend([p1 p2 p3],sprintf('\\chi^2_{%i} probability density function',deg_freedom),...
    %     'a \chi^2 value for a population',...
    %     'probability of exceeding observed \chi^2 value');
    
    % The test:
    % reject samples with X^2 values of more than 10X the variance
    if index == length(x_chi), pass(i)=0;
    else
        % probability of exceeding observed chi^2 value
        p = trapz(x_chi(index:end),ChiPdf(index:end));
        % acceptable confidence level (threshold for passing test)
        alpha = 0.20;
        if p > alpha, pass(i) = 1;else pass(i) = 0; end
    end
end
%%
percent_passed = sum(pass)/S