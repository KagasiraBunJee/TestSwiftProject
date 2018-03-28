//
//  StatsVC.swift
//  NewsTestProject
//
//  Created by Sergei on 3/27/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit

class StatsVC: EmbedParentStatVC {

    @IBOutlet weak var kdrLabel: UILabel!
    @IBOutlet weak var spmLabel: UILabel!
    @IBOutlet weak var kpmLabel: UILabel!
    @IBOutlet weak var killsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timePlayedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func fillData(with stats: PlayerStats) {
        super.fillData(with: stats)
        
        kdrLabel.text = String(format: "%.2f", stats.kdr)
        spmLabel.text = String(format: "%.2f", stats.spm)
        kpmLabel.text = String(format: "%.2f", stats.kpm)
        killsLabel.text = String(format: "%i", stats.kills)
        scoreLabel.text = CustomNumberFormatter.decimalFormatter.string(from: NSNumber(value: stats.currentScore))
        timePlayedLabel.text = String(format: "%@", Utils.timestampToHoursAndMinutes(timestamp: Int(stats.timePlayed)))
    }
}
