function [data,t] = Locat2D(base,D,time,thresh)
    B=zeros(width(D),2);
    l=zeros(width(D),1);
    data=zeros(height(D),2);
    t=zeros(height(D),1);
    X=[0;0];%E/N
    x=[0;0]; 
    count=0;
    for i=1:length(D)
        X0=X;
        flag = true;
        for j=1:4
            for k=1:width(D)
                len=norm(base(k,:)-X0.');
                B(k,:)=-(base(k,:)-X0.')/len;
                l(k,1)=D(i,k)-len;
            end
            x=(B.'*B)^-1*B.'*l;
            X0=X0+x;
        end
        v=B*x-l;
        C_v=eye(width(D),width(D))-B*(B.'*B)^-1*B.';
        thegma0=sqrt((v.'*v));
        for j=1:width(D)
            v(j)=v(j)/(thegma0*sqrt(abs(C_v(j,j))));
            if abs(v(j))>1.28
                flag=false;
            end
        end
        if flag==true&&thegma0<thresh
            count = count+1;
            X=X0;
            data(count,:)=X.';
            t(count)=time(i);
        end
    end
    data(count+1:end,:)=[];
    t(count+1:end,:)=[];
    figure;
    patch(data(:,1),data(:,2),t,'MarkerSize',12,...
    'MarkerFaceColor','flat',...
    'Marker','.',...
    'LineWidth',1,...
    'FaceColor','none',...
    'EdgeColor','flat')
    axis equal;grid on;colorbar
    hold on
    scatter(base(:,1),base(:,2),'MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0]);
end