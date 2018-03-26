//
//  UIViewController+Extension.swift
//  NewsTestProject
//
//  Created by Sergei on 3/25/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

protocol Loadable {
    func startLoading()
    func finishLoading()
    func startLoading(text:String)
    func finishLoading(with error:String)
}

extension UIViewController: Loadable {
    
    func startLoading(text: String) {
        SVProgressHUD.show(withStatus: text)
    }
    
    func finishLoading() {
        SVProgressHUD.dismiss()
    }
    
    func startLoading() {
        SVProgressHUD.show()
    }
    
    func finishLoading(with errorMsg: String) {
        SVProgressHUD.showError(withStatus: errorMsg)
    }
}
