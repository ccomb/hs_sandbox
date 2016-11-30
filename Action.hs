{-# LANGUAGE DeriveGeneric #-}
module Action where

import Data.UUID (UUID)
import Data.UUID.V4 (nextRandom)
import Data.Time (UTCTime, getCurrentTime)
import System.IO (appendFile)
import Data.Aeson (encode, ToJSON)
import Data.ByteString.Lazy.Char8 (unpack, pack)
import GHC.Generics

data Entity = Resource | Event | Agent

data Type = Create | Delete | Update
    deriving (Generic, Show)

data Action =
    Action
    { actionTime :: UTCTime
    , actionUuid ::  String
    , actionModel :: Model
    , actionType :: Type
    , actionPayload :: Payload
    } deriving (Generic, Show)


instance ToJSON Action
instance ToJSON Payload
instance ToJSON Model
instance ToJSON Type


newtype Model = Model String
    deriving (Generic, Show)

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

{- dispatch actions with pattern matching on the eventstore and the action -}
dispatch :: Action -> IO ()
dispatch action = do
    uuid <- nextRandom
    time <- getCurrentTime
    a <- return action { actionUuid = show uuid, actionTime = time }
    appendFile "store.db" $ unpack $ encode a
