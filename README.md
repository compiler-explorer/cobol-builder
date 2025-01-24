### COBOL Compiler build scripts

The repository is part of the [Compiler Explorer](https://godbolt.org/) project. It builds
the docker images used to build the Cobol compilers used on the site.

### Example test...

```
$ docker build -t builder -f Dockerfile .; and docker run --rm -it -v/tmp/out:/build builder ./build.sh 1.1 /build
```
