//
//  ParentVC.swift
//  NewsTestProject
//
//  Created by Sergei on 3/24/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit
import Moya

class ParentVC: UIViewController {
    
    var backgroundImageView: UIImageView?
    
    override func loadView() {
        super.loadView()
        
        applyUIChanges()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func applyUIChanges() {
        //set background image
        let image = #imageLiteral(resourceName: "themeBackground")
        backgroundImageView = UIImageView(image: image)
        backgroundImageView?.contentMode = .scaleAspectFill
        backgroundImageView?.clipsToBounds = true
        self.view.insertSubview(backgroundImageView!, at: 0)
        backgroundImageView?.frame = self.view.frame
    }
}

