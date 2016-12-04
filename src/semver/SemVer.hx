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

}