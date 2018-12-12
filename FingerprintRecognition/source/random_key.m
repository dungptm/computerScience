function [hexkey] = random_key(time)

% random key theo thoi gian giao dich
    format long;
    dt = datenum(datestr(time, 'mmmm dd, yyyy HH:MM'));
    s = num2str(dt*10^16,'%16.0f');
    s = s(1:16);
    hexkey = '';
    for i = 1:16
        hexkey = strcat(hexkey, dec2hex( mod(str2double(s(i))^2 + str2double(s(mod((2*i),16)+1))^2 + 5*str2double(s(i)),255) ,2));
    end
    format short;
end