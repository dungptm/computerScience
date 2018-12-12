/** Basic OpenCV example for face detecion and tracking with CamShift.
  * First run Haar classifier face detection on every frame until finding face,
  * then switch over to CamShift using face region to track.
 **/
#include "trackface.h"
using namespace cv;
char *classifer = "haarcascade_frontalface_default.xml";

int main (int argc, char** argv) {
  if (argc != 2) print_help(argv[0]); //check usage
  // declare  
  char* window_name = "Face Tracking Demo - Phan Thi My Dung";
  
  // initialize  
  CascadeClassifier cascade;
  if( !cascade.load( classifer ) ){ printf("--(!)Error loading\n"); return 0; };

  // create window
  cvNamedWindow(window_name, CV_WINDOW_AUTOSIZE);

  std::vector<Rect> facesList;
  
  // capture images form video file
  CvCapture* capture = cvCaptureFromFile(argv[1]);
  Mat image;
  Mat gray;
  
  // count number of frames
  int i = 0;
  // write output video
  char output[100] = "multipleFaces_tracking.avi";
  VideoWriter vwriter = VideoWriter(output,CV_FOURCC('D', 'I', 'V', 'X'),30,cvSize(640,480),TRUE);

  if (capture) {
    // run loop, exit on ESC
    while (i < 200) {
      image = capture_video_frame(capture);
	  if (image.empty()){break;}

	  // convert color image to gray scale image
	  cvtColor(image, gray,CV_BGR2GRAY);

	  cascade.detectMultiScale(gray,facesList,1.1,3, 0|CV_HAAR_SCALE_IMAGE, Size(35, 35) );

	  int fs = facesList.size();
	  // draw rectangles on faces
	  for (int j = 0; j < fs; j++)
	  {
		  rectangle(image,facesList[j],cvScalar(255, 0, 0, 1),2,8, 0);
	  }

	  //display
      imshow(window_name, image);
	  //WRITE CURRENT FRAME
	  vwriter.write(image);
      
      //exit program on ESC
      if ((char)27 == cvWaitKey(10)) {
        cvReleaseCapture(&capture); 
        exit(0);
      }
	  i++;
    }   
  }
  printf("\nPress Enter to quit the program!\n");
  getchar();

  //release resources and exit
  //cleanup(window_name, cascade, storage);
}


/* Capture frame and return a copy so not to write to source. */
IplImage* capture_video_frame (CvCapture* capture) {
  //capture the next frame
  frame_curr = cvQueryFrame(capture);
  frame_copy = cvCreateImage(cvGetSize(frame_curr), 8, 3);
  assert(frame_curr && frame_copy); //make sure it's there

  //make copy of frame so we don't write to src
  cvCopy(frame_curr, frame_copy, NULL);
  frame_copy->origin = frame_curr->origin;

  //invert if needed, 1 means the image is inverted
  if (frame_copy->origin == 1) {
    cvFlip(frame_copy, 0, 0);
    frame_copy->origin = 0;
  }
  
  return frame_copy;
}

void cleanup (char* name,
              CvHaarClassifierCascade* cascade,
              CvMemStorage* storage) {
  //cleanup and release resources
  cvDestroyWindow(name);
  if(cascade) cvReleaseHaarClassifierCascade(&cascade);
  if(storage) cvReleaseMemStorage(&storage);
}

void print_help (char* name) {
  printf("Usage: %s [video]\n", name);
  exit(-1);
}