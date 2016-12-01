{-# LANGUAGE OverloadedStrings #-}
import Network.Wai (Response, Application, responseLBS, responseFile, rawPathInfo)
import Network.HTTP.Types (status404, status200)
import Network.Wai.Handler.Warp (run)
import Data.ByteString.Char8 (unpack)
import qualified Data.ByteString as BS (take)
import Action
import Data.UUID.V4 (nextRandom)
import Data.Time (UTCTime, getCurrentTime)


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


app :: Application
app request respond = do
    case prefix of
        "/" -> respond $ serveFile "/index.html"
        "/ws" -> do
            uuid <- fmap show nextRandom
            time <- getCurrentTime
            dispatch (Action Nothing Nothing "Entity" Create (Payload "truc")) time uuid
            respond websocket
        "/static" -> respond $ serveFile $ unpack path
        _ -> respond notFound
        where
            path = rawPathInfo request
            prefix = BS.take 7 path


main :: IO ()
main = do
    putStrLn $ "Listening on localhost:" ++ show port
    run port app
