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

| Build | Base | Stages | Size |
|:--|:--|--:|--:|
| A — single-stage, full base | `python:3.12` | 1 | TODO |
| B — single-stage, slim base | | 1 | TODO |
| C — your `Dockerfile` | | | TODO |

| Step | Saves | What left the image |
|:--|--:|:--|
| A → B | TODO | TODO |
| B → C | TODO | TODO |

Evidence:

```
TODO — paste the output of your own docker image ls / docker history
```

TODO — attribute each of the two differences. Which one did more work, and what is
physically in the layers that disappeared at each step?

TODO — now generalise. Describe an application where the B → C saving would be far larger
than it is here, and say what about that application makes the difference.

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
