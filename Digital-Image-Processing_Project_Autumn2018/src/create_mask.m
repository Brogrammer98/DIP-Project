function mask=create_mask(img,n)
    [a,b,c]=size(img);
    
    mask=double(zeros(a,b));
    mask=checkerboard(n,a/(2*n),b/(2*n));
    mask(mask(:,:)>0)=1;
end