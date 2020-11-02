//
//  Data.swift
//  printfulTask
//
//  Created by Hardijs on 02/11/2020.
//

import Foundation

extension Data {
    init(readingFromInputStream input: InputStream, maxBufferSize: Int) {
        self.init()
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxBufferSize)
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: maxBufferSize)
            self.append(buffer, count: read)
        }
        buffer.deallocate()
    }
}
