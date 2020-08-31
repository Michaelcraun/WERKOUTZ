//
//  AddExerciseView.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/13/20.
//

import SwiftUI

struct AddExerciseView: View {
    @State private var name: String = ""
    @State private var type: String = ""
    @State private var showTypeOptions: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "rectangle.and.paperclip")
                    .renderingMode(.template)
                    .frame(width: screen.width, height: screen.width / 3)
                    .onTapGesture(perform: chooseImage)
                ExerciseSearchField()
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
                    primaryButton: Alert.Button.default(Text("Weighted"), action: { type = "Weighted" }),
                    secondaryButton: Alert.Button.default(Text("Duration"), action: { type = "Duration" }))
            })
        }
    }
}

extension AddExerciseView {
    private func chooseImage() {
        
    }
    
    private func displayTypeOptions() {
        
    }
    
    private func finish() {
        
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView()
    }
}
