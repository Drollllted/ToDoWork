//
//  Note+CoreDataProperties.swift
//  ToDoWork
//
//  Created by Drolllted on 30.05.2025.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var dateNotes: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var textNotes: String?
    @NSManaged public var titleNotes: String?
    @NSManaged public var completed: Bool

}

extension Note : Identifiable {

}
