//
//  PopularDetailViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 24.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

class PopularDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var instructionButton: UIButton!
    
    var popularTrain: Popular?
    var ratingArray: [Rating] = []
    
    override func viewWillAppear(_ animated: Bool) {
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
                if popularTrain?.id == ratingArray[i].id {
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
        tableView.rowHeight = UITableViewAutomaticDimension
        
        title = popularTrain!.name
        
        imageView.image = UIImage(named: popularTrain!.image!)
        
        // Рамка для кнопок.
        let buttons = [rateButton, instructionButton]
        for button in buttons {
            guard let button = button else { break }
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blue.cgColor
        }
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PopularDetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.keyLabel.text = "Название"
            cell.valueLabel.text = popularTrain!.name
        case 1:
            cell.keyLabel.text = "Тип"
            cell.valueLabel.text = popularTrain!.type
        case 2:
            cell.keyLabel.text = "Описание"
            cell.valueLabel.text = popularTrain!.desc
        case 3:
            cell.keyLabel.text = "Количество подходов в сутки:"
            cell.valueLabel.text = popularTrain?.podhody
        case 4:
            cell.keyLabel.text = "Среднее количество повторений за один подход:"
            cell.valueLabel.text = popularTrain?.povtoreniya
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "popularInstructionSegue" {
            guard let dvc = segue.destination as? PopularInstructionPageViewController else { return }
            dvc.popularInstruction = popularTrain
        }
    }
}
