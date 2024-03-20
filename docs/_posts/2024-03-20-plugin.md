---
title: プラグイン
layout: post
---

「プラグイン化するとすっきりするよね」というだけの話だが、自分で実装したことないのでイメージ掴むためにちょっと書いたメモ。

例えば以下の状況を想定する。

- app A で文字列を逆順にして感嘆符をつけたい
- 文字列の操作は十分独立性が高いため、appA の外側に切り出して配置する

```typescript
// common
class Transformer {
  constructor(public str: string) {}

  exclamate(): void {
    this.str = `${this.str}!`;
  }

  reverse(): void {
    this.str = this.str.split("").reverse().join("");
  }
}

// app A
const ta = new Transformer("hoge");
ta.reverse();
ta.exclamate();
console.log(ta.str); // => egoh!
```

続いて、app B で 大文字にしてから逆順にしたくなったとする。

ナイーブに実装すると、既に文字列操作を記述している common に追記することになる。

```typescript
// common
class Transformer {
  constructor(public str: string) {}

  exclamate(): void {
    this.str = `${this.str}!`;
  }

  reverse(): void {
    this.str = this.str.split("").reverse().join("");
  }

  capitalize(): void {
    this.str = this.str.toUpperCase();
  }
}

// app B
const tb = new Transformer("hoge");
tb.capitalize();
tb.reverse();
console.log(tb.str); // => EGOH
```

app C, D, E... で色んな要件が発生するたびにこの方向で対応していると、Transformer の責務が不必要にどんどん広がっていく。

そこで各機能を pluggable にしてみる。

```typescript
// common
type TransformerPlugin = (str: string) => string;

class Transformer {
  constructor(
    private readonly orig: string,
    private readonly plugins: TransformerPlugin[]
  ) {}

  execute(): string {
    return this.plugins.reduce((acc, plugin) => plugin(acc), this.orig);
  }
}

const reverser: TransformerPlugin = (str: string) =>
  str.split("").reverse().join("");

// app A
const exclamater: TransformerPlugin = (str: string) => `${str}!`;

const ta = new Transformer("hoge", [reverser, exclamater]);
console.log(ta.execute()); // => egoh!

// app B
const capitalizer: TransformerPlugin = (str: string) => str.toUpperCase();

const tb = new Transformer("hoge", [capitalizer, reverser]);
console.log(tb.execute()); // => EGOH
```

各アプリの責務と、互いの依存関係を必要十分な形に抑えることができた。

（上記では plugin を関数としているがもちろん必要に応じてクラスとかにして OK）

デザインパターンでいうと strategy pattern が一番近い気がする。strategy pattern の典型的な例では単一の処理の実装を差し替えるものが多いが、plugin は複数処理を差し込めるようにする方法なので若干異なるかもしれない。
