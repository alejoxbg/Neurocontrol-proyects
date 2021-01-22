clear all;  close all;clc;

numero_de_entradas=200;%Numero de vectores de entrada para entrenamiento

numero_divisiones=27; %numero de divisiones de angulos 

Total_neuronas=100;%numero total de neuronas de la capa sensorial y motora

epochs=500;%numero de epocas a entrenar

lambda=0.1; %constante lambda de la función de activación implementada

Error_aceptado=10*pi/180;%error aceptado para actualizar los pesos sinaptios

angulos_preferentes=[linspace(-15*(pi/180),375*(pi/180),numero_divisiones) 0]; %angulos preferentes 

neuronas_sensoriales=zeros(numero_de_entradas,Total_neuronas); %Estado de las neuronas de la capa sensorial

neuronas_motoras=zeros(numero_de_entradas,Total_neuronas);%Estado de las neuronas de la capa motora

rng(2);%seed para generación aleatoria de los pesos y las entradas

pesos_capa_motora=rand(Total_neuronas);%inicialización de pesos sinapticos de la capa sensorial a la motora

Entradas=rand(1,numero_de_entradas).*2*pi;%inicialización de los datos a entrenar

limite_angulos=@(x,i)(((x<=pi)&&(i<=(Total_neuronas/2)+2*(Total_neuronas/numero_divisiones)))||((x>pi)&&(i>Total_neuronas/2-2*(Total_neuronas/numero_divisiones))));%Condicion de limite de angulos

for h=1:epochs %ciclo para entrenamiento de todas los datos generados
    
error=0;%inicializaciión del error medio cuadrático por cada epoca

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CAPA MOTORA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
                     
            neuronas_motoras(k,i)=neuronas_motoras(k,i)+neuronas_sensoriales(k,j)*pesos_capa_motora(i,j)*limite_angulos(Entradas(k),i);%calculo de la salida de la neurona de la capa sensorial              
        end
        
        suma_ponderada_motora=suma_ponderada_motora+neuronas_motoras(k,i)*angulos_preferentes(cambio_angulo_motora);%calculo sumatoria ponderada para el calculo del angulo estimado de la capa motora
    end
    
angulo_estimado_motora(k)=suma_ponderada_motora/sum(neuronas_motoras(k,:));%calculo del angulo estimado por la capa motora

if angulo_estimado_sensorial(k)-angulo_estimado_motora(k)>Error_aceptado || angulo_estimado_sensorial(k)-angulo_estimado_motora(k)<-Error_aceptado%condición para determinar si se modifican los pesos, dependiendo del error del angulo estimado

for i=1:Total_neuronas %ciclo para recorrer todos los pesos de cada neurona motora

    for j=1:Total_neuronas %ciclo para recorrer todos los pesos de cada neurona sensorial con respecto a la motora

        pesos_capa_motora(i,j)=pesos_capa_motora(i,j)+0.01*(angulo_estimado_sensorial(k)-angulo_estimado_motora(k));%actualización de los pesos por la regla delta
        
    end
end
end
error=error+(angulo_estimado_sensorial(k)-angulo_estimado_motora(k))^2;%acumulador del error medio cuadrático
end
error_total(h)=error/numero_de_entradas;%error medio cuadrático de la epoca

Error_aceptado=Error_aceptado-9.98*pi/180/epochs;%modificación del error aceptado del angulo

end

save('pesos_capa_motora','pesos_capa_motora','-mat')%guarda los pesos calculados

xlabel('Epocas')
ylabel('Error Medio Cuadrático (MSE)')
plot(error_total)%grafica el error en el entrenamiento