//
//  ServerCell.swift
//  NewsTestProject
//
//  Created by Sergei on 3/25/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit

class ServerCell: UITableViewCell {

    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var mapName: UILabel!
    @IBOutlet weak var onlineStatus: UILabel!
    @IBOutlet weak var playerCounter: UILabel!
    
    func fillData(with data:Server) {
        
        let status = data.status
        
        mapName.text = data.name
        onlineStatus.text = status ? NSLocalizedString("status_online", comment: "server status online") : NSLocalizedString("status_offline", comment: "server status offline")
        onlineStatus.textColor = status ? .green : .red
        
        playerCounter.text = String(format: NSLocalizedString("players_counter_title", comment: "player counter"), data.currentPlayers().count, data.maxPlayers)
        
        if let localImage = Bundle.main.path(forResource: data.mapName?.lowercased(), ofType: "jpg") {
            mapImage.image = UIImage(contentsOfFile: localImage)
        }
        
    }
}
