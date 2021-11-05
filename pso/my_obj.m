function out = my_obj(x)
out = x(1).^2 + x(2).^2-0.3*cos(3*pi*x(1)) - 0.4*cos(4*pi*x(2))+0.7;
end
