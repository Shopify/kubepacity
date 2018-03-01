{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}
module Objects
        ( Pod(..)
        , Container(..)
        ) where

import Data.Text (Text)
import Data.Aeson
import Control.Monad (forM)
import Control.Applicative (optional)

data Pod = Pod
  { name       :: Text
  , containers :: [Container]
  } deriving (Show, Eq)

data Container = Container
  { cname      :: Text
  , cpuRequest :: Maybe Text
  , memRequest :: Maybe Text
  } deriving (Show, Eq)

instance FromJSON Pod where
  parseJSON = withObject "pod" $ \o -> do
    metadata <- o        .: "metadata"
    name     <- metadata .: "name"

    spec       <- o    .: "spec"
    containers <- spec .: "containers"

    cnames <- forM containers $ \container -> do
      cname      <- container .: "name"

      cpuRequest <- optional (container .: "resources") >>= \case
        Nothing        -> return Nothing
        Just resources ->
          optional (resources .: "requests") >>= \case
            Nothing       -> return Nothing
            Just requests -> optional (requests .: "cpu")

      memoryRequest <- optional (container .: "resources") >>= \case
        Nothing        -> return Nothing
        Just resources ->
          optional (resources .: "requests") >>= \case
            Nothing       -> return Nothing
            Just requests -> optional (requests .: "memory")

      return (Container cname cpuRequest memoryRequest)

    return (Pod name cnames)
