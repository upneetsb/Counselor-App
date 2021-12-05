//
//  MapView.swift
//  final_project
//
//  Created by Upneet Bir on 12/1/21.
//
import CoreData
import CoreLocation
import Firebase
import FirebaseDatabase
import MapKit
import SwiftUI

extension CLLocationCoordinate2D: Identifiable {
    public var id: String { "\(latitude), \(longitude)" }
}

struct MapView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var lm: Locationer
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38, longitude: -76), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow))
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
