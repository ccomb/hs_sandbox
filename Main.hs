{-# LANGUAGE OverloadedStrings #-}
import Network.Wai
import Network.HTTP.Types
import Network.Wai.Handler.Warp (run)
import qualified Data.ByteString.Lazy.Char8 as C (putStrLn)
import Data.ByteString.Char8 (unpack)
import qualified Data.ByteString as BS (take)


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
    C.putStrLn "Listening on localhost:8080"
    run 8080 app
