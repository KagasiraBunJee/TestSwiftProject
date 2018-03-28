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
        
        if let nextRank = stats.rank?.next {
            guard let imagePath = Bundle.main.path(forResource: nextRank.img, ofType: "png") else {
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                let image = UIImage(contentsOfFile: imagePath)
                DispatchQueue.main.async {
                    self.rankImage.image = image
                }
            }
            
            let scoreProgressValue = String(format: "%i/%i", stats.currentRankScore, stats.nextRankScore)
            rankProgressValue.text = scoreProgressValue
            
            rankProgressView.progress = Float(stats.currentRankScore)/Float(stats.nextRankScore)
        } else if let rank = stats.rank {
            guard let imagePath = Bundle.main.path(forResource: rank.img, ofType: "png") else {
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                let image = UIImage(contentsOfFile: imagePath)
                DispatchQueue.main.async {
                    self.rankImage.image = image
                }
            }
            
            let scoreProgressValue = String(format: "%i/%i", stats.currentRankScore, rank.neededRankScore)
            rankProgressValue.text = scoreProgressValue
            
            rankProgressView.progress = 1.0
        }
    }
}
