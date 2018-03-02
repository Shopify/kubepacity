{-# LANGUAGE OverloadedStrings #-}

module ObjectsSpec (spec) where

import Test.Hspec
import Data.Text.IO (readFile)
import Prelude hiding (readFile)

spec :: Spec
spec = do
  describe "ToJSON on Pod" $
    it "should return cpu and memory" $ do
      json <- readFile "test/fixtures/pod.json"
      json `shouldBe` json

