List<List<T>> transpose<T>(List<List<T>> list) {
  List<List<T>> out = [];
  for (int i = 0; i < list.first.length; i++) {
    if (i >= out.length) out.add(List.filled(list.length, null));
    for (int j = 0; j < list.length; j++) {
      out[i][j] = list[j][i];
    }
  }
  return out;
}
