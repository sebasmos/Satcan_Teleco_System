function [new]=decotexto(vector)
    
    if (mod(length(vector),7)~=0)
        f=mod(length(vector),7);
        s=7-f;
        add=zeros(1,s);
        vector=[vector add];
    end
  
    i=1;
    j=1;
    while(i<=length(vector))
        if mod(length(vector),7)
            sobra=mod(length(vector,7));
            for j=1:sobra
                vector(length(vector)+1)=0;
            end    
        end
        nuevovector=[vector(i) vector(i+1) vector(i+2) vector(i+3) vector(i+4) vector(i+5) vector(i+6)];
        cyu(j,:)=nuevovector;
        i=i+7;
        j=j+1;
    end
    s=size(cyu);
    for j=1:s(1,1)
        for k=1:s(1,2)
            if cyu(j,k)==0
                cyu(j,k)=48;
            else
                if cyu(j,k)==1
                cyu(j,k)=49;
                end
            end
        end
    end
    for j=1:s(1,1)
        for k=1:s(1,2)
            chars(j,k)=char(cyu(j,k));
            
        end
    end
    s=size(chars);
    for j=1:s(1,1)
        new(j)=char(bin2dec(chars(j,:)));
    end
    
end