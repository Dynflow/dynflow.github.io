@startuml

participant "Connector" as ClientConnector
participant "Connector" as ExecutorConnector

box "Client World"
  participant Client
  participant "Client Dispatcher"
  participant "ClientConnector"
end box

box "Executor World"
  participant "ExecutorConnector"
  participant "Executor Dispatcher"
  participant Executor
end box

autonumber
Client -> "Client Dispatcher" : publish_request\nexecution_plan_id
"Client Dispatcher" --> Client : IVar
"Client Dispatcher" -> "ClientConnector" : send\nEnvelope[Execution]
"ClientConnector" -> "ExecutorConnector" : handle_envelope\nEnvelope[Execution]
"ExecutorConnector" -> "Executor Dispatcher" : handle_request\nEnvelope[Execution]
"Executor Dispatcher" -> Executor : execute\nexecution_plan_id
note over Executor: executing…
activate Executor
"Executor Dispatcher" -> ExecutorConnector : send\nEnvelope[Accepted]
"ExecutorConnector" -> "ClientConnector" : handle_envelope\nEnvelope[Accepted]
"ClientConnector" -> "Client Dispatcher" : dispatch_response\nEnvelope[Accepted]
Executor -> "Executor Dispatcher" : finished
deactivate Executor
"Executor Dispatcher" -> ExecutorConnector : send\nEnvelope[Finished]
"ExecutorConnector" -> "ClientConnector" : handle_envelope\nEnvelope[Finished]
"ClientConnector" -> "Client Dispatcher" : dispatch_response\nEnvelope[Finished]
note over "Client Dispatcher": IVar fullfilled

@enduml
