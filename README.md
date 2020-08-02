# Vaporvisor
![test](https://github.com/handya/Vaporvisor/workflows/test/badge.svg) ![SwiftLint](https://github.com/handya/Vaporvisor/workflows/SwiftLint/badge.svg)

A Vapor API for getting [All Process Info](http://supervisord.org/api.html#supervisor.rpcinterface.SupervisorNamespaceRPCInterface.getAllProcessInfo) from [Supervisor](http://supervisord.org/introduction.html). This is usefull if you are using supervisor and Vapor together.


### Example
```swift
func getProcessInfo(_ req: Request) throws -> Future<[ProcessInfo]> {
    return try Vaporvisor.getProcessInfo(req)
}
```


### Dependencies

[XMLCoder](https://github.com/MaxDesiatov/XMLCoder) - 
Encoder & Decoder for XML using Swift's Codable protocols.

[Vapor](https://github.com/vapor/vapor) - This version currently only supports Vapor 3
