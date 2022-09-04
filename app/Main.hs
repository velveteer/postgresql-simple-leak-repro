module Main where

import Control.Exception (bracket)
import Control.Concurrent (threadDelay)
import Control.Concurrent.Async (race)
import qualified Database.Postgres.Temp as PGT
import qualified Database.PostgreSQL.Simple as PG
import qualified Database.PostgreSQL.Simple.Notification as PG

main :: IO ()
main = do
  _ <- PGT.with $ \db -> bracket
    (PG.connectPostgreSQL (PGT.toConnectionString db))
    PG.close
    loop
  pure ()
  where
    loop conn = do
      _ <- race (threadDelay 100000) (PG.getNotification conn)
      loop conn
