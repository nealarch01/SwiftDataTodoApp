//
//  SwiftDataTodoFunApp.swift
//  SwiftDataTodoFun
//
//  Created by Neal Archival on 7/27/23.
//

import SwiftUI
import SwiftData

/// Creates a new container (database/storage area)
/// Helpful reference: https://dev.to/thompson-dean/wwdc2023-swiftdata-basic-use-case-in-6-steps-m38
@MainActor
fileprivate func createTodoModelContainer() -> ModelContainer {
     do {
        let container = try ModelContainer(for: Todo.self, ModelConfiguration(inMemory: false))
         return container
    } catch let error {
        fatalError(error.localizedDescription)
    }
}

@main
struct SwiftDataTodoFunApp: App {
    var body: some Scene {
        let modelContainer = createTodoModelContainer()
        WindowGroup {
            ContentView(todoViewModel: TodoViewModel(modelContext: modelContainer.mainContext))
        }
        .modelContainer(modelContainer)
    }
}
