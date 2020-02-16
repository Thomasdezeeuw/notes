# Notes

A simple note keeper, with the help of git.

Inspired by "did.txt file" by Patrick Tran, see
https://theptrk.com/2018/07/11/did-txt-file.


## Usage

`note` can be used in the following way.

```
$ note
```

Opens the notes file for the current week.


## Environment variables

The following environment variables changes the behaviour of `note`.

```
$EDITOR
```

Determines what editor to use when editing a note, defaults to vim.

```
$NOTES_ROOT
```

The root directory which contains all notes, defaults to "~/.notes".

```
$NOTES_AUTO_SYNC
```

If this is set to `true`, or `1`, notes will call `git sync` after each call,
defaults to false.


## License

Licensed under either of

 * Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or https://www.apache.org/licenses/LICENSE-2.0)
 * MIT license ([LICENSE-MIT](LICENSE-MIT) or https://opensource.org/licenses/MIT)

at your option.


### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall be
dual licensed as above, without any additional terms or conditions.
