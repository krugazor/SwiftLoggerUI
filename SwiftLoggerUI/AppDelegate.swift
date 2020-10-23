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
