{-# LANGUAGE OverloadedStrings #-}
module Kube
        ( getNodeNames
        , getPods
        , Context(..)
        , NodeName(..)
        ) where

import Turtle
import qualified Data.Text as Text (words)

newtype Context  = Context Text
newtype NodeName = NodeName Text
newtype Command  = Command Text

getNodeNames :: Context -> IO [NodeName]
getNodeNames context = do
  blob <- strict $ kubectl context (Command "get nodes -o jsonpath={.items[*].metadata.name}")
  return $ map NodeName (Text.words blob)

getPods :: Context -> NodeName -> Shell Line
getPods context nodeName =
  kubectl context $ nodePods nodeName
  where
    nodePods :: NodeName -> Command
    nodePods (NodeName nodeName) =
      Command $ "get pods --all-namespaces --field-selector spec.nodeName="
              <> nodeName
              <> ",status.phase!=Succeeded,status.phase!=Failed -o json"

kubectl :: Context -> Command -> Shell Line
kubectl context command =
  inproc "kubectl" (args context command) empty
  where
    args :: Context -> Command -> [Text]
    args (Context context) (Command command) = ["--context", context] <> Text.words command
