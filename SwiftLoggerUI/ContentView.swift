//
//  ContentView.swift
//  SwiftLoggerUI
//
//  Created by Zino on 11/10/2020.
//

import SwiftUI
import SwiftLoggerCommon
import Introspect
import Combine

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

enum LoggerTypeFilter : String, CaseIterable, Identifiable {
    case ALL
    case DEBUG
    case INFO
    case WARNING
    case ERROR
    
    var id: String { self.rawValue }
    
    func matches(_ ldt: LoggerData.LoggerType) -> Bool {
        switch self {
        case .ALL:
            return true
        case .DEBUG:
            return true
        case .INFO:
            if ldt != .DEBUG { return true }
            else { return false }
        case .WARNING:
            if ldt == .WARNING || ldt == .ERROR { return true }
            else { return false }
        case .ERROR:
            if ldt == .ERROR { return true }
            else { return false }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var server : ServerData
    #if os(macOS)
    @State var scrollView : NSScrollView?
    #else
    @State var scrollView : UIScrollView?
    #endif
    @State var selectedLevel = LoggerTypeFilter.ALL
    @State var sink : AnyCancellable? // for garbage collection
    
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
            HStack {
                Picker("Level", selection: $selectedLevel) {
                    Text("All").tag(LoggerTypeFilter.ALL)
                    Text("Debug").tag(LoggerTypeFilter.DEBUG)
                    Text("Info").tag(LoggerTypeFilter.INFO)
                    Text("Warning").tag(LoggerTypeFilter.WARNING)
                    Text("Error").tag(LoggerTypeFilter.ERROR)
                }
                Text("and above")
                Spacer()
            }
            ScrollView(.vertical) {
                ForEach(server.logs) { item in
                    if selectedLevel.matches(item.logType) {
                        cellForLog(item)
                            .padding()
                            .border(Color.secondary, width: 1)
                    }
                }
            }
        }.frame(minWidth: 240, idealWidth: 600, maxWidth: 1200, minHeight: 240, idealHeight: 600, maxHeight: .infinity, alignment: .center)
        .introspectScrollView { isv in
            if self.scrollView == nil {
                self.scrollView = isv
                self.sink = server.$logs.sink { _ in
                    #if os(macOS)
                    self.scrollView?.contentView.scroll(NSPoint(x: 0, y: Int.max))
                    #else
                    self.scrollView?.scrollsToBottom(animated: true)
                    #endif
                }
            }
        }
        .onDisappear {
            server.router = nil
            server.connection = false
            sink = nil
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
                                                        LoggerData(appName: "Test", logType: .INFO, logTarget: .both, sourceFile: #file, lineNumber: #line, function: #function, logData: "This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. ".data(using: .utf8)!, dataExtension: nil),
                                                    ]
        ))
    }
}
