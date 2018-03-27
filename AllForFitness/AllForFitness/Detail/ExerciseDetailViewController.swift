//
//  ExerciseDetailViewController.swift
//  AllForFitness
//
//  Created by Aleksandr Avdukich on 25.03.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    var train: Training?
    
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
    
}
