# NUS-EE5731-Projects(Visual Computing)
2 projects for EE5731 courses, Visual Computing, in NUS, detailed requirements are in attached PDF. Images and video resources are available by links in PDF.

# Project1
## Part1: Gaussian Kernel, Sobel Kernel and Haar-like masks
### Sobel Kernel
<img width="286" alt="image" src="https://user-images.githubusercontent.com/60777462/201929616-ff77176e-eadb-40f0-988f-51948a5485e6.png"><img width="288" alt="image" src="https://user-images.githubusercontent.com/60777462/201929730-31aa0892-e43a-4ca3-b6ca-a55fc6498934.png">
### Gaussian Kernel
<img width="299" alt="image" src="https://user-images.githubusercontent.com/60777462/201930499-851c07d6-69b4-4c2d-8614-0b10e8e41265.png"><img width="286" alt="image" src="https://user-images.githubusercontent.com/60777462/201930533-94744fe4-4809-452a-b6ee-d85f84525b6f.png">
### Haar-like masks
<img width="281" alt="image" src="https://user-images.githubusercontent.com/60777462/201930900-10975946-747d-4967-8a00-d880c71ee641.png"><img width="285" alt="image" src="https://user-images.githubusercontent.com/60777462/201931284-57102d09-b07f-4c31-8679-b80a70391875.png">

## Part2: SIFT features and descriptors
<img width="273" alt="image" src="https://user-images.githubusercontent.com/60777462/201931404-0f96a7b4-71f0-4792-bf65-65b1f81b2a6a.png"><img width="288" alt="image" src="https://user-images.githubusercontent.com/60777462/201931502-55faa53f-f25f-45c0-9d4a-4f1b497e5a62.png">
  
## Part3: Homography matirx and transform a image
<img width="384" alt="image" src="https://user-images.githubusercontent.com/60777462/201931721-2476c43c-de6b-453e-8a1d-bb94b0379864.png"><img width="278" alt="image" src="https://user-images.githubusercontent.com/60777462/201932712-6d1d3ddb-4b72-41d8-ab8f-ebc048c4ed24.png">

## Part4: Manual homography and stitching 2 images
<img width="292" alt="image" src="https://user-images.githubusercontent.com/60777462/201934977-b5e9bded-ae8d-48ba-860f-71e54dea26f6.png"><img width="384" alt="image" src="https://user-images.githubusercontent.com/60777462/201931857-bee52360-77fe-42bf-8061-3cb7ab773eaf.png">

## Part5: Homography using RANSAC


## Part6: Basic panoramic image



## Part6: Basic panoramic image
Part7: Advanced panoramic image(orderless).  

# Project2  
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
