function S = segment_image_color(I, F, B, lambda, sigma)

    %making the bin size 51 so each has intervals from:
    %0-50 -> 1
    %51-102 -> 2
    %103-153 -> 3
    %154-205 -> 4
    %206-255 -> 5
    %total number of bins s 5^3 = 125
    %Each histogram will be stored as a 5x5x5 matrix
    %the rgb value divided by 51 rounded up to find its location in the
    %matrix, r -> x, g -> y, b -> z
    
    [H,W,D] = size(I);

    constant = (H*W)/(20*125);
    
    Histo_B(1:5,1:5,1:5) = constant;
    Histo_F(1:5,1:5,1:5) = constant;
    
    %goes through the given fore and background and constructs the
    %histograms
    for i = 1:H
        for j = 1:W
            
            if(F(i,j) == 1)
                
               rd = double(I(i,j,1));
               gd = double(I(i,j,2));
               bd = double(I(i,j,3));
               
               r = ceil(rd/51);
               g = ceil(gd/51);
               b = ceil(bd/51);
               
               %if rgb value is 0 round up to 1
               %beacuse 0 is out of bounds
               if(r == 0)
                    r = 1;
               end
               if(g == 0)
                   g = 1;
               end
               if(b == 0)
                   b = 1;
               end
               
               Histo_F(r,g,b) = Histo_F(r,g,b) +1;
            end
            if(B(i,j) == 1)
                
               rd = double(I(i,j,1));
               gd = double(I(i,j,2));
               bd = double(I(i,j,3));
               
               r = ceil(rd/51);
               g = ceil(gd/51);
               b = ceil(bd/51);
               
               if(r == 0)
                    r = 1;
               end
               if(g == 0)
                   g = 1;
               end
               if(b == 0)
                   b = 1;
               end
               
               Histo_B(r,g,b) = Histo_B(r,g,b) +1;
            end
        end
    end
    
    %normalizes the histograms
    Histo_F_normal = Normalize_3D_matrix(Histo_F);
    Histo_B_normal = Normalize_3D_matrix(Histo_B);
    
    %goes through the image and looks up for the particular pixel value what
    %the probability is that it belongs to the foreground and background 
    %then adds the edges with calculated weight to a sparse tree
    % finally performs the min cut algorithm
    A = sparse((H*W),2);
    counter = 1;
    for j = 1:W
        for i = 1:H 
            
           rd = double(I(i,j,1));
           gd = double(I(i,j,2));
           bd = double(I(i,j,3));

           r = ceil(rd/51);
           g = ceil(gd/51);
           b = ceil(bd/51);
           
               if(r == 0)
                    r = 1;
               end
               if(g == 0)
                   g = 1;
               end
               if(b == 0)
                   b = 1;
               end
           
           A(counter, 1) = -lambda*log(Histo_F_normal(r, g, b));
           A(counter, 2) = -lambda*log(Histo_B_normal(r, g, b));
           
           counter = counter+1;
        end
    end
   
    BWI = rgb2gray(I);
    B = image_edge_weights(BWI, sigma);
    
    [flow,labels] = maxflow(B,A);
    S = reshape(labels, [H,W]);
end

%Helper function normalizes the given matrix
function r = Normalize_3D_matrix(M)
    
    s = sum(sum(sum(M)));
    M = M / s;
    r = M;
end