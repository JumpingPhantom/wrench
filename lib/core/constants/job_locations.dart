/// The places a job can be filed against.
///
/// A fixed list rather than free text because `location` is matched by the
/// search query and read straight back out onto the jobs list: typed by hand,
/// "Zone 4", "zone 4" and "Zone4" become three different places and a search
/// for any one of them finds a third of the jobs.
///
/// The strings are stored verbatim on `Job.location` and are deliberately not
/// translated — a location that renamed itself per locale would split one place
/// in two, and a job filed in Arabic would be unfindable in English.
///
/// Adding a place here is all it takes to offer it; nothing reads the list but
/// the picker on the create-job screen.
const jobLocations = <String>[
  "Zone 1",
  "Zone 2",
  "Zone 3",
  "Zone 4",
  "Building A",
  "Building B",
  "Warehouse",
  "Workshop",
  "Yard",
  "Office",
];
