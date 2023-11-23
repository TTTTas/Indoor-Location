function [Roll, Pitch]=Horiz_atti_ang(x,y,z)
    Roll=zeros(height(x),1);
    Pitch=zeros(height(x),1);
    for i=1:length(x)
        Roll(i,1)=atan2(-y(i),-z(i)); %#ok<*AGROW> 
        Pitch(i,1)=atan2(x(i),sqrt(z(i)*z(i)+y(i)*y(i)));
    end
end