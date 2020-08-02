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
