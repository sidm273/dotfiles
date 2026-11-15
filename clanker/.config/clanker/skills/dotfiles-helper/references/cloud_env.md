## Agent instructions: using GitHub

Before using `gh`, Verify authentication

```sh
sh docs/misc/scripts/test_cloud_gh_pat.sh
```

If unsuccesful, guide the user with [Setup](#Setup).

- Never print or persist the credential binding or ask for the PAT in chat. Have
  the human enter it in environment settings.
- Treat permission denials as potentially intentional. Report the denied
  operation; do not expand permissions automatically.
- This setup covers GitHub API requests to `api.github.com`. It does not
  establish HTTPS Git push access through `github.com`.

## Setup

- Refer [Github PAT Setup](./github_pat_setup.md)
- In the cloud environment settings for your provider, add an HTTP secret with
  following information/scope. The format is representative and the keys might
  differ between providers. Help the user with exact steps after consulting the
  documentation.

```toml
name = ZID_GH_PROXY_PAT
value = "<paste_your_github_PAT_here>"
scope = "Personal" # use this when sharing environment within an enterprise.
allowed_domains = ["api.github.com"]
```

- Re-verify authentication after setup. The command should print the GitHub
  account name.

### Security

- Clarify the security scope of the above setup.
- The HTTP secret exposes an environment variable containing a placeholder. The
  proxy substitutes the real PAT for matching HTTPS requests to the configured
  destination.
- Destination scope controls where the credential can be sent. PAT permissions
  control which GitHub operations it can perform.
