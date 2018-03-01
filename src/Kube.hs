{-# LANGUAGE OverloadedStrings #-}
module Kube
        ( getNodeNames
        , getPods
        ) where

import Turtle
import qualified Data.Text as Text (words)

getNodeNames context = do
  blob <- strict $ kubectl context "get nodes -o jsonpath={.items[*].metadata.name}"
  return $ Text.words blob

getPods context nodeName =
  kubectl context $
    "get pods --all-namespaces --field-selector "
  <> nodePods nodeName
  <> " -o json"
  where
    nodePods nodeName =
      "spec.nodeName=" <> nodeName <> ",status.phase!=Succeeded,status.phase!=Failed"

kubectl context command =
  inproc "kubectl" args empty
  where
    args = ["--context", context] <> Text.words command
