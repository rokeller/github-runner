# GitHub Actions Runner

The scripts in this repository help to both create a container image for a
Runner for GitHub, as well as running it.

## Create runner image

In order to create an image for the runner, run the `make-image.sh` script. For
example:

```bash
./make-image.sh
```

By default, this will build an image for the latest release from GitHub. You can
override this by passing a different version as the first and only argument:

```bash
./make-image.sh v2.317.0
```

There are no checks to see if the given version actually exists. If it doesn't,
making the image fails.

Please note though that usually that is somewhat futile, since a runner, when
running, typically updates itself to the latest version, so using an older
version just causes more work.

## Running

Run the image to create a local runner and make it available for consumption
from workflows for a GitHub repository as follows.

First off, you will need to get a personal access token to pass to the runner
in order to let it connect to GitHub. This token should have permissions to
read the user/organization and its projects. Put this token into an environment
variable called `GH_TOKEN`.

You'll also need to tell the runner which user/organization (i.e. which owner)
to connect to. Put this into the `GH_OWNER` environment variable.

And last but not least, you need to let the runner know which repo you want it
to connect to. Pass the name of the repo as the only argument to the `run.sh`
script.

```bash
GH_TOKEN=my-token GH_OWNER=rokeller ./run.sh github-runner
```

The script also supports putting the two environment variables in a `.env` file
in the same location as the script, like this:

```env
GH_TOKEN=my-token
GH_OWNER=rokeller
```

The script will automatically add these to the environment for the runner, so
you can just start it like this:

```bash
./run.sh github-runner
```
