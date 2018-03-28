//
//  VCLoader.swift
//  NewsTestProject
//
//  Created by Sergii on 3/26/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit
import Foundation

enum Storyboard: String {
    case ServerList
    case PlayersList
    case PlayerStats
}

protocol VCLoaderProtocol {
    static func load<VC: UIViewController>(storyboardName storyboard: String!) -> VC
    static func load<VC: UIViewController>(storyboardName storyboard: String!, inStoryboardID: String!) -> VC
}

class VCLoader<VC: UIViewController>: VCLoaderProtocol {
    
    static func load<VC>(storyboardName storyboard: String!) -> VC where VC : UIViewController {
        let className = NSStringFromClass(VC.self).components(separatedBy: ".").last!
        return VCLoader<VC>.load(storyboardName: storyboard, inStoryboardID: className)
    }
    
    static func load<VC>(storyboardName storyboard: String!, inStoryboardID: String!) -> VC where VC : UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: inStoryboardID) as! VC

    }
}

extension VCLoader {
    
    class func load(storyboardId storyboard: Storyboard) -> VC {
        return VCLoader<VC>.load(storyboardName: storyboard.rawValue)
    }
    
    class func load(storyboardId storyboard: Storyboard, inStoryboardID: String!) -> VC {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: inStoryboardID) as! VC
    }
    
    class func loadInitial(storyboardId storyboard: Storyboard) -> VC {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        return storyboard.instantiateInitialViewController() as! VC
    }
}
