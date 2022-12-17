---
title: RxJSのflatteners
tags: rxjs
layout: post
---

整理する。

| xx     | xxMap     | xxMapTo     | xxAll     |
| ------ | --------- | ----------- | --------- |
| merge  | mergeMap  | mergeMapTo  | mergeAll  |
| concat | concatMap | concatMapTo | concatAll |
| -      | switchMap | switchMapTo | switchAll |

observable を 2 つ用意する。

```typescript
const number$ = interval(1000).pipe(take(5));

const alphabet$ = interval(1000).pipe(
  take(5),
  map((i) => String.fromCharCode(65 + i))
);
```

observable を出力する処理は全て以下で統一する。

```typescript
import { DateTime } from "luxon";

observable.subscribe((v) =>
  console.log(`${DateTime.now().toFormat("mm:ss")}  ${v}`)
);
```

出力結果はそれぞれ以下のとおり。

`number$`

```
13:14  0
13:15  1
13:16  2
13:17  3
13:18  4
```

`alphabet$`

```
07:20  A
07:21  B
07:22  C
07:23  D
07:24  E
```

# xx

## merge

```typescript
merge(alphabet$, number$);
```

```
14:45  A
14:45  0
14:46  B
14:46  1
14:47  C
14:47  2
14:48  D
14:48  3
14:49  E
14:49  4
```

```
.ABCDE
.01234
```

## concat

```typescript
concat(alphabet$, number$);
```

```
17:01  A
17:02  B
17:03  C
17:04  D
17:05  E
17:06  0
17:07  1
17:08  2
17:09  3
17:10  4
```

```
.ABCDE-----
-----.01234
```

# xxMap

## mergeMap

```typescript
alphabet$.pipe(
  mergeMap((alphabet) => number$.pipe(map((number) => `${alphabet} ${number}`)))
);
```

```
31:39  A 0
31:40  A 1
31:40  B 0
31:41  A 2
31:41  C 0
31:41  B 1
31:42  A 3
31:42  C 1
31:42  D 0
31:42  B 2
31:43  E 0
31:43  A 4
31:43  C 2
31:43  D 1
31:43  B 3
31:44  E 1
31:44  C 3
31:44  D 2
31:44  B 4
31:45  E 2
31:45  C 4
31:45  D 3
31:46  E 3
31:46  D 4
31:47  E 4
```

```
A: .01234----
B: -.01234---
C: --.01234--
D: ---.01234-
E: ----.01234
```

## concatMap

```typescript
alphabet$.pipe(
  concatMap((alphabet) =>
    number$.pipe(map((number) => `${alphabet} ${number}`))
  )
);
```

```
29:41  A 0
29:42  A 1
29:43  A 2
29:44  A 3
29:45  A 4
29:46  B 0
29:47  B 1
29:48  B 2
29:49  B 3
29:50  B 4
29:51  C 0
29:52  C 1
29:53  C 2
29:54  C 3
29:55  C 4
29:56  D 0
29:57  D 1
29:58  D 2
29:59  D 3
30:00  D 4
30:01  E 0
30:02  E 1
30:03  E 2
30:04  E 3
30:05  E 4
```

```
A: .01234--------------------
B: -----.01234---------------
C: ----------.01234----------
D: ---------------.01234-----
E: --------------------.01234
```

## switchMap

```typescript
alphabet$.pipe(
  switchMap((alphabet) =>
    number$.pipe(map((number) => `${alphabet} ${number}`))
  )
);
```

```
36:20  E 0
36:21  E 1
36:22  E 2
36:23  E 3
36:24  E 4
```

```
A: .*****----
B: -.*****---
C: --.*****--
D: ---.*****-
E: ----.01234
```

`*`: switched(canceled)

# xxMapTo

## mergeMapTo

```typescript
alphabet$.pipe(mergeMapTo(number$));
```

```
39:08  0
39:09  1
39:09  0
39:10  0
39:10  2
39:10  1
39:11  1
39:11  3
39:11  0
39:11  2
39:12  2
39:12  4
39:12  0
39:12  1
39:12  3
39:13  3
39:13  1
39:13  2
39:13  4
39:14  4
39:14  2
39:14  3
39:15  3
39:15  4
39:16  4
```

```
A: .01234----
B: -.01234---
C: --.01234--
D: ---.01234-
E: ----.01234
```

## concatMapTo

```typescript
alphabet$.pipe(concatMapTo(number$));
```

```
40:12  0
40:13  1
40:14  2
40:15  3
40:16  4
40:17  0
40:18  1
40:19  2
40:20  3
40:21  4
40:22  0
40:23  1
40:24  2
40:25  3
40:26  4
40:27  0
40:28  1
40:29  2
40:30  3
40:31  4
40:32  0
40:33  1
40:34  2
40:35  3
40:36  4
```

```
A: .01234--------------------
B: -----.01234---------------
C: ----------.01234----------
D: ---------------.01234-----
E: --------------------.01234
```

## switchMapTo

```typescript
alphabet$.pipe(switchMapTo(number$));
```

```
41:14  0
41:15  1
41:16  2
41:17  3
41:18  4
```

```
A: .*****----
B: -.*****---
C: --.*****--
D: ---.*****-
E: ----.01234
```

`*`: switched(canceled)

# xxAll

まずこれらの operator を使わない場合に message が observable である状態を確認する。

```typescript
alphabet$.pipe(mapTo(number$));
```

```
42:11  [object Object]
42:12  [object Object]
42:13  [object Object]
42:14  [object Object]
42:15  [object Object]
```

```
A: o----
B: -o---
C: --o--
D: ---o-
E: ----o
```

`o`: observable

## mergeAll

```typescript
alphabet$.pipe(mapTo(number$), mergeAll());
```

```
44:28  0
44:29  0
44:29  1
44:30  1
44:30  0
44:30  2
44:31  2
44:31  1
44:31  3
44:31  0
44:32  3
44:32  2
44:32  0
44:32  4
44:32  1
44:33  4
44:33  3
44:33  1
44:33  2
44:34  4
44:34  2
44:34  3
44:35  3
44:35  4
44:36  4
```

```
A: .01234----
B: -.01234---
C: --.01234--
D: ---.01234-
E: ----.01234
```

## concatAll

```typescript
alphabet$.pipe(mapTo(number$), concatAll());
```

```
46:09  0
46:10  1
46:11  2
46:12  3
46:13  4
46:14  0
46:15  1
46:16  2
46:17  3
46:18  4
46:19  0
46:20  1
46:21  2
46:22  3
46:23  4
46:24  0
46:25  1
46:26  2
46:27  3
46:28  4
46:29  0
46:30  1
46:31  2
46:32  3
46:33  4
```

```
A: .01234--------------------
B: -----.01234---------------
C: ----------.01234----------
D: ---------------.01234-----
E: --------------------.01234
```

## switchAll

```typescript
alphabet$.pipe(mapTo(number$), switchAll());
```

```
47:08  0
47:09  1
47:10  2
47:11  3
47:12  4
```

```
A: .*****----
B: -.*****---
C: --.*****--
D: ---.*****-
E: ----.01234
```

`*`: switched(canceled)
