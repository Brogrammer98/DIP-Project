function dIdt = flowVisualize(Image,Field)
%     neighbourhood = 5;
    [X,Y,Z] = size(Image);
    red_chan=Image(:,:,1);
    green_chan=Image(:,:,2);
    blue_chan=Image(:,:,3);
    
%     red_chan=padarray(red_chan,[offset,offset]);
%     green_chan=padarray(green_chan,[offset,offset]);
%     blue_chan=padarray(blue_chan,[offset,offset]);
    
    [Ixred,Iyred]=gradient(red_chan);
    [Ixxred,Ixyyred]=gradient(Ixred);
    [~,Iyyred]=gradient(Iyred);
    
    [Ixgreen,Iygreen]=gradient(green_chan);
    [Ixxgreen,Ixyygreen]=gradient(Ixgreen);
    [~,Iyygreen]=gradient(Iygreen);
    
    [Ixblue,Iyblue]=gradient(blue_chan);
    [Ixxblue,Ixyyblue]=gradient(Ixblue);
    [~,Iyyblue]=gradient(Iyblue);
 
    denoisedImageR = double(zeros(X,Y));
    denoisedImageG = double(zeros(X,Y));
    denoisedImageB = double(zeros(X,Y));
    for i=1:X
        for j=1:Y  
            
            F=[Field(i,j,1);Field(i,j,2)];
            T=(F*F')/norm(F);
            
            H_red=[Ixxred(i,j),Ixyyred(i,j);Ixyyred(i,j),Iyyred(i,j)];
            H_green=[Ixxgreen(i,j),Ixyygreen(i,j);Ixyygreen(i,j),Iyygreen(i,j)];
            H_blue=[Ixxblue(i,j),Ixyyblue(i,j);Ixyyblue(i,j),Iyyblue(i,j)];
       
            denoisedImageR(i,j)=trace(T*H_red);
            denoisedImageG(i,j)=trace(T*H_green);
            denoisedImageB(i,j)=trace(T*H_blue);
            
        end 
    end
    
    dIdt = cat(3,denoisedImageR,denoisedImageG,denoisedImageB);
end