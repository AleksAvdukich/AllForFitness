//
//  EditNoteTableViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 22.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class EditNoteTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var note: Note?
    
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var editTextField: UITextField!
    
    @IBAction func actionButtonPressed(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet) // title - заголовок, message - текст высплывающего окна, preferredStyle - cтиль высплывающего окна (Alert Controller). Причем .actionSheet - лист возможных действий (отображается внизу экрана), а .alert - warning.
        // Первый action - Отмена.
        let cancel = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel, handler: nil)
        // Второй action - Изменить.
        let edit = UIAlertAction(title: "Изменить", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
            if self.editTextField.text == "" {
                let ac1 = UIAlertController(title: "Не заполнено поле ввода!", message: "Пожалуйста, заполните всю информацию", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                ac1.addAction(ok)
                self.present(ac1, animated: true, completion: nil)
            } else {
                if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                    let editNote = Note(context: context)
                    editNote.note = self.editTextField.text
<<<<<<< HEAD
                    editNote.date = Date()
=======
>>>>>>> 980638860080985c60d3ae2525355f0ee87d1d99
                    if let image = self.editImageView.image {
                        editNote.image = UIImagePNGRepresentation(image)
                    }
                    do {
                        context.delete(self.note!)
                        try context.save()
                        print("Изменение удалось!")
                    } catch let error as NSError {
                        print("Не удалось изменить данные: \(error), \(error.userInfo)")
                    }
                }
                self.performSegue(withIdentifier: "unwindSegueFromEditNote", sender: self)
            }
        })
        // Третий action - Поделиться
        let share = UIAlertAction(title: "Поделиться", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
            let defaultText = self.note!.note!
            if let image = UIImage(data: self.note!.image! as Data) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        })
        // Четвертый action - Удалить
        let delete = UIAlertAction(title: "Удалить", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
            let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
            context?.delete(self.note!) // Удаление экземпляра класса Note из контекста.
            // Пересохранение контекста.
            do {
                try context?.save()
            } catch let error as NSError {
                print("Error: \(error), description \(error.userInfo)")
            }
            self.performSegue(withIdentifier: "unwindSegueFromEditNote", sender: self)
        })
        ac.addAction(cancel) // Добавляем кнопку (действие) во всплывающее окно.
        ac.addAction(edit)
        ac.addAction(share)
        ac.addAction(delete)
        present(ac, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        editImageView.image = UIImage(data: note!.image! as Data)
        editTextField.text = note?.note
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        editImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        editImageView.contentMode = .scaleAspectFill
        editImageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: "Добавить фотографию с помощью", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let cameraAction = UIAlertAction(title: "Камера", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
                self.chooseImagePickerAction(source: UIImagePickerControllerSourceType.camera)
            })
            let photoLibAction = UIAlertAction(title: "Библиотека", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
                self.chooseImagePickerAction(source: UIImagePickerControllerSourceType.photoLibrary)
            })
            let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(cameraAction)
            alertController.addAction(photoLibAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func chooseImagePickerAction(source: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}
