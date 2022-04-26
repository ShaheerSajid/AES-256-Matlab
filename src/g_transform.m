function y = g_transform(x, i)
    rcon = [0x01000000 0x02000000 0x04000000 0x08000000 0x10000000 0x20000000 0x40000000 0x80000000 0x1b000000 0x36000000 0x6c000000 0xd8000000 0xab000000 0x4d000000 0x9a000000];
    byte_shift = bitrot( x, 8);
    sx = sbox_word(byte_shift);
    y = bitxor(sx, rcon(i));
end