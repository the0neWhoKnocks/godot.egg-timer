# TODO
---

- [ ] Synchronize blinking animations of completed timers.

- [ ] Rename config file to match what currently exists.
- [ ] Create installer:
    - For Linux: Drop into `$HOME/.local/bin`.
- [ ] Create launcher:
    - For Linux: `$HOME/.local/share/applications/eggtimer.desktop`.
    - For OSX: ??.
    - For Windows: ??.

---

## Fix

- [ ] when timer is set to `00:00:02`, and it's played, it doesn't always count down "2, 1, 0", it just goes "2, 0". Oddly, timers with longer times seem to tick seconds fine.
