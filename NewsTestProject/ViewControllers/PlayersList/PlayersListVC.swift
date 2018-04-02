//
//  PlayersListVC.swift
//  NewsTestProject
//
//  Created by Sergii on 3/26/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit
import CoreData

class PlayersListVC: ParentVC {

    @IBOutlet weak private var tableView: UITableView!
    
    private var serverService = ServerServiceImp.shared
    private var playerService = PlayerServiceImp.shared
    private var refresh = UIRefreshControl()
    
    var server:Server!
    lazy var fetchedResultController:NSFetchedResultsController<Player> = {
        
        let request = NSFetchRequest<Player>(entityName: "Player")
        request.sortDescriptors = [NSSortDescriptor(key: "teamId", ascending: true), NSSortDescriptor(key: "score", ascending: false)]
        request.predicate = NSPredicate(format: "server == %@", server)
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStackImp.default.context, sectionNameKeyPath: "teamId", cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch let error {
            debugPrint(error)
        }
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = server.name
        
        refresh.addTarget(self, action: #selector(self.updateInfo), for: .valueChanged)
        tableView.addSubview(refresh)
    }

    @objc
    func updateInfo() {
        startLoading()
        
        serverService.refreshServers(endpoints: [server.fullAddr], game: .bf4).done { (servers) in
            self.refresh.endRefreshing()
            self.finishLoading()
        }.catch { (error) in
            self.finishLoading(with: error.localizedDescription)
        }
    }
    
    func selectPlayer(_ player:Player) {
        
        self.startLoading()
        playerService.playerStats(playerName: player.name!).done { (stats) in
            self.finishLoading()
            let vc = VCLoader<PlayerStatsVC>.load(storyboardId: .PlayerStats, inStoryboardID: "playerStats")
            vc.player = player
            self.navigationController?.pushViewController(vc, animated: true)
        }.catch { (error) in
            
            guard let _ = player.stat else {
                self.finishLoading(with: "There is no stats information")
                return
            }
            self.finishLoading(with: error.localizedDescription)
            
            let vc = VCLoader<PlayerStatsVC>.load(storyboardId: .PlayerStats, inStoryboardID: "playerStats")
            vc.player = player
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension PlayersListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerItem", for: indexPath)
        return cell
    }
}

extension PlayersListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let player = fetchedResultController.object(at: indexPath)
        if let cell = cell as? PlayerCell {
            cell.fillData(player: player, position: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Team(rawValue: Int(fetchedResultController.sections![section].name)!)?.named
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = fetchedResultController.object(at: indexPath)
        self.selectPlayer(player)
    }
}

extension PlayersListVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
