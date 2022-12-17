---
title: stub & mock
tags: testing
layout: post
---

いまさらながら stub とか mock とか、毎回思い出すときにちょっと混乱するのでメモ。

# stub, mock 導入前

サンプルコード。Waiter が Ramen を提供する。Ramen 生成の部分は Cooker に委譲している。

```typescript
export class Ramen {
  constructor(public soup: any = null, public noodle: any = null) {}
}

export class Waiter {
  constructor(private readonly cooker: Cooker) {}

  serve(): Ramen {
    const ramen = this.cooker.cook();
    return ramen;
  }
}

export class Cooker {
  cook(): Ramen {
    return new Ramen("awesome soup", "rich noodle");
  }
}
```

テストする。

```typescript
test("Ramen is served", () => {
  const cooker = new Cooker();
  const waiter = new Waiter(cooker);
  const served = waiter.serve();
  expect(served).toBeInstanceOf(Ramen);
});
```

# stub 導入

stub は、偽の値を返すオブジェクトを使うこと。

これによってテスト対象範囲を狭めることができる。

テストには戻り値のテストと副作用のテストがあるが、stub はいずれにも利用される。

サンプルコードでいうと、Waiter と Cooker の全体をテストしてしまっているので、Cooker を stub することでテスト対象を Waiter のみに限定してみる。

Stub が Stub 足り得ていることを保証するため、インターフェースを定義しつつ、本番用の実装とテスト用のスタブ実装がそれぞれこのインターフェースを implement する形にする。

```typescript
export interface ICooker {
  cook: () => Ramen;
}

export class Cooker implements ICooker {
  cook(): Ramen {
    return new Ramen("awesome soup", "rich noodle");
  }
}

class CookerStub implements ICooker {
  cook(): Ramen {
    return new Ramen();
  }
}
```

Waiter に期待するのは Cooker から受け取ったものをそのまま提供することなので、Cooker から受け取るものは型さえ満たせばなんでもよい。

この場合、soup も noodle もない空っぽの Ramen を渡す CookerStub を用意している。

```typescript
test("with cooker stub", () => {
  const cooker = new CookerStub();
  const waiter = new Waiter(cooker);
  const served = waiter.serve();
  expect(served).toBeInstanceOf(Ramen);
});
```

これで pass する。

当然ながら stub すると stub した部分はテスト対象から外れるので、それが妥当な値を返すことは別途テストする必要がある。

（この例でいうと、`Cooker#cook()`がテスト対象から外れるので、別途ちゃんと中身のある Ramen をつくってくれることをテストする必要がある。）

### stub by jest

jest で stub をつくるための機能が提供されているので、それを利用したバージョンも書いてみる。

（以降のサンプルコードでは Cooker についてはこのバージョンを利用する。）

```typescript
jest.spyOn(Cooker.prototype, "cook").mockReturnValue(new Ramen());

test("with cooker stub by jest", () => {
  const cooker = new Cooker();
  const waiter = new Waiter(cooker);
  const served = waiter.serve();
  expect(served).toBeInstanceOf(Ramen);
});
```

jest ではこの記事で整理する stub, mock をともに mock という名前の機能で提供しているので注意。

# 副作用のテスト

上記では`Waiter#serve()`は戻り値を返すだけで、特に副作用は生じていなかった。

Ramen を提供しつつ、伝票に 600 円を追加する副作用が期待される、ということにしてみる。

伝票を表現するクラスを以下のように定義してみる。

```typescript
export class Slip {
  constructor() {
    this.write(0);
  }

  private get path(): string {
    return "./slip-value";
  }

  private write(price: number): void {
    fs.writeFileSync(this.path, String(price));
  }

  private read(): number {
    return Number(fs.readFileSync(this.path));
  }

  add(price: number): number {
    const former = this.read();
    const latter = former + price;
    this.write(latter);
    return latter;
  }
}
```

そして 600 円の追記。

```typescript
export class Waiter {
  constructor(private readonly cooker: Cooker, private readonly slip: Slip) {}

  serve(): Ramen {
    const ramen = this.cooker.cook();
    this.slip.add(600);
    return ramen;
  }
}
```

これをまずはナイーブにテストする。

副作用の最終的な結果 = ファイルの中身を確かめている。この場合、テスト対象範囲は Ramen + Slip である。

```typescript
test("assert side effect", () => {
  const cooker = new CookerStub();
  const slip = new Slip();
  const waiter = new Waiter(cooker, slip);
  waiter.serve();

  const price = fs.readFileSync("./slip").toString();
  expect(price).toEqual("600");
});
```

# mock 導入

mock は、副作用をテストしたいときに、副作用のために利用されるオブジェクトが然るべき形（引数や回数）で呼び出されているかをテストするために利用するもの。

まずは自前で mock オブジェクトをつくってみる。

```typescript
class SlipMock extends Slip {
  private readonly addArgs: number[] = [];

  get addCalledCount(): number {
    return this.addArgs.length;
  }

  wasAddCalledWith(price: number): boolean {
    return this.addArgs.includes(price);
  }

  override add(price: number): number {
    this.addArgs.push(price);
    return super.add(price);
  }
}
```

これを利用してテストする。

```typescript
test("assert side effect with mock", () => {
  const cooker = new Cooker();
  const slipMock = new SlipMock();
  const waiter = new Waiter(cooker, slipMock);
  waiter.serve();

  expect(slipMock.addCalledCount).toEqual(1);
  expect(slipMock.wasAddCalledWith(600)).toBeTruthy();
});
```

### mock して、かつ stub もする

mock と stub は基本的に別軸の話なので、mock でかつ stub ということもありうる。

上記の例だと mock 機能のみを追加しており、stub はしていない。

しかし mock で副作用をテストするのであれば実際に副作用を起こす処理は動かさない方がテストが軽量になるので、実際に副作用を起こす処理は省略することが多い。

戻り値がその処理に基づいている場合には、実際の処理を行わない代わりに適当な何らかの値を返す、つまり stub する必要が生じる。

サンプルコードの場合、以下のようになる。

```typescript
class SlipMock extends Slip {
  // 省略

  override add(price: number): number {
    this.addArgs.push(price);
    return 0;
  }
}
```

### mock (& stub) by jest

jest が提供している機能を利用したバージョンも書いてみる。

```typescript
const addMock = jest.spyOn(Slip.prototype, "add").mockImplementation(() => 0);
```

```typescript
test("assert side effect with mock by jest", () => {
  const cooker = new Cooker();
  const slip = new Slip();
  const waiter = new Waiter(cooker, slip);
  waiter.serve();

  expect(addMock).toHaveBeenCalledTimes(1);
  expect(addMock).toHaveBeenCalledWith(600);
});
```

できた。

# おまけ

jest にはモジュールとかクラスをごっそり mock&stub する機能があるみたいだが、以下の理由からあんまりつかいたくないような気がした。

- デフォルトだと一律 undefined を返すように stub するが、インターフェースが変わっちゃってる
- hoisting とかあったりして、コードの動きがだいぶわかりにくい（実際ハマった）
- stub とか mock って部分的に当てればよくないか？
  - その方がそれぞれのテストでの意図がわかりやすいような
  - jest で規模大きめのテストコード書いたことないから実感わからないけど
