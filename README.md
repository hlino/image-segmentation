# Image Segmentation

This is an implementation of an image segmentation program which segments 
an image's foreground and background written in matlab. The program uses an implementation of max-flow/min-cut 
using Boykov-Kolmogorov's algorithm written in c++ with a wrapper for matlab.

# Files:

edges4connected.m:<br>
This file creates edges where each node
is connected to its four adjacent neighbors on a 
height x width grid.

GUI_student.m:<br>
This is a GUI script will open a small window that will allow the user
to segement forground objects in a picture by selecting background 
and forground objects.

image_edge_weights.m:<br>
Containes one function which creates a sparse matrix 
connecting the graph vertices with calculated weights.

make.m:<br>
Compiles the max flow algorithm.

maxlfow.m:<br>
Contains the implementation of the max-flow/min-cut algorithm.

segment_image_color.m:<br>
Creates a sparse tree and calculates weights for each pixel connecting them
to each other, foreground, and background. Then utilizes the min-cut algorithm 
to segment the forground and background for a RGB piture.

segment_image_gray.m:<br>
Takes similar steps as segment_image_color.m but for a gray scale image. This makes the
process more simple.




