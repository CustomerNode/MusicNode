# MusicNode

> Studies conducted at MIT show programming to music increases output and reduces bugs by up to 250%.

A minimal music + video player for Linux desktops. Drop files in, queue them up, drag to reorder, watch or listen — and cast the audio to AirPlay receivers on your network. Single-file Python, built on GTK 3 and GStreamer.

## Features

- **Queue-first workflow.** Drag tracks in, drag rows to reorder, click `✕` on a row to remove it. Add to the **top** (plays next) or **bottom** of the queue. One-click **🔀 Shuffle folder** dumps a whole directory tree in random order.
- **Recursive search** scoped to the current folder. Type to filter across every track in the subtree you're sitting in, then add hits to the top or bottom of the queue. `Ctrl+F` to focus, `Esc` to clear.
- **Saved playlists.** A 📋 Playlists entry at the music root lists every named playlist you've saved. One click on **💾 Save queue → playlist…** turns the current queue into an M3U file under `~/.config/musicnode/playlists/`. Each playlist behaves like a folder — click in to view tracks, hit "Add whole folder ▶" to queue the lot.
- **Plays everything GStreamer plays.** mp3, m4a, flac, ogg, wav, opus, mp4, mkv, webm, mov, …
- **Inline video.** Hardware-accelerated video pane (gtkglsink) with full-screen and a "hide controls" cinema mode for in-window watching.
- **AirPlay (legacy RAOP).** Send audio to AirPort Express, Onkyo / Denon receivers, and other classic AirPlay devices via PipeWire's `module-raop-discover`.
- **Lock-screen controls.** Talks MPRIS v2 over D-Bus, so the Cinnamon sound applet, lock screen, GNOME shell, and your keyboard's media keys all show your track and play/pause/skip.
- **Drag to import.** Drop files from your file manager onto the window to copy them into the folder you're browsing.
- **Marquee selection.** Click-and-drag to box-select rows in the file list; drag an already-selected row out to the queue.

## Install

### Dependencies

**Debian / Ubuntu / Linux Mint**
```bash
sudo apt install \
    python3-gi python3-dbus \
    gir1.2-gtk-3.0 gir1.2-gst-plugins-base-1.0 \
    gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav gstreamer1.0-gtk3 \
    pulseaudio-utils
```

**Fedora**
```bash
sudo dnf install \
    python3-gobject python3-dbus \
    gstreamer1-plugins-base gstreamer1-plugins-good \
    gstreamer1-plugins-bad-free gstreamer1-plugins-ugly-free \
    gstreamer1-libav pipewire-pulseaudio
```

**Arch / Manjaro**
```bash
sudo pacman -S python-gobject python-dbus \
    gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly \
    gst-libav gst-plugin-gtk pipewire-pulse
```

(PipeWire users — `pactl` ships with `pipewire-pulse`.)

### Install the app

```bash
git clone https://github.com/CustomerNode/MusicNode.git
cd MusicNode
./install.sh
```

That puts `musicnode` in `~/.local/bin/` and a launcher in your apps menu. Make sure `~/.local/bin` is on your `PATH`.

To remove: `./uninstall.sh` (your config in `~/.config/musicnode/` is left in place).

## Usage

By default MusicNode opens `~/Music` and recursively walks subfolders. Change the folder from the title-bar icon; the choice is remembered across launches in `~/.config/musicnode/state.json`.

### Keyboard

| Shortcut | Action |
|---|---|
| `Space` | Play / pause |
| `Ctrl + ←` / `Ctrl + →` | Previous / next track |
| `Ctrl + F` | Focus library search |
| `Ctrl + A` | Select every file in the current folder |
| `Enter` | Add the current selection and start playing |
| `Delete` / `Backspace` | Remove the focused queue row |
| `Ctrl + Q` | Hide / show controls (cinema mode in-window) |
| `F11` | Toggle fullscreen |
| `Esc` | Exit fullscreen |

### Selection in the file list

- **Drag from empty space or an unselected row** → marquee-select rows in a range
- **Drag from an already-selected row** → drag-out to the queue
- `Ctrl/Shift + click` → standard toggle / range select
- Double-click a folder to descend; the `⬆ ..` row goes back up

### AirPlay (the 📡 Cast button)

Click **📡 Cast** in the title bar to pick an audio output. The first click silently loads PipeWire's RAOP discovery; if you don't see your device immediately, click **🔄 Rescan** in the menu a moment later.

Selecting a target switches the audio stream mid-playback and remembers your choice for next time. Pick **🔊 System default** to come back.

**Heads up about latency.** AirPlay has roughly 2 seconds of buffering. That's fine for music, but if you cast a video file you'll see lip-sync drift. Use cast primarily for audio.

**Supported.** Older AirPlay devices that speak the legacy RAOP protocol — AirPort Express, most older AVRs (Onkyo, Denon, Marantz), and many shairport-sync receivers.

**Not supported.** AirPlay 2 / FairPlay-encrypted endpoints — newer Samsung TVs, the Apple TV's mirroring mode, HomePods. PipeWire's RAOP module doesn't speak that protocol. Those devices will show up in `avahi-browse` but won't appear in the Cast menu.

### Lock screen / system integration

MusicNode publishes MPRIS v2 at `org.mpris.MediaPlayer2.MusicNode`. That means:

- **Cinnamon's sound applet** shows the current track with play/pause/skip buttons.
- **The lock screen** (cinnamon-screensaver, GNOME's lock screen, KDE's lock screen) shows the same controls — handy if you started a playlist and want to skip a track without unlocking.
- **Media keys** on your keyboard (Play/Pause, Next, Previous) route to MusicNode while it's running.
- Any MPRIS client (`playerctl`, third-party panel applets) can drive it.

## Troubleshooting

- **No AirPlay devices in the menu.** Check that `pactl` exists (`which pactl`). On PipeWire that comes from `pipewire-pulse` / `pulseaudio-utils`. If it's there and you still see nothing after a Rescan, your devices might be AirPlay 2-only — see above.
- **Video files won't play.** You're missing codec plugins. Install `gstreamer1.0-plugins-bad` and `gstreamer1.0-libav` (or your distro's equivalent).
- **Multi-select feels weird.** See "Selection in the file list" above — clicking on a selected row starts a drag, clicking on an unselected one starts a marquee.
- **State got stuck on a missing folder.** Edit or delete `~/.config/musicnode/state.json`.

## Configuration

State is stored at:
```
~/.config/musicnode/state.json
```

Currently saved: the music folder, the queue, and the last-used audio output. No secrets, no telemetry.

## How it's built

| Concern | What's used |
|---|---|
| UI toolkit | GTK 3 via PyGObject |
| Media engine | GStreamer 1.0 (`playbin`) |
| Video sink | `gtkglsink` (GL accelerated) |
| Audio routing | PulseAudio / PipeWire sinks |
| AirPlay discovery | `module-raop-discover` (mDNS via Avahi) |
| System integration | MPRIS v2 over D-Bus (`dbus-python`) |

It's a single Python script. Read it, hack it, send a PR.

## License

[MIT](LICENSE).
