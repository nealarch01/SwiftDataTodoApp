//
//  TodoViewModel.swift
//  SwiftDataTodoFun
//
//  Created by Neal Archival on 7/27/23.
//

import Foundation
import SwiftData

@MainActor
class TodoViewModel: ObservableObject {
    /// The database connection
    private let modelContext: ModelContext
    
    /// When using Xcode previews, prevent create, update, or delete operations on SampleData
    private let inPreviewMode = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    
    @Published var newTodoText: String = ""
    
    @Published var editTodoText: String = ""
    @Published var showEditAlert: Bool = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    public func createNewTodo() {
        if inPreviewMode { return }
        let newTodo = Todo(title: newTodoText, isComplete: false)
        self.modelContext.insert(newTodo)
        newTodoText = ""
    }
    
    public func updateTodoTitle(todo: Todo) {
        if inPreviewMode { return }
        todo.title = editTodoText
    }
    
    public func updateTodoCompletionStatus(todo: Todo, isComplete: Bool) {
        if inPreviewMode { return }
        todo.isComplete = isComplete
    }
    
    public func deleteTodo(todo: Todo) {
        if inPreviewMode { return }
        modelContext.delete(todo)
    }
}
