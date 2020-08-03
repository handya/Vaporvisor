import Vapor
import XMLCoder

public struct Vaporvisor {

    public static func getProcessInfo(_ req: Request) throws -> Future<[ProcessInfo]> {
        let body = XMLRPCBody(methodName: "supervisor.getAllProcessInfo")

        let client = try req.make(Client.self)
        return client.post("http://localhost:9001/RPC2") { try $0.content.encode(body, using: XMLEncoder()) }
            .flatMap { try $0.content.decode(MethodResponse.self, using: XMLDecoder()) }
            .map { self.responseProcecssInfo($0) }
    }

    private static func responseProcecssInfo(_ response: MethodResponse) -> [ProcessInfo] {
        let valueElements = response.params.param.value.array.data.value
        return valueElements.map { .init(members: $0.valueStruct.member) }
    }
}

// MARK: - Models

public extension Vaporvisor {
    struct XMLRPCBody: Codable {
        let methodName: String
    }

    enum State: Int, Codable {
        /// The process has been stopped due to a stop request or has never been started.
        case stopped = 0

        /// The process is starting due to a start request.
        case starting =  10

        /// The process is running.
        case running = 20

        /// The process entered the `starting` state but subsequently exited too quickly to move to the `running` state.
        case backoff = 30

        /// The process is stopping due to a stop request.
        case stopping = 40

        /// The process exited from the `running` state (expectedly or unexpectedly).
        case exited = 100

        /// The process could not be started successfully.
        case fatal = 200

        /// The process is in an unknown state (supervisord programming error).
        case unknown = 1000
    }

    struct ProcessInfo: Content {
        public let name: String?
        public let group: String?
        public let start: Int?
        public let stop: Int?
        public let now: Int?
        public let state: State?
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
            self.state = State(rawValue: members.first(where: { $0.name == "state" })?.value.intValue ?? 1000)
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
}

// MARK: - XML Child Models

public extension Vaporvisor {
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
}
