%Creates a sparse matrix connecting neighboring pixels
%with edges containing a calculated weight
function A = image_edge_weights(I, sigma)
    [H, W] = size(I);
    E = edges4connected(H, W);
    N = H*W;
    I = double(I);
    
    V = exp(-(((I(E(:,1)) - I(E(:,2))).^2)/(2*(sigma).^2)));
    A = sparse(E(:,1),E(:,2),V,N,N,4*N);
end
