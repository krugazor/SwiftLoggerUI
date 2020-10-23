//
//  SwiftLoggeriOSApp.swift
//  SwiftLoggeriOS
//
//  Created by Nicolas Zinovieff on 10/23/20.
//

import SwiftUI

@main
struct SwiftLoggeriOSApp: App {
    var body: some Scene {
        WindowGroup {
            let sdata = ServerData(name: "Test")
            ContentView().environmentObject(sdata)
        }
    }
}
