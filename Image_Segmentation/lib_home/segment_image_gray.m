%1-background 0-foreground
function S = segment_image_gray(I, F, B, sigma)

    [H,W] = size(I);

    I = double(I);
    
    J = image_edge_weights(I, sigma);
    T = sparse(H*W,2);
    
    for i = 1:(H*W)
       
        if(F(i) == 1)
           T(i,1) = 100;
        end
        if(B(i) == 1)
           T(i,2) = 100;
        end
    end
    
    [flow,labels] = maxflow(J,T);
    S = reshape(labels, [H,W]);
end