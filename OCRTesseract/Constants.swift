//
//  Constants.swift
//  OCRTesseract
//
//  Created by Romit Kumar on 20/08/18.
//  Copyright © 2018 Romit Kumar. All rights reserved.
//

import Foundation
import UIKit

let screenSize: CGRect = UIScreen.main.bounds

extension UIViewController {
func alertify(message:String, in controller:UIViewController, success: Bool) {
  let errorView = UIView()
  errorView.frame = CGRect(x: 0, y: -150, width: screenSize.width, height: 100)
  
  let shadowView = UIView()
  shadowView.backgroundColor = hexStringToUIColor(hex: "8E8E8E")
  shadowView.layer.masksToBounds=false
  shadowView.frame = CGRect(x: 35, y: 37, width: errorView.frame.size.width - 70, height: 34)
  shadowView.layer.shadowOffset = CGSize(width:0, height: 20)
  shadowView.layer.shadowOpacity = 0.4
  shadowView.layer.shadowRadius = 20
  shadowView.layer.shadowColor = hexStringToUIColor(hex:"8E8E8E").cgColor
  
  errorView.addSubview(shadowView)
  
  let errorMessageView = UIView()
  errorMessageView.layer.masksToBounds=true
  if success {
    errorMessageView.backgroundColor = hexStringToUIColor(hex:"3BE95C")
  } else {
    errorMessageView.backgroundColor = hexStringToUIColor(hex:"FF5D47")
  }
  
  errorMessageView.frame = CGRect(x: 10, y: 18, width: errorView.frame.size.width - 20, height: 53)
  errorMessageView.layer.cornerRadius = 5
  let subview = UIView()
  if success {
    errorMessageView.backgroundColor = hexStringToUIColor(hex:"3BE95C")
  } else {
    errorMessageView.backgroundColor = hexStringToUIColor(hex:"FF5D47")
  }
  subview.frame = CGRect(x: 53, y: 6, width: errorMessageView.frame.size.width - 106, height: 40)
  
  let image: UIImage = UIImage(named: "Warning inverted")!
  let errorImage = UIImageView(image: image)
  errorImage.frame = CGRect(x: 0, y: 8, width: 24, height: 25)
  print(subview.frame.size.width)
  
  let errorLabel = UILabel()
  errorLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
  errorLabel.numberOfLines = 0
  errorLabel.frame = CGRect(x: 37, y: 7.5, width: subview.frame.size.width, height: 25)
  errorLabel.text = message
  errorLabel.font = UIFont(name: "Rubik-Medium",
                           size: 14.0)
  print(errorLabel.intrinsicContentSize)
  if(errorLabel.intrinsicContentSize.width <= errorLabel.frame.size.width) {
    errorLabel.font = UIFont(name: "Rubik-Medium",
                             size: 14.0)
  } else {
    subview.frame = CGRect(x:20, y: 6, width: errorMessageView.frame.size.width - 40, height: 40)
    errorLabel.font = UIFont(name: "Rubik-Medium",
                             size: 12.0)
  }
  errorLabel.textColor = hexStringToUIColor(hex:"FFFFFF")
  print(errorLabel.intrinsicContentSize)
  print(errorLabel.frame.size.width)
  
  subview.addSubview(errorLabel)
  subview.addSubview(errorImage)
  
  errorMessageView.addSubview(subview)
  errorView.addSubview(errorMessageView)
  
  controller.view.addSubview(errorView)
  
  //bring in the error view from top
  UIView.animate(withDuration: 0.3,
                 delay: 0.2,
                 usingSpringWithDamping:0.7,
                 initialSpringVelocity: 0.8,
                 options: .curveEaseInOut,
                 animations: {
                  errorView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 100)
                  self.view.layoutIfNeeded()
  }, completion: nil
  )
  // set a timer for auto dismissal of the error view after a few seconds
  Timer.scheduledTimer(timeInterval: 4.0,
                       target: self,
                       selector: #selector(dismissErrorMessage(sender:)),
                       userInfo: errorView,
                       repeats: false)
}
  @objc func dismissErrorMessage(sender: Timer) {
    //  self.errorViewTopConstraint.constant = 0
    let errorView: UIView = sender.userInfo as! UIView
    UIView.animate(withDuration: 0.2,
                   delay: 0,
                   options: .curveEaseInOut,
                   animations: {
                    errorView.frame = CGRect(x: 0, y: -150, width: screenSize.width, height: 100)
                    self.view.layoutIfNeeded()
    }, completion: { Bool in
      errorView.isHidden = true
    }
    )
  }

}

func hexStringToUIColor (hex:String) -> UIColor {
  //This function converts hexcode to UIColor
  var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
  
  if (cString.hasPrefix("#")) {
    cString.remove(at: cString.startIndex)
  }
  
  if ((cString.count) != 6) {
    return UIColor.gray
  }
  
  var rgbValue:UInt32 = 0
  Scanner(string: cString).scanHexInt32(&rgbValue)
  
  return UIColor(
    red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
    green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
    blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
    alpha: CGFloat(1.0)
  )
}
