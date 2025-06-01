//
//  CoreDataManager.swift
//  ToDoWork
//
//  Created by Drolllted on 30.05.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var notes: [Note] = []
    
    private init(){}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoWork")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
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
    
    //MARK: - Fetch, Add, Update, Delete notes
        
    func addOrUpdateNote(note: Note) throws {
        let context = persistentContainer.viewContext
        try context.performAndWait {
            if note.objectID.isTemporaryID {
                do {
                    try context.save()
                } catch {
                context.rollback()
                throw error
                }
            } else {
                    if let existingNote = try? getNoteById(id: note.id!) {
                        existingNote.textNotes = note.textNotes
                        existingNote.titleNotes = note.titleNotes
                        do {
                            try context.save()
                        } catch {
                            context.rollback()
                            throw error
                        }
                    }
                }
            }
        }
        
        func getNotes() throws {
            let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
            let context = persistentContainer.viewContext
            
            context.performAndWait {
                do {
                    notes = try context.fetch(fetchRequest)
                } catch {
                    fatalError("Failed to fetch notes: \(error)")
                }
            }
        }
        
        func deleteNotes(id: UUID) throws {
            let context = persistentContainer.viewContext
            
            try context.performAndWait {
                guard let note = try getNoteById(id: id) else {return}
                context.delete(note)
                do{
                    try context.save()
                    try getNotes()
                } catch {
                    context.rollback()
                    throw error
                }
            }
        }
        
        func getNoteById(id: UUID) throws -> Note? {
            let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            let context = persistentContainer.viewContext
            var note: Note? = nil
            context.performAndWait {
                do {
                    note = try context.fetch(fetchRequest).first
                } catch {
                    fatalError("Failed to fetch note by id: \(error)")
                }
            }
            return note
        }
        
        
    }
}
