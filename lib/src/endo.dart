// ignore_for_file: unnecessary_new

part of dartz;

typedef A Endo<A>(A a);

Monoid<Endo<A>> endoMi<A>() => monoid(() => (A a) => a, (Endo<A> e1, Endo<A> e2) => (A a) => e1(e2(a)));
final Monoid<Endo<dynamic>> EndoMi = endoMi();

final Monoid<Endo<dynamic>> DualEndoMi = dualMonoid(EndoMi);
Monoid<Endo<A>> dualEndoMi<A>() => dualMonoid(endoMi());
