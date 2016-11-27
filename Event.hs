module Event where
import Data.Time (UTCTime)
import Agent (Agent, AgentType)
import Resource (Resource, ResourceType)


data EventKind = Increment | Decrement


data EventType =
    EventType
    { eventTypeName :: String
    , eventTypeKind :: EventKind
    , eventTypeProvider :: AgentType
    , eventTypeReceiver :: AgentType
    , eventTypeResourceType :: ResourceType
    }


data EventGroup =
    EventGroup
    { eventGroupName :: String
    , eventGroupGroups :: EventGroup }


data Event =
    Event
    { eventName :: String
    , eventType :: EventType
    , eventGroups :: EventGroup
    , eventDate :: UTCTime
    , eventQuantity :: Rational
    , eventResourceType :: ResourceType
    , eventResource :: Resource
    , eventProvider :: Agent
    , eventReceiver :: Agent
    , eventInflow :: Resource
    , eventOutflow :: Resource}
