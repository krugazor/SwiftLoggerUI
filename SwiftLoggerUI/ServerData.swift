import Foundation
import Combine
import SwiftLoggerCommon
import SwiftLoggerRouter
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
        router = LoggerRouter.networkLoggerRouter(name: name,
                                                  passcode: p,
                                                  delegate: self,
                                                  dataDir: nil,
                                                  logToFile: false,
                                                  logToUI: false)
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
