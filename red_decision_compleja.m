clear; clc; close all;
disp('Red de Decisión Compleja');
tau1=40;
tau2=500;   
tau3=2000;
W21=2;W11=0.256;W31=0.4;W41=10;     M1=10; zita1=1.3;
W12=0.2;W22=0.4;W42=2;W32=10;       M2=10; zita2=3.6;
W33=2.8;W23=0.1;                    M3=5;  zita3=7;
W44=2.8;                            M4=4;  zita4=7;
W54=1;                                     zita5=0.05;
W63=1;                                     zita6=0.05;
H=@(x)x*(x>=0);
K2=@(x)1*(x>=0)*(x<=1400001);
K1=@(x)1*(x>=200001)*(x<=300001);

t=linspace(0,150001,150001/0.1);dt=0.02;%intervalo de integración
z=zeros(8,length(t));%matriz de estados en el tiempo

%Señales de Entrada
In1=zeros(1,length(t)); %K1
In2=zeros(1,length(t)); %K2

for i=1:length(t)-1
    
    In1(1,i)=K1(i);
    In2(1,i)=K2(i);
    
    z(1,i+1)=z(1,i)+(dt/tau1)*(-z(1,i)+M1*(H(K1(i)+W11*z(1,i)-W12*z(2,i)))^2/((zita1)^2+(H(K1(i)+W11*z(1,i)-W12*z(2,i)))^2));
    z(2,i+1)=z(2,i)+(dt/tau1)*(-z(2,i)+M2*(H(K2(i)+W22*z(2,i)-W21*z(1,i)-W23*z(3,i)))^2/((zita2)^2+(H(K2(i)+W22*z(2,i)-W21*z(1,i)-W23*z(3,i)))^2));
    
    
    z(3,i+1)=z(3,i)+(dt/tau2)*(-z(3,i)+M3*(H(W31*z(1,i)+W33*z(3,i)-W32*z(2,i)))^4/((zita3)^4+(H(W31*z(1,i)+W33*z(3,i)-W32*z(2,i)))^4));
    z(4,i+1)=z(4,i)+(dt/tau3)*(-z(4,i)+M4*(H(W42*z(2,i)+W44*z(4,i)-W41*z(1,i)))^4/((zita4)^4+(H(W42*z(2,i)+W44*z(4,i)-W41*z(1,i)))^4));
    z(5,i+1)=z(5,i)+(dt/tau1)*(-z(5,i)+M4*(H(W54*z(4,i)-3.5))^4/((zita5)^4+(H(W54*z(4,i)-3.5))^4));
    z(6,i+1)=z(6,i)+(dt/tau1)*(-z(6,i)+M3*(H(W63*z(3,i)-3.5))^4/((zita6)^4+(H(W63*z(3,i)-3.5))^4));
end

subplot(211);
plot(t,In1,'r',t,In2, 'g')
title('Señales de Entrada')
xlabel('time/ms');ylabel('z(t)');grid on;axis tight;legend('Input K1', 'Input K2')
axis([0 150000 0 1.2])

subplot(212);
plot(t,z(1,:),'b-',t,z(2,:),'r-',t,z(3,:),'c-',t,z(4,:),'k-',t,z(5,:),'m-',t,z(6,:),'g-')
title('Respuesta Robot Móvil')
xlabel('time/ms');ylabel('z(t)');grid on;axis tight;legend('Subite Grap Neuron', 'Trayectory Recalculated Neuron', 'Emergency Alarm Neuron', 'Return Neuron to Previous Point', 'Retreat', 'Activate Alarm')