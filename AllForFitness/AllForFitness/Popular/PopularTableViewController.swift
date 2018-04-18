//
//  PopularTableViewController.swift
//  AllForFitness
//
//  Created by Aleksandr Avdukich on 18.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

class PopularTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultsController: NSFetchedResultsController<Train>!
    var exercises: [Train] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<Train> = Train.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
         if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            do {
                try fetchResultsController.performFetch()
                exercises = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Fetch results controller delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
            tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        case .delete: guard let indexPath = indexPath else { break }
             tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        case .update: guard let indexPath = indexPath else { break }
             tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        default: tableView.reloadData()
        }
        exercises = controller.fetchedObjects as! [Train]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exercises.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PopularTableViewCell
        cell.popularImageView.image = UIImage(named: exercises[indexPath.row].image!)
        cell.popularNameLabel.text = exercises[indexPath.row].name
        return cell
    }
}

