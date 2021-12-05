//
//  TaskView.swift
//  final_project
//
//  Created by Upneet Bir on 12/5/21.
//

import CoreData
import Firebase
import FirebaseAuth
import SwiftUI

struct TaskRow: View {
    var task: ToDoTasks

    var body: some View {
        Text(task.task_title ?? "No name given")
    }
}

struct DetailView: View {
    @State var item: ToDoTasks
//    @State var region: MKCoordinateRegion
    var body: some View {
        VStack {
            Form {
                Text("Task Title: \(item.task_title!)")
                Text("Task Description: \(item.task_name ?? "")")
            }
        }
    }
}

struct TaskView: View {
//    @Environment(\.managedObjectContext) var context
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ToDoTasks.timestamp, ascending: true)],
        animation: .default
    )

    private var items: FetchedResults<ToDoTasks>

    @State private var taskName: String = ""
    @State private var task: String = ""

    var body: some View {
        VStack {
            HStack {
                TextField("Task Name", text: $taskName)
                TextField("Task Description", text: $task)
                Button(action: {
                    self.addTask()
                }) {
                    Text("Add Task")
                }
            }.padding(50)

            NavigationView {
                List {
                    ForEach(items) { item in
                        NavigationLink(destination: DetailView(item: item)) {
                            Text("Show details for \(item.task_title!)")
                        }.navigationBarTitle("My Personal Tasks")
                    }.onDelete(perform: deleteItems)
                }
            }

//            List {
//                ForEach(items){ task in
//                    Button(action: {
//                        self.deleteItems(task)
//                    }){
//                        TaskRow(task: task)
//                    }
//                }
//            }
        }
    }

    func addTask() {
        let newTask = ToDoTasks(context: viewContext)
        newTask.timestamp = Date()
        newTask.isDone = false
        newTask.task_title = taskName
        newTask.task_name = task

        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// struct TaskView: View {
//    @Environment(\.managedObjectContext) var context
//
//    var body: some View {
//        Text("Assigned Tasks")
//        Text("My Personal Tasks")
//    }
// }

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}
