# Evidence

Everything captured for this assignment. Part B was built locally on an arm64 laptop, and
Part C ran in Azure (`francecentral`, resource group `rg-cc-a1-tal`, since deleted). All
command output is plain text; the screenshots only repeat what is already in the text files.

## Part B: layers and cache

| File | What it holds |
|:--|:--|
| [`b1-sizes.txt`](b1-sizes.txt) | `docker image ls` for `cc-demo:a`, `cc-demo:b` and `cc-demo:c`, then `docker history` for each image |
| [`b1-site-packages.txt`](b1-site-packages.txt) | Size and contents of `site-packages` in images B and C, showing that C carries a second copy of pip inside `/opt/venv` |
| [`b2-cache.txt`](b2-cache.txt) | Full `--progress=plain` build of `Dockerfile` after changing `/healthz` to `"ok -b2"`: only `COPY app.py .` runs |
| [`b3-cache.txt`](b3-cache.txt) | Full `--progress=plain` build of `Dockerfile.bad` after changing `/healthz` to `"ok -b3v3"`: `pip install` runs again |

## Part C: Azure

| File | What it holds |
|:--|:--|
| [`c1-acr.txt`](c1-acr.txt) | `docker push` to `cca1tal6210.azurecr.io/cc-demo:v1`, then `az acr repository show-tags` listing `v1` |
| [`c2-aci.txt`](c2-aci.txt) | `az container show` (state `Running`, image from ACR, public IP, user-assigned identity) and `az container logs` |
| [`c3-request.txt`](c3-request.txt) | `curl.exe -i` against the public IP for `/`, `/healthz` and `/count` twice, with status lines and bodies |
| [`c4-secure-var.txt`](c4-secure-var.txt) | `az container show` environment variables: `GREETING` has a value, `SECRET_TOKEN` reads `null` |
| [`c5-portal-redeploy.txt`](c5-portal-redeploy.txt) | A second deployment of the same image (same digest), made only to take the portal screenshots: tag and digest in ACR, container `Running`, and `curl` against its public IP `4.178.153.219` |

## Screenshots

All in [`screenshots/`](screenshots/). The subscription, tenant and identity IDs are blacked
out wherever they appeared.

Portal screenshots, taken during the second deployment:

| File | What it shows |
|:--|:--|
| `portal-acr-repository.png` | The `cc-demo` repository in the `cca1tal6210` registry |
| `portal-aci-overview.png` | `aci-cc-a1` Running, with public IP `4.178.153.219`, Linux, France Central |
| `portal-aci-events.png` | ACI pulling the image from ACR and starting the container |
| `portal-app-response.png` | The app's JSON response in the browser; the hostname matches `c5-portal-redeploy.txt` |

Terminal screenshots of the original Part C session:

| File | What it shows |
|:--|:--|
| `c1-build-amd64.png` | Building the image for `linux/amd64` |
| `c1-push.png` | Pushing the image to ACR |
| `c2-identity-and-aci.png` | Managed identity, `AcrPull` role assignment and `az container create` |
| `c2-c3-running-and-requests.png` | Container state and logs, first requests to the public IP |
| `c3-requests.png` | Requests to `/healthz` and `/count` |
| `c4-secure-var-and-cleanup.png` | Secure variable reading `null`, and the resource group being deleted |
