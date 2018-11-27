function [A,M] = assemble_vec(p,t,pb,K)

% based on code from ifem by Long Chen. 

n = size(p,1); m = size(t,1);

% gradients of shape functions
v1 = p(t(:,3),:)-p(t(:,2),:);
v2 = p(t(:,1),:)-p(t(:,3),:);
v3 = p(t(:,2),:)-p(t(:,1),:);
area = 0.5*(-v3(:,1).*v2(:,2) + v3(:,2).*v2(:,1));       % areas of triangles
dphi(:,:,3) = [-v3(:,2)./(2*area), v3(:,1)./(2*area)];
dphi(:,:,1) = [-v1(:,2)./(2*area), v1(:,1)./(2*area)];
dphi(:,:,2) = [-v2(:,2)./(2*area), v2(:,1)./(2*area)];
area = abs(area);

% assembly
A = sparse(n,n); M = sparse(n,n);
for i = 1:3
    for j = i:3
        Aij = -area.*(dphi(:,1,i).*K(:,1).*dphi(:,1,j) ...
                    + dphi(:,1,i).*K(:,2).*dphi(:,2,j) ...
                    + dphi(:,2,i).*K(:,2).*dphi(:,1,j) ...
                    + dphi(:,2,i).*K(:,3).*dphi(:,2,j));
        Mij = area/12.*ones(size(dphi,1),1);
        I = pb(t(:,i),2); J = pb(t(:,j),2);
        if (j==i)
            A = A + sparse(I,J,Aij,n,n);
            M = M + sparse(I,J,Mij+area/12,n,n);
        else
            A = A + sparse([I;J],[J;I],[Aij; Aij],n,n);   
            M = M + sparse([I;J],[J;I],[Mij; Mij],n,n);
        end        
    end
end


