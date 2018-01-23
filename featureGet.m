%获取手势序列的特征
%seq是手势序列
function y=featureGet(emgData,imuData,len)
    len=len*5-1;
    emg1=emgData(1:len,1);
    emg2=emgData(1:len,2);
    emg3=emgData(1:len,3);
    emg4=emgData(1:len,4);
    emg5=emgData(1:len,5);
    emg6=emgData(1:len,6);
    emg7=emgData(1:len,7);
    emg8=emgData(1:len,8);
    accX=imuData(1:len,1);
    accY=imuData(1:len,2);
    accZ=imuData(1:len,3);
    acc=sqrt(accX.^2+accY.^2+accZ.^2);
    diffX=diff(accX);
    diffY=diff(accY);
    diffZ=diff(accZ);
    gcoX=imuData(1:len,4);
    gcoY=imuData(1:len,5);
    gcoZ=imuData(1:len,6);
    gco=sqrt(gcoX.^2+gcoY.^2+gcoZ.^2);
    diffGcoX=diff(gcoX);
    diffGcoY=diff(gcoY);
    diffGcoZ=diff(gcoZ);
    feature=[];
%     feature(1)=mean(accX);
%     feature(2)=mean(accY);
%     feature(3)=mean(accZ);
    feature(4)=sqrt(mean(accX.^2));
    feature(5)=sqrt(mean(accY.^2));
    feature(6)=sqrt(mean(accZ.^2));
    feature(7)=sum(accX(:))*len*1/50;   %积分
    feature(8)=sum(accY(:))*len*1/50; 
    feature(9)=sum(accZ(:))*len*1/50; 
    feature(10)=sqrt(mean(gcoZ.^2));
    feature(10)=sqrt(mean(gcoX.^2));
%     feature(11)=sqrt(mean(acc.^2));
    feature(12)=mean(acc);
    feature(13)=max(accX)-min(accX);
%     feature(14)=std(accZ);
%     feature(15)=var(accZ);
%     feature(16)=var(gcoZ);
%     feature(17)=std(gcoZ);
%     feature(18)=var(diffX);
%     feature(19)=var(diffY);
%     feature(20)=var(diffZ);
    for i=1:8
        feature(20+i)=mean(emgData(1:len,i));
    end
    for i=1:8
        feature(28+i)=var(emgData(1:len,i));
    end
%     for i=1:8
%         power=emgData(1:len,i).*emgData(1:len,i);
%         feature(36+i)=sqrt(mean(power(:)));
%     end
%     feature(45)=max(gco)-min(gco);
%     feature(46)=var(diffGcoX);
%     feature(47)=var(diffGcoY);
%     feature(48)=var(diffGcoZ);
    feature=feature';
    feature(all(feature==0,2),:)=[];
    y=feature';
    
    
    
    
