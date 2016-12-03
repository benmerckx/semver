package semver;

using tink.CoreApi;

typedef PartialVerData = {
  var major: Option<Int>;
  var minor: Option<Int>;
  var patch: Option<Int>;
  var prerelease: Option<Array<String>>;
}

@:forward
abstract PartialVer(PartialVerData) from PartialVerData {

  public function new()
    this = {
      major: None,
      minor: None,
      patch: None,
      prerelease: None
    }
  
  @:from
  static function fromString(str: String)
    return new PartialVerParser(str).partial();
    
}