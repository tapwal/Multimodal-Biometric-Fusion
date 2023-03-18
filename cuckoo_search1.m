function [bestnest,fmin]=cuckoo_search(n,score)
% rand('state',0);
if nargin<1,
% Number of nests (or different solutions)
n=100;
end
% Discovery rate of alien eggs/solutions
pa=0.6;
%% Change this if you want to get better results
%  Tolerance
% if score<=0.5
%     Tol=0.001; %0.43
% else
    Tol = 0.098;
% end
%% Simple bounds of the search domain
% Lower bounds
rand('state',0);

nd=1;

Lb=0.6*ones(1,nd);%0.6
% Upper bounds
Ub=1.6*ones(1,nd);%1.6
% Random initial solutions
pop = Lb+(Ub-Lb)*rand([n,1]);
nest = score*pop;
% Get the current best
for f = 1:n
fitness(f,1) = fobj(nest(:,1),f);
end
[fmin,bestnest,nest,fitness]=get_best_nest(nest,nest,fitness);
N_iter=0;
%% Starting iterations
while (fmin>Tol)
% Generate new solutions (but keep the current best)
new_nest=get_cuckoos(nest,bestnest,Lb,Ub);
[fnew,best,nest,fitness]=get_best_nest(nest,new_nest,fitness);
% Update the counter
N_iter=N_iter+1;
% Discovery and randomization
new_nest=empty_nests(nest,Lb,Ub,pa) ;
% Evaluate this set of solutions
[fnew,best,nest,fitness]=get_best_nest(nest,new_nest,fitness);
% Update the counter again
N_iter=N_iter+1;
% Find the best objective so far
if fnew<fmin,
fmin=fnew;
bestnest=best;

end
if N_iter >= 100
    break;
end
end %% End of iterations
%% Post-optimization processing
%% Display all the nests
disp(strcat(['Total number of iterations' num2str(N_iter)]));
%% --------------- All subfunctions are list below ------------------
%% Get cuckoos by ramdom walk
function nest=get_cuckoos(nest,best,Lb,Ub)
% Levy flights
n=size(nest,1);
% Levy exponent and coefficient
% For details, see equation (2.21), Page 16 (chapter 2) of the book
% X. S. Yang, Nature-Inspired Metaheuristic Algorithms, 2nd Edition, Luniver Press, (2010).
beta=3/2;
sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
for j=1:n,
s=nest(j,:);
% This is a simple way of implementing Levy flights
% For standard random walks, use step=1;
%% Levy flights by Mantegna’s algorithm
%randn('state',0);
u=randn(size(s))*sigma;
v=randn(size(s));
step=u./abs(v).^(1/beta);
% In the next equation, the difference factor (s-best) means that
% when the solution is the best solution, it remains unchanged.
stepsize=0.03*step.*(s-best);
% Here the factor 0.01 comes from the fact that L/100 should the typical
% step size of walks/flights where L is the typical lenghtscale;
% otherwise, Levy flights may become too aggresive/efficient,
% which makes new solutions (even) jump out side of the design domain
% (and thus wasting evaluations).
% Now the actual random walks or flights
s=s+stepsize.*randn(size(s));
% Apply simple bounds/limits
nest(j,:)=simplebounds(s,Lb,Ub);
end
%% Find the current best nest
function [fmin,best,nest,fitness]=get_best_nest(nest,newnest,fitness)
% Evaluating all new solutions
for j=1:size(nest,1)
fnew=fobj(newnest,j);
if fnew<=fitness(j),
fitness(j)=fnew;
nest(j,1)=newnest(j,1);
end
end
% Find the current best
[fmin,K]=min(fitness) ;
best = max(nest(fitness == fmin));
if best >1
    best = 1;
end
%best=nest(K,1);
%% Replace some nests by constructing new solutions/nests
function new_nest=empty_nests(nest,Lb,Ub,pa)
% A fraction of worse nests are discovered with a probability pa
n=size(nest,1);
% Discovered or not -- a status vector
K=rand(size(nest))>pa;
% In the real world, if a cuckoo’s egg is very similar to a host’s eggs, then
% this cuckoo’s egg is less likely to be discovered, thus the fitness should
% be related to the difference in solutions. Therefore, it is a good idea
% to do a random walk in a biased way with some random step sizes.
%% New solution by biased/selective random walks
stepsize=rand*(nest(randperm(n),:)-nest(randperm(n),:));
new_nest=nest+stepsize.*K;
% Application of simple constraints
function s=simplebounds(s,Lb,Ub)
% Apply the lower bound
ns_tmp=s;
I=ns_tmp<Lb;
ns_tmp(I)=Lb(I);
% Apply the upper bounds
J=ns_tmp>Ub;
ns_tmp(J)=Ub(J);
% Update this new move
s=ns_tmp;
%% You can replace the following by your own functions
% A d-dimensional objective function
function z=fobj(mass,i)
[far,frr] = calc_ROC(mass,i,size(mass,1));
        z = (0.5*far+0.5*frr);
