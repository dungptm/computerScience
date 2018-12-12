#include "test_sift.h"

int matchingAll_ImageDB_sift(){
	string testDir = "D:\\data\\standford_bcdb\\IP\\";
	string dbDir = "D:\\data\\standford_bcdb\\ST\\";

	// read images
	vector<string> names; 
	string srcFile = testDir + "\\*.jpg";
	int imgNum = 0;
	imgNum = GetNamesNE(srcFile, names, testDir);

	// DB images
	vector<string> db_names; 
	string dbFile = dbDir + "\\*.jpg";
	int imgNum_db = 0;
	imgNum_db = GetNamesNE(dbFile, db_names, dbDir);

	int false_matches = 0;
	//timer fE_Timer;

	//fE_Timer.Start();	
	vector<int> num_matches;
	int max_num_matches = 0;
	int match_ID = -1;

	for (int i = 0; i < imgNum; i++)
	{
		string query_img = testDir + names[i] + ".jpg";
		max_num_matches = 0;
		match_ID = -1;

		for (int j = 0; j < imgNum_db; j++){
			cout << "Matching ..." << i << " vs " << j << endl;
			string db_img = dbDir + db_names[j] + ".jpg";
			//////////////////////////////////////////////////////////////////////////

			Mat img_1;
			Mat img_2;
			if(readGrayImage( string(query_img), img_1) == -1 || readGrayImage( string(db_img), img_2) == -1){
				return -1;
			}

			//////////////////////////////////////////////////////////////////////////
			// sift feature
			SiftFeatureDetector  detector;
			SiftDescriptorExtractor extractor;

			std::vector<KeyPoint> keypoints_1, keypoints_2;

			detector.detect( img_1, keypoints_1 );
			detector.detect( img_2, keypoints_2 );

			//-- Step 2: Calculate descriptors (feature vectors)

			Mat descriptors_1, descriptors_2;

			extractor.compute( img_1, keypoints_1, descriptors_1 );
			extractor.compute( img_2, keypoints_2, descriptors_2 );

			//////////////////////////////////////////////////////////////////////////
			////-- Step 3: Matching descriptor vectors with a brute force matcher
			std::vector< DMatch > good_matches;
			good_matches = matchAndFilter(descriptors_1, descriptors_2);

			///good_matches = filterGoodMatches(matches,descriptors_1.rows);
			//num_matches.push_back(good_matches.size());
			////// find maximum match
			if(good_matches.size() > max_num_matches)
			{
				max_num_matches = good_matches.size();
				match_ID = j;
			}

		}
		if(match_ID != i){
			false_matches ++;			
		}
		cout<< "Matching Pair: " << i << "-" << match_ID <<endl;
	}

	//clock_t tend1 = fE_Timer.GetTicks();
	float accuracy = 0;
	accuracy = 100*(imgNum - false_matches)/imgNum;
	cout << "Accuracy: " << accuracy << "%"<<endl;
	//cout << "Time Consuming: " << tend1 << "ms" << endl;
	return 0;
}