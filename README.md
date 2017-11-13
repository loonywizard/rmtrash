# rmtrash

rmtrash is an unix script, which allows to remove files from terminal to `/home/\<username\>/.trash` directory

### Usage

```sh
$ /path/to/rmtrash/rmtrash.sh filenames
```

It will creates hard link to this file in `/home/\<username\>/.trash` with unique identifier and adds information about deleting to `/home/<username>/.trash/.trash.log` file with structure  `filename:id`
