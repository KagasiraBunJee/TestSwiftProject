//
//  PlayerStatsVC.swift
//  NewsTestProject
//
//  Created by Sergei on 3/27/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit

class PlayerStatsVC: ParentVC {

    var player:Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = player.name
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let embedStats = segue.destination as? EmbedParentStatVC {
            embedStats.stats = player.stat!
        }
    }
}
