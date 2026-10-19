# Project map

**GENERATED — do not edit.** `dart run tool/generate_project_map.dart` rewrites it; `dart run tool/check_structure.dart` fails while it is stale. Rules: [CLAUDE.md](CLAUDE.md). 464 source files.

`core` → nothing · `domain` → core · `application` → domain · `infrastructure` → domain · `presentation` → application, domain. `main.dart` and `application/di/` are the composition root.

## Features — `lib/<layer>/<feature>/<kind>/`

| feature | domain | application | infrastructure | presentation pages |
|---|---|---|---|---|
| `account` | entities 2 · interfaces 2 · read_models 4 · rules 1 · value_objects 4 | cubit 4 · use_cases 6 | dto 3 · mock 1 · repositories 2 | child_form, child_setup |
| `auth` | enums 2 · interfaces 2 · read_models 1 · rules 1 · validators 1 · value_objects 6 | cubit 8 · use_cases 7 | dto 6 · mock 1 · repositories 1 · services 1 | auth, intro, parent_gate, parent_pin, password |
| `avatar` | entities 1 · enums 2 · interfaces 1 | use_cases 1 | dto 1 · mock 1 · repositories 1 |  |
| `exam` | interfaces 1 · validators 1 · value_objects 1 | use_cases 1 | repositories 1 |  |
| `parent` | enums 1 · read_models 1 · rules 1 | cubit 2 · use_cases 1 |  | parent |
| `points` | entities 2 · enums 1 · interfaces 1 · rules 1 |  | dto 2 · mock 1 · repositories 1 |  |
| `profile` | read_models 1 | cubit 2 · use_cases 1 |  | profile |
| `progress` | enums 3 · read_models 1 · rules 1 | cubit 2 · use_cases 1 |  | progress |
| `reward` | entities 3 · enums 3 · interfaces 2 · read_models 1 · rules 1 · validators 1 · value_objects 1 | cubit 4 · use_cases 8 | dto 9 · mock 1 · repositories 2 | reward_setup, rewards |
| `session` | interfaces 1 · value_objects 1 | cubit 2 · use_cases 4 | repositories 1 | device_child |
| `settings` | enums 2 · interfaces 1 · value_objects 1 | cubit 2 · use_cases 2 | repositories 1 |  |
| `study_path` | enums 1 · read_models 3 · rules 1 | cubit 2 · use_cases 1 |  | home |
| `task` | entities 2 · enums 5 · interfaces 2 · rules 2 · validators 1 · value_objects 1 | cubit 2 · use_cases 6 | dto 7 · mock 2 · repositories 2 | task_setup |

Kind folders hold one suffix each: entities · value_objects · read_models · enums · interfaces · rules · validators · use_cases · cubit/<page> · repositories · services · dto · mock. A page folder: `<page>_page.dart`, `body/<page>_body.dart`, items/ widgets/ app_bar/ modal_bottom_sheet/.

## Shared folders

- `core/base/` _(4)_
- `core/constants/` _(5)_
- `core/failure/` _(1)_
- `core/validators/` _(7)_
- `application/di/` _(1)_
- `infrastructure/config/` _(2)_ — firebase
- `infrastructure/network/` _(21)_ — crypto, dto, interceptors, mock
- `presentation/base/` _(99)_ — ui
- `presentation/debug/` _(20)_ — pages, widgets
- `presentation/router/` _(7)_ — arguments
- `presentation/base/ui/widgets/` — app_bar, avatar, badge, buttons, card, feedback, icon, input, map, navigation, progress, reward, scaffold, section, state, task, text

## Tests — mirror lib

`test/<layer>/<feature>/`; `test/support/mock_backend.dart` builds the mock backend (`mockBackend()`, `demoParent()`). Page tests pump a 360-wide phone (`test/support/pump_page.dart`).

## Gate

`flutter analyze` · `dart run tool/check_structure.dart` · `flutter test`
