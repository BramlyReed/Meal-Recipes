//
//  API.swift
//  Meal Recipes
//
//  Created by Stas on 04.12.2020.
//

import Foundation
import UIKit

enum API{
    
    static func randomReq(to_url: String, completion: @escaping (Mealdata) -> Void){
        URLSession.shared.dataTask(with: URL(string: to_url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else{
                print("Some error got after request!")
                return
            }
            var resultmeal: Mealdata
            let decoder = JSONDecoder()
            resultmeal = try! decoder.decode(Mealdata.self, from: data)
            DispatchQueue.main.async {
                completion(resultmeal)
            }
        }).resume()
    }
    
    static func getPhoto(photomodel: String, completion: @escaping (UIImage?) -> Void){
        guard let imageURL = URL(string: photomodel) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            completion(image)
        }
    }
}
