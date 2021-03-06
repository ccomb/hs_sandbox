{-# LANGUAGE OverloadedStrings #-}
import Network.Wai (Response, Application, responseLBS, responseFile, rawPathInfo)
import Network.HTTP.Types (status404, status200)
import Network.Wai.Handler.Warp (run)
import Data.ByteString.Char8 (unpack)
import qualified Data.ByteString as BS (take)
import Action
import Data.UUID.V4 (nextRandom)
import Data.Time (getCurrentTime)


port :: Int
port = 8080


websocket :: Response
websocket = responseLBS status200 [] "websocket"

-- dispatch $ Action getCurrentTime (show nextRandom) "Entity" Create "truc"

notFound :: Response
notFound = responseLBS status404 [] "404 Not Found"


serveFile :: FilePath -> Response
serveFile filename =
    responseFile
    status200 
    []
    ("../elm" ++ filename)
    Nothing


storefile :: String
storefile = "store.db"

action :: Action
action = Action Nothing Nothing Create Resource (Payload "truc")

app :: Application
app request respond = do
    response <- let
        path = rawPathInfo request
        prefix = BS.take 7 path
        in case prefix of
            "/" -> return $ serveFile "/index.html"
            "/ws" -> do
                uuid <- fmap show nextRandom
                time <- getCurrentTime
                dispatch (FileEventStore storefile) action time uuid
                return websocket
            "/static" -> return $ serveFile $ unpack path
            _ -> return notFound
    respond response


main :: IO ()
main = do
    putStrLn $ "Listening on localhost:" ++ show port
    run port app
