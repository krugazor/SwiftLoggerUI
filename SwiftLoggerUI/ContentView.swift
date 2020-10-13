//
//  ContentView.swift
//  SwiftLoggerUI
//
//  Created by Zino on 11/10/2020.
//

import SwiftUI
import SwiftLoggerCommon
import Introspect

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
    @EnvironmentObject var server : ServerData
    @State var scrollView : NSScrollView?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Circle()
                    .fill(server.connection ? Color.green : Color.red)
                    .frame(width: 16, height: 16, alignment: .center)
                    .padding(4)
                TextField("Server name", text: $server.name)
                    .padding(4)
                TextField("Server passcode(empty for default)", text: $server.passcode)
                    .padding(4)
            }
            ScrollView(.vertical) {
                ForEach(server.logs) { item in
                    cellForLog(item)
                        .padding()
                        .border(Color.secondary, width: 1)
                }
            }
        }.frame(minWidth: 240, idealWidth: 600, maxWidth: 1200, minHeight: 240, idealHeight: 600, maxHeight: .infinity, alignment: .center)
        .introspectScrollView { isv in
            if self.scrollView == nil {
                self.scrollView = isv
                server.$logs.sink { _ in
                    self.scrollView?.scroll(NSPoint(x: 0, y: Int.max))
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static let image = NSImage(named: "screenshot-terminal")
    static var previews: some View {
        ContentView().environmentObject(ServerData(name: "Test", logs:
                        [
                            LoggerData(appName: "Test", logType: .INFO, logTarget: .both, sourceFile: #file, lineNumber: #line, function: #function, logData: (image?.png!)!, dataExtension: "png"),
                            LoggerData(appName: "Test", logType: .INFO, logTarget: .both, sourceFile: #file, lineNumber: #line, function: #function, logText: "This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. "),
                        ]
        ))
    }
}
