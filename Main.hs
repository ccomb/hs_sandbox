{-# LANGUAGE OverloadedStrings #-}
import Network.Wai (Response, Application, responseLBS, responseFile, rawPathInfo)
import Network.HTTP.Types (status404, status200)
import Network.Wai.Handler.Warp (run)
import Data.ByteString.Char8 (pack, unpack)
import qualified Data.ByteString as BS (take)


port :: Int
port = 8080


websocket :: Response
websocket = responseLBS status200 [] "websocket"


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
app request respond =
    respond $ case prefix of
        "/" -> serveFile "/index.html"
        "/ws" -> websocket
        "/static" -> serveFile $ unpack path
        _ -> notFound
        where
            path = rawPathInfo request
            prefix = BS.take 7 path


main :: IO ()
main = do
    putStrLn $ "Listening on localhost:" ++ show port
    run port app
