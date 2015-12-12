function [mdl] = func_non_leniar_plane_weidth(handle_in, XYZ, beat_n, start_point, end_point)

    X1 =(XYZ(beat_n,start_point:end_point,3))';
    X2 =(XYZ(beat_n,start_point:end_point,1))';
    X3 =(XYZ(beat_n,start_point:end_point,2))';

    X = [ones(size(X1)) X1 X2 X1.*X2];
    w = ((X1.^2)+(X2.^2)+(X3.^2)).^(0.5);

    mdl = fitlm(X,X3,'linear','Weights',w);
    scatter3(handle_in,X1,X2,X3,'filled')
    hold(handle_in,'on');
    
    x1fit = min(X1):100:max(X1);
    x2fit = min(X2):100:max(X2);
    [X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
    YFIT = table2array(mdl.Coefficients('x1','Estimate')) + table2array(mdl.Coefficients('x2','Estimate'))*X1FIT + table2array(mdl.Coefficients('x3','Estimate'))*X2FIT +table2array(mdl.Coefficients('x4','Estimate'))*X1FIT.*X2FIT;
    
    mesh(handle_in,X1FIT,X2FIT,YFIT);
    surfnorm(handle_in,X1FIT,X2FIT,YFIT);