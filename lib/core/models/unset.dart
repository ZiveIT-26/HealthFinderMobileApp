/// Marker for `copyWith` parameters of nullable fields.
///
/// `copyWith(note: null)` must clear the note, while `copyWith()` must keep
/// it. A plain nullable parameter cannot tell the two apart, so such
/// parameters default to [unset] instead.
const Object unset = _Unset();

class _Unset {
  const _Unset();
}

/// Returns [current] when [value] is [unset], otherwise [value] cast to [T].
T pick<T>(Object? value, T current) =>
    identical(value, unset) ? current : value as T;
