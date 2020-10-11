//
//  LogCell.swift
//  SwiftLoggerUI
//
//  Created by Zino on 11/10/2020.
//

import SwiftUI
import SwiftLoggerCommon

func cellForLog(_ data: LoggerData) -> some View {
    Group {
        if data.logText != nil {
            TextLogCell(data: data)
        } else if let imgdata = data.logData, let _ = NSImage(data: imgdata) {
            ImageLogCell(data: data)
        } else {
            TextLogCell(data: LoggerData(appName: "SwiftLoggerUI",
                                         logType: .WARNING, logTarget: .both, sourceFile: "LogCell", lineNumber: #line, function: #function, logText: "Cannot display this log"))
        }
    }
}

struct TextLogCell: View {
    var data : LoggerData
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(data.function)
                    .bold()
                Text(data.sourceFile + ":\(data.lineNumber)")
                    .italic()
                    .truncationMode(.head)
            }
            HStack {
                Text(data.logType.rawValue)
                    .foregroundColor(
                        data.logType == .ERROR ? .red :
                            data.logType == .WARNING ? .orange :
                            data.logType == .INFO ? .yellow :
                            nil
                    )
                    .frame(alignment: .leading)
                Spacer()
               Text(data.logText!)
                    .font(.footnote)
                    .lineLimit(nil)   
            }
        }
    }
}

struct ImageLogCell: View {
    var data : LoggerData
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(data.function)
                    .bold()
                Text(data.sourceFile + ":\(data.lineNumber)")
                    .italic()
                    .truncationMode(.head)
            }
            HStack {
                Text(data.logType.rawValue)
                    .foregroundColor(
                        data.logType == .ERROR ? .red :
                            data.logType == .WARNING ? .orange :
                            data.logType == .INFO ? .yellow :
                            nil)
                    .frame(alignment: .leading)
                Spacer()
                Image(nsImage: NSImage(data: data.logData!)!)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 240, idealWidth: 240, maxWidth: 800, minHeight: 240, idealHeight: 240, maxHeight: 800, alignment: .center)
                    .onTapGesture(count: 2, perform: {
                        print("tapped")
                    })
            }
        }
    }
    
}

struct LogCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let image = NSImage(named: "screenshot-terminal")
            
            cellForLog(LoggerData(appName: "Test", logType: .INFO, logTarget: .both, sourceFile: #file, lineNumber: #line, function: #function, logText: "This is a test log. "))
            cellForLog(LoggerData(appName: "Test", logType: .INFO, logTarget: .both, sourceFile: #file, lineNumber: #line, function: #function, logData: (image?.png!)!, dataExtension: "png"))
        }
    }
}
