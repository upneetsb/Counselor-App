//
//  ContentView.swift
//  final_project
//
//  Created by Upneet Bir on 11/29/21.
//

import CoreData
import CoreLocation
import Firebase
import FirebaseDatabase
import MapKit
import SwiftUI

// extension CLLocationCoordinate2D: Identifiable {
//    public var id: String { "\(latitude), \(longitude)"}
// }

struct ImageView: View {
    var text: String = ""
    var body: some View {
        Text("\(text)")
            .foregroundColor(.white)
            .font(.largeTitle)
            .frame(width: 200, height: 200)
            .background(Color.red)
    }
}

struct DisplayImage: View {
    var imagesTest: [String] = ["1", "2", "3", "4", "5", "6"]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 10) {
                ForEach(0 ..< imagesTest.count) { i in
                    ImageView(text: imagesTest[i])
                }
            }.padding()
        }
    }
}

struct ContentView: View {
    var body: some View {
//        Text("This is above the content view")
//        Spacer()
//        ScrollView(.horizontal){

//        }
//        Text("This is the Content View")
//        NavigationView {
//            VStack {
//                Button(action: {
//                    self.showingSheet.toggle()
//                }) {
//                    Label("", systemImage: "plus")
//                }.sheet(isPresented: $showingSheet) {
//                    MessageSheetView(showSheetView: $showingSheet)
//                }
//

//            }
//            DisplayImage()
//            .navigationBarTitle("Home Page")
//        }
        TaskView()
//        DisplayImage()
//        DisplayImage()

//        ScrollView(.horizontal, showsIndicators: true) {
//            HStack(spacing: 20) {
//                ForEach(0..<10) {
//
//                }
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
