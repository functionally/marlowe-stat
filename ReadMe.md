# Marlowe Statistics

Scripts to compute and publish statistics for Marlowe contracts on public networks.


## Build docker image

```bash
podman load < $(nix-build image.nix)
podman push localhost/marlowe-stat:latest docker://ghcr.io/functionally/marlowe-stat:latest
```


## Example deployment

```bash
podman play kube --replace=true --start=true example-kube.yaml
```
