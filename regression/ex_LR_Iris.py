# -*- coding: utf-8 -*-
"""
Created on Thu Feb 28 09:17:50 2019
Example of logistic regression with iris data
@author: Dung.Phan
"""

                
# Evaluation
from sklearn.datasets import load_iris
from models import regression

iris = load_iris()
X = iris.data[:,:2]
y = (iris.target !=0 )*1

model = regression.dLogisticRegression(lr=0.1, num_iter=30000, verbose=True)
model.fit(X,y)
pred = model.predict(X,0.7)
# accuracy
t = (y==pred).mean()
print('Logistic Regression - Testing accuracy: ' + str(t))