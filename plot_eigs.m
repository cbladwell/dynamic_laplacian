function plot_eigs(pI, pbI, V, alphaval, imprt_sp)
    
    % Arguments:
    %   pI: subset of the non zero
    clf; colormap default; colormap jet
    [m,q] = plot_shp(imprt_sp); % for shape of sub plots
    r = ~isnan(pI(:, 1));
    [C,IA,IC] = unique(pI,'rows','stable');
    x = setdiff((1:size(r,1))', IA);
    r(x) = 0;
    tri = alphaShape(pI(r,1),pI(r,2),alphaval(1)); tr = alphaTriangulation(tri);
    for j = 1:imprt_sp,
        subplot(q,m,j);
        plotev(tr,pI(r, :),pbI(r,:),-V(:,j),0);  
        xlabel('lon ($^\circ$)', 'Interpreter','latex'); ylabel('lat ($^\circ$)', 'Interpreter','latex'); 
        %axis equal; axis([xmin xmax ymin ymax]); colorbar
        axis on
    end
end
    
    