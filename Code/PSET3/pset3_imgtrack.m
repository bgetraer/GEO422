function [ty_coord xy_coord] = pset3_imgtrack(photo_num,frame_rate)
%PSET3_IMGTRACK
%   Loads images from geoweb.princeton.edu webpage of a tossed
%   golf ball, using the index provided, and allows manual selection of
%   location coordinates.
%       WEBPAGE:
%       http://geoweb.princeton.edu/people/simons/GOLFBALL/000000??.jpg
%
%       photo_num is an index array of the desired images.
%           all entries must be integers between 1 and 71.
%
%       coordinates is a two column array (x,y) describing the locations
%           manually selected using ginput.
% bgetraer@princeton.edu
% Nov. 2017

% ERROR MESSAGES
if sum(photo_num<1 | photo_num>71)~=0, ...
        error('elements [%s] of image index are non-existent webpages',...
        num2str(find(photo_num<1 | photo_num>71)));
end

if ~issorted(photo_num,'ascend'), ...
        error('image index is not in ascending order');
end

% MAIN LOOP runs through photo index
for image_index = photo_num
    % locate the photo
    web_address = sprintf('http://geoweb.princeton.edu/people/simons/GOLFBALL/000000%2.2i.jpg', ...
        image_index);
    % store the photo
    X = imread(web_address);
    % show the photo
    figure(1)
    image(X)
    xlabel('horizontal [pixel]')
    ylabel('vertical [pixel]')
    title(sprintf('Image #%2.2i',image_index))
    % running index
    frame_index = find(photo_num == image_index);
    % manually track an object in each
    xy_coord(frame_index,1:2) = ginput(1);
    % transform into height vs time array
    ty_coord(frame_index,1:2) = [frame_index/frame_rate xy_coord(frame_index,2)];
    %pause(0.1)
end
close(gcf)
end