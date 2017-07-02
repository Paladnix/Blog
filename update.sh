#!/bin/bash

hexo clean

hexo g

hexo d

#hexo s

git add ./source 
git add ./_config.yml 
git add ./themes
git add ./update.sh

git commit -m $1

git push origin master
