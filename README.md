# My Homebrew Tap

A custom Homebrew tap for personal/third-party macOS applications and tools.

## Available Casks

* [**Alacritty**](https://github.com/alacritty/alacritty/) (`alacritty`): GPU-accelerated terminal emulator.
* [**Radicle**](https://radicle.dev/) (`radicle-desktop`): Desktop client for the Radicle peer-to-peer code collaboration network.
* [**MarkText**](https://github.com/marktext/marktext) (`mark-text`): Markdown Editor

---

## Installation

Because third-party Homebrew taps run custom package code on your system, Homebrew's security policy requires you to explicitly trust the tap before installing from it.

### Step 1: Tap and Trust the Repository
Run the following commands to add the tap and authorize it on your machine:

```bash
brew tap justsrc/tap
brew trust justsrc/tap
```

### Step 2: Install a Cask

Once the tap is trusted, you can install the application natively:

```bash
brew install --cask <cask-name>
```

### Alternatively,

If you prefer to install it immediately using a fully-qualified name without tapping first, Homebrew will prompt you for trust dynamically:

```bash
brew install --cask justsrc/tap/<cask-name>
```

### Via Brewfile

If you manage your software setup via a `Brewfile` using `brew bundle`, add these lines:

```ruby
tap "justsrc/tap"
cask "<cask-name>"
```

*(Note: If running automated bundles, you may need to execute `brew trust justsrc/tap` prior to running `brew bundle` to prevent the installer from skipping it).*

---

## Trusting Unnotarized Apps (Gatekeeper Bypass)

Some apps do not go through Apple's official App Store notarization.

My cask configuration automatically strips the macOS quarantine flag for such unnotarized apps during installation. However, if macOS Gatekeeper still blocks the app from launching with an "unverified developer" warning, you can easily bypass it:

1. Open your `/Applications` folder in Finder.
2. **Right-click** (or `Control` + click) the application icon.
3. Select **Open** from the context menu.
4. Click **Open** again on the security confirmation dialog. (You will only need to do this once).

OR

You can clear the quarantine attribute via the terminal:

```zsh
xattr -rd com.apple.quarantine /Applications/<AppName>.app
```

---

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
