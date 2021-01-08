This is a dummy project to test out different CI solutions:

* [Concourse](https://concourse-ci.org/)
* [GoCD](https://www.gocd.org/)
* [Travis CI](https://travis-ci.com/)


# Concourse

The pipeline configuration is found in `concourse-pipeline.yml`.

## Usage

### Pre-requisites

* [Docker](https://www.docker.com/)


### Setting up Concourse

1. Download and run Docker compose file for Concourse:
   ```bash
   wget https://concourse-ci.org/docker-compose.yml
   docker-compose up -d
   ``
2. Store login credentials
   ```bash
   fly -t build-pipeline-demo login -c http://localhost:8080 -u test -p test
   ```
   
The web interface is accessible at [http://localhost:8080](http://localhost:8080).

### Setting up the pipeline

**Warning:** This stores the credentials in plain text, for production use this
should definitely use a credentials manager.

1. Create a `credentials.yml` file with credentials for the docker registry, containing:
  ```yaml
  docker-registry-username: "your username"
  docker-registry-token: "your token"
  ```
2. Setup the pipeline:
   ```bash
   fly -t build-pipeline-demo set-pipeline -c concourse-pipeline.yml -p build-pipeline-demo -l credentials.yml
   ```
3. Unpause the pipeline (can also be done via the web interface):
   ```bash
   fly -t build-pipeline-demo unpause-pipeline -p build-pipeline-demo
   ```
   
## Impressions

* Based on a few, but (seemingly?) powerful concepts.
* Can run pipelines locally for testing. 😀
* Each change to the pipeline needs to applied via a command and the pipeline
  definition is not fetched from the repository. 😐
* When applying changes to a pipeline, there is no warning or error for at least
  some invalid options. 😡
* Secrets management is extra deployment effort. 🙄


# GoCD

The pipeline configuration is found in `ci.gocd.yml`.

## Pre-requisites

* [GoCD Server](https://www.gocd.org/download)
* [GoCD Agent](https://www.gocd.org/download)
* [Docker](https://www.docker.com/)


## Usage

### Starting GoCD

You will need start both the server and agent to test out the pipeline.

```bash
path/to/go-server console  # use 'start' instead of 'console' to start as daemon
path/to/go-agent console
```

The GoCD UI will then be available at `http://localhost:8153/go`.


### Starting a Docker registry

We will push the docker image built in the test pipeline to a local registry.
Start one for testing purposes with:

```bash
docker run -d -p 5000:5000 --restart=always --name registry registry:2
```


### Setting up the pipeline

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


## Pre-flight validation

[GoCD is supposed to support syntax and preflight validation with gocd-cli.](https://github.com/tomzo/gocd-yaml-config-plugin#validation)
However, I was unable to get gocd-cli installed.
All provided installation methods failed for me.


## Impressions

* Some details about the YAML configuration have to be looked up in the [XML
  configuration reference](https://docs.gocd.org/current/configuration/configuration_reference.html).
  This requires translating between the two formats. 😐 It also seems that in
  some instances the naming is not consistent, i.e. `cleanWorkingDir` vs.
  `clean_workspace`. 🙄
  * The XML documentation is annoying to navigate. 😡
* Build logs support colors and collapsing. 😀
* The visual stream map (VSM) gives a nice display of dependencies and
  dependents of a pipeline. 🙂
* Slightly awkward UI navigation 😕 (but not as bad as Jenkins by far imo)


# Travis CI

[![Build Status](https://travis-ci.com/jgosmann/build-pipeline-demo.svg?branch=master)](https://travis-ci.com/jgosmann/build-pipeline-demo)

The pipeline configuration is found in `.travis.yml`.

## Impressions

* Quick to setup: just add `.travis.yml` (at least once the general Travis CI
  setup is done which I have done ages ago) 🙂
* Minimal code 🙂
* No passing of artifacts between stages of the pipeline without utilizing an
  external service. 😐
* Build logs support colors and collapsing. 😀
