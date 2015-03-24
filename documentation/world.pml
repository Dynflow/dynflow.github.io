@startuml

actor client

frame "client world" {
  interface adapter as ClientPersistenceAdapter
  interface adapter as ClientCoordinatorAdapter
  interface adapter as ClientConnectorAdapter
  component [coordinator] as ClientCoordinator
  component [persistence] as ClientPersistence
  component [connector] as ClientConnector
  component [client dispatcher] as ClientClientDispatcher
  [ClientCoordinator] -down-> ClientCoordinatorAdapter
  [ClientConnector] -down-> ClientConnectorAdapter
  [ClientPersistence] -down-> ClientPersistenceAdapter
  [ClientClientDispatcher] --> [ClientConnector]
  [ClientClientDispatcher] --> [ClientCoordinator]
  client -down--> [ClientClientDispatcher]
  client -down--> [ClientPersistence]
}

frame "executor world" {
interface adapter as PersistenceAdapter
interface adapter as CoordinatorAdapter
interface adapter as ConnectorAdapter
[coordinator] -up-> CoordinatorAdapter
[connector] -up-> ConnectorAdapter
[persistence] -up-> PersistenceAdapter
[connector] <-- [client dispatcher]
[connector] <-- [executor dispatcher]
[executor] <-- [executor dispatcher]
[coordinator] <-- [client dispatcher]
[coordinator] <-- [executor dispatcher]
[persistence] <-- [executor]
}

database "Database" as Database
ClientPersistenceAdapter -down- Database
Database -down- PersistenceAdapter

node "Synchronization\nservice" as SyncService
ClientCoordinatorAdapter -down- SyncService
SyncService -down- CoordinatorAdapter

node "Message\nbus" as MessageBus
ClientConnectorAdapter -down- MessageBus
MessageBus -down- ConnectorAdapter

@enduml
