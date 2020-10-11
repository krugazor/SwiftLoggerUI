//
//  ContentView.swift
//  SwiftLoggerUI
//
//  Created by Zino on 11/10/2020.
//

import SwiftUI
import SwiftLoggerCommon

class DoubleWrapper {
    let value: Double
    init(_ v: Double) {
        value = v
    }
}

extension LoggerData : Identifiable {
    public var id: UUID {
        return self.logDate.timeIntervalSince1970.asUUID
    }
}

struct Wrap: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content.frame(width: geometry.size.width)
        }
    }
}

struct ContentView: View {
    @State var connected = false
    @State var items : [LoggerData]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .fill(connected ? Color.green : Color.red)
                    .frame(width: 16, height: 16, alignment: .center)
                Text("Hello, World!")
            }
            ScrollView(.vertical) {
                ForEach(items) { item in
                    cellForLog(item)
                        .border(Color.secondary, width: 1)
                }
            }
        }.frame(minWidth: 240, idealWidth: 600, maxWidth: 1200, minHeight: 240, idealHeight: 600, maxHeight: .infinity, alignment: .center)
    }
}


struct ContentView_Previews: PreviewProvider {
    static let image = NSImage(named: "screenshot-terminal")
    static var previews: some View {
        ContentView(items:
                        [
                            LoggerData(appName: "Test", logType: .INFO, logTarget: .both, sourceFile: #file, lineNumber: #line, function: #function, logData: (image?.png!)!, dataExtension: "png"),
                            LoggerData(appName: "Test", logType: .INFO, logTarget: .both, sourceFile: #file, lineNumber: #line, function: #function, logText: "This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. "),
                        ]
        )
    }
}
