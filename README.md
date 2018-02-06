# hippo-module
Prototype for representing ARM modules using [jsonnet](https://jsonnet.org). 

## Getting started

### Running examples

1) Clone the repository
2) Make sure that you have jsonnet installed and on your path
3) Run `jsonnet <example file> -J <root of repository>`

## How to contribute

### Structure of the repository

```
<root>
+-- core
    +-- module.libsonnet    # Main module file exposing module
    +-- moduledef.libsonnet # Structure of a module
    +-- resource.libsonnet  # Structure for an individual resource
+-- example_consumers
    +-- vmss_cli.jsonnet    # Intended to be a module used by the azure cli vmss create command
+-- <other modules>
    +-- module.libsonnet
``` 

### Module 
A module is a folder that contains the following files:

```
modulename 
+-- module.libsonnet
+-- parameters.schema.json
+-- <additional libsonnet files>
```
where modulename is the name of the module.

### module.json
The structure of a module is a json object with two required properties; resources and outputs.

```
local core = import 'core/module.libsonnet';

{
    resources: {
      resource1: core.Module {
      },
      resource2: core.Module {
      }
    },
    outputs: {
    }
}
```
