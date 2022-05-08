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

to be continued.
