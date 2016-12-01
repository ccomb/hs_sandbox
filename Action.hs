{-# LANGUAGE DeriveGeneric #-}
module Action where

import Data.UUID (UUID)
import Data.UUID.V4 (nextRandom)
import Data.Time (UTCTime, getCurrentTime)
import System.IO (appendFile)
import Data.Aeson (encode, ToJSON)
import Data.ByteString.Lazy.Char8 (unpack, pack)
import GHC.Generics
import Data.Maybe

data Entity =
      Resource
    | Event
    | Agent
    deriving (Generic, Show)

data Type = Create | Delete | Update
    deriving (Generic, Show)

data Action =
    Action
    { actionTime :: Maybe UTCTime
    , actionUuid ::  Maybe String
    , actionType :: Type
    , actionModel :: Entity
    , actionPayload :: Payload
    } deriving (Generic, Show)


instance ToJSON Action
instance ToJSON Payload
instance ToJSON Type
instance ToJSON Entity

data Payload = Payload String
    deriving (Generic, Show)

data EventStoreType = ApendOnlyFile | Other

data EventStore =
    EventStore
    { eventStoreName :: String
    , eventStoreType :: EventStoreType
    }

{- store :: String -> 
store dbname = -}

stampAction :: Action -> UTCTime -> String -> Action
stampAction action time uuid = action { actionUuid = Just $ show uuid, actionTime = Just time }

{- dispatch actions with pattern matching on the eventstore and the action -}
dispatch :: Action -> UTCTime -> String -> IO ()
dispatch action time uuid =
    let content = (unpack $ encode $ stampAction action time uuid) ++ "\n"
        in appendFile "store.db" content


