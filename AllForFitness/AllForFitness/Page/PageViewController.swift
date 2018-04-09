//
//  PageViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 09.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    var headersArray = ["Тренируйтесь", "Записывайте и оценивайте"]
    var subheadersArray = ["Найдите подходящий для Вас комплекс упражнений", "Делайте заметки по каждому упражнению, а также оценивайте каждое из них"]
    var imagesArray = ["sport", "rating"]
    
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
    
    // Метод, который отображает ContentViewController. Далее код переходит в файл ContentViewController.swift, где описан класс контроллера contentViewController.
    func displayViewController(atIndex index: Int) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < headersArray.count else { return nil }
        // Переход на ContentViewController, используя Storyboard ID, и передача туда данных.
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController else { return nil }
        contentVC.imageFile = imagesArray[index]
        contentVC.header = headersArray[index]
        contentVC.subheader = subheadersArray[index]
        contentVC.index = index
        return contentVC
    }
    
    func nextVC(atIndex index: Int) {
        if let contencVC = displayViewController(atIndex: index + 1) { // Попытка получить следующий contentViewController из метода displayViewController. Если получается, то вызывается метод setViewControllers, куда помещается тот viewController, который необходимо отобразить далее.
            setViewControllers([contencVC], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    }
}

// Выполнение методов протокола UIPageViewControllerDataSource. Методы, означающие переход на ContentViewController и обратно.
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index += 1
        return displayViewController(atIndex: index)
    }
}
