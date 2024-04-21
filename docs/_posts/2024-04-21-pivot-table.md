---
title: pandas集計チートシート
layout: post
---

同じことやるのに方法が色々ありすぎて混乱した...。

# 準備

```python
import seaborn as sns
import pandas as pd

pd.set_option('display.float_format', '{:.3f}'.format)

df = sns.load_dataset("titanic")
```

# 1 軸

## カウント

```python
df.groupby("class").size()
```

```
class
First     216
Second    184
Third     491
```

N/A もグループ化したい場合は引数で指定する。

```python
df.groupby("class", dropna=False).size()
```

## 統計量

平均

```python
df.groupby("class")["age"].mean()
```

```
class
First    38.233
Second   29.878
Third    25.141
```

# 2 軸

ここから色々あってややこしい。

## カウント

### groupby()に引数 2 つ

`unstack()`で multi indexed な series を data frame に変換できる。

```python
pt = df.groupby(["class", "sex"]).size().unstack()
```

```
sex     female  male
class
First       94   122
Second      76   108
Third      144   347
```

### groupby()に引数 1 つ

`groupby()` の後でカラムを絞ってあげる。続く`value_count()`が各 series に対する操作になる。

```python
pt = df.groupby('class')['sex'].value_counts().unstack()
```

```
sex     female  male
class
First       94   122
Second      76   108
Third      144   347
```

### pivot_table()

```python
pt = df.pivot_table(index="class", columns="sex",  aggfunc="size")
```

```
sex     female  male
class
First       94   122
Second      76   108
Third      144   347
```

## 行/列ごとの割合

### pivot table から算出

各行の合計値をもつ series を算出し、その series での除算を列ごとに適用する。

```python
pt.div(pt.sum(axis=1), axis=0)
```

```
sex     female  male
class
First    0.435 0.565
Second   0.413 0.587
Third    0.293 0.707
```

### 「groupby()に引数 1 つ」の途中で集計

```python
df.groupby('class')['sex'].value_counts(normalize=True).unstack()
```

```
sex     female  male
class
First    0.435 0.565
Second   0.413 0.587
Third    0.293 0.707
```

## 総計に対する割合

pivot table から算出する。以下いずれでも OK。

```python
# values で ndarray を取得する。 sum() で全体の合計値が得られる。
pt.div(pt.values.sum())

# 各列の合計を求めて、それを再度合計する
pt.div(pt.sum().sum())
```

```
sex     female  male
class
First    0.105 0.137
Second   0.085 0.121
Third    0.162 0.389
```

## 2 軸で切った各セグメントにおいて、一定の条件を満たすものの割合

### 基本形

`groupby()`に引数を 2 つ与えて、各グループでの集計方法を`apply()`でカスタマイズする形をとる。

- lambda はグループごとに適用され、引数は alive の値が入った series になる
- `x == 'yes'`で mask(=0/1 を要素として条件の適否を表現する series)が得られるので、それに対して`sum()`を呼ぶことで、条件に合致する要素の個数を得られる

```python
df.groupby(["class", "sex"])['alive'].apply(lambda x: (x == 'yes').sum() /len(x)).unstack()
```

```
sex     female  male
class
First    0.968 0.369
Second   0.921 0.157
Third    0.500 0.135
```

### 特殊系

0/1 の値の割合を算出したい場合は `pivot_table()`で mean をとることで簡便に算出できる。

```python
df.pivot_table(index="class", columns="sex", values="survived", aggfunc="mean")
```

```
sex     female  male
class
First    0.968 0.369
Second   0.921 0.157
Third    0.500 0.135
```
