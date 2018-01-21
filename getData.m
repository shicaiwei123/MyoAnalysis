%% 初始化
close all
clear all
%% 读取数据
emgRead=xlsread('emg.xlsx');
imuRead=xlsread('imu.xlsx');
%% 计算阈值
%结论
%阈值选择300
%持续计时25点判断活动
%持续计时15个点判断停止
%emg阈值
len=5;
timeEmg=emgRead(:,9);
timeImu=imuRead(:,11);
emgData=emgRead(:,1:8);
imuData=imuRead(:,5:10);
times=fix(length(emgRead)/len);  %循环次数
emgThreshold=[];
%计算平稳时刻的阈值情况
for j=1:times
    emgSeg=emgData((j-1)*5+1:(j-1)*5+len,:)/100;
    emg=[];
    for i=1:8
        emgPower=emgSeg.*emgSeg;
        emg(i)=sum(emgPower(:));
    end
    sumEmg=sum(emg(:));
    emgThreshold(j)=sumEmg/len;
    emgThreshold=emgThreshold';
end
%加速度阈值
%平稳状态下，标准差为0到2的范围,和不同的人无关

times=fix(length(imuRead)/len);  %循环次数
imuThresholdX=[];
imuThresholdY=[];
imuThresholdZ=[];
%计算平稳时刻的阈值情况
for j=1:times
    imuSegX=imuData((j-1)*5+1:(j-1)*5+len,1)/20;
    imuSegY=imuData((j-1)*5+1:(j-1)*5+len,2)/20;
    imuSegZ=imuData((j-1)*5+1:(j-1)*5+len,3)/20;
    imuDiffX=diff(imuSegX);
    imuDiffY=diff(imuSegY);
    imuDiffZ=diff(imuSegZ);
    imuX=std(imuDiffX);
    imuY=std(imuDiffY);
    imuZ=std(imuDiffZ);
    imuThresholdX(j)=imuX;
    imuThresholdY(j)=imuY;
    imuThresholdZ(j)=imuZ;
end

%% 分割
%开始0.1s的数据不要，此时可能IMU和EMG数据量不匹配
%寻找数据起始点
timeBegin=timeEmg(1); %一般是emg会慢，所以以emg的数据为起始标识
%循环比较毫秒数，把下一毫秒的第一个数据的时间当做起始时间
timeBegin=fix(timeBegin*10);
while(1)
    j=1;
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





        







