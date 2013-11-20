function y = convert_H(H,P)
x = H;
y=boolean(zeros(P*size(x)));
I=boolean(eye(P));
[indexI,indexJ,Val] = find(x);  %I:row index, J: column index, Value
Val = Val-1;

for i=1:length(Val)
    
    startI=(indexI(i)-1)*P +1;
    startJ=(indexJ(i)-1)*P +1;
    y(startI:startI+P-1,startJ:startJ+P-1)= I(:,[end-Val(i)+1:end 1:end-Val(i)]);
end