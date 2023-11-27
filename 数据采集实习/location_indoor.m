clear;
clc;
[pos_xm, pos_ym, pos_zm, D1, D2, D3, D4, D5, D6, omegax, omegay, omegaz, fx, fy, fz, angle_xdeg, angle_ydeg, angle_zdeg, time]=importfile("data1.xlsx");
%% 基站坐标
base=[
6.29,10.26;
6.18,05.24;
6.05,00.89;
1.08,09.87;
1.30,05.60;
1.07,01.12];
%% 距离交会
[pos,time_after]=Locat2D(base,[D1,D2,D3,D4,D5,D6],time,1);
Locat2D(base,[D1,D2,D3,D4,D5,D6],time,2);
Locat2D(base,[D1,D2,D3,D4,D5,D6],time,3);
%% PDR
start_pos=pos(1,:);
start_index=find(time==time_after(1));
pos_PDR=Cal_PDR(start_pos,-90,0.07,omegax(start_index+1:end),omegay(start_index+1:end),omegaz(start_index+1:end)+0.0033,fx(start_index+1:end),fy(start_index+1:end),fz(start_index+1:end),time(start_index:end)*1e-3,9.63);
