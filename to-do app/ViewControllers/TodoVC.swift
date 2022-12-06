//
//  todoVC.swift
//  to-do app
//
//  Created by Mustafa Dawood on 11/17/22.
//

import UIKit
import CoreData

class TodoVC: UIViewController {

    @IBOutlet weak var todoTableView: UITableView!
    var taskArray :[Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskArray = TaskStorage.getTask()
        todoTableView.dataSource = self
        todoTableView.delegate = self
        // add task notification
        NotificationCenter.default.addObserver(self, selector: #selector(newTaskAdded), name: NSNotification.Name.init(rawValue: "newTask"), object: nil)
        // edit task notification
        NotificationCenter.default.addObserver(self, selector: #selector(editedTaskAdded), name: NSNotification.Name.init(rawValue: "editedTask"), object: nil)
        // delet task notification
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTask), name: NSNotification.Name.init(rawValue: "deleteTask"), object: nil)
    }
    // add task selectors
    @objc func newTaskAdded (newTaskNotification : Notification) {
        if let newTask = newTaskNotification.userInfo?["newTask"] as? Task {
            taskArray.append(newTask)
            todoTableView.reloadData()
            TaskStorage.storeTask(task: newTask)
        } }
    // edit task selector
    @objc func editedTaskAdded (editedTaskNotification:Notification) {
        if let editedTask = editedTaskNotification.userInfo?["editedTask"] as? Task
        {
            if let index = editedTaskNotification.userInfo?["editedTaskIndex"] as? Int
            {
                taskArray[index] = editedTask
                todoTableView.reloadData()
                TaskStorage.updateTask(task: editedTask, index: index)
            } } }
    // delete task selector
    @objc func deleteTask (deletTaskNotification : Notification){
        if let Index = deletTaskNotification.userInfo?["deletedTaskIndex"] as? Int {
            taskArray.remove(at: Index)
            todoTableView.reloadData()
            TaskStorage.deleteTask(index: Index)
        }
    }
}

// tableview functions
extension TodoVC : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        let currentCell = taskArray[indexPath.row]
        cell.taskLabel.text = currentCell.taskName
        cell.taskImageView.image = currentCell.taskImage
        cell.taskImageView.layer.cornerRadius = cell.taskImageView.frame.width/2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskIndex = indexPath.row
        let VC = storyboard?.instantiateViewController(withIdentifier: "TaskDetailsVC") as? TaskDetailsVC
        let currentTask = taskArray[indexPath.row]
        if let vc = VC {
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController?.pushViewController(vc, animated: true)
            vc.task = currentTask
            vc.currentTaskIndex = taskIndex
        } } }
