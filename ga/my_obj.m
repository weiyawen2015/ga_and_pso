function out = my_obj(x_bi,parameter)
nvar = parameter.nvar; 
xmin = parameter.xmin;
xmax = parameter.xmax;
m = parameter.m;
b(1) = bi2de(x_bi(1:m));
b(2) = bi2de(x_bi(m+1:nvar*m));
x = xmin + b*(xmax-xmin)/(2^m-1);
out = x(1).^2 + x(2).^2-0.3*cos(3*pi*x(1)) - 0.4*cos(4*pi*x(2))+0.7;
end
