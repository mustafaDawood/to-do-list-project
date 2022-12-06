//
//  TaskDetailsVC.swift
//  to-do app
//
//  Created by Mustafa Dawood on 11/17/22.
//

import UIKit

class TaskDetailsVC: UIViewController {

    var task : Task!
    var currentTaskIndex : Int!
    @IBOutlet weak var taskDetailImageView: UIImageView!
    @IBOutlet weak var taskDetailsLabel: UILabel!
    @IBOutlet weak var taskTitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // ui update
        taskDetailImageView.image = task.taskImage
        taskUi()
        // recived notifications
        NotificationCenter.default.addObserver(self, selector: #selector(taskUpdate), name: NSNotification.Name.init(rawValue: "editedTask"), object: nil)
    }
    // notification selector
    @objc func taskUpdate (updateNotification : Notification){
        if let updatedTask = updateNotification.userInfo?["editedTask"] as? Task {
            self.task = updatedTask
            taskUi()
        } }
    
    func taskUi () {
        taskTitleLabel.text = task.taskName
        taskDetailsLabel.text = task.taskDetails
        taskDetailImageView.image = task.taskImage
    }
    
    @IBAction func editButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddTaskVC") as? AddTaskVC
        {
            vc.addNewTask = false
            vc.editedTask = task
            vc.editedTaskIndex = currentTaskIndex
            navigationController?.pushViewController(vc, animated: true)
        } }
    @IBAction func deleteButton(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Alert", message: "Are you sure to delete task", preferredStyle: .alert)
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            NotificationCenter.default.post(name: NSNotification.Name.init("deleteTask"), object: nil, userInfo: ["deletedTaskIndex":self.currentTaskIndex])
            let alert = UIAlertController(title: "", message: "task has been deleted", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }))
        deleteAlert.addAction(UIAlertAction(title: "NO", style: .default, handler: nil))
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    
}
