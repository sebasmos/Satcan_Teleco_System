function [deco]= decodificado(valcod,quantvalue)
    i=1;
    j=1;
    deco=[];
    adeco=[];
    falta=6-mod(length(valcod),6);
    la=zeros(1,falta);
    valcod=[valcod la];
    while (i<length(valcod))
        signo=(valcod(i));
        pal=[valcod(i+1) valcod(i+2) valcod(i+3) valcod(i+4) valcod(i+5)];
        valor=bi2de(pal,'left-msb');
        nuevovalor=valor+1;
        cuant=quantvalue(nuevovalor)*((signo*2)-1);
        adeco=[adeco cuant];
        deco=adeco;
        i=i+6;
    end
end                             
                    
                
