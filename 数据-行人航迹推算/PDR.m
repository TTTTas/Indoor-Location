clear all;
close all;
read;
%% 
drawdata([omegax,omegay,omegaz],[fx,fy,fz],[Mx,My,Mz],time);
%% 
[Roll,Pitch,meanRoll,meanPitch]=Horiz_atti_ang(fx,fy,fz);
draw_horiz_angle(time,rad2deg([Roll,Pitch]),rad2deg([meanRoll,meanPitch]));
%% 
Yaw_M=Cal_Raw_M(Mx,My,Mz,meanRoll,meanPitch,14.11); 
Yaw_G=Cal_Raw_G(deg2rad(omegax),deg2rad(omegay),deg2rad(omegaz),Roll,Pitch,-90,0.05);
%% 
draw_Yaw(time,[Yaw_M,Yaw_G]);
%% 
len=Len(fx,fy,fz);
[Step_Mark,Time_Mark]=Detect_step(len,9.2,time);
%% 
% plot(time,len)
% hold on
% scatter(Time_Mark(:,1),Time_Mark(:,2),"*");
%% 
Point_M=Cal_PDR(Yaw_M,0.7/4,Step_Mark);
Point_G=Cal_PDR(Yaw_G,0.7/4,Step_Mark);
%% 
draw_PDR1(Point_G,Point_M);
%% 
omegaz_comp=omegaz+0.308;
Yaw_G_comp=Cal_Raw_G(deg2rad(omegax),deg2rad(omegay),deg2rad(omegaz_comp),Roll,Pitch,-90,0.05);
% draw_Yaw(time,[Yaw_M,Yaw_G_comp]);
Point_G_comp=Cal_PDR(Yaw_G_comp,0.7/4,Step_Mark);
draw_PDR1(Point_G_comp,Point_M);
%% 
function drawdata(YMatrix1, YMatrix2, YMatrix3, time)    
    % 创建 figure
    figure1 = figure('WindowState','maximized');
    
    % 创建 subplot
    subplot1 = subplot(3,1,1,'Parent',figure1);
    hold(subplot1,'on');
    
    % 使用 plot 的矩阵输入创建多个 line 对象
    plot1 = plot(time,YMatrix1,'Parent',subplot1);
    set(plot1(1),'DisplayName','omegax');
    set(plot1(2),'DisplayName','omegay');
    set(plot1(3),'DisplayName','oemgaz');
    
    % 创建 ylabel
    ylabel({'deg/s'});
    
    % 创建 xlabel
    xlabel({'time/s'});
    
    % 创建 title
    title({'GYO Data'});
    
    box(subplot1,'on');
    hold(subplot1,'off');
    % 创建 legend
    legend1 = legend(subplot1,'show');
    set(legend1,...
        'Position',[0.853679338168737 0.863012875483235 0.0687134493556287 0.0612002360239953]);
    
    % 创建 subplot
    subplot2 = subplot(3,1,2,'Parent',figure1);
    hold(subplot2,'on');
    
    % 使用 plot 的矩阵输入创建多个 line 对象
    plot2 = plot(time,YMatrix2,'Parent',subplot2);
    set(plot2(1),'DisplayName','fx');
    set(plot2(2),'DisplayName','fy');
    set(plot2(3),'DisplayName','fz');
    
    % 创建 ylabel
    ylabel({'m·s^{-2}'});
    
    % 创建 xlabel
    xlabel({'time/s'});
    
    % 创建 title
    title({'Accelerometer Data'});
    
    box(subplot2,'on');
    hold(subplot2,'off');
    % 创建 legend
    legend2 = legend(subplot2,'show');
    set(legend2,...
        'Position',[0.887670565509103 0.565924343100585 0.0442251459918699 0.0612002360239949]);
    
    % 创建 subplot
    subplot3 = subplot(3,1,3,'Parent',figure1);
    hold(subplot3,'on');
    
    % 使用 plot 的矩阵输入创建多个 line 对象
    plot3 = plot(time,YMatrix3,'Parent',subplot3);
    set(plot3(1),'DisplayName','Mx');
    set(plot3(2),'DisplayName','My');
    set(plot3(3),'DisplayName','Mz');
    
    % 创建 ylabel
    ylabel({'mGauss'});
    
    % 创建 xlabel
    xlabel({'time/s'});
    
    % 创建 title
    title({'Megnetometers'});
    
    box(subplot3,'on');
    hold(subplot3,'off');
    % 创建 legend
    legend3 = legend(subplot3,'show');
    set(legend3,...
    'Position',[0.878533138750121 0.272995050171292 0.0489766078385683 0.0612002360239952]);
end
%% 
function [Roll, Pitch,mean_Roll,mean_Pitch]=Horiz_atti_ang(x,y,z)
    for i=1:length(x)
        Roll(i,1)=atan2(-y(i),-z(i)); %#ok<*AGROW> 
        Pitch(i,1)=atan2(x(i),sqrt(z(i)*z(i)+y(i)*y(i)));
        if i<=21
            mean_Roll(i,1)=mean(Roll);
            mean_Pitch(i,1)=mean(Pitch);
        end
        if i>21
            mean_Roll(i,1)=mean(Roll(i-20:i,1));
            mean_Pitch(i,1)=mean(Pitch(i-20:i,1));
        end
    end
end
%% 
function draw_horiz_angle(X1, YMatrix1, YMatrix2)
    % 创建 figure
    figure2 = figure('WindowState','maximized');
    
    % 创建 subplot
    subplot1 = subplot(2,1,1,'Parent',figure2);
    hold(subplot1,'on');
    
    % 使用 plot 的矩阵输入创建多个 line 对象
    plot1 = plot(X1,YMatrix1,'Parent',subplot1);
    set(plot1(1),'DisplayName','Pitch');
    set(plot1(2),'DisplayName','Roll');
    
    % 创建 ylabel
    ylabel({'deg'});
    
    % 创建 xlabel
    xlabel({'time/s'});
    
    % 创建 title
    title({'Horizontal angle without smoothing'});
    
    box(subplot1,'on');
    hold(subplot1,'off');
    % 创建 legend
    legend(subplot1,'show');
    
    % 创建 subplot
    subplot2 = subplot(2,1,2,'Parent',figure2);
    hold(subplot2,'on');
    
    % 使用 plot 的矩阵输入创建多个 line 对象
    plot2 = plot(X1,YMatrix2,'Parent',subplot2);
    set(plot2(1),'DisplayName','Pitch');
    set(plot2(2),'DisplayName','Roll');
    
    % 创建 ylabel
    ylabel({'deg'});
    
    % 创建 xlabel
    xlabel({'time/s'});
    
    % 创建 title
    title({'Horizontal angle'});
    
    box(subplot2,'on');
    hold(subplot2,'off');
    % 创建 legend
    legend(subplot2,'show');
end
%% 
function [Yaw_M]=Cal_Raw_M(x,y,z,Roll,Pitch,D)
    clear Yaw_M
    for i=1:length(x)
        Cnb=[cos(Pitch(i)),sin(Roll(i))*sin(Pitch(i)),cos(Roll(i))*sin(Pitch(i));
            0,cos(Roll(i)),-sin(Roll(i));
            -sin(Pitch(i)),sin(Roll(i))*cos(Pitch(i)),cos(Roll(i))*cos(Pitch(i))];
        m=Cnb*[x(i);y(i);z(i)];
        Psi=-atan2(m(2,1),m(1,1))+deg2rad(D);
        if Psi>pi
            Psi=Psi-2*pi;
        end
        if Psi<-pi
            Psi=Psi+2*pi;
        end
        Yaw_M(i,1)=Psi;
    end
end
%% 
function [Yaw_G]=Cal_Raw_G(x,y,z,Roll,Pitch,D,t)
    clear Yaw_G
    Psi=deg2rad(D);
    for i=1:length(x)
        Cnb=[cos(Pitch(i)),sin(Roll(i))*sin(Pitch(i)),cos(Roll(i))*sin(Pitch(i));
            0,cos(Roll(i)),-sin(Roll(i));
            -sin(Pitch(i)),sin(Roll(i))*cos(Pitch(i)),cos(Roll(i))*cos(Pitch(i))];
        omega=Cnb*[x(i);y(i);z(i)];   
        Psi=Psi+omega(3,1)*t;
        if Psi>pi
            Psi=Psi-2*pi;
        end
        if Psi<-pi
            Psi=Psi+2*pi;
        end
        Yaw_G(i,1)=Psi;
    end
end
%% 
function draw_Yaw(X1, YMatrix1)
    %CREATEFIGURE(X1, YMatrix1)
    %  X1:  plot x 数据的向量
    %  YMATRIX1:  plot y 数据的矩阵
    
    %  由 MATLAB 于 25-Oct-2023 16:28:27 自动生成
    
    % 创建 figure
    figure3 = figure('WindowState','maximized');
    
    % 创建 axes
    axes1 = axes('Parent',figure3);
    hold(axes1,'on');
    
    % 使用 plot 的矩阵输入创建多个 line 对象
    plot1 = plot(X1,YMatrix1,'LineWidth',1);
    set(plot1(1),'DisplayName','Yaw_M');
    set(plot1(2),'DisplayName','Yaw_G','LineStyle','--','Color',[1 0 0]);
    
    % 创建 ylabel
    ylabel({'deg'});
    
    % 创建 xlabel
    xlabel({'time/s'});
    
    % 创建 title
    title({'Yaw from magnetometers and Gyro'});
    
    box(axes1,'on');
    hold(axes1,'off');
    % 创建 legend
    legend(axes1,'show');
end
%% 
function len=Len(x,y,z)
    for i=1:length(x)
        len(i,1)=sqrt(x(i)*x(i)+y(i)*y(i)+z(i)*z(i));
    end
end
%% 
function [Step,mark]=Detect_step(len,threshold,time)
    count=0;
    for i=1:length(len)
        if len(i,1)<threshold
            count = count+1;
            Step(count,1)=i;
            mark(count,1)=time(i);
            mark(count,2)=len(i);
        end
    end
end
%% 
function Point=Cal_PDR(Yaw,step_len,mark)
    p=[0;0];
    for i=1:length(mark)
        p=p+step_len*[sin(Yaw(mark(i)));cos(Yaw(mark(i)))];
        Point(i,1:2)=p;
    end
end
%% 
function draw_PDR1(XMatrix1, YMatrix1)
    %CREATEFIGURE(XMatrix1, YMatrix1)
    %  XMATRIX1:  plot x 数据的矩阵
    %  YMATRIX1:  plot y 数据的矩阵
    
    %  由 MATLAB 于 25-Oct-2023 17:32:17 自动生成
    
    % 创建 figure
    figure4 = figure('WindowState','maximized');
    
    % 创建 axes
    axes1 = axes('Parent',figure4);
    hold(axes1,'on');
    
    % 使用 plot 的矩阵输入创建多个 line 对象
    plot(XMatrix1(:,1),XMatrix1(:,2),'LineWidth',2,'DisplayName','P_G')
    hold on
    plot(YMatrix1(:,1),YMatrix1(:,2),'LineWidth',2,'DisplayName','P_M','LineStyle','--','Color',[1 0 0])
    % 创建 ylabel
    ylabel({'North/m'});
    
    % 创建 xlabel
    xlabel({'East/m'});
    
    % 创建 title
    title({'PDR result from magnetometers and Gyro'}); 

    xlim(axes1,[-222.666830408279 146.785861315438]);
    ylim(axes1,[-178.037750685239 60.9539194427453]);
    box(axes1,'on');
    grid(axes1,'on');
    hold(axes1,'off');
    % 设置其余坐标区属性
    set(axes1,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',...
        [184.726345861859 119.495835063992 1]);
    % 创建 legend
    legend(axes1,'show');
end