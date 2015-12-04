##(NEW) About the due date.##
TA strongly recommend you to completely finish all items in this PA even after the due date.
Higher grade will be given to a completed PA after the due date than an incomplete PA.
I will accept submissions until 20 Dec, but will give you a penalty.

##(NEW) A [leader board](https://docs.google.com/spreadsheets/d/1tV67MSfChC-ah2gn2GU4pQNehc66Pkp4ROgfKyU9WSo/edit?usp=sharing) is opened!##
Please report your scores on this [leader board](https://docs.google.com/spreadsheets/d/1tV67MSfChC-ah2gn2GU4pQNehc66Pkp4ROgfKyU9WSo/edit?usp=sharing) to share the results.
I thank Yukyung Choi, RCV Lab. for making this board.

#PA3) Image Representations with a Pre-trained Deep Convolutional Neural Network.
We have three tasks in PA3 including 1) image representations, 2) their applications, and 3) a report. 
You can finish most of implementations by filling all functions located in “/fillfun” directory if you 
use the provided skeleton code. The image database for this PA is [MIT Scene 67 dataset]
(http://web.mit.edu/torralba/www/indoor.html) which is composed of 67 scene categories. A lecture about 
detailed explanation will be provided next week.

##Task 1. Image representations.##
First, represent images by the three following ways, given a pre-trained CNN.
- **1) Image representation by a single global activation.** Start from “cnnAvgPool.m”.
- **2) Image representation by average-pooling of multiple global activations.** Start from “cnnAvgPool.m”.
- **3) Image representation by Fisher-pooling of multiple local activations.** Start from “cnnFisherPool.m”.

##Task 2. Applications.##
Conduct the four following experiments.
- **1) Image classification for each image representation.** Train image classifiers and measure the 
classification performance (Top-1 accuracy). TA will open a leaderboard where you report your classification 
scores to share them with each other.
- **2) Weakly-supervised per-class confidence map with Fisher-pooling.** For any 5 images from the test dataset, 
make their confidence maps, given the SVMs trained for the image classification task.
- **3) Image retrieval for each image representation.** For any 5 images from the test dataset as query images, 
retrieve the top-20 images from each query. All training images are the target database.
- **(Optional) Improving image classification.** Improve the classification performance with your own idea. 
For example, you can suggest your own image representations, or use better classifiers than SVMs. 
There is no limitation for improvement. Even if it is optional, *TA will give you unlimited additional scores 
according to your idea.*

##Task 3. Report.##
The report MUST contain the following items and their discussion/analysis/comparison. Explanation of your 
understanding of each method is not necessary but deep discussion/analysis/comparison about the results will 
be dominant for your grade.
- **1) Image classification performance table of each image representation.**
- **2) For Fisher-pooling, 5 examples of per-class confidence map.**
- **3) For each image representation, 5 examples of image retrieval results.**

##About programming languages and deep learning toolkits.##
Any kind of languages or deep learning toolkits is available. However, it would be the most efficient choice 
for you to use the provided skeleton codes combined with MatConvNet to successfully finish this PA. 

##Pre-trained CNN.##
In this PA, you must use the pre-trained CNN of VGG-M model which is pre-trained over the ILSVRC2012 dataset only. 
This pre-trained network is available in online if you use MatConvNet or Caffe.

##Using GPU.##
If you have a graphic-card which is higher than GTX580 series (e.g. GTX 7xx, GTX TATAN Black, GTX TATAN X, ...), 
you can significantly boost the feed-forwarding speed for this PA. If you are not equipped with GPU, I highly 
recommend you to start this PA soon because the processing time with CPU will take long. 

##Using skeleton code.##
- Utilize the comments written in skeleton codes. Most of instructions for implementation (e.g. meaning of in/out 
parameters, meaning of variables/functions) are described as a form of comments in the skeleton.

##Getting started with skeleton code.##
- 1) Download and install the [VLFeat package](http://www.vlfeat.org/) (already used in PA2).
- 2) Download the [MatConvNet package](https://github.com/vlfeat/matconvnet).
- 3) Install MatConvNet. Follow the [installation instruction](http://www.vlfeat.org/matconvnet/install/) according 
to your machine environment.
- 4) Download the [pre-trained VGG-M model](http://www.vlfeat.org/matconvnet/pretrained/) (imagenet-vgg-m).
- 5) Download/extract [MIT Scene67 dataset](http://web.mit.edu/torralba/www/indoor.html).
- 6) Download the [PA3 skeleton codes](https://github.com/cvpa3/pa3).
- 7) Open “init.m” in the skeleton codes and set every path required.

##Utilize our open discussion channel.##
You can utilize ["Issues" board](https://github.com/cvpa3/pa3/issues) as a site for an open discussion, like Stack Overflow. Do not feel embarrassed to ask! If you have any questions regarding the PA, post in this board. Others, who can give a tip to the questions, reply to the questions. There is no limitation on the discussion subjects.
- **EXTRA CREDITS** will be given to those who actively participate in discussions, especially to those who actively answer to other students' questions.
- When posting (both questions and answers), please write YOUR STUDENT ID so I can recognize who you are and give credits.
- When you post a reply, DO NOT COPY AND PASTE YOUR SOURCE CODE.

##Submission.##
Tentative due date is **December 4, 2015**.
Submit your PA3 to dgyoo@rcv.kaist.ac.kr with the following attachments.
- Source codes: IDXXXXXXXX.zip
- A report: IDXXXXXXXX.pdf

