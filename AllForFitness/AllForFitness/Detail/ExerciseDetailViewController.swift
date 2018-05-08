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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var instructionButton: UIButton!
    
    var train: Training?
    var fetchResultsController: NSFetchedResultsController<Popular>!
    var popularExercises: [Popular] = []
    var counterPopularButtonPressed = 0
    var id: Double?
    var ratingArray: [Rating] = []
    
//    // Обратный сигвэй от NoteTableViewController. От кнопки "Назад" в Exit.
//    @IBAction func unwindToDetailViewController(segue: UIStoryboardSegue) {
//
//    }
    
    // Обратный сигвэй от RateViewController при нажатии кнопок лайк/дизлайк (RateViewController -> Exit). Сигвэй имеет идентификатор "unwindSegueToDVC". Вызывается он в контроллере RateViewController при нажатии кнопок с тэгом 0 и 1 в @IBAction func rateRestaurant(sender: UIButton)
    @IBAction func unwindSegueToDetailViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindSegueToDVC" else { return }
        guard let svc = segue.source as? RateViewController else { return }
        guard let rating = svc.trainRating else { return }
        rateButton.setImage(UIImage(named: rating), for: UIControlState.normal)
    }
    
    // Загрузка данных из CoreData в массив ratingArray до загрузкки TableView, т.е. до выполнения метода viewDidLoad.
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.hidesBarsOnSwipe = false // Не прячем Navigation Bar при проматывании вниз.
//        navigationController?.setNavigationBarHidden(false, animated: true)
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext { // Обращение к контексту.
            let fetchRequest: NSFetchRequest<Rating> = Rating.fetchRequest() // Запрос по Rating сущности.
            do {
                ratingArray = try context.fetch(fetchRequest)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if ratingArray.count != 0 {
            for i in 0..<ratingArray.count {
                if id == ratingArray[i].id {
                    let ratingImage = ratingArray[i].image
                    rateButton.setImage(UIImage(named: ratingImage!), for: UIControlState.normal)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.estimatedRowHeight = 38
        tableView.rowHeight = UITableViewAutomaticDimension // Автоматическое увеличение высоты строки. Поскольку у ячейки есть строгие констрэйнты относительно строки, следовательно, когда в ячейке большой текст, то растягивается строка, а значит, растягивается и ячейка.
        title = train!.name // В Navigation Bar отображается название тренировки. Это название имеет цвет и шрифт такой, какой прописали в AppDelegate.swift.
        imageView.image = UIImage(named: train!.image) // Отображение изображения упражнения.
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        let fetchRequest: NSFetchRequest<Popular> = Popular.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            do {
                try fetchResultsController.performFetch()
                popularExercises = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Рамка для кнопок.
        let buttons = [rateButton, popularButton, instructionButton]
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
            cell.keyLabel.text = "Название:"
            cell.valueLabel.text = train!.name
        case 1:
            cell.keyLabel.text = "Тип:"
            cell.valueLabel.text = train!.type
        case 2:
            cell.keyLabel.text = "Описание:"
            cell.valueLabel.text = train!.description
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Сигвэй в InstructionPageViewController. От кнопки "Информация" идет сигвэй Show.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "instructionSegue" {
            guard let dvc = segue.destination as? InstructionPageViewController else { return }
            dvc.instruction = train
        }
        
        if segue.identifier == "ratingSegue" {
            guard let dvc = segue.destination as? RateViewController else { return }
            dvc.id = id
        }
    }

    @IBAction func popularButtonPressed(_ sender: UIButton) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            let exercise = Popular(context: context)
            exercise.name = train?.name
            exercise.image = train?.image
            exercise.desc = train?.description
            exercise.type = train?.type
            exercise.id = id!
            var counter = 0
            counterPopularButtonPressed += 1
            do {
                if counterPopularButtonPressed == 1 {
                    for i in 0..<popularExercises.count {
                        if exercise.name == popularExercises[i].name {
                            counter += 1
                        }
                    }
                    if counter == 0 {
                        try context.save()
                        
                        let ac = UIAlertController(title: "Сохранение удалось!", message: "Теперь Вы можете посмотреть данное упражнение в разделе Избранное", preferredStyle: UIAlertControllerStyle.alert)
                        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        ac.addAction(ok)
                        present(ac, animated: true, completion: nil)
                        
                        print("Сохранение удалось!")
                    } else {
                        context.delete(exercise)
                        try context.save()
                        
                        let ac = UIAlertController(title: "Сохранение не удалось!", message: "Данное упражнение уже есть в разделе Избранное", preferredStyle: UIAlertControllerStyle.alert)
                        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        ac.addAction(ok)
                        present(ac, animated: true, completion: nil)
                        
                        print("Сохранение не удалось!")
                    }
                } else {
                    context.delete(exercise)
                    try context.save()
                    
                    let ac = UIAlertController(title: "Сохранение не удалось!", message: "Данное упражнение уже есть в разделе Избранное", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    ac.addAction(ok)
                    present(ac, animated: true, completion: nil)
                    
                    print("Сохранение не удалось!")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
