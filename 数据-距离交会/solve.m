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
[data3D,thegma,t,Dop3d,e3d]=Locat3D(basestationlocation,D2,D4,D6,D8,H,time);
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
figure(3)
hold on
plot(t,Dop3d(:,1),'LineWidth',2,'DisplayName','DOP_{hor}','LineStyle','-');
plot(t,Dop3d(:,2),'LineWidth',2,'DisplayName','DOP_{ver}','LineStyle','--');
plot(t,Dop3d(:,3),'LineWidth',2,'DisplayName','DOP_{pos}','LineStyle',':');
grid on
legend
xlabel("Time/s")
ylabel("DOP")
title("距离交会定位DOP值")
%% 
figure(4)
hold on
plot(t,e3d(:,1),'LineWidth',2,'DisplayName','a_1','LineStyle','-');
plot(t,e3d(:,2),'LineWidth',2,'DisplayName','a_2','LineStyle','--');
plot(t,e3d(:,3),'LineWidth',2,'DisplayName','{\Psi}','LineStyle',':');
grid on
legend
xlabel("Time/s")
ylabel("误差椭圆参数")
title("距离交会定位误差椭圆")
%% 三维计算、零偏、高程约束
[data4D,t4D]=Locat4D(basestationlocation,D2,D4,D6,D8,H,time);
figure(4)
patch(data4D(:,2),data4D(:,1),t4D,'MarkerSize',12,...
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
%% 
figure(5)
subplot(3,1,1)
hold on
plot(t,data3D(:,1),'LineStyle','-','LineWidth',2,'DisplayName','无零偏修正-N') 
plot(t4D,data4D(:,1),'LineStyle','--','LineWidth',2,'DisplayName','有零偏修正-N')
xlabel("Time/s")
ylabel("N/m")
title("北向坐标对比")
grid on
legend
subplot(3,1,2)
hold on
plot(t,data3D(:,2),'LineStyle','-','LineWidth',2,'DisplayName','无零偏修正-E')
plot(t4D,data4D(:,2),'LineStyle','--','LineWidth',2,'DisplayName','有零偏修正-E')
xlabel("Time/s")
ylabel("E/m")
title("东向坐标对比")
grid on
legend
subplot(3,1,3)
hold on
plot(t,data3D(:,3),'LineStyle','-','LineWidth',2,'DisplayName','无零偏修正-H')
plot(t4D,data4D(:,3),'LineStyle','--','LineWidth',2,'DisplayName','有零偏修正-H')
xlabel("Time/s")
ylabel("H/m")
title("高程对比")
grid on
legend
%% 
[data11, thegma11, t11]=Locat3D_diff(basestationlocation,[D2,D4,D6,D8],time);
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
function [data,t] = Locat4D(base,D2,D4,D6,D8,H,time)
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
            v=B*x-l;
            C_v=eye(5,5)-B*(B.'*B)^-1*B.';
            thegma=sqrt((v.'*v));
            for k=1:5
                V=v(k)/(thegma*sqrt(abs(C_v(k,k))));
                if abs(V)>1.96
                    flag=false;
                end
            end
        end
        if flag==true&&thegma<2
            count = count+1;
            X=X0;
            data(count,1:4)=X.'; %#ok<*AGROW> 
            t(count)=time(i);
        end
    end
end
%% 
function [data, thegma, t,Dop,e] = Locat3D(base,D2,D4,D6,D8,H,time)
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
            [Dop(count,1:3),e(count,1:3)]=Cal_DOP(B);
        end
    end
end
%% 
function [Dop,e]=Cal_DOP(H)
    P=(H.'*H)^-1;
    Dop(1,1)=sqrt(P(1,1)+P(2,2));
    Dop(1,2)=sqrt(P(3,3));
    Dop(1,3)=sqrt(P(1,1)+P(2,2)+P(3,3));
    e(1,1)=sqrt(0.5*(P(1,1)+P(2,2))+sqrt(0.25*(P(1,1)-P(2,2))^2+P(1,2)^2));
    e(1,2)=sqrt(0.5*(P(1,1)+P(2,2))-sqrt(0.25*(P(1,1)-P(2,2))^2+P(1,2)^2));
    e(1,3)=0.5*atan2(2*P(1,2),P(2,2)-P(1,1));
end
%% 
function [data, thegma, t] = Locat3D_diff(base,D,time)
    clear data;
    B=[]; %#ok<*NASGU> 
    l=[];
    X=[0;0;0];%E/N
    x=[];
    count=0;
    base=[base(:,3),base(:,2),base(:,6)];
    for i=1:length(D)
        X0=X;
        flag = true;
        for j=1:4
            num=0;
            for k=1:4
                for m=k+1:4
                    num=num+1;
                    len1=norm(base(k,:)-X0.');
                    len2=norm(base(m,:)-X0.');
                    B(num,:)=(-(base(k,:)-X0.')/len1)-(-(base(m,:)-X0.')/len2);
                    l(num,1)=D(i,k)-len1-(D(i,m)-len2);
                end
            end
            x=(B.'*B)^-1*B.'*l;
            X0=X0+x;
        end
        v=B*x-l;
        C_v=eye(num,num)-B*(B.'*B)^-1*B.';
        thegma0=sqrt((v.'*v));
        thegma(i)=thegma0;
        for j=1:num
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
