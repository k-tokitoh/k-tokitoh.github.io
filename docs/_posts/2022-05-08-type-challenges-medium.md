---
title: type challenges - medium
tags: typescript
layout: post
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
type Last<T extends unknown[]> = T extends [...infer R, infer L] ? L : never;
```

## [pop](https://github.com/type-challenges/type-challenges/blob/main/questions/00016-medium-pop/README.md)

```typescript
type Pop<T extends unknown[]> = T extends [...infer R, infer L] ? R : never;
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

最初の文字が空白ならそれを取り除いて再帰的に呼び出す、最初の文字が空白でなくなった時点でその文字列を返す。

```typescript
type WhiteSpace = " " | "\n" | "\t";
type TrimLeft<S extends string> = S extends `${infer F}${infer R}`
  ? F extends WhiteSpace
    ? TrimLeft<R>
    : S
  : "";
```

## [trim](https://github.com/type-challenges/type-challenges/blob/main/questions/00108-medium-trim/README.md)

infer で最初のを取り出すのは、配列型でも string でもできる。

```typescript
type FirstOfArray<T extends unknown[]> = T extends [infer F, ...infer R]
  ? F
  : never;
type A = FirstOfArray<["a", "b", "c"]>; // "a"

type FirstOfString<T extends string> = T extends `${infer F}${infer R}`
  ? F
  : never;
type X = FirstOfString<"xyz">; // "x"
```

しかし最後のを取り出すのは、配列型ではできるが、string ではできない。

```typescript
type LastOfArray<T extends unknown[]> = T extends [...infer R, infer L] ? L : never
type C = LastOfArray<["a", "b", "c"]>  // "c"

type LastOfString<T extends string> = T extends `${...infer R}, ${infer L}` ? L : never  // error
```

それゆえ TrimLeft と対象に TrimRight を定義することはできなかった。

文字列をひっくり返すことはできそうなので、TrimLeft => Reverse => TrimLeft => Reverse することにした。

```typescript
type WhiteSpace = " " | "\n" | "\t";
type Trim<S extends string> = Reverse<TrimLeft<Reverse<TrimLeft<S>>>>;
type TrimLeft<S extends string> = S extends `${infer F}${infer R}`
  ? F extends WhiteSpace
    ? TrimLeft<R>
    : S
  : "";
type Reverse<
  S extends string,
  A extends string = ""
> = S extends `${infer F}${infer R}` ? Reverse<R, `${F}${A}`> : A;
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

数値の加減乗除はできないので 0 に対する加減算でふつうに絶対値を取得することはできないな。

再帰の回数で数値をインクリメントすることはできるけど、それでは負の値は扱えないな。

設問条件やテストケースから察するに、文字列のパターンマッチでいけばよさそう。

パターンマッチはテンプレートリテラルと infer の組み合わせでできる。

```typescript
type Absolute<T extends number | string | bigint> = `${T}` extends `-${infer A}`
  ? A
  : `${T}`;
```

## [string to union](https://github.com/type-challenges/type-challenges/blob/main/questions/00531-medium-string-to-union/README.md)

これは仕様で、テンプレートリテラルの中で infer を複数連続して用いると、最後以外は一文字ずつバインド、最後に infer された型変数に残りの文字列全体がバインドされるらしい。

```typescript
type First<T extends string> = T extends `${infer F}${infer S}${infer R}`
  ? F
  : never;
type Second<T extends string> = T extends `${infer F}${infer S}${infer R}`
  ? S
  : never;
type Rest<T extends string> = T extends `${infer F}${infer S}${infer R}`
  ? R
  : never;

type first = First<"hello">; // "h"
type second = Second<"hello">; // "e"
type rest = Rest<"hello">; // "llo"
```

文字列が短い場合にはどうなるか。

```typescript
type first_of_he = First<"he">; // "h"
type second_of_he = Second<"he">; // "e"
type rest_of_he = Rest<"he">; // ""

type first_of_h = First<"h">; // never
type second_of_h = Second<"h">; // never
type rest_of_h = Rest<"h">; // never
```

空文字の infer が成り立てば空文字を infer する。空文字の infer さえ成り立たないと割り当て不可能という判定になる。

この性質を利用して一文字ずつ取り出しして、再帰的に union でがっちゃんこしていけばよい。

```typescript
type StringToUnion<T extends string> = StringToUnionBase<T, never>;
type StringToUnionBase<
  T extends string,
  U extends string
> = T extends `${infer F}${infer R}` ? StringToUnionBase<R, U | F> : U;
```

## [merge](https://github.com/type-challenges/type-challenges/blob/main/questions/00599-medium-merge/README.md)

```typescript
// todo
```

## [kebab case](https://github.com/type-challenges/type-challenges/blob/main/questions/00612-medium-kebabcase/README.md)

template literals & infer で一文字ずつとりだして大文字ならハイフンと小文字に置き換えて accumulator として置換後の文字列を伸ばしていけばいい。

大文字の判定なんて便利なものはないので、大文字の union に対する割り当て可能性で判定するしかないだろう。

置換はどうするか？ 別の問題で index を求めるのがあったので、upper/lower それぞれを 26 要素の配列型にしておき、大文字の配列型における index を求めて、小文字の配列型に index signature でアクセスすればよさそう。

```typescript
type Upper = [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z"
];
type Lower = [
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z"
];
type KebabCase<S extends string> = S extends `${infer F}${infer R}`
  ? F extends Upper[number]
    ? KebabCaseBase<R, `${ToLower<F>}`>
    : KebabCaseBase<R, `${F}`>
  : "";
type KebabCaseBase<
  S extends string,
  A extends string
> = S extends `${infer F}${infer R}`
  ? F extends Upper[number]
    ? KebabCaseBase<R, `${A}-${ToLower<F>}`>
    : KebabCaseBase<R, `${A}${F}`>
  : A;
type ToLower<S extends Upper[number]> = Lower[IndexOf<Upper, S>];
type IndexOf<T extends unknown[], U extends unknown> = IndexOfBase<T, U, []>;
type IndexOfBase<T, U, Counter extends null[]> = T extends [infer F, ...infer R]
  ? Equal<F, U> extends true
    ? Counter["length"]
    : IndexOfBase<R, U, [...Counter, null]>
  : -1;
```

という感じで自力クリアしたけど、他の回答みたら Record つかえばこんなややこしいことしないで済むと気づいた...。

```typescript
type Mapper = {
  A: "a";
  B: "b";
  C: "c";
  D: "d";
  E: "e";
  F: "f";
  G: "g";
  H: "h";
  I: "i";
  J: "j";
  K: "k";
  L: "l";
  M: "m";
  N: "n";
  O: "o";
  P: "p";
  Q: "q";
  R: "r";
  S: "s";
  T: "t";
  U: "u";
  V: "v";
  W: "w";
  X: "x";
  Y: "y";
  Z: "z";
};

type KebabCase<S extends string> = S extends `${infer F}${infer R}`
  ? F extends keyof Mapper
    ? KebabCaseBase<R, `${ToLower<F>}`>
    : KebabCaseBase<R, `${F}`>
  : "";
type KebabCaseBase<
  S extends string,
  A extends string
> = S extends `${infer F}${infer R}`
  ? F extends keyof Mapper
    ? KebabCaseBase<R, `${A}-${ToLower<F>}`>
    : KebabCaseBase<R, `${A}${F}`>
  : A;
type ToLower<S extends keyof Mapper> = Mapper[S];
```

そしてさらに UpperCase/LowerCase という utility types があるの、知らなかった..!

```typescript
type KebabCase<S extends string> = S extends `${infer F}${infer R}`
  ? F extends Lowercase<F>
    ? KebabCaseBase<R, `${F}`>
    : KebabCaseBase<R, `${Lowercase<F>}`>
  : "";
type KebabCaseBase<
  S extends string,
  A extends string
> = S extends `${infer F}${infer R}`
  ? F extends Lowercase<F>
    ? KebabCaseBase<R, `${A}${F}`>
    : KebabCaseBase<R, `${A}-${Lowercase<F>}`>
  : A;
```

注意すべきは以下。

- 大文字/小文字は`C extends Uppercase<C>` or `C extends Lowercase<C>`で判定する訳だが、alphabet 以外は常にこれらが成り立つ
- よって「`C extends Lowercase<C>`が成り立つ小文字と記号は置換しない、成り立たない文字=大文字を置換する」という処理にする

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

union の場合にのみ union distribution が発生することを利用する。テクいな...。

```typescript
type IsUnion<T> = IsUnionBase<T, T>;
type IsUnionBase<T, C> = T extends infer TN
  ? [C] extends [TN]
    ? false
    : true
  : never;
```

T が`string | number`なら TN には`string`, `number`がそれぞれ分配してバインドされる。

これらが元の`string | number`と一致しないということを炙り出したい。

`TN extends C`だと一致しないけど割り当て可能と判定されてしまうので、TN(`string`)を extends の右側、C(`string | number`)を extends の左側に書くことに注意する。

しかしシンプルに`C extends TN`と書くと C(`string | number`)が分配されてしまい、

```typescript
string extends string ? true : false | number extends string ? true : false
```

すなわち`true | false`を返してしまう。

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

template literals と infer を用いたマッチングで素直にできる。

```typescript
type StartsWith<T extends string, U extends string> = T extends `${U}${infer R}`
  ? true
  : false;
```

## [ends with](https://github.com/type-challenges/type-challenges/blob/main/questions/02693-medium-endswith/README.md)

starts with と同様。

```typescript
type EndsWith<T extends string, U extends string> = T extends `${infer R}${U}`
  ? true
  : false;
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

続いて M も。これで完成。

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

配列の型を一気に得ることはできないので、どれかの配列をベースにして再帰的に組み立てる必要がある。

型引数を T, U とした場合、

- U を回すと、「この要素を T からすべて除く」操作が必要だが、それはできなさそう
- T を回すと、「この要素が U に含まれていたら除く」操作が必要、それはできそう

```typescript
type Without<
  T extends number[],
  U extends number | number[]
> = U extends number[]
  ? WithoutBase<T, U[number], []>
  : U extends number
  ? WithoutBase<T, U, []>
  : never;
type WithoutBase<
  T extends number[],
  U extends number,
  V extends number[]
> = T extends [infer F, ...infer R]
  ? F extends U
    ? R extends number[]
      ? WithoutBase<R, U, V>
      : never
    : R extends number[]
    ? F extends number
      ? WithoutBase<R, U, [...V, F]>
      : never
    : never
  : V;
```

`number | number[]`を`extends number`で分岐したときに、割り当て不可能な方を`number[]`と推論してくれないみたい。

なのでそういう箇所で conditional type を再度書いて推論を効かせるということをたくさんやる羽目になってしまった。

どうも`unknown | unknown[]`にしているとこの問題は回避できるらしい。仕様？

```typescript
type Without<
  T extends unknown[],
  U extends unknown | unknown[]
> = U extends unknown[] ? WithoutBase<T, U[number], []> : WithoutBase<T, U, []>;
type WithoutBase<
  T extends unknown[],
  U extends unknown,
  V extends unknown[]
> = T extends [infer F, ...infer R]
  ? F extends U
    ? WithoutBase<R, U, V>
    : WithoutBase<R, U, [...V, F]>
  : V;
```

## [trunc](https://github.com/type-challenges/type-challenges/blob/main/questions/05140-medium-trunc/README.md)

```typescript
// todo
```

## [index of](https://github.com/type-challenges/type-challenges/blob/main/questions/05153-medium-indexof/README.md)

一発で配列の中身を走査することはできないので、再帰で回す方針とする。

index を出力するために、呼び出しごとに値をインクリメントする必要がある。しかし値を+1 することはできないので、代わりに配列型を用意して要素をひとつずつ追加していき、一致する要素がみつかった時点でその配列型の length を返す。

```typescript
type IndexOf<T extends unknown[], U extends unknown> = IndexOfBase<T, U, []>;
type IndexOfBase<T, U, Counter extends null[]> = T extends [infer F, ...infer R]
  ? Equal<F, U> extends true
    ? Counter["length"]
    : IndexOfBase<R, U, [...Counter, null]>
  : -1;
```

## [join](https://github.com/type-challenges/type-challenges/blob/main/questions/05310-medium-join/README.md)

一発で join した型を得ることはできなそうなので再帰でやる。

```typescript
type Delimiter = string | number;
type Join<T extends string[], D extends Delimiter> = T extends [
  infer F,
  ...infer R
]
  ? F extends string
    ? R extends string[]
      ? JoinBase<R, D, F>
      : never
    : never
  : never;
type JoinBase<
  T extends string[],
  D extends Delimiter,
  A extends string
> = T extends [infer F, ...infer R]
  ? F extends string
    ? R extends string[]
      ? JoinBase<R, D, `${A}${D}${F}`>
      : never
    : never
  : A;
```

F, R を infer したときにそれぞれ`string`, `string[]`と推論してくれないようなので追って extends で推論させることで再帰呼び出しを可能にした。

unknown とかをつかったら以下のとおり少し減らせたけど、多少は extends で型を推論させることが必要と思われる。

```typescript
type Delimiter = string | number;
type Join<T extends unknown[], D extends Delimiter> = T extends [
  infer F,
  ...infer R
]
  ? F extends string
    ? JoinBase<R, D, F>
    : never
  : never;
type JoinBase<
  T extends unknown[],
  D extends Delimiter,
  A extends string
> = T extends [infer F, ...infer R]
  ? F extends string
    ? JoinBase<R, D, `${A}${D}${F}`>
    : never
  : A;
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
