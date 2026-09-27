# Assignment 1 — Containerise and deploy

> Replace every `TODO` and delete this quote block before submitting. The headings below
> map onto the rubric — keeping them makes it hard to lose marks for something you
> actually did. Answer in prose, not bullet fragments.

**Name:** TODO
**Campus:** TODO

## What this is

TODO — two or three sentences. What the application does and what you did to it.

## Build and run it locally

Commands someone else can paste, in order, with no edits beyond a name or a path.

```bash
docker build -t cc-app:1.0 .
docker run -d --name cc -p 8000:8000 -v ccdata:/data cc-app:1.0
sleep 3
curl http://localhost:8000/
curl http://localhost:8000/count
curl http://localhost:8000/healthz
docker exec cc id
```

Expected output:

```
{"greeting":"Hello from the container","hostname":"2a68251746b0"}
{"count":1,"stored_in":"/data/counter.json"}
{"status":"ok"}
uid=6210(user6210) gid=6210(user6210) groups=6210(user6210)
```

Show the counter surviving a container restart:

```bash
curl.exe http://localhost:8000/count
docker rm -f cc
docker run -d --name cc -p 8000:8000 -v ccdata:/data cc-app:1.0
Start-Sleep 3
curl.exe http://localhost:8000/count

{"count":2,"stored_in":"/data/counter.json"}
cc
1e5bb1b5888aae21b6f1d8b074069b049506d198d3d03fa72b54b48860c1762d
{"count":3,"stored_in":"/data/counter.json"}
```


Overriding configuration at run time:

```bash
docker run -d --name cc -p 8000:8000 -v ccdata:/data -e GREETING="Hi from Tal" cc-app:1.0
Start-Sleep 3
curl.exe http://localhost:8000/
cc
03db806302e5f84b380e80442db56ef84ef57dac83d94fd8d0f794648e285d07
{"greeting":"Hi from Tal","hostname":"03db806302e5"}
```

## Configuration

|| Variable | Default | What it does |
|:--|:--|:--|
| `GREETING` | `Hello from the container` | Text returned by `GET /`. Override with `-e GREETING="..."` to change the response without rebuilding. |
| `DATA_DIR` | `/data` | Folder where the counter file is stored. Matches the `VOLUME` and the folder owned by `user6210`, so the named volume can be written to. |
| `PORT` | `8000` | Port the app listens on inside the container. Published to the host with `-p <host>:8000`. |


## Part B — layers and cache

### B1 — image size

Sizes are the sum of each image's layers from `docker history` (uncompressed). The
compressed size that is actually pushed and pulled (`CONTENT SIZE` in `docker image ls`)
is given in brackets. All three images were built natively for linux/arm64.

| Build | Base | Stages | Size |
|:--|:--|--:|--:|
| A — single-stage, full base | `python:3.12.14` | 1 | ≈ 1,217 MB (405 MB) |
| B — single-stage, slim base | `python:3.12.14-slim` | 1 | ≈ 175 MB (48.5 MB) |
| C — my `Dockerfile` | `python:3.12.14-slim` | 2 | ≈ 179 MB (49.1 MB) |

| Step | Saves | What left the image |
|:--|--:|:--|
| A → B | ≈ 1,042 MB | Compilers, development headers and tools (gcc, g++, imagemagick, git, etc.) from the full base image's `apt-get install` layers, and a larger Debian base layer |
| B → C | ≈ −4 MB (C is bigger) | Nothing significant; C gained a second copy of pip inside `/opt/venv` |

Evidence (full output in `evidence/b1-sizes.txt` and `evidence/b1-site-packages.txt`):

```
IMAGE       ID             DISK USAGE   CONTENT SIZE   EXTRA
cc-demo:a   d2a54a60a9ca       1.62GB          405MB
cc-demo:b   bd2d89035528        223MB         48.5MB
cc-demo:c   0d7938084e70        228MB         49.1MB   U
```

TODO — attribute each of the two differences. Which one did more work, and what is
physically in the layers that disappeared at each step?

A-B:        there is a difference of 1042mb because a uses python and not python-slim. But this is wasted as even though they are still part of the image, so they are stored and downloaded every time, the Flask app never uses them when it runs because it only needs Python and Flask.

B-C:        The base layer is the same. The only difference is that C has pip twice which makes it heavier with no additional benefits. this is a difference of 4mb.

Multi-stage did not help here because the builder stage had nothing big to leave behind: installing Flask needs no compilers or build tools. So A→B saved much more (about 1,042 MB) than B→C, which saved nothing.


TODO — now generalise. Describe an application where the B → C saving would be far larger
than it is here, and say what about that application makes the difference.


In a case where a dependency is being installed that needs to be compiled every time you create a new image, rather than using a binary, it will have to also use the compiler tools like GCC. Those ones are going to create the actual size difference, not the app or the dependency itself that it's using. An example of this would be a Flask app that utilizes PostgreSQL through psycopg2.


### B2 — changing one line of source

TODO — say which line you changed. Paste the build output. Name the layers that were
rebuilt and the ones that came from cache, and explain why, referring to the **order of
instructions** in your Dockerfile.

```
TODO
```

### B3 — making the cache worse

TODO — show the reordered Dockerfile, paste the build output next to the output from B2,
and state the rule you broke in one sentence.

```
TODO
```

## Part C — Azure

The `az` commands you actually ran, in order:

```bash
TODO
```

Which value you passed as a **secure** environment variable, and how you know it is not
readable afterwards:

TODO

Evidence: see `evidence/` — the checklist in `evidence/README.md` says what to capture.
Replace that file with a short index of what you actually captured.

## Before this went to production

TODO — a short, specific paragraph. Not a list of everything you have ever heard about
production. Pick the two or three things that would actually bite this application first,
and say why.

## AI use

TODO — which tools, for what. Required by the course AI policy; acknowledging use does not
affect your grade. Write "None" if you used none.

## Sources

TODO — anything non-trivial you did not write yourself.
