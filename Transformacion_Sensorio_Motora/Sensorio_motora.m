clear all;  close all;clc;

numero_de_entradas=10;%Numero de vectores de entrada para entrenamiento

numero_divisiones=27; %numero de divisiones de angulos 

Total_neuronas=640;%numero total de neuronas de la capa sensorial y motora

lambda=0.1; %constante lambda de la función de activación implementada

Error_aceptado=10*pi/180;%error aceptado para actualizar los pesos sinaptios

angulos_preferentes=[linspace(-15*(pi/180),375*(pi/180),numero_divisiones) 0]; %angulos preferentes 

neuronas_sensoriales=zeros(numero_de_entradas,Total_neuronas); %Estado de las neuronas de la capa sensorial

neuronas_motoras=zeros(numero_de_entradas,Total_neuronas);%Estado de las neuronas de la capa motora

rng(8)%Seed

Entradas=rand(1,numero_de_entradas).*2*pi;%inicialización de los datos a entrenar

limite_angulos=@(x,i)(((x<=pi)&&(i<=(Total_neuronas/2)+2*(Total_neuronas/numero_divisiones)))||((x>pi)&&(i>Total_neuronas/2-2*(Total_neuronas/numero_divisiones))));%Condicion de limite de angulos

Y=@(x)1*(x>=0.9); %condición gamma de los pesos sinapticos

for k=1:numero_de_entradas %ciclo para evaluar todas los datos generados
    
      cambio_angulo_sensorial=1;%contador para determinar cuando cambia el angulo preferente de la neurona
      
      suma_ponderada_sensorial=0;%inicialización sumatoria para calcular el angulo estimado sensorial
      
for i=1:Total_neuronas%ciclo para calcular la salida de cada neurona de la capa sensorial
    
     U=[cos(Entradas(k)) sin(Entradas(k))]; %Vector de entrada
     
     V=[cos(angulos_preferentes(cambio_angulo_sensorial)) sin(angulos_preferentes(cambio_angulo_sensorial))];%vector de angulo preferente de la neurona
     
     neuronas_sensoriales(k,i)=exp(((dot(U,V))-1)/(2*(lambda^2)))*limite_angulos(Entradas(k),i);%calculo de la salida de la neurona de la capa sensorial
     
     suma_ponderada_sensorial=suma_ponderada_sensorial+(neuronas_sensoriales(k,i)*angulos_preferentes(cambio_angulo_sensorial));%calculo sumatoria ponderada para el calculo del angulo estimado
     
     if (i>=(Total_neuronas/numero_divisiones)*cambio_angulo_sensorial)%condición para actualizar el angulo preferente de cada neurona
           cambio_angulo_sensorial=cambio_angulo_sensorial+1;
     end  

end

angulo_estimado_sensorial(k)=suma_ponderada_sensorial/sum(neuronas_sensoriales(k,:));%calculo del angulo estimado por la capa sensorial

error_capa_sensorial(k)=abs(angulo_estimado_sensorial(k)-Entradas(k))/abs(Entradas(k)); %calculo del error del angulo estimado por la capa sensorial

semejanza_capa_sensorial(k)=dot([cos(Entradas(k)) sin(Entradas(k))],[cos(angulo_estimado_sensorial(k)) sin(angulo_estimado_sensorial(k))]); %calculo de la semejanza entre el angulo estimado y el angulo de entrada

end

Error_promedio_sensorial=sum(error_capa_sensorial)/length(error_capa_sensorial)%calculo del error promedio del angulo estimado por la capa sensorial

Semejanza_promedio_sensorial=sum(semejanza_capa_sensorial)/length(semejanza_capa_sensorial)%calculo de la semejanza promedia entre el angulo estimado por la capa sensorial y el angulo de entrada


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CAPA MOTORA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for k=1:numero_de_entradas
    
   cambio_angulo_motora=1;%contador para determinar cuando cambia el angulo preferente de la neurona
    
    suma_ponderada_motora=0;%inicialización sumatoria para calcular el angulo estimado motoro
    
    for i=1:Total_neuronas%ciclo para recorrer todas las neuronas de la capa sensorial
        
        cambio_angulo_sensorial=1;

        for j=1:Total_neuronas%ciclo para recorrer todas las neuronas de la capa sensorial


            if (j>=(Total_neuronas/numero_divisiones)*cambio_angulo_sensorial)%condición para actualizar el angulo preferente de cada neurona sensorial
                cambio_angulo_sensorial=cambio_angulo_sensorial+1;
            end 
            
            if (i>=(Total_neuronas/numero_divisiones)*cambio_angulo_motora)%condición para actualizar el angulo preferente de cada neurona motora
                cambio_angulo_motora=cambio_angulo_motora+1;
            end              
                     
            neuronas_motoras(k,i)=neuronas_motoras(k,i)+neuronas_sensoriales(k,j)*limite_angulos(Entradas(k),i)*Y(cos(angulos_preferentes(cambio_angulo_sensorial)-angulos_preferentes(cambio_angulo_motora)));%calculo de la salida de la neurona de la capa sensorial 
            
        end
        
                %%%%%%descomentar para usar funcion exponencial%%%%%%%
        %neuronas_motoras(k,i)=exp(-(angulos_preferentes(cambio_angulo_motora)-neuronas_motoras(k,i))^2/(2*(lambda^2)));
        
        suma_ponderada_motora=suma_ponderada_motora+neuronas_motoras(k,i)*angulos_preferentes(cambio_angulo_motora);%calculo sumatoria ponderada para el calculo del angulo estimado de la capa motora
    end
    
angulo_estimado_motora(k)=suma_ponderada_motora/sum(neuronas_motoras(k,:));%calculo del angulo estimado por la capa motora

error_capa_motora(k)=abs(angulo_estimado_motora(k)-Entradas(k))/abs(Entradas(k));%calculo del error promedio del angulo estimado por la capa motora

semejanza_capa_motora(k)=dot([cos(Entradas(k)) sin(Entradas(k))],[cos(angulo_estimado_motora(k)) sin(angulo_estimado_motora(k))]);%calculo de la semejanza entre el angulo estimado por la capa motora y el angulo de entrada

end
  
Error_promedio_motora=sum(error_capa_motora)/length(error_capa_motora)%calculo del error promedio del angulo estimado por la capa motora

Semejanza_promedio_motora=sum(semejanza_capa_motora)/length(semejanza_capa_motora)%calculo de la semejanza promedia entre el angulo estimado por la capa motora y el angulo de entrada

figure(1);
stem(angulo_estimado_sensorial,'r','LineWidth',1.5);
hold on
stem([1,2,3,4,5,6,7,8,9,10]+0.1,angulo_estimado_motora,'b','LineWidth',1.5);
legend('Estímulo angular de entrada','Orientación decodificada')
xlim([0 11]);
xlabel('Numero de entrada');ylabel('Valor angular (rad)');grid on;
title('Estímulo de entrada Vs. Orientación decodificada por la capa motora')

figure(2);
subplot(2,1,1);
plot(semejanza_capa_motora,'r','LineWidth',1.5);
xlabel('Numero de entrada');ylabel('Semejanza');grid on;
title('Semejanza')

 
subplot(2,1,2);
plot(error_capa_motora,'r','LineWidth',1.5);
xlabel('Número de entrada');ylabel('Error relativo');grid on;
title('Error')

figure(3);
stem(Entradas,'r','LineWidth',1.5);
hold on
stem([1,2,3,4,5,6,7,8,9,10]+0.1,angulo_estimado_sensorial,'b','LineWidth',1.5);
legend('Estímulo angular de entrada','Orientación decodificada')
xlim([0 11]);
xlabel('Numero de entrada');ylabel('Valor angular (rad)');grid on;
title('Estímulo de entrada Vs. Orientación decodificada por la capa sensorial')

figure(4);
subplot(2,1,1);
plot(semejanza_capa_sensorial,'r','LineWidth',1.5);
xlabel('Numero de entrada');ylabel('Semejanza');grid on;
title('Semejanza')

 
subplot(2,1,2);
plot(error_capa_sensorial,'r','LineWidth',1.5);
xlabel('Número de entrada');ylabel('Error relativo');grid on;
title('Error')