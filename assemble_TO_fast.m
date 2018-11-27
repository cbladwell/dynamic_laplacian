function [A,M,Phi] = assemble_fast(p,t,pb)

% A and M for any mesh of triangles: linear phi's
% p lists x,y coordinates of N nodes
% t lists triangles by 3 node numbers
% pb maps node numbers to realize periodic boundary conditions

n = max(pb(:,2));                   % number of nodes (periodic boundary)
m = size(t,1);                      % number of triangles
I = zeros(9*m,1); J = I; As = I; Ms = I;

for e = 1:m                         % integration over each element (triangle)
    ns = t(e,1:3);                    % nodes of triangle e
    Pe = [ones(3,1),p(ns,:)];       % 3 x 3 matrix with rows = [1 xnode ynode]
    area = abs(det(Pe))/2;          % area of triangle e
    B = inv(Pe);                    % columns of C are coeffs in a+bx+cy to give phi=1,0,0 at nodes
    Phi{e} = B';
    grad = B(2:3,:);
    Ae = area*grad'*grad;           % element matrix from slopes b,c in grad
    Me = area*(1/12)*(ones(3,3)+eye(3));   % mass matrix (scaled integrals from reference triangle)

    nsp = pb(ns,2)';   ind = (e-1)*9+1:e*9;
    I(ind) = repmat(nsp,1,3); 
    J(ind) = reshape(repmat(nsp,3,1),1,9);
    As(ind,:) = -reshape(Ae,9,1); 
    Ms(ind,:) = reshape(Me,9,1);
end
A = sparse(I,J,As,n,n);
M = sparse(I,J,Ms,n,n);
