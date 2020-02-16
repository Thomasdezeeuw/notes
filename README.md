# Note

A simple note keeper, with the help of git.

Inspired by "did.txt file" by Patrick Tran, see
https://theptrk.com/2018/07/11/did-txt-file. And Jethro Kuan, see
https://blog.jethro.dev/posts/how_to_take_smart_notes_org.


## Usage

Note keeps two kinds of notes:

* daily (or fleeting) notes, and
* subject related notes.

Daily notes will be opened by default and can be used for note not related to a
specific subject. These can later be searched through. Other notes might be
related to a specific subject, e.g. a project your working on, these are all
contained within a single file.


### Opening a daily note

The simplest usage of `note` is command below, which opens today's note using
your preferred editor (see below to change the editor).

```bash
$ note
```

Each first usage of the day `note` will automatically create a new note file to
write your notes in.


### Opening a subject specific note

Notes related to the same subject are better contained within the same file. To
open the note file related to a subject the following command can be used.

```bash
$ note $subject
# For example:
$ note my_project
```

### Search notes

After taking a bunch of notes it might become hard to remember on which day your
wrote what. So to aid reading notes `note` support searching notes for a
key-words.


```bash
$ note search $key_word
# For example:
$ note search note taking
```

Under the hood this using grep or [ripgrep] (if installed) to search the notes
and opens them using your preferred editor.

[ripgrep]: https://github.com/BurntSushi/ripgrep



## Environment variables

The following environment variables changes the behaviour of `note`.

* `$EDITOR` determines what editor to use when editing a note, defaults to
  `vim`.
* `$NOTES_DIR` sets the directory which contains all notes, defaults to
  `~/.notes`.
* `$NOTES_AUTO_SYNC`, if this is set to `true`, or `1`, notes will call `git add
  . && git sync` after each call, defaults to false.



## License

Licensed under either of

 * Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or https://www.apache.org/licenses/LICENSE-2.0)
 * MIT license ([LICENSE-MIT](LICENSE-MIT) or https://opensource.org/licenses/MIT)

at your option.


### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall be
dual licensed as above, without any additional terms or conditions.
