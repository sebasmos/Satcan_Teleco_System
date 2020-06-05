function [codificado] = probabilidad(quantval,cuant,signos)
    vdpr=zeros(1,length(quantval));
    
    for n=1:length(quantval)
        for m=1:length(cuant)
            if(cuant(m)==quantval(n))
                vdpr(n)=vdpr(n)+1;
            end
        end
    end

    vdpr=vdpr./(length(cuant));
        
%%AHORA VAMOS A HACER LA CUANTIFICACIÓN DE LONGITUD FIJA   
    cod=[];
    codificado=[];
    for n=1:length(cuant)
       a=cuant(n);
       for m=1:length(quantval)
           if a==quantval(m)
               b=m-1;
           end
       end
       c=dec2bin(b);
       fal=5-length(c);
       rel=zeros(1,fal);
       for i=1:length(c)
           nuevo(i)=str2num(c(i));
       end
       pal=[signos(n) rel nuevo];
       completo=[codificado pal];
       codificado=completo;
    end  
end