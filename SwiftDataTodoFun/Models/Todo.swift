//
//  TodoModel.swift
//  SwiftDataTodoFun
//
//  Created by Neal Archival on 7/27/23.
//

import Foundation
import SwiftData

@Model
class Todo: Identifiable {
    var title: String
    var isComplete: Bool
    var creationDate: Date
    
    init(title: String, isComplete: Bool = false) {
        self.title = title
        self.isComplete = isComplete
        self.creationDate = .now
    }
}
