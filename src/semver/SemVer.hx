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
    
}