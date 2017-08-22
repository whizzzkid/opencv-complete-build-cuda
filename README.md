# Latest OpenCV Installer From Source.

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://github.com/whizzzkid/opencv-complete-build-cuda/pulls)
[![Code Climate](https://lima.codeclimate.com/github/whizzzkid/opencv-complete-build-cuda/badges/gpa.svg)](https://lima.codeclimate.com/github/whizzzkid/opencv-complete-build-cuda)
[![Issue Count](https://lima.codeclimate.com/github/whizzzkid/opencv-complete-build-cuda/badges/issue_count.svg)](https://lima.codeclimate.com/github/whizzzkid/opencv-complete-build-cuda)

Full build script for Open CV with/without cuda and bumblebee support.

## Need
After playing around with so many parameters and building OpenCV from source, I
realized how painful this was. I ended up creating an installer script for my
convienience and since now I feel pretty confident that I have perfected this, I
am relasing this to everyone so your life can be simpler too.

## Short Link
The install script is located at: [http://bit.ly/OpenCV-Latest](http://bit.ly/OpenCV-Latest)

## Installation
One Line Install:

`$ curl -fsSL http://bit.ly/OpenCV-Latest | bash -s /path/to/download/folder`

One Line Install With Bumblebee:

`$ curl -fsSL http://bit.ly/OpenCV-Latest | optirun bash -s /path/to/download/folder`

## Fetching Updates
One Line Install:

`$ curl -fsSL http://bit.ly/OpenCV-Latest | bash -s /existing/download/path`

One Line Install With Bumblebee:

`$ curl -fsSL http://bit.ly/OpenCV-Latest | optirun bash -s /existing/download/path`

## Pre Install
You need to have the curl package to issue the online install.

`$ sudo apt install curl`

## Post Install
Make sure to setup relevant paths for python so that OpenCV packages can be
accessed. Generally the the path will be:

`$HOME/.opencv/lib/pythonX.X/dist-package`

Where X.X = {2.7, 3.2}. If your system does not have $PYTHONPATH variable, set
this in your profile.

## Features
This script will download and install everything required by OpenCV and build
everything fresh. In case you already have the repos downloaded and just want
to refresh the latest build. Simply provide the same download path and
everything latest will be pulled in.

## License
GPLv3
