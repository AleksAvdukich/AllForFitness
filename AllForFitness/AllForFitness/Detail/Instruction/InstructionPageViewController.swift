//
//  InstructionPageViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 29.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class InstructionPageViewController: UIPageViewController {

    var instruction: Training?
    
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
    
    // Метод, который отображает InstructionViewController. Далее код переходит в файл InstructionViewController.swift.
    func displayViewController(atIndex index: Int) -> InstructionViewController? {
        guard index >= 0 else { return nil }
        guard index < (instruction?.position)! else { return nil }
        // Переход на InstructionViewController, используя Storyboard ID, и передача туда данных.
        guard let instructionVC = storyboard?.instantiateViewController(withIdentifier: "instructionViewController") as? InstructionViewController else { return nil }
        switch index {
        case 0:
            instructionVC.header = "Положение 1"
            instructionVC.label = (instruction?.positionOne)!
            instructionVC.imageFile = (instruction?.imageOne)!
            instructionVC.position = (instruction?.position)!
            instructionVC.index = index
        case 1:
            instructionVC.header = "Положение 2"
            instructionVC.label = (instruction?.positionTwo)!
            instructionVC.imageFile = (instruction?.imageTwo)!
            instructionVC.position = (instruction?.position)!
            instructionVC.index = index
        case 2:
            instructionVC.header = "Положение 3"
            instructionVC.label = (instruction?.positionThree)!
            instructionVC.imageFile = (instruction?.imageThree)!
            instructionVC.position = (instruction?.position)!
            instructionVC.index = index
        case 3:
            instructionVC.header = "Положение 4"
            instructionVC.label = (instruction?.positionFour)!
            instructionVC.imageFile = (instruction?.imageFour)!
            instructionVC.position = (instruction?.position)!
            instructionVC.index = index
        case 4:
            instructionVC.header = "Положение 5"
            instructionVC.label = (instruction?.positionFive)!
            instructionVC.imageFile = (instruction?.imageFive)!
            instructionVC.position = (instruction?.position)!
            instructionVC.index = index
        default:
            break
        }
        return instructionVC
    }
    
    func nextVC(atIndex index: Int) {
        if let instructionVC = displayViewController(atIndex: index + 1) { // Попытка получить следующий InstructionViewController из метода displayViewController. Если получается, то вызывается метод setViewControllers, куда помещается тот viewController, который необходимо отобразить далее.
            setViewControllers([instructionVC], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    }
}

// Выполнение методов протокола UIPageViewControllerDataSource. Методы, означающие переход на InstructionViewController и обратно.
extension InstructionPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! InstructionViewController).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! InstructionViewController).index
        index += 1
        return displayViewController(atIndex: index)
    }
}
