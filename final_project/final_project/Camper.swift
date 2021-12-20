//
//  Camper.swift
//  final_project
//
//  Created by Upneet Bir on 11/30/21.
//

import FirebaseDatabase
import Foundation

struct CamperEntry: Codable, Identifiable {
    var id: String?
    var name: String
    var phone: String
    var allergies: String
    var parent_contact: String
    var notes: String?
    var strikes: Int
    var dict: NSDictionary? {
        if let idStr = id {
            let d = NSDictionary(dictionary: [
                "id": idStr, "name": name, "phone": phone, "allergies": allergies, "parent_contact": parent_contact, "notes": notes, "strikes": strikes,
            ])
            return d
        }
        return nil
    }

    static func fromDict(_ d: NSDictionary) -> CamperEntry? {
        guard let name = d["name"] as? String else { return nil }
        guard let phone = d["phone"] as? String else { return nil }
        guard let allergies = d["allergies"] as? String else { return nil }
        guard let parent_contact = d["parent_contact"] as? String else { return nil }
        guard let notes = d["notes"] as? String else { return nil }
        guard let strikes = d["strikes"] as? Int else { return nil }
        return CamperEntry(id: d["id"] as? String, name: name, phone: phone, allergies: allergies, parent_contact: parent_contact, notes: notes, strikes: strikes)
    }
}

struct Parent {
    var parentName: String
    var phone: String
    var email: String

    init(par: String, phone: String, email: String) {
        parentName = par
        self.phone = phone
        self.email = email
    }
}

// struct Parent: Codable, Identifiable {
//    var id: String?
//    var name: String
//    var phone: String
//    var email: String
//
//    var dict: NSDictionary? {
//        if let idStr = id {
//            let d = NSDictionary(dictionary: [
//               "id": idStr, "name": name, "phone": phone, "email": email ])
//            return d
//        }
//        return nil
//    }
//
//    static func fromDict(_ d: NSDictionary) -> Parent? {
//        guard let name = d["name"] as? String else { return nil }
//        guard let phone = d["phone"] as? String else { return nil }
//        guard let email = d["email"] as? String else { return nil }
//        return Parent(id: d["id"] as? String, name: name, phone: phone, email: email)
//    }
// }

class Camper: ObservableObject {
    @Published var entries: [String: CamperEntry] = [:]

    init() {
        let rootRef = Database.database().reference(withPath: "Camper Data")
        rootRef.getData { _, snapshot in
            DispatchQueue.main.async {
                for child in snapshot.children {
                    if let item = child as? DataSnapshot {
                        if let val = item.value as? NSDictionary,
                           let de = CamperEntry.fromDict(val),
                           let id = de.id { self.entries[id] = de }
                    }
                }
            }
        }
        rootRef.observe(.childAdded) { snapshot in
            if let v = snapshot.value as? NSDictionary,
               let de = CamperEntry.fromDict(v),
               let id = de.id { self.entries[id] = de }
        }
        rootRef.observe(.childRemoved) { snapshot in
            self.entries.removeValue(forKey: snapshot.key)
        }
        rootRef.observe(.childChanged) { snapshot in
            if let v = snapshot.value as? NSDictionary,
               let de = CamperEntry.fromDict(v),
               let id = de.id { self.entries[id] = de }
        }
    }

    func addEntry(entry: inout CamperEntry) {
        let rootRef = Database.database().reference()
        let childRef = rootRef.child("Camper Data").childByAutoId()
        entry.id = childRef.key
        if let val = entry.dict {
            childRef.setValue(val)
        }
    }

    func delEntry(id: String) {
        print(id)
        entries.removeValue(forKey: id)
        let rootRef = Database.database().reference(withPath: "Camper Data")
//        let rootRef = Database.database().reference()

        rootRef.child(id).removeValue()
    }

    func updateStrikes(entry: CamperEntry) {
        let newStrikes = entry.strikes + 1
        let rootRef = Database.database().reference()
        // id: d["id"] as? String, name: name, phone: phone, allergies: allergies, parent_contact: parent_contact, notes: notes, strikes: strikes
        rootRef.child("Camper Data").child(entry.id!).setValue(["id": entry.id!, "name": entry.name, "phone": entry.phone, "allergies": entry.allergies, "parent_contact": entry.parent_contact, "notes": entry.notes, "strikes": newStrikes])
        print("updated entry in db")
    }
}
