//
//  ContentView.swift
//  DSLSwitch
//
//  Created by Cem Olcay on 5/11/22.
//

import SwiftUI
import WatchConnectivity

class SessionManager: NSObject, WCSessionDelegate {
    let session: WCSession
    let data: DSLData

    override init() {
        session = WCSession.default
        data = DSLData()
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }

    func handleMessage(message: [String: Any]) {
        guard let controlString = message["control"] as? String,
              let control = ControlMessage(rawValue: controlString)
        else { return }
        switch control {
        case .clean: data.clean()
        case .crunch: data.crunch()
        case .od1: data.od1()
        case .od2: data.od2()
        case .fxOn: data.fxLoopOn()
        case .fxOff: data.fxLoopOff()
        case .fxToggle: data.toggleFXLoop()
        case .master1: data.master1()
        case .master2: data.master2()
        case .masterToggle: data.toggleMaster()
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        handleMessage(message: message)
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        handleMessage(message: message)
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        handleMessage(message: userInfo)
    }

    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        handleMessage(message: userInfoTransfer.userInfo)
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        return
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        return
    }

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
}

struct ContentView: View {
    let session: SessionManager
    @ObservedObject var data: DSLData

    init() {
        session = SessionManager()
        data = session.data
    }

    var body: some View {
        List {
            Section(header: Text("Channels")) {
                DSLButton("Clean") { data.clean() }
                DSLButton("Crunch") { data.crunch() }
                DSLButton("Ultra Gain 1") { data.od1() }
                DSLButton("Ultra Gain 2") { data.od2() }
            }
            Section(header: Text("FX Loop")) {
                DSLButton("On") { data.fxLoopOn() }
                DSLButton("Off") { data.fxLoopOff() }
                DSLButton("Toggle") { data.toggleFXLoop() }
            }
            Section(header: Text("Master")) {
                DSLButton("Master 1") { data.master1() }
                DSLButton("Master 2") { data.master2() }
                DSLButton("Toggle") { data.toggleMaster() }
            }
            Section(header: Text("Settings")) {
                Stepper(
                    value: $data.midiChannel,
                    in: 0...15,
                    label: { Text("MIDI Channel: \(data.midiChannel + 1)") })
                if $data.midiOuts.isEmpty {
                    Text("No MIDI outputs found!")
                } else {
                    ForEach($data.midiOuts, id: \.self, content: { out in
                        Toggle(out.name.wrappedValue, isOn: out.isOn)
                    })
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
