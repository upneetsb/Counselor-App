//
//  final_projectApp.swift
//  final_project
//
//  Created by Upneet Bir on 11/29/21.
//

import SwiftUI

import Firebase
import CoreLocation
import UIKit

@main
struct final_projectApp: App {
    let persistenceController = PersistenceController.shared
    @State private var tabS = 1
    @StateObject var campers = Camper()
    @StateObject var messageObj = Message()
    @StateObject var lm = Locationer()
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabS) {
                VStack{
                TaskView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                Spacer()
//                MapView().environment(\.managedObjectContext, persistenceController.container.viewContext).environmentObject(lm)
                }.tabItem {
                    Label("Home", systemImage: "house")
                }.tag(1)
                CamperView().environment(\.managedObjectContext, persistenceController.container.viewContext).environmentObject(campers)
                    .tabItem {
                        Label("Campers", systemImage: "person.3")
                    }.tag(2)
                MessageBoardView().environment(\.managedObjectContext, persistenceController.container.viewContext).environmentObject(messageObj)
                    .tabItem {
                        Label("Messages", systemImage: "person.2.circle")
                    }.tag(3)
                ProfileView().environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label("My Profile", systemImage: "person")
                    }.tag(4)
            }
        }
    }
}
