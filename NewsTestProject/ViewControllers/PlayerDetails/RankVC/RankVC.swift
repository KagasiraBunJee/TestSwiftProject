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
        
        if let nextRank = stats.rank?.next {
            imagePath = Bundle.main.path(forResource: nextRank.img, ofType: "png")
            
            let beginProgressValue = stats.rank!.neededRankScore
            let nextRankNeed = nextRank.neededRankScore
            let currentDeltaProgress = stats.currentRankScore - beginProgressValue
            let nextRankNeedDelta = nextRankNeed - beginProgressValue
            
            scoreProgressValue = String(format: "%i/%i", currentDeltaProgress, nextRankNeedDelta)
            progress = nextRank.rankProgress/100
        } else if let rank = stats.rank {
            imagePath = Bundle.main.path(forResource: rank.img, ofType: "png")
            scoreProgressValue = String(format: "%i/%i", stats.currentRankScore, rank.neededRankScore)
            progress = 1.0
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
