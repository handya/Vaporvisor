//
//  XMLCoder+Vaporvisor.swift
//  
//
//  Created by Andrew Farquharson on 30/07/20.
//

import Vapor
import XMLCoder

extension XMLEncoder: HTTPMessageEncoder {
    public func encode<E, M>(_ encodable: E, to message: inout M, on worker: Worker) throws where E : Encodable, M : HTTPMessage {
        message.contentType = .textXml
        message.body = try HTTPBody(data: self.encode(encodable, withRootKey: "methodCall", rootAttributes: nil, header: .init(version: 1)))
    }
}

extension XMLDecoder: HTTPMessageDecoder {
    public func decode<D, M>(_ decodable: D.Type, from message: M, maxSize: Int, on worker: Worker) throws -> EventLoopFuture<D> where D : Decodable, M : HTTPMessage {
        guard message.contentType == .textXml else {
            throw HTTPError(identifier: "contentType", reason: "HTTP message did not have text/xml content-type.")
        }
        return message.body.consumeData(max: maxSize, on: worker).map(to: D.self) { data in
            return try self.decode(D.self, from: data)
        }
    }
}

extension MediaType {
    public static let textXml = MediaType(type: "text", subType: "xml", parameters: ["charset": "utf-8"])
}
