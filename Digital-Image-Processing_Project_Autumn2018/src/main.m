clear;
close all;
tic;

%% Image denoising
% kSize = 5;
% sigma = 0.66;
% t = [1,5,10];
% window=5;
% 
% imname = ["baboon.png","child.png","desert.png","face.jpg","monkey.png"];
% smoothK = fspecial('gaussian', [kSize,kSize],sigma);
% 
% for i=1:size(imname,2)
%     origImage = imread(char(strcat('../input/',imname(i))));
%     smoothImage = im2double(imfilter(origImage,smoothK));
% 
%     % displayimage(origImage,char(strcat('original ',imname)));
%     for m=1:size(t,2)
%         h=waitbar(0,"denoising image...");
%         smoothImage1 = regularize(smoothImage,t(m),window);
%         close(h);
%     %     displayimage(smoothImage1,char(strcat(strcat('denoised image ',imname),strcat(' t=',string(t(m))))));
%         imwrite(smoothImage1,char(strcat(strcat('../output/denoised_t=',string(t(m))),strcat('_',imname(i)))));
%     end
% end

%% Image Inpainting
t = 50;
iter = 150;
window=5;

imname = ["old_uncle.jpg"];%,"pup_with_text.jpg","inpaintBirdCageReduced.jpg","inpaintParrotCage.jpg","4.jpg"];
maskname = ["old_mask.jpg"];%"text_mask.jpg","birdCageMaskReduced.jpg","parrotCageMask.jpg","mask.png"];
% imname = ["inpaintParrotCage.jpg"];
% maskname = ["parrotCageMask.jpg"];

for k=1:size(imname,2)
    origImage = imread(char(strcat('../input/',imname(k))));
    mask=imread(char(strcat('../input/',maskname(k))));
    smoothImage=im2double(origImage);

    for i=1:size(origImage,1)
        for j=1:size(origImage,2)
            if(mask(i,j)>=128)
                smoothImage(i,j,:)=1.0;
            end
        end
    end

    h=waitbar(0,"inpainting image...");
    displayimage(smoothImage,char(strcat('masked_',imname(k))));
%     displayimage(mask,char(strcat('original ',maskname)));

    for i=1:iter
        smoothImage1 = inpaint(smoothImage,t,window,mask);
        if (mod(i,10)==0)
    %         displayimage(smoothImage1,char(strcat(strcat('inpainted image ',imname),strcat(' iteration=',string(i)))));
            imwrite(smoothImage1,char(strcat(strcat('../output/inpainted_iteration=',string(i)),strcat('_',imname(k)))));
        end
        smoothImage = smoothImage1;
        waitbar(i/iter);
    end
    close(h);
    % displayimage(smoothImage1,char(strcat('inpainted image ',imname)));
    imwrite(smoothImage1,char(strcat('../output/inpainted_',imname(k))));
end

% %% Magnification
% kSize = 5;
% sigma = 0.66;
% t = 5;
% window=10;
% scalling = [3,4,10];
% smoothK = fspecial('gaussian', [kSize,kSize],sigma);
% 
% imname = ["resize1.jpg","resize2.jpg"];
% 
% for i=1:size(imname,2)
%     origImage = imread(char(strcat('../input/',imname(i))));
% %     displayimage(origImage,char(strcat('original ',imname(i))));
% 
%     for s=1:size(scalling,2)
%         h=waitbar(0,"Magnifying image...");
%         superscaledImg = imresize(origImage,scalling(s),'bilinear');
%         smoothImage = im2double(imfilter(superscaledImg,smoothK));
% 
% %         displayimage(smoothImage,char(strcat(strcat('nearestneighbour magnified image ',imname(i)),strcat(' factor=',string(scalling(s))))));
%         imwrite(smoothImage,char(strcat(strcat('../output/nearestneighbourmagnified_factor=',string(scalling(s))),strcat('_',imname(i)))));
%         smoothImage1 = regularize(smoothImage,t,window);
%         close(h);
% %         displayimage(smoothImage1,char(strcat(strcat('our magnified image ',imname(i)),strcat(' factor=',string(scalling(s))))));
%         imwrite(smoothImage,char(strcat(strcat('../output/ourmagnified_nearestneighbour_factor=',string(scalling(s))),strcat('_',imname(i)))));
%     end
% end

% a = [0.00     0.00     0.00     9.00     9.00     9.00;
%      0.01     0.01     0.01     9.01     9.01     9.01;
%      0.02     0.02     0.02     9.02     9.02     9.02;
%      0.03     0.03     0.03     9.03     9.03     9.03;
%      0.04     0.04     0.04     9.04     9.04     9.04;
%      0.05     0.05     0.05     9.05     9.05     9.05];
% 
% a = cat(3,a,a,a);
% a = im2double(a);
% b = regularize(a,5,5);

% %% Flow Visualization
% kSize = 5;
% timeslice=0.01;
% t = 5;
% imname=["face"];
% 
% for l=1:size(imname,2)
%     origImage = imread(char(strcat(strcat('../input/',imname(l)),'.jpg')));
%     smoothK = fspecial('gaussian', [kSize,kSize],0.66);
%     smoothImage = imfilter(origImage,smoothK);
%     [x,y,z] = size(origImage);
%     displayimage(origImage,char(strcat(imname(l),'original')));
%     
%     name_of_fields=["Field1","Field3","Field2"];
%     
%     Field1 = double(zeros(x,y,3));
%     for i = 1:x
%         for j = 1:y
%             Field1(i,j,1)=3*sign(i-(x/2));
%             Field1(i,j,2)=3*sign(j-(y/2));
%             Field1(i,j,3)=0;
%         end
%     end
%     
%     
%     h=waitbar(0,char(strcat(imname(l),name_of_fields(1))));
%     for i=0:timeslice:t
%         temp=flowVisualize(im2double(smoothImage),Field1);%returns dI/dt
%         smoothImage = im2double(smoothImage)+timeslice*temp;
%         if (mod(uint16(i*100),100)==0 && i~=0) 
%             displayimage(smoothImage,char(strcat(imname(l),strcat(name_of_fields(1),strcat('between',string(i))))));
%         end
%         waitbar(i/t);
%     end
%     close(h);
%     smoothImage = imfilter(origImage,smoothK);
%     
%     Field3 = double(zeros(x,y,3));
%     for i = 1:x
%         for j = 1:y
%             Field3(i,j,1)=0.1*(j-(y/2));
%             Field3(i,j,2)=-0.1*(i-(x/2));
%             Field3(i,j,3)=0;
%         end
%     end
%     
%     h=waitbar(0,char(strcat(imname(l),name_of_fields(2))));
%     for i=0:timeslice:t
%         temp=flowVisualize(im2double(smoothImage),Field3);%returns dI/dt
%         smoothImage = im2double(smoothImage)+timeslice*temp;
%         if (mod(uint16(i*100),100)==0 && i~=0) 
%             displayimage(smoothImage,char(strcat(imname(l),strcat(name_of_fields(2),strcat('between',string(i))))));
%         end
%         waitbar(i/t);
%     end
%     close(h);
%     smoothImage = imfilter(origImage,smoothK);
%     
%     Field2 = double(zeros(x,y,3));
%     for i = 1:x
%         for j = 1:y
%             Field2(i,j,1)=0.1*(i-(x/2));
%             Field2(i,j,2)=-0.1*(j-(y/2));
%             Field2(i,j,3)=0;
%         end
%     end
%     h=waitbar(0,char(strcat(imname(l),name_of_fields(3))));
%     for i=0:timeslice:t
%         temp=flowVisualize(im2double(smoothImage),Field2);%returns dI/dt
%         smoothImage = im2double(smoothImage)+timeslice*temp;
%         if (mod(uint16(i*100),100)==0 && i~=0) 
%             displayimage(smoothImage,char(strcat(imname(l),strcat(name_of_fields(3),strcat('between',string(i))))));
%         end
%         waitbar(i/t);
%     end
%     close(h);
% end
% toc;