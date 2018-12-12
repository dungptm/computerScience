-- Evaluate book cover data set
ORB_ObjMatching.exe 6 D:\Workspace\ORB_ObjMatching\DATA 1 500 0 1

-- test for book cover data set
ORB_ObjMatching.exe 7 D:\Workspace\ORB_ObjMatching\DATA\stanford\BookCover\Reference\ D:\Workspace\ORB_ObjMatching\DATA\stanford\BookCover\canon\023.jpg 1 500 0 0 jpg
ORB_ObjMatching.exe 7 D:\Workspace\ORB_ObjMatching\DATA\stanford\BookCover\Reference\ D:\Workspace\ORB_ObjMatching\DATA\stanford\BookCover\canon\059.jpg 1 500 0 0 jpg
ORB_ObjMatching.exe 7 D:\Workspace\ORB_ObjMatching\DATA\stanford\BookCover\Reference\ D:\Workspace\ORB_ObjMatching\DATA\stanford\BookCover\canon\049.jpg 1 500 0 0 jpg


-- test for CD cover data set
ORB_ObjMatching.exe 7 D:\Workspace\ORB_ObjMatching\DATA\stanford\CDCover\Reference\ D:\Workspace\ORB_ObjMatching\DATA\stanford\CDCover\canon\059.jpg 1 500 0 0 jpg
ORB_ObjMatching.exe 7 D:\Workspace\ORB_ObjMatching\DATA\stanford\CDCover\Reference\ D:\Workspace\ORB_ObjMatching\DATA\stanford\CDCover\canon\009.jpg 1 500 0 0 jpg
ORB_ObjMatching.exe 7 D:\Workspace\ORB_ObjMatching\DATA\stanford\CDCover\Reference\ D:\Workspace\ORB_ObjMatching\DATA\stanford\CDCover\canon\015.jpg 1 500 0 0 jpg

-- test for lab data set
ORB_ObjMatching.exe 7 E:\Testing\lab_data\dataset\train\ E:\Testing\lab_data\dataset\test\37_1.jpg 1 300 0 0 jpg
ORB_ObjMatching.exe 7 E:\Testing\lab_data\dataset\train\ E:\Testing\lab_data\dataset\test\21_1.jpg 1 300 0 0 jpg
ORB_ObjMatching.exe 7 E:\Testing\lab_data\dataset\train\ E:\Testing\lab_data\dataset\test\18_1.jpg 1 300 0 0 jpg
ORB_ObjMatching.exe 7 E:\Testing\lab_data\dataset\train\ E:\Testing\lab_data\dataset\test\3_1.jpg 1 300 0 0 jpg

-- Evaluate Amsterdam or PRLab's data set
ORB_ObjMatching.exe 8 E:\Testing\lab_data\dataset\train\ E:\Testing\lab_data\dataset\test\ 1 300 0 1 jpg

-- query an image in lab's data set
ORB_ObjMatching.exe 7  E:\Testing\lab_data\dataset\train\ E:\Testing\lab_data\dataset\test\1_1.jpg 1 500 0 1 800 jpg