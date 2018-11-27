% script to triangulate points from trajectory data
% trajectory data needs to be in a cell array 'p'
% each cell of p corresponds to a time step (month) of the flow
% each cell contains the X and Y points of a float at this time step
% ie a trajectory point in 2D

%% add paths
% update these
addpath('C:\Users\Toff\Documents\uni\HonoursResearch\Code\Data');
addpath('..\data'); % path to data file

%% setup
nt = 36;
alphaval = 9*ones(1,nt);

%%  triangulation

xmax=max(p{1}(:, 1));
xmin=min(p{1}(:, 1));
ymax=max(p{1}(:, 2));
ymin=min(p{1}(:, 2));
dx = xmax-xmin; dy = ymax-ymin;

r = find(~isnan(p{1}(:, 1)));
n=size(p{1}(r,1),1);
p0=[p{1}(r, 1) p{1}(r,2)];
pb = [1:n; 1:n]';
tri = alphaShape(p0(:,1),p0(:,2),alphaval(1));
b = unique(boundaryFacets(tri)); 

%% assembly sparse
n=size(p{1}(:,1),1);
tic; D = sparse(n,n); M = sparse(n,n); pm = 1; 
for k = 1:nt
    r = find(~isnan(p{k}(:, 1)));
    tr = delaunay(p{k}(r,:));
    tri = alphaShape(p{k}(r, 1),p{k}(r, 2),alphaval(k));
    tr = alphaTriangulation(tri);
    t = [r(tr(:,1)), r(tr(:,2)), r(tr(:,3))];
    n=size(p{k}(:,1),1);
    pb = [1:n; 1:n]';
    [Dt{k}, Mt{k}] = assemble(p{k},t,pb,kron([1 0 1],ones(size(t,1),1)));
    D = D + Dt{k}; M = M + Mt{k}; %nnz(Dt)/2
end; toc

%% remove all zero rows and columns
S = sum(abs(D));
I = find(abs(S)>eps); size(I);
D = D(I,I); M = M(I,I); pI = p{1}(I,:); pbI = [1:size(pI,1); 1:size(pI,1)]';
pI2=p{nt}(I,:);pbI2=[1:size(pI2,1); 1:size(pI2,1)]';
pImid=p{floor(nt/2)}(I,:);pbImid=[1:size(pImid,1); 1:size(pImid,1)]';

%% eigenproblem
tic; [V,L] = eigs(D,M,20,'SM'); toc
[lam,order] = sort(diag(L),'descend'); V = V(:,order);

%% plot spectrum
figure(1); clf; plot(lam,'.', 'MarkerSize',8); axis tight
% figure(1); clf; plot(lam,'s','markerfacecolor','b'); axis tight
xlabel('$k$','Interpreter','latex'); ylabel('$\lambda_k$', 'Interpreter','latex')

%% plot eigenvectors

% set important spectrum
important_spectrum = 9;
plot_eigs(pI, pbI, V, alphaval, important_spectrum);


