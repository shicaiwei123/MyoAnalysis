%% 初始化
clear all
close all

%% 特征提取
trainFeature=[];
lab={};
for i=1:132
    str=num2str(i);
    data=load(str);
    data=data.w;
    feature=featureGet(data.emgData,data.imuData,data.len);
    trainFeature=vertcat(trainFeature,feature);
    lab(i)=cellstr(data.lables);
end
for i=141:202
    str=num2str(i);
    data=load(str);
    data=data.w;
    feature=featureGet(data.emgData,data.imuData,data.len);
    trainFeature=vertcat(trainFeature,feature);
    lab(i-8)=cellstr(data.lables);
end
for i=221:331
    str=num2str(i);
    data=load(str);
    data=data.w;
    feature=featureGet(data.emgData,data.imuData,data.len);
    trainFeature=vertcat(trainFeature,feature);
    lab(i-26)=cellstr(data.lables);
end

for i=341:361
    str=num2str(i);
    data=load(str);
    data=data.w;
    feature=featureGet(data.emgData,data.imuData,data.len);
    trainFeature=vertcat(trainFeature,feature);
    lab(i-35)=cellstr(data.lables);
end

trainData=array2table(trainFeature);
trainData.labels=(lab');

