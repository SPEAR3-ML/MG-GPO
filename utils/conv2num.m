function n = conv2num(x)

try
    n = str2num(x);
catch
    n = x;
end
