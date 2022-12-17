---
title: type challenges - warm-up, easy
tags: typescript
layout: post
---

[type-challenges/type-challenges](https://github.com/type-challenges/type-challenges)

## [hello world](https://github.com/type-challenges/type-challenges/blob/main/questions/00013-warm-hello-world/README.md)

```typescript
type HelloWorld = string;
```

## [pick](https://github.com/type-challenges/type-challenges/blob/main/questions/00004-easy-pick/README.md)

```typescript
type MyPick<T, K extends keyof T> = {
  [P in K]: T[P];
};
```

型引数 K に条件として extends...を書かないといけなかった。

## [readonly](https://github.com/type-challenges/type-challenges/blob/main/questions/00007-easy-readonly/README.md)

```typescript
type MyReadonly<T> = {
  readonly [P in keyof T]: T[P];
};
```

## [tuple to object](https://github.com/type-challenges/type-challenges/blob/main/questions/00011-easy-tuple-to-object/README.md)

```typescript
type TupleToObject<T extends readonly (string | number | symbol)[]> = {
  [P in T[number]]: P;
};
```

key は `string|number|symbol` である必要があるのか。

## [first of array](https://github.com/type-challenges/type-challenges/blob/main/questions/00014-easy-first/README.md)

```typescript
type First<T extends unknown[]> = T extends [unknown, ...unknown[]]
  ? T[0]
  : never;
```

extends で要素がひとつ以上存在することを担保してあげる必要がある。

```typescript
type First<T extends unknown[]> = T extends [infer H, ...unknown[]] ? H : never;
```

infer をつかってもよい。
infer は extends の右側で導入する。

## [length of tuple](https://github.com/type-challenges/type-challenges/blob/main/questions/00018-easy-tuple-length/README.md)

```typescript
type Length<T extends readonly unknown[]> = T["length"];
```

そっか、length はプロパティだから `T["length"]`で取り出せるのか。

## [exclude](https://github.com/type-challenges/type-challenges/blob/main/questions/00043-easy-exclude/README.md)

```typescript
type MyExclude<T, U> = T extends U ? never : T;
```

union distribution って聞いたことあったけど初めて書いた。
extends の左側が型変数で union 型ならばそれは分配される。
never は 0 個の union のように振る舞う。

## [awaited](https://github.com/type-challenges/type-challenges/blob/main/questions/00189-easy-awaited/README.md)

`MyAwaited<number>`をエラーにするためにはシンプルな再帰では書けないので、まず以下で書いた。

```typescript
type MyAwaited<T extends Promise<unknown>> = T extends Promise<infer U>
  ? U extends Promise<infer V>
    ? V
    : U
  : never;
```

しかしこれだとネストが 2 階層までに限定されてしまい、例えば以下がとおらない。

```typescript
type N = Promise<Promise<Promise<string>>>;
Expect<Equal<MyAwaited<N>, string>>;
```

一番上の階層では型引数に extends を書くことで `MyAwaited<number>` とかを弾きつつ、内側では再帰で書けばより一般的に書けた。
上記のテストもとおる。

```typescript
type MyAwaited<T extends Promise<unknown>> = T extends Promise<infer U>
  ? MyAwaitedBase<U>
  : never;
type MyAwaitedBase<T> = T extends Promise<infer U> ? MyAwaitedBase<U> : T;
```

## [if](https://github.com/type-challenges/type-challenges/blob/main/questions/00268-easy-if/README.md)

```typescript
type If<C extends boolean, T, F> = C extends true ? T : F;
```

## [concat](https://github.com/type-challenges/type-challenges/blob/main/questions/00533-easy-concat/README.md)

```typescript
type Concat<T extends unknown[], U extends unknown[]> = [...T, ...U];
```

配列を展開するみたいに、配列の型も展開できるんだな。

## [includes](https://github.com/type-challenges/type-challenges/blob/main/questions/00898-easy-includes/README.md)

前段として、型の一致を検査することを考える。[参考](https://uraway.dev/equal-type/)

```typescript
type Equal_0<X, Y> = X extends Y ? (Y extends X ? true : false) : false;

type _0_true_0 = Equal_0<0, 0>; // true
type _0_false_0 = Equal_0<0, 1>; // false
type _0_true_1 = Equal_0<0 | 1, 0 | 1>; // boolean
```

これだと union distribution により最後の例で正しく判定できない。

配列にすることで union distribution を回避する。

```typescript
type Equal_1<X, Y> = [X] extends [Y] ? ([Y] extends [X] ? true : false) : false;

type _1_true_0 = Equal_1<0, 0>; // true
type _1_false_0 = Equal_1<0, 1>; // false
type _1_true_1 = Equal_1<0 | 1, 0 | 1>; // true
type _1_false_1 = Equal_1<0, 0 | 1>; // false
type _1_false_2 = Equal_1<0, any>; // true
```

extends は割り当て可能性を判定し、最後の例で 0 と any は互いに割り当て可能なため true を返してしまう。

一応、0 と any が互いに割り当て可能であることを確認しておく。

```typescript
declare let a: 0;
declare let b: any;

a = b; // エラーにならない
b = a; // エラーにならない
```

ここで「条件付き型同士が割り当て可能になるには extends 直後の型同士が同値でなければならない」という性質がある。

まずそれを確認する。

```typescript
declare let foo: <T>() => T extends string ? 0 : 1;
declare let bar: <T>() => T extends any ? 0 : 1;

foo = bar; // エラーになる
bar = foo; // エラーになる
```

extends を直ちに評価せず残すために、便宜的にジェネリックつきの関数の戻り値の型に extends を用いている。

ちなみにこういう関数型を実際に呼び出してみると、ジェネリックパラメータ T は推論しようがないので unknown となる。

```typescript
foo(); // let foo: <unknown>() => 1
```

ちなみに t/f の場合の型が同じだと「extends の右側がなんだろうと結局同じ型でしょ」ということで代入可能になる。

```typescript
declare let foo: <T>() => T extends string ? 0 : 0;
declare let bar: <T>() => T extends any ? 0 : 0;

foo = bar; // エラーにならない
bar = foo; // エラーにならない
```

さてこの性質を利用して型の一致を判定する。

```typescript
type Equal_2<X, Y> = (<T>() => T extends X ? 0 : 1) extends <T>() => T extends Y
  ? 0
  : 1
  ? true
  : false;

type _2_true_0 = Equal_2<0, 0>; // true
type _2_false_0 = Equal_2<0, 1>; // false
type _2_true_1 = Equal_2<0 | 1, 0 | 1>; // true
type _2_false_1 = Equal_2<0, 0 | 1>; // false
type _2_false_2 = Equal_2<0, any>; // false
```

以上で型の一致の検査をすることができたので、本題の includes に戻る。
一致性をひとつひとつの要素について再帰的に判定していく。

```typescript
type MyEqual<X, Y> = (<T>() => T extends X ? 0 : 1) extends <T>() => T extends Y
  ? 0
  : 1
  ? true
  : false;
type Includes<T extends readonly unknown[], U> = T extends [infer F, ...infer R]
  ? MyEqual<F, U> extends true
    ? true
    : Includes<R, U>
  : false;
```

## [push](https://github.com/type-challenges/type-challenges/blob/main/questions/03057-easy-push/README.md)

```typescript
type Push<T extends unknown[], U> = [...T, U];
```

## [unshift](https://github.com/type-challenges/type-challenges/blob/main/questions/03060-easy-unshift/README.md)

```typescript
type Unshift<T extends unknown[], U> = [U, ...T];
```

## [parameters](https://github.com/type-challenges/type-challenges/blob/main/questions/03312-easy-parameters/README.md)

```typescript
type MyParameters<T extends (...args: any[]) => unknown> = T extends (
  ...args: infer Args
) => unknown
  ? Args
  : never;
```
