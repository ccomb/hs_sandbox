{-# LANGUAGE DeriveGeneric #-}
module Action where

import Data.Time (UTCTime)
import System.IO ()
import Data.Aeson (encode, ToJSON)
import Data.ByteString.Lazy.Char8 (unpack)
import GHC.Generics
import Data.Maybe ()

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

data EventStore = FileEventStore FilePath | Other

getFile :: EventStore -> FilePath
getFile (FileEventStore f) = f
getFile (Other) = ""

stampAction :: Action -> UTCTime -> String -> Action
stampAction action time uuid = action { actionUuid = Just $ show uuid, actionTime = Just time }

{- todo dispatch actions with pattern matching on the eventstore and the action -}
dispatch :: EventStore -> Action -> UTCTime -> String -> IO ()
dispatch eventstore action time uuid =
    let content = (unpack $ encode $ stampAction action time uuid) ++ "\n"
    in appendFile (getFile eventstore) content


