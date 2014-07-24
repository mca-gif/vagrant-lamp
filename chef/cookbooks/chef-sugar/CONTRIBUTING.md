Contributing to Chef Sugar
===============================
The process for contributing to Chef sugar is rather straight-forward. It is unlikely that you'll need to modify the actual Chef recipe, so it's assumed that you want to work on the Gem itself.

1. Fork the repository on GitHub.
2. Clone your fork.
3. Create a new, semantically-named branch:

        $ git checkout -b my_feature_branch

4. Make any changes, ensuring you write adequate test coverage.
5. Document your changes (YARD).
6. Run the tests (make sure they pass).
7. Submit a Pull Request on GitHub.
8. (optional) Ping me on Twitter (@sethvargo)

Additionally, please **DO NOT**:
- Modify the version of the cookbook or gem.
- Update the CHANGELOG
- Make unnecessary changes to the gemspec
