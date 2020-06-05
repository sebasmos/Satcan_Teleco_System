%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%MODULACIÓN PSK PARA M SÍMBOLOS %%%%%%%%
%Esta función permite la modulación para modulación M-PSK 
% function [X_TX, T]=MPSK1(M,v,a)
%X_TX: es la señal a transmitir
%T: Base de tiempo necesaria para demodulación.
%M: número de simbolos del esquema
%v: vecctor de bits a transmitir
%a: Indica si es texto o audio y define la tasa de bits (a e{1,0})
function [X_TX, T]=MPSK1(M,v,a)
    if(a==1)
       Rb=128000; %128kpb 
    elseif(a==0)
        Rb=60000; %60kpb
    end
    Rs=Rb/log2(M);
    %Información de la señal portadora.
    fs=8*Rs;%Frecuencia de muestreo
    fc=2*Rs;%Frecuencia portador
    U=8; %factor de sobre muestreo 
    c=8; %cantidad de ceros que toman el filtro comformador p(t)
    
    %Calculo y hallo el número de bits por símbolos.
    n=log2(M); %número de bits por símbolo.
    Asim=simbolos(M); %Matriz de bits por simbolos.
    vmatriz=vec2mat(v,n); %Segmentos los bits en una matriz para la comparación
    [a b]=size(vmatriz); %tamaño de la matriz de bits.
    %Vector de símbolos en fase y símbolos en quadratura.
    A_fase=[]; %Vector de símbolos en fase.
    A_qua=[]; %Vector de símbolos en quadratura.
    Amp=4; %Amplitud proporcional al número de simbolos.
    %PASO DE BITS A SÍMBOLOS
    for i=1:a
        for j=1:(M)
            if(isequal(vmatriz(i,:),Asim(j,:)))
                if(j<=(M/4))
                    A_fase=[A_fase Amp*cos((2*j-1)*(pi/M))];
                    A_qua=[A_qua Amp*sin((2*j-1)*(pi/M))];   %Vector de símbolos en quadratura
                elseif(j<=(M/2)&& i>(M/4))
                    A_fase=[A_fase Amp*cos((2*j-1)*(pi/M))];
                    A_qua=[A_qua Amp*sin((2*j-1)*(pi/M))];
                elseif(j<=(3*M/4)&& j>(M/2))
                    A_fase=[A_fase Amp*cos((2*j-1)*(pi/M))];
                    A_qua=[A_qua Amp*sin((2*j-1)*(pi/M))];
                elseif(j>=(M/4))
                    A_fase=[A_fase Amp*cos((2*j-1)*(pi/M))];
                    A_qua=[A_qua Amp*sin((2*j-1)*(pi/M))];
                end
            end
        end
    end
    %FORMACIÓN DEL PULSO
    A_fase=[A_fase zeros(1,c)]; %Por el trasiente del filtro
    A_qua=[A_qua zeros(1,c)];
    %filtro conformador
    r1=0.5;
    p=rcosdesign(r1,c,U,'sqrt');
    Pulso_fase=filter(p,1,upsample(A_fase,U));
    Pulso_qua=filter(p,1,upsample(A_qua,U));
    %FORMACIÓN DE LA SEÑAL MODULADA.
    X=length(Pulso_fase); %Tamaño del vector de pulso
    S=length(A_qua); %Tamaño del vector de sìmbolos
    t=(0:X-1)*(S+20)/(Rs*X); %Base de tiempo
    %producto por la portadora
    X_fasetx=Pulso_fase.*cos(2*pi*fc.*t);
    X_quatx=Pulso_qua.*sin(2*pi*fc.*t);
    X_TX=X_fasetx+X_quatx; %Señal a transmitir
    T=t;
end 
