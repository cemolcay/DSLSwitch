//
//  ContentView.swift
//  DSL Switch WatchKit Extension
//
//  Created by Cem Olcay on 6/18/22.
//

import SwiftUI
import WatchConnectivity

class SessionManager: NSObject, WCSessionDelegate {
    let session: WCSession

    override init() {
        session = WCSession.default
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }

    func sendMessage(_ message: ControlMessage) {
        guard session.activationState == .activated else { return }
        session.sendMessage(["control": message.rawValue], replyHandler: nil)
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        return
    }
}

struct ContentView: View {
    var manager = SessionManager()
    
    var body: some View {
        List {
            Section(header: Text("Channels")) {
                DSLButton("Clean") { manager.sendMessage(.clean) }
                DSLButton("Crunch") { manager.sendMessage(.crunch) }
                DSLButton("Ultra Gain 1") { manager.sendMessage(.od1) }
                DSLButton("Ultra Gain 2") { manager.sendMessage(.od2) }
            }
            Section(header: Text("FX Loop")) {
                DSLButton("On") { manager.sendMessage(.fxOn) }
                DSLButton("Off") { manager.sendMessage(.fxOff) }
            }
            Section(header: Text("Master")) {
                DSLButton("Master 1") { manager.sendMessage(.master1) }
                DSLButton("Master 2") { manager.sendMessage(.master2) }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
