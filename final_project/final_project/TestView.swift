//
//  TestView.swift
//  final_project
//
//  Created by Upneet Bir on 11/30/21.
//

import FirebaseDatabase
import SwiftUI
import UIKit

struct TestView: View {
    @State var showAction: Bool = false
    @State var showImagePicker: Bool = false

    @State var uiImage: UIImage? = nil

    var sheet: ActionSheet {
        ActionSheet(
            title: Text("Action"),
            message: Text("Quotemark"),
            buttons: [
                .default(Text("Change"), action: {
                    self.showAction = false
                    self.showImagePicker = true
                }),
                .cancel(Text("Close"), action: {
                    self.showAction = false
                }),
                .destructive(Text("Remove"), action: {
                    self.showAction = false
                    self.uiImage = nil
                }),
            ]
        )
    }

    var body: some View {
        VStack {
            if uiImage == nil {
                Image(systemName: "camera.on.rectangle")
                    .accentColor(Color.purple)
                    .background(
                        Color.gray
                            .frame(width: 100, height: 100)
                            .cornerRadius(6))
                    .onTapGesture {
                        self.showImagePicker = true
                    }
            } else {
                Image(uiImage: uiImage!)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(6)
                    .onTapGesture {
                        self.showAction = true
                    }
            }

            Button(action: {
                print("Pressed")
                ImagePicker(isShown: self.$showImagePicker, uiImage: self.$uiImage)

//                var de = MessageEntry(id: nil, message: self.message, subject: self.subject)
//                messageObj.addEntry(entry: &de)
                ////                adding = false
//                self.showSheetView.toggle()

            }) {
                Text("Submit Note")
            }
        }

        .sheet(isPresented: $showImagePicker, onDismiss: {
            self.showImagePicker = false
        }, content: {
//            ImagePicker(isShown: self.$showImagePicker, sourceType: .camera, selectedImage: self.$image)
            ImagePicker(isShown: self.$showImagePicker, uiImage: self.$uiImage)
        })

        .actionSheet(isPresented: $showAction) {
            sheet
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var uiImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isShown: Bool
        @Binding var uiImage: UIImage?

        init(isShown: Binding<Bool>, uiImage: Binding<UIImage?>) {
            _isShown = isShown
            _uiImage = uiImage
//            persistImageToStorage()
        }

        func imagePickerController(_: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
        {
            let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            print(imagePicked)

            uiImage = imagePicked
            isShown = false
        }

        func imagePickerControllerDidCancel(_: UIImagePickerController) {
            isShown = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, uiImage: $uiImage)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_: UIImagePickerController,
                                context _: UIViewControllerRepresentableContext<ImagePicker>) {}

    func persistImageToStorage() {
        let filename = UUID().uuidString

        let rootRef = Database.database().reference()
        guard let imageData = uiImage?.jpegData(compressionQuality: 0.5) else { return }
        rootRef.setValue(imageData)

        print("added image.")
//        (imageData, metadata: nil) { metadata, err in
//            if let err = err {
//                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
//                return
//            }
//
//            ref.downloadURL { url, err in
//                if let err = err {
//                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
//                    return
//                }
//
//                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
//                print(url?.absoluteString)
//            }
//        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
