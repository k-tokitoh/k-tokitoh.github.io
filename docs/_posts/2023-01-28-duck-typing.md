---
title: ポリモーフィズムあれこれ
layout: post
---

python の typing.Protocol を知らなくてちょっと調べたついでに、色々気になったのでメモ。

# python

抽象基底クラスの継承を abc モジュールが、duck typing の型サポートを typing.Protocol が提供している。

interface / implement みたいのはなさそう。

(Python 3.10.9, Pylance v2023.1.40, TypeCheckingMode: strict)

## 継承

```python
from abc import ABC, abstractmethod


class Greeter(ABC):
    @abstractmethod
    def greet(self) -> None:
        raise NotImplementedError


class Man(Greeter):
    def greet(self) -> None:
        print("hello")


def doGreet(greeter: Greeter):
    greeter.greet()


doGreet(Man())  # hello
```

悲しいことに、abstract method が実装をもっていてもエラーがでずに実行できてしまう。

```python
class Greeter(ABC):
    @abstractmethod
    def greet(self) -> None:
        print("abstract")
```

また、以下のように具象クラスが abstract method を実装していない場合、呼び出し箇所で始めてエラーがでる。できれば具象クラスの定義でエラーをだしてほしい。

```python
class Greeter(ABC):
    @abstractmethod
    def greet(self) -> None:
        raise NotImplementedError


class Man(Greeter):
    pass


def doGreet(greeter: Greeter):
    greeter.greet()


doGreet(Man())  # TypeError: Can't instantiate abstract class Man with abstract method greet
```

## duck typing

```python
from typing import Protocol


class Greeter(Protocol):
    def greet(self) -> None:
        ...


class Man:
    def greet(self) -> None:
        print("hello")


def doGreet(greeter: Greeter):
    greeter.greet()


doGreet(Man())  # hello
```

こちらも、protocol が実装をもっていてもエラーがでずに実行できてしまう。

```python
class Greeter(Protocol):
    def greet(self) -> None:
        print("protocol")
```

# typescript

抽象基底クラスの継承も、interface / implement も、duck typing もサポートされている。

(typescript 4.6.4, "strict": true)

## 継承

```typescript
abstract class Greeter {
  abstract greet(): void;
}

class Man extends Greeter {
  greet(): void {
    console.log("hello");
  }
}

const doGreet = (greeter: Greeter) => greeter.greet();
doGreet(new Man()); // hello
```

python と違ってうれしいのは以下。

abstract method が実装をもっているとエラーになる。

```typescript
abstract class Greeter {
  abstract greet(): void {
    // Method 'greet' cannot have an implementation because it is marked abstract.ts(1245)
    throw new Error("not implemented.");
  }
}
```

abstract method を実装していない場合も具象クラスの定義でエラーを出してくれる。

```typescript
abstract class Greeter {
  abstract greet(): void;
}

class Man extends Greeter {
  // Non-abstract class 'Man' does not implement inherited abstract member 'greet' from class 'Greeter'.ts(2515)
}
```

## interface / implement

```typescript
interface Greeter {
  greet(): void;
}

class Man implements Greeter {
  greet(): void {
    console.log("hello");
  }
}

const doGreet = (greeter: Greeter) => greeter.greet();
doGreet(new Man()); // hello
```

## duck typing

typescript 自体が structural typing なので、特になにもせずとも duck typing が可能。

```typescript
interface Greeter {
  greet(): void;
}

class Man {
  greet(): void {
    console.log("hello");
  }
}

const doGreet = (greeter: Greeter) => greeter.greet();

doGreet(new Man()); // hello
```

interface が実装をもっているとエラーをだしてくれる、というかそもそも実装を記述することができない。

```typescript
interface Greeter {
  greet(): void {  // ';' expected.ts(1005)
    console.log('interface')
  }
}
```

# まとめ

python の比較は以下。

| abc                                        | 観点                                                             | typing.Protocol |
| ------------------------------------------ | ---------------------------------------------------------------- | --------------- |
| O                                          | 具象クラスの定義で明示したい                                     | X               |
| X                                          | 継承の一般的な扱いにくさ                                         | O               |
| △（適当に wrapper とか書けば全然できそう） | 外部ライブラリなどで定義されたクラスを具象クラスとして利用したい | O               |

python と typescript でいうと以下の点で typescript の方が何かとやりやすそう。

- そもそも python は interface / implement をサポートしていない
- 継承や duck typing についても、typescript の方がより適切に制約をかけてエラーを出してくれる
