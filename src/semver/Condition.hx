package semver;

using tink.CoreApi;

typedef Range = Array<Pair<Op, PartialVer>>;

enum Comparator {
  Greater;
  Less;
  Equal;
}