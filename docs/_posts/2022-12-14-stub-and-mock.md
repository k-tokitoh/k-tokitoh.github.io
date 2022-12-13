---
title: stub & mock
tags: testing
---

```typescript
export class Ramen {
  constructor(public soup: any = null, public noodle: any = null) {}
}

export class Waiter {
  constructor(private readonly cooker: Cooker) {}

  serve(): Ramen {
    const ramen = this.cooker.cook();
    return ramen;
  }
}

export class Cooker {
  cook(): Ramen {
    return new Ramen("awesome soup", "rich noodle");
  }
}
```

```typescript
test("Ramen is served", () => {
  const cooker = new Cooker();
  const waiter = new Waiter(cooker);
  const served = waiter.serve();
  expect(served).toBeInstanceOf(Ramen);
});
```

stub 導入

```typescript
export interface ICooker {
  cook: () => Ramen;
}

export class Cooker implements ICooker {
  cook(): Ramen {
    return new Ramen("awesome soup", "rich noodle");
  }
}

class CookerStub implements ICooker {
  cook(): Ramen {
    return new Ramen();
  }
}
```

```typescript
test("with cooker stub", () => {
  const cooker = new CookerStub();
  const waiter = new Waiter(cooker);
  const served = waiter.serve();
  expect(served).toBeInstanceOf(Ramen);
});
```

# 副作用

```typescript
export class Slip {
  constructor() {
    this.write(0);
  }

  private get path(): string {
    return "./slip";
  }

  private write(price: number): void {
    fs.writeFileSync(this.path, String(price));
  }

  private read(): number {
    return Number(fs.readFileSync(this.path));
  }

  add(price: number): number {
    const former = this.read();
    const latter = former + price;
    this.write(latter);
    return latter;
  }
}
```

```typescript
export class Waiter {
  constructor(private readonly cooker: Cooker, private readonly slip: Slip) {}

  serve(): Ramen {
    const ramen = this.cooker.cook();
    this.slip.add(600);
    return ramen;
  }
}
```

```typescript
test("assert side effect", () => {
  const cooker = new CookerStub();
  const slip = new Slip();
  const waiter = new Waiter(cooker, slip);
  waiter.serve();

  const price = fs.readFileSync("./slip").toString();
  expect(price).toEqual("600");
});
```

mock をつかう。

```typescript
jest.mock("./slip");
const SlipMock = Slip as jest.Mocked<typeof Slip>;

beforeEach(() => {
  SlipMock.mockClear();
});

test("assert side effect with mock", () => {
  const cooker = new CookerStub();
  const slip = new SlipMock();
  const waiter = new Waiter(cooker, slip);
  waiter.serve();

  const mockSlipAdd = SlipMock.mock.instances[0].add;
  expect(mockSlipAdd).toHaveBeenCalledTimes(1);
  expect(mockSlipAdd).toHaveBeenCalledWith(600);
});
```

mock するオブジェクトが適当な戻り値を返す必要がある場合

```typescript
export class Waiter {
  constructor(private readonly cooker: Cooker, private readonly slip: Slip) {}

  serve(): Ramen {
    const ramen = this.cooker.cook();
    const total = this.slip.add(600);
    if (isNaN(Number(total))) {
      throw Error("total must be number.");
    }
    return ramen;
  }
}
```

エラーになる。

特定のメソッドを、実装を含めて mock する書き方にしてみる。

```typescript
const addMock = jest.spyOn(Slip.prototype, "add").mockImplementation(() => 0);
```

```typescript
test("assert side effect with mock", () => {
  const cooker = new CookerStub();
  const slip = new Slip();
  const waiter = new Waiter(cooker, slip);
  waiter.serve();

  expect(addMock).toHaveBeenCalledTimes(1);
  expect(addMock).toHaveBeenCalledWith(600);
});
```
