/// The four places the bottom bar can take a student, and the whole product.
///
/// An enum rather than an index, because a tab index is a number that means
/// something only to whoever wrote the bar: `currentIndex == 2` is a line no
/// reader can check and every screen has to spell the same way. The order here
/// IS the order on screen, left to right, with the parent button sitting
/// between [rewards] and [progress] — it is not a tab, which is why it is not
/// in this list.
///
/// The design says there will not be a fifth. Adding one means editing this
/// enum, and every `switch` over it stops compiling until it has been thought
/// about — which is the point.
enum AppNavTabEnum { home, rewards, progress, profile }
