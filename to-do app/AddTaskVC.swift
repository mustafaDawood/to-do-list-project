//
//  AddTaskVC.swift
//  to-do app
//
//  Created by Mustafa Dawood on 11/18/22.
//

import UIKit

class AddTaskVC: UIViewController  {

    @IBOutlet weak var taskTitleLAbel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var taskImageView: UIImageView!
    var editedTask : Task?
    var addNewTask = true
    var editedTaskIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !addNewTask {
            mainButton.setTitle("Edit", for: .normal)
            navigationItem.title = "Edit Task"
            titleTextField.text = editedTask?.taskName
            detailsTextView.text = editedTask?.taskDetails
            taskImageView.image = editedTask?.taskImage
        } }
    
    
    @IBAction func addTaskButton(_ sender: Any) {
        if addNewTask {
            // alert
            let alert = UIAlertController(title: "message", message: "you added a new task", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) in
                self.tabBarController?.selectedIndex = 0
                self.titleTextField.text = ""
                self.detailsTextView.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
            // pass notification
            let task = Task(taskName: titleTextField.text! , taskImage : taskImageView.image, taskDetails: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "newTask"), object: nil, userInfo: ["newTask": task])
            
            } else {
                // when button is clicked to edit task
                // alert
            let alert = UIAlertController(title: "message", message: "task has been edited", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
                // pass notification
                let editedTask = Task(taskName: titleTextField.text!, taskImage: taskImageView.image, taskDetails: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "editedTask"), object: nil, userInfo: ["editedTask":editedTask, "editedTaskIndex" : editedTaskIndex])
            }
    }
    
    @IBAction func changePhotoButton(_ sender: Any) {
        let imagePicker = UIImagePickerController ()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
}

extension AddTaskVC : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[ UIImagePickerController.InfoKey.editedImage] as? UIImage
        dismiss(animated: true, completion: nil)
        taskImageView.image = image
    }
}
