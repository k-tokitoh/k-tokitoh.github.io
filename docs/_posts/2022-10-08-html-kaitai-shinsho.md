---
title: 『HTML 解体新書』
tags: html books
layout: post
---

<a target="_blank" href="https://www.amazon.co.jp/HTML%E8%A7%A3%E4%BD%93%E6%96%B0%E6%9B%B8-%E4%BB%95%E6%A7%98%E3%81%8B%E3%82%89%E7%B4%90%E8%A7%A3%E3%81%8F%E6%9C%AC%E6%A0%BC%E5%85%A5%E9%96%80-%E5%A4%AA%E7%94%B0-%E8%89%AF%E5%85%B8/dp/4862465277">
  <img src="https://m.media-amazon.com/images/I/81P9-Xhy06L.jpg" width="200px" />
</a>

以下の理由から読んだ。

- web のこと知らなさすぎるなあ、という課題感があった
  - 必要に応じて MDN つまみくいするくらいなので、
    - 体系的にまとまったものをさらってみたい
    - 必要に応じてオリジナルの仕様を読む体力つけられたらいいな
  - 特にアクセシビリティのこと alt 属性くらいしか知らないけど、どうも大事らしい
- [uhyo さんが高評価してた](https://blog.uhy.ooo/entry/2022-05-05/html-kaitai-shinsho/)

知ったことなどをメモ。

## chapter 1. HTML の基本概念

- HTML 仕様は字句的ルール、語彙的ルール、意味論的ルールに分類できる
- かつて HTML 仕様は W3C の勧告だったけど、すったもんだを経ていまはベンダーコミュニティである WHATWG が定めている
  - WHATWG による仕様は draft や candidate のような過程をもたず、公開されているものがすべて正式な仕様であり継続的に更新される
- かつて HTML は SGML（Standard Generalized Markup Language）という汎用マークアップ言語の字句的ルールを満たすものとして定められていたが、いまは違う
  - `<!DOCTYPE html>`はその名残
- HTML のバリエーションで、字句的ルールだけ xml に従うものが XHTML
  - MIME タイプは`application/xhtml+xml`
- DOM ツリーが構築された後で、情報を付加/削除してアクセシビリティツリーが構築され支援技術に対して公開される
- HTML 仕様を読む際はコンテンツ製作者向け/ブラウザベンダー向けの記述を区別して読むべし

## chapter 2. HTML マークアップのルール

- 一部要素は一定条件を満たすと終了タグを省略できる(p, li etc.)
  - たまに書いてない`</p>`が現れるのってそういうことだったのか
- 「この要素の子要素となりうるのはこれだけ」という語彙的ルールの定義では、 content model という概念が用いられる
- 今後新規に作成する HTML 文書の文字エンコーディングは UTF-8 でなけらばならない
- HTML におけるエスケープ = 文字参照
  - 地の HTML だけでなく、属性値も文字参照の対象となる
  - 方式は以下の 2 つ
    - 名前付き文字参照
      - `&lt;` -> `<`, `&gt;` -> `>`
        - タグと間違えないようにエスケープ
      - `&quot;` -> `"`
        - 属性値のダブルクォートと間違えないようにエスケープ
      - `&amp;` -> `&`
        - href の属性値でクエリ文字列を連結するアンパサンドを文字参照のアンパサンドと間違えないようにエスケープ
    - 数値文字参照
      - `&#UNICODE_SCALAR_VALUE;`
      - ex. `&#x3c` -> `<`
- table 要素内に入れることのできない要素を記述した場合、当該要素が table の前に押し出される
  - foster parenting と呼ばれる

## chapter 3. HTML の主要な要素

- マークアップからセクション構造を決定するアウトラインアルゴリズムというものがある
  - HTML 仕様に含まれるものの、その実装はほとんど存在しないらしいのでまず気にしなくて良さそう
  - h タグや secion タグから決定され、DOM ツリーの構造とは関係ない
- ARIA ロール
  - スクリーンリーダの読み上げなどにつかわれる
  - 指定することもできるし、各要素でデフォルトのロールが定まっている場合もある
  - 一部の ARIA ロールをもつ要素はランドマークとして扱われ、それをスキップしたりそれにジャンプしたりできる
- 構造化データ
  - web サイトのもつ情報を構造化して公開するとクローラにとってわかりやすい
  - 構造化データを提供する主要な方法は以下のように分類される
    - 構造化データを直接記述する
      - ex. JSON-LD
    - コンテンツに対するマークアップを付加することで構造化データを生成する
      - ex. microdata (specified in HTML), RDFa
      - microdata のためのグローバル属性として itemid, itemprop, itemref, itemscope, itemtype などがある
- 知らなかった要素や、知ってた要素の知らなかったこと
  - ルート要素と文書のメタデータ
    - base
    - style
      - body に書くとパフォーマンスに悪影響があるので head に記述する
  - セクション
    - article
    - address
  - グルーピングコンテンツ
    - pre
      - preformatted text という意味だったのか！
    - blockquote
    - dl, dt, dd
      - description list, term, definition
  - テキストレベルセマンティクス
    - strong
      - represents text of certain importance
      - デフォルトのスタイルは太字
    - b
      - draw the reader's attention to the element's contents
      - not for styling, but comes from "b"old
      - デフォルトのスタイルは太字
    - em
      - puts some emphasis on the text
      - デフォルトのスタイルは斜体
    - i
      - represents a range of text that is set off from the normal text for some reason, such as idiomatic text, technical terms, taxonomical designations, among others
      - not for styling, but comes from "i"talic
      - デフォルトのスタイルは斜体
    - cite
      - describe a reference to a cited creative work
      - デフォルトのスタイルは斜体
    - mark
      - represents text of certain relevance
      - デフォルトのスタイルは黄色い背景色
    - small
    - s
      - not for styling, but comes from "s"trikethrough
    - q
      - comes from "q"otation
      - 前後に引用符が挿入される
    - dfn
      - comes from "d"e"f"i"n"ition
    - abbr
      - comes from "abbr"eviation
      - 略語、頭文字
    - ruby
      - まだ仕様が安定していない
    - time
    - data
    - code
    - var
    - samp
      - comes from "samp"le
    - kbd
      - comes from "k"ey"b"oar"d"
    - sup
      - comes from "sup"erscript
    - sub
      - comes from "sub"script
    - u
      - comes from "u"nderline
    - bdi
      - comes from "b"i"d"irectional "i"solation
      - 書字方向が周囲と異なることを表現する
    - bdo
      - comes from "b"i"d"irectional "o"verride
      - dir 属性により書字方向を明示的に上書きする
    - br
      - comes from line "br"eak
    - wbr
      - comes from "w"ord "br"eak opportunity
      - 改行可能位置を示す
    - a
      - 支援技術では a タグの子要素だけを読み上げていく場合があるので、子要素には「こちら」などではなくリンク先が推定できる言葉を用いることが望ましい
      - href 属性
        - comes from "h"yper-link "ref"erence
      - target 属性
        - iframe 要素の name 属性を指定したりもできる
      - ping 属性
        - リンクを踏んだことを表現する post リクエストを指定した url に送信する
      - rel 属性 = link type
        - alternate
          - 別言語やスタイルシート切り替えなど

(...to be written)

## chapter 4. 主要な属性と WAI-ARIA

<input type="hidden" id="ASIN" name="ASIN" value="4862465277">
