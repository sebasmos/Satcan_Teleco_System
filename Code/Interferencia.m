%FUNCI�N DE INTERFERENCIA
% Retorna una funci�n resultado de la se�al interferente
% Sennal=Se�al con interferencia
% Y1=Se�al de entrada;
% Yi=Se�al interferente;
% [Sennal,CI]=Interferencia(Y1,Yi,Prx,Prxi,t)
function[Sennal,CI]=Interferencia(Y1,Yi,Prx,Prxi,t)
Y2=0.5*Yi; %Factor de atenuaci�n de la se�al interferente
Y3=0.9*Y1+Y2+0.5*cos(2*pi*8.*t); %Suma de la se�al modulada m�s la se�al interferente m�s un tono puro
CI=Prx-Prxi+60; %Calculo la relaci�n C/I; 
Sennal=Y3;
end