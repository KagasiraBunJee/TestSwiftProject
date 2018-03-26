//
//  ServerListVC.swift
//  NewsTestProject
//
//  Created by Sergei on 3/25/18.
//  Copyright © 2018 Sergei. All rights reserved.
//

import UIKit
import CoreData

class ServerListVC: ParentVC {

    @IBOutlet weak var tableView: UITableView!
    
    private var serverService = ServerServiceImp.shared
    private var refresh = UIRefreshControl()
    
    lazy var fetchedResultController:NSFetchedResultsController<Server> = {
        
        let request = NSFetchRequest<Server>(entityName: "Server")
        request.sortDescriptors = [NSSortDescriptor(key: "version", ascending: false)]
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStackImp.shared.context, sectionNameKeyPath: nil, cacheName: nil)
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

        refresh.addTarget(self, action: #selector(self.loadServers), for: .valueChanged)
        tableView.addSubview(refresh)
        
        loadServers()
    }

    @objc
    func loadServers() {
        
        let ips = fetchedResultController.fetchedObjects!.flatMap { (server) -> String? in
            guard let hostname = server.hostname else {
                return nil
            }
            
            return hostname + ":\(server.port)"
        }
        
        startLoading()
        serverService.refreshServers(endpoints: ips, game: .bf4).done { (servers) in
            self.refresh.endRefreshing()
            self.finishLoading()
        }.catch { (error) in
            self.finishLoading(with: error.localizedDescription)
        }
    }
    
    func addServer(ip:String, port:String) {
        
        startLoading()
        serverService.addServer(ip: ip, port: port, game: .bf4).done { (server) in
            self.refresh.endRefreshing()
            self.finishLoading()
        }.catch { (error) in
            self.finishLoading(with: error.localizedDescription)
        }
    }
    
    @IBAction func addServerAction(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: NSLocalizedString("add_server_alert_msg", comment: "add server title"), preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "IP address"
            textField.text = "94.250.199.113"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Port"
            textField.text = "25200"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
            
            guard let ip = alert.textFields?.first?.text, let port = alert.textFields?[1].text else {
                return
            }
            self?.addServer(ip: ip, port: port)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPlayers(of server:Server) {
        let vc = VCLoader<PlayersListVC>.load(storyboardId: .PlayersList, inStoryboardID: "playerList")
        vc.server = server
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ServerListVC: UITableViewDataSource {
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "serverItem", for: indexPath) as! ServerCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let server = fetchedResultController.object(at: indexPath)
        if let cell = cell as? ServerCell {
            cell.fillData(with: server)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let server = fetchedResultController.object(at: indexPath)
        self.showPlayers(of: server)
    }
}

extension ServerListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ServerListVC: NSFetchedResultsControllerDelegate {
    
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
