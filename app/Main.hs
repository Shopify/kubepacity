{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Kube
import Objects

import Data.Aeson (decodeStrict, ToJSON, FromJSON)
import Turtle
import Data.Text (Text)
import Data.Text.Encoding (encodeUtf8)
import GHC.Generics

-- Used to decode JSON list of pods.
newtype PodSet = PodSet { items :: [Pod] }
  deriving (Show, Eq, Generic, FromJSON)

parser :: Parser Context
parser = Context <$> optText "context" 'c' "the context to visualize"

-- A WIP main for messing around with parsing.
main :: IO ()
main = do
  context  <- options "kubepacity" parser
  names    <- getNodeNames context
  podsJSON <- strict . getPods context . head $ names
  let (Just set) = decodeStrict . encodeUtf8 $ podsJSON
  mapM_ print (items set)
