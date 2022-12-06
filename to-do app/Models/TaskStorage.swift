//
//  TaskStorage.swift
//  to-do app
//
//  Created by Mac on 12/6/22.
//

import UIKit
import CoreData

class TaskStorage {
    
   static func storeTask (task : Task){
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
    
   static func updateTask (task : Task ,index : Int) {
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
    
   static func deleteTask (index : Int) {
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
    
   static func getTask () -> [Task]{
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
    
}
