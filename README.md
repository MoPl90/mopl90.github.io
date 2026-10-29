# mopl90.github.io

Personal website of Moritz Platscher: <https://mopl90.github.io>

Built with Jekyll on GitHub Pages, based on [modern-resume-theme](https://github.com/sproogen/modern-resume-theme) (MIT, see `LICENSE`).

## Preview locally

Needs Ruby 3.x (`github-pages` doesn't support Ruby 4 yet).

    bundle install
    bundle exec jekyll serve --drafts

## Posts

- Drafts live in `_drafts/` and aren't tracked by git (see `.gitignore`), so they stay local. To publish one, move it to `_posts/YYYY-MM-DD-<slug>.md` and commit it.
- Images go in `assets/img/posts/<slug>/`. Run `scripts/optimize-images.sh` on the folder first.
- Tags are defined in `_data/tags.yml`.
