function regularizedImg = regularize(Image,t,window)
    offset=floor(window/2);
    [m,n,z]=size(Image);
    G0=fspecial('gaussian',2,1);%to smooth G matrix G-.G_{sigma}
    [x,y]=meshgrid(-2:2,-2:2);%coordinates of neighbourhood
    
    paddedImg = padarray(Image,[offset,offset]);
    Idx = double(zeros(m+2*offset,n+2*offset,3));
    Idy = double(zeros(m+2*offset,n+2*offset,3));
    
    for j=1:z
        [Idx(:,:,j),Idy(:,:,j)] = imgradientxy(paddedImg(:,:,j),'sobel');
    end
    Idx2=sum(Idx.^2,3);
    Idy2=sum(Idy.^2,3);
    Idxdy=sum(Idx.*Idy,3);

    for j=3:m+2
        for k=3:n+2
            G = [Idx2(j,k),Idxdy(j,k);Idxdy(j,k),Idy2(j,k)];
            Gs = imfilter(G,G0);
            [V,L] = eig(Gs);
            [eig_val,ind]=sort(diag(L), 'descend');
            V=V(:,ind);
            edge_perp = 1/(1+eig_val(1)+eig_val(2));%f+
            edge_para = 1/(sqrt(1+eig_val(1)+eig_val(2)));%f-

            T=edge_para*V(:,2)*V(:,2)' + edge_perp*V(:,1)*V(:,1)';
            Tinv=inv(T);
            Temp=-(x.^2*Tinv(1,1)+y.^2*Tinv(2,2)+x.*y*(Tinv(1,2)+Tinv(2,1)))/(4*t);
%             G_Tt = exp(Temp)/(4*pi*t);
            G_Tt = exp(Temp);
            G_Tt1 = G_Tt(max(1,6-j):min(end,1+m+2*offset-j),max(1,6-k):min(end,1+n+2*offset-k));
            G_Tt = G_Tt/sum(sum(G_Tt1));
            for l=1:3
                Temp = conv2(paddedImg(j-2:j+2,k-2:k+2,l),G_Tt,'same');
                paddedImg(j,k,l) = Temp(3,3);
            end
        end
    end
    regularizedImg = paddedImg(1+offset:m+offset,1+offset:n+offset,:);
end