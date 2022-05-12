---
title: type challenges - medium
tags: typescript
---

[type-challenges/type-challenges](https://github.com/type-challenges/type-challenges)

## [get return type](https://github.com/type-challenges/type-challenges/blob/main/questions/00002-medium-return-type/README.md)

```typescript
type MyReturnType<T extends (...args: any) => unknown> = T extends (
  ...args: any
) => infer U
  ? U
  : never;
```

## [omit](https://github.com/type-challenges/type-challenges/blob/main/questions/00003-medium-omit/README.md)

```typescript
type MyOmit<
  T extends { [key in K]: unknown },
  K extends string | number | symbol
> = { [P in MyExclude<keyof T, K>]: T[P] };

type MyExclude<T, U> = T extends U ? never : T;
```

## [readonly 2](https://github.com/type-challenges/type-challenges/blob/main/questions/00008-medium-readonly-2/README.md)

```typescript
type MyReadonly2<T, K extends keyof T = keyof T> = {
  readonly [P in K]: T[P];
} & { [Q in MyExclude<keyof T, K>]: T[Q] };

type MyExclude<T, U> = T extends U ? never : T;
```

## [deep readonly](https://github.com/type-challenges/type-challenges/blob/main/questions/00009-medium-deep-readonly/README.md)

```typescript
type DeepReadonly<T> = {
  readonly [P in keyof T]: T[P] extends Record<string, unknown> | unknown[]
    ? DeepReadonly<T[P]>
    : T[P];
};
```

いわゆる key-value なオブジェクトどうやって判定するねんと思ったら Record か。

## [tuple to union](https://github.com/type-challenges/type-challenges/blob/main/questions/00010-medium-tuple-to-union/README.md)

```typescript
type TupleToUnion<T extends unknown[]> = T[number];
```

## [chainable options](https://github.com/type-challenges/type-challenges/blob/main/questions/00012-medium-chainable-options/README.md)

```typescript
// todo
```

## [last of array](https://github.com/type-challenges/type-challenges/blob/main/questions/00015-medium-last/README.md)

```typescript
// todo
```

## [pop](https://github.com/type-challenges/type-challenges/blob/main/questions/00016-medium-pop/README.md)

```typescript
// todo
```

## [promise all](https://github.com/type-challenges/type-challenges/blob/main/questions/00020-medium-promise-all/README.md)

```typescript
// todo
```

## [type lookup](https://github.com/type-challenges/type-challenges/blob/main/questions/00062-medium-type-lookup/README.md)

```typescript
// todo
```

## [trim left](https://github.com/type-challenges/type-challenges/blob/main/questions/00106-medium-trimleft/README.md)

```typescript
// todo
```

## [trim](https://github.com/type-challenges/type-challenges/blob/main/questions/00108-medium-trim/README.md)

```typescript
// todo
```

## [capitalize](https://github.com/type-challenges/type-challenges/blob/main/questions/00110-medium-capitalize/README.md)

```typescript
// todo
```

## [replace](https://github.com/type-challenges/type-challenges/blob/main/questions/00116-medium-replace/README.md)

```typescript
// todo
```

## [replace all](https://github.com/type-challenges/type-challenges/blob/main/questions/00119-medium-replaceall/README.md)

```typescript
// todo
```

## [append argument](https://github.com/type-challenges/type-challenges/blob/main/questions/00191-medium-append-argument/README.md)

```typescript
// todo
```

## [permutation](https://github.com/type-challenges/type-challenges/blob/main/questions/00296-medium-permutation/README.md)

```typescript
// todo
```

## [length of string](https://github.com/type-challenges/type-challenges/blob/main/questions/00298-medium-length-of-string/README.md)

```typescript
// todo
```

## [flatten](https://github.com/type-challenges/type-challenges/blob/main/questions/00459-medium-flatten/README.md)

```typescript
// todo
```

## [append to object](https://github.com/type-challenges/type-challenges/blob/main/questions/00527-medium-append-to-object/README.md)

```typescript
// todo
```

## [absolute](https://github.com/type-challenges/type-challenges/blob/main/questions/00529-medium-absolute/README.md)

```typescript
// todo
```

## [string to union](https://github.com/type-challenges/type-challenges/blob/main/questions/00531-medium-string-to-union/README.md)

```typescript
// todo
```

## [merge](https://github.com/type-challenges/type-challenges/blob/main/questions/00599-medium-merge/README.md)

```typescript
// todo
```

## [kebab case](https://github.com/type-challenges/type-challenges/blob/main/questions/00612-medium-kebabcase/README.md)

```typescript
// todo
```

## [diff](https://github.com/type-challenges/type-challenges/blob/main/questions/00645-medium-diff/README.md)

```typescript
// todo
```

## [any of](https://github.com/type-challenges/type-challenges/blob/main/questions/00949-medium-anyof/README.md)

```typescript
// todo
```

## [is never](https://github.com/type-challenges/type-challenges/blob/main/questions/01042-medium-isnever/README.md)

```typescript
// todo
```

## [is union](https://github.com/type-challenges/type-challenges/blob/main/questions/01097-medium-isunion/README.md)

最初 union を配列に置き換えて length とるとか？ と思ったけど、そういう回答例は見当たらなくて以下。

union の場合にのみ union distribution が発生することを利用する。

```typescript
type IsUnion<T> = IsUnionBase<T, T>;
type IsUnionBase<T, C> = T extends infer TN
  ? [C] extends [TN]
    ? false
    : true
  : never;
```

T が`string|number`なら TN には`string`, `number`がそれぞれ分配してバインドされる。

これらが元の`string|number`と一致しないということを炙り出したい。

`TN extends C`だと一致しないけど割り当て可能と判定されてしまうので、TN(`string`)を extends の右側、C(`string|number`)を extends の左側に書くことに注意する。

しかしシンプルに`C extends TN`と書くと C(`string|number`)が分配されてしまい、

```typescript
string extends string ? true : false | number extends string ? true : false
```

すなわち`true|false`を返してしまう。

これを避けるために`C extends TN`ではなく`[C] extends [TN]`としてあげれば完成。

## [replace keys](https://github.com/type-challenges/type-challenges/blob/main/questions/01130-medium-replacekeys/README.md)

```typescript
// todo
```

## [remove index signature](https://github.com/type-challenges/type-challenges/blob/main/questions/01367-medium-remove-index-signature/README.md)

```typescript
// todo
```

## [percentage parser](https://github.com/type-challenges/type-challenges/blob/main/questions/01978-medium-percentage-parser/README.md)

```typescript
// todo
```

## [drop char](https://github.com/type-challenges/type-challenges/blob/main/questions/02070-medium-drop-char/README.md)

```typescript
// todo
```

## [minus one](https://github.com/type-challenges/type-challenges/blob/main/questions/02257-medium-minusone/README.md)

```typescript
// todo
```

## [pick by type](https://github.com/type-challenges/type-challenges/blob/main/questions/02595-medium-pickbytype/README.md)

```typescript
// todo
```

## [starts with](https://github.com/type-challenges/type-challenges/blob/main/questions/02688-medium-startswith/README.md)

```typescript
// todo
```

## [ends with](https://github.com/type-challenges/type-challenges/blob/main/questions/02693-medium-endswith/README.md)

```typescript
// todo
```

## [partial by keys](https://github.com/type-challenges/type-challenges/blob/main/questions/02757-medium-partialbykeys/README.md)

```typescript
// todo
```

## [required by keys](https://github.com/type-challenges/type-challenges/blob/main/questions/02759-medium-requiredbykeys/README.md)

まず、以下のように mapped type の key の部分で conditional type をつかうことができる。

```typescript
type MyExclude<T, U extends number | string | symbol> = {
  [k in keyof T as k extends U ? never : k]: T[k];
};

type Man = { name: string; age: number };
type AgeOnly = MyExclude<Man, "name">; // type AgeOnly = { age: number; }
```

これを利用して以下のように書いてみる。

```typescript
type RequiredByKeys<
  T extends Record<string | number | symbol, any>,
  K extends number | string | symbol = keyof T
> = {
  [P in keyof T as P extends K ? P : never]-?: T[P];
} & {
  [P in keyof T as P extends K ? never : P]?: T[P];
};
```

これだと以下のように交差型になってしまい、テストがとおらない。

```typescript
type Intersection = RequiredByKeys<User, "name">;

// type Intersection = {
//     name: string;
// } & {
//     age?: number | undefined;
//     address?: string | undefined;
// }
```

交差型をまとめるために、infer して mapped type をとおしてあげれば OK.

```typescript
type RequiredByKeys<
  T extends Record<string | number | symbol, any>,
  K extends number | string | symbol = keyof T
> = {
  [P in keyof T as P extends K ? P : never]-?: T[P];
} & {
  [P in keyof T as P extends K ? never : P]?: T[P];
} extends infer R
  ? { [P in keyof R]: R[P] }
  : never;
```

## [mutable](https://github.com/type-challenges/type-challenges/blob/main/questions/02793-medium-mutable/README.md)

```typescript
// todo
```

## [omit by type](https://github.com/type-challenges/type-challenges/blob/main/questions/02852-medium-omitbytype/README.md)

```typescript
// todo
```

## [object entries](https://github.com/type-challenges/type-challenges/blob/main/questions/02946-medium-objectentries/README.md)

```typescript
// todo
```

## [shift](https://github.com/type-challenges/type-challenges/blob/main/questions/03062-medium-shift/README.md)

```typescript
// todo
```

## [tuple to nested object](https://github.com/type-challenges/type-challenges/blob/main/questions/03188-medium-tuple-to-nested-object/README.md)

```typescript
// todo
```

## [reverse](https://github.com/type-challenges/type-challenges/blob/main/questions/03192-medium-reverse/README.md)

```typescript
// todo
```

## [flip arguments](https://github.com/type-challenges/type-challenges/blob/main/questions/03196-medium-flip-arguments/README.md)

```typescript
// todo
```

## [flatten depth](https://github.com/type-challenges/type-challenges/blob/main/questions/03243-medium-flattendepth/README.md)

```typescript
// todo
```

## [bem style string](https://github.com/type-challenges/type-challenges/blob/main/questions/03326-medium-bem-style-string/README.md)

product 的なのどうやってつくればええねんと思ったけど、

```typescript
type Countries = ["us", "jp"];
type Country = Countries[number]; // "us" | "jp"
```

これで配列型から union に展開してくれるのを、ひとつの型の記述の中で複数用いると、product な感じで union に展開してくれるようだ。

まずふつうに template literals つかいつつ union に展開する。

```typescript
type BE<B extends string, E extends string[]> = `${B}__${E[number]}`;
type be = BE<"b", ["e1", "e2"]>; // "b__e1" | "b__e2"
```

続いて複数を埋め込んで展開する。

```typescript
type BEM<
  B extends string,
  E extends string[],
  M extends string[]
> = `${B}__${E[number]}--${M[number]}`;
type bem = BEM<"b", ["e1", "e2"], ["m1", "m2"]>; // "b__e1--m1" | "b__e1--m2" | "b__e2--m1" | "b__e2--m2"
```

しかしこれだと E, M のいずれかが空配列だった場合、never を返却してしまう。上記で 2 \* 2 => 4 通りの union になっていたのが、n \* 0 => 0 通りになるということだろう。

これに対応するため、conditional type で空配列の場合を別途扱う。まず E のみの場合。

```typescript
type BE<B extends string, E extends string[]> = E extends []
  ? B
  : `${B}__${E[number]}`;
type be0 = BE<"b", ["e1", "e2"]>; //  "b__e1" | "b__e2"
type be1 = BE<"b", []>; // "b"
```

```typescript
type BEM<
  B extends string,
  E extends string[],
  M extends string[]
> = E extends []
  ? M extends []
    ? B
    : `${B}--${M[number]}`
  : M extends []
  ? `${B}__${E[number]}`
  : `${B}__${E[number]}--${M[number]}`;
```

これで完成。

## [in order traversal](https://github.com/type-challenges/type-challenges/blob/main/questions/03376-medium-inordertraversal/README.md)

```typescript
// todo
```

## [flip](https://github.com/type-challenges/type-challenges/blob/main/questions/04179-medium-flip/README.md)

```typescript
// todo
```

## [fibonacci sequence](https://github.com/type-challenges/type-challenges/blob/main/questions/04182-medium-fibonacci-sequence/README.md)

```typescript
// todo
```

## [all combinations](https://github.com/type-challenges/type-challenges/blob/main/questions/04260-medium-nomiwase/README.md)

```typescript
// todo
```

## [greater than](https://github.com/type-challenges/type-challenges/blob/main/questions/04425-medium-greater-than/README.md)

型のコードでは条件判定は extends を用いてしか行うことができない。なので数字の大小の問題を割り当て可能性の問題に置き換える必要がある。

`3 extends 3 ? true : false`のように数字の同一性を判定できることに着目する。

再帰をつかって extends の右側をカウントアップしていくことを考える。

値を直接インクリメントすることはできないが、n 個の要素からなる配列型を n+1 個の要素からなる配列型にして再帰的な呼び出しをすることは可能なので、それを利用する。

```typescript
type GreaterThan<T extends number, U extends number> = GreaterThanBase<
  T,
  U,
  []
>;
type GreaterThanBase<
  T extends number,
  U extends number,
  R extends null[]
> = T extends R["length"]
  ? false
  : U extends R["length"]
  ? true
  : GreaterThanBase<T, U, [...R, null]>;
```

## [zip](https://github.com/type-challenges/type-challenges/blob/main/questions/04471-medium-zip/README.md)

```typescript
// todo
```

## [is tuple](https://github.com/type-challenges/type-challenges/blob/main/questions/04484-medium-istuple/README.md)

```typescript
// todo
```

## [chunk](https://github.com/type-challenges/type-challenges/blob/main/questions/04499-medium-chunk/README.md)

```typescript
// todo
```

## [fill](https://github.com/type-challenges/type-challenges/blob/main/questions/04518-medium-fill/README.md)

```typescript
// todo
```

## [trim right](https://github.com/type-challenges/type-challenges/blob/main/questions/04803-medium-trim-right/README.md)

```typescript
// todo
```

## [without](https://github.com/type-challenges/type-challenges/blob/main/questions/05117-medium-without/README.md)

```typescript
// todo
```

## [trunc](https://github.com/type-challenges/type-challenges/blob/main/questions/05140-medium-trunc/README.md)

```typescript
// todo
```

## [index of](https://github.com/type-challenges/type-challenges/blob/main/questions/05153-medium-indexof/README.md)

```typescript
// todo
```

## [join](https://github.com/type-challenges/type-challenges/blob/main/questions/05310-medium-join/README.md)

```typescript
// todo
```

## [last index of](https://github.com/type-challenges/type-challenges/blob/main/questions/05317-medium-lastindexof/README.md)

```typescript
// todo
```

## [unique](https://github.com/type-challenges/type-challenges/blob/main/questions/05360-medium-unique/README.md)

```typescript
// todo
```

## [map types](https://github.com/type-challenges/type-challenges/blob/main/questions/05821-medium-maptypes/README.md)

```typescript
// todo
```

## [construct tuple](https://github.com/type-challenges/type-challenges/blob/main/questions/07544-medium-construct-tuple/README.md)

```typescript
// todo
```

## [number range](https://github.com/type-challenges/type-challenges/blob/main/questions/08640-medium-number-range/README.md)

```typescript
// todo
```

## [combination](https://github.com/type-challenges/type-challenges/blob/main/questions/08767-medium-combination/README.md)

```typescript
// todo
```

## [subsequence](https://github.com/type-challenges/type-challenges/blob/main/questions/08987-medium-subsequence/README.md)

```typescript
// todo
```
