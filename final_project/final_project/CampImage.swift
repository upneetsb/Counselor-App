//
//  CampImage.swift
//  final_project
//
//  Created by Upneet Bir on 12/4/21.
//

import Foundation
import FirebaseDatabase
import Firebase

struct ImageEntry: Codable, Identifiable {
    var id: String?
    var caption: String
    var upvotes: Int
    var image_path: String

    var dict: NSDictionary? {
        if let idStr = id {
            let d = NSDictionary(dictionary: [
                "id": idStr, "caption": caption, "upvotes": upvotes, "image_path": image_path
            ])
            return d
        }
        return nil
    }

    static func fromDict(_ d: NSDictionary) -> ImageEntry? {
        guard let caption = d["caption"] as? String else { return nil }
        guard let image_path = d["image_path"] as? String else { return nil }
        guard let upvotes = d["upvotes"] as? Int else { return nil }
        return ImageEntry(id: d["id"] as? String, caption: caption, upvotes: upvotes, image_path: image_path)
    }
}

class CampImage {
    @Published var image_entries: [String: ImageEntry] = [:]

    init() {
        let rootRef = Database.database().reference(withPath: "Images")
//        let rootRef = Database.database().reference()
        print(rootRef)
        rootRef.getData { _, snapshot in
            DispatchQueue.main.async {
                for child in snapshot.children {
                    print(child)
                    if let item = child as? DataSnapshot {
                        if let val = item.value as? NSDictionary,
                           let de = ImageEntry.fromDict(val),
                           let id = de.id { self.image_entries[id] = de }
                    }
                }
            }
        }
        rootRef.observe(.childAdded) { snapshot in
            if let v = snapshot.value as? NSDictionary,
               let de = ImageEntry.fromDict(v),
               let id = de.id { self.image_entries[id] = de }
        }
        rootRef.observe(.childRemoved) { snapshot in
            self.image_entries.removeValue(forKey: snapshot.key)
        }
        rootRef.observe(.childChanged) { snapshot in
            if let v = snapshot.value as? NSDictionary,
               let de = ImageEntry.fromDict(v),
               let id = de.id { self.image_entries[id] = de }
        }
    }
    
    
    
    func addEntry(entry: inout MessageEntry) {
        
        print("Entry Information: ", Date())
        let rootRef = Database.database().reference()
//        let childRef = rootRef.childByAutoId()

        let childRef = rootRef.child("Images").childByAutoId()
//        let childRef = rootRef.childByAutoId()
        entry.id = childRef.key
        if let val = entry.dict {
            childRef.setValue(val)
        }

//        let root = Database.database().reference()
//        root.child("values").childByAutoId().setValue(["name": "Camper", "url": "https://sedna.cs.umd.edu/436clips/vids/neo.mp4"])
    }

    func delEntry(id: String) {
        image_entries.removeValue(forKey: id)
        let rootRef = Database.database().reference(withPath: "Images")
//        let rootRef = Database.database().reference()

        rootRef.child(id).removeValue()
    }
    
}
