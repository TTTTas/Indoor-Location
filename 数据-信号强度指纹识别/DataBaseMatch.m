clc,clear
%% 选择前k个点进行数据库匹配，关键参数，可直接修改
k=3;
%% 测试文件处理
testData=readlines("test1_with_ref.data");
testSet=[];
for i=1:length(testData)
    if testData(i)==""
        testData(i)=[];
        continue;
    end
    testbuff=str2double(split(testData(i)))';
    testbuff(isnan(testbuff))=[];
    testSet=[testSet;testbuff];
end

%% 将不属于丢失数据基站的数据的-110平滑掉，平滑方式采取直接等于最近历元的数据
DiscardIndex1=[5,6,8,9,12,13,14,16,21,22,24,28,30];
retainIndex1=2:31;
common_elements = intersect(retainIndex1, DiscardIndex1);
retainIndex1=setdiff(retainIndex1,common_elements);

index=1:31;
index(DiscardIndex1)=[];
for i=index
    for j=1:size(testSet,1)
        if testSet(j,i)==-110
            tempIndex=find(testSet(:,i)~=-110);
            [~,findIndex]=min(abs(tempIndex-j));
            RealIndex=tempIndex(findIndex);
            if isempty(testSet(RealIndex,i))
                a=0;
            end
            testSet(j,i)=testSet(RealIndex,i);
        end
    end
end
%% 生成每个参考点对应30个热点的信号强度的统计特征
DataBase=readlines("database.data");
tempSet=[];%临时数组
meanResult=[];
PvecSet=[];
%求每个参考点平均信号强度
for i=1:length(DataBase)
    if DataBase(i)==""
        DataBase(i)=[];
        continue;
    end
    buff=str2double(split(DataBase(i)))';
    buff(isnan(buff))=[];
    if i==1
        initial=buff;
        tempSet=[tempSet;initial];
        continue;
    end
    if buff(1)==initial(1)
        tempSet=[tempSet;buff];
    end
    if buff(1)~=initial(1) || i==length(DataBase)-1
        meanData=mean(tempSet,1);
        DIndex=find(meanData~=-110);%在初步求平均后，找到均值不为-110的值，去掉其中的-110后再做平均
        for j=DIndex
            tempData=tempSet(:,j);
            tempRes=mean(tempData(tempData~=-110));
            meanData(j)=tempRes;
        end
        meanResult=[meanResult;meanData];
        tempSet=[];
        tempSet=[tempSet,buff];
        initial=buff;
        %% 丢失数据处理，即均值为-110的可视为未采集到数据,这里需要丢弃的数据不仅要考虑每个参考点的，还要考虑整体test的
        DiscardIndex=find(meanData==-110);
        elements_to_add = setdiff(DiscardIndex1, DiscardIndex);
        DiscardIndex = [DiscardIndex, elements_to_add];
        retainIndex=1:31;
        common_elements = intersect(retainIndex, DiscardIndex);
        retainIndex=setdiff(retainIndex,common_elements);
        %% knn聚类算向量之间距离,注意仅考虑数据未丢失的基站即可
        retainIndex(1)=[];%把时间项去除掉
        PvecFortest=[];
        for m=1:size(testSet,1)%大循环是对每个参考点的处理，此处小循环是在已知参考点上对每个测试点处理
            vec=meanData(retainIndex)-testSet(m,retainIndex);
            Pvec=GaussDistri(vec);%可能性
            PvecFortest=[PvecFortest;Pvec];
        end
        PvecSet=[PvecSet,PvecFortest];
    end
end
[sortedValues, sortedIndices] = sort(PvecSet,2,"descend");
KSet = sortedIndices(:,1:k);
KlestValue=sortedValues(:,1:k);
retainWeight=KlestValue./sum(KlestValue,2);%反转，视其为权值
Amean=mean(meanResult,1);

%% 导入参考点坐标
referenceCor=readlines("rp_loc.txt");
CorRefSet=[];
for i=1:length(referenceCor)
    if referenceCor(i)==""
        referenceCor(i)=[];
        continue;
    end
    Corbuff=str2double(split(referenceCor(i)))';
    Corbuff(isnan(Corbuff))=[];
    CorRefSet=[CorRefSet;Corbuff];
end
testCorSet=[];
for i=1:size(testSet,1)
    testCor=sum(CorRefSet(KSet(i,:),2:4).*retainWeight(i,:)',1);%根据挑出的k个参考坐标和权值计算得到对应坐标
    testCorSet=[testCorSet;testCor];
end
figure(3);
plot(testSet(:,32),testSet(:,33),'b*-','LineWidth',1.5);
hold on;
plot(testCorSet(:,1),testCorSet(:,2),'r+-','LineWidth',1.5);
grid on;
xlim([-10, 15]); % 限定X轴范围为 [2, 8]
ylim([-2.5, 17]); % 限定Y轴范围为 [-1, 1]
xticks(-10:5:15); % 设置X轴刻度为 0 到 10，步长为 2
yticks(-2.5:2.5:17); % 设置Y轴刻度为 -1 到 1，步长为 0.5

function res=GaussDistri(vec)
%只有一行数据来做处理
res=1/norm(vec);
% for i=1:size(vec,2)
%     tempStd=stdData(i);
%     tempStd(tempStd==0)=0.01;
%     res=res+1/(tempStd*sqrt(2*pi))*exp(-vec(:,i).^2/(2*tempStd^2));
% end
end