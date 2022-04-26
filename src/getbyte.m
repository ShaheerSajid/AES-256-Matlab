function y = getbyte(x,b)
    mask = bitshift(0x000000FF,(b*8));
    y = uint8(bitand(bitshift( bitand(x , mask), -b*8),0x000000FF));
end