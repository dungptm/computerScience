#include "define.h"

using namespace std;

string GetFolder(const string& path);
int GetNames(const string& nameWC, vector<string>& names);
int GetNames(const string &nameW, vector<string> &names, string &dir);
string GetNameNE(const string& path);
int GetNamesNE(const string& nameWC, vector<string> &names, string &dir);
int GetNamesNE(const string& nameWC, vector<string> &names);

// for matching
vector< DMatch > filterGoodMatches(vector< vector<DMatch> > matches);
vector<DMatch> matchAndFilter(Mat descriptors_1, Mat descriptors_2);
void rotate(cv::Mat& src, double angle, cv::Mat& dst);
int readListDesc(string srcDir, vector<Mat> &listDesc, vector<MatND> &listHist, 
	vector<Size> &listSize, vector<vector<KeyPoint>> &listKP, vector<string> &listFileNames);
int getStableMatches(Mat desc1, Mat desc2, vector<DMatch> &stable_matches);
void unsharpMask(cv::Mat& im);
int readGrayImage(string filename, Mat &fimg); // no use more 
int readGrayAndHSVImage(string filename, Mat &gray_img, Mat &hsv_img);
vector<double> getHistOfKeypoints(Mat *img_hsv, vector<KeyPoint> kp);
vector<DMatch> matchAndFilter2(Mat descriptors_1, Mat descriptors_2, Mat hsv_img_1, Mat hsv_img_2,
	vector<KeyPoint> keypoints_1, vector<KeyPoint> keypoints_2);

vector< DMatch > filterGoodMatches2(vector< vector<DMatch> > matches, Mat hsv_img_1, Mat hsv_img_2, 
	vector<KeyPoint> keypoints_1, vector<KeyPoint> keypoints_2);
Mat extractROIColor(vector<Point2f> scene_corners,Mat img);
MatND mcalculateHist(Mat img);
double compareHistToDB(vector<DMatch> &good_matches, 
	vector<KeyPoint> keypoints_1, vector<KeyPoint> keypoints_2, 
	Mat query_hsv_img, Size db_img_size, MatND db_hist);
void myResize(Mat &img);