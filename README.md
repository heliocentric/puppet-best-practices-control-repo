```
.
├── data <-- directory containing all hiera data
│   ├── common.yaml <-- default settings across all nodes
│   └── host
│       └── node1c.yaml <-- settings specific to node1c
├── environment.conf <-- boilerplate
├── hiera.yaml <-- default hiera config
├── manifests
│   └── site.pp <-- boilerplate
├── README.md
└── site <-- modules embedded in a control repo
    └── profile <--- default profiles for your code
        ├── files
        │   ├── config.yml <--- normal config file
        │   └── otherconfig.yml <-- node1c's config file
        └── manifests
            └── filebeat.pp <-- filebeat profile that configures filebeat

7 directories, 9 files
```
