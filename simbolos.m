%Funci�n para determinar el n�mero de bits por s�mbolo y sus combinaciones
%de acuerdo al esquema M-�rio
%M: matriz de combinaciones
%N: N�mero de s�mbolos del esquema

function [M]=simbolos(N)  %Funcion para obtener las combinaciones de los simbolos
    a=log2(N); %Cantidad de bits por simbolos
    v=[];
    %Creo un vector de 1 y 0 alternados.
    if N==2
        M=[0;1];
    else
    for i=1:a
        if (mod(i,2)==0)
            v=[v 0];
        else
            v=[v 1];
        end
    end
    if (((v*v') ~= 0) && ((v*v') ~= length(v))) %Realiz� el producto escalar para comprobar si todos son cero o todos son uno.
            M=de2bi(0:(2^(length(v)))-1);   % M es la matriz que contendr� los n�meros en binario desde el 0 hasta (2^(n)-1),
    else                                    %siendo "n" la dimensi�n del vector.
        M=v;                                %de2bi transforma el n�mero decimal obtenido en un n�mero binario.
    end
    end
end