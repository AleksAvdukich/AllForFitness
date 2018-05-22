//
//  SaveNoteTableViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 22.04.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class SaveNoteTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var saveImageView: UIImageView!
    @IBOutlet weak var saveTextView: UITextView!
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if saveTextView.textColor == UIColor.lightGray && saveTextView.text == "" {
            let ac = UIAlertController(title: "Не заполнено поле ввода!", message: "Пожалуйста, заполните всю информацию", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            ac.addAction(ok)
            present(ac, animated: true, completion: nil)
        } else {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let newNote = Note(context: context)
                newNote.note = saveTextView.text
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
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if saveTextView.textColor == UIColor.lightGray {
                saveTextView.selectedTextRange = saveTextView.textRange(from: saveTextView.beginningOfDocument, to: saveTextView.beginningOfDocument)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
        
        saveTextView.text = "Заметка"
        saveTextView.textColor = UIColor.lightGray
        saveTextView.delegate = self
        saveTextView.becomeFirstResponder()
        saveTextView.selectedTextRange = saveTextView.textRange(from: saveTextView.beginningOfDocument, to: saveTextView.beginningOfDocument)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Объединение текста в saveTextView и замещающего его текста для создания обновленной текстовой строки.
        let currentText: String = saveTextView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        // Если обновленное текстовое поле пустое, то добавляем placeholder ("Заметка" серого цвета) и устанавливаем курсор в начало текстового поля.
        if updatedText.isEmpty {
            saveTextView.text = "Заметка"
            saveTextView.textColor = UIColor.lightGray
            saveTextView.selectedTextRange = saveTextView.textRange(from: saveTextView.beginningOfDocument, to: saveTextView.beginningOfDocument)
        }
            // Иначе если placeholder saveTextView показывается и длина замененной строки больше 0 (пользователь начинает печатать в saveTextView), то устанавливаем: цвет шрифта черный и замещающий текст на текст placeholder'a в saveTextView.
        else if saveTextView.textColor == UIColor.lightGray && !text.isEmpty {
            saveTextView.textColor = UIColor.black
            saveTextView.text = text
        }
        else {
            return true
        }
        // Возвращение false, т.к. обновление (заамещение) уже было сделано.
        return false
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

