function anglemapobj = inclination_assignment(b,offset);

% makes a map between labeled lines and angles

anglemapobj = containers.Map('KeyType','double','ValueType','double');
anglemapobj(2) = 3*b;
anglemapobj(3) = 2*b;
anglemapobj(4) = 2*b;
anglemapobj(5) = b;
anglemapobj(6) = 0;
anglemapobj(7) = -b;
anglemapobj(8) = b;
anglemapobj(9) = -2*b;
anglemapobj(10) = 4*b;
anglemapobj(11) = 5*b;
anglemapobj(12) = 4*b;
anglemapobj(13) = 5*b;
anglemapobj(14) = 6*b;
anglemapobj(15) = 0;
anglemapobj(16) = -b;
anglemapobj(17) = -2*b;
anglemapobj(18) = -3*b;
anglemapobj(19) = -4*b;
anglemapobj(20) = b;
anglemapobj(21) = -4*b;
anglemapobj(22) = 2*b;
anglemapobj(23) = 3*b;
anglemapobj(24) = 4*b;
anglemapobj(25) = 5*b;
anglemapobj(26) = b;
anglemapobj(27) = 5*b;
anglemapobj(28) = -b;
anglemapobj(29) = -2*b;
anglemapobj(30) = -3*b;
anglemapobj(31) = -4*b;
anglemapobj(32) = -5*b;
anglemapobj(33) = -6*b;
anglemapobj(34) = -7*b;
anglemapobj(35) = 0;
anglemapobj(36) = -2*b;
anglemapobj(37) = -3*b;
anglemapobj(38) = -4*b;
anglemapobj(39) = -4*b;
anglemapobj(40) = -b;
anglemapobj(41) = -5*b;
anglemapobj(42) = 0;
anglemapobj(43) = 0;
anglemapobj(44) = b;
anglemapobj(45) = 2*b;
anglemapobj(46) = 3*b;
anglemapobj(47) = 4*b;
anglemapobj(48) = 5*b;
anglemapobj(49) = 4*b;
anglemapobj(50) = -3*b;
anglemapobj(51) = -4*b;
anglemapobj(52) = 0;
anglemapobj(53) = b;
anglemapobj(54) = 2*b;
anglemapobj(55) = 3*b;
for i = 2:55
    anglemapobj(i) = anglemapobj(i)+offset;
end



