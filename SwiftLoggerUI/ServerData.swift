import Foundation
import Combine
import SwiftLoggerCommon
import SwiftLoggerRouterBase
#if os(macOS)
import SwiftLoggerRouter
#else
import SwiftLoggerRouterNetwork
#endif
import Network

class ServerData : ObservableObject, LoggerRouterDelegate, PeerConnectionDelegate {
    @Published var name : String {
        didSet {
            setupRouter()
        }
    }
    @Published var passcode : String {
        didSet {
            setupRouter()
        }
    }
    @Published var connection : Bool = false
    @Published var logs : [LoggerData]
    var router : LoggerRouter?
    
    func setupRouter() {
        let p = passcode.isEmpty ? LoggerData.defaultPasscode : passcode
        #if os(macOS)
        router = LoggerRouter.networkLoggerRouter(name: name,
                                                  passcode: p,
                                                  delegate: self,
                                                  dataDir: nil,
                                                  logToFile: false,
                                                  logToUI: false)
        #else
        router = NetworkLoggerRouter(name: name,
                                     passcode: p,
                                     delegate: self,
                                     dataDir: nil,
                                     logToFile: false,
                                     logToUI: false)
        #endif
        router?.addLogger(self)
    }
    
    init(name n: String, passcode p: String? = nil, logs items: [LoggerData] = []) {
        name = n
        passcode = p != nil ? p! : LoggerData.defaultPasscode
        logs = items
        setupRouter()
    }
    
    deinit {
        self.router = nil
    }
    
    var writesToFile: Bool { return false }
    
    func logMessage(_ message: LoggerData) throws {
        DispatchQueue.main.async {
            self.logs.append(message)
        }
    }

    func connectionReady(_ conn: PeerConnection) {
        DispatchQueue.main.async {
            self.connection = true
        }
    }
    
    func connectionFailed(_ conn: PeerConnection) {
        DispatchQueue.main.async {
            self.connection = false
        }
    }
    
    func receivedMessage(_ conn: PeerConnection, content: Data?, message: NWProtocolFramer.Message) {
        DispatchQueue.main.async {
            self.connection = true
        }
    }
    
    func displayAdvertiseError(_ error: NWError) {
        DispatchQueue.main.async {
            self.connection = false
        }
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
