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

  public function versions()
    return [this.major, this.minor, this.patch];

  @:from
  static function fromVersions(versions: Array<Int>): PartialVer {
    if (versions.length != 3) throw 'Expected 3 arguments';
    return {
      major: Some(versions[0]),
      minor: Some(versions[1]),
      patch: Some(versions[2]),
      prerelease: None, metadata: None
    }
  }

  public function clone(): PartialVer {
    var copy = new PartialVer();
    copy.major = this.major;
    copy.minor = this.minor;
    copy.patch = this.patch;
    copy.prerelease = this.prerelease;
    copy.metadata = this.metadata;
    return copy;
  }

}