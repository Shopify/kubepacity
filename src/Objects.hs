{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}
{-# LANGUAGE LambdaCase #-}
module Objects
        ( Pod(..)
        , Container(..)
        ) where

import Data.Text (Text)
import Data.Aeson
import Control.Monad (forM)
import Control.Applicative (optional)

import GHC.Generics

data Pod = Pod
  { name       :: Text
  , containers :: [Container]
  } deriving (Show, Eq, Generic)

data Container = Container
  { cname      :: Text
  , requests   :: Maybe Request
  } deriving (Show, Eq, Generic)

data Request = Request
  { cpu :: Maybe Text
  , memory :: Maybe Text
  } deriving (Show, Eq, Generic)

instance FromJSON Pod
instance FromJSON Container
instance FromJSON Request
