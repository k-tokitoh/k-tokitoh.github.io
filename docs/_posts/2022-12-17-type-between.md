---
title: TypeScriptで `n | n +1 | n+2 | ... | m` みたいな型をつくる
tags: typescript
layout: post
---

業務中にこういう型があるといいなと思ったのでパズルがてらやってみた。

ほしい型のイメージは以下。

```typescript
type Between<3, 7>  // 3 | 4 | 5 | 6 | 7
```

最終的には始点と終点を指定したいが、まずは始点を 0 固定で終点だけ指定できるのを書いてみる。

```typescript
type UpTo<N extends number> = UpToBase<N, [], never>;

type UpToBase<
  N extends number,
  A extends unknown[],
  Acc extends unknown
> = A["length"] extends N
  ? Acc | N
  : UpToBase<N, [...A, null], Acc | A["length"]>;

type UpToThree = UpTo<3>; // 0 | 1 | 2 | 3
```

できた。

始点も指定できるようにしたい。

上記の UpToBase の第二型引数に始点の長さの配列型を渡せればよさそうだ。

材料として、数値を与えたらその長さの配列型を返す型を書いてみる。

```typescript
type ArrayOfLength<N extends number> = ArrayOfLengthBase<N, []>;

type ArrayOfLengthBase<
  N extends number,
  acc extends unknown[]
> = acc["length"] extends N ? acc : ArrayOfLengthBase<N, [...acc, unknown]>;

type ArrayOfLengthThree = ArrayOfLength<3>; // [unknown, unknown, unknown]
```

できた。

そしたらこれをつかって、`Between`を書いてみる。

```typescript
type Between<From extends number, To extends number> = UpToBase<
  To,
  ArrayOfLength<From>,
  never
>;

type BetweenThreeAndSeven = Between<3, 7>; // 3 | 4 | 5 | 6 | 7
```

できた〜。
