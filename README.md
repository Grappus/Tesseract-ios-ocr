A sample Optical character recognition project using Tesseract ios.

This project uses following three external libraries:

1) <a href="https://github.com/gali8/Tesseract-OCR-iOS">TesseractOCR</a>

2) <a href="https://github.com/michaeltyson/TPKeyboardAvoiding">TPKeyboardAvoiding</a>

3) <a href="https://github.com/TimOliver/TOCropViewController">TOCropViewController</a>
<h2>Example:</h2>
 
To run the example project, clone the repo, and run ```pod install```

This project uses english training data. The training data can be updated at a later stage. You can find available training data <a href="https://github.com/tesseract-ocr/">here</a>

<h2>Xcode settings</h2>

set ```ENABLE_BITCODE = NO``` to run the project on device. 

Note:  ```ENABLE_BITCODE``` should also be set ```NO ``` for each pod project too.

For more info visit the git hub library of <a href=" https://github.com/gali8/Tesseract-OCR-iOS/wiki/Installation">Tesseract</a>

You can find the entire tutorials on Raywenderlich's   <a href="https://www.raywenderlich.com/306-tesseract-ocr-tutorial-for-ios">website</a>

<h2>To Do:</h2>

1)Autofill basic forms(such as Name, DOB etc) from user ID (eg:- Password, Driving licence etc)

2)Better image processing for increased accuracy


