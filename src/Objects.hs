module Objects
        ( Pod(..)
        , Container(..)
        ) where

import Data.Text (Text)

data Pod = Pod
  { name       :: Text
  , containers :: [Container]
  } deriving (Show, Eq)

data Container = Container
  { cname      :: Text
  , cpuRequest :: Text
  , memRequest :: Text
  } deriving (Show, Eq)
