{-# LANGUAGE OverloadedStrings #-}
import Network.Wai
import Network.HTTP.Types
import Network.Wai.Handler.Warp (run)
import qualified Data.ByteString.Lazy as BS
import qualified Data.ByteString.Lazy.Char8


content :: BS.ByteString
content = "Hello World"

app :: Application
app _ respond = do
    putStrLn "Request received"
    respond $ responseLBS status200 [] content


main :: IO ()
main = do
    putStrLn $ "Listening on localhost:8080"
    run 8080 app
