//
//  TodoList.swift
//  SwiftDataTodoFun
//
//  Created by Neal Archival on 7/27/23.
//

import SwiftUI
import SwiftData

struct TodoListView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    let todoItems: [Todo]
    
    @State var showCompleted: Bool = true
    
    var body: some View {
        List {
            Section(header: Text("TODO")) {
                ForEach(todoItems.filter { !$0.isComplete }) { todoItem in
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
    }
}

extension TodoListView {
    @ViewBuilder
    func todoItemRow(_ todoItem: Todo) -> some View {
        Text(todoItem.title)
            .swipeActions {
                Button(action: {
                    todoViewModel.updateTodoCompletionStatus(
                        todo: todoItem,
                        isComplete: !todoItem.isComplete)
                }) {
                    Text(todoItem.isComplete ? "Todo" : "Done")
                }
                .tint(todoItem.isComplete ? Color.blue : Color.green)
            }
            .contextMenu {
                Group {
                    Button(action: {
                        todoViewModel.editTodoText = todoItem.title
                        todoViewModel.showEditAlert = true
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(role: .destructive, action: {
                        todoViewModel.deleteTodo(todo: todoItem)
                    }) {
                        Label("Delete", systemImage: "minus-circle")
                    }

                }
            }
            .alert("Edit todo", isPresented: $todoViewModel.showEditAlert) {
                TextField("", text: $todoViewModel.editTodoText)
                Button(action: {
                    todoViewModel.updateTodoTitle(todo: todoItem)
                    todoViewModel.showEditAlert = false
                }) {
                    Text("Done")
                }
                Button(action: { todoViewModel.showEditAlert = false }) {
                    Text("Cancel")
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
