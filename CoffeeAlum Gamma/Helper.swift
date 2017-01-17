//
//  Helper.swift
//  CoffeeAlum Gamma
//
//  Created by Nabil K on 2017-01-16.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    

}

extension UIImage{
    
    func toString() -> String{
        var data = Data()
        data = UIImageJPEGRepresentation(self, 0.8)!
        let base64String = data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        return base64String
    }
}

extension String{
    func toImage() -> UIImage{
        let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters)
        let image = UIImage(data: data!)
        return image!
    }
}
