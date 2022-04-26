function y = mix_column_mul2(x)
    temp = bitshift(uint16(x),1);
    if bitand(temp,0x100) == 0x100
        y = uint8(bitand(bitxor(temp,0x01b),0x0FF));
    else
        y = uint8(bitand(temp,0x0FF));
    end
end