# NUS-EE5731-Projects
2 projects for EE5731 courses, Visual Computing, in NUS, detailed requirements are in attached PDF. Images and video resources are available by links in PDF.

README for project2  
This is assignment 2 for Visual Computing. 

For each folder it has code and result for each part, before running code GCMex folder and its subfolder should be added to path in fear that GCMex fail to be added to path in the program. ifSome results are kept in their folder which can be checked without running the code. The results are illustrated in my project. 

I have found that, if the last parameter is set as 1, Matlab will breakdown at maci64 system. it will be fine, if set as 0. However, the result will not be that good when the parameter is 0 for multilabel situation. So I did this assignment in anothor win64 computer instead. 

part1.m runs for several seconds, the value of lambda can be set in the code to show different results. 

part2.m runs about 40 second firstly, then 20s for a figure of different lambda value. Lambda, disparity and labelcost can be adjusted easily to obtain different results.  

part3.m runs for about 80s, some results are kept in this folder. 

before running part4.m, a folder named with output should be created and added to path to receive generated each frame. For each frame, it takes about 4.5 minutes to generate, so the total time of generate 140 frames need 11 hours. 
