//
//  MostWeaponKillsVC.swift
//  NewsTestProject
//
//  Created by Sergii on 3/28/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit

class MostWeaponKillsVC: EmbedParentStatVC {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var weaponStats:[WeaponStat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "WeaponCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "weaponCell")
    }

    override func fillData(with stats: PlayerStats) {
        super.fillData(with: stats)
        
        weaponStats = WeaponStat.getTopKillsStatsByUser(name: stats.player!.name!, count: 5)
        collectionView.reloadData()
    }
    
}

extension MostWeaponKillsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weaponStats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "weaponCell", for: indexPath)
    }
    
}

extension MostWeaponKillsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let data = weaponStats[indexPath.row]
        if let cell = cell as? WeaponCollectionViewCell {
            cell.fillData(stat: data)
        }
    }
}

extension MostWeaponKillsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 100)
    }
    
}
