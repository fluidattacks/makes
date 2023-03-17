# Introduction

You can create custom workflows
not covered by the builtin `makes.nix` configuration options.

Locate in the root of your project:

`$ cd /path/to/my/project`

Create a directory structure. In this case: `makes/example`.

`$ mkdir -p makes/example`

We will place in this directory
all the source code
for the custom workflow called `example`.

Create a `main.nix` file inside `makes/example`.

Our goal is to create a bash script that prints `Hello from makes!`,
so we are going to write the following function:

```nix
# /path/to/my/project/makes/example/main.nix
{
  makeScript,
  ...
}:
makeScript {
  entrypoint = "echo Hello from Makes!";
  name = "hello-world";
}
```

Now run makes!

- List all available outputs: `$ m .`

    ```
    Outputs list for project: /path/to/my/project
      /example
    ```

- Build and run the output: `$ m . /example`

    ```
    Hello from Makes!
    ```

Makes will automatically recognize as outputs all `main.nix` files
under the `makes/` directory in the root of the project.
This "magic" `makes/` directory can be configured via the
`extendingMakesDirs` option.

You can create any directory structure you want.
Output names will me mapped in an intuitive way:

| `main.nix` position                                | Output name                | Invocation command     |
| -------------------------------------------------- | -------------------------- | ---------------------- |
| `/path/to/my/project/makes/main.nix`               | `outputs."/"`              | `$ m . /`              |
| `/path/to/my/project/makes/example/main.nix`       | `outputs."/example"`       | `$ m . /example`       |
| `/path/to/my/project/makes/other/example/main.nix` | `outputs."/other/example"` | `$ m . /other/example` |

Makes offers you a few building blocks
for you to reuse.

Let's start from the basics.
