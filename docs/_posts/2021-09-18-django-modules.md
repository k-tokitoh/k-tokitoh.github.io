---
title: Djangoのapplications
tags: Django
---

8 月から Django に触り始めて、まだフレームワーク頼みではあるのだが、ようやく Rails を外れた世界をみれている。

Rails にたぶんなくて、Django にあっていいなと思ったのは[applications の仕組み](https://docs.djangoproject.com/en/3.2/ref/applications)。

django では 1 つの project の中に複数の application を記述できる。
各 application は別々のサーバとして動かすこともできるし、サーバから依存される単なるモジュールとすることもできる。

適当に application を分割すれば、高凝集で疎結合な application 群から project を構成することができる。

やり方はいくらでもあるが、例えば以下のような構成がありうる。
実線で囲んだ箱が application に相当する。

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
  - controller は主に web アプリ, API 辺りに書く
  - usecases はそのインターフェース固有であれば web アプリ, API とかに書き、共通するならドメインの application に書けばいい気がする
  - persistence は domain にある他、認証や、場合によっては認可にも生じそう
