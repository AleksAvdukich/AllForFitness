//
//  NoteTableViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 10.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController {

    var items: [Note] = []
    
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Добавьте заметку", message: "Добавьте новую заметку", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            let textField = ac.textFields?[0] // Добавление в константу задачи, записанной в текстовое поле AlertController.
            self.saveNote(note: (textField?.text)!) // Вызывается функция, которая присваивает свойство taskToDo = textField.text объекту (экземпляру) класса Note и сохраняет этот экземпляр в массив items.
            self.tableView.reloadData() // Обновление данных, таблицы.
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        ac.addTextField { (textField) in // Отображение textField в AlertController.
        }
        ac.addAction(ok) // Отображение кнопки OK в AlertController.
        ac.addAction(cancel) // Отображение кнопки Cancel в AlertController.
        present(ac, animated: true, completion: nil) // Отображение самого AlertController.
    }
    
    func saveNote(note: String) {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext // Обращение к контексту.
        let newNote = Note(context: context!) // Создание пустого экземпляра типа сущности (класса) Note в контексте.
        newNote.note = note
        // Сохранение контекста, чтобы сохранился объект.
        do {
            try context?.save()
            items.append(newNote)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Загрузка данных из CoreData до загрузкки TableView, т.е. до выполнения метода viewDidLoad.
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext // Обращение к контексту.
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest() // Запрос по Note сущности.
        do {
            items = try context!.fetch(fetchRequest) // Запрос fetchRequest обращается к контексту и просит вернуть сущность типа Note, т.е. все ее объекты. И все полученные объекты сохраняются в массив.
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoteTableViewCell
        cell.noteLabel.text = items[indexPath.row].note
        return cell
    }
    
    // Метод удаления задачи из tableView.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
        guard editingStyle == .delete else { return }
        context?.delete(items[indexPath.row]) // Удаление экземпляра класса Note из контекста.
        items.remove(at: indexPath.row) // Удаление задачи из массива задач.
        // Пересохранение контекста.
        do {
            try context?.save()
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade) // Удаление св-ва задачи из tableView.
        } catch let error as NSError {
            print("Error: \(error), description \(error.userInfo)")
        }
    }
}
