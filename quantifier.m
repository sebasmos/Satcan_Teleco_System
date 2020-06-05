function value = quantifier(quantval,iter)
%Esta funci{on devuelve el valor cuantificado en la regla dependiendo del
%numero iter que ingrese.

for i=1:0.5*N
    if(iter==i || iter==N-i)
        value=quantval(i);
    else
        value=0;
    end
end

% switch iter
%     case {1 , 15}
%         value=quantval(1);
%         
%     case {2, 14}
%         value=quantval(2);
%         
%     case {3, 13}
%         value=quantval(3);
%         
%     case {4, 12}
%         value=quantval(4);
%         
%     case {5, 11}
%         value=quantval(5);
%         
%     case {6, 10}
%         value=quantval(6);
%         
%     case {7, 9}
%         value=quantval(7);
%         
%     case 8
%         value=quantval(8);
%         
%     otherwise
%         value=0;
% end


    