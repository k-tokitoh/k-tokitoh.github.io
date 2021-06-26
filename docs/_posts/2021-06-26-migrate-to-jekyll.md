---
title: はてなブログからJekyll on Github Pages に移行した
tags: Jekyll
---

はてなブログから退避したくなった理由は以下。

- データの持ち方及びデプロイサービスとして長期視点で依存するにはやや安定性が低い
  - 入力は markdown だが export は MovableType という形式に限られる..!
- しっくりくるテーマがなく、自前でスタイルを調整するのも面倒...となっていた

移行先として Jekyll on Github Pages を選定した理由は以下。

- Github Pages
  - デプロイサービスとして安定性が十分に高そう
- Jekyll
  - データの持ち方として、markdown なら汎用性が十分に高い
  - スタイルもかなり選択肢が多い/自由度が高い、というか minima で十分しっくりくる

MovableType 形式の post を marddown に移し替えるのが面倒だった。

次の職場で python を書くので、練習としてスクリプトを書いてみた。

ハイライトは以下。

- generator というのを初めて書いてみた
  - 今回程度のデータ量であれば一気にメモリに載せても全然大丈夫だが。
- 元ファイルの post 間のデリミタが 2 行であり、iterator に状態を保持させた方がすっきり書けそうだった
  - "Effective Python"の項目 38 に書いてあったやつだ！となり、`__call__()`メソッドをもつ class として記述してみた

<p>
  <a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873119170">
    <img
      src="https://images-fe.ssl-images-amazon.com/images/P/4873119170.09.MZZZZZZZ.jpg"
      alt="「プロになるためのWeb技術入門」 ――なぜ、あなたはWebシステムを開発できないのか"
    />
  </a>
</p>

```python
import sys
import os
from collections import defaultdict
from datetime import datetime
from random import randint
from textwrap import dedent
from xml import sax
import re
import pip

pip.main(["install", "html2text"])

from html2text import HTML2Text

file_path_from = sys.argv[1]
dir_to = sys.argv[2]


class Meta:
    __attrs = {"DATE", "TITLE", "STATUS"}

    def __init__(self, raw):
        rows = raw.split("\n")
        self.__rows_dict = defaultdict(lambda: None)

        for row in rows:
            key, value = [*row.split(": "), None][0:2]
            if key == "CATEGORY":
                if not self.__rows_dict[key]:
                    self.__rows_dict[key] = []
                self.__rows_dict[key].append(value)
            else:
                self.__rows_dict[key] = value

        for attr in self.__attrs:
            self.__setattr__(attr, self.__rows_dict.get(attr))

        self.date = self.__convert_date(self.__rows_dict["DATE"])
        self.title = self.__escape_title(self.__rows_dict["TITLE"])
        self.status = self.__rows_dict["STATUS"]
        self.tags = self.__rows_dict["CATEGORY"] if self.__rows_dict["CATEGORY"] else []

    def __convert_date(self, date_raw):
        return datetime.strptime(date_raw, "%m/%d/%Y %H:%M:%S")

    def __escape_title(self, title_raw):
        return sax.saxutils.unescape(title_raw, {"&#39;": "'", "&quot;": '\\"'})


class Post:
    def __init__(self, str):
        meta_raw, body_raw = str.split("-----\nBODY:\n")
        self.meta = Meta(meta_raw)
        self.body = self.__convert(body_raw)

    def write(self, dir):
        with open(self.__path_to(dir), "w") as f:
            f.write(self.__text())

    def __convert(self, body_raw):
        body = re.sub(r"-----\nEXTENDED BODY:\n", "", body_raw)
        body = re.sub(
            r"<a class=\"keyword\" href=\"http://d\.hatena\.ne\.jp/keyword/.*\">(.+)</a>",
            r"\1",
            body,
        )

        return self.__sneak_iframe(body, lambda body: HTML2Text().handle(body))

    def __sneak_iframe(self, body, func):
        body = re.sub(
            r"<(/?iframe)",
            r"&lt;\1",
            body,
        )
        markdown = func(body)
        return re.sub(
            r"&lt;(/?iframe)",
            r"<\1",
            markdown,
        )

    def __path_to(self, dir):
        filename = f"{self.meta.date:%Y-%m-%d}-{randint(100_000, 999_999)}.md"
        type_dirs = {"Publish": "_posts", "Draft": "_drafts"}
        return os.path.join(dir, type_dirs[self.meta.status], filename)

    def __text(self):
        return (
            dedent(
                """
            ---
            title: {title}
            tags: {tags}
            ---
            {body}
        """
            )
            .format(
                title=self.meta.title, body=self.body, tags=(" ".join(self.meta.tags))
            )
            .strip()
        )


class PostIter:
    def __init__(self, file):
        self.file = file
        self.flag = False
        self.str = ""

    def __call__(self):
        for row in f:
            if not self.flag:
                self.flag = row == "-----\n"
            if self.flag & (row == "--------\n"):
                str = self.str.rstrip("-\n")
                yield Post(str)
                self.str = ""
                self.flag = False
            self.str += row


with open(file_path_from, "r") as f:
    for post in PostIter(f)():
        post.write(dir_to)
```
