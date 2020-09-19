//
//  ExerciseView.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/10/20.
//

import SwiftUI

struct ExerciseView: View {
    let exercise: Exercise
    @Binding var records: [Record]
    @State var isAdding: Bool = false
    @State var duration: String = "" 
    @State var reps: String = ""
    @State var weight: String = ""
    
    var body: some View {
        VStack {
            if exercise.image == nil {
                Image(systemName: "rectangle.and.paperclip")
                    .frame(width: screen.width, height: screen.height / 3)
            } else {
                Image(uiImage: exercise.image!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: screen.width, height: screen.height / 3)
            }
            List {
                HStack {
                    Text("History")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                if isAdding {
                    EntryCell(exercise.type, duration: $duration, reps: $reps, weight: $weight)
                }
                ForEach(records.records(forExercise: exercise), id: \.id) { record in
                    HistoryCell(record: record)
                }
            }.listStyle(InsetGroupedListStyle())
        }.navigationTitle(exercise.name)
        .navigationBarItems(trailing: HStack {
            NavigationButton(action: handleButton, image: isAdding ? "checkmark.circle" : "plus.circle")
        })
    }
}

extension ExerciseView {
    private func add() {
        let record = Record(exercise: exercise)
        switch exercise.type {
        case .duration:
            record.duration = duration
        case .weighted:
            record.reps = Int(reps)
            record.weight = Double(weight)
        }
        record.set { (error) in
            if let error = error {
                print("ExerciseView - \(#function) encountered an error:", error.localizedDescription)
            } 
        }
    }
    
    private func handleButton() {
        if isAdding {
            add()
        }
        isAdding.toggle()
    }
}
