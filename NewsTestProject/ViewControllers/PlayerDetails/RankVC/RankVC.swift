//
//  RankVC.swift
//  NewsTestProject
//
//  Created by Sergei on 3/27/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit

class RankVC: EmbedParentStatVC {

    @IBOutlet weak var rankImage: UIImageView!
    @IBOutlet weak var rankProgressValue: UILabel!
    @IBOutlet weak var rankProgressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func fillData(with stats: PlayerStats) {
        super.fillData(with: stats)
        
        var imagePath = Bundle.main.path(forResource: "r0", ofType: "png")
        var progress:Float = 0.0
        var scoreProgressValue = "0/0"
        
        if let rankStats = stats.rankStat, let currentRank = stats.rank {
            imagePath = Bundle.main.path(forResource: currentRank.img, ofType: "png")
            scoreProgressValue = String(format: "%i/%i", currentRank.neededRankScore, currentRank.neededRankScore)
            progress = 1
            
            if let nextRank = currentRank.next {
                imagePath = Bundle.main.path(forResource: nextRank.img, ofType: "png")
                scoreProgressValue = String(format: "%i/%i", rankStats.rankCurrentRel, nextRank.needRankScoreRel)
                progress = rankStats.rankProgress/100
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            let image = UIImage(contentsOfFile: imagePath!)
            DispatchQueue.main.async {
                self.rankImage.image = image
            }
        }
        
        rankProgressValue.text = scoreProgressValue
        rankProgressView.progress = progress
    }
}
