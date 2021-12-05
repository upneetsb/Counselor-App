//
//  CamperView.swift
//  final_project
//
//  Created by Upneet Bir on 11/29/21.
//

import CoreData
import FirebaseDatabase
import SwiftUI

struct AddCamperView: View {
    @EnvironmentObject var camper: Camper
    @Binding var adding: Bool
    @State var nameStr = ""
    @State var phoneStr = ""
    @State var parentInformationStr = ""
    @State var allergiesStr = ""
    @State var notesStr = ""
    @State var dob = Date()
    @State var showingPicture = false

    var body: some View {
        Form {
            HStack {
                Text("name:")
                Spacer()
                TextField("name", text: $nameStr)
            }
            HStack {
                Text("phone:")
                Spacer()
                TextField("phone", text: $phoneStr)
            }
            HStack {
                Text("allergies:")
                Spacer()
                TextField("any allergies?", text: $allergiesStr)
            }
            HStack {
                Text("parentInformation:")
                Spacer()
                TextField("parent email/number", text: $parentInformationStr)
            }
            HStack {
                Text("notes:")
                Spacer()
                TextField("notes for us counselors?", text: $notesStr)
            }
            HStack {
                DatePicker("Birthday: ", selection: $dob, displayedComponents: .date)
            }
            HStack {
                Button(action: {
                    self.showingPicture.toggle()
                }) {
                    Text("Add Camper Photo")
                }.sheet(isPresented: $showingPicture) {
                    TestView()
                }
            }
        }

        Button("Submit Camper") {
            guard !nameStr.isEmpty,
                  !phoneStr.isEmpty
            else {
                adding = false
                return
            }
            var de = CamperEntry(id: nil, name: nameStr, phone: phoneStr, allergies: allergiesStr, parent_contact: parentInformationStr, notes: notesStr, strikes: 0)

            camper.addEntry(entry: &de)
            adding = false
        }
    }
}

struct CamperPreview: View {
    var entry: CamperEntry

    var body: some View {
        VStack {
            HStack {
                Text(entry.name)
                Spacer()
                Image(systemName: "person.fill")
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .frame(width: 25.0, height: 25.0)
            }
        }
    }
}

struct CamperEntryView: View {
    @EnvironmentObject var camper: Camper
    var entry: CamperEntry
    
    private func incrementStrikes() {
        print("Selected this camper: " + entry.name)
        
    }
    var body: some View {
        VStack {
            Form{
                Image(systemName: "person.fill")
                    .clipShape(Circle())
                    .shadow(radius: 10)
                Text("Name: " + entry.name).fontWeight(.bold)
                Text("Any Allergies? " + entry.allergies)
                Text("Parent Contact Information " + entry.phone)
                Text("Private Notes: " + (entry.notes ?? ""))
                if entry.strikes > 5 {
                    Text("Camper has " + String(entry.strikes) + " strikes!").font(.headline).bold().foregroundColor(.red)
                }
                else if entry.strikes == 0 {
                    Text("Camper has " + String(entry.strikes) + " strikes!").foregroundColor(.green)
                }
                else {
                    Text("Camper has " + String(entry.strikes) + " strikes!").foregroundColor(.yellow)
                }
            }
            
            Button(action: {
                camper.updateStrikes(entry: self.entry)
            }) {
                Text("Give Strike")
            }
            
//            HStack {
//                Text("phone:\t").bold()
//                Text(entry.phone)
//                Spacer()
//            }
//            HStack {
//                Text("allergies:\t").bold()
//                Text(entry.allergies)
//                Spacer()
//            }
        }
    }
}

struct PopupView: View {
    @EnvironmentObject var camper: Camper
    @State var showPopUp: Bool = false
    var entry: CamperEntry
    var body: some View {
        if $showPopUp.wrappedValue {
            ZStack {
                Color.white
                VStack {
                    Text("Camper \(self.entry.name) has recieved \(self.entry.strikes - 5) too many warnings.")
                    Button(action: {
                        self.showPopUp = false
                    }, label: {
                        Text("Close and Report")
                    })
                }.padding()
            }
            .frame(width: 300, height: 200)
            .cornerRadius(20).shadow(radius: 20)
        }
    }
}
struct CamperView: View {
    @EnvironmentObject var camper: Camper
    @State var adding = false

    var body: some View {
        NavigationView {
            VStack {
//                Text("List of Campers").bold()
                List {
                    ForEach(0 ..< camper.entries.keys.count, id: \.self) { i in
                        let key = camper.entries.keys.index(camper.entries.keys.startIndex, offsetBy: i)
                        let entry = camper.entries[key]
                        NavigationLink {
                            CamperEntryView(entry: entry.value)
                        } label: {
                            CamperPreview(entry: entry.value)
                        }

                    }.onDelete(perform: deleteEm)
                }

//                NavigationLink(destination: AddCamperView(adding: $adding)
//                    .environmentObject(camper),
//                    isActive: $adding) {
//                        Button(action: { adding = true }) {
//                            Label("Add Item", systemImage: "plus")
//                        }
//                }
            }
            .navigationBarTitle("List Of Campers")
            .navigationBarItems(trailing: Button(action: {
                self.adding.toggle()
            }) {
                Label("", systemImage: "plus")
            }.sheet(isPresented: $adding) {
                AddCamperView(adding: $adding)
            })
        }
    }

    private func idByOffset(_ offset: Int) -> String {
        let idx = camper.entries.keys.index(camper.entries.keys.startIndex, offsetBy: offset)
        let (key, _) = camper.entries[idx]
        return key
    }

    private func addItem(_ entry: inout CamperEntry) {
        withAnimation {
            camper.addEntry(entry: &entry)
        }
    }

    private func deleteEm(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                idByOffset($0)
            }.forEach(camper.delEntry)
        }
    }
}

struct CamperView_Previews: PreviewProvider {
    static var previews: some View {
        CamperView()
    }
}
