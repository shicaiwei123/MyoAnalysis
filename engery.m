%求一个矩阵序列的平均能量
function y=engery(seq)
    [m,n]=size(seq);
    power=seq.*seq;
    sumData=sum(power(:));
    y=sumData/m;