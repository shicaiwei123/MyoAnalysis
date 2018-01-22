%% 初始化
close all
clear all
species=0;
%% 读取数据
emgRead=xlsread('emg.xlsx');
imuRead=xlsread('imu.xlsx');
timeEmg=emgRead(:,9);
timeImu=imuRead(:,11);
emgData=emgRead(:,1:8);
imuData=imuRead(:,5:10);

 %% 计算阈值
% 结论
% 阈值选择40
% 持续计时25点判断活动
% 持续计时10个点判断停止
% emg阈值
% len=5;
% times=fix(length(emgRead)/len);  %循环次数
% emgThreshold=[];
% %计算平稳时刻的阈值情况
% for j=1:times
%     emgSeg=emgData((j-1)*5+1:(j-1)*5+len,:)/100;
%     emgThreshold(j)=engery(emgSeg);
%     emgThreshold=emgThreshold';
% end
% 加速度阈值
% dur=5;
% times=fix(length(imuRead)/dur);  %循环次数
% imuThresholdX=[];
% imuThresholdY=[];
% imuThresholdZ=[];
% 计算平稳时刻的阈值情况
% for j=1:times
%     imuSegX=imuData((j-1)*dur+1:(j-1)*dur+dur,1)/20;
%     imuSegY=imuData((j-1)*dur+1:(j-1)*dur+dur,2)/20;
%     imuSegZ=imuData((j-1)*dur+1:(j-1)*dur+dur,3)/20;
%     imuDiffX=diff(imuSegX);
%     imuDiffY=diff(imuSegY);
%     imuDiffZ=diff(imuSegZ);
%     imuX=var(imuDiffX);
%     imuY=var(imuDiffY);
%     imuZ=var(imuDiffZ);
%     imuThresholdX(j)=imuX;
%     imuThresholdY(j)=imuY;
%     imuThresholdZ(j)=imuZ;
% end

%% 分割
%开始0.1s的数据不要，此时可能IMU和EMG数据量不匹配
%寻找数据起始点
timeBegin=timeEmg(1); %一般是emg会慢，所以以emg的数据为起始标识
%循环比较毫秒数，把下一毫秒的第一个数据的时间当做起始时间
timeBegin=fix(timeBegin*10);
j=1;
while(1)
    if(fix(timeEmg(j))*10 >= timeBegin+1)
        timeBegin=timeEmg(j);
        emgNumBegin=j+1;
        while(1)  %寻找imu数据的开始点
            j=1;
            if(fix(timeImu(j))*10 >= timeBegin)
                imuNumBegin=j;
                break;
            end
            j=j+1;
        end
        break;
    end
    j=j+1;
end

%分割数据
%分割区间
dur=5; 
%y阈值
threshold=50;
%数据长度
lenImu=length(imuData(imuNumBegin:end,:));
imuData=imuData(imuNumBegin:end,:);
lenEmg=length(emgData(emgNumBegin:end,:));
emgData=emgData(emgNumBegin:end,:);
len=min(lenImu,lenEmg);
%计量活动和静止的次数
active=1;
quiet=1;
%待分析数据缓存
%emgAna---emgAnalysis
emgAna=zeros(200,8);
imuAna=zeros(200,6);
%分割
imuNum=imuNumBegin;
emgNum=emgNumBegin;
emgCache=zeros(dur,8);
imuCache=zeros(dur,6);
seqCounter=1;
i=1;
%数据缓存的次数
dataTimes=1;
while(1)
    if(i>dur) %缓存了dur个数据
        emgAna((dataTimes-1)*dur+1:dataTimes*dur,:)=emgCache;
        imuAna((dataTimes-1)*dur+1:dataTimes*dur,:)=imuCache;
        dataTimes=dataTimes + 1;
        E=engery(emgCache);
        if(E>=threshold)
            active=active+1;
        else
            quiet=quiet+1;
        end
        if(quiet>2)%已经平静
             if(active>5)   %达到了运动的标准，特征提取，重新记录
                 w.emgData=emgAna;           
                 w.imuData=imuData;
                 w.len=dataTimes;
                 w.lables='三';           %数据储存，lables根据不同的数据修改
                 str=num2str(seqCounter+species); %为了不同种数据集存储的不冲突，加上一个种类的差值，是需要修改的地方。
                 save(str,'w');
                                          %特征提取
                 seqCounter=seqCounter+1;
                 dataTimes=1;
                 active=1;
             else           %没有达到标准，清空再记录
                 dataTimes=1; 
                 active=1;
             end
             quiet=1;
        end
        i=1;
    end
             
    emgCache(i,:)=emgData(emgNum,:)/100;
    imuCache(i,:)=imuData(imuNum,:)/20;
    emgNum=emgNum+1;
    imuNum=imuNum+1;
    if(imuNum>len||emgNum>len)  %如果数据读到了尽头，那么就停止
        break;
    end
    i=i+1;
end
 



        







