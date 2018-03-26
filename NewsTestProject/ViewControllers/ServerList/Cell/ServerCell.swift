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
        onlineStatus.text = status ? "Online" : "Offline"
        onlineStatus.textColor = status ? .green : .red
        playerCounter.text = String(format: "Players: %i/%i", data.currentPlayers().count, data.maxPlayers)
        
        if let localImage = Bundle.main.path(forResource: data.mapName?.lowercased(), ofType: "jpg") {
            mapImage.image = UIImage(contentsOfFile: localImage)
        }
        
    }
}
