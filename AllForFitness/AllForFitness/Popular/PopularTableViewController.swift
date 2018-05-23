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
    
    var fetchResultsController: NSFetchedResultsController<Popular>!
    var exercises: [Popular] = []
    var searchController: UISearchController!
    var filteredResultArray: [Popular] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavBar.
        navigationController?.navigationBar.prefersLargeTitles = true
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.blue]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil) // Убрать текст "Популярные" из кнопки назад в Navigation Bar.
        
        let fetchRequest: NSFetchRequest<Popular> = Popular.fetchRequest()
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
    
    // Метод, необходимый для того, чтобы отфильтровать массив популярных тренировок в новый массив filteredResultArray при поиске.
    func filterContentFor(searchText text: String) {
        filteredResultArray = exercises.filter { (exercise) -> Bool in
            guard exercise.name != nil else { return false }
            return (exercise.name!.lowercased().contains(text.lowercased()))
        }
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
        exercises = controller.fetchedObjects as! [Popular]
        //        filterContentFor(searchText: searchController.searchBar.text!)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        } else {
            return exercises.count
        }
    }

    //MARK: Custom Cells
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Вращение
        let degree: Double = 90
        let rotationAngle = CGFloat(degree * .pi / 180)//Угол на который мы будем разворачивать ячейки
        let rotationTransform = CATransform3DMakeRotation(rotationAngle, 1, 0, 0)
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseInOut, animations: {
            cell.layer.transform = CATransform3DIdentity //возвращаем в исходное положение
        })
    }
    
    // Метод, необходимый для того, чтобы отображать рестораны в строках секции при условии поискового запроса.
    func exerciseToDisplay(indexPath: IndexPath) -> Popular {
        let exercise: Popular
        if searchController.isActive && searchController.searchBar.text != "" { // Если есть поисковый запрос, то отображаются заметки из массива filteredResultArray, иначе отображаются все заметки из массива items.
            exercise = filteredResultArray[indexPath.row]
        } else  {
            exercise = exercises[indexPath.row]
        }
        return exercise
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PopularTableViewCell
        let exercise = exerciseToDisplay(indexPath: indexPath)
        
        cell.popularViewCell.layer.cornerRadius = cell.frame.height / 2
        cell.popularImageView.image = UIImage(named: exercise.image!)
        cell.popularImageView.layer.cornerRadius = cell.popularImageView.frame.height / 2
        //cell.popularImageView.layer.cornerRadius = 32.5
        //cell.popularImageView.clipsToBounds = true
        cell.popularNameLabel.text = exercise.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
        guard editingStyle == .delete else { return }
        let exercise = self.exerciseToDisplay(indexPath: indexPath) // Экземпляр класса Popular в массиве либо filteredResultArray, либо exercises.
        context?.delete(exercise)
        if self.searchController.isActive && self.searchController.searchBar.text != "" {
            tableView.beginUpdates()
            self.filteredResultArray.remove(at: indexPath.row)
            for i in 0..<self.exercises.count {
                if exercise.id == Double(i) {
                    self.exercises.remove(at: i)
                }
            }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            tableView.endUpdates()
        } else  {
            self.exercises.remove(at: indexPath.row)
        }
        // Пересохранение контекста.
        do {
            try context?.save()
            print("filtered count - \(self.filteredResultArray.count), exercises count - \(self.exercises.count)")
        } catch let error as NSError {
            print("Error: \(error), description \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popularDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let dvc = segue.destination as? PopularDetailViewController else { return }
                dvc.popularTrain = exerciseToDisplay(indexPath: indexPath)
            }
        }
    }
}

// Подписываемся под протокол UISearchResultsUpdating для поисковой панели в tableView. Подписываемся через extension.
extension PopularTableViewController: UISearchResultsUpdating {
    // Этот метод вызывается тогда, когда что-то изменяется в поисковом запросе. Тогда сразу обновляется tableView.
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData() // Перезагружаем таблицу.
    }
}

extension PopularTableViewController: UISearchBarDelegate {
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


