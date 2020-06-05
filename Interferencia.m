%FUNCIÓN DE INTERFERENCIA
% Retorna una función resultado de la señal interferente
% Sennal=Señal con interferencia
% Y1=Señal de entrada;
% Yi=Señal interferente;
% [Sennal,CI]=Interferencia(Y1,Yi,Prx,Prxi,t)
function[Sennal,CI]=Interferencia(Y1,Yi,Prx,Prxi,t)
Y2=0.5*Yi; %Factor de atenuación de la señal interferente
Y3=0.9*Y1+Y2+0.5*cos(2*pi*8.*t); %Suma de la señal modulada más la señal interferente más un tono puro
CI=Prx-Prxi+60; %Calculo la relación C/I; 
Sennal=Y3;
end