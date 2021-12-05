//
//  MessageBoardView.swift
//  final_project
//
//  Created by Upneet Bir on 12/1/21.
//

import SwiftUI

//struct AddReplyView: View {
//    @EnvironmentObject var messageObj: Message
//    @Binding var adding: Bool
//    @State var nameStr: String = ""
//    @State var replyStr: String = ""
//
//    var body: some View {
//        Form {
//            HStack {
//                Text("Name:")
//                Spacer()
//                TextField("Name", text: $nameStr)
//            }
//            HStack {
//                Text("Reply:")
//                Spacer()
//                TextField("Enter Message Heres", text: $nameStr)
//            }
//        }
//
//        Button("Submit Reply") {
//            guard !nameStr.isEmpty,
//                  !replyStr.isEmpty
//            else {
//                adding = false
//                return
//            }
//            var de = MessageEntry(id: messageObj.entries[$0], name: nameStr, phone: phoneStr, allergies: allergiesStr, parent_contact: parentInformationStr, notes: notesStr, strikes: 0)
//
//            camper.addEntry(entry: &de)
//            adding = false
//        }
//    }
//}

//struct IssuePicker: View {
//    @State private var favoriteColor: Int = 0
//
//        var body: some View {
//            VStack {
//                Picker("Select Issues", selection: $favoriteColor) {
//                    Text("Resolved").tag(0)
//                    Text("Unresolved").tag(1)
//                }
//                .pickerStyle(.segmented)
//
//                if favoriteColor == 0 {
//
//                }
////                Text("Value: \(favoriteColor)")
//            }
//        }
//}


struct MessageEntryView: View {
    @EnvironmentObject var messageObj: Message
    @State var showingReplySheet: Bool = false
    @State var showAction: Bool = false
    
    var entry: MessageEntry
    
    var body: some View {
        VStack {
            if entry.resolved {
                Text("This issue was resolved!").font(.headline).bold().foregroundColor(.green)
            }
            else {
                Text("This issue has not been resolved").font(.headline).bold().italic().foregroundColor(.red)
            }
            Spacer()
            Text(entry.subject).font(.title).padding(20)
            Text(entry.message)
            Spacer()
        }
        Button(action: {
            messageObj.updateEntry(entry: self.entry)
        }) {
            if entry.resolved {
                Text("Mark Unresolved.")
            }
            else {
                Text("Mark Resolved!")
            }
        }.padding(50)
    }
    
}

struct MessagePreview: View {
    var entry: MessageEntry
    var body: some View {
        if entry.resolved {
            VStack {
                Text(entry.subject)

            }.foregroundColor(.green)
        }

        else {
            VStack {
                Text(entry.subject).bold()
            }.foregroundColor(.red)
        }
    }
}
struct TextView: View {
    @State var str: String = ""
    
    var body: some View {
        Text(str).font(.title)
    }
}
struct MessageBoardView: View {
    @EnvironmentObject var messageObj: Message
    @State var showingSheet = false
    var body: some View {
        
        NavigationView {
            VStack {
                List {
                    ForEach(0 ..< messageObj.entries.keys.count, id: \.self) { i in
                        let key = messageObj.entries.keys.index(messageObj.entries.keys.startIndex, offsetBy: i)
                        let entry = messageObj.entries[key]
                        NavigationLink {
                            MessageEntryView(entry: entry.value)
                        } label: {
                            MessagePreview(entry: entry.value)
                        }

                    }.onDelete(perform: deleteEm)
                }
                
            }
            .navigationBarTitle("Messages and Issues")
            .navigationBarItems(trailing: Button(action: {
                self.showingSheet.toggle()
            }) {
                Label("", systemImage: "plus")
            }.sheet(isPresented: $showingSheet) {
                MessageSheetView(showSheetView: $showingSheet)
            })
        }
        
    }

    private func idByOffset(_ offset: Int) -> String {
        let idx = messageObj.entries.keys.index(messageObj.entries.keys.startIndex, offsetBy: offset)
        let (key, _) = messageObj.entries[idx]
        return key
    }

    private func addItem(_ entry: inout MessageEntry) {
        withAnimation {
            messageObj.addEntry(entry: &entry)
        }
    }

    private func deleteEm(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                idByOffset($0)
            }.forEach(messageObj.delEntry)
        }
    }
    
    
}

struct MessageSheetView: View {
    @Binding var showSheetView: Bool
    @State var subject: String = ""
    @State var message: String = ""
    var body: some View {
        NavigationView {
            SheetView(showSheetView: $showSheetView)
                .navigationBarTitle(Text("Compose New Message or Note"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    print("Dismissing sheet view...")
                    self.showSheetView = false
                }) {
                    Text("Done").bold()
                })
        }
    }
}

struct SheetView: View {
    @EnvironmentObject var messageObj: Message
    @Binding var showSheetView: Bool
    @State var subject: String = ""
    @State var message: String = ""

    var body: some View {
        VStack {
            Form {
                HStack {
                    Text("Subject:")
                    Spacer()
                    TextField("Subject", text: $subject)
                }
                HStack {
                    Text("Message:")
                    Spacer()
                    TextEditor(text: $message)
                    //                        TextField("phone", text: $message)
                }
            }
            Button(action: {
                var de = MessageEntry(id: nil, message: self.message, subject: self.subject, resolved: false)
                messageObj.addEntry(entry: &de)
//                adding = false
                self.showSheetView.toggle()

            }) {
                Text("Submit Note")
            }
        }
    }

    private func processNote() {
        print(subject)
    }
}

struct MessageBoardView_Previews: PreviewProvider {
    static var previews: some View {
        MessageBoardView()
    }
}
