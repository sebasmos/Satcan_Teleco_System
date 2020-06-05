%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% FUNCIÓN PARA EL CANAL DE PROPAGACIÓN%%%%%%%%
%Esta función retorna una señal ruidosa,la potencia de recepción y la relación señal a Ruido 
% Sennal: Señal interferente y ruidosa  
% b: Indica si es texto o audio y define la tasa de bits (a e{1,0})
% Y_tx: Señal modulada
% t: tiempo
% M: Simbolos de la modulación.
% P_rx:Potencia en recepción (dBW);
% SNR=Relación señal a ruido (dB)
% P_tx=Potencia en transmisión(W);
% Perdidas= Perdidas del terreno (dB);
% G_tx, G_rx=Ganancia de las antenas (veces);
% a=Factor de roll-off del filtro conformador;
% M=Símbolos de la modulación.
% [Sennal, P_rx,SNR]=Canal(Y_tx,b,P_tx,Perdidas,G_tx,G_rx,a,M)
function [Sennal, P_rx,SNR]=Canal(Y_tx,b,P_tx,Perdidas,G_tx,G_rx,a,M)
if(b==1)
       Rb=128000; %128kpb 
elseif(b==0)
        Rb=60000; %60kpb
end
Rs=Rb/log2(M);
%CÁLCULO DE POTENCIA EN RECEPCIÓN.
fs=8*Rs;%Frecuencia de muestreo
P_tx_dB=10*log10(P_tx); %Potencia en dB
G_tx_dB=10*log10(G_tx); %Ganancia en dB
G_rx_dB=10*log10(G_rx); %Ganancia en dB
P_rx=P_tx_dB+G_tx_dB+G_rx_dB-Perdidas; %Entornos rurales

%POTENCIA DE RUIDO EQUIVALENTE
K=1.3806e-23; %Constante de Boltzmann (J/K)
T=273; %Temperatura de ruido equivalente (K)
B=(1+a)*(Rs); %Ancho de banda de Nyquist (Hz)
No=10*log10(K*B*T); %Potencia de ruido
SNR=P_rx-No; %Relación Señal a Ruido.

%SENAL CON RUIDO
Y2=awgn(Y_tx,SNR-10*log10((fs/2)/Rs),'measured'); %RUIDO
Sennal=Y2; %SEÑAL RUIDOSA E INTERFERENTE.
end