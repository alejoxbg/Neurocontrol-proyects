%% Prueba de cantidad de neuronas requerida para la capa sensorial

clear all;  close all;clc;

angulos_prueba=linspace(0.001,2*pi,360);
numero_divisiones=27; %numero de centros preferentes 
lambda=0.1; %constante lambda de la función de activación implementada
angulos_preferentes=[linspace(-15*(pi/180),375*(pi/180),numero_divisiones) 0]; %Centros preferentes
limite_angulos=@(x,i)(((x<=pi)&&(i<=195*(pi/180)))||((x>pi)&&(i>=165*(pi/180))));%Condicion de limite de angulos

for k=1:10
Total_neuronas(1,k)=k*27;
neuronas_sensoriales=zeros(1,Total_neuronas(k)); %Estado de las neuronas de la capa sensorial

for j=1:length(angulos_prueba)
    estimulo_angular=angulos_prueba(j);
    cambio_angulo_sensorial=1;%contador para determinar cuando cambia el angulo preferente de la neurona
    suma_ponderada_sensorial=0;
for i=1:Total_neuronas(k)%ciclo para calcular la salida de cada neurona de la capa sensorial
     U=[cos(estimulo_angular) sin(estimulo_angular)]; %Vector de entrada
     V=[cos(angulos_preferentes(cambio_angulo_sensorial)) sin(angulos_preferentes(cambio_angulo_sensorial))];%vector de angulo preferente de la neurona
     neuronas_sensoriales(1,i)=exp(((dot(U,V))-1)/(2*(lambda^2)))*limite_angulos(estimulo_angular,angulos_preferentes(cambio_angulo_sensorial));%calculo de la salida de la neurona de la capa sensorial
     suma_ponderada_sensorial=suma_ponderada_sensorial+(neuronas_sensoriales(1,i)*angulos_preferentes(cambio_angulo_sensorial));%calculo sumatoria ponderada para el calculo del angulo estimado
     if (i>=(Total_neuronas(k)/numero_divisiones)*cambio_angulo_sensorial)%condición para actualizar el angulo preferente de cada neurona
           cambio_angulo_sensorial=cambio_angulo_sensorial+1;
     end  
end
    angulo_estimado(1,j)=suma_ponderada_sensorial/sum(neuronas_sensoriales);
    Error(1,j)=abs(angulo_estimado(j)-estimulo_angular)/abs(estimulo_angular);
    Semejanza(1,j)=dot([cos(estimulo_angular) sin(estimulo_angular)],[cos(angulo_estimado(j)) sin(angulo_estimado(j))]);
end
Error_promedio(1,k)=sum(Error)/length(angulos_prueba);
Semejanza_promedio(1,k)=sum(Semejanza)/length(angulos_prueba); 
end

figure(1);
subplot(2,1,1);
plot(Total_neuronas,Semejanza_promedio,'r','LineWidth',1.5);
xlabel('Número de neuronas');ylabel('Semejanza Promedio');grid on;
title('Semejanza en función del número de neuronas')
xlim([17 280]);
xticks(Total_neuronas)
xticklabels({'27','54','81','108','135','162','189','216','243','270'})

subplot(2,1,2);
plot(Total_neuronas,Error_promedio,'b','LineWidth',1.5);
xlabel('Número de neuronas');ylabel('Error Promedio');grid on;
title('Error en función del número de neuronas')
xlim([17 280]);
xticks(Total_neuronas)
xticklabels({'27','54','81','108','135','162','189','216','243','270'})


%% Prueba de efectos en la corrección de la red - Capa sensorial con 25 divisiones

clear all;  close all; clc;

angulos_prueba=[5*(pi/180) 355*(pi/180)];

numero_divisiones=25; %numero de centros preferentes
Total_neuronas=25;
angulos_preferentes1=[linspace(0*(pi/180),360*(pi/180),numero_divisiones) 0]; %Centros preferentes
lambda=0.1; %constante lambda de la función de activación implementada
neuronas_sensoriales=zeros(2,Total_neuronas); %Estado de las neuronas de la capa sensorial


for j=1:length(angulos_prueba)
    estimulo_angular=angulos_prueba(j);
    cambio_angulo_sensorial=1;%contador para determinar cuando cambia el angulo preferente de la neurona
    suma_ponderada_sensorial=0;
for i=1:Total_neuronas%ciclo para calcular la salida de cada neurona de la capa sensorial
     U=[cos(estimulo_angular) sin(estimulo_angular)]; %Vector de entrada
     V=[cos(angulos_preferentes1(cambio_angulo_sensorial)) sin(angulos_preferentes1(cambio_angulo_sensorial))];%vector de angulo preferente de la neurona
     neuronas_sensoriales(j,i)=exp(((dot(U,V))-1)/(2*(lambda^2)));%calculo de la salida de la neurona de la capa sensorial
     suma_ponderada_sensorial=suma_ponderada_sensorial+(neuronas_sensoriales(j,i)*angulos_preferentes1(cambio_angulo_sensorial));%calculo sumatoria ponderada para el calculo del angulo estimado
     if (i>=(Total_neuronas/numero_divisiones)*cambio_angulo_sensorial)%condición para actualizar el angulo preferente de cada neurona
           cambio_angulo_sensorial=cambio_angulo_sensorial+1;
     end  
end
    angulo_estimado(1,j)=suma_ponderada_sensorial/sum(neuronas_sensoriales(j,:));
    Error(1,j)=abs(angulo_estimado(j)-estimulo_angular)/abs(estimulo_angular);
    Semejanza(1,j)=dot([cos(estimulo_angular) sin(estimulo_angular)],[cos(angulo_estimado(j)) sin(angulo_estimado(j))]);
end

figure(1);


subplot(2,1,1);
stem(angulos_preferentes1(1:25),neuronas_sensoriales(1,:),'r','LineWidth',1.5);
title('A) Respuesta de la capa sensorial ante un estímulo de ?/36')
xlim([-0.2 2*pi+0.2]);
xlabel('Neuronas - Centros preferentes');ylabel('Nivel de activación');grid on;
xticks(angulos_preferentes1(1:25))
xticklabels({'0','\pi/12','\pi/6','\pi/4','\pi/3','5\pi/12','\pi/2','7\pi/12','2\pi/3','3\pi/4','5\pi/6','11\pi/12','\pi','13\pi/12','7\pi/6','5\pi/4','4\pi/3','17\pi/12','3\pi/2','19\pi/12','5\pi/3','7\pi/4','11\pi/6','23\pi/12','2\pi'})


subplot(2,1,2); 
stem(angulos_preferentes1(1:25),neuronas_sensoriales(2,:),'b','LineWidth',1.5);
title('B) Respuesta de la capa sensorial ante un estímulo de 71?/36')
xlim([-0.2 2*pi+0.2]);
xlabel('Neuronas - Centros preferentes ');ylabel('Nivel de activación');grid on;
xticks(angulos_preferentes1(1:25))
xticklabels({'0','\pi/12','\pi/6','\pi/4','\pi/3','5\pi/12','\pi/2','7\pi/12','2\pi/3','3\pi/4','5\pi/6','11\pi/12','\pi','13\pi/12','7\pi/6','5\pi/4','4\pi/3','17\pi/12','3\pi/2','19\pi/12','5\pi/3','7\pi/4','11\pi/6','23\pi/12','2\pi'})

%% Prueba de efectos en la corrección de la red - Capa sensorial con 27 divisiones

clear all;  close all; clc;

angulos_prueba=[5*(pi/180) 355*(pi/180)];

numero_divisiones=27; %numero de centros preferentes
Total_neuronas=27;
angulos_preferentes2=[linspace(-15*(pi/180),375*(pi/180),numero_divisiones) 0]; %Centros preferentes
lambda=0.1; %constante lambda de la función de activación implementada
neuronas_sensoriales=zeros(2,Total_neuronas); %Estado de las neuronas de la capa sensorial
limite_angulos=@(x,i)(((x<=pi)&&(i<=195*(pi/180)))||((x>pi)&&(i>=165*(pi/180))));%Condicion de limite de angulos

for j=1:length(angulos_prueba)
    estimulo_angular=angulos_prueba(j);
    cambio_angulo_sensorial=1;%contador para determinar cuando cambia el angulo preferente de la neurona
    suma_ponderada_sensorial=0;
for i=1:Total_neuronas%ciclo para calcular la salida de cada neurona de la capa sensorial
     U=[cos(estimulo_angular) sin(estimulo_angular)]; %Vector de entrada
     V=[cos(angulos_preferentes2(cambio_angulo_sensorial)) sin(angulos_preferentes2(cambio_angulo_sensorial))];%vector de angulo preferente de la neurona
     neuronas_sensoriales(j,i)=exp(((dot(U,V))-1)/(2*(lambda^2)))*limite_angulos(estimulo_angular,angulos_preferentes2(cambio_angulo_sensorial));%calculo de la salida de la neurona de la capa sensorial
     suma_ponderada_sensorial=suma_ponderada_sensorial+(neuronas_sensoriales(j,i)*angulos_preferentes2(cambio_angulo_sensorial));%calculo sumatoria ponderada para el calculo del angulo estimado
     if (i>=(Total_neuronas/numero_divisiones)*cambio_angulo_sensorial)%condición para actualizar el angulo preferente de cada neurona
           cambio_angulo_sensorial=cambio_angulo_sensorial+1;
     end  
end
    angulo_estimado(1,j)=suma_ponderada_sensorial/sum(neuronas_sensoriales(j,:));
    Error(1,j)=abs(angulo_estimado(j)-estimulo_angular)/abs(estimulo_angular);
    Semejanza(1,j)=dot([cos(estimulo_angular) sin(estimulo_angular)],[cos(angulo_estimado(j)) sin(angulo_estimado(j))]);
end

figure(1);


subplot(2,1,1);
stem(angulos_preferentes2(1:27),neuronas_sensoriales(1,:),'r','LineWidth',1.5);
title('A) Respuesta de la capa sensorial ante un estímulo de ?/36')
xlim([-15*(pi/180)-0.15,375*(pi/180)+0.15]);
xlabel('Neuronas - Centros preferentes');ylabel('Nivel de activación');grid on;
xticks(angulos_preferentes2(1:27))
xticklabels({'-\pi/12','0','\pi/12','\pi/6','\pi/4','\pi/3','5\pi/12','\pi/2','7\pi/12','2\pi/3','3\pi/4','5\pi/6','11\pi/12','\pi','13\pi/12','7\pi/6','5\pi/4','4\pi/3','17\pi/12','3\pi/2','19\pi/12','5\pi/3','7\pi/4','11\pi/6','23\pi/12','2\pi','25\pi/12'})

subplot(2,1,2); 
stem(angulos_preferentes2(1:27),neuronas_sensoriales(2,:),'b','LineWidth',1.5);
title('B) Respuesta de la capa sensorial ante un estímulo de 71?/36')
xlim([-15*(pi/180)-0.15,375*(pi/180)+0.15]);
xlabel('Neuronas - Centros preferentes ');ylabel('Nivel de activación');grid on;
xticks(angulos_preferentes2(1:27))
xticklabels({'-\pi/12','0','\pi/12','\pi/6','\pi/4','\pi/3','5\pi/12','\pi/2','7\pi/12','2\pi/3','3\pi/4','5\pi/6','11\pi/12','\pi','13\pi/12','7\pi/6','5\pi/4','4\pi/3','17\pi/12','3\pi/2','19\pi/12','5\pi/3','7\pi/4','11\pi/6','23\pi/12','2\pi','25\pi/12'})


%% Prueba de desempeño final de la capa sensorial

clear all;  close all;clc;

angulos_prueba=rand(1,10).*(2*pi);
numero_divisiones=27; %numero de centros preferentes 
lambda=0.1; %constante lambda de la función de activación implementada
angulos_preferentes=[linspace(-15*(pi/180),375*(pi/180),numero_divisiones) 0]; %Centros preferentes
limite_angulos=@(x,i)(((x<=pi)&&(i<=195*(pi/180)))||((x>pi)&&(i>=165*(pi/180))));%Condicion de limite de angulos
Total_neuronas=108;

neuronas_sensoriales=zeros(1,Total_neuronas); %Estado de las neuronas de la capa sensorial

for j=1:length(angulos_prueba)
    estimulo_angular=angulos_prueba(j);
    cambio_angulo_sensorial=1;%contador para determinar cuando cambia el angulo preferente de la neurona
    suma_ponderada_sensorial=0;
for i=1:Total_neuronas%ciclo para calcular la salida de cada neurona de la capa sensorial
     U=[cos(estimulo_angular) sin(estimulo_angular)]; %Vector de entrada
     V=[cos(angulos_preferentes(cambio_angulo_sensorial)) sin(angulos_preferentes(cambio_angulo_sensorial))];%vector de angulo preferente de la neurona
     neuronas_sensoriales(1,i)=exp(((dot(U,V))-1)/(2*(lambda^2)))*limite_angulos(estimulo_angular,angulos_preferentes(cambio_angulo_sensorial));%calculo de la salida de la neurona de la capa sensorial
     suma_ponderada_sensorial=suma_ponderada_sensorial+(neuronas_sensoriales(1,i)*angulos_preferentes(cambio_angulo_sensorial));%calculo sumatoria ponderada para el calculo del angulo estimado
     if (i>=(Total_neuronas/numero_divisiones)*cambio_angulo_sensorial)%condición para actualizar el angulo preferente de cada neurona
           cambio_angulo_sensorial=cambio_angulo_sensorial+1;
     end  
end
    angulo_estimado(1,j)=suma_ponderada_sensorial/sum(neuronas_sensoriales);
    Error(1,j)=abs(angulo_estimado(j)-estimulo_angular)/abs(estimulo_angular);
    Semejanza(1,j)=dot([cos(estimulo_angular) sin(estimulo_angular)],[cos(angulo_estimado(j)) sin(angulo_estimado(j))]);
    
end

    Error_promedio=sum(Error)/length(angulos_prueba);
    Semejanza_promedio=sum(Semejanza)/length(angulos_prueba); 

figure(1);
stem(angulos_prueba,'r','LineWidth',1.5);
hold on
stem([1,2,3,4,5,6,7,8,9,10]+0.1,angulo_estimado,'b','LineWidth',1.5);
legend('Estímulo angular de entrada','Orientación decodificada')
xlim([0 11]);
xlabel('Numero de entrada');ylabel('Valor angular (rad)');grid on;
title('Estímulo de entrada Vs. Orientación decodificada por la capa sensorial')

figure(2);
subplot(2,1,1);
plot(Semejanza,'r','LineWidth',1.5);
xlabel('Numero de entrada');ylabel('Semejanza');grid on;
title('Semejanza')

 
subplot(2,1,2);
plot(Error,'r','LineWidth',1.5);
xlabel('Número de entrada');ylabel('Error relativo');grid on;
title('Error')

