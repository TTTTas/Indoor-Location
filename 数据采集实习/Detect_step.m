function [Step,mark]=Detect_step(len,threshold,time)
    count=0;
    Step=zeros(length(len),1);
    mark=zeros(length(len),2);
    for i=1:length(len)
        if len(i,1)<threshold
            count = count+1;
            Step(count,1)=i;
            mark(count,1)=time(i);
            mark(count,2)=len(i);
        end
    end
    Step(count+1:end,:)=[];
    mark(count+1:end,:)=[];
%     figure
%     plot(time,len)
%     hold on
%     scatter(mark(:,1),mark(:,2),"*");
end