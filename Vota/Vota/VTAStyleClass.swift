//
//  VTAStyleClass.swift
//  Vota
//
//  Created by Jose Alvarado on 2/29/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAStyleClass: NSObject {

    class func darkBlueColor() -> UIColor {
        return UIColor(red: 13.0/255, green: 51.0/255, blue: 143.0/255, alpha: 1)
    }
    
    class func lightGrayColor() -> UIColor {
        return UIColor(red: 234.0/255, green: 234.0/255, blue: 234.0/255, alpha: 1)
    }    
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}