//
//  PlayerCell.swift
//  NewsTestProject
//
//  Created by Sergii on 3/26/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell {

    @IBOutlet weak var placementLabel: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerStats: UILabel!
    
    func fillData(player:Player, position: Int) {
        
        placementLabel.text = "\(position + 1)"
        playerName.text = player.name
        playerStats.text = playerStats(kills: Int(player.kills), deaths: Int(player.deaths), latency: Int(player.ping) , score: Int(player.score))
        
    }
    
    func playerStats(kills:Int, deaths:Int, latency:Int, score:Int) -> String {
        return String(format: NSLocalizedString("player_stats_value", comment: "player stats in list"), kills, deaths, score, latency)
    }
    
}
