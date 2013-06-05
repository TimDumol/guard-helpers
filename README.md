guard-helpers
=============

A set of helper modules to make making a Guard plugin easier.

## ::Guard::Helpers::Starter

Include this for some useful default behavior and scaffolding for your Guard
plugin, such as nested directory support and removal of deleted files. It
gives your Gaurd plugin the following options:

* `output` [string] -- (required) directory to output compiled files in
* `exclude` [regex] -- paths to exclude
* `all_on_start` [boolean] -- whether to compile all files on startup
* `all_on_change` [boolean] -- whether to compile all files whenever a single file changes

## Example

```ruby
guard 'stylus', :output => 'build', :all_on_start => true, :all_on_change => true do
  watch(%r{^src/(.+\.styl)$})
end
```

will compile files matching the regex `^src/(.+\.styl)$` and write the
compiled output in `build/\1` (e.g., `src/foo/bar.styl` goes to
`build/foo/bar.css`.

## ::Guard::Helpers::Formatter

A module taken from `guard/guard-coffeescript` to make making pretty notificaitons easier.

## Authors

* Tim Joseph Dumol <tim@timdumol.com>
* Michael Kessler <michi@netzpiraten.ch> (took `::Guard::Helper::Formatter` from his `guard/guard-coffeescript` repo)

## License

`guard-helpers` is licensed under the Apache 2.0 license. Please refer to
`LICENSE` for more details.
