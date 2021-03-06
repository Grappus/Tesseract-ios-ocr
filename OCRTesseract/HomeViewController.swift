//
//  HomeViewController.swift
//  OCRTesseract
//
//  Created by Romit Kumar on 19/08/18.
//  Copyright © 2018 Romit Kumar. All rights reserved.
//

import UIKit
import TesseractOCR
import CropViewController

class HomeViewController: UIViewController, CropViewControllerDelegate {

  
  //MARK:- IBOutlets
  @IBOutlet weak var uploadImageButon: UIButton!
  @IBOutlet weak var overlayView: UIView!
  @IBOutlet weak var smallDocImageView: UIImageView!
  @IBOutlet weak var recognizedTextView: UITextView!
  @IBOutlet weak var femaleButton: UIButton!
  @IBOutlet weak var maleButton: UIButton!
  @IBOutlet weak var dateOfbirthTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var firstNameTextField: UITextField!

  //MARK:- VAriables
  let tes = G8Tesseract(language: "eng")
  var gender = ""
  
  //MARK:- Lifecycle methods
  override func viewDidLoad() {
        super.viewDidLoad()
        setTextFields()
        activityIndicator.alpha = 0
    }
  
  //MARK:- Default setup methods
  func setTextFields() {
   // MDCTextButtonThemer.applyScheme(buttonScheme, to: submitButton)
    recognizedTextView.layer.borderColor = UIColor.gray.cgColor
    recognizedTextView.layer.borderWidth = 1
    recognizedTextView.layer.cornerRadius = 4
  }
  
  //MARK:- IBActions
  @IBAction func uploadImageButtontapped(_ sender: Any) {
    firstNameTextField.text = ""
    lastNameTextField.text = ""
    dateOfbirthTextField.text = ""
    UIView.animate(withDuration: 0.2) {
         self.presentImagePicker()
    }
  }
  
  @IBAction func viewTapped(_ sender: Any) {
    self.view.endEditing(true)
  }
  
  @IBAction func sumbitButtontapped(_ sender: Any) {
    if firstNameTextField.text == "" {
      self.alertify(message: "Enter a name", in: self, success: false)
      return
    }
    if lastNameTextField.text == "" {
       self.alertify(message: "Enter last name", in: self, success: false)
      return
    }
    if dateOfbirthTextField.text == "" {
      self.alertify(message: "Enter date of birth", in: self, success: false)
      return
    }
    if gender == "" {
      self.alertify(message: "Select a gender", in: self, success: false)
      return
    }
    print("First Name is \(firstNameTextField.text!)")
    print("FLast Name is \(lastNameTextField.text!)")
    print("DOB is \(dateOfbirthTextField.text!)")
    self.alertify(message: "Successfully submitted", in: self, success: true)
  }
  
  @IBAction func takePhotoButtonTapped(_ sender: Any) {
    firstNameTextField.text = ""
    lastNameTextField.text = ""
    dateOfbirthTextField.text = ""
    presentImagePicker()
  }
  
  @IBAction func femaleSelected(_ sender: Any) {
    maleButton.isSelected = false
    femaleButton.isSelected = true
    gender = "female"
  }

  @IBAction func maleSelected(_ sender: Any) {
    maleButton.isSelected = true
    femaleButton.isSelected = false
    gender = "male"
  }
  
  //MARK:- Helper method
  func takePhoto() {
    UIView.animate(withDuration: 0.2) {
      self.overlayView.alpha = 1
    }
   presentImagePicker()
  }
  
  func performImageRecognition(_ image: UIImage) {
    if let tesseract = tes {
      //tesseract.engineMode = .tesseractOnly
      tesseract.pageSegmentationMode = .auto
      tesseract.image = image.g8_blackAndWhite()
      tesseract.recognize()
      print(tesseract.recognizedText)
      uploadImageButon.setTitle("Upload New", for: .normal)
      findData(stringData: tesseract.recognizedText)
      recognizedTextView.text = tesseract.recognizedText
    }
    self.overlayView.alpha = 0
    activityIndicator.stopAnimating()
    self.activityIndicator.alpha = 0
  }
  
  func findData(stringData : String) {
    //Method to find extract data such as name, dob
    print("found")
    var wordsArray = stringData.components(separatedBy: "\n")
    print("wordsArray is \(wordsArray)")
    for word in wordsArray {
      findRelevantData(word: word)
    }
    if firstNameTextField.text == "" {
      wordsArray = wordsArray.filter{$0 != ""}
      wordsArray = wordsArray.filter{$0 != " "}
      wordsArray = wordsArray.filter{$0 != "  "}
      wordsArray = wordsArray.filter{$0 != "   "}
      wordsArray = wordsArray.filter{$0 != "    "}
      if wordsArray.count >= 4 {
      firstNameTextField.text = wordsArray[3]
      }
    }
    if firstNameTextField.text == "" {
      if wordsArray.count > 0 {
      firstNameTextField.text = wordsArray[0]
      }
    }
  }
  
  func findRelevantData(word : String) {
    if word == "" || word == " " {
      return
    }
    if word.contains("Name :") {
       let replaced = word.replacingOccurrences(of: "Name :", with: "")
      extractName(nameData: replaced)
    } else if word.contains("Name:") {
      let replaced = word.replacingOccurrences(of: "Name:", with: "")
      extractName(nameData: replaced)
    } else if word.contains("Name") {
      let replaced = word.replacingOccurrences(of: "Name", with: "")
      extractName(nameData: replaced)
    }
    if word.contains("DOB :") {
      let replaced = word.replacingOccurrences(of: "DOB :", with: "")
      extractDOB(dateData: replaced)
    } else if word.contains("DOB:") {
      let replaced = word.replacingOccurrences(of: "DOB:", with: "")
      extractDOB(dateData: replaced)
    } else if word.contains("DOB") {
      let replaced = word.replacingOccurrences(of: "DOB", with: "")
      extractDOB(dateData: replaced)
    } else if word.contains(" DOB") {
      let replaced = word.replacingOccurrences(of: " DOB", with: "")
      extractDOB(dateData: replaced)
    } else if word.contains(" DOB:") {
      let replaced = word.replacingOccurrences(of: " DOB:", with: "")
      extractDOB(dateData: replaced)
    }
  }
  
  func extractName(nameData:String) {
    var wordsArray = nameData.components(separatedBy: " ")
    wordsArray = wordsArray.filter{$0 != " "}
    wordsArray = wordsArray.filter{$0 != ""}
    for word in wordsArray {
      var num = Int(word)
      if num != nil {
        wordsArray = wordsArray.filter{$0 != word}
      }
    }
    if wordsArray.count == 1 {
      firstNameTextField.text = wordsArray[0]
      return
    } else {
      firstNameTextField.text = wordsArray[0]
      lastNameTextField.text = wordsArray[1]
    }
  }
  
  func extractDOB(dateData : String) {
    var wordsArray = dateData.components(separatedBy: " ")
    wordsArray = wordsArray.filter{$0 != " "}
    wordsArray = wordsArray.filter{$0 != ""}
    
    if wordsArray.count == 1 {
      dateOfbirthTextField.text = wordsArray[0]
      return
    }
    for word in wordsArray {
      if word.count == 10 {
         dateOfbirthTextField.text = word
      }
    }
  }
  
  func presentCropViewController(image:UIImage) {
    
    let cropViewController = CropViewController(image: image)
    cropViewController.delegate = self
    present(cropViewController, animated: true, completion: nil)
  }
  
  func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
          self.performImageRecognition(image)
          self.smallDocImageView.image = image
       self.dismiss(animated: true, completion: nil)
    
  }
  
}

//MARK:- Extensions
// MARK: - UINavigationControllerDelegate
extension HomeViewController: UINavigationControllerDelegate {
}

// MARK: - UIImagePickerControllerDelegate
extension HomeViewController: UIImagePickerControllerDelegate {
  func presentImagePicker() {
    let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Image",
                                                   message: nil, preferredStyle: .actionSheet)
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let cameraButton = UIAlertAction(title: "Take Photo",
                                       style: .default) { (alert) -> Void in
                                        let imagePicker = UIImagePickerController()
                                        imagePicker.delegate = self
                                        imagePicker.sourceType = .camera
                                        self.present(imagePicker, animated: true)
      }
      imagePickerActionSheet.addAction(cameraButton)
    }
    let libraryButton = UIAlertAction(title: "Choose Existing",
                                      style: .default) { (alert) -> Void in
                                        let imagePicker = UIImagePickerController()
                                        imagePicker.delegate = self
                                        imagePicker.sourceType = .photoLibrary
                                        self.present(imagePicker, animated: true)
    }
    imagePickerActionSheet.addAction(libraryButton)
    let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
    imagePickerActionSheet.addAction(cancelButton)
    present(imagePickerActionSheet, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    if let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage,
      let scaledImage = selectedPhoto.scaleImage(640) {
      activityIndicator.alpha = 1
      activityIndicator.startAnimating()
      dismiss(animated: true, completion: {
        self.presentCropViewController(image: selectedPhoto)
      })
    }
  }
}

extension UIImage {
  func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
    var scaledSize = CGSize(width: maxDimension, height: maxDimension)
    if size.width > size.height {
      let scaleFactor = size.height / size.width
      scaledSize.height = scaledSize.width * scaleFactor
    } else {
      let scaleFactor = size.width / size.height
      scaledSize.width = scaledSize.height * scaleFactor
    }
    UIGraphicsBeginImageContext(scaledSize)
    draw(in: CGRect(origin: .zero, size: scaledSize))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return scaledImage
  }
}

extension HomeViewController : UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }
}
