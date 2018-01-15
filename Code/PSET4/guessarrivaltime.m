function [ G, delta_t ] = guessarrivaltime( m0 )
%GUESSARRIVALTIME calculates the arrival time of a seismic wave based on 
%guessed incident t,x,y,z parameters. Medium velocity and detector
%locations are given by PSET4, GEO422.
%
%INPUT
%   m0      vector of [t0,x0,y0,z0] guessed parameters
%
%OUTPUT
%   G       linear operator on model differences
%   delta_t vector of error in predicted arrival times
%
%Last modified by bgetraer@princeton.edu, 11/27/2017

load geiger_student.mat
v = mediumvelocity; %siesmic wave celerity
guessedlocations = m0(2:end); %location parameters
t0 = m0(1);%time parameter
%vector of predicted arrival times based model parameters
T0 = t0 + (1/v).*sqrt(sum((stationlocations-guessedlocations).^2,2));
%error of model results
delta_t = noisyarrivaltimes - T0;
%linear operator on changes to model parameters (n_stations)x(m_parameters)
G = [ones(size(noisyarrivaltimes)) (stationlocations-guessedlocations)./(-v^2.*(noisyarrivaltimes-t0))];
end

