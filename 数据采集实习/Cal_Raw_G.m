function Yaw_G=Cal_Raw_G(x,y,z,Roll,Pitch,start_ang,t)
    Psi=deg2rad(start_ang);
    Yaw_G=zeros(length(x),1);
    for i=1:length(x)
        Cnb=[cos(Pitch(i)),sin(Roll(i))*sin(Pitch(i)),cos(Roll(i))*sin(Pitch(i));
            0,cos(Roll(i)),-sin(Roll(i));
            -sin(Pitch(i)),sin(Roll(i))*cos(Pitch(i)),cos(Roll(i))*cos(Pitch(i))];
        omega=Cnb*[x(i);y(i);z(i)];   
        Psi=Psi+omega(3,1)*(t(i+1)-t(i));
        if Psi>pi
            Psi=Psi-2*pi;
        end
        if Psi<-pi
            Psi=Psi+2*pi;
        end
        Yaw_G(i,1)=Psi;
    end
end