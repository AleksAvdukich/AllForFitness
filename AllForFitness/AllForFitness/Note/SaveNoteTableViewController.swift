//
//  SaveNoteTableViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 22.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class SaveNoteTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var saveImageView: UIImageView!
    @IBOutlet weak var saveTextField: UITextField!
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if saveTextField.text == "" {
            let ac = UIAlertController(title: "Не заполнено поле ввода!", message: "Пожалуйста, заполните всю информацию", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            ac.addAction(ok)
            present(ac, animated: true, completion: nil)
        } else {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let newNote = Note(context: context)
                newNote.note = saveTextField.text
                newNote.date = Date()
                if let image = saveImageView.image {
                    newNote.image = UIImagePNGRepresentation(image)
                }
                do {
                    try context.save()
                    print("Сохранение удалось!")
                } catch let error as NSError {
                    print("Не удалось сохранить данные: \(error), \(error.userInfo)")
                }
            }
            performSegue(withIdentifier: "unwindSegueFromSaveNote", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        saveImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        saveImageView.contentMode = .scaleAspectFill
        saveImageView.clipsToBounds = true
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
