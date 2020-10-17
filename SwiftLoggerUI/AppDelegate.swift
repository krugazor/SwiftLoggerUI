//
//  AppDelegate.swift
//  SwiftLoggerUI
//
//  Created by Zino on 11/10/2020.
//

import Cocoa
import SwiftUI
import Darwin
import SwiftLoggerCommon

var windows : [SLWindow] = []

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let sdata = ServerData(name: "Test")
        let contentView = ContentView().environmentObject(sdata)
        
        // Create the window and set the content view.
        let window = SLWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.setFrameAutosaveName("Log")
        window.center()
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        window.environmentObject = sdata
        windows.append(window)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func newWindow(_ sender: Any?) {
        let sdata = ServerData(name: "Test")
        let contentView = ContentView().environmentObject(sdata)
        
        // Create the window and set the content view.
        let window = SLWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.setFrameAutosaveName("Log")
        window.center()
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        window.environmentObject = sdata
        windows.append(window)
    }
}

// MARK: -

extension NSBitmapImageRep {
    var png: Data? {
        return representation(using: .png, properties: [:])
    }
}
extension Data {
    var bitmap: NSBitmapImageRep? {
        return NSBitmapImageRep(data: self)
    }
}
extension NSImage {
    var png: Data? {
        return tiffRepresentation?.bitmap?.png
    }
}

extension Double {
    func toByteArray() -> [UInt8] {
        var value = self
        return withUnsafeBytes(of: &value) { Array($0) }
    }
    
    var asUUID : UUID {
        // aka (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
        let bytes = self.toByteArray()
        let b0 = (bytes.count > 0) ? bytes[0] : 0
        let b1 = (bytes.count > 1) ? bytes[1] : 0
        let b2 = (bytes.count > 2) ? bytes[2] : 0
        let b3 = (bytes.count > 3) ? bytes[3] : 0
        let b4 = (bytes.count > 4) ? bytes[4] : 0
        let b5 = (bytes.count > 5) ? bytes[5] : 0
        let b6 = (bytes.count > 6) ? bytes[6] : 0
        let b7 = (bytes.count > 7) ? bytes[7] : 0
        let b8 = (bytes.count > 8) ? bytes[8] : 0
        let b9 = (bytes.count > 9) ? bytes[9] : 0
        let b10 = (bytes.count > 10) ? bytes[10] : 0
        let b11 = (bytes.count > 11) ? bytes[11] : 0
        let b12 = (bytes.count > 12) ? bytes[12] : 0
        let b13 = (bytes.count > 13) ? bytes[13] : 0
        let b14 = (bytes.count > 14) ? bytes[14] : 0
        let b15 = (bytes.count > 15) ? bytes[15] : 0
        return UUID(uuid: (
            b0,
            b1,
            b2,
            b3,
            b4,
            b5,
            b6,
            b7,
            b8,
            b9,
            b10,
            b11,
            b12,
            b13,
            b14,
            b15
        ))
    }
}

// MARK: -
// Because SwiftUI doesn't call any deallocator, the bonjour stuff remains active

class SLWindow : NSWindow, NSWindowDelegate {
    var environmentObject : ServerData?
    var intermediateDelegate : NSWindowDelegate?
    let id = UUID()
    
    override var delegate: NSWindowDelegate? {
        get {
            return intermediateDelegate
        }
        set {
            if newValue == nil {
                intermediateDelegate = nil
            } else if !(newValue?.isEqual(self) ?? false) {
                intermediateDelegate = newValue
                super.delegate = self
            }
        }
    }
    
    func windowWillClose(_ notification: Notification) {
        environmentObject?.connection = false
        environmentObject?.router?.cleanup()
        environmentObject?.router = nil
        
        windows.removeAll(where: {
            $0 == self
        })
    }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        super.delegate = self
    }
}
