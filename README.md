# NUS-EE5731-Projects(Visual Computing)
2 projects for EE5731 courses, Visual Computing, in NUS, detailed requirements are in attached PDF. Images and video resources are available by links in PDF.

# Project1
## Part1: Gaussian Kernel, Sobel Kernel and Haar-like masks
### Sobel Kernel
<img width="477" alt="image" src="https://user-images.githubusercontent.com/60777462/201929616-ff77176e-eadb-40f0-988f-51948a5485e6.png"><img width="480" alt="image" src="https://user-images.githubusercontent.com/60777462/201929730-31aa0892-e43a-4ca3-b6ca-a55fc6498934.png">
### Gaussian Kernel
<img width="499" alt="image" src="https://user-images.githubusercontent.com/60777462/201930499-851c07d6-69b4-4c2d-8614-0b10e8e41265.png"><img width="476" alt="image" src="https://user-images.githubusercontent.com/60777462/201930533-94744fe4-4809-452a-b6ee-d85f84525b6f.png">
### Haar-like masks
<img width="469" alt="image" src="https://user-images.githubusercontent.com/60777462/201930900-10975946-747d-4967-8a00-d880c71ee641.png"><img width="475" alt="image" src="https://user-images.githubusercontent.com/60777462/201931284-57102d09-b07f-4c31-8679-b80a70391875.png">

## Part2: SIFT features and descriptors
<img width="455" alt="image" src="https://user-images.githubusercontent.com/60777462/201931404-0f96a7b4-71f0-4792-bf65-65b1f81b2a6a.png"><img width="480" alt="image" src="https://user-images.githubusercontent.com/60777462/201931502-55faa53f-f25f-45c0-9d4a-4f1b497e5a62.png">
  
## Part3: Homography matirx and transform a image
<img width="518" alt="image" src="https://user-images.githubusercontent.com/60777462/201931721-2476c43c-de6b-453e-8a1d-bb94b0379864.png">![image](https://user-images.githubusercontent.com/60777462/201931764-c1836498-34ad-4ae7-b1ec-a1ba8320bcff.png)

## Part4: Manual homography and stitching 2 images
![image](https://user-images.githubusercontent.com/60777462/201931857-bee52360-77fe-42bf-8061-3cb7ab773eaf.png)

## Part5: Homography using RANSAC
![image](https://user-images.githubusercontent.com/60777462/201931944-ea5b78d4-c9e1-4c15-bbed-83b1a2f1cf65.png)![image](https://user-images.githubusercontent.com/60777462/201931972-c9bc7011-de1c-42e9-85cb-518f64b4767e.png)
![image](https://user-images.githubusercontent.com/60777462/201932056-922b8dc6-d27f-4f77-8118-f87c97a88cbc.png)<img width="573" alt="image" src="https://user-images.githubusercontent.com/60777462/201932104-a4d9d62c-ea9d-40c9-bfc8-965b93a1cbaf.png">
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
