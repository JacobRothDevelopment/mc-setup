# mc-setup

scripts for setting up and starting an mc server

# HOW TO USE

## The Basics

- Copy `*.sh` into a directory or work directly out of this repo's directory
- This directory will hold subdirectories which themselves will contain the MC server.jar (note the `file structure`)
- To make the scripts executable, run `chmod +x *.sh`
- To learn about how to start the java server, run `./mc.sh -h` or `./mc.sh help`
- Starting the server will follow this pattern `./mc.sh start -w 1.19.4`
- You may need to update java. do so using `./newJava.sh install <version number>`
    - This will install a new version of java-jre as `java<version number>` along side your current version of java
    - Replace the `java` command in `run.sh` with the new java bin
    - For example
        - Java 25 is needed for minecraft 26.2
        - Run `./newJava.sh install 25`
        - Replace `java` in `26.2/run.sh` with `java25`
- To make backups of your worlds, use `./mc.sh backup -w <version number>`
    - this will save a timestamped .tar.gz file in `/backups`

## The Details

### mc.sh

| Action  | Description                                                   | Example                 |
| ------- | ------------------------------------------------------------- | ----------------------- |
| list    | List all available worlds                                     | ./mc.sh list            |
| backup  | Create zip backup of world                                    | ./mc.sh backup -w 26.2  |
| start   | Start world server                                            | ./mc.sh start -w 26.2   |
| install | Install server jar for given minecraft version (vanilla only) | ./mc.sh install -w 26.2 |

| Option | Description                                                  |
| ------ | ------------------------------------------------------------ |
| -d     | Debug mode. Outputs debug messages in console                |
| -h     | Help menu. display usage and options                         |
| -r     | Dry run mode. Will not create any files or run any processes |
| -v     | Version. Output version number for the script                |
| -w     | World. Specify which server to target                        |

### newJava.sh

| Action  | Description                                                           | Example                 |
| ------- | --------------------------------------------------------------------- | ----------------------- |
| list    | List all java versions                                                | ./newJava.sh list       |
| install | Install OpenJDK JRE version as `java<Version Number>` (requires sudo) | ./newJava.sh install 25 |

<small>\*_no options are used in this script_</small>

# FILE STRUCTURE

```
└── minecraft/
    ├── mc.sh
    ├── 1.19.4/
    │   └── server.jar
    ├── modded/
    │   └── server.jar
    └── backups/
```
