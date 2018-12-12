#pragma once
#ifndef DEFINE_H
#define  DEFINE_H

#include <stdio.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <Windows.h>
#include <stdio.h>
#include <string>
#include <map>
#include <vector>
#include <algorithm>
#include <time.h>
#include <queue>
#include <omp.h>
#include <math.h>
#include <direct.h>

#include "opencv2/core/core.hpp"
#include "opencv2/features2d/features2d.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
//#include "opencv2/gpu/gpumat.hpp"
#include "opencv2/nonfree/nonfree.hpp"
#include "opencv2/nonfree/features2d.hpp"
#include "opencv2/calib3d/calib3d.hpp"


using namespace std;
using namespace cv;

//#define MATCH_RATIO 0.75 // should be less than 0.7
//#define MAX_HEIGHT_IMG 500
//#define MAX_NUM_FEATURES 1000

#define MATCH_RATIO 0.75// should be less than 0.7
#define RESIZE_IMAGE TRUE
#define MAX_HEIGHT_WIDTH_IMG 500 // if this value is small that means not resize image

// threshold of number of matches to reject obj
#define MIN_NUM_FEATURES 0
#define MAX_NUM_FEATURES 600

#define HIST_CORREL_THRESHOLD 0.1


#define MIN_NUM_MATCHES 0 //5
#define MAX_NUM_MATCHES MAX_NUM_FEATURES/10
#define N_TOP_MATCHES 5

#define HIST_CMP 0
#define LC_WEIGHT 0.6
#define CL_WEIGHT 1-LC_WEIGHT

#define NUM_NEAREST_4 1
#define MAX_STABLE_MATCHES 100

// list of feature types
//#define ORB_FT 1
//#define BRISK_FT 1
//#define FREAK_FT 1


//#define SHOW_LOG 1
// global variable
//OrbFeatureDetector  detector(MAX_NUM_FEATURES,1.2,10,31,0);
//OrbDescriptorExtractor extractor;
//SiftFeatureDetector detector;
//SiftDescriptorExtractor extractor;
////FlannBasedMatcher matcher;
////FlannBasedMatcher matcher(new flann::LshIndexParams(2,2,1));
//BFMatcher matcher(NORM_L1);

#endif