# Notes

- Add this to your `~/.bashrc` to ensure your `~/.bashrc.private` is sourced if
  it exists.
- If available, use `$XDG_CONFIG_HOME/bash/bashrc` instead of
  `~/.bashrc.private` to avoid cluttering your home directory.

```bash
### Custom additions to default .bashrc (usually from /etc/skel/.bashrc)
if [ -f ~/.bashrc.private ]; then
    . "$HOME/.bashrc.private"
fi
```
