//
//  ApiManager.swift
//  ALiTunesSearch
//
//  Created by ALLENMAC on 2017/8/23.
//  Copyright © 2017年 ALLENMAC. All rights reserved.
//

import UIKit

class ApiManager {

    class func GETImage(urlString: String, completion: @escaping (UIImage?) -> ()) -> URLSessionDataTask? {
        return self.GET(urlString: urlString) { (data: Data?, respose: URLResponse?, erro: Error?) in
            if let theData = data {
                completion(UIImage.init(data: theData))
            } else {
                completion(nil)
            }
        }
    }
    
    class func GET(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask? {
        if let URL = URL(string: urlString) {
            let dataTask = URLSession.shared.dataTask(with: URL) { (data: Data?, response: URLResponse?, error: Error?) in
                OperationQueue.main.addOperation {
                    completion(data, response, error)
                }
            }
            dataTask.resume()
            
            return dataTask
        }
        
        return nil
    }
}
