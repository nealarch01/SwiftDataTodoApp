//
//  TodoList.swift
//  SwiftDataTodoFun
//
//  Created by Neal Archival on 7/27/23.
//

import SwiftUI
import Combine
import SwiftData

struct TodoListView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    
    var todoItems: [Todo]
    
    @State var showCompleted: Bool = true
    
    var body: some View {
        List {
            Section(header: Text("TODO")) {
                ForEach(todoItems
                    .filter { !$0.isComplete }
                    .sorted { $0.creationDate > $1.creationDate }
                ) { todoItem in
                    todoItemRow(todoItem)
                }
            }
            
            Section(header: collapsibleSectionHeader()) {
                if showCompleted {
                    ForEach(todoItems.filter { $0.isComplete }) { todoItem in
                        todoItemRow(todoItem)
                    }
                }
            }
        }
        .alert("Edit todo", isPresented: $todoViewModel.showEditAlert) {
            TextField("", text: $todoViewModel.editTodoText)
            Button(action: {
                todoViewModel.confirmEditAction.send(false)
            }) {
                Text("Cancel")
            }
            Button(action: {
                todoViewModel.confirmEditAction.send(true)
            }) {
                Text("Done")
            }
        }
        .alert("Are you sure you want to delete this todo?", isPresented: $todoViewModel.showDeleteAlert) {
            Button(role: .cancel, action: {
                todoViewModel.confirmDeleteAction.send(false)
            }) {
                Text("Cancel")
            }
            Button(role: .destructive, action: {
                todoViewModel.confirmDeleteAction.send(true)
            }) {
                Text("Delete")
            }
        }
        .alert("No todo entered. Type some text to create a new todo!", isPresented: $todoViewModel.showErrorAlert) {
            Button(role: .cancel, action: {}) {
                Text("Dismiss")
            }
        }
    }
}

extension TodoListView {
    @ViewBuilder
    func todoItemRow(_ todoItem: Todo) -> some View {
        Text(todoItem.title)
            .swipeActions {
                Button(action: {
                    todoViewModel.toggleTodoCompletionStatus.send(todoItem)
                }) {
                    Text(todoItem.isComplete ? "Todo" : "Done")
                }
                .tint(todoItem.isComplete ? Color.blue : Color.green)
            }
            .contextMenu {
                Button(action: {
                    todoViewModel.editTodo.send(todoItem)
                }) {
                    Label("Edit", systemImage: "pencil")
                }
                Button(role: .destructive, action: {
                    todoViewModel.deleteTodo.send(todoItem)
                }) {
                    Label("Delete", systemImage: "minus.circle")
                }
            }

    }
    
    @ViewBuilder
    func collapsibleSectionHeader() -> some View {
        HStack {
            Text("COMPLETED")
            Spacer()
            Button(action: {
                withAnimation(.linear(duration: 0.225)) {
                    showCompleted.toggle()
                }
            }) {
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(showCompleted ? 0 : -90))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.blue)
                    .padding(.leading)
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    struct ViewContainer: View { // Fix for 'failed to find a currently active container'
        @Query var todoItems: [Todo]
        @Environment(\.modelContext) var modelContext
        var body: some View {
            TodoListView(
                todoViewModel: TodoViewModel(modelContext: modelContext),
                todoItems: todoItems
            )
        }
    }
    
    static var previews: some View {
        ViewContainer()
            .modelContainer(TodoListPreviewContainer)
    }
}
