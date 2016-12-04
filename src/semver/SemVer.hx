package semver;

using tink.CoreApi;

typedef SemVerData = {
  var major: Int;
  var minor: Int;
  var patch: Int;
  var prerelease: Option<Array<String>>;
  var metadata: Option<Array<String>>;
}

@:forward
abstract SemVer(SemVerData) from SemVerData {
  
  @:from
  static function fromString(str: String)
    return new SemVerParser(str).version();

  @:to
  public function toString(): String
    return 
      [this.major, this.minor, this.patch].join('.')
      + formatIdentifiers('-', this.prerelease)
      + formatIdentifiers('+', this.metadata);

  @:allow(semver.PartialVer)
  static function formatIdentifiers(prefix: String, ids: Option<Array<String>>)
    return switch ids {
      case None: '';
      case Some(v): prefix + v.join('.');
    }

  static public function compare(a: SemVer, b: SemVer): Int {
    inline function versions(ver: SemVer)
      return [ver.major, ver.minor, ver.patch];
    var verA = versions(a), verB = versions(b);
    for (i in 0 ... 3)
      if (verA[i] > verB[i]) 
        return 1;
      else if (verA[i] < verB[i]) 
        return -1;
    return compareIdentifiers(a, b);
  }

  static function compareIdentifiers(a: SemVer, b: SemVer): Int {
    function val(input: String): Dynamic {
      var num = Std.parseInt(input);
      return num == null ? input : num;
    }
    switch [a.prerelease, b.prerelease] {
      case [None, None]: return 0;
      case [None, Some(_)]: return 1;
      case [Some(_), None]: return -1;
      case [Some(idsA), Some(idsB)]: 
        var min = idsA.length > idsB.length ? idsB.length : idsA.length;
        for (i in 0 ... min) {
          switch Reflect.compare(val(idsA[i]), val(idsB[i])) {
            case 0:
            case v: return v > 0 ? 1 : -1;
          }
        }
        if (idsA.length > idsB.length) 
          return 1; 
        if (idsA.length < idsB.length) 
          return -1;
    }
    return 0;
  }

	@:op(a > b) 
  static inline function gt(a: SemVer, b: SemVer)
		return compare(a, b) == 1;

	@:op(a >= b) 
  static inline function gteq(a: SemVer, b: SemVer)
		return compare(a, b) != -1;

	@:op(a < b) 
  static inline function lt(a: SemVer, b: SemVer)
		return compare(a, b) == -1;

	@:op(a <= b) 
  static inline function lteq(a: SemVer, b: SemVer)
		return compare(a, b) != 1;

	@:op(a == b) 
  static inline function eq(a: SemVer, b: SemVer)
		return compare(a, b) == 0;

	@:op(a != b) 
  static inline function neq(a: SemVer, b: SemVer)
		return compare(a, b) != 0;

}