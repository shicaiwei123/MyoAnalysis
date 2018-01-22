%% ��ʼ��
close all
clear all
species=0;
%% ��ȡ����
emgRead=xlsread('emg.xlsx');
imuRead=xlsread('imu.xlsx');
timeEmg=emgRead(:,9);
timeImu=imuRead(:,11);
emgData=emgRead(:,1:8);
imuData=imuRead(:,5:10);

 %% ������ֵ
% ����
% ��ֵѡ��40
% ������ʱ25���жϻ
% ������ʱ10�����ж�ֹͣ
% emg��ֵ
% len=5;
% times=fix(length(emgRead)/len);  %ѭ������
% emgThreshold=[];
% %����ƽ��ʱ�̵���ֵ���
% for j=1:times
%     emgSeg=emgData((j-1)*5+1:(j-1)*5+len,:)/100;
%     emgThreshold(j)=engery(emgSeg);
%     emgThreshold=emgThreshold';
% end
% ���ٶ���ֵ
% dur=5;
% times=fix(length(imuRead)/dur);  %ѭ������
% imuThresholdX=[];
% imuThresholdY=[];
% imuThresholdZ=[];
% ����ƽ��ʱ�̵���ֵ���
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

%% �ָ�
%��ʼ0.1s�����ݲ�Ҫ����ʱ����IMU��EMG��������ƥ��
%Ѱ��������ʼ��
timeBegin=timeEmg(1); %һ����emg������������emg������Ϊ��ʼ��ʶ
%ѭ���ȽϺ�����������һ����ĵ�һ�����ݵ�ʱ�䵱����ʼʱ��
timeBegin=fix(timeBegin*10);
j=1;
while(1)
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
%�ָ�����
dur=5; 
%y��ֵ
threshold=50;
%���ݳ���
lenImu=length(imuData(imuNumBegin:end,:));
imuData=imuData(imuNumBegin:end,:);
lenEmg=length(emgData(emgNumBegin:end,:));
emgData=emgData(emgNumBegin:end,:);
len=min(lenImu,lenEmg);
%������;�ֹ�Ĵ���
active=1;
quiet=1;
%���������ݻ���
%emgAna---emgAnalysis
emgAna=zeros(200,8);
imuAna=zeros(200,6);
%�ָ�
imuNum=imuNumBegin;
emgNum=emgNumBegin;
emgCache=zeros(dur,8);
imuCache=zeros(dur,6);
seqCounter=1;
i=1;
%���ݻ���Ĵ���
dataTimes=1;
while(1)
    if(i>dur) %������dur������
        emgAna((dataTimes-1)*dur+1:dataTimes*dur,:)=emgCache;
        imuAna((dataTimes-1)*dur+1:dataTimes*dur,:)=imuCache;
        dataTimes=dataTimes + 1;
        E=engery(emgCache);
        if(E>=threshold)
            active=active+1;
        else
            quiet=quiet+1;
        end
        if(quiet>2)%�Ѿ�ƽ��
             if(active>5)   %�ﵽ���˶��ı�׼��������ȡ�����¼�¼
                 w.emgData=emgAna;           
                 w.imuData=imuData;
                 w.len=dataTimes;
                 w.lables='��';           %���ݴ��棬lables���ݲ�ͬ�������޸�
                 str=num2str(seqCounter+species); %Ϊ�˲�ͬ�����ݼ��洢�Ĳ���ͻ������һ������Ĳ�ֵ������Ҫ�޸ĵĵط���
                 save(str,'w');
                                          %������ȡ
                 seqCounter=seqCounter+1;
                 dataTimes=1;
                 active=1;
             else           %û�дﵽ��׼������ټ�¼
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
    if(imuNum>len||emgNum>len)  %������ݶ����˾�ͷ����ô��ֹͣ
        break;
    end
    i=i+1;
end
 



        







