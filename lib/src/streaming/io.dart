// ignore_for_file: unnecessary_new

part of dartz_streaming;

class IO {

  static final Conveyor<Free<IOOp<dynamic>, dynamic>, String> stdinReader = Source.eval<Free<IOOp<dynamic>, dynamic>, String?>(io.readln()).repeat().takeWhile((s) => s != null).map((s) => s!);

  static final Conveyor<Free<IOOp<dynamic>, dynamic>, SinkF<Free<IOOp<dynamic>, dynamic>, String>> stdoutWriter = Source.constant(IOM, (String s) => Source.eval_(io.println(s)));

  static Conveyor<Free<IOOp<dynamic>, dynamic>, ChannelF<Free<IOOp<dynamic>, dynamic>, A, A>> stdoutPeeker<A>() => Source.constant(IOM, (A a) => Source.eval(io.println(a.toString()).andThen(IOM.pure(a))));

  static Conveyor<Free<IOOp<dynamic>, dynamic>, UnmodifiableListView<int>> fileReader(String path, [int chunkBytes = 4096]) => Source.resource(
      io.openFile(path, true),
      (FileRef file) => Source.eval<Free<IOOp<dynamic>, dynamic>, UnmodifiableListView<int>>(io.readBytes(file, chunkBytes)).repeat().takeWhile((bytes) => bytes.isNotEmpty),
      (FileRef file) => Source.eval_(io.closeFile(file)));

  static Conveyor<Free<IOOp<dynamic>, dynamic>, String> fileLineReader(String path, [Conveyor<From<UnmodifiableListView<int>>, String>? _decoder, int chunkBytes = 4096]) =>
      fileReader(path, chunkBytes).pipe(_decoder ?? Text.decodeUtf8).pipe(Text.lines);

  static Conveyor<Free<IOOp<dynamic>, dynamic>, SinkF<Free<IOOp<dynamic>, dynamic>, IList<int>>> fileWriter(String path) => Source.resource(
      io.openFile(path, false),
      (FileRef file) => Source.constant(IOM, (IList<int> bytes) => Source.eval_(io.writeBytes(file, bytes))),
      (FileRef file) => Source.eval_(io.closeFile(file)));

  static Function1<Conveyor<Free<IOOp<dynamic>, dynamic>, String>, Conveyor<Free<IOOp<dynamic>, dynamic>, Unit>> fileStringWriter(String path, [Conveyor<From<String>, IList<int>>? _encoder, int bufferCount = 100]) =>
      ((Conveyor<Free<IOOp<dynamic>, dynamic>, String> c) => c.buffer(StringMi, bufferCount).pipe(_encoder ?? Text.encodeUtf8).to(fileWriter(path)));

}
