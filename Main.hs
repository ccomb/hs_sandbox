{-# LANGUAGE OverloadedStrings #-}
import Network.Wai
import Network.HTTP.Types
import Network.Wai.Handler.Warp (run)
import qualified Data.ByteString.Lazy.Char8 as C (putStrLn)
import Data.ByteString.Char8 (unpack)


websocket :: Response
websocket = responseLBS status200 [] "websocket"


notFound :: Response
notFound = responseLBS status404 [] "40404"


serveFile :: FilePath -> Response
serveFile filename =
    responseFile
    status200 
    []
    ("../elm/" ++ filename)
    Nothing


app :: Application
app request respond =
    respond $ case rawPathInfo request of
        "/" -> serveFile "index.html"
        "/ws" -> websocket
        _ -> serveFile $ unpack $ rawPathInfo request


main :: IO ()
main = do
    C.putStrLn "Listening on localhost:8080"
    run 8080 app
