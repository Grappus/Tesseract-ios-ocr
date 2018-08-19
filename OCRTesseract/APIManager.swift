//
//  APIManager.swift
//  OCRTesseract
//
//  Created by Romit Kumar on 20/08/18.
//  Copyright © 2018 Romit Kumar. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class APIManager {
  
  var counter = 0
  static let sharedManager = APIManager()
  let windowView = UIApplication.shared.windows.last
  let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
  
  
  func submitData(_ parameters:Dictionary<String,Any>,
              completion: @escaping (Bool, Any?) -> ()) {
      let url = "sample url"
      Alamofire.request(url, method: .post, parameters: parameters, headers: nil).validate(statusCode: 200..<300).responseJSON { response in
        switch response.result {
        case .success:
          completion(true,nil)
        case .failure:
          print("error in sending data")
//          let error = self.processFailure(json: JSON(response.data as Any))
          completion(false, "some error occured")
        }
      }
    }
}
