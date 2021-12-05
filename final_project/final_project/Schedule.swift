//
//  Schedule.swift
//  final_project
//
//  Created by Upneet Bir on 12/5/21.
//

import Foundation

struct Schedule: Codable {
    var day_of_week: String
    var schedule_of_day: [String: String]
    var start_date: String
    var end_date: String
    var timezone: String

    init() {
        load("schedule.json")
        day_of_week = ""
        schedule_of_day = [:]
        start_date = ""
        end_date = ""
        timezone = ""
    }
}

func load(_ name: String) -> Data? {
    do {
        if let bundlePath = Bundle.main.path(forResource: name,
                                             ofType: "json"),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)
        {
            return jsonData
        }
    } catch {
        print(error)
    }

    return nil

//    do {
//        let decoder = JSONDecoder()
//        return try decoder.decode(T.self, from: data)
//    } catch {
//        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
//    }
}
