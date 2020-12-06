//
//  ContentView.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/10/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: FBManager
    @EnvironmentObject var user: User
    @State private var isEditing: Bool = false
    @State private var showAdd: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(user.exercises, id: \.id) { exercise in
                    ZStack(alignment: .leading) {
                        NavigationLink("", destination: ExerciseView(exercise: exercise, records: $manager.records))
                        ExerciseCell(exercise: exercise, records: manager.records.records(forExercise: exercise))
                    }.padding(.all, 2)
                }.onDelete(perform: handleDelete(at:) )
            }.navigationBarTitle("WERKOUTZ", displayMode: .inline)
            .navigationBarItems(trailing: HStack {
                NavigationButton(action: { showAdd.toggle() }, image: "plus.circle")
            })
            .listStyle(InsetGroupedListStyle())
        }.sheet(isPresented: $showAdd, content: {
            AddExerciseView(showModal: $showAdd)
                .environmentObject(manager)
        })
    }
}

extension ContentView {
    private func handleDelete(at index: IndexSet) {
        guard let index = Array(index).first else { return }
        let exercise = manager.user.exercises[index]
        manager.user.removeExercise(exercise)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
    }
}
