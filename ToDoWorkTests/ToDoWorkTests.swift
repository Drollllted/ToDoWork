//
//  ToDoWorkTests.swift
//  ToDoWorkTests
//
//  Created by Drolllted on 03.06.2025.
//

import XCTest

@testable import ToDoWork
import CoreData

final class ToDoWorkTests: XCTestCase {

    var coreDataManager: CoreDataManager!
       
       override func setUp() {
           super.setUp()
           coreDataManager = CoreDataManager.shared
           // Используем in-memory store для тестов
           let persistentStoreDescription = NSPersistentStoreDescription()
           persistentStoreDescription.type = NSInMemoryStoreType
           coreDataManager.persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
           
           coreDataManager.persistentContainer.loadPersistentStores(completionHandler: ) { _, error in
               XCTAssertNil(error)
           }
       }
       
       override func tearDown() {
           coreDataManager = nil
           super.tearDown()
       }
       
       func testAddAndFetchNote() {
           let title = "Test Title"
           let text = "Test Text"
           let date = Date()
           
           // Создаем новую заметку
           let note = Note(context: coreDataManager.persistentContainer.viewContext)
           note.id = UUID()
           note.titleNotes = title
           note.textNotes = text
           note.dateNotes = date
           note.completed = false
           
           do {
               try coreDataManager.addOrUpdateNote(note: note)
               try coreDataManager.getNotes()
               
               // Проверяем, что заметка добавилась
               XCTAssertEqual(coreDataManager.notes.count, 1)
               XCTAssertEqual(coreDataManager.notes.first?.titleNotes, title)
               XCTAssertEqual(coreDataManager.notes.first?.textNotes, text)
               XCTAssertEqual(coreDataManager.notes.first?.dateNotes, date)
               XCTAssertFalse(coreDataManager.notes.first?.completed ?? true)
           } catch {
               XCTFail("Error adding or fetching note: \(error)")
           }
       }
       
       func testUpdateNote() {
           // Сначала создаем заметку
           let note = Note(context: coreDataManager.persistentContainer.viewContext)
           note.id = UUID()
           note.titleNotes = "Original Title"
           note.textNotes = "Original Text"
           note.dateNotes = Date()
           note.completed = false
           
           do {
               try coreDataManager.addOrUpdateNote(note: note)
               
               // Обновляем заметку
               note.titleNotes = "Updated Title"
               note.completed = true
               try coreDataManager.addOrUpdateNote(note: note)
               try coreDataManager.getNotes()
               
               // Проверяем обновление
               XCTAssertEqual(coreDataManager.notes.first?.titleNotes, "Updated Title")
               XCTAssertTrue(coreDataManager.notes.first?.completed ?? false)
           } catch {
               XCTFail("Error updating note: \(error)")
           }
       }
       
       func testDeleteNote() {
           let note = Note(context: coreDataManager.persistentContainer.viewContext)
           note.id = UUID()
           note.titleNotes = "Note to delete"
           
           do {
               try coreDataManager.addOrUpdateNote(note: note)
               try coreDataManager.getNotes()
               XCTAssertEqual(coreDataManager.notes.count, 1)
               
               // Удаляем заметку
               guard let id = note.id else {
                   XCTFail("Note ID is nil")
                   return
               }
               
               try coreDataManager.deleteNotes(id: id)
               try coreDataManager.getNotes()
               
               // Проверяем, что заметка удалилась
               XCTAssertEqual(coreDataManager.notes.count, 0)
           } catch {
               XCTFail("Error in delete test: \(error)")
           }
       }
       
       func testPerformanceExample() {
           measure {
               for i in 0..<100 {
                   let note = Note(context: coreDataManager.persistentContainer.viewContext)
                   note.id = UUID()
                   note.titleNotes = "Note \(i)"
                   try? coreDataManager.addOrUpdateNote(note: note)
               }
               try? coreDataManager.getNotes()
               XCTAssertEqual(coreDataManager.notes.count, 100)
           }
       }
}
