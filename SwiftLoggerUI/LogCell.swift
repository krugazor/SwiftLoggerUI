//
//  LogCell.swift
//  SwiftLoggerUI
//
//  Created by Zino on 11/10/2020.
//

import SwiftUI
import SwiftLoggerCommon
#if os(macOS)
import AppKit // because swiftui can't give me text size :(
#else
import UIKit
typealias NSImage = UIImage
typealias NSFont = UIFont
#endif
func cellForLog(_ data: LoggerData) -> some View {
    Group {
        if data.logText != nil {
            TextLogCell(data: data)
        } else if let imgdata = data.logData, let _ = NSImage(data: imgdata) {
            ImageLogCell(data: data)
        } else if let _ = data.logData {
            DataLogCell(data: data)
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
                Text((data.sourceFile.lastPathComponent ?? "file?") + ":\(data.lineNumber)")
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
                    .allowsTightening(true)
                    .minimumScaleFactor(0.5)
                    .frame(alignment: .leading)
                Text(data.logText!)
                    .font(.footnote)
                    .minimumScaleFactor(0.5)
                    .lineLimit(nil)
                Spacer()
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
                Text((data.sourceFile.lastPathComponent ?? "file?") + ":\(data.lineNumber)")
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
                    .allowsTightening(true)
                    .minimumScaleFactor(0.5)
                  .frame(alignment: .leading)
                Spacer()
                Image(nsImage: NSImage(data: data.logData!)!)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 200, idealWidth: 240, maxWidth: 800, minHeight: 240, idealHeight: 240, maxHeight: 800, alignment: .center)
                    .onTapGesture(count: 2, perform: {
                        print("tapped")
                    })
            }
        }
    }
    
}

struct DataLogCell: View {
    var data : LoggerData
    
    func printableData(_ bytesPerRow: Int) -> String {
        guard let data = data.logData else { return "NO DATA" }
        
        var output = ""
        var rowWidth = 0
        var firstItem = true
        for idx in 0..<data.count {
            if rowWidth == bytesPerRow {
                output += "\n"
                rowWidth = 0
                firstItem = true
            }
            if !firstItem {
                output += " "
            } else {
                firstItem = !firstItem
            }
            output += String(format: "%02hhX", data[idx] )
            rowWidth += 1
        }
        
        return output
    }
    
    func maxWidth(_ width: CGFloat) -> Int {
        var textSize = 8
        var text = printableData(textSize)
        while (text as NSString).size(withAttributes: [
                                        .font: NSFont(name: "Courier", size: 12)
        ]).width < width {
            textSize += 8
            text = printableData(textSize)
        }
        
        return textSize - 8
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(data.function)
                    .bold()
                Text((data.sourceFile.lastPathComponent ?? "file?") + ":\(data.lineNumber)")
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
                    .allowsTightening(true)
                    .minimumScaleFactor(0.5)
                   .frame(alignment: .leading)
                GeometryReader { geom in
                    let text = printableData(maxWidth(geom.size.width))
                    Text(text)
                        .font(Font.custom("Courier", size: 12))
                        .allowsTightening(true)
                        .minimumScaleFactor(0.5)
                      .lineLimit(nil)
                }
                Spacer()
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
            cellForLog(LoggerData(appName: "Test", logType: .INFO, logTarget: .both, sourceFile: #file, lineNumber: #line, function: #function, logData: "This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. This is a test log. ".data(using: .utf8)!, dataExtension: nil))
        }
    }
}

extension String {
    var lastPathComponent: String? {
        return URL(string: self)?.lastPathComponent
    }
}
