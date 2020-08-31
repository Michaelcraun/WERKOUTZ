//
//  ContentView.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/10/20.
//

import SwiftUI

struct ContentView: View {
    @State private var isEditing: Bool = false
    @State private var showAdd: Bool = false
    @State private var exercises: [Exercise] = FBManager.shared.exercises
    @State private var records: [Record] = FBManager.shared.records
    
    var body: some View {
        NavigationView {
            List {
                ForEach(exercises, id: \.id) { exercise in
                    ZStack(alignment: .leading) {
                        NavigationLink("", destination: ExerciseView(exercise: exercise, records: $records))
                        ExerciseCell(exercise: exercise, records: records.records(forExercise: exercise))
                    }.padding(.all, 2)
                }.onDelete(perform: handleDelete(at:) )
            }.navigationBarTitle("WERKOUTZ", displayMode: .inline)
            .navigationBarItems(trailing: HStack {
                NavigationButton(action: { showAdd.toggle() }, image: "plus.circle")
            })
            .listStyle(InsetGroupedListStyle())
        }.sheet(isPresented: $showAdd, content: {
            AddExerciseView()
        })
    }
}

extension ContentView {
    private func handleDelete(at index: IndexSet) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
    }
}
