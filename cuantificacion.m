function [quantvalue,cuant,signvector] = cuantificacion(newaudio)
amp=1;
newaudio=amp*newaudio;
maximo=max(newaudio);
minimo=min(newaudio);
% se saca la regla de cuantificación para clasificar las muestras
N=64;
rule=linspace(-amp,amp,N);
pace=rule(N)-rule(N-1);
quantvalue=zeros(1,0.5*N);

for k = 0:((length(rule))/2)-1
    quantvalue(k+1)=(rule(N-k)+rule(N-k-1))/2;
end
quantvalue=quantvalue/amp;
% Se clasifican las muestras de audio dependiendo de las regiones de
% decisión
cuant=[];
signvector=[];
pos=1;
for i = 1:(length(newaudio))
    
    if(newaudio(i)>=0)
        
        signvector(pos)=1;
    else
        signvector(pos)=0;
    end
    pos=pos+1;
    iter=1;
    for j = 1:(length(rule))-1
        if(rule(j)<= newaudio(i) && newaudio(i) < (rule(j)+pace))
            for k=1:N/2
                if (iter==k || iter==N-k)
                    cuant(i)=quantvalue(k);
                end
            end
        end
        iter=iter+1;
    end
end


end