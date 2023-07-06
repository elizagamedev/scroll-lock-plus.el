# scroll-lock+.el

When `scroll-lock+-mode` is enabled, certain commands that normally simply move
the point vertically across lines will also scroll the window by the same number
of lines, similar to `scroll-lock-mode`. In other words, the vertical position
of the point relative to the window will remain fixed while navigating up and
down through a buffer.

The key difference between `scroll-lock+-mode` and `scroll-lock-mode` is that
the commands that trigger this behavior in `scroll-lock+-mode` are configurable
via the `scroll-lock+-commands` option instead of being a rigidly defined subset
of navigation commands.

## Installing

This package is not yet available on M?ELPA. In the meantime, you can use
something like [straight.el](https://github.com/radian-software/straight.el) or
[elpaca.el](https://github.com/progfolio/elpaca). Here is an example with elpaca
and [use-package.el](https://github.com/jwiegley/use-package):

```elisp
(use-package scroll-lock+
  :elpaca (:host github :repo "elizagamedev/scroll-lock-plus.el")
  :bind ([remap scroll-lock-mode] #'scroll-lock+-mode))
```
