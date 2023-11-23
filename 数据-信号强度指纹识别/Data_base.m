clear all
close all
%% 
read
%% 
meanbase=mean(database,1);
usedbaseIndex=[];
count=0;
for i=2:31
    if meanbase(i)>-100
        count=count+1;
        usedbaseIndex(count)=i-1;
    end
end
Index=[1]; %#ok<NBRAK2> 
for i=1:length(database)
    Index(database(i,1)+1)=i;
    for j=1:length(usedbaseIndex)
        if database(i,usedbaseIndex(j)+1)==-110
            database(i,usedbaseIndex(j)+1)=nan;
        end
    end
end
for i=1:97
    for j=1:30
        base(i,j)=mean(database(Index(i):Index(i+1),j+1),1,"omitnan");
        thegma(i,j)=std(database(Index(i):Index(i+1),j+1),1,"omitnan");
    end
end
%% 
for j=1:length(usedbaseIndex)
    for i=1:height(OBS_DATA)
        if OBS_DATA(i,usedbaseIndex(j)+1)==-110
            id=find(OBS_DATA(:,usedbaseIndex(j)+1)~=-110);
            [~,tempid]=min(abs(id-i));
            OBS_DATA(i,usedbaseIndex(j)+1)=OBS_DATA(id(tempid),usedbaseIndex(j)+1);
        end
    end
end
%% 
for i=1:length(OBS_DATA)
    p=Gauss(OBS_DATA(i,:),base,thegma,usedbaseIndex);
    pos(i,1:2)=Cal_Pos(p,Ref_E,Ref_N,3);
end
%% 
plot(OBS_DATA(:,32),OBS_DATA(:,33),'b*-','LineWidth',1.5);
hold on;
plot(pos(:,1),pos(:,2),'r^-','LineWidth',1.5);
grid on;
xlim([-10, 15]);
ylim([-2.5, 17]); 
axis equal;
%% 
function Likelihood=Gauss(data,base,thegma,Index)
    for i=1:97
        p=1;
        for j=1:length(Index)
            if data(Index(j)+1)~=-110&&~isnan(base(i,Index(j)))&&base(i,Index(j))~=-110&&~isnan(thegma(i,Index(j)))&&thegma(i,Index(j))~=0
                 p=p*exp((-(data(Index(j)+1)-base(i,Index(j)))^2)/(2*thegma(i,Index(j))^2))/(thegma(i,Index(j))*sqrt(2*pi)); %#ok<*AGROW>
                 %p=p+(data(Index(j)+1)-base(i,Index(j)))*(data(Index(j)+1)-base(i,Index(j)));
            end
        end
        Likelihood(i)=p*p;
    end
end
%% 
function pos=Cal_Pos(p,E,N,k)
    sum=0;
    pos=[0,0];
    for i=1:k
        [l,index]=max(p);
        p(index)=[];
        pos(1,1)=pos(1,1)+l*E(index);
        pos(1,2)=pos(1,2)+l*N(index);
        sum=sum+l;
    end
    pos=pos/sum;
end