//
//  ExerciseSearchField.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/13/20.
//

import SwiftUI

struct ExerciseSearchField: View {
    @EnvironmentObject var manager: FBManager
    @State private var exercises: [Exercise] = []
    @Binding var searchText: String
    @Binding var type: String
    let onSelect: (Exercise) -> Void
    
    var body: some View {
        VStack {
            TextField("Exercise Name", text: $searchText)
                .onChange(of: searchText, perform: { _ in search() })
            VStack {
                ForEach(exercises) { exercise in
                    ExerciseCell(exercise: exercise, records: [])
                        .onTapGesture { select(exercise) }
                }
            }
        }.padding(.all, 5)
    }
}

extension ExerciseSearchField {
    private func search() {
        manager.searchExercises(searchText)
        exercises = manager.searchedExercisees ?? manager.exercises
    }
    
    private func select(_ exercise: Exercise) {
        searchText = exercise.name
        onSelect(exercise)
    }
}
