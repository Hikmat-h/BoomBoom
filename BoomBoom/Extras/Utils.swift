//
//  Utils.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/9/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationItem{
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        
        /*Changing color*/
        backItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        self.backBarButtonItem = backItem
    }
    
}

class Utils {
    static let current = Utils()
    private init(){}
    
    func setButtonStyle(btn: UIButton) -> UIButton {
        btn.layer.borderWidth = 2
        btn.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.1019607843, blue: 0.2941176471, alpha: 1)
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 30
        return btn
    }
    
    func setTextFieldStyle(_ textField: UITextField, placeholder: String = "") -> UITextField {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.size.height))
        textField.leftView = paddingView
        textField.clipsToBounds = true
        textField.leftViewMode = UITextField.ViewMode.always
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.6274509804, alpha: 1).cgColor
        let lightGray = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                              attributes: [NSAttributedString.Key.foregroundColor: lightGray])
        return textField
    }
}
