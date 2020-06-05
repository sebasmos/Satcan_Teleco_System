function rta = muestreo()
[y,Fs]= audioread('Woman.wav'); %%Se lee el archivo de audio
vector=y(:,1); 
s=size(vector);
segundos=round(s(1,1)/Fs);
a=max(vector);
b=length(vector);
[P,Q]=rat(8000/Fs);
newaudio=resample(y,P,Q);
rta=newaudio;
%rta=compand(rta1,87.6,max(rta1),'a/compressor');
end