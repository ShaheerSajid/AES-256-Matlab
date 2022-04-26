key = [0x00010203 0x04050607 0x08090a0b 0x0c0d0e0f 0x10111213 0x14151617 0x18191a1b 0x1c1d1e1f];
data = [    0x00,0x44,0x88,0xcc;
            0x11,0x55,0x99,0xdd;
            0x22,0x66,0xaa,0xee;
            0x33,0x77,0xbb,0xff
       ];

%Key expansion and encryption
rk = zeros(8,8);
rk(1,:) = key;
%state matrix
state = zeros(4,4);
for i = 1 : 4
    state(1,i) = bitxor(data(1,i) , getbyte(rk(1,i),3));
    state(2,i) = bitxor(data(2,i) , getbyte(rk(1,i),2));
    state(3,i) = bitxor(data(3,i) , getbyte(rk(1,i),1));
    state(4,i) = bitxor(data(4,i) , getbyte(rk(1,i),0));
end

for i = 2 : 8
    g = g_transform(uint32(rk(i-1,8)),i-1);
    rk(i,1) = bitxor(g,      rk(i-1,1));
    rk(i,2) = bitxor(rk(i,1),rk(i-1,2));
    rk(i,3) = bitxor(rk(i,2),rk(i-1,3));
    rk(i,4) = bitxor(rk(i,3),rk(i-1,4));
    rk(i,5) = bitxor(sbox_word(rk(i,4)),rk(i-1,5));
    rk(i,6) = bitxor(rk(i,5),rk(i-1,6));
    rk(i,7) = bitxor(rk(i,6),rk(i-1,7));
    rk(i,8) = bitxor(rk(i,7),rk(i-1,8));
    %doing 2 rounds at one time
    %round 1
    %sub bytes
    for j = 1 : 4
        for k = 1 : 4
            state(j,k) = sbox_byte(state(j,k));
        end
    end
    %shift rows
    state(2,:) = circshift(state(2,:), -1, 2);
    state(3,:) = circshift(state(3,:), -2, 2);
    state(4,:) = circshift(state(4,:), -3, 2);
    %mix columns
    state_temp = uint8(zeros(4,4));
    for p = 1:4
        state_temp(1,p)=bitxor(bitxor(mix_column_mul2(state(1,p)), bitxor(mix_column_mul2(state(2,p)),state(2,p))), bitxor(state(3,p),state(4,p)));
        state_temp(2,p)=bitxor(bitxor(state(1,p), mix_column_mul2(state(2,p))), bitxor(bitxor(mix_column_mul2(state(3,p)),state(3,p)),state(4,p)));
        state_temp(3,p)=bitxor(bitxor(state(1,p), state(2,p)), bitxor(mix_column_mul2(state(3,p)),bitxor(mix_column_mul2(state(4,p)),state(4,p))));
        state_temp(4,p)=bitxor(bitxor(bitxor(mix_column_mul2(state(1,p)),state(1,p)), state(2,p)), bitxor(state(3,p),mix_column_mul2(state(4,p))));
    end
    %add round key
    for q = 1 : 4
        state(1,q) = bitxor(state_temp(1,q) , getbyte(rk(i-1,q+4),3));
        state(2,q) = bitxor(state_temp(2,q) , getbyte(rk(i-1,q+4),2));
        state(3,q) = bitxor(state_temp(3,q) , getbyte(rk(i-1,q+4),1));
        state(4,q) = bitxor(state_temp(4,q) , getbyte(rk(i-1,q+4),0));
    end
    dec2hex(state)
    %break;
    %round 2
    %sub bytes
    for j = 1 : 4
        for k = 1 : 4
            state(j,k) = sbox_byte(state(j,k));
        end
    end
    %shift rows
    state(2,:) = circshift(state(2,:), -1, 2);
    state(3,:) = circshift(state(3,:), -2, 2);
    state(4,:) = circshift(state(4,:), -3, 2);
    if i ~= 8
        %mix columns
        state_temp = uint8(zeros(4,4));
        for p = 1:4
            state_temp(1,p)=bitxor(bitxor(mix_column_mul2(state(1,p)), bitxor(mix_column_mul2(state(2,p)),state(2,p))), bitxor(state(3,p),state(4,p)));
            state_temp(2,p)=bitxor(bitxor(state(1,p), mix_column_mul2(state(2,p))), bitxor(bitxor(mix_column_mul2(state(3,p)),state(3,p)),state(4,p)));
            state_temp(3,p)=bitxor(bitxor(state(1,p), state(2,p)), bitxor(mix_column_mul2(state(3,p)),bitxor(mix_column_mul2(state(4,p)),state(4,p))));
            state_temp(4,p)=bitxor(bitxor(bitxor(mix_column_mul2(state(1,p)),state(1,p)), state(2,p)), bitxor(state(3,p),mix_column_mul2(state(4,p))));
        end
    else
        state_temp = state;
    end
    %add round key
    for q = 1 : 4
        state(1,q) = bitxor(state_temp(1,q) , getbyte(rk(i,q),3));
        state(2,q) = bitxor(state_temp(2,q) , getbyte(rk(i,q),2));
        state(3,q) = bitxor(state_temp(3,q) , getbyte(rk(i,q),1));
        state(4,q) = bitxor(state_temp(4,q) , getbyte(rk(i,q),0));
    end
    dec2hex(state)
end
rk_hex = compose("%X",rk);
state_hex = compose("%X",state);


