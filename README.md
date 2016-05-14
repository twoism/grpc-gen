# gRPC Gen

Docker image for generating gRPC stubs dependably for multiple languages.

## Installation

grpc-gen uses the `twoism/grpc-gen` Docker image to generate the client and server stubs.
Any `*.proto` file found in `protos` will be generated into its proper namespace in the `generated` directory.

On a machine with docker installed.

```bash
./script/docker-generate
```

### Building a new protoc and gRPC image

This only needs to be done when there is a new gRPC version.

```bash
script/build-image
```

