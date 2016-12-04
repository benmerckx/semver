package semver;

using tink.CoreApi;

typedef PartialVerData = {
  var major: Option<Int>;
  var minor: Option<Int>;
  var patch: Option<Int>;
  var prerelease: Option<Array<String>>;
  var metadata: Option<Array<String>>;
}

@:forward
abstract PartialVer(PartialVerData) from PartialVerData {

  public function new()
    this = {
      major: None,
      minor: None,
      patch: None,
      prerelease: None,
      metadata: None
    }
  
  @:from
  static function fromString(str: String)
    return new PartialVerParser(str).partial();
  
  @:to
  public function toString(): String {
    var response = new StringBuf();
    for (num in [this.major, this.minor, this.patch]) {
      if (response.length > 0)
        response.add('.');
      switch num {
        case Some(ver): 
          response.add(ver);
        case None:
          response.add('*');
          return response.toString();
      }
    }
    response.add(SemVer.formatIdentifiers('-', this.prerelease));
    response.add(SemVer.formatIdentifiers('+', this.metadata));
    return response.toString();
  }

}