#include "define.h"
#include "timer.h"
#include "utils.h"
#include "test_sift.h"
#include <sstream>
#include <string>

// global variable
// var for case 1,2,3,4,5
#define DATA_PATH "D:\\Workspace\\ORB_ObjMatching\\DATA"

int hist_cmp = 0;
int max_size = 500;
string file_ext = "jpg";
FeatureDetector* detector = new ORB(max_size);
//FeatureDetector* detector = new cv::FastFeatureDetector(); 

	//new cv::FastFeatureDetector();
DescriptorExtractor* extractor = new ORB();
//DescriptorExtractor* extractor = new FREAK(); 
//FlannBasedMatcher matcher(new flann::LshIndexParams(2,2,1));
BFMatcher matcher(NORM_HAMMING);

// PROTOTYPE
void readme();
vector<DMatch> demo(string f1, string f2, boolean show);

int matchDB(string file, vector<Mat> listDesc, vector<MatND> listHist,
	vector<Size> listSize, vector<vector<KeyPoint>> listKeypoints);
int matchingAll(vector<Mat> listDesc,vector<MatND> listHist,
	vector<Size> listSize,vector<vector<KeyPoint>> listKP, string testDir,vector<string> listFileNames, int &imgNum);
int matchingAll_ImageDB_4BookDB();
int generateFeatureDatabase(string srcDir);
void evaluationBook_CD_DataSet(string data_path, int feature_type, int num_feature, int gen, int flag_hist);
void evaluationALOI(string testDir, string srcRef, int feature_type, int numFeature, int gen, int flag_hist);
void query_1image(string srcRef, string file, int feature_type, int numFeature, int gen, int flag_hist);

/** @function main */
int main( int argc, char** argv )
{

	//////////////////////////////////////////////////////////////////////////
	int mode = atoi(argv[1]);
	cout << "====================" << endl;
	cout << "Running Mode: " << mode << endl;
	cout << "====================" << endl;
	if( argc > 7 ){
		hist_cmp = atoi(argv[7]);
		if(hist_cmp){
			cout << " +++++++++++ ORB + Color Histogram +++++++++++++" <<endl;
		}
	}	

	if( argc > 8 ){
		max_size = atoi(argv[8]);
		if(max_size){
			cout << " Resize image to max size " << max_size <<endl;
		}
	}

	//Case 3. MatchDB match 1 image to database
	vector<Mat> listDesc;
	vector<MatND> listHist;
	vector<Size> listSize;
	vector<vector<KeyPoint>> listKP;
	vector<string> listFileNames;
	
	// begin: var for case 1,2,3,4,5
	string db_src = DATA_PATH "\\stanford\\bookcover\\";
	string db_src_ip = db_src + "\\iPhone\\";
	string srcDir = DATA_PATH "\\stanford\\bookcover\\Reference\\";	
	string srcDesc = srcDir + "features_dsc\\";
	
	int id_match = -1;
	int imgNum = 0;
	timer global_time;
	// end: var for case 1,2,3,4,5
	//////////////////////////////////////////////////////////////////////////
	switch(mode){
	case 1:
		//Case 1.  matching 2 images
			global_time.Start();
			demo((string)argv[2],(string)argv[3],true);
			cout << "Processing Time: " << global_time.GetTicks() << endl;
			break;
		case 2:
			////////////////////////////////////////////////////////////////////////
			//Case 2. generate list of descriptor file
			generateFeatureDatabase(srcDir);			
			break;
			////////////////////////////////////////////////////////////////////////
		case 3:
			//////////////////////////////////////////////////////////////////////////
			//Case 3. MatchDB match 1 image to database
			
			generateFeatureDatabase(srcDir);
			readListDesc(srcDesc,listDesc,listHist,listSize,listKP,listFileNames);
			global_time.Start();
			id_match = matchDB(argv[2],listDesc,listHist,listSize,listKP);
			cout <<"ID Match:"<< id_match <<endl;
			cout <<"Processing Time:"<< global_time.GetTicks() <<endl;
			break;
		case 4:

			//////////////////////////////////////////////////////////////////////////
			//Case 4. matching all image in test dir to descriptor dir
			generateFeatureDatabase(srcDir);
			readListDesc(srcDesc,listDesc,listHist,listSize,listKP,listFileNames);
			matchingAll(listDesc,listHist,listSize,listKP,db_src_ip,listFileNames,imgNum);
			break;
		case 5:
			//////////////////////////////////////////////////////////////////////////
			//Case 5. matching all images in test dir to all image in db dir
			matchingAll_ImageDB_4BookDB();
			break;
		case 6:
			// evaluate for Book Cover and CD cover
			// 1: ORB 2: FREAK
			if(argc < 6)	
				cout << "ERROR - Not enough input argument!!!";
			else
				// cmd line: ORB_ObjMatching $mode $feature_type $numFeature $generateDB_Flag $combine_hist_flag
				//evaluationBook_CD_DataSet(string dataPath, int feature_type, int numFeature, int gen, int flag_hist)
				evaluationBook_CD_DataSet(string(argv[2]), atoi(argv[3]), atoi(argv[4]), atoi(argv[5]), atoi(argv[6]));
			break;

		case 7:
			// test: query 1 image in src Ref dir
			// cmd line: ORB_ObjMatching $srcRef(Train set) $image_file $feature_type $numFeature $gen $flag_hist $file_ext
			if(argc > 9)	file_ext = string(argv[9]);
			query_1image(string(argv[2]), string(argv[3]), atoi(argv[4]), atoi(argv[5]), atoi(argv[6]), atoi(argv[7]));
			break;
		case 8:
			// test ALOI test dir
			// cmd line: ORB_ObjMatching $srcRef(Train set) $testDir $feature_type $numFeature $gen $flag_hist $file_ext			
			if(argc > 9)	file_ext = string(argv[9]);
			evaluationALOI(string(argv[2]), string(argv[3]), atoi(argv[4]), atoi(argv[5]), atoi(argv[6]), atoi(argv[7]));
			break;

		default:
			break;
	}

	//cout<<"Press any key ..."<<endl;
	//getchar();
	return 0;
}
void query_1image(string srcRef, string image_file, int feature_type, int numFeature, int gen, int flag_hist){

	//////////////////////////////////////	
	cout << endl << "Parameters: " << endl;
	if(flag_hist == 1){
		hist_cmp = 1;
	}

	//	 declare feature detector and extractor
	switch(feature_type){
	case 1: 
		detector = new ORB(numFeature);
		extractor = new ORB();
		cout <<endl << "Feature: ORB" << endl;
		break;

	case 2:
		detector = new ORB(numFeature);
		extractor = new FREAK();
		cout <<endl << "Feature: FREAK" << endl;
		break;

	default:
		detector = new SIFT();
		extractor = new SIFT();
		cout <<endl << "Feature: SIFT" << endl;
		break;
	}
	cout << endl << "Num of Feature: " << numFeature << endl;
	cout << "================================================" << endl;

	//string srcRef = "E:\\Testing\\aloi\\train\\";	
	string srcDesc = srcRef + "\\features_dsc\\";		
	_mkdir(srcDesc.c_str());

	if( gen > 0 ){
		generateFeatureDatabase(srcRef);
		cout << endl << "Done: generating database" <<endl;
	}else
		cout << "WARN: Ignore generating database " << endl;

	// gen == 1 -> only generate data
	if( gen == 1 ) return;

	vector<Mat> listDesc;
	vector<MatND> listHist;
	vector<Size> listSize;
	vector<vector<KeyPoint>> listKP;
	vector<string> listFileNames;
	readListDesc(srcDesc,listDesc,listHist,listSize,listKP,listFileNames);
	
	//////////////////////////////////////////////////////////////////////////
	// MatchDB	
	timer queryTime;
	queryTime.Start();
	int index_match = matchDB(image_file,listDesc,listHist,listSize,listKP);
	cout << "Query Time: " << queryTime.GetTicks() << "ms" << endl;
	int id_match = -1;
	if(index_match > -1){
		//get id match
		int tmp1 = listFileNames[index_match].find_first_of("_");
		int tmp2 = listFileNames[index_match].find_first_of(".");
		tmp1 = tmp1<tmp2? tmp1: tmp2;

		id_match = stoi(listFileNames[index_match].substr(0,tmp1));					
		cout << "Object is found!" << endl;
		cout << "Index: " << index_match << endl;		
		//cout << "(string) Object ID: " <<listFileNames[index_match] << endl;		
		cout << "Object ID: " <<id_match << endl;		
		
		// show the retrieved image
		int tmp = listFileNames[index_match].find_last_of("_");

		string rfile = srcRef + "\\" + listFileNames[index_match].substr(0,tmp) + "." + file_ext;

		Mat img = imread(rfile,CV_LOAD_IMAGE_COLOR);
		myResize(img);
		Mat in_img = imread(image_file,CV_LOAD_IMAGE_COLOR);
		// resize
		myResize(in_img);
		//namedWindow("");
		imshow("Input Image", in_img  );
		//namedWindow("2");
		imshow("Retrieved Image", img );
		waitKey(0);
	}else{

		Mat in_img = imread(image_file,CV_LOAD_IMAGE_COLOR);
		myResize(in_img);
		//namedWindow("");
		imshow("Input Image", in_img  );
		waitKey(0);
		cout << "Object is not found!" << endl;		
	}

	return;
}
// 
void evaluationALOI(string srcRef, string testDir, int feature_type, int numFeature, int gen, int flag_hist){

	//////////////////////////////////////	
	cout << endl << "Parameters: " << endl;
	if(flag_hist == 1){
		hist_cmp = 1;
	}
	//file_ext = "png";
	//	 declare feature detector and extractor
	switch(feature_type){
	case 1: 
		detector = new ORB(numFeature);
		extractor = new ORB();
		cout <<endl << "Feature: ORB" << endl;
		break;

	case 2:
		detector = new ORB(numFeature);
		extractor = new FREAK();
		cout <<endl << "Feature: FREAK" << endl;
		break;

	default:
		detector = new SIFT();
		extractor = new SIFT();
		cout <<endl << "Feature: SIFT" << endl;
		break;
	}
	cout << endl << "Num of Feature: " << numFeature << endl;
	cout << "================================================" << endl;
	
	//string testDir = "E:\\Testing\\aloi\\test\\";
	//string srcRef = "E:\\Testing\\aloi\\train\\";	
	string srcDesc = srcRef + "features_dsc\\";	

	if( gen > 0 ){
		generateFeatureDatabase(srcRef);
		cout << endl << "Done: generating data database" <<endl;
	}else
		cout << "WARN: Ignore generating database" << endl;
	if( gen == 1){
		// just generate database
		return;
	}
	vector<Mat> listDesc;
	vector<MatND> listHist;
	vector<Size> listSize;
	vector<vector<KeyPoint>> listKP;
	vector<string> listFileNames;
	readListDesc(srcDesc,listDesc,listHist,listSize,listKP,listFileNames);
	int imgNum = 0;
	int true_matches = matchingAll(listDesc,listHist,listSize,listKP,testDir,listFileNames,imgNum);
	double acc = 100.0*true_matches/imgNum;
	
	cout << endl << "--------------------------" << endl;
	cout << "Accuracy: " << true_matches << "/" << imgNum << " = " << acc << "%"<<endl;
	cout << endl << "--------------------------" << endl;
	return;
}
/*
EVALUATE PROGRAM
- Input: 
	*db_type: book, cd, dvd
	*feature_type:ORB (1), FREAK (2)
	*flag_hist: NO_HIST (1), HSV_HIST(2), SHSV_HIST (3)

*/
void evaluationBook_CD_DataSet(string data_path, int feature_type, int num_feature, int gen, int flag_hist){
	
	//////////////////////////////////////	
	cout << endl << "Parameters: " << endl;
	if(flag_hist == 1){
		hist_cmp = 1;
	}
//	 declare feature detector and extractor
	switch(feature_type){
	case 1: 
		extractor = new ORB();
		cout <<endl << "Feature: ORB" << endl;
		break;
	case 2:
		extractor = new FREAK();
		cout <<endl << "Feature: FREAK" << endl;
		break;
	default:
		extractor = new ORB();
		break;
	}
	cout << endl << "Num of Feature: " << num_feature << endl;
	cout << "================================================" << endl;
	detector = new ORB(num_feature);

	// BOOK COVER DATABASE
	for (int idb = 0; idb < 2; idb++){

		cout << endl <<"================================================" << endl;
		vector<Mat> listDesc;
		vector<MatND> listHist;
		vector<Size> listSize;
		vector<vector<KeyPoint>> listKP;

		string srcRef;
		string data_src1 = data_path + "\\stanford\\bookcover\\";
		string testDir1 = data_src1 + "\\iPhone\\";
		string testDir2 = data_src1 + "\\Canon\\";
		string testDir3 = data_src1 + "\\5800\\";
		string testDir4 = data_src1 + "\\Droid\\";

		string data_src2 = data_path + "\\stanford\\CDCover\\";
		string testDir11 = data_src2 + "\\canon\\";
		string testDir21 = data_src2 + "\\Droid\\";
		string testDir31 = data_src2 + "\\E63\\";
		string testDir41 = data_src2 + "\\Palm\\";

		vector<string> list_test_dir;
		if(idb==0){
			srcRef = data_src1 + "Reference\\";	
			list_test_dir.push_back(testDir1);
			list_test_dir.push_back(testDir2);
			list_test_dir.push_back(testDir3);
			list_test_dir.push_back(testDir4);

			file_ext = "jpg";						

		}else if(idb == 1){
			
			srcRef = data_src2 + "Reference\\";	
			list_test_dir.push_back(testDir11);
			list_test_dir.push_back(testDir21);
			list_test_dir.push_back(testDir31);
			list_test_dir.push_back(testDir41);

			file_ext = "jpg";
		}
				
		string srcDesc = srcRef + "features_dsc\\";	
		if( gen > 0 )
			generateFeatureDatabase(srcRef);
		else
			cout << "WARN: Ignore generating" << endl;
		if( gen == 1 ){			
			cout << endl << "Done: generating data" <<endl;
			continue;
		}

		// un_used now
		vector<string> listFileNames;
		readListDesc(srcDesc,listDesc,listHist,listSize,listKP,listFileNames);
		int tnum_img = 0, t_true = 0, true_matches = 0, imgNum = 0;
		for(int itd=0; itd<list_test_dir.size();itd++){

			true_matches = matchingAll(listDesc,listHist,listSize,listKP,list_test_dir[itd],listFileNames,imgNum);
			t_true += true_matches;
			tnum_img += imgNum;
		}
		float t_acc = tnum_img>0? 100 *t_true/tnum_img: 0;
		cout << endl << "--------------------------" << endl;
		cout << "Total Accuracy: " << t_acc << "%"<<endl;
		cout << endl << "--------------------------" << endl;

		// clean up
		list_test_dir.clear();
		listDesc.clear();
		listHist.clear();
		listKP.clear();
	}
	
}
int matchingAll_ImageDB_4BookDB(){
	string testDir = "D:\\data\\standford_bcdb\\IP\\";
	string dbDir = "D:\\data\\standford_bcdb\\ST\\";

	// read images
	vector<string> names; 
	string srcFile = testDir + "\\*." + file_ext;
	int imgNum = 0;
	imgNum = GetNamesNE(srcFile, names, testDir);

	// DB images
	vector<string> db_names; 
	string dbFile = dbDir + "\\*." + file_ext;
	int imgNum_db = 0;
	imgNum_db = GetNamesNE(dbFile, db_names, dbDir);

	int false_matches = 0;
	timer fE_Timer;
	fE_Timer.Start();

	vector<int> num_matches;
	int max_num_matches = 0;
	int match_ID = -1;
	
	for (int i = 0; i < imgNum; i++)
	{
		string query_img = testDir + names[i] + "." + file_ext;
		max_num_matches = 0;
		match_ID = -1;
		
		for (int j = 0; j < imgNum_db; j++){
#ifdef SHOW_LOG
				cout << "Matching ..." << i << " vs " << j << endl;
#endif
		
			string db_img = dbDir + db_names[j] + "." + file_ext;
		
			////-- Step 3: Matching descriptor vectors with a brute force matcher
			std::vector< DMatch > good_matches;			
			good_matches = demo(query_img,db_img,false);
		
			////// find maximum match
			if(good_matches.size() > max_num_matches)
			{
				max_num_matches = good_matches.size();
				match_ID = j;
			}
			
		}
		if(match_ID != i){
			false_matches ++;			
			cout<< "Matching Pair - Failed: " << i+1 << "-" << match_ID+1 <<endl;
		}
#ifdef SHOW_LOG
		else{
			cout<< "Matching Pair: " << i << "-" << match_ID <<endl;
		}
#endif		

	}


	float accuracy = 0;
	imgNum += 1;
	accuracy = 100.0*(imgNum - false_matches)/imgNum;
	cout << "Accuracy: " << accuracy << "%"<<endl;
	/*clock_t tend1 = fE_Timer.GetTicks();
	cout << "Time Consuming: " << tend1 << "ms" << endl;*/
	return 0;
}
// return number of recognized obj
int matchingAll(vector<Mat> listDesc,vector<MatND> listHist,
	vector<Size> listSize,vector<vector<KeyPoint>> listKP, string testDir, vector<string> listFileNames, int &imgNum){

	timer fE_Timer;	
	fE_Timer.Start();
	cout << "Testing for data: " << testDir << endl;
		
	// read images
	vector<string> names; 
	string srcFile = testDir + "\\*." + file_ext;
	imgNum = GetNamesNE(srcFile, names, testDir);
	int index_match;
	int true_matches = 0;

//#ifdef SHOW_LOG	
	int false_matches = 0;
	int uk_matches = 0;
//#endif

	for (int i = 0; i < imgNum; i++){
		index_match = -1;
		string image_file = testDir + names[i] + "." + file_ext;

#ifdef SHOW_LOG
		cout<< "Query Image: " << image_file << endl;
#endif
		int tmp1 = names[i].find_first_of("_");
		int tmp2 = names[i].find_first_of(".");
		tmp1 = tmp1<tmp2? tmp1: tmp2;		
		int query_id = stoi(names[i].substr(0,tmp1));
		//cout << "----------query id: " << query_id << endl; 
			
		//////////////////////////////////////////////////////////////////////////
		// MatchDB			
		index_match = matchDB(image_file,listDesc,listHist,listSize,listKP);
		int id_match = -1;
		if(index_match > -1){
			//get id match
			int tmp1 = listFileNames[index_match].find_first_of("_");
			int tmp2 = listFileNames[index_match].find_first_of(".");
			tmp1 = tmp1<tmp2? tmp1: tmp2;
			id_match = stoi(listFileNames[index_match].substr(0,tmp1));			
		}
		if(id_match == query_id)	
			true_matches++;	

//#ifdef SHOW_LOG		
		if(id_match == -1){
			uk_matches ++;
			cout<< "Unknown Object: " << names[i] << endl;
		}else if(id_match != query_id){
			false_matches ++;			
			cout<< "Failed Matching Pair: " << names[i] << "-" << id_match <<endl;
		}	
//#endif
	}

	clock_t tend1 = fE_Timer.GetTicks();
	cout << "Total Time Processing: " << tend1 << "ms" << endl;
	float acc = imgNum > 0? 100.0*true_matches/imgNum: 0;

	cout << endl << "--------------------------" << endl;
	cout << "Accuracy: " << true_matches << "/" << imgNum << " = " << acc << "%"<<endl;
	cout << endl << "--------------------------" << endl;
	return true_matches;
}
vector<DMatch> demo(string f1, string f2, boolean show){
	
	Mat img_1, img_1hsv;
	Mat img_2, img_2hsv;

	vector<DMatch> good_matches;

	// HSV image
	readGrayAndHSVImage(f1, img_1, img_1hsv);
	readGrayAndHSVImage(f2, img_2, img_2hsv);

	// gray scale image
	if(img_1.data == NULL || img_1hsv.data == NULL || img_2.data == NULL || img_2hsv.data == NULL){
		cout << "!- ERROR - READING IMAGE FAILED" << endl;
		return good_matches;
	}
	
	// enhance image -> sharpening
	//unsharpMask(img_1);
	//unsharpMask(img_2);

	// detect keypoint
	std::vector<KeyPoint> keypoints_1, keypoints_2;

	detector->detect( img_1, keypoints_1 );
	detector->detect( img_2, keypoints_2 );

	//-- Draw keypoints
	// Calculate descriptors (feature vectors)
	Mat descriptors_1, descriptors_2;
	extractor->compute( img_1, keypoints_1, descriptors_1 );
	extractor->compute( img_2, keypoints_2, descriptors_2 );

	timer tE_timer;
	tE_timer.Start();

	good_matches = matchAndFilter(descriptors_1,descriptors_2);
	//good_matches = matchAndFilter2(descriptors_1,descriptors_2,img_1hsv,img_2hsv,keypoints_1,keypoints_2);

	clock_t tend = tE_timer.GetTicks();
	cout << "Matching Time: " << tend <<"ms" << endl;


	//-- Draw only "good" matches
	cout << "Num of Keypoints 1: " << keypoints_1.size()<< endl;
	cout << "Num of Keypoints 2: " << keypoints_2.size()<< endl;
	cout <<"Number of good matches: " << good_matches.size() << endl;


	if(show){
		Mat img_keypoints_1; Mat img_keypoints_2;

		imshow("HSV Image 1",img_1hsv);
		imshow("HSV Image 2",img_2hsv);

		//waitKey();

		drawKeypoints( img_1, keypoints_1, img_keypoints_1, Scalar::all(-1), DrawMatchesFlags::DEFAULT );
		drawKeypoints( img_2, keypoints_2, img_keypoints_2, Scalar::all(-1), DrawMatchesFlags::DEFAULT );

		imshow("Image 234",img_keypoints_2);
		imshow("Image 123",img_keypoints_1);


		//////////////////////////////////////////////////////////////////////////
		// number of keypoints should be greater than

		Mat img_matches;
		cout << "Good match size:" << good_matches.size() << endl;
		if(good_matches.size() > 3){
			MatND hist2 = mcalculateHist(img_2hsv);
			
			//////////////////////////////////////////////////////////////////////////
			// for show the detected obj
			std::vector<Point2f> obj;
			std::vector<Point2f> scene;

			if(compareHistToDB(good_matches,keypoints_1,keypoints_2,img_1hsv,Size(img_2hsv.cols,img_2hsv.rows),hist2))

				cout<<"matched"<<endl;
			else
				cout<<"Not matched"<<endl;

			if( good_matches.size() > 3){
				for( int i = 0; i < good_matches.size(); i++ )
				{
					//-- Get the keypoints from the good matches
					scene.push_back( keypoints_1[ good_matches[i].queryIdx ].pt );
					obj.push_back( keypoints_2[ good_matches[i].trainIdx ].pt );
				}

				Mat H = findHomography( obj, scene,CV_RANSAC, 5 );

			drawMatches( img_1, keypoints_1, img_2, keypoints_2,
				good_matches, img_matches, Scalar::all(-1), Scalar::all(-1),
				vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
			// put text
			for(int kk = 0; kk < good_matches.size(); kk++){
				char buffer [50];
				double xx = (keypoints_1[good_matches[kk].queryIdx]).pt.x;
				double yy = (keypoints_1[good_matches[kk].queryIdx]).pt.y;
				sprintf (buffer, "D%0.0f", good_matches[kk].distance );
				//putText(img_matches,buffer, cvPoint(xx,yy),FONT_HERSHEY_COMPLEX_SMALL, 0.8, cvScalar(200,200,250), 1, CV_AA);
			}
						

				//-- Get the corners from the image_1 ( the object to be "detected" )
				std::vector<Point2f> obj_corners(4);
				obj_corners[0] = cvPoint(0,0); obj_corners[1] = cvPoint( img_2.cols, 0 );
				obj_corners[2] = cvPoint( img_2.cols, img_2.rows ); obj_corners[3] = cvPoint( 0, img_2.rows );
				//std::vector<Point2f> scene_corners(4);

				obj.push_back(cvPoint(0,0));
				obj.push_back(cvPoint( img_2.cols, 0 ));
				obj.push_back(cvPoint(img_2.cols, img_2.rows ));
				obj.push_back(cvPoint( 0, img_2.rows));
				std::vector<Point2f> scene_corners(obj.size());
				vector<Point2f> scene_corners1(4);

				perspectiveTransform( obj_corners, scene_corners1, H);
				perspectiveTransform( obj, scene_corners, H);

				RNG rng(12345);
				vector<Point2f> hull;
				convexHull(scene_corners, hull);
				Scalar color = Scalar( rng.uniform(0, 255), rng.uniform(0,255), rng.uniform(0,255) );
				Mat gray_img = img_1hsv;
				
				line( gray_img, hull[0] , hull[1], Scalar(0, 255, 0), 4 );
				line( gray_img, hull[1] , hull[2], Scalar( 0, 255, 0), 4 );
				line( gray_img, hull[2] , hull[3], Scalar( 0, 255, 0), 4 );
				line( gray_img, hull[3] , hull[0], Scalar( 0, 255, 0), 4 );
				//drawContours(query_hsv_img, hull,1,color,1,8, vector<Vec4i>(), 0, Point() );
				imshow("Convex hull", gray_img);
				waitKey();

				////perspectiveTransform( obj_corners, scene_corners, H);
				cout << "2 Good match size:" << good_matches.size() << endl;
				//-- Draw lines between the corners (the mapped object in the scene - image_2 )		
				line( img_matches, scene_corners1[0] , scene_corners1[1], Scalar(0, 255, 0), 4 );
				line( img_matches, scene_corners1[1] , scene_corners1[2], Scalar( 0, 255, 0), 4 );
				line( img_matches, scene_corners1[2] , scene_corners1[3], Scalar( 0, 255, 0), 4 );
				line( img_matches, scene_corners1[3] , scene_corners1[0], Scalar( 0, 255, 0), 4 );
			}

			
			//cout << "Num of good matches after removing: " << good_matches.size() << endl;

			//-- Show detected matches
			imshow( "Good Matches", img_matches );
			waitKey();			
		}

	}

	return good_matches;
}

int matchDB(string file, vector<Mat> listDesc, vector<MatND> listHist,
	vector<Size> listSize, vector<vector<KeyPoint>> listKeypoints)
{
	
	//cout<<"Matching ..."<<endl;
	//////////////////////////////////////////////////////////////////////////		
	Mat descriptors_1;
	Mat img_1,img_1hsv;
	vector<int> num_matches;

#ifdef SHOW_LOG
	timer fE_Timer;
	fE_Timer.Start();
#endif

	//////////////////////////////////////////////////////////////////////////
	// end declare variable
	//cout << "Read Image File: " << file << endl;
	if(readGrayAndHSVImage(string(file),img_1,img_1hsv)){
		return -1;
	}
	
	//unsharpMask(img_1);
	//////////////////////////////////////////////////////////////////////////
	// EXTRACT INPUT DESCRIPTOR
	std::vector<KeyPoint> keypoints_1;
	detector->detect( img_1, keypoints_1 );
	extractor->compute( img_1, keypoints_1, descriptors_1 );
	
#ifdef SHOW_LOG
	cout << "Num of keypoint: " << keypoints_1.size() << endl;
	cout << "Processing Time of Extract Features: " << fE_Timer.GetTicks() << endl;
#endif

	// 
	if( keypoints_1.size() < MIN_NUM_FEATURES){
		cout << "WARN - Number of keypoints of input images too few" << endl;
		return -1; // match_idx = -1;
	}

	// declare variable----------------------
	int max_num_matches = MIN_NUM_MATCHES; // if the max num less than 10 -> unknown match
	int match_idx = -1;
	
	vector<int> num_matches_list;
	vector<vector<DMatch>> good_matches_list;
	

	//////////////////////////////////////////////////////////////////////////
	// MATCH TO DATABASE

	if(hist_cmp){
		for(int i=0; i < listDesc.size(); i++){
//#ifdef SHOW_LOG	
//			cout << "Compare to: image " << i << endl;
//#endif
			vector< DMatch > good_matches;
			Mat descriptors_2 = listDesc[i];
			if( descriptors_2.rows > MIN_NUM_FEATURES ){
				good_matches = matchAndFilter(descriptors_1,  descriptors_2);	
				good_matches_list.push_back(good_matches);
				num_matches_list.push_back(good_matches.size());
			}else{
				good_matches_list.push_back(good_matches);
				num_matches_list.push_back(0);
				cout <<"==========================="<< endl;
				cout <<"NO FEATURE: ID " << i << endl;
				cout <<"==========================="<< endl;
			}
				
		}

		// find top 5 matches by sorting and return index	
		vector<int> sort_idx;
		sortIdx(num_matches_list, sort_idx, CV_SORT_EVERY_ROW+CV_SORT_DESCENDING);

		// 2. Compare hsv color histogram
//#ifdef SHOW_LOG		
//		cout << "5 most nearest features index: " << sort_idx[0]<<"-" << sort_idx[1]
//		<<"-" << sort_idx[2]<<"-" << sort_idx[3]<<"-" << sort_idx[4]<<"-" << sort_idx[5]<<endl;// log
//		cout << "5 most nearest features: " <<good_matches_list[sort_idx[0]].size()<<"-" << good_matches_list[sort_idx[1]].size()
//		<<"-" << good_matches_list[sort_idx[2]].size()<<"-" << good_matches_list[sort_idx[3]].size()<<"-" << good_matches_list[sort_idx[4]].size()<<
//		"-" << good_matches_list[sort_idx[5]].size()<<endl;// log
//#endif
		double dist = 0, max_dist = 0; 
		//cout << "Test" << endl;
		
		int max_num = good_matches_list[sort_idx[0]].size();
		if (max_num < 1) return -1;

		vector<double> hist_dist(10);
		int mmax_num_tmp = -1;
		for(int i=0;i<min(N_TOP_MATCHES,int(sort_idx.size()));i++){		

			hist_dist[i] = -1;
			int idx = sort_idx[i];			
			if(good_matches_list[idx].size() < MIN_NUM_MATCHES) break;
			if(listKeypoints[idx].size() < 1 ) break;
			if(good_matches_list[idx].size() > MAX_NUM_MATCHES){
				match_idx = idx;
				break;
			}

			hist_dist[i] = compareHistToDB(good_matches_list[idx], keypoints_1, listKeypoints[idx], 
				img_1hsv, listSize[idx],listHist[idx]);
			// find max_num		
			int t = good_matches_list[idx].size();
			if ( t > mmax_num_tmp){
				mmax_num_tmp = t;
			}
		}
		//------------------------------------------
		// compute similarity
		for(int i=0;i<min(N_TOP_MATCHES,int(sort_idx.size()));i++){

			int idx = sort_idx[i];	
			//dist = LC_WEIGHT*good_matches_list[idx].size()/max_num + CL_WEIGHT*hist_dist;
			dist = 0.7*good_matches_list[idx].size()/mmax_num_tmp + 0.3*hist_dist[i];
			//dist = good_matches_list[idx].size()/mmax_num_tmp;
#ifdef SHOW_LOG		
			cout << "Dist: "  << dist << " - Max num: " << max_num << endl 
				<<"-num: " << good_matches_list[idx].size() << endl
				<< "Hist-dist: " << hist_dist[i] << endl;
#endif
			if(dist > max_dist){
				max_dist = dist;
				match_idx = idx;
				//cout << "similarity: " << dist <<endl;
			}
		}

	}else{
		max_num_matches = MIN_NUM_MATCHES;
		for(int i=0; i < listDesc.size(); i++){
			vector< DMatch > good_matches;
			Mat descriptors_2 = listDesc[i];
			if( descriptors_2.rows > MIN_NUM_FEATURES ){
				good_matches = matchAndFilter(descriptors_1,  descriptors_2);
							
				if(good_matches.size() > max_num_matches){
					
					max_num_matches = good_matches.size();
					match_idx = i;
					//cout << "index: " << i << "Max matches: " << max_num_matches<<endl;
				}			
			}
		}
#ifdef SHOW_LOG
		cout << "Good matches: " << max_num_matches<<endl;
#endif
	}
	//cout<<"matched ID: "<< match_idx+1 <<endl;
	//cout << "Good matches: " << max_num_matches<<endl;	
	//  index of matched obj in data set
	return match_idx;
}
int generateFeatureDatabase(string srcDir){

	timer fE_Timer;
	fE_Timer.Start();
	cout<< "Generating feature descriptors ..." << endl;
	cout<<"Source Dir " <<srcDir << endl;
	vector<string> names; 
	
	string outDir = srcDir + "\\features_dsc\\";
	_mkdir(outDir.c_str());


	string srcFile = srcDir + "\\*." + file_ext;
	cout<< "Pattern: " << srcFile << endl;
	int imgNum = 0;
	imgNum = GetNamesNE(srcFile, names, srcDir);
	vector<Size> listSize;
	
	for (int i = 0; i < imgNum; i++)
	{		
		//cout << "Read file: " << string(srcDir + names[i] + "." + file_ext) <<endl;
		Mat image;
		Mat hsv_image;
		readGrayAndHSVImage(string(srcDir + names[i] + "." + file_ext), image,hsv_image);
		
		vector<KeyPoint> keypoints_orb;
		Mat descriptors_orb;
		detector->detect(image, keypoints_orb);
		
		// just test to reject the images from DB
		if(keypoints_orb.size() < 20){
			cout << "****WARN - Number of keypoint too few: " << string(names[i]) << " : " << keypoints_orb.size()<< endl;
		}
		/// end
		extractor->compute( image, keypoints_orb, descriptors_orb );
		//-- Write feature vectors (keypoints) to file		
		
		FileStorage fs(outDir + names[i] + "_orb.yml", FileStorage::WRITE);	
		fs << "feature_descriptors" << descriptors_orb;
		fs.release();

		//// 2. CALCULATE HSV HISTOGRAM
		if( hist_cmp )		{
			MatND hist = mcalculateHist(hsv_image);

			FileStorage fs1( outDir + names[i] + "_hist.yml", FileStorage::WRITE);	
			fs1 << "histogram_descriptors" << hist;
			fs1.release();

			listSize.push_back(Size(image.cols,image.rows));

			FileStorage fs2(outDir + names[i] + "_kp.yml", FileStorage::WRITE);	
			fs2 << "keypoint" << keypoints_orb;
			fs2.release();
		}
		
	}
	
	if(hist_cmp){
		FileStorage fs3(outDir + "All_sizeList.yml", FileStorage::WRITE);	
		fs3 << "image_size" << listSize;
		fs3.release();
	}
	cout <<  "Processing Time of Generating Database : " << fE_Timer.GetTicks()  << "ms"<< endl;
	return 0;
}

/** @function readme */
void readme()
{ std::cout << " Usage: " << std::endl; }