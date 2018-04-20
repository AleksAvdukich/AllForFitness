//
//  ExerciseDetailViewController.swift
//  AllForFitness
//
//  Created by Aleksandr Avdukich on 25.03.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

class ExerciseDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // NSFetchedResultsControllerDelegate

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var noteButton: UIButton!
    @IBOutlet weak var popularButton: UIButton!
    
    var train: Training?
    var fetchResultsController: NSFetchedResultsController<Popular>!
    var popularExercises: [Popular] = []
    
    // Обратный сигвэй от NoteTableViewController. От кнопки "Назад" в Exit.
    @IBAction func unwindToDetailViewController(segue: UIStoryboardSegue) {

    }
    
    // Обратный сигвэй от RateViewController при нажатии кнопки close (Close -> Exit).
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    
    // Обратный сигвэй от RateViewController при нажатии кнопок лайк/дизлайк (RateViewController -> Exit). Сигвэй имеет идентификатор "unwindSegueToDVC". Вызывается он в контроллере RateViewController при нажатии кнопок с тэгом 0 и 1 в @IBAction func rateRestaurant(sender: UIButton)
    @IBAction func unwindSegueToDetailViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindSegueToDVC" else { return }
        guard let svc = segue.source as? RateViewController else { return }
        guard let rating = svc.trainRating else { return }
        rateButton.setImage(UIImage(named: rating), for: UIControlState.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false // Не прячем Navigation Bar при проматывании вниз.
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 38
        tableView.rowHeight = UITableViewAutomaticDimension // Автоматическое увеличение высоты строки. Поскольку у ячейки есть строгие констрэйнты относительно строки, следовательно, когда в ячейке большой текст, то растягивается строка, а значит, растягивается и ячейка.
        title = train!.name // В Navigation Bar отображается название тренировки. Это название имеет цвет и шрифт такой, какой прописали в AppDelegate.swift.
        imageView.image = UIImage(named: train!.image) // Отображение изображения упражнения.
        
        let fetchRequest: NSFetchRequest<Popular> = Popular.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//            fetchResultsController.delegate = self
            do {
                try fetchResultsController.performFetch()
                popularExercises = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Рамка для кнопок.
        let buttons = [rateButton, noteButton, popularButton]
        for button in buttons {
            guard let button = button else { break }
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blue.cgColor
        }
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
//
//        switch type {
//        case .insert: guard let indexPath = newIndexPath else { break }
//        tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
//        case .delete: guard let indexPath = indexPath else { break }
//        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
//        case .update: guard let indexPath = indexPath else { break }
//        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
//        default: tableView.reloadData()
//        }
//        popularExercises = controller.fetchedObjects as! [Train]
//
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Информация об упражнении:"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ExerciseDetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.keyLabel.text = "Название"
            cell.valueLabel.text = train!.name
        case 1:
            cell.keyLabel.text = "Тип"
            cell.valueLabel.text = train!.type
        case 2:
            cell.keyLabel.text = "Описание"
            cell.valueLabel.text = train!.description
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Сигвэй в NoteTableViewController. От кнопки "Заметки" идет сигвэй Show.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.destination is NoteTableViewController else { return }
    }

    @IBAction func popularButtonPressed(_ sender: UIButton) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            let exercise = Popular(context: context)
            exercise.name = train?.name
            exercise.image = train?.image
            do {
                if !popularExercises.isEmpty {
                    for i in 0..<popularExercises.count {
                        var counter = 0
                        if exercise.name == popularExercises[i].name {
                            counter += 1
                        }
                        if counter == 0 {
                            try context.save()

                            let ac = UIAlertController(title: "Сохранение удалось", message: "Теперь Вы можете посмотреть данное упражнение в разделе Избранное", preferredStyle: UIAlertControllerStyle.alert)
                            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                            ac.addAction(ok)
                            present(ac, animated: true, completion: nil)

                            print("Сохранение удалось!")
                        } else {
                            context.delete(exercise)
                            try context.save()
                            
                            let ac = UIAlertController(title: "Сохранение не удалось", message: "Данное упражнение уже есть в разделе Избранное", preferredStyle: UIAlertControllerStyle.alert)
                            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                            ac.addAction(ok)
                            present(ac, animated: true, completion: nil)
                            
                            print("Сохранение не удалось!")
                        }
                    }
                } else {
                    try context.save()

                    let ac = UIAlertController(title: "Сохранение удалось!", message: "Теперь Вы можете посмотреть данное упражнение в разделе Избранное", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    ac.addAction(ok)
                    present(ac, animated: true, completion: nil)

                    print("Сохранение удалось!")
                }
            } catch let error as NSError {
                    print(error.localizedDescription)
            }
        }
    }
}
