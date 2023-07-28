//
//  ContentView.swift
//  SwiftDataTodoFun
//
//  Created by Neal Archival on 7/27/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    
    @Query var todoItems: [Todo]
    
    @State var text: String = ""
    
    var body: some View {
        ZStack {
            TodoListView(todoViewModel: todoViewModel, todoItems: todoItems)
                .overlay(alignment: .bottom) {
                    VStack(spacing: 10) {
                        Divider()
                            .background(Color.black)
                        newTodoField()
                            .padding(.horizontal)
                            .padding(.bottom, 12)
                    }
                    .background(Color(red: 0xF1 / 255, green: 0xF0 / 255, blue: 0xF6 / 255))
                    .zIndex(1)
                }
        }
    }
    
    @ViewBuilder
    func newTodoField() -> some View {
        HStack(spacing: 4) {
            TextField("Enter todo", text: $todoViewModel.newTodoText)
                .frame(height: 35)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 2)
                }
            Button(action: { todoViewModel.createNewTodo() }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green)
                        .frame(width: 50, height: 45)
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    struct ViewContainer: View {
        @Environment(\.modelContext) var modelContext
        var body: some View {
            ContentView(todoViewModel: TodoViewModel(modelContext: modelContext))
        }
    }
    static var previews: some View {
        ViewContainer()
            .modelContainer(TodoListPreviewContainer)
    }
}
