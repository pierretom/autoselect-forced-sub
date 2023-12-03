# autoselect-forced-sub

A Lua script for [mpv](https://mpv.io) to automatically select forced subtitles in a different way.

Forced subtitles are a type of subtitle that must be provided in a video just to make it understandable. Such as when a foreign or alien language is spoken, or when a sign or flag is shown.

The script does not download any subtitles and will also do nothing if no subtitles are available.

## Installation

Use `autoselect-forced-sub.lua` for the stable version of mpv (0.36.x).

Place it in the corresponding mpv `scripts` folder of your operating system:
* Linux & BSD:
  - `$XDG_CONFIG_HOME/mpv/scripts` or
  - `~/.config/mpv/scripts` or
  - `/home/<username>/.config/mpv/scripts`
* macOS:
  - `$HOME/.config/mpv/scripts` or
  - `~/.config/mpv/scripts` or
  - `/Users/<username>/.config/mpv/scripts`
* Windows:
  - `%APPDATA%\mpv\scripts` or
  - `c:\users\<username>\AppData\Roaming\mpv\scripts`

## Options

This script does not use its own options, but only those of mpv:

| Option&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Value | Action&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :------------------------- | :--------------- | :-------------------------------------------- |
| `track-auto-selection`     | `no`             | Disable this script at startup or at runtime. |
| `sid` *or* `sub`           | *all but* `auto` | Disable this script at startup only.          |
| `slang`                    | *optional but __recommended__* | Used to select forced and non-forced subs with the specified language codes. |
| `slang`                    | `auto`           | Currently ignored. |
| `sub-forced-only`          | `yes` or `auto`  | Select only detected forced subtitles.<br />If no forced subtitles match the language codes specified with `--slang`:<br /><br />1. The first one that matches the language of the current audio track will be selected.<br />2. Otherwise it selects the forced subtitle with the lowest ID. |
| `sub-forced-only`          | `no `            | Select detected forced subtitles in priority.<br />If not found select another subtitle in that order:<br /><br />1. First subtitle with the default flag that matches language codes.<br />2. First subtitle that matches language codes.<br />3. First subtitle that matches the language of the current audio track.<br />4. First subtitle with the default flag that not matches language codes.<br />5. The subtitle with the first ID. |

### Notes

1. When setting up `--slang`, for better results, use [ISO 639-1, 639-2/T and 639-2/B codes](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes).<br />
Examples:
   * `--slang=ja,jpn,en,eng`
   * `--slang=es,spa`
   * `--slang=fr,fre,fra`
   * `--slang=sq,alb,sqi`

2. With `--sub-forced-only=no`, you are sure to select one forced or non-forced subtitle track.

3. All other mpv options are ignored.
