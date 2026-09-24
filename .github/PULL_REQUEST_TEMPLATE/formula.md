---
name: Formula
about: Changes to a formula in Formula/
title: ""
labels: ""
assignees: ""
---

-----

<!-- Do not tick a checkbox if you haven't performed its action. Honesty is indispensable for a smooth review process. -->
<!-- Use [x] to mark item done before creation, or just click the checkboxes with device pointer after creation -->
<!-- In the following questions `<formula>` is the name of the formula you're editing. -->

- [ ] Have you followed the [guidelines for contributing](https://github.com/Homebrew/homebrew-core/blob/HEAD/CONTRIBUTING.md)?
- [ ] Have you ensured that your commits follow the [commit style guide](https://docs.brew.sh/Formula-Cookbook#commit)?
- [ ] Have you checked that there aren't other open [pull requests](https://github.com/justsrc/homebrew-tap/pulls) for the same formula update/change?
- [ ] Have you built your formula locally with `HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source <formula>`?
- [ ] Is your test running fine `brew test <formula>`?
- [ ] Does your build pass `brew audit --strict <formula>` (after doing `HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source <formula>`)? If this is a new formula, does it pass `brew audit --new <formula>`?

**Bottles**

- [ ] I have not committed bottle files (`*.bottle.*.tar.gz`, bottle JSON blobs, or `bottle do`/`sha256 cellar:` stanzas) in this PR.
- [ ] `brew test-bot` builds this formula into a bottle without errors on the runner it targets (see [Bottles](https://docs.brew.sh/Bottles)).
- [ ] For a version or revision bump, the bottle merge happens automatically after merge via the `bottle` / `brew pr-pull` workflow; no `brew bottle --merge --force` commands were run by hand.

-----

- [ ] I did not use AI/LLM to create this PR, or I disclosed the tool/model below and reviewed its output; I did not attribute commits to AI and will answer maintainer questions and review comments myself without AI/LLM.

<!-- If AI was used, explain below how it was used and how you verified the changes. -->

-----