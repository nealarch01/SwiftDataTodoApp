//
//  TodoPreviewSampleData.swift
//  SwiftDataTodoFun
//
//  Created by Neal Archival on 7/27/23.
//

import SwiftData

@MainActor
let TodoListPreviewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Todo.self, ModelConfiguration(inMemory: true))
        for sampleTodo in SampleTodos {
            container.mainContext.insert(object: sampleTodo)
        }
        return container
    } catch let error {
        fatalError(error.localizedDescription)
    }
}()
