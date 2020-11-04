//
//  FriendsDataStream.swift
//  printfulTask
//
//  Created by Hardijs on 02/11/2020.
//

import Foundation


fileprivate enum FriendsStreamCommand: String {
    case UPDATE
    case USERLIST
}
class FriendsDataStream: NSObject {
    
    weak var delegate: FriendsDataListener?
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    private let maxBufferSize = 2048
    
    func connect(address: String = "ios-test.printful.lv", port: UInt32 = 6111) {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           address as CFString,
                                           port,
                                           &readStream,
                                           &writeStream)
        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: RunLoop.Mode.common)
        outputStream.schedule(in: .current, forMode: RunLoop.Mode.common)
        
        inputStream.open()
        outputStream.open()
    }
    
    func authorize(email: String = "hardijs.kirsis@gmail.com") {
        let authMessage = "AUTHORIZE \(email) \n"
        Logger.debug("Sending Authorization data: \(authMessage)")
        outputStream.write(authMessage, maxLength: authMessage.utf8.count)
    }
    
    func disconnect() {
        inputStream.close()
        outputStream.close()
    }
    
    deinit {
        disconnect()
    }
    
    private func readReceivedData() {
        let data = Data(readingFromInputStream: inputStream, maxBufferSize: maxBufferSize)
        guard let utf8String = String(data: data, encoding: .utf8) else {
            Logger.err("Could not create utf8String from sent server data!")
            return
        }
        let commands = utf8String.components(separatedBy: "\n").filter {!$0.isEmpty}
        commands.forEach { (command) in
            if command.starts(with: FriendsStreamCommand.UPDATE.rawValue) {
                if let update = createFriendLocationUpdate(from: command) {
                    delegate?.friendLocationChanged(update: update)
                }
            } else if command.starts(with: FriendsStreamCommand.USERLIST.rawValue) {
                let friendsList = createFriendList(from: command)
                delegate?.friendsListChanged(friends: friendsList)
            } else {
                Logger.warn("Friends data interpreter could not intepret data")
            }
        }
    }
    
    private func createFriendList(from command: String) -> [Friend] {
        Logger.debug("USERLIST command recieved:", command)
        let friendsStringArr = command.dropFirst(FriendsStreamCommand.USERLIST.rawValue.count + 1).split(separator: ";")
        var friends: [Friend] = []
        
        for friendDataString in friendsStringArr {
            let friendsAttrArr = friendDataString.split(separator: ",")
            let userId = String(friendsAttrArr[0])
            let fullName = String(friendsAttrArr[1])
            let imageUrl = String(friendsAttrArr[2])
            guard
                let latitude = Double(friendsAttrArr[3]),
                let longitude = Double(friendsAttrArr[4]) else {
                Logger.err("Could not decode friend location!")
                continue
            }
            friends.append(Friend(id: userId, name: fullName, imageUrl: imageUrl, latitude: latitude, longitude: longitude))
        }
        
        return friends
    }
    
    func createFriendLocationUpdate(from command: String) -> FriendUpdate? {
        Logger.debug("UPDATE command recieved:", command)
        let friendUpdateString = command.dropFirst(FriendsStreamCommand.UPDATE.rawValue.count + 1)
        let newValueArr = friendUpdateString.split(separator: ",")
        let userId = String(newValueArr[0])
        if let latitude = Double(newValueArr[1]),
           let longitude = Double(newValueArr[2]) {
            return FriendUpdate(friendID: userId, latitude: latitude, longitude: longitude)
        } else {
            Logger.err("Could not parse user update data!")
            return nil
        }
    }
}

// MARK: Extensions
extension FriendsDataStream: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            Logger.debug("Received data")
            readReceivedData()
        default:
            Logger.warn("Unknown stream event received: \(eventCode.rawValue)")
            break
        }
    }
}
