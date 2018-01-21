%% ��ʼ��
close all
clear all
%% ��ȡ����
emgRead=xlsread('emg.xlsx');
imuRead=xlsread('imu.xlsx');
%% ������ֵ
%����
%��ֵѡ��300
%������ʱ25���жϻ
%������ʱ15�����ж�ֹͣ
%emg��ֵ
len=5;
timeEmg=emgRead(:,9);
timeImu=imuRead(:,11);
emgData=emgRead(:,1:8);
imuData=imuRead(:,5:10);
times=fix(length(emgRead)/len);  %ѭ������
emgThreshold=[];
%����ƽ��ʱ�̵���ֵ���
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
%���ٶ���ֵ
%ƽ��״̬�£���׼��Ϊ0��2�ķ�Χ,�Ͳ�ͬ�����޹�

times=fix(length(imuRead)/len);  %ѭ������
imuThresholdX=[];
imuThresholdY=[];
imuThresholdZ=[];
%����ƽ��ʱ�̵���ֵ���
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

%% �ָ�
%��ʼ0.1s�����ݲ�Ҫ����ʱ����IMU��EMG��������ƥ��
%Ѱ��������ʼ��
timeBegin=timeEmg(1); %һ����emg������������emg������Ϊ��ʼ��ʶ
%ѭ���ȽϺ�����������һ����ĵ�һ�����ݵ�ʱ�䵱����ʼʱ��
timeBegin=fix(timeBegin*10);
while(1)
    j=1;
    if(fix(timeEmg(j))*10 >= timeBegin+1)
        timeBegin=timeEmg(j);
        emgNumBegin=j+1;
        while(1)  %Ѱ��imu���ݵĿ�ʼ��
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

%�ָ�����





        







