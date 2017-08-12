module nemoutils.generator;

class RangeGenerator (alias T, ElementType) {
    ElementType front;
    import core.thread;
    auto yield (ElementType returnType) {
        this.front = returnType;
        fiber.yield;
    }
            
    this () {
        fiber = new Fiber (() { T (&yield); });

        fiber.call;
    }
    auto popFront () {
        fiber.call;
    }
    auto empty () {
        return fiber.state == Fiber.State.TERM;
    }
    Fiber fiber = null;
}

auto genRange (ElementType, string functionBody) () {
    mixin (`return new RangeGenerator!((void delegate (`~ ElementType.stringof ~`) yield) { ` ~ functionBody ~ `}, ` ~ ElementType.stringof ~ `);`);
}

unittest {
    import std.range;
    assert (genRange! (int, q{
        int i = 0;
        while (true) { 
            yield (i);
            i++;
        }
    })
    .take (4).array == [0, 1, 2, 3]);
}
