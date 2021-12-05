//
//  Message.swift
//  final_project
//
//  Created by Upneet Bir on 12/1/21.
//

import FirebaseDatabase
import Foundation

struct MessageEntry: Codable, Identifiable {
    var id: String?
    var message: String
    var subject: String
    var resolved: Bool
    var replies: [String]

    var dict: NSDictionary? {
        if let idStr = id {
            let d = NSDictionary(dictionary: ["id": idStr, "subject": subject, "message": message, "resolved": resolved, "replies": replies])
            return d
        }
        return nil
    }

    static func fromDict(_ d: NSDictionary) -> MessageEntry? {
        guard let subject = d["subject"] as? String else { return nil }
        guard let message = d["message"] as? String else { return nil }
        guard let resolved = d["resolved"] as? Bool else { return nil }
        guard let replies = d["replies"] as? [String] else { return nil }
        return MessageEntry(id: d["id"] as? String, message: message, subject: subject, resolved: resolved, replies: replies)
    }
}

class Message: ObservableObject {
    @Published var entries: [String: MessageEntry] = [:]

    init() {
        let rootRef = Database.database().reference(withPath: "MessagesTest")
//        let rootRef = Database.database().reference()
        print(rootRef)
        rootRef.getData { _, snapshot in
            DispatchQueue.main.async {
                for child in snapshot.children {
                    print(child)
                    if let item = child as? DataSnapshot {
                        if let val = item.value as? NSDictionary,
                           let de = MessageEntry.fromDict(val),
                           let id = de.id { self.entries[id] = de }
                    }
                }
            }
        }
        rootRef.observe(.childAdded) { snapshot in
            if let v = snapshot.value as? NSDictionary,
               let de = MessageEntry.fromDict(v),
               let id = de.id { self.entries[id] = de }
        }
        rootRef.observe(.childRemoved) { snapshot in
            self.entries.removeValue(forKey: snapshot.key)
        }
        rootRef.observe(.childChanged) { snapshot in
            if let v = snapshot.value as? NSDictionary,
               let de = MessageEntry.fromDict(v),
               let id = de.id { self.entries[id] = de }
        }
    }

    func addEntry(entry: inout MessageEntry) {
        print("Entry Information: ", Date())
        let rootRef = Database.database().reference()
//        let childRef = rootRef.childByAutoId()

        let childRef = rootRef.child("MessagesTest").childByAutoId()
//        let childRef = rootRef.childByAutoId()
        entry.id = childRef.key
        if let val = entry.dict {
            childRef.setValue(val)
        }

//        let root = Database.database().reference()
//        root.child("values").childByAutoId().setValue(["name": "Camper", "url": "https://sedna.cs.umd.edu/436clips/vids/neo.mp4"])
    }

    func updateEntry(entry: MessageEntry) {
        let rootRef = Database.database().reference()

        rootRef.child("MessagesTest").child(entry.id!).setValue(["id": entry.id!, "subject": entry.subject, "message": entry.message, "resolved": !entry.resolved, "replies": entry.replies])
        print("updated entry in db")
    }

    func addReply(entry: MessageEntry, reply: String) {
        let rootRef = Database.database().reference()
        var new_arr = entry.replies

        new_arr.append(reply)
        rootRef.child("MessagesTest").child(entry.id!).setValue(["id": entry.id!, "subject": entry.subject, "message": entry.message, "resolved": entry.resolved, "replies": new_arr])
    }

    func delEntry(id: String) {
        entries.removeValue(forKey: id)
        let rootRef = Database.database().reference(withPath: "MessagesTest")
//        let rootRef = Database.database().reference()

        rootRef.child(id).removeValue()
    }
}
