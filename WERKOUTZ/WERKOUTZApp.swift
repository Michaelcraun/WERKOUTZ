//
//  WERKOUTZApp.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/10/20.
//

import SwiftUI
import Firebase

@main
struct WERKOUTZApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        FirebaseApp.configure()
        FBManager.shared.checkAuth { error in
            if let error = error {
                print("WERKOUTZ - error initializing Firebase:", error.localizedDescription)
            } else {
                FBManager.shared.addExerciseListener { (_, _) in
                    FBManager.shared.addRecordListener()
                    FBManager.shared.user?.addListener()
                }
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(FBManager.shared)
                .onChange(of: scenePhase, perform: { phase in
                    switch phase {
                    case .active: didBecomeActive()
                    case .background: didEnterBackground()
                    case .inactive: didBecomeInactive()
                    @unknown default: fatalError("This case is not handled!")
                    }
                })
        }
    }
}

extension WERKOUTZApp {
    private func didBecomeActive() {
        
    }
    
    private func didBecomeInactive() {
        
    }
    
    private func didEnterBackground() {
        
    }
}
