# TODO
---

- [ ] Compile to Linux binary?
    - Add semver to build name on Export?
        - "godot export create file with semver tacked on"
        - https://store.godotengine.org/asset/bearlikelion/export-auto-version/
- [ ] Create installer:
    - For Linux: Drop into `$HOME/.local/bin`.
- [ ] Create launcher:
    - For Linux: `$HOME/.local/share/applications/eggtimer.desktop`.
    - For OSX: ??.
    - For Windows: ??.

---

## Fix

- Error on close of exported App
    ```
    WARNING: 4 ObjectDB instances were leaked at exit (run with `--verbose` for details).
      at: cleanup (core/object/object.cpp:2536)
    Leaked instance: GDScriptNativeClass:9223372055074833041 - Reference count: 2
    ERROR: Cannot get path of node as it is not in a scene tree.
      at: get_path (scene/main/node.cpp:2431)
    Leaked instance: Node:36473668979 - Node path: 
    Leaked instance: GDScript:9223372070090442105 - Reference count: 1
    Leaked instance: GDScript:9223372070476318076 - Reference count: 1
    Hint: Leaked instances typically happen when nodes are removed from the scene tree (with `remove_child()`) but not freed (with `free()` or `queue_free()`).
    ERROR: 2 resources still in use at exit.
      at: clear (core/io/resource.cpp:817)
    Resource still in use: res://scripts/BaseConfig.gd (GDScript)
    Resource still in use: res://scripts/AppConfig.gd (GDScript)
    Orphan StringName: BaseConfig (static: 0, total: 2)
    Orphan StringName: PATH__USER_DATA (static: 0, total: 2)
    Orphan StringName: AppConfig (static: 0, total: 2)
    Orphan StringName: dir (static: 0, total: 2)
    Orphan StringName: data (static: 0, total: 2)
    Orphan StringName: Node (static: 3, total: 4)
    Orphan StringName: file (static: 0, total: 2)
    Orphan StringName: timers (static: 0, total: 2)
    StringName: 8 unclaimed string names at exit.
    ```
