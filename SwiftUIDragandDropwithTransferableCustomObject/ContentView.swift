//
//  ContentView.swift
//  SwiftUIDragandDropwithTransferableCustomObject
//
//  Created by Ramill Ibragimov on 24.07.2023.
//

import SwiftUI
import Algorithms
import UniformTypeIdentifiers

struct ContentView: View {
    
    @State private var toDoTasks: [DeveloperTasks] = [MockData.taskOne, MockData.taskTwo, MockData.taskThree]
    @State private var inProgressTasks: [DeveloperTasks] = []
    @State private var doneTasks: [DeveloperTasks] = []
    
    @State private var isToDoTargeted = false
    @State private var isInProgressTargeted = false
    @State private var isDoneTargeted = false
    
    var body: some View {
        HStack(spacing: 12) {
            KanbanView(title: "To Do", tasks: toDoTasks, isTargeted: isToDoTargeted)
                .dropDestination(for: DeveloperTasks.self) { droppedTasks, location in
                    for task in droppedTasks {
                        inProgressTasks.removeAll { $0.id == task.id }
                        doneTasks.removeAll { $0.id == task.id }
                    }
                    let totalTasks = toDoTasks + droppedTasks
                    toDoTasks = Array(totalTasks.uniqued())
                    return true
                } isTargeted: { isTargered in
                    isToDoTargeted = isTargered
                }
            
            KanbanView(title: "In Progress", tasks: inProgressTasks, isTargeted: isInProgressTargeted)
                .dropDestination(for: DeveloperTasks.self) { droppedTasks, location in
                    for task in droppedTasks {
                        toDoTasks.removeAll { $0.id == task.id }
                        doneTasks.removeAll { $0.id == task.id }
                    }
                    let totalTasks = inProgressTasks + droppedTasks
                    inProgressTasks = Array(totalTasks.uniqued())
                    return true
                } isTargeted: { isTargered in
                    isInProgressTargeted = isTargered
                }
            
            KanbanView(title: "Done", tasks: doneTasks, isTargeted: isDoneTargeted)
                .dropDestination(for: DeveloperTasks.self) { droppedTasks, location in
                    for task in droppedTasks {
                        toDoTasks.removeAll { $0.id == task.id }
                        inProgressTasks.removeAll { $0.id == task.id }
                    }
                    let totalTasks = doneTasks + droppedTasks
                    doneTasks = Array(totalTasks.uniqued())
                    return true
                } isTargeted: { isTargered in
                    isDoneTargeted = isTargered
                }
        }
    }
}

struct KanbanView: View {
    
    let title: String
    let tasks: [DeveloperTasks]
    let isTargeted: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.footnote.bold())
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(isTargeted ? .teal.opacity(0.15) : Color(.secondarySystemFill))
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(tasks, id: \.id) { task in
                        Text(task.title)
                            .padding(12)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(8)
                            .shadow(radius: 1, x: 1, y: 1)
                            .draggable(task)
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
            }
        }
    }
}

struct DeveloperTasks: Codable, Hashable, Transferable {
    let id: UUID
    let title: String
    let owner: String
    let note: String
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .developerTask)
    }
}

extension UTType {
    static let developerTask = UTType(exportedAs: "com.ri.SwiftUIDragandDropwithTransferableCustomObject")
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}

struct MockData {
    static let taskOne = DeveloperTasks(id: UUID(), title: "Learn Swift", owner: "Me", note: "All about it")
    static let taskTwo = DeveloperTasks(id: UUID(), title: "Learn SwiftUI", owner: "Me", note: "All about it")
    static let taskThree = DeveloperTasks(id: UUID(), title: "Find a Job", owner: "Me", note: "Best job in good gompany")
}
