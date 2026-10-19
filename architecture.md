# Architecture

[CLAUDE.md](CLAUDE.md) is the rule list — what you must do. This file is the
reasoning: why the boundaries sit where they do, and what breaks when one is
crossed. When the two disagree, CLAUDE.md wins and this file needs an edit.

This is the Recipely architecture in Dart. The layer names, the
`Either` / `Failure` contract, the port naming and the "one declaration per
file" rule are the same ideas; what changed is the state container — a Zustand
store becomes a `Cubit`, and a hand-rolled DI container becomes `get_it` +
`injectable`.

The page-based Cubit layout, `RoutePath` and `either_dart` come from the
`halleder` codebases (`halleder-core-dev`, `halleder-cubit-refactor`), so a
developer moving between the two projects reads the same shapes.

---

## The dependency rule

```
core ← domain ← application ← infrastructure
                    ↑              ↑
                    └─ presentation ┘
```

Arrows point at what a layer may import. Nothing points back up.

| Layer | Holds | May import |
|---|---|---|
| `core/` | `Failure`, named constants | nothing |
| `domain/` | entities, value objects, repository **interfaces** | `core` |
| `application/` | use cases, Cubits + states, DI wiring | `core`, `domain` |
| `infrastructure/` | repository implementations, DTOs, mappers, config | `core`, `domain` |
| `presentation/` | widgets, pages, router, theme, l10n | `core`, `domain`, `application` |

**`presentation` never imports `infrastructure`.** A widget that constructs a
repository has skipped the use case, and with it the failure handling the use
case exists to do. The composition root (`application/di/`) is the one place
allowed to know about both — that is what a composition root is for.

The payoff is concrete: `domain/` and `application/` have no Flutter import at
all, so they test in milliseconds with no widget tree, no device and no network.

## Errors are values, not control flow

`domain/` and `application/` do not throw. They return `Either<Failure, T>` from
`either_dart` — `Left` is the failure, `Right` the value, and because `Either`
is `sealed` a `switch` over an outcome is exhaustive and a caller that ignores
the failure case does not compile. An exception is invisible in a signature and
lands wherever a `try` happens to be.

`Either` rather than a hand-rolled `Result`: it is the type `halleder-core`
already uses, so the two codebases read alike, and it arrives with `fold`,
`map` and `then` for the places where only one branch does work. `switch` stays
the default where both branches produce state.

A `Failure` carries a **`messageKey`, never a sentence**. Copy is resolved at
the presentation edge by `failureCopy`, which is the one place that mapping
happens. That is what lets the same failure read differently in Turkish and
English, and lets copy be reworded without touching a use case.

`Failure`'s variants share one file because Dart requires a `sealed` type's
subtypes to live in its library — the single place the one-declaration-per-file
rule gives way, and it gives way to the language rather than to convenience.

## One Cubit per page; it orchestrates and does not compute

A `Cubit` is Recipely's Zustand store: it holds state, calls use cases, and
emits. What it must not do is decide anything a lower layer owns.

**One per page, named after the page**, in `application/<feature>/cubit/<page>/`. Named
for the feature instead, a Cubit is renamed the first time the page grows a
second thing — home will carry the day's tasks and the point total beside the
countdown — or, worse, it is not renamed and three Cubits end up sharing one
screen's state with no one owning the whole of it. The page is the unit that
actually has a lifetime: it is created, it is disposed, and the Cubit's timers
and subscriptions die with it.

- **How many days are left** is `ExamCountdownValueObject`'s question. Left in the
  Cubit it would be unreachable from anywhere else, which is how the same
  calculation ends up written twice and differently.
- **Where the date comes from** is the use case's.
- **What words a failure gets** is the presentation's.

State is `sealed`, one variant per thing the page can be showing, and it lives
in the Cubit's library as a `part` — Dart requires a `sealed` type's subtypes to
share its library, and a state is not meaningful away from the Cubit that emits
it. The
alternative — one class with `isLoading`, `failure` and `data` all nullable —
permits "loading AND failed AND has data", a combination nobody designed and
every widget has to guess about. Sealed means the widget's `switch` is
exhaustive, so a state added later cannot silently render as a blank screen.

**A Cubit that owns a timer or a subscription owns cancelling it**, in `close()`.
A ticker owned by a widget outlives the widget on the first navigation that
forgets it, and then emits into a closed stream.

## Ports

A capability the upper layers need and the lower layers provide is declared as
an interface *by the layer that needs it*, and implemented by the one that can.

- A **repository interface** is declared in `domain/`, beside the aggregate it
  loads.
- An **application port** (a hasher, a clock, a notifier) is declared in
  `application/`, because the domain has no opinion about platform services.

Both are named `*Interface` in a `*_interface.dart` file. The suffix is at the
END and spelled out: a leading `I` reads as noise at every use, and an `i_`
prefix sorts the port away from the implementation it describes in a file
listing. The same convention is used in the Recipely repos, on both sides of
the wire.

## Dependency injection

`get_it`, with the graph generated from `@injectable` annotations. Adding a use
case is one annotation rather than an edit to a wiring file that is easy to
forget and impossible to notice.

**Only the composition root and a page's `BlocProvider` may touch `getIt`.**
Everything else takes its dependencies through its constructor. A class that
reaches into the container is a class no test can substitute anything into, and
the boundary the layers exist to draw stops being enforceable.

## Flavors

Two environments, `dev` and `prod`, generated by `flutter_flavorizr` from the
`flavorizr:` block in `pubspec.yaml`. `dev` carries a suffixed application id
(`com.lgsrewardhunt.app.dev`) and its own display name so both can sit on one
device — the alternative is uninstalling one to test the other, which is how a
tester reports a bug against the wrong build.

**There is one `main.dart`, not one per flavor.** The flavor arrives from the
build (`--flavor`, which Flutter surfaces as `appFlavor`), so the two builds run
identical code and cannot drift. A `main_dev.dart` that grows a line
`main_prod.dart` never got is the failure this avoids.

`main.dart` is also the only file outside a layer, and the only one allowed to
see both `infrastructure` and `presentation`. That is why `App` takes its title
and debug-banner flag as constructor arguments: the shell lives in
`presentation/`, which may not import `infrastructure`, so the composition root
resolves those values and hands them down.

Everything that differs between the flavors is read through `AppConfig`
(`infrastructure/config/`), never by switching on `AppConfig.flavor` at the
point of use — a `switch` on the flavor scattered across the codebase is the
same decision spelled in many places, and the first one that is missed is a dev
build talking to production.

Regenerate the native config with `dart run flutter_flavorizr -f` after changing
the block. It rewrites `android/` and `ios/`, so review that diff. The
`instructions:` list in the block is the tool's default set minus every
`flutter:*` step: those write `lib/flavors.dart`, `lib/app.dart`, `lib/pages/`
and `lib/main.dart` at the package root, which is the layout this project
deliberately does not have.

## Localization

Turkish is the **template**, English the translation. The product is for
students sitting a Turkish exam; making English the template would mean every
string is authored twice and the one that ships to almost every user is the
derived one.

The app ships one language. Turkish is not the default of several — it is the
only `.arb` and the pinned locale, because the product is one Turkish exam and a
half-translated interface is worse than one written in the language its readers
speak. Everything else in the repository — identifiers, comments, folder names,
tests — is English, which is the line that keeps a codebase readable to anyone
who joins it and greppable by anyone who does not speak Turkish.

All user-visible copy comes from `AppL10n`. A string literal in a widget is a
string that cannot be translated, and it is invisible until someone switches
language.

Plurals go through ICU (`{days, plural, ...}`) rather than an `if`. Turkish and
English disagree about plural forms, and the zero case is a *different sentence*
here — "0 gün" on exam day is wrong where "Bugün!" is right.

## Comments sit above a declaration, never inside one

Every class, top-level function and constant holder carries one `///` block
above it. Inside the braces there are no comments at all — not a `///` on a
field, not a `//` between two statements. What a member needs said is said in
that one block, naming it: `[examDate] is the day the exam is held.`

Two things follow. A reader gets the whole picture in one place instead of
assembling it from fragments wedged between statements, and the code below reads
as code rather than as prose interrupted by more prose. And the comment that
rots first is exactly the inline one: the statement above it gets edited, the
comment two lines down is not in the hunk anyone is looking at, and it survives
as a confident description of behaviour the code no longer has. A single block
at the top of the declaration is the one place to look when the declaration
changes, so keeping it true is a habit rather than a search.

A block getting long enough to be unwieldy is the signal — the class is doing
too much, and the fix is to split the class, not to scatter the explanation back
through its body.

## Layer first, then one feature list for every layer

The tree is `lib/<layer>/<feature>/`. Layer first, because the layer is the
rule that matters most — what may import what — and a folder that says
`presentation/` makes a wrong import visible in the path itself; a
`features/task/` tree hides four layers behind one name and needs a linter to
say what the folder no longer can.

Before this, each layer grouped differently: domain and application by
feature, Cubits in a separate `cubit/` pile, pages by page, domain rules in
`core/`, the mock's handlers in one `handlers/` folder, and the parent's task
edits under `parent` although they change tasks. Each was reasonable alone;
together they meant "where is the task code?" had five answers. Now it has
one: `task/` in whichever layer you are in.

The list is closed and checked (`tool/check_structure.dart`), because
a list anyone can extend by creating a folder is a list that forks — `tasks/`
beside `task/`, `rewards/` beside `reward/`. A feature is a concept with its
own data or its own read model, not a page: pages are the leaves inside
`presentation/<feature>/pages/`, and the page–feature pairing follows the use
case that gives the page its purpose.

Inside a feature, files are grouped by kind — `entities/`, `value_objects/`,
`interfaces/` and so on — named after the suffix the file already carries. A
flat feature put `task_repository_interface.dart` between
`task_plan_value_object.dart` and `task_repeat_enum.dart`: a port, which is a
promise about the outside world, filed among the values it exchanges. The
kind folder says what a file IS before its name is read, and because each
folder admits exactly one suffix the check can hold it.

## Three domain bases: entity, value object, read model

Every domain type extends one of three bases in `core/base/`, and the base is
where its equality lives. Before them, thirty domain types had no `==` at all
while the docs called half of them "equal by their values" — a claim nothing
enforced.

- `BaseEntity` compares `id` only. Identity is the point of an entity; a
  field-by-field `==` would make an edited task a different task.
- `BaseValueObject<T>` is halleder's value object — `value`, a list of
  `validators`, `valueObject` and `isValid` — with two changes. A broken rule is
  a `Failure` with a `messageKey`, like every other failure here, not an
  exception. And validation runs when asked instead of in the constructor, so
  `SessionValueObject.none` can still be `const`. A composite keeps its parts as
  a record of value objects, so "the password is too weak" is the password's
  rule, written once, and not re-implemented in every form that has one.
- `BaseReadModel` is for what used to be misnamed a value object: a snapshot of
  several entities (the household, the study map, the dashboard). It has no
  invariant to validate, so forcing it into `BaseValueObject` would leave an
  empty `validators` list and a meaningless `value`; it only needs equality by
  content.

## A page is a folder; a route is a `RoutePath`

`presentation/<feature>/pages/<page>/<page>_page.dart` owns the scaffold and the `switch` over
its state, and nothing else. The layouts it can show are files beside it in
one `body/<page>_body.dart`, with `items/`, `app_bar/` and
`modal_bottom_sheet/` for the rest. A page whose bodies are
inlined into one `build` stops being readable at the third state, and the second
page that needs the same card copies it instead of importing it.

Every address is a `RoutePath` in `AppRoutePaths`, built from the one above it.
go_router needs each route spelled twice — the full path to navigate to
(`/tasks/new`) and the segment to register under (`new`) — and hand-writing both
is how they drift, with a mismatch showing up as a route that simply never
matches. `RoutePath` derives both from one declaration: `path()` to navigate,
`pathEnd()` to register. Renaming a parent segment then moves every path beneath
it, because they were never spelled out.

## The design system, and the two halves it arrives in

The UI kit is one design system with two homes. The drawn half lives in the
Claude Design canvas **LGS Ödül Avı** — a UI Kit artboard with eleven sections
and a second artboard carrying the six screens. The half that ships lives here:
`presentation/base/ui/values/` is that kit's foundations,
`presentation/base/ui/widgets/` its components. Neither is a drawing of the other; they are the same decisions
written twice, and the design is where they are decided.

Three consequences follow, and they are the whole discipline.

**The palette is generated, not listed.** An accent is three seeds — a primary,
a reward colour, and a saturated tone — and `AppPalette` derives some forty
tokens from them by mixing towards black, white and the tone. That is not
decoration: it is what makes five themes out of five colours rather than one
theme with a coloured button, because every neutral in the app is a few percent
of the accent. It is also why `ColorScheme.fromSeed` is not used — Material's
tonal palette answers a seed with its own opinion about chroma, and this design
has its own.

**What Material has no word for becomes a `ThemeExtension`, not a constant.**
Points, the earned green, the map's locked stone, the hard edge under a button:
`ColorScheme` has no role for any of them. Written as static constants they
would be right in light mode and wrong in dark, and wrong in four accents out of
five; a widget would have to ask which theme it was in, which is the question
the theme exists to answer for it. As an extension the palette is read the same
way a scheme colour is, it interpolates through a theme change, and it cannot be
reached without a `BuildContext` — so nothing outside a widget tree can quietly
depend on a colour.

`AppPalette.lerp` rebuilds from interpolated seeds rather than interpolating
forty fields. Every token is an affine mix of the three seeds, so a mix of the
outputs and the output of a mix are the same colour: the short version is exact,
not approximate. Across a brightness change there is no such identity — the two
formulas differ — so it snaps at the midpoint instead of inventing a theme that
belongs to neither.

**The component themes carry what Material's widgets can do, and `base/` carries
what they cannot.** A button is 48 high and 16 round because `AppTheme` says so
once. But the thing that makes the primary button look pressable is a solid
five-pixel edge below it and a four-pixel drop when touched, and Material's
elevation model has no way to express that — so `AppButton` is a widget rather
than a `ButtonStyle`. The rule for the next component is the same: theme it if
Material can say it, build it in `base/` if it cannot, and never settle it with
a `style:` argument at a call site, which is a decision made where nobody
looking for it will find it.

One thing to know about the palette as shipped: two contrast pairs sit under the
4.5:1 WCAG asks for small text — a button label on the red accent measures 4.13,
and the muted meta line measures between 3.13 and 4.46 depending on accent and
ground. They are the design's own values, and
`test/presentation/base/ui/values/app_theme_test.dart` pins them at the floor they stand
at today so the numbers cannot quietly get worse while the design decides.

## A file holds one thing, and its name says which

One exported declaration per file is the older half of this rule; the newer half
is that the KIND is spelled out at the end of both the file and the type —
`task_status_enum.dart` holding `TaskStatusEnum`. The file name helps a folder
sort; the type name helps a call site, which is where it matters more, because
`AccentChoiceEnum.pink` announces which vocabulary it belongs to and
`AccentChoice.pink` could be a class, a constant, or anything else. It reads as
bureaucracy until a folder has forty files in it, at which point
`task_status_enum.dart` and `task_entity.dart` sort next to each other and
answer, without being opened, what each is.

The rule is about what a file PUBLISHES, which is why a private helper widget no
longer earns an exemption: `_TaskRowCircle` at the bottom of `app_task_row.dart`
is invisible to anyone searching for the circle, and the day a second row wants
it, the move is a refactor rather than an import. It is now
`app_task_row_circle.dart`, public, in the same folder.

Two exemptions survive because the language leaves no choice. A `sealed` type's
variants must live in its library, so `Failure` is one file and `HomeState` is a
`part` of its Cubit. And a `StatefulWidget` keeps its `State` beside it — that
is Flutter's own shape, and splitting it would publish a class whose whole
purpose is to be private.

## Nothing crosses the network as a map

Every request is a `BaseRequest`, every answer a `BaseResponse`, and both are
`json_serializable` DTOs in `infrastructure/<feature>/dto/`. The point is not
ceremony: a map literal spells its keys, and a key spelled wrong is a 422 that
looks like a server problem. A DTO spells them once, in a file whose whole job
is to be that spelling.

They are two roots rather than one because the directions are not
interchangeable. A response can never be sent; a request is never read back.
One shared ancestor would let either be passed where the other belongs, which is
precisely the mistake the types exist to prevent.

DTOs stop at the repository. What travels upward is an entity, built by a mapper
the repository owns — so a backend that renames `linkCode` costs one line, and
the app above it never knew the name.

The transport itself is a seam. `PayloadCodecInterface` sits between the DTO and
the wire, run by `CryptoInterceptor` on the way out and the way back; today it
passes the body through unchanged, because the mock backend runs in this process
and encrypting to yourself proves nothing. When there is a real backend and a
key exchange, encryption is a second implementation of that interface and one
binding in the container — not a pass over thirty repository methods.

## Constants have homes, and the home is the meaning

Recipely's rule, in Dart. A literal typed at a call site is a value nobody can
find: `0` appears eleven thousand times in a codebase and none of them can be
grepped, so the ones that matter hide among the ones that do not.

The split that makes this workable is by MEANING rather than by type.
`core/constants/` holds quantities that are structural — `ValueConstants.zero`
is an empty count, `CharConstants.empty` an absent string,
`RadixConstants.hexadecimal` a base. `presentation/base/ui/values/` holds
measurements — a padding, a radius, an icon size, an opacity, a control height —
because those are answerable only beside the other measurements they have to
agree with. Putting a spacing step in `core/` would separate it from the ladder
it belongs to; putting `zero` in the theme would suggest it is a measurement
somebody chose.

The rule is enforced rather than remembered. `tool/check_structure.dart` walks
`lib/` and fails on three things it can be certain about: an empty string
literal, a bare number in a widget that is not a named constant's declaration,
and a colour hex outside the palette. It is deliberately narrow — a checker that
cries wolf is one everybody learns to skip — and it runs in CI beside the
analyzer, because Dart has no `no-magic-numbers` lint and a rule with no
mechanism is a preference.

Two consequences worth stating. A value only one screen reads stays in that
screen as a private `static const` — naming it is the point, not publishing it,
and a shared constant read once is a guess about a second caller who may never
arrive. And a vocabulary — a tab, an accent, a subject, a status — is an enum
defined once, so `switch` is exhaustive and a new member fails the build instead
of falling through to a blank screen. `AppNavTab.rewards` reads; `currentIndex
== 1` is a claim the reader has to go and verify.

## Where a new thing goes

| Adding… | Goes in |
|---|---|
| A rule about what a task or reward *is* | `domain/<feature>/*_entity.dart` |
| An action the user can take | `application/<feature>/*_use_case.dart` |
| Page state + orchestration | `application/<feature>/cubit/<page>/<page>_cubit.dart` + `<page>_state.dart` (a `part`) |
| A capability from outside the app | interface in `domain/` or `application/`, impl in `infrastructure/` |
| A word the app branches on | an `abstract final class` of constants in `core/constants/` |
| A user-visible error | a `Failure` variant + a key + a case in `failureCopy` + both ARB files |
| A page | `presentation/<feature>/pages/<page>/<page>_page.dart` + one `body/`, a `RoutePath` in `AppRoutePaths`, a route in `AppRouter` |
| What one page hands the next over a route | `presentation/router/arguments/*_arguments_model.dart` — the route's contract, not either page's |
| A design measurement | `presentation/base/ui/values/app_*.dart` — never a raw number in a widget |
| A named quantity (`0`, `1`, `''`, a separator) | `core/constants/` — `ValueConstants`, `CharConstants`, `RadixConstants` |
| A vocabulary the app switches on | one enum, plus a `*_copy.dart` mapper if it has to be read aloud |
| A colour Material has no name for | a field on `AppPalette`, derived from the accent seeds — never a hex in a widget |
| A widget a second page needs | `presentation/base/ui/widgets/<group>/app_*.dart`, moved there from the page that had it first |

## The rules in full

The numbered rules exactly as CLAUDE.md states them in short. CLAUDE.md is
loaded into every session, so it keeps one line per rule and the reasoning
lives here.

1. **One exported declaration per file, and the file says what it holds.**
   A class, an enum, a painter, a mixin — one per file, and **both the file and
   the type** end in what they are: `task_status_enum.dart` holds
   `TaskStatusEnum`, `app_dashed_border_painter.dart` holds
   `AppDashedBorderPainter`. The suffix is on the type as well as the file
   because a call site only shows the type: `AccentChoiceEnum.pink` says which
   vocabulary it came from where `AccentChoice.pink` could be anything.

   | Kind | File | Example |
   |---|---|---|
   | Entity — has an identity | `*_entity.dart` → `*Entity` | `task_entity.dart` · `TaskEntity` |
   | Value object — equal by its value, validated | `*_value_object.dart` → `*ValueObject extends BaseValueObject<T>` | `email_value_object.dart` |
   | Read model — a snapshot of several entities | `*_read_model.dart` → `*ReadModel extends BaseReadModel` | `household_read_model.dart` |
   | Validator — one check | `*_validator.dart` → `*Validator extends BaseValueValidator<T>` | `not_blank_validator.dart` |
   | Presentation style | `*_style.dart` → `*Style` | `app_button_style.dart` · `AppButtonStyle` |
   | Enum | `*_enum.dart` → `*Enum` | `task_status_enum.dart` · `TaskStatusEnum` |
   | Request DTO | `*_request_dto.dart` → `*RequestDto` | `sign_up_request_dto.dart` |
   | Response DTO | `*_response_dto.dart` → `*ResponseDto` | `parent_response_dto.dart` |
   | Route arguments | `router/arguments/*_arguments_model.dart` → `*ArgumentsModel` | `password_arguments_model.dart` |
   | Port | `*_interface.dart` → `*Interface` | `task_repository_interface.dart` |
   | Painter | `*_painter.dart` → `*Painter` | `app_dashed_border_painter.dart` |
   | Use case | `*_use_case.dart` → `*UseCase` | `read_appearance_use_case.dart` |
   | Cubit / state | `*_cubit.dart` / `*_state.dart` → `*Cubit` / `*State` | `home_cubit.dart` |
   | Page / body | `*_page.dart` / `*_body.dart` → `*Page` / `*Body` | `home_page.dart` · `HomeBody` |
   | Text role | `AppText` + `AppTextTypeEnum` | never a bare `Text` |

   A widget that was a private helper inside another file becomes its own file
   and its own public name: `AppTaskRowCircle`, not `_TaskRowCircle` buried at
   the bottom of `app_task_row.dart`. Two things are exempt, and only because
   the languages demand it: a `sealed` type's variants must share its library
   (`Failure`, `HomeState` as a `part`), and a `StatefulWidget` keeps its
   `State` — Flutter's own idiom, and splitting it would mean publishing the
   state class.

2. **Errors are values.** `domain/` and `application/` never throw; they return
   `Either<Failure, T>` from `either_dart` — `Left` is the failure, `Right` the
   value. `Either` is `sealed`, so a `switch` over `Left`/`Right` is exhaustive
   and `fold` is there when only one branch does work. A `Failure` carries a
   **`messageKey`, never a sentence** — `failureCopy` is the one place a key
   becomes words.

3. **Ports are `*Interface`, in a `*_interface.dart` file.** The suffix goes at
   the END, spelled out. Never a leading `I`.

4. **Domain types own their rules, and each extends its base.** A derivation
   that reads a domain type's fields is a method on that type, not a helper in
   a Cubit or a widget. Three kinds, three bases in `core/base/`, and the gate
   checks every file extends the right one:

   - **Entity → `BaseEntity`.** Tracked by an identity — its own `id`
     (`TaskEntity`), or the one thing it belongs to one-to-one
     (`PointsAccountEntity` answers its child's id) — and equal by that id
     alone: a renamed child is still that child. A static `create()` returning
     `Either<Failure, T>` guards its invariants.
   - **Value object → `BaseValueObject<T>`,** halleder's shape: it wraps
     `value`, lists its `validators` (`BaseValueValidator<T>`, one check each —
     generic ones in `core/validators/`, a feature's own in
     `domain/<feature>/validators/`), and answers `valueObject`
     (`Either<Failure, T>`, the first rule broken) and `isValid`. Equal by
     `value`. A single value is one type (`EmailValueObject`,
     `ParentPinValueObject`); a composite holds its parts as a record of value
     objects and lists `ValidPartsValidator` so the first broken part is the one
     reported (`CredentialsValueObject`, `ChildProfileValueObject`). A factory
     that hands out only valid instances answers
     `valueObject.map((_) => this)`.
   - **Read model → `BaseReadModel`.** A snapshot assembled from several
     entities for one purpose (`HouseholdReadModel`, `StudyMapReadModel`): no
     rules to validate, only derivations; equal by everything it holds, listed
     in `props`.

   A type's home follows who uses it, narrowest first: a domain enum beside
   its concept in `domain/<feature>/`; a widget's enum beside the widget in
   `base/ui/widgets/<group>/`; a type only one page uses at that page's root
   (`presentation/auth/pages/intro/intro_slide_enum.dart`); what two pages share over a route in
   `router/arguments/`.

5. **One Cubit per PAGE, named after the page.** `application/<feature>/cubit/<page>/`
   holds `<page>_cubit.dart` and its `<page>_state.dart` as a `part`. Named for
   the page, not the feature filling it today: home will grow tasks and points
   beside the countdown, and a `CountdownCubit` would have to be renamed or
   joined by two more Cubits fighting over one screen. Cubits orchestrate; they
   do not compute — they call use cases and emit state. A Cubit that owns a
   timer or subscription cancels it in `close()`.

6. **State is `sealed`, one variant per thing the page can show.** Never one
   class with `isLoading`, `failure` and `data` all nullable — that permits
   states nobody designed. Variants live in the Cubit's library as a `part`,
   because Dart requires it of a `sealed` type and a state means nothing away
   from the Cubit that emits it.

7. **No magic values — and every kind has ONE home.**
   A literal outside these files is a value nobody can search for. Where it goes
   is decided by what it MEANS, not by its type:

   | What it is | Where it lives |
   |---|---|
   | A named quantity — `0`, `1`, an empty string, a separator, a radix | `core/constants/` — `ValueConstants`, `CharConstants`, `RadixConstants` |
   | A design measurement — spacing, radius, icon size, control height, border, opacity, type size | `presentation/base/ui/values/` — `AppSpacing`, `AppRadii`, `AppSizes`, `AppOpacity`, `AppTypography` |
   | A colour | `AppPalette`, derived from the accent — never a hex in a widget |
   | A duration | `core/constants/duration_constants.dart` |
   | A rule of the economy or of a concept | `domain/<feature>/*_rules.dart` — `domain/points/points_rules.dart` |
   | A failure key | `FailureMessageKey` |
   | An address | `AppRoutePaths`, built from `presentation/router/route_path.dart` |
   | A value ONE page reads | a private `static const` in that page's own widget |

   Using them is not optional and not a matter of taste:
   `dart run tool/check_structure.dart` fails the build on an empty string
   literal, on a bare number in a widget that is not a named constant's own
   declaration, and on a colour hex outside `AppPalette`. `RoutePath` and the
   constants holders are the only files allowed to spell those values out.

   **The test is reuse, not type** — a number is not "a constant" because it is
   a number. `0` written as `ValueConstants.zero` says a count; `0` written as
   `AppSpacing.none` would be a lie about a measurement nobody measured.

   **A vocabulary is defined once and referenced everywhere else.** A word the
   app discriminates on — a tab, an accent, a subject, a status — gets ONE enum
   and every `switch` over it is exhaustive, so adding a member breaks the build
   rather than the screen. `AppNavTab.rewards` instead of `currentIndex == 1`.

8. **All copy through `AppL10n`, and the app speaks Turkish only.**
   A string literal in a widget cannot be changed without a rebuild and is
   invisible until someone reads that screen. There is **one** `.arb`,
   `app_tr.arb`, and the locale is pinned to Turkish rather than following the
   device: the audience is one exam in one country, and a student whose phone
   is in English is still sitting the LGS. Plurals use ICU, never an `if` — the
   zero case is often a different sentence, not a different number. A second
   language, if it ever comes, arrives as another `.arb` beside this one.

9. **Only the composition root and a page's `BlocProvider` touch `getIt`.**
   Everything else takes dependencies through its constructor.

10. **Package imports everywhere** (`package:lgs_reward_hunt/...`). A `../../..`
    says nothing about which layer it crossed, and crossing one is exactly what
    needs to be visible. Enforced by `always_use_package_imports`.

11. **A bug fix ships the test that would have caught it.** It must fail against
    the unfixed code. Name it after the SYMPTOM, not the mechanism. Then ask
    whether a lint or a type could have caught it — a rule the analyzer enforces
    beats a rule written down.

12. **`main.dart` is the only file outside a layer.** It is the composition
    root, and the one place allowed to see both `infrastructure` and
    `presentation` — which is why `App` takes its flavor-dependent values as
    arguments instead of reading `AppConfig` itself. There is one `main.dart`:
    the flavor arrives from the build, and anything that differs between
    environments is read through `AppConfig`, never by switching on
    `AppConfig.flavor` at the point of use.

13. **Comments go at the TOP of a declaration, never inside it.** One `///`
    block above each class, top-level function or constant holder — and nothing
    below it. No `///` on a field or a method, no `//` inside a body. Whatever a
    member needs said is said in that block, naming it: `[examDate] is the day
    the exam is held.` A comment wedged between two statements breaks the code
    into fragments the reader has to reassemble, and it is the comment that goes
    stale first, because the line above it changed and nobody scrolled. One
    block per declaration is one place to read and one place to keep true. A
    block growing unwieldy is the signal to split the class, not to scatter the
    explanation back through its body.

14. **A page is a folder with ONE body, and a route is a `RoutePath`.**
    `presentation/<feature>/pages/<page>/<page>_page.dart` owns the scaffold — an
    `AppScaffold`, never a bare `Scaffold` — and the `switch` over its state.
    Under it:

    - `body/<page>_body.dart` — exactly ONE. A scaffold has one body, and a
      folder of bodies is a folder of things nobody can tell apart.
    - `items/` — ONLY the widget that draws one entry of a repeated list or
      grid: the thing a loop or an `itemBuilder` produces.
    - `widgets/` — every other widget this page alone uses.
    - `app_bar/`, `modal_bottom_sheet/` — the two parts big enough to name.

    A widget a SECOND page needs leaves all of these and moves to
    `presentation/base/ui/widgets/<group>/`.

    Every address is a `RoutePath` in `AppRoutePaths`, built from the one above
    it — `path()` is what you navigate to, `pathEnd()` what `GoRoute` registers.
    A nested route never restates its parent's segments, and no path is ever a
    literal at a call site.

    What one page hands the next over a route is a `*ArgumentsModel` in
    `presentation/router/arguments/`, not in either page's folder: the sender
    builds it, `AppRouter` casts `extra` back to it and the receiver reads it,
    so it is the route's contract. It is not domain (nothing in it is validated
    yet) and not an application DTO (no use case takes it).

    Pages, not screens: the widget a route builds is a `*Page` in `<feature>/pages/`,
    as in Flutter's own `MyHomePage`, and the name is English everywhere —
    code, plan and the design's screen picker (`Intro`, `Child setup`, `Map`).
    Only what a user reads is Turkish.

15. **The kit page is temporary scaffolding.**
    `presentation/debug/pages/ui_kit/` shows every widget in `base/ui/widgets/` on
    one sheet, with brightness and accent switches at the top. It is reached
    from the home app bar in a debug build only (`kDebugMode`), linked from
    nowhere in the product, and meant to shrink or go once the real pages
    exist. Add a widget to `base/` and add it to the sheet in the same commit —
    a component nobody can open on a device is one nobody checks in dark mode or
    on the yellow accent. It is also the ONE page allowed string literals: its
    words name specimens, they are not the app speaking. Copy INSIDE a widget
    still comes from `AppL10n`.

16. **Every request and every response is a DTO.**
    A service call never sends or reads a map literal. A request is a
    `*RequestDto extends BaseRequest`, an answer is a `*ResponseDto extends
    BaseResponse`, both generated by `json_serializable`, both living in
    `infrastructure/<feature>/dto/`. The two roots are separate types on
    purpose: a response can never be sent and a request is never read back.

    A DTO never leaves `infrastructure`. The repository that fetched it turns it
    into an entity, and a field the backend renames costs one mapper rather than
    a search through every widget.

    Between the two sits `PayloadCodecInterface`, run by `CryptoInterceptor` on
    every request and response. It is a passthrough today; when the backend
    brings a key exchange, encryption is a second implementation and one DI
    binding — no repository is touched.

17. **Words go through `AppText`, and controls through the app's own widgets.**
    A bare `Text` takes whatever style the tree hands it, which is how one
    sentence ends up at two sizes on two screens. `AppText(x, type:
    AppTextTypeEnum.meta)` asks for a ROLE and the theme answers; `color`,
    `weight` and a merged `style` are the escape hatches, in that order. The
    same rule holds for the rest of Material's kit: `AppScaffold` rather than
    `Scaffold`, with an `AppAppBar` in its `appBar` slot and an `AppBottomNav`
    in its `bottomNavigationBar` slot — never a bar or a back arrow drawn inside
    the body, and the slot types enforce it — `AppIconButton` rather than
    `IconButton`, `AppButton` rather than `FilledButton`. Wrapping is not
    ceremony — it is where the shared answer lives, so a page cannot give a
    different one by accident.

18. **Anything used twice moves to `base/`, like halleder.**
    `presentation/base/ui/widgets/<group>/app_<name>.dart` for widgets —
    `app_bar/`, `avatar/`, `badge/`, `buttons/`, `card/`, `feedback/`, `icon/`, `input/`, `map/`,
    `navigation/`, `progress/`, `reward/`, `section/`, `state/`, `task/` — and
    `presentation/base/ui/values/` for what they read: the palette, the scales,
    the theme, and `l10n/`. A widget ONE page shows stays in that page's
    `items/`; it moves to `base/` the day a second page needs it, and not
    before, because a component generalised for one caller is a guess.

19. **No widget names a colour. Ever.**
    The accent is a setting — five colour ways, light and dark — so a hex in a
    widget is a widget that stays blue when the student turns the app pink.
    Everything comes from `AppPalette.of(context)`, which is derived from the
    accent's three seeds in `app_palette.dart`, the one file allowed to write a
    hex. The reward colour is the points economy and nothing else: not a
    heading, not navigation, never the countdown. The success colour is ink and
    an icon, never a fill — the single exception is a redeemed reward's card,
    which is a receipt.

20. **The type scale is closed, and Nunito is bundled.**
    One family in `AppFonts`, nine sizes in `AppTypography`, and the weights
    live in `AppTheme`'s `TextTheme` (900 structural, 800 prose, 700 quiet). The
    face ships as a single VARIABLE file in `assets/fonts/`, so a `FontWeight`
    is an axis position rather than another asset, and it is never fetched at
    runtime: `google_fonts` falls back to the platform face when the device is
    offline, and the first screen of this app is one a student opens on the bus.

21. **Code is English. Only the copy is Turkish.**
    Identifiers, comments, doc comments, file and folder names, commit
    messages, test descriptions: English, without exception. `AppAccent.yesil`
    cannot be grepped beside `green`, cannot be read by anyone who does not
    speak Turkish, and reads as a typo to every tool that lints Dart. The ONLY
    Turkish in the repository is what a user sees, and it lives in
    `app_tr.arb` — plus the sample strings on the kit sheet, which stand in for
    that copy on purpose. An English comment may quote a Turkish string when it
    is talking about that string ("Bugün!"), because the quote is the subject.

22. **A pressable thing sits on a solid edge, not a shadow.**
    `AppSizes.edgeDepth`, `edgePressed` and `pressTravel` are the design's
    signature: a button and a map stop rest on an unblurred offset below them,
    and pressing moves the face down onto it. Material's elevation cannot say
    this, which is why `AppButton` exists beside the themed `FilledButton` and
    why a page must never reach for `elevation:` to make something look
    tappable.
