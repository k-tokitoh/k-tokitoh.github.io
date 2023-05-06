---
title: 多重ディスパッチとvisitorパターン
layout: post
---

処理を、組み合わせによって決定したい場合がある。

例として、人と動物が出会ったときに以下の組み合わせで出来事が生じることを考える。

|          | 犬         | 猫           |
| -------- | ---------- | ------------ |
| いい人   | 尻尾を振る | にゃあと鳴く |
| わるい人 | 吠える     | 逃げる       |

# まずはナイーブに

`if`分岐で実装すると以下になる。[^1]

[^1]: 普段書かないのだが、オーバーロードでシグネチャごとに実装を記述する例を示したかったので java を利用した。typescript のオーバーロードでは複数のシグネチャを定義しても実装はひとつしか与えることができない。

```java
import java.util.Random;

interface Man {
}

class Good implements Man {
}

class Evil implements Man {
}

interface Animal {
}

class Dog implements Animal {
}

class Cat implements Animal {
}

class Main {
  static void contact(Man man, Animal animal) {
    if (man instanceof Good) {
      if (animal instanceof Dog) {
        System.out.println("wag its tail.");
      } else if (animal instanceof Cat) {
        System.out.println("meow.");
      }

    } else if (man instanceof Evil) {
      if (animal instanceof Dog) {
        System.out.println("bark.");
      } else if (animal instanceof Cat) {
        System.out.println("escape.");
      }
    }
  }

  public static void main(String[] args) {
    Man[] men = { new Good(), new Evil() };
    Animal[] animals = { new Dog(), new Cat() };
    Random rand = new Random();

    for (int i = 1; i <= 10; i++) {
      System.out.println("==========");
      Man man = men[rand.nextInt(men.length)];
      Animal animal = animals[rand.nextInt(animals.length)];
      System.out.print(man.getClass().getSimpleName() + " & " + animal.getClass().getSimpleName() + "-> ");
      contact(man, animal);
    }
  }
}
```

しかしこういう`if`分岐だとつらくなってくる。

ひとつのメソッドの中で分岐するのではなく、予め別の処理として記述しておき、呼び出したときに然るべき処理を選定(=dispatch)して実行できたら嬉しい。

もし 2 つのオブジェクト（人と動物）の組み合わせではなく 1 つのオブジェクト（人）によって処理が決まるなら、ポリモーフィズムを利用して`Good`/`Evil`それぞれにメソッドを定義すれば上記は実現できる。

しかしレシーバは 1 つしかないので、それではテーブルの行の方の分岐しかできない。

2 つのオブジェクトの組み合わせ（テーブルの行と列）を一気に判定して、然るべきセルの処理を選定することはできないだろうか...?

（この「複数のオブジェクトに基づいて処理を選定すること」を多重ディスパッチと呼ぶ。）

# 言語レベルでの多重ディスパッチのサポート

一部のプログラミング言語では、この多重ディスパッチが言語レベルでサポートされている。

以下は common lisp の例である。

```commonlisp
(defclass man ()
  ())

(defclass good (man)
  ())

(defclass evil (man)
  ())

(defclass animal ()
  ())

(defclass dog (animal)
  ())

(defclass cat (animal)
  ())

(defgeneric contact (man animal))

(defmethod contact ((man good) (animal dog))
  (format t "wag its tail.~%"))

(defmethod contact ((man evil) (animal dog))
  (format t "bark.~%"))

(defmethod contact ((man good) (animal cat))
  (format t "meow.~%"))

(defmethod contact ((man evil) (animal cat))
  (format t "escape.~%"))

(defparameter *man-list* (list 'good 'evil))

(defun random-element (lst)
  (nth (random (length lst)) lst))

(defun main ()
  (loop repeat 5 do
        (let* ((man (make-instance (random-element *man-list*))))
          (format t "==========~%")
          (contact man (make-instance 'dog))
          (contact man (make-instance 'cat))
          )))

(main)
```

便利である。

# オーバーロード？

残念ながら多くのプログラミング言語では、言語レベルで多重ディスパッチがサポートされていない。

どうにかすることを考えてみよう。

まずは先述のように、レシーバをポリモーフィックに扱うことで行の分岐を実現してみる。

```java
import java.util.Random;

interface Man {
  public void contact(Animal animal);
}

class Good implements Man {
  @Override
  public void contact(Animal animal) {
    if (animal instanceof Dog) {
      System.out.println("wag its tail.");
    } else if (animal instanceof Cat) {
      System.out.println("meow.");
    }
  }
}

class Evil implements Man {
  @Override
  public void contact(Animal animal) {
    if (animal instanceof Dog) {
      System.out.println("bark.");
    } else if (animal instanceof Cat) {
      System.out.println("escape.");
    }
  }
}

interface Animal {
}

class Dog implements Animal {
}

class Cat implements Animal {
}

class Main {
  public static void main(String[] args) {
    Man[] men = { new Good(), new Evil() };
    Animal[] animals = { new Dog(), new Cat() };
    Random rand = new Random();

    for (int i = 1; i <= 10; i++) {
      System.out.println("==========");
      Man man = men[rand.nextInt(men.length)];
      Animal animal = animals[rand.nextInt(animals.length)];
      System.out.print(man.getClass().getSimpleName() + " & " + animal.getClass().getSimpleName() + "-> ");
      man.contact(animal);
    }
  }
}
```

さらに`if`分岐をなくすためには、`Good#contact`, `Evil#contact`のそれぞれで、引数に応じて実装を分けられたらよいのだが...。

ひょっとしてオーバーロードが利用できるのではないか？試しに書いてみよう。

```java
interface Man {
  public void contact(Animal animal);
}

class Good implements Man {
  public void contact(Dog dog) {
    System.out.println("wag its tail.");
  }

  public void contact(Cat cat) {
    System.out.println("meow.");
  }
}
```

`Man#contact`は呼び出すために必要なので定義している。

しかしこれだと、`Man#contact`を正しく implement していないというエラーがでてしまう。

```
The type Good must implement the inherited abstract method Man.contact(Animal)Java(67109264)
```

クラスでは実装を持たせずにメソッドを定義することはできないので、空実装を与えてみる。

```java
class Good implements Man {
  public void contact(Animal animal) {
  };

  public void contact(Dog dog) {
    System.out.println("wag its tail.");
  }

  public void contact(Cat cat) {
    System.out.println("meow.");
  }
}
```

しかしこれだと呼び出しが`Dog`, `Cat`用の処理に振り分けられない。

オーバーロードは利用できないことがわかった。

# 一気にできないなら、ひとつずつ

手元にあるのはやはり、レシーバをポリモーフィックに扱うという手法だけのようだ。

まず`Man`をレシーバとして行の分岐が実現できたのならば、続いてレシーバを`Animal`とすることで、列の分岐を実現すればよいのではないか。

```java
import java.util.Random;

interface Man {
  public void contact(Animal animal);
}

class Good implements Man {
  @Override
  public void contact(Animal animal) {
    animal.like();
  }
}

class Evil implements Man {
  @Override
  public void contact(Animal animal) {
    animal.dislike();
  }
}

interface Animal {
  public void like();
  public void dislike();
}

class Dog implements Animal {
  public void like() {
    System.out.println("wag its tail.");
  };

  public void dislike() {
    System.out.println("bark.");
  };
}

class Cat implements Animal {
  public void like() {
    System.out.println("meow.");
  };

  public void dislike() {
    System.out.println("escape.");
  };
}

class Main {
  public static void main(String[] args) {
    Man[] men = { new Good(), new Evil() };
    Animal[] animals = { new Dog(), new Cat() };
    Random rand = new Random();

    for (int i = 1; i <= 10; i++) {
      System.out.println("==========");
      Man man = men[rand.nextInt(men.length)];
      Animal animal = animals[rand.nextInt(animals.length)];
      System.out.print(man.getClass().getSimpleName() + " & " + animal.getClass().getSimpleName() + "-> ");
      man.contact(animal);
    }
  }
}
```

これでよし。

引数をレシーバにし直すことで段階的にポリモーフィズムを利用して、「複数のオブジェクトに基づく処理の選定」、すなわち多重ディスパッチを実現することができた。

# visitor パターン

この多重ディスパッチを「アルゴリズムとデータ構造の分離」のために活用するのが visitor パターンである。

上の例で「いい人と犬の組み合わせならこの処理」と dispatch していたのと同様に、「このデータ構造にこのアルゴリズムを適用する場合はこの処理」という dispatch を実現する。

例として「出版物というデータ構造」と「引用方式というアルゴリズム」の組み合わせを、visitor パターンにより多重 dispatch する例を示す。

```typescript
interface Citer {
  citeBook(book: Book): string;
  citeOnlineArticle(article: OnlineArticle): string;
}

class APACiter implements Citer {
  citeBook(book: Book): string {
    const { title, author, publisher, year } = book;
    return `${author} (${year}). ${title}. ${publisher}.`;
  }

  citeOnlineArticle(article: OnlineArticle): string {
    const { title, author, website, date } = article;
    return `${author} (${date}). ${title}. ${website}.`;
  }
}

class MLACiter implements Citer {
  citeBook(book: Book): string {
    const { title, author, publisher, year } = book;
    return `${author}. ${title}. ${publisher}, ${year}.`;
  }

  citeOnlineArticle(article: OnlineArticle): string {
    const { title, author, website, date } = article;
    return `${author}. "${title}." ${website}, ${date}.`;
  }
}

interface Publication {
  accept(citer: Citer): string;
}

class Book implements Publication {
  constructor(
    readonly title: string,
    readonly author: string,
    readonly publisher: string,
    readonly year: number
  ) {}

  accept(citer: Citer): string {
    return citer.citeBook(this);
  }
}

class OnlineArticle implements Publication {
  constructor(
    readonly title: string,
    readonly author: string,
    readonly website: string,
    readonly date: string
  ) {}

  accept(citer: Citer): string {
    return citer.citeOnlineArticle(this);
  }
}

const book = new Book(
  "Design Patterns: Elements of Reusable Object-Oriented Software",
  "Gamma, E., Helm, R., Johnson, R., & Vlissides, J.",
  "Addison-Wesley Professional",
  1994
);
const article = new OnlineArticle(
  "The Visitor Design Pattern in Depth",
  "Ian Darwin",
  "https://blogs.oracle.com/javamagazine/post/the-visitor-design-pattern-in-depth",
  "May 6, 2023"
);

const publications = [book, article];
const citers = [new APACiter(), new MLACiter()];

for (let i = 1; i <= 10; i++) {
  const publication =
    publications[Math.floor(Math.random() * publications.length)];
  const citer = citers[Math.floor(Math.random() * citers.length)];
  console.log("==========");

  console.log(
    `${publication.constructor.name} & ${
      citer.constructor.name
    } -> ${publication.accept(citer)}`
  );
}
```

以上！
