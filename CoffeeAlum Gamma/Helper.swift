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
    
    static func validate(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        // Uses NSPredicate to filter through the email address string using the Regular Expression
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", regex)
        return emailCheck.evaluate(with: email)
    }

}

extension UIImage {
    
    func toString() -> String{
        var data = Data()
        data = UIImageJPEGRepresentation(self, 0.8)!
        let base64String = data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        return base64String
    }
}

extension String {
    
    func toImage() -> UIImage {
        let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters)
        let image = UIImage(data: data!)
        return image!
    }
    
}

extension Date {
    
    func convertToString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }
    
}
