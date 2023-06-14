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
    @IBOutlet weak var addPhotoButton: UIButton!
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
            addPhotoButton.setTitle("Edit Photo", for: .normal)
        } }
    
    
    @IBAction func addTaskButton(_ sender: Any) {
        if addNewTask {
            // alert
            let alert = MyAlertViewController(title: "", message: "you added a new task", imageName: nil, preferredStyle: .actionSheet)
            self.present(alert, animated: true, completion: nil)
            // pass notification
            let task = Task(taskName: titleTextField.text! , taskImage : taskImageView.image, taskDetails: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "newTask"), object: nil, userInfo: ["newTask": task])
            self.dismiss(animated: true, completion: nil)
            self.tabBarController?.selectedIndex = 0
            
            
            } else {
                // when button is clicked to edit task
                // alert
                let alert = MyAlertViewController(title: "", message: "task has been edited", imageName: nil, preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) in
//                self.navigationController?.popViewController(animated: true)
//            }))
            self.present(alert, animated: true, completion: nil)
                // pass notification
                let editedTask = Task(taskName: titleTextField.text!, taskImage: taskImageView.image, taskDetails: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "editedTask"), object: nil, userInfo: ["editedTask":editedTask, "editedTaskIndex" : editedTaskIndex])
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
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
