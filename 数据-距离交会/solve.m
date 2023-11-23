%% 读取数据
clear all;
close all;
read;
%% 二维状态直接计算
data2D=Locat2D(basestationlocation,D2,D4,D6,D8);
figure(1)
patch(data2D(:,2),data2D(:,1),time,'MarkerSize',12,...
    'MarkerFaceColor','flat',...
    'Marker','.',...
    'LineWidth',1,...
    'FaceColor','none',...
    'EdgeColor','flat')
axis equal;grid on;colorbar
hold on
scatter(basestationlocation(:,2),basestationlocation(:,3),'MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0]);
xlim([-1 23]);
ylim([-11 13]);
%% 三维计算、高程约束
[data3D,thegma,t]=Locat3D(basestationlocation,D2,D4,D6,D8,H,time);
figure(2)
patch(data3D(:,2),data3D(:,1),t,'MarkerSize',12,...
    'MarkerFaceColor','flat',...
    'Marker','.',...
    'LineWidth',1,...
    'FaceColor','none',...
    'EdgeColor','flat')
axis equal;grid on;colorbar
hold on
scatter(basestationlocation(:,2),basestationlocation(:,3),'MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0]);
xlim([-1 23]);
ylim([-11 13]);
%% 三维计算、零偏、高程约束
data4D=Locat4D(basestationlocation,D2,D4,D6,D8,H);
%% 
for i=1:length(D2)-1
    dD2(i)=D2(i+1)-D2(i);
    dD4(i)=D4(i+1)-D4(i);
    dD6(i)=D6(i+1)-D6(i);
    dD8(i)=D8(i+1)-D8(i);
    dH(i)=H(i+1)-H(i);
end
%% 
function data = Locat2D(base,D2,D4,D6,D8)
    B=[]; %#ok<*NASGU> 
    l=[];
    X=[0;0];%E/N
    x=[];
    for i=1:length(D2)
        for j=1:4
            len1=sqrt((base(1,3)-X(1,1))*(base(1,3)-X(1,1))+(base(1,2)-X(2,1))*(base(1,2)-X(2,1)));
            len2=sqrt((base(2,3)-X(1,1))*(base(2,3)-X(1,1))+(base(2,2)-X(2,1))*(base(2,2)-X(2,1)));  
            len3=sqrt((base(2,3)-X(1,1))*(base(3,3)-X(1,1))+(base(3,2)-X(2,1))*(base(3,2)-X(2,1)));
            len4=sqrt((base(4,3)-X(1,1))*(base(4,3)-X(1,1))+(base(4,2)-X(2,1))*(base(4,2)-X(2,1)));
            B=[-(base(1,3)-X(1,1))/len1,-(base(1,2)-X(2,1))/len1;
               -(base(2,3)-X(1,1))/len2,-(base(2,2)-X(2,1))/len2;
               -(base(3,3)-X(1,1))/len3,-(base(3,2)-X(2,1))/len3;
               -(base(4,3)-X(1,1))/len4,-(base(4,2)-X(2,1))/len4];
            l=[D2(i)-len1;D4(i)-len2;D6(i)-len3;D8(i)-len4];
            x=(B.'*B)^-1*B.'*l;
            X=X+x;
        end
        data(i,1:2)=X.'; %#ok<*AGROW> 
    end
end
%% 
function data = Locat4D(base,D2,D4,D6,D8,H)
    clear data;
    B=[]; %#ok<*NASGU> 
    l=[];
    X=[0;0;0;0];%E/N
    x=[];
    count=0;
    for i=1:length(D2)
        X0=X;
%         X=[0;0;0;0];
        flag = true;
        for j=1:4
            len1=sqrt((base(1,3)-X0(1,1))*(base(1,3)-X0(1,1))+(base(1,2)-X0(2,1))*(base(1,2)-X0(2,1))+(base(1,6)-X0(3,1))*(base(1,6)-X0(3,1)));
            len2=sqrt((base(2,3)-X0(1,1))*(base(2,3)-X0(1,1))+(base(2,2)-X0(2,1))*(base(2,2)-X0(2,1))+(base(2,6)-X0(3,1))*(base(1,6)-X0(3,1)));  
            len3=sqrt((base(2,3)-X0(1,1))*(base(3,3)-X0(1,1))+(base(3,2)-X0(2,1))*(base(3,2)-X0(2,1))+(base(3,6)-X0(3,1))*(base(1,6)-X0(3,1)));
            len4=sqrt((base(4,3)-X0(1,1))*(base(4,3)-X0(1,1))+(base(4,2)-X0(2,1))*(base(4,2)-X0(2,1))+(base(4,6)-X0(3,1))*(base(1,6)-X0(3,1)));
            B=[-(base(1,3)-X0(1,1))/len1,-(base(1,2)-X0(2,1))/len1,-(base(1,6)-X0(3,1))/len1,1;
               -(base(2,3)-X0(1,1))/len2,-(base(2,2)-X0(2,1))/len2,-(base(2,6)-X0(3,1))/len2,1;
               -(base(3,3)-X0(1,1))/len3,-(base(3,2)-X0(2,1))/len3,-(base(3,6)-X0(3,1))/len3,1;
               -(base(4,3)-X0(1,1))/len4,-(base(4,2)-X0(2,1))/len4,-(base(4,6)-X0(3,1))/len4,1;
               0,0,1, 0];
            l=[D2(i)-len1-X0(4,1);D4(i)-len2-X0(4,1);D6(i)-len3-X0(4,1);D8(i)-len4-X0(4,1);H(i)-X0(3,1)];
            x=(B.'*B)^-1*B.'*l;
            X0=X0+x;
        end
        v=B*x-l;
        C_v=eye(5,5)-B*(B.'*B)^-1*B.';
        thegma=sqrt((v.'*v));
        for j=1:5
            v(j)=v(j)/(thegma*sqrt(abs(C_v(j,j))));
            if abs(v(j))>1.96
                flag=false;
            end
        end
        %if flag==true
            count = count+1;
            X=X0;
            data(count,1:4)=X.'; %#ok<*AGROW> 
        %end
    end
end
%% 
function [data, thegma, t] = Locat3D(base,D2,D4,D6,D8,H,time)
    clear data;
    B=[]; %#ok<*NASGU> 
    l=[];
    X=[0;0;0];%E/N
    x=[];
    count=0;
    for i=1:length(D2)
        X0=X;
        flag = true;
        for j=1:4
            len1=sqrt((base(1,3)-X0(1,1))*(base(1,3)-X0(1,1))+(base(1,2)-X0(2,1))*(base(1,2)-X0(2,1))+(base(1,6)-X0(3,1))*(base(1,6)-X0(3,1)));
            len2=sqrt((base(2,3)-X0(1,1))*(base(2,3)-X0(1,1))+(base(2,2)-X0(2,1))*(base(2,2)-X0(2,1))+(base(2,6)-X0(3,1))*(base(1,6)-X0(3,1)));  
            len3=sqrt((base(2,3)-X0(1,1))*(base(3,3)-X0(1,1))+(base(3,2)-X0(2,1))*(base(3,2)-X0(2,1))+(base(3,6)-X0(3,1))*(base(1,6)-X0(3,1)));
            len4=sqrt((base(4,3)-X0(1,1))*(base(4,3)-X0(1,1))+(base(4,2)-X0(2,1))*(base(4,2)-X0(2,1))+(base(4,6)-X0(3,1))*(base(1,6)-X0(3,1)));
            B=[-(base(1,3)-X0(1,1))/len1,-(base(1,2)-X0(2,1))/len1,-(base(1,6)-X0(3,1))/len1;
               -(base(2,3)-X0(1,1))/len2,-(base(2,2)-X0(2,1))/len2,-(base(2,6)-X0(3,1))/len2;
               -(base(3,3)-X0(1,1))/len3,-(base(3,2)-X0(2,1))/len3,-(base(3,6)-X0(3,1))/len3;
               -(base(4,3)-X0(1,1))/len4,-(base(4,2)-X0(2,1))/len4,-(base(4,6)-X0(3,1))/len4;
               0,0,1];
            l=[D2(i)-len1;D4(i)-len2;D6(i)-len3;D8(i)-len4;H(i)-X0(3,1)];
            x=(B.'*B)^-1*B.'*l;
            X0=X0+x;
        end
        v=B*x-l;
        C_v=eye(5,5)-B*(B.'*B)^-1*B.';
        thegma0=sqrt((v.'*v));
        thegma(i)=thegma0;
        for j=1:5
            v(j)=v(j)/(thegma0*sqrt(abs(C_v(j,j))));
            if abs(v(j))>1.28
                flag=false;
            end
        end
        if flag==true&&thegma0<2
            count = count+1;
            X=X0;
            data(count,1:3)=X.'; %#ok<*AGROW> 
            t(count)=time(i);
        end
    end
end