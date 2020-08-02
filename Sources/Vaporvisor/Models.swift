//
//  Models.swift
//  
//
//  Created by Andrew Farquharson on 30/07/20.
//

import Vapor

struct XMLRPCBody: Codable {
    let methodName: String
}

// MARK: - MethodResponse
struct MethodResponse: Codable {
    let params: Params
}

// MARK: - Params
struct Params: Codable {
    let param: Param
}

// MARK: - Param
struct Param: Codable {
    let value: ParamValue
}

// MARK: - ParamValue
struct ParamValue: Codable {
    let array: Array
}

// MARK: - Array
struct Array: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let value: [ValueElement]
}

// MARK: - ValueElement
struct ValueElement: Codable {
    let valueStruct: Struct

    enum CodingKeys: String, CodingKey {
        case valueStruct = "struct"
    }
}

// MARK: - Struct
struct Struct: Codable {
    let member: [Member]
}

// MARK: - Member
struct Member: Codable {
    let name: String
    let value: MemberValue
}

// MARK: - MemberValue
struct MemberValue: Codable {
    let string, int: String?

    var intValue: Int? {
        return Int(self.int ?? "")
    }
}

public struct ProcessInfo: Content {
    public let name: String?
    public let group: String?
    public let start: Int?
    public let stop: Int?
    public let now: Int?
    public let state: Int?
    public let statename: String?
    public let spawnerr: String?
    public let exitStatus: Int?
    public let logFile: String?
    public let outLogFile: String?
    public let errorLogFile: String?
    public let pid: Int?
    public let description: String?

    init(members: [Member]) {
        self.name = members.first(where: { $0.name == "name" })?.value.string
        self.group = members.first(where: { $0.name == "group" })?.value.string
        self.start = members.first(where: { $0.name == "start" })?.value.intValue
        self.stop = members.first(where: { $0.name == "stop" })?.value.intValue
        self.now = members.first(where: { $0.name == "now" })?.value.intValue
        self.state = members.first(where: { $0.name == "state" })?.value.intValue
        self.statename = members.first(where: { $0.name == "statename" })?.value.string
        self.spawnerr = members.first(where: { $0.name == "spawnerr" })?.value.string
        self.exitStatus = members.first(where: { $0.name == "exitstatus" })?.value.intValue
        self.logFile = members.first(where: { $0.name == "logfile" })?.value.string
        self.outLogFile = members.first(where: { $0.name == "stdout_logfile" })?.value.string
        self.errorLogFile = members.first(where: { $0.name == "stderr_logfile" })?.value.string
        self.pid = members.first(where: { $0.name == "pid" })?.value.intValue
        self.description = members.first(where: { $0.name == "description" })?.value.string
    }
}
