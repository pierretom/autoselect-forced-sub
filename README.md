# autoselect-forced-sub

A Lua script for [mpv](https://mpv.io) to automatically select forced subtitles in a different way.

Forced subtitles are a type of subtitle that must be provided in a video just to make it understandable. Such as when a foreign or alien language is spoken, or when a sign or flag is shown.

The script does not download any subtitles and will also do nothing if no subtitles are available.

## Installation

Use `autoselect-forced-sub.lua` for the stable version of mpv (0.37.x).

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

This script uses some [mpv options](#mpv) and its [own options](#script).

### mpv

| Option&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Value | Action&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :------------------------- | :--------------- | :-------------------------------------------- |
| `track-auto-selection`     | `no`             | Disable this script at startup or at runtime. |
| `sid` *or* `sub`           | *all but* `auto` | Disable this script at startup only.          |
| `slang`                    | *optional but __recommended__* | Used to select forced and non-forced subs with the specified language codes. |

#### Notes

1. When setting up `--slang`, for better results, use [ISO 639-1, 639-2/T and 639-2/B codes](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes).<br />
Examples:
   * `--slang=ja,jpn,en,eng`
   * `--slang=es,spa`
   * `--slang=fr,fre,fra`
   * `--slang=sq,alb,sqi`

2. All other mpv options are ignored.

### Script

| Option&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Value | Action |
| :--------------------- | :--------------- | :-------------------------------------------- |
| `afs-enable`           | `no`             | Disable this script at startup or at runtime. Default value: `yes`.|
| `afs-sub_forced_only`  | `yes`            | Select only detected forced subtitles. Default value: `yes`.<br />If no forced subtitles match the language codes specified with `--slang`:<br /><br />1. The first one that matches the language of the current audio track will be selected.<br />2. Otherwise it selects the forced subtitle with the lowest ID. |
| `afs-sub_forced_only`  | `no `            | Select detected forced subtitles in priority.<br />If not found select another subtitle in that order:<br /><br />1. First subtitle with the default flag that matches language codes.<br />2. First subtitle that matches language codes.<br />3. First subtitle that matches the language of the current audio track.<br />4. First subtitle with the default flag that not matches language codes.<br />5. The subtitle with the first ID. |

#### Notes

1. With `--script-opts=afs-sub_forced_only=no`, you are sure to select one forced or non-forced subtitle track.

#### Examples to set the script options

Options are read in that order:

##### 1. On the command line

```
mpv --script-opts=afs-enable=no
mpv --script-opts=afs-sub_forced_only=no
mpv --script-opts=afs-enable=yes,afs-sub_forced_only=yes
```

##### 2. In mpv.conf

```
script-opts=afs-enable=yes,afs-sub_forced_only=no
```

##### 3. In afs.conf

This file can be placed in the `script-opts` folder (same location as the [scripts](#installation) folder).

```
enable=yes
sub_forced_only=no
```

##### 4. In autoselect-forced-sub.lua

The options are located at the beginning of the script, below `our_opts =`.

```
enable = true
sub_forced_only = true
```

##### 5. For key bindings and the mpv console

```
change-list script-opts append afs-enable=no
change-list script-opts append afs-sub_forced_only=no
set script-opts afs-enable=yes,afs-sub_forced_only=yes
```
