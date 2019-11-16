# github-action-build-push-github-package-registry

[Github Action](https://github.com/features/actions) to Build and Push a Docker image to [Github Package Registry](https://github.com/features/packages).

## Inputs

| **Input**                           | **Description**                                             | **Required** | **Default Value** |
|-------------------------------------|-------------------------------------------------------------| :----------: | :---------------: |
| `GITHUB_PACKAGE_REGISTRY_LOGIN`     | Login to connect to Github Package Registry                 | **Yes**      | |
| `GITHUB_PACKAGE_REGISTRY_PASSWORD`  | Password (Personal access token) to connect to Github Package Registry | **Yes** | |
| `IMAGE_NAME`                        | Docker image name                                           | **Yes** | |
| `DOCKERFILE_PATH`                   | Path of the Dockerfile                                      | **No** | `Dockerfile`     |
| `BUILD_CONTEXT`                     | Build context directory                                     | **No** | `.`             |

## Outputs

It will build and push a Docker image on `docker.pkg.github.com/<owner>/<repo>/${IMAGE_NAME}:<tag|sha>`.  
