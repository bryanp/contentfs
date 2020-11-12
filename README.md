# contentfs

A structured content file system.

## Install

```
gem install contentfs
```

## Usage

Content can be defined in a structure like this:

```
docs/
  api/
    application/
      content.md

      class_api/
        new.md
      instance_api/
        ...
  guides/
    ...
```

Once defined, content can be accessed through ContentFS:

```ruby
require "contentfs"

database = ContentFS::Database.load("path/to/docs")

database.docs.api.application.render
```

The `content` name is special in that it defines content for the containing folder.

### Formats

Markdown is supported by default. Simply add the `redcarpet` gem to your project's `Gemfile`. For automatic syntax highlighting, add the `rouge` to your `Gemfile` as well.

Unknown formats default to plain text.

### Metadata

Metadata can be defined on content through front-matter:

```
---
option: value
---

...
```

Metadata can be applied to all content in a folder by defining a `_metadata.yml` file. The folder's metadata is merged with metadata defined in front-matter, with precedence given to the front-matter metadata values.

### Filtering

Content can be filtered by one or more metadata values:

```ruby
database.filter(option: "value") do |content|
  ...
end
```

### Iterating

Iterate over content using the `all` method:

```ruby
database.content.all do |content|
  ...
end
```

### Prefixes

Both folders and content can be defined with prefixes, useful for ordering:

```
docs/
  api/
    0000__application/
      ...
```

Characters up to `__` (double underscore) are considered part of the prefix.
