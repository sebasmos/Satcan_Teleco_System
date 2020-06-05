% Esta función permite calcular las perdidas  del entorno máximo del NRF
% (100) o más allá
% Ls: Pérdidas obtenidas
% Tipo: Tipo de entorno
% Distancia: Distancia del enlace
% Ls=Perdidas(Tipo, distancia,a)
function Ls=Perdidas(Tipo, distancia)
    f=2400;
    Curbano=-2*((log10(f/28)^2))-5.4;
    Crural=-4.78*((log10(f)^2))+18.4*(log10(f))-40.98;
    Lfs=32.45+20*log10(f)+20*log10(distancia);
    if (Tipo==2)
        Ls=Lfs+Crural;
    elseif (Tipo==1)
        Ls=Lfs+Curbano;
    end
end