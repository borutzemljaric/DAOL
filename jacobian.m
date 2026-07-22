 %% funkcija jacobijeva matrika
 function J = jacobian(fun, x)
 %    display((x))
dx = eps^(1/3); % finite difference delta
nx = numel(x); % degrees of freedom
nf = numel(fun(x)); % number of functions
J = zeros(nf,nx); % matrix of zeros 
for n = 1:nx
    % create a vector of deltas, change delta_n by dx
    delta = zeros(nx, 1); delta(n) = delta(n)+dx;
    dF = fun(x+delta)-fun(x-delta); % delta F
    %display(n)
    J(:, n) = dF(:)/dx/2; % derivatives dF/d_n
end

end