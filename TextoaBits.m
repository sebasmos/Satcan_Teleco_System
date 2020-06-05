function BitText=TextoaBits(string)
caracteres=dec2bin(string);
bits=double(caracteres);
nuevacadena=[];
acum=[];
cod=[];
s=size(bits);
p=s(1,1);
for i=1:s
    acum=bits(i,:);
    nuevacadena=[cod acum];
    cod=nuevacadena;
end
for j=1:length(cod)
    if cod(j)==48
        cod(j)=0;
    else
        if cod(j)==49
            cod(j)=1;
        end
    end
end
BitText=cod;
end