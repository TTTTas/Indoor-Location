function Pos=Cal_PDR(start_pos,start_ang,step_len,omegax, omegay, omegaz, fx, fy, fz,time,thresh)
    [Roll, Pitch]=Horiz_atti_ang(fx,fy,fz);
    Yaw=Cal_Raw_G(omegax, omegay, omegaz,Roll,Pitch,start_ang,time);
    [mark,~]=Detect_step(vecnorm([fx,fy,fz],2,2),thresh,time(2:end));
    Pos=zeros(length(mark),2);
    p=start_pos;
    for i=1:length(mark)
        p=p+step_len*[sin(Yaw(mark(i))),cos(Yaw(mark(i)))];
        Pos(i,1:2)=p;
    end
    figure;
    patch(Pos(:,1),Pos(:,2),time(mark),'MarkerSize',12,...
    'MarkerFaceColor','flat',...
    'Marker','.',...
    'LineWidth',1,...
    'FaceColor','none',...
    'EdgeColor','flat')
    axis equal;grid on;colorbar
end