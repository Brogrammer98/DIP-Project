% function displayimage(img,name)
%     RI = imref2d(img);
%     figure(),imshow(mat2gray(img),RI);
%     title(name);    
% end

            
function displayimage(s1,res)
    myNumOfColors = 256;
    myColorScale = zeros(myNumOfColors,3);
    myColorScale(:,1) = 0:1/(myNumOfColors-1):1;% ,[0:1/(myNumOfColors-1):1] ,[0:1/(myNumOfColors-1):1]  ];
    myColorScale(:,2) = 0:1/(myNumOfColors-1):1;
    myColorScale(:,3) = 0:1/(myNumOfColors-1):1;
    figure();
    imagesc((s1));
    axis on;
    title(res); 
    imwrite(s1,char(strcat('../output/',strcat(res,'.jpg'))));
    
    if size(s1,3)==1
%         colormap jet;
        colormap (myColorScale);
        colorbar;
    end
    daspect ([1 1 1]);
    axis tight;
    drawnow;
end