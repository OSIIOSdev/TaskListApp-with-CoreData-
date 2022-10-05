//
//  StorageManager.swift
//  CoreDataApp
//
//  Created by Илья on 05.10.2022.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataApp")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Public Methods
    
    func fetchData(compleation: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            compleation(.success(tasks))
        } catch let error {
            compleation(.failure(error))
        }
    }
    
    // Save data
    
    func save (_ taskName: String, compleation: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.title = taskName
        compleation(task)
        saveContext()
    }
    
    // Editing data
    
    func edit (_ task: Task, newName: String) {
        task.title = newName
        saveContext()
    }
    
    // Delete data
    
    func delete (_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
