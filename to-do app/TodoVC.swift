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
        self.taskArray = getTask()
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
            storeTask(task: newTask)
        } }
    // edit task selector
    @objc func editedTaskAdded (editedTaskNotification:Notification) {
        if let editedTask = editedTaskNotification.userInfo?["editedTask"] as? Task
        {
            if let index = editedTaskNotification.userInfo?["editedTaskIndex"] as? Int
            {
                taskArray[index] = editedTask
                todoTableView.reloadData()
                updateTask(task: editedTask, index: index)
            } } }
    // delete task selector
    @objc func deleteTask (deletTaskNotification : Notification){
        if let Index = deletTaskNotification.userInfo?["deletedTaskIndex"] as? Int {
            taskArray.remove(at: Index)
            todoTableView.reloadData()
            deletTask(index: Index)
        }
    }
    // coreData functions
    func storeTask (task : Task){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        guard let taskEntity = NSEntityDescription.entity(forEntityName: "Tasks", in: context)  else {return}
        let taskObjc = NSManagedObject.init(entity: taskEntity, insertInto: context)
        taskObjc.setValue(task.taskName, forKey: "taskTitle")
        taskObjc.setValue(task.taskDetails, forKey: "taskDetail")
        if let image = task.taskImage {
            let imageData = image.pngData()
            taskObjc.setValue(imageData, forKey: "image")
        }
        do {
            try context.save()
        } catch  {
            print("error")
        }
    }
    
    func getTask () -> [Task]{
        var tasks : [Task] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for managedTask in result {
                let title = managedTask.value(forKey: "taskTitle") as? String
                let details = managedTask.value(forKey: "taskDetail") as? String
                var imageData : UIImage? = nil
                if let image = managedTask.value(forKey: "image") as? Data {
                    imageData = UIImage(data: image)
                }
                let task = Task(taskName: title ?? "", taskImage: imageData, taskDetails: details ?? "")
                tasks.append(task)
            }
        } catch{
            print("error")
        }
        
       return tasks
    }
    func updateTask (task : Task ,index : Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        do {
             let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            result[index].setValue(task.taskName, forKey: "taskTitle")
            result[index].setValue(task.taskDetails, forKey: "taskDetail")
            if let image = task.taskImage {
                let imageData = image.pngData()
                result[index].setValue(imageData, forKey: "image")
            }
            
            try context.save()
        } catch  {
            print("error")
        }
    }
    
    func deletTask (index : Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let deletedTask = result[index]
            context.delete(deletedTask)
            try context.save()
        } catch  {
            print("error")
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
