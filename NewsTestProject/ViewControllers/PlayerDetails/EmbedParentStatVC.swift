//
//  EmbedParentStatVC.swift
//  NewsTestProject
//
//  Created by Sergei on 3/27/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit

class EmbedParentStatVC: UIViewController {

    var stats:PlayerStats!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fillData(with: stats)
    }

    func fillData(with stats: PlayerStats) {}
}
