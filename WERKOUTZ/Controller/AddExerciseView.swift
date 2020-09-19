//
//  AddExerciseView.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/13/20.
//

import SwiftUI

struct AddExerciseView: View {
    @EnvironmentObject var manager: FBManager
    @Binding var showModal: Bool
    @State private var exercise: Exercise?
    @State private var image: UIImage?
    @State private var name: String = ""
    @State private var type: String = ""
    @State private var showTypeOptions: Bool = false
    @State private var showImageCaptureType: Bool = false
    @State private var showImageCapture: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        NavigationView {
            VStack {
                if image == nil {
                    Image(systemName: "rectangle.and.paperclip")
                        .renderingMode(.template)
                        .scaledToFill()
                        .frame(width: screen.width, height: screen.width / 3)
                        .onTapGesture(perform: { showImageCaptureType.toggle() })
                } else {
                    Image(uiImage: image!)
                        .scaledToFill()
                        .frame(width: screen.width, height: screen.width)
                        .clipped()
                        .onTapGesture(perform: { showImageCaptureType.toggle() })
                }
                ExerciseSearchField(searchText: $name, type: $type) { (exercise) in
                    self.exercise = exercise
                    self.type = exercise.type.rawValue
                }
                .environmentObject(manager)
                TextField("Exercise Type", text: $type)
                    .padding(.all, 5)
                    .onTapGesture(perform: { showTypeOptions.toggle() })
                Spacer()
            }.navigationBarTitle("Add Exercise")
            .navigationBarItems(trailing: HStack {
                NavigationButton(action: finish, image: "checkmark.circle")
            })
            .alert(isPresented: $showTypeOptions, content: {
                Alert(
                    title: Text("Exercise Type"),
                    message: Text("Please select a type:"),
                    primaryButton: Alert.Button.default(Text("Weighted"), action: { type = "weighted" }),
                    secondaryButton: Alert.Button.default(Text("Duration"), action: { type = "duration" }))
            })
            .actionSheet(isPresented: $showImageCaptureType, content: {
                ActionSheet(
                    title: Text("Add an Image From..."),
                    buttons: [
                        ActionSheet.Button.default(Text("Library"), action: { chooseImage(from: .photoLibrary) }),
                        ActionSheet.Button.default(Text("Camera"), action: { chooseImage(from: .camera) }),
                        ActionSheet.Button.cancel()])
            })
            .sheet(isPresented: $showImageCapture) {
                ImageCaptureView(isShown: $showImageCapture, image: $image, sourceType: sourceType)
            }
        }
    }
}

extension AddExerciseView {
    private func chooseImage(from source: UIImagePickerController.SourceType) {
        sourceType = source
        showImageCapture.toggle()
    }
    
    private func finish() {
        if let exercise = exercise {
            FBManager.shared.user.addExercise(exercise)
            showModal.toggle()
        } else if let type = Exercise.ExerciseType(rawValue: type) {
            let exercise = Exercise(name, image: image, type: type)
            exercise.put { (error) in
                if let error = error {
                    print("AddExerciseView - \(#function) encountered an error:", error.localizedDescription)
                } else {
                    FBManager.shared.user.addExercise(exercise)
                    showModal.toggle()
                }
            }
        } else {
            print("AddExerciseView - \(#function) encountered an error: type isn't filled out!")
        }
    }
}
