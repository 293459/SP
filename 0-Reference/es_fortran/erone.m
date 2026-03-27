close all
clear
clc

format long
x =[1.2 
3.5 
4.2];
y= [2.1
 4.2
1.3];

lat=zeros(3,1);

for i=1:3
    if i<3
lat (i)= sqrt((x(i)-x(i+1))^2+(y(i)-y(i+1))^2);
    else
        lat (i) = sqrt((x(i)-x(1))^2+(y(i)-y(1))^2);
    end

end

p=sum(lat)/2;

A=sqrt(p*(p-lat(1))*(p-lat(2))*(p-lat(3)))