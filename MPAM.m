function [BERT,EbNo]=MPAM(M,S,flag)
    A=uniquetol(S);
    EbNo=0:10;
    BERT=zeros(1,length(EbNo));
    for i=1:length(EbNo)
        Rs=1;%Tasa de baudios
        fs=8*Rs;%Frecuencia de muestreo
        fc=2*Rs;%Frecuencia portadora
        U=8; %factor de sobre muestreo 
        c=8; %cantidad de ceros que toman los filtros p(t) y q(t)
        if flag==1
            r1=0.5;%Factor de roll off de los filtros
            r2=0.5;
        else
            r1=0.75;%Factor de roll off de los filtros
            r2=0.25;
        end

        %FILTROS CONFORMADORES
        %p filtro transmisor
        %q filtro receptor
        p=rcosdesign(r1,c,U,'sqrt');
        q=rcosdesign(r2,c,U,'sqrt');
        S=[S zeros(1,c)];

        X=filter(p,1,upsample(S,U)); %los pulsos ya estan conformados)
        t=(0:length(X)-1)*(length(S)+20)/(Rs*length(X));%Base de tiempo
        Xt=X.*cos(2*pi*fc.*t); %señal a transmitir
        
  
        %RUIDO DEL CANAL
        n=log2(M);%Bits por simbolo
        Es_No=EbNo(i)+10*log10(n);
        SNR=Es_No;
        Y=awgn(Xt,SNR-10*log10((fs/2)/Rs),'measured');%Señal contaminada con AWGN
        figure(2)
        subplot(2,1,1);
        plot(Y);
        grid on;
        subplot(2,1,2);
        plot(Xt);
        grid on;
        figure(3)
        plot(X);
        grid on;
        figure(4)
        subplot(2,1,1);
        plot(p);
        grid on;
        subplot(2,1,2);
        stem(S);
        grid on;
        %RECEPTOR
        Yr=2*Y.*cos(2*pi*fc.*t);
        Yprima=filter(q,1,Yr); %señal en RX filtrada
        Ykprima=downsample(Yprima,U); %desición fase U-1 con pulso rectangular
        %criterio de distancia mínima
        T=M-1; %número de umbrales de desición
        Tes=zeros(1,T);
        for ii=1:T
            Tes(1,ii)=(A(1,ii)+A(1,ii+1))/2; %umbrales de decisión 
        end
        Sest=Ykprima;
        %de-mapeo
        %el primer y último valor de amplitud sólo requieren de una comparación 
        Sest(Sest<Tes(1,1))=A(1,1);
        Sest(Sest>Tes(1,M-1))=A(1,M);
        %mientras que los valores intermedios de amplitud se encuentran entre dos
        %umbrales, por lo que necesitan dos comparaciones
        if M>2
            for ii=2:(M-2)
                Sest(Sest>Tes(1,ii-1) & Sest<Tes(1,ii))=A(1,ii);
                Sest(Sest>Tes(1,ii) & Sest<Tes(1,ii+1))=A(1,ii+1);
            end
        end

        %sólo con el filtro raiz cuadrada de coseno alzado
        Sest=Sest(c+1:length(Sest)); % señal prescindiendo del transiente del filtro
        S=S(1:length(S)-c); %por el transiente del filtro los ultimos símbolos se pierden
        [Nerr,SER]=symerr(S,Sest);
        figure(5)
        stem(S)
        BER=SER/n;
        BERT(i)=BER;
    end
end