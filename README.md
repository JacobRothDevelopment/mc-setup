# mc-setup

scripts for setting up and starting an mc server

# HOW TO USE

- Copy mc.sh into a directory
- This directory will hold subdirectories which themselves will contain the MC server.jar (note the `file structure`)
- To make the script executable, run `chmod +x ./mc.sh`
- To learn about how to start the java server, run `./mc.sh -h` or `./mc.sh help`
- Starting the server will follow this pattern `./mc.sh start -w 1.19.4`

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
