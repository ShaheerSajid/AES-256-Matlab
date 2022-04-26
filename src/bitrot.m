function y = bitrot(x, k)
    y = bitor(bitshift(x,k), bitshift(x, k-32));
end