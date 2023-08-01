//
//  TodoViewModel.swift
//  SwiftDataTodoFun
//
//  Created by Neal Archival on 7/27/23.
//

import Foundation
import SwiftData
import Combine

@MainActor
class TodoViewModel: ObservableObject {
    // The database connection
    private let modelContext: ModelContext
    
    // When using Xcode previews, prevent create, update, or delete operations on SampleData
    private let inPreviewMode = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    
    // TextFields bindings
    @Published var newTodoText: String = ""
    @Published var editTodoText: String = ""
    
    // Alert bindings
    @Published var showEditAlert: Bool = false
    @Published var showDeleteAlert: Bool = false
    
    // CRUD subjects
    let createTodo = PassthroughSubject<Void, Never>()
    let editTodo = PassthroughSubject<Todo, Never>()
    let deleteTodo = PassthroughSubject<Todo, Never>()
    let toggleTodoCompletionStatus = PassthroughSubject<Todo, Never>()
    
    // Confirm subjects
    let confirmEditAction = PassthroughSubject<Bool, Never>()
    let confirmDeleteAction = PassthroughSubject<Bool, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        sinkSubjects()
    }
    
    private func sinkSubjects() {
        createTodo
            .sink { [weak self] _ in
                guard let self = self else { return }
                let newTodo = Todo(title: self.newTodoText, isComplete: false)
                self.modelContext.insert(newTodo)
                self.newTodoText = ""
            }
            .store(in: &subscriptions)
        
        // Edit title
        editTodo
            .sink { [weak self] todo in
                guard let self = self else { return }
                self.showEditAlert = true
                print("Show edit alert: \(self.showEditAlert)")
                self.editTodoText = todo.title
            }
            .store(in: &subscriptions)
        
        // Wait for edit completion
        Publishers.Zip(editTodo, confirmEditAction)
            .sink { [weak self] todoItem, confirmEdit in
                guard let self = self else { return }
                if !confirmEdit { return }
                todoItem.title = self.editTodoText
                self.editTodoText = ""
                self.showEditAlert = false
            }
            .store(in: &subscriptions)
        
        toggleTodoCompletionStatus.sink { todo in
                todo.isComplete.toggle()
            }
            .store(in: &subscriptions)
        
        deleteTodo
            .sink { [weak self] _ in
                self?.showDeleteAlert = true
            }
            .store(in: &subscriptions)
        
        // Wait for delete completion
        Publishers.Zip(deleteTodo, confirmDeleteAction)
            .sink { [weak self] todoItem, confirmDelete in
                guard let self = self else { return }
                if !confirmDelete { return }
                self.modelContext.delete(todoItem)
            }
            .store(in: &subscriptions)
    }
}
