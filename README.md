# gRPC Gen

Docker image for generating gRPC stubs dependably for multiple languages. Currently scripts for building Go, PHP, and JS are included. However, the image builds all gRPC supported language plugins.

## Installation

grpc-gen uses the `christwoism/grpc-gen` Docker image to generate the client and server stubs.
Any `*.proto` file found in `protos` will be generated into its proper namespace in the `generated` directory.

On a machine with docker installed.

```bash
# generate gRPC stubs for a given package
./script/docker-generate github.com/<user>/<repo>
```

### Building a new protoc and gRPC image

This only needs to be done when there is a new gRPC version.

```bash
script/build-image
```
