//
//  NoteTableViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 10.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController {
    //, NSFetchedResultsControllerDelegate {
    
    var items: [Note] = []
    //    var fetchResultsController: NSFetchedResultsController<Note>!
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    // Обратные сигвэи от SaveNoteTableVC и EditNOteTableVC. Первый от кнопки Cancel -> Exit. Два других от соотвествующих TableVC -> Exit. Имеют идентификаторы unwindSegueFromSaveNote и unwindSegueFromSaveNote. Вызываются в методах saveButtonPressed и editButtonPressed.
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindSegueFromSaveNote(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindSegueFromEditNote(segue: UIStoryboardSegue) {
        
    }
    
    // Загрузка данных из CoreData до загрузкки TableView, т.е. до выполнения метода viewDidLoad.
    override func viewWillAppear(_ animated: Bool) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext { // Обращение к контексту.
            let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest() // Запрос по Note сущности.
            do {
                items = try context.fetch(fetchRequest) // Запрос fetchRequest обращается к контексту и просит вернуть сущность типа Note, т.е. все ее объекты. И все полученные объекты сохраняются в массив.
                self.tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.blue]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        //        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        //        let sortDescriptor = NSSortDescriptor(key: "note", ascending: true)
        //        fetchRequest.sortDescriptors = [sortDescriptor]
        //        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
        //            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        //            fetchResultsController.delegate = self
        //            do {
        //                try fetchResultsController.performFetch()
        //                items = fetchResultsController.fetchedObjects!
        //            } catch let error as NSError {
        //                print(error.localizedDescription)
        //            }
        //        }
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Fetch results controller delegate
    
    //    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    //        tableView.beginUpdates()
    //    }
    //
    //    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    //        switch type {
    //        case .insert: guard let indexPath = newIndexPath else { break }
    //        tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    //        case .delete: guard let indexPath = indexPath else { break }
    //        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    //        case .update: guard let indexPath = indexPath else { break }
    //        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    //        default:
    //            tableView.reloadData()
    //        }
    //        items = controller.fetchedObjects as! [Note]
    //    }
    //
    //    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    //        tableView.endUpdates()
    //    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoteTableViewCell
        guard let noteDate = items[indexPath.row].date as Date? else { return cell }
        cell.dateLabel.text = dateFormatter.string(from: noteDate)
        cell.noteLabel.text = items[indexPath.row].note
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Метод удаления заметки из tableView.
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
    //        guard editingStyle == .delete else { return }
    //        context?.delete(items[indexPath.row]) // Удаление экземпляра класса Note из контекста.
    //        items.remove(at: indexPath.row) // Удаление задачи из массива задач.
    //        // Пересохранение контекста.
    //        do {
    //            try context?.save()
    ////            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade) // Удаление св-ва заметки из tableView.
    //        } catch let error as NSError {
    //            print("Error: \(error), description \(error.userInfo)")
    //        }
    //    }
    
    // Метод, чтобы "Удалить" заметку и "Поделиться" ею.
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Поделиться") { (action: UITableViewRowAction, indexPath) -> Void in
            let defaultText = self.items[indexPath.row].note!
            if let image = UIImage(data: self.items[indexPath.row].image! as Data) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Удалить") { (action: UITableViewRowAction, indexPath) -> Void in
            let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
            context?.delete(self.items[indexPath.row]) // Удаление экземпляра класса Note из контекста.
            self.items.remove(at: indexPath.row) // Удаление заметки из массива задач.
            // Пересохранение контекста.
            do {
                try context?.save()
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade) // Удаление св-ва заметки из tableView.
            } catch let error as NSError {
                print("Error: \(error), description \(error.userInfo)")
            }
        }
        share.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return [delete, share]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let dvc = segue.destination as? EditNoteTableViewController else { return }
                dvc.note = items[indexPath.row]
            }
        }
    }
}


