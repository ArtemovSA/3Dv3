function [b] = func_non_leniar_plane(handle_in, XYZ, beat_n, start_point, end_point)

    X1 =(XYZ(beat_n,start_point:end_point,1))';
    X2 =(XYZ(beat_n,start_point:end_point,2))';
    X3 =(XYZ(beat_n,start_point:end_point,3))';
    X = [ones(size(X1)) X1 X2 X1.*X2];
    
    b = regress(X3,X);
    
    scatter3(handle_in,X1,X2,X3,'filled');
    hold(handle_in,'on');
    
    x1fit = min(X1):100:max(X1);
    x2fit = min(X2):100:max(X2);
    [X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
    YFIT = b(1) + b(2)*X1FIT + b(3)*X2FIT + b(4)*X1FIT.*X2FIT;
    
    mesh(handle_in,X1FIT,X2FIT,YFIT);
    surfnorm(handle_in,X1FIT,X2FIT,YFIT);