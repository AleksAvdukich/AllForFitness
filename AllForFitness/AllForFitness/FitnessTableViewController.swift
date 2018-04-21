//
//  FitnessTableViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 25.03.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class FitnessTableViewController: UITableViewController {
    
    var searchController: UISearchController!
    var filteredResultArray: [Training] = [] // Массив упражнений, соответствующий критериям поиска.
    
    var trains: [Training] = [
        Training(name: "Берёзка", type: "Комлексное", image: "berezka.png", description: "Данное упражнение направлено на укрепление мышц пресса, спины, а также разработку шейного отдела."),
        Training(name: "Махи ногой", type: "Комлексное", image: "makhi.png", description: "Отличное упражнение, помогающее не только нагрузить пресс, который в момент выполнения будет в постоянном напряжении, а и немного проработать ягодичные мышцы."),
        Training(name: "Мостик", type: "Комлексное", image: "mostik.png", description: "Эффетивное упражнение, направленное на укрепление ягодичных мышц и задней поверхности бедра. Дополнительную нагрузку получают, при соблюдении техники выполнения, спина и пресс."),
        Training(name: "Ножницы", type: "Комлексное", image: "nozhnitsy.png", description: "Универсальное упражнение, помогающее проработать все мышцы брюшной полости, а также избавиться от лишних килограммов в этой проблемной области."),
        Training(name: "Повороты с упором на локоть", type: "Комлексное", image: "povoroty.png", description: "Упражнение, направленное на проработку мышц бокового пресса и помогающее развить координацию движений."),
        Training(name: "Приседания до параллели", type: "Базовое", image: "prisedaniya.png", description: "Базовое упражнение, являющееся одним из важнейших для тренировки ягодиц."),
        Training(name: "Прогибы назад", type: "Базовое", image: "progiby.png", description: "Упражнение, помогающее размяться и растянуть спину, подготовив ее к дальнейшим нагрузкам."),
        Training(name: "Прыжки в сторону", type: "Комлексное", image: "pryzhki.png", description: "Довольно специфическое, но оттого не менее эффективное упражнение, помогающее проработать мышцы бедер, ягодицы и квадрицепсы."),
        Training(name: "Двойные скручивания", type: "Комлексное", image: "skruchivaniya.png", description: "Сложное упражнение, направленное на проработку верхнего и нижнего отделов пресса. Выполнять его можно только предварительно размявшись."),
        Training(name: "Выпады", type: "Базовое", image: "vypady.png", description: "Базовое упражнение для тренировки ягодиц.")]
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.hidesBarsOnSwipe = true // Прячем Navigation Bar при проматывании вниз.
    }
    
    func filterContentFor(searchText text: String) {
        filteredResultArray = trains.filter { (trains) -> Bool in
            return (trains.name.lowercased().contains(text.lowercased())) // В filteredResultArray помещаются только те элементы, имя которых содержит тот же самый текст, что и в поисковом запросе. lowercased() - метод, который принудительно превращает все буквы имени ресторана в строчные, так же, как и весь запрос.
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.blue
            ]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false // Убираем затемнение tableView.
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.9030755635, green: 0.9030755635, blue: 0.9030755635, alpha: 1) // Цвет панели SearchBar.
        searchController.searchBar.tintColor = .blue // Цвет шрифта.
        definesPresentationContext = true // Поисковая строка (searchController) не переходит на DetailViewController.
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil) // Убрать текст "Все упражнения" из кнопки назад в Navigation Bar.
    }
    
    // Метод, позволяющий при загрузке главного экрана (таблицы), вызвать и отобразить PageViewController.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userDefaults = UserDefaults.standard
        let wasWatched = userDefaults.bool(forKey: "wasWatched")
        guard !wasWatched else { return } // Если обе страницы просмотрены, то ключ true трансформируется в false, и мы выходим из цикла через else { return }. Отображается таблица из метода viewDidLoad.
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            present(pageViewController, animated: true, completion: nil) // Если pageViewController с данным идентификатором найден, он отображается. И далее исполнение переходит в файл РageViewController.swift, где как раз записан класс этого контроллера.
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Возвращаем точное количество ячеек, равное кол-ву элементов либо в массив trains, либо в массиве filteredResultArray.
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        }
        return trains.count
    }
    
    func trainsToDisplayAt(indexPath: IndexPath) -> Training {
        let exercise: Training // Создаем константу в которую потом поместим значения либо с одного массива либо с другого
        if searchController.isActive && searchController.searchBar.text != "" {
            exercise = filteredResultArray[indexPath.row]
        } else {
            exercise = trains[indexPath.row]
        }
        return exercise
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FitnessTableViewCell
        let exercise = trainsToDisplayAt(indexPath: indexPath)
        
        cell.fitnessImageView.image = UIImage(named: exercise.image)
        cell.fitnessImageView.layer.cornerRadius = 32.5
        cell.fitnessImageView.clipsToBounds = true
        cell.nameLabel.text = exercise.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Исчезание выделения выбранной ячейки.
    }
    
    // Custom Row Actions для выбранной ячейки (смахивание влево - поделиться и удалить).
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Поделиться") { (action: UITableViewRowAction, indexPath) -> Void in
            let defaultText = "Я сейчас выполняю" + self.trains[indexPath.row].name
            if let image = UIImage(named: self.trains[indexPath.row].image) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        //        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Удалить") { (action: UITableViewRowAction, indexPath) -> Void in
        //            self.trains.remove(at: indexPath.row)
        //            tableView.deleteRows(at: [indexPath], with: .fade)
        //        }
        share.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        //        delete.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return [share]
    }
    
    // Подготовка к переходу на ViewController. При нажатии на ячейку, вызывается данный метод.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let dvc = segue.destination as? ExerciseDetailViewController else { return } // Конечный контролер, который кастится к EateryDetailViewController, чтобы получить его св-ва.
                dvc.train = trainsToDisplayAt(indexPath: indexPath)
            }
        }
    }
}

// Подписываемся под протокол UISearchResultsUpdating для поисковой панели в tableView.
extension FitnessTableViewController: UISearchResultsUpdating {
    // Этот метод вызывается тогда, когда что-то изменяется в поисковом запросе. Тогда сразу обновляется tableView.
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData() // Перезагружаем таблицу.
    }
}

extension FitnessTableViewController: UISearchBarDelegate {
    // Метод, означающий то, когда мы щелкаем на поисковую строку.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false // navigationController прячется. То есть остается только searchController.
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true // Когда мы ушли с этого окна, мы обратно активируем navigationController
    }
}




