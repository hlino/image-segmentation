% Abstract: 
% This GUI script will open a small window that will allow the user
% to segement forground objects in a picture by selecting background 
% and forground objects. 
% -----------------------------------------------
% GUI Function Descriptions:
% - 'Load Image' within the current directory. (src_image_Callback)
% - 'Select Background' mark a region as background (sel_bg_Callback)
% - 'Select Forground' mark a region as foreground  (sel_fg_Callback)
% - 'Run Segmentation' calls appropriate segmentation (run_seg_Callback)
% - 'Clear All' remove the variables set in 'base' (clear_Callback)
% - Setup establishes GUI buttons and reinitalized parameters (setup_GUI)
% - Constructor, primarily calls setup_GUI; repetitive (GUI)
% -----------------------------------------------
% Limitations:
% - File retrieval is only within the current directory.
% - Limited error checking on loaded images, required data, etc... 
% - All required functions should be within the current directory.
% - Selections made outside of target image will be canceled
% - You should select atleast (1) foreground and (1) background region
% -----------------------------------------------

% GUI(): 
% Initialization of the GUI Function.
function GUI
    % Setup Global Variables - Use Globals Sparingly!
    global fileName; fileName = 0;
    global I; I = 0;
    global F; F = [];
    global B; B = [];
    global lambda; lambda = 1;
    global sigma; sigma = 20;
    % Create and hide the GUI as it is being constructed.
    f = figure('Visible','off','Position',[100,100,1024,500]);
    % Call the 
    setup_GUI();
	% Make the GUI visible.
    set(f,'Visible','on')
end
% End of GUI()

% src_image_Callback():
% Used in 'Load Image' to load and display an image if possible.
function src_image_Callback(~, ~)
    global fileName;
    global I;
    global F;
    global B;
    % Call file selector
    fileName = uigetfile('*.jpg','Select the image file');
    % Check that there is a file
    if ~ischar(fileName)
            %error('No file selected');
    else
        % Clear the UI by calling setup_GUI()
        setup_GUI();
        I = imread(fileName);
        F = zeros(size(I,1), size(I,2));
        B = zeros(size(I,1), size(I,2));
        % Display the image
        subplot(1,1,1), imshow(I);
        title('Target Image');
    end;
    return;
end
% End of src_image_Callback()

% sel_bg_Callback():
% Used to tag pixels as background
function sel_bg_Callback(~, ~)
    global fileName;
    global B;
    global I;
    if (fileName ~= 0)
        rect = floor(getrect);
        if (rect(1,2) < 0 || rect(1,1) < 0 || rect(1,4) <= 0 || rect(1,3) <= 0 || (rect(1,2) + rect(1,4) - 1) > size(I, 1) ||(rect(1,1) + rect(1,3) - 1) > size (I, 2) )
            return;
        end
        for i = rect(1,2): (rect(1,2) + rect(1,4) - 1)
            %Y Loop
            for j = rect(1,1): (rect(1,1) + rect(1,3) - 1)
                %X Loop
                B(i,j) = 1;
            end
        end
        hold on
        drawnRectangleBG = rectangle('Position', rect, 'FaceColor','k');
        hold off
    end
    return;
end
% End of sel_bg_Callback()

% sel_fg_Callback():
% Used to tag pixels as foreground
function sel_fg_Callback(~, ~)
    global fileName;
    global F;
    global I;
    if (fileName ~= 0)
       rect = floor(getrect);
       if (rect(1,2) < 0 || rect(1,1) < 0 || rect(1,4) <= 0 || rect(1,3) <= 0 || (rect(1,2) + rect(1,4) - 1) > size(I, 1) ||(rect(1,1) + rect(1,3) - 1) > size (I, 2) )
            return;
       end
       for i = rect(1,2): (rect(1,2) + rect(1,4) - 1)
            %Y Loop
            for j = rect(1,1): (rect(1,1) + rect(1,3) - 1)
                %X Loop
                F(i,j) = 1;
            end
        end
       hold on
       drawnRectangleFG = rectangle('Position', rect, 'FaceColor','r');
       hold off
    end
    return;
end
% End of sel_fg_Callback()

% run_seg_Callback():
% Run segmentation functions
function run_seg_Callback(~, ~)
    global fileName;
    global F;
    global B;
    global I;
    global lambda;
    global sigma;
    if (fileName ~= 0)
        if size(I, 3) == 1
            S = segment_image_gray(I, F, B, sigma);
        else
            S = segment_image_color(I, F, B, lambda, sigma);
        end
        % Display the image
        figure, imshow(uint8(255*S));
        title('Segmented Image');
    end
end
% End of run_seg_Callback()

% clear_Callback():
% Clears base by calling setup_GUI() - sort of redundent
function clear_Callback(~, ~)
    global fileName; fileName = 0;
    global I; I = 0;
    global F; F = [];
    global B; B = [];
    global lambda; lambda = 1;
    global sigma; sigma = 20;
    setup_GUI();
end
% End of clear_Callback()

% setup_GUI():
% Clear base, builds buttons, and links callback functions.
function setup_GUI
    clf;
    %  Construct the components.
    src_image = uicontrol('Style','pushbutton','String','Load Image',...
           'Position',[10,450,110,25],...
           'Callback', {@src_image_Callback});  
    sel_bg = uicontrol('Style','pushbutton','String','Select Background',...
           'Position',[10,425,110,25],...
           'Callback', {@sel_bg_Callback});
    sel_fg = uicontrol('Style','pushbutton','String','Select Foreground',...
           'Position',[10,400,110,25],...
           'Callback', {@sel_fg_Callback});
    run_seg = uicontrol('Style','pushbutton','String','Run Segmentation',...
           'Position',[10,375,110,25],...
           'Callback', {@run_seg_Callback});     
	clear = uicontrol('Style','pushbutton','String','Clear All',...
           'Position',[10,350,110,25],...
           'Callback', {@clear_Callback});
    align([src_image, sel_bg, sel_fg, run_seg, clear],'Center','None');
end
% End of setup_GUI()
