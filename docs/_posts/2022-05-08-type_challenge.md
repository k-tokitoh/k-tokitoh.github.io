---
title: types challenges
tags: typescript
---

https://github.com/type-challenges/type-challenges

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
type N = Promise<Promise<Promise<string>>>
Expect<Equal<MyAwaited<N>, string>>
```

一番上の階層では型引数に extends を書くことで `MyAwaited<number>` とかを弾きつつ、内側では再帰で書けばより一般的に書けた。
上記のテストもとおる。

```typescript
type MyAwaited<T extends Promise<unknown>> = T extends Promise<infer U>
  ? MyAwaitedBase<U>
  : never;
type MyAwaitedBase<T> = T extends Promise<infer U> ? MyAwaitedBase<U> : T;
```
