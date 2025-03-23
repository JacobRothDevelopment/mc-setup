# mc-setup

scripts for setting up and starting an mc server

# HOW TO USE

- Copy mc-start.sh into a directory
- This directory will hold subdirectories which themselves will contain the MC server.jar (note the `file structure`)
- To make the script executable, run `chmod +x ./mc-start.sh`
- To learn about how to start the java server, run `./mc-start.sh -h`
- Starting the server will follow this pattern `./mc-start.sh -w 1.19.4`

# FILE STRUCTURE

```
└── minecraft/
    ├── mc-start.sh
    ├── 1.19.4/
    │   └── server.jar
    └── modded/
        └── server.jar
```
