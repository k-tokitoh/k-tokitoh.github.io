---
title: Djangoのapplications
tags: Django
---

8月からDjangoに触り始めて、まだフレームワーク頼みではあるのだが、ようやくRailsを外れた世界をみれている。

Railsにたぶんなくて、Djangoにあっていいなと思ったのは[applicationsの仕組み](https://docs.djangoproject.com/en/3.2/ref/applications)。

djangoでは1つのprojectの中に複数のapplicationを記述できる。
各applicationは別々のサーバとして動かすこともできるし、サーバから依存される単なるモジュールとすることもできる。

適当にapplicationを分割すれば、高凝集で疎結合なapplication群からprojectを構成することができる。

やり方はいくらでもあるが、例えば以下のような構成がありうる。
実線で囲んだ箱がapplicationに相当する。

![](https://docs.google.com/drawings/d/e/2PACX-1vTzyKIoBJ0LFusyDu_gk60ASiLGgEwLa4o6J2Jl0Fjjr5PsdJPKTM4YkzmjJ_UlXk1a9KjwKY_ZqKaU/pub?w=387&h=526)

いくつか補足。

- ここでサブドメインとは、コアドメインから依存されないアドホックなドメイン領域を指す
- 認可は
  - リソースについて知っている必要があるのでドメインに依存する
  - `isAuthenticated`とかつかうので認証にも依存する
- 認証は
  - ドメインに依存しない
  - デフォルトの認証モジュールを直接利用してもいいが、抽象化したレイヤを挟めば実装を切り替えたりできそう
- controller/usecase/domain/persistence みたいな区分とは完全に対応する訳でもないし、直交するわけでもない
  - controller は主にwebアプリ, API辺りに書く
  - usecases はそのインターフェース固有であればwebアプリ, APIとかに書き、共通するならドメインのapplicationに書けばいい気がする
  - persistence はdomainにある他、認証や、場合によっては認可にも生じそう


