//
//  WeaponCollectionViewCell.swift
//  NewsTestProject
//
//  Created by Sergii on 3/28/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit

class WeaponCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weaponImage: UIImageView!
    @IBOutlet weak var weaponName: UILabel!
    @IBOutlet weak var killPerMinuteLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var killsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func fillData(stat:WeaponStat) {
        
        killsLabel.text = String(format: "%i", stat.kills)
        killPerMinuteLabel.text = String(format: "%.2f", stat.kpm)
        accuracyLabel.text = String(format: "%.2f%%", stat.accuracy)
        
        if let weapon = stat.weapon {
            weaponName.text = weapon.name
            
            if let imagePath = Bundle.main.path(forResource: weapon.img, ofType: "png") {
                DispatchQueue.global(qos: .background).async {
                    let image = UIImage(contentsOfFile: imagePath)
                    DispatchQueue.main.async {
                        self.weaponImage.image = image
                    }
                }
            }
        }
    }
}
