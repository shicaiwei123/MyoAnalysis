%��һ���������е�ƽ������
function y=engery(seq)
    [m,n]=size(seq);
    power=seq.*seq;
    sumData=sum(power(:));
    y=sumData/m;