%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% DEMODULACIÓN PSK PARA M SÍMBOLOS %%%%%%%%
%Esta función permite la demodulación para modulación M-PSK 
%data=DEMPSK(Y,t,M)
%data: bits en recepción
%t: Base de tiempo necesaria para demodulación.
%M: número de simbolos del esquema
%a: Indica si es texto o audio y define la tasa de bits (a e{1,0})
function data=DEMPSK(Y,t,M,a)
if(a==1)
       Rb=128000; %128kpb 
elseif(a==0)
        Rb=60000; %60kpb
end
Rs=Rb/log2(M);
%INFORMACIÓN DE LA SEÑAL PORTADORA.
fs=8*Rs;%Frecuencia de muestreo
fc=2*Rs;%Frecuencia portador
U=8; %factor de sobre muestreo 
c=8; %cantidad de ceros que toman el filtro comformador p(t)

%GENERO UN VECTOR DE SIMBOLOS PARA LA DESICIÓN Y MATRIZ DE COMPARACIÓN;.
%Vectores
A_fase=[];
A_qua=[];
Amp=4;
for j=1:(M)
    if(j<=(M/4))
        A_fase=[A_fase Amp*cos((2*j-1)*(pi/M))];
        A_qua=[A_qua Amp*sin((2*j-1)*(pi/M))];   %Vector de símbolos en quadratura
    elseif(j<=(M/2)&& j>(M/4))
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
D=[A_fase' A_qua'];
B1=uniquetol(A_fase);
B2=uniquetol(A_qua);
B1=sort(B1);
B2=sort(B2);
B1=floor(B1*100)/100;
B2=floor(B2*100)/100;
D=floor(D*100)/100;
%Matriz
Ades=simbolos(M);
[a b]=size(Ades);
%MULTIPLICO POR LA SEÑAL EN FASE Y LA SEÑAL EN QUADRATURA.
Y_fase1=2*Y.*cos(2*pi*fc.*t); %Señal en fase
Y_qua1=2*Y.*sin(2*pi*fc.*t); %Señal en quadratura

%FILTRO CONFORMADOR
r1=0.5;
p=rcosdesign(r1,c,U,'sqrt');
%Filtro con el filtro conformador
Y_fase2=filter(p,1,Y_fase1);
Y_qua2=filter(p,1,Y_qua1);
%quito ceros para la conformación del pulso
Y_fase3=downsample(Y_fase2,U);
Y_qua3=downsample(Y_qua2,U);

%DECISIÓN
Sest1=Y_fase3;
Sest2=Y_qua3;
%Umbrales de decisión.
if(M==2)
    Test1=0;
    Test2=0;
    for m=1:length(Sest1)
         if(Sest1(m)<=Test1)
             Sest1(m)=0;
         else
             Sest1(m)=0;
         end
         if(Sest2(m)<=Test2)
             Sest2(m)=-4;
         else
             Sest2(m)=4;
         end
    end
else
    T=M/2;
    Test1=zeros(1,T-1); %Vector para umbrales de decisión en fase. 
    Test2=zeros(1,T-1); %Vector para umbrales de decisión en quadratura.
    for n=1:length(Test1)
        Test1(n)=(B1(n)+B1(n+1))/2;
        Test2(n)=(B2(n)+B2(n+1))/2;
    end

    %Para el primer y último umbral de decisión

    for m=1:length(Sest1)
             if(Sest1(m)<=Test1(1))
                     Sest1(m)=B1(1);
             end
            if(Sest2(m)<=Test2(1))
                     Sest2(m)=B2(1);
            end
            if(Sest1(m)>=Test1(length(Test1)))
                     Sest1(m)=B1(length(Test1)+1);
            end
            if(Sest2(m)>=Test2(length(Test2)))
                     Sest2(m)=B2(length(Test2)+1);
            end
    end
%Para los umbrales mayores al primer umbral y menores al último
    for q=1:length(Sest1)
        for w=1:(length(Test1)-1)
            if(w>=2)
                if(Sest1(q)>=Test1(w-1)&& Sest1(q)<Test1(w))
                    Sest1(q)=B1(w);
                elseif(Sest1(q)>=Test1(w)&& Sest1(q)<Test1(w+1))
                    Sest1(q)=B1(w+1);
                end
                if(Sest2(q)>=Test2(w-1)&& Sest2(q)<Test2(w))
                    Sest2(q)=B2(w);
                elseif(Sest2(q)>=Test2(w)&& Sest2(q)<Test2(w+1))
                    Sest2(q)=B2(w+1);
                end
            end
        end
    end
end
Sest1=Sest1(c+1:length(Sest1));
Sest2=Sest2(c+1:length(Sest2));

Sest1=floor(Sest1*100)/100;
Sest2=floor(Sest2*100)/100;
[v l]=size(D);
Ang=[];
Ang1=[];
%tomo los simbolos y los paso a bits
for ii=1:v
    if(ii<=M/4)
        Ang=[Ang 57.2958*atan(D(ii,2)/D(ii,1))];
    elseif(ii>M/4 && ii<=M/2)
        Ang=[Ang (180+57.2958*atan(D(ii,2)/D(ii,1)))];
    elseif(ii>M/2 && ii<=3*M/4)
        Ang=[Ang (180+57.2958*atan(D(ii,2)/D(ii,1)))];
    elseif(ii>=3*M/4)
        Ang=[Ang (360+57.2958*atan(D(ii,2)/D(ii,1)))];
    end
end
for tt=1:length(Sest1)
    if(Sest1(tt)>0)
        if(Sest2(tt)>0)
            Ang1=[Ang1 57.2958*atan(Sest2(tt)/Sest1(tt))];
        else
            Ang1=[Ang1 (360+57.2958*atan(Sest2(tt)/Sest1(tt)))];
        end
    else
        if(Sest2(tt)>0)
            Ang1=[Ang1 (180+57.2958*atan(Sest2(tt)/Sest1(tt)))];
        else
            Ang1=[Ang1 (180+57.2958*atan(Sest2(tt)/Sest1(tt)))];
        end
    end
end
Ang=(ceil(Ang*100)/100)-1;
Ang1=(ceil(Ang1*100)/100)-1;
if(M==2)
    Ang=[270.0000 90.0000];
    for ll=1:length(Ang1)
        if(Ang1(ll)<=90)
            Ang1(ll)=90;
        elseif (Ang1(ll)>90)
            Ang1(ll)=270;
        end
    end
end
Ang;
Bits=[];
for iii=1:length(Ang1)
    for ttt=1:length(Ang) 
        if(Ang1(iii)==Ang(ttt))
            Bits=[Bits Ades(ttt,:)];
        end
    end
end
data=Bits;
end
