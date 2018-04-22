//
//  NoteTableViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 10.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var items: [Note] = []
    var fetchResultsController: NSFetchedResultsController<Note>!
//    var searchController: UISearchController!
//    var filteredResultArray: [Note] = []
    
    // Обратные сигвэи от SaveNoteTableVC и EditNOteTableVC. Первый от кнопки Cancel -> Exit. Два других от соотвествующих TableVC -> Exit. Имеют идентификаторы unwindSegueFromSaveNote и unwindSegueFromSaveNote. Вызываются в методах saveButtonPressed и editButtonPressed.
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindSegueFromSaveNote(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindSegueFromEditNote(segue: UIStoryboardSegue) {
        
    }
    
    // Загрузка данных из CoreData до загрузкки TableView, т.е. до выполнения метода viewDidLoad.
//    override func viewWillAppear(_ animated: Bool) {
//        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext { // Обращение к контексту.
//            let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest() // Запрос по Note сущности.
//            do {
//                items = try context.fetch(fetchRequest) // Запрос fetchRequest обращается к контексту и просит вернуть сущность типа Note, т.е. все ее объекты. И все полученные объекты сохраняются в массив.
//                self.tableView.reloadData()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
    
//    func filterContentFor(searchText text: String) {
//        filteredResultArray = items.filter { (items) -> Bool in
//            return (items.note?.lowercased().contains(text.lowercased()))! // В filteredResultArray помещаются только те элементы, имя которых содержит тот же самый текст, что и в поисковом запросе. lowercased() - метод, который принудительно превращает все буквы имени ресторана в строчные, так же, как и весь запрос.
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.blue]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "note", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            do {
                try fetchResultsController.performFetch()
                items = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false // Убираем затемнение tableView.
//        tableView.tableHeaderView = searchController.searchBar
//        searchController.searchBar.delegate = self
//        searchController.searchBar.barTintColor = #colorLiteral(red: 0.9030755635, green: 0.9030755635, blue: 0.9030755635, alpha: 1) // Цвет панели SearchBar.
//        searchController.searchBar.tintColor = .blue // Цвет шрифта.
//        definesPresentationContext = true // Поисковая строка (searchController) не переходит далее.
        
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
        default:
            tableView.reloadData()
        }
        items = controller.fetchedObjects as! [Note]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // Возвращаем точное количество ячеек, равное кол-ву элементов либо в массив trains, либо в массиве filteredResultArray.
//        if searchController.isActive && searchController.searchBar.text != "" {
//            return filteredResultArray.count
//        }
        return items.count
    }
    
//    func notesToDisplayAt(indexPath: IndexPath) -> Note {
//        let notes: Note
//        if searchController.isActive && searchController.searchBar.text != "" {
//            notes = filteredResultArray[indexPath.row]
//        } else {
//            notes = items[indexPath.row]
//        }
//        return notes
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoteTableViewCell
//        let note = notesToDisplayAt(indexPath: indexPath)
        cell.noteLabel.text = items[indexPath.row].note
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Метод удаления заметки из tableView.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
        guard editingStyle == .delete else { return }
        context?.delete(items[indexPath.row]) // Удаление экземпляра класса Note из контекста.
        items.remove(at: indexPath.row) // Удаление задачи из массива задач.
        // Пересохранение контекста.
        do {
            try context?.save()
//            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade) // Удаление св-ва заметки из tableView.
        } catch let error as NSError {
            print("Error: \(error), description \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let dvc = segue.destination as? EditNoteTableViewController else { return }
                dvc.note = items[indexPath.row]
//                dvc.note = notesToDisplayAt(indexPath: indexPath)
            }
        }
    }
}

// Подписываемся под протокол UISearchResultsUpdating для поисковой панели в tableView.
//extension NoteTableViewController: UISearchResultsUpdating {
//    // Этот метод вызывается тогда, когда что-то изменяется в поисковом запросе. Тогда сразу обновляется tableView.
//    func updateSearchResults(for searchController: UISearchController) {
//        filterContentFor(searchText: searchController.searchBar.text!)
//        tableView.reloadData() // Перезагружаем таблицу.
//    }
//}
//
//extension NoteTableViewController: UISearchBarDelegate {
//    // Метод, означающий то, когда мы щелкаем на поисковую строку.
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        if searchBar.text == "" {
//            navigationController?.hidesBarsOnSwipe = false // navigationController прячется. То есть остается только searchController.
//        }
//    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        navigationController?.hidesBarsOnSwipe = true // Когда мы ушли с этого окна, мы обратно активируем navigationController
//    }
//}

