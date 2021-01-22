
clear; clc; close all;
display('Ejecución de PREFERRED');

H=@(x)x*(x>=0);
tau=20;
t=linspace(0,24000,24000/0.1);dt=0.1;%intervalo de integración

A1=[0 0 0 0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1];
A2=[0 0 0 0 1 0.95 0.9 0.85 0.8 0.75 0.7 0.65 0.6 0.55 0.5 0.45 0.4 0.35 0.3 0.25 0.2 0.15 0.1 0.05];

for l=5:24
    A1(l)=rand;
    A2(l)=rand;
end



j=0;
n=1;
In1=zeros(1,length(t));
In2=zeros(1,length(t));
for i=1:length(t)-1
    if i>(10000*j) && i<=((10000*j)+10000)
     In1(1,i)=A1(n);
     In2(1,i)=A2(n);
    end
    if i>=((10000*j)+10000)
        j=j+1;
        n=n+1;
    end
end

z=zeros(50,length(t));%variables de estado en el tiempo

for i=40001:length(t)-1

    
	z(1,i+1)=z(1,i)+(dt/tau)*(-z(1,i)+In1(1,i));
    z(2,i+1)=z(2,i)+(dt/tau)*(-z(2,i)+z(1,i-10000)); 
    z(3,i+1)=z(3,i)+(dt/tau)*(-z(3,i)+z(1,i-20000)); 
    z(4,i+1)=z(4,i)+(dt/tau)*(-z(4,i)+z(1,i-30000)); 
    z(5,i+1)=z(5,i)+(dt/tau)*(-z(5,i)+z(1,i-40000)); 
    
    
    z(6,i+1)=z(6,i)+(dt/tau)*(-z(6,i)+In2(1,i));
    z(7,i+1)=z(7,i)+(dt/tau)*(-z(7,i)+z(6,i-10000)); 
    z(8,i+1)=z(8,i)+(dt/tau)*(-z(8,i)+z(6,i-20000)); 
    z(9,i+1)=z(9,i)+(dt/tau)*(-z(9,i)+z(6,i-30000)); 
    z(10,i+1)=z(10,i)+(dt/tau)*(-z(10,i)+z(6,i-40000)); 
    
    z(11,i+1)=z(11,i)+(dt/tau)*(-z(11,i)+z(1,i)+z(2,i)+z(3,i)+z(4,i)+z(5,i));
    z(12,i+1)=z(12,i)+(dt/tau)*(-z(12,i)+z(6,i)+z(7,i)+z(8,i)+z(9,i)+z(10,i));
    
    z(13,i+1)=z(13,i)+(dt/tau)*(-z(13,i)+(H(z(11,i)-z(12,i)-0.5))^2/((0.05^2)+(H(z(11,i)-z(12,i)-0.5))^2));
    z(14,i+1)=z(14,i)+(dt/tau)*(-z(14,i)+(H(z(12,i)-z(11,i)-0.2))^2/((0.05^2)+(H(z(12,i)-z(11,i)-0.2))^2));

    
end

plot(t,z(1,:),t,z(2,:),t,z(3,:),t,z(4,:),t,z(5,:))
figure
plot(t,z(6,:),t,z(7,:),t,z(8,:),t,z(9,:),t,z(10,:))
figure
plot(t,z(11,:),t,z(12,:))
figure
plot(t,z(13,:),t,z(14,:))


