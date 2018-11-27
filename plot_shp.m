function [p, q] = plot_shp(n)
    % return the divisors closest in size
    if ~isprime(n)
        d = divisors(n);
        if mod(length(d), 2) == 0
            p = d(floor(length(d)/2));
            q = d(floor(length(d)/2) + 1);
        else
            p = d(floor(length(d)/2) + 1);
            q = d(floor(length(d)/2) + 1);
        end
    end
end
        