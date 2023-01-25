#!/bin/bash

# 作成対象タグ名
TARGET_TAG=$1
# タグメッセージ
TAG_MESSAGE=$2

# 作成対象のタグが存在するかチェック
## lightweightタグ(refs/tags/$タグ名^{})は除外するよう、正規表現に「refs/tags/$TARGET_TAG$」を指定
## 参考：https://zenn.dev/heyhey1028/articles/9ae35cf35c410d
REMOTE_TARGET_TAG=$(git ls-remote --tags 2>/dev/null | grep "refs/tags/$TARGET_TAG$" | awk -F' ' '{print $2}')

#　存在する場合はタグを削除
if [ -n "$REMOTE_TARGET_TAG" ]; then
  ## ローカルリポジトリのタグを削除
  git tag -d $TARGET_TAG
  ## リモートリポジトリのタグを削除
  git push origin -d $TARGET_TAG
fi

# タグの登録
## 注釈付きタグの作成にはuser.name,user.emailが必要
git config user.name "$(git log -1 --pretty=format:'%an')"
git config user.email "$(git log -1 --pretty=format:'%ae')"
## ローカルリポジトリにタグ作成
git tag -a $TARGET_TAG -m $TAG_MESSAGE
##　リモートリポジトリにタグ登録
git push origin $TARGET_TAG