# NUS-EE5731-Projects
2 projects for EE5731 courses, Visual Computing, in NUS, detailed requirements are in attached PDF. Images and video resources are available by links in PDF.

## Project1
Part1: Gaussian Kernel, Sobel Kernel and Haar-like masks.   
Part2: SIFT features and descriptors.   
Part3: Homography matirx and transform a image.   
Part4: Manual homography and stitching 2 images.  
Part5: Homography using RANSAC.   
Part6: Basic panoramic image.  
Part7: Advanced panoramic image(orderless).  

## Project2  
Part1: Noise removal.   
Part2: Depth from rectified stereo images.   
Part3: Depth from  stereo.   
Part4: Depth from video.    

original readme
This is assignment 2 for Visual Computing. 

For each folder it has code and result for each part, before running code GCMex folder and its subfolder should be added to path in fear that GCMex fail to be added to path in the program. ifSome results are kept in their folder which can be checked without running the code. The results are illustrated in my project. 

If the last parameter is set as 1, Matlab will breakdown at maci64 system. If set as 0, it will be fine. However, the result will not be that good when the parameter is 0 for multilabel situation. This assignment was did in anothor win64 computer instead. 

part1.m runs for several seconds, the value of lambda can be set in the code to show different results. 

part2.m runs about 40 second firstly, then 20s for a figure of different lambda value. Lambda, disparity and labelcost can be adjusted easily to obtain different results.  

part3.m runs for about 80s, some results are kept in this folder. 

before running part4.m, a folder named with output should be created and added to path to receive generated each frame. For each frame, it takes about 4.5 minutes to generate, so the total time of generate 140 frames need 11 hours. 
