import Foundation
import CoreData

final class CoreDataServiceNew {
    
    static var mainContext: NSManagedObjectContext {
        let mainContext = persistentContainer.viewContext
        mainContext.automaticallyMergesChangesFromParent = true
        return mainContext
    }
    
    static var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    // MARK: - Core Data stack

    static var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "PalitraProduct2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    static func saveMainContext() {
        assert(Thread.current == Thread.main, "Usage mainContext out of main thread")
        saveContext(context: mainContext)
    }
    
    static func saveBackgroundContext() {
        assert(Thread.current != Thread.main, "Usage background in main thread")
        saveContext(context: backgroundContext)
    }
    
    static func saveContext(context: NSManagedObjectContext) {
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
