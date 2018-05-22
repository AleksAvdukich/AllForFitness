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
    var searchController: UISearchController!
    var filteredResultArray: [Note] = []
    
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
    
    // Метод, необходимый для того, чтобы отфильтровать массив заметок в новый массив filteredResultArray при поиске.
    func filterContentFor(searchText text: String) {
        filteredResultArray = items.filter { (item) -> Bool in
            guard item.note != nil else { return false }
            return (item.note!.lowercased().contains(text.lowercased())) // В filteredResultArray помещаются только те элементы, имя которых содержит тот же самый текст, что и в поисковом запросе. lowercased() - метод, который принудительно превращает все буквы имени заметки в строчные, так же, как и весь запрос, а затем сравниваются эти два имени: содержит ли имя ресторана именно те буквы, что и поисковый запрос. Если содержит, возвращается true и это имя заметки попадает в filteredResultArray.
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.blue]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        //        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        //        tableView.estimatedRowHeight = 64
        //        tableView.rowHeight = UITableViewAutomaticDimension
        
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
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self // Подписались под то, что данный класс - делегат. Будет выполнять методы протокола UISearchResultsUpdating. Т.е. в классе UISearchController есть св-во var searchResultsUpdater: UISearchResultsUpdating.
        searchController.searchBar.delegate = self // Подписались под то, что данный класс - делегат. Будет выполнять методы протокола UISearchBarDelegate.
        searchController.dimsBackgroundDuringPresentation = false // Никакого затемнения экрана (tableView) при поиске.
        tableView.tableHeaderView = searchController.searchBar // Вверху tableView отображается searchBar searchController.
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.9030755635, green: 0.9030755635, blue: 0.9030755635, alpha: 1)
        searchController.searchBar.tintColor = .blue
        definesPresentationContext = true // Поисковая строка (searchController) не переходит далее.
        
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        } else {
            return items.count
        }
    }
    
    // Метод, необходимый для того, чтобы отображать рестораны в строках секции при условии поискового запроса.
    func noteToDisplay(indexPath: IndexPath) -> Note {
        let note: Note
        if searchController.isActive && searchController.searchBar.text != "" { // Если есть поисковый запрос, то отображаются заметки из массива filteredResultArray, иначе отображаются все заметки из массива items.
            note = filteredResultArray[indexPath.row]
        } else  {
            note = items[indexPath.row]
        }
        return note
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoteTableViewCell
        let note = noteToDisplay(indexPath: indexPath)
        guard let noteDate = note.date as Date? else { return cell }
        cell.dateLabel.text = dateFormatter.string(from: noteDate)
        cell.noteLabel.text = note.note
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
    //            //            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade) // Удаление св-ва заметки из tableView.
    //        } catch let error as NSError {
    //            print("Error: \(error), description \(error.userInfo)")
    //        }
    //    }
    
    // Метод, чтобы "Удалить" заметку и "Поделиться" ею.
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let note = noteToDisplay(indexPath: indexPath)
        let share = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Поделиться") { (action: UITableViewRowAction, indexPath) -> Void in
            let defaultText = note.note!
            if let image = UIImage(data: note.image! as Data) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Удалить") { (action: UITableViewRowAction, indexPath) -> Void in
            let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
            let note = self.noteToDisplay(indexPath: indexPath) // Экземпляр класса Note в массиве либо filteredResultArray, либо items.
            context?.delete(note) // Удаление экземпляра класса Note из контекста.
            if self.searchController.isActive && self.searchController.searchBar.text != "" { // Если есть поисковый запрос, то отображаются заметки из массива filteredResultArray, иначе отображаются все заметки из массива items.
                self.filteredResultArray.remove(at: indexPath.row)
                var counter = 0
                for i in 0..<self.items.count {
                    if note.id == Double(i) {
                        self.items.remove(at: i)
                        counter = i
                    }
                }
                if self.items.count != 0 {
                    for j in counter..<self.items.count {
                        self.items[j].id -= 1.0
                    }
                }
            } else  {
                self.items.remove(at: indexPath.row)
                if self.items.count != 0 {
                    for j in indexPath.row..<self.items.count {
                        self.items[j].id -= 1.0
                    }
                }
            }
            // Пересохранение контекста.
            do {
                try context?.save()
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade) // Удаление св-ва заметки из tableView.
                for t in 0..<self.items.count {
                    print(self.items[t].id)
                }
                print("filtered count - \(self.filteredResultArray.count), items count - \(self.items.count)")
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
                dvc.note = noteToDisplay(indexPath: indexPath)
            }
        }
    }
}

// Подписываемся под протокол UISearchResultsUpdating для поисковой панели в tableView. Подписываемся через extension.
extension NoteTableViewController: UISearchResultsUpdating {
    // Этот метод вызывается тогда, когда что-то изменяется в поисковом запросе. Тогда сразу обновляется tableView.
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData() // Перезагружаем таблицу.
    }
}

extension NoteTableViewController: UISearchBarDelegate {
    // Метод, означающий то, когда мы щелкаем на поисковую строку.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = true // navigationController прячется. То есть остается только searchController.
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = false
    }
}


