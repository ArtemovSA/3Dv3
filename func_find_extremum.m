%Autor: Artemov Sergei
%Date: 12.12.2015
%**************************************************************************
%*****Input varibles:*****
%XYZ - input point matrix
%beat_n - beat number
%start_point, end_point - start and end point in matrix XYZ
%axes - 'X','Y','Z','M' - type of input data X,Y,Z and Magnitude
%peaks_count - count of peaks
%peaks_dist -distance between peaks
%*****Output varibles:*****
%pks - vilue peaks
%locs - position peaks
%**************************************************************************

function [pks,locs] = func_find_extremum (XYZ, beat_n, start_point, end_point, axes, peaks_count, peaks_dist)

    %Filter parametrs
    windowSize = 10;
    b = (1/windowSize)*ones(1,windowSize); %Numerator coefficients of rational transfer function
    a = 1; %Denominator coefficients of rational transfer function

    switch (axes)
        case {'X'}
            data_X = abs(XYZ(beat_n,start_point:end_point,1));
            data_X_f = filter(b,a,data_X);
            [pks,locs] = findpeaks(data_X_f,'SORTSTR','descend','MINPEAKDISTANCE',peaks_dist,'NPEAKS', peaks_count);
        case {'Y'}
            data_Y = abs(XYZ(beat_n,start_point:end_point,2));
            data_Y_f = filter(b,a,data_Y);
            [pks,locs] = findpeaks(data_Y_f,'SORTSTR','descend','MINPEAKDISTANCE',peaks_dist,'NPEAKS', peaks_count);
        case {'Z'}
            data_Z = abs(XYZ(beat_n,start_point:end_point,3));
            data_Z_f = filter(b,a,data_Z);
            [pks,locs] = findpeaks(data_Z_f,'SORTSTR','descend','MINPEAKDISTANCE',peaks_dist,'NPEAKS', peaks_count);
        case {'M'}
            data_X = abs(XYZ(1,start_point:end_point,1));
            data_Y = abs(XYZ(1,start_point:end_point,2));
            data_Z = abs(XYZ(1,start_point:end_point,3));
            magnitude = (data_X.^2 + data_Y.*data_Y + data_Z.*data_Z).^(0.5);
            magnitude_f = filter(b,a,magnitude);
            [pks,locs] = findpeaks(magnitude_f,'SORTSTR','descend','MINPEAKDISTANCE',peaks_dist,'NPEAKS', peaks_count);
    end

