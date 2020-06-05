function [codificado] = codlinea(vector)
    matrizm=[];
    i=1;
    j=1;
    if (mod(length(vector),4)~=0)
        f=mod(length(vector),4);
        s=4-f;
        add=zeros(1,s);
        vector=[vector add];
    end
    
    while(i<=length(vector))
        nuevovector=[vector(i) vector(i+1) vector(i+2) vector(i+3)];
        matrizm(j,:)=nuevovector;
        i=i+4;
        j=j+1;
    end
    
    hamming=[1 1 0 1 0 0 0; 1 0 1 0 1 0 0; 0 1 1 0 0 1 0; 1 1 1 0 0 0 1];
    sm=size(matrizm);
    nwe=sm(1,1);
    nuebin=[];
    for i= 1:nwe
        ham=mod(matrizm(i,:)*hamming,2);
        nuebin=[nuebin ham];
    end
    codificado=nuebin;
end