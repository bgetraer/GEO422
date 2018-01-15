function [PSD,X] = prdgram(sampled_signal,sample_rate)
%PRDGRAM Takes a sampled signal and returns the Power Spectral Density
%   estimate using the default parameters of PERIODGRAM, along with a 
%   length normalized X frequency variable.
%
%   See also: PERIODGRAM
[PSD,X] = periodogram(sampled_signal,rectwin(length(sampled_signal)),...
    max(256,2^nextpow2(length(sampled_signal))),sample_rate);
end