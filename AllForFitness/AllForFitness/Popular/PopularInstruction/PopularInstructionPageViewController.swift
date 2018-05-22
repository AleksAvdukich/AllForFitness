//
//  PopularInstructionPageViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 08.05.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class PopularInstructionPageViewController: UIPageViewController {
    
    var popularInstruction: Popular?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstVC = displayViewController(atIndex: 0) { // Извлекается firstVC, используя метод displayViewController.
            setViewControllers([firstVC], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Метод, который отображает PopularInstructionViewController. Далее код переходит в файл PopularInstructionViewController.swift
    func displayViewController(atIndex index: Int) -> PopularInstructionViewController? {
        guard index >= 0 else { return nil }
        guard index < Int((popularInstruction?.position)!) else { return nil }
        // Переход на PopularInstructionViewController, используя Storyboard ID, и передача туда данных.
        guard let instructionVC = storyboard?.instantiateViewController(withIdentifier: "popularInstructionViewController") as? PopularInstructionViewController else { return nil }
        switch index {
        case 0:
            instructionVC.header = "Положение 1"
            instructionVC.label = (popularInstruction?.positionOne)!
            instructionVC.imageFile = (popularInstruction?.imageOne)!
            instructionVC.position = Int((popularInstruction?.position)!)
            instructionVC.index = index
        case 1:
            instructionVC.header = "Положение 2"
            instructionVC.label = (popularInstruction?.positionTwo)!
            instructionVC.imageFile = (popularInstruction?.imageTwo)!
            instructionVC.position = Int((popularInstruction?.position)!)
            instructionVC.index = index
        case 2:
            instructionVC.header = "Положение 3"
            instructionVC.label = (popularInstruction?.positionThree)!
            instructionVC.imageFile = (popularInstruction?.imageThree)!
            instructionVC.position = Int((popularInstruction?.position)!)
            instructionVC.index = index
        case 3:
            instructionVC.header = "Положение 4"
            instructionVC.label = (popularInstruction?.positionFour)!
            instructionVC.imageFile = (popularInstruction?.imageFour)!
            instructionVC.position = Int((popularInstruction?.position)!)
            instructionVC.index = index
        case 4:
            instructionVC.header = "Положение 5"
            instructionVC.label = (popularInstruction?.positionFive)!
            instructionVC.imageFile = (popularInstruction?.imageFive)!
            instructionVC.position = Int((popularInstruction?.position)!)
            instructionVC.index = index
        default:
            break
        }
        return instructionVC
    }
    
    func nextVC(atIndex index: Int) {
        if let instructionVC = displayViewController(atIndex: index + 1) { // Попытка получить следующий PopularInstructionViewController из метода displayViewController. Если получается, то вызывается метод setViewControllers, куда помещается тот viewController, который необходимо отобразить далее.
            setViewControllers([instructionVC], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    }
}

// Выполнение методов протокола UIPageViewControllerDataSource. Методы, означающие переход на PopularInstructionViewController и обратно.
extension PopularInstructionPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PopularInstructionViewController).index
        index -= 1
        return displayViewController(atIndex: Int(index))
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PopularInstructionViewController).index
        index += 1
        return displayViewController(atIndex: Int(index))
    }
}
