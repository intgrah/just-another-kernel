const std = @import("std");
const util = @import("util.zig");
const BigUint = @import("big_uint.zig").BigUint;
const smp_allocator = util.smp_allocator;

pub fn natAdd(x: BigUint, y: BigUint) BigUint {
    var mx = x;
    var my = y;
    var r = BigUint.init(smp_allocator) catch @panic("oom");
    r.add(&mx, &my) catch @panic("oom");
    return r;
}

pub fn natMul(x: BigUint, y: BigUint) BigUint {
    var mx = x;
    var my = y;
    var r = BigUint.init(smp_allocator) catch @panic("oom");
    r.mul(&mx, &my) catch @panic("oom");
    return r;
}

pub fn natPow(x: BigUint, y: BigUint) ?BigUint {
    var mx = x;
    var my = y;
    const e = my.toConst().toInt(u32) catch return null;
    var r = BigUint.init(smp_allocator) catch @panic("oom");
    r.pow(&mx, e) catch @panic("oom");
    return r;
}

pub fn natEq(x: BigUint, y: BigUint) bool {
    var mx = x;
    return mx.eql(y);
}

pub fn natLe(x: BigUint, y: BigUint) bool {
    var mx = x;
    return mx.order(y) != .gt;
}

pub fn natSub(x: BigUint, y: BigUint) BigUint {
    if (y.order(x) == .gt) {
        return bigZero();
    }
    var r = BigUint.init(std.heap.smp_allocator) catch @panic("oom");
    r.sub(&x, &y) catch @panic("oom");
    return r;
}

pub fn natDiv(x: BigUint, y: BigUint) BigUint {
    if (y.eqlZero()) {
        return bigZero();
    }
    var q = BigUint.init(std.heap.smp_allocator) catch @panic("oom");
    var rem = BigUint.init(std.heap.smp_allocator) catch @panic("oom");
    q.divFloor(&rem, &x, &y) catch @panic("oom");
    rem.deinit();
    return q;
}

pub fn natMod(x: BigUint, y: BigUint) BigUint {
    if (y.eqlZero()) {
        return x.clone() catch @panic("oom");
    }
    var q = BigUint.init(std.heap.smp_allocator) catch @panic("oom");
    var rem = BigUint.init(std.heap.smp_allocator) catch @panic("oom");
    q.divFloor(&rem, &x, &y) catch @panic("oom");
    q.deinit();
    return rem;
}

pub fn natGcd(x: *const BigUint, y: *const BigUint) BigUint {
    var r = BigUint.init(std.heap.smp_allocator) catch @panic("oom");
    r.gcd(x, y) catch @panic("oom");
    return r;
}

pub fn natXor(x: *const BigUint, y: *const BigUint) BigUint {
    var r = BigUint.init(std.heap.smp_allocator) catch @panic("oom");
    r.bitXor(x, y) catch @panic("oom");
    return r;
}

pub fn natShl(x: BigUint, y: BigUint) ?BigUint {
    const sh = y.toConst().toInt(usize) catch return null;
    var r = BigUint.init(std.heap.smp_allocator) catch @panic("oom");
    r.shiftLeft(&x, sh) catch @panic("oom");
    return r;
}

pub fn natShr(x: BigUint, y: BigUint) ?BigUint {
    const sh = y.toConst().toInt(usize) catch return null;
    var r = BigUint.init(std.heap.smp_allocator) catch @panic("oom");
    r.shiftRight(&x, sh) catch @panic("oom");
    return r;
}

pub fn natLand(x: BigUint, y: BigUint) BigUint {
    var r = BigUint.init(std.heap.smp_allocator) catch @panic("oom");
    r.bitAnd(&x, &y) catch @panic("oom");
    return r;
}

pub fn natLor(x: BigUint, y: BigUint) BigUint {
    var r = BigUint.init(std.heap.smp_allocator) catch @panic("oom");
    r.bitOr(&x, &y) catch @panic("oom");
    return r;
}

fn bigZero() BigUint {
    return BigUint.init(std.heap.smp_allocator) catch @panic("oom");
}
