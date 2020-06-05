function [deco]=decolinea(vector)
    H=[1 0 0 1 1 0 1; 0 1 0 1 0 1 1; 0 0 1 0 1 1 1];
    if (mod(length(vector),7)~=0)
        f=mod(length(vector),7);
        s=7-f;
        add=zeros(1,s);
        vector=[vector add];
    end
    i=1;
    j=1;
    matrizm=[];
    while(i<=length(vector))
        nuevovector=[vector(i) vector(i+1) vector(i+2) vector(i+3) vector(i+4) vector(i+5) vector(i+6)];
        matrizm(j,:)=nuevovector;
        i=i+7;
        j=j+1;
    end
    
    % matrizm es la matriz con los vectores de longitud 7
    
    sm=size(matrizm);
    nwe=sm(1,1);
    matsind=[];
    for k= 1:nwe
        sind=mod(matrizm(k,:)*H',2);
        matsind(k,:)=sind;
    end
    disp(matsind)
    %matsind es una matriz que contiene todos los vectores sindrome
    sm=size(matsind);
    nwe=sm(1,1);
    for i= 1:nwe
        if(matsind(i,:)==[1 1 0])
            matrizm(i,:)=mod(matrizm(i,:)+[0 0 0 1 0 0 0],2);
        else
            if(matsind(i,:)==[1 0 1])
                matrizm(i,:)=mod(matrizm(i,:)+[0 0 0 0 1 0 0],2);
            else
                if(matsind(i,:)==[0 1 1])
                    matrizm(i,:)=mod(matrizm(i,:)+[0 0 0 0 0 1 0],2);
                else
                    if (matsind(i,:)==[1 1 1])
                        matrizm(i,:)=mod(matrizm(i,:)+[0 0 0 0 0 0 1],2);
                    end
                end
            end
        end             
    end
    
    sm=size(matrizm);
    nwe=sm(1,1);
    decol=[];
    for i=1:nwe
        nuevovector=matrizm(i,4:7);
        decol=[decol nuevovector];
    end
    
    deco=decol;
    
end