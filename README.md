[![GoDoc](https://godoc.org/github.com/gen64/go-cli?status.svg)](https://godoc.org/github.com/gen64/go-cli)
[![Build Status](https://api.travis-ci.com/gen64/go-cli.svg?branch=master)](https://travis-ci.com/gen64/go-cli)

# go-cli

Package `gen64/go-cli` is meant to make handling command line interface easier.

You define commands with flags, attach a handler to it and package does all
the parsing.

### Install

Ensure you have your
[workspace directory](https://golang.org/doc/code.html#Workspaces) created and
run the following:

```
go get -u github.com/gen64/go-cli
```

### Example

Let's start with an example covering everything. First, let's create main
`CLI` instance and commands:

```
func main() {
    myCLI      := cli.NewCLI("Example CLI", "Silly app", "Author <a@example.com>")

    cmdInit    := myCLI.AddCmd("init", "Initialises the project", InitHandler)
    cmdStart   := myCLI.AddCmd("start", "Start the application", StartHandler)
}
```

Next, let's add flags to our commands:

```
    cmdInit.AddFlag("template", "t", "filepath", "Path to template file", TypePathFile|MustExist|Required)
    cmdInit.AddFlag("file-output", "o", "filepath", "Output to a specific file instead of stdout", TypePathFile)
    cmdInit.AddFlag("number", "n", "int", "Number necessary for initialisation", TypeInt|Required)

    cmdStart.AddFlag("verbose", "v", "", "Verbose mode", TypeBool)
    cmdStart.AddFlag("username", "u", "username", "Username", TypeAlphanumeric|AllowDots|AllowUnderscore|Required)
    cmdStart.AddFlag("threshold", "", "1.5", "Threshold, default 1.5", TypeFloat)
    cmdStart.AddArg("input", "FILE", "Path to a file", TypePathFile|Required)
    cmdStart.AddArg("difficulty", "DIFFICULTY", "Level of difficulty (1-5), default 3", TypeInt)
```

Fifth argument to `NewCLIFlag` is used to define what is the type of flag, is
it required etc. It's an integer value and the following `const`s are
available:

* `TypePathFile` - flag is a path to a file (string);
* `MustExist` - if added along with `CLIFlagTypePathFile` then path must exist;
* `Required` - flag is required (this does not work with bool flag);
* `TypeString` - flag is a string;
* `TypeBool` - flag is boolean and will have a value of "true" or "false";
* `TypeAlphanumeric` - flag is string and have to match [0-9a-zA-Z]+.

Check `cli_flag.go` for more information on flag types.

Finally, let's create functions to handle our commands. In below code, you can
see that method `Flag` on `CLI` instance (passed as first argument) can be
used to get a flag value.

```
func InitHandler(c *cli.CLI) int {
    fmt.Fprintf(os.Stdout, "Template path: %s\n", c.Flag("template"))
    return 0
}

func StartHandler(c *cli.CLI) int {
    fmt.Fprintf(os.Stdout, "Username: %s\n", c.Flag("username"))
    return 0
}
```

And in the end of `main()` func:

```
    os.Exit(myCLI.Run(os.Stdout, os.Stderr))
```
