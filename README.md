This is a dummy project to test out [GoCD](https://www.gocd.org/) build
pipelines.

# Pre-requisites

* [GoCD Server](https://www.gocd.org/download)
* [GoCD Agent](https://www.gocd.org/download)
* [Docker](https://www.docker.com/)


# Usage

## Starting GoCD

You will need start both the server and agent to test out the pipeline.

```bash
path/to/go-server console  # use 'start' instead of 'console' to start as daemon
path/to/go-agent console
```

The GoCD UI will then be available at `http://localhost:8153/go`.


## Starting a Docker registry

We will push the docker image built in the test pipeline to a local registry.
Start one for testing purposes with:

```bash
docker run -d -p 5000:5000 --restart=always --name registry registry:2
```


## Setting up the pipeline

1. [Open the GoCD UI](http://localhost:8153/go).
2. Navigate to Admin → Pipelines, click "Create new pipeline group", and name it
   `defaultGroup`.
3. Navigate to Admin → Config Repositories, click "Add".
   1. Choose a name.
   2. Plugin ID should be "YAML Configuration Plugin".
   3. Material type should be "Git".
   4. URL should be the URL of this repo: `https://github.com/jgosmann/build-pipeline-demo.git`.
      (You may test the connection.)
   5. Below "Rules" add a new permission with:
      - Directive: Allow
      - Type: Pipeline Group
      - Resources: defaultGroup


# Pre-flight validation

[GoCD is supposed to support syntax and preflight validation with gocd-cli.](https://github.com/tomzo/gocd-yaml-config-plugin#validation)
However, I was unable to get gocd-cli installed.
All provided installation methods failed for me.


# Impressions

* Some details about the YAML configuration have to be looked up in the [XML
  configuration reference](https://docs.gocd.org/current/configuration/configuration_reference.html).
  This requires translating between the two formats. 😐 It also seems that in
  some instances the naming is not consistent, i.e. `cleanWorkingDir` vs.
  `clean_workspace`. 🙄
  * The XML documentation is annoying to navigate. 😡
* Build logs supports colors and collapsing. 😀
* The visual stream map (VSM) gives a nice display of dependencies and
  dependents of a pipeline. 🙂
* Slightly awkward UI navigation 😕 (but not as bad as Jenkins by far imo)
